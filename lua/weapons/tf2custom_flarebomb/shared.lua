local RevolverLimit = { }
RevolverLimit[ "slam" ] = 32

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "FlareBomb"
	SWEP.HoldType = "revolver"
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Flare gun"
	SWEP.Stats =  "Explosive flares"
	SWEP.Stats2 = "+12% Clip size"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No burning flares"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Not a flaregun. It's a grenade-gun."
end

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFlip1		= true

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_detonator/c_detonator.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.InspectStartAnim = "item1_inspect_start"
SWEP.InspectIdleAnim = "item1_inspect_idle"
SWEP.InspectEndAnim = "item1_inspect_end"

SWEP.IsCModel			= true

SWEP.Primary.Sound			= Sound( "weapons/flaregun_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/flaregun_shoot_crit.wav" )
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 2
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Maxammo 		= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "slam"

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= 0

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("crossbow")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 1 + hand.Ang:Forward() * -2 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), -10)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
end
end

function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self:Holster2()
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	if self:Ammo1() <= 0 then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fg_fire"))

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100)
	end
	
	if self.Weapon:GetNWBool("Critical") then
	self:ShootCrit()
	else
	self:Shoot()
	end

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip
	
	self.Weapon.Primary.Cone = 0.018

	self.SpreadRecovery = CurTime() + 0.95
	self.Idle = CurTime() + 1.7
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("fg_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:AmmoCheck()
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
self:Think2()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fg_idle"))
end
if !self.Owner:KeyDown(IN_ATTACK) and self.SpreadRecovery and CurTime()>=self.SpreadRecovery then
self.SpreadRecovery = nil
self.Weapon.Primary.Cone = 0.005
end
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) and self.Primary.ClipSize > -1 then
		local timescale = GetConVarNumber("host_timescale")
		self.Weapon:EmitSound("Weapon_Revolver.ClipEmpty",100,timescale*100)
		self.Reloadaftershoot = CurTime()
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end

function SWEP:ShootCrit()
    if SERVER then
       
        local grenade = ents.Create("tf2custom_proj_flare")
        grenade:SetPos(self:ProjectileShootPos())
        grenade:SetAngles(self.Owner:EyeAngles())
        grenade:SetOwner(self.Owner)

	grenade.critical = true;
        
        grenade:Spawn()
        
		if not IsValid(grenade) then return end
        
	local vel = self.Owner:GetAimVector() * math.random(1215,1220)
        
		local phys = grenade:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			phys:ApplyForceCenter(vel)
		end

        end
        
    end

function SWEP:Shoot()
    if SERVER then
       
        local grenade = ents.Create("tf2custom_proj_flare")
        grenade:SetPos(self:ProjectileShootPos())
        grenade:SetAngles(self.Owner:EyeAngles())
        grenade:SetOwner(self.Owner)
        
        grenade:Spawn()
        
		if not IsValid(grenade) then return end
        
	local vel = self.Owner:GetAimVector() * math.random(1215,1220)
        
		local phys = grenade:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			phys:ApplyForceCenter(vel)
		end

        end
        
    end

SWEP.ProjectileShootOffset = Vector(52.6, 13, -6)

function SWEP:ProjectileShootPos()
    local pos, ang = self.Owner:GetShootPos(), self.Owner:EyeAngles()
    return pos +
        self.ProjectileShootOffset.x * ang:Forward() +
        self.ProjectileShootOffset.y * ang:Right() +
        self.ProjectileShootOffset.z * ang:Up()
end

local ForceMultiplier = 0.015

hook.Add("EntityTakeDamage","BecerStickyDetonation",function(ent, dmginfo)

	local inflictor = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	local amount	= dmginfo:GetDamage()
	if not inflictor.Explosive then return end
	
	if ent:IsNPC() or ent:IsPlayer() then
		-- Projectiles such as grenades don't do physical damage
		if not dmginfo:IsExplosionDamage() then
			dmginfo:SetDamage(0)
			return
		end
		
		-- Self damage reduction
		if attacker==ent and ent:IsPlayer() then
			if inflictor.OwnerDamage then
				dmginfo:SetDamage(dmginfo:GetDamage() * inflictor.OwnerDamage)
				dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 2)
			else
				dmginfo:SetDamage(dmginfo:GetDamage() * 0.5)
				dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 2)
			end
		end
		
		-- Overexaggerated explosion force
		ent:SetVelocity(ent:GetVelocity()+(dmginfo:GetDamageForce() * ForceMultiplier))
		
	end
end)

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
	
	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 0       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.22 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Attacker = self.Owner
	bullet.Callback = function(a, b, c) 

		if (SERVER) then

		self.TORight = 5
		self.TOUp = -1

		local StartPosPart = ents.Create("info_particle_system")
		local EndPosPart = ents.Create("info_particle_system")
		EndPosPart:SetKeyValue( "effect_name", self.TracerEffect )
		EndPosPart:SetPos(b.HitPos)
		EndPosPart:SetName( "tracer_entity" .. math.random(0, 9001) )
		EndPosPart:Spawn()
		EndPosPart:Activate()
		if self.Weapon:GetNWBool("Critical") then
		StartPosPart:SetKeyValue( "effect_name", self.TracerCritEffect )
		else
		StartPosPart:SetKeyValue( "effect_name", self.TracerEffect )
		end
		StartPosPart:SetKeyValue( "cpoint1", EndPosPart:GetName() )
		StartPosPart:SetKeyValue( "start_active", "1" )
		StartPosPart:SetName( "tracer_entity_startgheyniggah" )
		StartPosPart:SetAngles( self.Owner:EyeAngles() )
		StartPosPart:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Right()*self.TORight + self.Owner:EyeAngles():Up()*self.TOUp)
		StartPosPart:SetParent(self.Owner)
		StartPosPart:Spawn()
		StartPosPart:Activate()
		StartPosPart:Fire("kill","",self.Primary.Delay)
		EndPosPart:Fire("kill","",self.Primary.Delay)

		umsg.Start("DoMuzzleEffect")
		umsg.Entity(self)
		umsg.String(self.MuzzleEffect)
		umsg.End()
		return end
end

	self:FireBullets(bullet)					-- Fire the bullets
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

end