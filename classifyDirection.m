clear all 
close all
clc

addpath('..\data')
addpath('helpfunctions')

testconftestcase
% Load data
%parameters in function call
t_no='6'; % test case number
APnum='1';        % 1,2,4,5,8
dist='0';
RXVeh2L='PlutoL';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
RXVeh2R='PlutoR';
TXVehL='DEF84L';
enableRight=1;

if dist=='0'
   AP=APnum; 
else
    AP=[APnum '_' dist];
end
fs=124;
[TT_2L_124 RSSI_2L_124 LAT_2L_124 LONG_2L_124 RX_SEQ_2L_124 LAB_124 V_2L_124]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_124 RSSI_2R_124 LAT_2R_124 LONG_2R_124 RX_SEQ_2R_124]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=108;
[TT_1L_124 RSSI_1L_124 LAT_1L_124 LONG_1L_124 TX_SEQ_1L_124 LAB_124 V_1L_124]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);
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

% Trim loaded data

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
%
plot(DD1_124(:,2),-DD1_124(:,1),'b')
hold on
plot(DD2_124(:,2),-DD2_124(:,1),'r')
%
% Get time stamps for packet size 124 byte
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

% Get rest of the timestamps
% Get time stamps for packet size 524 byte
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

% Get time stamps for packet size 1524 byte
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

%% Classify direction
%Insted of running the above, just read the parameters from .mat file
% load('degermannparametrar.mat');
idxs=[(timestamp_124(1,1):timestamp_124(2,1)) (timestamp_124(3,1):timestamp_124(4,1))];
lat=(LAT_1L_124(idxs)*0.0000001)';
long=(LONG_1L_124(idxs)*0.0000001)';
[E,N] = deg2utm(lat, long); % Multiplication due to formating in the loggfiles, correct?


%% Det Degermanska trolleriet... och det är lätt!!!
E = E-mean(E);
N = N-mean(N);
V = ((V_1L_124(idxs))/3.6)'; %/3.6 to get in [m/s]


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

for i=1:length(idxs)
    
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

%% Classify direction and plot
turn = gradient(atan2(vy,vx));
%unwrap the pi's
turn(turn>0.9*pi)=turn(turn>0.9*pi)-pi;
turn(turn<-0.9*pi)=turn(turn<-0.9*pi)+pi;

turn_indicator = zeros(size(turn));
turn_indicator(turn>0.0004) = 1;
turn_indicator(turn<-0.0004) = -1;

figure(7);
hold on;
cla;
title('turning');
turnlogg=zeros(1,length(idxs));
for i=1:length(idxs)
    
    if turn_indicator(i)==1
        plot(X(1,i),X(2,i),'r*');
        turnlogg(i)=0.2;
    elseif turn_indicator(i)==-1
        plot(X(1,i),X(2,i),'b*');
        turnlogg(i)=-0.2;
    else
        plot(X(1,i),X(2,i),'g*');
        turnlogg(i)=0;
    end
    
end
hold off;
axis equal


% %% Plot figures
% figure(1);
% plot(idxs,gradient(E),idxs,vx)
% title('velocity(x) - from data and filtered');
% 
% figure(2);
% plot(idxs(1:end-2),diff(E,2),idxs,gradient(vx))
% title('acceleration(x) - from data and filtered');
% 
% %% Classify acceleration and plot
% % classify (rudimentary)
% 
% v = sqrt(vx.^2+vy.^2);
% acc = gradient(v);
% acc_indicator = zeros(size(acc));
% acc_indicator(acc<-0.3)=-1;
% acc_indicator(acc>0.3)=1;
% figure(6);
% hold on;
% cla;
% title('acceleration');
% 
% for i=1:length(idxs)
%     
%     if acc_indicator(i)==1
%         plot(X(1,i),X(2,i),'*r');
%     elseif acc_indicator(i)==-1
%         plot(X(1,i),X(2,i),'*b');
%     else
%         plot(X(1,i),X(2,i),'*g');
%     end
%     
% end
% hold off;
% axis equal

