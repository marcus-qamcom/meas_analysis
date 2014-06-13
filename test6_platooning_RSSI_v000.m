%% Test 2

% RSSI/PER as experienced by last truck (Pluto).

clear all 
close all
clc
addpath('..\data')
addpath('helpfunctions')
testconftestcase

%% Load data
t_no='6'; % test case number
AP='1'        % 1,2,4,5,6,7,8,       

%veh='DRF18L'; % 'DRF18L','DRF18H','PltonL','PltonR','DEF84L','DEF84R'

frielndly_name='PlutoL'; %'PlutoL','PlutoH'

fs=124; % 108 124 524 600m, frame size



%% read data: RSSI, T LAT LONG (i.e. lat long of moving trucks)     
disp('load links')

% pos (only) from Pluto
[TT_4L RSSI_4L LAT_4L LONG_4L RX_SEQ_4L]=load_comm_link(testconf,t_no,AP,'DRF18L','PlutoL',fs);

% pos and RSSI from DRF
[TT_1L RSSI_1L LAT_1L LONG_1L RX_SEQ_1L]=load_comm_link(testconf,t_no,AP,'PlutoL','DEF84L',fs);
[TT_1R RSSI_1R LAT_1R LONG_1R RX_SEQ_1R]=load_comm_link(testconf,t_no,AP,'PlutoR','DEF84R',fs);

[TT_2L RSSI_2L LAT_2L LONG_2L RX_SEQ_2L]=load_comm_link(testconf,t_no,AP,'PlutoL','PltonL',fs);
[TT_2R RSSI_2R LAT_2R LONG_2R RX_SEQ_2R]=load_comm_link(testconf,t_no,AP,'PlutoR','PltonR',fs);

[TT_3L RSSI_3L LAT_3L LONG_3L RX_SEQ_3L]=load_comm_link(testconf,t_no,AP,'PlutoL','DRF18L',fs);
[TT_3R RSSI_3R LAT_3R LONG_3R RX_SEQ_3R]=load_comm_link(testconf,t_no,AP,'PlutoR','DRF18R',fs);




%% Curve etc.
close all
LAT_4L_ref  =  590846416; % LAT_4L(1)  for AP1
LONG_4L_ref =  175958966; % LONG_4L(1) for AP1

[DD1] = calcDistV(LAT_1L,LONG_1L,LAT_4L_ref,LONG_4L_ref,-2); % DRF
[DD2] = calcDistV(LAT_2L,LONG_2L,LAT_4L_ref,LONG_4L_ref,-2); % Platon
[DD3] = calcDistV(LAT_3L,LONG_3L,LAT_4L_ref,LONG_4L_ref,-2); % DEF
[DD4] = calcDistV(LAT_4L,LONG_4L,LAT_4L_ref,LONG_4L_ref,-2); % Pluto


% plot route
%
plot(DD1(:,2),-DD1(:,1),'b')
hold on
plot(DD4(:,2),-DD4(:,1),'r')

% Timestamps

% Timestamps from distance/position 
% Format: index/TTL_...
timestamp=zeros(4,7); %(time_index, veh. L/R)
% 1) All have started, last leaves starting point
timestamp(1,:) = timestamp_test_6(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp(2,:) = timestamp_test_6(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 6100, 1, 0);
% Way back
% 3) last truck back onto E4 west direction at 6000m:
timestamp(3,:) = timestamp_test_6(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 5500, 0, 1);
% 4) first reaches E4 exit end of straight road
timestamp(4,:) = timestamp_test_6(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 800, 1, 1);


%time_stamp=[200 1250 1350 1700]
scatter(DD1(timestamp(1:4,1),2),-DD1(timestamp(1:4,1),1),60,'b*')
scatter(DD4(timestamp(1:4,7),2),-DD4(timestamp(1:4,7),1),60,'r*')

for t=1:4
    text(DD1(timestamp(t),2)+30,-DD1(timestamp(t),1)-30,num2str(t),'FontSize',18)
end
ylabel('Distance [m]')
xlabel('Distance [m]')
axis equal
hold off





% Plot distances
%
[TT14 DD14] = calcDistVV(TT_4L,LAT_4L,LONG_4L,TT_1L,LAT_1L,LONG_1L);
[TT24 DD24] = calcDistVV(TT_4L,LAT_4L,LONG_4L,TT_2L,LAT_2L,LONG_2L);
[TT34 DD34] = calcDistVV(TT_4L,LAT_4L,LONG_4L,TT_3L,LAT_3L,LONG_3L);
figure
%plot(TT14,DD14-(9.5+18+9.5),'c')
plot(TT14,DD14,'c')
hold on
%plot(TT24,DD24-(18+9.5),'b')
plot(TT24,DD24,'b')
%plot(TT34,DD34-9.5,'m')
plot(TT34,DD34,'m')

%timestamp
plot([TT_3L(timestamp(1,5))  TT_3L(timestamp(2,5)) ],[50 50],'k')
plot([TT_3L(timestamp(3,5))  TT_3L(timestamp(4,5)) ],[50 50],'k')
%misc
ylabel('Distance [m]')
xlabel('Time [s]')
%axis([0 500 0 150])
legend('DEF to Pluto','Platon to Pluto','DRF to Pluto','Meas. during this time')
title(['Test 6, AP' AP ', distance between trucks'])
hold off







%% 

disp('Analyze Pluto -> DEF, left side')
figure
plot(TT_1L(timestamp(1,1) : timestamp(2,1)), RSSI_1L(timestamp(1,1) : timestamp(2,1)),'r')
hold on
plot(TT_1L(timestamp(3,1) : timestamp(4,1)), RSSI_1L(timestamp(3,1) : timestamp(4,1)),'b')
%misc
ylabel('RSSI [dBm]')
xlabel('Time [s]')
legend('E4 South','E4 North')
title(['Test 6, AP' AP ', DEF to Pluto, left-to-left'])
%axis([0 450 -90 -40])
hold off
avg_rssi = mean([ RSSI_1L(timestamp(1,1):timestamp(2,1))  RSSI_1L(timestamp(3,1):timestamp(4,1)) ] );
disp(avg_rssi)



disp('Analyze Pluto -> Platon, left side')
figure
plot(TT_2L(timestamp(1,3) : timestamp(2,3)), RSSI_2L(timestamp(1,3) : timestamp(2,3)),'r')
hold on
plot(TT_2L(timestamp(3,3) : timestamp(4,3)), RSSI_2L(timestamp(3,3) : timestamp(4,3)),'b')
%misc
ylabel('RSSI [dBm]')
xlabel('Time [s]')
legend('E4 South','E4 North')
title(['Test 6, AP' AP ', Platon to Pluto, left-to-left'])
%axis([0 450 -90 -40])
hold off
avg_rssi = mean([ RSSI_2L(timestamp(1,3):timestamp(2,3))  RSSI_2L(timestamp(3,3):timestamp(4,3)) ] );
disp(avg_rssi)


% Analyze Pluto -> DRF, left side
disp('Analyze Pluto -> DRF, left side')
figure
plot(TT_3L(timestamp(1,5) : timestamp(2,5)), RSSI_3L(timestamp(1,5) : timestamp(2,5)),'r')
hold on
plot(TT_3L(timestamp(3,5) : timestamp(4,5)), RSSI_3L(timestamp(3,5) : timestamp(4,5)),'b')
%misc
ylabel('RSSI [dBm]')
xlabel('Time [s]')
legend('E4 South','E4 North')
title(['Test 6, AP' AP ', DRF to Pluto, left-to-left'])
%axis([0 450 -90 -40])
hold off
avg_rssi = mean([ RSSI_3L(timestamp(1,5):timestamp(2,5))  RSSI_3L(timestamp(3,5):timestamp(4,5)) ] );
disp(avg_rssi)