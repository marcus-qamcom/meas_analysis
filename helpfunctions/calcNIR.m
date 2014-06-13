function [NIR] = calcNIR(TX, RX1, RX2, RX3, RX4, RX5, RX6)

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
    case 7
        for i=TX
            tmpNIR=3;
            if ismember(i,RX1) || ismember(i,RX4)
                tmpNIR=tmpNIR-1;
            end
            if ismember(i,RX2) || ismember(i,RX5)
                tmpNIR=tmpNIR-1;
            end
            if ismember(i,RX3) || ismember(i,RX6)
                tmpNIR=tmpNIR-1;
            end %if
            NIR(k)=tmpNIR;
            k=k+1;
        end %for
    otherwise
        display 'Not correct number of arguments!'


end

