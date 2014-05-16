function [PSR] = calcPSR(TX_SEQ, RX_SEQ1, RX_SEQ2)
PSR=0;
packetRec=zeros(length(TX_SEQ));
for i=TX_SEQ
    if ismember(i,RX_SEQ1) || ismember(i,RX_SEQ2)
        PSR = PSR+1;
        packetRec(i)=1;
    end%if
    else
        packetRec(i)=0;
end
        
end%for
PSR=PSR/length(TX_SEQ);
end%function