function SWEP:Throw()

	self.DoThrow = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 120 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	if trace.Hit then self:EmitSound("weapons/medigun_no_target.wav") return end
	self.Weapon:EmitSound("Weapon_Fireaxe.Miss")
	if SERVER then
	local sap = ents.Create("tf2custom_proj_humansapper")
	sap:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 120 )
	sap:SetAngles(self.Owner:EyeAngles())
	sap.Owner = self.Owner
	sap:Spawn()
	sap:GetPhysicsObject():SetVelocity(self.Owner:EyeAngles():Forward() * 1000)
	self:Remove()
	self.Owner:ConCommand("lastinv")
	local sapowner = self.Owner
	timer.Create("humansapperrespawn"..sapowner:EntIndex(),15,1,function()
	if sapowner:IsValid() then
	if SERVER then
	sapowner:Give("tf2custom_humansapper")
	end
	end
	end)
	end
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Human Breaker"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Sapper"
	SWEP.Stats =  "On Use: Drop the sapper and break the target view for a short period"
	SWEP.Stats2 = "Can be picked up from ground"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Has a cooldown period"
	SWEP.Stats11 = "Cannot Sap buildings"
	SWEP.Stats12 = "Can be destroyed"
	SWEP.Stats13 = "-100% Damage penality"
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Hack their brain."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_sapper/c_sapper.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Primary.Delay			= 0.55
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.Inspect = false

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
	local CritMath = math.random(0,5)
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoThrow = CurTime()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .5
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.DoThrow = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_sapper_drawdeployed"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self.DoThrow = nil
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
if self.DoThrow and CurTime()>=self.DoThrow then
self.DoThrow = nil
self:Throw()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_sapper_idle"))
end
end
/*--------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:Equip()
if self.Owner:GetActiveWeapon():GetClass() == self:GetClass() then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_sapper_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
end
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

hook.Add("PostPlayerDeath","HumanSapperTimerStop",function(ply)
if timer.Exists("humansapperrespawn"..ply:EntIndex()) then timer.Remove("humansapperrespawn"..ply:EntIndex()) end
end)