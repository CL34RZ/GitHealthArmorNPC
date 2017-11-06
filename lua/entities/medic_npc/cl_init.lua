include("config.lua")
include("shared.lua")
include("languages.lua")

function ENT:Initialize()
	self.AutomaticFrameAdvance = true
end

surface.CreateFont("MaverickFont", {
	size = 55,
	font = "Impact",
	antialias = true
})
surface.CreateFont("barTopInfo",{
	size = 25,
	font = "Arial",
	antialias = true
})
surface.CreateFont("medicHeader",{
	size = 50,
	font = "Arial",
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
			if not MedicIsFrench then
				draw.RoundedBox(4,0-70,0-775,140,54,Color(0,0,0))
				draw.RoundedBox(4,0-68,0-773,136,50,Color(255,255,255))
				draw.SimpleText("Medic","MaverickFont",0,-750,Color(0,0,0),1,1)
			else
				draw.RoundedBox(4,0-80,0-775,160,54,Color(0,0,0))
				draw.RoundedBox(4,0-78,0-773,156,50,Color(255,255,255))
				draw.SimpleText("Medecin","MaverickFont",0,-750,Color(0,0,0),1,1)
			end
		cam.End3D2D()

		ang:RotateAroundAxis(ang:Right(),-180)

		cam.Start3D2D(pos+ang:Up()*-1,ang,0.1)
			if not MedicIsFrench then
				draw.SimpleText("Medic","MaverickFont",0,-750,Color(0,0,0),1,1)
			else
				draw.SimpleText("Medecin","MaverickFont",0,-750,Color(0,0,0),1,1)
			end
		cam.End3D2D()
	end
end

function NPCMenu()
	local NPCPanel = vgui.Create("DFrame")
	NPCPanel:SetSize(500,260)
	NPCPanel:SetDraggable(true)
	NPCPanel:SetTitle("")
	NPCPanel:MakePopup()
	NPCPanel:SetSizable(false)
	NPCPanel:SetDeleteOnClose(false)
	NPCPanel:ShowCloseButton(false)
	NPCPanel:Center()
	NPCPanel.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox(8,0,0,w,h,MavPanelBorder)
		draw.RoundedBox(8,2,2,w-4,h-4,MavPanelColor)
		if not MedicIsFrench then
			draw.SimpleText("Let's get you patched up then shall we?","barTopInfo",250,100,Color(255,255,255),1,1)
			draw.SimpleTextOutlined("Medic","medicHeader",250,50,Color(255,255,255),1,1,2,Color(0,0,0))
		else
			draw.SimpleText("Allons-nous vous remémer, alors devons-nous?","barTopInfo",250,100,Color(255,255,255),1,1)
			draw.SimpleTextOutlined("Medecin","medicHeader",250,50,Color(255,255,255),1,1,2,Color(0,0,0))
		end
	end

	local HealthButton = vgui.Create("DButton", NPCPanel)
		HealthButton:SetPos(25,175)
		HealthButton:SetSize(125,50)
		if not MedicIsFrench then
			HealthButton:SetText(" Health: ".. GAMEMODE.Config.currency .. string.Comma(MavHealthCost))
		else
			HealthButton:SetText(" Santé: ".. GAMEMODE.Config.currency .. string.Comma(MavHealthCost))
		end
		HealthButton:SetTextColor(CLTextColor)
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
		ArmorButton:SetPos(500-150,175)
		ArmorButton:SetSize(125,50)
		if not MedicIsFrench then
			ArmorButton:SetText(" Armor: ".. GAMEMODE.Config.currency .. string.Comma(MavArmorCost))
		else
			ArmorButton:SetText(" Armure: ".. GAMEMODE.Config.currency .. string.Comma(MavArmorCost))
		end
		ArmorButton:SetTextColor(CLTextColor)
		ArmorButton.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(0,0,150))
		end
		ArmorButton.DoClick = function()
			NPCPanel:Close()
			net.Start("mavgivearmor")
			net.SendToServer(ply)
		end

	local CloseButton = vgui.Create("DButton" , NPCPanel)
	CloseButton:SetPos(500-25,4)
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