%%%%%%%%%%%%% Power fading model %%%%%%%%%%%%% 
function avg_absError = power_fading_model2(Ci, Cj, waveLength, targetLocation, noise, y, linkNum, Ct, J, At, ht)
    % Ct = target
    % J = ???
    % At = unknown
    % ht = distance from the highest point of the target to the wireless link
    %%%% collect all I
    % Ci = transmitter
	% Cj = receiver
	% Ct = targetd
    dij = zeros( size(Ci,1), size(Cj,1) );
    dit = zeros( size(Ci, 1) );
    djt = zeros( size(Cj, 1) ); 
    L   = zeros( size(Ci,1), size(Cj,1) );
    D   = zeros( size(Ci,1), size(Cj,1) );
    v   = zeros( size(Ci,1), size(Cj,1) );
    
    for i = 1:size(Ci,1)
        for j = 1:size(Cj,1)
            dij(i, j) = sqrt( (Ci(i,:)-Cj(j,:)) * (Ci(i,:)-Cj(j,:))' );
            % propagation fading
            % waveLength
            L(i, j) = 10 * log( waveLength^2 / (16 * pi^2 * dij(i, j)^2)  );
        end
    end%%%% collect all I

    for ii = 1:size(Ci,1)
        dit(ii) = sqrt( (Ci(ii,1)-Ct(1))^2 + (Ci(ii,2)-Ct(2))^2 );  % 1xi
    end
    for jj = 1:size(Cj,1)
        djt(jj) = sqrt( (Cj(jj,1)-Ct(1))^2 + (Cj(jj,2)-Ct(2))^2 );  % 1xj
    end

    for c = 1: size(Ci,1)
       for d = 1:size(Cj, 1)
          v(c,d) = ht * sqrt( 2*(dit(c)+djt(d)) ./ (waveLength*dit(c).*djt(d)) );
       end
    end

    for a = 1: size(Ci,1)
       for b = 1:size(Cj, 1)
            syms z
            D(a,b) = 20 * log( sqrt(2)/2 * abs(int(exp(-J*waveLength*z^2/2), z, v(a, b), Inf)) );
       end
    end
    

    R = 0;
    for iii = 1: size(Ci,1)
        for jjj = 1:size(Cj, 1)
            switch targetLocation(iii, jjj)
                case 'LoS'
                     R = R + L(iii, jjj) + D(iii, jjj) + At + noise ;
                case 'NLoS'
                    R = R + L(iii, jjj) + D(iii, jjj) + noise;
                case 'outFFZ'
                    R = R + L(iii, jjj) + noise;
                otherwise
                    error('error in PFM');
            end
        end
    end
    
    avg_absError = abs(y - R)/linkNum;
    
end
