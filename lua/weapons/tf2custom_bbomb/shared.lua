local RPGLimit = { }
RPGLimit[ "Grenade" ] = 36

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Bouncy-Bomb Launcher"	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Grenade Launcher"
	SWEP.Stats =  "Sticky grenades: They remain attached to the enemy"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "45% of chance of hurting the enemy with an explosion"
	SWEP.Stats11 = "-60% damage done"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "A sticky, a bomb and a low chance to hit the enemy"
end

SWEP.MuzzleEffect			= "muzzle_shotgun"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"


SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/workshop/weapons/c_models/c_quadball/c_quadball.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Primary.Sound			= Sound( "Weapon_GrenadeLauncher.Single" )
SWEP.Primary.CritSound			= Sound( "Weapon_GrenadeLauncher.SingleCrit" )
SWEP.Primary.Recoil			= -1
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= -1
SWEP.Primary.Cone			= -1
SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Maxammo 		= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("crossbow")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), -10)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
end
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end
	
function SWEP:ShouldDropOnDie()
	return true
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self:Holster2()
local CritMath

	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	CritMath = math.random(0,15)

	if self.Weapon:GetNWBool("InReload") then
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = CurTime()
	self.Weapon:SetNWBool("InReload",false)
	return false
	end

	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	if !self.Weapon:GetNWBool("InReload") then
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	end
	
	ParticleEffectAttach( "muzzle_grenadelauncher", PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), self.Owner:GetViewModel():LookupAttachment("vm_weapon_bone_3"))
	ParticleEffectAttach( "muzzle_grenadelauncher", PATTACH_POINT_FOLLOW, self, 16)		
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("g_fire"))
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)

	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound)
	else
	self.Weapon:EmitSound(self.Primary.Sound)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:ShootCrit()
	else
	self:Shoot()
	end
	self.Owner:ViewPunch(Angle(3.0,0,0))

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip

	self.Idle = CurTime() + .5
	
	self.Weapon:SetNWBool("Critical", false)

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
self:SetModelScale(0.7,0.7,0.7)
self.Owner:GetViewModel():SetPlaybackRate(1)
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Weapon:SetNWBool("Super",false)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("g_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNWBool("InReload",false)
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
self.Weapon:SetNWBool("InReload",false)
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
if ( self.Reloadaftershoot > CurTime() ) then return end 

if self.Weapon:GetNWBool("InReload") then return end

	if ( self:Ammo1() <= 0 ) then return end
	if ( self.Weapon:Clip1() < self.Weapon.Primary.ClipSize ) then
	self:Holster2()
	self.Owner:SetAnimation( PLAYER_RELOAD )
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("g_reload_start"))
	self.Weapon:SetNWBool("InReload",true)
	self.Idle = nil
	self.AutoReload = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.24)

end
end

function SWEP:AmmoCheck()
for k, v in pairs( RPGLimit ) do
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
if self.Weapon:GetNWBool("InReload") and self.AutoReload and CurTime()>=self.AutoReload then
if self.Weapon:Clip1() >= self.Weapon.Primary.ClipSize or self:Ammo1() <= 0 then
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("g_reload_end"))
self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWBool("InReload",false)
else
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("loch_reload_loop"))
self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
self.AutoReload = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("g_idle"))
end
for k, v in pairs( RPGLimit ) do
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
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end

function SWEP:ShootCrit()
    if SERVER then
       
        local grenade = ents.Create("tf2custom_proj_bbomb")
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
       
        local grenade = ents.Create("tf2custom_proj_bbomb")
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
