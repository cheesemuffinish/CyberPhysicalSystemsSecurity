%% Question 1 %%%%%%%%%%%%%%%%%%%%

%varibles
N = size(C_INPUTS,1);
Beta = 0.1;

%% RLSM procedure 
P = 0.5 * eye(2);
C = [0;0];
savedC1 = [];
savedC2 = [];

for i = 1:N
    Kalman = ( P*C_INPUTS(i,:)' )/( 1 + C_INPUTS(i,:)*P*C_INPUTS(i,:)');
    C = C + Kalman*( C_OUTPUT(i) - C_INPUTS(i,:)*C );
    P = ( eye(2) - Kalman*C_INPUTS(i,:) )*P/Beta; 

        % save values for plotting later 
        savedC1 = [savedC1 C(1)];
        savedC2 = [savedC2 C(2)];

end

%%coefficient of determiniation
C = [savedC1', savedC2'];
error = C_OUTPUT' - dot(C_INPUTS',C');
mean_E = mean(error);
var_E = 0;
for j = 1:N
    var_E  = var_E + (error(j) - mean_E)^2;
end

var_E = var_E/N
var_Y = var(C_OUTPUT);
eta = 1 - var_E / var_Y;

%%plots
clf
plot(k, C);
title(sprintf('Beta = %0.1f, eta = %0.3f', Beta, eta));
legend()
pause()

%% Question 2 %%%%%%%%%%%%%%%%%%%%
ac = [0.9132 -0.1434; 0.009561 0.9993];
bc = [0.009561;0.00004853];
cc = C(end,:);
dc = [0];
tstep = 0.01;

sys = ss(ac,bc,cc,dc,tstep);


%% Question 3 %%%%%%%%%%%%%%%%%%%%

%% Transform into discrete space time 

[A_tf,B_tf] = ss2tf(ac,bc,cc,dc);
cts_tf = tf(A_tf,B_tf,tstep);
step(cts_tf)
legend('Discrete time statevarible system')
pause()

%% Question 4 %%%%%%%%%%%%%%%%%%%%
zeta = 1;
p =  0; %obtained from the zeta overshoot table
settling_time = 5; 

a = 4 /settling_time

b = a * (sqrt(1-zeta^2)/zeta)

%poles =  -0.8, 5

%denominator of the model
%model_D = x^2 + 5.8x + 4;

%numerator of the model
%model_N = 5;

model = tf([0 0 5],[1 5.8 4]);
G_z =  c2d(model,tstep, 'zoh')
step(G_z)

%% Question 5 %%%%%%%%%%%%%%%%%%%%

numerator_plant = A_tf
denominator_model = [1 5.8 4]
denominator_plant = B_tf

H_s = tf(denominator_model - denominator_plant, numerator_plant);
H_z =  c2d(H_s,tstep, 'zoh')

%% Question 6 %%%%%%%%%%%%%%%%%%%%
y = [C_OUTPUT(1)];
x = C_INPUTS(:,1);
for i = 2:length(k)
    y(end+1) = -1.059e4*x(i) - 1.055e4*x(i - 1) + 0.9903*y(i-1);
end

plot(y)
legend()
pause()
