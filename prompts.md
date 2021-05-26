## index
## Table of Contents
- [Lab 1](#lab-i)
  - [Task 1](#task-i1)
  - [Task 2](#task-i2)
  - [Task 3](#task-i3)
  - [Task 4](#task-i4)
- [Lab 2](#lab-ii)
    - [Task 1](#task-ii1)
    - [Task 2](#task-ii2)
    - [Task 3](#task-ii3)
    - [Task 4](#task-ii4)
    - [Task 5](#task-ii5)
- [Phase 1](#phase-i)
- [Phase 2](#phase-ii)
- [Phase 3](#phase-iii)

# Lab I
## using `flex`
### outline
1. Go over the first phase of the class project.
2. Complete an excercise to help you become familiar with flex.
3. Begin working on the first phase of the class project.
#### excercise with `flex`
```text
| -------- | -------- |
| Symbol in Language | Token Name |
| integer number (e.g., "0", "12", "1719") | NUMBER XXXX [where XXXX is the number itself] |
| + | PLUS |
| - | MINUS |
| * | MULT |
| / | DIV |
| ( | L_PAREN |
| ) | R_PAREN |
| = | EQUAL |
| -------- | -------- |
```
The calculator language itself is very simple. There is only one type of phrase in the language: "`Expression=`", where "`Expression`" is defined in the similar way as for the class project, except for the fact that there are no variables in the calculator language, only numbers. For example, all of the following are valid in the calculator language.
```jsunicoderegexp
21=
2+3*4=
(2+3)*4=
30/3/5=
-250/50=
(10+2)*-(3-5)=
40-20-5=
4*(1/1-3/3+10/5-21/7+45/9-121/11+26/13-45/15+34/17-38/19+63/21-1/1+2002/1001)=
```
Note, however, that lexical analysis only scans for valid tokens in the calculator language, not valid expressions. The parsing phase (phase 2, the next phase of the class project) is where sequences of tokens will be checked to ensure that they adhere to the specified language grammar. Thus, for this exercise which deals only with lexical analysis, even such phrases as `*/2=10++-(+ and ***101***())(-` can still be tokenized successfully.
#### Task I.1
Create a `flex` specification to recognize tokens in the calculator language. Print out an error message and exit if any unrecognized character is encountered in the input. Use flex to compile your specification into an executable lexical analyzer that reads text from standard-in and prints the identified tokens to the screen, one token per line. 
#### Task I.2
Enhance your `flex` specification so that input text can be optionally read from an input file, if one is specified on the command line when invoking the lexical analyzer. 
#### Task I.3
Enhance your `flex` specification so that in addition to printing out each encountered token, the lexical analyzer will also count the following. 
- The number of integers encountered
- The number of operators encountered: `+`, `-`, `*`, `/`
- The number of parentheses encountered: `(`, `)`
- The number of equal signs encountered 
The total counts should be printed to the screen after all input text has been tokenized. The counts need not be printed if an unrecognized character is encountered in the input (since the lexical analyzer should just terminate after issuing the error message). 
#### Task I.4
For a challenge, you may want to try extending the calculator language to allow for decimal numbers in addition to regular integers. Thus, the following numbers should be recognized by your lexical analyzer. 
```jsunicoderegexp
123
0.17
2.171
5.010
171.0023
```
For an even greater challenge, extend the calculator language to allow for scientific notation in the numbers. After the number, there can be an optional "e-phrase" consisting of either "`e`" or "`E`", followed by an optional `"+"` or `"-",` followed by one or more digits. For example, the following numbers in scientific notation would be recognized by your lexical analyzer. 
```jsunicoderegexp
2e7
2e+7
2e-7
2E+102
5E0
0.201e+17
```
# Lab II 
## Using `bison`
### outline 
- Go over the second phase of the class project (handed out)
- Complete an exercise to help you become familiar with `Bison`
- Begin working on the second phase of the class project 
#### Task II.1
Create a `Bison` specification to evaluate expressions in the calculator language. Print out an error message and exit if any unrecognized character is encountered in the input or if the input does not follow the calculator grammar. Use `Bison` to compile your specification into an executable parser that reads text from standard-in and prints the results to the screen. 
Use the following commands to compile your calculator project:
```shell
bison -v -d --file-prefix=y calc.y 
flex calc.lex
gcc -o calc y.tab.c lex.yy.c -lfl
```
#### Task II.2 
Task 2: Enhance your `Bison` specification so that input text can be optionally read from an input file, if one is specified on the command line when invoking the parser. 
#### Task II.3 
Enhance your `Bison` specification so that if the input expression is wrong (it does not follow the calculator grammar), it prints out where the error is and what token the parser was expecting. 
#### Task II.4 
Change `Bison` specification so that in addition to evaluate expressions, the parser will also count the following. 
- The number of integers encountered
- The number of operators encountered: `+`, `-`, `*`, `/`
- The number of parentheses encountered: `(`, `)`
- The number of equal signs encountered 
#### Task II.5
For a challenge, you may want to try extending the calculator language to allow for decimal numbers in addition to regular integers. Thus, the following numbers should be recognized by your parser. 
```jsunicoderegexp
.123
0.17
2.171
5.010
171.0023
```
For an even greater challenge, extend the calculator language to allow for scientific notation in the numbers. After the number, there can be an optional "e-phrase" consisting of either "`e`" or "`E`", followed by an optional `"+"` or `"-",` followed by one or more digits. For example, the following numbers in scientific notation would be recognized by your parser. 
```jsunicoderegexp
2e7
2e+7
2e-7
2E+102
5E0
0.201e+17
```
#### more on bison 
```text
| -------- | -------- |
| Symbol in Language | Token Name |
| integer number (e.g., "0", "12", "1719") | NUMBER XXXX [where XXXX is the number itself] |
| + | PLUS |
| - | MINUS |
| * | MULT |
| / | DIV |
| ( | L_PAREN |
| ) | R_PAREN |
| = | EQUAL |
| -------- | -------- |
```
# Project
### phase I
### detailed requirements
- Write the specification for a `flex` lexical analyzer for the MINI-L language. For this phase of the project, your lexical analyzer need only output the list of tokens identified from an inputted MINI-L program.
-   Example: write the `flex` specification in a file named `mini_l.lex`.
- Run `flex` to generate the lexical analyzer for MINI-L using your specification.
  - Example: execute the command `flex mini_l.lex`. This will create a file called `lex.yy.c`in the current directory.
- Compile your MINI-L lexical analyzer. This will require the `-lfl` flag for `gcc`.
  - Example: compile your lexical analyzer into the executable lexer with the following command: `gcc -o lexer lex.yy.c -lfl`. The program lexer should now be able to convert an inputted MINI-L program into the corresponding list of tokens. 

#### Example Usage
 Suppose your lexical analyzer is in the executable named `lexer`.
 Then for the MINI-L program `fibonacci.min`, your lexical analyzer should be invoked as follows:
```shell
cat fibonacci.min | lexer
```
 The list of tokens outputted by your lexical analyzer should then appear as they do here.
 The tokens can be printed to the screen (standard out). 
# Project
### phase II
## Overview
In the previous phase of the class project, you used the `flex` tool to create a lexical analyzer for the "MINI-L" programming language that reads in a MINI-L program (from a text file) and identifies the sequence of lexical tokens in the text file. In this phase of the class project, you will create a parser using the `bison` tool that will check to see whether the identified sequence of tokens adheres to the specified grammar of MINI-L. The output of your parser will be the list of productions used during the parsing process. If any syntax errors are encountered during parsing, your parser should emit appropriate error messages. Additionally, you will be required to submit the grammar for MINI-L that you will need to write before you can use `bison`. 
### Bison
 `Bison` is a tool for generating parsers. Given a specified context-free grammar for a language, `bison` will automatically produce an `LALR(1)` bottom-up parser for that language. The parser will ensure that a given sequence of tokens are ordered in such a way that they adhere to the specified grammar of the language. If the tokens fail to parse properly, then appropriate syntax error messages are outputted.
`Shift/Reduce` and `Reduce/Reduce` conflicts:
When ambiguities exist in the specified grammar, `bison` will emit one or more conflicts when it is run. These conflicts do not prevent `bison` from generating the parser from your specification, but they may unexpectedly affect how your parser behaves. A shift/reduce conflict occurs when the parser may perform either a shift or a reduce. A reduce/reduce conflict occurs when there are two or more production rules that apply to the same sequence of input tokens. In general, reduce/reduce conflicts indicate errors in the grammar (or at least serious ambiguities) and should be eliminated by modifying the grammar specification as needed. Shift/reduce conflicts, on the other hand, are more difficult to completely eliminate, especially when using the special "`error`" token provided by `bison` to handle errors. Therefore, you should try to eliminate as many shift/reduce conflicts as you can, but some shift/reduce conflicts may remain as long as they do not adversely affect the behavior of your parser. You can run `bison` with the `-v` option to generate an output file containing detailed information about each conflict.
In our department, `bison` is installed and can be used on lab machines and the "bolt" server. 
### detailed requirements
- First, you will need to write the grammar for the MINI-L language, based on the specification for MINI-L that we have provided for you. You must submit this grammar along with the other files required for this phase of the class project!
- Create the `bison` parser specification file using the MINI-L grammar. Ensure that you specify helpful syntax error messages to be outputted by the parser in the event of any syntax errors.
   - Example: write the `bison` specification in a file named `mini_l.y`.
- Run bison to generate the parser for MINI-L using your specification. The `-d` flag is necessary to create a `.h` file that will link your flex lexical analyzer and your `bison` parser. The `-v` flag is helpful for creating an output file that can be used to analyze any conflicts in `bison`. The `--file-prefix` option can be used to change the prefix of the file names outputted by `bison`.
  - Example: execute the command `bison -v -d --file-prefix=y mini_l.y`. This will create the parser in a file called `y.tab.c`, the necessary `.h` file called `y.tab.h`, and the informative output file called `y.output`.
- Ensure that your MINI-L lexical analyzer from the first phase of the class project has been constructed.
  - Example: if your lexical analyzer specification is in a file called `mini_l.lex`, then use it with flex as follows: `flex mini_l.lex`. This will create the lexical analyzer in a file called `lex.yy.c`.
- Compile everything together into a single executable.
  - Example: compile your parser into the executable parser with the following command: `gcc -o parser y.tab.c lex.yy.c -lfl`. The program parser should now be available for use. 
### Example Usage 
 Suppose your parser is in the executable named parser. Then for the MINI-L program `fibonacci.min`, your parser should be invoked as follows: 
```shell
cat fibonacci.min | parser
```
The list of productions taken by your parser during parsing should then be printed to the screen. As one example, the output might look like this (you do not need to number each production or label each non-terminal with the corresponding production number). However, your output may be different due to different productions in your specification. The most important thing is that your parser should not output any syntax errors for syntactically correct programs, and your parser should output helpful syntax error messages (for at least the first syntax error) whenever syntax errors do exist in the inputted MINI-L program. 
# Project
### phase III 
## Overview 
 - In the previous phases of the class project, you used the flex and bison tools to create a lexical analyzer and a parser for the "MINI-L" programming language. In this phase of the class project, you will take a syntactically-correct MINI-L program (a program that can be parsed without any syntax errors), verify that it has no semantic errors, and then generate its corresponding intermediate code. The generated code can then be executed (using a tool we will provide) to run the compiled MINI-L program.
- You should perform one-pass code generation and directly output the generated code. There is no need to build/traverse a syntax tree. However, you will need to maintain a symbol table during code generation.
- The intermediate code you will generate is called "MIL" code. We will provide you with an interpreter called mil_run that can be used to execute the MIL code.
- The output of your code generator will be a file containing the generated MIL code. If any semantic errors are encountered by the code generator, then appropriate error messages should be emitted and no other output should be produced. 
### The `mil_run` MIL interpreter 
 We are providing an interpreter for MIL intermediate code (`mil_run`), which can be used to execute the MIL code generated by your code generator. The `mil_run` interpreter requires an input file to be specified that contains the MIL code that should be executed. For example, if you have MIL code contained in a file called `mil_code.mil`, then you can execute the MIL code with the following command:
```shell
mil_run mil_code.mil
```
If the MIL code itself requires some input data, this input data can be written to a file and then redirected to the executing MIL code. For example, if the input values are written to a text file called `input.txt`, then it can be passed to the executing MIL program as follows:
```shell
mil_run mil_code.mil < input.txt
```
The `mil_run` interpreter will generate a file called milRun.stat that contains some statistics about the MIL code that was just executed. You may ignore this file.
`mil_run` makes the following assumptions.
  1. Each line in the MIL file contains at most one MIL instruction
  2. Each line is at most 254 characters long
  3. All variables are defined before they are used 
You must ensure that your generated MIL code meets the above three requirements.

mil_run is a linux executable and can be run on bolt. 
### Detailed Requirements 
1.  You will need to modify your `bison` specification file from the previous phase of the class project so that it no longer outputs the list of productions taken during parsing.
2. Implement the code generator. This will most likely require some enhancements to your `bison` specification file. You may also want to create additional implementation files. The requirements for your implementation are as follows.
 a. You do not need to do anything special to handle lexical or syntax errors in this phase of the class project. If any lexical or syntax errors are encountered, your compiler should emit appropriate error message(s) and terminate the same way as was done in previous phases.
 b. You need to check for semantic errors in the inputted MINI-L program. During code generation, if any semantic errors are encountered, then appropriate error messages should be emitted and no other output should be produced (i.e., no code should be generated).
 c. If no semantic errors are encountered, then the appropriate MIL intermediate code should be generated and written to stdout.
 d. When generating the intermediate code, be careful that you do not accidentally create a temporary variable with the same name as one of the variables specified in the original MINI-L program. 
3. Compile everything together into a single executable. The particular commands needed to compile your code generator will depend on the implementation files you create.
4. Use the `mil_run` MIL interpreter to test your implementation. For each program written in MINI-L source code, compile it down to MIL code using your implementation. Then invoke the MIL code using `mil_run` to verify that the compiled program behaves as expected.
#### Example usage 
Suppose your code generator is in the executable named `my_compiler`. Then for the MINI-L program `fibonacci.min` (which is syntactically and semantically correct), your code generator should be invoked as follows: 
```shell
cat fibonacci.min | my_compiler 
```
The file `fibonacci.mil` should then be created and should contain the generated MIL code (it is okay if your generated code looks slightly different, but it should have the same behavior when executed). Next, you can test your generated code using the `mil_run` MIL interpreter to ensure that it behaves as expected. Suppose we want to run the compiled `fibonacci` program with input "`5`": 
```shell
echo 5 > input.txt
mil_run fibonacci.mil < input.txt 
```
When the compiled `fibonacci` program is executed with the above input "`5`", then the fifth fibonacci number is printed to the screen: 
```jsunicoderegexp
8 
```

### A Note About Runtime Errors
There are some errors that cannot always be captured at compile-time and may only happen at run-time. These errors include those such as array index out-of-bounds errors, and division by zero. Your implementation need not handle these errors. You may assume that when we grade your programs, we will not use any MINI-L programs that would lead to run-time errors. Note also that the `mil_run` MIL interpreter we are providing may have unexpected behavior if you try to run it on a program that can lead to run-time problems (such as an out-of-bounds array access). Thus, when you are testing your implementation, try to make sure your MINI-L programs will not cause any run-time errors. 