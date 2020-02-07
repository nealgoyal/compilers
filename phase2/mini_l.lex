%{
  #include "heading.h"
  #include "tok.h"
  int yyerror(char *s);
  int currLine, currPos = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]

%%
"function" {yylval.str_val = strdup(yytext); currPos += yyleng; return FUNCTION;}
"beginparams" {yylval.str_val = strdup(yytext); currPos += yyleng; return BEGIN_PARAMS;}
"endparams" {yylval.str_val = strdup(yytext); currPos += yyleng; return END_PARAMS;}
"beginlocals" {yylval.str_val = strdup(yytext); currPos += yyleng; return BEGIN_LOCALS;}
"endlocals" {yylval.str_val = strdup(yytext); currPos += yyleng; return END_LOCALS;}
"beginbody" {yylval.str_val = strdup(yytext); currPos += yyleng; return BEGIN_BODY;}
"endbody" {yylval.str_val = strdup(yytext); currPos += yyleng; return END_BODY;}
"integer" {yylval.str_val = strdup(yytext); currPos += yyleng; return INTEGER;}
"array" {yylval.str_val = strdup(yytext); currPos += yyleng; return ARRAY;}
"of" {yylval.str_val = strdup(yytext); currPos += yyleng; return OF;}
"if" {yylval.str_val = strdup(yytext); currPos += yyleng; return IF;}
"then" {yylval.str_val = strdup(yytext); currPos += yyleng; return THEN;}
"endif" {yylval.str_val = strdup(yytext); currPos += yyleng; return ENDIF;}
"else" {yylval.str_val = strdup(yytext); currPos += yyleng; return ELSE;}
"while" {yylval.str_val = strdup(yytext); currPos += yyleng; return WHILE;}
"do" {yylval.str_val = strdup(yytext); currPos += yyleng; return DO;}
"for" {yylval.str_val = strdup(yytext); currPos += yyleng; return FOR;}
"beginloop" {yylval.str_val = strdup(yytext); currPos += yyleng; return BEGINLOOP;}
"endloop" {yylval.str_val = strdup(yytext); currPos += yyleng; return ENDLOOP;}
"continue" {yylval.str_val = strdup(yytext); currPos += yyleng; return CONTINUE;}
"read" {yylval.str_val = strdup(yytext); currPos += yyleng; return READ;}
"write" {yylval.str_val = strdup(yytext); currPos += yyleng; return WRITE;}
"and" {yylval.str_val = strdup(yytext); currPos += yyleng; return AND;}
"or" {yylval.str_val = strdup(yytext); currPos += yyleng; return OR;}
"not" {yylval.str_val = strdup(yytext); currPos += yyleng; return NOT;}
"true" {yylval.str_val = strdup(yytext); currPos += yyleng; return TRUE;}
"false" {yylval.str_val = strdup(yytext); currPos += yyleng; return FALSE;}
"return" {yylval.str_val = strdup(yytext); currPos += yyleng; return RETURN;}

"-" {return(SUB); currPos += yyleng;}
"+" {return(ADD); currPos += yyleng;}
"*" {return(MULT); currPos += yyleng;}
"/" {return(DIV); currPos += yyleng;}
"%" {return(MOD); currPos += yyleng;}

"==" {return(EQ); currPos += yyleng;}
"<>>" {return(NEQ); currPos += yyleng;}
"<" {return(LT); currPos += yyleng;}
">" {return(GT); currPos += yyleng;}
"<=" {return(LTE); currPos += yyleng;}
">=" {return(GTE); currPos += yyleng;}

";" {return(SEMICOLON); currPos += yyleng;}
":" {return(COLON); currPos += yyleng;}
"," {return(COMMA); currPos += yyleng;}
"(" {return(L_PAREN); currPos += yyleng;}
")" {return(R_PAREN); currPos += yyleng;}
"[" {return(L_SQUARE_BRACKET); currPos += yyleng;}
"]" {return(R_SQUARE_BRACKET); currPos += yyleng;}
":=" {return ASSIGN; currPos += yyleng;}

{DIGIT}+ {yylval.int_val = atoi(yytext); currPos += yyleng; return NUMBER;}

("_"[a-zA-Z0-9_]*)|({DIGIT}[a-zA-Z0-9_]*) {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(1);}

([a-zA-Z0-9_]*"_") {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(1);}

({LETTER}+[a-zA-Z0-9_]*) {yylval.str_val = strdup(yytext); return IDENT;}

[ \t]+ {/*ignore : whitespace */ currPos += yyleng;}

"##".* {/*ignore : comments */ currLine++;currPos += yyleng;}

"\n" {currLine++; currPos = 1;}

. { std::cerr << "SCANNER "; yyerror(""); exit(1);}

%%

int main(int argc, char** argv) {
  if (argc >= 2) {
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
      yyin = stdin;
    }
  }
  else {
    yyin = stdin;
  }
  yylex();
}
