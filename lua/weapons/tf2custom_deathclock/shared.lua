function SWEP:makemahamodel()
if (CLIENT) then
local vm = self.Owner:GetViewModel()
self.AModel = ClientsideModel("models/weapons/c_models/c_demo_arms.mdl")
self.AModel:SetPos(vm:GetPos())
self.AModel:SetAngles(vm:GetAngles())
self.AModel:AddEffects(EF_BONEMERGE)
self.AModel:SetNoDraw(true)
self.AModel:SetParent(vm)
end
end

function SWEP:makemahcmodel()
if (CLIENT) then
local vm = self.Owner:GetViewModel()
self.CModel = ClientsideModel("models/weapons/c_models/c_pda_engineer/c_pda_engineer.mdl")
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

function SWEP:CModelDraw()
if (CLIENT) then
if not self.AModel then self:makemahamodel() end
if self.SkinType == 1 and not self.CModel then self:makemahcmodel() end
if self.AModel then
local vm = self.Owner:GetViewModel()
self.AModel:DrawModel() 
end
if self.CModel then
local vm = self.Owner:GetViewModel()
self.CModel:DrawModel() 
end
end
if (CLIENT) then
if not self.AModel then self:makemahamodel() end
if self.AModel then self.AModel:DrawModel() end
if self.SkinType == 1 and not self.CModel then self:makemahcmodel() end
if self.SkinType == 1 and self.CModel then self.CModel:DrawModel() end
end
end

function SWEP:PreDrawViewModel(vm,wep,ply)
vm:SetMaterial("invis")
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Suicidal's Last Minute"	
	SWEP.Slot				= 0
	SWEP.SlotPos			= 0
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Suicide bomb"
	SWEP.Stats = "Primary Fire: Explode dealing 500 damage."
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "You die."
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Suspicious."
end

SWEP.MuzzleEffect			= "muzzle_shotgun"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"


SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true
SWEP.DrawCrosshair  	= false

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl"
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/weapons/c_models/stattrack.mdl", bone = "bip_wrist_R", rel = "", pos = Vector(-2.928, 2.321, -0.724), angle = Angle(1.69, 87.634, -9.48), size = Vector(1.23, 1.23, 1.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "weapons/grenade_launcher_shoot.wav" )
SWEP.Primary.CritSound			= Sound( "weapons/grenade_launcher_shoot_crit.wav" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.03
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.6
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Maxammo 		= 16
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.Inspect = false

SWEP.IronSightsPos = Vector(-7.62, 3.052, -5.547)
SWEP.IronSightsAng = Vector(0, -35.474, 0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("crossbow")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), -10)

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
	
function SWEP:GetViewModelPosition( pos, ang )	
local Offset	= self.IronSightsPos
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z )
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right
	pos = pos + Offset.y * Forward
	pos = pos + Offset.z * Up

	return pos, ang
	
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
self:EmitSound("items/cart_explode_trigger.wav")
self:SetNextPrimaryFire(CurTime() + 1)
timer.Simple(.8,function()
if !self or !self.Owner or !self:IsValid() or !self.Owner:IsValid() then return end
self:EmitSound( "Weapon_Grenade_Pipebomb.Explode" )
if SERVER then
local explosion = ents.Create( "info_particle_system" )
explosion:SetKeyValue( "effect_name", "ExplosionCore_MidAir" )
explosion:SetPos( self:GetPos()	) 
explosion:SetAngles( self:GetAngles() )
explosion:Spawn()
explosion:Activate() 
explosion:Fire( "Start", "", 0 )
explosion:Fire( "Kill", "", 0.1 )
	local d = DamageInfo()
	d:SetDamage( self.Owner:Health() )
	d:SetAttacker( self.Owner )
	d:SetInflictor( self.Owner:GetActiveWeapon() )
	d:SetDamageType( DMG_BLAST )
	self.Owner:TakeDamageInfo( d )
if self.Owner and IsValid(self.Owner) then
	if !self.critical then
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 180, 1500 )
	else
		util.BlastDamage( self, self:GetOwner(), self:GetPos(), 190, 500 )
	end
end
end
end)
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
self.Owner:GetViewModel():SetPlaybackRate(1)
	self:AmmoCheck()
	if self.SkinType == 1 then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pda_draw"))
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("item2_inspect_start"))
	end
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
if self and self:IsValid() and self.Owner and self.Owner:IsValid() and self.Owner:GetViewModel() and self.Owner:GetViewModel():IsValid() then
self.Owner:GetViewModel():SetMaterial(nil)
end
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
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
if self.SkinType == 1 then
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pda_idle"))
else
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("item2_inspect_idle"))
end
self.Owner:GetViewModel():SetPlaybackRate(1)
end
end

CreateClientConVar("tf2custom_deathclock_style","clock",true,false,"Clock or Device\nChanges require resupply.")

function SWEP:Initialize2()
local convar = GetConVar("tf2custom_deathclock_style"):GetString()
if string.lower(convar) == "device"  then
self.SkinType = 1
else
self.SkinType = 0
end
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		if self.SkinType == 1 then
		self:CModelDraw()
		else
		self:CModelDraw()
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if self.SkinType == 1 then
			self:DrawModel()
			self:WOffset()
		else
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			end
			
		end
		
	end
end
