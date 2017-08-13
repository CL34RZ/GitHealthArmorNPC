AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config.lua")
util.AddNetworkString("mavgivehealth")
util.AddNetworkString("mavgivearmor")

include("config.lua")
include("shared.lua")

function ENT:Initialize( )
	
	self:SetModel( MavNPCModel )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		activator:EmitSound("vo/npc/male01/hi01.wav",self:GetPos())
		umsg.Start("ShopUsed", caller)
		umsg.End()
	end
end

function ENT:OnTakeDamage()
	return false
end

function BuyHealth(length, activator)
    
 	if not activator:canAfford(MavHealthCost) then
	DarkRP.notify(activator, 1, 4, "You need more money!")
	return ""
	end 

	if activator:Health() < MavMaxHealth then
	activator:addMoney(-MavHealthCost)
	activator:SetHealth(MavMaxHealth)
	DarkRP.notify(activator, 1, 4, "You have purchased health for " .. GAMEMODE.Config.currency ..  MavHealthCost .. "!")
	hook.Run("Maverick_BuyHealth", activator, MavHealthCost)
    end

    if activator:Health() == MavMaxHealth then
    	DarkRP.notify(activator, 1, 4, "You already have full health!")
    end

end
net.Receive("mavgivehealth", BuyHealth)

function BuyArmor(length, activator)
    
 	if not activator:canAfford(MavArmorCost) then
	DarkRP.notify(activator, 1, 4, "You need more money!")
	return ""
	end 

	if activator:Armor() < MavMaxArmor then
	activator:addMoney(-MavArmorCost)
	activator:SetArmor(MavMaxArmor)
	DarkRP.notify(activator, 1, 4, "You have purchased Armor for " .. GAMEMODE.Config.currency ..  MavArmorCost .. "!")
	hook.Run("Maverick_BuyArmor", activator, MavArmorCost)
    end

    if activator:Armor() == MavMaxArmor then
	DarkRP.notify(activator, 1, 4, "You already have full armor!")
    end
end
net.Receive("mavgivearmor", BuyArmor)
