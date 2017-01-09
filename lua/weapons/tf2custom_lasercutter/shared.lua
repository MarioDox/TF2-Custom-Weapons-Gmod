local RevolverLimit = { }
RevolverLimit[ "battery" ] = 100

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Laser Cutter"
	SWEP.HoldType = "revolver"
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Laser-based alien-made cutter"
	SWEP.FirstStat =  "This weapon has a short range.\nAttacking heats the weapon up, releasing cools it down."
	SWEP.Stats =  "Infinite ammo"
	SWEP.Stats2 = "No reload necessary"
	SWEP.Stats3 = "+734% Clip size"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No random critical hits"
	SWEP.Stats11 = "-66% damage penality"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Turn your enemies in to ash!\nEverything is cooler with lasers.\nAnd really hurtful in this case.."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFlip1		= true

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/workshop/weapons/c_models/c_invasion_wrangler/c_invasion_wrangler.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.InspectStartAnim = "item1_inspect_start"
SWEP.InspectIdleAnim = "item1_inspect_idle"
SWEP.InspectEndAnim = "item1_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/3rd_degree_hit_01.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/3rd_degree_hit_01.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Maxammo 		= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "battery"

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= 0

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("revolver")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 1 + hand.Ang:Forward() * 0 - hand.Ang:Up() * 0

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 7)
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

	if not self:CanPrimaryAttack() then return end
	if self.Started then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + .1)
	self.Start = CurTime() + .1
	self.Started = true
	self:EmitSound("weapons/bumper_car_go_loop.wav",75,150,1,1)
	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	--self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100)
	else
	--self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100)
	end
	--self.Idle = CurTime() + .3
	
	self.Weapon:SetNWBool("Critical", false)
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("wgl_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:EmitSound("misc/blank.wav",75,100,1,1)
self.Started = false
self.Started2 = false
self.Started3 = false
self.Started4 = false
self.AmmoTaker = nil
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
if self:Ammo1() != 0 then
if self.Started2 and self.Owner:KeyDown(IN_ATTACK) then
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_reload_loop"))
self.Idle = nil
self.Started3 = true
end
if self.Started3 and not self.Started4 then
self.Started4 = true
self.AmmoTaker = CurTime() + .1
end
if self.AmmoTaker and CurTime()>=self.AmmoTaker then
self.AmmoTaker = CurTime() + .1
self.AmmoRegain = CurTime() + 1
self:TakePrimaryAmmo(1)
local tr = {}
tr.start = self.Owner:GetShootPos()
tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
tr.filter = self.Owner
tr.mask = MASK_SHOT
local trace = util.TraceLine( tr )
if ( trace.Hit ) and (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
self:EmitSound("weapons/drg_pomson_drain_01.wav",75,100,1,6)
if SERVER then
local d = DamageInfo()
d:SetDamage( 5 )
d:SetAttacker( self.Owner )
d:SetInflictor( self )
d:SetDamageType( DMG_DISSOLVE )
trace.Entity:TakeDamageInfo(d)
end
end
end
if self.Started2 and !self.Owner:KeyDown(IN_ATTACK) then
self.Started = false
self.Started2 = false
self.Started3 = false
self.Started4 = false
self.AmmoTaker = nil
if self:Ammo1() <= 25 then
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_idle_rare"))
self:SetNextPrimaryFire(CurTime() + 2)
self.Idle = CurTime() + 2.2
self.AmmoRegain = CurTime() + .5
else
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_reload_end"))
self:SetNextPrimaryFire(CurTime() + .5)
self.Idle = CurTime() + .2
self.AmmoRegain = CurTime() + 1.5
end
self:EmitSound("misc/blank.wav",75,100,1,1)
end
if self.Start and CurTime()>=self.Start then
self.Start = nil
self.Start2 = CurTime() + .3
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_reload_start"))
end
if self.Start2 and CurTime()>=self.Start2 then
self.Started2 = true
self.Start2 = nil
self.Idle = nil
end
else
if self.Started2 then
self.Started = false
self.Started2 = false
self.Started3 = false
self.Started4 = false
self.AmmoTaker = nil
self:SetNextPrimaryFire(CurTime() + 2)
self:EmitSound("weapons/sentry_upgrading_steam4.wav")
self:EmitSound("misc/blank.wav",75,100,1,1)
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_idle_rare"))
self.Idle = CurTime() + 2.2
self.AmmoRegain = CurTime() + 1.5
end
end
if self.Weapon:GetNextPrimaryFire() and CurTime()>=self.Weapon:GetNextPrimaryFire() and not self.Started2 and self.AmmoRegain and CurTime()>=self.AmmoRegain then
self.AmmoRegain = CurTime() + .1
self.Owner:SetAmmo( math.Clamp(self:Ammo1() + 1,0,100), "battery" )
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.AmmoRegain = CurTime() + .5
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wgl_idle"))
end
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end