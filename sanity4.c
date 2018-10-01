#include "types.h"
#include "user.h"


int
main()
{
	int i;
	int j= 0;
	int k;
	int retime[30];
	int rutime[30];
	int rtime[30];
	int stime[30];
	int average_wtime = 0;
	int average_ttime = 0;
	int average_rutime = 0;
	//int rutime;
	//int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;

	int pid[30];
	for (i = 0; i < 30; i++) {
		j = i % 3;
		pid[i] = fork();
		if( pid[i] < 0 ){
		printf(1,"error\n");
		return -1;
		}

		else if (pid[i] == 0) {//child
             // ensures independence from the first son's pid when gathering the results in the second part of the program
			#ifdef MLQ
			switch(j) {
				case 0:
          nice(getpid());
					break;

				case 1:
          nice(getpid());
          nice(getpid());
					break;

				case 2:

					break;
			}
			#endif
      for (k = 0; k < 5; k++){
        printf(1 , "my cid is: %d" , i);

      }
			exit(); // children exit here
		}
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < 30; i++) {
		wait2(&rtime[i], &rutime[i], &stime[i]);
		printf(1 , "mp pid is : %d  ,  my running time is: %d  ,  my waiting time is: %d  ,  my turnaround time is: %d\n" , getpid(), rutime[i] , (rtime[i]+stime[i]) , (rtime[i]+stime[i] + rutime[i]));

    for(int gf = 0; gf<30; gf++){
        average_wtime = average_wtime + rtime[gf] + stime[gf];
        average_rutime =average_wtime + rutime[gf];
        average_ttime = average_wtime + rtime[gf] + stime[gf] + rutime[gf];

    }
    average_wtime = average_wtime/30;
    average_rutime = average_rutime/30;
    average_ttime = average_ttime/30;
    printf(1 , "average waiting time is : %d  ,  average running time is: %d  ,  average turn around time is: %d\n" ,average_wtime,average_rutime,average_ttime );
		int res = i %3; // correlates to j in the dispatching loop
		switch(res) {
			case 0: // CPU bound processes
				//printf(1, "Priority 1, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[0][0] += retime[i];
				sums[0][1] += rutime[i];
				sums[0][2] += stime[i];
				break;
			case 1: // CPU bound processes, short tasks
				//printf(1, "Priority 2, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[1][0] += retime[i];
				sums[1][1] += rutime[i];
				sums[1][2] += stime[i];
				break;
			case 2: // simulating I/O bound processes
				//printf(1, "Priority 3, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[2][0] += retime[i];
				sums[2][1] += rutime[i];
				sums[2][2] += stime[i];
				break;
		}
	}
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] /= 30;
  printf(1, "\n\nPriority 1:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[0][0], sums[0][1], sums[0][2], sums[0][0] + sums[0][1] + sums[0][2]);
	printf(1, "Priority 2:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[1][0], sums[1][1], sums[1][2], sums[1][0] + sums[1][1] + sums[1][2]);
	printf(1, "Priority 3:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[2][0], sums[2][1], sums[2][2], sums[2][0] + sums[2][1] + sums[2][2]);
	exit();
}

