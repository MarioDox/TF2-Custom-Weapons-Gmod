
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
local playerown = self:GetOwner()
self:SetModel("models/props_training/target_sniper.mdl")
self:SetMoveType( MOVETYPE_NONE )
self:SetSolid( SOLID_VPHYSICS )
--self:PhysicsInit( SOLID_VPHYSICS )
self.Attack = 0
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

function ENT:Touch()
end

function ENT:Use(activator)
end

function ENT:OnTakeDamage(dmg)
if dmg:GetAttacker() == self.owner then
else
if self.Attack == 10 then
self:EmitSound("physics/wood/wood_plank_break"..math.random(1,4)..".wav")
self:PrecacheGibs()
self:GibBreakClient( Vector(0,0,300) )
self:Remove()
else
self:EmitSound("physics/wood/wood_solid_impact_bullet"..math.random(1,5)..".wav")
self.Attack = self.Attack + 1
end
end
end