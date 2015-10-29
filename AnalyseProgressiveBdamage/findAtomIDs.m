%% Find expressions for each kind of non-H atom of each amino acid

%Create expression to find in Bdamage files
atomID.aid001 = ' N   GLY';
atomID.aid002 = ' CA  GLY';
atomID.aid003 = ' C   GLY';
atomID.aid004 = ' O   GLY';
atomID.aid005 = ' N   ALA';
atomID.aid006 = ' CA  ALA';
atomID.aid007 = ' C   ALA';
atomID.aid008 = ' O   ALA';
atomID.aid009 = ' CB  ALA';
atomID.aid010 = ' N   VAL';
atomID.aid011 = ' CA  VAL';
atomID.aid012 = ' C   VAL';
atomID.aid013 = ' O   VAL';
atomID.aid014 = ' CB  VAL';
atomID.aid015 = ' CG1 VAL';
atomID.aid016 = ' CG2 VAL';
atomID.aid017 = ' N   ILE';
atomID.aid018 = ' CA  ILE';
atomID.aid019 = ' C   ILE';
atomID.aid020 = ' O   ILE';
atomID.aid021 = ' CB  ILE';
atomID.aid022 = ' CG1 ILE';
atomID.aid023 = ' CG2 ILE';
atomID.aid024 = ' CD  ILE';
atomID.aid025 = ' N   LEU';
atomID.aid026 = ' CA  LEU';
atomID.aid027 = ' C   LEU';
atomID.aid028 = ' O   LEU';
atomID.aid029 = ' CB  LEU';
atomID.aid030 = ' CG  LEU';
atomID.aid031 = ' CD1 LEU';
atomID.aid032 = ' CD2 LEU';
atomID.aid033 = ' N   MET';
atomID.aid034 = ' CA  MET';
atomID.aid035 = ' C   MET';
atomID.aid036 = ' O   MET';
atomID.aid037 = ' CB  MET';
atomID.aid038 = ' CG  MET';
atomID.aid039 = ' SD  MET';
atomID.aid040 = ' CE  MET';
atomID.aid041 = ' N   PHE';
atomID.aid042 = ' CA  PHE';
atomID.aid043 = ' C   PHE';
atomID.aid044 = ' O   PHE';
atomID.aid045 = ' CB  PHE';
atomID.aid046 = ' CG  PHE';
atomID.aid047 = ' CD1 PHE';
atomID.aid048 = ' CD2 PHE';
atomID.aid049 = ' CE1 PHE';
atomID.aid050 = ' CE2 PHE';
atomID.aid051 = ' CZ  PHE';
atomID.aid052 = ' N   TYR';
atomID.aid053 = ' CA  TYR';
atomID.aid054 = ' C   TYR';
atomID.aid055 = ' O   TYR';
atomID.aid056 = ' CB  TYR';
atomID.aid057 = ' CG  TYR';
atomID.aid058 = ' CD1 TYR';
atomID.aid059 = ' CD2 TYR';
atomID.aid060 = ' CE1 TYR';
atomID.aid061 = ' CE2 TYR';
atomID.aid062 = ' CZ  TYR';
atomID.aid063 = ' OH  TYR';
atomID.aid064 = ' N   TRP';
atomID.aid065 = ' CA  TRP';
atomID.aid066 = ' C   TRP';
atomID.aid067 = ' O   TRP';
atomID.aid068 = ' CB  TRP';
atomID.aid069 = ' CG  TRP';
atomID.aid070 = ' CD1 TRP';
atomID.aid071 = ' CD2 TRP';
atomID.aid072 = ' NE1 TRP';
atomID.aid073 = ' CE2 TRP';
atomID.aid074 = ' CE3 TRP';
atomID.aid075 = ' CZ2 TRP';
atomID.aid076 = ' CZ3 TRP';
atomID.aid077 = ' CH2 TRP';
atomID.aid078 = ' N   SER';
atomID.aid079 = ' CA  SER';
atomID.aid080 = ' C   SER';
atomID.aid081 = ' O   SER';
atomID.aid082 = ' CB  SER';
atomID.aid083 = ' OG  SER';
atomID.aid084 = ' N   THR';
atomID.aid085 = ' CA  THR';
atomID.aid086 = ' C   THR';
atomID.aid087 = ' O   THR';
atomID.aid088 = ' CB  THR';
atomID.aid089 = ' OG1 THR';
atomID.aid090 = ' CG2 THR';
atomID.aid091 = ' N   ASN';
atomID.aid092 = ' CA  ASN';
atomID.aid093 = ' C   ASN';
atomID.aid094 = ' O   ASN';
atomID.aid095 = ' CB  ASN';
atomID.aid096 = ' CG  ASN';
atomID.aid097 = ' OD1 ASN';
atomID.aid098 = ' ND2 ASN';
atomID.aid099 = ' N   GLN';
atomID.aid100 = ' CA  GLN';
atomID.aid101 = ' C   GLN';
atomID.aid102 = ' O   GLN';
atomID.aid103 = ' CB  GLN';
atomID.aid104 = ' CG  GLN';
atomID.aid105 = ' CD  GLN';
atomID.aid106 = ' OE1 GLN';
atomID.aid107 = ' NE2 GLN';
atomID.aid108 = ' N   CYS';
atomID.aid109 = ' CA  CYS';
atomID.aid110 = ' C   CYS';
atomID.aid111 = ' O   CYS';
atomID.aid112 = ' CB  CYS';
atomID.aid113 = ' SG  CYS';
atomID.aid114 = ' N   PRO';
atomID.aid115 = ' CA  PRO';
atomID.aid116 = ' C   PRO';
atomID.aid117 = ' O   PRO';
atomID.aid118 = ' CB  PRO';
atomID.aid119 = ' CG  PRO';
atomID.aid120 = ' CD  PRO';
atomID.aid121 = ' N   ARG';
atomID.aid122 = ' CA  ARG';
atomID.aid123 = ' C   ARG';
atomID.aid124 = ' O   ARG';
atomID.aid125 = ' CB  ARG';
atomID.aid126 = ' CG  ARG';
atomID.aid127 = ' CD  ARG';
atomID.aid128 = ' NE  ARG';
atomID.aid129 = ' CZ  ARG';
atomID.aid131 = ' NH1 ARG';
atomID.aid132 = ' NH2 ARG';
atomID.aid133 = ' N   HIS';
atomID.aid134 = ' CA  HIS';
atomID.aid135 = ' C   HIS';
atomID.aid136 = ' O   HIS';
atomID.aid137 = ' CB  HIS';
atomID.aid138 = ' CG  HIS';
atomID.aid139 = ' ND1 HIS';
atomID.aid140 = ' CD2 HIS';
atomID.aid141 = ' CE1 HIS';
atomID.aid142 = ' NE2 HIS';
atomID.aid143 = ' N   LYS';
atomID.aid144 = ' CA  LYS';
atomID.aid145 = ' C   LYS';
atomID.aid146 = ' O   LYS';
atomID.aid147 = ' O   LYS';
atomID.aid148 = ' CG  LYS';
atomID.aid149 = ' CD  LYS';
atomID.aid150 = ' CE  LYS';
atomID.aid151 = ' NZ  LYS';
atomID.aid152 = ' N   ASP';
atomID.aid153 = ' CA  ASP';
atomID.aid154 = ' C   ASP';
atomID.aid155 = ' O   ASP';
atomID.aid156 = ' CB  ASP';
atomID.aid157 = ' CG  ASP';
atomID.aid158 = ' OD1 ASP';
atomID.aid160 = ' OD2 ASP';
atomID.aid161 = ' N   GLU';
atomID.aid162 = ' CA  GLU';
atomID.aid163 = ' C   GLU';
atomID.aid164 = ' O   GLU';
atomID.aid165 = ' CB  GLU';
atomID.aid166 = ' CG  GLU';
atomID.aid167 = ' CD  GLU';
atomID.aid168 = ' CE1 GLU';
atomID.aid169 = ' CE2 GLU';
atomID.aid170 = ' N   MSE';
atomID.aid171 = ' CA  MSE';
atomID.aid172 = ' C   MSE';
atomID.aid173 = ' O   MSE';
atomID.aid174 = ' CB  MSE';
atomID.aid175 = ' CG  MSE';
atomID.aid176 = 'SE   MSE';
atomID.aid177 = ' CE  MSE';
atomID.aid178 = ' N   SEC';
atomID.aid179 = ' CA  SEC';
atomID.aid180 = ' C   SEC';
atomID.aid181 = ' O   SEC';
atomID.aid182 = ' CB  SEC';
atomID.aid183 = 'SE   SEC';
