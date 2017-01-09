-- Read all weapon_ for comments not pist_ or sec_

function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_degreaser/c_degreaser.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

function SWEP:ViewModelDrawn()
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then self.CModel:DrawModel() end
end
end


local FlameLimit = { }
FlameLimit[ "gravity" ] = 2000

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "ar2"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Airblaster"	
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Flamethrower"
	SWEP.Stats =  "+50% Clip Size"
	SWEP.Stats2 = "+20% Airblast force"
	SWEP.Stats3 = "Being able to fly using airblasts"
	SWEP.Stats4 = "Alt-Fire: More powerful Airblast"
	SWEP.Stats5 = "No Airblast effect"
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No damage done"
	SWEP.Stats11 = "No afterburn"
	SWEP.Stats12 = "Alt-Fire removes 50 of ammo"
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
	if not self.Owner:IsOnGround() then
	self.Owner:SetVelocity( self.Owner:GetForward() * -500 )
	return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if (SERVER) then
	if ( trace.Hit ) and (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
	if trace.Entity:IsOnFire() then
	trace.Entity:EmitSound("player/flame_out.wav")
	trace.Entity:Extinguish()
	else
	trace.Entity:EmitSound("player/pl_impact_airblast"..math.random(1,4)..".wav")
	trace.Entity:SetVelocity( self.Owner:GetForward() *500 )
			end
		end
	end
end

SWEP.MuzzleAttachment		= "muzzle"
SWEP.MuzzleEffect			= "drg_manmelter_vacuum"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_degreaser/c_degreaser.mdl"

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 3
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 1
SWEP.Primary.AmmoDelay		= 0.08
SWEP.Primary.DefaultClip	= 2000
SWEP.Primary.Maxammo 		= 2000
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
	
	PrecacheParticleSystem( "pyro_blast" )
	PrecacheParticleSystem( "drg_manmelter_vacuum" )
	
	self.FireLoop = CreateSound(self, Sound("weapons/man_melter_alt_fire_lp.wav"))
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
if not self:CanPrimaryAttack() then return end
self:Holster2()
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
self:SetNWBool("Attacking",false)
self.FireLoop:Stop()
self.TakeAmmo = nil
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
	
	if !self.Weapon:GetNWBool("Attacking") and self:GetNextPrimaryFire() and CurTime()>=self:GetNextPrimaryFire() then
	self.Weapon:SetNWBool("Attacking",true)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_fire"))
	self.TakeAmmo = CurTime()
	umsg.Start("DoMuzzleEffect")
	umsg.Entity(self)
	umsg.String(self.MuzzleEffect)
	umsg.End()
	self.FireLoop:Play()
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
	self.FireLoop:Stop()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end


function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
if self.Owner:IsValid() then
self:Holster2()
self.FireLoop:Stop()
self.TakeAmmo = nil
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
if ((self.Owner:KeyReleased(IN_ATTACK) and self.Weapon:GetNWBool("Attacking")) or (self.Owner:WaterLevel()>=3 and self.Weapon:GetNWBool("Attacking")) or (self:Ammo1() <= 0 and self.Weapon:GetNWBool("Attacking"))) then
self.Weapon:SetNextPrimaryFire(CurTime() + .2)
self.Weapon:SetNextSecondaryFire(CurTime() + .2)
self.Weapon:SetNWBool("Attacking",false)
self.TakeAmmo = nil
self.FireLoop:Stop()
if self.CModel then
self.CModel:StopParticles()
end
self.Owner:GetViewModel():StopParticles()
self:StopParticles()
self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("ft_idle"))
end
end

function SWEP:Think()
self:Think2()
self:Attacks()
if self.TakeAmmo and CurTime()>= self.TakeAmmo then
self.TakeAmmo = CurTime() + 0.08
self:TakePrimaryAmmo(1)
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

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if self:Ammo1() <= 0 then
	self.Weapon:SetNWBool("Attacking",false)
	self.TakeAmmo = nil
	self.FireLoop:Stop()
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
	end
		return false
	end
	return true
end
