local Variables, Functions, Connections = {},{},{}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

ReplicatedStorage:WaitForChild("Assets")
Players.LocalPlayer:WaitForChild("Replicated")
Players.LocalPlayer:WaitForChild("PlayerScripts")

local function findGame(GameId: string): Model
    local GameType
    for i, v in ipairs(workspace:GetChildren()) do
        if v.Name:lower():find("game") and v:IsA("Folder") and #v:GetChildren() >= 1 and v:FindFirstChild(GameId) then
            return v[GameId]
        end
    end
end

local GameId = Players.LocalPlayer.Replicated.GameID
local InitScript = Players.LocalPlayer.PlayerScripts.ClientMain

Variables.CurrentGame = GameId.Value and findGame(GameId.Value)
Variables.CurrentTeam = Players.LocalPlayer.Replicated.TeamID.Value
Variables.GameMechanics = require(InitScript.Utilities.Variables).Mechanics
Variables.MechanicSettings = require(ReplicatedStorage.Assets.Modules.Client.Mechanics)
Variables.Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

Functions.GetPlayersInActiveGame = function(): Player | {Player}?
    if not GameId.Value then
        return
    end

    local PlayersInGame = {}
    for i, v in ipairs(Players:GetPlayers()) do
        if v == Players.LocalPlayer then
            continue
        end

        local PlayerGameId = v:FindFirstChild("Replicated") and v.Replicated:FindFirstChild("GameID").Value

        if not PlayerGameId then
            continue
        elseif PlayerGameId == GameId.Value then
            table.insert(PlayersInGame, v)
        end
    end

    return #PlayersInGame <= 0 and nil or #PlayersInGame == 1 and PlayersInGame[1] or PlayersInGame
end

Functions.IsPlayerTeamate = function(TargetPlayer: Player): boolean
    local PlayerTeamId = v:FindFirstChild("Replicated") and v.Replicated:FindFirstChild("TeamID").Value

    if not PlayerGameId then
        continue
    end
    return PlayerGameId == Variables.CurrentTeam and true
end

Function.EditMechanicFunction = function(Callback, Flag: string)
    if typeof(Callback) ~= "function" or not Flag then
        return
    end
    Variables.GameMechanics[Flag] = function()
        Callback(Variables.MechanicSettings)
    end
end

Function.RunMechanic = function(Flag: string)
    if not Flag then
        return
    end
    Variables.GameMechanics[Flag](Variables.MechanicSettings)
end

Function.ModifyMechanicSetting(Flag: string, Value: any)
    if not Flag or not Value then
        return
    end
    Variables.MechanicSettings[Flag] = Value
end

Function.GetClosestPlayer = function(MaxDistance: number, PlayerTable: {Player}): Player
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local Check = PlayerTable or Players:GetPlayers()
    local Closest, Distance = nil, MaxDistance or math.huge
    for i, v in ipairs(Check) do
        local TargetRoot = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
        if not TargetRoot or v == Players.LocalPlayer then
            continue
        end

        local Magnitude = (Character.HumanoidRootPart.Position - TargetRoot.Position).Magnitude
        if Magnitude < Distance then
            Closest = v
            Distance = Magnitude
        end
    end

    return Closest
end

Function.GetPlayerWithBall = function(PlayerTable: {Player}): Player
    local Check = PlayerTable or Players:GetPlayers()

    for i, v in ipairs(Check) do
        local TargetCharacter = v.Character
        if not TargetCharacter or v == Players.LocalPlayer then
            continue
        end

        local Football = TargetCharacter:FindFirstChild("FootballCircle",true) or TargetCharacter:FindFirstChild("Football")
        if Football and Football:IsA("BillboardGui") or Football:IsA("BasePart") then
            return v
        end
    end
end

Connections.CharacterAdded = Players.LocalPlayer.CharacterAdded:Connect(function(c)
    Variables.Character = c
end)

Connections.OnGameIdChange = GameId.Changed:Connect(function()
    Variables.CurrentGame = findGame(GameId.Value)
end)

return Variables, Functions, Connections
