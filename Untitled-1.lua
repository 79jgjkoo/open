do 
    local Box = game.CoreGui:FindFirstChild("Box") if Box then 
        Box1:Destory()
        end
    end
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
Box1.Position = UDim2.new(0, 0, 0.449056596, 0)
Box1.Size = UDim2.new(0, 102, 0, 54)
Box1.Font = Enum.Font.Unknown
Box1.Text = "OPEN/CLOSE"
Box1.TextColor3 = Color3.fromRGB(85, 255, 0)
Box1.TextSize = 14.000
Box1.MouseButton1Click:Connect(function()
game.CoreGui.RobloxGui:FindFirstChild("Orion").Enabled = not game.CoreGui.RobloxGui:FindFirstChild("Orion").Enabled
end)
UICorner.Parent = Box1
