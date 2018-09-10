redis.replicate_commands()

local function init()
  redis.call('FLUSHALL')
  for i = 1, 100, 1
  do
	redis.call('SADD', 'parking_spot', i)
  end
end

local function findEmptyParkingSpot()
  local emptySpot = redis.call('SRANDMEMBER', 'parking_spot')
  redis.call('SREM', 'parking_spot', emptySpot)
  return emptySpot
end

local function getAirplaneParkingSpot(airplaneId)
  local parkingId = redis.call('HGET', airplaneId, 'parking')
  if parkingId == false then
    parkingId = findEmptyParkingSpot()
    redis.call('HMSET', airplaneId, 'parking', tostring(parkingId))
  end
  return parkingId
end

local function test()
  for i = 1, 80, 1
  do
    local airplaneId = "Airplane_"..i
    getAirplaneParkingSpot(airplaneId)
  end
end


-- first run init(), then call test() for automatic or manual testing from input console

-- init()
-- test()

-- manual testing
local airplaneId = tonumber(KEYS[1])
airplaneId = "Airplane_"..airplaneId
return getAirplaneParkingSpot(airplaneId)
