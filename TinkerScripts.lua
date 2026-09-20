--[[

	This file is part of TinkerScripts.
	Copyright (C) 2026 ImagineNothing

	TinkerScripts is free software. You can redistribute it and/or modify it
	under the terms of the GNU GPLv3 (or later), as published by the Free Software Foundation:

	see LICENSE or <https://www.gnu.org/licenses/> for all the details.

]]

natives.load_natives()
local cls = "                                            \r"
local lual = "\r\27[9C]\27[94m[INFO/LuaScript]\27[m "
local lual_s = ": \27[92mInitialized successfully\27[m                           "
local function IsOnline() return NETWORK.NETWORK_IS_SESSION_STARTED() and not NETWORK.NETWORK_IS_IN_TRANSITION() and not STREAMING.IS_PLAYER_SWITCH_IN_PROGRESS() and not NETWORK.NETWORK_IS_ACTIVITY_SESSION() end

---|| Submenu ||----------------------------------------------------------------------------------

local TS_BUILD = "1158.16"
local versionPtrn = memory.scan_pattern("4C 8D 0D ? ? ? ? 48 8D 5C 24 ? 48 89 D9 48 89 FA") -- from the menu
local GameVersion = versionPtrn:add(3):rip():get_string()

if GameVersion ~= TS_BUILD then
    notify.error("TinkeScripts - WRONG GAME BUILD", string.format("TinkeScripts: %s\nCurrent Game Build: %s", TS_BUILD, GameVersion))
    log.error(string.format("\27[2A]\r\27[18C\27[31m[EROR/LuaScript]\27[m TinkerScripts: WRONG GAME BUILD: %s | TinkeScripts: %s %s\27[B]                %s   \27[2A", GameVersion, TS_BUILD, cls, cls)) return
end

local TinkerPath = FileMgr.GetMenuRootPath()
local TS_PATH_Blips = FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/Blips.lua") load(TS_PATH_Blips)()
local TS_PATH_Unlocks = FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/TS_RecoveryPlus/Unlocks.lua") load(TS_PATH_Unlocks)()
local TS_PATH_Tunables = FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/TS_RecoveryPlus/Tunables.lua") load(TS_PATH_Tunables)()
local TS_PATH_FMCharTats = FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/HumanCanvas/FMCharTats.lua") load(TS_PATH_FMCharTats)()
local function TS_PATH_Settings() return FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/Settings/TS_Settings.lua") end load(TS_PATH_Settings())()
local function TS_PATH_FMCharTatCombo() return FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/HumanCanvas/Exported_TattooCombo.txt") end
local function TS_PATH_NoCloudSave() return FileMgr.ReadFileContent(TinkerPath.."/TinkerScripts/Settings/BlockCloudSaves/NoSave.txt") end

menu.set_menu_icon("\xef\x81\xae\xef\x81\xae")
local Tinker = menu.get_submenu("TinkerScripts")
local TS_Main = Tinker:add_category("Main")
local TS_Bizteroids = Tinker:add_category("Biz-Teroids")
local TS_PhoneMaster = Tinker:add_category("Phone Master")
local TS_GoonVan = Tinker:add_category("Gun Van Halen")
local TS_RainbowVeh = Tinker:add_category("Rainbow Vehicles")
local TS_RecoveryPlus = Tinker:add_category("Recovery +")
local TS_SettingsPlus = Tinker:add_category("Settings +")

function FindNewSession()
	ScriptFunction("shop_controller", ScriptPointer("SendToClouds", "2D 00 02 00 00 72 5D ? ? ? 72")):call("") -- CALLTHEFUNCTIONCALLTHEFUNCTIONCALLTHEFUNCTION | from the menu
	ScriptGlobal(1575048):set_int(11)
end

function CurPlayerCoords()
	PlaCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), 0)
	PlaHeading = ENTITY.GET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID())
	PlaFwdVec = ENTITY.GET_ENTITY_FORWARD_VECTOR(PLAYER.PLAYER_PED_ID())
end

function scripts.start_new_script(ScriptName, StackSize)
	script.run_in_callback(function()
		if scripts.is_active(ScriptName) then
			scripts.run_as_script(ScriptName, function() SCRIPT.TERMINATE_THIS_THREAD() end)
		end
		SCRIPT.REQUEST_SCRIPT(ScriptName)
		script.yield(50)
		if SCRIPT.HAS_SCRIPT_LOADED(ScriptName) then
			BUILTIN.START_NEW_SCRIPT(ScriptName, StackSize)
			SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(ScriptName)
		end
	end)
end

local screenX, screenY = ImGui.GetDisplaySize()
local nomoretreeplease = util.time()

local function CenteredText(Text, NewSeparator, FakeSeparatorText)
	if not FakeSeparatorText then
		ImGui.SetCursorPosX((ImGui.GetWindowWidth() - ImGui.CalcTextSize(Text)) / 2)
		ImGui.TextDisabled(Text)
		if NewSeparator then ImGui.Separator() end
	else
		ImGui.SeparatorText("")
		ImGui.SameLine()
		ImGui.SetCursorPosX((ImGui.GetWindowWidth() - ImGui.CalcTextSize(Text)) / 2)
		ImGui.Text(Text)
	end
end

local function TpToBlip(KillDelPed, Blip, BEntity)
	if KillDelPed then
		script.run_in_callback(function()
			for _, MissionEnemy in ipairs(entities.get_all_peds_as_handles()) do
				if Ped(MissionEnemy):is_enemy() then
					Entity(MissionEnemy):kill()
				end
			end
			script.yield(300)
			for _, MissionEnemy in ipairs(entities.get_all_peds_as_handles()) do
				if Ped(MissionEnemy):is_dead() then
					Entity(MissionEnemy):delete()
				end
			end
		end)
	end
	local BlipID = HUD.GET_FIRST_BLIP_INFO_ID(Blip)
	if BEntity then
		local BlipH = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(BlipID)
		if Entity(BlipH):is_valid() then
			local BEntityPos = Entity(BlipH):get_position()
			PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), BEntityPos.x, BEntityPos.y, BEntityPos.z + 0.5)
		--else
		--	notify.error("TinkerScript - Teleport to Blip", "No coordinates available!", 3000)
		end
	else
		if HUD.DOES_BLIP_EXIST(BlipID) then
			local blip_coords = HUD.GET_BLIP_INFO_ID_COORD(BlipID)
			PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), blip_coords.x, blip_coords.y, blip_coords.z + 0.5)
		--else
		--	notify.error("TinkerScript - Teleport to Blip", "No coordinates available!", 3000)
		end
	end
end

local function TpToEntity(EntityModel)
	script.run_in_callback(function()
		for _, h in ipairs(entities.get_all_objects_as_handles()) do
			if Entity(h):get_model() == EntityModel then
				local EntityCoords = Entity(h):get_position()
				PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), EntityCoords.x, EntityCoords.y, EntityCoords.z + 0.5) break
			end
		end
	end)
end

---|| Main ||------------------------------------------------------------------------------

local LocationCoords = { -- some from rage.mp
	{ LocName = "Franklin's Aunt's House",	LocDesc = "Teleport to Franklin's Aunt's House",					LocCoords = {-17.95, -1440.61, 31.10} },
	{ LocName = "Franklin's House",			LocDesc = "Teleport to Franklin's House",							LocCoords = {7.61, 538.30, 176.03} },
	{ LocName = "Michael's House",			LocDesc = "Teleport to Michael's House",							LocCoords = {-815.44, 178.77, 72.15} },
	{ LocName = "Trevor's Trailer",			LocDesc = "Teleport to Trevor's Trailer",							LocCoords = {1972.90, 3816.28, 33.42} },
	{ LocName = "Match Winner Room", 	  	LocDesc = "Teleport to Match \"WINNER\" Room", 						LocCoords = {414.4, -977.6, -100.0042} },
	{ LocName = "Character Creation Room",	LocDesc = "Teleport to Character Creation/Selection Room",			LocCoords = {409.13, -999.44, -99.00} },
	{ LocName = "Height Messure", 			LocDesc = "Teleport to Character Height Messure", 					LocCoords = {402.91, -996.90, -99.00} },
	{ LocName = "Omega's Garage", 			LocDesc = "Teleport to Omega's Garage", 							LocCoords = {2331.344, 2574.073, 46.68137} },
	{ LocName = "Lester's House", 			LocDesc = "Teleport to Lester's House", 							LocCoords = {1273.9, -1719.305, 54.77141} },
	{ LocName = "Torture Room", 		  	LocDesc = "Teleport to Torture Room", 								LocCoords = {136.5146, -2203.149, 7.30914} },
	{ LocName = "Split-Sides Comedy Club", 	LocDesc = "Teleport to Split-Sides Comedy Club", 					LocCoords = {382.71, -1001.45, -99.00} },
	{ LocName = "Motel",					LocDesc = "Teleport to Motel",										LocCoords = {152.2605,-1004.471, -98.99999} },
	{ LocName = "FIB Building",				LocDesc = "Teleport to FIB Building",								LocCoords = {134.5835,-749.339, 258.152} },
	{ LocName = "IAA Office",				LocDesc = "Teleport to IAA Office",									LocCoords = {117.22,-620.938, 206.1398} }
}

local function FastRespawn()
	local logresp = {
		"Wasted Screen Skipped!",
		"Player Respawned a thousand times!",
		"Fast-Respawn!",
		"mp_forcerespawnpla... oops, wrong game.",
		"Had to make the script longer somehow.",
		"I Need Healing!",
		"I should be playing Warframe...",
		"Wanna play RnG?",
		"I will not die; not yet, amigo!", -- Skye main since beta btw
		"Kifflom!",
		--"Moar text"
	}
	if ScriptGlobal(2658296):at(PLAYER.PLAYER_ID(), 468):at(236):get_int() == -1 then
		CurPlayerCoords()
		ScriptGlobal(2635562 + 2924):set_int(1)
		--log.info(cls..lual.."Rejack: "..logresp[math.random(#logresp)]..cls)
		script.yield(1500)
		PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), PlaCoords.x, PlaCoords.y, PlaCoords.z)
		ENTITY.SET_ENTITY_HEADING(PLAYER.PLAYER_PED_ID(), PlaHeading)
	end
end

local function FastReload()
	if PAD.IS_CONTROL_JUST_PRESSED(0, 24) then
		local cur_weap = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID())
		script.yield(20)
		WEAPON.SET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), "WEAPON_STICKYBOMB", 0)
		script.yield(200)
		WEAPON.SET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), cur_weap, 1)
	end
end

local function ClearWorld(CwToggle)
	ScriptGlobal(1690468):set_int(CwToggle) -- 1 is the minimum, 0 resets back to default value
	ScriptGlobal(1690469):set_int(CwToggle)
	ScriptGlobal(1690470):set_int(CwToggle)
end

local function GlobalSetBit(global, bitonoff, bits)
	local bitvalue = global:get_int()
	local togglebit = bitonoff
	if togglebit == 1 then
		bitvalue = bit.bor(bitvalue, bit.lshift(1, bits))
	elseif togglebit == 0 then
		bitvalue = bit.band(bitvalue, bit.bnot(bit.lshift(1, bits)))
	end
	global:set_int(bitvalue)
end

local function LocalSetBit(sLocal, bitonoff, bits)
	local bitvalue = sLocal:get_int()
	local togglebit = bitonoff
	if togglebit == 1 then
		bitvalue = bit.bor(bitvalue, bit.lshift(1, bits))
	elseif togglebit == 0 then
		bitvalue = bit.band(bitvalue, bit.bnot(bit.lshift(1, bits)))
	end
	sLocal:set_int(bitvalue)
end

local function RagdollPlayer()
	if PAD.IS_CONTROL_PRESSED(0, 19) then
		PED.SET_PED_TO_RAGDOLL(PLAYER.PLAYER_PED_ID(), 2000, 2000, 0, 0, 0, 0)
	end
end

commandmgr.add_looped_command("fastrespawn", "Fast Respawn", "Skips the WASTED screen.", function()
	FastRespawn()
end, function()
	ScriptGlobal(2709139):set_int(1)
	notify.success("TinkerScript - Rejack", "Fast Respawn Enabled!", 3000)
end, function()
	ScriptGlobal(2709139):set_int(0)
	notify.info("TinkerScript - Rejack", "Fast Respawn Disabled.", 3000)
end)

commandmgr.add_looped_command("fastreload", "Fast Reload", "Similar to Fast Reload macros.", function()
	FastReload()
end, function()
	notify.success("TinkerScript - Fast Reload", "Fast Reload Enabled!", 3000)
end, function()
	notify.info("TinkerScript - Fast Reload", "Fast Reload Disabled.", 3000)
end)

commandmgr.add_bool_command("notm25_bst", "Bullshark Testosterone", "Enables BST", false, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 1, 0)
	notify.success("TinkerScript - BST", "BST Enabled!", 3000)
end, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 1, 2)
	notify.info("TinkerScript - BST", "BST Disabled.", 3000)
end)

local m25_yogaRmulti = 1.15
local m25_yogaSmulti = 2.0
commandmgr.add_bool_command("m25_runboost", "Run/Swim Boost", "Enables Run/Swim Boost.\n*This is essentially the same as \"Super Run\" from Self submenu, but using a global (Not to be confused with \"Fast Run\" stat).", false, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 1, 10)
	notify.success("TinkerScript - Run Boost", "Run Boost Enabled!", 3000)
end, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 0, 10)
	notify.info("TinkerScript - Run Boost", "Run Boost Disabled.", 3000)
end)

commandmgr.add_bool_command("m25_strengthboost", "Strength Boost", "Enables Strength Boost", false, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 1, 6)
	notify.success("TinkerScript - Strength Boost", "Strength Boost Enabled!", 3000)
end, function()
	GlobalSetBit(ScriptGlobal(2673276 + 3768), 0, 6)
	notify.info("TinkerScript - Strength Boost", "Strength Boost Disabled.", 3000)
end)

commandmgr.add_bool_command("clearworld", "Clear World", "Remove all peds and vehicles.", false, function()
	ClearWorld(1)
	notify.success("TinkerScript - Clear World", "Clear World Enabled!", 3000)
end, function()
	ClearWorld(0)
	notify.info("TinkerScript - Clear World", "Clear World Disabled.", 3000)
end)

commandmgr.add_looped_command("ragdoll", "Ragdoll", "Ragdoll on command by pressing [L-ALT]", function()
	RagdollPlayer()
end, function()
	notify.success("TinkerScript - Ragdoll", "Manual Ragdoll Enabled!", 3000)
end, function()
	notify.info("TinkerScript - Ragdoll", "Manual Ragdoll Disabled.", 3000)
end)

commandmgr.add_looped_command("infcombatroll", "Infinite Combat Roll", "& No-Recoil/Spread ;)", function()
	stats.set_int("MPX_SHOOTING_ABILITY", 500)
end, function()
	notify.success("TinkerScript - Infinite Combat Roll", "Infinite Combat Roll Enabled!", 3000)
end, function()
	notify.info("TinkerScript - Infinite Combat Roll", "Infinite Combat Roll Disabled.", 3000)
end)

commandmgr.add_looped_command("noidlecam", "Disable Idle Cam", "Disables Idle Cam.", CAMERA.INVALIDATE_IDLE_CAM)

local VehAutoDrive = {
	Toggle = false,
	Mode = 0,
	Label = { "Normal", "Rushed", "GTA" },
	Flag = { 443, 787118, 1076625980 }
}

VehAutoDrive.SkipRedLight = function(PlaVeh)
	if VehAutoDrive.Flag[VehAutoDrive.Mode + 1] == 787118 and VEHICLE.IS_VEHICLE_STOPPED_AT_TRAFFIC_LIGHTS(PlaVeh) then
		script.yield(4000)
		TASK.SET_DRIVE_TASK_DRIVING_STYLE(PLAYER.PLAYER_PED_ID(), tonumber(bit.band(787118, bit.bnot(bit.lshift(1, 7)))))
		script.yield(2000)
		TASK.SET_DRIVE_TASK_DRIVING_STYLE(PLAYER.PLAYER_PED_ID(), 787118)
	end
end

local AutoDriveSpeed = 40
local function SelfTaxi()
	local PlaVeh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
    if PED.IS_PED_SITTING_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID()) then
        local wp_blip = HUD.GET_FIRST_BLIP_INFO_ID(8)
        if not HUD.DOES_BLIP_EXIST(wp_blip) then
           notify.info("TinkerScript - Self Taxi", "Please set a waypoint first.", 3000) return
        end
        local wp_coords = HUD.GET_BLIP_INFO_ID_COORD(wp_blip)
        TASK.TASK_VEHICLE_DRIVE_TO_COORD(PLAYER.PLAYER_PED_ID(), PlaVeh, wp_coords.x, wp_coords.y, wp_coords.z, AutoDriveSpeed, 0, 0, VehAutoDrive.Flag[VehAutoDrive.Mode + 1], 10.0, 0)
        notify.info("TinkerScript - Self Taxi", "Auto-Drive to Waypoint has started.", 3000)
        while true do
			VEHICLE.SET_VEHICLE_MAX_SPEED(PlaVeh, AutoDriveSpeed)
			CurPlayerCoords()
            local dist = BUILTIN.VDIST(PlaCoords.x, PlaCoords.y, PlaCoords.z, wp_coords.x, wp_coords.y, wp_coords.z)
			if drivemodechanged then TASK.SET_DRIVE_TASK_DRIVING_STYLE(PLAYER.PLAYER_PED_ID(), VehAutoDrive.Flag[VehAutoDrive.Mode + 1]) end
			VehAutoDrive.SkipRedLight(PlaVeh)
            if dist < 70.0 then
                TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID())
				VEHICLE.BRING_VEHICLE_TO_HALT(PlaVeh, 3.0, 1, 0)
                notify.success("TinkerScript - Self Taxi", "Destination reached.", 3000) return
            end
            if PAD.IS_CONTROL_JUST_PRESSED(0, 22) then -- SPACEBAR
                notify.info("TinkerScript - Self Taxi", "Auto-Drive to Waypoint has been canceled.", 3000)
                TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID()) return
            end
            script.yield(0)
        end
    else
        notify.warn("TinkerScript - Self Taxi", "You are not in a vehicle.", 3000)
    end
end

local function Wander() -- Shadow of The Collossus?
	local PlaVeh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false)
	if PED.IS_PED_SITTING_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID()) then
		TASK.TASK_VEHICLE_DRIVE_WANDER(PLAYER.PLAYER_PED_ID(), PlaVeh, AutoDriveSpeed, VehAutoDrive.Flag[VehAutoDrive.Mode + 1])
		notify.info("TinkerScript - Auto-Wander", "Auto-Wander has started.", 3000)
		while true do
			VEHICLE.SET_VEHICLE_MAX_SPEED(PlaVeh, AutoDriveSpeed)
			if drivemodechanged then TASK.SET_DRIVE_TASK_DRIVING_STYLE(PLAYER.PLAYER_PED_ID(), VehAutoDrive.Flag[VehAutoDrive.Mode + 1]) end
			VehAutoDrive.SkipRedLight(PlaVeh)
			if PAD.IS_CONTROL_JUST_PRESSED(0, 22) then -- SPACEBAR
				notify.info("TinkerScript - Auto-Wander", "You took the wheel.", 3000)
				TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID()) return
			end
			script.yield(0)
		end
	else
		notify.warn("TinkerScript - Auto-Wander", "You are not in a vehicle.", 3000)
	end
end

local jr_radius = 10
local function Joyrider(jr_radius)
	CurPlayerCoords()
	local vehicle = VEHICLE.GET_RANDOM_VEHICLE_IN_SPHERE(PlaCoords.x, PlaCoords.y, PlaCoords.z, jr_radius, 0, 101247)
	local drivernomore = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, 0)
	if vehicle ~= 0 and not Vehicle(vehicle):is_seat_free(-1) then
		Entity(drivernomore):delete() -- SPENT 2HRS TRYING TO USE NATIVES JUST TO FIND OUT THIS EXIST AHHHHHHHHHHHHHHHHHHHHHH (DELETE_ENTITY doesn't work)
		PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, -1)
	elseif vehicle ~= 0 and Vehicle(vehicle):is_seat_free(-1) then
		PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), vehicle, -1)
		VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, 0)
		VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, 1, 1, 0)
	else
		notify.info("TinkerScript - Joyrider", "No vehicles in radius ("..jr_radius.."m) detected.\nIncrease your Teleport Radius.", 3000)
	end
end

local DuffelBagSavePatch = {}
commandmgr.add_bool_command("DuffelBagSave", "Enable Duffel Bag Save", "Bypasses Duffel Bag save restrictions at Clothing Stores and Wardrobe.", false, function()
	if not DuffelBagSavePatch.Shop then
		DuffelBagSavePatch.Shop = ScriptPatch("clothes_shop_mp", "DuffelBagSavePatch1", "2C 0D ? ? 56 ? ? 72 2E 01 01 71 2E 01 01 2D 02 04", 7, {0x00})
	end
	if not DuffelBagSavePatch.Wardrobe then
		DuffelBagSavePatch.Wardrobe = ScriptPatch("wardrobe_mp", "DuffelBagSavePatch2", "2C 0D ? ? 56 ? ? 72 2E 01 01 71 2E 01 01 2D 01 03", 7, {0x00})
	end
	DuffelBagSavePatch.Shop:enable()
	DuffelBagSavePatch.Wardrobe:enable()
end, function()
	if DuffelBagSavePatch.Shop then DuffelBagSavePatch.Shop:disable() end
	if DuffelBagSavePatch.Wardrobe then DuffelBagSavePatch.Wardrobe:disable() end
end)

local OR_offsets = {
	0x528, 0x568, 0x5A8, 0x5E8, 0x628,
	0x668, 0x6A8, 0x6E8, 0x728, 0x768,
	0x7A8, 0x7E8, 0x828, 0x868, 0x8A8,
	0x8E8, 0x928, 0x968, 0x9A8, 0x9E8
}

local OR_ptr
local OR_selected = 0
local New_Name = ""
local renamemode = false
local canrename = false
local ibox_checkbox = false
local function ReNameEditor() -- deprecated
	if not canrename then
		if MISC.UPDATE_ONSCREEN_KEYBOARD() == 0 then
			log.info(cls..lual.."Waiting for \"New Name\""..cls)
			MISC.DISPLAY_ONSCREEN_KEYBOARD(0, "CELL_7000", "", New_Name, nil, nil, nil, 64)
			canrename = true
		elseif MISC.UPDATE_ONSCREEN_KEYBOARD() ~= 0 then
			notify.info("TinkerScript - Re-Name Editor", "Open an \"Input Box\" first.", 3000)
			log.info(cls..lual.."Re-Name Editor: \27[33mOpen an \"Input Box\" first.\27[m"..cls.."\n") return
		end
	end
	while canrename do
		local nn = MISC.GET_ONSCREEN_KEYBOARD_RESULT()
		if MISC.UPDATE_ONSCREEN_KEYBOARD() == 1 then
			notify.success("TinkerScript - Re-Name Editor", "New name is:\n"..nn, 3000)
			log.info(string.format("%s%s\27[ARe-Name Editor: \27[32mNew name is:\27[m%s %s%s", cls, lual, nn, cls, cls))
			New_Name = ""
			canrename = false
			return
		elseif MISC.UPDATE_ONSCREEN_KEYBOARD() == 2 then
			notify.info("TinkerScript - Re-Name Editor", "Logic canceled.", 3000)
			log.info(cls..lual.."\27[ARe-Name Editor: Logic canceled.                             \27[B\r                                      "..cls)
			canrename = false
			return
		end
		script.yield(0)
	end
end

local ReN_Style = {
	{ tbLabel = "R* Logo",		tStyle = "∑"},
	{ tbLabel = "Wanted Star",	tStyle = "~ws~"},
	{ tbLabel = "R* Verified",	tStyle = "¦"},
	{ tbLabel = "Lock Icon",	tStyle = "Ω"},
	{ tbLabel = "R* Created",	tStyle = "‹"},
	{ tbLabel = "Blank Icon",	tStyle = "›"},
	{ tbLabel = "Bold",			tStyle = "~h~"},
	{ tbLabel = "Italic",		tStyle = "~italic~"},
	{ tbLabel = "New line",		tStyle = "~n~"},
	{ tbLabel = "Reset",		tStyle = "~s~"}
}

local ReN_Color = {
	{ bName = "##Rednnf",		bTip = "Red",		 tColf = "~r~",	 bCol = {0.870, 0.196, 0.196, 1.0} },
	{ bName = "##Yellownnf",	bTip = "Yellow",	 tColf = "~y~",	 bCol = {0.933, 0.776, 0.313, 1.0} },
	{ bName = "##Bluennf",		bTip = "Blue",		 tColf = "~b~",	 bCol = {0.360, 0.705, 0.890, 1.0} },
	{ bName = "##DarkBluennf",	bTip = "Dark Blue",	 tColf = "~d~",	 bCol = {0.184, 0.361, 0.451, 1.0} },
	{ bName = "##Orangennf",	bTip = "Orange",	 tColf = "~o~",	 bCol = {0.992, 0.517, 0.333, 1.0} },
	{ bName = "##Greennnf",		bTip = "Green",		 tColf = "~g~",	 bCol = {0.443, 0.792, 0.443, 1.0} },
	{ bName = "##Pinknnf",		bTip = "Pink",		 tColf = "~q~",	 bCol = {0.886, 0.309, 0.502, 1.0} },
	{ bName = "##Purplennf",	bTip = "Purple",	 tColf = "~p~",	 bCol = {0.513, 0.396, 0.878, 1.0} },
	{ bName = "##Whitennf",		bTip = "White",		 tColf = "~w~",	 bCol = {1, 1, 1, 1.0} }, -- doing 1.0 makes the button transparent for some reason
	{ bName = "##Greynnf",		bTip = "Grey",		 tColf = "~c~",	 bCol = {0.545, 0.545, 0.545, 1.0} },
	{ bName = "##DarkGreynnf",	bTip = "Dark Grey",	 tColf = "~m~",	 bCol = {0.388, 0.388, 0.388, 1.0} },
	{ bName = "##Blacknnf",		bTip = "Black",		 tColf = "~u~",	 bCol = {0.0, 0.0, 0.0, 1.0} }
}

local ReN_selectedprop
-- local New_PropName = "" -- Replaced with original one
local ReN_Properties = {
	{ renProperty = "Office",			renPropStat = "MPX_GB_OFFICE_NAME",			renPropStat2 = "MPX_GB_OFFICE_NAME2"},
	{ renProperty = "Organization",		renPropStat = "MPX_GB_GANG_NAME",			renPropStat2 = "MPX_GB_GANG_NAME2"},
	{ renProperty = "MC Clubhouse",		renPropStat = "MPX_MC_CLBHOSE_NAME",		renPropStat2 = "MPX_MC_CLBHOSE_NAME2"},
	{ renProperty = "MC Club",			renPropStat = "MPX_MC_GANG_NAME",			renPropStat2 = "MPX_MC_GANG_NAME2"},
	{ renProperty = "Yacht",			renPropStat = "MPX_YACHT_NAME",				renPropStat2 = "MPX_YACHT_NAME2"},
	{ renProperty = "Nightclub",		renPropStat = "MPX_NIGHTCLUB_NAME",			renPropStat2 = "MPX_NIGHTCLUB_NAME2"},
	{ renProperty = "Acid Lab",			renPropStat = "MPX_ACID_LAB_NAME",			renPropStat2 = "MPX_ACID_LAB_NAME2"},
	{ renProperty = "Acid Lab Product",	renPropStat = "MPX_ACIDLAB_PRODUCT_NAME",	renPropStat2 = "MPX_ACIDLAB_PRODUCT_NAME2"},
	{ renProperty = "Mansion Dog",		renPropStat = "MPX_MANSION_DOG_NAME1",		renPropStat2 = "MPX_MANSION_DOG_NAME2"},
	{ renProperty = "Mansion Cat",		renPropStat = "MPX_MANSION_CAT_NAME1",		renPropStat2 = "MPX_MANSION_CAT_NAME2"}
}

local JBvJG = {
	SoV = false,
	Phoenix = false,
	SoVLoop = 0,
	PhoenixLoop = 0,
	PhoenixReactToNoclip = false
}

local function RapidOxidation()
	if PAD.IS_CONTROL_JUST_PRESSED(0, 183) then -- G Key
		JBvJG.SoV = not JBvJG.SoV
	end
	if JBvJG.SoV then
		if (MISC.GET_GAME_TIMER() - JBvJG.SoVLoop) > 2200 then
			STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
			for _, i in ipairs {{0x796e, 0.7}, {0x3779, 0.3}, {0xcc4d, 0.3}, {0xdead, 0.3}, {0x49d9, 0.3}} do
				GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_petrol_fire", PLAYER.PLAYER_PED_ID(), 0, 0, 0.0, 90.0, -100.0, 90.0, i[1], i[2], 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
			end
			JBvJG.SoVLoop = MISC.GET_GAME_TIMER()
		end
	end
	if PAD.IS_CONTROL_JUST_PRESSED(0, 29) then -- B Key
		JBvJG.Phoenix = not JBvJG.Phoenix
		--if not Phoenix then GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(PLAYER.PLAYER_PED_ID()) end -- This works but the change is too abrupt, phoenix wings slowly fading away look cool anyway
	end
	if JBvJG.Phoenix then
		if (MISC.GET_GAME_TIMER() - JBvJG.PhoenixLoop) > 6200 then
			STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
			for _, i in ipairs{{-0.30, 0}, {-0.35, 10.0}, {-0.40, 20.0}, {-0.45, 30.0}} do
				if JBvJG.PhoenixReactToNoclip then
					if commandmgr.get_command("noclip"):get_value() then
						GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1] + 0.50, -0.15, 0.03, -25.0, i[2] - 28, 0, 0x60F2, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
						GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1] + 0.50, -0.15, 0.03, 205.0, i[2] - 28, 0, 0x60F2, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
					else
						GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1] + 0.50, -0.15, 0.03, -25.0, i[2] + 50, 0, 0x60F2, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
						GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1] + 0.50, -0.15, 0.03, 205.0, i[2] + 50, 0, 0x60F2, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
					end
				else
					GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1], -0.15, 0.03, -25.0, i[2], 0, 0x2e28, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
					GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("ent_sht_flame", PLAYER.PLAYER_PED_ID(), i[1], -0.15, 0.03, 205.0, i[2], 0, 0x2e28, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET()
				end
			end
			JBvJG.PhoenixLoop = MISC.GET_GAME_TIMER()
		end
	end
end

commandmgr.add_looped_command("rapidoxidation", "Rapid Oxidation", "Johnny Blaze meets Jean Grey...\n\nPress [G] to become Ghost Rider.\nPress [B] to unleash The Phoenix!", function()
	RapidOxidation()
end, function()
	notify.success("TinkerScript - Rapid Oxidation", "Rapid Oxidation enabled\nPress [G] to become Ghost Rider.\nPress [B] to unleash The Phoenix!", 3000)
	players.get_local():get_ped():set_invincible(true)
end, function()
	notify.info("TinkerScript - Rapid Oxidation", "Rapid Oxidation disabled.", 3000)
	players.get_local():get_ped():set_invincible(false)
end)

commandmgr.add_bool_command("phoenixnoclip", "Phoenix Wings react to No clip", "Folds or Spreads Phoenix Wings based on No Clip state.", false, function()
	JBvJG.PhoenixReactToNoclip = true
end, function()
	JBvJG.PhoenixReactToNoclip = false
end)
commandmgr.add_bool_command("noclip_onscreen", "No Clip State On-Screen", "Displays a small window when No Clip is enabled.", false, nil)

local NoClipWindowTop = false
menu.add_always_draw_imgui(function()
	if commandmgr.get_command("noclip_onscreen"):get_value() and commandmgr.get_command("noclip"):get_value() then
        if not NoClipWindowTop then ImGui.SetNextWindowPos(screenX / 2, screenY, 0, 0.5, 1.0) else ImGui.SetNextWindowPos(screenX / 2, 0, 0, 0.5, 0) end
        ImGui.SetNextWindowSize(150, 70)
		ImGui.PushStyleVar(ImGuiStyleVar.WindowTitleAlign, 0.5, 0.5)
        ImGui.Begin("No Clip", nil, 2 + 4 + 32 + 256 + 512)
			ImGui.SetCursorPosX((ImGui.GetWindowWidth() - ImGui.CalcTextSize("Enabled")) / 2)
            ImGui.TextColored(0.0, 1.0, 0.0, 1.0, "Enabled")
        ImGui.End()
		ImGui.PopStyleVar()
	end
end)

local playing_anim = false
commandmgr.add_looped_command("noclip_anim", "No Clip Animation", "Makes your character play a Flying Animation when No Clip is enabled.", function() -- From YimMenu (I just wanted to clone my character and ended up with this... and completely forgot about cloning my character lol). I have no idea of what I have done here (if good or bad), but it works.
	if (commandmgr.get_command("noclip"):get_value() and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(PLAYER.PLAYER_PED_ID()) > 3) and not PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then
		if (STREAMING.HAS_ANIM_DICT_LOADED("skydive@freefall") and STREAMING.HAS_ANIM_DICT_LOADED("missfam5_yoga")) and not playing_anim then
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
			playing_anim = true
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 4, 1, -1, 1 + 1048576, 0, false, false, false)
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 4, 1, -1, 2 + 16 + 32 + 131072 + 1048576, 0, false, false, false)
		else
			STREAMING.REQUEST_ANIM_DICT("skydive@freefall")
			STREAMING.REQUEST_ANIM_DICT("skydive@parachute@first_person")
			STREAMING.REQUEST_ANIM_DICT("missfam5_yoga")
		end
		if playing_anim and PAD.IS_CONTROL_JUST_PRESSED(0, 150) then
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@freefall", "free_forward", 4.0, 1.0, -1, 1 + 64, 0, false, false, false)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 6.0)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 6.0)
		end
		if playing_anim and PAD.IS_CONTROL_JUST_PRESSED(0, 151) then
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@freefall", "free_back", 4.0, 1.0, -1, 1 + 64, 0, false, false, false)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 6.0)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 6.0)
		end
		if playing_anim and PAD.IS_CONTROL_JUST_PRESSED(0, 147) then
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@freefall", "free_left", 4.0, 1.0, -1, 1 + 64, 0, false, false, false)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 6.0)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 6.0)
		end
		if playing_anim and PAD.IS_CONTROL_JUST_PRESSED(0, 148) then
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@freefall", "free_right", 4.0, 1.0, -1, 1 + 64, 0, false, false, false)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 6.0)
			TASK.STOP_ANIM_TASK(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 6.0)
		end
		if playing_anim and (PAD.IS_CONTROL_JUST_RELEASED(0, 150) or PAD.IS_CONTROL_JUST_RELEASED(0, 151) or PAD.IS_CONTROL_JUST_RELEASED(0, 147) or PAD.IS_CONTROL_JUST_RELEASED(0, 148)) or PAD.IS_DISABLED_CONTROL_PRESSED(0, 36) then
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "skydive@parachute@first_person", "chute_idle_alt_lookright", 4, 1, -1, 1 + 1048576, 0, false, false, false)
			TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "missfam5_yoga", "c8_to_start", 4, 1, -1, 2 + 16 + 32 + 131072 + 1048576, 0, false, false, false)
		end
	else
		if playing_anim then
			TASK.CLEAR_PED_TASKS(PLAYER.PLAYER_PED_ID())
			playing_anim = false
		end
	end
end)

local PTFXt = {
	{ 1, "Explosion"},
	{ 2, "Electricity"},
	{ 3, "Sparkles"},
	{ 4, "Blink"},
	{ 5, "Poof1"},
	{ 6, "Poof2"},
}

local Particles = false
local function TransformFX()
	if Particles then
		if PTFX == 1 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("core");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("exp_grd_grenade_lod", PLAYER.PLAYER_PED_ID(),  0, 0, 0, 0, 0, 0, 0x2e28, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(100)
		elseif PTFX == 2 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("scr_fm_mp_missioncreator");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("scr_mp_elec_dst", PLAYER.PLAYER_PED_ID(),  0, 0, 0, 0, 0, 0, 0x2e28, 5, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(100)
		elseif PTFX == 3 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("proj_indep_firework_v2");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("scr_xmas_firework_sparkle_spawn", PLAYER.PLAYER_PED_ID(),  0, 0, 0, 0, 0, 0, 0x2e28, 15, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(100)
		elseif PTFX == 4 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("scr_indep_fireworks");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("scr_indep_firework_trailburst_spawn", PLAYER.PLAYER_PED_ID(),  0, 0, 0, 0, 0, 0, 0x2e28, 10, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(100)
		elseif PTFX == 5 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("scr_clown_appears", PLAYER.PLAYER_PED_ID(),  0.3, 0, 0, 0, 0, 0, 0x2e28, 1, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(300)
		elseif PTFX == 6 then
			GRAPHICS.USE_PARTICLE_FX_ASSET("scr_powerplay");GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_PED_BONE("scr_powerplay_beast_appear", PLAYER.PLAYER_PED_ID(),  0.3, 0, 0, 0, 0, 0, 0x2e28, 1.3, 1, 1, 1);STREAMING.REMOVE_PTFX_ASSET();script.yield(300)
		end
	end
end

local function TinyPlayer()
	if not PED.GET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, 1) then
		if PAD.IS_CONTROL_JUST_PRESSED(0, 73) then
			TransformFX()
			PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, 1);STREAMING.REMOVE_PTFX_ASSET()
		end
	else
		if PAD.IS_CONTROL_JUST_PRESSED(0, 73) then
			TransformFX()
			PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 223, 0);STREAMING.REMOVE_PTFX_ASSET()
		end
	end
end

commandmgr.add_looped_command("tinyplayer", "TinyPlayer", "Become Ant-Man?... + particle effects ;D", function()
	TinyPlayer()
end, function()
	for _, i in ipairs {"core", "scr_fm_mp_missioncreator", "proj_indep_firework_v2", "scr_indep_fireworks", "scr_rcbarry2", "scr_powerplay"} do
		STREAMING.REQUEST_NAMED_PTFX_ASSET(i)
	end
end, function()
	for _, i in ipairs {"core", "scr_fm_mp_missioncreator", "proj_indep_firework_v2", "scr_indep_fireworks", "scr_rcbarry2", "scr_powerplay"} do
		STREAMING.REMOVE_NAMED_PTFX_ASSET(i)
	end
end)

commandmgr.add_bool_command("tinyp_ptfxtoggle", "Particles", "Enables Particle Effects", false, function()
	Particles = true
end, function()
	Particles = false
end)

commandmgr.add_list_command("tinyp_ptfxlist", "Particle effects", "", PTFXt, 1, nil)

commandmgr.add_bool_command("hiddenlocs", "Hidden Locations", "Teleport to Hidden/Random Locations.", false, nil)

local BoxWidth = 0.208
local BoxHeight = 0.492
local xPos = 0.8545
local yPos = 0.312
local MM_msg = [[

~y~      Welcome to
Kiddion's Modest Menu!~s~

This mod is offered free of charge
and wihout warranty!

For any help, please visit the
Modest Menu thread at
~HC_64~https://unknowncheats.me~s~ and
carefully read the FAQ and Known
Issues.

~r~This is for EDUCATIONAL AND
EVALUATION PURPOSES ONLY.
NO responsability is held or
accepted for misuse.
~h~Use at your own risk!~s~

]]

local function ModestMenu(msg, x, y)
    HUD.SET_TEXT_SCALE(0.0, 0.375)
    HUD.SET_TEXT_LEADING(3.0)
    HUD.BEGIN_TEXT_COMMAND_DISPLAY_TEXT("CELL_EMAIL_BCON")
    for i = 1, #msg, 99 do
        HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(string.sub(msg, i, i + 98))
    end
    HUD.END_TEXT_COMMAND_DISPLAY_TEXT(x, y, 0)
	GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT("shared", true)
end

TS_Main:imgui(function() if not IsOnline() then ImGui.TextDisabled("Please join a freemode session.") return end

	ImGui.BeginTabBar("MainCatTab")
	if ImGui.BeginTabItem("General") then

		if not windowcheck and ImGui.IsWindowHovered() then
			nomoretreeplease = util.time()
			windowcheck = true
		elseif windowcheck then
			if util.time() < nomoretreeplease + 5000 then
				--ImGui.SetCursorPosX((ImGui.GetWindowWidth() - 300) * 0.5) ImGui.SetCursorPosY(5.0) -- not perfectly centered but I'll leave it here as an example of what not to do
				CenteredText("Original TinkerScripts by ImagineNothing", true, false)
			end
		end

		ImGui.Text("General")ImGui.Separator()ImGui.Spacing()

		ImGui.BeginGroup()
	    commandmgr.get_command("fastrespawn"):draw()
		commandmgr.get_command("fastreload"):draw()
		commandmgr.get_command("infcombatroll"):draw()
	    commandmgr.get_command("ragdoll"):draw()
		ImGui.EndGroup()

		ImGui.SameLine() ImGui.BeginGroup()
		commandmgr.get_command("notm25_bst"):draw()
		ImGui.SameLine()
		commandmgr.get_command("noidlecam"):draw()
		commandmgr.get_command("m25_runboost"):draw()
		if commandmgr.get_command("m25_runboost"):get_value() then
			ImGui.PushItemWidth(80)
			ImGui.SameLine() m25_yogaRmulti = ImGui.SliderFloat("Run Mult.", m25_yogaRmulti, 1.15, 3.0)
			ImGui.SameLine() m25_yogaSmulti = ImGui.SliderFloat("Swim Mult.", m25_yogaSmulti, 2.0, 3.0)
			ImGui.PopItemWidth()
			tunables.set_float(-1585694365, m25_yogaRmulti)
			tunables.set_float(-1986470272, m25_yogaSmulti)
		end
		commandmgr.get_command("m25_strengthboost"):draw()
	    commandmgr.get_command("clearworld"):draw()
		ImGui.EndGroup()

		if ImGui.Button("Force Cloud Save") then
			STATS.STAT_SAVE(0, 0, 3, 0)
		end

		if ImGui.Button("Teleport into Personal Vehicle") then
			ScriptGlobal(2640101 + 8):set_int(1)
		end

		if ImGui.Button("Teleport into Closest Vehicle") then
			Joyrider(jr_radius)
		end

		ImGui.SameLine()
		ImGui.SetNextItemWidth(100)
		jr_radius = ImGui.InputInt("Teleport Radius", jr_radius)

		ImGui.Spacing()ImGui.Spacing()

		ImGui.Text("Auto-Drive") if ImGui.IsItemHovered() then ImGui.SetTooltip("Enables KnoWay Autonomous Vehicles System.") end ImGui.Separator()ImGui.Spacing()

		ImGui.SetNextItemWidth(130)
		VehAutoDrive.Mode, drivemodechanged = ImGui.Combo("Driving Style", VehAutoDrive.Mode, VehAutoDrive.Label, 3) -- I'll stick to add_list_command next time

		ImGui.SameLine()
		ImGui.SetNextItemWidth(100)
		AutoDriveSpeed = ImGui.InputInt("Speed##wander", AutoDriveSpeed)

		if ImGui.Button("Auto-Drive to Waypoint") then
			script.run_in_callback(SelfTaxi)
		end

		if ImGui.Button("Auto-Wander") then
			script.run_in_callback(Wander)
		end

		ImGui.Spacing()ImGui.Spacing()

		ImGui.Text("Re-Name Editor")ImGui.Separator()ImGui.Spacing()

		if OR_ptr == nil then
			OR_ptr = memory.scan_pattern("40 5D ? ? ? ? 00 00 90 5D ? ? ? ? 00 00 00 00 00 00 00 00 00 00 00"):deref()
		end

		ImGui.AlignTextToFramePadding()
		if renamemode then ImGui.Text("Mode: Business Renamer") else ImGui.Text("Mode: Outfit Renamer") end

		ImGui.SameLine()

		if ImGui.Button("Switch Mode") then
			renamemode = not renamemode
			New_Name = ""
		end ImGui.Spacing()

		if renamemode then
			if ImGui.BeginListBox("##renprops"..nomoretreeplease, 400, 232) then -- https://www.unknowncheats.me/forum/call-of-duty-modern-warfare-ii/571696-imgui-listbox.html
				for i, item in ipairs(ReN_Properties) do
					local is_selected = (selected_prop == i)
					if ImGui.Selectable(item.renProperty..": "..stats.get_string(item.renPropStat)..stats.get_string(item.renPropStat2), is_selected) and selected_prop ~= i then
						selected_prop = i
						New_Name = stats.get_string(item.renPropStat) .. stats.get_string(item.renPropStat2)
						ReN_selectedprop = item
					end
				end
				ImGui.EndListBox()

				ImGui.SetNextItemWidth(400)
				New_Name = ImGui.InputTextWithHint("##newrename", "New Organization/Acid Lab/Pet Name", New_Name)

				ImGui.SameLine()
				if ImGui.Button("Re-Name") then
					stats.set_string(ReN_selectedprop.renPropStat, New_Name:sub(1, 10))
					stats.set_string(ReN_selectedprop.renPropStat2, New_Name:sub(11, 20))
				end
			end
			ImGui.SameLine() ibox_checkbox = ImGui.Checkbox("Input Box Override", ibox_checkbox)

			if ibox_checkbox then
				ImGui.SetNextItemWidth(400)
				New_Name = ImGui.InputTextWithHint("##iboxoverride", "New Input Box Text", New_Name)

				ImGui.SameLine() if ImGui.Button("Override") then
					script.run_in_callback(ReNameEditor)
				end if ImGui.IsItemHovered() then ImGui.SetTooltip("R* fixed input box filters. Consider this DEPRECATED.") end
			end
		else
			if ImGui.BeginListBox("##outfitslots"..nomoretreeplease, 400, 232) then
				for i = 1, 20 do
					local outfitname = OR_ptr:add(OR_offsets[i]):get_string()
					local is_selected = (OR_selected == i)
					if ImGui.Selectable(i..". "..outfitname, is_selected) and OR_selected ~= i then
						OR_selected = i
						New_Name = outfitname
					end
				end
				ImGui.EndListBox()
			end

			ImGui.SetNextItemWidth(400)
			New_Name = ImGui.InputTextWithHint("##outfitname", "~ws~~r~¦~s~New Name~r~¦~ws~", New_Name)

			ImGui.SameLine()
			if ImGui.Button("Apply##OR") then
				if New_Name ~= "" and OR_selected > 0 then
					OR_ptr:add(OR_offsets[OR_selected]):set_string(New_Name:sub(1, 31))
					notify.success("Outfit Renamer", "Slot " .. (OR_selected) .. " renamed!", 3000)
					New_Name = ""
				elseif (New_Name ~= "" or New_Name == "") and OR_selected <= 0 then
					notify.error("TinkerScript - Re-Name", "Select something first!", 3000)
				elseif New_Name == "" and OR_selected > 0 then
					notify.error("TinkerScript - Re-Name", "Name is empty!\nPlease enter a name.", 3000)
				end
			end

			ImGui.SameLine() if ImGui.Button("Copy") then
				if OR_selected > 0 then
					local copyoutfitname = OR_ptr:add(OR_offsets[OR_selected]):get_string()
					ImGui.SetClipboardText(copyoutfitname)
					notify.info("Outfit Renamer", "Copied: " .. copyoutfitname, 3000)
				else
					notify.error("TinkerScript - Re-Name", "Select something first!", 3000)
				end
			end

			ImGui.SameLine() if ImGui.Button("Copy All") then
				local AllOutfitNames = {}
				for i = 1, 20 do
					local outfitname = OR_ptr:add(OR_offsets[i]):get_string() or "(empty)"
					table.insert(AllOutfitNames, i..". "..outfitname)
				end
				ImGui.SetClipboardText(table.concat(AllOutfitNames, "\n"))
				notify.info("Outfit Renamer", "All outfit names copied to clipboard!", 3000)
			end
		end

		ImGui.Spacing()ImGui.Spacing() ImGui.SameLine(0, 3.8) if ImGui.TreeNodeEx("Text Formatting  ##"..nomoretreeplease, 8219) then

		ImGui.BeginGroup()

		for i, textformat in ipairs(ReN_Style) do
			if i % 2 == 0 then ImGui.SameLine() end

			if ImGui.Button(textformat.tbLabel, 100) then
				if selected_prop ~= nil or OR_selected > 0 then
					New_Name = New_Name .. textformat.tStyle
				else
					notify.error("TinkerScript - Re-Name", "Select something first!", 3000)
				end
			end if ImGui.IsItemHovered() then ImGui.SetTooltip(textformat.tStyle) end
		end

		ImGui.EndGroup()

		ImGui.SameLine()

		ImGui.BeginGroup() -- Table looks much better but this also work
		ImGui.InputTextMultiline("##Colors & Symbols", [[
Use HTML/Hex if symbols don't work.

R* Logo:    	      &#8721;   |   &#x2211;
R* Verified:	     &#166;     |   &#xa6;
R* Created: 	   &#8249;   |   &#x2039;
Lock Icon:           &#937;     |   &#x3a9;
Blank Icon:         &#8250;   |   &#x203a;]], 280, 142, ImGuiInputTextFlags.ReadOnly)
		ImGui.EndGroup()

		ImGui.Spacing()
		ImGui.BeginGroup()
		ImGui.Text("Colors")

		for i, textcolor in ipairs(ReN_Color) do
			if (i - 1) % 4 ~= 0 then ImGui.SameLine() end

			if ImGui.ColorButton(textcolor.bName, textcolor.bCol, 64) then
				if selected_prop ~= nil or OR_selected > 0 then
					New_Name = New_Name .. textcolor.tColf
				else
					notify.error("TinkerScript - Re-Name", "Select something first!", 3000)
				end
			end if ImGui.IsItemHovered() then ImGui.SetTooltip(textcolor.bTip..": "..textcolor.tColf) end
		end
		ImGui.EndGroup()
		ImGui.Spacing()
		end

		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Misc") then

		ImGui.Text("Misc")ImGui.Separator()ImGui.Spacing()

		commandmgr.get_command("DuffelBagSave"):draw()
		commandmgr.get_command("noclip_anim"):draw()
		ImGui.SameLine()
		commandmgr.get_command("noclip_onscreen"):draw()
		if commandmgr.get_command("noclip_onscreen"):get_value() then ImGui.SameLine() NoClipWindowTop = ImGui.Checkbox("Top", NoClipWindowTop) end

		commandmgr.get_command("rapidoxidation"):draw()
		if commandmgr.get_command("rapidoxidation"):get_value() then
			ImGui.SameLine() commandmgr.get_command("phoenixnoclip"):draw()
		end

		commandmgr.get_command("tinyplayer"):draw()
		if commandmgr.get_command("tinyplayer"):get_value() then
			ImGui.SameLine() commandmgr.get_command("tinyp_ptfxtoggle"):draw()
			if commandmgr.get_command("tinyp_ptfxtoggle"):get_value() then
				ImGui.SameLine() commandmgr.get_command("tinyp_ptfxlist"):draw()
			end
		end

		PTFX = commandmgr.get_command("tinyp_ptfxlist"):get_value()

		ImGui.SameLine(0, 200)
		ImGui.PushStyleColor(ImGuiCol.Button, 0, 0, 0, 0)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0, 0.5, 1, 0.05)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0, 0, 0, 0)
		if ImGui.Button(" ##ModestMenuWelcomeMsg") then
			script.run_in_callback(function()
				for i = 1, 60*9 do
					GRAPHICS.DRAW_RECT(xPos, yPos, BoxWidth, BoxHeight, 0, 0, 0, 200, 1)
					GRAPHICS.DRAW_SPRITE("shared", "info_icon_32", 0.763, 0.090, 0.02, 0.036, 0.0, 255, 255, 255, 255, 0, 0)
					ModestMenu(MM_msg, 0.756, 0.048)
					script.yield(0)
				end
			end)
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Triggers Nostalgia") end
		ImGui.PopStyleColor()ImGui.PopStyleColor()ImGui.PopStyleColor()

		commandmgr.get_command("hiddenlocs"):draw()
		if commandmgr.get_command("hiddenlocs"):get_value() then
			CurPlayerCoords()
			ImGui.SetNextItemWidth(240)
			ImGui.InputText("Current Coords", string.format("x: %.2f,   y: %.2f,   z: %.2f", PlaCoords.x, PlaCoords.y, PlaCoords.z), ImGuiInputTextFlags.ReadOnly)

			ImGui.SameLine()
			if ImGui.Button("Copy To Clipboard") then
				ImGui.SetClipboardText(string.format("%.2f, %.2f, %.2f", PlaCoords.x, PlaCoords.y, PlaCoords.z))
				notify.success("TinkerScript - Hidden Locations", "Current Coordinates copied to clipboard!", 3000)
			end

			if ImGui.BeginListBox("##hiddenlocsbox"..nomoretreeplease, 354, 232) then
				for _, LocServ in ipairs(LocationCoords) do
					if ImGui.Selectable(LocServ.LocName) then
						PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), LocServ.LocCoords[1], LocServ.LocCoords[2], LocServ.LocCoords[3])
					end if ImGui.IsItemHovered() then ImGui.SetTooltip(LocServ.LocDesc) end
				end
				ImGui.EndListBox()
			end
		end

		ImGui.EndTabItem()
	end
	ImGui.EndTabBar()
end)

---|| Biz-Teroids ||------------------------------------------------------------------------------

local HGgoodtypeT = {
	{ 0, "Animal Materials" },
	{ 1, "Art & Antiques" },
	{ 2, "Chemicals" },
	{ 3, "Counterfeit Goods" },
	{ 4, "Jewelry & Gemstones" },
	{ 5, "Medical Supplies" },
	{ 6, "Narcotics " },
	{ 7, "Tobacco & Alcohol" }
}

local WHgoodtypeT = {
	{ 0,  "Medical Supplies" },
	{ 1,  "Tobacco & Alcohol" },
	{ 2,  "Art & Antiques" },
	{ 3,  "Electronic Goods" },
	{ 4,  "Weapons & Ammo" },
	{ 5,  "Narcotics" },
	{ 6,  "Gemstones" },
	{ 7,  "Animal Materials" },
	{ 8,  "Counterfeit Goods" },
	{ 9,  "Jewelry" },
	{ 10, "Bullion" }
}

local PropGlob = {
	whprop = 1845347 + 260 + 128,
	hangarprop = 1845347 + 260 + 304,
	bbizprop = 1845347 + 260 + 205,
	ncprop = 1845347 + 260 + 364,
	syprop = 1845347 + 260 + 504,
	mcbar = 1845347 + 260 + 394
}

local BizRe_RestockSU = {
	methmc = {
		manuprod = {1370024930, 1944848251, 1577999189, 1678460062},
		manucost = {-730135062, -660914094}
	},
	weedmc = {
		manuprod = {-635596193, -1694873660, 1575359233, 102029883},
		manucost = {-373027461, 1195564032}
	},
	crackmc = {
		manuprod = {702413484, 2070857577, -1539796661, 396217128},
		manucost = {-161187879, 1500658261}
	},
	cashmc = {
		manuprod = {1310272402, 1690071006, -1454958662, -1913260493},
		manucost = {631857857, -891680742}
	},
	fakeidmc = {
		manuprod = {-959721585, 1672482518, -518264160, 489023341},
		manucost = {-1839004359, -192060672}
	},
	bunkermc = {
		manuprod = {215868155, 631477612, 818645907},
		manucost = {-1652502760, 1647327744}
	},
	acidmc = {
		manuprod = {-672998848, 494316332, -40235252},
		manucost = {-1506354854, -993236072}
	},
	nightclub = {
		manuprod = {-147565853, -1390027611, -1292210552, 1007184806, 18969287, -863328938, 1607981264}
	}
}

local function OpenMCT()
	if ScriptGlobal(1951071):get_int() ~= 0 then -- Credits to PazzoG
		ScriptGlobal(1951071):set_int(0)
	end
	scripts.start_new_script("apparcadebusinesshub", 1424)
	script.run_in_callback(function()
		while scripts.is_active("apparcadebusinesshub") do
			if ScriptGlobal(1971195):get_int() == -1 then
				ScriptGlobal(1971195):set_int(0)
			end
			script.yield(0)
		end
	end)
end


local BizRe_running = false
local BizRe_HGonly = false
local BizRe_WHonly = false
local BizRe_cancel = true
local function BizRe_lotoggle()
	if BizRe_cancel then
		notify.warn("TinkerScript - Biz-Teroids", "Logic Canceled.", 3000)
		BizRe_running = false
		STATS.STAT_SAVE(0, 0, 3, 0)
	end
	return BizRe_cancel
end

local MCbizlocs = {
	[1] = "Paleto Bay", [6] = "El Burro Heights", [11] = "Gran Senora Desert", [16] = "Terminal",
	[2] = "Mount Chiliad", [7] = "Downtown Vinewood", [12] = "San Chianski Mountain Range", [17] = "Elysian Island",
	[3] = "Paleto Bay", [8] = "Morningwood", [13] = "Alamo Sea", [18] = "Elysian Island",
	[4] = "Paleto Bay", [9] = "Vespucci Canals", [14] = "Gran Senora Desert", [19] = "Cypress Flats",
	[5] = "Paleto Bay", [10] = "Textile City", [15] = "Grapeseed", [20] = "Elysian Island",
	[21] = "Grand Senora Oilfields", [22] = "Grand Senora Desert", [23] = "Route 68", [24] = "Farmhouse", [25] = "Smoke Tree Road", [26] = "Thomson Scrapyard", [27] = "Grapeseed", [28] = "Paleto Forest", [29] = "Raton Canyon", [30] = "Lago Zancudo", [31] = "Chumash"
}

local MCbiz = {
	{ MCBname = "Methamphetamine Lab", 		ID = { 1, 6, 11, 16 },  Blip = Blips.Property.PRODUCTION_METH.ID },
	{ MCBname = "Weed Farm", 				ID = { 2, 7, 12, 17 },  Blip = Blips.Property.PRODUCTION_WEED.ID },
	{ MCBname = "Cocaine Lockup", 			ID = { 3, 8, 13, 18 },  Blip = Blips.Property.PRODUCTION_CRACK.ID },
	{ MCBname = "Counterfeit Cash Factory", ID = { 4, 9, 14, 19 },  Blip = Blips.Property.PRODUCTION_MONEY.ID },
	{ MCBname = "Document Forgery Office", 	ID = { 5, 10, 15, 20 }, Blip = Blips.Property.PRODUCTION_FAKE_ID.ID },
	{ MCBname = "Bunker", 					ID = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31 }, Blip = Blips.Property.PROPERTY_BUNKER.ID }
}

local function GetBusinessSlot(businessName, Blog)
	for _, business in ipairs(MCbiz) do -- Credit to Silenthy6 (SilentSalo) for this part https://www.unknowncheats.me/forum/4380348-post701.html (it was too much for my brain) | It's been a year and I sill don't add other businesses
		if business.MCBname == businessName then
			for i = 0, 5 do
				local slot = stats.get_int("MPX_FACTORYSLOT"..i)
				if slot > 0 then
					for _, id in ipairs(business.ID) do
						if slot == id then
							if Blog then
								local mcbizloc = MCbizlocs[slot]
								log.info(string.format("\r\27[1;36mBusiness:\27[1;92m %-25s \27[m| \27[1;36mLocation:\27[m %-27s | \27[1;36mSlot:\27[m %d | \27[1;36mID:\27[m %s            \r", businessName, mcbizloc, i, slot))
							end
							return true, i
						end
					end
				end
			end
		end
	end
end

local function BizRe_Hangar()
	if ScriptGlobal(PropGlob.hangarprop):at(PLAYER.PLAYER_ID(), 884):get_int() >= 1 then
		if not stats.get_packed_bool(15966) then stats.set_packed_bool(15966, true) end
		if ScriptGlobal(PropGlob.hangarprop + 3):at(PLAYER.PLAYER_ID(), 884):get_int() <= 49 then
			if HGWHmaxgoods then
				if HGsetgood then
					ScriptGlobal(1882787 + 8):set_int(HGgoodtype)
				end
				ScriptGlobal(1882787 + 7):set_int(50)
				stats.set_packed_bool(36828, true)
				STATS.STAT_SAVE(0, 0, 3, 0)
				notify.success("Success!", "Hangar goods replenished!", 3000)
			else
				notify.info("TinkerScript - Biz-Teroids", "Instant Max Restock disabled. Hangar will be replenished with mixed goods.", 3000)
				for HGl = 0, 49 do if BizRe_running and BizRe_lotoggle() then return end
					stats.set_packed_bool(36828, true)
					script.yield(1500)
				end
			end
		else
			notify.warn("Oops!", "Hangar is at max capacity.", 3000)
		end
		if BizRe_HGonly then BizRe_cancel = true BizRe_HGonly = false end
	else
		if BizRe_HGonly then BizRe_cancel = true BizRe_HGonly = false end
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Hangar", 3000)
	end
end

local function BizRe_Warehouse()
	if ScriptGlobal(PropGlob.whprop):at(PLAYER.PLAYER_ID(), 884):at(0, 3):get_int() >= 1 then
		if HGWHmaxgoods then
			for WHp, c in ipairs({32359, 32360, 32361, 32362, 32363}) do if BizRe_running and BizRe_lotoggle() then return end
				if ScriptGlobal(PropGlob.whprop):at(PLAYER.PLAYER_ID(), 884):at(WHp - 1, 3):get_int() >= 1 then
					if BizRe_running and BizRe_lotoggle() then return end
					if ScriptGlobal(PropGlob.whprop + 1):at(PLAYER.PLAYER_ID(), 884):at(WHp - 1, 3):get_int() <= 110 then
						for i = 1, 2 do if BizRe_running and BizRe_lotoggle() then return end
							if WHsetgood then ScriptGlobal(1882762 + 16):set_int(WHgoodtype) end
							ScriptGlobal(1882762 + 13):set_int(111)
							stats.set_packed_bool(c, true)
							script.yield(2000)
						end
						STATS.STAT_SAVE(0, 0, 3, 0)
						notify.success("Success!", string.format("Warehouse(%d) goods replenished!", WHp))
					else
						notify.warn("Oops!", string.format("Warehouse(%d) is at max capacity.", WHp))
					end
				end
			end
			if BizRe_WHonly then BizRe_cancel = true BizRe_WHonly = false end
		else
			notify.info("TinkerScript - Biz-Teroids", "Instant Max Restock disabled. Warehouse will be replenished with mixed goods.", 3000) script.yield(3000)
			for WHl = 1, 111 do if BizRe_running and BizRe_lotoggle() then return end
				stats.set_packed_bool_range(32359, 32363, true)
				script.yield(1200)
			end
			if BizRe_WHonly then BizRe_cancel = true BizRe_WHonly = false end
		end
	else
		if BizRe_WHonly then BizRe_cancel = true BizRe_WHonly = false end
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Warehouse", 3000)
	end
end

local function BizRe_MCresup()
	tunables.set_int(1712674055, 1)
	for b = 0, 7 do
		if ScriptGlobal(PropGlob.bbizprop):at(PLAYER.PLAYER_ID(), 884):at(b, 13):get_int() >= 1 then
			for bsup = 1, 7 do
				ScriptGlobal(1673820 + bsup):set_int(1)
			end
		end
	end
	notify.success("Success!", "All businesses supplies have been replenished!", 3000)
end

local function BizRe_MCrestock()

	tunables.set_int(728170457, 1)
	tunables.set_int(-2094564985, 1)

	local methmc, slot = GetBusinessSlot("Methamphetamine Lab", true)
	if methmc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 19 then
			for _, manuprod in ipairs(BizRe_RestockSU.methmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.methmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Meth Business restock ready!\nPlease restart your business.", 3000)
		else
			notify.warn("Oops!", "Meth Business stock is at max capacity!", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Methamphetamine Lab.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	local weedmc, slot = GetBusinessSlot("Weed Farm", true)
	if weedmc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 79 then
			for _, manuprod in ipairs(BizRe_RestockSU.weedmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.weedmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Weed Business restock ready!\nPlease restart your business.", 3000)
		else
			notify.warn("Oops!", "Weed Business stock is at max capacity!", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Weed Farm.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	local crackmc, slot = GetBusinessSlot("Cocaine Lockup", true)
	if crackmc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 9 then
			for _, manuprod in ipairs(BizRe_RestockSU.crackmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.crackmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Coke Business restock ready!\nPlease restart your business.", 3000)
		else
			notify.warn("Oops!", "Coke Business stock is at max capacity!", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Cocaine Lockup.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	local cashmc, slot = GetBusinessSlot("Counterfeit Cash Factory", true)
	if cashmc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 39 then
			for _, manuprod in ipairs(BizRe_RestockSU.cashmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.cashmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Cash Business restock ready!\nPlease restart your business.", 3000)
		else
			notify.warn("Oops!", "Cash Business stock is at max capacity!", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Counterfeit Cash Factory.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	local fakeidmc, slot = GetBusinessSlot("Document Forgery Office", true)
	if fakeidmc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 59 then
			for _, manuprod in ipairs(BizRe_RestockSU.fakeidmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.fakeidmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Documents Business restock ready!\nPlease restart your business.", 3000)
		else
			notify.warn("Oops!", "Documents Business stock is at max capacity!", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Document Forgery Office.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	local bunkermc, slot = GetBusinessSlot("Bunker", true)
	if bunkermc then
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(slot, 13):get_int() <= 99 then
			for _, manuprod in ipairs(BizRe_RestockSU.bunkermc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.bunkermc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Bunker Business restock ready!\nPlease restart your business.", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Bunker.", 3000)
	end

	if BizRe_running and BizRe_lotoggle() then return end
	if ScriptGlobal(PropGlob.bbizprop):at(PLAYER.PLAYER_ID(), 884):at(6, 13):get_int() >= 1 then
		if not stats.get_packed_bool(36689) then stats.set_packed_bool(36689, true) end
		if ScriptGlobal(PropGlob.bbizprop + 1):at(PLAYER.PLAYER_ID(), 884):at(6, 13):get_int() <= 159 then
			for _, manuprod in ipairs(BizRe_RestockSU.acidmc.manuprod) do
				tunables.set_int(manuprod, 1)
			end
			for _, manucost in ipairs(BizRe_RestockSU.acidmc.manucost) do
				tunables.set_int(manucost, 1)
			end
			script.yield(2000)
			notify.success("Success!", "Acid Lab Business restock ready!\nPlease restart your business.", 3000)
		end
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own an Acid Lab.", 3000)
	end
end


local function BizRe_NCrestock()
	if ScriptGlobal(PropGlob.ncprop):at(PLAYER.PLAYER_ID(), 884):get_int() >= 1 then
		if ScriptGlobal(PropGlob.ncprop + 4):get_float() <= 99.0 then
			stats.set_int("MPX_CLUB_POPULARITY", 1000)
			notify.success("Success!", "Nightclub Popularity has been maxed out!", 3000)
		end
		for _, manuprod in ipairs(BizRe_RestockSU.nightclub.manuprod) do
			tunables.set_int(manuprod, 1)
		end
		notify.success("Success!", "Nightclub restock ready!\nPlease re-assign your technicians.", 3000)
		script.yield(2000)
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Nightclub.", 3000)
	end
end

local function BizRe_SalvPop()
	if ScriptGlobal(PropGlob.syprop):at(PLAYER.PLAYER_ID(), 884):get_int() >= 1 then
		stats.set_packed_int(51051, 100)
		notify.success("Success!", "Salvage Yard Popularity has been maxed out!", 3000)
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own a Salvage Yard.", 3000)
	end
end

local function BizRe_MFheat()
	if stats.get_int("MPX_SB_CAR_WASH_OWNED") == 1 then
		for tycoonh = 24924, 24926 do
			stats.set_packed_int(tycoonh, 0)
		end
		notify.success("Success!", "Money Fronts Businesses Heat Removed!", 3000)
		script.yield(2000)
	else
		notify.error("TinkerScript - Biz-Teroids", "You don't own Hands on Car Wash.", 3000)
	end
end

local BizRe_count = true
local function BusinessOnSteroids()

local function Countdown()
	local cd_cls = "\r                                                                                \r"
	for i = 10, 1, -1 do if BizRe_lotoggle() then return end
		notify.info("TinkerScript - Biz-Teroids by ImagineNothing", "Main logic will start in "..i..".", 999)
		log.info(cd_cls.."Main logic will start in: "..i.."  \r\27[1A") script.yield(999)
	end
	log.info(cd_cls.."\27[1AStarting...                           \r")
	log.info(cd_cls.."\27[1A\27[42;30m Start \27[m                           \r\n")
end

	log.warn("\r                                                                                 \r"..[[
           __     This script will Restock/Refill:
  \ ______/ V`-,  ]].."\27[38;5;124mHangar and Warehouses\27[m\n"..[[
   }        /~~  ]].."\27[32mMC Businesses\27[m\n"..[[
  /_)^ --,r'    ]].."\27[95mNightclub\27[m and \27[95mPopularity Bar\27[m"..[[

 |b      |b   ]].."\27[38;5;27mSalvage Yard Reputation\27[m"..[[
 ]].."Remove heat levels: \27[38;5;208mMoney Fronts Businesses\27[m"..[[
 ]].."\n\27[2;37;3mYOU MUST RESTART YOUR MC BUSINESSES AND RE-ASSIGN YOUR NIGHTCLUB TECHS AFTER RUNNING THE SCRIPT IF *RESTOCK* IS ENABLED.\27[m\n\n")--\27[1;100;37m


	if BizRe_count then Countdown() end

	if BizRe_lotoggle() then return end

	if HGWHrestock then
		BizRe_Hangar()
		if BizRe_lotoggle() then return end
		BizRe_Warehouse()
	else
		notify.info("TinkerScript - Biz-Teroids", "Hangar & Warehouse restock disabled. Skipping...", 3000)
	end

	script.yield(3000)

	if BizRe_lotoggle() then return end
	if MCresup then BizRe_MCresup() else notify.info("TinkerScript - Biz-Teroids", "MC Businesses Resupply disabled. Skipping...", 3000) end

	script.yield(3000)

	if BizRe_lotoggle() then return end
	if MCrestock then
		notify.info("TinkerScript - Biz-Teroids", "MC Businesses Restock enabled.", 3000)
		BizRe_MCrestock()
	else
		notify.info("TinkerScript - Biz-Teroids", "MC Businesses Restock disabled. Skipping...", 3000)
	end

	script.yield(3000)

	if BizRe_lotoggle() then return end
	if NCgoods then BizRe_NCrestock() else notify.info("TinkerScript - Biz-Teroids", "Nigtclub Restock disabled. Skipping...", 3000) end

	script.yield(3000)

	BizRe_SalvPop()
	if BizRe_lotoggle() then return end
	BizRe_MFheat()

	STATS.STAT_SAVE(0, 0, 3, 0)
	BizRe_cancel = true
	BizRe_running = false

	log.info("\r                                                                                \r\n\r\27[1B\27[42;30m End \27[m\n")
	notify.success("TinkerScript - Biz-Teroids", "Finished!", 3000)

end

commandmgr.add_bool_command("HGWH_restock", "Hangar/Warehouse Restock", "Should the script restock your Hangar and Warehouses?", true, nil)
commandmgr.add_bool_command("HGWH_maxgoods", "Hangar/Warehouse Max Goods", "Should the script instantly max out your Hangar and Warehouses stock?\nIf disabled, restock will be a bit slower, but you'll receive mixed goods", true, nil)
commandmgr.add_bool_command("HG_setgood", "Hangar Set Good", "Goods type for Hangar will be random if this is disabled", false, nil)
commandmgr.add_bool_command("WH_setgood", "Warehouse Set Good", "Goods type for Warehouses will be random if this is disabled", false, nil)
commandmgr.add_bool_command("MC_resup", "MC Businesses Resupply", "Should the script resupply all your MC Businesses?", true, nil)
commandmgr.add_bool_command("MC_restock", "MC Businesses Restock", "Should the script restock your MC Businesses?", true, nil)
commandmgr.add_bool_command("NC_goods", "Nightclub Restock", "Should the script restock your Nightclub?", true, nil)
commandmgr.add_list_command("HG_goodtype", "Hangar Good type", "", HGgoodtypeT, 0, nil)
commandmgr.add_list_command("WH_goodtype", "Warehouse Good type", "", WHgoodtypeT, 0, nil)

local CEO_instantbuy_amount = 1

local ncgotgood = false
local ncstealamount = 1
local NC_goodstype = {
	{ 1, "Cargo and Shipments", 	goodTunable = 910739098,   goodDefaultAmount =  1},
	{ 2, "Sporting Goods", 			goodTunable = -188055253,  goodDefaultAmount =  2},
	{ 3, "South American Imports", 	goodTunable = -1924406700, goodDefaultAmount =  1},
	{ 4, "Pharmaceutical Research", goodTunable = 1386540504,  goodDefaultAmount =  1},
	{ 5, "Organic Produce", 		goodTunable = -1407470929, goodDefaultAmount =  7},
	{ 6, "Printing & Copying", 		goodTunable = -681418413,  goodDefaultAmount =  10},
	{ 7, "Cash Creation", 			goodTunable = -655270102,  goodDefaultAmount =  3}
}

commandmgr.add_list_command("NC_goodtype", "Goods##ncgoodtype", "", NC_goodstype, 0, function()
	local NC_goodst = commandmgr.get_command("NC_goodtype"):get_value()
	if scripts.is_active("fm_content_club_source") then
		ScriptLocal("fm_content_club_source", 3726 + 728 + 3):set_int(NC_goodst - 1)
		ncstealamount = NC_goodstype[NC_goodst].goodDefaultAmount
	end
end)

TS_Bizteroids:imgui(function() if not IsOnline() then ImGui.TextDisabled("Please join a freemode session.") return end

	HGWHrestock = commandmgr.get_command("HGWH_restock"):get_value()
	HGWHmaxgoods = commandmgr.get_command("HGWH_maxgoods"):get_value()
	HGsetgood = commandmgr.get_command("HG_setgood"):get_value()
	WHsetgood = commandmgr.get_command("WH_setgood"):get_value()
	MCresup = commandmgr.get_command("MC_resup"):get_value()
	MCrestock = commandmgr.get_command("MC_restock"):get_value()
	NCgoods = commandmgr.get_command("NC_goods"):get_value()
	HGgoodtype = commandmgr.get_command("HG_goodtype"):get_value()
	WHgoodtype = commandmgr.get_command("WH_goodtype"):get_value()

	ImGui.Text("Control Panel")ImGui.Separator()ImGui.Spacing()

	ImGui.BeginGroup()
	commandmgr.get_command("HGWH_restock"):draw()
	commandmgr.get_command("HGWH_maxgoods"):draw()
	commandmgr.get_command("HG_setgood"):draw()

	if commandmgr.get_command("HG_setgood"):get_value() then
		commandmgr.get_command("HG_goodtype"):draw()
		ImGui.Spacing()
	end

	commandmgr.get_command("WH_setgood"):draw()

	if commandmgr.get_command("WH_setgood"):get_value() then
		commandmgr.get_command("WH_goodtype"):draw()
		ImGui.Spacing()
	end

	commandmgr.get_command("MC_resup"):draw()
	commandmgr.get_command("MC_restock"):draw()
	commandmgr.get_command("NC_goods"):draw()

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
	if BizRe_cancel and ImGui.Button("Run!", 80, 40) then
		BizRe_running = true
		BizRe_cancel = false
		script.run_in_callback(BusinessOnSteroids)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Bless the Businesses.") end

	if BizRe_cancel then
		ImGui.SameLine()
		ImGui.BeginGroup()
		ImGui.Spacing()ImGui.Spacing()
		BizRe_count = ImGui.Checkbox("Countdown", BizRe_count)
		ImGui.EndGroup()
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Allows you to disable the 10s countdown when running Biz-Teroids") end

	if not BizRe_cancel and BizRe_running then
		if ImGui.Button("Cancel", 80, 40) then
			BizRe_cancel = true
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Cancels Biz-Teroids logic.") end
	end
	ImGui.EndGroup()

    ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
	ImGui.Text("Individual Features")ImGui.Separator()ImGui.Spacing()

	ImGui.BeginGroup()
	if ImGui.Button("Master Control Terminal", 185) then
		script.run_in_callback(OpenMCT)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Manage your businesses.") end ImGui.SameLine()

	if ImGui.Button("Owned Businesses", 185) then
		for _, Business in ipairs(MCbiz) do
			GetBusinessSlot(Business.MCBname, true)
		end
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Prints your owned businesses to console.") end ImGui.NewLine()

	if ImGui.Button("Restock Hangar", 185) then
		BizRe_HGonly = true
		BizRe_running = true
		BizRe_cancel = false
		script.run_in_callback(BizRe_Hangar)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Restocks your Hangar.") end ImGui.SameLine()

	if ImGui.Button("Restock Warehouse", 185) then
		BizRe_WHonly = true
		BizRe_running = true
		BizRe_cancel = false
		script.run_in_callback(BizRe_Warehouse)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Restocks your Warehouse(s).") end

	if ImGui.Button("Restock MC Businesses", 185) then
		BizRe_running = true
		BizRe_cancel = false
		script.run_in_callback(BizRe_MCrestock)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Restocks all your Motorcycle Club Businesses") end ImGui.SameLine()

	if ImGui.Button("Resupply MC Businesses", 185) then
		BizRe_MCresup()
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Resupplies all your Motorcycle Club Businesses.") end

	if ImGui.Button("Restock Nightclub", 185) then
		script.run_in_callback(BizRe_NCrestock)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Restocks your Nightclub.") end ImGui.SameLine()

	if ImGui.Button("Businesses Heat", 185) then
		script.run_in_callback(BizRe_MFheat)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Removes Money Fronts Heat.") end

	if ImGui.Button("Nightclub Popularity", 185) then
		if ScriptGlobal(PropGlob.ncprop):at(PLAYER.PLAYER_ID(), 884):get_int() >= 1 then
			if stats.get_int("MPX_CLUB_POPULARITY") <= 999 then
				stats.set_int("MPX_CLUB_POPULARITY", 1000)
				notify.success("Success!", "Nightclub Popularity has been maxed out!", 3000)
			end
		else
			notify.error("TinkerScript - Biz-Teroids", "You don't own a Nightclub.", 3000)
		end
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Sets your Nightclub popularity to max.") end ImGui.SameLine()

	if ImGui.Button("Salvage Yard Popularity", 185) then
		BizRe_SalvPop()
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Sets your Salvage Yard popularity to max.") end
	ImGui.EndGroup()

	ImGui.SameLine()
	ImGui.Spacing()
	ImGui.SameLine(0, 3.8)

	ImGui.BeginGroup()
	if ImGui.TreeNodeEx("Teleport to Business  ##"..nomoretreeplease, 8219) then
		ImGui.NewLine()
		ImGui.Spacing()
		ImGui.SameLine(-3.8, 0)
		if ImGui.BeginChild("##bizteroidstptoprop", 210, 112) then

			if ImGui.Button("Hangar", 193) then
				if stats.get_int("MPX_HANGAR_OWNED") >= 1 then
					TpToBlip(false, Blips.Property.SM_HANGAR.ID, false)
				else
					notify.error("TinkerScripts - Biz-Teroids", "You don't own a Hangar.")
				end
			end

			if ImGui.Button("Warehouse", 193) then
				if stats.get_int("MPX_WARHOUSESLOT0") >= 1 then
					TpToBlip(false, Blips.Property.WAREHOUSE.ID, false)
				else
					notify.error("TinkerScripts - Biz-Teroids", "You don't own a Warehouse.")
				end
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Too lazy to add other warehouses, sry.") end

			for _, Business in ipairs(MCbiz) do
				if ImGui.Button(Business.MCBname, 193) then
					local owned, _ = GetBusinessSlot(Business.MCBname, false)
					if owned then
						TpToBlip(false, Business.Blip, false)
					else
						notify.error("TinkerScripts - Biz-Teroids", string.format("You don't own a %s.", Business.MCBname))
					end
				end
			end

			if ImGui.Button("Nightclub", 193) then
				if stats.get_int("MPX_NIGHTCLUB_OWNED") >= 1 then
					TpToBlip(false, Blips.Property.BAT_CLUB_PROPERTY.ID, false)
				else
					notify.error("TinkerScripts - Biz-Teroids", "Nightclub.")
				end
			end

			for _, Mfronts in ipairs({"SMOKE_SHOP", "HELITOURS", "CAR_WASH_BUSINESS"}) do
				local Busines = Blips.Property[Mfronts]
				if ImGui.Button(Busines.Name, 193) then
					if stats.get_int(Busines.Stat) == 1 then
						TpToBlip(false, Busines.ID, false)
					else
						notify.error("TinkerScripts - Biz-Teroids", string.format("You don't own a %s.", Busines.Name))
					end
				end
			end

		end ImGui.EndChild()
	end
	ImGui.EndGroup()

	ImGui.SetWindowFontScale(0.6)
	ImGui.TextDisabled("\nYOU MUST RESTART YOUR MC BUSINESSES AND RE-ASSIGN YOUR NIGHTCLUB TECHS IF *RESTOCK* IS ENABLED")
	ImGui.SetWindowFontScale(1.0)

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
	ImGui.Text("Instant-Sell")ImGui.Separator()ImGui.Spacing()

	if ImGui.Button("Special Cargo##sell", 185) then
		if scripts.is_active("gb_contraband_sell") then
			ScriptLocal("gb_contraband_sell", 576 + 1):set_int(67230)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Special Cargo Sell Mission first!", 3000)
		end
	end

	ImGui.SameLine() if ImGui.Button("Air-Freight Cargo (Air)", 185) then
		if scripts.is_active("gb_smuggler") then
			ScriptLocal("gb_smuggler", 1998 + 1035):set_int(0)
			ScriptLocal("gb_smuggler", 1998 + 1078):set_int(1)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Air-Freight Sell Mission first!", 3000)
		end
	end

	if ImGui.Button("Weapons", 185) then
		if scripts.is_active("gb_gunrunning") then
			ScriptLocal("gb_gunrunning", 1275 + 774):set_int(0)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Weapons Sell Mission first!", 3000)
		end
	end

	ImGui.SameLine() if ImGui.Button("MC Business Product", 185) then
		if scripts.is_active("gb_biker_contraband_sell") then
			ScriptLocal("gb_biker_contraband_sell", 738 + 122):set_int(ScriptLocal("gb_biker_contraband_sell", 738 + 174):get_int())
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Product Sell Mission first!", 3000)
		end
	end

	if ImGui.Button("Nightclub Goods", 185) then
		if scripts.is_active("business_battles_sell") then
			ScriptLocal("business_battles_sell", 2395 + 205):set_int(0)
			ScriptLocal("business_battles_sell", 2395 + 204):set_int(1)
			ScriptLocal("business_battles_sell", 2395 + 33):set_int(0)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Goods Sell Mission first!", 3000)
		end
	end

	if CAMERA.IS_SCREEN_FADED_OUT() and (scripts.is_active("gb_biker_contraband_sell") or scripts.is_active("business_battles_sell")) then
		script.run_in_callback(function()
			CAMERA.DO_SCREEN_FADE_IN(500)
			script.yield(2000)
			CAMERA.DO_SCREEN_FADE_IN(500)
		end)
	end

	ImGui.SameLine() if CAMERA.IS_SCREEN_FADED_OUT() and (scripts.is_active("gb_biker_contraband_sell") or scripts.is_active("business_battles_sell")) then
		if ImGui.Button("Fade In") then
			CAMERA.DO_SCREEN_FADE_IN(500)
		end
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Use this if you're stuck on a black screen.") end

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
	ImGui.Text("Instant-Buy")ImGui.Separator()ImGui.Spacing()

	if ImGui.Button("Special Cargo##buy", 185) then
		if scripts.is_active("gb_contraband_buy") then
			ScriptLocal("gb_contraband_buy", 634 + 5):set_int(1)
			ScriptLocal("gb_contraband_buy", 634 + 1):set_int(CEO_instantbuy_amount)
			ScriptLocal("gb_contraband_buy", 634 + 191):set_int(6)
			ScriptLocal("gb_contraband_buy", 634 + 192):set_int(4)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Special Cargo Buy Mission first!", 3000)
		end
	end

	ImGui.PushItemWidth(100) ImGui.SameLine() CEO_instantbuy_amount = ImGui.InputInt("Crates Amount", CEO_instantbuy_amount) ImGui.PopItemWidth()

	if ImGui.Button("Nightclub Goods##steal", 185) then
		if scripts.is_active("fm_content_club_source") then
			script.run_in_callback(function()
				TpToBlip(true, Blips.LEVEL, false)
				script.yield(500) TpToBlip(true, Blips.CONTRABAND, false)
				CurPlayerCoords()
				local veh = VEHICLE.GET_RANDOM_VEHICLE_IN_SPHERE(PlaCoords.x, PlaCoords.y, PlaCoords.z, 10, 2053223216, 101247)
				if Entity(veh):get_model() == 2053223216 then
					local drivernomore = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, 0)
					if not Vehicle(veh):is_seat_free(-1) then Entity(drivernomore):delete() end
					script.yield(500) PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), veh, -1)
					TpToBlip(true, Blips.LEVEL, false)
				end
				script.yield(500) TpToBlip(true, Blips.LEVEL, false)
			end)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Goods Steal Mission first!", 3000)
		end
	end

	ImGui.SameLine() commandmgr.get_command("NC_goodtype"):draw()
	ImGui.SetNextItemWidth(100) ImGui.SameLine()
	ImGui.SameLine()
	ncstealamount = ImGui.InputInt("Amount##ncgoodtype", ncstealamount)
	if ncstealamount == 0 then ncstealamount = 1 end

	if scripts.is_active("fm_content_club_source") then
		if not ncgotgood then
			script.run_in_callback(function()
				script.yield(300)
				local ncgoodtype = ScriptLocal("fm_content_club_source", 3726 + 728 + 3):get_int() + 1
				ncstealamount = tunables.get_int(NC_goodstype[ncgoodtype].goodTunable)
				commandmgr.get_command("NC_goodtype"):set_value(ncgoodtype)
				ncgotgood = true
			end)
		else
			tunables.set_int(NC_goodstype[commandmgr.get_command("NC_goodtype"):get_value()].goodTunable, ncstealamount)
		end
	else
		ncgotgood = false
	end

	if ImGui.Button("Vehicle Cargo##steal", 185) then
		if scripts.is_active("gb_vehicle_export") then
			ScriptLocal("gb_vehicle_export", 889 + 459):set_int(12)
			script.run_in_callback(function()
				TpToBlip(true, Blips.LEVEL, false)
				script.yield(500) TpToBlip(true, Blips.SPORTS_CAR, false)
				Joyrider(10)
				script.yield(500) TpToBlip(true, Blips.LEVEL, false)
				players.get_local():set_wanted_level(0)
			end)
		else
			notify.info("TinkerScript - Biz-Teroids", "You must start a Vehicle Cargo Steal Mission first!", 3000)
		end
	end

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()

	ImGui.Text("Extras")ImGui.Separator()ImGui.Spacing()

	if ImGui.Button("Trigger Excess Weapon Parts") then
		GlobalSetBit(ScriptGlobal(2658296):at(PLAYER.PLAYER_ID(), 468):at(465), 1, 1)
	end

	if scripts.is_active("fm_content_ammunation") then
		ImGui.SameLine()
		if ImGui.Button("Deliver") then
			ScriptLocal("fm_content_ammunation", 2217 + 208):set_int(3)
			ScriptLocal("fm_content_ammunation", 2154 + 1):set_int(-1071628608)
		end
	end

	if ImGui.Button("Trigger Bar Earnings") then
		script.run_in_callback(function()
			for i = 1, 5 do
				stats.set_packed_int(36620, 1)
				script.yield(1500)
				ScriptGlobal(1882760):set_int(1)
			end
		end)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Fills your MC Clubhouse Bag\nCurrent Bar Earnings: $"..stats.get_int("MPX_BIKER_BAR_RESUPPLY_CASH")) end
end)

---|| Phone Master ||------------------------------------------------------------------------------

local function PhoneMaster(deftheme, theme, oldmodel)
	ScriptGlobal(80362):set_int(deftheme)
	ScriptGlobal(114990 + 14060):at(ScriptGlobal(21666):get_int(), 20):set_string(theme)
	ScriptGlobal(21609):set_int(oldmodel)
end

local function LetMeTakeASelfie()
	script.run_in_callback(function()
		if PAD.IS_CONTROL_JUST_PRESSED(0, 73) then
			ScriptGlobal(24076):set_int(1)
			script.yield(500)
			ScriptGlobal(24075):set_int(8)
			script.yield(2000)
			ScriptGlobal(24075):set_int(0)
		end
	end)
end

local pm_ContactOverrideList = {
	{ 104, "Juliet" },
	{ 105, "Nikki" },
	{ 106, "Chastity" },
	{ 107, "Cheetah" },
	{ 108, "Sapphire" },
	{ 109, "Infernus" },
	{ 110, "Fufu" },
	{ 111, "Peach" }
}

local pm_Themes = {
	{ 1, "Default Theme",  "CELLPHONE_IFRUIT" },
	{ 2, "Franklin", "CELLPHONE_BADGER" },
	{ 3, "Michael",  "CELLPHONE_IFRUIT" },
	{ 4, "Trevor",   "CELLPHONE_FACADE" },
	{ 5, "Celltowa", "CELLPHONE_PROLOGUE" }
}

local pm_SoundSets = {
	{ 1, "Franklin",  "Phone_SoundSet_Franklin" },
	{ 2, "Michael (Default)", "Phone_SoundSet_Michael" },
	{ 3, "Trevor",   "Phone_SoundSet_Trevor" },
	{ 4, "Prologue", "Phone_SoundSet_Prologue" },
	{ 5, "Default (?)",  "Phone_SoundSet_Default" }
}

local pm_Background = {
	{ 0,  "Crew Emblem" },
	{ 10,  "Blue Angles" },
	{ 11,  "Blue Shards" },
	{ 12,  "Blue Circles" },
	{ 13, "Diamonds" },
	{ 14, "Green Glow" },
	{ 9,  "Green Shards" },
	{ 5,  "Green Squares" },
	{ 8,  "Green Triangles" },
	{ 15, "Orange 8-Bit" },
	{ 7,  "Orange Halftone" },
	{ 6,  "Orange Herringbone" },
	{ 16, "Orange Triangles" },
	{ 4,  "Purple Glow" },
	{ 17, "Purple Tartan" }
}

local pm_ColorScheme = {
	{ 1, "Blue" },
	{ 2, "Green" },
	{ 3, "Red" },
	{ 4, "Orange" },
	{ 5, "Gray" },
	{ 6, "Purple" },
	{ 7, "Pink" }
}


local pm_celltowaon = false
local selected_theme = pm_Themes[1]
local function pm_AnimToggle(anim)

	PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 242, not anim)
	PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 243, not anim)
	PED.SET_PED_CONFIG_FLAG(PLAYER.PLAYER_PED_ID(), 244, not anim)

	if PAD.IS_CONTROL_JUST_PRESSED(0, 172) or PAD.IS_CONTROL_JUST_PRESSED(0, 181) then
		GTA.CELL_SET_INPUT(1)
	elseif PAD.IS_CONTROL_JUST_PRESSED(0, 173) or PAD.IS_CONTROL_JUST_PRESSED(0, 180) then
		GTA.CELL_SET_INPUT(2)
	elseif PAD.IS_CONTROL_JUST_PRESSED(0, 174) then
		GTA.CELL_SET_INPUT(3)
	elseif  PAD.IS_CONTROL_JUST_PRESSED(0, 175) then
		GTA.CELL_SET_INPUT(4)
	elseif PAD.IS_CONTROL_JUST_PRESSED(0, 176) or PAD.IS_CONTROL_JUST_PRESSED(0, 177) then
		GTA.CELL_SET_INPUT(5)
	end

	if scripts.is_active("appmpemail") then
		GTA.CELL_HORIZONTAL_MODE_TOGGLE(true)
	elseif not scripts.is_active("appmpemail") then
		if not commandmgr.get_command("pm_LeanKey"):get_value() then GTA.CELL_HORIZONTAL_MODE_TOGGLE(false) end
	end

	script.run_in_callback(function()
		if scripts.is_active("appemail") and not scripts.is_active("appmpemail") then
			if CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() ~= 4 then
				PhoneMaster(1, selected_theme[3], 0)
			end
			SCRIPT.REQUEST_SCRIPT("appmpemail")
			script.yield(50)
			if SCRIPT.HAS_SCRIPT_LOADED("appmpemail") then
				scripts.run_as_script("appemail", function() SCRIPT.TERMINATE_THIS_THREAD() end)
				BUILTIN.START_NEW_SCRIPT("appmpemail", 2600)
				SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED("appmpemail")
			end
		end
	end)

	-- Closest I can get to hide the phone when player is in first person mode like in sp
	if commandmgr.get_command("pm_ThemeList"):get_value() == 1 then
		if ScriptGlobal(21666 + 1):get_int() == 3 then
			PhoneMaster(1, "CELLPHONE_IFRUIT", 0)
		elseif ScriptGlobal(21666 + 1):get_int() == 6 and CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() ~= 4 then
			PhoneMaster(1, "CELLPHONE_IFRUIT", 0)
		elseif ScriptGlobal(21666 + 1):get_int() >= 6 and CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() == 4 then
			PhoneMaster(0, "CELLPHONE_IFRUIT", 0)
		end
	elseif commandmgr.get_command("pm_ThemeList"):get_value() >= 1 then
		if ScriptGlobal(21666 + 1):get_int() == 6 then
			PhoneMaster(0, selected_theme[3], 0)
		end
	end

end

local pm_pitch = -90.0
local pm_yaw   = 0
local pm_roll  = 0
local pm_gotphonepos = false

local pm_isphonelean = false
local function pm_Lean()
	if PAD.IS_CONTROL_JUST_PRESSED(0, 183) then
		GTA.CELL_HORIZONTAL_MODE_TOGGLE(not pm_isphonelean)
		pm_isphonelean = not pm_isphonelean
	end
end

commandmgr.add_looped_command("pm_Anims", "Phone Animations", "Enables Phone Animations", function()

	pm_AnimToggle(true)

end, function()
	if commandmgr.get_command("pm_ThemeList"):get_value() > 1 then
		commandmgr.get_command("pm_Anims"):set_value(false)
		notify.info("TinkerScript - Phone Master", "Enable \"Phone Animations\" before selecting a Theme.", 3000)
	end
	if commandmgr.get_command("pm_ModelCelltowa"):get_value() then
		notify.info("TinkerScript - Phone Master", "Enable \"Phone Animations\" before enabling \"Celltowa Phone Model\".", 3000)
	end

end, function()

	pm_AnimToggle(false)
	if commandmgr.get_command("pm_ThemeList"):get_value() == 1 then
		PhoneMaster(1, "CELLPHONE_IFRUIT", 0)
	end

end)

commandmgr.add_looped_command("pm_LeanKey", "Manual Horizontal Mode", "Put your phone in horizontal mode by pressing [G].", function()
	pm_Lean()
end, function()
end, function()
	pm_AnimToggle(false)
end)

commandmgr.add_looped_command("pm_ModelCelltowa", "Celltowa Phone Model", "eww... iFruit", function()

	PhoneMaster(0, "CELLPHONE_IFRUIT", 1)

	if CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() == 4 then
		pm_AnimToggle(true)
	end
	if commandmgr.get_command("pm_Anims"):get_value() then
		commandmgr.get_command("pm_Anims"):set_value(false)
	end
	if commandmgr.get_command("pm_ThemeList"):get_value() > 1 then
		commandmgr.get_command("pm_ThemeList"):set_value(1)
		notify.info("TinkerScript - Phone Master", "Disable \"Celltowa Phone Model\" before selecting a Phone Theme.", 3000)
	end

end, function()
	pm_celltowaon = true
end, function()

	pm_AnimToggle(false)
	PhoneMaster(1, "CELLPHONE_IFRUIT", 0)
	pm_celltowaon = false

end)

commandmgr.add_looped_command("pm_ScreenShot", "Remote Snapmatic", "Allows you to take a screenshot with Snapmatic at any moment by pressing [X].", function()
	LetMeTakeASelfie()
end)

commandmgr.add_list_command("pm_contactslist", "Strippers", "", pm_ContactOverrideList, 104)

commandmgr.add_looped_command("pm_ContactOverride", "Contact Override", "Redirects the call to a custom selected contact. Overrides Lester.", function()
	if ScriptGlobal(8817):get_int() == 12 then
		ScriptGlobal(8817):set_int(commandmgr.get_command("pm_contactslist"):get_value())
	end
end)

commandmgr.add_list_command("pm_ThemeList", "Theme", "Allows you to use phone themes from Story Mode", pm_Themes, 1, function()
	selected_theme = pm_Themes[commandmgr.get_command("pm_ThemeList"):get_value()]
	PhoneMaster(0, selected_theme[3], 0)
	if selected_theme[1] == 1 then
		PhoneMaster(1, "CELLPHONE_IFRUIT", 0)
	end
end)

commandmgr.add_list_command("pm_SoundSetList", "Sound Set", "Allows you to use phone Sound Sets from Story Mode", pm_SoundSets, 2, function()
	selected_soundset = pm_SoundSets[commandmgr.get_command("pm_SoundSetList"):get_value()]
	if selected_soundset[1] == 1 then
		ScriptGlobal(21655):set_string("Phone_SoundSet_Michael")
	end
end)

commandmgr.add_list_command("pm_BackgroundList", "Background", "Allows you to use phone Sound Sets from Story Mode", pm_Background, stats.get_int("MPX_FM_CELLPHONE_BACKGROUND"), function()
	local selected_background = commandmgr.get_command("pm_BackgroundList"):get_value()
	stats.set_int("MPX_FM_CELLPHONE_BACKGROUND", selected_background)
end)

commandmgr.add_list_command("pm_ColorSchemeList", "Color Scheme", "Allows you to use phone Sound Sets from Story Mode", pm_ColorScheme, stats.get_int("MPX_FM_CELLPHONE_THEME"), function()
	local selected_colscheme = commandmgr.get_command("pm_ColorSchemeList"):get_value()
	stats.set_int("MPX_FM_CELLPHONE_THEME", selected_colscheme)
end)

local pm_resetpos = false
TS_PhoneMaster:imgui(function() if not IsOnline() then ImGui.TextDisabled("Please join a freemode session.") return end

	--ImGui.SeparatorText("Phone Master")
	ImGui.Text("Main")ImGui.Separator()ImGui.Spacing()
	if not pm_gotphonepos and ScriptGlobal(44938):get_int() == 15 and ScriptGlobal(21666 + 1):get_int() == 6 then
		pm_gotStartpos = ScriptGlobal(21612 + 1):get_vector3()
		pm_gotEndpos   = ScriptGlobal(21619 + 1):get_vector3()
		pm_StartXPos = pm_gotStartpos.x
		pm_StartYPos = pm_gotStartpos.y
		pm_StartZPos = pm_gotStartpos.z
		pm_EndXPos   = pm_gotEndpos.x
		pm_EndYPos   = pm_gotEndpos.y
		pm_EndZPos   = pm_gotEndpos.z
		pm_gotphonepos = true
	elseif pm_gotphonepos and ScriptGlobal(44938):get_int() == 15 and ScriptGlobal(21666):get_int() >= 2 then
		ScriptGlobal(21612 + 1):set_vector3(Vector3(pm_StartXPos, pm_StartYPos, pm_StartZPos))
    	ScriptGlobal(21619 + 1):set_vector3(Vector3(pm_EndXPos, pm_EndYPos, pm_EndZPos))
    	ScriptGlobal(21626):set_float(pm_pitch)
    	ScriptGlobal(21626 + 1):set_float(pm_yaw)
    	ScriptGlobal(21626 + 2):set_float(pm_roll)
    end
	if selected_soundset then
		ScriptGlobal(21655):set_string(selected_soundset[3])
	end

	commandmgr.get_command("pm_Anims"):draw()
	if commandmgr.get_command("pm_Anims"):get_value() then
		ImGui.SameLine() commandmgr.get_command("pm_LeanKey"):draw()
	end

    commandmgr.get_command("pm_ScreenShot"):draw()
	commandmgr.get_command("pm_ContactOverride"):draw()

	if commandmgr.get_command("pm_ContactOverride"):get_value() then
		ImGui.SameLine() commandmgr.get_command("pm_contactslist"):draw()
	end

	ImGui.Spacing()

	ImGui.Text("Customize")ImGui.Separator()ImGui.Spacing()

    commandmgr.get_command("pm_ThemeList"):draw()
    commandmgr.get_command("pm_SoundSetList"):draw() if ImGui.IsItemHovered() then ImGui.SetTooltip("Last one is not the \"Default\" in freemode.") end

	if commandmgr.get_command("pm_BackgroundList"):get_value() == nil then commandmgr.get_command("pm_BackgroundList"):set_value(stats.get_int("MPX_FM_CELLPHONE_BACKGROUND")) end
	if commandmgr.get_command("pm_ColorSchemeList"):get_value() == nil then commandmgr.get_command("pm_ColorSchemeList"):set_value(stats.get_int("MPX_FM_CELLPHONE_THEME")) end

	commandmgr.get_command("pm_BackgroundList"):draw()
	commandmgr.get_command("pm_ColorSchemeList"):draw()

	if commandmgr.get_command("pm_ThemeList"):get_value() > 1 and CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() ~= 4 then
		pm_AnimToggle(false)
	end
	if commandmgr.get_command("pm_ThemeList"):get_value() > 1 and CAMERA.GET_FOLLOW_PED_CAM_VIEW_MODE() == 4 then
		pm_AnimToggle(true)
	end

	ImGui.Spacing()

	commandmgr.get_command("pm_ModelCelltowa"):draw()

	ImGui.Spacing()ImGui.Spacing()
	ImGui.Text("Phone Orientation")ImGui.Separator()ImGui.Spacing()
	ImGui.PushItemWidth(350)

	pm_pitch = ImGui.SliderFloat("Pitch", pm_pitch, -360.0, 360.0) if ImGui.IsItemHovered() then ImGui.SetTooltip("+ = Forward\n- = Backward") end ImGui.SameLine() if ImGui.Button("Reset##pitch") then pm_pitch = -90.0 end
	pm_yaw 	 = ImGui.SliderFloat("Yaw", pm_yaw, -360.0, 360.0)     if ImGui.IsItemHovered() then ImGui.SetTooltip("+ = Right\n- = Left") end ImGui.SameLine(0, 13) if ImGui.Button("Reset##yaw") then pm_yaw = 0 end
	pm_roll	 = ImGui.SliderFloat("Roll", pm_roll, 360.0, -360.0)   if ImGui.IsItemHovered() then ImGui.SetTooltip("+ = Left\n- = Right") end ImGui.SameLine(0, 16) if ImGui.Button("Reset##roll") then pm_roll = 0 end
	ImGui.Spacing()
	if ImGui.Button("Reset Phone Orientation") then
		pm_pitch = -90.0
		pm_yaw = 0
		pm_roll = 0
	end
	ImGui.Spacing()

	ImGui.PopItemWidth()

	ImGui.Text("Phone Position") if ImGui.IsItemHovered() then ImGui.SetTooltip("Think of this as a keyframe animation") end ImGui.Separator()ImGui.Spacing()
	if pm_gotphonepos then
		ImGui.PushItemWidth(350)

		pm_StartXPos = ImGui.SliderFloat("Start X Position", pm_StartXPos, -360.0, 360.0) ImGui.SameLine(0, 7) if ImGui.Button("Reset##StartXPos") then pm_StartXPos = pm_gotStartpos.x end
		pm_StartYPos = ImGui.SliderFloat("Start Y Position", pm_StartYPos, -360.0, 360.0) ImGui.SameLine(0, 7) if ImGui.Button("Reset##StartYPos") then pm_StartYPos = pm_gotStartpos.y end
		pm_StartZPos = ImGui.SliderFloat("Start Z Position", pm_StartZPos, -360.0, 360.0) ImGui.SameLine(0, 6) if ImGui.Button("Reset##StartZPos") then pm_StartZPos = pm_gotStartpos.z end

		ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()

		pm_EndXPos = ImGui.SliderFloat("End X Position", pm_EndXPos, -360.0, 360.0) ImGui.SameLine(0, 7) if ImGui.Button("Reset##EndXPos") then pm_EndXPos = pm_gotEndpos.x end
		pm_EndYPos = ImGui.SliderFloat("End Y Position", pm_EndYPos, -360.0, 360.0) ImGui.SameLine() if ImGui.Button("Reset##EndYPos") then pm_EndYPos = pm_gotEndpos.y end
		pm_EndZPos = ImGui.SliderFloat("End Z Position", pm_EndZPos, -360.0, 360.0) ImGui.SameLine(0, 6) if ImGui.Button("Reset##EndZPos") then pm_EndZPos = pm_gotEndpos.z end

		ImGui.Spacing()

		if ImGui.Button("Reset Phone Position") or pm_resetpos then
			pm_StartXPos = pm_gotStartpos.x
			pm_StartYPos = pm_gotStartpos.y
			pm_StartZPos = pm_gotStartpos.z
			pm_EndXPos = pm_gotEndpos.x
			pm_EndYPos = pm_gotEndpos.y
			pm_EndZPos = pm_gotEndpos.z
			pm_resetpos = false
		end
		ImGui.PopItemWidth()


		if ImGui.Button("Reset All") then
			pm_pitch = -90.0
			pm_yaw = 0
			pm_roll = 0
			pm_resetpos = true
		end
	else
		ImGui.TextDisabled("Pull out your phone to be able to use this feature.")
	end
end)


---|| Gun Van Halen ||------------------------------------------------------------------------------

local GVweapons = {
    { 0,	"" },
    { -1357824103,	"Advanced Rifle" },
    { -1834847097,	"Antique Cavalry Dagger" },
    { 584646201,	"AP Pistol" },
    { 961495388,	"Assault Rifle Mk II" },
    { -1074790547,	"Assault Rifle" },
    { -494615257,	"Assault Shotgun" },
    { -270015777,	"Assault SMG" },
    { -1786099057,	"Baseball Bat" },
    { -853065399,	"Battle Axe" },
    { 1924557585,	"Battle Rifle" },
    { -102323637,	"Bottle" },
    { -2066285827,	"Bullpup Rifle Mk II" },
    { 2132975508,	"Bullpup Rifle" },
    { -1654528753,	"Bullpup Shotgun" },
    { 1703483498,	"Candy Cane" },
    { -86904375,	"Carbine Rifle Mk II" },
    { -2084633992,	"Carbine Rifle" },
    { 727643628,	"Ceramic Pistol" },
    { -608341376,	"Combat MG Mk II" },
    { 2144741730,	"Combat MG" },
    { 171789620,	"Combat PDW" },
    { 1593441988,	"Combat Pistol" },
    { 94989220,		"Combat Shotgun" },
    { -618237638,	"Compact EMP Launcher" },
    { 125959754,	"Compact Grenade Launcher" },
    { 1649403952,	"Compact Rifle" },
    { -2067956739,	"Crowbar" },
    { -275439685,	"Double Barrel Shotgun" },
    { -1746263880,	"Double-Action Revolver" },
    { -1916886713,	"El Strickler" },
    { 2138347493,	"Firework Launcher" },
    { 1198879012,	"Flare Gun" },
    { -1951375401,	"Flashlight" },
    { -1568386805,	"Grenade Launcher" },
    { 1627465347,	"Gusenberg Sweeper" },
    { 1317494643,	"Hammer" },
    { -102973651,	"Hatchet" },
    { -771403250,	"Heavy Pistol" },
    { -879347409,	"Heavy Revolver Mk II" },
    { -1045183535,	"Heavy Revolver" },
    { -947031628,	"Heavy Rifle" },
    { 984333226,	"Heavy Shotgun" },
    { 177293209,	"Heavy Sniper Mk II" },
    { 205991906,	"Heavy Sniper" },
    { 1672152130,	"Homing Launcher" },
    { -1716189206,	"Knife" },
    { -656458692,	"Knuckle Duster" },
    { -581044007,	"Machete" },
    { -619010992,	"Machine Pistol" },
    { -598887786,	"Marksman Pistol" },
    {  1785463520,	"Marksman Rifle Mk II" },
    { -952879014,	"Marksman Rifle" },
    { -1660422300,	"MG" },
    { 324215364,	"Micro SMG" },
    { -1658906650,	"Military Rifle" },
    { -1121678507,	"Mini SMG" },
    { 1119849093,	"Minigun" },
    { -1466123874,	"Musket" },
    { -1853920116,	"Navy Revolver" },
    { 1737195953,	"Nightstick" },
    { 1470379660,	"Perico Pistol" },
    { 419712736,	"Pipe Wrench" },
    { -1716589765,	"Pistol .50" },
    { -1075685676,	"Pistol Mk II" },
    { 453432689,	"Pistol" },
    { -1810795771,	"Pool Cue" },
    { 1853742572,	"Precision Rifle" },
    { 1432025498,	"Pump Shotgun Mk II" },
    { 487013001,	"Pump Shotgun" },
    { -22923932,	"Railgun" },
    { -1312131151,	"RPG" },
    { 2017895192,	"Sawed-Off Shotgun" },
    { -774507221,	"Service Carbine" },
    { 2024373456,	"SMG Mk II" },
    { 736523883,	"SMG" },
    { 100416529,	"Sniper Rifle" },
    { 62870901,		"Snowball Launcher" },
    { -2009644972,	"SNS Pistol Mk II" },
    { -1076751822,	"SNS Pistol" },
    { -1768145561,	"Special Carbine Mk II" },
    { -1063057011,	"Special Carbine" },
    { 1171102963,	"Stun Gun" },
    { 317205821,	"Sweeper Shotgun" },
    { -538741184,	"Switchblade" },
    { 350597077,	"Tactical SMG" },
    { -624951259,	"The Shocker" },
    { 1198256469,	"Unholy Hellbringer" },
    { -1355376991,	"Up-n-Atomizer" },
    { 137902532,	"Vintage Pistol" },
    { -1238556825,	"Widowmaker" }
}

local GVthrowweapons = {
    { 0,	"" },
    { -1813897027,	"Grenade" },
    { -37975472,	"Tear Gas" },
    { 741814745,	"Sticky Bomb" },
    { -1420407917,	"Proximity Mine" },
    { -1169823560,	"Pipe Bomb" },
    { 883325847,	"Jerry Can" },
    { 615608432,	"Molotov" }
}

for i = 1, 10 do
	commandmgr.add_list_command("gv_weaponlist"..i, "Slot "..i.."##weapl"..i, "", GVweapons, tunables.get_int("XM22_GUN_VAN_SLOT_WEAPON_TYPE_"..i - 1), function()
		local GV_selectedweap  = commandmgr.get_command("gv_weaponlist"..i):get_value()
		tunables.set_int("XM22_GUN_VAN_SLOT_WEAPON_TYPE_"..i - 1, GV_selectedweap)
	end)
end

for i = 1, 3 do
	commandmgr.add_list_command("gv_throwlist"..i, "Slot "..i.."##throwl"..i, "", GVthrowweapons, tunables.get_int("XM22_GUN_VAN_SLOT_THROWABLE_TYPE_"..i - 1), function()
		local GV_selectedthrow  = commandmgr.get_command("gv_throwlist"..i):get_value()
		tunables.set_int("XM22_GUN_VAN_SLOT_THROWABLE_TYPE_"..i - 1, GV_selectedthrow)
	end)
end

commandmgr.add_bool_command("gv_getcurweap", "##getcurweap", "", false, function() -- used to print the current gun van weapons, now it just reloads the slots
	for i = 1, 10 do
		commandmgr.get_command("gv_weaponlist"..i):set_value(tunables.get_int("XM22_GUN_VAN_SLOT_WEAPON_TYPE_"..i - 1))
	end
	for i = 1, 3 do
		commandmgr.get_command("gv_throwlist"..i):set_value(tunables.get_int("XM22_GUN_VAN_SLOT_THROWABLE_TYPE_"..i - 1))
	end
end)

local gunvanlocs = {
	{ locname = "Paleto Bay",         	GVcoords = {-29.532, 6435.136, 31.162}	 },
	{ locname = "Grapeseed",          	GVcoords = {1705.214, 4819.167, 41.75}	 },
	{ locname = "Sandy Shores",       	GVcoords = {1795.522, 3899.753, 33.869}	 },
	{ locname = "Grand Senora Desert",	GVcoords = {1335.536, 2758.746, 51.099}	 },
	{ locname = "Vinewood Sign",     	GVcoords = {795.583, 1210.78, 338.962}	 }, -- *Galileo Park - Vinewood Hills
	{ locname = "Chumash",            	GVcoords = {-3192.67, 1077.205, 20.594}	 },
	{ locname = "Paleto Forest",      	GVcoords = {-789.719, 5400.921, 33.915}	 },
	{ locname = "Zancudo River",      	GVcoords = {-24.384, 3048.167, 40.703}	 },
	{ locname = "Power Station",      	GVcoords = {2666.786, 1469.324, 24.237}	 }, -- *Palmer-Taylor Power Station
	{ locname = "Lago Zancudo",      	GVcoords = {-1454.966, 2667.503, 3.2}	 }, -- *Fort Zancudo Approach Rd
	{ locname = "Thomson Scrapyard", 	GVcoords = {2340.418, 3054.188, 47.888}	 },
	{ locname = "El Burro Heights",  	GVcoords = {1509.183, -2146.795, 76.853} }, -- *Car Scrapyard
	{ locname = "Murrieta Heights",  	GVcoords = {1137.404, -1358.654, 34.322} },
	{ locname = "Elysian Island",    	GVcoords = {-57.208, -2658.793, 5.737}	 },
	{ locname = "Tataviam Mountains",	GVcoords = {1905.017, 565.222, 175.558}	 }, -- *Land Act Reservoir
	{ locname = "La Mesa",           	GVcoords = {974.484, -1718.798, 30.296}	 }, -- *Fridgit, Forced Labor Place
	{ locname = "Terminal",          	GVcoords = {779.077, -3266.297, 5.719}	 },
	{ locname = "La Puerta",         	GVcoords = {-587.728, -1637.208, 19.611} }, -- *Rogers Salvage & Scrap
	{ locname = "La Mesa",           	GVcoords = {733.99, -736.803, 26.165}	 }, -- *Popular Street
	{ locname = "Del Perro",         	GVcoords = {-1694.632, -454.082, 40.712} },
	{ locname = "Magellan Ave",      	GVcoords = {-1330.726, -1163.948, 4.313} }, -- *Vespucci Beach
	{ locname = "West Vinewood",     	GVcoords = {-496.618, 40.231, 52.316}	 },
	{ locname = "Downtown Vinewood", 	GVcoords = {275.527, 66.509, 94.108}	 },
	{ locname = "Pillbox Hill",      	GVcoords = {260.928, -763.35, 30.559}	 },
	{ locname = "Little Seoul",      	GVcoords = {-478.025, -741.45, 30.299}	 }, -- *Caesars Auto Parking
	{ locname = "Alamo Sea",         	GVcoords = {894.94, 3603.911, 32.56}	 }, -- *Joshua Road
	{ locname = "North Chumash",     	GVcoords = {-2166.511, 4289.503, 48.733} }, -- *Hookies
	{ locname = "Mount Chiliad",     	GVcoords = {1465.633, 6553.67, 13.771}	 }, -- *Procopio Beach
	{ locname = "Mirror Park",       	GVcoords = {1101.032, -335.172, 66.944}	 }, -- *Hearty Taco
	{ locname = "Davis",             	GVcoords = {149.683, -1655.674, 29.028}	 } -- *Bishop's Chicken
}

TS_GoonVan:imgui(function() if not IsOnline() then ImGui.TextDisabled("Please join a freemode session.") return end

	ImGui.Text("Current Gun Van Location")ImGui.Separator()ImGui.Spacing()

	local GVteleport = gunvanlocs[stats.get_packed_int(41239) + 1]
	if ImGui.Button("Teleport to "..GVteleport.locname) then
		local GVloc = GVteleport.GVcoords
		PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), GVloc[1], GVloc[2], GVloc[3]+1.0)
	end  --ImGui.SameLine()
	ImGui.Spacing()ImGui.Spacing()

	ImGui.Text("Slots Editor")ImGui.Separator()ImGui.Spacing()

	ImGui.BeginGroup()
	ImGui.Text("Weapon Slots") ImGui.Spacing()
	for i = 1, 10 do
		commandmgr.get_command("gv_weaponlist"..i):draw()
	end
	ImGui.EndGroup()

	ImGui.SameLine(0, 20)
	ImGui.BeginGroup()
	ImGui.Text("Throwable Slots") ImGui.Spacing()
	for i = 1, 3 do
		commandmgr.get_command("gv_throwlist"..i):draw()
	end ImGui.EndGroup()

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()

	if not commandmgr.get_command("gv_getcurweap"):get_value() then
		commandmgr.get_command("gv_getcurweap"):set_value(true)
	end

	if ImGui.Button("Reload Slots") then
		commandmgr.get_command("gv_getcurweap"):set_value(false)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Reloads Gun Van slots.") end -- just because, probably not too useful

	ImGui.Spacing()ImGui.Text("Others")ImGui.Separator()ImGui.Spacing()

	ImGui.SameLine(0, 3.8)
	ImGui.BeginGroup()
	if ImGui.TreeNodeEx("Unlock Weapons  ##"..nomoretreeplease, 8219) then
		ImGui.Spacing()
		ImGui.SameLine(-3.8, 0)

		--if ImGui.Button("WM29 Pistol") then
		--	if transactions.can_use_transactions() then
		--		--baskettranscationsdon'twork
		--		--notify.success("TinkerScript - Gun Van Halen", "WM29 Pistol unlocked!\nPlease change sesions to see the changes", 3000)
		--	else
		--		stats.set_masked_int("MPX_CHAR_WEAP_FM_PURCHASE3", 31, 0, 1)
		--		notify.success("TinkerScript - Gun Van Halen", "WM29 Pistol unlocked!\nPlease change sesions to see the changes", 3000)
		--	end
		--end
		ImGui.BeginGroup()
		if ImGui.Button("Golf Club") then
			stats.set_int("MPX_GCLUB_FM_AMMO_BOUGHT", 1) -- from https://www.unknowncheats.me/forum/4165404-post4.html
			notify.success("TinkerScript - Gun Van Halen", "Golf Club unlocked!", 3000)
		end

		if ImGui.Button("Stone Hatchet") then
			stats.set_packed_int(7315, 6)
			stats.set_packed_bool(22073, true)
			notify.success("TinkerScript - Gun Van Halen", "Stone Hatchet unlocked!", 3000)
		end

		if ImGui.Button("Up-n-Atomizer") then
			stats.set_packed_bool(25002, true)
			notify.success("TinkerScript - Gun Van Halen", "Up-n-Atomizer unlocked!", 3000)
		end

		if ImGui.Button("Service Carbine") then
			stats.set_packed_bool(32318, true)
			notify.success("TinkerScript - Gun Van Halen", "Service Carbine unlocked!", 3000)
		end

		if ImGui.Button("Snowball Launcher") then
			stats.set_packed_bool(42148, true)
			notify.success("TinkerScript - Gun Van Halen", "Snowball Launcher unlocked!", 3000)
		end

		if ImGui.Button("Candy Cane") then
			stats.set_packed_bool(42249, true)
			notify.success("TinkerScript - Gun Van Halen", "Candy Cane unlocked!", 3000)
		end

		if ImGui.Button("The Shocker") then
			stats.set_packed_bool(51196, true)
			notify.success("TinkerScript - Gun Van Halen", "The Shocker unlocked!", 3000)
		end
		ImGui.EndGroup()
		ImGui.SameLine()
		ImGui.Dummy(15.7, 0)
	else
		if ImGui.IsItemHovered() then ImGui.SetTooltip("Allows you to unlock login bonus weapons and the ones that can't be purchased from the Gun Van.\nChange sessions if the unlocked weapon doesn't appear on the Weapon Wheel.") end
	end
	ImGui.EndGroup()

	ImGui.SameLine()
	ImGui.BeginGroup()
	if ImGui.Button("Enable Bat & Knife Liveries") then
		stats.set_packed_bool_range(36789, 36808, true)
	end if ImGui.IsItemHovered() then ImGui.SetTooltip("Enables Bat & Knife Liveries permanently") end
	ImGui.EndGroup()

end)

---|| Rainbow Vehicles ||------------------------------------------------------------------------------

local hue_speed = 0.0574 -- Base Speed
local flicker_intensity = 15

local rainbow_speed_boost = false
	local rainbow_boost_amount = 0.1 -- Set this to 0.5 and press "E" 6 times for a "IDKWHATTOCALLTHIS" effect

local speed_level_max = 10 -- Set this to a higher value for a *CRT-ish(?) effect -- Default 10

local xenon = true -- Enable Xenon lights
local xenon_lspeed = 2

local set_plate = true -- Enable custom plates
	local plate_speed = 0.2
	local set_plate_styles = true -- Enable Custom Plates Styles
	local set_plate_animT = { { 1, "Scroll"}, {2, "Flicker"} } -- Enable Custom Plates Text Animation - 0/false = disabled | 1 = scroll | 2 = flicker
		local plate_text_scroll = "Unknown Cheats FTW    "
		local plate_scroll_speed = 200
		local plate_text_flicker = {"Unknown", "Cheats", "FTW"} -- 8 characters limit per word

local set_wheels = true -- Enable Custom Wheels - Only Big Bar w/ Retro White Wall Design for now

local hue = 0.0
local color_modeT = { {1, "Rainbow"}, {2, "Pastel"}, {3, "Flicker"}, {4, "Black/White Pulse"}, {5, "Overheat"} }
local plate_char = 0
local plate_text_current = 1
local wheel = 0
local speed_level = 0

local function RainbowDash()
	local PlaVeh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), 0)
	if PED.IS_PED_SITTING_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID()) then

		local dynamic_speed = hue_speed + (speed_level * rainbow_boost_amount)
		hue = hue + dynamic_speed

		if color_mode == 1 then -- Rainbow Default
			r = math.floor(math.sin(hue) * 127 + 128)
			g = math.floor(math.sin(hue + 2) * 127 + 128)
			b = math.floor(math.sin(hue + 4) * 127 + 128)
		elseif color_mode == 2 then -- Pastel Mode
			r = math.floor(math.sin(hue) * 50 + 205)
			g = math.floor(math.sin(hue + 2) * 50 + 205)
			b = math.floor(math.sin(hue + 4) * 50 + 205)
		elseif color_mode == 3 then -- Flicker Mode
			if math.random(1, 200) <= flicker_intensity then
				r, g, b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
			end
		elseif color_mode == 4 then -- Black/White Pulse Mode
			r = math.floor(math.sin(hue) * 127 + 128)
			g = math.floor(math.sin(hue) * 127 + 128)
			b = math.floor(math.sin(hue) * 127 + 128)
		elseif color_mode == 5 then -- Overheat Mode
			local speed = Vehicle(PlaVeh):get_speed() * 3.6 -- ENTITY.GET_ENTITY_SPEED(PlaVeh) * 3.5
			if speed < 2 then
				speed_level = 0
			elseif speed < 5 then
				r, g, b = 0, 0, 0
			elseif speed < 40 then
				speed_level = 4
				local moo = (speed - 5) / 35 -- sMOOth
				r = 0
				g = math.floor(moo * 255)
				b = math.floor(moo * 255)
			elseif speed < 80 then
				speed_level = 6
				local moo = (speed - 40) / 40
				r = math.floor(moo * 255)
				g = 255
				b = math.floor(255 - (moo * 255))
			elseif speed < 120 then
				speed_level = 8
				local moo = (speed - 80) / 40
				r = 255
				g = math.floor(255 - (moo * 255))
				b = 0
			else
				speed_level = 10
				r = 255
				g = math.min(255, math.floor(((speed - 120) / 60) * 255))
				b = math.min(255, math.floor(((speed - 120) / 60) * 255))
			end
			if speed == 0 then
				plate_scroll_speed = 100000
				plate_speed = 0
			else
				plate_scroll_speed = 200 - (speed_level * 18)
				plate_speed = 0.2 + (speed_level / 160)
			end
		end

		VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(PlaVeh, r, g, b);VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(PlaVeh, r, g, b)
		VEHICLE.TOGGLE_VEHICLE_MOD(PlaVeh, 20, 1);VEHICLE.TOGGLE_VEHICLE_MOD(PlaVeh, 22, 1);VEHICLE.TOGGLE_VEHICLE_MOD(PlaVeh, 23, 1)
		for i = 0, 3 do VEHICLE.SET_VEHICLE_NEON_ENABLED(PlaVeh, i, 1) end
		VEHICLE.SET_VEHICLE_TYRE_SMOKE_COLOR(PlaVeh, r, g, b)
		VEHICLE.SET_VEHICLE_NEON_COLOUR(PlaVeh, r, g, b)
		VEHICLE.SET_VEHICLE_WHEEL_TYPE(PlaVeh, 8)

		if xenon then
			local xenon_i = {5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4}
			local xenon_color = math.floor(hue * xenon_lspeed % #xenon_i) + 1
			VEHICLE.SET_VEHICLE_XENON_LIGHT_COLOR_INDEX(PlaVeh, xenon_i[xenon_color])
		end
		if set_plate then
			if set_plate_anim == 1 then
				if MISC.GET_GAME_TIMER() - plate_char > plate_scroll_speed then
					local plate_segment = string.sub(plate_text_scroll, plate_text_current, plate_text_current + 7) -- 8 = Character limit
					if #plate_segment < 8 then
						plate_segment = plate_segment .. string.sub(plate_text_scroll, 1, 8 - #plate_segment)
					end
					Vehicle(PlaVeh):set_plate_text(plate_segment)
					plate_char = MISC.GET_GAME_TIMER()
					plate_text_current = plate_text_current + 1
					if plate_text_current > #plate_text_scroll then
						plate_text_current = 1
					end
				end
			elseif set_plate_anim == 2 then
				local plate_iterf = math.floor(hue * plate_speed % #plate_text_flicker) + 1
				Vehicle(PlaVeh):set_plate_text(plate_text_flicker[plate_iterf])
			end
			if set_plate_styles then
				local plate_style_id = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12} -- Blue on White 1 = 0 | Yellow on Black = 1 | Yellow on Blue = 2 | Blue on White 2 = 3 | Blue on White 3 = 4 | North Yankton = 5 | Ecola = 6 | Las Venturas = 7 | Liberty City = 8 | Los Santos Car Meet = 9 | Los Santos Panicc = 10 | Los Santos Pounders = 11 | Sprunk = 12
				local plate_style = math.floor(hue * plate_speed % #plate_style_id) + 1
				VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(PlaVeh, plate_style_id[plate_style])
			end
		end
		if set_wheels then
			VEHICLE.SET_VEHICLE_MOD(PlaVeh, 23, 115, 1)
			wheel = wheel + 1
			if wheel > 160 then
				wheel = 0
			end
			VEHICLE.SET_VEHICLE_EXTRA_COLOURS(PlaVeh, 157, wheel)
		end
		VEHICLE.SET_VEHICLE_MOD_KIT(PlaVeh, 0)
	end
end

local function RainbowVehReset()
	speed_level = 0;plate_scroll_speed = 200;plate_speed = 0.2;flicker_intensity = 15
end

local rainbowveh_up = true
local function RainbowSpeed()
	if color_mode ~= 5 and rainbowveh_up then
		speed_level = speed_level + 1
		plate_scroll_speed = plate_scroll_speed - 20
		plate_speed = plate_speed + 0.05
		flicker_intensity = flicker_intensity + 10
	elseif color_mode ~= 5 and not rainbowveh_up then
		if speed_level < 1 then speed_level = 1; plate_scroll_speed = 200; flicker_intensity = 15 end
		speed_level = speed_level - 1
		plate_scroll_speed = plate_scroll_speed + 20
		plate_speed = plate_speed - 0.05
		flicker_intensity = flicker_intensity - 10
	end

	if speed_level == speed_level_max then
		HUD.BEGIN_TEXT_COMMAND_THEFEED_POST("STRING");HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(6)
		HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME("Rainbow Speed: ~y~~h~Ω MAX Ω")
		HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(1, 0)
	elseif speed_level > speed_level_max then
		RainbowVehReset()
		HUD.BEGIN_TEXT_COMMAND_THEFEED_POST("STRING")
		HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME("Rainbow Speed: ~b~Default")
		HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(1, 0)
	else
		HUD.BEGIN_TEXT_COMMAND_THEFEED_POST("STRING");HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(105)
		HUD.ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME("Rainbow Speed: ~y~"..speed_level) -- speed or cycle?
		HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(1, 0)
	end
end

commandmgr.add_looped_command("rainbowveh_toggle", "Rainbow Vehicles", "Enables Rainbow Vehicles", RainbowDash)

commandmgr.add_bool_command("rainbowveh_rainbowsb", "Rainbow Speed Boost", "Enables Rainbow Speed Boost", true, function()
	if commandmgr.get_command("rainbowveh_toggle"):get_value() then
		notify.warn("WARNING: RAINBOW SPEED BOOST ENABLED!", "This may potentially trigger seizures for people with photosensitive epilepsy.", 3000) -- template from wiklmedia ¯\_(ツ)_/¯
	end
end, RainbowVehReset)

commandmgr.add_list_command("rainbowveh_colormode", "Rainbow/Color mode", "", color_modeT, 1, RainbowVehReset)
commandmgr.add_bool_command("rainbowveh_setplates", "Custom Plates", "Enables Custom Plates", true, nil)
commandmgr.add_bool_command("rainbowveh_setplatestyle", "Plate Styles Cycle", "Enables Custom Plate Styles Cycle", true, nil)
commandmgr.add_list_command("rainbowveh_plateanimtype", "Plate Text Animation Type", "", set_plate_animT, 2, nil)
commandmgr.add_bool_command("rainbowveh_xenonl", "Xenon lights", "Enables Xenon lights", true, nil)
commandmgr.add_bool_command("rainbowveh_setwheels", "Custom Wheels", "Enables Custom Wheels", true, nil)

local newtext = 3
local NewFlicker1, NewFlicker2, NewFlicker3 = 0, 0, 0
local testcheckbox = false
TS_RainbowVeh:imgui(function() -- I was going to rework this part since I don't think it looks too good, but it just works so I probably won't be touching this anytime soon

	color_mode = commandmgr.get_command("rainbowveh_colormode"):get_value()
	rainbow_speed_boost = commandmgr.get_command("rainbowveh_rainbowsb"):get_value()
	set_plate = commandmgr.get_command("rainbowveh_setplates"):get_value()
	set_plate_anim = commandmgr.get_command("rainbowveh_plateanimtype"):get_value()
	set_plate_styles = commandmgr.get_command("rainbowveh_setplatestyle"):get_value()
	xenon = commandmgr.get_command("rainbowveh_xenonl"):get_value()
	set_wheels = commandmgr.get_command("rainbowveh_setwheels"):get_value()

	commandmgr.get_command("rainbowveh_toggle"):draw()

	if not commandmgr.get_command("rainbowveh_toggle"):get_value() then
		ImGui.TextDisabled("Somewhere over the rainbow\nOppressors fly.\nOppressors fly over the rainbow\nWhy, then, oh why don't I have money for GTA VI and a PS5?") return
	end

	ImGui.SameLine() commandmgr.get_command("rainbowveh_colormode"):draw()
	commandmgr.get_command("rainbowveh_rainbowsb"):draw()

	if rainbow_speed_boost then
		ImGui.SetNextItemWidth(40)
		ImGui.SameLine() ImGui.InputText("##rainbowspeedorcycleidk", "  "..speed_level, ImGuiInputTextFlags.ReadOnly)

		ImGui.SameLine(0, 4) if ImGui.Button("-", 25) then
			rainbowveh_up = false
			RainbowSpeed()
		end
		ImGui.SameLine(0, 4) if ImGui.Button("+", 25) then
			rainbowveh_up = true
			RainbowSpeed()
		end
		ImGui.SameLine() ImGui.Text("Rainbow Speed")
	end

	commandmgr.get_command("rainbowveh_setplates"):draw()
	if set_plate then
		ImGui.SameLine() commandmgr.get_command("rainbowveh_setplatestyle"):draw()
		ImGui.Indent()
		commandmgr.get_command("rainbowveh_plateanimtype"):draw()
		ImGui.SameLine() if commandmgr.get_command("rainbowveh_plateanimtype"):get_value() == 2 and ImGui.Button("Add Text") then
			newtext = newtext + 1
			if newtext == 4 then
				NewFlicker1 = 4
				table.insert(plate_text_flicker, "")
			elseif newtext == 5 then
				NewFlicker2 = 5
				table.insert(plate_text_flicker, "")
			elseif newtext == 6 then
				NewFlicker3 = 6
				table.insert(plate_text_flicker, "")
			elseif newtext > 6 then newtext = 6 notify.warn("TinkerScript - Rainbow Vehicles", "You can't add more words!", 3000) return end
		end
		if newtext > 3 then ImGui.SameLine() if ImGui.Button("Remove Text")then
			if newtext == 6 then
				NewFlicker3 = 0
				newtext = newtext - 1
				table.remove(plate_text_flicker, 6)
			elseif newtext == 5 then
				NewFlicker2 = 0
				newtext = newtext - 1
				table.remove(plate_text_flicker, 5)
			elseif newtext == 4 then
				NewFlicker1 = 0
				newtext = newtext - 1
				table.remove(plate_text_flicker, 4)
			elseif newtext > 3 then newtext = 3 return end
		end end

		if set_plate_anim == 2 then if ImGui.IsItemHovered() then ImGui.SetTooltip("8 characters limit per word") end
			ImGui.PushItemWidth(100)
			plate_text_flicker[1] = ImGui.InputText("Plate Text 1", plate_text_flicker[1])
			plate_text_flicker[2] = ImGui.InputText("Plate Text 2", plate_text_flicker[2])
			plate_text_flicker[3] = ImGui.InputText("Plate Text 3", plate_text_flicker[3])
			if NewFlicker1 == 4 then plate_text_flicker[NewFlicker1] = ImGui.InputText("Plate Text "..NewFlicker1.."", plate_text_flicker[NewFlicker1]) end
			if NewFlicker2 == 5 then plate_text_flicker[NewFlicker2] = ImGui.InputText("Plate Text "..NewFlicker2.."", plate_text_flicker[NewFlicker2]) end
			if NewFlicker3 == 6 then plate_text_flicker[NewFlicker3] = ImGui.InputText("Plate Text "..NewFlicker3.."", plate_text_flicker[NewFlicker3]) end
			ImGui.PopItemWidth()
		else
			ImGui.NewLine() ImGui.PushItemWidth(250) plate_text_scroll = ImGui.InputText("Plate Text", plate_text_scroll) ImGui.PopItemWidth()
		end
		ImGui.Unindent()
		ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
	end

	commandmgr.get_command("rainbowveh_xenonl"):draw()
	commandmgr.get_command("rainbowveh_setwheels"):draw()

	ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()

	testcheckbox = ImGui.Checkbox("Base Settings", testcheckbox) if ImGui.IsItemHovered() then ImGui.SetTooltip("Allows you to edit the base variables") end

	if testcheckbox then
		ImGui.SameLine() ImGui.TextDisabled("Please be careful with these.")
		ImGui.Spacing()ImGui.Spacing()ImGui.Spacing()
		ImGui.PushItemWidth(180)
		hue_speed = ImGui.SliderFloat("Hue Speed", hue_speed, 0.001, 2.0)
		rainbow_boost_amount = ImGui.SliderFloat("Rainbow Speed Multiplier", rainbow_boost_amount, 0.001, 2.0)
		speed_level_max = ImGui.SliderInt("Max Rainbow Speed", speed_level_max, 5, 50)
		ImGui.PopItemWidth()
	else
		hue_speed = 0.0574
		rainbow_boost_amount = 0.1
		speed_level_max = 10
	end


end)

---|| Recovery + (Safe Cracker) ||------------------------------------------------------------------------------

local function CrackCB()
	if ScriptLocal("fm_mission_controller_2020", 29373 + 12):get_int() == -1 then
		notify.error("TinkerScript - Cluckin' Raider", "You must be at the Safe first!", 3000) return
	end

	for i = 0, 2 do
		ScriptLocal("fm_mission_controller_2020", 32726 + 1 + 1):at(i, 2):set_int(0)
		ScriptLocal("fm_mission_controller_2020", 32726 + 1):at(i, 2):set_float(0)
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1.0)
	end
end

local function CBTpToPC()
	local CB_PCcoords = ScriptLocal("fm_mission_controller_2020", 34538 + 5):get_vector3()
	PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), CB_PCcoords.x, CB_PCcoords.y, CB_PCcoords.z + 1.0)
end

local function CBTpToCrate()
	if ScriptLocal("fm_mission_controller_2020", 21088):get_int() ~= 1149534208 then
		notify.error("TinkerScript - Cluckin' Raider", "You must be at the Storage Facility first!", 3000) return
	end

	local CB_Cratecoords = ScriptLocal("fm_mission_controller_2020", 29373 + 1192):get_vector3()
	PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), CB_Cratecoords.x, CB_Cratecoords.y, CB_Cratecoords.z)
end

commandmgr.add_looped_command("cbr_opendoors", "Open All Doors##cbr", "Opens All Doors", function()
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if Entity(h):get_model() == 258537691 then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			Entity(h):delete()
		end
	end
	if not scripts.is_active("fm_mission_controller_2020") then
		commandmgr.get_command("cbr_opendoors"):set_value(false)
	end
	end, function()
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if Entity(h):get_model() == -952356348 then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			Entity(h):delete() break
		end
	end
end)

local function CrackSH()
	if ScriptLocal("fm_content_stash_house", 153 + 16):get_int() == -1 then
		notify.error("TinkerScript - Stash House", "You must be at the Safe first!", 3000) return
	end

	for i = 0, 2 do
		ScriptLocal("fm_content_stash_house", 153 + 22 + 1):at(i, 2):set_int(0)
		ScriptLocal("fm_content_stash_house", 153 + 22):at(i, 2):set_float(0)
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1.0)
	end
end

local function TS_KortzStart()
	if ScriptGlobal(1893070):at(PLAYER.PLAYER_ID(), 625):at(10):get_int() == -1 then
		notify.error("TinkerScript - Kortz Center Cracker", "You must register as a Boss first!", 3000) return
	end
	if not scripts.is_active("fm_maintain_transition_players") then
		ScriptGlobal(1980570 + 732 + 5):set_int(1)
		for i = 1, 5 do
			script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 187, 1.0)
			script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 190, 1.0)
		end
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 201, 1.0)
	else
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 188, 1.0)
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 201, 1.0)
	end
end

local function TS_KortzFP()
	ScriptLocal("fm_mission_controller_v3", 26866):set_int(5)
end

local function TS_KortzPCAC()
	for i = 0, 2 do
		ScriptLocal("fm_mission_controller_v3", 32818 + 1 + 1):at(i, 2):set_int(0)
		script.yield(100) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1.0)
	end
end

local K26_Leasy = false
local K26_Lnodamage = false
local function TS_KortzPwrL()
	ScriptLocal("fm_mission_controller_v3", 70416):set_int(4294784)
	ScriptGlobal(1935711):set_int(1)
end

local function TS_KortzSN()
	ScriptLocal("fm_mission_controller_v3", 27914):set_int(5)
end

local function TS_KortzPaint()
	ScriptLocal("fm_mission_controller_v3", 29355 + 11):set_int(15)
	ScriptLocal("fm_mission_controller_v3", 29355 + 11):set_int(17)
	script.yield(1000) PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1.0)
end

local function TS_KortzPaint2()
	ScriptLocal("fm_mission_controller_v3", 29355 + 11):set_int(3)
	PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 219, 1.0)
end

local function TS_KortzDC()
	for b = 0, 7 do
		ScriptLocal("fm_mission_controller_v3", 1388):at(b, 4):set_int(1)
	end
end

local function TS_KortzGlass()
	for g = 0, 4 do
		ScriptLocal("fm_mission_controller_v3", 32855 + 3):at(g, 13):set_float(100)
	end
end

local function TS_KortzFinish()
	script.run_in_callback(function()
		while true do
			if scripts.is_active("fm_mission_controller_v3") and ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17718273 then
				ScriptLocal("fm_mission_controller_v3", 57250):set_int(9)
				ScriptLocal("fm_mission_controller_v3", 57250 + 1776):at(0, 1):set_int(1250)
			elseif scripts.is_active("fm_mission_controller_v3") and ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17456129 then
				ScriptLocal("fm_mission_controller_v3", 57250):set_int(9)
				ScriptLocal("fm_mission_controller_v3", 57250 + 1776):at(0, 1):set_int(1250)
			elseif scripts.is_active("fm_mission_controller_v3") and ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17456128 then
				if HUD.IS_HELP_MESSAGE_BEING_DISPLAYED() then
					FindNewSession() return
				end
			end
			script.yield(0)
		end
	end)
end

local kortz_doors = {
	-1989843262, -636649650, -763344841, 1671614326, 275743652,
	507130236, -1286517865, -421484378, -1864833911, -1925236194,
	2049614127, 454689787, -79540289, 390646248, 1895050696,
	361395225, 1430444526, -861563755, 956014487, 897048274,
	-1120166274, -1717616443, -1854411159, -1158448783, -646395663,
	-780184685, 511378549, -159586315, -434711109, -1993257312, 186527079
}

commandmgr.add_looped_command("kortz_opendoors", "Open All Doors##kortz", "Opens All Doors", function()
	for _, d in ipairs(kortz_doors) do
		OBJECT.DOOR_SYSTEM_SET_DOOR_STATE(d, 0, false, true)
	end
	if not scripts.is_active("fm_mission_controller_v3") then
		commandmgr.get_command("kortz_opendoors"):set_value(false)
	end
	end, function()
	for _, t in ipairs({0, 1, 5, 6, 7, 20, 21}) do
		ScriptGlobal(4980736 + 29174):at(t, 333):at(68):set_int(0) -- Credits to tidmouth
		ScriptGlobal(4980736 + 29174):at(t, 333):at(143):set_int(0)
	end
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if Entity(h):get_model() == -1974437642 then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true) -- false true or true true?
			end
			Entity(h):delete() break
		end
	end
end)

local kortz_cams = {
    [-630156392] = true,
    [1301284833] = true,
    [19326568] = true,
    [302330246] = true,
    [506184131] = true,
	[825790471] = true,
	[365062191] = true,
	[-301330169] = true,
	[1417894488] = true,
	[-247409812] = true,
	[-1233322078] = true
}

local kortzcamtimer = 0
local function KortzDelCams()
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if kortz_cams[Entity(h):get_model()] then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			Entity(h):delete()
		end
	end
end

commandmgr.add_looped_command("kortz_delcams", "Disable All Cameras", "Disables All Cameras", function()
	if util.time() < kortzcamtimer + 12000 then
		KortzDelCams()
	else
		commandmgr.get_command("kortz_delcams"):set_value(false)
	end
	if not scripts.is_active("fm_mission_controller_v3") then
		commandmgr.get_command("kortz_delcams"):set_value(false)
	end
	end, function()
	kortzcamtimer = util.time()
	notify.info("TinkerScript - Kortz Center Cracker", "Cameras Disabled!\nCameras rebooting in 12 seconds.")
	end, function()
	kortzcamtimer = 0
end)

local ch_doors = {
	-104143029, 1633148016, -1730152782, -1450870697, -1870500531,
	686757512, 1512975268, -1260608781, -503379382, 1649238266,
	-230581957, 277015006, -791522594, -1854580890, 714193794,
	1037783830, -1798315374, -219406021, -7449383, 1467373945,
	280344137, 1391515407, 320263035, -545816134, -1735742237,
	327933309, -1164440132, -1865839062, -1608865147, -1783267585, -104143029
}

local ch_lstacks = {
	[-2143906120] = true,
	[1228147776] = true,
	[-2143192170] = true,
	[-180074230] = true,
	[822904642] = true
}


local ch_pnts = {
	[-327407186] = true,
	[-590378411] = true,
	[-1035053785] = true,
	[-775883720] = true,
	[-1073786699] = true,
	[-1227899306] = true,
	[-1701280280] = true,
	[-1968970241] = true
}

local function ch_delcam()
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if Entity(h):get_model() == -1233322078 then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			Entity(h):delete()
		end
	end
end

commandmgr.add_looped_command("ch_opendoors", "Open All Doors##Cayo", "Opens All Doors", function()
	for _, d in ipairs(ch_doors) do
		OBJECT.DOOR_SYSTEM_SET_DOOR_STATE(d, 0, false, true)
	end
	if not scripts.is_active("fm_mission_controller_2020") then
		commandmgr.get_command("ch_opendoors"):set_value(false)
	end
	end, function()
	for _, h in ipairs(entities.get_all_objects_as_handles()) do
		if ch_lstacks[Entity(h):get_model()] then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			local blip = HUD.ADD_BLIP_FOR_ENTITY(h)
			HUD.SET_BLIP_SPRITE(blip, 618)
			HUD.SET_BLIP_COLOUR(blip, 4)
			HUD.SET_BLIP_SCALE(blip, 0.800000)
			HUD.SET_BLIP_PRIORITY(blip, 7)
		end
		if ch_pnts[Entity(h):get_model()] then
			if ENTITY.IS_ENTITY_A_MISSION_ENTITY(h)	then
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(h, false, true)
			end
			local blip = HUD.ADD_BLIP_FOR_ENTITY(h)
			HUD.SET_BLIP_SPRITE(blip, 776)
			HUD.SET_BLIP_COLOUR(blip, 4)
			HUD.SET_BLIP_SCALE(blip, 0.800000)
			HUD.SET_BLIP_PRIORITY(blip, 7)
		end
	end
end)

commandmgr.add_looped_command("autoloot", "Auto-Grab", "Auto-Grabs the loot", function()
	if scripts.is_active("fm_mission_controller") then
		ScriptLocal("fm_mission_controller", 10713):set_int(4)
		ScriptLocal("fm_mission_controller", 10713 + 14):set_float(2)
		if ScriptLocal("fm_mission_controller", 10713):get_int() == 5 then
			commandmgr.get_command("autoloot"):set_value(false)
		end
	end

	if scripts.is_active("fm_mission_controller_2020") then
		ScriptLocal("fm_mission_controller_2020", 31275):set_int(4)
		ScriptLocal("fm_mission_controller_2020", 31275 + 14):set_float(2)
		script.yield(100)
		if ScriptLocal("fm_mission_controller_2020", 31275):get_int() == 5 then
			commandmgr.get_command("autoloot"):set_value(false)
		end
	end
end)

local function Fmmc2020Finish()
	if scripts.is_active("fm_mission_controller_2020") then
		ScriptLocal("fm_mission_controller_2020", 56504):set_int(9)
		ScriptLocal("fm_mission_controller_2020", 56504 + 1776):at(0, 1):set_float(50)
	end
end

local criminalmmbonus = false

---|| Recovery + (Other Missions) ||------------------------------------------------------------------------------

local AutoShop_Contract = {
	{ 0,	"The Union Depository",    "The Robbery" },
	{ 1,	"The Superdollar Deal",    "The Robbery" },
	{ 2,	"The Bank Contract", 	   "The Robberies" },
	{ 3,	"The E.C.U Job",		   "The Robbery" },
	{ 4,	"The Prison Contract", 	   "The Hit" },
	{ 5,	"The Agency Deal", 		   "The Raid" },
	{ 6,	"The LOST Contract", 	   "The Job" },
	{ 7,	"The Data Contract", 	   "The Robbery" },
	{ 8,	"None" }
}

commandmgr.add_list_command("autoshop_contracts", "Contracts", "", AutoShop_Contract, stats.get_int("MPX_TUNER_CURRENT"), function()
	stats.set_int("MPX_TUNER_CURRENT", commandmgr.get_command("autoshop_contracts"):get_value())
	local selected_autoshopcontract = AutoShop_Contract[stats.get_int("MPX_TUNER_CURRENT") + 1][2]
	if commandmgr.get_command("autoshop_contracts"):get_value() ~= 8 then
		notify.success("TinkerScript - Auto Shop Contract", "Contract Selected: "..selected_autoshopcontract, 3000)
	else
		stats.set_int("MPX_TUNER_CURRENT", -1)
	end
	STATS.STAT_SAVE(0, 0, 3, 0)
end)

local function AutoShop_Reload()
	if scripts.is_active("tuner_planning") then ScriptLocal("tuner_planning", 418):set_int(2) end
end

local CluckinBellRaid = {
	GetSetupStats = { ApproachPB = stats.get_packed_bool(42108) and 1 or 0, WeaponsPI = stats.get_packed_int(51019), GearPI = stats.get_packed_int(51021), GetawayVehiclePI = stats.get_packed_int(51023) }, -- Unnecessary, just testing tables
	Approach = {
		{ 0, "Sneaky Approach" },
		{ 1, "Aggressive Approach" }
	},
	Weapons = {
		{ 0, "Marabunta Grande" },
		{ 1, "The Professionals" },
		{ 2, "Unnamed Militia" }
	},
	Gear = {
		{ 0, "Marabunta Grande" },
		{ 1, "The Professionals" },
		{ 2, "Unnamed Militia" }
	},
	GetawayVehicle = {
		{ 0, "Declasse Tulip" },
		{ 1, "Declasse Moonbeam Custom" },
		{ 2, "Declasse Impaler LX" },
		{ 3, "Ocelot Jugular" },
		{ 4, "Dinka Sugoi" },
		{ 5, "Coil Raiden" },
		{ 6, "Mammoth Patriot Mil-Spec" },
		{ 7, "Canis Terminus" },
		{ 8, "Mammoth Squaddie" }
	}
}

local OzcarGuzmanFliesAgain = { -- I'm learning luaaaaaaaaaaaaaaaaaa
	Difficulty = { HardMode = false, DifficultyPB = 51272 },
	S_Mogul = { Setup = false, SetupPB = { 51265, 51266 } },
	S_IronMule = { Setup = false, SetupPB = { 51264, 51268, 51269, 51270, 51271 } },
	S_Ammunition = { Setup = false, SetupPB = { 51260, 51261, 51262, 51263 } }
}

commandmgr.add_list_command("cbr_approach", "Approach", "", CluckinBellRaid.Approach, CluckinBellRaid.GetSetupStats.ApproachPB, function()
	if commandmgr.get_command("cbr_approach"):get_value() == 1 then
		stats.set_packed_bool(42108, true)
	else
		stats.set_packed_bool(42108, false)
	end
end)

commandmgr.add_list_command("cbr_weapons", "Weapons", "", CluckinBellRaid.Weapons, CluckinBellRaid.GetSetupStats.WeaponsPI, function()
	stats.set_packed_int(51019, commandmgr.get_command("cbr_weapons"):get_value())
end)

commandmgr.add_list_command("cbr_gear", "Gear", "", CluckinBellRaid.Gear, CluckinBellRaid.GetSetupStats.GearPI, function()
	stats.set_packed_int(51021, commandmgr.get_command("cbr_gear"):get_value())
end)

commandmgr.add_list_command("cbr_getawayvehicle", "Getaway Vehicle", "", CluckinBellRaid.GetawayVehicle, CluckinBellRaid.GetSetupStats.GetawayVehiclePI, function()
	stats.set_packed_int(51023, commandmgr.get_command("cbr_getawayvehicle"):get_value())
end)

local FIB_File = {
	{ 0,  "The Black Box File" },
	{ 1,  "The Brute Force File" },
	{ 2,  "The Fine Art File" },
	{ 3,  "The Project Breakaway File" },
	{ 4,  "None" }
}

commandmgr.add_list_command("fib_files", "Files", "", FIB_File, stats.get_int("MPX_HACKER24_ACTIVE_ROB"), function()
	stats.set_int("MPX_HACKER24_ACTIVE_ROB", commandmgr.get_command("fib_files"):get_value())
	local selected_fibfile = FIB_File[stats.get_int("MPX_HACKER24_ACTIVE_ROB") + 1][2]
	if commandmgr.get_command("fib_files"):get_value() ~= 4 then
		notify.success("TinkerScript - FIB File", "File Selected: "..selected_fibfile, 3000)
	else
		stats.set_int("MPX_HACKER24_ACTIVE_ROB", -1)
	end
	STATS.STAT_SAVE(0, 0, 3, 0)
end)

local function HackerDen_Reload()
	scripts.start_new_script("apphackerden", 4592)
end

---|| Recovery + (Content Unlocks) ||------------------------------------------------------------------------------

local Rplus_Config = {
	AW_tier = false,
	AW_stats = false,
	LSCM_rep = false,
	FacePaint_Opacity = 1.0,
	EyesColor = 1,
	ComboToFile = false,
	FiletoChar = false
}

---|| Recovery + (Tunables) ||------------------------------------------------------------------------------

commandmgr.add_bool_command("Tunaggle_Independence", "Independence Day", "Enables Independence Day Content", false, function()
	for _, independenceday in ipairs (RplusTuna_IndependenceDay) do
		tunables.set_bool(independenceday.Tunable, independenceday.tunaVal)
	end
	notify.success("TinkerScript - Independence Day", "Independence Day Content enabled!", 3000)
end,function()
	for _, independenceday in ipairs (RplusTuna_IndependenceDay) do
		tunables.set_bool(independenceday.Tunable, not independenceday.tunaVal)
	end
	notify.info("TinkerScript - Independence Day", "Independence Day Content disabled.", 3000)
end)

commandmgr.add_bool_command("Tunaggle_Halloween", "Halloween", "Enables Halloween Content", false, function()
	for _, halloween in ipairs (RplusTuna_Halloween) do
		tunables.set_bool(halloween.Tunable, halloween.tunaVal)
	end
	notify.success("TinkerScript - Halloween", "Halloween Content enabled!", 3000)
end,function()
	for _, halloween in ipairs (RplusTuna_Halloween) do
		tunables.set_bool(halloween.Tunable, not halloween.tunaVal)
	end
	notify.info("TinkerScript - Halloween", "Halloween Content disabled.", 3000)
end)

local xmas_snow = false
commandmgr.add_bool_command("Tunaggle_Xmas", "Christmas", "Enables Christmas Content", false, function()
	for _, xmas in ipairs (RplusTuna_Christmas) do
		tunables.set_bool(xmas.Tunable, xmas.tunaVal)
	end
	notify.success("TinkerScript - Christmas", "Christmas Content enabled!", 3000)
end,function()
	for _, xmas in ipairs (RplusTuna_Christmas) do
		tunables.set_bool(xmas.Tunable, not xmas.tunaVal)
	end
	notify.info("TinkerScript - Christmas", "Christmas Content disabled.", 3000)
end)

---|| Recovery + (Money) ||------------------------------------------------------------------------------

local SindyBar = {
	Loop = false,
	Money = 100000,
	Delay = 3000,
	ManualBarMoney = false
}

---|| Recovery + (Human canvas) ||------------------------------------------------------------------------------

commandmgr.add_list_command("humcanv_fp1list", "##fp1list", "", HumanC_FP, stats.get_packed_int(451), function()
	stats.set_packed_int(451, commandmgr.get_command("humcanv_fp1list"):get_value())
end)

commandmgr.add_list_command("humcanv_fp2list", "##fp2list", "", HumanC_FP2, stats.get_packed_int(3942), function()
	stats.set_packed_int(3942, commandmgr.get_command("humcanv_fp2list"):get_value())
end)


TS_RecoveryPlus:imgui(function() if not network.is_session_started() then ImGui.TextDisabled("Please join a freemode session.") return end

	ImGui.BeginTabBar("recoplus") -- Learned tabs ;D
	if ImGui.BeginTabItem("Safe Cracker") then

		ImGui.BeginGroup()
		ImGui.BeginChild("##ineedanameforthis", 424, 584, 1)
		CenteredText("Heists", false, true)

		--ImGui.PushStyleVar(ImGuiStyleVar.TabBarBorderSize, 0) -- issues/4859 ocornut
		ImGui.BeginTabBar("Heists"--[[, ImGuiTabBarFlags.NoTabListScrollingButtons + ImGuiTabBarFlags.FittingPolicyScroll]])
		if ImGui.BeginTabItem("Cluckin' Bell Raid") then

			ImGui.Text("Cluckin' Raider")ImGui.Separator()ImGui.Spacing()
			ImGui.BeginDisabled(not STREAMING.IS_IPL_ACTIVE("cs1_02_cf_onmission4"))

			ImGui.BeginGroup()
			if ImGui.Button("Teleport to Signal", 200) then
				CBTpToPC()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Teleports you to the PC with the strongest signal") end

			if ImGui.Button("Teleport to Crate", 200) then
				CBTpToCrate()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Teleports you to the stashed drugs.\nTeleports you to the Office PC if there are no crates left to search.") end

			if scripts.is_active("fm_mission_controller_2020") and ScriptLocal("fm_mission_controller_2020", 21088):get_int() == 1149534208 then -- Previously just a TpToBlip but it only worked when near the crowbar (when blip appears)
				if not WEAPON.HAS_PED_GOT_WEAPON(PLAYER.PLAYER_PED_ID(), "WEAPON_CROWBAR", false) then
					if ImGui.Button("Get Crowbar", 200) then
						WEAPON.GIVE_WEAPON_TO_PED(PLAYER.PLAYER_PED_ID(), "WEAPON_CROWBAR", 1, false, true)
					end
				end
			end

			commandmgr.get_command("cbr_opendoors"):draw()
			ImGui.EndGroup()

			ImGui.SameLine() ImGui.BeginGroup()
			if ImGui.Button("Crack Cluckin' Bell Safe", 200) then
				script.run_in_callback(CrackCB)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Breaks into the safe") end

			if ImGui.Button("Teleport to Office Keys##cbr", 200) then
				TpToEntity(-1423372530)
			end

			if ImGui.Button("Instant Finish##cbr", 200) then
				Fmmc2020Finish()
			end
			ImGui.EndGroup()

			ImGui.EndDisabled()
			ImGui.EndTabItem()
		end

		if ImGui.BeginTabItem("Kortz Center Heist") then
			ImGui.Text("Kortz Center Cracker")ImGui.Separator()ImGui.Spacing()

			if ScriptGlobal(1980570 + 1090):get_int() == 3 then
				if ImGui.Button("Quick Start Heist", 200) then
					script.run_in_callback(TS_KortzStart)
				end
			end

			ImGui.BeginDisabled(not scripts.is_active("fm_mission_controller_v3"))

			ImGui.BeginGroup()
			if ImGui.Button("Skip Data Crack", 200) then
				TS_KortzDC()
			end

			if ImGui.Button("Skip Fingerprint Hacking", 200) then
				TS_KortzFP()
			end

			if ImGui.Button("Auto-Enter PC Access Code", 200) then
				script.run_in_callback(TS_KortzPCAC)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Enters the Access Code automatically") end

			if ImGui.Button("Disable Lasers", 200) then
				TS_KortzPwrL()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Disables Laser Grid") end

			if ImGui.Button("Skip Vault Door Hacking", 200) then
				TS_KortzSN()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Skips Signal Nodes Hacking") end

			if ImGui.Button("Teleport to Exit Keys", 200) then
				TpToBlip(true, Blips.CRIM_CUFF_KEYS, false)
			end
			ImGui.EndGroup()

			ImGui.SameLine() ImGui.BeginGroup()
			if ImGui.Button("Take Primary Target", 200) then
				script.run_in_callback(TS_KortzPaint)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Takes Primary Target instantly") end

			if ImGui.Button("Take Secondary Target", 200) then
				TS_KortzPaint2()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Takes Secondary Target instantly") end

			if ImGui.Button("Cut Glass", 200) then
				TS_KortzGlass()
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Cuts Display Cases Glass instantly") end

			if ImGui.Button("Disable All Cameras", 200) then
				if ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17456129 and not scripts.is_active("fmmc_lasers") then
					if not commandmgr.get_command("kortz_delcams"):get_value() then
						commandmgr.get_command("kortz_delcams"):set_value(true)
					else
						commandmgr.get_command("kortz_delcams"):set_value(false)
					end
				else
					ScriptLocal("fm_mission_controller_v3", 70176):at(0, 295):at(237 + 1):set_int(-2145222410)
				end
			end

			if ImGui.IsItemHovered() then
				if ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17456129 and not scripts.is_active("fmmc_lasers") then
					ImGui.SetTooltip("Exterior: Disables All Cameras for 12 seconds\nMISSION WILL BREAK IF YOU ABUSE THIS OPTION!")
				else
					ImGui.SetTooltip("Interior: Disables CCTV system.")
				end
			end

			if ImGui.Button("Teleport to Key Card##k26_card", 200) then
				TpToBlip(true, Blips.KEYCARD, false)
			end

			if ImGui.Button("Instant Finish##k26", 200) then
				if ScriptLocal("fm_mission_controller_v3", 57250 + 1):get_int() == 17718273 then
					TS_KortzFinish()
				else
					notify.error("TinkerScript - Kortz Center Cracker", "You must be inside the building to use Instant-Finish!", 3000)
				end
			end

			ImGui.EndGroup()

			if stats.get_masked_int("MPX_K26_GENERAL_BS", 27, 1) == 0 then
				if ImGui.Button("Teleport to Manhole Key", 200) then
					TpToBlip(false, Blips.MANHOLE_KEY, true)
				end
				ImGui.SameLine()
			end

			commandmgr.get_command("kortz_opendoors"):draw()

			if util.time() < kortzcamtimer + 12000 then
				ImGui.SameLine()
				ImGui.TextDisabled(string.format("Disabled Cameras: %.1f", (kortzcamtimer + 12001 - util.time()) / 1000))
			end

			if scripts.is_active("fmmc_lasers") then
				K26_Leasy = ImGui.Checkbox("Easy Lasers", K26_Leasy)
				ImGui.SameLine()
				K26_Lnodamage = ImGui.Checkbox("No Damage Lasers", K26_Lnodamage)
				if K26_Leasy then
					ScriptLocal("fmmc_lasers", 1058):set_int(1)
					ScriptLocal("fmmc_lasers", 1059):set_int(0)
				else
					ScriptLocal("fmmc_lasers", 1058):set_int(0)
					ScriptLocal("fmmc_lasers", 1059):set_int(1)
				end
				if K26_Lnodamage then
					ScriptLocal("fmmc_lasers", 1060):set_int(1)
				else
					ScriptLocal("fmmc_lasers", 1060):set_int(0)
				end if ImGui.IsItemHovered() then ImGui.SetTooltip("Walk through the lasers without receiving damage") end
			end

			if scripts.is_active("fm_mission_controller_v3") then
				ImGui.Text("Loot")ImGui.Separator()ImGui.Spacing()
				local k26_take

				ImGui.SetNextItemWidth(140)
				if ScriptLocal("fm_mission_controller_v3", 60737 + 1376 + 60):get_int() ~= nil then
					k26_take = ImGui.InputInt("Take", ScriptLocal("fm_mission_controller_v3", 60737 + 1376 + 60):get_int())
				end
				ScriptLocal("fm_mission_controller_v3", 60737 + 1376 + 60):set_int(k26_take)

				ImGui.SetNextItemWidth(120)
				local k26_bagcap = ImGui.InputInt("Bag Capacity", tunables.get_int(6971439))
				tunables.set_int(6971439, k26_bagcap)
			end

			ImGui.EndDisabled()
			ImGui.EndTabItem()
		end

		if ImGui.BeginTabItem("Cayo Perico Heist") then
			ImGui.Text("Cayo Perico")ImGui.Separator()ImGui.Spacing()
			ImGui.BeginDisabled((not STREAMING.IS_IPL_ACTIVE("h4_islandx_sea_mines") and not scripts.is_active("fm_mission_controller_2020")))

			if ImGui.Button("Solo Mantrap", 200) then
				script.run_in_callback(function()
					ScriptLocal("fm_mission_controller_2020", 69374):at(0, 293):at(236):set_int(7)
					script.yield(200)
					ScriptLocal("fm_mission_controller_2020", 21215):set_int(1)
				end)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Bypass Dual Keycard systems") end

			ImGui.SameLine() if ImGui.Button("Take Secondary Target##Cayo", 200) then
				ScriptLocal("fm_mission_controller_2020", 29373 + 11):set_int(3)
				PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 219, 1.0)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Takes Secondary Target instantly") end

			if ImGui.Button("Teleport to Key Card", 200) then
				TpToBlip(true, Blips.KEYCARD, false)
				script.run_in_callback(function()
					script.yield(500)
					PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), 5012.4, -5755.6, 28.9)
				end)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Kills all enemies, and teleports you to available Key Card") end

			ImGui.SameLine()
			if ImGui.Button("Teleport to Gate Keys", 200) then
				TpToBlip(true, Blips.CRIM_CUFF_KEYS, false)
			end

			if ImGui.Button("Delete Cameras", 200) then
				script.run_in_callback(ch_delcam) -- It took me a whole year to realize I can call functions this way
			end

			commandmgr.get_command("ch_opendoors"):draw()

			if scripts.is_active("fm_mission_controller_2020") then
				ImGui.Text("Loot")ImGui.Separator()ImGui.Spacing()
				local ch_take

				ImGui.SetNextItemWidth(140)

				if ScriptLocal("fm_mission_controller_2020", 59986 + 1376 + 60):get_int() ~= nil then
					ch_take = ImGui.InputInt("Take", ScriptLocal("fm_mission_controller_2020", 59986 + 1376 + 60):get_int())
				end
				ScriptLocal("fm_mission_controller_2020", 59986 + 1376 + 60):set_int(ch_take)

				ImGui.SetNextItemWidth(120)
				local ch_bagcap = ImGui.InputInt("Bag Capacity",  tunables.get_int(1859395035))
				tunables.set_int(1859395035, ch_bagcap)
			end

			ImGui.EndDisabled()
			ImGui.EndTabItem()
		end
		--ImGui.PopStyleVar()
	ImGui.EndTabBar()
	ImGui.EndChild()
	ImGui.EndGroup()

	ImGui.SameLine(0, 6.8)

	ImGui.BeginGroup()
	ImGui.BeginChild("##missionskips", 406, 584, 1) -- Almost perfectly aligned with last category (by chance)

	CenteredText("Extras", false, true) -- Previously "Other Missions", I really don't know what to names these things

	ImGui.Text("Mission Skips & Setups") if ImGui.IsItemHovered() then ImGui.SetTooltip("Only those that can't be replayed through the Pause Menu") end ImGui.Separator()ImGui.Spacing()

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("Dr. Dre Contract  ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##drecontract", 210, 104, 1) then
				if ImGui.Button("Skip: Don't F* With Dre", -1) then
					stats.set_int("MPX_FIXER_STORY_BS", 4095)
					notify.success("TinkerScript - Dr. Dre Contract Skip", "Success! All preps skipped.\nNext mission: Don't F* With Dre", 3000)
				end
				ImGui.Separator()
				if ImGui.Button("Instant Finish") then
					Fmmc2020Finish()
				end
				if ImGui.Button("Teleport to Agency") then
					TpToBlip(false, Blips.Property.AGENCY.ID, false)
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("Auto Shop Contract  ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##autoshopchild", 320, 134, 1) then
				local autoshop_contractfinale
				if stats.get_int("MPX_TUNER_CURRENT") > -1 then
					autoshop_contractfinale = AutoShop_Contract[stats.get_int("MPX_TUNER_CURRENT") + 1][3]
					if ImGui.Button("Skip: "..autoshop_contractfinale, -1) then
						stats.set_int("MPX_TUNER_GEN_BS", -1)
						notify.success("TinkerScript - Auto Shop Skip", "Success! All preps skipped.\nNext mission: "..autoshop_contractfinale, 3000)
					end
					ImGui.Separator()
				end
				commandmgr.get_command("autoshop_contracts"):draw()
				if ImGui.Button("Reload Board") then AutoShop_Reload() end
				if ImGui.Button("Teleport to Auto Shop") then
					TpToBlip(false, Blips.Property.AUTO_SHOP_PROPERTY.ID, false)
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("Cluckin' Bell Raid  ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##cbrchild", 390, 192, 1) then
				if ImGui.Button("Skip: Scene of the Crime", -1) then
					stats.set_int("MPX_SALV23_INST_PROG", 31)
					notify.success("TinkerScript - Cluckin' Bell Raid Skip", "Success! All preps skipped.\nNext mission: Scene of the Crime", 3000)
				end
				ImGui.Separator()
				commandmgr.get_command("cbr_approach"):draw()
				commandmgr.get_command("cbr_weapons"):draw()
				commandmgr.get_command("cbr_gear"):draw()
				commandmgr.get_command("cbr_getawayvehicle"):draw()
				if ImGui.Button("Teleport to L.S.P.D.") then
					TpToBlip(false, Blips.VINCENT, false)
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("LSA Operations ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##avopchild", 260, 42, 1) then
				if ImGui.Button("Instant Finish", -1) then
					if scripts.is_active("fm_content_smuggler_ops") then
						ScriptLocal("fm_content_smuggler_ops", 7881 + 1306):set_int(1)
						LocalSetBit(ScriptLocal("fm_content_smuggler_ops", 7743 + 1), 1, 11)
					end
				end
				-- Cooldowns can be skipped but finishing a mission will triger a transaction failed screen
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("FIB Files  ##fibsetups"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("#fibchild#", 320, 134, 1) then
				local fib_filefinale
				if stats.get_int("MPX_HACKER24_ACTIVE_ROB") > -1 then
					fib_filefinale = FIB_File[stats.get_int("MPX_HACKER24_ACTIVE_ROB") + 1][2]
					if ImGui.Button("Skip: "..fib_filefinale, -1) then
						stats.set_int("MPX_HACKER24_GEN_BS", -1)
						notify.success("TinkerScript - FIB File Skip", "Success! All preps skipped.\nNext mission: "..fib_filefinale, 3000)
					end
					ImGui.Separator()
				end
				commandmgr.get_command("fib_files"):draw()
				if ImGui.Button("Reload PC") then HackerDen_Reload() end
				if ImGui.Button("Teleport to Garment Factory") then
					TpToBlip(false, Blips.Property.GARMENT_FACTORY.ID, false)
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("Oscar Guzman Flies Again  ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##ogfachild", 320, 192, 1) then
				if ImGui.Button("Skip: The Titan Job", -1) then
					stats.set_int("MPX_HACKER24_INST_BS", -1)
					notify.success("TinkerScript - Oscar Guzman Skip", "Success! All preps skipped.\nNext mission: The Titan Job", 3000)
				end
				ImGui.Separator()
				OzcarGuzmanFliesAgain.Difficulty.HardMode = ImGui.Checkbox("Hard Mode", OzcarGuzmanFliesAgain.Difficulty.HardMode) -- I completed this part withour errors on first try :')
				OzcarGuzmanFliesAgain.S_Mogul.Setup = ImGui.Checkbox("Setup: Mogul", OzcarGuzmanFliesAgain.S_Mogul.Setup)
				OzcarGuzmanFliesAgain.S_IronMule.Setup = ImGui.Checkbox("Setup: Iron Mule", OzcarGuzmanFliesAgain.S_IronMule.Setup)
				OzcarGuzmanFliesAgain.S_Ammunition.Setup = ImGui.Checkbox("Setup: Ammunition", OzcarGuzmanFliesAgain.S_Ammunition.Setup)
				stats.set_packed_bool(OzcarGuzmanFliesAgain.Difficulty.DifficultyPB, OzcarGuzmanFliesAgain.Difficulty.HardMode)
				for _, pbstat in ipairs(OzcarGuzmanFliesAgain.S_Mogul.SetupPB) do stats.set_packed_bool(pbstat, OzcarGuzmanFliesAgain.S_Mogul.Setup) end
				for _, pbstat in ipairs(OzcarGuzmanFliesAgain.S_IronMule.SetupPB) do stats.set_packed_bool(pbstat, OzcarGuzmanFliesAgain.S_IronMule.Setup) end
				for _, pbstat in ipairs(OzcarGuzmanFliesAgain.S_Ammunition.SetupPB) do stats.set_packed_bool(pbstat, OzcarGuzmanFliesAgain.S_Ammunition.Setup) end
				if ImGui.Button("Teleport to McKenzie Field Hangar") then
					TpToBlip(false, Blips.Property.FIELD_HANGAR.ID, false)
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("KnoWay Out ##"..nomoretreeplease, 8219) then
			if ImGui.BeginChild("##knowayoutchild", 260, 104, 1) then
				if ImGui.Button("Skip: A Clean Break", -1) then
					stats.set_int("MPX_M25_AVI_MISSION_CURRENT", 4)
					notify.success("TinkerScript - KnoWay Out Skip", "Success! All preps skipped.\nNext mission: A Clean Break", 3000)
				end
				ImGui.Separator()
				if ImGui.Button("Teleport to Payphone") then
					TpToBlip(false, Blips.ARMENIAN_FAMILY, false)
				end
				if ImGui.Button("Instant Finish") then
					Fmmc2020Finish()
				end
			end ImGui.EndChild()
		end

		ImGui.Spacing()

		ImGui.Text("Misc")ImGui.Separator()ImGui.Spacing()

		if ImGui.Button("Enable Weekly Boost") then
			stats.set_int("MPX_WEEKLY_BOOST_BS", 0)
			notify.success("TinkerScript - Weekly Boost", "Weekly Boost has been reset! You'll get the maximun payout in heist finales.", 3000)
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Resetting the weekly boost will get you the max payout in heist finales.\nNo one has *reported getting banned for this (yet).") end

		if ImGui.Button("Criminal Mastermind Bonus") then -- unknowncheats.me/forum/grand-theft-auto-v/453340
			if not criminalmmbonus then
				stats.set_int("MPPLY_HEISTFLOWORDERPROGRESS", 268435455)
				stats.set_int("MPPLY_HEISTTEAMPROGRESSBITSET", 268435455)
				stats.set_int("MPPLY_HEISTNODEATHPROGREITSET", 268435455)
				stats.set_bool("MPPLY_AWD_HST_ORDER", false)
				stats.set_bool("MPPLY_AWD_HST_SAME_TEAM", false)
				stats.set_bool("MPPLY_AWD_HST_ULT_CHAL", false)
				criminalmmbonus = true
				notify.success("TinkerScript - Criminal Mastermind Challenge","$12M Bonus Enabled!", 3000)
			else
				stats.set_int("MPPLY_HEISTFLOWORDERPROGRESS", -1)
				stats.set_int("MPPLY_HEISTTEAMPROGRESSBITSET", -1)
				stats.set_int("MPPLY_HEISTNODEATHPROGREITSET", -1)
				stats.set_bool("MPPLY_AWD_HST_ORDER", true)
				stats.set_bool("MPPLY_AWD_HST_SAME_TEAM", true)
				stats.set_bool("MPPLY_AWD_HST_ULT_CHAL", true)
				criminalmmbonus = false
				notify.info("TinkerScript - Criminal Mastermind Challenge","$12M Bonus Disabled.", 3000)
			end
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Enables the $12M payout bonus for completing the Criminal Mastermind Challenge.") end

		if ImGui.Button("Casino Heist P.O.I Reset") then
			stats.set_int("MPX_H3OPT_POI", 0)
			stats.set_int("MPX_H3OPT_ACCESSPOINTS", 0)
			notify.success("TinkerScript - Casino Heist P.O.I Reset", "Diamond Casino Heist P.O.I and Access Points have been reset.", 3000)
		end

		if stats.get_int("MPX_CH_ARC_CAB_DISPLAY_SLOT36") ~= 18 or stats.get_int("MPX_CH_ARC_CAB_DISPLAY_SLOT37") ~= 19 then
			if ImGui.Button("Casino Heist Extras Reset") then
				stats.set_int("MPX_CAS_HEIST_FLOW", -1610744001)
				notify.success("TinkerScript - Casino Heist Extras Rese!", "Secure Keypad & Vault Door replicas have been Fixed.", 3000)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Resets Secure Keypad & Vault Door at the Arcade, making them available for purchase again.\nYou'll only need this if you can't use them. Once purchased, you'll never have this problem again.") end
		end

		if ImGui.Button("Crack Stash House Safe") then
			if scripts.is_active("fm_content_stash_house") then script.run_in_callback(CrackSH) end
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Breaks into the safe") end

		ImGui.EndChild()
		ImGui.EndGroup()

		ImGui.Text("Loot Auto-Grab")ImGui.Separator()ImGui.Spacing()
		commandmgr.get_command("autoloot"):draw()

		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Unlocks") then
		ImGui.Text("Content Unlocks")ImGui.Separator()ImGui.Spacing()

		if ImGui.Button("Bunker") then
			Rplus_Bunker()
		end

		if ImGui.Button("Arena War##unlock") then
			Rplus_ArenaWar()
		end

		ImGui.SameLine() Rplus_Config.AW_tier = ImGui.Checkbox("Tier 1000", Rplus_Config.AW_tier)
		ImGui.SameLine() Rplus_Config.AW_stats = ImGui.Checkbox("Write Stats", Rplus_Config.AW_stats)

		if ImGui.Button("Collectibles") then
			Rplus_Collectibles()
		end

		if ImGui.Button("Tattoos") then
			Rplus_Tattoos()
		end

		if ImGui.Button("Los Santos Customs") then
			Rplus_LSCustoms()
		end

		if ImGui.Button("Los Santos Car Meet") then
			Rplus_LSCM()
		end

		ImGui.SameLine() Rplus_Config.LSCM_rep = ImGui.Checkbox("Rep. Level 1000", Rplus_Config.LSCM_rep)

		--if ImGui.Button("Eye Colors") then -- Works but doesn't save
		--	PED.SET_HEAD_BLEND_EYE_COLOR(PLAYER.PLAYER_PED_ID(), Rplus_Config.EyesColor)
		--end
		--
		--ImGui.SameLine() Rplus_Config.EyesColor = ImGui.InputInt("Eyes Color", Rplus_Config.EyesColor)

		if ImGui.Button("Halloween Face Paints") then
			stats.set_packed_bool_range(4270, 4299, true)
		end

		if ImGui.Button("Mansion Trophies") then
			Rplus_MansionTrophies()
		end

		if ImGui.Button("All Clothing") then
			Rplus_Cloooathes()
		end

		ImGui.Spacing()ImGui.Spacing()
		ImGui.Text("Character Stats")ImGui.Separator()ImGui.Spacing()

		if ImGui.Button("Max Out All Skills") then
			stats.set_int("MPX_SCRIPT_INCREASE_STAM", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_STRN", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_DRIV", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_FLY", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_STL", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_LUNG", 100)
			stats.set_int("MPX_SCRIPT_INCREASE_SHO", 100)
			stats.set_int("MPX_CHAR_FM_HEALTH_1_UNLCK", -1)
			stats.set_int("MPX_CHAR_FM_HEALTH_2_UNLCK", -1)
		end

		if ImGui.Button("Fast Run") then
			Rplus_FastRun()
		end

		if ImGui.Button("Frozen Rank") then
			Rplus_FrozenRank()
		end

		ImGui.Spacing()ImGui.Spacing()
		ImGui.Text("Awards")ImGui.Separator()ImGui.Spacing()
		if ImGui.Button("Unlock All Awards") then ImGui.OpenPopup("##warnallawards") end if ImGui.IsItemHovered() then ImGui.SetTooltip("Unlocks All Awards.") end

		if ImGui.BeginPopupModal("##warnallawards", nil, 65) then
			ImGui.Text("Are you sure you want to unlock All Awards?")
			ImGui.Spacing()
			if ImGui.Button("Yes") then
				for _, allAwards in ipairs(Rplus_Awards) do
					allAwards.Unlock()
				end
				notify.success("TinkerScript - All Awards Only", "All Awards Unlocked!", 3000)
				ImGui.CloseCurrentPopup()
			end
			ImGui.SameLine()
			if ImGui.Button("No") then
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end

		ImGui.SameLine()
		ImGui.Spacing()
		ImGui.SameLine(0, 3.8)
		if ImGui.TreeNodeEx("Categories  ##"..nomoretreeplease, 8219) then
			for i, Awards in ipairs(Rplus_Awards) do
				if (i - 1) % 4 ~= 0 then ImGui.SameLine() end

				if ImGui.Button(Awards.Category) then
					Awards.Unlock()
					notify.success("TinkerScript - All Awards Only", string.format("All \"%s\" Awards Unlocked!", Awards.Category))
				end
			end
		end

		ImGui.Spacing()ImGui.Spacing()
		ImGui.Text("Career Progress")ImGui.Separator()ImGui.Spacing()
		if ImGui.Button("Complete All Challenges") then
			Rplus_CareerProgress()
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Completes All Challenges.") end

		ImGui.Spacing()ImGui.Spacing()
		ImGui.Text("Misc")ImGui.Separator()ImGui.Spacing()

		if ImGui.Button("LSCM Prize RIde Vehicle") then
			if not stats.get_bool("MPX_CARMEET_PV_CLMED") then
				stats.set_bool("MPX_CARMEET_PV_CHLLGE_CMPLT", true)
				notify.success("TinkerScript - LSCM Prize Ride Vehicle", "Success! Weekly Prize Ride ready to claim!")
			else
				notify.error("TinkerScript - LSCM Prize Ride Vehicle", "You've already claimed this week's Prize Ride!")
			end
		end

		if ImGui.Button("Skip Jenette Dialogues") then
			stats.set_packed_bool_range(51192, 51195, true)
			notify.success("TinkerScript - Jenette The Mutette", "Success! Jenette dialogues have been skipped!")
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Skips Jenette dialogues at the Bail Office when using the laptop.") end

		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Tunables") then
		ImGui.Text("Content Tunables")ImGui.Separator()ImGui.Spacing()

		commandmgr.get_command("Tunaggle_Independence"):draw()
		commandmgr.get_command("Tunaggle_Halloween"):draw()
		commandmgr.get_command("Tunaggle_Xmas"):draw()

		if commandmgr.get_command("Tunaggle_Xmas"):get_value() then
			ImGui.SameLine() xmas_snow = ImGui.Checkbox("Enable Snow", xmas_snow)

			if xmas_snow then
				tunables.set_bool(-1146554960, true)
				tunables.set_bool(-1195222077, false)
			else
				tunables.set_bool(-1146554960, false)
				tunables.set_bool(-1195222077, true)
			end
		end

		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Money") then
		ImGui.Text("Money")ImGui.Separator()ImGui.Spacing()

		if ImGui.Button("Good Behavior Bonus") then
			ScriptGlobal(2697091):set_int(2000)
			ScriptGlobal(2697090):set_int(1)
		end

		if ImGui.Button("Casino Membership Bonus") then
			ScriptGlobal(1973325):set_int(1)
		end

		if not SindyBar.Loop then
			if ImGui.Button("Sindy Looper") then
				if scripts.is_active("ob_jukebox") then
					SindyBar.Loop = true
					script.run_in_callback(function()
						while true do
							script.yield(SindyBar.Delay)
							if SindyBar.Loop then
								ScriptGlobal(PropGlob.mcbar):at(PLAYER.PLAYER_ID(), 884):set_int(SindyBar.Money)
								script.yield(200)
								LocalSetBit(ScriptLocal("am_mp_property_int", 230), 1, 18)
							else
								notify.info("TinkerScripts - Sindy Looper", "Loop Canceled.", 3000) return
							end
						end
					end)
				else
					notify.error("TinkerScripts - Sindy Looper", "You must be inside your Clubhouse to Collect Bar Earnings!", 3000)
				end
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Not to be confused with Cyndi Lauper.") end
		else
			if ImGui.Button("Cancel") then SindyBar.Loop = false end
		end

		ImGui.SameLine()

		SindyBar.ManualBarMoney = ImGui.Checkbox("Manual Options", SindyBar.ManualBarMoney)

		if SindyBar.ManualBarMoney then
			if ImGui.BeginChild("##sindylooperchild", 282, 132, 1) then
				ImGui.SetNextItemWidth(128) SindyBar.Money = ImGui.InputInt("Earnings", SindyBar.Money)
				ImGui.SameLine() if ImGui.Button("Set", 41) then ScriptGlobal(PropGlob.mcbar):at(PLAYER.PLAYER_ID(), 884):set_int(SindyBar.Money) end
				ImGui.SetNextItemWidth(108) SindyBar.Delay, MCBD_changed = ImGui.InputInt("Loop Delay", SindyBar.Delay)
				ImGui.Spacing()
				if SindyBar.Money > 100000 then SindyBar.Money = 100000 end
				if ImGui.Button("Teleport to Clubhouse") then
					TpToBlip(false, Blips.Property.BIKER_CLUBHOUSE.ID, false)
				end
				if ImGui.Button("Collect Bar Earnings") then
					if scripts.is_active("ob_jukebox") then
						LocalSetBit(ScriptLocal("am_mp_property_int", 230), 1, 18)
					else
						notify.error("TinkerScripts - Sindy Looper", "You must be inside your Clubhouse to Collect Bar Earnings!", 3000)
					end
				end
			end ImGui.EndChild()
		end
		ImGui.EndTabItem()
	end

	if ImGui.BeginTabItem("Human Canvas") then

		ImGui.Text("Tattoos") if ImGui.IsItemHovered() then ImGui.SetTooltip("Allows you to stack tattoos.\nFind a new session to see changes") end ImGui.Separator()

		ImGui.BeginGroup()
		if next(TattooZone) == nil then -- from stackoverflow... again...
			for _, TatZone in ipairs(HumanCanvas()) do
				TattooZone[TatZone.BPart] = { selectedTatName = "Select...", searchTat = "" }
			end
		end

		for _, TatZone in ipairs(HumanCanvas()) do -- from Weapons category
			local ZoneName = TatZone.BPart
			local Tattoo = TattooZone[ZoneName]
			local TatPopup = "##tattoo_popup"..ZoneName

			ImGui.BeginGroup()
			ImGui.Dummy(75, 0) -- I don't know if this is the right way to use ImGui.Dummy, but it works
			ImGui.AlignTextToFramePadding()
			ImGui.Text(ZoneName..":")
			ImGui.EndGroup()
			ImGui.SameLine()

			ImGui.BeginGroup()
			ImGui.Dummy(0, 0)
			ImGui.SetNextItemWidth(300)
			ImGui.BeginCombo("##tattoos"..ZoneName, Tattoo.selectedTatName)

			if ImGui.IsItemActive() and not ImGui.IsPopupOpen(TatPopup) then
				ImGui.OpenPopup(TatPopup)
				Tattoo.searchTat = ""
			end

			if ImGui.BeginPopup(TatPopup, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove) then
				ImGui.Text("Search:")
				ImGui.SameLine()
				ImGui.SetNextItemWidth(250)
				Tattoo.searchTat = ImGui.InputText("##searchtattoo"..ZoneName, Tattoo.searchTat)

				local searchLower = string.lower(Tattoo.searchTat)

				for i, tat in ipairs(TatZone.Tattoos) do
					local tattooLower = string.lower(tat.tatName.." ")

					if tattooLower:find(searchLower) then
						if ImGui.Selectable(tat.tatName) then
							Tattoo.selectedTatName = tat.tatName
							Tattoo.selectedTattoo = tat.tatStat
							Tattoo.selectedTatVal = tat.tatVal
						end
					end
				end
				ImGui.EndPopup()
			end

			ImGui.SameLine()
			ImGui.BeginDisabled(Tattoo.selectedTatName == "Select...")

			if ImGui.Button("Apply##"..ZoneName) then
				stats.set_masked_bool(Tattoo.selectedTattoo, Tattoo.selectedTatVal, true) -- I should probably use set_masked_int but this is more convenient
				notify.success("TinkerScript - Human Canvas", "Applied: "..Tattoo.selectedTatName)
			end

			ImGui.SameLine()

			if Tattoo.selectedTattoo ~= nil then
				if stats.get_masked_bool(Tattoo.selectedTattoo, Tattoo.selectedTatVal) ~= false then -- Could be useful after applying the wrong tattoo or something
					if ImGui.Button("Remove##"..ZoneName) then
						stats.set_masked_bool(Tattoo.selectedTattoo, Tattoo.selectedTatVal, false)
						notify.info("TinkerScript - Human Canvas", "Removed: " .. Tattoo.selectedTatName)
						Tattoo.selectedTatName = "Select..."
					end
				end
			end

			ImGui.EndDisabled()
			ImGui.EndGroup()
		end
		ImGui.EndGroup()

		--ImGui.SameLine()
		ImGui.BeginGroup()

		ImGui.Spacing()
		--ImGui.BeginChild("##hc_tattoooptionschild", 316, 104, 1) -- I'm not completely sure about the ui here
		if ImGui.Button("Import Tattoos", 154) then
			if not Rplus_Config.FiletoChar then
				for stat in ImGui.GetClipboardText():gmatch("[^\r\n]+") do -- from stackoverflow
					if stat:match("MPX_TATTOO_FM_CURRENT_(%d+) = (%-?%d+)") then
						local tatstat, tatvalue = stat:match("^(.-) = (.-)$")
						stats.set_int(tatstat, tonumber(tatvalue))
					else
						log.error(string.format("%s%sTinkerScript - Human Canvas: \27[0;31mWrong Tattoo format!\27[m Make sure you copied the stats correctly.", cls, lual))
						notify.error("TinkerScript - Human Canvas", "Wrong Tattoo format! Make sure you copied the stats correctly.", 3000) break
					end
					notify.success("TinkerScript - Human Canvas", "Success! Tattoo Combo applied correctly.\nPlease change sesions to see the changes", 3000)
					STATS.STAT_SAVE(0, 0, 3, 0)
				end
			else
				for stat in TS_PATH_FMCharTatCombo():gmatch("[^\r\n]+") do
					if stat:match("MPX_TATTOO_FM_CURRENT_(%d+) = (%-?%d+)") then
						local tatstat, tatvalue = stat:match("^(.-) = (.-)$")
						stats.set_int(tatstat, tonumber(tatvalue))
					else
						log.error(string.format("%s%sTinkerScript - Human Canvas: \27[0;31mWrong Tattoo File format!\n\27[mValid format: MPX_TATTOO_FM_CURRENT_X = Value", cls, lual))
						notify.error("TinkerScript - Human Canvas", "Wrong Tattoo File format! Valid format: MPX_TATTOO_FM_CURRENT_X = Value", 3000) break
					end
					notify.success("TinkerScript - Human Canvas", "Success! Tattoo Combo applied correctly.\nPlease change sesions to see the changes", 3000)
					STATS.STAT_SAVE(0, 0, 3, 0)
				end
			end
		end

		ImGui.SameLine() Rplus_Config.FiletoChar = ImGui.Checkbox("Load from file", Rplus_Config.FiletoChar) if ImGui.IsItemHovered() then ImGui.SetTooltip("Toggle this if you want to load tattoo stats from a file.") end

		if ImGui.Button("Export Tattoos", 154) then
			local ExpTatCombo = {}
			for i = 0, 53 do
				local tatCombo = stats.get_int("MPX_TATTOO_FM_CURRENT_"..i)
				table.insert(ExpTatCombo, string.format("MPX_TATTOO_FM_CURRENT_%d = %d", i, tatCombo))
			end
			if Rplus_Config.ComboToFile then
				FileMgr.WriteFileContent(TinkerPath.."/TinkerScripts/HumanCanvas/Exported_TattooCombo.txt", table.concat(ExpTatCombo, "\n"), false)
				notify.success("TinkerScript - Human Canvas", "Success! Tattoos Combo has been exported to: Exported_TattooCombo.txt", 3000)
			else
				ImGui.SetClipboardText(table.concat(ExpTatCombo, "\n"))
				notify.success("TinkerScript - Human Canvas", "Success! Tattoos Combo has been exported to Clipboard", 3000)
			end
		end if ImGui.IsItemHovered() then ImGui.SetTooltip("Exports your current Tattoo Combo to Clipboard") end

		ImGui.SameLine() Rplus_Config.ComboToFile = ImGui.Checkbox("Export to file", Rplus_Config.ComboToFile) if ImGui.IsItemHovered() then ImGui.SetTooltip("Toggle this if you want to write your current tattoo stats to a file.") end

		if Rplus_Config.ComboToFile then
		ImGui.SameLine()
		ImGui.SetNextItemWidth(360)
			if ImGui.Button("Copy Path") then
				ImGui.SetClipboardText("%AppData%/YimMenuV2/scripts/TinkerScripts/HumanCanvas/Exported_TattooCombo.txt")
				notify.success("TinkerScript - Human Canvas", "Path to Exported Tattoos has been copied to clipboard!", 3000)
			end if ImGui.IsItemHovered() then ImGui.SetTooltip("Copies Exported Tattoos \"File\" path to clipboard.") end
		end
		ImGui.EndGroup()
		--ImGui.EndChild()

		ImGui.Spacing()

		if ImGui.Button("Apply All", 89) then ImGui.OpenPopup("##warnfullbodytat") end if ImGui.IsItemHovered() then ImGui.SetTooltip("Applies All Tattoos.\nThey won't display all at once. Actual combos look better.") end

		if ImGui.BeginPopupModal("##warnfullbodytat", nil, 65) then
			ImGui.Text("Are you sure you want to apply all tattoos?")
			ImGui.Spacing()
			if ImGui.Button("Yes") then
				for i = 0, 53 do
					stats.set_int("MPX_TATTOO_FM_CURRENT_"..i, -1)
				end
				notify.success("TinkerScript - Human Canvas", "Success! All tattoos Applied.", 3000)
				ImGui.CloseCurrentPopup()
			end
			ImGui.SameLine() if ImGui.Button("No") then
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end

		ImGui.SameLine()

		if ImGui.Button("Remove all") then ImGui.OpenPopup("##warnremovetats") end if ImGui.IsItemHovered() then ImGui.SetTooltip("Lucky Diamond who?") end

		if ImGui.BeginPopupModal("##warnremovetats", nil, 65) then
			ImGui.Text("Are you sure you want to remove all your tattoos?")
			ImGui.Spacing()
			if ImGui.Button("Yes") then
				for i = 0, 53 do
					stats.set_int("MPX_TATTOO_FM_CURRENT_"..i, 0)
				end
				notify.success("TinkerScript - Human Canvas", "Success! All tattoos removed.", 3000)
				ImGui.CloseCurrentPopup()
			end
			ImGui.SameLine() if ImGui.Button("No") then
				ImGui.CloseCurrentPopup()
			end
			ImGui.EndPopup()
		end

		ImGui.Spacing()
		ImGui.Text("Face Paints") if ImGui.IsItemHovered() then ImGui.SetTooltip("Allows you to stack face paints.\nSelected face paint will be applied automatically.\nOpacity works only for the items on the first list.") end ImGui.Separator()ImGui.Spacing()
		commandmgr.get_command("humcanv_fp1list"):draw()
		commandmgr.get_command("humcanv_fp2list"):draw() if ImGui.IsItemHovered() then ImGui.SetTooltip("If any of these don't get applied, buy any of them first (Cheapest one is \"Vertical Stripe\").") end

		ImGui.SetNextItemWidth(100)
		Rplus_Config.FacePaint_Opacity, fpchange = ImGui.SliderFloat("Face Paint/Makeup Opacity", Rplus_Config.FacePaint_Opacity, 0.0, 1.0) if ImGui.IsItemHovered() then ImGui.SetTooltip([[Looks cool ¯\_(°-°)_/¯]]) end
		if fpchange then stats.set_float("MPX_HEADBLEND_OVERLAY_MAKEUP_PC", Rplus_Config.FacePaint_Opacity) end

		ImGui.Spacing()
		ImGui.Text("Hair")ImGui.Separator()ImGui.Spacing()

		ImGui.BeginGroup()
		if ImGui.TreeNodeEx("Hair Color  ##haircol"..nomoretreeplease, 8219) then
			ImGui.SameLine(0, 14)

			ImGui.Text("Current: "..stats.get_int(HC_HairColor.HighlightOnOff.Stat)) if ImGui.IsItemHovered() then ImGui.SetTooltip(string.format("This is you real hair color value.\nHovering over the colors below will display the value from Barber Shops.", i)) end

			ImGui.SameLine() HC_HairColor.HiddenColToggle = ImGui.Checkbox("Hidden Colors", HC_HairColor.HiddenColToggle)
			ImGui.SameLine() HC_HairColor.HighlightOnOff.Toggle = ImGui.Checkbox("Highlight", HC_HairColor.HighlightOnOff.Toggle)
			for i, HairB in ipairs(HC_HairColor.Regular) do
				if (i - 1) % 12 ~= 0 then ImGui.SameLine() end

				if ImGui.ColorButton("##haircol"..HairB.statVal, HairB.bCol, 64) then
					stats.set_int(HC_HairColor.HighlightOnOff.Stat, HairB.statVal)
					if not HC_HairColor.HiddenColToggle then
						notify.success("TinkerScript - Human Canvas", "Success! Hair Color Applied: "..i, 3000)
					else
						notify.success("TinkerScript - Human Canvas", "Success! Hair Color Applied: "..stats.get_int(HC_HairColor.HighlightOnOff.Stat), 3000)
					end
				end if ImGui.IsItemHovered() then if not HC_HairColor.HiddenColToggle then ImGui.SetTooltip(string.format("Color (%d of 48)", i)) else ImGui.SetTooltip(string.format("Color %d", HairB.statVal)) end end
			end
		end
		ImGui.EndGroup()

		ImGui.BeginGroup()
		if HC_HairColor.HiddenColToggle then
			--ImGui.NewLine()
			for i, HairB in ipairs(HC_HairColor.Hidden) do
				if (i - 1) % 12 ~= 0 then ImGui.SameLine() end

				if ImGui.ColorButton("##haircol"..HairB.statVal, HairB.bCol, 64) then
					stats.set_int(HC_HairColor.HighlightOnOff.Stat, HairB.statVal)
					notify.success("TinkerScript - Human Canvas", "Success! Hidden Hair Color Applied: "..stats.get_int(HC_HairColor.HighlightOnOff.Stat), 3000)
				end if ImGui.IsItemHovered() then ImGui.SetTooltip(string.format("Color %d", HairB.statVal)) end
			end
		end

		if HC_HairColor.HighlightOnOff.Toggle then
			HC_HairColor.HighlightOnOff.Stat = "MPX_SEC_HAIR_TINT"
		else
			HC_HairColor.HighlightOnOff.Stat = "MPX_HAIR_TINT"
		end

		ImGui.EndGroup()

		ImGui.EndTabItem()
	end
	ImGui.EndTabBar()
end)

local Stngsplus_Config = {
	CloseBCSonUnload = TS_Settings.CloseBCSonUnload or true,
	LoadSettings = TS_Settings.LoadSettings or false
}

local function CloseBCSonUnload()
	if Stngsplus_Config.CloseBCSonUnload then
		FileMgr.WriteFileContent(TinkerPath.."/TinkerScripts/Settings/BlockCloudSaves/NoSave.txt", "Close", false)
	end
	return Stngsplus_Config.CloseBCSonUnload
end

local function SaveSettings(tabl) -- Also from stackoverflow (darkfrei) but just what I need. Could've done more progress on the script but decided to mess around with this thing (I wish i didn't). I don't even know if this is a serializer anymore
    local set = {}
	local order = { -- It seems that this is the only way to "preserve" the order
		"HGWHrestock",
		"HGWHmaxgoods",
		"HGsetgood",
		"HGgoodtype",
		"WHsetgood",
		"WHgoodtype",
		"MCresup",
		"MCrestock",
		"NCgoods",
		"NoClipState",
		"NoClipWindowTop",
		"LoadSettings",
		"CloseBCSonUnload"
	}
    for _, key in ipairs(order) do
        table.insert(set, key.." = "..tostring(tabl[key]))
    end
    return "TS_Settings = {}\n".."TS_Settings."..table.concat(set, "\nTS_Settings.") -- previously a regular table
end

local function LoadSavedSettings() -- My brain started melting since last function, i feel like somethings wrong but i dont know what
	load(TS_PATH_Settings())()
	Stngsplus_Config.LoadSettings = TS_Settings.LoadSettings
	Stngsplus_Config.CloseBCSonUnload = TS_Settings.CloseBCSonUnload
	NoClipWindowTop = TS_Settings.NoClipWindowTop
	commandmgr.get_command("noclip_onscreen"):set_value(TS_Settings.NoClipState)
	commandmgr.get_command("HGWH_restock"):set_value(TS_Settings.HGWHrestock)
	commandmgr.get_command("HGWH_maxgoods"):set_value(TS_Settings.HGWHmaxgoods)
	commandmgr.get_command("HG_setgood"):set_value(TS_Settings.HGsetgood)
	commandmgr.get_command("WH_setgood"):set_value(TS_Settings.WHsetgood)
	commandmgr.get_command("MC_resup"):set_value(TS_Settings.MCresup)
	commandmgr.get_command("MC_restock"):set_value(TS_Settings.MCrestock)
	commandmgr.get_command("NC_goods"):set_value(TS_Settings.NCgoods)
	commandmgr.get_command("HG_goodtype"):set_value(TS_Settings.HGgoodtype)
	commandmgr.get_command("WH_goodtype"):set_value(TS_Settings.WHgoodtype)
end

TS_SettingsPlus:imgui(function()

	if ImGui.BeginChild("##setttingschild", 271, 132, 1) then

		CenteredText("Submenu Settings", false, true) ImGui.Spacing()

		if ImGui.Button("Save Current Settings") then
			FileMgr.WriteFileContent(TinkerPath.."/TinkerScripts/Settings/TS_Settings.lua", SaveSettings({
				HGWHrestock = commandmgr.get_command("HGWH_restock"):get_value(),
				HGWHmaxgoods = commandmgr.get_command("HGWH_maxgoods"):get_value(),
				HGsetgood = commandmgr.get_command("HG_setgood"):get_value(),
				WHsetgood = commandmgr.get_command("WH_setgood"):get_value(),
				MCresup = commandmgr.get_command("MC_resup"):get_value(),
				MCrestock = commandmgr.get_command("MC_restock"):get_value(),
				NCgoods = commandmgr.get_command("NC_goods"):get_value(),
				HGgoodtype = commandmgr.get_command("HG_goodtype"):get_value(),
				WHgoodtype = commandmgr.get_command("WH_goodtype"):get_value(),
				NoClipState = commandmgr.get_command("noclip_onscreen"):get_value(),
				NoClipWindowTop = NoClipWindowTop,
				LoadSettings = Stngsplus_Config.LoadSettings,
				CloseBCSonUnload = Stngsplus_Config.CloseBCSonUnload
			}))
		end

		if ImGui.Button("Load Saved Settings") then
			LoadSavedSettings()
		end

		Stngsplus_Config.LoadSettings = ImGui.Checkbox("Load Saved Settings on Startup", Stngsplus_Config.LoadSettings)

	end ImGui.EndChild()

	if ImGui.BeginChild("##cloudsaveschild", 296, 196, 1) then

		CenteredText("Block Cloud Saves", false, true) ImGui.Spacing()

		ImGui.Text("Cloud Save State: ")

		if TS_PATH_NoCloudSave() == "" then
			ImGui.SameLine(0, 0) ImGui.TextColored(0, 1, 1, 1, "Ready")
		elseif TS_PATH_NoCloudSave() == "Disabled" then
			ImGui.SameLine(0, 0) ImGui.TextColored(1, 0, 0, 1, "OFF")
		elseif TS_PATH_NoCloudSave() == "Enabled" then
			ImGui.SameLine(0, 0) ImGui.TextColored(0, 1, 0, 1, "ON")
		elseif TS_PATH_NoCloudSave() == "Closed" or TS_PATH_NoCloudSave() == "Close" or TS_PATH_NoCloudSave() == "Disable" or TS_PATH_NoCloudSave() == "Enable" then
			ImGui.SameLine(0, 0) ImGui.TextDisabled("WAITING")
		end

		ImGui.SameLine()
		if TS_PATH_NoCloudSave() ~= "" then ImGui.TextDisabled("(?)") end if ImGui.IsItemHovered() then ImGui.SetTooltip("ON: Cloud Saves ENABLED\nOFF: Cloud Saves DISABLED\n\nWAITING: BlockCloudSaves.bat is not running") end
		ImGui.Spacing()

		if ImGui.Button("Disable Cloud Saves") then
			FileMgr.WriteFileContent(TinkerPath.."/TinkerScripts/Settings/BlockCloudSaves/NoSave.txt", "Disable", false)
		end

		if ImGui.Button("Enable Cloud Saves") then
			FileMgr.WriteFileContent(TinkerPath.."/TinkerScripts/Settings/BlockCloudSaves/NoSave.txt", "Enable", false)
		end

		ImGui.Spacing()ImGui.Spacing()
		if ImGui.Button("Copy Path##blocksaves") then
			ImGui.SetClipboardText("%AppData%/YimMenuV2/scripts/TinkerScripts/Settings/BlockCloudSaves/BlockCloudSaves.bat")
			notify.success("TinkerScript - Block Cloud Saves", "Path to BlockCloudSaves.bat has been copied to clipboard!", 3000)
		end

		Stngsplus_Config.CloseBCSonUnload = ImGui.Checkbox("Close Tool on Menu Unload", Stngsplus_Config.CloseBCSonUnload) if ImGui.IsItemHovered() then ImGui.SetTooltip("Should BlockCloudSaves.bat close itself on menu unload? (Enabled by default)\nThis will remove the firewall rule added by the tool, so you don't have problems joining Online in your next game session.") end

	end ImGui.EndChild()

end)

if Stngsplus_Config.LoadSettings then LoadSavedSettings() end

event.register_handler(menu_event.Unload, function()
	CloseBCSonUnload()
end)