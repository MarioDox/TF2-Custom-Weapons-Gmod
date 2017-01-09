function SWEP:CModelDraw()
end

function SWEP:Melee(ent)

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 120 )
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
			bullet.Force  = 16
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 136.5
			trace.Entity:SetVelocity(Vector(0,0,-1000))
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 45.5
			end
			if trace.Entity:IsNPC() or trace.Entity:IsPlayer() then
			trace.Entity:SetVelocity(self.Owner:EyeAngles():Forward() * 1000)
			end
			self.Weapon:EmitSound("items/pegleg_0"..math.random(1,2)..".wav")
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
	SWEP.PrintName			= "Drunk-man's Boat handler"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Oar"
	SWEP.Stats =  "Knockback on hit"
	SWEP.Stats2 = "This weapon has a large melee range"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-30% Attack penality"
	SWEP.Stats11 = "No random critical hits"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "He drank on a boat."
end

SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/props_swamp/oar_ref.mdl", bone = "weapon_bone", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["gun"] = { type = "Model", model = "models/props_swamp/oar_ref.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.884, 2.23, 0), angle = Angle(0, 90, -90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "claymore_inspect_start"
SWEP.InspectIdleAnim = "claymore_inspect_idle"
SWEP.InspectEndAnim = "claymore_inspect_end"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ShowWorldModel = false

SWEP.Primary.Delay			= 0.8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.WMOffset = false

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
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
	if self.Weapon:GetNWBool("Critical") then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("cm_swing_c"))
	self.Weapon:EmitSound("Weapon_Bottle.MissCrit")
	else
	swing = { "cm_swing_a","cm_swing_b" }
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence(table.Random( swing )))
	self.Weapon:EmitSound("Weapon_Bottle.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + 0.62

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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("cm_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster()
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("cm_idle"))
end
if self.InspectEnd and CurTime()>=self.InspectEnd then
self.Inspecting = false
self.InspectEnd = nil
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
	if CLIENT and IsValid(self.Owner) then
		self:Holster2()
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			vm:SetSubMaterial(0,nil)
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

