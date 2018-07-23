DAYS = 4;
DAYLAB = {'-3', '0', '3', '7'};
aData=[];
bData=[];
aAll=cell(0,0);
bAll=cell(0,0);

%Setup Testing Data% 
%% load grpA 

% was trying to just have user select a directory and use all files in order (or based on index of files in rank)
% but not working yet - the rest hopefully you can see changes (eg see changes relative to day '-3', etc)

filename_indices = [3:21];

    for i=1:DAYS
        

        
        tempdir = uigetdir('C:\');
        filenames = dir(tempdir);

        for filename = 1:length(filename_indices)

            aAll(i,:) = loadBout([tempdir '/'],filenames(filename_indices(filename),1).name,DAYLAB{i},'A');
            t=aAll{i,2};
            temp=[aData,t];
            
        end
        
        %add each day as column of data
        aData(:,i) = temp';
        
    end

aAll = aAll';
aData = aData';

%% load grpB

filename_indicesB = [3:10];

    for i=1:DAYS
        
        tempdir = uigetdir('C:\');
        filenames = dir(tempdir);

        for filename = 1:length(filename_indicesB)

            bAll(i,:) = loadBout([tempdir '/'],filenames(filename_indicesB(filename),1).name,DAYLAB{i},'A');
            t=bAll{i,2};
            bData(:,i)=[bData,t];
            
        end
        
    end

bAll = bAll';
bData = bData';

% da = aData(:,2:end)-aData(:,2:end-1);
% sa = aData(:,1:end-1)+aData(:,2:end);
% ma = da./sa;
% 
% db = bData(:,2:end)-bData(:,1:end-1);
% sb = bData(:,1:end-1)+bData(:,2:end);
% mb = db./sb;

%% process - jc data

a_dMD = [aData(:,2)-aData(:,1), aData(:,3)-aData(:,1), aData(:,4)-aData(:,1)];
b_dMD = [bData(:,2)-bData(:,1), bData(:,3)-bData(:,1), bData(:,4)-bData(:,1)];

a_sMD = [aData(:,2)+aData(:,1), aData(:,3)+aData(:,1), aData(:,4)+aData(:,1)];
b_sMD = [bData(:,2)+bData(:,1), bData(:,3)+bData(:,1), bData(:,4)+bData(:,1)];

ma = a_dMD./a_sMD
mb = b_dMD./b_sMD


%% jc plots


for i = 1:3
    figure(i);
    cumplot(ma(:,i), 'bo');
    hold on
    cumplot(mb(:,i), 'ro')
    t=sprintf('Size change (%s --> %s) - a v b',DAYLAB{i},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(:,i), mb(:,i));
    
    
    title([t 'p=' num2str(p)])
end

% percentile-based size categories:

% small -> 0-30
aMD0_ind_smallEPB = find(aData(:,1) <= prctile(aData(:,1), 30));
bMD0_ind_smallEPB = find(bData(:,1) <= prctile(bData(:,1), 30));

atemp1 = find(aData(:,1) > prctile(aData(:,1), 30));
btemp1 = find(bData(:,1) > prctile(bData(:,1), 30));

aMD0_ind_midEPB = find(atemp1(:,1) <= prctile(atemp1(:,1), 70));
bMD0_ind_midEPB = find(btemp1(:,1) <= prctile(btemp1(:,1), 70));

aMD0_ind_largeEPB = find(atemp1(:,1) > prctile(atemp1(:,1), 70));
bMD0_ind_largeEPB = find(btemp1(:,1) > prctile(btemp1(:,1), 70));

% mid ->   30-70
% large -> 70-100

% a v b - all EPBs
for i = 1:3
    figure(i);
    cumplot(ma(:,i), 'bo');
    hold on
    cumplot(mb(:,i), 'ro')
    t=sprintf('Size change (%s --> %s) - a v b',DAYLAB{i},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(:,i), mb(:,i));
    
    
    title([t 'p=' num2str(p)])
end

%% a v b - large EPBs

a_epb_sizegroup = aMD0_ind_midEPB
b_epb_sizegroup = bMD0_ind_midEPB

for i = 1:3
    figure();
    cumplot(ma(a_epb_sizegroup,i), 'bo');
    hold on
    cumplot(mb(b_epb_sizegroup,i), 'ro')
    t=sprintf('Size change (%s --> %s) - a v b | LRG EPBs',DAYLAB{i},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(a_epb_sizegroup,i), mb(b_epb_sizegroup,i));
    
    
    title([t 'p=' num2str(p)])
end



%% plots deltaSize

    for i=1:3
        figure(i);
        subplot(2,1,1);
        hold off;
        t=sprintf('Size change (%s --> %s) - a v b',DAYLAB{i},DAYLAB{i+1});
        H=cdfplot(ma(:,i));
    %     set(H,'Marker','o');
    %     set(H,'LineStyle','none');
        H.Color='r';
        Ax=H.XData;
        Ax(1)=-.5;
        Ax(end)=.5;
        [~,ia,~]=unique(Ax);
        Ax=Ax(ia);
        Ay=H.YData;
        Ay=Ay(ia);
        H.XData=Ax;
        H.YData=Ay;
        sumA=cumtrapz(Ax,Ay);
        hold on;
        H=cdfplot(mb(:,i));
    %     set(H,'Marker','o');
    %     set(H,'LineStyle','none');
        H.Color='b';
        Bx=H.XData;
        Bx(1)=-.5;
        Bx(end)=.5;
        [~,ia,~]=unique(Bx);
        Bx=Bx(ia);
        By=H.YData;
        By=By(ia);
        H.XData = Bx;
        H.YData = By;
        sumB=cumtrapz(Bx,By);
        title(t);
        ylim([0 1]);
        xlim([-.5 .5]);
        subplot(2,1,2);
        if length(sumA) > length(sumB)
            sumB=interp1(Bx,sumB,Ax);
        elseif length(sumA) < length(sumB)
            sumA=interp1(Ax,sumA,Bx);
        end
        hold off;
        df = abs(cumsum(sumA-sumB));
        %area(df);
        %hold on;
        %plot(zeros(size(sumA)),'k')
        plot(-.5:1/(length(df)-1):.5,df)
        ylim([0 2]);
        title('Cumulative difference |a-b|');
    end

    BINWIDTH=5;
    BINLIM=[0 90];
    BINX=BINLIM(1):BINWIDTH:BINLIM(2)-BINWIDTH;

    %% histograms - size

for day=1:4
    figure(day+3);
    subplot(2,1,1);
    hold off;
    histogram(aData(:,day),'BinWidth',BINWIDTH,'BinLimits',BINLIM,'normalization','probability');
    dist=fitdist(aData(:,day),'Kernel','BandWidth',5);
    kernel=pdf(dist,BINX);
    hold on;
    plot(BINX,kernel/sum(kernel), 'r-', 'LineWidth',2);
    t=sprintf('Bouton Size Day %s Group A',DAYLAB{day});
    title(t);
    
    subplot(2,1,2);
    hold off;
    histogram(bData(:,day),'BinWidth',BINWIDTH,'BinLimits',BINLIM,'normalization','probability');
    dist=fitdist(bData(:,day),'Kernel','BandWidth',5);
    kernel=pdf(dist,BINX);
    hold on;
    plot(BINX,kernel/sum(kernel), 'r-', 'LineWidth',2);
    t=sprintf('Bouton Size Day %s Group B',DAYLAB{day});
    title(t);
end