// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

abstract class MatrixIdHelper {
  /// Extracts the homeserver host domain from client
  static String getClientDomain(Client client) {
    final userDomain = client.userID?.domain;
    if (userDomain != null && userDomain.isNotEmpty) return userDomain;
    final hsHost = client.homeserver?.host;
    if (hsHost != null && hsHost.isNotEmpty) return hsHost;
    return '';
  }

  /// Normalizes any user input into a valid Matrix user ID.
  ///
  /// Handles inputs like:
  /// - "evelyn" -> `@evelyn:<domain>`
  /// - "@evelyn" -> `@evelyn:<domain>`
  /// - "@evelyn:domain" -> "@evelyn:domain"
  /// - "@evelyn:https://domain" -> "@evelyn:domain"
  /// - "@evelyn:https://domain/" -> "@evelyn:domain"
  /// - "evelyn:domain" -> "@evelyn:domain"
  /// - "https://matrix.to/#/@evelyn:domain" -> "@evelyn:domain"
  static String normalize(String? input, Client client) {
    if (input == null) return '';
    var s = input.trim();
    if (s.isEmpty) return '';

    // Handle matrix.to or matrix: link
    if (s.startsWith('https://matrix.to/#/')) {
      s = s.substring('https://matrix.to/#/'.length);
    } else if (s.startsWith('matrix:u/')) {
      s = '@${s.substring('matrix:u/'.length)}';
    } else if (s.startsWith('matrix:')) {
      s = s.substring('matrix:'.length);
    }

    // Strip URL protocols that might have been accidentally included
    s = s.replaceAll('https://', '').replaceAll('http://', '');

    // Strip trailing slashes
    while (s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }

    final domain = getClientDomain(client);

    if (!s.contains(':')) {
      // Localpart only (e.g. "evelyn" or "@evelyn")
      final localpart = s.startsWith('@') ? s.substring(1) : s;
      if (domain.isNotEmpty) {
        return '@$localpart:$domain';
      }
      return '@$localpart';
    } else {
      // Has colon: "@user:domain" or "user:domain"
      final colonIndex = s.indexOf(':');
      var local = s.substring(0, colonIndex);
      if (!local.startsWith('@')) {
        local = '@$local';
      }
      var domainPart = s.substring(colonIndex + 1).trim();
      while (domainPart.startsWith('/')) {
        domainPart = domainPart.substring(1);
      }
      while (domainPart.endsWith('/')) {
        domainPart = domainPart.substring(0, domainPart.length - 1);
      }
      if (domainPart.isEmpty && domain.isNotEmpty) {
        domainPart = domain;
      }
      return '$local:$domainPart';
    }
  }

  /// Formats user ID for human-friendly display:
  /// For local users on the same homeserver, shows "@username"
  /// For remote users, shows full "@username:domain"
  static String formatHandle(String userId, Client client) {
    final domain = getClientDomain(client);
    final userDomain = userId.domain;
    final localpart = userId.localpart;

    if (localpart != null && (userDomain == null || userDomain == domain)) {
      return '@$localpart';
    }
    return userId;
  }
}
