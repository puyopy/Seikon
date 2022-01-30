-- entities.lua
-- Purpose: Abstracts instances into entities with components.
-- 2022/01/28
local Seikon = require(script.Parent.Parent)
local RunService = game:GetService("RunService")
local s_require = Seikon.require
local Log = s_require("core/tier1/log")
local Instances = s_require("core/instances")

local ComponentsFolder = script.Parent.Parent.components
local Entities = {Name = 'Entities',ClientUpdate = {},Entities = {},UpdateThread = nil}

type Entity = {
    Components : table,
}
type Component = {
    Init : any,
    Properties : table,
    Update : any,
}

function Entities:Init()
    if Seikon.Env == "Client" then
        
    end
end

function Entities:OnMapLoad(Map)
    -- cleanup
    for i,v in pairs(self.Entities) do
        self.Entities[i] = nil
    end
    self.Entities = {}
    if self.UpdateThread then
        self.UpdateThread:Disconnect()
        self.UpdateThread = nil
    end

    local EntitiesFolder = Map.Entities:GetChildren()

    for _,Entity : Entity in pairs(EntitiesFolder) do
        if not Entity:FindFirstChild("Components") then
            Log:warn("No components folder in",Entity,"skipping..")
            continue 
        end
        
        Entities:AddEntity(Entity)
    end

    self.UpdateThread = RunService.Heartbeat:Connect(function()
        Entities:Update()
    end)
end

-- Switch to who owns a certain entity
-- Takes "Server" or "Client" as a parameter.
-- Caution: Entity will not update on the server
-- if it's owner is a client.
function Entities:SetNetworkOwner(NewOwner)
    if Seikon.Env == "Client" then Log:alert("Entity:SetNetworkOwner() can only be called on the authority server.") end

end

function Entities:AddEntity(Entity : Entity)
    local EntityTable = {Name = Entity.Name,Entity = Entity , Components = {}}
    local Components = Entity.Components:GetChildren()
    local ComponentCount = 0

    for _,Component in pairs(Components) do
        local ComponentModule = ComponentsFolder:FindFirstChild(Component.Name)

        if ComponentModule then
            ComponentModule = require(ComponentModule)
            local new_component = ComponentModule:Init(Entity,Component)
            EntityTable.Components[Component] = new_component
            ComponentCount += 1
        else
            Log:warn("Component",Component,"in entity",Entity,"does not have a valid behaviour module in",ComponentsFolder)
            continue
        end
    end
    
    table.insert(self.Entities,EntityTable)
    Log:info("Registered entity",Entity,"with",ComponentCount,"component(s)")
end

function Entities:GetEntity(Name : string)
    for _,Entity in pairs(self.Entities) do
        if Entity.Name == Name then
            return Entity
        end
    end

    Log:alert("No entity with the name",Name,"exists.")
end

-- Refresh every entity
function Entities:Update()
    for _,Entity : Entity in pairs(self.Entities) do
        for _,Component : Component in pairs(Entity.Components) do
            
            Component.Properties = Component.Config:GetAttributes()
            Component:Update()
        end
    end
end

return Entities