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
Program: FunctionList {printf("Program -> FunctionList \n");}
  | %empty {printf("Program -> %empty \n");}
  ;
FunctionList: FunctionList Function {printf("FunctionList -> FunctionList Function \n");}
  | Function {printf("FunctionList -> Function \n");}
  ;

Function: FUNCTION IDENT ";" FunctionParams FunctionLocals FunctionBody {printf("Function -> FUNCTION IDENT ; FunctionParams FunctionLocals FunctionBody \n");}
  ;
FunctionParams: BEGIN_PARAMS DeclarationList END_PARAMS {printf("FunctionParams -> BEGIN_PARAMS DeclarationList END_PARAMS \n");}
  ;
FunctionLocals: BEGIN_LOCALS DeclarationList END_LOCALS {printf("FunctionLocals -> BEGIN_LOCALS DeclarationList END_LOCALS \n");} 
  ;
FunctionBody: BEGIN_BODY DeclarationList END_BODY {printf("FunctionBody -> BEGIN_BODY DeclarationList END_BODY \n");}
  ;
DeclarationList: DeclarationList Declaration ";" {printf("DeclarationList -> DeclarationList Declaration ; \n");}
  | Declartion ";" {printf("DeclarationList -> Declaration ; \n");}
  ;

Declaration: IdentifierList ":" IDENT {printf("Declaration -> IdentifierList : IDENT \n");}
  | IdentifierList ":" ARRAY "[" NUMBER "]" OF INTEGER {printf("Declaration -> IdentifierList : ARRAY [NUMBER] OF INTEGER \n");}
  ;
IdentifierList: IDENT {printf("IdentifierList -> IDENT \n");}
  | IdentifierList "," IDENT {printf("IdentifierList -> IdentifierList , IDENT \n");}
  ;

%%
int yyerror(string s) {
  extern int yylineno;
  extern char *yytext;

  cerr << "ERROR " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s) {
  return yyerror(string(s));
}
