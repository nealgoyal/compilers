%{
  #include "stdio.h"
  #include "heading.h"
  int yyeror(char *s);
  int yyerror(string s);
  int yylex(void);
%}

%union {
  int int_val;
  char* str_val;
  string* opt_val;
}

%start Program
%token<str_val> FUNCTION;
%token<str_val> BEGIN_PARAMS;
%token<str_val> END_PARAMS;
%token<str_val> BEGIN_LOCALS;
%token<str_val> END_LOCALS;
%token<str_val> BEGIN_BODY;
%token<str_val> END_BODY;
%token <str_val> INTEGER;
%token<str_val> ARRAY;
%token<str_val> OF;
%token <str_val> IF;
%token<str_val> THEN;
%token <str_val> ENDIF;
%token <str_val> ELSE;
%token <str_val> WHILE;
%token <str_val> DO;
%token <str_val> FOR;
%token <str_val> BEGINLOOP;
%token <str_val> ENDLOOP;
%token <str_val> CONTINUE;
%token <str_val> READ;
%token <str_val> WRITE;
%token<str_val> AND;
%token <str_val> OR;
%token <str_val> NOT;
%token <str_val> TRUE;
%token <str_val> FALSE;
%token <str_val> RETURN;

%token <str_val> SUB;
%token <str_val> ADD;
%token <str_val> MULT;
%token <str_val> DIV;
%token <str_val> MOD;

%token <str_val> EQ;
%token <str_val> NEQ;
%token <str_val> LT;
%token <str_val> GT;
%token <str_val> LTE;
%token <str_val> GTE;

%token <str_val> IDENT;
%token <str_val> NUMBER;

%token <str_val> SEMICOLON;
%token <str_val> COLON;
%token <str_val> COMMA;
%token <str_val> L_PAREN;
%token <str_val> R_PAREN;
%token <str_val> L_SQUARE_BRACKET;
%token <str_val> R_SQUARE_BRACKET;
%token <str_val> ASSIGN;

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
  | Declaration SEMICOLON {printf("DeclarationList -> Declaration ; \n", $2);}
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
  | FOR Var ASSIGN NUMBER SEMICOLON BoolExpr SEMICOLON Var ASSIGN Expression BEGINLOOP StatementList ENDLOOP {printf("Statement -> %s Var %s NUMBER %s BoolExpr %s Var %s Expression %s StatementList %s\n", ($1, $3, $5, $7, $9, $11, $13));}
  | READ VarList {printf("Statement -> %s VarList\n", $1);}
  | WRITE VarList {printf("Statement -> %s VarList\n", $1);}
  | CONTINUE {printf("Statement -> %s\n", $1);}
  | RETURN Expression {printf("Statement -> %s Expression\n", $1);}
  ;
StatementList: Statement SEMICOLON {printf("StatementList -> Statement %s\n", $2);}
  | StatementList Statement SEMICOLON {printf("StatementList -> StatementList Statement %s\n", $3);}
  ;

/* Bool-Expr */
BoolExpr: BoolExpr OR RelationAndExpr {printf("BoolExpr -> BoolExpr %s RelationAndExpr\n", $2);}
  | RelationAndExpr {printf("BoolExpr -> RelationAndExpr\n");}
  ;
/* Relation_And_Expr */
RelationAndExpr: RelationAndExpr AND RelationExpr {printf("RelationAndExpr -> RelationAndExpr %s RelationExpr\n", $2);}
  | RelationExpr {printf("RelationAndExpr -> RelationExpr\n");}
  ;

/* Relation_Expr */
RelationExpr: Relations {printf("RelationExpr -> Relations\n");}
  | NOT Relations {printf("RelationExpr -> %s Relations\n", $1);}
  ;
Relations: Expression Comp Expression {printf("Relations -> Expression Comp Expression\n");}
  | TRUE {printf("Relations -> %s\n", $1);}
  | FALSE {printf("Relations -> %s\n", $1);}
  | L_PAREN BoolExpr R_PAREN {printf("Relations -> %s BoolExpr %s\n", );}
  ;

/* Comp */
Comp: EQ {printf("Comp -> %s\n", $1);}
  | NEQ {printf("Comp -> %s\n", $1);}
  | LT {printf("Comp -> %s\n", $1);}
  | GT {printf("Comp -> %s\n", $1);}
  | LTE {printf("Comp -> %s\n", $1);}
  | GTE {printf("Comp -> %s\n", $1);}
  ;

/* Expression */
Expression: Expression ADD MultiplicativeExpr {printf("Expression -> Expression %s MultiplicativeExpr\n", $2);}
  | Expression SUB MultiplicativeExpr {printf("Expression -> Expression %s MultiplicativeExpr\n", $2);}
  | MultiplicativeExpr {printf("Expression -> MultiplicativeExpr\n");}
  ;
ExpressionList: ExpressionList Expression COMMA {printf("ExpressionList -> ExpressionList Expression %s\n", $3);}
  | Expression {printf("ExpressionList -> Expression\n");}

/* Multiplicative_Expr */
MultiplicativeExpr: MultiplicativeExpr MULT Term {printf("MultiplicativeExpr -> MultiplicativeExpr %s Term\n", $2);}
  | MultiplicativeExpr DIV Term {printf("MultiplicativeExpr -> MultiplicativeExpr %s Term\n", $2);}
  | MultiplicativeExpr MOD Term {printf("MultiplicativeExpr -> MultiplicativeExpr %s Term\n", $2);}
  | Term {printf("MultiplicativeExpr -> Term\n");}
  ;

/* Term */
Term: Var {printf("Term -> Var\n");}
  | NUMBER {printf("Term -> NUMBER\n");}
  | L_PAREN Expression R_PAREN {printf("Term -> %s Expression %s\n", ($1, $3));}
  | SUB Var {printf("Term -> %s Var\n", $1);}
  | SUB NUMBER {printf("Term -> %s NUMBER\n", $1);}
  | SUB L_PAREN Expression R_PAREN {printf("Term -> %s %s Expression %s\n", ($1, $2, $4));}
  | IDENT L_PAREN ExpressionList R_PAREN {printf("Term -> %s %s ExpressionList %s\n", ($1, $2, $4));}
  | IDENT L_PAREN R_PAREN {printf("Term -> %s %s %s\n", ($1, $2, $3));}
  ;

/* Var */
Var: IDENT {printf("Var -> %s\n", $1);}
  | IDENT L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("Var -> %s %s Expression %s\n", ($1, $2, $4));}

VarList: Var {printf("VarList -> Var\n");}
  | VarList Var COMMA {printf("VarList -> VarList Var %s\n", $3);}

%%
int yyerror(string s) {
  extern int currLine;
  extern int currPos;
  extern char *yytext;

  cerr << "ERROR " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << currLine << ", column " << currPos << endl;
  exit(1);
}

int yyerror(char *s) {
  return yyerror(string(s));
}
