% first clump
sigma1x=0.5;
sigma1y=sigma1x;
m1=[1;1];

N1=500;
D1=gendata(m1,sigma1x,sigma1y,N1);


sigma2x=0.5;
sigma2y=sigma2x;
m2=[3;3];

N2=300;
D2=gendata(m2,sigma2x,sigma2y,N2);


sigma3x=0.4;
sigma3y=sigma3x;
m3=[5;5];

N3=200;
D3=gendata(m3,sigma3x,sigma3y,N3);


data= [D1 D2 D3];
p=randperm(N1+N2+N3);
datap= data(:,p);
datap=data;
figure(1);
scatter(datap(1,:),datap(2,:),25,ones(N1+N2+N3,1),'filled');
title('Scatter Plot of the data');

%sigma=s
sigma=1;

labels=ncut_driver(datap',3,100,0.0); % Data each row is a data point

% if you want to use the nystromized ncut
%labels=nystrom_driver(datap',sigma,200,3,100,0.0);

figure(2);
scatter(datap(1,:),datap(2,:),25,labels,'filled');
title('Labelled Clusters');


