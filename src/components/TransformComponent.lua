local Transform = {Config = nil,Properties = {Position = Vector3.new(),Rotation = Vector3.new()}}
Transform.__index = Transform

function Transform:Init(Instance,Configuration)
    local new_component = setmetatable({},self)

    new_component.Instance = Instance
    new_component.Config = Configuration
    new_component.Properties = Configuration:GetAttributes()

    return new_component
end

function Transform:Update()
    
    self.Instance.Position = self.Properties.Position
    self.Instance.Orientation = self.Properties.Rotation
end

return Transform