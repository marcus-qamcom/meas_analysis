clear all 
close all
clc

addpath('..\data')
addpath('helpfunctions')

testconftestcase

%% Load data
t_no='6'; % test case number
AP='4';% 1,2,4,5,8
APnum=AP;
dist='0';
TXLeft='DEF84L';
TXRight='DEF84R';

RXLeft='PlutoL';%'PlutoL';
RXRight='PlutoR';%'PlutoR';

% compensator for DEF84 to Pluto
% timeCompensator = [2 0 -1 1]; %[LL LR RR RL]
% compensator for Plton to Pluto
% timeCompensator = [0 -2 -2 0]; %[LL LR RR RL]
% compensator for DRF18 to Pluto
timeCompensator = [2 0 -1 1]; %[LL LR RR RL]

%% Load and trim data
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')

% Load data from receivers for 524 byte packets
fs=524;
% Recieveloggs!
% Left to left antennas
[TT_LL_524, RSSI_LL_524, LAT_LL_524, LONG_LL_524, RX_SEQ_LL_524 LAB_LL_524 V_LL_524]=load_comm_link(testconf,t_no,AP,RXLeft,TXLeft,fs);
% Left to right antennas
[TT_LR_524, RSSI_LR_524, LAT_LR_524, LONG_LR_524, RX_SEQ_LR_524 LAB_LR_524 V_LR_524]=load_comm_link(testconf,t_no,AP,RXRight,TXLeft,fs);
% Right to right antennas
[TT_RR_524, RSSI_RR_524, LAT_RR_524, LONG_RR_524, RX_SEQ_RR_524 LAB_RR_524 V_RR_524]=load_comm_link(testconf,t_no,AP,RXRight,TXRight,fs);
% Right to left antennas
[TT_RL_524, RSSI_RL_524, LAT_RL_524, LONG_RL_524, RX_SEQ_RL_524 LAB_RL_524 V_RL_524]=load_comm_link(testconf,t_no,AP,RXLeft,TXRight,fs);

% Sendloggs to see the total number of sent packages.
fs=508;
[TT_L_524_TX, RSSI_L_524_TX, LAT_L_524_TX, LONG_L_524_TX, TX_SEQ_L_524 LAB_L_524 V_L_524]=load_comm_link(testconf,t_no,AP,TXLeft,TXLeft,fs);
[TT_R_524_TX, RSSI_R_524_TX, LAT_R_524_TX, LONG_R_524_TX, TX_SEQ_R_524 LAB_R_524 V_R_524]=load_comm_link(testconf,t_no,AP,TXRight,TXRight,fs);

%% Trim loaded data

close all
LAT_LL_ref  =  590846416; % LAT_4L(1)  for AP1
LONG_LL_ref =  175958966; % LONG_4L(1) for AP1

%% TODO: Här är det något som är fel, ta en titt på detta!
[DD1_LL_524] = calcDistV(LAT_L_524_TX,LONG_L_524_TX,LAT_LL_ref,LONG_LL_ref,-2);
[DD2_LL_524] = calcDistV(LAT_LL_524,LONG_LL_524,LAT_LL_ref,LONG_LL_ref,-2);

[DD1_LR_524] = calcDistV(LAT_L_524_TX,LONG_L_524_TX,LAT_LL_ref,LONG_LL_ref,-2);
[DD2_LR_524] = calcDistV(LAT_LR_524,LONG_LR_524,LAT_LL_ref,LONG_LL_ref,-2);

[DD1_RL_524] = calcDistV(LAT_R_524_TX,LONG_R_524_TX,LAT_LL_ref,LONG_LL_ref,-2);
[DD2_RL_524] = calcDistV(LAT_RL_524,LONG_RL_524,LAT_LL_ref,LONG_LL_ref,-2);

[DD1_RR_524] = calcDistV(LAT_R_524_TX,LONG_R_524_TX,LAT_LL_ref,LONG_LL_ref,-2);
[DD2_RR_524] = calcDistV(LAT_RR_524,LONG_RR_524,LAT_LL_ref,LONG_LL_ref,-2);
% plot route
%%
figure(1)
plot(DD1_LL_524(:,2),-DD1_LL_524(:,1),'b')
hold on
plot(DD2_LL_524(:,2),-DD2_LL_524(:,1),'r')
hold off
%
%% Get time stamps for Left to Left channel
timestamp_524_LL=zeros(4,3); %(time_index
% 1) All have started, last leaves starting point
timestamp_524_LL(1,:) = timestamp_test_6_2(TT_L_524_TX, TT_LL_524, TT_LL_524, DD2_LL_524, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_524_LL(2,:) = timestamp_test_6_2(TT_L_524_TX, TT_LL_524, TT_LL_524, DD1_LL_524, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:
timestamp_524_LL(3,:) = timestamp_test_6_2(TT_L_524_TX, TT_LL_524, TT_LL_524, DD2_LL_524, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_524_LL(4,:) = timestamp_test_6_2(TT_L_524_TX, TT_LL_524, TT_LL_524, DD1_LL_524, 800, 1, 1);

% Get timestamps for Left to Right channels
timestamp_524_LR=zeros(4,3); %(time_index
% 1) All have started, last leaves starting point
timestamp_524_LR(1,:) = timestamp_test_6_2(TT_L_524_TX, TT_LR_524, TT_LR_524, DD2_LR_524, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_524_LR(2,:) = timestamp_test_6_2(TT_L_524_TX, TT_LR_524, TT_LR_524, DD1_LR_524, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:
timestamp_524_LR(3,:) = timestamp_test_6_2(TT_L_524_TX, TT_LR_524, TT_LR_524, DD2_LR_524, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_524_LR(4,:) = timestamp_test_6_2(TT_L_524_TX, TT_LR_524, TT_LR_524, DD1_LR_524, 800, 1, 1);

%Get timestamps for Right to Right channel

timestamp_524_RR=zeros(4,3); %(time_index
%1) All have started, last leaves starting point
timestamp_524_RR(1,:) = timestamp_test_6_2(TT_R_524_TX, TT_RR_524, TT_RR_524, DD2_RR_524, 2200, 0, 0);
%2) first reaches E4 exit in east direction at 6100m:
timestamp_524_RR(2,:) = timestamp_test_6_2(TT_R_524_TX, TT_RR_524, TT_RR_524, DD1_RR_524, 6100, 1, 0);
% Way back
% 3) last truck back onto E4 west direction at 6000m:
timestamp_524_RR(3,:) = timestamp_test_6_2(TT_R_524_TX, TT_RR_524, TT_RR_524, DD2_RR_524, 5500, 0, 1);

% 4) first reaches E4 exit end of straight road
timestamp_524_RR(4,:) = timestamp_test_6_2(TT_R_524_TX, TT_RR_524, TT_RR_524, DD1_RR_524, 800, 1, 1);

%Get timestamps for Right to Left channel
timestamp_524_RL=zeros(4,3); %(time_index
% 1) All have started, last leaves starting point
timestamp_524_RL(1,:) = timestamp_test_6_2(TT_R_524_TX, TT_RL_524, TT_RL_524, DD2_RL_524, 2200, 0, 0);
% 2) first reaches E4 exit in east direction at 6100m:
timestamp_524_RL(2,:) = timestamp_test_6_2(TT_R_524_TX, TT_RL_524, TT_RL_524, DD1_RL_524, 6100, 1, 0);
% % Way back
% % 3) last truck back onto E4 west direction at 6000m:
timestamp_524_RL(3,:) = timestamp_test_6_2(TT_R_524_TX, TT_RL_524, TT_RL_524, DD2_RL_524, 5500, 0, 1);
% 
% % 4) first reaches E4 exit end of straight road
timestamp_524_RL(4,:) = timestamp_test_6_2(TT_R_524_TX, TT_RL_524, TT_RL_524, DD1_RL_524, 800, 1, 1);

%time_stamp=[200 1250 1350 1700]
% scatter(DD1_524(timestamp_524_LL(1:2,1),2),-DD1_524(timestamp_524_LL(1:2,1),1),60,'b*')
% scatter(DD2_524(timestamp_524_LL(1:2,2),2),-DD2_524(timestamp_524_LL(1:2,2),1),60,'r*')
% 
% for t=1:4
%     text(DD1_524(timestamp_524_LL(t),2)+30,-DD1_524(timestamp_524_LL(t),1)-30,num2str(t),'FontSize',18)
% end
% ylabel('Distance [m]')
% xlabel('Distance [m]')
% axis equal
% hold off
% % close all

 
%% Calculate data age for Left to left channel.
[DA_524a, TT_2_524a, TT_TX_500a]=calcDA_mod(TX_SEQ_L_524(timestamp_524_LL(1,1):timestamp_524_LL(2,1)), TT_L_524_TX(timestamp_524_LL(1,1):timestamp_524_LL(2,1))+timeCompensator(1), RX_SEQ_LL_524(timestamp_524_LL(1,3):timestamp_524_LL(2,3)), TT_LL_524(timestamp_524_LL(1,3):timestamp_524_LL(2,3)),1);
[DA_524b, TT_2_524b, TT_TX_500b]=calcDA_mod(TX_SEQ_L_524(timestamp_524_LL(3,1):timestamp_524_LL(4,1)), TT_L_524_TX(timestamp_524_LL(3,1):timestamp_524_LL(4,1))+timeCompensator(1), RX_SEQ_LL_524(timestamp_524_LL(3,3):timestamp_524_LL(4,3)), TT_LL_524(timestamp_524_LL(3,3):timestamp_524_LL(4,3)),1);
DA_LL_500 = [DA_524a DA_524b];
tmptime=TT_TX_500a-TT_TX_500a(1);
TT_TX_LL_500=[TT_TX_500a-TT_TX_500a(1) TT_TX_500b-TT_TX_500b(1)+tmptime(end)];

% Calculate data age for Left to right channel.
[DA_524a, TT_2_524a, TT_TX_500a]=calcDA_mod(TX_SEQ_L_524(timestamp_524_LR(1,1):timestamp_524_LR(2,1)), TT_L_524_TX(timestamp_524_LR(1,1):timestamp_524_LR(2,1))+timeCompensator(2), RX_SEQ_LR_524(timestamp_524_LR(1,3):timestamp_524_LR(2,3)), TT_LR_524(timestamp_524_LR(1,3):timestamp_524_LR(2,3)),1);
[DA_524b, TT_2_524b, TT_TX_500b]=calcDA_mod(TX_SEQ_L_524(timestamp_524_LR(3,1):timestamp_524_LR(4,1)), TT_L_524_TX(timestamp_524_LR(3,1):timestamp_524_LR(4,1))+timeCompensator(2), RX_SEQ_LR_524(timestamp_524_LR(3,3):timestamp_524_LR(4,3)), TT_LR_524(timestamp_524_LR(3,3):timestamp_524_LR(4,3)),1);
DA_LR_500 = [DA_524a DA_524b];
tmptime=TT_TX_500a-TT_TX_500a(1);
TT_TX_LR_500=[TT_TX_500a-TT_TX_500a(1) TT_TX_500b-TT_TX_500b(1)+tmptime(end)];

% Calculate data age for Right to Right channel.
[DA_524a, TT_2_524a, TT_TX_500a]=calcDA_mod(TX_SEQ_R_524(timestamp_524_RR(1,1):timestamp_524_RR(2,1)), TT_R_524_TX(timestamp_524_RR(1,1):timestamp_524_RR(2,1))+timeCompensator(3), RX_SEQ_RR_524(timestamp_524_RR(1,3):timestamp_524_RR(2,3)), TT_RR_524(timestamp_524_RR(1,3):timestamp_524_RR(2,3)),1);
[DA_524b, TT_2_524b, TT_TX_500b]=calcDA_mod(TX_SEQ_R_524(timestamp_524_RR(3,1):timestamp_524_RR(4,1)), TT_R_524_TX(timestamp_524_RR(3,1):timestamp_524_RR(4,1))+timeCompensator(3), RX_SEQ_RR_524(timestamp_524_RR(3,3):timestamp_524_RR(4,3)), TT_RR_524(timestamp_524_RR(3,3):timestamp_524_RR(4,3)),1);
DA_RR_500 = [DA_524a DA_524b];
tmptime=TT_TX_500a-TT_TX_500a(1);
TT_TX_RR_500=[TT_TX_500a-TT_TX_500a(1) TT_TX_500b-TT_TX_500b(1)+tmptime(end)];

% Calculate data age for Right to Left channel.
[DA_524a, TT_2_524a, TT_TX_500a]=calcDA_mod(TX_SEQ_R_524(timestamp_524_RL(1,1):timestamp_524_RL(2,1)), TT_R_524_TX(timestamp_524_RL(1,1):timestamp_524_RL(2,1))+timeCompensator(4), RX_SEQ_RL_524(timestamp_524_RL(1,3):timestamp_524_RL(2,3)), TT_RL_524(timestamp_524_RL(1,3):timestamp_524_RL(2,3)),1);
[DA_524b, TT_2_524b, TT_TX_500b]=calcDA_mod(TX_SEQ_R_524(timestamp_524_RL(3,1):timestamp_524_RL(4,1)), TT_R_524_TX(timestamp_524_RL(3,1):timestamp_524_RL(4,1))+timeCompensator(4), RX_SEQ_RL_524(timestamp_524_RL(3,3):timestamp_524_RL(4,3)), TT_RL_524(timestamp_524_RL(3,3):timestamp_524_RL(4,3)),1);
DA_RL_500 = [DA_524a DA_524b];
tmptime=TT_TX_500a-TT_TX_500a(1);
TT_TX_RL_500=[TT_TX_500a-TT_TX_500a(1) TT_TX_500b-TT_TX_500b(1)+tmptime(end)];





% %% Calculate PER for 124 byte packets
% [PER_124, vPER_124]=calcPER([TX_SEQ_1L_124(timestamp_124(1,1):timestamp_124(2,1)) TX_SEQ_1L_124(timestamp_124(3,1):timestamp_124(4,1))],[RX_SEQ_2L_124(timestamp_124(1,3):timestamp_124(2,3)) RX_SEQ_2L_124(timestamp_124(3,3):timestamp_124(4,3))]);
% [PER_524, vPER_524]=calcPER([TX_SEQ_1L_524(timestamp_124(1,1):timestamp_524(2,1)) TX_SEQ_1L_524(timestamp_524(3,1):timestamp_524(4,1))],[RX_SEQ_2L_524(timestamp_524(1,3):timestamp_524(2,3)) RX_SEQ_2L_524(timestamp_524(3,3):timestamp_524(4,3))]);
% [PER_1524, vPER_1524]=calcPER([TX_SEQ_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)) TX_SEQ_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1))],[RX_SEQ_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)) RX_SEQ_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3))]);
% 
% %% plot and save
% % Concatanate data age according packet size
% % Use these time vectors when not filling data age with 0.1...
% 
% timeA=TT_2_124a-TT_2_124a(1);
% TT_124=[TT_2_124a-TT_2_124a(1) TT_2_124b-TT_2_124b(1)+timeA(end-1)];
% 
% timeA=TT_2_524a-TT_2_524a(1);
% TT_524=[TT_2_524a-TT_2_524a(1) (TT_2_524b-TT_2_524b(1))+timeA(end-1)];
% 
% timeA=TT_2_1524a-TT_2_1524a(1);
% TT_1524=[TT_2_1524a-TT_2_1524a(1) (TT_2_1524b-TT_2_1524b(1))+timeA(end-1)];
% 
% %% Save params
% cd('output')
% save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '100byte'], 'DA_124', 'TT_124', 'PER_124', 'vPER_124');
% save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '500byte'], 'DA_524', 'TT_524', 'PER_524', 'vPER_524');
% save(['Params_for_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '1500byte'], 'DA_1524', 'TT_1524', 'PER_1524', 'vPER_1524');
% cd('..')
% 

%% classify direction and extract right turning information when turning 
% right and left information when turning left.
t1=TT_L_524_TX(timestamp_524_LL(1,1):timestamp_524_LL(2,1));
t1=t1-t1(1);
t2=TT_L_524_TX(timestamp_524_LL(3,1):timestamp_524_LL(4,1));
t2=t2-t2(1)+t1(end);
plottime=[t1 t2];

idxs=[(timestamp_524_LL(1,1):timestamp_524_LL(2,1)) (timestamp_524_LL(3,1):timestamp_524_LL(4,1))];
lat=(LAT_L_524_TX(idxs)*0.0000001)'; % Multiplication due to formating in the loggfiles.
long=(LONG_L_524_TX(idxs)*0.0000001)'; % Multiplication due to formating in the loggfiles.
[E,N] = deg2utm(lat, long); 


% Det Degermanska trolleriet... och det är lätt!!!
E = E-mean(E);
N = N-mean(N);
V = ((V_L_524(idxs))/3.6)'; %/3.6 to get in [m/s]
timevector=TT_L_524_TX(idxs);

% filter to get good acceleration (Kalman stuff)

% init state
x = [E(1),N(1),(E(2)-E(1))/1,(N(2)-N(1))/1]';
P = diag([5,5,5,5].^2);
% state transition
T = 0.1;
F = kron([1,T;0,1],eye(2));
% modeling errors
% q = 5;
q = 0.5;
Q = q^2*kron([T/3,T/2;T/2,T],eye(2));
% measurement error
R = diag([5,5,5].^2);

X = [];

for i=2:length(idxs)
    
    T=TT_L_524_TX(i)-TT_L_524_TX(i-1);
    Q = q^2*kron([T/3,T/2;T/2,T],eye(2));
    F = kron([1,T;0,1],eye(2));
    % predicted state
    xp = F*x;
    Pp = F*P*F' + Q;   
    % predicted velocity (from state)
    vp = sqrt(xp(3)^2+xp(4)^2);
   
    % meausrement
    z  = [E(i),N(i),V(i)]';
    % predicted measurement
    zp = [x(1),x(2),vp]';
   
    % residual
    y  = z - zp;
   
    % measurement Jacobian
    H  = [1,0,0,0;0,1,0,0;0,0,xp(3)/vp,xp(4)/vp];
   
    % residual covariance
    S  = H*Pp*H' + R;
   
    % Kalman gain
    K  = Pp*H'*inv(S);
    
    % update
    x  = xp + K*y;
    P  = (eye(4)-K*H)*Pp;
    
    X = [X,x];
    
end

vx = X(3,:);
vy = X(4,:);

% Classify direction and plot
turn = gradient(atan2(vy,vx));
%unwrap the pi's
turn(turn>0.9*pi)=turn(turn>0.9*pi)-pi;
turn(turn<-0.9*pi)=turn(turn<-0.9*pi)+pi;

turn_indicator = zeros(size(turn));
turn_indicator(turn>0.0004) = 1;
turn_indicator(turn<-0.0004) = -1;

figure(1);
hold on;
cla;
title('turning');
turnlogg=zeros(1,length(idxs));
for i=1:length(idxs)-1
    
    if turn_indicator(i)==1
        plot(X(1,i),X(2,i),'r*');
        turnlogg(i)=1;
    elseif turn_indicator(i)==-1
        plot(X(1,i),X(2,i),'b*');
        turnlogg(i)=0.9;
    else
        plot(X(1,i),X(2,i),'g*');
        turnlogg(i)=0;
    end
    
end

%% Extract DA for left resp. right curves
[straightIndex, leftIndex, rightIndex] = getTurnIndex(turnlogg);
[ DA, DA_LeftRight ] = getDARightLeft(DA_LL_500, DA_RR_500, straightIndex, leftIndex, rightIndex);
meanDA_RR=mean(DA_RR_500)
meanDA_LL=mean(DA_LL_500)
meanDA_geo_choose=mean(DA)
menaDA_mix=mean(DA_LeftRight)


%% Plot figures
% Plot data age for left to left channel
timeB=max(TT_TX_LL_500);
hold off
h = figure(2);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on

plot(TT_TX_LL_500, DA_LL_500, 'k');
plot(plottime,turnlogg,'*')

maxDA=max(DA_LL_500);
axis([-10 max(timeB)+10 0 maxDA+0.2])
% axis([-10 max(timeB)+10 0 2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXLeft, ' to ', RXLeft]})
legend('500 byte');

% plot RR channel
timeB=max(TT_TX_RR_500);
hold off
h = figure(4);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on

plot(TT_TX_RR_500, DA_RR_500, 'k');
plot(plottime,turnlogg,'*')
maxDA=max(DA_RR_500);
axis([-10 max(timeB)+10 0 maxDA+0.2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXRight, ' to ', RXRight]})
legend('500 byte');

% plot mixed channel
timeB=max(TT_TX_LL_500);
hold off
h = figure(5);
set(h, 'Units','centimeters','Position', [14 10 14 10]);
hold on

plot(TT_TX_LL_500, DA, 'k');
plot(plottime,turnlogg,'*')
maxDA=max(DA);
axis([-10 max(timeB)+10 0 maxDA+0.2])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [' mix of left and right channel depening on heading']})
legend('500 byte');

% % Plot and save data age for right to left channel
% timeB=max(TT_TX_RL_500);
% hold off
% h = figure(5);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% hold on
% 
% plot(TT_TX_RL_500, DA_RL_500, 'k');
% 
% maxDA=max(DA_RL_500);
% axis([-10 max(timeB)+10 0 2])
% xlabel('Elapsed Time [s]');
% ylabel('Data Age [s]')
% title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXRight, ' to ', RXLeft]})
% legend('500 byte');
% 
% % Plot data age for left to right channel
% timeB=max(TT_TX_LR_500);
% hold off
% h = figure(3);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% hold on
% 
% plot(TT_TX_LR_500, DA_LR_500, 'k');
% 
% maxDA=max(DA_LR_500);
% axis([-10 max(timeB)+10 0 2])
% xlabel('Elapsed Time [s]');
% ylabel('Data Age [s]')
% title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXLeft, ' to ', RXRight]})
% legend('500 byte');
% Plot data age for right to right channel
% 


















%% Below is old and shall maybe not be used!





% 
% %Save the figure
% cd('output')
% savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_100byte']);
% cd('..')
% % close all
% 
% %% Plot and save data age for 500 byte packets
% timeB=max(TT_TX_500);
% hold off
% h = figure(1);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% hold on
% plot(TT_TX_500, DA_524, 'k');
% 
% 
% maxDA=max(DA_524);
% axis([-10 max(timeB)+10 0 maxDA+0.2])
% xlabel('Elapsed Time [s]');
% ylabel('Data Age [s]')
% title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 500 byte packets ']; [TXVehL, ' to ', RXVeh2L]})
% legend('500 byte');
% 
% %Save the figure
% cd('output')
% savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_500byte']);
% cd('..')
% close all
% %% Plot and save data age for 1500 byte packets
% timeB=max(TT_TX_1500);
% hold off
% h = figure(1);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% hold on
% plot(TT_TX_1500, DA_1524, 'k');
% 
% 
% maxDA=max(DA_1524);
% axis([-10 max(timeB)+10 0 maxDA+0.2])
% xlabel('Elapsed Time [s]');
% ylabel('Data Age [s]')
% title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, 1500 byte packets ']; [TXVehL, ' to ', RXVeh2L]})
% legend('1500 byte');
% 
% %Save the figure
% cd('output')
% savefig(['4_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_1500byte']);
% cd('..')
% close all
% 
% %% Create CDF plot for DAta age
% h = figure(1);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% hold on
% 
% a=cdfplot(DA_1524);
% set(a,'color','r')
% b=cdfplot(DA_524);
% set(b,'color','k')
% axis([0 2 0 1]);
% cdfplot(DA_124);
% 
% 
% xlabel('Data age [s]');
% ylabel('CDF [-]')
% title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
% legend( '1500 byte','500 byte','100 byte');
% 
% %Save the figure
% cd('output')
% savefig(['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, ' CDF']);
% cd('..')
% close all
% %% Create pie diagrams for data age
% bound1=0.15;
% bound2=0.25;
% bound3=0.5;
% bound4=1;
% 
% % Get values for 124byte packet size
% bound1_124=length(DA_124(DA_124>0 & DA_124<=bound1));
% bound2_124=length(DA_124(DA_124>bound1));
% bound3_124=length(DA_124(DA_124>bound2 & DA_124<=bound3));
% bound4_124=length(DA_124(DA_124>bound3 & DA_124<=bound4));
% bound5_124=length(DA_124(DA_124>bound4));
% 
% h=figure(1);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% pie([bound1_124 bound2_124 bound3_124 bound4_124 bound5_124])
% title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 100 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
% 
% legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
% cd('output')
% savefig(1,['3_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_100_byte']);
% cd('..')
% close all
% 
% % Get values for 524byte packet size
% bound1_524=length(DA_524(DA_524>0 & DA_524<=bound1));
% bound2_524=length(DA_524(DA_524>bound1));
% bound3_524=length(DA_524(DA_524>bound2 & DA_524<=bound3));
% bound4_524=length(DA_524(DA_524>bound3 & DA_524<=bound4));
% bound5_524=length(DA_524(DA_524>bound4));
% h=figure(2);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% pie([bound1_524 bound2_524 bound3_524 bound4_524 bound5_524])
% title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 500 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
% 
% legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
% cd('output')
% savefig(2,['2_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_500_byte']);
% cd('..')
% close all
% % Get values for 1524byte packet size
% bound1_1524=length(DA_1524(DA_1524>0 & DA_1524<=bound1));
% bound2_1524=length(DA_1524(DA_1524>bound1));
% bound3_1524=length(DA_1524(DA_1524>bound2 & DA_1524<=bound3));
% bound4_1524=length(DA_1524(DA_1524>bound3 & DA_1524<=bound4));
% bound5_1524=length(DA_1524(DA_1524>bound4));
% h=figure(3);
% set(h, 'Units','centimeters','Position', [14 10 14 10]);
% pie([bound1_1524 bound2_1524 bound3_1524 bound4_1524 bound5_1524])
% title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 1500 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
% legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
% %Save the figure
% cd('output')
% savefig(3,['1_Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_1500_byte']);
% cd('..')
% close all
