function [vPER, PER] = calcPER_div(RX_SEQ1, RX_SEQ2, TX_SEQ)
PER=0;
vPER=zeros(length(TX_SEQ));
for i=TX_SEQ
    if ~ismember(i,RX_SEQ1) || ~ismember(i,RX_SEQ2)
        PER = PER+1;
        vPER(i)=1;
    else 
        vPER(i)=0;
    end     
end%for
PER=PER/length(TX_SEQ);
end%function