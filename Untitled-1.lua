local Box = Instance.new("ScreenGui")
local Box1 = Instance.new("TextButton")
Box.Name = "Box"
Box.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Box.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Box1.Name = "Box1"
Box1.Parent = Box
Box1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Box1.BorderColor3 = Color3.fromRGB(0, 0, 0)
Box1.BorderSizePixel = 0
Box1.Position = UDim2.new(0.437271625, 0, 0.449056596, 0)
Box1.Size = UDim2.new(0, 102, 0, 54)
Box1.Font = Enum.Font.Unknown
Box1.Text = "OPEN/CLOSE"
Box1.TextColor3 = Color3.fromRGB(85, 255, 0)
Box1.TextSize = 14.000
Box1.MouseButton1Click:Connect(function()
game.CoreGui:FindFirstChild("ScreenGui").Enabled = not game.CoreGui:FindFirstChild("ScreenGui").Enabled
end)
UICorner.Parent = Box1

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x3fall3nangel/mercury-lib-edit/master/src.lua"))()

local GUI = Library:Create{
    Name = "Mercury",
    Size = UDim2.fromOffset(600, 400),
    Theme = Library.Themes.Serika,
    Link = "https://github.com/deeeity/mercury-lib"
}

local Main = GUI:tab{
    Name = "Main",
    Icon = "rbxassetid://8569322835" -- rbxassetid://2174510075 home icon
}


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local lp = Players.LocalPlayer
local Systems = ReplicatedStorage:WaitForChild("Systems")

local Race = lp.PlayerGui.Score.Frame.Race
local Timer
local Laps

local Driveworld = {}

for i,v in pairs(getconnections(Players.LocalPlayer.Idled)) do
    if v["Disable"] then
        v["Disable"](v)
    elseif v["Disconnect"] then
        v["Disconnect"](v)
    end
end

local function getchar()
    return lp.Character or lp.CharacterAdded:Wait()
end

local function isvehicle()
    for i,v in next, workspace.Cars:GetChildren() do
        if (v:IsA("Model") and v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == lp) then
            if v:FindFirstChild("CurrentDriver") and v:FindFirstChild("CurrentDriver").Value == lp then
                return true
            end
        end
    end
    return false
end

local function getvehicle()
    for i,v in next, workspace.Cars:GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == lp then
            return v
        end
    end
    return
end


Main:Toggle({
    Name = "Auto Delivery Trailer",
	StartingState = false,
    Description = "Use Full-E or Casper for more money(work in USA map only)",
	Callback = function(state)
        Driveworld["de"] = state
    end
})

task.spawn(function()
    while task.wait() do
        if Driveworld["de"] then
            pcall(function()
                if not setfpscap then return end
                    local UserInputService, RunService = game:GetService("UserInputService"), game:GetService("RunService")
                        UserInputService.WindowFocusReleased:Connect(function()
                            RunService:Set3dRenderingEnabled(false); setfpscap(5)
                                end)
                                UserInputService.WindowFocused:Connect(function()
                                    RunService:Set3dRenderingEnabled(true); setfpscap(999)
                                        end)
                if not isvehicle() then
                    local Cars = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(lp.Name):WaitForChild("Inventory"):WaitForChild("Cars")
                    local Truck = Cars:FindFirstChild("FullE") or Cars:FindFirstChild("Casper")
                    local normalcar = Cars:FindFirstChildWhichIsA("Folder")
                    if Truck then
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(Truck)
                    else
                        Systems:WaitForChild("CarInteraction"):WaitForChild("SpawnPlayerCar"):InvokeServer(normalcar)
                    end
                    getchar().HumanoidRootPart.CFrame = getvehicle().PrimaryPart.CFrame
                    task.wait(1)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                end
                local completepos
                local distance
                local jobDistance
                local CompletionRegion
                local job = lp.PlayerGui.Score.Frame.Jobs
                repeat task.wait()
                    if job.Visible == false and Driveworld["autodelivery"] then
                        Systems:WaitForChild("Jobs"):WaitForChild("StartJob"):InvokeServer("TrailerDelivery", "F")
                    end
                until job.Visible == true or Driveworld["autodelivery"] == false
                print("Start Job")
                repeat task.wait() 
                    CompletionRegion = workspace:WaitForChild("CompletionRegion", 3)
                    if CompletionRegion then
                        distance = CompletionRegion:FindFirstChild("Primary"):FindFirstChild("DestinationIndicator"):FindFirstChild("Distance").Text
                        local yeas = string.split(distance, " ")
                        for i,v in next, yeas do
                            if tonumber(v) then
                                if tonumber(v) < 2.1 then
                                    Systems:WaitForChild("Jobs"):WaitForChild("StartJob"):InvokeServer("TrailerDelivery", "F")
                                else
                                    jobDistance = v
                                    print("Trailer Job Distance : " .. jobDistance)
                                    break
                                end
                            end
                        end
                    end
                until jobDistance and tonumber(jobDistance) > 2.1 or Driveworld["autodelivery"] == false
                if CompletionRegion:FindFirstChild("Primary") then
                    completepos = CompletionRegion:FindFirstChild("Primary").CFrame
                end
                for i = 1, 25 do
                    if not Driveworld["autodelivery"] or not getvehicle() or not getchar() then
                        return
                    end
                    task.wait(1)
                end
                Systems:WaitForChild("Navigate"):WaitForChild("Teleport"):InvokeServer(completepos)
                task.wait(.5)
                Systems:WaitForChild("Jobs"):WaitForChild("CompleteJob"):InvokeServer()
                task.wait(.5)
                if lp.PlayerGui.JobComplete.Enabled == true then
                    Systems:WaitForChild("Jobs"):WaitForChild("CashBankedEarnings"):FireServer()
                    firesignal(lp.PlayerGui.JobComplete.Window.Content.Buttons.Close.MouseButton1Click)
                end
                print("Completed Job")    
            end)
        end
    end
end)