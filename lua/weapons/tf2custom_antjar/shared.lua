if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "melee"
end

function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/urinejar.mdl")
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
if self.CModel then self.CModel:DrawModel() end
end
end


if (CLIENT) then
	SWEP.Category 			= "Team Fortress 2 Edits"
	SWEP.PrintName			= "test"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Stats =  "Primary Fire: Throws the pointed object/enemy on the ground."
	SWEP.Stats2 = "Secondary Fire: Throws the pointed object/enemy in air."
	SWEP.Stats3 = "Infinite range"
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "No damage done"
	SWEP.Stats11 = "No random critical hits"
	SWEP.Stats12 = "+4% attack delay"
	SWEP.Stats13 = "Not being able to use buildables in any way."
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "You got magnificent powers."
end

SWEP.Base 				= "tf2base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_sniper_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/urinejar.mdl"

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Delay			= 1.2
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

function SWEP:DrawWorldModel()

local hand, offset, rotate

if not IsValid(self.Owner) then
self:DrawModel()
return
end

self:SetWeaponHoldType("grenade")
hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

offset = hand.Ang:Right() * 0.9 + hand.Ang:Forward() * 1.8 - hand.Ang:Up() * 0.7

hand.Ang:RotateAroundAxis(hand.Ang:Right(), 17)
hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

self:SetRenderOrigin(hand.Pos + offset)
self:SetRenderAngles(hand.Ang)

self:DrawModel()
if (CLIENT) then
end
end


/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pj_fire"))
	self.End = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	if SERVER then
	local sk = ents.Create("tf2custom_proj_antjar")
	sk:SetPos(self.Owner:GetShootPos())
	sk:SetAngles(Angle(0,self.Owner:EyeAngles().y,0))
	sk:SetOwner(self.Owner)
	sk.Owner = self.Owner
	sk:Spawn()
	local p = sk:GetPhysicsObject()
	if p:IsValid() then
	p:AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
	p:ApplyForceCenter(self.Owner:GetAimVector() * 4000)
	end
	end
end


function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pj_draw"))
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
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
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("pj_idle"))
end
if self.End and CurTime()>=self.End then
self.End = nil
self:Remove()
self.Owner:ConCommand("lastinv")
end
end
/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()
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