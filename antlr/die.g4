grammar die;

// Define your grammar rules here
dieDefinition: definitionStatements (NEWLINE*|) EOF;

definitionStatements: 
    metadataStatements 
    shapeStatements 
;

metadataStatements
    : metadataStart nameOfDie baseAngle descrizione typeOfDie class taglia part dataDigit metodo altezza area perimetro
    ;

metadataStart: '$$FUSTELLA.v3$$'NEWLINE;
nameOfDie: 'name_of_die' '=' PATH PATH NEWLINE;
baseAngle    : 'baseAngle' '=' INT NEWLINE;
descrizione: 'descrizione' '=' ALPHANUM NEWLINE;
typeOfDie: 'type_of_die' '=' (ALPHANUM| ) NEWLINE;
class: 'class' '=' ALPHANUM NEWLINE;
taglia: 'taglia' '=' (ALPHANUM| ) NEWLINE;
part: 'part' '=' (ALPHANUM| ) NEWLINE;
dataDigit: 'data_digit' '=' DATE NEWLINE;
metodo: 'metodo' '=' (ALPHANUM| ) NEWLINE;
altezza: 'altezza' '=' FLOAT NEWLINE;
area: 'area' '=' FLOAT NEWLINE;
perimetro: 'perimetro' '=' FLOAT NEWLINE;

shapeStatements: shapesDefinitionSTatement+;


// Shapes begin
shapesDefinitionSTatement:
    numofshapes (shapeParameter othersStatement)+ 
;

othersStatement:
    holesDefinitionSTatement
    qareasDefinitionSTatement
    cutsDefinitionSTatement
    signsDefinitionSTatement
    drillsDefinitionSTatement
    labelsDefinitionSTatement;
    
numofshapes: 'num_of_shapes' EQUALS INT NEWLINE;
shapeParameter: sagoma qualitydef numofpoints (pointStatement)+;
sagoma: 'SAGOMA' INT NEWLINE;
qualitydef: 'def_quality' EQUALS INT NEWLINE;
numofpoints: 'num_of_points' EQUALS INT NEWLINE;
pointStatement: 'point' EQUALS FLOAT FLOAT FLOAT NEWLINE;

//Holes Begin 
holesDefinitionSTatement:
    numofholes (holesParameter)+
;
numofholes: 'num_of_holes' EQUALS INT NEWLINE;
holesParameter: numofhpoints (hpointStatement)+;
numofhpoints: 'num_of_hpoints' EQUALS INT NEWLINE;
hpointStatement: 'hpoint' EQUALS FLOAT FLOAT FLOAT NEWLINE;

//qareas begin
qareasDefinitionSTatement:
    numofqareas (qareasParameter)+
;
numofqareas: 'num_of_qarea' EQUALS INT NEWLINE;
qareasParameter: levelofqarea numofqpoints  (qpointStatement)+;
levelofqarea: 'level_of_qarea' EQUALS INT NEWLINE;
numofqpoints: 'num_of_qpoints' EQUALS INT NEWLINE;
qpointStatement: 'qpoint' EQUALS FLOAT FLOAT FLOAT NEWLINE;

//Cut begin
cutsDefinitionSTatement:
    numofcuts (cutsParameter)+
;
numofcuts: 'num_of_cuts' EQUALS INT NEWLINE;
cutsParameter: numofcpoints (cpointStatement)+;
numofcpoints: 'num_of_cpoints' EQUALS INT NEWLINE;
cpointStatement: 'cpoint' EQUALS FLOAT FLOAT FLOAT NEWLINE;

//Sign begin
signsDefinitionSTatement:
    numofsigns (signsParameter)+
;
numofsigns: 'num_of_sign' EQUALS INT NEWLINE;
// signsParameter: numofcpoints (cpointStatement)+;
signsParameter: sign+;
sign: 'sign' EQUALS FLOAT FLOAT FLOAT FLOAT INT FLOAT FLOAT NEWLINE;

// Drill begin 
drillsDefinitionSTatement:
    numofdrills (drillsParameter)+
;
numofdrills: 'num_of_drills' EQUALS INT NEWLINE;
drillsParameter: 'drill' EQUALS FLOAT FLOAT FLOAT INT drillorint FLOAT NEWLINE;
drillorint: ALPHANUM | INT;

// Label begin 
labelsDefinitionSTatement:
    numoflabels (labelsParameter)+
;
numoflabels: 'num_of_labels' EQUALS INT NEWLINE;
labelsParameter: 'label' EQUALS labelText font number{8} NEWLINE;

// 文本标签，包括在中括号内
labelText: '[' text=.*? ']' ;

// 字体定义，包括在尖括号内
font: '<' fontName=.*? '>';

// 数字定义，可以是整数或浮点数
number: INT | FLOAT;
// DRILLSTR: 'DRILL'[0-9];
EQUALS : '=';
DATE: DIGIT'/'DIGIT'/'DIGIT;
FLOAT: '-'? [0-9]+'.'[0-9]+;
INT: '-'? [0-9]+;
ALPHANUM: [a-zA-Z0-9]+; // Set a higher precedence for this rule
PATH: (ALPHANUM | ':' | '\\' | '/' | '.')+;

NEWLINE : ('\r'? '\n') ;
WS : [ \t\r]+ -> skip ;
DIGIT: [0-9]+;