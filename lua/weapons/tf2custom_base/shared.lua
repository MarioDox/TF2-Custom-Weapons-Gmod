function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel(self.Model)
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end

function SWEP:CModelDraw()
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then
local vm = self.Owner:GetViewModel()
self.CModel:DrawModel() 
end
end
if (CLIENT) then
if not self.CModel then self:makemahcmodel() end
if self.CModel then
local vm = self.Owner:GetViewModel()
self.CModel:DrawModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetParent(vm)
end
end
end

function SWEP:PostDrawViewModel(vm,wep,ply)
vm:SetupBones()
end

local RevolverLimit = { }
RevolverLimit[ "smg1" ] = 75

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "ar2"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Test"	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.Type = "Gun"
	SWEP.Stats =  ""
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
	SWEP.Description = ""
	SWEP.DevDiary = "Dev Diary:\nWell. How you got here?\nI don't know, but, read this.\nI started working on this base in 2016, merging various stuff to not rewrite everytime when I made a new weapon.\nAfter that, I merged SCK's code, so I could make custom models.\nThen my first inspection code, was just press the +use Key to inspect the weapon, and was really buggy.\nI needed something different, so, I did, an hook, on bindings.\nIt replaced the F key with a cool inspection that was less buggy, and easily settable on each weapons through variables.\nThen I wanted to upgrade the stats menu, that was recycled from another weapon of mine. Similiar to TF2's it writes the actually stats of the weapon when being drawn.\nThen I added a random item level, something actually useless.\nNext, was the Set. The Set is a combinations of weapon, that when are togheter, they give an attribute to yourself or the gun.\nToday is 30 of October, 2016. I started working on this. I don't know if they would ever read this.. but, I want to express myself, after years of solitude and depression. Please, read this."
end


SWEP.MuzzleEffect			= "muzzle_pistol"
SWEP.TracerEffect = "bullet_tracer01_red"
SWEP.TracerCritEffect = "bullet_tracer01_red_crit"
SWEP.MuzzleAttachment		= "muzzle"

SWEP.Base 				= "tf2base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 	= false

SWEP.Model = "models/weapons/c_models/c_pistol/c_pistol.mdl"
SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= SWEP.Model

SWEP.Primary.Sound			= Sound( "Weapon_SMG.Single" )
SWEP.Primary.CritSound			= Sound( "Weapon_SMG.SingleCrit" )
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= math.random(4,5)
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Maxammo 		= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.SwayScale = 0
SWEP.BobScale = 1

SWEP.Inspect = true
SWEP.DrawAnim = "draw"
SWEP.IdleAnim = "idle"
SWEP.FireAnim = "fire"
SWEP.ReloadAnim = "reload"
SWEP.ReloadStartAnim = "reload_start"
SWEP.ReloadLoopAnim = "reload_loop"
SWEP.ReloadEndAnim = "reload_end"
SWEP.InspectStartAnim = "primary_inspect_start"
SWEP.InspectIdleAnim = "primary_inspect_idle"
SWEP.InspectEndAnim = "primary_inspect_end"
SWEP.Crosshair = "sprites/tf_crosshair_03"
SWEP.IdleDraw = 1
SWEP.IdleFire = 1
SWEP.IdleAgain = 1
SWEP.WMOffset = true


SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"
SWEP.LVLNumber 		= math.random(1,100)

SWEP.IronSightsPos = Vector (0,0,0)
SWEP.IronSightsAng = Vector (0,0,0)

function SWEP:WOffset()
if self.WMOffset then
if self.Owner and self.Owner:IsValid() then
local hand, offset, rotate

self:SetWeaponHoldType("ar2")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1 - hand.Ang:Up() * -2

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 7)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)
end
end
end


function SWEP:SecondaryAttack()
end

function SWEP:Zoom()
self.Owner:SetFOV( 30, 0.1 )
self.Weapon:SetNWBool("Scope",true)
end

function SWEP:UnZoom()
self.Owner:SetFOV( 0, 0.1 )
self.Weapon:SetNWBool("Scope",false)
end

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
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
	local vm = self.Owner:GetViewModel()
	
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.FireAnim))

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
	
	self.Idle = CurTime() + self.IdleFire
	
	self.Weapon:SetNWBool("Critical", false)


end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self:UnZoom()
	self:AmmoCheck()
	self.Weapon:SetNWBool("Critical",false)
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.DrawAnim))
	self.Idle = CurTime() + self.IdleDraw
	self.CanInspect = CurTime() + 1
	self.Reloadaftershoot = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
	return true
end

function SWEP:Holster()
self:UnZoom()
return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
if ( self.Reloadaftershoot > CurTime() ) then return end 

	if ( self:Ammo1() <= 0 ) then return end
	if ( self.Weapon:Clip1() < self.Weapon.Primary.ClipSize ) then
	self:UnZoom()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.ReloadAnim))
	self.Idle = CurTime() + .7
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
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.IdleAnim))
self.Idle = CurTime() + self.IdleAgain
end
if self.Inspectidle and CurTime()>=self.Inspectidle then
self.Inspectidle = nil
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectIdleAnim))
end
self:Think2()
for k, v in pairs( RevolverLimit ) do
		if ( self.Owner:GetAmmoCount( k ) > v ) then
				self.Owner:RemoveAmmo ( self.Owner:GetAmmoCount( k ) - v ,k )
		end
	end
end

function SWEP:Think2()
if self.Inspectidle and CurTime()>=self.Inspectidle then
self.Inspectidle = nil
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectIdleAnim))
end
if self.CanInspect and CurTime()>=self.CanInspect then
self.CanInspect = nil
self.CI = true
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

	
function SWEP:DrawHUD2()
end

function SWEP:DrawHUD()
self:DrawHUD2()
	surface.SetTexture(surface.GetTextureID(self.Crosshair))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( ScrW()/2 - 26, ScrH()/2 - 25, 50, 50 )
	if (CLIENT) then
	
	local Scale = ScrH()/480
	local w, h = 320*Scale, 240*Scale
	local cx, cy = ScrW()/2, ScrH()/2
	local scope_sniper_lr = surface.GetTextureID("HUD/scope_sniper_lr")
	local scope_sniper_ll = surface.GetTextureID("HUD/scope_sniper_ll")
	local scope_sniper_ul = surface.GetTextureID("HUD/scope_sniper_ul")
	local scope_sniper_ur = surface.GetTextureID("HUD/scope_sniper_ur")
	local SNIPERSCOPE_MIN = -0.75
	local SNIPERSCOPE_MAX = -2.782
	local SNIPERSCOPE_SCALE = 0.4

	if !self:GetNWBool("Scope") then return end

	render.UpdateRefractTexture()
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(scope_sniper_lr) surface.DrawTexturedRect(cx    , cy    , w, h)
	surface.SetTexture(scope_sniper_ll) surface.DrawTexturedRect(cx - w    , cy    , w, h)
	surface.SetTexture(scope_sniper_ul) surface.DrawTexturedRect(cx - w    , cy - h    , w, h)
	surface.SetTexture(scope_sniper_ur) surface.DrawTexturedRect(cx    , cy - h    , w, h)
	surface.SetDrawColor(0,0,0,255)
	if cx-w > 0 then
	surface.DrawRect(0, 0, cx-w, ScrH())
	surface.DrawRect(cx+w, 0, cx-w, ScrH())
	end	

		end
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

function SWEP:WeaponSetAttributes()
return false
end

CreateClientConVar("tf2custom_dev_diary",0,true,false,"1 = on, 0 = off.\nYou might ask why.\nBut, I feel emotions, even if I'm a Yandere.\nNo, this isn't something about Yandere Simulator, is just how I am.")
function SWEP:PrintWeaponInfo( x, y, alpha )

	--if (self.InfoMarkup == nil ) then
		local str
		local statspositive_color = "<color=102,178,255,255>"
		local statsnegative_color = "<color=255,0,0,255>"
		local Description_color = "<color=255,255,0,255>"
		local stats_color = "<color=0,255,0,255>"
		local white_color = "<color=255,255,255,255>"
		local gray_color = "<color=160,160,160,255>"
		local yellow_color = "<color=255,255,0,255>"
		local green_color = "<color=0,255,0,255>"
		local dev_color = "<color=150, 150, 150, 255>"
		
		str = "<font=HudSelectionText>"
		if ( self.Type != "" ) then str = str .. gray_color ..gray_color.."Level "..self:GetLVLNumber().." "..self.Type.."</color>\n" end
		--end
		if ( self.FirstStat and self.FirstStat != "" ) then str = str .. white_color ..white_color..self.FirstStat.."</color>\n" end
		if ( self.Stats != "" ) then str = str ..statspositive_color..self.Stats.."</color>\n" end
		if ( self.Stats2 != "" ) then str = str ..statspositive_color..self.Stats2.."</color>\n" end
		if ( self.Stats3 != "" ) then str = str ..statspositive_color..self.Stats3.."</color>\n" end
		if ( self.Stats4 != "" ) then str = str ..statspositive_color..self.Stats4.."</color>\n" end
		if ( self.Stats5 != "" ) then str = str ..statspositive_color..self.Stats5.."</color>\n" end
		if ( self.Stats6 != "" ) then str = str ..statspositive_color..self.Stats6.."</color>\n" end
		if ( self.Stats7 != "" ) then str = str ..statspositive_color..self.Stats7.."</color>\n" end
		if ( self.Stats8 != "" ) then str = str ..statspositive_color..self.Stats8.."</color>\n" end
		if ( self.Stats9 != "" ) then str = str ..statspositive_color..self.Stats9.."</color>\n" end
		if ( self.Stats10 != "" ) then str = str ..statsnegative_color..self.Stats10.."</color>\n" end
		if ( self.Stats11 != "" ) then str = str ..statsnegative_color..self.Stats11.."</color>\n" end
		if ( self.Stats12 != "" ) then str = str ..statsnegative_color..self.Stats12.."</color>\n" end
		if ( self.Stats13 != "" ) then str = str ..statsnegative_color..self.Stats13.."</color>\n" end
		if ( self.Stats14 != "" ) then str = str ..statsnegative_color..self.Stats14.."</color>\n" end
		if ( self.Stats15 != "" ) then str = str ..statsnegative_color..self.Stats15.."</color>\n" end
		if ( self.Stats16 != "" ) then str = str ..statsnegative_color..self.Stats16.."</color>\n" end
		if ( self.Description != "" ) then str = str ..white_color..self.Description.."</color>\n" end
		if ( self.Set and self.Set != "" ) then str = str ..yellow_color.."Set: "..self.Set.."</color>\n" end
		if self:WeaponSetAttributes() then
		if ( self.SetAttribute and self.SetAttribute != "" ) then str = str ..green_color.."Set Attributes: "..self.SetAttribute.."</color>\n" end
		end
		if GetConVar("tf2custom_dev_diary"):GetFloat() == 1 then
		if ( self.DevDiary != "" ) then str = str ..dev_color..self.DevDiary.."</color>\n" end
		end
		str = str .. "</font>"
		self.InfoMarkup = markup.Parse( str, 250 )
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "LVLNumber" )

end

function SWEP:Initialize2()
end

function SWEP:Initialize()
self:Initialize2()
self:SetLVLNumber(math.random(1,100))
--self.LVLNumber = math.random(1,100)
	// other initialize code goes here
	self:SetWeaponHoldType("knife")
	if CLIENT then
	
		--// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

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

function SWEP:Holster()
	self.Idle = false
	if CLIENT and IsValid(self.Owner) then
		self:UnZoom()
		self:Holster2()
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:Holster2()
if SERVER then
self.Idle = nil
self.Inspecting = false
self.Inspecting2 = false
self.Inspectidle = nil
end
end

function SWEP:OnRemove()
	self:Holster()
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

SWEP.Inspecting = false
hook.Add("PlayerBindPress","TF2CustomAntiflashlight",function( ply, bind, pressed )
if pressed then
if ply and ply:IsValid() and ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() then
local wep = ply:GetActiveWeapon()
if wep and wep:IsValid() and wep.Base and wep.Base == "tf2custom_base" then
if wep.Inspect and ( string.find( bind, "impulse 100" ) ) then return true end
end
end
end
end)

function SWEP:DoInspect()
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
self.Inspectidle = nil
self.Inspecting = false
local vm = self.Owner:GetViewModel()
if vm and vm:IsValid() then
vm:SendViewModelMatchingSequence(vm:LookupSequence(self.InspectEndAnim))
self.Idle = CurTime() + vm:SequenceDuration()
end
end

//holy shit took ages to make it work on mp
if SERVER then
util.AddNetworkString( "Inspect" )
util.AddNetworkString( "InspectEnd" )
end

hook.Add("Tick","TF2CustomInspect",function()
for k,v in pairs(player.GetAll()) do
local wep = v:GetActiveWeapon()
if v and v:IsValid() and wep and wep:IsValid() and wep.Base and wep.Base == "tf2custom_base" and wep.Inspect then
if CLIENT then
if v == LocalPlayer() then
if input.IsKeyDown(KEY_F) then
if v:GetViewModel() and (v:GetViewModel():GetSequence() == v:GetViewModel():LookupSequence(wep.InspectIdleAnim) or v:GetViewModel():GetSequence() == v:GetViewModel():LookupSequence(wep.InspectStartAnim) or v:GetViewModel():GetSequence() == v:GetViewModel():LookupSequence(wep.InspectEndAnim)) then else
wep.Inspecting = true
net.Start( "Inspect" )
net.WriteEntity( ply )
net.SendToServer()
end
end
if v:GetViewModel() and (v:GetViewModel():GetSequence() == v:GetViewModel():LookupSequence(wep.InspectIdleAnim)) then
if !input.IsKeyDown(KEY_F) then
if wep.Inspecting then
wep.Inspecting = false
net.Start( "InspectEnd" )
net.WriteEntity( ply )
net.SendToServer()
end
end
end
end
end
end
end
end)

net.Receive( "Inspect", function(len,ply)
local ply = net.ReadEntity()
local wep = ply:GetActiveWeapon()
if wep and wep:IsValid() and wep.Base and wep.Base == "tf2custom_base" and wep.Inspect then
wep:DoInspect()
end
end)
net.Receive( "InspectEnd", function(len,ply)
local ply = net.ReadEntity()
local wep = ply:GetActiveWeapon()
if wep and wep:IsValid() and wep.Base and wep.Base == "tf2custom_base" and wep.Inspect then
wep:DoEndInspect()
end
end)
