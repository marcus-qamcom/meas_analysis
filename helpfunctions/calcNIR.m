function [NIR] = calcNIR(TX, RX1, RX2, RX3)

NIR=zeros(length(TX),1);
k=1;
switch nargin
    case 4
        for i=TX
            tmpNIR=3;
            if ismember(i,RX1)
                tmpNIR=tmpNIR-1;
            end
            if ismember(i,RX2)
                tmpNIR=tmpNIR-1;
            end
            if ismember(i,RX3)
                tmpNIR=tmpNIR-1;
            end %if
            NIR(k)=tmpNIR;
            k=k+1;
        end %for
        
    case 3
    case 2
    otherwise
        display 'Not correct number of arguments!'


end

