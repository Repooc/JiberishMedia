JiberishMedia is a World of Warcraft addon that provides shared media resources for use with LibSharedMedia which is used by many addons. This addon is used by JiberishUI and other various addons like some of my other profile installers.

---

Features
- Supports: **Retail**, **Classic Era**, **Burning Crusade Classic**, and **Mists of Pandaria Classic**
- Contains 18 fonts with documented redistribution licenses (Rubik, Russo One, Poppins, etc.)
- Includes custom statusbars for UI elements
- Works with **ElvUI**, **EllesmereUI**, and other addons that use LibSharedMedia
- Includes LibStub, CallbackHandler-1.0, and LibSharedMedia-3.0; no other addon is required to register its media

Install the `JiberishMedia` folder in `Interface/AddOns`, enable it, and restart WoW.
Select the fonts and bar textures in your UI addon's settings. In EllesmereUI,
open `/eui` and use the font or bar texture selectors. Installing the pack makes
the media available; it does not change your selected fonts or textures.

Font copyrights and complete license texts are in `JiberishMedia/licenses/`.
Bundled library sources and licenses are listed in `JiberishMedia/Libs/README.md`.

The font license cleanup removes BigNoodleToo, both Gotham files, Gilroy,
Kabisat Demo, and Lixdu because permission to redistribute these files with the
addon has not been established. If a UI profile selects one of these fonts,
choose a retained font in that UI's settings after restarting WoW.

Development checks: run `lua5.1 tests/shared_media.lua` and
`python3 tests/font_licenses.py` from the repository root.
Check built packages with `python3 tests/font_licenses.py --archives .release`.
Branch pushes and pull requests validate and package without uploading. Version
tags continue to use the release workflow.

---

Important Notes
- Join the Discord for Support
- Do *not* upload or redistribute this addon on other websites or addon platforms.
- Do *not* modify and share altered versions of JiberishUI.
- You may use and play with the addon freely for personal in-game use.

---

Community & Support
- Discord: https://discord.gg/jiberish
- Patreon: https://patreon.com/jiberishui
- YouTube: https://www.youtube.com/@jiberishui
- Website: https://jiberishui.com

---

License
All rights reserved for JiberishUI-owned material. Third-party fonts and
libraries retain their own licenses and redistribution rights.
See LICENSE.md and the bundled notices for full details.

© [2025] JiberishUI, LLC – All Rights Reserved
Contact: jiberishui@gmail.com

---

Thank you for supporting custom UI design and the WoW addon community!
