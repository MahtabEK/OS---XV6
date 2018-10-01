
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <myPrint>:
#include "types.h"
#include "stat.h"
#include "user.h"

void myPrint(int pid){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
	int j;
	for(j = 0 ; j < 100 ; j++ ){
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 19                	jmp    28 <myPrint+0x28>
		printf(2, "child %d prints for the %d time.\n", pid, j);
   f:	ff 75 f4             	pushl  -0xc(%ebp)
  12:	ff 75 08             	pushl  0x8(%ebp)
  15:	68 3c 09 00 00       	push   $0x93c
  1a:	6a 02                	push   $0x2
  1c:	e8 62 05 00 00       	call   583 <printf>
  21:	83 c4 10             	add    $0x10,%esp
#include "stat.h"
#include "user.h"

void myPrint(int pid){
	int j;
	for(j = 0 ; j < 100 ; j++ ){
  24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  28:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  2c:	7e e1                	jle    f <myPrint+0xf>
		printf(2, "child %d prints for the %d time.\n", pid, j);
	}
	exit();
  2e:	e8 c1 03 00 00       	call   3f4 <exit>

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
  42:	81 ec b0 00 00 00    	sub    $0xb0,%esp

	int pid[10], rtime[10], rutime[10] , stime[10];
	int i = 0;
  48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for( i = 0 ; i < 10 ; i++ ){
  4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  56:	eb 55                	jmp    ad <main+0x7a>
		pid[i] = fork();
  58:	e8 8f 03 00 00       	call   3ec <fork>
  5d:	89 c2                	mov    %eax,%edx
  5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  62:	89 54 85 cc          	mov    %edx,-0x34(%ebp,%eax,4)
		if( pid[i] < 0 ) {
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  6d:	85 c0                	test   %eax,%eax
  6f:	79 1c                	jns    8d <main+0x5a>
			printf(1, "error\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 5e 09 00 00       	push   $0x95e
  79:	6a 01                	push   $0x1
  7b:	e8 03 05 00 00       	call   583 <printf>
  80:	83 c4 10             	add    $0x10,%esp
			return -1;
  83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  88:	e9 06 01 00 00       	jmp    193 <main+0x160>
		}
		else if( pid[i] == 0 ){
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  94:	85 c0                	test   %eax,%eax
  96:	75 11                	jne    a9 <main+0x76>
			myPrint(getpid());
  98:	e8 d7 03 00 00       	call   474 <getpid>
  9d:	83 ec 0c             	sub    $0xc,%esp
  a0:	50                   	push   %eax
  a1:	e8 5a ff ff ff       	call   0 <myPrint>
  a6:	83 c4 10             	add    $0x10,%esp

int main(){

	int pid[10], rtime[10], rutime[10] , stime[10];
	int i = 0;
	for( i = 0 ; i < 10 ; i++ ){
  a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  ad:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  b1:	7e a5                	jle    58 <main+0x25>
		else if( pid[i] == 0 ){
			myPrint(getpid());
		}
	}

	for( i = 0 ; i < 10 ; i++ ){
  b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ba:	eb 3a                	jmp    f6 <main+0xc3>
		wait2( &rtime[i], &rutime[i], &stime[i] );
  bc:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c5:	c1 e2 02             	shl    $0x2,%edx
  c8:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  cb:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  d4:	c1 e2 02             	shl    $0x2,%edx
  d7:	01 c2                	add    %eax,%edx
  d9:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  df:	c1 e3 02             	shl    $0x2,%ebx
  e2:	01 d8                	add    %ebx,%eax
  e4:	83 ec 04             	sub    $0x4,%esp
  e7:	51                   	push   %ecx
  e8:	52                   	push   %edx
  e9:	50                   	push   %eax
  ea:	e8 ad 03 00 00       	call   49c <wait2>
  ef:	83 c4 10             	add    $0x10,%esp
		else if( pid[i] == 0 ){
			myPrint(getpid());
		}
	}

	for( i = 0 ; i < 10 ; i++ ){
  f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  f6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  fa:	7e c0                	jle    bc <main+0x89>
		wait2( &rtime[i], &rutime[i], &stime[i] );
		//wait3( &rtime[i], &rutime[i], &stime[i] );
	}

	printf(1, "--------------------------\n");
  fc:	83 ec 08             	sub    $0x8,%esp
  ff:	68 65 09 00 00       	push   $0x965
 104:	6a 01                	push   $0x1
 106:	e8 78 04 00 00       	call   583 <printf>
 10b:	83 c4 10             	add    $0x10,%esp
	for( i = 0 ; i < 10 ; i++ ){
 10e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 115:	eb 71                	jmp    188 <main+0x155>
		printf(1, "child %d : running time is : %d, waiting time is : %d, turnaroundtime = %d\n", pid[i], rutime[i], (rtime[i]+stime[i]), (rutime[i]+rtime[i]+stime[i]));
 117:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11a:	8b 94 85 7c ff ff ff 	mov    -0x84(%ebp,%eax,4),%edx
 121:	8b 45 f4             	mov    -0xc(%ebp),%eax
 124:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
 128:	01 c2                	add    %eax,%edx
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8b 84 85 54 ff ff ff 	mov    -0xac(%ebp,%eax,4),%eax
 134:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 137:	8b 45 f4             	mov    -0xc(%ebp),%eax
 13a:	8b 54 85 a4          	mov    -0x5c(%ebp,%eax,4),%edx
 13e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 141:	8b 84 85 54 ff ff ff 	mov    -0xac(%ebp,%eax,4),%eax
 148:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 14b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 14e:	8b 94 85 7c ff ff ff 	mov    -0x84(%ebp,%eax,4),%edx
 155:	8b 45 f4             	mov    -0xc(%ebp),%eax
 158:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	53                   	push   %ebx
 160:	51                   	push   %ecx
 161:	52                   	push   %edx
 162:	50                   	push   %eax
 163:	68 84 09 00 00       	push   $0x984
 168:	6a 01                	push   $0x1
 16a:	e8 14 04 00 00       	call   583 <printf>
 16f:	83 c4 20             	add    $0x20,%esp
		printf(1, "--------------------------\n");
 172:	83 ec 08             	sub    $0x8,%esp
 175:	68 65 09 00 00       	push   $0x965
 17a:	6a 01                	push   $0x1
 17c:	e8 02 04 00 00       	call   583 <printf>
 181:	83 c4 10             	add    $0x10,%esp
		wait2( &rtime[i], &rutime[i], &stime[i] );
		//wait3( &rtime[i], &rutime[i], &stime[i] );
	}

	printf(1, "--------------------------\n");
	for( i = 0 ; i < 10 ; i++ ){
 184:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 188:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 18c:	7e 89                	jle    117 <main+0xe4>
		printf(1, "child %d : running time is : %d, waiting time is : %d, turnaroundtime = %d\n", pid[i], rutime[i], (rtime[i]+stime[i]), (rutime[i]+rtime[i]+stime[i]));
		printf(1, "--------------------------\n");
	}

	return 0;
 18e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 193:	8d 65 f8             	lea    -0x8(%ebp),%esp
 196:	59                   	pop    %ecx
 197:	5b                   	pop    %ebx
 198:	5d                   	pop    %ebp
 199:	8d 61 fc             	lea    -0x4(%ecx),%esp
 19c:	c3                   	ret    

0000019d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	57                   	push   %edi
 1a1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a5:	8b 55 10             	mov    0x10(%ebp),%edx
 1a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ab:	89 cb                	mov    %ecx,%ebx
 1ad:	89 df                	mov    %ebx,%edi
 1af:	89 d1                	mov    %edx,%ecx
 1b1:	fc                   	cld    
 1b2:	f3 aa                	rep stos %al,%es:(%edi)
 1b4:	89 ca                	mov    %ecx,%edx
 1b6:	89 fb                	mov    %edi,%ebx
 1b8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1bb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1be:	90                   	nop
 1bf:	5b                   	pop    %ebx
 1c0:	5f                   	pop    %edi
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    

000001c3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1cf:	90                   	nop
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	8d 50 01             	lea    0x1(%eax),%edx
 1d6:	89 55 08             	mov    %edx,0x8(%ebp)
 1d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1e2:	0f b6 12             	movzbl (%edx),%edx
 1e5:	88 10                	mov    %dl,(%eax)
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	84 c0                	test   %al,%al
 1ec:	75 e2                	jne    1d0 <strcpy+0xd>
    ;
  return os;
 1ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1f6:	eb 08                	jmp    200 <strcmp+0xd>
    p++, q++;
 1f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	84 c0                	test   %al,%al
 208:	74 10                	je     21a <strcmp+0x27>
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 10             	movzbl (%eax),%edx
 210:	8b 45 0c             	mov    0xc(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	38 c2                	cmp    %al,%dl
 218:	74 de                	je     1f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	0f b6 d0             	movzbl %al,%edx
 223:	8b 45 0c             	mov    0xc(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	0f b6 c0             	movzbl %al,%eax
 22c:	29 c2                	sub    %eax,%edx
 22e:	89 d0                	mov    %edx,%eax
}
 230:	5d                   	pop    %ebp
 231:	c3                   	ret    

00000232 <strlen>:

uint
strlen(char *s)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 23f:	eb 04                	jmp    245 <strlen+0x13>
 241:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 245:	8b 55 fc             	mov    -0x4(%ebp),%edx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	01 d0                	add    %edx,%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 ed                	jne    241 <strlen+0xf>
    ;
  return n;
 254:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <memset>:

void*
memset(void *dst, int c, uint n)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 25c:	8b 45 10             	mov    0x10(%ebp),%eax
 25f:	50                   	push   %eax
 260:	ff 75 0c             	pushl  0xc(%ebp)
 263:	ff 75 08             	pushl  0x8(%ebp)
 266:	e8 32 ff ff ff       	call   19d <stosb>
 26b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <strchr>:

char*
strchr(const char *s, char c)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 04             	sub    $0x4,%esp
 279:	8b 45 0c             	mov    0xc(%ebp),%eax
 27c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 27f:	eb 14                	jmp    295 <strchr+0x22>
    if(*s == c)
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3a 45 fc             	cmp    -0x4(%ebp),%al
 28a:	75 05                	jne    291 <strchr+0x1e>
      return (char*)s;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	eb 13                	jmp    2a4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 291:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	84 c0                	test   %al,%al
 29d:	75 e2                	jne    281 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <gets>:

char*
gets(char *buf, int max)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2b3:	eb 42                	jmp    2f7 <gets+0x51>
    cc = read(0, &c, 1);
 2b5:	83 ec 04             	sub    $0x4,%esp
 2b8:	6a 01                	push   $0x1
 2ba:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2bd:	50                   	push   %eax
 2be:	6a 00                	push   $0x0
 2c0:	e8 47 01 00 00       	call   40c <read>
 2c5:	83 c4 10             	add    $0x10,%esp
 2c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2cf:	7e 33                	jle    304 <gets+0x5e>
      break;
    buf[i++] = c;
 2d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d4:	8d 50 01             	lea    0x1(%eax),%edx
 2d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2da:	89 c2                	mov    %eax,%edx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	01 c2                	add    %eax,%edx
 2e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2eb:	3c 0a                	cmp    $0xa,%al
 2ed:	74 16                	je     305 <gets+0x5f>
 2ef:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2f3:	3c 0d                	cmp    $0xd,%al
 2f5:	74 0e                	je     305 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fa:	83 c0 01             	add    $0x1,%eax
 2fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 300:	7c b3                	jl     2b5 <gets+0xf>
 302:	eb 01                	jmp    305 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 304:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 305:	8b 55 f4             	mov    -0xc(%ebp),%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	01 d0                	add    %edx,%eax
 30d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 310:	8b 45 08             	mov    0x8(%ebp),%eax
}
 313:	c9                   	leave  
 314:	c3                   	ret    

00000315 <stat>:

int
stat(char *n, struct stat *st)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31b:	83 ec 08             	sub    $0x8,%esp
 31e:	6a 00                	push   $0x0
 320:	ff 75 08             	pushl  0x8(%ebp)
 323:	e8 0c 01 00 00       	call   434 <open>
 328:	83 c4 10             	add    $0x10,%esp
 32b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 32e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 332:	79 07                	jns    33b <stat+0x26>
    return -1;
 334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 339:	eb 25                	jmp    360 <stat+0x4b>
  r = fstat(fd, st);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	ff 75 0c             	pushl  0xc(%ebp)
 341:	ff 75 f4             	pushl  -0xc(%ebp)
 344:	e8 03 01 00 00       	call   44c <fstat>
 349:	83 c4 10             	add    $0x10,%esp
 34c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 34f:	83 ec 0c             	sub    $0xc,%esp
 352:	ff 75 f4             	pushl  -0xc(%ebp)
 355:	e8 c2 00 00 00       	call   41c <close>
 35a:	83 c4 10             	add    $0x10,%esp
  return r;
 35d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <atoi>:

int
atoi(const char *s)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 36f:	eb 25                	jmp    396 <atoi+0x34>
    n = n*10 + *s++ - '0';
 371:	8b 55 fc             	mov    -0x4(%ebp),%edx
 374:	89 d0                	mov    %edx,%eax
 376:	c1 e0 02             	shl    $0x2,%eax
 379:	01 d0                	add    %edx,%eax
 37b:	01 c0                	add    %eax,%eax
 37d:	89 c1                	mov    %eax,%ecx
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	8d 50 01             	lea    0x1(%eax),%edx
 385:	89 55 08             	mov    %edx,0x8(%ebp)
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	0f be c0             	movsbl %al,%eax
 38e:	01 c8                	add    %ecx,%eax
 390:	83 e8 30             	sub    $0x30,%eax
 393:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2f                	cmp    $0x2f,%al
 39e:	7e 0a                	jle    3aa <atoi+0x48>
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 39                	cmp    $0x39,%al
 3a8:	7e c7                	jle    371 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c1:	eb 17                	jmp    3da <memmove+0x2b>
    *dst++ = *src++;
 3c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c6:	8d 50 01             	lea    0x1(%eax),%edx
 3c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3cf:	8d 4a 01             	lea    0x1(%edx),%ecx
 3d2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3d5:	0f b6 12             	movzbl (%edx),%edx
 3d8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3da:	8b 45 10             	mov    0x10(%ebp),%eax
 3dd:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e0:	89 55 10             	mov    %edx,0x10(%ebp)
 3e3:	85 c0                	test   %eax,%eax
 3e5:	7f dc                	jg     3c3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ec:	b8 01 00 00 00       	mov    $0x1,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <exit>:
SYSCALL(exit)
 3f4:	b8 02 00 00 00       	mov    $0x2,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <wait>:
SYSCALL(wait)
 3fc:	b8 03 00 00 00       	mov    $0x3,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <pipe>:
SYSCALL(pipe)
 404:	b8 04 00 00 00       	mov    $0x4,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <read>:
SYSCALL(read)
 40c:	b8 05 00 00 00       	mov    $0x5,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <write>:
SYSCALL(write)
 414:	b8 10 00 00 00       	mov    $0x10,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <close>:
SYSCALL(close)
 41c:	b8 15 00 00 00       	mov    $0x15,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <kill>:
SYSCALL(kill)
 424:	b8 06 00 00 00       	mov    $0x6,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <exec>:
SYSCALL(exec)
 42c:	b8 07 00 00 00       	mov    $0x7,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <open>:
SYSCALL(open)
 434:	b8 0f 00 00 00       	mov    $0xf,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <mknod>:
SYSCALL(mknod)
 43c:	b8 11 00 00 00       	mov    $0x11,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <unlink>:
SYSCALL(unlink)
 444:	b8 12 00 00 00       	mov    $0x12,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <fstat>:
SYSCALL(fstat)
 44c:	b8 08 00 00 00       	mov    $0x8,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <link>:
SYSCALL(link)
 454:	b8 13 00 00 00       	mov    $0x13,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mkdir>:
SYSCALL(mkdir)
 45c:	b8 14 00 00 00       	mov    $0x14,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <chdir>:
SYSCALL(chdir)
 464:	b8 09 00 00 00       	mov    $0x9,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <dup>:
SYSCALL(dup)
 46c:	b8 0a 00 00 00       	mov    $0xa,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getpid>:
SYSCALL(getpid)
 474:	b8 0b 00 00 00       	mov    $0xb,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <sbrk>:
SYSCALL(sbrk)
 47c:	b8 0c 00 00 00       	mov    $0xc,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <sleep>:
SYSCALL(sleep)
 484:	b8 0d 00 00 00       	mov    $0xd,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <uptime>:
SYSCALL(uptime)
 48c:	b8 0e 00 00 00       	mov    $0xe,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <getppid>:
SYSCALL(getppid)
 494:	b8 16 00 00 00       	mov    $0x16,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <wait2>:
SYSCALL(wait2)
 49c:	b8 18 00 00 00       	mov    $0x18,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <nice>:
SYSCALL(nice)
 4a4:	b8 17 00 00 00       	mov    $0x17,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ac:	55                   	push   %ebp
 4ad:	89 e5                	mov    %esp,%ebp
 4af:	83 ec 18             	sub    $0x18,%esp
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b8:	83 ec 04             	sub    $0x4,%esp
 4bb:	6a 01                	push   $0x1
 4bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	pushl  0x8(%ebp)
 4c4:	e8 4b ff ff ff       	call   414 <write>
 4c9:	83 c4 10             	add    $0x10,%esp
}
 4cc:	90                   	nop
 4cd:	c9                   	leave  
 4ce:	c3                   	ret    

000004cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	53                   	push   %ebx
 4d3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4dd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e1:	74 17                	je     4fa <printint+0x2b>
 4e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e7:	79 11                	jns    4fa <printint+0x2b>
    neg = 1;
 4e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	f7 d8                	neg    %eax
 4f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f8:	eb 06                	jmp    500 <printint+0x31>
  } else {
    x = xx;
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 500:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 507:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 50a:	8d 41 01             	lea    0x1(%ecx),%eax
 50d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 510:	8b 5d 10             	mov    0x10(%ebp),%ebx
 513:	8b 45 ec             	mov    -0x14(%ebp),%eax
 516:	ba 00 00 00 00       	mov    $0x0,%edx
 51b:	f7 f3                	div    %ebx
 51d:	89 d0                	mov    %edx,%eax
 51f:	0f b6 80 50 0c 00 00 	movzbl 0xc50(%eax),%eax
 526:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 52a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 530:	ba 00 00 00 00       	mov    $0x0,%edx
 535:	f7 f3                	div    %ebx
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53e:	75 c7                	jne    507 <printint+0x38>
  if(neg)
 540:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 544:	74 2d                	je     573 <printint+0xa4>
    buf[i++] = '-';
 546:	8b 45 f4             	mov    -0xc(%ebp),%eax
 549:	8d 50 01             	lea    0x1(%eax),%edx
 54c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 554:	eb 1d                	jmp    573 <printint+0xa4>
    putc(fd, buf[i]);
 556:	8d 55 dc             	lea    -0x24(%ebp),%edx
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	01 d0                	add    %edx,%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	83 ec 08             	sub    $0x8,%esp
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 3c ff ff ff       	call   4ac <putc>
 570:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 573:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57b:	79 d9                	jns    556 <printint+0x87>
    putc(fd, buf[i]);
}
 57d:	90                   	nop
 57e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 581:	c9                   	leave  
 582:	c3                   	ret    

00000583 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 583:	55                   	push   %ebp
 584:	89 e5                	mov    %esp,%ebp
 586:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 589:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 590:	8d 45 0c             	lea    0xc(%ebp),%eax
 593:	83 c0 04             	add    $0x4,%eax
 596:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a0:	e9 59 01 00 00       	jmp    6fe <printf+0x17b>
    c = fmt[i] & 0xff;
 5a5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ab:	01 d0                	add    %edx,%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	25 ff 00 00 00       	and    $0xff,%eax
 5b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bf:	75 2c                	jne    5ed <printf+0x6a>
      if(c == '%'){
 5c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c5:	75 0c                	jne    5d3 <printf+0x50>
        state = '%';
 5c7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ce:	e9 27 01 00 00       	jmp    6fa <printf+0x177>
      } else {
        putc(fd, c);
 5d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	83 ec 08             	sub    $0x8,%esp
 5dc:	50                   	push   %eax
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 c7 fe ff ff       	call   4ac <putc>
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	e9 0d 01 00 00       	jmp    6fa <printf+0x177>
      }
    } else if(state == '%'){
 5ed:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f1:	0f 85 03 01 00 00    	jne    6fa <printf+0x177>
      if(c == 'd'){
 5f7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fb:	75 1e                	jne    61b <printf+0x98>
        printint(fd, *ap, 10, 1);
 5fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	6a 01                	push   $0x1
 604:	6a 0a                	push   $0xa
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 c0 fe ff ff       	call   4cf <printint>
 60f:	83 c4 10             	add    $0x10,%esp
        ap++;
 612:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 616:	e9 d8 00 00 00       	jmp    6f3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 61b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 61f:	74 06                	je     627 <printf+0xa4>
 621:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 625:	75 1e                	jne    645 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 627:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	6a 00                	push   $0x0
 62e:	6a 10                	push   $0x10
 630:	50                   	push   %eax
 631:	ff 75 08             	pushl  0x8(%ebp)
 634:	e8 96 fe ff ff       	call   4cf <printint>
 639:	83 c4 10             	add    $0x10,%esp
        ap++;
 63c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 640:	e9 ae 00 00 00       	jmp    6f3 <printf+0x170>
      } else if(c == 's'){
 645:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 649:	75 43                	jne    68e <printf+0x10b>
        s = (char*)*ap;
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 653:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65b:	75 25                	jne    682 <printf+0xff>
          s = "(null)";
 65d:	c7 45 f4 d0 09 00 00 	movl   $0x9d0,-0xc(%ebp)
        while(*s != 0){
 664:	eb 1c                	jmp    682 <printf+0xff>
          putc(fd, *s);
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	0f b6 00             	movzbl (%eax),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	83 ec 08             	sub    $0x8,%esp
 672:	50                   	push   %eax
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 31 fe ff ff       	call   4ac <putc>
 67b:	83 c4 10             	add    $0x10,%esp
          s++;
 67e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 682:	8b 45 f4             	mov    -0xc(%ebp),%eax
 685:	0f b6 00             	movzbl (%eax),%eax
 688:	84 c0                	test   %al,%al
 68a:	75 da                	jne    666 <printf+0xe3>
 68c:	eb 65                	jmp    6f3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 692:	75 1d                	jne    6b1 <printf+0x12e>
        putc(fd, *ap);
 694:	8b 45 e8             	mov    -0x18(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	0f be c0             	movsbl %al,%eax
 69c:	83 ec 08             	sub    $0x8,%esp
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	pushl  0x8(%ebp)
 6a3:	e8 04 fe ff ff       	call   4ac <putc>
 6a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6af:	eb 42                	jmp    6f3 <printf+0x170>
      } else if(c == '%'){
 6b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b5:	75 17                	jne    6ce <printf+0x14b>
        putc(fd, c);
 6b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	83 ec 08             	sub    $0x8,%esp
 6c0:	50                   	push   %eax
 6c1:	ff 75 08             	pushl  0x8(%ebp)
 6c4:	e8 e3 fd ff ff       	call   4ac <putc>
 6c9:	83 c4 10             	add    $0x10,%esp
 6cc:	eb 25                	jmp    6f3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ce:	83 ec 08             	sub    $0x8,%esp
 6d1:	6a 25                	push   $0x25
 6d3:	ff 75 08             	pushl  0x8(%ebp)
 6d6:	e8 d1 fd ff ff       	call   4ac <putc>
 6db:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	83 ec 08             	sub    $0x8,%esp
 6e7:	50                   	push   %eax
 6e8:	ff 75 08             	pushl  0x8(%ebp)
 6eb:	e8 bc fd ff ff       	call   4ac <putc>
 6f0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6fa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	01 d0                	add    %edx,%eax
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	84 c0                	test   %al,%al
 70b:	0f 85 94 fe ff ff    	jne    5a5 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 711:	90                   	nop
 712:	c9                   	leave  
 713:	c3                   	ret    

00000714 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	83 e8 08             	sub    $0x8,%eax
 720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 723:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 728:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72b:	eb 24                	jmp    751 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 735:	77 12                	ja     749 <free+0x35>
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73d:	77 24                	ja     763 <free+0x4f>
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 747:	77 1a                	ja     763 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 757:	76 d4                	jbe    72d <free+0x19>
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 761:	76 ca                	jbe    72d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	01 c2                	add    %eax,%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	39 c2                	cmp    %eax,%edx
 77c:	75 24                	jne    7a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	8b 50 04             	mov    0x4(%eax),%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	01 c2                	add    %eax,%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	8b 10                	mov    (%eax),%edx
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	89 10                	mov    %edx,(%eax)
 7a0:	eb 0a                	jmp    7ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 10                	mov    (%eax),%edx
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	01 d0                	add    %edx,%eax
 7be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c1:	75 20                	jne    7e3 <free+0xcf>
    p->s.size += bp->s.size;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 50 04             	mov    0x4(%eax),%edx
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	01 c2                	add    %eax,%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	89 10                	mov    %edx,(%eax)
 7e1:	eb 08                	jmp    7eb <free+0xd7>
  } else
    p->s.ptr = bp;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	a3 6c 0c 00 00       	mov    %eax,0xc6c
}
 7f3:	90                   	nop
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    

000007f6 <morecore>:

static Header*
morecore(uint nu)
{
 7f6:	55                   	push   %ebp
 7f7:	89 e5                	mov    %esp,%ebp
 7f9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 803:	77 07                	ja     80c <morecore+0x16>
    nu = 4096;
 805:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	c1 e0 03             	shl    $0x3,%eax
 812:	83 ec 0c             	sub    $0xc,%esp
 815:	50                   	push   %eax
 816:	e8 61 fc ff ff       	call   47c <sbrk>
 81b:	83 c4 10             	add    $0x10,%esp
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 821:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 825:	75 07                	jne    82e <morecore+0x38>
    return 0;
 827:	b8 00 00 00 00       	mov    $0x0,%eax
 82c:	eb 26                	jmp    854 <morecore+0x5e>
  hp = (Header*)p;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 834:	8b 45 f0             	mov    -0x10(%ebp),%eax
 837:	8b 55 08             	mov    0x8(%ebp),%edx
 83a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	83 c0 08             	add    $0x8,%eax
 843:	83 ec 0c             	sub    $0xc,%esp
 846:	50                   	push   %eax
 847:	e8 c8 fe ff ff       	call   714 <free>
 84c:	83 c4 10             	add    $0x10,%esp
  return freep;
 84f:	a1 6c 0c 00 00       	mov    0xc6c,%eax
}
 854:	c9                   	leave  
 855:	c3                   	ret    

00000856 <malloc>:

void*
malloc(uint nbytes)
{
 856:	55                   	push   %ebp
 857:	89 e5                	mov    %esp,%ebp
 859:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85c:	8b 45 08             	mov    0x8(%ebp),%eax
 85f:	83 c0 07             	add    $0x7,%eax
 862:	c1 e8 03             	shr    $0x3,%eax
 865:	83 c0 01             	add    $0x1,%eax
 868:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86b:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 870:	89 45 f0             	mov    %eax,-0x10(%ebp)
 873:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 877:	75 23                	jne    89c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 879:	c7 45 f0 64 0c 00 00 	movl   $0xc64,-0x10(%ebp)
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	a3 6c 0c 00 00       	mov    %eax,0xc6c
 888:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 88d:	a3 64 0c 00 00       	mov    %eax,0xc64
    base.s.size = 0;
 892:	c7 05 68 0c 00 00 00 	movl   $0x0,0xc68
 899:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89f:	8b 00                	mov    (%eax),%eax
 8a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ad:	72 4d                	jb     8fc <malloc+0xa6>
      if(p->s.size == nunits)
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 40 04             	mov    0x4(%eax),%eax
 8b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b8:	75 0c                	jne    8c6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	8b 10                	mov    (%eax),%edx
 8bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c2:	89 10                	mov    %edx,(%eax)
 8c4:	eb 26                	jmp    8ec <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 40 04             	mov    0x4(%eax),%eax
 8cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8cf:	89 c2                	mov    %eax,%edx
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	8b 40 04             	mov    0x4(%eax),%eax
 8dd:	c1 e0 03             	shl    $0x3,%eax
 8e0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ef:	a3 6c 0c 00 00       	mov    %eax,0xc6c
      return (void*)(p + 1);
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	83 c0 08             	add    $0x8,%eax
 8fa:	eb 3b                	jmp    937 <malloc+0xe1>
    }
    if(p == freep)
 8fc:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 901:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 904:	75 1e                	jne    924 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 906:	83 ec 0c             	sub    $0xc,%esp
 909:	ff 75 ec             	pushl  -0x14(%ebp)
 90c:	e8 e5 fe ff ff       	call   7f6 <morecore>
 911:	83 c4 10             	add    $0x10,%esp
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
 917:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91b:	75 07                	jne    924 <malloc+0xce>
        return 0;
 91d:	b8 00 00 00 00       	mov    $0x0,%eax
 922:	eb 13                	jmp    937 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	8b 00                	mov    (%eax),%eax
 92f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 932:	e9 6d ff ff ff       	jmp    8a4 <malloc+0x4e>
}
 937:	c9                   	leave  
 938:	c3                   	ret    
