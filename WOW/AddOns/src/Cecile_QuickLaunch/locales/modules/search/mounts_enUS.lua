----------------------------------------------------------------------------------------------------
-- localized English (mounts module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--mounts module
L["MOUNTS_MOUNT"] = "Mount: "
L["MOUNT_FAVORITE"] = " (favorite)"
L["MOUNT_DISMOUNT"] = "Mount: Dismount"
L["MOUNT_RANDOM"] = "Mount: Random (favorite)"