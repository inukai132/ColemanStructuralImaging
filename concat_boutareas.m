%%

% load('/Users/jcoleman/Dropbox (UFL)/--DATA--/-jenica-/new MD37 bouton data/SIZE(organized 5-12-18)/

% Script to pull out bout_area data Python-generated mat files (from getCSVdata in cell_magic_functions.py) and concatenate to 'dataout'

function [dataout] = concat_boutareas

[mat_filename,mat_pathname] = uigetfile('*.mat', 'Select *csv.mat files for a group-day...',...
    'MultiSelect','on');

for i = 1:length(mat_filename)
    
    if i == 1
     
        a = load([mat_pathname mat_filename{i}]);
        tempa = double(a.bout_areas);
        
        dataout = [tempa];
        
        sancheck(i) = length(dataout);
    
    elseif i > 1
        
        c = load([mat_pathname mat_filename{i}]);
        tempc = double(c.bout_areas);
    
        dataout = [dataout tempc];
        
        sancheck(i) = length(tempc);
        
    end
    
end


