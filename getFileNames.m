function [rootDir, names] = getFileNames(inDir)

if nargin<1
rootDir = uigetdir('', 'Please select the overall directory where the results are stored '); 
else
    rootDir = inDir; 
end

listing = dir(rootDir); % Calls MATLAB function "dir" to get names of everything in the root directory


listing= listing(arrayfun(@(x) x.name(1),  listing) ~= '.'); % remove entries in which 'name' is a dot
names= {listing(~[listing.isdir]).name}; % remove non-directory listings from list

