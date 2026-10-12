// SPDX-FileCopyrightText: 2026 FluffyChat Contributors
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class EmailVerificationDialog extends StatefulWidget {
  final Client client;
  final String email;
  final String initialSid;
  final String initialClientSecret;
  final Uri homeserverUri;

  const EmailVerificationDialog({
    required this.client,
    required this.email,
    required this.initialSid,
    required this.initialClientSecret,
    required this.homeserverUri,
    super.key,
  });

  static Future<Map<String, String>?> show({
    required BuildContext context,
    required Client client,
    required String email,
    required String initialSid,
    required String initialClientSecret,
    required Uri homeserverUri,
  }) {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmailVerificationDialog(
        client: client,
        email: email,
        initialSid: initialSid,
        initialClientSecret: initialClientSecret,
        homeserverUri: homeserverUri,
      ),
    );
  }

  @override
  State<EmailVerificationDialog> createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late String _currentSid;
  late String _currentClientSecret;

  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  Timer? _countdownTimer;
  int _secondsRemaining = 30;
  bool get _canResend => _secondsRemaining <= 0;

  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _currentSid = widget.initialSid;
    _currentClientSecret = widget.initialClientSecret;
    _startCountdown();
    _startBackgroundPolling();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 30);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void _startBackgroundPolling() {
    _pollingTimer?.cancel();
    // In case the user clicks the link in their email while looking at this dialog
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted || _isVerifying) return;
      try {
        final uri = widget.homeserverUri.resolve('/_matrix/client/v3/register/email/checkStatus');
        final resp = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'sid': _currentSid,
          }),
        );
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);
          if (data['validated'] == true && mounted) {
            timer.cancel();
            Navigator.of(context).pop({
              'sid': _currentSid,
              'clientSecret': _currentClientSecret,
            });
          }
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollingTimer?.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit code');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final uri = widget.homeserverUri.resolve('/_matrix/client/v3/register/email/submitCode');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': code,
          'sid': _currentSid,
          'client_secret': _currentClientSecret,
        }),
      );

      final data = jsonDecode(resp.body);
      if (resp.statusCode == 200 && data['success'] == true) {
        _pollingTimer?.cancel();
        if (mounted) {
          Navigator.of(context).pop({
            'sid': data['sid'] ?? _currentSid,
            'clientSecret': data['client_secret'] ?? _currentClientSecret,
          });
        }
      } else {
        setState(() {
          _errorMessage = data['error'] ?? 'Incorrect verification code. Please try again.';
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: Unable to verify code. Please check your connection.';
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final newClientSecret = DateTime.now().millisecondsSinceEpoch.toString();
      final tokenResponse = await widget.client.requestTokenToRegisterEmail(
        newClientSecret,
        widget.email,
        1,
      );

      if (mounted) {
        setState(() {
          _currentSid = tokenResponse.sid;
          _currentClientSecret = newClientSecret;
          _isResending = false;
          _codeController.clear();
        });
        _startCountdown();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A new 6-digit code has been sent to ${widget.email}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to resend code. Please wait a moment and try again.';
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      backgroundColor: theme.scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Security Shield Emblem
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.tertiary.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mark_email_read_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit security code to\n'),
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 6-digit Code Input Box
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _errorMessage != null
                        ? colorScheme.error
                        : colorScheme.outlineVariant.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  controller: _codeController,
                  focusNode: _focusNode,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 12.0,
                    fontFamily: 'monospace',
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '······',
                    hintStyle: TextStyle(
                      letterSpacing: 12.0,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (val) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                    if (val.length == 6) {
                      _submitCode();
                    }
                  },
                  onSubmitted: (_) => _submitCode(),
                ),
              ),

              // Error Message Banner
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, size: 18, color: colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Primary Action Button: Verify & Continue
              FilledButton(
                onPressed: _isVerifying ? null : _submitCode,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isVerifying
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text(
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Resend Code / Countdown Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  if (_canResend)
                    TextButton(
                      onPressed: _isResending ? null : _resendCode,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: _isResending
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Resend Code',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    )
                  else
                    Text(
                      'Resend in ${_secondsRemaining}s',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Cancel / Change Email Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Change Email or Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
