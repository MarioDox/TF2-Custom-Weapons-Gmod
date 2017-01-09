
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
local playerown = self:GetOwner()
self:SetModel("models/weapons/c_models/c_sapper/c_sapper.mdl")
self:SetMoveType( MOVETYPE_VPHYSICS )
self:SetSolid( SOLID_VPHYSICS )
self:PhysicsInit( SOLID_VPHYSICS )
self:SetNetworkedString("Owner", "World")
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
end
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
for k,v in pairs(ents.FindInSphere(self:GetPos(),10)) do
if v:IsPlayer() and not self.Owner then
self:Remove()
local ratio = 0
if SERVER then
v:SetNWAngle("beforesapangle",v:EyeAngles())
v:SetNWBool("sapped",true)
timer.Create("sappingplayer"..v:EntIndex(),.1,100,function()
--v:SetEyeAngles(Angle(math.random(0,180),math.random(0,180),0))
ratio = ratio + 0.1
v:SetEyeAngles( Lerp( ratio, Angle(math.random(0,180),math.random(0,180),0), Angle(math.random(0,180),math.random(0,180),0) ) )
end)
timer.Create("sappingplayerend"..v:EntIndex(),10,1,function()
v:SetEyeAngles(v:GetNWAngle("beforesapangle"))
v:SetNWBool("sapped",false)
end)
end
elseif v:IsNPC() then
self:Remove()
if SERVER then
v:SetNWAngle("beforesapangle",v:GetAngles())
v:SetNWBool("sapped",true)
local ratio = 0
timer.Create("sappingnpc"..v:EntIndex(),.1,100,function()
if !v:IsValid() then return end
--v:SetAngles(Angle(0,math.random(0,180),0))
ratio = ratio + 0.5
v:SetAngles( Lerp( ratio, Angle(0,math.random(0,180),0), Angle(0,math.random(0,180),0) ) )
end)
timer.Create("sappingnpcend"..v:EntIndex(),10,1,function()
if !v:IsValid() then return end
v:SetAngles(v:GetNWAngle("beforesapangle"))
v:SetNWBool("sapped",false)
end)
end
end
end
end

hook.Add("PostPlayerDeath","HumanSapperstopply",function(ply)
if timer.Exists("sappingplayer"..ply:EntIndex()) then timer.Remove("sappingplayer"..ply:EntIndex()) end
if timer.Exists("sappingplayerend"..ply:EntIndex()) then timer.Remove("sappingplayerend"..ply:EntIndex()) end
ply:SetNWBool("sapped",false)
end)

hook.Add("OnNPCKilled","HumanSapperstopnpc",function(npc,att,inf)
if timer.Exists("sappingplayer"..npc:EntIndex()) then timer.Remove("sappingplayer"..npc:EntIndex()) end
if timer.Exists("sappingplayerend"..npc:EntIndex()) then timer.Remove("sappingplayerend"..npc:EntIndex()) end
end)


function ENT:Use(activator)
if activator:IsPlayer() then
activator:Give("tf2custom_humansapper")
self:Remove()
end
end

function ENT:OnTakeDamage()
if SERVER then
local r = ents.Create("prop_physics")
r:SetModel("models/buildables/gibs/sapper_gib002.mdl")
r:SetPos(self:GetPos())
r:SetAngles(self:GetAngles())
if r:GetPhysicsObject():IsValid() and self:GetPhysicsObject():IsValid() then
r:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity())
end
r:Spawn()
self:Remove()
end
self:EmitSound("weapons/sapper_removed.wav")
end