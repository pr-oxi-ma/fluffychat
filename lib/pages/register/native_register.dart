// SPDX-FileCopyrightText: 2024-Present Contributors to FluffyChat Fork
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/auto_crypto_setup.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/disposable_email_checker.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

/// Native in-app registration page with email verification support.
///
/// Handles Tuwunel and standard Matrix UIAA stages:
/// - m.login.dummy (no verification)
/// - m.login.registration_token (token-based registration)
/// - m.login.email.identity (email verification via SMTP)
/// - m.login.terms (terms of service acceptance)
///
/// Also blocks disposable/temporary email addresses client-side and
/// automatically provisions end-to-end encryption with zero user friction.
class NativeRegister extends StatefulWidget {
  final Client client;
  const NativeRegister({required this.client, super.key});

  @override
  NativeRegisterController createState() => NativeRegisterController();
}

enum RegistrationStep { form, emailVerification }

class NativeRegisterController extends State<NativeRegister> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController registrationTokenController =
      TextEditingController();

  String? usernameError;
  String? passwordError;
  String? emailError;
  String? generalError;
  bool loading = false;
  bool showPassword = false;
  bool showTokenField = false;
  bool emailRequired = false;
  bool registrationDisabled = false;
  bool probingServer = false;
  RegistrationStep step = RegistrationStep.form;

  // Email verification state
  String? _uiaaSession;
  String? _emailSid;
  String? _clientSecret;
  Timer? _resendCooldownTimer;
  int _resendCooldownSeconds = 0;

  @override
  void initState() {
    super.initState();
    // 1. Read invite / registration token from URL query params (e.g. ?token=XYZ or ?invite_code=XYZ)
    try {
      final uri = Uri.base;
      String? urlToken = uri.queryParameters['token'] ??
          uri.queryParameters['invite_code'] ??
          uri.queryParameters['invite'];

      if ((urlToken == null || urlToken.isEmpty) && uri.fragment.contains('?')) {
        final fragUri = Uri.tryParse(uri.fragment);
        if (fragUri != null) {
          urlToken = fragUri.queryParameters['token'] ??
              fragUri.queryParameters['invite_code'] ??
              fragUri.queryParameters['invite'];
        }
      }

      if (urlToken != null && urlToken.isNotEmpty) {
        registrationTokenController.text = urlToken;
        showTokenField = true;
      }
    } catch (_) {}

    // 2. Pre-flight probe homeserver registration capabilities
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _probeServerCapabilities();
    });
  }

  /// Probe homeserver dynamically to discover required auth flows on page load
  Future<void> _probeServerCapabilities() async {
    var homeserverUri = widget.client.homeserver;
    if (homeserverUri == null) {
      final defaultHs = AppSettings.defaultHomeserver.value;
      if (defaultHs.isNotEmpty) {
        final parsed = Uri.tryParse(
          defaultHs.startsWith('http') ? defaultHs : 'https://$defaultHs',
        );
        if (parsed != null) {
          widget.client.homeserver = parsed;
          homeserverUri = parsed;
        }
      }
    }
    if (homeserverUri == null) return;

    if (mounted) setState(() => probingServer = true);
    try {
      final registerUri =
          homeserverUri.resolveUri(Uri(path: '/_matrix/client/v3/register'));
      final response = await widget.client.httpClient.post(
        registerUri,
        headers: {'Content-Type': 'application/json'},
        body: '{}',
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawErrcode = data['errcode'] as String?;

      if (response.statusCode == 403 || rawErrcode == 'M_FORBIDDEN') {
        if (mounted) {
          setState(() {
            registrationDisabled = true;
            generalError = data['error'] as String? ??
                'Registration is currently disabled on this server';
            probingServer = false;
          });
        }
        return;
      }

      final flows = data['flows'] as List<dynamic>?;
      if (flows != null) {
        final allStages = flows
            .expand((f) =>
                ((f as Map<String, dynamic>)['stages'] as List<dynamic>))
            .toSet();

        final hasDummyFlow = flows.any((f) {
          final stages =
              (f as Map<String, dynamic>)['stages'] as List<dynamic>;
          return stages.length == 1 && stages.first == 'm.login.dummy';
        });

        final needsToken = allStages.contains('m.login.registration_token');
        final needsEmail = allStages.contains('m.login.email.identity');

        if (mounted) {
          setState(() {
            _uiaaSession = data['session'] as String?;
            if (needsToken && !hasDummyFlow) {
              showTokenField = true;
            }
            if (needsEmail && !hasDummyFlow) {
              emailRequired = true;
            }
            probingServer = false;
          });
        }
      }
    } catch (e) {
      Logs().w('Could not pre-probe server capabilities: $e');
      if (mounted) {
        setState(() => probingServer = false);
      }
    }
  }

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  /// Step 1: Submit registration form
  Future<void> register() async {
    final l10n = L10n.of(context);

    setState(() {
      usernameError = null;
      passwordError = null;
      emailError = null;
      generalError = null;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final email = emailController.text.trim();
    final token = registrationTokenController.text.trim();

    // Validation
    if (username.isEmpty) {
      return setState(() => usernameError = l10n.pleaseEnterYourUsername);
    }
    final validUsernameRegex = RegExp(r'^[a-z0-9._=\-/]+$');
    if (!validUsernameRegex.hasMatch(username.toLowerCase())) {
      return setState(() => usernameError =
          'Username may only contain letters, numbers, and .-_');
    }
    if (password.isEmpty) {
      return setState(() => passwordError = l10n.pleaseEnterYourPassword);
    }
    if (password.length < 8) {
      return setState(() =>
          passwordError = 'Password must be at least 8 characters');
    }
    if (password != confirmPassword) {
      return setState(() => passwordError = l10n.passwordsDoNotMatch);
    }

    if (showTokenField && token.isEmpty) {
      return setState(
          () => generalError = 'Invite code is required to register on this server');
    }

    // Email validation (only if required by server)
    if (emailRequired) {
      if (email.isEmpty) {
        return setState(() => emailError = 'Email is required');
      }
      if (!RegExp(r'^.+@.+\..+$').hasMatch(email)) {
        return setState(() => emailError = 'Invalid email address');
      }

      setState(() => loading = true);

      final isTempMail = await DisposableEmailChecker.isDisposable(email);
      if (isTempMail) {
        return setState(() {
          emailError = 'Temporary/disposable emails are not allowed';
          loading = false;
        });
      }
    } else {
      setState(() => loading = true);
    }

    try {
      final client = widget.client;

      // Build auth payload if we already have session or token
      AuthenticationData? initialAuth;
      if (token.isNotEmpty) {
        initialAuth = AuthenticationData.fromJson({
          'type': 'm.login.registration_token',
          if (_uiaaSession != null) 'session': _uiaaSession,
          'token': token,
        });
      } else {
        initialAuth = AuthenticationData.fromJson({
          'type': 'm.login.dummy',
          if (_uiaaSession != null) 'session': _uiaaSession,
        });
      }

      // Initial register call
      try {
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
          auth: initialAuth,
        );
        // If it succeeds directly without further UIAA, finish setup
        await _finishRegistration(username, password);
        return;
      } on MatrixException catch (e) {
        // Parse UIAA 401 response first before checking error codes
        _uiaaSession = e.session ?? e.raw['session'] as String?;
        final flows = e.raw['flows'] as List?;

        if (_uiaaSession != null && flows != null) {
          final allFlowStages = flows
              .map((f) =>
                  List<String>.from((f as Map)['stages'] as List))
              .toList();

          final hasDummyFlow = allFlowStages.any((stages) =>
              stages.length == 1 && stages.first == 'm.login.dummy');

          final allStages = allFlowStages.expand((s) => s).toSet();
          final needsToken =
              allStages.contains('m.login.registration_token');
          final needsEmail = allStages.contains('m.login.email.identity');
          final needsTerms = allStages.contains('m.login.terms');

          // Registration token check
          if (needsToken && token.isEmpty && !hasDummyFlow) {
            return setState(() {
              showTokenField = true;
              loading = false;
              generalError = 'This server requires an invite code';
            });
          }

          // Email verification check
          if (needsEmail && email.isEmpty && !hasDummyFlow) {
            return setState(() {
              emailRequired = true;
              loading = false;
              generalError = 'This server requires email verification';
            });
          }

          // Submit token if required
          if (needsToken && token.isNotEmpty) {
            try {
              await client.register(
                username: username,
                password: password,
                initialDeviceDisplayName: PlatformInfos.appDisplayName,
                auth: AuthenticationData.fromJson({
                  'type': 'm.login.registration_token',
                  'session': _uiaaSession,
                  'token': token,
                }),
              );
              await _finishRegistration(username, password);
              return;
            } on MatrixException catch (subE) {
              _uiaaSession =
                  subE.session ?? subE.raw['session'] as String? ?? _uiaaSession;
            }
          }

          // If email verification needed
          if (needsEmail && email.isNotEmpty) {
            await _startEmailVerification(email, username, password);
            return;
          }

          // If terms acceptance needed
          if (needsTerms) {
            try {
              await client.register(
                username: username,
                password: password,
                initialDeviceDisplayName: PlatformInfos.appDisplayName,
                auth: AuthenticationData.fromJson({
                  'type': 'm.login.terms',
                  'session': _uiaaSession,
                }),
              );
              await _finishRegistration(username, password);
              return;
            } on MatrixException catch (termsE) {
              _uiaaSession =
                  termsE.session ?? termsE.raw['session'] as String? ?? _uiaaSession;
            }
          }

          // Default: dummy stage
          await _completeDummyStage(username, password);
          return;
        }

        final rawErrcode = e.raw['errcode'] as String?;
        if (rawErrcode == 'M_USER_IN_USE') {
          return setState(() {
            usernameError = 'Username is already taken';
            loading = false;
          });
        }
        if (rawErrcode == 'M_INVALID_USERNAME') {
          return setState(() {
            usernameError = 'Invalid username for this server';
            loading = false;
          });
        }
        if (rawErrcode == 'M_WEAK_PASSWORD') {
          return setState(() {
            passwordError = 'Password is too weak for this server';
            loading = false;
          });
        }
        if (rawErrcode == 'M_FORBIDDEN') {
          return setState(() {
            generalError = e.errorMessage.isNotEmpty
                ? e.errorMessage
                : 'Registration is disabled on this server';
            loading = false;
          });
        }
        if (rawErrcode == 'M_THREEPID_IN_USE') {
          return setState(() {
            emailError = 'This email is already registered';
            loading = false;
          });
        }

        rethrow;
      }
    } on MatrixException catch (e) {
      setState(() {
        generalError = e.errorMessage.isNotEmpty
            ? e.errorMessage
            : 'Registration failed (${e.error})';
        loading = false;
      });
    } catch (e) {
      setState(() {
        generalError = e.toLocalizedString(context);
        loading = false;
      });
    }
  }

  /// Complete dummy UIAA stage
  Future<void> _completeDummyStage(String username, String password) async {
    final client = widget.client;
    try {
      await client.register(
        username: username,
        password: password,
        initialDeviceDisplayName: PlatformInfos.appDisplayName,
        auth: AuthenticationData.fromJson({
          'type': 'm.login.dummy',
          if (_uiaaSession != null) 'session': _uiaaSession,
        }),
      );
      await _finishRegistration(username, password);
    } on MatrixException catch (e) {
      final rawErrcode = e.raw['errcode'] as String?;
      if (rawErrcode == 'M_USER_IN_USE') {
        setState(() {
          usernameError = 'Username is already taken';
          loading = false;
        });
        return;
      }
      if (rawErrcode == 'M_INVALID_USERNAME') {
        setState(() {
          usernameError = 'Invalid username for this server';
          loading = false;
        });
        return;
      }
      if (rawErrcode == 'M_WEAK_PASSWORD') {
        setState(() {
          passwordError = 'Password is too weak for this server';
          loading = false;
        });
        return;
      }
      rethrow;
    }
  }

  /// Start email verification: request token via SMTP
  Future<void> _startEmailVerification(
      String email, String username, String password) async {
    final client = widget.client;
    _clientSecret =
        'fc_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

    try {
      final response = await client.requestTokenToRegisterEmail(
        _clientSecret!,
        email,
        1,
      );
      _emailSid = response.sid;

      _startResendCooldown();

      setState(() {
        step = RegistrationStep.emailVerification;
        loading = false;
      });
    } on MatrixException catch (e) {
      if (e.error == MatrixError.M_THREEPID_IN_USE) {
        setState(() {
          emailError = 'This email is already registered';
          loading = false;
        });
      } else {
        setState(() {
          generalError = e.errorMessage;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        generalError = e.toLocalizedString(context);
        loading = false;
      });
    }
  }

  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    _resendCooldownSeconds = 30;
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCooldownSeconds > 0) {
        setState(() => _resendCooldownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  /// Resend verification email
  Future<void> resendVerificationEmail() async {
    if (_resendCooldownSeconds > 0 || loading) return;
    setState(() => loading = true);
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    await _startEmailVerification(email, username, password);
  }

  /// Step 2: User clicked "I've verified my email"
  Future<void> confirmEmailVerification() async {
    setState(() => loading = true);

    final username = usernameController.text.trim();
    final password = passwordController.text;

    try {
      final client = widget.client;

      final auth = {
        'type': 'm.login.email.identity',
        'session': _uiaaSession,
        'threepid_creds': {
          'sid': _emailSid,
          'client_secret': _clientSecret,
        },
      };

      try {
        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
          auth: AuthenticationData.fromJson(auth),
        );
        await _finishRegistration(username, password);
        return;
      } on MatrixException catch (e) {
        // If dummy stage is required after email
        final nextSession = e.session ?? e.raw['session'] as String? ?? _uiaaSession;
        if (nextSession != null) {
          try {
            await client.register(
              username: username,
              password: password,
              initialDeviceDisplayName: PlatformInfos.appDisplayName,
              auth: AuthenticationData.fromJson({
                'type': 'm.login.dummy',
                'session': nextSession,
              }),
            );
            await _finishRegistration(username, password);
            return;
          } catch (_) {
            rethrow;
          }
        }
        rethrow;
      }
    } on MatrixException catch (e) {
      setState(() {
        generalError = e.errorMessage.isNotEmpty
            ? e.errorMessage
            : 'Email verification pending. Please verify via the link in your email and try again.';
        loading = false;
      });
    } catch (e) {
      setState(() {
        generalError = e.toLocalizedString(context);
        loading = false;
      });
    }
  }

  /// Final step: login + silent auto-crypto setup + navigate to rooms
  Future<void> _finishRegistration(String username, String password) async {
    final matrix = Matrix.of(context);
    final client = widget.client;

    if (!client.isLogged()) {
      await client.login(
        LoginType.mLoginPassword,
        identifier: AuthenticationUserIdentifier(user: username),
        password: password,
        initialDeviceDisplayName: PlatformInfos.appDisplayName,
      );
    }

    // Cache password for UIA requests
    matrix.cachedPassword = password;

    if (!matrix.widget.clients.contains(client)) {
      matrix.widget.clients.add(client);
    }
    await ClientManager.addClientNameToStore(client.clientName, matrix.store);
    matrix.setActiveClient(client);

    // ProtonMail-style: silent auto-crypto vault initialization (non-blocking)
    unawaited(AutoCryptoSetup.setup(client, password: password));

    // Save default homeserver
    if (client.homeserver != null) {
      await AppSettings.defaultHomeserver.setItem(client.homeserver!.host);
    }

    if (mounted) {
      context.go('/rooms');
    }
  }

  @override
  void dispose() {
    _resendCooldownTimer?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    registrationTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    final homeserverHost = widget.client.homeserver?.host ?? 'Matrix';

    return LoginScaffold(
      appBar: AppBar(
        leading: loading
            ? null
            : BackButton(onPressed: () => Navigator.of(context).pop()),
        automaticallyImplyLeading: !loading,
        title: Text(l10n.createNewAccount),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: step == RegistrationStep.emailVerification
                    ? _buildEmailVerificationView(theme, l10n)
                    : _buildRegistrationForm(theme, l10n, homeserverHost),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailVerificationView(ThemeData theme, L10n l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 44,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Check your email',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'We sent a verification link to:\n${emailController.text}',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Click the link in the message, then tap the button below to finish.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        if (generalError != null)
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.onErrorContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    generalError!,
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: loading ? null : confirmEmailVerification,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "I've verified my email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _resendCooldownSeconds > 0 || loading
                  ? null
                  : resendVerificationEmail,
              child: Text(
                _resendCooldownSeconds > 0
                    ? 'Resend in ${_resendCooldownSeconds}s'
                    : 'Resend email',
              ),
            ),
            const Text('•'),
            TextButton(
              onPressed: loading
                  ? null
                  : () => setState(() {
                        step = RegistrationStep.form;
                        generalError = null;
                      }),
              child: const Text('Back to form'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(
      ThemeData theme, L10n l10n, String homeserverHost) {
    if (registrationDisabled) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_person_outlined,
                size: 38,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Registration Closed',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            generalError ?? 'Registration is currently disabled on $homeserverHost.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Login'),
          ),
        ],
      );
    }

    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (probingServer) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 12),
          ],

          // Logo
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                './assets/logo/mini/logo_mini.png',
                width: 68,
                height: 68,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Subtitle
          Text(
            l10n.createNewAccount,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create your private account on $homeserverHost',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // General Error Banner
          if (generalError != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      generalError!,
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Username
          TextField(
            controller: usernameController,
            autofillHints: loading ? null : [AutofillHints.newUsername],
            readOnly: loading,
            autocorrect: false,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outlined),
              labelText: 'Username',
              hintText: 'e.g. alice',
              helperText: 'Only lowercase letters, numbers, and .-_',
              errorText: usernameError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Email (only if required by server)
          if (emailRequired) ...[
            TextField(
              controller: emailController,
              autofillHints: loading ? null : [AutofillHints.email],
              readOnly: loading,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email *',
                helperText: 'Required by server for verification',
                errorText: emailError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Password
          TextField(
            controller: passwordController,
            autofillHints: loading ? null : [AutofillHints.newPassword],
            readOnly: loading,
            obscureText: !showPassword,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outlined),
              labelText: l10n.password,
              errorText: passwordError,
              helperText: 'Minimum 8 characters',
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: toggleShowPassword,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Confirm password
          TextField(
            controller: confirmPasswordController,
            readOnly: loading,
            obscureText: !showPassword,
            textInputAction: showTokenField
                ? TextInputAction.next
                : TextInputAction.done,
            onSubmitted: (_) {
              if (!showTokenField) register();
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outlined),
              labelText: l10n.repeatPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: toggleShowPassword,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Registration token / Invite Code (if required)
          if (showTokenField) ...[
            TextField(
              controller: registrationTokenController,
              readOnly: loading,
              autocorrect: false,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => register(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                labelText: 'Invite Code',
                hintText: 'e.g. matrix',
                helperText: 'Enter your invite code to create an account',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Register button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: loading ? null : register,
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    l10n.createNewAccount,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Already have account -> Log in
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        final currentLoc =
                            GoRouterState.of(context).matchedLocation;
                        final isAddAccount = currentLoc.contains('addaccount');
                        final loginRoute = isAddAccount
                            ? '/rooms/settings/addaccount/login'
                            : '/home/login';
                        context.push(
                          loginRoute,
                          extra: widget.client,
                        );
                      },
                child: Text(l10n.login),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
