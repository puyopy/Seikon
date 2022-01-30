local Transform = {Config = nil,Properties = {Speed = Vector3.new(),Client = false}}
Transform.__index = Transform

function Transform:Init(Instance,Configuration)
    local new_component = setmetatable({},self)

    new_component.Instance = Instance
    new_component.Config = Configuration
    new_component.Properties = Configuration:GetAttributes()

    return new_component
end

function Transform:Update()
    self.Instance.CFrame *= CFrame.Angles(math.rad(self.Properties.Speed.X),math.rad(self.Properties.Speed.Y),math.rad(self.Properties.Speed.Z))
end

return Transform