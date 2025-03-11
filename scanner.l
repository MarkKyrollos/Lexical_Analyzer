
%{
#include <stdio.h>
#include <stdlib.h>

int line_num = 1;
int char_pos = 1;

%}

%x COMMENT


DIGIT      [0-9]

LETTER   [a-zA-Z]

ID        {LETTER}({LETTER}|{DIGIT})*(("@"|"$"|"_"){DIGIT}+)?


NUM    ({DIGIT}+(\.{DIGIT}+)?((E|e)(\+|-)?{DIGIT}+)?)|(\.{DIGIT}+((E|e)(\+|-)?{DIGIT}+)?)


%%

[ \t]+                 {   char_pos+=yyleng;}

\n                { line_num++;  char_pos=1;}

{ID}                  {
                              printf( "Token: ID, Lexeme: %s\n",  yytext);
							  
                         char_pos+=yyleng;
                    }


{NUM}                      {

                              printf("Token: NUM, Lexeme: %s\n"  ,  yytext);

                              char_pos+=yyleng;
                          }


"/*"                       {BEGIN(COMMENT);}



<COMMENT>"*/"              {BEGIN(INITIAL);}


<COMMENT>\n                {line_num++;char_pos=1;}
<COMMENT>.                 		{/* Consume and ignore comment characters */}
<COMMENT><<EOF>>           {
                              printf("Error: There is an unclosed comment at line %d\n",line_num);
                              exit(1);
                          }

#[^ \t\n]*                 {
                              printf("Error: there's an invalid identifier at line %d, position %d: %s\n",
                                     line_num,char_pos,yytext);
                              char_pos+=yyleng;
                          }

{DIGIT}+[Ee](\+|-)?[^0-9 \t\n]+  {
                              
							  printf("Error: there is an invalid number at line %d, position %d: %s\n",
                                     
									 line_num,char_pos,yytext);
                              
							  char_pos+=yyleng;
                          }


.                          {

                              printf("Error: Unrecognized character at line %d, position %d: %s\n",

                                     line_num,char_pos,yytext);

                              char_pos+=yyleng;
                          }


%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}
