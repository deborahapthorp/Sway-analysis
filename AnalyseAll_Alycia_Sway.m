

rootDir = '/Users/deborahapthorp/Dropbox (Personal)/UNE/Supervision/Alycia Messing/Data/Data October 2023/Study 2/MATLAB code';
%subNum = 4156; % subject number
%group = 'FC';  % Group
%cond = 'EOOB'; % condition
%sub = num2str(subNum); % turn number into string

VarNamesAreaPath = {'Sub',  'Path', 'Area', 'Trial', 'Group', 'Eye', 'Weight'};

time = 'Sway'; 

participants = importParticipants('Participants.csv'); % import list of participants and their group

count = 0;

for s = 1:length(participants.Participant)
    for eyesOpen = 0:1
        for trial = 1:3
            if eyesOpen
                resultsDir = ['Results_2025_', time ,'/EyesOpen'];
                eye = 'Open';
            else
                resultsDir = ['Results_2025_' ,time ,'/EyesClosed'];
                eye = 'Closed';
            end
            subCode = participants.Participant{s};
            fName = [subCode '_trial_' num2str(trial) '_RESULTS.mat'];
            group = participants.Group(s);
            count = count+1;
            
            if exist([rootDir, '/', resultsDir, '/', fName], 'file')
                
                load([rootDir, '/', resultsDir, '/', fName])
                
                overallResults_Area_Path{count,1} = subCode;
                overallResults_Area_Path{count,2} = results.pathTotal;
                overallResults_Area_Path{count,3} = results.area;
                overallResults_Area_Path{count,4} = trial;
                overallResults_Area_Path{count,5} = group;
                overallResults_Area_Path{count,6} = eye;
                 overallResults_Area_Path{count,7} = data.weight;
            else
                
                overallResults_Area_Path{count,1} = subCode;
                overallResults_Area_Path{count,2} = 'NA';
                overallResults_Area_Path{count,3} = 'NA';
                overallResults_Area_Path{count,4} = trial;
                overallResults_Area_Path{count,5} = group;
                overallResults_Area_Path{count,6} = eye;
                 overallResults_Area_Path{count,7} = 'NA';
                
            end
            
            
        end
    end
end




AreaPath =  cell2table(overallResults_Area_Path); AreaPath.Properties.VariableNames = VarNamesAreaPath; 
writetable(AreaPath, [rootDir,  '/Overall_Area_Path_', time, '.csv']); % write back to text file as well!

