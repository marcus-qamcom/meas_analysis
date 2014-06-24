function dataAgeEvaluation(t_no, APnum, dist, testconf, TXVehL, RXVeh2L, RXVeh2R)

%% Below used for development of the script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all 
% close all
% clc
% 
% addpath('..\data')
% addpath('helpfunctions')
% 
% testconftestcase

%% Load data
%parameters in function call
% t_no='6'; % test case number
% APnum='2';        % 1,2,4,5,8
% dist='0';
% RXVeh2L='PlutoL';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
% RXVeh2R='PltonR';
% TXVehL='DRF18L';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enableRight=0;
if nargin==7
    enableRight=1;
end

if dist=='0'
   AP=APnum; 
else
    AP=[APnum '_' dist];
end

%Below used when using function

%% Load and trim data
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')

% Load data from receivers for 124 byte packets
fs=124;
% Left antennas
[TT_2L_124 RSSI_2L_124 LAT_2L_124 LONG_2L_124 RX_SEQ_2L_124]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_124 RSSI_2R_124 LAT_2R_124 LONG_2R_124 RX_SEQ_2R_124]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=108;
[TT_1L_124 RSSI_1L_124 LAT_1L_124 LONG_1L_124 TX_SEQ_1L_124]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);
% Frame size not the same for sender and receiver

% Load data from receivers for 524 byte packets
fs=524;
% Left antennas
[TT_2L_524 RSSI_2L_524 LAT_2L_524 LONG_2L_524 RX_SEQ_2L_524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_524 RSSI_2R_524 LAT_2R_524 LONG_2R_524 RX_SEQ_2R_524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=508;
[TT_1L_524 RSSI_1L_524 LAT_1L_524 LONG_1L_524 TX_SEQ_1L_524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);

% Load data from receivers for 524 byte packets
fs=600;
% Left antennas
[TT_2L_1524 RSSI_2L_1524 LAT_2L_1524 LONG_2L_1524 RX_SEQ_2L_1524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_1524 RSSI_2R_1524 LAT_2R_1524 LONG_2R_1524 RX_SEQ_2R_1524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=600;
[TT_1L_1524 RSSI_1L_1524 LAT_1L_1524 LONG_1L_1524 TX_SEQ_1L_1524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);

%% Trim loaded data

close all
LAT_4L_ref  =  590846416; % LAT_4L(1)  for AP1
LONG_4L_ref =  175958966; % LONG_4L(1) for AP1

[DD1_124] = calcDistV(LAT_1L_124,LONG_1L_124,LAT_4L_ref,LONG_4L_ref,-2);
[DD2_124] = calcDistV(LAT_2L_124,LONG_2L_124,LAT_4L_ref,LONG_4L_ref,-2);

[DD1_524] = calcDistV(LAT_1L_524,LONG_1L_524,LAT_4L_ref,LONG_4L_ref,-2);
[DD2_524] = calcDistV(LAT_2L_524,LONG_2L_524,LAT_4L_ref,LONG_4L_ref,-2);

[DD1_1524] = calcDistV(LAT_1L_1524,LONG_1L_1524,LAT_4L_ref,LONG_4L_ref,-2);
[DD2_1524] = calcDistV(LAT_2L_1524,LONG_2L_1524,LAT_4L_ref,LONG_4L_ref,-2);


% plot route
%%
plot(DD1_124(:,2),-DD1_124(:,1),'b')
hold on
plot(DD2_124(:,2),-DD2_124(:,1),'r')
%
%% Get time stamps for packet size 124 byte
timestamp_124=zeros(4,3); %(time_index, veh. L/R)
% 1) All have started, last leaves starting point
timestamp_124(1,:) = timestamp_test_6_2(TT_1L_124, TT_2L_124, TT_2L_124, DD2_124, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_124(2,:) = timestamp_test_6_2(TT_1L_124, TT_2L_124, TT_2L_124, DD1_124, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:
timestamp_124(3,:) = timestamp_test_6_2(TT_1L_124, TT_2L_124, TT_2L_124, DD2_124, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_124(4,:) = timestamp_test_6_2(TT_1L_124, TT_2L_124, TT_2L_124, DD1_124, 800, 1, 1);


%time_stamp=[200 1250 1350 1700]
scatter(DD1_124(timestamp_124(1:2,1),2),-DD1_124(timestamp_124(1:2,1),1),60,'b*')
scatter(DD2_124(timestamp_124(1:2,2),2),-DD2_124(timestamp_124(1:2,2),1),60,'r*')

for t=1:4
    text(DD1_124(timestamp_124(t),2)+30,-DD1_124(timestamp_124(t),1)-30,num2str(t),'FontSize',18)
end
ylabel('Distance [m]')
xlabel('Distance [m]')
axis equal
hold off
close all

% Get rest of the timestamps
%% Get time stamps for packet size 524 byte
timestamp_524=zeros(4,3); %(time_index, veh. L/R)
% 1) All have started, last leaves starting point
timestamp_524(1,:) = timestamp_test_6_2(TT_1L_524, TT_2L_524, TT_2L_524, DD2_524, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_524(2,:) = timestamp_test_6_2(TT_1L_524, TT_2L_524, TT_2L_524, DD1_524, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:
timestamp_524(3,:) = timestamp_test_6_2(TT_1L_524, TT_2L_524, TT_2L_524, DD2_524, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_524(4,:) = timestamp_test_6_2(TT_1L_524, TT_2L_524, TT_2L_524, DD1_524, 800, 1, 1);

%% Get time stamps for packet size 1524 byte
timestamp_1524=zeros(4,3); %(time_index, veh. L/R)
% 1) All have started, last leaves starting point
timestamp_1524(1,:) = timestamp_test_6_2(TT_1L_1524, TT_2L_1524, TT_2L_1524, DD2_1524, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_1524(2,:) = timestamp_test_6_2(TT_1L_1524, TT_2L_1524, TT_2L_1524, DD1_1524, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:

timestamp_1524(3,:) = timestamp_test_6_2(TT_1L_1524, TT_2L_1524, TT_2L_1524, DD2_1524, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_1524(4,:) = timestamp_test_6_2(TT_1L_1524, TT_2L_1524, TT_2L_1524, DD1_1524, 800, 1, 1);

%% Calculate Data age for 124 byte packets
[DA_124a, TT_2_124a]=calcDA(TX_SEQ_1L_124(timestamp_124(1,1):timestamp_124(2,1)), TT_1L_124(timestamp_124(1,1):timestamp_124(2,1)), RX_SEQ_2L_124(timestamp_124(1,3):timestamp_124(2,3)), TT_2L_124(timestamp_124(1,3):timestamp_124(2,3)));
[DA_124b, TT_2_124b]=calcDA(TX_SEQ_1L_124(timestamp_124(3,1):timestamp_124(4,1)), TT_1L_124(timestamp_124(3,1):timestamp_124(4,1)), RX_SEQ_2L_124(timestamp_124(3,3):timestamp_124(4,3)), TT_2L_124(timestamp_124(3,3):timestamp_124(4,3)));

%% Calculate Data age for 524 byte packets
[DA_524a, TT_2_524a]=calcDA(TX_SEQ_1L_524(timestamp_524(1,1):timestamp_524(2,1)), TT_1L_524(timestamp_524(1,1):timestamp_524(2,1)), RX_SEQ_2L_524(timestamp_524(1,3):timestamp_524(2,3)), TT_2L_524(timestamp_524(1,3):timestamp_524(2,3)));
[DA_524b, TT_2_524b]=calcDA(TX_SEQ_1L_524(timestamp_524(3,1):timestamp_524(4,1)), TT_1L_524(timestamp_524(3,1):timestamp_524(4,1)), RX_SEQ_2L_524(timestamp_524(3,3):timestamp_524(4,3)), TT_2L_524(timestamp_524(3,3):timestamp_524(4,3)));

%% Calculate Data age for 1524 byte packets
[DA_1524a, TT_2_1524a]=calcDA(TX_SEQ_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)), TT_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)), RX_SEQ_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)), TT_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)));
[DA_1524b, TT_2_1524b]=calcDA(TX_SEQ_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1)), TT_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1)), RX_SEQ_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3)), TT_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3)));

%% Calculate PER for 124 byte packets
[PER_124, vPER_124]=calcPER([TX_SEQ_1L_124(timestamp_124(1,1):timestamp_124(2,1)) TX_SEQ_1L_124(timestamp_124(3,1):timestamp_124(4,1))],[RX_SEQ_2L_124(timestamp_124(1,3):timestamp_124(2,3)) RX_SEQ_2L_124(timestamp_124(3,3):timestamp_124(4,3))]);
[PER_524, vPER_524]=calcPER([TX_SEQ_1L_524(timestamp_124(1,1):timestamp_524(2,1)) TX_SEQ_1L_524(timestamp_524(3,1):timestamp_524(4,1))],[RX_SEQ_2L_524(timestamp_524(1,3):timestamp_524(2,3)) RX_SEQ_2L_524(timestamp_524(3,3):timestamp_524(4,3))]);
[PER_1524, vPER_1524]=calcPER([TX_SEQ_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)) TX_SEQ_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1))],[RX_SEQ_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)) RX_SEQ_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3))]);

%% plot and save
% Concatanate data age according packet size
DA_124 = [DA_124a DA_124b];
DA_524 = [DA_524a DA_524b];
DA_1524 = [DA_1524a DA_1524b];

timeA=TT_2_124a-TT_2_124a(1);
TT_124=[TT_2_124a-TT_2_124a(1) (TT_2_124b-TT_2_124b(1))+timeA(end)];

timeA=TT_2_524a-TT_2_524a(1);
TT_524=[TT_2_524a-TT_2_524a(1) (TT_2_524b-TT_2_524b(1))+timeA(end)];

timeA=TT_2_1524a-TT_2_1524a(1);
TT_1524=[TT_2_1524a-TT_2_1524a(1) (TT_2_1524b-TT_2_1524b(1))+timeA(end)];

%%Save params
cd('output')
save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '100byte'], 'DA_124', 'TT_124', 'PER_124', 'vPER_124');
save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '500byte'], 'DA_524', 'TT_524', 'PER_524', 'vPER_524');
save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '1500byte'], 'DA_1524', 'TT_1524', 'PER_1524', 'vPER_1524');
cd('..')

%%Plot and save data age for 100 byte packets
timeB=max(TT_124);
hold off
h = figure(1);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on

plot(TT_124, DA_124, 'k');

maxDA=max(DA_124);
axis([-10 max(timeB)+10 0 maxDA+0.2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 100 byte packets ']; [TXVehL, ' to ', RXVeh2L]})
legend('100 byte');

%Save the figure
cd('output')
savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_100byte']);
cd('..')
close all

%%Plot and save data age for 500 byte packets
timeB=max(TT_524);
hold off
h = figure(1);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on
plot(TT_524, DA_524, 'k');


maxDA=max(DA_524);
axis([-10 max(timeB)+10 0 maxDA+0.2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXVehL, ' to ', RXVeh2L]})
legend('500 byte');

%Save the figure
cd('output')
savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_500byte']);
cd('..')
close all
%%Plot and save data age for 1500 byte packets
timeB=max(TT_1524);
hold off
h = figure(1);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on
plot(TT_1524, DA_1524, 'k');


maxDA=max(DA_1524);
axis([-10 max(timeB)+10 0 maxDA+0.2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 1500 byte packets ']; [TXVehL, ' to ', RXVeh2L]})
legend('1500 byte');

%Save the figure
cd('output')
savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_1500byte']);
cd('..')
close all

%% Create CDF plot for DAta age
h = figure(1);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on

a=cdfplot(DA_1524);
set(a,'color','r')
b=cdfplot(DA_524);
set(b,'color','k')
cdfplot(DA_124);


xlabel('Data age [s]');
ylabel('CDF [-]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
legend( '1500 byte','500 byte','100 byte');

%Save the figure
cd('output')
savefig(['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, ' CDF.']);
cd('..')
close all
%% Create pie diagrams for data age
bound1=0.15;
bound2=0.25;
bound3=0.5;
bound4=1;

% Get values for 124byte packet size
bound1_124=length(DA_124(DA_124>0 & DA_124<=bound1));
bound2_124=length(DA_124(DA_124>bound1));
bound3_124=length(DA_124(DA_124>bound2 & DA_124<=bound3));
bound4_124=length(DA_124(DA_124>bound3 & DA_124<=bound4));
bound5_124=length(DA_124(DA_124>bound4));

h=figure(1);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
pie([bound1_124 bound2_124 bound3_124 bound4_124 bound5_124])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 100 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})

legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
cd('output')
savefig(1,['3_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_100_byte']);
cd('..')
close all

% Get values for 524byte packet size
bound1_524=length(DA_524(DA_524>0 & DA_524<=bound1));
bound2_524=length(DA_524(DA_524>bound1));
bound3_524=length(DA_524(DA_524>bound2 & DA_524<=bound3));
bound4_524=length(DA_524(DA_524>bound3 & DA_524<=bound4));
bound5_524=length(DA_524(DA_524>bound4));
h=figure(2);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
pie([bound1_524 bound2_524 bound3_524 bound4_524 bound5_524])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 500 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})

legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
cd('output')
savefig(2,['2_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_500_byte']);
cd('..')
close all
% Get values for 1524byte packet size
bound1_1524=length(DA_1524(DA_1524>0 & DA_1524<=bound1));
bound2_1524=length(DA_1524(DA_1524>bound1));
bound3_1524=length(DA_1524(DA_1524>bound2 & DA_1524<=bound3));
bound4_1524=length(DA_1524(DA_1524>bound3 & DA_1524<=bound4));
bound5_1524=length(DA_1524(DA_1524>bound4));
h=figure(3);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
pie([bound1_1524 bound2_1524 bound3_1524 bound4_1524 bound5_1524])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 1500 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
%Save the figure
cd('output')
savefig(3,['1_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_1500_byte']);
cd('..')
close all
