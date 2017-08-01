print("start");
spi.setup(1,spi.MASTER,spi.CPOL_LOW,spi.CPOL_LOW,16,8);
spi.send(1,0x0900);
spi.send(1,0x0a01);  --1~f
spi.send(1,0x0b07);
spi.send(1,0x0c01);


--spi.setup(1,spi.MASTER,spi.CPOL_LOW,spi.CPOL_LOW,16,8);
--//[[
spi.send(1,0x0146);
spi.send(1,0x0249);
spi.send(1,0x0349);
spi.send(1,0x0476);
spi.send(1,0x0597);
spi.send(1,0x0696);
spi.send(1,0x0765);
spi.send(1,0x0867);
--]]

--[[dox
spi.send(1,0x0130);
spi.send(1,0x02e0);
spi.send(1,0x03e0);
spi.send(1,0x0462);
spi.send(1,0x057d);
spi.send(1,0x067c);
spi.send(1,0x076c);
spi.send(1,0x086c);
]]
--spi.send(1,0x0f,0x00);

-- function MatrixCtrl:Set(row,col,type)
--     local c_n = row * 0x100
--     local l_s = self._status[row]
--     if type then
--         l_s = bit.set(l_s,8-col)
--     else
--         l_s = bit.clear(l_s,8-col)
--     end

--     spi.send(1,c_n+l_s)
-- end

    --[[spi.send(1,0x0100);
    spi.send(1,0x0200);
    spi.send(1,0x0300);
    spi.send(1,0x0400);
    spi.send(1,0x0500);
    spi.send(1,0x0600);
    spi.send(1,0x0700);
    spi.send(1,0x0800);
    ]]