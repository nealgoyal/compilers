%{
  #include "heading.h"
  #include "tok.h"
  int yyerror(char *s);
  int currLine, currPos = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]

%%
"function" {yylval.str_val = strdup("FUNCTION"); currPos += yyleng; return FUNCTION;}
"beginparams" {yylval.str_val = strdup("BEGIN_PARAMS"); currPos += yyleng; return BEGIN_PARAMS;}
"endparams" {yylval.str_val = strdup("END_PARAMS"); currPos += yyleng; return END_PARAMS;}
"beginlocals" {yylval.str_val = strdup("BEGIN_LOCALS"); currPos += yyleng; return BEGIN_LOCALS;}
"endlocals" {yylval.str_val = strdup("END_LOCALS"); currPos += yyleng; return END_LOCALS;}
"beginbody" {yylval.str_val = strdup("BEGIN_BODY"); currPos += yyleng; return BEGIN_BODY;}
"endbody" {yylval.str_val = strdup("END_BODY"); currPos += yyleng; return END_BODY;}
"integer" {yylval.str_val = strdup("INTEGER"); currPos += yyleng; return INTEGER;}
"array" {yylval.str_val = strdup("ARRAY"); currPos += yyleng; return ARRAY;}
"of" {yylval.str_val = strdup("OF"); currPos += yyleng; return OF;}
"if" {yylval.str_val = strdup("IF"); currPos += yyleng; return IF;}
"then" {yylval.str_val = strdup("THEN"); currPos += yyleng; return THEN;}
"endif" {yylval.str_val = strdup("ENDIF"); currPos += yyleng; return ENDIF;}
"else" {yylval.str_val = strdup("ELSE"); currPos += yyleng; return ELSE;}
"while" {yylval.str_val = strdup("WHILE"); currPos += yyleng; return WHILE;}
"do" {yylval.str_val = strdup("DO"); currPos += yyleng; return DO;}
"for" {yylval.str_val = strdup("FOR"); currPos += yyleng; return FOR;}
"beginloop" {yylval.str_val = strdup("BEGINLOOP"); currPos += yyleng; return BEGINLOOP;}
"endloop" {yylval.str_val = strdup("ENDLOOP"); currPos += yyleng; return ENDLOOP;}
"continue" {yylval.str_val = strdup("CONTINUE"); currPos += yyleng; return CONTINUE;}
"read" {yylval.str_val = strdup("READ"); currPos += yyleng; return READ;}
"write" {yylval.str_val = strdup("WRITE"); currPos += yyleng; return WRITE;}
"and" {yylval.str_val = strdup("AND"); currPos += yyleng; return AND;}
"or" {yylval.str_val = strdup("OR"); currPos += yyleng; return OR;}
"not" {yylval.str_val = strdup("NOT"); currPos += yyleng; return NOT;}
"true" {yylval.str_val = strdup("TRUE"); currPos += yyleng; return TRUE;}
"false" {yylval.str_val = strdup("FALSE"); currPos += yyleng; return FALSE;}
"return" {yylval.str_val = strdup("RETURN"); currPos += yyleng; return RETURN;}

"-" {yylval.str_val = strdup("SUB"); currPos += yyleng; return SUB;}
"+" {yylval.str_val = strdup("ADD"); currPos += yyleng; return ADD;}
"*" {yylval.str_val = strdup("MULT"); currPos += yyleng; return MULT;}
"/" {yylval.str_val = strdup("DIV"); currPos += yyleng; return DIV;}
"%" {yylval.str_val = strdup("MOD"); currPos += yyleng; return MOD;}

"==" {yylval.str_val = strdup("EQ"); currPos += yyleng; return EQ;}
"<>>" {yylval.str_val = strdup("NEQ"); currPos += yyleng; return NEQ;}
"<" {yylval.str_val = strdup("LT"); currPos += yyleng; return LT;}
">" {yylval.str_val = strdup("GT"); currPos += yyleng; return GT;}
"<=" {yylval.str_val = strdup("LTE"); currPos += yyleng; return LTE;}
">=" {yylval.str_val = strdup("GTE"); currPos += yyleng; return GTE;}

";" {yylval.str_val = strdup("SEMICOLON"); currPos += yyleng; return SEMICOLON;}
":" {yylval.str_val = strdup("COLON"); currPos += yyleng; return COLON;}
"," {yylval.str_val = strdup("COMMA"); currPos += yyleng; return COMMA;}
"(" {yylval.str_val = strdup("L_PAREN"); currPos += yyleng; return L_PAREN;}
")" {yylval.str_val = strdup("R_PAREN"); currPos += yyleng; return R_PAREN;}
"[" {yylval.str_val = strdup("L_SQUARE_BRACKET"); currPos += yyleng; return L_SQUARE_BRACKET;}
"]" {yylval.str_val = strdup("R_SQUARE_BRACKET"); currPos += yyleng; return R_SQUARE_BRACKET;}
":=" {yylval.str_val = strdup("ASSIGN"); currPos += yyleng; return ASSIGN;}

{DIGIT}+ {yyLval.int_val = atoi(yytext); currPos += yyleng; return NUMBER;}

("_"[a-zA-Z0-9_]*)|({DIGIT}[a-zA-Z0-9_]*) {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(1);}

([a-zA-Z0-9_]*"_") {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(1);}

({LETTER}+[a-zA-Z0-9_]*) {yyLval.str_val = strdup(yytext); currPos += yyleng; return IDENT;}

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
