local MatrixCtrl = {
    _status=nil
}

function MatrixCtrl:SetUp()
    spi.setup(1,spi.MASTER,spi.CPOL_LOW,spi.CPHA_LOW,16,8)
    spi.send(1,0x0900);
    spi.send(1,0x0a01);  --1~f
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
        print("l_s:",l_s)
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
end

return MatrixCtrl