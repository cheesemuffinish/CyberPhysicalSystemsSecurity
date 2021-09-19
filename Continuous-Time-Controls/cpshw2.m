% create a transfer function
G_s = tf( [2 12] , [1 9 23] )
% zpk( that tf ) separates the numerator and denominator into roots
G_roots_s = zpk( G_s )

b = 0.2*sqrt(1 - (1.0)^2)/1.0
