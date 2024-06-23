// DECLARE VARIABLES
var
Y           $\hat{Y}$                 (long_name='Output')
C           $\hat{C}$                 (long_name='Consumption')
L           $\hat{L}$                 (long_name='Hours Worked')
K           $\hat{K}$                 (long_name='Capital')
// TECHNOLOGY
A           $\hat{A}$                 (long_name='TFP')
;
// EXOGENOUS SHOCKS
varexo
e       $\varepsilon$     (long_name='TFP Shock')
;

// PARAMETERS
parameters
betta        $\beta$            (long_name='Discount factor')
alphha       $\alpha$           (long_name='Capital share')
chii         $\chi$             (long_name='Labor aversement rate')
sigma        $\sigma$           (long_name='Risk aversion')
rho          $\rho$             (long_name='TFP persistence')
;

// PARAMETERISE
betta = 0.99;
alphha = 0.4;
chii = 2;
sigma = 0.01;
rho = 0.95;


// DECLARE MODEL
model;

1/C = betta * (alphha * (1/C(+1)) * (Y(+1)/K));
Y = A * K(-1)^alphha * L^(1-alphha);
Y = C + K;
L = ((1-alphha) * Y) / (C * chii);
log(A) = rho * log(A(-1)) + e;

end;


//STEADY STATE

steady_state_model;

L = (1-alphha) / (chii * (1 - alphha * betta));
A = 1;
Y = (A*L^(1-alphha))*(1 / (alphha * betta * (A*L^(1-alphha)))) ^ (alphha / (alphha-1));
C = (1 - alphha * betta) * Y;
K = Y - C;

end; 


// SHOCKS

shocks;
var e; stderr 0.01;
end;

// SIMULATION

stoch_simul(order=1,periods=200);

% Extract simulated data from Dynare output structure (assuming simulation has been performed)
Y_simulated = oo_.endo_simul(strmatch('Y', M_.endo_names, 'exact'), :); % Extract simulated values of Y
C_simulated = oo_.endo_simul(strmatch('C', M_.endo_names, 'exact'), :); % Extract simulated values of C
L_simulated = oo_.endo_simul(strmatch('L', M_.endo_names, 'exact'), :); % Extract simulated values of L

% Calculate standard deviation
std_Y = std(Y_simulated); % Standard deviation of Y
std_C = std(C_simulated); % Standard deviation of C
std_L = std(L_simulated); % Standard deviation of L

% Display or use the results
disp(['Standard deviation of output (Y): ', num2str(std_Y)]);
disp(['Standard deviation of consumption (C): ', num2str(std_C)]);
disp(['Standard deviation of labor (L): ', num2str(std_L)]);
