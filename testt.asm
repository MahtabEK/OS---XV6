
_testt:     file format elf32-i386


Disassembly of section .text:

00000000 <myPrint>:
#include "types.h"
#include "stat.h"
#include "user.h"

void myPrint(int pid){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  for(int t = 0 ; t < 10 ; t++ ){
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 19                	jmp    28 <myPrint+0x28>
    printf(2, "child id is %d\n", pid);
   f:	83 ec 04             	sub    $0x4,%esp
  12:	ff 75 08             	pushl  0x8(%ebp)
  15:	68 e8 0b 00 00       	push   $0xbe8
  1a:	6a 02                	push   $0x2
  1c:	e8 0e 08 00 00       	call   82f <printf>
  21:	83 c4 10             	add    $0x10,%esp
#include "types.h"
#include "stat.h"
#include "user.h"

void myPrint(int pid){
  for(int t = 0 ; t < 10 ; t++ ){
  24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  28:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  2c:	7e e1                	jle    f <myPrint+0xf>
    printf(2, "child id is %d\n", pid);
  }
  exit();
  2e:	e8 6d 06 00 00       	call   6a0 <exit>

00000033 <main>:
}

int main(){
  33:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  37:	83 e4 f0             	and    $0xfffffff0,%esp
  3a:	ff 71 fc             	pushl  -0x4(%ecx)
  3d:	55                   	push   %ebp
  3e:	89 e5                	mov    %esp,%ebp
  40:	53                   	push   %ebx
  41:	51                   	push   %ecx
  42:	81 ec b0 01 00 00    	sub    $0x1b0,%esp

  int pid[30], rutime[30], rtime[30];

  for( int i = 0 ; i < 30 ; i++ ){
  48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4f:	e9 e7 00 00 00       	jmp    13b <main+0x108>
    pid[i] = fork();
  54:	e8 3f 06 00 00       	call   698 <fork>
  59:	89 c2                	mov    %eax,%edx
  5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5e:	89 94 85 44 ff ff ff 	mov    %edx,-0xbc(%ebp,%eax,4)
    if( pid[i] < 0 ) {
  65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  68:	8b 84 85 44 ff ff ff 	mov    -0xbc(%ebp,%eax,4),%eax
  6f:	85 c0                	test   %eax,%eax
  71:	79 1c                	jns    8f <main+0x5c>
      printf(1, "error\n");
  73:	83 ec 08             	sub    $0x8,%esp
  76:	68 f8 0b 00 00       	push   $0xbf8
  7b:	6a 01                	push   $0x1
  7d:	e8 ad 07 00 00       	call   82f <printf>
  82:	83 c4 10             	add    $0x10,%esp
      return -1;
  85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8a:	e9 b0 03 00 00       	jmp    43f <main+0x40c>
    }
    else if( pid[i] == 0 ){//child
  8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  92:	8b 84 85 44 ff ff ff 	mov    -0xbc(%ebp,%eax,4),%eax
  99:	85 c0                	test   %eax,%eax
  9b:	0f 85 96 00 00 00    	jne    137 <main+0x104>
      int j = i % 3;
  a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  a4:	ba 56 55 55 55       	mov    $0x55555556,%edx
  a9:	89 c8                	mov    %ecx,%eax
  ab:	f7 ea                	imul   %edx
  ad:	89 c8                	mov    %ecx,%eax
  af:	c1 f8 1f             	sar    $0x1f,%eax
  b2:	29 c2                	sub    %eax,%edx
  b4:	89 d0                	mov    %edx,%eax
  b6:	01 c0                	add    %eax,%eax
  b8:	01 d0                	add    %edx,%eax
  ba:	29 c1                	sub    %eax,%ecx
  bc:	89 c8                	mov    %ecx,%eax
  be:	89 45 bc             	mov    %eax,-0x44(%ebp)
      if( j == 0 ){ //priority = 1
  c1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  c5:	75 24                	jne    eb <main+0xb8>
        //nice();
        nice(getpid());
  c7:	e8 54 06 00 00       	call   720 <getpid>
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	50                   	push   %eax
  d0:	e8 7b 06 00 00       	call   750 <nice>
  d5:	83 c4 10             	add    $0x10,%esp
        myPrint(getpid());
  d8:	e8 43 06 00 00       	call   720 <getpid>
  dd:	83 ec 0c             	sub    $0xc,%esp
  e0:	50                   	push   %eax
  e1:	e8 1a ff ff ff       	call   0 <myPrint>
  e6:	83 c4 10             	add    $0x10,%esp
  e9:	eb 4c                	jmp    137 <main+0x104>
      }
      else if( j == 1 ){ //priority = 0
  eb:	83 7d bc 01          	cmpl   $0x1,-0x44(%ebp)
  ef:	75 35                	jne    126 <main+0xf3>
        nice(getpid());
  f1:	e8 2a 06 00 00       	call   720 <getpid>
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	50                   	push   %eax
  fa:	e8 51 06 00 00       	call   750 <nice>
  ff:	83 c4 10             	add    $0x10,%esp
        nice(getpid());
 102:	e8 19 06 00 00       	call   720 <getpid>
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	50                   	push   %eax
 10b:	e8 40 06 00 00       	call   750 <nice>
 110:	83 c4 10             	add    $0x10,%esp
        //nice();
        //printf(2,"%d***********\n",nice(getpid()));
        myPrint(getpid());
 113:	e8 08 06 00 00       	call   720 <getpid>
 118:	83 ec 0c             	sub    $0xc,%esp
 11b:	50                   	push   %eax
 11c:	e8 df fe ff ff       	call   0 <myPrint>
 121:	83 c4 10             	add    $0x10,%esp
 124:	eb 11                	jmp    137 <main+0x104>
      }
      else {//priority = 2
        myPrint(getpid());
 126:	e8 f5 05 00 00       	call   720 <getpid>
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	50                   	push   %eax
 12f:	e8 cc fe ff ff       	call   0 <myPrint>
 134:	83 c4 10             	add    $0x10,%esp

int main(){

  int pid[30], rutime[30], rtime[30];

  for( int i = 0 ; i < 30 ; i++ ){
 137:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 13b:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
 13f:	0f 8e 0f ff ff ff    	jle    54 <main+0x21>
    else{//parent
      ;
    }
  }

  for(int i = 0 ; i < 30 ; i++ ){
 145:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 14c:	eb 2d                	jmp    17b <main+0x148>
    wait2( &rtime[i], &rutime[i]  );
 14e:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
 154:	8b 55 f0             	mov    -0x10(%ebp),%edx
 157:	c1 e2 02             	shl    $0x2,%edx
 15a:	01 c2                	add    %eax,%edx
 15c:	8d 85 54 fe ff ff    	lea    -0x1ac(%ebp),%eax
 162:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 165:	c1 e1 02             	shl    $0x2,%ecx
 168:	01 c8                	add    %ecx,%eax
 16a:	83 ec 08             	sub    $0x8,%esp
 16d:	52                   	push   %edx
 16e:	50                   	push   %eax
 16f:	e8 d4 05 00 00       	call   748 <wait2>
 174:	83 c4 10             	add    $0x10,%esp
    else{//parent
      ;
    }
  }

  for(int i = 0 ; i < 30 ; i++ ){
 177:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 17b:	83 7d f0 1d          	cmpl   $0x1d,-0x10(%ebp)
 17f:	7e cd                	jle    14e <main+0x11b>
    wait2( &rtime[i], &rutime[i]  );
  }

  printf(1, "--------------------------\n");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 ff 0b 00 00       	push   $0xbff
 189:	6a 01                	push   $0x1
 18b:	e8 9f 06 00 00       	call   82f <printf>
 190:	83 c4 10             	add    $0x10,%esp
  int wsum0 = 0, wsum1 = 0, wsum2 = 0;
 193:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 19a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 1a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int tsum0 = 0, tsum1 = 0, tsum2 = 0;
 1a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 1af:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1b6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  int c0 = 0, c1 = 0, c2 = 0;
 1bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 1c4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 1cb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  int wsumT = 0, tsumT = 0;
 1d2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 1d9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  for(int i = 0 ; i < 30 ; i++ ){
 1e0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 1e7:	e9 4e 01 00 00       	jmp    33a <main+0x307>


    printf(1, "child %d : running time = %d, waiting time = %d, turnaroundtime = %d\n", pid[i], rutime[i], rtime[i], (rutime[i]+rtime[i]));
 1ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1ef:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 1f6:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1f9:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 200:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 203:	8b 45 c0             	mov    -0x40(%ebp),%eax
 206:	8b 8c 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%ecx
 20d:	8b 45 c0             	mov    -0x40(%ebp),%eax
 210:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 217:	8b 45 c0             	mov    -0x40(%ebp),%eax
 21a:	8b 84 85 44 ff ff ff 	mov    -0xbc(%ebp,%eax,4),%eax
 221:	83 ec 08             	sub    $0x8,%esp
 224:	53                   	push   %ebx
 225:	51                   	push   %ecx
 226:	52                   	push   %edx
 227:	50                   	push   %eax
 228:	68 1c 0c 00 00       	push   $0xc1c
 22d:	6a 01                	push   $0x1
 22f:	e8 fb 05 00 00       	call   82f <printf>
 234:	83 c4 20             	add    $0x20,%esp
    printf(1, "--------------------------\n");
 237:	83 ec 08             	sub    $0x8,%esp
 23a:	68 ff 0b 00 00       	push   $0xbff
 23f:	6a 01                	push   $0x1
 241:	e8 e9 05 00 00       	call   82f <printf>
 246:	83 c4 10             	add    $0x10,%esp

    wsumT += rtime[i] ;
 249:	8b 45 c0             	mov    -0x40(%ebp),%eax
 24c:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 253:	01 45 c8             	add    %eax,-0x38(%ebp)
    tsumT += rutime[i] + rtime[i];
 256:	8b 45 c0             	mov    -0x40(%ebp),%eax
 259:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 260:	8b 45 c0             	mov    -0x40(%ebp),%eax
 263:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	01 45 c4             	add    %eax,-0x3c(%ebp)

    if( i % 3 == 0 ){
 26f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 272:	ba 56 55 55 55       	mov    $0x55555556,%edx
 277:	89 c8                	mov    %ecx,%eax
 279:	f7 ea                	imul   %edx
 27b:	89 c8                	mov    %ecx,%eax
 27d:	c1 f8 1f             	sar    $0x1f,%eax
 280:	29 c2                	sub    %eax,%edx
 282:	89 d0                	mov    %edx,%eax
 284:	89 c2                	mov    %eax,%edx
 286:	01 d2                	add    %edx,%edx
 288:	01 c2                	add    %eax,%edx
 28a:	89 c8                	mov    %ecx,%eax
 28c:	29 d0                	sub    %edx,%eax
 28e:	85 c0                	test   %eax,%eax
 290:	75 2c                	jne    2be <main+0x28b>
      wsum1 += rtime[i];
 292:	8b 45 c0             	mov    -0x40(%ebp),%eax
 295:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 29c:	01 45 e8             	add    %eax,-0x18(%ebp)
      tsum1 += rutime[i] + rtime[i];
 29f:	8b 45 c0             	mov    -0x40(%ebp),%eax
 2a2:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 2a9:	8b 45 c0             	mov    -0x40(%ebp),%eax
 2ac:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	01 45 dc             	add    %eax,-0x24(%ebp)
      c1++;
 2b8:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 2bc:	eb 78                	jmp    336 <main+0x303>
    }
    else if ( i % 3 == 1 ){
 2be:	8b 4d c0             	mov    -0x40(%ebp),%ecx
 2c1:	ba 56 55 55 55       	mov    $0x55555556,%edx
 2c6:	89 c8                	mov    %ecx,%eax
 2c8:	f7 ea                	imul   %edx
 2ca:	89 c8                	mov    %ecx,%eax
 2cc:	c1 f8 1f             	sar    $0x1f,%eax
 2cf:	29 c2                	sub    %eax,%edx
 2d1:	89 d0                	mov    %edx,%eax
 2d3:	01 c0                	add    %eax,%eax
 2d5:	01 d0                	add    %edx,%eax
 2d7:	29 c1                	sub    %eax,%ecx
 2d9:	89 ca                	mov    %ecx,%edx
 2db:	83 fa 01             	cmp    $0x1,%edx
 2de:	75 2c                	jne    30c <main+0x2d9>
      wsum0 += rtime[i];
 2e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
 2e3:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 2ea:	01 45 ec             	add    %eax,-0x14(%ebp)
      tsum0 += rutime[i] + rtime[i];
 2ed:	8b 45 c0             	mov    -0x40(%ebp),%eax
 2f0:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 2f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 2fa:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 45 e0             	add    %eax,-0x20(%ebp)
      c0++;
 306:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 30a:	eb 2a                	jmp    336 <main+0x303>
    }
    else {
      wsum2 += rtime[i];
 30c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 30f:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 316:	01 45 e4             	add    %eax,-0x1c(%ebp)
      tsum2 += rutime[i] + rtime[i];
 319:	8b 45 c0             	mov    -0x40(%ebp),%eax
 31c:	8b 94 85 cc fe ff ff 	mov    -0x134(%ebp,%eax,4),%edx
 323:	8b 45 c0             	mov    -0x40(%ebp),%eax
 326:	8b 84 85 54 fe ff ff 	mov    -0x1ac(%ebp,%eax,4),%eax
 32d:	01 d0                	add    %edx,%eax
 32f:	01 45 d8             	add    %eax,-0x28(%ebp)
      c2++;
 332:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
  printf(1, "--------------------------\n");
  int wsum0 = 0, wsum1 = 0, wsum2 = 0;
  int tsum0 = 0, tsum1 = 0, tsum2 = 0;
  int c0 = 0, c1 = 0, c2 = 0;
  int wsumT = 0, tsumT = 0;
  for(int i = 0 ; i < 30 ; i++ ){
 336:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
 33a:	83 7d c0 1d          	cmpl   $0x1d,-0x40(%ebp)
 33e:	0f 8e a8 fe ff ff    	jle    1ec <main+0x1b9>

//  double waverage, taverage;
//  float fl = 12.34;
//  printf(1,"*****\n%f\n", fl);

  printf(1, "--------------------------\n");
 344:	83 ec 08             	sub    $0x8,%esp
 347:	68 ff 0b 00 00       	push   $0xbff
 34c:	6a 01                	push   $0x1
 34e:	e8 dc 04 00 00       	call   82f <printf>
 353:	83 c4 10             	add    $0x10,%esp
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "total average : turnedround = %d , waiting time = %d\n", tsumT/30, wsumT/30);
 356:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 359:	ba 89 88 88 88       	mov    $0x88888889,%edx
 35e:	89 c8                	mov    %ecx,%eax
 360:	f7 ea                	imul   %edx
 362:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 365:	c1 f8 04             	sar    $0x4,%eax
 368:	89 c2                	mov    %eax,%edx
 36a:	89 c8                	mov    %ecx,%eax
 36c:	c1 f8 1f             	sar    $0x1f,%eax
 36f:	89 d3                	mov    %edx,%ebx
 371:	29 c3                	sub    %eax,%ebx
 373:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 376:	ba 89 88 88 88       	mov    $0x88888889,%edx
 37b:	89 c8                	mov    %ecx,%eax
 37d:	f7 ea                	imul   %edx
 37f:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 382:	c1 f8 04             	sar    $0x4,%eax
 385:	89 c2                	mov    %eax,%edx
 387:	89 c8                	mov    %ecx,%eax
 389:	c1 f8 1f             	sar    $0x1f,%eax
 38c:	29 c2                	sub    %eax,%edx
 38e:	89 d0                	mov    %edx,%eax
 390:	53                   	push   %ebx
 391:	50                   	push   %eax
 392:	68 64 0c 00 00       	push   $0xc64
 397:	6a 01                	push   $0x1
 399:	e8 91 04 00 00       	call   82f <printf>
 39e:	83 c4 10             	add    $0x10,%esp
  printf(1, "--------------------------\n");
 3a1:	83 ec 08             	sub    $0x8,%esp
 3a4:	68 ff 0b 00 00       	push   $0xbff
 3a9:	6a 01                	push   $0x1
 3ab:	e8 7f 04 00 00       	call   82f <printf>
 3b0:	83 c4 10             	add    $0x10,%esp
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 2 average : turnedround = %d , waiting time = %d\n", tsum2/c2, wsum2/c2);
 3b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3b6:	99                   	cltd   
 3b7:	f7 7d cc             	idivl  -0x34(%ebp)
 3ba:	89 c1                	mov    %eax,%ecx
 3bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
 3bf:	99                   	cltd   
 3c0:	f7 7d cc             	idivl  -0x34(%ebp)
 3c3:	51                   	push   %ecx
 3c4:	50                   	push   %eax
 3c5:	68 9c 0c 00 00       	push   $0xc9c
 3ca:	6a 01                	push   $0x1
 3cc:	e8 5e 04 00 00       	call   82f <printf>
 3d1:	83 c4 10             	add    $0x10,%esp
  printf(1, "--------------------------\n");
 3d4:	83 ec 08             	sub    $0x8,%esp
 3d7:	68 ff 0b 00 00       	push   $0xbff
 3dc:	6a 01                	push   $0x1
 3de:	e8 4c 04 00 00       	call   82f <printf>
 3e3:	83 c4 10             	add    $0x10,%esp
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 1 average : turnedround = %d , waiting time = %d\n", tsum1/c1, wsum1/c1);
 3e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3e9:	99                   	cltd   
 3ea:	f7 7d d0             	idivl  -0x30(%ebp)
 3ed:	89 c1                	mov    %eax,%ecx
 3ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3f2:	99                   	cltd   
 3f3:	f7 7d d0             	idivl  -0x30(%ebp)
 3f6:	51                   	push   %ecx
 3f7:	50                   	push   %eax
 3f8:	68 d8 0c 00 00       	push   $0xcd8
 3fd:	6a 01                	push   $0x1
 3ff:	e8 2b 04 00 00       	call   82f <printf>
 404:	83 c4 10             	add    $0x10,%esp
  printf(1, "--------------------------\n");
 407:	83 ec 08             	sub    $0x8,%esp
 40a:	68 ff 0b 00 00       	push   $0xbff
 40f:	6a 01                	push   $0x1
 411:	e8 19 04 00 00       	call   82f <printf>
 416:	83 c4 10             	add    $0x10,%esp
//  waverage = ((double)tsumT/(double)30);
//  taverage = ((double)wsumT/(double)30);
  printf(1, "priority 0 average : turnedround = %d , waiting time = %d\n", tsum0/c0, wsum0/c0);
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	99                   	cltd   
 41d:	f7 7d d4             	idivl  -0x2c(%ebp)
 420:	89 c1                	mov    %eax,%ecx
 422:	8b 45 e0             	mov    -0x20(%ebp),%eax
 425:	99                   	cltd   
 426:	f7 7d d4             	idivl  -0x2c(%ebp)
 429:	51                   	push   %ecx
 42a:	50                   	push   %eax
 42b:	68 14 0d 00 00       	push   $0xd14
 430:	6a 01                	push   $0x1
 432:	e8 f8 03 00 00       	call   82f <printf>
 437:	83 c4 10             	add    $0x10,%esp

  return 0;
 43a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 442:	59                   	pop    %ecx
 443:	5b                   	pop    %ebx
 444:	5d                   	pop    %ebp
 445:	8d 61 fc             	lea    -0x4(%ecx),%esp
 448:	c3                   	ret    

00000449 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	57                   	push   %edi
 44d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 44e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 451:	8b 55 10             	mov    0x10(%ebp),%edx
 454:	8b 45 0c             	mov    0xc(%ebp),%eax
 457:	89 cb                	mov    %ecx,%ebx
 459:	89 df                	mov    %ebx,%edi
 45b:	89 d1                	mov    %edx,%ecx
 45d:	fc                   	cld    
 45e:	f3 aa                	rep stos %al,%es:(%edi)
 460:	89 ca                	mov    %ecx,%edx
 462:	89 fb                	mov    %edi,%ebx
 464:	89 5d 08             	mov    %ebx,0x8(%ebp)
 467:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 46a:	90                   	nop
 46b:	5b                   	pop    %ebx
 46c:	5f                   	pop    %edi
 46d:	5d                   	pop    %ebp
 46e:	c3                   	ret    

0000046f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 47b:	90                   	nop
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	8d 50 01             	lea    0x1(%eax),%edx
 482:	89 55 08             	mov    %edx,0x8(%ebp)
 485:	8b 55 0c             	mov    0xc(%ebp),%edx
 488:	8d 4a 01             	lea    0x1(%edx),%ecx
 48b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 48e:	0f b6 12             	movzbl (%edx),%edx
 491:	88 10                	mov    %dl,(%eax)
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	84 c0                	test   %al,%al
 498:	75 e2                	jne    47c <strcpy+0xd>
    ;
  return os;
 49a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 49d:	c9                   	leave  
 49e:	c3                   	ret    

0000049f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 49f:	55                   	push   %ebp
 4a0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4a2:	eb 08                	jmp    4ac <strcmp+0xd>
    p++, q++;
 4a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	84 c0                	test   %al,%al
 4b4:	74 10                	je     4c6 <strcmp+0x27>
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	0f b6 10             	movzbl (%eax),%edx
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	0f b6 00             	movzbl (%eax),%eax
 4c2:	38 c2                	cmp    %al,%dl
 4c4:	74 de                	je     4a4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	0f b6 00             	movzbl (%eax),%eax
 4cc:	0f b6 d0             	movzbl %al,%edx
 4cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f b6 c0             	movzbl %al,%eax
 4d8:	29 c2                	sub    %eax,%edx
 4da:	89 d0                	mov    %edx,%eax
}
 4dc:	5d                   	pop    %ebp
 4dd:	c3                   	ret    

000004de <strlen>:

uint
strlen(char *s)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4eb:	eb 04                	jmp    4f1 <strlen+0x13>
 4ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	01 d0                	add    %edx,%eax
 4f9:	0f b6 00             	movzbl (%eax),%eax
 4fc:	84 c0                	test   %al,%al
 4fe:	75 ed                	jne    4ed <strlen+0xf>
    ;
  return n;
 500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 503:	c9                   	leave  
 504:	c3                   	ret    

00000505 <memset>:

void*
memset(void *dst, int c, uint n)
{
 505:	55                   	push   %ebp
 506:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 508:	8b 45 10             	mov    0x10(%ebp),%eax
 50b:	50                   	push   %eax
 50c:	ff 75 0c             	pushl  0xc(%ebp)
 50f:	ff 75 08             	pushl  0x8(%ebp)
 512:	e8 32 ff ff ff       	call   449 <stosb>
 517:	83 c4 0c             	add    $0xc,%esp
  return dst;
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <strchr>:

char*
strchr(const char *s, char c)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 04             	sub    $0x4,%esp
 525:	8b 45 0c             	mov    0xc(%ebp),%eax
 528:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 52b:	eb 14                	jmp    541 <strchr+0x22>
    if(*s == c)
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	3a 45 fc             	cmp    -0x4(%ebp),%al
 536:	75 05                	jne    53d <strchr+0x1e>
      return (char*)s;
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	eb 13                	jmp    550 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 53d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	84 c0                	test   %al,%al
 549:	75 e2                	jne    52d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 54b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 550:	c9                   	leave  
 551:	c3                   	ret    

00000552 <gets>:

char*
gets(char *buf, int max)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 55f:	eb 42                	jmp    5a3 <gets+0x51>
    cc = read(0, &c, 1);
 561:	83 ec 04             	sub    $0x4,%esp
 564:	6a 01                	push   $0x1
 566:	8d 45 ef             	lea    -0x11(%ebp),%eax
 569:	50                   	push   %eax
 56a:	6a 00                	push   $0x0
 56c:	e8 47 01 00 00       	call   6b8 <read>
 571:	83 c4 10             	add    $0x10,%esp
 574:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57b:	7e 33                	jle    5b0 <gets+0x5e>
      break;
    buf[i++] = c;
 57d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 580:	8d 50 01             	lea    0x1(%eax),%edx
 583:	89 55 f4             	mov    %edx,-0xc(%ebp)
 586:	89 c2                	mov    %eax,%edx
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	01 c2                	add    %eax,%edx
 58d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 591:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 593:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 597:	3c 0a                	cmp    $0xa,%al
 599:	74 16                	je     5b1 <gets+0x5f>
 59b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 59f:	3c 0d                	cmp    $0xd,%al
 5a1:	74 0e                	je     5b1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	83 c0 01             	add    $0x1,%eax
 5a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5ac:	7c b3                	jl     561 <gets+0xf>
 5ae:	eb 01                	jmp    5b1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 5b0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	01 d0                	add    %edx,%eax
 5b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5bf:	c9                   	leave  
 5c0:	c3                   	ret    

000005c1 <stat>:

int
stat(char *n, struct stat *st)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	6a 00                	push   $0x0
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 0c 01 00 00       	call   6e0 <open>
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5de:	79 07                	jns    5e7 <stat+0x26>
    return -1;
 5e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5e5:	eb 25                	jmp    60c <stat+0x4b>
  r = fstat(fd, st);
 5e7:	83 ec 08             	sub    $0x8,%esp
 5ea:	ff 75 0c             	pushl  0xc(%ebp)
 5ed:	ff 75 f4             	pushl  -0xc(%ebp)
 5f0:	e8 03 01 00 00       	call   6f8 <fstat>
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5fb:	83 ec 0c             	sub    $0xc,%esp
 5fe:	ff 75 f4             	pushl  -0xc(%ebp)
 601:	e8 c2 00 00 00       	call   6c8 <close>
 606:	83 c4 10             	add    $0x10,%esp
  return r;
 609:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 60c:	c9                   	leave  
 60d:	c3                   	ret    

0000060e <atoi>:

int
atoi(const char *s)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 61b:	eb 25                	jmp    642 <atoi+0x34>
    n = n*10 + *s++ - '0';
 61d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 620:	89 d0                	mov    %edx,%eax
 622:	c1 e0 02             	shl    $0x2,%eax
 625:	01 d0                	add    %edx,%eax
 627:	01 c0                	add    %eax,%eax
 629:	89 c1                	mov    %eax,%ecx
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	8d 50 01             	lea    0x1(%eax),%edx
 631:	89 55 08             	mov    %edx,0x8(%ebp)
 634:	0f b6 00             	movzbl (%eax),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	01 c8                	add    %ecx,%eax
 63c:	83 e8 30             	sub    $0x30,%eax
 63f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 642:	8b 45 08             	mov    0x8(%ebp),%eax
 645:	0f b6 00             	movzbl (%eax),%eax
 648:	3c 2f                	cmp    $0x2f,%al
 64a:	7e 0a                	jle    656 <atoi+0x48>
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	0f b6 00             	movzbl (%eax),%eax
 652:	3c 39                	cmp    $0x39,%al
 654:	7e c7                	jle    61d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 659:	c9                   	leave  
 65a:	c3                   	ret    

0000065b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 667:	8b 45 0c             	mov    0xc(%ebp),%eax
 66a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 66d:	eb 17                	jmp    686 <memmove+0x2b>
    *dst++ = *src++;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8d 50 01             	lea    0x1(%eax),%edx
 675:	89 55 fc             	mov    %edx,-0x4(%ebp)
 678:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67b:	8d 4a 01             	lea    0x1(%edx),%ecx
 67e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 681:	0f b6 12             	movzbl (%edx),%edx
 684:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 686:	8b 45 10             	mov    0x10(%ebp),%eax
 689:	8d 50 ff             	lea    -0x1(%eax),%edx
 68c:	89 55 10             	mov    %edx,0x10(%ebp)
 68f:	85 c0                	test   %eax,%eax
 691:	7f dc                	jg     66f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 693:	8b 45 08             	mov    0x8(%ebp),%eax
}
 696:	c9                   	leave  
 697:	c3                   	ret    

00000698 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 698:	b8 01 00 00 00       	mov    $0x1,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <exit>:
SYSCALL(exit)
 6a0:	b8 02 00 00 00       	mov    $0x2,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <wait>:
SYSCALL(wait)
 6a8:	b8 03 00 00 00       	mov    $0x3,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <pipe>:
SYSCALL(pipe)
 6b0:	b8 04 00 00 00       	mov    $0x4,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <read>:
SYSCALL(read)
 6b8:	b8 05 00 00 00       	mov    $0x5,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <write>:
SYSCALL(write)
 6c0:	b8 10 00 00 00       	mov    $0x10,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <close>:
SYSCALL(close)
 6c8:	b8 15 00 00 00       	mov    $0x15,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <kill>:
SYSCALL(kill)
 6d0:	b8 06 00 00 00       	mov    $0x6,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <exec>:
SYSCALL(exec)
 6d8:	b8 07 00 00 00       	mov    $0x7,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <open>:
SYSCALL(open)
 6e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <mknod>:
SYSCALL(mknod)
 6e8:	b8 11 00 00 00       	mov    $0x11,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <unlink>:
SYSCALL(unlink)
 6f0:	b8 12 00 00 00       	mov    $0x12,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <fstat>:
SYSCALL(fstat)
 6f8:	b8 08 00 00 00       	mov    $0x8,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <link>:
SYSCALL(link)
 700:	b8 13 00 00 00       	mov    $0x13,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <mkdir>:
SYSCALL(mkdir)
 708:	b8 14 00 00 00       	mov    $0x14,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <chdir>:
SYSCALL(chdir)
 710:	b8 09 00 00 00       	mov    $0x9,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <dup>:
SYSCALL(dup)
 718:	b8 0a 00 00 00       	mov    $0xa,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <getpid>:
SYSCALL(getpid)
 720:	b8 0b 00 00 00       	mov    $0xb,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <sbrk>:
SYSCALL(sbrk)
 728:	b8 0c 00 00 00       	mov    $0xc,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <sleep>:
SYSCALL(sleep)
 730:	b8 0d 00 00 00       	mov    $0xd,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <uptime>:
SYSCALL(uptime)
 738:	b8 0e 00 00 00       	mov    $0xe,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <getppid>:
SYSCALL(getppid)
 740:	b8 16 00 00 00       	mov    $0x16,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <wait2>:
SYSCALL(wait2)
 748:	b8 18 00 00 00       	mov    $0x18,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <nice>:
SYSCALL(nice)
 750:	b8 17 00 00 00       	mov    $0x17,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
 75e:	8b 45 0c             	mov    0xc(%ebp),%eax
 761:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 764:	83 ec 04             	sub    $0x4,%esp
 767:	6a 01                	push   $0x1
 769:	8d 45 f4             	lea    -0xc(%ebp),%eax
 76c:	50                   	push   %eax
 76d:	ff 75 08             	pushl  0x8(%ebp)
 770:	e8 4b ff ff ff       	call   6c0 <write>
 775:	83 c4 10             	add    $0x10,%esp
}
 778:	90                   	nop
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	53                   	push   %ebx
 77f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 782:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 789:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 78d:	74 17                	je     7a6 <printint+0x2b>
 78f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 793:	79 11                	jns    7a6 <printint+0x2b>
    neg = 1;
 795:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 79c:	8b 45 0c             	mov    0xc(%ebp),%eax
 79f:	f7 d8                	neg    %eax
 7a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a4:	eb 06                	jmp    7ac <printint+0x31>
  } else {
    x = xx;
 7a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7b6:	8d 41 01             	lea    0x1(%ecx),%eax
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c2:	ba 00 00 00 00       	mov    $0x0,%edx
 7c7:	f7 f3                	div    %ebx
 7c9:	89 d0                	mov    %edx,%eax
 7cb:	0f b6 80 d0 0f 00 00 	movzbl 0xfd0(%eax),%eax
 7d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7dc:	ba 00 00 00 00       	mov    $0x0,%edx
 7e1:	f7 f3                	div    %ebx
 7e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ea:	75 c7                	jne    7b3 <printint+0x38>
  if(neg)
 7ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f0:	74 2d                	je     81f <printint+0xa4>
    buf[i++] = '-';
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8d 50 01             	lea    0x1(%eax),%edx
 7f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 800:	eb 1d                	jmp    81f <printint+0xa4>
    putc(fd, buf[i]);
 802:	8d 55 dc             	lea    -0x24(%ebp),%edx
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	01 d0                	add    %edx,%eax
 80a:	0f b6 00             	movzbl (%eax),%eax
 80d:	0f be c0             	movsbl %al,%eax
 810:	83 ec 08             	sub    $0x8,%esp
 813:	50                   	push   %eax
 814:	ff 75 08             	pushl  0x8(%ebp)
 817:	e8 3c ff ff ff       	call   758 <putc>
 81c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 81f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 827:	79 d9                	jns    802 <printint+0x87>
    putc(fd, buf[i]);
}
 829:	90                   	nop
 82a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 835:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 83c:	8d 45 0c             	lea    0xc(%ebp),%eax
 83f:	83 c0 04             	add    $0x4,%eax
 842:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 845:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 84c:	e9 59 01 00 00       	jmp    9aa <printf+0x17b>
    c = fmt[i] & 0xff;
 851:	8b 55 0c             	mov    0xc(%ebp),%edx
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	01 d0                	add    %edx,%eax
 859:	0f b6 00             	movzbl (%eax),%eax
 85c:	0f be c0             	movsbl %al,%eax
 85f:	25 ff 00 00 00       	and    $0xff,%eax
 864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 867:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 86b:	75 2c                	jne    899 <printf+0x6a>
      if(c == '%'){
 86d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 871:	75 0c                	jne    87f <printf+0x50>
        state = '%';
 873:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 87a:	e9 27 01 00 00       	jmp    9a6 <printf+0x177>
      } else {
        putc(fd, c);
 87f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 882:	0f be c0             	movsbl %al,%eax
 885:	83 ec 08             	sub    $0x8,%esp
 888:	50                   	push   %eax
 889:	ff 75 08             	pushl  0x8(%ebp)
 88c:	e8 c7 fe ff ff       	call   758 <putc>
 891:	83 c4 10             	add    $0x10,%esp
 894:	e9 0d 01 00 00       	jmp    9a6 <printf+0x177>
      }
    } else if(state == '%'){
 899:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 89d:	0f 85 03 01 00 00    	jne    9a6 <printf+0x177>
      if(c == 'd'){
 8a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8a7:	75 1e                	jne    8c7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 8a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	6a 01                	push   $0x1
 8b0:	6a 0a                	push   $0xa
 8b2:	50                   	push   %eax
 8b3:	ff 75 08             	pushl  0x8(%ebp)
 8b6:	e8 c0 fe ff ff       	call   77b <printint>
 8bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 8be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c2:	e9 d8 00 00 00       	jmp    99f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8c7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8cb:	74 06                	je     8d3 <printf+0xa4>
 8cd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8d1:	75 1e                	jne    8f1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	6a 00                	push   $0x0
 8da:	6a 10                	push   $0x10
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 96 fe ff ff       	call   77b <printint>
 8e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ec:	e9 ae 00 00 00       	jmp    99f <printf+0x170>
      } else if(c == 's'){
 8f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8f5:	75 43                	jne    93a <printf+0x10b>
        s = (char*)*ap;
 8f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 907:	75 25                	jne    92e <printf+0xff>
          s = "(null)";
 909:	c7 45 f4 4f 0d 00 00 	movl   $0xd4f,-0xc(%ebp)
        while(*s != 0){
 910:	eb 1c                	jmp    92e <printf+0xff>
          putc(fd, *s);
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	0f b6 00             	movzbl (%eax),%eax
 918:	0f be c0             	movsbl %al,%eax
 91b:	83 ec 08             	sub    $0x8,%esp
 91e:	50                   	push   %eax
 91f:	ff 75 08             	pushl  0x8(%ebp)
 922:	e8 31 fe ff ff       	call   758 <putc>
 927:	83 c4 10             	add    $0x10,%esp
          s++;
 92a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	0f b6 00             	movzbl (%eax),%eax
 934:	84 c0                	test   %al,%al
 936:	75 da                	jne    912 <printf+0xe3>
 938:	eb 65                	jmp    99f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 93a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 93e:	75 1d                	jne    95d <printf+0x12e>
        putc(fd, *ap);
 940:	8b 45 e8             	mov    -0x18(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	0f be c0             	movsbl %al,%eax
 948:	83 ec 08             	sub    $0x8,%esp
 94b:	50                   	push   %eax
 94c:	ff 75 08             	pushl  0x8(%ebp)
 94f:	e8 04 fe ff ff       	call   758 <putc>
 954:	83 c4 10             	add    $0x10,%esp
        ap++;
 957:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 95b:	eb 42                	jmp    99f <printf+0x170>
      } else if(c == '%'){
 95d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 961:	75 17                	jne    97a <printf+0x14b>
        putc(fd, c);
 963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 966:	0f be c0             	movsbl %al,%eax
 969:	83 ec 08             	sub    $0x8,%esp
 96c:	50                   	push   %eax
 96d:	ff 75 08             	pushl  0x8(%ebp)
 970:	e8 e3 fd ff ff       	call   758 <putc>
 975:	83 c4 10             	add    $0x10,%esp
 978:	eb 25                	jmp    99f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 97a:	83 ec 08             	sub    $0x8,%esp
 97d:	6a 25                	push   $0x25
 97f:	ff 75 08             	pushl  0x8(%ebp)
 982:	e8 d1 fd ff ff       	call   758 <putc>
 987:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 98a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 98d:	0f be c0             	movsbl %al,%eax
 990:	83 ec 08             	sub    $0x8,%esp
 993:	50                   	push   %eax
 994:	ff 75 08             	pushl  0x8(%ebp)
 997:	e8 bc fd ff ff       	call   758 <putc>
 99c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 99f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b0:	01 d0                	add    %edx,%eax
 9b2:	0f b6 00             	movzbl (%eax),%eax
 9b5:	84 c0                	test   %al,%al
 9b7:	0f 85 94 fe ff ff    	jne    851 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9bd:	90                   	nop
 9be:	c9                   	leave  
 9bf:	c3                   	ret    

000009c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9c6:	8b 45 08             	mov    0x8(%ebp),%eax
 9c9:	83 e8 08             	sub    $0x8,%eax
 9cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9cf:	a1 ec 0f 00 00       	mov    0xfec,%eax
 9d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9d7:	eb 24                	jmp    9fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	8b 00                	mov    (%eax),%eax
 9de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e1:	77 12                	ja     9f5 <free+0x35>
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e9:	77 24                	ja     a0f <free+0x4f>
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	8b 00                	mov    (%eax),%eax
 9f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9f3:	77 1a                	ja     a0f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	8b 00                	mov    (%eax),%eax
 9fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a03:	76 d4                	jbe    9d9 <free+0x19>
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a0d:	76 ca                	jbe    9d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1f:	01 c2                	add    %eax,%edx
 a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a24:	8b 00                	mov    (%eax),%eax
 a26:	39 c2                	cmp    %eax,%edx
 a28:	75 24                	jne    a4e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2d:	8b 50 04             	mov    0x4(%eax),%edx
 a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a33:	8b 00                	mov    (%eax),%eax
 a35:	8b 40 04             	mov    0x4(%eax),%eax
 a38:	01 c2                	add    %eax,%edx
 a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	8b 10                	mov    (%eax),%edx
 a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4a:	89 10                	mov    %edx,(%eax)
 a4c:	eb 0a                	jmp    a58 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a51:	8b 10                	mov    (%eax),%edx
 a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a56:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5b:	8b 40 04             	mov    0x4(%eax),%eax
 a5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	01 d0                	add    %edx,%eax
 a6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a6d:	75 20                	jne    a8f <free+0xcf>
    p->s.size += bp->s.size;
 a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a72:	8b 50 04             	mov    0x4(%eax),%edx
 a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a78:	8b 40 04             	mov    0x4(%eax),%eax
 a7b:	01 c2                	add    %eax,%edx
 a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a80:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a86:	8b 10                	mov    (%eax),%edx
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	89 10                	mov    %edx,(%eax)
 a8d:	eb 08                	jmp    a97 <free+0xd7>
  } else
    p->s.ptr = bp;
 a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a92:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a95:	89 10                	mov    %edx,(%eax)
  freep = p;
 a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9a:	a3 ec 0f 00 00       	mov    %eax,0xfec
}
 a9f:	90                   	nop
 aa0:	c9                   	leave  
 aa1:	c3                   	ret    

00000aa2 <morecore>:

static Header*
morecore(uint nu)
{
 aa2:	55                   	push   %ebp
 aa3:	89 e5                	mov    %esp,%ebp
 aa5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 aa8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 aaf:	77 07                	ja     ab8 <morecore+0x16>
    nu = 4096;
 ab1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ab8:	8b 45 08             	mov    0x8(%ebp),%eax
 abb:	c1 e0 03             	shl    $0x3,%eax
 abe:	83 ec 0c             	sub    $0xc,%esp
 ac1:	50                   	push   %eax
 ac2:	e8 61 fc ff ff       	call   728 <sbrk>
 ac7:	83 c4 10             	add    $0x10,%esp
 aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 acd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ad1:	75 07                	jne    ada <morecore+0x38>
    return 0;
 ad3:	b8 00 00 00 00       	mov    $0x0,%eax
 ad8:	eb 26                	jmp    b00 <morecore+0x5e>
  hp = (Header*)p;
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae3:	8b 55 08             	mov    0x8(%ebp),%edx
 ae6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aec:	83 c0 08             	add    $0x8,%eax
 aef:	83 ec 0c             	sub    $0xc,%esp
 af2:	50                   	push   %eax
 af3:	e8 c8 fe ff ff       	call   9c0 <free>
 af8:	83 c4 10             	add    $0x10,%esp
  return freep;
 afb:	a1 ec 0f 00 00       	mov    0xfec,%eax
}
 b00:	c9                   	leave  
 b01:	c3                   	ret    

00000b02 <malloc>:

void*
malloc(uint nbytes)
{
 b02:	55                   	push   %ebp
 b03:	89 e5                	mov    %esp,%ebp
 b05:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b08:	8b 45 08             	mov    0x8(%ebp),%eax
 b0b:	83 c0 07             	add    $0x7,%eax
 b0e:	c1 e8 03             	shr    $0x3,%eax
 b11:	83 c0 01             	add    $0x1,%eax
 b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b17:	a1 ec 0f 00 00       	mov    0xfec,%eax
 b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b23:	75 23                	jne    b48 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b25:	c7 45 f0 e4 0f 00 00 	movl   $0xfe4,-0x10(%ebp)
 b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2f:	a3 ec 0f 00 00       	mov    %eax,0xfec
 b34:	a1 ec 0f 00 00       	mov    0xfec,%eax
 b39:	a3 e4 0f 00 00       	mov    %eax,0xfe4
    base.s.size = 0;
 b3e:	c7 05 e8 0f 00 00 00 	movl   $0x0,0xfe8
 b45:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b53:	8b 40 04             	mov    0x4(%eax),%eax
 b56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b59:	72 4d                	jb     ba8 <malloc+0xa6>
      if(p->s.size == nunits)
 b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5e:	8b 40 04             	mov    0x4(%eax),%eax
 b61:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b64:	75 0c                	jne    b72 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b69:	8b 10                	mov    (%eax),%edx
 b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6e:	89 10                	mov    %edx,(%eax)
 b70:	eb 26                	jmp    b98 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b75:	8b 40 04             	mov    0x4(%eax),%eax
 b78:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b7b:	89 c2                	mov    %eax,%edx
 b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b80:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b86:	8b 40 04             	mov    0x4(%eax),%eax
 b89:	c1 e0 03             	shl    $0x3,%eax
 b8c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b92:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b95:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9b:	a3 ec 0f 00 00       	mov    %eax,0xfec
      return (void*)(p + 1);
 ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba3:	83 c0 08             	add    $0x8,%eax
 ba6:	eb 3b                	jmp    be3 <malloc+0xe1>
    }
    if(p == freep)
 ba8:	a1 ec 0f 00 00       	mov    0xfec,%eax
 bad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bb0:	75 1e                	jne    bd0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 bb2:	83 ec 0c             	sub    $0xc,%esp
 bb5:	ff 75 ec             	pushl  -0x14(%ebp)
 bb8:	e8 e5 fe ff ff       	call   aa2 <morecore>
 bbd:	83 c4 10             	add    $0x10,%esp
 bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bc7:	75 07                	jne    bd0 <malloc+0xce>
        return 0;
 bc9:	b8 00 00 00 00       	mov    $0x0,%eax
 bce:	eb 13                	jmp    be3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd9:	8b 00                	mov    (%eax),%eax
 bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bde:	e9 6d ff ff ff       	jmp    b50 <malloc+0x4e>
}
 be3:	c9                   	leave  
 be4:	c3                   	ret    
