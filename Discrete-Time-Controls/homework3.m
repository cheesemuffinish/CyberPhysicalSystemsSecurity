%%Question 1

%% a.) 
A = [-2 19 20;
      1  0  0;
      0  1  0]
B = [1;
     0;
     0]
 
C = [0 1 3]

D = [0]

%% b.)
ss_N = [1 3]
ss_D = [1 2 -19 -20]
[A_out,B_out, C_out, D_out] = tf2ss(ss_N, ss_D)
% these matrices procudes the same results as section a.)

%% c.)
[A_tf,B_tf] = ss2tf(A_out,B_out, C_out, D_out)
% this command produces the correct numerator and denominator values. 

%% Question 2

%% a.)
result_a = eig([-8 -3; 1 -9])
% yes, there is a dominate pole pair

% settling time 
Tset = 4/8.5 %= 0.4706.

% overshoot
a = 8.5
b = 1.6583
Zeta = sqrt(1/(b^2/a^2 + 1)) %0.9815 = 0% overshoot

%% b.)
result_b = eig([-1 0; 0 -9])
% yes, there is a dominate pole -1

% settling time 4 seconds

% overshoot, there is no overshoot

%% c.)
result_c = eig([1 0 4; -3 -19 -12; -3 0 9])

% there are no dominate poles

%% Question 3
a_dom = 4/2 %equals 2

b_dom =  a_dom*(sqrt(1 - (0.6)^2)/0.6) %equals 2.6667

%poles = -2 +- 2.6667j

non_dom = -8 % Real {non-dom} >= -8

%gms = 88.8903/ s^3 + 12s^2 - 43.1113s + 88.8903 % from(s + 2- 2.6667i)(s + 2 +2.6667i)(s+8)

%decomposition
[Am, Bm, Cm, Dm] = tf2ss ([88.8903], [1 12 43 88.8903])
%% Question 4
F = -[1 0 0]*(Am - A) %2.0000   -1.8887  108.8903


%% Question 5
clear A B C D;
A = [-2 19 20;
      1  0  0;
      0  1  0]
B = [1;
     0;
     0]
 
C = [0 0 3]

D = [0]
