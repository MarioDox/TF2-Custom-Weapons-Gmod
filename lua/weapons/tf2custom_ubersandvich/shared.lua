function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_sandwich/c_sandwich.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:SetMaterial("models/effects/invulnfx_red")
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

local RevolverLimit = { }
RevolverLimit[ "Thumper" ] = 5

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Uber Sandvich"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Lunch"
	SWEP.Stats =  "On Use: Become ubered for a short period"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No health regained"
	SWEP.Stats11 = "Cannot be shared"
	SWEP.Stats12 = "Cannot change weapon when used"
	SWEP.Stats13 = "+50% Cooldown rate"
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Medic - Portable version."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_sandwich/c_sandwich.mdl"

SWEP.InspectStartAnim = "item1_inspect_start"
SWEP.InspectIdleAnim = "item1_inspect_idle"
SWEP.InspectEndAnim = "item1_inspect_end"

SWEP.Primary.Delay			= 1
SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip 	= 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Thumper"

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

function SWEP:EjectBrass()
end

SWEP.data 				= {}
SWEP.mode 				= "auto"

SWEP.data.semi 			= {}

SWEP.data.auto 			= {}


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
if self:Ammo1() <= 0 then return end
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
self.Weapon:SetNextPrimaryFire(CurTime() + 45)
self:Eating()
self.Idle = CurTime() + 1
end

function SWEP:Eating()
local oldowner = self.Owner
self.Owner:EmitSound("vo/sandwicheat09.mp3")
if SERVER then
self.Owner:Freeze(true)
end
timer.Create("sandvichuber1"..self.Owner:EntIndex(),2,1,function()
self.Owner:ConCommand( "pp_mat_overlay effects/invuln_overlay_red" )
self.Owner:SetNWBool("Ubered",true)
self:EmitSound("weapons/medi_shield_deploy.wav")
if SERVER then
self.Owner:Freeze(false)
self.Owner:GodEnable()
end
end)
timer.Create("sandvichuber2"..self.Owner:EntIndex(),12,1,function()
self:EmitSound("weapons/medi_shield_retract.wav")
end)
timer.Create("sandvichuber3"..self.Owner:EntIndex(),14,1,function()
if SERVER then
self.Owner:GodDisable()
end
self:Remove()
self.Owner:SetNWBool("Ubered",false)
self.Owner:ConCommand( "pp_mat_overlay  " )
self.Owner:ConCommand("lastinv")
end)
timer.Create("sandvichuberget"..oldowner:EntIndex(),53,1,function()
if SERVER then
oldowner:Give("tf2custom_ubersandvich")
end
oldowner:EmitSound("player/recharged.wav")
end)
end

hook.Add("PostPlayerDeath","Nosandvichuber",function(ply)
if timer.Exists("sandvichuber1"..ply:EntIndex()) then
timer.Remove("sandvichuber1"..ply:EntIndex())
end
if timer.Exists("sandvichuber2"..ply:EntIndex()) then
timer.Remove("sandvichuber2"..ply:EntIndex())
end
if timer.Exists("sandvichuber3"..ply:EntIndex()) then
timer.Remove("sandvichuber3"..ply:EntIndex())
end
if timer.Exists("sandvichuberget"..ply:EntIndex()) then
timer.Remove("sandvichuberget"..ply:EntIndex())
end
ply:ConCommand( "pp_mat_overlay  " )
ply:Freeze(false)
end)

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("sw_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	--self.Weapon:SetNextPrimaryFire(CurTime() + self.Weapon:GetNextPrimaryFire() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:AmmoCheck()
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
if self.Owner:GetNWBool("Ubered") then return false end
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("sw_idle"))
end
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end


/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end