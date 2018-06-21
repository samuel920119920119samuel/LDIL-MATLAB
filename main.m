% get CSI 1x30 from one link
csi_trace = read_bf_file('CSIdata/base_csi_5.dat');
rawTenSNR = zeros(30,30);
baseIndex = 1200;
indexCount = 0;
abc = 0;
for packetIndex = 1:50
    %if (csi_trace{baseIndex+packetIndex}.Nrx==1 || csi_trace{baseIndex+packetIndex}.Ntx==1)
        abc = abc+1;
        csi_entry = csi_trace{baseIndex+packetIndex};
        csi = get_scaled_csi(csi_entry);
        csiSize = size(csi);    csiSize = csiSize(1);
    
%     SNRcsi = (db(abs(squeeze(csi(NtxNum,:,:)).')))';
%     rawTenSNR(packetIndex,:) = SNRcsi(1,:);meanSNR
        for NtxNum = 1:csiSize
            indexCount = indexCount+1;
             SNRcsi = (db(abs(squeeze(csi(NtxNum,:,:)).')))';
             SNRcsi = 20* log(abs(SNRcsi)./1000);
            % BSNRcsi = (db(squeeze(csi(NtxNum,:,:).')))';
            rawTenSNR(indexCount,:) = SNRcsi(1,:);
        end
    %end
end
rawTenSNR((indexCount+1):30, :) = [];

stdSNR = std(rawTenSNR);
meanSNR = mean(rawTenSNR);
%stdSNR = 20* log(abs(stdSNR)./1000);
%meanSNR = 20* log(abs(meanSNR)./1000);

% base CSI 1x30
baseCSI = meanSNR;
% get CSI 1x30 from one link

% get CSI 1x30 from one link
csi_trace1 = read_bf_file('CSIdata/env_csi_5.dat');

rawTenSNR1 = zeros(30,30);
baseIndex1 = 120;
indexCount1 = 0;
for packetIndex1 = 1:50
    csi_entry1 = csi_trace1{baseIndex1+packetIndex1};
    csi1 = get_scaled_csi(csi_entry1);
    csiSize1 = size(csi1);    csiSize1 = csiSize1(1);
%     SNRcsi = (db(abs(squeeze(csi(NtxNum,:,:)).')))';
%     rawTenSNR(packetIndex,:) = SNRcsi(1,:);
    
    for NtxNum1 = 1:csiSize1
        indexCount1 = indexCount1+1;
         SNRcsi1 = (db(abs(squeeze(csi1(NtxNum1,:,:)).')))';
         SNRcsi1 = 20* log(abs(SNRcsi1)./1000);
        % BSNRcsi = (db(squeeze(csi(NtxNum,:,:).')))';
        rawTenSNR1(indexCount1,:) = SNRcsi1(1,:);
    end
end
rawTenSNR1((indexCount1+1):30, :) = [];
%plot(rawTenSNR1);
stdSNR1 = std(rawTenSNR1);
meanSNR1 = mean(rawTenSNR1);
%stdSNR1 = 20* log(abs(stdSNR1)./1000);
%meanSNR1 = 20* log(abs(meanSNR1)./1000);

envCSI = meanSNR1;

 figure
 plot(baseCSI, 'LineWidth',3); hold; plot(envCSI, 'LineWidth',3)
 title('Target stands at LoS', 'FontSize', 20)
 xlabel('Subcarrier Index', 'FontSize', 20)
 ylabel('CSI SNR (dB)', 'FontSize', 20)
 

% %%%%%%%%%%%%%%%%%%%%
% f0, f, delta (MHz)
f0 = 2412;
count = 1;
f = zeros(1,30);
for i=-28:2:28
      f(count) = f0 + 0.3125*i;
      count = count+1;
end
delta(1,1:30) = stdSNR;  %delta, threshold RELATION! LOOK ESSAY
 
F = envCSI;
O = baseCSI;
  
[I, Isize, targetLocation] = rough_location_estimate(f0, f, delta, F, O);


%%%%%%%%%%%%%%%%%%%%
CSIeff = pre_processing(targetLocation, I, Isize, f0, f, F, O);
%%%%%%%%%%%%%%%%%%%%
% then collect all CSIeff and targetLocation
% y = CSIeff + CSIeff D(iii, jjj)... % temp
 N = 1;
 M = 1;
 % y = 0;
 % for i = 1:N
 %     for j=1:M
 %         y = y + CSIeff(i, j);
 %     end
 % end
 linkNum = N*M;
 y = CSIeff; % temp
 targetLocation = ["LoS"];
 %%%%%%%%%%%%%%%%%%%%
 % wavelength, noise
 Ci = [0, 0];    %temp
 Cj = [1.5, 0];    %temp
 waveLength = 74;  %%%%meter 0.125m 7.4cm
 noise = 2;  %tempFitnessFcn
 At = 3;
 ht = 1;
 J = 1;
 PFM = @(x)power_fading_model2(Ci, Cj, waveLength, targetLocation, noise, y, linkNum, x, J, At, ht);
 
 %%%%%%%%%%%%%%%%%%%%
 %a = 4; b = 2.1; c = 4; % Assign parameter values
 %FitnessFcn = @(x)parameterfun(x,a,b,c);
 rng default % For reproducibility
 opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
 opts.InitialPopulationRange = [0 -1;1.5, 1];
 opts.PopulationSize = 10;
 [x, avg_absError, exitFlag,Output] = ga(PFM, 2, opts)
 % 	FitnessFcn = avg_absError;
 % 	numberOfVariables = 2; % temp
 %     options = optimoptions('ga','PlotFcn',{@gaplotbestf,@gaplotstopping});
 %     rng('default')
 %     [x, fval] = ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)
 %     fminuncOptions = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
 %     options = optimoptions(options,'HybridFcn',{@fminunc, fminuncOptions});
 % 	[Ct, J, At, ht, avg_absError] = ga(absError,numberOfVariables,[],[],[],[],[],[],[],options)

