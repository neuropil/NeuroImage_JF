function [allCaseD] = subXFStabHemi_v1_JF(BrainArea)



switch BrainArea
    case 'entor'
        
        brFlag = 'entorhinal';
        
    case 'latOB'
        
        brFlag = 'lateralorbitofrontal';
        
    case 'medOB'
        
        brFlag = 'medialorbitofrontal';
end

%%%% MAKE SURE Main DIRECTORY IS CORRECT
cd('Z:\BRAiN_Project\FinalSummaryNIfile')

subTab = readtable('jf_subj_data.csv');



[allCaseD] = getDATA(subTab, brFlag);


end




function [dataOUT] = getDATA(subTab, brFlag)

condS = {'PD','ET'};
dataOUT = struct;
areaDif = struct;
volDif = struct;
thickAve = struct;
for gi = 1:2
    
    condI = condS{gi};
    condIn = ismember(subTab.cond,condI);
    subTabt = subTab(condIn,:);
    
    numCASES = height(subTabt);
    
    caseINDS = 1:1:numCASES;
    
    % Thalamus Volume
    areaDif.(condS{gi}).all = nan(numCASES,1);
    
    % Normalized Volume
    volDif.(condS{gi}).all = nan(numCASES,1);
    
    % Up or Down in size
    thickAve.(condS{gi}).all = nan(numCASES,1);
    
    
    ti = 1;
    
    for si = 1:numCASES
        
        cI = caseINDS(si);
        fsurgC = subTabt.f_surg_n(cI);

        sideIND = subTabt.f_surg_s{cI};
        
        if strcmp(sideIND,'L')
            toLoadfl = 'TotalSLHTable.mat';
            load(toLoadfl);
            tableN = totalLHTable;
        else
            toLoadfl = 'TotalSRHTable.mat';
            load(toLoadfl);
            tableN = totalRHTable;
        end
        
        tableN.CaseName = cellfun(@(x) str2double(x(2:4)), tableN.CaseName);
        
        fsurgInd = ismember(tableN.CaseName,fsurgC);
        
        fsurgTab = tableN(fsurgInd,:);
        
        FSindT = ismember(fsurgTab.StructName,brFlag);
        
        if sum(fsurgInd) == 0 
            continue
        else
            
            areaDif.(condS{gi}).all(ti,1)  = fsurgTab.SurfArea{FSindT};
            
            volDif.(condS{gi}).all(ti,1)   = fsurgTab.GrayVol{FSindT};
            
            thickAve.(condS{gi}).all(ti,1) = fsurgTab.ThickAvg{FSindT};
            
            ti = ti + 1;
        end
    end
    
    [areaDif] = computeSummaryStats(areaDif, condS{gi});
    [volDif] = computeSummaryStats(volDif, condS{gi});
    [thickAve] = computeSummaryStats(thickAve, condS{gi});
    
    dataOUT.BrainROIarea = areaDif;
    dataOUT.BrainROIvolume = volDif;
    dataOUT.TissueThick = thickAve;
    
end


end



function [outSumStats] = computeSummaryStats(dataIN, CondID)

outSumStats = dataIN;
useDATA = dataIN.(CondID).all;

outSumStats.(CondID).all = useDATA;
outSumStats.(CondID).mean  = mean(useDATA);
outSumStats.(CondID).std  = std(useDATA);
outSumStats.(CondID).sem  = sqrt(outSumStats.(CondID).std/length(outSumStats.(CondID).std));
outSumStats.(CondID).ci95p  = outSumStats.(CondID).mean + (1.96*0.475)*outSumStats.(CondID).sem ;
outSumStats.(CondID).ci95n  = outSumStats.(CondID).mean - (1.96*0.475)*outSumStats.(CondID).sem;

end

