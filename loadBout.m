function [ o ] = loadBout(path, files, dayLab, grpLab)
    if isempty(files) || isempty(path)
        t=sprintf('Select *csv.mat files for group %s, day %s',grpLab,dayLab);
        [files,path] = uigetfile('*.mat', t,'MultiSelect','on');
    end
    o={};
    td=[];
    tl=[];
    if isa(files,'char')
        files={files};
    end
    for i=1:length(files)
        d = load([path files{i}]);
        l = files(i);
        l={l{1}(1:end-12)};
        l=strrep(l,sprintf('b%s',dayLab),'');
        td=[td double(d.bout_areas)];
        for j=1:length(d.bout_areas)
            tl=[tl l];
        end
    end
    o={tl,td};
end