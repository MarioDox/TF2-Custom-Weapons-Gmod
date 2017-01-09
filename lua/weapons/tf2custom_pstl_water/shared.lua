local RevolverLimit = { }
RevolverLimit[ "pistol" ] = 198

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "pistol"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Water-only Pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo = false
	SWEP.Type =  "Pistol"
	SWEP.Stats =  "Wearer can't drown when equipped"
	SWEP.Stats2 = "Infinite ammo"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Can shoot only in water"
	SWEP.Stats11 = "-30% damage penality"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "A Dolphin-eer."
end

SWEP.MuzzleEffect			= "muzzle_pistol"
SWEP.TracerEffect = "bullet_pistol_tracer01_red"
SWEP.TracerCritEffect = "bullet_pistol_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model			= "models/weapons/c_models/c_winger_pistol/c_winger_pistol.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/pistol_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "Weapon_Pistol.SingleCrit" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= math.random(22,44)
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.16
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Maxammo 		= 200
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Penetration			= true
SWEP.PrimMaxPenetration 	= 12
SWEP.PrimMaxWoodPenetration = 14
SWEP.Ricochet			= false
SWEP.MaxRicochet			= 0

SWEP.IronSightsPos = Vector (0,0,0)
SWEP.IronSightsAng = Vector (0,0,0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("pistol")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 + hand.Ang:Up() * -1

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
self:SetModelScale(0.7,0.7,0.7)
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
self.Owner:GetViewModel():SetPlaybackRate(1)
if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	
	if CLIENT then
	if self.Owner:KeyPressed(IN_USE) then
	self:EmitSound("weapons/draw_secondary.wav")
	end
	end
if self.Owner:WaterLevel() <= 3 then
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pstl_fire"))
self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
self.Idle = CurTime() + 0.05
self.Weapon:EmitSound("Weapon_Pistol.ClipEmpty")
end
	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	if self.Owner:WaterLevel() >= 3 then
	local CritMath = math.random(0,7)
	
	if CritMath == 5 then
	self.Weapon:SetNWBool("Critical",true)
	end

	ParticleEffectAttach( self.MuzzleEffect, PATTACH_POINT_FOLLOW, self, 1)			
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pstl_fire"))

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(31.5, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(14, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end
	-- Take 1 ammo in you clip
	
	self.Reloadaftershoot = CurTime() +  .2

	self.Idle = CurTime() + 0.05
	
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
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("pstl_draw"))
	self.Owner:GetViewModel():SetPlaybackRate(1)
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pstl_idle"))
self.Owner:GetViewModel():SetPlaybackRate(1)
end
if self.StopCrit and CurTime()>=self.StopCrit then
self.StopCrit = nil
self.Weapon:SetNWBool("Critical",false)
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
		self.Weapon:EmitSound("Weapon_Pistol.ClipEmpty",100,timescale*100)
		self.Reloadaftershoot = CurTime()
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
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

		self.TORight = 0.8
		self.TOForward = 0
		self.TOUp = -0.4

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
		StartPosPart:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Right()*self.TORight + self.Owner:EyeAngles():Up()*self.TOUp + self.Owner:EyeAngles():Forward()*self.TOForward)
		StartPosPart:SetParent(self.Owner)
		StartPosPart:Spawn()
		StartPosPart:Activate()
		StartPosPart:Fire("kill","",self.Primary.Delay)
		EndPosPart:Fire("kill","",self.Primary.Delay)

		umsg.Start("DoMuzzleEffect")
		umsg.Entity(self)
		umsg.String(self.MuzzleEffect)
		umsg.End()
		return end
end

	self:FireBullets(bullet)					-- Fire the bullets
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

end