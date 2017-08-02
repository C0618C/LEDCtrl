local MatrixCtrl = {
    _status=nil,
    _brightness = 1
}

function MatrixCtrl:SetUp()
    spi.setup(1,spi.MASTER,spi.CPOL_LOW,spi.CPHA_LOW,16,8)
    spi.send(1,0x0900);
    MatrixCtrl.SetBrightness(self,1)    --spi.send(1,0x0a01);  --1~f
    spi.send(1,0x0b07);
    spi.send(1,0x0c01);

    MatrixCtrl._status = {0,0,0,0,0,0,0,0}

    MatrixCtrl.Off()
end

function MatrixCtrl:SetData(_row,_col,_type)
    local c_n = _row * 0x100
    local l_s = MatrixCtrl._status[_row]

    if _type == 'true' then
        l_s = bit.set(l_s,8-_col)
    elseif _type == 'false' then
        l_s = bit.clear(l_s,8-_col)
    end

    MatrixCtrl._status[_row] = l_s
    spi.send(1,c_n+l_s)
end

function MatrixCtrl:Off()
    spi.send(1,0x0100);
    spi.send(1,0x0200);
    spi.send(1,0x0300);
    spi.send(1,0x0400);
    spi.send(1,0x0500);
    spi.send(1,0x0600);
    spi.send(1,0x0700);
    spi.send(1,0x0800);

    collectgarbage()
end
function MatrixCtrl:On()
    spi.send(1,0x01ff);
    spi.send(1,0x02ff);
    spi.send(1,0x03ff);
    spi.send(1,0x04ff);
    spi.send(1,0x05ff);
    spi.send(1,0x06ff);
    spi.send(1,0x07ff);
    spi.send(1,0x08ff);

    collectgarbage()
end

function MatrixCtrl:SetBrightness(value)
    MatrixCtrl._brightness = value
    spi.send(1,0x0a00+value);
    collectgarbage()
end

collectgarbage()

return MatrixCtrl