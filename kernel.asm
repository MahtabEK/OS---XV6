
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 07 39 10 80       	mov    $0x80103907,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 5c 89 10 80       	push   $0x8010895c
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 3e 53 00 00       	call   8010538a <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 cc 1d 11 80 7c 	movl   $0x80111d7c,0x80111dcc
80100056:	1d 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d0 1d 11 80 7c 	movl   $0x80111d7c,0x80111dd0
80100060:	1d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 47                	jmp    801000b3 <binit+0x7f>
    b->next = bcache.head.next;
8010006c:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	83 c0 0c             	add    $0xc,%eax
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	68 63 89 10 80       	push   $0x80108963
80100090:	50                   	push   %eax
80100091:	e8 96 51 00 00       	call   8010522c <initsleeplock>
80100096:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
80100099:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
8010009e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a1:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ac:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b3:	b8 7c 1d 11 80       	mov    $0x80111d7c,%eax
801000b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bb:	72 af                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	90                   	nop
801000be:	c9                   	leave  
801000bf:	c3                   	ret    

801000c0 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c6:	83 ec 0c             	sub    $0xc,%esp
801000c9:	68 80 d6 10 80       	push   $0x8010d680
801000ce:	e8 d9 52 00 00       	call   801053ac <acquire>
801000d3:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000d6:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801000db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000de:	eb 58                	jmp    80100138 <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
801000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e3:	8b 40 04             	mov    0x4(%eax),%eax
801000e6:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e9:	75 44                	jne    8010012f <bget+0x6f>
801000eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ee:	8b 40 08             	mov    0x8(%eax),%eax
801000f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000f4:	75 39                	jne    8010012f <bget+0x6f>
      b->refcnt++;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 40 4c             	mov    0x4c(%eax),%eax
801000fc:	8d 50 01             	lea    0x1(%eax),%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 80 d6 10 80       	push   $0x8010d680
8010010d:	e8 06 53 00 00       	call   80105418 <release>
80100112:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	83 c0 0c             	add    $0xc,%eax
8010011b:	83 ec 0c             	sub    $0xc,%esp
8010011e:	50                   	push   %eax
8010011f:	e8 44 51 00 00       	call   80105268 <acquiresleep>
80100124:	83 c4 10             	add    $0x10,%esp
      return b;
80100127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012a:	e9 9d 00 00 00       	jmp    801001cc <bget+0x10c>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 54             	mov    0x54(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
8010013f:	75 9f                	jne    801000e0 <bget+0x20>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 cc 1d 11 80       	mov    0x80111dcc,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 6b                	jmp    801001b6 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100151:	85 c0                	test   %eax,%eax
80100153:	75 58                	jne    801001ad <bget+0xed>
80100155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100158:	8b 00                	mov    (%eax),%eax
8010015a:	83 e0 04             	and    $0x4,%eax
8010015d:	85 c0                	test   %eax,%eax
8010015f:	75 4c                	jne    801001ad <bget+0xed>
      b->dev = dev;
80100161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100164:	8b 55 08             	mov    0x8(%ebp),%edx
80100167:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100170:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100186:	83 ec 0c             	sub    $0xc,%esp
80100189:	68 80 d6 10 80       	push   $0x8010d680
8010018e:	e8 85 52 00 00       	call   80105418 <release>
80100193:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	83 c0 0c             	add    $0xc,%eax
8010019c:	83 ec 0c             	sub    $0xc,%esp
8010019f:	50                   	push   %eax
801001a0:	e8 c3 50 00 00       	call   80105268 <acquiresleep>
801001a5:	83 c4 10             	add    $0x10,%esp
      return b;
801001a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001ab:	eb 1f                	jmp    801001cc <bget+0x10c>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b0:	8b 40 50             	mov    0x50(%eax),%eax
801001b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001b6:	81 7d f4 7c 1d 11 80 	cmpl   $0x80111d7c,-0xc(%ebp)
801001bd:	75 8c                	jne    8010014b <bget+0x8b>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001bf:	83 ec 0c             	sub    $0xc,%esp
801001c2:	68 6a 89 10 80       	push   $0x8010896a
801001c7:	e8 d4 03 00 00       	call   801005a0 <panic>
}
801001cc:	c9                   	leave  
801001cd:	c3                   	ret    

801001ce <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001ce:	55                   	push   %ebp
801001cf:	89 e5                	mov    %esp,%ebp
801001d1:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001d4:	83 ec 08             	sub    $0x8,%esp
801001d7:	ff 75 0c             	pushl  0xc(%ebp)
801001da:	ff 75 08             	pushl  0x8(%ebp)
801001dd:	e8 de fe ff ff       	call   801000c0 <bget>
801001e2:	83 c4 10             	add    $0x10,%esp
801001e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001eb:	8b 00                	mov    (%eax),%eax
801001ed:	83 e0 02             	and    $0x2,%eax
801001f0:	85 c0                	test   %eax,%eax
801001f2:	75 0e                	jne    80100202 <bread+0x34>
    iderw(b);
801001f4:	83 ec 0c             	sub    $0xc,%esp
801001f7:	ff 75 f4             	pushl  -0xc(%ebp)
801001fa:	e8 61 27 00 00       	call   80102960 <iderw>
801001ff:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100205:	c9                   	leave  
80100206:	c3                   	ret    

80100207 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100207:	55                   	push   %ebp
80100208:	89 e5                	mov    %esp,%ebp
8010020a:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	83 c0 0c             	add    $0xc,%eax
80100213:	83 ec 0c             	sub    $0xc,%esp
80100216:	50                   	push   %eax
80100217:	e8 ff 50 00 00       	call   8010531b <holdingsleep>
8010021c:	83 c4 10             	add    $0x10,%esp
8010021f:	85 c0                	test   %eax,%eax
80100221:	75 0d                	jne    80100230 <bwrite+0x29>
    panic("bwrite");
80100223:	83 ec 0c             	sub    $0xc,%esp
80100226:	68 7b 89 10 80       	push   $0x8010897b
8010022b:	e8 70 03 00 00       	call   801005a0 <panic>
  b->flags |= B_DIRTY;
80100230:	8b 45 08             	mov    0x8(%ebp),%eax
80100233:	8b 00                	mov    (%eax),%eax
80100235:	83 c8 04             	or     $0x4,%eax
80100238:	89 c2                	mov    %eax,%edx
8010023a:	8b 45 08             	mov    0x8(%ebp),%eax
8010023d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	ff 75 08             	pushl  0x8(%ebp)
80100245:	e8 16 27 00 00       	call   80102960 <iderw>
8010024a:	83 c4 10             	add    $0x10,%esp
}
8010024d:	90                   	nop
8010024e:	c9                   	leave  
8010024f:	c3                   	ret    

80100250 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100256:	8b 45 08             	mov    0x8(%ebp),%eax
80100259:	83 c0 0c             	add    $0xc,%eax
8010025c:	83 ec 0c             	sub    $0xc,%esp
8010025f:	50                   	push   %eax
80100260:	e8 b6 50 00 00       	call   8010531b <holdingsleep>
80100265:	83 c4 10             	add    $0x10,%esp
80100268:	85 c0                	test   %eax,%eax
8010026a:	75 0d                	jne    80100279 <brelse+0x29>
    panic("brelse");
8010026c:	83 ec 0c             	sub    $0xc,%esp
8010026f:	68 82 89 10 80       	push   $0x80108982
80100274:	e8 27 03 00 00       	call   801005a0 <panic>

  releasesleep(&b->lock);
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	83 c0 0c             	add    $0xc,%eax
8010027f:	83 ec 0c             	sub    $0xc,%esp
80100282:	50                   	push   %eax
80100283:	e8 45 50 00 00       	call   801052cd <releasesleep>
80100288:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
8010028b:	83 ec 0c             	sub    $0xc,%esp
8010028e:	68 80 d6 10 80       	push   $0x8010d680
80100293:	e8 14 51 00 00       	call   801053ac <acquire>
80100298:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010029b:	8b 45 08             	mov    0x8(%ebp),%eax
8010029e:	8b 40 4c             	mov    0x4c(%eax),%eax
801002a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002aa:	8b 45 08             	mov    0x8(%ebp),%eax
801002ad:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 47                	jne    801002fb <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002b4:	8b 45 08             	mov    0x8(%ebp),%eax
801002b7:	8b 40 54             	mov    0x54(%eax),%eax
801002ba:	8b 55 08             	mov    0x8(%ebp),%edx
801002bd:	8b 52 50             	mov    0x50(%edx),%edx
801002c0:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002c3:	8b 45 08             	mov    0x8(%ebp),%eax
801002c6:	8b 40 50             	mov    0x50(%eax),%eax
801002c9:	8b 55 08             	mov    0x8(%ebp),%edx
801002cc:	8b 52 54             	mov    0x54(%edx),%edx
801002cf:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002d2:	8b 15 d0 1d 11 80    	mov    0x80111dd0,%edx
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	c7 40 50 7c 1d 11 80 	movl   $0x80111d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002e8:	a1 d0 1d 11 80       	mov    0x80111dd0,%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	a3 d0 1d 11 80       	mov    %eax,0x80111dd0
  }
  
  release(&bcache.lock);
801002fb:	83 ec 0c             	sub    $0xc,%esp
801002fe:	68 80 d6 10 80       	push   $0x8010d680
80100303:	e8 10 51 00 00       	call   80105418 <release>
80100308:	83 c4 10             	add    $0x10,%esp
}
8010030b:	90                   	nop
8010030c:	c9                   	leave  
8010030d:	c3                   	ret    

8010030e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010030e:	55                   	push   %ebp
8010030f:	89 e5                	mov    %esp,%ebp
80100311:	83 ec 14             	sub    $0x14,%esp
80100314:	8b 45 08             	mov    0x8(%ebp),%eax
80100317:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010031b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010031f:	89 c2                	mov    %eax,%edx
80100321:	ec                   	in     (%dx),%al
80100322:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80100325:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80100329:	c9                   	leave  
8010032a:	c3                   	ret    

8010032b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010032b:	55                   	push   %ebp
8010032c:	89 e5                	mov    %esp,%ebp
8010032e:	83 ec 08             	sub    $0x8,%esp
80100331:	8b 55 08             	mov    0x8(%ebp),%edx
80100334:	8b 45 0c             	mov    0xc(%ebp),%eax
80100337:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010033b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010033e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100342:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100346:	ee                   	out    %al,(%dx)
}
80100347:	90                   	nop
80100348:	c9                   	leave  
80100349:	c3                   	ret    

8010034a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010034a:	55                   	push   %ebp
8010034b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010034d:	fa                   	cli    
}
8010034e:	90                   	nop
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    

80100351 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100351:	55                   	push   %ebp
80100352:	89 e5                	mov    %esp,%ebp
80100354:	53                   	push   %ebx
80100355:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010035c:	74 1c                	je     8010037a <printint+0x29>
8010035e:	8b 45 08             	mov    0x8(%ebp),%eax
80100361:	c1 e8 1f             	shr    $0x1f,%eax
80100364:	0f b6 c0             	movzbl %al,%eax
80100367:	89 45 10             	mov    %eax,0x10(%ebp)
8010036a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036e:	74 0a                	je     8010037a <printint+0x29>
    x = -xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	f7 d8                	neg    %eax
80100375:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100378:	eb 06                	jmp    80100380 <printint+0x2f>
  else
    x = xx;
8010037a:	8b 45 08             	mov    0x8(%ebp),%eax
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100380:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100387:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010038a:	8d 41 01             	lea    0x1(%ecx),%eax
8010038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100393:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100396:	ba 00 00 00 00       	mov    $0x0,%edx
8010039b:	f7 f3                	div    %ebx
8010039d:	89 d0                	mov    %edx,%eax
8010039f:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
801003a6:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
801003aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003b0:	ba 00 00 00 00       	mov    $0x0,%edx
801003b5:	f7 f3                	div    %ebx
801003b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003be:	75 c7                	jne    80100387 <printint+0x36>

  if(sign)
801003c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003c4:	74 2a                	je     801003f0 <printint+0x9f>
    buf[i++] = '-';
801003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003c9:	8d 50 01             	lea    0x1(%eax),%edx
801003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003cf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003d4:	eb 1a                	jmp    801003f0 <printint+0x9f>
    consputc(buf[i]);
801003d6:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003dc:	01 d0                	add    %edx,%eax
801003de:	0f b6 00             	movzbl (%eax),%eax
801003e1:	0f be c0             	movsbl %al,%eax
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	50                   	push   %eax
801003e8:	e8 df 03 00 00       	call   801007cc <consputc>
801003ed:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003f0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003f8:	79 dc                	jns    801003d6 <printint+0x85>
    consputc(buf[i]);
}
801003fa:	90                   	nop
801003fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003fe:	c9                   	leave  
801003ff:	c3                   	ret    

80100400 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100406:	a1 14 c6 10 80       	mov    0x8010c614,%eax
8010040b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
8010040e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100412:	74 10                	je     80100424 <cprintf+0x24>
    acquire(&cons.lock);
80100414:	83 ec 0c             	sub    $0xc,%esp
80100417:	68 e0 c5 10 80       	push   $0x8010c5e0
8010041c:	e8 8b 4f 00 00       	call   801053ac <acquire>
80100421:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100424:	8b 45 08             	mov    0x8(%ebp),%eax
80100427:	85 c0                	test   %eax,%eax
80100429:	75 0d                	jne    80100438 <cprintf+0x38>
    panic("null fmt");
8010042b:	83 ec 0c             	sub    $0xc,%esp
8010042e:	68 89 89 10 80       	push   $0x80108989
80100433:	e8 68 01 00 00       	call   801005a0 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100438:	8d 45 0c             	lea    0xc(%ebp),%eax
8010043b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010043e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100445:	e9 1a 01 00 00       	jmp    80100564 <cprintf+0x164>
    if(c != '%'){
8010044a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010044e:	74 13                	je     80100463 <cprintf+0x63>
      consputc(c);
80100450:	83 ec 0c             	sub    $0xc,%esp
80100453:	ff 75 e4             	pushl  -0x1c(%ebp)
80100456:	e8 71 03 00 00       	call   801007cc <consputc>
8010045b:	83 c4 10             	add    $0x10,%esp
      continue;
8010045e:	e9 fd 00 00 00       	jmp    80100560 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100463:	8b 55 08             	mov    0x8(%ebp),%edx
80100466:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010046d:	01 d0                	add    %edx,%eax
8010046f:	0f b6 00             	movzbl (%eax),%eax
80100472:	0f be c0             	movsbl %al,%eax
80100475:	25 ff 00 00 00       	and    $0xff,%eax
8010047a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010047d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100481:	0f 84 ff 00 00 00    	je     80100586 <cprintf+0x186>
      break;
    switch(c){
80100487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010048a:	83 f8 70             	cmp    $0x70,%eax
8010048d:	74 47                	je     801004d6 <cprintf+0xd6>
8010048f:	83 f8 70             	cmp    $0x70,%eax
80100492:	7f 13                	jg     801004a7 <cprintf+0xa7>
80100494:	83 f8 25             	cmp    $0x25,%eax
80100497:	0f 84 98 00 00 00    	je     80100535 <cprintf+0x135>
8010049d:	83 f8 64             	cmp    $0x64,%eax
801004a0:	74 14                	je     801004b6 <cprintf+0xb6>
801004a2:	e9 9d 00 00 00       	jmp    80100544 <cprintf+0x144>
801004a7:	83 f8 73             	cmp    $0x73,%eax
801004aa:	74 47                	je     801004f3 <cprintf+0xf3>
801004ac:	83 f8 78             	cmp    $0x78,%eax
801004af:	74 25                	je     801004d6 <cprintf+0xd6>
801004b1:	e9 8e 00 00 00       	jmp    80100544 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
801004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b9:	8d 50 04             	lea    0x4(%eax),%edx
801004bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bf:	8b 00                	mov    (%eax),%eax
801004c1:	83 ec 04             	sub    $0x4,%esp
801004c4:	6a 01                	push   $0x1
801004c6:	6a 0a                	push   $0xa
801004c8:	50                   	push   %eax
801004c9:	e8 83 fe ff ff       	call   80100351 <printint>
801004ce:	83 c4 10             	add    $0x10,%esp
      break;
801004d1:	e9 8a 00 00 00       	jmp    80100560 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d9:	8d 50 04             	lea    0x4(%eax),%edx
801004dc:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004df:	8b 00                	mov    (%eax),%eax
801004e1:	83 ec 04             	sub    $0x4,%esp
801004e4:	6a 00                	push   $0x0
801004e6:	6a 10                	push   $0x10
801004e8:	50                   	push   %eax
801004e9:	e8 63 fe ff ff       	call   80100351 <printint>
801004ee:	83 c4 10             	add    $0x10,%esp
      break;
801004f1:	eb 6d                	jmp    80100560 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f6:	8d 50 04             	lea    0x4(%eax),%edx
801004f9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004fc:	8b 00                	mov    (%eax),%eax
801004fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100505:	75 22                	jne    80100529 <cprintf+0x129>
        s = "(null)";
80100507:	c7 45 ec 92 89 10 80 	movl   $0x80108992,-0x14(%ebp)
      for(; *s; s++)
8010050e:	eb 19                	jmp    80100529 <cprintf+0x129>
        consputc(*s);
80100510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100513:	0f b6 00             	movzbl (%eax),%eax
80100516:	0f be c0             	movsbl %al,%eax
80100519:	83 ec 0c             	sub    $0xc,%esp
8010051c:	50                   	push   %eax
8010051d:	e8 aa 02 00 00       	call   801007cc <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100525:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100529:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	84 c0                	test   %al,%al
80100531:	75 dd                	jne    80100510 <cprintf+0x110>
        consputc(*s);
      break;
80100533:	eb 2b                	jmp    80100560 <cprintf+0x160>
    case '%':
      consputc('%');
80100535:	83 ec 0c             	sub    $0xc,%esp
80100538:	6a 25                	push   $0x25
8010053a:	e8 8d 02 00 00       	call   801007cc <consputc>
8010053f:	83 c4 10             	add    $0x10,%esp
      break;
80100542:	eb 1c                	jmp    80100560 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100544:	83 ec 0c             	sub    $0xc,%esp
80100547:	6a 25                	push   $0x25
80100549:	e8 7e 02 00 00       	call   801007cc <consputc>
8010054e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100551:	83 ec 0c             	sub    $0xc,%esp
80100554:	ff 75 e4             	pushl  -0x1c(%ebp)
80100557:	e8 70 02 00 00       	call   801007cc <consputc>
8010055c:	83 c4 10             	add    $0x10,%esp
      break;
8010055f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100564:	8b 55 08             	mov    0x8(%ebp),%edx
80100567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010056a:	01 d0                	add    %edx,%eax
8010056c:	0f b6 00             	movzbl (%eax),%eax
8010056f:	0f be c0             	movsbl %al,%eax
80100572:	25 ff 00 00 00       	and    $0xff,%eax
80100577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010057a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010057e:	0f 85 c6 fe ff ff    	jne    8010044a <cprintf+0x4a>
80100584:	eb 01                	jmp    80100587 <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100586:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100587:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010058b:	74 10                	je     8010059d <cprintf+0x19d>
    release(&cons.lock);
8010058d:	83 ec 0c             	sub    $0xc,%esp
80100590:	68 e0 c5 10 80       	push   $0x8010c5e0
80100595:	e8 7e 4e 00 00       	call   80105418 <release>
8010059a:	83 c4 10             	add    $0x10,%esp
}
8010059d:	90                   	nop
8010059e:	c9                   	leave  
8010059f:	c3                   	ret    

801005a0 <panic>:

void
panic(char *s)
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005a6:	e8 9f fd ff ff       	call   8010034a <cli>
  cons.locking = 0;
801005ab:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
801005b2:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
801005b5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801005bb:	0f b6 00             	movzbl (%eax),%eax
801005be:	0f b6 c0             	movzbl %al,%eax
801005c1:	83 ec 08             	sub    $0x8,%esp
801005c4:	50                   	push   %eax
801005c5:	68 99 89 10 80       	push   $0x80108999
801005ca:	e8 31 fe ff ff       	call   80100400 <cprintf>
801005cf:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d2:	8b 45 08             	mov    0x8(%ebp),%eax
801005d5:	83 ec 0c             	sub    $0xc,%esp
801005d8:	50                   	push   %eax
801005d9:	e8 22 fe ff ff       	call   80100400 <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e1:	83 ec 0c             	sub    $0xc,%esp
801005e4:	68 b5 89 10 80       	push   $0x801089b5
801005e9:	e8 12 fe ff ff       	call   80100400 <cprintf>
801005ee:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f1:	83 ec 08             	sub    $0x8,%esp
801005f4:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f7:	50                   	push   %eax
801005f8:	8d 45 08             	lea    0x8(%ebp),%eax
801005fb:	50                   	push   %eax
801005fc:	e8 69 4e 00 00       	call   8010546a <getcallerpcs>
80100601:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100604:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060b:	eb 1c                	jmp    80100629 <panic+0x89>
    cprintf(" %p", pcs[i]);
8010060d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100610:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100614:	83 ec 08             	sub    $0x8,%esp
80100617:	50                   	push   %eax
80100618:	68 b7 89 10 80       	push   $0x801089b7
8010061d:	e8 de fd ff ff       	call   80100400 <cprintf>
80100622:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
80100625:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100629:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062d:	7e de                	jle    8010060d <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
8010062f:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80100636:	00 00 00 
  for(;;)
    ;
80100639:	eb fe                	jmp    80100639 <panic+0x99>

8010063b <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
8010063b:	55                   	push   %ebp
8010063c:	89 e5                	mov    %esp,%ebp
8010063e:	83 ec 18             	sub    $0x18,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100641:	6a 0e                	push   $0xe
80100643:	68 d4 03 00 00       	push   $0x3d4
80100648:	e8 de fc ff ff       	call   8010032b <outb>
8010064d:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100650:	68 d5 03 00 00       	push   $0x3d5
80100655:	e8 b4 fc ff ff       	call   8010030e <inb>
8010065a:	83 c4 04             	add    $0x4,%esp
8010065d:	0f b6 c0             	movzbl %al,%eax
80100660:	c1 e0 08             	shl    $0x8,%eax
80100663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100666:	6a 0f                	push   $0xf
80100668:	68 d4 03 00 00       	push   $0x3d4
8010066d:	e8 b9 fc ff ff       	call   8010032b <outb>
80100672:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100675:	68 d5 03 00 00       	push   $0x3d5
8010067a:	e8 8f fc ff ff       	call   8010030e <inb>
8010067f:	83 c4 04             	add    $0x4,%esp
80100682:	0f b6 c0             	movzbl %al,%eax
80100685:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100688:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010068c:	75 30                	jne    801006be <cgaputc+0x83>
    pos += 80 - pos%80;
8010068e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100691:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100696:	89 c8                	mov    %ecx,%eax
80100698:	f7 ea                	imul   %edx
8010069a:	c1 fa 05             	sar    $0x5,%edx
8010069d:	89 c8                	mov    %ecx,%eax
8010069f:	c1 f8 1f             	sar    $0x1f,%eax
801006a2:	29 c2                	sub    %eax,%edx
801006a4:	89 d0                	mov    %edx,%eax
801006a6:	c1 e0 02             	shl    $0x2,%eax
801006a9:	01 d0                	add    %edx,%eax
801006ab:	c1 e0 04             	shl    $0x4,%eax
801006ae:	29 c1                	sub    %eax,%ecx
801006b0:	89 ca                	mov    %ecx,%edx
801006b2:	b8 50 00 00 00       	mov    $0x50,%eax
801006b7:	29 d0                	sub    %edx,%eax
801006b9:	01 45 f4             	add    %eax,-0xc(%ebp)
801006bc:	eb 34                	jmp    801006f2 <cgaputc+0xb7>
  else if(c == BACKSPACE){
801006be:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006c5:	75 0c                	jne    801006d3 <cgaputc+0x98>
    if(pos > 0) --pos;
801006c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006cb:	7e 25                	jle    801006f2 <cgaputc+0xb7>
801006cd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006d1:	eb 1f                	jmp    801006f2 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006d3:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
801006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006dc:	8d 50 01             	lea    0x1(%eax),%edx
801006df:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006e2:	01 c0                	add    %eax,%eax
801006e4:	01 c8                	add    %ecx,%eax
801006e6:	8b 55 08             	mov    0x8(%ebp),%edx
801006e9:	0f b6 d2             	movzbl %dl,%edx
801006ec:	80 ce 07             	or     $0x7,%dh
801006ef:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006f6:	78 09                	js     80100701 <cgaputc+0xc6>
801006f8:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006ff:	7e 0d                	jle    8010070e <cgaputc+0xd3>
    panic("pos under/overflow");
80100701:	83 ec 0c             	sub    $0xc,%esp
80100704:	68 bb 89 10 80       	push   $0x801089bb
80100709:	e8 92 fe ff ff       	call   801005a0 <panic>

  if((pos/80) >= 24){  // Scroll up.
8010070e:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100715:	7e 4c                	jle    80100763 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100717:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010071c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100722:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100727:	83 ec 04             	sub    $0x4,%esp
8010072a:	68 60 0e 00 00       	push   $0xe60
8010072f:	52                   	push   %edx
80100730:	50                   	push   %eax
80100731:	e8 af 4f 00 00       	call   801056e5 <memmove>
80100736:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100739:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010073d:	b8 80 07 00 00       	mov    $0x780,%eax
80100742:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100745:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100748:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010074d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100750:	01 c9                	add    %ecx,%ecx
80100752:	01 c8                	add    %ecx,%eax
80100754:	83 ec 04             	sub    $0x4,%esp
80100757:	52                   	push   %edx
80100758:	6a 00                	push   $0x0
8010075a:	50                   	push   %eax
8010075b:	e8 c6 4e 00 00       	call   80105626 <memset>
80100760:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
80100763:	83 ec 08             	sub    $0x8,%esp
80100766:	6a 0e                	push   $0xe
80100768:	68 d4 03 00 00       	push   $0x3d4
8010076d:	e8 b9 fb ff ff       	call   8010032b <outb>
80100772:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100778:	c1 f8 08             	sar    $0x8,%eax
8010077b:	0f b6 c0             	movzbl %al,%eax
8010077e:	83 ec 08             	sub    $0x8,%esp
80100781:	50                   	push   %eax
80100782:	68 d5 03 00 00       	push   $0x3d5
80100787:	e8 9f fb ff ff       	call   8010032b <outb>
8010078c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010078f:	83 ec 08             	sub    $0x8,%esp
80100792:	6a 0f                	push   $0xf
80100794:	68 d4 03 00 00       	push   $0x3d4
80100799:	e8 8d fb ff ff       	call   8010032b <outb>
8010079e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
801007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007a4:	0f b6 c0             	movzbl %al,%eax
801007a7:	83 ec 08             	sub    $0x8,%esp
801007aa:	50                   	push   %eax
801007ab:	68 d5 03 00 00       	push   $0x3d5
801007b0:	e8 76 fb ff ff       	call   8010032b <outb>
801007b5:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
801007b8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801007bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801007c0:	01 d2                	add    %edx,%edx
801007c2:	01 d0                	add    %edx,%eax
801007c4:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007c9:	90                   	nop
801007ca:	c9                   	leave  
801007cb:	c3                   	ret    

801007cc <consputc>:

void
consputc(int c)
{
801007cc:	55                   	push   %ebp
801007cd:	89 e5                	mov    %esp,%ebp
801007cf:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007d2:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
801007d7:	85 c0                	test   %eax,%eax
801007d9:	74 07                	je     801007e2 <consputc+0x16>
    cli();
801007db:	e8 6a fb ff ff       	call   8010034a <cli>
    for(;;)
      ;
801007e0:	eb fe                	jmp    801007e0 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007e2:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007e9:	75 29                	jne    80100814 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007eb:	83 ec 0c             	sub    $0xc,%esp
801007ee:	6a 08                	push   $0x8
801007f0:	e8 34 68 00 00       	call   80107029 <uartputc>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	83 ec 0c             	sub    $0xc,%esp
801007fb:	6a 20                	push   $0x20
801007fd:	e8 27 68 00 00       	call   80107029 <uartputc>
80100802:	83 c4 10             	add    $0x10,%esp
80100805:	83 ec 0c             	sub    $0xc,%esp
80100808:	6a 08                	push   $0x8
8010080a:	e8 1a 68 00 00       	call   80107029 <uartputc>
8010080f:	83 c4 10             	add    $0x10,%esp
80100812:	eb 0e                	jmp    80100822 <consputc+0x56>
  } else
    uartputc(c);
80100814:	83 ec 0c             	sub    $0xc,%esp
80100817:	ff 75 08             	pushl  0x8(%ebp)
8010081a:	e8 0a 68 00 00       	call   80107029 <uartputc>
8010081f:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	ff 75 08             	pushl  0x8(%ebp)
80100828:	e8 0e fe ff ff       	call   8010063b <cgaputc>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	90                   	nop
80100831:	c9                   	leave  
80100832:	c3                   	ret    

80100833 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100833:	55                   	push   %ebp
80100834:	89 e5                	mov    %esp,%ebp
80100836:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100839:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 e0 c5 10 80       	push   $0x8010c5e0
80100848:	e8 5f 4b 00 00       	call   801053ac <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100850:	e9 44 01 00 00       	jmp    80100999 <consoleintr+0x166>
    switch(c){
80100855:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100858:	83 f8 10             	cmp    $0x10,%eax
8010085b:	74 1e                	je     8010087b <consoleintr+0x48>
8010085d:	83 f8 10             	cmp    $0x10,%eax
80100860:	7f 0a                	jg     8010086c <consoleintr+0x39>
80100862:	83 f8 08             	cmp    $0x8,%eax
80100865:	74 6b                	je     801008d2 <consoleintr+0x9f>
80100867:	e9 9b 00 00 00       	jmp    80100907 <consoleintr+0xd4>
8010086c:	83 f8 15             	cmp    $0x15,%eax
8010086f:	74 33                	je     801008a4 <consoleintr+0x71>
80100871:	83 f8 7f             	cmp    $0x7f,%eax
80100874:	74 5c                	je     801008d2 <consoleintr+0x9f>
80100876:	e9 8c 00 00 00       	jmp    80100907 <consoleintr+0xd4>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010087b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100882:	e9 12 01 00 00       	jmp    80100999 <consoleintr+0x166>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100887:	a1 68 20 11 80       	mov    0x80112068,%eax
8010088c:	83 e8 01             	sub    $0x1,%eax
8010088f:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
80100894:	83 ec 0c             	sub    $0xc,%esp
80100897:	68 00 01 00 00       	push   $0x100
8010089c:	e8 2b ff ff ff       	call   801007cc <consputc>
801008a1:	83 c4 10             	add    $0x10,%esp
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008a4:	8b 15 68 20 11 80    	mov    0x80112068,%edx
801008aa:	a1 64 20 11 80       	mov    0x80112064,%eax
801008af:	39 c2                	cmp    %eax,%edx
801008b1:	0f 84 e2 00 00 00    	je     80100999 <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b7:	a1 68 20 11 80       	mov    0x80112068,%eax
801008bc:	83 e8 01             	sub    $0x1,%eax
801008bf:	83 e0 7f             	and    $0x7f,%eax
801008c2:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c9:	3c 0a                	cmp    $0xa,%al
801008cb:	75 ba                	jne    80100887 <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008cd:	e9 c7 00 00 00       	jmp    80100999 <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008d2:	8b 15 68 20 11 80    	mov    0x80112068,%edx
801008d8:	a1 64 20 11 80       	mov    0x80112064,%eax
801008dd:	39 c2                	cmp    %eax,%edx
801008df:	0f 84 b4 00 00 00    	je     80100999 <consoleintr+0x166>
        input.e--;
801008e5:	a1 68 20 11 80       	mov    0x80112068,%eax
801008ea:	83 e8 01             	sub    $0x1,%eax
801008ed:	a3 68 20 11 80       	mov    %eax,0x80112068
        consputc(BACKSPACE);
801008f2:	83 ec 0c             	sub    $0xc,%esp
801008f5:	68 00 01 00 00       	push   $0x100
801008fa:	e8 cd fe ff ff       	call   801007cc <consputc>
801008ff:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100902:	e9 92 00 00 00       	jmp    80100999 <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100907:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010090b:	0f 84 87 00 00 00    	je     80100998 <consoleintr+0x165>
80100911:	8b 15 68 20 11 80    	mov    0x80112068,%edx
80100917:	a1 60 20 11 80       	mov    0x80112060,%eax
8010091c:	29 c2                	sub    %eax,%edx
8010091e:	89 d0                	mov    %edx,%eax
80100920:	83 f8 7f             	cmp    $0x7f,%eax
80100923:	77 73                	ja     80100998 <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
80100925:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80100929:	74 05                	je     80100930 <consoleintr+0xfd>
8010092b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010092e:	eb 05                	jmp    80100935 <consoleintr+0x102>
80100930:	b8 0a 00 00 00       	mov    $0xa,%eax
80100935:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100938:	a1 68 20 11 80       	mov    0x80112068,%eax
8010093d:	8d 50 01             	lea    0x1(%eax),%edx
80100940:	89 15 68 20 11 80    	mov    %edx,0x80112068
80100946:	83 e0 7f             	and    $0x7f,%eax
80100949:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010094c:	88 90 e0 1f 11 80    	mov    %dl,-0x7feee020(%eax)
        consputc(c);
80100952:	83 ec 0c             	sub    $0xc,%esp
80100955:	ff 75 f0             	pushl  -0x10(%ebp)
80100958:	e8 6f fe ff ff       	call   801007cc <consputc>
8010095d:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100960:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100964:	74 18                	je     8010097e <consoleintr+0x14b>
80100966:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010096a:	74 12                	je     8010097e <consoleintr+0x14b>
8010096c:	a1 68 20 11 80       	mov    0x80112068,%eax
80100971:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100977:	83 ea 80             	sub    $0xffffff80,%edx
8010097a:	39 d0                	cmp    %edx,%eax
8010097c:	75 1a                	jne    80100998 <consoleintr+0x165>
          input.w = input.e;
8010097e:	a1 68 20 11 80       	mov    0x80112068,%eax
80100983:	a3 64 20 11 80       	mov    %eax,0x80112064
          wakeup(&input.r);
80100988:	83 ec 0c             	sub    $0xc,%esp
8010098b:	68 60 20 11 80       	push   $0x80112060
80100990:	e8 74 46 00 00       	call   80105009 <wakeup>
80100995:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100998:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100999:	8b 45 08             	mov    0x8(%ebp),%eax
8010099c:	ff d0                	call   *%eax
8010099e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801009a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801009a5:	0f 89 aa fe ff ff    	jns    80100855 <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009ab:	83 ec 0c             	sub    $0xc,%esp
801009ae:	68 e0 c5 10 80       	push   $0x8010c5e0
801009b3:	e8 60 4a 00 00       	call   80105418 <release>
801009b8:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009bf:	74 05                	je     801009c6 <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
801009c1:	e8 01 47 00 00       	call   801050c7 <procdump>
  }
}
801009c6:	90                   	nop
801009c7:	c9                   	leave  
801009c8:	c3                   	ret    

801009c9 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009c9:	55                   	push   %ebp
801009ca:	89 e5                	mov    %esp,%ebp
801009cc:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009cf:	83 ec 0c             	sub    $0xc,%esp
801009d2:	ff 75 08             	pushl  0x8(%ebp)
801009d5:	e8 64 11 00 00       	call   80101b3e <iunlock>
801009da:	83 c4 10             	add    $0x10,%esp
  target = n;
801009dd:	8b 45 10             	mov    0x10(%ebp),%eax
801009e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 e0 c5 10 80       	push   $0x8010c5e0
801009eb:	e8 bc 49 00 00       	call   801053ac <acquire>
801009f0:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009f3:	e9 ac 00 00 00       	jmp    80100aa4 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009fe:	8b 40 34             	mov    0x34(%eax),%eax
80100a01:	85 c0                	test   %eax,%eax
80100a03:	74 28                	je     80100a2d <consoleread+0x64>
        release(&cons.lock);
80100a05:	83 ec 0c             	sub    $0xc,%esp
80100a08:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a0d:	e8 06 4a 00 00       	call   80105418 <release>
80100a12:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a15:	83 ec 0c             	sub    $0xc,%esp
80100a18:	ff 75 08             	pushl  0x8(%ebp)
80100a1b:	e8 01 10 00 00       	call   80101a21 <ilock>
80100a20:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a28:	e9 ab 00 00 00       	jmp    80100ad8 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a2d:	83 ec 08             	sub    $0x8,%esp
80100a30:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a35:	68 60 20 11 80       	push   $0x80112060
80100a3a:	e8 dc 44 00 00       	call   80104f1b <sleep>
80100a3f:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a42:	8b 15 60 20 11 80    	mov    0x80112060,%edx
80100a48:	a1 64 20 11 80       	mov    0x80112064,%eax
80100a4d:	39 c2                	cmp    %eax,%edx
80100a4f:	74 a7                	je     801009f8 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a51:	a1 60 20 11 80       	mov    0x80112060,%eax
80100a56:	8d 50 01             	lea    0x1(%eax),%edx
80100a59:	89 15 60 20 11 80    	mov    %edx,0x80112060
80100a5f:	83 e0 7f             	and    $0x7f,%eax
80100a62:	0f b6 80 e0 1f 11 80 	movzbl -0x7feee020(%eax),%eax
80100a69:	0f be c0             	movsbl %al,%eax
80100a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a6f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a73:	75 17                	jne    80100a8c <consoleread+0xc3>
      if(n < target){
80100a75:	8b 45 10             	mov    0x10(%ebp),%eax
80100a78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a7b:	73 2f                	jae    80100aac <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a7d:	a1 60 20 11 80       	mov    0x80112060,%eax
80100a82:	83 e8 01             	sub    $0x1,%eax
80100a85:	a3 60 20 11 80       	mov    %eax,0x80112060
      }
      break;
80100a8a:	eb 20                	jmp    80100aac <consoleread+0xe3>
    }
    *dst++ = c;
80100a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a8f:	8d 50 01             	lea    0x1(%eax),%edx
80100a92:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a98:	88 10                	mov    %dl,(%eax)
    --n;
80100a9a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a9e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100aa2:	74 0b                	je     80100aaf <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100aa4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100aa8:	7f 98                	jg     80100a42 <consoleread+0x79>
80100aaa:	eb 04                	jmp    80100ab0 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100aac:	90                   	nop
80100aad:	eb 01                	jmp    80100ab0 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100aaf:	90                   	nop
  }
  release(&cons.lock);
80100ab0:	83 ec 0c             	sub    $0xc,%esp
80100ab3:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ab8:	e8 5b 49 00 00       	call   80105418 <release>
80100abd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	ff 75 08             	pushl  0x8(%ebp)
80100ac6:	e8 56 0f 00 00       	call   80101a21 <ilock>
80100acb:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ace:	8b 45 10             	mov    0x10(%ebp),%eax
80100ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad4:	29 c2                	sub    %eax,%edx
80100ad6:	89 d0                	mov    %edx,%eax
}
80100ad8:	c9                   	leave  
80100ad9:	c3                   	ret    

80100ada <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100ada:	55                   	push   %ebp
80100adb:	89 e5                	mov    %esp,%ebp
80100add:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ae0:	83 ec 0c             	sub    $0xc,%esp
80100ae3:	ff 75 08             	pushl  0x8(%ebp)
80100ae6:	e8 53 10 00 00       	call   80101b3e <iunlock>
80100aeb:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aee:	83 ec 0c             	sub    $0xc,%esp
80100af1:	68 e0 c5 10 80       	push   $0x8010c5e0
80100af6:	e8 b1 48 00 00       	call   801053ac <acquire>
80100afb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b05:	eb 21                	jmp    80100b28 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b0d:	01 d0                	add    %edx,%eax
80100b0f:	0f b6 00             	movzbl (%eax),%eax
80100b12:	0f be c0             	movsbl %al,%eax
80100b15:	0f b6 c0             	movzbl %al,%eax
80100b18:	83 ec 0c             	sub    $0xc,%esp
80100b1b:	50                   	push   %eax
80100b1c:	e8 ab fc ff ff       	call   801007cc <consputc>
80100b21:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b2b:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b2e:	7c d7                	jl     80100b07 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b38:	e8 db 48 00 00       	call   80105418 <release>
80100b3d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b40:	83 ec 0c             	sub    $0xc,%esp
80100b43:	ff 75 08             	pushl  0x8(%ebp)
80100b46:	e8 d6 0e 00 00       	call   80101a21 <ilock>
80100b4b:	83 c4 10             	add    $0x10,%esp

  return n;
80100b4e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b51:	c9                   	leave  
80100b52:	c3                   	ret    

80100b53 <consoleinit>:

void
consoleinit(void)
{
80100b53:	55                   	push   %ebp
80100b54:	89 e5                	mov    %esp,%ebp
80100b56:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b59:	83 ec 08             	sub    $0x8,%esp
80100b5c:	68 ce 89 10 80       	push   $0x801089ce
80100b61:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b66:	e8 1f 48 00 00       	call   8010538a <initlock>
80100b6b:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b6e:	c7 05 2c 2a 11 80 da 	movl   $0x80100ada,0x80112a2c
80100b75:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b78:	c7 05 28 2a 11 80 c9 	movl   $0x801009c9,0x80112a28
80100b7f:	09 10 80 
  cons.locking = 1;
80100b82:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100b89:	00 00 00 

  picenable(IRQ_KBD);
80100b8c:	83 ec 0c             	sub    $0xc,%esp
80100b8f:	6a 01                	push   $0x1
80100b91:	e8 2d 33 00 00       	call   80103ec3 <picenable>
80100b96:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b99:	83 ec 08             	sub    $0x8,%esp
80100b9c:	6a 00                	push   $0x0
80100b9e:	6a 01                	push   $0x1
80100ba0:	e8 92 1f 00 00       	call   80102b37 <ioapicenable>
80100ba5:	83 c4 10             	add    $0x10,%esp
}
80100ba8:	90                   	nop
80100ba9:	c9                   	leave  
80100baa:	c3                   	ret    

80100bab <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bab:	55                   	push   %ebp
80100bac:	89 e5                	mov    %esp,%ebp
80100bae:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100bb4:	e8 26 2a 00 00       	call   801035df <begin_op>

  if((ip = namei(path)) == 0){
80100bb9:	83 ec 0c             	sub    $0xc,%esp
80100bbc:	ff 75 08             	pushl  0x8(%ebp)
80100bbf:	e8 83 19 00 00       	call   80102547 <namei>
80100bc4:	83 c4 10             	add    $0x10,%esp
80100bc7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bce:	75 0f                	jne    80100bdf <exec+0x34>
    end_op();
80100bd0:	e8 96 2a 00 00       	call   8010366b <end_op>
    return -1;
80100bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bda:	e9 05 04 00 00       	jmp    80100fe4 <exec+0x439>
  }
  ilock(ip);
80100bdf:	83 ec 0c             	sub    $0xc,%esp
80100be2:	ff 75 d8             	pushl  -0x28(%ebp)
80100be5:	e8 37 0e 00 00       	call   80101a21 <ilock>
80100bea:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bed:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bf4:	6a 34                	push   $0x34
80100bf6:	6a 00                	push   $0x0
80100bf8:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bfe:	50                   	push   %eax
80100bff:	ff 75 d8             	pushl  -0x28(%ebp)
80100c02:	e8 f0 12 00 00       	call   80101ef7 <readi>
80100c07:	83 c4 10             	add    $0x10,%esp
80100c0a:	83 f8 33             	cmp    $0x33,%eax
80100c0d:	0f 86 7a 03 00 00    	jbe    80100f8d <exec+0x3e2>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c13:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c19:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c1e:	0f 85 6c 03 00 00    	jne    80100f90 <exec+0x3e5>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c24:	e8 31 75 00 00       	call   8010815a <setupkvm>
80100c29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c30:	0f 84 5d 03 00 00    	je     80100f93 <exec+0x3e8>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c44:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c4d:	e9 de 00 00 00       	jmp    80100d30 <exec+0x185>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c55:	6a 20                	push   $0x20
80100c57:	50                   	push   %eax
80100c58:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c5e:	50                   	push   %eax
80100c5f:	ff 75 d8             	pushl  -0x28(%ebp)
80100c62:	e8 90 12 00 00       	call   80101ef7 <readi>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	83 f8 20             	cmp    $0x20,%eax
80100c6d:	0f 85 23 03 00 00    	jne    80100f96 <exec+0x3eb>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c73:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c79:	83 f8 01             	cmp    $0x1,%eax
80100c7c:	0f 85 a0 00 00 00    	jne    80100d22 <exec+0x177>
      continue;
    if(ph.memsz < ph.filesz)
80100c82:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c88:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c8e:	39 c2                	cmp    %eax,%edx
80100c90:	0f 82 03 03 00 00    	jb     80100f99 <exec+0x3ee>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c96:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c9c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100ca2:	01 c2                	add    %eax,%edx
80100ca4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100caa:	39 c2                	cmp    %eax,%edx
80100cac:	0f 82 ea 02 00 00    	jb     80100f9c <exec+0x3f1>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb2:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cb8:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100cbe:	01 d0                	add    %edx,%eax
80100cc0:	83 ec 04             	sub    $0x4,%esp
80100cc3:	50                   	push   %eax
80100cc4:	ff 75 e0             	pushl  -0x20(%ebp)
80100cc7:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cca:	e8 fc 77 00 00       	call   801084cb <allocuvm>
80100ccf:	83 c4 10             	add    $0x10,%esp
80100cd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cd9:	0f 84 c0 02 00 00    	je     80100f9f <exec+0x3f4>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100cdf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ce5:	25 ff 0f 00 00       	and    $0xfff,%eax
80100cea:	85 c0                	test   %eax,%eax
80100cec:	0f 85 b0 02 00 00    	jne    80100fa2 <exec+0x3f7>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cf2:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cf8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cfe:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d04:	83 ec 0c             	sub    $0xc,%esp
80100d07:	52                   	push   %edx
80100d08:	50                   	push   %eax
80100d09:	ff 75 d8             	pushl  -0x28(%ebp)
80100d0c:	51                   	push   %ecx
80100d0d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d10:	e8 e9 76 00 00       	call   801083fe <loaduvm>
80100d15:	83 c4 20             	add    $0x20,%esp
80100d18:	85 c0                	test   %eax,%eax
80100d1a:	0f 88 85 02 00 00    	js     80100fa5 <exec+0x3fa>
80100d20:	eb 01                	jmp    80100d23 <exec+0x178>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d22:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d23:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d2a:	83 c0 20             	add    $0x20,%eax
80100d2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d30:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d37:	0f b7 c0             	movzwl %ax,%eax
80100d3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d3d:	0f 8f 0f ff ff ff    	jg     80100c52 <exec+0xa7>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d43:	83 ec 0c             	sub    $0xc,%esp
80100d46:	ff 75 d8             	pushl  -0x28(%ebp)
80100d49:	e8 e9 0e 00 00       	call   80101c37 <iunlockput>
80100d4e:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d51:	e8 15 29 00 00       	call   8010366b <end_op>
  ip = 0;
80100d56:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d60:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d70:	05 00 20 00 00       	add    $0x2000,%eax
80100d75:	83 ec 04             	sub    $0x4,%esp
80100d78:	50                   	push   %eax
80100d79:	ff 75 e0             	pushl  -0x20(%ebp)
80100d7c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d7f:	e8 47 77 00 00       	call   801084cb <allocuvm>
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d8a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d8e:	0f 84 14 02 00 00    	je     80100fa8 <exec+0x3fd>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d97:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d9c:	83 ec 08             	sub    $0x8,%esp
80100d9f:	50                   	push   %eax
80100da0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da3:	e8 75 79 00 00       	call   8010871d <clearpteu>
80100da8:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dae:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100db8:	e9 96 00 00 00       	jmp    80100e53 <exec+0x2a8>
    if(argc >= MAXARG)
80100dbd:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dc1:	0f 87 e4 01 00 00    	ja     80100fab <exec+0x400>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dd4:	01 d0                	add    %edx,%eax
80100dd6:	8b 00                	mov    (%eax),%eax
80100dd8:	83 ec 0c             	sub    $0xc,%esp
80100ddb:	50                   	push   %eax
80100ddc:	e8 92 4a 00 00       	call   80105873 <strlen>
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	89 c2                	mov    %eax,%edx
80100de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de9:	29 d0                	sub    %edx,%eax
80100deb:	83 e8 01             	sub    $0x1,%eax
80100dee:	83 e0 fc             	and    $0xfffffffc,%eax
80100df1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e01:	01 d0                	add    %edx,%eax
80100e03:	8b 00                	mov    (%eax),%eax
80100e05:	83 ec 0c             	sub    $0xc,%esp
80100e08:	50                   	push   %eax
80100e09:	e8 65 4a 00 00       	call   80105873 <strlen>
80100e0e:	83 c4 10             	add    $0x10,%esp
80100e11:	83 c0 01             	add    $0x1,%eax
80100e14:	89 c1                	mov    %eax,%ecx
80100e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e20:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e23:	01 d0                	add    %edx,%eax
80100e25:	8b 00                	mov    (%eax),%eax
80100e27:	51                   	push   %ecx
80100e28:	50                   	push   %eax
80100e29:	ff 75 dc             	pushl  -0x24(%ebp)
80100e2c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e2f:	e8 88 7a 00 00       	call   801088bc <copyout>
80100e34:	83 c4 10             	add    $0x10,%esp
80100e37:	85 c0                	test   %eax,%eax
80100e39:	0f 88 6f 01 00 00    	js     80100fae <exec+0x403>
      goto bad;
    ustack[3+argc] = sp;
80100e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e42:	8d 50 03             	lea    0x3(%eax),%edx
80100e45:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e48:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e4f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e60:	01 d0                	add    %edx,%eax
80100e62:	8b 00                	mov    (%eax),%eax
80100e64:	85 c0                	test   %eax,%eax
80100e66:	0f 85 51 ff ff ff    	jne    80100dbd <exec+0x212>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6f:	83 c0 03             	add    $0x3,%eax
80100e72:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e79:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e7d:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e84:	ff ff ff 
  ustack[1] = argc;
80100e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e93:	83 c0 01             	add    $0x1,%eax
80100e96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea0:	29 d0                	sub    %edx,%eax
80100ea2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eab:	83 c0 04             	add    $0x4,%eax
80100eae:	c1 e0 02             	shl    $0x2,%eax
80100eb1:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb7:	83 c0 04             	add    $0x4,%eax
80100eba:	c1 e0 02             	shl    $0x2,%eax
80100ebd:	50                   	push   %eax
80100ebe:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ec4:	50                   	push   %eax
80100ec5:	ff 75 dc             	pushl  -0x24(%ebp)
80100ec8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ecb:	e8 ec 79 00 00       	call   801088bc <copyout>
80100ed0:	83 c4 10             	add    $0x10,%esp
80100ed3:	85 c0                	test   %eax,%eax
80100ed5:	0f 88 d6 00 00 00    	js     80100fb1 <exec+0x406>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100edb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ee7:	eb 17                	jmp    80100f00 <exec+0x355>
    if(*s == '/')
80100ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eec:	0f b6 00             	movzbl (%eax),%eax
80100eef:	3c 2f                	cmp    $0x2f,%al
80100ef1:	75 09                	jne    80100efc <exec+0x351>
      last = s+1;
80100ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ef6:	83 c0 01             	add    $0x1,%eax
80100ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100efc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f03:	0f b6 00             	movzbl (%eax),%eax
80100f06:	84 c0                	test   %al,%al
80100f08:	75 df                	jne    80100ee9 <exec+0x33e>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f10:	83 ec 04             	sub    $0x4,%esp
80100f13:	6a 10                	push   $0x10
80100f15:	ff 75 f0             	pushl  -0x10(%ebp)
80100f18:	50                   	push   %eax
80100f19:	e8 0b 49 00 00       	call   80105829 <safestrcpy>
80100f1e:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f27:	8b 40 18             	mov    0x18(%eax),%eax
80100f2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f36:	89 50 18             	mov    %edx,0x18(%eax)
  proc->sz = sz;
80100f39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f42:	89 50 14             	mov    %edx,0x14(%eax)
  proc->tf->eip = elf.entry;  // main
80100f45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f4b:	8b 40 28             	mov    0x28(%eax),%eax
80100f4e:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f54:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f5d:	8b 40 28             	mov    0x28(%eax),%eax
80100f60:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f63:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6c:	83 ec 0c             	sub    $0xc,%esp
80100f6f:	50                   	push   %eax
80100f70:	e8 a1 72 00 00       	call   80108216 <switchuvm>
80100f75:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 75 d0             	pushl  -0x30(%ebp)
80100f7e:	e8 01 77 00 00       	call   80108684 <freevm>
80100f83:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f86:	b8 00 00 00 00       	mov    $0x0,%eax
80100f8b:	eb 57                	jmp    80100fe4 <exec+0x439>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100f8d:	90                   	nop
80100f8e:	eb 22                	jmp    80100fb2 <exec+0x407>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100f90:	90                   	nop
80100f91:	eb 1f                	jmp    80100fb2 <exec+0x407>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100f93:	90                   	nop
80100f94:	eb 1c                	jmp    80100fb2 <exec+0x407>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100f96:	90                   	nop
80100f97:	eb 19                	jmp    80100fb2 <exec+0x407>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100f99:	90                   	nop
80100f9a:	eb 16                	jmp    80100fb2 <exec+0x407>
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
80100f9c:	90                   	nop
80100f9d:	eb 13                	jmp    80100fb2 <exec+0x407>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100f9f:	90                   	nop
80100fa0:	eb 10                	jmp    80100fb2 <exec+0x407>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
80100fa2:	90                   	nop
80100fa3:	eb 0d                	jmp    80100fb2 <exec+0x407>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fa5:	90                   	nop
80100fa6:	eb 0a                	jmp    80100fb2 <exec+0x407>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fa8:	90                   	nop
80100fa9:	eb 07                	jmp    80100fb2 <exec+0x407>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fab:	90                   	nop
80100fac:	eb 04                	jmp    80100fb2 <exec+0x407>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fae:	90                   	nop
80100faf:	eb 01                	jmp    80100fb2 <exec+0x407>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fb1:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fb2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fb6:	74 0e                	je     80100fc6 <exec+0x41b>
    freevm(pgdir);
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fbe:	e8 c1 76 00 00       	call   80108684 <freevm>
80100fc3:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fc6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fca:	74 13                	je     80100fdf <exec+0x434>
    iunlockput(ip);
80100fcc:	83 ec 0c             	sub    $0xc,%esp
80100fcf:	ff 75 d8             	pushl  -0x28(%ebp)
80100fd2:	e8 60 0c 00 00       	call   80101c37 <iunlockput>
80100fd7:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fda:	e8 8c 26 00 00       	call   8010366b <end_op>
  }
  return -1;
80100fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe4:	c9                   	leave  
80100fe5:	c3                   	ret    

80100fe6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fe6:	55                   	push   %ebp
80100fe7:	89 e5                	mov    %esp,%ebp
80100fe9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fec:	83 ec 08             	sub    $0x8,%esp
80100fef:	68 d6 89 10 80       	push   $0x801089d6
80100ff4:	68 80 20 11 80       	push   $0x80112080
80100ff9:	e8 8c 43 00 00       	call   8010538a <initlock>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	90                   	nop
80101002:	c9                   	leave  
80101003:	c3                   	ret    

80101004 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	68 80 20 11 80       	push   $0x80112080
80101012:	e8 95 43 00 00       	call   801053ac <acquire>
80101017:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010101a:	c7 45 f4 b4 20 11 80 	movl   $0x801120b4,-0xc(%ebp)
80101021:	eb 2d                	jmp    80101050 <filealloc+0x4c>
    if(f->ref == 0){
80101023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101026:	8b 40 04             	mov    0x4(%eax),%eax
80101029:	85 c0                	test   %eax,%eax
8010102b:	75 1f                	jne    8010104c <filealloc+0x48>
      f->ref = 1;
8010102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101030:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 80 20 11 80       	push   $0x80112080
8010103f:	e8 d4 43 00 00       	call   80105418 <release>
80101044:	83 c4 10             	add    $0x10,%esp
      return f;
80101047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010104a:	eb 23                	jmp    8010106f <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101050:	b8 14 2a 11 80       	mov    $0x80112a14,%eax
80101055:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101058:	72 c9                	jb     80101023 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	68 80 20 11 80       	push   $0x80112080
80101062:	e8 b1 43 00 00       	call   80105418 <release>
80101067:	83 c4 10             	add    $0x10,%esp
  return 0;
8010106a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010106f:	c9                   	leave  
80101070:	c3                   	ret    

80101071 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101071:	55                   	push   %ebp
80101072:	89 e5                	mov    %esp,%ebp
80101074:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 80 20 11 80       	push   $0x80112080
8010107f:	e8 28 43 00 00       	call   801053ac <acquire>
80101084:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101087:	8b 45 08             	mov    0x8(%ebp),%eax
8010108a:	8b 40 04             	mov    0x4(%eax),%eax
8010108d:	85 c0                	test   %eax,%eax
8010108f:	7f 0d                	jg     8010109e <filedup+0x2d>
    panic("filedup");
80101091:	83 ec 0c             	sub    $0xc,%esp
80101094:	68 dd 89 10 80       	push   $0x801089dd
80101099:	e8 02 f5 ff ff       	call   801005a0 <panic>
  f->ref++;
8010109e:	8b 45 08             	mov    0x8(%ebp),%eax
801010a1:	8b 40 04             	mov    0x4(%eax),%eax
801010a4:	8d 50 01             	lea    0x1(%eax),%edx
801010a7:	8b 45 08             	mov    0x8(%ebp),%eax
801010aa:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010ad:	83 ec 0c             	sub    $0xc,%esp
801010b0:	68 80 20 11 80       	push   $0x80112080
801010b5:	e8 5e 43 00 00       	call   80105418 <release>
801010ba:	83 c4 10             	add    $0x10,%esp
  return f;
801010bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010c0:	c9                   	leave  
801010c1:	c3                   	ret    

801010c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010c2:	55                   	push   %ebp
801010c3:	89 e5                	mov    %esp,%ebp
801010c5:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	68 80 20 11 80       	push   $0x80112080
801010d0:	e8 d7 42 00 00       	call   801053ac <acquire>
801010d5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010d8:	8b 45 08             	mov    0x8(%ebp),%eax
801010db:	8b 40 04             	mov    0x4(%eax),%eax
801010de:	85 c0                	test   %eax,%eax
801010e0:	7f 0d                	jg     801010ef <fileclose+0x2d>
    panic("fileclose");
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	68 e5 89 10 80       	push   $0x801089e5
801010ea:	e8 b1 f4 ff ff       	call   801005a0 <panic>
  if(--f->ref > 0){
801010ef:	8b 45 08             	mov    0x8(%ebp),%eax
801010f2:	8b 40 04             	mov    0x4(%eax),%eax
801010f5:	8d 50 ff             	lea    -0x1(%eax),%edx
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	89 50 04             	mov    %edx,0x4(%eax)
801010fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101101:	8b 40 04             	mov    0x4(%eax),%eax
80101104:	85 c0                	test   %eax,%eax
80101106:	7e 15                	jle    8010111d <fileclose+0x5b>
    release(&ftable.lock);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	68 80 20 11 80       	push   $0x80112080
80101110:	e8 03 43 00 00       	call   80105418 <release>
80101115:	83 c4 10             	add    $0x10,%esp
80101118:	e9 8b 00 00 00       	jmp    801011a8 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010111d:	8b 45 08             	mov    0x8(%ebp),%eax
80101120:	8b 10                	mov    (%eax),%edx
80101122:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101125:	8b 50 04             	mov    0x4(%eax),%edx
80101128:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010112b:	8b 50 08             	mov    0x8(%eax),%edx
8010112e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101131:	8b 50 0c             	mov    0xc(%eax),%edx
80101134:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101137:	8b 50 10             	mov    0x10(%eax),%edx
8010113a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010113d:	8b 40 14             	mov    0x14(%eax),%eax
80101140:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101143:	8b 45 08             	mov    0x8(%ebp),%eax
80101146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	68 80 20 11 80       	push   $0x80112080
8010115e:	e8 b5 42 00 00       	call   80105418 <release>
80101163:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101166:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101169:	83 f8 01             	cmp    $0x1,%eax
8010116c:	75 19                	jne    80101187 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010116e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101172:	0f be d0             	movsbl %al,%edx
80101175:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101178:	83 ec 08             	sub    $0x8,%esp
8010117b:	52                   	push   %edx
8010117c:	50                   	push   %eax
8010117d:	e8 aa 2f 00 00       	call   8010412c <pipeclose>
80101182:	83 c4 10             	add    $0x10,%esp
80101185:	eb 21                	jmp    801011a8 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101187:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118a:	83 f8 02             	cmp    $0x2,%eax
8010118d:	75 19                	jne    801011a8 <fileclose+0xe6>
    begin_op();
8010118f:	e8 4b 24 00 00       	call   801035df <begin_op>
    iput(ff.ip);
80101194:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101197:	83 ec 0c             	sub    $0xc,%esp
8010119a:	50                   	push   %eax
8010119b:	e8 ec 09 00 00       	call   80101b8c <iput>
801011a0:	83 c4 10             	add    $0x10,%esp
    end_op();
801011a3:	e8 c3 24 00 00       	call   8010366b <end_op>
  }
}
801011a8:	c9                   	leave  
801011a9:	c3                   	ret    

801011aa <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011aa:	55                   	push   %ebp
801011ab:	89 e5                	mov    %esp,%ebp
801011ad:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 00                	mov    (%eax),%eax
801011b5:	83 f8 02             	cmp    $0x2,%eax
801011b8:	75 40                	jne    801011fa <filestat+0x50>
    ilock(f->ip);
801011ba:	8b 45 08             	mov    0x8(%ebp),%eax
801011bd:	8b 40 10             	mov    0x10(%eax),%eax
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	50                   	push   %eax
801011c4:	e8 58 08 00 00       	call   80101a21 <ilock>
801011c9:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011cc:	8b 45 08             	mov    0x8(%ebp),%eax
801011cf:	8b 40 10             	mov    0x10(%eax),%eax
801011d2:	83 ec 08             	sub    $0x8,%esp
801011d5:	ff 75 0c             	pushl  0xc(%ebp)
801011d8:	50                   	push   %eax
801011d9:	e8 d3 0c 00 00       	call   80101eb1 <stati>
801011de:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011e1:	8b 45 08             	mov    0x8(%ebp),%eax
801011e4:	8b 40 10             	mov    0x10(%eax),%eax
801011e7:	83 ec 0c             	sub    $0xc,%esp
801011ea:	50                   	push   %eax
801011eb:	e8 4e 09 00 00       	call   80101b3e <iunlock>
801011f0:	83 c4 10             	add    $0x10,%esp
    return 0;
801011f3:	b8 00 00 00 00       	mov    $0x0,%eax
801011f8:	eb 05                	jmp    801011ff <filestat+0x55>
  }
  return -1;
801011fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011ff:	c9                   	leave  
80101200:	c3                   	ret    

80101201 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101201:	55                   	push   %ebp
80101202:	89 e5                	mov    %esp,%ebp
80101204:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010120e:	84 c0                	test   %al,%al
80101210:	75 0a                	jne    8010121c <fileread+0x1b>
    return -1;
80101212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101217:	e9 9b 00 00 00       	jmp    801012b7 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010121c:	8b 45 08             	mov    0x8(%ebp),%eax
8010121f:	8b 00                	mov    (%eax),%eax
80101221:	83 f8 01             	cmp    $0x1,%eax
80101224:	75 1a                	jne    80101240 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101226:	8b 45 08             	mov    0x8(%ebp),%eax
80101229:	8b 40 0c             	mov    0xc(%eax),%eax
8010122c:	83 ec 04             	sub    $0x4,%esp
8010122f:	ff 75 10             	pushl  0x10(%ebp)
80101232:	ff 75 0c             	pushl  0xc(%ebp)
80101235:	50                   	push   %eax
80101236:	e8 99 30 00 00       	call   801042d4 <piperead>
8010123b:	83 c4 10             	add    $0x10,%esp
8010123e:	eb 77                	jmp    801012b7 <fileread+0xb6>
  if(f->type == FD_INODE){
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 00                	mov    (%eax),%eax
80101245:	83 f8 02             	cmp    $0x2,%eax
80101248:	75 60                	jne    801012aa <fileread+0xa9>
    ilock(f->ip);
8010124a:	8b 45 08             	mov    0x8(%ebp),%eax
8010124d:	8b 40 10             	mov    0x10(%eax),%eax
80101250:	83 ec 0c             	sub    $0xc,%esp
80101253:	50                   	push   %eax
80101254:	e8 c8 07 00 00       	call   80101a21 <ilock>
80101259:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010125c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	8b 50 14             	mov    0x14(%eax),%edx
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 40 10             	mov    0x10(%eax),%eax
8010126b:	51                   	push   %ecx
8010126c:	52                   	push   %edx
8010126d:	ff 75 0c             	pushl  0xc(%ebp)
80101270:	50                   	push   %eax
80101271:	e8 81 0c 00 00       	call   80101ef7 <readi>
80101276:	83 c4 10             	add    $0x10,%esp
80101279:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010127c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101280:	7e 11                	jle    80101293 <fileread+0x92>
      f->off += r;
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 50 14             	mov    0x14(%eax),%edx
80101288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128b:	01 c2                	add    %eax,%edx
8010128d:	8b 45 08             	mov    0x8(%ebp),%eax
80101290:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101293:	8b 45 08             	mov    0x8(%ebp),%eax
80101296:	8b 40 10             	mov    0x10(%eax),%eax
80101299:	83 ec 0c             	sub    $0xc,%esp
8010129c:	50                   	push   %eax
8010129d:	e8 9c 08 00 00       	call   80101b3e <iunlock>
801012a2:	83 c4 10             	add    $0x10,%esp
    return r;
801012a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012a8:	eb 0d                	jmp    801012b7 <fileread+0xb6>
  }
  panic("fileread");
801012aa:	83 ec 0c             	sub    $0xc,%esp
801012ad:	68 ef 89 10 80       	push   $0x801089ef
801012b2:	e8 e9 f2 ff ff       	call   801005a0 <panic>
}
801012b7:	c9                   	leave  
801012b8:	c3                   	ret    

801012b9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012b9:	55                   	push   %ebp
801012ba:	89 e5                	mov    %esp,%ebp
801012bc:	53                   	push   %ebx
801012bd:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012c7:	84 c0                	test   %al,%al
801012c9:	75 0a                	jne    801012d5 <filewrite+0x1c>
    return -1;
801012cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d0:	e9 1b 01 00 00       	jmp    801013f0 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012d5:	8b 45 08             	mov    0x8(%ebp),%eax
801012d8:	8b 00                	mov    (%eax),%eax
801012da:	83 f8 01             	cmp    $0x1,%eax
801012dd:	75 1d                	jne    801012fc <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012df:	8b 45 08             	mov    0x8(%ebp),%eax
801012e2:	8b 40 0c             	mov    0xc(%eax),%eax
801012e5:	83 ec 04             	sub    $0x4,%esp
801012e8:	ff 75 10             	pushl  0x10(%ebp)
801012eb:	ff 75 0c             	pushl  0xc(%ebp)
801012ee:	50                   	push   %eax
801012ef:	e8 e2 2e 00 00       	call   801041d6 <pipewrite>
801012f4:	83 c4 10             	add    $0x10,%esp
801012f7:	e9 f4 00 00 00       	jmp    801013f0 <filewrite+0x137>
  if(f->type == FD_INODE){
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 00                	mov    (%eax),%eax
80101301:	83 f8 02             	cmp    $0x2,%eax
80101304:	0f 85 d9 00 00 00    	jne    801013e3 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010130a:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101311:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101318:	e9 a3 00 00 00       	jmp    801013c0 <filewrite+0x107>
      int n1 = n - i;
8010131d:	8b 45 10             	mov    0x10(%ebp),%eax
80101320:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101323:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101326:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101329:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010132c:	7e 06                	jle    80101334 <filewrite+0x7b>
        n1 = max;
8010132e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101331:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101334:	e8 a6 22 00 00       	call   801035df <begin_op>
      ilock(f->ip);
80101339:	8b 45 08             	mov    0x8(%ebp),%eax
8010133c:	8b 40 10             	mov    0x10(%eax),%eax
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	50                   	push   %eax
80101343:	e8 d9 06 00 00       	call   80101a21 <ilock>
80101348:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010134b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010134e:	8b 45 08             	mov    0x8(%ebp),%eax
80101351:	8b 50 14             	mov    0x14(%eax),%edx
80101354:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010135a:	01 c3                	add    %eax,%ebx
8010135c:	8b 45 08             	mov    0x8(%ebp),%eax
8010135f:	8b 40 10             	mov    0x10(%eax),%eax
80101362:	51                   	push   %ecx
80101363:	52                   	push   %edx
80101364:	53                   	push   %ebx
80101365:	50                   	push   %eax
80101366:	e8 e3 0c 00 00       	call   8010204e <writei>
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101371:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101375:	7e 11                	jle    80101388 <filewrite+0xcf>
        f->off += r;
80101377:	8b 45 08             	mov    0x8(%ebp),%eax
8010137a:	8b 50 14             	mov    0x14(%eax),%edx
8010137d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101380:	01 c2                	add    %eax,%edx
80101382:	8b 45 08             	mov    0x8(%ebp),%eax
80101385:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	8b 40 10             	mov    0x10(%eax),%eax
8010138e:	83 ec 0c             	sub    $0xc,%esp
80101391:	50                   	push   %eax
80101392:	e8 a7 07 00 00       	call   80101b3e <iunlock>
80101397:	83 c4 10             	add    $0x10,%esp
      end_op();
8010139a:	e8 cc 22 00 00       	call   8010366b <end_op>

      if(r < 0)
8010139f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a3:	78 29                	js     801013ce <filewrite+0x115>
        break;
      if(r != n1)
801013a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013ab:	74 0d                	je     801013ba <filewrite+0x101>
        panic("short filewrite");
801013ad:	83 ec 0c             	sub    $0xc,%esp
801013b0:	68 f8 89 10 80       	push   $0x801089f8
801013b5:	e8 e6 f1 ff ff       	call   801005a0 <panic>
      i += r;
801013ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013bd:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801013c6:	0f 8c 51 ff ff ff    	jl     8010131d <filewrite+0x64>
801013cc:	eb 01                	jmp    801013cf <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013ce:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d2:	3b 45 10             	cmp    0x10(%ebp),%eax
801013d5:	75 05                	jne    801013dc <filewrite+0x123>
801013d7:	8b 45 10             	mov    0x10(%ebp),%eax
801013da:	eb 14                	jmp    801013f0 <filewrite+0x137>
801013dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013e1:	eb 0d                	jmp    801013f0 <filewrite+0x137>
  }
  panic("filewrite");
801013e3:	83 ec 0c             	sub    $0xc,%esp
801013e6:	68 08 8a 10 80       	push   $0x80108a08
801013eb:	e8 b0 f1 ff ff       	call   801005a0 <panic>
}
801013f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013f3:	c9                   	leave  
801013f4:	c3                   	ret    

801013f5 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013f5:	55                   	push   %ebp
801013f6:	89 e5                	mov    %esp,%ebp
801013f8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013fb:	8b 45 08             	mov    0x8(%ebp),%eax
801013fe:	83 ec 08             	sub    $0x8,%esp
80101401:	6a 01                	push   $0x1
80101403:	50                   	push   %eax
80101404:	e8 c5 ed ff ff       	call   801001ce <bread>
80101409:	83 c4 10             	add    $0x10,%esp
8010140c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010140f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101412:	83 c0 5c             	add    $0x5c,%eax
80101415:	83 ec 04             	sub    $0x4,%esp
80101418:	6a 1c                	push   $0x1c
8010141a:	50                   	push   %eax
8010141b:	ff 75 0c             	pushl  0xc(%ebp)
8010141e:	e8 c2 42 00 00       	call   801056e5 <memmove>
80101423:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101426:	83 ec 0c             	sub    $0xc,%esp
80101429:	ff 75 f4             	pushl  -0xc(%ebp)
8010142c:	e8 1f ee ff ff       	call   80100250 <brelse>
80101431:	83 c4 10             	add    $0x10,%esp
}
80101434:	90                   	nop
80101435:	c9                   	leave  
80101436:	c3                   	ret    

80101437 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101437:	55                   	push   %ebp
80101438:	89 e5                	mov    %esp,%ebp
8010143a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010143d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101440:	8b 45 08             	mov    0x8(%ebp),%eax
80101443:	83 ec 08             	sub    $0x8,%esp
80101446:	52                   	push   %edx
80101447:	50                   	push   %eax
80101448:	e8 81 ed ff ff       	call   801001ce <bread>
8010144d:	83 c4 10             	add    $0x10,%esp
80101450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101456:	83 c0 5c             	add    $0x5c,%eax
80101459:	83 ec 04             	sub    $0x4,%esp
8010145c:	68 00 02 00 00       	push   $0x200
80101461:	6a 00                	push   $0x0
80101463:	50                   	push   %eax
80101464:	e8 bd 41 00 00       	call   80105626 <memset>
80101469:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	ff 75 f4             	pushl  -0xc(%ebp)
80101472:	e8 a0 23 00 00       	call   80103817 <log_write>
80101477:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010147a:	83 ec 0c             	sub    $0xc,%esp
8010147d:	ff 75 f4             	pushl  -0xc(%ebp)
80101480:	e8 cb ed ff ff       	call   80100250 <brelse>
80101485:	83 c4 10             	add    $0x10,%esp
}
80101488:	90                   	nop
80101489:	c9                   	leave  
8010148a:	c3                   	ret    

8010148b <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010148b:	55                   	push   %ebp
8010148c:	89 e5                	mov    %esp,%ebp
8010148e:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101491:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010149f:	e9 13 01 00 00       	jmp    801015b7 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014ad:	85 c0                	test   %eax,%eax
801014af:	0f 48 c2             	cmovs  %edx,%eax
801014b2:	c1 f8 0c             	sar    $0xc,%eax
801014b5:	89 c2                	mov    %eax,%edx
801014b7:	a1 98 2a 11 80       	mov    0x80112a98,%eax
801014bc:	01 d0                	add    %edx,%eax
801014be:	83 ec 08             	sub    $0x8,%esp
801014c1:	50                   	push   %eax
801014c2:	ff 75 08             	pushl  0x8(%ebp)
801014c5:	e8 04 ed ff ff       	call   801001ce <bread>
801014ca:	83 c4 10             	add    $0x10,%esp
801014cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014d7:	e9 a6 00 00 00       	jmp    80101582 <balloc+0xf7>
      m = 1 << (bi % 8);
801014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014df:	99                   	cltd   
801014e0:	c1 ea 1d             	shr    $0x1d,%edx
801014e3:	01 d0                	add    %edx,%eax
801014e5:	83 e0 07             	and    $0x7,%eax
801014e8:	29 d0                	sub    %edx,%eax
801014ea:	ba 01 00 00 00       	mov    $0x1,%edx
801014ef:	89 c1                	mov    %eax,%ecx
801014f1:	d3 e2                	shl    %cl,%edx
801014f3:	89 d0                	mov    %edx,%eax
801014f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fb:	8d 50 07             	lea    0x7(%eax),%edx
801014fe:	85 c0                	test   %eax,%eax
80101500:	0f 48 c2             	cmovs  %edx,%eax
80101503:	c1 f8 03             	sar    $0x3,%eax
80101506:	89 c2                	mov    %eax,%edx
80101508:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010150b:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101510:	0f b6 c0             	movzbl %al,%eax
80101513:	23 45 e8             	and    -0x18(%ebp),%eax
80101516:	85 c0                	test   %eax,%eax
80101518:	75 64                	jne    8010157e <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151d:	8d 50 07             	lea    0x7(%eax),%edx
80101520:	85 c0                	test   %eax,%eax
80101522:	0f 48 c2             	cmovs  %edx,%eax
80101525:	c1 f8 03             	sar    $0x3,%eax
80101528:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010152b:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101530:	89 d1                	mov    %edx,%ecx
80101532:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101535:	09 ca                	or     %ecx,%edx
80101537:	89 d1                	mov    %edx,%ecx
80101539:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010153c:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
80101543:	ff 75 ec             	pushl  -0x14(%ebp)
80101546:	e8 cc 22 00 00       	call   80103817 <log_write>
8010154b:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010154e:	83 ec 0c             	sub    $0xc,%esp
80101551:	ff 75 ec             	pushl  -0x14(%ebp)
80101554:	e8 f7 ec ff ff       	call   80100250 <brelse>
80101559:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010155c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101562:	01 c2                	add    %eax,%edx
80101564:	8b 45 08             	mov    0x8(%ebp),%eax
80101567:	83 ec 08             	sub    $0x8,%esp
8010156a:	52                   	push   %edx
8010156b:	50                   	push   %eax
8010156c:	e8 c6 fe ff ff       	call   80101437 <bzero>
80101571:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101574:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157a:	01 d0                	add    %edx,%eax
8010157c:	eb 57                	jmp    801015d5 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010157e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101582:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101589:	7f 17                	jg     801015a2 <balloc+0x117>
8010158b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101591:	01 d0                	add    %edx,%eax
80101593:	89 c2                	mov    %eax,%edx
80101595:	a1 80 2a 11 80       	mov    0x80112a80,%eax
8010159a:	39 c2                	cmp    %eax,%edx
8010159c:	0f 82 3a ff ff ff    	jb     801014dc <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	ff 75 ec             	pushl  -0x14(%ebp)
801015a8:	e8 a3 ec ff ff       	call   80100250 <brelse>
801015ad:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015b0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015b7:	8b 15 80 2a 11 80    	mov    0x80112a80,%edx
801015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c0:	39 c2                	cmp    %eax,%edx
801015c2:	0f 87 dc fe ff ff    	ja     801014a4 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015c8:	83 ec 0c             	sub    $0xc,%esp
801015cb:	68 14 8a 10 80       	push   $0x80108a14
801015d0:	e8 cb ef ff ff       	call   801005a0 <panic>
}
801015d5:	c9                   	leave  
801015d6:	c3                   	ret    

801015d7 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015d7:	55                   	push   %ebp
801015d8:	89 e5                	mov    %esp,%ebp
801015da:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015dd:	83 ec 08             	sub    $0x8,%esp
801015e0:	68 80 2a 11 80       	push   $0x80112a80
801015e5:	ff 75 08             	pushl  0x8(%ebp)
801015e8:	e8 08 fe ff ff       	call   801013f5 <readsb>
801015ed:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f3:	c1 e8 0c             	shr    $0xc,%eax
801015f6:	89 c2                	mov    %eax,%edx
801015f8:	a1 98 2a 11 80       	mov    0x80112a98,%eax
801015fd:	01 c2                	add    %eax,%edx
801015ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101602:	83 ec 08             	sub    $0x8,%esp
80101605:	52                   	push   %edx
80101606:	50                   	push   %eax
80101607:	e8 c2 eb ff ff       	call   801001ce <bread>
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101612:	8b 45 0c             	mov    0xc(%ebp),%eax
80101615:	25 ff 0f 00 00       	and    $0xfff,%eax
8010161a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101620:	99                   	cltd   
80101621:	c1 ea 1d             	shr    $0x1d,%edx
80101624:	01 d0                	add    %edx,%eax
80101626:	83 e0 07             	and    $0x7,%eax
80101629:	29 d0                	sub    %edx,%eax
8010162b:	ba 01 00 00 00       	mov    $0x1,%edx
80101630:	89 c1                	mov    %eax,%ecx
80101632:	d3 e2                	shl    %cl,%edx
80101634:	89 d0                	mov    %edx,%eax
80101636:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101639:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163c:	8d 50 07             	lea    0x7(%eax),%edx
8010163f:	85 c0                	test   %eax,%eax
80101641:	0f 48 c2             	cmovs  %edx,%eax
80101644:	c1 f8 03             	sar    $0x3,%eax
80101647:	89 c2                	mov    %eax,%edx
80101649:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010164c:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101651:	0f b6 c0             	movzbl %al,%eax
80101654:	23 45 ec             	and    -0x14(%ebp),%eax
80101657:	85 c0                	test   %eax,%eax
80101659:	75 0d                	jne    80101668 <bfree+0x91>
    panic("freeing free block");
8010165b:	83 ec 0c             	sub    $0xc,%esp
8010165e:	68 2a 8a 10 80       	push   $0x80108a2a
80101663:	e8 38 ef ff ff       	call   801005a0 <panic>
  bp->data[bi/8] &= ~m;
80101668:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166b:	8d 50 07             	lea    0x7(%eax),%edx
8010166e:	85 c0                	test   %eax,%eax
80101670:	0f 48 c2             	cmovs  %edx,%eax
80101673:	c1 f8 03             	sar    $0x3,%eax
80101676:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101679:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010167e:	89 d1                	mov    %edx,%ecx
80101680:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101683:	f7 d2                	not    %edx
80101685:	21 ca                	and    %ecx,%edx
80101687:	89 d1                	mov    %edx,%ecx
80101689:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010168c:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	ff 75 f4             	pushl  -0xc(%ebp)
80101696:	e8 7c 21 00 00       	call   80103817 <log_write>
8010169b:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	ff 75 f4             	pushl  -0xc(%ebp)
801016a4:	e8 a7 eb ff ff       	call   80100250 <brelse>
801016a9:	83 c4 10             	add    $0x10,%esp
}
801016ac:	90                   	nop
801016ad:	c9                   	leave  
801016ae:	c3                   	ret    

801016af <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016af:	55                   	push   %ebp
801016b0:	89 e5                	mov    %esp,%ebp
801016b2:	57                   	push   %edi
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
801016b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801016bf:	83 ec 08             	sub    $0x8,%esp
801016c2:	68 3d 8a 10 80       	push   $0x80108a3d
801016c7:	68 a0 2a 11 80       	push   $0x80112aa0
801016cc:	e8 b9 3c 00 00       	call   8010538a <initlock>
801016d1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016db:	eb 2d                	jmp    8010170a <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016e0:	89 d0                	mov    %edx,%eax
801016e2:	c1 e0 03             	shl    $0x3,%eax
801016e5:	01 d0                	add    %edx,%eax
801016e7:	c1 e0 04             	shl    $0x4,%eax
801016ea:	83 c0 30             	add    $0x30,%eax
801016ed:	05 a0 2a 11 80       	add    $0x80112aa0,%eax
801016f2:	83 c0 10             	add    $0x10,%eax
801016f5:	83 ec 08             	sub    $0x8,%esp
801016f8:	68 44 8a 10 80       	push   $0x80108a44
801016fd:	50                   	push   %eax
801016fe:	e8 29 3b 00 00       	call   8010522c <initsleeplock>
80101703:	83 c4 10             	add    $0x10,%esp
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101706:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010170a:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010170e:	7e cd                	jle    801016dd <iinit+0x2e>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
80101710:	83 ec 08             	sub    $0x8,%esp
80101713:	68 80 2a 11 80       	push   $0x80112a80
80101718:	ff 75 08             	pushl  0x8(%ebp)
8010171b:	e8 d5 fc ff ff       	call   801013f5 <readsb>
80101720:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101723:	a1 98 2a 11 80       	mov    0x80112a98,%eax
80101728:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010172b:	8b 3d 94 2a 11 80    	mov    0x80112a94,%edi
80101731:	8b 35 90 2a 11 80    	mov    0x80112a90,%esi
80101737:	8b 1d 8c 2a 11 80    	mov    0x80112a8c,%ebx
8010173d:	8b 0d 88 2a 11 80    	mov    0x80112a88,%ecx
80101743:	8b 15 84 2a 11 80    	mov    0x80112a84,%edx
80101749:	a1 80 2a 11 80       	mov    0x80112a80,%eax
8010174e:	ff 75 d4             	pushl  -0x2c(%ebp)
80101751:	57                   	push   %edi
80101752:	56                   	push   %esi
80101753:	53                   	push   %ebx
80101754:	51                   	push   %ecx
80101755:	52                   	push   %edx
80101756:	50                   	push   %eax
80101757:	68 4c 8a 10 80       	push   $0x80108a4c
8010175c:	e8 9f ec ff ff       	call   80100400 <cprintf>
80101761:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101764:	90                   	nop
80101765:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101768:	5b                   	pop    %ebx
80101769:	5e                   	pop    %esi
8010176a:	5f                   	pop    %edi
8010176b:	5d                   	pop    %ebp
8010176c:	c3                   	ret    

8010176d <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010176d:	55                   	push   %ebp
8010176e:	89 e5                	mov    %esp,%ebp
80101770:	83 ec 28             	sub    $0x28,%esp
80101773:	8b 45 0c             	mov    0xc(%ebp),%eax
80101776:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010177a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101781:	e9 9e 00 00 00       	jmp    80101824 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101789:	c1 e8 03             	shr    $0x3,%eax
8010178c:	89 c2                	mov    %eax,%edx
8010178e:	a1 94 2a 11 80       	mov    0x80112a94,%eax
80101793:	01 d0                	add    %edx,%eax
80101795:	83 ec 08             	sub    $0x8,%esp
80101798:	50                   	push   %eax
80101799:	ff 75 08             	pushl  0x8(%ebp)
8010179c:	e8 2d ea ff ff       	call   801001ce <bread>
801017a1:	83 c4 10             	add    $0x10,%esp
801017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017aa:	8d 50 5c             	lea    0x5c(%eax),%edx
801017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b0:	83 e0 07             	and    $0x7,%eax
801017b3:	c1 e0 06             	shl    $0x6,%eax
801017b6:	01 d0                	add    %edx,%eax
801017b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017be:	0f b7 00             	movzwl (%eax),%eax
801017c1:	66 85 c0             	test   %ax,%ax
801017c4:	75 4c                	jne    80101812 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017c6:	83 ec 04             	sub    $0x4,%esp
801017c9:	6a 40                	push   $0x40
801017cb:	6a 00                	push   $0x0
801017cd:	ff 75 ec             	pushl  -0x14(%ebp)
801017d0:	e8 51 3e 00 00       	call   80105626 <memset>
801017d5:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017db:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017df:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017e2:	83 ec 0c             	sub    $0xc,%esp
801017e5:	ff 75 f0             	pushl  -0x10(%ebp)
801017e8:	e8 2a 20 00 00       	call   80103817 <log_write>
801017ed:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	ff 75 f0             	pushl  -0x10(%ebp)
801017f6:	e8 55 ea ff ff       	call   80100250 <brelse>
801017fb:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101801:	83 ec 08             	sub    $0x8,%esp
80101804:	50                   	push   %eax
80101805:	ff 75 08             	pushl  0x8(%ebp)
80101808:	e8 f8 00 00 00       	call   80101905 <iget>
8010180d:	83 c4 10             	add    $0x10,%esp
80101810:	eb 30                	jmp    80101842 <ialloc+0xd5>
    }
    brelse(bp);
80101812:	83 ec 0c             	sub    $0xc,%esp
80101815:	ff 75 f0             	pushl  -0x10(%ebp)
80101818:	e8 33 ea ff ff       	call   80100250 <brelse>
8010181d:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101820:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101824:	8b 15 88 2a 11 80    	mov    0x80112a88,%edx
8010182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182d:	39 c2                	cmp    %eax,%edx
8010182f:	0f 87 51 ff ff ff    	ja     80101786 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101835:	83 ec 0c             	sub    $0xc,%esp
80101838:	68 9f 8a 10 80       	push   $0x80108a9f
8010183d:	e8 5e ed ff ff       	call   801005a0 <panic>
}
80101842:	c9                   	leave  
80101843:	c3                   	ret    

80101844 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	8b 45 08             	mov    0x8(%ebp),%eax
8010184d:	8b 40 04             	mov    0x4(%eax),%eax
80101850:	c1 e8 03             	shr    $0x3,%eax
80101853:	89 c2                	mov    %eax,%edx
80101855:	a1 94 2a 11 80       	mov    0x80112a94,%eax
8010185a:	01 c2                	add    %eax,%edx
8010185c:	8b 45 08             	mov    0x8(%ebp),%eax
8010185f:	8b 00                	mov    (%eax),%eax
80101861:	83 ec 08             	sub    $0x8,%esp
80101864:	52                   	push   %edx
80101865:	50                   	push   %eax
80101866:	e8 63 e9 ff ff       	call   801001ce <bread>
8010186b:	83 c4 10             	add    $0x10,%esp
8010186e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101874:	8d 50 5c             	lea    0x5c(%eax),%edx
80101877:	8b 45 08             	mov    0x8(%ebp),%eax
8010187a:	8b 40 04             	mov    0x4(%eax),%eax
8010187d:	83 e0 07             	and    $0x7,%eax
80101880:	c1 e0 06             	shl    $0x6,%eax
80101883:	01 d0                	add    %edx,%eax
80101885:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	0f b7 50 50          	movzwl 0x50(%eax),%edx
8010188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101892:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189f:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018a3:	8b 45 08             	mov    0x8(%ebp),%eax
801018a6:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ad:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018b1:	8b 45 08             	mov    0x8(%ebp),%eax
801018b4:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801018b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018bb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018bf:	8b 45 08             	mov    0x8(%ebp),%eax
801018c2:	8b 50 58             	mov    0x58(%eax),%edx
801018c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c8:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018cb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ce:	8d 50 5c             	lea    0x5c(%eax),%edx
801018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018d4:	83 c0 0c             	add    $0xc,%eax
801018d7:	83 ec 04             	sub    $0x4,%esp
801018da:	6a 34                	push   $0x34
801018dc:	52                   	push   %edx
801018dd:	50                   	push   %eax
801018de:	e8 02 3e 00 00       	call   801056e5 <memmove>
801018e3:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	ff 75 f4             	pushl  -0xc(%ebp)
801018ec:	e8 26 1f 00 00       	call   80103817 <log_write>
801018f1:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018f4:	83 ec 0c             	sub    $0xc,%esp
801018f7:	ff 75 f4             	pushl  -0xc(%ebp)
801018fa:	e8 51 e9 ff ff       	call   80100250 <brelse>
801018ff:	83 c4 10             	add    $0x10,%esp
}
80101902:	90                   	nop
80101903:	c9                   	leave  
80101904:	c3                   	ret    

80101905 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101905:	55                   	push   %ebp
80101906:	89 e5                	mov    %esp,%ebp
80101908:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010190b:	83 ec 0c             	sub    $0xc,%esp
8010190e:	68 a0 2a 11 80       	push   $0x80112aa0
80101913:	e8 94 3a 00 00       	call   801053ac <acquire>
80101918:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010191b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101922:	c7 45 f4 d4 2a 11 80 	movl   $0x80112ad4,-0xc(%ebp)
80101929:	eb 60                	jmp    8010198b <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192e:	8b 40 08             	mov    0x8(%eax),%eax
80101931:	85 c0                	test   %eax,%eax
80101933:	7e 39                	jle    8010196e <iget+0x69>
80101935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101938:	8b 00                	mov    (%eax),%eax
8010193a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010193d:	75 2f                	jne    8010196e <iget+0x69>
8010193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101942:	8b 40 04             	mov    0x4(%eax),%eax
80101945:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101948:	75 24                	jne    8010196e <iget+0x69>
      ip->ref++;
8010194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194d:	8b 40 08             	mov    0x8(%eax),%eax
80101950:	8d 50 01             	lea    0x1(%eax),%edx
80101953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101956:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	68 a0 2a 11 80       	push   $0x80112aa0
80101961:	e8 b2 3a 00 00       	call   80105418 <release>
80101966:	83 c4 10             	add    $0x10,%esp
      return ip;
80101969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196c:	eb 77                	jmp    801019e5 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010196e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101972:	75 10                	jne    80101984 <iget+0x7f>
80101974:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101977:	8b 40 08             	mov    0x8(%eax),%eax
8010197a:	85 c0                	test   %eax,%eax
8010197c:	75 06                	jne    80101984 <iget+0x7f>
      empty = ip;
8010197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101981:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101984:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010198b:	81 7d f4 f4 46 11 80 	cmpl   $0x801146f4,-0xc(%ebp)
80101992:	72 97                	jb     8010192b <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101994:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101998:	75 0d                	jne    801019a7 <iget+0xa2>
    panic("iget: no inodes");
8010199a:	83 ec 0c             	sub    $0xc,%esp
8010199d:	68 b1 8a 10 80       	push   $0x80108ab1
801019a2:	e8 f9 eb ff ff       	call   801005a0 <panic>

  ip = empty;
801019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b0:	8b 55 08             	mov    0x8(%ebp),%edx
801019b3:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801019bb:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019cb:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019d2:	83 ec 0c             	sub    $0xc,%esp
801019d5:	68 a0 2a 11 80       	push   $0x80112aa0
801019da:	e8 39 3a 00 00       	call   80105418 <release>
801019df:	83 c4 10             	add    $0x10,%esp

  return ip;
801019e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019e5:	c9                   	leave  
801019e6:	c3                   	ret    

801019e7 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019e7:	55                   	push   %ebp
801019e8:	89 e5                	mov    %esp,%ebp
801019ea:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019ed:	83 ec 0c             	sub    $0xc,%esp
801019f0:	68 a0 2a 11 80       	push   $0x80112aa0
801019f5:	e8 b2 39 00 00       	call   801053ac <acquire>
801019fa:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101a00:	8b 40 08             	mov    0x8(%eax),%eax
80101a03:	8d 50 01             	lea    0x1(%eax),%edx
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a0c:	83 ec 0c             	sub    $0xc,%esp
80101a0f:	68 a0 2a 11 80       	push   $0x80112aa0
80101a14:	e8 ff 39 00 00       	call   80105418 <release>
80101a19:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a1f:	c9                   	leave  
80101a20:	c3                   	ret    

80101a21 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a21:	55                   	push   %ebp
80101a22:	89 e5                	mov    %esp,%ebp
80101a24:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a2b:	74 0a                	je     80101a37 <ilock+0x16>
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 08             	mov    0x8(%eax),%eax
80101a33:	85 c0                	test   %eax,%eax
80101a35:	7f 0d                	jg     80101a44 <ilock+0x23>
    panic("ilock");
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	68 c1 8a 10 80       	push   $0x80108ac1
80101a3f:	e8 5c eb ff ff       	call   801005a0 <panic>

  acquiresleep(&ip->lock);
80101a44:	8b 45 08             	mov    0x8(%ebp),%eax
80101a47:	83 c0 0c             	add    $0xc,%eax
80101a4a:	83 ec 0c             	sub    $0xc,%esp
80101a4d:	50                   	push   %eax
80101a4e:	e8 15 38 00 00       	call   80105268 <acquiresleep>
80101a53:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a56:	8b 45 08             	mov    0x8(%ebp),%eax
80101a59:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a5c:	83 e0 02             	and    $0x2,%eax
80101a5f:	85 c0                	test   %eax,%eax
80101a61:	0f 85 d4 00 00 00    	jne    80101b3b <ilock+0x11a>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a67:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6a:	8b 40 04             	mov    0x4(%eax),%eax
80101a6d:	c1 e8 03             	shr    $0x3,%eax
80101a70:	89 c2                	mov    %eax,%edx
80101a72:	a1 94 2a 11 80       	mov    0x80112a94,%eax
80101a77:	01 c2                	add    %eax,%edx
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 00                	mov    (%eax),%eax
80101a7e:	83 ec 08             	sub    $0x8,%esp
80101a81:	52                   	push   %edx
80101a82:	50                   	push   %eax
80101a83:	e8 46 e7 ff ff       	call   801001ce <bread>
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a91:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	8b 40 04             	mov    0x4(%eax),%eax
80101a9a:	83 e0 07             	and    $0x7,%eax
80101a9d:	c1 e0 06             	shl    $0x6,%eax
80101aa0:	01 d0                	add    %edx,%eax
80101aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa8:	0f b7 10             	movzwl (%eax),%edx
80101aab:	8b 45 08             	mov    0x8(%ebp),%eax
80101aae:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80101abc:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ac3:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aca:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad1:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad8:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101adf:	8b 50 08             	mov    0x8(%eax),%edx
80101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae5:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aeb:	8d 50 0c             	lea    0xc(%eax),%edx
80101aee:	8b 45 08             	mov    0x8(%ebp),%eax
80101af1:	83 c0 5c             	add    $0x5c,%eax
80101af4:	83 ec 04             	sub    $0x4,%esp
80101af7:	6a 34                	push   $0x34
80101af9:	52                   	push   %edx
80101afa:	50                   	push   %eax
80101afb:	e8 e5 3b 00 00       	call   801056e5 <memmove>
80101b00:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b03:	83 ec 0c             	sub    $0xc,%esp
80101b06:	ff 75 f4             	pushl  -0xc(%ebp)
80101b09:	e8 42 e7 ff ff       	call   80100250 <brelse>
80101b0e:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b17:	83 c8 02             	or     $0x2,%eax
80101b1a:	89 c2                	mov    %eax,%edx
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	89 50 4c             	mov    %edx,0x4c(%eax)
    if(ip->type == 0)
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101b29:	66 85 c0             	test   %ax,%ax
80101b2c:	75 0d                	jne    80101b3b <ilock+0x11a>
      panic("ilock: no type");
80101b2e:	83 ec 0c             	sub    $0xc,%esp
80101b31:	68 c7 8a 10 80       	push   $0x80108ac7
80101b36:	e8 65 ea ff ff       	call   801005a0 <panic>
  }
}
80101b3b:	90                   	nop
80101b3c:	c9                   	leave  
80101b3d:	c3                   	ret    

80101b3e <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b3e:	55                   	push   %ebp
80101b3f:	89 e5                	mov    %esp,%ebp
80101b41:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b48:	74 20                	je     80101b6a <iunlock+0x2c>
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	83 c0 0c             	add    $0xc,%eax
80101b50:	83 ec 0c             	sub    $0xc,%esp
80101b53:	50                   	push   %eax
80101b54:	e8 c2 37 00 00       	call   8010531b <holdingsleep>
80101b59:	83 c4 10             	add    $0x10,%esp
80101b5c:	85 c0                	test   %eax,%eax
80101b5e:	74 0a                	je     80101b6a <iunlock+0x2c>
80101b60:	8b 45 08             	mov    0x8(%ebp),%eax
80101b63:	8b 40 08             	mov    0x8(%eax),%eax
80101b66:	85 c0                	test   %eax,%eax
80101b68:	7f 0d                	jg     80101b77 <iunlock+0x39>
    panic("iunlock");
80101b6a:	83 ec 0c             	sub    $0xc,%esp
80101b6d:	68 d6 8a 10 80       	push   $0x80108ad6
80101b72:	e8 29 ea ff ff       	call   801005a0 <panic>

  releasesleep(&ip->lock);
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	83 c0 0c             	add    $0xc,%eax
80101b7d:	83 ec 0c             	sub    $0xc,%esp
80101b80:	50                   	push   %eax
80101b81:	e8 47 37 00 00       	call   801052cd <releasesleep>
80101b86:	83 c4 10             	add    $0x10,%esp
}
80101b89:	90                   	nop
80101b8a:	c9                   	leave  
80101b8b:	c3                   	ret    

80101b8c <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b8c:	55                   	push   %ebp
80101b8d:	89 e5                	mov    %esp,%ebp
80101b8f:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b92:	83 ec 0c             	sub    $0xc,%esp
80101b95:	68 a0 2a 11 80       	push   $0x80112aa0
80101b9a:	e8 0d 38 00 00       	call   801053ac <acquire>
80101b9f:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba5:	8b 40 08             	mov    0x8(%eax),%eax
80101ba8:	83 f8 01             	cmp    $0x1,%eax
80101bab:	75 68                	jne    80101c15 <iput+0x89>
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 40 4c             	mov    0x4c(%eax),%eax
80101bb3:	83 e0 02             	and    $0x2,%eax
80101bb6:	85 c0                	test   %eax,%eax
80101bb8:	74 5b                	je     80101c15 <iput+0x89>
80101bba:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbd:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101bc1:	66 85 c0             	test   %ax,%ax
80101bc4:	75 4f                	jne    80101c15 <iput+0x89>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
80101bc6:	83 ec 0c             	sub    $0xc,%esp
80101bc9:	68 a0 2a 11 80       	push   $0x80112aa0
80101bce:	e8 45 38 00 00       	call   80105418 <release>
80101bd3:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	ff 75 08             	pushl  0x8(%ebp)
80101bdc:	e8 a0 01 00 00       	call   80101d81 <itrunc>
80101be1:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101be4:	8b 45 08             	mov    0x8(%ebp),%eax
80101be7:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
    iupdate(ip);
80101bed:	83 ec 0c             	sub    $0xc,%esp
80101bf0:	ff 75 08             	pushl  0x8(%ebp)
80101bf3:	e8 4c fc ff ff       	call   80101844 <iupdate>
80101bf8:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
80101bfe:	68 a0 2a 11 80       	push   $0x80112aa0
80101c03:	e8 a4 37 00 00       	call   801053ac <acquire>
80101c08:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }
  ip->ref--;
80101c15:	8b 45 08             	mov    0x8(%ebp),%eax
80101c18:	8b 40 08             	mov    0x8(%eax),%eax
80101c1b:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c24:	83 ec 0c             	sub    $0xc,%esp
80101c27:	68 a0 2a 11 80       	push   $0x80112aa0
80101c2c:	e8 e7 37 00 00       	call   80105418 <release>
80101c31:	83 c4 10             	add    $0x10,%esp
}
80101c34:	90                   	nop
80101c35:	c9                   	leave  
80101c36:	c3                   	ret    

80101c37 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c37:	55                   	push   %ebp
80101c38:	89 e5                	mov    %esp,%ebp
80101c3a:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c3d:	83 ec 0c             	sub    $0xc,%esp
80101c40:	ff 75 08             	pushl  0x8(%ebp)
80101c43:	e8 f6 fe ff ff       	call   80101b3e <iunlock>
80101c48:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c4b:	83 ec 0c             	sub    $0xc,%esp
80101c4e:	ff 75 08             	pushl  0x8(%ebp)
80101c51:	e8 36 ff ff ff       	call   80101b8c <iput>
80101c56:	83 c4 10             	add    $0x10,%esp
}
80101c59:	90                   	nop
80101c5a:	c9                   	leave  
80101c5b:	c3                   	ret    

80101c5c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c5c:	55                   	push   %ebp
80101c5d:	89 e5                	mov    %esp,%ebp
80101c5f:	53                   	push   %ebx
80101c60:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c63:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c67:	77 42                	ja     80101cab <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c69:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c6f:	83 c2 14             	add    $0x14,%edx
80101c72:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c7d:	75 24                	jne    80101ca3 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c82:	8b 00                	mov    (%eax),%eax
80101c84:	83 ec 0c             	sub    $0xc,%esp
80101c87:	50                   	push   %eax
80101c88:	e8 fe f7 ff ff       	call   8010148b <balloc>
80101c8d:	83 c4 10             	add    $0x10,%esp
80101c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c99:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c9f:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ca6:	e9 d1 00 00 00       	jmp    80101d7c <bmap+0x120>
  }
  bn -= NDIRECT;
80101cab:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101caf:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cb3:	0f 87 b6 00 00 00    	ja     80101d6f <bmap+0x113>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cc9:	75 20                	jne    80101ceb <bmap+0x8f>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cce:	8b 00                	mov    (%eax),%eax
80101cd0:	83 ec 0c             	sub    $0xc,%esp
80101cd3:	50                   	push   %eax
80101cd4:	e8 b2 f7 ff ff       	call   8010148b <balloc>
80101cd9:	83 c4 10             	add    $0x10,%esp
80101cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce5:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cee:	8b 00                	mov    (%eax),%eax
80101cf0:	83 ec 08             	sub    $0x8,%esp
80101cf3:	ff 75 f4             	pushl  -0xc(%ebp)
80101cf6:	50                   	push   %eax
80101cf7:	e8 d2 e4 ff ff       	call   801001ce <bread>
80101cfc:	83 c4 10             	add    $0x10,%esp
80101cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d05:	83 c0 5c             	add    $0x5c,%eax
80101d08:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d18:	01 d0                	add    %edx,%eax
80101d1a:	8b 00                	mov    (%eax),%eax
80101d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d23:	75 37                	jne    80101d5c <bmap+0x100>
      a[bn] = addr = balloc(ip->dev);
80101d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d32:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	8b 00                	mov    (%eax),%eax
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	50                   	push   %eax
80101d3e:	e8 48 f7 ff ff       	call   8010148b <balloc>
80101d43:	83 c4 10             	add    $0x10,%esp
80101d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4c:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101d4e:	83 ec 0c             	sub    $0xc,%esp
80101d51:	ff 75 f0             	pushl  -0x10(%ebp)
80101d54:	e8 be 1a 00 00       	call   80103817 <log_write>
80101d59:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d5c:	83 ec 0c             	sub    $0xc,%esp
80101d5f:	ff 75 f0             	pushl  -0x10(%ebp)
80101d62:	e8 e9 e4 ff ff       	call   80100250 <brelse>
80101d67:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d6d:	eb 0d                	jmp    80101d7c <bmap+0x120>
  }

  panic("bmap: out of range");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 de 8a 10 80       	push   $0x80108ade
80101d77:	e8 24 e8 ff ff       	call   801005a0 <panic>
}
80101d7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d7f:	c9                   	leave  
80101d80:	c3                   	ret    

80101d81 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d81:	55                   	push   %ebp
80101d82:	89 e5                	mov    %esp,%ebp
80101d84:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d8e:	eb 45                	jmp    80101dd5 <itrunc+0x54>
    if(ip->addrs[i]){
80101d90:	8b 45 08             	mov    0x8(%ebp),%eax
80101d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d96:	83 c2 14             	add    $0x14,%edx
80101d99:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	74 30                	je     80101dd1 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101da1:	8b 45 08             	mov    0x8(%ebp),%eax
80101da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da7:	83 c2 14             	add    $0x14,%edx
80101daa:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101dae:	8b 55 08             	mov    0x8(%ebp),%edx
80101db1:	8b 12                	mov    (%edx),%edx
80101db3:	83 ec 08             	sub    $0x8,%esp
80101db6:	50                   	push   %eax
80101db7:	52                   	push   %edx
80101db8:	e8 1a f8 ff ff       	call   801015d7 <bfree>
80101dbd:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dc6:	83 c2 14             	add    $0x14,%edx
80101dc9:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dd0:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dd5:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dd9:	7e b5                	jle    80101d90 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dde:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101de4:	85 c0                	test   %eax,%eax
80101de6:	0f 84 aa 00 00 00    	je     80101e96 <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101df5:	8b 45 08             	mov    0x8(%ebp),%eax
80101df8:	8b 00                	mov    (%eax),%eax
80101dfa:	83 ec 08             	sub    $0x8,%esp
80101dfd:	52                   	push   %edx
80101dfe:	50                   	push   %eax
80101dff:	e8 ca e3 ff ff       	call   801001ce <bread>
80101e04:	83 c4 10             	add    $0x10,%esp
80101e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e0d:	83 c0 5c             	add    $0x5c,%eax
80101e10:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e1a:	eb 3c                	jmp    80101e58 <itrunc+0xd7>
      if(a[j])
80101e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e29:	01 d0                	add    %edx,%eax
80101e2b:	8b 00                	mov    (%eax),%eax
80101e2d:	85 c0                	test   %eax,%eax
80101e2f:	74 23                	je     80101e54 <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e3e:	01 d0                	add    %edx,%eax
80101e40:	8b 00                	mov    (%eax),%eax
80101e42:	8b 55 08             	mov    0x8(%ebp),%edx
80101e45:	8b 12                	mov    (%edx),%edx
80101e47:	83 ec 08             	sub    $0x8,%esp
80101e4a:	50                   	push   %eax
80101e4b:	52                   	push   %edx
80101e4c:	e8 86 f7 ff ff       	call   801015d7 <bfree>
80101e51:	83 c4 10             	add    $0x10,%esp
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e54:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e5b:	83 f8 7f             	cmp    $0x7f,%eax
80101e5e:	76 bc                	jbe    80101e1c <itrunc+0x9b>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	ff 75 ec             	pushl  -0x14(%ebp)
80101e66:	e8 e5 e3 ff ff       	call   80100250 <brelse>
80101e6b:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e71:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e77:	8b 55 08             	mov    0x8(%ebp),%edx
80101e7a:	8b 12                	mov    (%edx),%edx
80101e7c:	83 ec 08             	sub    $0x8,%esp
80101e7f:	50                   	push   %eax
80101e80:	52                   	push   %edx
80101e81:	e8 51 f7 ff ff       	call   801015d7 <bfree>
80101e86:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e89:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8c:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e93:	00 00 00 
  }

  ip->size = 0;
80101e96:	8b 45 08             	mov    0x8(%ebp),%eax
80101e99:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	ff 75 08             	pushl  0x8(%ebp)
80101ea6:	e8 99 f9 ff ff       	call   80101844 <iupdate>
80101eab:	83 c4 10             	add    $0x10,%esp
}
80101eae:	90                   	nop
80101eaf:	c9                   	leave  
80101eb0:	c3                   	ret    

80101eb1 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101eb1:	55                   	push   %ebp
80101eb2:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	8b 00                	mov    (%eax),%eax
80101eb9:	89 c2                	mov    %eax,%edx
80101ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebe:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	8b 50 04             	mov    0x4(%eax),%edx
80101ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eca:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed0:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed7:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101eda:	8b 45 08             	mov    0x8(%ebp),%eax
80101edd:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ee4:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8b 50 58             	mov    0x58(%eax),%edx
80101eee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ef1:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ef4:	90                   	nop
80101ef5:	5d                   	pop    %ebp
80101ef6:	c3                   	ret    

80101ef7 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ef7:	55                   	push   %ebp
80101ef8:	89 e5                	mov    %esp,%ebp
80101efa:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f04:	66 83 f8 03          	cmp    $0x3,%ax
80101f08:	75 5c                	jne    80101f66 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f11:	66 85 c0             	test   %ax,%ax
80101f14:	78 20                	js     80101f36 <readi+0x3f>
80101f16:	8b 45 08             	mov    0x8(%ebp),%eax
80101f19:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f1d:	66 83 f8 09          	cmp    $0x9,%ax
80101f21:	7f 13                	jg     80101f36 <readi+0x3f>
80101f23:	8b 45 08             	mov    0x8(%ebp),%eax
80101f26:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f2a:	98                   	cwtl   
80101f2b:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
80101f32:	85 c0                	test   %eax,%eax
80101f34:	75 0a                	jne    80101f40 <readi+0x49>
      return -1;
80101f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f3b:	e9 0c 01 00 00       	jmp    8010204c <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f47:	98                   	cwtl   
80101f48:	8b 04 c5 20 2a 11 80 	mov    -0x7feed5e0(,%eax,8),%eax
80101f4f:	8b 55 14             	mov    0x14(%ebp),%edx
80101f52:	83 ec 04             	sub    $0x4,%esp
80101f55:	52                   	push   %edx
80101f56:	ff 75 0c             	pushl  0xc(%ebp)
80101f59:	ff 75 08             	pushl  0x8(%ebp)
80101f5c:	ff d0                	call   *%eax
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	e9 e6 00 00 00       	jmp    8010204c <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101f66:	8b 45 08             	mov    0x8(%ebp),%eax
80101f69:	8b 40 58             	mov    0x58(%eax),%eax
80101f6c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f6f:	72 0d                	jb     80101f7e <readi+0x87>
80101f71:	8b 55 10             	mov    0x10(%ebp),%edx
80101f74:	8b 45 14             	mov    0x14(%ebp),%eax
80101f77:	01 d0                	add    %edx,%eax
80101f79:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f7c:	73 0a                	jae    80101f88 <readi+0x91>
    return -1;
80101f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f83:	e9 c4 00 00 00       	jmp    8010204c <readi+0x155>
  if(off + n > ip->size)
80101f88:	8b 55 10             	mov    0x10(%ebp),%edx
80101f8b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f8e:	01 c2                	add    %eax,%edx
80101f90:	8b 45 08             	mov    0x8(%ebp),%eax
80101f93:	8b 40 58             	mov    0x58(%eax),%eax
80101f96:	39 c2                	cmp    %eax,%edx
80101f98:	76 0c                	jbe    80101fa6 <readi+0xaf>
    n = ip->size - off;
80101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9d:	8b 40 58             	mov    0x58(%eax),%eax
80101fa0:	2b 45 10             	sub    0x10(%ebp),%eax
80101fa3:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fad:	e9 8b 00 00 00       	jmp    8010203d <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb2:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb5:	c1 e8 09             	shr    $0x9,%eax
80101fb8:	83 ec 08             	sub    $0x8,%esp
80101fbb:	50                   	push   %eax
80101fbc:	ff 75 08             	pushl  0x8(%ebp)
80101fbf:	e8 98 fc ff ff       	call   80101c5c <bmap>
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	89 c2                	mov    %eax,%edx
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	8b 00                	mov    (%eax),%eax
80101fce:	83 ec 08             	sub    $0x8,%esp
80101fd1:	52                   	push   %edx
80101fd2:	50                   	push   %eax
80101fd3:	e8 f6 e1 ff ff       	call   801001ce <bread>
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fde:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fe6:	ba 00 02 00 00       	mov    $0x200,%edx
80101feb:	29 c2                	sub    %eax,%edx
80101fed:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff0:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101ff3:	39 c2                	cmp    %eax,%edx
80101ff5:	0f 46 c2             	cmovbe %edx,%eax
80101ff8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffe:	8d 50 5c             	lea    0x5c(%eax),%edx
80102001:	8b 45 10             	mov    0x10(%ebp),%eax
80102004:	25 ff 01 00 00       	and    $0x1ff,%eax
80102009:	01 d0                	add    %edx,%eax
8010200b:	83 ec 04             	sub    $0x4,%esp
8010200e:	ff 75 ec             	pushl  -0x14(%ebp)
80102011:	50                   	push   %eax
80102012:	ff 75 0c             	pushl  0xc(%ebp)
80102015:	e8 cb 36 00 00       	call   801056e5 <memmove>
8010201a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	ff 75 f0             	pushl  -0x10(%ebp)
80102023:	e8 28 e2 ff ff       	call   80100250 <brelse>
80102028:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010202b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102031:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102034:	01 45 10             	add    %eax,0x10(%ebp)
80102037:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010203a:	01 45 0c             	add    %eax,0xc(%ebp)
8010203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102040:	3b 45 14             	cmp    0x14(%ebp),%eax
80102043:	0f 82 69 ff ff ff    	jb     80101fb2 <readi+0xbb>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80102049:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010204c:	c9                   	leave  
8010204d:	c3                   	ret    

8010204e <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010204e:	55                   	push   %ebp
8010204f:	89 e5                	mov    %esp,%ebp
80102051:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102054:	8b 45 08             	mov    0x8(%ebp),%eax
80102057:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010205b:	66 83 f8 03          	cmp    $0x3,%ax
8010205f:	75 5c                	jne    801020bd <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102061:	8b 45 08             	mov    0x8(%ebp),%eax
80102064:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102068:	66 85 c0             	test   %ax,%ax
8010206b:	78 20                	js     8010208d <writei+0x3f>
8010206d:	8b 45 08             	mov    0x8(%ebp),%eax
80102070:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102074:	66 83 f8 09          	cmp    $0x9,%ax
80102078:	7f 13                	jg     8010208d <writei+0x3f>
8010207a:	8b 45 08             	mov    0x8(%ebp),%eax
8010207d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102081:	98                   	cwtl   
80102082:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
80102089:	85 c0                	test   %eax,%eax
8010208b:	75 0a                	jne    80102097 <writei+0x49>
      return -1;
8010208d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102092:	e9 3d 01 00 00       	jmp    801021d4 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102097:	8b 45 08             	mov    0x8(%ebp),%eax
8010209a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010209e:	98                   	cwtl   
8010209f:	8b 04 c5 24 2a 11 80 	mov    -0x7feed5dc(,%eax,8),%eax
801020a6:	8b 55 14             	mov    0x14(%ebp),%edx
801020a9:	83 ec 04             	sub    $0x4,%esp
801020ac:	52                   	push   %edx
801020ad:	ff 75 0c             	pushl  0xc(%ebp)
801020b0:	ff 75 08             	pushl  0x8(%ebp)
801020b3:	ff d0                	call   *%eax
801020b5:	83 c4 10             	add    $0x10,%esp
801020b8:	e9 17 01 00 00       	jmp    801021d4 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801020bd:	8b 45 08             	mov    0x8(%ebp),%eax
801020c0:	8b 40 58             	mov    0x58(%eax),%eax
801020c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801020c6:	72 0d                	jb     801020d5 <writei+0x87>
801020c8:	8b 55 10             	mov    0x10(%ebp),%edx
801020cb:	8b 45 14             	mov    0x14(%ebp),%eax
801020ce:	01 d0                	add    %edx,%eax
801020d0:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d3:	73 0a                	jae    801020df <writei+0x91>
    return -1;
801020d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020da:	e9 f5 00 00 00       	jmp    801021d4 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801020df:	8b 55 10             	mov    0x10(%ebp),%edx
801020e2:	8b 45 14             	mov    0x14(%ebp),%eax
801020e5:	01 d0                	add    %edx,%eax
801020e7:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020ec:	76 0a                	jbe    801020f8 <writei+0xaa>
    return -1;
801020ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f3:	e9 dc 00 00 00       	jmp    801021d4 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020ff:	e9 99 00 00 00       	jmp    8010219d <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102104:	8b 45 10             	mov    0x10(%ebp),%eax
80102107:	c1 e8 09             	shr    $0x9,%eax
8010210a:	83 ec 08             	sub    $0x8,%esp
8010210d:	50                   	push   %eax
8010210e:	ff 75 08             	pushl  0x8(%ebp)
80102111:	e8 46 fb ff ff       	call   80101c5c <bmap>
80102116:	83 c4 10             	add    $0x10,%esp
80102119:	89 c2                	mov    %eax,%edx
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
8010211e:	8b 00                	mov    (%eax),%eax
80102120:	83 ec 08             	sub    $0x8,%esp
80102123:	52                   	push   %edx
80102124:	50                   	push   %eax
80102125:	e8 a4 e0 ff ff       	call   801001ce <bread>
8010212a:	83 c4 10             	add    $0x10,%esp
8010212d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102130:	8b 45 10             	mov    0x10(%ebp),%eax
80102133:	25 ff 01 00 00       	and    $0x1ff,%eax
80102138:	ba 00 02 00 00       	mov    $0x200,%edx
8010213d:	29 c2                	sub    %eax,%edx
8010213f:	8b 45 14             	mov    0x14(%ebp),%eax
80102142:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102145:	39 c2                	cmp    %eax,%edx
80102147:	0f 46 c2             	cmovbe %edx,%eax
8010214a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102150:	8d 50 5c             	lea    0x5c(%eax),%edx
80102153:	8b 45 10             	mov    0x10(%ebp),%eax
80102156:	25 ff 01 00 00       	and    $0x1ff,%eax
8010215b:	01 d0                	add    %edx,%eax
8010215d:	83 ec 04             	sub    $0x4,%esp
80102160:	ff 75 ec             	pushl  -0x14(%ebp)
80102163:	ff 75 0c             	pushl  0xc(%ebp)
80102166:	50                   	push   %eax
80102167:	e8 79 35 00 00       	call   801056e5 <memmove>
8010216c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010216f:	83 ec 0c             	sub    $0xc,%esp
80102172:	ff 75 f0             	pushl  -0x10(%ebp)
80102175:	e8 9d 16 00 00       	call   80103817 <log_write>
8010217a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010217d:	83 ec 0c             	sub    $0xc,%esp
80102180:	ff 75 f0             	pushl  -0x10(%ebp)
80102183:	e8 c8 e0 ff ff       	call   80100250 <brelse>
80102188:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010218b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010218e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102191:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102194:	01 45 10             	add    %eax,0x10(%ebp)
80102197:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010219a:	01 45 0c             	add    %eax,0xc(%ebp)
8010219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a0:	3b 45 14             	cmp    0x14(%ebp),%eax
801021a3:	0f 82 5b ff ff ff    	jb     80102104 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801021a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021ad:	74 22                	je     801021d1 <writei+0x183>
801021af:	8b 45 08             	mov    0x8(%ebp),%eax
801021b2:	8b 40 58             	mov    0x58(%eax),%eax
801021b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801021b8:	73 17                	jae    801021d1 <writei+0x183>
    ip->size = off;
801021ba:	8b 45 08             	mov    0x8(%ebp),%eax
801021bd:	8b 55 10             	mov    0x10(%ebp),%edx
801021c0:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021c3:	83 ec 0c             	sub    $0xc,%esp
801021c6:	ff 75 08             	pushl  0x8(%ebp)
801021c9:	e8 76 f6 ff ff       	call   80101844 <iupdate>
801021ce:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021d1:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021d4:	c9                   	leave  
801021d5:	c3                   	ret    

801021d6 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021d6:	55                   	push   %ebp
801021d7:	89 e5                	mov    %esp,%ebp
801021d9:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021dc:	83 ec 04             	sub    $0x4,%esp
801021df:	6a 0e                	push   $0xe
801021e1:	ff 75 0c             	pushl  0xc(%ebp)
801021e4:	ff 75 08             	pushl  0x8(%ebp)
801021e7:	e8 8f 35 00 00       	call   8010577b <strncmp>
801021ec:	83 c4 10             	add    $0x10,%esp
}
801021ef:	c9                   	leave  
801021f0:	c3                   	ret    

801021f1 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021f1:	55                   	push   %ebp
801021f2:	89 e5                	mov    %esp,%ebp
801021f4:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021f7:	8b 45 08             	mov    0x8(%ebp),%eax
801021fa:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021fe:	66 83 f8 01          	cmp    $0x1,%ax
80102202:	74 0d                	je     80102211 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 f1 8a 10 80       	push   $0x80108af1
8010220c:	e8 8f e3 ff ff       	call   801005a0 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102218:	eb 7b                	jmp    80102295 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010221a:	6a 10                	push   $0x10
8010221c:	ff 75 f4             	pushl  -0xc(%ebp)
8010221f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102222:	50                   	push   %eax
80102223:	ff 75 08             	pushl  0x8(%ebp)
80102226:	e8 cc fc ff ff       	call   80101ef7 <readi>
8010222b:	83 c4 10             	add    $0x10,%esp
8010222e:	83 f8 10             	cmp    $0x10,%eax
80102231:	74 0d                	je     80102240 <dirlookup+0x4f>
      panic("dirlink read");
80102233:	83 ec 0c             	sub    $0xc,%esp
80102236:	68 03 8b 10 80       	push   $0x80108b03
8010223b:	e8 60 e3 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
80102240:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102244:	66 85 c0             	test   %ax,%ax
80102247:	74 47                	je     80102290 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
80102249:	83 ec 08             	sub    $0x8,%esp
8010224c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010224f:	83 c0 02             	add    $0x2,%eax
80102252:	50                   	push   %eax
80102253:	ff 75 0c             	pushl  0xc(%ebp)
80102256:	e8 7b ff ff ff       	call   801021d6 <namecmp>
8010225b:	83 c4 10             	add    $0x10,%esp
8010225e:	85 c0                	test   %eax,%eax
80102260:	75 2f                	jne    80102291 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102262:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102266:	74 08                	je     80102270 <dirlookup+0x7f>
        *poff = off;
80102268:	8b 45 10             	mov    0x10(%ebp),%eax
8010226b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010226e:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102270:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102274:	0f b7 c0             	movzwl %ax,%eax
80102277:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010227a:	8b 45 08             	mov    0x8(%ebp),%eax
8010227d:	8b 00                	mov    (%eax),%eax
8010227f:	83 ec 08             	sub    $0x8,%esp
80102282:	ff 75 f0             	pushl  -0x10(%ebp)
80102285:	50                   	push   %eax
80102286:	e8 7a f6 ff ff       	call   80101905 <iget>
8010228b:	83 c4 10             	add    $0x10,%esp
8010228e:	eb 19                	jmp    801022a9 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102290:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102291:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102295:	8b 45 08             	mov    0x8(%ebp),%eax
80102298:	8b 40 58             	mov    0x58(%eax),%eax
8010229b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010229e:	0f 87 76 ff ff ff    	ja     8010221a <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801022a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022a9:	c9                   	leave  
801022aa:	c3                   	ret    

801022ab <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022ab:	55                   	push   %ebp
801022ac:	89 e5                	mov    %esp,%ebp
801022ae:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022b1:	83 ec 04             	sub    $0x4,%esp
801022b4:	6a 00                	push   $0x0
801022b6:	ff 75 0c             	pushl  0xc(%ebp)
801022b9:	ff 75 08             	pushl  0x8(%ebp)
801022bc:	e8 30 ff ff ff       	call   801021f1 <dirlookup>
801022c1:	83 c4 10             	add    $0x10,%esp
801022c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022cb:	74 18                	je     801022e5 <dirlink+0x3a>
    iput(ip);
801022cd:	83 ec 0c             	sub    $0xc,%esp
801022d0:	ff 75 f0             	pushl  -0x10(%ebp)
801022d3:	e8 b4 f8 ff ff       	call   80101b8c <iput>
801022d8:	83 c4 10             	add    $0x10,%esp
    return -1;
801022db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022e0:	e9 9c 00 00 00       	jmp    80102381 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022ec:	eb 39                	jmp    80102327 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f1:	6a 10                	push   $0x10
801022f3:	50                   	push   %eax
801022f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f7:	50                   	push   %eax
801022f8:	ff 75 08             	pushl  0x8(%ebp)
801022fb:	e8 f7 fb ff ff       	call   80101ef7 <readi>
80102300:	83 c4 10             	add    $0x10,%esp
80102303:	83 f8 10             	cmp    $0x10,%eax
80102306:	74 0d                	je     80102315 <dirlink+0x6a>
      panic("dirlink read");
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	68 03 8b 10 80       	push   $0x80108b03
80102310:	e8 8b e2 ff ff       	call   801005a0 <panic>
    if(de.inum == 0)
80102315:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102319:	66 85 c0             	test   %ax,%ax
8010231c:	74 18                	je     80102336 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102321:	83 c0 10             	add    $0x10,%eax
80102324:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102327:	8b 45 08             	mov    0x8(%ebp),%eax
8010232a:	8b 50 58             	mov    0x58(%eax),%edx
8010232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102330:	39 c2                	cmp    %eax,%edx
80102332:	77 ba                	ja     801022ee <dirlink+0x43>
80102334:	eb 01                	jmp    80102337 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102336:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	6a 0e                	push   $0xe
8010233c:	ff 75 0c             	pushl  0xc(%ebp)
8010233f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102342:	83 c0 02             	add    $0x2,%eax
80102345:	50                   	push   %eax
80102346:	e8 86 34 00 00       	call   801057d1 <strncpy>
8010234b:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010234e:	8b 45 10             	mov    0x10(%ebp),%eax
80102351:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102358:	6a 10                	push   $0x10
8010235a:	50                   	push   %eax
8010235b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010235e:	50                   	push   %eax
8010235f:	ff 75 08             	pushl  0x8(%ebp)
80102362:	e8 e7 fc ff ff       	call   8010204e <writei>
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	83 f8 10             	cmp    $0x10,%eax
8010236d:	74 0d                	je     8010237c <dirlink+0xd1>
    panic("dirlink");
8010236f:	83 ec 0c             	sub    $0xc,%esp
80102372:	68 10 8b 10 80       	push   $0x80108b10
80102377:	e8 24 e2 ff ff       	call   801005a0 <panic>

  return 0;
8010237c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102381:	c9                   	leave  
80102382:	c3                   	ret    

80102383 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102383:	55                   	push   %ebp
80102384:	89 e5                	mov    %esp,%ebp
80102386:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102389:	eb 04                	jmp    8010238f <skipelem+0xc>
    path++;
8010238b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010238f:	8b 45 08             	mov    0x8(%ebp),%eax
80102392:	0f b6 00             	movzbl (%eax),%eax
80102395:	3c 2f                	cmp    $0x2f,%al
80102397:	74 f2                	je     8010238b <skipelem+0x8>
    path++;
  if(*path == 0)
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	0f b6 00             	movzbl (%eax),%eax
8010239f:	84 c0                	test   %al,%al
801023a1:	75 07                	jne    801023aa <skipelem+0x27>
    return 0;
801023a3:	b8 00 00 00 00       	mov    $0x0,%eax
801023a8:	eb 7b                	jmp    80102425 <skipelem+0xa2>
  s = path;
801023aa:	8b 45 08             	mov    0x8(%ebp),%eax
801023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023b0:	eb 04                	jmp    801023b6 <skipelem+0x33>
    path++;
801023b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801023b6:	8b 45 08             	mov    0x8(%ebp),%eax
801023b9:	0f b6 00             	movzbl (%eax),%eax
801023bc:	3c 2f                	cmp    $0x2f,%al
801023be:	74 0a                	je     801023ca <skipelem+0x47>
801023c0:	8b 45 08             	mov    0x8(%ebp),%eax
801023c3:	0f b6 00             	movzbl (%eax),%eax
801023c6:	84 c0                	test   %al,%al
801023c8:	75 e8                	jne    801023b2 <skipelem+0x2f>
    path++;
  len = path - s;
801023ca:	8b 55 08             	mov    0x8(%ebp),%edx
801023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d0:	29 c2                	sub    %eax,%edx
801023d2:	89 d0                	mov    %edx,%eax
801023d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023d7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023db:	7e 15                	jle    801023f2 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801023dd:	83 ec 04             	sub    $0x4,%esp
801023e0:	6a 0e                	push   $0xe
801023e2:	ff 75 f4             	pushl  -0xc(%ebp)
801023e5:	ff 75 0c             	pushl  0xc(%ebp)
801023e8:	e8 f8 32 00 00       	call   801056e5 <memmove>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	eb 26                	jmp    80102418 <skipelem+0x95>
  else {
    memmove(name, s, len);
801023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f5:	83 ec 04             	sub    $0x4,%esp
801023f8:	50                   	push   %eax
801023f9:	ff 75 f4             	pushl  -0xc(%ebp)
801023fc:	ff 75 0c             	pushl  0xc(%ebp)
801023ff:	e8 e1 32 00 00       	call   801056e5 <memmove>
80102404:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102407:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010240a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010240d:	01 d0                	add    %edx,%eax
8010240f:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102412:	eb 04                	jmp    80102418 <skipelem+0x95>
    path++;
80102414:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
8010241b:	0f b6 00             	movzbl (%eax),%eax
8010241e:	3c 2f                	cmp    $0x2f,%al
80102420:	74 f2                	je     80102414 <skipelem+0x91>
    path++;
  return path;
80102422:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102425:	c9                   	leave  
80102426:	c3                   	ret    

80102427 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102427:	55                   	push   %ebp
80102428:	89 e5                	mov    %esp,%ebp
8010242a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010242d:	8b 45 08             	mov    0x8(%ebp),%eax
80102430:	0f b6 00             	movzbl (%eax),%eax
80102433:	3c 2f                	cmp    $0x2f,%al
80102435:	75 17                	jne    8010244e <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102437:	83 ec 08             	sub    $0x8,%esp
8010243a:	6a 01                	push   $0x1
8010243c:	6a 01                	push   $0x1
8010243e:	e8 c2 f4 ff ff       	call   80101905 <iget>
80102443:	83 c4 10             	add    $0x10,%esp
80102446:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102449:	e9 bb 00 00 00       	jmp    80102509 <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010244e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102454:	8b 40 78             	mov    0x78(%eax),%eax
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	50                   	push   %eax
8010245b:	e8 87 f5 ff ff       	call   801019e7 <idup>
80102460:	83 c4 10             	add    $0x10,%esp
80102463:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102466:	e9 9e 00 00 00       	jmp    80102509 <namex+0xe2>
    ilock(ip);
8010246b:	83 ec 0c             	sub    $0xc,%esp
8010246e:	ff 75 f4             	pushl  -0xc(%ebp)
80102471:	e8 ab f5 ff ff       	call   80101a21 <ilock>
80102476:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102479:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010247c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102480:	66 83 f8 01          	cmp    $0x1,%ax
80102484:	74 18                	je     8010249e <namex+0x77>
      iunlockput(ip);
80102486:	83 ec 0c             	sub    $0xc,%esp
80102489:	ff 75 f4             	pushl  -0xc(%ebp)
8010248c:	e8 a6 f7 ff ff       	call   80101c37 <iunlockput>
80102491:	83 c4 10             	add    $0x10,%esp
      return 0;
80102494:	b8 00 00 00 00       	mov    $0x0,%eax
80102499:	e9 a7 00 00 00       	jmp    80102545 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010249e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024a2:	74 20                	je     801024c4 <namex+0x9d>
801024a4:	8b 45 08             	mov    0x8(%ebp),%eax
801024a7:	0f b6 00             	movzbl (%eax),%eax
801024aa:	84 c0                	test   %al,%al
801024ac:	75 16                	jne    801024c4 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801024ae:	83 ec 0c             	sub    $0xc,%esp
801024b1:	ff 75 f4             	pushl  -0xc(%ebp)
801024b4:	e8 85 f6 ff ff       	call   80101b3e <iunlock>
801024b9:	83 c4 10             	add    $0x10,%esp
      return ip;
801024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024bf:	e9 81 00 00 00       	jmp    80102545 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	6a 00                	push   $0x0
801024c9:	ff 75 10             	pushl  0x10(%ebp)
801024cc:	ff 75 f4             	pushl  -0xc(%ebp)
801024cf:	e8 1d fd ff ff       	call   801021f1 <dirlookup>
801024d4:	83 c4 10             	add    $0x10,%esp
801024d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024de:	75 15                	jne    801024f5 <namex+0xce>
      iunlockput(ip);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	ff 75 f4             	pushl  -0xc(%ebp)
801024e6:	e8 4c f7 ff ff       	call   80101c37 <iunlockput>
801024eb:	83 c4 10             	add    $0x10,%esp
      return 0;
801024ee:	b8 00 00 00 00       	mov    $0x0,%eax
801024f3:	eb 50                	jmp    80102545 <namex+0x11e>
    }
    iunlockput(ip);
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	ff 75 f4             	pushl  -0xc(%ebp)
801024fb:	e8 37 f7 ff ff       	call   80101c37 <iunlockput>
80102500:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102503:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102509:	83 ec 08             	sub    $0x8,%esp
8010250c:	ff 75 10             	pushl  0x10(%ebp)
8010250f:	ff 75 08             	pushl  0x8(%ebp)
80102512:	e8 6c fe ff ff       	call   80102383 <skipelem>
80102517:	83 c4 10             	add    $0x10,%esp
8010251a:	89 45 08             	mov    %eax,0x8(%ebp)
8010251d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102521:	0f 85 44 ff ff ff    	jne    8010246b <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102527:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010252b:	74 15                	je     80102542 <namex+0x11b>
    iput(ip);
8010252d:	83 ec 0c             	sub    $0xc,%esp
80102530:	ff 75 f4             	pushl  -0xc(%ebp)
80102533:	e8 54 f6 ff ff       	call   80101b8c <iput>
80102538:	83 c4 10             	add    $0x10,%esp
    return 0;
8010253b:	b8 00 00 00 00       	mov    $0x0,%eax
80102540:	eb 03                	jmp    80102545 <namex+0x11e>
  }
  return ip;
80102542:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102545:	c9                   	leave  
80102546:	c3                   	ret    

80102547 <namei>:

struct inode*
namei(char *path)
{
80102547:	55                   	push   %ebp
80102548:	89 e5                	mov    %esp,%ebp
8010254a:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010254d:	83 ec 04             	sub    $0x4,%esp
80102550:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102553:	50                   	push   %eax
80102554:	6a 00                	push   $0x0
80102556:	ff 75 08             	pushl  0x8(%ebp)
80102559:	e8 c9 fe ff ff       	call   80102427 <namex>
8010255e:	83 c4 10             	add    $0x10,%esp
}
80102561:	c9                   	leave  
80102562:	c3                   	ret    

80102563 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102563:	55                   	push   %ebp
80102564:	89 e5                	mov    %esp,%ebp
80102566:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102569:	83 ec 04             	sub    $0x4,%esp
8010256c:	ff 75 0c             	pushl  0xc(%ebp)
8010256f:	6a 01                	push   $0x1
80102571:	ff 75 08             	pushl  0x8(%ebp)
80102574:	e8 ae fe ff ff       	call   80102427 <namex>
80102579:	83 c4 10             	add    $0x10,%esp
}
8010257c:	c9                   	leave  
8010257d:	c3                   	ret    

8010257e <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010257e:	55                   	push   %ebp
8010257f:	89 e5                	mov    %esp,%ebp
80102581:	83 ec 14             	sub    $0x14,%esp
80102584:	8b 45 08             	mov    0x8(%ebp),%eax
80102587:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010258b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010258f:	89 c2                	mov    %eax,%edx
80102591:	ec                   	in     (%dx),%al
80102592:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102595:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102599:	c9                   	leave  
8010259a:	c3                   	ret    

8010259b <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010259b:	55                   	push   %ebp
8010259c:	89 e5                	mov    %esp,%ebp
8010259e:	57                   	push   %edi
8010259f:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801025a0:	8b 55 08             	mov    0x8(%ebp),%edx
801025a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025a6:	8b 45 10             	mov    0x10(%ebp),%eax
801025a9:	89 cb                	mov    %ecx,%ebx
801025ab:	89 df                	mov    %ebx,%edi
801025ad:	89 c1                	mov    %eax,%ecx
801025af:	fc                   	cld    
801025b0:	f3 6d                	rep insl (%dx),%es:(%edi)
801025b2:	89 c8                	mov    %ecx,%eax
801025b4:	89 fb                	mov    %edi,%ebx
801025b6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025b9:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801025bc:	90                   	nop
801025bd:	5b                   	pop    %ebx
801025be:	5f                   	pop    %edi
801025bf:	5d                   	pop    %ebp
801025c0:	c3                   	ret    

801025c1 <outb>:

static inline void
outb(ushort port, uchar data)
{
801025c1:	55                   	push   %ebp
801025c2:	89 e5                	mov    %esp,%ebp
801025c4:	83 ec 08             	sub    $0x8,%esp
801025c7:	8b 55 08             	mov    0x8(%ebp),%edx
801025ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801025cd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801025d1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025d8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025dc:	ee                   	out    %al,(%dx)
}
801025dd:	90                   	nop
801025de:	c9                   	leave  
801025df:	c3                   	ret    

801025e0 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025e5:	8b 55 08             	mov    0x8(%ebp),%edx
801025e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025eb:	8b 45 10             	mov    0x10(%ebp),%eax
801025ee:	89 cb                	mov    %ecx,%ebx
801025f0:	89 de                	mov    %ebx,%esi
801025f2:	89 c1                	mov    %eax,%ecx
801025f4:	fc                   	cld    
801025f5:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025f7:	89 c8                	mov    %ecx,%eax
801025f9:	89 f3                	mov    %esi,%ebx
801025fb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025fe:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102601:	90                   	nop
80102602:	5b                   	pop    %ebx
80102603:	5e                   	pop    %esi
80102604:	5d                   	pop    %ebp
80102605:	c3                   	ret    

80102606 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102606:	55                   	push   %ebp
80102607:	89 e5                	mov    %esp,%ebp
80102609:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010260c:	90                   	nop
8010260d:	68 f7 01 00 00       	push   $0x1f7
80102612:	e8 67 ff ff ff       	call   8010257e <inb>
80102617:	83 c4 04             	add    $0x4,%esp
8010261a:	0f b6 c0             	movzbl %al,%eax
8010261d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102620:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102623:	25 c0 00 00 00       	and    $0xc0,%eax
80102628:	83 f8 40             	cmp    $0x40,%eax
8010262b:	75 e0                	jne    8010260d <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010262d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102631:	74 11                	je     80102644 <idewait+0x3e>
80102633:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102636:	83 e0 21             	and    $0x21,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	74 07                	je     80102644 <idewait+0x3e>
    return -1;
8010263d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102642:	eb 05                	jmp    80102649 <idewait+0x43>
  return 0;
80102644:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102649:	c9                   	leave  
8010264a:	c3                   	ret    

8010264b <ideinit>:

void
ideinit(void)
{
8010264b:	55                   	push   %ebp
8010264c:	89 e5                	mov    %esp,%ebp
8010264e:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102651:	83 ec 08             	sub    $0x8,%esp
80102654:	68 18 8b 10 80       	push   $0x80108b18
80102659:	68 20 c6 10 80       	push   $0x8010c620
8010265e:	e8 27 2d 00 00       	call   8010538a <initlock>
80102663:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102666:	83 ec 0c             	sub    $0xc,%esp
80102669:	6a 0e                	push   $0xe
8010266b:	e8 53 18 00 00       	call   80103ec3 <picenable>
80102670:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102673:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80102678:	83 e8 01             	sub    $0x1,%eax
8010267b:	83 ec 08             	sub    $0x8,%esp
8010267e:	50                   	push   %eax
8010267f:	6a 0e                	push   $0xe
80102681:	e8 b1 04 00 00       	call   80102b37 <ioapicenable>
80102686:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102689:	83 ec 0c             	sub    $0xc,%esp
8010268c:	6a 00                	push   $0x0
8010268e:	e8 73 ff ff ff       	call   80102606 <idewait>
80102693:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102696:	83 ec 08             	sub    $0x8,%esp
80102699:	68 f0 00 00 00       	push   $0xf0
8010269e:	68 f6 01 00 00       	push   $0x1f6
801026a3:	e8 19 ff ff ff       	call   801025c1 <outb>
801026a8:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801026ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026b2:	eb 24                	jmp    801026d8 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 f7 01 00 00       	push   $0x1f7
801026bc:	e8 bd fe ff ff       	call   8010257e <inb>
801026c1:	83 c4 10             	add    $0x10,%esp
801026c4:	84 c0                	test   %al,%al
801026c6:	74 0c                	je     801026d4 <ideinit+0x89>
      havedisk1 = 1;
801026c8:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801026cf:	00 00 00 
      break;
801026d2:	eb 0d                	jmp    801026e1 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801026d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026d8:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026df:	7e d3                	jle    801026b4 <ideinit+0x69>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026e1:	83 ec 08             	sub    $0x8,%esp
801026e4:	68 e0 00 00 00       	push   $0xe0
801026e9:	68 f6 01 00 00       	push   $0x1f6
801026ee:	e8 ce fe ff ff       	call   801025c1 <outb>
801026f3:	83 c4 10             	add    $0x10,%esp
}
801026f6:	90                   	nop
801026f7:	c9                   	leave  
801026f8:	c3                   	ret    

801026f9 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102703:	75 0d                	jne    80102712 <idestart+0x19>
    panic("idestart");
80102705:	83 ec 0c             	sub    $0xc,%esp
80102708:	68 1c 8b 10 80       	push   $0x80108b1c
8010270d:	e8 8e de ff ff       	call   801005a0 <panic>
  if(b->blockno >= FSSIZE)
80102712:	8b 45 08             	mov    0x8(%ebp),%eax
80102715:	8b 40 08             	mov    0x8(%eax),%eax
80102718:	3d e7 03 00 00       	cmp    $0x3e7,%eax
8010271d:	76 0d                	jbe    8010272c <idestart+0x33>
    panic("incorrect blockno");
8010271f:	83 ec 0c             	sub    $0xc,%esp
80102722:	68 25 8b 10 80       	push   $0x80108b25
80102727:	e8 74 de ff ff       	call   801005a0 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010272c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102733:	8b 45 08             	mov    0x8(%ebp),%eax
80102736:	8b 50 08             	mov    0x8(%eax),%edx
80102739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010273c:	0f af c2             	imul   %edx,%eax
8010273f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102742:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102746:	75 07                	jne    8010274f <idestart+0x56>
80102748:	b8 20 00 00 00       	mov    $0x20,%eax
8010274d:	eb 05                	jmp    80102754 <idestart+0x5b>
8010274f:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102757:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010275b:	75 07                	jne    80102764 <idestart+0x6b>
8010275d:	b8 30 00 00 00       	mov    $0x30,%eax
80102762:	eb 05                	jmp    80102769 <idestart+0x70>
80102764:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102769:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010276c:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102770:	7e 0d                	jle    8010277f <idestart+0x86>
80102772:	83 ec 0c             	sub    $0xc,%esp
80102775:	68 1c 8b 10 80       	push   $0x80108b1c
8010277a:	e8 21 de ff ff       	call   801005a0 <panic>

  idewait(0);
8010277f:	83 ec 0c             	sub    $0xc,%esp
80102782:	6a 00                	push   $0x0
80102784:	e8 7d fe ff ff       	call   80102606 <idewait>
80102789:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
8010278c:	83 ec 08             	sub    $0x8,%esp
8010278f:	6a 00                	push   $0x0
80102791:	68 f6 03 00 00       	push   $0x3f6
80102796:	e8 26 fe ff ff       	call   801025c1 <outb>
8010279b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a1:	0f b6 c0             	movzbl %al,%eax
801027a4:	83 ec 08             	sub    $0x8,%esp
801027a7:	50                   	push   %eax
801027a8:	68 f2 01 00 00       	push   $0x1f2
801027ad:	e8 0f fe ff ff       	call   801025c1 <outb>
801027b2:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801027b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b8:	0f b6 c0             	movzbl %al,%eax
801027bb:	83 ec 08             	sub    $0x8,%esp
801027be:	50                   	push   %eax
801027bf:	68 f3 01 00 00       	push   $0x1f3
801027c4:	e8 f8 fd ff ff       	call   801025c1 <outb>
801027c9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
801027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027cf:	c1 f8 08             	sar    $0x8,%eax
801027d2:	0f b6 c0             	movzbl %al,%eax
801027d5:	83 ec 08             	sub    $0x8,%esp
801027d8:	50                   	push   %eax
801027d9:	68 f4 01 00 00       	push   $0x1f4
801027de:	e8 de fd ff ff       	call   801025c1 <outb>
801027e3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027e9:	c1 f8 10             	sar    $0x10,%eax
801027ec:	0f b6 c0             	movzbl %al,%eax
801027ef:	83 ec 08             	sub    $0x8,%esp
801027f2:	50                   	push   %eax
801027f3:	68 f5 01 00 00       	push   $0x1f5
801027f8:	e8 c4 fd ff ff       	call   801025c1 <outb>
801027fd:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102800:	8b 45 08             	mov    0x8(%ebp),%eax
80102803:	8b 40 04             	mov    0x4(%eax),%eax
80102806:	83 e0 01             	and    $0x1,%eax
80102809:	c1 e0 04             	shl    $0x4,%eax
8010280c:	89 c2                	mov    %eax,%edx
8010280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102811:	c1 f8 18             	sar    $0x18,%eax
80102814:	83 e0 0f             	and    $0xf,%eax
80102817:	09 d0                	or     %edx,%eax
80102819:	83 c8 e0             	or     $0xffffffe0,%eax
8010281c:	0f b6 c0             	movzbl %al,%eax
8010281f:	83 ec 08             	sub    $0x8,%esp
80102822:	50                   	push   %eax
80102823:	68 f6 01 00 00       	push   $0x1f6
80102828:	e8 94 fd ff ff       	call   801025c1 <outb>
8010282d:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102830:	8b 45 08             	mov    0x8(%ebp),%eax
80102833:	8b 00                	mov    (%eax),%eax
80102835:	83 e0 04             	and    $0x4,%eax
80102838:	85 c0                	test   %eax,%eax
8010283a:	74 35                	je     80102871 <idestart+0x178>
    outb(0x1f7, write_cmd);
8010283c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010283f:	0f b6 c0             	movzbl %al,%eax
80102842:	83 ec 08             	sub    $0x8,%esp
80102845:	50                   	push   %eax
80102846:	68 f7 01 00 00       	push   $0x1f7
8010284b:	e8 71 fd ff ff       	call   801025c1 <outb>
80102850:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102853:	8b 45 08             	mov    0x8(%ebp),%eax
80102856:	83 c0 5c             	add    $0x5c,%eax
80102859:	83 ec 04             	sub    $0x4,%esp
8010285c:	68 80 00 00 00       	push   $0x80
80102861:	50                   	push   %eax
80102862:	68 f0 01 00 00       	push   $0x1f0
80102867:	e8 74 fd ff ff       	call   801025e0 <outsl>
8010286c:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010286f:	eb 17                	jmp    80102888 <idestart+0x18f>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
80102871:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102874:	0f b6 c0             	movzbl %al,%eax
80102877:	83 ec 08             	sub    $0x8,%esp
8010287a:	50                   	push   %eax
8010287b:	68 f7 01 00 00       	push   $0x1f7
80102880:	e8 3c fd ff ff       	call   801025c1 <outb>
80102885:	83 c4 10             	add    $0x10,%esp
  }
}
80102888:	90                   	nop
80102889:	c9                   	leave  
8010288a:	c3                   	ret    

8010288b <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010288b:	55                   	push   %ebp
8010288c:	89 e5                	mov    %esp,%ebp
8010288e:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102891:	83 ec 0c             	sub    $0xc,%esp
80102894:	68 20 c6 10 80       	push   $0x8010c620
80102899:	e8 0e 2b 00 00       	call   801053ac <acquire>
8010289e:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028a1:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028ad:	75 15                	jne    801028c4 <ideintr+0x39>
    release(&idelock);
801028af:	83 ec 0c             	sub    $0xc,%esp
801028b2:	68 20 c6 10 80       	push   $0x8010c620
801028b7:	e8 5c 2b 00 00       	call   80105418 <release>
801028bc:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801028bf:	e9 9a 00 00 00       	jmp    8010295e <ideintr+0xd3>
  }
  idequeue = b->qnext;
801028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c7:	8b 40 58             	mov    0x58(%eax),%eax
801028ca:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d2:	8b 00                	mov    (%eax),%eax
801028d4:	83 e0 04             	and    $0x4,%eax
801028d7:	85 c0                	test   %eax,%eax
801028d9:	75 2d                	jne    80102908 <ideintr+0x7d>
801028db:	83 ec 0c             	sub    $0xc,%esp
801028de:	6a 01                	push   $0x1
801028e0:	e8 21 fd ff ff       	call   80102606 <idewait>
801028e5:	83 c4 10             	add    $0x10,%esp
801028e8:	85 c0                	test   %eax,%eax
801028ea:	78 1c                	js     80102908 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ef:	83 c0 5c             	add    $0x5c,%eax
801028f2:	83 ec 04             	sub    $0x4,%esp
801028f5:	68 80 00 00 00       	push   $0x80
801028fa:	50                   	push   %eax
801028fb:	68 f0 01 00 00       	push   $0x1f0
80102900:	e8 96 fc ff ff       	call   8010259b <insl>
80102905:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010290b:	8b 00                	mov    (%eax),%eax
8010290d:	83 c8 02             	or     $0x2,%eax
80102910:	89 c2                	mov    %eax,%edx
80102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102915:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291a:	8b 00                	mov    (%eax),%eax
8010291c:	83 e0 fb             	and    $0xfffffffb,%eax
8010291f:	89 c2                	mov    %eax,%edx
80102921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102924:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102926:	83 ec 0c             	sub    $0xc,%esp
80102929:	ff 75 f4             	pushl  -0xc(%ebp)
8010292c:	e8 d8 26 00 00       	call   80105009 <wakeup>
80102931:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102934:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102939:	85 c0                	test   %eax,%eax
8010293b:	74 11                	je     8010294e <ideintr+0xc3>
    idestart(idequeue);
8010293d:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102942:	83 ec 0c             	sub    $0xc,%esp
80102945:	50                   	push   %eax
80102946:	e8 ae fd ff ff       	call   801026f9 <idestart>
8010294b:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010294e:	83 ec 0c             	sub    $0xc,%esp
80102951:	68 20 c6 10 80       	push   $0x8010c620
80102956:	e8 bd 2a 00 00       	call   80105418 <release>
8010295b:	83 c4 10             	add    $0x10,%esp
}
8010295e:	c9                   	leave  
8010295f:	c3                   	ret    

80102960 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102966:	8b 45 08             	mov    0x8(%ebp),%eax
80102969:	83 c0 0c             	add    $0xc,%eax
8010296c:	83 ec 0c             	sub    $0xc,%esp
8010296f:	50                   	push   %eax
80102970:	e8 a6 29 00 00       	call   8010531b <holdingsleep>
80102975:	83 c4 10             	add    $0x10,%esp
80102978:	85 c0                	test   %eax,%eax
8010297a:	75 0d                	jne    80102989 <iderw+0x29>
    panic("iderw: buf not locked");
8010297c:	83 ec 0c             	sub    $0xc,%esp
8010297f:	68 37 8b 10 80       	push   $0x80108b37
80102984:	e8 17 dc ff ff       	call   801005a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102989:	8b 45 08             	mov    0x8(%ebp),%eax
8010298c:	8b 00                	mov    (%eax),%eax
8010298e:	83 e0 06             	and    $0x6,%eax
80102991:	83 f8 02             	cmp    $0x2,%eax
80102994:	75 0d                	jne    801029a3 <iderw+0x43>
    panic("iderw: nothing to do");
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	68 4d 8b 10 80       	push   $0x80108b4d
8010299e:	e8 fd db ff ff       	call   801005a0 <panic>
  if(b->dev != 0 && !havedisk1)
801029a3:	8b 45 08             	mov    0x8(%ebp),%eax
801029a6:	8b 40 04             	mov    0x4(%eax),%eax
801029a9:	85 c0                	test   %eax,%eax
801029ab:	74 16                	je     801029c3 <iderw+0x63>
801029ad:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029b2:	85 c0                	test   %eax,%eax
801029b4:	75 0d                	jne    801029c3 <iderw+0x63>
    panic("iderw: ide disk 1 not present");
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	68 62 8b 10 80       	push   $0x80108b62
801029be:	e8 dd db ff ff       	call   801005a0 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801029c3:	83 ec 0c             	sub    $0xc,%esp
801029c6:	68 20 c6 10 80       	push   $0x8010c620
801029cb:	e8 dc 29 00 00       	call   801053ac <acquire>
801029d0:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801029d3:	8b 45 08             	mov    0x8(%ebp),%eax
801029d6:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029dd:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
801029e4:	eb 0b                	jmp    801029f1 <iderw+0x91>
801029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e9:	8b 00                	mov    (%eax),%eax
801029eb:	83 c0 58             	add    $0x58,%eax
801029ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f4:	8b 00                	mov    (%eax),%eax
801029f6:	85 c0                	test   %eax,%eax
801029f8:	75 ec                	jne    801029e6 <iderw+0x86>
    ;
  *pp = b;
801029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102a00:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102a02:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a07:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a0a:	75 23                	jne    80102a2f <iderw+0xcf>
    idestart(b);
80102a0c:	83 ec 0c             	sub    $0xc,%esp
80102a0f:	ff 75 08             	pushl  0x8(%ebp)
80102a12:	e8 e2 fc ff ff       	call   801026f9 <idestart>
80102a17:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a1a:	eb 13                	jmp    80102a2f <iderw+0xcf>
    sleep(b, &idelock);
80102a1c:	83 ec 08             	sub    $0x8,%esp
80102a1f:	68 20 c6 10 80       	push   $0x8010c620
80102a24:	ff 75 08             	pushl  0x8(%ebp)
80102a27:	e8 ef 24 00 00       	call   80104f1b <sleep>
80102a2c:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a32:	8b 00                	mov    (%eax),%eax
80102a34:	83 e0 06             	and    $0x6,%eax
80102a37:	83 f8 02             	cmp    $0x2,%eax
80102a3a:	75 e0                	jne    80102a1c <iderw+0xbc>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a3c:	83 ec 0c             	sub    $0xc,%esp
80102a3f:	68 20 c6 10 80       	push   $0x8010c620
80102a44:	e8 cf 29 00 00       	call   80105418 <release>
80102a49:	83 c4 10             	add    $0x10,%esp
}
80102a4c:	90                   	nop
80102a4d:	c9                   	leave  
80102a4e:	c3                   	ret    

80102a4f <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a4f:	55                   	push   %ebp
80102a50:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a52:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a57:	8b 55 08             	mov    0x8(%ebp),%edx
80102a5a:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a5c:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a61:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a64:	5d                   	pop    %ebp
80102a65:	c3                   	ret    

80102a66 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a66:	55                   	push   %ebp
80102a67:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a69:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a6e:	8b 55 08             	mov    0x8(%ebp),%edx
80102a71:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a73:	a1 f4 46 11 80       	mov    0x801146f4,%eax
80102a78:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a7b:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a7e:	90                   	nop
80102a7f:	5d                   	pop    %ebp
80102a80:	c3                   	ret    

80102a81 <ioapicinit>:

void
ioapicinit(void)
{
80102a81:	55                   	push   %ebp
80102a82:	89 e5                	mov    %esp,%ebp
80102a84:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a87:	a1 24 48 11 80       	mov    0x80114824,%eax
80102a8c:	85 c0                	test   %eax,%eax
80102a8e:	0f 84 a0 00 00 00    	je     80102b34 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a94:	c7 05 f4 46 11 80 00 	movl   $0xfec00000,0x801146f4
80102a9b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a9e:	6a 01                	push   $0x1
80102aa0:	e8 aa ff ff ff       	call   80102a4f <ioapicread>
80102aa5:	83 c4 04             	add    $0x4,%esp
80102aa8:	c1 e8 10             	shr    $0x10,%eax
80102aab:	25 ff 00 00 00       	and    $0xff,%eax
80102ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102ab3:	6a 00                	push   $0x0
80102ab5:	e8 95 ff ff ff       	call   80102a4f <ioapicread>
80102aba:	83 c4 04             	add    $0x4,%esp
80102abd:	c1 e8 18             	shr    $0x18,%eax
80102ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102ac3:	0f b6 05 20 48 11 80 	movzbl 0x80114820,%eax
80102aca:	0f b6 c0             	movzbl %al,%eax
80102acd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102ad0:	74 10                	je     80102ae2 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ad2:	83 ec 0c             	sub    $0xc,%esp
80102ad5:	68 80 8b 10 80       	push   $0x80108b80
80102ada:	e8 21 d9 ff ff       	call   80100400 <cprintf>
80102adf:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102ae9:	eb 3f                	jmp    80102b2a <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aee:	83 c0 20             	add    $0x20,%eax
80102af1:	0d 00 00 01 00       	or     $0x10000,%eax
80102af6:	89 c2                	mov    %eax,%edx
80102af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afb:	83 c0 08             	add    $0x8,%eax
80102afe:	01 c0                	add    %eax,%eax
80102b00:	83 ec 08             	sub    $0x8,%esp
80102b03:	52                   	push   %edx
80102b04:	50                   	push   %eax
80102b05:	e8 5c ff ff ff       	call   80102a66 <ioapicwrite>
80102b0a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b10:	83 c0 08             	add    $0x8,%eax
80102b13:	01 c0                	add    %eax,%eax
80102b15:	83 c0 01             	add    $0x1,%eax
80102b18:	83 ec 08             	sub    $0x8,%esp
80102b1b:	6a 00                	push   $0x0
80102b1d:	50                   	push   %eax
80102b1e:	e8 43 ff ff ff       	call   80102a66 <ioapicwrite>
80102b23:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b30:	7e b9                	jle    80102aeb <ioapicinit+0x6a>
80102b32:	eb 01                	jmp    80102b35 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b34:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b35:	c9                   	leave  
80102b36:	c3                   	ret    

80102b37 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b37:	55                   	push   %ebp
80102b38:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b3a:	a1 24 48 11 80       	mov    0x80114824,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	74 39                	je     80102b7c <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b43:	8b 45 08             	mov    0x8(%ebp),%eax
80102b46:	83 c0 20             	add    $0x20,%eax
80102b49:	89 c2                	mov    %eax,%edx
80102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4e:	83 c0 08             	add    $0x8,%eax
80102b51:	01 c0                	add    %eax,%eax
80102b53:	52                   	push   %edx
80102b54:	50                   	push   %eax
80102b55:	e8 0c ff ff ff       	call   80102a66 <ioapicwrite>
80102b5a:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b60:	c1 e0 18             	shl    $0x18,%eax
80102b63:	89 c2                	mov    %eax,%edx
80102b65:	8b 45 08             	mov    0x8(%ebp),%eax
80102b68:	83 c0 08             	add    $0x8,%eax
80102b6b:	01 c0                	add    %eax,%eax
80102b6d:	83 c0 01             	add    $0x1,%eax
80102b70:	52                   	push   %edx
80102b71:	50                   	push   %eax
80102b72:	e8 ef fe ff ff       	call   80102a66 <ioapicwrite>
80102b77:	83 c4 08             	add    $0x8,%esp
80102b7a:	eb 01                	jmp    80102b7d <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102b7c:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    

80102b7f <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
80102b82:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b85:	83 ec 08             	sub    $0x8,%esp
80102b88:	68 b2 8b 10 80       	push   $0x80108bb2
80102b8d:	68 00 47 11 80       	push   $0x80114700
80102b92:	e8 f3 27 00 00       	call   8010538a <initlock>
80102b97:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b9a:	c7 05 34 47 11 80 00 	movl   $0x0,0x80114734
80102ba1:	00 00 00 
  freerange(vstart, vend);
80102ba4:	83 ec 08             	sub    $0x8,%esp
80102ba7:	ff 75 0c             	pushl  0xc(%ebp)
80102baa:	ff 75 08             	pushl  0x8(%ebp)
80102bad:	e8 2a 00 00 00       	call   80102bdc <freerange>
80102bb2:	83 c4 10             	add    $0x10,%esp
}
80102bb5:	90                   	nop
80102bb6:	c9                   	leave  
80102bb7:	c3                   	ret    

80102bb8 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102bb8:	55                   	push   %ebp
80102bb9:	89 e5                	mov    %esp,%ebp
80102bbb:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102bbe:	83 ec 08             	sub    $0x8,%esp
80102bc1:	ff 75 0c             	pushl  0xc(%ebp)
80102bc4:	ff 75 08             	pushl  0x8(%ebp)
80102bc7:	e8 10 00 00 00       	call   80102bdc <freerange>
80102bcc:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102bcf:	c7 05 34 47 11 80 01 	movl   $0x1,0x80114734
80102bd6:	00 00 00 
}
80102bd9:	90                   	nop
80102bda:	c9                   	leave  
80102bdb:	c3                   	ret    

80102bdc <freerange>:

void
freerange(void *vstart, void *vend)
{
80102bdc:	55                   	push   %ebp
80102bdd:	89 e5                	mov    %esp,%ebp
80102bdf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102be2:	8b 45 08             	mov    0x8(%ebp),%eax
80102be5:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf2:	eb 15                	jmp    80102c09 <freerange+0x2d>
    kfree(p);
80102bf4:	83 ec 0c             	sub    $0xc,%esp
80102bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80102bfa:	e8 1a 00 00 00       	call   80102c19 <kfree>
80102bff:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c02:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c0c:	05 00 10 00 00       	add    $0x1000,%eax
80102c11:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c14:	76 de                	jbe    80102bf4 <freerange+0x18>
    kfree(p);
}
80102c16:	90                   	nop
80102c17:	c9                   	leave  
80102c18:	c3                   	ret    

80102c19 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c19:	55                   	push   %ebp
80102c1a:	89 e5                	mov    %esp,%ebp
80102c1c:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c22:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c27:	85 c0                	test   %eax,%eax
80102c29:	75 18                	jne    80102c43 <kfree+0x2a>
80102c2b:	81 7d 08 c8 7d 11 80 	cmpl   $0x80117dc8,0x8(%ebp)
80102c32:	72 0f                	jb     80102c43 <kfree+0x2a>
80102c34:	8b 45 08             	mov    0x8(%ebp),%eax
80102c37:	05 00 00 00 80       	add    $0x80000000,%eax
80102c3c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c41:	76 0d                	jbe    80102c50 <kfree+0x37>
    panic("kfree");
80102c43:	83 ec 0c             	sub    $0xc,%esp
80102c46:	68 b7 8b 10 80       	push   $0x80108bb7
80102c4b:	e8 50 d9 ff ff       	call   801005a0 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c50:	83 ec 04             	sub    $0x4,%esp
80102c53:	68 00 10 00 00       	push   $0x1000
80102c58:	6a 01                	push   $0x1
80102c5a:	ff 75 08             	pushl  0x8(%ebp)
80102c5d:	e8 c4 29 00 00       	call   80105626 <memset>
80102c62:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c65:	a1 34 47 11 80       	mov    0x80114734,%eax
80102c6a:	85 c0                	test   %eax,%eax
80102c6c:	74 10                	je     80102c7e <kfree+0x65>
    acquire(&kmem.lock);
80102c6e:	83 ec 0c             	sub    $0xc,%esp
80102c71:	68 00 47 11 80       	push   $0x80114700
80102c76:	e8 31 27 00 00       	call   801053ac <acquire>
80102c7b:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c84:	8b 15 38 47 11 80    	mov    0x80114738,%edx
80102c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8d:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c92:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102c97:	a1 34 47 11 80       	mov    0x80114734,%eax
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	74 10                	je     80102cb0 <kfree+0x97>
    release(&kmem.lock);
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 00 47 11 80       	push   $0x80114700
80102ca8:	e8 6b 27 00 00       	call   80105418 <release>
80102cad:	83 c4 10             	add    $0x10,%esp
}
80102cb0:	90                   	nop
80102cb1:	c9                   	leave  
80102cb2:	c3                   	ret    

80102cb3 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102cb3:	55                   	push   %ebp
80102cb4:	89 e5                	mov    %esp,%ebp
80102cb6:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102cb9:	a1 34 47 11 80       	mov    0x80114734,%eax
80102cbe:	85 c0                	test   %eax,%eax
80102cc0:	74 10                	je     80102cd2 <kalloc+0x1f>
    acquire(&kmem.lock);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	68 00 47 11 80       	push   $0x80114700
80102cca:	e8 dd 26 00 00       	call   801053ac <acquire>
80102ccf:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102cd2:	a1 38 47 11 80       	mov    0x80114738,%eax
80102cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cde:	74 0a                	je     80102cea <kalloc+0x37>
    kmem.freelist = r->next;
80102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce3:	8b 00                	mov    (%eax),%eax
80102ce5:	a3 38 47 11 80       	mov    %eax,0x80114738
  if(kmem.use_lock)
80102cea:	a1 34 47 11 80       	mov    0x80114734,%eax
80102cef:	85 c0                	test   %eax,%eax
80102cf1:	74 10                	je     80102d03 <kalloc+0x50>
    release(&kmem.lock);
80102cf3:	83 ec 0c             	sub    $0xc,%esp
80102cf6:	68 00 47 11 80       	push   $0x80114700
80102cfb:	e8 18 27 00 00       	call   80105418 <release>
80102d00:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d06:	c9                   	leave  
80102d07:	c3                   	ret    

80102d08 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102d08:	55                   	push   %ebp
80102d09:	89 e5                	mov    %esp,%ebp
80102d0b:	83 ec 14             	sub    $0x14,%esp
80102d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d11:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d15:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d19:	89 c2                	mov    %eax,%edx
80102d1b:	ec                   	in     (%dx),%al
80102d1c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d1f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d23:	c9                   	leave  
80102d24:	c3                   	ret    

80102d25 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d25:	55                   	push   %ebp
80102d26:	89 e5                	mov    %esp,%ebp
80102d28:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d2b:	6a 64                	push   $0x64
80102d2d:	e8 d6 ff ff ff       	call   80102d08 <inb>
80102d32:	83 c4 04             	add    $0x4,%esp
80102d35:	0f b6 c0             	movzbl %al,%eax
80102d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3e:	83 e0 01             	and    $0x1,%eax
80102d41:	85 c0                	test   %eax,%eax
80102d43:	75 0a                	jne    80102d4f <kbdgetc+0x2a>
    return -1;
80102d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d4a:	e9 23 01 00 00       	jmp    80102e72 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d4f:	6a 60                	push   $0x60
80102d51:	e8 b2 ff ff ff       	call   80102d08 <inb>
80102d56:	83 c4 04             	add    $0x4,%esp
80102d59:	0f b6 c0             	movzbl %al,%eax
80102d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d5f:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d66:	75 17                	jne    80102d7f <kbdgetc+0x5a>
    shift |= E0ESC;
80102d68:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d6d:	83 c8 40             	or     $0x40,%eax
80102d70:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102d75:	b8 00 00 00 00       	mov    $0x0,%eax
80102d7a:	e9 f3 00 00 00       	jmp    80102e72 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d82:	25 80 00 00 00       	and    $0x80,%eax
80102d87:	85 c0                	test   %eax,%eax
80102d89:	74 45                	je     80102dd0 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d8b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102d90:	83 e0 40             	and    $0x40,%eax
80102d93:	85 c0                	test   %eax,%eax
80102d95:	75 08                	jne    80102d9f <kbdgetc+0x7a>
80102d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d9a:	83 e0 7f             	and    $0x7f,%eax
80102d9d:	eb 03                	jmp    80102da2 <kbdgetc+0x7d>
80102d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102da5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102da8:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102dad:	0f b6 00             	movzbl (%eax),%eax
80102db0:	83 c8 40             	or     $0x40,%eax
80102db3:	0f b6 c0             	movzbl %al,%eax
80102db6:	f7 d0                	not    %eax
80102db8:	89 c2                	mov    %eax,%edx
80102dba:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dbf:	21 d0                	and    %edx,%eax
80102dc1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102dc6:	b8 00 00 00 00       	mov    $0x0,%eax
80102dcb:	e9 a2 00 00 00       	jmp    80102e72 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102dd0:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dd5:	83 e0 40             	and    $0x40,%eax
80102dd8:	85 c0                	test   %eax,%eax
80102dda:	74 14                	je     80102df0 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ddc:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102de3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102de8:	83 e0 bf             	and    $0xffffffbf,%eax
80102deb:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df3:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102df8:	0f b6 00             	movzbl (%eax),%eax
80102dfb:	0f b6 d0             	movzbl %al,%edx
80102dfe:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e03:	09 d0                	or     %edx,%eax
80102e05:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e0d:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e12:	0f b6 00             	movzbl (%eax),%eax
80102e15:	0f b6 d0             	movzbl %al,%edx
80102e18:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e1d:	31 d0                	xor    %edx,%eax
80102e1f:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e24:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e29:	83 e0 03             	and    $0x3,%eax
80102e2c:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e36:	01 d0                	add    %edx,%eax
80102e38:	0f b6 00             	movzbl (%eax),%eax
80102e3b:	0f b6 c0             	movzbl %al,%eax
80102e3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e41:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e46:	83 e0 08             	and    $0x8,%eax
80102e49:	85 c0                	test   %eax,%eax
80102e4b:	74 22                	je     80102e6f <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e4d:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e51:	76 0c                	jbe    80102e5f <kbdgetc+0x13a>
80102e53:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e57:	77 06                	ja     80102e5f <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e59:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e5d:	eb 10                	jmp    80102e6f <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e5f:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e63:	76 0a                	jbe    80102e6f <kbdgetc+0x14a>
80102e65:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e69:	77 04                	ja     80102e6f <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e6b:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e72:	c9                   	leave  
80102e73:	c3                   	ret    

80102e74 <kbdintr>:

void
kbdintr(void)
{
80102e74:	55                   	push   %ebp
80102e75:	89 e5                	mov    %esp,%ebp
80102e77:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e7a:	83 ec 0c             	sub    $0xc,%esp
80102e7d:	68 25 2d 10 80       	push   $0x80102d25
80102e82:	e8 ac d9 ff ff       	call   80100833 <consoleintr>
80102e87:	83 c4 10             	add    $0x10,%esp
}
80102e8a:	90                   	nop
80102e8b:	c9                   	leave  
80102e8c:	c3                   	ret    

80102e8d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e8d:	55                   	push   %ebp
80102e8e:	89 e5                	mov    %esp,%ebp
80102e90:	83 ec 14             	sub    $0x14,%esp
80102e93:	8b 45 08             	mov    0x8(%ebp),%eax
80102e96:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e9e:	89 c2                	mov    %eax,%edx
80102ea0:	ec                   	in     (%dx),%al
80102ea1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ea4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ea8:	c9                   	leave  
80102ea9:	c3                   	ret    

80102eaa <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	83 ec 08             	sub    $0x8,%esp
80102eb0:	8b 55 08             	mov    0x8(%ebp),%edx
80102eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eb6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102eba:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ec1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ec5:	ee                   	out    %al,(%dx)
}
80102ec6:	90                   	nop
80102ec7:	c9                   	leave  
80102ec8:	c3                   	ret    

80102ec9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102ec9:	55                   	push   %ebp
80102eca:	89 e5                	mov    %esp,%ebp
80102ecc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102ecf:	9c                   	pushf  
80102ed0:	58                   	pop    %eax
80102ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ed7:	c9                   	leave  
80102ed8:	c3                   	ret    

80102ed9 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102ed9:	55                   	push   %ebp
80102eda:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102edc:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102ee1:	8b 55 08             	mov    0x8(%ebp),%edx
80102ee4:	c1 e2 02             	shl    $0x2,%edx
80102ee7:	01 c2                	add    %eax,%edx
80102ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
80102eec:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102eee:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102ef3:	83 c0 20             	add    $0x20,%eax
80102ef6:	8b 00                	mov    (%eax),%eax
}
80102ef8:	90                   	nop
80102ef9:	5d                   	pop    %ebp
80102efa:	c3                   	ret    

80102efb <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102efb:	55                   	push   %ebp
80102efc:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102efe:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102f03:	85 c0                	test   %eax,%eax
80102f05:	0f 84 0b 01 00 00    	je     80103016 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f0b:	68 3f 01 00 00       	push   $0x13f
80102f10:	6a 3c                	push   $0x3c
80102f12:	e8 c2 ff ff ff       	call   80102ed9 <lapicw>
80102f17:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f1a:	6a 0b                	push   $0xb
80102f1c:	68 f8 00 00 00       	push   $0xf8
80102f21:	e8 b3 ff ff ff       	call   80102ed9 <lapicw>
80102f26:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f29:	68 20 00 02 00       	push   $0x20020
80102f2e:	68 c8 00 00 00       	push   $0xc8
80102f33:	e8 a1 ff ff ff       	call   80102ed9 <lapicw>
80102f38:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102f3b:	68 80 96 98 00       	push   $0x989680
80102f40:	68 e0 00 00 00       	push   $0xe0
80102f45:	e8 8f ff ff ff       	call   80102ed9 <lapicw>
80102f4a:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f4d:	68 00 00 01 00       	push   $0x10000
80102f52:	68 d4 00 00 00       	push   $0xd4
80102f57:	e8 7d ff ff ff       	call   80102ed9 <lapicw>
80102f5c:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f5f:	68 00 00 01 00       	push   $0x10000
80102f64:	68 d8 00 00 00       	push   $0xd8
80102f69:	e8 6b ff ff ff       	call   80102ed9 <lapicw>
80102f6e:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f71:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102f76:	83 c0 30             	add    $0x30,%eax
80102f79:	8b 00                	mov    (%eax),%eax
80102f7b:	c1 e8 10             	shr    $0x10,%eax
80102f7e:	0f b6 c0             	movzbl %al,%eax
80102f81:	83 f8 03             	cmp    $0x3,%eax
80102f84:	76 12                	jbe    80102f98 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102f86:	68 00 00 01 00       	push   $0x10000
80102f8b:	68 d0 00 00 00       	push   $0xd0
80102f90:	e8 44 ff ff ff       	call   80102ed9 <lapicw>
80102f95:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f98:	6a 33                	push   $0x33
80102f9a:	68 dc 00 00 00       	push   $0xdc
80102f9f:	e8 35 ff ff ff       	call   80102ed9 <lapicw>
80102fa4:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102fa7:	6a 00                	push   $0x0
80102fa9:	68 a0 00 00 00       	push   $0xa0
80102fae:	e8 26 ff ff ff       	call   80102ed9 <lapicw>
80102fb3:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102fb6:	6a 00                	push   $0x0
80102fb8:	68 a0 00 00 00       	push   $0xa0
80102fbd:	e8 17 ff ff ff       	call   80102ed9 <lapicw>
80102fc2:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fc5:	6a 00                	push   $0x0
80102fc7:	6a 2c                	push   $0x2c
80102fc9:	e8 0b ff ff ff       	call   80102ed9 <lapicw>
80102fce:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fd1:	6a 00                	push   $0x0
80102fd3:	68 c4 00 00 00       	push   $0xc4
80102fd8:	e8 fc fe ff ff       	call   80102ed9 <lapicw>
80102fdd:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fe0:	68 00 85 08 00       	push   $0x88500
80102fe5:	68 c0 00 00 00       	push   $0xc0
80102fea:	e8 ea fe ff ff       	call   80102ed9 <lapicw>
80102fef:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ff2:	90                   	nop
80102ff3:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80102ff8:	05 00 03 00 00       	add    $0x300,%eax
80102ffd:	8b 00                	mov    (%eax),%eax
80102fff:	25 00 10 00 00       	and    $0x1000,%eax
80103004:	85 c0                	test   %eax,%eax
80103006:	75 eb                	jne    80102ff3 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103008:	6a 00                	push   $0x0
8010300a:	6a 20                	push   $0x20
8010300c:	e8 c8 fe ff ff       	call   80102ed9 <lapicw>
80103011:	83 c4 08             	add    $0x8,%esp
80103014:	eb 01                	jmp    80103017 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic)
    return;
80103016:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103017:	c9                   	leave  
80103018:	c3                   	ret    

80103019 <cpunum>:

int
cpunum(void)
{
80103019:	55                   	push   %ebp
8010301a:	89 e5                	mov    %esp,%ebp
8010301c:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010301f:	e8 a5 fe ff ff       	call   80102ec9 <readeflags>
80103024:	25 00 02 00 00       	and    $0x200,%eax
80103029:	85 c0                	test   %eax,%eax
8010302b:	74 26                	je     80103053 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010302d:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80103032:	8d 50 01             	lea    0x1(%eax),%edx
80103035:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
8010303b:	85 c0                	test   %eax,%eax
8010303d:	75 14                	jne    80103053 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010303f:	8b 45 04             	mov    0x4(%ebp),%eax
80103042:	83 ec 08             	sub    $0x8,%esp
80103045:	50                   	push   %eax
80103046:	68 c0 8b 10 80       	push   $0x80108bc0
8010304b:	e8 b0 d3 ff ff       	call   80100400 <cprintf>
80103050:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80103053:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103058:	85 c0                	test   %eax,%eax
8010305a:	75 07                	jne    80103063 <cpunum+0x4a>
    return 0;
8010305c:	b8 00 00 00 00       	mov    $0x0,%eax
80103061:	eb 52                	jmp    801030b5 <cpunum+0x9c>

  apicid = lapic[ID] >> 24;
80103063:	a1 3c 47 11 80       	mov    0x8011473c,%eax
80103068:	83 c0 20             	add    $0x20,%eax
8010306b:	8b 00                	mov    (%eax),%eax
8010306d:	c1 e8 18             	shr    $0x18,%eax
80103070:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < ncpu; ++i) {
80103073:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010307a:	eb 22                	jmp    8010309e <cpunum+0x85>
    if (cpus[i].apicid == apicid)
8010307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010307f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103085:	05 40 48 11 80       	add    $0x80114840,%eax
8010308a:	0f b6 00             	movzbl (%eax),%eax
8010308d:	0f b6 c0             	movzbl %al,%eax
80103090:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103093:	75 05                	jne    8010309a <cpunum+0x81>
      return i;
80103095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103098:	eb 1b                	jmp    801030b5 <cpunum+0x9c>

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010309a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010309e:	a1 20 4e 11 80       	mov    0x80114e20,%eax
801030a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801030a6:	7c d4                	jl     8010307c <cpunum+0x63>
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801030a8:	83 ec 0c             	sub    $0xc,%esp
801030ab:	68 ec 8b 10 80       	push   $0x80108bec
801030b0:	e8 eb d4 ff ff       	call   801005a0 <panic>
}
801030b5:	c9                   	leave  
801030b6:	c3                   	ret    

801030b7 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030b7:	55                   	push   %ebp
801030b8:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030ba:	a1 3c 47 11 80       	mov    0x8011473c,%eax
801030bf:	85 c0                	test   %eax,%eax
801030c1:	74 0c                	je     801030cf <lapiceoi+0x18>
    lapicw(EOI, 0);
801030c3:	6a 00                	push   $0x0
801030c5:	6a 2c                	push   $0x2c
801030c7:	e8 0d fe ff ff       	call   80102ed9 <lapicw>
801030cc:	83 c4 08             	add    $0x8,%esp
}
801030cf:	90                   	nop
801030d0:	c9                   	leave  
801030d1:	c3                   	ret    

801030d2 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030d2:	55                   	push   %ebp
801030d3:	89 e5                	mov    %esp,%ebp
}
801030d5:	90                   	nop
801030d6:	5d                   	pop    %ebp
801030d7:	c3                   	ret    

801030d8 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030d8:	55                   	push   %ebp
801030d9:	89 e5                	mov    %esp,%ebp
801030db:	83 ec 14             	sub    $0x14,%esp
801030de:	8b 45 08             	mov    0x8(%ebp),%eax
801030e1:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030e4:	6a 0f                	push   $0xf
801030e6:	6a 70                	push   $0x70
801030e8:	e8 bd fd ff ff       	call   80102eaa <outb>
801030ed:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030f0:	6a 0a                	push   $0xa
801030f2:	6a 71                	push   $0x71
801030f4:	e8 b1 fd ff ff       	call   80102eaa <outb>
801030f9:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030fc:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103103:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103106:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010310b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010310e:	83 c0 02             	add    $0x2,%eax
80103111:	8b 55 0c             	mov    0xc(%ebp),%edx
80103114:	c1 ea 04             	shr    $0x4,%edx
80103117:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010311a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010311e:	c1 e0 18             	shl    $0x18,%eax
80103121:	50                   	push   %eax
80103122:	68 c4 00 00 00       	push   $0xc4
80103127:	e8 ad fd ff ff       	call   80102ed9 <lapicw>
8010312c:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010312f:	68 00 c5 00 00       	push   $0xc500
80103134:	68 c0 00 00 00       	push   $0xc0
80103139:	e8 9b fd ff ff       	call   80102ed9 <lapicw>
8010313e:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103141:	68 c8 00 00 00       	push   $0xc8
80103146:	e8 87 ff ff ff       	call   801030d2 <microdelay>
8010314b:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010314e:	68 00 85 00 00       	push   $0x8500
80103153:	68 c0 00 00 00       	push   $0xc0
80103158:	e8 7c fd ff ff       	call   80102ed9 <lapicw>
8010315d:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103160:	6a 64                	push   $0x64
80103162:	e8 6b ff ff ff       	call   801030d2 <microdelay>
80103167:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010316a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103171:	eb 3d                	jmp    801031b0 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103173:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103177:	c1 e0 18             	shl    $0x18,%eax
8010317a:	50                   	push   %eax
8010317b:	68 c4 00 00 00       	push   $0xc4
80103180:	e8 54 fd ff ff       	call   80102ed9 <lapicw>
80103185:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103188:	8b 45 0c             	mov    0xc(%ebp),%eax
8010318b:	c1 e8 0c             	shr    $0xc,%eax
8010318e:	80 cc 06             	or     $0x6,%ah
80103191:	50                   	push   %eax
80103192:	68 c0 00 00 00       	push   $0xc0
80103197:	e8 3d fd ff ff       	call   80102ed9 <lapicw>
8010319c:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010319f:	68 c8 00 00 00       	push   $0xc8
801031a4:	e8 29 ff ff ff       	call   801030d2 <microdelay>
801031a9:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031b0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031b4:	7e bd                	jle    80103173 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031b6:	90                   	nop
801031b7:	c9                   	leave  
801031b8:	c3                   	ret    

801031b9 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031b9:	55                   	push   %ebp
801031ba:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031bc:	8b 45 08             	mov    0x8(%ebp),%eax
801031bf:	0f b6 c0             	movzbl %al,%eax
801031c2:	50                   	push   %eax
801031c3:	6a 70                	push   $0x70
801031c5:	e8 e0 fc ff ff       	call   80102eaa <outb>
801031ca:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031cd:	68 c8 00 00 00       	push   $0xc8
801031d2:	e8 fb fe ff ff       	call   801030d2 <microdelay>
801031d7:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031da:	6a 71                	push   $0x71
801031dc:	e8 ac fc ff ff       	call   80102e8d <inb>
801031e1:	83 c4 04             	add    $0x4,%esp
801031e4:	0f b6 c0             	movzbl %al,%eax
}
801031e7:	c9                   	leave  
801031e8:	c3                   	ret    

801031e9 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031e9:	55                   	push   %ebp
801031ea:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031ec:	6a 00                	push   $0x0
801031ee:	e8 c6 ff ff ff       	call   801031b9 <cmos_read>
801031f3:	83 c4 04             	add    $0x4,%esp
801031f6:	89 c2                	mov    %eax,%edx
801031f8:	8b 45 08             	mov    0x8(%ebp),%eax
801031fb:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801031fd:	6a 02                	push   $0x2
801031ff:	e8 b5 ff ff ff       	call   801031b9 <cmos_read>
80103204:	83 c4 04             	add    $0x4,%esp
80103207:	89 c2                	mov    %eax,%edx
80103209:	8b 45 08             	mov    0x8(%ebp),%eax
8010320c:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010320f:	6a 04                	push   $0x4
80103211:	e8 a3 ff ff ff       	call   801031b9 <cmos_read>
80103216:	83 c4 04             	add    $0x4,%esp
80103219:	89 c2                	mov    %eax,%edx
8010321b:	8b 45 08             	mov    0x8(%ebp),%eax
8010321e:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103221:	6a 07                	push   $0x7
80103223:	e8 91 ff ff ff       	call   801031b9 <cmos_read>
80103228:	83 c4 04             	add    $0x4,%esp
8010322b:	89 c2                	mov    %eax,%edx
8010322d:	8b 45 08             	mov    0x8(%ebp),%eax
80103230:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103233:	6a 08                	push   $0x8
80103235:	e8 7f ff ff ff       	call   801031b9 <cmos_read>
8010323a:	83 c4 04             	add    $0x4,%esp
8010323d:	89 c2                	mov    %eax,%edx
8010323f:	8b 45 08             	mov    0x8(%ebp),%eax
80103242:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103245:	6a 09                	push   $0x9
80103247:	e8 6d ff ff ff       	call   801031b9 <cmos_read>
8010324c:	83 c4 04             	add    $0x4,%esp
8010324f:	89 c2                	mov    %eax,%edx
80103251:	8b 45 08             	mov    0x8(%ebp),%eax
80103254:	89 50 14             	mov    %edx,0x14(%eax)
}
80103257:	90                   	nop
80103258:	c9                   	leave  
80103259:	c3                   	ret    

8010325a <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010325a:	55                   	push   %ebp
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103260:	6a 0b                	push   $0xb
80103262:	e8 52 ff ff ff       	call   801031b9 <cmos_read>
80103267:	83 c4 04             	add    $0x4,%esp
8010326a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103270:	83 e0 04             	and    $0x4,%eax
80103273:	85 c0                	test   %eax,%eax
80103275:	0f 94 c0             	sete   %al
80103278:	0f b6 c0             	movzbl %al,%eax
8010327b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010327e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103281:	50                   	push   %eax
80103282:	e8 62 ff ff ff       	call   801031e9 <fill_rtcdate>
80103287:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010328a:	6a 0a                	push   $0xa
8010328c:	e8 28 ff ff ff       	call   801031b9 <cmos_read>
80103291:	83 c4 04             	add    $0x4,%esp
80103294:	25 80 00 00 00       	and    $0x80,%eax
80103299:	85 c0                	test   %eax,%eax
8010329b:	75 27                	jne    801032c4 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010329d:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032a0:	50                   	push   %eax
801032a1:	e8 43 ff ff ff       	call   801031e9 <fill_rtcdate>
801032a6:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032a9:	83 ec 04             	sub    $0x4,%esp
801032ac:	6a 18                	push   $0x18
801032ae:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032b1:	50                   	push   %eax
801032b2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032b5:	50                   	push   %eax
801032b6:	e8 d2 23 00 00       	call   8010568d <memcmp>
801032bb:	83 c4 10             	add    $0x10,%esp
801032be:	85 c0                	test   %eax,%eax
801032c0:	74 05                	je     801032c7 <cmostime+0x6d>
801032c2:	eb ba                	jmp    8010327e <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032c4:	90                   	nop
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032c5:	eb b7                	jmp    8010327e <cmostime+0x24>
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032c7:	90                   	nop
  }

  // convert
  if(bcd) {
801032c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032cc:	0f 84 b4 00 00 00    	je     80103386 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032d5:	c1 e8 04             	shr    $0x4,%eax
801032d8:	89 c2                	mov    %eax,%edx
801032da:	89 d0                	mov    %edx,%eax
801032dc:	c1 e0 02             	shl    $0x2,%eax
801032df:	01 d0                	add    %edx,%eax
801032e1:	01 c0                	add    %eax,%eax
801032e3:	89 c2                	mov    %eax,%edx
801032e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032e8:	83 e0 0f             	and    $0xf,%eax
801032eb:	01 d0                	add    %edx,%eax
801032ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032f3:	c1 e8 04             	shr    $0x4,%eax
801032f6:	89 c2                	mov    %eax,%edx
801032f8:	89 d0                	mov    %edx,%eax
801032fa:	c1 e0 02             	shl    $0x2,%eax
801032fd:	01 d0                	add    %edx,%eax
801032ff:	01 c0                	add    %eax,%eax
80103301:	89 c2                	mov    %eax,%edx
80103303:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103306:	83 e0 0f             	and    $0xf,%eax
80103309:	01 d0                	add    %edx,%eax
8010330b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010330e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103311:	c1 e8 04             	shr    $0x4,%eax
80103314:	89 c2                	mov    %eax,%edx
80103316:	89 d0                	mov    %edx,%eax
80103318:	c1 e0 02             	shl    $0x2,%eax
8010331b:	01 d0                	add    %edx,%eax
8010331d:	01 c0                	add    %eax,%eax
8010331f:	89 c2                	mov    %eax,%edx
80103321:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103324:	83 e0 0f             	and    $0xf,%eax
80103327:	01 d0                	add    %edx,%eax
80103329:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010332f:	c1 e8 04             	shr    $0x4,%eax
80103332:	89 c2                	mov    %eax,%edx
80103334:	89 d0                	mov    %edx,%eax
80103336:	c1 e0 02             	shl    $0x2,%eax
80103339:	01 d0                	add    %edx,%eax
8010333b:	01 c0                	add    %eax,%eax
8010333d:	89 c2                	mov    %eax,%edx
8010333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103342:	83 e0 0f             	and    $0xf,%eax
80103345:	01 d0                	add    %edx,%eax
80103347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010334d:	c1 e8 04             	shr    $0x4,%eax
80103350:	89 c2                	mov    %eax,%edx
80103352:	89 d0                	mov    %edx,%eax
80103354:	c1 e0 02             	shl    $0x2,%eax
80103357:	01 d0                	add    %edx,%eax
80103359:	01 c0                	add    %eax,%eax
8010335b:	89 c2                	mov    %eax,%edx
8010335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103360:	83 e0 0f             	and    $0xf,%eax
80103363:	01 d0                	add    %edx,%eax
80103365:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103368:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336b:	c1 e8 04             	shr    $0x4,%eax
8010336e:	89 c2                	mov    %eax,%edx
80103370:	89 d0                	mov    %edx,%eax
80103372:	c1 e0 02             	shl    $0x2,%eax
80103375:	01 d0                	add    %edx,%eax
80103377:	01 c0                	add    %eax,%eax
80103379:	89 c2                	mov    %eax,%edx
8010337b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337e:	83 e0 0f             	and    $0xf,%eax
80103381:	01 d0                	add    %edx,%eax
80103383:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103386:	8b 45 08             	mov    0x8(%ebp),%eax
80103389:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010338c:	89 10                	mov    %edx,(%eax)
8010338e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103391:	89 50 04             	mov    %edx,0x4(%eax)
80103394:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103397:	89 50 08             	mov    %edx,0x8(%eax)
8010339a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010339d:	89 50 0c             	mov    %edx,0xc(%eax)
801033a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033a3:	89 50 10             	mov    %edx,0x10(%eax)
801033a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033a9:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033ac:	8b 45 08             	mov    0x8(%ebp),%eax
801033af:	8b 40 14             	mov    0x14(%eax),%eax
801033b2:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033b8:	8b 45 08             	mov    0x8(%ebp),%eax
801033bb:	89 50 14             	mov    %edx,0x14(%eax)
}
801033be:	90                   	nop
801033bf:	c9                   	leave  
801033c0:	c3                   	ret    

801033c1 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033c1:	55                   	push   %ebp
801033c2:	89 e5                	mov    %esp,%ebp
801033c4:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033c7:	83 ec 08             	sub    $0x8,%esp
801033ca:	68 fc 8b 10 80       	push   $0x80108bfc
801033cf:	68 40 47 11 80       	push   $0x80114740
801033d4:	e8 b1 1f 00 00       	call   8010538a <initlock>
801033d9:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033dc:	83 ec 08             	sub    $0x8,%esp
801033df:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033e2:	50                   	push   %eax
801033e3:	ff 75 08             	pushl  0x8(%ebp)
801033e6:	e8 0a e0 ff ff       	call   801013f5 <readsb>
801033eb:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033f1:	a3 74 47 11 80       	mov    %eax,0x80114774
  log.size = sb.nlog;
801033f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033f9:	a3 78 47 11 80       	mov    %eax,0x80114778
  log.dev = dev;
801033fe:	8b 45 08             	mov    0x8(%ebp),%eax
80103401:	a3 84 47 11 80       	mov    %eax,0x80114784
  recover_from_log();
80103406:	e8 b2 01 00 00       	call   801035bd <recover_from_log>
}
8010340b:	90                   	nop
8010340c:	c9                   	leave  
8010340d:	c3                   	ret    

8010340e <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010340e:	55                   	push   %ebp
8010340f:	89 e5                	mov    %esp,%ebp
80103411:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010341b:	e9 95 00 00 00       	jmp    801034b5 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103420:	8b 15 74 47 11 80    	mov    0x80114774,%edx
80103426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103429:	01 d0                	add    %edx,%eax
8010342b:	83 c0 01             	add    $0x1,%eax
8010342e:	89 c2                	mov    %eax,%edx
80103430:	a1 84 47 11 80       	mov    0x80114784,%eax
80103435:	83 ec 08             	sub    $0x8,%esp
80103438:	52                   	push   %edx
80103439:	50                   	push   %eax
8010343a:	e8 8f cd ff ff       	call   801001ce <bread>
8010343f:	83 c4 10             	add    $0x10,%esp
80103442:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103448:	83 c0 10             	add    $0x10,%eax
8010344b:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103452:	89 c2                	mov    %eax,%edx
80103454:	a1 84 47 11 80       	mov    0x80114784,%eax
80103459:	83 ec 08             	sub    $0x8,%esp
8010345c:	52                   	push   %edx
8010345d:	50                   	push   %eax
8010345e:	e8 6b cd ff ff       	call   801001ce <bread>
80103463:	83 c4 10             	add    $0x10,%esp
80103466:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010346c:	8d 50 5c             	lea    0x5c(%eax),%edx
8010346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103472:	83 c0 5c             	add    $0x5c,%eax
80103475:	83 ec 04             	sub    $0x4,%esp
80103478:	68 00 02 00 00       	push   $0x200
8010347d:	52                   	push   %edx
8010347e:	50                   	push   %eax
8010347f:	e8 61 22 00 00       	call   801056e5 <memmove>
80103484:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103487:	83 ec 0c             	sub    $0xc,%esp
8010348a:	ff 75 ec             	pushl  -0x14(%ebp)
8010348d:	e8 75 cd ff ff       	call   80100207 <bwrite>
80103492:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80103495:	83 ec 0c             	sub    $0xc,%esp
80103498:	ff 75 f0             	pushl  -0x10(%ebp)
8010349b:	e8 b0 cd ff ff       	call   80100250 <brelse>
801034a0:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034a3:	83 ec 0c             	sub    $0xc,%esp
801034a6:	ff 75 ec             	pushl  -0x14(%ebp)
801034a9:	e8 a2 cd ff ff       	call   80100250 <brelse>
801034ae:	83 c4 10             	add    $0x10,%esp
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b5:	a1 88 47 11 80       	mov    0x80114788,%eax
801034ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034bd:	0f 8f 5d ff ff ff    	jg     80103420 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801034c3:	90                   	nop
801034c4:	c9                   	leave  
801034c5:	c3                   	ret    

801034c6 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034c6:	55                   	push   %ebp
801034c7:	89 e5                	mov    %esp,%ebp
801034c9:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034cc:	a1 74 47 11 80       	mov    0x80114774,%eax
801034d1:	89 c2                	mov    %eax,%edx
801034d3:	a1 84 47 11 80       	mov    0x80114784,%eax
801034d8:	83 ec 08             	sub    $0x8,%esp
801034db:	52                   	push   %edx
801034dc:	50                   	push   %eax
801034dd:	e8 ec cc ff ff       	call   801001ce <bread>
801034e2:	83 c4 10             	add    $0x10,%esp
801034e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034eb:	83 c0 5c             	add    $0x5c,%eax
801034ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034f4:	8b 00                	mov    (%eax),%eax
801034f6:	a3 88 47 11 80       	mov    %eax,0x80114788
  for (i = 0; i < log.lh.n; i++) {
801034fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103502:	eb 1b                	jmp    8010351f <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010350a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010350e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103511:	83 c2 10             	add    $0x10,%edx
80103514:	89 04 95 4c 47 11 80 	mov    %eax,-0x7feeb8b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010351b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010351f:	a1 88 47 11 80       	mov    0x80114788,%eax
80103524:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103527:	7f db                	jg     80103504 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103529:	83 ec 0c             	sub    $0xc,%esp
8010352c:	ff 75 f0             	pushl  -0x10(%ebp)
8010352f:	e8 1c cd ff ff       	call   80100250 <brelse>
80103534:	83 c4 10             	add    $0x10,%esp
}
80103537:	90                   	nop
80103538:	c9                   	leave  
80103539:	c3                   	ret    

8010353a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010353a:	55                   	push   %ebp
8010353b:	89 e5                	mov    %esp,%ebp
8010353d:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103540:	a1 74 47 11 80       	mov    0x80114774,%eax
80103545:	89 c2                	mov    %eax,%edx
80103547:	a1 84 47 11 80       	mov    0x80114784,%eax
8010354c:	83 ec 08             	sub    $0x8,%esp
8010354f:	52                   	push   %edx
80103550:	50                   	push   %eax
80103551:	e8 78 cc ff ff       	call   801001ce <bread>
80103556:	83 c4 10             	add    $0x10,%esp
80103559:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010355c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010355f:	83 c0 5c             	add    $0x5c,%eax
80103562:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103565:	8b 15 88 47 11 80    	mov    0x80114788,%edx
8010356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010356e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103577:	eb 1b                	jmp    80103594 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010357c:	83 c0 10             	add    $0x10,%eax
8010357f:	8b 0c 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%ecx
80103586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010358c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103590:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103594:	a1 88 47 11 80       	mov    0x80114788,%eax
80103599:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010359c:	7f db                	jg     80103579 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010359e:	83 ec 0c             	sub    $0xc,%esp
801035a1:	ff 75 f0             	pushl  -0x10(%ebp)
801035a4:	e8 5e cc ff ff       	call   80100207 <bwrite>
801035a9:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	ff 75 f0             	pushl  -0x10(%ebp)
801035b2:	e8 99 cc ff ff       	call   80100250 <brelse>
801035b7:	83 c4 10             	add    $0x10,%esp
}
801035ba:	90                   	nop
801035bb:	c9                   	leave  
801035bc:	c3                   	ret    

801035bd <recover_from_log>:

static void
recover_from_log(void)
{
801035bd:	55                   	push   %ebp
801035be:	89 e5                	mov    %esp,%ebp
801035c0:	83 ec 08             	sub    $0x8,%esp
  read_head();
801035c3:	e8 fe fe ff ff       	call   801034c6 <read_head>
  install_trans(); // if committed, copy from log to disk
801035c8:	e8 41 fe ff ff       	call   8010340e <install_trans>
  log.lh.n = 0;
801035cd:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
801035d4:	00 00 00 
  write_head(); // clear the log
801035d7:	e8 5e ff ff ff       	call   8010353a <write_head>
}
801035dc:	90                   	nop
801035dd:	c9                   	leave  
801035de:	c3                   	ret    

801035df <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035df:	55                   	push   %ebp
801035e0:	89 e5                	mov    %esp,%ebp
801035e2:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035e5:	83 ec 0c             	sub    $0xc,%esp
801035e8:	68 40 47 11 80       	push   $0x80114740
801035ed:	e8 ba 1d 00 00       	call   801053ac <acquire>
801035f2:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801035f5:	a1 80 47 11 80       	mov    0x80114780,%eax
801035fa:	85 c0                	test   %eax,%eax
801035fc:	74 17                	je     80103615 <begin_op+0x36>
      sleep(&log, &log.lock);
801035fe:	83 ec 08             	sub    $0x8,%esp
80103601:	68 40 47 11 80       	push   $0x80114740
80103606:	68 40 47 11 80       	push   $0x80114740
8010360b:	e8 0b 19 00 00       	call   80104f1b <sleep>
80103610:	83 c4 10             	add    $0x10,%esp
80103613:	eb e0                	jmp    801035f5 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103615:	8b 0d 88 47 11 80    	mov    0x80114788,%ecx
8010361b:	a1 7c 47 11 80       	mov    0x8011477c,%eax
80103620:	8d 50 01             	lea    0x1(%eax),%edx
80103623:	89 d0                	mov    %edx,%eax
80103625:	c1 e0 02             	shl    $0x2,%eax
80103628:	01 d0                	add    %edx,%eax
8010362a:	01 c0                	add    %eax,%eax
8010362c:	01 c8                	add    %ecx,%eax
8010362e:	83 f8 1e             	cmp    $0x1e,%eax
80103631:	7e 17                	jle    8010364a <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103633:	83 ec 08             	sub    $0x8,%esp
80103636:	68 40 47 11 80       	push   $0x80114740
8010363b:	68 40 47 11 80       	push   $0x80114740
80103640:	e8 d6 18 00 00       	call   80104f1b <sleep>
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	eb ab                	jmp    801035f5 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010364a:	a1 7c 47 11 80       	mov    0x8011477c,%eax
8010364f:	83 c0 01             	add    $0x1,%eax
80103652:	a3 7c 47 11 80       	mov    %eax,0x8011477c
      release(&log.lock);
80103657:	83 ec 0c             	sub    $0xc,%esp
8010365a:	68 40 47 11 80       	push   $0x80114740
8010365f:	e8 b4 1d 00 00       	call   80105418 <release>
80103664:	83 c4 10             	add    $0x10,%esp
      break;
80103667:	90                   	nop
    }
  }
}
80103668:	90                   	nop
80103669:	c9                   	leave  
8010366a:	c3                   	ret    

8010366b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010366b:	55                   	push   %ebp
8010366c:	89 e5                	mov    %esp,%ebp
8010366e:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103671:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	68 40 47 11 80       	push   $0x80114740
80103680:	e8 27 1d 00 00       	call   801053ac <acquire>
80103685:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103688:	a1 7c 47 11 80       	mov    0x8011477c,%eax
8010368d:	83 e8 01             	sub    $0x1,%eax
80103690:	a3 7c 47 11 80       	mov    %eax,0x8011477c
  if(log.committing)
80103695:	a1 80 47 11 80       	mov    0x80114780,%eax
8010369a:	85 c0                	test   %eax,%eax
8010369c:	74 0d                	je     801036ab <end_op+0x40>
    panic("log.committing");
8010369e:	83 ec 0c             	sub    $0xc,%esp
801036a1:	68 00 8c 10 80       	push   $0x80108c00
801036a6:	e8 f5 ce ff ff       	call   801005a0 <panic>
  if(log.outstanding == 0){
801036ab:	a1 7c 47 11 80       	mov    0x8011477c,%eax
801036b0:	85 c0                	test   %eax,%eax
801036b2:	75 13                	jne    801036c7 <end_op+0x5c>
    do_commit = 1;
801036b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036bb:	c7 05 80 47 11 80 01 	movl   $0x1,0x80114780
801036c2:	00 00 00 
801036c5:	eb 10                	jmp    801036d7 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036c7:	83 ec 0c             	sub    $0xc,%esp
801036ca:	68 40 47 11 80       	push   $0x80114740
801036cf:	e8 35 19 00 00       	call   80105009 <wakeup>
801036d4:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 40 47 11 80       	push   $0x80114740
801036df:	e8 34 1d 00 00       	call   80105418 <release>
801036e4:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036eb:	74 3f                	je     8010372c <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036ed:	e8 f5 00 00 00       	call   801037e7 <commit>
    acquire(&log.lock);
801036f2:	83 ec 0c             	sub    $0xc,%esp
801036f5:	68 40 47 11 80       	push   $0x80114740
801036fa:	e8 ad 1c 00 00       	call   801053ac <acquire>
801036ff:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103702:	c7 05 80 47 11 80 00 	movl   $0x0,0x80114780
80103709:	00 00 00 
    wakeup(&log);
8010370c:	83 ec 0c             	sub    $0xc,%esp
8010370f:	68 40 47 11 80       	push   $0x80114740
80103714:	e8 f0 18 00 00       	call   80105009 <wakeup>
80103719:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010371c:	83 ec 0c             	sub    $0xc,%esp
8010371f:	68 40 47 11 80       	push   $0x80114740
80103724:	e8 ef 1c 00 00       	call   80105418 <release>
80103729:	83 c4 10             	add    $0x10,%esp
  }
}
8010372c:	90                   	nop
8010372d:	c9                   	leave  
8010372e:	c3                   	ret    

8010372f <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010372f:	55                   	push   %ebp
80103730:	89 e5                	mov    %esp,%ebp
80103732:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010373c:	e9 95 00 00 00       	jmp    801037d6 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103741:	8b 15 74 47 11 80    	mov    0x80114774,%edx
80103747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374a:	01 d0                	add    %edx,%eax
8010374c:	83 c0 01             	add    $0x1,%eax
8010374f:	89 c2                	mov    %eax,%edx
80103751:	a1 84 47 11 80       	mov    0x80114784,%eax
80103756:	83 ec 08             	sub    $0x8,%esp
80103759:	52                   	push   %edx
8010375a:	50                   	push   %eax
8010375b:	e8 6e ca ff ff       	call   801001ce <bread>
80103760:	83 c4 10             	add    $0x10,%esp
80103763:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103769:	83 c0 10             	add    $0x10,%eax
8010376c:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103773:	89 c2                	mov    %eax,%edx
80103775:	a1 84 47 11 80       	mov    0x80114784,%eax
8010377a:	83 ec 08             	sub    $0x8,%esp
8010377d:	52                   	push   %edx
8010377e:	50                   	push   %eax
8010377f:	e8 4a ca ff ff       	call   801001ce <bread>
80103784:	83 c4 10             	add    $0x10,%esp
80103787:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378d:	8d 50 5c             	lea    0x5c(%eax),%edx
80103790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103793:	83 c0 5c             	add    $0x5c,%eax
80103796:	83 ec 04             	sub    $0x4,%esp
80103799:	68 00 02 00 00       	push   $0x200
8010379e:	52                   	push   %edx
8010379f:	50                   	push   %eax
801037a0:	e8 40 1f 00 00       	call   801056e5 <memmove>
801037a5:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	ff 75 f0             	pushl  -0x10(%ebp)
801037ae:	e8 54 ca ff ff       	call   80100207 <bwrite>
801037b3:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801037b6:	83 ec 0c             	sub    $0xc,%esp
801037b9:	ff 75 ec             	pushl  -0x14(%ebp)
801037bc:	e8 8f ca ff ff       	call   80100250 <brelse>
801037c1:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037c4:	83 ec 0c             	sub    $0xc,%esp
801037c7:	ff 75 f0             	pushl  -0x10(%ebp)
801037ca:	e8 81 ca ff ff       	call   80100250 <brelse>
801037cf:	83 c4 10             	add    $0x10,%esp
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037d6:	a1 88 47 11 80       	mov    0x80114788,%eax
801037db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037de:	0f 8f 5d ff ff ff    	jg     80103741 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
801037e4:	90                   	nop
801037e5:	c9                   	leave  
801037e6:	c3                   	ret    

801037e7 <commit>:

static void
commit()
{
801037e7:	55                   	push   %ebp
801037e8:	89 e5                	mov    %esp,%ebp
801037ea:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037ed:	a1 88 47 11 80       	mov    0x80114788,%eax
801037f2:	85 c0                	test   %eax,%eax
801037f4:	7e 1e                	jle    80103814 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
801037f6:	e8 34 ff ff ff       	call   8010372f <write_log>
    write_head();    // Write header to disk -- the real commit
801037fb:	e8 3a fd ff ff       	call   8010353a <write_head>
    install_trans(); // Now install writes to home locations
80103800:	e8 09 fc ff ff       	call   8010340e <install_trans>
    log.lh.n = 0;
80103805:	c7 05 88 47 11 80 00 	movl   $0x0,0x80114788
8010380c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010380f:	e8 26 fd ff ff       	call   8010353a <write_head>
  }
}
80103814:	90                   	nop
80103815:	c9                   	leave  
80103816:	c3                   	ret    

80103817 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103817:	55                   	push   %ebp
80103818:	89 e5                	mov    %esp,%ebp
8010381a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010381d:	a1 88 47 11 80       	mov    0x80114788,%eax
80103822:	83 f8 1d             	cmp    $0x1d,%eax
80103825:	7f 12                	jg     80103839 <log_write+0x22>
80103827:	a1 88 47 11 80       	mov    0x80114788,%eax
8010382c:	8b 15 78 47 11 80    	mov    0x80114778,%edx
80103832:	83 ea 01             	sub    $0x1,%edx
80103835:	39 d0                	cmp    %edx,%eax
80103837:	7c 0d                	jl     80103846 <log_write+0x2f>
    panic("too big a transaction");
80103839:	83 ec 0c             	sub    $0xc,%esp
8010383c:	68 0f 8c 10 80       	push   $0x80108c0f
80103841:	e8 5a cd ff ff       	call   801005a0 <panic>
  if (log.outstanding < 1)
80103846:	a1 7c 47 11 80       	mov    0x8011477c,%eax
8010384b:	85 c0                	test   %eax,%eax
8010384d:	7f 0d                	jg     8010385c <log_write+0x45>
    panic("log_write outside of trans");
8010384f:	83 ec 0c             	sub    $0xc,%esp
80103852:	68 25 8c 10 80       	push   $0x80108c25
80103857:	e8 44 cd ff ff       	call   801005a0 <panic>

  acquire(&log.lock);
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	68 40 47 11 80       	push   $0x80114740
80103864:	e8 43 1b 00 00       	call   801053ac <acquire>
80103869:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010386c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103873:	eb 1d                	jmp    80103892 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103878:	83 c0 10             	add    $0x10,%eax
8010387b:	8b 04 85 4c 47 11 80 	mov    -0x7feeb8b4(,%eax,4),%eax
80103882:	89 c2                	mov    %eax,%edx
80103884:	8b 45 08             	mov    0x8(%ebp),%eax
80103887:	8b 40 08             	mov    0x8(%eax),%eax
8010388a:	39 c2                	cmp    %eax,%edx
8010388c:	74 10                	je     8010389e <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010388e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103892:	a1 88 47 11 80       	mov    0x80114788,%eax
80103897:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010389a:	7f d9                	jg     80103875 <log_write+0x5e>
8010389c:	eb 01                	jmp    8010389f <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
8010389e:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
8010389f:	8b 45 08             	mov    0x8(%ebp),%eax
801038a2:	8b 40 08             	mov    0x8(%eax),%eax
801038a5:	89 c2                	mov    %eax,%edx
801038a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038aa:	83 c0 10             	add    $0x10,%eax
801038ad:	89 14 85 4c 47 11 80 	mov    %edx,-0x7feeb8b4(,%eax,4)
  if (i == log.lh.n)
801038b4:	a1 88 47 11 80       	mov    0x80114788,%eax
801038b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038bc:	75 0d                	jne    801038cb <log_write+0xb4>
    log.lh.n++;
801038be:	a1 88 47 11 80       	mov    0x80114788,%eax
801038c3:	83 c0 01             	add    $0x1,%eax
801038c6:	a3 88 47 11 80       	mov    %eax,0x80114788
  b->flags |= B_DIRTY; // prevent eviction
801038cb:	8b 45 08             	mov    0x8(%ebp),%eax
801038ce:	8b 00                	mov    (%eax),%eax
801038d0:	83 c8 04             	or     $0x4,%eax
801038d3:	89 c2                	mov    %eax,%edx
801038d5:	8b 45 08             	mov    0x8(%ebp),%eax
801038d8:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 40 47 11 80       	push   $0x80114740
801038e2:	e8 31 1b 00 00       	call   80105418 <release>
801038e7:	83 c4 10             	add    $0x10,%esp
}
801038ea:	90                   	nop
801038eb:	c9                   	leave  
801038ec:	c3                   	ret    

801038ed <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801038ed:	55                   	push   %ebp
801038ee:	89 e5                	mov    %esp,%ebp
801038f0:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038f3:	8b 55 08             	mov    0x8(%ebp),%edx
801038f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801038f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038fc:	f0 87 02             	lock xchg %eax,(%edx)
801038ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103902:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103905:	c9                   	leave  
80103906:	c3                   	ret    

80103907 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103907:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010390b:	83 e4 f0             	and    $0xfffffff0,%esp
8010390e:	ff 71 fc             	pushl  -0x4(%ecx)
80103911:	55                   	push   %ebp
80103912:	89 e5                	mov    %esp,%ebp
80103914:	51                   	push   %ecx
80103915:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103918:	83 ec 08             	sub    $0x8,%esp
8010391b:	68 00 00 40 80       	push   $0x80400000
80103920:	68 c8 7d 11 80       	push   $0x80117dc8
80103925:	e8 55 f2 ff ff       	call   80102b7f <kinit1>
8010392a:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010392d:	e8 b3 48 00 00       	call   801081e5 <kvmalloc>
  mpinit();        // detect other processors
80103932:	e8 e4 03 00 00       	call   80103d1b <mpinit>
  lapicinit();     // interrupt controller
80103937:	e8 bf f5 ff ff       	call   80102efb <lapicinit>
  seginit();       // segment descriptors
8010393c:	e8 7e 42 00 00       	call   80107bbf <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103941:	e8 d3 f6 ff ff       	call   80103019 <cpunum>
80103946:	83 ec 08             	sub    $0x8,%esp
80103949:	50                   	push   %eax
8010394a:	68 40 8c 10 80       	push   $0x80108c40
8010394f:	e8 ac ca ff ff       	call   80100400 <cprintf>
80103954:	83 c4 10             	add    $0x10,%esp
  picinit();       // another interrupt controller
80103957:	e8 94 05 00 00       	call   80103ef0 <picinit>
  ioapicinit();    // another interrupt controller
8010395c:	e8 20 f1 ff ff       	call   80102a81 <ioapicinit>
  consoleinit();   // console hardware
80103961:	e8 ed d1 ff ff       	call   80100b53 <consoleinit>
  uartinit();      // serial port
80103966:	e8 ca 35 00 00       	call   80106f35 <uartinit>
  pinit();         // process table
8010396b:	e8 7d 0a 00 00       	call   801043ed <pinit>
  tvinit();        // trap vectors
80103970:	e8 81 31 00 00       	call   80106af6 <tvinit>
  binit();         // buffer cache
80103975:	e8 ba c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010397a:	e8 67 d6 ff ff       	call   80100fe6 <fileinit>
  ideinit();       // disk
8010397f:	e8 c7 ec ff ff       	call   8010264b <ideinit>
  if(!ismp)
80103984:	a1 24 48 11 80       	mov    0x80114824,%eax
80103989:	85 c0                	test   %eax,%eax
8010398b:	75 05                	jne    80103992 <main+0x8b>
    timerinit();   // uniprocessor timer
8010398d:	e8 c1 30 00 00       	call   80106a53 <timerinit>
  startothers();   // start other processors
80103992:	e8 78 00 00 00       	call   80103a0f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103997:	83 ec 08             	sub    $0x8,%esp
8010399a:	68 00 00 00 8e       	push   $0x8e000000
8010399f:	68 00 00 40 80       	push   $0x80400000
801039a4:	e8 0f f2 ff ff       	call   80102bb8 <kinit2>
801039a9:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039ac:	e8 e6 0b 00 00       	call   80104597 <userinit>
  mpmain();        // finish this processor's setup
801039b1:	e8 1a 00 00 00       	call   801039d0 <mpmain>

801039b6 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039b6:	55                   	push   %ebp
801039b7:	89 e5                	mov    %esp,%ebp
801039b9:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801039bc:	e8 3c 48 00 00       	call   801081fd <switchkvm>
  seginit();
801039c1:	e8 f9 41 00 00       	call   80107bbf <seginit>
  lapicinit();
801039c6:	e8 30 f5 ff ff       	call   80102efb <lapicinit>
  mpmain();
801039cb:	e8 00 00 00 00       	call   801039d0 <mpmain>

801039d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
801039d6:	e8 3e f6 ff ff       	call   80103019 <cpunum>
801039db:	83 ec 08             	sub    $0x8,%esp
801039de:	50                   	push   %eax
801039df:	68 57 8c 10 80       	push   $0x80108c57
801039e4:	e8 17 ca ff ff       	call   80100400 <cprintf>
801039e9:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039ec:	e8 7b 32 00 00       	call   80106c6c <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039f7:	05 a8 00 00 00       	add    $0xa8,%eax
801039fc:	83 ec 08             	sub    $0x8,%esp
801039ff:	6a 01                	push   $0x1
80103a01:	50                   	push   %eax
80103a02:	e8 e6 fe ff ff       	call   801038ed <xchg>
80103a07:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a0a:	e8 f1 12 00 00       	call   80104d00 <scheduler>

80103a0f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a0f:	55                   	push   %ebp
80103a10:	89 e5                	mov    %esp,%ebp
80103a12:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103a15:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a1c:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a21:	83 ec 04             	sub    $0x4,%esp
80103a24:	50                   	push   %eax
80103a25:	68 2c c5 10 80       	push   $0x8010c52c
80103a2a:	ff 75 f0             	pushl  -0x10(%ebp)
80103a2d:	e8 b3 1c 00 00       	call   801056e5 <memmove>
80103a32:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a35:	c7 45 f4 40 48 11 80 	movl   $0x80114840,-0xc(%ebp)
80103a3c:	e9 84 00 00 00       	jmp    80103ac5 <startothers+0xb6>
    if(c == cpus+cpunum())  // We've started already.
80103a41:	e8 d3 f5 ff ff       	call   80103019 <cpunum>
80103a46:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a4c:	05 40 48 11 80       	add    $0x80114840,%eax
80103a51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a54:	74 67                	je     80103abd <startothers+0xae>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a56:	e8 58 f2 ff ff       	call   80102cb3 <kalloc>
80103a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a61:	83 e8 04             	sub    $0x4,%eax
80103a64:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a67:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a6d:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a72:	83 e8 08             	sub    $0x8,%eax
80103a75:	c7 00 b6 39 10 80    	movl   $0x801039b6,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a7e:	83 e8 0c             	sub    $0xc,%eax
80103a81:	ba 00 b0 10 80       	mov    $0x8010b000,%edx
80103a86:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80103a8c:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a91:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a9a:	0f b6 00             	movzbl (%eax),%eax
80103a9d:	0f b6 c0             	movzbl %al,%eax
80103aa0:	83 ec 08             	sub    $0x8,%esp
80103aa3:	52                   	push   %edx
80103aa4:	50                   	push   %eax
80103aa5:	e8 2e f6 ff ff       	call   801030d8 <lapicstartap>
80103aaa:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103aad:	90                   	nop
80103aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab1:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	74 f3                	je     80103aae <startothers+0x9f>
80103abb:	eb 01                	jmp    80103abe <startothers+0xaf>
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103abd:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103abe:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103ac5:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103aca:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ad0:	05 40 48 11 80       	add    $0x80114840,%eax
80103ad5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ad8:	0f 87 63 ff ff ff    	ja     80103a41 <startothers+0x32>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103ade:	90                   	nop
80103adf:	c9                   	leave  
80103ae0:	c3                   	ret    

80103ae1 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103ae1:	55                   	push   %ebp
80103ae2:	89 e5                	mov    %esp,%ebp
80103ae4:	83 ec 14             	sub    $0x14,%esp
80103ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80103aea:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103aee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103af2:	89 c2                	mov    %eax,%edx
80103af4:	ec                   	in     (%dx),%al
80103af5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103af8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103afc:	c9                   	leave  
80103afd:	c3                   	ret    

80103afe <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103afe:	55                   	push   %ebp
80103aff:	89 e5                	mov    %esp,%ebp
80103b01:	83 ec 08             	sub    $0x8,%esp
80103b04:	8b 55 08             	mov    0x8(%ebp),%edx
80103b07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b0a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b0e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b11:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b15:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b19:	ee                   	out    %al,(%dx)
}
80103b1a:	90                   	nop
80103b1b:	c9                   	leave  
80103b1c:	c3                   	ret    

80103b1d <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103b1d:	55                   	push   %ebp
80103b1e:	89 e5                	mov    %esp,%ebp
80103b20:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103b23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b31:	eb 15                	jmp    80103b48 <sum+0x2b>
    sum += addr[i];
80103b33:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b36:	8b 45 08             	mov    0x8(%ebp),%eax
80103b39:	01 d0                	add    %edx,%eax
80103b3b:	0f b6 00             	movzbl (%eax),%eax
80103b3e:	0f b6 c0             	movzbl %al,%eax
80103b41:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103b44:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b4e:	7c e3                	jl     80103b33 <sum+0x16>
    sum += addr[i];
  return sum;
80103b50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b53:	c9                   	leave  
80103b54:	c3                   	ret    

80103b55 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b55:	55                   	push   %ebp
80103b56:	89 e5                	mov    %esp,%ebp
80103b58:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b5e:	05 00 00 00 80       	add    $0x80000000,%eax
80103b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b66:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6c:	01 d0                	add    %edx,%eax
80103b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b77:	eb 36                	jmp    80103baf <mpsearch1+0x5a>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b79:	83 ec 04             	sub    $0x4,%esp
80103b7c:	6a 04                	push   $0x4
80103b7e:	68 68 8c 10 80       	push   $0x80108c68
80103b83:	ff 75 f4             	pushl  -0xc(%ebp)
80103b86:	e8 02 1b 00 00       	call   8010568d <memcmp>
80103b8b:	83 c4 10             	add    $0x10,%esp
80103b8e:	85 c0                	test   %eax,%eax
80103b90:	75 19                	jne    80103bab <mpsearch1+0x56>
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	6a 10                	push   $0x10
80103b97:	ff 75 f4             	pushl  -0xc(%ebp)
80103b9a:	e8 7e ff ff ff       	call   80103b1d <sum>
80103b9f:	83 c4 10             	add    $0x10,%esp
80103ba2:	84 c0                	test   %al,%al
80103ba4:	75 05                	jne    80103bab <mpsearch1+0x56>
      return (struct mp*)p;
80103ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba9:	eb 11                	jmp    80103bbc <mpsearch1+0x67>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103bab:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103bb5:	72 c2                	jb     80103b79 <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103bbc:	c9                   	leave  
80103bbd:	c3                   	ret    

80103bbe <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103bbe:	55                   	push   %ebp
80103bbf:	89 e5                	mov    %esp,%ebp
80103bc1:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bc4:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bce:	83 c0 0f             	add    $0xf,%eax
80103bd1:	0f b6 00             	movzbl (%eax),%eax
80103bd4:	0f b6 c0             	movzbl %al,%eax
80103bd7:	c1 e0 08             	shl    $0x8,%eax
80103bda:	89 c2                	mov    %eax,%edx
80103bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bdf:	83 c0 0e             	add    $0xe,%eax
80103be2:	0f b6 00             	movzbl (%eax),%eax
80103be5:	0f b6 c0             	movzbl %al,%eax
80103be8:	09 d0                	or     %edx,%eax
80103bea:	c1 e0 04             	shl    $0x4,%eax
80103bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bf4:	74 21                	je     80103c17 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103bf6:	83 ec 08             	sub    $0x8,%esp
80103bf9:	68 00 04 00 00       	push   $0x400
80103bfe:	ff 75 f0             	pushl  -0x10(%ebp)
80103c01:	e8 4f ff ff ff       	call   80103b55 <mpsearch1>
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c0c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c10:	74 51                	je     80103c63 <mpsearch+0xa5>
      return mp;
80103c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c15:	eb 61                	jmp    80103c78 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1a:	83 c0 14             	add    $0x14,%eax
80103c1d:	0f b6 00             	movzbl (%eax),%eax
80103c20:	0f b6 c0             	movzbl %al,%eax
80103c23:	c1 e0 08             	shl    $0x8,%eax
80103c26:	89 c2                	mov    %eax,%edx
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	83 c0 13             	add    $0x13,%eax
80103c2e:	0f b6 00             	movzbl (%eax),%eax
80103c31:	0f b6 c0             	movzbl %al,%eax
80103c34:	09 d0                	or     %edx,%eax
80103c36:	c1 e0 0a             	shl    $0xa,%eax
80103c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c3f:	2d 00 04 00 00       	sub    $0x400,%eax
80103c44:	83 ec 08             	sub    $0x8,%esp
80103c47:	68 00 04 00 00       	push   $0x400
80103c4c:	50                   	push   %eax
80103c4d:	e8 03 ff ff ff       	call   80103b55 <mpsearch1>
80103c52:	83 c4 10             	add    $0x10,%esp
80103c55:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c5c:	74 05                	je     80103c63 <mpsearch+0xa5>
      return mp;
80103c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c61:	eb 15                	jmp    80103c78 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c63:	83 ec 08             	sub    $0x8,%esp
80103c66:	68 00 00 01 00       	push   $0x10000
80103c6b:	68 00 00 0f 00       	push   $0xf0000
80103c70:	e8 e0 fe ff ff       	call   80103b55 <mpsearch1>
80103c75:	83 c4 10             	add    $0x10,%esp
}
80103c78:	c9                   	leave  
80103c79:	c3                   	ret    

80103c7a <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c7a:	55                   	push   %ebp
80103c7b:	89 e5                	mov    %esp,%ebp
80103c7d:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c80:	e8 39 ff ff ff       	call   80103bbe <mpsearch>
80103c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c8c:	74 0a                	je     80103c98 <mpconfig+0x1e>
80103c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c91:	8b 40 04             	mov    0x4(%eax),%eax
80103c94:	85 c0                	test   %eax,%eax
80103c96:	75 07                	jne    80103c9f <mpconfig+0x25>
    return 0;
80103c98:	b8 00 00 00 00       	mov    $0x0,%eax
80103c9d:	eb 7a                	jmp    80103d19 <mpconfig+0x9f>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca2:	8b 40 04             	mov    0x4(%eax),%eax
80103ca5:	05 00 00 00 80       	add    $0x80000000,%eax
80103caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103cad:	83 ec 04             	sub    $0x4,%esp
80103cb0:	6a 04                	push   $0x4
80103cb2:	68 6d 8c 10 80       	push   $0x80108c6d
80103cb7:	ff 75 f0             	pushl  -0x10(%ebp)
80103cba:	e8 ce 19 00 00       	call   8010568d <memcmp>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	74 07                	je     80103ccd <mpconfig+0x53>
    return 0;
80103cc6:	b8 00 00 00 00       	mov    $0x0,%eax
80103ccb:	eb 4c                	jmp    80103d19 <mpconfig+0x9f>
  if(conf->version != 1 && conf->version != 4)
80103ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd0:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cd4:	3c 01                	cmp    $0x1,%al
80103cd6:	74 12                	je     80103cea <mpconfig+0x70>
80103cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cdb:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cdf:	3c 04                	cmp    $0x4,%al
80103ce1:	74 07                	je     80103cea <mpconfig+0x70>
    return 0;
80103ce3:	b8 00 00 00 00       	mov    $0x0,%eax
80103ce8:	eb 2f                	jmp    80103d19 <mpconfig+0x9f>
  if(sum((uchar*)conf, conf->length) != 0)
80103cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ced:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cf1:	0f b7 c0             	movzwl %ax,%eax
80103cf4:	83 ec 08             	sub    $0x8,%esp
80103cf7:	50                   	push   %eax
80103cf8:	ff 75 f0             	pushl  -0x10(%ebp)
80103cfb:	e8 1d fe ff ff       	call   80103b1d <sum>
80103d00:	83 c4 10             	add    $0x10,%esp
80103d03:	84 c0                	test   %al,%al
80103d05:	74 07                	je     80103d0e <mpconfig+0x94>
    return 0;
80103d07:	b8 00 00 00 00       	mov    $0x0,%eax
80103d0c:	eb 0b                	jmp    80103d19 <mpconfig+0x9f>
  *pmp = mp;
80103d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d14:	89 10                	mov    %edx,(%eax)
  return conf;
80103d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d19:	c9                   	leave  
80103d1a:	c3                   	ret    

80103d1b <mpinit>:

void
mpinit(void)
{
80103d1b:	55                   	push   %ebp
80103d1c:	89 e5                	mov    %esp,%ebp
80103d1e:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103d21:	83 ec 0c             	sub    $0xc,%esp
80103d24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d27:	50                   	push   %eax
80103d28:	e8 4d ff ff ff       	call   80103c7a <mpconfig>
80103d2d:	83 c4 10             	add    $0x10,%esp
80103d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d37:	0f 84 1f 01 00 00    	je     80103e5c <mpinit+0x141>
    return;
  ismp = 1;
80103d3d:	c7 05 24 48 11 80 01 	movl   $0x1,0x80114824
80103d44:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4a:	8b 40 24             	mov    0x24(%eax),%eax
80103d4d:	a3 3c 47 11 80       	mov    %eax,0x8011473c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d55:	83 c0 2c             	add    $0x2c,%eax
80103d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d62:	0f b7 d0             	movzwl %ax,%edx
80103d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d68:	01 d0                	add    %edx,%eax
80103d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d6d:	eb 7e                	jmp    80103ded <mpinit+0xd2>
    switch(*p){
80103d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d72:	0f b6 00             	movzbl (%eax),%eax
80103d75:	0f b6 c0             	movzbl %al,%eax
80103d78:	83 f8 04             	cmp    $0x4,%eax
80103d7b:	77 65                	ja     80103de2 <mpinit+0xc7>
80103d7d:	8b 04 85 74 8c 10 80 	mov    -0x7fef738c(,%eax,4),%eax
80103d84:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d89:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu < NCPU) {
80103d8c:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103d91:	83 f8 07             	cmp    $0x7,%eax
80103d94:	7f 28                	jg     80103dbe <mpinit+0xa3>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d96:	8b 15 20 4e 11 80    	mov    0x80114e20,%edx
80103d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d9f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103da3:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103da9:	81 c2 40 48 11 80    	add    $0x80114840,%edx
80103daf:	88 02                	mov    %al,(%edx)
        ncpu++;
80103db1:	a1 20 4e 11 80       	mov    0x80114e20,%eax
80103db6:	83 c0 01             	add    $0x1,%eax
80103db9:	a3 20 4e 11 80       	mov    %eax,0x80114e20
      }
      p += sizeof(struct mpproc);
80103dbe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103dc2:	eb 29                	jmp    80103ded <mpinit+0xd2>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dcd:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dd1:	a2 20 48 11 80       	mov    %al,0x80114820
      p += sizeof(struct mpioapic);
80103dd6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dda:	eb 11                	jmp    80103ded <mpinit+0xd2>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ddc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103de0:	eb 0b                	jmp    80103ded <mpinit+0xd2>
    default:
      ismp = 0;
80103de2:	c7 05 24 48 11 80 00 	movl   $0x0,0x80114824
80103de9:	00 00 00 
      break;
80103dec:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103df3:	0f 82 76 ff ff ff    	jb     80103d6f <mpinit+0x54>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103df9:	a1 24 48 11 80       	mov    0x80114824,%eax
80103dfe:	85 c0                	test   %eax,%eax
80103e00:	75 1d                	jne    80103e1f <mpinit+0x104>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e02:	c7 05 20 4e 11 80 01 	movl   $0x1,0x80114e20
80103e09:	00 00 00 
    lapic = 0;
80103e0c:	c7 05 3c 47 11 80 00 	movl   $0x0,0x8011473c
80103e13:	00 00 00 
    ioapicid = 0;
80103e16:	c6 05 20 48 11 80 00 	movb   $0x0,0x80114820
    return;
80103e1d:	eb 3e                	jmp    80103e5d <mpinit+0x142>
  }

  if(mp->imcrp){
80103e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e22:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e26:	84 c0                	test   %al,%al
80103e28:	74 33                	je     80103e5d <mpinit+0x142>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e2a:	83 ec 08             	sub    $0x8,%esp
80103e2d:	6a 70                	push   $0x70
80103e2f:	6a 22                	push   $0x22
80103e31:	e8 c8 fc ff ff       	call   80103afe <outb>
80103e36:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e39:	83 ec 0c             	sub    $0xc,%esp
80103e3c:	6a 23                	push   $0x23
80103e3e:	e8 9e fc ff ff       	call   80103ae1 <inb>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	83 c8 01             	or     $0x1,%eax
80103e49:	0f b6 c0             	movzbl %al,%eax
80103e4c:	83 ec 08             	sub    $0x8,%esp
80103e4f:	50                   	push   %eax
80103e50:	6a 23                	push   $0x23
80103e52:	e8 a7 fc ff ff       	call   80103afe <outb>
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	eb 01                	jmp    80103e5d <mpinit+0x142>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    return;
80103e5c:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103e5d:	c9                   	leave  
80103e5e:	c3                   	ret    

80103e5f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e5f:	55                   	push   %ebp
80103e60:	89 e5                	mov    %esp,%ebp
80103e62:	83 ec 08             	sub    $0x8,%esp
80103e65:	8b 55 08             	mov    0x8(%ebp),%edx
80103e68:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e6b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e6f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e72:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e76:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e7a:	ee                   	out    %al,(%dx)
}
80103e7b:	90                   	nop
80103e7c:	c9                   	leave  
80103e7d:	c3                   	ret    

80103e7e <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e7e:	55                   	push   %ebp
80103e7f:	89 e5                	mov    %esp,%ebp
80103e81:	83 ec 04             	sub    $0x4,%esp
80103e84:	8b 45 08             	mov    0x8(%ebp),%eax
80103e87:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e8b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e8f:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103e95:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e99:	0f b6 c0             	movzbl %al,%eax
80103e9c:	50                   	push   %eax
80103e9d:	6a 21                	push   $0x21
80103e9f:	e8 bb ff ff ff       	call   80103e5f <outb>
80103ea4:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103ea7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103eab:	66 c1 e8 08          	shr    $0x8,%ax
80103eaf:	0f b6 c0             	movzbl %al,%eax
80103eb2:	50                   	push   %eax
80103eb3:	68 a1 00 00 00       	push   $0xa1
80103eb8:	e8 a2 ff ff ff       	call   80103e5f <outb>
80103ebd:	83 c4 08             	add    $0x8,%esp
}
80103ec0:	90                   	nop
80103ec1:	c9                   	leave  
80103ec2:	c3                   	ret    

80103ec3 <picenable>:

void
picenable(int irq)
{
80103ec3:	55                   	push   %ebp
80103ec4:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec9:	ba 01 00 00 00       	mov    $0x1,%edx
80103ece:	89 c1                	mov    %eax,%ecx
80103ed0:	d3 e2                	shl    %cl,%edx
80103ed2:	89 d0                	mov    %edx,%eax
80103ed4:	f7 d0                	not    %eax
80103ed6:	89 c2                	mov    %eax,%edx
80103ed8:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103edf:	21 d0                	and    %edx,%eax
80103ee1:	0f b7 c0             	movzwl %ax,%eax
80103ee4:	50                   	push   %eax
80103ee5:	e8 94 ff ff ff       	call   80103e7e <picsetmask>
80103eea:	83 c4 04             	add    $0x4,%esp
}
80103eed:	90                   	nop
80103eee:	c9                   	leave  
80103eef:	c3                   	ret    

80103ef0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ef3:	68 ff 00 00 00       	push   $0xff
80103ef8:	6a 21                	push   $0x21
80103efa:	e8 60 ff ff ff       	call   80103e5f <outb>
80103eff:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f02:	68 ff 00 00 00       	push   $0xff
80103f07:	68 a1 00 00 00       	push   $0xa1
80103f0c:	e8 4e ff ff ff       	call   80103e5f <outb>
80103f11:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f14:	6a 11                	push   $0x11
80103f16:	6a 20                	push   $0x20
80103f18:	e8 42 ff ff ff       	call   80103e5f <outb>
80103f1d:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f20:	6a 20                	push   $0x20
80103f22:	6a 21                	push   $0x21
80103f24:	e8 36 ff ff ff       	call   80103e5f <outb>
80103f29:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f2c:	6a 04                	push   $0x4
80103f2e:	6a 21                	push   $0x21
80103f30:	e8 2a ff ff ff       	call   80103e5f <outb>
80103f35:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f38:	6a 03                	push   $0x3
80103f3a:	6a 21                	push   $0x21
80103f3c:	e8 1e ff ff ff       	call   80103e5f <outb>
80103f41:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f44:	6a 11                	push   $0x11
80103f46:	68 a0 00 00 00       	push   $0xa0
80103f4b:	e8 0f ff ff ff       	call   80103e5f <outb>
80103f50:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f53:	6a 28                	push   $0x28
80103f55:	68 a1 00 00 00       	push   $0xa1
80103f5a:	e8 00 ff ff ff       	call   80103e5f <outb>
80103f5f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f62:	6a 02                	push   $0x2
80103f64:	68 a1 00 00 00       	push   $0xa1
80103f69:	e8 f1 fe ff ff       	call   80103e5f <outb>
80103f6e:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f71:	6a 03                	push   $0x3
80103f73:	68 a1 00 00 00       	push   $0xa1
80103f78:	e8 e2 fe ff ff       	call   80103e5f <outb>
80103f7d:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f80:	6a 68                	push   $0x68
80103f82:	6a 20                	push   $0x20
80103f84:	e8 d6 fe ff ff       	call   80103e5f <outb>
80103f89:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f8c:	6a 0a                	push   $0xa
80103f8e:	6a 20                	push   $0x20
80103f90:	e8 ca fe ff ff       	call   80103e5f <outb>
80103f95:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f98:	6a 68                	push   $0x68
80103f9a:	68 a0 00 00 00       	push   $0xa0
80103f9f:	e8 bb fe ff ff       	call   80103e5f <outb>
80103fa4:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103fa7:	6a 0a                	push   $0xa
80103fa9:	68 a0 00 00 00       	push   $0xa0
80103fae:	e8 ac fe ff ff       	call   80103e5f <outb>
80103fb3:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fb6:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fbd:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fc1:	74 13                	je     80103fd6 <picinit+0xe6>
    picsetmask(irqmask);
80103fc3:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fca:	0f b7 c0             	movzwl %ax,%eax
80103fcd:	50                   	push   %eax
80103fce:	e8 ab fe ff ff       	call   80103e7e <picsetmask>
80103fd3:	83 c4 04             	add    $0x4,%esp
}
80103fd6:	90                   	nop
80103fd7:	c9                   	leave  
80103fd8:	c3                   	ret    

80103fd9 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fd9:	55                   	push   %ebp
80103fda:	89 e5                	mov    %esp,%ebp
80103fdc:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fef:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ff2:	8b 10                	mov    (%eax),%edx
80103ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff7:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ff9:	e8 06 d0 ff ff       	call   80101004 <filealloc>
80103ffe:	89 c2                	mov    %eax,%edx
80104000:	8b 45 08             	mov    0x8(%ebp),%eax
80104003:	89 10                	mov    %edx,(%eax)
80104005:	8b 45 08             	mov    0x8(%ebp),%eax
80104008:	8b 00                	mov    (%eax),%eax
8010400a:	85 c0                	test   %eax,%eax
8010400c:	0f 84 cb 00 00 00    	je     801040dd <pipealloc+0x104>
80104012:	e8 ed cf ff ff       	call   80101004 <filealloc>
80104017:	89 c2                	mov    %eax,%edx
80104019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401c:	89 10                	mov    %edx,(%eax)
8010401e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104021:	8b 00                	mov    (%eax),%eax
80104023:	85 c0                	test   %eax,%eax
80104025:	0f 84 b2 00 00 00    	je     801040dd <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010402b:	e8 83 ec ff ff       	call   80102cb3 <kalloc>
80104030:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104033:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104037:	0f 84 9f 00 00 00    	je     801040dc <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010403d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104040:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104047:	00 00 00 
  p->writeopen = 1;
8010404a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104054:	00 00 00 
  p->nwrite = 0;
80104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405a:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104061:	00 00 00 
  p->nread = 0;
80104064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104067:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010406e:	00 00 00 
  initlock(&p->lock, "pipe");
80104071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104074:	83 ec 08             	sub    $0x8,%esp
80104077:	68 88 8c 10 80       	push   $0x80108c88
8010407c:	50                   	push   %eax
8010407d:	e8 08 13 00 00       	call   8010538a <initlock>
80104082:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104085:	8b 45 08             	mov    0x8(%ebp),%eax
80104088:	8b 00                	mov    (%eax),%eax
8010408a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104090:	8b 45 08             	mov    0x8(%ebp),%eax
80104093:	8b 00                	mov    (%eax),%eax
80104095:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104099:	8b 45 08             	mov    0x8(%ebp),%eax
8010409c:	8b 00                	mov    (%eax),%eax
8010409e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040a2:	8b 45 08             	mov    0x8(%ebp),%eax
801040a5:	8b 00                	mov    (%eax),%eax
801040a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040aa:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b0:	8b 00                	mov    (%eax),%eax
801040b2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040bb:	8b 00                	mov    (%eax),%eax
801040bd:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c4:	8b 00                	mov    (%eax),%eax
801040c6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801040cd:	8b 00                	mov    (%eax),%eax
801040cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040d2:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040d5:	b8 00 00 00 00       	mov    $0x0,%eax
801040da:	eb 4e                	jmp    8010412a <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801040dc:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801040dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040e1:	74 0e                	je     801040f1 <pipealloc+0x118>
    kfree((char*)p);
801040e3:	83 ec 0c             	sub    $0xc,%esp
801040e6:	ff 75 f4             	pushl  -0xc(%ebp)
801040e9:	e8 2b eb ff ff       	call   80102c19 <kfree>
801040ee:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040f1:	8b 45 08             	mov    0x8(%ebp),%eax
801040f4:	8b 00                	mov    (%eax),%eax
801040f6:	85 c0                	test   %eax,%eax
801040f8:	74 11                	je     8010410b <pipealloc+0x132>
    fileclose(*f0);
801040fa:	8b 45 08             	mov    0x8(%ebp),%eax
801040fd:	8b 00                	mov    (%eax),%eax
801040ff:	83 ec 0c             	sub    $0xc,%esp
80104102:	50                   	push   %eax
80104103:	e8 ba cf ff ff       	call   801010c2 <fileclose>
80104108:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010410b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010410e:	8b 00                	mov    (%eax),%eax
80104110:	85 c0                	test   %eax,%eax
80104112:	74 11                	je     80104125 <pipealloc+0x14c>
    fileclose(*f1);
80104114:	8b 45 0c             	mov    0xc(%ebp),%eax
80104117:	8b 00                	mov    (%eax),%eax
80104119:	83 ec 0c             	sub    $0xc,%esp
8010411c:	50                   	push   %eax
8010411d:	e8 a0 cf ff ff       	call   801010c2 <fileclose>
80104122:	83 c4 10             	add    $0x10,%esp
  return -1;
80104125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010412a:	c9                   	leave  
8010412b:	c3                   	ret    

8010412c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010412c:	55                   	push   %ebp
8010412d:	89 e5                	mov    %esp,%ebp
8010412f:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104132:	8b 45 08             	mov    0x8(%ebp),%eax
80104135:	83 ec 0c             	sub    $0xc,%esp
80104138:	50                   	push   %eax
80104139:	e8 6e 12 00 00       	call   801053ac <acquire>
8010413e:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104141:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104145:	74 23                	je     8010416a <pipeclose+0x3e>
    p->writeopen = 0;
80104147:	8b 45 08             	mov    0x8(%ebp),%eax
8010414a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104151:	00 00 00 
    wakeup(&p->nread);
80104154:	8b 45 08             	mov    0x8(%ebp),%eax
80104157:	05 34 02 00 00       	add    $0x234,%eax
8010415c:	83 ec 0c             	sub    $0xc,%esp
8010415f:	50                   	push   %eax
80104160:	e8 a4 0e 00 00       	call   80105009 <wakeup>
80104165:	83 c4 10             	add    $0x10,%esp
80104168:	eb 21                	jmp    8010418b <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010416a:	8b 45 08             	mov    0x8(%ebp),%eax
8010416d:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104174:	00 00 00 
    wakeup(&p->nwrite);
80104177:	8b 45 08             	mov    0x8(%ebp),%eax
8010417a:	05 38 02 00 00       	add    $0x238,%eax
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	50                   	push   %eax
80104183:	e8 81 0e 00 00       	call   80105009 <wakeup>
80104188:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010418b:	8b 45 08             	mov    0x8(%ebp),%eax
8010418e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104194:	85 c0                	test   %eax,%eax
80104196:	75 2c                	jne    801041c4 <pipeclose+0x98>
80104198:	8b 45 08             	mov    0x8(%ebp),%eax
8010419b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041a1:	85 c0                	test   %eax,%eax
801041a3:	75 1f                	jne    801041c4 <pipeclose+0x98>
    release(&p->lock);
801041a5:	8b 45 08             	mov    0x8(%ebp),%eax
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	50                   	push   %eax
801041ac:	e8 67 12 00 00       	call   80105418 <release>
801041b1:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	ff 75 08             	pushl  0x8(%ebp)
801041ba:	e8 5a ea ff ff       	call   80102c19 <kfree>
801041bf:	83 c4 10             	add    $0x10,%esp
801041c2:	eb 0f                	jmp    801041d3 <pipeclose+0xa7>
  } else
    release(&p->lock);
801041c4:	8b 45 08             	mov    0x8(%ebp),%eax
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	50                   	push   %eax
801041cb:	e8 48 12 00 00       	call   80105418 <release>
801041d0:	83 c4 10             	add    $0x10,%esp
}
801041d3:	90                   	nop
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    

801041d6 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041d6:	55                   	push   %ebp
801041d7:	89 e5                	mov    %esp,%ebp
801041d9:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801041dc:	8b 45 08             	mov    0x8(%ebp),%eax
801041df:	83 ec 0c             	sub    $0xc,%esp
801041e2:	50                   	push   %eax
801041e3:	e8 c4 11 00 00       	call   801053ac <acquire>
801041e8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041f2:	e9 ad 00 00 00       	jmp    801042a4 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104200:	85 c0                	test   %eax,%eax
80104202:	74 0d                	je     80104211 <pipewrite+0x3b>
80104204:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010420a:	8b 40 34             	mov    0x34(%eax),%eax
8010420d:	85 c0                	test   %eax,%eax
8010420f:	74 19                	je     8010422a <pipewrite+0x54>
        release(&p->lock);
80104211:	8b 45 08             	mov    0x8(%ebp),%eax
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	50                   	push   %eax
80104218:	e8 fb 11 00 00       	call   80105418 <release>
8010421d:	83 c4 10             	add    $0x10,%esp
        return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	e9 a8 00 00 00       	jmp    801042d2 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
8010422a:	8b 45 08             	mov    0x8(%ebp),%eax
8010422d:	05 34 02 00 00       	add    $0x234,%eax
80104232:	83 ec 0c             	sub    $0xc,%esp
80104235:	50                   	push   %eax
80104236:	e8 ce 0d 00 00       	call   80105009 <wakeup>
8010423b:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010423e:	8b 45 08             	mov    0x8(%ebp),%eax
80104241:	8b 55 08             	mov    0x8(%ebp),%edx
80104244:	81 c2 38 02 00 00    	add    $0x238,%edx
8010424a:	83 ec 08             	sub    $0x8,%esp
8010424d:	50                   	push   %eax
8010424e:	52                   	push   %edx
8010424f:	e8 c7 0c 00 00       	call   80104f1b <sleep>
80104254:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104257:	8b 45 08             	mov    0x8(%ebp),%eax
8010425a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104260:	8b 45 08             	mov    0x8(%ebp),%eax
80104263:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104269:	05 00 02 00 00       	add    $0x200,%eax
8010426e:	39 c2                	cmp    %eax,%edx
80104270:	74 85                	je     801041f7 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104272:	8b 45 08             	mov    0x8(%ebp),%eax
80104275:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010427b:	8d 48 01             	lea    0x1(%eax),%ecx
8010427e:	8b 55 08             	mov    0x8(%ebp),%edx
80104281:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104287:	25 ff 01 00 00       	and    $0x1ff,%eax
8010428c:	89 c1                	mov    %eax,%ecx
8010428e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104291:	8b 45 0c             	mov    0xc(%ebp),%eax
80104294:	01 d0                	add    %edx,%eax
80104296:	0f b6 10             	movzbl (%eax),%edx
80104299:	8b 45 08             	mov    0x8(%ebp),%eax
8010429c:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801042a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a7:	3b 45 10             	cmp    0x10(%ebp),%eax
801042aa:	7c ab                	jl     80104257 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042ac:	8b 45 08             	mov    0x8(%ebp),%eax
801042af:	05 34 02 00 00       	add    $0x234,%eax
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	50                   	push   %eax
801042b8:	e8 4c 0d 00 00       	call   80105009 <wakeup>
801042bd:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042c0:	8b 45 08             	mov    0x8(%ebp),%eax
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	50                   	push   %eax
801042c7:	e8 4c 11 00 00       	call   80105418 <release>
801042cc:	83 c4 10             	add    $0x10,%esp
  return n;
801042cf:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042d2:	c9                   	leave  
801042d3:	c3                   	ret    

801042d4 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042d4:	55                   	push   %ebp
801042d5:	89 e5                	mov    %esp,%ebp
801042d7:	53                   	push   %ebx
801042d8:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042db:	8b 45 08             	mov    0x8(%ebp),%eax
801042de:	83 ec 0c             	sub    $0xc,%esp
801042e1:	50                   	push   %eax
801042e2:	e8 c5 10 00 00       	call   801053ac <acquire>
801042e7:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042ea:	eb 3f                	jmp    8010432b <piperead+0x57>
    if(proc->killed){
801042ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042f2:	8b 40 34             	mov    0x34(%eax),%eax
801042f5:	85 c0                	test   %eax,%eax
801042f7:	74 19                	je     80104312 <piperead+0x3e>
      release(&p->lock);
801042f9:	8b 45 08             	mov    0x8(%ebp),%eax
801042fc:	83 ec 0c             	sub    $0xc,%esp
801042ff:	50                   	push   %eax
80104300:	e8 13 11 00 00       	call   80105418 <release>
80104305:	83 c4 10             	add    $0x10,%esp
      return -1;
80104308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430d:	e9 bf 00 00 00       	jmp    801043d1 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104312:	8b 45 08             	mov    0x8(%ebp),%eax
80104315:	8b 55 08             	mov    0x8(%ebp),%edx
80104318:	81 c2 34 02 00 00    	add    $0x234,%edx
8010431e:	83 ec 08             	sub    $0x8,%esp
80104321:	50                   	push   %eax
80104322:	52                   	push   %edx
80104323:	e8 f3 0b 00 00       	call   80104f1b <sleep>
80104328:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010432b:	8b 45 08             	mov    0x8(%ebp),%eax
8010432e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104334:	8b 45 08             	mov    0x8(%ebp),%eax
80104337:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010433d:	39 c2                	cmp    %eax,%edx
8010433f:	75 0d                	jne    8010434e <piperead+0x7a>
80104341:	8b 45 08             	mov    0x8(%ebp),%eax
80104344:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010434a:	85 c0                	test   %eax,%eax
8010434c:	75 9e                	jne    801042ec <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010434e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104355:	eb 49                	jmp    801043a0 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104360:	8b 45 08             	mov    0x8(%ebp),%eax
80104363:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104369:	39 c2                	cmp    %eax,%edx
8010436b:	74 3d                	je     801043aa <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010436d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104370:	8b 45 0c             	mov    0xc(%ebp),%eax
80104373:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104376:	8b 45 08             	mov    0x8(%ebp),%eax
80104379:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010437f:	8d 48 01             	lea    0x1(%eax),%ecx
80104382:	8b 55 08             	mov    0x8(%ebp),%edx
80104385:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010438b:	25 ff 01 00 00       	and    $0x1ff,%eax
80104390:	89 c2                	mov    %eax,%edx
80104392:	8b 45 08             	mov    0x8(%ebp),%eax
80104395:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010439a:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010439c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a3:	3b 45 10             	cmp    0x10(%ebp),%eax
801043a6:	7c af                	jl     80104357 <piperead+0x83>
801043a8:	eb 01                	jmp    801043ab <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801043aa:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043ab:	8b 45 08             	mov    0x8(%ebp),%eax
801043ae:	05 38 02 00 00       	add    $0x238,%eax
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	50                   	push   %eax
801043b7:	e8 4d 0c 00 00       	call   80105009 <wakeup>
801043bc:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043bf:	8b 45 08             	mov    0x8(%ebp),%eax
801043c2:	83 ec 0c             	sub    $0xc,%esp
801043c5:	50                   	push   %eax
801043c6:	e8 4d 10 00 00       	call   80105418 <release>
801043cb:	83 c4 10             	add    $0x10,%esp
  return i;
801043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d4:	c9                   	leave  
801043d5:	c3                   	ret    

801043d6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043d6:	55                   	push   %ebp
801043d7:	89 e5                	mov    %esp,%ebp
801043d9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043dc:	9c                   	pushf  
801043dd:	58                   	pop    %eax
801043de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    

801043e6 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043e6:	55                   	push   %ebp
801043e7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043e9:	fb                   	sti    
}
801043ea:	90                   	nop
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    

801043ed <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043ed:	55                   	push   %ebp
801043ee:	89 e5                	mov    %esp,%ebp
801043f0:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043f3:	83 ec 08             	sub    $0x8,%esp
801043f6:	68 8d 8c 10 80       	push   $0x80108c8d
801043fb:	68 40 4e 11 80       	push   $0x80114e40
80104400:	e8 85 0f 00 00       	call   8010538a <initlock>
80104405:	83 c4 10             	add    $0x10,%esp
}
80104408:	90                   	nop
80104409:	c9                   	leave  
8010440a:	c3                   	ret    

8010440b <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010440b:	55                   	push   %ebp
8010440c:	89 e5                	mov    %esp,%ebp
8010440e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104411:	83 ec 0c             	sub    $0xc,%esp
80104414:	68 40 4e 11 80       	push   $0x80114e40
80104419:	e8 8e 0f 00 00       	call   801053ac <acquire>
8010441e:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104421:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104428:	eb 11                	jmp    8010443b <allocproc+0x30>
    if(p->state == UNUSED)
8010442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442d:	8b 40 20             	mov    0x20(%eax),%eax
80104430:	85 c0                	test   %eax,%eax
80104432:	74 2a                	je     8010445e <allocproc+0x53>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104434:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010443b:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80104442:	72 e6                	jb     8010442a <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 40 4e 11 80       	push   $0x80114e40
8010444c:	e8 c7 0f 00 00       	call   80105418 <release>
80104451:	83 c4 10             	add    $0x10,%esp
  return 0;
80104454:	b8 00 00 00 00       	mov    $0x0,%eax
80104459:	e9 37 01 00 00       	jmp    80104595 <allocproc+0x18a>

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
8010445e:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104462:	c7 40 20 01 00 00 00 	movl   $0x1,0x20(%eax)
  p->pid = nextpid++;
80104469:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010446e:	8d 50 01             	lea    0x1(%eax),%edx
80104471:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447a:	89 42 10             	mov    %eax,0x10(%edx)
  p->ctime = ticks;
8010447d:	8b 15 c0 7d 11 80    	mov    0x80117dc0,%edx
80104483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104486:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->retime = 0;
80104489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104493:	00 00 00 
  p->rutime = 0;
80104496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104499:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801044a0:	00 00 00 
  p->stime = 0;
801044a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801044ad:	00 00 00 
  p->fake[0] = '*';
801044b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b3:	c6 80 94 00 00 00 2a 	movb   $0x2a,0x94(%eax)
  p->fake[1] = '*';
801044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bd:	c6 80 95 00 00 00 2a 	movb   $0x2a,0x95(%eax)
  p->fake[2] = '*';
801044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c7:	c6 80 96 00 00 00 2a 	movb   $0x2a,0x96(%eax)
  p->fake[3] = '*';
801044ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d1:	c6 80 97 00 00 00 2a 	movb   $0x2a,0x97(%eax)
  p->fake[4] = '*';
801044d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044db:	c6 80 98 00 00 00 2a 	movb   $0x2a,0x98(%eax)
  p->fake[5] = '*';
801044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e5:	c6 80 99 00 00 00 2a 	movb   $0x2a,0x99(%eax)
  p->fake[6] = '*';
801044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ef:	c6 80 9a 00 00 00 2a 	movb   $0x2a,0x9a(%eax)
  p->fake[7] = '*';
801044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f9:	c6 80 9b 00 00 00 2a 	movb   $0x2a,0x9b(%eax)

  release(&ptable.lock);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	68 40 4e 11 80       	push   $0x80114e40
80104508:	e8 0b 0f 00 00       	call   80105418 <release>
8010450d:	83 c4 10             	add    $0x10,%esp
  if((p->kstack = kalloc()) == 0){
80104510:	e8 9e e7 ff ff       	call   80102cb3 <kalloc>
80104515:	89 c2                	mov    %eax,%edx
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	89 50 1c             	mov    %edx,0x1c(%eax)
8010451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104520:	8b 40 1c             	mov    0x1c(%eax),%eax
80104523:	85 c0                	test   %eax,%eax
80104525:	75 11                	jne    80104538 <allocproc+0x12d>
    p->state = UNUSED;
80104527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452a:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    return 0;
80104531:	b8 00 00 00 00       	mov    $0x0,%eax
80104536:	eb 5d                	jmp    80104595 <allocproc+0x18a>
  }
  sp = p->kstack + KSTACKSIZE;
80104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010453e:	05 00 10 00 00       	add    $0x1000,%eax
80104543:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sp -= sizeof *p->tf;
80104546:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010454a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104550:	89 50 28             	mov    %edx,0x28(%eax)

  sp -= 4;
80104553:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104557:	ba b0 6a 10 80       	mov    $0x80106ab0,%edx
8010455c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010455f:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104561:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010456b:	89 50 2c             	mov    %edx,0x2c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104571:	8b 40 2c             	mov    0x2c(%eax),%eax
80104574:	83 ec 04             	sub    $0x4,%esp
80104577:	6a 14                	push   $0x14
80104579:	6a 00                	push   $0x0
8010457b:	50                   	push   %eax
8010457c:	e8 a5 10 00 00       	call   80105626 <memset>
80104581:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 40 2c             	mov    0x2c(%eax),%eax
8010458a:	ba d5 4e 10 80       	mov    $0x80104ed5,%edx
8010458f:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104592:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104595:	c9                   	leave  
80104596:	c3                   	ret    

80104597 <userinit>:

void
userinit(void)
{
80104597:	55                   	push   %ebp
80104598:	89 e5                	mov    %esp,%ebp
8010459a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
8010459d:	e8 69 fe ff ff       	call   8010440b <allocproc>
801045a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  initproc = p;
801045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a8:	a3 64 c6 10 80       	mov    %eax,0x8010c664
  if((p->pgdir = setupkvm()) == 0)
801045ad:	e8 a8 3b 00 00       	call   8010815a <setupkvm>
801045b2:	89 c2                	mov    %eax,%edx
801045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b7:	89 50 18             	mov    %edx,0x18(%eax)
801045ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bd:	8b 40 18             	mov    0x18(%eax),%eax
801045c0:	85 c0                	test   %eax,%eax
801045c2:	75 0d                	jne    801045d1 <userinit+0x3a>
    panic("userinit: out of memory?");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 94 8c 10 80       	push   $0x80108c94
801045cc:	e8 cf bf ff ff       	call   801005a0 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801045d1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801045d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d9:	8b 40 18             	mov    0x18(%eax),%eax
801045dc:	83 ec 04             	sub    $0x4,%esp
801045df:	52                   	push   %edx
801045e0:	68 00 c5 10 80       	push   $0x8010c500
801045e5:	50                   	push   %eax
801045e6:	e8 a3 3d 00 00       	call   8010838e <inituvm>
801045eb:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f1:	c7 40 14 00 10 00 00 	movl   $0x1000,0x14(%eax)
  p->ctime = ticks;
801045f8:	8b 15 c0 7d 11 80    	mov    0x80117dc0,%edx
801045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104601:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->priority = 2;
80104604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104607:	c7 80 8c 00 00 00 02 	movl   $0x2,0x8c(%eax)
8010460e:	00 00 00 
  memset(p->tf, 0, sizeof(*p->tf));
80104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104614:	8b 40 28             	mov    0x28(%eax),%eax
80104617:	83 ec 04             	sub    $0x4,%esp
8010461a:	6a 4c                	push   $0x4c
8010461c:	6a 00                	push   $0x0
8010461e:	50                   	push   %eax
8010461f:	e8 02 10 00 00       	call   80105626 <memset>
80104624:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462a:	8b 40 28             	mov    0x28(%eax),%eax
8010462d:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104636:	8b 40 28             	mov    0x28(%eax),%eax
80104639:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	8b 40 28             	mov    0x28(%eax),%eax
80104645:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104648:	8b 52 28             	mov    0x28(%edx),%edx
8010464b:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010464f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	8b 40 28             	mov    0x28(%eax),%eax
80104659:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010465c:	8b 52 28             	mov    0x28(%edx),%edx
8010465f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104663:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466a:	8b 40 28             	mov    0x28(%eax),%eax
8010466d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104677:	8b 40 28             	mov    0x28(%eax),%eax
8010467a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;
80104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104684:	8b 40 28             	mov    0x28(%eax),%eax
80104687:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104691:	83 ec 04             	sub    $0x4,%esp
80104694:	6a 10                	push   $0x10
80104696:	68 ad 8c 10 80       	push   $0x80108cad
8010469b:	50                   	push   %eax
8010469c:	e8 88 11 00 00       	call   80105829 <safestrcpy>
801046a1:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	68 b6 8c 10 80       	push   $0x80108cb6
801046ac:	e8 96 de ff ff       	call   80102547 <namei>
801046b1:	83 c4 10             	add    $0x10,%esp
801046b4:	89 c2                	mov    %eax,%edx
801046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b9:	89 50 78             	mov    %edx,0x78(%eax)

  acquire(&ptable.lock);
801046bc:	83 ec 0c             	sub    $0xc,%esp
801046bf:	68 40 4e 11 80       	push   $0x80114e40
801046c4:	e8 e3 0c 00 00       	call   801053ac <acquire>
801046c9:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
801046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046cf:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)

  release(&ptable.lock);
801046d6:	83 ec 0c             	sub    $0xc,%esp
801046d9:	68 40 4e 11 80       	push   $0x80114e40
801046de:	e8 35 0d 00 00       	call   80105418 <release>
801046e3:	83 c4 10             	add    $0x10,%esp
}
801046e6:	90                   	nop
801046e7:	c9                   	leave  
801046e8:	c3                   	ret    

801046e9 <growproc>:

int
growproc(int n)
{
801046e9:	55                   	push   %ebp
801046ea:	89 e5                	mov    %esp,%ebp
801046ec:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
801046ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f5:	8b 40 14             	mov    0x14(%eax),%eax
801046f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801046fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046ff:	7e 31                	jle    80104732 <growproc+0x49>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104701:	8b 55 08             	mov    0x8(%ebp),%edx
80104704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104707:	01 c2                	add    %eax,%edx
80104709:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470f:	8b 40 18             	mov    0x18(%eax),%eax
80104712:	83 ec 04             	sub    $0x4,%esp
80104715:	52                   	push   %edx
80104716:	ff 75 f4             	pushl  -0xc(%ebp)
80104719:	50                   	push   %eax
8010471a:	e8 ac 3d 00 00       	call   801084cb <allocuvm>
8010471f:	83 c4 10             	add    $0x10,%esp
80104722:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104729:	75 3e                	jne    80104769 <growproc+0x80>
      return -1;
8010472b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104730:	eb 5a                	jmp    8010478c <growproc+0xa3>
  } else if(n < 0){
80104732:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104736:	79 31                	jns    80104769 <growproc+0x80>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473e:	01 c2                	add    %eax,%edx
80104740:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104746:	8b 40 18             	mov    0x18(%eax),%eax
80104749:	83 ec 04             	sub    $0x4,%esp
8010474c:	52                   	push   %edx
8010474d:	ff 75 f4             	pushl  -0xc(%ebp)
80104750:	50                   	push   %eax
80104751:	e8 7a 3e 00 00       	call   801085d0 <deallocuvm>
80104756:	83 c4 10             	add    $0x10,%esp
80104759:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010475c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104760:	75 07                	jne    80104769 <growproc+0x80>
      return -1;
80104762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104767:	eb 23                	jmp    8010478c <growproc+0xa3>
  }
  proc->sz = sz;
80104769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010476f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104772:	89 50 14             	mov    %edx,0x14(%eax)
  switchuvm(proc);
80104775:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477b:	83 ec 0c             	sub    $0xc,%esp
8010477e:	50                   	push   %eax
8010477f:	e8 92 3a 00 00       	call   80108216 <switchuvm>
80104784:	83 c4 10             	add    $0x10,%esp
  return 0;
80104787:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010478c:	c9                   	leave  
8010478d:	c3                   	ret    

8010478e <fork>:

int
fork(void)
{
8010478e:	55                   	push   %ebp
8010478f:	89 e5                	mov    %esp,%ebp
80104791:	57                   	push   %edi
80104792:	56                   	push   %esi
80104793:	53                   	push   %ebx
80104794:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80104797:	e8 6f fc ff ff       	call   8010440b <allocproc>
8010479c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010479f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047a3:	75 0a                	jne    801047af <fork+0x21>
    return -1;
801047a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047aa:	e9 67 01 00 00       	jmp    80104916 <fork+0x188>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801047af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b5:	8b 50 14             	mov    0x14(%eax),%edx
801047b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047be:	8b 40 18             	mov    0x18(%eax),%eax
801047c1:	83 ec 08             	sub    $0x8,%esp
801047c4:	52                   	push   %edx
801047c5:	50                   	push   %eax
801047c6:	e8 93 3f 00 00       	call   8010875e <copyuvm>
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	89 c2                	mov    %eax,%edx
801047d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d3:	89 50 18             	mov    %edx,0x18(%eax)
801047d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d9:	8b 40 18             	mov    0x18(%eax),%eax
801047dc:	85 c0                	test   %eax,%eax
801047de:	75 30                	jne    80104810 <fork+0x82>
    kfree(np->kstack);
801047e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e3:	8b 40 1c             	mov    0x1c(%eax),%eax
801047e6:	83 ec 0c             	sub    $0xc,%esp
801047e9:	50                   	push   %eax
801047ea:	e8 2a e4 ff ff       	call   80102c19 <kfree>
801047ef:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801047f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    np->state = UNUSED;
801047fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ff:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    return -1;
80104806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480b:	e9 06 01 00 00       	jmp    80104916 <fork+0x188>
  }
  np->sz = proc->sz;
80104810:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104816:	8b 50 14             	mov    0x14(%eax),%edx
80104819:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481c:	89 50 14             	mov    %edx,0x14(%eax)
  np->parent = proc;
8010481f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104826:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104829:	89 50 24             	mov    %edx,0x24(%eax)
  *np->tf = *proc->tf;
8010482c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010482f:	8b 50 28             	mov    0x28(%eax),%edx
80104832:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104838:	8b 40 28             	mov    0x28(%eax),%eax
8010483b:	89 c3                	mov    %eax,%ebx
8010483d:	b8 13 00 00 00       	mov    $0x13,%eax
80104842:	89 d7                	mov    %edx,%edi
80104844:	89 de                	mov    %ebx,%esi
80104846:	89 c1                	mov    %eax,%ecx
80104848:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010484a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010484d:	8b 40 28             	mov    0x28(%eax),%eax
80104850:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104857:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010485e:	eb 43                	jmp    801048a3 <fork+0x115>
    if(proc->ofile[i])
80104860:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104869:	83 c2 0c             	add    $0xc,%edx
8010486c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104870:	85 c0                	test   %eax,%eax
80104872:	74 2b                	je     8010489f <fork+0x111>
      np->ofile[i] = filedup(proc->ofile[i]);
80104874:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010487d:	83 c2 0c             	add    $0xc,%edx
80104880:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	50                   	push   %eax
80104888:	e8 e4 c7 ff ff       	call   80101071 <filedup>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	89 c1                	mov    %eax,%ecx
80104892:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104895:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104898:	83 c2 0c             	add    $0xc,%edx
8010489b:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010489f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048a3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048a7:	7e b7                	jle    80104860 <fork+0xd2>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801048a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048af:	8b 40 78             	mov    0x78(%eax),%eax
801048b2:	83 ec 0c             	sub    $0xc,%esp
801048b5:	50                   	push   %eax
801048b6:	e8 2c d1 ff ff       	call   801019e7 <idup>
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	89 c2                	mov    %eax,%edx
801048c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c3:	89 50 78             	mov    %edx,0x78(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801048c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048cc:	89 c2                	mov    %eax,%edx
801048ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d1:	83 ec 04             	sub    $0x4,%esp
801048d4:	6a 10                	push   $0x10
801048d6:	52                   	push   %edx
801048d7:	50                   	push   %eax
801048d8:	e8 4c 0f 00 00       	call   80105829 <safestrcpy>
801048dd:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
801048e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048e3:	8b 40 10             	mov    0x10(%eax),%eax
801048e6:	89 45 dc             	mov    %eax,-0x24(%ebp)

  acquire(&ptable.lock);
801048e9:	83 ec 0c             	sub    $0xc,%esp
801048ec:	68 40 4e 11 80       	push   $0x80114e40
801048f1:	e8 b6 0a 00 00       	call   801053ac <acquire>
801048f6:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
801048f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fc:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)

  release(&ptable.lock);
80104903:	83 ec 0c             	sub    $0xc,%esp
80104906:	68 40 4e 11 80       	push   $0x80114e40
8010490b:	e8 08 0b 00 00       	call   80105418 <release>
80104910:	83 c4 10             	add    $0x10,%esp

  return pid;
80104913:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104916:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5f                   	pop    %edi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    

8010491e <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010491e:	55                   	push   %ebp
8010491f:	89 e5                	mov    %esp,%ebp
80104921:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104924:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010492b:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104930:	39 c2                	cmp    %eax,%edx
80104932:	75 0d                	jne    80104941 <exit+0x23>
    panic("init exiting");
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	68 b8 8c 10 80       	push   $0x80108cb8
8010493c:	e8 5f bc ff ff       	call   801005a0 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104941:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104948:	eb 48                	jmp    80104992 <exit+0x74>
    if(proc->ofile[fd]){
8010494a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104950:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104953:	83 c2 0c             	add    $0xc,%edx
80104956:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010495a:	85 c0                	test   %eax,%eax
8010495c:	74 30                	je     8010498e <exit+0x70>
      fileclose(proc->ofile[fd]);
8010495e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104964:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104967:	83 c2 0c             	add    $0xc,%edx
8010496a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010496e:	83 ec 0c             	sub    $0xc,%esp
80104971:	50                   	push   %eax
80104972:	e8 4b c7 ff ff       	call   801010c2 <fileclose>
80104977:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
8010497a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104980:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104983:	83 c2 0c             	add    $0xc,%edx
80104986:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010498d:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010498e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104992:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104996:	7e b2                	jle    8010494a <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104998:	e8 42 ec ff ff       	call   801035df <begin_op>
  iput(proc->cwd);
8010499d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a3:	8b 40 78             	mov    0x78(%eax),%eax
801049a6:	83 ec 0c             	sub    $0xc,%esp
801049a9:	50                   	push   %eax
801049aa:	e8 dd d1 ff ff       	call   80101b8c <iput>
801049af:	83 c4 10             	add    $0x10,%esp
  end_op();
801049b2:	e8 b4 ec ff ff       	call   8010366b <end_op>
  proc->cwd = 0;
801049b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049bd:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)

  acquire(&ptable.lock);
801049c4:	83 ec 0c             	sub    $0xc,%esp
801049c7:	68 40 4e 11 80       	push   $0x80114e40
801049cc:	e8 db 09 00 00       	call   801053ac <acquire>
801049d1:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801049d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049da:	8b 40 24             	mov    0x24(%eax),%eax
801049dd:	83 ec 0c             	sub    $0xc,%esp
801049e0:	50                   	push   %eax
801049e1:	e8 e1 05 00 00       	call   80104fc7 <wakeup1>
801049e6:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e9:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
801049f0:	eb 3f                	jmp    80104a31 <exit+0x113>
    if(p->parent == proc){
801049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f5:	8b 50 24             	mov    0x24(%eax),%edx
801049f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fe:	39 c2                	cmp    %eax,%edx
80104a00:	75 28                	jne    80104a2a <exit+0x10c>
      p->parent = initproc;
80104a02:	8b 15 64 c6 10 80    	mov    0x8010c664,%edx
80104a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0b:	89 50 24             	mov    %edx,0x24(%eax)
      if(p->state == ZOMBIE)
80104a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a11:	8b 40 20             	mov    0x20(%eax),%eax
80104a14:	83 f8 05             	cmp    $0x5,%eax
80104a17:	75 11                	jne    80104a2a <exit+0x10c>
        wakeup1(initproc);
80104a19:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80104a1e:	83 ec 0c             	sub    $0xc,%esp
80104a21:	50                   	push   %eax
80104a22:	e8 a0 05 00 00       	call   80104fc7 <wakeup1>
80104a27:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2a:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104a31:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80104a38:	72 b8                	jb     801049f2 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a40:	c7 40 20 05 00 00 00 	movl   $0x5,0x20(%eax)
  sched();
80104a47:	e8 92 03 00 00       	call   80104dde <sched>
  panic("zombie exit");
80104a4c:	83 ec 0c             	sub    $0xc,%esp
80104a4f:	68 c5 8c 10 80       	push   $0x80108cc5
80104a54:	e8 47 bb ff ff       	call   801005a0 <panic>

80104a59 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a59:	55                   	push   %ebp
80104a5a:	89 e5                	mov    %esp,%ebp
80104a5c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 40 4e 11 80       	push   $0x80114e40
80104a67:	e8 40 09 00 00       	call   801053ac <acquire>
80104a6c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104a6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a76:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104a7d:	e9 a8 00 00 00       	jmp    80104b2a <wait+0xd1>
      if(p->parent != proc)
80104a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a85:	8b 50 24             	mov    0x24(%eax),%edx
80104a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8e:	39 c2                	cmp    %eax,%edx
80104a90:	0f 85 8c 00 00 00    	jne    80104b22 <wait+0xc9>
        continue;
      havekids = 1;
80104a96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa0:	8b 40 20             	mov    0x20(%eax),%eax
80104aa3:	83 f8 05             	cmp    $0x5,%eax
80104aa6:	75 7b                	jne    80104b23 <wait+0xca>
        // Found one.
        pid = p->pid;
80104aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aab:	8b 40 10             	mov    0x10(%eax),%eax
80104aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab4:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ab7:	83 ec 0c             	sub    $0xc,%esp
80104aba:	50                   	push   %eax
80104abb:	e8 59 e1 ff ff       	call   80102c19 <kfree>
80104ac0:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        freevm(p->pgdir);
80104acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad0:	8b 40 18             	mov    0x18(%eax),%eax
80104ad3:	83 ec 0c             	sub    $0xc,%esp
80104ad6:	50                   	push   %eax
80104ad7:	e8 a8 3b 00 00       	call   80108684 <freevm>
80104adc:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->name[0] = 0;
80104af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af6:	c6 00 00             	movb   $0x0,(%eax)
        p->killed = 0;
80104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afc:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
        p->state = UNUSED;
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
        release(&ptable.lock);
80104b0d:	83 ec 0c             	sub    $0xc,%esp
80104b10:	68 40 4e 11 80       	push   $0x80114e40
80104b15:	e8 fe 08 00 00       	call   80105418 <release>
80104b1a:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b20:	eb 5b                	jmp    80104b7d <wait+0x124>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104b22:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b23:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104b2a:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80104b31:	0f 82 4b ff ff ff    	jb     80104a82 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b3b:	74 0d                	je     80104b4a <wait+0xf1>
80104b3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b43:	8b 40 34             	mov    0x34(%eax),%eax
80104b46:	85 c0                	test   %eax,%eax
80104b48:	74 17                	je     80104b61 <wait+0x108>
      release(&ptable.lock);
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	68 40 4e 11 80       	push   $0x80114e40
80104b52:	e8 c1 08 00 00       	call   80105418 <release>
80104b57:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b5f:	eb 1c                	jmp    80104b7d <wait+0x124>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b67:	83 ec 08             	sub    $0x8,%esp
80104b6a:	68 40 4e 11 80       	push   $0x80114e40
80104b6f:	50                   	push   %eax
80104b70:	e8 a6 03 00 00       	call   80104f1b <sleep>
80104b75:	83 c4 10             	add    $0x10,%esp
  }
80104b78:	e9 f2 fe ff ff       	jmp    80104a6f <wait+0x16>
}
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    

80104b7f <wait2>:

int wait2(int *retime, int *rutime, int *stime) {
80104b7f:	55                   	push   %ebp
80104b80:	89 e5                	mov    %esp,%ebp
80104b82:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids;
  acquire(&ptable.lock);
80104b85:	83 ec 0c             	sub    $0xc,%esp
80104b88:	68 40 4e 11 80       	push   $0x80114e40
80104b8d:	e8 1a 08 00 00       	call   801053ac <acquire>
80104b92:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b9c:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104ba3:	e9 03 01 00 00       	jmp    80104cab <wait2+0x12c>
      if(p->parent != proc)
80104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bab:	8b 50 24             	mov    0x24(%eax),%edx
80104bae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb4:	39 c2                	cmp    %eax,%edx
80104bb6:	0f 85 e7 00 00 00    	jne    80104ca3 <wait2+0x124>
        continue;
      havekids = 1;
80104bbc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc6:	8b 40 20             	mov    0x20(%eax),%eax
80104bc9:	83 f8 05             	cmp    $0x5,%eax
80104bcc:	0f 85 d2 00 00 00    	jne    80104ca4 <wait2+0x125>
        // Found one.
        *retime = p->retime;
80104bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80104bde:	89 10                	mov    %edx,(%eax)
        *rutime = p->rutime;
80104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be3:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104be9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bec:	89 10                	mov    %edx,(%eax)
        *stime = p->stime;
80104bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf1:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104bf7:	8b 45 10             	mov    0x10(%ebp),%eax
80104bfa:	89 10                	mov    %edx,(%eax)
        //pid = p->pid;
        kfree(p->kstack);
80104bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bff:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c02:	83 ec 0c             	sub    $0xc,%esp
80104c05:	50                   	push   %eax
80104c06:	e8 0e e0 ff ff       	call   80102c19 <kfree>
80104c0b:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c11:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        freevm(p->pgdir);
80104c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1b:	8b 40 18             	mov    0x18(%eax),%eax
80104c1e:	83 ec 0c             	sub    $0xc,%esp
80104c21:	50                   	push   %eax
80104c22:	e8 5d 3a 00 00       	call   80108684 <freevm>
80104c27:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
        //p->pid = 0;
        p->parent = 0;
80104c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c37:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->name[0] = 0;
80104c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c41:	c6 00 00             	movb   $0x0,(%eax)
        p->killed = 0;
80104c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c47:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%eax)
        p->ctime = 0;
80104c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c51:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
        p->retime = 0;
80104c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104c62:	00 00 00 
        p->rutime = 0;
80104c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c68:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104c6f:	00 00 00 
        p->stime = 0;
80104c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c75:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104c7c:	00 00 00 
        p->priority = 0;
80104c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c82:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104c89:	00 00 00 
        release(&ptable.lock);
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	68 40 4e 11 80       	push   $0x80114e40
80104c94:	e8 7f 07 00 00       	call   80105418 <release>
80104c99:	83 c4 10             	add    $0x10,%esp
//////////////
	//printf("runtime = %d , waiting time = %d\n" , rutime , stime );
//////////////
        return *rutime;
80104c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9f:	8b 00                	mov    (%eax),%eax
80104ca1:	eb 5b                	jmp    80104cfe <wait2+0x17f>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104ca3:	90                   	nop
  int havekids;
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ca4:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104cab:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80104cb2:	0f 82 f0 fe ff ff    	jb     80104ba8 <wait2+0x29>
        return *rutime;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104cb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104cbc:	74 0d                	je     80104ccb <wait2+0x14c>
80104cbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc4:	8b 40 34             	mov    0x34(%eax),%eax
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	74 17                	je     80104ce2 <wait2+0x163>
      release(&ptable.lock);
80104ccb:	83 ec 0c             	sub    $0xc,%esp
80104cce:	68 40 4e 11 80       	push   $0x80114e40
80104cd3:	e8 40 07 00 00       	call   80105418 <release>
80104cd8:	83 c4 10             	add    $0x10,%esp
      return -1;
80104cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce0:	eb 1c                	jmp    80104cfe <wait2+0x17f>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104ce2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce8:	83 ec 08             	sub    $0x8,%esp
80104ceb:	68 40 4e 11 80       	push   $0x80114e40
80104cf0:	50                   	push   %eax
80104cf1:	e8 25 02 00 00       	call   80104f1b <sleep>
80104cf6:	83 c4 10             	add    $0x10,%esp
  }
80104cf9:	e9 97 fe ff ff       	jmp    80104b95 <wait2+0x16>
}
80104cfe:	c9                   	leave  
80104cff:	c3                   	ret    

80104d00 <scheduler>:
  return 0;
}
#endif
void
scheduler(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int index1 = 0;
80104d06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int index2 = 0;
80104d0d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int index3 = 0;
80104d14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int x = index1;
80104d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  index1 = x;
80104d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  x = index2;
80104d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  index2 = x;
80104d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  x = index3;
80104d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104d36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  index3 = x;
80104d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d3c:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for(;;){
    sti();
80104d3f:	e8 a2 f6 ff ff       	call   801043e6 <sti>
    acquire(&ptable.lock);
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	68 40 4e 11 80       	push   $0x80114e40
80104d4c:	e8 5b 06 00 00       	call   801053ac <acquire>
80104d51:	83 c4 10             	add    $0x10,%esp

    #ifdef RR
    //cprintf("default\n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d54:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
80104d5b:	eb 63                	jmp    80104dc0 <scheduler+0xc0>
      if(p->state != RUNNABLE)
80104d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d60:	8b 40 20             	mov    0x20(%eax),%eax
80104d63:	83 f8 03             	cmp    $0x3,%eax
80104d66:	75 50                	jne    80104db8 <scheduler+0xb8>
        continue;
      proc = p;
80104d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104d71:	83 ec 0c             	sub    $0xc,%esp
80104d74:	ff 75 f4             	pushl  -0xc(%ebp)
80104d77:	e8 9a 34 00 00       	call   80108216 <switchuvm>
80104d7c:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d82:	c7 40 20 04 00 00 00 	movl   $0x4,0x20(%eax)
      swtch(&cpu->scheduler, p->context);
80104d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8c:	8b 40 2c             	mov    0x2c(%eax),%eax
80104d8f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d96:	83 c2 04             	add    $0x4,%edx
80104d99:	83 ec 08             	sub    $0x8,%esp
80104d9c:	50                   	push   %eax
80104d9d:	52                   	push   %edx
80104d9e:	e8 f7 0a 00 00       	call   8010589a <swtch>
80104da3:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104da6:	e8 52 34 00 00       	call   801081fd <switchkvm>
      proc = 0;
80104dab:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104db2:	00 00 00 00 
80104db6:	eb 01                	jmp    80104db9 <scheduler+0xb9>

    #ifdef RR
    //cprintf("default\n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104db8:	90                   	nop
    sti();
    acquire(&ptable.lock);

    #ifdef RR
    //cprintf("default\n");
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db9:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104dc0:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80104dc7:	72 94                	jb     80104d5d <scheduler+0x5d>
    #endif
    #endif
    #endif


    release(&ptable.lock);
80104dc9:	83 ec 0c             	sub    $0xc,%esp
80104dcc:	68 40 4e 11 80       	push   $0x80114e40
80104dd1:	e8 42 06 00 00       	call   80105418 <release>
80104dd6:	83 c4 10             	add    $0x10,%esp

  }
80104dd9:	e9 61 ff ff ff       	jmp    80104d3f <scheduler+0x3f>

80104dde <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104dde:	55                   	push   %ebp
80104ddf:	89 e5                	mov    %esp,%ebp
80104de1:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	68 40 4e 11 80       	push   $0x80114e40
80104dec:	e8 f3 06 00 00       	call   801054e4 <holding>
80104df1:	83 c4 10             	add    $0x10,%esp
80104df4:	85 c0                	test   %eax,%eax
80104df6:	75 0d                	jne    80104e05 <sched+0x27>
    panic("sched ptable.lock");
80104df8:	83 ec 0c             	sub    $0xc,%esp
80104dfb:	68 d1 8c 10 80       	push   $0x80108cd1
80104e00:	e8 9b b7 ff ff       	call   801005a0 <panic>
  if(cpu->ncli != 1)
80104e05:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e0b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e11:	83 f8 01             	cmp    $0x1,%eax
80104e14:	74 0d                	je     80104e23 <sched+0x45>
    panic("sched locks");
80104e16:	83 ec 0c             	sub    $0xc,%esp
80104e19:	68 e3 8c 10 80       	push   $0x80108ce3
80104e1e:	e8 7d b7 ff ff       	call   801005a0 <panic>
  if(proc->state == RUNNING)
80104e23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e29:	8b 40 20             	mov    0x20(%eax),%eax
80104e2c:	83 f8 04             	cmp    $0x4,%eax
80104e2f:	75 0d                	jne    80104e3e <sched+0x60>
    panic("sched running");
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	68 ef 8c 10 80       	push   $0x80108cef
80104e39:	e8 62 b7 ff ff       	call   801005a0 <panic>
  if(readeflags()&FL_IF)
80104e3e:	e8 93 f5 ff ff       	call   801043d6 <readeflags>
80104e43:	25 00 02 00 00       	and    $0x200,%eax
80104e48:	85 c0                	test   %eax,%eax
80104e4a:	74 0d                	je     80104e59 <sched+0x7b>
    panic("sched interruptible");
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	68 fd 8c 10 80       	push   $0x80108cfd
80104e54:	e8 47 b7 ff ff       	call   801005a0 <panic>
  intena = cpu->intena;
80104e59:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e5f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104e68:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e6e:	8b 40 04             	mov    0x4(%eax),%eax
80104e71:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e78:	83 c2 2c             	add    $0x2c,%edx
80104e7b:	83 ec 08             	sub    $0x8,%esp
80104e7e:	50                   	push   %eax
80104e7f:	52                   	push   %edx
80104e80:	e8 15 0a 00 00       	call   8010589a <swtch>
80104e85:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104e88:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e91:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
		cprintf("<%d>,", (int)(p1->pid));
     }
  //cprintf("\n-----------------------------------------\n");
  #endif

}
80104e97:	90                   	nop
80104e98:	c9                   	leave  
80104e99:	c3                   	ret    

80104e9a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104e9a:	55                   	push   %ebp
80104e9b:	89 e5                	mov    %esp,%ebp
80104e9d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	68 40 4e 11 80       	push   $0x80114e40
80104ea8:	e8 ff 04 00 00       	call   801053ac <acquire>
80104ead:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104eb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb6:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
  sched();
80104ebd:	e8 1c ff ff ff       	call   80104dde <sched>
  release(&ptable.lock);
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 40 4e 11 80       	push   $0x80114e40
80104eca:	e8 49 05 00 00       	call   80105418 <release>
80104ecf:	83 c4 10             	add    $0x10,%esp
}
80104ed2:	90                   	nop
80104ed3:	c9                   	leave  
80104ed4:	c3                   	ret    

80104ed5 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ed5:	55                   	push   %ebp
80104ed6:	89 e5                	mov    %esp,%ebp
80104ed8:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	68 40 4e 11 80       	push   $0x80114e40
80104ee3:	e8 30 05 00 00       	call   80105418 <release>
80104ee8:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104eeb:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	74 24                	je     80104f18 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104ef4:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104efb:	00 00 00 
    iinit(ROOTDEV);
80104efe:	83 ec 0c             	sub    $0xc,%esp
80104f01:	6a 01                	push   $0x1
80104f03:	e8 a7 c7 ff ff       	call   801016af <iinit>
80104f08:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104f0b:	83 ec 0c             	sub    $0xc,%esp
80104f0e:	6a 01                	push   $0x1
80104f10:	e8 ac e4 ff ff       	call   801033c1 <initlog>
80104f15:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104f18:	90                   	nop
80104f19:	c9                   	leave  
80104f1a:	c3                   	ret    

80104f1b <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104f1b:	55                   	push   %ebp
80104f1c:	89 e5                	mov    %esp,%ebp
80104f1e:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104f21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f27:	85 c0                	test   %eax,%eax
80104f29:	75 0d                	jne    80104f38 <sleep+0x1d>
    panic("sleep");
80104f2b:	83 ec 0c             	sub    $0xc,%esp
80104f2e:	68 11 8d 10 80       	push   $0x80108d11
80104f33:	e8 68 b6 ff ff       	call   801005a0 <panic>

  if(lk == 0)
80104f38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f3c:	75 0d                	jne    80104f4b <sleep+0x30>
    panic("sleep without lk");
80104f3e:	83 ec 0c             	sub    $0xc,%esp
80104f41:	68 17 8d 10 80       	push   $0x80108d17
80104f46:	e8 55 b6 ff ff       	call   801005a0 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104f4b:	81 7d 0c 40 4e 11 80 	cmpl   $0x80114e40,0xc(%ebp)
80104f52:	74 1e                	je     80104f72 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104f54:	83 ec 0c             	sub    $0xc,%esp
80104f57:	68 40 4e 11 80       	push   $0x80114e40
80104f5c:	e8 4b 04 00 00       	call   801053ac <acquire>
80104f61:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	ff 75 0c             	pushl  0xc(%ebp)
80104f6a:	e8 a9 04 00 00       	call   80105418 <release>
80104f6f:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104f72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f78:	8b 55 08             	mov    0x8(%ebp),%edx
80104f7b:	89 50 30             	mov    %edx,0x30(%eax)
  proc->state = SLEEPING;
80104f7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f84:	c7 40 20 02 00 00 00 	movl   $0x2,0x20(%eax)
  sched();
80104f8b:	e8 4e fe ff ff       	call   80104dde <sched>

  // Tidy up.
  proc->chan = 0;
80104f90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f96:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f9d:	81 7d 0c 40 4e 11 80 	cmpl   $0x80114e40,0xc(%ebp)
80104fa4:	74 1e                	je     80104fc4 <sleep+0xa9>
    release(&ptable.lock);
80104fa6:	83 ec 0c             	sub    $0xc,%esp
80104fa9:	68 40 4e 11 80       	push   $0x80114e40
80104fae:	e8 65 04 00 00       	call   80105418 <release>
80104fb3:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104fb6:	83 ec 0c             	sub    $0xc,%esp
80104fb9:	ff 75 0c             	pushl  0xc(%ebp)
80104fbc:	e8 eb 03 00 00       	call   801053ac <acquire>
80104fc1:	83 c4 10             	add    $0x10,%esp
  }
}
80104fc4:	90                   	nop
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    

80104fc7 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104fc7:	55                   	push   %ebp
80104fc8:	89 e5                	mov    %esp,%ebp
80104fca:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fcd:	c7 45 fc 74 4e 11 80 	movl   $0x80114e74,-0x4(%ebp)
80104fd4:	eb 27                	jmp    80104ffd <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd9:	8b 40 20             	mov    0x20(%eax),%eax
80104fdc:	83 f8 02             	cmp    $0x2,%eax
80104fdf:	75 15                	jne    80104ff6 <wakeup1+0x2f>
80104fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fe4:	8b 40 30             	mov    0x30(%eax),%eax
80104fe7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fea:	75 0a                	jne    80104ff6 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fef:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff6:	81 45 fc 9c 00 00 00 	addl   $0x9c,-0x4(%ebp)
80104ffd:	81 7d fc 74 75 11 80 	cmpl   $0x80117574,-0x4(%ebp)
80105004:	72 d0                	jb     80104fd6 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80105006:	90                   	nop
80105007:	c9                   	leave  
80105008:	c3                   	ret    

80105009 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105009:	55                   	push   %ebp
8010500a:	89 e5                	mov    %esp,%ebp
8010500c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	68 40 4e 11 80       	push   $0x80114e40
80105017:	e8 90 03 00 00       	call   801053ac <acquire>
8010501c:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
8010501f:	83 ec 0c             	sub    $0xc,%esp
80105022:	ff 75 08             	pushl  0x8(%ebp)
80105025:	e8 9d ff ff ff       	call   80104fc7 <wakeup1>
8010502a:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	68 40 4e 11 80       	push   $0x80114e40
80105035:	e8 de 03 00 00       	call   80105418 <release>
8010503a:	83 c4 10             	add    $0x10,%esp
}
8010503d:	90                   	nop
8010503e:	c9                   	leave  
8010503f:	c3                   	ret    

80105040 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105046:	83 ec 0c             	sub    $0xc,%esp
80105049:	68 40 4e 11 80       	push   $0x80114e40
8010504e:	e8 59 03 00 00       	call   801053ac <acquire>
80105053:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105056:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
8010505d:	eb 48                	jmp    801050a7 <kill+0x67>
    if(p->pid == pid){
8010505f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105062:	8b 40 10             	mov    0x10(%eax),%eax
80105065:	3b 45 08             	cmp    0x8(%ebp),%eax
80105068:	75 36                	jne    801050a0 <kill+0x60>
      p->killed = 1;
8010506a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506d:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105077:	8b 40 20             	mov    0x20(%eax),%eax
8010507a:	83 f8 02             	cmp    $0x2,%eax
8010507d:	75 0a                	jne    80105089 <kill+0x49>
        p->state = RUNNABLE;
8010507f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105082:	c7 40 20 03 00 00 00 	movl   $0x3,0x20(%eax)
      release(&ptable.lock);
80105089:	83 ec 0c             	sub    $0xc,%esp
8010508c:	68 40 4e 11 80       	push   $0x80114e40
80105091:	e8 82 03 00 00       	call   80105418 <release>
80105096:	83 c4 10             	add    $0x10,%esp
      return 0;
80105099:	b8 00 00 00 00       	mov    $0x0,%eax
8010509e:	eb 25                	jmp    801050c5 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050a0:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
801050a7:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
801050ae:	72 af                	jb     8010505f <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	68 40 4e 11 80       	push   $0x80114e40
801050b8:	e8 5b 03 00 00       	call   80105418 <release>
801050bd:	83 c4 10             	add    $0x10,%esp
  return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    

801050c7 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801050c7:	55                   	push   %ebp
801050c8:	89 e5                	mov    %esp,%ebp
801050ca:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050cd:	c7 45 f0 74 4e 11 80 	movl   $0x80114e74,-0x10(%ebp)
801050d4:	e9 d7 00 00 00       	jmp    801051b0 <procdump+0xe9>
    if(p->state == UNUSED)
801050d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050dc:	8b 40 20             	mov    0x20(%eax),%eax
801050df:	85 c0                	test   %eax,%eax
801050e1:	0f 84 c1 00 00 00    	je     801051a8 <procdump+0xe1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ea:	8b 40 20             	mov    0x20(%eax),%eax
801050ed:	83 f8 05             	cmp    $0x5,%eax
801050f0:	77 23                	ja     80105115 <procdump+0x4e>
801050f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f5:	8b 40 20             	mov    0x20(%eax),%eax
801050f8:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801050ff:	85 c0                	test   %eax,%eax
80105101:	74 12                	je     80105115 <procdump+0x4e>
      state = states[p->state];
80105103:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105106:	8b 40 20             	mov    0x20(%eax),%eax
80105109:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105110:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105113:	eb 07                	jmp    8010511c <procdump+0x55>
    else
      state = "???";
80105115:	c7 45 ec 28 8d 10 80 	movl   $0x80108d28,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010511c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010511f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105122:	8b 40 10             	mov    0x10(%eax),%eax
80105125:	52                   	push   %edx
80105126:	ff 75 ec             	pushl  -0x14(%ebp)
80105129:	50                   	push   %eax
8010512a:	68 2c 8d 10 80       	push   $0x80108d2c
8010512f:	e8 cc b2 ff ff       	call   80100400 <cprintf>
80105134:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513a:	8b 40 20             	mov    0x20(%eax),%eax
8010513d:	83 f8 02             	cmp    $0x2,%eax
80105140:	75 54                	jne    80105196 <procdump+0xcf>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105145:	8b 40 2c             	mov    0x2c(%eax),%eax
80105148:	8b 40 0c             	mov    0xc(%eax),%eax
8010514b:	83 c0 08             	add    $0x8,%eax
8010514e:	89 c2                	mov    %eax,%edx
80105150:	83 ec 08             	sub    $0x8,%esp
80105153:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105156:	50                   	push   %eax
80105157:	52                   	push   %edx
80105158:	e8 0d 03 00 00       	call   8010546a <getcallerpcs>
8010515d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105167:	eb 1c                	jmp    80105185 <procdump+0xbe>
        cprintf(" %p", pc[i]);
80105169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105170:	83 ec 08             	sub    $0x8,%esp
80105173:	50                   	push   %eax
80105174:	68 35 8d 10 80       	push   $0x80108d35
80105179:	e8 82 b2 ff ff       	call   80100400 <cprintf>
8010517e:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105181:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105185:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105189:	7f 0b                	jg     80105196 <procdump+0xcf>
8010518b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105192:	85 c0                	test   %eax,%eax
80105194:	75 d3                	jne    80105169 <procdump+0xa2>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105196:	83 ec 0c             	sub    $0xc,%esp
80105199:	68 39 8d 10 80       	push   $0x80108d39
8010519e:	e8 5d b2 ff ff       	call   80100400 <cprintf>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	eb 01                	jmp    801051a9 <procdump+0xe2>
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801051a8:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051a9:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
801051b0:	81 7d f0 74 75 11 80 	cmpl   $0x80117574,-0x10(%ebp)
801051b7:	0f 82 1c ff ff ff    	jb     801050d9 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051bd:	90                   	nop
801051be:	c9                   	leave  
801051bf:	c3                   	ret    

801051c0 <getppid>:
//new function to get pid of parent of a process
int
getppid(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
	return 13;
801051c3:	b8 0d 00 00 00       	mov    $0xd,%eax
}
801051c8:	5d                   	pop    %ebp
801051c9:	c3                   	ret    

801051ca <nice>:

//nice
void
nice(int pid)
{
801051ca:	55                   	push   %ebp
801051cb:	89 e5                	mov    %esp,%ebp
801051cd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	68 40 4e 11 80       	push   $0x80114e40
801051d8:	e8 cf 01 00 00       	call   801053ac <acquire>
801051dd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051e0:	c7 45 f4 74 4e 11 80 	movl   $0x80114e74,-0xc(%ebp)
801051e7:	eb 27                	jmp    80105210 <nice+0x46>
    if(p->pid == pid){
801051e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ec:	8b 40 10             	mov    0x10(%eax),%eax
801051ef:	3b 45 08             	cmp    0x8(%ebp),%eax
801051f2:	75 15                	jne    80105209 <nice+0x3f>
      p->priority --;
801051f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801051fd:	8d 50 ff             	lea    -0x1(%eax),%edx
80105200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105203:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
nice(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105209:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105210:	81 7d f4 74 75 11 80 	cmpl   $0x80117574,-0xc(%ebp)
80105217:	72 d0                	jb     801051e9 <nice+0x1f>
    if(p->pid == pid){
      p->priority --;
    }
  }
  release(&ptable.lock);
80105219:	83 ec 0c             	sub    $0xc,%esp
8010521c:	68 40 4e 11 80       	push   $0x80114e40
80105221:	e8 f2 01 00 00       	call   80105418 <release>
80105226:	83 c4 10             	add    $0x10,%esp
}
80105229:	90                   	nop
8010522a:	c9                   	leave  
8010522b:	c3                   	ret    

8010522c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
8010522c:	55                   	push   %ebp
8010522d:	89 e5                	mov    %esp,%ebp
8010522f:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
80105232:	8b 45 08             	mov    0x8(%ebp),%eax
80105235:	83 c0 04             	add    $0x4,%eax
80105238:	83 ec 08             	sub    $0x8,%esp
8010523b:	68 65 8d 10 80       	push   $0x80108d65
80105240:	50                   	push   %eax
80105241:	e8 44 01 00 00       	call   8010538a <initlock>
80105246:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80105249:	8b 45 08             	mov    0x8(%ebp),%eax
8010524c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010524f:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80105252:	8b 45 08             	mov    0x8(%ebp),%eax
80105255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010525b:	8b 45 08             	mov    0x8(%ebp),%eax
8010525e:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80105265:	90                   	nop
80105266:	c9                   	leave  
80105267:	c3                   	ret    

80105268 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105268:	55                   	push   %ebp
80105269:	89 e5                	mov    %esp,%ebp
8010526b:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
8010526e:	8b 45 08             	mov    0x8(%ebp),%eax
80105271:	83 c0 04             	add    $0x4,%eax
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	50                   	push   %eax
80105278:	e8 2f 01 00 00       	call   801053ac <acquire>
8010527d:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105280:	eb 15                	jmp    80105297 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80105282:	8b 45 08             	mov    0x8(%ebp),%eax
80105285:	83 c0 04             	add    $0x4,%eax
80105288:	83 ec 08             	sub    $0x8,%esp
8010528b:	50                   	push   %eax
8010528c:	ff 75 08             	pushl  0x8(%ebp)
8010528f:	e8 87 fc ff ff       	call   80104f1b <sleep>
80105294:	83 c4 10             	add    $0x10,%esp

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80105297:	8b 45 08             	mov    0x8(%ebp),%eax
8010529a:	8b 00                	mov    (%eax),%eax
8010529c:	85 c0                	test   %eax,%eax
8010529e:	75 e2                	jne    80105282 <acquiresleep+0x1a>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801052a0:	8b 45 08             	mov    0x8(%ebp),%eax
801052a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = proc->pid;
801052a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052af:	8b 50 10             	mov    0x10(%eax),%edx
801052b2:	8b 45 08             	mov    0x8(%ebp),%eax
801052b5:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
801052b8:	8b 45 08             	mov    0x8(%ebp),%eax
801052bb:	83 c0 04             	add    $0x4,%eax
801052be:	83 ec 0c             	sub    $0xc,%esp
801052c1:	50                   	push   %eax
801052c2:	e8 51 01 00 00       	call   80105418 <release>
801052c7:	83 c4 10             	add    $0x10,%esp
}
801052ca:	90                   	nop
801052cb:	c9                   	leave  
801052cc:	c3                   	ret    

801052cd <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801052cd:	55                   	push   %ebp
801052ce:	89 e5                	mov    %esp,%ebp
801052d0:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801052d3:	8b 45 08             	mov    0x8(%ebp),%eax
801052d6:	83 c0 04             	add    $0x4,%eax
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	50                   	push   %eax
801052dd:	e8 ca 00 00 00       	call   801053ac <acquire>
801052e2:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801052e5:	8b 45 08             	mov    0x8(%ebp),%eax
801052e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801052ee:	8b 45 08             	mov    0x8(%ebp),%eax
801052f1:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	ff 75 08             	pushl  0x8(%ebp)
801052fe:	e8 06 fd ff ff       	call   80105009 <wakeup>
80105303:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80105306:	8b 45 08             	mov    0x8(%ebp),%eax
80105309:	83 c0 04             	add    $0x4,%eax
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	50                   	push   %eax
80105310:	e8 03 01 00 00       	call   80105418 <release>
80105315:	83 c4 10             	add    $0x10,%esp
}
80105318:	90                   	nop
80105319:	c9                   	leave  
8010531a:	c3                   	ret    

8010531b <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010531b:	55                   	push   %ebp
8010531c:	89 e5                	mov    %esp,%ebp
8010531e:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
80105321:	8b 45 08             	mov    0x8(%ebp),%eax
80105324:	83 c0 04             	add    $0x4,%eax
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	50                   	push   %eax
8010532b:	e8 7c 00 00 00       	call   801053ac <acquire>
80105330:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
80105333:	8b 45 08             	mov    0x8(%ebp),%eax
80105336:	8b 00                	mov    (%eax),%eax
80105338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010533b:	8b 45 08             	mov    0x8(%ebp),%eax
8010533e:	83 c0 04             	add    $0x4,%eax
80105341:	83 ec 0c             	sub    $0xc,%esp
80105344:	50                   	push   %eax
80105345:	e8 ce 00 00 00       	call   80105418 <release>
8010534a:	83 c4 10             	add    $0x10,%esp
  return r;
8010534d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105350:	c9                   	leave  
80105351:	c3                   	ret    

80105352 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105352:	55                   	push   %ebp
80105353:	89 e5                	mov    %esp,%ebp
80105355:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105358:	9c                   	pushf  
80105359:	58                   	pop    %eax
8010535a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010535d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105360:	c9                   	leave  
80105361:	c3                   	ret    

80105362 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105362:	55                   	push   %ebp
80105363:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105365:	fa                   	cli    
}
80105366:	90                   	nop
80105367:	5d                   	pop    %ebp
80105368:	c3                   	ret    

80105369 <sti>:

static inline void
sti(void)
{
80105369:	55                   	push   %ebp
8010536a:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010536c:	fb                   	sti    
}
8010536d:	90                   	nop
8010536e:	5d                   	pop    %ebp
8010536f:	c3                   	ret    

80105370 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105376:	8b 55 08             	mov    0x8(%ebp),%edx
80105379:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010537f:	f0 87 02             	lock xchg %eax,(%edx)
80105382:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105385:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105388:	c9                   	leave  
80105389:	c3                   	ret    

8010538a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010538a:	55                   	push   %ebp
8010538b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010538d:	8b 45 08             	mov    0x8(%ebp),%eax
80105390:	8b 55 0c             	mov    0xc(%ebp),%edx
80105393:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105396:	8b 45 08             	mov    0x8(%ebp),%eax
80105399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010539f:	8b 45 08             	mov    0x8(%ebp),%eax
801053a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053a9:	90                   	nop
801053aa:	5d                   	pop    %ebp
801053ab:	c3                   	ret    

801053ac <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801053ac:	55                   	push   %ebp
801053ad:	89 e5                	mov    %esp,%ebp
801053af:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801053b2:	e8 57 01 00 00       	call   8010550e <pushcli>
  if(holding(lk))
801053b7:	8b 45 08             	mov    0x8(%ebp),%eax
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	50                   	push   %eax
801053be:	e8 21 01 00 00       	call   801054e4 <holding>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	74 0d                	je     801053d7 <acquire+0x2b>
    panic("acquire");
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	68 70 8d 10 80       	push   $0x80108d70
801053d2:	e8 c9 b1 ff ff       	call   801005a0 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801053d7:	90                   	nop
801053d8:	8b 45 08             	mov    0x8(%ebp),%eax
801053db:	83 ec 08             	sub    $0x8,%esp
801053de:	6a 01                	push   $0x1
801053e0:	50                   	push   %eax
801053e1:	e8 8a ff ff ff       	call   80105370 <xchg>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	75 eb                	jne    801053d8 <acquire+0x2c>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801053ed:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801053f2:	8b 45 08             	mov    0x8(%ebp),%eax
801053f5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053fc:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801053ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105402:	83 c0 0c             	add    $0xc,%eax
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	50                   	push   %eax
80105409:	8d 45 08             	lea    0x8(%ebp),%eax
8010540c:	50                   	push   %eax
8010540d:	e8 58 00 00 00       	call   8010546a <getcallerpcs>
80105412:	83 c4 10             	add    $0x10,%esp
}
80105415:	90                   	nop
80105416:	c9                   	leave  
80105417:	c3                   	ret    

80105418 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105418:	55                   	push   %ebp
80105419:	89 e5                	mov    %esp,%ebp
8010541b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	ff 75 08             	pushl  0x8(%ebp)
80105424:	e8 bb 00 00 00       	call   801054e4 <holding>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	75 0d                	jne    8010543d <release+0x25>
    panic("release");
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	68 78 8d 10 80       	push   $0x80108d78
80105438:	e8 63 b1 ff ff       	call   801005a0 <panic>

  lk->pcs[0] = 0;
8010543d:	8b 45 08             	mov    0x8(%ebp),%eax
80105440:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105447:	8b 45 08             	mov    0x8(%ebp),%eax
8010544a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105451:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105456:	8b 45 08             	mov    0x8(%ebp),%eax
80105459:	8b 55 08             	mov    0x8(%ebp),%edx
8010545c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105462:	e8 fe 00 00 00       	call   80105565 <popcli>
}
80105467:	90                   	nop
80105468:	c9                   	leave  
80105469:	c3                   	ret    

8010546a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010546a:	55                   	push   %ebp
8010546b:	89 e5                	mov    %esp,%ebp
8010546d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105470:	8b 45 08             	mov    0x8(%ebp),%eax
80105473:	83 e8 08             	sub    $0x8,%eax
80105476:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105479:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105480:	eb 38                	jmp    801054ba <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105482:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105486:	74 53                	je     801054db <getcallerpcs+0x71>
80105488:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010548f:	76 4a                	jbe    801054db <getcallerpcs+0x71>
80105491:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105495:	74 44                	je     801054db <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105497:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010549a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a4:	01 c2                	add    %eax,%edx
801054a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054a9:	8b 40 04             	mov    0x4(%eax),%eax
801054ac:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801054ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054b1:	8b 00                	mov    (%eax),%eax
801054b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801054b6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054ba:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054be:	7e c2                	jle    80105482 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054c0:	eb 19                	jmp    801054db <getcallerpcs+0x71>
    pcs[i] = 0;
801054c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801054cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cf:	01 d0                	add    %edx,%eax
801054d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801054d7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801054db:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801054df:	7e e1                	jle    801054c2 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801054e1:	90                   	nop
801054e2:	c9                   	leave  
801054e3:	c3                   	ret    

801054e4 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801054e7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ea:	8b 00                	mov    (%eax),%eax
801054ec:	85 c0                	test   %eax,%eax
801054ee:	74 17                	je     80105507 <holding+0x23>
801054f0:	8b 45 08             	mov    0x8(%ebp),%eax
801054f3:	8b 50 08             	mov    0x8(%eax),%edx
801054f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054fc:	39 c2                	cmp    %eax,%edx
801054fe:	75 07                	jne    80105507 <holding+0x23>
80105500:	b8 01 00 00 00       	mov    $0x1,%eax
80105505:	eb 05                	jmp    8010550c <holding+0x28>
80105507:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    

8010550e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010550e:	55                   	push   %ebp
8010550f:	89 e5                	mov    %esp,%ebp
80105511:	83 ec 10             	sub    $0x10,%esp
  int eflags;

  eflags = readeflags();
80105514:	e8 39 fe ff ff       	call   80105352 <readeflags>
80105519:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010551c:	e8 41 fe ff ff       	call   80105362 <cli>
  if(cpu->ncli == 0)
80105521:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105527:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010552d:	85 c0                	test   %eax,%eax
8010552f:	75 15                	jne    80105546 <pushcli+0x38>
    cpu->intena = eflags & FL_IF;
80105531:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105537:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010553a:	81 e2 00 02 00 00    	and    $0x200,%edx
80105540:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  cpu->ncli += 1;
80105546:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010554c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105553:	8b 92 ac 00 00 00    	mov    0xac(%edx),%edx
80105559:	83 c2 01             	add    $0x1,%edx
8010555c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
80105562:	90                   	nop
80105563:	c9                   	leave  
80105564:	c3                   	ret    

80105565 <popcli>:

void
popcli(void)
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
80105568:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010556b:	e8 e2 fd ff ff       	call   80105352 <readeflags>
80105570:	25 00 02 00 00       	and    $0x200,%eax
80105575:	85 c0                	test   %eax,%eax
80105577:	74 0d                	je     80105586 <popcli+0x21>
    panic("popcli - interruptible");
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	68 80 8d 10 80       	push   $0x80108d80
80105581:	e8 1a b0 ff ff       	call   801005a0 <panic>
  if(--cpu->ncli < 0)
80105586:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010558c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105592:	83 ea 01             	sub    $0x1,%edx
80105595:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010559b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055a1:	85 c0                	test   %eax,%eax
801055a3:	79 0d                	jns    801055b2 <popcli+0x4d>
    panic("popcli");
801055a5:	83 ec 0c             	sub    $0xc,%esp
801055a8:	68 97 8d 10 80       	push   $0x80108d97
801055ad:	e8 ee af ff ff       	call   801005a0 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801055b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055b8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055be:	85 c0                	test   %eax,%eax
801055c0:	75 15                	jne    801055d7 <popcli+0x72>
801055c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055c8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801055ce:	85 c0                	test   %eax,%eax
801055d0:	74 05                	je     801055d7 <popcli+0x72>
    sti();
801055d2:	e8 92 fd ff ff       	call   80105369 <sti>
}
801055d7:	90                   	nop
801055d8:	c9                   	leave  
801055d9:	c3                   	ret    

801055da <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801055da:	55                   	push   %ebp
801055db:	89 e5                	mov    %esp,%ebp
801055dd:	57                   	push   %edi
801055de:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801055df:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055e2:	8b 55 10             	mov    0x10(%ebp),%edx
801055e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e8:	89 cb                	mov    %ecx,%ebx
801055ea:	89 df                	mov    %ebx,%edi
801055ec:	89 d1                	mov    %edx,%ecx
801055ee:	fc                   	cld    
801055ef:	f3 aa                	rep stos %al,%es:(%edi)
801055f1:	89 ca                	mov    %ecx,%edx
801055f3:	89 fb                	mov    %edi,%ebx
801055f5:	89 5d 08             	mov    %ebx,0x8(%ebp)
801055f8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801055fb:	90                   	nop
801055fc:	5b                   	pop    %ebx
801055fd:	5f                   	pop    %edi
801055fe:	5d                   	pop    %ebp
801055ff:	c3                   	ret    

80105600 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105605:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105608:	8b 55 10             	mov    0x10(%ebp),%edx
8010560b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010560e:	89 cb                	mov    %ecx,%ebx
80105610:	89 df                	mov    %ebx,%edi
80105612:	89 d1                	mov    %edx,%ecx
80105614:	fc                   	cld    
80105615:	f3 ab                	rep stos %eax,%es:(%edi)
80105617:	89 ca                	mov    %ecx,%edx
80105619:	89 fb                	mov    %edi,%ebx
8010561b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010561e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105621:	90                   	nop
80105622:	5b                   	pop    %ebx
80105623:	5f                   	pop    %edi
80105624:	5d                   	pop    %ebp
80105625:	c3                   	ret    

80105626 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105626:	55                   	push   %ebp
80105627:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105629:	8b 45 08             	mov    0x8(%ebp),%eax
8010562c:	83 e0 03             	and    $0x3,%eax
8010562f:	85 c0                	test   %eax,%eax
80105631:	75 43                	jne    80105676 <memset+0x50>
80105633:	8b 45 10             	mov    0x10(%ebp),%eax
80105636:	83 e0 03             	and    $0x3,%eax
80105639:	85 c0                	test   %eax,%eax
8010563b:	75 39                	jne    80105676 <memset+0x50>
    c &= 0xFF;
8010563d:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105644:	8b 45 10             	mov    0x10(%ebp),%eax
80105647:	c1 e8 02             	shr    $0x2,%eax
8010564a:	89 c1                	mov    %eax,%ecx
8010564c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010564f:	c1 e0 18             	shl    $0x18,%eax
80105652:	89 c2                	mov    %eax,%edx
80105654:	8b 45 0c             	mov    0xc(%ebp),%eax
80105657:	c1 e0 10             	shl    $0x10,%eax
8010565a:	09 c2                	or     %eax,%edx
8010565c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565f:	c1 e0 08             	shl    $0x8,%eax
80105662:	09 d0                	or     %edx,%eax
80105664:	0b 45 0c             	or     0xc(%ebp),%eax
80105667:	51                   	push   %ecx
80105668:	50                   	push   %eax
80105669:	ff 75 08             	pushl  0x8(%ebp)
8010566c:	e8 8f ff ff ff       	call   80105600 <stosl>
80105671:	83 c4 0c             	add    $0xc,%esp
80105674:	eb 12                	jmp    80105688 <memset+0x62>
  } else
    stosb(dst, c, n);
80105676:	8b 45 10             	mov    0x10(%ebp),%eax
80105679:	50                   	push   %eax
8010567a:	ff 75 0c             	pushl  0xc(%ebp)
8010567d:	ff 75 08             	pushl  0x8(%ebp)
80105680:	e8 55 ff ff ff       	call   801055da <stosb>
80105685:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105688:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010568b:	c9                   	leave  
8010568c:	c3                   	ret    

8010568d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010568d:	55                   	push   %ebp
8010568e:	89 e5                	mov    %esp,%ebp
80105690:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105693:	8b 45 08             	mov    0x8(%ebp),%eax
80105696:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010569f:	eb 30                	jmp    801056d1 <memcmp+0x44>
    if(*s1 != *s2)
801056a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056a4:	0f b6 10             	movzbl (%eax),%edx
801056a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056aa:	0f b6 00             	movzbl (%eax),%eax
801056ad:	38 c2                	cmp    %al,%dl
801056af:	74 18                	je     801056c9 <memcmp+0x3c>
      return *s1 - *s2;
801056b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b4:	0f b6 00             	movzbl (%eax),%eax
801056b7:	0f b6 d0             	movzbl %al,%edx
801056ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056bd:	0f b6 00             	movzbl (%eax),%eax
801056c0:	0f b6 c0             	movzbl %al,%eax
801056c3:	29 c2                	sub    %eax,%edx
801056c5:	89 d0                	mov    %edx,%eax
801056c7:	eb 1a                	jmp    801056e3 <memcmp+0x56>
    s1++, s2++;
801056c9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056cd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056d1:	8b 45 10             	mov    0x10(%ebp),%eax
801056d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056d7:	89 55 10             	mov    %edx,0x10(%ebp)
801056da:	85 c0                	test   %eax,%eax
801056dc:	75 c3                	jne    801056a1 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801056de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056e3:	c9                   	leave  
801056e4:	c3                   	ret    

801056e5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056e5:	55                   	push   %ebp
801056e6:	89 e5                	mov    %esp,%ebp
801056e8:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801056eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801056f1:	8b 45 08             	mov    0x8(%ebp),%eax
801056f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801056f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056fd:	73 54                	jae    80105753 <memmove+0x6e>
801056ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105702:	8b 45 10             	mov    0x10(%ebp),%eax
80105705:	01 d0                	add    %edx,%eax
80105707:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010570a:	76 47                	jbe    80105753 <memmove+0x6e>
    s += n;
8010570c:	8b 45 10             	mov    0x10(%ebp),%eax
8010570f:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105712:	8b 45 10             	mov    0x10(%ebp),%eax
80105715:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105718:	eb 13                	jmp    8010572d <memmove+0x48>
      *--d = *--s;
8010571a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010571e:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105722:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105725:	0f b6 10             	movzbl (%eax),%edx
80105728:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010572b:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010572d:	8b 45 10             	mov    0x10(%ebp),%eax
80105730:	8d 50 ff             	lea    -0x1(%eax),%edx
80105733:	89 55 10             	mov    %edx,0x10(%ebp)
80105736:	85 c0                	test   %eax,%eax
80105738:	75 e0                	jne    8010571a <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010573a:	eb 24                	jmp    80105760 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
8010573c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010573f:	8d 50 01             	lea    0x1(%eax),%edx
80105742:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105745:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105748:	8d 4a 01             	lea    0x1(%edx),%ecx
8010574b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010574e:	0f b6 12             	movzbl (%edx),%edx
80105751:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105753:	8b 45 10             	mov    0x10(%ebp),%eax
80105756:	8d 50 ff             	lea    -0x1(%eax),%edx
80105759:	89 55 10             	mov    %edx,0x10(%ebp)
8010575c:	85 c0                	test   %eax,%eax
8010575e:	75 dc                	jne    8010573c <memmove+0x57>
      *d++ = *s++;

  return dst;
80105760:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105763:	c9                   	leave  
80105764:	c3                   	ret    

80105765 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105765:	55                   	push   %ebp
80105766:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105768:	ff 75 10             	pushl  0x10(%ebp)
8010576b:	ff 75 0c             	pushl  0xc(%ebp)
8010576e:	ff 75 08             	pushl  0x8(%ebp)
80105771:	e8 6f ff ff ff       	call   801056e5 <memmove>
80105776:	83 c4 0c             	add    $0xc,%esp
}
80105779:	c9                   	leave  
8010577a:	c3                   	ret    

8010577b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010577b:	55                   	push   %ebp
8010577c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010577e:	eb 0c                	jmp    8010578c <strncmp+0x11>
    n--, p++, q++;
80105780:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105784:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105788:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010578c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105790:	74 1a                	je     801057ac <strncmp+0x31>
80105792:	8b 45 08             	mov    0x8(%ebp),%eax
80105795:	0f b6 00             	movzbl (%eax),%eax
80105798:	84 c0                	test   %al,%al
8010579a:	74 10                	je     801057ac <strncmp+0x31>
8010579c:	8b 45 08             	mov    0x8(%ebp),%eax
8010579f:	0f b6 10             	movzbl (%eax),%edx
801057a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a5:	0f b6 00             	movzbl (%eax),%eax
801057a8:	38 c2                	cmp    %al,%dl
801057aa:	74 d4                	je     80105780 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801057ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057b0:	75 07                	jne    801057b9 <strncmp+0x3e>
    return 0;
801057b2:	b8 00 00 00 00       	mov    $0x0,%eax
801057b7:	eb 16                	jmp    801057cf <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801057b9:	8b 45 08             	mov    0x8(%ebp),%eax
801057bc:	0f b6 00             	movzbl (%eax),%eax
801057bf:	0f b6 d0             	movzbl %al,%edx
801057c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c5:	0f b6 00             	movzbl (%eax),%eax
801057c8:	0f b6 c0             	movzbl %al,%eax
801057cb:	29 c2                	sub    %eax,%edx
801057cd:	89 d0                	mov    %edx,%eax
}
801057cf:	5d                   	pop    %ebp
801057d0:	c3                   	ret    

801057d1 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057d1:	55                   	push   %ebp
801057d2:	89 e5                	mov    %esp,%ebp
801057d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801057d7:	8b 45 08             	mov    0x8(%ebp),%eax
801057da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801057dd:	90                   	nop
801057de:	8b 45 10             	mov    0x10(%ebp),%eax
801057e1:	8d 50 ff             	lea    -0x1(%eax),%edx
801057e4:	89 55 10             	mov    %edx,0x10(%ebp)
801057e7:	85 c0                	test   %eax,%eax
801057e9:	7e 2c                	jle    80105817 <strncpy+0x46>
801057eb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ee:	8d 50 01             	lea    0x1(%eax),%edx
801057f1:	89 55 08             	mov    %edx,0x8(%ebp)
801057f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801057f7:	8d 4a 01             	lea    0x1(%edx),%ecx
801057fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801057fd:	0f b6 12             	movzbl (%edx),%edx
80105800:	88 10                	mov    %dl,(%eax)
80105802:	0f b6 00             	movzbl (%eax),%eax
80105805:	84 c0                	test   %al,%al
80105807:	75 d5                	jne    801057de <strncpy+0xd>
    ;
  while(n-- > 0)
80105809:	eb 0c                	jmp    80105817 <strncpy+0x46>
    *s++ = 0;
8010580b:	8b 45 08             	mov    0x8(%ebp),%eax
8010580e:	8d 50 01             	lea    0x1(%eax),%edx
80105811:	89 55 08             	mov    %edx,0x8(%ebp)
80105814:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105817:	8b 45 10             	mov    0x10(%ebp),%eax
8010581a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010581d:	89 55 10             	mov    %edx,0x10(%ebp)
80105820:	85 c0                	test   %eax,%eax
80105822:	7f e7                	jg     8010580b <strncpy+0x3a>
    *s++ = 0;
  return os;
80105824:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105827:	c9                   	leave  
80105828:	c3                   	ret    

80105829 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105829:	55                   	push   %ebp
8010582a:	89 e5                	mov    %esp,%ebp
8010582c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010582f:	8b 45 08             	mov    0x8(%ebp),%eax
80105832:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105835:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105839:	7f 05                	jg     80105840 <safestrcpy+0x17>
    return os;
8010583b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010583e:	eb 31                	jmp    80105871 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105840:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105844:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105848:	7e 1e                	jle    80105868 <safestrcpy+0x3f>
8010584a:	8b 45 08             	mov    0x8(%ebp),%eax
8010584d:	8d 50 01             	lea    0x1(%eax),%edx
80105850:	89 55 08             	mov    %edx,0x8(%ebp)
80105853:	8b 55 0c             	mov    0xc(%ebp),%edx
80105856:	8d 4a 01             	lea    0x1(%edx),%ecx
80105859:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010585c:	0f b6 12             	movzbl (%edx),%edx
8010585f:	88 10                	mov    %dl,(%eax)
80105861:	0f b6 00             	movzbl (%eax),%eax
80105864:	84 c0                	test   %al,%al
80105866:	75 d8                	jne    80105840 <safestrcpy+0x17>
    ;
  *s = 0;
80105868:	8b 45 08             	mov    0x8(%ebp),%eax
8010586b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010586e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105871:	c9                   	leave  
80105872:	c3                   	ret    

80105873 <strlen>:

int
strlen(const char *s)
{
80105873:	55                   	push   %ebp
80105874:	89 e5                	mov    %esp,%ebp
80105876:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105880:	eb 04                	jmp    80105886 <strlen+0x13>
80105882:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105886:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105889:	8b 45 08             	mov    0x8(%ebp),%eax
8010588c:	01 d0                	add    %edx,%eax
8010588e:	0f b6 00             	movzbl (%eax),%eax
80105891:	84 c0                	test   %al,%al
80105893:	75 ed                	jne    80105882 <strlen+0xf>
    ;
  return n;
80105895:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105898:	c9                   	leave  
80105899:	c3                   	ret    

8010589a <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010589a:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010589e:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801058a2:	55                   	push   %ebp
  pushl %ebx
801058a3:	53                   	push   %ebx
  pushl %esi
801058a4:	56                   	push   %esi
  pushl %edi
801058a5:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058a6:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058a8:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801058aa:	5f                   	pop    %edi
  popl %esi
801058ab:	5e                   	pop    %esi
  popl %ebx
801058ac:	5b                   	pop    %ebx
  popl %ebp
801058ad:	5d                   	pop    %ebp
  ret
801058ae:	c3                   	ret    

801058af <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058af:	55                   	push   %ebp
801058b0:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801058b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058b8:	8b 40 14             	mov    0x14(%eax),%eax
801058bb:	3b 45 08             	cmp    0x8(%ebp),%eax
801058be:	76 13                	jbe    801058d3 <fetchint+0x24>
801058c0:	8b 45 08             	mov    0x8(%ebp),%eax
801058c3:	8d 50 04             	lea    0x4(%eax),%edx
801058c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058cc:	8b 40 14             	mov    0x14(%eax),%eax
801058cf:	39 c2                	cmp    %eax,%edx
801058d1:	76 07                	jbe    801058da <fetchint+0x2b>
    return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d8:	eb 0f                	jmp    801058e9 <fetchint+0x3a>
  *ip = *(int*)(addr);
801058da:	8b 45 08             	mov    0x8(%ebp),%eax
801058dd:	8b 10                	mov    (%eax),%edx
801058df:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e2:	89 10                	mov    %edx,(%eax)
  return 0;
801058e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058e9:	5d                   	pop    %ebp
801058ea:	c3                   	ret    

801058eb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058eb:	55                   	push   %ebp
801058ec:	89 e5                	mov    %esp,%ebp
801058ee:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801058f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f7:	8b 40 14             	mov    0x14(%eax),%eax
801058fa:	3b 45 08             	cmp    0x8(%ebp),%eax
801058fd:	77 07                	ja     80105906 <fetchstr+0x1b>
    return -1;
801058ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105904:	eb 47                	jmp    8010594d <fetchstr+0x62>
  *pp = (char*)addr;
80105906:	8b 55 08             	mov    0x8(%ebp),%edx
80105909:	8b 45 0c             	mov    0xc(%ebp),%eax
8010590c:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010590e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105914:	8b 40 14             	mov    0x14(%eax),%eax
80105917:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010591a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591d:	8b 00                	mov    (%eax),%eax
8010591f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105922:	eb 1c                	jmp    80105940 <fetchstr+0x55>
    if(*s == 0)
80105924:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105927:	0f b6 00             	movzbl (%eax),%eax
8010592a:	84 c0                	test   %al,%al
8010592c:	75 0e                	jne    8010593c <fetchstr+0x51>
      return s - *pp;
8010592e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105931:	8b 45 0c             	mov    0xc(%ebp),%eax
80105934:	8b 00                	mov    (%eax),%eax
80105936:	29 c2                	sub    %eax,%edx
80105938:	89 d0                	mov    %edx,%eax
8010593a:	eb 11                	jmp    8010594d <fetchstr+0x62>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010593c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105940:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105943:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105946:	72 dc                	jb     80105924 <fetchstr+0x39>
    if(*s == 0)
      return s - *pp;
  return -1;
80105948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    

8010594f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010594f:	55                   	push   %ebp
80105950:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105952:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105958:	8b 40 28             	mov    0x28(%eax),%eax
8010595b:	8b 40 44             	mov    0x44(%eax),%eax
8010595e:	8b 55 08             	mov    0x8(%ebp),%edx
80105961:	c1 e2 02             	shl    $0x2,%edx
80105964:	01 d0                	add    %edx,%eax
80105966:	83 c0 04             	add    $0x4,%eax
80105969:	ff 75 0c             	pushl  0xc(%ebp)
8010596c:	50                   	push   %eax
8010596d:	e8 3d ff ff ff       	call   801058af <fetchint>
80105972:	83 c4 08             	add    $0x8,%esp
}
80105975:	c9                   	leave  
80105976:	c3                   	ret    

80105977 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105977:	55                   	push   %ebp
80105978:	89 e5                	mov    %esp,%ebp
8010597a:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(argint(n, &i) < 0)
8010597d:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105980:	50                   	push   %eax
80105981:	ff 75 08             	pushl  0x8(%ebp)
80105984:	e8 c6 ff ff ff       	call   8010594f <argint>
80105989:	83 c4 08             	add    $0x8,%esp
8010598c:	85 c0                	test   %eax,%eax
8010598e:	79 07                	jns    80105997 <argptr+0x20>
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105995:	eb 43                	jmp    801059da <argptr+0x63>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80105997:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010599b:	78 27                	js     801059c4 <argptr+0x4d>
8010599d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059a3:	8b 40 14             	mov    0x14(%eax),%eax
801059a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059a9:	39 d0                	cmp    %edx,%eax
801059ab:	76 17                	jbe    801059c4 <argptr+0x4d>
801059ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059b0:	89 c2                	mov    %eax,%edx
801059b2:	8b 45 10             	mov    0x10(%ebp),%eax
801059b5:	01 c2                	add    %eax,%edx
801059b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059bd:	8b 40 14             	mov    0x14(%eax),%eax
801059c0:	39 c2                	cmp    %eax,%edx
801059c2:	76 07                	jbe    801059cb <argptr+0x54>
    return -1;
801059c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c9:	eb 0f                	jmp    801059da <argptr+0x63>
  *pp = (char*)i;
801059cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059ce:	89 c2                	mov    %eax,%edx
801059d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d3:	89 10                	mov    %edx,(%eax)
  return 0;
801059d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059da:	c9                   	leave  
801059db:	c3                   	ret    

801059dc <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059dc:	55                   	push   %ebp
801059dd:	89 e5                	mov    %esp,%ebp
801059df:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801059e2:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059e5:	50                   	push   %eax
801059e6:	ff 75 08             	pushl  0x8(%ebp)
801059e9:	e8 61 ff ff ff       	call   8010594f <argint>
801059ee:	83 c4 08             	add    $0x8,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	79 07                	jns    801059fc <argstr+0x20>
    return -1;
801059f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fa:	eb 0f                	jmp    80105a0b <argstr+0x2f>
  return fetchstr(addr, pp);
801059fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059ff:	ff 75 0c             	pushl  0xc(%ebp)
80105a02:	50                   	push   %eax
80105a03:	e8 e3 fe ff ff       	call   801058eb <fetchstr>
80105a08:	83 c4 08             	add    $0x8,%esp
}
80105a0b:	c9                   	leave  
80105a0c:	c3                   	ret    

80105a0d <syscall>:
[SYS_nice]   sys_nice,
};

void
syscall(void)
{
80105a0d:	55                   	push   %ebp
80105a0e:	89 e5                	mov    %esp,%ebp
80105a10:	53                   	push   %ebx
80105a11:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105a14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a1a:	8b 40 28             	mov    0x28(%eax),%eax
80105a1d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a27:	7e 30                	jle    80105a59 <syscall+0x4c>
80105a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2c:	83 f8 18             	cmp    $0x18,%eax
80105a2f:	77 28                	ja     80105a59 <syscall+0x4c>
80105a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a34:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	74 1a                	je     80105a59 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105a3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a45:	8b 58 28             	mov    0x28(%eax),%ebx
80105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4b:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a52:	ff d0                	call   *%eax
80105a54:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105a57:	eb 33                	jmp    80105a8c <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105a59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a5f:	89 c2                	mov    %eax,%edx
80105a61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105a67:	8b 40 10             	mov    0x10(%eax),%eax
80105a6a:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6d:	52                   	push   %edx
80105a6e:	50                   	push   %eax
80105a6f:	68 9e 8d 10 80       	push   $0x80108d9e
80105a74:	e8 87 a9 ff ff       	call   80100400 <cprintf>
80105a79:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105a7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a82:	8b 40 28             	mov    0x28(%eax),%eax
80105a85:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105a8c:	90                   	nop
80105a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a90:	c9                   	leave  
80105a91:	c3                   	ret    

80105a92 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105a92:	55                   	push   %ebp
80105a93:	89 e5                	mov    %esp,%ebp
80105a95:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105a98:	83 ec 08             	sub    $0x8,%esp
80105a9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a9e:	50                   	push   %eax
80105a9f:	ff 75 08             	pushl  0x8(%ebp)
80105aa2:	e8 a8 fe ff ff       	call   8010594f <argint>
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	85 c0                	test   %eax,%eax
80105aac:	79 07                	jns    80105ab5 <argfd+0x23>
    return -1;
80105aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab3:	eb 50                	jmp    80105b05 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	78 21                	js     80105add <argfd+0x4b>
80105abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abf:	83 f8 0f             	cmp    $0xf,%eax
80105ac2:	7f 19                	jg     80105add <argfd+0x4b>
80105ac4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105acd:	83 c2 0c             	add    $0xc,%edx
80105ad0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ad7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105adb:	75 07                	jne    80105ae4 <argfd+0x52>
    return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae2:	eb 21                	jmp    80105b05 <argfd+0x73>
  if(pfd)
80105ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ae8:	74 08                	je     80105af2 <argfd+0x60>
    *pfd = fd;
80105aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105aed:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af0:	89 10                	mov    %edx,(%eax)
  if(pf)
80105af2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105af6:	74 08                	je     80105b00 <argfd+0x6e>
    *pf = f;
80105af8:	8b 45 10             	mov    0x10(%ebp),%eax
80105afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105afe:	89 10                	mov    %edx,(%eax)
  return 0;
80105b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    

80105b07 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b07:	55                   	push   %ebp
80105b08:	89 e5                	mov    %esp,%ebp
80105b0a:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b14:	eb 30                	jmp    80105b46 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b1f:	83 c2 0c             	add    $0xc,%edx
80105b22:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b26:	85 c0                	test   %eax,%eax
80105b28:	75 18                	jne    80105b42 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b30:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b33:	8d 4a 0c             	lea    0xc(%edx),%ecx
80105b36:	8b 55 08             	mov    0x8(%ebp),%edx
80105b39:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b40:	eb 0f                	jmp    80105b51 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b46:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b4a:	7e ca                	jle    80105b16 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b51:	c9                   	leave  
80105b52:	c3                   	ret    

80105b53 <sys_dup>:

int
sys_dup(void)
{
80105b53:	55                   	push   %ebp
80105b54:	89 e5                	mov    %esp,%ebp
80105b56:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105b59:	83 ec 04             	sub    $0x4,%esp
80105b5c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b5f:	50                   	push   %eax
80105b60:	6a 00                	push   $0x0
80105b62:	6a 00                	push   $0x0
80105b64:	e8 29 ff ff ff       	call   80105a92 <argfd>
80105b69:	83 c4 10             	add    $0x10,%esp
80105b6c:	85 c0                	test   %eax,%eax
80105b6e:	79 07                	jns    80105b77 <sys_dup+0x24>
    return -1;
80105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b75:	eb 31                	jmp    80105ba8 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	50                   	push   %eax
80105b7e:	e8 84 ff ff ff       	call   80105b07 <fdalloc>
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b8d:	79 07                	jns    80105b96 <sys_dup+0x43>
    return -1;
80105b8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b94:	eb 12                	jmp    80105ba8 <sys_dup+0x55>
  filedup(f);
80105b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b99:	83 ec 0c             	sub    $0xc,%esp
80105b9c:	50                   	push   %eax
80105b9d:	e8 cf b4 ff ff       	call   80101071 <filedup>
80105ba2:	83 c4 10             	add    $0x10,%esp
  return fd;
80105ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ba8:	c9                   	leave  
80105ba9:	c3                   	ret    

80105baa <sys_read>:

int
sys_read(void)
{
80105baa:	55                   	push   %ebp
80105bab:	89 e5                	mov    %esp,%ebp
80105bad:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bb0:	83 ec 04             	sub    $0x4,%esp
80105bb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb6:	50                   	push   %eax
80105bb7:	6a 00                	push   $0x0
80105bb9:	6a 00                	push   $0x0
80105bbb:	e8 d2 fe ff ff       	call   80105a92 <argfd>
80105bc0:	83 c4 10             	add    $0x10,%esp
80105bc3:	85 c0                	test   %eax,%eax
80105bc5:	78 2e                	js     80105bf5 <sys_read+0x4b>
80105bc7:	83 ec 08             	sub    $0x8,%esp
80105bca:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bcd:	50                   	push   %eax
80105bce:	6a 02                	push   $0x2
80105bd0:	e8 7a fd ff ff       	call   8010594f <argint>
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	85 c0                	test   %eax,%eax
80105bda:	78 19                	js     80105bf5 <sys_read+0x4b>
80105bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bdf:	83 ec 04             	sub    $0x4,%esp
80105be2:	50                   	push   %eax
80105be3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be6:	50                   	push   %eax
80105be7:	6a 01                	push   $0x1
80105be9:	e8 89 fd ff ff       	call   80105977 <argptr>
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	85 c0                	test   %eax,%eax
80105bf3:	79 07                	jns    80105bfc <sys_read+0x52>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfa:	eb 17                	jmp    80105c13 <sys_read+0x69>
  return fileread(f, p, n);
80105bfc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bff:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c05:	83 ec 04             	sub    $0x4,%esp
80105c08:	51                   	push   %ecx
80105c09:	52                   	push   %edx
80105c0a:	50                   	push   %eax
80105c0b:	e8 f1 b5 ff ff       	call   80101201 <fileread>
80105c10:	83 c4 10             	add    $0x10,%esp
}
80105c13:	c9                   	leave  
80105c14:	c3                   	ret    

80105c15 <sys_write>:

int
sys_write(void)
{
80105c15:	55                   	push   %ebp
80105c16:	89 e5                	mov    %esp,%ebp
80105c18:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c1b:	83 ec 04             	sub    $0x4,%esp
80105c1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c21:	50                   	push   %eax
80105c22:	6a 00                	push   $0x0
80105c24:	6a 00                	push   $0x0
80105c26:	e8 67 fe ff ff       	call   80105a92 <argfd>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	78 2e                	js     80105c60 <sys_write+0x4b>
80105c32:	83 ec 08             	sub    $0x8,%esp
80105c35:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c38:	50                   	push   %eax
80105c39:	6a 02                	push   $0x2
80105c3b:	e8 0f fd ff ff       	call   8010594f <argint>
80105c40:	83 c4 10             	add    $0x10,%esp
80105c43:	85 c0                	test   %eax,%eax
80105c45:	78 19                	js     80105c60 <sys_write+0x4b>
80105c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c4a:	83 ec 04             	sub    $0x4,%esp
80105c4d:	50                   	push   %eax
80105c4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c51:	50                   	push   %eax
80105c52:	6a 01                	push   $0x1
80105c54:	e8 1e fd ff ff       	call   80105977 <argptr>
80105c59:	83 c4 10             	add    $0x10,%esp
80105c5c:	85 c0                	test   %eax,%eax
80105c5e:	79 07                	jns    80105c67 <sys_write+0x52>
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c65:	eb 17                	jmp    80105c7e <sys_write+0x69>
  return filewrite(f, p, n);
80105c67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c70:	83 ec 04             	sub    $0x4,%esp
80105c73:	51                   	push   %ecx
80105c74:	52                   	push   %edx
80105c75:	50                   	push   %eax
80105c76:	e8 3e b6 ff ff       	call   801012b9 <filewrite>
80105c7b:	83 c4 10             	add    $0x10,%esp
}
80105c7e:	c9                   	leave  
80105c7f:	c3                   	ret    

80105c80 <sys_close>:

int
sys_close(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105c86:	83 ec 04             	sub    $0x4,%esp
80105c89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8c:	50                   	push   %eax
80105c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c90:	50                   	push   %eax
80105c91:	6a 00                	push   $0x0
80105c93:	e8 fa fd ff ff       	call   80105a92 <argfd>
80105c98:	83 c4 10             	add    $0x10,%esp
80105c9b:	85 c0                	test   %eax,%eax
80105c9d:	79 07                	jns    80105ca6 <sys_close+0x26>
    return -1;
80105c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca4:	eb 28                	jmp    80105cce <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105ca6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105caf:	83 c2 0c             	add    $0xc,%edx
80105cb2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cb9:	00 
  fileclose(f);
80105cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	50                   	push   %eax
80105cc1:	e8 fc b3 ff ff       	call   801010c2 <fileclose>
80105cc6:	83 c4 10             	add    $0x10,%esp
  return 0;
80105cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cce:	c9                   	leave  
80105ccf:	c3                   	ret    

80105cd0 <sys_fstat>:

int
sys_fstat(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105cd6:	83 ec 04             	sub    $0x4,%esp
80105cd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cdc:	50                   	push   %eax
80105cdd:	6a 00                	push   $0x0
80105cdf:	6a 00                	push   $0x0
80105ce1:	e8 ac fd ff ff       	call   80105a92 <argfd>
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	78 17                	js     80105d04 <sys_fstat+0x34>
80105ced:	83 ec 04             	sub    $0x4,%esp
80105cf0:	6a 14                	push   $0x14
80105cf2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cf5:	50                   	push   %eax
80105cf6:	6a 01                	push   $0x1
80105cf8:	e8 7a fc ff ff       	call   80105977 <argptr>
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	85 c0                	test   %eax,%eax
80105d02:	79 07                	jns    80105d0b <sys_fstat+0x3b>
    return -1;
80105d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d09:	eb 13                	jmp    80105d1e <sys_fstat+0x4e>
  return filestat(f, st);
80105d0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d11:	83 ec 08             	sub    $0x8,%esp
80105d14:	52                   	push   %edx
80105d15:	50                   	push   %eax
80105d16:	e8 8f b4 ff ff       	call   801011aa <filestat>
80105d1b:	83 c4 10             	add    $0x10,%esp
}
80105d1e:	c9                   	leave  
80105d1f:	c3                   	ret    

80105d20 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d26:	83 ec 08             	sub    $0x8,%esp
80105d29:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d2c:	50                   	push   %eax
80105d2d:	6a 00                	push   $0x0
80105d2f:	e8 a8 fc ff ff       	call   801059dc <argstr>
80105d34:	83 c4 10             	add    $0x10,%esp
80105d37:	85 c0                	test   %eax,%eax
80105d39:	78 15                	js     80105d50 <sys_link+0x30>
80105d3b:	83 ec 08             	sub    $0x8,%esp
80105d3e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d41:	50                   	push   %eax
80105d42:	6a 01                	push   $0x1
80105d44:	e8 93 fc ff ff       	call   801059dc <argstr>
80105d49:	83 c4 10             	add    $0x10,%esp
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	79 0a                	jns    80105d5a <sys_link+0x3a>
    return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d55:	e9 68 01 00 00       	jmp    80105ec2 <sys_link+0x1a2>

  begin_op();
80105d5a:	e8 80 d8 ff ff       	call   801035df <begin_op>
  if((ip = namei(old)) == 0){
80105d5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105d62:	83 ec 0c             	sub    $0xc,%esp
80105d65:	50                   	push   %eax
80105d66:	e8 dc c7 ff ff       	call   80102547 <namei>
80105d6b:	83 c4 10             	add    $0x10,%esp
80105d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d75:	75 0f                	jne    80105d86 <sys_link+0x66>
    end_op();
80105d77:	e8 ef d8 ff ff       	call   8010366b <end_op>
    return -1;
80105d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d81:	e9 3c 01 00 00       	jmp    80105ec2 <sys_link+0x1a2>
  }

  ilock(ip);
80105d86:	83 ec 0c             	sub    $0xc,%esp
80105d89:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8c:	e8 90 bc ff ff       	call   80101a21 <ilock>
80105d91:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d97:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d9b:	66 83 f8 01          	cmp    $0x1,%ax
80105d9f:	75 1d                	jne    80105dbe <sys_link+0x9e>
    iunlockput(ip);
80105da1:	83 ec 0c             	sub    $0xc,%esp
80105da4:	ff 75 f4             	pushl  -0xc(%ebp)
80105da7:	e8 8b be ff ff       	call   80101c37 <iunlockput>
80105dac:	83 c4 10             	add    $0x10,%esp
    end_op();
80105daf:	e8 b7 d8 ff ff       	call   8010366b <end_op>
    return -1;
80105db4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db9:	e9 04 01 00 00       	jmp    80105ec2 <sys_link+0x1a2>
  }

  ip->nlink++;
80105dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc1:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105dc5:	83 c0 01             	add    $0x1,%eax
80105dc8:	89 c2                	mov    %eax,%edx
80105dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcd:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105dd1:	83 ec 0c             	sub    $0xc,%esp
80105dd4:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd7:	e8 68 ba ff ff       	call   80101844 <iupdate>
80105ddc:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	ff 75 f4             	pushl  -0xc(%ebp)
80105de5:	e8 54 bd ff ff       	call   80101b3e <iunlock>
80105dea:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105ded:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105df6:	52                   	push   %edx
80105df7:	50                   	push   %eax
80105df8:	e8 66 c7 ff ff       	call   80102563 <nameiparent>
80105dfd:	83 c4 10             	add    $0x10,%esp
80105e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e07:	74 71                	je     80105e7a <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e0f:	e8 0d bc ff ff       	call   80101a21 <ilock>
80105e14:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e1a:	8b 10                	mov    (%eax),%edx
80105e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1f:	8b 00                	mov    (%eax),%eax
80105e21:	39 c2                	cmp    %eax,%edx
80105e23:	75 1d                	jne    80105e42 <sys_link+0x122>
80105e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e28:	8b 40 04             	mov    0x4(%eax),%eax
80105e2b:	83 ec 04             	sub    $0x4,%esp
80105e2e:	50                   	push   %eax
80105e2f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e32:	50                   	push   %eax
80105e33:	ff 75 f0             	pushl  -0x10(%ebp)
80105e36:	e8 70 c4 ff ff       	call   801022ab <dirlink>
80105e3b:	83 c4 10             	add    $0x10,%esp
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	79 10                	jns    80105e52 <sys_link+0x132>
    iunlockput(dp);
80105e42:	83 ec 0c             	sub    $0xc,%esp
80105e45:	ff 75 f0             	pushl  -0x10(%ebp)
80105e48:	e8 ea bd ff ff       	call   80101c37 <iunlockput>
80105e4d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e50:	eb 29                	jmp    80105e7b <sys_link+0x15b>
  }
  iunlockput(dp);
80105e52:	83 ec 0c             	sub    $0xc,%esp
80105e55:	ff 75 f0             	pushl  -0x10(%ebp)
80105e58:	e8 da bd ff ff       	call   80101c37 <iunlockput>
80105e5d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	ff 75 f4             	pushl  -0xc(%ebp)
80105e66:	e8 21 bd ff ff       	call   80101b8c <iput>
80105e6b:	83 c4 10             	add    $0x10,%esp

  end_op();
80105e6e:	e8 f8 d7 ff ff       	call   8010366b <end_op>

  return 0;
80105e73:	b8 00 00 00 00       	mov    $0x0,%eax
80105e78:	eb 48                	jmp    80105ec2 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105e7a:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80105e7b:	83 ec 0c             	sub    $0xc,%esp
80105e7e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e81:	e8 9b bb ff ff       	call   80101a21 <ilock>
80105e86:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e8c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105e90:	83 e8 01             	sub    $0x1,%eax
80105e93:	89 c2                	mov    %eax,%edx
80105e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e98:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105e9c:	83 ec 0c             	sub    $0xc,%esp
80105e9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105ea2:	e8 9d b9 ff ff       	call   80101844 <iupdate>
80105ea7:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105eaa:	83 ec 0c             	sub    $0xc,%esp
80105ead:	ff 75 f4             	pushl  -0xc(%ebp)
80105eb0:	e8 82 bd ff ff       	call   80101c37 <iunlockput>
80105eb5:	83 c4 10             	add    $0x10,%esp
  end_op();
80105eb8:	e8 ae d7 ff ff       	call   8010366b <end_op>
  return -1;
80105ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    

80105ec4 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105eca:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105ed1:	eb 40                	jmp    80105f13 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed6:	6a 10                	push   $0x10
80105ed8:	50                   	push   %eax
80105ed9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105edc:	50                   	push   %eax
80105edd:	ff 75 08             	pushl  0x8(%ebp)
80105ee0:	e8 12 c0 ff ff       	call   80101ef7 <readi>
80105ee5:	83 c4 10             	add    $0x10,%esp
80105ee8:	83 f8 10             	cmp    $0x10,%eax
80105eeb:	74 0d                	je     80105efa <isdirempty+0x36>
      panic("isdirempty: readi");
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	68 ba 8d 10 80       	push   $0x80108dba
80105ef5:	e8 a6 a6 ff ff       	call   801005a0 <panic>
    if(de.inum != 0)
80105efa:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105efe:	66 85 c0             	test   %ax,%ax
80105f01:	74 07                	je     80105f0a <isdirempty+0x46>
      return 0;
80105f03:	b8 00 00 00 00       	mov    $0x0,%eax
80105f08:	eb 1b                	jmp    80105f25 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0d:	83 c0 10             	add    $0x10,%eax
80105f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f13:	8b 45 08             	mov    0x8(%ebp),%eax
80105f16:	8b 50 58             	mov    0x58(%eax),%edx
80105f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f1c:	39 c2                	cmp    %eax,%edx
80105f1e:	77 b3                	ja     80105ed3 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105f20:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f25:	c9                   	leave  
80105f26:	c3                   	ret    

80105f27 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f27:	55                   	push   %ebp
80105f28:	89 e5                	mov    %esp,%ebp
80105f2a:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f2d:	83 ec 08             	sub    $0x8,%esp
80105f30:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f33:	50                   	push   %eax
80105f34:	6a 00                	push   $0x0
80105f36:	e8 a1 fa ff ff       	call   801059dc <argstr>
80105f3b:	83 c4 10             	add    $0x10,%esp
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	79 0a                	jns    80105f4c <sys_unlink+0x25>
    return -1;
80105f42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f47:	e9 bc 01 00 00       	jmp    80106108 <sys_unlink+0x1e1>

  begin_op();
80105f4c:	e8 8e d6 ff ff       	call   801035df <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f54:	83 ec 08             	sub    $0x8,%esp
80105f57:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105f5a:	52                   	push   %edx
80105f5b:	50                   	push   %eax
80105f5c:	e8 02 c6 ff ff       	call   80102563 <nameiparent>
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f6b:	75 0f                	jne    80105f7c <sys_unlink+0x55>
    end_op();
80105f6d:	e8 f9 d6 ff ff       	call   8010366b <end_op>
    return -1;
80105f72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f77:	e9 8c 01 00 00       	jmp    80106108 <sys_unlink+0x1e1>
  }

  ilock(dp);
80105f7c:	83 ec 0c             	sub    $0xc,%esp
80105f7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f82:	e8 9a ba ff ff       	call   80101a21 <ilock>
80105f87:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105f8a:	83 ec 08             	sub    $0x8,%esp
80105f8d:	68 cc 8d 10 80       	push   $0x80108dcc
80105f92:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f95:	50                   	push   %eax
80105f96:	e8 3b c2 ff ff       	call   801021d6 <namecmp>
80105f9b:	83 c4 10             	add    $0x10,%esp
80105f9e:	85 c0                	test   %eax,%eax
80105fa0:	0f 84 4a 01 00 00    	je     801060f0 <sys_unlink+0x1c9>
80105fa6:	83 ec 08             	sub    $0x8,%esp
80105fa9:	68 ce 8d 10 80       	push   $0x80108dce
80105fae:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fb1:	50                   	push   %eax
80105fb2:	e8 1f c2 ff ff       	call   801021d6 <namecmp>
80105fb7:	83 c4 10             	add    $0x10,%esp
80105fba:	85 c0                	test   %eax,%eax
80105fbc:	0f 84 2e 01 00 00    	je     801060f0 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105fc2:	83 ec 04             	sub    $0x4,%esp
80105fc5:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105fc8:	50                   	push   %eax
80105fc9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fcc:	50                   	push   %eax
80105fcd:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd0:	e8 1c c2 ff ff       	call   801021f1 <dirlookup>
80105fd5:	83 c4 10             	add    $0x10,%esp
80105fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fdf:	0f 84 0a 01 00 00    	je     801060ef <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80105fe5:	83 ec 0c             	sub    $0xc,%esp
80105fe8:	ff 75 f0             	pushl  -0x10(%ebp)
80105feb:	e8 31 ba ff ff       	call   80101a21 <ilock>
80105ff0:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff6:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ffa:	66 85 c0             	test   %ax,%ax
80105ffd:	7f 0d                	jg     8010600c <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105fff:	83 ec 0c             	sub    $0xc,%esp
80106002:	68 d1 8d 10 80       	push   $0x80108dd1
80106007:	e8 94 a5 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010600c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106013:	66 83 f8 01          	cmp    $0x1,%ax
80106017:	75 25                	jne    8010603e <sys_unlink+0x117>
80106019:	83 ec 0c             	sub    $0xc,%esp
8010601c:	ff 75 f0             	pushl  -0x10(%ebp)
8010601f:	e8 a0 fe ff ff       	call   80105ec4 <isdirempty>
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	85 c0                	test   %eax,%eax
80106029:	75 13                	jne    8010603e <sys_unlink+0x117>
    iunlockput(ip);
8010602b:	83 ec 0c             	sub    $0xc,%esp
8010602e:	ff 75 f0             	pushl  -0x10(%ebp)
80106031:	e8 01 bc ff ff       	call   80101c37 <iunlockput>
80106036:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106039:	e9 b2 00 00 00       	jmp    801060f0 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
8010603e:	83 ec 04             	sub    $0x4,%esp
80106041:	6a 10                	push   $0x10
80106043:	6a 00                	push   $0x0
80106045:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106048:	50                   	push   %eax
80106049:	e8 d8 f5 ff ff       	call   80105626 <memset>
8010604e:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106051:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106054:	6a 10                	push   $0x10
80106056:	50                   	push   %eax
80106057:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010605a:	50                   	push   %eax
8010605b:	ff 75 f4             	pushl  -0xc(%ebp)
8010605e:	e8 eb bf ff ff       	call   8010204e <writei>
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	83 f8 10             	cmp    $0x10,%eax
80106069:	74 0d                	je     80106078 <sys_unlink+0x151>
    panic("unlink: writei");
8010606b:	83 ec 0c             	sub    $0xc,%esp
8010606e:	68 e3 8d 10 80       	push   $0x80108de3
80106073:	e8 28 a5 ff ff       	call   801005a0 <panic>
  if(ip->type == T_DIR){
80106078:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010607b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010607f:	66 83 f8 01          	cmp    $0x1,%ax
80106083:	75 21                	jne    801060a6 <sys_unlink+0x17f>
    dp->nlink--;
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010608c:	83 e8 01             	sub    $0x1,%eax
8010608f:	89 c2                	mov    %eax,%edx
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106098:	83 ec 0c             	sub    $0xc,%esp
8010609b:	ff 75 f4             	pushl  -0xc(%ebp)
8010609e:	e8 a1 b7 ff ff       	call   80101844 <iupdate>
801060a3:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801060a6:	83 ec 0c             	sub    $0xc,%esp
801060a9:	ff 75 f4             	pushl  -0xc(%ebp)
801060ac:	e8 86 bb ff ff       	call   80101c37 <iunlockput>
801060b1:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801060b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801060bb:	83 e8 01             	sub    $0x1,%eax
801060be:	89 c2                	mov    %eax,%edx
801060c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060c3:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801060c7:	83 ec 0c             	sub    $0xc,%esp
801060ca:	ff 75 f0             	pushl  -0x10(%ebp)
801060cd:	e8 72 b7 ff ff       	call   80101844 <iupdate>
801060d2:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801060d5:	83 ec 0c             	sub    $0xc,%esp
801060d8:	ff 75 f0             	pushl  -0x10(%ebp)
801060db:	e8 57 bb ff ff       	call   80101c37 <iunlockput>
801060e0:	83 c4 10             	add    $0x10,%esp

  end_op();
801060e3:	e8 83 d5 ff ff       	call   8010366b <end_op>

  return 0;
801060e8:	b8 00 00 00 00       	mov    $0x0,%eax
801060ed:	eb 19                	jmp    80106108 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801060ef:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	ff 75 f4             	pushl  -0xc(%ebp)
801060f6:	e8 3c bb ff ff       	call   80101c37 <iunlockput>
801060fb:	83 c4 10             	add    $0x10,%esp
  end_op();
801060fe:	e8 68 d5 ff ff       	call   8010366b <end_op>
  return -1;
80106103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106108:	c9                   	leave  
80106109:	c3                   	ret    

8010610a <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010610a:	55                   	push   %ebp
8010610b:	89 e5                	mov    %esp,%ebp
8010610d:	83 ec 38             	sub    $0x38,%esp
80106110:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106113:	8b 55 10             	mov    0x10(%ebp),%edx
80106116:	8b 45 14             	mov    0x14(%ebp),%eax
80106119:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010611d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106121:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106125:	83 ec 08             	sub    $0x8,%esp
80106128:	8d 45 de             	lea    -0x22(%ebp),%eax
8010612b:	50                   	push   %eax
8010612c:	ff 75 08             	pushl  0x8(%ebp)
8010612f:	e8 2f c4 ff ff       	call   80102563 <nameiparent>
80106134:	83 c4 10             	add    $0x10,%esp
80106137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010613a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010613e:	75 0a                	jne    8010614a <create+0x40>
    return 0;
80106140:	b8 00 00 00 00       	mov    $0x0,%eax
80106145:	e9 90 01 00 00       	jmp    801062da <create+0x1d0>
  ilock(dp);
8010614a:	83 ec 0c             	sub    $0xc,%esp
8010614d:	ff 75 f4             	pushl  -0xc(%ebp)
80106150:	e8 cc b8 ff ff       	call   80101a21 <ilock>
80106155:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106158:	83 ec 04             	sub    $0x4,%esp
8010615b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010615e:	50                   	push   %eax
8010615f:	8d 45 de             	lea    -0x22(%ebp),%eax
80106162:	50                   	push   %eax
80106163:	ff 75 f4             	pushl  -0xc(%ebp)
80106166:	e8 86 c0 ff ff       	call   801021f1 <dirlookup>
8010616b:	83 c4 10             	add    $0x10,%esp
8010616e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106175:	74 50                	je     801061c7 <create+0xbd>
    iunlockput(dp);
80106177:	83 ec 0c             	sub    $0xc,%esp
8010617a:	ff 75 f4             	pushl  -0xc(%ebp)
8010617d:	e8 b5 ba ff ff       	call   80101c37 <iunlockput>
80106182:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106185:	83 ec 0c             	sub    $0xc,%esp
80106188:	ff 75 f0             	pushl  -0x10(%ebp)
8010618b:	e8 91 b8 ff ff       	call   80101a21 <ilock>
80106190:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106193:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106198:	75 15                	jne    801061af <create+0xa5>
8010619a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801061a1:	66 83 f8 02          	cmp    $0x2,%ax
801061a5:	75 08                	jne    801061af <create+0xa5>
      return ip;
801061a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061aa:	e9 2b 01 00 00       	jmp    801062da <create+0x1d0>
    iunlockput(ip);
801061af:	83 ec 0c             	sub    $0xc,%esp
801061b2:	ff 75 f0             	pushl  -0x10(%ebp)
801061b5:	e8 7d ba ff ff       	call   80101c37 <iunlockput>
801061ba:	83 c4 10             	add    $0x10,%esp
    return 0;
801061bd:	b8 00 00 00 00       	mov    $0x0,%eax
801061c2:	e9 13 01 00 00       	jmp    801062da <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801061c7:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801061cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ce:	8b 00                	mov    (%eax),%eax
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	52                   	push   %edx
801061d4:	50                   	push   %eax
801061d5:	e8 93 b5 ff ff       	call   8010176d <ialloc>
801061da:	83 c4 10             	add    $0x10,%esp
801061dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061e4:	75 0d                	jne    801061f3 <create+0xe9>
    panic("create: ialloc");
801061e6:	83 ec 0c             	sub    $0xc,%esp
801061e9:	68 f2 8d 10 80       	push   $0x80108df2
801061ee:	e8 ad a3 ff ff       	call   801005a0 <panic>

  ilock(ip);
801061f3:	83 ec 0c             	sub    $0xc,%esp
801061f6:	ff 75 f0             	pushl  -0x10(%ebp)
801061f9:	e8 23 b8 ff ff       	call   80101a21 <ilock>
801061fe:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106201:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106204:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106208:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
8010620c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010620f:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106213:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80106217:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621a:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	ff 75 f0             	pushl  -0x10(%ebp)
80106226:	e8 19 b6 ff ff       	call   80101844 <iupdate>
8010622b:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010622e:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106233:	75 6a                	jne    8010629f <create+0x195>
    dp->nlink++;  // for ".."
80106235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106238:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010623c:	83 c0 01             	add    $0x1,%eax
8010623f:	89 c2                	mov    %eax,%edx
80106241:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106244:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106248:	83 ec 0c             	sub    $0xc,%esp
8010624b:	ff 75 f4             	pushl  -0xc(%ebp)
8010624e:	e8 f1 b5 ff ff       	call   80101844 <iupdate>
80106253:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106259:	8b 40 04             	mov    0x4(%eax),%eax
8010625c:	83 ec 04             	sub    $0x4,%esp
8010625f:	50                   	push   %eax
80106260:	68 cc 8d 10 80       	push   $0x80108dcc
80106265:	ff 75 f0             	pushl  -0x10(%ebp)
80106268:	e8 3e c0 ff ff       	call   801022ab <dirlink>
8010626d:	83 c4 10             	add    $0x10,%esp
80106270:	85 c0                	test   %eax,%eax
80106272:	78 1e                	js     80106292 <create+0x188>
80106274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106277:	8b 40 04             	mov    0x4(%eax),%eax
8010627a:	83 ec 04             	sub    $0x4,%esp
8010627d:	50                   	push   %eax
8010627e:	68 ce 8d 10 80       	push   $0x80108dce
80106283:	ff 75 f0             	pushl  -0x10(%ebp)
80106286:	e8 20 c0 ff ff       	call   801022ab <dirlink>
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	85 c0                	test   %eax,%eax
80106290:	79 0d                	jns    8010629f <create+0x195>
      panic("create dots");
80106292:	83 ec 0c             	sub    $0xc,%esp
80106295:	68 01 8e 10 80       	push   $0x80108e01
8010629a:	e8 01 a3 ff ff       	call   801005a0 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010629f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a2:	8b 40 04             	mov    0x4(%eax),%eax
801062a5:	83 ec 04             	sub    $0x4,%esp
801062a8:	50                   	push   %eax
801062a9:	8d 45 de             	lea    -0x22(%ebp),%eax
801062ac:	50                   	push   %eax
801062ad:	ff 75 f4             	pushl  -0xc(%ebp)
801062b0:	e8 f6 bf ff ff       	call   801022ab <dirlink>
801062b5:	83 c4 10             	add    $0x10,%esp
801062b8:	85 c0                	test   %eax,%eax
801062ba:	79 0d                	jns    801062c9 <create+0x1bf>
    panic("create: dirlink");
801062bc:	83 ec 0c             	sub    $0xc,%esp
801062bf:	68 0d 8e 10 80       	push   $0x80108e0d
801062c4:	e8 d7 a2 ff ff       	call   801005a0 <panic>

  iunlockput(dp);
801062c9:	83 ec 0c             	sub    $0xc,%esp
801062cc:	ff 75 f4             	pushl  -0xc(%ebp)
801062cf:	e8 63 b9 ff ff       	call   80101c37 <iunlockput>
801062d4:	83 c4 10             	add    $0x10,%esp

  return ip;
801062d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801062da:	c9                   	leave  
801062db:	c3                   	ret    

801062dc <sys_open>:

int
sys_open(void)
{
801062dc:	55                   	push   %ebp
801062dd:	89 e5                	mov    %esp,%ebp
801062df:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801062e2:	83 ec 08             	sub    $0x8,%esp
801062e5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062e8:	50                   	push   %eax
801062e9:	6a 00                	push   $0x0
801062eb:	e8 ec f6 ff ff       	call   801059dc <argstr>
801062f0:	83 c4 10             	add    $0x10,%esp
801062f3:	85 c0                	test   %eax,%eax
801062f5:	78 15                	js     8010630c <sys_open+0x30>
801062f7:	83 ec 08             	sub    $0x8,%esp
801062fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062fd:	50                   	push   %eax
801062fe:	6a 01                	push   $0x1
80106300:	e8 4a f6 ff ff       	call   8010594f <argint>
80106305:	83 c4 10             	add    $0x10,%esp
80106308:	85 c0                	test   %eax,%eax
8010630a:	79 0a                	jns    80106316 <sys_open+0x3a>
    return -1;
8010630c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106311:	e9 61 01 00 00       	jmp    80106477 <sys_open+0x19b>

  begin_op();
80106316:	e8 c4 d2 ff ff       	call   801035df <begin_op>

  if(omode & O_CREATE){
8010631b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010631e:	25 00 02 00 00       	and    $0x200,%eax
80106323:	85 c0                	test   %eax,%eax
80106325:	74 2a                	je     80106351 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106327:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010632a:	6a 00                	push   $0x0
8010632c:	6a 00                	push   $0x0
8010632e:	6a 02                	push   $0x2
80106330:	50                   	push   %eax
80106331:	e8 d4 fd ff ff       	call   8010610a <create>
80106336:	83 c4 10             	add    $0x10,%esp
80106339:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010633c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106340:	75 75                	jne    801063b7 <sys_open+0xdb>
      end_op();
80106342:	e8 24 d3 ff ff       	call   8010366b <end_op>
      return -1;
80106347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010634c:	e9 26 01 00 00       	jmp    80106477 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106351:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	50                   	push   %eax
80106358:	e8 ea c1 ff ff       	call   80102547 <namei>
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106367:	75 0f                	jne    80106378 <sys_open+0x9c>
      end_op();
80106369:	e8 fd d2 ff ff       	call   8010366b <end_op>
      return -1;
8010636e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106373:	e9 ff 00 00 00       	jmp    80106477 <sys_open+0x19b>
    }
    ilock(ip);
80106378:	83 ec 0c             	sub    $0xc,%esp
8010637b:	ff 75 f4             	pushl  -0xc(%ebp)
8010637e:	e8 9e b6 ff ff       	call   80101a21 <ilock>
80106383:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106389:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010638d:	66 83 f8 01          	cmp    $0x1,%ax
80106391:	75 24                	jne    801063b7 <sys_open+0xdb>
80106393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106396:	85 c0                	test   %eax,%eax
80106398:	74 1d                	je     801063b7 <sys_open+0xdb>
      iunlockput(ip);
8010639a:	83 ec 0c             	sub    $0xc,%esp
8010639d:	ff 75 f4             	pushl  -0xc(%ebp)
801063a0:	e8 92 b8 ff ff       	call   80101c37 <iunlockput>
801063a5:	83 c4 10             	add    $0x10,%esp
      end_op();
801063a8:	e8 be d2 ff ff       	call   8010366b <end_op>
      return -1;
801063ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b2:	e9 c0 00 00 00       	jmp    80106477 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801063b7:	e8 48 ac ff ff       	call   80101004 <filealloc>
801063bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063c3:	74 17                	je     801063dc <sys_open+0x100>
801063c5:	83 ec 0c             	sub    $0xc,%esp
801063c8:	ff 75 f0             	pushl  -0x10(%ebp)
801063cb:	e8 37 f7 ff ff       	call   80105b07 <fdalloc>
801063d0:	83 c4 10             	add    $0x10,%esp
801063d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801063d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801063da:	79 2e                	jns    8010640a <sys_open+0x12e>
    if(f)
801063dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063e0:	74 0e                	je     801063f0 <sys_open+0x114>
      fileclose(f);
801063e2:	83 ec 0c             	sub    $0xc,%esp
801063e5:	ff 75 f0             	pushl  -0x10(%ebp)
801063e8:	e8 d5 ac ff ff       	call   801010c2 <fileclose>
801063ed:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	ff 75 f4             	pushl  -0xc(%ebp)
801063f6:	e8 3c b8 ff ff       	call   80101c37 <iunlockput>
801063fb:	83 c4 10             	add    $0x10,%esp
    end_op();
801063fe:	e8 68 d2 ff ff       	call   8010366b <end_op>
    return -1;
80106403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106408:	eb 6d                	jmp    80106477 <sys_open+0x19b>
  }
  iunlock(ip);
8010640a:	83 ec 0c             	sub    $0xc,%esp
8010640d:	ff 75 f4             	pushl  -0xc(%ebp)
80106410:	e8 29 b7 ff ff       	call   80101b3e <iunlock>
80106415:	83 c4 10             	add    $0x10,%esp
  end_op();
80106418:	e8 4e d2 ff ff       	call   8010366b <end_op>

  f->type = FD_INODE;
8010641d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106420:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106426:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106429:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010642c:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010642f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106432:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010643c:	83 e0 01             	and    $0x1,%eax
8010643f:	85 c0                	test   %eax,%eax
80106441:	0f 94 c0             	sete   %al
80106444:	89 c2                	mov    %eax,%edx
80106446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106449:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010644c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010644f:	83 e0 01             	and    $0x1,%eax
80106452:	85 c0                	test   %eax,%eax
80106454:	75 0a                	jne    80106460 <sys_open+0x184>
80106456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106459:	83 e0 02             	and    $0x2,%eax
8010645c:	85 c0                	test   %eax,%eax
8010645e:	74 07                	je     80106467 <sys_open+0x18b>
80106460:	b8 01 00 00 00       	mov    $0x1,%eax
80106465:	eb 05                	jmp    8010646c <sys_open+0x190>
80106467:	b8 00 00 00 00       	mov    $0x0,%eax
8010646c:	89 c2                	mov    %eax,%edx
8010646e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106471:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106474:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106477:	c9                   	leave  
80106478:	c3                   	ret    

80106479 <sys_mkdir>:

int
sys_mkdir(void)
{
80106479:	55                   	push   %ebp
8010647a:	89 e5                	mov    %esp,%ebp
8010647c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010647f:	e8 5b d1 ff ff       	call   801035df <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106484:	83 ec 08             	sub    $0x8,%esp
80106487:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010648a:	50                   	push   %eax
8010648b:	6a 00                	push   $0x0
8010648d:	e8 4a f5 ff ff       	call   801059dc <argstr>
80106492:	83 c4 10             	add    $0x10,%esp
80106495:	85 c0                	test   %eax,%eax
80106497:	78 1b                	js     801064b4 <sys_mkdir+0x3b>
80106499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649c:	6a 00                	push   $0x0
8010649e:	6a 00                	push   $0x0
801064a0:	6a 01                	push   $0x1
801064a2:	50                   	push   %eax
801064a3:	e8 62 fc ff ff       	call   8010610a <create>
801064a8:	83 c4 10             	add    $0x10,%esp
801064ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b2:	75 0c                	jne    801064c0 <sys_mkdir+0x47>
    end_op();
801064b4:	e8 b2 d1 ff ff       	call   8010366b <end_op>
    return -1;
801064b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064be:	eb 18                	jmp    801064d8 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	ff 75 f4             	pushl  -0xc(%ebp)
801064c6:	e8 6c b7 ff ff       	call   80101c37 <iunlockput>
801064cb:	83 c4 10             	add    $0x10,%esp
  end_op();
801064ce:	e8 98 d1 ff ff       	call   8010366b <end_op>
  return 0;
801064d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064d8:	c9                   	leave  
801064d9:	c3                   	ret    

801064da <sys_mknod>:

int
sys_mknod(void)
{
801064da:	55                   	push   %ebp
801064db:	89 e5                	mov    %esp,%ebp
801064dd:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801064e0:	e8 fa d0 ff ff       	call   801035df <begin_op>
  if((argstr(0, &path)) < 0 ||
801064e5:	83 ec 08             	sub    $0x8,%esp
801064e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064eb:	50                   	push   %eax
801064ec:	6a 00                	push   $0x0
801064ee:	e8 e9 f4 ff ff       	call   801059dc <argstr>
801064f3:	83 c4 10             	add    $0x10,%esp
801064f6:	85 c0                	test   %eax,%eax
801064f8:	78 4f                	js     80106549 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
801064fa:	83 ec 08             	sub    $0x8,%esp
801064fd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106500:	50                   	push   %eax
80106501:	6a 01                	push   $0x1
80106503:	e8 47 f4 ff ff       	call   8010594f <argint>
80106508:	83 c4 10             	add    $0x10,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010650b:	85 c0                	test   %eax,%eax
8010650d:	78 3a                	js     80106549 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010650f:	83 ec 08             	sub    $0x8,%esp
80106512:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106515:	50                   	push   %eax
80106516:	6a 02                	push   $0x2
80106518:	e8 32 f4 ff ff       	call   8010594f <argint>
8010651d:	83 c4 10             	add    $0x10,%esp
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106520:	85 c0                	test   %eax,%eax
80106522:	78 25                	js     80106549 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106524:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106527:	0f bf c8             	movswl %ax,%ecx
8010652a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010652d:	0f bf d0             	movswl %ax,%edx
80106530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106533:	51                   	push   %ecx
80106534:	52                   	push   %edx
80106535:	6a 03                	push   $0x3
80106537:	50                   	push   %eax
80106538:	e8 cd fb ff ff       	call   8010610a <create>
8010653d:	83 c4 10             	add    $0x10,%esp
80106540:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106547:	75 0c                	jne    80106555 <sys_mknod+0x7b>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106549:	e8 1d d1 ff ff       	call   8010366b <end_op>
    return -1;
8010654e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106553:	eb 18                	jmp    8010656d <sys_mknod+0x93>
  }
  iunlockput(ip);
80106555:	83 ec 0c             	sub    $0xc,%esp
80106558:	ff 75 f4             	pushl  -0xc(%ebp)
8010655b:	e8 d7 b6 ff ff       	call   80101c37 <iunlockput>
80106560:	83 c4 10             	add    $0x10,%esp
  end_op();
80106563:	e8 03 d1 ff ff       	call   8010366b <end_op>
  return 0;
80106568:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010656d:	c9                   	leave  
8010656e:	c3                   	ret    

8010656f <sys_chdir>:

int
sys_chdir(void)
{
8010656f:	55                   	push   %ebp
80106570:	89 e5                	mov    %esp,%ebp
80106572:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106575:	e8 65 d0 ff ff       	call   801035df <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010657a:	83 ec 08             	sub    $0x8,%esp
8010657d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106580:	50                   	push   %eax
80106581:	6a 00                	push   $0x0
80106583:	e8 54 f4 ff ff       	call   801059dc <argstr>
80106588:	83 c4 10             	add    $0x10,%esp
8010658b:	85 c0                	test   %eax,%eax
8010658d:	78 18                	js     801065a7 <sys_chdir+0x38>
8010658f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106592:	83 ec 0c             	sub    $0xc,%esp
80106595:	50                   	push   %eax
80106596:	e8 ac bf ff ff       	call   80102547 <namei>
8010659b:	83 c4 10             	add    $0x10,%esp
8010659e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a5:	75 0c                	jne    801065b3 <sys_chdir+0x44>
    end_op();
801065a7:	e8 bf d0 ff ff       	call   8010366b <end_op>
    return -1;
801065ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b1:	eb 6e                	jmp    80106621 <sys_chdir+0xb2>
  }
  ilock(ip);
801065b3:	83 ec 0c             	sub    $0xc,%esp
801065b6:	ff 75 f4             	pushl  -0xc(%ebp)
801065b9:	e8 63 b4 ff ff       	call   80101a21 <ilock>
801065be:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801065c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801065c8:	66 83 f8 01          	cmp    $0x1,%ax
801065cc:	74 1a                	je     801065e8 <sys_chdir+0x79>
    iunlockput(ip);
801065ce:	83 ec 0c             	sub    $0xc,%esp
801065d1:	ff 75 f4             	pushl  -0xc(%ebp)
801065d4:	e8 5e b6 ff ff       	call   80101c37 <iunlockput>
801065d9:	83 c4 10             	add    $0x10,%esp
    end_op();
801065dc:	e8 8a d0 ff ff       	call   8010366b <end_op>
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e6:	eb 39                	jmp    80106621 <sys_chdir+0xb2>
  }
  iunlock(ip);
801065e8:	83 ec 0c             	sub    $0xc,%esp
801065eb:	ff 75 f4             	pushl  -0xc(%ebp)
801065ee:	e8 4b b5 ff ff       	call   80101b3e <iunlock>
801065f3:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801065f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065fc:	8b 40 78             	mov    0x78(%eax),%eax
801065ff:	83 ec 0c             	sub    $0xc,%esp
80106602:	50                   	push   %eax
80106603:	e8 84 b5 ff ff       	call   80101b8c <iput>
80106608:	83 c4 10             	add    $0x10,%esp
  end_op();
8010660b:	e8 5b d0 ff ff       	call   8010366b <end_op>
  proc->cwd = ip;
80106610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106616:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106619:	89 50 78             	mov    %edx,0x78(%eax)
  return 0;
8010661c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106621:	c9                   	leave  
80106622:	c3                   	ret    

80106623 <sys_exec>:

int
sys_exec(void)
{
80106623:	55                   	push   %ebp
80106624:	89 e5                	mov    %esp,%ebp
80106626:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010662c:	83 ec 08             	sub    $0x8,%esp
8010662f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106632:	50                   	push   %eax
80106633:	6a 00                	push   $0x0
80106635:	e8 a2 f3 ff ff       	call   801059dc <argstr>
8010663a:	83 c4 10             	add    $0x10,%esp
8010663d:	85 c0                	test   %eax,%eax
8010663f:	78 18                	js     80106659 <sys_exec+0x36>
80106641:	83 ec 08             	sub    $0x8,%esp
80106644:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010664a:	50                   	push   %eax
8010664b:	6a 01                	push   $0x1
8010664d:	e8 fd f2 ff ff       	call   8010594f <argint>
80106652:	83 c4 10             	add    $0x10,%esp
80106655:	85 c0                	test   %eax,%eax
80106657:	79 0a                	jns    80106663 <sys_exec+0x40>
    return -1;
80106659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665e:	e9 c6 00 00 00       	jmp    80106729 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106663:	83 ec 04             	sub    $0x4,%esp
80106666:	68 80 00 00 00       	push   $0x80
8010666b:	6a 00                	push   $0x0
8010666d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106673:	50                   	push   %eax
80106674:	e8 ad ef ff ff       	call   80105626 <memset>
80106679:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010667c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106686:	83 f8 1f             	cmp    $0x1f,%eax
80106689:	76 0a                	jbe    80106695 <sys_exec+0x72>
      return -1;
8010668b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106690:	e9 94 00 00 00       	jmp    80106729 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106698:	c1 e0 02             	shl    $0x2,%eax
8010669b:	89 c2                	mov    %eax,%edx
8010669d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801066a3:	01 c2                	add    %eax,%edx
801066a5:	83 ec 08             	sub    $0x8,%esp
801066a8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801066ae:	50                   	push   %eax
801066af:	52                   	push   %edx
801066b0:	e8 fa f1 ff ff       	call   801058af <fetchint>
801066b5:	83 c4 10             	add    $0x10,%esp
801066b8:	85 c0                	test   %eax,%eax
801066ba:	79 07                	jns    801066c3 <sys_exec+0xa0>
      return -1;
801066bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c1:	eb 66                	jmp    80106729 <sys_exec+0x106>
    if(uarg == 0){
801066c3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801066c9:	85 c0                	test   %eax,%eax
801066cb:	75 27                	jne    801066f4 <sys_exec+0xd1>
      argv[i] = 0;
801066cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d0:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801066d7:	00 00 00 00 
      break;
801066db:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801066dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066df:	83 ec 08             	sub    $0x8,%esp
801066e2:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801066e8:	52                   	push   %edx
801066e9:	50                   	push   %eax
801066ea:	e8 bc a4 ff ff       	call   80100bab <exec>
801066ef:	83 c4 10             	add    $0x10,%esp
801066f2:	eb 35                	jmp    80106729 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801066f4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066fd:	c1 e2 02             	shl    $0x2,%edx
80106700:	01 c2                	add    %eax,%edx
80106702:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106708:	83 ec 08             	sub    $0x8,%esp
8010670b:	52                   	push   %edx
8010670c:	50                   	push   %eax
8010670d:	e8 d9 f1 ff ff       	call   801058eb <fetchstr>
80106712:	83 c4 10             	add    $0x10,%esp
80106715:	85 c0                	test   %eax,%eax
80106717:	79 07                	jns    80106720 <sys_exec+0xfd>
      return -1;
80106719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671e:	eb 09                	jmp    80106729 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106720:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106724:	e9 5a ff ff ff       	jmp    80106683 <sys_exec+0x60>
  return exec(path, argv);
}
80106729:	c9                   	leave  
8010672a:	c3                   	ret    

8010672b <sys_pipe>:

int
sys_pipe(void)
{
8010672b:	55                   	push   %ebp
8010672c:	89 e5                	mov    %esp,%ebp
8010672e:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106731:	83 ec 04             	sub    $0x4,%esp
80106734:	6a 08                	push   $0x8
80106736:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106739:	50                   	push   %eax
8010673a:	6a 00                	push   $0x0
8010673c:	e8 36 f2 ff ff       	call   80105977 <argptr>
80106741:	83 c4 10             	add    $0x10,%esp
80106744:	85 c0                	test   %eax,%eax
80106746:	79 0a                	jns    80106752 <sys_pipe+0x27>
    return -1;
80106748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674d:	e9 af 00 00 00       	jmp    80106801 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106752:	83 ec 08             	sub    $0x8,%esp
80106755:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106758:	50                   	push   %eax
80106759:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010675c:	50                   	push   %eax
8010675d:	e8 77 d8 ff ff       	call   80103fd9 <pipealloc>
80106762:	83 c4 10             	add    $0x10,%esp
80106765:	85 c0                	test   %eax,%eax
80106767:	79 0a                	jns    80106773 <sys_pipe+0x48>
    return -1;
80106769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676e:	e9 8e 00 00 00       	jmp    80106801 <sys_pipe+0xd6>
  fd0 = -1;
80106773:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010677a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010677d:	83 ec 0c             	sub    $0xc,%esp
80106780:	50                   	push   %eax
80106781:	e8 81 f3 ff ff       	call   80105b07 <fdalloc>
80106786:	83 c4 10             	add    $0x10,%esp
80106789:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010678c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106790:	78 18                	js     801067aa <sys_pipe+0x7f>
80106792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106795:	83 ec 0c             	sub    $0xc,%esp
80106798:	50                   	push   %eax
80106799:	e8 69 f3 ff ff       	call   80105b07 <fdalloc>
8010679e:	83 c4 10             	add    $0x10,%esp
801067a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067a8:	79 3f                	jns    801067e9 <sys_pipe+0xbe>
    if(fd0 >= 0)
801067aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067ae:	78 14                	js     801067c4 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801067b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067b9:	83 c2 0c             	add    $0xc,%edx
801067bc:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801067c3:	00 
    fileclose(rf);
801067c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067c7:	83 ec 0c             	sub    $0xc,%esp
801067ca:	50                   	push   %eax
801067cb:	e8 f2 a8 ff ff       	call   801010c2 <fileclose>
801067d0:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801067d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067d6:	83 ec 0c             	sub    $0xc,%esp
801067d9:	50                   	push   %eax
801067da:	e8 e3 a8 ff ff       	call   801010c2 <fileclose>
801067df:	83 c4 10             	add    $0x10,%esp
    return -1;
801067e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067e7:	eb 18                	jmp    80106801 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801067e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067ef:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801067f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067f4:	8d 50 04             	lea    0x4(%eax),%edx
801067f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067fa:	89 02                	mov    %eax,(%edx)
  return 0;
801067fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106801:	c9                   	leave  
80106802:	c3                   	ret    

80106803 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106803:	55                   	push   %ebp
80106804:	89 e5                	mov    %esp,%ebp
80106806:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106809:	e8 80 df ff ff       	call   8010478e <fork>
}
8010680e:	c9                   	leave  
8010680f:	c3                   	ret    

80106810 <sys_exit>:

int
sys_exit(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 08             	sub    $0x8,%esp
  exit();
80106816:	e8 03 e1 ff ff       	call   8010491e <exit>
  return 0;  // not reached
8010681b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106820:	c9                   	leave  
80106821:	c3                   	ret    

80106822 <sys_wait>:

int
sys_wait(void)
{
80106822:	55                   	push   %ebp
80106823:	89 e5                	mov    %esp,%ebp
80106825:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106828:	e8 2c e2 ff ff       	call   80104a59 <wait>
}
8010682d:	c9                   	leave  
8010682e:	c3                   	ret    

8010682f <sys_wait2>:

int sys_wait2(void) {
8010682f:	55                   	push   %ebp
80106830:	89 e5                	mov    %esp,%ebp
80106832:	83 ec 18             	sub    $0x18,%esp
  int *retime, *rutime, *stime;
  if (argptr(0, (void*)&retime, sizeof(retime)) < 0)
80106835:	83 ec 04             	sub    $0x4,%esp
80106838:	6a 04                	push   $0x4
8010683a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010683d:	50                   	push   %eax
8010683e:	6a 00                	push   $0x0
80106840:	e8 32 f1 ff ff       	call   80105977 <argptr>
80106845:	83 c4 10             	add    $0x10,%esp
80106848:	85 c0                	test   %eax,%eax
8010684a:	79 07                	jns    80106853 <sys_wait2+0x24>
    return -1;
8010684c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106851:	eb 53                	jmp    801068a6 <sys_wait2+0x77>
  if (argptr(1, (void*)&rutime, sizeof(retime)) < 0)
80106853:	83 ec 04             	sub    $0x4,%esp
80106856:	6a 04                	push   $0x4
80106858:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010685b:	50                   	push   %eax
8010685c:	6a 01                	push   $0x1
8010685e:	e8 14 f1 ff ff       	call   80105977 <argptr>
80106863:	83 c4 10             	add    $0x10,%esp
80106866:	85 c0                	test   %eax,%eax
80106868:	79 07                	jns    80106871 <sys_wait2+0x42>
    return -1;
8010686a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010686f:	eb 35                	jmp    801068a6 <sys_wait2+0x77>
  if (argptr(2, (void*)&stime, sizeof(stime)) < 0)
80106871:	83 ec 04             	sub    $0x4,%esp
80106874:	6a 04                	push   $0x4
80106876:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106879:	50                   	push   %eax
8010687a:	6a 02                	push   $0x2
8010687c:	e8 f6 f0 ff ff       	call   80105977 <argptr>
80106881:	83 c4 10             	add    $0x10,%esp
80106884:	85 c0                	test   %eax,%eax
80106886:	79 07                	jns    8010688f <sys_wait2+0x60>
    return -1;
80106888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010688d:	eb 17                	jmp    801068a6 <sys_wait2+0x77>
  return wait2(retime, rutime , stime);
8010688f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106892:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106898:	83 ec 04             	sub    $0x4,%esp
8010689b:	51                   	push   %ecx
8010689c:	52                   	push   %edx
8010689d:	50                   	push   %eax
8010689e:	e8 dc e2 ff ff       	call   80104b7f <wait2>
801068a3:	83 c4 10             	add    $0x10,%esp
}
801068a6:	c9                   	leave  
801068a7:	c3                   	ret    

801068a8 <sys_kill>:

int
sys_kill(void)
{
801068a8:	55                   	push   %ebp
801068a9:	89 e5                	mov    %esp,%ebp
801068ab:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801068ae:	83 ec 08             	sub    $0x8,%esp
801068b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068b4:	50                   	push   %eax
801068b5:	6a 00                	push   $0x0
801068b7:	e8 93 f0 ff ff       	call   8010594f <argint>
801068bc:	83 c4 10             	add    $0x10,%esp
801068bf:	85 c0                	test   %eax,%eax
801068c1:	79 07                	jns    801068ca <sys_kill+0x22>
    return -1;
801068c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c8:	eb 0f                	jmp    801068d9 <sys_kill+0x31>
  return kill(pid);
801068ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068cd:	83 ec 0c             	sub    $0xc,%esp
801068d0:	50                   	push   %eax
801068d1:	e8 6a e7 ff ff       	call   80105040 <kill>
801068d6:	83 c4 10             	add    $0x10,%esp
}
801068d9:	c9                   	leave  
801068da:	c3                   	ret    

801068db <sys_getpid>:

int
sys_getpid(void)
{
801068db:	55                   	push   %ebp
801068dc:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801068de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068e4:	8b 40 10             	mov    0x10(%eax),%eax
}
801068e7:	5d                   	pop    %ebp
801068e8:	c3                   	ret    

801068e9 <sys_getppid>:

int
sys_getppid(void)
{
801068e9:	55                   	push   %ebp
801068ea:	89 e5                	mov    %esp,%ebp
801068ec:	83 ec 10             	sub    $0x10,%esp
  int t = proc->parent->pid;
801068ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f5:	8b 40 24             	mov    0x24(%eax),%eax
801068f8:	8b 40 10             	mov    0x10(%eax),%eax
801068fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return t;
801068fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106901:	c9                   	leave  
80106902:	c3                   	ret    

80106903 <sys_sbrk>:


int
sys_sbrk(void)
{
80106903:	55                   	push   %ebp
80106904:	89 e5                	mov    %esp,%ebp
80106906:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106909:	83 ec 08             	sub    $0x8,%esp
8010690c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010690f:	50                   	push   %eax
80106910:	6a 00                	push   $0x0
80106912:	e8 38 f0 ff ff       	call   8010594f <argint>
80106917:	83 c4 10             	add    $0x10,%esp
8010691a:	85 c0                	test   %eax,%eax
8010691c:	79 07                	jns    80106925 <sys_sbrk+0x22>
    return -1;
8010691e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106923:	eb 29                	jmp    8010694e <sys_sbrk+0x4b>
  addr = proc->sz;
80106925:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692b:	8b 40 14             	mov    0x14(%eax),%eax
8010692e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106931:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106934:	83 ec 0c             	sub    $0xc,%esp
80106937:	50                   	push   %eax
80106938:	e8 ac dd ff ff       	call   801046e9 <growproc>
8010693d:	83 c4 10             	add    $0x10,%esp
80106940:	85 c0                	test   %eax,%eax
80106942:	79 07                	jns    8010694b <sys_sbrk+0x48>
    return -1;
80106944:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106949:	eb 03                	jmp    8010694e <sys_sbrk+0x4b>
  return addr;
8010694b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010694e:	c9                   	leave  
8010694f:	c3                   	ret    

80106950 <sys_sleep>:

int
sys_sleep(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106956:	83 ec 08             	sub    $0x8,%esp
80106959:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010695c:	50                   	push   %eax
8010695d:	6a 00                	push   $0x0
8010695f:	e8 eb ef ff ff       	call   8010594f <argint>
80106964:	83 c4 10             	add    $0x10,%esp
80106967:	85 c0                	test   %eax,%eax
80106969:	79 07                	jns    80106972 <sys_sleep+0x22>
    return -1;
8010696b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106970:	eb 77                	jmp    801069e9 <sys_sleep+0x99>
  acquire(&tickslock);
80106972:	83 ec 0c             	sub    $0xc,%esp
80106975:	68 80 75 11 80       	push   $0x80117580
8010697a:	e8 2d ea ff ff       	call   801053ac <acquire>
8010697f:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106982:	a1 c0 7d 11 80       	mov    0x80117dc0,%eax
80106987:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010698a:	eb 39                	jmp    801069c5 <sys_sleep+0x75>
    if(proc->killed){
8010698c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106992:	8b 40 34             	mov    0x34(%eax),%eax
80106995:	85 c0                	test   %eax,%eax
80106997:	74 17                	je     801069b0 <sys_sleep+0x60>
      release(&tickslock);
80106999:	83 ec 0c             	sub    $0xc,%esp
8010699c:	68 80 75 11 80       	push   $0x80117580
801069a1:	e8 72 ea ff ff       	call   80105418 <release>
801069a6:	83 c4 10             	add    $0x10,%esp
      return -1;
801069a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ae:	eb 39                	jmp    801069e9 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801069b0:	83 ec 08             	sub    $0x8,%esp
801069b3:	68 80 75 11 80       	push   $0x80117580
801069b8:	68 c0 7d 11 80       	push   $0x80117dc0
801069bd:	e8 59 e5 ff ff       	call   80104f1b <sleep>
801069c2:	83 c4 10             	add    $0x10,%esp

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801069c5:	a1 c0 7d 11 80       	mov    0x80117dc0,%eax
801069ca:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069d0:	39 d0                	cmp    %edx,%eax
801069d2:	72 b8                	jb     8010698c <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801069d4:	83 ec 0c             	sub    $0xc,%esp
801069d7:	68 80 75 11 80       	push   $0x80117580
801069dc:	e8 37 ea ff ff       	call   80105418 <release>
801069e1:	83 c4 10             	add    $0x10,%esp
  return 0;
801069e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069e9:	c9                   	leave  
801069ea:	c3                   	ret    

801069eb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069eb:	55                   	push   %ebp
801069ec:	89 e5                	mov    %esp,%ebp
801069ee:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
801069f1:	83 ec 0c             	sub    $0xc,%esp
801069f4:	68 80 75 11 80       	push   $0x80117580
801069f9:	e8 ae e9 ff ff       	call   801053ac <acquire>
801069fe:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106a01:	a1 c0 7d 11 80       	mov    0x80117dc0,%eax
80106a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106a09:	83 ec 0c             	sub    $0xc,%esp
80106a0c:	68 80 75 11 80       	push   $0x80117580
80106a11:	e8 02 ea ff ff       	call   80105418 <release>
80106a16:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a1c:	c9                   	leave  
80106a1d:	c3                   	ret    

80106a1e <sys_nice>:
void
sys_nice(int pid)
{
80106a1e:	55                   	push   %ebp
80106a1f:	89 e5                	mov    %esp,%ebp
80106a21:	83 ec 08             	sub    $0x8,%esp
  return nice(pid);
80106a24:	83 ec 0c             	sub    $0xc,%esp
80106a27:	ff 75 08             	pushl  0x8(%ebp)
80106a2a:	e8 9b e7 ff ff       	call   801051ca <nice>
80106a2f:	83 c4 10             	add    $0x10,%esp
}
80106a32:	c9                   	leave  
80106a33:	c3                   	ret    

80106a34 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a34:	55                   	push   %ebp
80106a35:	89 e5                	mov    %esp,%ebp
80106a37:	83 ec 08             	sub    $0x8,%esp
80106a3a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a40:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a44:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a47:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a4b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a4f:	ee                   	out    %al,(%dx)
}
80106a50:	90                   	nop
80106a51:	c9                   	leave  
80106a52:	c3                   	ret    

80106a53 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106a53:	55                   	push   %ebp
80106a54:	89 e5                	mov    %esp,%ebp
80106a56:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106a59:	6a 34                	push   $0x34
80106a5b:	6a 43                	push   $0x43
80106a5d:	e8 d2 ff ff ff       	call   80106a34 <outb>
80106a62:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106a65:	68 9c 00 00 00       	push   $0x9c
80106a6a:	6a 40                	push   $0x40
80106a6c:	e8 c3 ff ff ff       	call   80106a34 <outb>
80106a71:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106a74:	6a 2e                	push   $0x2e
80106a76:	6a 40                	push   $0x40
80106a78:	e8 b7 ff ff ff       	call   80106a34 <outb>
80106a7d:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106a80:	83 ec 0c             	sub    $0xc,%esp
80106a83:	6a 00                	push   $0x0
80106a85:	e8 39 d4 ff ff       	call   80103ec3 <picenable>
80106a8a:	83 c4 10             	add    $0x10,%esp
}
80106a8d:	90                   	nop
80106a8e:	c9                   	leave  
80106a8f:	c3                   	ret    

80106a90 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106a90:	1e                   	push   %ds
  pushl %es
80106a91:	06                   	push   %es
  pushl %fs
80106a92:	0f a0                	push   %fs
  pushl %gs
80106a94:	0f a8                	push   %gs
  pushal
80106a96:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106a97:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106a9b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106a9d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106a9f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106aa3:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106aa5:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106aa7:	54                   	push   %esp
  call trap
80106aa8:	e8 d7 01 00 00       	call   80106c84 <trap>
  addl $4, %esp
80106aad:	83 c4 04             	add    $0x4,%esp

80106ab0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106ab0:	61                   	popa   
  popl %gs
80106ab1:	0f a9                	pop    %gs
  popl %fs
80106ab3:	0f a1                	pop    %fs
  popl %es
80106ab5:	07                   	pop    %es
  popl %ds
80106ab6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106ab7:	83 c4 08             	add    $0x8,%esp
  iret
80106aba:	cf                   	iret   

80106abb <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106abb:	55                   	push   %ebp
80106abc:	89 e5                	mov    %esp,%ebp
80106abe:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac4:	83 e8 01             	sub    $0x1,%eax
80106ac7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106acb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ace:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad5:	c1 e8 10             	shr    $0x10,%eax
80106ad8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106adc:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106adf:	0f 01 18             	lidtl  (%eax)
}
80106ae2:	90                   	nop
80106ae3:	c9                   	leave  
80106ae4:	c3                   	ret    

80106ae5 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106ae5:	55                   	push   %ebp
80106ae6:	89 e5                	mov    %esp,%ebp
80106ae8:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106aeb:	0f 20 d0             	mov    %cr2,%eax
80106aee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106af4:	c9                   	leave  
80106af5:	c3                   	ret    

80106af6 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106af6:	55                   	push   %ebp
80106af7:	89 e5                	mov    %esp,%ebp
80106af9:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106afc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b03:	e9 c3 00 00 00       	jmp    80106bcb <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0b:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
80106b12:	89 c2                	mov    %eax,%edx
80106b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b17:	66 89 14 c5 c0 75 11 	mov    %dx,-0x7fee8a40(,%eax,8)
80106b1e:	80 
80106b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b22:	66 c7 04 c5 c2 75 11 	movw   $0x8,-0x7fee8a3e(,%eax,8)
80106b29:	80 08 00 
80106b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2f:	0f b6 14 c5 c4 75 11 	movzbl -0x7fee8a3c(,%eax,8),%edx
80106b36:	80 
80106b37:	83 e2 e0             	and    $0xffffffe0,%edx
80106b3a:	88 14 c5 c4 75 11 80 	mov    %dl,-0x7fee8a3c(,%eax,8)
80106b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b44:	0f b6 14 c5 c4 75 11 	movzbl -0x7fee8a3c(,%eax,8),%edx
80106b4b:	80 
80106b4c:	83 e2 1f             	and    $0x1f,%edx
80106b4f:	88 14 c5 c4 75 11 80 	mov    %dl,-0x7fee8a3c(,%eax,8)
80106b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b59:	0f b6 14 c5 c5 75 11 	movzbl -0x7fee8a3b(,%eax,8),%edx
80106b60:	80 
80106b61:	83 e2 f0             	and    $0xfffffff0,%edx
80106b64:	83 ca 0e             	or     $0xe,%edx
80106b67:	88 14 c5 c5 75 11 80 	mov    %dl,-0x7fee8a3b(,%eax,8)
80106b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b71:	0f b6 14 c5 c5 75 11 	movzbl -0x7fee8a3b(,%eax,8),%edx
80106b78:	80 
80106b79:	83 e2 ef             	and    $0xffffffef,%edx
80106b7c:	88 14 c5 c5 75 11 80 	mov    %dl,-0x7fee8a3b(,%eax,8)
80106b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b86:	0f b6 14 c5 c5 75 11 	movzbl -0x7fee8a3b(,%eax,8),%edx
80106b8d:	80 
80106b8e:	83 e2 9f             	and    $0xffffff9f,%edx
80106b91:	88 14 c5 c5 75 11 80 	mov    %dl,-0x7fee8a3b(,%eax,8)
80106b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9b:	0f b6 14 c5 c5 75 11 	movzbl -0x7fee8a3b(,%eax,8),%edx
80106ba2:	80 
80106ba3:	83 ca 80             	or     $0xffffff80,%edx
80106ba6:	88 14 c5 c5 75 11 80 	mov    %dl,-0x7fee8a3b(,%eax,8)
80106bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb0:	8b 04 85 a4 c0 10 80 	mov    -0x7fef3f5c(,%eax,4),%eax
80106bb7:	c1 e8 10             	shr    $0x10,%eax
80106bba:	89 c2                	mov    %eax,%edx
80106bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbf:	66 89 14 c5 c6 75 11 	mov    %dx,-0x7fee8a3a(,%eax,8)
80106bc6:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106bc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bcb:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106bd2:	0f 8e 30 ff ff ff    	jle    80106b08 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106bd8:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80106bdd:	66 a3 c0 77 11 80    	mov    %ax,0x801177c0
80106be3:	66 c7 05 c2 77 11 80 	movw   $0x8,0x801177c2
80106bea:	08 00 
80106bec:	0f b6 05 c4 77 11 80 	movzbl 0x801177c4,%eax
80106bf3:	83 e0 e0             	and    $0xffffffe0,%eax
80106bf6:	a2 c4 77 11 80       	mov    %al,0x801177c4
80106bfb:	0f b6 05 c4 77 11 80 	movzbl 0x801177c4,%eax
80106c02:	83 e0 1f             	and    $0x1f,%eax
80106c05:	a2 c4 77 11 80       	mov    %al,0x801177c4
80106c0a:	0f b6 05 c5 77 11 80 	movzbl 0x801177c5,%eax
80106c11:	83 c8 0f             	or     $0xf,%eax
80106c14:	a2 c5 77 11 80       	mov    %al,0x801177c5
80106c19:	0f b6 05 c5 77 11 80 	movzbl 0x801177c5,%eax
80106c20:	83 e0 ef             	and    $0xffffffef,%eax
80106c23:	a2 c5 77 11 80       	mov    %al,0x801177c5
80106c28:	0f b6 05 c5 77 11 80 	movzbl 0x801177c5,%eax
80106c2f:	83 c8 60             	or     $0x60,%eax
80106c32:	a2 c5 77 11 80       	mov    %al,0x801177c5
80106c37:	0f b6 05 c5 77 11 80 	movzbl 0x801177c5,%eax
80106c3e:	83 c8 80             	or     $0xffffff80,%eax
80106c41:	a2 c5 77 11 80       	mov    %al,0x801177c5
80106c46:	a1 a4 c1 10 80       	mov    0x8010c1a4,%eax
80106c4b:	c1 e8 10             	shr    $0x10,%eax
80106c4e:	66 a3 c6 77 11 80    	mov    %ax,0x801177c6

  initlock(&tickslock, "time");
80106c54:	83 ec 08             	sub    $0x8,%esp
80106c57:	68 20 8e 10 80       	push   $0x80108e20
80106c5c:	68 80 75 11 80       	push   $0x80117580
80106c61:	e8 24 e7 ff ff       	call   8010538a <initlock>
80106c66:	83 c4 10             	add    $0x10,%esp
}
80106c69:	90                   	nop
80106c6a:	c9                   	leave  
80106c6b:	c3                   	ret    

80106c6c <idtinit>:

void
idtinit(void)
{
80106c6c:	55                   	push   %ebp
80106c6d:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106c6f:	68 00 08 00 00       	push   $0x800
80106c74:	68 c0 75 11 80       	push   $0x801175c0
80106c79:	e8 3d fe ff ff       	call   80106abb <lidt>
80106c7e:	83 c4 08             	add    $0x8,%esp
}
80106c81:	90                   	nop
80106c82:	c9                   	leave  
80106c83:	c3                   	ret    

80106c84 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106c84:	55                   	push   %ebp
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	57                   	push   %edi
80106c88:	56                   	push   %esi
80106c89:	53                   	push   %ebx
80106c8a:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c90:	8b 40 30             	mov    0x30(%eax),%eax
80106c93:	83 f8 40             	cmp    $0x40,%eax
80106c96:	75 3e                	jne    80106cd6 <trap+0x52>
    if(proc->killed)
80106c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c9e:	8b 40 34             	mov    0x34(%eax),%eax
80106ca1:	85 c0                	test   %eax,%eax
80106ca3:	74 05                	je     80106caa <trap+0x26>
      exit();
80106ca5:	e8 74 dc ff ff       	call   8010491e <exit>
    proc->tf = tf;
80106caa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80106cb3:	89 50 28             	mov    %edx,0x28(%eax)
    syscall();
80106cb6:	e8 52 ed ff ff       	call   80105a0d <syscall>
    if(proc->killed)
80106cbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc1:	8b 40 34             	mov    0x34(%eax),%eax
80106cc4:	85 c0                	test   %eax,%eax
80106cc6:	0f 84 24 02 00 00    	je     80106ef0 <trap+0x26c>
      exit();
80106ccc:	e8 4d dc ff ff       	call   8010491e <exit>
    return;
80106cd1:	e9 1a 02 00 00       	jmp    80106ef0 <trap+0x26c>
  }

  switch(tf->trapno){
80106cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd9:	8b 40 30             	mov    0x30(%eax),%eax
80106cdc:	83 e8 20             	sub    $0x20,%eax
80106cdf:	83 f8 1f             	cmp    $0x1f,%eax
80106ce2:	0f 87 d4 00 00 00    	ja     80106dbc <trap+0x138>
80106ce8:	8b 04 85 c8 8e 10 80 	mov    -0x7fef7138(,%eax,4),%eax
80106cef:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80106cf1:	e8 23 c3 ff ff       	call   80103019 <cpunum>
80106cf6:	85 c0                	test   %eax,%eax
80106cf8:	75 3d                	jne    80106d37 <trap+0xb3>
      acquire(&tickslock);
80106cfa:	83 ec 0c             	sub    $0xc,%esp
80106cfd:	68 80 75 11 80       	push   $0x80117580
80106d02:	e8 a5 e6 ff ff       	call   801053ac <acquire>
80106d07:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106d0a:	a1 c0 7d 11 80       	mov    0x80117dc0,%eax
80106d0f:	83 c0 01             	add    $0x1,%eax
80106d12:	a3 c0 7d 11 80       	mov    %eax,0x80117dc0
      wakeup(&ticks);
80106d17:	83 ec 0c             	sub    $0xc,%esp
80106d1a:	68 c0 7d 11 80       	push   $0x80117dc0
80106d1f:	e8 e5 e2 ff ff       	call   80105009 <wakeup>
80106d24:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106d27:	83 ec 0c             	sub    $0xc,%esp
80106d2a:	68 80 75 11 80       	push   $0x80117580
80106d2f:	e8 e4 e6 ff ff       	call   80105418 <release>
80106d34:	83 c4 10             	add    $0x10,%esp
    }
if(proc){
80106d37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d3d:	85 c0                	test   %eax,%eax
80106d3f:	74 15                	je     80106d56 <trap+0xd2>
proc->rutime++;
80106d41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d47:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80106d4d:	83 c2 01             	add    $0x1,%edx
80106d50:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
}
    lapiceoi();
80106d56:	e8 5c c3 ff ff       	call   801030b7 <lapiceoi>
    break;
80106d5b:	e9 0a 01 00 00       	jmp    80106e6a <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106d60:	e8 26 bb ff ff       	call   8010288b <ideintr>
    lapiceoi();
80106d65:	e8 4d c3 ff ff       	call   801030b7 <lapiceoi>
    break;
80106d6a:	e9 fb 00 00 00       	jmp    80106e6a <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106d6f:	e8 00 c1 ff ff       	call   80102e74 <kbdintr>
    lapiceoi();
80106d74:	e8 3e c3 ff ff       	call   801030b7 <lapiceoi>
    break;
80106d79:	e9 ec 00 00 00       	jmp    80106e6a <trap+0x1e6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106d7e:	e8 4e 03 00 00       	call   801070d1 <uartintr>
    lapiceoi();
80106d83:	e8 2f c3 ff ff       	call   801030b7 <lapiceoi>
    break;
80106d88:	e9 dd 00 00 00       	jmp    80106e6a <trap+0x1e6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d90:	8b 70 38             	mov    0x38(%eax),%esi
            cpunum(), tf->cs, tf->eip);
80106d93:	8b 45 08             	mov    0x8(%ebp),%eax
80106d96:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d9a:	0f b7 d8             	movzwl %ax,%ebx
80106d9d:	e8 77 c2 ff ff       	call   80103019 <cpunum>
80106da2:	56                   	push   %esi
80106da3:	53                   	push   %ebx
80106da4:	50                   	push   %eax
80106da5:	68 28 8e 10 80       	push   $0x80108e28
80106daa:	e8 51 96 ff ff       	call   80100400 <cprintf>
80106daf:	83 c4 10             	add    $0x10,%esp
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80106db2:	e8 00 c3 ff ff       	call   801030b7 <lapiceoi>
    break;
80106db7:	e9 ae 00 00 00       	jmp    80106e6a <trap+0x1e6>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106dbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc2:	85 c0                	test   %eax,%eax
80106dc4:	74 11                	je     80106dd7 <trap+0x153>
80106dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106dcd:	0f b7 c0             	movzwl %ax,%eax
80106dd0:	83 e0 03             	and    $0x3,%eax
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	75 3b                	jne    80106e12 <trap+0x18e>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106dd7:	e8 09 fd ff ff       	call   80106ae5 <rcr2>
80106ddc:	89 c6                	mov    %eax,%esi
80106dde:	8b 45 08             	mov    0x8(%ebp),%eax
80106de1:	8b 58 38             	mov    0x38(%eax),%ebx
80106de4:	e8 30 c2 ff ff       	call   80103019 <cpunum>
80106de9:	89 c2                	mov    %eax,%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	8b 40 30             	mov    0x30(%eax),%eax
80106df1:	83 ec 0c             	sub    $0xc,%esp
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	52                   	push   %edx
80106df7:	50                   	push   %eax
80106df8:	68 4c 8e 10 80       	push   $0x80108e4c
80106dfd:	e8 fe 95 ff ff       	call   80100400 <cprintf>
80106e02:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80106e05:	83 ec 0c             	sub    $0xc,%esp
80106e08:	68 7e 8e 10 80       	push   $0x80108e7e
80106e0d:	e8 8e 97 ff ff       	call   801005a0 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e12:	e8 ce fc ff ff       	call   80106ae5 <rcr2>
80106e17:	89 c7                	mov    %eax,%edi
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1c:	8b 58 38             	mov    0x38(%eax),%ebx
80106e1f:	e8 f5 c1 ff ff       	call   80103019 <cpunum>
80106e24:	89 c6                	mov    %eax,%esi
80106e26:	8b 45 08             	mov    0x8(%ebp),%eax
80106e29:	8b 48 34             	mov    0x34(%eax),%ecx
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80106e32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e41:	8b 40 10             	mov    0x10(%eax),%eax
80106e44:	57                   	push   %edi
80106e45:	53                   	push   %ebx
80106e46:	56                   	push   %esi
80106e47:	51                   	push   %ecx
80106e48:	52                   	push   %edx
80106e49:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e4c:	50                   	push   %eax
80106e4d:	68 84 8e 10 80       	push   $0x80108e84
80106e52:	e8 a9 95 ff ff       	call   80100400 <cprintf>
80106e57:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80106e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e60:	c7 40 34 01 00 00 00 	movl   $0x1,0x34(%eax)
80106e67:	eb 01                	jmp    80106e6a <trap+0x1e6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106e69:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106e6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e70:	85 c0                	test   %eax,%eax
80106e72:	74 24                	je     80106e98 <trap+0x214>
80106e74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e7a:	8b 40 34             	mov    0x34(%eax),%eax
80106e7d:	85 c0                	test   %eax,%eax
80106e7f:	74 17                	je     80106e98 <trap+0x214>
80106e81:	8b 45 08             	mov    0x8(%ebp),%eax
80106e84:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e88:	0f b7 c0             	movzwl %ax,%eax
80106e8b:	83 e0 03             	and    $0x3,%eax
80106e8e:	83 f8 03             	cmp    $0x3,%eax
80106e91:	75 05                	jne    80106e98 <trap+0x214>
    exit();
80106e93:	e8 86 da ff ff       	call   8010491e <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	74 1e                	je     80106ec0 <trap+0x23c>
80106ea2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea8:	8b 40 20             	mov    0x20(%eax),%eax
80106eab:	83 f8 04             	cmp    $0x4,%eax
80106eae:	75 10                	jne    80106ec0 <trap+0x23c>
80106eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb3:	8b 40 30             	mov    0x30(%eax),%eax
80106eb6:	83 f8 20             	cmp    $0x20,%eax
80106eb9:	75 05                	jne    80106ec0 <trap+0x23c>
    yield();
80106ebb:	e8 da df ff ff       	call   80104e9a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ec0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec6:	85 c0                	test   %eax,%eax
80106ec8:	74 27                	je     80106ef1 <trap+0x26d>
80106eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ed0:	8b 40 34             	mov    0x34(%eax),%eax
80106ed3:	85 c0                	test   %eax,%eax
80106ed5:	74 1a                	je     80106ef1 <trap+0x26d>
80106ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80106eda:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ede:	0f b7 c0             	movzwl %ax,%eax
80106ee1:	83 e0 03             	and    $0x3,%eax
80106ee4:	83 f8 03             	cmp    $0x3,%eax
80106ee7:	75 08                	jne    80106ef1 <trap+0x26d>
    exit();
80106ee9:	e8 30 da ff ff       	call   8010491e <exit>
80106eee:	eb 01                	jmp    80106ef1 <trap+0x26d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106ef0:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef4:	5b                   	pop    %ebx
80106ef5:	5e                   	pop    %esi
80106ef6:	5f                   	pop    %edi
80106ef7:	5d                   	pop    %ebp
80106ef8:	c3                   	ret    

80106ef9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106ef9:	55                   	push   %ebp
80106efa:	89 e5                	mov    %esp,%ebp
80106efc:	83 ec 14             	sub    $0x14,%esp
80106eff:	8b 45 08             	mov    0x8(%ebp),%eax
80106f02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106f0a:	89 c2                	mov    %eax,%edx
80106f0c:	ec                   	in     (%dx),%al
80106f0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106f10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106f14:	c9                   	leave  
80106f15:	c3                   	ret    

80106f16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106f16:	55                   	push   %ebp
80106f17:	89 e5                	mov    %esp,%ebp
80106f19:	83 ec 08             	sub    $0x8,%esp
80106f1c:	8b 55 08             	mov    0x8(%ebp),%edx
80106f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106f26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106f2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106f31:	ee                   	out    %al,(%dx)
}
80106f32:	90                   	nop
80106f33:	c9                   	leave  
80106f34:	c3                   	ret    

80106f35 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106f35:	55                   	push   %ebp
80106f36:	89 e5                	mov    %esp,%ebp
80106f38:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106f3b:	6a 00                	push   $0x0
80106f3d:	68 fa 03 00 00       	push   $0x3fa
80106f42:	e8 cf ff ff ff       	call   80106f16 <outb>
80106f47:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106f4a:	68 80 00 00 00       	push   $0x80
80106f4f:	68 fb 03 00 00       	push   $0x3fb
80106f54:	e8 bd ff ff ff       	call   80106f16 <outb>
80106f59:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106f5c:	6a 0c                	push   $0xc
80106f5e:	68 f8 03 00 00       	push   $0x3f8
80106f63:	e8 ae ff ff ff       	call   80106f16 <outb>
80106f68:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106f6b:	6a 00                	push   $0x0
80106f6d:	68 f9 03 00 00       	push   $0x3f9
80106f72:	e8 9f ff ff ff       	call   80106f16 <outb>
80106f77:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106f7a:	6a 03                	push   $0x3
80106f7c:	68 fb 03 00 00       	push   $0x3fb
80106f81:	e8 90 ff ff ff       	call   80106f16 <outb>
80106f86:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106f89:	6a 00                	push   $0x0
80106f8b:	68 fc 03 00 00       	push   $0x3fc
80106f90:	e8 81 ff ff ff       	call   80106f16 <outb>
80106f95:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106f98:	6a 01                	push   $0x1
80106f9a:	68 f9 03 00 00       	push   $0x3f9
80106f9f:	e8 72 ff ff ff       	call   80106f16 <outb>
80106fa4:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106fa7:	68 fd 03 00 00       	push   $0x3fd
80106fac:	e8 48 ff ff ff       	call   80106ef9 <inb>
80106fb1:	83 c4 04             	add    $0x4,%esp
80106fb4:	3c ff                	cmp    $0xff,%al
80106fb6:	74 6e                	je     80107026 <uartinit+0xf1>
    return;
  uart = 1;
80106fb8:	c7 05 68 c6 10 80 01 	movl   $0x1,0x8010c668
80106fbf:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106fc2:	68 fa 03 00 00       	push   $0x3fa
80106fc7:	e8 2d ff ff ff       	call   80106ef9 <inb>
80106fcc:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106fcf:	68 f8 03 00 00       	push   $0x3f8
80106fd4:	e8 20 ff ff ff       	call   80106ef9 <inb>
80106fd9:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	6a 04                	push   $0x4
80106fe1:	e8 dd ce ff ff       	call   80103ec3 <picenable>
80106fe6:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106fe9:	83 ec 08             	sub    $0x8,%esp
80106fec:	6a 00                	push   $0x0
80106fee:	6a 04                	push   $0x4
80106ff0:	e8 42 bb ff ff       	call   80102b37 <ioapicenable>
80106ff5:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106ff8:	c7 45 f4 48 8f 10 80 	movl   $0x80108f48,-0xc(%ebp)
80106fff:	eb 19                	jmp    8010701a <uartinit+0xe5>
    uartputc(*p);
80107001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107004:	0f b6 00             	movzbl (%eax),%eax
80107007:	0f be c0             	movsbl %al,%eax
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	50                   	push   %eax
8010700e:	e8 16 00 00 00       	call   80107029 <uartputc>
80107013:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107016:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010701a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010701d:	0f b6 00             	movzbl (%eax),%eax
80107020:	84 c0                	test   %al,%al
80107022:	75 dd                	jne    80107001 <uartinit+0xcc>
80107024:	eb 01                	jmp    80107027 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107026:	90                   	nop
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107027:	c9                   	leave  
80107028:	c3                   	ret    

80107029 <uartputc>:

void
uartputc(int c)
{
80107029:	55                   	push   %ebp
8010702a:	89 e5                	mov    %esp,%ebp
8010702c:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010702f:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80107034:	85 c0                	test   %eax,%eax
80107036:	74 53                	je     8010708b <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010703f:	eb 11                	jmp    80107052 <uartputc+0x29>
    microdelay(10);
80107041:	83 ec 0c             	sub    $0xc,%esp
80107044:	6a 0a                	push   $0xa
80107046:	e8 87 c0 ff ff       	call   801030d2 <microdelay>
8010704b:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010704e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107052:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107056:	7f 1a                	jg     80107072 <uartputc+0x49>
80107058:	83 ec 0c             	sub    $0xc,%esp
8010705b:	68 fd 03 00 00       	push   $0x3fd
80107060:	e8 94 fe ff ff       	call   80106ef9 <inb>
80107065:	83 c4 10             	add    $0x10,%esp
80107068:	0f b6 c0             	movzbl %al,%eax
8010706b:	83 e0 20             	and    $0x20,%eax
8010706e:	85 c0                	test   %eax,%eax
80107070:	74 cf                	je     80107041 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107072:	8b 45 08             	mov    0x8(%ebp),%eax
80107075:	0f b6 c0             	movzbl %al,%eax
80107078:	83 ec 08             	sub    $0x8,%esp
8010707b:	50                   	push   %eax
8010707c:	68 f8 03 00 00       	push   $0x3f8
80107081:	e8 90 fe ff ff       	call   80106f16 <outb>
80107086:	83 c4 10             	add    $0x10,%esp
80107089:	eb 01                	jmp    8010708c <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010708b:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010708c:	c9                   	leave  
8010708d:	c3                   	ret    

8010708e <uartgetc>:

static int
uartgetc(void)
{
8010708e:	55                   	push   %ebp
8010708f:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107091:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80107096:	85 c0                	test   %eax,%eax
80107098:	75 07                	jne    801070a1 <uartgetc+0x13>
    return -1;
8010709a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010709f:	eb 2e                	jmp    801070cf <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801070a1:	68 fd 03 00 00       	push   $0x3fd
801070a6:	e8 4e fe ff ff       	call   80106ef9 <inb>
801070ab:	83 c4 04             	add    $0x4,%esp
801070ae:	0f b6 c0             	movzbl %al,%eax
801070b1:	83 e0 01             	and    $0x1,%eax
801070b4:	85 c0                	test   %eax,%eax
801070b6:	75 07                	jne    801070bf <uartgetc+0x31>
    return -1;
801070b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070bd:	eb 10                	jmp    801070cf <uartgetc+0x41>
  return inb(COM1+0);
801070bf:	68 f8 03 00 00       	push   $0x3f8
801070c4:	e8 30 fe ff ff       	call   80106ef9 <inb>
801070c9:	83 c4 04             	add    $0x4,%esp
801070cc:	0f b6 c0             	movzbl %al,%eax
}
801070cf:	c9                   	leave  
801070d0:	c3                   	ret    

801070d1 <uartintr>:

void
uartintr(void)
{
801070d1:	55                   	push   %ebp
801070d2:	89 e5                	mov    %esp,%ebp
801070d4:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801070d7:	83 ec 0c             	sub    $0xc,%esp
801070da:	68 8e 70 10 80       	push   $0x8010708e
801070df:	e8 4f 97 ff ff       	call   80100833 <consoleintr>
801070e4:	83 c4 10             	add    $0x10,%esp
}
801070e7:	90                   	nop
801070e8:	c9                   	leave  
801070e9:	c3                   	ret    

801070ea <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $0
801070ec:	6a 00                	push   $0x0
  jmp alltraps
801070ee:	e9 9d f9 ff ff       	jmp    80106a90 <alltraps>

801070f3 <vector1>:
.globl vector1
vector1:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $1
801070f5:	6a 01                	push   $0x1
  jmp alltraps
801070f7:	e9 94 f9 ff ff       	jmp    80106a90 <alltraps>

801070fc <vector2>:
.globl vector2
vector2:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $2
801070fe:	6a 02                	push   $0x2
  jmp alltraps
80107100:	e9 8b f9 ff ff       	jmp    80106a90 <alltraps>

80107105 <vector3>:
.globl vector3
vector3:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $3
80107107:	6a 03                	push   $0x3
  jmp alltraps
80107109:	e9 82 f9 ff ff       	jmp    80106a90 <alltraps>

8010710e <vector4>:
.globl vector4
vector4:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $4
80107110:	6a 04                	push   $0x4
  jmp alltraps
80107112:	e9 79 f9 ff ff       	jmp    80106a90 <alltraps>

80107117 <vector5>:
.globl vector5
vector5:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $5
80107119:	6a 05                	push   $0x5
  jmp alltraps
8010711b:	e9 70 f9 ff ff       	jmp    80106a90 <alltraps>

80107120 <vector6>:
.globl vector6
vector6:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $6
80107122:	6a 06                	push   $0x6
  jmp alltraps
80107124:	e9 67 f9 ff ff       	jmp    80106a90 <alltraps>

80107129 <vector7>:
.globl vector7
vector7:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $7
8010712b:	6a 07                	push   $0x7
  jmp alltraps
8010712d:	e9 5e f9 ff ff       	jmp    80106a90 <alltraps>

80107132 <vector8>:
.globl vector8
vector8:
  pushl $8
80107132:	6a 08                	push   $0x8
  jmp alltraps
80107134:	e9 57 f9 ff ff       	jmp    80106a90 <alltraps>

80107139 <vector9>:
.globl vector9
vector9:
  pushl $0
80107139:	6a 00                	push   $0x0
  pushl $9
8010713b:	6a 09                	push   $0x9
  jmp alltraps
8010713d:	e9 4e f9 ff ff       	jmp    80106a90 <alltraps>

80107142 <vector10>:
.globl vector10
vector10:
  pushl $10
80107142:	6a 0a                	push   $0xa
  jmp alltraps
80107144:	e9 47 f9 ff ff       	jmp    80106a90 <alltraps>

80107149 <vector11>:
.globl vector11
vector11:
  pushl $11
80107149:	6a 0b                	push   $0xb
  jmp alltraps
8010714b:	e9 40 f9 ff ff       	jmp    80106a90 <alltraps>

80107150 <vector12>:
.globl vector12
vector12:
  pushl $12
80107150:	6a 0c                	push   $0xc
  jmp alltraps
80107152:	e9 39 f9 ff ff       	jmp    80106a90 <alltraps>

80107157 <vector13>:
.globl vector13
vector13:
  pushl $13
80107157:	6a 0d                	push   $0xd
  jmp alltraps
80107159:	e9 32 f9 ff ff       	jmp    80106a90 <alltraps>

8010715e <vector14>:
.globl vector14
vector14:
  pushl $14
8010715e:	6a 0e                	push   $0xe
  jmp alltraps
80107160:	e9 2b f9 ff ff       	jmp    80106a90 <alltraps>

80107165 <vector15>:
.globl vector15
vector15:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $15
80107167:	6a 0f                	push   $0xf
  jmp alltraps
80107169:	e9 22 f9 ff ff       	jmp    80106a90 <alltraps>

8010716e <vector16>:
.globl vector16
vector16:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $16
80107170:	6a 10                	push   $0x10
  jmp alltraps
80107172:	e9 19 f9 ff ff       	jmp    80106a90 <alltraps>

80107177 <vector17>:
.globl vector17
vector17:
  pushl $17
80107177:	6a 11                	push   $0x11
  jmp alltraps
80107179:	e9 12 f9 ff ff       	jmp    80106a90 <alltraps>

8010717e <vector18>:
.globl vector18
vector18:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $18
80107180:	6a 12                	push   $0x12
  jmp alltraps
80107182:	e9 09 f9 ff ff       	jmp    80106a90 <alltraps>

80107187 <vector19>:
.globl vector19
vector19:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $19
80107189:	6a 13                	push   $0x13
  jmp alltraps
8010718b:	e9 00 f9 ff ff       	jmp    80106a90 <alltraps>

80107190 <vector20>:
.globl vector20
vector20:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $20
80107192:	6a 14                	push   $0x14
  jmp alltraps
80107194:	e9 f7 f8 ff ff       	jmp    80106a90 <alltraps>

80107199 <vector21>:
.globl vector21
vector21:
  pushl $0
80107199:	6a 00                	push   $0x0
  pushl $21
8010719b:	6a 15                	push   $0x15
  jmp alltraps
8010719d:	e9 ee f8 ff ff       	jmp    80106a90 <alltraps>

801071a2 <vector22>:
.globl vector22
vector22:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $22
801071a4:	6a 16                	push   $0x16
  jmp alltraps
801071a6:	e9 e5 f8 ff ff       	jmp    80106a90 <alltraps>

801071ab <vector23>:
.globl vector23
vector23:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $23
801071ad:	6a 17                	push   $0x17
  jmp alltraps
801071af:	e9 dc f8 ff ff       	jmp    80106a90 <alltraps>

801071b4 <vector24>:
.globl vector24
vector24:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $24
801071b6:	6a 18                	push   $0x18
  jmp alltraps
801071b8:	e9 d3 f8 ff ff       	jmp    80106a90 <alltraps>

801071bd <vector25>:
.globl vector25
vector25:
  pushl $0
801071bd:	6a 00                	push   $0x0
  pushl $25
801071bf:	6a 19                	push   $0x19
  jmp alltraps
801071c1:	e9 ca f8 ff ff       	jmp    80106a90 <alltraps>

801071c6 <vector26>:
.globl vector26
vector26:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $26
801071c8:	6a 1a                	push   $0x1a
  jmp alltraps
801071ca:	e9 c1 f8 ff ff       	jmp    80106a90 <alltraps>

801071cf <vector27>:
.globl vector27
vector27:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $27
801071d1:	6a 1b                	push   $0x1b
  jmp alltraps
801071d3:	e9 b8 f8 ff ff       	jmp    80106a90 <alltraps>

801071d8 <vector28>:
.globl vector28
vector28:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $28
801071da:	6a 1c                	push   $0x1c
  jmp alltraps
801071dc:	e9 af f8 ff ff       	jmp    80106a90 <alltraps>

801071e1 <vector29>:
.globl vector29
vector29:
  pushl $0
801071e1:	6a 00                	push   $0x0
  pushl $29
801071e3:	6a 1d                	push   $0x1d
  jmp alltraps
801071e5:	e9 a6 f8 ff ff       	jmp    80106a90 <alltraps>

801071ea <vector30>:
.globl vector30
vector30:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $30
801071ec:	6a 1e                	push   $0x1e
  jmp alltraps
801071ee:	e9 9d f8 ff ff       	jmp    80106a90 <alltraps>

801071f3 <vector31>:
.globl vector31
vector31:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $31
801071f5:	6a 1f                	push   $0x1f
  jmp alltraps
801071f7:	e9 94 f8 ff ff       	jmp    80106a90 <alltraps>

801071fc <vector32>:
.globl vector32
vector32:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $32
801071fe:	6a 20                	push   $0x20
  jmp alltraps
80107200:	e9 8b f8 ff ff       	jmp    80106a90 <alltraps>

80107205 <vector33>:
.globl vector33
vector33:
  pushl $0
80107205:	6a 00                	push   $0x0
  pushl $33
80107207:	6a 21                	push   $0x21
  jmp alltraps
80107209:	e9 82 f8 ff ff       	jmp    80106a90 <alltraps>

8010720e <vector34>:
.globl vector34
vector34:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $34
80107210:	6a 22                	push   $0x22
  jmp alltraps
80107212:	e9 79 f8 ff ff       	jmp    80106a90 <alltraps>

80107217 <vector35>:
.globl vector35
vector35:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $35
80107219:	6a 23                	push   $0x23
  jmp alltraps
8010721b:	e9 70 f8 ff ff       	jmp    80106a90 <alltraps>

80107220 <vector36>:
.globl vector36
vector36:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $36
80107222:	6a 24                	push   $0x24
  jmp alltraps
80107224:	e9 67 f8 ff ff       	jmp    80106a90 <alltraps>

80107229 <vector37>:
.globl vector37
vector37:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $37
8010722b:	6a 25                	push   $0x25
  jmp alltraps
8010722d:	e9 5e f8 ff ff       	jmp    80106a90 <alltraps>

80107232 <vector38>:
.globl vector38
vector38:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $38
80107234:	6a 26                	push   $0x26
  jmp alltraps
80107236:	e9 55 f8 ff ff       	jmp    80106a90 <alltraps>

8010723b <vector39>:
.globl vector39
vector39:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $39
8010723d:	6a 27                	push   $0x27
  jmp alltraps
8010723f:	e9 4c f8 ff ff       	jmp    80106a90 <alltraps>

80107244 <vector40>:
.globl vector40
vector40:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $40
80107246:	6a 28                	push   $0x28
  jmp alltraps
80107248:	e9 43 f8 ff ff       	jmp    80106a90 <alltraps>

8010724d <vector41>:
.globl vector41
vector41:
  pushl $0
8010724d:	6a 00                	push   $0x0
  pushl $41
8010724f:	6a 29                	push   $0x29
  jmp alltraps
80107251:	e9 3a f8 ff ff       	jmp    80106a90 <alltraps>

80107256 <vector42>:
.globl vector42
vector42:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $42
80107258:	6a 2a                	push   $0x2a
  jmp alltraps
8010725a:	e9 31 f8 ff ff       	jmp    80106a90 <alltraps>

8010725f <vector43>:
.globl vector43
vector43:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $43
80107261:	6a 2b                	push   $0x2b
  jmp alltraps
80107263:	e9 28 f8 ff ff       	jmp    80106a90 <alltraps>

80107268 <vector44>:
.globl vector44
vector44:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $44
8010726a:	6a 2c                	push   $0x2c
  jmp alltraps
8010726c:	e9 1f f8 ff ff       	jmp    80106a90 <alltraps>

80107271 <vector45>:
.globl vector45
vector45:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $45
80107273:	6a 2d                	push   $0x2d
  jmp alltraps
80107275:	e9 16 f8 ff ff       	jmp    80106a90 <alltraps>

8010727a <vector46>:
.globl vector46
vector46:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $46
8010727c:	6a 2e                	push   $0x2e
  jmp alltraps
8010727e:	e9 0d f8 ff ff       	jmp    80106a90 <alltraps>

80107283 <vector47>:
.globl vector47
vector47:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $47
80107285:	6a 2f                	push   $0x2f
  jmp alltraps
80107287:	e9 04 f8 ff ff       	jmp    80106a90 <alltraps>

8010728c <vector48>:
.globl vector48
vector48:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $48
8010728e:	6a 30                	push   $0x30
  jmp alltraps
80107290:	e9 fb f7 ff ff       	jmp    80106a90 <alltraps>

80107295 <vector49>:
.globl vector49
vector49:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $49
80107297:	6a 31                	push   $0x31
  jmp alltraps
80107299:	e9 f2 f7 ff ff       	jmp    80106a90 <alltraps>

8010729e <vector50>:
.globl vector50
vector50:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $50
801072a0:	6a 32                	push   $0x32
  jmp alltraps
801072a2:	e9 e9 f7 ff ff       	jmp    80106a90 <alltraps>

801072a7 <vector51>:
.globl vector51
vector51:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $51
801072a9:	6a 33                	push   $0x33
  jmp alltraps
801072ab:	e9 e0 f7 ff ff       	jmp    80106a90 <alltraps>

801072b0 <vector52>:
.globl vector52
vector52:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $52
801072b2:	6a 34                	push   $0x34
  jmp alltraps
801072b4:	e9 d7 f7 ff ff       	jmp    80106a90 <alltraps>

801072b9 <vector53>:
.globl vector53
vector53:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $53
801072bb:	6a 35                	push   $0x35
  jmp alltraps
801072bd:	e9 ce f7 ff ff       	jmp    80106a90 <alltraps>

801072c2 <vector54>:
.globl vector54
vector54:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $54
801072c4:	6a 36                	push   $0x36
  jmp alltraps
801072c6:	e9 c5 f7 ff ff       	jmp    80106a90 <alltraps>

801072cb <vector55>:
.globl vector55
vector55:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $55
801072cd:	6a 37                	push   $0x37
  jmp alltraps
801072cf:	e9 bc f7 ff ff       	jmp    80106a90 <alltraps>

801072d4 <vector56>:
.globl vector56
vector56:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $56
801072d6:	6a 38                	push   $0x38
  jmp alltraps
801072d8:	e9 b3 f7 ff ff       	jmp    80106a90 <alltraps>

801072dd <vector57>:
.globl vector57
vector57:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $57
801072df:	6a 39                	push   $0x39
  jmp alltraps
801072e1:	e9 aa f7 ff ff       	jmp    80106a90 <alltraps>

801072e6 <vector58>:
.globl vector58
vector58:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $58
801072e8:	6a 3a                	push   $0x3a
  jmp alltraps
801072ea:	e9 a1 f7 ff ff       	jmp    80106a90 <alltraps>

801072ef <vector59>:
.globl vector59
vector59:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $59
801072f1:	6a 3b                	push   $0x3b
  jmp alltraps
801072f3:	e9 98 f7 ff ff       	jmp    80106a90 <alltraps>

801072f8 <vector60>:
.globl vector60
vector60:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $60
801072fa:	6a 3c                	push   $0x3c
  jmp alltraps
801072fc:	e9 8f f7 ff ff       	jmp    80106a90 <alltraps>

80107301 <vector61>:
.globl vector61
vector61:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $61
80107303:	6a 3d                	push   $0x3d
  jmp alltraps
80107305:	e9 86 f7 ff ff       	jmp    80106a90 <alltraps>

8010730a <vector62>:
.globl vector62
vector62:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $62
8010730c:	6a 3e                	push   $0x3e
  jmp alltraps
8010730e:	e9 7d f7 ff ff       	jmp    80106a90 <alltraps>

80107313 <vector63>:
.globl vector63
vector63:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $63
80107315:	6a 3f                	push   $0x3f
  jmp alltraps
80107317:	e9 74 f7 ff ff       	jmp    80106a90 <alltraps>

8010731c <vector64>:
.globl vector64
vector64:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $64
8010731e:	6a 40                	push   $0x40
  jmp alltraps
80107320:	e9 6b f7 ff ff       	jmp    80106a90 <alltraps>

80107325 <vector65>:
.globl vector65
vector65:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $65
80107327:	6a 41                	push   $0x41
  jmp alltraps
80107329:	e9 62 f7 ff ff       	jmp    80106a90 <alltraps>

8010732e <vector66>:
.globl vector66
vector66:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $66
80107330:	6a 42                	push   $0x42
  jmp alltraps
80107332:	e9 59 f7 ff ff       	jmp    80106a90 <alltraps>

80107337 <vector67>:
.globl vector67
vector67:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $67
80107339:	6a 43                	push   $0x43
  jmp alltraps
8010733b:	e9 50 f7 ff ff       	jmp    80106a90 <alltraps>

80107340 <vector68>:
.globl vector68
vector68:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $68
80107342:	6a 44                	push   $0x44
  jmp alltraps
80107344:	e9 47 f7 ff ff       	jmp    80106a90 <alltraps>

80107349 <vector69>:
.globl vector69
vector69:
  pushl $0
80107349:	6a 00                	push   $0x0
  pushl $69
8010734b:	6a 45                	push   $0x45
  jmp alltraps
8010734d:	e9 3e f7 ff ff       	jmp    80106a90 <alltraps>

80107352 <vector70>:
.globl vector70
vector70:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $70
80107354:	6a 46                	push   $0x46
  jmp alltraps
80107356:	e9 35 f7 ff ff       	jmp    80106a90 <alltraps>

8010735b <vector71>:
.globl vector71
vector71:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $71
8010735d:	6a 47                	push   $0x47
  jmp alltraps
8010735f:	e9 2c f7 ff ff       	jmp    80106a90 <alltraps>

80107364 <vector72>:
.globl vector72
vector72:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $72
80107366:	6a 48                	push   $0x48
  jmp alltraps
80107368:	e9 23 f7 ff ff       	jmp    80106a90 <alltraps>

8010736d <vector73>:
.globl vector73
vector73:
  pushl $0
8010736d:	6a 00                	push   $0x0
  pushl $73
8010736f:	6a 49                	push   $0x49
  jmp alltraps
80107371:	e9 1a f7 ff ff       	jmp    80106a90 <alltraps>

80107376 <vector74>:
.globl vector74
vector74:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $74
80107378:	6a 4a                	push   $0x4a
  jmp alltraps
8010737a:	e9 11 f7 ff ff       	jmp    80106a90 <alltraps>

8010737f <vector75>:
.globl vector75
vector75:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $75
80107381:	6a 4b                	push   $0x4b
  jmp alltraps
80107383:	e9 08 f7 ff ff       	jmp    80106a90 <alltraps>

80107388 <vector76>:
.globl vector76
vector76:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $76
8010738a:	6a 4c                	push   $0x4c
  jmp alltraps
8010738c:	e9 ff f6 ff ff       	jmp    80106a90 <alltraps>

80107391 <vector77>:
.globl vector77
vector77:
  pushl $0
80107391:	6a 00                	push   $0x0
  pushl $77
80107393:	6a 4d                	push   $0x4d
  jmp alltraps
80107395:	e9 f6 f6 ff ff       	jmp    80106a90 <alltraps>

8010739a <vector78>:
.globl vector78
vector78:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $78
8010739c:	6a 4e                	push   $0x4e
  jmp alltraps
8010739e:	e9 ed f6 ff ff       	jmp    80106a90 <alltraps>

801073a3 <vector79>:
.globl vector79
vector79:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $79
801073a5:	6a 4f                	push   $0x4f
  jmp alltraps
801073a7:	e9 e4 f6 ff ff       	jmp    80106a90 <alltraps>

801073ac <vector80>:
.globl vector80
vector80:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $80
801073ae:	6a 50                	push   $0x50
  jmp alltraps
801073b0:	e9 db f6 ff ff       	jmp    80106a90 <alltraps>

801073b5 <vector81>:
.globl vector81
vector81:
  pushl $0
801073b5:	6a 00                	push   $0x0
  pushl $81
801073b7:	6a 51                	push   $0x51
  jmp alltraps
801073b9:	e9 d2 f6 ff ff       	jmp    80106a90 <alltraps>

801073be <vector82>:
.globl vector82
vector82:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $82
801073c0:	6a 52                	push   $0x52
  jmp alltraps
801073c2:	e9 c9 f6 ff ff       	jmp    80106a90 <alltraps>

801073c7 <vector83>:
.globl vector83
vector83:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $83
801073c9:	6a 53                	push   $0x53
  jmp alltraps
801073cb:	e9 c0 f6 ff ff       	jmp    80106a90 <alltraps>

801073d0 <vector84>:
.globl vector84
vector84:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $84
801073d2:	6a 54                	push   $0x54
  jmp alltraps
801073d4:	e9 b7 f6 ff ff       	jmp    80106a90 <alltraps>

801073d9 <vector85>:
.globl vector85
vector85:
  pushl $0
801073d9:	6a 00                	push   $0x0
  pushl $85
801073db:	6a 55                	push   $0x55
  jmp alltraps
801073dd:	e9 ae f6 ff ff       	jmp    80106a90 <alltraps>

801073e2 <vector86>:
.globl vector86
vector86:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $86
801073e4:	6a 56                	push   $0x56
  jmp alltraps
801073e6:	e9 a5 f6 ff ff       	jmp    80106a90 <alltraps>

801073eb <vector87>:
.globl vector87
vector87:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $87
801073ed:	6a 57                	push   $0x57
  jmp alltraps
801073ef:	e9 9c f6 ff ff       	jmp    80106a90 <alltraps>

801073f4 <vector88>:
.globl vector88
vector88:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $88
801073f6:	6a 58                	push   $0x58
  jmp alltraps
801073f8:	e9 93 f6 ff ff       	jmp    80106a90 <alltraps>

801073fd <vector89>:
.globl vector89
vector89:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $89
801073ff:	6a 59                	push   $0x59
  jmp alltraps
80107401:	e9 8a f6 ff ff       	jmp    80106a90 <alltraps>

80107406 <vector90>:
.globl vector90
vector90:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $90
80107408:	6a 5a                	push   $0x5a
  jmp alltraps
8010740a:	e9 81 f6 ff ff       	jmp    80106a90 <alltraps>

8010740f <vector91>:
.globl vector91
vector91:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $91
80107411:	6a 5b                	push   $0x5b
  jmp alltraps
80107413:	e9 78 f6 ff ff       	jmp    80106a90 <alltraps>

80107418 <vector92>:
.globl vector92
vector92:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $92
8010741a:	6a 5c                	push   $0x5c
  jmp alltraps
8010741c:	e9 6f f6 ff ff       	jmp    80106a90 <alltraps>

80107421 <vector93>:
.globl vector93
vector93:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $93
80107423:	6a 5d                	push   $0x5d
  jmp alltraps
80107425:	e9 66 f6 ff ff       	jmp    80106a90 <alltraps>

8010742a <vector94>:
.globl vector94
vector94:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $94
8010742c:	6a 5e                	push   $0x5e
  jmp alltraps
8010742e:	e9 5d f6 ff ff       	jmp    80106a90 <alltraps>

80107433 <vector95>:
.globl vector95
vector95:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $95
80107435:	6a 5f                	push   $0x5f
  jmp alltraps
80107437:	e9 54 f6 ff ff       	jmp    80106a90 <alltraps>

8010743c <vector96>:
.globl vector96
vector96:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $96
8010743e:	6a 60                	push   $0x60
  jmp alltraps
80107440:	e9 4b f6 ff ff       	jmp    80106a90 <alltraps>

80107445 <vector97>:
.globl vector97
vector97:
  pushl $0
80107445:	6a 00                	push   $0x0
  pushl $97
80107447:	6a 61                	push   $0x61
  jmp alltraps
80107449:	e9 42 f6 ff ff       	jmp    80106a90 <alltraps>

8010744e <vector98>:
.globl vector98
vector98:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $98
80107450:	6a 62                	push   $0x62
  jmp alltraps
80107452:	e9 39 f6 ff ff       	jmp    80106a90 <alltraps>

80107457 <vector99>:
.globl vector99
vector99:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $99
80107459:	6a 63                	push   $0x63
  jmp alltraps
8010745b:	e9 30 f6 ff ff       	jmp    80106a90 <alltraps>

80107460 <vector100>:
.globl vector100
vector100:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $100
80107462:	6a 64                	push   $0x64
  jmp alltraps
80107464:	e9 27 f6 ff ff       	jmp    80106a90 <alltraps>

80107469 <vector101>:
.globl vector101
vector101:
  pushl $0
80107469:	6a 00                	push   $0x0
  pushl $101
8010746b:	6a 65                	push   $0x65
  jmp alltraps
8010746d:	e9 1e f6 ff ff       	jmp    80106a90 <alltraps>

80107472 <vector102>:
.globl vector102
vector102:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $102
80107474:	6a 66                	push   $0x66
  jmp alltraps
80107476:	e9 15 f6 ff ff       	jmp    80106a90 <alltraps>

8010747b <vector103>:
.globl vector103
vector103:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $103
8010747d:	6a 67                	push   $0x67
  jmp alltraps
8010747f:	e9 0c f6 ff ff       	jmp    80106a90 <alltraps>

80107484 <vector104>:
.globl vector104
vector104:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $104
80107486:	6a 68                	push   $0x68
  jmp alltraps
80107488:	e9 03 f6 ff ff       	jmp    80106a90 <alltraps>

8010748d <vector105>:
.globl vector105
vector105:
  pushl $0
8010748d:	6a 00                	push   $0x0
  pushl $105
8010748f:	6a 69                	push   $0x69
  jmp alltraps
80107491:	e9 fa f5 ff ff       	jmp    80106a90 <alltraps>

80107496 <vector106>:
.globl vector106
vector106:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $106
80107498:	6a 6a                	push   $0x6a
  jmp alltraps
8010749a:	e9 f1 f5 ff ff       	jmp    80106a90 <alltraps>

8010749f <vector107>:
.globl vector107
vector107:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $107
801074a1:	6a 6b                	push   $0x6b
  jmp alltraps
801074a3:	e9 e8 f5 ff ff       	jmp    80106a90 <alltraps>

801074a8 <vector108>:
.globl vector108
vector108:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $108
801074aa:	6a 6c                	push   $0x6c
  jmp alltraps
801074ac:	e9 df f5 ff ff       	jmp    80106a90 <alltraps>

801074b1 <vector109>:
.globl vector109
vector109:
  pushl $0
801074b1:	6a 00                	push   $0x0
  pushl $109
801074b3:	6a 6d                	push   $0x6d
  jmp alltraps
801074b5:	e9 d6 f5 ff ff       	jmp    80106a90 <alltraps>

801074ba <vector110>:
.globl vector110
vector110:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $110
801074bc:	6a 6e                	push   $0x6e
  jmp alltraps
801074be:	e9 cd f5 ff ff       	jmp    80106a90 <alltraps>

801074c3 <vector111>:
.globl vector111
vector111:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $111
801074c5:	6a 6f                	push   $0x6f
  jmp alltraps
801074c7:	e9 c4 f5 ff ff       	jmp    80106a90 <alltraps>

801074cc <vector112>:
.globl vector112
vector112:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $112
801074ce:	6a 70                	push   $0x70
  jmp alltraps
801074d0:	e9 bb f5 ff ff       	jmp    80106a90 <alltraps>

801074d5 <vector113>:
.globl vector113
vector113:
  pushl $0
801074d5:	6a 00                	push   $0x0
  pushl $113
801074d7:	6a 71                	push   $0x71
  jmp alltraps
801074d9:	e9 b2 f5 ff ff       	jmp    80106a90 <alltraps>

801074de <vector114>:
.globl vector114
vector114:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $114
801074e0:	6a 72                	push   $0x72
  jmp alltraps
801074e2:	e9 a9 f5 ff ff       	jmp    80106a90 <alltraps>

801074e7 <vector115>:
.globl vector115
vector115:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $115
801074e9:	6a 73                	push   $0x73
  jmp alltraps
801074eb:	e9 a0 f5 ff ff       	jmp    80106a90 <alltraps>

801074f0 <vector116>:
.globl vector116
vector116:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $116
801074f2:	6a 74                	push   $0x74
  jmp alltraps
801074f4:	e9 97 f5 ff ff       	jmp    80106a90 <alltraps>

801074f9 <vector117>:
.globl vector117
vector117:
  pushl $0
801074f9:	6a 00                	push   $0x0
  pushl $117
801074fb:	6a 75                	push   $0x75
  jmp alltraps
801074fd:	e9 8e f5 ff ff       	jmp    80106a90 <alltraps>

80107502 <vector118>:
.globl vector118
vector118:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $118
80107504:	6a 76                	push   $0x76
  jmp alltraps
80107506:	e9 85 f5 ff ff       	jmp    80106a90 <alltraps>

8010750b <vector119>:
.globl vector119
vector119:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $119
8010750d:	6a 77                	push   $0x77
  jmp alltraps
8010750f:	e9 7c f5 ff ff       	jmp    80106a90 <alltraps>

80107514 <vector120>:
.globl vector120
vector120:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $120
80107516:	6a 78                	push   $0x78
  jmp alltraps
80107518:	e9 73 f5 ff ff       	jmp    80106a90 <alltraps>

8010751d <vector121>:
.globl vector121
vector121:
  pushl $0
8010751d:	6a 00                	push   $0x0
  pushl $121
8010751f:	6a 79                	push   $0x79
  jmp alltraps
80107521:	e9 6a f5 ff ff       	jmp    80106a90 <alltraps>

80107526 <vector122>:
.globl vector122
vector122:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $122
80107528:	6a 7a                	push   $0x7a
  jmp alltraps
8010752a:	e9 61 f5 ff ff       	jmp    80106a90 <alltraps>

8010752f <vector123>:
.globl vector123
vector123:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $123
80107531:	6a 7b                	push   $0x7b
  jmp alltraps
80107533:	e9 58 f5 ff ff       	jmp    80106a90 <alltraps>

80107538 <vector124>:
.globl vector124
vector124:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $124
8010753a:	6a 7c                	push   $0x7c
  jmp alltraps
8010753c:	e9 4f f5 ff ff       	jmp    80106a90 <alltraps>

80107541 <vector125>:
.globl vector125
vector125:
  pushl $0
80107541:	6a 00                	push   $0x0
  pushl $125
80107543:	6a 7d                	push   $0x7d
  jmp alltraps
80107545:	e9 46 f5 ff ff       	jmp    80106a90 <alltraps>

8010754a <vector126>:
.globl vector126
vector126:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $126
8010754c:	6a 7e                	push   $0x7e
  jmp alltraps
8010754e:	e9 3d f5 ff ff       	jmp    80106a90 <alltraps>

80107553 <vector127>:
.globl vector127
vector127:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $127
80107555:	6a 7f                	push   $0x7f
  jmp alltraps
80107557:	e9 34 f5 ff ff       	jmp    80106a90 <alltraps>

8010755c <vector128>:
.globl vector128
vector128:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $128
8010755e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107563:	e9 28 f5 ff ff       	jmp    80106a90 <alltraps>

80107568 <vector129>:
.globl vector129
vector129:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $129
8010756a:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010756f:	e9 1c f5 ff ff       	jmp    80106a90 <alltraps>

80107574 <vector130>:
.globl vector130
vector130:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $130
80107576:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010757b:	e9 10 f5 ff ff       	jmp    80106a90 <alltraps>

80107580 <vector131>:
.globl vector131
vector131:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $131
80107582:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107587:	e9 04 f5 ff ff       	jmp    80106a90 <alltraps>

8010758c <vector132>:
.globl vector132
vector132:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $132
8010758e:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107593:	e9 f8 f4 ff ff       	jmp    80106a90 <alltraps>

80107598 <vector133>:
.globl vector133
vector133:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $133
8010759a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010759f:	e9 ec f4 ff ff       	jmp    80106a90 <alltraps>

801075a4 <vector134>:
.globl vector134
vector134:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $134
801075a6:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801075ab:	e9 e0 f4 ff ff       	jmp    80106a90 <alltraps>

801075b0 <vector135>:
.globl vector135
vector135:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $135
801075b2:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801075b7:	e9 d4 f4 ff ff       	jmp    80106a90 <alltraps>

801075bc <vector136>:
.globl vector136
vector136:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $136
801075be:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801075c3:	e9 c8 f4 ff ff       	jmp    80106a90 <alltraps>

801075c8 <vector137>:
.globl vector137
vector137:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $137
801075ca:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801075cf:	e9 bc f4 ff ff       	jmp    80106a90 <alltraps>

801075d4 <vector138>:
.globl vector138
vector138:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $138
801075d6:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801075db:	e9 b0 f4 ff ff       	jmp    80106a90 <alltraps>

801075e0 <vector139>:
.globl vector139
vector139:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $139
801075e2:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801075e7:	e9 a4 f4 ff ff       	jmp    80106a90 <alltraps>

801075ec <vector140>:
.globl vector140
vector140:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $140
801075ee:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801075f3:	e9 98 f4 ff ff       	jmp    80106a90 <alltraps>

801075f8 <vector141>:
.globl vector141
vector141:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $141
801075fa:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801075ff:	e9 8c f4 ff ff       	jmp    80106a90 <alltraps>

80107604 <vector142>:
.globl vector142
vector142:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $142
80107606:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010760b:	e9 80 f4 ff ff       	jmp    80106a90 <alltraps>

80107610 <vector143>:
.globl vector143
vector143:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $143
80107612:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107617:	e9 74 f4 ff ff       	jmp    80106a90 <alltraps>

8010761c <vector144>:
.globl vector144
vector144:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $144
8010761e:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107623:	e9 68 f4 ff ff       	jmp    80106a90 <alltraps>

80107628 <vector145>:
.globl vector145
vector145:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $145
8010762a:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010762f:	e9 5c f4 ff ff       	jmp    80106a90 <alltraps>

80107634 <vector146>:
.globl vector146
vector146:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $146
80107636:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010763b:	e9 50 f4 ff ff       	jmp    80106a90 <alltraps>

80107640 <vector147>:
.globl vector147
vector147:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $147
80107642:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107647:	e9 44 f4 ff ff       	jmp    80106a90 <alltraps>

8010764c <vector148>:
.globl vector148
vector148:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $148
8010764e:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107653:	e9 38 f4 ff ff       	jmp    80106a90 <alltraps>

80107658 <vector149>:
.globl vector149
vector149:
  pushl $0
80107658:	6a 00                	push   $0x0
  pushl $149
8010765a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010765f:	e9 2c f4 ff ff       	jmp    80106a90 <alltraps>

80107664 <vector150>:
.globl vector150
vector150:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $150
80107666:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010766b:	e9 20 f4 ff ff       	jmp    80106a90 <alltraps>

80107670 <vector151>:
.globl vector151
vector151:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $151
80107672:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107677:	e9 14 f4 ff ff       	jmp    80106a90 <alltraps>

8010767c <vector152>:
.globl vector152
vector152:
  pushl $0
8010767c:	6a 00                	push   $0x0
  pushl $152
8010767e:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107683:	e9 08 f4 ff ff       	jmp    80106a90 <alltraps>

80107688 <vector153>:
.globl vector153
vector153:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $153
8010768a:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010768f:	e9 fc f3 ff ff       	jmp    80106a90 <alltraps>

80107694 <vector154>:
.globl vector154
vector154:
  pushl $0
80107694:	6a 00                	push   $0x0
  pushl $154
80107696:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010769b:	e9 f0 f3 ff ff       	jmp    80106a90 <alltraps>

801076a0 <vector155>:
.globl vector155
vector155:
  pushl $0
801076a0:	6a 00                	push   $0x0
  pushl $155
801076a2:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801076a7:	e9 e4 f3 ff ff       	jmp    80106a90 <alltraps>

801076ac <vector156>:
.globl vector156
vector156:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $156
801076ae:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801076b3:	e9 d8 f3 ff ff       	jmp    80106a90 <alltraps>

801076b8 <vector157>:
.globl vector157
vector157:
  pushl $0
801076b8:	6a 00                	push   $0x0
  pushl $157
801076ba:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801076bf:	e9 cc f3 ff ff       	jmp    80106a90 <alltraps>

801076c4 <vector158>:
.globl vector158
vector158:
  pushl $0
801076c4:	6a 00                	push   $0x0
  pushl $158
801076c6:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801076cb:	e9 c0 f3 ff ff       	jmp    80106a90 <alltraps>

801076d0 <vector159>:
.globl vector159
vector159:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $159
801076d2:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801076d7:	e9 b4 f3 ff ff       	jmp    80106a90 <alltraps>

801076dc <vector160>:
.globl vector160
vector160:
  pushl $0
801076dc:	6a 00                	push   $0x0
  pushl $160
801076de:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801076e3:	e9 a8 f3 ff ff       	jmp    80106a90 <alltraps>

801076e8 <vector161>:
.globl vector161
vector161:
  pushl $0
801076e8:	6a 00                	push   $0x0
  pushl $161
801076ea:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801076ef:	e9 9c f3 ff ff       	jmp    80106a90 <alltraps>

801076f4 <vector162>:
.globl vector162
vector162:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $162
801076f6:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801076fb:	e9 90 f3 ff ff       	jmp    80106a90 <alltraps>

80107700 <vector163>:
.globl vector163
vector163:
  pushl $0
80107700:	6a 00                	push   $0x0
  pushl $163
80107702:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107707:	e9 84 f3 ff ff       	jmp    80106a90 <alltraps>

8010770c <vector164>:
.globl vector164
vector164:
  pushl $0
8010770c:	6a 00                	push   $0x0
  pushl $164
8010770e:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107713:	e9 78 f3 ff ff       	jmp    80106a90 <alltraps>

80107718 <vector165>:
.globl vector165
vector165:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $165
8010771a:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010771f:	e9 6c f3 ff ff       	jmp    80106a90 <alltraps>

80107724 <vector166>:
.globl vector166
vector166:
  pushl $0
80107724:	6a 00                	push   $0x0
  pushl $166
80107726:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010772b:	e9 60 f3 ff ff       	jmp    80106a90 <alltraps>

80107730 <vector167>:
.globl vector167
vector167:
  pushl $0
80107730:	6a 00                	push   $0x0
  pushl $167
80107732:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107737:	e9 54 f3 ff ff       	jmp    80106a90 <alltraps>

8010773c <vector168>:
.globl vector168
vector168:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $168
8010773e:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107743:	e9 48 f3 ff ff       	jmp    80106a90 <alltraps>

80107748 <vector169>:
.globl vector169
vector169:
  pushl $0
80107748:	6a 00                	push   $0x0
  pushl $169
8010774a:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010774f:	e9 3c f3 ff ff       	jmp    80106a90 <alltraps>

80107754 <vector170>:
.globl vector170
vector170:
  pushl $0
80107754:	6a 00                	push   $0x0
  pushl $170
80107756:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010775b:	e9 30 f3 ff ff       	jmp    80106a90 <alltraps>

80107760 <vector171>:
.globl vector171
vector171:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $171
80107762:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107767:	e9 24 f3 ff ff       	jmp    80106a90 <alltraps>

8010776c <vector172>:
.globl vector172
vector172:
  pushl $0
8010776c:	6a 00                	push   $0x0
  pushl $172
8010776e:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107773:	e9 18 f3 ff ff       	jmp    80106a90 <alltraps>

80107778 <vector173>:
.globl vector173
vector173:
  pushl $0
80107778:	6a 00                	push   $0x0
  pushl $173
8010777a:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010777f:	e9 0c f3 ff ff       	jmp    80106a90 <alltraps>

80107784 <vector174>:
.globl vector174
vector174:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $174
80107786:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010778b:	e9 00 f3 ff ff       	jmp    80106a90 <alltraps>

80107790 <vector175>:
.globl vector175
vector175:
  pushl $0
80107790:	6a 00                	push   $0x0
  pushl $175
80107792:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107797:	e9 f4 f2 ff ff       	jmp    80106a90 <alltraps>

8010779c <vector176>:
.globl vector176
vector176:
  pushl $0
8010779c:	6a 00                	push   $0x0
  pushl $176
8010779e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801077a3:	e9 e8 f2 ff ff       	jmp    80106a90 <alltraps>

801077a8 <vector177>:
.globl vector177
vector177:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $177
801077aa:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801077af:	e9 dc f2 ff ff       	jmp    80106a90 <alltraps>

801077b4 <vector178>:
.globl vector178
vector178:
  pushl $0
801077b4:	6a 00                	push   $0x0
  pushl $178
801077b6:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801077bb:	e9 d0 f2 ff ff       	jmp    80106a90 <alltraps>

801077c0 <vector179>:
.globl vector179
vector179:
  pushl $0
801077c0:	6a 00                	push   $0x0
  pushl $179
801077c2:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801077c7:	e9 c4 f2 ff ff       	jmp    80106a90 <alltraps>

801077cc <vector180>:
.globl vector180
vector180:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $180
801077ce:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801077d3:	e9 b8 f2 ff ff       	jmp    80106a90 <alltraps>

801077d8 <vector181>:
.globl vector181
vector181:
  pushl $0
801077d8:	6a 00                	push   $0x0
  pushl $181
801077da:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801077df:	e9 ac f2 ff ff       	jmp    80106a90 <alltraps>

801077e4 <vector182>:
.globl vector182
vector182:
  pushl $0
801077e4:	6a 00                	push   $0x0
  pushl $182
801077e6:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801077eb:	e9 a0 f2 ff ff       	jmp    80106a90 <alltraps>

801077f0 <vector183>:
.globl vector183
vector183:
  pushl $0
801077f0:	6a 00                	push   $0x0
  pushl $183
801077f2:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801077f7:	e9 94 f2 ff ff       	jmp    80106a90 <alltraps>

801077fc <vector184>:
.globl vector184
vector184:
  pushl $0
801077fc:	6a 00                	push   $0x0
  pushl $184
801077fe:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107803:	e9 88 f2 ff ff       	jmp    80106a90 <alltraps>

80107808 <vector185>:
.globl vector185
vector185:
  pushl $0
80107808:	6a 00                	push   $0x0
  pushl $185
8010780a:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010780f:	e9 7c f2 ff ff       	jmp    80106a90 <alltraps>

80107814 <vector186>:
.globl vector186
vector186:
  pushl $0
80107814:	6a 00                	push   $0x0
  pushl $186
80107816:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010781b:	e9 70 f2 ff ff       	jmp    80106a90 <alltraps>

80107820 <vector187>:
.globl vector187
vector187:
  pushl $0
80107820:	6a 00                	push   $0x0
  pushl $187
80107822:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107827:	e9 64 f2 ff ff       	jmp    80106a90 <alltraps>

8010782c <vector188>:
.globl vector188
vector188:
  pushl $0
8010782c:	6a 00                	push   $0x0
  pushl $188
8010782e:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107833:	e9 58 f2 ff ff       	jmp    80106a90 <alltraps>

80107838 <vector189>:
.globl vector189
vector189:
  pushl $0
80107838:	6a 00                	push   $0x0
  pushl $189
8010783a:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010783f:	e9 4c f2 ff ff       	jmp    80106a90 <alltraps>

80107844 <vector190>:
.globl vector190
vector190:
  pushl $0
80107844:	6a 00                	push   $0x0
  pushl $190
80107846:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010784b:	e9 40 f2 ff ff       	jmp    80106a90 <alltraps>

80107850 <vector191>:
.globl vector191
vector191:
  pushl $0
80107850:	6a 00                	push   $0x0
  pushl $191
80107852:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107857:	e9 34 f2 ff ff       	jmp    80106a90 <alltraps>

8010785c <vector192>:
.globl vector192
vector192:
  pushl $0
8010785c:	6a 00                	push   $0x0
  pushl $192
8010785e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107863:	e9 28 f2 ff ff       	jmp    80106a90 <alltraps>

80107868 <vector193>:
.globl vector193
vector193:
  pushl $0
80107868:	6a 00                	push   $0x0
  pushl $193
8010786a:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010786f:	e9 1c f2 ff ff       	jmp    80106a90 <alltraps>

80107874 <vector194>:
.globl vector194
vector194:
  pushl $0
80107874:	6a 00                	push   $0x0
  pushl $194
80107876:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010787b:	e9 10 f2 ff ff       	jmp    80106a90 <alltraps>

80107880 <vector195>:
.globl vector195
vector195:
  pushl $0
80107880:	6a 00                	push   $0x0
  pushl $195
80107882:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107887:	e9 04 f2 ff ff       	jmp    80106a90 <alltraps>

8010788c <vector196>:
.globl vector196
vector196:
  pushl $0
8010788c:	6a 00                	push   $0x0
  pushl $196
8010788e:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107893:	e9 f8 f1 ff ff       	jmp    80106a90 <alltraps>

80107898 <vector197>:
.globl vector197
vector197:
  pushl $0
80107898:	6a 00                	push   $0x0
  pushl $197
8010789a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010789f:	e9 ec f1 ff ff       	jmp    80106a90 <alltraps>

801078a4 <vector198>:
.globl vector198
vector198:
  pushl $0
801078a4:	6a 00                	push   $0x0
  pushl $198
801078a6:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801078ab:	e9 e0 f1 ff ff       	jmp    80106a90 <alltraps>

801078b0 <vector199>:
.globl vector199
vector199:
  pushl $0
801078b0:	6a 00                	push   $0x0
  pushl $199
801078b2:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801078b7:	e9 d4 f1 ff ff       	jmp    80106a90 <alltraps>

801078bc <vector200>:
.globl vector200
vector200:
  pushl $0
801078bc:	6a 00                	push   $0x0
  pushl $200
801078be:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801078c3:	e9 c8 f1 ff ff       	jmp    80106a90 <alltraps>

801078c8 <vector201>:
.globl vector201
vector201:
  pushl $0
801078c8:	6a 00                	push   $0x0
  pushl $201
801078ca:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801078cf:	e9 bc f1 ff ff       	jmp    80106a90 <alltraps>

801078d4 <vector202>:
.globl vector202
vector202:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $202
801078d6:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801078db:	e9 b0 f1 ff ff       	jmp    80106a90 <alltraps>

801078e0 <vector203>:
.globl vector203
vector203:
  pushl $0
801078e0:	6a 00                	push   $0x0
  pushl $203
801078e2:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801078e7:	e9 a4 f1 ff ff       	jmp    80106a90 <alltraps>

801078ec <vector204>:
.globl vector204
vector204:
  pushl $0
801078ec:	6a 00                	push   $0x0
  pushl $204
801078ee:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801078f3:	e9 98 f1 ff ff       	jmp    80106a90 <alltraps>

801078f8 <vector205>:
.globl vector205
vector205:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $205
801078fa:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801078ff:	e9 8c f1 ff ff       	jmp    80106a90 <alltraps>

80107904 <vector206>:
.globl vector206
vector206:
  pushl $0
80107904:	6a 00                	push   $0x0
  pushl $206
80107906:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010790b:	e9 80 f1 ff ff       	jmp    80106a90 <alltraps>

80107910 <vector207>:
.globl vector207
vector207:
  pushl $0
80107910:	6a 00                	push   $0x0
  pushl $207
80107912:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107917:	e9 74 f1 ff ff       	jmp    80106a90 <alltraps>

8010791c <vector208>:
.globl vector208
vector208:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $208
8010791e:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107923:	e9 68 f1 ff ff       	jmp    80106a90 <alltraps>

80107928 <vector209>:
.globl vector209
vector209:
  pushl $0
80107928:	6a 00                	push   $0x0
  pushl $209
8010792a:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010792f:	e9 5c f1 ff ff       	jmp    80106a90 <alltraps>

80107934 <vector210>:
.globl vector210
vector210:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $210
80107936:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010793b:	e9 50 f1 ff ff       	jmp    80106a90 <alltraps>

80107940 <vector211>:
.globl vector211
vector211:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $211
80107942:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107947:	e9 44 f1 ff ff       	jmp    80106a90 <alltraps>

8010794c <vector212>:
.globl vector212
vector212:
  pushl $0
8010794c:	6a 00                	push   $0x0
  pushl $212
8010794e:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107953:	e9 38 f1 ff ff       	jmp    80106a90 <alltraps>

80107958 <vector213>:
.globl vector213
vector213:
  pushl $0
80107958:	6a 00                	push   $0x0
  pushl $213
8010795a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010795f:	e9 2c f1 ff ff       	jmp    80106a90 <alltraps>

80107964 <vector214>:
.globl vector214
vector214:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $214
80107966:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010796b:	e9 20 f1 ff ff       	jmp    80106a90 <alltraps>

80107970 <vector215>:
.globl vector215
vector215:
  pushl $0
80107970:	6a 00                	push   $0x0
  pushl $215
80107972:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107977:	e9 14 f1 ff ff       	jmp    80106a90 <alltraps>

8010797c <vector216>:
.globl vector216
vector216:
  pushl $0
8010797c:	6a 00                	push   $0x0
  pushl $216
8010797e:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107983:	e9 08 f1 ff ff       	jmp    80106a90 <alltraps>

80107988 <vector217>:
.globl vector217
vector217:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $217
8010798a:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010798f:	e9 fc f0 ff ff       	jmp    80106a90 <alltraps>

80107994 <vector218>:
.globl vector218
vector218:
  pushl $0
80107994:	6a 00                	push   $0x0
  pushl $218
80107996:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010799b:	e9 f0 f0 ff ff       	jmp    80106a90 <alltraps>

801079a0 <vector219>:
.globl vector219
vector219:
  pushl $0
801079a0:	6a 00                	push   $0x0
  pushl $219
801079a2:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801079a7:	e9 e4 f0 ff ff       	jmp    80106a90 <alltraps>

801079ac <vector220>:
.globl vector220
vector220:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $220
801079ae:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801079b3:	e9 d8 f0 ff ff       	jmp    80106a90 <alltraps>

801079b8 <vector221>:
.globl vector221
vector221:
  pushl $0
801079b8:	6a 00                	push   $0x0
  pushl $221
801079ba:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801079bf:	e9 cc f0 ff ff       	jmp    80106a90 <alltraps>

801079c4 <vector222>:
.globl vector222
vector222:
  pushl $0
801079c4:	6a 00                	push   $0x0
  pushl $222
801079c6:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801079cb:	e9 c0 f0 ff ff       	jmp    80106a90 <alltraps>

801079d0 <vector223>:
.globl vector223
vector223:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $223
801079d2:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801079d7:	e9 b4 f0 ff ff       	jmp    80106a90 <alltraps>

801079dc <vector224>:
.globl vector224
vector224:
  pushl $0
801079dc:	6a 00                	push   $0x0
  pushl $224
801079de:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801079e3:	e9 a8 f0 ff ff       	jmp    80106a90 <alltraps>

801079e8 <vector225>:
.globl vector225
vector225:
  pushl $0
801079e8:	6a 00                	push   $0x0
  pushl $225
801079ea:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801079ef:	e9 9c f0 ff ff       	jmp    80106a90 <alltraps>

801079f4 <vector226>:
.globl vector226
vector226:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $226
801079f6:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801079fb:	e9 90 f0 ff ff       	jmp    80106a90 <alltraps>

80107a00 <vector227>:
.globl vector227
vector227:
  pushl $0
80107a00:	6a 00                	push   $0x0
  pushl $227
80107a02:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107a07:	e9 84 f0 ff ff       	jmp    80106a90 <alltraps>

80107a0c <vector228>:
.globl vector228
vector228:
  pushl $0
80107a0c:	6a 00                	push   $0x0
  pushl $228
80107a0e:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107a13:	e9 78 f0 ff ff       	jmp    80106a90 <alltraps>

80107a18 <vector229>:
.globl vector229
vector229:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $229
80107a1a:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107a1f:	e9 6c f0 ff ff       	jmp    80106a90 <alltraps>

80107a24 <vector230>:
.globl vector230
vector230:
  pushl $0
80107a24:	6a 00                	push   $0x0
  pushl $230
80107a26:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107a2b:	e9 60 f0 ff ff       	jmp    80106a90 <alltraps>

80107a30 <vector231>:
.globl vector231
vector231:
  pushl $0
80107a30:	6a 00                	push   $0x0
  pushl $231
80107a32:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107a37:	e9 54 f0 ff ff       	jmp    80106a90 <alltraps>

80107a3c <vector232>:
.globl vector232
vector232:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $232
80107a3e:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107a43:	e9 48 f0 ff ff       	jmp    80106a90 <alltraps>

80107a48 <vector233>:
.globl vector233
vector233:
  pushl $0
80107a48:	6a 00                	push   $0x0
  pushl $233
80107a4a:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107a4f:	e9 3c f0 ff ff       	jmp    80106a90 <alltraps>

80107a54 <vector234>:
.globl vector234
vector234:
  pushl $0
80107a54:	6a 00                	push   $0x0
  pushl $234
80107a56:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107a5b:	e9 30 f0 ff ff       	jmp    80106a90 <alltraps>

80107a60 <vector235>:
.globl vector235
vector235:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $235
80107a62:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107a67:	e9 24 f0 ff ff       	jmp    80106a90 <alltraps>

80107a6c <vector236>:
.globl vector236
vector236:
  pushl $0
80107a6c:	6a 00                	push   $0x0
  pushl $236
80107a6e:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107a73:	e9 18 f0 ff ff       	jmp    80106a90 <alltraps>

80107a78 <vector237>:
.globl vector237
vector237:
  pushl $0
80107a78:	6a 00                	push   $0x0
  pushl $237
80107a7a:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107a7f:	e9 0c f0 ff ff       	jmp    80106a90 <alltraps>

80107a84 <vector238>:
.globl vector238
vector238:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $238
80107a86:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107a8b:	e9 00 f0 ff ff       	jmp    80106a90 <alltraps>

80107a90 <vector239>:
.globl vector239
vector239:
  pushl $0
80107a90:	6a 00                	push   $0x0
  pushl $239
80107a92:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107a97:	e9 f4 ef ff ff       	jmp    80106a90 <alltraps>

80107a9c <vector240>:
.globl vector240
vector240:
  pushl $0
80107a9c:	6a 00                	push   $0x0
  pushl $240
80107a9e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107aa3:	e9 e8 ef ff ff       	jmp    80106a90 <alltraps>

80107aa8 <vector241>:
.globl vector241
vector241:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $241
80107aaa:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107aaf:	e9 dc ef ff ff       	jmp    80106a90 <alltraps>

80107ab4 <vector242>:
.globl vector242
vector242:
  pushl $0
80107ab4:	6a 00                	push   $0x0
  pushl $242
80107ab6:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107abb:	e9 d0 ef ff ff       	jmp    80106a90 <alltraps>

80107ac0 <vector243>:
.globl vector243
vector243:
  pushl $0
80107ac0:	6a 00                	push   $0x0
  pushl $243
80107ac2:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107ac7:	e9 c4 ef ff ff       	jmp    80106a90 <alltraps>

80107acc <vector244>:
.globl vector244
vector244:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $244
80107ace:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ad3:	e9 b8 ef ff ff       	jmp    80106a90 <alltraps>

80107ad8 <vector245>:
.globl vector245
vector245:
  pushl $0
80107ad8:	6a 00                	push   $0x0
  pushl $245
80107ada:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107adf:	e9 ac ef ff ff       	jmp    80106a90 <alltraps>

80107ae4 <vector246>:
.globl vector246
vector246:
  pushl $0
80107ae4:	6a 00                	push   $0x0
  pushl $246
80107ae6:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107aeb:	e9 a0 ef ff ff       	jmp    80106a90 <alltraps>

80107af0 <vector247>:
.globl vector247
vector247:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $247
80107af2:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107af7:	e9 94 ef ff ff       	jmp    80106a90 <alltraps>

80107afc <vector248>:
.globl vector248
vector248:
  pushl $0
80107afc:	6a 00                	push   $0x0
  pushl $248
80107afe:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107b03:	e9 88 ef ff ff       	jmp    80106a90 <alltraps>

80107b08 <vector249>:
.globl vector249
vector249:
  pushl $0
80107b08:	6a 00                	push   $0x0
  pushl $249
80107b0a:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107b0f:	e9 7c ef ff ff       	jmp    80106a90 <alltraps>

80107b14 <vector250>:
.globl vector250
vector250:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $250
80107b16:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107b1b:	e9 70 ef ff ff       	jmp    80106a90 <alltraps>

80107b20 <vector251>:
.globl vector251
vector251:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $251
80107b22:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107b27:	e9 64 ef ff ff       	jmp    80106a90 <alltraps>

80107b2c <vector252>:
.globl vector252
vector252:
  pushl $0
80107b2c:	6a 00                	push   $0x0
  pushl $252
80107b2e:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107b33:	e9 58 ef ff ff       	jmp    80106a90 <alltraps>

80107b38 <vector253>:
.globl vector253
vector253:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $253
80107b3a:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107b3f:	e9 4c ef ff ff       	jmp    80106a90 <alltraps>

80107b44 <vector254>:
.globl vector254
vector254:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $254
80107b46:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107b4b:	e9 40 ef ff ff       	jmp    80106a90 <alltraps>

80107b50 <vector255>:
.globl vector255
vector255:
  pushl $0
80107b50:	6a 00                	push   $0x0
  pushl $255
80107b52:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107b57:	e9 34 ef ff ff       	jmp    80106a90 <alltraps>

80107b5c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107b5c:	55                   	push   %ebp
80107b5d:	89 e5                	mov    %esp,%ebp
80107b5f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107b62:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b65:	83 e8 01             	sub    $0x1,%eax
80107b68:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b6f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107b73:	8b 45 08             	mov    0x8(%ebp),%eax
80107b76:	c1 e8 10             	shr    $0x10,%eax
80107b79:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107b7d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107b80:	0f 01 10             	lgdtl  (%eax)
}
80107b83:	90                   	nop
80107b84:	c9                   	leave  
80107b85:	c3                   	ret    

80107b86 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107b86:	55                   	push   %ebp
80107b87:	89 e5                	mov    %esp,%ebp
80107b89:	83 ec 04             	sub    $0x4,%esp
80107b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b8f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107b93:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107b97:	0f 00 d8             	ltr    %ax
}
80107b9a:	90                   	nop
80107b9b:	c9                   	leave  
80107b9c:	c3                   	ret    

80107b9d <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107b9d:	55                   	push   %ebp
80107b9e:	89 e5                	mov    %esp,%ebp
80107ba0:	83 ec 04             	sub    $0x4,%esp
80107ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107baa:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107bae:	8e e8                	mov    %eax,%gs
}
80107bb0:	90                   	nop
80107bb1:	c9                   	leave  
80107bb2:	c3                   	ret    

80107bb3 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80107bb3:	55                   	push   %ebp
80107bb4:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bb6:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb9:	0f 22 d8             	mov    %eax,%cr3
}
80107bbc:	90                   	nop
80107bbd:	5d                   	pop    %ebp
80107bbe:	c3                   	ret    

80107bbf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107bbf:	55                   	push   %ebp
80107bc0:	89 e5                	mov    %esp,%ebp
80107bc2:	53                   	push   %ebx
80107bc3:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107bc6:	e8 4e b4 ff ff       	call   80103019 <cpunum>
80107bcb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107bd1:	05 40 48 11 80       	add    $0x80114840,%eax
80107bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdc:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be5:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bee:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107bf9:	83 e2 f0             	and    $0xfffffff0,%edx
80107bfc:	83 ca 0a             	or     $0xa,%edx
80107bff:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c05:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c09:	83 ca 10             	or     $0x10,%edx
80107c0c:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c12:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c16:	83 e2 9f             	and    $0xffffff9f,%edx
80107c19:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107c23:	83 ca 80             	or     $0xffffff80,%edx
80107c26:	88 50 7d             	mov    %dl,0x7d(%eax)
80107c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c2c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c30:	83 ca 0f             	or     $0xf,%edx
80107c33:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c39:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c3d:	83 e2 ef             	and    $0xffffffef,%edx
80107c40:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c46:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c4a:	83 e2 df             	and    $0xffffffdf,%edx
80107c4d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c53:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c57:	83 ca 40             	or     $0x40,%edx
80107c5a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c60:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107c64:	83 ca 80             	or     $0xffffff80,%edx
80107c67:	88 50 7e             	mov    %dl,0x7e(%eax)
80107c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c74:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107c7b:	ff ff 
80107c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c80:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107c87:	00 00 
80107c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c96:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107c9d:	83 e2 f0             	and    $0xfffffff0,%edx
80107ca0:	83 ca 02             	or     $0x2,%edx
80107ca3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cac:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cb3:	83 ca 10             	or     $0x10,%edx
80107cb6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cc6:	83 e2 9f             	and    $0xffffff9f,%edx
80107cc9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107cd9:	83 ca 80             	or     $0xffffff80,%edx
80107cdc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cec:	83 ca 0f             	or     $0xf,%edx
80107cef:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107cff:	83 e2 ef             	and    $0xffffffef,%edx
80107d02:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d12:	83 e2 df             	and    $0xffffffdf,%edx
80107d15:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d25:	83 ca 40             	or     $0x40,%edx
80107d28:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d31:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107d38:	83 ca 80             	or     $0xffffff80,%edx
80107d3b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d44:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107d55:	ff ff 
80107d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d5a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107d61:	00 00 
80107d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d66:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d70:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d77:	83 e2 f0             	and    $0xfffffff0,%edx
80107d7a:	83 ca 0a             	or     $0xa,%edx
80107d7d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d86:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107d8d:	83 ca 10             	or     $0x10,%edx
80107d90:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d99:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107da0:	83 ca 60             	or     $0x60,%edx
80107da3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107db3:	83 ca 80             	or     $0xffffff80,%edx
80107db6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dbf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dc6:	83 ca 0f             	or     $0xf,%edx
80107dc9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dd9:	83 e2 ef             	and    $0xffffffef,%edx
80107ddc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dec:	83 e2 df             	and    $0xffffffdf,%edx
80107def:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107dff:	83 ca 40             	or     $0x40,%edx
80107e02:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e12:	83 ca 80             	or     $0xffffff80,%edx
80107e15:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e28:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107e2f:	ff ff 
80107e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e34:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107e3b:	00 00 
80107e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e40:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e4a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e51:	83 e2 f0             	and    $0xfffffff0,%edx
80107e54:	83 ca 02             	or     $0x2,%edx
80107e57:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e60:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e67:	83 ca 10             	or     $0x10,%edx
80107e6a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e73:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e7a:	83 ca 60             	or     $0x60,%edx
80107e7d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e86:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e8d:	83 ca 80             	or     $0xffffff80,%edx
80107e90:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e99:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ea0:	83 ca 0f             	or     $0xf,%edx
80107ea3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eac:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107eb3:	83 e2 ef             	and    $0xffffffef,%edx
80107eb6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ec6:	83 e2 df             	and    $0xffffffdf,%edx
80107ec9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107ed9:	83 ca 40             	or     $0x40,%edx
80107edc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107eec:	83 ca 80             	or     $0xffffff80,%edx
80107eef:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef8:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f02:	05 b4 00 00 00       	add    $0xb4,%eax
80107f07:	89 c3                	mov    %eax,%ebx
80107f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0c:	05 b4 00 00 00       	add    $0xb4,%eax
80107f11:	c1 e8 10             	shr    $0x10,%eax
80107f14:	89 c2                	mov    %eax,%edx
80107f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f19:	05 b4 00 00 00       	add    $0xb4,%eax
80107f1e:	c1 e8 18             	shr    $0x18,%eax
80107f21:	89 c1                	mov    %eax,%ecx
80107f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f26:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107f2d:	00 00 
80107f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f32:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3c:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f45:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f4c:	83 e2 f0             	and    $0xfffffff0,%edx
80107f4f:	83 ca 02             	or     $0x2,%edx
80107f52:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f62:	83 ca 10             	or     $0x10,%edx
80107f65:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f75:	83 e2 9f             	and    $0xffffff9f,%edx
80107f78:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f81:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107f88:	83 ca 80             	or     $0xffffff80,%edx
80107f8b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f94:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107f9b:	83 e2 f0             	and    $0xfffffff0,%edx
80107f9e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fae:	83 e2 ef             	and    $0xffffffef,%edx
80107fb1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fba:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fc1:	83 e2 df             	and    $0xffffffdf,%edx
80107fc4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fd4:	83 ca 40             	or     $0x40,%edx
80107fd7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107fe7:	83 ca 80             	or     $0xffffff80,%edx
80107fea:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff3:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffc:	83 c0 70             	add    $0x70,%eax
80107fff:	83 ec 08             	sub    $0x8,%esp
80108002:	6a 38                	push   $0x38
80108004:	50                   	push   %eax
80108005:	e8 52 fb ff ff       	call   80107b5c <lgdt>
8010800a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010800d:	83 ec 0c             	sub    $0xc,%esp
80108010:	6a 18                	push   $0x18
80108012:	e8 86 fb ff ff       	call   80107b9d <loadgs>
80108017:	83 c4 10             	add    $0x10,%esp

  // Initialize cpu-local storage.
  cpu = c;
8010801a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108023:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010802a:	00 00 00 00 
}
8010802e:	90                   	nop
8010802f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108032:	c9                   	leave  
80108033:	c3                   	ret    

80108034 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108034:	55                   	push   %ebp
80108035:	89 e5                	mov    %esp,%ebp
80108037:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010803a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010803d:	c1 e8 16             	shr    $0x16,%eax
80108040:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108047:	8b 45 08             	mov    0x8(%ebp),%eax
8010804a:	01 d0                	add    %edx,%eax
8010804c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010804f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108052:	8b 00                	mov    (%eax),%eax
80108054:	83 e0 01             	and    $0x1,%eax
80108057:	85 c0                	test   %eax,%eax
80108059:	74 14                	je     8010806f <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010805b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010805e:	8b 00                	mov    (%eax),%eax
80108060:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108065:	05 00 00 00 80       	add    $0x80000000,%eax
8010806a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010806d:	eb 42                	jmp    801080b1 <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010806f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108073:	74 0e                	je     80108083 <walkpgdir+0x4f>
80108075:	e8 39 ac ff ff       	call   80102cb3 <kalloc>
8010807a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010807d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108081:	75 07                	jne    8010808a <walkpgdir+0x56>
      return 0;
80108083:	b8 00 00 00 00       	mov    $0x0,%eax
80108088:	eb 3e                	jmp    801080c8 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010808a:	83 ec 04             	sub    $0x4,%esp
8010808d:	68 00 10 00 00       	push   $0x1000
80108092:	6a 00                	push   $0x0
80108094:	ff 75 f4             	pushl  -0xc(%ebp)
80108097:	e8 8a d5 ff ff       	call   80105626 <memset>
8010809c:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010809f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a2:	05 00 00 00 80       	add    $0x80000000,%eax
801080a7:	83 c8 07             	or     $0x7,%eax
801080aa:	89 c2                	mov    %eax,%edx
801080ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080af:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801080b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801080b4:	c1 e8 0c             	shr    $0xc,%eax
801080b7:	25 ff 03 00 00       	and    $0x3ff,%eax
801080bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801080c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c6:	01 d0                	add    %edx,%eax
}
801080c8:	c9                   	leave  
801080c9:	c3                   	ret    

801080ca <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801080ca:	55                   	push   %ebp
801080cb:	89 e5                	mov    %esp,%ebp
801080cd:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801080d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801080d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801080db:	8b 55 0c             	mov    0xc(%ebp),%edx
801080de:	8b 45 10             	mov    0x10(%ebp),%eax
801080e1:	01 d0                	add    %edx,%eax
801080e3:	83 e8 01             	sub    $0x1,%eax
801080e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801080ee:	83 ec 04             	sub    $0x4,%esp
801080f1:	6a 01                	push   $0x1
801080f3:	ff 75 f4             	pushl  -0xc(%ebp)
801080f6:	ff 75 08             	pushl  0x8(%ebp)
801080f9:	e8 36 ff ff ff       	call   80108034 <walkpgdir>
801080fe:	83 c4 10             	add    $0x10,%esp
80108101:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108104:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108108:	75 07                	jne    80108111 <mappages+0x47>
      return -1;
8010810a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010810f:	eb 47                	jmp    80108158 <mappages+0x8e>
    if(*pte & PTE_P)
80108111:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108114:	8b 00                	mov    (%eax),%eax
80108116:	83 e0 01             	and    $0x1,%eax
80108119:	85 c0                	test   %eax,%eax
8010811b:	74 0d                	je     8010812a <mappages+0x60>
      panic("remap");
8010811d:	83 ec 0c             	sub    $0xc,%esp
80108120:	68 50 8f 10 80       	push   $0x80108f50
80108125:	e8 76 84 ff ff       	call   801005a0 <panic>
    *pte = pa | perm | PTE_P;
8010812a:	8b 45 18             	mov    0x18(%ebp),%eax
8010812d:	0b 45 14             	or     0x14(%ebp),%eax
80108130:	83 c8 01             	or     $0x1,%eax
80108133:	89 c2                	mov    %eax,%edx
80108135:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108138:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010813a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108140:	74 10                	je     80108152 <mappages+0x88>
      break;
    a += PGSIZE;
80108142:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108149:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108150:	eb 9c                	jmp    801080ee <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108152:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108153:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108158:	c9                   	leave  
80108159:	c3                   	ret    

8010815a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010815a:	55                   	push   %ebp
8010815b:	89 e5                	mov    %esp,%ebp
8010815d:	53                   	push   %ebx
8010815e:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108161:	e8 4d ab ff ff       	call   80102cb3 <kalloc>
80108166:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010816d:	75 07                	jne    80108176 <setupkvm+0x1c>
    return 0;
8010816f:	b8 00 00 00 00       	mov    $0x0,%eax
80108174:	eb 6a                	jmp    801081e0 <setupkvm+0x86>
  memset(pgdir, 0, PGSIZE);
80108176:	83 ec 04             	sub    $0x4,%esp
80108179:	68 00 10 00 00       	push   $0x1000
8010817e:	6a 00                	push   $0x0
80108180:	ff 75 f0             	pushl  -0x10(%ebp)
80108183:	e8 9e d4 ff ff       	call   80105626 <memset>
80108188:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010818b:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108192:	eb 40                	jmp    801081d4 <setupkvm+0x7a>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108197:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010819a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819d:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a3:	8b 58 08             	mov    0x8(%eax),%ebx
801081a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a9:	8b 40 04             	mov    0x4(%eax),%eax
801081ac:	29 c3                	sub    %eax,%ebx
801081ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b1:	8b 00                	mov    (%eax),%eax
801081b3:	83 ec 0c             	sub    $0xc,%esp
801081b6:	51                   	push   %ecx
801081b7:	52                   	push   %edx
801081b8:	53                   	push   %ebx
801081b9:	50                   	push   %eax
801081ba:	ff 75 f0             	pushl  -0x10(%ebp)
801081bd:	e8 08 ff ff ff       	call   801080ca <mappages>
801081c2:	83 c4 20             	add    $0x20,%esp
801081c5:	85 c0                	test   %eax,%eax
801081c7:	79 07                	jns    801081d0 <setupkvm+0x76>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801081c9:	b8 00 00 00 00       	mov    $0x0,%eax
801081ce:	eb 10                	jmp    801081e0 <setupkvm+0x86>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801081d0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801081d4:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801081db:	72 b7                	jb     80108194 <setupkvm+0x3a>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801081dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801081e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081e3:	c9                   	leave  
801081e4:	c3                   	ret    

801081e5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801081e5:	55                   	push   %ebp
801081e6:	89 e5                	mov    %esp,%ebp
801081e8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801081eb:	e8 6a ff ff ff       	call   8010815a <setupkvm>
801081f0:	a3 c4 7d 11 80       	mov    %eax,0x80117dc4
  switchkvm();
801081f5:	e8 03 00 00 00       	call   801081fd <switchkvm>
}
801081fa:	90                   	nop
801081fb:	c9                   	leave  
801081fc:	c3                   	ret    

801081fd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801081fd:	55                   	push   %ebp
801081fe:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108200:	a1 c4 7d 11 80       	mov    0x80117dc4,%eax
80108205:	05 00 00 00 80       	add    $0x80000000,%eax
8010820a:	50                   	push   %eax
8010820b:	e8 a3 f9 ff ff       	call   80107bb3 <lcr3>
80108210:	83 c4 04             	add    $0x4,%esp
}
80108213:	90                   	nop
80108214:	c9                   	leave  
80108215:	c3                   	ret    

80108216 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108216:	55                   	push   %ebp
80108217:	89 e5                	mov    %esp,%ebp
80108219:	56                   	push   %esi
8010821a:	53                   	push   %ebx
  pushcli();
8010821b:	e8 ee d2 ff ff       	call   8010550e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108220:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108226:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010822d:	83 c2 08             	add    $0x8,%edx
80108230:	89 d6                	mov    %edx,%esi
80108232:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108239:	83 c2 08             	add    $0x8,%edx
8010823c:	c1 ea 10             	shr    $0x10,%edx
8010823f:	89 d3                	mov    %edx,%ebx
80108241:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108248:	83 c2 08             	add    $0x8,%edx
8010824b:	c1 ea 18             	shr    $0x18,%edx
8010824e:	89 d1                	mov    %edx,%ecx
80108250:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108257:	67 00 
80108259:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108260:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108266:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010826d:	83 e2 f0             	and    $0xfffffff0,%edx
80108270:	83 ca 09             	or     $0x9,%edx
80108273:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108279:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108280:	83 ca 10             	or     $0x10,%edx
80108283:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108289:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108290:	83 e2 9f             	and    $0xffffff9f,%edx
80108293:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108299:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801082a0:	83 ca 80             	or     $0xffffff80,%edx
801082a3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801082a9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082b0:	83 e2 f0             	and    $0xfffffff0,%edx
801082b3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082b9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082c0:	83 e2 ef             	and    $0xffffffef,%edx
801082c3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082c9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082d0:	83 e2 df             	and    $0xffffffdf,%edx
801082d3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082d9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082e0:	83 ca 40             	or     $0x40,%edx
801082e3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082e9:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801082f0:	83 e2 7f             	and    $0x7f,%edx
801082f3:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801082f9:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801082ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108305:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010830c:	83 e2 ef             	and    $0xffffffef,%edx
8010830f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108315:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010831b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108321:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108327:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010832e:	8b 52 1c             	mov    0x1c(%edx),%edx
80108331:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108337:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
8010833a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108340:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80108346:	83 ec 0c             	sub    $0xc,%esp
80108349:	6a 30                	push   $0x30
8010834b:	e8 36 f8 ff ff       	call   80107b86 <ltr>
80108350:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108353:	8b 45 08             	mov    0x8(%ebp),%eax
80108356:	8b 40 18             	mov    0x18(%eax),%eax
80108359:	85 c0                	test   %eax,%eax
8010835b:	75 0d                	jne    8010836a <switchuvm+0x154>
    panic("switchuvm: no pgdir");
8010835d:	83 ec 0c             	sub    $0xc,%esp
80108360:	68 56 8f 10 80       	push   $0x80108f56
80108365:	e8 36 82 ff ff       	call   801005a0 <panic>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010836a:	8b 45 08             	mov    0x8(%ebp),%eax
8010836d:	8b 40 18             	mov    0x18(%eax),%eax
80108370:	05 00 00 00 80       	add    $0x80000000,%eax
80108375:	83 ec 0c             	sub    $0xc,%esp
80108378:	50                   	push   %eax
80108379:	e8 35 f8 ff ff       	call   80107bb3 <lcr3>
8010837e:	83 c4 10             	add    $0x10,%esp
  popcli();
80108381:	e8 df d1 ff ff       	call   80105565 <popcli>
}
80108386:	90                   	nop
80108387:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010838a:	5b                   	pop    %ebx
8010838b:	5e                   	pop    %esi
8010838c:	5d                   	pop    %ebp
8010838d:	c3                   	ret    

8010838e <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010838e:	55                   	push   %ebp
8010838f:	89 e5                	mov    %esp,%ebp
80108391:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80108394:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010839b:	76 0d                	jbe    801083aa <inituvm+0x1c>
    panic("inituvm: more than a page");
8010839d:	83 ec 0c             	sub    $0xc,%esp
801083a0:	68 6a 8f 10 80       	push   $0x80108f6a
801083a5:	e8 f6 81 ff ff       	call   801005a0 <panic>
  mem = kalloc();
801083aa:	e8 04 a9 ff ff       	call   80102cb3 <kalloc>
801083af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801083b2:	83 ec 04             	sub    $0x4,%esp
801083b5:	68 00 10 00 00       	push   $0x1000
801083ba:	6a 00                	push   $0x0
801083bc:	ff 75 f4             	pushl  -0xc(%ebp)
801083bf:	e8 62 d2 ff ff       	call   80105626 <memset>
801083c4:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801083c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ca:	05 00 00 00 80       	add    $0x80000000,%eax
801083cf:	83 ec 0c             	sub    $0xc,%esp
801083d2:	6a 06                	push   $0x6
801083d4:	50                   	push   %eax
801083d5:	68 00 10 00 00       	push   $0x1000
801083da:	6a 00                	push   $0x0
801083dc:	ff 75 08             	pushl  0x8(%ebp)
801083df:	e8 e6 fc ff ff       	call   801080ca <mappages>
801083e4:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801083e7:	83 ec 04             	sub    $0x4,%esp
801083ea:	ff 75 10             	pushl  0x10(%ebp)
801083ed:	ff 75 0c             	pushl  0xc(%ebp)
801083f0:	ff 75 f4             	pushl  -0xc(%ebp)
801083f3:	e8 ed d2 ff ff       	call   801056e5 <memmove>
801083f8:	83 c4 10             	add    $0x10,%esp
}
801083fb:	90                   	nop
801083fc:	c9                   	leave  
801083fd:	c3                   	ret    

801083fe <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801083fe:	55                   	push   %ebp
801083ff:	89 e5                	mov    %esp,%ebp
80108401:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108404:	8b 45 0c             	mov    0xc(%ebp),%eax
80108407:	25 ff 0f 00 00       	and    $0xfff,%eax
8010840c:	85 c0                	test   %eax,%eax
8010840e:	74 0d                	je     8010841d <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108410:	83 ec 0c             	sub    $0xc,%esp
80108413:	68 84 8f 10 80       	push   $0x80108f84
80108418:	e8 83 81 ff ff       	call   801005a0 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010841d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108424:	e9 8f 00 00 00       	jmp    801084b8 <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108429:	8b 55 0c             	mov    0xc(%ebp),%edx
8010842c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842f:	01 d0                	add    %edx,%eax
80108431:	83 ec 04             	sub    $0x4,%esp
80108434:	6a 00                	push   $0x0
80108436:	50                   	push   %eax
80108437:	ff 75 08             	pushl  0x8(%ebp)
8010843a:	e8 f5 fb ff ff       	call   80108034 <walkpgdir>
8010843f:	83 c4 10             	add    $0x10,%esp
80108442:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108445:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108449:	75 0d                	jne    80108458 <loaduvm+0x5a>
      panic("loaduvm: address should exist");
8010844b:	83 ec 0c             	sub    $0xc,%esp
8010844e:	68 a7 8f 10 80       	push   $0x80108fa7
80108453:	e8 48 81 ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
80108458:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010845b:	8b 00                	mov    (%eax),%eax
8010845d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108462:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108465:	8b 45 18             	mov    0x18(%ebp),%eax
80108468:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010846b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108470:	77 0b                	ja     8010847d <loaduvm+0x7f>
      n = sz - i;
80108472:	8b 45 18             	mov    0x18(%ebp),%eax
80108475:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108478:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010847b:	eb 07                	jmp    80108484 <loaduvm+0x86>
    else
      n = PGSIZE;
8010847d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108484:	8b 55 14             	mov    0x14(%ebp),%edx
80108487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848a:	01 d0                	add    %edx,%eax
8010848c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010848f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108495:	ff 75 f0             	pushl  -0x10(%ebp)
80108498:	50                   	push   %eax
80108499:	52                   	push   %edx
8010849a:	ff 75 10             	pushl  0x10(%ebp)
8010849d:	e8 55 9a ff ff       	call   80101ef7 <readi>
801084a2:	83 c4 10             	add    $0x10,%esp
801084a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084a8:	74 07                	je     801084b1 <loaduvm+0xb3>
      return -1;
801084aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084af:	eb 18                	jmp    801084c9 <loaduvm+0xcb>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801084b1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801084b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bb:	3b 45 18             	cmp    0x18(%ebp),%eax
801084be:	0f 82 65 ff ff ff    	jb     80108429 <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801084c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084c9:	c9                   	leave  
801084ca:	c3                   	ret    

801084cb <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801084cb:	55                   	push   %ebp
801084cc:	89 e5                	mov    %esp,%ebp
801084ce:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801084d1:	8b 45 10             	mov    0x10(%ebp),%eax
801084d4:	85 c0                	test   %eax,%eax
801084d6:	79 0a                	jns    801084e2 <allocuvm+0x17>
    return 0;
801084d8:	b8 00 00 00 00       	mov    $0x0,%eax
801084dd:	e9 ec 00 00 00       	jmp    801085ce <allocuvm+0x103>
  if(newsz < oldsz)
801084e2:	8b 45 10             	mov    0x10(%ebp),%eax
801084e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801084e8:	73 08                	jae    801084f2 <allocuvm+0x27>
    return oldsz;
801084ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ed:	e9 dc 00 00 00       	jmp    801085ce <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801084f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801084f5:	05 ff 0f 00 00       	add    $0xfff,%eax
801084fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108502:	e9 b8 00 00 00       	jmp    801085bf <allocuvm+0xf4>
    mem = kalloc();
80108507:	e8 a7 a7 ff ff       	call   80102cb3 <kalloc>
8010850c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010850f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108513:	75 2e                	jne    80108543 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80108515:	83 ec 0c             	sub    $0xc,%esp
80108518:	68 c5 8f 10 80       	push   $0x80108fc5
8010851d:	e8 de 7e ff ff       	call   80100400 <cprintf>
80108522:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108525:	83 ec 04             	sub    $0x4,%esp
80108528:	ff 75 0c             	pushl  0xc(%ebp)
8010852b:	ff 75 10             	pushl  0x10(%ebp)
8010852e:	ff 75 08             	pushl  0x8(%ebp)
80108531:	e8 9a 00 00 00       	call   801085d0 <deallocuvm>
80108536:	83 c4 10             	add    $0x10,%esp
      return 0;
80108539:	b8 00 00 00 00       	mov    $0x0,%eax
8010853e:	e9 8b 00 00 00       	jmp    801085ce <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80108543:	83 ec 04             	sub    $0x4,%esp
80108546:	68 00 10 00 00       	push   $0x1000
8010854b:	6a 00                	push   $0x0
8010854d:	ff 75 f0             	pushl  -0x10(%ebp)
80108550:	e8 d1 d0 ff ff       	call   80105626 <memset>
80108555:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108558:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010855b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108561:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108564:	83 ec 0c             	sub    $0xc,%esp
80108567:	6a 06                	push   $0x6
80108569:	52                   	push   %edx
8010856a:	68 00 10 00 00       	push   $0x1000
8010856f:	50                   	push   %eax
80108570:	ff 75 08             	pushl  0x8(%ebp)
80108573:	e8 52 fb ff ff       	call   801080ca <mappages>
80108578:	83 c4 20             	add    $0x20,%esp
8010857b:	85 c0                	test   %eax,%eax
8010857d:	79 39                	jns    801085b8 <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
8010857f:	83 ec 0c             	sub    $0xc,%esp
80108582:	68 dd 8f 10 80       	push   $0x80108fdd
80108587:	e8 74 7e ff ff       	call   80100400 <cprintf>
8010858c:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010858f:	83 ec 04             	sub    $0x4,%esp
80108592:	ff 75 0c             	pushl  0xc(%ebp)
80108595:	ff 75 10             	pushl  0x10(%ebp)
80108598:	ff 75 08             	pushl  0x8(%ebp)
8010859b:	e8 30 00 00 00       	call   801085d0 <deallocuvm>
801085a0:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801085a3:	83 ec 0c             	sub    $0xc,%esp
801085a6:	ff 75 f0             	pushl  -0x10(%ebp)
801085a9:	e8 6b a6 ff ff       	call   80102c19 <kfree>
801085ae:	83 c4 10             	add    $0x10,%esp
      return 0;
801085b1:	b8 00 00 00 00       	mov    $0x0,%eax
801085b6:	eb 16                	jmp    801085ce <allocuvm+0x103>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801085b8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c2:	3b 45 10             	cmp    0x10(%ebp),%eax
801085c5:	0f 82 3c ff ff ff    	jb     80108507 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801085cb:	8b 45 10             	mov    0x10(%ebp),%eax
}
801085ce:	c9                   	leave  
801085cf:	c3                   	ret    

801085d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801085d0:	55                   	push   %ebp
801085d1:	89 e5                	mov    %esp,%ebp
801085d3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801085d6:	8b 45 10             	mov    0x10(%ebp),%eax
801085d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801085dc:	72 08                	jb     801085e6 <deallocuvm+0x16>
    return oldsz;
801085de:	8b 45 0c             	mov    0xc(%ebp),%eax
801085e1:	e9 9c 00 00 00       	jmp    80108682 <deallocuvm+0xb2>

  a = PGROUNDUP(newsz);
801085e6:	8b 45 10             	mov    0x10(%ebp),%eax
801085e9:	05 ff 0f 00 00       	add    $0xfff,%eax
801085ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801085f6:	eb 7b                	jmp    80108673 <deallocuvm+0xa3>
    pte = walkpgdir(pgdir, (char*)a, 0);
801085f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fb:	83 ec 04             	sub    $0x4,%esp
801085fe:	6a 00                	push   $0x0
80108600:	50                   	push   %eax
80108601:	ff 75 08             	pushl  0x8(%ebp)
80108604:	e8 2b fa ff ff       	call   80108034 <walkpgdir>
80108609:	83 c4 10             	add    $0x10,%esp
8010860c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010860f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108613:	75 09                	jne    8010861e <deallocuvm+0x4e>
      a += (NPTENTRIES - 1) * PGSIZE;
80108615:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010861c:	eb 4e                	jmp    8010866c <deallocuvm+0x9c>
    else if((*pte & PTE_P) != 0){
8010861e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108621:	8b 00                	mov    (%eax),%eax
80108623:	83 e0 01             	and    $0x1,%eax
80108626:	85 c0                	test   %eax,%eax
80108628:	74 42                	je     8010866c <deallocuvm+0x9c>
      pa = PTE_ADDR(*pte);
8010862a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010862d:	8b 00                	mov    (%eax),%eax
8010862f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108634:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108637:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010863b:	75 0d                	jne    8010864a <deallocuvm+0x7a>
        panic("kfree");
8010863d:	83 ec 0c             	sub    $0xc,%esp
80108640:	68 f9 8f 10 80       	push   $0x80108ff9
80108645:	e8 56 7f ff ff       	call   801005a0 <panic>
      char *v = P2V(pa);
8010864a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010864d:	05 00 00 00 80       	add    $0x80000000,%eax
80108652:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108655:	83 ec 0c             	sub    $0xc,%esp
80108658:	ff 75 e8             	pushl  -0x18(%ebp)
8010865b:	e8 b9 a5 ff ff       	call   80102c19 <kfree>
80108660:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010866c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108676:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108679:	0f 82 79 ff ff ff    	jb     801085f8 <deallocuvm+0x28>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010867f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108682:	c9                   	leave  
80108683:	c3                   	ret    

80108684 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108684:	55                   	push   %ebp
80108685:	89 e5                	mov    %esp,%ebp
80108687:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010868a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010868e:	75 0d                	jne    8010869d <freevm+0x19>
    panic("freevm: no pgdir");
80108690:	83 ec 0c             	sub    $0xc,%esp
80108693:	68 ff 8f 10 80       	push   $0x80108fff
80108698:	e8 03 7f ff ff       	call   801005a0 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010869d:	83 ec 04             	sub    $0x4,%esp
801086a0:	6a 00                	push   $0x0
801086a2:	68 00 00 00 80       	push   $0x80000000
801086a7:	ff 75 08             	pushl  0x8(%ebp)
801086aa:	e8 21 ff ff ff       	call   801085d0 <deallocuvm>
801086af:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801086b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801086b9:	eb 48                	jmp    80108703 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
801086bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086c5:	8b 45 08             	mov    0x8(%ebp),%eax
801086c8:	01 d0                	add    %edx,%eax
801086ca:	8b 00                	mov    (%eax),%eax
801086cc:	83 e0 01             	and    $0x1,%eax
801086cf:	85 c0                	test   %eax,%eax
801086d1:	74 2c                	je     801086ff <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801086d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801086dd:	8b 45 08             	mov    0x8(%ebp),%eax
801086e0:	01 d0                	add    %edx,%eax
801086e2:	8b 00                	mov    (%eax),%eax
801086e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086e9:	05 00 00 00 80       	add    $0x80000000,%eax
801086ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801086f1:	83 ec 0c             	sub    $0xc,%esp
801086f4:	ff 75 f0             	pushl  -0x10(%ebp)
801086f7:	e8 1d a5 ff ff       	call   80102c19 <kfree>
801086fc:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801086ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108703:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010870a:	76 af                	jbe    801086bb <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010870c:	83 ec 0c             	sub    $0xc,%esp
8010870f:	ff 75 08             	pushl  0x8(%ebp)
80108712:	e8 02 a5 ff ff       	call   80102c19 <kfree>
80108717:	83 c4 10             	add    $0x10,%esp
}
8010871a:	90                   	nop
8010871b:	c9                   	leave  
8010871c:	c3                   	ret    

8010871d <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010871d:	55                   	push   %ebp
8010871e:	89 e5                	mov    %esp,%ebp
80108720:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108723:	83 ec 04             	sub    $0x4,%esp
80108726:	6a 00                	push   $0x0
80108728:	ff 75 0c             	pushl  0xc(%ebp)
8010872b:	ff 75 08             	pushl  0x8(%ebp)
8010872e:	e8 01 f9 ff ff       	call   80108034 <walkpgdir>
80108733:	83 c4 10             	add    $0x10,%esp
80108736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010873d:	75 0d                	jne    8010874c <clearpteu+0x2f>
    panic("clearpteu");
8010873f:	83 ec 0c             	sub    $0xc,%esp
80108742:	68 10 90 10 80       	push   $0x80109010
80108747:	e8 54 7e ff ff       	call   801005a0 <panic>
  *pte &= ~PTE_U;
8010874c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874f:	8b 00                	mov    (%eax),%eax
80108751:	83 e0 fb             	and    $0xfffffffb,%eax
80108754:	89 c2                	mov    %eax,%edx
80108756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108759:	89 10                	mov    %edx,(%eax)
}
8010875b:	90                   	nop
8010875c:	c9                   	leave  
8010875d:	c3                   	ret    

8010875e <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010875e:	55                   	push   %ebp
8010875f:	89 e5                	mov    %esp,%ebp
80108761:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108764:	e8 f1 f9 ff ff       	call   8010815a <setupkvm>
80108769:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010876c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108770:	75 0a                	jne    8010877c <copyuvm+0x1e>
    return 0;
80108772:	b8 00 00 00 00       	mov    $0x0,%eax
80108777:	e9 eb 00 00 00       	jmp    80108867 <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
8010877c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108783:	e9 b7 00 00 00       	jmp    8010883f <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878b:	83 ec 04             	sub    $0x4,%esp
8010878e:	6a 00                	push   $0x0
80108790:	50                   	push   %eax
80108791:	ff 75 08             	pushl  0x8(%ebp)
80108794:	e8 9b f8 ff ff       	call   80108034 <walkpgdir>
80108799:	83 c4 10             	add    $0x10,%esp
8010879c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010879f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087a3:	75 0d                	jne    801087b2 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
801087a5:	83 ec 0c             	sub    $0xc,%esp
801087a8:	68 1a 90 10 80       	push   $0x8010901a
801087ad:	e8 ee 7d ff ff       	call   801005a0 <panic>
    if(!(*pte & PTE_P))
801087b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087b5:	8b 00                	mov    (%eax),%eax
801087b7:	83 e0 01             	and    $0x1,%eax
801087ba:	85 c0                	test   %eax,%eax
801087bc:	75 0d                	jne    801087cb <copyuvm+0x6d>
      panic("copyuvm: page not present");
801087be:	83 ec 0c             	sub    $0xc,%esp
801087c1:	68 34 90 10 80       	push   $0x80109034
801087c6:	e8 d5 7d ff ff       	call   801005a0 <panic>
    pa = PTE_ADDR(*pte);
801087cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087ce:	8b 00                	mov    (%eax),%eax
801087d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801087d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087db:	8b 00                	mov    (%eax),%eax
801087dd:	25 ff 0f 00 00       	and    $0xfff,%eax
801087e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801087e5:	e8 c9 a4 ff ff       	call   80102cb3 <kalloc>
801087ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
801087ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801087f1:	74 5d                	je     80108850 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801087f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801087f6:	05 00 00 00 80       	add    $0x80000000,%eax
801087fb:	83 ec 04             	sub    $0x4,%esp
801087fe:	68 00 10 00 00       	push   $0x1000
80108803:	50                   	push   %eax
80108804:	ff 75 e0             	pushl  -0x20(%ebp)
80108807:	e8 d9 ce ff ff       	call   801056e5 <memmove>
8010880c:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
8010880f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108812:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108815:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010881b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010881e:	83 ec 0c             	sub    $0xc,%esp
80108821:	52                   	push   %edx
80108822:	51                   	push   %ecx
80108823:	68 00 10 00 00       	push   $0x1000
80108828:	50                   	push   %eax
80108829:	ff 75 f0             	pushl  -0x10(%ebp)
8010882c:	e8 99 f8 ff ff       	call   801080ca <mappages>
80108831:	83 c4 20             	add    $0x20,%esp
80108834:	85 c0                	test   %eax,%eax
80108836:	78 1b                	js     80108853 <copyuvm+0xf5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108838:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010883f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108842:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108845:	0f 82 3d ff ff ff    	jb     80108788 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
8010884b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010884e:	eb 17                	jmp    80108867 <copyuvm+0x109>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108850:	90                   	nop
80108851:	eb 01                	jmp    80108854 <copyuvm+0xf6>
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
80108853:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108854:	83 ec 0c             	sub    $0xc,%esp
80108857:	ff 75 f0             	pushl  -0x10(%ebp)
8010885a:	e8 25 fe ff ff       	call   80108684 <freevm>
8010885f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108862:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108867:	c9                   	leave  
80108868:	c3                   	ret    

80108869 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108869:	55                   	push   %ebp
8010886a:	89 e5                	mov    %esp,%ebp
8010886c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010886f:	83 ec 04             	sub    $0x4,%esp
80108872:	6a 00                	push   $0x0
80108874:	ff 75 0c             	pushl  0xc(%ebp)
80108877:	ff 75 08             	pushl  0x8(%ebp)
8010887a:	e8 b5 f7 ff ff       	call   80108034 <walkpgdir>
8010887f:	83 c4 10             	add    $0x10,%esp
80108882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108888:	8b 00                	mov    (%eax),%eax
8010888a:	83 e0 01             	and    $0x1,%eax
8010888d:	85 c0                	test   %eax,%eax
8010888f:	75 07                	jne    80108898 <uva2ka+0x2f>
    return 0;
80108891:	b8 00 00 00 00       	mov    $0x0,%eax
80108896:	eb 22                	jmp    801088ba <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80108898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010889b:	8b 00                	mov    (%eax),%eax
8010889d:	83 e0 04             	and    $0x4,%eax
801088a0:	85 c0                	test   %eax,%eax
801088a2:	75 07                	jne    801088ab <uva2ka+0x42>
    return 0;
801088a4:	b8 00 00 00 00       	mov    $0x0,%eax
801088a9:	eb 0f                	jmp    801088ba <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
801088ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ae:	8b 00                	mov    (%eax),%eax
801088b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088b5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801088ba:	c9                   	leave  
801088bb:	c3                   	ret    

801088bc <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801088bc:	55                   	push   %ebp
801088bd:	89 e5                	mov    %esp,%ebp
801088bf:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801088c2:	8b 45 10             	mov    0x10(%ebp),%eax
801088c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801088c8:	eb 7f                	jmp    80108949 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801088ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801088cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801088d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088d8:	83 ec 08             	sub    $0x8,%esp
801088db:	50                   	push   %eax
801088dc:	ff 75 08             	pushl  0x8(%ebp)
801088df:	e8 85 ff ff ff       	call   80108869 <uva2ka>
801088e4:	83 c4 10             	add    $0x10,%esp
801088e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801088ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801088ee:	75 07                	jne    801088f7 <copyout+0x3b>
      return -1;
801088f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088f5:	eb 61                	jmp    80108958 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801088f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088fa:	2b 45 0c             	sub    0xc(%ebp),%eax
801088fd:	05 00 10 00 00       	add    $0x1000,%eax
80108902:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108908:	3b 45 14             	cmp    0x14(%ebp),%eax
8010890b:	76 06                	jbe    80108913 <copyout+0x57>
      n = len;
8010890d:	8b 45 14             	mov    0x14(%ebp),%eax
80108910:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108913:	8b 45 0c             	mov    0xc(%ebp),%eax
80108916:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108919:	89 c2                	mov    %eax,%edx
8010891b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010891e:	01 d0                	add    %edx,%eax
80108920:	83 ec 04             	sub    $0x4,%esp
80108923:	ff 75 f0             	pushl  -0x10(%ebp)
80108926:	ff 75 f4             	pushl  -0xc(%ebp)
80108929:	50                   	push   %eax
8010892a:	e8 b6 cd ff ff       	call   801056e5 <memmove>
8010892f:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108935:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010893b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010893e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108941:	05 00 10 00 00       	add    $0x1000,%eax
80108946:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108949:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010894d:	0f 85 77 ff ff ff    	jne    801088ca <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108953:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108958:	c9                   	leave  
80108959:	c3                   	ret    
