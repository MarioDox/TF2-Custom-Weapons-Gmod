AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
local playerke = self:GetOwner()
	self:EmitSound("misc/halloween/spell_meteor_cast.wav")
	self:SetModel("models/bots/skeleton_sniper_boss/skeleton_sniper_boss.mdl")
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetPlaybackRate(1)
	self:SetAngles(self:GetAngles() + Angle(0,90,90))
	self:SetSkin(2)
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end	
	
timer.Simple(.2,function()
self:EmitSound("weapons/cbar_miss1.wav")
for k,v in pairs (ents.FindInSphere(self:GetPos(),25)) do
v:TakeDamage(15,self.Owner)
end
timer.Simple(.8,function()
self:EmitSound("weapons/cbar_miss1.wav")
for k,v in pairs (ents.FindInSphere(self:GetPos(),25)) do
v:TakeDamage(15,self.Owner)
end
timer.Simple(.5,function()
self:EmitSound("misc/halloween/skeleton_break.wav")
self:PrecacheGibs()
self:GibBreakClient( Vector(0,0,300) )
self:Remove()
end)
end)
end)
end

function ENT:Think()
if not self.First then
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	local explosion = ents.Create( "info_particle_system" )
	explosion:SetKeyValue( "effect_name", "duck_collect_green" )
	explosion:SetPos( self:GetPos()	) 
	explosion:SetAngles( self:GetAngles() - Angle(0,0,90) )
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire( "Start", "", 0 )
	explosion:Fire( "Kill", "", 0.1 )
end
self.First = true
self:SetSequence(self:LookupSequence("melee_swing2"))
self:NextThink(CurTime())
return true
end