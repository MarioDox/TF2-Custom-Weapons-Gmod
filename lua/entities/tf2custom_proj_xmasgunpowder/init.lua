
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()
local playerown = self:GetOwner()
self:SetModel("models/weapons/c_models/c_xms_festive_ornament.mdl")
self:SetMoveType( MOVETYPE_VPHYSICS )
self:SetSolid( SOLID_VPHYSICS )
self:PhysicsInit( SOLID_VPHYSICS )
self:SetNetworkedString("Owner", "World")
local phys = self:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
end

local prop = ents.Create("prop_dynamic")
prop:SetModel("models/player/items/soldier/xms_soldier_ornaments.mdl")
prop:SetPos(self:GetPos() + self:GetAngles():Forward() * 58 + self:GetAngles():Up() * -10 + self:GetAngles():Right() * 2)
prop:SetAngles(self:GetAngles())
prop:SetParent(self)
prop:ManipulateBoneScale( prop:LookupBone("prp_grenade_top"), Vector(0,0,0) )
prop:Spawn()
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
end

hook.Add("PostPlayerDeath","TF2Customgrenadexmasstopply",function(ply)
if timer.Exists("freezed"..ply:EntIndex()) then timer.Remove("freezed"..ply:EntIndex()) end
end)

hook.Add("OnNPCKilled","TF2Customgrenadexmasstopnpc",function(npc,att,inf)
if timer.Exists("freezed"..npc:EntIndex()) then timer.Remove("freezed"..npc:EntIndex()) end
end)


function ENT:Use(activator)
end

function ENT:PhysicsCollide()
for k,v in pairs(ents.FindInSphere(self:GetPos(),170)) do
if v:IsPlayer() then
v:Freeze(true)
timer.Create("freezed"..v:EntIndex(),3,1,function()
v:Freeze(false)
end)
elseif v:IsNPC() then
if SERVER then
v:SetNPCState( NPC_STATE_INVALID )
end
timer.Create("freezed"..v:EntIndex(),3,1,function()
if SERVER then
v:SetNPCState( NPC_STATE_IDLE )
end
end)
end
end
self:EmitSound("weapons/ball_buster_break_01.wav")
local explosion = ents.Create( "info_particle_system" )
explosion:SetKeyValue( "effect_name", "xms_snowburst" )
explosion:SetPos( self:GetPos()	) 
explosion:SetAngles( self:GetAngles() )
explosion:Spawn()
explosion:Activate() 
explosion:Fire( "Start", "", 0 )
explosion:Fire( "Kill", "", 0.1 )
self:Remove()
end