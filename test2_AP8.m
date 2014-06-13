%% Test 2
clear all 
close all
clc

addpath('..\data')
addpath('helpfunctions')

testconftestcase

%% Load data
t_no='2'; % test case number
AP='8_10m';        % 1,2,4,5,8
RXVeh2L='PltonL';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
RXVeh3L='DEF84L';
RXVeh4L='PlutoL';
RXVeh2R='PltonR';
RXVeh3R='DEF84R';
RXVeh4R='PlutoR';
TXVehL='DRF18L';
TXVehR='DRF18R';
fs=524; % 108 124 524 600m, frame size

%% Analysis starts here
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')

% Load data from receivers
% Left antennas
[TT_2L RSSI_2L LAT_2L LONG_2L RX_SEQ_2L]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
[TT_3L RSSI_3L LAT_3L LONG_3L RX_SEQ_3L]=load_comm_link(testconf,t_no,AP,RXVeh3L,TXVehL,fs);
[TT_4L RSSI_4L LAT_4L LONG_4L RX_SEQ_4L]=load_comm_link(testconf,t_no,AP,RXVeh4L,TXVehL,fs);

% Right antennas
[TT_2R RSSI_2R LAT_2R LONG_2R RX_SEQ_2R]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
[TT_3R RSSI_3R LAT_3R LONG_3R RX_SEQ_3R]=load_comm_link(testconf,t_no,AP,RXVeh3R,TXVehL,fs);
[TT_4R RSSI_4R LAT_4R LONG_4R RX_SEQ_4R]=load_comm_link(testconf,t_no,AP,RXVeh4R,TXVehL,fs);

% Frame size not the same for sender and receiver
if fs==124
    fsTX=108;
end
if fs==524
    fsTX=508;
end
if fs==600
    fsTX=600;
end

[TT_1L RSSI_1L LAT_1L LONG_1L TX_SEQ_1L]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);
[TT_1R RSSI_1R LAT_1R LONG_1R TX_SEQ_1R]=load_comm_link(testconf,t_no,AP,TXVehR,TXVehR,fsTX);
%% Extract interesting data (remove half way curve)
%% Curve etc.

LAT_4L_ref  = 587951383; % LAT_4L(1)  for AP1_10m
LONG_4L_ref = 165571916; % LONG_4L(1) for AP1_10m

[DD1] = calcDistV(LAT_1L,LONG_1L,LAT_4L_ref,LONG_4L_ref,-2); % DRF
[DD2] = calcDistV(LAT_2L,LONG_2L,LAT_4L_ref,LONG_4L_ref,-2); % Platon
[DD3] = calcDistV(LAT_3L,LONG_3L,LAT_4L_ref,LONG_4L_ref,-2); % DEF
[DD4] = calcDistV(LAT_4L,LONG_4L,LAT_4L_ref,LONG_4L_ref,-2); % Pluto



% Timestamps from distance/position 
% Format: index/TTL_...
timestamp=zeros(8,7); %(time_index, veh. L/R)
% 1) All have started, last leaves starting point
timestamp(1,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 90, 0, 0);

% 2) first reaches start of curve at 650m:
timestamp(2,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 1100, 1, 0);

% 3) last reaches into curve at 670m:
timestamp(3,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 1140, 0, 0);

% 4) first reaches end of curve at 890m:
timestamp(4,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 1500, 1, 0);

% Way back
% 5) last reaches into curve
timestamp(5,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 1500, 0, 1);

% 6) first reaches end of curve
timestamp(6,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 1140, 1, 1);

% 7) last reaches into straight road
timestamp(7,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD4, 1100, 0, 1);

% 8) first reaches end of straight road
timestamp(8,:) = timestamp_test_2(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD1, 650, 1, 1);

%% Remove unwanted data
STRIPPED_RX_SEQ_2L=RX_SEQ_2L(timestamp(1,1):timestamp(2,1));
STRIPPED_RX_SEQ_2L=[STRIPPED_RX_SEQ_2L RX_SEQ_2L(timestamp(3,1):timestamp(4,1))];
STRIPPED_RX_SEQ_2L=[STRIPPED_RX_SEQ_2L RX_SEQ_2L(timestamp(5,1):timestamp(6,1))];
STRIPPED_RX_SEQ_2L=[STRIPPED_RX_SEQ_2L RX_SEQ_2L(timestamp(7,1):timestamp(8,1))];

STRIPPED_RX_SEQ_3L=RX_SEQ_3L(timestamp(1,1):timestamp(2,1));
STRIPPED_RX_SEQ_3L=[STRIPPED_RX_SEQ_3L RX_SEQ_3L(timestamp(3,1):timestamp(4,1))];
STRIPPED_RX_SEQ_3L=[STRIPPED_RX_SEQ_3L RX_SEQ_3L(timestamp(5,1):timestamp(6,1))];
STRIPPED_RX_SEQ_3L=[STRIPPED_RX_SEQ_3L RX_SEQ_3L(timestamp(7,1):timestamp(8,1))];

STRIPPED_RX_SEQ_4L=RX_SEQ_4L(timestamp(1,1):timestamp(2,1));
STRIPPED_RX_SEQ_4L=[STRIPPED_RX_SEQ_4L RX_SEQ_4L(timestamp(3,1):timestamp(4,1))];
STRIPPED_RX_SEQ_4L=[STRIPPED_RX_SEQ_4L RX_SEQ_4L(timestamp(5,1):timestamp(6,1))];
STRIPPED_RX_SEQ_4L=[STRIPPED_RX_SEQ_4L RX_SEQ_4L(timestamp(7,1):timestamp(8,1))];

STRIPPED_TX_SEQ_1L=TX_SEQ_1L(timestamp(1,1):timestamp(2,1));
STRIPPED_TX_SEQ_1L=[STRIPPED_TX_SEQ_1L TX_SEQ_1L(timestamp(3,1):timestamp(4,1))];
STRIPPED_TX_SEQ_1L=[STRIPPED_TX_SEQ_1L TX_SEQ_1L(timestamp(5,1):timestamp(6,1))];
STRIPPED_TX_SEQ_1L=[STRIPPED_TX_SEQ_1L TX_SEQ_1L(timestamp(7,1):timestamp(8,1))];

STRIPPED_RX_SEQ_2R=RX_SEQ_2R(timestamp(1,1):timestamp(2,1));
A=1
STRIPPED_RX_SEQ_2R=[STRIPPED_RX_SEQ_2R RX_SEQ_2R(timestamp(3,1):timestamp(4,1))];
% STRIPPED_RX_SEQ_2R=[STRIPPED_RX_SEQ_2R RX_SEQ_2R(timestamp(5,1):timestamp(6,1))];
% STRIPPED_RX_SEQ_2R=[STRIPPED_RX_SEQ_2R RX_SEQ_2R(timestamp(7,1):timestamp(8,1))];
A=2
STRIPPED_RX_SEQ_3R=RX_SEQ_3R(timestamp(1,1):timestamp(2,1));
STRIPPED_RX_SEQ_3R=[STRIPPED_RX_SEQ_3R RX_SEQ_3R(timestamp(3,1):timestamp(4,1))];
keyboard
STRIPPED_RX_SEQ_3R=[STRIPPED_RX_SEQ_3R RX_SEQ_3R(timestamp(5,1):timestamp(6,1))];
A=3
STRIPPED_RX_SEQ_3R=[STRIPPED_RX_SEQ_3R RX_SEQ_3R(timestamp(7,1):timestamp(8,1))];

% STRIPPED_RX_SEQ_4R=RX_SEQ_4R(timestamp(1,1):timestamp(2,1));
% STRIPPED_RX_SEQ_4R=[STRIPPED_RX_SEQ_4R RX_SEQ_4R(timestamp(3,1):timestamp(4,1))];
% STRIPPED_RX_SEQ_4R=[STRIPPED_RX_SEQ_4R RX_SEQ_4R(timestamp(5,1):timestamp(6,1))];
% STRIPPED_RX_SEQ_4R=[STRIPPED_RX_SEQ_4R RX_SEQ_4R(timestamp(7,1):timestamp(8,1))];

%% Calculate NIR
[NIR] = calcNIR(STRIPPED_TX_SEQ_1L, STRIPPED_RX_SEQ_2L, STRIPPED_RX_SEQ_3L, STRIPPED_RX_SEQ_4R, STRIPPED_RX_SEQ_2R, STRIPPED_RX_SEQ_3R, STRIPPED_RX_SEQ_4R);
[PER, vPER] = calcPER(TX_SEQ_1L, RX_SEQ_4L);

% Present results
uniqueNIR=unique(NIR);
histogram=[uniqueNIR,histc(NIR(:),uniqueNIR)]

figure;
bar(histogram(:,1),histogram(:,2))
title('')
xlabel('NIR')
ylabel('Number of occurencies')
axis([-1 4 0 length(NIR)])




