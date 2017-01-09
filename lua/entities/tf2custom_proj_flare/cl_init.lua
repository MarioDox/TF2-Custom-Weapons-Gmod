include('shared.lua')

language.Add("tf_projectile_pipe", "Grenade")
killicon.Add("tf_projectile_pipe","sprites/bucket_grenlaunch",Color ( 255, 255, 255, 255 ) )

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
end
