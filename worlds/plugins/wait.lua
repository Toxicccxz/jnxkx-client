-- wait.lua
-- ----------------------------------------------------------
-- 'wait' stuff - lets you build pauses into scripts.
-- See forum thread:
--   http://www.gammon.com.au/forum/?id=4957
--
--Modified by simon
--Date 2013.12.10
--Email:hapopen@gmail.com
-- ----------------------------------------------------------

--[[

Example of an alias 'send to script':


require "wait"

wait.make (function ()  --- coroutine below here

  repeat
    Send "cast heal"
    line, wildcards = 
       wait.regexp ("^(You heal .*|You lose your concentration)$")

  until string.find (line, "heal")

  -- wait a second for luck
  wait.time (1) 

end)  -- end of coroutine

--]]

require "check"

module (..., package.seeall)

-- ----------------------------------------------------------
-- table of outstanding threads that are waiting
-- ----------------------------------------------------------
local threads = {}

-- ----------------------------------------------------------
-- wait.timer_resume: called by a timer to resume a thread
-- ----------------------------------------------------------
function timer_resume (name)
  local thread = threads [name]
  if thread then
    threads [name] = nil
    local ok, err = coroutine.resume (thread)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in timer function (in wait module).")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end -- function timer_resume 

-- ----------------------------------------------------------
-- wait.trigger_resume: called by a trigger to resume a thread
-- ----------------------------------------------------------
function trigger_resume (name, line, wildcards, styles)
  local thread = threads [name]
  if thread then
    threads [name] = nil
    local ok, err = coroutine.resume (thread, line, wildcards, styles)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in trigger function (in wait module)")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end -- function trigger_resume 

-- ----------------------------------------------------------
-- convert x seconds to hours, minutes, seconds (for AddTimer)
-- ----------------------------------------------------------
local function convert_seconds (seconds)
  local hours = math.floor (seconds / 3600)
  seconds = seconds - (hours * 3600)
  local minutes = math.floor (seconds / 60)
  seconds = seconds - (minutes * 60)
  return hours, minutes, seconds
end -- function convert_seconds 

-- ----------------------------------------------------------
-- wait.time: we call this to wait in a script
-- ----------------------------------------------------------
function time (seconds)
  local id = "wait_timer_" .. GetUniqueNumber ()
  threads [id] = assert (coroutine.running (), "Must be in coroutine")

  local hours, minutes, seconds = convert_seconds (seconds)

  check (AddTimer (id, hours, minutes, seconds, "",
                  bit.bor (timer_flag.Enabled,
                           timer_flag.OneShot,
                           timer_flag.Temporary,
                           timer_flag.ActiveWhenClosed,
                           timer_flag.Replace), 
                   "wait.timer_resume"))

  return coroutine.yield ()
end -- function time

-- ----------------------------------------------------------
-- wait.regexp: we call this to wait for a trigger with a regexp
-- ----------------------------------------------------------
function regexp (regexp, timeout, flags, multi, multi_lines)
  if type(regexp) == "table" then
    local s="("
    for k,v in pairs(regexp) do
      if k~=1 then
        s=s.."|"
      end
      s=s..v
    end
    s=s..")"
    regexp=s
  end
  local id = "wait_trigger_" .. GetUniqueNumber ()
  threads [id] = assert (coroutine.running (), "Must be in coroutine")
            
  check (AddTriggerEx (id, regexp, 
            "-- added by wait.regexp",  
            bit.bor (flags or 0, -- user-supplied extra flags, like omit from output
                     trigger_flag.Enabled, 
                     trigger_flag.RegularExpression,
                     trigger_flag.Temporary,
                     trigger_flag.Replace,
                     trigger_flag.OneShot),
            custom_colour.NoChange, 
            0, "",  -- wildcard number, sound file name
            "wait.trigger_resume", 
            12, 100))  -- send to script (in case we have to delete the timer)
  if (multi ~= nil) and multi then
    SetTriggerOption (id, "multi_line", multi)
    if (multi_lines ~= nil) then
      SetTriggerOption (id, "lines_to_match", multi_lines)
    end
  end
  -- if timeout specified, also add a timer
  if timeout and timeout > 0 then
    local hours, minutes, seconds = convert_seconds (timeout)

    -- if timer fires, it deletes this trigger
    check (AddTimer (id, hours, minutes, seconds, 
                   "DeleteTrigger ('" .. id .. "')",
                   bit.bor (timer_flag.Enabled,
                            timer_flag.OneShot,
                            timer_flag.Temporary,
                            timer_flag.ActiveWhenClosed,
                            timer_flag.Replace), 
                   "wait.timer_resume"))

    check (SetTimerOption (id, "send_to", "12"))  -- send to script

    -- if trigger fires, it should delete the timer we just added
    check (SetTriggerOption (id, "send", "DeleteTimer ('" .. id .. "')"))  

  end -- if having a timeout

  return coroutine.yield ()  -- return line, wildcards
end -- function regexp 

-- ----------------------------------------------------------
-- wait.match: we call this to wait for a trigger (not a regexp)
-- ----------------------------------------------------------
function match (match, timeout, flags)
  return regexp (MakeRegularExpression (match), timeout, flags)
end -- function match 

-- ----------------------------------------------------------
-- wait.make: makes a coroutine and resumes it
-- ----------------------------------------------------------
function make (f)
  assert (type (f) == "function", "wait.make requires a function")
  assert (GetOption ("enable_timers") == 1, "Timers not enabled")
  assert (GetOption ("enable_triggers") == 1, "Triggers not enabled")
  coroutine.wrap (f) () -- make coroutine, resume it
end -- make


------------------------------------------
--�ഥ����ʱ����ʱ�ص��õĺ���
--
--return  �����½��Ķ���
------------------------------------------
function timer_mulresume (name)
  DeleteTriggerGroup(name)
  local thread = threads [name]
  if thread then
    threads [name] = nil
    local ok, err = coroutine.resume (thread)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in timer function (in wait module).")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end -- function timer_mulresume 

------------------------------------------
--�ഥ���ص��õĺ���
--
--return  �����½��Ķ���
------------------------------------------
function trigger_mulresume (name, line, wildcards, styles)
  local gp=GetTriggerOption(name,"group")
  DeleteTriggerGroup(gp)
  DeleteTimer(gp)  
  local thread = threads [gp]
  if thread then
    threads [gp] = nil
    local ok, err = coroutine.resume (thread, line, wildcards, styles)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in trigger function (in wait module)")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end -- function trigger_mulresume 

------------------------------------------
--�ú����ȴ�������򴥷����ء��κ�һ���������غ���������Ҳ��ʧЧ��
--@regexps   ������ʽ�б�{������ʽ,�Ƿ���д���,��������}
--@timeout   ��ʱʱ��
--@flags     ���������Ա��
--
--return  �����½��Ķ���
------------------------------------------
function mulregexp (regexps, timeout, flags)
  local gp = "wait_group_" .. GetUniqueNumber ()
  threads [gp] = assert (coroutine.running (), "Must be in coroutine")
  local id
  for k,v in pairs(regexps) do
      id = "wait_trigger_" .. GetUniqueNumber ()
      check (AddTriggerEx (id, v[1], 
		"-- added by wait.mulregexp",  
		bit.bor (flags or 0, -- user-supplied extra flags, like omit from output
			 trigger_flag.Enabled, 
			 trigger_flag.RegularExpression,
			 trigger_flag.Temporary,
			 trigger_flag.Replace,
			 trigger_flag.OneShot),
		custom_colour.NoChange, 
		0, "",  -- wildcard number, sound file name
		"wait.trigger_mulresume", 
		12, 100))  -- send to script (in case we have to delete the timer)
      SetTriggerOption (id, "group", gp)
      if (v[2] ~= nil) and v[2] then
	SetTriggerOption (id, "multi_line", v[2])
	if (v[3] ~= nil) then
	  SetTriggerOption (id, "lines_to_match", v[3])
	end
      end
  end
            
  -- if timeout specified, also add a timer
  if timeout and timeout > 0 then
    local hours, minutes, seconds = convert_seconds (timeout)

    -- if timer fires, it deletes this trigger
    check (AddTimer (gp, hours, minutes, seconds, 
		   "-- added by wait.mulregexp",  
                   bit.bor (timer_flag.Enabled,
                            timer_flag.OneShot,
                            timer_flag.Temporary,
                            timer_flag.ActiveWhenClosed,
                            timer_flag.Replace), 
                   "wait.timer_mulresume"))

    check (SetTimerOption (id, "send_to", "12"))  -- send to script

  end -- if having a timeout

  return coroutine.yield ()  -- return line, wildcards
end
------------------------------------------
--�ָ�ָ����һ������
--@sign  ��ͣ��ʶ
--@text  ���ظ���ͣλ�õ��ַ���
--
--return  �����½��Ķ���
------------------------------------------
function wake (sign,text)
  local name="wait_pause_"..sign
  local thread = threads [name]
  if thread then
    threads [name] = nil
    local ok, err = coroutine.resume (thread,text)
    if not ok then
       ColourNote ("deeppink", "black", "Error raised in timer function (in wait module).")
       ColourNote ("darkorange", "black", debug.traceback (thread))
       error (err)
    end -- if
  end -- if
end
------------------------------------------
--��ͣһ�����̣�ֱ��wake������
--@sign  ��ͣλ�ñ�ʶ�ֱ�
--
--return  �����½��Ķ���
------------------------------------------
function pause (sign)
  local id = "wait_pause_"..sign
  threads [id] = assert (coroutine.running (), "Must be in coroutine")
  return coroutine.yield ()  -- return line, wildcards
end

subwait={}
------------------------------------------
--ɾ���������ָ��Ԫ�أ�ֻɾ��һ��
--@arr  table
--@element Ԫ��
--
--return �����±�
------------------------------------------
function table_del(arr, element) 
   if arr==nil then
      return nil
   end
   if #arr==0 then
      return {}
   end
   for k, value in pairs(arr) do
      if value == element then 
         table.remove(arr, k)
         return arr 
      end 
   end   
   return arr
end 
------------------------------------------
--����һ�����̲߳��������̶߳���
--
--return  �����½��Ķ���
------------------------------------------
function subwait:new ()
    local o = {list={["timer"]={},["trigger"]={},["group"]={}}} 
    setmetatable(o, self)
    self.__index = self
    return o
end
------------------------------------------
--�ر��̶߳���
--
--return  ��
------------------------------------------
function subwait:close ()
    for key,value in pairs(self.list["timer"]) do
	DeleteTimer(value)
	threads[value]=nil
    end
    self.list["timer"]={}
    for key,value in pairs(self.list["trigger"]) do
	DeleteTrigger(value)
	DeleteTimer(value)
	threads[value]=nil
    end
    self.list["trigger"]={}
    for key,value in pairs(self.list["group"]) do
        DeleteTriggerGroup(value)
	DeleteTimer(value)
	threads[value]=nil
    end
    self.list["group"]={}
end
------------------------------------------
--���߳��н��еȴ�
--@seconds
--
--return  ��
------------------------------------------
function subwait:time (seconds)
  local id = "subwait_timer_" .. GetUniqueNumber ()
  threads [id] = assert (coroutine.running (), "Must be in coroutine")

  local hours, minutes, seconds = convert_seconds (seconds)

  check (AddTimer (id, hours, minutes, seconds, "",
                  bit.bor (timer_flag.Enabled,
                           timer_flag.OneShot,
                           timer_flag.Temporary,
                           timer_flag.ActiveWhenClosed,
                           timer_flag.Replace), 
                   "wait.timer_resume"))
  table.insert(self.list["timer"],id)
  --return coroutine.yield ()
  coroutine.yield () 
  self.list["timer"]=table_del(self.list["timer"],id) 
  return
 
end
------------------------------------------
--���߳��еȴ�һ������
--
--return  �������ı�����
------------------------------------------
function subwait:regexp (regexp, timeout, flags, multi, multi_lines)
  if type(regexp) == "table" then
    local s="("
    for k,v in pairs(regexp) do
      if k~=1 then
        s=s.."|"
      end
      s=s..v
    end
    s=s..")"
    regexp=s
  end
  local id = "subwait_trigger_" .. GetUniqueNumber ()
  threads [id] = assert (coroutine.running (), "Must be in coroutine")
            
  check (AddTriggerEx (id, regexp, 
            "-- added by subwait.regexp",  
            bit.bor (flags or 0, -- user-supplied extra flags, like omit from output
                     trigger_flag.Enabled, 
                     trigger_flag.RegularExpression,
                     trigger_flag.Temporary,
                     trigger_flag.Replace,
                     trigger_flag.OneShot),
            custom_colour.NoChange, 
            0, "",  -- wildcard number, sound file name
            "wait.trigger_resume", 
            12, 100))  -- send to script (in case we have to delete the timer)
  if (multi ~= nil) and multi then
    SetTriggerOption (id, "multi_line", multi)
    if (multi_lines ~= nil) then
      SetTriggerOption (id, "lines_to_match", multi_lines)
    end
  end
  -- if timeout specified, also add a timer
  if timeout and timeout > 0 then
    local hours, minutes, seconds = convert_seconds (timeout)

    -- if timer fires, it deletes this trigger
    check (AddTimer (id, hours, minutes, seconds, 
                   "DeleteTrigger ('" .. id .. "')",
                   bit.bor (timer_flag.Enabled,
                            timer_flag.OneShot,
                            timer_flag.Temporary,
                            timer_flag.ActiveWhenClosed,
                            timer_flag.Replace), 
                   "wait.timer_resume"))

    check (SetTimerOption (id, "send_to", "12"))  -- send to script

    -- if trigger fires, it should delete the timer we just added
    check (SetTriggerOption (id, "send", "DeleteTimer ('" .. id .. "')"))  

  end -- if having a timeout

  --return coroutine.yield ()  -- return line, wildcards
  table.insert(self.list["trigger"],id)
  local line, wildcards, styles
  line, wildcards, styles=coroutine.yield () 
  self.list["trigger"]=table_del(self.list["trigger"],id) 
  return line, wildcards, styles
end
------------------------------------------
--�ú����ȴ�������򴥷����ء��κ�һ���������غ���������Ҳ��ʧЧ��
--@regexps   ������ʽ�б�{������ʽ,�Ƿ���д���,��������}
--@timeout   ��ʱʱ��
--@flags     ���������Ա��
--
--return  �����½��Ķ���
------------------------------------------
function subwait:mulregexp (regexps, timeout, flags)
  local gp = "wait_group_" .. GetUniqueNumber ()
  threads [gp] = assert (coroutine.running (), "Must be in coroutine")
  local id
  for k,v in pairs(regexps) do
      id = "wait_trigger_" .. GetUniqueNumber ()
      check (AddTriggerEx (id, v[1], 
		"-- added by wait.mulregexp",  
		bit.bor (flags or 0, -- user-supplied extra flags, like omit from output
			 trigger_flag.Enabled, 
			 trigger_flag.RegularExpression,
			 trigger_flag.Temporary,
			 trigger_flag.Replace,
			 trigger_flag.OneShot),
		custom_colour.NoChange, 
		0, "",  -- wildcard number, sound file name
		"wait.trigger_mulresume", 
		12, 100))  -- send to script (in case we have to delete the timer)
      SetTriggerOption (id, "group", gp)
      if (v[2] ~= nil) and v[2] then
	SetTriggerOption (id, "multi_line", v[2])
	if (v[3] ~= nil) then
	  SetTriggerOption (id, "lines_to_match", v[3])
	end
      end
  end
            
  -- if timeout specified, also add a timer
  if timeout and timeout > 0 then
    local hours, minutes, seconds = convert_seconds (timeout)

    -- if timer fires, it deletes this trigger
    check (AddTimer (gp, hours, minutes, seconds, 
		   "-- added by wait.mulregexp",  
                   bit.bor (timer_flag.Enabled,
                            timer_flag.OneShot,
                            timer_flag.Temporary,
                            timer_flag.ActiveWhenClosed,
                            timer_flag.Replace), 
                   "wait.timer_mulresume"))

    check (SetTimerOption (id, "send_to", "12"))  -- send to script

  end -- if having a timeout

  --return coroutine.yield ()  -- return line, wildcards
  table.insert(self.list["group"],gp)
  local line, wildcards, styles
  line, wildcards, styles=coroutine.yield () 
  self.list["group"]=table_del(self.list["group"],gp) 
  return line, wildcards, styles
end
