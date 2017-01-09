function SWEP:CModelDraw()
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then
render.CullMode( MATERIAL_CULLMODE_CW )
self.CModel:DrawModel()
render.CullMode( MATERIAL_CULLMODE_CCW )
end
end
end

local BowLimit = { }
BowLimit[ "RPG_Round" ] = 12

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "smg"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Rocket Impostor"	
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Bow"
	SWEP.Stats =  "Arrows are replaced with rockets"
	SWEP.Stats2 = "+40% Damage done"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No headshots"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Remember to hold on."
end

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= true

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model			= "models/weapons/c_models/c_bow/c_bow.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_sniper_arms.mdl"
SWEP.ViewModelBoneMods = {
	["weapon_bone_4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["rocket"] = { type = "Model", model = "models/weapons/w_models/w_rocket.mdl", bone = "weapon_bone_4", rel = "", pos = Vector(0, -0, 8.953), angle = Angle(90, 0, 0), size = Vector(0.393, 0.393, 0.393), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "item2_inspect_start"
SWEP.InspectIdleAnim = "item2_inspect_idle"
SWEP.InspectEndAnim = "item2_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/sniper_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "Weapon_SniperRifle.SingleCrit" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= 13
SWEP.Primary.Maxammo 		= 13
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "RPG_Round"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("revolver")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1.8 - hand.Ang:Up() * 0.7

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 17)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
end
end

function SWEP:FireArrow()
self:Holster2()
	local charge = self:GetNWInt("Charge")
	self.Weapon:EmitSound("Weapon_CompoundBow.Single")
	self:TakePrimaryAmmo(1)
	self.Weapon:SetNWBool("OverCharge",false)
	self.Weapon:SetNWBool("Charging",false)
	self.Weapon:SetNWInt("Charge",0)
	self.Charge1 = nil
	self.Charge2 = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_fire"))
	if (SERVER) then
	local arrow = ents.Create("tf2custom_proj_rocket") -- The entity to shoot off
	local eAng = self.Owner:EyeAngles() -- Get where we are shooting
	if !arrow:IsValid() then return end
	arrow:SetPos(self.Owner:GetShootPos() + eAng:Forward() * 1 - eAng:Right()* 0.75 - eAng:Up() * 0.5)
	arrow.Owner = self.Owner
	arrow.Wep = self.Weapon
	arrow:SetOwner(self.Owner)
	arrow:SetPhysicsAttacker(self.Owner)
	arrow:SetAngles(eAng)
	arrow:Spawn()
	if self.Weapon:GetNWBool("OverCharge") then
	arrow:SetVelocity(arrow:GetForward()*Lerp(charge/100, 200, 2500) + arrow:GetRight()*math.random(-50,50) + arrow:GetUp()*math.random(-40,40))
	else
	arrow:SetVelocity(arrow:GetForward()*Lerp(charge/100, 200, 3650))
	end
	arrow:SetGravity(Lerp(charge/100, 1.1, 0.065))
	end
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end


/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
self:Holster2()
if self.Weapon:GetNWBool("Charging") then
self.Weapon:SetNWBool("Charging", false)
self.Weapon:SetNWBool("OverCharge",false)
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_dryfire"))
self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self.Charge1 = nil
self.Charge2 = nil
self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
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

	if not self:CanPrimaryAttack() then return end
	
	if !self.Weapon:GetNWBool("Charging") then
	self.Weapon:SetNWBool("Charging",true)
	self.Weapon:SetNWInt("Charge",0)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_charge"))
	self.Weapon:EmitSound("Weapon_CompoundBow.SinglePull")
	self.NextCharge = CurTime() + 0.02
	self.Idle = nil
	self.Charge1 = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	end
	
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Charging",false)
	self.Weapon:SetNWInt("Charge", 0)
    self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("bw_draw"))
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Charge1 = nil
	self.Charge2 = nil
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	return true
end

function SWEP:Holster()
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:AmmoCheck()
for k, v in pairs( BowLimit ) do
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
self:Think3()
end

function SWEP:Think3()
if self.Owner:KeyReleased(IN_ATTACK) and self.Weapon:GetNWBool("Charging") then self:FireArrow() end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_idle"))
end
if self.Charge1 and CurTime()>=self.Charge1 then
self.Charge1 = nil
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_idle2"))
self.Charge2 = CurTime() + 5
end
if self.Charge2 and CurTime()>=self.Charge2 then
self.Charge2 = nil
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bw_idle3"))
self.Weapon:SetNWBool("OverCharge",true)
end
if self.Weapon:GetNWBool("Charging") and self.NextCharge and CurTime() >= self.NextCharge then
		if self.Weapon:GetNWInt("Charge") < 100 then
			self:SetNWInt("Charge", self.Weapon:GetNWInt("Charge") + 2.5)
			self.NextCharge = CurTime() + 0.02
		end
	end
for k, v in pairs( BowLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:DoInspect()
if self.Weapon:GetNWBool("Charging") then return end
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
if self.Weapon:GetNWBool("Charging") then return end
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

	if ( self:Ammo1() <= 0 ) then
		return false
	end
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
	if CLIENT and IsValid(self.Owner) then
		self:Holster2()
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end
