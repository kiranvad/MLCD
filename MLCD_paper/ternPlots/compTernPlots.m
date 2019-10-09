
%% ploting ternary diagrams for each ternanry system

dirName = strcat(pwd,'/Images/ternCompsCured/');
mkdir(dirName);

for terN=1:4
    
    A=ternaryClustPlotData{terN,3};
    idx=ternaryClustPlotData{terN,4};
    colorCell = {'r','b','k','m'};
    
    C1 = elementCell{combInds(terN,1)};
    C2 = elementCell{combInds(terN,2)};
    C3 = elementCell{combInds(terN,3)};

    [h,hg,htick]=terplot; % for entire surface
    
    for i=1:4
        %[h,hg,htick]=terplot;  %% for plotting individual clusters

        tempA=A(idx==i,:);
        hter=ternaryc(tempA(:,1),tempA(:,2),tempA(:,3));
        %-- ... and modify the symbol:
        set(hter,'marker','.','MarkerFaceColor','red','markersize',25,'Color',colorCell{i});
        hlabels=terlabel(C1,C2,C3);
        %--  Modify the tick labels
        set(hlabels,'fontsize',15)
        
%         fname=strcat(dirName,sprintf('ternanry_%s',strcat(C1,C2,C3,sprintf('_cluster_%i',i)),'.png'));
%         print(fname,'-dpng')
        %close;
        hold on;
    end
    hold off;
    

    fname=strcat(dirName,'ternanry_',strcat(C1,C2,C3));
    fname=strcat(fname,'.png');
    print(fname,'-dpng')
end

%% ploting for each cluster in a ternary system

addPath = strcat(pwd,'/','ternPlots');
addpath(addPath);
combInds=combnk(1:4,3);
elementCell={'Ce','Co','Fe','Ni'};



dirName = strcat(pwd,'/Images/fullCompTernPlts/');
mkdir(dirName);
for i=1:4
    terN=i;
    C1 = elementCell{combInds(terN,1)};
    C2 = elementCell{combInds(terN,2)};
    C3 = elementCell{combInds(terN,3)};
    
    tempA = compCutNew(:,combInds(i,:));
    [h,hg,htick]=terplot; % for entire surface
    hter=ternaryc(tempA(:,1),tempA(:,2),tempA(:,3));
    %-- ... and modify the symbol:
    set(hter,'marker','.','MarkerFaceColor','red','markersize',25,'Color','b');
    hlabels=terlabel(C1,C2,C3);
    %--  Modify the tick labels
    set(hlabels,'fontsize',15)
    fname=strcat(dirName,sprintf('ternanry_%s',strcat(C1,C2,C3),'.png'));
    print(fname,'-dpng')
    
    close;
end















