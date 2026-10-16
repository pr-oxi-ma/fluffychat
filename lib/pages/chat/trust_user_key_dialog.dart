// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';
import 'package:matrix/matrix.dart';

Future<bool> showTrustUserInRoomDialog(BuildContext context, Room room) async {
  // Seamless messaging like Telegram & WhatsApp: automatic trust-on-first-use, no blocking popups
  if (room.encrypted) {
    try {
      final users = await room.requestParticipants();
      for (final user in users) {
        if (user.id != room.client.userID) {
          room.client.userDeviceKeys[user.id]?.masterKey?.trustOnFirstUse();
        }
      }
    } catch (_) {}
  }
  return true;
}

enum _Action { allow, deny, verification }
