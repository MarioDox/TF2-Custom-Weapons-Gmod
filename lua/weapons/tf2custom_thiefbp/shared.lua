if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Custom"
	SWEP.PrintName			= "Thief Backpack"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Type =  "Backpack"
	SWEP.Stats =  "On item pickup: Store it in one of the 6 slots of your backpack"
	SWEP.Stats2 = "Primary Fire: Drop the pickups on ground"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "Cannot refil ammo or heal from pickups"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "Help your teammates by giving them pickups!"
end

SWEP.Base 				= "tf2custom_base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/player/items/sniper/xms_sniper_commandobackpack.mdl"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.Inspect = false

SWEP.IronSightsPos = Vector (0,0,0)
SWEP.IronSightsAng = Vector (0,0,0)

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("melee")
self:SetSubMaterial(1,"invis")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("chest"))

offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 10 - hand.Ang:Up() * 65

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
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
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
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()
if self.AntiGlitch and CurTime()>=self.AntiGlitch then
self.AntiGlitch = nil
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:PrintWeaponInfo( x, y, alpha )

	if (self.InfoMarkup == nil ) then
		local str
		local statspositive_color = "<color=102,178,255,255>"
		local statsnegative_color = "<color=255,0,0,255>"
		local Description_color = "<color=255,255,0,255>"
		local stats_color = "<color=0,255,0,255>"
		local white_color = "<color=255,255,255,255>"
		
		str = "<font=HudSelectionText>"
		if ( self.Stats != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats.."</color>\n" end
		if ( self.Stats2 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats2.."</color>\n" end
		if ( self.Stats3 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats3.."</color>\n" end
		if ( self.Stats4 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats4.."</color>\n" end
		if ( self.Stats5 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats5.."</color>\n" end
		if ( self.Stats6 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats6.."</color>\n" end
		if ( self.Stats7 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats7.."</color>\n" end
		if ( self.Stats8 != "" ) then str = str .. statspositive_color ..statspositive_color..self.Stats8.."</color>\n" end
		if ( self.Stats9 != "" ) then str = str .. statsnegative_color ..statspositive_color..self.Stats9.."</color>\n" end
		if ( self.Stats10 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats10.."</color>\n" end
		if ( self.Stats11 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats11.."</color>\n" end
		if ( self.Stats12 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats12.."</color>\n" end
		if ( self.Stats13 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats13.."</color>\n" end
		if ( self.Stats14 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats14.."</color>\n" end
		if ( self.Stats15 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats15.."</color>\n" end
		if ( self.Stats16 != "" ) then str = str .. statsnegative_color ..statsnegative_color..self.Stats16.."</color>\n" end
		if ( self.Description != "" ) then str = str .. white_color ..white_color..self.Description.."</color>\n" end
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse( str, 250 )
	end
	
	surface.SetDrawColor( 60, 60, 60, alpha )
	surface.SetTexture( self.SpeechBubbleLid )
	
	surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 ) 
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )
	
	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )
	
end

function SWEP:Equip()
self.Items = 0
end
--[[
function SWEP:StoreItem(ent)
if SERVER then
local mdl = ent:GetModel()
local class = ent:GetClass()
if wep.Items == 0 then
self:SetNWString( "item1mdl", mdl )
self:SetNWString( "item1class", class )
self.Owner:ChatPrint("item1: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 1
elseif wep.Items == 1 then
self:SetNWString( "item2mdl", mdl )
self:SetNWString( "item2class", class )
self.Owner:ChatPrint("item2: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 2
elseif wep.Items == 2 then
self:SetNWString( "item3mdl", mdl )
self:SetNWString( "item3class", class )
self.Owner:ChatPrint("item3: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 3
elseif wep.Items == 3 then
self:SetNWString( "item4mdl", mdl )
self:SetNWString( "item4class", class )
self.Owner:ChatPrint("item4: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 4
elseif wep.Items == 4 then
self:SetNWString( "item5mdl", mdl )
self:SetNWString( "item5class", class )
self.Owner:ChatPrint("item5: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 5
elseif wep.Items == 5 then
self:SetNWString( "item6mdl", mdl )
self:SetNWString( "item6class", class )
self.Owner:ChatPrint("item6: picked up "..ent:GetClass().." with model: "..ent:GetModel())
ent:Remove()
self.Items = 6
end
self.AntiGlitch = CurTime() + .1
self:EmitSound("ui/item_light_gun_pickup.wav")
end
end]]

function SWEP:Initialize()
self.Items = 0
self.Items = self.Items
self:SetNWFloat("Items",0)
end

function SWEP:PrimaryAttack()
local tr = {}
tr.start = self.Owner:GetShootPos()
tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 230 )
tr.filter = self.Owner
tr.mask = MASK_SHOT
local trace = util.TraceLine( tr )
if ( not trace.Hit ) then
if wep.Items >= 1 then
self:EmitSound("ui/item_bag_drop.wav")
end
if SERVER then
self:SetNextPrimaryFire(CurTime() + self.Items)
local mdl1 = self:GetNWString("item1mdl")
local mdl2 = self:GetNWString("item2mdl")
local mdl3 = self:GetNWString("item3mdl")
local mdl4 = self:GetNWString("item4mdl")
local mdl5 = self:GetNWString("item5mdl")
local mdl6 = self:GetNWString("item6mdl")
local class1 = self:GetNWString("item1class")
local class2 = self:GetNWString("item2class")
local class3 = self:GetNWString("item3class")
local class4 = self:GetNWString("item4class")
local class5 = self:GetNWString("item5class")
local class6 = self:GetNWString("item6class")
if wep.Items >= 1 then
local ent1 = ents.Create(class1)
ent1:SetModel(mdl1)
ent1:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80)
ent1:Spawn()
self:SetNWString( "item1mdl", "" )
self:SetNWString( "item1class", "" )
end
if wep.Items >= 2 then
local ent2 = ents.Create(class2)
ent2:SetModel(mdl2)
ent2:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * -10)
ent2:Spawn()
self:SetNWString( "item2mdl", "" )
self:SetNWString( "item2class", "" )
end
if wep.Items >= 3 then
local ent3 = ents.Create(class3)
ent3:SetModel(mdl3)
ent3:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * -20)
ent3:Spawn()
self:SetNWString( "item3mdl", "" )
self:SetNWString( "item3class", "" )
end
if wep.Items >= 4 then
local ent4 = ents.Create(class4)
ent4:SetModel(mdl4)
ent4:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * -40)
ent4:Spawn()
self:SetNWString( "item4mdl", "" )
self:SetNWString( "item4class", "" )
end
if wep.Items >= 5 then
local ent5 = ents.Create(class5)
ent5:SetModel(mdl5)
ent5:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * -50)
ent5:Spawn()
self:SetNWString( "item5mdl", "" )
self:SetNWString( "item5class", "" )
end
if wep.Items == 6 then
local ent6 = ents.Create(class6)
ent6:SetModel(mdl6)
ent6:SetPos(self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 80 + self.Owner:GetAngles():Up() * -60)
ent6:Spawn()
self:SetNWString( "item6mdl", "" )
self:SetNWString( "item6class", "" )
end
end
self.Items = 0
self:SetNWFloat("Items",0)
else
self:EmitSound("weapons/medigun_no_target.wav")
end
end

function SWEP:DrawHUD()
	surface.SetTexture(surface.GetTextureID("sprites/tf_crosshair_01"))
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( ScrW()/2 - 26, ScrH()/2 - 25, 50, 50 )
	--surface.SetFont( "Trebuchet24" )
	--surface.SetTextColor( 255, 255, 255, 255 )
	--surface.SetTextPos( ScrW()/2 - 26, ScrH()/1.1 - 25 )
	--surface.CreateFont("ItemHud", {font = "Prototype", size = 20, weight = 500, blursize = 0, antialias = true, shadow = false})
	--surface.SetFont("ItemHud")
	if CLIENT and self:GetNWFloat("Items") and self:GetNWFloat("Items") >= -1 then
	--surface.DrawText( "Items: "..self:GetNWFloat("Items"))
	draw.SimpleText("Items: "..self:GetNWFloat("Items").."","DermaLarge",ScrW()/2 - 26, ScrH()/1.1 - 25,Color(255,255,255,190))
end
end

hook.Add("PlayerCanPickupItem","CTF2Backpackpick",function(ply,ent)
if ply:HasWeapon("tf2custom_thiefbp") then
local wep = ply:GetWeapon( "tf2custom_thiefbp" ) 
if (wep.Items and wep.Items >= 6) or (wep.AntiGlitch and CurTime()<wep.AntiGlitch)  then return false end
--if wep:StoreItem(ent) then
--wep:StoreItem(ent)
--end
if SERVER then
local mdl = ent:GetModel()
local class = ent:GetClass()
if wep.Items == 0 then
wep:SetNWString( "item1mdl", mdl )
wep:SetNWString( "item1class", class )
ent:Remove()
wep.Items = 1
wep:SetNWFloat("Items",1)
elseif wep.Items == 1 then
wep:SetNWString( "item2mdl", mdl )
wep:SetNWString( "item2class", class )
ent:Remove()
wep.Items = 2
wep:SetNWFloat("Items",2)
elseif wep.Items == 2 then
wep:SetNWString( "item3mdl", mdl )
wep:SetNWString( "item3class", class )
ent:Remove()
wep.Items = 3
wep:SetNWFloat("Items",3)
elseif wep.Items == 3 then
wep:SetNWString( "item4mdl", mdl )
wep:SetNWString( "item4class", class )
ent:Remove()
wep.Items = 4
wep:SetNWFloat("Items",4)
elseif wep.Items == 4 then
wep:SetNWString( "item5mdl", mdl )
wep:SetNWString( "item5class", class )
ent:Remove()
wep.Items = 5
wep:SetNWFloat("Items",5)
elseif wep.Items == 5 then
wep:SetNWString( "item6mdl", mdl )
wep:SetNWString( "item6class", class )
ent:Remove()
wep.Items = 6
wep:SetNWFloat("Items",6)
end
wep.AntiGlitch = CurTime() + .1
wep:EmitSound("ui/item_light_gun_pickup.wav")
end
return false
end
end)