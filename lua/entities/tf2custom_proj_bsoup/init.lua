
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
local playerown = self:GetOwner()
self:SetModel("models/weapons/c_models/urinejar.mdl")
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
prop:SetModel("models/player/items/soldier/ds_can_grenades.mdl")
prop:SetPos(self:GetPos() + self:GetAngles():Forward() * -10 + self:GetAngles():Up() * 0 + self:GetAngles():Right() * -3.3)
prop:SetAngles(self:GetAngles())
prop:SetParent(self)
--prop:ManipulateBoneScale( prop:LookupBone("prp_grenade_top"), Vector(0,0,0) )
prop:ManipulateBoneScale( prop:LookupBone("prp_grenade_bottom"), Vector(0,0,0) )
--prop:ManipulateBoneScale( prop:LookupBone("prp_helmet"), Vector(0,0,0) )
prop:Spawn()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

function ENT:Explode()
if self and self:IsValid() then
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	self:EmitSound( "Jar.Explode" )
	local explosion = ents.Create( "info_particle_system" )
	explosion:SetKeyValue( "effect_name", "peejar_impact" )
	explosion:SetPos( self:GetPos()	) 
	explosion:SetAngles( self:GetAngles() )
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire( "Start", "", 0 )
	explosion:Fire( "Kill", "", 0.1 )
	local explosion2 = ents.Create( "info_particle_system" )
	explosion2:SetKeyValue( "effect_name", "breadjar_impact" )
	explosion2:SetPos( self:GetPos()	) 
	explosion2:SetAngles( self:GetAngles() )
	explosion2:Spawn()
	explosion2:Activate() 
	explosion2:Fire( "Start", "", 0 )
	explosion2:Fire( "Kill", "", 0.1 )
	
	
for k,v in pairs(ents.FindInSphere(self:GetPos(),175)) do
if v:IsNPC() or v:IsPlayer() then
v:TF2Bleed(1,10,5,self:GetOwner(),self,DMG_SLASH,true)
end
end
	
	self:Remove()
end
end

function ENT:Use(activator)
end

function ENT:PhysicsCollide(data,physobj)
self:Explode()
return true
end