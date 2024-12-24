local assets = {}
local functions = {}
local connections = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local succ, err = pcall(function()
  assets.LocalPlayer = Players.LocalPlayer
  assets.Backpack = assets.LocalPlayer:WaitForChild("Backpack",10)

  assets.Cameras = Workspace:WaitForChild("Cameras",10)
  assets.Citizens = Workspace:WaitForChild("Citizens",10)
  assets.Criminals = Workspace:WaitForChild("Criminals",10)
  assets.Glass = Workspace:WaitForChild("Glass",10)
  assets.Police = Workspace:WaitForChild("Police",10)

  local Package = ReplicatedStorage:WaitForChild("Package",10)
  local AssetRemotes = Package:WaitForChild("Assets",10):WaitForChild("Remotes",10)
  local RegRemotes = Package:WaitForChild("Remotes",10)

  assets.MeleeRemote = AssetRemotes:WaitForChild("MeleeDamage",10)
  assets.GunRemote = AssetRemotes:WaitForChild("Damage",10)
  assets.FireRemote = AssetRemotes:WaitForChild("Bullet",10)
  assets.HitRemote = AssetRemotes:WaitForChild("HitObject",10)

  assets.YellRemote = RegRemotes:WaitForChild("PlayerYell",10)

  assets.Character = assets.LocalPlayer.Character
  assets.Humanoid = assets.Character and assets.Character:WaitForChild("Humanoid",10)
  assets.HumanoidRootPart = assets.Character and assets.Character:WaitForChild("HumanoidRootPart",10)
  assets.Stamina = assets.Character and assets.Character.Parent == assets.Criminals and assets.Character:WaitForChild("Stamina",10)
  assets.Speed = assets.Character and assets.Character.Parent == assets.Criminals and assets.Character:WaitForChild("BaseSpeed",10)
  assets.BodyBagSpeedChanger = assets.Character and assets.Character.Parent == assets.Criminals and assets.Character:WaitForChild("BagSpeed",10)

  assets.Primary = nil
  assets.Secondary = nil
  assets.Melee = nil

  if assets.Humanoid then
    assets.Humanoid:UnequipTools()
  end

  for i, v in ipairs(assets.Backpack:GetChildren()) do
    if v:FindFirstChild("Primary") then
      assets.Primary = v
    elseif v:FindFirstChild("Secondary") then
      assets.Secondary = v
    elseif v:FindFirstChild("Melee") then
      assets.Melee = v
    end
  end
end)

if not succ then
  warn("[APOLLO]: Failed to load certain assets. This may cause unexpected behaivor.")
end

if assets.Character then
  connections.CharacterUpdateValueConnection = assets.Character.AncestryChanged:Connect(function()
    if assets.Character.Parent == assets.Criminals then
      assets.Stamina = Character:WaitForChild("Stamina")
      assets.Speed = Character:WaitForChild("BaseSpeed")
      assets.BodyBagSpeedChanger = Character:WaitForChild("BagSpeed")
    end
  end)

  connections.CharacterCloseUpdateValueConnection = assets.Character.Destroying:Connect(function()
    if connections.CharacterUpdateValueConnection then
      connections.CharacterUpdateValueConnection:Disconnect()
      connections.CharacterUpdateValueConnection = nil -- cleanup
    end
  end)
end

connections.CharacterUpdateConnection = assets.LocalPlayer.CharacterAdded:Connect(function(Character: Model)
  assets.Character = Character
  assets.Humanoid = Character:WaitForChild("Humanoid")
  assets.HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

  if Character.Parent == assets.Criminals then
    assets.Stamina = Character:WaitForChild("Stamina")
    assets.Speed = Character:WaitForChild("BaseSpeed")
    assets.BodyBagSpeedChanger = Character:WaitForChild("BagSpeed")
  end

  connections.CharacterUpdateValueConnection = Character.AncestryChanged:Connect(function()
    if assets.Character.Parent == assets.Criminals then
      assets.Stamina = Character:WaitForChild("Stamina")
      assets.Speed = Character:WaitForChild("BaseSpeed")
      assets.BodyBagSpeedChanger = Character:WaitForChild("BagSpeed")
    end
  end)

  connections.CharacterCloseUpdateValueConnection = Character.Destroying:Connect(function()
    if connections.CharacterUpdateValueConnection then
      connections.CharacterUpdateValueConnection:Disconnect()
      connections.CharacterUpdateValueConnection = nil -- cleanup
    end
  end)
end)



connections.WeaponUpdateConnection = assets.Backpack.ChildAdded:Connect(function(v: Tool)
  if v:FindFirstChild("Primary") then
      assets.Primary = v
    elseif v:FindFirstChild("Secondary") then
      assets.Secondary = v
    elseif v:FindFirstChild("Melee") then
      assets.Melee = v
  end
end)

return assets, functions, connections
