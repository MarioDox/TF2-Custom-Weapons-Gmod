function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_revolver/c_revolver.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetMaterial("invis")
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

local RevolverLimit = { }
RevolverLimit[ "357" ] = 24

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Musical Bang"
	SWEP.HoldType = "revolver"
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Pistol..?"
	SWEP.Stats =  "+800% bullets per shot"
	SWEP.Stats2 = "+50% damage bonus"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "500% less accurate"
	SWEP.Stats11 = "-85% clip size"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Doesn't kill everyone from ear damage... yet."
end

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFlip1		= true

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_revolver/c_revolver.mdl"
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/workshop/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl", bone = "weapon_bone", rel = "", pos = Vector(0, 2.217, -0.951), angle = Angle(90, -90, 0), size = Vector(0.833, 0.833, 0.833), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun2"] = { type = "Model", model = "models/weapons/c_models/c_battalion_bugle/c_battalion_bugle.mdl", bone = "weapon_bone", rel = "", pos = Vector(0.137, 0.172, 9.942), angle = Angle(180, 151.154, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/reserve_shooter_02.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/reserve_shooter_02_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 6
SWEP.Primary.NumShots		= 9
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= 1
SWEP.Primary.Delay			= 0.58
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Maxammo 		= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= 0

SWEP.InspectsightPos = Vector(6.577, -20, -0.049)
SWEP.InspectsightAng = Vector(12.217, 51.812, 0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

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

	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	local CritMath = math.random(0,15)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	end
	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_dart_gun_fire"))

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(self.Primary.Damage*3, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end

	self:TakePrimaryAmmo(1)

	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("c_dart_gun_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
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
if ( self.Reloadaftershoot > CurTime() ) then return end 

	if ( self:Ammo1() <= 0 ) then return end

	if ( self.Weapon:Clip1() < self.Weapon.Primary.ClipSize ) then
	self:Holster2()
	self.Weapon:DefaultReload(self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_dart_gun_reload")))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())

end
end

function SWEP:AmmoCheck()
for k, v in pairs( RevolverLimit ) do
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("c_dart_gun_idle"))
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

	if ( self.Weapon:Clip1() <= 0 ) and self.Primary.ClipSize > -1 then
		local timescale = GetConVarNumber("host_timescale")
		self.Weapon:EmitSound("Weapon_Revolver.ClipEmpty",100,timescale*100)
		self.Reloadaftershoot = CurTime()
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end