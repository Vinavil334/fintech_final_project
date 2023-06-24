function turnover = calcTurnover(weights)
% Calculate portfolio turnover accordint to mkt standards
%
% INPUT:
% weights = n_obs x n_assets matrix of % weights
%
% OUTPUT
% turnover = column vector of ptf turnover
%--------------------------------------------------------------------------
%%
d_weights = diff(weights);

turnover = sum(abs(d_weights'))/2;

turnover = turnover';