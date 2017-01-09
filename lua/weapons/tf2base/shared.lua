
function StopModelOverlay(pl)
pl:GetViewModel():SetMaterial( "" )
end
hook.Add("PlayerSpawn", "StopModelOverlay", StopModelOverlay)

hook.Add("KeyPress", "DoubleJump", function(pl, k)
if !pl:GetNWBool("IsScout") then return end
	if not pl or not pl:IsValid() or k~=2 then
		return
	end
		
	if not pl.Jumps or pl:IsOnGround() then
		pl.Jumps=0
	end
	
	if pl.Jumps==2 then return end
	
	pl.Jumps = pl.Jumps + 1
	if pl.Jumps==2 then
		local ang = pl:GetAngles()
		local forward, right = ang:Forward(), ang:Right()
		
		local vel = -1 * pl:GetVelocity() -- Nullify current velocity
		vel = vel + Vector(0, 0, 220) -- Add vertical force
		
		local spd = pl:GetMaxSpeed()
		
		if pl:KeyDown(IN_FORWARD) then
			vel = vel + forward * spd
		elseif pl:KeyDown(IN_BACK) then
			vel = vel - forward * spd
		end
		
		if pl:KeyDown(IN_MOVERIGHT) then
			vel = vel + right * spd
		elseif pl:KeyDown(IN_MOVELEFT) then
			vel = vel - right * spd
		end
		
		pl:SetVelocity(vel)
	end
end)

function JumpsReset( pl, bInWater, bOnFloater, flFallSpeed )
pl.Jumps = 1
end
hook.Add("OnPlayerHitGround", "JumpsReset", JumpsReset)

function Tf2Ammo(ply, wep)
   if wep:GetClass() == "weapon_pistol" then return true end
   if wep:GetClass() == "weapon_ar2" and (ply:HasWeapon("tf2_pistol_scout") or ply:HasWeapon("sp_tf2_pistol_scout")) then ply:GiveAmmo(24,"pistol") return true end
   if wep:GetClass() == "weapon_smg1" and (ply:HasWeapon("tf2_pistol_scout") or ply:HasWeapon("sp_tf2_pistol_scout")) then ply:GiveAmmo(24,"pistol") return true end
   if wep:GetClass() == "weapon_shotgun" and (ply:HasWeapon("tf2_scattergun") or ply:HasWeapon("sp_tf2_scattergun")) then ply:GiveAmmo(6,"buckshot") return true end
   return true
end
hook.Add("PlayerCanPickupWeapon", "Tf2Ammo", Tf2Ammo)

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight 		= 5
	SWEP.HoldType		= "ar2"		-- Hold type style ("ar2" "pistol" "shotgun" "rpg" "normal" "melee" "grenade" "smg")
end

if (CLIENT) then
	SWEP.DrawAmmo		= true
	SWEP.DrawCrosshair	= false
	SWEP.ViewModelFOV		= 55
	SWEP.ViewModelFlip	= true
	SWEP.CSMuzzleFlashes	= false
end

SWEP.ViewModel			= "models/weapons/v_models/v_scattergun_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_scattergun.mdl"

SWEP.MuzzleEffect			= "muzzle_shotgun"
SWEP.TracerEffect = "bullet_shotgun_tracer01_red"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Category			= "Team Fortress 2"

SWEP.DrawWeaponInfoBox  	= false
SWEP.BounceWeaponIcon		= false

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false

SWEP.Weight 			= 5
SWEP.AutoSwitchTo 		= false
SWEP.AutoSwitchFrom 		= false

SWEP.Primary.Sound 		= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil 		= 0
SWEP.Primary.Damage 		= 0
SWEP.Primary.NumShots 		= 0
SWEP.Primary.Cone 		= 0
SWEP.Primary.ClipSize 		= 0
SWEP.Primary.Delay 		= 0						-- Example: If your weapon shoot 800 bullets per minute, this is what you need to do: 1 / (800 / 60) = 0.075
SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "none"

SWEP.Secondary.ClipSize 	= 0
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.data 				= {}
SWEP.mode 				= "auto"
SWEP.data.ironsights		= 0

SWEP.MuzzleEffect			= "muzzle_shotgun"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

/*---------------------------------------------------------
IronSight
---------------------------------------------------------*/
function SWEP:IronSight()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
end

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function SWEP:Initialize()

	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType) 	-- Hold type of the 3rd person animation
	end
	
	PrecacheParticleSystem( self.MuzzleEffect )
	PrecacheParticleSystem( self.TracerEffect )
	PrecacheParticleSystem( self.TracerCritEffect )
	self.Reloadaftershoot = CurTime()
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
end

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) and self.Primary.ClipSize > -1 then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
		return false
	end
	return true
end

function SWEP:GetViewModelPosition(pos, ang)
end

/*---------------------------------------------------------
RecoilPower
---------------------------------------------------------*/
function SWEP:RecoilPower()
end

/*
MUZZLE FLASHES
"muzzle_pistol" - Scout/Engineer pistol muzzle flash
"muzzle_bignasty" - Force-a-Nature muzzle
"muzzle_minigun" - Sascha/Natascha muzzle flash
"muzzle_revolver" - Revolver muzzle
"muzzle_sniperrifle" - Sniper rifle muzzle
"muzzle_shotgun" - Shotgun muzzle flash

TRACER EFFECTS
"bullet_tracer01_blue" - Standard blue tracer
"bullet_tracer01_blue_crit" - Standard blue crit tracer
"bullet_tracer01_red" - Standard red tracer
"bullet_tracer01_red_crit" - Standard red crit tracer
"bullet_bignasty_tracer01_blue" - FaN blue tracer
"bullet_bignasty_tracer01_red" -  FaN red tracer
"bullet_bignasty_tracer01_blue_crit" -  FaN blue tracer
"bullet_bignasty_tracer01_red_crit" -  FaN red crit tracer
"bullet_shotgun_tracer01_blue" - Standard blue shotgun tracer
"bullet_shotgun_tracer01_red" - Standard red shotgun tracer
"bullet_shotgun_tracer01_blue_crit" - Standard blue crit shotgun tracer
"bullet_shotgun_tracer01_red_crit" - Standard red crit shotgun tracer
*/

function DoBulletTracer(msg)
local weapon = msg:ReadEntity()
local endpos = msg:ReadVector()
local effect = msg:ReadString()
--DoBulletTracer2(weapon, endpos, effect)
end
 
usermessage.Hook("DoBulletTracer",DoBulletTracer)

function DoMuzzleEffect(msg)
local weaponz = msg:ReadEntity()
local effectz = msg:ReadString()
DoMuzzleEffect2(weaponz, effectz)
end

usermessage.Hook("DoMuzzleEffect", DoMuzzleEffect)

function DoMuzzleEffect2(weaponz, effectz)
local trakmuz
if weaponz.Owner==LocalPlayer() then
if weaponz.CModel then trakmuz=weaponz.CModel
else trakmuz=LocalPlayer():GetViewModel() end
else
trakmuz=weaponz
end
if !weaponz:IsValid() then return end
local idmuz = trakmuz:LookupAttachment("muzzle")
local attmuz = trakmuz:GetAttachment(idmuz)
ParticleEffectAttach( effectz, PATTACH_POINT_FOLLOW, trakmuz, idmuz)
end

function DoBonkMuzzleEffect(msg)
local weaponz = msg:ReadEntity()
local effectz = msg:ReadString()
DoBonkMuzzleEffect2(weaponz, effectz)
end

usermessage.Hook("DoBonkMuzzleEffect", DoBonkMuzzleEffect)

function DoBonkMuzzleEffect2(weaponz, effectz)
local trakmuz
if weaponz.Owner==LocalPlayer() then
if weaponz.CModel then trakmuz=weaponz.CModel
else trakmuz=LocalPlayer():GetViewModel() end
else
trakmuz=weaponz
end
if !weaponz:IsValid() then return end
local idmuz = trakmuz:LookupAttachment("drink_spray")
local attmuz = trakmuz:GetAttachment(idmuz)
ParticleEffectAttach( effectz, PATTACH_POINT_FOLLOW, trakmuz, idmuz)
end

function DoBulletTracer2(weapon, endpos, effect)
local trak
if weapon.Owner==LocalPlayer() then
if weapon.CModel then trak=weapon.CModel
else trak=LocalPlayer():GetViewModel() end
else
trak=weapon
end
if !weapon:IsValid() then return end
local id = trak:LookupAttachment("muzzle")
local attz = trak:GetAttachment(id)
util.ParticleTracerEx(effect, attz.Pos, endpos, true, trak:EntIndex(), id)
end

/*---------------------------------------------------------
ShootBullet
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
		
		local FireMath = math.random(0,6)
		if a:GetActiveWeapon():GetNWBool("FireUpgrade") and FireMath == 3 and a:WaterLevel() <= 2 then
			local effectdata = EffectData()
			effectdata:SetOrigin(b.HitPos)
			effectdata:SetNormal(b.HitNormal)
			effectdata:SetScale(20)
			util.Effect("tf2_fireupgrade_effect", effectdata)
			util.Decal("FadingScorch", b.HitPos + b.HitNormal, b.HitPos - b.HitNormal)
			if b.Entity:IsNPC() and b.Entity:WaterLevel() <= 2 then
			if (SERVER) then
			b.Entity:Ignite(8)
			end
			end
		end
	
		local vm = self.Owner:GetViewModel()
		local attach = vm:GetAttachment(vm:LookupAttachment("muzzle"))
		local worldattach = self:GetAttachment(self:LookupAttachment("muzzle"))
		
		ParticleEffectAttach( self.MuzzleEffect, PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), self.Owner:GetViewModel():LookupAttachment(self.MuzzleAttachment))
		
		if (SERVER) and self.Weapon.IsCModel == nil and (SinglePlayer) then
		local StartPosPart = ents.Create("info_particle_system")
		local EndPosPart = ents.Create("info_particle_system")
		EndPosPart:SetPos(b.HitPos)
		EndPosPart:Spawn()
		EndPosPart:Activate()
		EndPosPart:SetName( "tracer_entity" .. math.random(0, 9001) )
		if self.Weapon:GetNWBool("Critical") then
		StartPosPart:SetKeyValue( "effect_name", self.TracerCritEffect )
		else
		StartPosPart:SetKeyValue( "effect_name", self.TracerEffect )
		end
		StartPosPart:SetKeyValue( "cpoint1", EndPosPart:GetName() )
		StartPosPart:SetKeyValue( "start_active", "1" )
		if (self.Owner) then
		StartPosPart:SetPos( attach.Pos - vm:GetForward()*10 )
		else
		StartPosPart:SetPos( self.Owner:GetPos() + self.Owner:GetUp()*20 )
		end
		StartPosPart:SetParent(vm)
		StartPosPart:Spawn()
		StartPosPart:Activate()
		StartPosPart:Fire("kill","",0.3)
		EndPosPart:Fire("kill","",0.3)
		end
		
		if (SERVER) and self.CModel then
		umsg.Start("DoBulletTracer")
		umsg.Entity(self)
		umsg.Vector(b.HitPos)
		if self.Weapon:GetNWBool("Critical") then
		umsg.String(self.TracerCritEffect)
		else
		umsg.String(self.TracerEffect)
		end
		umsg.End()
		umsg.Start("DoMuzzleEffect")
		umsg.Entity(self)
		umsg.String(self.MuzzleEffect)
		umsg.End()
		end
		return end

	self:FireBullets(bullet)					-- Fire the bullets
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

end

/*---------------------------------------------------------
   Name: SWEP:BulletPenetrate()
---------------------------------------------------------*/
function SWEP:BulletPenetrate(bouncenum, attacker, tr, dmginfo, isplayer)

	local DoDefaultEffect = true
	// Don't go through metal, sand or player
	if (tr.MatType == MAT_SAND) or (tr.Entity:IsPlayer()) then return end

	// Don't go through more than 3 times
	if (bouncenum > 3) then return end
	
	// Direction (and length) that we are gonna penetrate
	local PenetrationDirection = tr.Normal * self.PrimMaxPenetration
	
	if (tr.MatType == MAT_DIRT or tr.MatType == MAT_WOOD or tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_GLASS or tr.MatType == MAT_PLASTIC or tr.MatType == MAT_VENT or tr.MatType == MAT_COMPUTER) then
		PenetrationDirection = tr.Normal * self.PrimMaxWoodPenetration
	end
		
	local trace 	= {}
	trace.endpos 	= tr.HitPos
	trace.start 	= tr.HitPos + PenetrationDirection
	trace.mask 		= MASK_SHOT
	trace.filter 	= {self.Owner}
	   
	local trace 	= util.TraceLine(trace) 
	
	// Bullet didn't penetrate.
	if (trace.StartSolid or trace.Fraction >= 1.0 or tr.Fraction <= 0.0) then return end
	
	// Damage multiplier depending on surface
	local fDamageMulti = 0.5
	
	if (tr.MatType == MAT_CONCRETE) then
		fDamageMulti = 0.7
		elseif (tr.MatType == MAT_METAL) then
		fDamageMulti = 0.72;
	elseif (tr.MatType == MAT_WOOD) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH) then
		fDamageMulti = 0.9;
	elseif (tr.MatType == MAT_GLASS) then
		fDamageMulti = 0.75;
	elseif (tr.MatType == MAT_GRATE) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_PLASTIC) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_VENT) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_ANTLION) then
		fDamageMulti = 0.6;
	elseif (tr.MatType == MAT_DIRT) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_SAND) then
		fDamageMulti = 0.4;
	elseif (tr.MatType == MAT_FOLIAGE) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_COMPUTER) then
		fDamageMulti = 0.8;
	elseif (tr.MatType == MAT_SLOSH) then
		fDamageMulti = 0.7;
	elseif (tr.MatType == MAT_TILE) then
		fDamageMulti = 0.75;
	end
		
	// Fire bullet from the exit point using the original trajectory
	local bullet = 
	{	
		Num 		= 1,
		Src 		= trace.HitPos,
		Dir 		= tr.Normal,	
		Spread 	= Vector(0, 0, 0),
		Tracer	= 0,
		TracerName 	= "",
		Force		= 5,
		Damage	= (dmginfo:GetDamage() * fDamageMulti),
		HullSize	= 2
	}
	
	bullet.Callback    = function(a, b, c) if (self.Ricochet) then return self:RicochetCallback(bouncenum + 1, a, b, c) end end
		
	timer.Simple(0.01, attacker.FireBullets, attacker, bullet, true)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:RicochetCallback()
---------------------------------------------------------*/
function SWEP:RicochetCallback(bouncenum, attacker, tr, dmginfo)

	local DoDefaultEffect = true
	if (tr.HitSky) then return end
	
	// Can we go through whatever we hit?
	if (self.Penetration) and (self:BulletPenetrate(bouncenum, attacker, tr, dmginfo)) then
		return {damage = true, effects = DoDefaultEffect}
	end
	
	if (tr.MatType != MAT_METAL) then
		if (SERVER) then
			util.ScreenShake(tr.HitPos, 5, 0.1, 0.5, 30)
			
		end

		return 
	end

	if (self.Ricochet == false) then return {damage = true, effects = DoDefaultEffect} end
	
	if (bouncenum > self.MaxRicochet) then return end
	
	// Bounce vector
	local trace = {}
	trace.start = tr.HitPos
	trace.endpos = trace.start + (tr.HitNormal * 16384)

	local trace = util.TraceLine(trace)

 	local DotProduct = tr.HitNormal:Dot(tr.Normal * -1) 
	
	local bullet = 
	{	
		Num 		= 1,
		Src 		= tr.HitPos + (tr.HitNormal * 5),
		Dir 		= ((2 * tr.HitNormal * DotProduct) + tr.Normal) + (VectorRand() * 0),
		Spread 	= Vector(0, 0, 0),
		Tracer	= 0,
		TracerName 	= "",
		Force		= dmginfo:GetDamage() * 0.7,
		Damage	= dmginfo:GetDamage() * 0.85,
		HullSize	= 2
	}
		
	// Added conditional to stop errors when bullets ricochet after weapon switch
	bullet.Callback  	= function(a, b, c) if (self.Ricochet) then return self:RicochetCallback(bouncenum + 1, a, b, c) end end
	
	timer.Simple(0.01, attacker.FireBullets, attacker, bullet, true)
	
	return {damage = true, effects = DoDefaultEffect}
end

/*---------------------------------------------------------
   Name: SWEP:RicochetCallback_Redirect()
---------------------------------------------------------*/
function SWEP:RicochetCallback_Redirect(a, b, c)
 
	return self:RicochetCallback(0, a, b, c) 
end

function DRFootsteps( p, vPos, iFoot, strSoundName, fVolume, pFilter )
if p:Alive() and p:IsValid() and p:GetNWBool("Cloak") then
if CLIENT then
return true
end
end
end
hook.Add("PlayerFootstep","DeadRingerFootsteps",DRFootsteps)

function EqualizerSpeed()
for k,v in pairs (player.GetAll()) do
if v:HasWeapon("Equalizer") and v:Health() <= 90 then
v:SetWalkSpeed(265)
v:SetRunSpeed(265)
end
if v:HasWeapon("Equalizer") and v:Health() >= 91 then
v:SetWalkSpeed(205)
v:SetRunSpeed(205)
end
end
end

if (CLIENT) then
hook.Add("HUDPaint", "Jarated",function()
 if LocalPlayer():GetNWBool("Pissed") then 
 local QuadTable = {} 
 
 QuadTable.texture = surface.GetTextureID( "Effects/jarate_overlay" )
 QuadTable.color = Color( 255,255,255,255 )
 QuadTable:SetMaterialFloat("$refractamount", 0.05)
 
 QuadTable.x = 0 
 QuadTable.y = 0 
 QuadTable.w = ScrW() 
 QuadTable.h = ScrH()
 draw.TexturedQuad( QuadTable )
end
end)
end