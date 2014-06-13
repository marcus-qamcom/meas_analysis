function dataAgeEvaluation(t_no, APnum, dist, RXVeh2L, RXVeh2R, TXVehL, testconf)
testconftestcase
%% Load data
% t_no='2'; % test case number
%AP='8_30m';        % 1,2,4,5,8
if dist=='0'
   AP=APnum; 
else
    AP=[APnum '_' dist];
end
% RXVeh2L='PlutoL';%,'PltonR','DEF84L','DEF84R','PlutoL','PlutoR'
% RXVeh2R='PltonR';
% TXVehL='DRF18L';


%% Analysis starts here
% read data: RSSI, T LAT LONG (i.e. lat long of moving truck)     
disp('load links')

% Load data from receivers for 124 byte packets
fs=124;
% Left antennas
[TT_2L_124 RSSI_2L_124 LAT_2L_124 LONG_2L_124 RX_SEQ_2L_124]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
%[TT_2R_124 RSSI_2R_124 LAT_2R_124 LONG_2R_124 RX_SEQ_2R_124]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
%send logg
fsTX=108;
[TT_1L_124 RSSI_1L_124 LAT_1L_124 LONG_1L_124 TX_SEQ_1L_124]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);
% Frame size not the same for sender and receiver

% Load data from receivers for 524 byte packets
fs=524;
% Left antennas
[TT_2L_524 RSSI_2L_524 LAT_2L_524 LONG_2L_524 RX_SEQ_2L_524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
%[TT_2R_524 RSSI_2R_524 LAT_2R_524 LONG_2R_524 RX_SEQ_2R_524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
%send logg
fsTX=508;
[TT_1L_524 RSSI_1L_524 LAT_1L_524 LONG_1L_524 TX_SEQ_1L_524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);

% Load data from receivers for 524 byte packets
fs=600;
% Left antennas
[TT_2L_1524 RSSI_2L_1524 LAT_2L_1524 LONG_2L_1524 RX_SEQ_2L_1524]=load_comm_link(testconf,t_no,AP,RXVeh2L,TXVehL,fs);
% Right antennas
%[TT_2R_1524 RSSI_2R_1524 LAT_2R_1524 LONG_2R_1524 RX_SEQ_2R_1524]=load_comm_link(testconf,t_no,AP,RXVeh2R,TXVehL,fs);
%send logg
fsTX=600;
[TT_1L_1524 RSSI_1L_1524 LAT_1L_1524 LONG_1L_1524 TX_SEQ_1L_1524]=load_comm_link(testconf,t_no,AP,TXVehL,TXVehL,fsTX);


%% Calculate Data age
[DA_124, TT_2_124]=calcDA(TX_SEQ_1L_124, TT_1L_124, RX_SEQ_2L_124, TT_2L_124);
[DA_524, TT_2_524]=calcDA(TX_SEQ_1L_524, TT_1L_524, RX_SEQ_2L_524, TT_2L_524);
[DA_1524, TT_2_1524]=calcDA(TX_SEQ_1L_1524, TT_1L_1524, RX_SEQ_2L_1524, TT_2L_1524);

hold on
stairs(TT_2_124, DA_124,'k', 'EdgeColor', 'None');
stairs(TT_2_524, DA_524, 'EdgeColor', 'None');
stairs(TT_2_1524, DA_1524,'r', 'EdgeColor', 'None');  

maxDA=max([DA_124 DA_524 DA_1524]);
axis([-10 max(TT_1L_524)+10 0 maxDA+0.5])
xlabel('Elapsed Time [s]');
ylabel('Data Age [s]')
title({['Test',num2str(t_no),' AP', num2str(APnum), ', Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
legend('124 byte','524 byte', '1524 byte')

%Save the figure
cd('output')
savefig(['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L]);
cd('..')
close all
%% Create pie diagrams for data age
bound1=0.05;
bound2=0.15;
bound3=0.5;
bound4=1;

% Get values for 124byte packet size
bound1_124=length(DA_124(DA_124>0 & DA_124<=bound1));
bound2_124=length(DA_124(DA_124>bound1));
bound3_124=length(DA_124(DA_124>bound2 & DA_124<=bound3));
bound4_124=length(DA_124(DA_124>bound3 & DA_124<=bound4));
bound5_124=length(DA_124(DA_124>bound4));
figure(1);
pie([bound1_124 bound2_124 bound3_124 bound4_124 bound5_124])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 124 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})

legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
cd('output')
savefig(1,['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_124_byte']);
cd('..')
close all

% Get values for 524byte packet size
bound1_524=length(DA_524(DA_524>0 & DA_524<=bound1));
bound2_524=length(DA_524(DA_524>bound1));
bound3_524=length(DA_524(DA_524>bound2 & DA_524<=bound3));
bound4_524=length(DA_524(DA_524>bound3 & DA_524<=bound4));
bound5_524=length(DA_524(DA_524>bound4));
figure(2);
pie([bound1_524 bound2_524 bound3_524 bound4_524 bound5_524])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 524 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})

legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
cd('output')
savefig(2,['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_524_byte']);
cd('..')
close all
% Get values for 1524byte packet size
bound1_1524=length(DA_1524(DA_1524>0 & DA_1524<=bound1));
bound2_1524=length(DA_1524(DA_1524>bound1));
bound3_1524=length(DA_1524(DA_1524>bound2 & DA_1524<=bound3));
bound4_1524=length(DA_1524(DA_1524>bound3 & DA_1524<=bound4));
bound5_1524=length(DA_1524(DA_1524>bound4));
figure(3);
pie([bound1_1524 bound2_1524 bound3_1524 bound4_1524 bound5_1524])
title({['Test',num2str(t_no),' AP', num2str(APnum) ' packet size: 1524 byte. Inter vehicle distance: ~21m, ']; [TXVehL, ' to ', RXVeh2L]})
legend(['0-' num2str(bound1) 's'],[num2str(bound1) '-' num2str(bound2) 's'],[num2str(bound2) 's-' num2str(bound3) 's'],[num2str(bound3) 's-' num2str(bound4) 's'],[num2str(bound4) 's- ...'],'Location', 'NorthEastOutside')
%Save the figure
cd('output')
savefig(3,['Test', num2str(t_no), '_AP', num2str(AP), ' ', TXVehL, ' to ', RXVeh2L, '_pie_1524_byte']);
cd('..')
close all

end