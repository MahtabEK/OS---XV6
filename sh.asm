
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 d6 0e 00 00       	call   ee7 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 58 14 00 00 	mov    0x1458(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 2c 14 00 00       	push   $0x142c
      2c:	e8 7d 03 00 00       	call   3ae <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 9e 0e 00 00       	call   ee7 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 c0 0e 00 00       	call   f1f <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 33 14 00 00       	push   $0x1433
      71:	6a 02                	push   $0x2
      73:	e8 fe 0f 00 00       	call   1076 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 7a 0e 00 00       	call   f0f <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 79 0e 00 00       	call   f27 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 43 14 00 00       	push   $0x1443
      c4:	6a 02                	push   $0x2
      c6:	e8 ab 0f 00 00       	call   1076 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 14 0e 00 00       	call   ee7 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 d9 02 00 00       	call   3ce <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 df 0d 00 00       	call   eef <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 be 0d 00 00       	call   ef7 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 53 14 00 00       	push   $0x1453
     148:	e8 61 02 00 00       	call   3ae <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 79 02 00 00       	call   3ce <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 ac 0d 00 00       	call   f0f <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 ed 0d 00 00       	call   f5f <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 8e 0d 00 00       	call   f0f <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 7f 0d 00 00       	call   f0f <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 24 02 00 00       	call   3ce <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 57 0d 00 00       	call   f0f <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 98 0d 00 00       	call   f5f <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 39 0d 00 00       	call   f0f <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 2a 0d 00 00       	call   f0f <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 09 0d 00 00       	call   f0f <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 fa 0c 00 00       	call   f0f <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 d2 0c 00 00       	call   eef <wait>
    wait();
     21d:	e8 cd 0c 00 00       	call   eef <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 9f 01 00 00       	call   3ce <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 9c 0c 00 00       	call   ee7 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 70 14 00 00       	push   $0x1470
     259:	6a 02                	push   $0x2
     25b:	e8 16 0e 00 00       	call   1076 <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	pushl  0x8(%ebp)
     26f:	e8 d8 0a 00 00       	call   d4c <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	pushl  0xc(%ebp)
     27d:	ff 75 08             	pushl  0x8(%ebp)
     280:	e8 14 0b 00 00       	call   d99 <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <main>:

int
main(void)
{
     2a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a4:	83 e4 f0             	and    $0xfffffff0,%esp
     2a7:	ff 71 fc             	pushl  -0x4(%ecx)
     2aa:	55                   	push   %ebp
     2ab:	89 e5                	mov    %esp,%ebp
     2ad:	51                   	push   %ecx
     2ae:	83 ec 14             	sub    $0x14,%esp

  #ifdef RR
  printf(1,"RR\n");
     2b1:	83 ec 08             	sub    $0x8,%esp
     2b4:	68 73 14 00 00       	push   $0x1473
     2b9:	6a 01                	push   $0x1
     2bb:	e8 b6 0d 00 00       	call   1076 <printf>
     2c0:	83 c4 10             	add    $0x10,%esp
  #endif
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2c3:	eb 16                	jmp    2db <main+0x3b>
    if(fd >= 3){
     2c5:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2c9:	7e 10                	jle    2db <main+0x3b>
      close(fd);
     2cb:	83 ec 0c             	sub    $0xc,%esp
     2ce:	ff 75 f4             	pushl  -0xc(%ebp)
     2d1:	e8 39 0c 00 00       	call   f0f <close>
     2d6:	83 c4 10             	add    $0x10,%esp
      break;
     2d9:	eb 1b                	jmp    2f6 <main+0x56>
  #endif
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2db:	83 ec 08             	sub    $0x8,%esp
     2de:	6a 02                	push   $0x2
     2e0:	68 77 14 00 00       	push   $0x1477
     2e5:	e8 3d 0c 00 00       	call   f27 <open>
     2ea:	83 c4 10             	add    $0x10,%esp
     2ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2f4:	79 cf                	jns    2c5 <main+0x25>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2f6:	e9 94 00 00 00       	jmp    38f <main+0xef>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2fb:	0f b6 05 e0 19 00 00 	movzbl 0x19e0,%eax
     302:	3c 63                	cmp    $0x63,%al
     304:	75 5f                	jne    365 <main+0xc5>
     306:	0f b6 05 e1 19 00 00 	movzbl 0x19e1,%eax
     30d:	3c 64                	cmp    $0x64,%al
     30f:	75 54                	jne    365 <main+0xc5>
     311:	0f b6 05 e2 19 00 00 	movzbl 0x19e2,%eax
     318:	3c 20                	cmp    $0x20,%al
     31a:	75 49                	jne    365 <main+0xc5>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     31c:	83 ec 0c             	sub    $0xc,%esp
     31f:	68 e0 19 00 00       	push   $0x19e0
     324:	e8 fc 09 00 00       	call   d25 <strlen>
     329:	83 c4 10             	add    $0x10,%esp
     32c:	83 e8 01             	sub    $0x1,%eax
     32f:	c6 80 e0 19 00 00 00 	movb   $0x0,0x19e0(%eax)
      if(chdir(buf+3) < 0)
     336:	b8 e3 19 00 00       	mov    $0x19e3,%eax
     33b:	83 ec 0c             	sub    $0xc,%esp
     33e:	50                   	push   %eax
     33f:	e8 13 0c 00 00       	call   f57 <chdir>
     344:	83 c4 10             	add    $0x10,%esp
     347:	85 c0                	test   %eax,%eax
     349:	79 44                	jns    38f <main+0xef>
        printf(2, "cannot cd %s\n", buf+3);
     34b:	b8 e3 19 00 00       	mov    $0x19e3,%eax
     350:	83 ec 04             	sub    $0x4,%esp
     353:	50                   	push   %eax
     354:	68 7f 14 00 00       	push   $0x147f
     359:	6a 02                	push   $0x2
     35b:	e8 16 0d 00 00       	call   1076 <printf>
     360:	83 c4 10             	add    $0x10,%esp
      continue;
     363:	eb 2a                	jmp    38f <main+0xef>
    }
    if(fork1() == 0)
     365:	e8 64 00 00 00       	call   3ce <fork1>
     36a:	85 c0                	test   %eax,%eax
     36c:	75 1c                	jne    38a <main+0xea>
      runcmd(parsecmd(buf));
     36e:	83 ec 0c             	sub    $0xc,%esp
     371:	68 e0 19 00 00       	push   $0x19e0
     376:	e8 ab 03 00 00       	call   726 <parsecmd>
     37b:	83 c4 10             	add    $0x10,%esp
     37e:	83 ec 0c             	sub    $0xc,%esp
     381:	50                   	push   %eax
     382:	e8 79 fc ff ff       	call   0 <runcmd>
     387:	83 c4 10             	add    $0x10,%esp
    wait();
     38a:	e8 60 0b 00 00       	call   eef <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     38f:	83 ec 08             	sub    $0x8,%esp
     392:	6a 64                	push   $0x64
     394:	68 e0 19 00 00       	push   $0x19e0
     399:	e8 ad fe ff ff       	call   24b <getcmd>
     39e:	83 c4 10             	add    $0x10,%esp
     3a1:	85 c0                	test   %eax,%eax
     3a3:	0f 89 52 ff ff ff    	jns    2fb <main+0x5b>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     3a9:	e8 39 0b 00 00       	call   ee7 <exit>

000003ae <panic>:
}

void
panic(char *s)
{
     3ae:	55                   	push   %ebp
     3af:	89 e5                	mov    %esp,%ebp
     3b1:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3b4:	83 ec 04             	sub    $0x4,%esp
     3b7:	ff 75 08             	pushl  0x8(%ebp)
     3ba:	68 8d 14 00 00       	push   $0x148d
     3bf:	6a 02                	push   $0x2
     3c1:	e8 b0 0c 00 00       	call   1076 <printf>
     3c6:	83 c4 10             	add    $0x10,%esp
  exit();
     3c9:	e8 19 0b 00 00       	call   ee7 <exit>

000003ce <fork1>:
}

int
fork1(void)
{
     3ce:	55                   	push   %ebp
     3cf:	89 e5                	mov    %esp,%ebp
     3d1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  pid = fork();
     3d4:	e8 06 0b 00 00       	call   edf <fork>
     3d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3dc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3e0:	75 10                	jne    3f2 <fork1+0x24>
    panic("fork");
     3e2:	83 ec 0c             	sub    $0xc,%esp
     3e5:	68 91 14 00 00       	push   $0x1491
     3ea:	e8 bf ff ff ff       	call   3ae <panic>
     3ef:	83 c4 10             	add    $0x10,%esp
  return pid;
     3f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3f5:	c9                   	leave  
     3f6:	c3                   	ret    

000003f7 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3f7:	55                   	push   %ebp
     3f8:	89 e5                	mov    %esp,%ebp
     3fa:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3fd:	83 ec 0c             	sub    $0xc,%esp
     400:	6a 54                	push   $0x54
     402:	e8 42 0f 00 00       	call   1349 <malloc>
     407:	83 c4 10             	add    $0x10,%esp
     40a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     40d:	83 ec 04             	sub    $0x4,%esp
     410:	6a 54                	push   $0x54
     412:	6a 00                	push   $0x0
     414:	ff 75 f4             	pushl  -0xc(%ebp)
     417:	e8 30 09 00 00       	call   d4c <memset>
     41c:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     41f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     422:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     428:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     42b:	c9                   	leave  
     42c:	c3                   	ret    

0000042d <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     42d:	55                   	push   %ebp
     42e:	89 e5                	mov    %esp,%ebp
     430:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     433:	83 ec 0c             	sub    $0xc,%esp
     436:	6a 18                	push   $0x18
     438:	e8 0c 0f 00 00       	call   1349 <malloc>
     43d:	83 c4 10             	add    $0x10,%esp
     440:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     443:	83 ec 04             	sub    $0x4,%esp
     446:	6a 18                	push   $0x18
     448:	6a 00                	push   $0x0
     44a:	ff 75 f4             	pushl  -0xc(%ebp)
     44d:	e8 fa 08 00 00       	call   d4c <memset>
     452:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     455:	8b 45 f4             	mov    -0xc(%ebp),%eax
     458:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     461:	8b 55 08             	mov    0x8(%ebp),%edx
     464:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     467:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46a:	8b 55 0c             	mov    0xc(%ebp),%edx
     46d:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	8b 55 10             	mov    0x10(%ebp),%edx
     476:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     479:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47c:	8b 55 14             	mov    0x14(%ebp),%edx
     47f:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     482:	8b 45 f4             	mov    -0xc(%ebp),%eax
     485:	8b 55 18             	mov    0x18(%ebp),%edx
     488:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     48b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     48e:	c9                   	leave  
     48f:	c3                   	ret    

00000490 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     490:	55                   	push   %ebp
     491:	89 e5                	mov    %esp,%ebp
     493:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     496:	83 ec 0c             	sub    $0xc,%esp
     499:	6a 0c                	push   $0xc
     49b:	e8 a9 0e 00 00       	call   1349 <malloc>
     4a0:	83 c4 10             	add    $0x10,%esp
     4a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4a6:	83 ec 04             	sub    $0x4,%esp
     4a9:	6a 0c                	push   $0xc
     4ab:	6a 00                	push   $0x0
     4ad:	ff 75 f4             	pushl  -0xc(%ebp)
     4b0:	e8 97 08 00 00       	call   d4c <memset>
     4b5:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bb:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c4:	8b 55 08             	mov    0x8(%ebp),%edx
     4c7:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4cd:	8b 55 0c             	mov    0xc(%ebp),%edx
     4d0:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4d6:	c9                   	leave  
     4d7:	c3                   	ret    

000004d8 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4d8:	55                   	push   %ebp
     4d9:	89 e5                	mov    %esp,%ebp
     4db:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4de:	83 ec 0c             	sub    $0xc,%esp
     4e1:	6a 0c                	push   $0xc
     4e3:	e8 61 0e 00 00       	call   1349 <malloc>
     4e8:	83 c4 10             	add    $0x10,%esp
     4eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4ee:	83 ec 04             	sub    $0x4,%esp
     4f1:	6a 0c                	push   $0xc
     4f3:	6a 00                	push   $0x0
     4f5:	ff 75 f4             	pushl  -0xc(%ebp)
     4f8:	e8 4f 08 00 00       	call   d4c <memset>
     4fd:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     500:	8b 45 f4             	mov    -0xc(%ebp),%eax
     503:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     509:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50c:	8b 55 08             	mov    0x8(%ebp),%edx
     50f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	8b 55 0c             	mov    0xc(%ebp),%edx
     518:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     51e:	c9                   	leave  
     51f:	c3                   	ret    

00000520 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     520:	55                   	push   %ebp
     521:	89 e5                	mov    %esp,%ebp
     523:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     526:	83 ec 0c             	sub    $0xc,%esp
     529:	6a 08                	push   $0x8
     52b:	e8 19 0e 00 00       	call   1349 <malloc>
     530:	83 c4 10             	add    $0x10,%esp
     533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     536:	83 ec 04             	sub    $0x4,%esp
     539:	6a 08                	push   $0x8
     53b:	6a 00                	push   $0x0
     53d:	ff 75 f4             	pushl  -0xc(%ebp)
     540:	e8 07 08 00 00       	call   d4c <memset>
     545:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     548:	8b 45 f4             	mov    -0xc(%ebp),%eax
     54b:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     551:	8b 45 f4             	mov    -0xc(%ebp),%eax
     554:	8b 55 08             	mov    0x8(%ebp),%edx
     557:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     55a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     55d:	c9                   	leave  
     55e:	c3                   	ret    

0000055f <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     55f:	55                   	push   %ebp
     560:	89 e5                	mov    %esp,%ebp
     562:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;

  s = *ps;
     565:	8b 45 08             	mov    0x8(%ebp),%eax
     568:	8b 00                	mov    (%eax),%eax
     56a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     56d:	eb 04                	jmp    573 <gettoken+0x14>
    s++;
     56f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     573:	8b 45 f4             	mov    -0xc(%ebp),%eax
     576:	3b 45 0c             	cmp    0xc(%ebp),%eax
     579:	73 1e                	jae    599 <gettoken+0x3a>
     57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57e:	0f b6 00             	movzbl (%eax),%eax
     581:	0f be c0             	movsbl %al,%eax
     584:	83 ec 08             	sub    $0x8,%esp
     587:	50                   	push   %eax
     588:	68 ac 19 00 00       	push   $0x19ac
     58d:	e8 d4 07 00 00       	call   d66 <strchr>
     592:	83 c4 10             	add    $0x10,%esp
     595:	85 c0                	test   %eax,%eax
     597:	75 d6                	jne    56f <gettoken+0x10>
    s++;
  if(q)
     599:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     59d:	74 08                	je     5a7 <gettoken+0x48>
    *q = s;
     59f:	8b 45 10             	mov    0x10(%ebp),%eax
     5a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5a5:	89 10                	mov    %edx,(%eax)
  ret = *s;
     5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5aa:	0f b6 00             	movzbl (%eax),%eax
     5ad:	0f be c0             	movsbl %al,%eax
     5b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     5b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b6:	0f b6 00             	movzbl (%eax),%eax
     5b9:	0f be c0             	movsbl %al,%eax
     5bc:	83 f8 29             	cmp    $0x29,%eax
     5bf:	7f 14                	jg     5d5 <gettoken+0x76>
     5c1:	83 f8 28             	cmp    $0x28,%eax
     5c4:	7d 28                	jge    5ee <gettoken+0x8f>
     5c6:	85 c0                	test   %eax,%eax
     5c8:	0f 84 94 00 00 00    	je     662 <gettoken+0x103>
     5ce:	83 f8 26             	cmp    $0x26,%eax
     5d1:	74 1b                	je     5ee <gettoken+0x8f>
     5d3:	eb 3a                	jmp    60f <gettoken+0xb0>
     5d5:	83 f8 3e             	cmp    $0x3e,%eax
     5d8:	74 1a                	je     5f4 <gettoken+0x95>
     5da:	83 f8 3e             	cmp    $0x3e,%eax
     5dd:	7f 0a                	jg     5e9 <gettoken+0x8a>
     5df:	83 e8 3b             	sub    $0x3b,%eax
     5e2:	83 f8 01             	cmp    $0x1,%eax
     5e5:	77 28                	ja     60f <gettoken+0xb0>
     5e7:	eb 05                	jmp    5ee <gettoken+0x8f>
     5e9:	83 f8 7c             	cmp    $0x7c,%eax
     5ec:	75 21                	jne    60f <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5f2:	eb 75                	jmp    669 <gettoken+0x10a>
  case '>':
    s++;
     5f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fb:	0f b6 00             	movzbl (%eax),%eax
     5fe:	3c 3e                	cmp    $0x3e,%al
     600:	75 63                	jne    665 <gettoken+0x106>
      ret = '+';
     602:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     609:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     60d:	eb 56                	jmp    665 <gettoken+0x106>
  default:
    ret = 'a';
     60f:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     616:	eb 04                	jmp    61c <gettoken+0xbd>
      s++;
     618:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     622:	73 44                	jae    668 <gettoken+0x109>
     624:	8b 45 f4             	mov    -0xc(%ebp),%eax
     627:	0f b6 00             	movzbl (%eax),%eax
     62a:	0f be c0             	movsbl %al,%eax
     62d:	83 ec 08             	sub    $0x8,%esp
     630:	50                   	push   %eax
     631:	68 ac 19 00 00       	push   $0x19ac
     636:	e8 2b 07 00 00       	call   d66 <strchr>
     63b:	83 c4 10             	add    $0x10,%esp
     63e:	85 c0                	test   %eax,%eax
     640:	75 26                	jne    668 <gettoken+0x109>
     642:	8b 45 f4             	mov    -0xc(%ebp),%eax
     645:	0f b6 00             	movzbl (%eax),%eax
     648:	0f be c0             	movsbl %al,%eax
     64b:	83 ec 08             	sub    $0x8,%esp
     64e:	50                   	push   %eax
     64f:	68 b4 19 00 00       	push   $0x19b4
     654:	e8 0d 07 00 00       	call   d66 <strchr>
     659:	83 c4 10             	add    $0x10,%esp
     65c:	85 c0                	test   %eax,%eax
     65e:	74 b8                	je     618 <gettoken+0xb9>
      s++;
    break;
     660:	eb 06                	jmp    668 <gettoken+0x109>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     662:	90                   	nop
     663:	eb 04                	jmp    669 <gettoken+0x10a>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     665:	90                   	nop
     666:	eb 01                	jmp    669 <gettoken+0x10a>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     668:	90                   	nop
  }
  if(eq)
     669:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     66d:	74 0e                	je     67d <gettoken+0x11e>
    *eq = s;
     66f:	8b 45 14             	mov    0x14(%ebp),%eax
     672:	8b 55 f4             	mov    -0xc(%ebp),%edx
     675:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     677:	eb 04                	jmp    67d <gettoken+0x11e>
    s++;
     679:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     680:	3b 45 0c             	cmp    0xc(%ebp),%eax
     683:	73 1e                	jae    6a3 <gettoken+0x144>
     685:	8b 45 f4             	mov    -0xc(%ebp),%eax
     688:	0f b6 00             	movzbl (%eax),%eax
     68b:	0f be c0             	movsbl %al,%eax
     68e:	83 ec 08             	sub    $0x8,%esp
     691:	50                   	push   %eax
     692:	68 ac 19 00 00       	push   $0x19ac
     697:	e8 ca 06 00 00       	call   d66 <strchr>
     69c:	83 c4 10             	add    $0x10,%esp
     69f:	85 c0                	test   %eax,%eax
     6a1:	75 d6                	jne    679 <gettoken+0x11a>
    s++;
  *ps = s;
     6a3:	8b 45 08             	mov    0x8(%ebp),%eax
     6a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6a9:	89 10                	mov    %edx,(%eax)
  return ret;
     6ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     6ae:	c9                   	leave  
     6af:	c3                   	ret    

000006b0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     6b0:	55                   	push   %ebp
     6b1:	89 e5                	mov    %esp,%ebp
     6b3:	83 ec 18             	sub    $0x18,%esp
  char *s;

  s = *ps;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 00                	mov    (%eax),%eax
     6bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6be:	eb 04                	jmp    6c4 <peek+0x14>
    s++;
     6c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     6c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6ca:	73 1e                	jae    6ea <peek+0x3a>
     6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cf:	0f b6 00             	movzbl (%eax),%eax
     6d2:	0f be c0             	movsbl %al,%eax
     6d5:	83 ec 08             	sub    $0x8,%esp
     6d8:	50                   	push   %eax
     6d9:	68 ac 19 00 00       	push   $0x19ac
     6de:	e8 83 06 00 00       	call   d66 <strchr>
     6e3:	83 c4 10             	add    $0x10,%esp
     6e6:	85 c0                	test   %eax,%eax
     6e8:	75 d6                	jne    6c0 <peek+0x10>
    s++;
  *ps = s;
     6ea:	8b 45 08             	mov    0x8(%ebp),%eax
     6ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6f0:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f5:	0f b6 00             	movzbl (%eax),%eax
     6f8:	84 c0                	test   %al,%al
     6fa:	74 23                	je     71f <peek+0x6f>
     6fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ff:	0f b6 00             	movzbl (%eax),%eax
     702:	0f be c0             	movsbl %al,%eax
     705:	83 ec 08             	sub    $0x8,%esp
     708:	50                   	push   %eax
     709:	ff 75 10             	pushl  0x10(%ebp)
     70c:	e8 55 06 00 00       	call   d66 <strchr>
     711:	83 c4 10             	add    $0x10,%esp
     714:	85 c0                	test   %eax,%eax
     716:	74 07                	je     71f <peek+0x6f>
     718:	b8 01 00 00 00       	mov    $0x1,%eax
     71d:	eb 05                	jmp    724 <peek+0x74>
     71f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     724:	c9                   	leave  
     725:	c3                   	ret    

00000726 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     726:	55                   	push   %ebp
     727:	89 e5                	mov    %esp,%ebp
     729:	53                   	push   %ebx
     72a:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     72d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     730:	8b 45 08             	mov    0x8(%ebp),%eax
     733:	83 ec 0c             	sub    $0xc,%esp
     736:	50                   	push   %eax
     737:	e8 e9 05 00 00       	call   d25 <strlen>
     73c:	83 c4 10             	add    $0x10,%esp
     73f:	01 d8                	add    %ebx,%eax
     741:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     744:	83 ec 08             	sub    $0x8,%esp
     747:	ff 75 f4             	pushl  -0xc(%ebp)
     74a:	8d 45 08             	lea    0x8(%ebp),%eax
     74d:	50                   	push   %eax
     74e:	e8 61 00 00 00       	call   7b4 <parseline>
     753:	83 c4 10             	add    $0x10,%esp
     756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     759:	83 ec 04             	sub    $0x4,%esp
     75c:	68 96 14 00 00       	push   $0x1496
     761:	ff 75 f4             	pushl  -0xc(%ebp)
     764:	8d 45 08             	lea    0x8(%ebp),%eax
     767:	50                   	push   %eax
     768:	e8 43 ff ff ff       	call   6b0 <peek>
     76d:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     770:	8b 45 08             	mov    0x8(%ebp),%eax
     773:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     776:	74 26                	je     79e <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     778:	8b 45 08             	mov    0x8(%ebp),%eax
     77b:	83 ec 04             	sub    $0x4,%esp
     77e:	50                   	push   %eax
     77f:	68 97 14 00 00       	push   $0x1497
     784:	6a 02                	push   $0x2
     786:	e8 eb 08 00 00       	call   1076 <printf>
     78b:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     78e:	83 ec 0c             	sub    $0xc,%esp
     791:	68 a6 14 00 00       	push   $0x14a6
     796:	e8 13 fc ff ff       	call   3ae <panic>
     79b:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     79e:	83 ec 0c             	sub    $0xc,%esp
     7a1:	ff 75 f0             	pushl  -0x10(%ebp)
     7a4:	e8 eb 03 00 00       	call   b94 <nulterminate>
     7a9:	83 c4 10             	add    $0x10,%esp
  return cmd;
     7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     7af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7b2:	c9                   	leave  
     7b3:	c3                   	ret    

000007b4 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     7b4:	55                   	push   %ebp
     7b5:	89 e5                	mov    %esp,%ebp
     7b7:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     7ba:	83 ec 08             	sub    $0x8,%esp
     7bd:	ff 75 0c             	pushl  0xc(%ebp)
     7c0:	ff 75 08             	pushl  0x8(%ebp)
     7c3:	e8 99 00 00 00       	call   861 <parsepipe>
     7c8:	83 c4 10             	add    $0x10,%esp
     7cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7ce:	eb 23                	jmp    7f3 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7d0:	6a 00                	push   $0x0
     7d2:	6a 00                	push   $0x0
     7d4:	ff 75 0c             	pushl  0xc(%ebp)
     7d7:	ff 75 08             	pushl  0x8(%ebp)
     7da:	e8 80 fd ff ff       	call   55f <gettoken>
     7df:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7e2:	83 ec 0c             	sub    $0xc,%esp
     7e5:	ff 75 f4             	pushl  -0xc(%ebp)
     7e8:	e8 33 fd ff ff       	call   520 <backcmd>
     7ed:	83 c4 10             	add    $0x10,%esp
     7f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7f3:	83 ec 04             	sub    $0x4,%esp
     7f6:	68 ad 14 00 00       	push   $0x14ad
     7fb:	ff 75 0c             	pushl  0xc(%ebp)
     7fe:	ff 75 08             	pushl  0x8(%ebp)
     801:	e8 aa fe ff ff       	call   6b0 <peek>
     806:	83 c4 10             	add    $0x10,%esp
     809:	85 c0                	test   %eax,%eax
     80b:	75 c3                	jne    7d0 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     80d:	83 ec 04             	sub    $0x4,%esp
     810:	68 af 14 00 00       	push   $0x14af
     815:	ff 75 0c             	pushl  0xc(%ebp)
     818:	ff 75 08             	pushl  0x8(%ebp)
     81b:	e8 90 fe ff ff       	call   6b0 <peek>
     820:	83 c4 10             	add    $0x10,%esp
     823:	85 c0                	test   %eax,%eax
     825:	74 35                	je     85c <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     827:	6a 00                	push   $0x0
     829:	6a 00                	push   $0x0
     82b:	ff 75 0c             	pushl  0xc(%ebp)
     82e:	ff 75 08             	pushl  0x8(%ebp)
     831:	e8 29 fd ff ff       	call   55f <gettoken>
     836:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     839:	83 ec 08             	sub    $0x8,%esp
     83c:	ff 75 0c             	pushl  0xc(%ebp)
     83f:	ff 75 08             	pushl  0x8(%ebp)
     842:	e8 6d ff ff ff       	call   7b4 <parseline>
     847:	83 c4 10             	add    $0x10,%esp
     84a:	83 ec 08             	sub    $0x8,%esp
     84d:	50                   	push   %eax
     84e:	ff 75 f4             	pushl  -0xc(%ebp)
     851:	e8 82 fc ff ff       	call   4d8 <listcmd>
     856:	83 c4 10             	add    $0x10,%esp
     859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     85f:	c9                   	leave  
     860:	c3                   	ret    

00000861 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     861:	55                   	push   %ebp
     862:	89 e5                	mov    %esp,%ebp
     864:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     867:	83 ec 08             	sub    $0x8,%esp
     86a:	ff 75 0c             	pushl  0xc(%ebp)
     86d:	ff 75 08             	pushl  0x8(%ebp)
     870:	e8 ec 01 00 00       	call   a61 <parseexec>
     875:	83 c4 10             	add    $0x10,%esp
     878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     87b:	83 ec 04             	sub    $0x4,%esp
     87e:	68 b1 14 00 00       	push   $0x14b1
     883:	ff 75 0c             	pushl  0xc(%ebp)
     886:	ff 75 08             	pushl  0x8(%ebp)
     889:	e8 22 fe ff ff       	call   6b0 <peek>
     88e:	83 c4 10             	add    $0x10,%esp
     891:	85 c0                	test   %eax,%eax
     893:	74 35                	je     8ca <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     895:	6a 00                	push   $0x0
     897:	6a 00                	push   $0x0
     899:	ff 75 0c             	pushl  0xc(%ebp)
     89c:	ff 75 08             	pushl  0x8(%ebp)
     89f:	e8 bb fc ff ff       	call   55f <gettoken>
     8a4:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8a7:	83 ec 08             	sub    $0x8,%esp
     8aa:	ff 75 0c             	pushl  0xc(%ebp)
     8ad:	ff 75 08             	pushl  0x8(%ebp)
     8b0:	e8 ac ff ff ff       	call   861 <parsepipe>
     8b5:	83 c4 10             	add    $0x10,%esp
     8b8:	83 ec 08             	sub    $0x8,%esp
     8bb:	50                   	push   %eax
     8bc:	ff 75 f4             	pushl  -0xc(%ebp)
     8bf:	e8 cc fb ff ff       	call   490 <pipecmd>
     8c4:	83 c4 10             	add    $0x10,%esp
     8c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8cd:	c9                   	leave  
     8ce:	c3                   	ret    

000008cf <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8cf:	55                   	push   %ebp
     8d0:	89 e5                	mov    %esp,%ebp
     8d2:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8d5:	e9 b6 00 00 00       	jmp    990 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     8da:	6a 00                	push   $0x0
     8dc:	6a 00                	push   $0x0
     8de:	ff 75 10             	pushl  0x10(%ebp)
     8e1:	ff 75 0c             	pushl  0xc(%ebp)
     8e4:	e8 76 fc ff ff       	call   55f <gettoken>
     8e9:	83 c4 10             	add    $0x10,%esp
     8ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8f2:	50                   	push   %eax
     8f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8f6:	50                   	push   %eax
     8f7:	ff 75 10             	pushl  0x10(%ebp)
     8fa:	ff 75 0c             	pushl  0xc(%ebp)
     8fd:	e8 5d fc ff ff       	call   55f <gettoken>
     902:	83 c4 10             	add    $0x10,%esp
     905:	83 f8 61             	cmp    $0x61,%eax
     908:	74 10                	je     91a <parseredirs+0x4b>
      panic("missing file for redirection");
     90a:	83 ec 0c             	sub    $0xc,%esp
     90d:	68 b3 14 00 00       	push   $0x14b3
     912:	e8 97 fa ff ff       	call   3ae <panic>
     917:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     91d:	83 f8 3c             	cmp    $0x3c,%eax
     920:	74 0c                	je     92e <parseredirs+0x5f>
     922:	83 f8 3e             	cmp    $0x3e,%eax
     925:	74 26                	je     94d <parseredirs+0x7e>
     927:	83 f8 2b             	cmp    $0x2b,%eax
     92a:	74 43                	je     96f <parseredirs+0xa0>
     92c:	eb 62                	jmp    990 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     92e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     931:	8b 45 f0             	mov    -0x10(%ebp),%eax
     934:	83 ec 0c             	sub    $0xc,%esp
     937:	6a 00                	push   $0x0
     939:	6a 00                	push   $0x0
     93b:	52                   	push   %edx
     93c:	50                   	push   %eax
     93d:	ff 75 08             	pushl  0x8(%ebp)
     940:	e8 e8 fa ff ff       	call   42d <redircmd>
     945:	83 c4 20             	add    $0x20,%esp
     948:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     94b:	eb 43                	jmp    990 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     94d:	8b 55 ec             	mov    -0x14(%ebp),%edx
     950:	8b 45 f0             	mov    -0x10(%ebp),%eax
     953:	83 ec 0c             	sub    $0xc,%esp
     956:	6a 01                	push   $0x1
     958:	68 01 02 00 00       	push   $0x201
     95d:	52                   	push   %edx
     95e:	50                   	push   %eax
     95f:	ff 75 08             	pushl  0x8(%ebp)
     962:	e8 c6 fa ff ff       	call   42d <redircmd>
     967:	83 c4 20             	add    $0x20,%esp
     96a:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     96d:	eb 21                	jmp    990 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     96f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     972:	8b 45 f0             	mov    -0x10(%ebp),%eax
     975:	83 ec 0c             	sub    $0xc,%esp
     978:	6a 01                	push   $0x1
     97a:	68 01 02 00 00       	push   $0x201
     97f:	52                   	push   %edx
     980:	50                   	push   %eax
     981:	ff 75 08             	pushl  0x8(%ebp)
     984:	e8 a4 fa ff ff       	call   42d <redircmd>
     989:	83 c4 20             	add    $0x20,%esp
     98c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     98f:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     990:	83 ec 04             	sub    $0x4,%esp
     993:	68 d0 14 00 00       	push   $0x14d0
     998:	ff 75 10             	pushl  0x10(%ebp)
     99b:	ff 75 0c             	pushl  0xc(%ebp)
     99e:	e8 0d fd ff ff       	call   6b0 <peek>
     9a3:	83 c4 10             	add    $0x10,%esp
     9a6:	85 c0                	test   %eax,%eax
     9a8:	0f 85 2c ff ff ff    	jne    8da <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9b1:	c9                   	leave  
     9b2:	c3                   	ret    

000009b3 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9b3:	55                   	push   %ebp
     9b4:	89 e5                	mov    %esp,%ebp
     9b6:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9b9:	83 ec 04             	sub    $0x4,%esp
     9bc:	68 d3 14 00 00       	push   $0x14d3
     9c1:	ff 75 0c             	pushl  0xc(%ebp)
     9c4:	ff 75 08             	pushl  0x8(%ebp)
     9c7:	e8 e4 fc ff ff       	call   6b0 <peek>
     9cc:	83 c4 10             	add    $0x10,%esp
     9cf:	85 c0                	test   %eax,%eax
     9d1:	75 10                	jne    9e3 <parseblock+0x30>
    panic("parseblock");
     9d3:	83 ec 0c             	sub    $0xc,%esp
     9d6:	68 d5 14 00 00       	push   $0x14d5
     9db:	e8 ce f9 ff ff       	call   3ae <panic>
     9e0:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9e3:	6a 00                	push   $0x0
     9e5:	6a 00                	push   $0x0
     9e7:	ff 75 0c             	pushl  0xc(%ebp)
     9ea:	ff 75 08             	pushl  0x8(%ebp)
     9ed:	e8 6d fb ff ff       	call   55f <gettoken>
     9f2:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9f5:	83 ec 08             	sub    $0x8,%esp
     9f8:	ff 75 0c             	pushl  0xc(%ebp)
     9fb:	ff 75 08             	pushl  0x8(%ebp)
     9fe:	e8 b1 fd ff ff       	call   7b4 <parseline>
     a03:	83 c4 10             	add    $0x10,%esp
     a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a09:	83 ec 04             	sub    $0x4,%esp
     a0c:	68 e0 14 00 00       	push   $0x14e0
     a11:	ff 75 0c             	pushl  0xc(%ebp)
     a14:	ff 75 08             	pushl  0x8(%ebp)
     a17:	e8 94 fc ff ff       	call   6b0 <peek>
     a1c:	83 c4 10             	add    $0x10,%esp
     a1f:	85 c0                	test   %eax,%eax
     a21:	75 10                	jne    a33 <parseblock+0x80>
    panic("syntax - missing )");
     a23:	83 ec 0c             	sub    $0xc,%esp
     a26:	68 e2 14 00 00       	push   $0x14e2
     a2b:	e8 7e f9 ff ff       	call   3ae <panic>
     a30:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a33:	6a 00                	push   $0x0
     a35:	6a 00                	push   $0x0
     a37:	ff 75 0c             	pushl  0xc(%ebp)
     a3a:	ff 75 08             	pushl  0x8(%ebp)
     a3d:	e8 1d fb ff ff       	call   55f <gettoken>
     a42:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a45:	83 ec 04             	sub    $0x4,%esp
     a48:	ff 75 0c             	pushl  0xc(%ebp)
     a4b:	ff 75 08             	pushl  0x8(%ebp)
     a4e:	ff 75 f4             	pushl  -0xc(%ebp)
     a51:	e8 79 fe ff ff       	call   8cf <parseredirs>
     a56:	83 c4 10             	add    $0x10,%esp
     a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a5f:	c9                   	leave  
     a60:	c3                   	ret    

00000a61 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a61:	55                   	push   %ebp
     a62:	89 e5                	mov    %esp,%ebp
     a64:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     a67:	83 ec 04             	sub    $0x4,%esp
     a6a:	68 d3 14 00 00       	push   $0x14d3
     a6f:	ff 75 0c             	pushl  0xc(%ebp)
     a72:	ff 75 08             	pushl  0x8(%ebp)
     a75:	e8 36 fc ff ff       	call   6b0 <peek>
     a7a:	83 c4 10             	add    $0x10,%esp
     a7d:	85 c0                	test   %eax,%eax
     a7f:	74 16                	je     a97 <parseexec+0x36>
    return parseblock(ps, es);
     a81:	83 ec 08             	sub    $0x8,%esp
     a84:	ff 75 0c             	pushl  0xc(%ebp)
     a87:	ff 75 08             	pushl  0x8(%ebp)
     a8a:	e8 24 ff ff ff       	call   9b3 <parseblock>
     a8f:	83 c4 10             	add    $0x10,%esp
     a92:	e9 fb 00 00 00       	jmp    b92 <parseexec+0x131>

  ret = execcmd();
     a97:	e8 5b f9 ff ff       	call   3f7 <execcmd>
     a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     aac:	83 ec 04             	sub    $0x4,%esp
     aaf:	ff 75 0c             	pushl  0xc(%ebp)
     ab2:	ff 75 08             	pushl  0x8(%ebp)
     ab5:	ff 75 f0             	pushl  -0x10(%ebp)
     ab8:	e8 12 fe ff ff       	call   8cf <parseredirs>
     abd:	83 c4 10             	add    $0x10,%esp
     ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     ac3:	e9 87 00 00 00       	jmp    b4f <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     ac8:	8d 45 e0             	lea    -0x20(%ebp),%eax
     acb:	50                   	push   %eax
     acc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     acf:	50                   	push   %eax
     ad0:	ff 75 0c             	pushl  0xc(%ebp)
     ad3:	ff 75 08             	pushl  0x8(%ebp)
     ad6:	e8 84 fa ff ff       	call   55f <gettoken>
     adb:	83 c4 10             	add    $0x10,%esp
     ade:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ae1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ae5:	0f 84 84 00 00 00    	je     b6f <parseexec+0x10e>
      break;
    if(tok != 'a')
     aeb:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     aef:	74 10                	je     b01 <parseexec+0xa0>
      panic("syntax");
     af1:	83 ec 0c             	sub    $0xc,%esp
     af4:	68 a6 14 00 00       	push   $0x14a6
     af9:	e8 b0 f8 ff ff       	call   3ae <panic>
     afe:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     b01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b0a:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b14:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b17:	83 c1 08             	add    $0x8,%ecx
     b1a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b22:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b26:	7e 10                	jle    b38 <parseexec+0xd7>
      panic("too many args");
     b28:	83 ec 0c             	sub    $0xc,%esp
     b2b:	68 f5 14 00 00       	push   $0x14f5
     b30:	e8 79 f8 ff ff       	call   3ae <panic>
     b35:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b38:	83 ec 04             	sub    $0x4,%esp
     b3b:	ff 75 0c             	pushl  0xc(%ebp)
     b3e:	ff 75 08             	pushl  0x8(%ebp)
     b41:	ff 75 f0             	pushl  -0x10(%ebp)
     b44:	e8 86 fd ff ff       	call   8cf <parseredirs>
     b49:	83 c4 10             	add    $0x10,%esp
     b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b4f:	83 ec 04             	sub    $0x4,%esp
     b52:	68 03 15 00 00       	push   $0x1503
     b57:	ff 75 0c             	pushl  0xc(%ebp)
     b5a:	ff 75 08             	pushl  0x8(%ebp)
     b5d:	e8 4e fb ff ff       	call   6b0 <peek>
     b62:	83 c4 10             	add    $0x10,%esp
     b65:	85 c0                	test   %eax,%eax
     b67:	0f 84 5b ff ff ff    	je     ac8 <parseexec+0x67>
     b6d:	eb 01                	jmp    b70 <parseexec+0x10f>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     b6f:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b76:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b7d:	00 
  cmd->eargv[argc] = 0;
     b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b84:	83 c2 08             	add    $0x8,%edx
     b87:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b8e:	00 
  return ret;
     b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b92:	c9                   	leave  
     b93:	c3                   	ret    

00000b94 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b94:	55                   	push   %ebp
     b95:	89 e5                	mov    %esp,%ebp
     b97:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b9e:	75 0a                	jne    baa <nulterminate+0x16>
    return 0;
     ba0:	b8 00 00 00 00       	mov    $0x0,%eax
     ba5:	e9 e4 00 00 00       	jmp    c8e <nulterminate+0xfa>

  switch(cmd->type){
     baa:	8b 45 08             	mov    0x8(%ebp),%eax
     bad:	8b 00                	mov    (%eax),%eax
     baf:	83 f8 05             	cmp    $0x5,%eax
     bb2:	0f 87 d3 00 00 00    	ja     c8b <nulterminate+0xf7>
     bb8:	8b 04 85 08 15 00 00 	mov    0x1508(,%eax,4),%eax
     bbf:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     bc1:	8b 45 08             	mov    0x8(%ebp),%eax
     bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bce:	eb 14                	jmp    be4 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bd6:	83 c2 08             	add    $0x8,%edx
     bd9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bdd:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     be0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bea:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bee:	85 c0                	test   %eax,%eax
     bf0:	75 de                	jne    bd0 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     bf2:	e9 94 00 00 00       	jmp    c8b <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     bf7:	8b 45 08             	mov    0x8(%ebp),%eax
     bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c00:	8b 40 04             	mov    0x4(%eax),%eax
     c03:	83 ec 0c             	sub    $0xc,%esp
     c06:	50                   	push   %eax
     c07:	e8 88 ff ff ff       	call   b94 <nulterminate>
     c0c:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c12:	8b 40 0c             	mov    0xc(%eax),%eax
     c15:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c18:	eb 71                	jmp    c8b <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c1a:	8b 45 08             	mov    0x8(%ebp),%eax
     c1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c23:	8b 40 04             	mov    0x4(%eax),%eax
     c26:	83 ec 0c             	sub    $0xc,%esp
     c29:	50                   	push   %eax
     c2a:	e8 65 ff ff ff       	call   b94 <nulterminate>
     c2f:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c35:	8b 40 08             	mov    0x8(%eax),%eax
     c38:	83 ec 0c             	sub    $0xc,%esp
     c3b:	50                   	push   %eax
     c3c:	e8 53 ff ff ff       	call   b94 <nulterminate>
     c41:	83 c4 10             	add    $0x10,%esp
    break;
     c44:	eb 45                	jmp    c8b <nulterminate+0xf7>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c46:	8b 45 08             	mov    0x8(%ebp),%eax
     c49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c4f:	8b 40 04             	mov    0x4(%eax),%eax
     c52:	83 ec 0c             	sub    $0xc,%esp
     c55:	50                   	push   %eax
     c56:	e8 39 ff ff ff       	call   b94 <nulterminate>
     c5b:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c61:	8b 40 08             	mov    0x8(%eax),%eax
     c64:	83 ec 0c             	sub    $0xc,%esp
     c67:	50                   	push   %eax
     c68:	e8 27 ff ff ff       	call   b94 <nulterminate>
     c6d:	83 c4 10             	add    $0x10,%esp
    break;
     c70:	eb 19                	jmp    c8b <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c72:	8b 45 08             	mov    0x8(%ebp),%eax
     c75:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c7b:	8b 40 04             	mov    0x4(%eax),%eax
     c7e:	83 ec 0c             	sub    $0xc,%esp
     c81:	50                   	push   %eax
     c82:	e8 0d ff ff ff       	call   b94 <nulterminate>
     c87:	83 c4 10             	add    $0x10,%esp
    break;
     c8a:	90                   	nop
  }
  return cmd;
     c8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c8e:	c9                   	leave  
     c8f:	c3                   	ret    

00000c90 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c90:	55                   	push   %ebp
     c91:	89 e5                	mov    %esp,%ebp
     c93:	57                   	push   %edi
     c94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c95:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c98:	8b 55 10             	mov    0x10(%ebp),%edx
     c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
     c9e:	89 cb                	mov    %ecx,%ebx
     ca0:	89 df                	mov    %ebx,%edi
     ca2:	89 d1                	mov    %edx,%ecx
     ca4:	fc                   	cld    
     ca5:	f3 aa                	rep stos %al,%es:(%edi)
     ca7:	89 ca                	mov    %ecx,%edx
     ca9:	89 fb                	mov    %edi,%ebx
     cab:	89 5d 08             	mov    %ebx,0x8(%ebp)
     cae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     cb1:	90                   	nop
     cb2:	5b                   	pop    %ebx
     cb3:	5f                   	pop    %edi
     cb4:	5d                   	pop    %ebp
     cb5:	c3                   	ret    

00000cb6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     cb6:	55                   	push   %ebp
     cb7:	89 e5                	mov    %esp,%ebp
     cb9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     cbc:	8b 45 08             	mov    0x8(%ebp),%eax
     cbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     cc2:	90                   	nop
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	8d 50 01             	lea    0x1(%eax),%edx
     cc9:	89 55 08             	mov    %edx,0x8(%ebp)
     ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
     ccf:	8d 4a 01             	lea    0x1(%edx),%ecx
     cd2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     cd5:	0f b6 12             	movzbl (%edx),%edx
     cd8:	88 10                	mov    %dl,(%eax)
     cda:	0f b6 00             	movzbl (%eax),%eax
     cdd:	84 c0                	test   %al,%al
     cdf:	75 e2                	jne    cc3 <strcpy+0xd>
    ;
  return os;
     ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ce4:	c9                   	leave  
     ce5:	c3                   	ret    

00000ce6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ce6:	55                   	push   %ebp
     ce7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     ce9:	eb 08                	jmp    cf3 <strcmp+0xd>
    p++, q++;
     ceb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     cef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     cf3:	8b 45 08             	mov    0x8(%ebp),%eax
     cf6:	0f b6 00             	movzbl (%eax),%eax
     cf9:	84 c0                	test   %al,%al
     cfb:	74 10                	je     d0d <strcmp+0x27>
     cfd:	8b 45 08             	mov    0x8(%ebp),%eax
     d00:	0f b6 10             	movzbl (%eax),%edx
     d03:	8b 45 0c             	mov    0xc(%ebp),%eax
     d06:	0f b6 00             	movzbl (%eax),%eax
     d09:	38 c2                	cmp    %al,%dl
     d0b:	74 de                	je     ceb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d0d:	8b 45 08             	mov    0x8(%ebp),%eax
     d10:	0f b6 00             	movzbl (%eax),%eax
     d13:	0f b6 d0             	movzbl %al,%edx
     d16:	8b 45 0c             	mov    0xc(%ebp),%eax
     d19:	0f b6 00             	movzbl (%eax),%eax
     d1c:	0f b6 c0             	movzbl %al,%eax
     d1f:	29 c2                	sub    %eax,%edx
     d21:	89 d0                	mov    %edx,%eax
}
     d23:	5d                   	pop    %ebp
     d24:	c3                   	ret    

00000d25 <strlen>:

uint
strlen(char *s)
{
     d25:	55                   	push   %ebp
     d26:	89 e5                	mov    %esp,%ebp
     d28:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d32:	eb 04                	jmp    d38 <strlen+0x13>
     d34:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d38:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d3b:	8b 45 08             	mov    0x8(%ebp),%eax
     d3e:	01 d0                	add    %edx,%eax
     d40:	0f b6 00             	movzbl (%eax),%eax
     d43:	84 c0                	test   %al,%al
     d45:	75 ed                	jne    d34 <strlen+0xf>
    ;
  return n;
     d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d4a:	c9                   	leave  
     d4b:	c3                   	ret    

00000d4c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d4c:	55                   	push   %ebp
     d4d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d4f:	8b 45 10             	mov    0x10(%ebp),%eax
     d52:	50                   	push   %eax
     d53:	ff 75 0c             	pushl  0xc(%ebp)
     d56:	ff 75 08             	pushl  0x8(%ebp)
     d59:	e8 32 ff ff ff       	call   c90 <stosb>
     d5e:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d61:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d64:	c9                   	leave  
     d65:	c3                   	ret    

00000d66 <strchr>:

char*
strchr(const char *s, char c)
{
     d66:	55                   	push   %ebp
     d67:	89 e5                	mov    %esp,%ebp
     d69:	83 ec 04             	sub    $0x4,%esp
     d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d6f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d72:	eb 14                	jmp    d88 <strchr+0x22>
    if(*s == c)
     d74:	8b 45 08             	mov    0x8(%ebp),%eax
     d77:	0f b6 00             	movzbl (%eax),%eax
     d7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
     d7d:	75 05                	jne    d84 <strchr+0x1e>
      return (char*)s;
     d7f:	8b 45 08             	mov    0x8(%ebp),%eax
     d82:	eb 13                	jmp    d97 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d88:	8b 45 08             	mov    0x8(%ebp),%eax
     d8b:	0f b6 00             	movzbl (%eax),%eax
     d8e:	84 c0                	test   %al,%al
     d90:	75 e2                	jne    d74 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d97:	c9                   	leave  
     d98:	c3                   	ret    

00000d99 <gets>:

char*
gets(char *buf, int max)
{
     d99:	55                   	push   %ebp
     d9a:	89 e5                	mov    %esp,%ebp
     d9c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     da6:	eb 42                	jmp    dea <gets+0x51>
    cc = read(0, &c, 1);
     da8:	83 ec 04             	sub    $0x4,%esp
     dab:	6a 01                	push   $0x1
     dad:	8d 45 ef             	lea    -0x11(%ebp),%eax
     db0:	50                   	push   %eax
     db1:	6a 00                	push   $0x0
     db3:	e8 47 01 00 00       	call   eff <read>
     db8:	83 c4 10             	add    $0x10,%esp
     dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     dbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     dc2:	7e 33                	jle    df7 <gets+0x5e>
      break;
    buf[i++] = c;
     dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc7:	8d 50 01             	lea    0x1(%eax),%edx
     dca:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dcd:	89 c2                	mov    %eax,%edx
     dcf:	8b 45 08             	mov    0x8(%ebp),%eax
     dd2:	01 c2                	add    %eax,%edx
     dd4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dd8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     dda:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dde:	3c 0a                	cmp    $0xa,%al
     de0:	74 16                	je     df8 <gets+0x5f>
     de2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     de6:	3c 0d                	cmp    $0xd,%al
     de8:	74 0e                	je     df8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ded:	83 c0 01             	add    $0x1,%eax
     df0:	3b 45 0c             	cmp    0xc(%ebp),%eax
     df3:	7c b3                	jl     da8 <gets+0xf>
     df5:	eb 01                	jmp    df8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     df7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dfb:	8b 45 08             	mov    0x8(%ebp),%eax
     dfe:	01 d0                	add    %edx,%eax
     e00:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e03:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e06:	c9                   	leave  
     e07:	c3                   	ret    

00000e08 <stat>:

int
stat(char *n, struct stat *st)
{
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e0e:	83 ec 08             	sub    $0x8,%esp
     e11:	6a 00                	push   $0x0
     e13:	ff 75 08             	pushl  0x8(%ebp)
     e16:	e8 0c 01 00 00       	call   f27 <open>
     e1b:	83 c4 10             	add    $0x10,%esp
     e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e25:	79 07                	jns    e2e <stat+0x26>
    return -1;
     e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e2c:	eb 25                	jmp    e53 <stat+0x4b>
  r = fstat(fd, st);
     e2e:	83 ec 08             	sub    $0x8,%esp
     e31:	ff 75 0c             	pushl  0xc(%ebp)
     e34:	ff 75 f4             	pushl  -0xc(%ebp)
     e37:	e8 03 01 00 00       	call   f3f <fstat>
     e3c:	83 c4 10             	add    $0x10,%esp
     e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e42:	83 ec 0c             	sub    $0xc,%esp
     e45:	ff 75 f4             	pushl  -0xc(%ebp)
     e48:	e8 c2 00 00 00       	call   f0f <close>
     e4d:	83 c4 10             	add    $0x10,%esp
  return r;
     e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e53:	c9                   	leave  
     e54:	c3                   	ret    

00000e55 <atoi>:

int
atoi(const char *s)
{
     e55:	55                   	push   %ebp
     e56:	89 e5                	mov    %esp,%ebp
     e58:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e62:	eb 25                	jmp    e89 <atoi+0x34>
    n = n*10 + *s++ - '0';
     e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e67:	89 d0                	mov    %edx,%eax
     e69:	c1 e0 02             	shl    $0x2,%eax
     e6c:	01 d0                	add    %edx,%eax
     e6e:	01 c0                	add    %eax,%eax
     e70:	89 c1                	mov    %eax,%ecx
     e72:	8b 45 08             	mov    0x8(%ebp),%eax
     e75:	8d 50 01             	lea    0x1(%eax),%edx
     e78:	89 55 08             	mov    %edx,0x8(%ebp)
     e7b:	0f b6 00             	movzbl (%eax),%eax
     e7e:	0f be c0             	movsbl %al,%eax
     e81:	01 c8                	add    %ecx,%eax
     e83:	83 e8 30             	sub    $0x30,%eax
     e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e89:	8b 45 08             	mov    0x8(%ebp),%eax
     e8c:	0f b6 00             	movzbl (%eax),%eax
     e8f:	3c 2f                	cmp    $0x2f,%al
     e91:	7e 0a                	jle    e9d <atoi+0x48>
     e93:	8b 45 08             	mov    0x8(%ebp),%eax
     e96:	0f b6 00             	movzbl (%eax),%eax
     e99:	3c 39                	cmp    $0x39,%al
     e9b:	7e c7                	jle    e64 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ea0:	c9                   	leave  
     ea1:	c3                   	ret    

00000ea2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     ea2:	55                   	push   %ebp
     ea3:	89 e5                	mov    %esp,%ebp
     ea5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     ea8:	8b 45 08             	mov    0x8(%ebp),%eax
     eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     eae:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     eb4:	eb 17                	jmp    ecd <memmove+0x2b>
    *dst++ = *src++;
     eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb9:	8d 50 01             	lea    0x1(%eax),%edx
     ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
     ebf:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ec2:	8d 4a 01             	lea    0x1(%edx),%ecx
     ec5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     ec8:	0f b6 12             	movzbl (%edx),%edx
     ecb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     ecd:	8b 45 10             	mov    0x10(%ebp),%eax
     ed0:	8d 50 ff             	lea    -0x1(%eax),%edx
     ed3:	89 55 10             	mov    %edx,0x10(%ebp)
     ed6:	85 c0                	test   %eax,%eax
     ed8:	7f dc                	jg     eb6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     eda:	8b 45 08             	mov    0x8(%ebp),%eax
}
     edd:	c9                   	leave  
     ede:	c3                   	ret    

00000edf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     edf:	b8 01 00 00 00       	mov    $0x1,%eax
     ee4:	cd 40                	int    $0x40
     ee6:	c3                   	ret    

00000ee7 <exit>:
SYSCALL(exit)
     ee7:	b8 02 00 00 00       	mov    $0x2,%eax
     eec:	cd 40                	int    $0x40
     eee:	c3                   	ret    

00000eef <wait>:
SYSCALL(wait)
     eef:	b8 03 00 00 00       	mov    $0x3,%eax
     ef4:	cd 40                	int    $0x40
     ef6:	c3                   	ret    

00000ef7 <pipe>:
SYSCALL(pipe)
     ef7:	b8 04 00 00 00       	mov    $0x4,%eax
     efc:	cd 40                	int    $0x40
     efe:	c3                   	ret    

00000eff <read>:
SYSCALL(read)
     eff:	b8 05 00 00 00       	mov    $0x5,%eax
     f04:	cd 40                	int    $0x40
     f06:	c3                   	ret    

00000f07 <write>:
SYSCALL(write)
     f07:	b8 10 00 00 00       	mov    $0x10,%eax
     f0c:	cd 40                	int    $0x40
     f0e:	c3                   	ret    

00000f0f <close>:
SYSCALL(close)
     f0f:	b8 15 00 00 00       	mov    $0x15,%eax
     f14:	cd 40                	int    $0x40
     f16:	c3                   	ret    

00000f17 <kill>:
SYSCALL(kill)
     f17:	b8 06 00 00 00       	mov    $0x6,%eax
     f1c:	cd 40                	int    $0x40
     f1e:	c3                   	ret    

00000f1f <exec>:
SYSCALL(exec)
     f1f:	b8 07 00 00 00       	mov    $0x7,%eax
     f24:	cd 40                	int    $0x40
     f26:	c3                   	ret    

00000f27 <open>:
SYSCALL(open)
     f27:	b8 0f 00 00 00       	mov    $0xf,%eax
     f2c:	cd 40                	int    $0x40
     f2e:	c3                   	ret    

00000f2f <mknod>:
SYSCALL(mknod)
     f2f:	b8 11 00 00 00       	mov    $0x11,%eax
     f34:	cd 40                	int    $0x40
     f36:	c3                   	ret    

00000f37 <unlink>:
SYSCALL(unlink)
     f37:	b8 12 00 00 00       	mov    $0x12,%eax
     f3c:	cd 40                	int    $0x40
     f3e:	c3                   	ret    

00000f3f <fstat>:
SYSCALL(fstat)
     f3f:	b8 08 00 00 00       	mov    $0x8,%eax
     f44:	cd 40                	int    $0x40
     f46:	c3                   	ret    

00000f47 <link>:
SYSCALL(link)
     f47:	b8 13 00 00 00       	mov    $0x13,%eax
     f4c:	cd 40                	int    $0x40
     f4e:	c3                   	ret    

00000f4f <mkdir>:
SYSCALL(mkdir)
     f4f:	b8 14 00 00 00       	mov    $0x14,%eax
     f54:	cd 40                	int    $0x40
     f56:	c3                   	ret    

00000f57 <chdir>:
SYSCALL(chdir)
     f57:	b8 09 00 00 00       	mov    $0x9,%eax
     f5c:	cd 40                	int    $0x40
     f5e:	c3                   	ret    

00000f5f <dup>:
SYSCALL(dup)
     f5f:	b8 0a 00 00 00       	mov    $0xa,%eax
     f64:	cd 40                	int    $0x40
     f66:	c3                   	ret    

00000f67 <getpid>:
SYSCALL(getpid)
     f67:	b8 0b 00 00 00       	mov    $0xb,%eax
     f6c:	cd 40                	int    $0x40
     f6e:	c3                   	ret    

00000f6f <sbrk>:
SYSCALL(sbrk)
     f6f:	b8 0c 00 00 00       	mov    $0xc,%eax
     f74:	cd 40                	int    $0x40
     f76:	c3                   	ret    

00000f77 <sleep>:
SYSCALL(sleep)
     f77:	b8 0d 00 00 00       	mov    $0xd,%eax
     f7c:	cd 40                	int    $0x40
     f7e:	c3                   	ret    

00000f7f <uptime>:
SYSCALL(uptime)
     f7f:	b8 0e 00 00 00       	mov    $0xe,%eax
     f84:	cd 40                	int    $0x40
     f86:	c3                   	ret    

00000f87 <getppid>:
SYSCALL(getppid)
     f87:	b8 16 00 00 00       	mov    $0x16,%eax
     f8c:	cd 40                	int    $0x40
     f8e:	c3                   	ret    

00000f8f <wait2>:
SYSCALL(wait2)
     f8f:	b8 18 00 00 00       	mov    $0x18,%eax
     f94:	cd 40                	int    $0x40
     f96:	c3                   	ret    

00000f97 <nice>:
SYSCALL(nice)
     f97:	b8 17 00 00 00       	mov    $0x17,%eax
     f9c:	cd 40                	int    $0x40
     f9e:	c3                   	ret    

00000f9f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f9f:	55                   	push   %ebp
     fa0:	89 e5                	mov    %esp,%ebp
     fa2:	83 ec 18             	sub    $0x18,%esp
     fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa8:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     fab:	83 ec 04             	sub    $0x4,%esp
     fae:	6a 01                	push   $0x1
     fb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
     fb3:	50                   	push   %eax
     fb4:	ff 75 08             	pushl  0x8(%ebp)
     fb7:	e8 4b ff ff ff       	call   f07 <write>
     fbc:	83 c4 10             	add    $0x10,%esp
}
     fbf:	90                   	nop
     fc0:	c9                   	leave  
     fc1:	c3                   	ret    

00000fc2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     fc2:	55                   	push   %ebp
     fc3:	89 e5                	mov    %esp,%ebp
     fc5:	53                   	push   %ebx
     fc6:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     fc9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     fd0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     fd4:	74 17                	je     fed <printint+0x2b>
     fd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     fda:	79 11                	jns    fed <printint+0x2b>
    neg = 1;
     fdc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
     fe6:	f7 d8                	neg    %eax
     fe8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     feb:	eb 06                	jmp    ff3 <printint+0x31>
  } else {
    x = xx;
     fed:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ff3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ffa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ffd:	8d 41 01             	lea    0x1(%ecx),%eax
    1000:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1003:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1006:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1009:	ba 00 00 00 00       	mov    $0x0,%edx
    100e:	f7 f3                	div    %ebx
    1010:	89 d0                	mov    %edx,%eax
    1012:	0f b6 80 bc 19 00 00 	movzbl 0x19bc(%eax),%eax
    1019:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    101d:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1020:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1023:	ba 00 00 00 00       	mov    $0x0,%edx
    1028:	f7 f3                	div    %ebx
    102a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    102d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1031:	75 c7                	jne    ffa <printint+0x38>
  if(neg)
    1033:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1037:	74 2d                	je     1066 <printint+0xa4>
    buf[i++] = '-';
    1039:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103c:	8d 50 01             	lea    0x1(%eax),%edx
    103f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1042:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1047:	eb 1d                	jmp    1066 <printint+0xa4>
    putc(fd, buf[i]);
    1049:	8d 55 dc             	lea    -0x24(%ebp),%edx
    104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104f:	01 d0                	add    %edx,%eax
    1051:	0f b6 00             	movzbl (%eax),%eax
    1054:	0f be c0             	movsbl %al,%eax
    1057:	83 ec 08             	sub    $0x8,%esp
    105a:	50                   	push   %eax
    105b:	ff 75 08             	pushl  0x8(%ebp)
    105e:	e8 3c ff ff ff       	call   f9f <putc>
    1063:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1066:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    106a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106e:	79 d9                	jns    1049 <printint+0x87>
    putc(fd, buf[i]);
}
    1070:	90                   	nop
    1071:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1074:	c9                   	leave  
    1075:	c3                   	ret    

00001076 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1076:	55                   	push   %ebp
    1077:	89 e5                	mov    %esp,%ebp
    1079:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    107c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1083:	8d 45 0c             	lea    0xc(%ebp),%eax
    1086:	83 c0 04             	add    $0x4,%eax
    1089:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    108c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1093:	e9 59 01 00 00       	jmp    11f1 <printf+0x17b>
    c = fmt[i] & 0xff;
    1098:	8b 55 0c             	mov    0xc(%ebp),%edx
    109b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    109e:	01 d0                	add    %edx,%eax
    10a0:	0f b6 00             	movzbl (%eax),%eax
    10a3:	0f be c0             	movsbl %al,%eax
    10a6:	25 ff 00 00 00       	and    $0xff,%eax
    10ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    10ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10b2:	75 2c                	jne    10e0 <printf+0x6a>
      if(c == '%'){
    10b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10b8:	75 0c                	jne    10c6 <printf+0x50>
        state = '%';
    10ba:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    10c1:	e9 27 01 00 00       	jmp    11ed <printf+0x177>
      } else {
        putc(fd, c);
    10c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10c9:	0f be c0             	movsbl %al,%eax
    10cc:	83 ec 08             	sub    $0x8,%esp
    10cf:	50                   	push   %eax
    10d0:	ff 75 08             	pushl  0x8(%ebp)
    10d3:	e8 c7 fe ff ff       	call   f9f <putc>
    10d8:	83 c4 10             	add    $0x10,%esp
    10db:	e9 0d 01 00 00       	jmp    11ed <printf+0x177>
      }
    } else if(state == '%'){
    10e0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    10e4:	0f 85 03 01 00 00    	jne    11ed <printf+0x177>
      if(c == 'd'){
    10ea:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    10ee:	75 1e                	jne    110e <printf+0x98>
        printint(fd, *ap, 10, 1);
    10f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10f3:	8b 00                	mov    (%eax),%eax
    10f5:	6a 01                	push   $0x1
    10f7:	6a 0a                	push   $0xa
    10f9:	50                   	push   %eax
    10fa:	ff 75 08             	pushl  0x8(%ebp)
    10fd:	e8 c0 fe ff ff       	call   fc2 <printint>
    1102:	83 c4 10             	add    $0x10,%esp
        ap++;
    1105:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1109:	e9 d8 00 00 00       	jmp    11e6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    110e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1112:	74 06                	je     111a <printf+0xa4>
    1114:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1118:	75 1e                	jne    1138 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    111a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    111d:	8b 00                	mov    (%eax),%eax
    111f:	6a 00                	push   $0x0
    1121:	6a 10                	push   $0x10
    1123:	50                   	push   %eax
    1124:	ff 75 08             	pushl  0x8(%ebp)
    1127:	e8 96 fe ff ff       	call   fc2 <printint>
    112c:	83 c4 10             	add    $0x10,%esp
        ap++;
    112f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1133:	e9 ae 00 00 00       	jmp    11e6 <printf+0x170>
      } else if(c == 's'){
    1138:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    113c:	75 43                	jne    1181 <printf+0x10b>
        s = (char*)*ap;
    113e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1141:	8b 00                	mov    (%eax),%eax
    1143:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1146:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    114a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    114e:	75 25                	jne    1175 <printf+0xff>
          s = "(null)";
    1150:	c7 45 f4 20 15 00 00 	movl   $0x1520,-0xc(%ebp)
        while(*s != 0){
    1157:	eb 1c                	jmp    1175 <printf+0xff>
          putc(fd, *s);
    1159:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115c:	0f b6 00             	movzbl (%eax),%eax
    115f:	0f be c0             	movsbl %al,%eax
    1162:	83 ec 08             	sub    $0x8,%esp
    1165:	50                   	push   %eax
    1166:	ff 75 08             	pushl  0x8(%ebp)
    1169:	e8 31 fe ff ff       	call   f9f <putc>
    116e:	83 c4 10             	add    $0x10,%esp
          s++;
    1171:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1175:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1178:	0f b6 00             	movzbl (%eax),%eax
    117b:	84 c0                	test   %al,%al
    117d:	75 da                	jne    1159 <printf+0xe3>
    117f:	eb 65                	jmp    11e6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1181:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1185:	75 1d                	jne    11a4 <printf+0x12e>
        putc(fd, *ap);
    1187:	8b 45 e8             	mov    -0x18(%ebp),%eax
    118a:	8b 00                	mov    (%eax),%eax
    118c:	0f be c0             	movsbl %al,%eax
    118f:	83 ec 08             	sub    $0x8,%esp
    1192:	50                   	push   %eax
    1193:	ff 75 08             	pushl  0x8(%ebp)
    1196:	e8 04 fe ff ff       	call   f9f <putc>
    119b:	83 c4 10             	add    $0x10,%esp
        ap++;
    119e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11a2:	eb 42                	jmp    11e6 <printf+0x170>
      } else if(c == '%'){
    11a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11a8:	75 17                	jne    11c1 <printf+0x14b>
        putc(fd, c);
    11aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11ad:	0f be c0             	movsbl %al,%eax
    11b0:	83 ec 08             	sub    $0x8,%esp
    11b3:	50                   	push   %eax
    11b4:	ff 75 08             	pushl  0x8(%ebp)
    11b7:	e8 e3 fd ff ff       	call   f9f <putc>
    11bc:	83 c4 10             	add    $0x10,%esp
    11bf:	eb 25                	jmp    11e6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11c1:	83 ec 08             	sub    $0x8,%esp
    11c4:	6a 25                	push   $0x25
    11c6:	ff 75 08             	pushl  0x8(%ebp)
    11c9:	e8 d1 fd ff ff       	call   f9f <putc>
    11ce:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    11d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11d4:	0f be c0             	movsbl %al,%eax
    11d7:	83 ec 08             	sub    $0x8,%esp
    11da:	50                   	push   %eax
    11db:	ff 75 08             	pushl  0x8(%ebp)
    11de:	e8 bc fd ff ff       	call   f9f <putc>
    11e3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    11e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    11ed:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11f1:	8b 55 0c             	mov    0xc(%ebp),%edx
    11f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f7:	01 d0                	add    %edx,%eax
    11f9:	0f b6 00             	movzbl (%eax),%eax
    11fc:	84 c0                	test   %al,%al
    11fe:	0f 85 94 fe ff ff    	jne    1098 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1204:	90                   	nop
    1205:	c9                   	leave  
    1206:	c3                   	ret    

00001207 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1207:	55                   	push   %ebp
    1208:	89 e5                	mov    %esp,%ebp
    120a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    120d:	8b 45 08             	mov    0x8(%ebp),%eax
    1210:	83 e8 08             	sub    $0x8,%eax
    1213:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1216:	a1 4c 1a 00 00       	mov    0x1a4c,%eax
    121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    121e:	eb 24                	jmp    1244 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1220:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1223:	8b 00                	mov    (%eax),%eax
    1225:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1228:	77 12                	ja     123c <free+0x35>
    122a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    122d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1230:	77 24                	ja     1256 <free+0x4f>
    1232:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1235:	8b 00                	mov    (%eax),%eax
    1237:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    123a:	77 1a                	ja     1256 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    123f:	8b 00                	mov    (%eax),%eax
    1241:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1244:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1247:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    124a:	76 d4                	jbe    1220 <free+0x19>
    124c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124f:	8b 00                	mov    (%eax),%eax
    1251:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1254:	76 ca                	jbe    1220 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1259:	8b 40 04             	mov    0x4(%eax),%eax
    125c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1263:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1266:	01 c2                	add    %eax,%edx
    1268:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126b:	8b 00                	mov    (%eax),%eax
    126d:	39 c2                	cmp    %eax,%edx
    126f:	75 24                	jne    1295 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1271:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1274:	8b 50 04             	mov    0x4(%eax),%edx
    1277:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127a:	8b 00                	mov    (%eax),%eax
    127c:	8b 40 04             	mov    0x4(%eax),%eax
    127f:	01 c2                	add    %eax,%edx
    1281:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1284:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1287:	8b 45 fc             	mov    -0x4(%ebp),%eax
    128a:	8b 00                	mov    (%eax),%eax
    128c:	8b 10                	mov    (%eax),%edx
    128e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1291:	89 10                	mov    %edx,(%eax)
    1293:	eb 0a                	jmp    129f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1295:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1298:	8b 10                	mov    (%eax),%edx
    129a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    129d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a2:	8b 40 04             	mov    0x4(%eax),%eax
    12a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12af:	01 d0                	add    %edx,%eax
    12b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12b4:	75 20                	jne    12d6 <free+0xcf>
    p->s.size += bp->s.size;
    12b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b9:	8b 50 04             	mov    0x4(%eax),%edx
    12bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12bf:	8b 40 04             	mov    0x4(%eax),%eax
    12c2:	01 c2                	add    %eax,%edx
    12c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    12ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12cd:	8b 10                	mov    (%eax),%edx
    12cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d2:	89 10                	mov    %edx,(%eax)
    12d4:	eb 08                	jmp    12de <free+0xd7>
  } else
    p->s.ptr = bp;
    12d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12dc:	89 10                	mov    %edx,(%eax)
  freep = p;
    12de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e1:	a3 4c 1a 00 00       	mov    %eax,0x1a4c
}
    12e6:	90                   	nop
    12e7:	c9                   	leave  
    12e8:	c3                   	ret    

000012e9 <morecore>:

static Header*
morecore(uint nu)
{
    12e9:	55                   	push   %ebp
    12ea:	89 e5                	mov    %esp,%ebp
    12ec:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    12ef:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    12f6:	77 07                	ja     12ff <morecore+0x16>
    nu = 4096;
    12f8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    12ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1302:	c1 e0 03             	shl    $0x3,%eax
    1305:	83 ec 0c             	sub    $0xc,%esp
    1308:	50                   	push   %eax
    1309:	e8 61 fc ff ff       	call   f6f <sbrk>
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1314:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1318:	75 07                	jne    1321 <morecore+0x38>
    return 0;
    131a:	b8 00 00 00 00       	mov    $0x0,%eax
    131f:	eb 26                	jmp    1347 <morecore+0x5e>
  hp = (Header*)p;
    1321:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1324:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1327:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132a:	8b 55 08             	mov    0x8(%ebp),%edx
    132d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1330:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1333:	83 c0 08             	add    $0x8,%eax
    1336:	83 ec 0c             	sub    $0xc,%esp
    1339:	50                   	push   %eax
    133a:	e8 c8 fe ff ff       	call   1207 <free>
    133f:	83 c4 10             	add    $0x10,%esp
  return freep;
    1342:	a1 4c 1a 00 00       	mov    0x1a4c,%eax
}
    1347:	c9                   	leave  
    1348:	c3                   	ret    

00001349 <malloc>:

void*
malloc(uint nbytes)
{
    1349:	55                   	push   %ebp
    134a:	89 e5                	mov    %esp,%ebp
    134c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    134f:	8b 45 08             	mov    0x8(%ebp),%eax
    1352:	83 c0 07             	add    $0x7,%eax
    1355:	c1 e8 03             	shr    $0x3,%eax
    1358:	83 c0 01             	add    $0x1,%eax
    135b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    135e:	a1 4c 1a 00 00       	mov    0x1a4c,%eax
    1363:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    136a:	75 23                	jne    138f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    136c:	c7 45 f0 44 1a 00 00 	movl   $0x1a44,-0x10(%ebp)
    1373:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1376:	a3 4c 1a 00 00       	mov    %eax,0x1a4c
    137b:	a1 4c 1a 00 00       	mov    0x1a4c,%eax
    1380:	a3 44 1a 00 00       	mov    %eax,0x1a44
    base.s.size = 0;
    1385:	c7 05 48 1a 00 00 00 	movl   $0x0,0x1a48
    138c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1392:	8b 00                	mov    (%eax),%eax
    1394:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1397:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139a:	8b 40 04             	mov    0x4(%eax),%eax
    139d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    13a0:	72 4d                	jb     13ef <malloc+0xa6>
      if(p->s.size == nunits)
    13a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a5:	8b 40 04             	mov    0x4(%eax),%eax
    13a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    13ab:	75 0c                	jne    13b9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    13ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b0:	8b 10                	mov    (%eax),%edx
    13b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b5:	89 10                	mov    %edx,(%eax)
    13b7:	eb 26                	jmp    13df <malloc+0x96>
      else {
        p->s.size -= nunits;
    13b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13bc:	8b 40 04             	mov    0x4(%eax),%eax
    13bf:	2b 45 ec             	sub    -0x14(%ebp),%eax
    13c2:	89 c2                	mov    %eax,%edx
    13c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    13ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13cd:	8b 40 04             	mov    0x4(%eax),%eax
    13d0:	c1 e0 03             	shl    $0x3,%eax
    13d3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    13d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    13dc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    13df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13e2:	a3 4c 1a 00 00       	mov    %eax,0x1a4c
      return (void*)(p + 1);
    13e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13ea:	83 c0 08             	add    $0x8,%eax
    13ed:	eb 3b                	jmp    142a <malloc+0xe1>
    }
    if(p == freep)
    13ef:	a1 4c 1a 00 00       	mov    0x1a4c,%eax
    13f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    13f7:	75 1e                	jne    1417 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    13f9:	83 ec 0c             	sub    $0xc,%esp
    13fc:	ff 75 ec             	pushl  -0x14(%ebp)
    13ff:	e8 e5 fe ff ff       	call   12e9 <morecore>
    1404:	83 c4 10             	add    $0x10,%esp
    1407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    140a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    140e:	75 07                	jne    1417 <malloc+0xce>
        return 0;
    1410:	b8 00 00 00 00       	mov    $0x0,%eax
    1415:	eb 13                	jmp    142a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1417:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    141d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1420:	8b 00                	mov    (%eax),%eax
    1422:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1425:	e9 6d ff ff ff       	jmp    1397 <malloc+0x4e>
}
    142a:	c9                   	leave  
    142b:	c3                   	ret    
