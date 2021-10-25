-- Useful functions to do with time

local Time = {}

-- Returns the Unix Timestamp in seconds
function Time:GetCurrentUnixTime()
	local now = DateTime.now()

	return now.UnixTimestamp
end

-- Returns the Unix Timestamp in milliseconds
function Time:GetCurrentUnixTimeMillis()
	local now = DateTime.now()

	return now.UnixTimestampMillis
end

return Time