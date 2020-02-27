
make:
		bison -v -d --file-prefix=mini_l mini_l.y
		flex mini_l.lex
		g++ -o my_compiler mini_l.tab.c lex.yy.c -lfl


clean:
		rm -rf mini_l.output mini_l.tab.* my_compiler
		-rm input.txt
		-rm my_compiler
