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
  bool continueCheck (const string &ref);
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
      stringstream ss;
      
      ss << $2->code << endl;
      // FIXME send each ident up through ret_name and print out "= ident, $0 \n = ident2, $1, ..."
      string ident;
      int paramNum = 0;
      for (unsigned i = 0; i < $2->ret_name.length(); ++i) {
        if ($2->ret_name[i] == ',') {
          ss << "= " << ident << ", $" << to_string(paramNum) << endl;
          ident = "";
          paramNum++;
          continue;
        }
        ident.push_back($2->ret_name[i]);
      }

      if (ident.length() > 0) {
        ss << "= " << ident << ", $" << to_string(paramNum);
      }


      $$->code = ss.str();
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
      if (continueCheck($2->code)) {
        cout << "Error: continue statement not within a loop." << endl;
        exit(1);
      }

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
      stringstream ss, slist;

      ss << $1->code << endl << $2->code;
      
      slist << $1->ret_name << "," << $2->ret_name;

      $$->code = ss.str();
      $$->ret_name = slist.str();
    }
  | Declaration SEMICOLON
    {
      $$ = new nonTerm();
      $$->code = $1->code;
      $$->ret_name = $1->ret_name; // pass identlist up
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
      $$->ret_name = $1->code; // pass identlist up
    }
  | IdentifierList COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
    {
      // FIXME
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
      $$->ret_name = $1->code; // pass identlist up
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
      $$ = new nonTerm();
      stringstream ss;
      
      ss << $3->code << endl;
      ss << "= " << $1->code << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = $1->code;
    }
  | IF BoolExpr THEN StatementList ENDIF
    {
      $$ = new nonTerm();
      string ifTrue = makeLabel();
      string ifFalse = makeLabel();
      stringstream ss;
      ss << $2->code << endl; // Add BoolExpr code to the stream
      ss << "?:= " << ifTrue << ", " << $2->ret_name << endl; // if true, go to label ifTrue
      ss << ":= " << ifFalse << endl; // if false, send to the false label
      ss << ": " << ifTrue << endl; // start the true branch
      ss << $4->code << endl; // add statementlist code to the stream
      ss << ": " << ifFalse; // add false branch label, in this case branch is empty so no new line

      $$->code = ss.str();
      // $$->ret_name = ???
    }
  | IF BoolExpr THEN StatementList ELSE StatementList ENDIF
    {
      $$ = new nonTerm();
      string ifTrue = makeLabel();
      string ifFalse = makeLabel();
      stringstream ss;
      ss << $2->code << endl; // Add BoolExpr code to the stream
      ss << "?:= " << ifTrue << ", " << $2->ret_name << endl; // if true, go to label ifTrue
      ss << ":= " << ifFalse << endl; // if false, send to the false label
      ss << ": " << ifTrue << endl; // start the true branch
      ss << $4->code << endl; // add true statementlist code to the stream
      ss << ": " << ifFalse << endl; // add false branch label
      ss << $6->code; // add false statementlist code - no new line because end of stream

      $$->code = ss.str();
      // $$->ret_name = ???
    }
  | WHILE BoolExpr BEGINLOOP StatementList ENDLOOP
    {
      $$ = new nonTerm();
      string conditionalLabel = makeLabel();
      string startLabel = makeLabel();
      string endLabel = makeLabel();
      stringstream ss;

      // while find("continue") != ::npos => replace with ":= conditionalLabel"

      ss << ": " << conditionalLabel << endl; // begin while loop
      ss << $2->code << endl; // add condtional statements
      ss << "?:= " << startLabel << ", " << $2->ret_name << endl; // goto start of loop if true
      ss << ":= " << endLabel << endl; // goto end if false
      ss << ": " << startLabel << endl;
      ss << $4->code << endl; // output statementlist code
      ss << ":= " << conditionalLabel << endl; // re-evaluate loop conditions
      ss << ": " << endLabel;

      $$->code = ss.str();
    }
  | DO BEGINLOOP StatementList ENDLOOP WHILE BoolExpr
    {
      $$ = new nonTerm();
      string startLabel = makeLabel();
      string conditionalLabel = makeLabel();
      stringstream ss;

      ss << ": " << startLabel << endl; // mark loop start label
      ss << $3->code << endl;
      ss << ": " << conditionalLabel << endl;
      ss << $6->code << endl;
      ss << "?:= " << startLabel << ", " << $6->ret_name;

      $$->code = ss.str();
    }
  | FOR Var ASSIGN NUMBER SEMICOLON BoolExpr SEMICOLON Var ASSIGN Expression BEGINLOOP StatementList ENDLOOP
    {
      $$ = new nonTerm();
      string conditionalLabel = makeLabel();
      string startLabel = makeLabel();
      string endLabel = makeLabel();
      string loopVariable = makeTemp();
      stringstream ss;
      
      ss << "= " << loopVariable << ", " << $4 << endl; // __temp__ = loop variable
      ss << ": " << conditionalLabel << endl;
      ss << $6->code << endl; // loop condition code
      ss << "?:= " << startLabel << ", " << $6->ret_name << endl;
    }
  | READ VarList
    {
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
            // FIXME add array var to stream (_ident[2])
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
        // FIXME
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
            ss << ".> " << temp << endl;
          }
          temp = "";
        }
      }
      // add last ident in temp (DO NOT END WITH ENDL)
      if (temp[temp.length() - 1] == ']') {
        // FIXME
        //add array var to stream (_ident[2])
        // - calculate x : [ x ] (str.find('[') => pull substring between index '[' and ']'
      }
      else {
        // add integer var to stream
        ss << ".> " << temp;
      }

      $$->code = ss.str();
    }
  | CONTINUE
    {
      $$ = new nonTerm();
      $$->code = "continue";
    }
  | RETURN Expression
    {
      $$ = new nonTerm();
      stringstream ss;

      ss << $2->code << endl;
      ss << "ret " << $2->ret_name;
      
      $$->code = ss.str();
      $$->ret_name = $2->ret_name;
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
      $$ = new nonTerm();
      string returnName = makeTemp(); // OR statement result location
      
      stringstream ss;
      ss << $1->code << endl << $3->code << endl; // Add nested expression code to the stream
      ss << ". " << returnName << endl; // Add new return name to the output
      ss << "|| " << returnName << ", " << $1->ret_name << ", " << $3->ret_name; // Add the logical OR statement
      
      $$->code = ss.str();
      $$->ret_name = returnName;
    }
  | RelationAndExpr
    {
      $$ = new nonTerm();
      $$->code = $1->code; // BoolExpr == RelationAndExpr - pass values directly
      $$->ret_name = $1->ret_name;
    }
  ;
/* Relation_And_Expr */
RelationAndExpr: RelationAndExpr AND RelationExpr
    {
      $$ = new nonTerm();
      string returnName = makeTemp(); // && statement result location

      stringstream ss;
      ss << $1->code << endl << $3->code << endl; // Add nested expression code to the stream
      ss << ". " << returnName << endl; // Add new return name to the output
      ss << "&& " << returnName << ", " << $1->ret_name << ", " << $3->ret_name; // Add the logical AND statement
      
      $$->code = ss.str();
      $$->ret_name = returnName;
    }
  | RelationExpr
    {
      $$ = new nonTerm();
      $$->code = $1->code; // RelationAndExpr == RelationExpr - pass values directly
      $$->ret_name = $1->ret_name;
    }
  ;

/* Relation_Expr */
RelationExpr: Relations
    {
      $$ = new nonTerm();
      $$->code = $1->code;
      $$->ret_name = $1->ret_name;
    }
  | NOT Relations
    {
      $$ = new nonTerm();

      stringstream ss;
      ss << $2->code << endl;
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

      $$ = new nonTerm();
      string resultTemp = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << resultTemp << endl;
      ss << $2 << " " << resultTemp << ", " << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = resultTemp;
    }
  | TRUE
    {
      $$ = new nonTerm();
      $$->code = "1";
    }
  | FALSE
    {
      $$ = new nonTerm();
      $$->code = "0";
    }
  | L_PAREN BoolExpr R_PAREN
    {
      $$ = new nonTerm();
      $$->code = $2->code;
      $$->ret_name = $2->ret_name;
    }
  ;

/* Comp */
Comp: EQ {}
  | NEQ {}
  | LT {}
  | GT {}
  | LTE {}
  | GTE {}
  ;

/* Expression */
Expression: Expression ADD MultiplicativeExpr
    {
      $$ = new nonTerm();
      string addResult = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << addResult << endl;
      ss << "+ " << addResult << ", " << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = addResult;
    }
  | Expression SUB MultiplicativeExpr
    {
      $$ = new nonTerm();
      string subResult = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << subResult << endl;
      ss << "- " << subResult << ", " << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = subResult;
    }
  | MultiplicativeExpr
    {
      $$ = new nonTerm();
      $$->code = $1->code;
      $$->ret_name = $1->ret_name;
    }
  ;
ExpressionList: ExpressionList COMMA Expression
    {
      $$ = new nonTerm();
      stringstream scode, sret;

      scode << $1->code << endl << $3->code; // build blocks of expression code
      
      sret << $3->ret_name << "," << $3->ret_name; // append ret_name to list : ret_name1,ret_name2...
      
      $$->code = scode.str();
      $$->ret_name = sret.str();
    }
  | Expression
    {
      $$ = new nonTerm();
      $$->code = $1->code;
      $$->ret_name = $1->ret_name;
    }
  | %empty
    {
      $$ = new nonTerm();
    }
  ;

/* Multiplicative_Expr */
MultiplicativeExpr: MultiplicativeExpr MULT Term
    {
      $$ = new nonTerm();
      string multResult = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << multResult << endl;
      ss << "* " << multResult << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = multResult;
    }
  | MultiplicativeExpr DIV Term
    {
      $$ = new nonTerm();
      string divResult = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << divResult << endl;
      ss << "/ " << divResult << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = divResult;
    }
  | MultiplicativeExpr MOD Term
    {
      $$ = new nonTerm();
      string modResult = makeTemp();
      stringstream ss;

      ss << $1->code << endl << $3->code << endl;
      ss << ". " << modResult << endl;
      ss << "% " << modResult << $1->ret_name << ", " << $3->ret_name;

      $$->code = ss.str();
      $$->ret_name = modResult;
    }
  | Term
    {
      $$ = new nonTerm();
      
      if ($1->ret_name != "") {
        $$->code = $1->code;
        $$->ret_name = $1->ret_name;
      }
      else {
        string newTemp = makeTemp();
        stringstream ss;

        ss << ". " << newTemp << endl;
        ss << "= " << newTemp << ", " << $1->code;

        $$->code = ss.str();
        $$->ret_name = newTemp;
      }
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
      // fibinocci(k-1) + fibinocci(k-2)
      $$ = new nonTerm();
      string newTemp = makeTemp();
      stringstream ss, sret;

      ss << $3->code << endl; // add all expressions code to output
      // iterate through $3->ret_name to find all params : ret_name1,ret_name2
      string temp;
      for (unsigned i = 0; i < $3->ret_name.length(); ++i) {
        if ($3->ret_name[i] == ',') {
          sret << "param " << temp << endl;
          temp = "";
          continue;
        }
        temp.push_back($3->ret_name[i]);
      }

      if (temp.length() > 0) { // only add to code stream if at least 1 ret_name exists
        sret << "param " << temp << endl; // add last ret_name to output
        ss << sret.str(); // add ret_name stream to code stream
      }

      ss << ". " << newTemp << endl;
      ss << "call " << $1->code << ", " << newTemp;

      $$->code = ss.str();
      $$->ret_name = newTemp;
    }
  ;
TermInner: Var
    {
      $$ = new nonTerm();
      $$->code = $1->code;
    }
  | NUMBER
    {
      $$ = new nonTerm();
      $$->code = to_string($1);
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

bool continueCheck (const string &ref) {
  if (ref.find("continue") == string::npos) {
    return false;
  }
  return true;
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
