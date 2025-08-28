--[[local args = {
	"unit_tomato_plant",
	{
		Valid = true,
		Rotation = 180,
		CF = CFrame.new(-787.47607421875, 61.93030548095703, -213.0801544189453, -1, 0, -8.742277657347586e-08, 0, 1, 0, 8.742277657347586e-08, 0, -1),
		Position = vector.create(-787.47607421875, 61.93030548095703, -213.0801544189453)
	}
game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("PlaceUnit"):InvokeServer(unpack(args))
}]] 
JSON = loadstring(game:HttpGet('https://raw.githubusercontent.com/eltrul/shioru/refs/heads/main/json.lua'))() 

MacroRecorder = {
    Callbacks = {} 
} 

function MacroRecorder.StartRecording () 
    MacroRecorder.Keyframes = {}
    MacroRecorder.LastEmitted = tick()
    MacroRecorder.IsRecording = true 
end 

function MacroRecorder.StopRecording () 
    MacroRecorder.IsRecording = false 
end

function MacroRecorder.GetRecordData () 
    return JSON.stringify(MacroRecorder.Keyframes)
end 

function MacroRecorder.SubmitData (data) 
    table.insert(MacroRecorder.Keyframes, {
        type = 'wait', 
        data = tick() - MacroRecorder.LastEmitted
    }) 
    table.insert(MacroRecorder.Keyframes, {
        type = data.type, 
        data = data.data
    })
    MacroRecorder.LastEmitted = tick()
    for i, v in MacroRecorder.Callbacks do 
        if v[1] == 'NewKeyframeSubmitted' then 
            v[2](data)
        end 
    end 
end 

function MacroRecorder.On(EventType, Callback)
    table.insert(MacroRecorder.Callbacks, {
        EventType,
        Callback
    })
end

local old 
old = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    if self and typeof(self) == 'Instance' and tostring(self.Parent) == 'RemoteFunctions' then 
        if  MacroRecorder.IsRecording then 
            print(getnamecallmethod(), ...)
            MacroRecorder.SubmitData({
                type = getnamecallmethod(), 
                data = {...}
            })
        end 
    end 
    return old(self, unpack({...}))
end))

return MacroRecorder
