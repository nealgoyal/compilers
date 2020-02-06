%{
  int currLine = 1, currPos = 1;
%}

DIGIT [0-9]
LETTER [a-zA-Z]

%%
"function" {return("FUNCTION\n"); currPos += yyleng;}
"beginparams" {return("BEGIN_PARAMS\n"); currPos += yyleng;}
"endparams" {return("END_PARAMS\n"); currPos += yyleng;}
"beginlocals" {return("BEGIN_LOCALS\n"); currPos += yyleng;}
"endlocals" {return("END_LOCALS\n"); currPos += yyleng;}
"beginbody" {return("BEGIN_BODY\n"); currPos += yyleng;}
"endbody" {return("END_BODY\n"); currPos += yyleng;}
"integer" {return("INTEGER\n"); currPos += yyleng;}
"array" {return("ARRAY\n"); currPos += yyleng;}
"of" {return("OF\n"); currPos += yyleng;}
"if" {return("IF\n"); currPos += yyleng;}
"then" {return("THEN\n"); currPos += yyleng;}
"endif" {return("ENDIF\n"); currPos += yyleng;}
"else" {return("ELSE\n"); currPos += yyleng;}
"while" {return("WHILE\n"); currPos += yyleng;}
"do" {return("DO\n"); currPos += yyleng;}
"for" {return("FOR\n"); currPos += yyleng;}
"beginloop" {return("BEGINLOOP\n"); currPos += yyleng;}
"endloop" {return("ENDLOOP\n"); currPos += yyleng;}
"continue" {return("CONTINUE\n"); currPos += yyleng;}
"read" {return("READ\n"); currPos += yyleng;}
"write" {return("WRITE\n"); currPos += yyleng;}
"and" {return("AND\n"); currPos += yyleng;}
"or" {return("OR\n"); currPos += yyleng;}
"not" {return("NOT\n"); currPos += yyleng;}
"true" {return("TRUE\n"); currPos += yyleng;}
"false" {return("FALSE\n"); currPos += yyleng;}
"return" {return("RETURN\n"); currPos += yyleng;}

"-" {return("SUB\n"); currPos += yyleng;}
"+" {return("ADD\n"); currPos += yyleng;}
"*" {return("MULT\n"); currPos += yyleng;}
"/" {return("DIV\n"); currPos += yyleng;}
"%" {return("MOD\n"); currPos += yyleng;}

"==" {return("EQ\n"); currPos += yyleng;}
"<>>" {return("NEQ\n"); currPos += yyleng;}
"<" {return("LT\n"); currPos += yyleng;}
">" {return("GT\n"); currPos += yyleng;}
"<=" {return("LTE\n"); currPos += yyleng;}
">=" {return("GTE\n"); currPos += yyleng;}

";" {return("SEMICOLON\n"); currPos += yyleng;}
":" {return("COLON\n"); currPos += yyleng;}
"," {return("COMMA\n"); currPos += yyleng;}
"(" {return("L_PAREN\n"); currPos += yyleng;}
")" {return("R_PAREN\n"); currPos += yyleng;}
"[" {return("L_SQUARE_BRACKET\n"); currPos += yyleng;}
"]" {return("R_SQUARE_BRACKET\n"); currPos += yyleng;}
":=" {return("ASSIGN\n"); currPos += yyleng;}

{DIGIT}+ {printf("NUMBER %s\n", yytext); currPos += yyleng;}

("_"[a-zA-Z0-9_]*)|({DIGIT}[a-zA-Z0-9_]*) {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}

([a-zA-Z0-9_]*"_") {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

({LETTER}+[a-zA-Z0-9_]*) {printf("IDENT %s\n", yytext); currPos += yyleng;}

[ \t]+ {/*ignore : whitespace */ currPos += yyleng;}

"##".* {/*ignore : comments */ currLine++; currPos += yyleng;}

"\n" {currLine++; currPos = 1;}

. {printf("Error on line %d, column %d: unrecognized symbol: \"%s\"\n", currLine, currPos, yytext); exit(0);}

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
