function [threshold,CI] = getThreshold(result, pCorrect, unscaled)
% function [threshold,CI] = getThreshold(result, pCorrect,unscaled)
% this function finds a threshold value for a given fit for different
% percent correct cutoffs
%
% result is a result struct from psignifit
%
% pCorrect is the percent correct at the threshold you want to calculate
%
% threshold returns the stimulus level at which pCorrect is reached
% CI will return a nx2 array of n credible intervals for this threshold
% value.
%
% unscaled is whether the percent correct you provide are for the unscaled
% sigmoid or for the one scaled by lambda and gamma. By default this
% function returns the one for the scaled sigmoid -> unscaled = false
%
% The CIs you may obtain from this are calculated based on the confidence
% intervals only, e.g. with the shalowest and the steepest psychometric
% function and may thus broaden if you move away from the standard
% threshold of unscaled sigmoid = .5 /= options.threshPC
%
% For the sigmoids in logspace this also returns values in the linear
% stimulus level domain.
%
%
% For a more accurate inference use the changed level of percent correct
% directly to define the threshold in the inference by setting
% options.threshPC and adjusting the priors.


if ~exist('unscaled','var') || isempty(unscaled)
    unscaled = false;
end

if isstruct(result)
    theta0 = result.Fit;
    CIs    = result.conf_Intervals;
else
    error('Result needs to be a result struct generated by psignifit');
end

if unscaled % set asymptotes to 0 for everything.
    theta0(3)  = 0;
    theta0(4)  = 0;
    CIs(3:4,:) = 0;
end

assert(pCorrect>theta0(4) && pCorrect<(1-theta0(3)), 'The threshold percent correct is not reached by the function!')

%% calculate point estimate threshold -> transform only result.Fit

pCorrectUnscaled = (pCorrect-theta0(4))./(1-theta0(3)-theta0(4));
alpha = result.options.widthalpha;
if isfield(result.options,'threshPC')
    PC    = result.options.threshPC;
else
    PC = 0.5;
end
if strcmp(result.options.sigmoidName(1:3),'neg')
    pCorrectUnscaled = 1-pCorrectUnscaled;
    PC = 1-PC;
end

switch result.options.sigmoidName
    case {'norm','gauss','neg_norm','neg_gauss'}   % cumulative normal distribution
        C         = my_norminv(1-alpha,0,1) - my_norminv(alpha,0,1);
        threshold = my_norminv(pCorrectUnscaled, theta0(1)-my_norminv(PC,0,theta0(2)./C), theta0(2) ./ C);
    case {'logistic','neg_logistic'}         % logistic function
        threshold = theta0(1)-theta0(2)*(log(1/pCorrectUnscaled-1)-log(1/PC-1))/2/log(1/alpha-1);
    case {'gumbel','neg_gumbel'}           % gumbel
        % note that gumbel and reversed gumbel definitions are sometimes swapped
        % and sometimes called extreme value distributions
        C      = log(-log(alpha)) - log(-log(1-alpha));
        threshold = theta0(1) + (log(-log(1-pCorrectUnscaled))-log(-log(1-PC)))*theta0(2)/C;
    case {'rgumbel','neg_rgumbel'}           % reversed gumbel
        % note that gumbel and reversed gumbel definitions are sometimes swapped
        % and sometimes called extreme value distributions
        C      = log(-log(1-alpha)) - log(-log(alpha));
        threshold = theta0(1) + (log(-log(pCorrectUnscaled))-log(-log(PC)))*theta0(2)/C;
    case {'logn','neg_logn'}             % cumulative lognormal distribution
        C      = my_norminv(1-alpha,0,1) - my_norminv(alpha,0,1);
        threshold = exp(my_norminv(pCorrectUnscaled, theta0(1)-my_norminv(PC,0,theta0(2)./C), theta0(2) ./ C));
    case {'Weibull','weibull','neg_Weibull','neg_weibull'} % Weibull
        C      = log(-log(alpha)) - log(-log(1-alpha));
        threshold = exp(theta0(1)+theta0(2)/C*(log(-log(1-pCorrectUnscaled))-log(-log(1-PC))));
    case {'tdist','student','heavytail','neg_tdist','neg_student','neg_heavytail'}
        % student T distribution with 1 df
        %-> heavy tail distribution
        C      = (my_t1icdf(1-alpha) - my_t1icdf(alpha));
        threshold = (my_t1icdf(pCorrectUnscaled)-my_t1icdf(PC))*theta0(2) ./ C + theta0(1);
    otherwise
        error('unknown sigmoid function');
end

%% calculate CI -> worst case in parameter confidence intervals
if nargout>1 % calculate CIs only if required
    warning('psignifit:getThresholdCIs','The CIs computed by this method are only upper bounds. For more accurate inference change threshPC in the options.');
    for iConfP = 1:numel(result.options.confP)
        
        if strcmp(result.options.sigmoidName(1:3),'neg')
            if pCorrectUnscaled < PC
                thetaMax = [CIs(1,2,iConfP),CIs(2,1,iConfP),CIs(3,1,iConfP),CIs(4,2,iConfP),0];
                thetaMin = [CIs(1,1,iConfP),CIs(2,2,iConfP),CIs(3,2,iConfP),CIs(4,1,iConfP),0];
            else
                thetaMax = [CIs(1,2,iConfP),CIs(2,2,iConfP),CIs(3,1,iConfP),CIs(4,2,iConfP),0];
                thetaMin = [CIs(1,1,iConfP),CIs(2,1,iConfP),CIs(3,2,iConfP),CIs(4,1,iConfP),0];
            end
            pCorrMin = 1-(pCorrect-thetaMin(4))./(1-thetaMin(3)-thetaMin(4));
            pCorrMax = 1-(pCorrect-thetaMax(4))./(1-thetaMax(3)-thetaMax(4));
        else
            if pCorrectUnscaled > PC
                thetaMin = [CIs(1,1,iConfP),CIs(2,1,iConfP),CIs(3,1,iConfP),CIs(4,2,iConfP),0];
                thetaMax = [CIs(1,2,iConfP),CIs(2,2,iConfP),CIs(3,2,iConfP),CIs(4,1,iConfP),0];
            else
                thetaMin = [CIs(1,1,iConfP),CIs(2,2,iConfP),CIs(3,1,iConfP),CIs(4,2,iConfP),0];
                thetaMax = [CIs(1,2,iConfP),CIs(2,1,iConfP),CIs(3,2,iConfP),CIs(4,1,iConfP),0];
            end
            pCorrMin = (pCorrect-thetaMin(4))./(1-thetaMin(3)-thetaMin(4));
            pCorrMax = (pCorrect-thetaMax(4))./(1-thetaMax(3)-thetaMax(4));
        end
        switch result.options.sigmoidName
            case {'norm','gauss','neg_norm','neg_gauss'}   % cumulative normal distribution
                C         = my_norminv(1-alpha,0,1) - my_norminv(alpha,0,1);
                CI(iConfP,1)     = my_norminv(pCorrMin, thetaMin(1)-my_norminv(PC,0,thetaMin(2)./C), thetaMin(2) ./ C);
                CI(iConfP,2)     = my_norminv(pCorrMax, thetaMax(1)-my_norminv(PC,0,thetaMax(2)./C), thetaMax(2) ./ C);
            case {'logistic','neg_logistic'}         % logistic function
                CI(iConfP,1)     = thetaMin(1)-thetaMin(2)*(log(1/pCorrMin-1)-log(1/PC-1))/2/log(1/alpha-1);
                CI(iConfP,2)     = thetaMax(1)-thetaMax(2)*(log(1/pCorrMax-1)-log(1/PC-1))/2/log(1/alpha-1);
            case {'gumbel','neg_gumbel'}           % gumbel
                % note that gumbel and reversed gumbel definitions are sometimesswapped
                % and sometimes called extreme value distributions
                C      = log(-log(alpha)) - log(-log(1-alpha));
                CI(iConfP,1) = thetaMin(1) + (log(-log(1-pCorrMin))-log(-log(1-PC)))*thetaMin(2)/C;
                CI(iConfP,2) = thetaMax(1) + (log(-log(1-pCorrMax))-log(-log(1-PC)))*thetaMax(2)/C;
            case {'rgumbel','neg_rgumbel'}           % reversed gumbel
                % note that gumbel and reversed gumbel definitions are sometimesswapped
                % and sometimes called extreme value distributions
                C      = log(-log(1-alpha)) - log(-log(alpha));
                CI(iConfP,1) = thetaMin(1) + (log(-log(pCorrMin))-log(-log(PC)))*thetaMin(2)/C;
                CI(iConfP,2) = thetaMax(1) + (log(-log(pCorrMax))-log(-log(PC)))*thetaMax(2)/C;
            case {'logn','neg_logn'}             % cumulative lognormal distribution
                C      = my_norminv(1-alpha,0,1) - my_norminv(alpha,0,1);
                CI(iConfP,1) = exp(my_norminv(pCorrMin, thetaMin(1)-my_norminv(PC,0,thetaMin(2)./C), thetaMin(2) ./ C));
                CI(iConfP,2) = exp(my_norminv(pCorrMax, thetaMax(1)-my_norminv(PC,0,thetaMax(2)./C), thetaMax(2) ./ C));
            case {'Weibull','weibull','neg_Weibull','neg_weibull'} % Weibull
                C      = log(-log(alpha)) - log(-log(1-alpha));
                CI(iConfP,1) = exp(thetaMin(1)+thetaMin(2)/C*(log(-log(1-pCorrMin))-log(-log(1-PC))));
                CI(iConfP,2) = exp(thetaMax(1)+thetaMax(2)/C*(log(-log(1-pCorrMax))-log(-log(1-PC))));
            case {'tdist','student','heavytail','neg_tdist','neg_student','neg_heavytail'}
                % student T distribution with 1 df
                %-> heavy tail distribution
                C      = (my_t1icdf(1-alpha) - my_t1icdf(alpha));
                CI(iConfP,1) = (my_t1icdf(pCorrMin)-my_t1icdf(PC))*thetaMin(2) ./ C + thetaMin(1);
                CI(iConfP,2) = (my_t1icdf(pCorrMax)-my_t1icdf(PC))*thetaMax(2) ./ C + thetaMax(1);
            otherwise
                error('unknown sigmoid function');
        end
        if pCorrMin>1 || pCorrMin<0
            CI(iConfP,1) = NaN;
        end
        if pCorrMax>1 || pCorrMax<0
            CI(iConfP,2) = NaN;
        end
    end
end

