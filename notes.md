## Avoid These Common Bugs in Your Homeworks!
1) yytext or yyinput were not declared global
2) main() does not have its required argc, argv parameters!
3) main() does not call yylex() in a loop or check its return value
4) getc() EOF handling is missing or wrong! check EVERY all to getc() for EOF!
5) opened files not (all) closed! file handle leak!
6) end-of-comment code doesn't check for */
7) yylex() is not doing the file reading
8) yylex() does not skip multiple spaces, mishandles spaces at the front of input, or requires certain spaces in order to function OK
9) extra or bogus output not in assignment spec
10) = instead of == 
--- 
## Comparison of REGEX
| lexical category | BASIC | C | MINI-L |
|-|-|-|-|
| operators | `char`s themselves | * RegEx operators marked with `"` and `"` or `\` to indicate actual `char` not a RegExp operator.<br>* `=` needs to be determined by lexical analyzer (scanning phase) whether it is an assignment or `==` |  |
| reserved words | Disambiguating rule as needed for reserved words matched by RegEx for identifiers |  |  |
| identifiers | * no `_`<br>* `$` at ends of some identifiers<br>* `!` and `?` are significant letters<br>*case insensitive | `[a-zA-Z_][a-zA-Z0-9_]*` | begins with letter, may be followed by additional letters, digits, or underscores, and cannot end in an underscore. |
| numbers | * `int`<br>* `real`s<br>  * starting with `[0-9]+` | `0x[0-9a-fA-F]+ etc.` |  |
| comments | REM.* |  | `##` and extends to the end of the current line. |
| strings | * almost `".*"`<br>* no escapes | escaped quotes |  |
<!-- add more here below is how many columns there are-->
|  |  |  |  | 
---
### sscanf() example
```C
#include <stdio.h>
#include <stdlib.h>
int main()
{
   double d;
   char *yytext = "2.71";
   sscanf(yytext, "%lg", &d);
   printf("%lg\n", d);
}
```
- sscanf'ing into a double calls for a %lg. 
---
### Lex extended regular ExpressionList
| `c` | normal characters mean themselves |
| `\c` | backslash escapes remove the meaning from most operator characters.<br>Inside character sets and quotes, backslash performs C-style escapes. |
| `"s"` | Double quotes mean to match the C string given as itself.<br>This is particularly useful for multi-byte operators and may be more readable than using backslash multiple times. |
| `[s]` | This character set operator matches any one character among those in `s`. |
| `[^s]` | A negated-set matches any one character not among those in `s`. |
| `.` | The dot operator matches any one character except newline: `[^\n]` |
| `r*` | match `r` `0` or more times. |
| `r+` | match `r` `1` or more times. |
| `r?` | match `r` `0` or `1` time. |
| `r{m,n}`| match `r` between `m` and `n` times. |
| `r1r2` | concatenation.<br>match `r1` followed by `r2` |
| `r1|r2` | alternation.<br>match `r1` or `r2` |
| `(r)` | parentheses specify precedence but do not match anything 
| `r1/r2` | lookahead.<br>match `r1` when `r2` follows, without consuming `r2` |
| `^r` | match `r` only when it occurs at the beginning of a line |
| `r$` | match `r` only when it occurs at the end of a line |
## token example
Besides the token's category, the rest of the compiler may need several pieces of information about a token in order to perform semantic analysis, code generation, and error handling. These are stored in an object instance of class Token, or in C, a struct. The fields are generally something like follows.
The union literal will hold computed values of integers, real numbers, and strings. 
```C
struct token {
   int category;
   char *text;
   int linenumber;
   int column;
   char *filename;
   union literal value;
}
```
---
## MINI-L

* A comment is introduced by "##" and extends to the end of the current line.
* MINI-L is case sensitive. All reserved words are expressed in lower case.
* A valid identifier must begin with a letter, may be followed by additional letters, digits, or underscores, and cannot end in an underscore.
* Whitespace in MINI-L programs can occur due to regular blank spaces, tabs, or newlines. 

| Precedence | Operator | Description                  | Associativity |
|------------|----------|------------------------------|---------------|
|      0     | ()       | Function calls               | Left-to-right |
|      1     | []       | Array subscripting           | Left-to-right |
|      2     | -        | Unary minus                  | Right-to-left |
|      3     | *        | Multiplication               | Left-to-right |
|      3     | /        | Division                     |               |
|      3     | %        |  Remainder                   |               |
|      4     | +        | Addition                     |               |
|      4     | -        | Subtraction                  |               |
|      5     | <        | For relational operators  <  |               |
|      5     | <=       | For relational operators <=  |               |
|      5     | >        | For relational operators >   |               |
|      5     | >=       | For relational operators >=  |               |
|      5     | ==       | For relational operator ==   |               |
|      5     | <>       | For relational operator !=   |               |
|      6     | not      | Logical not                  | Right-to-left |
|      7     | and      | Logical and                  | Left-to-right |
|      8     | or       | Logical or                   |               |
|      9     | :=       | Assignment                   | Right-to-left |