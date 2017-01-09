function SWEP:Melee()

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 60 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	if ( trace.Hit ) then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 156
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 52
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
			self.Owner:SetHealth(self.Owner:Health() + 15)
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:EmitSound("Weapon_Fist.HitFlesh")
			else
			self.Weapon:EmitSound("Weapon_Fist.HitWorld")
			end
			self.Owner:FireBullets(bullet) 
	end
			self.Weapon:SetNWBool("Critical", false)
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "War-Hamm"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Ham"
	SWEP.Set = "Heavy food set"
	SWEP.Stats =  "On Hit: Gain +15 health"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-20% damage penality"
	SWEP.Stats11 = "-38% slower attack speed"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.SetAttribute = "+1 Health regeneration per second"
	SWEP.Description = "No one has forgotten his lunch to a fight."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_ham/c_ham.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Primary.Delay			= 1.1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.InspectStartAnim = "melee_allclass_inspect_start"
SWEP.InspectIdleAnim = "melee_allclass_inspect_idle"
SWEP.InspectEndAnim = "melee_allclass_inspect_end"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (0,0,0)
SWEP.IronSightsAng = Vector (0,0,0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("melee")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 - hand.Ang:Up() * 0

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 7)
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
end
	
function SWEP:ShouldDropOnDie()
	return true
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self:Holster2()
	local CritMath = math.random(0,5)
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	if CritMath == 3 then
	self.Weapon:SetNWBool("Critical", true)
	end

	if self.Weapon:GetNWBool("Critical") then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_swing"))
	self.Weapon:EmitSound("Weapon_Fist.MissCrit")
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_swing"))
	self.Weapon:EmitSound("Weapon_Fist.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + 1

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.CanInspect = CurTime()
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
self.DoMelee = nil
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
if self.Owner:HasWeapon("tf2custom_sandwichgun") and not self.SetON then
self.SetON = true
timer.Create("tf2custom_set_heavyfood_healthregen",1,0,function()
if self and self:IsValid() and self.Owner and self.Owner:IsValid() then
self.Owner:SetHealth(self.Owner:Health()+1)
end
end)
end
self:Think2()
if self.Inspectidle and CurTime()>=self.Inspectidle then
self.Inspectidle = nil
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectIdleAnim))
end
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_idle"))
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:WeaponSetAttributes()
local hasweps = self.Owner:HasWeapon("tf2custom_sandwichgun")
return hasweps
end