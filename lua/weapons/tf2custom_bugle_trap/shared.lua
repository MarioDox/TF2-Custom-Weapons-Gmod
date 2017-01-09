if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

local RevolverLimit = { }
RevolverLimit[ "Xbowbolt" ] = 10

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Bugle trap"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Trumpet"
	SWEP.Stats =  "Primary Fire: Shoots a bullet then reloads"
	SWEP.Stats2 = "-100% weapon spread"
	SWEP.Stats3 = "+10% Ammo reserve"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "+5% Fire delay"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "You're so damn powerful that you can fire a bullet using your mouth."
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/weapons/c_models/c_bugle/c_bugle.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Primary.Sound = Sound("weapons/sniper_sydneysleeper_shoot.wav")
SWEP.Primary.CritSound = Sound("weapons/sniper_sydneysleeper_shoot_crit.wav")
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip 	= 10
SWEP.Primary.Delay			= 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Xbowbolt"

SWEP.InspectStartAnim = "item1_inspect_start"
SWEP.InspectIdleAnim = "item1_inspect_idle"
SWEP.InspectEndAnim = "item1_inspect_end"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.MuzzleEffect			= "muzzle_grenadelauncher"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.InspectsightPos = Vector(0, 0, 0)
SWEP.InspectsightAng = Vector(-69.581, -70, -34.785)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("grenade")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1.8 - hand.Ang:Up() * 0.7

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 17)
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
if not self:CanPrimaryAttack() then return end
self:Holster2()

	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	local CritMath = math.random(0,11)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	end
	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bb_fire_blue"))
	self:EmitSound("weapons/buff_banner_horn_blue.wav",100,100,1,-1)
	
	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() + 5)
	self.Start = true
	self.End = CurTime() + self.Owner:GetViewModel():SequenceDuration() - 1
	self.End2 = CurTime() + self.Owner:GetViewModel():SequenceDuration() - 2
	
end


function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bb_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
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
self:Holster2()
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end
function SWEP:ReloadA()
if ( self:Ammo1() <= 0 ) then
self:Holster2()
self.Owner:ConCommand("lastinv")
self:Remove()
return end
self:EmitSound("weapons/sniper_railgun_bolt_back.wav")
self.End3 = CurTime() + .4
self.Idle2 = CurTime() + .7
self.Weapon:SetNextPrimaryFire(CurTime() + .8)
end


/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
self:Think2()
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bb_idle"))
end
if self.Idle2 and CurTime()>=self.Idle2 then
self.Idle2 = nil
self:Holster2()
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bb_draw"))
self.Idle = CurTime() + 1
self.Weapon:SetNextPrimaryFire(CurTime() + .4)
end
if self.End and CurTime()>=self.End then
self:Holster2()
self.End = nil
self:ReloadA()
self:SetInspectsight( true )
end
if self.End3 and CurTime()>=self.End3 then
self:Holster2()
self.End3 = nil
self:SetInspectsight( false )
self.Start = false
end
if self.End2 and CurTime()>=self.End2 then
self:Holster2()
self.End2 = nil
	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end
	self:TakePrimaryAmmo(1)
	self.Weapon:SetNWBool("Critical", false)
end
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:DoInspect()
if self.End or self.End2 or self.End3 or self.Idle2 or self.Start then return end
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
if self.End or self.End2 or self.End3 or self.Idle2 or self.Start then return end
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

local INSPECTSIGHT_TIME = .3

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.InspectsightPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Inspectsight" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - INSPECTSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - INSPECTSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / INSPECTSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.InspectsightPos
	
	if ( self.InspectsightAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.InspectsightAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.InspectsightAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.InspectsightAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end


/*---------------------------------------------------------
	SetInspectsight
---------------------------------------------------------*/
function SWEP:SetInspectsight( b )

	self.Weapon:SetNetworkedBool( "Inspectsight", b )
	self.Weapon:SetNetworkedBool( "Inspecting", b )

end