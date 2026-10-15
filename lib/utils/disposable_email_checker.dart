// SPDX-FileCopyrightText: 2024-Present Contributors to FluffyChat Fork
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

/// Fetches and caches the disposable email domains list from
/// https://github.com/disposable/disposable-email-domains
///
/// List is fetched once per app session and cached in memory.
/// Contains 100,000+ known temp/disposable email domains.
class DisposableEmailChecker {
  static Set<String>? _cachedDomains;
  static bool _fetchFailed = false;

  static const _domainsUrl =
      'https://disposable.github.io/disposable-email-domains/domains.json';

  /// Fetch domains list (cached after first call)
  static Future<Set<String>> _getDomains() async {
    if (_cachedDomains != null) return _cachedDomains!;
    if (_fetchFailed) return _fallbackDomains;

    try {
      final response = await http.get(Uri.parse(_domainsUrl)).timeout(
            const Duration(seconds: 5),
          );
      if (response.statusCode == 200) {
        final list = (jsonDecode(response.body) as List).cast<String>();
        _cachedDomains = list.map((d) => d.toLowerCase()).toSet();
        Logs().i(
            'Loaded ${_cachedDomains!.length} disposable email domains');
        return _cachedDomains!;
      }
    } catch (e) {
      Logs().w('Failed to fetch disposable email domains, using fallback', e);
    }

    _fetchFailed = true;
    return _fallbackDomains;
  }

  /// Check if an email address uses a disposable/temporary domain.
  static Future<bool> isDisposable(String email) async {
    final parts = email.toLowerCase().split('@');
    if (parts.length != 2) return false;
    final domain = parts[1];
    final domains = await _getDomains();
    return domains.contains(domain);
  }

  /// Small fallback list in case the remote fetch fails.
  /// Only used when network is unavailable during registration.
  static final _fallbackDomains = <String>{
    'tempmail.com', 'temp-mail.org', 'guerrillamail.com',
    'guerrillamail.net', 'mailinator.com', 'trashmail.com',
    'yopmail.com', 'yopmail.fr', 'throwaway.email',
    'maildrop.cc', 'getnada.com', 'mohmal.com',
    'sharklasers.com', 'guerrillamailblock.com',
    '10minutemail.com', 'minutemail.io', 'mailsac.com',
    'discard.email', 'discardmail.com', 'fakeinbox.com',
    'tempmailo.com', 'emailfake.com', 'burnermail.io',
    'harakirimail.com', 'mailnesia.com', 'meltmail.com',
    'spamgourmet.com', 'trashmail.me', 'trashmail.net',
    'wegwerfmail.de', 'mailexpire.com', 'getairmail.com',
  };
}
