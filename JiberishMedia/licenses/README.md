# Font licenses

The bundled fonts retain their original licenses. JiberishUI's addon license
does not replace or restrict rights granted by these third-party licenses.

- `FONT-NOTICES.txt` preserves the copyright, attribution, trademark, and license
  notices for every bundled font, including Reserved Font Names where stated.
- `OFL-1.1.txt` contains the full SIL Open Font License 1.1 for the OFL fonts.
- `Apache-2.0.txt` contains the full Apache License 2.0 for this version of Luckiest Guy.
- `fonts.json` maps every font to its license, copyright, version, and SHA-256.
  The font binaries and their embedded notices have not been modified.

OFL source: https://openfontlicense.org/open-font-license-official-text/
Apache source for Luckiest Guy: https://github.com/google/fonts/blob/main/apache/luckiestguy/LICENSE.txt

When updating or adding a font, first verify permission to distribute the actual
font file with the addon. Keep the original notices and complete license text,
then update the inventory and its checksum. A personal-use or desktop-use grant
alone does not establish that permission.

The 2026-10-26 cleanup removes fonts with restrictive or unverified redistribution
terms. Existing UI profiles that select a removed font may need a new font chosen
in their UI settings. Available alternatives include Rubik, Poppins, Urbanist,
Space Grotesk, and Russo One. Retained media names and paths are unchanged.

Bundled Lua libraries have their own notices in `../Libs/README.md`.
