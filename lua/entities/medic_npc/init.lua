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
			activator:EmitSound("vo/npc/male01/hi02.wav",self:GetPos())
		end
		net.Start("mavshop")
		net.Send(caller)
	end
end

function ENT:OnTakeDamage()
	return false
end

function BuyHealth(length, activator)
    
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
		if not MedicIsFrench then
			DarkRP.notify(activator, 0, 4, "You have purchased health for " .. GAMEMODE.Config.currency ..  MavHealthCost .. "!")
		else
			DarkRP.notify(activator, 0, 4, "Vous avez acheté de la santé pour " .. GAMEMODE.Config.currency ..  MavHealthCost .. "!")
		end
		hook.Run("Maverick_BuyHealth", activator, MavHealthCost)
    else
    	if not MedicIsFrench then
    		DarkRP.notify(activator,1,4,"You have full health!")
    	else
    		DarkRP.notify(activator,1,4,"Votre santé est au maximum!")
    	end
    end

end
net.Receive("mavgivehealth", BuyHealth)

function BuyArmor(length, activator)
    
 	if ! activator:canAfford(MavHealthCost) then
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
		if not MedicIsFrench then
			DarkRP.notify(activator, 0, 4, "You have purchased Armor for " .. GAMEMODE.Config.currency ..  MavArmorCost .. "!")
		else
			DarkRP.notify(activator, 0, 4, "Vous avez acheté de la Armure pour " .. GAMEMODE.Config.currency ..  MavArmorCost .. "!")
		end
		hook.Run("Maverick_BuyArmor", activator, MavArmorCost)
    else
    	if not MedicIsFrench then
    		DarkRP.notify(activator,1,4,"You have full armor!")
    	else
    		DarkRP.notify(activator,1,4,"Votre Armure est au maximum!")
    	end
    end
end
net.Receive("mavgivearmor", BuyArmor)