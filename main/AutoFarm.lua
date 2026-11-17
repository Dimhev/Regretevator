local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")

local lp = plrs.LocalPlayer

local autofarm = {
    autogpu = false,
    gpurunning = false,
    autorocks = false,
    rocksrunning = false,
    farmingnow = false
}

local function getchar()
    local char = lp and lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and hrp and hum.Health > 0 then
        return char, hum, hrp
    end
    return nil, nil, nil
end

local function triggerprompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then
        return false
    end

    if type(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return true
    end

    pcall(function()
        prompt:InputHoldBegin()
        task.wait((prompt.HoldDuration > 0 and prompt.HoldDuration or 0.05) + 0.05)
        if prompt.Parent then
            prompt:InputHoldEnd()
        end
    end)
    return true
end

local function getrockpart(item)
    if item:IsA("BasePart") then
        return item
    end
    return item:FindFirstChildWhichIsA("BasePart", true)
end

local function findrockprompt(item)
    return item:FindFirstChild("PickUpRock")
        or item:FindFirstChildOfClass("ProximityPrompt")
        or item:FindFirstChild("PickUpRock", true)
        or item:FindFirstChildWhichIsA("ProximityPrompt", true)
end

function autofarm:farmbugboonce()
    if self.farmingnow then
        return false, "Already farming rocks"
    end

    local bugbo = ws:FindFirstChild("bugbo")
    local build = bugbo and bugbo:FindFirstChild("Build")
    local rocks = build and build:FindFirstChild("Rocks")

    if not rocks then
        return false, "bugbo floor not found"
    end

    local _, _, startHrp = getchar()
    if not startHrp then
        return false, "Character not ready"
    end

    self.farmingnow = true
    local savedcf = startHrp.CFrame
    local count = 0

    local ok, err = pcall(function()
        for _, item in ipairs(rocks:GetChildren()) do
            if not rocks.Parent then
                break
            end

            if item.Name == "Rock" or item:FindFirstChild("PickUpRock", true) then
                local prompt = findrockprompt(item)
                local part = getrockpart(item)

                if prompt and prompt.Enabled and part and part.Parent then
                    local _, _, hrp = getchar()
                    if not hrp then
                        break
                    end

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.12)

                    if prompt.Parent and prompt.Enabled then
                        triggerprompt(prompt)
                        count += 1
                        task.wait(0.06)
                    end
                end
            end
        end
    end)

    local _, _, endHrp = getchar()
    if endHrp and savedcf then
        endHrp.AssemblyLinearVelocity = Vector3.zero
        endHrp.CFrame = savedcf
    end

    self.farmingnow = false
    if not ok then
        return false, "Farm error: " .. tostring(err)
    end
    return true, "Collected rocks: " .. tostring(count)
end

function autofarm:togglebugborocks(state)
    self.autorocks = state
    if not state or self.rocksrunning then return end

    self.rocksrunning = true
    task.spawn(function()
        while self.autorocks do
            local bugbo = ws:FindFirstChild("bugbo")
            local build = bugbo and bugbo:FindFirstChild("Build")
            local rocks = build and build:FindFirstChild("Rocks")

            if rocks and not self.farmingnow then
                for _, item in ipairs(rocks:GetChildren()) do
                    local prompt = findrockprompt(item)
                    if prompt and prompt.Enabled then
                        self:farmbugboonce()
                        break
                    end
                end
            end

            task.wait(1.5)
        end
        self.rocksrunning = false
    end)
end

function autofarm:toggleautogpu(state)
    self.autogpu = state
    if not state or self.gpurunning then return end

    self.gpurunning = true
    task.spawn(function()
        while self.autogpu do
            local char, hum = getchar()
            local bp = lp and lp:FindFirstChild("Backpack")

            if char and hum and not lp:HasTag("Spectators") then
                local gpu = char:FindFirstChild("GenerationProcessingUnit")
                if not gpu and bp then
                    local bpgpu = bp:FindFirstChild("GenerationProcessingUnit")
                    if bpgpu then
                        hum:EquipTool(bpgpu)
                        task.wait(1.1)
                        if not self.autogpu then
                            break
                        end
                        gpu = char:FindFirstChild("GenerationProcessingUnit")
                    end
                end

                if gpu and gpu.Parent == char then
                    gpu:Activate()
                end
            end

            task.wait(0.85)
        end
        self.gpurunning = false
    end)
end

function autofarm:destroy()
    self.autogpu = false
    self.autorocks = false
end

return autofarm
