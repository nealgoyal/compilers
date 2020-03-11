%code requires{
  #include<string>
  using namespace std;
  
  struct nonTerm {
    string code;
    string ret_name;
    string value;
  };
}

%{
  #include "stdio.h"
  #include <string>
  #include <iostream>
  #include <sstream>
  using namespace std;
  int yyeror(char *s);
  int yyerror(string s);
  int yylex(void);
  string makeTemp();
  string makeLabel();
  string createVar(char*);
  extern FILE* yyin;
  
%}
%union {
  int int_val;
  char* str_val;
  nonTerm* n_term;
}

%start Program
%token FUNCTION;
%token BEGIN_PARAMS END_PARAMS;
%token BEGIN_LOCALS END_LOCALS;
%token BEGIN_BODY END_BODY;
%token INTEGER ARRAY OF;
%token IF THEN ENDIF ELSE;
%token WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE;
%token READ WRITE;
%token AND OR NOT TRUE FALSE RETURN;

%token SUB ADD MULT DIV MOD;

%token EQ NEQ LT GT LTE GTE;

%token SEMICOLON COLON COMMA;
%token L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET;
%token ASSIGN;

%token<str_val> IDENT;
%token<int_val> NUMBER;

%type<n_term> Program
%type<n_term> DeclarationList
%type<n_term> Declaration
%type<n_term> FunctionList
%type<n_term> Function
%type<n_term> Identifier
%type<n_term> FunctionParams
%type<n_term> FunctionLocals
%type<n_term> FunctionBody
%type<n_term> StatementList
%type<n_term> Statement
%type<n_term> IdentifierList
%type<n_term> Var
%type<n_term> VarList
%type<n_term> Expression
%type<n_term> ExpressionList
%type<n_term> BoolExpr
%type<n_term> RelationAndExpr
%type<n_term> RelationExpr
%type<n_term> Relations
%type<n_term> Comp
%type<n_term> MultiplicativeExpr
%type<n_term> Term
%type<n_term> TermInner

%%
/* Program */
Program: FunctionList
    {
      // cout << $1->code << endl;
    }
  | %empty {/*$$->ret_name = "";*/}
  ;
FunctionList: FunctionList Function
    {

    }
  | Function
    {
      // $$->code = $1->code;
    }
  ;

/* Function */
Function: FUNCTION Identifier SEMICOLON FunctionParams FunctionLocals FunctionBody
    {
      // stringstream ss;
      // ss << "func " << $2->code << "\n";
      // ss << $4->code << "\n" << $5->code << "\n" << $6->code << "\n";
      // $$->code = ss.str();
    }
  ;
FunctionParams: BEGIN_PARAMS DeclarationList END_PARAMS
    {
      // $$->code = $2->code;
    }
  | BEGIN_PARAMS END_PARAMS
    {
      // $$->code = "";
    }
  ;
FunctionLocals: BEGIN_LOCALS DeclarationList END_LOCALS
    {

    }
  | BEGIN_LOCALS END_LOCALS
    {
      // $$->code = "";
    }
  ;
FunctionBody: BEGIN_BODY StatementList END_BODY
    {

    }
  | BEGIN_BODY END_BODY
    {
      // $$->code = "";
    }
  ;
DeclarationList: DeclarationList Declaration SEMICOLON
    {

    }
  | Declaration SEMICOLON
    {
      // string temp_var = makeTemp();
      // stringstream ss;
      // ss << $1->code;
      // ss << ". " << temp_var;
      // ss << "; " << temp_var << " " << $1->ret_name;
      // $$->code = ss.str();
      // $$->ret_name = temp_var;
    }
  ;

/* Declaration */
Declaration: IdentifierList COLON INTEGER
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << ". ";
      for (unsigned i = 0; i < $1->code.length(); ++i) {
        if ($1->code.at(i) == ',') {
          ss << endl << ". ";
        }
        else {
          ss << $1->code.at(i);
        }
      }
      $$->code = ss.str();
      cout << $$->code << endl;
    }
  | IdentifierList COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << ".[] ";
      for (unsigned i = 0; i < $1->code.length(); ++i) {
        if ($1->code.at(i) == ',') {
          ss << ", " << to_string($5) << endl << ".[] ";
        }
        else {
          ss << $1->code.at(i);
        }
      }
      ss << ", " << to_string($5);
      $$->code = ss.str();
      cout << $$->code << endl;
    }
  ;
IdentifierList: Identifier {
    $$ = new nonTerm();
    stringstream ss;
    ss << "_" << $1->code;
    $$->code = ss.str();
  }
  | Identifier COMMA IdentifierList
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << "_" << $1->code << "," << $3->code;
      // ss << $3->code << endl;
      $$->code = ss.str();
    }
  ;
Identifier: IDENT {
  $$ = new nonTerm();
  $$->code = $1;
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
      // string temp_var = makeTemp();
      // stringstream ss;
      // ss << $1->code << "\n" << $3->code;
      // ss << ". " << temp_var;
      // ss << $2->value << " " << temp_var << ", " << $1->ret_name << ", " << $3->ret_name;
      // $$->code = ss.str();
      // $$->ret_name = temp_var;
    }
  | TRUE {/*$$->value = "1";*/}
  | FALSE {/*$$->value = "0";*/}
  | L_PAREN BoolExpr R_PAREN
    {

    }
  ;

/* Comp */
Comp: EQ {/*$$->value = "==";*/}
  | NEQ {/*$$->value = "<>";*/}
  | LT {/*$$->value = "<";*/}
  | GT {/*$$->value = ">";*/}
  | LTE {/*$$->value = "<=";*/}
  | GTE {/*$$->value = ">=";*/}
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
  | %empty {/*$$->ret_name = "";*/}
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
Var: Identifier
    {
      // string temp_var = makeTemp();
      // stringstream ss;
      // ss << $1->code;
      // ss << ". " << temp_var;
      // ss << temp_var << " " << $1->ret_name;
      // $$->code = ss.str();
      // $$->ret_name = temp_var;
    }
  | Identifier L_SQUARE_BRACKET Expression R_SQUARE_BRACKET
    {
      // string temp_var = makeTemp();
      // stringstream ss;
      // ss << $1->code << "\n" << $3->code;
      // ss << ". " << temp_var;
      // ss << ". []" << $$->value << " " << temp_var << ", " << $1->ret_name << ", " << $3->ret_name;
      // $$->code = ss.str();
      // $$->ret_name = temp_var;
    }
  ;
VarList: Var
    {

    }
  | Var COMMA VarList
    {

    }
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

string createVar(char* ident) {
  string newVar = string(ident);
  // add variable to the syntax table
  return newVar;
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
