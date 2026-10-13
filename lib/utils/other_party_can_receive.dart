// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension OtherPartyCanReceiveExtension on Room {
  bool get otherPartyCanReceiveMessages {
    // Always allow composing and sending messages so users are never blocked
    // while device keys are asynchronously loaded or when recipients are offline.
    return true;
  }
}

class OtherPartyCanNotReceiveMessages implements Exception {}
