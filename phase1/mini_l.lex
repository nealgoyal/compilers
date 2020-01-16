%{
  int currLine = 1, currPos = 1;
%}

DIGIT [0-9]

%%

"function" {printf("FUNCTION"); currPos += yyleng;}

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