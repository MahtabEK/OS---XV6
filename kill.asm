
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 0e 08 00 00       	push   $0x80e
  21:	6a 02                	push   $0x2
  23:	e8 30 04 00 00       	call   458 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <getppid>:
SYSCALL(getppid)
 369:	b8 16 00 00 00       	mov    $0x16,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <wait2>:
SYSCALL(wait2)
 371:	b8 18 00 00 00       	mov    $0x18,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <nice>:
SYSCALL(nice)
 379:	b8 17 00 00 00       	mov    $0x17,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 18             	sub    $0x18,%esp
 387:	8b 45 0c             	mov    0xc(%ebp),%eax
 38a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38d:	83 ec 04             	sub    $0x4,%esp
 390:	6a 01                	push   $0x1
 392:	8d 45 f4             	lea    -0xc(%ebp),%eax
 395:	50                   	push   %eax
 396:	ff 75 08             	pushl  0x8(%ebp)
 399:	e8 4b ff ff ff       	call   2e9 <write>
 39e:	83 c4 10             	add    $0x10,%esp
}
 3a1:	90                   	nop
 3a2:	c9                   	leave  
 3a3:	c3                   	ret    

000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	53                   	push   %ebx
 3a8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b6:	74 17                	je     3cf <printint+0x2b>
 3b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bc:	79 11                	jns    3cf <printint+0x2b>
    neg = 1;
 3be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c8:	f7 d8                	neg    %eax
 3ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cd:	eb 06                	jmp    3d5 <printint+0x31>
  } else {
    x = xx;
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3df:	8d 41 01             	lea    0x1(%ecx),%eax
 3e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3eb:	ba 00 00 00 00       	mov    $0x0,%edx
 3f0:	f7 f3                	div    %ebx
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	0f b6 80 78 0a 00 00 	movzbl 0xa78(%eax),%eax
 3fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
 402:	8b 45 ec             	mov    -0x14(%ebp),%eax
 405:	ba 00 00 00 00       	mov    $0x0,%edx
 40a:	f7 f3                	div    %ebx
 40c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 413:	75 c7                	jne    3dc <printint+0x38>
  if(neg)
 415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 419:	74 2d                	je     448 <printint+0xa4>
    buf[i++] = '-';
 41b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41e:	8d 50 01             	lea    0x1(%eax),%edx
 421:	89 55 f4             	mov    %edx,-0xc(%ebp)
 424:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 429:	eb 1d                	jmp    448 <printint+0xa4>
    putc(fd, buf[i]);
 42b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 431:	01 d0                	add    %edx,%eax
 433:	0f b6 00             	movzbl (%eax),%eax
 436:	0f be c0             	movsbl %al,%eax
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	50                   	push   %eax
 43d:	ff 75 08             	pushl  0x8(%ebp)
 440:	e8 3c ff ff ff       	call   381 <putc>
 445:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 448:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 450:	79 d9                	jns    42b <printint+0x87>
    putc(fd, buf[i]);
}
 452:	90                   	nop
 453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 456:	c9                   	leave  
 457:	c3                   	ret    

00000458 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 465:	8d 45 0c             	lea    0xc(%ebp),%eax
 468:	83 c0 04             	add    $0x4,%eax
 46b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 475:	e9 59 01 00 00       	jmp    5d3 <printf+0x17b>
    c = fmt[i] & 0xff;
 47a:	8b 55 0c             	mov    0xc(%ebp),%edx
 47d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 480:	01 d0                	add    %edx,%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	0f be c0             	movsbl %al,%eax
 488:	25 ff 00 00 00       	and    $0xff,%eax
 48d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 494:	75 2c                	jne    4c2 <printf+0x6a>
      if(c == '%'){
 496:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49a:	75 0c                	jne    4a8 <printf+0x50>
        state = '%';
 49c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a3:	e9 27 01 00 00       	jmp    5cf <printf+0x177>
      } else {
        putc(fd, c);
 4a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	83 ec 08             	sub    $0x8,%esp
 4b1:	50                   	push   %eax
 4b2:	ff 75 08             	pushl  0x8(%ebp)
 4b5:	e8 c7 fe ff ff       	call   381 <putc>
 4ba:	83 c4 10             	add    $0x10,%esp
 4bd:	e9 0d 01 00 00       	jmp    5cf <printf+0x177>
      }
    } else if(state == '%'){
 4c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c6:	0f 85 03 01 00 00    	jne    5cf <printf+0x177>
      if(c == 'd'){
 4cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d0:	75 1e                	jne    4f0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d5:	8b 00                	mov    (%eax),%eax
 4d7:	6a 01                	push   $0x1
 4d9:	6a 0a                	push   $0xa
 4db:	50                   	push   %eax
 4dc:	ff 75 08             	pushl  0x8(%ebp)
 4df:	e8 c0 fe ff ff       	call   3a4 <printint>
 4e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4eb:	e9 d8 00 00 00       	jmp    5c8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f4:	74 06                	je     4fc <printf+0xa4>
 4f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fa:	75 1e                	jne    51a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ff:	8b 00                	mov    (%eax),%eax
 501:	6a 00                	push   $0x0
 503:	6a 10                	push   $0x10
 505:	50                   	push   %eax
 506:	ff 75 08             	pushl  0x8(%ebp)
 509:	e8 96 fe ff ff       	call   3a4 <printint>
 50e:	83 c4 10             	add    $0x10,%esp
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 515:	e9 ae 00 00 00       	jmp    5c8 <printf+0x170>
      } else if(c == 's'){
 51a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51e:	75 43                	jne    563 <printf+0x10b>
        s = (char*)*ap;
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 530:	75 25                	jne    557 <printf+0xff>
          s = "(null)";
 532:	c7 45 f4 22 08 00 00 	movl   $0x822,-0xc(%ebp)
        while(*s != 0){
 539:	eb 1c                	jmp    557 <printf+0xff>
          putc(fd, *s);
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	0f be c0             	movsbl %al,%eax
 544:	83 ec 08             	sub    $0x8,%esp
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 31 fe ff ff       	call   381 <putc>
 550:	83 c4 10             	add    $0x10,%esp
          s++;
 553:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 557:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	84 c0                	test   %al,%al
 55f:	75 da                	jne    53b <printf+0xe3>
 561:	eb 65                	jmp    5c8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 563:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 567:	75 1d                	jne    586 <printf+0x12e>
        putc(fd, *ap);
 569:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56c:	8b 00                	mov    (%eax),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	83 ec 08             	sub    $0x8,%esp
 574:	50                   	push   %eax
 575:	ff 75 08             	pushl  0x8(%ebp)
 578:	e8 04 fe ff ff       	call   381 <putc>
 57d:	83 c4 10             	add    $0x10,%esp
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 584:	eb 42                	jmp    5c8 <printf+0x170>
      } else if(c == '%'){
 586:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58a:	75 17                	jne    5a3 <printf+0x14b>
        putc(fd, c);
 58c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 e3 fd ff ff       	call   381 <putc>
 59e:	83 c4 10             	add    $0x10,%esp
 5a1:	eb 25                	jmp    5c8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a3:	83 ec 08             	sub    $0x8,%esp
 5a6:	6a 25                	push   $0x25
 5a8:	ff 75 08             	pushl  0x8(%ebp)
 5ab:	e8 d1 fd ff ff       	call   381 <putc>
 5b0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	83 ec 08             	sub    $0x8,%esp
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 bc fd ff ff       	call   381 <putc>
 5c5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d9:	01 d0                	add    %edx,%eax
 5db:	0f b6 00             	movzbl (%eax),%eax
 5de:	84 c0                	test   %al,%al
 5e0:	0f 85 94 fe ff ff    	jne    47a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e6:	90                   	nop
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    

000005e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	83 e8 08             	sub    $0x8,%eax
 5f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	a1 94 0a 00 00       	mov    0xa94,%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	eb 24                	jmp    626 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60a:	77 12                	ja     61e <free+0x35>
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 612:	77 24                	ja     638 <free+0x4f>
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61c:	77 1a                	ja     638 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62c:	76 d4                	jbe    602 <free+0x19>
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 636:	76 ca                	jbe    602 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	01 c2                	add    %eax,%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	39 c2                	cmp    %eax,%edx
 651:	75 24                	jne    677 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 50 04             	mov    0x4(%eax),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	8b 10                	mov    (%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 10                	mov    %edx,(%eax)
 675:	eb 0a                	jmp    681 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 696:	75 20                	jne    6b8 <free+0xcf>
    p->s.size += bp->s.size;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 50 04             	mov    0x4(%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb 08                	jmp    6c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6be:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	a3 94 0a 00 00       	mov    %eax,0xa94
}
 6c8:	90                   	nop
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <morecore>:

static Header*
morecore(uint nu)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d8:	77 07                	ja     6e1 <morecore+0x16>
    nu = 4096;
 6da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	c1 e0 03             	shl    $0x3,%eax
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	50                   	push   %eax
 6eb:	e8 61 fc ff ff       	call   351 <sbrk>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fa:	75 07                	jne    703 <morecore+0x38>
    return 0;
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb 26                	jmp    729 <morecore+0x5e>
  hp = (Header*)p;
 703:	8b 45 f4             	mov    -0xc(%ebp),%eax
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 55 08             	mov    0x8(%ebp),%edx
 70f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	83 c0 08             	add    $0x8,%eax
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	50                   	push   %eax
 71c:	e8 c8 fe ff ff       	call   5e9 <free>
 721:	83 c4 10             	add    $0x10,%esp
  return freep;
 724:	a1 94 0a 00 00       	mov    0xa94,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <malloc>:

void*
malloc(uint nbytes)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 740:	a1 94 0a 00 00       	mov    0xa94,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74e:	c7 45 f0 8c 0a 00 00 	movl   $0xa8c,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 94 0a 00 00       	mov    %eax,0xa94
 75d:	a1 94 0a 00 00       	mov    0xa94,%eax
 762:	a3 8c 0a 00 00       	mov    %eax,0xa8c
    base.s.size = 0;
 767:	c7 05 90 0a 00 00 00 	movl   $0x0,0xa90
 76e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	72 4d                	jb     7d1 <malloc+0xa6>
      if(p->s.size == nunits)
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78d:	75 0c                	jne    79b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 94 0a 00 00       	mov    %eax,0xa94
      return (void*)(p + 1);
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 3b                	jmp    80c <malloc+0xe1>
    }
    if(p == freep)
 7d1:	a1 94 0a 00 00       	mov    0xa94,%eax
 7d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d9:	75 1e                	jne    7f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	ff 75 ec             	pushl  -0x14(%ebp)
 7e1:	e8 e5 fe ff ff       	call   6cb <morecore>
 7e6:	83 c4 10             	add    $0x10,%esp
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <malloc+0xce>
        return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 13                	jmp    80c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 807:	e9 6d ff ff ff       	jmp    779 <malloc+0x4e>
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    
