// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_password/settings_password_view.dart';
import 'package:fluffychat/utils/auto_crypto_setup.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

class SettingsPassword extends StatefulWidget {
  const SettingsPassword({super.key});

  @override
  SettingsPasswordController createState() => SettingsPasswordController();
}

class SettingsPasswordController extends State<SettingsPassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPassword1Controller = TextEditingController();
  final TextEditingController newPassword2Controller = TextEditingController();

  String? oldPasswordError;
  String? newPassword1Error;
  String? newPassword2Error;

  bool loading = false;

  Future<void> changePassword() async {
    final l10n = L10n.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    setState(() {
      oldPasswordError = newPassword1Error = newPassword2Error = null;
    });
    if (oldPasswordController.text.isEmpty) {
      setState(() {
        oldPasswordError = L10n.of(context).pleaseEnterYourPassword;
      });
      return;
    }
    if (newPassword1Controller.text.isEmpty ||
        newPassword1Controller.text.length < 6) {
      setState(() {
        newPassword1Error = L10n.of(context).pleaseChooseAStrongPassword;
      });
      return;
    }
    if (newPassword1Controller.text != newPassword2Controller.text) {
      setState(() {
        newPassword2Error = L10n.of(context).passwordsDoNotMatch;
      });
      return;
    }

    setState(() {
      loading = true;
    });
    try {
      final matrix = Matrix.of(context);
      final client = matrix.client;
      final newPass = newPassword1Controller.text;
      await client.changePassword(
        newPass,
        oldPassword: oldPasswordController.text,
      );

      // Update cached password for UIA
      matrix.cachedPassword = newPass;

      // Re-key SSSS seamlessly so that new devices can decrypt without recovery prompts
      try {
        await AutoCryptoSetup.rotatePassword(client, newPassword: newPass);
      } catch (cryptoErr) {
        Logs().w('Non-critical failure rotating SSSS passphrase: $cryptoErr');
      }

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.passwordHasBeenChanged)),
      );
      if (mounted) context.pop();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.error,
          content: Text(
            e.toLocalizedString(context),
            style: TextStyle(color: theme.colorScheme.onError),
          ),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPassword1Controller.dispose();
    newPassword2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SettingsPasswordView(this);
}
