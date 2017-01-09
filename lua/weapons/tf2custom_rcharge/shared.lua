if (SERVER) then
	AddCSLuaFile("shared.lua")
end

local RevolverLimit = { }
RevolverLimit[ "RPG_Round" ] = 60


SWEP.HoldType		= "smg"

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Rocket Charger"	
	SWEP.Slot 				= 0
	SWEP.SlotPos 			= 0
	SWEP.ViewModelFOV		= 70
	SWEP.Type =  "Rocket Launcher"
	SWEP.Stats =  "Hold the primary fire button to charge the rocket"
	SWEP.Stats2 = "+10% explosion damage"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Rocket is affected by gravity"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Remember to hold on."
end

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("rpg")
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


SWEP.Weight = 4

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model			= "models/workshop/weapons/c_models/c_atom_launcher/c_atom_launcher.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.Primary.Sound			= Sound( "weapons/rocket_shoot.wav" )
SWEP.Primary.CritSound		= Sound( "weapons/rocket_shoot_crit.wav" )
SWEP.Primary.Recoil 		= 0
SWEP.Primary.Damage 		= 0
SWEP.Primary.NumShots 		= 0
SWEP.Primary.Cone 			= 0
SWEP.Primary.ClipSize		= 4
SWEP.Primary.Delay		= 0.75
SWEP.Primary.DefaultClip	= 37
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "RPG_Round"
SWEP.MaxAmmo = 12

SWEP.Secondary.Ammo 			= "none"

SWEP.Penetration			= false
SWEP.MaxPenetration 		= 15
SWEP.MaxWoodPenetration 	= 18
SWEP.Ricochet			= true
SWEP.MaxRicochet			= 0

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

function SWEP:Firerocket()
self:Holster2()
self:EmitSound(self.Primary.Sound)
self:TakePrimaryAmmo(1)
self.PullBack = false
self.Charge1 = nil
self.Charge2 = nil
self.NextCharge = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_fire"))
if SERVER then
local rocket = ents.Create("tf2custom_proj_rocket")
local eAng = self.Owner:EyeAngles()
rocket:SetPos(self.Owner:GetShootPos() - eAng:Right()*1.5 - eAng:Up()*0.5)
rocket:SetOwner(self.Owner)
rocket:SetAngles(eAng)
rocket:Spawn()
if self.OverCharge == true then
rocket:SetVelocity(rocket:GetForward()*Lerp(self.Charge/100, 200, 2500) + rocket:GetRight()*math.random(-50,50) + rocket:GetUp()*math.random(-40,40))
else
rocket:SetVelocity(rocket:GetForward()*Lerp(self.Charge/100, 200, 3200))
end
rocket:SetGravity(Lerp(self.Charge/100, 1.1, 0.0655))
end
self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
self.CheckWepAmmo = CurTime() + self.Owner:GetViewModel():SequenceDuration() - 1.2
self.Charge = 0
end

function SWEP:Deploy()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_draw"))
self:AmmoCheck()
self.PullBack = false
self.Charge = 0
self.Charge1 = nil
self.Charge2 = nil
self.NextCharge = nil
self.Owner:GetViewModel():SetCycle(0)
self.Owner:GetViewModel():SetPlaybackRate(1)
self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
return true
end

function SWEP:AmmoCheck()
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
if self.Owner:KeyDown(IN_ATTACK) then return end
self:Holster2()
	if self.Reloading then
		self.Reloading = false
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
	end
	return true
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
self:Think2()
if self.Owner:KeyReleased(IN_ATTACK) and self.PullBack then self:Firerocket() end
if self.CheckWepAmmo and CurTime() >= self.CheckWepAmmo then
self.CheckWepAmmo = nil
if self:Ammo1() <= 0 then
if SERVER then
self.Owner:ConCommand("lastinv")
end
end
end
if self.NextCharge and CurTime() >= self.NextCharge then
self.NextCharge = CurTime() + 0.075
self.Charge = self.Charge + 5
if self.Charge > 100 then self.Charge = 100 end
end
if self.Charge1 and CurTime() >= self.Charge1 then
self.Charge1 = nil
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_idle"))
self.Charge2 = CurTime() + 2.7
end
if self.Charge2 and CurTime() >= self.Charge2 then
self:Firerocket()
end
if self.Idle and CurTime() >= self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_idle"))
end
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:DoInspect()
if self.Owner:KeyDown(IN_ATTACK) or self.Reloading then return end
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
if self.Owner:KeyDown(IN_ATTACK) or self.Reloading then return end
self.Inspectidle = nil
self.Inspecting = false
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectEndAnim))
self.Idle = CurTime() + vm:SequenceDuration()
end
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
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
	if self.Weapon:Clip1() <= 0 then
		self:Reload()
		return
	end

	if ( !self:CanPrimaryAttack() ) then return end

	if self.Reloading then
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
		self.Reloading = false
	end

	if not self.PullBack then
	self.PullBack = true
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_idle"))
	self.Charge = 0
	self.Charge1 = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Charge2 = nil
	self.Idle = nil
	self.NextCharge = CurTime() + 0.075
	self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self:EmitSound("weapons/stickybomblauncher_charge_up.wav")
	end
	
end

function SWEP:Reload()
if self.Owner:KeyDown(IN_ATTACK) and self.Weapon:Clip1() > 0 then return end
	if SERVER then
		if self.Reloading || self.Owner:GetAmmoCount( "RPG_Round" ) == 0 then return end
		if self.Weapon:Clip1() < 4 then
			self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_reload_start"))
			self.Reloading = true
			timer.Create( "Reload_" .. self.Weapon:EntIndex(), 0.75, 9- self.Weapon:Clip1(),function() self:PerformReload() end)
		end
	end
end

function SWEP:PerformReload()

	if !self.Reloading then 
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
		return
	end
	local Ammo = self.Weapon:Clip1( )
	
	if Ammo >= 4 or self.Owner:GetAmmoCount( "RPG_Round" ) == 0 then
		self.Reloading = false
		timer.Destroy( "Reload_" .. self.Weapon:EntIndex() )
		self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("dh_reload_finish"))
	else
		self.Reloading = true
		self:SendWeaponAnim(self.Owner:GetViewModel():GetSequenceActivity(self.Owner:GetViewModel():LookupSequence("dh_reload_loop")))
		if self.Owner:GetAmmoCount( "RPG_Round" ) <= 0 then return end
		self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
		self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
		self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	end
end


function SWEP:SecondaryAttack()
end

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

		self.TORight = 5
		self.TOUp = -1

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
		StartPosPart:SetPos( self.Owner:GetShootPos() + self.Owner:EyeAngles():Right()*self.TORight + self.Owner:EyeAngles():Up()*self.TOUp)
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