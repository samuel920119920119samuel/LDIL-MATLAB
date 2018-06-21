%%%%%%%%%%%%% Power fading model %%%%%%%%%%%%% 
function R = power_fading_model(Ci, Cj, waveLength, targetLocation, noise)
    % Ct = target
    % J = ???
    % At = unknown
    % ht = distance from the highest point of the target to the wireless link
    %%%% collect all I
    % Ci = transmitter
	% Cj = receiver
	% Ct = target
    dij = zeros( size(Ci,1), size(Cj,1) );
    dit = zeros( size(Ci, 1) );
    djt = zeros( size(Cj, 1) );
    L   = zeros( size(Ci,1), size(Cj,1) );
    
    for i = 1:size(Ci,1)
        for j = 1:size(Cj,1)
            dij(i, j) = sqrt( (Ci(i,:)-Cj(j,:)) * (Ci(i,:)-Cj(j,:))' );
            % propagation fading
            % waveLength
            L(i, j) = 10 * log( waveLength^2 / (16 * pi^2 * dij(i, j)^2)  );
        end
    end%%%% collect all I

    function R = getR(Ct, J, At, ht)
        for ii = 1:size(Ci,1)
            dit(ii) = sqrt( (Ci(ii,:)-Ct) * (Ci(ii,:)-Ct)' );  % 1xi
        end
        for jj = 1:size(Cj,1)
            djt(jj) = sqrt( (Cj(jj,:)-Ct) * (Cj(jj,:)-Ct)' );  % 1xj
        end
        
        function D = getD(i, j)
            % diffraction fading
            % ht = distance from the highest point of the target to the wireless link
            % J = ???
            % noise
            % At = unknown
            v = ht * sqrt( 2*(dit(i)+djt(j)) / (pi*dit(i)*djt(j)) );
            D = 20 * log( sqrt(2)/2 * abs(int(exp(-J*pi*z^2/2), z, v, Inf)) );
        end
        
        R = 0;
        for iii = 1: size(Ci,1)
            for jjj = 1:size(Cj, 1)
                switch targetLocation(iii, jjj)
                    case 'LoS'
                        R = R + L(iii, jjj) + getD(iii, jjj) + At + noise; 
                    case 'NLoS'
                        R = R + L(iii, jjj) + getD(iii, jjj) + noise;
                    case 'outFFZ'
                        R = R + L(iii, jjj) + noise;
                    otherwise
                        error('error in PFM')
                end
            end
        end
        
    end
    R = @getR;
end