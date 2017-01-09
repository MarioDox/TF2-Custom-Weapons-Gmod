function SWEP:Melee()

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 80 )
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
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 500000000
			bullet.Force  = 8
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = math.random(20,25)
			bullet.Force  = 2.5
			end
			if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:EmitSound("Weapon_Knife.HitFlesh")
			else
			self.Weapon:EmitSound("Weapon_Knife.HitWorld")
			end
			if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") then
			self.Owner:SetHealth(self.Owner:Health() + trace.Entity:Health())
			end
			self.Owner:FireBullets(bullet) 
	end
			self.Weapon:SetNWBool("Critical", false)
end

function SWEP:EntsInSphereBack( pos, range )
	local ents = ents.FindInSphere(pos,range)
	for k, v in pairs(ents) do
		if v != self and v != self.Owner and (v:IsNPC() or v:IsPlayer()) and IsValid(v) and !self:EntityFaceBack(v) then
			return true
		end
	end
	return false
end

function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Blade'o'Frontier"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Knife"
	SWEP.Stats =  "Backstab is replaced with a frontal-stab"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No backstab"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Because glitches."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_voodoo_pin/c_voodoo_pin.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.InspectStartAnim = "item2_inspect_start"
SWEP.InspectIdleAnim = "item2_inspect_idle"
SWEP.InspectEndAnim = "item2_inspect_end"

SWEP.Primary.Delay			= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Ammo 		= "none"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("knife")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.5 + hand.Ang:Forward() * -.7 - hand.Ang:Up() * 0

hand.Ang:RotateAroundAxis(hand.Ang:Right(), -5)
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
	self.Attack = CurTime() + 1.5
	self.Weapon:SetNWBool("BackStab",false)
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos +(self.Owner:GetAimVector( ) *66)
	tracedata.filter = self.Owner
	local tr = util.TraceLine(tracedata)
	if (tr.Entity and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer()) and !self:EntityFaceBack(tr.Entity)) or self:EntsInSphereBack( tracedata.endpos,12 ) then
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "eternal_backstab" ) )
		self.DoMelee = CurTime() + 0.09
		self.Weapon:EmitSound("Weapon_Knife.MissCrit")
		self.Weapon:SetNWBool("Critical",true)
	else
	local vm = self.Owner:GetViewModel()
	vm:ResetSequence( vm:LookupSequence( "eternal_stab_a" ) )
		self.DoMelee = CurTime() + 0.1
		self.Weapon:EmitSound("Weapon_Knife.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()

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
	self.Attack = nil
	self.Weapon:SetNWBool("BackStab",false)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("eternal_draw"))
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("eternal_idle"))
end
if self.Attack and CurTime()>= self.Attack then
self.Attack = nil
end

	local tra = {}
	tra.start = self.Owner:GetShootPos()
	tra.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 99999999 )
	tra.filter = self.Owner
	tra.mask = MASK_SHOT
	local tracez = util.TraceLine( tra )
	local tra2 = {}
	tra2.start = self.Owner:GetShootPos()
	tra2.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 80 )
	tra2.filter = self.Owner
	tra2.mask = MASK_SHOT
	local tracez2 = util.TraceLine( tra2 )
	
		if ( tracez2.Hit ) and ( tracez2.Entity:IsNPC() or tracez2.Entity:IsPlayer() ) and !self:EntityFaceBack(tracez2.Entity) and !self.Weapon:GetNWBool("BackStab") then
		self.Weapon:SetNWBool("BackStab",true)
	end
	if ( tracez.Hit ) and self.Weapon:GetNWBool("BackStab") then
		if (tracez.Entity:IsWorld() or (tracez.Entity:IsNPC() or tracez.Entity:IsPlayer()) and !self:EntityFaceBack(tracez.Entity)) then
		self.Weapon:SetNWBool("BackStab",false)
	end
	end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end