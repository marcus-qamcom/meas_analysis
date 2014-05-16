function [T RSSI LAT LONG RX_SEQ lab] = load_comm_link(testconf,testcase_no,AP,veh,friendlyname,frame_size,meeting) 
% Load Test 1, AP1

% run testconftestcase before this script
% testconftestcase

% Test 1
if isequal(testcase_no,'1') && isequal(AP,'1')
    no=1;
end
if isequal(testcase_no,'1') && isequal(AP,'2')
    no=2;
end
if isequal(testcase_no,'1') && isequal(AP,'4')
    no=3;
end
if isequal(testcase_no,'1') && isequal(AP,'5')
    no=4;
end
if isequal(testcase_no,'1') && isequal(AP,'8')
    no=5;
end


% Test 1b
if isequal(testcase_no,'1b') && isequal(AP,'1a')
    no=6;
end
if isequal(testcase_no,'1b') && isequal(AP,'1b')
    no=7;
end
if isequal(testcase_no,'1b') && isequal(AP,'2a')
    no=8;
end
if isequal(testcase_no,'1b') && isequal(AP,'2b')
    no=9;
end
if isequal(testcase_no,'1b') && isequal(AP,'4a')
    no=10;
end
if isequal(testcase_no,'1b') && isequal(AP,'4b')
    no=11;
end
if isequal(testcase_no,'1b') && isequal(AP,'5a')
    no=12;
end
if isequal(testcase_no,'1b') && isequal(AP,'5b')
    no=13;
end
if isequal(testcase_no,'1b') && isequal(AP,'8a')
    no=14;
end
if isequal(testcase_no,'1b') && isequal(AP,'8b')
    no=15;
end


% Test 2
if isequal(testcase_no,'2') && isequal(AP,'1_10m')
    no=19;
end
if isequal(testcase_no,'2') && isequal(AP,'1_20m')
    no=20;
end
if isequal(testcase_no,'2') && isequal(AP,'1_30m')
    no=21;
end

if isequal(testcase_no,'2') && isequal(AP,'4_10m')
    no=22;
end
if isequal(testcase_no,'2') && isequal(AP,'4_20m')
    no=23;
end
if isequal(testcase_no,'2') && isequal(AP,'4_30m')
    no=24;
end

if isequal(testcase_no,'2') && isequal(AP,'5_10m')
    no=25;
end
if isequal(testcase_no,'2') && isequal(AP,'5_20m')
    no=26;
end
if isequal(testcase_no,'2') && isequal(AP,'5_30m')
    no=27;
end


if isequal(testcase_no,'2') && isequal(AP,'8_10m')
    no=16;
end
if isequal(testcase_no,'2') && isequal(AP,'8_20m')
    no=17;
end
if isequal(testcase_no,'2') && isequal(AP,'8_30m')
    no=18;
end

% start
disp(['Start:' testconf(no).starttime ' , Stop: ' testconf(no).stoptime])

t1=timeHuman2timeUnix(testconf(no).starttime);
% stop
t2=timeHuman2timeUnix(testconf(no).stoptime);


my_path=['../data/Day1/' veh '/Test' num2str(testcase_no) 'AP' num2str(AP) veh '.mat']
data_m = load(my_path);

my_cmd=['Test' num2str(testcase_no) 'AP' num2str(AP) veh];
data = data_m.(my_cmd);
clear data_m

[T RSSI LAT LONG RX_SEQ] = read_data(t1, t2, data, friendlyname, frame_size);

clear data

% Labels...


% Label sender
% ------- Volvo left -----------
if isequal(friendlyname, 'DEF84L') || isequal(friendlyname, 'DRF18L')
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '2'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '3'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3L'];
    case '6'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '7'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '9'
        lab_send = [friendlyname(1:5) ' 1L'];
    end
end

% ------- Volvo right -----------
if isequal(friendlyname, 'DEF84R') || isequal(friendlyname, 'DRF18R') 
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' 1R-high'];
    case '2'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '3'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3R'];
    case '6'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '7'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '9'
        lab_send = [friendlyname(1:5) ' 1R-high'];
    end
end

% ------- Scania left -----------
if isequal(friendlyname, 'PltonL') || isequal(friendlyname, 'PlutoL') 
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' VL'];
    case '2'
        lab_send = [friendlyname(1:5) ' VL'];
    case '3'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3L'];
    case '6'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '7'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '9'
        lab_send = [friendlyname(1:5) ' 2L'];
    end
end

% ------- Scania right -----------
if isequal(friendlyname, 'PltonR') || isequal(friendlyname, 'PlutoR')
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' VR'];
    case '2'
        lab_send = [friendlyname(1:5) ' VR'];
    case '3'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3R'];
    case '6'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '7'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '9'
        lab_send = [friendlyname(1:5) ' 2R'];
    end
end






% Label receiver
% ------- Volvo left -----------
if isequal(veh, 'DEF84L') || isequal(veh, 'DRF18L')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' 1L'];
    case '2'
        lab_rec = [veh(1:5) ' 1L'];
    case '3'
        lab_rec = [veh(1:5) ' 1L'];
    case '4'
        lab_rec = [veh(1:5) ' 2L'];
    case '5'
        lab_rec = [veh(1:5) ' 3L'];
    case '6'
        lab_rec = [veh(1:5) ' 1L'];
    case '7'
        lab_rec = [veh(1:5) ' 4L'];
    case '8'
        lab_rec = [veh(1:5) ' 4L'];
    case '9'
        lab_rec = [veh(1:5) ' 1L'];
    end
end

% ------- Volvo right -----------
if isequal(veh, 'DEF84R') || isequal(veh, 'DRF18R')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' 1R-high'];
    case '2'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '3'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '4'
        lab_rec = [veh(1:5) ' 2R'];
    case '5'
        lab_rec = [veh(1:5) ' 3R'];
    case '6'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '7'
        lab_rec = [veh(1:5) ' 4R'];
    case '8'
        lab_rec = [veh(1:5) ' 4R'];
    case '9'
        lab_rec = [veh(1:5) ' 1R-high'];
    end
end

% ------- Scania left -----------
if isequal(veh, 'PltonL') || isequal(veh, 'PlutoL')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' VL'];
    case '2'
        lab_rec = [veh(1:5) ' VL'];
    case '3'
        lab_rec = [veh(1:5) ' 2L'];
    case '4'
        lab_rec = [veh(1:5) ' 2L'];
    case '5'
        lab_rec = [veh(1:5) ' 3L'];
    case '6'
        lab_rec = [veh(1:5) ' 4L'];
    case '7'
        lab_rec = [veh(1:5) ' 2L'];
    case '8'
        lab_rec = [veh(1:5) ' 4L'];
    case '9'
        lab_rec = [veh(1:5) ' 2L'];
    end
end

% ------- Scania right -----------
if isequal(veh, 'PltonR') || isequal(veh, 'PlutoR')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' VR'];
    case '2'
        lab_rec = [veh(1:5) ' VR'];
    case '3'
        lab_rec = [veh(1:5) ' 2R'];
    case '4'
        lab_rec = [veh(1:5) ' 2R'];
    case '5'
        lab_rec = [veh(1:5) ' 3R'];
    case '6'
        lab_rec = [veh(1:5) ' 4R'];
    case '7'
        lab_rec = [veh(1:5) ' 2R'];
    case '8'
        lab_rec = [veh(1:5) ' 4R'];
    case '9'
        lab_rec = [veh(1:5) ' 2R'];
    end
end

lab = [lab_send '->' lab_rec];
end
