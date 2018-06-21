%%%%%%%%%%%%% rough location estimate module %%%%%%%%%%%%%
function [I, Isize, targetLocation] = rough_location_estimate(f0, f, delta, F, O)
	K = 30;     % number of subcarriers
	% f0 = central frequency
	% fk = frequency of k-th subcarrier
	% deltaK = standard deviation of the amplitudes of baseline CSI measurements on k-th subcarrier when no target is precent
    threshold = 1/K * sum(f/f0 .* delta)

	% F[K]  % CSI measurements when a target is inside the FFZ of a link
	% O[K]  % baseline CSI measuremant
	index = 1;
    I = zeros(1, 30);
    for j = 1:K
	   %if F(j) - O(j) > threshold
       if O(j) - F(j) > threshold
	       I(index) = j;
           index = index+1;
       end
    end
    I(index:30) = [];
    Isize = size(I);
    Isize = Isize(2);
  	deltaCSIeff = 1/Isize * sum( f(I)/f0 .* (F(I)-O(I)) )
  
  	At = 3;
  	if abs(deltaCSIeff) > abs(At)
  		targetLocation = 'LoS';
        threshold = threshold + At;
  	elseif abs(At) >= abs(deltaCSIeff) && abs(deltaCSIeff) > threshold
  		targetLocation = 'NLoS';
  	elseif threshold >= abs(deltaCSIeff)
  		targetLocation = 'outFFZ';
    else
        targetLocation = 'error';
    end
    
 	index = 1;
    I = zeros(1, 30);
     for j = 1:K
 	   if O(j) - F(j) > threshold
 	       I(index) = j;
           index = index+1;
 	   end
     end
     I(index:30) = [];
    
end