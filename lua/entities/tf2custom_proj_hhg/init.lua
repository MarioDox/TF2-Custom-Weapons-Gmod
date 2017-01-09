
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
local playerown = self:GetOwner()
self:SetModel("models/weapons/w_models/w_baseball.mdl")
self:SetMoveType( MOVETYPE_VPHYSICS )
self:SetSolid( SOLID_VPHYSICS )
self:SetSolid( SOLID_CUSTOM )
self:PhysicsInit( 1 )
self:PhysicsInitSphere( 1.9, "metal" )
--self:SetNetworkedString("Owner", "World")
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
phys:SetMass(1)
end
local prop = ents.Create("prop_dynamic")
prop:SetModel("models/player/items/soldier/worms_gear.mdl")
prop:SetPos(self:GetPos() + self:GetAngles():Forward() * -10.5 + self:GetAngles():Up() * -58 + self:GetAngles():Right() * 1)
prop:SetAngles(self:GetAngles())
prop:SetParent(self)
prop:ManipulateBoneScale( prop:LookupBone("prp_grenade_top"), Vector(0,0,0) )
--prop:ManipulateBoneScale( prop:LookupBone("prp_grenade_bottom"), Vector(0,0,0) )
prop:ManipulateBoneScale( prop:LookupBone("prp_helmet"), Vector(0,0,0) )
prop:Spawn()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

function ENT:Explode()
self:EmitSound("player/taunt_wormshhg.wav",90,100,1,1)
timer.Simple(2.5,function()
if self and self:IsValid() then
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	self:EmitSound( "Weapon_Grenade_Pipebomb.Explode" )
	local explosion = ents.Create( "info_particle_system" )
	explosion:SetKeyValue( "effect_name", "ExplosionCore_MidAir_Flare" )
	explosion:SetPos( self:GetPos()	) 
	explosion:SetAngles( self:GetAngles() )
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire( "Start", "", 0 )
	explosion:Fire( "Kill", "", 0.1 )
	
	if self.Owner and IsValid(self.Owner) then
		if !self.critical then
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), 285, 75 )
		else
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), 285, 180 )
		end
	else
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 285, 75 )
	end
	
	self:Remove()
end
end)
end

function ENT:Use(activator)
end

function ENT:PhysicsCollide(data,physobj)
if !self.HOLYSHITITGOTActivated then
self:GetPhysicsObject():SetVelocity(self:GetVelocity()/10)
self.HOLYSHITITGOTActivated = true
timer.Simple(2,function() if self and self:IsValid() then self:Explode() end end) 
	if ( data.Speed > 100 ) then
		self:EmitSound( "Weapon_Grenade_Pipebomb.Bounce" )
	end
--self:Remove()
return true
end
end