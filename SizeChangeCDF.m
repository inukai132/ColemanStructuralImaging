function SizeChangeCDF( grpA, grpB, graphTitle, figTitle )
    global LEGENDNAMES;
    for i = 1:3
        figure('name',figTitle);
        cumplot(grpA(:,i), 'b');
        hold on
        cumplot(grpB(:,i), 'r')
        xlim([-1 1]);
        [h,p]=kstest2(grpA(:,i), grpB(:,i));


        title([graphTitle ' p=' num2str(p)])
        legend(LEGENDNAMES);
    end

end

