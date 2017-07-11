IO_TEST = 4
gpio.mode(IO_TEST, gpio.INT)


function onBtnEvent(lv)
    print('both~'..lv)
end
gpio.trig(IO_TEST, 'both', onBtnEvent)