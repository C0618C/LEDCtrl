local GpioCtrl ={}

function GpioCtrl:Info()
    local _list ={}
    for i=0,12 do
        --gpio.mode(i, gpio.INPUT)
        _list[i]=gpio.read(i)
    end
    return _list
end

function GpioCtrl:Low(pin)
    pin = tonumber(pin)
    if not pin or pin < 0 or pin > 12 then return false end
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.LOW)
    return true
end

function GpioCtrl:High(pin)
    pin = tonumber(pin)
    if not pin or pin < 0 or pin > 12 then return false end
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, gpio.HIGH)
    return true
end

function GpioCtrl:Toggle(pin)
    pin = tonumber(pin)
    if not pin or pin < 0 or pin > 12 then return false end
    local val = gpio.read(pin)
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, val == gpio.HIGH and gpio.LOW or gpio.HIGH)
    return true
end

function GpioCtrl:On(pin)
    return self:High(pin)
end
function GpioCtrl:Off(pin)
    return self:Low(pin)
end


return GpioCtrl