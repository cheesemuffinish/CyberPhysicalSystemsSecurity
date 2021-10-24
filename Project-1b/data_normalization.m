flightData = readtable('noid-out.csv');
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Project 1C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LSM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ROLL_ERROR = cleanData(1).NAV_CONTROLLER_OUTPUT_nav_roll - cleanData(1).ATTITUDE_roll_rads;
servo_output = cleanData.SERVO_OUTPUT_RAW_servo1_raw;

alsm = inv(ROLL_ERROR'*ROLL_ERROR)*ROLL_ERROR'*servo_output;


%% RLSM procedure 
N = length(ROLL_ERROR);
Beta = 0.3;
P = 0.5 * eye(1);
C = [0];
savedC1 = [];
starting_val = 3000;
normal_var = 622.6610;
normal_mean = 1.2400;
win = 3000;
scaleFactor = 4

for i = 1:N
    Kalman = ( P*ROLL_ERROR(i,:)' )/( 1 + ROLL_ERROR(i,:)*P*ROLL_ERROR(i,:)' );
    C = C + Kalman*( servo_output(i) - ROLL_ERROR(i,:)*C );
    P = ( eye(1) - Kalman*ROLL_ERROR(i,:) )*P/Beta; 

    % save values for plotting later 
    savedC1 = [savedC1 C(1)];

    if i >= starting_val+win
        testData = savedC1(i-win:i);
        if mean(testData) < normal_mean/scaleFactor ||mean(testData) >= normal_mean*scaleFactor
           sprintf("Anomoly detected from the mean at index %i",i )
        end
        if var(testData) < normal_var/scaleFactor ||var(testData) >= normal_var*scaleFactor
            sprintf("Anomoly detected from the variance at index %i",i)
        end
    end
end

%%coefficient of determiniation
C = [savedC1];
error = servo_output - dot(ROLL_ERROR',C');
mean_E = mean(error);
var_E = 0;
for j = 1:N
    var_E  = var_E + (error(j) - mean_E)^2;
end

var_E = var_E/N
var_Y = var(y);
eta = 1 - var_E / var_Y;

%plots
colors = get(gca,'colororder');

k = 1:N;
clf
plot(k, C,'.');
title(sprintf('Beta = %0.1f, eta = %0.3f', Beta, eta));

%% Step 8



%plot(k, c(:,2),'.','color',colors(2,:));
%plot(k, savedC2,'color',colors(2,:));
%
%plot(k, c(:,3),'.','color',colors(3,:));
%plot(k, savedC3,'color',colors(3,:));


%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Project 1C
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LSM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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