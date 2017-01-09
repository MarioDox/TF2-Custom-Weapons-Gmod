function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_machete/c_machete.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
self.CModel:SetBodygroup(0,1)
end
end

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
			bullet.Damage = 97.5
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 32.5
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:IsRagdoll() then
			self.Weapon:EmitSound("weapons/bottle_broken_hit_flesh"..math.random(1,3)..".wav")
			else
			self.Weapon:EmitSound("weapons/bottle_broken_hit_world"..math.random(1,3)..".wav")
			end
			self.Owner:FireBullets(bullet) 
			local playerki = self.Owner
			timer.Create("BottleBleed"..trace.Entity:EntIndex(),.5,10,function()
			if SERVER then
			if trace.Entity:IsNPC() or trace.Entity:IsPlayer() then
			if not trace.Entity:IsValid() then return end
			trace.Entity:TakeDamage(3,playerki)
			end
			end
			end)
	end
			self.Weapon:SetNWBool("Critical", false)
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Sharp Drink"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Bottle"
	SWEP.Stats =  "On Hit: Cause Bleed"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-50% damage penality"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "'Bloody Brilliant!' - Demoman"
end
SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model			= "models/weapons/c_models/c_bottle/c_bottle.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_bottle/c_bottle.mdl"

SWEP.InspectStartAnim = "melee_inspect_start"
SWEP.InspectIdleAnim = "melee_inspect_idle"
SWEP.InspectEndAnim = "melee_inspect_end"

SWEP.Primary.Delay			= .8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:WOffset()
if self.WMOffset then
local hand, offset, rotate
self:SetBodygroup(0,1)
self:SetWeaponHoldType("ar2")
if self.Owner and self.Owner:IsValid() then
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 7)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)
end
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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("b_swing_c"))
	self.Weapon:EmitSound("Weapon_Bottle.MissCrit")
	else
	local swing = {"b_swing_a","b_swing_b"}
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence(table.Random(swing)))
	self.Weapon:EmitSound("Weapon_Bottle.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .68

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end


function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("b_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + .5)
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("b_idle"))
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end
