-- Read all weapon_ for comments not pist_ or sec_

local FlameLimit = { }
FlameLimit[ "gravity" ] = 350

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "ar2"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Pilot flame"	
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Flamethrower"
	SWEP.Stats =  "Longer flames"
	SWEP.Stats2 = "No ammunition loss in water"
	SWEP.Stats3 = "+75% Clip size"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-35% damage penality"
	SWEP.Stats11 = "-45% afterburn duration"
	SWEP.Stats12 = "No random critical hits"
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Throw yourself in space"
end


function SWEP:DoFlame()
	
	if self.Owner:WaterLevel() >= 3 then return false end

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 600 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	
	if ( trace.Hit ) and (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then

		if (SERVER) then
			trace.Entity:Ignite(5.5)
			if self.Weapon:GetNWBool("Critical") then
			trace.Entity:TakeDamage(3.25, self.Owner, self)
			else
			trace.Entity:TakeDamage(0.975, self.Owner, self)
		end
	end
end
end

function SWEP:DoAirBlast()
	
	if self.Owner:WaterLevel() >= 3 then return false end

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 180 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if (SERVER) then
	if ( trace.Hit ) and (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
	if trace.Entity:IsOnFire() then
	trace.Entity:EmitSound("player/flame_out.wav")
	self.Owner:SetHealth(self.Owner:Health() + 20)
	trace.Entity:Extinguish()
	else
	trace.Entity:EmitSound("player/pl_impact_airblast"..math.random(1,4)..".wav")
	if trace.Entity:IsOnGround() then
	trace.Entity:SetVelocity( self.Owner:EyeAngles():Forward() *500 + self.Owner:EyeAngles():Up() *300)
	else
	trace.Entity:SetVelocity( self.Owner:EyeAngles():Forward() *500)
	end
			end
		end
	end
end

SWEP.MuzzleEffect			= "flamethrower_giant_mvm"
SWEP.MuzzleCritEffect			= "flamethrower_giant_mvm"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.Model			= "models/weapons/c_models/c_flamethrower/c_flamethrower.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 3
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 1
SWEP.Primary.AmmoDelay		= 0.08
SWEP.Primary.DefaultClip	= 350
SWEP.Primary.Maxammo 		= 350
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "gravity"
SWEP.Inspect = true
SWEP.Crosshair = "sprites/tf_crosshair_01"

SWEP.Secondary.Automatic		= true

game.AddParticles( "particles/flamethrower.pcf" )
game.AddParticles( "particles/flamethrower_dx80.pcf" )
game.AddParticles( "particles/flamethrower_dx90_slow.pcf" )
game.AddParticles( "particles/flamethrower_high.pcf" )
game.AddParticles( "particles/flamethrower_mvm.pcf" )
game.AddParticles( "particles/flamethrowertest.pcf" )

function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
	end
	
	PrecacheParticleSystem( self.MuzzleEffect )
	PrecacheParticleSystem( self.TracerEffect )
	PrecacheParticleSystem( self.TracerCritEffect )
	PrecacheParticleSystem( "pyro_blast" )
	PrecacheParticleSystem( "flamethrower_halloween" )
	PrecacheParticleSystem( "flamethrower" )
	PrecacheParticleSystem( "flamethrower_crit_red" )
	PrecacheParticleSystem( "flamethrower_giant_mvm" )
	
	self.DrawLoop = CreateSound(self, Sound("Weapon_FlameThrower.PilotLoop"))
	self.Fire1Loop = CreateSound(self, Sound("Weapon_FlameThrower.FireStart"))
	self.Fire2Loop = CreateSound(self, Sound("Weapon_FlameThrower.FireLoop"))
	self.CritFireLoop = CreateSound(self, Sound("Weapon_FlameThrower.FireLoopCrit"))
end

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("crossbow")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.7 + hand.Ang:Forward() * 2 - hand.Ang:Up() * 0

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 15)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

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
if self:Ammo1() < 20 then return end
if self.Owner:KeyDown(IN_ATTACK) then return end
if not self:CanPrimaryAttack() then return end
self:Holster2()
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_alt_fire"))
self:TakePrimaryAmmo(20)
self.Weapon:SetNextSecondaryFire(CurTime() + 0.8)
self.Weapon:SetNextPrimaryFire(CurTime() + 0.8)
self.Idle = CurTime() + .5
self.Weapon:EmitSound("Weapon_FlameThrower.AirBurstAttack")
umsg.Start("DoMuzzleEffect")
umsg.Entity(self)
umsg.String("pyro_blast")
umsg.End()
self:DoAirBlast()
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
if self.Owner:WaterLevel()>=3 then return end
	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetNWBool("Critical") and !self.Weapon:GetNWBool("Attacking") then
	self.Weapon:SetNWBool("Attacking",true)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.TakeAmmo = CurTime()
	self.DrawLoop:Stop()
	self.Fire1Loop:Stop()
	self.Fire2Loop:Stop()
	self.CritFireLoop:Play()
	self.EndOfStartLoop = CurTime() + 3
	umsg.Start("DoMuzzleEffect")
	umsg.Entity(self)
	umsg.String(self.MuzzleEffect)
	umsg.End()
	elseif not self.Weapon:GetNWBool("Critical") and !self.Weapon:GetNWBool("Attacking") then
	self.Weapon:SetNWBool("Attacking",true)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_fire"))
	self.TakeAmmo = CurTime()
	umsg.Start("DoMuzzleEffect")
	umsg.Entity(self)
	umsg.String(self.MuzzleEffect)
	umsg.End()
	self.DrawLoop:Stop()
	self.Fire1Loop:Play()
	self.Fire2Loop:Stop()
	self.CritFireLoop:Stop()
	self.EndOfStartLoop = CurTime() + 3
	end

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime())
	if self.Owner:WaterLevel() >= 3 then 
	self:DoFlame()
	else
	self:DoFlame()
	end
	
	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:SetModelScale(0.75,0.75,0.75)
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Weapon:SetNWBool("Attacking",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_draw"))
	self.DrawLoop:Play()
	self.Fire1Loop:Stop()
	self.Fire2Loop:Stop()
	self.CritFireLoop:Stop()
	self.EndOfStartLoop = nil
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end


function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
if self.Owner:IsValid() then
self:Holster2()
if self.CModel then
self.CModel:StopParticles()
end
if CLIENT then
self.Owner:GetViewModel():StopParticles()
self.Owner:GetViewModel():StopParticleEmission()
self:StopParticles()
end
self.DrawLoop:Stop()
self.Fire1Loop:Stop()
self.Fire2Loop:Stop()
self.CritFireLoop:Stop()
self.TakeAmmo = nil
self.EndOfStartLoop = nil
end
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:AmmoCheck()
for k, v in pairs( FlameLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Attacks()
if self.Owner:GetViewModel():GetSequence() == self.Owner:GetViewModel():LookupSequence("ft_idle") or self.Owner:GetViewModel():GetSequence() == self.Owner:GetViewModel():LookupSequence("ft_draw") then
if self.CModel then
self.CModel:StopParticles()
end
end
if (self.Owner:KeyReleased(IN_ATTACK) and self.Weapon:GetNWBool("Attacking")) or (self.Owner:WaterLevel()>=3 and self.Weapon:GetNWBool("Attacking")) or (self:Ammo1() <= 0 and self.Weapon:GetNWBool("Attacking")) then
self.Weapon:SetNextPrimaryFire(CurTime() + .2)
self.Weapon:SetNextSecondaryFire(CurTime() + .2)
self.Weapon:SetNWBool("Attacking",false)
self.TakeAmmo = nil
self.DrawLoop:Stop()
self.Fire1Loop:Stop()
self.Fire2Loop:Stop()
self.CritFireLoop:Stop()
self.EndOfStartLoop = nil
if self.CModel then
self.CModel:StopParticles()
end
self.Owner:GetViewModel():StopParticles()
self:StopParticles()
self.Weapon:EmitSound("Weapon_FlameThrower.FireEnd")
self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_idle"))
end
if self.EndOfStartLoop and CurTime()>= self.EndOfStartLoop then
self.EndOfStartLoop = nil
self.Fire1Loop:Stop()
self.Fire2Loop:Play()
end
end

function SWEP:Think()
self:Think2()
self:Attacks()

if self.Owner:WaterLevel()>=3 then self.MuzzleEffect = "flamethrower_underwater" else self.MuzzleEffect = "flamethrower_giant_mvm" end
if self.TakeAmmo and CurTime()>= self.TakeAmmo then
self.TakeAmmo = CurTime() + 0.08
self:TakePrimaryAmmo(1)
end
if self.StopCrit and CurTime()>=self.StopCrit then
self.StopCrit = nil
self.Weapon:SetNWBool("Critical",false)
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_idle"))
end
for k, v in pairs( FlameLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:DoInspect()
if self.Owner:KeyDown(IN_ATTACK) then return end
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
	self.Weapon:SetNWBool("Attacking",false)
	self.TakeAmmo = nil
	self.DrawLoop:Stop()
	self.Fire1Loop:Stop()
	self.Fire2Loop:Stop()
	self.CritFireLoop:Stop()
	self.EndOfStartLoop = nil
	if self.CModel then
	self.CModel:StopParticles()
	end
	if self.Weapon:GetNWBool("Attacking") then
	self.Weapon:SetNWBool("Attacking",false)
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	self.Idle = nil
	if self.CModel then
	self.CModel:StopParticles()
	end
	self.Owner:GetViewModel():StopParticles()
	self:StopParticles()
	self.Weapon:EmitSound("Weapon_FlameThrower.FireEnd")
	end
		return false
	end
	return true
end
