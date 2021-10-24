%% Problem 1 Transform into discrete space time 
ac = [-5 -4; 1 0];
bc = [1;0];
cc = [0 5];
dc = [0];
tstep = 0.02

[A_tf,B_tf] = ss2tf(ac,bc,cc,dc)
cts_tf = tf(A_tf,B_tf);

%% Problem 2 Transform into a discrete-time (G_s) using ss2tf
G_z =  c2d(cts_tf,tstep, 'zoh')

%% Problem 3 Transform G_z into a continuous time transfer function G_s using d2c
G_s = d2c(G_z)

%% Problem 4 Plot step responses of  ss_c, ss_d, G_z and G_s
step(G_s,'-',G_z,'--');
legend();

%% Problem 5 Use (G_mz)and assume G_z in question 2 as the plant to create (H_z)

%% G_z = numberator of the plant
numerator_plant = [0 0.0009674 0.0009356]
denominator_model = [1 -1.8129 0.8187]
denominator_plant = [1 -1.903  0.9048]

H_z = tf(denominator_model - denominator_plant, numerator_plant)


