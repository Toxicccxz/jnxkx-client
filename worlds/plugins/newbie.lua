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

function player.eatYeguo()
    wait.make(function()
        while true do
            Execute("get ye guo")
            local line = wait.regexp("^[> ]*�������Ѿ���Ұ���ˣ��ö���Ҳ���˷ѡ�")
            if line ~= nil then
                break
            else
                line = wait.regexp("^[> ]*�����һöҰ��.*", 5)
                if line ~= nil then
                    break
                end
            end
        end

        Execute("eat ye guo")
    end)
end

function player.getHulu()
    wait.make(function()
        while true do
            Execute("get hulu")
            local line = wait.regexp(".*�����һ����«.*", 5)
            if line ~= nil then
                break
            end
        end
    end)
end