function [timeV] = createTimeVector(timeVector,timestamp1,timestamp2, timestamp3, timestamp4)
    keyboard
    tmp1=timeVector(timestamp1:timestamp2)-timeVector(1);
    tmp2=timeVector(timestamp3:timestamp4);
    tmp2=tmp2-tmp2(1);
    timeV=[tmp1 tmp2];
end

