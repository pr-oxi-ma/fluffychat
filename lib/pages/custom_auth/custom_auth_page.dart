// SPDX-FileCopyrightText: 2026 Proxima
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/auto_crypto_vault.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class CustomAuthPage extends StatefulWidget {
  final bool initialSignUp;
  const CustomAuthPage({super.key, this.initialSignUp = false});

  @override
  State<CustomAuthPage> createState() => _CustomAuthPageState();
}

class _CustomAuthPageState extends State<CustomAuthPage> {
  late bool isSignUp;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _homeserverController = TextEditingController();

  bool _loading = false;
  String? _loadingStatus;
  bool _showPassword = false;
  bool _showAdvancedServer = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    isSignUp = widget.initialSignUp;
    final preset = AppSettings.presetHomeserver.value;
    _homeserverController.text =
        preset.isNotEmpty ? preset : AppConfig.defaultHomeserverUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _inviteCodeController.dispose();
    _homeserverController.dispose();
    super.dispose();
  }

  void _toggleShowPassword() {
    setState(() => _showPassword = !_showPassword);
  }

  Uri _resolveHomeserverUri(String rawInput) {
    var text = rawInput.trim();
    if (text.isEmpty) {
      text = AppConfig.defaultHomeserverUrl;
    }
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      text = 'https://$text';
    }
    return Uri.parse(text);
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final inviteCode = _inviteCodeController.text.trim();

    if (username.isEmpty) {
      setState(() => _errorMessage = 'Please enter a username');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter a password');
      return;
    }

    if (isSignUp) {
      if (password.length < 8) {
        setState(() => _errorMessage = 'Password must be at least 8 characters');
        return;
      }
      if (password != _confirmPasswordController.text) {
        setState(() => _errorMessage = 'Passwords do not match');
        return;
      }
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _loadingStatus = isSignUp ? 'Creating account...' : 'Connecting to server...';
    });

    try {
      final matrix = Matrix.of(context);
      final client = await matrix.getLoginClient();

      final homeserverUri = _resolveHomeserverUri(_homeserverController.text);
      await client.checkHomeserver(homeserverUri);

      if (isSignUp) {
        setState(() => _loadingStatus = 'Registering user...');
        final authData = inviteCode.isNotEmpty
            ? AuthenticationData(
                type: 'm.login.registration_token',
                additionalFields: {'token': inviteCode},
              )
            : null;

        await client.register(
          username: username,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
          auth: authData,
        );
      } else {
        setState(() => _loadingStatus = 'Authenticating...');
        AuthenticationIdentifier identifier;
        if (username.contains('@') && username.contains('.')) {
          identifier = AuthenticationThirdPartyIdentifier(
            medium: 'email',
            address: username,
          );
        } else {
          identifier = AuthenticationUserIdentifier(user: username);
        }

        await client.login(
          LoginType.mLoginPassword,
          identifier: identifier,
          password: password,
          initialDeviceDisplayName: PlatformInfos.appDisplayName,
        );
      }

      // Automatically initialize or restore deterministic SSSS key backup & auto-verify device
      setState(() => _loadingStatus = 'Securing session & restoring keys...');
      await AutoCryptoVault.setupOrRestore(client, username, password);

      // Save homeserver for next session
      await AppSettings.defaultHomeserver.setItem(homeserverUri.host);

      if (mounted) {
        context.go('/rooms');
      }
    } on MatrixException catch (e) {
      setState(() {
        _errorMessage = e.errorMessage;
        _loading = false;
        _loadingStatus = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
        _loadingStatus = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/logo/mini/logo_mini.png',
                          width: 72,
                          height: 72,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppSettings.applicationName.value,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isSignUp
                          ? 'Create a private, encrypted account'
                          : 'Sign in to your private chat session',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tabs: Login / Sign Up
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _loading
                                  ? null
                                  : () => setState(() {
                                        isSignUp = false;
                                        _errorMessage = null;
                                      }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !isSignUp
                                      ? theme.colorScheme.surface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: !isSignUp
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(13),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: !isSignUp
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: !isSignUp
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: _loading
                                  ? null
                                  : () => setState(() {
                                        isSignUp = true;
                                        _errorMessage = null;
                                      }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSignUp
                                      ? theme.colorScheme.surface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: isSignUp
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(13),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: isSignUp
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSignUp
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Username Field
                    TextField(
                      controller: _usernameController,
                      readOnly: _loading,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'e.g. proxima',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: _passwordController,
                      readOnly: _loading,
                      obscureText: !_showPassword,
                      textInputAction: isSignUp
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onSubmitted: (_) {
                        if (!isSignUp) _submit();
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: _toggleShowPassword,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    if (isSignUp) ...[
                      const SizedBox(height: 16),
                      // Confirm Password Field
                      TextField(
                        controller: _confirmPasswordController,
                        readOnly: _loading,
                        obscureText: !_showPassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Invite Code Field
                      TextField(
                        controller: _inviteCodeController,
                        readOnly: _loading,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Invite Code',
                          hintText: 'Registration token (if required)',
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Collapsible Server Settings
                    InkWell(
                      onTap: () => setState(
                        () => _showAdvancedServer = !_showAdvancedServer,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _showAdvancedServer
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _showAdvancedServer
                                  ? 'Hide Server Options'
                                  : 'Server Settings',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_showAdvancedServer) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _homeserverController,
                        readOnly: _loading,
                        autocorrect: false,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: 'Homeserver URL',
                          prefixIcon: const Icon(Icons.dns_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _loading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _loadingStatus ?? 'Loading...',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            )
                          : Text(
                              isSignUp ? 'Create Account' : 'Sign In',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
