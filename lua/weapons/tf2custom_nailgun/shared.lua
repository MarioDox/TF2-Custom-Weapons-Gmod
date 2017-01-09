local RevolverLimit = { }
RevolverLimit[ "smg1" ] = 75

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "ar2"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Nail gun"	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type =  "Nailgun"
	SWEP.Stats =  "Alt-fire: Use Scope"
	SWEP.Stats2 = "Scope doesn't retract when shooting"
	SWEP.Stats3 = "-5% Reload delay"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-5% Reload delay"
	SWEP.Stats11 = "+1% Fire delay"
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "At least looks like an M4."
end


SWEP.MuzzleEffect			= "muzzle_pistol"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_tfc_sniperrifle/c_tfc_sniperrifle.mdl"
SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/items/festivizer.mdl", bone = "weapon_bone", rel = "", pos = Vector(3.026, -4.732, 4.671), angle = Angle(180, 26.51, -73.034), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["gun"] = { type = "Model", model = "models/items/festivizer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.052, 4.788, -4.597), angle = Angle(38.395, 78.42, -162.741), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.InspectStartAnim = "secondary_inspect_start"
SWEP.InspectIdleAnim = "secondary_inspect_idle"
SWEP.InspectEndAnim = "secondary_inspect_end"

SWEP.Primary.Sound			= Sound( "Weapon_SMG.Single" )
SWEP.Primary.CritSound			= Sound( "Weapon_SMG.SingleCrit" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= math.random(4,5)
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Maxammo 		= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:SecondaryAttack()
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

	if not self:CanPrimaryAttack() then return end
	-- If your gun have a problem or if you are under water, you'll not be able to fire
	
		local CritMath = math.random(0,15)
	
	if CritMath == 11 then
	self.Weapon:SetNWBool("Critical", true)
	self.StopCrit = CurTime() + 0.6
	end
	
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("revolver_fire"))

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
	
	self.Idle = CurTime() + .1
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	self.Owner:GetViewModel():ResetSequence(self.Owner:GetViewModel():LookupSequence("revolver_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	self.Owner:GetViewModel():SetPlaybackRate(1)
	return true
end

function SWEP:Holster()
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
if ( self.Reloadaftershoot > CurTime() ) then return end 

	if ( self:Ammo1() <= 0 ) then return end
	if ( self.Weapon:Clip1() < self.Weapon.Primary.ClipSize ) then
	self:Holster2()
	self.Weapon:DefaultReload(self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("revolver_reload")))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
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
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("revolver_idle"))
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
		return end
end

	self:FireBullets(bullet)					-- Fire the bullets
	self.Owner:SetAnimation(PLAYER_ATTACK1)       			-- 3rd Person Animation

end
/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/

function SWEP:Initialize()

	// other initialize code goes here

	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
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
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
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

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
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
				model:SetSubMaterial(0,"invis")
				model:SetSubMaterial(1,"invis")
				model:SetSubMaterial(2,"invis")
				model:SetSubMaterial(3,nil)
				
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

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
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
				model:SetSubMaterial(0,"invis")
				model:SetSubMaterial(1,"invis")
				model:SetSubMaterial(2,"invis")
				model:SetSubMaterial(3,nil)
				
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

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

