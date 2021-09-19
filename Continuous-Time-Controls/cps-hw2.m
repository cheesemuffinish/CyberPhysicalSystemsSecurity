% create a transfer function
G_s = tf( [1 3 7] , [1 10 13 16] )
% zpk( that tf ) separates the numerator and denominator into
roots
G_roots_s = zpk( G_s )