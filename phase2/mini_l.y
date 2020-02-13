%{
  #include "stdio.h"
  #include "heading.h"
  int yyeror(char *s);
  int yylex(void);
%}

%union {
  int int_val;
  char* str_val;
}

%start input
%token<str_val> FUNCTION, IDENT;
%token<str_val> BEGIN_PARAMS, END_PARAMS, BEGIN_LOCALS, END_LOCALS, BEGIN_BODY, END_BODY;
%token<int_val> NUMBER;
%token<str_val> ARRAY, OF, INTEGER;


%%
/* Program */
Program: FunctionList {printf("Program -> FunctionList \n");}
  | %empty {printf("Program -> %empty \n");}
  ;
FunctionList: FunctionList Function {printf("FunctionList -> FunctionList Function \n");}
  | Function {printf("FunctionList -> Function \n");}
  ;

/* Function */
Function: FUNCTION IDENT SEMICOLON FunctionParams FunctionLocals FunctionBody {printf(" Function -> FUNCTION IDENT %s FunctionParams FunctionLocals FunctionBody \n", $3);}
  ;
FunctionParams: BEGIN_PARAMS DeclarationList END_PARAMS {printf("FunctionParams -> BEGIN_PARAMS DeclarationList END_PARAMS \n");}
  ;
FunctionLocals: BEGIN_LOCALS DeclarationList END_LOCALS {printf("FunctionLocals -> BEGIN_LOCALS DeclarationList END_LOCALS \n");} 
  ;
FunctionBody: BEGIN_BODY DeclarationList END_BODY {printf("FunctionBody -> BEGIN_BODY DeclarationList END_BODY \n");}
  ;
DeclarationList: DeclarationList Declaration SEMICOLON {printf("DeclarationList -> DeclarationList Declaration %s \n", $3);}
  | Declartion SEMICOLON {printf("DeclarationList -> Declaration ; \n", $2);}
  ;

/* Declaration */
Declaration: IdentifierList COLON INTEGER {printf("Declaration -> IdentifierList %s INTEGER \n", $2);}
  | IdentifierList COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("Declaration -> IdentifierList %s ARRAY %s NUMBER %s OF INTEGER \n", ($2, $4, $6));}
  ;
IdentifierList: IDENT {printf("IdentifierList -> %s \n", $1);}
  | IdentifierList COMMA IDENT {printf("IdentifierList -> IdentifierList %s %s \n", ($2, $3));}
  ;

/* Statement */
Statement: Var ASSIGN Expression {printf("Statement -> Var %s Expression\n", $2);}
  | IF BoolExpr THEN StatementList ENDIF {printf("Statement -> %s BoolExpr %s StatementList %s\n", ($1, $3, $5));}
  | IF BoolExpr THEN StatementList ELSE StatementList ENDIF {printf("Statement -> %s BoolExpr %s StatementList %s StatementList %s\n", ($1, $3, $5, $7));}
  | WHILE BoolExpr BEGINLOOP StatementList ENDLOOP {printf("Statement -> %s BoolExpr %s StatementList %s\n", ($1, $3, $5));}
  | DO BEGINLOOP StatementList ENDLOOP WHILE BoolExpr {printf("Statement -> %s %s StatementList %s %s BoolExpr\n", ($1, $2, $4, $5));}
  | FOR Var ASSIGN NUMBER SEMICOLON BoolExpr SEMICOLON Var ASSIGN Expression BEGINLOOP StatementList ENDLOOP {printf("Statement -> %s Var %s %s %s BoolExpr %s Var %s Expression %s StatementList %s\n", ($1, $3, $4, $5, $7, $9, $11, $13));}
  | READ VarList {printf("Statement -> %s VarList\n", $1);}
  | WRITE VarList {printf("Statement -> %s VarList\n", $1);}
  | CONTINUE {printf("Statement -> %s\n", $1);}
  | RETURN Expression {printf("Statement -> %s Expression\n", $1);}

/* Bool-Expr */


/* Relation_And_Expr */


/* Relation_Expr */


/* Comp */


/* Expression */


/* Multiplicative_Expr */


/* Term */


/* Var */