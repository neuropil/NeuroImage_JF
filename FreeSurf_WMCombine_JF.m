function [] = FreeSurf_WMCombine_JF()

txtLoc = 'Z:\BRAiN_Project\Freesurfer stat text files\FreesurfTEXTfiles';
cd(txtLoc)

dirList = dir('*.txt');

flist = {dirList.name};

iLines = cell(length(flist),1);

totalBrainTable = table;
totalSegTable = table; 
totalBrainWMTable = table;
totalSegWMTable = table;
totalRHTable = table;
totalLHTable = table;
totalLHiTable = table;
totalRHiTable = table;

for fi = 1:length(flist)
    
    nameParts = strsplit(flist{fi},{'_','.'});
    
    analysisT = nameParts{2};

    fid = fopen(flist{fi});
    tline = fgets(fid);
    allLines = cell(10000,1);
    lcount = 1;
    while ischar(tline)
        allLines{lcount,1} = tline;
        lcount = lcount + 1;
        tline = fgets(fid);
    end
    
    allLind = cellfun(@(x) ~isempty(x), allLines);
    allLines = allLines(allLind);
    iLines{fi} = allLines;
    casParts = strsplit(flist{fi},'_');
    caseNum = casParts{1};
    
    switch analysisT
        case 'SC'
            
            [scBTable , scSTable] = extractFiles(allLines,caseNum);
            totalBrainTable = [totalBrainTable ; scBTable]; %#ok<*AGROW>
            totalSegTable = [totalSegTable ; scSTable];
            
        case 'WM'
            
            [wmBTable , wmSTable] = extractFiles(allLines,caseNum);
            totalBrainWMTable = [totalBrainWMTable ; wmBTable]; %#ok<*AGROW>
            totalSegWMTable = [totalSegWMTable ; wmSTable];
            
        case 'RH'
            
            [RhemiInfoTable , RhemiTable] = extractHemi(allLines, caseNum);
            totalRHTable = [totalRHTable ; RhemiTable];
            totalRHiTable = [totalRHiTable ; RhemiInfoTable];
            
        case 'LH'
            
            [LhemiInfoTable , LhemiTable] = extractHemi(allLines, caseNum);
            totalLHTable = [totalLHTable ; LhemiTable];
            totalLHiTable = [totalLHiTable ; LhemiInfoTable];
            
    end
    
    fclose(fid);
    
end

%%%% CLEAN UP TABLES

% TotalSegTable;
tstFn = totalSegTable.Properties.VariableNames;
tstFnI = ~ismember(tstFn,{'CaseName','StructName'});
totalSegTable = tableColFunction(totalSegTable, tstFnI);

% TotalSegWMTable;
tswmtFn = totalSegWMTable.Properties.VariableNames;
tswmtFnI = ~ismember(tswmtFn,{'CaseName','StructName'});
totalSegWMTable = tableColFunction(totalSegWMTable, tswmtFnI);

% TotalRHTable;
trtFn = totalRHTable.Properties.VariableNames;
trFnI = ~ismember(trtFn,{'CaseName','StructName'});
totalRHTable = tableColFunction(totalRHTable, trFnI);

% TotalLHTable
tltFn = totalLHTable.Properties.VariableNames;
tlFnI = ~ismember(tltFn,{'CaseName','StructName'});
totalLHTable = tableColFunction(totalLHTable, tlFnI);


cd('Z:\BRAiN_Project\FinalSummaryNIfile')


% Subcortical Cortical
save('TotalBTable.mat','totalBrainTable');
save('TotalSTable.mat','totalSegTable');

writetable(totalBrainTable,'tBrainTable.csv')
writetable(totalSegTable,'tSegTable.csv')

% White Matter
save('TotalBWMTable.mat','totalBrainWMTable');
save('TotalSWMTable.mat','totalSegWMTable');

writetable(totalBrainWMTable,'tBrainWMTable.xlsx')
writetable(totalSegWMTable,'tSegWMTable.xlsx')

% Left Hemisphere
save('TotalBLHTable.mat','totalLHiTable');
save('TotalSLHTable.mat','totalLHTable');

writetable(totalLHiTable,'tLHiTable.xlsx')
writetable(totalLHTable,'tLHsegTable.xlsx')

% Right Hemisphere
save('TotalBRHTable.mat','totalRHiTable');
save('TotalSRHTable.mat','totalRHTable');

writetable(totalRHiTable,'tRHiTable.xlsx')
writetable(totalRHTable,'tRHsegTable.xlsx')





end






function [brainTable,segTable] = extractFiles(inLINES, caseID)

outCount = 1;
dataNames = cell(10000,1);
dataVals = cell(10000,1);
colNames = cell(1,10);
dataCol = cell(200,10);
dcOl = 1;
for li = 1:length(inLINES)
    
    tparts = strsplit(inLINES{li});
    if strcmp(tparts{2},'Measure')
        dataNames{outCount} = tparts{3};
        dataVals{outCount} = textract(tparts);
        outCount = outCount + 1;
    elseif strcmp(tparts{2},'ColHeaders')
        colNames(1,1:10) = tparts(3:length(tparts)-1);
    elseif isnumeric(str2double(tparts{2})) && strcmp(tparts{1},'')
        dataCol(dcOl,1:10) = tparts(2:11);
        dcOl = dcOl + 1;
    end
    
    
end

brainAind = cellfun(@(x) ~isempty(x), dataNames);
dataNames = dataNames(brainAind);
dataVals = dataVals(brainAind);

brainCase = cellstr(repmat(caseID,length(dataVals),1));
allCells = [brainCase, dataNames, dataVals];
brainTable = cell2table(allCells,'VariableNames',{'Case','BArea','Volmm3'});
segAind = cellfun(@(x) ~isempty(x), dataCol(:,1));
dataCol = dataCol(segAind,:);

brainCaseSeg = cellstr(repmat(caseID,size(dataCol,1),1));
dataCol = [brainCaseSeg , dataCol];
colNames = ['CaseName',colNames];
segTable = cell2table(dataCol,'VariableNames',colNames);

end




function [hemiMetaTable , hemiSegTable] = extractHemi(inLINES, caseID)

outCount = 1;
dataNames = cell(10000,1);
dataVals = cell(10000,1);
colNames = cell(1,10);
dataCol = cell(200,10);
dcOl = 1;
for li = 1:length(inLINES)
    
    tparts = strsplit(inLINES{li});
    if strcmp(tparts{2},'Measure')
        dataNames{outCount} = tparts{4};
        dataVals{outCount} = textract(tparts);
        outCount = outCount + 1;
    elseif strcmp(tparts{2},'ColHeaders')
        colNames(1,1:10) = tparts(3:length(tparts)-1);
    elseif isletter(tparts{1}(1)) && ~strcmp(tparts{1}(1),'#')
        dataCol(dcOl,1:10) = tparts(1:10);
        dcOl = dcOl + 1;
    end
    
    
end

hemiAind = cellfun(@(x) ~isempty(x), dataNames);
dataVals = dataVals(hemiAind);

hemiCase = {caseID};
allCells = [hemiCase , transpose(dataVals)];
hemiMetaTable = cell2table(allCells,'VariableNames',{'CaseN','NumVertex','WMSurfArea_mm2','MeanCortThick_mm'});

segAind = cellfun(@(x) ~isempty(x), dataCol(:,1));
dataCol = dataCol(segAind,:);
hemiCaseSeg = cellstr(repmat(caseID,size(dataCol,1),1));
dataCol = [hemiCaseSeg , dataCol];
colNames = ['CaseName',colNames];
hemiSegTable = cell2table(dataCol,'VariableNames',colNames);

end




function [newTable] = tableColFunction(inTable, tabInd)


ind2use = find(tabInd);
numCols = sum(tabInd);

newTable = inTable;

for i = 1:numCols
   
    
    newTable(:,ind2use(i)) = table(num2cell(str2double(table2array(inTable(:,ind2use(i))))));
    
    
end






end




function [outVal] = textract(inParts)


tmpVal = inParts{length(inParts)-2};
outVal = str2double(tmpVal(1:length(tmpVal)-1));



end
