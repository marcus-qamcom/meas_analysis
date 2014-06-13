function [vector]=interpolate(a,b,nbr)
offset=(b-a)/(nbr+1);
vector=zeros(nbr,1);
vector(1)=a+offset;
    for i=2:nbr
        vector(i)=vector(i-1)+offset;
    end
end
