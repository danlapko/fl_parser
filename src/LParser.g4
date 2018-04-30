parser grammar LParser;

options {tokenVocab=LLexer;}


program : function_def* statement EOF ;

statement : statement COLON statement | terminal_statement ;

terminal_statement : passing | assignment | write | read | while_stmt | if_stmt | function_call ;

begin_end_statement : BEGIN statement COLON statement END | BEGIN terminal_statement END ;

passing : PASSING ;

assignment : identifier ASSIGN expression ;

write : WRITE OPEN_PAREN expression CLOSE_PAREN;

read : READ OPEN_PAREN identifier CLOSE_PAREN;

while_stmt : WHILE condition_expr DO body_stmt ;

if_stmt : IF condition_expr THEN body_stmt ELSE body_stmt ;

condition_expr : OPEN_PAREN expression CLOSE_PAREN ;

body_stmt : terminal_statement | begin_end_statement ;

expression : OPEN_PAREN expression CLOSE_PAREN              # parenExpr
             | expression (MUL | DIV | MOD) expression      # multDivModBinop
             | expression (ADD | SUB) expression            # plusMinusBinop
             | expression (GE | GEQ | LE | LEQ) expression  # greaterLessBinop
             | expression (EQ | NEQ) expression             # equalityBinop
             | expression AND expression                    # andBinop
             | expression OR expression                     # orBinop
             | identifier                                   # idExpr
             | value                                        # valueExpr
             | function_call                                # functionExpr
             ;

value : FLOATING | TRUE | FALSE ;

identifier : ID ;

function_call: ID OPEN_PAREN ( expression (COMMA expression)* )? CLOSE_PAREN ;

function_def: ID OPEN_PAREN ( ID (COMMA ID)* )? CLOSE_PAREN begin_end_statement ;

