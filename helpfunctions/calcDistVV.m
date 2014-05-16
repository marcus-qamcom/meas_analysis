function [T_new D] = calcDistVV(T1,lat1V,long1V,T2,lat2V,long2V)
% Calculate the great circle distance between two vectors.
%   
N1=length(T1);
N2=length(T2);

t2=1;
t3=1;
break_now=0;

for t1=1:N1
    if T1(t1)-T2(t2)==0 % time match
        D(t3) = calcDist(lat1V(t1),long1V(t1),lat2V(t2),long2V(t2))*1000;
        T_new(t3)=T1(t1);
        t3=t3+1;
    else
        if T1(t1)<T2(t2) % increase t1
            % do nothing..
        else %T1(t1)>T2(t2) -> increase t2
            while T1(t1)>T2(t2)
                t2=t2+1; 
                if t2>N2
                    break_now=1;
                    break
                end
            end
            if break_now ==0
                D(t3) = calcDist(lat1V(t1),long1V(t1),lat2V(t2),long2V(t2))*1000;
                T_new(t3)=T1(t1);
                t3=t3+1;
            else
                break
            end
        end
    end
end

end