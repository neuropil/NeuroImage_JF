function [] = CERES_CSV_compile()


% First loop

fmainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases';

cd(fmainLoc)

fdir1 = dir;
fdir2 = {fdir1.name};
fdir3 = fdir2(4:end);

fdir4 = fdir3(cellfun(@(x) ~isempty(strfind(x,'Case')), fdir3, 'UniformOutput',true));

for i = 1:length(fdir4)
    
    tmpD = [fmainLoc,'\',fdir4{i},'\CERES'];
    
    cd(tmpD);
    
    nameParts = strsplit(fdir4{i},'_');

    newName = ['c',nameParts{2},'.csv'];
    
    newNloc = ['Z:\BRAiN_Project\Freesurfer stat text files\CERES_CSVfiles\',newName];   
    
    copyfile([tmpD , '\', newName], newNloc);
    
end





% Second loop


smainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases\DTI_Subjects';

cd(smainLoc)

sdir1 = dir;
sdir2 = {sdir1.name};
sdir3 = sdir2(4:end);


for ii = 1:length(sdir3)
    
    tmpS = [smainLoc,'\',sdir3{ii},'\CERES'];
    
    cd(tmpS);
    
    nameParts = strsplit(sdir3{ii},'_');
    
    newName = ['c',nameParts{2},'.csv'];
    
    newNloc = ['Z:\BRAiN_Project\Freesurfer stat text files\CERES_CSVfiles\',newName];
    
    copyfile([tmpS , '\', newName], newNloc);
    
end


















end