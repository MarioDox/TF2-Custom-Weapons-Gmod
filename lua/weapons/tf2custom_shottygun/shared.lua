local MinigunLimit = { }
MinigunLimit[ "buckshot" ] = 200

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "smg"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Iron's Shotgun"	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Minigun"
	SWEP.Stats =  "Silent killer: No spin sound"
	SWEP.Stats2 = "Shoots 4 bullets per sec"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "+1% Fire delay"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "A massive shotgun."
end


SWEP.MuzzleEffect			= "muzzle_minigun"
SWEP.TracerEffect = "bullet_shotgun_tracer01_red"
SWEP.TracerCritEffect = "bullet_shotgun_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"


SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model			= "models/weapons/c_models/c_iron_curtain/c_iron_curtain.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.Primary.Sound			= Sound( "Weapon_Minigun.Fire" )
SWEP.Primary.CritSound			= Sound( "Weapon_Minigun.FireCrit" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= math.random(5,7)
SWEP.Primary.NumShots		= 4
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.4
SWEP.Primary.DefaultClip	= 200
SWEP.Primary.Maxammo 		= 200
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("physgun")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.4 - hand.Ang:Forward() * -0.2 + hand.Ang:Up() * 0

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 9)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
self:SetModelScale(0.6,0.6,0.6)
end
end


function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
	end
	
	PrecacheParticleSystem( self.MuzzleEffect )
	PrecacheParticleSystem( self.TracerEffect )
	PrecacheParticleSystem( self.TracerCritEffect )
	
	self.CritFireLoop = Sound("Weapon_Minigun.FireCrit")
	self.PlayCritFireLoop = CreateSound(self, self.CritFireLoop)
	self.FireLoop = Sound("weapons/quake_rpg_fire_remastered.wav")
	self.PlayFireLoop = CreateSound(self, self.FireLoop)
	self.Weapon:SetNWBool("SpinnedUp",false)
	self.Weapon:SetNWBool("Attacking",false)
	self.Weapon:SetNWBool("AllowAttacking",false)
	util.PrecacheSound("weapons/tomislav_wind_up.wav")
	util.PrecacheSound("weapons/tomislav_wind_down.wav")
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
if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	if self:Ammo1() <= 0 then
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.15)
	self.PlayCritFireLoop:Stop()
	self.PlayFireLoop:Stop()
	return false end

	if !self.Weapon:GetNWBool("SpinnedUp") then
	self.Weapon:SetNWBool("SpinnedUp",true)
	self.Weapon:EmitSound("weapons/tomislav_wind_up.wav")
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_spool_up"))
	self.AllowFire = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon.SecondaryAttackDelay = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	ParticleEffectAttach( self.MuzzleEffect, PATTACH_POINT_FOLLOW, self, 2)			
	end
	
	if self.Weapon:GetNWBool("SpinnedUp") then

	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	if !self.Weapon:GetNWBool("AllowAttacking") then return false end
	
	local CritMath = math.random(0,150)
	
	if CritMath == 40 or CritMath == 120 then
	self.Weapon:SetNWBool("Critical", true)
	self.StopCrit = CurTime() + math.random(1.5,2.2)
	end
	
	if !self.Weapon:GetNWBool("Attacking") then
	self.HeavySound = CurTime() + math.random(4,7)
	self.Weapon:SetNWBool("Attacking", true)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_fire"))
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if self.Weapon:GetNWBool("Critical") then
	self:EmitSound("weapons/quake_rpg_fire_remastered_crit.wav")
	else
	self:EmitSound("weapons/quake_rpg_fire_remastered.wav")
	end
	
	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(self.Primary.Damage*2, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end
	
	self.Idle = nil

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
self.Owner:GetViewModel():SetPlaybackRate(1)
	self:AmmoCheck()
	self.HeavySound = nil
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_draw"))
	self.Weapon:SetNWBool("SpinnedUp",false)
	self.Weapon:SetNWBool("Attacking",false)
	self.Weapon:SetNWBool("AllowAttacking",false)
	self.Weapon:StopSound("weapons/tomislav_wind_up.wav")
	self.Weapon:StopSound("weapons/tomislav_wind_up.wav")
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon.SecondaryAttackDelay = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
self.PlayCritFireLoop:Stop()
self.PlayFireLoop:Stop()
self.Weapon:StopSound("weapons/tomislav_wind_up.wav")
self.Weapon:StopSound("weapons/tomislav_wind_up.wav")
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:AmmoCheck()
for k, v in pairs( MinigunLimit ) do
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
if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_ATTACK) and self.Weapon:GetNWBool("SpinnedUp") and self.Weapon:GetNWBool("AllowAttacking") then
self.Weapon:SetNWBool("Attacking",false)
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_spool_idle"))
self.PlayCritFireLoop:Stop()
self.PlayFireLoop:Stop()
self.Weapon:StopSound("weapons/tomislav_wind_up.wav")
self.Idle = nil
end
if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_ATTACK) and !self.Weapon:GetNWBool("SpinnedUp") and self.Weapon.SecondaryAttackDelay and CurTime()>=self.Weapon.SecondaryAttackDelay then
self.Weapon:SetNWBool("Attacking",false)
self.Weapon:SetNWBool("SpinnedUp",true)
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_spool_up"))
self.AllowFire = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:EmitSound("weapons/tomislav_wind_up.wav")
self.Idle = nil
self.PlayCritFireLoop:Stop()
self.PlayFireLoop:Stop()
self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self.Weapon.SecondaryAttackDelay = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
if !self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_ATTACK) and self.Weapon:GetNWBool("SpinnedUp") and self.Weapon.SecondaryAttackDelay and CurTime()>=self.Weapon.SecondaryAttackDelay then
self.Weapon:SetNWBool("Attacking",false)
self.Weapon:SetNWBool("SpinnedUp",false)
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_spool_down"))
self.StopFire = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.PlayCritFireLoop:Stop()
self.PlayFireLoop:Stop()
self.HeavySound = nil
self.Weapon:EmitSound("weapons/tomislav_wind_up.wav")
self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self.Weapon.SecondaryAttackDelay = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("m_idle"))
end
if self.StopFire and CurTime()>=self.StopFire then
self.StopFire = nil
self.Weapon:SetNWBool("AllowAttacking",false)
end
if self.AllowFire and CurTime()>=self.AllowFire then
self.AllowFire = nil
self.Weapon:SetNWBool("AllowAttacking",true)
end
if self.StopCrit and CurTime()>=self.StopCrit then
self.StopCrit = nil
self.Weapon:SetNWBool("Critical",false)
end
for k, v in pairs( MinigunLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:DoInspect()
if self.Owner:KeyDown(IN_ATTACK) then return end
if self.Owner:KeyDown(IN_ATTACK2) then return end
self.Idle = nil
self.Inspecting = true
self.Inspecting2 = true
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectStartAnim))
self.Inspectidle = CurTime() + vm:SequenceDuration()
end
end

function SWEP:DoEndInspect()
if self.Owner:KeyDown(IN_ATTACK) then return end
if self.Owner:KeyDown(IN_ATTACK2) then return end
self.Inspectidle = nil
self.Inspecting = false
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectEndAnim))
self.Idle = CurTime() + vm:SequenceDuration()
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if self:Ammo1() <= 0 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
		return false
	end
	return true
end

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