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