
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0.25

util.PrecacheSound("Weapon_Arrow.ImpactFlesh")
util.PrecacheSound("Weapon_Arrow.ImpactMetal")
util.PrecacheSound("Weapon_Arrow.ImpactWood")
util.PrecacheSound("Weapon_Arrow.ImpactConcrete")

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	local Trail = ents.Create("info_particle_system")
	Trail:SetPos(self:GetPos() - self:GetForward()*24)
	Trail:SetAngles(self:GetAngles())
	Trail:SetKeyValue( "effect_name", "rockettrail" )
	Trail:SetParent( self )
	Trail:SetKeyValue( "start_active", "1" )
	Trail:Spawn()
	Trail:Activate()

	self:SetModel("models/weapons/w_models/w_rocket.mdl")
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	self.NotStuck = true
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetNetworkedString("Owner", "World")
	self.RemoveArrow = CurTime() + 20
end

local exp

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
	if self.RemoveArrow and CurTime()>self.RemoveArrow then self:Remove() end
	if self.NotStuck then self:SetAngles(self:GetVelocity():Angle()) end
	self:NextThink(CurTime()) return true
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )
self:Explode()
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
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), 150, math.random(50,70))
		end
	
	self:Remove()
end

function ENT:PhysicsCollide()
util.Effect( "Explosion", effectdata )
util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 125, 125)
end