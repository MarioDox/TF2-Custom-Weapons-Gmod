function SWEP:makemahcmodel()
if (CLIENT) then
self.CModel = ClientsideModel("models/weapons/c_models/c_lollichop/c_lollichop.mdl")
local vm = self.Owner:GetViewModel()
self.CModel:SetPos(vm:GetPos())
self.CModel:SetAngles(vm:GetAngles())
self.CModel:AddEffects(EF_BONEMERGE)
self.CModel:SetNoDraw(true)
self.CModel:SetSkin(1)
self.CModel:SetParent(vm)
end
end

function SWEP:ViewModelDrawn()
if (CLIENT) then
local col2 = HSVToColor( CurTime() % 6 * 60, 1, 1 )
local temp = Vector( col2.r / 255, col2.g / 255, col2.b / 255 )
local col = temp:ToColor()
render.SetColorModulation(col2.r / 255, col2.g / 255, col2.b / 255)
if not self.CModel then self:makemahcmodel() end
if self.CModel then
self.CModel:DrawModel()
self.CModel:SetColor( col )
end
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
			bullet.Damage = 131
			trace.Entity:EmitSound("TFPlayer.CritHit")
			else
			bullet.Damage = 44
			end
			if trace.Entity:IsPlayer() then
			for k, v in pairs( trace.Entity:GetWeapons() ) do
			trace.Entity:DropWeapon( v )
			end
			elseif trace.Entity:IsNPC() then
			local wepon = trace.Entity:GetActiveWeapon()
			if SERVER then
			if trace.Entity:GetActiveWeapon():IsValid() then
			trace.Entity:GetActiveWeapon():Remove()
			end
			end
			end
			if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:EmitSound("Weapon_Shovel.HitFlesh")
			trace.Entity:SetColor(Color(math.random(150,255),math.random(150,255),math.random(150,255)))
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
	SWEP.Category 			= "Team Fortress 2 Edits"
	SWEP.PrintName			= "Magic Candy of Rainbow"	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 70
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawAmmo		= false
	SWEP.Stats =  "On Hit: Target drops weapons"
	SWEP.Stats2 = "On Hit: Target turns of another color"
	SWEP.Stats3 = ""
	SWEP.Stats4 = ""
	SWEP.Stats5 = ""
	SWEP.Stats6 = ""
	SWEP.Stats7 = ""
	SWEP.Stats8 = ""
	SWEP.Stats9 = ""
	SWEP.Stats10 = "-33% Damage penality"
	SWEP.Stats11 = ""
	SWEP.Stats12 = ""
	SWEP.Stats13 = ""
	SWEP.Stats14 = ""
	SWEP.Stats15 = ""
	SWEP.Stats16 = ""
	SWEP.Description = "The love of the pyro is this magic rainbow-colored candy, that when people see it, they give up to war and become friends."
	--hey you.
	--yes you.
	--If you're reading this message...
	--Come to my profile.
	--And write a comment: "I saw this message, in the candy."
	--That will make me fell happy.
	--Thanks.
end

SWEP.Base 				= "tf2base"
SWEP.ViewModelFlip		= false

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_lollichop/c_lollichop.mdl"

SWEP.Primary.Delay			= 0.8
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

self:SetSkin(1)

if CLIENT then
local col2 = HSVToColor( CurTime() % 6 * 60, 1, 1 )
local temp = Vector( col2.r / 255, col2.g / 255, col2.b / 255 )
local col = temp:ToColor()
render.SetColorModulation(col2.r / 255, col2.g / 255, col2.b / 255)
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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fa_swing_c"))
	self.Weapon:EmitSound("Weapon_Bat.MissCrit")
	else
	swing = { "fa_swing_a", "fa_swing_b" }
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence(table.Random( swing )))
	self.Weapon:EmitSound("Weapon_Bat.Miss")
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.DoMelee = CurTime() + 0.22
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Idle = CurTime() + .75

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
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fa_draw"))
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
	self.Idle = CurTime() + 23133245636456436456
	end
	
if self.Owner:KeyReleased(IN_USE) and self.Inspecting == true then 
	if self.Inspecting == false then return end
	if self.CanInspect == false then return end
	self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("melee_inspect_end"))
	self.InspectEnd = CurTime() + self.Primary.Delay
	self.Idle = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
	end
if self.DoMelee and CurTime()>=self.DoMelee then
self.DoMelee = nil
self:Melee()
end
if self.Idle and CurTime()>=self.Idle then
self.Idle = nil
self.Owner:GetViewModel():SetSequence(self.Owner:GetViewModel():LookupSequence("fa_idle"))
end
end

/*---------------------------------------------------------
CanPrimaryAttack
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()
end


function SWEP:SecondaryAttack()
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

hook.Add("PostPlayerDeath","TF2CustomCandyremover",function(ply)
ply:SetColor(Color(255,255,255))
end)