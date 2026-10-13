// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sign_in_flows/oidc_login.dart';
import 'package:fluffychat/utils/sign_in_flows/sso_login.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

Future<void> connectToHomeserverFlow(
  PublicHomeserverData homeserverData,
  BuildContext context,
  void Function(AsyncSnapshot<bool>) setState,
  bool signUp,
) async {
  setState(AsyncSnapshot.waiting());
  try {
    final homeserverInput = homeserverData.name!;
    var homeserver = Uri.parse(homeserverInput);
    if (homeserver.scheme.isEmpty) {
      homeserver = Uri.https(homeserverInput, '');
    }
    final l10n = L10n.of(context);
    final client = await Matrix.of(context).getLoginClient();
    final (_, _, loginFlows, authMetadata) = await client.checkHomeserver(
      homeserver,
      fetchAuthMetadata: true,
    );

    final supportsPassword =
        loginFlows.any((flow) => flow.type == 'm.login.password');
    final supportsSso = loginFlows.any((flow) => flow.type == 'm.login.sso');

    final currentPath = GoRouterState.of(context).uri.path;
    final basePath = currentPath.contains('addaccount') || currentPath.startsWith('/rooms')
        ? '/rooms/settings/addaccount'
        : '/home';

    if (signUp && AppConfig.enableNativeInAppRegistration) {
      // 100% Native In-App Registration inside FluffyChat
      if (!context.mounted) return;
      context.push('$basePath/register', extra: client);
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
      return;
    }

    if (!signUp &&
        AppConfig.enableNativeInAppRegistration &&
        supportsPassword) {
      // 100% Native In-App Login inside FluffyChat
      if (!context.mounted) return;
      context.push('$basePath/login', extra: client);
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
      return;
    }

    final ssoFlow =
        loginFlows.where((flow) => flow.type == 'm.login.sso').firstOrNull;
    final ssoProviders =
        (ssoFlow?.additionalProperties['identity_providers'] as List?);
    final hasSsoProviders = ssoProviders != null && ssoProviders.isNotEmpty;

    if ((kIsWeb || PlatformInfos.isLinux) &&
        ((supportsSso && hasSsoProviders) || authMetadata != null)) {
      if (!context.mounted) return;
      final consent = await showOkCancelAlertDialog(
        context: context,
        title: l10n.appWantsToUseForLogin(homeserverInput),
        message: l10n.appWantsToUseForLoginDescription,
        okLabel: l10n.continueText,
      );
      if (consent != OkCancelResult.ok) return;
      if (!context.mounted) return;
    }
    if (!context.mounted) return;

    if (authMetadata != null && AppSettings.enableMatrixNativeOIDC.value) {
      await oidcLoginFlow(client, context, signUp);
    } else if (supportsSso && hasSsoProviders) {
      await ssoLoginFlow(client, context, signUp, loginFlows);
    } else {
      if (!context.mounted) return;
      context.push('$basePath/login', extra: client);
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
      return;
    }

    await AppSettings.defaultHomeserver.setItem(homeserverInput);

    if (context.mounted) {
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
      context.go('/backup');
    }
  } catch (e, s) {
    Logs().w('Unable to login', e, s);
    setState(AsyncSnapshot.withError(ConnectionState.done, e, s));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toLocalizedString(context, ExceptionContext.checkHomeserver),
        ),
      ),
    );
  }
}
