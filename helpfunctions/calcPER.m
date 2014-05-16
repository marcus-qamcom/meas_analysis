function [PER, vPER] = calcPER(TX_SEQ, RX_SEQ1, RX_SEQ2)
% [PER, vPER] = calcPER(TX_SEQ, RX_SEQ1, RX_SEQ2) 
% calcPER calculates the Packet Error Rate for the specified channel TX->RX
% or TX->(RX1 or RX2).
% When calculating PER for two receivers PER will increase only if the packet
% is missing in both receiving vectors.
% The PER value is in per cent [%]
% vPER is a vector describing which packet that has been missed a 1 states that
% the packet is missing.

PER=0;
vPER=zeros(length(TX_SEQ),1);
v=1;
switch nargin
    case 3
        for i=TX_SEQ
            if ~ismember(i,RX_SEQ1) || ~ismember(i,RX_SEQ2)
                PER = PER+1;
                vPER(v)=1;
            else 
                vPER(v)=0;
            end
            v=v+1;
        end%for
        PER=(PER/length(TX_SEQ))*100; %Multiply with 100 to get %
    case 2
        for i=TX_SEQ
            if ~ismember(i,RX_SEQ1)
                PER = PER+1;
                vPER(v)=1;
            else 
                vPER(v)=0;
            end
            v=v+1;
        end%for
        PER=(PER/length(TX_SEQ))*100; %Multiply with 100 to get %    
    otherwise
        disp('Wrong number of arguments to calcPer!!')
        return
end
