#include "types.h"
#include "stat.h"
#include "user.h"



int main(){

	int pid[10];
	for( int i = 0 ; i < 10 ; i++ ){
		pid[i] = fork();
		if( pid[i] < 0 ) {
			printf(1, "Error");
			return -1;
		}
		else if( pid[i] == 0 ){ //child
			for(int g =0; g<1000;g++){
            printf(1 ," time is: %d\n",g);
			}
			printf(1 , "my pid is: %d\n" , getpid());


			exit();
		}
		else if ( pid[i]  > 0 ) //parent
		for( int i = 0 ; i < 10 ; i++ ){
            wait();
		}

	}



	return 0;
}
