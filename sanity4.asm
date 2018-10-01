
_sanity4:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


int
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec a8 02 00 00    	sub    $0x2a8,%esp
	int i;
	int j= 0;
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	int k;
	int retime[30];
	int rutime[30];
	int rtime[30];
	int stime[30];
	int average_wtime = 0;
  1e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	int average_ttime = 0;
  25:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	int average_rutime = 0;
  2c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	//int rutime;
	//int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
  33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  3a:	eb 30                	jmp    6c <main+0x6c>
		for (j = 0; j < 3; j++)
  3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  43:	eb 1d                	jmp    62 <main+0x62>
			sums[i][j] = 0;
  45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  48:	89 d0                	mov    %edx,%eax
  4a:	01 c0                	add    %eax,%eax
  4c:	01 d0                	add    %edx,%eax
  4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  51:	01 d0                	add    %edx,%eax
  53:	c7 84 85 c4 fd ff ff 	movl   $0x0,-0x23c(%ebp,%eax,4)
  5a:	00 00 00 00 
	int average_rutime = 0;
	//int rutime;
	//int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
  5e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  62:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  66:	7e dd                	jle    45 <main+0x45>
	int average_ttime = 0;
	int average_rutime = 0;
	//int rutime;
	//int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
  68:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  6c:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  70:	7e ca                	jle    3c <main+0x3c>
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;

	int pid[30];
	for (i = 0; i < 30; i++) {
  72:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  79:	e9 9a 00 00 00       	jmp    118 <main+0x118>
		j = i % 3;
  7e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  81:	ba 56 55 55 55       	mov    $0x55555556,%edx
  86:	89 c8                	mov    %ecx,%eax
  88:	f7 ea                	imul   %edx
  8a:	89 c8                	mov    %ecx,%eax
  8c:	c1 f8 1f             	sar    $0x1f,%eax
  8f:	29 c2                	sub    %eax,%edx
  91:	89 d0                	mov    %edx,%eax
  93:	01 c0                	add    %eax,%eax
  95:	01 d0                	add    %edx,%eax
  97:	29 c1                	sub    %eax,%ecx
  99:	89 c8                	mov    %ecx,%eax
  9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pid[i] = fork();
  9e:	e8 b9 06 00 00       	call   75c <fork>
  a3:	89 c2                	mov    %eax,%edx
  a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a8:	89 94 85 4c fd ff ff 	mov    %edx,-0x2b4(%ebp,%eax,4)
		if( pid[i] < 0 ){
  af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b2:	8b 84 85 4c fd ff ff 	mov    -0x2b4(%ebp,%eax,4),%eax
  b9:	85 c0                	test   %eax,%eax
  bb:	79 1c                	jns    d9 <main+0xd9>
		printf(1,"error\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 ac 0c 00 00       	push   $0xcac
  c5:	6a 01                	push   $0x1
  c7:	e8 27 08 00 00       	call   8f3 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
		return -1;
  cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  d4:	e9 28 04 00 00       	jmp    501 <main+0x501>
		}

		else if (pid[i] == 0) {//child
  d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  dc:	8b 84 85 4c fd ff ff 	mov    -0x2b4(%ebp,%eax,4),%eax
  e3:	85 c0                	test   %eax,%eax
  e5:	75 2d                	jne    114 <main+0x114>
				case 2:

					break;
			}
			#endif
      for (k = 0; k < 5; k++){
  e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  ee:	eb 19                	jmp    109 <main+0x109>
        printf(1 , "my cid is: %d" , i);
  f0:	83 ec 04             	sub    $0x4,%esp
  f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  f6:	68 b3 0c 00 00       	push   $0xcb3
  fb:	6a 01                	push   $0x1
  fd:	e8 f1 07 00 00       	call   8f3 <printf>
 102:	83 c4 10             	add    $0x10,%esp
				case 2:

					break;
			}
			#endif
      for (k = 0; k < 5; k++){
 105:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 109:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
 10d:	7e e1                	jle    f0 <main+0xf0>
        printf(1 , "my cid is: %d" , i);

      }
			exit(); // children exit here
 10f:	e8 50 06 00 00       	call   764 <exit>
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;

	int pid[30];
	for (i = 0; i < 30; i++) {
 114:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 118:	83 7d e4 1d          	cmpl   $0x1d,-0x1c(%ebp)
 11c:	0f 8e 5c ff ff ff    	jle    7e <main+0x7e>
      }
			exit(); // children exit here
		}
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < 30; i++) {
 122:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 129:	e9 9d 02 00 00       	jmp    3cb <main+0x3cb>
		wait2(&rtime[i], &rutime[i], &stime[i]);
 12e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 134:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 137:	c1 e2 02             	shl    $0x2,%edx
 13a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 13d:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
 143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 146:	c1 e2 02             	shl    $0x2,%edx
 149:	01 c2                	add    %eax,%edx
 14b:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
 151:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
 154:	c1 e3 02             	shl    $0x2,%ebx
 157:	01 d8                	add    %ebx,%eax
 159:	83 ec 04             	sub    $0x4,%esp
 15c:	51                   	push   %ecx
 15d:	52                   	push   %edx
 15e:	50                   	push   %eax
 15f:	e8 a8 06 00 00       	call   80c <wait2>
 164:	83 c4 10             	add    $0x10,%esp
		printf(1 , "mp pid is : %d  ,  my running time is: %d  ,  my waiting time is: %d  ,  my turnaround time is: %d\n" , getpid(), rutime[i] , (rtime[i]+stime[i]) , (rtime[i]+stime[i] + rutime[i]));
 167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 16a:	8b 94 85 60 fe ff ff 	mov    -0x1a0(%ebp,%eax,4),%edx
 171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 174:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 17b:	01 c2                	add    %eax,%edx
 17d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 180:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
 187:	8d 3c 02             	lea    (%edx,%eax,1),%edi
 18a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 18d:	8b 94 85 60 fe ff ff 	mov    -0x1a0(%ebp,%eax,4),%edx
 194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 197:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 19e:	8d 34 02             	lea    (%edx,%eax,1),%esi
 1a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a4:	8b 9c 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%ebx
 1ab:	e8 34 06 00 00       	call   7e4 <getpid>
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	50                   	push   %eax
 1b7:	68 c4 0c 00 00       	push   $0xcc4
 1bc:	6a 01                	push   $0x1
 1be:	e8 30 07 00 00       	call   8f3 <printf>
 1c3:	83 c4 20             	add    $0x20,%esp

    for(int gf = 0; gf<30; gf++){
 1c6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
 1cd:	eb 5e                	jmp    22d <main+0x22d>
        average_wtime = average_wtime + rtime[gf] + stime[gf];
 1cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1d2:	8b 94 85 60 fe ff ff 	mov    -0x1a0(%ebp,%eax,4),%edx
 1d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1dc:	01 c2                	add    %eax,%edx
 1de:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1e1:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
        average_rutime =average_wtime + rutime[gf];
 1ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
 1f0:	8b 94 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%edx
 1f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        average_ttime = average_wtime + rtime[gf] + stime[gf] + rutime[gf];
 1ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
 202:	8b 94 85 60 fe ff ff 	mov    -0x1a0(%ebp,%eax,4),%edx
 209:	8b 45 d8             	mov    -0x28(%ebp),%eax
 20c:	01 c2                	add    %eax,%edx
 20e:	8b 45 cc             	mov    -0x34(%ebp),%eax
 211:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	8b 45 cc             	mov    -0x34(%ebp),%eax
 21d:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
 224:	01 d0                	add    %edx,%eax
 226:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	}
	for (i = 0; i < 30; i++) {
		wait2(&rtime[i], &rutime[i], &stime[i]);
		printf(1 , "mp pid is : %d  ,  my running time is: %d  ,  my waiting time is: %d  ,  my turnaround time is: %d\n" , getpid(), rutime[i] , (rtime[i]+stime[i]) , (rtime[i]+stime[i] + rutime[i]));

    for(int gf = 0; gf<30; gf++){
 229:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 22d:	83 7d cc 1d          	cmpl   $0x1d,-0x34(%ebp)
 231:	7e 9c                	jle    1cf <main+0x1cf>
        average_wtime = average_wtime + rtime[gf] + stime[gf];
        average_rutime =average_wtime + rutime[gf];
        average_ttime = average_wtime + rtime[gf] + stime[gf] + rutime[gf];

    }
    average_wtime = average_wtime/30;
 233:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 236:	ba 89 88 88 88       	mov    $0x88888889,%edx
 23b:	89 c8                	mov    %ecx,%eax
 23d:	f7 ea                	imul   %edx
 23f:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 242:	c1 f8 04             	sar    $0x4,%eax
 245:	89 c2                	mov    %eax,%edx
 247:	89 c8                	mov    %ecx,%eax
 249:	c1 f8 1f             	sar    $0x1f,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
 250:	89 45 d8             	mov    %eax,-0x28(%ebp)
    average_rutime = average_rutime/30;
 253:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 256:	ba 89 88 88 88       	mov    $0x88888889,%edx
 25b:	89 c8                	mov    %ecx,%eax
 25d:	f7 ea                	imul   %edx
 25f:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 262:	c1 f8 04             	sar    $0x4,%eax
 265:	89 c2                	mov    %eax,%edx
 267:	89 c8                	mov    %ecx,%eax
 269:	c1 f8 1f             	sar    $0x1f,%eax
 26c:	29 c2                	sub    %eax,%edx
 26e:	89 d0                	mov    %edx,%eax
 270:	89 45 d0             	mov    %eax,-0x30(%ebp)
    average_ttime = average_ttime/30;
 273:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 276:	ba 89 88 88 88       	mov    $0x88888889,%edx
 27b:	89 c8                	mov    %ecx,%eax
 27d:	f7 ea                	imul   %edx
 27f:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 282:	c1 f8 04             	sar    $0x4,%eax
 285:	89 c2                	mov    %eax,%edx
 287:	89 c8                	mov    %ecx,%eax
 289:	c1 f8 1f             	sar    $0x1f,%eax
 28c:	29 c2                	sub    %eax,%edx
 28e:	89 d0                	mov    %edx,%eax
 290:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    printf(1 , "average waiting time is : %d  ,  average running time is: %d  ,  average turn around time is: %d\n" ,average_wtime,average_rutime,average_ttime );
 293:	83 ec 0c             	sub    $0xc,%esp
 296:	ff 75 d4             	pushl  -0x2c(%ebp)
 299:	ff 75 d0             	pushl  -0x30(%ebp)
 29c:	ff 75 d8             	pushl  -0x28(%ebp)
 29f:	68 28 0d 00 00       	push   $0xd28
 2a4:	6a 01                	push   $0x1
 2a6:	e8 48 06 00 00       	call   8f3 <printf>
 2ab:	83 c4 20             	add    $0x20,%esp
		int res = i %3; // correlates to j in the dispatching loop
 2ae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 2b1:	ba 56 55 55 55       	mov    $0x55555556,%edx
 2b6:	89 c8                	mov    %ecx,%eax
 2b8:	f7 ea                	imul   %edx
 2ba:	89 c8                	mov    %ecx,%eax
 2bc:	c1 f8 1f             	sar    $0x1f,%eax
 2bf:	29 c2                	sub    %eax,%edx
 2c1:	89 d0                	mov    %edx,%eax
 2c3:	01 c0                	add    %eax,%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	29 c1                	sub    %eax,%ecx
 2c9:	89 c8                	mov    %ecx,%eax
 2cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		switch(res) {
 2ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2d1:	83 f8 01             	cmp    $0x1,%eax
 2d4:	74 5e                	je     334 <main+0x334>
 2d6:	83 f8 02             	cmp    $0x2,%eax
 2d9:	0f 84 9f 00 00 00    	je     37e <main+0x37e>
 2df:	85 c0                	test   %eax,%eax
 2e1:	0f 85 e0 00 00 00    	jne    3c7 <main+0x3c7>
			case 0: // CPU bound processes
				//printf(1, "Priority 1, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[0][0] += retime[i];
 2e7:	8b 95 c4 fd ff ff    	mov    -0x23c(%ebp),%edx
 2ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f0:	8b 84 85 50 ff ff ff 	mov    -0xb0(%ebp,%eax,4),%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	89 85 c4 fd ff ff    	mov    %eax,-0x23c(%ebp)
				sums[0][1] += rutime[i];
 2ff:	8b 95 c8 fd ff ff    	mov    -0x238(%ebp),%edx
 305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 308:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
 30f:	01 d0                	add    %edx,%eax
 311:	89 85 c8 fd ff ff    	mov    %eax,-0x238(%ebp)
				sums[0][2] += stime[i];
 317:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 31d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 320:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 327:	01 d0                	add    %edx,%eax
 329:	89 85 cc fd ff ff    	mov    %eax,-0x234(%ebp)
				break;
 32f:	e9 93 00 00 00       	jmp    3c7 <main+0x3c7>
			case 1: // CPU bound processes, short tasks
				//printf(1, "Priority 2, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[1][0] += retime[i];
 334:	8b 95 d0 fd ff ff    	mov    -0x230(%ebp),%edx
 33a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 33d:	8b 84 85 50 ff ff ff 	mov    -0xb0(%ebp,%eax,4),%eax
 344:	01 d0                	add    %edx,%eax
 346:	89 85 d0 fd ff ff    	mov    %eax,-0x230(%ebp)
				sums[1][1] += rutime[i];
 34c:	8b 95 d4 fd ff ff    	mov    -0x22c(%ebp),%edx
 352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 355:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
 35c:	01 d0                	add    %edx,%eax
 35e:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
				sums[1][2] += stime[i];
 364:	8b 95 d8 fd ff ff    	mov    -0x228(%ebp),%edx
 36a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 36d:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 374:	01 d0                	add    %edx,%eax
 376:	89 85 d8 fd ff ff    	mov    %eax,-0x228(%ebp)
				break;
 37c:	eb 49                	jmp    3c7 <main+0x3c7>
			case 2: // simulating I/O bound processes
				//printf(1, "Priority 3, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[2][0] += retime[i];
 37e:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 387:	8b 84 85 50 ff ff ff 	mov    -0xb0(%ebp,%eax,4),%eax
 38e:	01 d0                	add    %edx,%eax
 390:	89 85 dc fd ff ff    	mov    %eax,-0x224(%ebp)
				sums[2][1] += rutime[i];
 396:	8b 95 e0 fd ff ff    	mov    -0x220(%ebp),%edx
 39c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 39f:	8b 84 85 d8 fe ff ff 	mov    -0x128(%ebp,%eax,4),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)
				sums[2][2] += stime[i];
 3ae:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 3b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3b7:	8b 84 85 e8 fd ff ff 	mov    -0x218(%ebp,%eax,4),%eax
 3be:	01 d0                	add    %edx,%eax
 3c0:	89 85 e4 fd ff ff    	mov    %eax,-0x21c(%ebp)
				break;
 3c6:	90                   	nop
      }
			exit(); // children exit here
		}
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < 30; i++) {
 3c7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 3cb:	83 7d e4 1d          	cmpl   $0x1d,-0x1c(%ebp)
 3cf:	0f 8e 59 fd ff ff    	jle    12e <main+0x12e>
				sums[2][1] += rutime[i];
				sums[2][2] += stime[i];
				break;
		}
	}
	for (i = 0; i < 3; i++)
 3d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3dc:	eb 5b                	jmp    439 <main+0x439>
		for (j = 0; j < 3; j++)
 3de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 3e5:	eb 48                	jmp    42f <main+0x42f>
			sums[i][j] /= 30;
 3e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3ea:	89 d0                	mov    %edx,%eax
 3ec:	01 c0                	add    %eax,%eax
 3ee:	01 d0                	add    %edx,%eax
 3f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
 3f3:	01 d0                	add    %edx,%eax
 3f5:	8b 8c 85 c4 fd ff ff 	mov    -0x23c(%ebp,%eax,4),%ecx
 3fc:	ba 89 88 88 88       	mov    $0x88888889,%edx
 401:	89 c8                	mov    %ecx,%eax
 403:	f7 ea                	imul   %edx
 405:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 408:	c1 f8 04             	sar    $0x4,%eax
 40b:	89 c2                	mov    %eax,%edx
 40d:	89 c8                	mov    %ecx,%eax
 40f:	c1 f8 1f             	sar    $0x1f,%eax
 412:	89 d1                	mov    %edx,%ecx
 414:	29 c1                	sub    %eax,%ecx
 416:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 419:	89 d0                	mov    %edx,%eax
 41b:	01 c0                	add    %eax,%eax
 41d:	01 d0                	add    %edx,%eax
 41f:	8b 55 e0             	mov    -0x20(%ebp),%edx
 422:	01 d0                	add    %edx,%eax
 424:	89 8c 85 c4 fd ff ff 	mov    %ecx,-0x23c(%ebp,%eax,4)
				sums[2][2] += stime[i];
				break;
		}
	}
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
 42b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 42f:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
 433:	7e b2                	jle    3e7 <main+0x3e7>
				sums[2][1] += rutime[i];
				sums[2][2] += stime[i];
				break;
		}
	}
	for (i = 0; i < 3; i++)
 435:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 439:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 43d:	7e 9f                	jle    3de <main+0x3de>
		for (j = 0; j < 3; j++)
			sums[i][j] /= 30;
  printf(1, "\n\nPriority 1:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[0][0], sums[0][1], sums[0][2], sums[0][0] + sums[0][1] + sums[0][2]);
 43f:	8b 95 c4 fd ff ff    	mov    -0x23c(%ebp),%edx
 445:	8b 85 c8 fd ff ff    	mov    -0x238(%ebp),%eax
 44b:	01 c2                	add    %eax,%edx
 44d:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 453:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 456:	8b 8d cc fd ff ff    	mov    -0x234(%ebp),%ecx
 45c:	8b 95 c8 fd ff ff    	mov    -0x238(%ebp),%edx
 462:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 468:	83 ec 08             	sub    $0x8,%esp
 46b:	53                   	push   %ebx
 46c:	51                   	push   %ecx
 46d:	52                   	push   %edx
 46e:	50                   	push   %eax
 46f:	68 8c 0d 00 00       	push   $0xd8c
 474:	6a 01                	push   $0x1
 476:	e8 78 04 00 00       	call   8f3 <printf>
 47b:	83 c4 20             	add    $0x20,%esp
	printf(1, "Priority 2:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[1][0], sums[1][1], sums[1][2], sums[1][0] + sums[1][1] + sums[1][2]);
 47e:	8b 95 d0 fd ff ff    	mov    -0x230(%ebp),%edx
 484:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 48a:	01 c2                	add    %eax,%edx
 48c:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
 492:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 495:	8b 8d d8 fd ff ff    	mov    -0x228(%ebp),%ecx
 49b:	8b 95 d4 fd ff ff    	mov    -0x22c(%ebp),%edx
 4a1:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
 4a7:	83 ec 08             	sub    $0x8,%esp
 4aa:	53                   	push   %ebx
 4ab:	51                   	push   %ecx
 4ac:	52                   	push   %edx
 4ad:	50                   	push   %eax
 4ae:	68 04 0e 00 00       	push   $0xe04
 4b3:	6a 01                	push   $0x1
 4b5:	e8 39 04 00 00       	call   8f3 <printf>
 4ba:	83 c4 20             	add    $0x20,%esp
	printf(1, "Priority 3:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[2][0], sums[2][1], sums[2][2], sums[2][0] + sums[2][1] + sums[2][2]);
 4bd:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 4c3:	8b 85 e0 fd ff ff    	mov    -0x220(%ebp),%eax
 4c9:	01 c2                	add    %eax,%edx
 4cb:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
 4d1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 4d4:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 4da:	8b 95 e0 fd ff ff    	mov    -0x220(%ebp),%edx
 4e0:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	53                   	push   %ebx
 4ea:	51                   	push   %ecx
 4eb:	52                   	push   %edx
 4ec:	50                   	push   %eax
 4ed:	68 7c 0e 00 00       	push   $0xe7c
 4f2:	6a 01                	push   $0x1
 4f4:	e8 fa 03 00 00       	call   8f3 <printf>
 4f9:	83 c4 20             	add    $0x20,%esp
	exit();
 4fc:	e8 63 02 00 00       	call   764 <exit>
}
 501:	8d 65 f0             	lea    -0x10(%ebp),%esp
 504:	59                   	pop    %ecx
 505:	5b                   	pop    %ebx
 506:	5e                   	pop    %esi
 507:	5f                   	pop    %edi
 508:	5d                   	pop    %ebp
 509:	8d 61 fc             	lea    -0x4(%ecx),%esp
 50c:	c3                   	ret    

0000050d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	57                   	push   %edi
 511:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 512:	8b 4d 08             	mov    0x8(%ebp),%ecx
 515:	8b 55 10             	mov    0x10(%ebp),%edx
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	89 cb                	mov    %ecx,%ebx
 51d:	89 df                	mov    %ebx,%edi
 51f:	89 d1                	mov    %edx,%ecx
 521:	fc                   	cld    
 522:	f3 aa                	rep stos %al,%es:(%edi)
 524:	89 ca                	mov    %ecx,%edx
 526:	89 fb                	mov    %edi,%ebx
 528:	89 5d 08             	mov    %ebx,0x8(%ebp)
 52b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 52e:	90                   	nop
 52f:	5b                   	pop    %ebx
 530:	5f                   	pop    %edi
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    

00000533 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 53f:	90                   	nop
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	8d 50 01             	lea    0x1(%eax),%edx
 546:	89 55 08             	mov    %edx,0x8(%ebp)
 549:	8b 55 0c             	mov    0xc(%ebp),%edx
 54c:	8d 4a 01             	lea    0x1(%edx),%ecx
 54f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 552:	0f b6 12             	movzbl (%edx),%edx
 555:	88 10                	mov    %dl,(%eax)
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	84 c0                	test   %al,%al
 55c:	75 e2                	jne    540 <strcpy+0xd>
    ;
  return os;
 55e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 566:	eb 08                	jmp    570 <strcmp+0xd>
    p++, q++;
 568:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 56c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	84 c0                	test   %al,%al
 578:	74 10                	je     58a <strcmp+0x27>
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	0f b6 10             	movzbl (%eax),%edx
 580:	8b 45 0c             	mov    0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	38 c2                	cmp    %al,%dl
 588:	74 de                	je     568 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f b6 d0             	movzbl %al,%edx
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
 596:	0f b6 00             	movzbl (%eax),%eax
 599:	0f b6 c0             	movzbl %al,%eax
 59c:	29 c2                	sub    %eax,%edx
 59e:	89 d0                	mov    %edx,%eax
}
 5a0:	5d                   	pop    %ebp
 5a1:	c3                   	ret    

000005a2 <strlen>:

uint
strlen(char *s)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 5a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5af:	eb 04                	jmp    5b5 <strlen+0x13>
 5b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	01 d0                	add    %edx,%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	84 c0                	test   %al,%al
 5c2:	75 ed                	jne    5b1 <strlen+0xf>
    ;
  return n;
 5c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5c7:	c9                   	leave  
 5c8:	c3                   	ret    

000005c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c9:	55                   	push   %ebp
 5ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 5cc:	8b 45 10             	mov    0x10(%ebp),%eax
 5cf:	50                   	push   %eax
 5d0:	ff 75 0c             	pushl  0xc(%ebp)
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 32 ff ff ff       	call   50d <stosb>
 5db:	83 c4 0c             	add    $0xc,%esp
  return dst;
 5de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5e1:	c9                   	leave  
 5e2:	c3                   	ret    

000005e3 <strchr>:

char*
strchr(const char *s, char c)
{
 5e3:	55                   	push   %ebp
 5e4:	89 e5                	mov    %esp,%ebp
 5e6:	83 ec 04             	sub    $0x4,%esp
 5e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5ef:	eb 14                	jmp    605 <strchr+0x22>
    if(*s == c)
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 5fa:	75 05                	jne    601 <strchr+0x1e>
      return (char*)s;
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	eb 13                	jmp    614 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 601:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	84 c0                	test   %al,%al
 60d:	75 e2                	jne    5f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 60f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 614:	c9                   	leave  
 615:	c3                   	ret    

00000616 <gets>:

char*
gets(char *buf, int max)
{
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 61c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 623:	eb 42                	jmp    667 <gets+0x51>
    cc = read(0, &c, 1);
 625:	83 ec 04             	sub    $0x4,%esp
 628:	6a 01                	push   $0x1
 62a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 62d:	50                   	push   %eax
 62e:	6a 00                	push   $0x0
 630:	e8 47 01 00 00       	call   77c <read>
 635:	83 c4 10             	add    $0x10,%esp
 638:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 63b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63f:	7e 33                	jle    674 <gets+0x5e>
      break;
    buf[i++] = c;
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8d 50 01             	lea    0x1(%eax),%edx
 647:	89 55 f4             	mov    %edx,-0xc(%ebp)
 64a:	89 c2                	mov    %eax,%edx
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	01 c2                	add    %eax,%edx
 651:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 655:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 657:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 65b:	3c 0a                	cmp    $0xa,%al
 65d:	74 16                	je     675 <gets+0x5f>
 65f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 663:	3c 0d                	cmp    $0xd,%al
 665:	74 0e                	je     675 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 667:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66a:	83 c0 01             	add    $0x1,%eax
 66d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 670:	7c b3                	jl     625 <gets+0xf>
 672:	eb 01                	jmp    675 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 674:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 675:	8b 55 f4             	mov    -0xc(%ebp),%edx
 678:	8b 45 08             	mov    0x8(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 680:	8b 45 08             	mov    0x8(%ebp),%eax
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <stat>:

int
stat(char *n, struct stat *st)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 68b:	83 ec 08             	sub    $0x8,%esp
 68e:	6a 00                	push   $0x0
 690:	ff 75 08             	pushl  0x8(%ebp)
 693:	e8 0c 01 00 00       	call   7a4 <open>
 698:	83 c4 10             	add    $0x10,%esp
 69b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 69e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a2:	79 07                	jns    6ab <stat+0x26>
    return -1;
 6a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6a9:	eb 25                	jmp    6d0 <stat+0x4b>
  r = fstat(fd, st);
 6ab:	83 ec 08             	sub    $0x8,%esp
 6ae:	ff 75 0c             	pushl  0xc(%ebp)
 6b1:	ff 75 f4             	pushl  -0xc(%ebp)
 6b4:	e8 03 01 00 00       	call   7bc <fstat>
 6b9:	83 c4 10             	add    $0x10,%esp
 6bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6bf:	83 ec 0c             	sub    $0xc,%esp
 6c2:	ff 75 f4             	pushl  -0xc(%ebp)
 6c5:	e8 c2 00 00 00       	call   78c <close>
 6ca:	83 c4 10             	add    $0x10,%esp
  return r;
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6d0:	c9                   	leave  
 6d1:	c3                   	ret    

000006d2 <atoi>:

int
atoi(const char *s)
{
 6d2:	55                   	push   %ebp
 6d3:	89 e5                	mov    %esp,%ebp
 6d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6df:	eb 25                	jmp    706 <atoi+0x34>
    n = n*10 + *s++ - '0';
 6e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6e4:	89 d0                	mov    %edx,%eax
 6e6:	c1 e0 02             	shl    $0x2,%eax
 6e9:	01 d0                	add    %edx,%eax
 6eb:	01 c0                	add    %eax,%eax
 6ed:	89 c1                	mov    %eax,%ecx
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	8d 50 01             	lea    0x1(%eax),%edx
 6f5:	89 55 08             	mov    %edx,0x8(%ebp)
 6f8:	0f b6 00             	movzbl (%eax),%eax
 6fb:	0f be c0             	movsbl %al,%eax
 6fe:	01 c8                	add    %ecx,%eax
 700:	83 e8 30             	sub    $0x30,%eax
 703:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	3c 2f                	cmp    $0x2f,%al
 70e:	7e 0a                	jle    71a <atoi+0x48>
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	0f b6 00             	movzbl (%eax),%eax
 716:	3c 39                	cmp    $0x39,%al
 718:	7e c7                	jle    6e1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 71d:	c9                   	leave  
 71e:	c3                   	ret    

0000071f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 71f:	55                   	push   %ebp
 720:	89 e5                	mov    %esp,%ebp
 722:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 72b:	8b 45 0c             	mov    0xc(%ebp),%eax
 72e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 731:	eb 17                	jmp    74a <memmove+0x2b>
    *dst++ = *src++;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8d 50 01             	lea    0x1(%eax),%edx
 739:	89 55 fc             	mov    %edx,-0x4(%ebp)
 73c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73f:	8d 4a 01             	lea    0x1(%edx),%ecx
 742:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 745:	0f b6 12             	movzbl (%edx),%edx
 748:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 74a:	8b 45 10             	mov    0x10(%ebp),%eax
 74d:	8d 50 ff             	lea    -0x1(%eax),%edx
 750:	89 55 10             	mov    %edx,0x10(%ebp)
 753:	85 c0                	test   %eax,%eax
 755:	7f dc                	jg     733 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 757:	8b 45 08             	mov    0x8(%ebp),%eax
}
 75a:	c9                   	leave  
 75b:	c3                   	ret    

0000075c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 75c:	b8 01 00 00 00       	mov    $0x1,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <exit>:
SYSCALL(exit)
 764:	b8 02 00 00 00       	mov    $0x2,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <wait>:
SYSCALL(wait)
 76c:	b8 03 00 00 00       	mov    $0x3,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <pipe>:
SYSCALL(pipe)
 774:	b8 04 00 00 00       	mov    $0x4,%eax
 779:	cd 40                	int    $0x40
 77b:	c3                   	ret    

0000077c <read>:
SYSCALL(read)
 77c:	b8 05 00 00 00       	mov    $0x5,%eax
 781:	cd 40                	int    $0x40
 783:	c3                   	ret    

00000784 <write>:
SYSCALL(write)
 784:	b8 10 00 00 00       	mov    $0x10,%eax
 789:	cd 40                	int    $0x40
 78b:	c3                   	ret    

0000078c <close>:
SYSCALL(close)
 78c:	b8 15 00 00 00       	mov    $0x15,%eax
 791:	cd 40                	int    $0x40
 793:	c3                   	ret    

00000794 <kill>:
SYSCALL(kill)
 794:	b8 06 00 00 00       	mov    $0x6,%eax
 799:	cd 40                	int    $0x40
 79b:	c3                   	ret    

0000079c <exec>:
SYSCALL(exec)
 79c:	b8 07 00 00 00       	mov    $0x7,%eax
 7a1:	cd 40                	int    $0x40
 7a3:	c3                   	ret    

000007a4 <open>:
SYSCALL(open)
 7a4:	b8 0f 00 00 00       	mov    $0xf,%eax
 7a9:	cd 40                	int    $0x40
 7ab:	c3                   	ret    

000007ac <mknod>:
SYSCALL(mknod)
 7ac:	b8 11 00 00 00       	mov    $0x11,%eax
 7b1:	cd 40                	int    $0x40
 7b3:	c3                   	ret    

000007b4 <unlink>:
SYSCALL(unlink)
 7b4:	b8 12 00 00 00       	mov    $0x12,%eax
 7b9:	cd 40                	int    $0x40
 7bb:	c3                   	ret    

000007bc <fstat>:
SYSCALL(fstat)
 7bc:	b8 08 00 00 00       	mov    $0x8,%eax
 7c1:	cd 40                	int    $0x40
 7c3:	c3                   	ret    

000007c4 <link>:
SYSCALL(link)
 7c4:	b8 13 00 00 00       	mov    $0x13,%eax
 7c9:	cd 40                	int    $0x40
 7cb:	c3                   	ret    

000007cc <mkdir>:
SYSCALL(mkdir)
 7cc:	b8 14 00 00 00       	mov    $0x14,%eax
 7d1:	cd 40                	int    $0x40
 7d3:	c3                   	ret    

000007d4 <chdir>:
SYSCALL(chdir)
 7d4:	b8 09 00 00 00       	mov    $0x9,%eax
 7d9:	cd 40                	int    $0x40
 7db:	c3                   	ret    

000007dc <dup>:
SYSCALL(dup)
 7dc:	b8 0a 00 00 00       	mov    $0xa,%eax
 7e1:	cd 40                	int    $0x40
 7e3:	c3                   	ret    

000007e4 <getpid>:
SYSCALL(getpid)
 7e4:	b8 0b 00 00 00       	mov    $0xb,%eax
 7e9:	cd 40                	int    $0x40
 7eb:	c3                   	ret    

000007ec <sbrk>:
SYSCALL(sbrk)
 7ec:	b8 0c 00 00 00       	mov    $0xc,%eax
 7f1:	cd 40                	int    $0x40
 7f3:	c3                   	ret    

000007f4 <sleep>:
SYSCALL(sleep)
 7f4:	b8 0d 00 00 00       	mov    $0xd,%eax
 7f9:	cd 40                	int    $0x40
 7fb:	c3                   	ret    

000007fc <uptime>:
SYSCALL(uptime)
 7fc:	b8 0e 00 00 00       	mov    $0xe,%eax
 801:	cd 40                	int    $0x40
 803:	c3                   	ret    

00000804 <getppid>:
SYSCALL(getppid)
 804:	b8 16 00 00 00       	mov    $0x16,%eax
 809:	cd 40                	int    $0x40
 80b:	c3                   	ret    

0000080c <wait2>:
SYSCALL(wait2)
 80c:	b8 18 00 00 00       	mov    $0x18,%eax
 811:	cd 40                	int    $0x40
 813:	c3                   	ret    

00000814 <nice>:
SYSCALL(nice)
 814:	b8 17 00 00 00       	mov    $0x17,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 18             	sub    $0x18,%esp
 822:	8b 45 0c             	mov    0xc(%ebp),%eax
 825:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 828:	83 ec 04             	sub    $0x4,%esp
 82b:	6a 01                	push   $0x1
 82d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 830:	50                   	push   %eax
 831:	ff 75 08             	pushl  0x8(%ebp)
 834:	e8 4b ff ff ff       	call   784 <write>
 839:	83 c4 10             	add    $0x10,%esp
}
 83c:	90                   	nop
 83d:	c9                   	leave  
 83e:	c3                   	ret    

0000083f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 83f:	55                   	push   %ebp
 840:	89 e5                	mov    %esp,%ebp
 842:	53                   	push   %ebx
 843:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 846:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 84d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 851:	74 17                	je     86a <printint+0x2b>
 853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 857:	79 11                	jns    86a <printint+0x2b>
    neg = 1;
 859:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 860:	8b 45 0c             	mov    0xc(%ebp),%eax
 863:	f7 d8                	neg    %eax
 865:	89 45 ec             	mov    %eax,-0x14(%ebp)
 868:	eb 06                	jmp    870 <printint+0x31>
  } else {
    x = xx;
 86a:	8b 45 0c             	mov    0xc(%ebp),%eax
 86d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 870:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 877:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 87a:	8d 41 01             	lea    0x1(%ecx),%eax
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 880:	8b 5d 10             	mov    0x10(%ebp),%ebx
 883:	8b 45 ec             	mov    -0x14(%ebp),%eax
 886:	ba 00 00 00 00       	mov    $0x0,%edx
 88b:	f7 f3                	div    %ebx
 88d:	89 d0                	mov    %edx,%eax
 88f:	0f b6 80 60 11 00 00 	movzbl 0x1160(%eax),%eax
 896:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 89a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 89d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a0:	ba 00 00 00 00       	mov    $0x0,%edx
 8a5:	f7 f3                	div    %ebx
 8a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8ae:	75 c7                	jne    877 <printint+0x38>
  if(neg)
 8b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b4:	74 2d                	je     8e3 <printint+0xa4>
    buf[i++] = '-';
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	8d 50 01             	lea    0x1(%eax),%edx
 8bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8bf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8c4:	eb 1d                	jmp    8e3 <printint+0xa4>
    putc(fd, buf[i]);
 8c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	01 d0                	add    %edx,%eax
 8ce:	0f b6 00             	movzbl (%eax),%eax
 8d1:	0f be c0             	movsbl %al,%eax
 8d4:	83 ec 08             	sub    $0x8,%esp
 8d7:	50                   	push   %eax
 8d8:	ff 75 08             	pushl  0x8(%ebp)
 8db:	e8 3c ff ff ff       	call   81c <putc>
 8e0:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8eb:	79 d9                	jns    8c6 <printint+0x87>
    putc(fd, buf[i]);
}
 8ed:	90                   	nop
 8ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8f1:	c9                   	leave  
 8f2:	c3                   	ret    

000008f3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8f3:	55                   	push   %ebp
 8f4:	89 e5                	mov    %esp,%ebp
 8f6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 900:	8d 45 0c             	lea    0xc(%ebp),%eax
 903:	83 c0 04             	add    $0x4,%eax
 906:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 910:	e9 59 01 00 00       	jmp    a6e <printf+0x17b>
    c = fmt[i] & 0xff;
 915:	8b 55 0c             	mov    0xc(%ebp),%edx
 918:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91b:	01 d0                	add    %edx,%eax
 91d:	0f b6 00             	movzbl (%eax),%eax
 920:	0f be c0             	movsbl %al,%eax
 923:	25 ff 00 00 00       	and    $0xff,%eax
 928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 92b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 92f:	75 2c                	jne    95d <printf+0x6a>
      if(c == '%'){
 931:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 935:	75 0c                	jne    943 <printf+0x50>
        state = '%';
 937:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 93e:	e9 27 01 00 00       	jmp    a6a <printf+0x177>
      } else {
        putc(fd, c);
 943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 946:	0f be c0             	movsbl %al,%eax
 949:	83 ec 08             	sub    $0x8,%esp
 94c:	50                   	push   %eax
 94d:	ff 75 08             	pushl  0x8(%ebp)
 950:	e8 c7 fe ff ff       	call   81c <putc>
 955:	83 c4 10             	add    $0x10,%esp
 958:	e9 0d 01 00 00       	jmp    a6a <printf+0x177>
      }
    } else if(state == '%'){
 95d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 961:	0f 85 03 01 00 00    	jne    a6a <printf+0x177>
      if(c == 'd'){
 967:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 96b:	75 1e                	jne    98b <printf+0x98>
        printint(fd, *ap, 10, 1);
 96d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 970:	8b 00                	mov    (%eax),%eax
 972:	6a 01                	push   $0x1
 974:	6a 0a                	push   $0xa
 976:	50                   	push   %eax
 977:	ff 75 08             	pushl  0x8(%ebp)
 97a:	e8 c0 fe ff ff       	call   83f <printint>
 97f:	83 c4 10             	add    $0x10,%esp
        ap++;
 982:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 986:	e9 d8 00 00 00       	jmp    a63 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 98b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 98f:	74 06                	je     997 <printf+0xa4>
 991:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 995:	75 1e                	jne    9b5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 997:	8b 45 e8             	mov    -0x18(%ebp),%eax
 99a:	8b 00                	mov    (%eax),%eax
 99c:	6a 00                	push   $0x0
 99e:	6a 10                	push   $0x10
 9a0:	50                   	push   %eax
 9a1:	ff 75 08             	pushl  0x8(%ebp)
 9a4:	e8 96 fe ff ff       	call   83f <printint>
 9a9:	83 c4 10             	add    $0x10,%esp
        ap++;
 9ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b0:	e9 ae 00 00 00       	jmp    a63 <printf+0x170>
      } else if(c == 's'){
 9b5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9b9:	75 43                	jne    9fe <printf+0x10b>
        s = (char*)*ap;
 9bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9be:	8b 00                	mov    (%eax),%eax
 9c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9cb:	75 25                	jne    9f2 <printf+0xff>
          s = "(null)";
 9cd:	c7 45 f4 f1 0e 00 00 	movl   $0xef1,-0xc(%ebp)
        while(*s != 0){
 9d4:	eb 1c                	jmp    9f2 <printf+0xff>
          putc(fd, *s);
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	0f b6 00             	movzbl (%eax),%eax
 9dc:	0f be c0             	movsbl %al,%eax
 9df:	83 ec 08             	sub    $0x8,%esp
 9e2:	50                   	push   %eax
 9e3:	ff 75 08             	pushl  0x8(%ebp)
 9e6:	e8 31 fe ff ff       	call   81c <putc>
 9eb:	83 c4 10             	add    $0x10,%esp
          s++;
 9ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f5:	0f b6 00             	movzbl (%eax),%eax
 9f8:	84 c0                	test   %al,%al
 9fa:	75 da                	jne    9d6 <printf+0xe3>
 9fc:	eb 65                	jmp    a63 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9fe:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a02:	75 1d                	jne    a21 <printf+0x12e>
        putc(fd, *ap);
 a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a07:	8b 00                	mov    (%eax),%eax
 a09:	0f be c0             	movsbl %al,%eax
 a0c:	83 ec 08             	sub    $0x8,%esp
 a0f:	50                   	push   %eax
 a10:	ff 75 08             	pushl  0x8(%ebp)
 a13:	e8 04 fe ff ff       	call   81c <putc>
 a18:	83 c4 10             	add    $0x10,%esp
        ap++;
 a1b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a1f:	eb 42                	jmp    a63 <printf+0x170>
      } else if(c == '%'){
 a21:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a25:	75 17                	jne    a3e <printf+0x14b>
        putc(fd, c);
 a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a2a:	0f be c0             	movsbl %al,%eax
 a2d:	83 ec 08             	sub    $0x8,%esp
 a30:	50                   	push   %eax
 a31:	ff 75 08             	pushl  0x8(%ebp)
 a34:	e8 e3 fd ff ff       	call   81c <putc>
 a39:	83 c4 10             	add    $0x10,%esp
 a3c:	eb 25                	jmp    a63 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a3e:	83 ec 08             	sub    $0x8,%esp
 a41:	6a 25                	push   $0x25
 a43:	ff 75 08             	pushl  0x8(%ebp)
 a46:	e8 d1 fd ff ff       	call   81c <putc>
 a4b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a51:	0f be c0             	movsbl %al,%eax
 a54:	83 ec 08             	sub    $0x8,%esp
 a57:	50                   	push   %eax
 a58:	ff 75 08             	pushl  0x8(%ebp)
 a5b:	e8 bc fd ff ff       	call   81c <putc>
 a60:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a63:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a6a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	01 d0                	add    %edx,%eax
 a76:	0f b6 00             	movzbl (%eax),%eax
 a79:	84 c0                	test   %al,%al
 a7b:	0f 85 94 fe ff ff    	jne    915 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a81:	90                   	nop
 a82:	c9                   	leave  
 a83:	c3                   	ret    

00000a84 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a84:	55                   	push   %ebp
 a85:	89 e5                	mov    %esp,%ebp
 a87:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8a:	8b 45 08             	mov    0x8(%ebp),%eax
 a8d:	83 e8 08             	sub    $0x8,%eax
 a90:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a93:	a1 7c 11 00 00       	mov    0x117c,%eax
 a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a9b:	eb 24                	jmp    ac1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	8b 00                	mov    (%eax),%eax
 aa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aa5:	77 12                	ja     ab9 <free+0x35>
 aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aad:	77 24                	ja     ad3 <free+0x4f>
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	8b 00                	mov    (%eax),%eax
 ab4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab7:	77 1a                	ja     ad3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abc:	8b 00                	mov    (%eax),%eax
 abe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ac7:	76 d4                	jbe    a9d <free+0x19>
 ac9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acc:	8b 00                	mov    (%eax),%eax
 ace:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad1:	76 ca                	jbe    a9d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad6:	8b 40 04             	mov    0x4(%eax),%eax
 ad9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae3:	01 c2                	add    %eax,%edx
 ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae8:	8b 00                	mov    (%eax),%eax
 aea:	39 c2                	cmp    %eax,%edx
 aec:	75 24                	jne    b12 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af1:	8b 50 04             	mov    0x4(%eax),%edx
 af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af7:	8b 00                	mov    (%eax),%eax
 af9:	8b 40 04             	mov    0x4(%eax),%eax
 afc:	01 c2                	add    %eax,%edx
 afe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b01:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b07:	8b 00                	mov    (%eax),%eax
 b09:	8b 10                	mov    (%eax),%edx
 b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0e:	89 10                	mov    %edx,(%eax)
 b10:	eb 0a                	jmp    b1c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b15:	8b 10                	mov    (%eax),%edx
 b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1f:	8b 40 04             	mov    0x4(%eax),%eax
 b22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2c:	01 d0                	add    %edx,%eax
 b2e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b31:	75 20                	jne    b53 <free+0xcf>
    p->s.size += bp->s.size;
 b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b36:	8b 50 04             	mov    0x4(%eax),%edx
 b39:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b3c:	8b 40 04             	mov    0x4(%eax),%eax
 b3f:	01 c2                	add    %eax,%edx
 b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b44:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b4a:	8b 10                	mov    (%eax),%edx
 b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4f:	89 10                	mov    %edx,(%eax)
 b51:	eb 08                	jmp    b5b <free+0xd7>
  } else
    p->s.ptr = bp;
 b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b56:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b59:	89 10                	mov    %edx,(%eax)
  freep = p;
 b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5e:	a3 7c 11 00 00       	mov    %eax,0x117c
}
 b63:	90                   	nop
 b64:	c9                   	leave  
 b65:	c3                   	ret    

00000b66 <morecore>:

static Header*
morecore(uint nu)
{
 b66:	55                   	push   %ebp
 b67:	89 e5                	mov    %esp,%ebp
 b69:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b6c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b73:	77 07                	ja     b7c <morecore+0x16>
    nu = 4096;
 b75:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b7c:	8b 45 08             	mov    0x8(%ebp),%eax
 b7f:	c1 e0 03             	shl    $0x3,%eax
 b82:	83 ec 0c             	sub    $0xc,%esp
 b85:	50                   	push   %eax
 b86:	e8 61 fc ff ff       	call   7ec <sbrk>
 b8b:	83 c4 10             	add    $0x10,%esp
 b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b91:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b95:	75 07                	jne    b9e <morecore+0x38>
    return 0;
 b97:	b8 00 00 00 00       	mov    $0x0,%eax
 b9c:	eb 26                	jmp    bc4 <morecore+0x5e>
  hp = (Header*)p;
 b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba7:	8b 55 08             	mov    0x8(%ebp),%edx
 baa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb0:	83 c0 08             	add    $0x8,%eax
 bb3:	83 ec 0c             	sub    $0xc,%esp
 bb6:	50                   	push   %eax
 bb7:	e8 c8 fe ff ff       	call   a84 <free>
 bbc:	83 c4 10             	add    $0x10,%esp
  return freep;
 bbf:	a1 7c 11 00 00       	mov    0x117c,%eax
}
 bc4:	c9                   	leave  
 bc5:	c3                   	ret    

00000bc6 <malloc>:

void*
malloc(uint nbytes)
{
 bc6:	55                   	push   %ebp
 bc7:	89 e5                	mov    %esp,%ebp
 bc9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bcc:	8b 45 08             	mov    0x8(%ebp),%eax
 bcf:	83 c0 07             	add    $0x7,%eax
 bd2:	c1 e8 03             	shr    $0x3,%eax
 bd5:	83 c0 01             	add    $0x1,%eax
 bd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bdb:	a1 7c 11 00 00       	mov    0x117c,%eax
 be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 be7:	75 23                	jne    c0c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 be9:	c7 45 f0 74 11 00 00 	movl   $0x1174,-0x10(%ebp)
 bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf3:	a3 7c 11 00 00       	mov    %eax,0x117c
 bf8:	a1 7c 11 00 00       	mov    0x117c,%eax
 bfd:	a3 74 11 00 00       	mov    %eax,0x1174
    base.s.size = 0;
 c02:	c7 05 78 11 00 00 00 	movl   $0x0,0x1178
 c09:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0f:	8b 00                	mov    (%eax),%eax
 c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c17:	8b 40 04             	mov    0x4(%eax),%eax
 c1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c1d:	72 4d                	jb     c6c <malloc+0xa6>
      if(p->s.size == nunits)
 c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c22:	8b 40 04             	mov    0x4(%eax),%eax
 c25:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c28:	75 0c                	jne    c36 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2d:	8b 10                	mov    (%eax),%edx
 c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c32:	89 10                	mov    %edx,(%eax)
 c34:	eb 26                	jmp    c5c <malloc+0x96>
      else {
        p->s.size -= nunits;
 c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c39:	8b 40 04             	mov    0x4(%eax),%eax
 c3c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c3f:	89 c2                	mov    %eax,%edx
 c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c44:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4a:	8b 40 04             	mov    0x4(%eax),%eax
 c4d:	c1 e0 03             	shl    $0x3,%eax
 c50:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c56:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c59:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5f:	a3 7c 11 00 00       	mov    %eax,0x117c
      return (void*)(p + 1);
 c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c67:	83 c0 08             	add    $0x8,%eax
 c6a:	eb 3b                	jmp    ca7 <malloc+0xe1>
    }
    if(p == freep)
 c6c:	a1 7c 11 00 00       	mov    0x117c,%eax
 c71:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c74:	75 1e                	jne    c94 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 c76:	83 ec 0c             	sub    $0xc,%esp
 c79:	ff 75 ec             	pushl  -0x14(%ebp)
 c7c:	e8 e5 fe ff ff       	call   b66 <morecore>
 c81:	83 c4 10             	add    $0x10,%esp
 c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c8b:	75 07                	jne    c94 <malloc+0xce>
        return 0;
 c8d:	b8 00 00 00 00       	mov    $0x0,%eax
 c92:	eb 13                	jmp    ca7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9d:	8b 00                	mov    (%eax),%eax
 c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ca2:	e9 6d ff ff ff       	jmp    c14 <malloc+0x4e>
}
 ca7:	c9                   	leave  
 ca8:	c3                   	ret    
