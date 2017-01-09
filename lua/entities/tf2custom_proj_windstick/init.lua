
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	local playerown = self:GetOwner()
	self:SetModel("models/player/items/engineer/bet_wingstick.mdl")
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetNetworkedString("Owner", "World")
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
phys:SetMaterial("metal")
end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

function ENT:PhysicsCollide( data, phys )
	if not self.Stop and (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and ( data.Speed > 50 ) then data.HitEntity:TakeDamage(10,self.Owner,self.Owner) end
self.Stop = true
end

function ENT:Use(activator)
if activator:IsPlayer() then
self:Remove()
activator:Give("tf2custom_windstick")
end
end