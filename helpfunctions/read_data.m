function [TT RSSI LAT LONG RX_SEQ] = read_data(t1, t2, DATA, fname, flength)
% 
 

N=max(size(DATA));
tt=1;

for t=1:N
    if DATA(t).postime > t1 && DATA(t).postime < t2
    fname2=DATA(t).friendlyname;
    %'DEF84L'
        if fname2 == fname
            flength2=DATA(t).framelength;
            if flength2 == flength; % 108 124 524 600

                time=DATA(t).postime;
                TT(tt)=time-t1;
                RSSI(tt)=DATA(t).rssi;
                LAT(tt)=DATA(t).latitude;
                LONG(tt)=DATA(t).longitude;
                RX_SEQ(tt)=DATA(t).seqno;
                tt=tt+1;
            end
        end
    end
end   

if tt==1
    disp(['Not found: ' fname ' ' num2str(flength) ])
    TT(1)=0;
    RSSI(1)=-90;
    LAT(1)=DATA(1).latitude;
    LONG(1)=DATA(1).longitude;
    RX_SEQ(1)=DATA(1).seqno;
end