
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 01 08 00 00       	mov    $0x801,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 03 08 00 00       	mov    $0x803,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 05 08 00 00       	push   $0x805
  4b:	6a 01                	push   $0x1
  4d:	e8 f9 03 00 00       	call   44b <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 57 02 00 00       	call   2bc <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 47 01 00 00       	call   2d4 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 0c 01 00 00       	call   2fc <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 03 01 00 00       	call   314 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 c2 00 00 00       	call   2e4 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x34>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x48>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 289:	eb 17                	jmp    2a2 <memmove+0x2b>
    *dst++ = *src++;
 28b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28e:	8d 50 01             	lea    0x1(%eax),%edx
 291:	89 55 fc             	mov    %edx,-0x4(%ebp)
 294:	8b 55 f8             	mov    -0x8(%ebp),%edx
 297:	8d 4a 01             	lea    0x1(%edx),%ecx
 29a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29d:	0f b6 12             	movzbl (%edx),%edx
 2a0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a8:	89 55 10             	mov    %edx,0x10(%ebp)
 2ab:	85 c0                	test   %eax,%eax
 2ad:	7f dc                	jg     28b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <getppid>:
SYSCALL(getppid)
 35c:	b8 16 00 00 00       	mov    $0x16,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <wait2>:
SYSCALL(wait2)
 364:	b8 18 00 00 00       	mov    $0x18,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <nice>:
SYSCALL(nice)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 18             	sub    $0x18,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	8d 45 f4             	lea    -0xc(%ebp),%eax
 388:	50                   	push   %eax
 389:	ff 75 08             	pushl  0x8(%ebp)
 38c:	e8 4b ff ff ff       	call   2dc <write>
 391:	83 c4 10             	add    $0x10,%esp
}
 394:	90                   	nop
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	53                   	push   %ebx
 39b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a9:	74 17                	je     3c2 <printint+0x2b>
 3ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3af:	79 11                	jns    3c2 <printint+0x2b>
    neg = 1;
 3b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	f7 d8                	neg    %eax
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c0:	eb 06                	jmp    3c8 <printint+0x31>
  } else {
    x = xx;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d2:	8d 41 01             	lea    0x1(%ecx),%eax
 3d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f3                	div    %ebx
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	0f b6 80 60 0a 00 00 	movzbl 0xa60(%eax),%eax
 3ee:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f8:	ba 00 00 00 00       	mov    $0x0,%edx
 3fd:	f7 f3                	div    %ebx
 3ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
 402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 406:	75 c7                	jne    3cf <printint+0x38>
  if(neg)
 408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40c:	74 2d                	je     43b <printint+0xa4>
    buf[i++] = '-';
 40e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 411:	8d 50 01             	lea    0x1(%eax),%edx
 414:	89 55 f4             	mov    %edx,-0xc(%ebp)
 417:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 41c:	eb 1d                	jmp    43b <printint+0xa4>
    putc(fd, buf[i]);
 41e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 421:	8b 45 f4             	mov    -0xc(%ebp),%eax
 424:	01 d0                	add    %edx,%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	0f be c0             	movsbl %al,%eax
 42c:	83 ec 08             	sub    $0x8,%esp
 42f:	50                   	push   %eax
 430:	ff 75 08             	pushl  0x8(%ebp)
 433:	e8 3c ff ff ff       	call   374 <putc>
 438:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 43f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 443:	79 d9                	jns    41e <printint+0x87>
    putc(fd, buf[i]);
}
 445:	90                   	nop
 446:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 451:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 458:	8d 45 0c             	lea    0xc(%ebp),%eax
 45b:	83 c0 04             	add    $0x4,%eax
 45e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 468:	e9 59 01 00 00       	jmp    5c6 <printf+0x17b>
    c = fmt[i] & 0xff;
 46d:	8b 55 0c             	mov    0xc(%ebp),%edx
 470:	8b 45 f0             	mov    -0x10(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	0f be c0             	movsbl %al,%eax
 47b:	25 ff 00 00 00       	and    $0xff,%eax
 480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 487:	75 2c                	jne    4b5 <printf+0x6a>
      if(c == '%'){
 489:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48d:	75 0c                	jne    49b <printf+0x50>
        state = '%';
 48f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 496:	e9 27 01 00 00       	jmp    5c2 <printf+0x177>
      } else {
        putc(fd, c);
 49b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	83 ec 08             	sub    $0x8,%esp
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 c7 fe ff ff       	call   374 <putc>
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	e9 0d 01 00 00       	jmp    5c2 <printf+0x177>
      }
    } else if(state == '%'){
 4b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b9:	0f 85 03 01 00 00    	jne    5c2 <printf+0x177>
      if(c == 'd'){
 4bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c3:	75 1e                	jne    4e3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c8:	8b 00                	mov    (%eax),%eax
 4ca:	6a 01                	push   $0x1
 4cc:	6a 0a                	push   $0xa
 4ce:	50                   	push   %eax
 4cf:	ff 75 08             	pushl  0x8(%ebp)
 4d2:	e8 c0 fe ff ff       	call   397 <printint>
 4d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4de:	e9 d8 00 00 00       	jmp    5bb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e7:	74 06                	je     4ef <printf+0xa4>
 4e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ed:	75 1e                	jne    50d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f2:	8b 00                	mov    (%eax),%eax
 4f4:	6a 00                	push   $0x0
 4f6:	6a 10                	push   $0x10
 4f8:	50                   	push   %eax
 4f9:	ff 75 08             	pushl  0x8(%ebp)
 4fc:	e8 96 fe ff ff       	call   397 <printint>
 501:	83 c4 10             	add    $0x10,%esp
        ap++;
 504:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 508:	e9 ae 00 00 00       	jmp    5bb <printf+0x170>
      } else if(c == 's'){
 50d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 511:	75 43                	jne    556 <printf+0x10b>
        s = (char*)*ap;
 513:	8b 45 e8             	mov    -0x18(%ebp),%eax
 516:	8b 00                	mov    (%eax),%eax
 518:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 523:	75 25                	jne    54a <printf+0xff>
          s = "(null)";
 525:	c7 45 f4 0a 08 00 00 	movl   $0x80a,-0xc(%ebp)
        while(*s != 0){
 52c:	eb 1c                	jmp    54a <printf+0xff>
          putc(fd, *s);
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	83 ec 08             	sub    $0x8,%esp
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 31 fe ff ff       	call   374 <putc>
 543:	83 c4 10             	add    $0x10,%esp
          s++;
 546:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	84 c0                	test   %al,%al
 552:	75 da                	jne    52e <printf+0xe3>
 554:	eb 65                	jmp    5bb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 556:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55a:	75 1d                	jne    579 <printf+0x12e>
        putc(fd, *ap);
 55c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55f:	8b 00                	mov    (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	83 ec 08             	sub    $0x8,%esp
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 04 fe ff ff       	call   374 <putc>
 570:	83 c4 10             	add    $0x10,%esp
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 577:	eb 42                	jmp    5bb <printf+0x170>
      } else if(c == '%'){
 579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57d:	75 17                	jne    596 <printf+0x14b>
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 e3 fd ff ff       	call   374 <putc>
 591:	83 c4 10             	add    $0x10,%esp
 594:	eb 25                	jmp    5bb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 596:	83 ec 08             	sub    $0x8,%esp
 599:	6a 25                	push   $0x25
 59b:	ff 75 08             	pushl  0x8(%ebp)
 59e:	e8 d1 fd ff ff       	call   374 <putc>
 5a3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	83 ec 08             	sub    $0x8,%esp
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 bc fd ff ff       	call   374 <putc>
 5b8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cc:	01 d0                	add    %edx,%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	84 c0                	test   %al,%al
 5d3:	0f 85 94 fe ff ff    	jne    46d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d9:	90                   	nop
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	83 e8 08             	sub    $0x8,%eax
 5e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5eb:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f3:	eb 24                	jmp    619 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fd:	77 12                	ja     611 <free+0x35>
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 24                	ja     62b <free+0x4f>
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60f:	77 1a                	ja     62b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	89 45 fc             	mov    %eax,-0x4(%ebp)
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61f:	76 d4                	jbe    5f5 <free+0x19>
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 629:	76 ca                	jbe    5f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	8b 40 04             	mov    0x4(%eax),%eax
 631:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	01 c2                	add    %eax,%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	39 c2                	cmp    %eax,%edx
 644:	75 24                	jne    66a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 50 04             	mov    0x4(%eax),%edx
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	8b 40 04             	mov    0x4(%eax),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 10                	mov    %edx,(%eax)
 668:	eb 0a                	jmp    674 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	01 d0                	add    %edx,%eax
 686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 689:	75 20                	jne    6ab <free+0xcf>
    p->s.size += bp->s.size;
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 08                	jmp    6b3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6bb:	90                   	nop
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <morecore>:

static Header*
morecore(uint nu)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cb:	77 07                	ja     6d4 <morecore+0x16>
    nu = 4096;
 6cd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	c1 e0 03             	shl    $0x3,%eax
 6da:	83 ec 0c             	sub    $0xc,%esp
 6dd:	50                   	push   %eax
 6de:	e8 61 fc ff ff       	call   344 <sbrk>
 6e3:	83 c4 10             	add    $0x10,%esp
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ed:	75 07                	jne    6f6 <morecore+0x38>
    return 0;
 6ef:	b8 00 00 00 00       	mov    $0x0,%eax
 6f4:	eb 26                	jmp    71c <morecore+0x5e>
  hp = (Header*)p;
 6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	8b 55 08             	mov    0x8(%ebp),%edx
 702:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	83 c0 08             	add    $0x8,%eax
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	50                   	push   %eax
 70f:	e8 c8 fe ff ff       	call   5dc <free>
 714:	83 c4 10             	add    $0x10,%esp
  return freep;
 717:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <malloc>:

void*
malloc(uint nbytes)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	83 c0 07             	add    $0x7,%eax
 72a:	c1 e8 03             	shr    $0x3,%eax
 72d:	83 c0 01             	add    $0x1,%eax
 730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 733:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 738:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73f:	75 23                	jne    764 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 741:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 750:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 755:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 75a:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 761:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 764:	8b 45 f0             	mov    -0x10(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 775:	72 4d                	jb     7c4 <malloc+0xa6>
      if(p->s.size == nunits)
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 780:	75 0c                	jne    78e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
 78c:	eb 26                	jmp    7b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	2b 45 ec             	sub    -0x14(%ebp),%eax
 797:	89 c2                	mov    %eax,%edx
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	c1 e0 03             	shl    $0x3,%eax
 7a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	83 c0 08             	add    $0x8,%eax
 7c2:	eb 3b                	jmp    7ff <malloc+0xe1>
    }
    if(p == freep)
 7c4:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7cc:	75 1e                	jne    7ec <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ce:	83 ec 0c             	sub    $0xc,%esp
 7d1:	ff 75 ec             	pushl  -0x14(%ebp)
 7d4:	e8 e5 fe ff ff       	call   6be <morecore>
 7d9:	83 c4 10             	add    $0x10,%esp
 7dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e3:	75 07                	jne    7ec <malloc+0xce>
        return 0;
 7e5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ea:	eb 13                	jmp    7ff <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7fa:	e9 6d ff ff ff       	jmp    76c <malloc+0x4e>
}
 7ff:	c9                   	leave  
 800:	c3                   	ret    
