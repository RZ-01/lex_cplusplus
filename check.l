%{
	int count=0;
%}

%%

int|if|then|else|while	{
													 count = count + 1;
													 printf("word_%d keyword: %s\n", count, yytext);
												}

[A-Za-z]([A-Za-z]|[0-9])*	{
														count = count + 1;
														printf("word_%d identifier: %s\n", count, yytext);
													}

[0-9]*	{
					count = count + 1;
					printf("word_%d constant: %s\n", count, yytext);
				}

"+"|"-"|"*"|"/"|"="|"=="|"!="|"<"|"<="|">"|">="	{
											count = count + 1;
											printf("word_%d operator: %s\n", count, yytext);
										}

","|";"|"{"|"}"|"("|")" {
													count = count + 1;
													printf("word_%d delimiter: %s\n", count, yytext);
												}

"\x20"|"\x09"|"\x0d"|"\x0a"

.  { printf("error: %c\n", *yytext);}

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
