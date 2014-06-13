function [DA]=calcDA(TX_SEQ_1, TT_1, RX_SEQ_2, TT_2)
    spacing=0;
    for i=1:length(TX_SEQ_1)
%         if i>199
%             keyboard
%         end
        [hit, loc]=ismember(TX_SEQ_1(i),RX_SEQ_2);
        if ~hit
            spacing=spacing+1;
        end
        if hit
            %Fill out the empty gaps
            %TODO: Se över vad som händer när det är fler än 2 "luckor" i
            %datat. verkar bli något fel vid i = ca 200
            if spacing>0
                tmp=interpolate(TT_2(loc),TT_2(loc+1),spacing);
                TT_2=[TT_2(1:loc) tmp' TT_2(loc+spacing:end)];
                RX_SEQ_2 = [RX_SEQ_2(1:loc) zeros(spacing,1)' RX_SEQ_2(loc+spacing:end)];
                spacing=0;
            end
            if i>156
                keyboard
            end
            receivetime = TT_2(i)
            rxseq=RX_SEQ_2(i)
            sendtime=TT_1(i)
            txseq=TX_SEQ_1(i)
            
            DA(i)=TT_2(i)-TT_1(i);       
        end %if
    end %for
end %function