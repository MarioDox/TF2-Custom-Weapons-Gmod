if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Another Chance"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Resurrect Totem"
	SWEP.Stats =  "Resurrects wearer on first death, boosting his health to the max"
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No cooldown, resupply to get again"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Looks like you got a 1-UP before, uh?"
end

SWEP.Inspect = false

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ShowWorldModel = false

SWEP.Primary.Delay			= .4
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

hook.Add("PlayerSwitchWeapon","TF2Custom_anotherchance_noswitch",function( ply, oldWeapon, newWeapon )
if newWeapon:GetClass() == "tf2custom_anotherchance" then return true end
end)

hook.Add("EntityTakeDamage","TF2Custom_anotherchance_lifesave",function(ent,dmg)
if ent:IsPlayer() and ent:HasWeapon("tf2custom_anotherchance") and dmg:GetDamage() >= ent:Health() then
ent:GetWeapon("tf2custom_anotherchance"):Remove()
ent:SetHealth(0)
ent:EmitSound("player/mannpower_invulnerable.wav")
ent:GodEnable()
timer.Create("TF2Custom_anotherchance_lifegain"..ent:EntIndex(),.00001,ent:GetMaxHealth(),function()
if ent and ent:IsValid() then
ent:SetHealth(ent:Health() + 1)
end
end)
timer.Simple((ent:GetMaxHealth()/100)+.5,function() --that's some easy math
if ent and ent:IsValid() then
ent:GodDisable()
ent:EmitSound("player/invulnerable_off.wav")
end
end)
return true
end
end)

hook.Add("PostPlayerDeath","TF2Custom_anotherchance_lifestop",function(ply)
if timer.Exists("TF2Custom_anotherchance_lifegain"..ply:EntIndex()) then timer.Remove("TF2Custom_anotherchance_lifegain"..ply:EntIndex()) end
end)

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
end


function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
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
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
	self:Holster2()
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end