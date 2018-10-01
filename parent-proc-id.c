
#include "types.h"
#include "user.h"

int main(void)
{


    int processID = fork();
    if(processID == 0)
    {
        printf(1 , "This is child process , pid = %d , id of parent is %d\n" , getpid () , getppid());

    }
    else{
        printf(1 , "main process : %d\n" , getpid());
        wait();
    }

    exit();
}
