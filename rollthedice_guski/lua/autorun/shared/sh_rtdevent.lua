RTDEvent = {}
RTDEvent.__index = RTDEvent

function RTDEvent:create(name, description, probability, func)
   local event = {}             
   setmetatable(event,RTDEvent) 
   event.name = name
   event.description = description
   event.probability = probability
   event.func = func
   return event
end

function RTDEvent:run(player)
    self.func(player)
end