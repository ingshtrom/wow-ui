-------------------------------------------------------------------------------
--  Module Declaration

local mod = BigWigs:NewBoss("Isiset", 759)
if not mod then return end
mod.partyContent = true
mod:RegisterEnableMob(39587)
mod.toggleOptions = {74373, 74137, "split", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local split1 = nil

-------------------------------------------------------------------------------
--  Localization

local L = mod:NewLocale("enUS", true)
if L then
