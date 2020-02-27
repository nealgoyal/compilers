mini-l:
	mil_run mil_code.mil
	mil_run mil_code.mil < input.txt

clean:
	-rm input.txt
	-rm my_compiler


make:
		bison -v -d --file-prefix=mini_l mini_l.y
		flex mini_l.lex
		g++ -o parser mini_l.tab.c lex.yy.c -lfl


clean:
		rm -rf mini_l.output mini_l.tab.* parser
