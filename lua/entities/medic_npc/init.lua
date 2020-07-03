AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("languages.lua")
util.AddNetworkString("mavgivehealth")
util.AddNetworkString("mavgivearmor")
util.AddNetworkString("mavshop")

include("config.lua")
include("shared.lua")
include("languages.lua")

function ENT:Initialize( )
	
	self:SetModel( MavNPCModel )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		if not MedicIsFrench then
			if MedicShouldSpeak then
				self:EmitSound("vo/npc/male01/hi02.wav",self:GetPos())
			end
		end
		net.Start("mavshop")
		net.Send(caller)
		caller.mavRecentNPC = self
	end
end

function ENT:OnTakeDamage()
	return false
end

local function AllowedTo(ply)
	if !ply || !ply:IsValid() then return false end
	local ent = ply.mavRecentNPC
	if !ent || !ent:IsValid() then return false end
	if ply:GetPos():Distance(ent:GetPos()) > 250 then return false end
	return true
end

local function BuyHealth(length, activator)

	if !AllowedTo(activator) then return end
    
 	if ! activator:canAfford(MavHealthCost) then
		if not MedicIsFrench then
			DarkRP.notify(activator, 1, 4, "You need more money!")
		else
			DarkRP.notify(activator, 1, 4, "Vous avez besoin de plus d'argent!")
		end
		return ""
	end 

	if activator:Health() < MavMaxHealth then
		activator:addMoney(-MavHealthCost)
		activator:SetHealth(MavMaxHealth)
		hook.Run("bLogs_Maverick_BuyHealth", activator, MavHealthCost)
		if not MedicIsFrench then
			DarkRP.notify(activator, 0, 4, "You have purchased health for " .. GAMEMODE.Config.currency ..  MavHealthCost .. "!")
		else
			DarkRP.notify(activator, 0, 4, "Vous avez acheté de la santé pour " .. GAMEMODE.Config.currency ..  MavHealthCost .. "!")
		end
    else
    	if not MedicIsFrench then
    		DarkRP.notify(activator,1,4,"You have full health!")
    	else
    		DarkRP.notify(activator,1,4,"Votre santé est au maximum!")
    	end
    end

end
net.Receive("mavgivehealth", BuyHealth)

local function BuyArmor(length, activator)

	if !AllowedTo(activator) then return end
    
 	if ! activator:canAfford(MavArmorCost) then
		if not MedicIsFrench then
			DarkRP.notify(activator, 1, 4, "You need more money!")
		else
			DarkRP.notify(activator, 1, 4, "Vous avez besoin de plus d'argent!")
		end
		return ""
	end

	if activator:Armor() < MavMaxArmor then
		activator:addMoney(-MavArmorCost)
		activator:SetArmor(MavMaxArmor)
		hook.Run("bLogs_Maverick_BuyArmor", activator, MavArmorCost)
		if not MedicIsFrench then
			DarkRP.notify(activator, 0, 4, "You have purchased Armor for " .. GAMEMODE.Config.currency ..  MavArmorCost .. "!")
		else
			DarkRP.notify(activator, 0, 4, "Vous avez achetez de l'armure " .. GAMEMODE.Config.currency ..  MavArmorCost .. "!")
		end
    else
    	if not MedicIsFrench then
    		DarkRP.notify(activator,1,4,"You have full armor!")
    	else
    		DarkRP.notify(activator,1,4,"Votre Armure est au maximum!")
    	end
    end
end
net.Receive("mavgivearmor", BuyArmor)