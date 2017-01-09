AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:PhysicsCollide(data,phys)
	local playerke = self:GetOwner()
	self:Explode()
end


function ENT:Initialize()
	self:SetModel("models/weapons/c_models/urinejar.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
if SERVER then
	local playerke = self:GetOwner()
end
end

function ENT:Explode()
	playerke2 = playerke
	print(playerke2)
	for k,v in pairs (ents.FindInSphere(self:GetPos(),95)) do
	timer.Create("bees"..v:EntIndex(),.5,10,function()
	if SERVER then
	if (v:IsNPC() or v:IsPlayer()) and v:IsValid() then
	v:TakeDamage(5,playerke)
	v:EmitSound("ambient/creatures/flies"..math.random(1,5)..".wav")
	end
	end
	end)
	end
	self:EmitSound("Jar.Explode")
	local ExplodeEffect = ents.Create("info_particle_system")
	ExplodeEffect:SetPos(self:GetPos())
	ExplodeEffect:SetKeyValue( "effect_name", "peejar_impact" )
	ExplodeEffect:SetKeyValue( "start_active", "1" )
	ExplodeEffect:Spawn()
	ExplodeEffect:Activate()
	self:Remove()
end

function ENT:Think()
end