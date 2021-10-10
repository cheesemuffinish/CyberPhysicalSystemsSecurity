flightData = readtable('output.csv');
cleanData = struct([]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Normalizing all of the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% timestamp zeroing
cleanData(1).timestamp_s = flightData.timestamp - min(flightData.timestamp);

%% altitude time boot in ms to s
cleanData(1).ATTITUDE_time_boot_s = data_norm(flightData.ATTITUDE_time_boot_ms,1e-3,false);

%% attitude roll in euler angles (radians)
cleanData(1).ATTITUDE_roll_rads = data_norm(flightData.ATTITUDE_roll,1,false);

%% attitude pitch in euler angles (radians)
cleanData(1).ATTITUDE_pitch_rads = data_norm(flightData.ATTITUDE_pitch,1,false);

%% attitude yaw in euler angles (radians)
cleanData(1).ATTITUDE_yaw_rads = data_norm(flightData.ATTITUDE_yaw,1,false);

%% attitude roll speed in radians/s
cleanData(1).ATTITUDE_rollspeed_rads = data_norm(flightData.ATTITUDE_rollspeed,1,false);

%% attitude pitch speed in radians/s
cleanData(1).ATTITUDE_pitchspeed_rads = data_norm(flightData.ATTITUDE_pitchspeed,1,false);

%% attitude yaw speed in radians/s
cleanData(1).ATTITUDE_yawspeed_rads = data_norm(flightData.ATTITUDE_yawspeed,1,false);

%% SERVO_OUTPUT_RAW_time_usec in s
cleanData(1).SERVO_OUTPUT_RAW_time_s = data_norm(flightData.SERVO_OUTPUT_RAW_time_usec,1e-6,false);

%% SERVO_OUTPUT_RAW_port 
cleanData(1).SERVO_OUTPUT_RAW_port = data_norm(flightData.SERVO_OUTPUT_RAW_port,1,false);

%% SERVO_OUTPUT_RAW_servoi_raw normalized
i = 1;
while i <= 16
    cleanData(1).(sprintf('SERVO_OUTPUT_RAW_servo%i_raw',i)) = data_norm(flightData.(sprintf('SERVO_OUTPUT_RAW_servo%i_raw',i)),1,true);
    i = i+1;
end 

%% NAV_CONTROLLER_OUTPUT_nav_roll normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_nav_roll = data_norm(flightData.NAV_CONTROLLER_OUTPUT_nav_roll,1,false);

%% NAV_CONTROLLER_OUTPUT_nav_pitch normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_nav_pitch = data_norm(flightData.NAV_CONTROLLER_OUTPUT_nav_pitch,1,false);

%% NAV_CONTROLLER_OUTPUT_nav_bearing normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_nav_bearing = data_norm(flightData.NAV_CONTROLLER_OUTPUT_nav_bearing,1,false);

%% NAV_CONTROLLER_OUTPUT_target_bearing normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_target_bearing = data_norm(flightData.NAV_CONTROLLER_OUTPUT_target_bearing,1,false);

%% NAV_CONTROLLER_OUTPUT_wp_dist normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_wp_dist = data_norm(flightData.NAV_CONTROLLER_OUTPUT_wp_dist,1,false);

%% NAV_CONTROLLER_OUTPUT_alt_error normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_alt_error = data_norm(flightData.NAV_CONTROLLER_OUTPUT_alt_error,1,false);

%% NAV_CONTROLLER_OUTPUT_aspd_error normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_aspd_error = data_norm(flightData.NAV_CONTROLLER_OUTPUT_aspd_error,1,false);

%% NAV_CONTROLLER_OUTPUT_xtrack_error normalized
cleanData(1).NAV_CONTROLLER_OUTPUT_xtrack_error = data_norm(flightData.NAV_CONTROLLER_OUTPUT_xtrack_error,1,false);


%%%%% plot the data %%%%%
plot(diff(cleanData(1).timestamp_s))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% function to normalize the given data with a normalization factor
function normOut =  data_norm(data, normFac, doFullNorm)
    
    %% if the max and min are the same, avoid machine percision
    if min(data) == max(data) && doFullNorm
        normOut = zeros(size(data));
        return 
    end
    
    %% if all of the data is NaN
    if all(isnan(data))
        normOut = zeros(size(data));
        return
    end
    
    %% fill NANs with values in the data
    data = inpaint_nans(data);

    %% convert values to desired format
    normOut = data * normFac;
    
    %% if we desire to normalize between 0 and 1
    if doFullNorm
        normOut = (normOut - min(normOut))/(max(normOut) -  min(normOut));
    end
    
end