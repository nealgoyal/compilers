## P-I
 - `flex mini_l.lex`
 - `gcc -o lexer lex.yy.c -lfl`
 - ` cat fibonacci.min | lexer `
## P-II 
 - `bison -v -d --file-prefix=y mini_l.y`
 - `flex mini_l.lex`
 - `gcc -o parser y.tab.c lex.yy.c -lfl`
 - ` cat fibonacci.min | parser `
## P-III 
 - ` mil_run mil_code.mil `
 - ` mil_run mil_code.mil < input.txt `
 - `mil_run`
 - ` cat fibonacci.min | my_compiler `
 - ```  echo 5 > input.txt  ```
   ` mil_run fibonacci.mil < input.txt `