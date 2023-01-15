RTDEvent = {}
RTDEvent.__index = RTDEvent

function RTDEvent:create(name, description, probability, func)
   local event = {}             
   setmetatable(event,RTDEvent) 
   event.name = name
   event.description = description
   event.probability = probability
   event.func = func
   event.disableFunc = nil
   return event
end

function RTDEvent:setDisableFunction(func)
    self.disableFunc = func
end

function RTDEvent:disable(player)
    if self.disableFunc ~= nil then
        self.disableFunc(self,player)
    end
end

function RTDEvent:run(player, round_identifier)
    self.func(self, player, round_identifier)
end