lexer grammar LLexer;

IF : 'if';
THEN : 'then';
ELSE : 'else';
WHILE : 'while';
PASSING : 'passing';
DO : 'do';
READ : 'read';
WRITE : 'write';
BEGIN : 'begin';
END : 'end';
TRUE : 'true';
FALSE : 'false';

ID : ID_FIRST ID_REST* ;

FLOATING
 : '-'? NUMBER ('.' DIGIT+ EXPONENT?)?
 | '-'? NUMBER EXPONENT?
 | '-'? '.' DIGIT+ EXPONENT?
 ;


OPEN_PAREN : '(';
CLOSE_PAREN : ')';
COLON : ';';
ASSIGN : ':=';
ADD : '+';
SUB : '-';
POW : '**';
MUL : '*';
DIV : '/';
MOD : '%';
EQ : '==';
NEQ : '!=';
GE : '>';
GEQ : '>=';
LE : '<';
LEQ : '<=';
AND : '&&';
OR : '||';
COMMA : ',';


COMMENT : '//' ~[\r\n]* -> channel(HIDDEN);
ML_COMMENT : '/*' (ML_COMMENT|.)*? '*/' -> channel(HIDDEN) ;

SKIP_ : (SPACE | LINEBREAK) -> skip;

fragment
SPACE : [ \t\f];

fragment
LINEBREAK : '\r' | '\n' | '\r\n';



fragment
DIGIT : [0-9];

fragment
DIGIT_FROM_1 : [1-9];

fragment
NUMBER : '0' | DIGIT_FROM_1 DIGIT*;

fragment 
EXPONENT : 'e' [-+]? NUMBER;



fragment
ID_FIRST : '_'| [a-z] ;

fragment
ID_REST : ID_FIRST | [0-9] ;