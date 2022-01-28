-- managers.lua
-- Purpose: Manages managers (lol)
-- 2022/01/28

local Seikon = require(script.Parent.Parent)
local classic_require = require
local require = Seikon.require
local Log = require("core/tier1/log")

local Managers = {LoadedManagers = {}}

function Managers:Init()
    for _,Manager in pairs(script.Parent.Parent.managers:GetChildren()) do
        local ManagerInfo = classic_require(Manager)
        if ManagerInfo.Name ~= "" then
            ManagerInfo.Name = Manager.Name
        end

        Managers:CreateManager(ManagerInfo)
        Log:info("[MANAGERS] Load ->",Manager)
    end
end

function Managers:CreateManager(Info)
    if Info.Name == "CreateManager" then return end

    Managers.LoadedManagers[Info.Name] = Info
    if Info["Init"] then
        Info:Init()
    end
end

function Managers:FireManagerEvent(Event,...)
    for _,Manager in pairs(self.LoadedManagers) do
        
        if Manager[Event] then
            -- fire it with self
            Manager[Event](Manager,...)
        end
    end
end

function Managers:GetManager(Name)
    return self.LoadedManagers[Name]
end

Seikon.Managers = Managers
return Managers