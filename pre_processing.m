function [CSIeff] = pre_processing(targetLocation, I, Isize, f0, f, F, O)
	%%%%%%%%%%%%% pre-processing module %%%%%%%%%%%%%
    K = 30;
	switch targetLocation
		case 'LoS'
	    	CSIeff = 1/Isize * sum( f(I)/f0 .* F(I) ); 
	    case 'NLoS'
	        CSIeff = 1/Isize * sum( f/f0 .* F(I) );
	    case 'outFFZ'
	    	CSIeff = 1/K * sum( f/f0 .* O );
        otherwise
	        CSIeff = 1/K * sum( f/f0 .* O );
	end
end