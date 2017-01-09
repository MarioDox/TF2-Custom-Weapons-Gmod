function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_boxing_gloves/c_boxing_gloves.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetColor(Color(33,255,0,255))
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

function SWEP:CModelDraw()
if (CLIENT) then
render.SetColorModulation(.05,30,0)
if not self.CModel then self:makemahcmodel() end
if self.CModel then
self.CModel:DrawModel()
end
end
end


function SWEP:Melee(ent)

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 40 )
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
			bullet.Damage = 39
			trace.Entity:EmitSound("TFPlayer.CritHit")
			self.Weapon:EmitSound("weapons/boxing_gloves_hit_crit"..math.random(1,2)..".wav")
			else
			self.Weapon:EmitSound("weapons/boxing_gloves_hit"..math.random(1,4)..".wav")
			bullet.Damage = 13
			end
			self.Owner:FireBullets(bullet) 
	end
			if trace.Hit and (trace.Entity:IsNPC() or trace.Entity:IsPlayer()) then
			if self.Combo == 2 then
			self.Combo = 0
			self.Weapon:SetNWBool("Critical", false)
			elseif self.Combo == 1 then
			self.Combo = 2
			self.Weapon:SetNWBool("Critical", true)
			else
			self.Combo = 1
			self.Weapon:SetNWBool("Critical", false)
			end
			else
			self.Combo = 0
			self.Weapon:SetNWBool("Critical", false)
			end
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Baby Fist"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Boxing Gloves"
	SWEP.Stats =  "Third successful punch in a row always crits."
	SWEP.Stats2 = "50% faster firing speed"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-80% damage penality"
	SWEP.Stats11 = "No random critical hits"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Only babies wear baby fists."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_boxing_gloves/c_boxing_gloves.mdl"
SWEP.ShowWorldModel = false

SWEP.Primary.Delay			= 0.4
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
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	local vm = self.Owner:GetViewModel()
	if self.Weapon:GetNWBool("Critical") then
	vm:SendViewModelMatchingSequence(vm:LookupSequence("bg_swing_crit"))
	self.Weapon:EmitSound("weapons/fist_swing_crit.wav")
	else
	vm:SendViewModelMatchingSequence(vm:LookupSequence("bg_swing_left"))
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
self:Holster2()
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	local vm = self.Owner:GetViewModel()
	if self.Weapon:GetNWBool("Critical") then
	vm:SendViewModelMatchingSequence(vm:LookupSequence("bg_swing_crit"))
	self.Weapon:EmitSound("weapons/fist_swing_crit.wav")
	else
	vm:SendViewModelMatchingSequence(vm:LookupSequence("bg_swing_right"))
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
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bg_idle"))
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