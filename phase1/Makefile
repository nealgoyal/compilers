# compiler: foo.o bar.o baz.o
# 	gcc -o compiler foo.o bar.o baz.o

mini-l:
	flex mini_l.lex
	gcc -o lexer lex.yy.c -lfl

clean: 
	-rm lex.yy.c
	-rm lexer
