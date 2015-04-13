alpha [a-zA-Z]
digit [0-9]

%%
[ \t]		;
[ \n]   { yylineno = yylineno + 1;}
"int"	return INT;
"unsigned int"	return UINT;
"case"	return CASE;
"break"	return BREAK;
"void" return VOID;
"while"	return WHILE;
"switch"	return SWITCH;
"default" return DEFAULT;
"if"	return IF;
"else"	return ELSE;
^"#include ".+ ;
{digit}+       return NUM;
{alpha}({alpha}|{digit})* return ID;
"="     return ASGN;
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
">"	return GT;
"<"	return LT;
"||" 	return LOR;
"&&"  	return LAND;
"|" 	return BOR;
"&"	return BAND;
"^"	return BXOR;
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
.       return yytext[0];
%%
