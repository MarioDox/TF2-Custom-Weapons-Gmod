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
			if self.Weapon:GetNWBool("Critical") then
			bullet.Damage = 195
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 65
			end
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:IsRagdoll() then
			if self.NoAmmo then
			self.Weapon:EmitSound("Weapon_Fist.HitFlesh")
			else
			self.Weapon:EmitSound("Weapon_Shovel.HitFlesh")
			end
			else
			if self.NoAmmo then
			self.Weapon:EmitSound("Weapon_Fist.HitWorld")
			else
			self.Weapon:EmitSound("Weapon_Shovel.HitWorld")
			end
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
	SWEP.PrintName			= "Ammunition"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Bullet bandolier"
	SWEP.Stats =  "Alt-Fire: Gain +50 ammo for each weapon."
	SWEP.Stats2 = ""
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = ""
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Why we need weapons if we can kill with the ammo?"
end

SWEP.VElements = {
	["gun"] = { type = "Model", model = "models/weapons/c_models/c_w_ludmila/c_w_ludmila.mdl", bone = "weapon_bone", rel = "", pos = Vector(3.055, 19.024, -1.089), angle = Angle(169.406, -141.532, -40.791), size = Vector(0.791, 0.791, 0.791), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["gun"] = { type = "Model", model = "models/weapons/c_models/c_w_ludmila/c_w_ludmila.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.39, 7.364, 13.614), angle = Angle(-40.245, -9.837, 78.699), size = Vector(0.791, 0.791, 0.791), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_knife_t.mdl"
SWEP.ShowWorldModel = false
SWEP.WMOffset = false

SWEP.InspectStartAnim = "melee_allclass_inspect_start"
SWEP.InspectIdleAnim = "melee_allclass_inspect_idle"
SWEP.InspectEndAnim = "melee_allclass_inspect_end"

SWEP.Primary.Delay			= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.NoAmmo 		= false

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack(s)
self:Holster2()
	local CritMath = math.random(0,5)
	if SERVER then
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Inspecting = false
	self.Caninspect = false
	end
	if CritMath == 3 then
	self.Weapon:SetNWBool("Critical", true)
	end
	if self.Weapon:GetNWBool("Critical") then
	if self.NoAmmo then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("f_swing_crit"))
	self.Weapon:EmitSound("Weapon_Fist.MissCrit")
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_swing"))
	self.Weapon:EmitSound("Weapon_Shovel.MissCrit")
	end
	else
	if self.NoAmmo and !s then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("f_swing_left"))
	self.Weapon:EmitSound("Weapon_Fist.Miss")
	elseif self.NoAmmo and s then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("f_swing_right"))
	self.Weapon:EmitSound("Weapon_Fist.Miss")
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_swing"))
	self.Weapon:EmitSound("Weapon_Shovel.Miss")
	end
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .92

	if ((game.SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end


function SWEP:SecondaryAttack()
local oldself = self
if self.NoAmmo then
self:PrimaryAttack(true)
end
if self.NoAmmo then return end
if SERVER then
self.NoAmmo = true
self:SetNoAmmo(true) 
end
self:EmitSound("items/gunpickup2.wav")
self:Deploy()
timer.Create("TF2Custom_Ammunition_Regain"..self.Owner:EntIndex(),12,1,function()
if oldself and oldself:IsValid() then
if SERVER then
self.NoAmmo = false
self:SetNoAmmo(false) 
end
self:Deploy()
self:EmitSound("player/recharged.wav",75,100,1,6)
end
end)
for k,v in pairs(self.Owner:GetWeapons()) do
if v:IsScripted() then
local a = v.Primary.Ammo
local a2 = v.Secondary.Ammo
local nogive = {"pistol","357","smg1","ar2","buckshot","xbowbolt","grenades","rpg_round","smg1_grenade","Ar2AltFire","slam","Alyxgun","SniperRound","SniperPenetratedRound","Thumper","Gravity","Battery","GaussEnergy","CombineCannon","CombineHeavyCannon","AirboatGun","StriderMinigun","StriderMinigunDirect","HelicopterGun","Hornet","MP5_Grenade","9mmRound"}
if a != #nogive then
self.Owner:GiveAmmo(50,a,false)
end
if a2 != #nogive then
self.Owner:GiveAmmo(50,a2)
end
end
if SERVER then
self.Owner:GiveAmmo(50,"pistol",true)
self.Owner:GiveAmmo(50,"357",true)
self.Owner:GiveAmmo(50,"smg1",true)
self.Owner:GiveAmmo(50,"ar2",true)
self.Owner:GiveAmmo(50,"buckshot",true)
self.Owner:GiveAmmo(50,"Xbowbolt",true)
self.Owner:GiveAmmo(50,"grenades",true)
self.Owner:GiveAmmo(50,"rpg_round",true)
self.Owner:GiveAmmo(50,"smg1_grenade",true)
self.Owner:GiveAmmo(50,"AR2AltFire",true)
self.Owner:GiveAmmo(50,"slam",true)
self.Owner:GiveAmmo(50,"AlyxGun",true)
self.Owner:GiveAmmo(50,"SniperRound",true)
self.Owner:GiveAmmo(50,"SniperPenetratedRound",true)
self.Owner:GiveAmmo(50,"Thumper",true)
self.Owner:GiveAmmo(50,"Gravity",true)
self.Owner:GiveAmmo(50,"Battery",true)
self.Owner:GiveAmmo(50,"GaussEnergy",true)
self.Owner:GiveAmmo(50,"CombineCannon",true)
self.Owner:GiveAmmo(50,"AirboatGun",true)
self.Owner:GiveAmmo(50,"StriderMinigun",true)
self.Owner:GiveAmmo(50,"HelicopterGun",true)
self.Owner:GiveAmmo(50,"9mmRound",true)
self.Owner:GiveAmmo(50,"MP5_Grenade",true)
self.Owner:GiveAmmo(50,"Hornet",true)
self.Owner:GiveAmmo(50,"StriderMinigunDirect",true)
self.Owner:GiveAmmo(50,"CombineHeavyCannon",true)
end
end
end


hook.Add("PostPlayerDeath","TF2Custom_Ammunition_RegainRemove",function(ply)
if timer.Exists("TF2Custom_Ammunition_Regain"..ply:EntIndex()) then timer.Remove("TF2Custom_Ammunition_Regain"..ply:EntIndex()) end
end)

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Weapon:SetNWBool("Critical",false)
	self.DoMelee = nil
	if self.Owner:GetActiveWeapon() == self then
	if self.NoAmmo then
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("f_draw"))
	else
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_allclass_draw"))
	end
	end
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + .9)
	self.Weapon:SetNextSecondaryFire(CurTime() + .9)
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
if self:GetNoAmmo() then
self.Inspect = false
if self.VElements then
self.VElements["gun"].hide = true
end
else
self.Inspect = true
if self.VElements then
self.VElements["gun"].hide = false
end
end
self:Think2()
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
if self.Idle and CurTime()>=self.Idle then
if self.NoAmmo then
self.Idle = CurTime() + 1.3
self:SendWeaponAnim(self.Owner:GetViewModel():GetSequenceActivity(self.Owner:GetViewModel():LookupSequence("f_idle")))
else
self.Idle = nil
self:SendWeaponAnim(self.Owner:GetViewModel():GetSequenceActivity(self.Owner:GetViewModel():LookupSequence("melee_allclass_idle")))
end
end
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "LVLNumber" )
	self:NetworkVar( "Bool", 0, "NoAmmo" )
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:Holster(gun)
if !self:IsValid() or (gun and !gun:IsValid()) then self = nil return false end
self:Holster2()
self.DoMelee = nil
return true
end



if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
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

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		self:WOffset()
		
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

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			--// Technically, if there exists an element with the same name as a bone
			--// you can get in an infinite loop. Let's just hope nobody's that stupid.
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
			
			--// !! WORKAROUND !! //
			--// We need to check all model names :/
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
			--// !! ----------- !! //
			
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

	--// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	--// Does not copy entities of course, only copies their reference.
	--// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
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


