%% Test 1
clear all 
close all
clc
%  addpath 'C:\Users\marcus.larsson\Documents\RelCommH\fromKristian'
%  addpath 'C:\Users\marcus.larsson\Documents\RelCommH\fromKristian\RelCommH mätutvärdering V9'
 addpath('..\data')
 addpath('helpfunctions')
% addpath ''

testconftestcase

%% Load data
t_no='1'; % test case number
%AP='8';        % 1,2,4,5,8
veh='PlutoL'; %'PltonL','PltonR','DEF84L','DEF84R','PlutoL','PlutoR'

frielndly_name='DRF18L'; %'DRF18L','DRF18R'
fs=124; % 108 124 524 600m, frame size

disp('gps ref')
% reference positions of stationary trucks:
if isequal(veh,'PltonL') || isequal(veh,'PltonR')
    [TT_L RSSI_L LAT_L LONG_L RX_SEQ_L]=load_comm_link(testconf,t_no,'5','DRF18L','PltonL',fs);
end
if isequal(veh,'DEF84L') || isequal(veh,'DEF84R')
    [TT_L RSSI_L LAT_L LONG_L RX_SEQ_L]=load_comm_link(testconf,t_no,'5','DRF18L','DEF84L',fs);
end
if isequal(veh,'PlutoL') || isequal(veh,'PlutoR')
    [TT_L RSSI_L LAT_L LONG_L RX_SEQ_L]=load_comm_link(testconf,t_no,'5','DRF18L','PlutoL',fs);
end

LAT_ref = mean(LAT_L);
LON_ref = mean(LONG_L);

clear TT_L RSSI_L LAT_L LONG_L RX_SEQ_L


%% Analysis starts here
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')
% [TT_2L RSSI_1L LAT_1L LONG_1L RX_SEQ_PltonL]=load_comm_link(testconf,t_no,'1','PltonL','DRF18L',fs);
% [TT_1L RSSI_DEF84L LAT_1L LONG_1L RX_SEQ_DEF84L]=load_comm_link(testconf,t_no,'1','DEF84L','DRF18L',fs);
[TT_4L RSSI_PlutoL LAT_1L LONG_1L RX_SEQ_PlutoL]=load_comm_link(testconf,t_no,'1','PlutoL','DRF18L',fs);
% [TT_1L RSSI_PlutoR LAT_1L LONG_1L RX_SEQ_PlutoR]=load_comm_link(testconf,t_no,'1','PlutoR','DRF18L',fs);
[TT_2L RSSI_PltonL LAT_1L LONG_1L RX_SEQ_PltonL]=load_comm_link(testconf,t_no,'1','PltonL','DRF18L',fs);
% [TT_1L RSSI_PltonR LAT_1L LONG_1L RX_SEQ_PltonR]=load_comm_link(testconf,t_no,'1','PltonR','DRF18L',fs);
[TT_3L RSSI_DEF84L LAT_1L LONG_1L RX_SEQ_DEF84L]=load_comm_link(testconf,t_no,'1','DEF84L','DRF18L',fs);
% [TT_1L RSSI_DEF84R LAT_1L LONG_1L RX_SEQ_DEF84R]=load_comm_link(testconf,t_no,'1','DEF84R','DRF18L',fs);
% TX frames smaller than RX frames
fs=108;
[TT_1L RSSI_1L LAT_1L LONG_1L TX_SEQ_DRF18L]=load_comm_link(testconf,t_no,'1','DRF18L','DRF18L',fs);

% %% Calculate PSR/PER
% PSR_DRF18L_to_PltonL = calcPSR(TX_SEQ_DRF18L,RX_SEQ_PltonL);
% 
% PSR_DRF18L_to_DEF84L = calcPSR(TX_SEQ_DRF18L,RX_SEQ_DEF84L);
%%
% [PER, vPER] = calcPER(TX_SEQ_DRF18L,RX_SEQ_PlutoR);
% [RSSI] = getRSSI(TX_SEQ_DRF18L, RX_SEQ_PlutoL, RX_SEQ_PlutoR, RSSI_PlutoL,RSSI_PlutoR);
[NIR] = calcNIR(TX_SEQ_DRF18L,RX_SEQ_PlutoL,RX_SEQ_PltonL,RX_SEQ_DEF84L);

% PER_DRF18L_to_PltonL = (1-PSR_DRF18L_to_PltonL)*100
% PER_DRF18L_to_PlutoL = (1-PSR_DRF18L_to_PlutoL)*100
% PER_DRF18L_to_DEF84L = (1-PSR_DRF18L_to_DEF84L)*100


% [TT_1R RSSI_1R LAT_1R LONG_1R RX_SEQ_1R]=load_comm_link(testconf,t_no,'1a',veh,'DRF18R',fs);
% 
% [TT_2L RSSI_2L LAT_2L LONG_2L RX_SEQ_2L]=load_comm_link(testconf,t_no,'2a',veh,'DRF18L',fs);
% [TT_2R RSSI_2R LAT_2R LONG_2R RX_SEQ_2R]=load_comm_link(testconf,t_no,'2a',veh,'DRF18R',fs);
% 
% [TT_4L RSSI_4L LAT_4L LONG_4L RX_SEQ_4L]=load_comm_link(testconf,t_no,'4a',veh,'DRF18L',fs);
% [TT_4R RSSI_4R LAT_4R LONG_4R RX_SEQ_4R]=load_comm_link(testconf,t_no,'4a',veh,'DRF18R',fs);
% 
% [TT_5L RSSI_5L LAT_5L LONG_5L RX_SEQ_5L]=load_comm_link(testconf,t_no,'5a',veh,'DRF18L',fs);
% [TT_5R RSSI_5R LAT_5R LONG_5R RX_SEQ_5R]=load_comm_link(testconf,t_no,'5a',veh,'DRF18R',fs);
% 
% [TT_8L RSSI_8L LAT_8L LONG_8L RX_SEQ_8L]=load_comm_link(testconf,t_no,'8a',veh,'DRF18L',fs);
% [TT_8R RSSI_8R LAT_8R LONG_8R RX_SEQ_8R]=load_comm_link(testconf,t_no,'8a',veh,'DRF18R',fs);

% 
% 
% %% Smooth RSSI a little bit
% disp('Analyze')
% window=21;
% RSSI_1Lb = Smooth(RSSI_1L, window);
% RSSI_1Rb = Smooth(RSSI_1R, window);
% RSSI_2Lb = Smooth(RSSI_2L, window);
% RSSI_2Rb = Smooth(RSSI_2R, window);
% RSSI_4Lb = Smooth(RSSI_4L, window);
% RSSI_4Rb = Smooth(RSSI_4R, window);
% RSSI_5Lb = Smooth(RSSI_5L, window);
% RSSI_5Rb = Smooth(RSSI_5R, window);
% RSSI_8Lb = Smooth(RSSI_8L, window);
% RSSI_8Rb = Smooth(RSSI_8R, window);
% 
% 
% 
% % Distances
% DD_1L = calcDistV(LAT_1L,LONG_1L,LAT_ref,LON_ref,-1);
% DD_2L = calcDistV(LAT_2L,LONG_2L,LAT_ref,LON_ref,-1);
% DD_4L = calcDistV(LAT_4L,LONG_4L,LAT_ref,LON_ref,-1);
% DD_5L = calcDistV(LAT_5L,LONG_5L,LAT_ref,LON_ref,-1);
% DD_8L = calcDistV(LAT_8L,LONG_8L,LAT_ref,LON_ref,-1);
% 
% DD_1R = calcDistV(LAT_1R,LONG_1R,LAT_ref,LON_ref,-1);
% DD_2R = calcDistV(LAT_2R,LONG_2R,LAT_ref,LON_ref,-1);
% DD_4R = calcDistV(LAT_4R,LONG_4R,LAT_ref,LON_ref,-1);
% DD_5R = calcDistV(LAT_5R,LONG_5R,LAT_ref,LON_ref,-1);
% DD_8R = calcDistV(LAT_8R,LONG_8R,LAT_ref,LON_ref,-1);
% 
% 
% %% plot data
% 
% % Left
% plot(DD_1L,RSSI_1Lb,'b')
% hold on
% plot(DD_2L,RSSI_2Lb,'r')
% plot(DD_4L,RSSI_4Lb,'g')
% plot(DD_5L,RSSI_5Lb,'c')
% plot(DD_8L,RSSI_8Lb,'m')
% hold off
% ylabel('RSSI [dBm]')
% xlabel('Distance [m]')
% 
% legend('AP1','AP2','AP4','AP5','AP8')
% title(['Test 1, AP(X), DRFL->' veh])
% 
% 
% % Right
% figure
% plot(DD_1R,RSSI_1Rb,'b')
% hold on
% plot(DD_2R,RSSI_2Rb,'r')
% plot(DD_4R,RSSI_4Rb,'g')
% plot(DD_5R,RSSI_5Rb,'c')
% plot(DD_8R,RSSI_8Rb,'m')
% hold off
% ylabel('RSSI [dBm]')
% xlabel('Distance [m]')
% 
% legend('AP1','AP2','AP4','AP5','AP8')
% title(['Test 1, AP(X), DRFR->' veh])
