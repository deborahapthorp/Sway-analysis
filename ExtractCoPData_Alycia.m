%% Analyse postural sway data for Alycia's Parkinsons Project

CoPDir = uigetdir('Please select the directory for the CoP files');

[dataDir, namesSway] = getFileNames(CoPDir); % Call a handy function I wrote to get folder names

resultsDir = 'Results_2025_Sway'; 
if~exist(resultsDir, "dir") 
    mkdir(resultsDir)
end

closed = contains(namesSway, "closed");
closedNames = namesSway(closed); 


open= contains(namesSway, "open");
openNames = namesSway(open); 


%%

for open = 0:1
    for sub = 1:length(closedNames)
        if open
            fileName = [dataDir, '/', openNames{sub}];
            subName = openNames{sub}(1:10);
            saveDir = 'EyesOpen';

        else
            fileName = [dataDir, '/', closedNames{sub}];
            subName = closedNames{sub}(1:10);
            saveDir = 'EyesClosed';
        end
        if~exist([resultsDir '/' saveDir], "dir")
            mkdir([resultsDir '/' saveDir])
        end
        sway = importswayfile(fileName);
        trialNo = fileName(end-4); 
        
         resultsFileName =strcat(resultsDir, '/' , saveDir, '/',  subName, '_trial_', trialNo, '_RESULTS.mat');
        
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
end
