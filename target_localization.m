function [avg_absError] = target_localization(y, linkNum, PFM)
	% input: N, M, y(pre-processed CSI measurement of the link lij), PFM
%	absError = 0;
% 	for i = 1:N
% 		for j = 1:M
% 			absError = absError + abs(y(i,j) - PFM(i,j));
% 		end
% 	end
    % avg_absError = @(Ct, J, At, ht) (abs(y - PFM(Ct, J, At, ht))/linkNum);
    avg_absError = abs(y - PFM)/linkNum;
	%%%%%%%%%%%%% Target localization module %%%%%%%%%%%%%
	% FitnessFcn = @dejong2fcn;
	% numberOfVariables = 2;
	% options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
	% rng('default')
	% [x,fval] = ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

% % 	FitnessFcn = avg_absError;
% 	numberOfVariables = 4; % temp
%     options = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
% %     rng('default')
% %     [Ct, J, At, ht, avg_absError] = ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)
%     fminuncOptions = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
%     options = optimoptions(options,'HybridFcn',{@fminunc, fminuncOptions});
% 	[Ct, J, At, ht, avg_absError] = ga(avg_absError,numberOfVariables,[],[],[],[],[],[],[],options)

end