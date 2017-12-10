
%{
#include "parser.h"
#include "lex.h"
#include <math.h> 
#include <fstream>
#include <iostream> 
#include <string>
#include <vector>
using namespace std;
 int yyerror(yyscan_t scanner, string result, const char *s){  
    (void)scanner;
    std::cout << "yyerror : " << *s << " - " << s << std::endl;
    return 1;
  }
%}

%code requires{
#define YY_TYPEDEF_YY_SCANNER_T 
typedef void * yyscan_t;
#define YYERROR_VERBOSE 0
#define YYMAXDEPTH 65536*1024 
#include <math.h> 
#include <fstream>
#include <iostream> 
#include <string>
#include <vector>
}

%define api.pure full
%lex-param{ yyscan_t scanner }
%parse-param{ yyscan_t scanner } {std::string & result}

%union {
  std::string *  sval;
}

%token TOKEN_ID TOKEN_ERROR TOKEN_OB TOKEN_CB TOKEN_AND TOKEN_XOR TOKEN_OR TOKEN_NOT
%type <sval>  TOKEN_ID expression unary_expression binary_expression
%left BINARY_PRIO
%left UNARY_PRIO
%%

top:
expression {result = *$1;}
;
expression:
TOKEN_ID  {$$=$1; }
| TOKEN_OB expression TOKEN_CB  {$$=$2;}
| binary_expression  {$$=$1;}
| unary_expression  {$$=$1;}
;

unary_expression:
 TOKEN_NOT expression %prec UNARY_PRIO {result =  " (NOT " + *$2 + " ) " ; $$ = &result;}
;
binary_expression:
expression expression  %prec BINARY_PRIO {result = " ( " + *$1+ " AND " + *$2 + " ) "; $$ = &result;}
| expression TOKEN_AND expression %prec BINARY_PRIO {result = " ( " + *$1+ " AND " + *$3 + " ) "; $$ = &result;} 
| expression TOKEN_OR expression %prec BINARY_PRIO {result = " ( " + *$1 + " OR " + *$3 + " ) "; $$ = &result;} 
| expression TOKEN_XOR expression %prec BINARY_PRIO {result = " ( " + *$1 + " XOR " + *$3 + " ) "; $$ = &result;} 
;

%%
