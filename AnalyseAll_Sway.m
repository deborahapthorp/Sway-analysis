

rootDir =cd; % Fix this later 
%subNum = 4156; % subject number
%group = 'FC';  % Group
%cond = 'EOOB'; % condition
%sub = num2str(subNum); % turn number into string

VarNamesAreaPath = {'Sub',  'Path', 'Area', 'Trial', 'Weight'};
if ispc 
    sep = '\';
else
    sep = '/'; 
end


%participants = importParticipants('Participants.csv'); % import list of participants and their group
resultsDir = ['Results_Sway', sep];
[~, namesSway] = getFileNames(resultsDir); % Call a handy function I wrote to get folder names
count = 0;

for s = 1:length(namesSway)

 fName = namesSway{s};
        subCode = fName(1:3);
        count = count+1;


 if   contains(fName, 'A')
    trial = 1; 
 elseif contains(fName, 'B')
    trial = 2; 
 elseif  contains(fName, 'C')
    trial = 3; 
 else
     trial = 'NA';
end


        if exist([rootDir, '/', resultsDir, '/', fName], 'file')

            load([rootDir, '/', resultsDir, '/', fName])

            overallResults_Area_Path{count,1} = subCode;
            overallResults_Area_Path{count,2} = results.pathTotal;
            overallResults_Area_Path{count,3} = results.area;
            overallResults_Area_Path{count,4} = trial;
            overallResults_Area_Path{count,5} = data.weight;
        else

            overallResults_Area_Path{count,1} = subCode;
            overallResults_Area_Path{count,2} = 'NA';
            overallResults_Area_Path{count,3} = 'NA';
            overallResults_Area_Path{count,4} = trial;
            overallResults_Area_Path{count,5} = 'NA';

        end
end




AreaPath =  cell2table(overallResults_Area_Path); AreaPath.Properties.VariableNames = VarNamesAreaPath; 
writetable(AreaPath, [rootDir,  '/Overall_Area_Path_.csv']); % write back to text file as well!

