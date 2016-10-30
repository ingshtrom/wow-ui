local MSQ = LibStub("Masque", true)
if not MSQ then return end

-- Demigod Square
MSQ:AddSkin("Demigod Square", {
	Author = "Elloria",
	Version = "1.0",
	Shape = "Square",
	Masque_Version = 40200,
	Backdrop = {
		Width = 44,
		Height = 44,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Backdrop]],
	},
	Icon = {
		Width = 26,
		Height = 26,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 44,
		Height = 44,
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Overlay]],
	},
	Cooldown = {
		Width = 26,
		Height = 26,
	},
	AutoCast = {
		Width = 24,
		Height = 24,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 44,
		Height = 44,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Normal]],
	},
	Pushed = {
		Width = 44,
		Height = 44,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Overlay]],
	},
	Border = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		--Color = {0, 1, 0, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Border]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0, 0.75, 1, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Border]],
	},
	AutoCastable = {
		Width = 48,
		Height = 48,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Highlight]],
	},
	Gloss = {
		Width = 44,
		Height = 44,
		Texture = [[Interface\AddOns\Masque_Demigod Square\Textures\Demigod Square\Gloss]],
	},
	HotKey = {
		Width = 0,
		Height = 0,
		OffsetX = 7,
		OffsetY = -8,
	},
	Count = {
		Width = 44,
		Height = 10,
		OffsetX = -12,
		OffsetY = -6,
	},
	Name = {
		Width = 44,
		Height = 12,
		OffsetY = -6,
	},
	-- Skin data end.

}, true)