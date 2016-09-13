------------------------------------------
-- ����ģ��
------------------------------------------

require 'jnxkxmapper'
require 'tprint'

module(..., package.seeall)

-- �����ͼ����
local mapperStatus = mapper.open(GetInfo(66) .. 'rooms_all.h')
if (mapperStatus == 0) then
    print "��ͼ��������ʧ��"
end

local currentPath = {}

local convertToTable = function(path)
    local i=0
    _convpath={}
    re = rex.new("([^;]+)")
    n=re:gmatch(path,function (m, t)
        i=i+1
        _convpath[i]=m
    end)
    return _convpath
end

function doWalk(from,to,fly)
     local pathString = mapper.getpath(from,to,fly)
     if pathString == '' then
        print('δ�ҵ����ʵ�·����')
        return false
     else
        currentPath = convertToTable(pathString)
        tprint(currentPath)
        return true
     end
end
