function plotSway(folder, subNum, trialNum)

if ispc
    sep = '\';
else
    sep = '/';
end

if trialNum ==1
    trialLetter = 'A'; 
elseif trialNum ==2
    trialLetter = 'B'; 
elseif trialNum ==3
    trialLetter = 'C'; 
else
    error ('Trial number must be between 1 and 3')

end

load([folder, sep, 'Results_Sway', sep, num2str(subNum), '_trial_', trialLetter, '_RESULTS.mat'], 'data', 'results'); 
[results.area,results.axes,results.angles,results.ellip] = ellipse(data.filtML ,data.filtAP, 1, .95); % don't plot
axis equal
title(['Sub ', num2str(subNum), ', trial ' trialLetter])
fontsize("scale", 1.3)