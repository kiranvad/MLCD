function []=savemean_clusterperf(direc)
folderInfo = dir([ direc '/*.csv*']);
fileID = fopen([pwd direc '_MeanScores.txt'],'w');
fprintf(fileID,'%-10s \t AMI \t ARI \t FMS \t NMI \n','Metric');
val = [];
for i=1:length(folderInfo)
    T = readtable([folderInfo(i).folder '/' folderInfo(i).name]);
    field = strsplit(folderInfo(i).name,'.');
    val = [val;mean(T{:,:})];
    fprintf(fileID,'%-10s \t %0.2f \t %0.2f \t %0.2f \t%0.2f \n',field{1},val(i,1),val(i,2),...
        val(i,3),val(i,4));
    if strcmp(field{1},'mt-lmnn')
        refid = i;
    end
end
vec_ref = readtable([folderInfo(refid).folder '/' folderInfo(refid).name]);

for i=1:size(T,2)
    [~,maxid] = max(val(:,i));
    vec_best = readtable([folderInfo(maxid).folder '/' folderInfo(maxid).name]);
    [h(i),p(i)] = ttest(vec_best{:,i},vec_ref{:,i},'Tail','right','Alpha',0.01);

end
fprintf(fileID,'================================================== \n');
fprintf(fileID,'%-10s \t %0.2f \t %0.2f \t %0.2f \t%0.2f \n','hvalue',h(1),h(2),...
    h(3),h(4));
fprintf(fileID,'%-10s \t %0.2f \t %0.2f \t %0.2f \t%0.2f \n','pvalue',p(1),p(2),...
    p(3),p(4));
fprintf('Computed: %s \n',direc);
fclose(fileID);
