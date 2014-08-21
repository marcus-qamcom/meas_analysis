clear all 
close all
clc

addpath('..\data')
addpath('helpfunctions')

testconftestcase

%% Load data
%parameters in function call
t_no='6'; % test case number
APnum='2';        % 1,2,4,5,8
dist='0';
RXVeh2L='PlutoL';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
RXVeh2R='PlutoL';
TXVehL='PltonL';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
enableRight=0;
% if nargin==7
%     enableRight=1;
% end

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
[TT_2L_124 RSSI_2L_124 LAT_2L_124 LONG_2L_124 RX_SEQ_2L_124 LAB_2L_124 V_2L_124]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_124 RSSI_2R_124 LAT_2R_124 LONG_2R_124 RX_SEQ_2R_124 LAB_2R_124 V_2R_124]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=108;
[TT_1L_124 RSSI_1L_124 LAT_1L_124 LONG_1L_124 TX_SEQ_1L_124 LAB_1L_124 V_1L_124]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);
% Frame size not the same for sender and receiver

% Load data from receivers for 524 byte packets
fs=524;
% Left antennas
[TT_2L_524 RSSI_2L_524 LAT_2L_524 LONG_2L_524 RX_SEQ_2L_524 LAB_2L_524 V_2L_524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_524 RSSI_2R_524 LAT_2R_524 LONG_2R_524 RX_SEQ_2R_524 LAB_2R_524 V_2R_524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=508;
[TT_1L_524 RSSI_1L_524 LAT_1L_524 LONG_1L_524 TX_SEQ_1L_524 LAB_1L_524 V_1L_524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);

% Load data from receivers for 524 byte packets
fs=600;
% Left antennas
[TT_2L_1524 RSSI_2L_1524 LAT_2L_1524 LONG_2L_1524 RX_SEQ_2L_1524 LAB_2L_1524 V_2L_1524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
if enableRight
    [TT_2R_1524 RSSI_2R_1524 LAT_2R_1524 LONG_2R_1524 RX_SEQ_2R_1524 LAB_2R_524 V_2R_524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
end
%send logg
fsTX=600;
[TT_1L_1524 RSSI_1L_1524 LAT_1L_1524 LONG_1L_1524 TX_SEQ_1L_1524 LAB_1L_1524 V_1L_1524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);

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

%% Calculate data age for comparison
%% Calculate Data age for 524 byte packets
 
[DA_524a, TT_2_524a, TT_TX_500a]=calcDA(TX_SEQ_1L_524(timestamp_524(1,1):timestamp_524(2,1)), TT_1L_524(timestamp_524(1,1):timestamp_524(2,1)), RX_SEQ_2L_524(timestamp_524(1,3):timestamp_524(2,3)), TT_2L_524(timestamp_524(1,3):timestamp_524(2,3)),1);
[DA_524b, TT_2_524b, TT_TX_500b]=calcDA(TX_SEQ_1L_524(timestamp_524(3,1):timestamp_524(4,1)), TT_1L_524(timestamp_524(3,1):timestamp_524(4,1)), RX_SEQ_2L_524(timestamp_524(3,3):timestamp_524(4,3)), TT_2L_524(timestamp_524(3,3):timestamp_524(4,3)),1);
DA_524 = [DA_524a DA_524b];
tmptime=TT_TX_500a-TT_TX_500a(1);
TT_TX_500=[TT_TX_500a-TT_TX_500a(1) TT_TX_500b-TT_TX_500b(1)+tmptime(end)];

%% Calculate Data age for 1500 byte packets
[DA_1524a, TT_2_1524a, TT_TX_1500a]=calcDA(TX_SEQ_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)), TT_1L_1524(timestamp_1524(1,1):timestamp_1524(2,1)), RX_SEQ_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)), TT_2L_1524(timestamp_1524(1,3):timestamp_1524(2,3)),1);
[DA_1524b, TT_2_1524b, TT_TX_1500b]=calcDA(TX_SEQ_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1)), TT_1L_1524(timestamp_1524(3,1):timestamp_1524(4,1)), RX_SEQ_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3)), TT_2L_1524(timestamp_1524(3,3):timestamp_1524(4,3)),1);
DA_1524 = [DA_1524a DA_1524b];
tmptime=TT_TX_1500a-TT_TX_1500a(1);
TT_TX_1500=[TT_TX_1500a-TT_TX_1500a(1) TT_TX_1500b-TT_TX_1500b(1)+tmptime(end)];
% Classify direction
%Insted of running the above, just read the parameters from .mat file
% load('degermannparametrar.mat');
t1=TT_1L_524(timestamp_524(1,1):timestamp_524(2,1));
t1=t1-t1(1);
t2=TT_1L_524(timestamp_524(3,1):timestamp_524(4,1));
t2=t2-t2(1)+t1(end);
plottime=[t1 t2];

idxs=[(timestamp_524(1,1):timestamp_524(2,1)) (timestamp_524(3,1):timestamp_524(4,1))];
lat=(LAT_1L_524(idxs)*0.0000001)'; % Multiplication due to formating in the loggfiles.
long=(LONG_1L_524(idxs)*0.0000001)'; % Multiplication due to formating in the loggfiles.
[E,N] = deg2utm(lat, long); 


% Det Degermanska trolleriet... och det är lätt!!!
E = E-mean(E);
N = N-mean(N);
V = ((V_1L_524(idxs))/3.6)'; %/3.6 to get in [m/s]
timevector=TT_1L_524(idxs);

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

for i=2:length(TT_TX_500)
    
    T=TT_TX_500(i)-TT_TX_500(i-1);
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
for i=1:length(TT_TX_500)-1
    
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
hold off;
axis equal

%plot to compare dataage with turning
h=figure(2);
hold on
title(['Test ',t_no, ' AP:',AP,' ', TXVehL, ' to ', RXVeh2L,', packet size: 500 byte.']);
plot(plottime,turnlogg, '.');
plot(TT_TX_500,DA_524,'k')
ylabel('Data Age [s]');
xlabel('Elapsed time [s]');
txstr='Blue dots: 0.9=right turn, 1=left turn, 0=straight';
text(350,max(DA_524)-0.3,txstr,'HorizontalAlignment','right')
hold off

cd('output')
savefig(['Test', num2str(t_no), ' AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, ' curve 500 byte']);
cd('..')
% close all

%plot to compare dataage with turning
h=figure(3);
hold on
title(['Test ',t_no, ' AP:',AP,' ', TXVehL, ' to ', RXVeh2L,', packet size: 1500 byte.']);
plot(plottime,turnlogg, '.');
plot(TT_TX_1500,DA_1524,'k')
ylabel('Data Age [s]');
xlabel('Elapsed time [s]');
txstr='Blue dots: 0.9=right turn, 1=left turn, 0=straight';
text(350,max(DA_1524)-0.3,txstr,'HorizontalAlignment','right')
hold off

cd('output')
savefig(['Test', num2str(t_no), ' AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, ' curve 1500 byte']);
cd('..')
% close all





