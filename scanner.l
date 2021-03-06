

%{
/* A template scanner file to build "scanner.c". */
#include <stdio.h>
#include <stdlib.h>


#define NUMBER 200
#define WORD   201

%}

%option 8bit outfile="scanner.c" prefix="test"
%option nounput nomain nodefault noyywrap
%option warn 


%%

[[:space:]]+   { }
[[:digit:]]+   { printf("NUMBER "); fflush(stdout);}
[[:alpha:]]+   { printf("WORD "); fflush(stdout);}
.              {
    fprintf(stderr,"*** Error: Unrecognized character '%c' while scanning.\n",
         yytext[0]);
    yyterminate();
    }

<<EOF>>  { printf("<<EOF>>\n"); yyterminate();}

%%


#define INPUT_STRING_1  "1234 foo bar"
#define INPUT_STRING_2  "1234 foo bar *@&@&###@^$#&#*"

int main(void);

int
main ()
{
    char * buf;
    int len;
    YY_BUFFER_STATE state;


    /* Scan a good string. */
    printf("Testing: yy_scan_string(%s): ",INPUT_STRING_1); fflush(stdout);
    state = yy_scan_string ( INPUT_STRING_1 );
    yylex();
    yy_delete_buffer(state);

    /* Scan only the first 12 chars of a string. */
    printf("Testing: yy_scan_bytes(%s): ",INPUT_STRING_2); fflush(stdout);
    state = yy_scan_bytes  ( INPUT_STRING_2, 12 );
    yylex();
    yy_delete_buffer(state);

    /* Scan directly from a buffer.
       We make a copy, since the buffer will be modified by flex.*/
    printf("Testing: yy_scan_buffer(%s): ",INPUT_STRING_1); fflush(stdout);
    len = strlen(INPUT_STRING_1) + 2;
    buf = (char*)malloc( len );
    strcpy( buf, INPUT_STRING_1);
    buf[ len -2 ]  = 0; /* Flex requires two NUL bytes at end of buffer. */
    buf[ len -1 ] =0;

    state = yy_scan_buffer( buf, len );
    yylex();
    yy_delete_buffer(state);
    
    printf("TEST RETURNING OK.\n");
    return 0;
}
