function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_wooden_bat/c_wooden_bat.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
self.DModel = ClientsideModel("models/weapons/v_models/v_baseball.mdl")
self.DModel:SetPos(vm:GetPos())
self.DModel:SetAngles(vm:GetAngles())
self.DModel:AddEffects(EF_BONEMERGE)
self.DModel:SetNoDraw(true)
self.DModel:SetParent(vm)
end
end

function SWEP:ViewModelDrawn()
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then self.CModel:DrawModel() end
if not self.DModel then self:makemahcmodel() end
if self.DModel then self.DModel:DrawModel() end
end
end

function SWEP:Melee()

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
			bullet.Force  = 1
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 90
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = math.random(29,35)
			end
			if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:EmitSound("Weapon_Shovel.HitFlesh")
			else
			self.Weapon:EmitSound("Weapon_Shovel.HitWorld")
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
	SWEP.PrintName			= "Ball-Bat"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Stats =  "Infinite ammo reserve"
	SWEP.Stats2 = "Primary fire: Throws a ball that hurts enemies"
	SWEP.Stats3 = "Balls don't stuns enemies"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats =  "Infinite ammo reserve"
	SWEP.Stats2 = "Primary fire: Throws a ball that hurts enemies"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Balls do not stun"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Ya miss the ball? Take it!"
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_wooden_bat/c_wooden_bat.mdl"

SWEP.Primary.Delay			= 0.55
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (0,0,0)
SWEP.IronSightsAng = Vector (0,0,0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("melee")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 1 - hand.Ang:Up() * 3

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 7)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

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
local CritMath
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end

	CritMath = math.random(0,22)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wb_fire"))
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Reloadaftershoot = CurTime() + 0.1

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound("weapons/bat_baseball_hit" .. math.random(1,2) .. ".wav")
	self:Shoot()
	timer.Simple( .3,function()
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wb_grab"))
	self.Idle = CurTime() + .5
	end)
end
		
function SWEP:Shoot()
    if SERVER then
       
        local grenade = ents.Create("tf2custom_proj_batball")
        grenade:SetPos(self:ProjectileShootPos())
        grenade:SetAngles(self.Owner:EyeAngles())
        grenade:SetOwner(self.Owner)
        
        grenade:Spawn()
        
		if not IsValid(grenade) then return end
        
	local vel = self.Owner:GetAimVector() * 4000
        
		local phys = grenade:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			phys:ApplyForceCenter(vel)
		end

        end
        
    end

SWEP.ProjectileShootOffset = Vector(52.6, 13, -6)

function SWEP:ProjectileShootPos()
    local pos, ang = self.Owner:GetShootPos(), self.Owner:EyeAngles()
    return pos +
        self.ProjectileShootOffset.x * ang:Forward() +
        self.ProjectileShootOffset.y * ang:Right() +
        self.ProjectileShootOffset.z * ang:Up()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wb_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster()
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
	if CLIENT then
	if self.Owner:KeyPressed(IN_USE) then
	self:EmitSound("weapons/draw_secondary.wav")
	end
	end
if SERVER then
if self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then self.Inspecting = false  self.Caninspect = false end
if self.Owner:KeyDown(IN_USE) then
self.Inspecting = true
end
if self.Owner:KeyPressed(IN_USE) then
	self.Inspecting = true
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_inspect_start"))
	--self.Weapon:SetNextPrimaryFire(CurTime() + 213534566546)
	--self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Idle = CurTime() + 23133245636456436456
	end
	
if self.Owner:KeyReleased(IN_USE) and self.Inspecting == true then 
	if self.Inspecting == false then return end
	if self.CanInspect == false then return end
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_inspect_end"))
	--self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
	end
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
if self.Idle and CurTime()>=self.Idle then
self.Owner:GetViewModel():SetPlaybackRate(1.4)
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("wb_idle"))
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end