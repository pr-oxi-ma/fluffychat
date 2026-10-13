# FluffyChat Git History & Recovered Logs

This document contains the full git logs and recovery information for **`backup-main-before-reset`** and all related branches/commits in `pr-oxi-ma/fluffychat`.

---

## 1. Commits on `backup-main-before-reset`
Full commit history leading up to the state before the reset.

```text
commit 9dea6165acbc110ee6e7bad5a6b2db6063ec1cff
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 09:00:26 2026 +0000

    chore: configure hs.llc.qzz.io, locked chat backup, and safe routes on stable 2.10

 assets/config.json                            |  4 ++--
 lib/config/routes.dart                        | 27 +++++++++++++++++++++++++++
 lib/pages/settings/settings_view.dart         |  6 +++---
 lib/utils/sign_in_flows/check_homeserver.dart | 12 +++++++++---
 web/config.json                               |  4 ++--
 5 files changed, 43 insertions(+), 10 deletions(-)

commit a7990dd6de921f695d325967736ea484e571af29
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 04:31:22 2026 +0000

    fix(auth): direct to native login and guard SSO without identity providers

 lib/utils/sign_in_flows/check_homeserver.dart | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

commit 92794b860eaaca297329168046148b9b28a510a2
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 04:15:05 2026 +0000

    feat(auth): enable native in-app registration

 lib/config/app_config.dart | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 83e5e15f6be7b402ac833f76864abde3a42650b1
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 03:15:56 2026 +0000

    feat(auth): make native registration toggleable and default to external SSO/OIDC

 lib/config/app_config.dart                    |  3 +++
 lib/pages/login/login.dart                    | 36 +++++++++++++++++++++++++--
 lib/pages/login/login_view.dart               |  7 ++----
 lib/utils/sign_in_flows/check_homeserver.dart |  7 +++---
 4 files changed, 43 insertions(+), 10 deletions(-)

commit 2ac8591d601895956c2d40aaf34a9ae91f536dde
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 02:54:07 2026 +0000

    fix(auth): update homeserver config, sanitize placeholder name, and handle UIA cross-signing gracefully

 assets/config.json                      |  4 +--
 lib/pages/register/native_register.dart | 55 +++++++++++++++++++++++++--------
 web/config.json                         |  4 +--
 3 files changed, 46 insertions(+), 17 deletions(-)

commit 1f25aaf9f16ae9cdbb3d983532541cad5e0a5d23
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 02:33:27 2026 +0000

    feat(auth): 100% native in-app registration on FluffyChat 2.10.0

 assets/config.json                            |  14 +
 lib/config/routes.dart                        |  10 +
 lib/pages/intro/intro_page.dart               |  32 +-
 lib/pages/intro/intro_page_presenter.dart     |  16 +
 lib/pages/login/login_view.dart               |  25 +
 lib/pages/register/native_register.dart       | 889 ++++++++++++++++++++++++++
 lib/utils/auto_crypto_setup.dart              | 131 ++++
 lib/utils/disposable_email_checker.dart       |  70 ++
 lib/utils/sign_in_flows/check_homeserver.dart |  26 +-
 pubspec.lock                                  |   4 +-
 pubspec.yaml                                  |   2 +
 web/config.json                               |  14 +
 12 files changed, 1202 insertions(+), 31 deletions(-)

commit 8f4d0cca37fa91385aa0410588657d01ca48fc1a
Merge: a0b9ed6f6 2b9c5c9d5
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:57:05 2026 +0200

    Merge pull request #3786 from krille-chan/krille/minor-fixes-10-10
    
    Krille/minor fixes 10 10

commit 2b9c5c9d5debfc8b1c1dc449e471d6e4a93c9ab4
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:26:11 2026 +0200

    feat: support for matrix uri scheme

 lib/l10n/intl_ar.arb             |  5 -----
 lib/l10n/intl_be.arb             |  5 -----
 lib/l10n/intl_ca.arb             |  5 -----
 lib/l10n/intl_cs.arb             |  5 -----
 lib/l10n/intl_de.arb             |  5 -----
 lib/l10n/intl_en.arb             |  5 -----
 lib/l10n/intl_eo.arb             |  5 -----
 lib/l10n/intl_es.arb             |  5 -----
 lib/l10n/intl_et.arb             |  5 -----
 lib/l10n/intl_eu.arb             |  5 -----
 lib/l10n/intl_fa.arb             |  5 -----
 lib/l10n/intl_fi.arb             |  5 -----
 lib/l10n/intl_fr.arb             |  5 -----
 lib/l10n/intl_ga.arb             |  5 -----
 lib/l10n/intl_gl.arb             |  5 -----
 lib/l10n/intl_hr.arb             |  5 -----
 lib/l10n/intl_hu.arb             |  5 -----
 lib/l10n/intl_id.arb             |  5 -----
 lib/l10n/intl_it.arb             |  5 -----
 lib/l10n/intl_ja.arb             |  5 -----
 lib/l10n/intl_kab.arb            |  5 -----
 lib/l10n/intl_ko.arb             |  5 -----
 lib/l10n/intl_lt.arb             |  5 -----
 lib/l10n/intl_lv.arb             |  5 -----
 lib/l10n/intl_nb.arb             |  5 -----
 lib/l10n/intl_nl.arb             |  5 -----
 lib/l10n/intl_pl.arb             |  5 -----
 lib/l10n/intl_pt_BR.arb          |  5 -----
 lib/l10n/intl_ro.arb             |  5 -----
 lib/l10n/intl_ru.arb             |  5 -----
 lib/l10n/intl_sk.arb             |  5 -----
 lib/l10n/intl_sr.arb             |  5 -----
 lib/l10n/intl_sv.arb             |  5 -----
 lib/l10n/intl_ta.arb             |  5 -----
 lib/l10n/intl_tr.arb             |  5 -----
 lib/l10n/intl_uk.arb             |  5 -----
 lib/l10n/intl_uz.arb             |  5 -----
 lib/l10n/intl_zh.arb             |  5 -----
 lib/l10n/intl_zh_Hant.arb        |  5 -----
 lib/widgets/fluffy_chat_app.dart | 19 +++++++++++++++++++
 40 files changed, 19 insertions(+), 195 deletions(-)

commit 20b2795de799047b861a18b2cbfa3030988e563c
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:13:29 2026 +0200

    chore: do not report notification errors by default

 lib/pages/chat_list/chat_list.dart | 1 +
 1 file changed, 1 insertion(+)

commit 6b23c1071b44855723905f48f0377b4a53d8e22a
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:10:39 2026 +0200

    feat: new invite to chat UX

 lib/l10n/intl_en.arb                           |  26 ++++-
 lib/pages/chat/chat.dart                       |  41 +++++++
 lib/pages/chat/chat_app_bar_title.dart         |  26 ++---
 lib/pages/chat/chat_event_list.dart            |  63 ++++++++++-
 lib/pages/chat/chat_view.dart                  | 142 ++++++++++++++++---------
 lib/pages/chat_list/chat_list.dart             |  47 +++-----
 lib/pages/chat_list/chat_list_item.dart        |  25 +----
 lib/pages/chat_list/navigation_rail.dart       |   2 +-
 lib/pages/chat_list/unread_bubble.dart         |   6 +-
 lib/utils/notification_background_handler.dart |  12 +--
 lib/widgets/chat_settings_popup_menu.dart      |  40 +++----
 11 files changed, 278 insertions(+), 152 deletions(-)

commit 806fb205d52682d1acddc71e7d164038494bc774
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 18:17:03 2026 +0200

    chore: follow up check rtc transports

 lib/utils/matrix_live_kit_calls/matrix_live_kit_call.dart | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

commit 0f8ddcc6a43e0a2297724a06f5db97d9591174af
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 17:26:11 2026 +0200

    build: switch to matrix sdk from pub.dev again

 pubspec.lock | 9 ++++-----
 pubspec.yaml | 6 +-----
 2 files changed, 5 insertions(+), 10 deletions(-)

commit 77dd54c7de0eeb97f5227af315c6d961cacb4bf1
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 17:26:03 2026 +0200

    chore: set window size on macOS and windows like in Linux

 .../xcshareddata/swiftpm/Package.resolved          | 122 ---------------------
 macos/Runner/Base.lproj/MainMenu.xib               |   4 +-
 windows/runner/main.cpp                            |   2 +-
 3 files changed, 3 insertions(+), 125 deletions(-)

commit a0b9ed6f62dbb1e534a7cb4fe1707715e07c13ca
Merge: 8bca8b392 b9c0c0aa3
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 10:42:38 2026 +0200

    Merge pull request #3770 from zacxihu/ios_paste
    
    feat: Allow pasting from iOS keyboard

commit 8bca8b39248bdaedd2f45ecced1e7575a06d2d67
Merge: 08b9b9aff 68d26b1ba
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 10:14:48 2026 +0200

    Merge pull request #3774 from krille-chan/krille/query-rtc-transports
    
    Krille/query rtc transports

commit 08b9b9aff6420930ccaf8358f6982c5cb4b38d86
Merge: 4c4653d99 a3da37dee
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 06:46:00 2026 +0200

    Merge pull request #3781 from krille-chan/dependabot/pub/cupertino_ui-1.1.2
    
    build: (deps): bump cupertino_ui from 1.1.1 to 1.1.2

commit 4c4653d99dc40ae8fb5002f204bcc893ec83ab18
Merge: 3410d16ea 47e6cf9ce
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 06:45:26 2026 +0200

    Merge pull request #3780 from krille-chan/dependabot/pub/material_ui-1.6.0
    
    build: (deps): bump material_ui from 1.5.0 to 1.6.0

commit 3410d16ead8523c34b90fae222abdb7766fd5391
Merge: 046da70d8 b984cde1c
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 06:44:44 2026 +0200

    Merge pull request #3779 from krille-chan/dependabot/pub/shared_preferences-2.5.6
    
    build: (deps): bump shared_preferences from 2.5.5 to 2.5.6

commit 046da70d8378e7af50354e2843ce9d7531c1d92c
Merge: f94804398 625e6cbe6
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 06:44:12 2026 +0200

    Merge pull request #3778 from krille-chan/dependabot/pub/image_picker-1.2.4
    
    build: (deps): bump image_picker from 1.2.3 to 1.2.4

commit a3da37deeecf24090f4642e0634efdc1bfd56e7e
Author: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>
Date:   Fri Oct 9 22:10:45 2026 +0000

    build: (deps): bump cupertino_ui from 1.1.1 to 1.1.2
    
    Bumps [cupertino_ui](https://github.com/flutter/packages/tree/main/packages) from 1.1.1 to 1.1.2.
    - [Release notes](https://github.com/flutter/packages/releases)
    - [Commits](https://github.com/flutter/packages/commits/cupertino_ui-v1.1.2/packages)
    
    ---
    updated-dependencies:
    - dependency-name: cupertino_ui
      dependency-version: 1.1.2
      dependency-type: direct:production
      update-type: version-update:semver-patch
    ...
    
    Signed-off-by: dependabot[bot] <support@github.com>

 pubspec.lock | 4 ++--
 pubspec.yaml | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

commit 47e6cf9ce9699df71d5a1b37991904447bb11fb9
Author: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>
Date:   Fri Oct 9 22:10:32 2026 +0000

    build: (deps): bump material_ui from 1.5.0 to 1.6.0
    
    Bumps [material_ui](https://github.com/flutter/packages/tree/main/packages) from 1.5.0 to 1.6.0.
    - [Release notes](https://github.com/flutter/packages/releases)
    - [Commits](https://github.com/flutter/packages/commits/material_ui-v1.6.0/packages)
    
    ---
    updated-dependencies:
    - dependency-name: material_ui
      dependency-version: 1.6.0
      dependency-type: direct:production
      update-type: version-update:semver-minor
    ...
    
    Signed-off-by: dependabot[bot] <support@github.com>

 pubspec.lock | 4 ++--
 pubspec.yaml | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

commit b984cde1cfd9e4112bbf5a7306d13ba50ec06309
Author: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>
Date:   Fri Oct 9 22:09:41 2026 +0000

    build: (deps): bump shared_preferences from 2.5.5 to 2.5.6
    
    Bumps [shared_preferences](https://github.com/flutter/packages/tree/main/packages/shared_preferences) from 2.5.5 to 2.5.6.
    - [Release notes](https://github.com/flutter/packages/releases)
    - [Commits](https://github.com/flutter/packages/commits/shared_preferences-v2.5.6/packages/shared_preferences)
    
    ---
    updated-dependencies:
    - dependency-name: shared_preferences
      dependency-version: 2.5.6
      dependency-type: direct:production
      update-type: version-update:semver-patch
    ...
    
    Signed-off-by: dependabot[bot] <support@github.com>

 pubspec.lock | 4 ++--
 pubspec.yaml | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

commit 625e6cbe69fe0fc7992b70b8d3c3f1294a6c779e
Author: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>
Date:   Fri Oct 9 22:09:19 2026 +0000

    build: (deps): bump image_picker from 1.2.3 to 1.2.4
    
    Bumps [image_picker](https://github.com/flutter/packages/tree/main/packages/image_picker) from 1.2.3 to 1.2.4.
    - [Release notes](https://github.com/flutter/packages/releases)
    - [Commits](https://github.com/flutter/packages/commits/image_picker-v1.2.4/packages/image_picker)
    
    ---
    updated-dependencies:
    - dependency-name: image_picker
      dependency-version: 1.2.4
      dependency-type: direct:production
      update-type: version-update:semver-patch
    ...
    
    Signed-off-by: dependabot[bot] <support@github.com>

 pubspec.lock | 4 ++--
 pubspec.yaml | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

commit b9c0c0aa30d91859df1ede0c4e279b66aad98eb6
Author: Zach Westlake <4939037+zacxihu@users.noreply.github.com>
Date:   Wed Oct 7 21:07:50 2026 -0700

    feat: Allow pasting from iOS keyboard

 lib/l10n/intl_en.arb                    |  4 +++-
 lib/pages/chat/input_bar.dart           | 16 ++++++++++++++++
 lib/utils/markdown_context_builder.dart | 10 ++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

commit f94804398acf2c24b50f1b3f4cf9b47d783044d8
Merge: d31a88389 2ac8d017d
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Fri Oct 9 12:36:42 2026 +0200

    Merge pull request #3772 from krille-chan/krille/correct-audio-session-handling-ios-in-calls
    
    Krille/correct audio session handling ios in calls
```

---

## 2. Commits on `v2.10-native-inapp-auth` (`df69b4545`)
Full commit history of the alternative/extended branch with native auth, routes, and lint fixes.

```text
commit df69b4545c2e9544bda6ac0a07cc7ae35f7b075f
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 08:26:43 2026 +0000

    fix(lint): remove unnecessary cast and guard BuildContext with mounted check

 lib/utils/sign_in_flows/check_homeserver.dart | 1 +
 lib/widgets/settings_switch_list_tile.dart    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

commit ce9728fe2bd2c282a55a5dd38d5db6abd73c55d3
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 08:22:50 2026 +0000

    fix(routes): add register and login routes under settings and support contextual basePath

 lib/config/routes.dart                        | 27 +++++++++++++++++++++++++++
 lib/utils/sign_in_flows/check_homeserver.dart | 11 ++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

commit cc0bdcd1f120eca240cf1c4429a68390bca2735f
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 07:23:18 2026 +0000

    fix(chat): extend sendTimelineEventTimeout to 180s for media uploads and guard web notifications

 lib/config/setting_keys.dart                   |  2 +-
 lib/utils/client_manager.dart                  | 12 ++++++++++--
 lib/widgets/local_notifications_extension.dart | 18 ++++++++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

commit 911b7612b9445c19e47c2d2773d79fa624e55885
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 06:52:49 2026 +0000

    fix(chat): allow immediate message composition without blocking on async key loading

 assets/config.json                     |  8 ++++++--
 lib/utils/other_party_can_receive.dart | 16 +++-------------
 web/config.json                        |  8 ++++++--
 3 files changed, 15 insertions(+), 17 deletions(-)

commit 6d3db7482742c5880d1da855142c97e995cc1837
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 12:49:38 2026 +0000

    feat(search): support automatic homeserver domain resolution for plain username and @username search

 lib/pages/new_private_chat/new_private_chat.dart | 40 +++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

commit 34f11a6aae86967ef91196c4a93acdcc275d358d
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 12:35:14 2026 +0000

    fix(search): strictly validate user profile with server before displaying in search

 lib/pages/new_private_chat/new_private_chat.dart | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

commit f1de3c9f0e54180831cccae0cce6dd655fe7a6ff
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 11:58:48 2026 +0000

    fix(settings): ensure default values display correctly as ON and enable double-tap-to-react

 lib/config/setting_keys.dart               | 10 ++++++----
 lib/widgets/settings_switch_list_tile.dart |  5 ++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

commit 3e41c286005c2bd86311d6940d7be8c59349b731
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 08:17:38 2026 +0000

    fix(settings): lock chat backup to active and dimmed

 lib/pages/settings/settings_view.dart | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

commit a7990dd6de921f695d325967736ea484e571af29
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 04:31:22 2026 +0000

    fix(auth): direct to native login and guard SSO without identity providers

 lib/utils/sign_in_flows/check_homeserver.dart | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

commit 92794b860eaaca297329168046148b9b28a510a2
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 04:15:05 2026 +0000

    feat(auth): enable native in-app registration

 lib/config/app_config.dart | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 83e5e15f6be7b402ac833f76864abde3a42650b1
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 03:15:56 2026 +0000

    feat(auth): make native registration toggleable and default to external SSO/OIDC

 lib/config/app_config.dart                    |  3 +++
 lib/pages/login/login.dart                    | 36 +++++++++++++++++++++++++--
 lib/pages/login/login_view.dart               |  7 ++----
 lib/utils/sign_in_flows/check_homeserver.dart |  7 +++---
 4 files changed, 43 insertions(+), 10 deletions(-)

commit 2ac8591d601895956c2d40aaf34a9ae91f536dde
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 02:54:07 2026 +0000

    fix(auth): update homeserver config, sanitize placeholder name, and handle UIA cross-signing gracefully

 assets/config.json                      |  4 +--
 lib/pages/register/native_register.dart | 55 +++++++++++++++++++++++++--------
 web/config.json                         |  4 +--
 3 files changed, 46 insertions(+), 17 deletions(-)

commit 1f25aaf9f16ae9cdbb3d983532541cad5e0a5d23
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 02:33:27 2026 +0000

    feat(auth): 100% native in-app registration on FluffyChat 2.10.0

 assets/config.json                            |  14 +
 lib/config/routes.dart                        |  10 +
 lib/pages/intro/intro_page.dart               |  32 +-
 lib/pages/intro/intro_page_presenter.dart     |  16 +
 lib/pages/login/login_view.dart               |  25 +
 lib/pages/register/native_register.dart       | 889 ++++++++++++++++++++++++++
 lib/utils/auto_crypto_setup.dart              | 131 ++++
 lib/utils/disposable_email_checker.dart       |  70 ++
 lib/utils/sign_in_flows/check_homeserver.dart |  26 +-
 pubspec.lock                                  |   4 +-
 pubspec.yaml                                  |   2 +
 web/config.json                               |  14 +
 12 files changed, 1202 insertions(+), 31 deletions(-)

commit 8f4d0cca37fa91385aa0410588657d01ca48fc1a
Merge: a0b9ed6f6 2b9c5c9d5
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:57:05 2026 +0200

    Merge pull request #3786 from krille-chan/krille/minor-fixes-10-10
    
    Krille/minor fixes 10 10

commit 2b9c5c9d5debfc8b1c1dc449e471d6e4a93c9ab4
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:26:11 2026 +0200

    feat: support for matrix uri scheme

 lib/l10n/intl_ar.arb             |  5 -----
 lib/l10n/intl_be.arb             |  5 -----
 lib/l10n/intl_ca.arb             |  5 -----
 lib/l10n/intl_cs.arb             |  5 -----
 lib/l10n/intl_de.arb             |  5 -----
 lib/l10n/intl_en.arb             |  5 -----
 lib/l10n/intl_eo.arb             |  5 -----
 lib/l10n/intl_es.arb             |  5 -----
 lib/l10n/intl_et.arb             |  5 -----
 lib/l10n/intl_eu.arb             |  5 -----
 lib/l10n/intl_fa.arb             |  5 -----
 lib/l10n/intl_fi.arb             |  5 -----
 lib/l10n/intl_fr.arb             |  5 -----
 lib/l10n/intl_ga.arb             |  5 -----
 lib/l10n/intl_gl.arb             |  5 -----
 lib/l10n/intl_hr.arb             |  5 -----
 lib/l10n/intl_hu.arb             |  5 -----
 lib/l10n/intl_id.arb             |  5 -----
 lib/l10n/intl_it.arb             |  5 -----
 lib/l10n/intl_ja.arb             |  5 -----
 lib/l10n/intl_kab.arb            |  5 -----
 lib/l10n/intl_ko.arb             |  5 -----
 lib/l10n/intl_lt.arb             |  5 -----
 lib/l10n/intl_lv.arb             |  5 -----
 lib/l10n/intl_nb.arb             |  5 -----
 lib/l10n/intl_nl.arb             |  5 -----
 lib/l10n/intl_pl.arb             |  5 -----
 lib/l10n/intl_pt_BR.arb          |  5 -----
 lib/l10n/intl_ro.arb             |  5 -----
 lib/l10n/intl_ru.arb             |  5 -----
 lib/l10n/intl_sk.arb             |  5 -----
 lib/l10n/intl_sr.arb             |  5 -----
 lib/l10n/intl_sv.arb             |  5 -----
 lib/l10n/intl_ta.arb             |  5 -----
 lib/l10n/intl_tr.arb             |  5 -----
 lib/l10n/intl_uk.arb             |  5 -----
 lib/l10n/intl_uz.arb             |  5 -----
 lib/l10n/intl_zh.arb             |  5 -----
 lib/l10n/intl_zh_Hant.arb        |  5 -----
 lib/widgets/fluffy_chat_app.dart | 19 +++++++++++++++++++
 40 files changed, 19 insertions(+), 195 deletions(-)

commit 20b2795de799047b861a18b2cbfa3030988e563c
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:13:29 2026 +0200

    chore: do not report notification errors by default

 lib/pages/chat_list/chat_list.dart | 1 +
 1 file changed, 1 insertion(+)

commit 6b23c1071b44855723905f48f0377b4a53d8e22a
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 19:10:39 2026 +0200

    feat: new invite to chat UX

 lib/l10n/intl_en.arb                           |  26 ++++-
 lib/pages/chat/chat.dart                       |  41 +++++++
 lib/pages/chat/chat_app_bar_title.dart         |  26 ++---
 lib/pages/chat/chat_event_list.dart            |  63 ++++++++++-
 lib/pages/chat/chat_view.dart                  | 142 ++++++++++++++++---------
 lib/pages/chat_list/chat_list.dart             |  47 +++-----
 lib/pages/chat_list/chat_list_item.dart        |  25 +----
 lib/pages/chat_list/navigation_rail.dart       |   2 +-
 lib/pages/chat_list/unread_bubble.dart         |   6 +-
 lib/utils/notification_background_handler.dart |  12 +--
 lib/widgets/chat_settings_popup_menu.dart      |  40 +++----
 11 files changed, 278 insertions(+), 152 deletions(-)

commit 806fb205d52682d1acddc71e7d164038494bc774
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 18:17:03 2026 +0200

    chore: follow up check rtc transports

 lib/utils/matrix_live_kit_calls/matrix_live_kit_call.dart | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

commit 0f8ddcc6a43e0a2297724a06f5db97d9591174af
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 17:26:11 2026 +0200

    build: switch to matrix sdk from pub.dev again

 pubspec.lock | 9 ++++-----
 pubspec.yaml | 6 +-----
 2 files changed, 5 insertions(+), 10 deletions(-)

commit 77dd54c7de0eeb97f5227af315c6d961cacb4bf1
Author: Christian Kußowski <christian-kussowski@posteo.de>
Date:   Sat Oct 10 17:26:03 2026 +0200

    chore: set window size on macOS and windows like in Linux

 .../xcshareddata/swiftpm/Package.resolved          | 122 ---------------------
 macos/Runner/Base.lproj/MainMenu.xib               |   4 +-
 windows/runner/main.cpp                            |   2 +-
 3 files changed, 3 insertions(+), 125 deletions(-)
```

---

## 3. Commits on `official-fluffychat-2.10` (`26c17d215`)
Commits based on FluffyChat 2.10 official release.

```text
commit 26c17d215800f5b2995a97f57463ef3e36b61ba6
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 07:23:18 2026 +0000

    fix(chat): extend sendTimelineEventTimeout to 180s for media uploads and guard web notifications

 lib/config/setting_keys.dart                   |  2 +-
 lib/utils/client_manager.dart                  | 12 ++++++++++--
 lib/widgets/local_notifications_extension.dart | 18 ++++++++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

commit f23daad77b8bdc638f89b256b7836f7aeaced6a4
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Tue Oct 13 06:52:49 2026 +0000

    fix(chat): allow immediate message composition without blocking on async key loading

 assets/config.json                     | 18 ++++++++++++++++++
 lib/utils/other_party_can_receive.dart | 16 +++-------------
 2 files changed, 21 insertions(+), 13 deletions(-)

commit ac0469348ba0c5ddba91c04b164ddd34926d646d
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 12:49:38 2026 +0000

    feat(search): support automatic homeserver domain resolution for plain username and @username search

 lib/pages/new_private_chat/new_private_chat.dart | 40 +++++++++++++++++-------
 1 file changed, 29 insertions(+), 11 deletions(-)

commit 130c21ca8525af3c5e198dd4225c0f63c9af15f6
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 12:35:14 2026 +0000

    fix(search): strictly validate user profile with server before displaying in search

 lib/pages/new_private_chat/new_private_chat.dart | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

commit 1335982a959b3b58168ce15b090f3b73f52cb9a1
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 11:58:48 2026 +0000

    fix(settings): ensure default values display correctly as ON and enable double-tap-to-react

 lib/config/setting_keys.dart               | 10 ++++++----
 lib/widgets/settings_switch_list_tile.dart |  5 ++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

commit 69638df03e1d13a057b15f61e4249b7833479882
Merge: 09cfcfe87 3ef51a5f1
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Fri Oct 2 15:55:52 2026 +0200

    Merge pull request #3718 from krille-chan/krille/pin-integration-tests-to-24-04
    
    Krille/pin integration tests to 24 04

commit 3ef51a5f1cf58e56848ce474c4ef83ef019ec524
Author: Christian Kußowski <chritian-kussowski@posteo.de>
Date:   Fri Oct 2 15:32:46 2026 +0200

    build: fix integration tests

 integration_test/flows/login_and_chat_backup.dart | 3 +++
 1 file changed, 3 insertions(+)

commit 09cfcfe8738a44a1b99a610310adb420c48d7708
Merge: 4ad1bcffd ef423ae0d
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Thu Oct 1 12:13:08 2026 +0200

    Merge pull request #3711 from krille-chan/krille/self-sign-after-restore-identity
    
    Krille/self sign after restore identity

commit ef423ae0d3387b6b97cbbdba443cf5a43c8bea15
Author: Christian Kußowski <chritian-kussowski@posteo.de>
Date:   Thu Oct 1 09:09:46 2026 +0200

    chore: follow up selfsign

 lib/pages/bootstrap/view_model/bootstrap_view_model.dart | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

commit 4ad1bcffd63c38ef1e550e3be2c1c83c9704ec21
Merge: 200184a6a ff18f3bd1
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Thu Oct 1 08:09:07 2026 +0200

    Merge pull request #3700 from krille-chan/krille/fix-reset-crypto-identity
    
    Krille/fix reset crypto identity

commit 200184a6a245a161a27edacf385d21ab71b117fa
Merge: 982505735 922523289
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Thu Oct 1 08:05:06 2026 +0200

    Merge pull request #3705 from PolynomialDivision/fix/read-marker-on-edits
    
    fix: set read marker on the last event if it is the newest

commit 982505735a5560a33d41b10996c3b68a2a8d69a5
Merge: bc4608df7 ed9e1f465
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Thu Oct 1 07:33:31 2026 +0200

    Merge pull request #3703 from PolynomialDivision/fix/repeat-sending-read
    
    fix: don't drop new read marker updates while a request is running

commit 9225232890d097b2d3c87c33b5bc1b2f4bc31192
Author: Nick Hainke <vincent@systemli.org>
Date:   Wed Sep 30 21:56:29 2026 +0200

    fix: set read marker on the last event if it is the newest
    
    If the last event in a room does not notify (e.g. an edit), the room can
    never be marked as read. This is because the room marker is only set on
    the last notifying event. Use the last event instead if it is newer.

 lib/pages/chat/chat.dart | 1 +
 1 file changed, 1 insertion(+)

commit ed9e1f465636ef9a89c0d9841a8e6115d5c95f15
Author: Nick Hainke <vincent@systemli.org>
Date:   Wed Sep 30 16:49:04 2026 +0200

    fix: don't drop new read marker updates while a request is running
    
    setReadMarker is only executed when some event happens (like scrolling,
    new message arrives, ...). When now two messages arrive after each
    other, we could potentially lose a setReadMarker of the second message
    since it is still blocked by the first request.

 lib/pages/chat/chat.dart | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

commit ff18f3bd173c16c1e18b2acae31683367a4ff8d9
Author: Christian Kußowski <chritian-kussowski@posteo.de>
Date:   Wed Sep 30 12:46:47 2026 +0200

    fix: reset crypto identity does not wipe secrets

 .../bootstrap/view_model/bootstrap_view_model.dart | 32 +++++++++-------------
 1 file changed, 13 insertions(+), 19 deletions(-)
```

---

## 4. Commits on `backup-2.9.5-working` (`22daecb54`)
Stable working state prior to 2.10 upgrade.

```text
commit 22daecb5435ed41edd8bec0f643da7896567c793
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Mon Oct 12 11:17:22 2026 +0000

    chore: save working state before official 2.10 upgrade

 .github/workflows/integrate.yaml                   |  44 +-
 .github/workflows/release.yaml                     |  60 ++-
 LICENSES/LicenseRef-All-Rights-Reserved.txt        |   4 +
 REUSE.toml                                         |  14 +-
 android/fastlane/Fastfile                          |   2 -
 assets/config.json                                 |  14 +
 assets/logo/img/banner.png                         | Bin 0 -> 272263 bytes
 assets/logo/img/mascot.png                         | Bin 0 -> 183133 bytes
 assets/logo/mini/banner.png                        | Bin 0 -> 60021 bytes
 assets/logo/mini/mascot.png                        | Bin 0 -> 14504 bytes
 assets/logo/vector/mascot.svg                      | 136 ++++++
 fastlane/metadata.rclonelink                       |   1 +
 lib/config/app_config.dart                         |  12 +-
 lib/config/routes.dart                             |  52 ++-
 lib/config/setting_keys.dart                       |  10 +-
 lib/l10n/intl_en.arb                               |  10 +
 lib/l10n/intl_ja.arb                               |   6 +-
 lib/l10n/intl_nl.arb                               |   8 +
 lib/l10n/intl_uk.arb                               |  73 +++-
 lib/main.dart                                      |  37 +-
 lib/pages/bootstrap/bootstrap_page.dart            |  97 ++---
 .../bootstrap/view_model/bootstrap_view_model.dart |  47 +-
 lib/pages/chat/chat.dart                           |  22 +-
 lib/pages/chat/encryption_info.dart                |   1 -
 lib/pages/chat/events/html_message.dart            |  12 +-
 lib/pages/chat/events/message_content.dart         | 114 +++++
 lib/pages/chat/events/state_message.dart           |  32 +-
 lib/pages/chat/trust_user_key_dialog.dart          | 133 +-----
 lib/pages/chat_list/chat_list.dart                 |  39 +-
 .../device_settings/device_settings_view.dart      |  15 +-
 lib/pages/login/email_verification_dialog.dart     | 472 +++++++++++++++++++++
 lib/pages/login/login.dart                         |  65 ++-
 lib/pages/login/login_view.dart                    |   7 +-
 lib/pages/register/native_register.dart            | 363 ++++++++++++----
 lib/pages/settings/edit_profile_dialog.dart        | 330 ++++++++++++++
 lib/pages/settings/settings.dart                   |  19 +-
 lib/pages/settings/settings_view.dart              |  11 +-
 .../settings_homeserver/settings_homeserver.dart   |  24 +-
 .../settings_homeserver_view.dart                  |  11 +-
 lib/pages/settings_password/settings_password.dart |  20 +-
 .../settings_security/settings_security_view.dart  |  55 ++-
 lib/utils/auto_crypto_setup.dart                   | 263 +++++++++---
 lib/utils/client_manager.dart                      |  19 +-
 lib/utils/matrix_id_helper.dart                    |  93 ++++
 .../flutter_matrix_dart_sdk_database/builder.dart  |  50 +--
 lib/utils/matrix_sdk_extensions/matrix_locals.dart |   2 +-
 lib/utils/push_helper.dart                         |   3 +-
 lib/utils/show_update_snackbar.dart                | 109 ++++-
 lib/utils/sign_in_flows/check_homeserver.dart      |  39 +-
 lib/utils/url_launcher.dart                        |  11 +-
 .../adaptive_dialogs/adaptive_dialog_action.dart   |   4 +-
 lib/widgets/local_notifications_extension.dart     |   4 +
 lib/widgets/matrix.dart                            |  39 +-
 macos/Flutter/Flutter-Debug.xcconfig               |   1 -
 macos/Flutter/Flutter-Release.xcconfig             |   1 -
 macos/Runner.xcodeproj/project.pbxproj             | 100 +----
 macos/Runner/Configs/AppInfo.xcconfig              |   2 +-
 macos/Runner/Info.plist                            |   4 +
 pubspec.lock                                       |   4 +-
 run_test_env.py                                    | 209 +++++++++
 scripts/package-windows.ps1                        |  41 ++
 serve_web.py                                       |  51 +++
 vercel.json                                        |  43 ++
 web/config.json                                    |  14 +
 web/index.html                                     |   5 +-
 windows/CMakeLists.txt                             |  10 +
 windows/flutter/CMakeLists.txt                     |   7 +-
 windows/installer.iss                              |  73 ++++
 windows/runner/CMakeLists.txt                      |   7 +
 windows/runner/Runner.rc                           |  10 +-
 70 files changed, 2915 insertions(+), 675 deletions(-)

commit 78608546f0936937fd3b2e87fab0afd962f7a37e
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 01:55:41 2026 +0000

    fix(lint): add @override annotation to noPermission

 lib/utils/matrix_sdk_extensions/matrix_locals.dart | 1 +
 1 file changed, 1 insertion(+)

commit d3504c4c261579885bde94820ece2665e688c4d0
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 01:54:49 2026 +0000

    fix(lint): clean up analyzer warnings and add direct dependencies

 lib/utils/auto_crypto_setup.dart                   | 2 +-
 lib/utils/matrix_sdk_extensions/matrix_locals.dart | 4 ----
 pubspec.yaml                                       | 2 ++
 3 files changed, 3 insertions(+), 5 deletions(-)

commit 5b34065929dccc33d1e401a824aa06c1725746f1
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sun Oct 11 01:37:44 2026 +0000

    feat(auth): 100% native in-app registration with UIAA and zero-friction crypto setup

 lib/config/routes.dart                        |  13 +-
 lib/pages/intro/intro_page.dart               |  32 +-
 lib/pages/intro/intro_page_presenter.dart     |  16 +
 lib/pages/login/login_view.dart               |  25 +
 lib/pages/register/native_register.dart       | 889 ++++++++++++++++++++++++++
 lib/utils/auto_crypto_setup.dart              | 131 ++++
 lib/utils/disposable_email_checker.dart       |  70 ++
 lib/utils/sign_in_flows/check_homeserver.dart |  26 +-
 pubspec.lock                                  |  63 +-
 pubspec.yaml                                  |  17 +-
 10 files changed, 1208 insertions(+), 74 deletions(-)

commit 2b3c09458329a5f1a44ca13fb2eb040c92e69db5
Author: pr-oxi-ma <adnanshah6901@gmail.com>
Date:   Sat Sep 19 07:38:09 2026 +0000

    feat: custom auth, silent auto-crypto vault, auto-verify, and non-toggleable backup

 lib/config/app_config.dart                         |   2 +
 lib/config/routes.dart                             |   3 +-
 lib/pages/bootstrap/bootstrap_page.dart            |   4 +-
 lib/pages/chat/encryption_info.dart                |  23 +-
 lib/pages/custom_auth/custom_auth_page.dart        | 526 +++++++++++++++++++++
 lib/pages/login/login.dart                         |   8 +-
 lib/pages/settings/settings_view.dart              |  11 +-
 .../settings_security/settings_security_view.dart  |  55 +--
 lib/utils/auto_crypto_vault.dart                   |  73 +++
 lib/widgets/matrix.dart                            |  19 +-
 pubspec.lock                                       |   2 +-
 pubspec.yaml                                       |   1 +
 12 files changed, 629 insertions(+), 98 deletions(-)

commit 30492f8827beab20d0c4f637634edb32914f726d
Author: Krille-chan <christian-kussowski@posteo.de>
Date:   Sat Sep 19 08:17:19 2026 +0200

    Merge pull request #3634 from krille-chan/dependabot/pub/qr_code_scanner_plus-2.3.0
    
    build: (deps): bump qr_code_scanner_plus from 2.2.0 to 2.3.0

 .github/CODEOWNERS                                 |    3 +
 .github/FUNDING.yml                                |   13 +
 .github/ISSUE_TEMPLATE/bug_report.yml              |   74 +
 .github/ISSUE_TEMPLATE/config.yml                  |    5 +
 .github/ISSUE_TEMPLATE/feature_request.yml         |   34 +
 .github/ISSUE_TEMPLATE/test_report.md              |   44 +
 .github/actions/free_up_space/action.yaml          |   50 +
 .github/dependabot.yml                             |   23 +
 .github/pull_request_template.md                   |   12 +
 .github/workflows/integrate.yaml                   |  229 ++
 .github/workflows/main_deploy.yaml                 |   83 +
 .github/workflows/matrix_notify.yaml               |   60 +
 .github/workflows/release.yaml                     |  216 ++
 .github/workflows/stale.yaml                       |   21 +
 .gitignore                                         |  205 +
 .mailmap                                           |   20 +
 .metadata                                          |   30 +
 .tool_versions.yaml                                |    2 +
 .vscode/settings.json                              |    7 +
 CHANGELOG.md                                       | 4007 ++++++++++++++++++++
 CONTRIBUTING.md                                    |  179 +
 Dockerfile                                         |   26 +
 LICENSE                                            |  661 ++++
 LICENSES/AGPL-3.0-or-later.txt                     |  235 ++
 LICENSES/Apache-2.0.txt                            |   73 +
 LICENSES/CC-BY-4.0.txt                             |  156 +
 PRIVACY.md                                         |    8 +
 README.md                                          |  138 +
 REUSE.toml                                         |   63 +
 SECURITY.md                                        |   22 +
 analysis_options.yaml                              |   89 +
 android/.gitignore                                 |   13 +
 android/Gemfile                                    |    4 +
 android/app/build.gradle.kts                       |   98 +
 android/app/proguard-rules.pro                     |    1 +
 android/app/src/main/AndroidManifest.xml           |  147 +
 .../chat/fluffy/fluffychat/FcmPushService.kt       |   28 +
 .../kotlin/chat/fluffy/fluffychat/MainActivity.kt  |   31 +
 .../res/drawable-hdpi/ic_launcher_background.png   |  Bin 0 -> 598 bytes
 .../res/drawable-hdpi/ic_launcher_foreground.png   |  Bin 0 -> 7198 bytes
 .../res/drawable-hdpi/ic_launcher_monochrome.png   |  Bin 0 -> 7550 bytes
 .../main/res/drawable-hdpi/notifications_icon.png  |  Bin 0 -> 882 bytes
 android/app/src/main/res/drawable-hdpi/splash.png  |  Bin 0 -> 9166 bytes
 .../res/drawable-mdpi/ic_launcher_background.png   |  Bin 0 -> 396 bytes
 .../res/drawable-mdpi/ic_launcher_foreground.png   |  Bin 0 -> 4790 bytes
 .../res/drawable-mdpi/ic_launcher_monochrome.png   |  Bin 0 -> 4984 bytes
 .../main/res/drawable-mdpi/notifications_icon.png  |  Bin 0 -> 566 bytes
 android/app/src/main/res/drawable-mdpi/splash.png  |  Bin 0 -> 5267 bytes
 .../src/main/res/drawable-night-v21/background.png |  Bin 0 -> 70 bytes
 .../res/drawable-night-v21/launch_background.xml   |    9 +
 .../app/src/main/res/drawable-night/background.png |  Bin 0 -> 70 bytes
 .../main/res/drawable-night/launch_background.xml  |    9 +
 .../app/src/main/res/drawable-v21/background.png   |  Bin 0 -> 68 bytes
 .../main/res/drawable-v21/launch_background.xml    |    9 +
 .../res/drawable-xhdpi/ic_launcher_background.png  |  Bin 0 -> 814 bytes
 .../res/drawable-xhdpi/ic_launcher_foreground.png  |  Bin 0 -> 9889 bytes
 .../res/drawable-xhdpi/ic_launcher_monochrome.png  |  Bin 0 -> 10431 bytes
 .../main/res/drawable-xhdpi/notifications_icon.png |  Bin 0 -> 1194 bytes
 android/app/src/main/res/drawable-xhdpi/splash.png |  Bin 0 -> 14346 bytes
 .../res/drawable-xxhdpi/ic_launcher_background.png |  Bin 0 -> 3506 bytes
 .../res/drawable-xxhdpi/ic_launcher_foreground.png |  Bin 0 -> 16079 bytes
 .../res/drawable-xxhdpi/ic_launcher_monochrome.png |  Bin 0 -> 16679 bytes
 .../res/drawable-xxhdpi/notifications_icon.png     |  Bin 0 -> 1860 bytes
 .../app/src/main/res/drawable-xxhdpi/splash.png    |  Bin 0 -> 25762 bytes
 .../drawable-xxxhdpi/ic_launcher_background.png    |  Bin 0 -> 1928 bytes
 .../drawable-xxxhdpi/ic_launcher_foreground.png    |  Bin 0 -> 20522 bytes
 .../drawable-xxxhdpi/ic_launcher_monochrome.png    |  Bin 0 -> 21547 bytes
 .../res/drawable-xxxhdpi/notifications_icon.png    |  Bin 0 -> 2536 bytes
 .../app/src/main/res/drawable-xxxhdpi/splash.png   |  Bin 0 -> 28508 bytes
 android/app/src/main/res/drawable/background.png   |  Bin 0 -> 68 bytes
 .../main/res/drawable/ic_launcher_foreground.xml   |   29 +
 .../main/res/drawable/ic_launcher_monochrome.xml   |   11 +
 .../src/main/res/drawable/launch_background.xml    |    9 +
 .../src/main/res/mipmap-anydpi-v26/ic_launcher.xml |   14 +
 .../app/src/main/res/mipmap-hdpi/ic_launcher.png   |  Bin 0 -> 3178 bytes
 .../app/src/main/res/mipmap-mdpi/ic_launcher.png   |  Bin 0 -> 1864 bytes
 .../app/src/main/res/mipmap-xhdpi/ic_launcher.png  |  Bin 0 -> 3784 bytes
 .../app/src/main/res/mipmap-xxhdpi/ic_launcher.png |  Bin 0 -> 6640 bytes
 .../src/main/res/mipmap-xxxhdpi/ic_launcher.png    |  Bin 0 -> 7685 bytes
 android/app/src/main/res/values-night/styles.xml   |   19 +
 .../src/main/res/values/ic_launcher_background.xml |    4 +
 android/app/src/main/res/values/styles.xml         |    8 +
 android/app/src/main/res/xml/app_restrictions.xml  |   19 +
 .../app/src/main/res/xml/automotive_app_desc.xml   |    3 +
 android/app/src/main/res/xml/locale_config.xml     |   62 +
 android/build.gradle.kts                           |   21 +
 android/fastlane/Appfile                           |    2 +
 android/fastlane/Fastfile                          |   80 +
 android/fastlane/README.md                         |   56 +
 .../metadata/android/en-US/changelogs/default.txt  |    2 +
 .../metadata/android/en-US/full_description.txt    |   31 +
 .../metadata/android/en-US/images/logo.png         |  Bin 0 -> 88369 bytes
 .../android/en-US/images/phoneScreenshots/1.png    |  Bin 0 -> 444992 bytes
 .../android/en-US/images/phoneScreenshots/2.png    |  Bin 0 -> 974635 bytes
 .../android/en-US/images/phoneScreenshots/3.png    |  Bin 0 -> 253726 bytes
 .../android/en-US/images/phoneScreenshots/4.png    |  Bin 0 -> 436580 bytes
 .../android/en-US/images/phoneScreenshots/5.png    |  Bin 0 -> 974051 bytes
 .../android/en-US/images/phoneScreenshots/6.png    |  Bin 0 -> 171825 bytes
 .../metadata/android/en-US/short_description.txt   |    1 +
 android/fastlane/metadata/android/en-US/title.txt  |    1 +
 android/fastlane/report.xml                        |   23 +
 android/gradle.properties                          |    8 +
 android/gradle/wrapper/gradle-wrapper.properties   |    6 +
 android/settings.gradle.kts                        |   28 +
 assets/logo/img/logo.png                           |  Bin 0 -> 88369 bytes
 assets/logo/img/logo_background.png                |  Bin 0 -> 20535 bytes
 assets/logo/img/logo_font.png                      |  Bin 0 -> 24050 bytes
 assets/logo/img/logo_foreground.png                |  Bin 0 -> 84562 bytes
 assets/logo/img/logo_mono.png                      |  Bin 0 -> 84163 bytes
 assets/logo/img/logo_standalone.png                |  Bin 0 -> 201052 bytes
 assets/logo/mini/logo_font_mini.png                |  Bin 0 -> 7243 bytes
 assets/logo/mini/logo_mini.png                     |  Bin 0 -> 10370 bytes
 assets/logo/mini/logo_mono_mini.png                |  Bin 0 -> 6507 bytes
 assets/logo/vector/logo.svg                        |   22 +
 assets/logo/vector/logo_background.svg             |   10 +
 assets/logo/vector/logo_foreground.svg             |   15 +
 assets/logo/vector/logo_mono.svg                   |   20 +
 assets/logo/vector/logo_notification.svg           |   20 +
 assets/logo/vector/logo_standalone.svg             |   22 +
 assets/sas-emoji.json                              | 2178 +++++++++++
 assets/sounds/call_attention.mp3                   |  Bin 0 -> 50991 bytes
 assets/sounds/call_join.mp3                        |  Bin 0 -> 35108 bytes
 assets/sounds/call_leave.mp3                       |  Bin 0 -> 35108 bytes
 assets/sounds/call_ring.mp3                        |  Bin 0 -> 100310 bytes
 assets/sounds/call_wait.mp3                        |  Bin 0 -> 67709 bytes
 assets/sounds/notification.mp3                     |  Bin 0 -> 46811 bytes
 assets/vodozemac/.gitignore                        |    1 +
 assets/vodozemac/0.8.1/.gitkeep                    |    0
 config.sample.json                                 |   32 +
 dart_dependency_validator.yaml                     |    9 +
 devtools_options.yaml                              |    8 +
 fastlane/README.md                                 |   10 +
 fastlane/metadata                                  |    1 +
 integration_test/.gitignore                        |    6 +
 integration_test/data/environment_constants.dart   |   19 +
 integration_test/data/integration_users.env        |    5 +
 integration_test/flows/auth_flows.dart             |   75 +
 integration_test/flows/basic_messaging.dart        |   29 +
 integration_test/flows/chat_flows.dart             |   42 +
 integration_test/flows/login_and_chat_backup.dart  |   64 +
 integration_test/flows/multi_account.dart          |   37 +
 integration_test/mobile_test.dart                  |   25 +
 integration_test/synapse/data/homeserver.yaml      | 2781 ++++++++++++++
 integration_test/synapse/data/localhost.log.config |   27 +
 .../synapse/data/localhost.signing.key             |    1 +
 integration_test/utils/fluffy_chat_tester.dart     |  128 +
 ios/.gitignore                                     |   33 +
 .../Base.lproj/MainInterface.storyboard            |   24 +
 ios/FluffyChat Share/FluffyChat Share.entitlements |   10 +
 ios/FluffyChat Share/Info.plist                    |   52 +
 ios/FluffyChat Share/ShareViewController.swift     |   28 +
 ios/Flutter/AppFrameworkInfo.plist                 |   24 +
 ios/Flutter/Debug.xcconfig                         |    2 +
 ios/Flutter/Release.xcconfig                       |    2 +
 ios/Gemfile                                        |    8 +
 ios/Gemfile.lock                                   |  247 ++
 ios/Localizable.xcstrings                          |   58 +
 ios/Notification Service Extension/Info.plist      |   13 +
 .../Notification Service Extension.entitlements    |   10 +
 .../NotificationService.swift                      |  416 ++
 ios/Podfile                                        |   71 +
 ios/Runner.xcodeproj/project.pbxproj               | 1163 ++++++
 .../project.xcworkspace/contents.xcworkspacedata   |    7 +
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 +
 .../xcshareddata/WorkspaceSettings.xcsettings      |    8 +
 .../xcshareddata/swiftpm/Package.resolved          |   14 +
 .../xcshareddata/xcschemes/Runner.xcscheme         |  112 +
 ios/Runner.xcworkspace/contents.xcworkspacedata    |   10 +
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 +
 .../xcshareddata/WorkspaceSettings.xcsettings      |    8 +
 .../xcshareddata/swiftpm/Package.resolved          |   14 +
 ios/Runner/AppDelegate.swift                       |   18 +
 .../AppIcon.appiconset/Contents.json               |    1 +
 .../AppIcon.appiconset/Icon-App-1024x1024@1x.png   |  Bin 0 -> 45696 bytes
 .../AppIcon.appiconset/Icon-App-20x20@1x.png       |  Bin 0 -> 692 bytes
 .../AppIcon.appiconset/Icon-App-20x20@2x.png       |  Bin 0 -> 1501 bytes
 .../AppIcon.appiconset/Icon-App-20x20@3x.png       |  Bin 0 -> 2540 bytes
 .../AppIcon.appiconset/Icon-App-29x29@1x.png       |  Bin 0 -> 1078 bytes
 .../AppIcon.appiconset/Icon-App-29x29@2x.png       |  Bin 0 -> 2249 bytes
 .../AppIcon.appiconset/Icon-App-29x29@3x.png       |  Bin 0 -> 3444 bytes
 .../AppIcon.appiconset/Icon-App-40x40@1x.png       |  Bin 0 -> 1501 bytes
 .../AppIcon.appiconset/Icon-App-40x40@2x.png       |  Bin 0 -> 3119 bytes
 .../AppIcon.appiconset/Icon-App-40x40@3x.png       |  Bin 0 -> 4781 bytes
 .../AppIcon.appiconset/Icon-App-50x50@1x.png       |  Bin 0 -> 1947 bytes
 .../AppIcon.appiconset/Icon-App-50x50@2x.png       |  Bin 0 -> 3911 bytes
 .../AppIcon.appiconset/Icon-App-57x57@1x.png       |  Bin 0 -> 2255 bytes
 .../AppIcon.appiconset/Icon-App-57x57@2x.png       |  Bin 0 -> 4590 bytes
 .../AppIcon.appiconset/Icon-App-60x60@2x.png       |  Bin 0 -> 4781 bytes
 .../AppIcon.appiconset/Icon-App-60x60@3x.png       |  Bin 0 -> 7182 bytes
 .../AppIcon.appiconset/Icon-App-72x72@1x.png       |  Bin 0 -> 3178 bytes
 .../AppIcon.appiconset/Icon-App-72x72@2x.png       |  Bin 0 -> 6640 bytes
 .../AppIcon.appiconset/Icon-App-76x76@1x.png       |  Bin 0 -> 3392 bytes
 .../AppIcon.appiconset/Icon-App-76x76@2x.png       |  Bin 0 -> 6841 bytes
 .../AppIcon.appiconset/Icon-App-83.5x83.5@2x.png   |  Bin 0 -> 6634 bytes
 .../LaunchImage.imageset/Contents.json             |   23 +
 .../LaunchImage.imageset/LaunchImage.png           |  Bin 0 -> 68 bytes
 .../LaunchImage.imageset/LaunchImage@2x.png        |  Bin 0 -> 68 bytes
 .../LaunchImage.imageset/LaunchImage@3x.png        |  Bin 0 -> 68 bytes
 .../Assets.xcassets/LaunchImage.imageset/README.md |    5 +
 ios/Runner/Base.lproj/LaunchScreen.storyboard      |   37 +
 ios/Runner/Base.lproj/Main.storyboard              |   26 +
 ios/Runner/GoogleService-Info.plist                |   34 +
 ios/Runner/Info.plist                              |  138 +
 ios/Runner/Runner-Bridging-Header.h                |    1 +
 ios/Runner/Runner.entitlements                     |   16 +
 ios/Runner/ar.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/ar.lproj/Main.strings                   |    1 +
 ios/Runner/ca.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/ca.lproj/Main.strings                   |    1 +
 ios/Runner/cs.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/cs.lproj/Main.strings                   |    1 +
 ios/Runner/de.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/de.lproj/Main.strings                   |    1 +
 ios/Runner/eo.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/eo.lproj/Main.strings                   |    1 +
 ios/Runner/es.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/es.lproj/Main.strings                   |    1 +
 ios/Runner/et.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/et.lproj/Main.strings                   |    1 +
 ios/Runner/eu.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/eu.lproj/Main.strings                   |    1 +
 ios/Runner/fr.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/fr.lproj/Main.strings                   |    1 +
 ios/Runner/gl.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/gl.lproj/Main.strings                   |    1 +
 ios/Runner/hr-HR.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/hr-HR.lproj/Main.strings                |    1 +
 ios/Runner/hu-HU.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/hu-HU.lproj/Main.strings                |    1 +
 ios/Runner/hu.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/hu.lproj/Main.strings                   |    1 +
 ios/Runner/hy.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/hy.lproj/Main.strings                   |    1 +
 ios/Runner/it.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/it.lproj/Main.strings                   |    1 +
 ios/Runner/ja.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/ja.lproj/Main.strings                   |    1 +
 ios/Runner/nb-NO.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/nb-NO.lproj/Main.strings                |    1 +
 ios/Runner/notification.caf                        |  Bin 0 -> 178050 bytes
 ios/Runner/pl.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/pl.lproj/Main.strings                   |    1 +
 ios/Runner/pt.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/pt.lproj/Main.strings                   |    1 +
 ios/Runner/ru-RU.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/ru-RU.lproj/Main.strings                |    1 +
 ios/Runner/sk-SK.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/sk-SK.lproj/Main.strings                |    1 +
 ios/Runner/sv-SE.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/sv-SE.lproj/Main.strings                |    1 +
 ios/Runner/tr.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/tr.lproj/Main.strings                   |    1 +
 ios/Runner/uk.lproj/LaunchScreen.strings           |    1 +
 ios/Runner/uk.lproj/Main.strings                   |    1 +
 ios/Runner/vi-VN.lproj/LaunchScreen.strings        |    1 +
 ios/Runner/vi-VN.lproj/Main.strings                |    1 +
 ios/Runner/zh-Hans.lproj/LaunchScreen.strings      |    1 +
 ios/Runner/zh-Hans.lproj/Main.strings              |    1 +
 l10n.yaml                                          |   12 +
 lib/config/app_config.dart                         |   68 +
 lib/config/isrg_x1.dart                            |   37 +
 lib/config/isrg_x2.dart                            |   20 +
 lib/config/routes.dart                             |  532 +++
 lib/config/setting_keys.dart                       |  261 ++
 lib/config/themes.dart                             |  155 +
 lib/l10n/intl_ar.arb                               | 2673 +++++++++++++
 lib/l10n/intl_az.arb                               |   14 +
 lib/l10n/intl_be.arb                               | 2823 ++++++++++++++
 lib/l10n/intl_bn.arb                               | 1865 +++++++++
 lib/l10n/intl_bo.arb                               | 1974 ++++++++++
 lib/l10n/intl_ca.arb                               | 2504 ++++++++++++
 lib/l10n/intl_cs.arb                               | 2393 ++++++++++++
 lib/l10n/intl_da.arb                               | 1861 +++++++++
 lib/l10n/intl_de.arb                               | 2844 ++++++++++++++
 lib/l10n/intl_el.arb                               | 1880 +++++++++
 lib/l10n/intl_en.arb                               | 2819 ++++++++++++++
 lib/l10n/intl_eo.arb                               | 2122 +++++++++++
 lib/l10n/intl_es.arb                               | 2669 +++++++++++++
 lib/l10n/intl_et.arb                               | 2839 ++++++++++++++
 lib/l10n/intl_eu.arb                               | 2579 +++++++++++++
 lib/l10n/intl_fa.arb                               | 2503 ++++++++++++
 lib/l10n/intl_fi.arb                               | 2456 ++++++++++++
 lib/l10n/intl_fil.arb                              | 1997 ++++++++++
 lib/l10n/intl_fr.arb                               | 2837 ++++++++++++++
 lib/l10n/intl_ga.arb                               | 2842 ++++++++++++++
 lib/l10n/intl_gl.arb                               | 2836 ++++++++++++++
 lib/l10n/intl_he.arb                               | 2053 ++++++++++
 lib/l10n/intl_hi.arb                               | 1849 +++++++++
 lib/l10n/intl_hr.arb                               | 2479 ++++++++++++
 lib/l10n/intl_hu.arb                               | 2431 ++++++++++++
 lib/l10n/intl_ia.arb                               | 1992 ++++++++++
 lib/l10n/intl_id.arb                               | 2806 ++++++++++++++
 lib/l10n/intl_ie.arb                               | 2013 ++++++++++
 lib/l10n/intl_it.arb                               | 2554 +++++++++++++
 lib/l10n/intl_ja.arb                               | 2242 +++++++++++
 lib/l10n/intl_ka.arb                               | 1962 ++++++++++
 lib/l10n/intl_kab.arb                              | 2353 ++++++++++++
 lib/l10n/intl_ko.arb                               | 2398 ++++++++++++
 lib/l10n/intl_la.arb                               |  138 +
 lib/l10n/intl_lt.arb                               | 1963 ++++++++++
 lib/l10n/intl_lv.arb                               | 2816 ++++++++++++++
 lib/l10n/intl_nb.arb                               | 2853 ++++++++++++++
 lib/l10n/intl_nl.arb                               | 2827 ++++++++++++++
 lib/l10n/intl_pl.arb                               | 2711 +++++++++++++
 lib/l10n/intl_pt.arb                               | 2001 ++++++++++
 lib/l10n/intl_pt_BR.arb                            | 2471 ++++++++++++
 lib/l10n/intl_pt_PT.arb                            | 2204 +++++++++++
 lib/l10n/intl_ro.arb                               | 2194 +++++++++++
 lib/l10n/intl_ru.arb                               | 2690 +++++++++++++
 lib/l10n/intl_sk.arb                               | 1221 ++++++
 lib/l10n/intl_sl.arb                               | 1926 ++++++++++
 lib/l10n/intl_sq.arb                               | 1974 ++++++++++
 lib/l10n/intl_sr.arb                               | 2107 ++++++++++
 lib/l10n/intl_sv.arb                               | 2707 +++++++++++++
 lib/l10n/intl_ta.arb                               | 2754 ++++++++++++++
 lib/l10n/intl_te.arb                               | 1977 ++++++++++
 lib/l10n/intl_th.arb                               | 1875 +++++++++
 lib/l10n/intl_tr.arb                               | 2361 ++++++++++++
 lib/l10n/intl_uk.arb                               | 2552 +++++++++++++
 lib/l10n/intl_uz.arb                               | 2468 ++++++++++++
 lib/l10n/intl_vi.arb                               | 1958 ++++++++++
 lib/l10n/intl_yue_Hant.arb                         | 1889 +++++++++
 lib/l10n/intl_zh.arb                               | 2836 ++++++++++++++
 lib/l10n/intl_zh_Hant.arb                          | 2428 ++++++++++++
 lib/main.dart                                      |  180 +
 lib/pages/archive/archive.dart                     |   75 +
 lib/pages/archive/archive_view.dart                |   79 +
 lib/pages/bootstrap/bootstrap_page.dart            |   96 +
 .../bootstrap/view_model/bootstrap_state.dart      |   35 +
 .../bootstrap/view_model/bootstrap_view_model.dart |  302 ++
 .../bootstrap/widgets/new_passphrase_view.dart     |  129 +
 .../bootstrap/widgets/restore_bootstrap_view.dart  |  198 +
 .../bootstrap/widgets/store_recovery_key_view.dart |   63 +
 lib/pages/call/call_page.dart                      |  537 +++
 lib/pages/call/call_tile.dart                      |  140 +
 lib/pages/call/call_view_model.dart                |  621 +++
 lib/pages/call/start_time.dart                     |   43 +
 lib/pages/call/utils/get_call_tiles.dart           |  109 +
 lib/pages/chat/chat.dart                           | 1665 ++++++++
 lib/pages/chat/chat_app_bar_list_tile.dart         |   68 +
 lib/pages/chat/chat_app_bar_title.dart             |  179 +
 lib/pages/chat/chat_emoji_picker.dart              |  125 +
 lib/pages/chat/chat_event_list.dart                |  253 ++
 lib/pages/chat/chat_input_row.dart                 |  436 +++
 lib/pages/chat/chat_view.dart                      |  493 +++
 lib/pages/chat/command_hints.dart                  |   95 +
 lib/pages/chat/encryption_info.dart                |  107 +
 lib/pages/chat/event_info_dialog.dart              |  108 +
 lib/pages/chat/events/audio_player.dart            |  552 +++
 lib/pages/chat/events/cute_events.dart             |  195 +
 .../chat/events/file_send_status_indicator.dart    |   35 +
 lib/pages/chat/events/html_message.dart            |  743 ++++
 lib/pages/chat/events/image_bubble.dart            |  175 +
 lib/pages/chat/events/map_bubble.dart              |  105 +
 lib/pages/chat/events/message.dart                 | 1039 +++++
 lib/pages/chat/events/message_content.dart         |  321 ++
 .../chat/events/message_download_content.dart      |  124 +
 lib/pages/chat/events/message_reactions.dart       |  208 +
 lib/pages/chat/events/poll.dart                    |  224 ++
 lib/pages/chat/events/reply_content.dart           |  110 +
 lib/pages/chat/events/state_message.dart           |  123 +
 lib/pages/chat/events/video_player.dart            |  163 +
 lib/pages/chat/image_edit_geometry.dart            |   37 +
 lib/pages/chat/input_bar.dart                      |  475 +++
 lib/pages/chat/pinned_events.dart                  |  104 +
 lib/pages/chat/recording_input_row.dart            |  107 +
 lib/pages/chat/recording_view_model.dart           |  222 ++
 lib/pages/chat/reply_display.dart                  |   95 +
 lib/pages/chat/seen_by_row.dart                    |   94 +
 lib/pages/chat/send_file_dialog.dart               | 1209 ++++++
 lib/pages/chat/send_location_dialog.dart           |  136 +
 lib/pages/chat/start_poll_bottom_sheet.dart        |  174 +
 lib/pages/chat/sticker_picker_dialog.dart          |  187 +
 lib/pages/chat/trust_user_key_dialog.dart          |  163 +
 lib/pages/chat/typing_indicators.dart              |  103 +
 lib/pages/chat/utd_dialog.dart                     |   76 +
 lib/pages/chat/utils/web_file_to_x_file.dart       |   23 +
 .../chat_access_settings_controller.dart           |  359 ++
 .../chat_access_settings_page.dart                 |  318 ++
 lib/pages/chat_details/chat_details.dart           |  173 +
 lib/pages/chat_details/chat_details_view.dart      |  418 ++
 lib/pages/chat_details/participant_list_item.dart  |  114 +
 .../chat_encryption_settings.dart                  |  121 +
 .../chat_encryption_settings_view.dart             |  246 ++
 lib/pages/chat_list/active_call_indicator.dart     |   49 +
 lib/pages/chat_list/chat_list.dart                 | 1088 ++++++
 lib/pages/chat_list/chat_list_body.dart            |  338 ++
 lib/pages/chat_list/chat_list_header.dart          |  152 +
 lib/pages/chat_list/chat_list_item.dart            |  412 ++
 lib/pages/chat_list/chat_list_view.dart            |  114 +
 lib/pages/chat_list/client_chooser_button.dart     |  241 ++
 lib/pages/chat_list/dummy_chat_list_item.dart      |   77 +
 lib/pages/chat_list/navi_rail_item.dart            |  103 +
 lib/pages/chat_list/navigation_rail.dart           |  137 +
 lib/pages/chat_list/search_title.dart              |   71 +
 lib/pages/chat_list/space_view.dart                |  644 ++++
 lib/pages/chat_list/start_chat_fab.dart            |   35 +
 lib/pages/chat_list/unread_bubble.dart             |   59 +
 lib/pages/chat_members/chat_members.dart           |  120 +
 lib/pages/chat_members/chat_members_view.dart      |  191 +
 .../chat_permissions_settings.dart                 |   78 +
 .../chat_permissions_settings_view.dart            |  151 +
 .../permission_list_tile.dart                      |  130 +
 lib/pages/chat_search/chat_search_files_tab.dart   |  112 +
 lib/pages/chat_search/chat_search_images_tab.dart  |  129 +
 lib/pages/chat_search/chat_search_message_tab.dart |  148 +
 lib/pages/chat_search/chat_search_page.dart        |  143 +
 lib/pages/chat_search/chat_search_view.dart        |  122 +
 lib/pages/chat_search/search_footer.dart           |   72 +
 lib/pages/device_settings/device_settings.dart     |  179 +
 .../device_settings/device_settings_view.dart      |  148 +
 .../device_settings/user_device_list_item.dart     |  154 +
 lib/pages/image_viewer/image_viewer.dart           |  134 +
 lib/pages/image_viewer/image_viewer_view.dart      |  167 +
 lib/pages/image_viewer/pointers_listener.dart      |   60 +
 lib/pages/image_viewer/video_player.dart           |  191 +
 lib/pages/intro/flows/restore_backup_flow.dart     |   38 +
 lib/pages/intro/intro_page.dart                    |  197 +
 lib/pages/intro/intro_page_presenter.dart          |  128 +
 .../invitation_selection/invitation_selection.dart |  129 +
 .../invitation_selection_view.dart                 |  204 +
 .../key_verification/key_verification_dialog.dart  |  402 ++
 lib/pages/login/login.dart                         |  278 ++
 lib/pages/login/login_view.dart                    |  144 +
 lib/pages/new_group/new_group.dart                 |  197 +
 lib/pages/new_group/new_group_view.dart            |  199 +
 lib/pages/new_private_chat/new_private_chat.dart   |  134 +
 .../new_private_chat/new_private_chat_view.dart    |  290 ++
 lib/pages/new_private_chat/qr_scanner_modal.dart   |   80 +
 lib/pages/settings/settings.dart                   |  221 ++
 lib/pages/settings/settings_view.dart              |  219 ++
 lib/pages/settings_3pid/settings_3pid.dart         |  104 +
 lib/pages/settings_3pid/settings_3pid_view.dart    |  119 +
 lib/pages/settings_chat/settings_chat.dart         |   22 +
 lib/pages/settings_chat/settings_chat_view.dart    |  172 +
 .../settings_emotes/import_archive_dialog.dart     |  363 ++
 lib/pages/settings_emotes/settings_emotes.dart     |  422 +++
 .../settings_emotes/settings_emotes_view.dart      |  385 ++
 .../settings_homeserver/settings_homeserver.dart   |   57 +
 .../settings_homeserver_view.dart                  |  303 ++
 .../settings_ignore_list/settings_ignore_list.dart |   67 +
 .../settings_ignore_list_view.dart                 |  101 +
 .../push_rule_extensions.dart                      |  126 +
 .../settings_notifications.dart                    |  196 +
 .../settings_notifications_view.dart               |  254 ++
 lib/pages/settings_password/settings_password.dart |   98 +
 .../settings_password/settings_password_view.dart  |   93 +
 lib/pages/settings_security/settings_security.dart |  166 +
 .../settings_security/settings_security_view.dart  |  253 ++
 lib/pages/settings_style/settings_style.dart       |  141 +
 lib/pages/settings_style/settings_style_view.dart  |  349 ++
 lib/pages/sign_in/sign_in_page.dart                |  247 ++
 .../view_model/model/public_homeserver_data.dart   |   84 +
 lib/pages/sign_in/view_model/sign_in_state.dart    |   15 +
 .../sign_in/view_model/sign_in_view_model.dart     |  114 +
 lib/utils/account_bundles.dart                     |  105 +
 lib/utils/account_config.dart                      |   68 +
 lib/utils/adaptive_bottom_sheet.dart               |   58 +
 lib/utils/background_push.dart                     |  464 +++
 lib/utils/beautify_string_extension.dart           |   31 +
 lib/utils/call_kit_params.dart                     |   89 +
 lib/utils/client_download_content_extension.dart   |  109 +
 lib/utils/client_manager.dart                      |  188 +
 lib/utils/code_highlight_theme.dart                |   45 +
 lib/utils/color_value.dart                         |   19 +
 lib/utils/custom_http_client.dart                  |   41 +
 lib/utils/custom_image_resizer.dart                |  109 +
 lib/utils/custom_scroll_behaviour.dart             |   15 +
 lib/utils/date_time_extension.dart                 |  191 +
 lib/utils/error_reporter.dart                      |  164 +
 lib/utils/event_checkbox_extension.dart            |   31 +
 lib/utils/file_description.dart                    |   29 +
 lib/utils/file_selector.dart                       |   38 +
 lib/utils/fluffy_share.dart                        |   54 +
 lib/utils/init_with_restore.dart                   |  154 +
 lib/utils/localized_exception_extension.dart       |  121 +
 lib/utils/markdown_context_builder.dart            |  142 +
 .../call_keys_event_content.dart                   |  125 +
 .../matrix_live_kit_call.dart                      |  353 ++
 .../matrix_live_kit_call_member.dart               |  135 +
 .../matrix_sdk_extensions/device_extension.dart    |   49 +
 .../matrix_sdk_extensions/event_extension.dart     |   68 +
 .../filtered_timeline_extension.dart               |   57 +
 .../flutter_matrix_dart_sdk_database/builder.dart  |  214 ++
 .../flutter_matrix_dart_sdk_database/cipher.dart   |   88 +
 .../matrix_file_extension.dart                     |   70 +
 lib/utils/matrix_sdk_extensions/matrix_locals.dart |  382 ++
 .../oidc_session_json_extension.dart               |   29 +
 lib/utils/notification_avatar_extension.dart       |   58 +
 lib/utils/notification_background_handler.dart     |  214 ++
 lib/utils/other_party_can_receive.dart             |   26 +
 lib/utils/platform_infos.dart                      |  108 +
 lib/utils/position_from_build_context.dart         |   25 +
 lib/utils/push_helper.dart                         |  547 +++
 lib/utils/resize_video.dart                        |   65 +
 lib/utils/room_status_extension.dart               |   62 +
 lib/utils/show_scaffold_dialog.dart                |   38 +
 lib/utils/show_update_snackbar.dart                |   73 +
 lib/utils/sign_in_flows/calc_redirect_url.dart     |   30 +
 lib/utils/sign_in_flows/check_homeserver.dart      |   95 +
 lib/utils/sign_in_flows/oidc_login.dart            |   92 +
 lib/utils/sign_in_flows/sso_login.dart             |   74 +
 lib/utils/size_string.dart                         |   26 +
 lib/utils/start_push_foreground_service.dart       |   86 +
 lib/utils/stream_extension.dart                    |   53 +
 lib/utils/string_color.dart                        |   25 +
 lib/utils/sync_status_localization.dart            |   31 +
 lib/utils/uia_request_manager.dart                 |  110 +
 lib/utils/url_launcher.dart                        |  253 ++
 lib/utils/verified_room_extension.dart             |   15 +
 .../adaptive_dialogs/adaptive_dialog_action.dart   |  164 +
 .../adaptive_dialogs/dialog_text_field.dart        |  120 +
 .../adaptive_dialogs/public_room_dialog.dart       |  311 ++
 .../adaptive_dialogs/show_modal_action_popup.dart  |  119 +
 .../show_ok_cancel_alert_dialog.dart               |  108 +
 .../adaptive_dialogs/show_text_input_dialog.dart   |  115 +
 lib/widgets/adaptive_dialogs/user_dialog.dart      |  275 ++
 lib/widgets/app_lock.dart                          |  146 +
 lib/widgets/avatar.dart                            |  169 +
 lib/widgets/blur_hash.dart                         |   91 +
 lib/widgets/chat_settings_popup_menu.dart          |  145 +
 lib/widgets/config_viewer.dart                     |  146 +
 lib/widgets/fluffy_chat_app.dart                   |  102 +
 lib/widgets/future_loading_dialog.dart             |  170 +
 lib/widgets/hover_builder.dart                     |   34 +
 lib/widgets/incoming_call_dialog.dart              |  117 +
 lib/widgets/layouts/call_overlay.dart              |   70 +
 lib/widgets/layouts/empty_page.dart                |   37 +
 lib/widgets/layouts/login_scaffold.dart            |  144 +
 lib/widgets/layouts/max_width_body.dart            |   66 +
 lib/widgets/layouts/two_column_layout.dart         |   43 +
 lib/widgets/local_notifications_extension.dart     |  141 +
 lib/widgets/lock_screen.dart                       |  198 +
 lib/widgets/log_view.dart                          |   97 +
 lib/widgets/matrix.dart                            |  435 +++
 lib/widgets/member_actions_popup_menu_button.dart  |  377 ++
 lib/widgets/mxc_image.dart                         |  266 ++
 lib/widgets/mxc_image_viewer.dart                  |   64 +
 lib/widgets/permission_slider_dialog.dart          |   66 +
 lib/widgets/presence_builder.dart                  |   60 +
 lib/widgets/pulsating_widget.dart                  |   69 +
 lib/widgets/qr_code_viewer.dart                    |  144 +
 lib/widgets/settings_switch_list_tile.dart         |   44 +
 lib/widgets/share_scaffold_dialog.dart             |  215 ++
 lib/widgets/theme_builder.dart                     |  103 +
 lib/widgets/typing_animation.dart                  |   71 +
 lib/widgets/unread_rooms_badge.dart                |   48 +
 lib/widgets/view_model_builder.dart                |   48 +
 licenses.yaml                                      |   48 +
 linux/.gitignore                                   |    1 +
 linux/CMakeLists.txt                               |  147 +
 linux/flutter/CMakeLists.txt                       |   88 +
 linux/flutter/generated_plugin_registrant.cc       |   75 +
 linux/flutter/generated_plugin_registrant.h        |   15 +
 linux/flutter/generated_plugins.cmake              |   41 +
 linux/main.cc                                      |    6 +
 linux/my_application.cc                            |  137 +
 linux/my_application.h                             |   18 +
 macos/.gitignore                                   |    7 +
 macos/Flutter/Flutter-Debug.xcconfig               |    2 +
 macos/Flutter/Flutter-Release.xcconfig             |    2 +
 macos/Flutter/GeneratedPluginRegistrant.swift      |   72 +
 macos/Podfile                                      |   43 +
 macos/Podfile.lock                                 |   22 +
 macos/Runner.xcodeproj/project.pbxproj             |  679 ++++
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 +
 .../xcshareddata/xcschemes/Runner.xcscheme         |  117 +
 macos/Runner.xcworkspace/contents.xcworkspacedata  |   10 +
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 +
 macos/Runner/AppDelegate.swift                     |   13 +
 .../AppIcon.appiconset/1024-mac.png                |  Bin 0 -> 21100 bytes
 .../Assets.xcassets/AppIcon.appiconset/128-mac.png |  Bin 0 -> 2868 bytes
 .../Assets.xcassets/AppIcon.appiconset/16-mac.png  |  Bin 0 -> 316 bytes
 .../Assets.xcassets/AppIcon.appiconset/256-mac.png |  Bin 0 -> 5382 bytes
 .../Assets.xcassets/AppIcon.appiconset/32-mac.png  |  Bin 0 -> 878 bytes
 .../Assets.xcassets/AppIcon.appiconset/512-mac.png |  Bin 0 -> 10898 bytes
 .../Assets.xcassets/AppIcon.appiconset/64-mac.png  |  Bin 0 -> 1462 bytes
 .../AppIcon.appiconset/Contents.json               |   64 +
 .../AppIcon.appiconset/app_icon_1024.png           |  Bin 0 -> 45696 bytes
 .../AppIcon.appiconset/app_icon_128.png            |  Bin 0 -> 5089 bytes
 .../AppIcon.appiconset/app_icon_16.png             |  Bin 0 -> 582 bytes
 .../AppIcon.appiconset/app_icon_256.png            |  Bin 0 -> 12054 bytes
 .../AppIcon.appiconset/app_icon_32.png             |  Bin 0 -> 1216 bytes
 .../AppIcon.appiconset/app_icon_512.png            |  Bin 0 -> 21545 bytes
 .../AppIcon.appiconset/app_icon_64.png             |  Bin 0 -> 2499 bytes
 macos/Runner/Base.lproj/MainMenu.xib               |  343 ++
 macos/Runner/Configs/AppInfo.xcconfig              |   14 +
 macos/Runner/Configs/Debug.xcconfig                |    2 +
 macos/Runner/Configs/Release.xcconfig              |    2 +
 macos/Runner/Configs/Warnings.xcconfig             |   13 +
 macos/Runner/DebugProfile.entitlements             |   26 +
 macos/Runner/Info.plist                            |   32 +
 macos/Runner/MainFlutterWindow.swift               |   15 +
 macos/Runner/Release.entitlements                  |   22 +
 pubspec.lock                                       | 2519 ++++++++++++
 pubspec.yaml                                       |  148 +
 recommended_homeservers.json                       |   35 +
 scripts/add-firebase-messaging.sh                  |   17 +
 scripts/build-ios.sh                               |   84 +
 scripts/build-macos.sh                             |   39 +
 scripts/build-windows.ps1                          |   12 +
 scripts/generate-locale-config.sh                  |   36 +
 scripts/generate_command_hints_glue.sh             |   36 +
 scripts/prepare-android-release.sh                 |   19 +
 scripts/prepare-web.sh                             |   50 +
 scripts/prepare-windows.ps1                        |   10 +
 scripts/prepare_integration_test.sh                |   28 +
 scripts/release-ios-testflight.sh                  |   32 +
 scripts/update-license-headers.sh                  |   32 +
 snap/gui/fluffychat.desktop                        |    9 +
 snap/gui/fluffychat.png                            |  Bin 0 -> 17397 bytes
 snap/snapcraft.yaml                                |  149 +
 test/archive_test.dart                             |   16 +
 test/command_hint_test.dart                        |   29 +
 test/homeserver_picker_test.dart                   |   23 +
 test/utils/test_client.dart                        |   48 +
 test/widget_test.dart                              |   26 +
 web/auth.html                                      |   13 +
 web/favicon.png                                    |  Bin 0 -> 762 bytes
 web/icons/Icon-16.png                              |  Bin 0 -> 762 bytes
 web/icons/Icon-192.png                             |  Bin 0 -> 4318 bytes
 web/icons/Icon-32.png                              |  Bin 0 -> 1677 bytes
 web/icons/Icon-48.png                              |  Bin 0 -> 2203 bytes
 web/icons/Icon-512.png                             |  Bin 0 -> 10837 bytes
 web/icons/Icon-maskable-192.png                    |  Bin 0 -> 4318 bytes
 web/icons/Icon-maskable-512.png                    |  Bin 0 -> 10837 bytes
 web/index.html                                     |   63 +
 web/manifest.json                                  |   35 +
 web/native_executor.dart                           |    3 +
 windows/.gitignore                                 |   17 +
 windows/CMakeLists.txt                             |  101 +
 windows/flutter/CMakeLists.txt                     |  104 +
 windows/flutter/generated_plugin_registrant.cc     |   68 +
 windows/flutter/generated_plugin_registrant.h      |   15 +
 windows/flutter/generated_plugins.cmake            |   45 +
 windows/runner/CMakeLists.txt                      |   32 +
 windows/runner/Runner.rc                           |  121 +
 windows/runner/flutter_window.cpp                  |   61 +
 windows/runner/flutter_window.h                    |   33 +
 windows/runner/main.cpp                            |   43 +
 windows/runner/resource.h                          |   16 +
 windows/runner/resources/app_icon.ico              |  Bin 0 -> 1886 bytes
 windows/runner/runner.exe.manifest                 |   20 +
 windows/runner/utils.cpp                           |   64 +
 windows/runner/utils.h                             |   19 +
 windows/runner/win32_window.cpp                    |  245 ++
 windows/runner/win32_window.h                      |   98 +
 647 files changed, 197361 insertions(+)
```

---

## 5. Local Git Reflog (All Recorded Head Movements)
Complete local reflog showing every commit visited, cherry-picked, or checked out.

```text
911b7612b HEAD@{0}: reset: moving to 911b7612b9445c19e47c2d2773d79fa624e55885
5b3406592 HEAD@{1}: checkout: moving from stable-2.10 to main
9dea6165a HEAD@{2}: commit: chore: configure hs.llc.qzz.io, locked chat backup, and safe routes on stable 2.10
a7990dd6d HEAD@{3}: checkout: moving from backup-2.9.5-working to stable-2.10
22daecb54 HEAD@{4}: checkout: moving from v2.10-native-inapp-auth to backup-2.9.5-working
df69b4545 HEAD@{5}: commit: fix(lint): remove unnecessary cast and guard BuildContext with mounted check
ce9728fe2 HEAD@{6}: commit: fix(routes): add register and login routes under settings and support contextual basePath
cc0bdcd1f HEAD@{7}: cherry-pick: fix(chat): extend sendTimelineEventTimeout to 180s for media uploads and guard web notifications
911b7612b HEAD@{8}: commit (cherry-pick): fix(chat): allow immediate message composition without blocking on async key loading
6d3db7482 HEAD@{9}: cherry-pick: feat(search): support automatic homeserver domain resolution for plain username and @username search
34f11a6aa HEAD@{10}: cherry-pick: fix(search): strictly validate user profile with server before displaying in search
f1de3c9f0 HEAD@{11}: cherry-pick: fix(settings): ensure default values display correctly as ON and enable double-tap-to-react
3e41c2860 HEAD@{12}: commit: fix(settings): lock chat backup to active and dimmed
a7990dd6d HEAD@{13}: checkout: moving from official-fluffychat-2.10 to v2.10-native-inapp-auth
26c17d215 HEAD@{14}: commit: fix(chat): extend sendTimelineEventTimeout to 180s for media uploads and guard web notifications
f23daad77 HEAD@{15}: commit: fix(chat): allow immediate message composition without blocking on async key loading
ac0469348 HEAD@{16}: commit: feat(search): support automatic homeserver domain resolution for plain username and @username search
130c21ca8 HEAD@{17}: commit: fix(search): strictly validate user profile with server before displaying in search
1335982a9 HEAD@{18}: commit: fix(settings): ensure default values display correctly as ON and enable double-tap-to-react
69638df03 HEAD@{19}: checkout: moving from backup-2.9.5-working to official-fluffychat-2.10
22daecb54 HEAD@{20}: commit: chore: save working state before official 2.10 upgrade
78608546f HEAD@{21}: checkout: moving from native-inapp-auth to backup-2.9.5-working
78608546f HEAD@{22}: commit: fix(lint): add @override annotation to noPermission
d3504c4c2 HEAD@{23}: commit: fix(lint): clean up analyzer warnings and add direct dependencies
5b3406592 HEAD@{24}: checkout: moving from main to native-inapp-auth
5b3406592 HEAD@{25}: commit: feat(auth): 100% native in-app registration with UIAA and zero-friction crypto setup
2b3c09458 HEAD@{26}: commit: feat: custom auth, silent auto-crypto vault, auto-verify, and non-toggleable backup
30492f882 HEAD@{27}: clone: from https://github.com/krille-chan/fluffychat.git
```

---
Generated on: $(date -u)
