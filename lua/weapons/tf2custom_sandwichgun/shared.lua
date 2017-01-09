local RPGLimit = { }
RPGLimit[ "grenade" ] = 16

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Sandwich gun"	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Shotgun"
	SWEP.Stats = "On Hit: Gain up to +50 health per attack"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-25% damage penality"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Damage and health."
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
SWEP.Model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl"
SWEP.WorldModel = SWEP.Model
SWEP.VElements = {
--	["gun"] = { type = "Model", model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl", bone = "weapon_bone", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sandvich"] = { type = "Model", model = "models/weapons/c_models/c_bread/c_bread_baguette.mdl", bone = "weapon_bone", rel = "", pos = Vector(0, -5.718, 9.072), angle = Angle(90, 0, -90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
--	["gun"] = { type = "Model", model = "models/weapons/c_models/c_russian_riot/c_russian_riot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.001, 1.05, -1.482), angle = Angle(-8.379, 0, 180), size = Vector(0.819, 0.819, 0.819), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sandvich"] = { type = "Model", model = "models/weapons/c_models/c_bread/c_bread_baguette.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.753, 0.953, -7.608), angle = Angle(-8.912, 0, -180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/shotgun_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/shotgun_shoot_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 4.5
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= 0.0675
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.625
SWEP.Primary.DefaultClip	= 32
SWEP.Primary.Maxammo 		= 32
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
self:Holster2()
	local CritMath = math.random(0,22)
	
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	if self.Weapon:GetNWBool("InReload") then
	self.Owner:GetViewModel():SetSequence("reload_end")
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNWBool("InReload",false)
	return false
	end

	if not self:CanPrimaryAttack() then return end
	
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
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip

	self.Idle = CurTime() + 0.55
	
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
if ( self.Reloadaftershoot > CurTime() ) then return end 

if self.Weapon:GetNWBool("InReload") then return end

	if ( self:Ammo1() <= 0 ) then return end

	if ( self.Weapon:Clip1() < self.Weapon.Primary.ClipSize ) then
	self:Holster2()
	self.Owner:SetAnimation( PLAYER_RELOAD )
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("reload_start"))
	self.Weapon:SetNWBool("InReload",true)
	self.Idle = nil
	self.AutoReload = CurTime() + .2
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.24)

end
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
if self.Weapon:GetNWBool("InReload") and self.AutoReload and CurTime()>=self.AutoReload then
if self.Weapon:Clip1() >= self.Weapon.Primary.ClipSize or self:Ammo1() <= 0 then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("reload_end"))
self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
self.Weapon:SetNWBool("InReload",false)
else
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("reload_loop"))
self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
self.AutoReload = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end
end
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

function SWEP:DoInspect()
if self.Weapon:GetNWBool("InReload") then return end
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
if self.Weapon:GetNWBool("InReload") then return end
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

	if ( self.Weapon:Clip1() <= 0 ) and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end
SWEP.ProjectileShootOffset = Vector(52.6, 13, -6)
function SWEP:ProjectileShootPos()
    local pos, ang = self.Owner:GetShootPos(), self.Owner:EyeAngles()
    return pos +
        self.ProjectileShootOffset.x * ang:Forward() +
        self.ProjectileShootOffset.y * ang:Right() +
        self.ProjectileShootOffset.z * ang:Up()
end

function SWEP:CSShootBullet(dmg, recoil, numbul, cone)
	
	numbul 		= numbul or 1
	cone 			= cone or 0.01

	local bullet 	= {}
	bullet.Num  	= numbul
	bullet.Src 		= self.Owner:GetShootPos()       					-- Source
	bullet.Dir 		= self.Owner:GetAimVector()      					-- Dir of bullet
	bullet.Spread 	= Vector(cone, cone, 0)     						-- Aim Cone
	bullet.Tracer 	= 0       									-- Show a tracer on every x bullets
	bullet.Force 	= 0.22 * dmg     								-- Amount of force to give to phys objects
	bullet.Damage 	= dmg										-- Amount of damage to give to the bullets
	bullet.Attacker = self.Owner
	bullet.Callback = function(a, b, c) 
		
		if (SERVER) then
		if self.Owner and self.Owner:IsValid() then
		if (b.Entity:IsPlayer() or b.Entity:IsNPC()) then
		self.Owner:SetHealth(self.Owner:Health()+5)
		end
		end
		local StartPosPart = ents.Create("info_particle_system")
		local EndPosPart = ents.Create("info_particle_system")
		EndPosPart:SetKeyValue( "effect_name", self.TracerEffect )
		EndPosPart:SetPos(b.HitPos)
		EndPosPart:SetName( "tracer_entity" .. math.random(0, 9001) )
		EndPosPart:Spawn()
		EndPosPart:Activate()
		if self.Weapon:GetNWBool("Critical") then
		StartPosPart:SetKeyValue( "effect_name", self.TracerCritEffect )
		else
		StartPosPart:SetKeyValue( "effect_name", self.TracerEffect )
		end
		StartPosPart:SetKeyValue( "cpoint1", EndPosPart:GetName() )
		StartPosPart:SetKeyValue( "start_active", "1" )
		StartPosPart:SetName( "tracer_entity_startgheyniggah" )
		StartPosPart:SetAngles( self.Owner:EyeAngles() )
		StartPosPart:SetPos( self:ProjectileShootPos() )
		StartPosPart:SetParent(self.Owner)
		StartPosPart:Spawn()
		StartPosPart:Activate()
		StartPosPart:Fire("kill","",.01)
		EndPosPart:Fire("kill","",.01)

		umsg.Start("DoMuzzleEffect")
		umsg.Entity(self)
		umsg.String(self.MuzzleEffect)
		umsg.End()
end
end

	self:FireBullets(bullet)					-- Fire the bullets
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

end