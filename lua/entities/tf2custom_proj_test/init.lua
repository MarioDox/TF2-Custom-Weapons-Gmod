
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/workshop/weapons/c_models/c_quadball/w_quadball_grenade.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetHealth(1)
	--self:PhysicsInit( 6 )
	//self:PhysicsInitSphere( 12 )
	//self:SetCollisionBounds(Vector(-12,-12,-12),Vector(12,12,12)) 
	--self:SetMoveCollide( 3 )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(1)
		//phys:EnableGravity( false )
		//phys:EnableDrag( false )
		//phys:SetBuoyancyRatio( 0 )
	end
	
	timer.Simple(2, function() if self and IsValid(self) then self:Explode() end end)
end

function ENT:Think()
end

function ENT:Explode()

	self:EmitSound( "Weapon_Grenade_Pipebomb.Explode" )

	
	if self.Owner and IsValid(self.Owner) then
		if !self.critical then
			--util.BlastDamage( self, self:GetOwner(), self:GetPos(), 180, math.random(90,110) )
		else
			--util.BlastDamage( self, self:GetOwner(), self:GetPos(), 190, math.random(270,330) )
		end
	else
		--util.BlastDamage( self, self:GetOwner(), self:GetPos(), 180, math.random(105,115) )
	end


	
	self:Remove()
end

function ENT:PhysicsCollide( data, physobj )

	if ( data.Speed > 100 ) then
		self:EmitSound( "Weapon_Grenade_Pipebomb.Bounce" )
	end
	return true
end

