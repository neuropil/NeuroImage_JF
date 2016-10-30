function [outTable] = FSL_ITKsnapCSVimport(cName)

% Location
inTable = readtable('Volumes.csv');
inTable = inTable(inTable.LabelId ~= 0,:);

% Label List
labelNum = transpose([10 11 12 13 16 17 18 26 49 50 51 52 53 54 58]);
labelID = {'L_Th';'L_Cd';'L_Pu';'L_Pl';'BS';'L_Hp';'L_Am';'L_Ac';'R_Th';...
           'R_Cd';'R_Pu';'R_Pl';'R_Hp';'R_Am';'R_Ac'};
labelColor = [[210 180 140] ; [102 205 170] ; [0 0 128] ; [0 139 139] ;...
              [106 90 205]  ; [221 160 221] ; [233 150 122] ; [255 235 205] ;...
              [34 139 34] ; [248 248 255] ; [245 255 250] ; [255 160 122] ;...
              [144 238 144] ; [173 255 47] ; [128 0 0]]/255;
fslColors = cell(size(labelColor,1),1);
for li = 1:size(labelColor,1)
    fslColors{li,1} = labelColor(li,:);
end

if isequal(labelNum , inTable.LabelId)
    inTable.LabelName = labelID;
else
    for labelI = 1:length(labelNum)
        tLabel = labelNum(labelI);
        lInd = inTable.LabelId == tLabel;
        tCell = labelID(lInd);
        inTable.LabelName(lInd) = tCell{1,1};
    end
end

inTable.LabColor = fslColors;

inTable.Properties.VariableNames([3 4 5 6]) = {'NVoxels' , 'Volume_mm3' , 'IMmean' , 'IMstddev'};

PDcases = {'c202','c204','c294','c205','c212','c213','c215','c216',...
           'c218','c223','c224','c227','c228','c232','c235','c237',...
           'c252','c256','c260','c267'};

ETcases = {'c229','c241','c248','c249','c270','c277','c278','c286',};

if ismember(cName,PDcases)
    inTable.Condition = cellstr(repmat('PD',height(inTable),1));
elseif ismember(cName,ETcases)
    inTable.Condition = cellstr(repmat('ET',height(inTable),1));
end

caseCol = cellstr(repmat(cName,height(inTable),1));

inTable.caseID = caseCol;

outTable = inTable;

end


