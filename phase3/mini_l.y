  %{
  #include "stdio.h"
  #include <string>
  #include <iostream>
  using namespace std;
  int yyeror(char *s);
  int yyerror(string s);
  int yylex(void);
  extern FILE* yyin;
  
  struct nonTerm {
    string code;
    string ret_name;
    string value;
  };
%}
%start Program
%token FUNCTION;
%token BEGIN_PARAMS;
%token END_PARAMS;
%token BEGIN_LOCALS;
%token END_LOCALS;
%token BEGIN_BODY;
%token END_BODY;
%token INTEGER;
%token ARRAY;
%token OF;
%token IF;
%token THEN;
%token ENDIF;
%token ELSE;
%token WHILE;
%token DO;
%token FOR;
%token BEGINLOOP;
%token ENDLOOP;
%token CONTINUE;
%token READ;
%token WRITE;
%token AND;
%token OR;
%token NOT;
%token TRUE;
%token FALSE;
%token RETURN;

%token SUB;
%token ADD;
%token MULT;
%token DIV;
%token MOD;

%token EQ;
%token NEQ;
%token LT;
%token GT;
%token LTE;
%token GTE;

%token<str_val> IDENT;
%token<str_val> NUMBER;

%token SEMICOLON;
%token COLON;
%token COMMA;
%token L_PAREN;
%token R_PAREN;
%token L_SQUARE_BRACKET;
%token R_SQUARE_BRACKET;
%token ASSIGN;

%union {
  int int_val;
  char* str_val;
  nonTerm n_;
}

%%
/* Program */
Program: FunctionList
    {

    }
  | %empty {nonTerm n; n.ret_name = ""; $$ = n;}
  ;
FunctionList: FunctionList Function
    {

    }
  | Function
    {

    }
  ;

/* Function */
Function: FUNCTION Identifier SEMICOLON FunctionParams FunctionLocals FunctionBody
    {

    }
  ;
FunctionParams: BEGIN_PARAMS DeclarationList END_PARAMS
    {

    }
  | BEGIN_PARAMS END_PARAMS
    {

    }
  ;
FunctionLocals: BEGIN_LOCALS DeclarationList END_LOCALS
    {

    }
  | BEGIN_LOCALS END_LOCALS
    {

    }
  ;
FunctionBody: BEGIN_BODY StatementList END_BODY
    {

    }
  | BEGIN_BODY END_BODY
    {

    }
  ;
DeclarationList: DeclarationList Declaration SEMICOLON
    {

    }
  | Declaration SEMICOLON
    {

    }
  ;

/* Declaration */
Declaration: IdentifierList COLON INTEGER
    {

    }
  | IdentifierList COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
    {

    }
  ;
IdentifierList: Identifier
    {

    }
  | IdentifierList COMMA Identifier
    {

    }
  ;
Identifier: IDENT
    {

    }
  ;

/* Statement */
Statement: Var ASSIGN Expression
    {

    }
  | IF BoolExpr THEN StatementList ENDIF
    {

    }
  | IF BoolExpr THEN StatementList ELSE StatementList ENDIF
    {

    }
  | WHILE BoolExpr BEGINLOOP StatementList ENDLOOP
    {

    }
  | DO BEGINLOOP StatementList ENDLOOP WHILE BoolExpr
    {

    }
  | FOR Var ASSIGN NUMBER SEMICOLON BoolExpr SEMICOLON Var ASSIGN Expression BEGINLOOP StatementList ENDLOOP
    {

    }
  | READ VarList
    {

    }
  | WRITE VarList
    {

    }
  | CONTINUE
    {

    }
  | RETURN Expression
    {

    }
  ;
StatementList: Statement SEMICOLON
    {

    }
  | StatementList Statement SEMICOLON
    {

    }
  ;

/* Bool-Expr */
BoolExpr: BoolExpr OR RelationAndExpr
    {

    }
  | RelationAndExpr
    {

    }
  ;
/* Relation_And_Expr */
RelationAndExpr: RelationAndExpr AND RelationExpr
    {

    }
  | RelationExpr
    {

    }
  ;

/* Relation_Expr */
RelationExpr: Relations
    {

    }
  | NOT Relations
    {

    }
  ;
Relations: Expression Comp Expression
    {
      nonTerm n;
      string temp_var = makeTemp();
      stringstream ss;
      ss << $1.code << "\n" << $3.code;
      ss << ". " << temp_var;
      ss << $2.value << " " << temp_var << ", " << $1.ret_name << ", " << $3.ret_name;
      n.code = ss.str();
      n.ret_name = temp_var;
      $$ = n;
    }
  | TRUE
    {
      nonTerm n;
		  n.value = "1";
      $$ = n;
    }
  | FALSE
    {
      nonTerm n;
		  n.value = "0";
      $$ = n;
    }
  | L_PAREN BoolExpr R_PAREN
    {

    }
  ;

/* Comp */
Comp: EQ {nonTerm n; n.value = "=="; $$ = n;}
  | NEQ {nonTerm n; n.value = "<>"; $$ = n;}
  | LT {nonTerm n; n.value = "<"; $$ = n;}
  | GT {nonTerm n; n.value = ">"; $$ = n;}
  | LTE {nonTerm n; n.value = "<="; $$ = n;}
  | GTE {nonTerm n; n.value = ">="; $$ = n;}
  ;

/* Expression */
Expression: Expression ADD MultiplicativeExpr
    {

    }
  | Expression SUB MultiplicativeExpr
    {

    }
  | MultiplicativeExpr
    {

    }
  ;
ExpressionList: ExpressionList COMMA Expression
    {

    }
  | Expression
    {

    }
  | %empty {nonTerm n; n.ret_name = ""; $$ = n;}
  ;

/* Multiplicative_Expr */
MultiplicativeExpr: MultiplicativeExpr MULT Term
    {

    }
  | MultiplicativeExpr DIV Term
    {

    }
  | MultiplicativeExpr MOD Term
    {

    }
  | Term
    {

    }
  ;

/* Term */
Term: TermInner
    {

    }
  | SUB TermInner
    {

    }
  | Identifier L_PAREN ExpressionList R_PAREN
    {

    }
  ;
TermInner: Var
    {

    }
  | NUMBER
    {

    }
  | L_PAREN Expression R_PAREN
    {
      
    }
  ;

/* Var */
Var: Identifier {}
  | Identifier L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {}
  ;
VarList: Var {}
  | Var COMMA VarList {}
  ;

%%
string makeTemp() {
  static int tempNum = 0;
  return "__temp__" + to_string(tempNum++);
}

string makeLabel() {
  static int labelNum = 0;
  return "__label__" + to_string(labelNum++);
}

int yyerror(string s) {
  extern int currLine, currPos;
  extern char *yytext;

  cout << "ERROR " << s << " : at symbol " << yytext << " on line " << currLine << ", column " << currPos << endl;
  // printf("ERROR %s at symbol \"%s\" on line %s, column %s\n"), (s, yytext, currLine, currPos);
  exit(1);
}

int yyerror(char* s) {
  return yyerror(string(s));
}
