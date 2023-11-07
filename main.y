%{
/*********************************************
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include <string.h>
#include"convertDFA.h"
int yylex();

extern int yyparse();
FILE* yyin;
void yyerror(const char* s);


void addNextstate(NFAnode *pre_node,NFAnode *next_node,char symbol);


NFAnode* creatNFAnode(int isFinal);


void printNFA(NFAnode* start);
int state_num=0;

%}

%union{
    char  symbol;
    NFAnode *node;
}


%token ANY
%token EMPTY
%token OR
%token CLOURE
%token LEFTPAR RIGHTPAR
%token <symbol>SYMBOL

%type <node> expr
%type <node> term
%type <node> factor
%type <node> simple

%left SYMBOL
%left RCLOURE CLOURE
%right OR
%%


lines   :   lines expr ';' {
                NFAnode *start=$2;
                printf("NFA:\n");
                printNFA(start);
                printf("DFA:\n");
                DFAnode* dfa_start=toDFA(start);
                minDFA();
                printMinDFA();
        }
        |   lines ';'{}
        |
        ;

expr    :   term OR expr{
                NFAnode* start=creatNFAnode(0);
                NFAnode* end=creatNFAnode(1);
                
                addNextstate(start,$1,0);
                addNextstate(start,$3,0);
                
                
                addNextstate($1->end,end,0);
                $1->end->isFinal=0;
                
                addNextstate($3->end,end,0);
                $3->end->isFinal=0;
                
                start->end=end;
                $$=start;
        }
        |   term{
            $$=$1;
        }
        ;

term    :   simple term{
                addNextstate($1->end,$2,0);
                $1->end->isFinal=0;
                $$=$1;
        }
        |   simple{
                $$=$1;
        }
        ;
        
simple  :   factor CLOURE{
                NFAnode* start=creatNFAnode(0);
                NFAnode* end=creatNFAnode(1);
                
                addNextstate(start,end,0);
                addNextstate(start,$1,0);
                addNextstate($1->end,end,0);
                $1->end->isFinal=0;
                
                addNextstate($1->end,$1,0);
                $$=start;
                $$->end=end;
        }
        |   factor{
                $$=$1;
        }
        ;

factor  :   SYMBOL{
                NFAnode *pre_node=creatNFAnode(0);
                NFAnode *next_node=creatNFAnode(1);
                addNextstate(pre_node,next_node,$1);
                pre_node->end=next_node;
                $$=pre_node;
        }
        |   EMPTY{
                NFAnode *pre_node=creatNFAnode(0);
                NFAnode *next_node=creatNFAnode(1);
                addNextstate(pre_node,next_node,0);
                pre_node->end=next_node;
                $$=pre_node;
        }
        |   LEFTPAR expr RIGHTPAR{
                $$=$2;
        }
        ;

%%

int yylex()
{
    int ch;
    while(1){
        ch=getchar();
        if(ch==' '||ch=='\t'||ch=='\n'){
            
        }else if(ch=='('){
            return LEFTPAR;
        }else if(ch==')'){
            return RIGHTPAR;
        }else if(ch=='|'){
            return OR;
        }
        else if(ch=='*'){
            return CLOURE;
        }
        else if(ch=='#'){
            return EMPTY;
        }
        else if(ch==';'){
            return ch;
        }
        else{
            yylval.symbol=ch;
            symbol_list[listno++]=ch;
            return SYMBOL;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}

void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}

void addNextstate(NFAnode *pre_node,NFAnode *next_node,char symbol){
    pre_node->next[pre_node->count]=next_node;
    pre_node->edge[pre_node->count]=symbol;
    pre_node->count++;
}

NFAnode* creatNFAnode(int isFinal){
    NFAnode* node=malloc(sizeof(NFAnode));
    node->id = state_num++;
    node->isFinal = isFinal;
    node->count=0;
    return node;
}

void printNFA(NFAnode* start){
    NFAnode* node[100];
    int index=0;
    node[0]=start;
    int count=1;
    while(index<count){
        printf("state:%d:\n",node[index]->id);
        
        if(node[index]->isFinal==1){
            printf("final\n");
            index++;
            continue;
        }
        
        for(int i=0;i<node[index]->count;i++){
            printf("next:%d\tedge:%c\t", node[index]->next[i]->id, node[index]->edge[i]);
            int flag=1;
            for(int j=0;j<count;j++){
                if(node[j]==node[index]->next[i]){
                    flag=0;
                    break;
                }
            }
            if(flag){
                node[count++]=node[index]->next[i];
            }
        }
        printf("\n");
        index++;
    }
}