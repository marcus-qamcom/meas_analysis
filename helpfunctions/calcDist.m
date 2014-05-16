function d = calcDist(lat1,long1,lat2,long2)
% Calculate the great circle distance between two points.
%   

R = 6373; % Radius of earth
% Multiply with 0.0000001 to put decimal in correct way.
latrad1 = deg2rad(lat1*0.0000001);
latrad2 = deg2rad(lat2*0.0000001);
longrad1 = deg2rad(long1*0.0000001);
longrad2 = deg2rad(long2*0.0000001);

dlon = longrad2 - longrad1;
dlat = latrad2 - latrad1;

a = abs((sin(dlat/2))^2+cos(latrad1)*cos(latrad2)*(sin(dlon/2))^2);
c = 2*atan2(sqrt(a),sqrt(1-a));
d = R*c;

end