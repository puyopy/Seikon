--[[
    Entrypoint for Seikon Framework
]]

local RunService = game:GetService("RunService")

local old_require = require
local require = require(script.path).require
local log = require("core/tier1/log")
local core = script.core

-- Main seikon namespace
local Seikon = {}
local Envrionment = RunService:IsClient()

if Envrionment then
    Seikon.Env = "Client"
else
    Seikon.Env = "Server"
end

Seikon.require = require

function Seikon:Initialize()
    for _,Core in pairs(script.core:GetChildren()) do
        if Core:IsA("ModuleScript") then
            old_require(Core):Init()
            log:info("[CORE] Load ->",Core)
        end
     end

     -- we have no real map so lets just "load" it
     Seikon.Managers:FireManagerEvent("OnMapLoad",workspace.Map)
end

return Seikon