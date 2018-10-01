#include "types.h"
#include "stat.h"
#include "user.h"

void myPrint(int pid){
  for(int t = 0 ; t < 10 ; t++ ){
    printf(2, "child id is %d\n", pid);
  }
  exit();
}

int main(){

  int pid[30], rutime[30], rtime[30];

  for( int i = 0 ; i < 30 ; i++ ){
    pid[i] = fork();
    if( pid[i] < 0 ) {
      printf(1, "error\n");
      return -1;
    }
    else if( pid[i] == 0 ){//child
      int j = i % 3;
      if( j == 0 ){ //priority = 1
        //nice();
        nice(getpid());
        myPrint(getpid());
      }
      else if( j == 1 ){ //priority = 0
        nice(getpid());
        nice(getpid());
        //nice();
        //printf(2,"%d***********\n",nice(getpid()));
        myPrint(getpid());
      }
      else {//priority = 2
        myPrint(getpid());
      }
    }
    else{//parent
      ;
    }
  }

  for(int i = 0 ; i < 30 ; i++ ){
    wait2( &rtime[i], &rutime[i]  );
  }

  printf(1, "--------------------------\n");
  int wsum0 = 0, wsum1 = 0, wsum2 = 0;
  int tsum0 = 0, tsum1 = 0, tsum2 = 0;
  int c0 = 0, c1 = 0, c2 = 0;
  int wsumT = 0, tsumT = 0;
  for(int i = 0 ; i < 30 ; i++ ){


    printf(1, "child %d : running time = %d, waiting time = %d, turnaroundtime = %d\n", pid[i], rutime[i], rtime[i], (rutime[i]+rtime[i]));
    printf(1, "--------------------------\n");

    wsumT += rtime[i] ;
    tsumT += rutime[i] + rtime[i];

    if( i % 3 == 0 ){
      wsum1 += rtime[i];
      tsum1 += rutime[i] + rtime[i];
      c1++;
    }
    else if ( i % 3 == 1 ){
      wsum0 += rtime[i];
      tsum0 += rutime[i] + rtime[i];
      c0++;
    }
    else {
      wsum2 += rtime[i];
      tsum2 += rutime[i] + rtime[i];
      c2++;
    }
  }


//  double waverage, taverage;
//  float fl = 12.34;
//  printf(1,"*****\n%f\n", fl);

  printf(1, "--------------------------\n");
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "total average : turnedround = %d , waiting time = %d\n", tsumT/30, wsumT/30);
  printf(1, "--------------------------\n");
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 2 average : turnedround = %d , waiting time = %d\n", tsum2/c2, wsum2/c2);
  printf(1, "--------------------------\n");
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 1 average : turnedround = %d , waiting time = %d\n", tsum1/c1, wsum1/c1);
  printf(1, "--------------------------\n");
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 0 average : turnedround = %d , waiting time = %d\n", tsum0/c0, wsum0/c0);

  return 0;
}
