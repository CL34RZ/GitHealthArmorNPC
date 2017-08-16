include("config.lua")
include("shared.lua")

function ENT:Initialize()
	self.AutomaticFrameAdvance = true
end

surface.CreateFont("MaverickFont", {
	size = 55,
	font = "Impact",
	antialias = true
})

function ENT:Draw()
	self.Entity:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local distance = LocalPlayer():GetPos():Distance(pos) < 500

	ang:RotateAroundAxis(ang:Up(),90)
	ang:RotateAroundAxis(ang:Forward(),90)

	if distance then
		cam.Start3D2D(pos+ang:Up(),ang,0.1)
			draw.RoundedBox(4,0-70,0-775,140,54,Color(0,0,0))
			draw.RoundedBox(4,0-68,0-773,136,50,Color(255,255,255))
			draw.SimpleText("Medic","MaverickFont",0,-750,Color(0,0,0),1,1)
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Right(),-180)

		cam.Start3D2D(pos+ang:Up()*-1,ang,0.1)
			draw.SimpleText("Medic","MaverickFont",0,-750,Color(0,0,0),1,1)
		cam.End3D2D()
	end
end

function NPCMenu()
	local NPCPanel = vgui.Create("DFrame")
	NPCPanel:SetSize(400,165)
	NPCPanel:SetDraggable(false)
	NPCPanel:SetTitle("")
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

	local creatorButton = vgui.Create("DButton" , NPCPanel)
	creatorButton:SetPos(335,140)
	creatorButton:SetSize(75,25)
	creatorButton:SetText("Creator")
	creatorButton:SetTextColor(Color(255,255,255,255))
	creatorButton.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,0))
	end
	creatorButton.DoClick = function()
		gui.OpenURL("http://steamcommunity.com/profiles/76561198109963148")
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
net.Receive("mavshop", NPCMenu)