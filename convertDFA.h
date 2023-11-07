#include<stdio.h>
#include<stdlib.h>


extern char symbol_list[30];
extern int listno;


typedef struct node
{
    int id;
    struct node* next[10];
    char edge[10];
    int isFinal;
    int count;
    struct node* end;

}NFAnode;


typedef struct DFA
{
    int id;
    NFAnode* NFAset[10];
    int isFinal;
    struct DFA* next[10];
    char edge[10];
    int next_count;
    int NFAcount;
}DFAnode;

typedef struct DFAset
{
    int id;
    int isFinal;
    int isStart;
    DFAnode * dfa_set[10];
    int dfa_count;
    struct DFAset* next[10];
    char edge[10];
    int next_count;
}minDFAnode;




void deleteminDFAnode(minDFAnode* node);


void addminDFAnode(minDFAnode* node);



DFAnode* toDFA(NFAnode* start);


void minDFA();


DFAnode* creatDFAnode();


void addNFAnodeToDFAnode(NFAnode* nfa,DFAnode* dfa);


void colureOfNFAnode(NFAnode* nfa,DFAnode* dfa);


void addNextDFA(DFAnode* pre_node,DFAnode* next_node,char symbol);


int compareDFA(DFAnode* pre_node,DFAnode* next_node);


int copareMinDFA(minDFAnode *pre,minDFAnode *next);


minDFAnode* createMinDFAnode();


void printDFA(DFAnode* start);


minDFAnode *search(DFAnode *node);


void addNextminDFA(minDFAnode* pre_node,minDFAnode* next_node,char symbol);


void addDFAToMIN(DFAnode *dfa,minDFAnode* min_dfa);


void printMinDFA();