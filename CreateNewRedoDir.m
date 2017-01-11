function [] = CreateNewRedoDir()


% First loop

fmainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases';

cd(fmainLoc)

fdir1 = dir;
fdir2 = {fdir1.name};
fdir3 = fdir2(4:end);

fdir4 = fdir3(cellfun(@(x) ~isempty(strfind(x,'Case')), fdir3, 'UniformOutput',true));

for i = 1:length(fdir4)
    
    tmpD = ['Z:\BRAiN_Project\REdoCAT12\',fdir4{i},'\NIFTI'];
    
    mkdir(tmpD)
    
end





% Second loop


smainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases\DTI_Subjects';

cd(smainLoc)

sdir1 = dir;
sdir2 = {sdir1.name};
sdir3 = sdir2(4:end);


for ii = 1:length(sdir3)
    
    tmpS = ['Z:\BRAiN_Project\REdoCAT12\',sdir3{ii},'\NIFTI'];
    
    mkdir(tmpS)
    
end


















end