function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel(self.Model)
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
self.CModel:SetMaterial("invis")
end
end

local RPGLimit = { }
RPGLimit[ "buckshot" ] = 45

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Buck-Shot"	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Shotgun"
	SWEP.Stats = "+650% clip size"
	SWEP.Stats2 = "Reload not necessary"
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
	SWEP.Description = "Big man stole baby man's gun!"
end

SWEP.MuzzleEffect			= "muzzle_shotgun"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"


SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true
SWEP.DrawCrosshair  	= false

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.Model = "models/weapons/c_models/c_pep_scattergun.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_pep_scattergun.mdl"
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/weapons/c_models/c_pep_scattergun.mdl", bone = "weapon_bone", rel = "", pos = Vector(0, 1.888, 1.207), angle = Angle(90, -90, 0), size = Vector(1.228, 1.228, 1.228), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/doom_scout_shotgun.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/doom_scout_shotgun_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 3
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.0675
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.625
SWEP.Primary.DefaultClip	= 45
SWEP.Primary.Maxammo 		= 45
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("crossbow")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), -10)

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
	if not self:CanPrimaryAttack() then return end
self:Holster2()
	local CritMath = math.random(0,22)
	
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end


	self.Owner:GetViewModel():SetPlaybackRate(1)
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	if !self.Weapon:GetNWBool("InReload") then
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	end	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fire"))

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound)
	else
	self.Weapon:EmitSound(self.Primary.Sound)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(self.Primary.Damage*3, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip

	self.Idle = CurTime() + 0.18
	
	self.Weapon:SetNWBool("Critical", false)

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
self.Owner:GetViewModel():SetPlaybackRate(1)
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Weapon:SetNWBool("Super",false)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Weapon:SetNWBool("InReload",false)
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
self.Weapon:SetNWBool("InReload",false)
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:AmmoCheck()
for k, v in pairs( RPGLimit ) do
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
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("idle"))
self.Owner:GetViewModel():SetPlaybackRate(1)
end
for k, v in pairs( RPGLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Ammo1() <= 0 ) and self.Primary.DefaultClip > -1 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end