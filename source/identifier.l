%{
#include <string>
#include <iostream>
#include <unordered_map>

// Define token types
enum TokenType {
    END_OF_FILE = 0,
    CONSTANT = 1,
    IDENTIFIER = 2,
    INT = 3,
    DOUBLE = 4,
    LONG = 5,
    FLOAT = 6,
    CHAR = 7,
    BOOL = 8,
    STRING = 9,
    IF = 10,
    ELSE = 11,
    WHILE = 12,
    FOR = 13,
    DO = 14,
    BREAK = 15,
    CONTINUE = 16,
    RETURN = 17,
    READ = 18,
    WRITE = 19,
    PLUS = 20,
    MINUS = 21,
    MULTIPLY = 22,
    DIVIDE = 23,
    MODULO = 24,
    EXPONENT = 25,
    BITWISE_AND = 26,
    BITWISE_OR = 27,
    BITWISE_XOR = 28,
    BITWISE_NOT = 29,
    LOGICAL_AND = 30,
    LOGICAL_OR = 31,
    LESS = 32,
    LESS_EQUAL = 33,
    GREATER = 34,
    GREATER_EQUAL = 35,
    NOT_EQUAL = 36,
    EQUAL_EQUAL = 37,
    ASSIGN = 38,
    LEFT_PAREN = 39,
    RIGHT_PAREN = 40,
    LEFT_BRACE = 41,
    RIGHT_BRACE = 42,
    LEFT_BRACKET = 43,
    RIGHT_BRACKET = 44,
    COMMA = 45,
    SEMICOLON = 46,
    COLON = 47,
    DOT = 48
};

// Function to print the token
void print_token(int type, const char* lexeme = nullptr) {
    if (type == IDENTIFIER || type == CONSTANT) {
        std::cout << "( " << type << " , " << lexeme << " )" << std::endl;
    } else {
        std::cout << "( " << type << " , - )" << std::endl;
    }
}

std::unordered_map<std::string, int> keywords = {
    {"int", INT},
    {"double", DOUBLE},
    {"long", LONG},
    {"float", FLOAT},
    {"char", CHAR},
    {"bool", BOOL},
    {"string", STRING},
    {"if", IF},
    {"else", ELSE},
    {"while", WHILE},
    {"for", FOR},
    {"do", DO},
    {"break", BREAK},
    {"continue", CONTINUE},
    {"return", RETURN},
    {"read", READ},
    {"write", WRITE}
};

%}

digit       [0-9]
letter      [a-zA-Z]
identifier  {letter}({letter}|{digit})*
number      {digit}+
whitespace  [ \t\r\n]
char  \'(\\.|[^\\'])?\'
string \"(\\.|[^\\"])*\"

%%

{whitespace}    {}

"/*"            { 
					int c;
					while((c = yyinput()) != 0) {
						if(c == '*') {
							if((c = yyinput()) == '/')
								break;
							unput(c);
						}
					}
                }

"//"            { 
					int c;
					while((c = yyinput()) != 0 && c != '\n');
                }

{identifier}    { 
					auto it = keywords.find(yytext);
					if(it != keywords.end()) {
						print_token(it->second);
					} else {
						print_token(IDENTIFIER, yytext);
					}
                }

{number}        { 
                  print_token(CONSTANT, yytext);
                }

{char}    		{ 
                  print_token(CONSTANT, yytext);
                }

{string}  		{ 
                  print_token(CONSTANT, yytext);
                }

"+"             { print_token(PLUS); }
"-"             { print_token(MINUS); }
"*"             { print_token(MULTIPLY); }
"/"             { print_token(DIVIDE); }
"%"             { print_token(MODULO); }
"^"             { print_token(EXPONENT); }

"&"             { print_token(BITWISE_AND); }
"|"             { print_token(BITWISE_OR); }
"~"             { print_token(BITWISE_NOT); }

"&&"            { print_token(LOGICAL_AND); }
"||"            { print_token(LOGICAL_OR); }

"<"             { print_token(LESS); }
"<="            { print_token(LESS_EQUAL); }
">"             { print_token(GREATER); }
">="            { print_token(GREATER_EQUAL); }
"=="            { print_token(EQUAL_EQUAL); }
"!="            { print_token(NOT_EQUAL); }
"="             { print_token(ASSIGN); }

"("             { print_token(LEFT_PAREN); }
")"             { print_token(RIGHT_PAREN); }
"{"             { print_token(LEFT_BRACE); }
"}"             { print_token(RIGHT_BRACE); }
"["             { print_token(LEFT_BRACKET); }
"]"             { print_token(RIGHT_BRACKET); }
","             { print_token(COMMA); }
";"             { print_token(SEMICOLON); }
":"             { print_token(COLON); }
"."             { print_token(DOT); }

.               { std::cerr << "Error: unexpected character '" << yytext << "'" << std::endl; }

%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " input_file" << std::endl;
        return 1;
    }

    yyin = fopen(argv[1], "r");
    
    if(yyin == NULL) {
        std::cerr << "Error: cannot open file \"" << argv[1] << "\"" << std::endl;
        return 1;
    }

    yylex();

    fclose(yyin);
    return 0;
}