#include <stdio.h>
#define LOW_LIMIT 1
#define HIGH_LIMIT 1000000000

typedef enum
{
    MAYOR = 0,
    MENOR
} Condition;

extern void primo(unsigned long int, unsigned long int);
unsigned long int readNumber(char *, Condition);

int main(void)
{
    unsigned long int lowLimit, hightLimit;
    lowLimit = readNumber("Ingresa el límite inferior: ", MAYOR);
    hightLimit = readNumber("Ingresa el límite superior: ", MENOR);
    primo(lowLimit, hightLimit);
    return 0;
}

unsigned long int readNumber(char *msg, Condition cond)
{
    long int input;
    if (cond == MAYOR)
    {
        do
        {
            printf("\n%s", msg);
            scanf("%ld", &input);
        } while (input < LOW_LIMIT);
    }
    else
    {
        do
        {
            printf("\n%s", msg);
            scanf("%ld", &input);
        } while (input > HIGH_LIMIT);
    }

    return (unsigned long int)input;
}