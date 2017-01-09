function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_ubersaw/c_ubersaw.mdl")
local vm = self.Owner:GetViewModel()
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
if self.CModel then
self.CModel:DrawModel()
local vm = self.Owner:GetViewModel()
if self:GetNWFloat("Blood") == 0 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,0) )
elseif self:GetNWFloat("Blood") == 20 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-1) )
elseif self:GetNWFloat("Blood") == 40 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-2) )
elseif self:GetNWFloat("Blood") == 60 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-3) )
elseif self:GetNWFloat("Blood") == 80 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-4) )
elseif self:GetNWFloat("Blood") == 100 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-5) )
elseif self:GetNWFloat("Blood") == 120 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-6) )
elseif self:GetNWFloat("Blood") == 140 then
self.CModel:ManipulateBonePosition(self.CModel:LookupBone("charge_level"), Vector(0,0,-6.95) )
end
end
end
end


function SWEP:Melee(ent)

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 80 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	if ( trace.Hit ) then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 48
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 146.25
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 48.75
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:IsRagdoll() then
			self.Weapon:EmitSound("Weapon_UberSaw.HitFlesh")
			if self:GetNWFloat("Blood") < 140 then
			self:SetNWFloat("Blood",self:GetNWFloat("Blood") + 20)
			end
			else
			self.Weapon:EmitSound("Weapon_BoneSaw.HitWorld")
			end
			self.Owner:FireBullets(bullet) 
	end
			self.Weapon:SetNWBool("Critical", false)
end

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Healthy Saw"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Saw"
	SWEP.Stats =  "On Hit: Steal health"
	SWEP.Stats2 = "Alt-Fire: Inject the stolen health"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-25% Attack penality"
	SWEP.Stats11 = "No random critical hits"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Who told you that this is a female's work?"
end

SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/workshop/player/items/all_class/zoomin_broom/zoomin_broom_pyro.mdl", bone = "weapon_bone", rel = "", pos = Vector(-0.647, -20.497, 1.6), angle = Angle(-9.429, -87.142, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["gun"] = { type = "Model", model = "models/workshop/player/items/all_class/zoomin_broom/zoomin_broom_pyro.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.036, 1.883, -13.622), angle = Angle(78.16, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "melee_inspect_start"
SWEP.InspectIdleAnim = "melee_inspect_idle"
SWEP.InspectEndAnim = "melee_inspect_end"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_medic_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl"

SWEP.Primary.Delay			= 0.8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(-11.881, -50, -20)
SWEP.IronSightsAng = Vector(0,0,0)

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
if self.Injecting then return end
self:Holster2()
if self:GetNWFloat("Blood") > 0 then
self:SetIronsights(true)
self:EmitSound("weapons/blade_hit4.wav")
self.Injecting = true
self.Owner:Freeze(true)
local blood = (self:GetNWFloat("Blood") / 10)
timer.Create("tf2custom_healthsaw_inject"..self.Owner:EntIndex(),.6,blood,function()
self:EmitSound("weapons/syringegun_reload_air"..math.random(1,2)..".wav")
self.Owner:SetHealth(self.Owner:Health() + 10)
end)
timer.Create("tf2custom_healthsaw_end"..self.Owner:EntIndex(),blood * .6,1,function()
self:SetIronsights(false)
self:Deploy()
self.Injecting = false
self:SetNWFloat("Blood",0)
self.Owner:Freeze(false)
end)
end
end

hook.Add("PostPlayerDeath","TF2C_Healthsaw",function(ply)
if timer.Exists("tf2custom_healthsaw_inject"..ply:EntIndex()) then timer.Remove("tf2custom_healthsaw_inject"..ply:EntIndex()) end
if timer.Exists("tf2custom_healthsaw_end"..ply:EntIndex()) then timer.Remove("tf2custom_healthsaw_end"..ply:EntIndex()) end
end)

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
if self.Injecting then return end
self:Holster2()
	local vm = self.Owner:GetViewModel()
	if self.Weapon:GetNWBool("Critical") then
	vm:SendViewModelMatchingSequence(vm:LookupSequence("bs_swing_c"))
	self.Weapon:EmitSound("Weapon_FireAxe.MissCrit")
	else
	swing = { "bs_swing_a","bs_swing_b" }
	vm:SendViewModelMatchingSequence(vm:LookupSequence(table.Random( swing )))
	self.Weapon:EmitSound("Weapon_FireAxe.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + 0.9

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bs_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
if self.Injecting then return false end
self:Holster2()
self.DoMelee = nil
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
self:Think2()
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bs_idle"))
end
if self.InspectEnd and CurTime()>=self.InspectEnd then
self.Inspecting = false
self.InspectEnd = nil
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end


function SWEP:DoInspect()
if self.Injecting then return end
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
if self.Injecting then return end
self.Inspectidle = nil
self.Inspecting = false
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectEndAnim))
self.Idle = CurTime() + vm:SequenceDuration()
end
end


local IRONSIGHT_TIME = .1

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
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
	SetIronsights
---------------------------------------------------------*/
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end


SWEP.NextSecondaryAttack = 0

/*---------------------------------------------------------
	onRestore
	Loaded a saved game (or changelevel)
---------------------------------------------------------*/
function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

SWEP.Primary.Cone = 0.02
