

--no X particle

game.AddParticles( "particles/bigboom.pcf" )
game.AddParticles( "particles/bigboom_dx80.pcf" )
game.AddParticles( "particles/explosion.pcf" )
game.AddParticles( "particles/explosion_dx80.pcf" )
game.AddParticles( "particles/explosion_dx90_slow.pcf" )
game.AddParticles( "particles/explosion_high.pcf" )
game.AddParticles( "particles/flamethrower.pcf" )
game.AddParticles( "particles/flamethrower_dx80.pcf" )
game.AddParticles( "particles/flamethrower_high.pcf" )
game.AddParticles( "particles/flamethrower_mvm.pcf" )
game.AddParticles( "particles/flamethrowerTest.pcf" )
game.AddParticles( "particles/items_demo.pcf" )
game.AddParticles( "particles/items_engineer.pcf" )
game.AddParticles( "particles/medicgun_attrib.pcf" )
game.AddParticles( "particles/medicgun_beam.pcf" )
game.AddParticles( "particles/medicgun_beam_dx80.pcf" )
game.AddParticles( "particles/rocketbackblast.pcf" )
game.AddParticles( "particles/rocketjumptrail.pcf" )
game.AddParticles( "particles/rockettrail.pcf" )
game.AddParticles( "particles/rockettrail_dx80.pcf" )
game.AddParticles( "particles/stickybomb.pcf" )
game.AddParticles( "particles/stickybomb_dx80.pcf" )
game.AddParticles("particles/muzzle_flash.pcf")
PrecacheParticleSystem("muzzle_pistol")
PrecacheParticleSystem("muzzle_sniperrifle")
PrecacheParticleSystem("muzzle_pistol")
PrecacheParticleSystem("muzzle_revolver")
PrecacheParticleSystem("muzzle_shotgun")
PrecacheParticleSystem("muzzle_smg")
PrecacheParticleSystem("muzzle_scattergun")
PrecacheParticleSystem("muzzle_scattergun_flash")
PrecacheParticleSystem("muzzle_minigun")
PrecacheParticleSystem("muzzle_bignasty")

AddCSLuaFile()

hook.Add("Think","TF2IgniteWater",function()
for k,v in pairs(ents.GetAll()) do
if v:GetNWBool("Burning") == true and v:WaterLevel() >= 2 then
v:SetNWBool("Burning",false)
v:StopParticles()
if CLIENT then
v:EmitSound("player/flame_out.wav")
end
if timer.Exists("TF2IgniteTimer"..v:EntIndex()) then 
timer.Remove("TF2IgniteTimer"..v:EntIndex())
end
if timer.Exists("TF2IgniteTimerEnd"..v:EntIndex()) then 
timer.Remove("TF2IgniteTimerEnd"..v:EntIndex())
end
end
end
end)

local meta = FindMetaTable( "Entity" )
function meta:TF2Ignite(time,repeats,dmg,attacker,inflictor,dmgtype,startnow,particle)
if SERVER then
if !time then
time = 1
end
if !repeats then
repeats = 1
end
if !particle then
ParticleEffectAttach( "burningplayer_red", 1, self,0 )
self:SetNWString("BurningParticle","burningplayer_red")
else
ParticleEffectAttach( particle, 1, self,0 )
self:SetNWString("BurningParticle",particle)
end
if startnow == true then
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_BURN )
end
self:TakeDamageInfo( dmgtable )
self:SetNWBool("Burning",true)
end
timer.Create("TF2IgniteTimer"..self:EntIndex(),time,repeats,function()
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) or self:WaterLevel() >= 3 then
self:SetNWBool("Burning",false)
if timer.Exists("TF2IgniteTimer"..self:EntIndex()) then 
timer.Remove("TF2IgniteTimer"..self:EntIndex())
end
else
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_BURN )
end
self:TakeDamageInfo( dmgtable )
self:SetNWBool("Burning",true)
end
end)
timer.Create("TF2IgniteTimerEnd"..self:EntIndex(),time*repeats,1,function()
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) or self:WaterLevel() >= 3 then
if timer.Exists("TF2IgniteTimerEnd"..self:EntIndex()) then 
timer.Remove("TF2IgniteTimerEnd"..self:EntIndex())
end
else
self:StopParticles()
self:SetNWBool("Burning",false)
end
end)
end
end

function meta:TF2Bleed(time,repeats,dmg,attacker,inflictor,dmgtype,startnow)
if SERVER then
if !time then
time = 1
end
if !repeats then
repeats = 1
end
if startnow == true then
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_SLASH )
end
self:TakeDamageInfo( dmgtable )
self:SetNWBool("Bleeding",true)
end
timer.Create("TF2BleedTimer"..self:EntIndex(),time,repeats,function()
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) then
self:SetNWBool("Bleeding",false)
if timer.Exists("TF2BleedTimer"..self:EntIndex()) then 
timer.Remove("TF2BleedTimer"..self:EntIndex())
end
else
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_SLASH )
end
self:TakeDamageInfo( dmgtable )
self:SetNWBool("Bleeding",true)
end
end)
timer.Create("TF2BleedTimerEnd"..self:EntIndex(),time*repeats,1,function()
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) then
if timer.Exists("TF2BleedTimerEnd"..self:EntIndex()) then 
timer.Remove("TF2BleedTimerEnd"..self:EntIndex())
end
else
self:StopParticles()
self:SetNWBool("Bleeding",false)
end
end)
end
end

function meta:TF2Stun(time,snd,particle,pos)
if SERVER then
if !time then
time = 1
end
if !snd then
self:EmitSound("player/pl_impact_stun.wav")
else
self:EmitSound(snd)
end
if !pos then
pos = 50
else
pos = pos
end
if !particle then
ParticleEffect( "bonk_text", self:GetPos() + self:GetAngles():Up() * pos, self:GetAngles(), self )
else
ParticleEffect( particle, self:GetPos() + self:GetAngles():Up() * pos, self:GetAngles(), self )
end
self:SetNWBool("TF2Stunned",true)
end
if self:IsPlayer() then
self:Freeze(true)
end
if self:IsNPC() then
self:SetNPCState( NPC_STATE_INVALID )
end
timer.Create("TF2StunnedTimer"..self:EntIndex(),time,1,function()
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) then
if timer.Exists("TF2StunnedTimer"..self:EntIndex()) then 
timer.Remove("TF2StunnedTimer"..self:EntIndex())
end
else
self:StopParticles()
self:SetNWBool("TF2Stunned",false)
if self:IsPlayer() then
self:Freeze(false)
end
if self:IsNPC() then
self:SetNPCState( NPC_STATE_IDLE )
end
end
end)
end

hook.Add("PostPlayerDeath","TF2Stun_stopondeath",function(ply)
if timer.Exists("TF2StunnedTimer"..ply:EntIndex()) then  timer.Remove("TF2StunnedTimer"..ply:EntIndex()) end
ply:SetNWBool("TF2Stunned",false)
end)

hook.Add("Think","TF2Stun_think",function()
for k,v in pairs(ents.GetAll()) do
if v:GetNWBool("TF2Stunned") then
if v:IsPlayer() then
if SERVER then
v:Freeze(true)
end
end
if v:IsNPC() then
if SERVER then
v:SetNPCState( NPC_STATE_INVALID )
end
end
end
end
end)




function meta:TF2CustomCurse(time,repeats,dmg,attacker,inflictor,dmgtype,startnow)
if SERVER then
if !time then
time = 1
end
if !repeats then
repeats = 1
end
if startnow == true then
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_SLASH )
end
self:TakeDamageInfo( dmgtable )
self:SetNWBool("TF2CCursed",true)
end
timer.Create("CTF2CurseTimer"..self:EntIndex(),time,repeats,function()
--self:SetNWBool("TF2CCursed",false)
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) then
self:SetNWBool("TF2CCursed",false)
if timer.Exists("CTF2CurseTimer"..self:EntIndex()) then 
timer.Remove("CTF2CurseTimer"..self:EntIndex())
end
else
local dmgtable = DamageInfo()
if dmg then
dmgtable:SetDamage( dmg )
end
if attacker and attacker:IsValid() then
dmgtable:SetAttacker( attacker )
end
if inflictor and inflictor:IsValid() then
dmgtable:SetInflictor( inflictor )
end
if dmgtype then
dmgtable:SetDamageType( dmgtype )
else
dmgtable:SetDamageType( DMG_SLASH )
end
self:TakeDamageInfo( dmgtable )
--self:SetNWBool("TF2CCursed",true)
end
end)
timer.Create("CTF2CurseTimerEND"..self:EntIndex(),time*repeats,1,function()
self:SetNWBool("TF2CCursed",false)
if !self or !self:IsValid() or (self:IsPlayer() and !self:Alive()) then
if timer.Exists("CTF2CurseTimerEND"..self:EntIndex()) then 
timer.Remove("CTF2CurseTimerEND"..self:EntIndex())
end
else
self:StopParticles()
self:SetNWBool("TF2CCursed",false)
end
end)
end
end

local CTF2darkness = Material( "effects/stealth_overlay" )

hook.Add( "HUDPaint", "TF2Custom_curseDark", function()
for k,v in pairs(player.GetAll()) do
if v:GetNWBool("TF2CCursed") == true then
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( CTF2darkness )
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
else
end
end
end)

hook.Add("Move", "TF2Custom_curseSlow", function(ply, move)
if ply:GetNWBool("TF2CCursed") == true then
local slow = (ply:GetMaxSpeed() - 25) * 0.75
if move:GetForwardSpeed()>slow then
move:SetForwardSpeed(slow)
end
if move:GetSideSpeed()>slow then
move:SetSideSpeed(slow)
end
end
end)

hook.Add("PostPlayerDeath","TF2Custom_curseEnd",function(ply)
if timer.Exists("CTF2CurseTimer"..ply:EntIndex()) then  timer.Remove("CTF2CurseTimer"..ply:EntIndex()) end
if timer.Exists("CTF2CurseTimerEND"..ply:EntIndex()) then  timer.Remove("CTF2CurseTimerEND"..ply:EntIndex()) end
ply:SetNWBool("TF2CCursed",false)
end)
