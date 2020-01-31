%{
  #include "stdio.h"
  #include "heading.h"
  int yyeror(char *s);
  int yylex(void);
%}

%union {
  int int_val;
  string* opt_val;
}

%start input
%token<str_val> ID