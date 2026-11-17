local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer

local autofloor = {}

local ignorednames = {
    ["Terrain"] = true,
    ["Camera"] = true,
    ["Props"] = true,
    ["Values"] = true,
    ["Elevator"] = true,
    ["Lobby"] = true
}

local wintargets = {
    "WinPart",
    "WinPoint",
    "EndPlatform",
    "ENDBLOCK",
    "MiddleRing",
    "WinZone",
    "WinPool"
}

local safefloors = {
    ["Dance"] = true,
    ["FourCorners"] = true,
    ["SlimYim"] = true
}

local function getchar()
    local char = lp and lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and hrp then
        return char, hrp, hum
    end
    return nil, nil, nil
end

local function tp(target, offset)
    local char, hrp, hum = getchar()
    if not char or not hrp or not target then
        return false
    end

    local targetcf = nil
    if typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            targetcf = target.CFrame
        elseif target:IsA("Model") then
            targetcf = target:GetPivot()
        end
    elseif typeof(target) == "CFrame" then
        targetcf = target
    elseif typeof(target) == "Vector3" then
        targetcf = CFrame.new(target)
    end

    if targetcf then
        if typeof(offset) == "Vector3" then
            targetcf = targetcf + offset
        elseif typeof(offset) == "CFrame" then
            targetcf = targetcf * offset
        end
        if hum and hum.Sit then
            hum.Sit = false
        end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = targetcf
        return true
    end

    return false
end

local function isplayerchar(inst)
    for _, plr in ipairs(plrs:GetPlayers()) do
        if plr.Character == inst then
            return true
        end
    end
    return false
end

local function isvalidtarget(inst)
    return inst ~= nil and (inst:IsA("BasePart") or inst:IsA("Model"))
end

local function findwinpart(room)
    if not room then return nil end

    local build = room:FindFirstChild("Build")

    for _, name in ipairs(wintargets) do
        local direct = room:FindFirstChild(name)
        if isvalidtarget(direct) then
            return direct
        end
        if build then
            local indirect = build:FindFirstChild(name)
            if isvalidtarget(indirect) then
                return indirect
            end
        end
    end

    local targetset = {}
    for _, name in ipairs(wintargets) do
        targetset[name] = true
    end

    for _, desc in ipairs(room:GetDescendants()) do
        if targetset[desc.Name] and isvalidtarget(desc) then
            return desc
        end
    end

    return nil
end

local function getcurrentroom()
    local values = ws:FindFirstChild("Values")
    local curroom = values and values:FindFirstChild("CurrentRoom")
    if curroom and curroom.Value then
        local val = curroom.Value
        if typeof(val) == "Instance" and val.Parent then
            return val.Name, val
        end
        local name = tostring(val)
        if name ~= "" then
            local model = ws:FindFirstChild(name)
            if model then
                return name, model
            end
        end
    end

    for _, child in ipairs(ws:GetChildren()) do
        if (child:IsA("Model") or child:IsA("Folder")) and not ignorednames[child.Name] and not isplayerchar(child) then
            if safefloors[child.Name] or findwinpart(child) then
                return child.Name, child
            end
        end
    end

    return nil, nil
end

function autofloor:safespot()
    local elev = ws:FindFirstChild("Elevator")
    local ceil = elev and elev:FindFirstChild("Ceiling")
    local concrete = (ceil and ceil:FindFirstChild("Concrete")) or (elev and elev:FindFirstChild("Concrete", true))

    if isvalidtarget(concrete) then
        if tp(concrete, Vector3.new(0, 4, 0)) then
            return true, "Teleported to SafeSpot"
        end
    end

    return false, "Elevator ceiling not found"
end

function autofloor:complete()
    local name, room = getcurrentroom()
    if not name or not room then
        return false, "Supported floor not found"
    end

    if safefloors[name] then
        local ok = self:safespot()
        if ok then
            return true, "SafeSpot: " .. name
        end
        return false, "Failed to TP to SafeSpot"
    end

    local win = findwinpart(room)
    if win then
        if tp(win) then
            return true, "Completed: " .. name
        end
    end

    return false, "Unsupported floor: " .. tostring(name)
end

return autofloor
