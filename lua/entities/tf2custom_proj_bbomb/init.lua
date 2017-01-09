
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.model = "models/workshop/weapons/c_models/c_quadball/w_quadball_grenade.mdl"

function ENT:Initialize()
	self:SetModel( self.model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_CUSTOM )
	self:SetHealth(1)
	self:PhysicsInit( 1 )
	self:PhysicsInitSphere( self:GetModelScale(), "metal_bouncy" )
	//self:SetCollisionBounds(Vector(-12,-12,-12),Vector(12,12,12)) 
	self:SetMoveCollide( 7 )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
		//phys:EnableGravity( false )
		//phys:EnableDrag( false )
		//phys:SetBuoyancyRatio( 0 )
	end
	
	self.ai_sound = ents.Create( "ai_sound" )
	self.ai_sound:SetPos( self:GetPos() )
	self.ai_sound:SetKeyValue( "volume", "80" )
	self.ai_sound:SetKeyValue( "duration", "8" )
	self.ai_sound:SetKeyValue( "soundtype", "8" )
	self.ai_sound:SetParent( self )
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire( "EmitAISound", "", 0 )
	
	timer.Simple(2, function() if self and IsValid(self) then self:Explode() end end)
	
	local effect = "red"
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name","pipebombtrail_" .. effect)
	self.particle_trail:SetKeyValue("start_active", "1")
	self.particle_trail:Spawn()
	self.particle_trail:Activate()
	
	if !self.critical then return end
	self.particle_crit = ents.Create("info_particle_system")
	self.particle_crit:SetPos(self:GetPos())
	self.particle_crit:SetParent(self)
	self.particle_crit:SetKeyValue("effect_name","critical_pipe_" .. effect)
	self.particle_crit:SetKeyValue("start_active", "1")
	self.particle_crit:Spawn()
	self.particle_crit:Activate()
end

function ENT:OnRemove()
	if self.ai_sound and IsValid(self.ai_sound) then self.ai_sound:Remove() end
	if self.particle_trail and IsValid(self.particle_trail) then self.particle_trail:Remove() end
	if self.particle_crit and IsValid(self.particle_crit) then self.particle_crit:Remove() end
end

function ENT:Think()
end

function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	self:EmitSound( "Weapon_Grenade_Pipebomb.Explode" )
	local explosion = ents.Create( "info_particle_system" )
	explosion:SetKeyValue( "effect_name", "ExplosionCore_MidAir" )
	explosion:SetPos( self:GetPos()	) 
	explosion:SetAngles( self:GetAngles() )
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire( "Start", "", 0 )
	explosion:Fire( "Kill", "", 0.1 )
	
	if self.Owner and IsValid(self.Owner) then
		if !self.critical then
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), 30, math.random(9,11) )
		else
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), 30, math.random(27,33) )
		end
	else
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 30, math.random(15,15) )
	end
	
	self:Remove()
end

function ENT:PhysicsCollide( data, physobj )
	if ( data.Speed > 100 ) then
		self:EmitSound( "Weapon_Grenade_Pipebomb.Bounce" )
	end
	return true
end

function ENT:Touch(ent)
if not ent:IsWorld() then
self:SetMoveType( MOVETYPE_NONE )
--self:PhysicsInit( SOLID_NONE )
self:SetParent(ent)
end
end
