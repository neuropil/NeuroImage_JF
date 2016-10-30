function [outTable] = FSL_CombineVolumes()

% Location

mainCSVloc = 'Z:\BRAiN_Project\Freesurfer stat text files\FSL_VolumeCSV';
cd(mainCSVloc);

csvDir = dir('*.csv');
csvFiles = {csvDir.name};

PDcases = {'c202','c204','c205','c212','c213','c215','c216','c218','c223',...
           'c225','c227','c228','c232','c233','c235','c237','c246','c252',...
           'c254','c256','c260','c267','c290','c294','c296'};

ETcases = {'c229','c241','c249','c250','c270','c277','c286','c307','c318'};

outTable = table;

for ci = 1:length(csvFiles)
    
    nameParts = strsplit(csvFiles{ci},{'.','_'});
    cName = nameParts{2};
    
    inTable = readtable(csvFiles{ci});

    inTable.Properties.VariableNames([3 4 5 6]) = {'NVoxels' , 'Volume_mm3' , 'IMmean' , 'IMstddev'};
    
    cTable = table(repmat({cName},height(inTable),1),'VariableName',{'CaseName'});
    
    inTable = [cTable , inTable]; %#ok<AGROW>
    
    if ismember(cName,PDcases)
        inTable.Condition = cellstr(repmat('PD',height(inTable),1));
    elseif ismember(cName,ETcases)
        inTable.Condition = cellstr(repmat('ET',height(inTable),1));
    end
    
    outTable = [outTable ; inTable]; %#ok<AGROW>
    
    
end

% Fix Labels





% Save Table mat file
save('FSL_Total.mat','outTable');
writetable(outTable,'tRHiTable.csv')




end


