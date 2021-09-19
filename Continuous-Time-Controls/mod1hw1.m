%Problem 3B
N_Y = conv([7,-14],[0,5]);

D_Y = conv([1,-1,-12], [1,14,3]);

Y = tf(N_Y,D_Y)

%Problem 3C
[N, D] = tfdata(Y, 'v')

[r,p,k] = residue(N,D)

%Problem 3D
sys = tf([0,5], [1, 14, 3]);
isstable(sys)

%Problem 4A
G = tf([0,24], [1, 3, -22, -24]);
isstable(G)

%Problem 4B
[N, D] = tfdata(G, 'v')

[r,p,k] = residue(N,D)