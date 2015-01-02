
obj/fs/fs:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 43 44 00 00       	callq  804484 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	53                   	push   %rbx
  800049:	48 83 ec 18          	sub    $0x18,%rsp
  80004d:	89 f8                	mov    %edi,%eax
  80004f:	88 45 e4             	mov    %al,-0x1c(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800052:	c7 45 f0 f7 01 00 00 	movl   $0x1f7,-0x10(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800059:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80005c:	89 55 e0             	mov    %edx,-0x20(%rbp)
  80005f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800062:	ec                   	in     (%dx),%al
  800063:	89 c3                	mov    %eax,%ebx
  800065:	88 5d ef             	mov    %bl,-0x11(%rbp)
	return data;
  800068:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80006c:	0f b6 c0             	movzbl %al,%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800072:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800075:	25 c0 00 00 00       	and    $0xc0,%eax
  80007a:	83 f8 40             	cmp    $0x40,%eax
  80007d:	75 d3                	jne    800052 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80007f:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  800083:	74 11                	je     800096 <ide_wait_ready+0x52>
  800085:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800088:	83 e0 21             	and    $0x21,%eax
  80008b:	85 c0                	test   %eax,%eax
  80008d:	74 07                	je     800096 <ide_wait_ready+0x52>
		return -1;
  80008f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800094:	eb 05                	jmp    80009b <ide_wait_ready+0x57>
	return 0;
  800096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80009b:	48 83 c4 18          	add    $0x18,%rsp
  80009f:	5b                   	pop    %rbx
  8000a0:	5d                   	pop    %rbp
  8000a1:	c3                   	retq   

00000000008000a2 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  8000a2:	55                   	push   %rbp
  8000a3:	48 89 e5             	mov    %rsp,%rbp
  8000a6:	53                   	push   %rbx
  8000a7:	48 83 ec 38          	sub    $0x38,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  8000ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8000b0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
  8000bc:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  8000c3:	c6 45 e3 f0          	movb   $0xf0,-0x1d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000c7:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  8000cb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8000ce:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000d6:	eb 04                	jmp    8000dc <ide_probe_disk1+0x3a>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000d8:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000dc:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  8000e3:	7f 2c                	jg     800111 <ide_probe_disk1+0x6f>
  8000e5:	c7 45 dc f7 01 00 00 	movl   $0x1f7,-0x24(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000ec:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8000ef:	89 55 cc             	mov    %edx,-0x34(%rbp)
  8000f2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8000f5:	ec                   	in     (%dx),%al
  8000f6:	89 c3                	mov    %eax,%ebx
  8000f8:	88 5d db             	mov    %bl,-0x25(%rbp)
	return data;
  8000fb:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ff:	0f b6 c0             	movzbl %al,%eax
  800102:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800105:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800108:	25 a1 00 00 00       	and    $0xa1,%eax
  80010d:	85 c0                	test   %eax,%eax
  80010f:	75 c7                	jne    8000d8 <ide_probe_disk1+0x36>
  800111:	c7 45 d4 f6 01 00 00 	movl   $0x1f6,-0x2c(%rbp)
  800118:	c6 45 d3 e0          	movb   $0xe0,-0x2d(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80011c:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
  800120:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  800123:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800124:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  80012b:	0f 9e c0             	setle  %al
  80012e:	0f b6 c0             	movzbl %al,%eax
  800131:	89 c6                	mov    %eax,%esi
  800133:	48 bf 40 81 80 00 00 	movabs $0x808140,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  800149:	00 00 00 
  80014c:	ff d2                	callq  *%rdx
	return (x < 1000);
  80014e:	81 7d ec e7 03 00 00 	cmpl   $0x3e7,-0x14(%rbp)
  800155:	0f 9e c0             	setle  %al
}
  800158:	48 83 c4 38          	add    $0x38,%rsp
  80015c:	5b                   	pop    %rbx
  80015d:	5d                   	pop    %rbp
  80015e:	c3                   	retq   

000000000080015f <ide_set_disk>:

void
ide_set_disk(int d)
{
  80015f:	55                   	push   %rbp
  800160:	48 89 e5             	mov    %rsp,%rbp
  800163:	48 83 ec 10          	sub    $0x10,%rsp
  800167:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  80016a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016e:	74 30                	je     8001a0 <ide_set_disk+0x41>
  800170:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  800174:	74 2a                	je     8001a0 <ide_set_disk+0x41>
		panic("bad disk number");
  800176:	48 ba 57 81 80 00 00 	movabs $0x808157,%rdx
  80017d:	00 00 00 
  800180:	be 3a 00 00 00       	mov    $0x3a,%esi
  800185:	48 bf 67 81 80 00 00 	movabs $0x808167,%rdi
  80018c:	00 00 00 
  80018f:	b8 00 00 00 00       	mov    $0x0,%eax
  800194:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  80019b:	00 00 00 
  80019e:	ff d1                	callq  *%rcx
	diskno = d;
  8001a0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8001a7:	00 00 00 
  8001aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001ad:	89 10                	mov    %edx,(%rax)
}
  8001af:	c9                   	leaveq 
  8001b0:	c3                   	retq   

00000000008001b1 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8001b1:	55                   	push   %rbp
  8001b2:	48 89 e5             	mov    %rsp,%rbp
  8001b5:	41 54                	push   %r12
  8001b7:	53                   	push   %rbx
  8001b8:	48 83 ec 70          	sub    $0x70,%rsp
  8001bc:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  8001bf:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  8001c3:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
	int r;

	assert(nsecs <= 256);
  8001c7:	48 81 7d 88 00 01 00 	cmpq   $0x100,-0x78(%rbp)
  8001ce:	00 
  8001cf:	76 35                	jbe    800206 <ide_read+0x55>
  8001d1:	48 b9 70 81 80 00 00 	movabs $0x808170,%rcx
  8001d8:	00 00 00 
  8001db:	48 ba 7d 81 80 00 00 	movabs $0x80817d,%rdx
  8001e2:	00 00 00 
  8001e5:	be 43 00 00 00       	mov    $0x43,%esi
  8001ea:	48 bf 67 81 80 00 00 	movabs $0x808167,%rdi
  8001f1:	00 00 00 
  8001f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001f9:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800200:	00 00 00 
  800203:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800206:	bf 00 00 00 00       	mov    $0x0,%edi
  80020b:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800217:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  80021b:	0f b6 c0             	movzbl %al,%eax
  80021e:	c7 45 e8 f2 01 00 00 	movl   $0x1f2,-0x18(%rbp)
  800225:	88 45 e7             	mov    %al,-0x19(%rbp)
  800228:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  80022c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80022f:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800230:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e0 f3 01 00 00 	movl   $0x1f3,-0x20(%rbp)
  80023d:	88 45 df             	mov    %al,-0x21(%rbp)
  800240:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800244:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  800248:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80024b:	c1 e8 08             	shr    $0x8,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 d8 f4 01 00 00 	movl   $0x1f4,-0x28(%rbp)
  800258:	88 45 d7             	mov    %al,-0x29(%rbp)
  80025b:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80025f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800263:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800266:	c1 e8 10             	shr    $0x10,%eax
  800269:	0f b6 c0             	movzbl %al,%eax
  80026c:	c7 45 d0 f5 01 00 00 	movl   $0x1f5,-0x30(%rbp)
  800273:	88 45 cf             	mov    %al,-0x31(%rbp)
  800276:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  80027a:	8b 55 d0             	mov    -0x30(%rbp),%edx
  80027d:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80027e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  800285:	00 00 00 
  800288:	8b 00                	mov    (%rax),%eax
  80028a:	83 e0 01             	and    $0x1,%eax
  80028d:	89 c2                	mov    %eax,%edx
  80028f:	c1 e2 04             	shl    $0x4,%edx
  800292:	8b 45 9c             	mov    -0x64(%rbp),%eax
  800295:	c1 e8 18             	shr    $0x18,%eax
  800298:	83 e0 0f             	and    $0xf,%eax
  80029b:	09 d0                	or     %edx,%eax
  80029d:	83 c8 e0             	or     $0xffffffe0,%eax
  8002a0:	0f b6 c0             	movzbl %al,%eax
  8002a3:	c7 45 c8 f6 01 00 00 	movl   $0x1f6,-0x38(%rbp)
  8002aa:	88 45 c7             	mov    %al,-0x39(%rbp)
  8002ad:	0f b6 45 c7          	movzbl -0x39(%rbp),%eax
  8002b1:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002b4:	ee                   	out    %al,(%dx)
  8002b5:	c7 45 c0 f7 01 00 00 	movl   $0x1f7,-0x40(%rbp)
  8002bc:	c6 45 bf 20          	movb   $0x20,-0x41(%rbp)
  8002c0:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  8002c4:	8b 55 c0             	mov    -0x40(%rbp),%edx
  8002c7:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002c8:	eb 67                	jmp    800331 <ide_read+0x180>
		if ((r = ide_wait_ready(1)) < 0)
  8002ca:	bf 01 00 00 00       	mov    $0x1,%edi
  8002cf:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	callq  *%rax
  8002db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8002de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8002e2:	79 05                	jns    8002e9 <ide_read+0x138>
			return r;
  8002e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e7:	eb 54                	jmp    80033d <ide_read+0x18c>
  8002e9:	c7 45 b8 f0 01 00 00 	movl   $0x1f0,-0x48(%rbp)
  8002f0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  8002f4:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8002f8:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%rbp)
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8002ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800302:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800306:	8b 55 ac             	mov    -0x54(%rbp),%edx
  800309:	49 89 cc             	mov    %rcx,%r12
  80030c:	89 d3                	mov    %edx,%ebx
  80030e:	4c 89 e7             	mov    %r12,%rdi
  800311:	89 d9                	mov    %ebx,%ecx
  800313:	89 c2                	mov    %eax,%edx
  800315:	fc                   	cld    
  800316:	f2 6d                	repnz insl (%dx),%es:(%rdi)
  800318:	89 cb                	mov    %ecx,%ebx
  80031a:	49 89 fc             	mov    %rdi,%r12
  80031d:	4c 89 65 b0          	mov    %r12,-0x50(%rbp)
  800321:	89 5d ac             	mov    %ebx,-0x54(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800324:	48 83 6d 88 01       	subq   $0x1,-0x78(%rbp)
  800329:	48 81 45 90 00 02 00 	addq   $0x200,-0x70(%rbp)
  800330:	00 
  800331:	48 83 7d 88 00       	cmpq   $0x0,-0x78(%rbp)
  800336:	75 92                	jne    8002ca <ide_read+0x119>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80033d:	48 83 c4 70          	add    $0x70,%rsp
  800341:	5b                   	pop    %rbx
  800342:	41 5c                	pop    %r12
  800344:	5d                   	pop    %rbp
  800345:	c3                   	retq   

0000000000800346 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800346:	55                   	push   %rbp
  800347:	48 89 e5             	mov    %rsp,%rbp
  80034a:	41 54                	push   %r12
  80034c:	53                   	push   %rbx
  80034d:	48 83 ec 70          	sub    $0x70,%rsp
  800351:	89 7d 9c             	mov    %edi,-0x64(%rbp)
  800354:	48 89 75 90          	mov    %rsi,-0x70(%rbp)
  800358:	48 89 55 88          	mov    %rdx,-0x78(%rbp)
	int r;

	assert(nsecs <= 256);
  80035c:	48 81 7d 88 00 01 00 	cmpq   $0x100,-0x78(%rbp)
  800363:	00 
  800364:	76 35                	jbe    80039b <ide_write+0x55>
  800366:	48 b9 70 81 80 00 00 	movabs $0x808170,%rcx
  80036d:	00 00 00 
  800370:	48 ba 7d 81 80 00 00 	movabs $0x80817d,%rdx
  800377:	00 00 00 
  80037a:	be 5c 00 00 00       	mov    $0x5c,%esi
  80037f:	48 bf 67 81 80 00 00 	movabs $0x808167,%rdi
  800386:	00 00 00 
  800389:	b8 00 00 00 00       	mov    $0x0,%eax
  80038e:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800395:	00 00 00 
  800398:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  80039b:	bf 00 00 00 00       	mov    $0x0,%edi
  8003a0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8003ac:	48 8b 45 88          	mov    -0x78(%rbp),%rax
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	c7 45 e8 f2 01 00 00 	movl   $0x1f2,-0x18(%rbp)
  8003ba:	88 45 e7             	mov    %al,-0x19(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8003bd:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003c1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003c4:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  8003c5:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003c8:	0f b6 c0             	movzbl %al,%eax
  8003cb:	c7 45 e0 f3 01 00 00 	movl   $0x1f3,-0x20(%rbp)
  8003d2:	88 45 df             	mov    %al,-0x21(%rbp)
  8003d5:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003d9:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003dc:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003dd:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003e0:	c1 e8 08             	shr    $0x8,%eax
  8003e3:	0f b6 c0             	movzbl %al,%eax
  8003e6:	c7 45 d8 f4 01 00 00 	movl   $0x1f4,-0x28(%rbp)
  8003ed:	88 45 d7             	mov    %al,-0x29(%rbp)
  8003f0:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  8003f4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8003f7:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003f8:	8b 45 9c             	mov    -0x64(%rbp),%eax
  8003fb:	c1 e8 10             	shr    $0x10,%eax
  8003fe:	0f b6 c0             	movzbl %al,%eax
  800401:	c7 45 d0 f5 01 00 00 	movl   $0x1f5,-0x30(%rbp)
  800408:	88 45 cf             	mov    %al,-0x31(%rbp)
  80040b:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  80040f:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800412:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800413:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80041a:	00 00 00 
  80041d:	8b 00                	mov    (%rax),%eax
  80041f:	83 e0 01             	and    $0x1,%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	c1 e2 04             	shl    $0x4,%edx
  800427:	8b 45 9c             	mov    -0x64(%rbp),%eax
  80042a:	c1 e8 18             	shr    $0x18,%eax
  80042d:	83 e0 0f             	and    $0xf,%eax
  800430:	09 d0                	or     %edx,%eax
  800432:	83 c8 e0             	or     $0xffffffe0,%eax
  800435:	0f b6 c0             	movzbl %al,%eax
  800438:	c7 45 c8 f6 01 00 00 	movl   $0x1f6,-0x38(%rbp)
  80043f:	88 45 c7             	mov    %al,-0x39(%rbp)
  800442:	0f b6 45 c7          	movzbl -0x39(%rbp),%eax
  800446:	8b 55 c8             	mov    -0x38(%rbp),%edx
  800449:	ee                   	out    %al,(%dx)
  80044a:	c7 45 c0 f7 01 00 00 	movl   $0x1f7,-0x40(%rbp)
  800451:	c6 45 bf 30          	movb   $0x30,-0x41(%rbp)
  800455:	0f b6 45 bf          	movzbl -0x41(%rbp),%eax
  800459:	8b 55 c0             	mov    -0x40(%rbp),%edx
  80045c:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80045d:	eb 67                	jmp    8004c6 <ide_write+0x180>
		if ((r = ide_wait_ready(1)) < 0)
  80045f:	bf 01 00 00 00       	mov    $0x1,%edi
  800464:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80046b:	00 00 00 
  80046e:	ff d0                	callq  *%rax
  800470:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800473:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800477:	79 05                	jns    80047e <ide_write+0x138>
			return r;
  800479:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80047c:	eb 54                	jmp    8004d2 <ide_write+0x18c>
  80047e:	c7 45 b8 f0 01 00 00 	movl   $0x1f0,-0x48(%rbp)
  800485:	48 8b 45 90          	mov    -0x70(%rbp),%rax
  800489:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80048d:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%rbp)
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800494:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800497:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  80049b:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80049e:	49 89 cc             	mov    %rcx,%r12
  8004a1:	89 d3                	mov    %edx,%ebx
  8004a3:	4c 89 e6             	mov    %r12,%rsi
  8004a6:	89 d9                	mov    %ebx,%ecx
  8004a8:	89 c2                	mov    %eax,%edx
  8004aa:	fc                   	cld    
  8004ab:	f2 6f                	repnz outsl %ds:(%rsi),(%dx)
  8004ad:	89 cb                	mov    %ecx,%ebx
  8004af:	49 89 f4             	mov    %rsi,%r12
  8004b2:	4c 89 65 b0          	mov    %r12,-0x50(%rbp)
  8004b6:	89 5d ac             	mov    %ebx,-0x54(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8004b9:	48 83 6d 88 01       	subq   $0x1,-0x78(%rbp)
  8004be:	48 81 45 90 00 02 00 	addq   $0x200,-0x70(%rbp)
  8004c5:	00 
  8004c6:	48 83 7d 88 00       	cmpq   $0x0,-0x78(%rbp)
  8004cb:	75 92                	jne    80045f <ide_write+0x119>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d2:	48 83 c4 70          	add    $0x70,%rsp
  8004d6:	5b                   	pop    %rbx
  8004d7:	41 5c                	pop    %r12
  8004d9:	5d                   	pop    %rbp
  8004da:	c3                   	retq   
	...

00000000008004dc <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004dc:	55                   	push   %rbp
  8004dd:	48 89 e5             	mov    %rsp,%rbp
  8004e0:	48 83 ec 10          	sub    $0x10,%rsp
  8004e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004e8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004ed:	74 2a                	je     800519 <diskaddr+0x3d>
  8004ef:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  8004f6:	00 00 00 
  8004f9:	48 8b 00             	mov    (%rax),%rax
  8004fc:	48 85 c0             	test   %rax,%rax
  8004ff:	74 4a                	je     80054b <diskaddr+0x6f>
  800501:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  800508:	00 00 00 
  80050b:	48 8b 00             	mov    (%rax),%rax
  80050e:	8b 40 04             	mov    0x4(%rax),%eax
  800511:	89 c0                	mov    %eax,%eax
  800513:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800517:	77 32                	ja     80054b <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  800519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051d:	48 89 c1             	mov    %rax,%rcx
  800520:	48 ba 98 81 80 00 00 	movabs $0x808198,%rdx
  800527:	00 00 00 
  80052a:	be 09 00 00 00       	mov    $0x9,%esi
  80052f:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800536:	00 00 00 
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800545:	00 00 00 
  800548:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  80054b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80054f:	48 05 00 00 01 00    	add    $0x10000,%rax
  800555:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800559:	c9                   	leaveq 
  80055a:	c3                   	retq   

000000000080055b <eviction_policy>:

void eviction_policy()
{
  80055b:	55                   	push   %rbp
  80055c:	48 89 e5             	mov    %rsp,%rbp
  80055f:	48 83 ec 20          	sub    $0x20,%rsp
	int i, r, eviction_block_count = 0;
  800563:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	uint32_t *addr;
	cprintf("Block cache eviction policy in action...\n");
  80056a:	48 bf c8 81 80 00 00 	movabs $0x8081c8,%rdi
  800571:	00 00 00 
  800574:	b8 00 00 00 00       	mov    $0x0,%eax
  800579:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  800580:	00 00 00 
  800583:	ff d2                	callq  *%rdx
	for(i=3;i<super->s_nblocks && eviction_block_count < EVICT_BLOCK_CACHE_SIZE;i++)
  800585:	c7 45 fc 03 00 00 00 	movl   $0x3,-0x4(%rbp)
  80058c:	e9 9b 01 00 00       	jmpq   80072c <eviction_policy+0x1d1>
	{
		addr = diskaddr(i);
  800591:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800594:	48 98                	cltq   
  800596:	48 89 c7             	mov    %rax,%rdi
  800599:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8005a0:	00 00 00 
  8005a3:	ff d0                	callq  *%rax
  8005a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		//cprintf("addr:%08x\nroundedaddr:%08x\n", addr, ROUNDUP(addr, BLKSIZE    ));
		if(uvpd[VPD(addr)] & PTE_P)
  8005a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ad:	48 89 c2             	mov    %rax,%rdx
  8005b0:	48 c1 ea 15          	shr    $0x15,%rdx
  8005b4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005bb:	01 00 00 
  8005be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005c2:	83 e0 01             	and    $0x1,%eax
  8005c5:	84 c0                	test   %al,%al
  8005c7:	0f 84 1c 01 00 00    	je     8006e9 <eviction_policy+0x18e>
		{
			if(uvpt[PGNUM(addr)] & PTE_P)
  8005cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d1:	48 89 c2             	mov    %rax,%rdx
  8005d4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8005d8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005df:	01 00 00 
  8005e2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e6:	83 e0 01             	and    $0x1,%eax
  8005e9:	84 c0                	test   %al,%al
  8005eb:	0f 84 d7 00 00 00    	je     8006c8 <eviction_policy+0x16d>
			{
				if(uvpt[PGNUM(addr)] & PTE_A)
  8005f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005f5:	48 89 c2             	mov    %rax,%rdx
  8005f8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8005fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800603:	01 00 00 
  800606:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80060a:	83 e0 20             	and    $0x20,%eax
  80060d:	48 85 c0             	test   %rax,%rax
  800610:	0f 84 f2 00 00 00    	je     800708 <eviction_policy+0x1ad>
				{
					r = sys_page_map(0, addr, 0, addr, PTE_SYSCALL);
  800616:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80061e:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  800624:	48 89 d1             	mov    %rdx,%rcx
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	48 89 c6             	mov    %rax,%rsi
  80062f:	bf 00 00 00 00       	mov    $0x0,%edi
  800634:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  80063b:	00 00 00 
  80063e:	ff d0                	callq  *%rax
  800640:	89 45 ec             	mov    %eax,-0x14(%rbp)
					if(r<0)
  800643:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800647:	79 30                	jns    800679 <eviction_policy+0x11e>
			                 	panic("panic in eviction_policy:sys_page_map: %e", r);
  800649:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	48 ba f8 81 80 00 00 	movabs $0x8081f8,%rdx
  800655:	00 00 00 
  800658:	be 1e 00 00 00       	mov    $0x1e,%esi
  80065d:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800664:	00 00 00 
  800667:	b8 00 00 00 00       	mov    $0x0,%eax
  80066c:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800673:	00 00 00 
  800676:	41 ff d0             	callq  *%r8
					else
					{
						flush_block(addr);
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	48 89 c7             	mov    %rax,%rdi
  800680:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  800687:	00 00 00 
  80068a:	ff d0                	callq  *%rax
						r = sys_page_unmap(0, addr);
  80068c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800690:	48 89 c6             	mov    %rax,%rsi
  800693:	bf 00 00 00 00       	mov    $0x0,%edi
  800698:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  80069f:	00 00 00 
  8006a2:	ff d0                	callq  *%rax
  8006a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
						eviction_block_count++;
  8006a7:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
						block_cache_count--;
  8006ab:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  8006b2:	00 00 00 
  8006b5:	8b 00                	mov    (%rax),%eax
  8006b7:	8d 50 ff             	lea    -0x1(%rax),%edx
  8006ba:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  8006c1:	00 00 00 
  8006c4:	89 10                	mov    %edx,(%rax)
  8006c6:	eb 40                	jmp    800708 <eviction_policy+0x1ad>
					}
				}
			}
			else
			{
				eviction_block_count++;
  8006c8:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
				block_cache_count--;
  8006cc:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  8006d3:	00 00 00 
  8006d6:	8b 00                	mov    (%rax),%eax
  8006d8:	8d 50 ff             	lea    -0x1(%rax),%edx
  8006db:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  8006e2:	00 00 00 
  8006e5:	89 10                	mov    %edx,(%rax)
  8006e7:	eb 1f                	jmp    800708 <eviction_policy+0x1ad>
			}
		}
		else
		{
			eviction_block_count++;
  8006e9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
			block_cache_count--;
  8006ed:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  8006f4:	00 00 00 
  8006f7:	8b 00                	mov    (%rax),%eax
  8006f9:	8d 50 ff             	lea    -0x1(%rax),%edx
  8006fc:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  800703:	00 00 00 
  800706:	89 10                	mov    %edx,(%rax)
		}
		cprintf("Disk block number %d evicted from block cache\n",i);
  800708:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80070b:	89 c6                	mov    %eax,%esi
  80070d:	48 bf 28 82 80 00 00 	movabs $0x808228,%rdi
  800714:	00 00 00 
  800717:	b8 00 00 00 00       	mov    $0x0,%eax
  80071c:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  800723:	00 00 00 
  800726:	ff d2                	callq  *%rdx
void eviction_policy()
{
	int i, r, eviction_block_count = 0;
	uint32_t *addr;
	cprintf("Block cache eviction policy in action...\n");
	for(i=3;i<super->s_nblocks && eviction_block_count < EVICT_BLOCK_CACHE_SIZE;i++)
  800728:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80072c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80072f:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  800736:	00 00 00 
  800739:	48 8b 00             	mov    (%rax),%rax
  80073c:	8b 40 04             	mov    0x4(%rax),%eax
  80073f:	39 c2                	cmp    %eax,%edx
  800741:	73 0a                	jae    80074d <eviction_policy+0x1f2>
  800743:	83 7d f8 09          	cmpl   $0x9,-0x8(%rbp)
  800747:	0f 8e 44 fe ff ff    	jle    800591 <eviction_policy+0x36>
			eviction_block_count++;
			block_cache_count--;
		}
		cprintf("Disk block number %d evicted from block cache\n",i);
	}
}
  80074d:	c9                   	leaveq 
  80074e:	c3                   	retq   

000000000080074f <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80074f:	55                   	push   %rbp
  800750:	48 89 e5             	mov    %rsp,%rbp
  800753:	48 83 ec 08          	sub    $0x8,%rsp
  800757:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80075b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80075f:	48 89 c2             	mov    %rax,%rdx
  800762:	48 c1 ea 27          	shr    $0x27,%rdx
  800766:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80076d:	01 00 00 
  800770:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800774:	83 e0 01             	and    $0x1,%eax
  800777:	84 c0                	test   %al,%al
  800779:	74 67                	je     8007e2 <va_is_mapped+0x93>
  80077b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80077f:	48 89 c2             	mov    %rax,%rdx
  800782:	48 c1 ea 1e          	shr    $0x1e,%rdx
  800786:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80078d:	01 00 00 
  800790:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800794:	83 e0 01             	and    $0x1,%eax
  800797:	84 c0                	test   %al,%al
  800799:	74 47                	je     8007e2 <va_is_mapped+0x93>
  80079b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80079f:	48 89 c2             	mov    %rax,%rdx
  8007a2:	48 c1 ea 15          	shr    $0x15,%rdx
  8007a6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8007ad:	01 00 00 
  8007b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007b4:	83 e0 01             	and    $0x1,%eax
  8007b7:	84 c0                	test   %al,%al
  8007b9:	74 27                	je     8007e2 <va_is_mapped+0x93>
  8007bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007bf:	48 89 c2             	mov    %rax,%rdx
  8007c2:	48 c1 ea 0c          	shr    $0xc,%rdx
  8007c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007cd:	01 00 00 
  8007d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d4:	83 e0 01             	and    $0x1,%eax
  8007d7:	84 c0                	test   %al,%al
  8007d9:	74 07                	je     8007e2 <va_is_mapped+0x93>
  8007db:	b8 01 00 00 00       	mov    $0x1,%eax
  8007e0:	eb 05                	jmp    8007e7 <va_is_mapped+0x98>
  8007e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007e7:	c9                   	leaveq 
  8007e8:	c3                   	retq   

00000000008007e9 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8007e9:	55                   	push   %rbp
  8007ea:	48 89 e5             	mov    %rsp,%rbp
  8007ed:	48 83 ec 08          	sub    $0x8,%rsp
  8007f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8007f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007f9:	48 89 c2             	mov    %rax,%rdx
  8007fc:	48 c1 ea 0c          	shr    $0xc,%rdx
  800800:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800807:	01 00 00 
  80080a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80080e:	83 e0 40             	and    $0x40,%eax
  800811:	48 85 c0             	test   %rax,%rax
  800814:	0f 95 c0             	setne  %al
}
  800817:	c9                   	leaveq 
  800818:	c3                   	retq   

0000000000800819 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800819:	55                   	push   %rbp
  80081a:	48 89 e5             	mov    %rsp,%rbp
  80081d:	48 83 ec 40          	sub    $0x40,%rsp
  800821:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  800825:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800829:	48 8b 00             	mov    (%rax),%rax
  80082c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800830:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800834:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  80083a:	48 c1 e8 0c          	shr    $0xc,%rax
  80083e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;
	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800842:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800849:	0f 
  80084a:	76 0b                	jbe    800857 <bc_pgfault+0x3e>
  80084c:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800851:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800855:	76 4b                	jbe    8008a2 <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800857:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80085b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80085f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800863:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  80086a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80086e:	49 89 c9             	mov    %rcx,%r9
  800871:	49 89 d0             	mov    %rdx,%r8
  800874:	48 89 c1             	mov    %rax,%rcx
  800877:	48 ba 58 82 80 00 00 	movabs $0x808258,%rdx
  80087e:	00 00 00 
  800881:	be 50 00 00 00       	mov    $0x50,%esi
  800886:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  80088d:	00 00 00 
  800890:	b8 00 00 00 00       	mov    $0x0,%eax
  800895:	49 ba 4c 45 80 00 00 	movabs $0x80454c,%r10
  80089c:	00 00 00 
  80089f:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8008a2:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  8008a9:	00 00 00 
  8008ac:	48 8b 00             	mov    (%rax),%rax
  8008af:	48 85 c0             	test   %rax,%rax
  8008b2:	74 4a                	je     8008fe <bc_pgfault+0xe5>
  8008b4:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  8008bb:	00 00 00 
  8008be:	48 8b 00             	mov    (%rax),%rax
  8008c1:	8b 40 04             	mov    0x4(%rax),%eax
  8008c4:	89 c0                	mov    %eax,%eax
  8008c6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8008ca:	77 32                	ja     8008fe <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8008cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008d0:	48 89 c1             	mov    %rax,%rcx
  8008d3:	48 ba 88 82 80 00 00 	movabs $0x808288,%rdx
  8008da:	00 00 00 
  8008dd:	be 54 00 00 00       	mov    $0x54,%esi
  8008e2:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  8008e9:	00 00 00 
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f1:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8008f8:	00 00 00 
  8008fb:	41 ff d0             	callq  *%r8
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: you code here:

    	void *pgva=ROUNDDOWN(addr,PGSIZE);
  8008fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800902:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800910:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
        if((r = sys_page_alloc(0, pgva, PTE_U | PTE_P | PTE_W)) < 0)
  800914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800918:	ba 07 00 00 00       	mov    $0x7,%edx
  80091d:	48 89 c6             	mov    %rax,%rsi
  800920:	bf 00 00 00 00       	mov    $0x0,%edi
  800925:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  80092c:	00 00 00 
  80092f:	ff d0                	callq  *%rax
  800931:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800934:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800938:	79 2a                	jns    800964 <bc_pgfault+0x14b>
                panic("bc_pgfault:sys_page_alloc failed");
  80093a:	48 ba b0 82 80 00 00 	movabs $0x8082b0,%rdx
  800941:	00 00 00 
  800944:	be 5e 00 00 00       	mov    $0x5e,%esi
  800949:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800950:	00 00 00 
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
  800958:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  80095f:	00 00 00 
  800962:	ff d1                	callq  *%rcx
        uint32_t sectno=blockno*BLKSECTS;
  800964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800968:	c1 e0 03             	shl    $0x3,%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%rbp)
        if((r = ide_read(sectno, pgva, BLKSECTS)) < 0)
  80096e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800972:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800975:	ba 08 00 00 00       	mov    $0x8,%edx
  80097a:	48 89 ce             	mov    %rcx,%rsi
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	48 b8 b1 01 80 00 00 	movabs $0x8001b1,%rax
  800986:	00 00 00 
  800989:	ff d0                	callq  *%rax
  80098b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80098e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800992:	79 2a                	jns    8009be <bc_pgfault+0x1a5>
                panic("bc_pgfault:ide_read failed");
  800994:	48 ba d1 82 80 00 00 	movabs $0x8082d1,%rdx
  80099b:	00 00 00 
  80099e:	be 61 00 00 00       	mov    $0x61,%esi
  8009a3:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  8009aa:	00 00 00 
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b2:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  8009b9:	00 00 00 
  8009bc:	ff d1                	callq  *%rcx
	if ((r = sys_page_map(0, pgva, 0, pgva, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8009be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009c2:	48 89 c2             	mov    %rax,%rdx
  8009c5:	48 c1 ea 0c          	shr    $0xc,%rdx
  8009c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009d0:	01 00 00 
  8009d3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009d7:	89 c1                	mov    %eax,%ecx
  8009d9:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8009df:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009e7:	41 89 c8             	mov    %ecx,%r8d
  8009ea:	48 89 d1             	mov    %rdx,%rcx
  8009ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f2:	48 89 c6             	mov    %rax,%rsi
  8009f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fa:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  800a01:	00 00 00 
  800a04:	ff d0                	callq  *%rax
  800a06:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a09:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0d:	79 30                	jns    800a3f <bc_pgfault+0x226>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800a0f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a12:	89 c1                	mov    %eax,%ecx
  800a14:	48 ba f0 82 80 00 00 	movabs $0x8082f0,%rdx
  800a1b:	00 00 00 
  800a1e:	be 63 00 00 00       	mov    $0x63,%esi
  800a23:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800a2a:	00 00 00 
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a32:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800a39:	00 00 00 
  800a3c:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	//cprintf("blockisfree:%d\n",block_is_free(blockno));
	if (bitmap && block_is_free(blockno))
  800a3f:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  800a46:	00 00 00 
  800a49:	48 8b 00             	mov    (%rax),%rax
  800a4c:	48 85 c0             	test   %rax,%rax
  800a4f:	74 48                	je     800a99 <bc_pgfault+0x280>
  800a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a55:	89 c7                	mov    %eax,%edi
  800a57:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  800a5e:	00 00 00 
  800a61:	ff d0                	callq  *%rax
  800a63:	84 c0                	test   %al,%al
  800a65:	74 32                	je     800a99 <bc_pgfault+0x280>
		panic("reading free block %08x\n", blockno);
  800a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6b:	48 89 c1             	mov    %rax,%rcx
  800a6e:	48 ba 10 83 80 00 00 	movabs $0x808310,%rdx
  800a75:	00 00 00 
  800a78:	be 6b 00 00 00       	mov    $0x6b,%esi
  800a7d:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800a84:	00 00 00 
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8c:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800a93:	00 00 00 
  800a96:	41 ff d0             	callq  *%r8

	block_cache_count++;
  800a99:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  800aa0:	00 00 00 
  800aa3:	8b 00                	mov    (%rax),%eax
  800aa5:	8d 50 01             	lea    0x1(%rax),%edx
  800aa8:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  800aaf:	00 00 00 
  800ab2:	89 10                	mov    %edx,(%rax)
	//cprintf("\nInside block cache\tcount:%d\n", block_cache_count);
	if(block_cache_count >= MAX_BLOCK_CACHE_SIZE)
  800ab4:	48 b8 0c 40 81 00 00 	movabs $0x81400c,%rax
  800abb:	00 00 00 
  800abe:	8b 00                	mov    (%rax),%eax
  800ac0:	3d f8 00 00 00       	cmp    $0xf8,%eax
  800ac5:	7e 0c                	jle    800ad3 <bc_pgfault+0x2ba>
		eviction_policy();
  800ac7:	48 b8 5b 05 80 00 00 	movabs $0x80055b,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
}
  800ad3:	c9                   	leaveq 
  800ad4:	c3                   	retq   

0000000000800ad5 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800ad5:	55                   	push   %rbp
  800ad6:	48 89 e5             	mov    %rsp,%rbp
  800ad9:	48 83 ec 30          	sub    $0x30,%rsp
  800add:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800ae1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800ae5:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800aeb:	48 c1 e8 0c          	shr    $0xc,%rax
  800aef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800af3:	48 81 7d d8 ff ff ff 	cmpq   $0xfffffff,-0x28(%rbp)
  800afa:	0f 
  800afb:	76 0b                	jbe    800b08 <flush_block+0x33>
  800afd:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800b02:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800b06:	76 32                	jbe    800b3a <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  800b08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b0c:	48 89 c1             	mov    %rax,%rcx
  800b0f:	48 ba 29 83 80 00 00 	movabs $0x808329,%rdx
  800b16:	00 00 00 
  800b19:	be 81 00 00 00       	mov    $0x81,%esi
  800b1e:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800b25:	00 00 00 
  800b28:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2d:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800b34:	00 00 00 
  800b37:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.
	void *pgva=(void *) ROUNDDOWN(addr,PGSIZE);
  800b3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800b3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b46:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800b4c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        if((va_is_dirty(pgva)==0) || (va_is_mapped(pgva)==0))
  800b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b54:	48 89 c7             	mov    %rax,%rdi
  800b57:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800b5e:	00 00 00 
  800b61:	ff d0                	callq  *%rax
  800b63:	83 f0 01             	xor    $0x1,%eax
  800b66:	84 c0                	test   %al,%al
  800b68:	0f 85 f9 00 00 00    	jne    800c67 <flush_block+0x192>
  800b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b72:	48 89 c7             	mov    %rax,%rdi
  800b75:	48 b8 4f 07 80 00 00 	movabs $0x80074f,%rax
  800b7c:	00 00 00 
  800b7f:	ff d0                	callq  *%rax
  800b81:	83 f0 01             	xor    $0x1,%eax
  800b84:	84 c0                	test   %al,%al
  800b86:	0f 85 db 00 00 00    	jne    800c67 <flush_block+0x192>
		return;                  
	uint32_t sectno=blockno*BLKSECTS;
  800b8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800b90:	c1 e0 03             	shl    $0x3,%eax
  800b93:	89 45 e4             	mov    %eax,-0x1c(%rbp)
        if((r = ide_write(sectno, pgva, BLKSECTS)) < 0)
  800b96:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b9a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800b9d:	ba 08 00 00 00       	mov    $0x8,%edx
  800ba2:	48 89 ce             	mov    %rcx,%rsi
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	48 b8 46 03 80 00 00 	movabs $0x800346,%rax
  800bae:	00 00 00 
  800bb1:	ff d0                	callq  *%rax
  800bb3:	89 45 e0             	mov    %eax,-0x20(%rbp)
  800bb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800bba:	79 2a                	jns    800be6 <flush_block+0x111>
                panic("flush_block:ide_write failed");
  800bbc:	48 ba 44 83 80 00 00 	movabs $0x808344,%rdx
  800bc3:	00 00 00 
  800bc6:	be 89 00 00 00       	mov    $0x89,%esi
  800bcb:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800bd2:	00 00 00 
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bda:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  800be1:	00 00 00 
  800be4:	ff d1                	callq  *%rcx
	if ((r = sys_page_map(0, pgva, 0, pgva,  uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800be6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800bea:	48 89 c2             	mov    %rax,%rdx
  800bed:	48 c1 ea 0c          	shr    $0xc,%rdx
  800bf1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800bf8:	01 00 00 
  800bfb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800bff:	89 c1                	mov    %eax,%ecx
  800c01:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  800c07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0f:	41 89 c8             	mov    %ecx,%r8d
  800c12:	48 89 d1             	mov    %rdx,%rcx
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	48 89 c6             	mov    %rax,%rsi
  800c1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c22:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  800c29:	00 00 00 
  800c2c:	ff d0                	callq  *%rax
  800c2e:	89 45 e0             	mov    %eax,-0x20(%rbp)
  800c31:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c35:	79 31                	jns    800c68 <flush_block+0x193>
                panic("in flush_block, sys_page_map: %e", r);
  800c37:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c3a:	89 c1                	mov    %eax,%ecx
  800c3c:	48 ba 68 83 80 00 00 	movabs $0x808368,%rdx
  800c43:	00 00 00 
  800c46:	be 8b 00 00 00       	mov    $0x8b,%esi
  800c4b:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800c52:	00 00 00 
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5a:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800c61:	00 00 00 
  800c64:	41 ff d0             	callq  *%r8
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	void *pgva=(void *) ROUNDDOWN(addr,PGSIZE);
        if((va_is_dirty(pgva)==0) || (va_is_mapped(pgva)==0))
		return;                  
  800c67:	90                   	nop
                panic("flush_block:ide_write failed");
	if ((r = sys_page_map(0, pgva, 0, pgva,  uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
                panic("in flush_block, sys_page_map: %e", r);


}
  800c68:	c9                   	leaveq 
  800c69:	c3                   	retq   

0000000000800c6a <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800c6a:	55                   	push   %rbp
  800c6b:	48 89 e5             	mov    %rsp,%rbp
  800c6e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800c75:	bf 01 00 00 00       	mov    $0x1,%edi
  800c7a:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
  800c86:	48 89 c1             	mov    %rax,%rcx
  800c89:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800c90:	ba 08 01 00 00       	mov    $0x108,%edx
  800c95:	48 89 ce             	mov    %rcx,%rsi
  800c98:	48 89 c7             	mov    %rax,%rdi
  800c9b:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  800ca2:	00 00 00 
  800ca5:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  800ca7:	bf 01 00 00 00       	mov    $0x1,%edi
  800cac:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
  800cb8:	48 be 89 83 80 00 00 	movabs $0x808389,%rsi
  800cbf:	00 00 00 
  800cc2:	48 89 c7             	mov    %rax,%rdi
  800cc5:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800cd1:	bf 01 00 00 00       	mov    $0x1,%edi
  800cd6:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	48 89 c7             	mov    %rax,%rdi
  800ce5:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  800cec:	00 00 00 
  800cef:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800cf1:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf6:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800cfd:	00 00 00 
  800d00:	ff d0                	callq  *%rax
  800d02:	48 89 c7             	mov    %rax,%rdi
  800d05:	48 b8 4f 07 80 00 00 	movabs $0x80074f,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
  800d11:	83 f0 01             	xor    $0x1,%eax
  800d14:	84 c0                	test   %al,%al
  800d16:	74 35                	je     800d4d <check_bc+0xe3>
  800d18:	48 b9 90 83 80 00 00 	movabs $0x808390,%rcx
  800d1f:	00 00 00 
  800d22:	48 ba aa 83 80 00 00 	movabs $0x8083aa,%rdx
  800d29:	00 00 00 
  800d2c:	be 9d 00 00 00       	mov    $0x9d,%esi
  800d31:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800d38:	00 00 00 
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800d47:	00 00 00 
  800d4a:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800d4d:	bf 01 00 00 00       	mov    $0x1,%edi
  800d52:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800d59:	00 00 00 
  800d5c:	ff d0                	callq  *%rax
  800d5e:	48 89 c7             	mov    %rax,%rdi
  800d61:	48 b8 e9 07 80 00 00 	movabs $0x8007e9,%rax
  800d68:	00 00 00 
  800d6b:	ff d0                	callq  *%rax
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 35                	je     800da6 <check_bc+0x13c>
  800d71:	48 b9 bf 83 80 00 00 	movabs $0x8083bf,%rcx
  800d78:	00 00 00 
  800d7b:	48 ba aa 83 80 00 00 	movabs $0x8083aa,%rdx
  800d82:	00 00 00 
  800d85:	be 9e 00 00 00       	mov    $0x9e,%esi
  800d8a:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800d91:	00 00 00 
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800da0:	00 00 00 
  800da3:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800da6:	bf 01 00 00 00       	mov    $0x1,%edi
  800dab:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800db2:	00 00 00 
  800db5:	ff d0                	callq  *%rax
  800db7:	48 89 c6             	mov    %rax,%rsi
  800dba:	bf 00 00 00 00       	mov    $0x0,%edi
  800dbf:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800dcb:	bf 01 00 00 00       	mov    $0x1,%edi
  800dd0:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800dd7:	00 00 00 
  800dda:	ff d0                	callq  *%rax
  800ddc:	48 89 c7             	mov    %rax,%rdi
  800ddf:	48 b8 4f 07 80 00 00 	movabs $0x80074f,%rax
  800de6:	00 00 00 
  800de9:	ff d0                	callq  *%rax
  800deb:	84 c0                	test   %al,%al
  800ded:	74 35                	je     800e24 <check_bc+0x1ba>
  800def:	48 b9 d9 83 80 00 00 	movabs $0x8083d9,%rcx
  800df6:	00 00 00 
  800df9:	48 ba aa 83 80 00 00 	movabs $0x8083aa,%rdx
  800e00:	00 00 00 
  800e03:	be a2 00 00 00       	mov    $0xa2,%esi
  800e08:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800e0f:	00 00 00 
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
  800e17:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800e1e:	00 00 00 
  800e21:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800e24:	bf 01 00 00 00       	mov    $0x1,%edi
  800e29:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800e30:	00 00 00 
  800e33:	ff d0                	callq  *%rax
  800e35:	48 be 89 83 80 00 00 	movabs $0x808389,%rsi
  800e3c:	00 00 00 
  800e3f:	48 89 c7             	mov    %rax,%rdi
  800e42:	48 b8 9f 54 80 00 00 	movabs $0x80549f,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	callq  *%rax
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	74 35                	je     800e87 <check_bc+0x21d>
  800e52:	48 b9 f8 83 80 00 00 	movabs $0x8083f8,%rcx
  800e59:	00 00 00 
  800e5c:	48 ba aa 83 80 00 00 	movabs $0x8083aa,%rdx
  800e63:	00 00 00 
  800e66:	be a5 00 00 00       	mov    $0xa5,%esi
  800e6b:	48 bf ba 81 80 00 00 	movabs $0x8081ba,%rdi
  800e72:	00 00 00 
  800e75:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7a:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  800e81:	00 00 00 
  800e84:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800e87:	bf 01 00 00 00       	mov    $0x1,%edi
  800e8c:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800e93:	00 00 00 
  800e96:	ff d0                	callq  *%rax
  800e98:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800e9f:	ba 08 01 00 00       	mov    $0x108,%edx
  800ea4:	48 89 ce             	mov    %rcx,%rsi
  800ea7:	48 89 c7             	mov    %rax,%rdi
  800eaa:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800eb6:	bf 01 00 00 00       	mov    $0x1,%edi
  800ebb:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800ec2:	00 00 00 
  800ec5:	ff d0                	callq  *%rax
  800ec7:	48 89 c7             	mov    %rax,%rdi
  800eca:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  800ed1:	00 00 00 
  800ed4:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800ed6:	48 bf 1c 84 80 00 00 	movabs $0x80841c,%rdi
  800edd:	00 00 00 
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  800eec:	00 00 00 
  800eef:	ff d2                	callq  *%rdx
}
  800ef1:	c9                   	leaveq 
  800ef2:	c3                   	retq   

0000000000800ef3 <bc_init>:

void
bc_init(void)
{
  800ef3:	55                   	push   %rbp
  800ef4:	48 89 e5             	mov    %rsp,%rbp
  800ef7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800efe:	48 bf 19 08 80 00 00 	movabs $0x800819,%rdi
  800f05:	00 00 00 
  800f08:	48 b8 bc 5f 80 00 00 	movabs $0x805fbc,%rax
  800f0f:	00 00 00 
  800f12:	ff d0                	callq  *%rax
	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800f14:	bf 01 00 00 00       	mov    $0x1,%edi
  800f19:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  800f20:	00 00 00 
  800f23:	ff d0                	callq  *%rax
  800f25:	48 89 c1             	mov    %rax,%rcx
  800f28:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f2f:	ba 08 01 00 00       	mov    $0x108,%edx
  800f34:	48 89 ce             	mov    %rcx,%rsi
  800f37:	48 89 c7             	mov    %rax,%rdi
  800f3a:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  800f41:	00 00 00 
  800f44:	ff d0                	callq  *%rax



}
  800f46:	c9                   	leaveq 
  800f47:	c3                   	retq   

0000000000800f48 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800f48:	55                   	push   %rbp
  800f49:	48 89 e5             	mov    %rsp,%rbp
  800f4c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
	if (super->s_magic != FS_MAGIC)
  800f53:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  800f5a:	00 00 00 
  800f5d:	48 8b 00             	mov    (%rax),%rax
  800f60:	8b 00                	mov    (%rax),%eax
  800f62:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800f67:	74 2a                	je     800f93 <check_super+0x4b>
		panic("bad file system magic number");
  800f69:	48 ba 38 84 80 00 00 	movabs $0x808438,%rdx
  800f70:	00 00 00 
  800f73:	be 0e 00 00 00       	mov    $0xe,%esi
  800f78:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  800f7f:	00 00 00 
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
  800f87:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  800f8e:	00 00 00 
  800f91:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800f93:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  800f9a:	00 00 00 
  800f9d:	48 8b 00             	mov    (%rax),%rax
  800fa0:	8b 40 04             	mov    0x4(%rax),%eax
  800fa3:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800fa8:	76 2a                	jbe    800fd4 <check_super+0x8c>
		panic("file system is too large");
  800faa:	48 ba 5d 84 80 00 00 	movabs $0x80845d,%rdx
  800fb1:	00 00 00 
  800fb4:	be 11 00 00 00       	mov    $0x11,%esi
  800fb9:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  800fc0:	00 00 00 
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc8:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  800fcf:	00 00 00 
  800fd2:	ff d1                	callq  *%rcx

	check_root_dir(super->s_root);	
  800fd4:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  800fdb:	00 00 00 
  800fde:	48 8b 00             	mov    (%rax),%rax
  800fe1:	48 89 e2             	mov    %rsp,%rdx
  800fe4:	48 8d 70 08          	lea    0x8(%rax),%rsi
  800fe8:	b8 20 00 00 00       	mov    $0x20,%eax
  800fed:	48 89 d7             	mov    %rdx,%rdi
  800ff0:	48 89 c1             	mov    %rax,%rcx
  800ff3:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  800ff6:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  800ffd:	00 00 00 
  801000:	ff d0                	callq  *%rax

	//cprintf("Number of blocks in FS:%d\n",super->s_nblocks);
	cprintf("Superblock is good\n");
  801002:	48 bf 76 84 80 00 00 	movabs $0x808476,%rdi
  801009:	00 00 00 
  80100c:	b8 00 00 00 00       	mov    $0x0,%eax
  801011:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801018:	00 00 00 
  80101b:	ff d2                	callq  *%rdx
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <check_root_dir>:

void check_root_dir(struct File f)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
	int i, j;
	struct File rootdir = f;
  80102a:	48 8d 95 e0 fe ff ff 	lea    -0x120(%rbp),%rdx
  801031:	48 8d 75 10          	lea    0x10(%rbp),%rsi
  801035:	b8 20 00 00 00       	mov    $0x20,%eax
  80103a:	48 89 d7             	mov    %rdx,%rdi
  80103d:	48 89 c1             	mov    %rax,%rcx
  801040:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	cprintf("Checking root directory files...\n");
  801043:	48 bf 90 84 80 00 00 	movabs $0x808490,%rdi
  80104a:	00 00 00 
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801059:	00 00 00 
  80105c:	ff d2                	callq  *%rdx
	cprintf("name:%s\tsize:%d\ttype:%d\n", rootdir.f_name, rootdir.f_size, rootdir.f_type);
  80105e:	8b 8d 64 ff ff ff    	mov    -0x9c(%rbp),%ecx
  801064:	8b 95 60 ff ff ff    	mov    -0xa0(%rbp),%edx
  80106a:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
  801071:	48 89 c6             	mov    %rax,%rsi
  801074:	48 bf b2 84 80 00 00 	movabs $0x8084b2,%rdi
  80107b:	00 00 00 
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
  801083:	49 b8 87 47 80 00 00 	movabs $0x804787,%r8
  80108a:	00 00 00 
  80108d:	41 ff d0             	callq  *%r8
	if(rootdir.f_type == FTYPE_DIR){
  801090:	8b 85 64 ff ff ff    	mov    -0x9c(%rbp),%eax
  801096:	83 f8 01             	cmp    $0x1,%eax
  801099:	0f 85 62 01 00 00    	jne    801201 <check_root_dir+0x1e2>
	for(i=0; i<NDIRECT; i++)
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a6:	e9 4c 01 00 00       	jmpq   8011f7 <check_root_dir+0x1d8>
	{
		//cprintf("direct block pointer %d :%08x\n", i, rootdir.f_direct[i]);		
		if(rootdir.f_direct[i] != 0)
  8010ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ae:	48 98                	cltq   
  8010b0:	48 83 c0 20          	add    $0x20,%rax
  8010b4:	8b 84 85 e8 fe ff ff 	mov    -0x118(%rbp,%rax,4),%eax
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	0f 84 30 01 00 00    	je     8011f3 <check_root_dir+0x1d4>
		{
			assert(rootdir.f_direct[i]!=1);
  8010c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c6:	48 98                	cltq   
  8010c8:	48 83 c0 20          	add    $0x20,%rax
  8010cc:	8b 84 85 e8 fe ff ff 	mov    -0x118(%rbp,%rax,4),%eax
  8010d3:	83 f8 01             	cmp    $0x1,%eax
  8010d6:	75 35                	jne    80110d <check_root_dir+0xee>
  8010d8:	48 b9 cb 84 80 00 00 	movabs $0x8084cb,%rcx
  8010df:	00 00 00 
  8010e2:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8010e9:	00 00 00 
  8010ec:	be 25 00 00 00       	mov    $0x25,%esi
  8010f1:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8010f8:	00 00 00 
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  801107:	00 00 00 
  80110a:	41 ff d0             	callq  *%r8
			assert(rootdir.f_direct[i]<JOURNALSTARTBLOCK || rootdir.f_direct[i]>JOURNALSTARTBLOCK+MAXJOURNALS);
  80110d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801110:	48 98                	cltq   
  801112:	48 83 c0 20          	add    $0x20,%rax
  801116:	8b 84 85 e8 fe ff ff 	mov    -0x118(%rbp,%rax,4),%eax
  80111d:	3d 87 13 00 00       	cmp    $0x1387,%eax
  801122:	76 4c                	jbe    801170 <check_root_dir+0x151>
  801124:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801127:	48 98                	cltq   
  801129:	48 83 c0 20          	add    $0x20,%rax
  80112d:	8b 84 85 e8 fe ff ff 	mov    -0x118(%rbp,%rax,4),%eax
  801134:	3d 7c 15 00 00       	cmp    $0x157c,%eax
  801139:	77 35                	ja     801170 <check_root_dir+0x151>
  80113b:	48 b9 f8 84 80 00 00 	movabs $0x8084f8,%rcx
  801142:	00 00 00 
  801145:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  80114c:	00 00 00 
  80114f:	be 26 00 00 00       	mov    $0x26,%esi
  801154:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  80115b:	00 00 00 
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80116a:	00 00 00 
  80116d:	41 ff d0             	callq  *%r8
			
			struct File * rootdirfile = (struct File *)(diskaddr(rootdir.f_direct[i]));
  801170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801173:	48 98                	cltq   
  801175:	48 83 c0 20          	add    $0x20,%rax
  801179:	8b 84 85 e8 fe ff ff 	mov    -0x118(%rbp,%rax,4),%eax
  801180:	89 c0                	mov    %eax,%eax
  801182:	48 89 c7             	mov    %rax,%rdi
  801185:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  80118c:	00 00 00 
  80118f:	ff d0                	callq  *%rax
  801191:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			int sizeSum = 0;
  801195:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
			while(sizeSum < rootdir.f_size)
  80119c:	eb 4a                	jmp    8011e8 <check_root_dir+0x1c9>
			{
				cprintf("\tname:%s\tsize:%d\ttype:%d\n", rootdirfile->f_name, rootdirfile->f_size, rootdirfile->f_type);
  80119e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a2:	8b 88 84 00 00 00    	mov    0x84(%rax),%ecx
  8011a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ac:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8011b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b6:	48 89 c6             	mov    %rax,%rsi
  8011b9:	48 bf 53 85 80 00 00 	movabs $0x808553,%rdi
  8011c0:	00 00 00 
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	49 b8 87 47 80 00 00 	movabs $0x804787,%r8
  8011cf:	00 00 00 
  8011d2:	41 ff d0             	callq  *%r8
				sizeSum += sizeof(struct File);
  8011d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011d8:	05 00 01 00 00       	add    $0x100,%eax
  8011dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
				rootdirfile++;
  8011e0:	48 81 45 f0 00 01 00 	addq   $0x100,-0x10(%rbp)
  8011e7:	00 
			assert(rootdir.f_direct[i]!=1);
			assert(rootdir.f_direct[i]<JOURNALSTARTBLOCK || rootdir.f_direct[i]>JOURNALSTARTBLOCK+MAXJOURNALS);
			
			struct File * rootdirfile = (struct File *)(diskaddr(rootdir.f_direct[i]));
			int sizeSum = 0;
			while(sizeSum < rootdir.f_size)
  8011e8:	8b 85 60 ff ff ff    	mov    -0xa0(%rbp),%eax
  8011ee:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8011f1:	7f ab                	jg     80119e <check_root_dir+0x17f>
	int i, j;
	struct File rootdir = f;
	cprintf("Checking root directory files...\n");
	cprintf("name:%s\tsize:%d\ttype:%d\n", rootdir.f_name, rootdir.f_size, rootdir.f_type);
	if(rootdir.f_type == FTYPE_DIR){
	for(i=0; i<NDIRECT; i++)
  8011f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8011f7:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  8011fb:	0f 8e aa fe ff ff    	jle    8010ab <check_root_dir+0x8c>
			}
		}
	}
	}
	//cprintf("indirect block pointer:%08x\n", rootdir.f_indirect);
	if(rootdir.f_indirect != 0)
  801201:	8b 45 90             	mov    -0x70(%rbp),%eax
  801204:	85 c0                	test   %eax,%eax
  801206:	74 18                	je     801220 <check_root_dir+0x201>
	{
		struct File *indir_block = (struct File *)(diskaddr(rootdir.f_indirect));
  801208:	8b 45 90             	mov    -0x70(%rbp),%eax
  80120b:	89 c0                	mov    %eax,%eax
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  801217:	00 00 00 
  80121a:	ff d0                	callq  *%rax
  80121c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		//check_root_dir(*indir_block, level+1);			
	}
	cprintf("Root directory files are good\n");
  801220:	48 bf 70 85 80 00 00 	movabs $0x808570,%rdi
  801227:	00 00 00 
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801236:	00 00 00 
  801239:	ff d2                	callq  *%rdx
}
  80123b:	c9                   	leaveq 
  80123c:	c3                   	retq   

000000000080123d <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  80123d:	55                   	push   %rbp
  80123e:	48 89 e5             	mov    %rsp,%rbp
  801241:	53                   	push   %rbx
  801242:	48 83 ec 08          	sub    $0x8,%rsp
  801246:	89 7d f4             	mov    %edi,-0xc(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  801249:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  801250:	00 00 00 
  801253:	48 8b 00             	mov    (%rax),%rax
  801256:	48 85 c0             	test   %rax,%rax
  801259:	74 15                	je     801270 <block_is_free+0x33>
  80125b:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  801262:	00 00 00 
  801265:	48 8b 00             	mov    (%rax),%rax
  801268:	8b 40 04             	mov    0x4(%rax),%eax
  80126b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80126e:	77 07                	ja     801277 <block_is_free+0x3a>
		return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 43                	jmp    8012ba <block_is_free+0x7d>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  801277:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  80127e:	00 00 00 
  801281:	48 8b 00             	mov    (%rax),%rax
  801284:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801287:	c1 ea 05             	shr    $0x5,%edx
  80128a:	89 d2                	mov    %edx,%edx
  80128c:	48 c1 e2 02          	shl    $0x2,%rdx
  801290:	48 01 d0             	add    %rdx,%rax
  801293:	8b 10                	mov    (%rax),%edx
  801295:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801298:	83 e0 1f             	and    $0x1f,%eax
  80129b:	be 01 00 00 00       	mov    $0x1,%esi
  8012a0:	89 f3                	mov    %esi,%ebx
  8012a2:	89 c1                	mov    %eax,%ecx
  8012a4:	d3 e3                	shl    %cl,%ebx
  8012a6:	89 d8                	mov    %ebx,%eax
  8012a8:	21 d0                	and    %edx,%eax
  8012aa:	85 c0                	test   %eax,%eax
  8012ac:	74 07                	je     8012b5 <block_is_free+0x78>
		return 1;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8012b3:	eb 05                	jmp    8012ba <block_is_free+0x7d>
	return 0;
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ba:	48 83 c4 08          	add    $0x8,%rsp
  8012be:	5b                   	pop    %rbx
  8012bf:	5d                   	pop    %rbp
  8012c0:	c3                   	retq   

00000000008012c1 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8012c1:	55                   	push   %rbp
  8012c2:	48 89 e5             	mov    %rsp,%rbp
  8012c5:	53                   	push   %rbx
  8012c6:	48 83 ec 18          	sub    $0x18,%rsp
  8012ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8012cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8012d1:	75 2a                	jne    8012fd <free_block+0x3c>
		panic("attempt to free zero block");
  8012d3:	48 ba 8f 85 80 00 00 	movabs $0x80858f,%rdx
  8012da:	00 00 00 
  8012dd:	be 54 00 00 00       	mov    $0x54,%esi
  8012e2:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8012e9:	00 00 00 
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  8012f8:	00 00 00 
  8012fb:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  8012fd:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  801304:	00 00 00 
  801307:	48 8b 10             	mov    (%rax),%rdx
  80130a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80130d:	c1 e8 05             	shr    $0x5,%eax
  801310:	89 c1                	mov    %eax,%ecx
  801312:	48 c1 e1 02          	shl    $0x2,%rcx
  801316:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  80131a:	48 ba 68 40 81 00 00 	movabs $0x814068,%rdx
  801321:	00 00 00 
  801324:	48 8b 12             	mov    (%rdx),%rdx
  801327:	89 c0                	mov    %eax,%eax
  801329:	48 c1 e0 02          	shl    $0x2,%rax
  80132d:	48 01 d0             	add    %rdx,%rax
  801330:	8b 10                	mov    (%rax),%edx
  801332:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801335:	83 e0 1f             	and    $0x1f,%eax
  801338:	bf 01 00 00 00       	mov    $0x1,%edi
  80133d:	89 fb                	mov    %edi,%ebx
  80133f:	89 c1                	mov    %eax,%ecx
  801341:	d3 e3                	shl    %cl,%ebx
  801343:	89 d8                	mov    %ebx,%eax
  801345:	09 d0                	or     %edx,%eax
  801347:	89 06                	mov    %eax,(%rsi)
}
  801349:	48 83 c4 18          	add    $0x18,%rsp
  80134d:	5b                   	pop    %rbx
  80134e:	5d                   	pop    %rbp
  80134f:	c3                   	retq   

0000000000801350 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  801350:	55                   	push   %rbp
  801351:	48 89 e5             	mov    %rsp,%rbp
  801354:	53                   	push   %rbx
  801355:	48 83 ec 18          	sub    $0x18,%rsp
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.

	int i;
        i=1;
  801359:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
        while(i< super->s_nblocks)
  801360:	e9 a5 00 00 00       	jmpq   80140a <alloc_block+0xba>
        {
                if(block_is_free(i)==1)
  801365:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801368:	89 c7                	mov    %eax,%edi
  80136a:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  801371:	00 00 00 
  801374:	ff d0                	callq  *%rax
  801376:	84 c0                	test   %al,%al
  801378:	0f 84 88 00 00 00    	je     801406 <alloc_block+0xb6>
                {
                        bitmap[i/32] &= ~(1<<(i%32));
  80137e:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  801385:	00 00 00 
  801388:	48 8b 10             	mov    (%rax),%rdx
  80138b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80138e:	8d 48 1f             	lea    0x1f(%rax),%ecx
  801391:	85 c0                	test   %eax,%eax
  801393:	0f 48 c1             	cmovs  %ecx,%eax
  801396:	c1 f8 05             	sar    $0x5,%eax
  801399:	48 63 c8             	movslq %eax,%rcx
  80139c:	48 c1 e1 02          	shl    $0x2,%rcx
  8013a0:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  8013a4:	48 ba 68 40 81 00 00 	movabs $0x814068,%rdx
  8013ab:	00 00 00 
  8013ae:	48 8b 12             	mov    (%rdx),%rdx
  8013b1:	48 98                	cltq   
  8013b3:	48 c1 e0 02          	shl    $0x2,%rax
  8013b7:	48 01 d0             	add    %rdx,%rax
  8013ba:	8b 38                	mov    (%rax),%edi
  8013bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8013bf:	89 c2                	mov    %eax,%edx
  8013c1:	c1 fa 1f             	sar    $0x1f,%edx
  8013c4:	c1 ea 1b             	shr    $0x1b,%edx
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	83 e0 1f             	and    $0x1f,%eax
  8013cc:	29 d0                	sub    %edx,%eax
  8013ce:	ba 01 00 00 00       	mov    $0x1,%edx
  8013d3:	89 d3                	mov    %edx,%ebx
  8013d5:	89 c1                	mov    %eax,%ecx
  8013d7:	d3 e3                	shl    %cl,%ebx
  8013d9:	89 d8                	mov    %ebx,%eax
  8013db:	f7 d0                	not    %eax
  8013dd:	21 f8                	and    %edi,%eax
  8013df:	89 06                	mov    %eax,(%rsi)
                        flush_block(diskaddr(2));
  8013e1:	bf 02 00 00 00       	mov    $0x2,%edi
  8013e6:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8013ed:	00 00 00 
  8013f0:	ff d0                	callq  *%rax
  8013f2:	48 89 c7             	mov    %rax,%rdi
  8013f5:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  8013fc:	00 00 00 
  8013ff:	ff d0                	callq  *%rax
                        return i;
  801401:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801404:	eb 24                	jmp    80142a <alloc_block+0xda>
                }

                i++;
  801406:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)

	// LAB 5: Your code here.

	int i;
        i=1;
        while(i< super->s_nblocks)
  80140a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80140d:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  801414:	00 00 00 
  801417:	48 8b 00             	mov    (%rax),%rax
  80141a:	8b 40 04             	mov    0x4(%rax),%eax
  80141d:	39 c2                	cmp    %eax,%edx
  80141f:	0f 82 40 ff ff ff    	jb     801365 <alloc_block+0x15>
                }

                i++;
        }

	return -E_NO_DISK;
  801425:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax


}	
  80142a:	48 83 c4 18          	add    $0x18,%rsp
  80142e:	5b                   	pop    %rbx
  80142f:	5d                   	pop    %rbp
  801430:	c3                   	retq   

0000000000801431 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  801431:	55                   	push   %rbp
  801432:	48 89 e5             	mov    %rsp,%rbp
  801435:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  801439:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801440:	eb 51                	jmp    801493 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  801442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801445:	83 c0 02             	add    $0x2,%eax
  801448:	89 c7                	mov    %eax,%edi
  80144a:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  801451:	00 00 00 
  801454:	ff d0                	callq  *%rax
  801456:	84 c0                	test   %al,%al
  801458:	74 35                	je     80148f <check_bitmap+0x5e>
  80145a:	48 b9 aa 85 80 00 00 	movabs $0x8085aa,%rcx
  801461:	00 00 00 
  801464:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  80146b:	00 00 00 
  80146e:	be 87 00 00 00       	mov    $0x87,%esi
  801473:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  80147a:	00 00 00 
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
  801482:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  801489:	00 00 00 
  80148c:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80148f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801493:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801496:	89 c2                	mov    %eax,%edx
  801498:	c1 e2 0f             	shl    $0xf,%edx
  80149b:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  8014a2:	00 00 00 
  8014a5:	48 8b 00             	mov    (%rax),%rax
  8014a8:	8b 40 04             	mov    0x4(%rax),%eax
  8014ab:	39 c2                	cmp    %eax,%edx
  8014ad:	72 93                	jb     801442 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  8014af:	bf 00 00 00 00       	mov    $0x0,%edi
  8014b4:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  8014bb:	00 00 00 
  8014be:	ff d0                	callq  *%rax
  8014c0:	84 c0                	test   %al,%al
  8014c2:	74 35                	je     8014f9 <check_bitmap+0xc8>
  8014c4:	48 b9 be 85 80 00 00 	movabs $0x8085be,%rcx
  8014cb:	00 00 00 
  8014ce:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8014d5:	00 00 00 
  8014d8:	be 8a 00 00 00       	mov    $0x8a,%esi
  8014dd:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8014e4:	00 00 00 
  8014e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ec:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8014f3:	00 00 00 
  8014f6:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  8014f9:	bf 01 00 00 00       	mov    $0x1,%edi
  8014fe:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  801505:	00 00 00 
  801508:	ff d0                	callq  *%rax
  80150a:	84 c0                	test   %al,%al
  80150c:	74 35                	je     801543 <check_bitmap+0x112>
  80150e:	48 b9 d0 85 80 00 00 	movabs $0x8085d0,%rcx
  801515:	00 00 00 
  801518:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  80151f:	00 00 00 
  801522:	be 8b 00 00 00       	mov    $0x8b,%esi
  801527:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  80152e:	00 00 00 
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
  801536:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80153d:	00 00 00 
  801540:	41 ff d0             	callq  *%r8

	cprintf("Free block bitmap is good\n");
  801543:	48 bf e2 85 80 00 00 	movabs $0x8085e2,%rdi
  80154a:	00 00 00 
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801559:	00 00 00 
  80155c:	ff d2                	callq  *%rdx
}
  80155e:	c9                   	leaveq 
  80155f:	c3                   	retq   

0000000000801560 <check_journal>:


void check_journal(void)
{
  801560:	55                   	push   %rbp
  801561:	48 89 e5             	mov    %rsp,%rbp
  801564:	48 83 ec 10          	sub    $0x10,%rsp
	int i, journal_count =get_journal_size();
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
  80156d:	48 ba fa 32 80 00 00 	movabs $0x8032fa,%rdx
  801574:	00 00 00 
  801577:	ff d2                	callq  *%rdx
  801579:	89 45 f8             	mov    %eax,-0x8(%rbp)
	cprintf("Journal record count:%d\n",journal_count);		
  80157c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80157f:	89 c6                	mov    %eax,%esi
  801581:	48 bf fd 85 80 00 00 	movabs $0x8085fd,%rdi
  801588:	00 00 00 
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
  801590:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801597:	00 00 00 
  80159a:	ff d2                	callq  *%rdx
	assert(journal_count < MAXJOURNALS);
  80159c:	81 7d f8 f3 01 00 00 	cmpl   $0x1f3,-0x8(%rbp)
  8015a3:	7e 35                	jle    8015da <check_journal+0x7a>
  8015a5:	48 b9 16 86 80 00 00 	movabs $0x808616,%rcx
  8015ac:	00 00 00 
  8015af:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8015b6:	00 00 00 
  8015b9:	be 95 00 00 00       	mov    $0x95,%esi
  8015be:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8015c5:	00 00 00 
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8015d4:	00 00 00 
  8015d7:	41 ff d0             	callq  *%r8
	
	for(i = JOURNALSTARTBLOCK; i < JOURNALSTARTBLOCK + MAXJOURNALS; i++)
  8015da:	c7 45 fc 88 13 00 00 	movl   $0x1388,-0x4(%rbp)
  8015e1:	eb 4e                	jmp    801631 <check_journal+0xd1>
		assert(!block_is_free(i));
  8015e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8015e6:	89 c7                	mov    %eax,%edi
  8015e8:	48 b8 3d 12 80 00 00 	movabs $0x80123d,%rax
  8015ef:	00 00 00 
  8015f2:	ff d0                	callq  *%rax
  8015f4:	84 c0                	test   %al,%al
  8015f6:	74 35                	je     80162d <check_journal+0xcd>
  8015f8:	48 b9 32 86 80 00 00 	movabs $0x808632,%rcx
  8015ff:	00 00 00 
  801602:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  801609:	00 00 00 
  80160c:	be 98 00 00 00       	mov    $0x98,%esi
  801611:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  801618:	00 00 00 
  80161b:	b8 00 00 00 00       	mov    $0x0,%eax
  801620:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  801627:	00 00 00 
  80162a:	41 ff d0             	callq  *%r8
{
	int i, journal_count =get_journal_size();
	cprintf("Journal record count:%d\n",journal_count);		
	assert(journal_count < MAXJOURNALS);
	
	for(i = JOURNALSTARTBLOCK; i < JOURNALSTARTBLOCK + MAXJOURNALS; i++)
  80162d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801631:	81 7d fc 7b 15 00 00 	cmpl   $0x157b,-0x4(%rbp)
  801638:	7e a9                	jle    8015e3 <check_journal+0x83>
		assert(!block_is_free(i));

	cprintf("Journal blocks are good\n");
  80163a:	48 bf 44 86 80 00 00 	movabs $0x808644,%rdi
  801641:	00 00 00 
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
  801649:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801650:	00 00 00 
  801653:	ff d2                	callq  *%rdx
}
  801655:	c9                   	leaveq 
  801656:	c3                   	retq   

0000000000801657 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  801657:	55                   	push   %rbp
  801658:	48 89 e5             	mov    %rsp,%rbp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  80165b:	48 b8 a2 00 80 00 00 	movabs $0x8000a2,%rax
  801662:	00 00 00 
  801665:	ff d0                	callq  *%rax
  801667:	84 c0                	test   %al,%al
  801669:	74 13                	je     80167e <fs_init+0x27>
		ide_set_disk(1);
  80166b:	bf 01 00 00 00       	mov    $0x1,%edi
  801670:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  801677:	00 00 00 
  80167a:	ff d0                	callq  *%rax
  80167c:	eb 11                	jmp    80168f <fs_init+0x38>
	else
		ide_set_disk(0);
  80167e:	bf 00 00 00 00       	mov    $0x0,%edi
  801683:	48 b8 5f 01 80 00 00 	movabs $0x80015f,%rax
  80168a:	00 00 00 
  80168d:	ff d0                	callq  *%rax

	bc_init();
  80168f:	48 b8 f3 0e 80 00 00 	movabs $0x800ef3,%rax
  801696:	00 00 00 
  801699:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  80169b:	bf 01 00 00 00       	mov    $0x1,%edi
  8016a0:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8016a7:	00 00 00 
  8016aa:	ff d0                	callq  *%rax
  8016ac:	48 ba 70 40 81 00 00 	movabs $0x814070,%rdx
  8016b3:	00 00 00 
  8016b6:	48 89 02             	mov    %rax,(%rdx)

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8016b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8016be:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8016c5:	00 00 00 
  8016c8:	ff d0                	callq  *%rax
  8016ca:	48 ba 68 40 81 00 00 	movabs $0x814068,%rdx
  8016d1:	00 00 00 
  8016d4:	48 89 02             	mov    %rax,(%rdx)

	//Set "journal" to point to the beginning of the first journal block
	journal = diskaddr(5000);
  8016d7:	bf 88 13 00 00       	mov    $0x1388,%edi
  8016dc:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8016e3:	00 00 00 
  8016e6:	ff d0                	callq  *%rax
  8016e8:	48 ba 78 40 81 00 00 	movabs $0x814078,%rdx
  8016ef:	00 00 00 
  8016f2:	48 89 02             	mov    %rax,(%rdx)
	
	fs_check();
  8016f5:	48 b8 14 17 80 00 00 	movabs $0x801714,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
	
	replay_journal();	
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
  801706:	48 ba 08 2e 80 00 00 	movabs $0x802e08,%rdx
  80170d:	00 00 00 
  801710:	ff d2                	callq  *%rdx
}
  801712:	5d                   	pop    %rbp
  801713:	c3                   	retq   

0000000000801714 <fs_check>:

void fs_check(void)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
	cprintf("\n\n\nStarting file system check...\n");
  801718:	48 bf 60 86 80 00 00 	movabs $0x808660,%rdi
  80171f:	00 00 00 
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  80172e:	00 00 00 
  801731:	ff d2                	callq  *%rdx
	cprintf("Checking super block...\n");
  801733:	48 bf 82 86 80 00 00 	movabs $0x808682,%rdi
  80173a:	00 00 00 
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801749:	00 00 00 
  80174c:	ff d2                	callq  *%rdx
	check_super();
  80174e:	48 b8 48 0f 80 00 00 	movabs $0x800f48,%rax
  801755:	00 00 00 
  801758:	ff d0                	callq  *%rax

	cprintf("Checking free block bitmap...\n");
  80175a:	48 bf a0 86 80 00 00 	movabs $0x8086a0,%rdi
  801761:	00 00 00 
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801770:	00 00 00 
  801773:	ff d2                	callq  *%rdx
        check_bitmap();
  801775:	48 b8 31 14 80 00 00 	movabs $0x801431,%rax
  80177c:	00 00 00 
  80177f:	ff d0                	callq  *%rax

	cprintf("Checking journal blocks...\n");
  801781:	48 bf bf 86 80 00 00 	movabs $0x8086bf,%rdi
  801788:	00 00 00 
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  801797:	00 00 00 
  80179a:	ff d2                	callq  *%rdx
        check_journal();
  80179c:	48 b8 60 15 80 00 00 	movabs $0x801560,%rax
  8017a3:	00 00 00 
  8017a6:	ff d0                	callq  *%rax

	cprintf("File system check complete...\n\n\n");
  8017a8:	48 bf e0 86 80 00 00 	movabs $0x8086e0,%rdi
  8017af:	00 00 00 
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b7:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  8017be:	00 00 00 
  8017c1:	ff d2                	callq  *%rdx

}
  8017c3:	5d                   	pop    %rbp
  8017c4:	c3                   	retq   

00000000008017c5 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  8017c5:	55                   	push   %rbp
  8017c6:	48 89 e5             	mov    %rsp,%rbp
  8017c9:	48 83 ec 40          	sub    $0x40,%rsp
  8017cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017d1:	89 75 d4             	mov    %esi,-0x2c(%rbp)
  8017d4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8017d8:	89 c8                	mov    %ecx,%eax
  8017da:	88 45 d0             	mov    %al,-0x30(%rbp)
  
	uint32_t *indirectblkptr;
        int blockno,allocated_block;
        if(filebno>=NDIRECT+NINDIRECT)
  8017dd:	81 7d d4 09 04 00 00 	cmpl   $0x409,-0x2c(%rbp)
  8017e4:	76 0a                	jbe    8017f0 <file_block_walk+0x2b>
                return -E_INVAL;
  8017e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017eb:	e9 01 01 00 00       	jmpq   8018f1 <file_block_walk+0x12c>
        if(filebno<NDIRECT)
  8017f0:	83 7d d4 09          	cmpl   $0x9,-0x2c(%rbp)
  8017f4:	77 26                	ja     80181c <file_block_walk+0x57>
        {
                *ppdiskbno=&f->f_direct[filebno];
  8017f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fa:	48 8d 90 88 00 00 00 	lea    0x88(%rax),%rdx
  801801:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801804:	48 c1 e0 02          	shl    $0x2,%rax
  801808:	48 01 c2             	add    %rax,%rdx
  80180b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80180f:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  801812:	b8 00 00 00 00       	mov    $0x0,%eax
  801817:	e9 d5 00 00 00       	jmpq   8018f1 <file_block_walk+0x12c>
        }
        else
        {
                if(f->f_indirect==0)
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801826:	85 c0                	test   %eax,%eax
  801828:	75 15                	jne    80183f <file_block_walk+0x7a>
                {
                        if(alloc == false)
  80182a:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
  80182e:	83 f0 01             	xor    $0x1,%eax
  801831:	84 c0                	test   %al,%al
  801833:	74 0a                	je     80183f <file_block_walk+0x7a>
                                return -E_NOT_FOUND;
  801835:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80183a:	e9 b2 00 00 00       	jmpq   8018f1 <file_block_walk+0x12c>
                }
                if(f->f_indirect==0)
  80183f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801843:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801849:	85 c0                	test   %eax,%eax
  80184b:	75 60                	jne    8018ad <file_block_walk+0xe8>
                {
                        allocated_block = alloc_block();
  80184d:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  801854:	00 00 00 
  801857:	ff d0                	callq  *%rax
  801859:	89 45 fc             	mov    %eax,-0x4(%rbp)
                        if(allocated_block < 0)
  80185c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801860:	79 0a                	jns    80186c <file_block_walk+0xa7>
                        {
                                return -E_NO_DISK;
  801862:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801867:	e9 85 00 00 00       	jmpq   8018f1 <file_block_walk+0x12c>

                        }
                        f->f_indirect = allocated_block;
  80186c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80186f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801873:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
                        memset((uint32_t*)diskaddr(f->f_indirect),0,BLKSIZE);
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801883:	89 c0                	mov    %eax,%eax
  801885:	48 89 c7             	mov    %rax,%rdi
  801888:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
  801894:	ba 00 10 00 00       	mov    $0x1000,%edx
  801899:	be 00 00 00 00       	mov    $0x0,%esi
  80189e:	48 89 c7             	mov    %rax,%rdi
  8018a1:	48 b8 db 55 80 00 00 	movabs $0x8055db,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	callq  *%rax


                }
                indirectblkptr=(uint32_t*)diskaddr(f->f_indirect);
  8018ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b1:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8018b7:	89 c0                	mov    %eax,%eax
  8018b9:	48 89 c7             	mov    %rax,%rdi
  8018bc:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8018c3:	00 00 00 
  8018c6:	ff d0                	callq  *%rax
  8018c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                blockno=filebno-NDIRECT;
  8018cc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8018cf:	83 e8 0a             	sub    $0xa,%eax
  8018d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
                *ppdiskbno=&indirectblkptr[blockno];
  8018d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018d8:	48 98                	cltq   
  8018da:	48 c1 e0 02          	shl    $0x2,%rax
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	48 03 55 f0          	add    -0x10(%rbp),%rdx
  8018e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8018e9:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
        }

}
  8018f1:	c9                   	leaveq 
  8018f2:	c3                   	retq   

00000000008018f3 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  8018f3:	55                   	push   %rbp
  8018f4:	48 89 e5             	mov    %rsp,%rbp
  8018f7:	48 83 ec 30          	sub    $0x30,%rsp
  8018fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018ff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801902:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

 // LAB 5: Your code here.
        uint32_t *ppdiskbno;
        int r,allocated_block;
        r = file_block_walk(f, filebno, &ppdiskbno, 1);
  801906:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80190a:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80190d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801911:	b9 01 00 00 00       	mov    $0x1,%ecx
  801916:	48 89 c7             	mov    %rax,%rdi
  801919:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  801920:	00 00 00 
  801923:	ff d0                	callq  *%rax
  801925:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  801928:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80192c:	79 05                	jns    801933 <file_get_block+0x40>
                return r;
  80192e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801931:	eb 52                	jmp    801985 <file_get_block+0x92>


        if ((*ppdiskbno) == 0)
  801933:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801937:	8b 00                	mov    (%rax),%eax
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 25                	jne    801962 <file_get_block+0x6f>
        {
                allocated_block = alloc_block();
  80193d:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  801944:	00 00 00 
  801947:	ff d0                	callq  *%rax
  801949:	89 45 f8             	mov    %eax,-0x8(%rbp)
                if(allocated_block < 0)
  80194c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801950:	79 07                	jns    801959 <file_get_block+0x66>
                {
                                return -E_NO_DISK;
  801952:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801957:	eb 2c                	jmp    801985 <file_get_block+0x92>
                }
                *ppdiskbno = allocated_block;
  801959:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80195d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801960:	89 10                	mov    %edx,(%rax)
        }
         *blk=(char*)diskaddr(*ppdiskbno);
  801962:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801966:	8b 00                	mov    (%rax),%eax
  801968:	89 c0                	mov    %eax,%eax
  80196a:	48 89 c7             	mov    %rax,%rdi
  80196d:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  801974:	00 00 00 
  801977:	ff d0                	callq  *%rax
  801979:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80197d:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  801980:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801985:	c9                   	leaveq 
  801986:	c3                   	retq   

0000000000801987 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801987:	55                   	push   %rbp
  801988:	48 89 e5             	mov    %rsp,%rbp
  80198b:	48 83 ec 40          	sub    $0x40,%rsp
  80198f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801993:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801997:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  80199b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8019a5:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 35                	je     8019e3 <dir_lookup+0x5c>
  8019ae:	48 b9 01 87 80 00 00 	movabs $0x808701,%rcx
  8019b5:	00 00 00 
  8019b8:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8019bf:	00 00 00 
  8019c2:	be 39 01 00 00       	mov    $0x139,%esi
  8019c7:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8019ce:	00 00 00 
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8019dd:	00 00 00 
  8019e0:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8019e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8019ed:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	0f 48 c2             	cmovs  %edx,%eax
  8019f8:	c1 f8 0c             	sar    $0xc,%eax
  8019fb:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8019fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a05:	e9 8a 00 00 00       	jmpq   801a94 <dir_lookup+0x10d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801a0a:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801a0e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a15:	89 ce                	mov    %ecx,%esi
  801a17:	48 89 c7             	mov    %rax,%rdi
  801a1a:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
  801a26:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801a29:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801a2d:	79 05                	jns    801a34 <dir_lookup+0xad>
			return r;
  801a2f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801a32:	eb 71                	jmp    801aa5 <dir_lookup+0x11e>
		f = (struct File*) blk;
  801a34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801a3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801a43:	eb 45                	jmp    801a8a <dir_lookup+0x103>
			if (strcmp(f[j].f_name, name) == 0) {
  801a45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a48:	48 c1 e0 08          	shl    $0x8,%rax
  801a4c:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801a50:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a54:	48 89 d6             	mov    %rdx,%rsi
  801a57:	48 89 c7             	mov    %rax,%rdi
  801a5a:	48 b8 9f 54 80 00 00 	movabs $0x80549f,%rax
  801a61:	00 00 00 
  801a64:	ff d0                	callq  *%rax
  801a66:	85 c0                	test   %eax,%eax
  801a68:	75 1c                	jne    801a86 <dir_lookup+0xff>
				*file = &f[j];
  801a6a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a6d:	48 c1 e0 08          	shl    $0x8,%rax
  801a71:	48 89 c2             	mov    %rax,%rdx
  801a74:	48 03 55 e8          	add    -0x18(%rbp),%rdx
  801a78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a7c:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	eb 1f                	jmp    801aa5 <dir_lookup+0x11e>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801a86:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801a8a:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801a8e:	76 b5                	jbe    801a45 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801a90:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a97:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801a9a:	0f 82 6a ff ff ff    	jb     801a0a <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  801aa0:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  801aa5:	c9                   	leaveq 
  801aa6:	c3                   	retq   

0000000000801aa7 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  801aa7:	55                   	push   %rbp
  801aa8:	48 89 e5             	mov    %rsp,%rbp
  801aab:	48 83 ec 30          	sub    $0x30,%rsp
  801aaf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ab3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801ab7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801abb:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801ac1:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	74 35                	je     801aff <dir_alloc_file+0x58>
  801aca:	48 b9 01 87 80 00 00 	movabs $0x808701,%rcx
  801ad1:	00 00 00 
  801ad4:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  801adb:	00 00 00 
  801ade:	be 52 01 00 00       	mov    $0x152,%esi
  801ae3:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  801aea:	00 00 00 
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
  801af2:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  801af9:	00 00 00 
  801afc:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801aff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b03:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801b09:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	0f 48 c2             	cmovs  %edx,%eax
  801b14:	c1 f8 0c             	sar    $0xc,%eax
  801b17:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b21:	eb 7a                	jmp    801b9d <dir_alloc_file+0xf6>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801b23:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801b27:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801b2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b2e:	89 ce                	mov    %ecx,%esi
  801b30:	48 89 c7             	mov    %rax,%rdi
  801b33:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  801b3a:	00 00 00 
  801b3d:	ff d0                	callq  *%rax
  801b3f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801b46:	79 08                	jns    801b50 <dir_alloc_file+0xa9>
			return r;
  801b48:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801b4b:	e9 b5 00 00 00       	jmpq   801c05 <dir_alloc_file+0x15e>
		f = (struct File*) blk;
  801b50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801b58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801b5f:	eb 32                	jmp    801b93 <dir_alloc_file+0xec>
			if (f[j].f_name[0] == '\0') {
  801b61:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b64:	48 c1 e0 08          	shl    $0x8,%rax
  801b68:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801b6c:	0f b6 00             	movzbl (%rax),%eax
  801b6f:	84 c0                	test   %al,%al
  801b71:	75 1c                	jne    801b8f <dir_alloc_file+0xe8>
				*file = &f[j];
  801b73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b76:	48 c1 e0 08          	shl    $0x8,%rax
  801b7a:	48 89 c2             	mov    %rax,%rdx
  801b7d:	48 03 55 e8          	add    -0x18(%rbp),%rdx
  801b81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b85:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8d:	eb 76                	jmp    801c05 <dir_alloc_file+0x15e>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801b8f:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801b93:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801b97:	76 c8                	jbe    801b61 <dir_alloc_file+0xba>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801b99:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801ba3:	0f 82 7a ff ff ff    	jb     801b23 <dir_alloc_file+0x7c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801ba9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bad:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801bb3:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  801bb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bbd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801bc3:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801bc7:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801bca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bce:	89 ce                	mov    %ecx,%esi
  801bd0:	48 89 c7             	mov    %rax,%rdi
  801bd3:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  801bda:	00 00 00 
  801bdd:	ff d0                	callq  *%rax
  801bdf:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801be2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801be6:	79 05                	jns    801bed <dir_alloc_file+0x146>
		return r;
  801be8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801beb:	eb 18                	jmp    801c05 <dir_alloc_file+0x15e>
	f = (struct File*) blk;
  801bed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  801bf5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bfd:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c05:	c9                   	leaveq 
  801c06:	c3                   	retq   

0000000000801c07 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801c07:	55                   	push   %rbp
  801c08:	48 89 e5             	mov    %rsp,%rbp
  801c0b:	48 83 ec 08          	sub    $0x8,%rsp
  801c0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801c13:	eb 05                	jmp    801c1a <skip_slash+0x13>
		p++;
  801c15:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c1e:	0f b6 00             	movzbl (%rax),%eax
  801c21:	3c 2f                	cmp    $0x2f,%al
  801c23:	74 f0                	je     801c15 <skip_slash+0xe>
		p++;
	return p;
  801c25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c29:	c9                   	leaveq 
  801c2a:	c3                   	retq   

0000000000801c2b <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  801c2b:	55                   	push   %rbp
  801c2c:	48 89 e5             	mov    %rsp,%rbp
  801c2f:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801c36:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  801c3d:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801c44:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  801c4b:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	char name[MAXNAMELEN];
	struct File *dir, *f;
	int r;
	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  801c52:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801c59:	48 89 c7             	mov    %rax,%rdi
  801c5c:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
  801c68:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  801c6f:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  801c76:	00 00 00 
  801c79:	48 8b 00             	mov    (%rax),%rax
  801c7c:	48 83 c0 08          	add    $0x8,%rax
  801c80:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  801c87:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801c8e:	00 
	name[0] = 0;
  801c8f:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  801c96:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801c9d:	00 
  801c9e:	74 0e                	je     801cae <walk_path+0x83>
		*pdir = 0;
  801ca0:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801ca7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801cae:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801cb5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801cbc:	e9 7c 01 00 00       	jmpq   801e3d <walk_path+0x212>
		dir = f;
  801cc1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801cc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801ccc:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801cd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  801cd7:	eb 08                	jmp    801ce1 <walk_path+0xb6>
			path++;
  801cd9:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801ce0:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801ce1:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801ce8:	0f b6 00             	movzbl (%rax),%eax
  801ceb:	3c 2f                	cmp    $0x2f,%al
  801ced:	74 0e                	je     801cfd <walk_path+0xd2>
  801cef:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801cf6:	0f b6 00             	movzbl (%rax),%eax
  801cf9:	84 c0                	test   %al,%al
  801cfb:	75 dc                	jne    801cd9 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  801cfd:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d08:	48 89 d1             	mov    %rdx,%rcx
  801d0b:	48 29 c1             	sub    %rax,%rcx
  801d0e:	48 89 c8             	mov    %rcx,%rax
  801d11:	48 83 f8 7f          	cmp    $0x7f,%rax
  801d15:	7e 0a                	jle    801d21 <walk_path+0xf6>
			return -E_BAD_PATH;
  801d17:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801d1c:	e9 5c 01 00 00       	jmpq   801e7d <walk_path+0x252>
		memmove(name, p, path - p);
  801d21:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2c:	48 89 d1             	mov    %rdx,%rcx
  801d2f:	48 29 c1             	sub    %rax,%rcx
  801d32:	48 89 c8             	mov    %rcx,%rax
  801d35:	48 89 c2             	mov    %rax,%rdx
  801d38:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d3c:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  801d43:	48 89 ce             	mov    %rcx,%rsi
  801d46:	48 89 c7             	mov    %rax,%rdi
  801d49:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  801d50:	00 00 00 
  801d53:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  801d55:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801d5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d60:	48 89 d1             	mov    %rdx,%rcx
  801d63:	48 29 c1             	sub    %rax,%rcx
  801d66:	48 89 c8             	mov    %rcx,%rax
  801d69:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801d70:	00 
		path = skip_slash(path);
  801d71:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801d78:	48 89 c7             	mov    %rax,%rdi
  801d7b:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  801d82:	00 00 00 
  801d85:	ff d0                	callq  *%rax
  801d87:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  801d8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d92:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801d98:	83 f8 01             	cmp    $0x1,%eax
  801d9b:	74 0a                	je     801da7 <walk_path+0x17c>
			return -E_NOT_FOUND;
  801d9d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801da2:	e9 d6 00 00 00       	jmpq   801e7d <walk_path+0x252>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  801da7:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801dae:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  801db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801db9:	48 89 ce             	mov    %rcx,%rsi
  801dbc:	48 89 c7             	mov    %rax,%rdi
  801dbf:	48 b8 87 19 80 00 00 	movabs $0x801987,%rax
  801dc6:	00 00 00 
  801dc9:	ff d0                	callq  *%rax
  801dcb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801dce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dd2:	79 69                	jns    801e3d <walk_path+0x212>
			if (r == -E_NOT_FOUND && *path == '\0') {
  801dd4:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801dd8:	75 5e                	jne    801e38 <walk_path+0x20d>
  801dda:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801de1:	0f b6 00             	movzbl (%rax),%eax
  801de4:	84 c0                	test   %al,%al
  801de6:	75 50                	jne    801e38 <walk_path+0x20d>
				if (pdir)
  801de8:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801def:	00 
  801df0:	74 0e                	je     801e00 <walk_path+0x1d5>
					*pdir = dir;
  801df2:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801df9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dfd:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801e00:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801e07:	00 
  801e08:	74 20                	je     801e2a <walk_path+0x1ff>
					strcpy(lastelem, name);
  801e0a:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801e11:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801e18:	48 89 d6             	mov    %rdx,%rsi
  801e1b:	48 89 c7             	mov    %rax,%rdi
  801e1e:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  801e25:	00 00 00 
  801e28:	ff d0                	callq  *%rax
				*pf = 0;
  801e2a:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801e31:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  801e38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e3b:	eb 40                	jmp    801e7d <walk_path+0x252>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  801e3d:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801e44:	0f b6 00             	movzbl (%rax),%eax
  801e47:	84 c0                	test   %al,%al
  801e49:	0f 85 72 fe ff ff    	jne    801cc1 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  801e4f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801e56:	00 
  801e57:	74 0e                	je     801e67 <walk_path+0x23c>
		*pdir = dir;
  801e59:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801e60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e64:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  801e67:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801e6e:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801e75:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7d:	c9                   	leaveq 
  801e7e:	c3                   	retq   

0000000000801e7f <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801e7f:	55                   	push   %rbp
  801e80:	48 89 e5             	mov    %rsp,%rbp
  801e83:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801e8a:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801e91:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)

	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801e98:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801e9f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801ea6:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801ead:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801eb4:	48 89 c7             	mov    %rax,%rdi
  801eb7:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
  801ec3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eca:	75 0a                	jne    801ed6 <file_create+0x57>
		//return -1;
		return -E_FILE_EXISTS;
  801ecc:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801ed1:	e9 91 00 00 00       	jmpq   801f67 <file_create+0xe8>
	

	if (r != -E_NOT_FOUND || dir == 0)
  801ed6:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801eda:	75 0c                	jne    801ee8 <file_create+0x69>
  801edc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801ee3:	48 85 c0             	test   %rax,%rax
  801ee6:	75 05                	jne    801eed <file_create+0x6e>
		return r;
  801ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eeb:	eb 7a                	jmp    801f67 <file_create+0xe8>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  801eed:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801ef4:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801efb:	48 89 d6             	mov    %rdx,%rsi
  801efe:	48 89 c7             	mov    %rax,%rdi
  801f01:	48 b8 a7 1a 80 00 00 	movabs $0x801aa7,%rax
  801f08:	00 00 00 
  801f0b:	ff d0                	callq  *%rax
  801f0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f14:	79 05                	jns    801f1b <file_create+0x9c>
		return r;
  801f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f19:	eb 4c                	jmp    801f67 <file_create+0xe8>
	strcpy(f->f_name, name);
  801f1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801f22:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801f29:	48 89 d6             	mov    %rdx,%rsi
  801f2c:	48 89 c7             	mov    %rax,%rdi
  801f2f:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	callq  *%rax
	*pf = f;
  801f3b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801f42:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801f49:	48 89 10             	mov    %rdx,(%rax)
	int num;
	//cprintf("NAME OF FILE: %s",(*pf)->f_name);
	file_flush(dir);
  801f4c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801f53:	48 89 c7             	mov    %rax,%rdi
  801f56:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
	//cprintf("Creation of file was succcessfull!");
	return 0;
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f67:	c9                   	leaveq 
  801f68:	c3                   	retq   

0000000000801f69 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801f69:	55                   	push   %rbp
  801f6a:	48 89 e5             	mov    %rsp,%rbp
  801f6d:	48 83 ec 10          	sub    $0x10,%rsp
  801f71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  801f79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f86:	be 00 00 00 00       	mov    $0x0,%esi
  801f8b:	48 89 c7             	mov    %rax,%rdi
  801f8e:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
}
  801f9a:	c9                   	leaveq 
  801f9b:	c3                   	retq   

0000000000801f9c <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  801f9c:	55                   	push   %rbp
  801f9d:	48 89 e5             	mov    %rsp,%rbp
  801fa0:	48 83 ec 60          	sub    $0x60,%rsp
  801fa4:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801fa8:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801fac:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801fb0:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801fb3:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801fb7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801fbd:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801fc0:	7f 0a                	jg     801fcc <file_read+0x30>
		return 0;
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc7:	e9 2d 01 00 00       	jmpq   8020f9 <file_read+0x15d>

	count = MIN(count, f->f_size - offset);
  801fcc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801fd0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801fd4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801fd8:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801fde:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801fe1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe7:	48 63 d0             	movslq %eax,%rdx
  801fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fee:	48 39 c2             	cmp    %rax,%rdx
  801ff1:	48 0f 46 c2          	cmovbe %rdx,%rax
  801ff5:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801ff9:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801ffc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fff:	e9 d9 00 00 00       	jmpq   8020dd <file_read+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  802004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802007:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80200d:	85 c0                	test   %eax,%eax
  80200f:	0f 48 c2             	cmovs  %edx,%eax
  802012:	c1 f8 0c             	sar    $0xc,%eax
  802015:	89 c1                	mov    %eax,%ecx
  802017:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80201b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80201f:	89 ce                	mov    %ecx,%esi
  802021:	48 89 c7             	mov    %rax,%rdi
  802024:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  80202b:	00 00 00 
  80202e:	ff d0                	callq  *%rax
  802030:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802033:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802037:	79 08                	jns    802041 <file_read+0xa5>
			return r;
  802039:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80203c:	e9 b8 00 00 00       	jmpq   8020f9 <file_read+0x15d>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  802041:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802044:	89 c2                	mov    %eax,%edx
  802046:	c1 fa 1f             	sar    $0x1f,%edx
  802049:	c1 ea 14             	shr    $0x14,%edx
  80204c:	01 d0                	add    %edx,%eax
  80204e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802053:	29 d0                	sub    %edx,%eax
  802055:	ba 00 10 00 00       	mov    $0x1000,%edx
  80205a:	89 d1                	mov    %edx,%ecx
  80205c:	29 c1                	sub    %eax,%ecx
  80205e:	89 c8                	mov    %ecx,%eax
  802060:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  802063:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  802066:	48 98                	cltq   
  802068:	48 89 c2             	mov    %rax,%rdx
  80206b:	48 03 55 a8          	add    -0x58(%rbp),%rdx
  80206f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802072:	48 98                	cltq   
  802074:	48 89 d1             	mov    %rdx,%rcx
  802077:	48 29 c1             	sub    %rax,%rcx
  80207a:	48 89 c8             	mov    %rcx,%rax
  80207d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802081:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802084:	48 63 d0             	movslq %eax,%rdx
  802087:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80208b:	48 39 c2             	cmp    %rax,%rdx
  80208e:	48 0f 46 c2          	cmovbe %rdx,%rax
  802092:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  802095:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802098:	48 63 c8             	movslq %eax,%rcx
  80209b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80209f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a2:	89 c2                	mov    %eax,%edx
  8020a4:	c1 fa 1f             	sar    $0x1f,%edx
  8020a7:	c1 ea 14             	shr    $0x14,%edx
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020b1:	29 d0                	sub    %edx,%eax
  8020b3:	48 98                	cltq   
  8020b5:	48 01 c6             	add    %rax,%rsi
  8020b8:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8020bc:	48 89 ca             	mov    %rcx,%rdx
  8020bf:	48 89 c7             	mov    %rax,%rdi
  8020c2:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8020c9:	00 00 00 
  8020cc:	ff d0                	callq  *%rax
		pos += bn;
  8020ce:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020d1:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8020d4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020d7:	48 98                	cltq   
  8020d9:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  8020dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e0:	48 63 d0             	movslq %eax,%rdx
  8020e3:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8020e6:	48 98                	cltq   
  8020e8:	48 03 45 a8          	add    -0x58(%rbp),%rax
  8020ec:	48 39 c2             	cmp    %rax,%rdx
  8020ef:	0f 82 0f ff ff ff    	jb     802004 <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  8020f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  8020f9:	c9                   	leaveq 
  8020fa:	c3                   	retq   

00000000008020fb <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  8020fb:	55                   	push   %rbp
  8020fc:	48 89 e5             	mov    %rsp,%rbp
  8020ff:	48 83 ec 50          	sub    $0x50,%rsp
  802103:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802107:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80210b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80210f:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;
	
	r = journal_write(f, buf, count, offset);
  802112:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  802115:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802119:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80211d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802121:	48 89 c7             	mov    %rax,%rdi
  802124:	48 b8 44 26 80 00 00 	movabs $0x802644,%rax
  80212b:	00 00 00 
  80212e:	ff d0                	callq  *%rax
  802130:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if(r < 0)
  802133:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802137:	79 08                	jns    802141 <file_write+0x46>
                return r;
  802139:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80213c:	e9 a2 01 00 00       	jmpq   8022e3 <file_write+0x1e8>
	
	r = journal_commit(f, buf, count, offset);
  802141:	8b 4d b4             	mov    -0x4c(%rbp),%ecx
  802144:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802148:	48 8b 75 c0          	mov    -0x40(%rbp),%rsi
  80214c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802150:	48 89 c7             	mov    %rax,%rdi
  802153:	48 b8 43 28 80 00 00 	movabs $0x802843,%rax
  80215a:	00 00 00 
  80215d:	ff d0                	callq  *%rax
  80215f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if(r < 0)
  802162:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802166:	79 08                	jns    802170 <file_write+0x75>
                return r;
  802168:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80216b:	e9 73 01 00 00       	jmpq   8022e3 <file_write+0x1e8>

	r = journal_checkpoint();
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	48 ba b3 2c 80 00 00 	movabs $0x802cb3,%rdx
  80217c:	00 00 00 
  80217f:	ff d2                	callq  *%rdx
  802181:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if(r < 0)
  802184:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802188:	79 08                	jns    802192 <file_write+0x97>
		return r;
  80218a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80218d:	e9 51 01 00 00       	jmpq   8022e3 <file_write+0x1e8>

// /*	
	// Extend file if necessary
	if (offset + count > f->f_size)
  802192:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  802195:	48 98                	cltq   
  802197:	48 89 c2             	mov    %rax,%rdx
  80219a:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  80219e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021a2:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8021a8:	48 98                	cltq   
  8021aa:	48 39 c2             	cmp    %rax,%rdx
  8021ad:	76 33                	jbe    8021e2 <file_write+0xe7>
		if ((r = file_set_size(f, offset + count)) < 0)
  8021af:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	89 c2                	mov    %eax,%edx
  8021bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021c0:	89 d6                	mov    %edx,%esi
  8021c2:	48 89 c7             	mov    %rax,%rdi
  8021c5:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
  8021d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021d8:	79 08                	jns    8021e2 <file_write+0xe7>
			return r;
  8021da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021dd:	e9 01 01 00 00       	jmpq   8022e3 <file_write+0x1e8>

	for (pos = offset; pos < offset + count; ) {
  8021e2:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e8:	e9 da 00 00 00       	jmpq   8022c7 <file_write+0x1cc>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8021ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f0:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	0f 48 c2             	cmovs  %edx,%eax
  8021fb:	c1 f8 0c             	sar    $0xc,%eax
  8021fe:	89 c1                	mov    %eax,%ecx
  802200:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802204:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802208:	89 ce                	mov    %ecx,%esi
  80220a:	48 89 c7             	mov    %rax,%rdi
  80220d:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80221c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802220:	79 08                	jns    80222a <file_write+0x12f>
			return r;	
  802222:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802225:	e9 b9 00 00 00       	jmpq   8022e3 <file_write+0x1e8>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80222a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222d:	89 c2                	mov    %eax,%edx
  80222f:	c1 fa 1f             	sar    $0x1f,%edx
  802232:	c1 ea 14             	shr    $0x14,%edx
  802235:	01 d0                	add    %edx,%eax
  802237:	25 ff 0f 00 00       	and    $0xfff,%eax
  80223c:	29 d0                	sub    %edx,%eax
  80223e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802243:	89 d1                	mov    %edx,%ecx
  802245:	29 c1                	sub    %eax,%ecx
  802247:	89 c8                	mov    %ecx,%eax
  802249:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80224c:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  80224f:	48 98                	cltq   
  802251:	48 89 c2             	mov    %rax,%rdx
  802254:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  802258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225b:	48 98                	cltq   
  80225d:	48 89 d1             	mov    %rdx,%rcx
  802260:	48 29 c1             	sub    %rax,%rcx
  802263:	48 89 c8             	mov    %rcx,%rax
  802266:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80226a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80226d:	48 63 d0             	movslq %eax,%rdx
  802270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802274:	48 39 c2             	cmp    %rax,%rdx
  802277:	48 0f 46 c2          	cmovbe %rdx,%rax
  80227b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  80227e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802281:	48 63 c8             	movslq %eax,%rcx
  802284:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  802288:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228b:	89 c2                	mov    %eax,%edx
  80228d:	c1 fa 1f             	sar    $0x1f,%edx
  802290:	c1 ea 14             	shr    $0x14,%edx
  802293:	01 d0                	add    %edx,%eax
  802295:	25 ff 0f 00 00       	and    $0xfff,%eax
  80229a:	29 d0                	sub    %edx,%eax
  80229c:	48 98                	cltq   
  80229e:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8022a2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8022a6:	48 89 ca             	mov    %rcx,%rdx
  8022a9:	48 89 c6             	mov    %rax,%rsi
  8022ac:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8022b3:	00 00 00 
  8022b6:	ff d0                	callq  *%rax
		pos += bn;
  8022b8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022bb:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  8022be:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8022c1:	48 98                	cltq   
  8022c3:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  8022c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ca:	48 63 d0             	movslq %eax,%rdx
  8022cd:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8022d0:	48 98                	cltq   
  8022d2:	48 03 45 b8          	add    -0x48(%rbp),%rax
  8022d6:	48 39 c2             	cmp    %rax,%rdx
  8022d9:	0f 82 0e ff ff ff    	jb     8021ed <file_write+0xf2>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}
// */	
	return count;
  8022df:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  8022e3:	c9                   	leaveq 
  8022e4:	c3                   	retq   

00000000008022e5 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  8022e5:	55                   	push   %rbp
  8022e6:	48 89 e5             	mov    %rsp,%rbp
  8022e9:	48 83 ec 20          	sub    $0x20,%rsp
  8022ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  8022f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f8:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8022fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  802304:	48 89 c7             	mov    %rax,%rdi
  802307:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231a:	79 05                	jns    802321 <file_free_block+0x3c>
		return r;
  80231c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231f:	eb 2d                	jmp    80234e <file_free_block+0x69>
	if (*ptr) {
  802321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802325:	8b 00                	mov    (%rax),%eax
  802327:	85 c0                	test   %eax,%eax
  802329:	74 1e                	je     802349 <file_free_block+0x64>
		free_block(*ptr);
  80232b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232f:	8b 00                	mov    (%rax),%eax
  802331:	89 c7                	mov    %eax,%edi
  802333:	48 b8 c1 12 80 00 00 	movabs $0x8012c1,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
		*ptr = 0;
  80233f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802343:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234e:	c9                   	leaveq 
  80234f:	c3                   	retq   

0000000000802350 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	48 83 ec 20          	sub    $0x20,%rsp
  802358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80235c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  80235f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802363:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  802369:	05 ff 0f 00 00       	add    $0xfff,%eax
  80236e:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  802374:	85 c0                	test   %eax,%eax
  802376:	0f 48 c2             	cmovs  %edx,%eax
  802379:	c1 f8 0c             	sar    $0xc,%eax
  80237c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  80237f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802382:	05 ff 0f 00 00       	add    $0xfff,%eax
  802387:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80238d:	85 c0                	test   %eax,%eax
  80238f:	0f 48 c2             	cmovs  %edx,%eax
  802392:	c1 f8 0c             	sar    $0xc,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  802398:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80239b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239e:	eb 45                	jmp    8023e5 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  8023a0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a7:	89 d6                	mov    %edx,%esi
  8023a9:	48 89 c7             	mov    %rax,%rdi
  8023ac:	48 b8 e5 22 80 00 00 	movabs $0x8022e5,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	callq  *%rax
  8023b8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8023bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8023bf:	79 20                	jns    8023e1 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  8023c1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8023c4:	89 c6                	mov    %eax,%esi
  8023c6:	48 bf 1e 87 80 00 00 	movabs $0x80871e,%rdi
  8023cd:	00 00 00 
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  8023dc:	00 00 00 
  8023df:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  8023e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e8:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8023eb:	72 b3                	jb     8023a0 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  8023ed:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8023f1:	77 34                	ja     802427 <file_truncate_blocks+0xd7>
  8023f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f7:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	74 26                	je     802427 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  802401:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802405:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	48 b8 c1 12 80 00 00 	movabs $0x8012c1,%rax
  802414:	00 00 00 
  802417:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  802419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  802424:	00 00 00 
	}
}
  802427:	c9                   	leaveq 
  802428:	c3                   	retq   

0000000000802429 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  802429:	55                   	push   %rbp
  80242a:	48 89 e5             	mov    %rsp,%rbp
  80242d:	48 83 ec 10          	sub    $0x10,%rsp
  802431:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802435:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  802438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243c:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  802442:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802445:	7e 18                	jle    80245f <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  802447:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80244a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80244e:	89 d6                	mov    %edx,%esi
  802450:	48 89 c7             	mov    %rax,%rdi
  802453:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  80245a:	00 00 00 
  80245d:	ff d0                	callq  *%rax
	f->f_size = newsize;
  80245f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802463:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802466:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  80246c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802470:	48 89 c7             	mov    %rax,%rdi
  802473:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  80247a:	00 00 00 
  80247d:	ff d0                	callq  *%rax
	return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802484:	c9                   	leaveq 
  802485:	c3                   	retq   

0000000000802486 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  802486:	55                   	push   %rbp
  802487:	48 89 e5             	mov    %rsp,%rbp
  80248a:	48 83 ec 20          	sub    $0x20,%rsp
  80248e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  802492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802499:	eb 63                	jmp    8024fe <file_flush+0x78>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80249b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80249e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024ab:	48 89 c7             	mov    %rax,%rdi
  8024ae:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	78 3b                	js     8024f9 <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  8024be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  8024c2:	48 85 c0             	test   %rax,%rax
  8024c5:	74 32                	je     8024f9 <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  8024c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cb:	8b 00                	mov    (%rax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 28                	je     8024f9 <file_flush+0x73>
			continue;
		flush_block(diskaddr(*pdiskbno));
  8024d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d5:	8b 00                	mov    (%rax),%eax
  8024d7:	89 c0                	mov    %eax,%eax
  8024d9:	48 89 c7             	mov    %rax,%rdi
  8024dc:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  8024e3:	00 00 00 
  8024e6:	ff d0                	callq  *%rax
  8024e8:	48 89 c7             	mov    %rax,%rdi
  8024eb:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  8024f2:	00 00 00 
  8024f5:	ff d0                	callq  *%rax
  8024f7:	eb 01                	jmp    8024fa <file_flush+0x74>
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
  8024f9:	90                   	nop
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  8024fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802502:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  802508:	05 ff 0f 00 00       	add    $0xfff,%eax
  80250d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  802513:	85 c0                	test   %eax,%eax
  802515:	0f 48 c2             	cmovs  %edx,%eax
  802518:	c1 f8 0c             	sar    $0xc,%eax
  80251b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80251e:	0f 8f 77 ff ff ff    	jg     80249b <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  802524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802528:	48 89 c7             	mov    %rax,%rdi
  80252b:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  802532:	00 00 00 
  802535:	ff d0                	callq  *%rax
	if (f->f_indirect)
  802537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253b:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	74 2a                	je     80256f <file_flush+0xe9>
		flush_block(diskaddr(f->f_indirect));
  802545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802549:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80254f:	89 c0                	mov    %eax,%eax
  802551:	48 89 c7             	mov    %rax,%rdi
  802554:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax
  802560:	48 89 c7             	mov    %rax,%rdi
  802563:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax
}
  80256f:	c9                   	leaveq 
  802570:	c3                   	retq   

0000000000802571 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  802571:	55                   	push   %rbp
  802572:	48 89 e5             	mov    %rsp,%rbp
  802575:	48 83 ec 20          	sub    $0x20,%rsp
  802579:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  80257d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802585:	b9 00 00 00 00       	mov    $0x0,%ecx
  80258a:	be 00 00 00 00       	mov    $0x0,%esi
  80258f:	48 89 c7             	mov    %rax,%rdi
  802592:	48 b8 2b 1c 80 00 00 	movabs $0x801c2b,%rax
  802599:	00 00 00 
  80259c:	ff d0                	callq  *%rax
  80259e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a5:	79 05                	jns    8025ac <file_remove+0x3b>
		return r;
  8025a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025aa:	eb 45                	jmp    8025f1 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  8025ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b0:	be 00 00 00 00       	mov    $0x0,%esi
  8025b5:	48 89 c7             	mov    %rax,%rdi
  8025b8:	48 b8 50 23 80 00 00 	movabs $0x802350,%rax
  8025bf:	00 00 00 
  8025c2:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  8025c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c8:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025d6:	00 00 00 
	flush_block(f);
  8025d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dd:	48 89 c7             	mov    %rax,%rdi
  8025e0:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax

	return 0;
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f1:	c9                   	leaveq 
  8025f2:	c3                   	retq   

00000000008025f3 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8025f3:	55                   	push   %rbp
  8025f4:	48 89 e5             	mov    %rsp,%rbp
  8025f7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8025fb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  802602:	eb 27                	jmp    80262b <fs_sync+0x38>
		flush_block(diskaddr(i));
  802604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802607:	48 98                	cltq   
  802609:	48 89 c7             	mov    %rax,%rdi
  80260c:	48 b8 dc 04 80 00 00 	movabs $0x8004dc,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
  802618:	48 89 c7             	mov    %rax,%rdi
  80261b:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  802622:	00 00 00 
  802625:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  802627:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80262b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80262e:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  802635:	00 00 00 
  802638:	48 8b 00             	mov    (%rax),%rax
  80263b:	8b 40 04             	mov    0x4(%rax),%eax
  80263e:	39 c2                	cmp    %eax,%edx
  802640:	72 c2                	jb     802604 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  802642:	c9                   	leaveq 
  802643:	c3                   	retq   

0000000000802644 <journal_write>:
// Journal methods
//----------------------------
	
//Method to perform a journal write of transaction data and metadata
int journal_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  802644:	55                   	push   %rbp
  802645:	48 89 e5             	mov    %rsp,%rbp
  802648:	48 83 ec 30          	sub    $0x30,%rsp
  80264c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802650:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802654:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802658:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
	cprintf("[1/3] Starting journal write...\n");
  80265b:	48 bf 40 87 80 00 00 	movabs $0x808740,%rdi
  802662:	00 00 00 
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
  80266a:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802671:	00 00 00 
  802674:	ff d2                	callq  *%rdx

	//uint32_t *journal_count = (uint32_t *)journal;
	//cprintf("journal count:%d\n", journal_count);
	//cprintf("count:%d\n",count);
	uint32_t i;
	struct Journal *cur_journal = (struct Journal *)(journal);
  802676:	48 b8 78 40 81 00 00 	movabs $0x814078,%rax
  80267d:	00 00 00 
  802680:	48 8b 00             	mov    (%rax),%rax
  802683:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	cur_journal += journal_count;
  802687:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80268e:	00 00 00 
  802691:	8b 00                	mov    (%rax),%eax
  802693:	89 c0                	mov    %eax,%eax
  802695:	48 69 c0 18 0a 00 00 	imul   $0xa18,%rax,%rax
  80269c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        
	cur_journal->txBegin = 1;
  8026a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a4:	c6 00 01             	movb   $0x1,(%rax)
	
	for(i = 0; i < super->s_nblocks; i+=32)
  8026a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026ae:	eb 34                	jmp    8026e4 <journal_write+0xa0>
		cur_journal->bmap[i/32] =  bitmap[i/32]; 
  8026b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b3:	89 c6                	mov    %eax,%esi
  8026b5:	c1 ee 05             	shr    $0x5,%esi
  8026b8:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  8026bf:	00 00 00 
  8026c2:	48 8b 00             	mov    (%rax),%rax
  8026c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026c8:	c1 ea 05             	shr    $0x5,%edx
  8026cb:	89 d2                	mov    %edx,%edx
  8026cd:	48 c1 e2 02          	shl    $0x2,%rdx
  8026d1:	48 01 d0             	add    %rdx,%rax
  8026d4:	8b 08                	mov    (%rax),%ecx
  8026d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026da:	89 f2                	mov    %esi,%edx
  8026dc:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
	struct Journal *cur_journal = (struct Journal *)(journal);
	cur_journal += journal_count;
        
	cur_journal->txBegin = 1;
	
	for(i = 0; i < super->s_nblocks; i+=32)
  8026e0:	83 45 fc 20          	addl   $0x20,-0x4(%rbp)
  8026e4:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  8026eb:	00 00 00 
  8026ee:	48 8b 00             	mov    (%rax),%rax
  8026f1:	8b 40 04             	mov    0x4(%rax),%eax
  8026f4:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8026f7:	77 b7                	ja     8026b0 <journal_write+0x6c>
	{
                cprintf("bitmap[%d]:%08x\n",i/32, bitmap[i/32]);
		cprintf("bmap[%d]:%08x\n",i/32, cur_journal->bmap[i/32]);
	}*/
	
	strcpy(cur_journal->file.f_name, f->f_name);
  8026f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802701:	48 81 c2 04 05 00 00 	add    $0x504,%rdx
  802708:	48 89 c6             	mov    %rax,%rsi
  80270b:	48 89 d7             	mov    %rdx,%rdi
  80270e:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  802715:	00 00 00 
  802718:	ff d0                	callq  *%rax
	cur_journal->file.f_size = f->f_size;
  80271a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80271e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802728:	89 90 84 05 00 00    	mov    %edx,0x584(%rax)
	cur_journal->file.f_type = f->f_type;
  80272e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802732:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273c:	89 90 88 05 00 00    	mov    %edx,0x588(%rax)
	for(i = 0; i < NDIRECT ; i++)
  802742:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802749:	eb 25                	jmp    802770 <journal_write+0x12c>
		cur_journal->file.f_direct[i] = f->f_direct[i];
  80274b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802752:	48 83 c2 20          	add    $0x20,%rdx
  802756:	8b 54 90 08          	mov    0x8(%rax,%rdx,4),%edx
  80275a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275e:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802761:	48 81 c1 60 01 00 00 	add    $0x160,%rcx
  802768:	89 54 88 0c          	mov    %edx,0xc(%rax,%rcx,4)
	}*/
	
	strcpy(cur_journal->file.f_name, f->f_name);
	cur_journal->file.f_size = f->f_size;
	cur_journal->file.f_type = f->f_type;
	for(i = 0; i < NDIRECT ; i++)
  80276c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802770:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  802774:	76 d5                	jbe    80274b <journal_write+0x107>
		cur_journal->file.f_direct[i] = f->f_direct[i];
	cur_journal->file.f_indirect = f->f_indirect;
  802776:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277a:	8b 90 b0 00 00 00    	mov    0xb0(%rax),%edx
  802780:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802784:	89 90 b4 05 00 00    	mov    %edx,0x5b4(%rax)
	for(i = 0; i< (256 - MAXNAMELEN - 8 - 4*NDIRECT - 4); i++)
  80278a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802791:	eb 21                	jmp    8027b4 <journal_write+0x170>
		cur_journal->file.f_pad[i] = f->f_pad[i];
  802793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802797:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279a:	0f b6 8c 02 b4 00 00 	movzbl 0xb4(%rdx,%rax,1),%ecx
  8027a1:	00 
  8027a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a9:	88 8c 02 b8 05 00 00 	mov    %cl,0x5b8(%rdx,%rax,1)
	cur_journal->file.f_size = f->f_size;
	cur_journal->file.f_type = f->f_type;
	for(i = 0; i < NDIRECT ; i++)
		cur_journal->file.f_direct[i] = f->f_direct[i];
	cur_journal->file.f_indirect = f->f_indirect;
	for(i = 0; i< (256 - MAXNAMELEN - 8 - 4*NDIRECT - 4); i++)
  8027b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027b4:	83 7d fc 4b          	cmpl   $0x4b,-0x4(%rbp)
  8027b8:	76 d9                	jbe    802793 <journal_write+0x14f>
		cur_journal->file.f_pad[i] = f->f_pad[i];

	cur_journal->count = count;
  8027ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027c2:	48 89 90 08 06 00 00 	mov    %rdx,0x608(%rax)

	memmove(cur_journal->buffer, buf, count);
  8027c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027cd:	48 8d 88 10 06 00 00 	lea    0x610(%rax),%rcx
  8027d4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027dc:	48 89 c6             	mov    %rax,%rsi
  8027df:	48 89 cf             	mov    %rcx,%rdi
  8027e2:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
	//cprintf("journal buffer:%s\nbuffer:%s\n", cur_journal->buffer, buf, count);
	
	cur_journal->offset = offset;
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  8027f5:	89 90 10 0a 00 00    	mov    %edx,0xa10(%rax)
	
	cur_journal->txEnd = 0;	
  8027fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ff:	c6 80 14 0a 00 00 00 	movb   $0x0,0xa14(%rax)
	
	journal_count++;
  802806:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80280d:	00 00 00 
  802810:	8b 00                	mov    (%rax),%eax
  802812:	8d 50 01             	lea    0x1(%rax),%edx
  802815:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80281c:	00 00 00 
  80281f:	89 10                	mov    %edx,(%rax)
	cprintf("[1/3] Journal write complete...\n");
  802821:	48 bf 68 87 80 00 00 	movabs $0x808768,%rdi
  802828:	00 00 00 
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802837:	00 00 00 
  80283a:	ff d2                	callq  *%rdx
	//cprintf("journal count:%d\n", journal_count);

	return 0;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802841:	c9                   	leaveq 
  802842:	c3                   	retq   

0000000000802843 <journal_commit>:

//Method to perform a journal commit
int journal_commit(struct File *f, const void *buf, size_t count, off_t offset)
{
  802843:	55                   	push   %rbp
  802844:	48 89 e5             	mov    %rsp,%rbp
  802847:	48 83 ec 40          	sub    $0x40,%rsp
  80284b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80284f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802853:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  802857:	89 4d c4             	mov    %ecx,-0x3c(%rbp)
	cprintf("[2/3] Starting journal commit...\n");
  80285a:	48 bf 90 87 80 00 00 	movabs $0x808790,%rdi
  802861:	00 00 00 
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802870:	00 00 00 
  802873:	ff d2                	callq  *%rdx
	journal_count--;
  802875:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80287c:	00 00 00 
  80287f:	8b 00                	mov    (%rax),%eax
  802881:	8d 50 ff             	lea    -0x1(%rax),%edx
  802884:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80288b:	00 00 00 
  80288e:	89 10                	mov    %edx,(%rax)
	struct Journal *prev_journal = (struct Journal *)(journal);
  802890:	48 b8 78 40 81 00 00 	movabs $0x814078,%rax
  802897:	00 00 00 
  80289a:	48 8b 00             	mov    (%rax),%rax
  80289d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	prev_journal += journal_count;
  8028a1:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  8028a8:	00 00 00 
  8028ab:	8b 00                	mov    (%rax),%eax
  8028ad:	89 c0                	mov    %eax,%eax
  8028af:	48 69 c0 18 0a 00 00 	imul   $0xa18,%rax,%rax
  8028b6:	48 01 45 f0          	add    %rax,-0x10(%rbp)
	uint32_t i;
        
	assert(prev_journal->txBegin == 1);
  8028ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028be:	0f b6 00             	movzbl (%rax),%eax
  8028c1:	3c 01                	cmp    $0x1,%al
  8028c3:	74 35                	je     8028fa <journal_commit+0xb7>
  8028c5:	48 b9 b2 87 80 00 00 	movabs $0x8087b2,%rcx
  8028cc:	00 00 00 
  8028cf:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8028d6:	00 00 00 
  8028d9:	be b5 02 00 00       	mov    $0x2b5,%esi
  8028de:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8028e5:	00 00 00 
  8028e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ed:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8028f4:	00 00 00 
  8028f7:	41 ff d0             	callq  *%r8
	
	assert(strcmp(f->f_name, prev_journal->file.f_name) == 0);
  8028fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028fe:	48 8d 90 04 05 00 00 	lea    0x504(%rax),%rdx
  802905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802909:	48 89 d6             	mov    %rdx,%rsi
  80290c:	48 89 c7             	mov    %rax,%rdi
  80290f:	48 b8 9f 54 80 00 00 	movabs $0x80549f,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 35                	je     802954 <journal_commit+0x111>
  80291f:	48 b9 d0 87 80 00 00 	movabs $0x8087d0,%rcx
  802926:	00 00 00 
  802929:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802930:	00 00 00 
  802933:	be b7 02 00 00       	mov    $0x2b7,%esi
  802938:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  80293f:	00 00 00 
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
  802947:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80294e:	00 00 00 
  802951:	41 ff d0             	callq  *%r8
	assert(f->f_size == prev_journal->file.f_size);
  802954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802958:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80295e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802962:	8b 80 84 05 00 00    	mov    0x584(%rax),%eax
  802968:	39 c2                	cmp    %eax,%edx
  80296a:	74 35                	je     8029a1 <journal_commit+0x15e>
  80296c:	48 b9 08 88 80 00 00 	movabs $0x808808,%rcx
  802973:	00 00 00 
  802976:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  80297d:	00 00 00 
  802980:	be b8 02 00 00       	mov    $0x2b8,%esi
  802985:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  80298c:	00 00 00 
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80299b:	00 00 00 
  80299e:	41 ff d0             	callq  *%r8
	assert(f->f_type == prev_journal->file.f_type);
  8029a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a5:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029af:	8b 80 88 05 00 00    	mov    0x588(%rax),%eax
  8029b5:	39 c2                	cmp    %eax,%edx
  8029b7:	74 35                	je     8029ee <journal_commit+0x1ab>
  8029b9:	48 b9 30 88 80 00 00 	movabs $0x808830,%rcx
  8029c0:	00 00 00 
  8029c3:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  8029ca:	00 00 00 
  8029cd:	be b9 02 00 00       	mov    $0x2b9,%esi
  8029d2:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  8029d9:	00 00 00 
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8029e8:	00 00 00 
  8029eb:	41 ff d0             	callq  *%r8
	for(i = 0; i < NDIRECT ; i++)
  8029ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029f5:	eb 5e                	jmp    802a55 <journal_commit+0x212>
                assert(prev_journal->file.f_direct[i] == f->f_direct[i]);
  8029f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029fe:	48 81 c2 60 01 00 00 	add    $0x160,%rdx
  802a05:	8b 54 90 0c          	mov    0xc(%rax,%rdx,4),%edx
  802a09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a0d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802a10:	48 83 c1 20          	add    $0x20,%rcx
  802a14:	8b 44 88 08          	mov    0x8(%rax,%rcx,4),%eax
  802a18:	39 c2                	cmp    %eax,%edx
  802a1a:	74 35                	je     802a51 <journal_commit+0x20e>
  802a1c:	48 b9 58 88 80 00 00 	movabs $0x808858,%rcx
  802a23:	00 00 00 
  802a26:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802a2d:	00 00 00 
  802a30:	be bb 02 00 00       	mov    $0x2bb,%esi
  802a35:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802a3c:	00 00 00 
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802a4b:	00 00 00 
  802a4e:	41 ff d0             	callq  *%r8
	assert(prev_journal->txBegin == 1);
	
	assert(strcmp(f->f_name, prev_journal->file.f_name) == 0);
	assert(f->f_size == prev_journal->file.f_size);
	assert(f->f_type == prev_journal->file.f_type);
	for(i = 0; i < NDIRECT ; i++)
  802a51:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a55:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  802a59:	76 9c                	jbe    8029f7 <journal_commit+0x1b4>
                assert(prev_journal->file.f_direct[i] == f->f_direct[i]);
        assert(prev_journal->file.f_indirect == f->f_indirect);
  802a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5f:	8b 90 b4 05 00 00    	mov    0x5b4(%rax),%edx
  802a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a69:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  802a6f:	39 c2                	cmp    %eax,%edx
  802a71:	74 35                	je     802aa8 <journal_commit+0x265>
  802a73:	48 b9 90 88 80 00 00 	movabs $0x808890,%rcx
  802a7a:	00 00 00 
  802a7d:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802a84:	00 00 00 
  802a87:	be bc 02 00 00       	mov    $0x2bc,%esi
  802a8c:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802a93:	00 00 00 
  802a96:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9b:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802aa2:	00 00 00 
  802aa5:	41 ff d0             	callq  *%r8
        for(i = 0; i< (256 - MAXNAMELEN - 8 - 4*NDIRECT - 4); i++)
  802aa8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aaf:	eb 5b                	jmp    802b0c <journal_commit+0x2c9>
                assert(prev_journal->file.f_pad[i] == f->f_pad[i]);
  802ab1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	0f b6 8c 02 b8 05 00 	movzbl 0x5b8(%rdx,%rax,1),%ecx
  802abf:	00 
  802ac0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac7:	0f b6 84 02 b4 00 00 	movzbl 0xb4(%rdx,%rax,1),%eax
  802ace:	00 
  802acf:	38 c1                	cmp    %al,%cl
  802ad1:	74 35                	je     802b08 <journal_commit+0x2c5>
  802ad3:	48 b9 c0 88 80 00 00 	movabs $0x8088c0,%rcx
  802ada:	00 00 00 
  802add:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802ae4:	00 00 00 
  802ae7:	be be 02 00 00       	mov    $0x2be,%esi
  802aec:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802af3:	00 00 00 
  802af6:	b8 00 00 00 00       	mov    $0x0,%eax
  802afb:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802b02:	00 00 00 
  802b05:	41 ff d0             	callq  *%r8
	assert(f->f_size == prev_journal->file.f_size);
	assert(f->f_type == prev_journal->file.f_type);
	for(i = 0; i < NDIRECT ; i++)
                assert(prev_journal->file.f_direct[i] == f->f_direct[i]);
        assert(prev_journal->file.f_indirect == f->f_indirect);
        for(i = 0; i< (256 - MAXNAMELEN - 8 - 4*NDIRECT - 4); i++)
  802b08:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b0c:	83 7d fc 4b          	cmpl   $0x4b,-0x4(%rbp)
  802b10:	76 9f                	jbe    802ab1 <journal_commit+0x26e>
                assert(prev_journal->file.f_pad[i] == f->f_pad[i]);

	assert(prev_journal->count == count);	
  802b12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b16:	48 8b 80 08 06 00 00 	mov    0x608(%rax),%rax
  802b1d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802b21:	74 35                	je     802b58 <journal_commit+0x315>
  802b23:	48 b9 eb 88 80 00 00 	movabs $0x8088eb,%rcx
  802b2a:	00 00 00 
  802b2d:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802b34:	00 00 00 
  802b37:	be c0 02 00 00       	mov    $0x2c0,%esi
  802b3c:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802b43:	00 00 00 
  802b46:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4b:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802b52:	00 00 00 
  802b55:	41 ff d0             	callq  *%r8

	char *charbuf = (char *)buf;
  802b58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for(i = 0; i < count; i++)
  802b60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b67:	eb 56                	jmp    802bbf <journal_commit+0x37c>
		assert(*(charbuf+i) == prev_journal->buffer[i]);  
  802b69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6c:	48 03 45 e8          	add    -0x18(%rbp),%rax
  802b70:	0f b6 08             	movzbl (%rax),%ecx
  802b73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	0f b6 84 02 10 06 00 	movzbl 0x610(%rdx,%rax,1),%eax
  802b81:	00 
  802b82:	38 c1                	cmp    %al,%cl
  802b84:	74 35                	je     802bbb <journal_commit+0x378>
  802b86:	48 b9 08 89 80 00 00 	movabs $0x808908,%rcx
  802b8d:	00 00 00 
  802b90:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802b97:	00 00 00 
  802b9a:	be c4 02 00 00       	mov    $0x2c4,%esi
  802b9f:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802ba6:	00 00 00 
  802ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bae:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802bb5:	00 00 00 
  802bb8:	41 ff d0             	callq  *%r8
                assert(prev_journal->file.f_pad[i] == f->f_pad[i]);

	assert(prev_journal->count == count);	

	char *charbuf = (char *)buf;
	for(i = 0; i < count; i++)
  802bbb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802bc6:	72 a1                	jb     802b69 <journal_commit+0x326>
		assert(*(charbuf+i) == prev_journal->buffer[i]);  

	assert(prev_journal->offset == offset);
  802bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcc:	8b 80 10 0a 00 00    	mov    0xa10(%rax),%eax
  802bd2:	3b 45 c4             	cmp    -0x3c(%rbp),%eax
  802bd5:	74 35                	je     802c0c <journal_commit+0x3c9>
  802bd7:	48 b9 30 89 80 00 00 	movabs $0x808930,%rcx
  802bde:	00 00 00 
  802be1:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802be8:	00 00 00 
  802beb:	be c6 02 00 00       	mov    $0x2c6,%esi
  802bf0:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802bf7:	00 00 00 
  802bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802bff:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802c06:	00 00 00 
  802c09:	41 ff d0             	callq  *%r8

	assert(prev_journal->txEnd == 0);
  802c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c10:	0f b6 80 14 0a 00 00 	movzbl 0xa14(%rax),%eax
  802c17:	84 c0                	test   %al,%al
  802c19:	74 35                	je     802c50 <journal_commit+0x40d>
  802c1b:	48 b9 4f 89 80 00 00 	movabs $0x80894f,%rcx
  802c22:	00 00 00 
  802c25:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802c2c:	00 00 00 
  802c2f:	be c8 02 00 00       	mov    $0x2c8,%esi
  802c34:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802c3b:	00 00 00 
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c43:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802c4a:	00 00 00 
  802c4d:	41 ff d0             	callq  *%r8
	cprintf("[2/3] Journal record is in a consistent state\n");
  802c50:	48 bf 68 89 80 00 00 	movabs $0x808968,%rdi
  802c57:	00 00 00 
  802c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5f:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802c66:	00 00 00 
  802c69:	ff d2                	callq  *%rdx
	
	prev_journal->txEnd = 1;
  802c6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c6f:	c6 80 14 0a 00 00 01 	movb   $0x1,0xa14(%rax)
	journal_count++;
  802c76:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802c7d:	00 00 00 
  802c80:	8b 00                	mov    (%rax),%eax
  802c82:	8d 50 01             	lea    0x1(%rax),%edx
  802c85:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802c8c:	00 00 00 
  802c8f:	89 10                	mov    %edx,(%rax)
	cprintf("[2/3] Journal commit complete...\n");
  802c91:	48 bf 98 89 80 00 00 	movabs $0x808998,%rdi
  802c98:	00 00 00 
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802ca7:	00 00 00 
  802caa:	ff d2                	callq  *%rdx
	return 0;
  802cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <journal_checkpoint>:

//Method to perform a journal checkpoint.Flushes the journal blocks to disk
int journal_checkpoint()
{
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 10          	sub    $0x10,%rsp
	cprintf("[3/3] Starting journal checkpointing...\n");
  802cbb:	48 bf c0 89 80 00 00 	movabs $0x8089c0,%rdi
  802cc2:	00 00 00 
  802cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cca:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802cd1:	00 00 00 
  802cd4:	ff d2                	callq  *%rdx
	journal_count--;
  802cd6:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802cdd:	00 00 00 
  802ce0:	8b 00                	mov    (%rax),%eax
  802ce2:	8d 50 ff             	lea    -0x1(%rax),%edx
  802ce5:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802cec:	00 00 00 
  802cef:	89 10                	mov    %edx,(%rax)
        struct Journal *prev_journal = (struct Journal *)(journal);
  802cf1:	48 b8 78 40 81 00 00 	movabs $0x814078,%rax
  802cf8:	00 00 00 
  802cfb:	48 8b 00             	mov    (%rax),%rax
  802cfe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	prev_journal += journal_count;
  802d02:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802d09:	00 00 00 
  802d0c:	8b 00                	mov    (%rax),%eax
  802d0e:	89 c0                	mov    %eax,%eax
  802d10:	48 69 c0 18 0a 00 00 	imul   $0xa18,%rax,%rax
  802d17:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	assert(prev_journal->txBegin == 1);
  802d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1f:	0f b6 00             	movzbl (%rax),%eax
  802d22:	3c 01                	cmp    $0x1,%al
  802d24:	74 35                	je     802d5b <journal_checkpoint+0xa8>
  802d26:	48 b9 b2 87 80 00 00 	movabs $0x8087b2,%rcx
  802d2d:	00 00 00 
  802d30:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802d37:	00 00 00 
  802d3a:	be d8 02 00 00       	mov    $0x2d8,%esi
  802d3f:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802d46:	00 00 00 
  802d49:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4e:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802d55:	00 00 00 
  802d58:	41 ff d0             	callq  *%r8
	assert(prev_journal->txEnd == 1);
  802d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d5f:	0f b6 80 14 0a 00 00 	movzbl 0xa14(%rax),%eax
  802d66:	3c 01                	cmp    $0x1,%al
  802d68:	74 35                	je     802d9f <journal_checkpoint+0xec>
  802d6a:	48 b9 e9 89 80 00 00 	movabs $0x8089e9,%rcx
  802d71:	00 00 00 
  802d74:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802d7b:	00 00 00 
  802d7e:	be d9 02 00 00       	mov    $0x2d9,%esi
  802d83:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802d8a:	00 00 00 
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802d99:	00 00 00 
  802d9c:	41 ff d0             	callq  *%r8
	//cprintf("journal start addr:%08x\nisdirty:%d\n", prev_journal, va_is_dirty(prev_journal));
	//cprintf("journal end addr:%08x\nisdirty:%d\n", prev_journal+1, va_is_dirty(prev_journal));
	flush_block(prev_journal);
  802d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
	flush_block(prev_journal+1);
  802db2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db6:	48 05 18 0a 00 00    	add    $0xa18,%rax
  802dbc:	48 89 c7             	mov    %rax,%rdi
  802dbf:	48 b8 d5 0a 80 00 00 	movabs $0x800ad5,%rax
  802dc6:	00 00 00 
  802dc9:	ff d0                	callq  *%rax
	//cprintf("journal start addr:%08x\nisdirty:%d\n", prev_journal, va_is_dirty(prev_journal));
        //cprintf("journal end addr:%08x\nisdirty:%d\n", prev_journal+1, va_is_dirty(prev_journal));	
	journal_count++;
  802dcb:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802dd2:	00 00 00 
  802dd5:	8b 00                	mov    (%rax),%eax
  802dd7:	8d 50 01             	lea    0x1(%rax),%edx
  802dda:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802de1:	00 00 00 
  802de4:	89 10                	mov    %edx,(%rax)
	cprintf("[3/3] Journal checkpointing complete...\n\n\n");
  802de6:	48 bf 08 8a 80 00 00 	movabs $0x808a08,%rdi
  802ded:	00 00 00 
  802df0:	b8 00 00 00 00       	mov    $0x0,%eax
  802df5:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802dfc:	00 00 00 
  802dff:	ff d2                	callq  *%rdx
	return 0; 
  802e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e06:	c9                   	leaveq 
  802e07:	c3                   	retq   

0000000000802e08 <replay_journal>:

//Method that replays the journal records from journal blocks during FS initialization
void replay_journal()
{
  802e08:	55                   	push   %rbp
  802e09:	48 89 e5             	mov    %rsp,%rbp
  802e0c:	48 81 ec 20 04 00 00 	sub    $0x420,%rsp
	int journal_counter, success_counter, r, i;
	cprintf("Replaying journal records...\n");
  802e13:	48 bf 33 8a 80 00 00 	movabs $0x808a33,%rdi
  802e1a:	00 00 00 
  802e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e22:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802e29:	00 00 00 
  802e2c:	ff d2                	callq  *%rdx
	struct Journal *itjournal = (struct Journal *)(journal);
  802e2e:	48 b8 78 40 81 00 00 	movabs $0x814078,%rax
  802e35:	00 00 00 
  802e38:	48 8b 00             	mov    (%rax),%rax
  802e3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for(journal_counter = 0, success_counter = 0;itjournal->txBegin==1;itjournal++, journal_counter++)
  802e3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  802e4d:	e9 c4 02 00 00       	jmpq   803116 <replay_journal+0x30e>
	{
		cprintf("Replaying journal record %d...\n",journal_counter);
  802e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e55:	89 c6                	mov    %eax,%esi
  802e57:	48 bf 58 8a 80 00 00 	movabs $0x808a58,%rdi
  802e5e:	00 00 00 
  802e61:	b8 00 00 00 00       	mov    $0x0,%eax
  802e66:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802e6d:	00 00 00 
  802e70:	ff d2                	callq  *%rdx
		//cprintf("txbegin:%d\n",itjournal->txBegin);
		//i++;
		assert(itjournal->txBegin == itjournal->txEnd);
  802e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e76:	0f b6 10             	movzbl (%rax),%edx
  802e79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7d:	0f b6 80 14 0a 00 00 	movzbl 0xa14(%rax),%eax
  802e84:	38 c2                	cmp    %al,%dl
  802e86:	74 35                	je     802ebd <replay_journal+0xb5>
  802e88:	48 b9 78 8a 80 00 00 	movabs $0x808a78,%rcx
  802e8f:	00 00 00 
  802e92:	48 ba e2 84 80 00 00 	movabs $0x8084e2,%rdx
  802e99:	00 00 00 
  802e9c:	be f0 02 00 00       	mov    $0x2f0,%esi
  802ea1:	48 bf 55 84 80 00 00 	movabs $0x808455,%rdi
  802ea8:	00 00 00 
  802eab:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb0:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  802eb7:	00 00 00 
  802eba:	41 ff d0             	callq  *%r8

		//Replaying bitmap block
		for(i = 0; i < super->s_nblocks; i+=32)
  802ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802ec4:	eb 46                	jmp    802f0c <replay_journal+0x104>
                	bitmap[i/32] = itjournal->bmap[i/32];
  802ec6:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  802ecd:	00 00 00 
  802ed0:	48 8b 10             	mov    (%rax),%rdx
  802ed3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ed6:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	0f 48 c1             	cmovs  %ecx,%eax
  802ede:	c1 f8 05             	sar    $0x5,%eax
  802ee1:	48 98                	cltq   
  802ee3:	48 c1 e0 02          	shl    $0x2,%rax
  802ee7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802eeb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eee:	8d 50 1f             	lea    0x1f(%rax),%edx
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	0f 48 c2             	cmovs  %edx,%eax
  802ef6:	c1 f8 05             	sar    $0x5,%eax
  802ef9:	89 c2                	mov    %eax,%edx
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	48 63 d2             	movslq %edx,%rdx
  802f02:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
  802f06:	89 01                	mov    %eax,(%rcx)
		//cprintf("txbegin:%d\n",itjournal->txBegin);
		//i++;
		assert(itjournal->txBegin == itjournal->txEnd);

		//Replaying bitmap block
		for(i = 0; i < super->s_nblocks; i+=32)
  802f08:	83 45 f4 20          	addl   $0x20,-0xc(%rbp)
  802f0c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f0f:	48 b8 70 40 81 00 00 	movabs $0x814070,%rax
  802f16:	00 00 00 
  802f19:	48 8b 00             	mov    (%rax),%rax
  802f1c:	8b 40 04             	mov    0x4(%rax),%eax
  802f1f:	39 c2                	cmp    %eax,%edx
  802f21:	72 a3                	jb     802ec6 <replay_journal+0xbe>
                	bitmap[i/32] = itjournal->bmap[i/32];
	
	
		cprintf("\t[1/3] Writing file %s with data %s at offset %d...\n", itjournal->file.f_name, itjournal->buffer, itjournal->offset);
  802f23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f27:	8b 80 10 0a 00 00    	mov    0xa10(%rax),%eax
  802f2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f31:	48 81 c2 10 06 00 00 	add    $0x610,%rdx
  802f38:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f3c:	48 8d b1 04 05 00 00 	lea    0x504(%rcx),%rsi
  802f43:	89 c1                	mov    %eax,%ecx
  802f45:	48 bf a0 8a 80 00 00 	movabs $0x808aa0,%rdi
  802f4c:	00 00 00 
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f54:	49 b8 87 47 80 00 00 	movabs $0x804787,%r8
  802f5b:	00 00 00 
  802f5e:	41 ff d0             	callq  *%r8
		r = journal_file_write(&itjournal->file, itjournal->buffer, itjournal->count, itjournal->offset);
  802f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f65:	8b 90 10 0a 00 00    	mov    0xa10(%rax),%edx
  802f6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6f:	48 8b 80 08 06 00 00 	mov    0x608(%rax),%rax
  802f76:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f7a:	48 8d b1 10 06 00 00 	lea    0x610(%rcx),%rsi
  802f81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f85:	48 8d b9 04 05 00 00 	lea    0x504(%rcx),%rdi
  802f8c:	89 d1                	mov    %edx,%ecx
  802f8e:	48 89 c2             	mov    %rax,%rdx
  802f91:	48 b8 90 31 80 00 00 	movabs $0x803190,%rax
  802f98:	00 00 00 
  802f9b:	ff d0                	callq  *%rax
  802f9d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		file_flush(&itjournal->file);
  802fa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa4:	48 05 04 05 00 00    	add    $0x504,%rax
  802faa:	48 89 c7             	mov    %rax,%rdi
  802fad:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
		if(r < 0)
  802fb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802fbd:	79 25                	jns    802fe4 <replay_journal+0x1dc>
		{
			cprintf("journal_file-write failed:%e\n",r);
  802fbf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802fc2:	89 c6                	mov    %eax,%esi
  802fc4:	48 bf d5 8a 80 00 00 	movabs $0x808ad5,%rdi
  802fcb:	00 00 00 
  802fce:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd3:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  802fda:	00 00 00 
  802fdd:	ff d2                	callq  *%rdx
			continue;
  802fdf:	e9 26 01 00 00       	jmpq   80310a <replay_journal+0x302>
		}
		//cprintf("return value of journal_file_write:%d\n", r);
		cprintf("\t[2/3] File %s written with data %s at offset %d\n", itjournal->file.f_name, itjournal->buffer, itjournal->offset);
  802fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe8:	8b 80 10 0a 00 00    	mov    0xa10(%rax),%eax
  802fee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ff2:	48 81 c2 10 06 00 00 	add    $0x610,%rdx
  802ff9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ffd:	48 8d b1 04 05 00 00 	lea    0x504(%rcx),%rsi
  803004:	89 c1                	mov    %eax,%ecx
  803006:	48 bf f8 8a 80 00 00 	movabs $0x808af8,%rdi
  80300d:	00 00 00 
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	49 b8 87 47 80 00 00 	movabs $0x804787,%r8
  80301c:	00 00 00 
  80301f:	41 ff d0             	callq  *%r8
		success_counter += 1;
  803022:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
		
		char resultBuf[BLKSIZE/4];
		r = file_read(&itjournal->file, resultBuf, itjournal->count, itjournal->offset);
  803026:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302a:	8b 88 10 0a 00 00    	mov    0xa10(%rax),%ecx
  803030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803034:	48 8b 90 08 06 00 00 	mov    0x608(%rax),%rdx
  80303b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303f:	48 8d b8 04 05 00 00 	lea    0x504(%rax),%rdi
  803046:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  80304d:	48 89 c6             	mov    %rax,%rsi
  803050:	48 b8 9c 1f 80 00 00 	movabs $0x801f9c,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
  80305c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0 && (strcmp(resultBuf, itjournal->buffer) != 0))
  80305f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803063:	79 45                	jns    8030aa <replay_journal+0x2a2>
  803065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803069:	48 8d 90 10 06 00 00 	lea    0x610(%rax),%rdx
  803070:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  803077:	48 89 d6             	mov    %rdx,%rsi
  80307a:	48 89 c7             	mov    %rax,%rdi
  80307d:	48 b8 9f 54 80 00 00 	movabs $0x80549f,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 1d                	je     8030aa <replay_journal+0x2a2>
		{
			cprintf("file_read after journal_file_write failed\n");
  80308d:	48 bf 30 8b 80 00 00 	movabs $0x808b30,%rdi
  803094:	00 00 00 
  803097:	b8 00 00 00 00       	mov    $0x0,%eax
  80309c:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  8030a3:	00 00 00 
  8030a6:	ff d2                	callq  *%rdx
			continue;
  8030a8:	eb 60                	jmp    80310a <replay_journal+0x302>
		}
		cprintf("\tresult of file_read after journal write:%s\n", resultBuf);
  8030aa:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8030b1:	48 89 c6             	mov    %rax,%rsi
  8030b4:	48 bf 60 8b 80 00 00 	movabs $0x808b60,%rdi
  8030bb:	00 00 00 
  8030be:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c3:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  8030ca:	00 00 00 
  8030cd:	ff d2                	callq  *%rdx
		cprintf("\t[3/3] file_read after journal_file_write successful\n");
  8030cf:	48 bf 90 8b 80 00 00 	movabs $0x808b90,%rdi
  8030d6:	00 00 00 
  8030d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030de:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  8030e5:	00 00 00 
  8030e8:	ff d2                	callq  *%rdx
		cprintf("Replaying journal record %d complete\n\n\n",journal_counter);
  8030ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ed:	89 c6                	mov    %eax,%esi
  8030ef:	48 bf c8 8b 80 00 00 	movabs $0x808bc8,%rdi
  8030f6:	00 00 00 
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fe:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803105:	00 00 00 
  803108:	ff d2                	callq  *%rdx
void replay_journal()
{
	int journal_counter, success_counter, r, i;
	cprintf("Replaying journal records...\n");
	struct Journal *itjournal = (struct Journal *)(journal);
	for(journal_counter = 0, success_counter = 0;itjournal->txBegin==1;itjournal++, journal_counter++)
  80310a:	48 81 45 e8 18 0a 00 	addq   $0xa18,-0x18(%rbp)
  803111:	00 
  803112:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311a:	0f b6 00             	movzbl (%rax),%eax
  80311d:	3c 01                	cmp    $0x1,%al
  80311f:	0f 84 2d fd ff ff    	je     802e52 <replay_journal+0x4a>
		}
		cprintf("\tresult of file_read after journal write:%s\n", resultBuf);
		cprintf("\t[3/3] file_read after journal_file_write successful\n");
		cprintf("Replaying journal record %d complete\n\n\n",journal_counter);
	}
	cprintf("Number of journal records\t\t\t:%d\n", journal_counter);
  803125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803128:	89 c6                	mov    %eax,%esi
  80312a:	48 bf f0 8b 80 00 00 	movabs $0x808bf0,%rdi
  803131:	00 00 00 
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
  803139:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803140:	00 00 00 
  803143:	ff d2                	callq  *%rdx
	cprintf("Number of records successfully replayed\t\t:%d\n", success_counter);
  803145:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803148:	89 c6                	mov    %eax,%esi
  80314a:	48 bf 18 8c 80 00 00 	movabs $0x808c18,%rdi
  803151:	00 00 00 
  803154:	b8 00 00 00 00       	mov    $0x0,%eax
  803159:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803160:	00 00 00 
  803163:	ff d2                	callq  *%rdx
	cprintf("Number of records unsuccessfully replayed\t:%d\n\n\n", journal_counter - success_counter); 
  803165:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803168:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80316b:	89 d1                	mov    %edx,%ecx
  80316d:	29 c1                	sub    %eax,%ecx
  80316f:	89 c8                	mov    %ecx,%eax
  803171:	89 c6                	mov    %eax,%esi
  803173:	48 bf 48 8c 80 00 00 	movabs $0x808c48,%rdi
  80317a:	00 00 00 
  80317d:	b8 00 00 00 00       	mov    $0x0,%eax
  803182:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803189:	00 00 00 
  80318c:	ff d2                	callq  *%rdx
}
  80318e:	c9                   	leaveq 
  80318f:	c3                   	retq   

0000000000803190 <journal_file_write>:

int
journal_file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  803190:	55                   	push   %rbp
  803191:	48 89 e5             	mov    %rsp,%rbp
  803194:	48 83 ec 50          	sub    $0x50,%rsp
  803198:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80319c:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8031a0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8031a4:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
        off_t pos;
        char *blk;

	//cprintf("Received journal_file_write request for file pointer:%08x\tbuffer:%08x\tcount:%d\toffset:%d\n", f, buf, count, offset); 
        // Extend file if necessary
        if (offset + count > f->f_size)
  8031a7:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8031aa:	48 98                	cltq   
  8031ac:	48 89 c2             	mov    %rax,%rdx
  8031af:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  8031b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031b7:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8031bd:	48 98                	cltq   
  8031bf:	48 39 c2             	cmp    %rax,%rdx
  8031c2:	76 33                	jbe    8031f7 <journal_file_write+0x67>
	{
		//cprintf("offset + count > f->f_size");
                if ((r = file_set_size(f, offset + count)) < 0)
  8031c4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8031c8:	89 c2                	mov    %eax,%edx
  8031ca:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8031cd:	01 d0                	add    %edx,%eax
  8031cf:	89 c2                	mov    %eax,%edx
  8031d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031d5:	89 d6                	mov    %edx,%esi
  8031d7:	48 89 c7             	mov    %rax,%rdi
  8031da:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8031e1:	00 00 00 
  8031e4:	ff d0                	callq  *%rax
  8031e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031e9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031ed:	79 08                	jns    8031f7 <journal_file_write+0x67>
                        return r;
  8031ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031f2:	e9 01 01 00 00       	jmpq   8032f8 <journal_file_write+0x168>
	}
        for (pos = offset; pos < offset + count; ) 
  8031f7:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8031fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fd:	e9 da 00 00 00       	jmpq   8032dc <journal_file_write+0x14c>
	{
                if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803205:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80320b:	85 c0                	test   %eax,%eax
  80320d:	0f 48 c2             	cmovs  %edx,%eax
  803210:	c1 f8 0c             	sar    $0xc,%eax
  803213:	89 c1                	mov    %eax,%ecx
  803215:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803219:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80321d:	89 ce                	mov    %ecx,%esi
  80321f:	48 89 c7             	mov    %rax,%rdi
  803222:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  803229:	00 00 00 
  80322c:	ff d0                	callq  *%rax
  80322e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803231:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803235:	79 08                	jns    80323f <journal_file_write+0xaf>
                        return r;
  803237:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323a:	e9 b9 00 00 00       	jmpq   8032f8 <journal_file_write+0x168>
		//cprintf("file_get_block successful. blk:%08x\n",blk);
                bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80323f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803242:	89 c2                	mov    %eax,%edx
  803244:	c1 fa 1f             	sar    $0x1f,%edx
  803247:	c1 ea 14             	shr    $0x14,%edx
  80324a:	01 d0                	add    %edx,%eax
  80324c:	25 ff 0f 00 00       	and    $0xfff,%eax
  803251:	29 d0                	sub    %edx,%eax
  803253:	ba 00 10 00 00       	mov    $0x1000,%edx
  803258:	89 d1                	mov    %edx,%ecx
  80325a:	29 c1                	sub    %eax,%ecx
  80325c:	89 c8                	mov    %ecx,%eax
  80325e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803261:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  803264:	48 98                	cltq   
  803266:	48 89 c2             	mov    %rax,%rdx
  803269:	48 03 55 b8          	add    -0x48(%rbp),%rdx
  80326d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803270:	48 98                	cltq   
  803272:	48 89 d1             	mov    %rdx,%rcx
  803275:	48 29 c1             	sub    %rax,%rcx
  803278:	48 89 c8             	mov    %rcx,%rax
  80327b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80327f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803282:	48 63 d0             	movslq %eax,%rdx
  803285:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803289:	48 39 c2             	cmp    %rax,%rdx
  80328c:	48 0f 46 c2          	cmovbe %rdx,%rax
  803290:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		//cprintf("blk+pos%BLKSIZE=%08x\t buf=%08x\t bn=%d\n", blk+pos%BLKSIZE, buf, bn);
                memmove(blk + pos % BLKSIZE, buf, bn);
  803293:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803296:	48 63 c8             	movslq %eax,%rcx
  803299:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  80329d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a0:	89 c2                	mov    %eax,%edx
  8032a2:	c1 fa 1f             	sar    $0x1f,%edx
  8032a5:	c1 ea 14             	shr    $0x14,%edx
  8032a8:	01 d0                	add    %edx,%eax
  8032aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  8032af:	29 d0                	sub    %edx,%eax
  8032b1:	48 98                	cltq   
  8032b3:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  8032b7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032bb:	48 89 ca             	mov    %rcx,%rdx
  8032be:	48 89 c6             	mov    %rax,%rsi
  8032c1:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8032c8:	00 00 00 
  8032cb:	ff d0                	callq  *%rax
		//cprintf("memmove successful\n");
                pos += bn;
  8032cd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8032d0:	01 45 fc             	add    %eax,-0x4(%rbp)
                buf += bn;
  8032d3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8032d6:	48 98                	cltq   
  8032d8:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	{
		//cprintf("offset + count > f->f_size");
                if ((r = file_set_size(f, offset + count)) < 0)
                        return r;
	}
        for (pos = offset; pos < offset + count; ) 
  8032dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032df:	48 63 d0             	movslq %eax,%rdx
  8032e2:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8032e5:	48 98                	cltq   
  8032e7:	48 03 45 b8          	add    -0x48(%rbp),%rax
  8032eb:	48 39 c2             	cmp    %rax,%rdx
  8032ee:	0f 82 0e ff ff ff    	jb     803202 <journal_file_write+0x72>
		//cprintf("memmove successful\n");
                pos += bn;
                buf += bn;
        }

        return count;
  8032f4:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  8032f8:	c9                   	leaveq 
  8032f9:	c3                   	retq   

00000000008032fa <get_journal_size>:

int get_journal_size()
{
  8032fa:	55                   	push   %rbp
  8032fb:	48 89 e5             	mov    %rsp,%rbp
  8032fe:	48 83 ec 10          	sub    $0x10,%rsp
	struct Journal *itjournal = (struct Journal *)(journal);
  803302:	48 b8 78 40 81 00 00 	movabs $0x814078,%rax
  803309:	00 00 00 
  80330c:	48 8b 00             	mov    (%rax),%rax
  80330f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int journal_counter;
        for(journal_counter = 0; itjournal->txBegin==1; itjournal++,journal_counter++);
  803313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80331a:	eb 0c                	jmp    803328 <get_journal_size+0x2e>
  80331c:	48 81 45 f8 18 0a 00 	addq   $0xa18,-0x8(%rbp)
  803323:	00 
  803324:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80332c:	0f b6 00             	movzbl (%rax),%eax
  80332f:	3c 01                	cmp    $0x1,%al
  803331:	74 e9                	je     80331c <get_journal_size+0x22>
        return journal_counter;
  803333:	8b 45 f4             	mov    -0xc(%rbp),%eax
}
  803336:	c9                   	leaveq 
  803337:	c3                   	retq   

0000000000803338 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  803338:	55                   	push   %rbp
  803339:	48 89 e5             	mov    %rsp,%rbp
  80333c:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  803340:	c7 45 f0 00 00 00 d0 	movl   $0xd0000000,-0x10(%rbp)
  803347:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  80334e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803355:	eb 4b                	jmp    8033a2 <serve_init+0x6a>
		opentab[i].o_fileid = i;
  803357:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335a:	48 ba 20 b0 80 00 00 	movabs $0x80b020,%rdx
  803361:	00 00 00 
  803364:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  803367:	48 63 c9             	movslq %ecx,%rcx
  80336a:	48 c1 e1 05          	shl    $0x5,%rcx
  80336e:	48 01 ca             	add    %rcx,%rdx
  803371:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  803373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803377:	48 ba 20 b0 80 00 00 	movabs $0x80b020,%rdx
  80337e:	00 00 00 
  803381:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  803384:	48 63 c9             	movslq %ecx,%rcx
  803387:	48 c1 e1 05          	shl    $0x5,%rcx
  80338b:	48 01 ca             	add    %rcx,%rdx
  80338e:	48 83 c2 10          	add    $0x10,%rdx
  803392:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  803396:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  80339d:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80339e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033a2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8033a9:	7e ac                	jle    803357 <serve_init+0x1f>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  8033ab:	c9                   	leaveq 
  8033ac:	c3                   	retq   

00000000008033ad <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  8033ad:	55                   	push   %rbp
  8033ae:	48 89 e5             	mov    %rsp,%rbp
  8033b1:	48 83 ec 20          	sub    $0x20,%rsp
  8033b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8033b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033c0:	e9 24 01 00 00       	jmpq   8034e9 <openfile_alloc+0x13c>
		switch (pageref(opentab[i].o_fd)) {
  8033c5:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  8033cc:	00 00 00 
  8033cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033d2:	48 63 d2             	movslq %edx,%rdx
  8033d5:	48 c1 e2 05          	shl    $0x5,%rdx
  8033d9:	48 01 d0             	add    %rdx,%rax
  8033dc:	48 83 c0 10          	add    $0x10,%rax
  8033e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8033e4:	48 89 c7             	mov    %rax,%rdi
  8033e7:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	74 0a                	je     803401 <openfile_alloc+0x54>
  8033f7:	83 f8 01             	cmp    $0x1,%eax
  8033fa:	74 4e                	je     80344a <openfile_alloc+0x9d>
  8033fc:	e9 e4 00 00 00       	jmpq   8034e5 <openfile_alloc+0x138>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  803401:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803408:	00 00 00 
  80340b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80340e:	48 63 d2             	movslq %edx,%rdx
  803411:	48 c1 e2 05          	shl    $0x5,%rdx
  803415:	48 01 d0             	add    %rdx,%rax
  803418:	48 83 c0 10          	add    $0x10,%rax
  80341c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803420:	ba 07 00 00 00       	mov    $0x7,%edx
  803425:	48 89 c6             	mov    %rax,%rsi
  803428:	bf 00 00 00 00       	mov    $0x0,%edi
  80342d:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  803434:	00 00 00 
  803437:	ff d0                	callq  *%rax
  803439:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80343c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803440:	79 08                	jns    80344a <openfile_alloc+0x9d>
				return r;
  803442:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803445:	e9 b1 00 00 00       	jmpq   8034fb <openfile_alloc+0x14e>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  80344a:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803451:	00 00 00 
  803454:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803457:	48 63 d2             	movslq %edx,%rdx
  80345a:	48 c1 e2 05          	shl    $0x5,%rdx
  80345e:	48 01 d0             	add    %rdx,%rax
  803461:	8b 00                	mov    (%rax),%eax
  803463:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  803469:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803470:	00 00 00 
  803473:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  803476:	48 63 c9             	movslq %ecx,%rcx
  803479:	48 c1 e1 05          	shl    $0x5,%rcx
  80347d:	48 01 c8             	add    %rcx,%rax
  803480:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  803482:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803485:	48 98                	cltq   
  803487:	48 89 c2             	mov    %rax,%rdx
  80348a:	48 c1 e2 05          	shl    $0x5,%rdx
  80348e:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803495:	00 00 00 
  803498:	48 01 c2             	add    %rax,%rdx
  80349b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349f:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8034a2:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  8034a9:	00 00 00 
  8034ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034af:	48 63 d2             	movslq %edx,%rdx
  8034b2:	48 c1 e2 05          	shl    $0x5,%rdx
  8034b6:	48 01 d0             	add    %rdx,%rax
  8034b9:	48 83 c0 10          	add    $0x10,%rax
  8034bd:	48 8b 40 08          	mov    0x8(%rax),%rax
  8034c1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8034c6:	be 00 00 00 00       	mov    $0x0,%esi
  8034cb:	48 89 c7             	mov    %rax,%rdi
  8034ce:	48 b8 db 55 80 00 00 	movabs $0x8055db,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8034da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034de:	48 8b 00             	mov    (%rax),%rax
  8034e1:	8b 00                	mov    (%rax),%eax
  8034e3:	eb 16                	jmp    8034fb <openfile_alloc+0x14e>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8034e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8034e9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8034f0:	0f 8e cf fe ff ff    	jle    8033c5 <openfile_alloc+0x18>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8034f6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8034fb:	c9                   	leaveq 
  8034fc:	c3                   	retq   

00000000008034fd <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 20          	sub    $0x20,%rsp
  803505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803508:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80350b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80350f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803512:	25 ff 03 00 00       	and    $0x3ff,%eax
  803517:	48 89 c2             	mov    %rax,%rdx
  80351a:	48 c1 e2 05          	shl    $0x5,%rdx
  80351e:	48 b8 20 b0 80 00 00 	movabs $0x80b020,%rax
  803525:	00 00 00 
  803528:	48 01 d0             	add    %rdx,%rax
  80352b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80352f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803533:	48 8b 40 18          	mov    0x18(%rax),%rax
  803537:	48 89 c7             	mov    %rax,%rdi
  80353a:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  803541:	00 00 00 
  803544:	ff d0                	callq  *%rax
  803546:	83 f8 01             	cmp    $0x1,%eax
  803549:	74 0b                	je     803556 <openfile_lookup+0x59>
  80354b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354f:	8b 00                	mov    (%rax),%eax
  803551:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803554:	74 07                	je     80355d <openfile_lookup+0x60>
		return -E_INVAL;
  803556:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80355b:	eb 10                	jmp    80356d <openfile_lookup+0x70>
	*po = o;
  80355d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803561:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803565:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  803568:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  80357a:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  803580:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  803587:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  80358e:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  803595:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  80359c:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8035a3:	ba 00 04 00 00       	mov    $0x400,%edx
  8035a8:	48 89 ce             	mov    %rcx,%rsi
  8035ab:	48 89 c7             	mov    %rax,%rdi
  8035ae:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8035b5:	00 00 00 
  8035b8:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8035ba:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8035be:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8035c5:	48 89 c7             	mov    %rax,%rdi
  8035c8:	48 b8 ad 33 80 00 00 	movabs $0x8033ad,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
  8035d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035db:	79 08                	jns    8035e5 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  8035dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e0:	e9 7b 01 00 00       	jmpq   803760 <serve_open+0x1f1>
	}
	fileid = r;
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  8035eb:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8035f2:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8035f8:	25 00 01 00 00       	and    $0x100,%eax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	74 4e                	je     80364f <serve_open+0xe0>
		if ((r = file_create(path, &f)) < 0) {
  803601:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  803608:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80360f:	48 89 d6             	mov    %rdx,%rsi
  803612:	48 89 c7             	mov    %rax,%rdi
  803615:	48 b8 7f 1e 80 00 00 	movabs $0x801e7f,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
  803621:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803624:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803628:	79 56                	jns    803680 <serve_open+0x111>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80362a:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  803631:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  803637:	25 00 04 00 00       	and    $0x400,%eax
  80363c:	85 c0                	test   %eax,%eax
  80363e:	75 06                	jne    803646 <serve_open+0xd7>
  803640:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  803644:	74 08                	je     80364e <serve_open+0xdf>
				goto try_open;
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  803646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803649:	e9 12 01 00 00       	jmpq   803760 <serve_open+0x1f1>

	// Open the file
	if (req->req_omode & O_CREAT) {
		if ((r = file_create(path, &f)) < 0) {
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
				goto try_open;
  80364e:	90                   	nop
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80364f:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  803656:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80365d:	48 89 d6             	mov    %rdx,%rsi
  803660:	48 89 c7             	mov    %rax,%rdi
  803663:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  80366a:	00 00 00 
  80366d:	ff d0                	callq  *%rax
  80366f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803672:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803676:	79 08                	jns    803680 <serve_open+0x111>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  803678:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367b:	e9 e0 00 00 00       	jmpq   803760 <serve_open+0x1f1>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  803680:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  803687:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80368d:	25 00 02 00 00       	and    $0x200,%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	74 2c                	je     8036c2 <serve_open+0x153>
		if ((r = file_set_size(f, 0)) < 0) {
  803696:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  80369d:	be 00 00 00 00       	mov    $0x0,%esi
  8036a2:	48 89 c7             	mov    %rax,%rdi
  8036a5:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
  8036b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b8:	79 08                	jns    8036c2 <serve_open+0x153>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8036ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bd:	e9 9e 00 00 00       	jmpq   803760 <serve_open+0x1f1>
		}
	}

	// Save the file pointer
	o->o_file = f;
  8036c2:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8036c9:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  8036d0:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8036d4:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8036db:	48 8b 40 18          	mov    0x18(%rax),%rax
  8036df:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  8036e6:	8b 12                	mov    (%rdx),%edx
  8036e8:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8036eb:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8036f2:	48 8b 40 18          	mov    0x18(%rax),%rax
  8036f6:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8036fd:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  803703:	83 e2 03             	and    $0x3,%edx
  803706:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  803709:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  803710:	48 8b 40 18          	mov    0x18(%rax),%rax
  803714:	48 ba e0 30 81 00 00 	movabs $0x8130e0,%rdx
  80371b:	00 00 00 
  80371e:	8b 12                	mov    (%rdx),%edx
  803720:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  803722:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  803729:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  803730:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  803736:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  803739:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  803740:	48 8b 50 18          	mov    0x18(%rax),%rdx
  803744:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  80374b:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  80374e:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  803755:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80375b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803760:	c9                   	leaveq 
  803761:	c3                   	retq   

0000000000803762 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  803762:	55                   	push   %rbp
  803763:	48 89 e5             	mov    %rsp,%rbp
  803766:	48 83 ec 20          	sub    $0x20,%rsp
  80376a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80376d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  803771:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803775:	8b 00                	mov    (%rax),%eax
  803777:	89 c1                	mov    %eax,%ecx
  803779:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80377d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803780:	89 ce                	mov    %ecx,%esi
  803782:	89 c7                	mov    %eax,%edi
  803784:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  80378b:	00 00 00 
  80378e:	ff d0                	callq  *%rax
  803790:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803793:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803797:	79 05                	jns    80379e <serve_set_size+0x3c>
		return r;
  803799:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379c:	eb 20                	jmp    8037be <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80379e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a2:	8b 50 04             	mov    0x4(%rax),%edx
  8037a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	48 89 c7             	mov    %rax,%rdi
  8037b2:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  8037b9:	00 00 00 
  8037bc:	ff d0                	callq  *%rax
}
  8037be:	c9                   	leaveq 
  8037bf:	c3                   	retq   

00000000008037c0 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 40          	sub    $0x40,%rsp
  8037c8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8037cb:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  8037cf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  8037d7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037db:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	
	ssize_t nBytes;
	int count = req->req_n;
  8037df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(count>PGSIZE)
  8037ea:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8037f1:	7e 07                	jle    8037fa <serve_read+0x3a>
		count=PGSIZE;
  8037f3:	c7 45 fc 00 10 00 00 	movl   $0x1000,-0x4(%rbp)
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8037fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fe:	8b 00                	mov    (%rax),%eax
  803800:	89 c1                	mov    %eax,%ecx
  803802:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803806:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803809:	89 ce                	mov    %ecx,%esi
  80380b:	89 c7                	mov    %eax,%edi
  80380d:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  803814:	00 00 00 
  803817:	ff d0                	callq  *%rax
  803819:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80381c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803820:	79 05                	jns    803827 <serve_read+0x67>
                return r;
  803822:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803825:	eb 56                	jmp    80387d <serve_read+0xbd>
		
	nBytes=file_read(o->o_file, ret->ret_buf, count, o->o_fd->fd_offset);
  803827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80382f:	8b 48 04             	mov    0x4(%rax),%ecx
  803832:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803835:	48 63 d0             	movslq %eax,%rdx
  803838:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  80383c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803840:	48 8b 40 08          	mov    0x8(%rax),%rax
  803844:	48 89 c7             	mov    %rax,%rdi
  803847:	48 b8 9c 1f 80 00 00 	movabs $0x801f9c,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
  803853:	89 45 e0             	mov    %eax,-0x20(%rbp)
	if(nBytes < 0)
  803856:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80385a:	79 05                	jns    803861 <serve_read+0xa1>
		return nBytes;
  80385c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80385f:	eb 1c                	jmp    80387d <serve_read+0xbd>
	o->o_fd->fd_offset += nBytes;
  803861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803865:	48 8b 40 18          	mov    0x18(%rax),%rax
  803869:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80386d:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  803871:	8b 52 04             	mov    0x4(%rdx),%edx
  803874:	03 55 e0             	add    -0x20(%rbp),%edx
  803877:	89 50 04             	mov    %edx,0x4(%rax)
	return nBytes;
  80387a:	8b 45 e0             	mov    -0x20(%rbp),%eax


}
  80387d:	c9                   	leaveq 
  80387e:	c3                   	retq   

000000000080387f <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80387f:	55                   	push   %rbp
  803880:	48 89 e5             	mov    %rsp,%rbp
  803883:	48 83 ec 20          	sub    $0x20,%rsp
  803887:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80388a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

  	struct OpenFile *o;
        int r,nBytes;

        if((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80388e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803892:	8b 00                	mov    (%rax),%eax
  803894:	89 c1                	mov    %eax,%ecx
  803896:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80389a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389d:	89 ce                	mov    %ecx,%esi
  80389f:	89 c7                	mov    %eax,%edi
  8038a1:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
  8038ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b4:	79 05                	jns    8038bb <serve_write+0x3c>
                return r;
  8038b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b9:	eb 5c                	jmp    803917 <serve_write+0x98>

	nBytes = file_write(o->o_file,req->req_buf,req->req_n, o->o_fd->fd_offset);
  8038bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8038c3:	8b 48 04             	mov    0x4(%rax),%ecx
  8038c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ca:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8038ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d2:	48 8d 70 10          	lea    0x10(%rax),%rsi
  8038d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038da:	48 8b 40 08          	mov    0x8(%rax),%rax
  8038de:	48 89 c7             	mov    %rax,%rdi
  8038e1:	48 b8 fb 20 80 00 00 	movabs $0x8020fb,%rax
  8038e8:	00 00 00 
  8038eb:	ff d0                	callq  *%rax
  8038ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if(nBytes <0)        
  8038f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038f4:	79 05                	jns    8038fb <serve_write+0x7c>
		return nBytes;
  8038f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038f9:	eb 1c                	jmp    803917 <serve_write+0x98>

        o->o_fd->fd_offset += nBytes;
  8038fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ff:	48 8b 40 18          	mov    0x18(%rax),%rax
  803903:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803907:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  80390b:	8b 52 04             	mov    0x4(%rdx),%edx
  80390e:	03 55 f8             	add    -0x8(%rbp),%edx
  803911:	89 50 04             	mov    %edx,0x4(%rax)
        return nBytes;
  803914:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 30          	sub    $0x30,%rsp
  803921:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803924:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  803928:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80392c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  803930:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803934:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  803938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80393c:	8b 00                	mov    (%rax),%eax
  80393e:	89 c1                	mov    %eax,%ecx
  803940:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  803944:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803947:	89 ce                	mov    %ecx,%esi
  803949:	89 c7                	mov    %eax,%edi
  80394b:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
  803957:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80395a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80395e:	79 05                	jns    803965 <serve_stat+0x4c>
		return r;
  803960:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803963:	eb 5f                	jmp    8039c4 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  803965:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803969:	48 8b 40 08          	mov    0x8(%rax),%rax
  80396d:	48 89 c2             	mov    %rax,%rdx
  803970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803974:	48 89 d6             	mov    %rdx,%rsi
  803977:	48 89 c7             	mov    %rax,%rdi
  80397a:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  803981:	00 00 00 
  803984:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  803986:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80398a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80398e:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803994:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803998:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80399e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8039a6:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8039ac:	83 f8 01             	cmp    $0x1,%eax
  8039af:	0f 94 c0             	sete   %al
  8039b2:	0f b6 d0             	movzbl %al,%edx
  8039b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039b9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8039bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039c4:	c9                   	leaveq 
  8039c5:	c3                   	retq   

00000000008039c6 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8039c6:	55                   	push   %rbp
  8039c7:	48 89 e5             	mov    %rsp,%rbp
  8039ca:	48 83 ec 20          	sub    $0x20,%rsp
  8039ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8039d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d9:	8b 00                	mov    (%rax),%eax
  8039db:	89 c1                	mov    %eax,%ecx
  8039dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8039e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e4:	89 ce                	mov    %ecx,%esi
  8039e6:	89 c7                	mov    %eax,%edi
  8039e8:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  8039ef:	00 00 00 
  8039f2:	ff d0                	callq  *%rax
  8039f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039fb:	79 05                	jns    803a02 <serve_flush+0x3c>
		return r;
  8039fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a00:	eb 1c                	jmp    803a1e <serve_flush+0x58>
	file_flush(o->o_file);
  803a02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a06:	48 8b 40 08          	mov    0x8(%rax),%rax
  803a0a:	48 89 c7             	mov    %rax,%rdi
  803a0d:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
	return 0;
  803a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a1e:	c9                   	leaveq 
  803a1f:	c3                   	retq   

0000000000803a20 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  803a20:	55                   	push   %rbp
  803a21:	48 89 e5             	mov    %rsp,%rbp
  803a24:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  803a2b:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  803a31:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  803a38:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  803a3f:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  803a46:	ba 00 04 00 00       	mov    $0x400,%edx
  803a4b:	48 89 ce             	mov    %rcx,%rsi
  803a4e:	48 89 c7             	mov    %rax,%rdi
  803a51:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  803a58:	00 00 00 
  803a5b:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  803a5d:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  803a61:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  803a68:	48 89 c7             	mov    %rax,%rdi
  803a6b:	48 b8 71 25 80 00 00 	movabs $0x802571,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
}
  803a77:	c9                   	leaveq 
  803a78:	c3                   	retq   

0000000000803a79 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  803a79:	55                   	push   %rbp
  803a7a:	48 89 e5             	mov    %rsp,%rbp
  803a7d:	48 83 ec 10          	sub    $0x10,%rsp
  803a81:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  803a88:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
	return 0;
  803a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a99:	c9                   	leaveq 
  803a9a:	c3                   	retq   

0000000000803a9b <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  803a9b:	55                   	push   %rbp
  803a9c:	48 89 e5             	mov    %rsp,%rbp
  803a9f:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  803aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  803aaa:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  803ab1:	00 00 00 
  803ab4:	48 8b 08             	mov    (%rax),%rcx
  803ab7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803abb:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  803abf:	48 89 ce             	mov    %rcx,%rsi
  803ac2:	48 89 c7             	mov    %rax,%rdi
  803ac5:	48 b8 0c 61 80 00 00 	movabs $0x80610c,%rax
  803acc:	00 00 00 
  803acf:	ff d0                	callq  *%rax
  803ad1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  803ad4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ad7:	83 e0 01             	and    $0x1,%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	75 23                	jne    803b01 <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  803ade:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ae1:	89 c6                	mov    %eax,%esi
  803ae3:	48 bf 80 8c 80 00 00 	movabs $0x808c80,%rdi
  803aea:	00 00 00 
  803aed:	b8 00 00 00 00       	mov    $0x0,%eax
  803af2:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803af9:	00 00 00 
  803afc:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  803afe:	90                   	nop
			cprintf("Invalid request code %d from %08x\n", req, whom);
			r = -E_INVAL;
		}
		ipc_send(whom, r, pg, perm);
		sys_page_unmap(0, fsreq);
	}
  803aff:	eb a2                	jmp    803aa3 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  803b01:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803b08:	00 
		if (req == FSREQ_OPEN) {
  803b09:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  803b0d:	75 2b                	jne    803b3a <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  803b0f:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  803b16:	00 00 00 
  803b19:	48 8b 30             	mov    (%rax),%rsi
  803b1c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b1f:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  803b23:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b27:	89 c7                	mov    %eax,%edi
  803b29:	48 b8 6f 35 80 00 00 	movabs $0x80356f,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
  803b35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b38:	eb 73                	jmp    803bad <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  803b3a:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  803b3e:	77 43                	ja     803b83 <serve+0xe8>
  803b40:	48 b8 40 30 81 00 00 	movabs $0x813040,%rax
  803b47:	00 00 00 
  803b4a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b4d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b51:	48 85 c0             	test   %rax,%rax
  803b54:	74 2d                	je     803b83 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  803b56:	48 b8 40 30 81 00 00 	movabs $0x813040,%rax
  803b5d:	00 00 00 
  803b60:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b63:	48 8b 0c d0          	mov    (%rax,%rdx,8),%rcx
  803b67:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  803b6e:	00 00 00 
  803b71:	48 8b 10             	mov    (%rax),%rdx
  803b74:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b77:	48 89 d6             	mov    %rdx,%rsi
  803b7a:	89 c7                	mov    %eax,%edi
  803b7c:	ff d1                	callq  *%rcx
  803b7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b81:	eb 2a                	jmp    803bad <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  803b83:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b86:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b89:	89 c6                	mov    %eax,%esi
  803b8b:	48 bf b0 8c 80 00 00 	movabs $0x808cb0,%rdi
  803b92:	00 00 00 
  803b95:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9a:	48 b9 87 47 80 00 00 	movabs $0x804787,%rcx
  803ba1:	00 00 00 
  803ba4:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  803ba6:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  803bad:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  803bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803bb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803bba:	89 c7                	mov    %eax,%edi
  803bbc:	48 b8 cc 61 80 00 00 	movabs $0x8061cc,%rax
  803bc3:	00 00 00 
  803bc6:	ff d0                	callq  *%rax
		sys_page_unmap(0, fsreq);
  803bc8:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  803bcf:	00 00 00 
  803bd2:	48 8b 00             	mov    (%rax),%rax
  803bd5:	48 89 c6             	mov    %rax,%rsi
  803bd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bdd:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
	}
  803be9:	e9 b5 fe ff ff       	jmpq   803aa3 <serve+0x8>

0000000000803bee <umain>:
}

void
umain(int argc, char **argv)
{
  803bee:	55                   	push   %rbp
  803bef:	48 89 e5             	mov    %rsp,%rbp
  803bf2:	48 83 ec 20          	sub    $0x20,%rsp
  803bf6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bf9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  803bfd:	48 b8 90 30 81 00 00 	movabs $0x813090,%rax
  803c04:	00 00 00 
  803c07:	48 ba d3 8c 80 00 00 	movabs $0x808cd3,%rdx
  803c0e:	00 00 00 
  803c11:	48 89 10             	mov    %rdx,(%rax)
	cprintf("FS is running\n");
  803c14:	48 bf d6 8c 80 00 00 	movabs $0x808cd6,%rdi
  803c1b:	00 00 00 
  803c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c23:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803c2a:	00 00 00 
  803c2d:	ff d2                	callq  *%rdx
  803c2f:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  803c36:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  803c3c:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  803c40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c43:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  803c45:	48 bf e5 8c 80 00 00 	movabs $0x808ce5,%rdi
  803c4c:	00 00 00 
  803c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c54:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803c5b:	00 00 00 
  803c5e:	ff d2                	callq  *%rdx

	serve_init();
  803c60:	48 b8 38 33 80 00 00 	movabs $0x803338,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
	fs_init();
  803c6c:	48 b8 57 16 80 00 00 	movabs $0x801657,%rax
  803c73:	00 00 00 
  803c76:	ff d0                	callq  *%rax
	serve();
  803c78:	48 b8 9b 3a 80 00 00 	movabs $0x803a9b,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
}
  803c84:	c9                   	leaveq 
  803c85:	c3                   	retq   
	...

0000000000803c88 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  803c88:	55                   	push   %rbp
  803c89:	48 89 e5             	mov    %rsp,%rbp
  803c8c:	53                   	push   %rbx
  803c8d:	48 83 ec 28          	sub    $0x28,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  803c91:	ba 07 00 00 00       	mov    $0x7,%edx
  803c96:	be 00 10 00 00       	mov    $0x1000,%esi
  803c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803ca0:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
  803cac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803caf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803cb3:	79 30                	jns    803ce5 <fs_test+0x5d>
		panic("sys_page_alloc: %e", r);
  803cb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb8:	89 c1                	mov    %eax,%ecx
  803cba:	48 ba 1e 8d 80 00 00 	movabs $0x808d1e,%rdx
  803cc1:	00 00 00 
  803cc4:	be 13 00 00 00       	mov    $0x13,%esi
  803cc9:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803cd0:	00 00 00 
  803cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd8:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803cdf:	00 00 00 
  803ce2:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  803ce5:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  803cec:	00 
	memmove(bits, bitmap, PGSIZE);
  803ced:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  803cf4:	00 00 00 
  803cf7:	48 8b 08             	mov    (%rax),%rcx
  803cfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cfe:	ba 00 10 00 00       	mov    $0x1000,%edx
  803d03:	48 89 ce             	mov    %rcx,%rsi
  803d06:	48 89 c7             	mov    %rax,%rdi
  803d09:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  803d15:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
  803d21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d28:	79 30                	jns    803d5a <fs_test+0xd2>
		panic("alloc_block: %e", r);
  803d2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d2d:	89 c1                	mov    %eax,%ecx
  803d2f:	48 ba 3b 8d 80 00 00 	movabs $0x808d3b,%rdx
  803d36:	00 00 00 
  803d39:	be 18 00 00 00       	mov    $0x18,%esi
  803d3e:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803d45:	00 00 00 
  803d48:	b8 00 00 00 00       	mov    $0x0,%eax
  803d4d:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803d54:	00 00 00 
  803d57:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  803d5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5d:	8d 50 1f             	lea    0x1f(%rax),%edx
  803d60:	85 c0                	test   %eax,%eax
  803d62:	0f 48 c2             	cmovs  %edx,%eax
  803d65:	c1 f8 05             	sar    $0x5,%eax
  803d68:	48 98                	cltq   
  803d6a:	48 c1 e0 02          	shl    $0x2,%rax
  803d6e:	48 03 45 e0          	add    -0x20(%rbp),%rax
  803d72:	8b 30                	mov    (%rax),%esi
  803d74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d77:	89 c2                	mov    %eax,%edx
  803d79:	c1 fa 1f             	sar    $0x1f,%edx
  803d7c:	c1 ea 1b             	shr    $0x1b,%edx
  803d7f:	01 d0                	add    %edx,%eax
  803d81:	83 e0 1f             	and    $0x1f,%eax
  803d84:	29 d0                	sub    %edx,%eax
  803d86:	ba 01 00 00 00       	mov    $0x1,%edx
  803d8b:	89 d3                	mov    %edx,%ebx
  803d8d:	89 c1                	mov    %eax,%ecx
  803d8f:	d3 e3                	shl    %cl,%ebx
  803d91:	89 d8                	mov    %ebx,%eax
  803d93:	21 f0                	and    %esi,%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	75 35                	jne    803dce <fs_test+0x146>
  803d99:	48 b9 4b 8d 80 00 00 	movabs $0x808d4b,%rcx
  803da0:	00 00 00 
  803da3:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  803daa:	00 00 00 
  803dad:	be 1a 00 00 00       	mov    $0x1a,%esi
  803db2:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803db9:	00 00 00 
  803dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc1:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803dc8:	00 00 00 
  803dcb:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  803dce:	48 b8 68 40 81 00 00 	movabs $0x814068,%rax
  803dd5:	00 00 00 
  803dd8:	48 8b 10             	mov    (%rax),%rdx
  803ddb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dde:	8d 48 1f             	lea    0x1f(%rax),%ecx
  803de1:	85 c0                	test   %eax,%eax
  803de3:	0f 48 c1             	cmovs  %ecx,%eax
  803de6:	c1 f8 05             	sar    $0x5,%eax
  803de9:	48 98                	cltq   
  803deb:	48 c1 e0 02          	shl    $0x2,%rax
  803def:	48 01 d0             	add    %rdx,%rax
  803df2:	8b 30                	mov    (%rax),%esi
  803df4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803df7:	89 c2                	mov    %eax,%edx
  803df9:	c1 fa 1f             	sar    $0x1f,%edx
  803dfc:	c1 ea 1b             	shr    $0x1b,%edx
  803dff:	01 d0                	add    %edx,%eax
  803e01:	83 e0 1f             	and    $0x1f,%eax
  803e04:	29 d0                	sub    %edx,%eax
  803e06:	ba 01 00 00 00       	mov    $0x1,%edx
  803e0b:	89 d3                	mov    %edx,%ebx
  803e0d:	89 c1                	mov    %eax,%ecx
  803e0f:	d3 e3                	shl    %cl,%ebx
  803e11:	89 d8                	mov    %ebx,%eax
  803e13:	21 f0                	and    %esi,%eax
  803e15:	85 c0                	test   %eax,%eax
  803e17:	74 35                	je     803e4e <fs_test+0x1c6>
  803e19:	48 b9 80 8d 80 00 00 	movabs $0x808d80,%rcx
  803e20:	00 00 00 
  803e23:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  803e2a:	00 00 00 
  803e2d:	be 1c 00 00 00       	mov    $0x1c,%esi
  803e32:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803e39:	00 00 00 
  803e3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e41:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803e48:	00 00 00 
  803e4b:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  803e4e:	48 bf a0 8d 80 00 00 	movabs $0x808da0,%rdi
  803e55:	00 00 00 
  803e58:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5d:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803e64:	00 00 00 
  803e67:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  803e69:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e6d:	48 89 c6             	mov    %rax,%rsi
  803e70:	48 bf b5 8d 80 00 00 	movabs $0x808db5,%rdi
  803e77:	00 00 00 
  803e7a:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  803e81:	00 00 00 
  803e84:	ff d0                	callq  *%rax
  803e86:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e8d:	79 36                	jns    803ec5 <fs_test+0x23d>
  803e8f:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  803e93:	74 30                	je     803ec5 <fs_test+0x23d>
		panic("file_open /not-found: %e", r);
  803e95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e98:	89 c1                	mov    %eax,%ecx
  803e9a:	48 ba c0 8d 80 00 00 	movabs $0x808dc0,%rdx
  803ea1:	00 00 00 
  803ea4:	be 20 00 00 00       	mov    $0x20,%esi
  803ea9:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803eb0:	00 00 00 
  803eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb8:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803ebf:	00 00 00 
  803ec2:	41 ff d0             	callq  *%r8
	else if (r == 0)
  803ec5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ec9:	75 2a                	jne    803ef5 <fs_test+0x26d>
		panic("file_open /not-found succeeded!");
  803ecb:	48 ba e0 8d 80 00 00 	movabs $0x808de0,%rdx
  803ed2:	00 00 00 
  803ed5:	be 22 00 00 00       	mov    $0x22,%esi
  803eda:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803ee1:	00 00 00 
  803ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee9:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  803ef0:	00 00 00 
  803ef3:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  803ef5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ef9:	48 89 c6             	mov    %rax,%rsi
  803efc:	48 bf 00 8e 80 00 00 	movabs $0x808e00,%rdi
  803f03:	00 00 00 
  803f06:	48 b8 69 1f 80 00 00 	movabs $0x801f69,%rax
  803f0d:	00 00 00 
  803f10:	ff d0                	callq  *%rax
  803f12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f19:	79 30                	jns    803f4b <fs_test+0x2c3>
		panic("file_open /newmotd: %e", r);
  803f1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1e:	89 c1                	mov    %eax,%ecx
  803f20:	48 ba 09 8e 80 00 00 	movabs $0x808e09,%rdx
  803f27:	00 00 00 
  803f2a:	be 24 00 00 00       	mov    $0x24,%esi
  803f2f:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803f36:	00 00 00 
  803f39:	b8 00 00 00 00       	mov    $0x0,%eax
  803f3e:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803f45:	00 00 00 
  803f48:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  803f4b:	48 bf 20 8e 80 00 00 	movabs $0x808e20,%rdi
  803f52:	00 00 00 
  803f55:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5a:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  803f61:	00 00 00 
  803f64:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  803f66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f6a:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  803f6e:	be 00 00 00 00       	mov    $0x0,%esi
  803f73:	48 89 c7             	mov    %rax,%rdi
  803f76:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  803f7d:	00 00 00 
  803f80:	ff d0                	callq  *%rax
  803f82:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f85:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f89:	79 30                	jns    803fbb <fs_test+0x333>
		panic("file_get_block: %e", r);
  803f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f8e:	89 c1                	mov    %eax,%ecx
  803f90:	48 ba 33 8e 80 00 00 	movabs $0x808e33,%rdx
  803f97:	00 00 00 
  803f9a:	be 28 00 00 00       	mov    $0x28,%esi
  803f9f:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803fa6:	00 00 00 
  803fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fae:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  803fb5:	00 00 00 
  803fb8:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  803fbb:	48 b8 88 30 81 00 00 	movabs $0x813088,%rax
  803fc2:	00 00 00 
  803fc5:	48 8b 10             	mov    (%rax),%rdx
  803fc8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fcc:	48 89 d6             	mov    %rdx,%rsi
  803fcf:	48 89 c7             	mov    %rax,%rdi
  803fd2:	48 b8 9f 54 80 00 00 	movabs $0x80549f,%rax
  803fd9:	00 00 00 
  803fdc:	ff d0                	callq  *%rax
  803fde:	85 c0                	test   %eax,%eax
  803fe0:	74 2a                	je     80400c <fs_test+0x384>
		panic("file_get_block returned wrong data");
  803fe2:	48 ba 48 8e 80 00 00 	movabs $0x808e48,%rdx
  803fe9:	00 00 00 
  803fec:	be 2a 00 00 00       	mov    $0x2a,%esi
  803ff1:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  803ff8:	00 00 00 
  803ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  804000:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  804007:	00 00 00 
  80400a:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  80400c:	48 bf 6b 8e 80 00 00 	movabs $0x808e6b,%rdi
  804013:	00 00 00 
  804016:	b8 00 00 00 00       	mov    $0x0,%eax
  80401b:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  804022:	00 00 00 
  804025:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  804027:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80402f:	0f b6 12             	movzbl (%rdx),%edx
  804032:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  804034:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804038:	48 89 c2             	mov    %rax,%rdx
  80403b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80403f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804046:	01 00 00 
  804049:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80404d:	83 e0 40             	and    $0x40,%eax
  804050:	48 85 c0             	test   %rax,%rax
  804053:	75 35                	jne    80408a <fs_test+0x402>
  804055:	48 b9 83 8e 80 00 00 	movabs $0x808e83,%rcx
  80405c:	00 00 00 
  80405f:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  804066:	00 00 00 
  804069:	be 2e 00 00 00       	mov    $0x2e,%esi
  80406e:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  804075:	00 00 00 
  804078:	b8 00 00 00 00       	mov    $0x0,%eax
  80407d:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  804084:	00 00 00 
  804087:	41 ff d0             	callq  *%r8
	file_flush(f);
  80408a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80408e:	48 89 c7             	mov    %rax,%rdi
  804091:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  804098:	00 00 00 
  80409b:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80409d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a1:	48 89 c2             	mov    %rax,%rdx
  8040a4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8040a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040af:	01 00 00 
  8040b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b6:	83 e0 40             	and    $0x40,%eax
  8040b9:	48 85 c0             	test   %rax,%rax
  8040bc:	74 35                	je     8040f3 <fs_test+0x46b>
  8040be:	48 b9 9e 8e 80 00 00 	movabs $0x808e9e,%rcx
  8040c5:	00 00 00 
  8040c8:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  8040cf:	00 00 00 
  8040d2:	be 30 00 00 00       	mov    $0x30,%esi
  8040d7:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  8040de:	00 00 00 
  8040e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e6:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8040ed:	00 00 00 
  8040f0:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  8040f3:	48 bf ba 8e 80 00 00 	movabs $0x808eba,%rdi
  8040fa:	00 00 00 
  8040fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804102:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  804109:	00 00 00 
  80410c:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  80410e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804112:	be 00 00 00 00       	mov    $0x0,%esi
  804117:	48 89 c7             	mov    %rax,%rdi
  80411a:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  804121:	00 00 00 
  804124:	ff d0                	callq  *%rax
  804126:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804129:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80412d:	79 30                	jns    80415f <fs_test+0x4d7>
		panic("file_set_size: %e", r);
  80412f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804132:	89 c1                	mov    %eax,%ecx
  804134:	48 ba ce 8e 80 00 00 	movabs $0x808ece,%rdx
  80413b:	00 00 00 
  80413e:	be 34 00 00 00       	mov    $0x34,%esi
  804143:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  80414a:	00 00 00 
  80414d:	b8 00 00 00 00       	mov    $0x0,%eax
  804152:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  804159:	00 00 00 
  80415c:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  80415f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804163:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  804169:	85 c0                	test   %eax,%eax
  80416b:	74 35                	je     8041a2 <fs_test+0x51a>
  80416d:	48 b9 e0 8e 80 00 00 	movabs $0x808ee0,%rcx
  804174:	00 00 00 
  804177:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  80417e:	00 00 00 
  804181:	be 35 00 00 00       	mov    $0x35,%esi
  804186:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  80418d:	00 00 00 
  804190:	b8 00 00 00 00       	mov    $0x0,%eax
  804195:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80419c:	00 00 00 
  80419f:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8041a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041a6:	48 89 c2             	mov    %rax,%rdx
  8041a9:	48 c1 ea 0c          	shr    $0xc,%rdx
  8041ad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041b4:	01 00 00 
  8041b7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041bb:	83 e0 40             	and    $0x40,%eax
  8041be:	48 85 c0             	test   %rax,%rax
  8041c1:	74 35                	je     8041f8 <fs_test+0x570>
  8041c3:	48 b9 f4 8e 80 00 00 	movabs $0x808ef4,%rcx
  8041ca:	00 00 00 
  8041cd:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  8041d4:	00 00 00 
  8041d7:	be 36 00 00 00       	mov    $0x36,%esi
  8041dc:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  8041e3:	00 00 00 
  8041e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041eb:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8041f2:	00 00 00 
  8041f5:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  8041f8:	48 bf 0e 8f 80 00 00 	movabs $0x808f0e,%rdi
  8041ff:	00 00 00 
  804202:	b8 00 00 00 00       	mov    $0x0,%eax
  804207:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  80420e:	00 00 00 
  804211:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  804213:	48 b8 88 30 81 00 00 	movabs $0x813088,%rax
  80421a:	00 00 00 
  80421d:	48 8b 00             	mov    (%rax),%rax
  804220:	48 89 c7             	mov    %rax,%rdi
  804223:	48 b8 d8 52 80 00 00 	movabs $0x8052d8,%rax
  80422a:	00 00 00 
  80422d:	ff d0                	callq  *%rax
  80422f:	89 c2                	mov    %eax,%edx
  804231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804235:	89 d6                	mov    %edx,%esi
  804237:	48 89 c7             	mov    %rax,%rdi
  80423a:	48 b8 29 24 80 00 00 	movabs $0x802429,%rax
  804241:	00 00 00 
  804244:	ff d0                	callq  *%rax
  804246:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804249:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80424d:	79 30                	jns    80427f <fs_test+0x5f7>
		panic("file_set_size 2: %e", r);
  80424f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804252:	89 c1                	mov    %eax,%ecx
  804254:	48 ba 25 8f 80 00 00 	movabs $0x808f25,%rdx
  80425b:	00 00 00 
  80425e:	be 3a 00 00 00       	mov    $0x3a,%esi
  804263:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  80426a:	00 00 00 
  80426d:	b8 00 00 00 00       	mov    $0x0,%eax
  804272:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  804279:	00 00 00 
  80427c:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80427f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804283:	48 89 c2             	mov    %rax,%rdx
  804286:	48 c1 ea 0c          	shr    $0xc,%rdx
  80428a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804291:	01 00 00 
  804294:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804298:	83 e0 40             	and    $0x40,%eax
  80429b:	48 85 c0             	test   %rax,%rax
  80429e:	74 35                	je     8042d5 <fs_test+0x64d>
  8042a0:	48 b9 f4 8e 80 00 00 	movabs $0x808ef4,%rcx
  8042a7:	00 00 00 
  8042aa:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  8042b1:	00 00 00 
  8042b4:	be 3b 00 00 00       	mov    $0x3b,%esi
  8042b9:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  8042c0:	00 00 00 
  8042c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8042c8:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  8042cf:	00 00 00 
  8042d2:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8042d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d9:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8042dd:	be 00 00 00 00       	mov    $0x0,%esi
  8042e2:	48 89 c7             	mov    %rax,%rdi
  8042e5:	48 b8 f3 18 80 00 00 	movabs $0x8018f3,%rax
  8042ec:	00 00 00 
  8042ef:	ff d0                	callq  *%rax
  8042f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042f8:	79 30                	jns    80432a <fs_test+0x6a2>
		panic("file_get_block 2: %e", r);
  8042fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042fd:	89 c1                	mov    %eax,%ecx
  8042ff:	48 ba 39 8f 80 00 00 	movabs $0x808f39,%rdx
  804306:	00 00 00 
  804309:	be 3d 00 00 00       	mov    $0x3d,%esi
  80430e:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  804315:	00 00 00 
  804318:	b8 00 00 00 00       	mov    $0x0,%eax
  80431d:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  804324:	00 00 00 
  804327:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  80432a:	48 b8 88 30 81 00 00 	movabs $0x813088,%rax
  804331:	00 00 00 
  804334:	48 8b 10             	mov    (%rax),%rdx
  804337:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80433b:	48 89 d6             	mov    %rdx,%rsi
  80433e:	48 89 c7             	mov    %rax,%rdi
  804341:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  804348:	00 00 00 
  80434b:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80434d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804351:	48 89 c2             	mov    %rax,%rdx
  804354:	48 c1 ea 0c          	shr    $0xc,%rdx
  804358:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80435f:	01 00 00 
  804362:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804366:	83 e0 40             	and    $0x40,%eax
  804369:	48 85 c0             	test   %rax,%rax
  80436c:	75 35                	jne    8043a3 <fs_test+0x71b>
  80436e:	48 b9 83 8e 80 00 00 	movabs $0x808e83,%rcx
  804375:	00 00 00 
  804378:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  80437f:	00 00 00 
  804382:	be 3f 00 00 00       	mov    $0x3f,%esi
  804387:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  80438e:	00 00 00 
  804391:	b8 00 00 00 00       	mov    $0x0,%eax
  804396:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80439d:	00 00 00 
  8043a0:	41 ff d0             	callq  *%r8
	file_flush(f);
  8043a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043a7:	48 89 c7             	mov    %rax,%rdi
  8043aa:	48 b8 86 24 80 00 00 	movabs $0x802486,%rax
  8043b1:	00 00 00 
  8043b4:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8043b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ba:	48 89 c2             	mov    %rax,%rdx
  8043bd:	48 c1 ea 0c          	shr    $0xc,%rdx
  8043c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8043c8:	01 00 00 
  8043cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043cf:	83 e0 40             	and    $0x40,%eax
  8043d2:	48 85 c0             	test   %rax,%rax
  8043d5:	74 35                	je     80440c <fs_test+0x784>
  8043d7:	48 b9 9e 8e 80 00 00 	movabs $0x808e9e,%rcx
  8043de:	00 00 00 
  8043e1:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  8043e8:	00 00 00 
  8043eb:	be 41 00 00 00       	mov    $0x41,%esi
  8043f0:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  8043f7:	00 00 00 
  8043fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ff:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  804406:	00 00 00 
  804409:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80440c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804410:	48 89 c2             	mov    %rax,%rdx
  804413:	48 c1 ea 0c          	shr    $0xc,%rdx
  804417:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80441e:	01 00 00 
  804421:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804425:	83 e0 40             	and    $0x40,%eax
  804428:	48 85 c0             	test   %rax,%rax
  80442b:	74 35                	je     804462 <fs_test+0x7da>
  80442d:	48 b9 f4 8e 80 00 00 	movabs $0x808ef4,%rcx
  804434:	00 00 00 
  804437:	48 ba 66 8d 80 00 00 	movabs $0x808d66,%rdx
  80443e:	00 00 00 
  804441:	be 42 00 00 00       	mov    $0x42,%esi
  804446:	48 bf 31 8d 80 00 00 	movabs $0x808d31,%rdi
  80444d:	00 00 00 
  804450:	b8 00 00 00 00       	mov    $0x0,%eax
  804455:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80445c:	00 00 00 
  80445f:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  804462:	48 bf 4e 8f 80 00 00 	movabs $0x808f4e,%rdi
  804469:	00 00 00 
  80446c:	b8 00 00 00 00       	mov    $0x0,%eax
  804471:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  804478:	00 00 00 
  80447b:	ff d2                	callq  *%rdx
}
  80447d:	48 83 c4 28          	add    $0x28,%rsp
  804481:	5b                   	pop    %rbx
  804482:	5d                   	pop    %rbp
  804483:	c3                   	retq   

0000000000804484 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  804484:	55                   	push   %rbp
  804485:	48 89 e5             	mov    %rsp,%rbp
  804488:	48 83 ec 10          	sub    $0x10,%rsp
  80448c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80448f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  804493:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  80449a:	00 00 00 
  80449d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8044a4:	48 b8 00 5c 80 00 00 	movabs $0x805c00,%rax
  8044ab:	00 00 00 
  8044ae:	ff d0                	callq  *%rax
  8044b0:	48 98                	cltq   
  8044b2:	48 89 c2             	mov    %rax,%rdx
  8044b5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8044bb:	48 89 d0             	mov    %rdx,%rax
  8044be:	48 c1 e0 03          	shl    $0x3,%rax
  8044c2:	48 01 d0             	add    %rdx,%rax
  8044c5:	48 c1 e0 05          	shl    $0x5,%rax
  8044c9:	48 89 c2             	mov    %rax,%rdx
  8044cc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8044d3:	00 00 00 
  8044d6:	48 01 c2             	add    %rax,%rdx
  8044d9:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  8044e0:	00 00 00 
  8044e3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8044e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ea:	7e 14                	jle    804500 <libmain+0x7c>
		binaryname = argv[0];
  8044ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f0:	48 8b 10             	mov    (%rax),%rdx
  8044f3:	48 b8 90 30 81 00 00 	movabs $0x813090,%rax
  8044fa:	00 00 00 
  8044fd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  804500:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804504:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804507:	48 89 d6             	mov    %rdx,%rsi
  80450a:	89 c7                	mov    %eax,%edi
  80450c:	48 b8 ee 3b 80 00 00 	movabs $0x803bee,%rax
  804513:	00 00 00 
  804516:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  804518:	48 b8 28 45 80 00 00 	movabs $0x804528,%rax
  80451f:	00 00 00 
  804522:	ff d0                	callq  *%rax
}
  804524:	c9                   	leaveq 
  804525:	c3                   	retq   
	...

0000000000804528 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  804528:	55                   	push   %rbp
  804529:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80452c:	48 b8 55 66 80 00 00 	movabs $0x806655,%rax
  804533:	00 00 00 
  804536:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  804538:	bf 00 00 00 00       	mov    $0x0,%edi
  80453d:	48 b8 bc 5b 80 00 00 	movabs $0x805bbc,%rax
  804544:	00 00 00 
  804547:	ff d0                	callq  *%rax
}
  804549:	5d                   	pop    %rbp
  80454a:	c3                   	retq   
	...

000000000080454c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80454c:	55                   	push   %rbp
  80454d:	48 89 e5             	mov    %rsp,%rbp
  804550:	53                   	push   %rbx
  804551:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804558:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80455f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804565:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80456c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804573:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80457a:	84 c0                	test   %al,%al
  80457c:	74 23                	je     8045a1 <_panic+0x55>
  80457e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804585:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804589:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80458d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804591:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804595:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804599:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80459d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8045a1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8045a8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8045af:	00 00 00 
  8045b2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8045b9:	00 00 00 
  8045bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8045c0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8045c7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8045ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8045d5:	48 b8 90 30 81 00 00 	movabs $0x813090,%rax
  8045dc:	00 00 00 
  8045df:	48 8b 18             	mov    (%rax),%rbx
  8045e2:	48 b8 00 5c 80 00 00 	movabs $0x805c00,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
  8045ee:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8045f4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8045fb:	41 89 c8             	mov    %ecx,%r8d
  8045fe:	48 89 d1             	mov    %rdx,%rcx
  804601:	48 89 da             	mov    %rbx,%rdx
  804604:	89 c6                	mov    %eax,%esi
  804606:	48 bf 70 8f 80 00 00 	movabs $0x808f70,%rdi
  80460d:	00 00 00 
  804610:	b8 00 00 00 00       	mov    $0x0,%eax
  804615:	49 b9 87 47 80 00 00 	movabs $0x804787,%r9
  80461c:	00 00 00 
  80461f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804622:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804629:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804630:	48 89 d6             	mov    %rdx,%rsi
  804633:	48 89 c7             	mov    %rax,%rdi
  804636:	48 b8 db 46 80 00 00 	movabs $0x8046db,%rax
  80463d:	00 00 00 
  804640:	ff d0                	callq  *%rax
	cprintf("\n");
  804642:	48 bf 93 8f 80 00 00 	movabs $0x808f93,%rdi
  804649:	00 00 00 
  80464c:	b8 00 00 00 00       	mov    $0x0,%eax
  804651:	48 ba 87 47 80 00 00 	movabs $0x804787,%rdx
  804658:	00 00 00 
  80465b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80465d:	cc                   	int3   
  80465e:	eb fd                	jmp    80465d <_panic+0x111>

0000000000804660 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  804660:	55                   	push   %rbp
  804661:	48 89 e5             	mov    %rsp,%rbp
  804664:	48 83 ec 10          	sub    $0x10,%rsp
  804668:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80466b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80466f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804673:	8b 00                	mov    (%rax),%eax
  804675:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804678:	89 d6                	mov    %edx,%esi
  80467a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80467e:	48 63 d0             	movslq %eax,%rdx
  804681:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  804686:	8d 50 01             	lea    0x1(%rax),%edx
  804689:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80468f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804693:	8b 00                	mov    (%rax),%eax
  804695:	3d ff 00 00 00       	cmp    $0xff,%eax
  80469a:	75 2c                	jne    8046c8 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80469c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a0:	8b 00                	mov    (%rax),%eax
  8046a2:	48 98                	cltq   
  8046a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046a8:	48 83 c2 08          	add    $0x8,%rdx
  8046ac:	48 89 c6             	mov    %rax,%rsi
  8046af:	48 89 d7             	mov    %rdx,%rdi
  8046b2:	48 b8 34 5b 80 00 00 	movabs $0x805b34,%rax
  8046b9:	00 00 00 
  8046bc:	ff d0                	callq  *%rax
		b->idx = 0;
  8046be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8046c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046cc:	8b 40 04             	mov    0x4(%rax),%eax
  8046cf:	8d 50 01             	lea    0x1(%rax),%edx
  8046d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8046d9:	c9                   	leaveq 
  8046da:	c3                   	retq   

00000000008046db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8046db:	55                   	push   %rbp
  8046dc:	48 89 e5             	mov    %rsp,%rbp
  8046df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8046e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8046ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8046f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8046fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  804702:	48 8b 0a             	mov    (%rdx),%rcx
  804705:	48 89 08             	mov    %rcx,(%rax)
  804708:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80470c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804710:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  804714:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  804718:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80471f:	00 00 00 
	b.cnt = 0;
  804722:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804729:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80472c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  804733:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80473a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804741:	48 89 c6             	mov    %rax,%rsi
  804744:	48 bf 60 46 80 00 00 	movabs $0x804660,%rdi
  80474b:	00 00 00 
  80474e:	48 b8 38 4b 80 00 00 	movabs $0x804b38,%rax
  804755:	00 00 00 
  804758:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80475a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  804760:	48 98                	cltq   
  804762:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  804769:	48 83 c2 08          	add    $0x8,%rdx
  80476d:	48 89 c6             	mov    %rax,%rsi
  804770:	48 89 d7             	mov    %rdx,%rdi
  804773:	48 b8 34 5b 80 00 00 	movabs $0x805b34,%rax
  80477a:	00 00 00 
  80477d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80477f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  804785:	c9                   	leaveq 
  804786:	c3                   	retq   

0000000000804787 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  804787:	55                   	push   %rbp
  804788:	48 89 e5             	mov    %rsp,%rbp
  80478b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  804792:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804799:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8047a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8047a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8047ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8047b5:	84 c0                	test   %al,%al
  8047b7:	74 20                	je     8047d9 <cprintf+0x52>
  8047b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8047bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8047c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8047c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8047c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8047cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8047d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8047d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8047d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8047e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8047e7:	00 00 00 
  8047ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8047f1:	00 00 00 
  8047f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8047f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8047ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804806:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80480d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804814:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80481b:	48 8b 0a             	mov    (%rdx),%rcx
  80481e:	48 89 08             	mov    %rcx,(%rax)
  804821:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804825:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804829:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80482d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  804831:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  804838:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80483f:	48 89 d6             	mov    %rdx,%rsi
  804842:	48 89 c7             	mov    %rax,%rdi
  804845:	48 b8 db 46 80 00 00 	movabs $0x8046db,%rax
  80484c:	00 00 00 
  80484f:	ff d0                	callq  *%rax
  804851:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  804857:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80485d:	c9                   	leaveq 
  80485e:	c3                   	retq   
	...

0000000000804860 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  804860:	55                   	push   %rbp
  804861:	48 89 e5             	mov    %rsp,%rbp
  804864:	48 83 ec 30          	sub    $0x30,%rsp
  804868:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80486c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804870:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804874:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  804877:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80487b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80487f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804882:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  804886:	77 52                	ja     8048da <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  804888:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80488b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80488f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804892:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80489a:	ba 00 00 00 00       	mov    $0x0,%edx
  80489f:	48 f7 75 d0          	divq   -0x30(%rbp)
  8048a3:	48 89 c2             	mov    %rax,%rdx
  8048a6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8048a9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8048ac:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8048b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8048b4:	41 89 f9             	mov    %edi,%r9d
  8048b7:	48 89 c7             	mov    %rax,%rdi
  8048ba:	48 b8 60 48 80 00 00 	movabs $0x804860,%rax
  8048c1:	00 00 00 
  8048c4:	ff d0                	callq  *%rax
  8048c6:	eb 1c                	jmp    8048e4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8048c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8048cf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8048d3:	48 89 d6             	mov    %rdx,%rsi
  8048d6:	89 c7                	mov    %eax,%edi
  8048d8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8048da:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8048de:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8048e2:	7f e4                	jg     8048c8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8048e4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8048e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8048f0:	48 f7 f1             	div    %rcx
  8048f3:	48 89 d0             	mov    %rdx,%rax
  8048f6:	48 ba 68 91 80 00 00 	movabs $0x809168,%rdx
  8048fd:	00 00 00 
  804900:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  804904:	0f be c0             	movsbl %al,%eax
  804907:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80490b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80490f:	48 89 d6             	mov    %rdx,%rsi
  804912:	89 c7                	mov    %eax,%edi
  804914:	ff d1                	callq  *%rcx
}
  804916:	c9                   	leaveq 
  804917:	c3                   	retq   

0000000000804918 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  804918:	55                   	push   %rbp
  804919:	48 89 e5             	mov    %rsp,%rbp
  80491c:	48 83 ec 20          	sub    $0x20,%rsp
  804920:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804924:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  804927:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80492b:	7e 52                	jle    80497f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80492d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804931:	8b 00                	mov    (%rax),%eax
  804933:	83 f8 30             	cmp    $0x30,%eax
  804936:	73 24                	jae    80495c <getuint+0x44>
  804938:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80493c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  804940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804944:	8b 00                	mov    (%rax),%eax
  804946:	89 c0                	mov    %eax,%eax
  804948:	48 01 d0             	add    %rdx,%rax
  80494b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80494f:	8b 12                	mov    (%rdx),%edx
  804951:	8d 4a 08             	lea    0x8(%rdx),%ecx
  804954:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804958:	89 0a                	mov    %ecx,(%rdx)
  80495a:	eb 17                	jmp    804973 <getuint+0x5b>
  80495c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804960:	48 8b 50 08          	mov    0x8(%rax),%rdx
  804964:	48 89 d0             	mov    %rdx,%rax
  804967:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80496b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80496f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  804973:	48 8b 00             	mov    (%rax),%rax
  804976:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80497a:	e9 a3 00 00 00       	jmpq   804a22 <getuint+0x10a>
	else if (lflag)
  80497f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804983:	74 4f                	je     8049d4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  804985:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804989:	8b 00                	mov    (%rax),%eax
  80498b:	83 f8 30             	cmp    $0x30,%eax
  80498e:	73 24                	jae    8049b4 <getuint+0x9c>
  804990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804994:	48 8b 50 10          	mov    0x10(%rax),%rdx
  804998:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80499c:	8b 00                	mov    (%rax),%eax
  80499e:	89 c0                	mov    %eax,%eax
  8049a0:	48 01 d0             	add    %rdx,%rax
  8049a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049a7:	8b 12                	mov    (%rdx),%edx
  8049a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8049ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049b0:	89 0a                	mov    %ecx,(%rdx)
  8049b2:	eb 17                	jmp    8049cb <getuint+0xb3>
  8049b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8049bc:	48 89 d0             	mov    %rdx,%rax
  8049bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8049c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8049cb:	48 8b 00             	mov    (%rax),%rax
  8049ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8049d2:	eb 4e                	jmp    804a22 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8049d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049d8:	8b 00                	mov    (%rax),%eax
  8049da:	83 f8 30             	cmp    $0x30,%eax
  8049dd:	73 24                	jae    804a03 <getuint+0xeb>
  8049df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8049e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049eb:	8b 00                	mov    (%rax),%eax
  8049ed:	89 c0                	mov    %eax,%eax
  8049ef:	48 01 d0             	add    %rdx,%rax
  8049f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049f6:	8b 12                	mov    (%rdx),%edx
  8049f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8049fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8049ff:	89 0a                	mov    %ecx,(%rdx)
  804a01:	eb 17                	jmp    804a1a <getuint+0x102>
  804a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a07:	48 8b 50 08          	mov    0x8(%rax),%rdx
  804a0b:	48 89 d0             	mov    %rdx,%rax
  804a0e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  804a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a16:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  804a1a:	8b 00                	mov    (%rax),%eax
  804a1c:	89 c0                	mov    %eax,%eax
  804a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  804a22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804a26:	c9                   	leaveq 
  804a27:	c3                   	retq   

0000000000804a28 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  804a28:	55                   	push   %rbp
  804a29:	48 89 e5             	mov    %rsp,%rbp
  804a2c:	48 83 ec 20          	sub    $0x20,%rsp
  804a30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a34:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  804a37:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  804a3b:	7e 52                	jle    804a8f <getint+0x67>
		x=va_arg(*ap, long long);
  804a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a41:	8b 00                	mov    (%rax),%eax
  804a43:	83 f8 30             	cmp    $0x30,%eax
  804a46:	73 24                	jae    804a6c <getint+0x44>
  804a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a4c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  804a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a54:	8b 00                	mov    (%rax),%eax
  804a56:	89 c0                	mov    %eax,%eax
  804a58:	48 01 d0             	add    %rdx,%rax
  804a5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a5f:	8b 12                	mov    (%rdx),%edx
  804a61:	8d 4a 08             	lea    0x8(%rdx),%ecx
  804a64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a68:	89 0a                	mov    %ecx,(%rdx)
  804a6a:	eb 17                	jmp    804a83 <getint+0x5b>
  804a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a70:	48 8b 50 08          	mov    0x8(%rax),%rdx
  804a74:	48 89 d0             	mov    %rdx,%rax
  804a77:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  804a7b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a7f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  804a83:	48 8b 00             	mov    (%rax),%rax
  804a86:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  804a8a:	e9 a3 00 00 00       	jmpq   804b32 <getint+0x10a>
	else if (lflag)
  804a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  804a93:	74 4f                	je     804ae4 <getint+0xbc>
		x=va_arg(*ap, long);
  804a95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a99:	8b 00                	mov    (%rax),%eax
  804a9b:	83 f8 30             	cmp    $0x30,%eax
  804a9e:	73 24                	jae    804ac4 <getint+0x9c>
  804aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  804aa8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aac:	8b 00                	mov    (%rax),%eax
  804aae:	89 c0                	mov    %eax,%eax
  804ab0:	48 01 d0             	add    %rdx,%rax
  804ab3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ab7:	8b 12                	mov    (%rdx),%edx
  804ab9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  804abc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ac0:	89 0a                	mov    %ecx,(%rdx)
  804ac2:	eb 17                	jmp    804adb <getint+0xb3>
  804ac4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  804acc:	48 89 d0             	mov    %rdx,%rax
  804acf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  804ad3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ad7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  804adb:	48 8b 00             	mov    (%rax),%rax
  804ade:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  804ae2:	eb 4e                	jmp    804b32 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  804ae4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ae8:	8b 00                	mov    (%rax),%eax
  804aea:	83 f8 30             	cmp    $0x30,%eax
  804aed:	73 24                	jae    804b13 <getint+0xeb>
  804aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804af3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  804af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804afb:	8b 00                	mov    (%rax),%eax
  804afd:	89 c0                	mov    %eax,%eax
  804aff:	48 01 d0             	add    %rdx,%rax
  804b02:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b06:	8b 12                	mov    (%rdx),%edx
  804b08:	8d 4a 08             	lea    0x8(%rdx),%ecx
  804b0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b0f:	89 0a                	mov    %ecx,(%rdx)
  804b11:	eb 17                	jmp    804b2a <getint+0x102>
  804b13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b17:	48 8b 50 08          	mov    0x8(%rax),%rdx
  804b1b:	48 89 d0             	mov    %rdx,%rax
  804b1e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  804b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b26:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  804b2a:	8b 00                	mov    (%rax),%eax
  804b2c:	48 98                	cltq   
  804b2e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  804b32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804b36:	c9                   	leaveq 
  804b37:	c3                   	retq   

0000000000804b38 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  804b38:	55                   	push   %rbp
  804b39:	48 89 e5             	mov    %rsp,%rbp
  804b3c:	41 54                	push   %r12
  804b3e:	53                   	push   %rbx
  804b3f:	48 83 ec 60          	sub    $0x60,%rsp
  804b43:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  804b47:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  804b4b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  804b4f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  804b53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804b57:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  804b5b:	48 8b 0a             	mov    (%rdx),%rcx
  804b5e:	48 89 08             	mov    %rcx,(%rax)
  804b61:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804b65:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804b69:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  804b6d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  804b71:	eb 17                	jmp    804b8a <vprintfmt+0x52>
			if (ch == '\0')
  804b73:	85 db                	test   %ebx,%ebx
  804b75:	0f 84 d7 04 00 00    	je     805052 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  804b7b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804b7f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804b83:	48 89 c6             	mov    %rax,%rsi
  804b86:	89 df                	mov    %ebx,%edi
  804b88:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  804b8a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  804b8e:	0f b6 00             	movzbl (%rax),%eax
  804b91:	0f b6 d8             	movzbl %al,%ebx
  804b94:	83 fb 25             	cmp    $0x25,%ebx
  804b97:	0f 95 c0             	setne  %al
  804b9a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  804b9f:	84 c0                	test   %al,%al
  804ba1:	75 d0                	jne    804b73 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  804ba3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  804ba7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  804bae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  804bb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  804bbc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  804bc3:	eb 04                	jmp    804bc9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  804bc5:	90                   	nop
  804bc6:	eb 01                	jmp    804bc9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  804bc8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  804bc9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  804bcd:	0f b6 00             	movzbl (%rax),%eax
  804bd0:	0f b6 d8             	movzbl %al,%ebx
  804bd3:	89 d8                	mov    %ebx,%eax
  804bd5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  804bda:	83 e8 23             	sub    $0x23,%eax
  804bdd:	83 f8 55             	cmp    $0x55,%eax
  804be0:	0f 87 38 04 00 00    	ja     80501e <vprintfmt+0x4e6>
  804be6:	89 c0                	mov    %eax,%eax
  804be8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  804bef:	00 
  804bf0:	48 b8 90 91 80 00 00 	movabs $0x809190,%rax
  804bf7:	00 00 00 
  804bfa:	48 01 d0             	add    %rdx,%rax
  804bfd:	48 8b 00             	mov    (%rax),%rax
  804c00:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  804c02:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  804c06:	eb c1                	jmp    804bc9 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  804c08:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  804c0c:	eb bb                	jmp    804bc9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  804c0e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  804c15:	8b 55 d8             	mov    -0x28(%rbp),%edx
  804c18:	89 d0                	mov    %edx,%eax
  804c1a:	c1 e0 02             	shl    $0x2,%eax
  804c1d:	01 d0                	add    %edx,%eax
  804c1f:	01 c0                	add    %eax,%eax
  804c21:	01 d8                	add    %ebx,%eax
  804c23:	83 e8 30             	sub    $0x30,%eax
  804c26:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  804c29:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  804c2d:	0f b6 00             	movzbl (%rax),%eax
  804c30:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  804c33:	83 fb 2f             	cmp    $0x2f,%ebx
  804c36:	7e 63                	jle    804c9b <vprintfmt+0x163>
  804c38:	83 fb 39             	cmp    $0x39,%ebx
  804c3b:	7f 5e                	jg     804c9b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  804c3d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  804c42:	eb d1                	jmp    804c15 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  804c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804c47:	83 f8 30             	cmp    $0x30,%eax
  804c4a:	73 17                	jae    804c63 <vprintfmt+0x12b>
  804c4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804c50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804c53:	89 c0                	mov    %eax,%eax
  804c55:	48 01 d0             	add    %rdx,%rax
  804c58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804c5b:	83 c2 08             	add    $0x8,%edx
  804c5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804c61:	eb 0f                	jmp    804c72 <vprintfmt+0x13a>
  804c63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804c67:	48 89 d0             	mov    %rdx,%rax
  804c6a:	48 83 c2 08          	add    $0x8,%rdx
  804c6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  804c72:	8b 00                	mov    (%rax),%eax
  804c74:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  804c77:	eb 23                	jmp    804c9c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  804c79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804c7d:	0f 89 42 ff ff ff    	jns    804bc5 <vprintfmt+0x8d>
				width = 0;
  804c83:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  804c8a:	e9 36 ff ff ff       	jmpq   804bc5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  804c8f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  804c96:	e9 2e ff ff ff       	jmpq   804bc9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  804c9b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  804c9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804ca0:	0f 89 22 ff ff ff    	jns    804bc8 <vprintfmt+0x90>
				width = precision, precision = -1;
  804ca6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804ca9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  804cac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  804cb3:	e9 10 ff ff ff       	jmpq   804bc8 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  804cb8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  804cbc:	e9 08 ff ff ff       	jmpq   804bc9 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  804cc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804cc4:	83 f8 30             	cmp    $0x30,%eax
  804cc7:	73 17                	jae    804ce0 <vprintfmt+0x1a8>
  804cc9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804ccd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804cd0:	89 c0                	mov    %eax,%eax
  804cd2:	48 01 d0             	add    %rdx,%rax
  804cd5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804cd8:	83 c2 08             	add    $0x8,%edx
  804cdb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804cde:	eb 0f                	jmp    804cef <vprintfmt+0x1b7>
  804ce0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804ce4:	48 89 d0             	mov    %rdx,%rax
  804ce7:	48 83 c2 08          	add    $0x8,%rdx
  804ceb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  804cef:	8b 00                	mov    (%rax),%eax
  804cf1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804cf5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  804cf9:	48 89 d6             	mov    %rdx,%rsi
  804cfc:	89 c7                	mov    %eax,%edi
  804cfe:	ff d1                	callq  *%rcx
			break;
  804d00:	e9 47 03 00 00       	jmpq   80504c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  804d05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804d08:	83 f8 30             	cmp    $0x30,%eax
  804d0b:	73 17                	jae    804d24 <vprintfmt+0x1ec>
  804d0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804d11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804d14:	89 c0                	mov    %eax,%eax
  804d16:	48 01 d0             	add    %rdx,%rax
  804d19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804d1c:	83 c2 08             	add    $0x8,%edx
  804d1f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804d22:	eb 0f                	jmp    804d33 <vprintfmt+0x1fb>
  804d24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804d28:	48 89 d0             	mov    %rdx,%rax
  804d2b:	48 83 c2 08          	add    $0x8,%rdx
  804d2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  804d33:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  804d35:	85 db                	test   %ebx,%ebx
  804d37:	79 02                	jns    804d3b <vprintfmt+0x203>
				err = -err;
  804d39:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  804d3b:	83 fb 10             	cmp    $0x10,%ebx
  804d3e:	7f 16                	jg     804d56 <vprintfmt+0x21e>
  804d40:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  804d47:	00 00 00 
  804d4a:	48 63 d3             	movslq %ebx,%rdx
  804d4d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  804d51:	4d 85 e4             	test   %r12,%r12
  804d54:	75 2e                	jne    804d84 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  804d56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  804d5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804d5e:	89 d9                	mov    %ebx,%ecx
  804d60:	48 ba 79 91 80 00 00 	movabs $0x809179,%rdx
  804d67:	00 00 00 
  804d6a:	48 89 c7             	mov    %rax,%rdi
  804d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  804d72:	49 b8 5c 50 80 00 00 	movabs $0x80505c,%r8
  804d79:	00 00 00 
  804d7c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  804d7f:	e9 c8 02 00 00       	jmpq   80504c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  804d84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  804d88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804d8c:	4c 89 e1             	mov    %r12,%rcx
  804d8f:	48 ba 82 91 80 00 00 	movabs $0x809182,%rdx
  804d96:	00 00 00 
  804d99:	48 89 c7             	mov    %rax,%rdi
  804d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  804da1:	49 b8 5c 50 80 00 00 	movabs $0x80505c,%r8
  804da8:	00 00 00 
  804dab:	41 ff d0             	callq  *%r8
			break;
  804dae:	e9 99 02 00 00       	jmpq   80504c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  804db3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804db6:	83 f8 30             	cmp    $0x30,%eax
  804db9:	73 17                	jae    804dd2 <vprintfmt+0x29a>
  804dbb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804dbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804dc2:	89 c0                	mov    %eax,%eax
  804dc4:	48 01 d0             	add    %rdx,%rax
  804dc7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804dca:	83 c2 08             	add    $0x8,%edx
  804dcd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  804dd0:	eb 0f                	jmp    804de1 <vprintfmt+0x2a9>
  804dd2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804dd6:	48 89 d0             	mov    %rdx,%rax
  804dd9:	48 83 c2 08          	add    $0x8,%rdx
  804ddd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  804de1:	4c 8b 20             	mov    (%rax),%r12
  804de4:	4d 85 e4             	test   %r12,%r12
  804de7:	75 0a                	jne    804df3 <vprintfmt+0x2bb>
				p = "(null)";
  804de9:	49 bc 85 91 80 00 00 	movabs $0x809185,%r12
  804df0:	00 00 00 
			if (width > 0 && padc != '-')
  804df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804df7:	7e 7a                	jle    804e73 <vprintfmt+0x33b>
  804df9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  804dfd:	74 74                	je     804e73 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  804dff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804e02:	48 98                	cltq   
  804e04:	48 89 c6             	mov    %rax,%rsi
  804e07:	4c 89 e7             	mov    %r12,%rdi
  804e0a:	48 b8 06 53 80 00 00 	movabs $0x805306,%rax
  804e11:	00 00 00 
  804e14:	ff d0                	callq  *%rax
  804e16:	29 45 dc             	sub    %eax,-0x24(%rbp)
  804e19:	eb 17                	jmp    804e32 <vprintfmt+0x2fa>
					putch(padc, putdat);
  804e1b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  804e1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804e23:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  804e27:	48 89 d6             	mov    %rdx,%rsi
  804e2a:	89 c7                	mov    %eax,%edi
  804e2c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  804e2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  804e32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804e36:	7f e3                	jg     804e1b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804e38:	eb 39                	jmp    804e73 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  804e3a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  804e3e:	74 1e                	je     804e5e <vprintfmt+0x326>
  804e40:	83 fb 1f             	cmp    $0x1f,%ebx
  804e43:	7e 05                	jle    804e4a <vprintfmt+0x312>
  804e45:	83 fb 7e             	cmp    $0x7e,%ebx
  804e48:	7e 14                	jle    804e5e <vprintfmt+0x326>
					putch('?', putdat);
  804e4a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804e4e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804e52:	48 89 c6             	mov    %rax,%rsi
  804e55:	bf 3f 00 00 00       	mov    $0x3f,%edi
  804e5a:	ff d2                	callq  *%rdx
  804e5c:	eb 0f                	jmp    804e6d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  804e5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804e62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804e66:	48 89 c6             	mov    %rax,%rsi
  804e69:	89 df                	mov    %ebx,%edi
  804e6b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  804e6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  804e71:	eb 01                	jmp    804e74 <vprintfmt+0x33c>
  804e73:	90                   	nop
  804e74:	41 0f b6 04 24       	movzbl (%r12),%eax
  804e79:	0f be d8             	movsbl %al,%ebx
  804e7c:	85 db                	test   %ebx,%ebx
  804e7e:	0f 95 c0             	setne  %al
  804e81:	49 83 c4 01          	add    $0x1,%r12
  804e85:	84 c0                	test   %al,%al
  804e87:	74 28                	je     804eb1 <vprintfmt+0x379>
  804e89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804e8d:	78 ab                	js     804e3a <vprintfmt+0x302>
  804e8f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  804e93:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804e97:	79 a1                	jns    804e3a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  804e99:	eb 16                	jmp    804eb1 <vprintfmt+0x379>
				putch(' ', putdat);
  804e9b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804e9f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804ea3:	48 89 c6             	mov    %rax,%rsi
  804ea6:	bf 20 00 00 00       	mov    $0x20,%edi
  804eab:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  804ead:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  804eb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  804eb5:	7f e4                	jg     804e9b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  804eb7:	e9 90 01 00 00       	jmpq   80504c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  804ebc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804ec0:	be 03 00 00 00       	mov    $0x3,%esi
  804ec5:	48 89 c7             	mov    %rax,%rdi
  804ec8:	48 b8 28 4a 80 00 00 	movabs $0x804a28,%rax
  804ecf:	00 00 00 
  804ed2:	ff d0                	callq  *%rax
  804ed4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  804ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804edc:	48 85 c0             	test   %rax,%rax
  804edf:	79 1d                	jns    804efe <vprintfmt+0x3c6>
				putch('-', putdat);
  804ee1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804ee5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804ee9:	48 89 c6             	mov    %rax,%rsi
  804eec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  804ef1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  804ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ef7:	48 f7 d8             	neg    %rax
  804efa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  804efe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  804f05:	e9 d5 00 00 00       	jmpq   804fdf <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  804f0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804f0e:	be 03 00 00 00       	mov    $0x3,%esi
  804f13:	48 89 c7             	mov    %rax,%rdi
  804f16:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  804f1d:	00 00 00 
  804f20:	ff d0                	callq  *%rax
  804f22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  804f26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  804f2d:	e9 ad 00 00 00       	jmpq   804fdf <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  804f32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804f36:	be 03 00 00 00       	mov    $0x3,%esi
  804f3b:	48 89 c7             	mov    %rax,%rdi
  804f3e:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  804f45:	00 00 00 
  804f48:	ff d0                	callq  *%rax
  804f4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  804f4e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  804f55:	e9 85 00 00 00       	jmpq   804fdf <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  804f5a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804f5e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804f62:	48 89 c6             	mov    %rax,%rsi
  804f65:	bf 30 00 00 00       	mov    $0x30,%edi
  804f6a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  804f6c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  804f70:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804f74:	48 89 c6             	mov    %rax,%rsi
  804f77:	bf 78 00 00 00       	mov    $0x78,%edi
  804f7c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  804f7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804f81:	83 f8 30             	cmp    $0x30,%eax
  804f84:	73 17                	jae    804f9d <vprintfmt+0x465>
  804f86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804f8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  804f8d:	89 c0                	mov    %eax,%eax
  804f8f:	48 01 d0             	add    %rdx,%rax
  804f92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  804f95:	83 c2 08             	add    $0x8,%edx
  804f98:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  804f9b:	eb 0f                	jmp    804fac <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  804f9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  804fa1:	48 89 d0             	mov    %rdx,%rax
  804fa4:	48 83 c2 08          	add    $0x8,%rdx
  804fa8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  804fac:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  804faf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  804fb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  804fba:	eb 23                	jmp    804fdf <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  804fbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  804fc0:	be 03 00 00 00       	mov    $0x3,%esi
  804fc5:	48 89 c7             	mov    %rax,%rdi
  804fc8:	48 b8 18 49 80 00 00 	movabs $0x804918,%rax
  804fcf:	00 00 00 
  804fd2:	ff d0                	callq  *%rax
  804fd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  804fd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  804fdf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  804fe4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804fe7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804fee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  804ff2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804ff6:	45 89 c1             	mov    %r8d,%r9d
  804ff9:	41 89 f8             	mov    %edi,%r8d
  804ffc:	48 89 c7             	mov    %rax,%rdi
  804fff:	48 b8 60 48 80 00 00 	movabs $0x804860,%rax
  805006:	00 00 00 
  805009:	ff d0                	callq  *%rax
			break;
  80500b:	eb 3f                	jmp    80504c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80500d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  805011:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  805015:	48 89 c6             	mov    %rax,%rsi
  805018:	89 df                	mov    %ebx,%edi
  80501a:	ff d2                	callq  *%rdx
			break;
  80501c:	eb 2e                	jmp    80504c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80501e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  805022:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  805026:	48 89 c6             	mov    %rax,%rsi
  805029:	bf 25 00 00 00       	mov    $0x25,%edi
  80502e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  805030:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  805035:	eb 05                	jmp    80503c <vprintfmt+0x504>
  805037:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80503c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  805040:	48 83 e8 01          	sub    $0x1,%rax
  805044:	0f b6 00             	movzbl (%rax),%eax
  805047:	3c 25                	cmp    $0x25,%al
  805049:	75 ec                	jne    805037 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  80504b:	90                   	nop
		}
	}
  80504c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80504d:	e9 38 fb ff ff       	jmpq   804b8a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  805052:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  805053:	48 83 c4 60          	add    $0x60,%rsp
  805057:	5b                   	pop    %rbx
  805058:	41 5c                	pop    %r12
  80505a:	5d                   	pop    %rbp
  80505b:	c3                   	retq   

000000000080505c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80505c:	55                   	push   %rbp
  80505d:	48 89 e5             	mov    %rsp,%rbp
  805060:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  805067:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80506e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  805075:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80507c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  805083:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80508a:	84 c0                	test   %al,%al
  80508c:	74 20                	je     8050ae <printfmt+0x52>
  80508e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  805092:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  805096:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80509a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80509e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8050a2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8050a6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8050aa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8050ae:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8050b5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8050bc:	00 00 00 
  8050bf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8050c6:	00 00 00 
  8050c9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8050cd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8050d4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8050db:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8050e2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8050e9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8050f0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8050f7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8050fe:	48 89 c7             	mov    %rax,%rdi
  805101:	48 b8 38 4b 80 00 00 	movabs $0x804b38,%rax
  805108:	00 00 00 
  80510b:	ff d0                	callq  *%rax
	va_end(ap);
}
  80510d:	c9                   	leaveq 
  80510e:	c3                   	retq   

000000000080510f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80510f:	55                   	push   %rbp
  805110:	48 89 e5             	mov    %rsp,%rbp
  805113:	48 83 ec 10          	sub    $0x10,%rsp
  805117:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80511a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80511e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805122:	8b 40 10             	mov    0x10(%rax),%eax
  805125:	8d 50 01             	lea    0x1(%rax),%edx
  805128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80512c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80512f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805133:	48 8b 10             	mov    (%rax),%rdx
  805136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80513a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80513e:	48 39 c2             	cmp    %rax,%rdx
  805141:	73 17                	jae    80515a <sprintputch+0x4b>
		*b->buf++ = ch;
  805143:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805147:	48 8b 00             	mov    (%rax),%rax
  80514a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80514d:	88 10                	mov    %dl,(%rax)
  80514f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805157:	48 89 10             	mov    %rdx,(%rax)
}
  80515a:	c9                   	leaveq 
  80515b:	c3                   	retq   

000000000080515c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80515c:	55                   	push   %rbp
  80515d:	48 89 e5             	mov    %rsp,%rbp
  805160:	48 83 ec 50          	sub    $0x50,%rsp
  805164:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  805168:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80516b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80516f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  805173:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  805177:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80517b:	48 8b 0a             	mov    (%rdx),%rcx
  80517e:	48 89 08             	mov    %rcx,(%rax)
  805181:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  805185:	48 89 48 08          	mov    %rcx,0x8(%rax)
  805189:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80518d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  805191:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805195:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  805199:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80519c:	48 98                	cltq   
  80519e:	48 83 e8 01          	sub    $0x1,%rax
  8051a2:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8051a6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8051aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8051b1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8051b6:	74 06                	je     8051be <vsnprintf+0x62>
  8051b8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8051bc:	7f 07                	jg     8051c5 <vsnprintf+0x69>
		return -E_INVAL;
  8051be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8051c3:	eb 2f                	jmp    8051f4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8051c5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8051c9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8051cd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8051d1:	48 89 c6             	mov    %rax,%rsi
  8051d4:	48 bf 0f 51 80 00 00 	movabs $0x80510f,%rdi
  8051db:	00 00 00 
  8051de:	48 b8 38 4b 80 00 00 	movabs $0x804b38,%rax
  8051e5:	00 00 00 
  8051e8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8051ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8051ee:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8051f1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8051f4:	c9                   	leaveq 
  8051f5:	c3                   	retq   

00000000008051f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8051f6:	55                   	push   %rbp
  8051f7:	48 89 e5             	mov    %rsp,%rbp
  8051fa:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  805201:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  805208:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80520e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  805215:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80521c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  805223:	84 c0                	test   %al,%al
  805225:	74 20                	je     805247 <snprintf+0x51>
  805227:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80522b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80522f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  805233:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  805237:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80523b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80523f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  805243:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  805247:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80524e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  805255:	00 00 00 
  805258:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80525f:	00 00 00 
  805262:	48 8d 45 10          	lea    0x10(%rbp),%rax
  805266:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80526d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  805274:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80527b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  805282:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  805289:	48 8b 0a             	mov    (%rdx),%rcx
  80528c:	48 89 08             	mov    %rcx,(%rax)
  80528f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  805293:	48 89 48 08          	mov    %rcx,0x8(%rax)
  805297:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80529b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80529f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8052a6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8052ad:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8052b3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8052ba:	48 89 c7             	mov    %rax,%rdi
  8052bd:	48 b8 5c 51 80 00 00 	movabs $0x80515c,%rax
  8052c4:	00 00 00 
  8052c7:	ff d0                	callq  *%rax
  8052c9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8052cf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8052d5:	c9                   	leaveq 
  8052d6:	c3                   	retq   
	...

00000000008052d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8052d8:	55                   	push   %rbp
  8052d9:	48 89 e5             	mov    %rsp,%rbp
  8052dc:	48 83 ec 18          	sub    $0x18,%rsp
  8052e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8052e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8052eb:	eb 09                	jmp    8052f6 <strlen+0x1e>
		n++;
  8052ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8052f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8052f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8052fa:	0f b6 00             	movzbl (%rax),%eax
  8052fd:	84 c0                	test   %al,%al
  8052ff:	75 ec                	jne    8052ed <strlen+0x15>
		n++;
	return n;
  805301:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805304:	c9                   	leaveq 
  805305:	c3                   	retq   

0000000000805306 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  805306:	55                   	push   %rbp
  805307:	48 89 e5             	mov    %rsp,%rbp
  80530a:	48 83 ec 20          	sub    $0x20,%rsp
  80530e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805312:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  805316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80531d:	eb 0e                	jmp    80532d <strnlen+0x27>
		n++;
  80531f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  805323:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  805328:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80532d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805332:	74 0b                	je     80533f <strnlen+0x39>
  805334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805338:	0f b6 00             	movzbl (%rax),%eax
  80533b:	84 c0                	test   %al,%al
  80533d:	75 e0                	jne    80531f <strnlen+0x19>
		n++;
	return n;
  80533f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805342:	c9                   	leaveq 
  805343:	c3                   	retq   

0000000000805344 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  805344:	55                   	push   %rbp
  805345:	48 89 e5             	mov    %rsp,%rbp
  805348:	48 83 ec 20          	sub    $0x20,%rsp
  80534c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  805354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805358:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80535c:	90                   	nop
  80535d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805361:	0f b6 10             	movzbl (%rax),%edx
  805364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805368:	88 10                	mov    %dl,(%rax)
  80536a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80536e:	0f b6 00             	movzbl (%rax),%eax
  805371:	84 c0                	test   %al,%al
  805373:	0f 95 c0             	setne  %al
  805376:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80537b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  805380:	84 c0                	test   %al,%al
  805382:	75 d9                	jne    80535d <strcpy+0x19>
		/* do nothing */;
	return ret;
  805384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805388:	c9                   	leaveq 
  805389:	c3                   	retq   

000000000080538a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80538a:	55                   	push   %rbp
  80538b:	48 89 e5             	mov    %rsp,%rbp
  80538e:	48 83 ec 20          	sub    $0x20,%rsp
  805392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80539a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80539e:	48 89 c7             	mov    %rax,%rdi
  8053a1:	48 b8 d8 52 80 00 00 	movabs $0x8052d8,%rax
  8053a8:	00 00 00 
  8053ab:	ff d0                	callq  *%rax
  8053ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8053b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053b3:	48 98                	cltq   
  8053b5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8053b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053bd:	48 89 d6             	mov    %rdx,%rsi
  8053c0:	48 89 c7             	mov    %rax,%rdi
  8053c3:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  8053ca:	00 00 00 
  8053cd:	ff d0                	callq  *%rax
	return dst;
  8053cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8053d3:	c9                   	leaveq 
  8053d4:	c3                   	retq   

00000000008053d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8053d5:	55                   	push   %rbp
  8053d6:	48 89 e5             	mov    %rsp,%rbp
  8053d9:	48 83 ec 28          	sub    $0x28,%rsp
  8053dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8053e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8053e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8053e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8053f1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8053f8:	00 
  8053f9:	eb 27                	jmp    805422 <strncpy+0x4d>
		*dst++ = *src;
  8053fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053ff:	0f b6 10             	movzbl (%rax),%edx
  805402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805406:	88 10                	mov    %dl,(%rax)
  805408:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80540d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805411:	0f b6 00             	movzbl (%rax),%eax
  805414:	84 c0                	test   %al,%al
  805416:	74 05                	je     80541d <strncpy+0x48>
			src++;
  805418:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80541d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805422:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805426:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80542a:	72 cf                	jb     8053fb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80542c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  805430:	c9                   	leaveq 
  805431:	c3                   	retq   

0000000000805432 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  805432:	55                   	push   %rbp
  805433:	48 89 e5             	mov    %rsp,%rbp
  805436:	48 83 ec 28          	sub    $0x28,%rsp
  80543a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80543e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805442:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  805446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80544a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80544e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805453:	74 37                	je     80548c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  805455:	eb 17                	jmp    80546e <strlcpy+0x3c>
			*dst++ = *src++;
  805457:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80545b:	0f b6 10             	movzbl (%rax),%edx
  80545e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805462:	88 10                	mov    %dl,(%rax)
  805464:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  805469:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80546e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  805473:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805478:	74 0b                	je     805485 <strlcpy+0x53>
  80547a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80547e:	0f b6 00             	movzbl (%rax),%eax
  805481:	84 c0                	test   %al,%al
  805483:	75 d2                	jne    805457 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  805485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805489:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80548c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805490:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805494:	48 89 d1             	mov    %rdx,%rcx
  805497:	48 29 c1             	sub    %rax,%rcx
  80549a:	48 89 c8             	mov    %rcx,%rax
}
  80549d:	c9                   	leaveq 
  80549e:	c3                   	retq   

000000000080549f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80549f:	55                   	push   %rbp
  8054a0:	48 89 e5             	mov    %rsp,%rbp
  8054a3:	48 83 ec 10          	sub    $0x10,%rsp
  8054a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8054ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8054af:	eb 0a                	jmp    8054bb <strcmp+0x1c>
		p++, q++;
  8054b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8054b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8054bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054bf:	0f b6 00             	movzbl (%rax),%eax
  8054c2:	84 c0                	test   %al,%al
  8054c4:	74 12                	je     8054d8 <strcmp+0x39>
  8054c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054ca:	0f b6 10             	movzbl (%rax),%edx
  8054cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054d1:	0f b6 00             	movzbl (%rax),%eax
  8054d4:	38 c2                	cmp    %al,%dl
  8054d6:	74 d9                	je     8054b1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8054d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054dc:	0f b6 00             	movzbl (%rax),%eax
  8054df:	0f b6 d0             	movzbl %al,%edx
  8054e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054e6:	0f b6 00             	movzbl (%rax),%eax
  8054e9:	0f b6 c0             	movzbl %al,%eax
  8054ec:	89 d1                	mov    %edx,%ecx
  8054ee:	29 c1                	sub    %eax,%ecx
  8054f0:	89 c8                	mov    %ecx,%eax
}
  8054f2:	c9                   	leaveq 
  8054f3:	c3                   	retq   

00000000008054f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8054f4:	55                   	push   %rbp
  8054f5:	48 89 e5             	mov    %rsp,%rbp
  8054f8:	48 83 ec 18          	sub    $0x18,%rsp
  8054fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805500:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805504:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  805508:	eb 0f                	jmp    805519 <strncmp+0x25>
		n--, p++, q++;
  80550a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80550f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805514:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  805519:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80551e:	74 1d                	je     80553d <strncmp+0x49>
  805520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805524:	0f b6 00             	movzbl (%rax),%eax
  805527:	84 c0                	test   %al,%al
  805529:	74 12                	je     80553d <strncmp+0x49>
  80552b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80552f:	0f b6 10             	movzbl (%rax),%edx
  805532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805536:	0f b6 00             	movzbl (%rax),%eax
  805539:	38 c2                	cmp    %al,%dl
  80553b:	74 cd                	je     80550a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80553d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805542:	75 07                	jne    80554b <strncmp+0x57>
		return 0;
  805544:	b8 00 00 00 00       	mov    $0x0,%eax
  805549:	eb 1a                	jmp    805565 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80554b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80554f:	0f b6 00             	movzbl (%rax),%eax
  805552:	0f b6 d0             	movzbl %al,%edx
  805555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805559:	0f b6 00             	movzbl (%rax),%eax
  80555c:	0f b6 c0             	movzbl %al,%eax
  80555f:	89 d1                	mov    %edx,%ecx
  805561:	29 c1                	sub    %eax,%ecx
  805563:	89 c8                	mov    %ecx,%eax
}
  805565:	c9                   	leaveq 
  805566:	c3                   	retq   

0000000000805567 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  805567:	55                   	push   %rbp
  805568:	48 89 e5             	mov    %rsp,%rbp
  80556b:	48 83 ec 10          	sub    $0x10,%rsp
  80556f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805573:	89 f0                	mov    %esi,%eax
  805575:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  805578:	eb 17                	jmp    805591 <strchr+0x2a>
		if (*s == c)
  80557a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80557e:	0f b6 00             	movzbl (%rax),%eax
  805581:	3a 45 f4             	cmp    -0xc(%rbp),%al
  805584:	75 06                	jne    80558c <strchr+0x25>
			return (char *) s;
  805586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80558a:	eb 15                	jmp    8055a1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80558c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805595:	0f b6 00             	movzbl (%rax),%eax
  805598:	84 c0                	test   %al,%al
  80559a:	75 de                	jne    80557a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80559c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055a1:	c9                   	leaveq 
  8055a2:	c3                   	retq   

00000000008055a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8055a3:	55                   	push   %rbp
  8055a4:	48 89 e5             	mov    %rsp,%rbp
  8055a7:	48 83 ec 10          	sub    $0x10,%rsp
  8055ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8055af:	89 f0                	mov    %esi,%eax
  8055b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8055b4:	eb 11                	jmp    8055c7 <strfind+0x24>
		if (*s == c)
  8055b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ba:	0f b6 00             	movzbl (%rax),%eax
  8055bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8055c0:	74 12                	je     8055d4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8055c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8055c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055cb:	0f b6 00             	movzbl (%rax),%eax
  8055ce:	84 c0                	test   %al,%al
  8055d0:	75 e4                	jne    8055b6 <strfind+0x13>
  8055d2:	eb 01                	jmp    8055d5 <strfind+0x32>
		if (*s == c)
			break;
  8055d4:	90                   	nop
	return (char *) s;
  8055d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8055d9:	c9                   	leaveq 
  8055da:	c3                   	retq   

00000000008055db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8055db:	55                   	push   %rbp
  8055dc:	48 89 e5             	mov    %rsp,%rbp
  8055df:	48 83 ec 18          	sub    $0x18,%rsp
  8055e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8055e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8055ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8055ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8055f3:	75 06                	jne    8055fb <memset+0x20>
		return v;
  8055f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055f9:	eb 69                	jmp    805664 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8055fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ff:	83 e0 03             	and    $0x3,%eax
  805602:	48 85 c0             	test   %rax,%rax
  805605:	75 48                	jne    80564f <memset+0x74>
  805607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80560b:	83 e0 03             	and    $0x3,%eax
  80560e:	48 85 c0             	test   %rax,%rax
  805611:	75 3c                	jne    80564f <memset+0x74>
		c &= 0xFF;
  805613:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80561a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80561d:	89 c2                	mov    %eax,%edx
  80561f:	c1 e2 18             	shl    $0x18,%edx
  805622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805625:	c1 e0 10             	shl    $0x10,%eax
  805628:	09 c2                	or     %eax,%edx
  80562a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80562d:	c1 e0 08             	shl    $0x8,%eax
  805630:	09 d0                	or     %edx,%eax
  805632:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  805635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805639:	48 89 c1             	mov    %rax,%rcx
  80563c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  805640:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805644:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805647:	48 89 d7             	mov    %rdx,%rdi
  80564a:	fc                   	cld    
  80564b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80564d:	eb 11                	jmp    805660 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80564f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805653:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805656:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80565a:	48 89 d7             	mov    %rdx,%rdi
  80565d:	fc                   	cld    
  80565e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  805660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805664:	c9                   	leaveq 
  805665:	c3                   	retq   

0000000000805666 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  805666:	55                   	push   %rbp
  805667:	48 89 e5             	mov    %rsp,%rbp
  80566a:	48 83 ec 28          	sub    $0x28,%rsp
  80566e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805672:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805676:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80567a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80567e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  805682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805686:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80568a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80568e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  805692:	0f 83 88 00 00 00    	jae    805720 <memmove+0xba>
  805698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80569c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8056a0:	48 01 d0             	add    %rdx,%rax
  8056a3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8056a7:	76 77                	jbe    805720 <memmove+0xba>
		s += n;
  8056a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056ad:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8056b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056b5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8056b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056bd:	83 e0 03             	and    $0x3,%eax
  8056c0:	48 85 c0             	test   %rax,%rax
  8056c3:	75 3b                	jne    805700 <memmove+0x9a>
  8056c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056c9:	83 e0 03             	and    $0x3,%eax
  8056cc:	48 85 c0             	test   %rax,%rax
  8056cf:	75 2f                	jne    805700 <memmove+0x9a>
  8056d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056d5:	83 e0 03             	and    $0x3,%eax
  8056d8:	48 85 c0             	test   %rax,%rax
  8056db:	75 23                	jne    805700 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8056dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8056e1:	48 83 e8 04          	sub    $0x4,%rax
  8056e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8056e9:	48 83 ea 04          	sub    $0x4,%rdx
  8056ed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8056f1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8056f5:	48 89 c7             	mov    %rax,%rdi
  8056f8:	48 89 d6             	mov    %rdx,%rsi
  8056fb:	fd                   	std    
  8056fc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8056fe:	eb 1d                	jmp    80571d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  805700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805704:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  805708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80570c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  805710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805714:	48 89 d7             	mov    %rdx,%rdi
  805717:	48 89 c1             	mov    %rax,%rcx
  80571a:	fd                   	std    
  80571b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80571d:	fc                   	cld    
  80571e:	eb 57                	jmp    805777 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  805720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805724:	83 e0 03             	and    $0x3,%eax
  805727:	48 85 c0             	test   %rax,%rax
  80572a:	75 36                	jne    805762 <memmove+0xfc>
  80572c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805730:	83 e0 03             	and    $0x3,%eax
  805733:	48 85 c0             	test   %rax,%rax
  805736:	75 2a                	jne    805762 <memmove+0xfc>
  805738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80573c:	83 e0 03             	and    $0x3,%eax
  80573f:	48 85 c0             	test   %rax,%rax
  805742:	75 1e                	jne    805762 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  805744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805748:	48 89 c1             	mov    %rax,%rcx
  80574b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80574f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805753:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805757:	48 89 c7             	mov    %rax,%rdi
  80575a:	48 89 d6             	mov    %rdx,%rsi
  80575d:	fc                   	cld    
  80575e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  805760:	eb 15                	jmp    805777 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  805762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805766:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80576a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80576e:	48 89 c7             	mov    %rax,%rdi
  805771:	48 89 d6             	mov    %rdx,%rsi
  805774:	fc                   	cld    
  805775:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  805777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80577b:	c9                   	leaveq 
  80577c:	c3                   	retq   

000000000080577d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80577d:	55                   	push   %rbp
  80577e:	48 89 e5             	mov    %rsp,%rbp
  805781:	48 83 ec 18          	sub    $0x18,%rsp
  805785:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805789:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80578d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  805791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805795:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80579d:	48 89 ce             	mov    %rcx,%rsi
  8057a0:	48 89 c7             	mov    %rax,%rdi
  8057a3:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8057aa:	00 00 00 
  8057ad:	ff d0                	callq  *%rax
}
  8057af:	c9                   	leaveq 
  8057b0:	c3                   	retq   

00000000008057b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8057b1:	55                   	push   %rbp
  8057b2:	48 89 e5             	mov    %rsp,%rbp
  8057b5:	48 83 ec 28          	sub    $0x28,%rsp
  8057b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8057bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8057c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8057c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8057cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8057d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8057d5:	eb 38                	jmp    80580f <memcmp+0x5e>
		if (*s1 != *s2)
  8057d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057db:	0f b6 10             	movzbl (%rax),%edx
  8057de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057e2:	0f b6 00             	movzbl (%rax),%eax
  8057e5:	38 c2                	cmp    %al,%dl
  8057e7:	74 1c                	je     805805 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8057e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057ed:	0f b6 00             	movzbl (%rax),%eax
  8057f0:	0f b6 d0             	movzbl %al,%edx
  8057f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057f7:	0f b6 00             	movzbl (%rax),%eax
  8057fa:	0f b6 c0             	movzbl %al,%eax
  8057fd:	89 d1                	mov    %edx,%ecx
  8057ff:	29 c1                	sub    %eax,%ecx
  805801:	89 c8                	mov    %ecx,%eax
  805803:	eb 20                	jmp    805825 <memcmp+0x74>
		s1++, s2++;
  805805:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80580a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80580f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805814:	0f 95 c0             	setne  %al
  805817:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80581c:	84 c0                	test   %al,%al
  80581e:	75 b7                	jne    8057d7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  805820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805825:	c9                   	leaveq 
  805826:	c3                   	retq   

0000000000805827 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  805827:	55                   	push   %rbp
  805828:	48 89 e5             	mov    %rsp,%rbp
  80582b:	48 83 ec 28          	sub    $0x28,%rsp
  80582f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805833:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  805836:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80583a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80583e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805842:	48 01 d0             	add    %rdx,%rax
  805845:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  805849:	eb 13                	jmp    80585e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80584b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80584f:	0f b6 10             	movzbl (%rax),%edx
  805852:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805855:	38 c2                	cmp    %al,%dl
  805857:	74 11                	je     80586a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  805859:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80585e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805862:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  805866:	72 e3                	jb     80584b <memfind+0x24>
  805868:	eb 01                	jmp    80586b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80586a:	90                   	nop
	return (void *) s;
  80586b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80586f:	c9                   	leaveq 
  805870:	c3                   	retq   

0000000000805871 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  805871:	55                   	push   %rbp
  805872:	48 89 e5             	mov    %rsp,%rbp
  805875:	48 83 ec 38          	sub    $0x38,%rsp
  805879:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80587d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805881:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  805884:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80588b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  805892:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  805893:	eb 05                	jmp    80589a <strtol+0x29>
		s++;
  805895:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80589a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80589e:	0f b6 00             	movzbl (%rax),%eax
  8058a1:	3c 20                	cmp    $0x20,%al
  8058a3:	74 f0                	je     805895 <strtol+0x24>
  8058a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058a9:	0f b6 00             	movzbl (%rax),%eax
  8058ac:	3c 09                	cmp    $0x9,%al
  8058ae:	74 e5                	je     805895 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8058b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058b4:	0f b6 00             	movzbl (%rax),%eax
  8058b7:	3c 2b                	cmp    $0x2b,%al
  8058b9:	75 07                	jne    8058c2 <strtol+0x51>
		s++;
  8058bb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8058c0:	eb 17                	jmp    8058d9 <strtol+0x68>
	else if (*s == '-')
  8058c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058c6:	0f b6 00             	movzbl (%rax),%eax
  8058c9:	3c 2d                	cmp    $0x2d,%al
  8058cb:	75 0c                	jne    8058d9 <strtol+0x68>
		s++, neg = 1;
  8058cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8058d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8058d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8058dd:	74 06                	je     8058e5 <strtol+0x74>
  8058df:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8058e3:	75 28                	jne    80590d <strtol+0x9c>
  8058e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058e9:	0f b6 00             	movzbl (%rax),%eax
  8058ec:	3c 30                	cmp    $0x30,%al
  8058ee:	75 1d                	jne    80590d <strtol+0x9c>
  8058f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8058f4:	48 83 c0 01          	add    $0x1,%rax
  8058f8:	0f b6 00             	movzbl (%rax),%eax
  8058fb:	3c 78                	cmp    $0x78,%al
  8058fd:	75 0e                	jne    80590d <strtol+0x9c>
		s += 2, base = 16;
  8058ff:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  805904:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80590b:	eb 2c                	jmp    805939 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80590d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  805911:	75 19                	jne    80592c <strtol+0xbb>
  805913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805917:	0f b6 00             	movzbl (%rax),%eax
  80591a:	3c 30                	cmp    $0x30,%al
  80591c:	75 0e                	jne    80592c <strtol+0xbb>
		s++, base = 8;
  80591e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  805923:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80592a:	eb 0d                	jmp    805939 <strtol+0xc8>
	else if (base == 0)
  80592c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  805930:	75 07                	jne    805939 <strtol+0xc8>
		base = 10;
  805932:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  805939:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80593d:	0f b6 00             	movzbl (%rax),%eax
  805940:	3c 2f                	cmp    $0x2f,%al
  805942:	7e 1d                	jle    805961 <strtol+0xf0>
  805944:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805948:	0f b6 00             	movzbl (%rax),%eax
  80594b:	3c 39                	cmp    $0x39,%al
  80594d:	7f 12                	jg     805961 <strtol+0xf0>
			dig = *s - '0';
  80594f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805953:	0f b6 00             	movzbl (%rax),%eax
  805956:	0f be c0             	movsbl %al,%eax
  805959:	83 e8 30             	sub    $0x30,%eax
  80595c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80595f:	eb 4e                	jmp    8059af <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  805961:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805965:	0f b6 00             	movzbl (%rax),%eax
  805968:	3c 60                	cmp    $0x60,%al
  80596a:	7e 1d                	jle    805989 <strtol+0x118>
  80596c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805970:	0f b6 00             	movzbl (%rax),%eax
  805973:	3c 7a                	cmp    $0x7a,%al
  805975:	7f 12                	jg     805989 <strtol+0x118>
			dig = *s - 'a' + 10;
  805977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80597b:	0f b6 00             	movzbl (%rax),%eax
  80597e:	0f be c0             	movsbl %al,%eax
  805981:	83 e8 57             	sub    $0x57,%eax
  805984:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805987:	eb 26                	jmp    8059af <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  805989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80598d:	0f b6 00             	movzbl (%rax),%eax
  805990:	3c 40                	cmp    $0x40,%al
  805992:	7e 47                	jle    8059db <strtol+0x16a>
  805994:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805998:	0f b6 00             	movzbl (%rax),%eax
  80599b:	3c 5a                	cmp    $0x5a,%al
  80599d:	7f 3c                	jg     8059db <strtol+0x16a>
			dig = *s - 'A' + 10;
  80599f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8059a3:	0f b6 00             	movzbl (%rax),%eax
  8059a6:	0f be c0             	movsbl %al,%eax
  8059a9:	83 e8 37             	sub    $0x37,%eax
  8059ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8059af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059b2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8059b5:	7d 23                	jge    8059da <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8059b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8059bc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8059bf:	48 98                	cltq   
  8059c1:	48 89 c2             	mov    %rax,%rdx
  8059c4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8059c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059cc:	48 98                	cltq   
  8059ce:	48 01 d0             	add    %rdx,%rax
  8059d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8059d5:	e9 5f ff ff ff       	jmpq   805939 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8059da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8059db:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8059e0:	74 0b                	je     8059ed <strtol+0x17c>
		*endptr = (char *) s;
  8059e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8059e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8059ea:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8059ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059f1:	74 09                	je     8059fc <strtol+0x18b>
  8059f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059f7:	48 f7 d8             	neg    %rax
  8059fa:	eb 04                	jmp    805a00 <strtol+0x18f>
  8059fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  805a00:	c9                   	leaveq 
  805a01:	c3                   	retq   

0000000000805a02 <strstr>:

char * strstr(const char *in, const char *str)
{
  805a02:	55                   	push   %rbp
  805a03:	48 89 e5             	mov    %rsp,%rbp
  805a06:	48 83 ec 30          	sub    $0x30,%rsp
  805a0a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805a0e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  805a12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a16:	0f b6 00             	movzbl (%rax),%eax
  805a19:	88 45 ff             	mov    %al,-0x1(%rbp)
  805a1c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  805a21:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  805a25:	75 06                	jne    805a2d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  805a27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a2b:	eb 68                	jmp    805a95 <strstr+0x93>

    len = strlen(str);
  805a2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805a31:	48 89 c7             	mov    %rax,%rdi
  805a34:	48 b8 d8 52 80 00 00 	movabs $0x8052d8,%rax
  805a3b:	00 00 00 
  805a3e:	ff d0                	callq  *%rax
  805a40:	48 98                	cltq   
  805a42:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  805a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a4a:	0f b6 00             	movzbl (%rax),%eax
  805a4d:	88 45 ef             	mov    %al,-0x11(%rbp)
  805a50:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  805a55:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  805a59:	75 07                	jne    805a62 <strstr+0x60>
                return (char *) 0;
  805a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  805a60:	eb 33                	jmp    805a95 <strstr+0x93>
        } while (sc != c);
  805a62:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  805a66:	3a 45 ff             	cmp    -0x1(%rbp),%al
  805a69:	75 db                	jne    805a46 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  805a6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805a6f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805a73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a77:	48 89 ce             	mov    %rcx,%rsi
  805a7a:	48 89 c7             	mov    %rax,%rdi
  805a7d:	48 b8 f4 54 80 00 00 	movabs $0x8054f4,%rax
  805a84:	00 00 00 
  805a87:	ff d0                	callq  *%rax
  805a89:	85 c0                	test   %eax,%eax
  805a8b:	75 b9                	jne    805a46 <strstr+0x44>

    return (char *) (in - 1);
  805a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805a91:	48 83 e8 01          	sub    $0x1,%rax
}
  805a95:	c9                   	leaveq 
  805a96:	c3                   	retq   
	...

0000000000805a98 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  805a98:	55                   	push   %rbp
  805a99:	48 89 e5             	mov    %rsp,%rbp
  805a9c:	53                   	push   %rbx
  805a9d:	48 83 ec 58          	sub    $0x58,%rsp
  805aa1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805aa4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  805aa7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  805aab:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  805aaf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  805ab3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  805ab7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805aba:	89 45 ac             	mov    %eax,-0x54(%rbp)
  805abd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805ac1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  805ac5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  805ac9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  805acd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  805ad1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  805ad4:	4c 89 c3             	mov    %r8,%rbx
  805ad7:	cd 30                	int    $0x30
  805ad9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  805add:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  805ae1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  805ae5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  805ae9:	74 3e                	je     805b29 <syscall+0x91>
  805aeb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805af0:	7e 37                	jle    805b29 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  805af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805af6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805af9:	49 89 d0             	mov    %rdx,%r8
  805afc:	89 c1                	mov    %eax,%ecx
  805afe:	48 ba 40 94 80 00 00 	movabs $0x809440,%rdx
  805b05:	00 00 00 
  805b08:	be 23 00 00 00       	mov    $0x23,%esi
  805b0d:	48 bf 5d 94 80 00 00 	movabs $0x80945d,%rdi
  805b14:	00 00 00 
  805b17:	b8 00 00 00 00       	mov    $0x0,%eax
  805b1c:	49 b9 4c 45 80 00 00 	movabs $0x80454c,%r9
  805b23:	00 00 00 
  805b26:	41 ff d1             	callq  *%r9

	return ret;
  805b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  805b2d:	48 83 c4 58          	add    $0x58,%rsp
  805b31:	5b                   	pop    %rbx
  805b32:	5d                   	pop    %rbp
  805b33:	c3                   	retq   

0000000000805b34 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  805b34:	55                   	push   %rbp
  805b35:	48 89 e5             	mov    %rsp,%rbp
  805b38:	48 83 ec 20          	sub    $0x20,%rsp
  805b3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  805b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805b4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805b53:	00 
  805b54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805b5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805b60:	48 89 d1             	mov    %rdx,%rcx
  805b63:	48 89 c2             	mov    %rax,%rdx
  805b66:	be 00 00 00 00       	mov    $0x0,%esi
  805b6b:	bf 00 00 00 00       	mov    $0x0,%edi
  805b70:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805b77:	00 00 00 
  805b7a:	ff d0                	callq  *%rax
}
  805b7c:	c9                   	leaveq 
  805b7d:	c3                   	retq   

0000000000805b7e <sys_cgetc>:

int
sys_cgetc(void)
{
  805b7e:	55                   	push   %rbp
  805b7f:	48 89 e5             	mov    %rsp,%rbp
  805b82:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  805b86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805b8d:	00 
  805b8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805b94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805b9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  805b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  805ba4:	be 00 00 00 00       	mov    $0x0,%esi
  805ba9:	bf 01 00 00 00       	mov    $0x1,%edi
  805bae:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805bb5:	00 00 00 
  805bb8:	ff d0                	callq  *%rax
}
  805bba:	c9                   	leaveq 
  805bbb:	c3                   	retq   

0000000000805bbc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  805bbc:	55                   	push   %rbp
  805bbd:	48 89 e5             	mov    %rsp,%rbp
  805bc0:	48 83 ec 20          	sub    $0x20,%rsp
  805bc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  805bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bca:	48 98                	cltq   
  805bcc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805bd3:	00 
  805bd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805bda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805be0:	b9 00 00 00 00       	mov    $0x0,%ecx
  805be5:	48 89 c2             	mov    %rax,%rdx
  805be8:	be 01 00 00 00       	mov    $0x1,%esi
  805bed:	bf 03 00 00 00       	mov    $0x3,%edi
  805bf2:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805bf9:	00 00 00 
  805bfc:	ff d0                	callq  *%rax
}
  805bfe:	c9                   	leaveq 
  805bff:	c3                   	retq   

0000000000805c00 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  805c00:	55                   	push   %rbp
  805c01:	48 89 e5             	mov    %rsp,%rbp
  805c04:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  805c08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805c0f:	00 
  805c10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805c16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  805c21:	ba 00 00 00 00       	mov    $0x0,%edx
  805c26:	be 00 00 00 00       	mov    $0x0,%esi
  805c2b:	bf 02 00 00 00       	mov    $0x2,%edi
  805c30:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805c37:	00 00 00 
  805c3a:	ff d0                	callq  *%rax
}
  805c3c:	c9                   	leaveq 
  805c3d:	c3                   	retq   

0000000000805c3e <sys_yield>:

void
sys_yield(void)
{
  805c3e:	55                   	push   %rbp
  805c3f:	48 89 e5             	mov    %rsp,%rbp
  805c42:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  805c46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805c4d:	00 
  805c4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805c54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805c5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  805c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  805c64:	be 00 00 00 00       	mov    $0x0,%esi
  805c69:	bf 0b 00 00 00       	mov    $0xb,%edi
  805c6e:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805c75:	00 00 00 
  805c78:	ff d0                	callq  *%rax
}
  805c7a:	c9                   	leaveq 
  805c7b:	c3                   	retq   

0000000000805c7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  805c7c:	55                   	push   %rbp
  805c7d:	48 89 e5             	mov    %rsp,%rbp
  805c80:	48 83 ec 20          	sub    $0x20,%rsp
  805c84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805c87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805c8b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  805c8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805c91:	48 63 c8             	movslq %eax,%rcx
  805c94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c9b:	48 98                	cltq   
  805c9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805ca4:	00 
  805ca5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805cab:	49 89 c8             	mov    %rcx,%r8
  805cae:	48 89 d1             	mov    %rdx,%rcx
  805cb1:	48 89 c2             	mov    %rax,%rdx
  805cb4:	be 01 00 00 00       	mov    $0x1,%esi
  805cb9:	bf 04 00 00 00       	mov    $0x4,%edi
  805cbe:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805cc5:	00 00 00 
  805cc8:	ff d0                	callq  *%rax
}
  805cca:	c9                   	leaveq 
  805ccb:	c3                   	retq   

0000000000805ccc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  805ccc:	55                   	push   %rbp
  805ccd:	48 89 e5             	mov    %rsp,%rbp
  805cd0:	48 83 ec 30          	sub    $0x30,%rsp
  805cd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805cd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805cdb:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805cde:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  805ce2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  805ce6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805ce9:	48 63 c8             	movslq %eax,%rcx
  805cec:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  805cf0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805cf3:	48 63 f0             	movslq %eax,%rsi
  805cf6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805cfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805cfd:	48 98                	cltq   
  805cff:	48 89 0c 24          	mov    %rcx,(%rsp)
  805d03:	49 89 f9             	mov    %rdi,%r9
  805d06:	49 89 f0             	mov    %rsi,%r8
  805d09:	48 89 d1             	mov    %rdx,%rcx
  805d0c:	48 89 c2             	mov    %rax,%rdx
  805d0f:	be 01 00 00 00       	mov    $0x1,%esi
  805d14:	bf 05 00 00 00       	mov    $0x5,%edi
  805d19:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805d20:	00 00 00 
  805d23:	ff d0                	callq  *%rax
}
  805d25:	c9                   	leaveq 
  805d26:	c3                   	retq   

0000000000805d27 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  805d27:	55                   	push   %rbp
  805d28:	48 89 e5             	mov    %rsp,%rbp
  805d2b:	48 83 ec 20          	sub    $0x20,%rsp
  805d2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  805d36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d3d:	48 98                	cltq   
  805d3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805d46:	00 
  805d47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805d4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805d53:	48 89 d1             	mov    %rdx,%rcx
  805d56:	48 89 c2             	mov    %rax,%rdx
  805d59:	be 01 00 00 00       	mov    $0x1,%esi
  805d5e:	bf 06 00 00 00       	mov    $0x6,%edi
  805d63:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805d6a:	00 00 00 
  805d6d:	ff d0                	callq  *%rax
}
  805d6f:	c9                   	leaveq 
  805d70:	c3                   	retq   

0000000000805d71 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  805d71:	55                   	push   %rbp
  805d72:	48 89 e5             	mov    %rsp,%rbp
  805d75:	48 83 ec 20          	sub    $0x20,%rsp
  805d79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d7c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  805d7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805d82:	48 63 d0             	movslq %eax,%rdx
  805d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d88:	48 98                	cltq   
  805d8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805d91:	00 
  805d92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805d98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805d9e:	48 89 d1             	mov    %rdx,%rcx
  805da1:	48 89 c2             	mov    %rax,%rdx
  805da4:	be 01 00 00 00       	mov    $0x1,%esi
  805da9:	bf 08 00 00 00       	mov    $0x8,%edi
  805dae:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805db5:	00 00 00 
  805db8:	ff d0                	callq  *%rax
}
  805dba:	c9                   	leaveq 
  805dbb:	c3                   	retq   

0000000000805dbc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  805dbc:	55                   	push   %rbp
  805dbd:	48 89 e5             	mov    %rsp,%rbp
  805dc0:	48 83 ec 20          	sub    $0x20,%rsp
  805dc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805dc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  805dcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805dcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dd2:	48 98                	cltq   
  805dd4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805ddb:	00 
  805ddc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805de2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805de8:	48 89 d1             	mov    %rdx,%rcx
  805deb:	48 89 c2             	mov    %rax,%rdx
  805dee:	be 01 00 00 00       	mov    $0x1,%esi
  805df3:	bf 09 00 00 00       	mov    $0x9,%edi
  805df8:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805dff:	00 00 00 
  805e02:	ff d0                	callq  *%rax
}
  805e04:	c9                   	leaveq 
  805e05:	c3                   	retq   

0000000000805e06 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  805e06:	55                   	push   %rbp
  805e07:	48 89 e5             	mov    %rsp,%rbp
  805e0a:	48 83 ec 20          	sub    $0x20,%rsp
  805e0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  805e15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805e19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e1c:	48 98                	cltq   
  805e1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805e25:	00 
  805e26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805e2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805e32:	48 89 d1             	mov    %rdx,%rcx
  805e35:	48 89 c2             	mov    %rax,%rdx
  805e38:	be 01 00 00 00       	mov    $0x1,%esi
  805e3d:	bf 0a 00 00 00       	mov    $0xa,%edi
  805e42:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805e49:	00 00 00 
  805e4c:	ff d0                	callq  *%rax
}
  805e4e:	c9                   	leaveq 
  805e4f:	c3                   	retq   

0000000000805e50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  805e50:	55                   	push   %rbp
  805e51:	48 89 e5             	mov    %rsp,%rbp
  805e54:	48 83 ec 30          	sub    $0x30,%rsp
  805e58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805e5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805e63:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  805e66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e69:	48 63 f0             	movslq %eax,%rsi
  805e6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e73:	48 98                	cltq   
  805e75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805e79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805e80:	00 
  805e81:	49 89 f1             	mov    %rsi,%r9
  805e84:	49 89 c8             	mov    %rcx,%r8
  805e87:	48 89 d1             	mov    %rdx,%rcx
  805e8a:	48 89 c2             	mov    %rax,%rdx
  805e8d:	be 00 00 00 00       	mov    $0x0,%esi
  805e92:	bf 0c 00 00 00       	mov    $0xc,%edi
  805e97:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805e9e:	00 00 00 
  805ea1:	ff d0                	callq  *%rax
}
  805ea3:	c9                   	leaveq 
  805ea4:	c3                   	retq   

0000000000805ea5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  805ea5:	55                   	push   %rbp
  805ea6:	48 89 e5             	mov    %rsp,%rbp
  805ea9:	48 83 ec 20          	sub    $0x20,%rsp
  805ead:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  805eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805eb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805ebc:	00 
  805ebd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805ec3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  805ece:	48 89 c2             	mov    %rax,%rdx
  805ed1:	be 01 00 00 00       	mov    $0x1,%esi
  805ed6:	bf 0d 00 00 00       	mov    $0xd,%edi
  805edb:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805ee2:	00 00 00 
  805ee5:	ff d0                	callq  *%rax
}
  805ee7:	c9                   	leaveq 
  805ee8:	c3                   	retq   

0000000000805ee9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  805ee9:	55                   	push   %rbp
  805eea:	48 89 e5             	mov    %rsp,%rbp
  805eed:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  805ef1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805ef8:	00 
  805ef9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805eff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805f05:	b9 00 00 00 00       	mov    $0x0,%ecx
  805f0a:	ba 00 00 00 00       	mov    $0x0,%edx
  805f0f:	be 00 00 00 00       	mov    $0x0,%esi
  805f14:	bf 0e 00 00 00       	mov    $0xe,%edi
  805f19:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805f20:	00 00 00 
  805f23:	ff d0                	callq  *%rax
}
  805f25:	c9                   	leaveq 
  805f26:	c3                   	retq   

0000000000805f27 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  805f27:	55                   	push   %rbp
  805f28:	48 89 e5             	mov    %rsp,%rbp
  805f2b:	48 83 ec 20          	sub    $0x20,%rsp
  805f2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805f33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  805f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805f3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805f46:	00 
  805f47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805f4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805f53:	48 89 d1             	mov    %rdx,%rcx
  805f56:	48 89 c2             	mov    %rax,%rdx
  805f59:	be 00 00 00 00       	mov    $0x0,%esi
  805f5e:	bf 0f 00 00 00       	mov    $0xf,%edi
  805f63:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805f6a:	00 00 00 
  805f6d:	ff d0                	callq  *%rax
}
  805f6f:	c9                   	leaveq 
  805f70:	c3                   	retq   

0000000000805f71 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  805f71:	55                   	push   %rbp
  805f72:	48 89 e5             	mov    %rsp,%rbp
  805f75:	48 83 ec 20          	sub    $0x20,%rsp
  805f79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805f7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  805f81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805f85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805f89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  805f90:	00 
  805f91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  805f97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805f9d:	48 89 d1             	mov    %rdx,%rcx
  805fa0:	48 89 c2             	mov    %rax,%rdx
  805fa3:	be 00 00 00 00       	mov    $0x0,%esi
  805fa8:	bf 10 00 00 00       	mov    $0x10,%edi
  805fad:	48 b8 98 5a 80 00 00 	movabs $0x805a98,%rax
  805fb4:	00 00 00 
  805fb7:	ff d0                	callq  *%rax
}
  805fb9:	c9                   	leaveq 
  805fba:	c3                   	retq   
	...

0000000000805fbc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805fbc:	55                   	push   %rbp
  805fbd:	48 89 e5             	mov    %rsp,%rbp
  805fc0:	48 83 ec 20          	sub    $0x20,%rsp
  805fc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  805fc8:	48 b8 88 40 81 00 00 	movabs $0x814088,%rax
  805fcf:	00 00 00 
  805fd2:	48 8b 00             	mov    (%rax),%rax
  805fd5:	48 85 c0             	test   %rax,%rax
  805fd8:	0f 85 8e 00 00 00    	jne    80606c <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  805fde:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  805fe5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  805fec:	48 b8 00 5c 80 00 00 	movabs $0x805c00,%rax
  805ff3:	00 00 00 
  805ff6:	ff d0                	callq  *%rax
  805ff8:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  805ffb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  805fff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806002:	ba 07 00 00 00       	mov    $0x7,%edx
  806007:	48 89 ce             	mov    %rcx,%rsi
  80600a:	89 c7                	mov    %eax,%edi
  80600c:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  806013:	00 00 00 
  806016:	ff d0                	callq  *%rax
  806018:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80601b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80601f:	74 30                	je     806051 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  806021:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806024:	89 c1                	mov    %eax,%ecx
  806026:	48 ba 70 94 80 00 00 	movabs $0x809470,%rdx
  80602d:	00 00 00 
  806030:	be 24 00 00 00       	mov    $0x24,%esi
  806035:	48 bf a7 94 80 00 00 	movabs $0x8094a7,%rdi
  80603c:	00 00 00 
  80603f:	b8 00 00 00 00       	mov    $0x0,%eax
  806044:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80604b:	00 00 00 
  80604e:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  806051:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806054:	48 be 80 60 80 00 00 	movabs $0x806080,%rsi
  80605b:	00 00 00 
  80605e:	89 c7                	mov    %eax,%edi
  806060:	48 b8 06 5e 80 00 00 	movabs $0x805e06,%rax
  806067:	00 00 00 
  80606a:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80606c:	48 b8 88 40 81 00 00 	movabs $0x814088,%rax
  806073:	00 00 00 
  806076:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80607a:	48 89 10             	mov    %rdx,(%rax)
}
  80607d:	c9                   	leaveq 
  80607e:	c3                   	retq   
	...

0000000000806080 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  806080:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  806083:	48 a1 88 40 81 00 00 	movabs 0x814088,%rax
  80608a:	00 00 00 
	call *%rax
  80608d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80608f:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  806093:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  806097:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80609a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8060a1:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8060a2:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8060a7:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8060aa:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8060ab:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8060ae:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8060b5:	00 08 
		POPA_						// copy the register contents to the registers
  8060b7:	4c 8b 3c 24          	mov    (%rsp),%r15
  8060bb:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8060c0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8060c5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8060ca:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8060cf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8060d4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8060d9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8060de:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8060e3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8060e8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8060ed:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8060f2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8060f7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8060fc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806101:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  806105:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  806109:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80610a:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80610b:	c3                   	retq   

000000000080610c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80610c:	55                   	push   %rbp
  80610d:	48 89 e5             	mov    %rsp,%rbp
  806110:	48 83 ec 30          	sub    $0x30,%rsp
  806114:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806118:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80611c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  806120:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806125:	74 18                	je     80613f <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  806127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80612b:	48 89 c7             	mov    %rax,%rdi
  80612e:	48 b8 a5 5e 80 00 00 	movabs $0x805ea5,%rax
  806135:	00 00 00 
  806138:	ff d0                	callq  *%rax
  80613a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80613d:	eb 19                	jmp    806158 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80613f:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  806146:	00 00 00 
  806149:	48 b8 a5 5e 80 00 00 	movabs $0x805ea5,%rax
  806150:	00 00 00 
  806153:	ff d0                	callq  *%rax
  806155:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  806158:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80615c:	79 19                	jns    806177 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80615e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806162:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  806168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80616c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  806172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806175:	eb 53                	jmp    8061ca <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  806177:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80617c:	74 19                	je     806197 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  80617e:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  806185:	00 00 00 
  806188:	48 8b 00             	mov    (%rax),%rax
  80618b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  806191:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806195:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  806197:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80619c:	74 19                	je     8061b7 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80619e:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  8061a5:	00 00 00 
  8061a8:	48 8b 00             	mov    (%rax),%rax
  8061ab:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8061b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061b5:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8061b7:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  8061be:	00 00 00 
  8061c1:	48 8b 00             	mov    (%rax),%rax
  8061c4:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8061ca:	c9                   	leaveq 
  8061cb:	c3                   	retq   

00000000008061cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8061cc:	55                   	push   %rbp
  8061cd:	48 89 e5             	mov    %rsp,%rbp
  8061d0:	48 83 ec 30          	sub    $0x30,%rsp
  8061d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8061d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8061da:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8061de:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8061e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8061e8:	e9 96 00 00 00       	jmpq   806283 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8061ed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8061f2:	74 20                	je     806214 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8061f4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8061f7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8061fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8061fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806201:	89 c7                	mov    %eax,%edi
  806203:	48 b8 50 5e 80 00 00 	movabs $0x805e50,%rax
  80620a:	00 00 00 
  80620d:	ff d0                	callq  *%rax
  80620f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806212:	eb 2d                	jmp    806241 <ipc_send+0x75>
		else if(pg==NULL)
  806214:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  806219:	75 26                	jne    806241 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80621b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80621e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806221:	b9 00 00 00 00       	mov    $0x0,%ecx
  806226:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80622d:	00 00 00 
  806230:	89 c7                	mov    %eax,%edi
  806232:	48 b8 50 5e 80 00 00 	movabs $0x805e50,%rax
  806239:	00 00 00 
  80623c:	ff d0                	callq  *%rax
  80623e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  806241:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806245:	79 30                	jns    806277 <ipc_send+0xab>
  806247:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80624b:	74 2a                	je     806277 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  80624d:	48 ba b5 94 80 00 00 	movabs $0x8094b5,%rdx
  806254:	00 00 00 
  806257:	be 40 00 00 00       	mov    $0x40,%esi
  80625c:	48 bf cd 94 80 00 00 	movabs $0x8094cd,%rdi
  806263:	00 00 00 
  806266:	b8 00 00 00 00       	mov    $0x0,%eax
  80626b:	48 b9 4c 45 80 00 00 	movabs $0x80454c,%rcx
  806272:	00 00 00 
  806275:	ff d1                	callq  *%rcx
		}
		sys_yield();
  806277:	48 b8 3e 5c 80 00 00 	movabs $0x805c3e,%rax
  80627e:	00 00 00 
  806281:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  806283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806287:	0f 85 60 ff ff ff    	jne    8061ed <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80628d:	c9                   	leaveq 
  80628e:	c3                   	retq   

000000000080628f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80628f:	55                   	push   %rbp
  806290:	48 89 e5             	mov    %rsp,%rbp
  806293:	48 83 ec 18          	sub    $0x18,%rsp
  806297:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80629a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8062a1:	eb 5e                	jmp    806301 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8062a3:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8062aa:	00 00 00 
  8062ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062b0:	48 63 d0             	movslq %eax,%rdx
  8062b3:	48 89 d0             	mov    %rdx,%rax
  8062b6:	48 c1 e0 03          	shl    $0x3,%rax
  8062ba:	48 01 d0             	add    %rdx,%rax
  8062bd:	48 c1 e0 05          	shl    $0x5,%rax
  8062c1:	48 01 c8             	add    %rcx,%rax
  8062c4:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8062ca:	8b 00                	mov    (%rax),%eax
  8062cc:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8062cf:	75 2c                	jne    8062fd <ipc_find_env+0x6e>
			return envs[i].env_id;
  8062d1:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8062d8:	00 00 00 
  8062db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062de:	48 63 d0             	movslq %eax,%rdx
  8062e1:	48 89 d0             	mov    %rdx,%rax
  8062e4:	48 c1 e0 03          	shl    $0x3,%rax
  8062e8:	48 01 d0             	add    %rdx,%rax
  8062eb:	48 c1 e0 05          	shl    $0x5,%rax
  8062ef:	48 01 c8             	add    %rcx,%rax
  8062f2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8062f8:	8b 40 08             	mov    0x8(%rax),%eax
  8062fb:	eb 12                	jmp    80630f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8062fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806301:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  806308:	7e 99                	jle    8062a3 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80630a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80630f:	c9                   	leaveq 
  806310:	c3                   	retq   
  806311:	00 00                	add    %al,(%rax)
	...

0000000000806314 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  806314:	55                   	push   %rbp
  806315:	48 89 e5             	mov    %rsp,%rbp
  806318:	48 83 ec 08          	sub    $0x8,%rsp
  80631c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  806320:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806324:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80632b:	ff ff ff 
  80632e:	48 01 d0             	add    %rdx,%rax
  806331:	48 c1 e8 0c          	shr    $0xc,%rax
}
  806335:	c9                   	leaveq 
  806336:	c3                   	retq   

0000000000806337 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  806337:	55                   	push   %rbp
  806338:	48 89 e5             	mov    %rsp,%rbp
  80633b:	48 83 ec 08          	sub    $0x8,%rsp
  80633f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  806343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806347:	48 89 c7             	mov    %rax,%rdi
  80634a:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  806351:	00 00 00 
  806354:	ff d0                	callq  *%rax
  806356:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80635c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  806360:	c9                   	leaveq 
  806361:	c3                   	retq   

0000000000806362 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  806362:	55                   	push   %rbp
  806363:	48 89 e5             	mov    %rsp,%rbp
  806366:	48 83 ec 18          	sub    $0x18,%rsp
  80636a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80636e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806375:	eb 6b                	jmp    8063e2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  806377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80637a:	48 98                	cltq   
  80637c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  806382:	48 c1 e0 0c          	shl    $0xc,%rax
  806386:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80638a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80638e:	48 89 c2             	mov    %rax,%rdx
  806391:	48 c1 ea 15          	shr    $0x15,%rdx
  806395:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80639c:	01 00 00 
  80639f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8063a3:	83 e0 01             	and    $0x1,%eax
  8063a6:	48 85 c0             	test   %rax,%rax
  8063a9:	74 21                	je     8063cc <fd_alloc+0x6a>
  8063ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063af:	48 89 c2             	mov    %rax,%rdx
  8063b2:	48 c1 ea 0c          	shr    $0xc,%rdx
  8063b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8063bd:	01 00 00 
  8063c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8063c4:	83 e0 01             	and    $0x1,%eax
  8063c7:	48 85 c0             	test   %rax,%rax
  8063ca:	75 12                	jne    8063de <fd_alloc+0x7c>
			*fd_store = fd;
  8063cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8063d4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8063d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8063dc:	eb 1a                	jmp    8063f8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8063de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8063e2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8063e6:	7e 8f                	jle    806377 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8063e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063ec:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8063f3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8063f8:	c9                   	leaveq 
  8063f9:	c3                   	retq   

00000000008063fa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8063fa:	55                   	push   %rbp
  8063fb:	48 89 e5             	mov    %rsp,%rbp
  8063fe:	48 83 ec 20          	sub    $0x20,%rsp
  806402:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  806409:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80640d:	78 06                	js     806415 <fd_lookup+0x1b>
  80640f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  806413:	7e 07                	jle    80641c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  806415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80641a:	eb 6c                	jmp    806488 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80641c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80641f:	48 98                	cltq   
  806421:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  806427:	48 c1 e0 0c          	shl    $0xc,%rax
  80642b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80642f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806433:	48 89 c2             	mov    %rax,%rdx
  806436:	48 c1 ea 15          	shr    $0x15,%rdx
  80643a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  806441:	01 00 00 
  806444:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806448:	83 e0 01             	and    $0x1,%eax
  80644b:	48 85 c0             	test   %rax,%rax
  80644e:	74 21                	je     806471 <fd_lookup+0x77>
  806450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806454:	48 89 c2             	mov    %rax,%rdx
  806457:	48 c1 ea 0c          	shr    $0xc,%rdx
  80645b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806462:	01 00 00 
  806465:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806469:	83 e0 01             	and    $0x1,%eax
  80646c:	48 85 c0             	test   %rax,%rax
  80646f:	75 07                	jne    806478 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  806471:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  806476:	eb 10                	jmp    806488 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  806478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80647c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  806480:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  806483:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806488:	c9                   	leaveq 
  806489:	c3                   	retq   

000000000080648a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80648a:	55                   	push   %rbp
  80648b:	48 89 e5             	mov    %rsp,%rbp
  80648e:	48 83 ec 30          	sub    $0x30,%rsp
  806492:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806496:	89 f0                	mov    %esi,%eax
  806498:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80649b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80649f:	48 89 c7             	mov    %rax,%rdi
  8064a2:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  8064a9:	00 00 00 
  8064ac:	ff d0                	callq  *%rax
  8064ae:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8064b2:	48 89 d6             	mov    %rdx,%rsi
  8064b5:	89 c7                	mov    %eax,%edi
  8064b7:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  8064be:	00 00 00 
  8064c1:	ff d0                	callq  *%rax
  8064c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8064c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8064ca:	78 0a                	js     8064d6 <fd_close+0x4c>
	    || fd != fd2)
  8064cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064d0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8064d4:	74 12                	je     8064e8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8064d6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8064da:	74 05                	je     8064e1 <fd_close+0x57>
  8064dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064df:	eb 05                	jmp    8064e6 <fd_close+0x5c>
  8064e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8064e6:	eb 69                	jmp    806551 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8064e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8064ec:	8b 00                	mov    (%rax),%eax
  8064ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8064f2:	48 89 d6             	mov    %rdx,%rsi
  8064f5:	89 c7                	mov    %eax,%edi
  8064f7:	48 b8 53 65 80 00 00 	movabs $0x806553,%rax
  8064fe:	00 00 00 
  806501:	ff d0                	callq  *%rax
  806503:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80650a:	78 2a                	js     806536 <fd_close+0xac>
		if (dev->dev_close)
  80650c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806510:	48 8b 40 20          	mov    0x20(%rax),%rax
  806514:	48 85 c0             	test   %rax,%rax
  806517:	74 16                	je     80652f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  806519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80651d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  806521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806525:	48 89 c7             	mov    %rax,%rdi
  806528:	ff d2                	callq  *%rdx
  80652a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80652d:	eb 07                	jmp    806536 <fd_close+0xac>
		else
			r = 0;
  80652f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  806536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80653a:	48 89 c6             	mov    %rax,%rsi
  80653d:	bf 00 00 00 00       	mov    $0x0,%edi
  806542:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  806549:	00 00 00 
  80654c:	ff d0                	callq  *%rax
	return r;
  80654e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806551:	c9                   	leaveq 
  806552:	c3                   	retq   

0000000000806553 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  806553:	55                   	push   %rbp
  806554:	48 89 e5             	mov    %rsp,%rbp
  806557:	48 83 ec 20          	sub    $0x20,%rsp
  80655b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80655e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  806562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806569:	eb 41                	jmp    8065ac <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80656b:	48 b8 a0 30 81 00 00 	movabs $0x8130a0,%rax
  806572:	00 00 00 
  806575:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806578:	48 63 d2             	movslq %edx,%rdx
  80657b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80657f:	8b 00                	mov    (%rax),%eax
  806581:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806584:	75 22                	jne    8065a8 <dev_lookup+0x55>
			*dev = devtab[i];
  806586:	48 b8 a0 30 81 00 00 	movabs $0x8130a0,%rax
  80658d:	00 00 00 
  806590:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806593:	48 63 d2             	movslq %edx,%rdx
  806596:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80659a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80659e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8065a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8065a6:	eb 60                	jmp    806608 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8065a8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8065ac:	48 b8 a0 30 81 00 00 	movabs $0x8130a0,%rax
  8065b3:	00 00 00 
  8065b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8065b9:	48 63 d2             	movslq %edx,%rdx
  8065bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8065c0:	48 85 c0             	test   %rax,%rax
  8065c3:	75 a6                	jne    80656b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8065c5:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  8065cc:	00 00 00 
  8065cf:	48 8b 00             	mov    (%rax),%rax
  8065d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8065d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8065db:	89 c6                	mov    %eax,%esi
  8065dd:	48 bf d8 94 80 00 00 	movabs $0x8094d8,%rdi
  8065e4:	00 00 00 
  8065e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8065ec:	48 b9 87 47 80 00 00 	movabs $0x804787,%rcx
  8065f3:	00 00 00 
  8065f6:	ff d1                	callq  *%rcx
	*dev = 0;
  8065f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8065fc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  806603:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  806608:	c9                   	leaveq 
  806609:	c3                   	retq   

000000000080660a <close>:

int
close(int fdnum)
{
  80660a:	55                   	push   %rbp
  80660b:	48 89 e5             	mov    %rsp,%rbp
  80660e:	48 83 ec 20          	sub    $0x20,%rsp
  806612:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806615:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806619:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80661c:	48 89 d6             	mov    %rdx,%rsi
  80661f:	89 c7                	mov    %eax,%edi
  806621:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  806628:	00 00 00 
  80662b:	ff d0                	callq  *%rax
  80662d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806634:	79 05                	jns    80663b <close+0x31>
		return r;
  806636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806639:	eb 18                	jmp    806653 <close+0x49>
	else
		return fd_close(fd, 1);
  80663b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80663f:	be 01 00 00 00       	mov    $0x1,%esi
  806644:	48 89 c7             	mov    %rax,%rdi
  806647:	48 b8 8a 64 80 00 00 	movabs $0x80648a,%rax
  80664e:	00 00 00 
  806651:	ff d0                	callq  *%rax
}
  806653:	c9                   	leaveq 
  806654:	c3                   	retq   

0000000000806655 <close_all>:

void
close_all(void)
{
  806655:	55                   	push   %rbp
  806656:	48 89 e5             	mov    %rsp,%rbp
  806659:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80665d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806664:	eb 15                	jmp    80667b <close_all+0x26>
		close(i);
  806666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806669:	89 c7                	mov    %eax,%edi
  80666b:	48 b8 0a 66 80 00 00 	movabs $0x80660a,%rax
  806672:	00 00 00 
  806675:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  806677:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80667b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80667f:	7e e5                	jle    806666 <close_all+0x11>
		close(i);
}
  806681:	c9                   	leaveq 
  806682:	c3                   	retq   

0000000000806683 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  806683:	55                   	push   %rbp
  806684:	48 89 e5             	mov    %rsp,%rbp
  806687:	48 83 ec 40          	sub    $0x40,%rsp
  80668b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80668e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  806691:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  806695:	8b 45 cc             	mov    -0x34(%rbp),%eax
  806698:	48 89 d6             	mov    %rdx,%rsi
  80669b:	89 c7                	mov    %eax,%edi
  80669d:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  8066a4:	00 00 00 
  8066a7:	ff d0                	callq  *%rax
  8066a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066b0:	79 08                	jns    8066ba <dup+0x37>
		return r;
  8066b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066b5:	e9 70 01 00 00       	jmpq   80682a <dup+0x1a7>
	close(newfdnum);
  8066ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8066bd:	89 c7                	mov    %eax,%edi
  8066bf:	48 b8 0a 66 80 00 00 	movabs $0x80660a,%rax
  8066c6:	00 00 00 
  8066c9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8066cb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8066ce:	48 98                	cltq   
  8066d0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8066d6:	48 c1 e0 0c          	shl    $0xc,%rax
  8066da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8066de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8066e2:	48 89 c7             	mov    %rax,%rdi
  8066e5:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  8066ec:	00 00 00 
  8066ef:	ff d0                	callq  *%rax
  8066f1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8066f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066f9:	48 89 c7             	mov    %rax,%rdi
  8066fc:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  806703:	00 00 00 
  806706:	ff d0                	callq  *%rax
  806708:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80670c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806710:	48 89 c2             	mov    %rax,%rdx
  806713:	48 c1 ea 15          	shr    $0x15,%rdx
  806717:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80671e:	01 00 00 
  806721:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806725:	83 e0 01             	and    $0x1,%eax
  806728:	84 c0                	test   %al,%al
  80672a:	74 71                	je     80679d <dup+0x11a>
  80672c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806730:	48 89 c2             	mov    %rax,%rdx
  806733:	48 c1 ea 0c          	shr    $0xc,%rdx
  806737:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80673e:	01 00 00 
  806741:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806745:	83 e0 01             	and    $0x1,%eax
  806748:	84 c0                	test   %al,%al
  80674a:	74 51                	je     80679d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80674c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806750:	48 89 c2             	mov    %rax,%rdx
  806753:	48 c1 ea 0c          	shr    $0xc,%rdx
  806757:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80675e:	01 00 00 
  806761:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806765:	89 c1                	mov    %eax,%ecx
  806767:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80676d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  806771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806775:	41 89 c8             	mov    %ecx,%r8d
  806778:	48 89 d1             	mov    %rdx,%rcx
  80677b:	ba 00 00 00 00       	mov    $0x0,%edx
  806780:	48 89 c6             	mov    %rax,%rsi
  806783:	bf 00 00 00 00       	mov    $0x0,%edi
  806788:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  80678f:	00 00 00 
  806792:	ff d0                	callq  *%rax
  806794:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806797:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80679b:	78 56                	js     8067f3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80679d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8067a1:	48 89 c2             	mov    %rax,%rdx
  8067a4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8067a8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8067af:	01 00 00 
  8067b2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8067b6:	89 c1                	mov    %eax,%ecx
  8067b8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8067be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8067c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8067c6:	41 89 c8             	mov    %ecx,%r8d
  8067c9:	48 89 d1             	mov    %rdx,%rcx
  8067cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8067d1:	48 89 c6             	mov    %rax,%rsi
  8067d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8067d9:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  8067e0:	00 00 00 
  8067e3:	ff d0                	callq  *%rax
  8067e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067ec:	78 08                	js     8067f6 <dup+0x173>
		goto err;

	return newfdnum;
  8067ee:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8067f1:	eb 37                	jmp    80682a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8067f3:	90                   	nop
  8067f4:	eb 01                	jmp    8067f7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8067f6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8067f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067fb:	48 89 c6             	mov    %rax,%rsi
  8067fe:	bf 00 00 00 00       	mov    $0x0,%edi
  806803:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  80680a:	00 00 00 
  80680d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80680f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806813:	48 89 c6             	mov    %rax,%rsi
  806816:	bf 00 00 00 00       	mov    $0x0,%edi
  80681b:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  806822:	00 00 00 
  806825:	ff d0                	callq  *%rax
	return r;
  806827:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80682a:	c9                   	leaveq 
  80682b:	c3                   	retq   

000000000080682c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80682c:	55                   	push   %rbp
  80682d:	48 89 e5             	mov    %rsp,%rbp
  806830:	48 83 ec 40          	sub    $0x40,%rsp
  806834:	89 7d dc             	mov    %edi,-0x24(%rbp)
  806837:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80683b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80683f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806843:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806846:	48 89 d6             	mov    %rdx,%rsi
  806849:	89 c7                	mov    %eax,%edi
  80684b:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  806852:	00 00 00 
  806855:	ff d0                	callq  *%rax
  806857:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80685a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80685e:	78 24                	js     806884 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  806860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806864:	8b 00                	mov    (%rax),%eax
  806866:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80686a:	48 89 d6             	mov    %rdx,%rsi
  80686d:	89 c7                	mov    %eax,%edi
  80686f:	48 b8 53 65 80 00 00 	movabs $0x806553,%rax
  806876:	00 00 00 
  806879:	ff d0                	callq  *%rax
  80687b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80687e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806882:	79 05                	jns    806889 <read+0x5d>
		return r;
  806884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806887:	eb 7a                	jmp    806903 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  806889:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80688d:	8b 40 08             	mov    0x8(%rax),%eax
  806890:	83 e0 03             	and    $0x3,%eax
  806893:	83 f8 01             	cmp    $0x1,%eax
  806896:	75 3a                	jne    8068d2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  806898:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  80689f:	00 00 00 
  8068a2:	48 8b 00             	mov    (%rax),%rax
  8068a5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8068ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8068ae:	89 c6                	mov    %eax,%esi
  8068b0:	48 bf f7 94 80 00 00 	movabs $0x8094f7,%rdi
  8068b7:	00 00 00 
  8068ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8068bf:	48 b9 87 47 80 00 00 	movabs $0x804787,%rcx
  8068c6:	00 00 00 
  8068c9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8068cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8068d0:	eb 31                	jmp    806903 <read+0xd7>
	}
	if (!dev->dev_read)
  8068d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068d6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8068da:	48 85 c0             	test   %rax,%rax
  8068dd:	75 07                	jne    8068e6 <read+0xba>
		return -E_NOT_SUPP;
  8068df:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8068e4:	eb 1d                	jmp    806903 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8068e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068ea:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8068ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8068f2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8068f6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8068fa:	48 89 ce             	mov    %rcx,%rsi
  8068fd:	48 89 c7             	mov    %rax,%rdi
  806900:	41 ff d0             	callq  *%r8
}
  806903:	c9                   	leaveq 
  806904:	c3                   	retq   

0000000000806905 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  806905:	55                   	push   %rbp
  806906:	48 89 e5             	mov    %rsp,%rbp
  806909:	48 83 ec 30          	sub    $0x30,%rsp
  80690d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806910:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806914:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  806918:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80691f:	eb 46                	jmp    806967 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  806921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806924:	48 98                	cltq   
  806926:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80692a:	48 29 c2             	sub    %rax,%rdx
  80692d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806930:	48 98                	cltq   
  806932:	48 89 c1             	mov    %rax,%rcx
  806935:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  806939:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80693c:	48 89 ce             	mov    %rcx,%rsi
  80693f:	89 c7                	mov    %eax,%edi
  806941:	48 b8 2c 68 80 00 00 	movabs $0x80682c,%rax
  806948:	00 00 00 
  80694b:	ff d0                	callq  *%rax
  80694d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  806950:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  806954:	79 05                	jns    80695b <readn+0x56>
			return m;
  806956:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806959:	eb 1d                	jmp    806978 <readn+0x73>
		if (m == 0)
  80695b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80695f:	74 13                	je     806974 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  806961:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806964:	01 45 fc             	add    %eax,-0x4(%rbp)
  806967:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80696a:	48 98                	cltq   
  80696c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  806970:	72 af                	jb     806921 <readn+0x1c>
  806972:	eb 01                	jmp    806975 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  806974:	90                   	nop
	}
	return tot;
  806975:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806978:	c9                   	leaveq 
  806979:	c3                   	retq   

000000000080697a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80697a:	55                   	push   %rbp
  80697b:	48 89 e5             	mov    %rsp,%rbp
  80697e:	48 83 ec 40          	sub    $0x40,%rsp
  806982:	89 7d dc             	mov    %edi,-0x24(%rbp)
  806985:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806989:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80698d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806991:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806994:	48 89 d6             	mov    %rdx,%rsi
  806997:	89 c7                	mov    %eax,%edi
  806999:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  8069a0:	00 00 00 
  8069a3:	ff d0                	callq  *%rax
  8069a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8069a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8069ac:	78 24                	js     8069d2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8069ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8069b2:	8b 00                	mov    (%rax),%eax
  8069b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8069b8:	48 89 d6             	mov    %rdx,%rsi
  8069bb:	89 c7                	mov    %eax,%edi
  8069bd:	48 b8 53 65 80 00 00 	movabs $0x806553,%rax
  8069c4:	00 00 00 
  8069c7:	ff d0                	callq  *%rax
  8069c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8069cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8069d0:	79 05                	jns    8069d7 <write+0x5d>
		return r;
  8069d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8069d5:	eb 79                	jmp    806a50 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8069d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8069db:	8b 40 08             	mov    0x8(%rax),%eax
  8069de:	83 e0 03             	and    $0x3,%eax
  8069e1:	85 c0                	test   %eax,%eax
  8069e3:	75 3a                	jne    806a1f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8069e5:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  8069ec:	00 00 00 
  8069ef:	48 8b 00             	mov    (%rax),%rax
  8069f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8069f8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8069fb:	89 c6                	mov    %eax,%esi
  8069fd:	48 bf 13 95 80 00 00 	movabs $0x809513,%rdi
  806a04:	00 00 00 
  806a07:	b8 00 00 00 00       	mov    $0x0,%eax
  806a0c:	48 b9 87 47 80 00 00 	movabs $0x804787,%rcx
  806a13:	00 00 00 
  806a16:	ff d1                	callq  *%rcx
		return -E_INVAL;
  806a18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  806a1d:	eb 31                	jmp    806a50 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  806a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a23:	48 8b 40 18          	mov    0x18(%rax),%rax
  806a27:	48 85 c0             	test   %rax,%rax
  806a2a:	75 07                	jne    806a33 <write+0xb9>
		return -E_NOT_SUPP;
  806a2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  806a31:	eb 1d                	jmp    806a50 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  806a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a37:	4c 8b 40 18          	mov    0x18(%rax),%r8
  806a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806a3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  806a43:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  806a47:	48 89 ce             	mov    %rcx,%rsi
  806a4a:	48 89 c7             	mov    %rax,%rdi
  806a4d:	41 ff d0             	callq  *%r8
}
  806a50:	c9                   	leaveq 
  806a51:	c3                   	retq   

0000000000806a52 <seek>:

int
seek(int fdnum, off_t offset)
{
  806a52:	55                   	push   %rbp
  806a53:	48 89 e5             	mov    %rsp,%rbp
  806a56:	48 83 ec 18          	sub    $0x18,%rsp
  806a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806a5d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806a60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806a64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806a67:	48 89 d6             	mov    %rdx,%rsi
  806a6a:	89 c7                	mov    %eax,%edi
  806a6c:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  806a73:	00 00 00 
  806a76:	ff d0                	callq  *%rax
  806a78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806a7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806a7f:	79 05                	jns    806a86 <seek+0x34>
		return r;
  806a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806a84:	eb 0f                	jmp    806a95 <seek+0x43>
	fd->fd_offset = offset;
  806a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a8a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806a8d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  806a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806a95:	c9                   	leaveq 
  806a96:	c3                   	retq   

0000000000806a97 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  806a97:	55                   	push   %rbp
  806a98:	48 89 e5             	mov    %rsp,%rbp
  806a9b:	48 83 ec 30          	sub    $0x30,%rsp
  806a9f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  806aa2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  806aa5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806aa9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806aac:	48 89 d6             	mov    %rdx,%rsi
  806aaf:	89 c7                	mov    %eax,%edi
  806ab1:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  806ab8:	00 00 00 
  806abb:	ff d0                	callq  *%rax
  806abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806ac4:	78 24                	js     806aea <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  806ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806aca:	8b 00                	mov    (%rax),%eax
  806acc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806ad0:	48 89 d6             	mov    %rdx,%rsi
  806ad3:	89 c7                	mov    %eax,%edi
  806ad5:	48 b8 53 65 80 00 00 	movabs $0x806553,%rax
  806adc:	00 00 00 
  806adf:	ff d0                	callq  *%rax
  806ae1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806ae4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806ae8:	79 05                	jns    806aef <ftruncate+0x58>
		return r;
  806aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806aed:	eb 72                	jmp    806b61 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  806aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806af3:	8b 40 08             	mov    0x8(%rax),%eax
  806af6:	83 e0 03             	and    $0x3,%eax
  806af9:	85 c0                	test   %eax,%eax
  806afb:	75 3a                	jne    806b37 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  806afd:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  806b04:	00 00 00 
  806b07:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  806b0a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806b10:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806b13:	89 c6                	mov    %eax,%esi
  806b15:	48 bf 30 95 80 00 00 	movabs $0x809530,%rdi
  806b1c:	00 00 00 
  806b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  806b24:	48 b9 87 47 80 00 00 	movabs $0x804787,%rcx
  806b2b:	00 00 00 
  806b2e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  806b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  806b35:	eb 2a                	jmp    806b61 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  806b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b3b:	48 8b 40 30          	mov    0x30(%rax),%rax
  806b3f:	48 85 c0             	test   %rax,%rax
  806b42:	75 07                	jne    806b4b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  806b44:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  806b49:	eb 16                	jmp    806b61 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  806b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b4f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  806b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806b57:	8b 55 d8             	mov    -0x28(%rbp),%edx
  806b5a:	89 d6                	mov    %edx,%esi
  806b5c:	48 89 c7             	mov    %rax,%rdi
  806b5f:	ff d1                	callq  *%rcx
}
  806b61:	c9                   	leaveq 
  806b62:	c3                   	retq   

0000000000806b63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  806b63:	55                   	push   %rbp
  806b64:	48 89 e5             	mov    %rsp,%rbp
  806b67:	48 83 ec 30          	sub    $0x30,%rsp
  806b6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  806b6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  806b72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806b76:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806b79:	48 89 d6             	mov    %rdx,%rsi
  806b7c:	89 c7                	mov    %eax,%edi
  806b7e:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  806b85:	00 00 00 
  806b88:	ff d0                	callq  *%rax
  806b8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806b91:	78 24                	js     806bb7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  806b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806b97:	8b 00                	mov    (%rax),%eax
  806b99:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806b9d:	48 89 d6             	mov    %rdx,%rsi
  806ba0:	89 c7                	mov    %eax,%edi
  806ba2:	48 b8 53 65 80 00 00 	movabs $0x806553,%rax
  806ba9:	00 00 00 
  806bac:	ff d0                	callq  *%rax
  806bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806bb5:	79 05                	jns    806bbc <fstat+0x59>
		return r;
  806bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806bba:	eb 5e                	jmp    806c1a <fstat+0xb7>
	if (!dev->dev_stat)
  806bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806bc0:	48 8b 40 28          	mov    0x28(%rax),%rax
  806bc4:	48 85 c0             	test   %rax,%rax
  806bc7:	75 07                	jne    806bd0 <fstat+0x6d>
		return -E_NOT_SUPP;
  806bc9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  806bce:	eb 4a                	jmp    806c1a <fstat+0xb7>
	stat->st_name[0] = 0;
  806bd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806bd4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  806bd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806bdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  806be2:	00 00 00 
	stat->st_isdir = 0;
  806be5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806be9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806bf0:	00 00 00 
	stat->st_dev = dev;
  806bf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806bf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806bfb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  806c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806c06:	48 8b 48 28          	mov    0x28(%rax),%rcx
  806c0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806c0e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  806c12:	48 89 d6             	mov    %rdx,%rsi
  806c15:	48 89 c7             	mov    %rax,%rdi
  806c18:	ff d1                	callq  *%rcx
}
  806c1a:	c9                   	leaveq 
  806c1b:	c3                   	retq   

0000000000806c1c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  806c1c:	55                   	push   %rbp
  806c1d:	48 89 e5             	mov    %rsp,%rbp
  806c20:	48 83 ec 20          	sub    $0x20,%rsp
  806c24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806c28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  806c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806c30:	be 00 00 00 00       	mov    $0x0,%esi
  806c35:	48 89 c7             	mov    %rax,%rdi
  806c38:	48 b8 0b 6d 80 00 00 	movabs $0x806d0b,%rax
  806c3f:	00 00 00 
  806c42:	ff d0                	callq  *%rax
  806c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c4b:	79 05                	jns    806c52 <stat+0x36>
		return fd;
  806c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c50:	eb 2f                	jmp    806c81 <stat+0x65>
	r = fstat(fd, stat);
  806c52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  806c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c59:	48 89 d6             	mov    %rdx,%rsi
  806c5c:	89 c7                	mov    %eax,%edi
  806c5e:	48 b8 63 6b 80 00 00 	movabs $0x806b63,%rax
  806c65:	00 00 00 
  806c68:	ff d0                	callq  *%rax
  806c6a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  806c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c70:	89 c7                	mov    %eax,%edi
  806c72:	48 b8 0a 66 80 00 00 	movabs $0x80660a,%rax
  806c79:	00 00 00 
  806c7c:	ff d0                	callq  *%rax
	return r;
  806c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  806c81:	c9                   	leaveq 
  806c82:	c3                   	retq   
	...

0000000000806c84 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  806c84:	55                   	push   %rbp
  806c85:	48 89 e5             	mov    %rsp,%rbp
  806c88:	48 83 ec 10          	sub    $0x10,%rsp
  806c8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806c8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  806c93:	48 b8 4c 40 81 00 00 	movabs $0x81404c,%rax
  806c9a:	00 00 00 
  806c9d:	8b 00                	mov    (%rax),%eax
  806c9f:	85 c0                	test   %eax,%eax
  806ca1:	75 1d                	jne    806cc0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  806ca3:	bf 01 00 00 00       	mov    $0x1,%edi
  806ca8:	48 b8 8f 62 80 00 00 	movabs $0x80628f,%rax
  806caf:	00 00 00 
  806cb2:	ff d0                	callq  *%rax
  806cb4:	48 ba 4c 40 81 00 00 	movabs $0x81404c,%rdx
  806cbb:	00 00 00 
  806cbe:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  806cc0:	48 b8 4c 40 81 00 00 	movabs $0x81404c,%rax
  806cc7:	00 00 00 
  806cca:	8b 00                	mov    (%rax),%eax
  806ccc:	8b 75 fc             	mov    -0x4(%rbp),%esi
  806ccf:	b9 07 00 00 00       	mov    $0x7,%ecx
  806cd4:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  806cdb:	00 00 00 
  806cde:	89 c7                	mov    %eax,%edi
  806ce0:	48 b8 cc 61 80 00 00 	movabs $0x8061cc,%rax
  806ce7:	00 00 00 
  806cea:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  806cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  806cf5:	48 89 c6             	mov    %rax,%rsi
  806cf8:	bf 00 00 00 00       	mov    $0x0,%edi
  806cfd:	48 b8 0c 61 80 00 00 	movabs $0x80610c,%rax
  806d04:	00 00 00 
  806d07:	ff d0                	callq  *%rax
}
  806d09:	c9                   	leaveq 
  806d0a:	c3                   	retq   

0000000000806d0b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  806d0b:	55                   	push   %rbp
  806d0c:	48 89 e5             	mov    %rsp,%rbp
  806d0f:	48 83 ec 20          	sub    $0x20,%rsp
  806d13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806d17:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  806d1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806d1e:	48 89 c7             	mov    %rax,%rdi
  806d21:	48 b8 d8 52 80 00 00 	movabs $0x8052d8,%rax
  806d28:	00 00 00 
  806d2b:	ff d0                	callq  *%rax
  806d2d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  806d32:	7e 0a                	jle    806d3e <open+0x33>
                return -E_BAD_PATH;
  806d34:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  806d39:	e9 a5 00 00 00       	jmpq   806de3 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  806d3e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806d42:	48 89 c7             	mov    %rax,%rdi
  806d45:	48 b8 62 63 80 00 00 	movabs $0x806362,%rax
  806d4c:	00 00 00 
  806d4f:	ff d0                	callq  *%rax
  806d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806d58:	79 08                	jns    806d62 <open+0x57>
		return r;
  806d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806d5d:	e9 81 00 00 00       	jmpq   806de3 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  806d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806d66:	48 89 c6             	mov    %rax,%rsi
  806d69:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  806d70:	00 00 00 
  806d73:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  806d7a:	00 00 00 
  806d7d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  806d7f:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806d86:	00 00 00 
  806d89:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  806d8c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  806d92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806d96:	48 89 c6             	mov    %rax,%rsi
  806d99:	bf 01 00 00 00       	mov    $0x1,%edi
  806d9e:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806da5:	00 00 00 
  806da8:	ff d0                	callq  *%rax
  806daa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  806dad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806db1:	79 1d                	jns    806dd0 <open+0xc5>
	{
		fd_close(fd,0);
  806db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806db7:	be 00 00 00 00       	mov    $0x0,%esi
  806dbc:	48 89 c7             	mov    %rax,%rdi
  806dbf:	48 b8 8a 64 80 00 00 	movabs $0x80648a,%rax
  806dc6:	00 00 00 
  806dc9:	ff d0                	callq  *%rax
		return r;
  806dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806dce:	eb 13                	jmp    806de3 <open+0xd8>
	}
	return fd2num(fd);
  806dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806dd4:	48 89 c7             	mov    %rax,%rdi
  806dd7:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  806dde:	00 00 00 
  806de1:	ff d0                	callq  *%rax
	


}
  806de3:	c9                   	leaveq 
  806de4:	c3                   	retq   

0000000000806de5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  806de5:	55                   	push   %rbp
  806de6:	48 89 e5             	mov    %rsp,%rbp
  806de9:	48 83 ec 10          	sub    $0x10,%rsp
  806ded:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  806df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806df5:	8b 50 0c             	mov    0xc(%rax),%edx
  806df8:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806dff:	00 00 00 
  806e02:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  806e04:	be 00 00 00 00       	mov    $0x0,%esi
  806e09:	bf 06 00 00 00       	mov    $0x6,%edi
  806e0e:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806e15:	00 00 00 
  806e18:	ff d0                	callq  *%rax
}
  806e1a:	c9                   	leaveq 
  806e1b:	c3                   	retq   

0000000000806e1c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  806e1c:	55                   	push   %rbp
  806e1d:	48 89 e5             	mov    %rsp,%rbp
  806e20:	48 83 ec 30          	sub    $0x30,%rsp
  806e24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806e28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806e2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  806e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806e34:	8b 50 0c             	mov    0xc(%rax),%edx
  806e37:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806e3e:	00 00 00 
  806e41:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  806e43:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806e4a:	00 00 00 
  806e4d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806e51:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  806e55:	be 00 00 00 00       	mov    $0x0,%esi
  806e5a:	bf 03 00 00 00       	mov    $0x3,%edi
  806e5f:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806e66:	00 00 00 
  806e69:	ff d0                	callq  *%rax
  806e6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806e6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806e72:	79 05                	jns    806e79 <devfile_read+0x5d>
	{
		return r;
  806e74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806e77:	eb 2c                	jmp    806ea5 <devfile_read+0x89>
	}
	if(r > 0)
  806e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806e7d:	7e 23                	jle    806ea2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  806e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806e82:	48 63 d0             	movslq %eax,%rdx
  806e85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e89:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  806e90:	00 00 00 
  806e93:	48 89 c7             	mov    %rax,%rdi
  806e96:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  806e9d:	00 00 00 
  806ea0:	ff d0                	callq  *%rax
	return r;
  806ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  806ea5:	c9                   	leaveq 
  806ea6:	c3                   	retq   

0000000000806ea7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  806ea7:	55                   	push   %rbp
  806ea8:	48 89 e5             	mov    %rsp,%rbp
  806eab:	48 83 ec 30          	sub    $0x30,%rsp
  806eaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806eb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806eb7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  806ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806ebf:	8b 50 0c             	mov    0xc(%rax),%edx
  806ec2:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806ec9:	00 00 00 
  806ecc:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  806ece:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  806ed5:	00 
  806ed6:	76 08                	jbe    806ee0 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  806ed8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  806edf:	00 
	fsipcbuf.write.req_n=n;
  806ee0:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806ee7:	00 00 00 
  806eea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806eee:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  806ef2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806efa:	48 89 c6             	mov    %rax,%rsi
  806efd:	48 bf 10 50 81 00 00 	movabs $0x815010,%rdi
  806f04:	00 00 00 
  806f07:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  806f0e:	00 00 00 
  806f11:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  806f13:	be 00 00 00 00       	mov    $0x0,%esi
  806f18:	bf 04 00 00 00       	mov    $0x4,%edi
  806f1d:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806f24:	00 00 00 
  806f27:	ff d0                	callq  *%rax
  806f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  806f2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806f2f:	c9                   	leaveq 
  806f30:	c3                   	retq   

0000000000806f31 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  806f31:	55                   	push   %rbp
  806f32:	48 89 e5             	mov    %rsp,%rbp
  806f35:	48 83 ec 10          	sub    $0x10,%rsp
  806f39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806f3d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  806f40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806f44:	8b 50 0c             	mov    0xc(%rax),%edx
  806f47:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806f4e:	00 00 00 
  806f51:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  806f53:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806f5a:	00 00 00 
  806f5d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  806f60:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  806f63:	be 00 00 00 00       	mov    $0x0,%esi
  806f68:	bf 02 00 00 00       	mov    $0x2,%edi
  806f6d:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806f74:	00 00 00 
  806f77:	ff d0                	callq  *%rax
}
  806f79:	c9                   	leaveq 
  806f7a:	c3                   	retq   

0000000000806f7b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  806f7b:	55                   	push   %rbp
  806f7c:	48 89 e5             	mov    %rsp,%rbp
  806f7f:	48 83 ec 20          	sub    $0x20,%rsp
  806f83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806f87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  806f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806f8f:	8b 50 0c             	mov    0xc(%rax),%edx
  806f92:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806f99:	00 00 00 
  806f9c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  806f9e:	be 00 00 00 00       	mov    $0x0,%esi
  806fa3:	bf 05 00 00 00       	mov    $0x5,%edi
  806fa8:	48 b8 84 6c 80 00 00 	movabs $0x806c84,%rax
  806faf:	00 00 00 
  806fb2:	ff d0                	callq  *%rax
  806fb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806fbb:	79 05                	jns    806fc2 <devfile_stat+0x47>
		return r;
  806fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806fc0:	eb 56                	jmp    807018 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  806fc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806fc6:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  806fcd:	00 00 00 
  806fd0:	48 89 c7             	mov    %rax,%rdi
  806fd3:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  806fda:	00 00 00 
  806fdd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  806fdf:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806fe6:	00 00 00 
  806fe9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  806fef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806ff3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  806ff9:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  807000:	00 00 00 
  807003:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  807009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80700d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  807013:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807018:	c9                   	leaveq 
  807019:	c3                   	retq   
	...

000000000080701c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80701c:	55                   	push   %rbp
  80701d:	48 89 e5             	mov    %rsp,%rbp
  807020:	48 83 ec 18          	sub    $0x18,%rsp
  807024:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  807028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80702c:	48 89 c2             	mov    %rax,%rdx
  80702f:	48 c1 ea 15          	shr    $0x15,%rdx
  807033:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80703a:	01 00 00 
  80703d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  807041:	83 e0 01             	and    $0x1,%eax
  807044:	48 85 c0             	test   %rax,%rax
  807047:	75 07                	jne    807050 <pageref+0x34>
		return 0;
  807049:	b8 00 00 00 00       	mov    $0x0,%eax
  80704e:	eb 53                	jmp    8070a3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  807050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807054:	48 89 c2             	mov    %rax,%rdx
  807057:	48 c1 ea 0c          	shr    $0xc,%rdx
  80705b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  807062:	01 00 00 
  807065:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  807069:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80706d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807071:	83 e0 01             	and    $0x1,%eax
  807074:	48 85 c0             	test   %rax,%rax
  807077:	75 07                	jne    807080 <pageref+0x64>
		return 0;
  807079:	b8 00 00 00 00       	mov    $0x0,%eax
  80707e:	eb 23                	jmp    8070a3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  807080:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807084:	48 89 c2             	mov    %rax,%rdx
  807087:	48 c1 ea 0c          	shr    $0xc,%rdx
  80708b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  807092:	00 00 00 
  807095:	48 c1 e2 04          	shl    $0x4,%rdx
  807099:	48 01 d0             	add    %rdx,%rax
  80709c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8070a0:	0f b7 c0             	movzwl %ax,%eax
}
  8070a3:	c9                   	leaveq 
  8070a4:	c3                   	retq   
  8070a5:	00 00                	add    %al,(%rax)
	...

00000000008070a8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8070a8:	55                   	push   %rbp
  8070a9:	48 89 e5             	mov    %rsp,%rbp
  8070ac:	48 83 ec 20          	sub    $0x20,%rsp
  8070b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8070b3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8070b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8070ba:	48 89 d6             	mov    %rdx,%rsi
  8070bd:	89 c7                	mov    %eax,%edi
  8070bf:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  8070c6:	00 00 00 
  8070c9:	ff d0                	callq  *%rax
  8070cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8070ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8070d2:	79 05                	jns    8070d9 <fd2sockid+0x31>
		return r;
  8070d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8070d7:	eb 24                	jmp    8070fd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8070d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070dd:	8b 10                	mov    (%rax),%edx
  8070df:	48 b8 20 31 81 00 00 	movabs $0x813120,%rax
  8070e6:	00 00 00 
  8070e9:	8b 00                	mov    (%rax),%eax
  8070eb:	39 c2                	cmp    %eax,%edx
  8070ed:	74 07                	je     8070f6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8070ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8070f4:	eb 07                	jmp    8070fd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8070f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8070fa:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8070fd:	c9                   	leaveq 
  8070fe:	c3                   	retq   

00000000008070ff <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8070ff:	55                   	push   %rbp
  807100:	48 89 e5             	mov    %rsp,%rbp
  807103:	48 83 ec 20          	sub    $0x20,%rsp
  807107:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80710a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80710e:	48 89 c7             	mov    %rax,%rdi
  807111:	48 b8 62 63 80 00 00 	movabs $0x806362,%rax
  807118:	00 00 00 
  80711b:	ff d0                	callq  *%rax
  80711d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807120:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807124:	78 26                	js     80714c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  807126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80712a:	ba 07 04 00 00       	mov    $0x407,%edx
  80712f:	48 89 c6             	mov    %rax,%rsi
  807132:	bf 00 00 00 00       	mov    $0x0,%edi
  807137:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  80713e:	00 00 00 
  807141:	ff d0                	callq  *%rax
  807143:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807146:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80714a:	79 16                	jns    807162 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80714c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80714f:	89 c7                	mov    %eax,%edi
  807151:	48 b8 0c 76 80 00 00 	movabs $0x80760c,%rax
  807158:	00 00 00 
  80715b:	ff d0                	callq  *%rax
		return r;
  80715d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807160:	eb 3a                	jmp    80719c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  807162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807166:	48 ba 20 31 81 00 00 	movabs $0x813120,%rdx
  80716d:	00 00 00 
  807170:	8b 12                	mov    (%rdx),%edx
  807172:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  807174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807178:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80717f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807183:	8b 55 ec             	mov    -0x14(%rbp),%edx
  807186:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  807189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80718d:	48 89 c7             	mov    %rax,%rdi
  807190:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  807197:	00 00 00 
  80719a:	ff d0                	callq  *%rax
}
  80719c:	c9                   	leaveq 
  80719d:	c3                   	retq   

000000000080719e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80719e:	55                   	push   %rbp
  80719f:	48 89 e5             	mov    %rsp,%rbp
  8071a2:	48 83 ec 30          	sub    $0x30,%rsp
  8071a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8071a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8071ad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8071b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8071b4:	89 c7                	mov    %eax,%edi
  8071b6:	48 b8 a8 70 80 00 00 	movabs $0x8070a8,%rax
  8071bd:	00 00 00 
  8071c0:	ff d0                	callq  *%rax
  8071c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8071c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8071c9:	79 05                	jns    8071d0 <accept+0x32>
		return r;
  8071cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071ce:	eb 3b                	jmp    80720b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8071d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8071d4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8071d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071db:	48 89 ce             	mov    %rcx,%rsi
  8071de:	89 c7                	mov    %eax,%edi
  8071e0:	48 b8 e9 74 80 00 00 	movabs $0x8074e9,%rax
  8071e7:	00 00 00 
  8071ea:	ff d0                	callq  *%rax
  8071ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8071ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8071f3:	79 05                	jns    8071fa <accept+0x5c>
		return r;
  8071f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071f8:	eb 11                	jmp    80720b <accept+0x6d>
	return alloc_sockfd(r);
  8071fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8071fd:	89 c7                	mov    %eax,%edi
  8071ff:	48 b8 ff 70 80 00 00 	movabs $0x8070ff,%rax
  807206:	00 00 00 
  807209:	ff d0                	callq  *%rax
}
  80720b:	c9                   	leaveq 
  80720c:	c3                   	retq   

000000000080720d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80720d:	55                   	push   %rbp
  80720e:	48 89 e5             	mov    %rsp,%rbp
  807211:	48 83 ec 20          	sub    $0x20,%rsp
  807215:	89 7d ec             	mov    %edi,-0x14(%rbp)
  807218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80721c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80721f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807222:	89 c7                	mov    %eax,%edi
  807224:	48 b8 a8 70 80 00 00 	movabs $0x8070a8,%rax
  80722b:	00 00 00 
  80722e:	ff d0                	callq  *%rax
  807230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807237:	79 05                	jns    80723e <bind+0x31>
		return r;
  807239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80723c:	eb 1b                	jmp    807259 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80723e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  807241:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  807245:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807248:	48 89 ce             	mov    %rcx,%rsi
  80724b:	89 c7                	mov    %eax,%edi
  80724d:	48 b8 68 75 80 00 00 	movabs $0x807568,%rax
  807254:	00 00 00 
  807257:	ff d0                	callq  *%rax
}
  807259:	c9                   	leaveq 
  80725a:	c3                   	retq   

000000000080725b <shutdown>:

int
shutdown(int s, int how)
{
  80725b:	55                   	push   %rbp
  80725c:	48 89 e5             	mov    %rsp,%rbp
  80725f:	48 83 ec 20          	sub    $0x20,%rsp
  807263:	89 7d ec             	mov    %edi,-0x14(%rbp)
  807266:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  807269:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80726c:	89 c7                	mov    %eax,%edi
  80726e:	48 b8 a8 70 80 00 00 	movabs $0x8070a8,%rax
  807275:	00 00 00 
  807278:	ff d0                	callq  *%rax
  80727a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80727d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807281:	79 05                	jns    807288 <shutdown+0x2d>
		return r;
  807283:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807286:	eb 16                	jmp    80729e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  807288:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80728b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80728e:	89 d6                	mov    %edx,%esi
  807290:	89 c7                	mov    %eax,%edi
  807292:	48 b8 cc 75 80 00 00 	movabs $0x8075cc,%rax
  807299:	00 00 00 
  80729c:	ff d0                	callq  *%rax
}
  80729e:	c9                   	leaveq 
  80729f:	c3                   	retq   

00000000008072a0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8072a0:	55                   	push   %rbp
  8072a1:	48 89 e5             	mov    %rsp,%rbp
  8072a4:	48 83 ec 10          	sub    $0x10,%rsp
  8072a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8072ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072b0:	48 89 c7             	mov    %rax,%rdi
  8072b3:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8072ba:	00 00 00 
  8072bd:	ff d0                	callq  *%rax
  8072bf:	83 f8 01             	cmp    $0x1,%eax
  8072c2:	75 17                	jne    8072db <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8072c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072c8:	8b 40 0c             	mov    0xc(%rax),%eax
  8072cb:	89 c7                	mov    %eax,%edi
  8072cd:	48 b8 0c 76 80 00 00 	movabs $0x80760c,%rax
  8072d4:	00 00 00 
  8072d7:	ff d0                	callq  *%rax
  8072d9:	eb 05                	jmp    8072e0 <devsock_close+0x40>
	else
		return 0;
  8072db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8072e0:	c9                   	leaveq 
  8072e1:	c3                   	retq   

00000000008072e2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8072e2:	55                   	push   %rbp
  8072e3:	48 89 e5             	mov    %rsp,%rbp
  8072e6:	48 83 ec 20          	sub    $0x20,%rsp
  8072ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8072ed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8072f1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8072f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8072f7:	89 c7                	mov    %eax,%edi
  8072f9:	48 b8 a8 70 80 00 00 	movabs $0x8070a8,%rax
  807300:	00 00 00 
  807303:	ff d0                	callq  *%rax
  807305:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807308:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80730c:	79 05                	jns    807313 <connect+0x31>
		return r;
  80730e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807311:	eb 1b                	jmp    80732e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  807313:	8b 55 e8             	mov    -0x18(%rbp),%edx
  807316:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80731a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80731d:	48 89 ce             	mov    %rcx,%rsi
  807320:	89 c7                	mov    %eax,%edi
  807322:	48 b8 39 76 80 00 00 	movabs $0x807639,%rax
  807329:	00 00 00 
  80732c:	ff d0                	callq  *%rax
}
  80732e:	c9                   	leaveq 
  80732f:	c3                   	retq   

0000000000807330 <listen>:

int
listen(int s, int backlog)
{
  807330:	55                   	push   %rbp
  807331:	48 89 e5             	mov    %rsp,%rbp
  807334:	48 83 ec 20          	sub    $0x20,%rsp
  807338:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80733b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80733e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807341:	89 c7                	mov    %eax,%edi
  807343:	48 b8 a8 70 80 00 00 	movabs $0x8070a8,%rax
  80734a:	00 00 00 
  80734d:	ff d0                	callq  *%rax
  80734f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807356:	79 05                	jns    80735d <listen+0x2d>
		return r;
  807358:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80735b:	eb 16                	jmp    807373 <listen+0x43>
	return nsipc_listen(r, backlog);
  80735d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  807360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807363:	89 d6                	mov    %edx,%esi
  807365:	89 c7                	mov    %eax,%edi
  807367:	48 b8 9d 76 80 00 00 	movabs $0x80769d,%rax
  80736e:	00 00 00 
  807371:	ff d0                	callq  *%rax
}
  807373:	c9                   	leaveq 
  807374:	c3                   	retq   

0000000000807375 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  807375:	55                   	push   %rbp
  807376:	48 89 e5             	mov    %rsp,%rbp
  807379:	48 83 ec 20          	sub    $0x20,%rsp
  80737d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  807381:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  807385:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  807389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80738d:	89 c2                	mov    %eax,%edx
  80738f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807393:	8b 40 0c             	mov    0xc(%rax),%eax
  807396:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80739a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80739f:	89 c7                	mov    %eax,%edi
  8073a1:	48 b8 dd 76 80 00 00 	movabs $0x8076dd,%rax
  8073a8:	00 00 00 
  8073ab:	ff d0                	callq  *%rax
}
  8073ad:	c9                   	leaveq 
  8073ae:	c3                   	retq   

00000000008073af <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8073af:	55                   	push   %rbp
  8073b0:	48 89 e5             	mov    %rsp,%rbp
  8073b3:	48 83 ec 20          	sub    $0x20,%rsp
  8073b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8073bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8073bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8073c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8073c7:	89 c2                	mov    %eax,%edx
  8073c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8073cd:	8b 40 0c             	mov    0xc(%rax),%eax
  8073d0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8073d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8073d9:	89 c7                	mov    %eax,%edi
  8073db:	48 b8 a9 77 80 00 00 	movabs $0x8077a9,%rax
  8073e2:	00 00 00 
  8073e5:	ff d0                	callq  *%rax
}
  8073e7:	c9                   	leaveq 
  8073e8:	c3                   	retq   

00000000008073e9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8073e9:	55                   	push   %rbp
  8073ea:	48 89 e5             	mov    %rsp,%rbp
  8073ed:	48 83 ec 10          	sub    $0x10,%rsp
  8073f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8073f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8073f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8073fd:	48 be 5b 95 80 00 00 	movabs $0x80955b,%rsi
  807404:	00 00 00 
  807407:	48 89 c7             	mov    %rax,%rdi
  80740a:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  807411:	00 00 00 
  807414:	ff d0                	callq  *%rax
	return 0;
  807416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80741b:	c9                   	leaveq 
  80741c:	c3                   	retq   

000000000080741d <socket>:

int
socket(int domain, int type, int protocol)
{
  80741d:	55                   	push   %rbp
  80741e:	48 89 e5             	mov    %rsp,%rbp
  807421:	48 83 ec 20          	sub    $0x20,%rsp
  807425:	89 7d ec             	mov    %edi,-0x14(%rbp)
  807428:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80742b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80742e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  807431:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  807434:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807437:	89 ce                	mov    %ecx,%esi
  807439:	89 c7                	mov    %eax,%edi
  80743b:	48 b8 61 78 80 00 00 	movabs $0x807861,%rax
  807442:	00 00 00 
  807445:	ff d0                	callq  *%rax
  807447:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80744a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80744e:	79 05                	jns    807455 <socket+0x38>
		return r;
  807450:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807453:	eb 11                	jmp    807466 <socket+0x49>
	return alloc_sockfd(r);
  807455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807458:	89 c7                	mov    %eax,%edi
  80745a:	48 b8 ff 70 80 00 00 	movabs $0x8070ff,%rax
  807461:	00 00 00 
  807464:	ff d0                	callq  *%rax
}
  807466:	c9                   	leaveq 
  807467:	c3                   	retq   

0000000000807468 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  807468:	55                   	push   %rbp
  807469:	48 89 e5             	mov    %rsp,%rbp
  80746c:	48 83 ec 10          	sub    $0x10,%rsp
  807470:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  807473:	48 b8 5c 40 81 00 00 	movabs $0x81405c,%rax
  80747a:	00 00 00 
  80747d:	8b 00                	mov    (%rax),%eax
  80747f:	85 c0                	test   %eax,%eax
  807481:	75 1d                	jne    8074a0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  807483:	bf 02 00 00 00       	mov    $0x2,%edi
  807488:	48 b8 8f 62 80 00 00 	movabs $0x80628f,%rax
  80748f:	00 00 00 
  807492:	ff d0                	callq  *%rax
  807494:	48 ba 5c 40 81 00 00 	movabs $0x81405c,%rdx
  80749b:	00 00 00 
  80749e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8074a0:	48 b8 5c 40 81 00 00 	movabs $0x81405c,%rax
  8074a7:	00 00 00 
  8074aa:	8b 00                	mov    (%rax),%eax
  8074ac:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8074af:	b9 07 00 00 00       	mov    $0x7,%ecx
  8074b4:	48 ba 00 70 81 00 00 	movabs $0x817000,%rdx
  8074bb:	00 00 00 
  8074be:	89 c7                	mov    %eax,%edi
  8074c0:	48 b8 cc 61 80 00 00 	movabs $0x8061cc,%rax
  8074c7:	00 00 00 
  8074ca:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8074cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8074d1:	be 00 00 00 00       	mov    $0x0,%esi
  8074d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8074db:	48 b8 0c 61 80 00 00 	movabs $0x80610c,%rax
  8074e2:	00 00 00 
  8074e5:	ff d0                	callq  *%rax
}
  8074e7:	c9                   	leaveq 
  8074e8:	c3                   	retq   

00000000008074e9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8074e9:	55                   	push   %rbp
  8074ea:	48 89 e5             	mov    %rsp,%rbp
  8074ed:	48 83 ec 30          	sub    $0x30,%rsp
  8074f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8074f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8074f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8074fc:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807503:	00 00 00 
  807506:	8b 55 ec             	mov    -0x14(%rbp),%edx
  807509:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80750b:	bf 01 00 00 00       	mov    $0x1,%edi
  807510:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  807517:	00 00 00 
  80751a:	ff d0                	callq  *%rax
  80751c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80751f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807523:	78 3e                	js     807563 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  807525:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80752c:	00 00 00 
  80752f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  807533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807537:	8b 40 10             	mov    0x10(%rax),%eax
  80753a:	89 c2                	mov    %eax,%edx
  80753c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  807540:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807544:	48 89 ce             	mov    %rcx,%rsi
  807547:	48 89 c7             	mov    %rax,%rdi
  80754a:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  807551:	00 00 00 
  807554:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  807556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80755a:	8b 50 10             	mov    0x10(%rax),%edx
  80755d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807561:	89 10                	mov    %edx,(%rax)
	}
	return r;
  807563:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  807566:	c9                   	leaveq 
  807567:	c3                   	retq   

0000000000807568 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  807568:	55                   	push   %rbp
  807569:	48 89 e5             	mov    %rsp,%rbp
  80756c:	48 83 ec 10          	sub    $0x10,%rsp
  807570:	89 7d fc             	mov    %edi,-0x4(%rbp)
  807573:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  807577:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80757a:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807581:	00 00 00 
  807584:	8b 55 fc             	mov    -0x4(%rbp),%edx
  807587:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  807589:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80758c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807590:	48 89 c6             	mov    %rax,%rsi
  807593:	48 bf 04 70 81 00 00 	movabs $0x817004,%rdi
  80759a:	00 00 00 
  80759d:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8075a4:	00 00 00 
  8075a7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8075a9:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8075b0:	00 00 00 
  8075b3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8075b6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8075b9:	bf 02 00 00 00       	mov    $0x2,%edi
  8075be:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  8075c5:	00 00 00 
  8075c8:	ff d0                	callq  *%rax
}
  8075ca:	c9                   	leaveq 
  8075cb:	c3                   	retq   

00000000008075cc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8075cc:	55                   	push   %rbp
  8075cd:	48 89 e5             	mov    %rsp,%rbp
  8075d0:	48 83 ec 10          	sub    $0x10,%rsp
  8075d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8075d7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8075da:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8075e1:	00 00 00 
  8075e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8075e7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8075e9:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8075f0:	00 00 00 
  8075f3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8075f6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8075f9:	bf 03 00 00 00       	mov    $0x3,%edi
  8075fe:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  807605:	00 00 00 
  807608:	ff d0                	callq  *%rax
}
  80760a:	c9                   	leaveq 
  80760b:	c3                   	retq   

000000000080760c <nsipc_close>:

int
nsipc_close(int s)
{
  80760c:	55                   	push   %rbp
  80760d:	48 89 e5             	mov    %rsp,%rbp
  807610:	48 83 ec 10          	sub    $0x10,%rsp
  807614:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  807617:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80761e:	00 00 00 
  807621:	8b 55 fc             	mov    -0x4(%rbp),%edx
  807624:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  807626:	bf 04 00 00 00       	mov    $0x4,%edi
  80762b:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  807632:	00 00 00 
  807635:	ff d0                	callq  *%rax
}
  807637:	c9                   	leaveq 
  807638:	c3                   	retq   

0000000000807639 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  807639:	55                   	push   %rbp
  80763a:	48 89 e5             	mov    %rsp,%rbp
  80763d:	48 83 ec 10          	sub    $0x10,%rsp
  807641:	89 7d fc             	mov    %edi,-0x4(%rbp)
  807644:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  807648:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80764b:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807652:	00 00 00 
  807655:	8b 55 fc             	mov    -0x4(%rbp),%edx
  807658:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80765a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80765d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807661:	48 89 c6             	mov    %rax,%rsi
  807664:	48 bf 04 70 81 00 00 	movabs $0x817004,%rdi
  80766b:	00 00 00 
  80766e:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  807675:	00 00 00 
  807678:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80767a:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807681:	00 00 00 
  807684:	8b 55 f8             	mov    -0x8(%rbp),%edx
  807687:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80768a:	bf 05 00 00 00       	mov    $0x5,%edi
  80768f:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  807696:	00 00 00 
  807699:	ff d0                	callq  *%rax
}
  80769b:	c9                   	leaveq 
  80769c:	c3                   	retq   

000000000080769d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80769d:	55                   	push   %rbp
  80769e:	48 89 e5             	mov    %rsp,%rbp
  8076a1:	48 83 ec 10          	sub    $0x10,%rsp
  8076a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8076a8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8076ab:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8076b2:	00 00 00 
  8076b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8076b8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8076ba:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8076c1:	00 00 00 
  8076c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8076c7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8076ca:	bf 06 00 00 00       	mov    $0x6,%edi
  8076cf:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  8076d6:	00 00 00 
  8076d9:	ff d0                	callq  *%rax
}
  8076db:	c9                   	leaveq 
  8076dc:	c3                   	retq   

00000000008076dd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8076dd:	55                   	push   %rbp
  8076de:	48 89 e5             	mov    %rsp,%rbp
  8076e1:	48 83 ec 30          	sub    $0x30,%rsp
  8076e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8076e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8076ec:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8076ef:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8076f2:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8076f9:	00 00 00 
  8076fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8076ff:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  807701:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807708:	00 00 00 
  80770b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80770e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  807711:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807718:	00 00 00 
  80771b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80771e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  807721:	bf 07 00 00 00       	mov    $0x7,%edi
  807726:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  80772d:	00 00 00 
  807730:	ff d0                	callq  *%rax
  807732:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807735:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807739:	78 69                	js     8077a4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80773b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  807742:	7f 08                	jg     80774c <nsipc_recv+0x6f>
  807744:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807747:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80774a:	7e 35                	jle    807781 <nsipc_recv+0xa4>
  80774c:	48 b9 62 95 80 00 00 	movabs $0x809562,%rcx
  807753:	00 00 00 
  807756:	48 ba 77 95 80 00 00 	movabs $0x809577,%rdx
  80775d:	00 00 00 
  807760:	be 61 00 00 00       	mov    $0x61,%esi
  807765:	48 bf 8c 95 80 00 00 	movabs $0x80958c,%rdi
  80776c:	00 00 00 
  80776f:	b8 00 00 00 00       	mov    $0x0,%eax
  807774:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  80777b:	00 00 00 
  80777e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  807781:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807784:	48 63 d0             	movslq %eax,%rdx
  807787:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80778b:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  807792:	00 00 00 
  807795:	48 89 c7             	mov    %rax,%rdi
  807798:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  80779f:	00 00 00 
  8077a2:	ff d0                	callq  *%rax
	}

	return r;
  8077a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8077a7:	c9                   	leaveq 
  8077a8:	c3                   	retq   

00000000008077a9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8077a9:	55                   	push   %rbp
  8077aa:	48 89 e5             	mov    %rsp,%rbp
  8077ad:	48 83 ec 20          	sub    $0x20,%rsp
  8077b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8077b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8077b8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8077bb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8077be:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8077c5:	00 00 00 
  8077c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8077cb:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8077cd:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8077d4:	7e 35                	jle    80780b <nsipc_send+0x62>
  8077d6:	48 b9 98 95 80 00 00 	movabs $0x809598,%rcx
  8077dd:	00 00 00 
  8077e0:	48 ba 77 95 80 00 00 	movabs $0x809577,%rdx
  8077e7:	00 00 00 
  8077ea:	be 6c 00 00 00       	mov    $0x6c,%esi
  8077ef:	48 bf 8c 95 80 00 00 	movabs $0x80958c,%rdi
  8077f6:	00 00 00 
  8077f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8077fe:	49 b8 4c 45 80 00 00 	movabs $0x80454c,%r8
  807805:	00 00 00 
  807808:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80780b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80780e:	48 63 d0             	movslq %eax,%rdx
  807811:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807815:	48 89 c6             	mov    %rax,%rsi
  807818:	48 bf 0c 70 81 00 00 	movabs $0x81700c,%rdi
  80781f:	00 00 00 
  807822:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  807829:	00 00 00 
  80782c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80782e:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807835:	00 00 00 
  807838:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80783b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80783e:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807845:	00 00 00 
  807848:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80784b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80784e:	bf 08 00 00 00       	mov    $0x8,%edi
  807853:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  80785a:	00 00 00 
  80785d:	ff d0                	callq  *%rax
}
  80785f:	c9                   	leaveq 
  807860:	c3                   	retq   

0000000000807861 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  807861:	55                   	push   %rbp
  807862:	48 89 e5             	mov    %rsp,%rbp
  807865:	48 83 ec 10          	sub    $0x10,%rsp
  807869:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80786c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80786f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  807872:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807879:	00 00 00 
  80787c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80787f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  807881:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807888:	00 00 00 
  80788b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80788e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  807891:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  807898:	00 00 00 
  80789b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80789e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8078a1:	bf 09 00 00 00       	mov    $0x9,%edi
  8078a6:	48 b8 68 74 80 00 00 	movabs $0x807468,%rax
  8078ad:	00 00 00 
  8078b0:	ff d0                	callq  *%rax
}
  8078b2:	c9                   	leaveq 
  8078b3:	c3                   	retq   

00000000008078b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8078b4:	55                   	push   %rbp
  8078b5:	48 89 e5             	mov    %rsp,%rbp
  8078b8:	53                   	push   %rbx
  8078b9:	48 83 ec 38          	sub    $0x38,%rsp
  8078bd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8078c1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8078c5:	48 89 c7             	mov    %rax,%rdi
  8078c8:	48 b8 62 63 80 00 00 	movabs $0x806362,%rax
  8078cf:	00 00 00 
  8078d2:	ff d0                	callq  *%rax
  8078d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8078d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8078db:	0f 88 bf 01 00 00    	js     807aa0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8078e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8078e5:	ba 07 04 00 00       	mov    $0x407,%edx
  8078ea:	48 89 c6             	mov    %rax,%rsi
  8078ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8078f2:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  8078f9:	00 00 00 
  8078fc:	ff d0                	callq  *%rax
  8078fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  807901:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  807905:	0f 88 95 01 00 00    	js     807aa0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80790b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80790f:	48 89 c7             	mov    %rax,%rdi
  807912:	48 b8 62 63 80 00 00 	movabs $0x806362,%rax
  807919:	00 00 00 
  80791c:	ff d0                	callq  *%rax
  80791e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  807921:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  807925:	0f 88 5d 01 00 00    	js     807a88 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80792b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80792f:	ba 07 04 00 00       	mov    $0x407,%edx
  807934:	48 89 c6             	mov    %rax,%rsi
  807937:	bf 00 00 00 00       	mov    $0x0,%edi
  80793c:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  807943:	00 00 00 
  807946:	ff d0                	callq  *%rax
  807948:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80794b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80794f:	0f 88 33 01 00 00    	js     807a88 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  807955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807959:	48 89 c7             	mov    %rax,%rdi
  80795c:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807963:	00 00 00 
  807966:	ff d0                	callq  *%rax
  807968:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80796c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807970:	ba 07 04 00 00       	mov    $0x407,%edx
  807975:	48 89 c6             	mov    %rax,%rsi
  807978:	bf 00 00 00 00       	mov    $0x0,%edi
  80797d:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  807984:	00 00 00 
  807987:	ff d0                	callq  *%rax
  807989:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80798c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  807990:	0f 88 d9 00 00 00    	js     807a6f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  807996:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80799a:	48 89 c7             	mov    %rax,%rdi
  80799d:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  8079a4:	00 00 00 
  8079a7:	ff d0                	callq  *%rax
  8079a9:	48 89 c2             	mov    %rax,%rdx
  8079ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8079b0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8079b6:	48 89 d1             	mov    %rdx,%rcx
  8079b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8079be:	48 89 c6             	mov    %rax,%rsi
  8079c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8079c6:	48 b8 cc 5c 80 00 00 	movabs $0x805ccc,%rax
  8079cd:	00 00 00 
  8079d0:	ff d0                	callq  *%rax
  8079d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8079d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8079d9:	78 79                	js     807a54 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8079db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8079df:	48 ba 60 31 81 00 00 	movabs $0x813160,%rdx
  8079e6:	00 00 00 
  8079e9:	8b 12                	mov    (%rdx),%edx
  8079eb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8079ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8079f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8079f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8079fc:	48 ba 60 31 81 00 00 	movabs $0x813160,%rdx
  807a03:	00 00 00 
  807a06:	8b 12                	mov    (%rdx),%edx
  807a08:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  807a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807a0e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  807a15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807a19:	48 89 c7             	mov    %rax,%rdi
  807a1c:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  807a23:	00 00 00 
  807a26:	ff d0                	callq  *%rax
  807a28:	89 c2                	mov    %eax,%edx
  807a2a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  807a2e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  807a30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  807a34:	48 8d 58 04          	lea    0x4(%rax),%rbx
  807a38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807a3c:	48 89 c7             	mov    %rax,%rdi
  807a3f:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  807a46:	00 00 00 
  807a49:	ff d0                	callq  *%rax
  807a4b:	89 03                	mov    %eax,(%rbx)
	return 0;
  807a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  807a52:	eb 4f                	jmp    807aa3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  807a54:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  807a55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807a59:	48 89 c6             	mov    %rax,%rsi
  807a5c:	bf 00 00 00 00       	mov    $0x0,%edi
  807a61:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  807a68:	00 00 00 
  807a6b:	ff d0                	callq  *%rax
  807a6d:	eb 01                	jmp    807a70 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  807a6f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  807a70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807a74:	48 89 c6             	mov    %rax,%rsi
  807a77:	bf 00 00 00 00       	mov    $0x0,%edi
  807a7c:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  807a83:	00 00 00 
  807a86:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  807a88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807a8c:	48 89 c6             	mov    %rax,%rsi
  807a8f:	bf 00 00 00 00       	mov    $0x0,%edi
  807a94:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  807a9b:	00 00 00 
  807a9e:	ff d0                	callq  *%rax
    err:
	return r;
  807aa0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  807aa3:	48 83 c4 38          	add    $0x38,%rsp
  807aa7:	5b                   	pop    %rbx
  807aa8:	5d                   	pop    %rbp
  807aa9:	c3                   	retq   

0000000000807aaa <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  807aaa:	55                   	push   %rbp
  807aab:	48 89 e5             	mov    %rsp,%rbp
  807aae:	53                   	push   %rbx
  807aaf:	48 83 ec 28          	sub    $0x28,%rsp
  807ab3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  807ab7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  807abb:	eb 01                	jmp    807abe <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  807abd:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  807abe:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  807ac5:	00 00 00 
  807ac8:	48 8b 00             	mov    (%rax),%rax
  807acb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  807ad1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  807ad4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807ad8:	48 89 c7             	mov    %rax,%rdi
  807adb:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  807ae2:	00 00 00 
  807ae5:	ff d0                	callq  *%rax
  807ae7:	89 c3                	mov    %eax,%ebx
  807ae9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807aed:	48 89 c7             	mov    %rax,%rdi
  807af0:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  807af7:	00 00 00 
  807afa:	ff d0                	callq  *%rax
  807afc:	39 c3                	cmp    %eax,%ebx
  807afe:	0f 94 c0             	sete   %al
  807b01:	0f b6 c0             	movzbl %al,%eax
  807b04:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  807b07:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  807b0e:	00 00 00 
  807b11:	48 8b 00             	mov    (%rax),%rax
  807b14:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  807b1a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  807b1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807b20:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  807b23:	75 0a                	jne    807b2f <_pipeisclosed+0x85>
			return ret;
  807b25:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  807b28:	48 83 c4 28          	add    $0x28,%rsp
  807b2c:	5b                   	pop    %rbx
  807b2d:	5d                   	pop    %rbp
  807b2e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  807b2f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807b32:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  807b35:	74 86                	je     807abd <_pipeisclosed+0x13>
  807b37:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  807b3b:	75 80                	jne    807abd <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  807b3d:	48 b8 80 40 81 00 00 	movabs $0x814080,%rax
  807b44:	00 00 00 
  807b47:	48 8b 00             	mov    (%rax),%rax
  807b4a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  807b50:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  807b53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807b56:	89 c6                	mov    %eax,%esi
  807b58:	48 bf a9 95 80 00 00 	movabs $0x8095a9,%rdi
  807b5f:	00 00 00 
  807b62:	b8 00 00 00 00       	mov    $0x0,%eax
  807b67:	49 b8 87 47 80 00 00 	movabs $0x804787,%r8
  807b6e:	00 00 00 
  807b71:	41 ff d0             	callq  *%r8
	}
  807b74:	e9 44 ff ff ff       	jmpq   807abd <_pipeisclosed+0x13>

0000000000807b79 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  807b79:	55                   	push   %rbp
  807b7a:	48 89 e5             	mov    %rsp,%rbp
  807b7d:	48 83 ec 30          	sub    $0x30,%rsp
  807b81:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  807b84:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  807b88:	8b 45 dc             	mov    -0x24(%rbp),%eax
  807b8b:	48 89 d6             	mov    %rdx,%rsi
  807b8e:	89 c7                	mov    %eax,%edi
  807b90:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  807b97:	00 00 00 
  807b9a:	ff d0                	callq  *%rax
  807b9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807b9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807ba3:	79 05                	jns    807baa <pipeisclosed+0x31>
		return r;
  807ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807ba8:	eb 31                	jmp    807bdb <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  807baa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807bae:	48 89 c7             	mov    %rax,%rdi
  807bb1:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807bb8:	00 00 00 
  807bbb:	ff d0                	callq  *%rax
  807bbd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  807bc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807bc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807bc9:	48 89 d6             	mov    %rdx,%rsi
  807bcc:	48 89 c7             	mov    %rax,%rdi
  807bcf:	48 b8 aa 7a 80 00 00 	movabs $0x807aaa,%rax
  807bd6:	00 00 00 
  807bd9:	ff d0                	callq  *%rax
}
  807bdb:	c9                   	leaveq 
  807bdc:	c3                   	retq   

0000000000807bdd <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  807bdd:	55                   	push   %rbp
  807bde:	48 89 e5             	mov    %rsp,%rbp
  807be1:	48 83 ec 40          	sub    $0x40,%rsp
  807be5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  807be9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  807bed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  807bf1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807bf5:	48 89 c7             	mov    %rax,%rdi
  807bf8:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807bff:	00 00 00 
  807c02:	ff d0                	callq  *%rax
  807c04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  807c08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807c0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  807c10:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  807c17:	00 
  807c18:	e9 97 00 00 00       	jmpq   807cb4 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  807c1d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  807c22:	74 09                	je     807c2d <devpipe_read+0x50>
				return i;
  807c24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807c28:	e9 95 00 00 00       	jmpq   807cc2 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  807c2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807c31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807c35:	48 89 d6             	mov    %rdx,%rsi
  807c38:	48 89 c7             	mov    %rax,%rdi
  807c3b:	48 b8 aa 7a 80 00 00 	movabs $0x807aaa,%rax
  807c42:	00 00 00 
  807c45:	ff d0                	callq  *%rax
  807c47:	85 c0                	test   %eax,%eax
  807c49:	74 07                	je     807c52 <devpipe_read+0x75>
				return 0;
  807c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  807c50:	eb 70                	jmp    807cc2 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  807c52:	48 b8 3e 5c 80 00 00 	movabs $0x805c3e,%rax
  807c59:	00 00 00 
  807c5c:	ff d0                	callq  *%rax
  807c5e:	eb 01                	jmp    807c61 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  807c60:	90                   	nop
  807c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807c65:	8b 10                	mov    (%rax),%edx
  807c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807c6b:	8b 40 04             	mov    0x4(%rax),%eax
  807c6e:	39 c2                	cmp    %eax,%edx
  807c70:	74 ab                	je     807c1d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  807c72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807c76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  807c7a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  807c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807c82:	8b 00                	mov    (%rax),%eax
  807c84:	89 c2                	mov    %eax,%edx
  807c86:	c1 fa 1f             	sar    $0x1f,%edx
  807c89:	c1 ea 1b             	shr    $0x1b,%edx
  807c8c:	01 d0                	add    %edx,%eax
  807c8e:	83 e0 1f             	and    $0x1f,%eax
  807c91:	29 d0                	sub    %edx,%eax
  807c93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807c97:	48 98                	cltq   
  807c99:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  807c9e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  807ca0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807ca4:	8b 00                	mov    (%rax),%eax
  807ca6:	8d 50 01             	lea    0x1(%rax),%edx
  807ca9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807cad:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  807caf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  807cb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807cb8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  807cbc:	72 a2                	jb     807c60 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  807cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  807cc2:	c9                   	leaveq 
  807cc3:	c3                   	retq   

0000000000807cc4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  807cc4:	55                   	push   %rbp
  807cc5:	48 89 e5             	mov    %rsp,%rbp
  807cc8:	48 83 ec 40          	sub    $0x40,%rsp
  807ccc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  807cd0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  807cd4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  807cd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807cdc:	48 89 c7             	mov    %rax,%rdi
  807cdf:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807ce6:	00 00 00 
  807ce9:	ff d0                	callq  *%rax
  807ceb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  807cef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  807cf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  807cf7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  807cfe:	00 
  807cff:	e9 93 00 00 00       	jmpq   807d97 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  807d04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807d08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  807d0c:	48 89 d6             	mov    %rdx,%rsi
  807d0f:	48 89 c7             	mov    %rax,%rdi
  807d12:	48 b8 aa 7a 80 00 00 	movabs $0x807aaa,%rax
  807d19:	00 00 00 
  807d1c:	ff d0                	callq  *%rax
  807d1e:	85 c0                	test   %eax,%eax
  807d20:	74 07                	je     807d29 <devpipe_write+0x65>
				return 0;
  807d22:	b8 00 00 00 00       	mov    $0x0,%eax
  807d27:	eb 7c                	jmp    807da5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  807d29:	48 b8 3e 5c 80 00 00 	movabs $0x805c3e,%rax
  807d30:	00 00 00 
  807d33:	ff d0                	callq  *%rax
  807d35:	eb 01                	jmp    807d38 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  807d37:	90                   	nop
  807d38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807d3c:	8b 40 04             	mov    0x4(%rax),%eax
  807d3f:	48 63 d0             	movslq %eax,%rdx
  807d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807d46:	8b 00                	mov    (%rax),%eax
  807d48:	48 98                	cltq   
  807d4a:	48 83 c0 20          	add    $0x20,%rax
  807d4e:	48 39 c2             	cmp    %rax,%rdx
  807d51:	73 b1                	jae    807d04 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  807d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807d57:	8b 40 04             	mov    0x4(%rax),%eax
  807d5a:	89 c2                	mov    %eax,%edx
  807d5c:	c1 fa 1f             	sar    $0x1f,%edx
  807d5f:	c1 ea 1b             	shr    $0x1b,%edx
  807d62:	01 d0                	add    %edx,%eax
  807d64:	83 e0 1f             	and    $0x1f,%eax
  807d67:	29 d0                	sub    %edx,%eax
  807d69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  807d6d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  807d71:	48 01 ca             	add    %rcx,%rdx
  807d74:	0f b6 0a             	movzbl (%rdx),%ecx
  807d77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807d7b:	48 98                	cltq   
  807d7d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  807d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807d85:	8b 40 04             	mov    0x4(%rax),%eax
  807d88:	8d 50 01             	lea    0x1(%rax),%edx
  807d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807d8f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  807d92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  807d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807d9b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  807d9f:	72 96                	jb     807d37 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  807da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  807da5:	c9                   	leaveq 
  807da6:	c3                   	retq   

0000000000807da7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  807da7:	55                   	push   %rbp
  807da8:	48 89 e5             	mov    %rsp,%rbp
  807dab:	48 83 ec 20          	sub    $0x20,%rsp
  807daf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  807db3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  807db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807dbb:	48 89 c7             	mov    %rax,%rdi
  807dbe:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807dc5:	00 00 00 
  807dc8:	ff d0                	callq  *%rax
  807dca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  807dce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807dd2:	48 be bc 95 80 00 00 	movabs $0x8095bc,%rsi
  807dd9:	00 00 00 
  807ddc:	48 89 c7             	mov    %rax,%rdi
  807ddf:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  807de6:	00 00 00 
  807de9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  807deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807def:	8b 50 04             	mov    0x4(%rax),%edx
  807df2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807df6:	8b 00                	mov    (%rax),%eax
  807df8:	29 c2                	sub    %eax,%edx
  807dfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807dfe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  807e04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807e08:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  807e0f:	00 00 00 
	stat->st_dev = &devpipe;
  807e12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807e16:	48 ba 60 31 81 00 00 	movabs $0x813160,%rdx
  807e1d:	00 00 00 
  807e20:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  807e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807e2c:	c9                   	leaveq 
  807e2d:	c3                   	retq   

0000000000807e2e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  807e2e:	55                   	push   %rbp
  807e2f:	48 89 e5             	mov    %rsp,%rbp
  807e32:	48 83 ec 10          	sub    $0x10,%rsp
  807e36:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  807e3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807e3e:	48 89 c6             	mov    %rax,%rsi
  807e41:	bf 00 00 00 00       	mov    $0x0,%edi
  807e46:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  807e4d:	00 00 00 
  807e50:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  807e52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807e56:	48 89 c7             	mov    %rax,%rdi
  807e59:	48 b8 37 63 80 00 00 	movabs $0x806337,%rax
  807e60:	00 00 00 
  807e63:	ff d0                	callq  *%rax
  807e65:	48 89 c6             	mov    %rax,%rsi
  807e68:	bf 00 00 00 00       	mov    $0x0,%edi
  807e6d:	48 b8 27 5d 80 00 00 	movabs $0x805d27,%rax
  807e74:	00 00 00 
  807e77:	ff d0                	callq  *%rax
}
  807e79:	c9                   	leaveq 
  807e7a:	c3                   	retq   
	...

0000000000807e7c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  807e7c:	55                   	push   %rbp
  807e7d:	48 89 e5             	mov    %rsp,%rbp
  807e80:	48 83 ec 20          	sub    $0x20,%rsp
  807e84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  807e87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807e8a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  807e8d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  807e91:	be 01 00 00 00       	mov    $0x1,%esi
  807e96:	48 89 c7             	mov    %rax,%rdi
  807e99:	48 b8 34 5b 80 00 00 	movabs $0x805b34,%rax
  807ea0:	00 00 00 
  807ea3:	ff d0                	callq  *%rax
}
  807ea5:	c9                   	leaveq 
  807ea6:	c3                   	retq   

0000000000807ea7 <getchar>:

int
getchar(void)
{
  807ea7:	55                   	push   %rbp
  807ea8:	48 89 e5             	mov    %rsp,%rbp
  807eab:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  807eaf:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  807eb3:	ba 01 00 00 00       	mov    $0x1,%edx
  807eb8:	48 89 c6             	mov    %rax,%rsi
  807ebb:	bf 00 00 00 00       	mov    $0x0,%edi
  807ec0:	48 b8 2c 68 80 00 00 	movabs $0x80682c,%rax
  807ec7:	00 00 00 
  807eca:	ff d0                	callq  *%rax
  807ecc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  807ecf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807ed3:	79 05                	jns    807eda <getchar+0x33>
		return r;
  807ed5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807ed8:	eb 14                	jmp    807eee <getchar+0x47>
	if (r < 1)
  807eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807ede:	7f 07                	jg     807ee7 <getchar+0x40>
		return -E_EOF;
  807ee0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  807ee5:	eb 07                	jmp    807eee <getchar+0x47>
	return c;
  807ee7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  807eeb:	0f b6 c0             	movzbl %al,%eax
}
  807eee:	c9                   	leaveq 
  807eef:	c3                   	retq   

0000000000807ef0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  807ef0:	55                   	push   %rbp
  807ef1:	48 89 e5             	mov    %rsp,%rbp
  807ef4:	48 83 ec 20          	sub    $0x20,%rsp
  807ef8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  807efb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  807eff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807f02:	48 89 d6             	mov    %rdx,%rsi
  807f05:	89 c7                	mov    %eax,%edi
  807f07:	48 b8 fa 63 80 00 00 	movabs $0x8063fa,%rax
  807f0e:	00 00 00 
  807f11:	ff d0                	callq  *%rax
  807f13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807f16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807f1a:	79 05                	jns    807f21 <iscons+0x31>
		return r;
  807f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807f1f:	eb 1a                	jmp    807f3b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  807f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807f25:	8b 10                	mov    (%rax),%edx
  807f27:	48 b8 a0 31 81 00 00 	movabs $0x8131a0,%rax
  807f2e:	00 00 00 
  807f31:	8b 00                	mov    (%rax),%eax
  807f33:	39 c2                	cmp    %eax,%edx
  807f35:	0f 94 c0             	sete   %al
  807f38:	0f b6 c0             	movzbl %al,%eax
}
  807f3b:	c9                   	leaveq 
  807f3c:	c3                   	retq   

0000000000807f3d <opencons>:

int
opencons(void)
{
  807f3d:	55                   	push   %rbp
  807f3e:	48 89 e5             	mov    %rsp,%rbp
  807f41:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  807f45:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  807f49:	48 89 c7             	mov    %rax,%rdi
  807f4c:	48 b8 62 63 80 00 00 	movabs $0x806362,%rax
  807f53:	00 00 00 
  807f56:	ff d0                	callq  *%rax
  807f58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807f5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807f5f:	79 05                	jns    807f66 <opencons+0x29>
		return r;
  807f61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807f64:	eb 5b                	jmp    807fc1 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  807f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807f6a:	ba 07 04 00 00       	mov    $0x407,%edx
  807f6f:	48 89 c6             	mov    %rax,%rsi
  807f72:	bf 00 00 00 00       	mov    $0x0,%edi
  807f77:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  807f7e:	00 00 00 
  807f81:	ff d0                	callq  *%rax
  807f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807f8a:	79 05                	jns    807f91 <opencons+0x54>
		return r;
  807f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807f8f:	eb 30                	jmp    807fc1 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  807f91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807f95:	48 ba a0 31 81 00 00 	movabs $0x8131a0,%rdx
  807f9c:	00 00 00 
  807f9f:	8b 12                	mov    (%rdx),%edx
  807fa1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  807fa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807fa7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  807fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807fb2:	48 89 c7             	mov    %rax,%rdi
  807fb5:	48 b8 14 63 80 00 00 	movabs $0x806314,%rax
  807fbc:	00 00 00 
  807fbf:	ff d0                	callq  *%rax
}
  807fc1:	c9                   	leaveq 
  807fc2:	c3                   	retq   

0000000000807fc3 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  807fc3:	55                   	push   %rbp
  807fc4:	48 89 e5             	mov    %rsp,%rbp
  807fc7:	48 83 ec 30          	sub    $0x30,%rsp
  807fcb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  807fcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  807fd3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  807fd7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  807fdc:	75 13                	jne    807ff1 <devcons_read+0x2e>
		return 0;
  807fde:	b8 00 00 00 00       	mov    $0x0,%eax
  807fe3:	eb 49                	jmp    80802e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  807fe5:	48 b8 3e 5c 80 00 00 	movabs $0x805c3e,%rax
  807fec:	00 00 00 
  807fef:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  807ff1:	48 b8 7e 5b 80 00 00 	movabs $0x805b7e,%rax
  807ff8:	00 00 00 
  807ffb:	ff d0                	callq  *%rax
  807ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  808000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  808004:	74 df                	je     807fe5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  808006:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80800a:	79 05                	jns    808011 <devcons_read+0x4e>
		return c;
  80800c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80800f:	eb 1d                	jmp    80802e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  808011:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  808015:	75 07                	jne    80801e <devcons_read+0x5b>
		return 0;
  808017:	b8 00 00 00 00       	mov    $0x0,%eax
  80801c:	eb 10                	jmp    80802e <devcons_read+0x6b>
	*(char*)vbuf = c;
  80801e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  808021:	89 c2                	mov    %eax,%edx
  808023:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  808027:	88 10                	mov    %dl,(%rax)
	return 1;
  808029:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80802e:	c9                   	leaveq 
  80802f:	c3                   	retq   

0000000000808030 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  808030:	55                   	push   %rbp
  808031:	48 89 e5             	mov    %rsp,%rbp
  808034:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80803b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  808042:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  808049:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  808050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  808057:	eb 77                	jmp    8080d0 <devcons_write+0xa0>
		m = n - tot;
  808059:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  808060:	89 c2                	mov    %eax,%edx
  808062:	8b 45 fc             	mov    -0x4(%rbp),%eax
  808065:	89 d1                	mov    %edx,%ecx
  808067:	29 c1                	sub    %eax,%ecx
  808069:	89 c8                	mov    %ecx,%eax
  80806b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80806e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  808071:	83 f8 7f             	cmp    $0x7f,%eax
  808074:	76 07                	jbe    80807d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  808076:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80807d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  808080:	48 63 d0             	movslq %eax,%rdx
  808083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  808086:	48 98                	cltq   
  808088:	48 89 c1             	mov    %rax,%rcx
  80808b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  808092:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  808099:	48 89 ce             	mov    %rcx,%rsi
  80809c:	48 89 c7             	mov    %rax,%rdi
  80809f:	48 b8 66 56 80 00 00 	movabs $0x805666,%rax
  8080a6:	00 00 00 
  8080a9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8080ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8080ae:	48 63 d0             	movslq %eax,%rdx
  8080b1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8080b8:	48 89 d6             	mov    %rdx,%rsi
  8080bb:	48 89 c7             	mov    %rax,%rdi
  8080be:	48 b8 34 5b 80 00 00 	movabs $0x805b34,%rax
  8080c5:	00 00 00 
  8080c8:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8080ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8080cd:	01 45 fc             	add    %eax,-0x4(%rbp)
  8080d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8080d3:	48 98                	cltq   
  8080d5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8080dc:	0f 82 77 ff ff ff    	jb     808059 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8080e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8080e5:	c9                   	leaveq 
  8080e6:	c3                   	retq   

00000000008080e7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8080e7:	55                   	push   %rbp
  8080e8:	48 89 e5             	mov    %rsp,%rbp
  8080eb:	48 83 ec 08          	sub    $0x8,%rsp
  8080ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8080f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8080f8:	c9                   	leaveq 
  8080f9:	c3                   	retq   

00000000008080fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8080fa:	55                   	push   %rbp
  8080fb:	48 89 e5             	mov    %rsp,%rbp
  8080fe:	48 83 ec 10          	sub    $0x10,%rsp
  808102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  808106:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80810a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80810e:	48 be c8 95 80 00 00 	movabs $0x8095c8,%rsi
  808115:	00 00 00 
  808118:	48 89 c7             	mov    %rax,%rdi
  80811b:	48 b8 44 53 80 00 00 	movabs $0x805344,%rax
  808122:	00 00 00 
  808125:	ff d0                	callq  *%rax
	return 0;
  808127:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80812c:	c9                   	leaveq 
  80812d:	c3                   	retq   
