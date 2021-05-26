# Compilers
This course covers the fundamentals of compiler design, including lexical analysis, parsing, semantic analysis, compile-time memory organization, run-time memory organization, code generation, and compiler portability issues. Laboratory work involves a project and exercises covering various aspects of compilers. 

## Table of Contents
- [Phase 1](#phase-1)
- [Phase 2](#phase-2)
- [Phase 3](#phase-3)
- [Dependencies](#dependencies)

## Phase 1
For this first part of the class project, you will use the flex tool to generate a lexical analyzer for a high-level source code language called "MINI-L". The lexical analyzer should take as input a MINI-L program, parse it, and output the sequence of lexical tokens associated with the program.

**Full Instructions:**
https://www.cs.ucr.edu/~cxu009/teaching/CS152-winter20/webpages1/phase1_lexer.html

**How To Run:**
```
> cd compilers
> cd phase1
> make clean
> make
> cat fibonacci.min | lexer
```

## Phase 2
In the previous phase of the class project, you used the flex tool to create a lexical analyzer for the "MINI-L" programming language that reads in a MINI-L program (from a text file) and identifies the sequence of lexical tokens in the text file. In this phase of the class project, you will create a parser using the bison tool that will check to see whether the identified sequence of tokens adheres to the specified grammar of MINI-L. The output of your parser will be the list of productions used during the parsing process. If any syntax errors are encountered during parsing, your parser should emit appropriate error messages. Additionally, you will be required to submit the grammar for MINI-L that you will need to write before you can use bison.

**Full Instructions:**
https://www.cs.ucr.edu/~cxu009/teaching/CS152-winter20/webpages2/phase2_parser.html


**How To Run:**
```
> cd compilers
> cd phase2
> make clean
> make
> cat fibonacci.min | parser
```

## Phase 3
In the previous phases of the class project, you used the flex and bison tools to create a lexical analyzer and a parser for the "MINI-L" programming language. In this phase of the class project, you will take a syntactically-correct MINI-L program (a program that can be parsed without any syntax errors), verify that it has no semantic errors, and then generate its corresponding intermediate code. The generated code can then be executed (using a tool we will provide) to run the compiled MINI-L program.

**Full Instructions:**
https://www.cs.ucr.edu/~cxu009/teaching/CS152-winter20/webpages3/phase3_code_generator.html

**How To Run:**
```
> cd compilers
> cd phase3
> make clean
> make
> echo 5 > input.txt
> cat tests/fibonacci.min | my_compiler > fibonacci.mil
> mil_run fibonacci.mil < input.txt
```
Output Expected: 
8

## Dependencies
Install [`flex`](https://github.com/westes/flex) and [`bison`](https://www.gnu.org/software/bison/)
