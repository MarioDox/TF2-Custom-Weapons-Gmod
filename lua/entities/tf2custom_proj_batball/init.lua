AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
timer.Simple( 12,function()
self:Remove()
end)
	local Trail = ents.Create("info_particle_system")
	Trail:SetPos(self:GetPos())
	Trail:SetKeyValue( "effect_name", "stunballtrail_red" )
	Trail:SetParent( self )
	Trail:SetKeyValue( "start_active", "1" )
	Trail:Spawn()
	Trail:Activate()
	util.SpriteTrail(self, 0, Color(255,100,100), false, 8, 1, 0.28, 1/(8+1)*0.5, "Effects/baseballtrail_red.vmt")

	self:SetModel("models/weapons/w_models/w_baseball.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( true )
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetNetworkedString("Owner", "World")
	
	local phys = self:GetPhysicsObject()
	
	phys:SetMass(1.4)
	
	self.DoRemove = CurTime() + 20
	self.AllowHit = CurTime() + 0.085
	self.HomeRun = CurTime() + 0.6
	self.NextHit = CurTime()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local exp

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

function ENT:Use(pl)
end

function ENT:Touch(ent)

if self.AllowHit and CurTime()>=self.AllowHit and self.NextHit and CurTime()>=self.NextHit then

if !ent:IsNPC() or !ent:IsPlayer() then
self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
end
end
ent:EmitSound("TFPlayer.StunImpact")
if self:GetVelocity():Length() >= 50 then 
ent:TakeDamage(6, self.Owner, self)
end
end

