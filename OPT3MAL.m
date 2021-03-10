%%%% This script is published in conjunction with Wang et al., 2021.
%%%% Global calibration of novel 3-hydroxy fatty acid based temperature and pH proxies
%%%% [Geochimica et Cosmochimica Acta, doi:] 
%%%% Code and README housed at: https://github.com/carbonatefan/OPT3MAL

%%%% This script:
    %%%% Reads in a modern calibration dataset and an ancient 3-OH-FA dataset.
    %%%% 
    %%%% Returns a csv file with Nearest Neighbour distances, MAAT,
    %%%% and pH predictions.
    %%%% 
    %%%% Returns plots of the predicted error (1 standard deviation) for
    %%%% temperature and pH vs. the nearest neighbour distances.
    %%%% 
    %%%% Returns plots of the predicted temperature and pH with error bars 
    %%%% (1 standard deviation) vs. sample number.

%%%% The expected file format is the following columns in order: 
    %%%% Modern Calibration Dataset: Sample_ID C10 i-C11 a-C11 C11 i-C12
    %%%% C12 i-C13 a-C13 C13 i-C14 C14 i-C15 a-C15 C15 i-C16 C16 i-C17
    %%%% a-C17 C17 i-C18 C-18 MAAT pH
    %%%% 
    %%%% Ancient Dataset: C10 i-C11 a-C11 C11 i-C12 C12 i-C13 a-C13 C13
    %%%% i-C14 C14 i-C15 a-C15 C15 i-C16 C16 i-C17 a-C17 C17 i-C18 C-18
    %%%% 
    %%%% 3-OH-FA inputs must be formatted as fractional abundances (rows summing to 1)

clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%User Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read in datasets
%User data:
UserData=csvread('OPT3MAL_Demo.csv',1,0); %If your csv does not contain a header row, remove ,1,0 leaving only the filename (in single quotes) in the parentheses
%Modern calibration dataset:
CalibrationData=csvread('3_OH_FA_CalibrationData.csv',1,1);

%Set filenames for outputs
OPT3MAL_Results='OPT3MAL_Demo_Output.csv'; % csv file containing original 3-OH-FA data plus Nearest Neighbour distance, Temp. prediction, 1 StDev (Temp), pH prediction, 1 StDev (pH)
Plot1='OPT3MALNearestNeighbourMAAT_Demo.png'; % Plot of 1 St Dev for MAAT predictions vs. nearest neighbour distances for ancient dataset
Plot2='OPT3MALNearestNeighbourpH_Demo.png'; % Plot of 1 St Dev for pH predictions vs. nearest neighbour distances for ancient dataset
Plot3='OPT3MALReconstructedMAAT_Demo.png'; % Plot of Reconstructed MAAT (+ 1StDev) vs. Sample Number (row) for the ancient dataset
Plot4='OPT3MALReconstructedpH_Demo.png'; % Plot of Reconstructed pH (+ 1StDev) vs. Sample Number (row) for the ancient dataset

%Choose which 3-OH-FA compounds are used to build the GPR model.
AllCompounds=false; %Recommended setting [false] - GPR model is built using only C15 and C17 compounds. [true] uses all 3-OH-FA compounds.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%End of User Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%GPR based on all compounds or just C15 and C17?
if AllCompounds==true
    input=CalibrationData(:,1:21); 
    ancient=UserData(:,1:21);
elseif AllCompounds==false
    input=CalibrationData(:,[12,13,14,17,18,19]); %C15 and C17 compounds only
    ancient=UserData(:,[12,13,14,17,18,19]);
else
    display AllCompounds must be set to true or false. Recommended setting: false.
end
Temp=CalibrationData(:,22);
pH=CalibrationData(:,23);

%Calibrate GP regression on modern calibration data set
%temperature predictor
gprMdltemp = fitrgp(input,Temp,...
        'KernelFunction','ardsquaredexponential',...
        'KernelParameters',[std(input) std(Temp)],'Sigma',std(Temp));  
sigmaLtemp = gprMdltemp.KernelInformation.KernelParameters(1:end-1); % Learned length scales

%pH predictor
gprMdlpH = fitrgp(input,pH,...
        'KernelFunction','ardsquaredexponential',...
        'KernelParameters',[std(input) std(pH)],'Sigma',std(pH));
sigmaLpH = gprMdlpH.KernelInformation.KernelParameters(1:end-1); % Learned length scales

%Apply GP regression to ancient data set for temp
[tempancient,tempancientstd,tempancient95]=predict(gprMdltemp,ancient,'Alpha',0.05);

%Determine weighted nearest neighbour distances for temp
for(i=1:length(ancient)),
    for(j=1:length(input)),
            dist=(input(j,:)-ancient(i,:))./sigmaLtemp';
            distsq(j)=sqrt(sum(dist.^2));
    end;
    [distmintemp(i),index(i)]=min(distsq);
end;

%Apply GP regression to ancient data set for pH
[pHancient,pHancientstd,pHancient95]=predict(gprMdlpH,ancient,'Alpha',0.05);

%Determine weighted nearest neighbour distances for pH
for(i=1:length(ancient)),
    for(j=1:length(input)),
            dist=(input(j,:)-ancient(i,:))./sigmaLpH';
            distsq(j)=sqrt(sum(dist.^2));
    end;
    [distminpH(i),index(i)]=min(distsq);
end;

%Create figure - Standard error (Temp.) vs. DNearest
figure
set(gca, 'FontSize', 12); 
semilogx(distmintemp,tempancientstd,'.', 'MarkerSize', 16); hold on;
plot(0.5*ones(size([0:ceil(max(tempancientstd))])),[0:ceil(max(tempancientstd))],'k:', 'LineWidth', 2); hold off;
grid on
xlabel('$D_\mathrm{nearest}$MAAT','Interpreter', 'latex')
ylabel(['St. Dev. Reconstructed MAAT (' char(176) 'C)'])
saveas(gcf,Plot1)

%Create figure - Standard error (pH) vs. DNearest
figure
set(gca, 'FontSize', 12); 
semilogx(distminpH,pHancientstd,'.', 'MarkerSize', 16); hold on;
plot(0.5*ones(size([0:ceil(max(pHancientstd))])),[0:ceil(max(pHancientstd))],'k:', 'LineWidth', 2); hold off;
grid on
xlabel('$D_\mathrm{nearest}$pH','Interpreter', 'latex')
ylabel('St. Dev. Reconstructed pH')
saveas(gcf,Plot2)

%Create figure - OPT3MAL Temp. vs. sample number
figure
SampleNumber=1:length(tempancient);
set(gca, 'FontSize', 12);
hold on
for (j=1:length(SampleNumber)),
    if (distmintemp(j)<0.5),
        plot([SampleNumber(j),SampleNumber(j)], [tempancient(j)-tempancientstd(j),tempancient(j)+tempancientstd(j)],'-k','LineWidth',1),
    else
        plot([SampleNumber(j),SampleNumber(j)], [tempancient(j)-tempancientstd(j),tempancient(j)+tempancientstd(j)],'-','color', [0.8 0.8 0.8], 'LineWidth',0.5),
    end
end
scatter(SampleNumber(distmintemp>=0.5),tempancient(distmintemp>=0.5), 15, [0.8 0.8 0.8], 'filled');
scatter(SampleNumber(distmintemp<0.5),tempancient(distmintemp<0.5), 25, (distmintemp(distmintemp<0.5)), 'filled');
c = colorbar;
caxis([0 0.5]);
xlabel('Sample Number'),
ylabel(['Reconstructed MAAT (' char(176) 'C)']);
c.Label.String = 'D_{nearest} (MAAT)';
saveas(gcf,Plot3)

%Create figure - OPT3MAL pH vs. sample number
figure
SampleNumber=1:length(pHancient);
set(gca, 'FontSize', 12);
hold on
for (j=1:length(SampleNumber)),
    if (distminpH(j)<0.5),
        plot([SampleNumber(j),SampleNumber(j)], [pHancient(j)-pHancientstd(j),pHancient(j)+pHancientstd(j)],'-k','LineWidth',1),
    else
        plot([SampleNumber(j),SampleNumber(j)], [pHancient(j)-pHancientstd(j),pHancient(j)+pHancientstd(j)],'-','color', [0.8 0.8 0.8], 'LineWidth',0.5),
    end
end
scatter(SampleNumber(distminpH>=0.5),pHancient(distminpH>=0.5), 15, [0.8 0.8 0.8], 'filled');
scatter(SampleNumber(distminpH<0.5),pHancient(distminpH<0.5), 25, (distminpH(distminpH<0.5)), 'filled');
c = colorbar;
caxis([0 0.5]);
xlabel('Sample Number'),
ylabel('Reconstructed pH');
c.Label.String = 'D_{nearest} (pH)';
saveas(gcf,Plot4)

%Output csv file with results
output=[UserData distmintemp' tempancient tempancientstd distminpH' pHancient pHancientstd];
col_header={'C10','i-C11','a-C11','C11','i-C12','C12','i-C13','a-C13','C13','i-C14','C14','i-C15','a-C15','C15','i-C16','C16','i-C17','a-C17','C17','i-C18','C-18','D_nearest_MAAT','MAAT','StDevMAAT','D_nearest_pH','pH','StDevpH'};
fileID=fopen(OPT3MAL_Results, 'w');
fprintf(fileID, '%s, ', col_header {:});
fprintf(fileID, '\n');
fprintf(fileID, '%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f \n', output');
fclose(fileID);
 
