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

%%
%plots
clf
plot(k, C);
title(sprintf('Beta = %0.1f, eta = %0.3f', Beta, eta));
legend()

%% Question 2 %%%%%%%%%%%%%%%%%%%%

%% Transform into discrete space time 
ac = [0.9132 -0.1434; 0.009561 0.9993];
bc = [0.009561;0.00004853];
cc = C(end,:);
dc = [0];
tstep = 0.01

[A_tf,B_tf] = ss2tf(ac,bc,cc,dc)
cts_tf = tf(A_tf,B_tf);

%% Transform into a discrete-time (G_s) using ss2tf
G_z =  c2d(cts_tf,tstep, 'zoh')

%%plot
step(G_z,'-')