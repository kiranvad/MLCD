
function []=ternPlotsComp(A,colorCode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lastly, an example showing the "constant data option" of
% ternaryc().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-- Plot the axis system
[h,hg,htick]=terplot;
%-- Plot the data ...
hter=ternaryc(A(:,1),A(:,2),A(:,3));
%-- ... and modify the symbol:
set(hter,'marker','.','MarkerFaceColor','red','markersize',15,'Color',colorCode)
hlabels=terlabel('C1','C2','C3');
%--  Modify the tick labels
set(hlabels,'fontsize',15)

set(htick(:,1),'color','r','linewidth',3)
set(htick(:,2),'color','b','linewidth',3)
set(htick(:,3),'color',[12 195 82] ./ 255,'linewidth',3)
end