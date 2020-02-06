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
%token<str_val> IDENT;

%%
Program: FunctionList {printf("Program -> FunctionList \n");}
  | %empty {printf("Program -> %empty \n");}
  ;

FunctionList: FunctionList Function {}
  | Function {}
  ;