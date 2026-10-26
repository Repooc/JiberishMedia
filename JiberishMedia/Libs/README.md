# Bundled libraries

These libraries are distributed as unmodified source and retain their own
licenses, independently of the JiberishMedia artwork and addon license.
Load order is LibStub, CallbackHandler-1.0, then LibSharedMedia-3.0, before
Media.lua. LibStub shares the newest library instance with other addons.

- **LibStub 1.0, minor 2**: public domain, as stated in its source header.
  Source: https://github.com/WoWUIDev/Ace3/blob/5a9344990ef9b437012e9d9e8531c3c6f88f4f8e/LibStub/LibStub.lua
- **CallbackHandler-1.0, minor 8**: Ace3 BSD-style license; see
  `CallbackHandler-1.0/LICENSE.txt`.
  Source: https://github.com/WoWUIDev/Ace3/blob/5a9344990ef9b437012e9d9e8531c3c6f88f4f8e/CallbackHandler-1.0/CallbackHandler-1.0.lua
- **LibSharedMedia-3.0 v12.1.3, minor 12000005**: LGPL 2.1, as stated
  in its source header; see `LibSharedMedia-3.0/LICENSE.txt`.
  Source: https://repos.wowace.com/wow/libsharedmedia-3-0/tags/v12.1.3/LibSharedMedia-3.0/LibSharedMedia-3.0.lua

When updating a library, retain the upstream source and license and run the
standalone/shared-instance checks in `tests/shared_media.lua`.
