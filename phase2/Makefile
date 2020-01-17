mini-l:
	bison -v -d --file-prefix=y mini_l.y
	flex mini_l.lex
	gcc -o parser y.tab.c lex.yy.c -lfl

clean: 
	-rm y.tab.c
	-rm y.tab.h
	-rm y.output
	-rm lex.yy.c
	-rm lexer
	-rm parser
