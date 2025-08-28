local HttpService = game:GetService("HttpService")
JSON = {}
local function encodeVector3(v)
	return {__type = "Vector3", x = v.X, y = v.Y, z = v.Z}
end

local function encodeCFrame(cf)
	local components = {cf:GetComponents()}
	return {
		__type = "CFrame",
		components = components
	}
end

function JSON.stringify(data)
	local result = {}

	for key, value in pairs(data) do
		if typeof(value) == "Vector3" then
			result[key] = encodeVector3(value)
		elseif typeof(value) == "CFrame" then
			result[key] = encodeCFrame(value)
		else
			result[key] = value
		end
	end

	return HttpService:JSONEncode(result)
end

local function decodeVector3(t)
	return Vector3.new(t.x, t.y, t.z)
end

local function decodeCFrame(t)
	return CFrame.new(unpack(t.components))
end

function JSON.parse(json)
	local result = {}
	local data = HttpService:JSONDecode(json)

	for key, value in pairs(data) do
		if typeof(value) == "table" and value.__type == "Vector3" then
			result[key] = decodeVector3(value)
		elseif typeof(value) == "table" and value.__type == "CFrame" then
			result[key] = decodeCFrame(value)
		else
			result[key] = value
		end
	end

	return result
end

return JSON
