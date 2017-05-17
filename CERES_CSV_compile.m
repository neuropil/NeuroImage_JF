function [] = CERES_CSV_compile_ET()


% First loop

fmainLoc = 'X:\EssentialTremor_GrantData\OASIS_DATA\ET_Controls\caseDATA';

cd(fmainLoc)

fdir1 = dir;
fdir2 = {fdir1.name};
fdir3 = fdir2(~ismember(fdir2,{'.','..'}));

for i = 1:length(fdir3)
    
    tmpD = [fmainLoc,'\',fdir3{i},'\CERES_2'];
    
    if ~exist(tmpD,'dir')
        continue
    end
    
    cd(tmpD);

    oldName = ['etctl_c',fdir3{i},'.csv'];
    newName = ['cc',fdir3{i},'.csv'];
    
    newNloc = ['X:\EssentialTremor_GrantData\CeresCSVfiles\',newName];   
    
    copyfile([tmpD , '\', oldName], newNloc);
    
end





% Second loop


smainLoc = 'X:\EssentialTremor_GrantData\ET_ExperimentalDATA';

cd(smainLoc)

sdir1 = dir;
sdir2 = {sdir1.name};
sdir3 = sdir2(~ismember(fdir2,{'.','..'}));


for ii = 1:length(sdir3)
    
    tmpS = [smainLoc,'\',sdir3{ii},'\CERES'];
    
    cd(tmpS);
    
    nameParts = strsplit(sdir3{ii},'_');
    
    newName = ['c',nameParts{2},'.csv'];
    
    newNloc = ['X:\EssentialTremor_GrantData\CeresCSVfiles\',newName];
    
    copyfile([tmpS , '\', newName], newNloc);
    
end


















end