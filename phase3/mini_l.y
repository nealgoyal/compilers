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
  string findIndex (const string&);
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
%type<str_val> Comp

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
%type<n_term> MultiplicativeExpr
%type<n_term> Term
%type<n_term> TermInner

%%
/* Program */
Program: FunctionList
    {
      $$ = new nonTerm();
      $$->code = $1->code;
      cout << $$->code << endl;
    }
  | %empty 
    {
      $$ = new nonTerm();
      cout << $$->code << endl;
    }
  ;
FunctionList: Function FunctionList
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << $1->code << endl << endl << $2->code;
      $$->code = ss.str();
    }
  | Function
    {
      $$ = new nonTerm();
      $$->code = $1->code;
    }
  ;

/* Function */
Function: FUNCTION Identifier SEMICOLON FunctionParams FunctionLocals FunctionBody
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << "func " << $2->code << endl;
      
      ss << $4->code;
      if ($4->code.length() > 0) {ss << endl;}
      
      ss << $5->code;
      if ($5->code.length() > 0) {ss << endl;}
      
      ss << $6->code;
      if ($6->code.length() > 0) {ss << endl;}
      
      ss << "endfunc";
      $$->code = ss.str();
    }
  ;
FunctionParams: BEGIN_PARAMS DeclarationList END_PARAMS
    {
      $$ = new nonTerm();
      $$->code = $2->code;
    }
  | BEGIN_PARAMS END_PARAMS
    {
      $$ = new nonTerm();
    }
  ;
FunctionLocals: BEGIN_LOCALS DeclarationList END_LOCALS {
      $$ = new nonTerm();
      $$->code = $2->code;
    }
  | BEGIN_LOCALS END_LOCALS {
      $$ = new nonTerm();
    }
  ;
FunctionBody: BEGIN_BODY StatementList END_BODY
    {
      $$ = new nonTerm();
      $$->code = $2->code;
    }
  | BEGIN_BODY END_BODY
    {
      $$ = new nonTerm();
    }
  ;
DeclarationList: DeclarationList Declaration SEMICOLON
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << $1->code << endl << $2->code;
      $$->code = ss.str();
    }
  | Declaration SEMICOLON
    {
      $$ = new nonTerm();
      $$->code = $1->code;
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
    }
  ;
IdentifierList: Identifier {
      $$ = new nonTerm();
      stringstream ss;
      ss << "_" << $1->code;
      $$->code = ss.str();
    }
  | Identifier COMMA IdentifierList {
      $$ = new nonTerm();
      stringstream ss;
      ss << "_" << $1->code << "," << $3->code;
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
      // cout << $2->code << endl;
      $$ = new nonTerm();
      stringstream ss;
      string temp = "";
      for (unsigned i = 0; i < $2->code.length(); ++i) {
        //find each comma
        if ($2->code[i] != ',') {
          temp.push_back($2->code[i]);
        }
        else {
          // reach comma
          if (temp[temp.length() - 1] == ']') {
            //add array var to stream (_ident[2])
            // - calculate x : [ x ] (str.find('[') => pull substring between index '[' and ']'
          }
          else {
            // add integer var to stream
            ss << ".< " << temp << endl;
          }
          temp = "";
        }
      }
      // add last ident in temp (DO NOT END WITH ENDL)
      if (temp[temp.length() - 1] == ']') {
        //add array var to stream (_ident[2])
        // - calculate x : [ x ] (str.find('[') => pull substring between index '[' and ']'
      }
      else {
        // add integer var to stream
        ss << ".< " << temp;
      }

      $$->code = ss.str();
    }
  | WRITE VarList
    {
      $$ = new nonTerm();
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
      $$ = new nonTerm();
      $$->code = $1->code;
    }
  | StatementList Statement SEMICOLON
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << $1->code << endl << $2->code;
      $$->code = ss.str();
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
Comp: EQ {cout << "EQ: " << $$ << endl;}
  | NEQ {cout << "NEQ: " << $$ << endl;}
  | LT {cout << "LT: " << $$ << endl;}
  | GT {cout << "GT: " << $$ << endl;}
  | LTE {cout << "LTE: " << $$ << endl;}
  | GTE {cout << "GTE: " << $$ << endl;}
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
  | %empty
    {
      $$ = new nonTerm();
    }
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
      $$ = new nonTerm();
      $$->code = $1->code;
    }
  | SUB TermInner
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << "- " << $2->code;
      $$->code = ss.str();
    }
  | Identifier L_PAREN ExpressionList R_PAREN
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << $1->code << "(" << $3 << ")";
      $$->code = ss.str();
    }
  ;
TermInner: Var
    {
      // $$ = new nonTerm();
      // stringstream ss;
      // string temp = "";
      // for (unsigned i = 0; i < $1->code.length(); ++i) {
      //   if ($1->code.at(i) == '[') {
      //     ss << endl << ". ";
      //   }

      // ss << $1->code << ". " << endl << "=[] " << ", ";

    }
  | NUMBER
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << to_string($1);
      $$->code = ss.str();
    }
  | L_PAREN Expression R_PAREN
    {
      // $2->code == evalutated expression
      $$ = new nonTerm();
      stringstream ss;
      ss << "(" << $2 << ")";
      $$->code = ss.str();
    }
  ;

/* Var */
Var: Identifier
    {
      // Neal's code
      // $$ = new nonTerm();
      // stringstream ss;
      // ss << $1->code;
      // $$->code = ss.str();
      
      $$ = new nonTerm();
      $$->code = $1->code;
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

      // Neal's code
      // $$ = new nonTerm();
      // stringstream ss;
      // ss << $1->code << ", " << $3->code;
      // $$->code = ss.str();

      $$ = new nonTerm();
      stringstream ss;
      ss << $1->code << "[" << $3 << "]";
      $$->code = ss.str();
    }
  ;
VarList: Var
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << "_" << $1->code;
      $$->code = ss.str();
    }
  | Var COMMA VarList
    {
      $$ = new nonTerm();
      stringstream ss;
      ss << "_" << $1->code << "," << $3->code;
      $$->code = ss.str();
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

string findIndex (const string &ref) {
  // return x in _ident[xx]
  unsigned leftB = ref.find('[');
  if (leftB != string::npos) {
    // [ exists at leftB, ] exists at ref.length() - 1
    int indexLength = ((ref.length() - 1) - leftB) - 1;
    return ref.substr(leftB + 1, indexLength);
  }
  else {
    // return yyerror("Tried to find index in a non-array variable.");
    exit(1);
  }
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
