include("config.lua")
include("shared.lua")

function ENT:Initialize()
	self.AutomaticFrameAdvance = true
	end

surface.CreateFont( "MaverickFont", {
	font = "Arial",
	extended = false,
	size = 25,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
} )

function ENT:Draw()
	self.Entity:DrawModel()

	for k, ent in pairs (ents.FindByClass("maverick_npc")) do
		local Ang = ent:GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), -90)

	cam.Start3D2D(ent:GetPos()+ent:GetUp()*77, Ang, 0.20)

	draw.SimpleTextOutlined("Medic", "MaverickFont", 0,0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))

	Ang:RotateAroundAxis( Ang:Right(), -180)
		
		cam.Start3D2D(ent:GetPos()+ent:GetUp()*80, Ang, 0.20)
			draw.SimpleTextOutlined("Medic", "MaverickFont", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
		cam.End3D2D()

	cam.End3D2D()

	end
end

function NPCMenu()

	local NPCPanel = vgui.Create("DFrame")
	NPCPanel:SetSize(400,165)
	NPCPanel:SetDraggable(false)
	NPCPanel:SetTitle("Made By MaverickMeme:")
	NPCPanel:MakePopup()
	NPCPanel:SetSizable(false)
	NPCPanel:SetDeleteOnClose(false)
	NPCPanel:ShowCloseButton(false)
	NPCPanel:Center()
		NPCPanel.Paint = function(self,w,h)
			draw.RoundedBox(8,0,0,w,h,MavPanelBorder)
			draw.RoundedBox(8,2,2,w-4,h-4,MavPanelColor)
		end

	local HealthButton = vgui.Create("DButton", NPCPanel)
		HealthButton:SetPos(25,58)
		HealthButton:SetSize(75,50)
		HealthButton:SetText(" Health: ".. GAMEMODE.Config.currency .. MavHealthCost)
		HealthButton:SetTextColor(Color(255,255,255))
		HealthButton.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(150,0,0))
		end
		HealthButton.DoClick = function()
			NPCPanel:Close()
			net.Start("mavgivehealth")
			net.SendToServer(ply)
		end

	local ArmorButton = vgui.Create("DButton", NPCPanel)
		ArmorButton:SetPos(300,58)
		ArmorButton:SetSize(75,50)
		ArmorButton:SetText(" Armor: ".. GAMEMODE.Config.currency .. MavArmorCost)
		ArmorButton:SetTextColor(Color(255,255,255))
		ArmorButton.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(0,0,150))
		end
		ArmorButton.DoClick = function()
			NPCPanel:Close()
			net.Start("mavgivearmor")
			net.SendToServer(ply)
		end

	local MavButton = vgui.Create("DButton" , NPCPanel)
	MavButton:SetPos(127,0)
	MavButton:SetSize(30,25)
	MavButton:SetText("Steam")
	MavButton:SetTextColor(Color(255,255,255,255))
	MavButton.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,0))
	end
	MavButton.DoClick = function(caller)
		gui.OpenURL("http://steamcommunity.com/id/Blalerina")
	end

	local CloseButton = vgui.Create("DButton" , NPCPanel)
	CloseButton:SetPos(375,4)
	CloseButton:SetSize(20,20)
	CloseButton:SetText(" X")
	CloseButton:SetTextColor(Color(255,255,255,255))
	CloseButton.Paint = function(self,w,h)
		draw.RoundedBox(50,0,0,w,h,Color(255,0,0))
	end
	CloseButton.DoClick = function()
		NPCPanel:Close()
	end

end
usermessage.Hook("ShopUsed", NPCMenu)