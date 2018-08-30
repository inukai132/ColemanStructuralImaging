function [ dayAll, dayData ] = LoadBoutons( folders )
    global DAYS;
        if ~exist('folders','var')
            for i=1:DAYS
                t = sprintf('Please select folder for day %i',i);
                folders=[folders uigetdir('.',t)];
            end
        end
            
        for i=1:DAYS %Loop through days
            
            filenames = dir(folders{i});
            filenames = filenames(3:end);%Filter out the relative folders '. and ..'
            dayTemp = cell(1,2);
            for filename = 1:length(filenames)%Loop through files in folder

                name = filenames(filename).name;
                if strcmp(name(end-3:end), '.ini')%skip desktop.ini
                    continue
                end
                newBout = loadBout([folders{i} '/'],name,int2str(i),'A'); %Load bouton data
                dayTemp{1} = [dayTemp{1} newBout{1}];%Append it to the current day's data
                dayTemp{2} = [dayTemp{2} newBout{2}];

            end
            dayAll(i,:)=dayTemp;%Add day to full list

        end
    
    %Check that all files have the same number of elements across the days and
    %remove ones that don't
    files = unique(upper(dayAll{1,1})); %Get file names
    nums = [];
    for file_i = 1:length(files)
        nums = [nums sum(strcmpi(dayAll{1,1},files(file_i)))]; %Count elements in each filename for day 1
    end
    for days_i = 2:DAYS
        for file_i = 1:length(files)
            if nums(file_i) > 0 && nums(file_i) ~= sum(strcmpi(dayAll{days_i,1},files(file_i))) %If a day's elements under a certain file don't match, mark the file as invalid
                sprintf('INVALID FILE FOUND: %s had %i elements, expecting %i',files{file_i},sum(strcmpi(dayAll{days_i,1},files(file_i))),nums(file_i))
                nums(file_i) = -1;
            end
        end
    end

    del = upper(files(nums<0)); %Get list of invalid filenames
    for days_i = 1:DAYS
        keep_i = ~ismember(upper(dayAll{days_i,1}),del);
        dayAll{days_i,1}=dayAll{days_i,1}(keep_i);%Remove the invalid data
        dayAll{days_i,2}=dayAll{days_i,2}(keep_i);
        dayData(:,days_i) = dayAll{days_i,2}'; %While we're looping, append day data as a column
    end

end

