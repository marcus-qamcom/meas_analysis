function timeUnix = timeHuman2timeUnix( timeHuman )
matlab_time = todatenum(cdfepoch(timeHuman));
time_reference = datenum('1970', 'yyyy');
timeUnix = 8.64e4 * (matlab_time - datenum('1970', 'yyyy')); %8.64e4 number of seconds in 24 hours
end

