// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/bootstrap/view_model/bootstrap_view_model.dart';
import 'package:fluffychat/pages/bootstrap/widgets/restore_bootstrap_view.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// Simplified bootstrap page for SSO/OIDC fallback.
///
/// For password login: user never sees this page (handled by login.dart).
/// For SSO/OIDC: auto-bootstrap runs silently. Only if it fails does the
/// user see a recovery key input (rare — only when switching to a new device
/// without secure storage access).
class BootstrapPage extends StatelessWidget {
  final bool reset;
  const BootstrapPage({required this.reset, super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      create: () =>
          BootstrapViewModel(client: Matrix.of(context).client, reset: reset),
      builder: (context, viewModel, _) {
        final cryptoIdentityState = viewModel.value.cryptoIdentityState;

        // Auto-redirect to rooms once crypto is connected
        if (cryptoIdentityState?.connected == true && !reset) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => viewModel.goToRoomsPageAfterSuccess(context),
          );
        }

        // Still loading or auto-bootstrap in progress — show spinner only
        if (cryptoIdentityState == null ||
            (!cryptoIdentityState.connected && !cryptoIdentityState.initialized)) {
          return LoginScaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(L10n.of(context).loadingPleaseWait),
            ),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        // Auto-bootstrap succeeded but connected check hasn't triggered yet
        if (cryptoIdentityState.connected && !reset) {
          return LoginScaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(L10n.of(context).loadingPleaseWait),
            ),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        // Fallback: auto-bootstrap failed, need manual recovery key input.
        // This only happens for SSO users on a completely new device without
        // access to their previous secure storage. Rare case.
        return LoginScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: CloseButton(
              onPressed: () => context.go('/rooms'),
            ),
            title: Text(L10n.of(context).restoreCryptoIdentity),
          ),
          body: RestoreBootstrapView(viewModel),
        );
      },
    );
  }
}
