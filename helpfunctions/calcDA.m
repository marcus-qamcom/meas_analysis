function [DA, TT_2]=calcDA(TX_SEQ_1, TT_1, RX_SEQ_2, TT_2)
    indexLastReceived=0;
    dataAgeIndex=1;
    missedPacket=0;
    firsthit=1;
    for i=2:length(TX_SEQ_1)
        %Make sure that only data that has been sent and received whithin
        %this testcase is evaluated.
       [hit, loc]=ismember(TX_SEQ_1(i),RX_SEQ_2);
       if firsthit==1 && hit
          RX_SEQ_2=RX_SEQ_2(loc:end);
          TT_2=TT_2(loc:end);
          [hit, loc]=ismember(TX_SEQ_1(i),RX_SEQ_2);
          firsthit=0;
       end
        if firsthit==0
            if ~hit && missedPacket==0
                indexLastReceived=i-1;
                missedPacket=1;
            end
            if hit
                if missedPacket==1
                    DA(dataAgeIndex)=TT_2(loc)-TT_1(indexLastReceived);
                    indexLastReceived=0;
                    missedPacket=0;
                    dataAgeIndex=dataAgeIndex+1;
                else
                   DA(dataAgeIndex)=TT_2(loc)-TT_1(i-1); 
                   dataAgeIndex=dataAgeIndex+1;
                end       
            end %if
        end
    end %for
    TT_2=TT_2(1:dataAgeIndex-1);
    % Logging of time is faulty and is offset by 1s for some of the nodes
    if mean(DA)>2
        DA=DA-2;
    elseif mean(DA)>1
        DA=DA-1;
    elseif mean(DA)<-1
        DA=DA+2;
    elseif mean(DA)<0
        DA=DA+1;
    end
   
end %function