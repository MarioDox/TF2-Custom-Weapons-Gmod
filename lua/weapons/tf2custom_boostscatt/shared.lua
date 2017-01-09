local RevolverLimit = { }
RevolverLimit[ "buckshot" ] = 22

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Booster Shoot"
	SWEP.HoldType = "revolver"
	SWEP.Slot				= 0
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Scattergun"
	SWEP.Stats =  "No need to reload"
	SWEP.Stats2 = "+18% clip size"
	SWEP.Stats3 = "+10% damage done"
	SWEP.Stats4 = "+100 speed"
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Being able to crouch only when in mid-air"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Get faster my boy!"
end

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.Model = "models/workshop/weapons/c_models/c_scatterdrum/c_scatterdrum.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel = SWEP.Model

SWEP.Primary.Sound			= Sound( "weapons/tf2_back_scatter.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/tf2_back_scatter_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 10
SWEP.Primary.Cone			= .09
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.696
SWEP.Primary.DefaultClip	= 22
SWEP.Primary.Maxammo 		= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"

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

self:SetWeaponHoldType("shotgun")
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
if self:Ammo1() <= 0 then return end
self:Holster2()
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire

	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("sg_fire"))

	local CritMath = math.random(0,15)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	end
	
	
	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

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
	-- Take 1 ammo in you clip

	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("sg_draw"))
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
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("sg_idle"))
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
		self.Weapon:EmitSound("Weapon_Revolver.ClipEmpty",100,timescale*100)
		self.Reloadaftershoot = CurTime()
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
		self:Reload()
		return false
	end
	return true
end

function SWEP:DrawHUD()
	surface.SetTexture(surface.GetTextureID("sprites/tf_crosshair_03"))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( ScrW()/2 - 26, ScrH()/2 - 25, 50, 50 )
	end
	
function SWEP:Equip()
self.Owner:SetRunSpeed(500)
self.Owner:SetWalkSpeed(500)
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