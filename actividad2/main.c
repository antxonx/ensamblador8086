#include <stdio.h>
#define LIMIT 46

extern unsigned int fib(unsigned int);

int main(void)
{
    unsigned int input;
    do{
        printf("\n\nIngrese un numero menor o igual a 46:\n");
        scanf("%d", &input);
    } while(input > LIMIT);
    printf("fibonacci con %d elementos:\n", input);
	fib(input);
	return 0;
}