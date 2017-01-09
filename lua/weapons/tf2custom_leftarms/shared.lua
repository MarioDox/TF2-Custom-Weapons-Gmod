function SWEP:CModelDraw()
end

function SWEP:Melee(ent)

	self.DoMelee = nil
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 40 )
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
			bullet.Force  = 5
			if self.Weapon:GetNWBool("Critical") or self:EntityFaceBack(trace.Entity) then
			bullet.Damage = 97.5
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 32.5
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:IsRagdoll() then
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
	SWEP.PrintName			= "Left arms"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Pistol, knife and laser"
	SWEP.Stats =  "100% critical hits from behind"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No random critical hits"
	SWEP.Stats11 = "-50% damage penality"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "War has ended. Mercenaries' arms are on ground. Medic fixes them togheter, creating a monstrosity."
end

SWEP.VElements = {
	["gun2"] = { type = "Model", model = "models/weapons/c_models/c_knife/c_knife.mdl", bone = "weapon_bone", rel = "gun", pos = Vector(4.88, 1.021, 4.663), angle = Angle(-90, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun"] = { type = "Model", model = "models/weapons/c_models/c_pistol/c_pistol.mdl", bone = "weapon_bone", rel = "", pos = Vector(-0.382, -1.818, -1.902), angle = Angle(66.759, -110.541, 9.831), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun3"] = { type = "Model", model = "models/weapons/v_models/v_stickybomb_defender.mdl", bone = "weapon_bone", rel = "gun", pos = Vector(-7.101, 0.27, 3.904), angle = Angle(0, 0, 0), size = Vector(0.558, 0.558, 0.558), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.VElements2 = {
	["gun2"] = { type = "Model", model = "models/weapons/c_models/c_ava_roseknife/c_ava_roseknife.mdl", bone = "weapon_bone", rel = "gun", pos = Vector(4.88, 1.021, 4.663), angle = Angle(-90, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 3, bodygroup = {} },
	["gun"] = { type = "Model", model = "models/workshop/weapons/c_models/c_pep_pistol/c_pep_pistol.mdl", bone = "weapon_bone", rel = "", pos = Vector(-0.382, -1.818, -1.902), angle = Angle(66.759, -110.541, 9.831), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun3"] = { type = "Model", model = "models/weapons/v_models/v_stickybomb_defender.mdl", bone = "weapon_bone", rel = "gun", pos = Vector(-9.101, 0.27, 3.904), angle = Angle(0, 0, 0), size = Vector(0.558, 0.558, 0.558), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_medic_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ShowWorldModel = false

SWEP.InspectStartAnim = "melee_inspect_start"
SWEP.InspectIdleAnim = "melee_inspect_idle"
SWEP.InspectEndAnim = "melee_inspect_end"


SWEP.Primary.Delay			= .8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:EntsInSphereBack( pos, range )
	local ents = ents.FindInSphere(pos,range)
	for k, v in pairs(ents) do
		if v != self and v != self.Owner and (v:IsNPC() or v:IsPlayer()) and IsValid(v) and self:EntityFaceBack(v) then
			return true
		end
	end
	return false
end

function SWEP:EntityFaceBack(ent)
	local angle = self.Owner:GetAngles().y -ent:GetAngles().y
	if angle < -180 then angle = 360 +angle end
	if angle <= 90 and angle >= -90 then return true end
	return false
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
	if CritMath == 3 then
	self.Weapon:SetNWBool("Critical", true)
	end
	if self.Weapon:GetNWBool("Critical") then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("bs_swing_c"))
	self.Weapon:EmitSound("Weapon_Bat.MissCrit")
	else
	local swing = {"bs_swing_a","bs_swing_b"}
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence(table.Random(swing)))
	self.Weapon:EmitSound("Weapon_Bat.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .7

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end


function SWEP:SecondaryAttack()
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
	self.Weapon:SetNextPrimaryFire(CurTime() + .5)
	return true
end

function SWEP:Holster()
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
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

CreateClientConVar("tf2custom_leftarms_style","oldest",true,false,"Oldest or Blacky\nChanges require resupply.")

function SWEP:Initialize()
self:Initialize2()
self:SetLVLNumber(math.random(1,100))
	// other initialize code goes here
	self:SetWeaponHoldType("knife")
	local convar = GetConVar("tf2custom_leftarms_style"):GetString()
	if string.lower(convar) == "blacky"  then
	self.SkinType = 1
	else
	self.SkinType = 0
	end
	if CLIENT then
		// Create a new table for every weapon instance
		if self.SkinType == 1 then
		self.VElements = table.FullCopy( self.VElements2 )
		self.WElements = table.FullCopy( self.WElements2 )
		else
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		end		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		--// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					--// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					--// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end
