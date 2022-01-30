local Instances = {}

function Instances:CreateInstance(Class : string,Parent : Instance,Properties : table?) : Instance
    local m_instance = Instance.new(Class)

    m_instance.Parent = Parent
    if Properties then
        for Property,Value in pairs(Properties) do
            m_instance[Property] = Value
        end
    end

    return m_instance
end

return Instances