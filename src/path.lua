-- path.lua
-- Purpose: Manages relative paths (ex. core/tier1/log.lua)
-- 2022/01/28

local path = {}

function path.require (Path)
    local CurrentFolder = script.Parent
    local PathSplit = Path:split("/")
    local EndFile = PathSplit[#PathSplit]
    local CurrentIndex = 1

    for _,PathFolder in pairs(PathSplit) do
        local RealFolder = CurrentFolder:FindFirstChild(PathFolder)
        if RealFolder then
            if RealFolder:IsA("Folder") then
                
                CurrentFolder = RealFolder
            elseif RealFolder:IsA("ModuleScript")  then
                
                if RealFolder.Name == EndFile and RealFolder:IsA("ModuleScript") then
                    return require(RealFolder)
                end
            end
        else
            local ModifiedPathString = PathFolder.."[HERE]"
            local ModifiedPath = Path

            ModifiedPath = ModifiedPath:gsub(PathFolder,ModifiedPathString)
            return error("[PATH] Incorrect path specified: "..ModifiedPath,0)
        end

        CurrentIndex += 1
    end
end

return path