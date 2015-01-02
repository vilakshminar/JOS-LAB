
obj/user/testpteshare.debug:     file format elf64-x86-64


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
  80003c:	e8 6b 02 00 00       	callq  8002ac <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800053:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800057:	74 0c                	je     800065 <umain+0x21>
		childofspawn();
  800059:	48 b8 76 02 80 00 00 	movabs $0x800276,%rax
  800060:	00 00 00 
  800063:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800065:	ba 07 04 00 00       	mov    $0x407,%edx
  80006a:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
  800074:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  80007b:	00 00 00 
  80007e:	ff d0                	callq  *%rax
  800080:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800083:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800087:	79 30                	jns    8000b9 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008c:	89 c1                	mov    %eax,%ecx
  80008e:	48 ba fe 52 80 00 00 	movabs $0x8052fe,%rdx
  800095:	00 00 00 
  800098:	be 13 00 00 00       	mov    $0x13,%esi
  80009d:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8000a4:	00 00 00 
  8000a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ac:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  8000b3:	00 00 00 
  8000b6:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b9:	48 b8 7b 21 80 00 00 	movabs $0x80217b,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
  8000c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cc:	79 30                	jns    8000fe <umain+0xba>
		panic("fork: %e", r);
  8000ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d1:	89 c1                	mov    %eax,%ecx
  8000d3:	48 ba 25 53 80 00 00 	movabs $0x805325,%rdx
  8000da:	00 00 00 
  8000dd:	be 17 00 00 00       	mov    $0x17,%esi
  8000e2:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8000e9:	00 00 00 
  8000ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f1:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  8000f8:	00 00 00 
  8000fb:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800102:	75 2d                	jne    800131 <umain+0xed>
		strcpy(VA, msg);
  800104:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010b:	00 00 00 
  80010e:	48 8b 00             	mov    (%rax),%rax
  800111:	48 89 c6             	mov    %rax,%rsi
  800114:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800119:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
		exit();
  800125:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	callq  *%rax
	}
	wait(r);
  800131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800134:	89 c7                	mov    %eax,%edi
  800136:	48 b8 90 4b 80 00 00 	movabs $0x804b90,%rax
  80013d:	00 00 00 
  800140:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800142:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800149:	00 00 00 
  80014c:	48 8b 00             	mov    (%rax),%rax
  80014f:	48 89 c6             	mov    %rax,%rsi
  800152:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800157:	48 b8 c7 12 80 00 00 	movabs $0x8012c7,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	85 c0                	test   %eax,%eax
  800165:	75 0c                	jne    800173 <umain+0x12f>
  800167:	48 b8 2e 53 80 00 00 	movabs $0x80532e,%rax
  80016e:	00 00 00 
  800171:	eb 0a                	jmp    80017d <umain+0x139>
  800173:	48 b8 34 53 80 00 00 	movabs $0x805334,%rax
  80017a:	00 00 00 
  80017d:	48 89 c6             	mov    %rax,%rsi
  800180:	48 bf 3a 53 80 00 00 	movabs $0x80533a,%rdi
  800187:	00 00 00 
  80018a:	b8 00 00 00 00       	mov    $0x0,%eax
  80018f:	48 ba af 05 80 00 00 	movabs $0x8005af,%rdx
  800196:	00 00 00 
  800199:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a0:	48 ba 55 53 80 00 00 	movabs $0x805355,%rdx
  8001a7:	00 00 00 
  8001aa:	48 be 59 53 80 00 00 	movabs $0x805359,%rsi
  8001b1:	00 00 00 
  8001b4:	48 bf 66 53 80 00 00 	movabs $0x805366,%rdi
  8001bb:	00 00 00 
  8001be:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c3:	49 b8 1d 35 80 00 00 	movabs $0x80351d,%r8
  8001ca:	00 00 00 
  8001cd:	41 ff d0             	callq  *%r8
  8001d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d7:	79 30                	jns    800209 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dc:	89 c1                	mov    %eax,%ecx
  8001de:	48 ba 78 53 80 00 00 	movabs $0x805378,%rdx
  8001e5:	00 00 00 
  8001e8:	be 21 00 00 00       	mov    $0x21,%esi
  8001ed:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8001f4:	00 00 00 
  8001f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fc:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  800203:	00 00 00 
  800206:	41 ff d0             	callq  *%r8
	wait(r);
  800209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020c:	89 c7                	mov    %eax,%edi
  80020e:	48 b8 90 4b 80 00 00 	movabs $0x804b90,%rax
  800215:	00 00 00 
  800218:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80021a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800221:	00 00 00 
  800224:	48 8b 00             	mov    (%rax),%rax
  800227:	48 89 c6             	mov    %rax,%rsi
  80022a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022f:	48 b8 c7 12 80 00 00 	movabs $0x8012c7,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
  80023b:	85 c0                	test   %eax,%eax
  80023d:	75 0c                	jne    80024b <umain+0x207>
  80023f:	48 b8 2e 53 80 00 00 	movabs $0x80532e,%rax
  800246:	00 00 00 
  800249:	eb 0a                	jmp    800255 <umain+0x211>
  80024b:	48 b8 34 53 80 00 00 	movabs $0x805334,%rax
  800252:	00 00 00 
  800255:	48 89 c6             	mov    %rax,%rsi
  800258:	48 bf 82 53 80 00 00 	movabs $0x805382,%rdi
  80025f:	00 00 00 
  800262:	b8 00 00 00 00       	mov    $0x0,%eax
  800267:	48 ba af 05 80 00 00 	movabs $0x8005af,%rdx
  80026e:	00 00 00 
  800271:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800273:	cc                   	int3   

	breakpoint();
}
  800274:	c9                   	leaveq 
  800275:	c3                   	retq   

0000000000800276 <childofspawn>:

void
childofspawn(void)
{
  800276:	55                   	push   %rbp
  800277:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  80027a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800281:	00 00 00 
  800284:	48 8b 00             	mov    (%rax),%rax
  800287:	48 89 c6             	mov    %rax,%rsi
  80028a:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028f:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
	exit();
  80029b:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
}
  8002a7:	5d                   	pop    %rbp
  8002a8:	c3                   	retq   
  8002a9:	00 00                	add    %al,(%rax)
	...

00000000008002ac <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002ac:	55                   	push   %rbp
  8002ad:	48 89 e5             	mov    %rsp,%rbp
  8002b0:	48 83 ec 10          	sub    $0x10,%rsp
  8002b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002bb:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8002c2:	00 00 00 
  8002c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8002cc:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	48 98                	cltq   
  8002da:	48 89 c2             	mov    %rax,%rdx
  8002dd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8002e3:	48 89 d0             	mov    %rdx,%rax
  8002e6:	48 c1 e0 03          	shl    $0x3,%rax
  8002ea:	48 01 d0             	add    %rdx,%rax
  8002ed:	48 c1 e0 05          	shl    $0x5,%rax
  8002f1:	48 89 c2             	mov    %rax,%rdx
  8002f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002fb:	00 00 00 
  8002fe:	48 01 c2             	add    %rax,%rdx
  800301:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  800308:	00 00 00 
  80030b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800312:	7e 14                	jle    800328 <libmain+0x7c>
		binaryname = argv[0];
  800314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800318:	48 8b 10             	mov    (%rax),%rdx
  80031b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800322:	00 00 00 
  800325:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800328:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80032c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032f:	48 89 d6             	mov    %rdx,%rsi
  800332:	89 c7                	mov    %eax,%edi
  800334:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80033b:	00 00 00 
  80033e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800340:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800347:	00 00 00 
  80034a:	ff d0                	callq  *%rax
}
  80034c:	c9                   	leaveq 
  80034d:	c3                   	retq   
	...

0000000000800350 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800354:	48 b8 e9 27 80 00 00 	movabs $0x8027e9,%rax
  80035b:	00 00 00 
  80035e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800360:	bf 00 00 00 00       	mov    $0x0,%edi
  800365:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  80036c:	00 00 00 
  80036f:	ff d0                	callq  *%rax
}
  800371:	5d                   	pop    %rbp
  800372:	c3                   	retq   
	...

0000000000800374 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800374:	55                   	push   %rbp
  800375:	48 89 e5             	mov    %rsp,%rbp
  800378:	53                   	push   %rbx
  800379:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800380:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800387:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80038d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800394:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80039b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003a2:	84 c0                	test   %al,%al
  8003a4:	74 23                	je     8003c9 <_panic+0x55>
  8003a6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003ad:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003b1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003b5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003b9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003bd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003c1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003c5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003c9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003d0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003d7:	00 00 00 
  8003da:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003e1:	00 00 00 
  8003e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003e8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003ef:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003fd:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800404:	00 00 00 
  800407:	48 8b 18             	mov    (%rax),%rbx
  80040a:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  800411:	00 00 00 
  800414:	ff d0                	callq  *%rax
  800416:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80041c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800423:	41 89 c8             	mov    %ecx,%r8d
  800426:	48 89 d1             	mov    %rdx,%rcx
  800429:	48 89 da             	mov    %rbx,%rdx
  80042c:	89 c6                	mov    %eax,%esi
  80042e:	48 bf a8 53 80 00 00 	movabs $0x8053a8,%rdi
  800435:	00 00 00 
  800438:	b8 00 00 00 00       	mov    $0x0,%eax
  80043d:	49 b9 af 05 80 00 00 	movabs $0x8005af,%r9
  800444:	00 00 00 
  800447:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80044a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800451:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800458:	48 89 d6             	mov    %rdx,%rsi
  80045b:	48 89 c7             	mov    %rax,%rdi
  80045e:	48 b8 03 05 80 00 00 	movabs $0x800503,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
	cprintf("\n");
  80046a:	48 bf cb 53 80 00 00 	movabs $0x8053cb,%rdi
  800471:	00 00 00 
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
  800479:	48 ba af 05 80 00 00 	movabs $0x8005af,%rdx
  800480:	00 00 00 
  800483:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800485:	cc                   	int3   
  800486:	eb fd                	jmp    800485 <_panic+0x111>

0000000000800488 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 10          	sub    $0x10,%rsp
  800490:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800493:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80049b:	8b 00                	mov    (%rax),%eax
  80049d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004a0:	89 d6                	mov    %edx,%esi
  8004a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004a6:	48 63 d0             	movslq %eax,%rdx
  8004a9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8004ae:	8d 50 01             	lea    0x1(%rax),%edx
  8004b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b5:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8004b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004bb:	8b 00                	mov    (%rax),%eax
  8004bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c2:	75 2c                	jne    8004f0 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8004c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c8:	8b 00                	mov    (%rax),%eax
  8004ca:	48 98                	cltq   
  8004cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004d0:	48 83 c2 08          	add    $0x8,%rdx
  8004d4:	48 89 c6             	mov    %rax,%rsi
  8004d7:	48 89 d7             	mov    %rdx,%rdi
  8004da:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax
		b->idx = 0;
  8004e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8004f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004f4:	8b 40 04             	mov    0x4(%rax),%eax
  8004f7:	8d 50 01             	lea    0x1(%rax),%edx
  8004fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fe:	89 50 04             	mov    %edx,0x4(%rax)
}
  800501:	c9                   	leaveq 
  800502:	c3                   	retq   

0000000000800503 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800503:	55                   	push   %rbp
  800504:	48 89 e5             	mov    %rsp,%rbp
  800507:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80050e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800515:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80051c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800523:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80052a:	48 8b 0a             	mov    (%rdx),%rcx
  80052d:	48 89 08             	mov    %rcx,(%rax)
  800530:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800534:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800538:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80053c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800540:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800547:	00 00 00 
	b.cnt = 0;
  80054a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800551:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800554:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80055b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800562:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800569:	48 89 c6             	mov    %rax,%rsi
  80056c:	48 bf 88 04 80 00 00 	movabs $0x800488,%rdi
  800573:	00 00 00 
  800576:	48 b8 60 09 80 00 00 	movabs $0x800960,%rax
  80057d:	00 00 00 
  800580:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800582:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800588:	48 98                	cltq   
  80058a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800591:	48 83 c2 08          	add    $0x8,%rdx
  800595:	48 89 c6             	mov    %rax,%rsi
  800598:	48 89 d7             	mov    %rdx,%rdi
  80059b:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  8005a2:	00 00 00 
  8005a5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8005a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005ad:	c9                   	leaveq 
  8005ae:	c3                   	retq   

00000000008005af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005af:	55                   	push   %rbp
  8005b0:	48 89 e5             	mov    %rsp,%rbp
  8005b3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005ba:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005dd:	84 c0                	test   %al,%al
  8005df:	74 20                	je     800601 <cprintf+0x52>
  8005e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800601:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800608:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80060f:	00 00 00 
  800612:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800619:	00 00 00 
  80061c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800620:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800627:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80062e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800635:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80063c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800643:	48 8b 0a             	mov    (%rdx),%rcx
  800646:	48 89 08             	mov    %rcx,(%rax)
  800649:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80064d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800651:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800655:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800659:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800660:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800667:	48 89 d6             	mov    %rdx,%rsi
  80066a:	48 89 c7             	mov    %rax,%rdi
  80066d:	48 b8 03 05 80 00 00 	movabs $0x800503,%rax
  800674:	00 00 00 
  800677:	ff d0                	callq  *%rax
  800679:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80067f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800685:	c9                   	leaveq 
  800686:	c3                   	retq   
	...

0000000000800688 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800688:	55                   	push   %rbp
  800689:	48 89 e5             	mov    %rsp,%rbp
  80068c:	48 83 ec 30          	sub    $0x30,%rsp
  800690:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800694:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800698:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80069c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80069f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006a3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006aa:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006ae:	77 52                	ja     800702 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006b3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006b7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006ba:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8006cb:	48 89 c2             	mov    %rax,%rdx
  8006ce:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8006d1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006d4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	41 89 f9             	mov    %edi,%r9d
  8006df:	48 89 c7             	mov    %rax,%rdi
  8006e2:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  8006e9:	00 00 00 
  8006ec:	ff d0                	callq  *%rax
  8006ee:	eb 1c                	jmp    80070c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8006f7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006fb:	48 89 d6             	mov    %rdx,%rsi
  8006fe:	89 c7                	mov    %eax,%edi
  800700:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800702:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800706:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80070a:	7f e4                	jg     8006f0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	48 f7 f1             	div    %rcx
  80071b:	48 89 d0             	mov    %rdx,%rax
  80071e:	48 ba a8 55 80 00 00 	movabs $0x8055a8,%rdx
  800725:	00 00 00 
  800728:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80072c:	0f be c0             	movsbl %al,%eax
  80072f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800733:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800737:	48 89 d6             	mov    %rdx,%rsi
  80073a:	89 c7                	mov    %eax,%edi
  80073c:	ff d1                	callq  *%rcx
}
  80073e:	c9                   	leaveq 
  80073f:	c3                   	retq   

0000000000800740 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800740:	55                   	push   %rbp
  800741:	48 89 e5             	mov    %rsp,%rbp
  800744:	48 83 ec 20          	sub    $0x20,%rsp
  800748:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80074c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80074f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800753:	7e 52                	jle    8007a7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800759:	8b 00                	mov    (%rax),%eax
  80075b:	83 f8 30             	cmp    $0x30,%eax
  80075e:	73 24                	jae    800784 <getuint+0x44>
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800768:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076c:	8b 00                	mov    (%rax),%eax
  80076e:	89 c0                	mov    %eax,%eax
  800770:	48 01 d0             	add    %rdx,%rax
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	8b 12                	mov    (%rdx),%edx
  800779:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80077c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800780:	89 0a                	mov    %ecx,(%rdx)
  800782:	eb 17                	jmp    80079b <getuint+0x5b>
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80078c:	48 89 d0             	mov    %rdx,%rax
  80078f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800793:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800797:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079b:	48 8b 00             	mov    (%rax),%rax
  80079e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a2:	e9 a3 00 00 00       	jmpq   80084a <getuint+0x10a>
	else if (lflag)
  8007a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007ab:	74 4f                	je     8007fc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b1:	8b 00                	mov    (%rax),%eax
  8007b3:	83 f8 30             	cmp    $0x30,%eax
  8007b6:	73 24                	jae    8007dc <getuint+0x9c>
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	8b 00                	mov    (%rax),%eax
  8007c6:	89 c0                	mov    %eax,%eax
  8007c8:	48 01 d0             	add    %rdx,%rax
  8007cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cf:	8b 12                	mov    (%rdx),%edx
  8007d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d8:	89 0a                	mov    %ecx,(%rdx)
  8007da:	eb 17                	jmp    8007f3 <getuint+0xb3>
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e4:	48 89 d0             	mov    %rdx,%rax
  8007e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f3:	48 8b 00             	mov    (%rax),%rax
  8007f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fa:	eb 4e                	jmp    80084a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	8b 00                	mov    (%rax),%eax
  800802:	83 f8 30             	cmp    $0x30,%eax
  800805:	73 24                	jae    80082b <getuint+0xeb>
  800807:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800813:	8b 00                	mov    (%rax),%eax
  800815:	89 c0                	mov    %eax,%eax
  800817:	48 01 d0             	add    %rdx,%rax
  80081a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081e:	8b 12                	mov    (%rdx),%edx
  800820:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	89 0a                	mov    %ecx,(%rdx)
  800829:	eb 17                	jmp    800842 <getuint+0x102>
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800833:	48 89 d0             	mov    %rdx,%rax
  800836:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800842:	8b 00                	mov    (%rax),%eax
  800844:	89 c0                	mov    %eax,%eax
  800846:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80084e:	c9                   	leaveq 
  80084f:	c3                   	retq   

0000000000800850 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800850:	55                   	push   %rbp
  800851:	48 89 e5             	mov    %rsp,%rbp
  800854:	48 83 ec 20          	sub    $0x20,%rsp
  800858:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80085c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80085f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800863:	7e 52                	jle    8008b7 <getint+0x67>
		x=va_arg(*ap, long long);
  800865:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800869:	8b 00                	mov    (%rax),%eax
  80086b:	83 f8 30             	cmp    $0x30,%eax
  80086e:	73 24                	jae    800894 <getint+0x44>
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800878:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087c:	8b 00                	mov    (%rax),%eax
  80087e:	89 c0                	mov    %eax,%eax
  800880:	48 01 d0             	add    %rdx,%rax
  800883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800887:	8b 12                	mov    (%rdx),%edx
  800889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80088c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800890:	89 0a                	mov    %ecx,(%rdx)
  800892:	eb 17                	jmp    8008ab <getint+0x5b>
  800894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800898:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80089c:	48 89 d0             	mov    %rdx,%rax
  80089f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ab:	48 8b 00             	mov    (%rax),%rax
  8008ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008b2:	e9 a3 00 00 00       	jmpq   80095a <getint+0x10a>
	else if (lflag)
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008bb:	74 4f                	je     80090c <getint+0xbc>
		x=va_arg(*ap, long);
  8008bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c1:	8b 00                	mov    (%rax),%eax
  8008c3:	83 f8 30             	cmp    $0x30,%eax
  8008c6:	73 24                	jae    8008ec <getint+0x9c>
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d4:	8b 00                	mov    (%rax),%eax
  8008d6:	89 c0                	mov    %eax,%eax
  8008d8:	48 01 d0             	add    %rdx,%rax
  8008db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008df:	8b 12                	mov    (%rdx),%edx
  8008e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e8:	89 0a                	mov    %ecx,(%rdx)
  8008ea:	eb 17                	jmp    800903 <getint+0xb3>
  8008ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008f4:	48 89 d0             	mov    %rdx,%rax
  8008f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800903:	48 8b 00             	mov    (%rax),%rax
  800906:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80090a:	eb 4e                	jmp    80095a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	8b 00                	mov    (%rax),%eax
  800912:	83 f8 30             	cmp    $0x30,%eax
  800915:	73 24                	jae    80093b <getint+0xeb>
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	8b 00                	mov    (%rax),%eax
  800925:	89 c0                	mov    %eax,%eax
  800927:	48 01 d0             	add    %rdx,%rax
  80092a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092e:	8b 12                	mov    (%rdx),%edx
  800930:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800937:	89 0a                	mov    %ecx,(%rdx)
  800939:	eb 17                	jmp    800952 <getint+0x102>
  80093b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800943:	48 89 d0             	mov    %rdx,%rax
  800946:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800952:	8b 00                	mov    (%rax),%eax
  800954:	48 98                	cltq   
  800956:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80095a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80095e:	c9                   	leaveq 
  80095f:	c3                   	retq   

0000000000800960 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800960:	55                   	push   %rbp
  800961:	48 89 e5             	mov    %rsp,%rbp
  800964:	41 54                	push   %r12
  800966:	53                   	push   %rbx
  800967:	48 83 ec 60          	sub    $0x60,%rsp
  80096b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80096f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800973:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800977:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80097b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80097f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800983:	48 8b 0a             	mov    (%rdx),%rcx
  800986:	48 89 08             	mov    %rcx,(%rax)
  800989:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80098d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800991:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800995:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800999:	eb 17                	jmp    8009b2 <vprintfmt+0x52>
			if (ch == '\0')
  80099b:	85 db                	test   %ebx,%ebx
  80099d:	0f 84 d7 04 00 00    	je     800e7a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8009a3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009a7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009ab:	48 89 c6             	mov    %rax,%rsi
  8009ae:	89 df                	mov    %ebx,%edi
  8009b0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009b6:	0f b6 00             	movzbl (%rax),%eax
  8009b9:	0f b6 d8             	movzbl %al,%ebx
  8009bc:	83 fb 25             	cmp    $0x25,%ebx
  8009bf:	0f 95 c0             	setne  %al
  8009c2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009c7:	84 c0                	test   %al,%al
  8009c9:	75 d0                	jne    80099b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009cf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8009eb:	eb 04                	jmp    8009f1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8009ed:	90                   	nop
  8009ee:	eb 01                	jmp    8009f1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8009f0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009f5:	0f b6 00             	movzbl (%rax),%eax
  8009f8:	0f b6 d8             	movzbl %al,%ebx
  8009fb:	89 d8                	mov    %ebx,%eax
  8009fd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a02:	83 e8 23             	sub    $0x23,%eax
  800a05:	83 f8 55             	cmp    $0x55,%eax
  800a08:	0f 87 38 04 00 00    	ja     800e46 <vprintfmt+0x4e6>
  800a0e:	89 c0                	mov    %eax,%eax
  800a10:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a17:	00 
  800a18:	48 b8 d0 55 80 00 00 	movabs $0x8055d0,%rax
  800a1f:	00 00 00 
  800a22:	48 01 d0             	add    %rdx,%rax
  800a25:	48 8b 00             	mov    (%rax),%rax
  800a28:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a2a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a2e:	eb c1                	jmp    8009f1 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a30:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a34:	eb bb                	jmp    8009f1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a36:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a3d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a40:	89 d0                	mov    %edx,%eax
  800a42:	c1 e0 02             	shl    $0x2,%eax
  800a45:	01 d0                	add    %edx,%eax
  800a47:	01 c0                	add    %eax,%eax
  800a49:	01 d8                	add    %ebx,%eax
  800a4b:	83 e8 30             	sub    $0x30,%eax
  800a4e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a55:	0f b6 00             	movzbl (%rax),%eax
  800a58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a5e:	7e 63                	jle    800ac3 <vprintfmt+0x163>
  800a60:	83 fb 39             	cmp    $0x39,%ebx
  800a63:	7f 5e                	jg     800ac3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a65:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6a:	eb d1                	jmp    800a3d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	83 f8 30             	cmp    $0x30,%eax
  800a72:	73 17                	jae    800a8b <vprintfmt+0x12b>
  800a74:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7b:	89 c0                	mov    %eax,%eax
  800a7d:	48 01 d0             	add    %rdx,%rax
  800a80:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a83:	83 c2 08             	add    $0x8,%edx
  800a86:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a89:	eb 0f                	jmp    800a9a <vprintfmt+0x13a>
  800a8b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8f:	48 89 d0             	mov    %rdx,%rax
  800a92:	48 83 c2 08          	add    $0x8,%rdx
  800a96:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9a:	8b 00                	mov    (%rax),%eax
  800a9c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a9f:	eb 23                	jmp    800ac4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800aa1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aa5:	0f 89 42 ff ff ff    	jns    8009ed <vprintfmt+0x8d>
				width = 0;
  800aab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ab2:	e9 36 ff ff ff       	jmpq   8009ed <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800ab7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800abe:	e9 2e ff ff ff       	jmpq   8009f1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ac8:	0f 89 22 ff ff ff    	jns    8009f0 <vprintfmt+0x90>
				width = precision, precision = -1;
  800ace:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ad4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800adb:	e9 10 ff ff ff       	jmpq   8009f0 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ae4:	e9 08 ff ff ff       	jmpq   8009f1 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800ae9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aec:	83 f8 30             	cmp    $0x30,%eax
  800aef:	73 17                	jae    800b08 <vprintfmt+0x1a8>
  800af1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af8:	89 c0                	mov    %eax,%eax
  800afa:	48 01 d0             	add    %rdx,%rax
  800afd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b00:	83 c2 08             	add    $0x8,%edx
  800b03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b06:	eb 0f                	jmp    800b17 <vprintfmt+0x1b7>
  800b08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0c:	48 89 d0             	mov    %rdx,%rax
  800b0f:	48 83 c2 08          	add    $0x8,%rdx
  800b13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b17:	8b 00                	mov    (%rax),%eax
  800b19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b21:	48 89 d6             	mov    %rdx,%rsi
  800b24:	89 c7                	mov    %eax,%edi
  800b26:	ff d1                	callq  *%rcx
			break;
  800b28:	e9 47 03 00 00       	jmpq   800e74 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b30:	83 f8 30             	cmp    $0x30,%eax
  800b33:	73 17                	jae    800b4c <vprintfmt+0x1ec>
  800b35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3c:	89 c0                	mov    %eax,%eax
  800b3e:	48 01 d0             	add    %rdx,%rax
  800b41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b44:	83 c2 08             	add    $0x8,%edx
  800b47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b4a:	eb 0f                	jmp    800b5b <vprintfmt+0x1fb>
  800b4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b50:	48 89 d0             	mov    %rdx,%rax
  800b53:	48 83 c2 08          	add    $0x8,%rdx
  800b57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b5b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b5d:	85 db                	test   %ebx,%ebx
  800b5f:	79 02                	jns    800b63 <vprintfmt+0x203>
				err = -err;
  800b61:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b63:	83 fb 10             	cmp    $0x10,%ebx
  800b66:	7f 16                	jg     800b7e <vprintfmt+0x21e>
  800b68:	48 b8 20 55 80 00 00 	movabs $0x805520,%rax
  800b6f:	00 00 00 
  800b72:	48 63 d3             	movslq %ebx,%rdx
  800b75:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b79:	4d 85 e4             	test   %r12,%r12
  800b7c:	75 2e                	jne    800bac <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b7e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b86:	89 d9                	mov    %ebx,%ecx
  800b88:	48 ba b9 55 80 00 00 	movabs $0x8055b9,%rdx
  800b8f:	00 00 00 
  800b92:	48 89 c7             	mov    %rax,%rdi
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	49 b8 84 0e 80 00 00 	movabs $0x800e84,%r8
  800ba1:	00 00 00 
  800ba4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ba7:	e9 c8 02 00 00       	jmpq   800e74 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb4:	4c 89 e1             	mov    %r12,%rcx
  800bb7:	48 ba c2 55 80 00 00 	movabs $0x8055c2,%rdx
  800bbe:	00 00 00 
  800bc1:	48 89 c7             	mov    %rax,%rdi
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc9:	49 b8 84 0e 80 00 00 	movabs $0x800e84,%r8
  800bd0:	00 00 00 
  800bd3:	41 ff d0             	callq  *%r8
			break;
  800bd6:	e9 99 02 00 00       	jmpq   800e74 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bdb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bde:	83 f8 30             	cmp    $0x30,%eax
  800be1:	73 17                	jae    800bfa <vprintfmt+0x29a>
  800be3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800be7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bea:	89 c0                	mov    %eax,%eax
  800bec:	48 01 d0             	add    %rdx,%rax
  800bef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf2:	83 c2 08             	add    $0x8,%edx
  800bf5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bf8:	eb 0f                	jmp    800c09 <vprintfmt+0x2a9>
  800bfa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bfe:	48 89 d0             	mov    %rdx,%rax
  800c01:	48 83 c2 08          	add    $0x8,%rdx
  800c05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c09:	4c 8b 20             	mov    (%rax),%r12
  800c0c:	4d 85 e4             	test   %r12,%r12
  800c0f:	75 0a                	jne    800c1b <vprintfmt+0x2bb>
				p = "(null)";
  800c11:	49 bc c5 55 80 00 00 	movabs $0x8055c5,%r12
  800c18:	00 00 00 
			if (width > 0 && padc != '-')
  800c1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c1f:	7e 7a                	jle    800c9b <vprintfmt+0x33b>
  800c21:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c25:	74 74                	je     800c9b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c27:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c2a:	48 98                	cltq   
  800c2c:	48 89 c6             	mov    %rax,%rsi
  800c2f:	4c 89 e7             	mov    %r12,%rdi
  800c32:	48 b8 2e 11 80 00 00 	movabs $0x80112e,%rax
  800c39:	00 00 00 
  800c3c:	ff d0                	callq  *%rax
  800c3e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c41:	eb 17                	jmp    800c5a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800c43:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800c47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c4f:	48 89 d6             	mov    %rdx,%rsi
  800c52:	89 c7                	mov    %eax,%edi
  800c54:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c56:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5e:	7f e3                	jg     800c43 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c60:	eb 39                	jmp    800c9b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800c62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c66:	74 1e                	je     800c86 <vprintfmt+0x326>
  800c68:	83 fb 1f             	cmp    $0x1f,%ebx
  800c6b:	7e 05                	jle    800c72 <vprintfmt+0x312>
  800c6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c70:	7e 14                	jle    800c86 <vprintfmt+0x326>
					putch('?', putdat);
  800c72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c7a:	48 89 c6             	mov    %rax,%rsi
  800c7d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c82:	ff d2                	callq  *%rdx
  800c84:	eb 0f                	jmp    800c95 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c86:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8e:	48 89 c6             	mov    %rax,%rsi
  800c91:	89 df                	mov    %ebx,%edi
  800c93:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c95:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c99:	eb 01                	jmp    800c9c <vprintfmt+0x33c>
  800c9b:	90                   	nop
  800c9c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ca1:	0f be d8             	movsbl %al,%ebx
  800ca4:	85 db                	test   %ebx,%ebx
  800ca6:	0f 95 c0             	setne  %al
  800ca9:	49 83 c4 01          	add    $0x1,%r12
  800cad:	84 c0                	test   %al,%al
  800caf:	74 28                	je     800cd9 <vprintfmt+0x379>
  800cb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cb5:	78 ab                	js     800c62 <vprintfmt+0x302>
  800cb7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800cbb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cbf:	79 a1                	jns    800c62 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cc1:	eb 16                	jmp    800cd9 <vprintfmt+0x379>
				putch(' ', putdat);
  800cc3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cc7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ccb:	48 89 c6             	mov    %rax,%rsi
  800cce:	bf 20 00 00 00       	mov    $0x20,%edi
  800cd3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cdd:	7f e4                	jg     800cc3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800cdf:	e9 90 01 00 00       	jmpq   800e74 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800ce4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce8:	be 03 00 00 00       	mov    $0x3,%esi
  800ced:	48 89 c7             	mov    %rax,%rdi
  800cf0:	48 b8 50 08 80 00 00 	movabs $0x800850,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
  800cfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d04:	48 85 c0             	test   %rax,%rax
  800d07:	79 1d                	jns    800d26 <vprintfmt+0x3c6>
				putch('-', putdat);
  800d09:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d0d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d11:	48 89 c6             	mov    %rax,%rsi
  800d14:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d19:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1f:	48 f7 d8             	neg    %rax
  800d22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d2d:	e9 d5 00 00 00       	jmpq   800e07 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d36:	be 03 00 00 00       	mov    $0x3,%esi
  800d3b:	48 89 c7             	mov    %rax,%rdi
  800d3e:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  800d45:	00 00 00 
  800d48:	ff d0                	callq  *%rax
  800d4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d4e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d55:	e9 ad 00 00 00       	jmpq   800e07 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800d5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5e:	be 03 00 00 00       	mov    $0x3,%esi
  800d63:	48 89 c7             	mov    %rax,%rdi
  800d66:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	callq  *%rax
  800d72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800d76:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d7d:	e9 85 00 00 00       	jmpq   800e07 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800d82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d8a:	48 89 c6             	mov    %rax,%rsi
  800d8d:	bf 30 00 00 00       	mov    $0x30,%edi
  800d92:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d94:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d98:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d9c:	48 89 c6             	mov    %rax,%rsi
  800d9f:	bf 78 00 00 00       	mov    $0x78,%edi
  800da4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800da6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da9:	83 f8 30             	cmp    $0x30,%eax
  800dac:	73 17                	jae    800dc5 <vprintfmt+0x465>
  800dae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800db5:	89 c0                	mov    %eax,%eax
  800db7:	48 01 d0             	add    %rdx,%rax
  800dba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dbd:	83 c2 08             	add    $0x8,%edx
  800dc0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc3:	eb 0f                	jmp    800dd4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800dc5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dc9:	48 89 d0             	mov    %rdx,%rax
  800dcc:	48 83 c2 08          	add    $0x8,%rdx
  800dd0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ddb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800de2:	eb 23                	jmp    800e07 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800de4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de8:	be 03 00 00 00       	mov    $0x3,%esi
  800ded:	48 89 c7             	mov    %rax,%rdi
  800df0:	48 b8 40 07 80 00 00 	movabs $0x800740,%rax
  800df7:	00 00 00 
  800dfa:	ff d0                	callq  *%rax
  800dfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e00:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e07:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e0c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e0f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e1e:	45 89 c1             	mov    %r8d,%r9d
  800e21:	41 89 f8             	mov    %edi,%r8d
  800e24:	48 89 c7             	mov    %rax,%rdi
  800e27:	48 b8 88 06 80 00 00 	movabs $0x800688,%rax
  800e2e:	00 00 00 
  800e31:	ff d0                	callq  *%rax
			break;
  800e33:	eb 3f                	jmp    800e74 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e35:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e39:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e3d:	48 89 c6             	mov    %rax,%rsi
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	ff d2                	callq  *%rdx
			break;
  800e44:	eb 2e                	jmp    800e74 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e46:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e4a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e4e:	48 89 c6             	mov    %rax,%rsi
  800e51:	bf 25 00 00 00       	mov    $0x25,%edi
  800e56:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e58:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e5d:	eb 05                	jmp    800e64 <vprintfmt+0x504>
  800e5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e64:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e68:	48 83 e8 01          	sub    $0x1,%rax
  800e6c:	0f b6 00             	movzbl (%rax),%eax
  800e6f:	3c 25                	cmp    $0x25,%al
  800e71:	75 ec                	jne    800e5f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800e73:	90                   	nop
		}
	}
  800e74:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e75:	e9 38 fb ff ff       	jmpq   8009b2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e7a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800e7b:	48 83 c4 60          	add    $0x60,%rsp
  800e7f:	5b                   	pop    %rbx
  800e80:	41 5c                	pop    %r12
  800e82:	5d                   	pop    %rbp
  800e83:	c3                   	retq   

0000000000800e84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e84:	55                   	push   %rbp
  800e85:	48 89 e5             	mov    %rsp,%rbp
  800e88:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e8f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e96:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e9d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ea4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800eab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800eb2:	84 c0                	test   %al,%al
  800eb4:	74 20                	je     800ed6 <printfmt+0x52>
  800eb6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ebe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ec2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ec6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ece:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ed2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ed6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800edd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ee4:	00 00 00 
  800ee7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800eee:	00 00 00 
  800ef1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ef5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800efc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f03:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f0a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f11:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f18:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f1f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 60 09 80 00 00 	movabs $0x800960,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f35:	c9                   	leaveq 
  800f36:	c3                   	retq   

0000000000800f37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f37:	55                   	push   %rbp
  800f38:	48 89 e5             	mov    %rsp,%rbp
  800f3b:	48 83 ec 10          	sub    $0x10,%rsp
  800f3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f4a:	8b 40 10             	mov    0x10(%rax),%eax
  800f4d:	8d 50 01             	lea    0x1(%rax),%edx
  800f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f54:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5b:	48 8b 10             	mov    (%rax),%rdx
  800f5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f62:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f66:	48 39 c2             	cmp    %rax,%rdx
  800f69:	73 17                	jae    800f82 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6f:	48 8b 00             	mov    (%rax),%rax
  800f72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f75:	88 10                	mov    %dl,(%rax)
  800f77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f7f:	48 89 10             	mov    %rdx,(%rax)
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 50          	sub    $0x50,%rsp
  800f8c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f90:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f93:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f97:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f9b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f9f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fa3:	48 8b 0a             	mov    (%rdx),%rcx
  800fa6:	48 89 08             	mov    %rcx,(%rax)
  800fa9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fb1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fb5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fc1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fc4:	48 98                	cltq   
  800fc6:	48 83 e8 01          	sub    $0x1,%rax
  800fca:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800fce:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fd9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fde:	74 06                	je     800fe6 <vsnprintf+0x62>
  800fe0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fe4:	7f 07                	jg     800fed <vsnprintf+0x69>
		return -E_INVAL;
  800fe6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800feb:	eb 2f                	jmp    80101c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fed:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ff1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ff5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ff9:	48 89 c6             	mov    %rax,%rsi
  800ffc:	48 bf 37 0f 80 00 00 	movabs $0x800f37,%rdi
  801003:	00 00 00 
  801006:	48 b8 60 09 80 00 00 	movabs $0x800960,%rax
  80100d:	00 00 00 
  801010:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801012:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801016:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801019:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80101c:	c9                   	leaveq 
  80101d:	c3                   	retq   

000000000080101e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80101e:	55                   	push   %rbp
  80101f:	48 89 e5             	mov    %rsp,%rbp
  801022:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801029:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801030:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801036:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80103d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801044:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80104b:	84 c0                	test   %al,%al
  80104d:	74 20                	je     80106f <snprintf+0x51>
  80104f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801053:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801057:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80105b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80105f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801063:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801067:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80106b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80106f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801076:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80107d:	00 00 00 
  801080:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801087:	00 00 00 
  80108a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80108e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801095:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80109c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010a3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010aa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010b1:	48 8b 0a             	mov    (%rdx),%rcx
  8010b4:	48 89 08             	mov    %rcx,(%rax)
  8010b7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010bb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010bf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010c3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010c7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010ce:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010d5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010db:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010e2:	48 89 c7             	mov    %rax,%rdi
  8010e5:	48 b8 84 0f 80 00 00 	movabs $0x800f84,%rax
  8010ec:	00 00 00 
  8010ef:	ff d0                	callq  *%rax
  8010f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010fd:	c9                   	leaveq 
  8010fe:	c3                   	retq   
	...

0000000000801100 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 18          	sub    $0x18,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80110c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801113:	eb 09                	jmp    80111e <strlen+0x1e>
		n++;
  801115:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801119:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	75 ec                	jne    801115 <strlen+0x15>
		n++;
	return n;
  801129:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80112c:	c9                   	leaveq 
  80112d:	c3                   	retq   

000000000080112e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80112e:	55                   	push   %rbp
  80112f:	48 89 e5             	mov    %rsp,%rbp
  801132:	48 83 ec 20          	sub    $0x20,%rsp
  801136:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80113e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801145:	eb 0e                	jmp    801155 <strnlen+0x27>
		n++;
  801147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80114b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801150:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801155:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80115a:	74 0b                	je     801167 <strnlen+0x39>
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	75 e0                	jne    801147 <strnlen+0x19>
		n++;
	return n;
  801167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80116a:	c9                   	leaveq 
  80116b:	c3                   	retq   

000000000080116c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80116c:	55                   	push   %rbp
  80116d:	48 89 e5             	mov    %rsp,%rbp
  801170:	48 83 ec 20          	sub    $0x20,%rsp
  801174:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801178:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80117c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801180:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801184:	90                   	nop
  801185:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801189:	0f b6 10             	movzbl (%rax),%edx
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	88 10                	mov    %dl,(%rax)
  801192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801196:	0f b6 00             	movzbl (%rax),%eax
  801199:	84 c0                	test   %al,%al
  80119b:	0f 95 c0             	setne  %al
  80119e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011a3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8011a8:	84 c0                	test   %al,%al
  8011aa:	75 d9                	jne    801185 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b0:	c9                   	leaveq 
  8011b1:	c3                   	retq   

00000000008011b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011b2:	55                   	push   %rbp
  8011b3:	48 89 e5             	mov    %rsp,%rbp
  8011b6:	48 83 ec 20          	sub    $0x20,%rsp
  8011ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	48 89 c7             	mov    %rax,%rdi
  8011c9:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8011d0:	00 00 00 
  8011d3:	ff d0                	callq  *%rax
  8011d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011db:	48 98                	cltq   
  8011dd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8011e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011e5:	48 89 d6             	mov    %rdx,%rsi
  8011e8:	48 89 c7             	mov    %rax,%rdi
  8011eb:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  8011f2:	00 00 00 
  8011f5:	ff d0                	callq  *%rax
	return dst;
  8011f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011fb:	c9                   	leaveq 
  8011fc:	c3                   	retq   

00000000008011fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011fd:	55                   	push   %rbp
  8011fe:	48 89 e5             	mov    %rsp,%rbp
  801201:	48 83 ec 28          	sub    $0x28,%rsp
  801205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80120d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801219:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801220:	00 
  801221:	eb 27                	jmp    80124a <strncpy+0x4d>
		*dst++ = *src;
  801223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801227:	0f b6 10             	movzbl (%rax),%edx
  80122a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122e:	88 10                	mov    %dl,(%rax)
  801230:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801235:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801239:	0f b6 00             	movzbl (%rax),%eax
  80123c:	84 c0                	test   %al,%al
  80123e:	74 05                	je     801245 <strncpy+0x48>
			src++;
  801240:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801245:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801252:	72 cf                	jb     801223 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801258:	c9                   	leaveq 
  801259:	c3                   	retq   

000000000080125a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80125a:	55                   	push   %rbp
  80125b:	48 89 e5             	mov    %rsp,%rbp
  80125e:	48 83 ec 28          	sub    $0x28,%rsp
  801262:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801266:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80126a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80126e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801272:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801276:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80127b:	74 37                	je     8012b4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80127d:	eb 17                	jmp    801296 <strlcpy+0x3c>
			*dst++ = *src++;
  80127f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801283:	0f b6 10             	movzbl (%rax),%edx
  801286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128a:	88 10                	mov    %dl,(%rax)
  80128c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801291:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801296:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80129b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012a0:	74 0b                	je     8012ad <strlcpy+0x53>
  8012a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 d2                	jne    80127f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	48 89 d1             	mov    %rdx,%rcx
  8012bf:	48 29 c1             	sub    %rax,%rcx
  8012c2:	48 89 c8             	mov    %rcx,%rax
}
  8012c5:	c9                   	leaveq 
  8012c6:	c3                   	retq   

00000000008012c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
  8012cb:	48 83 ec 10          	sub    $0x10,%rsp
  8012cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012d7:	eb 0a                	jmp    8012e3 <strcmp+0x1c>
		p++, q++;
  8012d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e7:	0f b6 00             	movzbl (%rax),%eax
  8012ea:	84 c0                	test   %al,%al
  8012ec:	74 12                	je     801300 <strcmp+0x39>
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	0f b6 10             	movzbl (%rax),%edx
  8012f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f9:	0f b6 00             	movzbl (%rax),%eax
  8012fc:	38 c2                	cmp    %al,%dl
  8012fe:	74 d9                	je     8012d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801300:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	0f b6 d0             	movzbl %al,%edx
  80130a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	0f b6 c0             	movzbl %al,%eax
  801314:	89 d1                	mov    %edx,%ecx
  801316:	29 c1                	sub    %eax,%ecx
  801318:	89 c8                	mov    %ecx,%eax
}
  80131a:	c9                   	leaveq 
  80131b:	c3                   	retq   

000000000080131c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	48 83 ec 18          	sub    $0x18,%rsp
  801324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801328:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80132c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801330:	eb 0f                	jmp    801341 <strncmp+0x25>
		n--, p++, q++;
  801332:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801337:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801341:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801346:	74 1d                	je     801365 <strncmp+0x49>
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	0f b6 00             	movzbl (%rax),%eax
  80134f:	84 c0                	test   %al,%al
  801351:	74 12                	je     801365 <strncmp+0x49>
  801353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801357:	0f b6 10             	movzbl (%rax),%edx
  80135a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80135e:	0f b6 00             	movzbl (%rax),%eax
  801361:	38 c2                	cmp    %al,%dl
  801363:	74 cd                	je     801332 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801365:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80136a:	75 07                	jne    801373 <strncmp+0x57>
		return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 1a                	jmp    80138d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	0f b6 d0             	movzbl %al,%edx
  80137d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	0f b6 c0             	movzbl %al,%eax
  801387:	89 d1                	mov    %edx,%ecx
  801389:	29 c1                	sub    %eax,%ecx
  80138b:	89 c8                	mov    %ecx,%eax
}
  80138d:	c9                   	leaveq 
  80138e:	c3                   	retq   

000000000080138f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80138f:	55                   	push   %rbp
  801390:	48 89 e5             	mov    %rsp,%rbp
  801393:	48 83 ec 10          	sub    $0x10,%rsp
  801397:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80139b:	89 f0                	mov    %esi,%eax
  80139d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013a0:	eb 17                	jmp    8013b9 <strchr+0x2a>
		if (*s == c)
  8013a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013ac:	75 06                	jne    8013b4 <strchr+0x25>
			return (char *) s;
  8013ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b2:	eb 15                	jmp    8013c9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	0f b6 00             	movzbl (%rax),%eax
  8013c0:	84 c0                	test   %al,%al
  8013c2:	75 de                	jne    8013a2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c9:	c9                   	leaveq 
  8013ca:	c3                   	retq   

00000000008013cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013cb:	55                   	push   %rbp
  8013cc:	48 89 e5             	mov    %rsp,%rbp
  8013cf:	48 83 ec 10          	sub    $0x10,%rsp
  8013d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d7:	89 f0                	mov    %esi,%eax
  8013d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013dc:	eb 11                	jmp    8013ef <strfind+0x24>
		if (*s == c)
  8013de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013e8:	74 12                	je     8013fc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f3:	0f b6 00             	movzbl (%rax),%eax
  8013f6:	84 c0                	test   %al,%al
  8013f8:	75 e4                	jne    8013de <strfind+0x13>
  8013fa:	eb 01                	jmp    8013fd <strfind+0x32>
		if (*s == c)
			break;
  8013fc:	90                   	nop
	return (char *) s;
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801401:	c9                   	leaveq 
  801402:	c3                   	retq   

0000000000801403 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801403:	55                   	push   %rbp
  801404:	48 89 e5             	mov    %rsp,%rbp
  801407:	48 83 ec 18          	sub    $0x18,%rsp
  80140b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80140f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801412:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801416:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80141b:	75 06                	jne    801423 <memset+0x20>
		return v;
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801421:	eb 69                	jmp    80148c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801427:	83 e0 03             	and    $0x3,%eax
  80142a:	48 85 c0             	test   %rax,%rax
  80142d:	75 48                	jne    801477 <memset+0x74>
  80142f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 3c                	jne    801477 <memset+0x74>
		c &= 0xFF;
  80143b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801442:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801445:	89 c2                	mov    %eax,%edx
  801447:	c1 e2 18             	shl    $0x18,%edx
  80144a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144d:	c1 e0 10             	shl    $0x10,%eax
  801450:	09 c2                	or     %eax,%edx
  801452:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801455:	c1 e0 08             	shl    $0x8,%eax
  801458:	09 d0                	or     %edx,%eax
  80145a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80145d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801461:	48 89 c1             	mov    %rax,%rcx
  801464:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801468:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80146f:	48 89 d7             	mov    %rdx,%rdi
  801472:	fc                   	cld    
  801473:	f3 ab                	rep stos %eax,%es:(%rdi)
  801475:	eb 11                	jmp    801488 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801477:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80147e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801482:	48 89 d7             	mov    %rdx,%rdi
  801485:	fc                   	cld    
  801486:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80148c:	c9                   	leaveq 
  80148d:	c3                   	retq   

000000000080148e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80148e:	55                   	push   %rbp
  80148f:	48 89 e5             	mov    %rsp,%rbp
  801492:	48 83 ec 28          	sub    $0x28,%rsp
  801496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80149e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ba:	0f 83 88 00 00 00    	jae    801548 <memmove+0xba>
  8014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c8:	48 01 d0             	add    %rdx,%rax
  8014cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014cf:	76 77                	jbe    801548 <memmove+0xba>
		s += n;
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e5:	83 e0 03             	and    $0x3,%eax
  8014e8:	48 85 c0             	test   %rax,%rax
  8014eb:	75 3b                	jne    801528 <memmove+0x9a>
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	83 e0 03             	and    $0x3,%eax
  8014f4:	48 85 c0             	test   %rax,%rax
  8014f7:	75 2f                	jne    801528 <memmove+0x9a>
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	83 e0 03             	and    $0x3,%eax
  801500:	48 85 c0             	test   %rax,%rax
  801503:	75 23                	jne    801528 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801509:	48 83 e8 04          	sub    $0x4,%rax
  80150d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801511:	48 83 ea 04          	sub    $0x4,%rdx
  801515:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801519:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80151d:	48 89 c7             	mov    %rax,%rdi
  801520:	48 89 d6             	mov    %rdx,%rsi
  801523:	fd                   	std    
  801524:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801526:	eb 1d                	jmp    801545 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801534:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801538:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153c:	48 89 d7             	mov    %rdx,%rdi
  80153f:	48 89 c1             	mov    %rax,%rcx
  801542:	fd                   	std    
  801543:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801545:	fc                   	cld    
  801546:	eb 57                	jmp    80159f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	83 e0 03             	and    $0x3,%eax
  80154f:	48 85 c0             	test   %rax,%rax
  801552:	75 36                	jne    80158a <memmove+0xfc>
  801554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801558:	83 e0 03             	and    $0x3,%eax
  80155b:	48 85 c0             	test   %rax,%rax
  80155e:	75 2a                	jne    80158a <memmove+0xfc>
  801560:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801564:	83 e0 03             	and    $0x3,%eax
  801567:	48 85 c0             	test   %rax,%rax
  80156a:	75 1e                	jne    80158a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80156c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801570:	48 89 c1             	mov    %rax,%rcx
  801573:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80157f:	48 89 c7             	mov    %rax,%rdi
  801582:	48 89 d6             	mov    %rdx,%rsi
  801585:	fc                   	cld    
  801586:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801588:	eb 15                	jmp    80159f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80158a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801592:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801596:	48 89 c7             	mov    %rax,%rdi
  801599:	48 89 d6             	mov    %rdx,%rsi
  80159c:	fc                   	cld    
  80159d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 18          	sub    $0x18,%rsp
  8015ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c5:	48 89 ce             	mov    %rcx,%rsi
  8015c8:	48 89 c7             	mov    %rax,%rdi
  8015cb:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  8015d2:	00 00 00 
  8015d5:	ff d0                	callq  *%rax
}
  8015d7:	c9                   	leaveq 
  8015d8:	c3                   	retq   

00000000008015d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015d9:	55                   	push   %rbp
  8015da:	48 89 e5             	mov    %rsp,%rbp
  8015dd:	48 83 ec 28          	sub    $0x28,%rsp
  8015e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015fd:	eb 38                	jmp    801637 <memcmp+0x5e>
		if (*s1 != *s2)
  8015ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801603:	0f b6 10             	movzbl (%rax),%edx
  801606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160a:	0f b6 00             	movzbl (%rax),%eax
  80160d:	38 c2                	cmp    %al,%dl
  80160f:	74 1c                	je     80162d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801615:	0f b6 00             	movzbl (%rax),%eax
  801618:	0f b6 d0             	movzbl %al,%edx
  80161b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	0f b6 c0             	movzbl %al,%eax
  801625:	89 d1                	mov    %edx,%ecx
  801627:	29 c1                	sub    %eax,%ecx
  801629:	89 c8                	mov    %ecx,%eax
  80162b:	eb 20                	jmp    80164d <memcmp+0x74>
		s1++, s2++;
  80162d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801632:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801637:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80163c:	0f 95 c0             	setne  %al
  80163f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801644:	84 c0                	test   %al,%al
  801646:	75 b7                	jne    8015ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 28          	sub    $0x28,%rsp
  801657:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80165b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80165e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801662:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801666:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80166a:	48 01 d0             	add    %rdx,%rax
  80166d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801671:	eb 13                	jmp    801686 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801677:	0f b6 10             	movzbl (%rax),%edx
  80167a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80167d:	38 c2                	cmp    %al,%dl
  80167f:	74 11                	je     801692 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801681:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80168e:	72 e3                	jb     801673 <memfind+0x24>
  801690:	eb 01                	jmp    801693 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801692:	90                   	nop
	return (void *) s;
  801693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801697:	c9                   	leaveq 
  801698:	c3                   	retq   

0000000000801699 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801699:	55                   	push   %rbp
  80169a:	48 89 e5             	mov    %rsp,%rbp
  80169d:	48 83 ec 38          	sub    $0x38,%rsp
  8016a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016a9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016b3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016ba:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016bb:	eb 05                	jmp    8016c2 <strtol+0x29>
		s++;
  8016bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c6:	0f b6 00             	movzbl (%rax),%eax
  8016c9:	3c 20                	cmp    $0x20,%al
  8016cb:	74 f0                	je     8016bd <strtol+0x24>
  8016cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d1:	0f b6 00             	movzbl (%rax),%eax
  8016d4:	3c 09                	cmp    $0x9,%al
  8016d6:	74 e5                	je     8016bd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016dc:	0f b6 00             	movzbl (%rax),%eax
  8016df:	3c 2b                	cmp    $0x2b,%al
  8016e1:	75 07                	jne    8016ea <strtol+0x51>
		s++;
  8016e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e8:	eb 17                	jmp    801701 <strtol+0x68>
	else if (*s == '-')
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	0f b6 00             	movzbl (%rax),%eax
  8016f1:	3c 2d                	cmp    $0x2d,%al
  8016f3:	75 0c                	jne    801701 <strtol+0x68>
		s++, neg = 1;
  8016f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801701:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801705:	74 06                	je     80170d <strtol+0x74>
  801707:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80170b:	75 28                	jne    801735 <strtol+0x9c>
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	3c 30                	cmp    $0x30,%al
  801716:	75 1d                	jne    801735 <strtol+0x9c>
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	48 83 c0 01          	add    $0x1,%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	3c 78                	cmp    $0x78,%al
  801725:	75 0e                	jne    801735 <strtol+0x9c>
		s += 2, base = 16;
  801727:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80172c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801733:	eb 2c                	jmp    801761 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801739:	75 19                	jne    801754 <strtol+0xbb>
  80173b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173f:	0f b6 00             	movzbl (%rax),%eax
  801742:	3c 30                	cmp    $0x30,%al
  801744:	75 0e                	jne    801754 <strtol+0xbb>
		s++, base = 8;
  801746:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80174b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801752:	eb 0d                	jmp    801761 <strtol+0xc8>
	else if (base == 0)
  801754:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801758:	75 07                	jne    801761 <strtol+0xc8>
		base = 10;
  80175a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	0f b6 00             	movzbl (%rax),%eax
  801768:	3c 2f                	cmp    $0x2f,%al
  80176a:	7e 1d                	jle    801789 <strtol+0xf0>
  80176c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801770:	0f b6 00             	movzbl (%rax),%eax
  801773:	3c 39                	cmp    $0x39,%al
  801775:	7f 12                	jg     801789 <strtol+0xf0>
			dig = *s - '0';
  801777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177b:	0f b6 00             	movzbl (%rax),%eax
  80177e:	0f be c0             	movsbl %al,%eax
  801781:	83 e8 30             	sub    $0x30,%eax
  801784:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801787:	eb 4e                	jmp    8017d7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801789:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178d:	0f b6 00             	movzbl (%rax),%eax
  801790:	3c 60                	cmp    $0x60,%al
  801792:	7e 1d                	jle    8017b1 <strtol+0x118>
  801794:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	3c 7a                	cmp    $0x7a,%al
  80179d:	7f 12                	jg     8017b1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80179f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	0f be c0             	movsbl %al,%eax
  8017a9:	83 e8 57             	sub    $0x57,%eax
  8017ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017af:	eb 26                	jmp    8017d7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b5:	0f b6 00             	movzbl (%rax),%eax
  8017b8:	3c 40                	cmp    $0x40,%al
  8017ba:	7e 47                	jle    801803 <strtol+0x16a>
  8017bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c0:	0f b6 00             	movzbl (%rax),%eax
  8017c3:	3c 5a                	cmp    $0x5a,%al
  8017c5:	7f 3c                	jg     801803 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	0f b6 00             	movzbl (%rax),%eax
  8017ce:	0f be c0             	movsbl %al,%eax
  8017d1:	83 e8 37             	sub    $0x37,%eax
  8017d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017da:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017dd:	7d 23                	jge    801802 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8017df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017e7:	48 98                	cltq   
  8017e9:	48 89 c2             	mov    %rax,%rdx
  8017ec:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8017f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017f4:	48 98                	cltq   
  8017f6:	48 01 d0             	add    %rdx,%rax
  8017f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017fd:	e9 5f ff ff ff       	jmpq   801761 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801802:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801803:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801808:	74 0b                	je     801815 <strtol+0x17c>
		*endptr = (char *) s;
  80180a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80180e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801812:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801819:	74 09                	je     801824 <strtol+0x18b>
  80181b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80181f:	48 f7 d8             	neg    %rax
  801822:	eb 04                	jmp    801828 <strtol+0x18f>
  801824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <strstr>:

char * strstr(const char *in, const char *str)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 30          	sub    $0x30,%rsp
  801832:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801836:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80183a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80183e:	0f b6 00             	movzbl (%rax),%eax
  801841:	88 45 ff             	mov    %al,-0x1(%rbp)
  801844:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801849:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80184d:	75 06                	jne    801855 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	eb 68                	jmp    8018bd <strstr+0x93>

    len = strlen(str);
  801855:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801859:	48 89 c7             	mov    %rax,%rdi
  80185c:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801863:	00 00 00 
  801866:	ff d0                	callq  *%rax
  801868:	48 98                	cltq   
  80186a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80186e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801872:	0f b6 00             	movzbl (%rax),%eax
  801875:	88 45 ef             	mov    %al,-0x11(%rbp)
  801878:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80187d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801881:	75 07                	jne    80188a <strstr+0x60>
                return (char *) 0;
  801883:	b8 00 00 00 00       	mov    $0x0,%eax
  801888:	eb 33                	jmp    8018bd <strstr+0x93>
        } while (sc != c);
  80188a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80188e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801891:	75 db                	jne    80186e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801897:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80189b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189f:	48 89 ce             	mov    %rcx,%rsi
  8018a2:	48 89 c7             	mov    %rax,%rdi
  8018a5:	48 b8 1c 13 80 00 00 	movabs $0x80131c,%rax
  8018ac:	00 00 00 
  8018af:	ff d0                	callq  *%rax
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	75 b9                	jne    80186e <strstr+0x44>

    return (char *) (in - 1);
  8018b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b9:	48 83 e8 01          	sub    $0x1,%rax
}
  8018bd:	c9                   	leaveq 
  8018be:	c3                   	retq   
	...

00000000008018c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	53                   	push   %rbx
  8018c5:	48 83 ec 58          	sub    $0x58,%rsp
  8018c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018cc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018d3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018d7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018db:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8018e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8018fc:	4c 89 c3             	mov    %r8,%rbx
  8018ff:	cd 30                	int    $0x30
  801901:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801905:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801909:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80190d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801911:	74 3e                	je     801951 <syscall+0x91>
  801913:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801918:	7e 37                	jle    801951 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80191a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80191e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801921:	49 89 d0             	mov    %rdx,%r8
  801924:	89 c1                	mov    %eax,%ecx
  801926:	48 ba 80 58 80 00 00 	movabs $0x805880,%rdx
  80192d:	00 00 00 
  801930:	be 23 00 00 00       	mov    $0x23,%esi
  801935:	48 bf 9d 58 80 00 00 	movabs $0x80589d,%rdi
  80193c:	00 00 00 
  80193f:	b8 00 00 00 00       	mov    $0x0,%eax
  801944:	49 b9 74 03 80 00 00 	movabs $0x800374,%r9
  80194b:	00 00 00 
  80194e:	41 ff d1             	callq  *%r9

	return ret;
  801951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801955:	48 83 c4 58          	add    $0x58,%rsp
  801959:	5b                   	pop    %rbx
  80195a:	5d                   	pop    %rbp
  80195b:	c3                   	retq   

000000000080195c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80195c:	55                   	push   %rbp
  80195d:	48 89 e5             	mov    %rsp,%rbp
  801960:	48 83 ec 20          	sub    $0x20,%rsp
  801964:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801968:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80196c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801974:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197b:	00 
  80197c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801982:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801988:	48 89 d1             	mov    %rdx,%rcx
  80198b:	48 89 c2             	mov    %rax,%rdx
  80198e:	be 00 00 00 00       	mov    $0x0,%esi
  801993:	bf 00 00 00 00       	mov    $0x0,%edi
  801998:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  80199f:	00 00 00 
  8019a2:	ff d0                	callq  *%rax
}
  8019a4:	c9                   	leaveq 
  8019a5:	c3                   	retq   

00000000008019a6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a6:	55                   	push   %rbp
  8019a7:	48 89 e5             	mov    %rsp,%rbp
  8019aa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019b5:	00 
  8019b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cc:	be 00 00 00 00       	mov    $0x0,%esi
  8019d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8019d6:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  8019dd:	00 00 00 
  8019e0:	ff d0                	callq  *%rax
}
  8019e2:	c9                   	leaveq 
  8019e3:	c3                   	retq   

00000000008019e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019e4:	55                   	push   %rbp
  8019e5:	48 89 e5             	mov    %rsp,%rbp
  8019e8:	48 83 ec 20          	sub    $0x20,%rsp
  8019ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f2:	48 98                	cltq   
  8019f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019fb:	00 
  8019fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0d:	48 89 c2             	mov    %rax,%rdx
  801a10:	be 01 00 00 00       	mov    $0x1,%esi
  801a15:	bf 03 00 00 00       	mov    $0x3,%edi
  801a1a:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
}
  801a26:	c9                   	leaveq 
  801a27:	c3                   	retq   

0000000000801a28 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a37:	00 
  801a38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a49:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4e:	be 00 00 00 00       	mov    $0x0,%esi
  801a53:	bf 02 00 00 00       	mov    $0x2,%edi
  801a58:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	callq  *%rax
}
  801a64:	c9                   	leaveq 
  801a65:	c3                   	retq   

0000000000801a66 <sys_yield>:

void
sys_yield(void)
{
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a6e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a75:	00 
  801a76:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a7c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a82:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a87:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8c:	be 00 00 00 00       	mov    $0x0,%esi
  801a91:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a96:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801a9d:	00 00 00 
  801aa0:	ff d0                	callq  *%rax
}
  801aa2:	c9                   	leaveq 
  801aa3:	c3                   	retq   

0000000000801aa4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801aa4:	55                   	push   %rbp
  801aa5:	48 89 e5             	mov    %rsp,%rbp
  801aa8:	48 83 ec 20          	sub    $0x20,%rsp
  801aac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ab3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ab6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab9:	48 63 c8             	movslq %eax,%rcx
  801abc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac3:	48 98                	cltq   
  801ac5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acc:	00 
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	49 89 c8             	mov    %rcx,%r8
  801ad6:	48 89 d1             	mov    %rdx,%rcx
  801ad9:	48 89 c2             	mov    %rax,%rdx
  801adc:	be 01 00 00 00       	mov    $0x1,%esi
  801ae1:	bf 04 00 00 00       	mov    $0x4,%edi
  801ae6:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801aed:	00 00 00 
  801af0:	ff d0                	callq  *%rax
}
  801af2:	c9                   	leaveq 
  801af3:	c3                   	retq   

0000000000801af4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801af4:	55                   	push   %rbp
  801af5:	48 89 e5             	mov    %rsp,%rbp
  801af8:	48 83 ec 30          	sub    $0x30,%rsp
  801afc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b03:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b06:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b0a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b11:	48 63 c8             	movslq %eax,%rcx
  801b14:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1b:	48 63 f0             	movslq %eax,%rsi
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b2b:	49 89 f9             	mov    %rdi,%r9
  801b2e:	49 89 f0             	mov    %rsi,%r8
  801b31:	48 89 d1             	mov    %rdx,%rcx
  801b34:	48 89 c2             	mov    %rax,%rdx
  801b37:	be 01 00 00 00       	mov    $0x1,%esi
  801b3c:	bf 05 00 00 00       	mov    $0x5,%edi
  801b41:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   

0000000000801b4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	48 83 ec 20          	sub    $0x20,%rsp
  801b57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b65:	48 98                	cltq   
  801b67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b6e:	00 
  801b6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b7b:	48 89 d1             	mov    %rdx,%rcx
  801b7e:	48 89 c2             	mov    %rax,%rdx
  801b81:	be 01 00 00 00       	mov    $0x1,%esi
  801b86:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8b:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
}
  801b97:	c9                   	leaveq 
  801b98:	c3                   	retq   

0000000000801b99 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b99:	55                   	push   %rbp
  801b9a:	48 89 e5             	mov    %rsp,%rbp
  801b9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ba1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ba4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ba7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801baa:	48 63 d0             	movslq %eax,%rdx
  801bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb0:	48 98                	cltq   
  801bb2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb9:	00 
  801bba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc6:	48 89 d1             	mov    %rdx,%rcx
  801bc9:	48 89 c2             	mov    %rax,%rdx
  801bcc:	be 01 00 00 00       	mov    $0x1,%esi
  801bd1:	bf 08 00 00 00       	mov    $0x8,%edi
  801bd6:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801bdd:	00 00 00 
  801be0:	ff d0                	callq  *%rax
}
  801be2:	c9                   	leaveq 
  801be3:	c3                   	retq   

0000000000801be4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801be4:	55                   	push   %rbp
  801be5:	48 89 e5             	mov    %rsp,%rbp
  801be8:	48 83 ec 20          	sub    $0x20,%rsp
  801bec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfa:	48 98                	cltq   
  801bfc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c03:	00 
  801c04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c10:	48 89 d1             	mov    %rdx,%rcx
  801c13:	48 89 c2             	mov    %rax,%rdx
  801c16:	be 01 00 00 00       	mov    $0x1,%esi
  801c1b:	bf 09 00 00 00       	mov    $0x9,%edi
  801c20:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801c27:	00 00 00 
  801c2a:	ff d0                	callq  *%rax
}
  801c2c:	c9                   	leaveq 
  801c2d:	c3                   	retq   

0000000000801c2e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c2e:	55                   	push   %rbp
  801c2f:	48 89 e5             	mov    %rsp,%rbp
  801c32:	48 83 ec 20          	sub    $0x20,%rsp
  801c36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c44:	48 98                	cltq   
  801c46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4d:	00 
  801c4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c5a:	48 89 d1             	mov    %rdx,%rcx
  801c5d:	48 89 c2             	mov    %rax,%rdx
  801c60:	be 01 00 00 00       	mov    $0x1,%esi
  801c65:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c6a:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801c71:	00 00 00 
  801c74:	ff d0                	callq  *%rax
}
  801c76:	c9                   	leaveq 
  801c77:	c3                   	retq   

0000000000801c78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c78:	55                   	push   %rbp
  801c79:	48 89 e5             	mov    %rsp,%rbp
  801c7c:	48 83 ec 30          	sub    $0x30,%rsp
  801c80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c8b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c91:	48 63 f0             	movslq %eax,%rsi
  801c94:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9b:	48 98                	cltq   
  801c9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ca1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca8:	00 
  801ca9:	49 89 f1             	mov    %rsi,%r9
  801cac:	49 89 c8             	mov    %rcx,%r8
  801caf:	48 89 d1             	mov    %rdx,%rcx
  801cb2:	48 89 c2             	mov    %rax,%rdx
  801cb5:	be 00 00 00 00       	mov    $0x0,%esi
  801cba:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cbf:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801cc6:	00 00 00 
  801cc9:	ff d0                	callq  *%rax
}
  801ccb:	c9                   	leaveq 
  801ccc:	c3                   	retq   

0000000000801ccd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ccd:	55                   	push   %rbp
  801cce:	48 89 e5             	mov    %rsp,%rbp
  801cd1:	48 83 ec 20          	sub    $0x20,%rsp
  801cd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce4:	00 
  801ce5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ceb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf6:	48 89 c2             	mov    %rax,%rdx
  801cf9:	be 01 00 00 00       	mov    $0x1,%esi
  801cfe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d03:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d0a:	00 00 00 
  801d0d:	ff d0                	callq  *%rax
}
  801d0f:	c9                   	leaveq 
  801d10:	c3                   	retq   

0000000000801d11 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d11:	55                   	push   %rbp
  801d12:	48 89 e5             	mov    %rsp,%rbp
  801d15:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d20:	00 
  801d21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d32:	ba 00 00 00 00       	mov    $0x0,%edx
  801d37:	be 00 00 00 00       	mov    $0x0,%esi
  801d3c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d41:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d48:	00 00 00 
  801d4b:	ff d0                	callq  *%rax
}
  801d4d:	c9                   	leaveq 
  801d4e:	c3                   	retq   

0000000000801d4f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801d4f:	55                   	push   %rbp
  801d50:	48 89 e5             	mov    %rsp,%rbp
  801d53:	48 83 ec 20          	sub    $0x20,%rsp
  801d57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6e:	00 
  801d6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d7b:	48 89 d1             	mov    %rdx,%rcx
  801d7e:	48 89 c2             	mov    %rax,%rdx
  801d81:	be 00 00 00 00       	mov    $0x0,%esi
  801d86:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d8b:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 20          	sub    $0x20,%rsp
  801da1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801da9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801db1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db8:	00 
  801db9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dc5:	48 89 d1             	mov    %rdx,%rcx
  801dc8:	48 89 c2             	mov    %rax,%rdx
  801dcb:	be 00 00 00 00       	mov    $0x0,%esi
  801dd0:	bf 10 00 00 00       	mov    $0x10,%edi
  801dd5:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  801ddc:	00 00 00 
  801ddf:	ff d0                	callq  *%rax
}
  801de1:	c9                   	leaveq 
  801de2:	c3                   	retq   
	...

0000000000801de4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801de4:	55                   	push   %rbp
  801de5:	48 89 e5             	mov    %rsp,%rbp
  801de8:	48 83 ec 30          	sub    $0x30,%rsp
  801dec:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801df0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df4:	48 8b 00             	mov    (%rax),%rax
  801df7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801dfb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dff:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e03:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801e06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e09:	83 e0 02             	and    $0x2,%eax
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	74 23                	je     801e33 <pgfault+0x4f>
  801e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e14:	48 89 c2             	mov    %rax,%rdx
  801e17:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e1b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e22:	01 00 00 
  801e25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e29:	25 00 08 00 00       	and    $0x800,%eax
  801e2e:	48 85 c0             	test   %rax,%rax
  801e31:	75 2a                	jne    801e5d <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801e33:	48 ba b0 58 80 00 00 	movabs $0x8058b0,%rdx
  801e3a:	00 00 00 
  801e3d:	be 1c 00 00 00       	mov    $0x1c,%esi
  801e42:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801e49:	00 00 00 
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  801e58:	00 00 00 
  801e5b:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801e5d:	ba 07 00 00 00       	mov    $0x7,%edx
  801e62:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e67:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6c:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  801e73:	00 00 00 
  801e76:	ff d0                	callq  *%rax
  801e78:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e7f:	79 30                	jns    801eb1 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801e81:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e84:	89 c1                	mov    %eax,%ecx
  801e86:	48 ba f0 58 80 00 00 	movabs $0x8058f0,%rdx
  801e8d:	00 00 00 
  801e90:	be 26 00 00 00       	mov    $0x26,%esi
  801e95:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801e9c:	00 00 00 
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  801eab:	00 00 00 
  801eae:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ec3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ec8:	48 89 c6             	mov    %rax,%rsi
  801ecb:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ed0:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801edc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ee0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801ee4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801eee:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ef4:	48 89 c1             	mov    %rax,%rcx
  801ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  801efc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f01:	bf 00 00 00 00       	mov    $0x0,%edi
  801f06:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	callq  *%rax
  801f12:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f19:	79 30                	jns    801f4b <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801f1b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f1e:	89 c1                	mov    %eax,%ecx
  801f20:	48 ba 18 59 80 00 00 	movabs $0x805918,%rdx
  801f27:	00 00 00 
  801f2a:	be 2b 00 00 00       	mov    $0x2b,%esi
  801f2f:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801f36:	00 00 00 
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  801f45:	00 00 00 
  801f48:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801f4b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f50:	bf 00 00 00 00       	mov    $0x0,%edi
  801f55:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  801f5c:	00 00 00 
  801f5f:	ff d0                	callq  *%rax
  801f61:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f68:	79 30                	jns    801f9a <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801f6a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f6d:	89 c1                	mov    %eax,%ecx
  801f6f:	48 ba 40 59 80 00 00 	movabs $0x805940,%rdx
  801f76:	00 00 00 
  801f79:	be 2e 00 00 00       	mov    $0x2e,%esi
  801f7e:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  801f85:	00 00 00 
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  801f94:	00 00 00 
  801f97:	41 ff d0             	callq  *%r8
	
}
  801f9a:	c9                   	leaveq 
  801f9b:	c3                   	retq   

0000000000801f9c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801f9c:	55                   	push   %rbp
  801f9d:	48 89 e5             	mov    %rsp,%rbp
  801fa0:	48 83 ec 30          	sub    $0x30,%rsp
  801fa4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801fa7:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801faa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fb1:	01 00 00 
  801fb4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801fb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc3:	25 07 0e 00 00       	and    $0xe07,%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801fcb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801fce:	48 c1 e0 0c          	shl    $0xc,%rax
  801fd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801fd6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fd9:	25 00 04 00 00       	and    $0x400,%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	74 5c                	je     80203e <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801fe2:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801fe5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fe9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff0:	41 89 f0             	mov    %esi,%r8d
  801ff3:	48 89 c6             	mov    %rax,%rsi
  801ff6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffb:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
  802007:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  80200a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80200e:	0f 89 60 01 00 00    	jns    802174 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  802014:	48 ba 68 59 80 00 00 	movabs $0x805968,%rdx
  80201b:	00 00 00 
  80201e:	be 4d 00 00 00       	mov    $0x4d,%esi
  802023:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  80202a:	00 00 00 
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
  802032:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  802039:	00 00 00 
  80203c:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  80203e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802041:	83 e0 02             	and    $0x2,%eax
  802044:	85 c0                	test   %eax,%eax
  802046:	75 10                	jne    802058 <duppage+0xbc>
  802048:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80204b:	25 00 08 00 00       	and    $0x800,%eax
  802050:	85 c0                	test   %eax,%eax
  802052:	0f 84 c4 00 00 00    	je     80211c <duppage+0x180>
	{
		perm |= PTE_COW;
  802058:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  80205f:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  802063:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802066:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80206a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80206d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802071:	41 89 f0             	mov    %esi,%r8d
  802074:	48 89 c6             	mov    %rax,%rsi
  802077:	bf 00 00 00 00       	mov    $0x0,%edi
  80207c:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  802083:	00 00 00 
  802086:	ff d0                	callq  *%rax
  802088:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  80208b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80208f:	79 2a                	jns    8020bb <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802091:	48 ba 98 59 80 00 00 	movabs $0x805998,%rdx
  802098:	00 00 00 
  80209b:	be 56 00 00 00       	mov    $0x56,%esi
  8020a0:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  8020a7:	00 00 00 
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020af:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  8020b6:	00 00 00 
  8020b9:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  8020bb:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  8020be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8020c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c6:	41 89 c8             	mov    %ecx,%r8d
  8020c9:	48 89 d1             	mov    %rdx,%rcx
  8020cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d1:	48 89 c6             	mov    %rax,%rsi
  8020d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8020d9:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  8020e0:	00 00 00 
  8020e3:	ff d0                	callq  *%rax
  8020e5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8020e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020ec:	0f 89 82 00 00 00    	jns    802174 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  8020f2:	48 ba 98 59 80 00 00 	movabs $0x805998,%rdx
  8020f9:	00 00 00 
  8020fc:	be 59 00 00 00       	mov    $0x59,%esi
  802101:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  802108:	00 00 00 
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  802117:	00 00 00 
  80211a:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  80211c:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80211f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802123:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212a:	41 89 f0             	mov    %esi,%r8d
  80212d:	48 89 c6             	mov    %rax,%rsi
  802130:	bf 00 00 00 00       	mov    $0x0,%edi
  802135:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  80213c:	00 00 00 
  80213f:	ff d0                	callq  *%rax
  802141:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802144:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802148:	79 2a                	jns    802174 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  80214a:	48 ba d0 59 80 00 00 	movabs $0x8059d0,%rdx
  802151:	00 00 00 
  802154:	be 60 00 00 00       	mov    $0x60,%esi
  802159:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  802160:	00 00 00 
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  80216f:	00 00 00 
  802172:	ff d1                	callq  *%rcx
	}
	return 0;
  802174:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802179:	c9                   	leaveq 
  80217a:	c3                   	retq   

000000000080217b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80217b:	55                   	push   %rbp
  80217c:	48 89 e5             	mov    %rsp,%rbp
  80217f:	53                   	push   %rbx
  802180:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802184:	48 bf e4 1d 80 00 00 	movabs $0x801de4,%rdi
  80218b:	00 00 00 
  80218e:	48 b8 e8 4e 80 00 00 	movabs $0x804ee8,%rax
  802195:	00 00 00 
  802198:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80219a:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  8021a1:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8021a4:	cd 30                	int    $0x30
  8021a6:	89 c3                	mov    %eax,%ebx
  8021a8:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8021ab:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  8021ae:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  8021b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8021b5:	79 30                	jns    8021e7 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  8021b7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021ba:	89 c1                	mov    %eax,%ecx
  8021bc:	48 ba f4 59 80 00 00 	movabs $0x8059f4,%rdx
  8021c3:	00 00 00 
  8021c6:	be 7f 00 00 00       	mov    $0x7f,%esi
  8021cb:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  8021d2:	00 00 00 
  8021d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021da:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  8021e1:	00 00 00 
  8021e4:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  8021e7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8021eb:	75 4c                	jne    802239 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8021ed:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  8021f4:	00 00 00 
  8021f7:	ff d0                	callq  *%rax
  8021f9:	48 98                	cltq   
  8021fb:	48 89 c2             	mov    %rax,%rdx
  8021fe:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802204:	48 89 d0             	mov    %rdx,%rax
  802207:	48 c1 e0 03          	shl    $0x3,%rax
  80220b:	48 01 d0             	add    %rdx,%rax
  80220e:	48 c1 e0 05          	shl    $0x5,%rax
  802212:	48 89 c2             	mov    %rax,%rdx
  802215:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80221c:	00 00 00 
  80221f:	48 01 c2             	add    %rax,%rdx
  802222:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802229:	00 00 00 
  80222c:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	e9 38 02 00 00       	jmpq   802471 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802239:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80223c:	ba 07 00 00 00       	mov    $0x7,%edx
  802241:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802246:	89 c7                	mov    %eax,%edi
  802248:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
  802254:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802257:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80225b:	79 30                	jns    80228d <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  80225d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802260:	89 c1                	mov    %eax,%ecx
  802262:	48 ba 08 5a 80 00 00 	movabs $0x805a08,%rdx
  802269:	00 00 00 
  80226c:	be 8b 00 00 00       	mov    $0x8b,%esi
  802271:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  802278:	00 00 00 
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  802287:	00 00 00 
  80228a:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  80228d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802294:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80229b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8022a2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  8022a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8022b0:	e9 0a 01 00 00       	jmpq   8023bf <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8022b5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8022bc:	01 00 00 
  8022bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022c2:	48 63 d2             	movslq %edx,%rdx
  8022c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c9:	83 e0 01             	and    $0x1,%eax
  8022cc:	84 c0                	test   %al,%al
  8022ce:	0f 84 e7 00 00 00    	je     8023bb <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  8022d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  8022db:	e9 cf 00 00 00       	jmpq   8023af <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  8022e0:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8022e7:	01 00 00 
  8022ea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022ed:	48 63 d2             	movslq %edx,%rdx
  8022f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f4:	83 e0 01             	and    $0x1,%eax
  8022f7:	84 c0                	test   %al,%al
  8022f9:	0f 84 a0 00 00 00    	je     80239f <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8022ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802306:	e9 85 00 00 00       	jmpq   802390 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  80230b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802312:	01 00 00 
  802315:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802318:	48 63 d2             	movslq %edx,%rdx
  80231b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80231f:	83 e0 01             	and    $0x1,%eax
  802322:	84 c0                	test   %al,%al
  802324:	74 56                	je     80237c <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802326:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  80232d:	eb 42                	jmp    802371 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80232f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802336:	01 00 00 
  802339:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80233c:	48 63 d2             	movslq %edx,%rdx
  80233f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802343:	83 e0 01             	and    $0x1,%eax
  802346:	84 c0                	test   %al,%al
  802348:	74 1f                	je     802369 <fork+0x1ee>
  80234a:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  802351:	74 16                	je     802369 <fork+0x1ee>
									 duppage(envid,d1);
  802353:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802356:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802359:	89 d6                	mov    %edx,%esi
  80235b:	89 c7                	mov    %eax,%edi
  80235d:	48 b8 9c 1f 80 00 00 	movabs $0x801f9c,%rax
  802364:	00 00 00 
  802367:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802369:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  80236d:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  802371:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802378:	7e b5                	jle    80232f <fork+0x1b4>
  80237a:	eb 0c                	jmp    802388 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  80237c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80237f:	83 c0 01             	add    $0x1,%eax
  802382:	c1 e0 09             	shl    $0x9,%eax
  802385:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802388:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  80238c:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802390:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802397:	0f 8e 6e ff ff ff    	jle    80230b <fork+0x190>
  80239d:	eb 0c                	jmp    8023ab <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80239f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023a2:	83 c0 01             	add    $0x1,%eax
  8023a5:	c1 e0 09             	shl    $0x9,%eax
  8023a8:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  8023ab:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  8023af:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8023b2:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8023b5:	0f 8c 25 ff ff ff    	jl     8022e0 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8023bb:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8023bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023c2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8023c5:	0f 8c ea fe ff ff    	jl     8022b5 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8023cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8023ce:	48 be ac 4f 80 00 00 	movabs $0x804fac,%rsi
  8023d5:	00 00 00 
  8023d8:	89 c7                	mov    %eax,%edi
  8023da:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  8023e1:	00 00 00 
  8023e4:	ff d0                	callq  *%rax
  8023e6:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8023e9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8023ed:	79 30                	jns    80241f <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8023ef:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8023f2:	89 c1                	mov    %eax,%ecx
  8023f4:	48 ba 28 5a 80 00 00 	movabs $0x805a28,%rdx
  8023fb:	00 00 00 
  8023fe:	be ad 00 00 00       	mov    $0xad,%esi
  802403:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  80240a:	00 00 00 
  80240d:	b8 00 00 00 00       	mov    $0x0,%eax
  802412:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  802419:	00 00 00 
  80241c:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80241f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802422:	be 02 00 00 00       	mov    $0x2,%esi
  802427:	89 c7                	mov    %eax,%edi
  802429:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  802430:	00 00 00 
  802433:	ff d0                	callq  *%rax
  802435:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802438:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80243c:	79 30                	jns    80246e <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80243e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802441:	89 c1                	mov    %eax,%ecx
  802443:	48 ba 58 5a 80 00 00 	movabs $0x805a58,%rdx
  80244a:	00 00 00 
  80244d:	be b0 00 00 00       	mov    $0xb0,%esi
  802452:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  802459:	00 00 00 
  80245c:	b8 00 00 00 00       	mov    $0x0,%eax
  802461:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  802468:	00 00 00 
  80246b:	41 ff d0             	callq  *%r8
	return envid;
  80246e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802471:	48 83 c4 48          	add    $0x48,%rsp
  802475:	5b                   	pop    %rbx
  802476:	5d                   	pop    %rbp
  802477:	c3                   	retq   

0000000000802478 <sfork>:

// Challenge!
int
sfork(void)
{
  802478:	55                   	push   %rbp
  802479:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80247c:	48 ba 7c 5a 80 00 00 	movabs $0x805a7c,%rdx
  802483:	00 00 00 
  802486:	be b8 00 00 00       	mov    $0xb8,%esi
  80248b:	48 bf e5 58 80 00 00 	movabs $0x8058e5,%rdi
  802492:	00 00 00 
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  8024a1:	00 00 00 
  8024a4:	ff d1                	callq  *%rcx
	...

00000000008024a8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024a8:	55                   	push   %rbp
  8024a9:	48 89 e5             	mov    %rsp,%rbp
  8024ac:	48 83 ec 08          	sub    $0x8,%rsp
  8024b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024b8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024bf:	ff ff ff 
  8024c2:	48 01 d0             	add    %rdx,%rax
  8024c5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024c9:	c9                   	leaveq 
  8024ca:	c3                   	retq   

00000000008024cb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024cb:	55                   	push   %rbp
  8024cc:	48 89 e5             	mov    %rsp,%rbp
  8024cf:	48 83 ec 08          	sub    $0x8,%rsp
  8024d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024db:	48 89 c7             	mov    %rax,%rdi
  8024de:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  8024e5:	00 00 00 
  8024e8:	ff d0                	callq  *%rax
  8024ea:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024f0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024f4:	c9                   	leaveq 
  8024f5:	c3                   	retq   

00000000008024f6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024f6:	55                   	push   %rbp
  8024f7:	48 89 e5             	mov    %rsp,%rbp
  8024fa:	48 83 ec 18          	sub    $0x18,%rsp
  8024fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802502:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802509:	eb 6b                	jmp    802576 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80250b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250e:	48 98                	cltq   
  802510:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802516:	48 c1 e0 0c          	shl    $0xc,%rax
  80251a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80251e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802522:	48 89 c2             	mov    %rax,%rdx
  802525:	48 c1 ea 15          	shr    $0x15,%rdx
  802529:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802530:	01 00 00 
  802533:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802537:	83 e0 01             	and    $0x1,%eax
  80253a:	48 85 c0             	test   %rax,%rax
  80253d:	74 21                	je     802560 <fd_alloc+0x6a>
  80253f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802543:	48 89 c2             	mov    %rax,%rdx
  802546:	48 c1 ea 0c          	shr    $0xc,%rdx
  80254a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802551:	01 00 00 
  802554:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802558:	83 e0 01             	and    $0x1,%eax
  80255b:	48 85 c0             	test   %rax,%rax
  80255e:	75 12                	jne    802572 <fd_alloc+0x7c>
			*fd_store = fd;
  802560:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802564:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802568:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
  802570:	eb 1a                	jmp    80258c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802572:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802576:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80257a:	7e 8f                	jle    80250b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80257c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802580:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802587:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80258c:	c9                   	leaveq 
  80258d:	c3                   	retq   

000000000080258e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80258e:	55                   	push   %rbp
  80258f:	48 89 e5             	mov    %rsp,%rbp
  802592:	48 83 ec 20          	sub    $0x20,%rsp
  802596:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802599:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80259d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025a1:	78 06                	js     8025a9 <fd_lookup+0x1b>
  8025a3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025a7:	7e 07                	jle    8025b0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ae:	eb 6c                	jmp    80261c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b3:	48 98                	cltq   
  8025b5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025bb:	48 c1 e0 0c          	shl    $0xc,%rax
  8025bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c7:	48 89 c2             	mov    %rax,%rdx
  8025ca:	48 c1 ea 15          	shr    $0x15,%rdx
  8025ce:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025d5:	01 00 00 
  8025d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025dc:	83 e0 01             	and    $0x1,%eax
  8025df:	48 85 c0             	test   %rax,%rax
  8025e2:	74 21                	je     802605 <fd_lookup+0x77>
  8025e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025e8:	48 89 c2             	mov    %rax,%rdx
  8025eb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025ef:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025f6:	01 00 00 
  8025f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025fd:	83 e0 01             	and    $0x1,%eax
  802600:	48 85 c0             	test   %rax,%rax
  802603:	75 07                	jne    80260c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802605:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80260a:	eb 10                	jmp    80261c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80260c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802610:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802614:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261c:	c9                   	leaveq 
  80261d:	c3                   	retq   

000000000080261e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 30          	sub    $0x30,%rsp
  802626:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80262a:	89 f0                	mov    %esi,%eax
  80262c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80262f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802633:	48 89 c7             	mov    %rax,%rdi
  802636:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  80263d:	00 00 00 
  802640:	ff d0                	callq  *%rax
  802642:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802646:	48 89 d6             	mov    %rdx,%rsi
  802649:	89 c7                	mov    %eax,%edi
  80264b:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802652:	00 00 00 
  802655:	ff d0                	callq  *%rax
  802657:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265e:	78 0a                	js     80266a <fd_close+0x4c>
	    || fd != fd2)
  802660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802664:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802668:	74 12                	je     80267c <fd_close+0x5e>
		return (must_exist ? r : 0);
  80266a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80266e:	74 05                	je     802675 <fd_close+0x57>
  802670:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802673:	eb 05                	jmp    80267a <fd_close+0x5c>
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
  80267a:	eb 69                	jmp    8026e5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80267c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802680:	8b 00                	mov    (%rax),%eax
  802682:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269e:	78 2a                	js     8026ca <fd_close+0xac>
		if (dev->dev_close)
  8026a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a4:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026a8:	48 85 c0             	test   %rax,%rax
  8026ab:	74 16                	je     8026c3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b1:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8026b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026b9:	48 89 c7             	mov    %rax,%rdi
  8026bc:	ff d2                	callq  *%rdx
  8026be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c1:	eb 07                	jmp    8026ca <fd_close+0xac>
		else
			r = 0;
  8026c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026ce:	48 89 c6             	mov    %rax,%rsi
  8026d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8026d6:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
	return r;
  8026e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026e5:	c9                   	leaveq 
  8026e6:	c3                   	retq   

00000000008026e7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026e7:	55                   	push   %rbp
  8026e8:	48 89 e5             	mov    %rsp,%rbp
  8026eb:	48 83 ec 20          	sub    $0x20,%rsp
  8026ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026fd:	eb 41                	jmp    802740 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026ff:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802706:	00 00 00 
  802709:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80270c:	48 63 d2             	movslq %edx,%rdx
  80270f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802713:	8b 00                	mov    (%rax),%eax
  802715:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802718:	75 22                	jne    80273c <dev_lookup+0x55>
			*dev = devtab[i];
  80271a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802721:	00 00 00 
  802724:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802727:	48 63 d2             	movslq %edx,%rdx
  80272a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80272e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802732:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	eb 60                	jmp    80279c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80273c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802740:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802747:	00 00 00 
  80274a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80274d:	48 63 d2             	movslq %edx,%rdx
  802750:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802754:	48 85 c0             	test   %rax,%rax
  802757:	75 a6                	jne    8026ff <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802759:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802760:	00 00 00 
  802763:	48 8b 00             	mov    (%rax),%rax
  802766:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80276c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80276f:	89 c6                	mov    %eax,%esi
  802771:	48 bf 98 5a 80 00 00 	movabs $0x805a98,%rdi
  802778:	00 00 00 
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	48 b9 af 05 80 00 00 	movabs $0x8005af,%rcx
  802787:	00 00 00 
  80278a:	ff d1                	callq  *%rcx
	*dev = 0;
  80278c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802790:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802797:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80279c:	c9                   	leaveq 
  80279d:	c3                   	retq   

000000000080279e <close>:

int
close(int fdnum)
{
  80279e:	55                   	push   %rbp
  80279f:	48 89 e5             	mov    %rsp,%rbp
  8027a2:	48 83 ec 20          	sub    $0x20,%rsp
  8027a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027b0:	48 89 d6             	mov    %rdx,%rsi
  8027b3:	89 c7                	mov    %eax,%edi
  8027b5:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  8027bc:	00 00 00 
  8027bf:	ff d0                	callq  *%rax
  8027c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c8:	79 05                	jns    8027cf <close+0x31>
		return r;
  8027ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027cd:	eb 18                	jmp    8027e7 <close+0x49>
	else
		return fd_close(fd, 1);
  8027cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d3:	be 01 00 00 00       	mov    $0x1,%esi
  8027d8:	48 89 c7             	mov    %rax,%rdi
  8027db:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  8027e2:	00 00 00 
  8027e5:	ff d0                	callq  *%rax
}
  8027e7:	c9                   	leaveq 
  8027e8:	c3                   	retq   

00000000008027e9 <close_all>:

void
close_all(void)
{
  8027e9:	55                   	push   %rbp
  8027ea:	48 89 e5             	mov    %rsp,%rbp
  8027ed:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027f8:	eb 15                	jmp    80280f <close_all+0x26>
		close(i);
  8027fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fd:	89 c7                	mov    %eax,%edi
  8027ff:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  802806:	00 00 00 
  802809:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80280b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80280f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802813:	7e e5                	jle    8027fa <close_all+0x11>
		close(i);
}
  802815:	c9                   	leaveq 
  802816:	c3                   	retq   

0000000000802817 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802817:	55                   	push   %rbp
  802818:	48 89 e5             	mov    %rsp,%rbp
  80281b:	48 83 ec 40          	sub    $0x40,%rsp
  80281f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802822:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802825:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802829:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80282c:	48 89 d6             	mov    %rdx,%rsi
  80282f:	89 c7                	mov    %eax,%edi
  802831:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802838:	00 00 00 
  80283b:	ff d0                	callq  *%rax
  80283d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802844:	79 08                	jns    80284e <dup+0x37>
		return r;
  802846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802849:	e9 70 01 00 00       	jmpq   8029be <dup+0x1a7>
	close(newfdnum);
  80284e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802851:	89 c7                	mov    %eax,%edi
  802853:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80285f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802862:	48 98                	cltq   
  802864:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80286a:	48 c1 e0 0c          	shl    $0xc,%rax
  80286e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802872:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802876:	48 89 c7             	mov    %rax,%rdi
  802879:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802889:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288d:	48 89 c7             	mov    %rax,%rdi
  802890:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  802897:	00 00 00 
  80289a:	ff d0                	callq  *%rax
  80289c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a4:	48 89 c2             	mov    %rax,%rdx
  8028a7:	48 c1 ea 15          	shr    $0x15,%rdx
  8028ab:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028b2:	01 00 00 
  8028b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028b9:	83 e0 01             	and    $0x1,%eax
  8028bc:	84 c0                	test   %al,%al
  8028be:	74 71                	je     802931 <dup+0x11a>
  8028c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c4:	48 89 c2             	mov    %rax,%rdx
  8028c7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d2:	01 00 00 
  8028d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d9:	83 e0 01             	and    $0x1,%eax
  8028dc:	84 c0                	test   %al,%al
  8028de:	74 51                	je     802931 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e4:	48 89 c2             	mov    %rax,%rdx
  8028e7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028f2:	01 00 00 
  8028f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f9:	89 c1                	mov    %eax,%ecx
  8028fb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802901:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802909:	41 89 c8             	mov    %ecx,%r8d
  80290c:	48 89 d1             	mov    %rdx,%rcx
  80290f:	ba 00 00 00 00       	mov    $0x0,%edx
  802914:	48 89 c6             	mov    %rax,%rsi
  802917:	bf 00 00 00 00       	mov    $0x0,%edi
  80291c:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
  802928:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292f:	78 56                	js     802987 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802935:	48 89 c2             	mov    %rax,%rdx
  802938:	48 c1 ea 0c          	shr    $0xc,%rdx
  80293c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802943:	01 00 00 
  802946:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294a:	89 c1                	mov    %eax,%ecx
  80294c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802956:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80295a:	41 89 c8             	mov    %ecx,%r8d
  80295d:	48 89 d1             	mov    %rdx,%rcx
  802960:	ba 00 00 00 00       	mov    $0x0,%edx
  802965:	48 89 c6             	mov    %rax,%rsi
  802968:	bf 00 00 00 00       	mov    $0x0,%edi
  80296d:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802980:	78 08                	js     80298a <dup+0x173>
		goto err;

	return newfdnum;
  802982:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802985:	eb 37                	jmp    8029be <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802987:	90                   	nop
  802988:	eb 01                	jmp    80298b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80298a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	48 89 c6             	mov    %rax,%rsi
  802992:	bf 00 00 00 00       	mov    $0x0,%edi
  802997:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029a7:	48 89 c6             	mov    %rax,%rsi
  8029aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8029af:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8029b6:	00 00 00 
  8029b9:	ff d0                	callq  *%rax
	return r;
  8029bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029be:	c9                   	leaveq 
  8029bf:	c3                   	retq   

00000000008029c0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029c0:	55                   	push   %rbp
  8029c1:	48 89 e5             	mov    %rsp,%rbp
  8029c4:	48 83 ec 40          	sub    $0x40,%rsp
  8029c8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029d3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029d7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029da:	48 89 d6             	mov    %rdx,%rsi
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
  8029eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f2:	78 24                	js     802a18 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f8:	8b 00                	mov    (%rax),%eax
  8029fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029fe:	48 89 d6             	mov    %rdx,%rsi
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a16:	79 05                	jns    802a1d <read+0x5d>
		return r;
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	eb 7a                	jmp    802a97 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a21:	8b 40 08             	mov    0x8(%rax),%eax
  802a24:	83 e0 03             	and    $0x3,%eax
  802a27:	83 f8 01             	cmp    $0x1,%eax
  802a2a:	75 3a                	jne    802a66 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a2c:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802a33:	00 00 00 
  802a36:	48 8b 00             	mov    (%rax),%rax
  802a39:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a3f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a42:	89 c6                	mov    %eax,%esi
  802a44:	48 bf b7 5a 80 00 00 	movabs $0x805ab7,%rdi
  802a4b:	00 00 00 
  802a4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a53:	48 b9 af 05 80 00 00 	movabs $0x8005af,%rcx
  802a5a:	00 00 00 
  802a5d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a64:	eb 31                	jmp    802a97 <read+0xd7>
	}
	if (!dev->dev_read)
  802a66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6a:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a6e:	48 85 c0             	test   %rax,%rax
  802a71:	75 07                	jne    802a7a <read+0xba>
		return -E_NOT_SUPP;
  802a73:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a78:	eb 1d                	jmp    802a97 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802a7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a8a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a8e:	48 89 ce             	mov    %rcx,%rsi
  802a91:	48 89 c7             	mov    %rax,%rdi
  802a94:	41 ff d0             	callq  *%r8
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	48 83 ec 30          	sub    $0x30,%rsp
  802aa1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aa4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802aa8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802aac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ab3:	eb 46                	jmp    802afb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	48 98                	cltq   
  802aba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802abe:	48 29 c2             	sub    %rax,%rdx
  802ac1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac4:	48 98                	cltq   
  802ac6:	48 89 c1             	mov    %rax,%rcx
  802ac9:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802acd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ad0:	48 89 ce             	mov    %rcx,%rsi
  802ad3:	89 c7                	mov    %eax,%edi
  802ad5:	48 b8 c0 29 80 00 00 	movabs $0x8029c0,%rax
  802adc:	00 00 00 
  802adf:	ff d0                	callq  *%rax
  802ae1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ae4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ae8:	79 05                	jns    802aef <readn+0x56>
			return m;
  802aea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aed:	eb 1d                	jmp    802b0c <readn+0x73>
		if (m == 0)
  802aef:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802af3:	74 13                	je     802b08 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802af5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802af8:	01 45 fc             	add    %eax,-0x4(%rbp)
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afe:	48 98                	cltq   
  802b00:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b04:	72 af                	jb     802ab5 <readn+0x1c>
  802b06:	eb 01                	jmp    802b09 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b08:	90                   	nop
	}
	return tot;
  802b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b0c:	c9                   	leaveq 
  802b0d:	c3                   	retq   

0000000000802b0e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b0e:	55                   	push   %rbp
  802b0f:	48 89 e5             	mov    %rsp,%rbp
  802b12:	48 83 ec 40          	sub    $0x40,%rsp
  802b16:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b19:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b1d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b21:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b25:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b28:	48 89 d6             	mov    %rdx,%rsi
  802b2b:	89 c7                	mov    %eax,%edi
  802b2d:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
  802b39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b40:	78 24                	js     802b66 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b46:	8b 00                	mov    (%rax),%eax
  802b48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b4c:	48 89 d6             	mov    %rdx,%rsi
  802b4f:	89 c7                	mov    %eax,%edi
  802b51:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
  802b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b64:	79 05                	jns    802b6b <write+0x5d>
		return r;
  802b66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b69:	eb 79                	jmp    802be4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6f:	8b 40 08             	mov    0x8(%rax),%eax
  802b72:	83 e0 03             	and    $0x3,%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	75 3a                	jne    802bb3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b79:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802b80:	00 00 00 
  802b83:	48 8b 00             	mov    (%rax),%rax
  802b86:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b8c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b8f:	89 c6                	mov    %eax,%esi
  802b91:	48 bf d3 5a 80 00 00 	movabs $0x805ad3,%rdi
  802b98:	00 00 00 
  802b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba0:	48 b9 af 05 80 00 00 	movabs $0x8005af,%rcx
  802ba7:	00 00 00 
  802baa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bb1:	eb 31                	jmp    802be4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bbb:	48 85 c0             	test   %rax,%rax
  802bbe:	75 07                	jne    802bc7 <write+0xb9>
		return -E_NOT_SUPP;
  802bc0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bc5:	eb 1d                	jmp    802be4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcb:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bd7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bdb:	48 89 ce             	mov    %rcx,%rsi
  802bde:	48 89 c7             	mov    %rax,%rdi
  802be1:	41 ff d0             	callq  *%r8
}
  802be4:	c9                   	leaveq 
  802be5:	c3                   	retq   

0000000000802be6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802be6:	55                   	push   %rbp
  802be7:	48 89 e5             	mov    %rsp,%rbp
  802bea:	48 83 ec 18          	sub    $0x18,%rsp
  802bee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bf1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bf4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bfb:	48 89 d6             	mov    %rdx,%rsi
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
  802c0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c13:	79 05                	jns    802c1a <seek+0x34>
		return r;
  802c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c18:	eb 0f                	jmp    802c29 <seek+0x43>
	fd->fd_offset = offset;
  802c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c21:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c29:	c9                   	leaveq 
  802c2a:	c3                   	retq   

0000000000802c2b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c2b:	55                   	push   %rbp
  802c2c:	48 89 e5             	mov    %rsp,%rbp
  802c2f:	48 83 ec 30          	sub    $0x30,%rsp
  802c33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c36:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c39:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c3d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c40:	48 89 d6             	mov    %rdx,%rsi
  802c43:	89 c7                	mov    %eax,%edi
  802c45:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c58:	78 24                	js     802c7e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5e:	8b 00                	mov    (%rax),%eax
  802c60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c64:	48 89 d6             	mov    %rdx,%rsi
  802c67:	89 c7                	mov    %eax,%edi
  802c69:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
  802c75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c7c:	79 05                	jns    802c83 <ftruncate+0x58>
		return r;
  802c7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c81:	eb 72                	jmp    802cf5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c87:	8b 40 08             	mov    0x8(%rax),%eax
  802c8a:	83 e0 03             	and    $0x3,%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	75 3a                	jne    802ccb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c91:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  802c98:	00 00 00 
  802c9b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c9e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ca4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ca7:	89 c6                	mov    %eax,%esi
  802ca9:	48 bf f0 5a 80 00 00 	movabs $0x805af0,%rdi
  802cb0:	00 00 00 
  802cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb8:	48 b9 af 05 80 00 00 	movabs $0x8005af,%rcx
  802cbf:	00 00 00 
  802cc2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cc9:	eb 2a                	jmp    802cf5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cd3:	48 85 c0             	test   %rax,%rax
  802cd6:	75 07                	jne    802cdf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cd8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cdd:	eb 16                	jmp    802cf5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802ce7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ceb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802cee:	89 d6                	mov    %edx,%esi
  802cf0:	48 89 c7             	mov    %rax,%rdi
  802cf3:	ff d1                	callq  *%rcx
}
  802cf5:	c9                   	leaveq 
  802cf6:	c3                   	retq   

0000000000802cf7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802cf7:	55                   	push   %rbp
  802cf8:	48 89 e5             	mov    %rsp,%rbp
  802cfb:	48 83 ec 30          	sub    $0x30,%rsp
  802cff:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d02:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d0d:	48 89 d6             	mov    %rdx,%rsi
  802d10:	89 c7                	mov    %eax,%edi
  802d12:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	callq  *%rax
  802d1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d25:	78 24                	js     802d4b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2b:	8b 00                	mov    (%rax),%eax
  802d2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d31:	48 89 d6             	mov    %rdx,%rsi
  802d34:	89 c7                	mov    %eax,%edi
  802d36:	48 b8 e7 26 80 00 00 	movabs $0x8026e7,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d49:	79 05                	jns    802d50 <fstat+0x59>
		return r;
  802d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4e:	eb 5e                	jmp    802dae <fstat+0xb7>
	if (!dev->dev_stat)
  802d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d54:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d58:	48 85 c0             	test   %rax,%rax
  802d5b:	75 07                	jne    802d64 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d5d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d62:	eb 4a                	jmp    802dae <fstat+0xb7>
	stat->st_name[0] = 0;
  802d64:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d68:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d6f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d76:	00 00 00 
	stat->st_isdir = 0;
  802d79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d84:	00 00 00 
	stat->st_dev = dev;
  802d87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d8f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802d9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802da6:	48 89 d6             	mov    %rdx,%rsi
  802da9:	48 89 c7             	mov    %rax,%rdi
  802dac:	ff d1                	callq  *%rcx
}
  802dae:	c9                   	leaveq 
  802daf:	c3                   	retq   

0000000000802db0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802db0:	55                   	push   %rbp
  802db1:	48 89 e5             	mov    %rsp,%rbp
  802db4:	48 83 ec 20          	sub    $0x20,%rsp
  802db8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc4:	be 00 00 00 00       	mov    $0x0,%esi
  802dc9:	48 89 c7             	mov    %rax,%rdi
  802dcc:	48 b8 9f 2e 80 00 00 	movabs $0x802e9f,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
  802dd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ddb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ddf:	79 05                	jns    802de6 <stat+0x36>
		return fd;
  802de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de4:	eb 2f                	jmp    802e15 <stat+0x65>
	r = fstat(fd, stat);
  802de6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ded:	48 89 d6             	mov    %rdx,%rsi
  802df0:	89 c7                	mov    %eax,%edi
  802df2:	48 b8 f7 2c 80 00 00 	movabs $0x802cf7,%rax
  802df9:	00 00 00 
  802dfc:	ff d0                	callq  *%rax
  802dfe:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	89 c7                	mov    %eax,%edi
  802e06:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  802e0d:	00 00 00 
  802e10:	ff d0                	callq  *%rax
	return r;
  802e12:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   
	...

0000000000802e18 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e18:	55                   	push   %rbp
  802e19:	48 89 e5             	mov    %rsp,%rbp
  802e1c:	48 83 ec 10          	sub    $0x10,%rsp
  802e20:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e27:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  802e2e:	00 00 00 
  802e31:	8b 00                	mov    (%rax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	75 1d                	jne    802e54 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e37:	bf 01 00 00 00       	mov    $0x1,%edi
  802e3c:	48 b8 bb 51 80 00 00 	movabs $0x8051bb,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
  802e48:	48 ba 24 80 80 00 00 	movabs $0x808024,%rdx
  802e4f:	00 00 00 
  802e52:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e54:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  802e5b:	00 00 00 
  802e5e:	8b 00                	mov    (%rax),%eax
  802e60:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e63:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e68:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e6f:	00 00 00 
  802e72:	89 c7                	mov    %eax,%edi
  802e74:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802e7b:	00 00 00 
  802e7e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e84:	ba 00 00 00 00       	mov    $0x0,%edx
  802e89:	48 89 c6             	mov    %rax,%rsi
  802e8c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e91:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
}
  802e9d:	c9                   	leaveq 
  802e9e:	c3                   	retq   

0000000000802e9f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e9f:	55                   	push   %rbp
  802ea0:	48 89 e5             	mov    %rsp,%rbp
  802ea3:	48 83 ec 20          	sub    $0x20,%rsp
  802ea7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eab:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	48 89 c7             	mov    %rax,%rdi
  802eb5:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802ebc:	00 00 00 
  802ebf:	ff d0                	callq  *%rax
  802ec1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ec6:	7e 0a                	jle    802ed2 <open+0x33>
                return -E_BAD_PATH;
  802ec8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ecd:	e9 a5 00 00 00       	jmpq   802f77 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802ed2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ed6:	48 89 c7             	mov    %rax,%rdi
  802ed9:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
  802ee5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ee8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eec:	79 08                	jns    802ef6 <open+0x57>
		return r;
  802eee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef1:	e9 81 00 00 00       	jmpq   802f77 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efa:	48 89 c6             	mov    %rax,%rsi
  802efd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f04:	00 00 00 
  802f07:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  802f0e:	00 00 00 
  802f11:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802f13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f1a:	00 00 00 
  802f1d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f20:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802f26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2a:	48 89 c6             	mov    %rax,%rsi
  802f2d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f32:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  802f39:	00 00 00 
  802f3c:	ff d0                	callq  *%rax
  802f3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802f41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f45:	79 1d                	jns    802f64 <open+0xc5>
	{
		fd_close(fd,0);
  802f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4b:	be 00 00 00 00       	mov    $0x0,%esi
  802f50:	48 89 c7             	mov    %rax,%rdi
  802f53:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
		return r;
  802f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f62:	eb 13                	jmp    802f77 <open+0xd8>
	}
	return fd2num(fd);
  802f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
	


}
  802f77:	c9                   	leaveq 
  802f78:	c3                   	retq   

0000000000802f79 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f79:	55                   	push   %rbp
  802f7a:	48 89 e5             	mov    %rsp,%rbp
  802f7d:	48 83 ec 10          	sub    $0x10,%rsp
  802f81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f89:	8b 50 0c             	mov    0xc(%rax),%edx
  802f8c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f93:	00 00 00 
  802f96:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f98:	be 00 00 00 00       	mov    $0x0,%esi
  802f9d:	bf 06 00 00 00       	mov    $0x6,%edi
  802fa2:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
}
  802fae:	c9                   	leaveq 
  802faf:	c3                   	retq   

0000000000802fb0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fb0:	55                   	push   %rbp
  802fb1:	48 89 e5             	mov    %rsp,%rbp
  802fb4:	48 83 ec 30          	sub    $0x30,%rsp
  802fb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc8:	8b 50 0c             	mov    0xc(%rax),%edx
  802fcb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fd2:	00 00 00 
  802fd5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fd7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fde:	00 00 00 
  802fe1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fe5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fe9:	be 00 00 00 00       	mov    $0x0,%esi
  802fee:	bf 03 00 00 00       	mov    $0x3,%edi
  802ff3:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803002:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803006:	79 05                	jns    80300d <devfile_read+0x5d>
	{
		return r;
  803008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80300b:	eb 2c                	jmp    803039 <devfile_read+0x89>
	}
	if(r > 0)
  80300d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803011:	7e 23                	jle    803036 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803013:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803016:	48 63 d0             	movslq %eax,%rdx
  803019:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80301d:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803024:	00 00 00 
  803027:	48 89 c7             	mov    %rax,%rdi
  80302a:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
	return r;
  803036:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 30          	sub    $0x30,%rsp
  803043:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803047:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80304b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80304f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803053:	8b 50 0c             	mov    0xc(%rax),%edx
  803056:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80305d:	00 00 00 
  803060:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803062:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  803069:	00 
  80306a:	76 08                	jbe    803074 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80306c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803073:	00 
	fsipcbuf.write.req_n=n;
  803074:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80307b:	00 00 00 
  80307e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803082:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803086:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80308a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308e:	48 89 c6             	mov    %rax,%rsi
  803091:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803098:	00 00 00 
  80309b:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  8030a2:	00 00 00 
  8030a5:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8030a7:	be 00 00 00 00       	mov    $0x0,%esi
  8030ac:	bf 04 00 00 00       	mov    $0x4,%edi
  8030b1:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  8030b8:	00 00 00 
  8030bb:	ff d0                	callq  *%rax
  8030bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8030c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030c3:	c9                   	leaveq 
  8030c4:	c3                   	retq   

00000000008030c5 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8030c5:	55                   	push   %rbp
  8030c6:	48 89 e5             	mov    %rsp,%rbp
  8030c9:	48 83 ec 10          	sub    $0x10,%rsp
  8030cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030d1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8030d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8030db:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030e2:	00 00 00 
  8030e5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8030e7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ee:	00 00 00 
  8030f1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030f4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8030f7:	be 00 00 00 00       	mov    $0x0,%esi
  8030fc:	bf 02 00 00 00       	mov    $0x2,%edi
  803101:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
  803113:	48 83 ec 20          	sub    $0x20,%rsp
  803117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80311b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80311f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803123:	8b 50 0c             	mov    0xc(%rax),%edx
  803126:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80312d:	00 00 00 
  803130:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803132:	be 00 00 00 00       	mov    $0x0,%esi
  803137:	bf 05 00 00 00       	mov    $0x5,%edi
  80313c:	48 b8 18 2e 80 00 00 	movabs $0x802e18,%rax
  803143:	00 00 00 
  803146:	ff d0                	callq  *%rax
  803148:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80314b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314f:	79 05                	jns    803156 <devfile_stat+0x47>
		return r;
  803151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803154:	eb 56                	jmp    8031ac <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803156:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803161:	00 00 00 
  803164:	48 89 c7             	mov    %rax,%rdi
  803167:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803173:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80317a:	00 00 00 
  80317d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803183:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803187:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80318d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803194:	00 00 00 
  803197:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80319d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031a1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ac:	c9                   	leaveq 
  8031ad:	c3                   	retq   
	...

00000000008031b0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	53                   	push   %rbx
  8031b5:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  8031bc:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  8031c3:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8031ca:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  8031d1:	be 00 00 00 00       	mov    $0x0,%esi
  8031d6:	48 89 c7             	mov    %rax,%rdi
  8031d9:	48 b8 9f 2e 80 00 00 	movabs $0x802e9f,%rax
  8031e0:	00 00 00 
  8031e3:	ff d0                	callq  *%rax
  8031e5:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8031e8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8031ec:	79 08                	jns    8031f6 <spawn+0x46>
		return r;
  8031ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031f1:	e9 1d 03 00 00       	jmpq   803513 <spawn+0x363>
	fd = r;
  8031f6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031f9:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031fc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  803203:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803207:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  80320e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803211:	ba 00 02 00 00       	mov    $0x200,%edx
  803216:	48 89 ce             	mov    %rcx,%rsi
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
  803227:	3d 00 02 00 00       	cmp    $0x200,%eax
  80322c:	75 0d                	jne    80323b <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  80322e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803232:	8b 00                	mov    (%rax),%eax
  803234:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803239:	74 43                	je     80327e <spawn+0xce>
		close(fd);
  80323b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80323e:	89 c7                	mov    %eax,%edi
  803240:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80324c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803250:	8b 00                	mov    (%rax),%eax
  803252:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803257:	89 c6                	mov    %eax,%esi
  803259:	48 bf 18 5b 80 00 00 	movabs $0x805b18,%rdi
  803260:	00 00 00 
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	48 b9 af 05 80 00 00 	movabs $0x8005af,%rcx
  80326f:	00 00 00 
  803272:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803274:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803279:	e9 95 02 00 00       	jmpq   803513 <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80327e:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  803285:	00 00 00 
  803288:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  80328e:	cd 30                	int    $0x30
  803290:	89 c3                	mov    %eax,%ebx
  803292:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803295:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803298:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80329b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80329f:	79 08                	jns    8032a9 <spawn+0xf9>
		return r;
  8032a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8032a4:	e9 6a 02 00 00       	jmpq   803513 <spawn+0x363>
	child = r;
  8032a9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8032ac:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8032af:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8032b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8032b7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8032be:	00 00 00 
  8032c1:	48 63 d0             	movslq %eax,%rdx
  8032c4:	48 89 d0             	mov    %rdx,%rax
  8032c7:	48 c1 e0 03          	shl    $0x3,%rax
  8032cb:	48 01 d0             	add    %rdx,%rax
  8032ce:	48 c1 e0 05          	shl    $0x5,%rax
  8032d2:	48 01 c8             	add    %rcx,%rax
  8032d5:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8032dc:	48 89 c6             	mov    %rax,%rsi
  8032df:	b8 18 00 00 00       	mov    $0x18,%eax
  8032e4:	48 89 d7             	mov    %rdx,%rdi
  8032e7:	48 89 c1             	mov    %rax,%rcx
  8032ea:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032f1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032f5:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032fc:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  803303:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  80330a:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  803311:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803314:	48 89 ce             	mov    %rcx,%rsi
  803317:	89 c7                	mov    %eax,%edi
  803319:	48 b8 6b 37 80 00 00 	movabs $0x80376b,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803328:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80332c:	79 08                	jns    803336 <spawn+0x186>
		return r;
  80332e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803331:	e9 dd 01 00 00       	jmpq   803513 <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803336:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80333a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80333e:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  803345:	48 01 d0             	add    %rdx,%rax
  803348:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80334c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  803353:	eb 7a                	jmp    8033cf <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  803355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803359:	8b 00                	mov    (%rax),%eax
  80335b:	83 f8 01             	cmp    $0x1,%eax
  80335e:	75 65                	jne    8033c5 <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  803360:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80336b:	8b 40 04             	mov    0x4(%rax),%eax
  80336e:	83 e0 02             	and    $0x2,%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 04                	je     803379 <spawn+0x1c9>
			perm |= PTE_W;
  803375:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803379:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337d:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803381:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803388:	4c 8b 40 20          	mov    0x20(%rax),%r8
  80338c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803390:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803398:	48 8b 70 10          	mov    0x10(%rax),%rsi
  80339c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80339f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8033a2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8033a5:	89 3c 24             	mov    %edi,(%rsp)
  8033a8:	89 c7                	mov    %eax,%edi
  8033aa:	48 b8 db 39 80 00 00 	movabs $0x8039db,%rax
  8033b1:	00 00 00 
  8033b4:	ff d0                	callq  *%rax
  8033b6:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8033b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8033bd:	0f 88 2a 01 00 00    	js     8034ed <spawn+0x33d>
  8033c3:	eb 01                	jmp    8033c6 <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  8033c5:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033c6:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8033ca:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  8033cf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033d3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033d7:	0f b7 c0             	movzwl %ax,%eax
  8033da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8033dd:	0f 8f 72 ff ff ff    	jg     803355 <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033e3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
	fd = -1;
  8033f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033fb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 c2 3b 80 00 00 	movabs $0x803bc2,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
  80340c:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80340f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803413:	79 30                	jns    803445 <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  803415:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803418:	89 c1                	mov    %eax,%ecx
  80341a:	48 ba 32 5b 80 00 00 	movabs $0x805b32,%rdx
  803421:	00 00 00 
  803424:	be 82 00 00 00       	mov    $0x82,%esi
  803429:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  803430:	00 00 00 
  803433:	b8 00 00 00 00       	mov    $0x0,%eax
  803438:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  80343f:	00 00 00 
  803442:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803445:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  80344c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80344f:	48 89 d6             	mov    %rdx,%rsi
  803452:	89 c7                	mov    %eax,%edi
  803454:	48 b8 e4 1b 80 00 00 	movabs $0x801be4,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
  803460:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803463:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803467:	79 30                	jns    803499 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  803469:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80346c:	89 c1                	mov    %eax,%ecx
  80346e:	48 ba 54 5b 80 00 00 	movabs $0x805b54,%rdx
  803475:	00 00 00 
  803478:	be 85 00 00 00       	mov    $0x85,%esi
  80347d:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  803484:	00 00 00 
  803487:	b8 00 00 00 00       	mov    $0x0,%eax
  80348c:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  803493:	00 00 00 
  803496:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803499:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80349c:	be 02 00 00 00       	mov    $0x2,%esi
  8034a1:	89 c7                	mov    %eax,%edi
  8034a3:	48 b8 99 1b 80 00 00 	movabs $0x801b99,%rax
  8034aa:	00 00 00 
  8034ad:	ff d0                	callq  *%rax
  8034af:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8034b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8034b6:	79 30                	jns    8034e8 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  8034b8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8034bb:	89 c1                	mov    %eax,%ecx
  8034bd:	48 ba 6e 5b 80 00 00 	movabs $0x805b6e,%rdx
  8034c4:	00 00 00 
  8034c7:	be 88 00 00 00       	mov    $0x88,%esi
  8034cc:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  8034d3:	00 00 00 
  8034d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034db:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  8034e2:	00 00 00 
  8034e5:	41 ff d0             	callq  *%r8

	return child;
  8034e8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8034eb:	eb 26                	jmp    803513 <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  8034ed:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8034ee:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8034f1:	89 c7                	mov    %eax,%edi
  8034f3:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  8034fa:	00 00 00 
  8034fd:	ff d0                	callq  *%rax
	close(fd);
  8034ff:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803502:	89 c7                	mov    %eax,%edi
  803504:	48 b8 9e 27 80 00 00 	movabs $0x80279e,%rax
  80350b:	00 00 00 
  80350e:	ff d0                	callq  *%rax
	return r;
  803510:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  803513:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  80351a:	5b                   	pop    %rbx
  80351b:	5d                   	pop    %rbp
  80351c:	c3                   	retq   

000000000080351d <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  80351d:	55                   	push   %rbp
  80351e:	48 89 e5             	mov    %rsp,%rbp
  803521:	53                   	push   %rbx
  803522:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  803529:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803530:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  803537:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80353e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803545:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80354c:	84 c0                	test   %al,%al
  80354e:	74 23                	je     803573 <spawnl+0x56>
  803550:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803557:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80355b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80355f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803563:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803567:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80356b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80356f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803573:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80357a:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  803581:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803584:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  80358b:	00 00 00 
  80358e:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803595:	00 00 00 
  803598:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80359c:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  8035a3:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8035aa:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8035b1:	eb 07                	jmp    8035ba <spawnl+0x9d>
		argc++;
  8035b3:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8035ba:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8035c0:	83 f8 30             	cmp    $0x30,%eax
  8035c3:	73 23                	jae    8035e8 <spawnl+0xcb>
  8035c5:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  8035cc:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8035d2:	89 c0                	mov    %eax,%eax
  8035d4:	48 01 d0             	add    %rdx,%rax
  8035d7:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  8035dd:	83 c2 08             	add    $0x8,%edx
  8035e0:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  8035e6:	eb 15                	jmp    8035fd <spawnl+0xe0>
  8035e8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8035ef:	48 89 d0             	mov    %rdx,%rax
  8035f2:	48 83 c2 08          	add    $0x8,%rdx
  8035f6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8035fd:	48 8b 00             	mov    (%rax),%rax
  803600:	48 85 c0             	test   %rax,%rax
  803603:	75 ae                	jne    8035b3 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803605:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  80360b:	83 c0 02             	add    $0x2,%eax
  80360e:	48 89 e2             	mov    %rsp,%rdx
  803611:	48 89 d3             	mov    %rdx,%rbx
  803614:	48 63 d0             	movslq %eax,%rdx
  803617:	48 83 ea 01          	sub    $0x1,%rdx
  80361b:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  803622:	48 98                	cltq   
  803624:	48 c1 e0 03          	shl    $0x3,%rax
  803628:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  80362c:	b8 10 00 00 00       	mov    $0x10,%eax
  803631:	48 83 e8 01          	sub    $0x1,%rax
  803635:	48 01 d0             	add    %rdx,%rax
  803638:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  80363f:	10 00 00 00 
  803643:	ba 00 00 00 00       	mov    $0x0,%edx
  803648:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  80364f:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803653:	48 29 c4             	sub    %rax,%rsp
  803656:	48 89 e0             	mov    %rsp,%rax
  803659:	48 83 c0 0f          	add    $0xf,%rax
  80365d:	48 c1 e8 04          	shr    $0x4,%rax
  803661:	48 c1 e0 04          	shl    $0x4,%rax
  803665:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  80366c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803673:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  80367a:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  80367d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803683:	8d 50 01             	lea    0x1(%rax),%edx
  803686:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80368d:	48 63 d2             	movslq %edx,%rdx
  803690:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803697:	00 

	va_start(vl, arg0);
  803698:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  80369f:	00 00 00 
  8036a2:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  8036a9:	00 00 00 
  8036ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8036b0:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  8036b7:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  8036be:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8036c5:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  8036cc:	00 00 00 
  8036cf:	eb 63                	jmp    803734 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  8036d1:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  8036d7:	8d 70 01             	lea    0x1(%rax),%esi
  8036da:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8036e0:	83 f8 30             	cmp    $0x30,%eax
  8036e3:	73 23                	jae    803708 <spawnl+0x1eb>
  8036e5:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  8036ec:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  8036f2:	89 c0                	mov    %eax,%eax
  8036f4:	48 01 d0             	add    %rdx,%rax
  8036f7:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  8036fd:	83 c2 08             	add    $0x8,%edx
  803700:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803706:	eb 15                	jmp    80371d <spawnl+0x200>
  803708:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80370f:	48 89 d0             	mov    %rdx,%rax
  803712:	48 83 c2 08          	add    $0x8,%rdx
  803716:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  80371d:	48 8b 08             	mov    (%rax),%rcx
  803720:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803727:	89 f2                	mov    %esi,%edx
  803729:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80372d:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  803734:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  80373a:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  803740:	77 8f                	ja     8036d1 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803742:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803749:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803750:	48 89 d6             	mov    %rdx,%rsi
  803753:	48 89 c7             	mov    %rax,%rdi
  803756:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
  803762:	48 89 dc             	mov    %rbx,%rsp
}
  803765:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803769:	c9                   	leaveq 
  80376a:	c3                   	retq   

000000000080376b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80376b:	55                   	push   %rbp
  80376c:	48 89 e5             	mov    %rsp,%rbp
  80376f:	48 83 ec 50          	sub    $0x50,%rsp
  803773:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803776:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80377a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80377e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803785:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803786:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80378d:	eb 2c                	jmp    8037bb <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  80378f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803792:	48 98                	cltq   
  803794:	48 c1 e0 03          	shl    $0x3,%rax
  803798:	48 03 45 c0          	add    -0x40(%rbp),%rax
  80379c:	48 8b 00             	mov    (%rax),%rax
  80379f:	48 89 c7             	mov    %rax,%rdi
  8037a2:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8037a9:	00 00 00 
  8037ac:	ff d0                	callq  *%rax
  8037ae:	83 c0 01             	add    $0x1,%eax
  8037b1:	48 98                	cltq   
  8037b3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8037b7:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8037bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037be:	48 98                	cltq   
  8037c0:	48 c1 e0 03          	shl    $0x3,%rax
  8037c4:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8037c8:	48 8b 00             	mov    (%rax),%rax
  8037cb:	48 85 c0             	test   %rax,%rax
  8037ce:	75 bf                	jne    80378f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037d4:	48 f7 d8             	neg    %rax
  8037d7:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037dd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037e5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ed:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037f1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037f4:	83 c2 01             	add    $0x1,%edx
  8037f7:	c1 e2 03             	shl    $0x3,%edx
  8037fa:	48 63 d2             	movslq %edx,%rdx
  8037fd:	48 f7 da             	neg    %rdx
  803800:	48 01 d0             	add    %rdx,%rax
  803803:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803807:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380b:	48 83 e8 10          	sub    $0x10,%rax
  80380f:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803815:	77 0a                	ja     803821 <init_stack+0xb6>
		return -E_NO_MEM;
  803817:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80381c:	e9 b8 01 00 00       	jmpq   8039d9 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803821:	ba 07 00 00 00       	mov    $0x7,%edx
  803826:	be 00 00 40 00       	mov    $0x400000,%esi
  80382b:	bf 00 00 00 00       	mov    $0x0,%edi
  803830:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803837:	00 00 00 
  80383a:	ff d0                	callq  *%rax
  80383c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80383f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803843:	79 08                	jns    80384d <init_stack+0xe2>
		return r;
  803845:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803848:	e9 8c 01 00 00       	jmpq   8039d9 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80384d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803854:	eb 73                	jmp    8038c9 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803856:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803859:	48 98                	cltq   
  80385b:	48 c1 e0 03          	shl    $0x3,%rax
  80385f:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803863:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803868:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  80386c:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803873:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803876:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803879:	48 98                	cltq   
  80387b:	48 c1 e0 03          	shl    $0x3,%rax
  80387f:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803883:	48 8b 10             	mov    (%rax),%rdx
  803886:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80388a:	48 89 d6             	mov    %rdx,%rsi
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80389c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80389f:	48 98                	cltq   
  8038a1:	48 c1 e0 03          	shl    $0x3,%rax
  8038a5:	48 03 45 c0          	add    -0x40(%rbp),%rax
  8038a9:	48 8b 00             	mov    (%rax),%rax
  8038ac:	48 89 c7             	mov    %rax,%rdi
  8038af:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8038b6:	00 00 00 
  8038b9:	ff d0                	callq  *%rax
  8038bb:	48 98                	cltq   
  8038bd:	48 83 c0 01          	add    $0x1,%rax
  8038c1:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038c5:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038c9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038cc:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038cf:	7c 85                	jl     803856 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038d4:	48 98                	cltq   
  8038d6:	48 c1 e0 03          	shl    $0x3,%rax
  8038da:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8038de:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038e5:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038ec:	00 
  8038ed:	74 35                	je     803924 <init_stack+0x1b9>
  8038ef:	48 b9 88 5b 80 00 00 	movabs $0x805b88,%rcx
  8038f6:	00 00 00 
  8038f9:	48 ba ae 5b 80 00 00 	movabs $0x805bae,%rdx
  803900:	00 00 00 
  803903:	be f1 00 00 00       	mov    $0xf1,%esi
  803908:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  80390f:	00 00 00 
  803912:	b8 00 00 00 00       	mov    $0x0,%eax
  803917:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  80391e:	00 00 00 
  803921:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803924:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803928:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80392c:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803931:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803935:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80393b:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80393e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803942:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803946:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803949:	48 98                	cltq   
  80394b:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80394e:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803953:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803957:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80395d:	48 89 c2             	mov    %rax,%rdx
  803960:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803964:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803967:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80396a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803970:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803975:	89 c2                	mov    %eax,%edx
  803977:	be 00 00 40 00       	mov    $0x400000,%esi
  80397c:	bf 00 00 00 00       	mov    $0x0,%edi
  803981:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
  80398d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803990:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803994:	78 26                	js     8039bc <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803996:	be 00 00 40 00       	mov    $0x400000,%esi
  80399b:	bf 00 00 00 00       	mov    $0x0,%edi
  8039a0:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8039a7:	00 00 00 
  8039aa:	ff d0                	callq  *%rax
  8039ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039b3:	78 0a                	js     8039bf <init_stack+0x254>
		goto error;

	return 0;
  8039b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ba:	eb 1d                	jmp    8039d9 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8039bc:	90                   	nop
  8039bd:	eb 01                	jmp    8039c0 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8039bf:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8039c0:	be 00 00 40 00       	mov    $0x400000,%esi
  8039c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8039ca:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
	return r;
  8039d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039d9:	c9                   	leaveq 
  8039da:	c3                   	retq   

00000000008039db <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039db:	55                   	push   %rbp
  8039dc:	48 89 e5             	mov    %rsp,%rbp
  8039df:	48 83 ec 50          	sub    $0x50,%rsp
  8039e3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8039ee:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8039f1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8039f5:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8039f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039fd:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a09:	74 21                	je     803a2c <map_segment+0x51>
		va -= i;
  803a0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0e:	48 98                	cltq   
  803a10:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a17:	48 98                	cltq   
  803a19:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a20:	48 98                	cltq   
  803a22:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a29:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a33:	e9 74 01 00 00       	jmpq   803bac <map_segment+0x1d1>
		if (i >= filesz) {
  803a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3b:	48 98                	cltq   
  803a3d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a41:	72 38                	jb     803a7b <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a46:	48 98                	cltq   
  803a48:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803a4c:	48 89 c1             	mov    %rax,%rcx
  803a4f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a52:	8b 55 10             	mov    0x10(%rbp),%edx
  803a55:	48 89 ce             	mov    %rcx,%rsi
  803a58:	89 c7                	mov    %eax,%edi
  803a5a:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
  803a66:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a69:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a6d:	0f 89 32 01 00 00    	jns    803ba5 <map_segment+0x1ca>
				return r;
  803a73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a76:	e9 45 01 00 00       	jmpq   803bc0 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a7b:	ba 07 00 00 00       	mov    $0x7,%edx
  803a80:	be 00 00 40 00       	mov    $0x400000,%esi
  803a85:	bf 00 00 00 00       	mov    $0x0,%edi
  803a8a:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a99:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a9d:	79 08                	jns    803aa7 <map_segment+0xcc>
				return r;
  803a9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aa2:	e9 19 01 00 00       	jmpq   803bc0 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aaa:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803aad:	01 c2                	add    %eax,%edx
  803aaf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803ab2:	89 d6                	mov    %edx,%esi
  803ab4:	89 c7                	mov    %eax,%edi
  803ab6:	48 b8 e6 2b 80 00 00 	movabs $0x802be6,%rax
  803abd:	00 00 00 
  803ac0:	ff d0                	callq  *%rax
  803ac2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ac5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ac9:	79 08                	jns    803ad3 <map_segment+0xf8>
				return r;
  803acb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ace:	e9 ed 00 00 00       	jmpq   803bc0 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ad3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	48 98                	cltq   
  803adf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ae3:	48 89 d1             	mov    %rdx,%rcx
  803ae6:	48 29 c1             	sub    %rax,%rcx
  803ae9:	48 89 c8             	mov    %rcx,%rax
  803aec:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803af0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803af3:	48 63 d0             	movslq %eax,%rdx
  803af6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803afa:	48 39 c2             	cmp    %rax,%rdx
  803afd:	48 0f 47 d0          	cmova  %rax,%rdx
  803b01:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b04:	be 00 00 40 00       	mov    $0x400000,%esi
  803b09:	89 c7                	mov    %eax,%edi
  803b0b:	48 b8 99 2a 80 00 00 	movabs $0x802a99,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
  803b17:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b1e:	79 08                	jns    803b28 <map_segment+0x14d>
				return r;
  803b20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b23:	e9 98 00 00 00       	jmpq   803bc0 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2b:	48 98                	cltq   
  803b2d:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803b31:	48 89 c2             	mov    %rax,%rdx
  803b34:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b37:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b3b:	48 89 d1             	mov    %rdx,%rcx
  803b3e:	89 c2                	mov    %eax,%edx
  803b40:	be 00 00 40 00       	mov    $0x400000,%esi
  803b45:	bf 00 00 00 00       	mov    $0x0,%edi
  803b4a:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  803b51:	00 00 00 
  803b54:	ff d0                	callq  *%rax
  803b56:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b59:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b5d:	79 30                	jns    803b8f <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  803b5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b62:	89 c1                	mov    %eax,%ecx
  803b64:	48 ba c3 5b 80 00 00 	movabs $0x805bc3,%rdx
  803b6b:	00 00 00 
  803b6e:	be 24 01 00 00       	mov    $0x124,%esi
  803b73:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  803b7a:	00 00 00 
  803b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803b82:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  803b89:	00 00 00 
  803b8c:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803b8f:	be 00 00 40 00       	mov    $0x400000,%esi
  803b94:	bf 00 00 00 00       	mov    $0x0,%edi
  803b99:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803ba0:	00 00 00 
  803ba3:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803ba5:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803baf:	48 98                	cltq   
  803bb1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bb5:	0f 82 7d fe ff ff    	jb     803a38 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bc0:	c9                   	leaveq 
  803bc1:	c3                   	retq   

0000000000803bc2 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bc2:	55                   	push   %rbp
  803bc3:	48 89 e5             	mov    %rsp,%rbp
  803bc6:	48 83 ec 60          	sub    $0x60,%rsp
  803bca:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  803bcd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  803bd4:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803bdb:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  803be2:	00 
  803be3:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803bea:	00 
  803beb:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  803bf2:	00 
  803bf3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bfa:	00 
  803bfb:	e9 a6 01 00 00       	jmpq   803da6 <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  803c00:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803c07:	01 00 00 
  803c0a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c12:	83 e0 01             	and    $0x1,%eax
  803c15:	84 c0                	test   %al,%al
  803c17:	0f 84 74 01 00 00    	je     803d91 <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803c1d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803c24:	00 
  803c25:	e9 56 01 00 00       	jmpq   803d80 <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  803c2a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c31:	01 00 00 
  803c34:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c38:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c3c:	83 e0 01             	and    $0x1,%eax
  803c3f:	84 c0                	test   %al,%al
  803c41:	0f 84 1f 01 00 00    	je     803d66 <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  803c47:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803c4e:	00 
  803c4f:	e9 02 01 00 00       	jmpq   803d56 <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  803c54:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c5b:	01 00 00 
  803c5e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c66:	83 e0 01             	and    $0x1,%eax
  803c69:	84 c0                	test   %al,%al
  803c6b:	0f 84 cb 00 00 00    	je     803d3c <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  803c71:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803c78:	00 
  803c79:	e9 ae 00 00 00       	jmpq   803d2c <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  803c7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c85:	01 00 00 
  803c88:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c90:	25 00 04 00 00       	and    $0x400,%eax
  803c95:	48 85 c0             	test   %rax,%rax
  803c98:	0f 84 84 00 00 00    	je     803d22 <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  803c9e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ca2:	48 c1 e0 0c          	shl    $0xc,%rax
  803ca6:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  803caa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cb1:	01 00 00 
  803cb4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cbc:	25 07 0e 00 00       	and    $0xe07,%eax
  803cc1:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  803cc4:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  803cc7:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  803ccb:	8b 55 ac             	mov    -0x54(%rbp),%edx
  803cce:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803cd2:	41 89 f0             	mov    %esi,%r8d
  803cd5:	48 89 c6             	mov    %rax,%rsi
  803cd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803cdd:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  803ce4:	00 00 00 
  803ce7:	ff d0                	callq  *%rax
  803ce9:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  803cec:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  803cf0:	79 30                	jns    803d22 <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  803cf2:	8b 45 b0             	mov    -0x50(%rbp),%eax
  803cf5:	89 c1                	mov    %eax,%ecx
  803cf7:	48 ba e0 5b 80 00 00 	movabs $0x805be0,%rdx
  803cfe:	00 00 00 
  803d01:	be 48 01 00 00       	mov    $0x148,%esi
  803d06:	48 bf 48 5b 80 00 00 	movabs $0x805b48,%rdi
  803d0d:	00 00 00 
  803d10:	b8 00 00 00 00       	mov    $0x0,%eax
  803d15:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  803d1c:	00 00 00 
  803d1f:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  803d22:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803d27:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  803d2c:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803d33:	00 
  803d34:	0f 86 44 ff ff ff    	jbe    803c7e <copy_shared_pages+0xbc>
  803d3a:	eb 10                	jmp    803d4c <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  803d3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d40:	48 83 c0 01          	add    $0x1,%rax
  803d44:	48 c1 e0 09          	shl    $0x9,%rax
  803d48:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  803d4c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803d51:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  803d56:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803d5d:	00 
  803d5e:	0f 86 f0 fe ff ff    	jbe    803c54 <copy_shared_pages+0x92>
  803d64:	eb 10                	jmp    803d76 <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  803d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6a:	48 83 c0 01          	add    $0x1,%rax
  803d6e:	48 c1 e0 09          	shl    $0x9,%rax
  803d72:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803d76:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803d7b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803d80:	8b 45 c0             	mov    -0x40(%rbp),%eax
  803d83:	48 98                	cltq   
  803d85:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803d89:	0f 87 9b fe ff ff    	ja     803c2a <copy_shared_pages+0x68>
  803d8f:	eb 10                	jmp    803da1 <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  803d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d95:	48 83 c0 01          	add    $0x1,%rax
  803d99:	48 c1 e0 09          	shl    $0x9,%rax
  803d9d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803da1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803da6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803da9:	48 98                	cltq   
  803dab:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803daf:	0f 87 4b fe ff ff    	ja     803c00 <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  803db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dba:	c9                   	leaveq 
  803dbb:	c3                   	retq   

0000000000803dbc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803dbc:	55                   	push   %rbp
  803dbd:	48 89 e5             	mov    %rsp,%rbp
  803dc0:	48 83 ec 20          	sub    $0x20,%rsp
  803dc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803dc7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dce:	48 89 d6             	mov    %rdx,%rsi
  803dd1:	89 c7                	mov    %eax,%edi
  803dd3:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
  803ddf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de6:	79 05                	jns    803ded <fd2sockid+0x31>
		return r;
  803de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803deb:	eb 24                	jmp    803e11 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803ded:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df1:	8b 10                	mov    (%rax),%edx
  803df3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803dfa:	00 00 00 
  803dfd:	8b 00                	mov    (%rax),%eax
  803dff:	39 c2                	cmp    %eax,%edx
  803e01:	74 07                	je     803e0a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803e03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e08:	eb 07                	jmp    803e11 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803e11:	c9                   	leaveq 
  803e12:	c3                   	retq   

0000000000803e13 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803e13:	55                   	push   %rbp
  803e14:	48 89 e5             	mov    %rsp,%rbp
  803e17:	48 83 ec 20          	sub    $0x20,%rsp
  803e1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803e1e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803e22:	48 89 c7             	mov    %rax,%rdi
  803e25:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  803e2c:	00 00 00 
  803e2f:	ff d0                	callq  *%rax
  803e31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e38:	78 26                	js     803e60 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3e:	ba 07 04 00 00       	mov    $0x407,%edx
  803e43:	48 89 c6             	mov    %rax,%rsi
  803e46:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4b:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  803e52:	00 00 00 
  803e55:	ff d0                	callq  *%rax
  803e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e5e:	79 16                	jns    803e76 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803e60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e63:	89 c7                	mov    %eax,%edi
  803e65:	48 b8 20 43 80 00 00 	movabs $0x804320,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
		return r;
  803e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e74:	eb 3a                	jmp    803eb0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803e81:	00 00 00 
  803e84:	8b 12                	mov    (%rdx),%edx
  803e86:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e8c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803e93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e97:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e9a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea1:	48 89 c7             	mov    %rax,%rdi
  803ea4:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  803eab:	00 00 00 
  803eae:	ff d0                	callq  *%rax
}
  803eb0:	c9                   	leaveq 
  803eb1:	c3                   	retq   

0000000000803eb2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803eb2:	55                   	push   %rbp
  803eb3:	48 89 e5             	mov    %rsp,%rbp
  803eb6:	48 83 ec 30          	sub    $0x30,%rsp
  803eba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ebd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ec1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ec5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ec8:	89 c7                	mov    %eax,%edi
  803eca:	48 b8 bc 3d 80 00 00 	movabs $0x803dbc,%rax
  803ed1:	00 00 00 
  803ed4:	ff d0                	callq  *%rax
  803ed6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ed9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803edd:	79 05                	jns    803ee4 <accept+0x32>
		return r;
  803edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee2:	eb 3b                	jmp    803f1f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803ee4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ee8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eef:	48 89 ce             	mov    %rcx,%rsi
  803ef2:	89 c7                	mov    %eax,%edi
  803ef4:	48 b8 fd 41 80 00 00 	movabs $0x8041fd,%rax
  803efb:	00 00 00 
  803efe:	ff d0                	callq  *%rax
  803f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f07:	79 05                	jns    803f0e <accept+0x5c>
		return r;
  803f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0c:	eb 11                	jmp    803f1f <accept+0x6d>
	return alloc_sockfd(r);
  803f0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f11:	89 c7                	mov    %eax,%edi
  803f13:	48 b8 13 3e 80 00 00 	movabs $0x803e13,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
}
  803f1f:	c9                   	leaveq 
  803f20:	c3                   	retq   

0000000000803f21 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f21:	55                   	push   %rbp
  803f22:	48 89 e5             	mov    %rsp,%rbp
  803f25:	48 83 ec 20          	sub    $0x20,%rsp
  803f29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f30:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f36:	89 c7                	mov    %eax,%edi
  803f38:	48 b8 bc 3d 80 00 00 	movabs $0x803dbc,%rax
  803f3f:	00 00 00 
  803f42:	ff d0                	callq  *%rax
  803f44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f4b:	79 05                	jns    803f52 <bind+0x31>
		return r;
  803f4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f50:	eb 1b                	jmp    803f6d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803f52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f55:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803f59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f5c:	48 89 ce             	mov    %rcx,%rsi
  803f5f:	89 c7                	mov    %eax,%edi
  803f61:	48 b8 7c 42 80 00 00 	movabs $0x80427c,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
}
  803f6d:	c9                   	leaveq 
  803f6e:	c3                   	retq   

0000000000803f6f <shutdown>:

int
shutdown(int s, int how)
{
  803f6f:	55                   	push   %rbp
  803f70:	48 89 e5             	mov    %rsp,%rbp
  803f73:	48 83 ec 20          	sub    $0x20,%rsp
  803f77:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f7a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803f7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f80:	89 c7                	mov    %eax,%edi
  803f82:	48 b8 bc 3d 80 00 00 	movabs $0x803dbc,%rax
  803f89:	00 00 00 
  803f8c:	ff d0                	callq  *%rax
  803f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f95:	79 05                	jns    803f9c <shutdown+0x2d>
		return r;
  803f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9a:	eb 16                	jmp    803fb2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803f9c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa2:	89 d6                	mov    %edx,%esi
  803fa4:	89 c7                	mov    %eax,%edi
  803fa6:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
  803fad:	00 00 00 
  803fb0:	ff d0                	callq  *%rax
}
  803fb2:	c9                   	leaveq 
  803fb3:	c3                   	retq   

0000000000803fb4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803fb4:	55                   	push   %rbp
  803fb5:	48 89 e5             	mov    %rsp,%rbp
  803fb8:	48 83 ec 10          	sub    $0x10,%rsp
  803fbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc4:	48 89 c7             	mov    %rax,%rdi
  803fc7:	48 b8 40 52 80 00 00 	movabs $0x805240,%rax
  803fce:	00 00 00 
  803fd1:	ff d0                	callq  *%rax
  803fd3:	83 f8 01             	cmp    $0x1,%eax
  803fd6:	75 17                	jne    803fef <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fdc:	8b 40 0c             	mov    0xc(%rax),%eax
  803fdf:	89 c7                	mov    %eax,%edi
  803fe1:	48 b8 20 43 80 00 00 	movabs $0x804320,%rax
  803fe8:	00 00 00 
  803feb:	ff d0                	callq  *%rax
  803fed:	eb 05                	jmp    803ff4 <devsock_close+0x40>
	else
		return 0;
  803fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ff4:	c9                   	leaveq 
  803ff5:	c3                   	retq   

0000000000803ff6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ff6:	55                   	push   %rbp
  803ff7:	48 89 e5             	mov    %rsp,%rbp
  803ffa:	48 83 ec 20          	sub    $0x20,%rsp
  803ffe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804001:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804005:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804008:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80400b:	89 c7                	mov    %eax,%edi
  80400d:	48 b8 bc 3d 80 00 00 	movabs $0x803dbc,%rax
  804014:	00 00 00 
  804017:	ff d0                	callq  *%rax
  804019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804020:	79 05                	jns    804027 <connect+0x31>
		return r;
  804022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804025:	eb 1b                	jmp    804042 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804027:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80402a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80402e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804031:	48 89 ce             	mov    %rcx,%rsi
  804034:	89 c7                	mov    %eax,%edi
  804036:	48 b8 4d 43 80 00 00 	movabs $0x80434d,%rax
  80403d:	00 00 00 
  804040:	ff d0                	callq  *%rax
}
  804042:	c9                   	leaveq 
  804043:	c3                   	retq   

0000000000804044 <listen>:

int
listen(int s, int backlog)
{
  804044:	55                   	push   %rbp
  804045:	48 89 e5             	mov    %rsp,%rbp
  804048:	48 83 ec 20          	sub    $0x20,%rsp
  80404c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80404f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804052:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804055:	89 c7                	mov    %eax,%edi
  804057:	48 b8 bc 3d 80 00 00 	movabs $0x803dbc,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
  804063:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804066:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80406a:	79 05                	jns    804071 <listen+0x2d>
		return r;
  80406c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406f:	eb 16                	jmp    804087 <listen+0x43>
	return nsipc_listen(r, backlog);
  804071:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804077:	89 d6                	mov    %edx,%esi
  804079:	89 c7                	mov    %eax,%edi
  80407b:	48 b8 b1 43 80 00 00 	movabs $0x8043b1,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 20          	sub    $0x20,%rsp
  804091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804095:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804099:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80409d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a1:	89 c2                	mov    %eax,%edx
  8040a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a7:	8b 40 0c             	mov    0xc(%rax),%eax
  8040aa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8040ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8040b3:	89 c7                	mov    %eax,%edi
  8040b5:	48 b8 f1 43 80 00 00 	movabs $0x8043f1,%rax
  8040bc:	00 00 00 
  8040bf:	ff d0                	callq  *%rax
}
  8040c1:	c9                   	leaveq 
  8040c2:	c3                   	retq   

00000000008040c3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8040c3:	55                   	push   %rbp
  8040c4:	48 89 e5             	mov    %rsp,%rbp
  8040c7:	48 83 ec 20          	sub    $0x20,%rsp
  8040cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8040d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040db:	89 c2                	mov    %eax,%edx
  8040dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e1:	8b 40 0c             	mov    0xc(%rax),%eax
  8040e4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8040e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8040ed:	89 c7                	mov    %eax,%edi
  8040ef:	48 b8 bd 44 80 00 00 	movabs $0x8044bd,%rax
  8040f6:	00 00 00 
  8040f9:	ff d0                	callq  *%rax
}
  8040fb:	c9                   	leaveq 
  8040fc:	c3                   	retq   

00000000008040fd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8040fd:	55                   	push   %rbp
  8040fe:	48 89 e5             	mov    %rsp,%rbp
  804101:	48 83 ec 10          	sub    $0x10,%rsp
  804105:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804109:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80410d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804111:	48 be fc 5b 80 00 00 	movabs $0x805bfc,%rsi
  804118:	00 00 00 
  80411b:	48 89 c7             	mov    %rax,%rdi
  80411e:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  804125:	00 00 00 
  804128:	ff d0                	callq  *%rax
	return 0;
  80412a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80412f:	c9                   	leaveq 
  804130:	c3                   	retq   

0000000000804131 <socket>:

int
socket(int domain, int type, int protocol)
{
  804131:	55                   	push   %rbp
  804132:	48 89 e5             	mov    %rsp,%rbp
  804135:	48 83 ec 20          	sub    $0x20,%rsp
  804139:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80413c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80413f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804142:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804145:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804148:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80414b:	89 ce                	mov    %ecx,%esi
  80414d:	89 c7                	mov    %eax,%edi
  80414f:	48 b8 75 45 80 00 00 	movabs $0x804575,%rax
  804156:	00 00 00 
  804159:	ff d0                	callq  *%rax
  80415b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80415e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804162:	79 05                	jns    804169 <socket+0x38>
		return r;
  804164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804167:	eb 11                	jmp    80417a <socket+0x49>
	return alloc_sockfd(r);
  804169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416c:	89 c7                	mov    %eax,%edi
  80416e:	48 b8 13 3e 80 00 00 	movabs $0x803e13,%rax
  804175:	00 00 00 
  804178:	ff d0                	callq  *%rax
}
  80417a:	c9                   	leaveq 
  80417b:	c3                   	retq   

000000000080417c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80417c:	55                   	push   %rbp
  80417d:	48 89 e5             	mov    %rsp,%rbp
  804180:	48 83 ec 10          	sub    $0x10,%rsp
  804184:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804187:	48 b8 34 80 80 00 00 	movabs $0x808034,%rax
  80418e:	00 00 00 
  804191:	8b 00                	mov    (%rax),%eax
  804193:	85 c0                	test   %eax,%eax
  804195:	75 1d                	jne    8041b4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804197:	bf 02 00 00 00       	mov    $0x2,%edi
  80419c:	48 b8 bb 51 80 00 00 	movabs $0x8051bb,%rax
  8041a3:	00 00 00 
  8041a6:	ff d0                	callq  *%rax
  8041a8:	48 ba 34 80 80 00 00 	movabs $0x808034,%rdx
  8041af:	00 00 00 
  8041b2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8041b4:	48 b8 34 80 80 00 00 	movabs $0x808034,%rax
  8041bb:	00 00 00 
  8041be:	8b 00                	mov    (%rax),%eax
  8041c0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8041c3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8041c8:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  8041cf:	00 00 00 
  8041d2:	89 c7                	mov    %eax,%edi
  8041d4:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  8041db:	00 00 00 
  8041de:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8041e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8041e5:	be 00 00 00 00       	mov    $0x0,%esi
  8041ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8041ef:	48 b8 38 50 80 00 00 	movabs $0x805038,%rax
  8041f6:	00 00 00 
  8041f9:	ff d0                	callq  *%rax
}
  8041fb:	c9                   	leaveq 
  8041fc:	c3                   	retq   

00000000008041fd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8041fd:	55                   	push   %rbp
  8041fe:	48 89 e5             	mov    %rsp,%rbp
  804201:	48 83 ec 30          	sub    $0x30,%rsp
  804205:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804208:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80420c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804210:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804217:	00 00 00 
  80421a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80421d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80421f:	bf 01 00 00 00       	mov    $0x1,%edi
  804224:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  80422b:	00 00 00 
  80422e:	ff d0                	callq  *%rax
  804230:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804233:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804237:	78 3e                	js     804277 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804239:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804240:	00 00 00 
  804243:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424b:	8b 40 10             	mov    0x10(%rax),%eax
  80424e:	89 c2                	mov    %eax,%edx
  804250:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804254:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804258:	48 89 ce             	mov    %rcx,%rsi
  80425b:	48 89 c7             	mov    %rax,%rdi
  80425e:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  804265:	00 00 00 
  804268:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80426a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80426e:	8b 50 10             	mov    0x10(%rax),%edx
  804271:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804275:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804277:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80427a:	c9                   	leaveq 
  80427b:	c3                   	retq   

000000000080427c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80427c:	55                   	push   %rbp
  80427d:	48 89 e5             	mov    %rsp,%rbp
  804280:	48 83 ec 10          	sub    $0x10,%rsp
  804284:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804287:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80428b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80428e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804295:	00 00 00 
  804298:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80429b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80429d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042a4:	48 89 c6             	mov    %rax,%rsi
  8042a7:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8042ae:	00 00 00 
  8042b1:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  8042b8:	00 00 00 
  8042bb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8042bd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042c4:	00 00 00 
  8042c7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042ca:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8042cd:	bf 02 00 00 00       	mov    $0x2,%edi
  8042d2:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
}
  8042de:	c9                   	leaveq 
  8042df:	c3                   	retq   

00000000008042e0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8042e0:	55                   	push   %rbp
  8042e1:	48 89 e5             	mov    %rsp,%rbp
  8042e4:	48 83 ec 10          	sub    $0x10,%rsp
  8042e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8042eb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8042ee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042f5:	00 00 00 
  8042f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042fb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8042fd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804304:	00 00 00 
  804307:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80430a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80430d:	bf 03 00 00 00       	mov    $0x3,%edi
  804312:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
}
  80431e:	c9                   	leaveq 
  80431f:	c3                   	retq   

0000000000804320 <nsipc_close>:

int
nsipc_close(int s)
{
  804320:	55                   	push   %rbp
  804321:	48 89 e5             	mov    %rsp,%rbp
  804324:	48 83 ec 10          	sub    $0x10,%rsp
  804328:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80432b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804332:	00 00 00 
  804335:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804338:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80433a:	bf 04 00 00 00       	mov    $0x4,%edi
  80433f:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
}
  80434b:	c9                   	leaveq 
  80434c:	c3                   	retq   

000000000080434d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80434d:	55                   	push   %rbp
  80434e:	48 89 e5             	mov    %rsp,%rbp
  804351:	48 83 ec 10          	sub    $0x10,%rsp
  804355:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804358:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80435c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80435f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804366:	00 00 00 
  804369:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80436c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80436e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804375:	48 89 c6             	mov    %rax,%rsi
  804378:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80437f:	00 00 00 
  804382:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  804389:	00 00 00 
  80438c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80438e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804395:	00 00 00 
  804398:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80439b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80439e:	bf 05 00 00 00       	mov    $0x5,%edi
  8043a3:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  8043aa:	00 00 00 
  8043ad:	ff d0                	callq  *%rax
}
  8043af:	c9                   	leaveq 
  8043b0:	c3                   	retq   

00000000008043b1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8043b1:	55                   	push   %rbp
  8043b2:	48 89 e5             	mov    %rsp,%rbp
  8043b5:	48 83 ec 10          	sub    $0x10,%rsp
  8043b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8043bf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043c6:	00 00 00 
  8043c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043cc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8043ce:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043d5:	00 00 00 
  8043d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043db:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8043de:	bf 06 00 00 00       	mov    $0x6,%edi
  8043e3:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  8043ea:	00 00 00 
  8043ed:	ff d0                	callq  *%rax
}
  8043ef:	c9                   	leaveq 
  8043f0:	c3                   	retq   

00000000008043f1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8043f1:	55                   	push   %rbp
  8043f2:	48 89 e5             	mov    %rsp,%rbp
  8043f5:	48 83 ec 30          	sub    $0x30,%rsp
  8043f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804400:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804403:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804406:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80440d:	00 00 00 
  804410:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804413:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804415:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80441c:	00 00 00 
  80441f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804422:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804425:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80442c:	00 00 00 
  80442f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804432:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804435:	bf 07 00 00 00       	mov    $0x7,%edi
  80443a:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  804441:	00 00 00 
  804444:	ff d0                	callq  *%rax
  804446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80444d:	78 69                	js     8044b8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80444f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804456:	7f 08                	jg     804460 <nsipc_recv+0x6f>
  804458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80445b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80445e:	7e 35                	jle    804495 <nsipc_recv+0xa4>
  804460:	48 b9 03 5c 80 00 00 	movabs $0x805c03,%rcx
  804467:	00 00 00 
  80446a:	48 ba 18 5c 80 00 00 	movabs $0x805c18,%rdx
  804471:	00 00 00 
  804474:	be 61 00 00 00       	mov    $0x61,%esi
  804479:	48 bf 2d 5c 80 00 00 	movabs $0x805c2d,%rdi
  804480:	00 00 00 
  804483:	b8 00 00 00 00       	mov    $0x0,%eax
  804488:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  80448f:	00 00 00 
  804492:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804498:	48 63 d0             	movslq %eax,%rdx
  80449b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80449f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8044a6:	00 00 00 
  8044a9:	48 89 c7             	mov    %rax,%rdi
  8044ac:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  8044b3:	00 00 00 
  8044b6:	ff d0                	callq  *%rax
	}

	return r;
  8044b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8044bb:	c9                   	leaveq 
  8044bc:	c3                   	retq   

00000000008044bd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8044bd:	55                   	push   %rbp
  8044be:	48 89 e5             	mov    %rsp,%rbp
  8044c1:	48 83 ec 20          	sub    $0x20,%rsp
  8044c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8044cf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8044d2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044d9:	00 00 00 
  8044dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044df:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8044e1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8044e8:	7e 35                	jle    80451f <nsipc_send+0x62>
  8044ea:	48 b9 39 5c 80 00 00 	movabs $0x805c39,%rcx
  8044f1:	00 00 00 
  8044f4:	48 ba 18 5c 80 00 00 	movabs $0x805c18,%rdx
  8044fb:	00 00 00 
  8044fe:	be 6c 00 00 00       	mov    $0x6c,%esi
  804503:	48 bf 2d 5c 80 00 00 	movabs $0x805c2d,%rdi
  80450a:	00 00 00 
  80450d:	b8 00 00 00 00       	mov    $0x0,%eax
  804512:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  804519:	00 00 00 
  80451c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80451f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804522:	48 63 d0             	movslq %eax,%rdx
  804525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804529:	48 89 c6             	mov    %rax,%rsi
  80452c:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804533:	00 00 00 
  804536:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  80453d:	00 00 00 
  804540:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804542:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804549:	00 00 00 
  80454c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80454f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804552:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804559:	00 00 00 
  80455c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80455f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804562:	bf 08 00 00 00       	mov    $0x8,%edi
  804567:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  80456e:	00 00 00 
  804571:	ff d0                	callq  *%rax
}
  804573:	c9                   	leaveq 
  804574:	c3                   	retq   

0000000000804575 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804575:	55                   	push   %rbp
  804576:	48 89 e5             	mov    %rsp,%rbp
  804579:	48 83 ec 10          	sub    $0x10,%rsp
  80457d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804580:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804583:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804586:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80458d:	00 00 00 
  804590:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804593:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804595:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80459c:	00 00 00 
  80459f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045a2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8045a5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045ac:	00 00 00 
  8045af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8045b2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8045b5:	bf 09 00 00 00       	mov    $0x9,%edi
  8045ba:	48 b8 7c 41 80 00 00 	movabs $0x80417c,%rax
  8045c1:	00 00 00 
  8045c4:	ff d0                	callq  *%rax
}
  8045c6:	c9                   	leaveq 
  8045c7:	c3                   	retq   

00000000008045c8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8045c8:	55                   	push   %rbp
  8045c9:	48 89 e5             	mov    %rsp,%rbp
  8045cc:	53                   	push   %rbx
  8045cd:	48 83 ec 38          	sub    $0x38,%rsp
  8045d1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8045d5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8045d9:	48 89 c7             	mov    %rax,%rdi
  8045dc:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  8045e3:	00 00 00 
  8045e6:	ff d0                	callq  *%rax
  8045e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045ef:	0f 88 bf 01 00 00    	js     8047b4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8045fe:	48 89 c6             	mov    %rax,%rsi
  804601:	bf 00 00 00 00       	mov    $0x0,%edi
  804606:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  80460d:	00 00 00 
  804610:	ff d0                	callq  *%rax
  804612:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804615:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804619:	0f 88 95 01 00 00    	js     8047b4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80461f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804623:	48 89 c7             	mov    %rax,%rdi
  804626:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  80462d:	00 00 00 
  804630:	ff d0                	callq  *%rax
  804632:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804635:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804639:	0f 88 5d 01 00 00    	js     80479c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80463f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804643:	ba 07 04 00 00       	mov    $0x407,%edx
  804648:	48 89 c6             	mov    %rax,%rsi
  80464b:	bf 00 00 00 00       	mov    $0x0,%edi
  804650:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  804657:	00 00 00 
  80465a:	ff d0                	callq  *%rax
  80465c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80465f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804663:	0f 88 33 01 00 00    	js     80479c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80466d:	48 89 c7             	mov    %rax,%rdi
  804670:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  804677:	00 00 00 
  80467a:	ff d0                	callq  *%rax
  80467c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804680:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804684:	ba 07 04 00 00       	mov    $0x407,%edx
  804689:	48 89 c6             	mov    %rax,%rsi
  80468c:	bf 00 00 00 00       	mov    $0x0,%edi
  804691:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  804698:	00 00 00 
  80469b:	ff d0                	callq  *%rax
  80469d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046a4:	0f 88 d9 00 00 00    	js     804783 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8046aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046ae:	48 89 c7             	mov    %rax,%rdi
  8046b1:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8046b8:	00 00 00 
  8046bb:	ff d0                	callq  *%rax
  8046bd:	48 89 c2             	mov    %rax,%rdx
  8046c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046c4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8046ca:	48 89 d1             	mov    %rdx,%rcx
  8046cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8046d2:	48 89 c6             	mov    %rax,%rsi
  8046d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8046da:	48 b8 f4 1a 80 00 00 	movabs $0x801af4,%rax
  8046e1:	00 00 00 
  8046e4:	ff d0                	callq  *%rax
  8046e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046ed:	78 79                	js     804768 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8046ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046f3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8046fa:	00 00 00 
  8046fd:	8b 12                	mov    (%rdx),%edx
  8046ff:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804701:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804705:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80470c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804710:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804717:	00 00 00 
  80471a:	8b 12                	mov    (%rdx),%edx
  80471c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80471e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804722:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804729:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472d:	48 89 c7             	mov    %rax,%rdi
  804730:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  804737:	00 00 00 
  80473a:	ff d0                	callq  *%rax
  80473c:	89 c2                	mov    %eax,%edx
  80473e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804742:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804744:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804748:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80474c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804750:	48 89 c7             	mov    %rax,%rdi
  804753:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  80475a:	00 00 00 
  80475d:	ff d0                	callq  *%rax
  80475f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804761:	b8 00 00 00 00       	mov    $0x0,%eax
  804766:	eb 4f                	jmp    8047b7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804768:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  804769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80476d:	48 89 c6             	mov    %rax,%rsi
  804770:	bf 00 00 00 00       	mov    $0x0,%edi
  804775:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  80477c:	00 00 00 
  80477f:	ff d0                	callq  *%rax
  804781:	eb 01                	jmp    804784 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804783:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804784:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804788:	48 89 c6             	mov    %rax,%rsi
  80478b:	bf 00 00 00 00       	mov    $0x0,%edi
  804790:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  804797:	00 00 00 
  80479a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80479c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047a0:	48 89 c6             	mov    %rax,%rsi
  8047a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8047a8:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8047af:	00 00 00 
  8047b2:	ff d0                	callq  *%rax
    err:
	return r;
  8047b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8047b7:	48 83 c4 38          	add    $0x38,%rsp
  8047bb:	5b                   	pop    %rbx
  8047bc:	5d                   	pop    %rbp
  8047bd:	c3                   	retq   

00000000008047be <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8047be:	55                   	push   %rbp
  8047bf:	48 89 e5             	mov    %rsp,%rbp
  8047c2:	53                   	push   %rbx
  8047c3:	48 83 ec 28          	sub    $0x28,%rsp
  8047c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8047cf:	eb 01                	jmp    8047d2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8047d1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8047d2:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8047d9:	00 00 00 
  8047dc:	48 8b 00             	mov    (%rax),%rax
  8047df:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8047e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8047e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047ec:	48 89 c7             	mov    %rax,%rdi
  8047ef:	48 b8 40 52 80 00 00 	movabs $0x805240,%rax
  8047f6:	00 00 00 
  8047f9:	ff d0                	callq  *%rax
  8047fb:	89 c3                	mov    %eax,%ebx
  8047fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804801:	48 89 c7             	mov    %rax,%rdi
  804804:	48 b8 40 52 80 00 00 	movabs $0x805240,%rax
  80480b:	00 00 00 
  80480e:	ff d0                	callq  *%rax
  804810:	39 c3                	cmp    %eax,%ebx
  804812:	0f 94 c0             	sete   %al
  804815:	0f b6 c0             	movzbl %al,%eax
  804818:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80481b:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  804822:	00 00 00 
  804825:	48 8b 00             	mov    (%rax),%rax
  804828:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80482e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804831:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804834:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804837:	75 0a                	jne    804843 <_pipeisclosed+0x85>
			return ret;
  804839:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80483c:	48 83 c4 28          	add    $0x28,%rsp
  804840:	5b                   	pop    %rbx
  804841:	5d                   	pop    %rbp
  804842:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804843:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804846:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804849:	74 86                	je     8047d1 <_pipeisclosed+0x13>
  80484b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80484f:	75 80                	jne    8047d1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804851:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  804858:	00 00 00 
  80485b:	48 8b 00             	mov    (%rax),%rax
  80485e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804864:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804867:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80486a:	89 c6                	mov    %eax,%esi
  80486c:	48 bf 4a 5c 80 00 00 	movabs $0x805c4a,%rdi
  804873:	00 00 00 
  804876:	b8 00 00 00 00       	mov    $0x0,%eax
  80487b:	49 b8 af 05 80 00 00 	movabs $0x8005af,%r8
  804882:	00 00 00 
  804885:	41 ff d0             	callq  *%r8
	}
  804888:	e9 44 ff ff ff       	jmpq   8047d1 <_pipeisclosed+0x13>

000000000080488d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80488d:	55                   	push   %rbp
  80488e:	48 89 e5             	mov    %rsp,%rbp
  804891:	48 83 ec 30          	sub    $0x30,%rsp
  804895:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804898:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80489c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80489f:	48 89 d6             	mov    %rdx,%rsi
  8048a2:	89 c7                	mov    %eax,%edi
  8048a4:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  8048ab:	00 00 00 
  8048ae:	ff d0                	callq  *%rax
  8048b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048b7:	79 05                	jns    8048be <pipeisclosed+0x31>
		return r;
  8048b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048bc:	eb 31                	jmp    8048ef <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8048be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048c2:	48 89 c7             	mov    %rax,%rdi
  8048c5:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8048cc:	00 00 00 
  8048cf:	ff d0                	callq  *%rax
  8048d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8048d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048dd:	48 89 d6             	mov    %rdx,%rsi
  8048e0:	48 89 c7             	mov    %rax,%rdi
  8048e3:	48 b8 be 47 80 00 00 	movabs $0x8047be,%rax
  8048ea:	00 00 00 
  8048ed:	ff d0                	callq  *%rax
}
  8048ef:	c9                   	leaveq 
  8048f0:	c3                   	retq   

00000000008048f1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048f1:	55                   	push   %rbp
  8048f2:	48 89 e5             	mov    %rsp,%rbp
  8048f5:	48 83 ec 40          	sub    $0x40,%rsp
  8048f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804901:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804909:	48 89 c7             	mov    %rax,%rdi
  80490c:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  804913:	00 00 00 
  804916:	ff d0                	callq  *%rax
  804918:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80491c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804920:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804924:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80492b:	00 
  80492c:	e9 97 00 00 00       	jmpq   8049c8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804931:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804936:	74 09                	je     804941 <devpipe_read+0x50>
				return i;
  804938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80493c:	e9 95 00 00 00       	jmpq   8049d6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804941:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804949:	48 89 d6             	mov    %rdx,%rsi
  80494c:	48 89 c7             	mov    %rax,%rdi
  80494f:	48 b8 be 47 80 00 00 	movabs $0x8047be,%rax
  804956:	00 00 00 
  804959:	ff d0                	callq  *%rax
  80495b:	85 c0                	test   %eax,%eax
  80495d:	74 07                	je     804966 <devpipe_read+0x75>
				return 0;
  80495f:	b8 00 00 00 00       	mov    $0x0,%eax
  804964:	eb 70                	jmp    8049d6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804966:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  80496d:	00 00 00 
  804970:	ff d0                	callq  *%rax
  804972:	eb 01                	jmp    804975 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804974:	90                   	nop
  804975:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804979:	8b 10                	mov    (%rax),%edx
  80497b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80497f:	8b 40 04             	mov    0x4(%rax),%eax
  804982:	39 c2                	cmp    %eax,%edx
  804984:	74 ab                	je     804931 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804986:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80498a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80498e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804992:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804996:	8b 00                	mov    (%rax),%eax
  804998:	89 c2                	mov    %eax,%edx
  80499a:	c1 fa 1f             	sar    $0x1f,%edx
  80499d:	c1 ea 1b             	shr    $0x1b,%edx
  8049a0:	01 d0                	add    %edx,%eax
  8049a2:	83 e0 1f             	and    $0x1f,%eax
  8049a5:	29 d0                	sub    %edx,%eax
  8049a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049ab:	48 98                	cltq   
  8049ad:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8049b2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8049b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b8:	8b 00                	mov    (%rax),%eax
  8049ba:	8d 50 01             	lea    0x1(%rax),%edx
  8049bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8049c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049cc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049d0:	72 a2                	jb     804974 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8049d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8049d6:	c9                   	leaveq 
  8049d7:	c3                   	retq   

00000000008049d8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8049d8:	55                   	push   %rbp
  8049d9:	48 89 e5             	mov    %rsp,%rbp
  8049dc:	48 83 ec 40          	sub    $0x40,%rsp
  8049e0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049e4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8049e8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8049ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049f0:	48 89 c7             	mov    %rax,%rdi
  8049f3:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  8049fa:	00 00 00 
  8049fd:	ff d0                	callq  *%rax
  8049ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a0b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a12:	00 
  804a13:	e9 93 00 00 00       	jmpq   804aab <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804a18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a20:	48 89 d6             	mov    %rdx,%rsi
  804a23:	48 89 c7             	mov    %rax,%rdi
  804a26:	48 b8 be 47 80 00 00 	movabs $0x8047be,%rax
  804a2d:	00 00 00 
  804a30:	ff d0                	callq  *%rax
  804a32:	85 c0                	test   %eax,%eax
  804a34:	74 07                	je     804a3d <devpipe_write+0x65>
				return 0;
  804a36:	b8 00 00 00 00       	mov    $0x0,%eax
  804a3b:	eb 7c                	jmp    804ab9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804a3d:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  804a44:	00 00 00 
  804a47:	ff d0                	callq  *%rax
  804a49:	eb 01                	jmp    804a4c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a4b:	90                   	nop
  804a4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a50:	8b 40 04             	mov    0x4(%rax),%eax
  804a53:	48 63 d0             	movslq %eax,%rdx
  804a56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a5a:	8b 00                	mov    (%rax),%eax
  804a5c:	48 98                	cltq   
  804a5e:	48 83 c0 20          	add    $0x20,%rax
  804a62:	48 39 c2             	cmp    %rax,%rdx
  804a65:	73 b1                	jae    804a18 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a6b:	8b 40 04             	mov    0x4(%rax),%eax
  804a6e:	89 c2                	mov    %eax,%edx
  804a70:	c1 fa 1f             	sar    $0x1f,%edx
  804a73:	c1 ea 1b             	shr    $0x1b,%edx
  804a76:	01 d0                	add    %edx,%eax
  804a78:	83 e0 1f             	and    $0x1f,%eax
  804a7b:	29 d0                	sub    %edx,%eax
  804a7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804a85:	48 01 ca             	add    %rcx,%rdx
  804a88:	0f b6 0a             	movzbl (%rdx),%ecx
  804a8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a8f:	48 98                	cltq   
  804a91:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a99:	8b 40 04             	mov    0x4(%rax),%eax
  804a9c:	8d 50 01             	lea    0x1(%rax),%edx
  804a9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aa3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804aa6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804aab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aaf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804ab3:	72 96                	jb     804a4b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804ab5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804ab9:	c9                   	leaveq 
  804aba:	c3                   	retq   

0000000000804abb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804abb:	55                   	push   %rbp
  804abc:	48 89 e5             	mov    %rsp,%rbp
  804abf:	48 83 ec 20          	sub    $0x20,%rsp
  804ac3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ac7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804acf:	48 89 c7             	mov    %rax,%rdi
  804ad2:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  804ad9:	00 00 00 
  804adc:	ff d0                	callq  *%rax
  804ade:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ae6:	48 be 5d 5c 80 00 00 	movabs $0x805c5d,%rsi
  804aed:	00 00 00 
  804af0:	48 89 c7             	mov    %rax,%rdi
  804af3:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  804afa:	00 00 00 
  804afd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b03:	8b 50 04             	mov    0x4(%rax),%edx
  804b06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b0a:	8b 00                	mov    (%rax),%eax
  804b0c:	29 c2                	sub    %eax,%edx
  804b0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b12:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804b18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b1c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804b23:	00 00 00 
	stat->st_dev = &devpipe;
  804b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b2a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804b31:	00 00 00 
  804b34:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804b3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b40:	c9                   	leaveq 
  804b41:	c3                   	retq   

0000000000804b42 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804b42:	55                   	push   %rbp
  804b43:	48 89 e5             	mov    %rsp,%rbp
  804b46:	48 83 ec 10          	sub    $0x10,%rsp
  804b4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804b4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b52:	48 89 c6             	mov    %rax,%rsi
  804b55:	bf 00 00 00 00       	mov    $0x0,%edi
  804b5a:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  804b61:	00 00 00 
  804b64:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804b66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b6a:	48 89 c7             	mov    %rax,%rdi
  804b6d:	48 b8 cb 24 80 00 00 	movabs $0x8024cb,%rax
  804b74:	00 00 00 
  804b77:	ff d0                	callq  *%rax
  804b79:	48 89 c6             	mov    %rax,%rsi
  804b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  804b81:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  804b88:	00 00 00 
  804b8b:	ff d0                	callq  *%rax
}
  804b8d:	c9                   	leaveq 
  804b8e:	c3                   	retq   
	...

0000000000804b90 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804b90:	55                   	push   %rbp
  804b91:	48 89 e5             	mov    %rsp,%rbp
  804b94:	48 83 ec 20          	sub    $0x20,%rsp
  804b98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804b9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b9f:	75 35                	jne    804bd6 <wait+0x46>
  804ba1:	48 b9 64 5c 80 00 00 	movabs $0x805c64,%rcx
  804ba8:	00 00 00 
  804bab:	48 ba 6f 5c 80 00 00 	movabs $0x805c6f,%rdx
  804bb2:	00 00 00 
  804bb5:	be 09 00 00 00       	mov    $0x9,%esi
  804bba:	48 bf 84 5c 80 00 00 	movabs $0x805c84,%rdi
  804bc1:	00 00 00 
  804bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  804bc9:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  804bd0:	00 00 00 
  804bd3:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804bd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bd9:	48 98                	cltq   
  804bdb:	48 89 c2             	mov    %rax,%rdx
  804bde:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804be4:	48 89 d0             	mov    %rdx,%rax
  804be7:	48 c1 e0 03          	shl    $0x3,%rax
  804beb:	48 01 d0             	add    %rdx,%rax
  804bee:	48 c1 e0 05          	shl    $0x5,%rax
  804bf2:	48 89 c2             	mov    %rax,%rdx
  804bf5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804bfc:	00 00 00 
  804bff:	48 01 d0             	add    %rdx,%rax
  804c02:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804c06:	eb 0c                	jmp    804c14 <wait+0x84>
		sys_yield();
  804c08:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  804c0f:	00 00 00 
  804c12:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c18:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804c1e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c21:	75 0e                	jne    804c31 <wait+0xa1>
  804c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c27:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804c2d:	85 c0                	test   %eax,%eax
  804c2f:	75 d7                	jne    804c08 <wait+0x78>
		sys_yield();
}
  804c31:	c9                   	leaveq 
  804c32:	c3                   	retq   
	...

0000000000804c34 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804c34:	55                   	push   %rbp
  804c35:	48 89 e5             	mov    %rsp,%rbp
  804c38:	48 83 ec 20          	sub    $0x20,%rsp
  804c3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804c3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804c42:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804c45:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804c49:	be 01 00 00 00       	mov    $0x1,%esi
  804c4e:	48 89 c7             	mov    %rax,%rdi
  804c51:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  804c58:	00 00 00 
  804c5b:	ff d0                	callq  *%rax
}
  804c5d:	c9                   	leaveq 
  804c5e:	c3                   	retq   

0000000000804c5f <getchar>:

int
getchar(void)
{
  804c5f:	55                   	push   %rbp
  804c60:	48 89 e5             	mov    %rsp,%rbp
  804c63:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804c67:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804c6b:	ba 01 00 00 00       	mov    $0x1,%edx
  804c70:	48 89 c6             	mov    %rax,%rsi
  804c73:	bf 00 00 00 00       	mov    $0x0,%edi
  804c78:	48 b8 c0 29 80 00 00 	movabs $0x8029c0,%rax
  804c7f:	00 00 00 
  804c82:	ff d0                	callq  *%rax
  804c84:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804c87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c8b:	79 05                	jns    804c92 <getchar+0x33>
		return r;
  804c8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c90:	eb 14                	jmp    804ca6 <getchar+0x47>
	if (r < 1)
  804c92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c96:	7f 07                	jg     804c9f <getchar+0x40>
		return -E_EOF;
  804c98:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804c9d:	eb 07                	jmp    804ca6 <getchar+0x47>
	return c;
  804c9f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804ca3:	0f b6 c0             	movzbl %al,%eax
}
  804ca6:	c9                   	leaveq 
  804ca7:	c3                   	retq   

0000000000804ca8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804ca8:	55                   	push   %rbp
  804ca9:	48 89 e5             	mov    %rsp,%rbp
  804cac:	48 83 ec 20          	sub    $0x20,%rsp
  804cb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804cb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804cb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804cba:	48 89 d6             	mov    %rdx,%rsi
  804cbd:	89 c7                	mov    %eax,%edi
  804cbf:	48 b8 8e 25 80 00 00 	movabs $0x80258e,%rax
  804cc6:	00 00 00 
  804cc9:	ff d0                	callq  *%rax
  804ccb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cd2:	79 05                	jns    804cd9 <iscons+0x31>
		return r;
  804cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cd7:	eb 1a                	jmp    804cf3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804cdd:	8b 10                	mov    (%rax),%edx
  804cdf:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804ce6:	00 00 00 
  804ce9:	8b 00                	mov    (%rax),%eax
  804ceb:	39 c2                	cmp    %eax,%edx
  804ced:	0f 94 c0             	sete   %al
  804cf0:	0f b6 c0             	movzbl %al,%eax
}
  804cf3:	c9                   	leaveq 
  804cf4:	c3                   	retq   

0000000000804cf5 <opencons>:

int
opencons(void)
{
  804cf5:	55                   	push   %rbp
  804cf6:	48 89 e5             	mov    %rsp,%rbp
  804cf9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804cfd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804d01:	48 89 c7             	mov    %rax,%rdi
  804d04:	48 b8 f6 24 80 00 00 	movabs $0x8024f6,%rax
  804d0b:	00 00 00 
  804d0e:	ff d0                	callq  *%rax
  804d10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d17:	79 05                	jns    804d1e <opencons+0x29>
		return r;
  804d19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d1c:	eb 5b                	jmp    804d79 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d22:	ba 07 04 00 00       	mov    $0x407,%edx
  804d27:	48 89 c6             	mov    %rax,%rsi
  804d2a:	bf 00 00 00 00       	mov    $0x0,%edi
  804d2f:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  804d36:	00 00 00 
  804d39:	ff d0                	callq  *%rax
  804d3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d42:	79 05                	jns    804d49 <opencons+0x54>
		return r;
  804d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d47:	eb 30                	jmp    804d79 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d4d:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804d54:	00 00 00 
  804d57:	8b 12                	mov    (%rdx),%edx
  804d59:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d5f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804d66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d6a:	48 89 c7             	mov    %rax,%rdi
  804d6d:	48 b8 a8 24 80 00 00 	movabs $0x8024a8,%rax
  804d74:	00 00 00 
  804d77:	ff d0                	callq  *%rax
}
  804d79:	c9                   	leaveq 
  804d7a:	c3                   	retq   

0000000000804d7b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804d7b:	55                   	push   %rbp
  804d7c:	48 89 e5             	mov    %rsp,%rbp
  804d7f:	48 83 ec 30          	sub    $0x30,%rsp
  804d83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804d87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804d8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804d8f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804d94:	75 13                	jne    804da9 <devcons_read+0x2e>
		return 0;
  804d96:	b8 00 00 00 00       	mov    $0x0,%eax
  804d9b:	eb 49                	jmp    804de6 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804d9d:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  804da4:	00 00 00 
  804da7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804da9:	48 b8 a6 19 80 00 00 	movabs $0x8019a6,%rax
  804db0:	00 00 00 
  804db3:	ff d0                	callq  *%rax
  804db5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dbc:	74 df                	je     804d9d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dc2:	79 05                	jns    804dc9 <devcons_read+0x4e>
		return c;
  804dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dc7:	eb 1d                	jmp    804de6 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804dc9:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804dcd:	75 07                	jne    804dd6 <devcons_read+0x5b>
		return 0;
  804dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  804dd4:	eb 10                	jmp    804de6 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dd9:	89 c2                	mov    %eax,%edx
  804ddb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ddf:	88 10                	mov    %dl,(%rax)
	return 1;
  804de1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804de6:	c9                   	leaveq 
  804de7:	c3                   	retq   

0000000000804de8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804de8:	55                   	push   %rbp
  804de9:	48 89 e5             	mov    %rsp,%rbp
  804dec:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804df3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804dfa:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804e01:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e0f:	eb 77                	jmp    804e88 <devcons_write+0xa0>
		m = n - tot;
  804e11:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804e18:	89 c2                	mov    %eax,%edx
  804e1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e1d:	89 d1                	mov    %edx,%ecx
  804e1f:	29 c1                	sub    %eax,%ecx
  804e21:	89 c8                	mov    %ecx,%eax
  804e23:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804e26:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e29:	83 f8 7f             	cmp    $0x7f,%eax
  804e2c:	76 07                	jbe    804e35 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804e2e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804e35:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e38:	48 63 d0             	movslq %eax,%rdx
  804e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e3e:	48 98                	cltq   
  804e40:	48 89 c1             	mov    %rax,%rcx
  804e43:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804e4a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e51:	48 89 ce             	mov    %rcx,%rsi
  804e54:	48 89 c7             	mov    %rax,%rdi
  804e57:	48 b8 8e 14 80 00 00 	movabs $0x80148e,%rax
  804e5e:	00 00 00 
  804e61:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804e63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e66:	48 63 d0             	movslq %eax,%rdx
  804e69:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804e70:	48 89 d6             	mov    %rdx,%rsi
  804e73:	48 89 c7             	mov    %rax,%rdi
  804e76:	48 b8 5c 19 80 00 00 	movabs $0x80195c,%rax
  804e7d:	00 00 00 
  804e80:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804e82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e85:	01 45 fc             	add    %eax,-0x4(%rbp)
  804e88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e8b:	48 98                	cltq   
  804e8d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804e94:	0f 82 77 ff ff ff    	jb     804e11 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804e9d:	c9                   	leaveq 
  804e9e:	c3                   	retq   

0000000000804e9f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804e9f:	55                   	push   %rbp
  804ea0:	48 89 e5             	mov    %rsp,%rbp
  804ea3:	48 83 ec 08          	sub    $0x8,%rsp
  804ea7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804eb0:	c9                   	leaveq 
  804eb1:	c3                   	retq   

0000000000804eb2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804eb2:	55                   	push   %rbp
  804eb3:	48 89 e5             	mov    %rsp,%rbp
  804eb6:	48 83 ec 10          	sub    $0x10,%rsp
  804eba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804ebe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ec6:	48 be 94 5c 80 00 00 	movabs $0x805c94,%rsi
  804ecd:	00 00 00 
  804ed0:	48 89 c7             	mov    %rax,%rdi
  804ed3:	48 b8 6c 11 80 00 00 	movabs $0x80116c,%rax
  804eda:	00 00 00 
  804edd:	ff d0                	callq  *%rax
	return 0;
  804edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ee4:	c9                   	leaveq 
  804ee5:	c3                   	retq   
	...

0000000000804ee8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804ee8:	55                   	push   %rbp
  804ee9:	48 89 e5             	mov    %rsp,%rbp
  804eec:	48 83 ec 20          	sub    $0x20,%rsp
  804ef0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804ef4:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804efb:	00 00 00 
  804efe:	48 8b 00             	mov    (%rax),%rax
  804f01:	48 85 c0             	test   %rax,%rax
  804f04:	0f 85 8e 00 00 00    	jne    804f98 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  804f0a:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804f11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804f18:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  804f1f:	00 00 00 
  804f22:	ff d0                	callq  *%rax
  804f24:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804f27:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804f2b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f2e:	ba 07 00 00 00       	mov    $0x7,%edx
  804f33:	48 89 ce             	mov    %rcx,%rsi
  804f36:	89 c7                	mov    %eax,%edi
  804f38:	48 b8 a4 1a 80 00 00 	movabs $0x801aa4,%rax
  804f3f:	00 00 00 
  804f42:	ff d0                	callq  *%rax
  804f44:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804f4b:	74 30                	je     804f7d <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  804f4d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804f50:	89 c1                	mov    %eax,%ecx
  804f52:	48 ba a0 5c 80 00 00 	movabs $0x805ca0,%rdx
  804f59:	00 00 00 
  804f5c:	be 24 00 00 00       	mov    $0x24,%esi
  804f61:	48 bf d7 5c 80 00 00 	movabs $0x805cd7,%rdi
  804f68:	00 00 00 
  804f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  804f70:	49 b8 74 03 80 00 00 	movabs $0x800374,%r8
  804f77:	00 00 00 
  804f7a:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804f7d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804f80:	48 be ac 4f 80 00 00 	movabs $0x804fac,%rsi
  804f87:	00 00 00 
  804f8a:	89 c7                	mov    %eax,%edi
  804f8c:	48 b8 2e 1c 80 00 00 	movabs $0x801c2e,%rax
  804f93:	00 00 00 
  804f96:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804f98:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804f9f:	00 00 00 
  804fa2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804fa6:	48 89 10             	mov    %rdx,(%rax)
}
  804fa9:	c9                   	leaveq 
  804faa:	c3                   	retq   
	...

0000000000804fac <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804fac:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804faf:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804fb6:	00 00 00 
	call *%rax
  804fb9:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  804fbb:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804fbf:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804fc3:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  804fc6:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804fcd:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804fce:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804fd3:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  804fd6:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  804fd7:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  804fda:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804fe1:	00 08 
		POPA_						// copy the register contents to the registers
  804fe3:	4c 8b 3c 24          	mov    (%rsp),%r15
  804fe7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804fec:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804ff1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804ff6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804ffb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805000:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805005:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80500a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80500f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805014:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805019:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80501e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805023:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805028:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80502d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  805031:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  805035:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  805036:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  805037:	c3                   	retq   

0000000000805038 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805038:	55                   	push   %rbp
  805039:	48 89 e5             	mov    %rsp,%rbp
  80503c:	48 83 ec 30          	sub    $0x30,%rsp
  805040:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805048:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  80504c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805051:	74 18                	je     80506b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  805053:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805057:	48 89 c7             	mov    %rax,%rdi
  80505a:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  805061:	00 00 00 
  805064:	ff d0                	callq  *%rax
  805066:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805069:	eb 19                	jmp    805084 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80506b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  805072:	00 00 00 
  805075:	48 b8 cd 1c 80 00 00 	movabs $0x801ccd,%rax
  80507c:	00 00 00 
  80507f:	ff d0                	callq  *%rax
  805081:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  805084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805088:	79 19                	jns    8050a3 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80508a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80508e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  805094:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805098:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80509e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050a1:	eb 53                	jmp    8050f6 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8050a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8050a8:	74 19                	je     8050c3 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8050aa:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8050b1:	00 00 00 
  8050b4:	48 8b 00             	mov    (%rax),%rax
  8050b7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8050bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050c1:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8050c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8050c8:	74 19                	je     8050e3 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8050ca:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8050d1:	00 00 00 
  8050d4:	48 8b 00             	mov    (%rax),%rax
  8050d7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8050dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8050e1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8050e3:	48 b8 50 80 80 00 00 	movabs $0x808050,%rax
  8050ea:	00 00 00 
  8050ed:	48 8b 00             	mov    (%rax),%rax
  8050f0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8050f6:	c9                   	leaveq 
  8050f7:	c3                   	retq   

00000000008050f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8050f8:	55                   	push   %rbp
  8050f9:	48 89 e5             	mov    %rsp,%rbp
  8050fc:	48 83 ec 30          	sub    $0x30,%rsp
  805100:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805103:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805106:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80510a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  80510d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  805114:	e9 96 00 00 00       	jmpq   8051af <ipc_send+0xb7>
	{
		if(pg!=NULL)
  805119:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80511e:	74 20                	je     805140 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  805120:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805123:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805126:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80512a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80512d:	89 c7                	mov    %eax,%edi
  80512f:	48 b8 78 1c 80 00 00 	movabs $0x801c78,%rax
  805136:	00 00 00 
  805139:	ff d0                	callq  *%rax
  80513b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80513e:	eb 2d                	jmp    80516d <ipc_send+0x75>
		else if(pg==NULL)
  805140:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805145:	75 26                	jne    80516d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  805147:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80514a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80514d:	b9 00 00 00 00       	mov    $0x0,%ecx
  805152:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805159:	00 00 00 
  80515c:	89 c7                	mov    %eax,%edi
  80515e:	48 b8 78 1c 80 00 00 	movabs $0x801c78,%rax
  805165:	00 00 00 
  805168:	ff d0                	callq  *%rax
  80516a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  80516d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805171:	79 30                	jns    8051a3 <ipc_send+0xab>
  805173:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  805177:	74 2a                	je     8051a3 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  805179:	48 ba e5 5c 80 00 00 	movabs $0x805ce5,%rdx
  805180:	00 00 00 
  805183:	be 40 00 00 00       	mov    $0x40,%esi
  805188:	48 bf fd 5c 80 00 00 	movabs $0x805cfd,%rdi
  80518f:	00 00 00 
  805192:	b8 00 00 00 00       	mov    $0x0,%eax
  805197:	48 b9 74 03 80 00 00 	movabs $0x800374,%rcx
  80519e:	00 00 00 
  8051a1:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8051a3:	48 b8 66 1a 80 00 00 	movabs $0x801a66,%rax
  8051aa:	00 00 00 
  8051ad:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8051af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051b3:	0f 85 60 ff ff ff    	jne    805119 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8051b9:	c9                   	leaveq 
  8051ba:	c3                   	retq   

00000000008051bb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8051bb:	55                   	push   %rbp
  8051bc:	48 89 e5             	mov    %rsp,%rbp
  8051bf:	48 83 ec 18          	sub    $0x18,%rsp
  8051c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8051c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8051cd:	eb 5e                	jmp    80522d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8051cf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8051d6:	00 00 00 
  8051d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051dc:	48 63 d0             	movslq %eax,%rdx
  8051df:	48 89 d0             	mov    %rdx,%rax
  8051e2:	48 c1 e0 03          	shl    $0x3,%rax
  8051e6:	48 01 d0             	add    %rdx,%rax
  8051e9:	48 c1 e0 05          	shl    $0x5,%rax
  8051ed:	48 01 c8             	add    %rcx,%rax
  8051f0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8051f6:	8b 00                	mov    (%rax),%eax
  8051f8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8051fb:	75 2c                	jne    805229 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8051fd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  805204:	00 00 00 
  805207:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80520a:	48 63 d0             	movslq %eax,%rdx
  80520d:	48 89 d0             	mov    %rdx,%rax
  805210:	48 c1 e0 03          	shl    $0x3,%rax
  805214:	48 01 d0             	add    %rdx,%rax
  805217:	48 c1 e0 05          	shl    $0x5,%rax
  80521b:	48 01 c8             	add    %rcx,%rax
  80521e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805224:	8b 40 08             	mov    0x8(%rax),%eax
  805227:	eb 12                	jmp    80523b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  805229:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80522d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805234:	7e 99                	jle    8051cf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  805236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80523b:	c9                   	leaveq 
  80523c:	c3                   	retq   
  80523d:	00 00                	add    %al,(%rax)
	...

0000000000805240 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805240:	55                   	push   %rbp
  805241:	48 89 e5             	mov    %rsp,%rbp
  805244:	48 83 ec 18          	sub    $0x18,%rsp
  805248:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80524c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805250:	48 89 c2             	mov    %rax,%rdx
  805253:	48 c1 ea 15          	shr    $0x15,%rdx
  805257:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80525e:	01 00 00 
  805261:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805265:	83 e0 01             	and    $0x1,%eax
  805268:	48 85 c0             	test   %rax,%rax
  80526b:	75 07                	jne    805274 <pageref+0x34>
		return 0;
  80526d:	b8 00 00 00 00       	mov    $0x0,%eax
  805272:	eb 53                	jmp    8052c7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  805274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805278:	48 89 c2             	mov    %rax,%rdx
  80527b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80527f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805286:	01 00 00 
  805289:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80528d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805295:	83 e0 01             	and    $0x1,%eax
  805298:	48 85 c0             	test   %rax,%rax
  80529b:	75 07                	jne    8052a4 <pageref+0x64>
		return 0;
  80529d:	b8 00 00 00 00       	mov    $0x0,%eax
  8052a2:	eb 23                	jmp    8052c7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8052a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052a8:	48 89 c2             	mov    %rax,%rdx
  8052ab:	48 c1 ea 0c          	shr    $0xc,%rdx
  8052af:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8052b6:	00 00 00 
  8052b9:	48 c1 e2 04          	shl    $0x4,%rdx
  8052bd:	48 01 d0             	add    %rdx,%rax
  8052c0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8052c4:	0f b7 c0             	movzwl %ax,%eax
}
  8052c7:	c9                   	leaveq 
  8052c8:	c3                   	retq   
