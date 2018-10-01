
_sanity3:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
    int pid;
    printf(1,"Father pid is %d" ,getpid());
  11:	e8 8a 03 00 00       	call   3a0 <getpid>
  16:	83 ec 04             	sub    $0x4,%esp
  19:	50                   	push   %eax
  1a:	68 68 08 00 00       	push   $0x868
  1f:	6a 01                	push   $0x1
  21:	e8 89 04 00 00       	call   4af <printf>
  26:	83 c4 10             	add    $0x10,%esp
    sleep(10000);
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	68 10 27 00 00       	push   $0x2710
  31:	e8 7a 03 00 00       	call   3b0 <sleep>
  36:	83 c4 10             	add    $0x10,%esp
    printf(1,"Father is awake");
  39:	83 ec 08             	sub    $0x8,%esp
  3c:	68 79 08 00 00       	push   $0x879
  41:	6a 01                	push   $0x1
  43:	e8 67 04 00 00       	call   4af <printf>
  48:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  4b:	e8 c8 02 00 00       	call   318 <fork>
  50:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid  != 0 ){ //father
  53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  57:	74 2d                	je     86 <main+0x86>
        for(int i=0; i<50; i++){
  59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  60:	eb 1c                	jmp    7e <main+0x7e>
            printf(1,"Process %d is printing for the %d time\n" , getpid() , i);
  62:	e8 39 03 00 00       	call   3a0 <getpid>
  67:	ff 75 f4             	pushl  -0xc(%ebp)
  6a:	50                   	push   %eax
  6b:	68 8c 08 00 00       	push   $0x88c
  70:	6a 01                	push   $0x1
  72:	e8 38 04 00 00       	call   4af <printf>
  77:	83 c4 10             	add    $0x10,%esp
    printf(1,"Father pid is %d" ,getpid());
    sleep(10000);
    printf(1,"Father is awake");
    pid = fork();
    if(pid  != 0 ){ //father
        for(int i=0; i<50; i++){
  7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  7e:	83 7d f4 31          	cmpl   $0x31,-0xc(%ebp)
  82:	7e de                	jle    62 <main+0x62>
  84:	eb 36                	jmp    bc <main+0xbc>
            printf(1,"Process %d is printing for the %d time\n" , getpid() , i);

        }
    }

    else if(pid  == 0 ){ //child
  86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8a:	75 30                	jne    bc <main+0xbc>
        for(int i=0; i<50; i++){
  8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  93:	eb 1c                	jmp    b1 <main+0xb1>
            printf(1,"Process %d is printing for the %d time\n" , getpid() , i);
  95:	e8 06 03 00 00       	call   3a0 <getpid>
  9a:	ff 75 f0             	pushl  -0x10(%ebp)
  9d:	50                   	push   %eax
  9e:	68 8c 08 00 00       	push   $0x88c
  a3:	6a 01                	push   $0x1
  a5:	e8 05 04 00 00       	call   4af <printf>
  aa:	83 c4 10             	add    $0x10,%esp

        }
    }

    else if(pid  == 0 ){ //child
        for(int i=0; i<50; i++){
  ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  b1:	83 7d f0 31          	cmpl   $0x31,-0x10(%ebp)
  b5:	7e de                	jle    95 <main+0x95>
            printf(1,"Process %d is printing for the %d time\n" , getpid() , i);

        }
        exit();
  b7:	e8 64 02 00 00       	call   320 <exit>
    }


	return 0;
  bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  c4:	c9                   	leave  
  c5:	8d 61 fc             	lea    -0x4(%ecx),%esp
  c8:	c3                   	ret    

000000c9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  cc:	57                   	push   %edi
  cd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d1:	8b 55 10             	mov    0x10(%ebp),%edx
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	89 cb                	mov    %ecx,%ebx
  d9:	89 df                	mov    %ebx,%edi
  db:	89 d1                	mov    %edx,%ecx
  dd:	fc                   	cld    
  de:	f3 aa                	rep stos %al,%es:(%edi)
  e0:	89 ca                	mov    %ecx,%edx
  e2:	89 fb                	mov    %edi,%ebx
  e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ea:	90                   	nop
  eb:	5b                   	pop    %ebx
  ec:	5f                   	pop    %edi
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  fb:	90                   	nop
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	8d 50 01             	lea    0x1(%eax),%edx
 102:	89 55 08             	mov    %edx,0x8(%ebp)
 105:	8b 55 0c             	mov    0xc(%ebp),%edx
 108:	8d 4a 01             	lea    0x1(%edx),%ecx
 10b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 10e:	0f b6 12             	movzbl (%edx),%edx
 111:	88 10                	mov    %dl,(%eax)
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	84 c0                	test   %al,%al
 118:	75 e2                	jne    fc <strcpy+0xd>
    ;
  return os;
 11a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 122:	eb 08                	jmp    12c <strcmp+0xd>
    p++, q++;
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	84 c0                	test   %al,%al
 134:	74 10                	je     146 <strcmp+0x27>
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	0f b6 10             	movzbl (%eax),%edx
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	38 c2                	cmp    %al,%dl
 144:	74 de                	je     124 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	0f b6 d0             	movzbl %al,%edx
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	0f b6 00             	movzbl (%eax),%eax
 155:	0f b6 c0             	movzbl %al,%eax
 158:	29 c2                	sub    %eax,%edx
 15a:	89 d0                	mov    %edx,%eax
}
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    

0000015e <strlen>:

uint
strlen(char *s)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 16b:	eb 04                	jmp    171 <strlen+0x13>
 16d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 171:	8b 55 fc             	mov    -0x4(%ebp),%edx
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	01 d0                	add    %edx,%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	84 c0                	test   %al,%al
 17e:	75 ed                	jne    16d <strlen+0xf>
    ;
  return n;
 180:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <memset>:

void*
memset(void *dst, int c, uint n)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 188:	8b 45 10             	mov    0x10(%ebp),%eax
 18b:	50                   	push   %eax
 18c:	ff 75 0c             	pushl  0xc(%ebp)
 18f:	ff 75 08             	pushl  0x8(%ebp)
 192:	e8 32 ff ff ff       	call   c9 <stosb>
 197:	83 c4 0c             	add    $0xc,%esp
  return dst;
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <strchr>:

char*
strchr(const char *s, char c)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	83 ec 04             	sub    $0x4,%esp
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ab:	eb 14                	jmp    1c1 <strchr+0x22>
    if(*s == c)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b6:	75 05                	jne    1bd <strchr+0x1e>
      return (char*)s;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	eb 13                	jmp    1d0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	84 c0                	test   %al,%al
 1c9:	75 e2                	jne    1ad <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    

000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1df:	eb 42                	jmp    223 <gets+0x51>
    cc = read(0, &c, 1);
 1e1:	83 ec 04             	sub    $0x4,%esp
 1e4:	6a 01                	push   $0x1
 1e6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e9:	50                   	push   %eax
 1ea:	6a 00                	push   $0x0
 1ec:	e8 47 01 00 00       	call   338 <read>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1fb:	7e 33                	jle    230 <gets+0x5e>
      break;
    buf[i++] = c;
 1fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 200:	8d 50 01             	lea    0x1(%eax),%edx
 203:	89 55 f4             	mov    %edx,-0xc(%ebp)
 206:	89 c2                	mov    %eax,%edx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	01 c2                	add    %eax,%edx
 20d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 211:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 213:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 217:	3c 0a                	cmp    $0xa,%al
 219:	74 16                	je     231 <gets+0x5f>
 21b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21f:	3c 0d                	cmp    $0xd,%al
 221:	74 0e                	je     231 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 223:	8b 45 f4             	mov    -0xc(%ebp),%eax
 226:	83 c0 01             	add    $0x1,%eax
 229:	3b 45 0c             	cmp    0xc(%ebp),%eax
 22c:	7c b3                	jl     1e1 <gets+0xf>
 22e:	eb 01                	jmp    231 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 230:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 231:	8b 55 f4             	mov    -0xc(%ebp),%edx
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	01 d0                	add    %edx,%eax
 239:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 23f:	c9                   	leave  
 240:	c3                   	ret    

00000241 <stat>:

int
stat(char *n, struct stat *st)
{
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
 244:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 247:	83 ec 08             	sub    $0x8,%esp
 24a:	6a 00                	push   $0x0
 24c:	ff 75 08             	pushl  0x8(%ebp)
 24f:	e8 0c 01 00 00       	call   360 <open>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 25a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25e:	79 07                	jns    267 <stat+0x26>
    return -1;
 260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 265:	eb 25                	jmp    28c <stat+0x4b>
  r = fstat(fd, st);
 267:	83 ec 08             	sub    $0x8,%esp
 26a:	ff 75 0c             	pushl  0xc(%ebp)
 26d:	ff 75 f4             	pushl  -0xc(%ebp)
 270:	e8 03 01 00 00       	call   378 <fstat>
 275:	83 c4 10             	add    $0x10,%esp
 278:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	ff 75 f4             	pushl  -0xc(%ebp)
 281:	e8 c2 00 00 00       	call   348 <close>
 286:	83 c4 10             	add    $0x10,%esp
  return r;
 289:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 28c:	c9                   	leave  
 28d:	c3                   	ret    

0000028e <atoi>:

int
atoi(const char *s)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 29b:	eb 25                	jmp    2c2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 29d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a0:	89 d0                	mov    %edx,%eax
 2a2:	c1 e0 02             	shl    $0x2,%eax
 2a5:	01 d0                	add    %edx,%eax
 2a7:	01 c0                	add    %eax,%eax
 2a9:	89 c1                	mov    %eax,%ecx
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	8d 50 01             	lea    0x1(%eax),%edx
 2b1:	89 55 08             	mov    %edx,0x8(%ebp)
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	0f be c0             	movsbl %al,%eax
 2ba:	01 c8                	add    %ecx,%eax
 2bc:	83 e8 30             	sub    $0x30,%eax
 2bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	3c 2f                	cmp    $0x2f,%al
 2ca:	7e 0a                	jle    2d6 <atoi+0x48>
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 39                	cmp    $0x39,%al
 2d4:	7e c7                	jle    29d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d9:	c9                   	leave  
 2da:	c3                   	ret    

000002db <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2db:	55                   	push   %ebp
 2dc:	89 e5                	mov    %esp,%ebp
 2de:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ed:	eb 17                	jmp    306 <memmove+0x2b>
    *dst++ = *src++;
 2ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f2:	8d 50 01             	lea    0x1(%eax),%edx
 2f5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2fb:	8d 4a 01             	lea    0x1(%edx),%ecx
 2fe:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 301:	0f b6 12             	movzbl (%edx),%edx
 304:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 306:	8b 45 10             	mov    0x10(%ebp),%eax
 309:	8d 50 ff             	lea    -0x1(%eax),%edx
 30c:	89 55 10             	mov    %edx,0x10(%ebp)
 30f:	85 c0                	test   %eax,%eax
 311:	7f dc                	jg     2ef <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 313:	8b 45 08             	mov    0x8(%ebp),%eax
}
 316:	c9                   	leave  
 317:	c3                   	ret    

00000318 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 318:	b8 01 00 00 00       	mov    $0x1,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <exit>:
SYSCALL(exit)
 320:	b8 02 00 00 00       	mov    $0x2,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <wait>:
SYSCALL(wait)
 328:	b8 03 00 00 00       	mov    $0x3,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <pipe>:
SYSCALL(pipe)
 330:	b8 04 00 00 00       	mov    $0x4,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <read>:
SYSCALL(read)
 338:	b8 05 00 00 00       	mov    $0x5,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <write>:
SYSCALL(write)
 340:	b8 10 00 00 00       	mov    $0x10,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <close>:
SYSCALL(close)
 348:	b8 15 00 00 00       	mov    $0x15,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <kill>:
SYSCALL(kill)
 350:	b8 06 00 00 00       	mov    $0x6,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <exec>:
SYSCALL(exec)
 358:	b8 07 00 00 00       	mov    $0x7,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <open>:
SYSCALL(open)
 360:	b8 0f 00 00 00       	mov    $0xf,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <mknod>:
SYSCALL(mknod)
 368:	b8 11 00 00 00       	mov    $0x11,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <unlink>:
SYSCALL(unlink)
 370:	b8 12 00 00 00       	mov    $0x12,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <fstat>:
SYSCALL(fstat)
 378:	b8 08 00 00 00       	mov    $0x8,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <link>:
SYSCALL(link)
 380:	b8 13 00 00 00       	mov    $0x13,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <mkdir>:
SYSCALL(mkdir)
 388:	b8 14 00 00 00       	mov    $0x14,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <chdir>:
SYSCALL(chdir)
 390:	b8 09 00 00 00       	mov    $0x9,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <dup>:
SYSCALL(dup)
 398:	b8 0a 00 00 00       	mov    $0xa,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <getpid>:
SYSCALL(getpid)
 3a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <sbrk>:
SYSCALL(sbrk)
 3a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <sleep>:
SYSCALL(sleep)
 3b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <uptime>:
SYSCALL(uptime)
 3b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <getppid>:
SYSCALL(getppid)
 3c0:	b8 16 00 00 00       	mov    $0x16,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <wait2>:
SYSCALL(wait2)
 3c8:	b8 18 00 00 00       	mov    $0x18,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <nice>:
SYSCALL(nice)
 3d0:	b8 17 00 00 00       	mov    $0x17,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 18             	sub    $0x18,%esp
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e4:	83 ec 04             	sub    $0x4,%esp
 3e7:	6a 01                	push   $0x1
 3e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ec:	50                   	push   %eax
 3ed:	ff 75 08             	pushl  0x8(%ebp)
 3f0:	e8 4b ff ff ff       	call   340 <write>
 3f5:	83 c4 10             	add    $0x10,%esp
}
 3f8:	90                   	nop
 3f9:	c9                   	leave  
 3fa:	c3                   	ret    

000003fb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	53                   	push   %ebx
 3ff:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 402:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 409:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40d:	74 17                	je     426 <printint+0x2b>
 40f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 413:	79 11                	jns    426 <printint+0x2b>
    neg = 1;
 415:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	f7 d8                	neg    %eax
 421:	89 45 ec             	mov    %eax,-0x14(%ebp)
 424:	eb 06                	jmp    42c <printint+0x31>
  } else {
    x = xx;
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 433:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 436:	8d 41 01             	lea    0x1(%ecx),%eax
 439:	89 45 f4             	mov    %eax,-0xc(%ebp)
 43c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 442:	ba 00 00 00 00       	mov    $0x0,%edx
 447:	f7 f3                	div    %ebx
 449:	89 d0                	mov    %edx,%eax
 44b:	0f b6 80 0c 0b 00 00 	movzbl 0xb0c(%eax),%eax
 452:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 456:	8b 5d 10             	mov    0x10(%ebp),%ebx
 459:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45c:	ba 00 00 00 00       	mov    $0x0,%edx
 461:	f7 f3                	div    %ebx
 463:	89 45 ec             	mov    %eax,-0x14(%ebp)
 466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46a:	75 c7                	jne    433 <printint+0x38>
  if(neg)
 46c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 470:	74 2d                	je     49f <printint+0xa4>
    buf[i++] = '-';
 472:	8b 45 f4             	mov    -0xc(%ebp),%eax
 475:	8d 50 01             	lea    0x1(%eax),%edx
 478:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 480:	eb 1d                	jmp    49f <printint+0xa4>
    putc(fd, buf[i]);
 482:	8d 55 dc             	lea    -0x24(%ebp),%edx
 485:	8b 45 f4             	mov    -0xc(%ebp),%eax
 488:	01 d0                	add    %edx,%eax
 48a:	0f b6 00             	movzbl (%eax),%eax
 48d:	0f be c0             	movsbl %al,%eax
 490:	83 ec 08             	sub    $0x8,%esp
 493:	50                   	push   %eax
 494:	ff 75 08             	pushl  0x8(%ebp)
 497:	e8 3c ff ff ff       	call   3d8 <putc>
 49c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 49f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a7:	79 d9                	jns    482 <printint+0x87>
    putc(fd, buf[i]);
}
 4a9:	90                   	nop
 4aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ad:	c9                   	leave  
 4ae:	c3                   	ret    

000004af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4af:	55                   	push   %ebp
 4b0:	89 e5                	mov    %esp,%ebp
 4b2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4bc:	8d 45 0c             	lea    0xc(%ebp),%eax
 4bf:	83 c0 04             	add    $0x4,%eax
 4c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4cc:	e9 59 01 00 00       	jmp    62a <printf+0x17b>
    c = fmt[i] & 0xff;
 4d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d7:	01 d0                	add    %edx,%eax
 4d9:	0f b6 00             	movzbl (%eax),%eax
 4dc:	0f be c0             	movsbl %al,%eax
 4df:	25 ff 00 00 00       	and    $0xff,%eax
 4e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4eb:	75 2c                	jne    519 <printf+0x6a>
      if(c == '%'){
 4ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f1:	75 0c                	jne    4ff <printf+0x50>
        state = '%';
 4f3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4fa:	e9 27 01 00 00       	jmp    626 <printf+0x177>
      } else {
        putc(fd, c);
 4ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 502:	0f be c0             	movsbl %al,%eax
 505:	83 ec 08             	sub    $0x8,%esp
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 c7 fe ff ff       	call   3d8 <putc>
 511:	83 c4 10             	add    $0x10,%esp
 514:	e9 0d 01 00 00       	jmp    626 <printf+0x177>
      }
    } else if(state == '%'){
 519:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 51d:	0f 85 03 01 00 00    	jne    626 <printf+0x177>
      if(c == 'd'){
 523:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 527:	75 1e                	jne    547 <printf+0x98>
        printint(fd, *ap, 10, 1);
 529:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52c:	8b 00                	mov    (%eax),%eax
 52e:	6a 01                	push   $0x1
 530:	6a 0a                	push   $0xa
 532:	50                   	push   %eax
 533:	ff 75 08             	pushl  0x8(%ebp)
 536:	e8 c0 fe ff ff       	call   3fb <printint>
 53b:	83 c4 10             	add    $0x10,%esp
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 542:	e9 d8 00 00 00       	jmp    61f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 547:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 54b:	74 06                	je     553 <printf+0xa4>
 54d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 551:	75 1e                	jne    571 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 553:	8b 45 e8             	mov    -0x18(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	6a 00                	push   $0x0
 55a:	6a 10                	push   $0x10
 55c:	50                   	push   %eax
 55d:	ff 75 08             	pushl  0x8(%ebp)
 560:	e8 96 fe ff ff       	call   3fb <printint>
 565:	83 c4 10             	add    $0x10,%esp
        ap++;
 568:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56c:	e9 ae 00 00 00       	jmp    61f <printf+0x170>
      } else if(c == 's'){
 571:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 575:	75 43                	jne    5ba <printf+0x10b>
        s = (char*)*ap;
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 587:	75 25                	jne    5ae <printf+0xff>
          s = "(null)";
 589:	c7 45 f4 b4 08 00 00 	movl   $0x8b4,-0xc(%ebp)
        while(*s != 0){
 590:	eb 1c                	jmp    5ae <printf+0xff>
          putc(fd, *s);
 592:	8b 45 f4             	mov    -0xc(%ebp),%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 31 fe ff ff       	call   3d8 <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
          s++;
 5aa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	0f b6 00             	movzbl (%eax),%eax
 5b4:	84 c0                	test   %al,%al
 5b6:	75 da                	jne    592 <printf+0xe3>
 5b8:	eb 65                	jmp    61f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ba:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5be:	75 1d                	jne    5dd <printf+0x12e>
        putc(fd, *ap);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	83 ec 08             	sub    $0x8,%esp
 5cb:	50                   	push   %eax
 5cc:	ff 75 08             	pushl  0x8(%ebp)
 5cf:	e8 04 fe ff ff       	call   3d8 <putc>
 5d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5db:	eb 42                	jmp    61f <printf+0x170>
      } else if(c == '%'){
 5dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e1:	75 17                	jne    5fa <printf+0x14b>
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 e3 fd ff ff       	call   3d8 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	eb 25                	jmp    61f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	83 ec 08             	sub    $0x8,%esp
 5fd:	6a 25                	push   $0x25
 5ff:	ff 75 08             	pushl  0x8(%ebp)
 602:	e8 d1 fd ff ff       	call   3d8 <putc>
 607:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 ec 08             	sub    $0x8,%esp
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 bc fd ff ff       	call   3d8 <putc>
 61c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 61f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 626:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 62a:	8b 55 0c             	mov    0xc(%ebp),%edx
 62d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 630:	01 d0                	add    %edx,%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	84 c0                	test   %al,%al
 637:	0f 85 94 fe ff ff    	jne    4d1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63d:	90                   	nop
 63e:	c9                   	leave  
 63f:	c3                   	ret    

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	83 e8 08             	sub    $0x8,%eax
 64c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	a1 28 0b 00 00       	mov    0xb28,%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	eb 24                	jmp    67d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 12                	ja     675 <free+0x35>
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 669:	77 24                	ja     68f <free+0x4f>
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 673:	77 1a                	ja     68f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	76 d4                	jbe    659 <free+0x19>
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	76 ca                	jbe    659 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	39 c2                	cmp    %eax,%edx
 6a8:	75 24                	jne    6ce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
 6cc:	eb 0a                	jmp    6d8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	01 d0                	add    %edx,%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	75 20                	jne    70f <free+0xcf>
    p->s.size += bp->s.size;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	01 c2                	add    %eax,%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	89 10                	mov    %edx,(%eax)
 70d:	eb 08                	jmp    717 <free+0xd7>
  } else
    p->s.ptr = bp;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 55 f8             	mov    -0x8(%ebp),%edx
 715:	89 10                	mov    %edx,(%eax)
  freep = p;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	a3 28 0b 00 00       	mov    %eax,0xb28
}
 71f:	90                   	nop
 720:	c9                   	leave  
 721:	c3                   	ret    

00000722 <morecore>:

static Header*
morecore(uint nu)
{
 722:	55                   	push   %ebp
 723:	89 e5                	mov    %esp,%ebp
 725:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 728:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72f:	77 07                	ja     738 <morecore+0x16>
    nu = 4096;
 731:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	c1 e0 03             	shl    $0x3,%eax
 73e:	83 ec 0c             	sub    $0xc,%esp
 741:	50                   	push   %eax
 742:	e8 61 fc ff ff       	call   3a8 <sbrk>
 747:	83 c4 10             	add    $0x10,%esp
 74a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 751:	75 07                	jne    75a <morecore+0x38>
    return 0;
 753:	b8 00 00 00 00       	mov    $0x0,%eax
 758:	eb 26                	jmp    780 <morecore+0x5e>
  hp = (Header*)p;
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	8b 55 08             	mov    0x8(%ebp),%edx
 766:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	83 c0 08             	add    $0x8,%eax
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	50                   	push   %eax
 773:	e8 c8 fe ff ff       	call   640 <free>
 778:	83 c4 10             	add    $0x10,%esp
  return freep;
 77b:	a1 28 0b 00 00       	mov    0xb28,%eax
}
 780:	c9                   	leave  
 781:	c3                   	ret    

00000782 <malloc>:

void*
malloc(uint nbytes)
{
 782:	55                   	push   %ebp
 783:	89 e5                	mov    %esp,%ebp
 785:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	83 c0 07             	add    $0x7,%eax
 78e:	c1 e8 03             	shr    $0x3,%eax
 791:	83 c0 01             	add    $0x1,%eax
 794:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 797:	a1 28 0b 00 00       	mov    0xb28,%eax
 79c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a3:	75 23                	jne    7c8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a5:	c7 45 f0 20 0b 00 00 	movl   $0xb20,-0x10(%ebp)
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	a3 28 0b 00 00       	mov    %eax,0xb28
 7b4:	a1 28 0b 00 00       	mov    0xb28,%eax
 7b9:	a3 20 0b 00 00       	mov    %eax,0xb20
    base.s.size = 0;
 7be:	c7 05 24 0b 00 00 00 	movl   $0x0,0xb24
 7c5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d9:	72 4d                	jb     828 <malloc+0xa6>
      if(p->s.size == nunits)
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e4:	75 0c                	jne    7f2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ee:	89 10                	mov    %edx,(%eax)
 7f0:	eb 26                	jmp    818 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7fb:	89 c2                	mov    %eax,%edx
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	c1 e0 03             	shl    $0x3,%eax
 80c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	8b 55 ec             	mov    -0x14(%ebp),%edx
 815:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	a3 28 0b 00 00       	mov    %eax,0xb28
      return (void*)(p + 1);
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	83 c0 08             	add    $0x8,%eax
 826:	eb 3b                	jmp    863 <malloc+0xe1>
    }
    if(p == freep)
 828:	a1 28 0b 00 00       	mov    0xb28,%eax
 82d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 830:	75 1e                	jne    850 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 832:	83 ec 0c             	sub    $0xc,%esp
 835:	ff 75 ec             	pushl  -0x14(%ebp)
 838:	e8 e5 fe ff ff       	call   722 <morecore>
 83d:	83 c4 10             	add    $0x10,%esp
 840:	89 45 f4             	mov    %eax,-0xc(%ebp)
 843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 847:	75 07                	jne    850 <malloc+0xce>
        return 0;
 849:	b8 00 00 00 00       	mov    $0x0,%eax
 84e:	eb 13                	jmp    863 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	89 45 f0             	mov    %eax,-0x10(%ebp)
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 00                	mov    (%eax),%eax
 85b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85e:	e9 6d ff ff ff       	jmp    7d0 <malloc+0x4e>
}
 863:	c9                   	leave  
 864:	c3                   	ret    
