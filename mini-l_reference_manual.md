## Contents
1. [Introduction](#introduction)
2. [Lexical Rules](#lexical-rules)
    * [Whitespace](#whitespace)
    * [Comments](#comments)
    * [Operators](#operators)
    * [Identifiers](#identifiers)
    * [Semicolon](#semicolon)
    * [Reserved Words](#reserved-words)
3. [Syntax](#syntax)
    * [Function Syntax](#function-syntax)
    * [Control Structures](#control-structures)
    * [Variable Declaration Syntax](#variable-declaration-syntax)
4. [Data Types and Semantics](#data-types)
    * [Numbers](#numbers)
    * [Arrays](#arrays)
    * [Tables](#tables)
5. [Summary](#summary)

---

# Introduction
MINI-L is a context-free grammar high-level language.
# Lexical rules
Lexical rules of MINI-L are similar to the lexical rules of Ada? Idk.

### Whitespace
Whitespace in MINI-L programs can occur due to regular blank spaces, tabs, or newlines. Whitespace separates elements of the source program and are not otherwised considered, except when within a string literal. 

### Comments 
MINI-L comments use `##` which extends the comment to the end of the current line.
`C`-style multi-line comments should be recognized as an error resulting in the following message:
> C comments are not allowed in MINI-L.

### Operators
For **p** = Precedence:
0= ♬
1= ★
2= ✿
3= ❖
4= ☆
5= ☯
6= ❤
7= ☂
8= ☁
9= ☼

| Operator |                  Description                  | Associativity |      P     |
|:--------:|:---------------------------------------------:|:-------------:|:----------:|
|       () |                  Parentheses                  | Left-->Right  | ♬          |
|       [] |               Array Subscripting              | Left-->Right  | ★          |
|        - |                  Unary minus                  | Right-->Left  | ✿          |
|        * |                 Multiplication                | Left-->Right  | ❖          |
|        / |                    Division                   | Left-->Right  | ❖          |
|        % |              Remainder / Modulus              | Left-->Right  | ❖          |
|        + |                    Addition                   | Left-->Right  | ☆          |
|        - |                  Subtraction                  | Left-->Right  | ☆          |
|        < |       Relational Operator <br>less than       | Left-->Right  | ☯          |
|       <= |   Relational Operator <br>less than or equal  | Left-->Right  | ☯          |
|        > |      Relational Operator <br>greater than     | Left-->Right  | ☯          |
|       >= | Relational Operator <br>greater than or equal | Left-->Right  | ☯          |
|       == |      Relational Operator <br>is equal to      | Left-->Right  | ☯          |
|       <> |    Relational Operator<br> is not equal to    | Left-->Right  | ☯          |
|      not |                  Logical NOT                  | Right-->Left  | ❤          |
|      and |                  Logical AND                  | Left-->Right  | ☂          |
|       or |                   Logical OR                  | Left-->Right  | ☁          |
|       := | Assignment<br>left operand must be a variable | Right-->Left  | ☼          |

Other operators should result in the error message (including filename/line number where compiler stops):
> That operator is not valid in MINI-L.
An example of operators that are not valid:
`&`       `&=`      `|`       `|=`
`^`       `*=`      `^=`      `<-`
`<<`      `&^`      `/=`      `:`
### Identifiers
A valid identifier must begin with a letter (from `a`->`z` or `A`->`Z`), may be followed by additional letters, digits, or underscores, and cannot end in an underscore. 
Maximum length of a variable name in MINI-L is 12 and this limit should be enforced.
* Management error identifier with less than 8 characters long and ends with ‘_’.
* Management error identifier with more than 8 characters.
### Semicolon
Semi-colons exist but are mostly optional and rare in MINI-L compared with other languages. There are a couple specific lexical rules. 

### Reserved Words
MINI-L is case sensitive. All reserved words are expressed in lower case. 
MINI-L uses the following reserved words, which are from `C`? A `MINI-L` compiler should support the following reserved words:
`function`      `beginloop`       `continue`
`endloop`       `endbody`          `endif`
`endlocals`       `beginparams`     `write`
... and so on.
The rest of (some lang) reserved words, should they occur, will result in the following error message (alongside filename/line number where compiler stops):
`begin_loop`      `default`            `type`
`return`          `for`                 `go_to`
> C keywords not legal in MINI-L.
# Syntax
Syntax of MINI-L is based on `C` I believe.
### Function syntax
MINI-L functional syntax is a small subset of
 syntax.
A function definition consists of a reserved word `function` followed by an identifier that specifies the function name.
Functions appearing in another file or later in the same file, can be called if they are public using the name syntax. There is no calling of private functions in another file or later in the same file.
### Control Structures
MINI-L supports `if` statements (with an optional `else` clause) and a lot of other constructs such as:
 * `while` and `do-while` loops
 * `continue` statement
 * `if-then-else` statements
 * read/write statements
Then-parts, else-parts, and loop bodies are required to be enclosed by statements `beginloop` and `endloop`.
The exception to this restriction on the syntax is that.
No classes but it does methods on structures. Since methods on structures turns out to be an alternate syntax for just declaring functions whose first parameter is a struct, MINI-L does not bother with the methods. 
### Variable Declaration Syntax
All variables must be declared and defined before they are used. Variable declarations such as:
```
n : integer;
```
This can occur at one level, the local scope. There are no variable initializers.
* Error Handling for the use of variables that have not been declared at the beginning of the program.
* Error handling for the declaration of the same variable mutliple times.
# Data Types and Semantics
### Numbers
MINI-L has a single size of `integer` numeric type which can have negative values. 
### Arrays
Arrays are one-dimensional sequences, indexed using integers.
```
a : array[1000] of integer;
```
* Error Handling in the use of an array variable as a normal integer variable.
* Error Handling negative array size.
* Error management use of an array index greater than the maximum size declared (in the case where the index is a number).

# Summary
In conclusion, this is a toy language designed for an introductory upper-division compiler class. Even though it's very minimal in it's implementation and through our application, it provides a convenient notation for all the tasks and project phases we as students go through in CS152.