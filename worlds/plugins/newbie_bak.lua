------------------------------------------
--�������������
--δ���ȵ�����/newbietask () ���������������ǰֹͣ��
--��Ůͨ�ã����ϻ������ȴ󲿷��������ⶼ�����ˡ�
--����: �������
--
------------------------------------------

require "wait"
function newbietask ()
    if GetOption("enable_command_stack")~=1 then
        Note("��������Ϸ���������еĵ��ж�����ģʽ\n�ļ�->��Ϸ����(Alt+Enter)->Input->Commands->���ж�����ָ���Ϊ\";\"")
        return
    end
    wait.make (function ()
        local line,gender
        Execute("sc")
        line=wait.regexp (".*����һλ.*δ��.*����.*",10) --����һλʮ�����δ����������
        if line == nil then
            gender = 1
        elseif string.find(line,"��������")~=nil then
            gender = 1
        elseif string.find(line,"Ů������")~=nil then
            gender = 0
        else
            gender = 1
        end
        Execute("quest")
        line=wait.regexp (".*���������İ���ĵط���ǰ;δ����������hp�������Լ����������.*",10)
        Execute("hp")
        line=wait.regexp (".*�������ֿ��ֶ��������������ܷ��ҵ�Щ�Եĺȵġ�.*",2)
        while true do
            Execute("get ye guo") --�����һöҰ��
            line=wait.regexp (".*�����һöҰ��.*",5)
            if line~=nil then
                break
            end
        end
        Execute("eat ye guo")
        while true do
            line=wait.regexp ("(.*������Ұ��ҧ�˼���.*|.*���Ѿ���̫����.*)",2)
            if (line~=nil) and (string.find(line,"����Ұ��")~=nil) then
                Execute("eat ye guo")
            elseif (line~=nil) and (string.find(line,"�Ѿ���̫��")~=nil) then
                break
            end
        end
        Execute("l river")
        line=wait.regexp (".*Ҳ�������������ϵĺ�«.*",2)
        while true do
            Execute("get hulu")
            line=wait.regexp (".*�����һ����«.*",5)
            if line~=nil then
                break
            end
        end
        Execute("l hulu")
        line=wait.regexp (".*������������ʢϪˮ.*",2)
        Execute("fill hulu;drink hulu")
        while true do
            line=wait.regexp ("(.*�������«������غ��˼���.*|.*�Ա������ˣ������ڿ���ȥ��Χ̽����.*)",2)
            if (line~=nil) and (string.find(line,"�����«")~=nil) then
                Execute("drink hulu")
            elseif (line~=nil) and (string.find(line,"�Ա�������")~=nil) then
                Execute("e;w;s;n;w;e")
                break
            end
        end
        line=wait.regexp (".*����Χ���˸��飬��û�з�������������.*",3)
        wait.time(2)
        Execute("l path;climb up")
        line=wait.regexp (".*��������ɽׯ�᲻�����ǰ�渽���ĵط�.*",15)
        Execute("n;n;n")
        line=wait.regexp (".*��������վ�����ﲻ֪����,����ȥ������.*",2)
        Execute("knock gate;")
        line=wait.regexp (".*Ѿ������ɴ�������ȹ���˹�����.*",1)
        Execute("ask yahuan about ��«")
        line=wait.regexp (".*Ѿ�߼������еĺ�«�������.*",1)
        wait.time(2)
        Execute("knock gate")
        line=wait.regexp (".*Ѿ��ת��ͷ�������㣬ʾ����Ͻ��Ѻ�«����λׯ��.*",25)
        Execute("give hulu to you kunyi")
        line=wait.regexp (".*�������ƺ������Զ�����.*",2)
        wait.time(5)
        Execute("ask you kunyi about here;ask you kunyi about name;ask you kunyi about ��«;ask you kunyi about ��������;")
        wait.time(5)
        line=wait.regexp (".*����Ѿ�߰�正�����������Ϥһ��ɽׯ��.*",5)
        Execute("follow a shu")
        line=wait.regexp (".*����·�����,�ú�������ϴ�����.*",60)
        wait.time(1)
        Execute("follow none;remove all;bath")
        line=wait.regexp (".*���ڰ���ϴ����.*",60)
        wait.time(5)
        if gender == 0 then
            Execute("wear all;s;w;ask you kunyi about ��������;")
        else
            Execute("wear all;s;e;ask you kunyi about ��������;")
        end
        line=wait.regexp (".*��ȥ����������ʦ��������.*",2)
        wait.time(3)
        Execute("n;fight wushi")
        line=wait.regexp ("(.*�������㲻�ٵ����������᷿ȥ��Ϣ.*|.*������������������֪��.*)",120)
        wait.time(5)
        if gender == 0 then
            Execute("s;e;sleep")
        else
            Execute("s;w;sleep")
        end
        line=wait.regexp (".*����ɫ�ָ�����Ȼ����ʦ�����.*",30)
        wait.time(3)
        if gender == 0 then
            Execute("w;ask you kunyi about ��������;")
        else
            Execute("e;ask you kunyi about ��������;")
        end
        line=wait.regexp (".*��������Ʊ��������.*",3)
        wait.time(3)
        Execute("localmaps;q")
        line=wait.regexp (".*��ȥ����Ʊ�ſ��������������˶���Ǯ.*",3)
        Execute("s;s;open gate;s;e;qu 100 silver")
        line=wait.regexp (".*ȡ��Ǯ���Ͻ�ȥҩ����ҩ���˰�.*",3)
        wait.time(3)
        Execute("w;s;s;ne;buy yao;eat yao")
        line=wait.regexp (".*������κ��ˣ���ص���ׯ����.*",3)
        wait.time(5)
        Execute("sw;n;n;knock gate;n;n;n;ask you kunyi about ��������;")
        line=wait.regexp (".*��ȥ�����ã�����ʦ��ʦѧ��ȥ��.*",3)
        wait.time(3)
        Execute("n;bai wushi")
        line=wait.regexp (".*����Ҫһ���յ��Ӻ�һ�Ѹֽ�.*",3)
        wait.time(3)
        Execute("s")
        line=wait.regexp (".*�ȱ��ߣ���û����Ǯ.*",3)
        wait.time(5)
        Execute("s;s;s;open gate;s;s;w;buy jian")
        line=wait.regexp (".*����Ϻ�����������һ���ֽ�.*",3)
        wait.time(3)
        Execute("e;s;se;buy shaodaozi")
        line=wait.regexp (".*����Ϻ�����������һ̳�յ���.*",3)
        wait.time(3)
        Execute("nw;n;n;knock gate;n;n;n;n;give wushi jian;")
        line=wait.regexp (".*�����ʦһ���ֽ�.*",3)
        wait.time(3)
        Execute("give wushi shaodaozi")
        line=wait.regexp (".*û�취����������ȥ������.*",3)
        wait.time(3)
        Execute("s;s;s;open gate;s;s;e;buy shi he")
        line=wait.regexp (".*�������������������һ��ʳ��.*",3)
        wait.time(3)
        Execute("w;s;se;buy jitui")
        line=wait.regexp (".*����Ϻ�����������һ��������.*",3)
        wait.time(3)
        Execute("put jitui in shi he")
        line=wait.regexp (".*�㽫һ�������ȷŽ�ʳ��.*",3)
        wait.time(3)
        Execute("nw;n;n;knock gate;n;n;n;n;give wushi shi he;")
        line=wait.regexp (".*�ٿ���ʦ������Щʲô����.*",3)
        wait.time(3)
        Execute("bai wushi;cha wushi")
        line=wait.regexp (".*�����������ʦѧ����Щ���ܣ��Ͻ�����ѧ�㹦��.*",3)
        wait.time(3)
        while true do
            Execute("learn wushi for force 1;learn wushi for dodge 1;learn wushi for parry 1;learn wushi for strike 1;learn wushi for sword 1;learn wushi for taiyi-shengong 1;learn wushi for taiyi-jian 1;learn wushi for taiyi-you 1;learn wushi for taiyi-zhang 1;")
            line=wait.regexp ("(.*�����̫����.*|.*��ѧ���Ĺ��򶼼���������.*)",2)
            wait.time(2)
            if line~=nil and  (string.find(line,"����̫��")~=nil) then
                if gender == 0 then
                    Execute("s;e;sleep")
                else
                    Execute("s;w;sleep")
                end
                line=wait.regexp ("(.*��һ�������������ӵػ.*|.*�������������˯��һ��.*)",35)
                if (line~=nil) and (string.find(line,"����������˯��")~=nil) then
                    wait.time(15)
                end
                if gender == 0 then
                    Execute("w;n")
                else
                    Execute("e;n")
                end
            elseif line~=nil and  (string.find(line,"���򶼼���")~=nil) then
                break
            end
        end
        line=wait.regexp (".*��ѧ���Ĺ��򶼼���������.*",3)
        Execute("jifa force taiyi-shengong;jifa dodge taiyi-you;jifa sword taiyi-jian;jifa parry taiyi-jian;jifa strike taiyi-zhang")
        line=wait.regexp (".*��Ҫ��׼��һ�����ÿ�����ʽ.*",3)
        Execute("bei taiyi-zhang")
        wait.time(3)
        line=wait.regexp (".*�ٺ���ʦ����������.*",3)
        Execute("fight wushi")
        line=wait.regexp (".*���ȴ���ȥ��ϰһ��̫�ҽ���.*",30)
        wait.time(3)
        if gender == 0 then
            Execute("s;e;wield sword;lian sword 10")
        else
            Execute("s;w;wield sword;lian sword 10")
        end
        while true do
            Execute("lian sword 10")
            line=wait.regexp ("(.*�������������̫����.*|.*�����������еĽ����о��Լ��е㹦����.*)",5)
            if (line~=nil) and (string.find(line,"��������")~=nil) then
                Execute("sleep")
                line=wait.regexp ("(.*��һ�������������ӵػ.*|.*�������������˯��һ��.*)",35)
                if (line~=nil) and (string.find(line,"����������˯��")~=nil) then
                    wait.time(10)
                end
            elseif (line~=nil) and  (string.find(line,"�о��Լ��е㹦��")~=nil) then
                break
            end
        end
        Note("----�ȴ��ظ���Ϣ----")
        wait.time(10)
        while true do
            Execute("sleep")
            line=wait.regexp ("(.*��һ�������������ӵػ.*|.*�������������˯��һ��.*)",35)
            if (line~=nil) and (string.find(line,"��һ������")~=nil) then
                break
            end
            wait.time(10)
        end
        if gender == 0 then
            Execute("w;ask you kunyi about ��������;")
        else
            Execute("e;ask you kunyi about ��������;")
        end
        line=wait.regexp (".*ȥ���������׻�����ʾ����.*",3)
        wait.time(3)
        Execute("s;s;open gate;s;s;s;ne;buy yao")
        wait.time(5)
        Execute("sw;s;climb down")
        line=wait.regexp (".*����˾�ţ����֮�������������˹ȵ�.*",25)
        wait.time(5)
        Execute("w;kill lao hu")
        while true do
            Execute("perform sword.bafang")
            line=wait.regexp ("(.*�����˶񻢣���о��Լ���������.*|.*���Ѿ���������״̬.*|.*�㿴�����Ѿ���������.*|.*�����ǰһ�ڣ�����ʲôҲ��֪����.*)",3)
            if line~=nil and (string.find(line,"�����˶�")~=nil) then
                wait.time(2)
                Execute("e;climb up")
                break
            elseif (line~=nil) and ((string.find(line,"���Ѿ���������")~=nil) or (string.find(line,"�㿴�����Ѿ���������")~=nil)) then
                Execute("eat yao")
            elseif line~=nil and (string.find(line,"�����ǰһ��")~=nil) then
                line=wait.regexp (".*�����������۾��������˹���.*",240)
                wait.time(10)
                if gender == 0 then
                    Execute("w")
                else
                    Execute("e")
                end
                Execute("s;s;open gate;s;s;s;s;climb down")
                line=wait.regexp (".*����˾�ţ����֮�������������˹ȵ�.*",35)
                wait.time(5)
                Execute("w;kill lao hu")
            end
        end
        line=wait.regexp (".*���������ɵ���������.*",15)
        wait.time(2)
        Execute("n;n;n;knock gate;n;n;n;ask you kunyi about ��������;")
        line=wait.regexp (".*����ȥ������һ������.*",3)
        wait.time(2)
        Execute("n;n;get book from shujia;read book for 1")
        line=wait.regexp (".*��������������.*",3)
        wait.time(3)
        Execute("s;s;ask you kunyi about ��������;")
        line=wait.regexp (".*��ȻӢ��Ҫ���㣬ȴ֮����.*",3)
        wait.time(1)
        Execute("s;s;open gate;s;s;s") --��������ǰ
    end) 
end
