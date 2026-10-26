-- Run with Lua 5.1 from the repository root. Optional argument: addon folder.
local root = arg[1] or "JiberishMedia"
local files = {}
for line in io.lines(root .. "/JiberishMedia.toc") do
    line = line:match("^%s*(.-)%s*$")
    assert(not line:match("^##%s*Dependencies:"), "Media pack must not require another addon")
    if line ~= "" and not line:match("^#") then
        files[#files + 1] = line:gsub("\\", "/")
    end
end
assert(files[#files] == "Media.lua", "Libraries must load before Media.lua")

local function exists(path)
    local file = io.open(path, "rb")
    if file then file:close(); return true end
    return false
end

local function knownFile(path)
    local relative = path:gsub("\\", "/"):match("^[Ii]nterface/[Aa]dd[Oo]ns/JiberishMedia/(.+)$")
    if not relative then return false end
    return exists(root .. "/" .. relative) or exists(root .. "/" .. relative .. ".tga")
end

local function environment()
    local env = setmetatable({}, { __index = _G })
    env._G = env
    env.getfenv = function() return env end
    env.GetLocale = function() return "enUS" end
    env.C_UIFileAsset = { IsKnownFile = knownFile }
    env.geterrorhandler = function() return error end
    env.securecallfunction = function(fn, ...) return fn(...) end
    env.bit = { band = function(a, b)
        local result, bit = 0, 1
        while a > 0 and b > 0 do
            if a % 2 == 1 and b % 2 == 1 then result = result + bit end
            a, b, bit = math.floor(a / 2), math.floor(b / 2), bit * 2
        end
        return result
    end }
    return env
end

local function load(env, file)
    local chunk = assert(loadfile(root .. "/" .. file))
    setfenv(chunk, env)
    chunk()
end

local function loadAddon(env)
    for _, file in ipairs(files) do load(env, file) end
end

local function checkMedia(env)
    assert(env.ElvUI == nil and env.EllesmereUI == nil, "UI globals must not be needed")
    local lsm = env.LibStub("LibSharedMedia-3.0")
    local expected = 0
    for line in io.lines(root .. "/Media.lua") do
        local kind, name, path = line:match('LSM:Register%("([^"]+)", "([^"]+)", %[%[(.-)%]%]%)')
        if kind then
            expected = expected + 1
            assert(knownFile(path), "Missing asset: " .. path)
            assert(lsm:Fetch(kind, name, true) == path, "Media not available: " .. name)
            assert(lsm:HashTable(kind)[name] == path, "Dropdown lookup missing: " .. name)
            local listed = false
            for _, entry in ipairs(lsm:List(kind)) do
                if entry == name then listed = true end
            end
            assert(listed, "Dropdown list missing: " .. name)
        end
    end
    assert(expected >= 22, "Expected at least the repository's 18 fonts and 4 statusbars")
    return expected
end

local standalone = environment()
loadAddon(standalone)
local total = checkMedia(standalone)
local original = standalone.LibStub("LibSharedMedia-3.0")
loadAddon(standalone)
assert(standalone.LibStub("LibSharedMedia-3.0") == original)
checkMedia(standalone)
print("PASS: standalone and repeated loading (" .. total .. " media entries)")

-- Simulate an existing provider with equal, newer, or older library versions.
-- Registrations and listeners must survive; newer methods must not be replaced.
for _, delta in ipairs({ 0, 1, -1 }) do
    local env = environment()
    for i = 1, #files - 1 do load(env, files[i]) end
    local lsm, minor = env.LibStub("LibSharedMedia-3.0")
    env.LibStub.minors["LibSharedMedia-3.0"] = minor + delta
    local oldRegister = lsm.Register
    lsm:List("font") -- Exercise lists cached by an earlier-loading UI.
    lsm:Register("statusbar", "Existing provider", [[Interface\Addons\JiberishMedia\statusbar\Jiberwatch.tga]])
    local owner, notifications = {}, 0
    lsm.RegisterCallback(owner, "LibSharedMedia_Registered", function()
        notifications = notifications + 1
    end)
    loadAddon(env)
    assert(env.LibStub("LibSharedMedia-3.0") == lsm, "Shared instance replaced")
    assert(lsm:IsValid("statusbar", "Existing provider"), "Existing registration lost")
    assert(notifications == checkMedia(env), "Late-registration notifications missing")
    if delta >= 0 then assert(lsm.Register == oldRegister, "Existing library downgraded") end
    assert(env.LibStub.minors["LibSharedMedia-3.0"] == minor + math.max(delta, 0))
    print("PASS: existing library, version delta " .. delta)
end

local missing = environment()
load(missing, "Media.lua") -- Defensive behavior if an installation is incomplete.
load(missing, files[1])
load(missing, "Media.lua")
print("PASS: missing library guards")

-- Additional arguments may name installed UIs' actual LibSharedMedia files.
for i = 2, #arg do
    for _, providerFirst in ipairs({ true, false }) do
        local env = environment()
        load(env, files[1])
        load(env, files[2])
        if not providerFirst then loadAddon(env) end
        local provider = assert(loadfile(arg[i]))
        setfenv(provider, env)
        provider()
        local lsm = env.LibStub("LibSharedMedia-3.0")
        if providerFirst then loadAddon(env) end
        assert(env.LibStub("LibSharedMedia-3.0") == lsm, "Provider instance replaced")
        checkMedia(env)
        print("PASS: installed provider " .. arg[i] .. " (provider first: " .. tostring(providerFirst) .. ")")
    end
end
