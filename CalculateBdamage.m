%% Script to calculate B-damage for proteina atom
%Input: the file path to the pdb that you want to calculate B-damage
%factors for
function CalculateBdamage(pathToPDB)

%Start timer to calculate time taken to run the script
mainTimer = tic;

fprintf('################################################################\n')
fprintf('################################################################\n')
fprintf('################################################################\n')
fprintf('### Program to calculate B Damage                            ###\n')
fprintf('################################################################\n')
fprintf('\n\n')

%% Print time and date that program was run
% Get the time and date for the program 
programStartTime = clock;
theYear = programStartTime(1);
theMonth = programStartTime(2);
theDay = programStartTime(3);
theHour = programStartTime(4);
theMinute = programStartTime(5);
theSecond = programStartTime(6);

fprintf('This program was run on %02.d\\%02.d\\%02.d at %02.d:%02.d:%02.0f.\n\n',theDay,theMonth,theYear,theHour,theMinute,theSecond);

%% User Defined Inputs
fprintf('****************************************************************\n')
fprintf('************************ Input Section *************************\n')
fprintf('\n')

%Create a struct containing the input lines for running the CCP4 program
%PDBCUR to generate a Unit Cell
unitCellGenerationInputsPDBCUR = unitCellInputs();

%File suffix for PDB containing original Unit cell coordinates
unitCellPDBSuffix = 'UnitCellCoords';

%Set the Packing Density Threshold (in Angstroms)
packingDensityThreshold = 14;

%Set the bin size for defining packing density environment similarity
binSize = 10;

%Specify what you would like to do with the location of the actual pdb file
%You can either choose to:
%1) 'move' - move the file from its current location to the new PDB folder
%that will be created
%2) 'copy' - copy the file so that 2 copies of the file exist. 1 is kept in
%it's original location and the other is copied to the new directory
%3) 'nothing' - do nothing to the original pdb file location and
pdbFileLocation = 'nothing'; 

%Choose whether or not you would like to create the mega and kilo pdb
%files.
makeMegaPDBFile = true;
makeKiloPDBFile = true;

fprintf('\n')
fprintf('******************* End of Input Section ***********************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')
%% Process pdb file with PDBCUR to generate a unit cell and then store the name of the processed pdb
fprintf('****************************************************************\n')
fprintf('********************* Process PDB Section **********************\n')
fprintf('\n')
fprintf('Processing PDB file to:\n')
fprintf('1 - Remove hydrogen atoms.\n')
fprintf('2 - Keep most probable alternate conformation.\n')
fprintf('3 - Remove anisotropic records from the file.\n')
fprintf('4 - Generate the Unit Cell from Symmetry Operations.\n')
fprintf('\n')

%Split the string containing the path to the PDB file
pdbPathSplit = strsplit(pathToPDB,{'.','\','/'});
%Store the location of the processed pdb
if length(pdbPathSplit) ~= 1
    fprintf('Path to pdb file has been given.\n')
    fprintf('Input pdb file location: %s\n',pathToPDB)
    PDBCode = upper(pdbPathSplit{end-1});
    processedPDB = sprintf('%s%s.pdb',PDBCode,unitCellPDBSuffix);
else
    PDBCode = upper(pdbPathSplit{1});
    processedPDB = sprintf('%s%s.pdb',PDBCode,unitCellPDBSuffix);
    fprintf('Only PDB code given.\n')
    %Convert pdb code to be upper case
    pathToPDB = upper(pathToPDB);
    
    %Create URL for downloading content
    urlText = sprintf('http://www.rcsb.org/pdb/files/%s.pdb',pathToPDB);
    
    %create the name of the pdb file to be created
    pathToPDB = sprintf('%s.pdb',pathToPDB);
    
    fprintf('Downloading the pdb file content from the web and saving it to file: "%s".\n',pathToPDB)
    %download content from the URL and save it to a file in the directory
    urlwrite(urlText,pathToPDB);
end

%If a directory with the PDB code doesn't exist then create one. All files 
%created by this program will be stored there.
if exist(PDBCode,'dir') == 0
    fprintf('A directory named "%s" does not exist in the current directory.\n',PDBCode)
    fprintf('Creating a directory named "%s".\n',PDBCode)
    mkdir(PDBCode)
    
else
    fprintf('A directory named "%s" already exists in the current directory.\n',PDBCode)
    fprintf('All files generated by this program will be moved there.\n')
end

%If user specifies to move the file to the new directory then move the file
%otherwise the user can specify to copy the file to the new location
%otherwise nothing will be done.
if strcmp(pdbFileLocation,'move')
    fprintf('Moving the PDB file located: %s.\n',pathToPDB)
    fprintf('This file will be moved to the %s folder in the current directory.\n',PDBCode)
    movefile(pathToPDB,PDBCode)
elseif strcmp(pdbFileLocation,'copy')
    fprintf('Copying the PDB file located: %s.\n',pathToPDB)
    fprintf('This file will be copied to the %s folder in the current directory.\n',PDBCode)
    copyfile(pathToPDB,PDBCode)
end

fprintf('Running PDBCUR (Winn et al. 2011) to process the PDB file\n')

%Create string with the location of the original PDB file depending on what
%the user decided to do with the original PDB file.
if strcmp(pdbFileLocation,'move') || strcmp(pdbFileLocation,'copy')
    locationOfOriginalPDBFile = strcat(PDBCode,'\',PDBCode,'.pdb');
else
    locationOfOriginalPDBFile = pathToPDB;
end
%Create file path to the location where the processed PDB will be stored
outputLocationOfProcessedPDB = strcat(PDBCode,'\',processedPDB);

%Call function to process the pdb
processPDB(locationOfOriginalPDBFile,outputLocationOfProcessedPDB,unitCellGenerationInputsPDBCUR);

fprintf('\n')
fprintf('Deleting the input file generated to run PDBCUR.\n')

%If the input file generated to run PDBCUR exists in the directory then
%delete it because it's no longer needed.
if exist(unitCellGenerationInputsPDBCUR.filename,'file') ~= 0
    delete(unitCellGenerationInputsPDBCUR.filename)
end

fprintf('\n')
fprintf('**************** End of Process PDB Section ********************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Parse the generated PDB file

fprintf('****************************************************************\n')
fprintf('******************** Parsing PDB Section ***********************\n')
fprintf('\n')
fprintf('Reading the PDB file...\n')

%Start Timing
pdbFileTimer = tic;

%Parse the file to get the coordinates of all of the atoms in the Unit
%Cell along with the Unit cell information.
if ~makeMegaPDBFile && ~makeKiloPDBFile
    [atomicCoordinates000,unitCellInfo,~,~] = getAtomInfo(outputLocationOfProcessedPDB);
else
    [atomicCoordinates000,unitCellInfo,pdbPreamble,pdbEOF] = getAtomInfo(outputLocationOfProcessedPDB); %#ok<ASGLU> -The comment to the left suppresses the warning message
end

%Stop timer
pdbFileTime = toc(pdbFileTimer);

fprintf('Finished Parsing PDB\n')
fprintf('Time taken to read and parse pdb file: %.2f seconds',pdbFileTime)
fprintf('\n')
fprintf('**************** End of Parsing PDB Section ********************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Create the translated copies of the unit cell
fprintf('****************************************************************\n')
fprintf('************** Translate the unit cell Section *****************\n')
fprintf('\n')
fprintf('Converting the unit cell basis vectors to cartesian coordinates.\n')

%Call function to find the equivalent cartesian coordinates that correspond
%to the unit cell basis vectors.
[aTrans, bTrans, cTrans] = findCartesianTranslationVectors(unitCellInfo);

fprintf('Finished conversion.\n\n')

%Start Timing
translationTimer = tic;

fprintf('Now translating unit cell.\n\n')

%Get the x, y and z coordinates for each atom in the unit cell
xyzAtom = str2double(atomicCoordinates000(:,9:11));

%Calculate number of atoms
numberOfAtoms = length(atomicCoordinates000);

%Translate Unit Cell contents and store the translated unit cells in a
%structure variable
%NOTE: In variable "2" corresponds to a "-1" translation
atomicCoordinates.ac001 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,0,1],numberOfAtoms);
atomicCoordinates.ac002 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,0,-1],numberOfAtoms);
atomicCoordinates.ac010 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,1,0],numberOfAtoms);
atomicCoordinates.ac011 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,1,1],numberOfAtoms);
atomicCoordinates.ac012 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,1,-1],numberOfAtoms);
atomicCoordinates.ac020 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,-1,0],numberOfAtoms);
atomicCoordinates.ac021 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,-1,1],numberOfAtoms);
atomicCoordinates.ac022 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,-1,-1],numberOfAtoms);
atomicCoordinates.ac100 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,0,0],numberOfAtoms);
atomicCoordinates.ac101 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,0,1],numberOfAtoms);
atomicCoordinates.ac102 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,0,-1],numberOfAtoms);
atomicCoordinates.ac110 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,1,0],numberOfAtoms);
atomicCoordinates.ac111 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,1,1],numberOfAtoms);
atomicCoordinates.ac112 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,1,-1],numberOfAtoms);
atomicCoordinates.ac120 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,-1,0],numberOfAtoms);
atomicCoordinates.ac121 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,-1,1],numberOfAtoms);
atomicCoordinates.ac122 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[1,-1,-1],numberOfAtoms);
atomicCoordinates.ac200 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,0,0],numberOfAtoms);
atomicCoordinates.ac201 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,0,1],numberOfAtoms);
atomicCoordinates.ac202 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,0,-1],numberOfAtoms);
atomicCoordinates.ac210 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,1,0],numberOfAtoms);
atomicCoordinates.ac211 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,1,1],numberOfAtoms);
atomicCoordinates.ac212 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,1,-1],numberOfAtoms);
atomicCoordinates.ac220 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,-1,0],numberOfAtoms);
atomicCoordinates.ac221 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,-1,1],numberOfAtoms);
atomicCoordinates.ac222 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[-1,-1,-1],numberOfAtoms);
atomicCoordinates.ac000 = translateUnitCellAlternative(atomicCoordinates000,xyzAtom,aTrans,bTrans,cTrans,[0,0,0],numberOfAtoms);

%Clear variable with atomic coordinates of the unit cell
clearvars atomicCoordinates000

%Stop Timing
translationTime = toc(translationTimer);

fprintf('Time taken to translate all unit cells: %.2f seconds',translationTime)
fprintf('\n')
fprintf('*********** End of Translating Unit Cell Section ***************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Create pdb files for the translated unit cells
fprintf('****************************************************************\n')
fprintf('********************* Create PDBs section **********************\n')
fprintf('\n')

fprintf('Storing all unit cell coordinates in an array.\n')
%append all atomic coordinates
allAtomicCoordinates = [atomicCoordinates.ac000;...
    atomicCoordinates.ac001;...
    atomicCoordinates.ac002;...
    atomicCoordinates.ac010;...
    atomicCoordinates.ac011;...
    atomicCoordinates.ac012;...
    atomicCoordinates.ac020;...
    atomicCoordinates.ac021;...
    atomicCoordinates.ac022;...
    atomicCoordinates.ac100;...
    atomicCoordinates.ac101;...
    atomicCoordinates.ac102;...
    atomicCoordinates.ac110;...
    atomicCoordinates.ac111;...
    atomicCoordinates.ac112;...
    atomicCoordinates.ac120;...
    atomicCoordinates.ac121;...
    atomicCoordinates.ac122;...
    atomicCoordinates.ac200;...
    atomicCoordinates.ac201;...
    atomicCoordinates.ac202;...
    atomicCoordinates.ac210;...
    atomicCoordinates.ac211;...
    atomicCoordinates.ac212;...
    atomicCoordinates.ac220;...
    atomicCoordinates.ac221;...
    atomicCoordinates.ac222];

if makeMegaPDBFile
    fprintf('Creating PDB file with coordinates for 27 Unit Cells.\n') %#ok<UNRCH> -The comment to the left suppresses the warning.
    
    %Start Timing
    createMegaPDBTimer = tic;
    
    %Creating PDB files for each of the translated Unit Cells
    createPDBFile(allAtomicCoordinates,pdbPreamble,pdbEOF,outputLocationOfProcessedPDB,'Mega');
    
    %Stop Timing
    createMegaPDBTime = toc(createMegaPDBTimer);
    
    fprintf('Time taken to create the big PDB file was %.2f seconds',createMegaPDBTime)
    fprintf('\n')
    
else
    fprintf('User specified not to create the Mega PDB file.')
    fprintf('\n')
end
fprintf('**************** End of Create PDBs Section ********************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Exclude atoms far away
fprintf('****************************************************************\n')
fprintf('*************** Exclude far away atoms section *****************\n')
fprintf('\n')

%Start Timing
excludeAtomsTimer = tic;

fprintf('Getting the atomic coordinates of molecule from the original PDB file.\n')

%Get atomic coordinates of atoms in orginal PDB
coordinatesPDB = getAtomInfo(locationOfOriginalPDBFile);
    
fprintf('Finished getting coordinates.\n\n')
fprintf('Now creating a box surrounding the atoms.\n')
fprintf('We only want to consider atoms in this box when we calculate the packing density\n\n')
%get the maximum and minimum x,y,z values
maxCoords = max(str2double(coordinatesPDB(:,9:11)));
minCoords = min(str2double(coordinatesPDB(:,9:11)));

%set the exclusion parameters using max/min x,y,z and PDT
maxParam = maxCoords + packingDensityThreshold;
minParam = minCoords - packingDensityThreshold;
% 
% %Check that all unit cell angles are 90 degrees. If so then we can exclude
% %unit cells to speed up the code.
% if unitCellInfo(4) - 90 < 1e-6 && unitCellInfo(5) - 90 < 1e-6 && unitCellInfo(6) - 90 < 1e-6
%     fprintf('Excluding the unit cells that do not contain any atoms in the box.\n')
%     %Exclude Unit Cells too far away
%     unitCells = removeUnitCells(aTrans,bTrans,cTrans,atomicCoordinates,maxParam,minParam);
%     fprintf('Finished excluding unit cells.\n\n')
%     
%     %Clear struct containing all atomic coordinates
%     clearvars atomicCoordinates
%     
%     %Preallocate memory to store the atomic coordinates of the atoms in the
%     %remaining unit cell
%     remainingUnitCells = cell(length(unitCells{1})*length(unitCells),15);
%     
%     %Loop through each unit cell and store the atomic coordinates in a single
%     %cell array
%     for eachUC = 1 : length(unitCells)
%         remainingUnitCells(((eachUC - 1) * length(unitCells{1}) + 1):((eachUC - 1) * length(unitCells{1}) + length(unitCells{1})) , 1:15) = unitCells{eachUC};
%     end
% else
%     %If at least one of the unit cell angles is not 90 degrees then we
%     %can't exclude any unit cells. We need to be a bit more sophisticated!
%    remainingUnitCells = allAtomicCoordinates;
% end

remainingUnitCells = allAtomicCoordinates;

fprintf('Excluding the atoms that lie outside the box.\n')
%Remove atoms outside of box
remainingAtomCoords = removeAtomsFarAwayAlternative(remainingUnitCells,maxParam,minParam);
fprintf('Finished excluding atoms.\n\n')

%clear variable containing all atomic coordinates
clearvars allAtomicCoordinates

%Clear variable with the atomic coordinates of all of the unit cells
clearvars remainingUnitCells

if makeKiloPDBFile
    fprintf('Creating PDB file.\n') %#ok<UNRCH> -The comment to the left suppresess the warning message
    %Create PDB file
    createPDBFile(remainingAtomCoords,pdbPreamble,pdbEOF,outputLocationOfProcessedPDB,'Kilo');
else
    fprintf('User specified not to create a Kilo PDB file.\n')
end

%Stop Timing
excludeAtomsTime = toc(excludeAtomsTimer);

fprintf('Time taken to exclude atoms was %.2f seconds',excludeAtomsTime)
fprintf('\n')
fprintf('**************** End of Create PDBs Section ********************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Calculate Packing density for each atom
fprintf('****************************************************************\n')
fprintf('***************** Calculating Packing Density ******************\n')
fprintf('\n')

fprintf('Calculating the packing density for each atom...\n')
fprintf('This step takes a while.\n')
fprintf('If you want to take a break, coffee or something, now is the time.\n\n')

%Start Timing
calculatingPackingDensityTimer = tic;

%Calculate the packing density for each
fullAtomInformation = calculatePackingDensityAlternative(coordinatesPDB,remainingAtomCoords,packingDensityThreshold);

%Calculate total number of atoms in pdb file
totalNumberOfAtoms = length(coordinatesPDB);

%Calculate the number of unique packing density environments
numberOfUniquePackingDensityEnvironments = length(unique(cell2mat(fullAtomInformation(:,18))));

fprintf('Of the %d atoms in the PDB file there are %d unique packing density environments.\n',totalNumberOfAtoms,numberOfUniquePackingDensityEnvironments)

%Stop Timing
calculatingPackingDensityTime = toc(calculatingPackingDensityTimer);
fprintf('Time taken to calculate packing density for every atom was %.0f minutes and %.0f seconds',floor(calculatingPackingDensityTime/60),rem(calculatingPackingDensityTime,60))
fprintf('\n')
fprintf('********* End of Calculating Packing Density section ***********\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Group the atoms into similar packing density environments
fprintf('****************************************************************\n')
fprintf('******* Calculating Similar Packing Density Environments *******\n')
fprintf('\n')

%Start Timing
similarPDEnvTimer = tic;

%Group atoms into similar packing density environments
fullAtomInformation = calculateSimilarPackingEnvironment(fullAtomInformation,binSize);

%Calculate number of different similar packing density environments
groupNumber = cell2mat(fullAtomInformation(:,19));
%Get unique group numbers
[uniqueGroupNumbers, indicesForNumberOfAtoms, ~] = unique(groupNumber);
%find the number of unique non-zero similar packing density environments
numberOfSimilarPackingDensityEnvironments = length(uniqueGroupNumbers);
fprintf('There are %d non-zero similar packing density environments.\n',numberOfSimilarPackingDensityEnvironments)

%Number of atoms in each bin
numberOfAtomsInEachBin = cell2mat(fullAtomInformation(:,21));

%Create bar chart
fig = figure('name','Bar Graph','Units', 'pixels','Position', [100 100 900 600]);
bar(uniqueGroupNumbers,numberOfAtomsInEachBin(indicesForNumberOfAtoms),'FaceColor',[0 .5 .5],'EdgeColor',[0 0 0],'LineWidth',1.5)
title('Atoms in similar Packing Density Environment','FontSize',20,'FontWeight','bold','FontName'   , 'AvantGarde')
xlabel('Environment number','FontSize',18,'FontName'   , 'AvantGarde')
ylabel('Number of atoms','FontSize',18,'FontName'   , 'AvantGarde')

set(gca,                       ...
  'FontName'    , 'Helvetica', ...
  'FontSize'    , 14         , ...
  'Box'         , 'off'      , ...
  'TickDir'     , 'out'      , ...
  'TickLength'  , [.02 .02]  , ...
  'XMinorTick'  , 'on'       , ...
  'YMinorTick'  , 'on'       , ...
  'YGrid'       , 'on'       , ...
  'XColor'      , [.3 .3 .3] , ...
  'YColor'      , [.3 .3 .3] , ...
  'LineWidth'   , 1         );

%Print bar chart to pdf
set(fig,'PaperOrientation','landscape');
set(fig,'PaperUnits','normalized');
set(fig,'PaperPosition', [0 0 1 1]);
print(fig,'-dpdf', sprintf('%s\\PackingDensityHistogram%s',PDBCode,PDBCode))

%Close the figure 
close

%Stop Timing
similarPDEnvTime = toc(similarPDEnvTimer);
fprintf('Time taken to group into similar packing density environments was %.2f seconds\n',similarPDEnvTime)
fprintf('**** End of Calculating Similar Packing Density Environments ****\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Calculate Bdamage
fprintf('****************************************************************\n')
fprintf('****************** Calculating B Damage ************************\n')
fprintf('\n')

%Start Timing
bDamageTimer = tic;

fprintf('Calculating Bdamage...\n')
fullAtomInformation = calcBDamage(fullAtomInformation);

%Save atom information
fprintf('Saving the atom information as a .MAT file.\n')
fileLocationToStoreAtomVariable = sprintf('%s\\atomInformation%s.mat',PDBCode,PDBCode);
save(fileLocationToStoreAtomVariable,'fullAtomInformation')

%Stop Timing
bDamageTime = toc(bDamageTimer);
fprintf('Time taken for calculating B damage was %.2f seconds\n',bDamageTime)
fprintf('**** End of Calculating B Damage ****\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%% Print Atom data to file
fprintf('****************************************************************\n')
fprintf('****************** Printing B Damage to file *******************\n')
fprintf('\n')

%Start Timing
printingTimer = tic;

%Open file for writing
fileID = fopen(sprintf('%s\\%sBdamage.txt',PDBCode,PDBCode),'w');

%Write preamble with legend
fprintf(fileID,'REC  = RECORD NAME\n');
fprintf(fileID,'SER  = ATOM SERIAL NUMBER\n');
fprintf(fileID,'ATM  = ATOM NAME\n');
fprintf(fileID,'A    = ALTERNATE LOCATION IDENTIFIER\n');
fprintf(fileID,'RES  = RESIDUE NAME\n');
fprintf(fileID,'C    = CHAIN IDENTIFIER\n');
fprintf(fileID,'RS   = RESIDUE SEQUENCE NUMBER\n');
fprintf(fileID,'IN   = CODE FOR INSERTION OF RESIDUES\n');
fprintf(fileID,'XPOS = ORTHOGONAL COORDINATES FOR X IN ANGSTROMS\n');
fprintf(fileID,'YPOS = ORTHOGONAL COORDINATES FOR Y IN ANGSTROMS\n');
fprintf(fileID,'ZPOS = ORTHOGONAL COORDINATES FOR Z IN ANGSTROMS\n');
fprintf(fileID,'OCC  = OCCUPANCY\n');
fprintf(fileID,'BFAC = B FACTOR (TEMPERATURE FACTOR)\n');
fprintf(fileID,'EL   = ELEMENT SYMBOL\n');
fprintf(fileID,'CH   = CHARGE ON ATOM\n');
fprintf(fileID,'AVB  = AVERAGE B FACTOR FOR ATOMS IN SIMILAR PACKING DENSITY ENVIRONMENT\n');
fprintf(fileID,'BDAM = BDAMAGE VALUE\n');
fprintf(fileID,'PD   = PACKING DENSITY (ATOMIC CONTACT NUMBER)\n');
fprintf(fileID,'GN   = SIMILAR PACKING DENSITY ENVIRONMENT GROUP NUMBER\n');
fprintf(fileID,'BIN  = SIMILAR PACKING DENSITY BIN\n');
fprintf(fileID,'ANUM = NUMBER OF ATOMS IN SIMILAR PACKING DENSITY GROUP\n');
fprintf(fileID,'\n');
%Write Column headers 
fprintf(fileID,'%-6s%5s %s%s %s %s   %s  %s %-8s%-8s%-8s%s  %s%10s  %s  %-6.2s %-6.4s%3s %4s      %-15s %4s\n','REC','SER','ATM','A','RES','C','RS','IN','XPOS','YPOS','ZPOS','OCC','BFAC','EL','CH','AVB','BDAM','PD','GN','BIN','ANUM');

for eachAtom = 1 : length(fullAtomInformation)
    fprintf(fileID,'%6s%5s %s%s%s %s%s%s%11s%8s%8s%s%s%12s%s%6.2f%8.4f%4d%4d%20s%4d\n',fullAtomInformation{eachAtom,:});
end

%Close file
fclose(fileID);

%Stop Timing
printingTime = toc(printingTimer);

fprintf('Time taken to print data to file was %.2f seconds\n',printingTime)
fprintf('************* Finished printing B Damage to file ***************\n')
fprintf('****************************************************************\n')
fprintf('\n')
fprintf('----------------------------------------------------------------\n')
fprintf('\n')

%stop timing the time taken for the program to run
timeTaken = toc(mainTimer);

fprintf('Total time taken for program to run was %.0f minutes and %.0f seconds.\n\n',floor(timeTaken/60),rem(timeTaken,60));

end