%{
	int count=0;
%}

%%

[A-Za-z]([A-Za-z]|[0-9])*	{
														count = count + 1;
														printf("identifier_%d: %s\n", count, yytext);
													}

.|\n

%%

int yywrap()
{
	return 1;
}

int main() 
{
	yyin = fopen("input.txt", "r");
	
	if(yyin == NULL)
	{
		printf("error: no file input.txt\n");
		return 0;
	}

	yylex();

	fclose(yyin);
	return 0;
}
