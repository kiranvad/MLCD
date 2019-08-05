function varargout=terlabel(label1,label2,label3)
%FUNCTIONS HANDELS=TERLABEL(LABEL1,LABEL2,LABEL3) adds labels to a ternary
% plot. Note that the order of labels must be the same as in the vectors in
% the ternaryc function call.
% The labels can be modified through the handel vector HANDELS.
%
% Uli Theune, Geophysics, University of Alberta
% 2005
%

handles = ones(3,1);
handles(1)=text(0.45,-0.095,label2,'horizontalalignment','center','FontSize',20,'Interpreter','latex');
handles(2)=text(0.12,sqrt(3)/4+0.1,label1,'horizontalalignment','center','rotation',60,'FontSize',20,'Interpreter','latex');
handles(3)=text(0.88,sqrt(3)/4+0.1,label3,'horizontalalignment','center','rotation',-60,'FontSize',20,'Interpreter','latex');

if nargout>=1
    varargout{1} = handles;
end
end