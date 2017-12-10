%{
#include <string>
#include "parser.h"

%}
%option outfile="lex.cpp" header-file="lex.h"
%option noyywrap never-interactive
%option reentrant
%option bison-bridge

%top{
/* This code goes at the "top" of the generated file. */
#include <stdint.h>
}

id        ([a-zA-Z][a-zA-Z0-9]*)+
white     [ \t\r]
newline   [\n]

%%
{id}                    {    
    yylval->sval = new std::string(yytext);
    return TOKEN_ID;
}
"(" {return TOKEN_OB;}
")" {return TOKEN_CB;}
"*" {return TOKEN_AND;}
"^" {return TOKEN_XOR;}
"+" {return TOKEN_OR;}
"!" {return TOKEN_NOT;}

{white};  // ignore white spaces
{newline};
. {
return TOKEN_ERROR;
}

%%

usage : 
void parse(std::string& function) {
  string result = "";
  yyscan_t scanner;
  yylex_init_extra(NULL, &scanner);
  YY_BUFFER_STATE state = yy_scan_string(function.c_str() , scanner);
  yyparse(scanner,result);
  yy_delete_buffer(state, scanner);
  yylex_destroy(scanner);
  function = " " + result + " ";  
}
