function SWEP:CModelDraw()
end

function SWEP:Melee()

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	if ( trace.Hit ) then
			self.Primary.Delay = math.Clamp(self.Primary.Delay - .05,.22,.8)
			self.Primary.CritDamage = math.Clamp(self.Primary.CritDamage - 15,50.7,195)
			self.Primary.Damage = math.Clamp(self.Primary.Damage - 15,16.9,65)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = self.Primary.CritDamage
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = self.Primary.Damage
			end
			if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:EmitSound("Weapon_Sword.HitFlesh")
			else
			self.Weapon:EmitSound("Weapon_Sword.HitWorld")
			end
			self.Owner:FireBullets(bullet) 
			else
			self.Primary.Delay = .8
			self.Primary.CritDamage = 195
			self.Primary.Damage = 65
	end
			self.Weapon:SetNWBool("Critical", false)
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Fast Scimitar"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Sword"
	SWEP.FirstStat =  "This weapon has a large melee range"
	SWEP.Stats =  "On Hit: Increase attack speed for each hit"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "On Hit: Increase damage penality for each hit"
	SWEP.Stats11 = "No random critical hits"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "On Miss: Reset attack speed and damage penality.\nGo fast and attack fast."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_scimitar/c_scimitar.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/weapons/c_models/c_scimitar/c_scimitar.mdl", bone = "weapon_bone", rel = "", pos = Vector(-0.475, -0.801, -0.136), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "melee_allclass_inspect_start"
SWEP.InspectIdleAnim = "melee_allclass_inspect_idle"
SWEP.InspectEndAnim = "melee_allclass_inspect_end"

SWEP.Primary.CritDamage			= 195
SWEP.Primary.Damage			= 65
SWEP.Primary.Delay			= 0.8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

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

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 1 - hand.Ang:Up() * 3

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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_swing_c"))
	self.Weapon:EmitSound("Weapon_Sword.Swing")
	else
	swing = { "melee_allclass_swing_a", "melee_allclass_swing_b" }
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence(table.Random( swing )))
	self.Weapon:EmitSound("Weapon_Sword.Swing")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + self.Primary.Delay - .02

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
self:Think2()
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

function SWEP:DrawHUD()
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end