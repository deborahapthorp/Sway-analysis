%% Analyse postural sway data for Ella Trevaskes dementia and sway project 

CoPDir = uigetdir('Please select the directory for the CoP files'); % Calls interactive function to get the directory name where the CoP files are stored 

[dataDir, namesSway] = getFileNames(CoPDir); % Call a handy function I wrote to get folder names

resultsDir = 'Results_Sway'; 
if~exist(resultsDir, "dir") 
    mkdir(resultsDir)
end

%% Analysis loop 


    for sub = 86:length(namesSway)
   
        fileName = [dataDir, '/', namesSway{sub}];
        subName = namesSway{sub}(1:3); % This may need to be changed depending on naming convention for subjects 
        sway = importswayfile(fileName);
        trialNo = fileName(end-4); % This may need to be changed depending on naming convention for trials
        resultsFileName =strcat(resultsDir, '/' ,  subName, '_trial_', trialNo, '_RESULTS.mat');

        decValue = 20; % donwsample to 50 Hz - this depends on your original frequency obviously! If it's 1000 Hz, you'll downsample by 20.
        data.weight = mean(sway.Fz)*0.1019716; % Convert Newtons to kg
        
        %%
        
        ML_dec = decimate(sway.COPx, decValue);
        AP_dec = decimate(sway.COPy, decValue);
        
        ML_dec = ML_dec - mean(ML_dec(1:100));
        AP_dec = AP_dec - mean(AP_dec(1:100));
        data.ML_dec = ML_dec*1000; % convert from m to mm   
        data.AP_dec = AP_dec*1000; % convert from m to mm
        
                %% Butterworth filter on the data
        Fs = 50; % sampling rate
        Hz = 18; % cutoff frequency for filter
        Wn = Hz/(Fs/2);
        [b,a]=butter(4, Wn, 'low'); %  low-pass order 4 Butterworth filter
        data.filtAP=filter(b,a,data.AP_dec);
        data.filtML=filter(b,a, data.ML_dec);
        
        
                %% Calculate path
        
        for i = 2:length(data.filtAP)
            Path(i) = sqrt((data.filtML(i)- data.filtML(i-1))^2+(data.filtAP(i)- data.filtAP(i-1))^2);
        end
        results.pathTotal = sum(Path);
        
        %% Calculate area
        
            [results.area,results.axes,results.angles,results.ellip] = ellipse(data.filtML ,data.filtAP, [], .95); % don't plot
            
                    %% Save results
        
        save(resultsFileName, 'data', 'results')
        
    end

