function [RSSIcalc, RSSIplot]=getRSSI(TX_SEQ, RX_SEQ1, RX_SEQ2, RX_RSSI1, RX_RSSI2)
% function [RSSI]=getRSSI(TX_SEQ, RX_SEQ1, RX_SEQ2, RX_RSSI1, RX_RSSI2)
% Pick out the best RSSI from RX_RSSI1 and RX_RSSI2.
%
% Two RSSI vectors are created one that only contains the received RSSI
% values (RSSIcalc) and one that contains all the received RSSI values but has NaN
% where no RSSI value has been received (RSSIplot) that has the same length as TX_SEQ. 
index=1;
tmpRX1_RSSI=0;
tmpRX2_RSSI=0;
RSSIplot=zeros(length(TX_SEQ),1);
RSSIcalc=zeros(length(TX_SEQ),1);
for i=1:length(TX_SEQ)
    % Search to see if the TX packat has been received by the two
    % receivers.
    [TXseqAvailableInRX1, posInRX_SEQ1]=ismember(TX_SEQ(i),RX_SEQ1);
    [TXseqAvailableInRX2, posInRX_SEQ2]=ismember(TX_SEQ(i),RX_SEQ2);
    
    %If tha packet has been received by RX1, store the coresponding RSSI
    %value from RX1 temporarily.
    if TXseqAvailableInRX1
        tmpRX1_RSSI=RX_RSSI1(posInRX_SEQ1);
    end%if
    
    %Do the same check for RX2.
    if TXseqAvailableInRX2
        tmpRX2_RSSI=RX_RSSI2(posInRX_SEQ2);
    end%if
    
    %Pick the best of the two RSSI values (possibly there is only one
    %available due to that the packet might have been received by only one
    %RX.
    %If there is no received RSSI value in neither RX1 nor RX2 then set the
    %RSSI value to NaN in order to keep the vector of same length as
    %TX_SEQ, this can be good if it is of interest to plot against distance
    %wich is stored in the same way as TX_SEQ
    RSSIplot(i)=-max(abs(tmpRX1_RSSI), abs(tmpRX2_RSSI));
    if RSSIplot(i)==0
        RSSIplot(i)=NaN;
    end%if
    if (max(tmpRX1_RSSI, tmpRX2_RSSI)~=0)
        RSSIcalc(index)=-max(abs(tmpRX1_RSSI), abs(tmpRX2_RSSI));
        index=index+1;
    end
    tmpRX1_RSSI=0;
    tmpRX2_RSSI=0;
end%for
RSSIcalc=RSSIcalc(1:index-1);
end%function