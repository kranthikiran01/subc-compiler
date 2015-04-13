#Documentation for SubsetC compiler

###Requirements:
These requirements are for users running Debian based Operating Systems like Ubuntu/Fedora

One needs `Flex`(lex) and `Bison`(upward compatible with yacc) for lexical analyzer generator and parser generator

To install flex and yacc in Ubuntu:

* __sudo apt-get install flex__
* __sudo apt-get install bison__

To install flex and yacc in Fedora:

* __sudo yum install flex__
* __sudo yum install bison__

Steps to execute the project:

* lex subc-compiler.l
* yacc subc-compiler.y
* gcc y.tab.c -ll -ly
* ./a.out test

or simply use shellscript to automate , run 

* chmod 777 build.sh
(this is for making the script executable)
execute by running
* ./build.sh
The output will be displayed and written into file named output
Subsetc Compiler Lex File:

* __alpha [a-zA-Z]__
* __digit [0-9]__

>Alpha and digit are definitions for alphabets and digits.

* [\n] 

>for newline and increase count for line number

* {digit}+

>for identifying a number

* {alpha}({alpha}|{digit})*

>for identifying an identifier

* \/\/.* ;
* \/\*(.*\n)*.*\*\/ ;

>Regular Expression for finding comments

Rest of the file is self-explanatory.

##Yacc File:

- Header files and some definitions/declarations are included in between %{...%} braces.
- FILE* f1 is used for writing the intermediate code to a temporary file.
- The code is finally printed from the file to the console after entire parsing is done.
- Tokens returned from the lex file are declared in the initial section.


####Operator Precedence:

%right ASGN 

%left LOR

%left LAND

%left BOR

%left BXOR

%left BAND

%left EQ NE 

%left LE GE LT GT

%left '+' '-' 

%left '*' '/' '@'


- %left/%right are used for setting the associativity of various operators.
- %right is used for "=" as it is a right associative operator.
- %left is used for all remaining operators as all of them are left associative.
- The ordering of operators even decides the operator precedence.
- The operators having higher precedence are placed below the ones' with lesser precedence.
- The operators having same precedence are present at the same level.

###Rules section:

- The rules of the grammar are declared in the middle section of the yacc file.

pgmstart 			: TYPE ID '(' ')' STMTS
				;

- It's used for declaring return type of the function & then declaring a main function which is followed by a set of statements in a block.

STMTS 	: '{' STMT1 '}'|
				;
STMT1			: STMT  STMT1
				|
				;

STMT 			: STMT_DECLARE    //all types of statements
				| STMT_ASSGN  
				| STMT_IF
				| STMT_WHILE
				| STMT_SWITCH
				| ';'
				;

				
- These rules are used for declaring statements.
- Each statement can further be either a Declaration stmt or Assignment stmt or If- Else stmt or While stmt or a switch stmt.



EXP 			: EXP LT{push();} EXP {codegen_logical();}
				| EXP LE{push();} EXP {codegen_logical();}
				| EXP GT{push();} EXP {codegen_logical();}
				| EXP GE{push();} EXP {codegen_logical();}
				| EXP NE{push();} EXP {codegen_logical();}
				| EXP EQ{push();} EXP {codegen_logical();}
				| EXP '+'{push();} EXP {codegen_algebric();}
				| EXP '-'{push();} EXP {codegen_algebric();}
				| EXP '*'{push();} EXP {codegen_algebric();}
				| EXP '/'{push();} EXP {codegen_algebric();}
                                | EXP {push();} LOR EXP {codegen_logical();}
				| EXP {push();} LAND EXP {codegen_logical();}
				| EXP {push();} BOR EXP {codegen_logical();}
				| EXP {push();} BXOR EXP {codegen_logical();}
				| EXP {push();} BAND EXP {codegen_logical();}
				| '(' EXP ')'
				| ID {check();push();}
				| NUM {push();}
				;

- push function pushes the token discovered just before the push function, on to the stack.
- The functions codegen_..... are executed after dicovering of an expression.
- Though all the operators are kept under same rule, the order of declaration in the top declaration section gives precedence priority for 
  all the operators of the grammar.

- Similarly, depending on the structure of the other language constructs, remaining rules are defined and the corresponding functions are
  executed after parsing of that corresponding rule on the stack.


Code Section:

char st[1000][10];
int top=0;
int i=0;
char temp[2]="t";

int label[200];
int lnum=0;
int ltop=0;
int switch_stack[1000];
int stop=0;
char type[10];
struct Table
{
	char id[20];
	char type[10];
}table[10000];

- st stack is used for storing the node values.
- label is used for storing the labels.
- table is used for storing variables on to symbol table.
- remng are helper variables for storing their attributes like top position etc.

functions:

- push(): used for pushing node value on to the stack.
- codegen_logical(): used for generating three address code for logical statements.
- codegen_algebraic(): used for generating three address code for algebraic statements.
- if_label(): for generating a label for the end of the if/if-else statement.
- while_start(): used for generating the starting label for the while statement.
- while_rep(): used for generating the if condition for the while statement.
- while_end(): used for generating the code for moving back to start of the while statement.
- check(): is used to check if the variable is already declared when referencing it.
- STMT_DECLARE(): is used to check if the variable  being declared is already declared previously.
- Intermediatecode(): used for printing intermediate code once parsing is complete...


This documentation is signed off by [Kranthi Kiran Guduru](http://www.kranthikiran.in/) and [Sri Krishna Shanmukh](http://github.com/krishanmukh), B.Tech 3/4, Computer Science and Engineering, NIT Warangal.