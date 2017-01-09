function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_energy_drink/c_energy_drink.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetSkin(2)
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

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Mini drink"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Drink"
	SWEP.Stats =  "When used: Mini-resize yourself for 25 seconds"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "When used: Split your health"
	SWEP.Stats11 = "When used: Cannot change weapon"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "You're a tiny baby."
end

SWEP.MuzzleEffect			= "energydrink_splash"
SWEP.MuzzleAttachment		= "drink_spray"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_energy_drink/c_energy_drink.mdl"

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
self:SetSkin(2)
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
if self.Big then return end
if self.Owner:GetModelScale() <= .5 then return end
if self.Owner:Health() == 1 then return end
self:Drink()
end

function SWEP:Drink()
local drinke = math.random(12,47)
self.Owner:SetHealth(self.Owner:Health() / 2)
self:EmitSound("player/pl_scout_dodge_can_drink_fast.wav", 100,140,1,1)
self.Owner:SetModelScale(.1)
self.Owner:SetViewOffset(Vector(0,0,8))
self.Owner:SetViewOffsetDucked(Vector(0,0,5))
self.Owner:ResetHull()
self.Owner:SetHull(Vector(-9,-9,0),Vector(9,9,20))
self.Owner:SetHullDuck(Vector(-9,-9,0),Vector(9,9,10))
self.Big = CurTime() + 25
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
self.Owner:SetModelScale(1)
	self:EmitSound("weapons/draw_madmilk.wav")
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("ed_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	if CLIENT then
	self.MuzzleEffect			= "energydrink_splash"
	self.MuzzleAttachment		= "drink_spray"
	end
	if SERVER then
	umsg.Start("DoBonkMuzzleEffect")
	umsg.Entity(self)
	umsg.String(self.MuzzleEffect)
	umsg.End()
	end
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
if self.Big and CurTime() > 0 then return end
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
if self.Big and CurTime()>=self.Big then
self.Owner:ConCommand("lastinv")
self.Big = nil
self.Owner:SetModelScale(1)
self.Owner:SetViewOffset(Vector(0,0,64))
self.Owner:SetViewOffsetDucked(Vector(0,0,28))
self.Owner:SetHealth(self.Owner:Health() * 2 )
self.Owner:ResetHull()
self:Remove()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("ed_idle"))
end
end

local function PlayerDeathM(ply)
ply.Big = nil
ply:SetModelScale(1)
ply:SetViewOffset(Vector(0,0,64))
ply:SetViewOffsetDucked(Vector(0,0,28))
end

hook.Add("PlayerDeath", "PlayerDeathM", PlayerDeathM)

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end