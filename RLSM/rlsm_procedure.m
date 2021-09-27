%varibles
N = 200;
k = 0;
x = zeros(N, 3);
c = zeros(N, 3);

%estimation theory
for k = 1:N
    x(k,1) = 10 + sin(4 * k) + 10 * sin(14 * k);
    x(k,2) = 5 + sin(2 * k) + 0.5 * sin(8 * k);
    x(k,3) = 17 + sin(0.5 * k) + 0.1 * sin(20 * k);
    c(k,1) = 3 + 0.001 * k;
    c(k,2) = -2 - 0.001 * k;
    c(k,3) = 10 + 0.007 * k;
end


%matrix dot multiplication to find the ys
y = dot(c',x')

%% RLSM procedure 
for Beta = linspace(0.1,1,10)
    P = 0.5 * eye(3);
    C = [0;0;0];
    savedC1 = [];
    savedC2 = [];
    savedC3 = [];
    for i = 1:N
        Kalman = ( P*x(i,:)' )/( 1 + x(i,:)*P*x(i,:)' );
        C = C + Kalman*( y(i) - x(i,:)*C );
        P = ( eye(3) - Kalman*x(i,:) )*P/Beta; 

            % save values for plotting later 
            savedC1 = [savedC1 C(1)];
            savedC2 = [savedC2 C(2)];
            savedC3 = [savedC3 C(3)];

    end
    
    %%coefficient of determiniation
    C = [savedC1', savedC2', savedC3'];
    error = y - dot(x',C');
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
    plot(k, c(:,1),'.','color',colors(1,:));
    title(sprintf('Beta = %0.1f, eta = %0.3f', Beta, eta));
    hold on
    plot(k, savedC1,'color',colors(1,:));

    plot(k, c(:,2),'.','color',colors(2,:));
    plot(k, savedC2,'color',colors(2,:));

    plot(k, c(:,3),'.','color',colors(3,:));
    plot(k, savedC3,'color',colors(3,:));
    legend('Actual C1','Calculated C1','Actual C2','Calculated C2','Actual C3','Calculated C3')
    saveas(gcf,sprintf('Result_Beta = %0.1f.png',Beta))
end