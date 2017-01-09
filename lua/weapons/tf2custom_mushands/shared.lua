function SWEP:CModelDraw()
end

function SWEP:Melee(ent)

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
			bullet.Force  = 5
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 136.5
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 45.5
			end
			self.Weapon:EmitSound("Weapon_Machete.HitFlesh")
			self.Owner:FireBullets(bullet) 
			local playerki = self.Owner
			trace.Entity:TF2Bleed(1,10,3,playerki,self,DMG_ACID,false)
	end
			self.Weapon:SetNWBool("Critical", false)
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Mush-hands"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Poison Mushrooms"
	SWEP.Stats =  "On Hit: Poison target"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-30% damage penality"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Who wants mushrooms?"
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_boxing_gloves/c_boxing_gloves.mdl"
SWEP.ShowWorldModel = false
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/workshop/player/items/all_class/hwn2016_toadstool_topper/hwn2016_toadstool_topper_demo.mdl", bone = "bip_hand_L", rel = "", pos = Vector(0, -87, 3.648), angle = Angle(0, -0.751, 90), size = Vector(1.133, 1.133, 1.133), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun+"] = { type = "Model", model = "models/workshop/player/items/all_class/hwn2016_toadstool_topper/hwn2016_toadstool_topper_heavy.mdl", bone = "bip_hand_R", rel = "", pos = Vector(-22.989, 95, -0.5), angle = Angle(0, -15, -90), size = Vector(1.200, 1.200, 1.200), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Primary.Delay			= .8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.PTime = 0

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= true
SWEP.Secondary.Ammo 		= "none"

SWEP.Inspect = false

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end
self:SetSkin(2)

self:SetWeaponHoldType("revolver")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1 - hand.Ang:Up() * -2

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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_swing_crit"))
	self.Weapon:EmitSound("weapons/fist_swing_crit.wav")
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_swing_left"))
	self.Weapon:EmitSound("weapons/boxing_gloves_swing"..math.random(1,2)..".wav")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .78
	
	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

function SWEP:SecondaryAttack()
	local CritMath = math.random(0,5)
	if CritMath == 3 then
	self.Weapon:SetNWBool("Critical", true)
	end
	if self.Weapon:GetNWBool("Critical") then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_swing_crit"))
	self.Weapon:EmitSound("weapons/fist_swing_crit.wav")
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_swing_right"))
	self.Weapon:EmitSound("weapons/boxing_gloves_swing"..math.random(1,2)..".wav")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + .22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .78

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.PTime = CurTime() + 0.5
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self.DoMelee = nil
self.PTime = nil
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
if self.Idle and CurTime()>=self.Idle then
self.Idle = CurTime() + 1
self:SendWeaponAnim(self.Owner:GetViewModel():GetSequenceActivity(self.Owner:GetViewModel():LookupSequence("bg_idle")))
end
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end