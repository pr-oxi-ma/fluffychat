// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

Future<bool> showTrustUserInRoomDialog(BuildContext context, Room room) async {
  if (!room.encrypted) return true;

  final users = await room.requestParticipants();
  if (!context.mounted) return false;

  users.removeWhere((user) {
    if (user.id == room.client.userID) return true;
    final keys = room.client.userDeviceKeys[user.id];
    final masterKey = keys?.masterKey;

    if (keys == null ||
        masterKey == null ||
        masterKey.verified ||
        masterKey.trustOnFirstUseSince != null) {
      return true;
    }
    return false;
  });

  if (users.isEmpty) return true;

  // Auto-trust on first use (TOFU) silently to preserve smooth messaging
  for (final user in users) {
    room.client.userDeviceKeys[user.id]?.masterKey?.trustOnFirstUse();
  }

  return true;
}

