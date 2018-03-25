include("config.lua")
include("shared.lua")
include("languages.lua")

function ENT:Initialize()
	self.AutomaticFrameAdvance = true
end

surface.CreateFont("medic_topText", {
	font = Arial,
	size = 75,
	antialias = true
})

local function fadelerp(self,w,h,speed,color)
	self.fade = (self.fade or 0)
	if self:IsHovered() then
		self.fade = Lerp(speed,self.fade,255)
	else
		self.fade = Lerp(speed,self.fade,0)
	end
	color.a = self.fade
	draw.RoundedBox(0,0,0,w,h,color)
end
local lang
if MedicIsFrench then
	lang = {health = "Santé:",armor = "Armure:",overhead = "Médical"}
else
	lang = {health = "Health:",armor = "Armor:",overhead = "Medic"}
end

function ENT:Draw()
	self.Entity:DrawModel()
	local mypos = self:GetPos()
	if (LocalPlayer():GetPos():Distance(mypos) >= 1000) then return end
	local offset = Vector(0, 0, 80)
	local pos = mypos + offset
	local ang = (LocalPlayer():EyePos() - pos):Angle()
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 180)
	cam.Start3D2D(pos,ang,0.04)
		draw.RoundedBox(6,-250-2,0-2,500+4,150+4,Color(255,255,255))
		draw.RoundedBox(6,-250,0,500,150,Color(0,0,0))
		draw.SimpleText(lang.overhead,"medic_topText",0,75,Color(255,255,255),1,1)
	cam.End3D2D()
end

function NPCMenu()
	local main = vgui.Create("DFrame")
	main:MakePopup()
	main:SetSize(ScrW()*0.25,ScrH()*0.1)
	main:Center()
	main:SetTitle("")
	main:ShowCloseButton(false)
	main.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox(0,0,0,w,h,MavPanelBorder)
		draw.RoundedBox(0,2,2,w-4,h-4,MavPanelColor)
	end
	local close = vgui.Create("DButton",main)
	close:SetSize(25,25)
	close:SetPos(main:GetWide()-close:GetWide()-4,4)
	close:SetText("")
	close.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,MedicCloseBtnCol)
		fadelerp(self,w,h,FrameTime()*2,MedicCloseBtnFade)
		draw.SimpleText("X",Default,w/2,h/2,MedicCloseBtnTextCol,1,1)
	end
	close.DoClick = function()
		main:Close()
	end
	local health = vgui.Create("DButton",main)
	health:SetSize(main:GetWide()*0.3,main:GetTall()*0.5)
	health:SetPos(main:GetWide()*0.1,main:GetTall()/2-health:GetTall()/2)
	health:SetText("")
	health.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,MedicHealthCol)
		fadelerp(self,w,h,FrameTime()*2,MedicHealthFade)
		draw.SimpleText(lang.health .. " " .. GAMEMODE.Config.currency .. MavHealthCost,"Trebuchet18",w/2,h/2,MedicHealthTextCol,1,1)
	end
	health.DoClick = function()
		net.Start("mavgivehealth")
		net.SendToServer()
	end
	local armor = vgui.Create("DButton",main)
	armor:SetSize(main:GetWide()*0.3,main:GetTall()*0.5)
	armor:SetPos(main:GetWide()*0.6,main:GetTall()/2-armor:GetTall()/2)
	armor:SetText("")
	armor.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,MedicArmorCol)
		fadelerp(self,w,h,FrameTime()*2,MedicArmorFade)
		draw.SimpleText(lang.armor .. " " .. GAMEMODE.Config.currency .. MavArmorCost,"Trebuchet18",w/2,h/2,MedicArmorTextCol,1,1)
	end
	armor.DoClick = function()
		net.Start("mavgivearmor")
		net.SendToServer()
	end
end
net.Receive("mavshop", NPCMenu)