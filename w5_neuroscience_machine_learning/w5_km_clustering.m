load('kmeans_results.mat'); % IDX has already been created for you
load('MEG_decoding_data_final.mat');
X = MEG_data(:,[200,233]);

figure

% plot a selection of indices in one data structure that meet a specified
% condition in another data structure of the same size
x1 = X(IDX==1, 1); y1 = X(IDX==1, 2); 
plot(x1,y1,'b.','MarkerSize',16);
xlabel('Sensor 200 (T x 10^-12)'); ylabel('Sensor 233 (T x 10^-12)');
set(gca,'Xticklabel', {'-8','-6','-4','-2','0','2','4'});
set(gca,'Yticklabel', {'-6','-4','-2','-0','2','4','6'});
hold on

x2 = X(IDX==2, 1); y2 = X(IDX==2, 2); 
plot(x2,y2,'r.','MarkerSize',16);
x3 = X(IDX==3, 1); y3 = X(IDX==3, 2); 
plot(x3,y3,'g.','MarkerSize',16);
x4 = X(IDX==4, 1); y4 = X(IDX==4, 2); 
plot(x4,y4,'k.','MarkerSize',16);
x5 = X(IDX==5, 1); y5 = X(IDX==5, 2);
plot(x5,y5,'m.','MarkerSize',16);