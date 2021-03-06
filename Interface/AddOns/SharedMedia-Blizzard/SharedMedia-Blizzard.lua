local LSM = LibStub("LibSharedMedia-3.0")
local path = "Interface\\AddOns\\SharedMedia-Blizzard\\Backgrounds\\"

--[[----------------------------------------------------------------------------------------------
	If there are any textures here that you do not wish to use, you may
	simply comment out their respective lines by putting two dashes (--)
	in front (just like these lines, or where it says border, etc).
	This way, your menu in-game won't be so long to go through.
----------------------------------------------------------------------------------------------]]--


--statusbar
	LSM:Register("statusbar",	"Blizzard2",	"Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill.blp")
	LSM:Register("statusbar",	"Blizzard3",	"Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill.blp")
	LSM:Register("statusbar",	"Greyscale",	"Interface\\BUTTONS\\GreyscaleRamp64.blp")

--border:
	LSM:Register("border",	"TextPanel Border",	"Interface\\GLUES\\COMMON\\TextPanel-Border.blp")
	LSM:Register("border",	"LFG Border", 		"Interface\\LFGFrame\\LFGBorder.blp")
	LSM:Register("border",	"Toast Border",		"Interface\\FriendsFrame\\UI-Toast-Border.blp")

--background:
	--taken out of unit frame textures
	LSM:Register("background", 	"Elite", 				path.."Elite.tga")
	LSM:Register("background", 	"Rare", 				path.."Rare.tga")
	--reversed versions
	LSM:Register("background", 	"Elite Left", 			path.."EliteLeft.tga")
	LSM:Register("background", 	"Rare Left", 			path.."RareLeft.tga")
	LSM:Register("background", 	"Gryphon Right", 		path.."UI-MainMenuBar-EndCap-Dwarf-right.blp")
	LSM:Register("background", 	"Lion Right", 			path.."UI-MainMenuBar-EndCap-Human-right.blp")
	--these all needed pieced together and included manually now
	LSM:Register("background", 	"SpellBar", 			path.."PlayerActionBarAlt.tga")
	LSM:Register("background", 	"SpellBar- Alliance", 	path.."Spellbar- Alliance.blp")
	LSM:Register("background", 	"SpellBar- Amber", 		path.."Spellbar- Amber.blp")
	LSM:Register("background", 	"SpellBar- Bamboo", 	path.."Spellbar- Bamboo.blp")
	LSM:Register("background", 	"SpellBar- Darkmoon", 	path.."Spellbar- Darkmoon.blp")
	LSM:Register("background", 	"SpellBar- Fancy",	 	path.."Spellbar- Fancy.blp")
	LSM:Register("background", 	"SpellBar- Horde", 		path.."Spellbar- Horde.blp")
	LSM:Register("background", 	"SpellBar- Mechanical", 	path.."Spellbar- Mechanical.blp")
	LSM:Register("background", 	"SpellBar- Mechanical2", 	path.."Spellbar- Mechanical2.blp")
	LSM:Register("background", 	"SpellBar- Natural", 	path.."Spellbar- Natural.blp")
	LSM:Register("background", 	"SpellBar- Pandaren Wood", 	path.."Spellbar- Pandaren Wood.blp")
	LSM:Register("background", 	"SpellBar- Stone",	 	path.."Spellbar- Stone.blp")
	LSM:Register("background", 	"SpellBar- Tree",	 	path.."Spellbar- Tree.blp")
	LSM:Register("background", 	"SpellBar- Wood",	 	path.."Spellbar- Wood.blp")
	LSM:Register("background", 	"SpellBar- WoW",	 	path.."Spellbar- WoW.blp")

	LSM:Register("background",	"Achievement Bling",	"Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Bling.blp")
	--LSM:Register("background",	"Blizzard Parchment Gray",	"Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Parchment-Horizontal-Desaturated.blp")
	--LSM:Register("background",	"Blizzard Parchment 2 Gray",	"Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.blp")
	--LSM:Register("background",	"Blizzard Parchment Dragon",	"Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground.blp")
	LSM:Register("background", 	"Dark Parchment", 		"Interface\\Garrison\\GarrisonLandingPageMiddleTile.blp")	--new!
	LSM:Register("background", 	"Blue Gradient", 		"Interface\\BUTTONS\\BLUEGRAD64.blp")
	LSM:Register("background", 	"Green Gradient", 		"Interface\\BUTTONS\\GREENGRAD64.blp")
	LSM:Register("background", 	"Grey Gradient", 		"Interface\\BUTTONS\\GreyscaleRamp64.blp")
	LSM:Register("background", 	"Orange Gradient", 		"Interface\\BUTTONS\\LegendaryOrange64.blp")
	LSM:Register("background", 	"Red Gradient", 		"Interface\\BUTTONS\\RedGrad64.blp")
	LSM:Register("background", 	"Yellow-Orange", 		"Interface\\BUTTONS\\YELLOWORANGE64.blp")
	LSM:Register("background",	"DK player frame", 		"Interface\\CHARACTERFRAME\\UI-DeathKnightFrame.blp")
	LSM:Register("background",	"Destiny Parchment", 	"Interface\\Destiny\\EndscreenBG.blp")
	LSM:Register("background",	"Alert",				"Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew.blp")
	LSM:Register("background",	"Alert Cog",			"Interface\\DialogFrame\\UI-Dialog-Icon-AlertOther.blp")
	LSM:Register("background", 	"DressUp-BloodElf", 	"Interface\\DressUpFrame\\DressUpBackground-BloodElf1.blp")
	LSM:Register("background", 	"DressUp-Draenei", 		"Interface\\DressUpFrame\\DressUpBackground-Draenei1.blp")
	LSM:Register("background", 	"DressUp-Dwarf", 		"Interface\\DressUpFrame\\DressUpBackground-Dwarf1.blp")
	LSM:Register("background", 	"DressUp-Gnome", 		"Interface\\DressUpFrame\\DressUpBackground-Gnome1.blp")
	LSM:Register("background", 	"DressUp-Goblin", 		"Interface\\DressUpFrame\\DressUpBackground-Goblin1.blp")
	LSM:Register("background", 	"DressUp-Human", 		"Interface\\DressUpFrame\\DressUpBackground-Human1.blp")
	LSM:Register("background", 	"DressUp-NightElf", 	"Interface\\DressUpFrame\\DressUpBackground-NightElf1.blp")
	LSM:Register("background", 	"DressUp-Orc", 			"Interface\\DressUpFrame\\DressUpBackground-Orc1.blp")
	LSM:Register("background", 	"DressUp-Pandaren", 	"Interface\\DressUpFrame\\DressUpBackground-Pandaren1.blp")
	LSM:Register("background", 	"DressUp-Scourge", 		"Interface\\DressUpFrame\\DressUpBackground-Scourge1.blp")
	LSM:Register("background", 	"DressUp-Tauren", 		"Interface\\DressUpFrame\\DressUpBackground-Tauren1.blp")
	LSM:Register("background", 	"DressUp-Troll", 		"Interface\\DressUpFrame\\DressUpBackground-Troll1.blp")
	LSM:Register("background", 	"DressUp-Worgen", 		"Interface\\DressUpFrame\\DressUpBackground-Worgen1.blp")
	LSM:Register("background", 	"WoW BG - BC",			"Interface\\EncounterJournal\\UI-EJ-BurningCrusade.blp")
	LSM:Register("background", 	"WoW BG - Cataclysm",	"Interface\\EncounterJournal\\UI-EJ-CATACLYSM.blp")
	LSM:Register("background", 	"WoW BG - Classic",		"Interface\\EncounterJournal\\UI-EJ-Classic.blp")
	LSM:Register("background", 	"WoW BG - MoP",			"Interface\\EncounterJournal\\UI-EJ-MistsofPandaria.blp")
	LSM:Register("background", 	"WoW BG - WotLK",		"Interface\\EncounterJournal\\UI-EJ-WrathoftheLichKing.blp")
	LSM:Register("background", 	"WoW BG - Warlords",	"Interface\\EncounterJournal\\UI-EJ-WarlordsofDraenor.blp")	--new!
	--
	LSM:Register("background",	"Blue Gradient 2",		"Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue.blp")
	LSM:Register("background", 	"Stormwind", 			"Interface\\GLUES\\MODELS\\UI_Alliance\\Background_01.blp")
	LSM:Register("background", 	"Stone Wall 2", 		"Interface\\GLUES\\MODELS\\UI_Alliance\\UI_wall_ionic.blp")
	LSM:Register("background", 	"Stormwind 2", 		"Interface\\GLUES\\MODELS\\UI_Alliance_LowRes\\UI_Alliance_lowres_02.blp")
	LSM:Register("background", 	"BElf Login fence", 	"Interface\\GLUES\\MODELS\\UI_BLOODELF\\RG_FENCE_FANCY.blp")
	LSM:Register("background", 	"BElf Login trim", 		"Interface\\GLUES\\MODELS\\UI_BLOODELF\\RG_JLO_BLOODELF_DOORTRIM_01.blp")
	LSM:Register("background", 	"BElf Login branch", 	"Interface\\GLUES\\MODELS\\UI_BLOODELF\\SILVERMOONBRANCH04.blp")
	LSM:Register("background", 	"Draenei Login window",	"Interface\\GLUES\\MODELS\\UI_Draenei\\rg_jlo_Draenei_window_03.blp")
	LSM:Register("background", 	"Dwarf Login snow", 	"Interface\\GLUES\\MODELS\\UI_Dwarf\\snow.blp")
	LSM:Register("background", 	"Goblin Login clouds", 	"Interface\\GLUES\\MODELS\\UI_Goblin\\UI_Goblin_clouds01.blp")
	LSM:Register("background", 	"Goblin Login sky", 	"Interface\\GLUES\\MODELS\\UI_Goblin\\UI_Goblin_sky.blp")
	LSM:Register("background", 	"Orgrimmar", 			"Interface\\GLUES\\MODELS\\UI_Horde_LowRes\\UI_Horde_lowres_02.blp")
	LSM:Register("background", 	"Human Login caustic", 	"Interface\\GLUES\\MODELS\\UI_Human\\caustic02.blp")
	--LSM:Register("background", 	"Human Login sky", 		"Interface\\GLUES\\MODELS\\UI_Human\\MM_SKY_02.blp")
	LSM:Register("background", 	"Human Login sky", 		"Interface\\GLUES\\MODELS\\UI_Human\\Large_Human_Background_Sky_01.blp")
	--LSM:Register("background", 	"Human Login sidewalk",	"Interface\\GLUES\\MODELS\\UI_Human\\SIDEWALK.blp")
	LSM:Register("background", 	"Human Login street", 	"Interface\\GLUES\\MODELS\\UI_Human\\STREET 02.blp")
	LSM:Register("background", 	"Aerie Peak", 			"Interface\\GLUES\\MODELS\\UI_MAINMENU\\AERIEPEAK01.blp")
	LSM:Register("background", 	"Durotar Rock", 		"Interface\\GLUES\\MODELS\\UI_MAINMENU\\DurotarRock03.blp")
	LSM:Register("background", 	"Black Gradient", 		"Interface\\GLUES\\MODELS\\UI_MAINMENU\\GRADIENT.blp")
	LSM:Register("background", 	"BlueBlack Gradient", 	"Interface\\GLUES\\MODELS\\UI_MAINMENU\\SWORDGRADIENT.blp")
	LSM:Register("background", 	"OrangeBlack Gradient",	"Interface\\GLUES\\MODELS\\UI_MAINMENU\\SWORDGRADIENT2.blp")
	LSM:Register("background", 	"Dark Portal nebula", 	"Interface\\GLUES\\MODELS\\UI_MainMenu_BurningCrusade\\dp_nebula.blp")
	LSM:Register("background", 	"Lava Brick Wall",	 	"Interface\\GLUES\\MODELS\\UI_MAINMENU_CATACLYSM\\UI_strmwnd_lavawall01_nite.blp")
	LSM:Register("background", 	"Wooden Wall",	 		"Interface\\GLUES\\MODELS\\UI_MAINMENU_CATACLYSM\\UI_strmwnd_stone_trim_03.blp")
	LSM:Register("background", 	"Stone Wall",	 		"Interface\\GLUES\\MODELS\\UI_MAINMENU_CATACLYSM\\UI_strmwnd_stonewall03_nite.blp")
	LSM:Register("background", 	"Deathwing",	 		"Interface\\GLUES\\MODELS\\UI_MainMenu_LowBandwidth\\UI_Mainmenu_Cataclysm_Low.blp")
	LSM:Register("background", 	"Pandaria Statues",		"Interface\\GLUES\\MODELS\\UI_MainMenu_LowBandwidth\\UI_MainMenu_Pandaria_Low_01.blp")
	LSM:Register("background", 	"Pandaria Sky",	 		"Interface\\GLUES\\MODELS\\UI_MainMenu_Pandaria\\WideShot_Clouds_08.blp")
	LSM:Register("background", 	"Warlords Portal", 		"Interface\\GLUES\\MODELS\\UI_MainMenu_Warlords\\UI_Main_Warlords_Low_01.blp")	--new!
	LSM:Register("background", 	"NElf Login moonwell",	"Interface\\GLUES\\MODELS\\UI_NightElf\\AA_MOONWELL_GLOW.blp")
	LSM:Register("background", 	"NElf Login sky", 		"Interface\\GLUES\\MODELS\\UI_NightElf\\AA_NE_SKY.blp")
	LSM:Register("background", 	"Orc Login wall", 		"Interface\\GLUES\\MODELS\\UI_Orc\\JLO_MCAVE_WALL_RED.blp")
	LSM:Register("background", 	"Orc Login sky", 		"Interface\\GLUES\\MODELS\\UI_Orc\\MM_ORC_SKY_01.blp")
	LSM:Register("background", 	"Pandaren Login sky", 	"Interface\\GLUES\\MODELS\\UI_PandarenCharacterSelect\\PandaCharSel_Sky_01.blp")
	LSM:Register("background", 	"Pandaria", 			"Interface\\GLUES\\MODELS\\UI_PandarenCharacterSelect_LowRes\\UI_PandarenCharacterSelect_lowres_04.blp")
	LSM:Register("background",	"Water",				"Interface\\GLUES\\MODELS\\UI_Troll\\UI_TROLL_WATER01.blp")
	LSM:Register("background", 	"Worgen", 				"Interface\\GLUES\\MODELS\\UI_Worgen\\UI_Worgen_Silhouette01.blp")
	LSM:Register("background",	"Dark Sandstone",		"Interface\\HELPFRAME\\DarkSandstone-Tile.blp")
	LSM:Register("background",	"Blizzard Parchment 3",	"Interface\\HELPFRAME\\Tileable-Parchment.blp")
	LSM:Register("background",	"Illidan",				"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BLACKTEMPLE.blp")
	LSM:Register("background",	"Brewfest",				"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-BREW.blp")
	LSM:Register("background",	"Deadmines",			"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-DEADMINES.blp")
	LSM:Register("background",	"Hyjal",				"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-HYJALPAST.blp")
	LSM:Register("background",	"Molten Core",			"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-MOLTENCORE.blp")
	LSM:Register("background",	"Crossed Swords",		"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-RandomScenario.blp")
	LSM:Register("background",	"Wandering Isle",		"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-WanderingIsle.blp")
	LSM:Register("background",	"Draenor",				"Interface\\LFGFRAME\\UI-LFG-BACKGROUND-Draenor.blp")	--new!
	LSM:Register("background", 	"Gryphon Left", 		"Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Dwarf.blp")
	LSM:Register("background", 	"Lion Left", 			"Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human.blp")
	LSM:Register("background", 	"BuyBack frame", 		"Interface\\MERCHANTFRAME\\UI-BuyBack-TopLeft.blp")
	LSM:Register("background", 	"PvP Banner 2", 		"Interface\\PVPFrame\\PVP-Banner-2.blp")
	LSM:Register("background", 	"PvP Banner 3", 		"Interface\\PVPFrame\\PVP-Banner-3.blp")
	LSM:Register("background",	"PvP Banner 5", 		"Interface\\PVPFrame\\PVP-Banner-5.blp")
	LSM:Register("background", 	"Dwarf v. Orc", 		"Interface\\PVPFrame\\PvpBg-AlteracValley-ToastBG.blp")
	LSM:Register("background", 	"Arathi Basin", 		"Interface\\PVPFrame\\PvpBg-ArathiBasin-ToastBG.blp")
	LSM:Register("background",	"Scroll Divider",		"Interface\\QUESTFRAME\\UI-HorizontalBreak.blp")
	LSM:Register("background", 	"AoE Spell Aura", 		"Interface\\SpellShadow\\Spell-Shadow-Acceptable.blp")
	LSM:Register("background", 	"Unholy DK TalentBG", 	"Interface\\TalentFrame\\DeathKnightUnholy-TopLeft.blp")
	LSM:Register("background", 	"BeastMast. TalentBG", 	"Interface\\TalentFrame\\HunterBeastMastery-TopLeft.blp")
	LSM:Register("background", 	"HolyP TalentBG", 		"Interface\\TalentFrame\\PriestHoly-TopLeft.blp")
	LSM:Register("background", 	"RestoSh TalentBG", 	"Interface\\TalentFrame\\ShamanRestoration-TopLeft.blp")
	LSM:Register("background", 	"Map - Eastern Kingdoms", 	"Interface\\TaxiFrame\\TAXIMAP0.blp")
	LSM:Register("background", 	"Map - Kalimdor", 			"Interface\\TaxiFrame\\TAXIMAP1.blp")
	LSM:Register("background", 	"Map - Outlands", 			"Interface\\TaxiFrame\\TAXIMAP530.blp")
	LSM:Register("background", 	"Map - Northrend", 			"Interface\\TaxiFrame\\TAXIMAP571.blp")
	LSM:Register("background", 	"Map - Pandaria", 			"Interface\\TaxiFrame\\TAXIMAP870.blp")
	LSM:Register("background", 	"Map - Draenor", 			"Interface\\TaxiFrame\\TAXIMAP1116.blp")	--new!
	LSM:Register("background", 	"Alliance Insignia", 	"Interface\\Timer\\Alliance-Logo.blp")
	LSM:Register("background", 	"Horde Insignia", 		"Interface\\Timer\\Horde-Logo.blp")
	LSM:Register("background", 	"Pandaren Insignia", 	"Interface\\Timer\\Panda-Logo.blp")
	LSM:Register("background", 	"Air Circle Frame", 	"Interface\\UnitPowerBarAlt\\Air_Circular_Frame.blp")
	LSM:Register("background", 	"Air Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Air_Horizontal_Frame.blp")
	LSM:Register("background", 	"Air Vert. Frame", 		"Interface\\UnitPowerBarAlt\\Air_Vertical_Frame.blp")
	LSM:Register("background", 	"Alliance Circle Frame", "Interface\\UnitPowerBarAlt\\Alliance_Circular_Frame.blp")
	LSM:Register("background", 	"Alliance Horiz. Frame", "Interface\\UnitPowerBarAlt\\Alliance_Horizontal_Frame.blp")
	LSM:Register("background", 	"Alliance Vert. Frame", "Interface\\UnitPowerBarAlt\\Alliance_Vertical_Frame.blp")
	LSM:Register("background",	"Druid Horiz. Frame",	"Interface\\UnitPowerBarAlt\\Druid_Horizontal_Frame.blp")
	LSM:Register("background", 	"Fire Circle Frame", 	"Interface\\UnitPowerBarAlt\\Fire_Circular_Frame.blp")
	LSM:Register("background", 	"Fire Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Fire_Horizontal_Frame.blp")
	LSM:Register("background", 	"Fire Vert. Frame", 	"Interface\\UnitPowerBarAlt\\Fire_Vertical_Frame.blp")
	LSM:Register("background", 	"Generic Circle Frame", "Interface\\UnitPowerBarAlt\\Generic1Player_Circular_Frame.blp")
	LSM:Register("background", 	"Generic Horiz. Frame", "Interface\\UnitPowerBarAlt\\Generic1Player_Horizontal_Frame.blp")
	LSM:Register("background", 	"Generic Vert. Frame", 	"Interface\\UnitPowerBarAlt\\Generic1Player_Vertical_Frame.blp")
	LSM:Register("background", 	"Horde Circle Frame", 	"Interface\\UnitPowerBarAlt\\Horde_Circular_Frame.blp")
	LSM:Register("background", 	"Horde Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Horde_Horizontal_Frame.blp")
	LSM:Register("background", 	"Horde Vert. Frame", 	"Interface\\UnitPowerBarAlt\\Horde_Vertical_Frame.blp")
	LSM:Register("background", 	"Ice Circle Frame", 	"Interface\\UnitPowerBarAlt\\Ice_Circular_Frame.blp")
	LSM:Register("background", 	"Ice Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Ice_Horizontal_Frame.blp")
	LSM:Register("background", 	"Ice Vert. Frame", 		"Interface\\UnitPowerBarAlt\\Ice_Vertical_Frame.blp")
	LSM:Register("background", 	"Cogs Circle Frame", 	"Interface\\UnitPowerBarAlt\\Mechanical_Circular_Frame.blp")
	LSM:Register("background", 	"Cogs Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Mechanical_Horizontal_Frame.blp")
	LSM:Register("background", 	"Cogs Vert. Frame", 	"Interface\\UnitPowerBarAlt\\Mechanical_Vertical_Frame.blp")
	LSM:Register("background", 	"Bronze Circle Frame", 	"Interface\\UnitPowerBarAlt\\MetalBronze_Circular_Frame.blp")
	LSM:Register("background", 	"Bronze Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\MetalBronze_Horizontal_Frame.blp")
	LSM:Register("background", 	"Bronze Vert. Frame", 	"Interface\\UnitPowerBarAlt\\MetalBronze_Vertical_Frame.blp")
	LSM:Register("background", 	"Gold Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\MetalGold_Horizontal_Frame.blp")
	LSM:Register("background", 	"Gold Vert. Frame", 	"Interface\\UnitPowerBarAlt\\MetalGold_Vertical_Frame.blp")
	LSM:Register("background", 	"Stone Circle Frame", 	"Interface\\UnitPowerBarAlt\\StoneTan_Circular_Frame.blp")
	LSM:Register("background", 	"Stone Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\StoneTan_Horizontal_Frame.blp")
	LSM:Register("background", 	"Stone Vert. Frame", 	"Interface\\UnitPowerBarAlt\\StoneTan_Vertical_Frame.blp")
	LSM:Register("background", 	"Water Circle Frame", 	"Interface\\UnitPowerBarAlt\\Water_Circular_Frame.blp")
	LSM:Register("background", 	"Water Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\Water_Horizontal_Frame.blp")
	LSM:Register("background", 	"Water Vert. Frame", 	"Interface\\UnitPowerBarAlt\\Water_Pill_Frame.blp")
	LSM:Register("background", 	"Wood Circle Frame", 	"Interface\\UnitPowerBarAlt\\WoodBoards_Circular_Frame.blp")
	LSM:Register("background", 	"Wood Horiz. Frame", 	"Interface\\UnitPowerBarAlt\\WoodBoards_Horizontal_Frame.blp")
	LSM:Register("background", 	"Wood Vert. Frame", 	"Interface\\UnitPowerBarAlt\\WoodBoards_Vertical_Frame.blp")
	LSM:Register("background", 	"RedBlack Gradient", 	"Interface\\WorldMap\\UI-ArchaeologyBlob-Inside.blp")
	LSM:Register("background", 	"WorldMapBG", 			"Interface\\WorldMap\\UI-WorldMap-Middle2.blp")
	LSM:Register("background", 	"Beer Stein", 			"Interface\\PVP-Banner-Emblem-1.blp")


--sound
	LSM:Register("sound",	"Big Bad Wolf", 		"Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav")
	LSM:Register("sound", 	"Murderous Rampage", 	"Sound\\Character\\Gnome\\GnomeVocalFemale\\GnomeFemalePissed01.wav")
	LSM:Register("sound", 	"Big Bell", 			"Sound\\Doodad\\BellTollAlliance.wav")
	LSM:Register("sound", 	"Karazhan Bell", 		"Sound\\Doodad\\KharazahnBellToll.wav")
	LSM:Register("sound", 	"Bell (Klang)", 		"Sound\\Doodad\\BellTollHorde.wav")
	LSM:Register("sound", 	"Fireworks", 			"Sound\\Doodad\\G_FireworkLauncher02Custom0.wav")
	LSM:Register("sound", 	"Springs", 				"Sound\\Doodad\\Goblin_Lottery_Open03.wav")
	LSM:Register("sound", 	"Troll Drums", 			"Sound\\Doodad\\TrollDrumLoop1.wav")
	LSM:Register("sound", 	"Ogre Drums", 			"Sound\\Event Sounds\\Event_wardrum_ogre.wav")
	LSM:Register("sound", 	"Alarm Clock", 			"Sound\\Interface\\AlarmClockWarning2.wav")
	