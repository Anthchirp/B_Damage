#Copyright Thomas Dixon 2015
def genPDBCURinputs(PDBCURinputFile, delhydrogen):
    #import os for OS usability
    import os
    #check if an input file has already been created
    if os.path.exists(PDBCURinputFile):
        #inform user file already exists
        print 'Input file for PDBCUR already exists at %s' % PDBCURinputFile
        #exit method if file exists
        return    
    #open a text file for writing
    print 'Creating input file for PDBCUR at %s' % PDBCURinputFile
    #write input keywords to file for use with PDBCUR
    with open(PDBCURinputFile,'w') as f:
        #only write input line delhydrogen if not specified otherwise by user
        if delhydrogen == 1:
            #delhydrogen keyword removes all hydrogen atoms from PDB
            f.write('delhydrogen\n')
        #cutocc keyword removes all atoms with occupancy of 0 from PDB
        f.write('cutocc\n')
        #mostprob keyword only keeps atoms from conformations with the highest occupancy
        #if equal occupancies then only one is retained (A)
        f.write('mostprob\n')
        #noanisou keyword removes all ANISOU information from PDB
        f.write('noanisou\n')
        #genunit keyword generates a unit cell
        f.write('genunit\n')
        f.close
#end genPDBCURinputs
def runPDBCUR(pathToPDB, PDBCURoutputPDB, PDBCURinputFile):
    #import os for OS usability
    import os
    #check if output file has already been created
    if os.path.exists(PDBCURoutputPDB):
        #inform user file already exists
        print 'Output file from PDBCUR already exists at %s\n' % PDBCURoutputPDB
        #exit method if file exists
        return
    #create a string for command line input to run PDBCUR
    runPDBCURcommand = 'pdbcur xyzin %s xyzout %s < %s' % (pathToPDB, PDBCURoutputPDB, PDBCURinputFile)
    #run PDBCUR to specifications
    os.system(runPDBCURcommand)
    #inform user of generated PDBCUR output file
    print 'Creating output file from PDBCUR at %s\n' % PDBCURoutputPDB
#end runPDBCUR 