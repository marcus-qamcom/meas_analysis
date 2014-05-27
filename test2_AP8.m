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
RXVeh2='DRF18L';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
RXVeh3='PltonL';
RXVeh4='DEF84L';
TXVeh='PlutoL';
fs=124; % 108 124 524 600m, frame size

%% Analysis starts here
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')

% Load data from receivers
[TT_2L RSSI_PltonL LAT_1L LONG_1L RX_SEQ_PltonL]=load_comm_link(testconf,t_no,AP,RXVeh2,TXVeh,fs);
[TT_3L RSSI_DEF84L LAT_1L LONG_1L RX_SEQ_DEF84L]=load_comm_link(testconf,t_no,AP,RXVeh3,TXVeh,fs);
[TT_4L RSSI_PlutoL LAT_1L LONG_1L RX_SEQ_PlutoL]=load_comm_link(testconf,t_no,AP,RXVeh4,TXVeh,fs);

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

[TT_1L RSSI_1L LAT_1L LONG_1L TX_SEQ_DRF18L]=load_comm_link(testconf,t_no,AP,TXVeh,TXVeh,fsTX);

%% Calculate NIR
[NIR] = calcNIR(TX_SEQ_DRF18L,RX_SEQ_PlutoL,RX_SEQ_PltonL,RX_SEQ_DEF84L);

% Present results
uniqueNIR=unique(NIR);
histogram=[uniqueNIR,histc(NIR(:),uniqueNIR)]

figure;
bar(histogram(:,1),histogram(:,2))
title('')
xlabel('NIR')
ylabel('Number of occurencies')
axis([-1 4 0 length(NIR)])




