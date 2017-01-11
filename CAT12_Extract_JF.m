function [] = CAT12_Extract_JF()

% Hemisphere
% Duration
% Group Cut off



allFsLoc = 'Z:\Yilma_Project\Case_Data';
cd(allFsLoc);

dirFolds = dir;
dirFolds2 = {dirFolds.name};
dirFoldsA = dirFolds2(4:end);


allTable = table;
allmeasures = struct;
allmeasures.nativeMeasure = 'cm^3';
allmeasures.tivMeasure = 'cm^3';
allmeasures.mniMeasure = 'per%';
allmeasures.cortThMeasure = 'mm'; %#ok<STRNU>

presC = 1;

for di = 1:length(dirFoldsA)
    
    cd([allFsLoc, '\', char(dirFoldsA{di}) , '\NIFTI'])
    fSetdirs = dir;
    fdirsTemp = [fSetdirs(:).isdir];
    fdirNames = {fSetdirs(fdirsTemp).name};
    fdirNames(ismember(fdirNames,{'.','..','incoming','NIFTI','Freesurfer'})) = [];
    
    fdirInd = contains(fdirNames,'3D') & contains(fdirNames,'T1');
    
    if sum(fdirInd) == 0
        continue
    end
    
    fdirName2use = fdirNames{fdirInd};
    
    reportLoc = [allFsLoc, '\', char(dirFoldsA{di}) , '\NIFTI\' , fdirName2use '\report'];

    if ~exist(reportLoc,'dir')
        continue
    else
        
        cd(reportLoc)
        
        matDir = dir('*.mat');
        matName = matDir.name;
        
        load(matName);
        
        % Get Case name
        tmpNf = S.filedata.path;
        tmpParts = strsplit(tmpNf,'\');
        tmpNloc = cellfun(@(x) ~isempty(strfind(x,'Case')), tmpParts, 'UniformOutput',true);
        tmpCname = tmpParts{tmpNloc};
        tmpCNparts = strsplit(tmpCname,'_');
        caseNUM = tmpCNparts{2};
        
        allTable.CaseNum{presC,1} = caseNUM;
        
        % Get relevant Data
        
        allTable.csf_nat(presC,1) = S.subjectmeasures.vol_abs_CGW(1);
        allTable.gm_nat(presC,1) = S.subjectmeasures.vol_abs_CGW(2);
        allTable.wm_nat(presC,1) = S.subjectmeasures.vol_abs_CGW(3);
        
        allTable.TIV(presC,1) = S.subjectmeasures.vol_TIV;
        
        allTable.csf_mni(presC,1) = S.subjectmeasures.vol_rel_CGW(1);
        allTable.gm_mni(presC,1) = S.subjectmeasures.vol_rel_CGW(2);
        allTable.wm_mni(presC,1) = S.subjectmeasures.vol_rel_CGW(3);
        
        allTable.cortThick_ave(presC,1) = S.subjectmeasures.dist_thickness{1,1}(1);
        allTable.cortThick_std(presC,1) = S.subjectmeasures.dist_thickness{1,1}(2);
        
        presC = presC + 1;
        
        clear S
        
    end
    
    
end


% Save Data
cd('Z:\Yilma_Project\CompiledCSVdata')

save('CAT12_All.mat','allTable','allmeasures');



end