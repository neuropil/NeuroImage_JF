function [] = CERES_CreateAllCSV()

% Location

mainVolLoc = 'Z:\BRAiN_Project\Freesurfer stat text files\CERES_CSVfiles';

cd(mainVolLoc)

csvDir = dir('*.csv');
csvDirA = {csvDir.name};

allCERESTab = table;
for ci = 1:length(csvDirA)
    
    % tmpTable
    tmpTable = readtable(csvDirA{ci});
    % tmpCname
    nParts = strsplit(csvDirA{ci},{'_','.'});
    tcName = nParts{1};
    
    % clean up
    
    tmpTable.PatientID = tcName;
    tmpTable.ReportDate = [];
    
    PDcases = {'c202','c204','c205','c212','c213','c215','c216','c218','c223',...
        'c225','c227','c228','c232','c233','c235','c237','c246','c252',...
        'c254','c256','c260','c267','c290','c294','c296'};
    
    ETcases = {'c229','c241','c249','c250','c270','c277','c286','c307','c318'};
    
    if ismember(tcName,PDcases)
        tmpTable.Condition = 'PD';
    elseif ismember(tcName,ETcases)
        tmpTable.Condition = 'ET';
    end
    
    if tcName == 'c223'
        tmpTable.Age = 57;
        tmpTable.Sex = 'Male';
    end
    
    allCERESTab = [allCERESTab ; tmpTable]; %#ok<AGROW>
    
end

labelColors = [[255 0 0]    ;... # 1
    [0 255 0]     ;... # 2
    [0 0 255]     ;... # 3
    [255 255 0]   ;... # 4
    [0 255 255]   ;... # 5
    [255 0 255]   ;... # 6
    [255 239 213] ;... # 7
    [0 0 205]     ;... # 8
    [205 133 63]  ;... # 9
    [210 180 140] ;... # 10
    [102 205 170] ;... # 11
    [0 0 128]     ;... # 12
    [0 139 139]   ;... # 13
    [46 139 87]   ;... # 14
    [255 228 225] ;... # 15
    [106 90 205]  ;... # 16
    [221 160 221] ;... # 17
    [233 150 122] ;... # 18
    [165 42 42]   ;... # 19
    [255 245 245] ;... # 20
    [147 112 219] ;... # 21
    [218 112 214] ;... # 22
    [75 0 130]    ;... # 23
    [255 182 193] ;... # 24
    [60 179 113]  ;... # 25
    [218 165 32]  ;... # 26
    ];

labelColor = labelColors/255;

colRegs = {'I_IILeftC','I_IIRightC','IIILeftC','IIIRightC','IVLeftC','IVRightC',...
    'VLeftC','VRigthC','VILeftC','VIRightC','CrusILeftC','CrusIRightC',...
    'CrusIILeftC','CrusIIRightC','VIIBLeftC','VIIBRightC','VIIIALeftC',...
    'VIIIARightC','VIIIBLeftC','VIIIBRightC','IXLeftC','IXRightC','XLeftC',...
    'XRightC','WM_LeftC','WM_RightC'};

cLabsCells = transpose(num2cell(labelColor,2));

colTable = cell2table(cLabsCells,'VariableNames',colRegs); %#ok<NASGU>

cd('Z:\BRAiN_Project\FinalSummaryNIfile');
% Subcortical Cortical
save('AllCERESdata.mat','allCERESTab','colTable');
writetable(allCERESTab,'AllCERESdata.csv')




end
