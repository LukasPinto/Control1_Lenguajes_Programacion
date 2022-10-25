dfa_creator:	dfa.l dfa_token.y
	bison -d dfa_token.y
	flex dfa.l
	g++ -Wall -o $@ dfa_token.tab.c lex.yy.c -ll 
clean:
	rm *.yy.c dfa_creator dfa_token.tab.c dfa_token.tab.h 2>/dev/null
