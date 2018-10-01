
_waittest:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:
}
*/

void
foo()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int i;
  for (i=0;i<100;i++)
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 19                	jmp    28 <foo+0x28>
     printf(2, "wait test %d\n",i);
   f:	83 ec 04             	sub    $0x4,%esp
  12:	ff 75 f4             	pushl  -0xc(%ebp)
  15:	68 95 08 00 00       	push   $0x895
  1a:	6a 02                	push   $0x2
  1c:	e8 be 04 00 00       	call   4df <printf>
  21:	83 c4 10             	add    $0x10,%esp

void
foo()
{
  int i;
  for (i=0;i<100;i++)
  24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  28:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  2c:	7e e1                	jle    f <foo+0xf>
     printf(2, "wait test %d\n",i);
  sleep(20);
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	6a 14                	push   $0x14
  33:	e8 a8 03 00 00       	call   3e0 <sleep>
  38:	83 c4 10             	add    $0x10,%esp
  for (i=0;i<100;i++)
  3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  42:	eb 19                	jmp    5d <foo+0x5d>
     printf(2, "wait test %d\n",i);
  44:	83 ec 04             	sub    $0x4,%esp
  47:	ff 75 f4             	pushl  -0xc(%ebp)
  4a:	68 95 08 00 00       	push   $0x895
  4f:	6a 02                	push   $0x2
  51:	e8 89 04 00 00       	call   4df <printf>
  56:	83 c4 10             	add    $0x10,%esp
{
  int i;
  for (i=0;i<100;i++)
     printf(2, "wait test %d\n",i);
  sleep(20);
  for (i=0;i<100;i++)
  59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  5d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  61:	7e e1                	jle    44 <foo+0x44>
     printf(2, "wait test %d\n",i);

}
  63:	90                   	nop
  64:	c9                   	leave  
  65:	c3                   	ret    

00000066 <waittest>:

void
waittest(void)
{
  66:	55                   	push   %ebp
  67:	89 e5                	mov    %esp,%ebp
  69:	83 ec 18             	sub    $0x18,%esp
  int rTime;
  int ruTime;
  int sTime;
  int pid;
  printf(1, "wait test\n");
  6c:	83 ec 08             	sub    $0x8,%esp
  6f:	68 a3 08 00 00       	push   $0x8a3
  74:	6a 01                	push   $0x1
  76:	e8 64 04 00 00       	call   4df <printf>
  7b:	83 c4 10             	add    $0x10,%esp


    pid = fork();
  7e:	e8 c5 02 00 00       	call   348 <fork>
  83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid == 0)
  86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8a:	75 0a                	jne    96 <waittest+0x30>
    {
      foo();
  8c:	e8 6f ff ff ff       	call   0 <foo>
      exit();      
  91:	e8 ba 02 00 00       	call   350 <exit>
    }
    wait2(&rTime,&ruTime , &sTime);
  96:	83 ec 04             	sub    $0x4,%esp
  99:	8d 45 e8             	lea    -0x18(%ebp),%eax
  9c:	50                   	push   %eax
  9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  a4:	50                   	push   %eax
  a5:	e8 4e 03 00 00       	call   3f8 <wait2>
  aa:	83 c4 10             	add    $0x10,%esp
     printf(1, "hi \n");
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	68 ae 08 00 00       	push   $0x8ae
  b5:	6a 01                	push   $0x1
  b7:	e8 23 04 00 00       	call   4df <printf>
  bc:	83 c4 10             	add    $0x10,%esp
    printf(1, "wTime: %d rTime: %d \n",(rTime+sTime),ruTime);
  bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  c8:	01 ca                	add    %ecx,%edx
  ca:	50                   	push   %eax
  cb:	52                   	push   %edx
  cc:	68 b3 08 00 00       	push   $0x8b3
  d1:	6a 01                	push   $0x1
  d3:	e8 07 04 00 00       	call   4df <printf>
  d8:	83 c4 10             	add    $0x10,%esp

}
  db:	90                   	nop
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <main>:
int
main(void)
{
  de:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  e2:	83 e4 f0             	and    $0xfffffff0,%esp
  e5:	ff 71 fc             	pushl  -0x4(%ecx)
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	51                   	push   %ecx
  ec:	83 ec 04             	sub    $0x4,%esp
  waittest();
  ef:	e8 72 ff ff ff       	call   66 <waittest>
  exit();
  f4:	e8 57 02 00 00       	call   350 <exit>

000000f9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	57                   	push   %edi
  fd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
 101:	8b 55 10             	mov    0x10(%ebp),%edx
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	89 cb                	mov    %ecx,%ebx
 109:	89 df                	mov    %ebx,%edi
 10b:	89 d1                	mov    %edx,%ecx
 10d:	fc                   	cld    
 10e:	f3 aa                	rep stos %al,%es:(%edi)
 110:	89 ca                	mov    %ecx,%edx
 112:	89 fb                	mov    %edi,%ebx
 114:	89 5d 08             	mov    %ebx,0x8(%ebp)
 117:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 11a:	90                   	nop
 11b:	5b                   	pop    %ebx
 11c:	5f                   	pop    %edi
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 12b:	90                   	nop
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	8d 50 01             	lea    0x1(%eax),%edx
 132:	89 55 08             	mov    %edx,0x8(%ebp)
 135:	8b 55 0c             	mov    0xc(%ebp),%edx
 138:	8d 4a 01             	lea    0x1(%edx),%ecx
 13b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 13e:	0f b6 12             	movzbl (%edx),%edx
 141:	88 10                	mov    %dl,(%eax)
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	84 c0                	test   %al,%al
 148:	75 e2                	jne    12c <strcpy+0xd>
    ;
  return os;
 14a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 152:	eb 08                	jmp    15c <strcmp+0xd>
    p++, q++;
 154:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 158:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	74 10                	je     176 <strcmp+0x27>
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 10             	movzbl (%eax),%edx
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	38 c2                	cmp    %al,%dl
 174:	74 de                	je     154 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	0f b6 d0             	movzbl %al,%edx
 17f:	8b 45 0c             	mov    0xc(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	0f b6 c0             	movzbl %al,%eax
 188:	29 c2                	sub    %eax,%edx
 18a:	89 d0                	mov    %edx,%eax
}
 18c:	5d                   	pop    %ebp
 18d:	c3                   	ret    

0000018e <strlen>:

uint
strlen(char *s)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 19b:	eb 04                	jmp    1a1 <strlen+0x13>
 19d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 d0                	add    %edx,%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	84 c0                	test   %al,%al
 1ae:	75 ed                	jne    19d <strlen+0xf>
    ;
  return n;
 1b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b3:	c9                   	leave  
 1b4:	c3                   	ret    

000001b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b8:	8b 45 10             	mov    0x10(%ebp),%eax
 1bb:	50                   	push   %eax
 1bc:	ff 75 0c             	pushl  0xc(%ebp)
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	e8 32 ff ff ff       	call   f9 <stosb>
 1c7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <strchr>:

char*
strchr(const char *s, char c)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 04             	sub    $0x4,%esp
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1db:	eb 14                	jmp    1f1 <strchr+0x22>
    if(*s == c)
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e6:	75 05                	jne    1ed <strchr+0x1e>
      return (char*)s;
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	eb 13                	jmp    200 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	84 c0                	test   %al,%al
 1f9:	75 e2                	jne    1dd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 208:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 20f:	eb 42                	jmp    253 <gets+0x51>
    cc = read(0, &c, 1);
 211:	83 ec 04             	sub    $0x4,%esp
 214:	6a 01                	push   $0x1
 216:	8d 45 ef             	lea    -0x11(%ebp),%eax
 219:	50                   	push   %eax
 21a:	6a 00                	push   $0x0
 21c:	e8 47 01 00 00       	call   368 <read>
 221:	83 c4 10             	add    $0x10,%esp
 224:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 22b:	7e 33                	jle    260 <gets+0x5e>
      break;
    buf[i++] = c;
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	8d 50 01             	lea    0x1(%eax),%edx
 233:	89 55 f4             	mov    %edx,-0xc(%ebp)
 236:	89 c2                	mov    %eax,%edx
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	01 c2                	add    %eax,%edx
 23d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 241:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 243:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 247:	3c 0a                	cmp    $0xa,%al
 249:	74 16                	je     261 <gets+0x5f>
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0d                	cmp    $0xd,%al
 251:	74 0e                	je     261 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	8b 45 f4             	mov    -0xc(%ebp),%eax
 256:	83 c0 01             	add    $0x1,%eax
 259:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25c:	7c b3                	jl     211 <gets+0xf>
 25e:	eb 01                	jmp    261 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 260:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 261:	8b 55 f4             	mov    -0xc(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <stat>:

int
stat(char *n, struct stat *st)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	6a 00                	push   $0x0
 27c:	ff 75 08             	pushl  0x8(%ebp)
 27f:	e8 0c 01 00 00       	call   390 <open>
 284:	83 c4 10             	add    $0x10,%esp
 287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28e:	79 07                	jns    297 <stat+0x26>
    return -1;
 290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 295:	eb 25                	jmp    2bc <stat+0x4b>
  r = fstat(fd, st);
 297:	83 ec 08             	sub    $0x8,%esp
 29a:	ff 75 0c             	pushl  0xc(%ebp)
 29d:	ff 75 f4             	pushl  -0xc(%ebp)
 2a0:	e8 03 01 00 00       	call   3a8 <fstat>
 2a5:	83 c4 10             	add    $0x10,%esp
 2a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ab:	83 ec 0c             	sub    $0xc,%esp
 2ae:	ff 75 f4             	pushl  -0xc(%ebp)
 2b1:	e8 c2 00 00 00       	call   378 <close>
 2b6:	83 c4 10             	add    $0x10,%esp
  return r;
 2b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <atoi>:

int
atoi(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cb:	eb 25                	jmp    2f2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d0:	89 d0                	mov    %edx,%eax
 2d2:	c1 e0 02             	shl    $0x2,%eax
 2d5:	01 d0                	add    %edx,%eax
 2d7:	01 c0                	add    %eax,%eax
 2d9:	89 c1                	mov    %eax,%ecx
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	8d 50 01             	lea    0x1(%eax),%edx
 2e1:	89 55 08             	mov    %edx,0x8(%ebp)
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	0f be c0             	movsbl %al,%eax
 2ea:	01 c8                	add    %ecx,%eax
 2ec:	83 e8 30             	sub    $0x30,%eax
 2ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	3c 2f                	cmp    $0x2f,%al
 2fa:	7e 0a                	jle    306 <atoi+0x48>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 39                	cmp    $0x39,%al
 304:	7e c7                	jle    2cd <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 309:	c9                   	leave  
 30a:	c3                   	ret    

0000030b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30b:	55                   	push   %ebp
 30c:	89 e5                	mov    %esp,%ebp
 30e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31d:	eb 17                	jmp    336 <memmove+0x2b>
    *dst++ = *src++;
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 fc             	mov    %edx,-0x4(%ebp)
 328:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32b:	8d 4a 01             	lea    0x1(%edx),%ecx
 32e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 331:	0f b6 12             	movzbl (%edx),%edx
 334:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 336:	8b 45 10             	mov    0x10(%ebp),%eax
 339:	8d 50 ff             	lea    -0x1(%eax),%edx
 33c:	89 55 10             	mov    %edx,0x10(%ebp)
 33f:	85 c0                	test   %eax,%eax
 341:	7f dc                	jg     31f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 348:	b8 01 00 00 00       	mov    $0x1,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <exit>:
SYSCALL(exit)
 350:	b8 02 00 00 00       	mov    $0x2,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <wait>:
SYSCALL(wait)
 358:	b8 03 00 00 00       	mov    $0x3,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <pipe>:
SYSCALL(pipe)
 360:	b8 04 00 00 00       	mov    $0x4,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <read>:
SYSCALL(read)
 368:	b8 05 00 00 00       	mov    $0x5,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <write>:
SYSCALL(write)
 370:	b8 10 00 00 00       	mov    $0x10,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <close>:
SYSCALL(close)
 378:	b8 15 00 00 00       	mov    $0x15,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <kill>:
SYSCALL(kill)
 380:	b8 06 00 00 00       	mov    $0x6,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exec>:
SYSCALL(exec)
 388:	b8 07 00 00 00       	mov    $0x7,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <open>:
SYSCALL(open)
 390:	b8 0f 00 00 00       	mov    $0xf,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <mknod>:
SYSCALL(mknod)
 398:	b8 11 00 00 00       	mov    $0x11,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <unlink>:
SYSCALL(unlink)
 3a0:	b8 12 00 00 00       	mov    $0x12,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <fstat>:
SYSCALL(fstat)
 3a8:	b8 08 00 00 00       	mov    $0x8,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <link>:
SYSCALL(link)
 3b0:	b8 13 00 00 00       	mov    $0x13,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <mkdir>:
SYSCALL(mkdir)
 3b8:	b8 14 00 00 00       	mov    $0x14,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <chdir>:
SYSCALL(chdir)
 3c0:	b8 09 00 00 00       	mov    $0x9,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <dup>:
SYSCALL(dup)
 3c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getpid>:
SYSCALL(getpid)
 3d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <sbrk>:
SYSCALL(sbrk)
 3d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sleep>:
SYSCALL(sleep)
 3e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <uptime>:
SYSCALL(uptime)
 3e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <getppid>:
SYSCALL(getppid)
 3f0:	b8 16 00 00 00       	mov    $0x16,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <wait2>:
SYSCALL(wait2)
 3f8:	b8 18 00 00 00       	mov    $0x18,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <nice>:
SYSCALL(nice)
 400:	b8 17 00 00 00       	mov    $0x17,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	83 ec 18             	sub    $0x18,%esp
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 414:	83 ec 04             	sub    $0x4,%esp
 417:	6a 01                	push   $0x1
 419:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41c:	50                   	push   %eax
 41d:	ff 75 08             	pushl  0x8(%ebp)
 420:	e8 4b ff ff ff       	call   370 <write>
 425:	83 c4 10             	add    $0x10,%esp
}
 428:	90                   	nop
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	53                   	push   %ebx
 42f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 439:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43d:	74 17                	je     456 <printint+0x2b>
 43f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 443:	79 11                	jns    456 <printint+0x2b>
    neg = 1;
 445:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44c:	8b 45 0c             	mov    0xc(%ebp),%eax
 44f:	f7 d8                	neg    %eax
 451:	89 45 ec             	mov    %eax,-0x14(%ebp)
 454:	eb 06                	jmp    45c <printint+0x31>
  } else {
    x = xx;
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 463:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 466:	8d 41 01             	lea    0x1(%ecx),%eax
 469:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 46f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 472:	ba 00 00 00 00       	mov    $0x0,%edx
 477:	f7 f3                	div    %ebx
 479:	89 d0                	mov    %edx,%eax
 47b:	0f b6 80 58 0b 00 00 	movzbl 0xb58(%eax),%eax
 482:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 486:	8b 5d 10             	mov    0x10(%ebp),%ebx
 489:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48c:	ba 00 00 00 00       	mov    $0x0,%edx
 491:	f7 f3                	div    %ebx
 493:	89 45 ec             	mov    %eax,-0x14(%ebp)
 496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49a:	75 c7                	jne    463 <printint+0x38>
  if(neg)
 49c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a0:	74 2d                	je     4cf <printint+0xa4>
    buf[i++] = '-';
 4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a5:	8d 50 01             	lea    0x1(%eax),%edx
 4a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ab:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b0:	eb 1d                	jmp    4cf <printint+0xa4>
    putc(fd, buf[i]);
 4b2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b8:	01 d0                	add    %edx,%eax
 4ba:	0f b6 00             	movzbl (%eax),%eax
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	83 ec 08             	sub    $0x8,%esp
 4c3:	50                   	push   %eax
 4c4:	ff 75 08             	pushl  0x8(%ebp)
 4c7:	e8 3c ff ff ff       	call   408 <putc>
 4cc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d7:	79 d9                	jns    4b2 <printint+0x87>
    putc(fd, buf[i]);
}
 4d9:	90                   	nop
 4da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4dd:	c9                   	leave  
 4de:	c3                   	ret    

000004df <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4df:	55                   	push   %ebp
 4e0:	89 e5                	mov    %esp,%ebp
 4e2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ec:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ef:	83 c0 04             	add    $0x4,%eax
 4f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4fc:	e9 59 01 00 00       	jmp    65a <printf+0x17b>
    c = fmt[i] & 0xff;
 501:	8b 55 0c             	mov    0xc(%ebp),%edx
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
 507:	01 d0                	add    %edx,%eax
 509:	0f b6 00             	movzbl (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	25 ff 00 00 00       	and    $0xff,%eax
 514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 517:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51b:	75 2c                	jne    549 <printf+0x6a>
      if(c == '%'){
 51d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 521:	75 0c                	jne    52f <printf+0x50>
        state = '%';
 523:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52a:	e9 27 01 00 00       	jmp    656 <printf+0x177>
      } else {
        putc(fd, c);
 52f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	83 ec 08             	sub    $0x8,%esp
 538:	50                   	push   %eax
 539:	ff 75 08             	pushl  0x8(%ebp)
 53c:	e8 c7 fe ff ff       	call   408 <putc>
 541:	83 c4 10             	add    $0x10,%esp
 544:	e9 0d 01 00 00       	jmp    656 <printf+0x177>
      }
    } else if(state == '%'){
 549:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54d:	0f 85 03 01 00 00    	jne    656 <printf+0x177>
      if(c == 'd'){
 553:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 557:	75 1e                	jne    577 <printf+0x98>
        printint(fd, *ap, 10, 1);
 559:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55c:	8b 00                	mov    (%eax),%eax
 55e:	6a 01                	push   $0x1
 560:	6a 0a                	push   $0xa
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 c0 fe ff ff       	call   42b <printint>
 56b:	83 c4 10             	add    $0x10,%esp
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	e9 d8 00 00 00       	jmp    64f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 577:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57b:	74 06                	je     583 <printf+0xa4>
 57d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 581:	75 1e                	jne    5a1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	6a 00                	push   $0x0
 58a:	6a 10                	push   $0x10
 58c:	50                   	push   %eax
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 96 fe ff ff       	call   42b <printint>
 595:	83 c4 10             	add    $0x10,%esp
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	e9 ae 00 00 00       	jmp    64f <printf+0x170>
      } else if(c == 's'){
 5a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a5:	75 43                	jne    5ea <printf+0x10b>
        s = (char*)*ap;
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b7:	75 25                	jne    5de <printf+0xff>
          s = "(null)";
 5b9:	c7 45 f4 c9 08 00 00 	movl   $0x8c9,-0xc(%ebp)
        while(*s != 0){
 5c0:	eb 1c                	jmp    5de <printf+0xff>
          putc(fd, *s);
 5c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 31 fe ff ff       	call   408 <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
          s++;
 5da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	84 c0                	test   %al,%al
 5e6:	75 da                	jne    5c2 <printf+0xe3>
 5e8:	eb 65                	jmp    64f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ea:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ee:	75 1d                	jne    60d <printf+0x12e>
        putc(fd, *ap);
 5f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 ec 08             	sub    $0x8,%esp
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 04 fe ff ff       	call   408 <putc>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	eb 42                	jmp    64f <printf+0x170>
      } else if(c == '%'){
 60d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 611:	75 17                	jne    62a <printf+0x14b>
        putc(fd, c);
 613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	50                   	push   %eax
 61d:	ff 75 08             	pushl  0x8(%ebp)
 620:	e8 e3 fd ff ff       	call   408 <putc>
 625:	83 c4 10             	add    $0x10,%esp
 628:	eb 25                	jmp    64f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	6a 25                	push   $0x25
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 d1 fd ff ff       	call   408 <putc>
 637:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63d:	0f be c0             	movsbl %al,%eax
 640:	83 ec 08             	sub    $0x8,%esp
 643:	50                   	push   %eax
 644:	ff 75 08             	pushl  0x8(%ebp)
 647:	e8 bc fd ff ff       	call   408 <putc>
 64c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 64f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 656:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65a:	8b 55 0c             	mov    0xc(%ebp),%edx
 65d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 660:	01 d0                	add    %edx,%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	84 c0                	test   %al,%al
 667:	0f 85 94 fe ff ff    	jne    501 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66d:	90                   	nop
 66e:	c9                   	leave  
 66f:	c3                   	ret    

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	83 e8 08             	sub    $0x8,%eax
 67c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67f:	a1 74 0b 00 00       	mov    0xb74,%eax
 684:	89 45 fc             	mov    %eax,-0x4(%ebp)
 687:	eb 24                	jmp    6ad <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 691:	77 12                	ja     6a5 <free+0x35>
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 699:	77 24                	ja     6bf <free+0x4f>
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a3:	77 1a                	ja     6bf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b3:	76 d4                	jbe    689 <free+0x19>
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bd:	76 ca                	jbe    689 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	01 c2                	add    %eax,%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	39 c2                	cmp    %eax,%edx
 6d8:	75 24                	jne    6fe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	01 c2                	add    %eax,%edx
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 0a                	jmp    708 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 10                	mov    (%eax),%edx
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71d:	75 20                	jne    73f <free+0xcf>
    p->s.size += bp->s.size;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 50 04             	mov    0x4(%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	89 10                	mov    %edx,(%eax)
 73d:	eb 08                	jmp    747 <free+0xd7>
  } else
    p->s.ptr = bp;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	8b 55 f8             	mov    -0x8(%ebp),%edx
 745:	89 10                	mov    %edx,(%eax)
  freep = p;
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	a3 74 0b 00 00       	mov    %eax,0xb74
}
 74f:	90                   	nop
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <morecore>:

static Header*
morecore(uint nu)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 758:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75f:	77 07                	ja     768 <morecore+0x16>
    nu = 4096;
 761:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	c1 e0 03             	shl    $0x3,%eax
 76e:	83 ec 0c             	sub    $0xc,%esp
 771:	50                   	push   %eax
 772:	e8 61 fc ff ff       	call   3d8 <sbrk>
 777:	83 c4 10             	add    $0x10,%esp
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 781:	75 07                	jne    78a <morecore+0x38>
    return 0;
 783:	b8 00 00 00 00       	mov    $0x0,%eax
 788:	eb 26                	jmp    7b0 <morecore+0x5e>
  hp = (Header*)p;
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	8b 55 08             	mov    0x8(%ebp),%edx
 796:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	83 c0 08             	add    $0x8,%eax
 79f:	83 ec 0c             	sub    $0xc,%esp
 7a2:	50                   	push   %eax
 7a3:	e8 c8 fe ff ff       	call   670 <free>
 7a8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ab:	a1 74 0b 00 00       	mov    0xb74,%eax
}
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <malloc>:

void*
malloc(uint nbytes)
{
 7b2:	55                   	push   %ebp
 7b3:	89 e5                	mov    %esp,%ebp
 7b5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	83 c0 07             	add    $0x7,%eax
 7be:	c1 e8 03             	shr    $0x3,%eax
 7c1:	83 c0 01             	add    $0x1,%eax
 7c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c7:	a1 74 0b 00 00       	mov    0xb74,%eax
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d3:	75 23                	jne    7f8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d5:	c7 45 f0 6c 0b 00 00 	movl   $0xb6c,-0x10(%ebp)
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 74 0b 00 00       	mov    %eax,0xb74
 7e4:	a1 74 0b 00 00       	mov    0xb74,%eax
 7e9:	a3 6c 0b 00 00       	mov    %eax,0xb6c
    base.s.size = 0;
 7ee:	c7 05 70 0b 00 00 00 	movl   $0x0,0xb70
 7f5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 809:	72 4d                	jb     858 <malloc+0xa6>
      if(p->s.size == nunits)
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 814:	75 0c                	jne    822 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 10                	mov    (%eax),%edx
 81b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81e:	89 10                	mov    %edx,(%eax)
 820:	eb 26                	jmp    848 <malloc+0x96>
      else {
        p->s.size -= nunits;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82b:	89 c2                	mov    %eax,%edx
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	c1 e0 03             	shl    $0x3,%eax
 83c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 55 ec             	mov    -0x14(%ebp),%edx
 845:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	a3 74 0b 00 00       	mov    %eax,0xb74
      return (void*)(p + 1);
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	83 c0 08             	add    $0x8,%eax
 856:	eb 3b                	jmp    893 <malloc+0xe1>
    }
    if(p == freep)
 858:	a1 74 0b 00 00       	mov    0xb74,%eax
 85d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 860:	75 1e                	jne    880 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 862:	83 ec 0c             	sub    $0xc,%esp
 865:	ff 75 ec             	pushl  -0x14(%ebp)
 868:	e8 e5 fe ff ff       	call   752 <morecore>
 86d:	83 c4 10             	add    $0x10,%esp
 870:	89 45 f4             	mov    %eax,-0xc(%ebp)
 873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 877:	75 07                	jne    880 <malloc+0xce>
        return 0;
 879:	b8 00 00 00 00       	mov    $0x0,%eax
 87e:	eb 13                	jmp    893 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 45 f0             	mov    %eax,-0x10(%ebp)
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 00                	mov    (%eax),%eax
 88b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 88e:	e9 6d ff ff ff       	jmp    800 <malloc+0x4e>
}
 893:	c9                   	leave  
 894:	c3                   	ret    
