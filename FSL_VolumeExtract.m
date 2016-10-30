function [] = FSL_VolumeExtract()


% First loop

fmainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases';

cd(fmainLoc)

fdir1 = dir;
fdir2 = {fdir1.name};
fdir3 = fdir2(4:end);

fdir4 = fdir3(cellfun(@(x) ~isempty(strfind(x,'Case')), fdir3, 'UniformOutput',true));

for i = 1:length(fdir4)
    
    tmpD = [fmainLoc,'\',fdir4{i},'\FSL_subseg'];
    cd(tmpD);
    
    nameParts = strsplit(fdir4{i},'_');

    newName = ['Volumes_c',nameParts{2},'.csv'];
    
    newNloc = ['Z:\BRAiN_Project\Freesurfer stat text files\FSL_VolumeCSV\',newName];   
    
    copyfile([tmpD , '\Volumes.csv'],newNloc);
    
end





% Second loop


smainLoc = 'Z:\BRAiN_Project\MRI_Data_Cases\DTI_Subjects';

cd(smainLoc)

sdir1 = dir;
sdir2 = {sdir1.name};
sdir3 = sdir2(4:end);


for ii = 1:length(sdir3)
    
    tmpS = [smainLoc,'\',sdir3{ii},'\FSL_subseg'];
    
    cd(tmpS);
    
    nameParts = strsplit(sdir3{ii},'_');
    
    newName = ['Volumes_c',nameParts{2},'.csv'];
    
    newNloc = ['Z:\BRAiN_Project\Freesurfer stat text files\FSL_VolumeCSV\',newName];
    
    copyfile([tmpS , '\Volumes.csv'],newNloc);
    
end


















end