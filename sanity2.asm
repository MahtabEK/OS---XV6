
_sanity2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"



int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 44             	sub    $0x44,%esp

	int pid[10];
	for( int i = 0 ; i < 10 ; i++ ){
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  18:	e9 af 00 00 00       	jmp    cc <main+0xcc>
		pid[i] = fork();
  1d:	e8 10 03 00 00       	call   332 <fork>
  22:	89 c2                	mov    %eax,%edx
  24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  27:	89 54 85 c4          	mov    %edx,-0x3c(%ebp,%eax,4)
		if( pid[i] < 0 ) {
  2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
  32:	85 c0                	test   %eax,%eax
  34:	79 1c                	jns    52 <main+0x52>
			printf(1, "Error");
  36:	83 ec 08             	sub    $0x8,%esp
  39:	68 7f 08 00 00       	push   $0x87f
  3e:	6a 01                	push   $0x1
  40:	e8 84 04 00 00       	call   4c9 <printf>
  45:	83 c4 10             	add    $0x10,%esp
			return -1;
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	e9 89 00 00 00       	jmp    db <main+0xdb>
		}
		else if( pid[i] == 0 ){ //child
  52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  55:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
  59:	85 c0                	test   %eax,%eax
  5b:	75 48                	jne    a5 <main+0xa5>
			for(int g =0; g<1000;g++){
  5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  64:	eb 19                	jmp    7f <main+0x7f>
            printf(1 ," time is: %d\n",g);
  66:	83 ec 04             	sub    $0x4,%esp
  69:	ff 75 f0             	pushl  -0x10(%ebp)
  6c:	68 85 08 00 00       	push   $0x885
  71:	6a 01                	push   $0x1
  73:	e8 51 04 00 00       	call   4c9 <printf>
  78:	83 c4 10             	add    $0x10,%esp
		if( pid[i] < 0 ) {
			printf(1, "Error");
			return -1;
		}
		else if( pid[i] == 0 ){ //child
			for(int g =0; g<1000;g++){
  7b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  7f:	81 7d f0 e7 03 00 00 	cmpl   $0x3e7,-0x10(%ebp)
  86:	7e de                	jle    66 <main+0x66>
            printf(1 ," time is: %d\n",g);
			}
			printf(1 , "my pid is: %d\n" , getpid());
  88:	e8 2d 03 00 00       	call   3ba <getpid>
  8d:	83 ec 04             	sub    $0x4,%esp
  90:	50                   	push   %eax
  91:	68 93 08 00 00       	push   $0x893
  96:	6a 01                	push   $0x1
  98:	e8 2c 04 00 00       	call   4c9 <printf>
  9d:	83 c4 10             	add    $0x10,%esp


			exit();
  a0:	e8 95 02 00 00       	call   33a <exit>
		}
		else if ( pid[i]  > 0 ) //parent
  a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
  ac:	85 c0                	test   %eax,%eax
  ae:	7e 18                	jle    c8 <main+0xc8>
		for( int i = 0 ; i < 10 ; i++ ){
  b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  b7:	eb 09                	jmp    c2 <main+0xc2>
            wait();
  b9:	e8 84 02 00 00       	call   342 <wait>


			exit();
		}
		else if ( pid[i]  > 0 ) //parent
		for( int i = 0 ; i < 10 ; i++ ){
  be:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  c2:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  c6:	7e f1                	jle    b9 <main+0xb9>


int main(){

	int pid[10];
	for( int i = 0 ; i < 10 ; i++ ){
  c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  cc:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  d0:	0f 8e 47 ff ff ff    	jle    1d <main+0x1d>

	}



	return 0;
  d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  db:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  de:	c9                   	leave  
  df:	8d 61 fc             	lea    -0x4(%ecx),%esp
  e2:	c3                   	ret    

000000e3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	57                   	push   %edi
  e7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  eb:	8b 55 10             	mov    0x10(%ebp),%edx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	89 cb                	mov    %ecx,%ebx
  f3:	89 df                	mov    %ebx,%edi
  f5:	89 d1                	mov    %edx,%ecx
  f7:	fc                   	cld    
  f8:	f3 aa                	rep stos %al,%es:(%edi)
  fa:	89 ca                	mov    %ecx,%edx
  fc:	89 fb                	mov    %edi,%ebx
  fe:	89 5d 08             	mov    %ebx,0x8(%ebp)
 101:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 104:	90                   	nop
 105:	5b                   	pop    %ebx
 106:	5f                   	pop    %edi
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 115:	90                   	nop
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	8d 50 01             	lea    0x1(%eax),%edx
 11c:	89 55 08             	mov    %edx,0x8(%ebp)
 11f:	8b 55 0c             	mov    0xc(%ebp),%edx
 122:	8d 4a 01             	lea    0x1(%edx),%ecx
 125:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 128:	0f b6 12             	movzbl (%edx),%edx
 12b:	88 10                	mov    %dl,(%eax)
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	75 e2                	jne    116 <strcpy+0xd>
    ;
  return os;
 134:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 13c:	eb 08                	jmp    146 <strcmp+0xd>
    p++, q++;
 13e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 142:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	84 c0                	test   %al,%al
 14e:	74 10                	je     160 <strcmp+0x27>
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	0f b6 10             	movzbl (%eax),%edx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 c2                	cmp    %al,%dl
 15e:	74 de                	je     13e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	0f b6 00             	movzbl (%eax),%eax
 166:	0f b6 d0             	movzbl %al,%edx
 169:	8b 45 0c             	mov    0xc(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	29 c2                	sub    %eax,%edx
 174:	89 d0                	mov    %edx,%eax
}
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strlen>:

uint
strlen(char *s)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 17e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 185:	eb 04                	jmp    18b <strlen+0x13>
 187:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 18b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	01 d0                	add    %edx,%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 ed                	jne    187 <strlen+0xf>
    ;
  return n;
 19a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <memset>:

void*
memset(void *dst, int c, uint n)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1a2:	8b 45 10             	mov    0x10(%ebp),%eax
 1a5:	50                   	push   %eax
 1a6:	ff 75 0c             	pushl  0xc(%ebp)
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 32 ff ff ff       	call   e3 <stosb>
 1b1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <strchr>:

char*
strchr(const char *s, char c)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 04             	sub    $0x4,%esp
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1c5:	eb 14                	jmp    1db <strchr+0x22>
    if(*s == c)
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1d0:	75 05                	jne    1d7 <strchr+0x1e>
      return (char*)s;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
 1d5:	eb 13                	jmp    1ea <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 00             	movzbl (%eax),%eax
 1e1:	84 c0                	test   %al,%al
 1e3:	75 e2                	jne    1c7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <gets>:

char*
gets(char *buf, int max)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1f9:	eb 42                	jmp    23d <gets+0x51>
    cc = read(0, &c, 1);
 1fb:	83 ec 04             	sub    $0x4,%esp
 1fe:	6a 01                	push   $0x1
 200:	8d 45 ef             	lea    -0x11(%ebp),%eax
 203:	50                   	push   %eax
 204:	6a 00                	push   $0x0
 206:	e8 47 01 00 00       	call   352 <read>
 20b:	83 c4 10             	add    $0x10,%esp
 20e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 215:	7e 33                	jle    24a <gets+0x5e>
      break;
    buf[i++] = c;
 217:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21a:	8d 50 01             	lea    0x1(%eax),%edx
 21d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 220:	89 c2                	mov    %eax,%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	01 c2                	add    %eax,%edx
 227:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 22d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 231:	3c 0a                	cmp    $0xa,%al
 233:	74 16                	je     24b <gets+0x5f>
 235:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 239:	3c 0d                	cmp    $0xd,%al
 23b:	74 0e                	je     24b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 240:	83 c0 01             	add    $0x1,%eax
 243:	3b 45 0c             	cmp    0xc(%ebp),%eax
 246:	7c b3                	jl     1fb <gets+0xf>
 248:	eb 01                	jmp    24b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 24a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 24b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 d0                	add    %edx,%eax
 253:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 256:	8b 45 08             	mov    0x8(%ebp),%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <stat>:

int
stat(char *n, struct stat *st)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 261:	83 ec 08             	sub    $0x8,%esp
 264:	6a 00                	push   $0x0
 266:	ff 75 08             	pushl  0x8(%ebp)
 269:	e8 0c 01 00 00       	call   37a <open>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 274:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 278:	79 07                	jns    281 <stat+0x26>
    return -1;
 27a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27f:	eb 25                	jmp    2a6 <stat+0x4b>
  r = fstat(fd, st);
 281:	83 ec 08             	sub    $0x8,%esp
 284:	ff 75 0c             	pushl  0xc(%ebp)
 287:	ff 75 f4             	pushl  -0xc(%ebp)
 28a:	e8 03 01 00 00       	call   392 <fstat>
 28f:	83 c4 10             	add    $0x10,%esp
 292:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 295:	83 ec 0c             	sub    $0xc,%esp
 298:	ff 75 f4             	pushl  -0xc(%ebp)
 29b:	e8 c2 00 00 00       	call   362 <close>
 2a0:	83 c4 10             	add    $0x10,%esp
  return r;
 2a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <atoi>:

int
atoi(const char *s)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2b5:	eb 25                	jmp    2dc <atoi+0x34>
    n = n*10 + *s++ - '0';
 2b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ba:	89 d0                	mov    %edx,%eax
 2bc:	c1 e0 02             	shl    $0x2,%eax
 2bf:	01 d0                	add    %edx,%eax
 2c1:	01 c0                	add    %eax,%eax
 2c3:	89 c1                	mov    %eax,%ecx
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	8d 50 01             	lea    0x1(%eax),%edx
 2cb:	89 55 08             	mov    %edx,0x8(%ebp)
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	0f be c0             	movsbl %al,%eax
 2d4:	01 c8                	add    %ecx,%eax
 2d6:	83 e8 30             	sub    $0x30,%eax
 2d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	3c 2f                	cmp    $0x2f,%al
 2e4:	7e 0a                	jle    2f0 <atoi+0x48>
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	3c 39                	cmp    $0x39,%al
 2ee:	7e c7                	jle    2b7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 301:	8b 45 0c             	mov    0xc(%ebp),%eax
 304:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 307:	eb 17                	jmp    320 <memmove+0x2b>
    *dst++ = *src++;
 309:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30c:	8d 50 01             	lea    0x1(%eax),%edx
 30f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 312:	8b 55 f8             	mov    -0x8(%ebp),%edx
 315:	8d 4a 01             	lea    0x1(%edx),%ecx
 318:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 31b:	0f b6 12             	movzbl (%edx),%edx
 31e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 320:	8b 45 10             	mov    0x10(%ebp),%eax
 323:	8d 50 ff             	lea    -0x1(%eax),%edx
 326:	89 55 10             	mov    %edx,0x10(%ebp)
 329:	85 c0                	test   %eax,%eax
 32b:	7f dc                	jg     309 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 332:	b8 01 00 00 00       	mov    $0x1,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exit>:
SYSCALL(exit)
 33a:	b8 02 00 00 00       	mov    $0x2,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <wait>:
SYSCALL(wait)
 342:	b8 03 00 00 00       	mov    $0x3,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <pipe>:
SYSCALL(pipe)
 34a:	b8 04 00 00 00       	mov    $0x4,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <read>:
SYSCALL(read)
 352:	b8 05 00 00 00       	mov    $0x5,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <write>:
SYSCALL(write)
 35a:	b8 10 00 00 00       	mov    $0x10,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <close>:
SYSCALL(close)
 362:	b8 15 00 00 00       	mov    $0x15,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <kill>:
SYSCALL(kill)
 36a:	b8 06 00 00 00       	mov    $0x6,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exec>:
SYSCALL(exec)
 372:	b8 07 00 00 00       	mov    $0x7,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <open>:
SYSCALL(open)
 37a:	b8 0f 00 00 00       	mov    $0xf,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <mknod>:
SYSCALL(mknod)
 382:	b8 11 00 00 00       	mov    $0x11,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <unlink>:
SYSCALL(unlink)
 38a:	b8 12 00 00 00       	mov    $0x12,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <fstat>:
SYSCALL(fstat)
 392:	b8 08 00 00 00       	mov    $0x8,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <link>:
SYSCALL(link)
 39a:	b8 13 00 00 00       	mov    $0x13,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <mkdir>:
SYSCALL(mkdir)
 3a2:	b8 14 00 00 00       	mov    $0x14,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <chdir>:
SYSCALL(chdir)
 3aa:	b8 09 00 00 00       	mov    $0x9,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <dup>:
SYSCALL(dup)
 3b2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <getpid>:
SYSCALL(getpid)
 3ba:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sbrk>:
SYSCALL(sbrk)
 3c2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <sleep>:
SYSCALL(sleep)
 3ca:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <uptime>:
SYSCALL(uptime)
 3d2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <getppid>:
SYSCALL(getppid)
 3da:	b8 16 00 00 00       	mov    $0x16,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <wait2>:
SYSCALL(wait2)
 3e2:	b8 18 00 00 00       	mov    $0x18,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <nice>:
SYSCALL(nice)
 3ea:	b8 17 00 00 00       	mov    $0x17,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 18             	sub    $0x18,%esp
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3fe:	83 ec 04             	sub    $0x4,%esp
 401:	6a 01                	push   $0x1
 403:	8d 45 f4             	lea    -0xc(%ebp),%eax
 406:	50                   	push   %eax
 407:	ff 75 08             	pushl  0x8(%ebp)
 40a:	e8 4b ff ff ff       	call   35a <write>
 40f:	83 c4 10             	add    $0x10,%esp
}
 412:	90                   	nop
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	53                   	push   %ebx
 419:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 41c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 423:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 427:	74 17                	je     440 <printint+0x2b>
 429:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 42d:	79 11                	jns    440 <printint+0x2b>
    neg = 1;
 42f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 436:	8b 45 0c             	mov    0xc(%ebp),%eax
 439:	f7 d8                	neg    %eax
 43b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43e:	eb 06                	jmp    446 <printint+0x31>
  } else {
    x = xx;
 440:	8b 45 0c             	mov    0xc(%ebp),%eax
 443:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 446:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 44d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 450:	8d 41 01             	lea    0x1(%ecx),%eax
 453:	89 45 f4             	mov    %eax,-0xc(%ebp)
 456:	8b 5d 10             	mov    0x10(%ebp),%ebx
 459:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45c:	ba 00 00 00 00       	mov    $0x0,%edx
 461:	f7 f3                	div    %ebx
 463:	89 d0                	mov    %edx,%eax
 465:	0f b6 80 fc 0a 00 00 	movzbl 0xafc(%eax),%eax
 46c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 470:	8b 5d 10             	mov    0x10(%ebp),%ebx
 473:	8b 45 ec             	mov    -0x14(%ebp),%eax
 476:	ba 00 00 00 00       	mov    $0x0,%edx
 47b:	f7 f3                	div    %ebx
 47d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 480:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 484:	75 c7                	jne    44d <printint+0x38>
  if(neg)
 486:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48a:	74 2d                	je     4b9 <printint+0xa4>
    buf[i++] = '-';
 48c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48f:	8d 50 01             	lea    0x1(%eax),%edx
 492:	89 55 f4             	mov    %edx,-0xc(%ebp)
 495:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 49a:	eb 1d                	jmp    4b9 <printint+0xa4>
    putc(fd, buf[i]);
 49c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	01 d0                	add    %edx,%eax
 4a4:	0f b6 00             	movzbl (%eax),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	83 ec 08             	sub    $0x8,%esp
 4ad:	50                   	push   %eax
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 3c ff ff ff       	call   3f2 <putc>
 4b6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c1:	79 d9                	jns    49c <printint+0x87>
    putc(fd, buf[i]);
}
 4c3:	90                   	nop
 4c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d9:	83 c0 04             	add    $0x4,%eax
 4dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e6:	e9 59 01 00 00       	jmp    644 <printf+0x17b>
    c = fmt[i] & 0xff;
 4eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f1:	01 d0                	add    %edx,%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	25 ff 00 00 00       	and    $0xff,%eax
 4fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 505:	75 2c                	jne    533 <printf+0x6a>
      if(c == '%'){
 507:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50b:	75 0c                	jne    519 <printf+0x50>
        state = '%';
 50d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 514:	e9 27 01 00 00       	jmp    640 <printf+0x177>
      } else {
        putc(fd, c);
 519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 c7 fe ff ff       	call   3f2 <putc>
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	e9 0d 01 00 00       	jmp    640 <printf+0x177>
      }
    } else if(state == '%'){
 533:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 537:	0f 85 03 01 00 00    	jne    640 <printf+0x177>
      if(c == 'd'){
 53d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 541:	75 1e                	jne    561 <printf+0x98>
        printint(fd, *ap, 10, 1);
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	6a 01                	push   $0x1
 54a:	6a 0a                	push   $0xa
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 c0 fe ff ff       	call   415 <printint>
 555:	83 c4 10             	add    $0x10,%esp
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55c:	e9 d8 00 00 00       	jmp    639 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 561:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 565:	74 06                	je     56d <printf+0xa4>
 567:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56b:	75 1e                	jne    58b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	6a 00                	push   $0x0
 574:	6a 10                	push   $0x10
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 96 fe ff ff       	call   415 <printint>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	e9 ae 00 00 00       	jmp    639 <printf+0x170>
      } else if(c == 's'){
 58b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58f:	75 43                	jne    5d4 <printf+0x10b>
        s = (char*)*ap;
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a1:	75 25                	jne    5c8 <printf+0xff>
          s = "(null)";
 5a3:	c7 45 f4 a2 08 00 00 	movl   $0x8a2,-0xc(%ebp)
        while(*s != 0){
 5aa:	eb 1c                	jmp    5c8 <printf+0xff>
          putc(fd, *s);
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	0f b6 00             	movzbl (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 31 fe ff ff       	call   3f2 <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
          s++;
 5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	84 c0                	test   %al,%al
 5d0:	75 da                	jne    5ac <printf+0xe3>
 5d2:	eb 65                	jmp    639 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d8:	75 1d                	jne    5f7 <printf+0x12e>
        putc(fd, *ap);
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 04 fe ff ff       	call   3f2 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f5:	eb 42                	jmp    639 <printf+0x170>
      } else if(c == '%'){
 5f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fb:	75 17                	jne    614 <printf+0x14b>
        putc(fd, c);
 5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	83 ec 08             	sub    $0x8,%esp
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 e3 fd ff ff       	call   3f2 <putc>
 60f:	83 c4 10             	add    $0x10,%esp
 612:	eb 25                	jmp    639 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 614:	83 ec 08             	sub    $0x8,%esp
 617:	6a 25                	push   $0x25
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 d1 fd ff ff       	call   3f2 <putc>
 621:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 627:	0f be c0             	movsbl %al,%eax
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	50                   	push   %eax
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 bc fd ff ff       	call   3f2 <putc>
 636:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 640:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 644:	8b 55 0c             	mov    0xc(%ebp),%edx
 647:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64a:	01 d0                	add    %edx,%eax
 64c:	0f b6 00             	movzbl (%eax),%eax
 64f:	84 c0                	test   %al,%al
 651:	0f 85 94 fe ff ff    	jne    4eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 657:	90                   	nop
 658:	c9                   	leave  
 659:	c3                   	ret    

0000065a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65a:	55                   	push   %ebp
 65b:	89 e5                	mov    %esp,%ebp
 65d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	83 e8 08             	sub    $0x8,%eax
 666:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 669:	a1 18 0b 00 00       	mov    0xb18,%eax
 66e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 671:	eb 24                	jmp    697 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	77 12                	ja     68f <free+0x35>
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	77 24                	ja     6a9 <free+0x4f>
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	77 1a                	ja     6a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	89 45 fc             	mov    %eax,-0x4(%ebp)
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	76 d4                	jbe    673 <free+0x19>
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	76 ca                	jbe    673 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	01 c2                	add    %eax,%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	39 c2                	cmp    %eax,%edx
 6c2:	75 24                	jne    6e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	8b 50 04             	mov    0x4(%eax),%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	01 c2                	add    %eax,%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	8b 10                	mov    (%eax),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	89 10                	mov    %edx,(%eax)
 6e6:	eb 0a                	jmp    6f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 707:	75 20                	jne    729 <free+0xcf>
    p->s.size += bp->s.size;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 50 04             	mov    0x4(%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	8b 40 04             	mov    0x4(%eax),%eax
 715:	01 c2                	add    %eax,%edx
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
 727:	eb 08                	jmp    731 <free+0xd7>
  } else
    p->s.ptr = bp;
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72f:	89 10                	mov    %edx,(%eax)
  freep = p;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 739:	90                   	nop
 73a:	c9                   	leave  
 73b:	c3                   	ret    

0000073c <morecore>:

static Header*
morecore(uint nu)
{
 73c:	55                   	push   %ebp
 73d:	89 e5                	mov    %esp,%ebp
 73f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 742:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 749:	77 07                	ja     752 <morecore+0x16>
    nu = 4096;
 74b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	c1 e0 03             	shl    $0x3,%eax
 758:	83 ec 0c             	sub    $0xc,%esp
 75b:	50                   	push   %eax
 75c:	e8 61 fc ff ff       	call   3c2 <sbrk>
 761:	83 c4 10             	add    $0x10,%esp
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 767:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 76b:	75 07                	jne    774 <morecore+0x38>
    return 0;
 76d:	b8 00 00 00 00       	mov    $0x0,%eax
 772:	eb 26                	jmp    79a <morecore+0x5e>
  hp = (Header*)p;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77d:	8b 55 08             	mov    0x8(%ebp),%edx
 780:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	83 c0 08             	add    $0x8,%eax
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	50                   	push   %eax
 78d:	e8 c8 fe ff ff       	call   65a <free>
 792:	83 c4 10             	add    $0x10,%esp
  return freep;
 795:	a1 18 0b 00 00       	mov    0xb18,%eax
}
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <malloc>:

void*
malloc(uint nbytes)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	83 c0 07             	add    $0x7,%eax
 7a8:	c1 e8 03             	shr    $0x3,%eax
 7ab:	83 c0 01             	add    $0x1,%eax
 7ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b1:	a1 18 0b 00 00       	mov    0xb18,%eax
 7b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bd:	75 23                	jne    7e2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7bf:	c7 45 f0 10 0b 00 00 	movl   $0xb10,-0x10(%ebp)
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	a3 18 0b 00 00       	mov    %eax,0xb18
 7ce:	a1 18 0b 00 00       	mov    0xb18,%eax
 7d3:	a3 10 0b 00 00       	mov    %eax,0xb10
    base.s.size = 0;
 7d8:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 7df:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	8b 40 04             	mov    0x4(%eax),%eax
 7f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f3:	72 4d                	jb     842 <malloc+0xa6>
      if(p->s.size == nunits)
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fe:	75 0c                	jne    80c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
 80a:	eb 26                	jmp    832 <malloc+0x96>
      else {
        p->s.size -= nunits;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	2b 45 ec             	sub    -0x14(%ebp),%eax
 815:	89 c2                	mov    %eax,%edx
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	c1 e0 03             	shl    $0x3,%eax
 826:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	a3 18 0b 00 00       	mov    %eax,0xb18
      return (void*)(p + 1);
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	83 c0 08             	add    $0x8,%eax
 840:	eb 3b                	jmp    87d <malloc+0xe1>
    }
    if(p == freep)
 842:	a1 18 0b 00 00       	mov    0xb18,%eax
 847:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84a:	75 1e                	jne    86a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 84c:	83 ec 0c             	sub    $0xc,%esp
 84f:	ff 75 ec             	pushl  -0x14(%ebp)
 852:	e8 e5 fe ff ff       	call   73c <morecore>
 857:	83 c4 10             	add    $0x10,%esp
 85a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 861:	75 07                	jne    86a <malloc+0xce>
        return 0;
 863:	b8 00 00 00 00       	mov    $0x0,%eax
 868:	eb 13                	jmp    87d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 878:	e9 6d ff ff ff       	jmp    7ea <malloc+0x4e>
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    
