function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_revolver/c_revolver.mdl")
local vm = self.Owner:GetViewModel( 0 )
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

function SWEP:ViewModelDrawn()
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then self.CModel:DrawModel() end
end
end

local RevolverLimit = { }
RevolverLimit[ "357" ] = 486

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Akimbo Revolvers"
	SWEP.HoldType 			= "dual"
	SWEP.Slot				= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Revolver"
	SWEP.Stats =  "+81% Ammo reserve"
	SWEP.Stats2 = "Secondary Fire: Shoot with second revolver"
	SWEP.Stats3 = "Can shoot with both revolvers at the same time"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Can't cloak when holded"
	SWEP.Stats11 = "Can't switch to when cloaked"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Let's show who's is the best here."
end

SWEP.MuzzleEffect			= "muzzle_revolver"
SWEP.MuzzleEffect1			= "muzzle_revolver"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"
SWEP.MuzzleAttachment1		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false
SWEP.ViewModelFlip1		= true

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.ViewModel1 		= "models/weapons/v_models/v_revolver_spy.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_revolver/c_revolver.mdl"

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.IsCModel			= true

SWEP.Primary.Sound			= Sound( "weapons/revolver_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/revolver_shoot_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.696
SWEP.Primary.DefaultClip	= 486
SWEP.Primary.Maxammo 		= 36
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "357"

SWEP.Secondary.Ammo			= "357"
SWEP.Secondary.ClipSize		= 6
SWEP.Secondary.DefaultClip	= 54
SWEP.Secondary.Delay			= 0.696
SWEP.Secondary.Automatic		= true

SWEP.Penetration			= true
SWEP.PrimMaxPenetration 	= 12
SWEP.PrimMaxWoodPenetration = 14
SWEP.Ricochet			= false
SWEP.MaxRicochet			= 0

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("dual")
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
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
self:Holster2()
if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	if not self:CanSecondaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	local CritMath = math.random(0,15)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	self.StopCrit = CurTime() + 0.6
	end
	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fire"))

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100,1,1)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100,1,1)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end

	self:TakeSecondaryAmmo(1)
	-- Take 1 ammo in you clip
	
	self.Weapon.Primary.Cone = 0.018

	self.SpreadRecovery = CurTime() + 0.95
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end

	if not self:CanPrimaryAttack() then return end
	self:Holster2()
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
	local CritMath = math.random(0,15)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	self.StopCrit = CurTime() + 0.6
	end
	self:SendViewModelAnim( ACT_VM_PRIMARYATTACK , 1 )

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local timescale = GetConVarNumber("host_timescale")
	if self.Weapon:GetNWBool("Critical") then
	self.Weapon:EmitSound(self.Primary.CritSound,100,timescale*100,1,-1)
	else
	self.Weapon:EmitSound(self.Primary.Sound,100,timescale*100,1,-1)
	end

	if self.Weapon:GetNWBool("Critical") then
	self:CSShootBullet1(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	else
	self:CSShootBullet1(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone)
	end

	self:TakePrimaryAmmo(1)
	-- Take 1 ammo in you clip
	
	self.Weapon.Primary.Cone = 0.018

	self.SpreadRecovery = CurTime() + 0.95
	self.Idle1 = CurTime() + self.Owner:GetViewModel( 1 ):SequenceDuration()
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	local viewmodel1 = self.Owner:GetViewModel( 1 )
	viewmodel1:SetWeaponModel( self.ViewModel1 , self )
	viewmodel1:ResetSequence(viewmodel1:LookupSequence("draw"))
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
	if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
	self:Holster2()
	local viewmodel1 = self.Owner:GetViewModel( 1 )
	if ( IsValid( viewmodel1 ) ) then
	viewmodel1:SetWeaponModel( self.ViewModel1 , nil )
	end
return true
end

function SWEP:SendViewModelAnim( act , index , rate )

	if ( not game.SinglePlayer() and not IsFirstTimePredicted() ) then
		return
	end

	local vm = self.Owner:GetViewModel( index )

	if ( not IsValid( vm ) ) then
		return
	end

	local seq = vm:SelectWeightedSequence( act )

	if ( seq == -1 ) then
		return
	end

	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate or 1 )
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
if ( self.Reloadaftershoot > CurTime() ) then return end 

	if ( self:Ammo1() <= 0 ) then return end

	if ( self.Weapon:Clip1() == 0 ) and ( self.Weapon:Clip2() == 0 ) then
	self:Holster2()
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self:SetInspectsight( true )
	timer.Simple(.6, function()
	self.Weapon:DefaultReload(self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("reload")))
	timer.Simple(.9, function()
	self:SetInspectsight( false )
end)
end)
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
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("idle"))
end
if self.Idle1 and CurTime()>=self.Idle1 then
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
self.Idle1 = nil
self:SendViewModelAnim( ACT_VM_IDLE , 1 )
end
if !self.Owner:KeyDown(IN_ATTACK) and self.SpreadRecovery and CurTime()>=self.SpreadRecovery then
self.SpreadRecovery = nil
self.Weapon.Primary.Cone = 0.005
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

function SWEP:DoInspect()
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
wep.Idle = nil
wep.Inspecting = true
wep.Inspecting2 = true
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(wep.InspectStartAnim))
wep.Inspectidle = CurTime() + vm:SequenceDuration()
end
end

function SWEP:DoEndInspect()
if self.Weapon:GetNetworkedBool( "Inspecting", b ) then return end
wep.Inspectidle = nil
wep.Inspecting = false
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(wep.InspectEndAnim))
wep.Idle = CurTime() + vm:SequenceDuration()
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

function SWEP:CanSecondaryAttack()

	if ( self.Weapon:Clip2() <= 0 ) and self.Secondary.ClipSize > -1 then
		local timescale = GetConVarNumber("host_timescale")
		self.Weapon:EmitSound("Weapon_Revolver.ClipEmpty",100,timescale*100)
		self.Reloadaftershoot = CurTime()
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.6)
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

function SWEP:CSShootBullet1(dmg, recoil, numbul, cone)
	
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
		umsg.Entity(self.Owner:GetViewModel( 1 ))
		umsg.String(self.MuzzleEffect1)
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

function SWEP:OnDrop()
end