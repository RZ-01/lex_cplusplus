
%%

.|\n	{	
				printf("%c", *yytext); 
			}

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
