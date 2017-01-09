function SWEP:CModelDraw()

end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Choco-Meal"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Chocolate Bar"
	SWEP.FirstStat =  "Eat to regain 50 health."
	SWEP.Stats =  ""
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = ""
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	if (os.date("*t").day == 31 or os.date("*t").day == 30 or os.date("*t").day == 29 or os.date("*t").day == 28) and os.date("*t").month == 10 then
	SWEP.Description = "Shot or Treat?"
	else
	SWEP.Description = ""
end
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true
SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.WorldModelDraw = false
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/props_halloween/halloween_medkit_small.mdl", bone = "weapon_bone", rel = "", pos = Vector(0.981, 2.746, -9.283), angle = Angle(15.857, -88.741, -0.091), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["gun"] = { type = "Model", model = "models/props_halloween/halloween_medkit_small.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.704, -4.773, 4.532), angle = Angle(-53.751, 72.167, 157.085), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.InspectStartAnim = "item1_inspect_start"
SWEP.InspectIdleAnim = "item1_inspect_idle"
SWEP.InspectEndAnim = "item1_inspect_end"

SWEP.Primary.Delay			= 4
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

self:SetWeaponHoldType("slam")
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
self.Owner:Freeze(true)
self.Owner:SetHealth(self.Owner:Health() + 50)
timer.Simple(.5,function()
if self and self:IsValid() and self.Owner and self.Owner:IsValid() then
self.Owner:ConCommand("lastinv")
self:Remove()
self.Owner:Freeze(false)
end
end)
local oldown = self.Owner
timer.Create("TF2Custom_respawnchocomeal"..self.Owner:EntIndex(),2,1,function()
oldown:EmitSound("player/recharged.wav")
if SERVER then
oldown:Give("tf2custom_test")
end
end)
end

hook.Add("PostPlayerDeath","TF2Custom_respawnchocostop",function(ply)
if timer.Exists("TF2Custom_respawnchocomeal"..ply:EntIndex()) then timer.Remove("TF2Custom_respawnchocomeal"..ply:EntIndex()) end
end)

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("ed_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
self:Think2()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("ed_idle"))
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end