require "wait"

player = {
    gender = 1, -- 1��    2Ů
    currQuest = '',
}

function player.setGender(gender)
    if gender == "Ů" then
        player.gender = 2
    end
end

--require "jnxkxmapper"

--local mapData = mapper.open(GetInfo(66) .. 'rooms_all.h')

-- ��0�ŷ��䵽1�ŷ���
-- local path = mapper.getpath(0,1,0)

--local path = mapper.getpath(0,555,0)
--Note('path no fly ---->>>',path)