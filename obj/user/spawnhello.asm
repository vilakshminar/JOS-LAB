
obj/user/spawnhello.debug:     file format elf64-x86-64


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
  80003c:	e8 a7 00 00 00       	callq  8000e8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800053:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80005a:	00 00 00 
  80005d:	48 8b 00             	mov    (%rax),%rax
  800060:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800066:	89 c6                	mov    %eax,%esi
  800068:	48 bf 60 48 80 00 00 	movabs $0x804860,%rdi
  80006f:	00 00 00 
  800072:	b8 00 00 00 00       	mov    $0x0,%eax
  800077:	48 ba eb 03 80 00 00 	movabs $0x8003eb,%rdx
  80007e:	00 00 00 
  800081:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800083:	ba 00 00 00 00       	mov    $0x0,%edx
  800088:	48 be 7e 48 80 00 00 	movabs $0x80487e,%rsi
  80008f:	00 00 00 
  800092:	48 bf 84 48 80 00 00 	movabs $0x804884,%rdi
  800099:	00 00 00 
  80009c:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a1:	48 b9 95 2c 80 00 00 	movabs $0x802c95,%rcx
  8000a8:	00 00 00 
  8000ab:	ff d1                	callq  *%rcx
  8000ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b4:	79 30                	jns    8000e6 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b9:	89 c1                	mov    %eax,%ecx
  8000bb:	48 ba 8f 48 80 00 00 	movabs $0x80488f,%rdx
  8000c2:	00 00 00 
  8000c5:	be 09 00 00 00       	mov    $0x9,%esi
  8000ca:	48 bf a7 48 80 00 00 	movabs $0x8048a7,%rdi
  8000d1:	00 00 00 
  8000d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d9:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  8000e0:	00 00 00 
  8000e3:	41 ff d0             	callq  *%r8
}
  8000e6:	c9                   	leaveq 
  8000e7:	c3                   	retq   

00000000008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %rbp
  8000e9:	48 89 e5             	mov    %rsp,%rbp
  8000ec:	48 83 ec 10          	sub    $0x10,%rsp
  8000f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000f7:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8000fe:	00 00 00 
  800101:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800108:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
  800114:	48 98                	cltq   
  800116:	48 89 c2             	mov    %rax,%rdx
  800119:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80011f:	48 89 d0             	mov    %rdx,%rax
  800122:	48 c1 e0 03          	shl    $0x3,%rax
  800126:	48 01 d0             	add    %rdx,%rax
  800129:	48 c1 e0 05          	shl    $0x5,%rax
  80012d:	48 89 c2             	mov    %rax,%rdx
  800130:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800137:	00 00 00 
  80013a:	48 01 c2             	add    %rax,%rdx
  80013d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800144:	00 00 00 
  800147:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80014e:	7e 14                	jle    800164 <libmain+0x7c>
		binaryname = argv[0];
  800150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800154:	48 8b 10             	mov    (%rax),%rdx
  800157:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80015e:	00 00 00 
  800161:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800164:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800168:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80016b:	48 89 d6             	mov    %rdx,%rsi
  80016e:	89 c7                	mov    %eax,%edi
  800170:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800177:	00 00 00 
  80017a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80017c:	48 b8 8c 01 80 00 00 	movabs $0x80018c,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
}
  800188:	c9                   	leaveq 
  800189:	c3                   	retq   
	...

000000000080018c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018c:	55                   	push   %rbp
  80018d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800190:	48 b8 61 1f 80 00 00 	movabs $0x801f61,%rax
  800197:	00 00 00 
  80019a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80019c:	bf 00 00 00 00       	mov    $0x0,%edi
  8001a1:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8001a8:	00 00 00 
  8001ab:	ff d0                	callq  *%rax
}
  8001ad:	5d                   	pop    %rbp
  8001ae:	c3                   	retq   
	...

00000000008001b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b0:	55                   	push   %rbp
  8001b1:	48 89 e5             	mov    %rsp,%rbp
  8001b4:	53                   	push   %rbx
  8001b5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001bc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001c3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001c9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001d0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001d7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001de:	84 c0                	test   %al,%al
  8001e0:	74 23                	je     800205 <_panic+0x55>
  8001e2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001e9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001ed:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001f1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001f5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001f9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001fd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800201:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800205:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80020c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800213:	00 00 00 
  800216:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80021d:	00 00 00 
  800220:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800224:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80022b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800232:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800239:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800240:	00 00 00 
  800243:	48 8b 18             	mov    (%rax),%rbx
  800246:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80024d:	00 00 00 
  800250:	ff d0                	callq  *%rax
  800252:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800258:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80025f:	41 89 c8             	mov    %ecx,%r8d
  800262:	48 89 d1             	mov    %rdx,%rcx
  800265:	48 89 da             	mov    %rbx,%rdx
  800268:	89 c6                	mov    %eax,%esi
  80026a:	48 bf c8 48 80 00 00 	movabs $0x8048c8,%rdi
  800271:	00 00 00 
  800274:	b8 00 00 00 00       	mov    $0x0,%eax
  800279:	49 b9 eb 03 80 00 00 	movabs $0x8003eb,%r9
  800280:	00 00 00 
  800283:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80028d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800294:	48 89 d6             	mov    %rdx,%rsi
  800297:	48 89 c7             	mov    %rax,%rdi
  80029a:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
	cprintf("\n");
  8002a6:	48 bf eb 48 80 00 00 	movabs $0x8048eb,%rdi
  8002ad:	00 00 00 
  8002b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b5:	48 ba eb 03 80 00 00 	movabs $0x8003eb,%rdx
  8002bc:	00 00 00 
  8002bf:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002c1:	cc                   	int3   
  8002c2:	eb fd                	jmp    8002c1 <_panic+0x111>

00000000008002c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002c4:	55                   	push   %rbp
  8002c5:	48 89 e5             	mov    %rsp,%rbp
  8002c8:	48 83 ec 10          	sub    $0x10,%rsp
  8002cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8002d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d7:	8b 00                	mov    (%rax),%eax
  8002d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002dc:	89 d6                	mov    %edx,%esi
  8002de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8002e2:	48 63 d0             	movslq %eax,%rdx
  8002e5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8002ea:	8d 50 01             	lea    0x1(%rax),%edx
  8002ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8002f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f7:	8b 00                	mov    (%rax),%eax
  8002f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fe:	75 2c                	jne    80032c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800304:	8b 00                	mov    (%rax),%eax
  800306:	48 98                	cltq   
  800308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030c:	48 83 c2 08          	add    $0x8,%rdx
  800310:	48 89 c6             	mov    %rax,%rsi
  800313:	48 89 d7             	mov    %rdx,%rdi
  800316:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
		b->idx = 0;
  800322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800326:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80032c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800330:	8b 40 04             	mov    0x4(%rax),%eax
  800333:	8d 50 01             	lea    0x1(%rax),%edx
  800336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80033a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80033d:	c9                   	leaveq 
  80033e:	c3                   	retq   

000000000080033f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033f:	55                   	push   %rbp
  800340:	48 89 e5             	mov    %rsp,%rbp
  800343:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80034a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800351:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800358:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80035f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800366:	48 8b 0a             	mov    (%rdx),%rcx
  800369:	48 89 08             	mov    %rcx,(%rax)
  80036c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800370:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800374:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800378:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80037c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800383:	00 00 00 
	b.cnt = 0;
  800386:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80038d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800390:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800397:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80039e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003a5:	48 89 c6             	mov    %rax,%rsi
  8003a8:	48 bf c4 02 80 00 00 	movabs $0x8002c4,%rdi
  8003af:	00 00 00 
  8003b2:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8003be:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003c4:	48 98                	cltq   
  8003c6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003cd:	48 83 c2 08          	add    $0x8,%rdx
  8003d1:	48 89 c6             	mov    %rax,%rsi
  8003d4:	48 89 d7             	mov    %rdx,%rdi
  8003d7:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003f6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003fd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800404:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80040b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800412:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800419:	84 c0                	test   %al,%al
  80041b:	74 20                	je     80043d <cprintf+0x52>
  80041d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800421:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800425:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800429:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800431:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800435:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800439:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80043d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800444:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80044b:	00 00 00 
  80044e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800455:	00 00 00 
  800458:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80045c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800463:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80046a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800471:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800478:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80047f:	48 8b 0a             	mov    (%rdx),%rcx
  800482:	48 89 08             	mov    %rcx,(%rax)
  800485:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800489:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80048d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800491:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800495:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80049c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004a3:	48 89 d6             	mov    %rdx,%rsi
  8004a6:	48 89 c7             	mov    %rax,%rdi
  8004a9:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
  8004b5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004bb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004c1:	c9                   	leaveq 
  8004c2:	c3                   	retq   
	...

00000000008004c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c4:	55                   	push   %rbp
  8004c5:	48 89 e5             	mov    %rsp,%rbp
  8004c8:	48 83 ec 30          	sub    $0x30,%rsp
  8004cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004d8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004db:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004df:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004e6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004ea:	77 52                	ja     80053e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004ef:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004f3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004f6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800503:	48 f7 75 d0          	divq   -0x30(%rbp)
  800507:	48 89 c2             	mov    %rax,%rdx
  80050a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80050d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800510:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800518:	41 89 f9             	mov    %edi,%r9d
  80051b:	48 89 c7             	mov    %rax,%rdi
  80051e:	48 b8 c4 04 80 00 00 	movabs $0x8004c4,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
  80052a:	eb 1c                	jmp    800548 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800530:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800533:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800537:	48 89 d6             	mov    %rdx,%rsi
  80053a:	89 c7                	mov    %eax,%edi
  80053c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800542:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800546:	7f e4                	jg     80052c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800548:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	ba 00 00 00 00       	mov    $0x0,%edx
  800554:	48 f7 f1             	div    %rcx
  800557:	48 89 d0             	mov    %rdx,%rax
  80055a:	48 ba c8 4a 80 00 00 	movabs $0x804ac8,%rdx
  800561:	00 00 00 
  800564:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800568:	0f be c0             	movsbl %al,%eax
  80056b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800573:	48 89 d6             	mov    %rdx,%rsi
  800576:	89 c7                	mov    %eax,%edi
  800578:	ff d1                	callq  *%rcx
}
  80057a:	c9                   	leaveq 
  80057b:	c3                   	retq   

000000000080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	48 83 ec 20          	sub    $0x20,%rsp
  800584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80058b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80058f:	7e 52                	jle    8005e3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	8b 00                	mov    (%rax),%eax
  800597:	83 f8 30             	cmp    $0x30,%eax
  80059a:	73 24                	jae    8005c0 <getuint+0x44>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	8b 00                	mov    (%rax),%eax
  8005aa:	89 c0                	mov    %eax,%eax
  8005ac:	48 01 d0             	add    %rdx,%rax
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	8b 12                	mov    (%rdx),%edx
  8005b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	89 0a                	mov    %ecx,(%rdx)
  8005be:	eb 17                	jmp    8005d7 <getuint+0x5b>
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c8:	48 89 d0             	mov    %rdx,%rax
  8005cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d7:	48 8b 00             	mov    (%rax),%rax
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005de:	e9 a3 00 00 00       	jmpq   800686 <getuint+0x10a>
	else if (lflag)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e7:	74 4f                	je     800638 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getuint+0x9c>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 17                	jmp    80062f <getuint+0xb3>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800620:	48 89 d0             	mov    %rdx,%rax
  800623:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062f:	48 8b 00             	mov    (%rax),%rax
  800632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800636:	eb 4e                	jmp    800686 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getuint+0xeb>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getuint+0x102>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	89 c0                	mov    %eax,%eax
  800682:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068a:	c9                   	leaveq 
  80068b:	c3                   	retq   

000000000080068c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068c:	55                   	push   %rbp
  80068d:	48 89 e5             	mov    %rsp,%rbp
  800690:	48 83 ec 20          	sub    $0x20,%rsp
  800694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800698:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80069b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80069f:	7e 52                	jle    8006f3 <getint+0x67>
		x=va_arg(*ap, long long);
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	8b 00                	mov    (%rax),%eax
  8006a7:	83 f8 30             	cmp    $0x30,%eax
  8006aa:	73 24                	jae    8006d0 <getint+0x44>
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	8b 00                	mov    (%rax),%eax
  8006ba:	89 c0                	mov    %eax,%eax
  8006bc:	48 01 d0             	add    %rdx,%rax
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	8b 12                	mov    (%rdx),%edx
  8006c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cc:	89 0a                	mov    %ecx,(%rdx)
  8006ce:	eb 17                	jmp    8006e7 <getint+0x5b>
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d8:	48 89 d0             	mov    %rdx,%rax
  8006db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e7:	48 8b 00             	mov    (%rax),%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ee:	e9 a3 00 00 00       	jmpq   800796 <getint+0x10a>
	else if (lflag)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006f7:	74 4f                	je     800748 <getint+0xbc>
		x=va_arg(*ap, long);
  8006f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fd:	8b 00                	mov    (%rax),%eax
  8006ff:	83 f8 30             	cmp    $0x30,%eax
  800702:	73 24                	jae    800728 <getint+0x9c>
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	8b 00                	mov    (%rax),%eax
  800712:	89 c0                	mov    %eax,%eax
  800714:	48 01 d0             	add    %rdx,%rax
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	8b 12                	mov    (%rdx),%edx
  80071d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800720:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800724:	89 0a                	mov    %ecx,(%rdx)
  800726:	eb 17                	jmp    80073f <getint+0xb3>
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800730:	48 89 d0             	mov    %rdx,%rax
  800733:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073f:	48 8b 00             	mov    (%rax),%rax
  800742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800746:	eb 4e                	jmp    800796 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	83 f8 30             	cmp    $0x30,%eax
  800751:	73 24                	jae    800777 <getint+0xeb>
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	89 c0                	mov    %eax,%eax
  800763:	48 01 d0             	add    %rdx,%rax
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	8b 12                	mov    (%rdx),%edx
  80076c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80076f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800773:	89 0a                	mov    %ecx,(%rdx)
  800775:	eb 17                	jmp    80078e <getint+0x102>
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80077f:	48 89 d0             	mov    %rdx,%rax
  800782:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	48 98                	cltq   
  800792:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80079a:	c9                   	leaveq 
  80079b:	c3                   	retq   

000000000080079c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079c:	55                   	push   %rbp
  80079d:	48 89 e5             	mov    %rsp,%rbp
  8007a0:	41 54                	push   %r12
  8007a2:	53                   	push   %rbx
  8007a3:	48 83 ec 60          	sub    $0x60,%rsp
  8007a7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007ab:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8007af:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007b3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007b7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007bb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007bf:	48 8b 0a             	mov    (%rdx),%rcx
  8007c2:	48 89 08             	mov    %rcx,(%rax)
  8007c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	eb 17                	jmp    8007ee <vprintfmt+0x52>
			if (ch == '\0')
  8007d7:	85 db                	test   %ebx,%ebx
  8007d9:	0f 84 d7 04 00 00    	je     800cb6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8007df:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007e3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8007e7:	48 89 c6             	mov    %rax,%rsi
  8007ea:	89 df                	mov    %ebx,%edi
  8007ec:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f2:	0f b6 00             	movzbl (%rax),%eax
  8007f5:	0f b6 d8             	movzbl %al,%ebx
  8007f8:	83 fb 25             	cmp    $0x25,%ebx
  8007fb:	0f 95 c0             	setne  %al
  8007fe:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800803:	84 c0                	test   %al,%al
  800805:	75 d0                	jne    8007d7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800807:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80080b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800812:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800819:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800820:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800827:	eb 04                	jmp    80082d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800829:	90                   	nop
  80082a:	eb 01                	jmp    80082d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80082c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800831:	0f b6 00             	movzbl (%rax),%eax
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	89 d8                	mov    %ebx,%eax
  800839:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80083e:	83 e8 23             	sub    $0x23,%eax
  800841:	83 f8 55             	cmp    $0x55,%eax
  800844:	0f 87 38 04 00 00    	ja     800c82 <vprintfmt+0x4e6>
  80084a:	89 c0                	mov    %eax,%eax
  80084c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800853:	00 
  800854:	48 b8 f0 4a 80 00 00 	movabs $0x804af0,%rax
  80085b:	00 00 00 
  80085e:	48 01 d0             	add    %rdx,%rax
  800861:	48 8b 00             	mov    (%rax),%rax
  800864:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800866:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80086a:	eb c1                	jmp    80082d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800870:	eb bb                	jmp    80082d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800872:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800879:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	c1 e0 02             	shl    $0x2,%eax
  800881:	01 d0                	add    %edx,%eax
  800883:	01 c0                	add    %eax,%eax
  800885:	01 d8                	add    %ebx,%eax
  800887:	83 e8 30             	sub    $0x30,%eax
  80088a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80088d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800891:	0f b6 00             	movzbl (%rax),%eax
  800894:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800897:	83 fb 2f             	cmp    $0x2f,%ebx
  80089a:	7e 63                	jle    8008ff <vprintfmt+0x163>
  80089c:	83 fb 39             	cmp    $0x39,%ebx
  80089f:	7f 5e                	jg     8008ff <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a6:	eb d1                	jmp    800879 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 17                	jae    8008c7 <vprintfmt+0x12b>
  8008b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	89 c0                	mov    %eax,%eax
  8008b9:	48 01 d0             	add    %rdx,%rax
  8008bc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008bf:	83 c2 08             	add    $0x8,%edx
  8008c2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c5:	eb 0f                	jmp    8008d6 <vprintfmt+0x13a>
  8008c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 83 c2 08          	add    $0x8,%rdx
  8008d2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008db:	eb 23                	jmp    800900 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8008dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e1:	0f 89 42 ff ff ff    	jns    800829 <vprintfmt+0x8d>
				width = 0;
  8008e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008ee:	e9 36 ff ff ff       	jmpq   800829 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8008f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008fa:	e9 2e ff ff ff       	jmpq   80082d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800900:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800904:	0f 89 22 ff ff ff    	jns    80082c <vprintfmt+0x90>
				width = precision, precision = -1;
  80090a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80090d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800910:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800917:	e9 10 ff ff ff       	jmpq   80082c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800920:	e9 08 ff ff ff       	jmpq   80082d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800925:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800928:	83 f8 30             	cmp    $0x30,%eax
  80092b:	73 17                	jae    800944 <vprintfmt+0x1a8>
  80092d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800931:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800934:	89 c0                	mov    %eax,%eax
  800936:	48 01 d0             	add    %rdx,%rax
  800939:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093c:	83 c2 08             	add    $0x8,%edx
  80093f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800942:	eb 0f                	jmp    800953 <vprintfmt+0x1b7>
  800944:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800948:	48 89 d0             	mov    %rdx,%rax
  80094b:	48 83 c2 08          	add    $0x8,%rdx
  80094f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800953:	8b 00                	mov    (%rax),%eax
  800955:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800959:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80095d:	48 89 d6             	mov    %rdx,%rsi
  800960:	89 c7                	mov    %eax,%edi
  800962:	ff d1                	callq  *%rcx
			break;
  800964:	e9 47 03 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800969:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096c:	83 f8 30             	cmp    $0x30,%eax
  80096f:	73 17                	jae    800988 <vprintfmt+0x1ec>
  800971:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	89 c0                	mov    %eax,%eax
  80097a:	48 01 d0             	add    %rdx,%rax
  80097d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800980:	83 c2 08             	add    $0x8,%edx
  800983:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800986:	eb 0f                	jmp    800997 <vprintfmt+0x1fb>
  800988:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098c:	48 89 d0             	mov    %rdx,%rax
  80098f:	48 83 c2 08          	add    $0x8,%rdx
  800993:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800997:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800999:	85 db                	test   %ebx,%ebx
  80099b:	79 02                	jns    80099f <vprintfmt+0x203>
				err = -err;
  80099d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80099f:	83 fb 10             	cmp    $0x10,%ebx
  8009a2:	7f 16                	jg     8009ba <vprintfmt+0x21e>
  8009a4:	48 b8 40 4a 80 00 00 	movabs $0x804a40,%rax
  8009ab:	00 00 00 
  8009ae:	48 63 d3             	movslq %ebx,%rdx
  8009b1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8009b5:	4d 85 e4             	test   %r12,%r12
  8009b8:	75 2e                	jne    8009e8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c2:	89 d9                	mov    %ebx,%ecx
  8009c4:	48 ba d9 4a 80 00 00 	movabs $0x804ad9,%rdx
  8009cb:	00 00 00 
  8009ce:	48 89 c7             	mov    %rax,%rdi
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	49 b8 c0 0c 80 00 00 	movabs $0x800cc0,%r8
  8009dd:	00 00 00 
  8009e0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e3:	e9 c8 02 00 00       	jmpq   800cb0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f0:	4c 89 e1             	mov    %r12,%rcx
  8009f3:	48 ba e2 4a 80 00 00 	movabs $0x804ae2,%rdx
  8009fa:	00 00 00 
  8009fd:	48 89 c7             	mov    %rax,%rdi
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	49 b8 c0 0c 80 00 00 	movabs $0x800cc0,%r8
  800a0c:	00 00 00 
  800a0f:	41 ff d0             	callq  *%r8
			break;
  800a12:	e9 99 02 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1a:	83 f8 30             	cmp    $0x30,%eax
  800a1d:	73 17                	jae    800a36 <vprintfmt+0x29a>
  800a1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2e:	83 c2 08             	add    $0x8,%edx
  800a31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a34:	eb 0f                	jmp    800a45 <vprintfmt+0x2a9>
  800a36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3a:	48 89 d0             	mov    %rdx,%rax
  800a3d:	48 83 c2 08          	add    $0x8,%rdx
  800a41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a45:	4c 8b 20             	mov    (%rax),%r12
  800a48:	4d 85 e4             	test   %r12,%r12
  800a4b:	75 0a                	jne    800a57 <vprintfmt+0x2bb>
				p = "(null)";
  800a4d:	49 bc e5 4a 80 00 00 	movabs $0x804ae5,%r12
  800a54:	00 00 00 
			if (width > 0 && padc != '-')
  800a57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5b:	7e 7a                	jle    800ad7 <vprintfmt+0x33b>
  800a5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a61:	74 74                	je     800ad7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a66:	48 98                	cltq   
  800a68:	48 89 c6             	mov    %rax,%rsi
  800a6b:	4c 89 e7             	mov    %r12,%rdi
  800a6e:	48 b8 6a 0f 80 00 00 	movabs $0x800f6a,%rax
  800a75:	00 00 00 
  800a78:	ff d0                	callq  *%rax
  800a7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a7d:	eb 17                	jmp    800a96 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800a7f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800a83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a87:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a8b:	48 89 d6             	mov    %rdx,%rsi
  800a8e:	89 c7                	mov    %eax,%edi
  800a90:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9a:	7f e3                	jg     800a7f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9c:	eb 39                	jmp    800ad7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800aa2:	74 1e                	je     800ac2 <vprintfmt+0x326>
  800aa4:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa7:	7e 05                	jle    800aae <vprintfmt+0x312>
  800aa9:	83 fb 7e             	cmp    $0x7e,%ebx
  800aac:	7e 14                	jle    800ac2 <vprintfmt+0x326>
					putch('?', putdat);
  800aae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ab6:	48 89 c6             	mov    %rax,%rsi
  800ab9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800abe:	ff d2                	callq  *%rdx
  800ac0:	eb 0f                	jmp    800ad1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800ac2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ac6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aca:	48 89 c6             	mov    %rax,%rsi
  800acd:	89 df                	mov    %ebx,%edi
  800acf:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ad5:	eb 01                	jmp    800ad8 <vprintfmt+0x33c>
  800ad7:	90                   	nop
  800ad8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800add:	0f be d8             	movsbl %al,%ebx
  800ae0:	85 db                	test   %ebx,%ebx
  800ae2:	0f 95 c0             	setne  %al
  800ae5:	49 83 c4 01          	add    $0x1,%r12
  800ae9:	84 c0                	test   %al,%al
  800aeb:	74 28                	je     800b15 <vprintfmt+0x379>
  800aed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800af1:	78 ab                	js     800a9e <vprintfmt+0x302>
  800af3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800af7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800afb:	79 a1                	jns    800a9e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800afd:	eb 16                	jmp    800b15 <vprintfmt+0x379>
				putch(' ', putdat);
  800aff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b03:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b07:	48 89 c6             	mov    %rax,%rsi
  800b0a:	bf 20 00 00 00       	mov    $0x20,%edi
  800b0f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b11:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b19:	7f e4                	jg     800aff <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800b1b:	e9 90 01 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b24:	be 03 00 00 00       	mov    $0x3,%esi
  800b29:	48 89 c7             	mov    %rax,%rdi
  800b2c:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
  800b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 85 c0             	test   %rax,%rax
  800b43:	79 1d                	jns    800b62 <vprintfmt+0x3c6>
				putch('-', putdat);
  800b45:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b49:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b4d:	48 89 c6             	mov    %rax,%rsi
  800b50:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b55:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5b:	48 f7 d8             	neg    %rax
  800b5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b62:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b69:	e9 d5 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b72:	be 03 00 00 00       	mov    $0x3,%esi
  800b77:	48 89 c7             	mov    %rax,%rdi
  800b7a:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b8a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b91:	e9 ad 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800b96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9a:	be 03 00 00 00       	mov    $0x3,%esi
  800b9f:	48 89 c7             	mov    %rax,%rdi
  800ba2:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800ba9:	00 00 00 
  800bac:	ff d0                	callq  *%rax
  800bae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800bb2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800bb9:	e9 85 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800bbe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bc2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bc6:	48 89 c6             	mov    %rax,%rsi
  800bc9:	bf 30 00 00 00       	mov    $0x30,%edi
  800bce:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800bd0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bd8:	48 89 c6             	mov    %rax,%rsi
  800bdb:	bf 78 00 00 00       	mov    $0x78,%edi
  800be0:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800be2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be5:	83 f8 30             	cmp    $0x30,%eax
  800be8:	73 17                	jae    800c01 <vprintfmt+0x465>
  800bea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf1:	89 c0                	mov    %eax,%eax
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf9:	83 c2 08             	add    $0x8,%edx
  800bfc:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bff:	eb 0f                	jmp    800c10 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800c01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c05:	48 89 d0             	mov    %rdx,%rax
  800c08:	48 83 c2 08          	add    $0x8,%rdx
  800c0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c10:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c1e:	eb 23                	jmp    800c43 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c24:	be 03 00 00 00       	mov    $0x3,%esi
  800c29:	48 89 c7             	mov    %rax,%rdi
  800c2c:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800c33:	00 00 00 
  800c36:	ff d0                	callq  *%rax
  800c38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c3c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c43:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c48:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c4b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c52:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5a:	45 89 c1             	mov    %r8d,%r9d
  800c5d:	41 89 f8             	mov    %edi,%r8d
  800c60:	48 89 c7             	mov    %rax,%rdi
  800c63:	48 b8 c4 04 80 00 00 	movabs $0x8004c4,%rax
  800c6a:	00 00 00 
  800c6d:	ff d0                	callq  *%rax
			break;
  800c6f:	eb 3f                	jmp    800cb0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c71:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c75:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c79:	48 89 c6             	mov    %rax,%rsi
  800c7c:	89 df                	mov    %ebx,%edi
  800c7e:	ff d2                	callq  *%rdx
			break;
  800c80:	eb 2e                	jmp    800cb0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8a:	48 89 c6             	mov    %rax,%rsi
  800c8d:	bf 25 00 00 00       	mov    $0x25,%edi
  800c92:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c94:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c99:	eb 05                	jmp    800ca0 <vprintfmt+0x504>
  800c9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ca0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca4:	48 83 e8 01          	sub    $0x1,%rax
  800ca8:	0f b6 00             	movzbl (%rax),%eax
  800cab:	3c 25                	cmp    $0x25,%al
  800cad:	75 ec                	jne    800c9b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800caf:	90                   	nop
		}
	}
  800cb0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb1:	e9 38 fb ff ff       	jmpq   8007ee <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800cb6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800cb7:	48 83 c4 60          	add    $0x60,%rsp
  800cbb:	5b                   	pop    %rbx
  800cbc:	41 5c                	pop    %r12
  800cbe:	5d                   	pop    %rbp
  800cbf:	c3                   	retq   

0000000000800cc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc0:	55                   	push   %rbp
  800cc1:	48 89 e5             	mov    %rsp,%rbp
  800cc4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ccb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cd2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ce0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ce7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 20                	je     800d12 <printfmt+0x52>
  800cf2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cf6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cfa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cfe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d12:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d19:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d20:	00 00 00 
  800d23:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d2a:	00 00 00 
  800d2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d31:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d3f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d46:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d4d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d54:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d5b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  800d6c:	00 00 00 
  800d6f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d71:	c9                   	leaveq 
  800d72:	c3                   	retq   

0000000000800d73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d73:	55                   	push   %rbp
  800d74:	48 89 e5             	mov    %rsp,%rbp
  800d77:	48 83 ec 10          	sub    $0x10,%rsp
  800d7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d86:	8b 40 10             	mov    0x10(%rax),%eax
  800d89:	8d 50 01             	lea    0x1(%rax),%edx
  800d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d90:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d97:	48 8b 10             	mov    (%rax),%rdx
  800d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800da2:	48 39 c2             	cmp    %rax,%rdx
  800da5:	73 17                	jae    800dbe <sprintputch+0x4b>
		*b->buf++ = ch;
  800da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dab:	48 8b 00             	mov    (%rax),%rax
  800dae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800db1:	88 10                	mov    %dl,(%rax)
  800db3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dbb:	48 89 10             	mov    %rdx,(%rax)
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 50          	sub    $0x50,%rsp
  800dc8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dcc:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800dcf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dd3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dd7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ddb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ddf:	48 8b 0a             	mov    (%rdx),%rcx
  800de2:	48 89 08             	mov    %rcx,(%rax)
  800de5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800de9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ded:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800df1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800df5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800df9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dfd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e00:	48 98                	cltq   
  800e02:	48 83 e8 01          	sub    $0x1,%rax
  800e06:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800e0a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e15:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e1a:	74 06                	je     800e22 <vsnprintf+0x62>
  800e1c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e20:	7f 07                	jg     800e29 <vsnprintf+0x69>
		return -E_INVAL;
  800e22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e27:	eb 2f                	jmp    800e58 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e29:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e2d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e35:	48 89 c6             	mov    %rax,%rsi
  800e38:	48 bf 73 0d 80 00 00 	movabs $0x800d73,%rdi
  800e3f:	00 00 00 
  800e42:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e52:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e55:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e58:	c9                   	leaveq 
  800e59:	c3                   	retq   

0000000000800e5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5a:	55                   	push   %rbp
  800e5b:	48 89 e5             	mov    %rsp,%rbp
  800e5e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e65:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e6c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e87:	84 c0                	test   %al,%al
  800e89:	74 20                	je     800eab <snprintf+0x51>
  800e8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ea3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eab:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800eb2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800eb9:	00 00 00 
  800ebc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ec3:	00 00 00 
  800ec6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ed1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800edf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ee6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800eed:	48 8b 0a             	mov    (%rdx),%rcx
  800ef0:	48 89 08             	mov    %rcx,(%rax)
  800ef3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800efb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f03:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f0a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f11:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f17:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f1e:	48 89 c7             	mov    %rax,%rdi
  800f21:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	callq  *%rax
  800f2d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f33:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f39:	c9                   	leaveq 
  800f3a:	c3                   	retq   
	...

0000000000800f3c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f3c:	55                   	push   %rbp
  800f3d:	48 89 e5             	mov    %rsp,%rbp
  800f40:	48 83 ec 18          	sub    $0x18,%rsp
  800f44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f4f:	eb 09                	jmp    800f5a <strlen+0x1e>
		n++;
  800f51:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f55:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5e:	0f b6 00             	movzbl (%rax),%eax
  800f61:	84 c0                	test   %al,%al
  800f63:	75 ec                	jne    800f51 <strlen+0x15>
		n++;
	return n;
  800f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f68:	c9                   	leaveq 
  800f69:	c3                   	retq   

0000000000800f6a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f6a:	55                   	push   %rbp
  800f6b:	48 89 e5             	mov    %rsp,%rbp
  800f6e:	48 83 ec 20          	sub    $0x20,%rsp
  800f72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f81:	eb 0e                	jmp    800f91 <strnlen+0x27>
		n++;
  800f83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f87:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f8c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f91:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f96:	74 0b                	je     800fa3 <strnlen+0x39>
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	0f b6 00             	movzbl (%rax),%eax
  800f9f:	84 c0                	test   %al,%al
  800fa1:	75 e0                	jne    800f83 <strnlen+0x19>
		n++;
	return n;
  800fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fa6:	c9                   	leaveq 
  800fa7:	c3                   	retq   

0000000000800fa8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fa8:	55                   	push   %rbp
  800fa9:	48 89 e5             	mov    %rsp,%rbp
  800fac:	48 83 ec 20          	sub    $0x20,%rsp
  800fb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fc0:	90                   	nop
  800fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc5:	0f b6 10             	movzbl (%rax),%edx
  800fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcc:	88 10                	mov    %dl,(%rax)
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	0f 95 c0             	setne  %al
  800fda:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fdf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800fe4:	84 c0                	test   %al,%al
  800fe6:	75 d9                	jne    800fc1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fec:	c9                   	leaveq 
  800fed:	c3                   	retq   

0000000000800fee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fee:	55                   	push   %rbp
  800fef:	48 89 e5             	mov    %rsp,%rbp
  800ff2:	48 83 ec 20          	sub    $0x20,%rsp
  800ff6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801002:	48 89 c7             	mov    %rax,%rdi
  801005:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  80100c:	00 00 00 
  80100f:	ff d0                	callq  *%rax
  801011:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801017:	48 98                	cltq   
  801019:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80101d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801021:	48 89 d6             	mov    %rdx,%rsi
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
	return dst;
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	48 83 ec 28          	sub    $0x28,%rsp
  801041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801049:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801055:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80105c:	00 
  80105d:	eb 27                	jmp    801086 <strncpy+0x4d>
		*dst++ = *src;
  80105f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801063:	0f b6 10             	movzbl (%rax),%edx
  801066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106a:	88 10                	mov    %dl,(%rax)
  80106c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801071:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801075:	0f b6 00             	movzbl (%rax),%eax
  801078:	84 c0                	test   %al,%al
  80107a:	74 05                	je     801081 <strncpy+0x48>
			src++;
  80107c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801081:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80108e:	72 cf                	jb     80105f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 28          	sub    $0x28,%rsp
  80109e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010b7:	74 37                	je     8010f0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 17                	jmp    8010d2 <strlcpy+0x3c>
			*dst++ = *src++;
  8010bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010bf:	0f b6 10             	movzbl (%rax),%edx
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	88 10                	mov    %dl,(%rax)
  8010c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010cd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010dc:	74 0b                	je     8010e9 <strlcpy+0x53>
  8010de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e2:	0f b6 00             	movzbl (%rax),%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 d2                	jne    8010bb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f8:	48 89 d1             	mov    %rdx,%rcx
  8010fb:	48 29 c1             	sub    %rax,%rcx
  8010fe:	48 89 c8             	mov    %rcx,%rax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 10          	sub    $0x10,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801113:	eb 0a                	jmp    80111f <strcmp+0x1c>
		p++, q++;
  801115:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	84 c0                	test   %al,%al
  801128:	74 12                	je     80113c <strcmp+0x39>
  80112a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112e:	0f b6 10             	movzbl (%rax),%edx
  801131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801135:	0f b6 00             	movzbl (%rax),%eax
  801138:	38 c2                	cmp    %al,%dl
  80113a:	74 d9                	je     801115 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80113c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801140:	0f b6 00             	movzbl (%rax),%eax
  801143:	0f b6 d0             	movzbl %al,%edx
  801146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114a:	0f b6 00             	movzbl (%rax),%eax
  80114d:	0f b6 c0             	movzbl %al,%eax
  801150:	89 d1                	mov    %edx,%ecx
  801152:	29 c1                	sub    %eax,%ecx
  801154:	89 c8                	mov    %ecx,%eax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 18          	sub    $0x18,%rsp
  801160:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801164:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801168:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80116c:	eb 0f                	jmp    80117d <strncmp+0x25>
		n--, p++, q++;
  80116e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801173:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801178:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80117d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801182:	74 1d                	je     8011a1 <strncmp+0x49>
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	0f b6 00             	movzbl (%rax),%eax
  80118b:	84 c0                	test   %al,%al
  80118d:	74 12                	je     8011a1 <strncmp+0x49>
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	0f b6 10             	movzbl (%rax),%edx
  801196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119a:	0f b6 00             	movzbl (%rax),%eax
  80119d:	38 c2                	cmp    %al,%dl
  80119f:	74 cd                	je     80116e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a6:	75 07                	jne    8011af <strncmp+0x57>
		return 0;
  8011a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ad:	eb 1a                	jmp    8011c9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	0f b6 d0             	movzbl %al,%edx
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	0f b6 c0             	movzbl %al,%eax
  8011c3:	89 d1                	mov    %edx,%ecx
  8011c5:	29 c1                	sub    %eax,%ecx
  8011c7:	89 c8                	mov    %ecx,%eax
}
  8011c9:	c9                   	leaveq 
  8011ca:	c3                   	retq   

00000000008011cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	48 83 ec 10          	sub    $0x10,%rsp
  8011d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d7:	89 f0                	mov    %esi,%eax
  8011d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011dc:	eb 17                	jmp    8011f5 <strchr+0x2a>
		if (*s == c)
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011e8:	75 06                	jne    8011f0 <strchr+0x25>
			return (char *) s;
  8011ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ee:	eb 15                	jmp    801205 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	84 c0                	test   %al,%al
  8011fe:	75 de                	jne    8011de <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	c9                   	leaveq 
  801206:	c3                   	retq   

0000000000801207 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801207:	55                   	push   %rbp
  801208:	48 89 e5             	mov    %rsp,%rbp
  80120b:	48 83 ec 10          	sub    $0x10,%rsp
  80120f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801213:	89 f0                	mov    %esi,%eax
  801215:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801218:	eb 11                	jmp    80122b <strfind+0x24>
		if (*s == c)
  80121a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121e:	0f b6 00             	movzbl (%rax),%eax
  801221:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801224:	74 12                	je     801238 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801226:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	84 c0                	test   %al,%al
  801234:	75 e4                	jne    80121a <strfind+0x13>
  801236:	eb 01                	jmp    801239 <strfind+0x32>
		if (*s == c)
			break;
  801238:	90                   	nop
	return (char *) s;
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80123d:	c9                   	leaveq 
  80123e:	c3                   	retq   

000000000080123f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	48 83 ec 18          	sub    $0x18,%rsp
  801247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80124e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801252:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801257:	75 06                	jne    80125f <memset+0x20>
		return v;
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	eb 69                	jmp    8012c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 48                	jne    8012b3 <memset+0x74>
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	83 e0 03             	and    $0x3,%eax
  801272:	48 85 c0             	test   %rax,%rax
  801275:	75 3c                	jne    8012b3 <memset+0x74>
		c &= 0xFF;
  801277:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80127e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 e2 18             	shl    $0x18,%edx
  801286:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801289:	c1 e0 10             	shl    $0x10,%eax
  80128c:	09 c2                	or     %eax,%edx
  80128e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801291:	c1 e0 08             	shl    $0x8,%eax
  801294:	09 d0                	or     %edx,%eax
  801296:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129d:	48 89 c1             	mov    %rax,%rcx
  8012a0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ab:	48 89 d7             	mov    %rdx,%rdi
  8012ae:	fc                   	cld    
  8012af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012b1:	eb 11                	jmp    8012c4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012be:	48 89 d7             	mov    %rdx,%rdi
  8012c1:	fc                   	cld    
  8012c2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c8:	c9                   	leaveq 
  8012c9:	c3                   	retq   

00000000008012ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012ca:	55                   	push   %rbp
  8012cb:	48 89 e5             	mov    %rsp,%rbp
  8012ce:	48 83 ec 28          	sub    $0x28,%rsp
  8012d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012f6:	0f 83 88 00 00 00    	jae    801384 <memmove+0xba>
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801304:	48 01 d0             	add    %rdx,%rax
  801307:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80130b:	76 77                	jbe    801384 <memmove+0xba>
		s += n;
  80130d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801311:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801319:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	83 e0 03             	and    $0x3,%eax
  801324:	48 85 c0             	test   %rax,%rax
  801327:	75 3b                	jne    801364 <memmove+0x9a>
  801329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132d:	83 e0 03             	and    $0x3,%eax
  801330:	48 85 c0             	test   %rax,%rax
  801333:	75 2f                	jne    801364 <memmove+0x9a>
  801335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801339:	83 e0 03             	and    $0x3,%eax
  80133c:	48 85 c0             	test   %rax,%rax
  80133f:	75 23                	jne    801364 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801345:	48 83 e8 04          	sub    $0x4,%rax
  801349:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134d:	48 83 ea 04          	sub    $0x4,%rdx
  801351:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801355:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801359:	48 89 c7             	mov    %rax,%rdi
  80135c:	48 89 d6             	mov    %rdx,%rsi
  80135f:	fd                   	std    
  801360:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801362:	eb 1d                	jmp    801381 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801368:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80136c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801370:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801378:	48 89 d7             	mov    %rdx,%rdi
  80137b:	48 89 c1             	mov    %rax,%rcx
  80137e:	fd                   	std    
  80137f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801381:	fc                   	cld    
  801382:	eb 57                	jmp    8013db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	83 e0 03             	and    $0x3,%eax
  80138b:	48 85 c0             	test   %rax,%rax
  80138e:	75 36                	jne    8013c6 <memmove+0xfc>
  801390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801394:	83 e0 03             	and    $0x3,%eax
  801397:	48 85 c0             	test   %rax,%rax
  80139a:	75 2a                	jne    8013c6 <memmove+0xfc>
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	83 e0 03             	and    $0x3,%eax
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	75 1e                	jne    8013c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 89 c1             	mov    %rax,%rcx
  8013af:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bb:	48 89 c7             	mov    %rax,%rdi
  8013be:	48 89 d6             	mov    %rdx,%rsi
  8013c1:	fc                   	cld    
  8013c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013c4:	eb 15                	jmp    8013db <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d2:	48 89 c7             	mov    %rax,%rdi
  8013d5:	48 89 d6             	mov    %rdx,%rsi
  8013d8:	fc                   	cld    
  8013d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 18          	sub    $0x18,%rsp
  8013e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	48 89 ce             	mov    %rcx,%rsi
  801404:	48 89 c7             	mov    %rax,%rdi
  801407:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  80140e:	00 00 00 
  801411:	ff d0                	callq  *%rax
}
  801413:	c9                   	leaveq 
  801414:	c3                   	retq   

0000000000801415 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801415:	55                   	push   %rbp
  801416:	48 89 e5             	mov    %rsp,%rbp
  801419:	48 83 ec 28          	sub    $0x28,%rsp
  80141d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801421:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801425:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801431:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801435:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801439:	eb 38                	jmp    801473 <memcmp+0x5e>
		if (*s1 != *s2)
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	0f b6 10             	movzbl (%rax),%edx
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	38 c2                	cmp    %al,%dl
  80144b:	74 1c                	je     801469 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	0f b6 d0             	movzbl %al,%edx
  801457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	0f b6 c0             	movzbl %al,%eax
  801461:	89 d1                	mov    %edx,%ecx
  801463:	29 c1                	sub    %eax,%ecx
  801465:	89 c8                	mov    %ecx,%eax
  801467:	eb 20                	jmp    801489 <memcmp+0x74>
		s1++, s2++;
  801469:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80146e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801473:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801478:	0f 95 c0             	setne  %al
  80147b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801480:	84 c0                	test   %al,%al
  801482:	75 b7                	jne    80143b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 28          	sub    $0x28,%rsp
  801493:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801497:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80149a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80149e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a6:	48 01 d0             	add    %rdx,%rax
  8014a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014ad:	eb 13                	jmp    8014c2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b3:	0f b6 10             	movzbl (%rax),%edx
  8014b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014b9:	38 c2                	cmp    %al,%dl
  8014bb:	74 11                	je     8014ce <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014ca:	72 e3                	jb     8014af <memfind+0x24>
  8014cc:	eb 01                	jmp    8014cf <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014ce:	90                   	nop
	return (void *) s;
  8014cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 38          	sub    $0x38,%rsp
  8014dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014e5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014ef:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014f6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f7:	eb 05                	jmp    8014fe <strtol+0x29>
		s++;
  8014f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	3c 20                	cmp    $0x20,%al
  801507:	74 f0                	je     8014f9 <strtol+0x24>
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 09                	cmp    $0x9,%al
  801512:	74 e5                	je     8014f9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 2b                	cmp    $0x2b,%al
  80151d:	75 07                	jne    801526 <strtol+0x51>
		s++;
  80151f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801524:	eb 17                	jmp    80153d <strtol+0x68>
	else if (*s == '-')
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	0f b6 00             	movzbl (%rax),%eax
  80152d:	3c 2d                	cmp    $0x2d,%al
  80152f:	75 0c                	jne    80153d <strtol+0x68>
		s++, neg = 1;
  801531:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80153d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801541:	74 06                	je     801549 <strtol+0x74>
  801543:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801547:	75 28                	jne    801571 <strtol+0x9c>
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	3c 30                	cmp    $0x30,%al
  801552:	75 1d                	jne    801571 <strtol+0x9c>
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 83 c0 01          	add    $0x1,%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 78                	cmp    $0x78,%al
  801561:	75 0e                	jne    801571 <strtol+0x9c>
		s += 2, base = 16;
  801563:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801568:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80156f:	eb 2c                	jmp    80159d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801571:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801575:	75 19                	jne    801590 <strtol+0xbb>
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	3c 30                	cmp    $0x30,%al
  801580:	75 0e                	jne    801590 <strtol+0xbb>
		s++, base = 8;
  801582:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801587:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80158e:	eb 0d                	jmp    80159d <strtol+0xc8>
	else if (base == 0)
  801590:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801594:	75 07                	jne    80159d <strtol+0xc8>
		base = 10;
  801596:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	3c 2f                	cmp    $0x2f,%al
  8015a6:	7e 1d                	jle    8015c5 <strtol+0xf0>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 39                	cmp    $0x39,%al
  8015b1:	7f 12                	jg     8015c5 <strtol+0xf0>
			dig = *s - '0';
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	0f be c0             	movsbl %al,%eax
  8015bd:	83 e8 30             	sub    $0x30,%eax
  8015c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c3:	eb 4e                	jmp    801613 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 60                	cmp    $0x60,%al
  8015ce:	7e 1d                	jle    8015ed <strtol+0x118>
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 7a                	cmp    $0x7a,%al
  8015d9:	7f 12                	jg     8015ed <strtol+0x118>
			dig = *s - 'a' + 10;
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	0f be c0             	movsbl %al,%eax
  8015e5:	83 e8 57             	sub    $0x57,%eax
  8015e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015eb:	eb 26                	jmp    801613 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	3c 40                	cmp    $0x40,%al
  8015f6:	7e 47                	jle    80163f <strtol+0x16a>
  8015f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3c 5a                	cmp    $0x5a,%al
  801601:	7f 3c                	jg     80163f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	0f be c0             	movsbl %al,%eax
  80160d:	83 e8 37             	sub    $0x37,%eax
  801610:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801613:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801616:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801619:	7d 23                	jge    80163e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80161b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801620:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801623:	48 98                	cltq   
  801625:	48 89 c2             	mov    %rax,%rdx
  801628:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80162d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801630:	48 98                	cltq   
  801632:	48 01 d0             	add    %rdx,%rax
  801635:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801639:	e9 5f ff ff ff       	jmpq   80159d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80163e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80163f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801644:	74 0b                	je     801651 <strtol+0x17c>
		*endptr = (char *) s;
  801646:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80164e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801655:	74 09                	je     801660 <strtol+0x18b>
  801657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165b:	48 f7 d8             	neg    %rax
  80165e:	eb 04                	jmp    801664 <strtol+0x18f>
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801664:	c9                   	leaveq 
  801665:	c3                   	retq   

0000000000801666 <strstr>:

char * strstr(const char *in, const char *str)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 30          	sub    $0x30,%rsp
  80166e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801672:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801676:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801680:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801685:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801689:	75 06                	jne    801691 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	eb 68                	jmp    8016f9 <strstr+0x93>

    len = strlen(str);
  801691:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801695:	48 89 c7             	mov    %rax,%rdi
  801698:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  80169f:	00 00 00 
  8016a2:	ff d0                	callq  *%rax
  8016a4:	48 98                	cltq   
  8016a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8016b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8016b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016bd:	75 07                	jne    8016c6 <strstr+0x60>
                return (char *) 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c4:	eb 33                	jmp    8016f9 <strstr+0x93>
        } while (sc != c);
  8016c6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016ca:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016cd:	75 db                	jne    8016aa <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8016cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	48 89 ce             	mov    %rcx,%rsi
  8016de:	48 89 c7             	mov    %rax,%rdi
  8016e1:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  8016e8:	00 00 00 
  8016eb:	ff d0                	callq  *%rax
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	75 b9                	jne    8016aa <strstr+0x44>

    return (char *) (in - 1);
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	48 83 e8 01          	sub    $0x1,%rax
}
  8016f9:	c9                   	leaveq 
  8016fa:	c3                   	retq   
	...

00000000008016fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	53                   	push   %rbx
  801701:	48 83 ec 58          	sub    $0x58,%rsp
  801705:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801708:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80170b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80170f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801713:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801717:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80171e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801721:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801725:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801729:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80172d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801731:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801735:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801738:	4c 89 c3             	mov    %r8,%rbx
  80173b:	cd 30                	int    $0x30
  80173d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801741:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801745:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801749:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80174d:	74 3e                	je     80178d <syscall+0x91>
  80174f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801754:	7e 37                	jle    80178d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80175d:	49 89 d0             	mov    %rdx,%r8
  801760:	89 c1                	mov    %eax,%ecx
  801762:	48 ba a0 4d 80 00 00 	movabs $0x804da0,%rdx
  801769:	00 00 00 
  80176c:	be 23 00 00 00       	mov    $0x23,%esi
  801771:	48 bf bd 4d 80 00 00 	movabs $0x804dbd,%rdi
  801778:	00 00 00 
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	49 b9 b0 01 80 00 00 	movabs $0x8001b0,%r9
  801787:	00 00 00 
  80178a:	41 ff d1             	callq  *%r9

	return ret;
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801791:	48 83 c4 58          	add    $0x58,%rsp
  801795:	5b                   	pop    %rbx
  801796:	5d                   	pop    %rbp
  801797:	c3                   	retq   

0000000000801798 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 20          	sub    $0x20,%rsp
  8017a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b7:	00 
  8017b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c4:	48 89 d1             	mov    %rdx,%rcx
  8017c7:	48 89 c2             	mov    %rax,%rdx
  8017ca:	be 00 00 00 00       	mov    $0x0,%esi
  8017cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d4:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f1:	00 
  8017f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	be 00 00 00 00       	mov    $0x0,%esi
  80180d:	bf 01 00 00 00       	mov    $0x1,%edi
  801812:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
}
  80181e:	c9                   	leaveq 
  80181f:	c3                   	retq   

0000000000801820 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
  801824:	48 83 ec 20          	sub    $0x20,%rsp
  801828:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80182b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182e:	48 98                	cltq   
  801830:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801837:	00 
  801838:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801844:	b9 00 00 00 00       	mov    $0x0,%ecx
  801849:	48 89 c2             	mov    %rax,%rdx
  80184c:	be 01 00 00 00       	mov    $0x1,%esi
  801851:	bf 03 00 00 00       	mov    $0x3,%edi
  801856:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
}
  801862:	c9                   	leaveq 
  801863:	c3                   	retq   

0000000000801864 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801864:	55                   	push   %rbp
  801865:	48 89 e5             	mov    %rsp,%rbp
  801868:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80186c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801873:	00 
  801874:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801880:	b9 00 00 00 00       	mov    $0x0,%ecx
  801885:	ba 00 00 00 00       	mov    $0x0,%edx
  80188a:	be 00 00 00 00       	mov    $0x0,%esi
  80188f:	bf 02 00 00 00       	mov    $0x2,%edi
  801894:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	callq  *%rax
}
  8018a0:	c9                   	leaveq 
  8018a1:	c3                   	retq   

00000000008018a2 <sys_yield>:

void
sys_yield(void)
{
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b1:	00 
  8018b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c8:	be 00 00 00 00       	mov    $0x0,%esi
  8018cd:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018d2:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018f5:	48 63 c8             	movslq %eax,%rcx
  8018f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ff:	48 98                	cltq   
  801901:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801908:	00 
  801909:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190f:	49 89 c8             	mov    %rcx,%r8
  801912:	48 89 d1             	mov    %rdx,%rcx
  801915:	48 89 c2             	mov    %rax,%rdx
  801918:	be 01 00 00 00       	mov    $0x1,%esi
  80191d:	bf 04 00 00 00       	mov    $0x4,%edi
  801922:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801929:	00 00 00 
  80192c:	ff d0                	callq  *%rax
}
  80192e:	c9                   	leaveq 
  80192f:	c3                   	retq   

0000000000801930 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	48 83 ec 30          	sub    $0x30,%rsp
  801938:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80193b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801942:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801946:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80194a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80194d:	48 63 c8             	movslq %eax,%rcx
  801950:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801957:	48 63 f0             	movslq %eax,%rsi
  80195a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801961:	48 98                	cltq   
  801963:	48 89 0c 24          	mov    %rcx,(%rsp)
  801967:	49 89 f9             	mov    %rdi,%r9
  80196a:	49 89 f0             	mov    %rsi,%r8
  80196d:	48 89 d1             	mov    %rdx,%rcx
  801970:	48 89 c2             	mov    %rax,%rdx
  801973:	be 01 00 00 00       	mov    $0x1,%esi
  801978:	bf 05 00 00 00       	mov    $0x5,%edi
  80197d:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801984:	00 00 00 
  801987:	ff d0                	callq  *%rax
}
  801989:	c9                   	leaveq 
  80198a:	c3                   	retq   

000000000080198b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80198b:	55                   	push   %rbp
  80198c:	48 89 e5             	mov    %rsp,%rbp
  80198f:	48 83 ec 20          	sub    $0x20,%rsp
  801993:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801996:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80199a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a1:	48 98                	cltq   
  8019a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019aa:	00 
  8019ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b7:	48 89 d1             	mov    %rdx,%rcx
  8019ba:	48 89 c2             	mov    %rax,%rdx
  8019bd:	be 01 00 00 00       	mov    $0x1,%esi
  8019c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8019c7:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	callq  *%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 20          	sub    $0x20,%rsp
  8019dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e6:	48 63 d0             	movslq %eax,%rdx
  8019e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ec:	48 98                	cltq   
  8019ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f5:	00 
  8019f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a02:	48 89 d1             	mov    %rdx,%rcx
  801a05:	48 89 c2             	mov    %rax,%rdx
  801a08:	be 01 00 00 00       	mov    $0x1,%esi
  801a0d:	bf 08 00 00 00       	mov    $0x8,%edi
  801a12:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 20          	sub    $0x20,%rsp
  801a28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a36:	48 98                	cltq   
  801a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3f:	00 
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	48 89 d1             	mov    %rdx,%rcx
  801a4f:	48 89 c2             	mov    %rax,%rdx
  801a52:	be 01 00 00 00       	mov    $0x1,%esi
  801a57:	bf 09 00 00 00       	mov    $0x9,%edi
  801a5c:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	48 83 ec 20          	sub    $0x20,%rsp
  801a72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a80:	48 98                	cltq   
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	48 89 d1             	mov    %rdx,%rcx
  801a99:	48 89 c2             	mov    %rax,%rdx
  801a9c:	be 01 00 00 00       	mov    $0x1,%esi
  801aa1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801aa6:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801aad:	00 00 00 
  801ab0:	ff d0                	callq  *%rax
}
  801ab2:	c9                   	leaveq 
  801ab3:	c3                   	retq   

0000000000801ab4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ab4:	55                   	push   %rbp
  801ab5:	48 89 e5             	mov    %rsp,%rbp
  801ab8:	48 83 ec 30          	sub    $0x30,%rsp
  801abc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ac3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ac7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801aca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801acd:	48 63 f0             	movslq %eax,%rsi
  801ad0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad7:	48 98                	cltq   
  801ad9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	49 89 f1             	mov    %rsi,%r9
  801ae8:	49 89 c8             	mov    %rcx,%r8
  801aeb:	48 89 d1             	mov    %rdx,%rcx
  801aee:	48 89 c2             	mov    %rax,%rdx
  801af1:	be 00 00 00 00       	mov    $0x0,%esi
  801af6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801afb:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 20          	sub    $0x20,%rsp
  801b11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b20:	00 
  801b21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b32:	48 89 c2             	mov    %rax,%rdx
  801b35:	be 01 00 00 00       	mov    $0x1,%esi
  801b3a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b3f:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	callq  *%rax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5c:	00 
  801b5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b73:	be 00 00 00 00       	mov    $0x0,%esi
  801b78:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b7d:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	callq  *%rax
}
  801b89:	c9                   	leaveq 
  801b8a:	c3                   	retq   

0000000000801b8b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801b8b:	55                   	push   %rbp
  801b8c:	48 89 e5             	mov    %rsp,%rbp
  801b8f:	48 83 ec 20          	sub    $0x20,%rsp
  801b93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801baa:	00 
  801bab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb7:	48 89 d1             	mov    %rdx,%rcx
  801bba:	48 89 c2             	mov    %rax,%rdx
  801bbd:	be 00 00 00 00       	mov    $0x0,%esi
  801bc2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bc7:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801bce:	00 00 00 
  801bd1:	ff d0                	callq  *%rax
}
  801bd3:	c9                   	leaveq 
  801bd4:	c3                   	retq   

0000000000801bd5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
  801bd9:	48 83 ec 20          	sub    $0x20,%rsp
  801bdd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bed:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf4:	00 
  801bf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c01:	48 89 d1             	mov    %rdx,%rcx
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	be 00 00 00 00       	mov    $0x0,%esi
  801c0c:	bf 10 00 00 00       	mov    $0x10,%edi
  801c11:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   
	...

0000000000801c20 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 08          	sub    $0x8,%rsp
  801c28:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c30:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c37:	ff ff ff 
  801c3a:	48 01 d0             	add    %rdx,%rax
  801c3d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c41:	c9                   	leaveq 
  801c42:	c3                   	retq   

0000000000801c43 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c43:	55                   	push   %rbp
  801c44:	48 89 e5             	mov    %rsp,%rbp
  801c47:	48 83 ec 08          	sub    $0x8,%rsp
  801c4b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c53:	48 89 c7             	mov    %rax,%rdi
  801c56:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  801c5d:	00 00 00 
  801c60:	ff d0                	callq  *%rax
  801c62:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c68:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c6c:	c9                   	leaveq 
  801c6d:	c3                   	retq   

0000000000801c6e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c6e:	55                   	push   %rbp
  801c6f:	48 89 e5             	mov    %rsp,%rbp
  801c72:	48 83 ec 18          	sub    $0x18,%rsp
  801c76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c81:	eb 6b                	jmp    801cee <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c86:	48 98                	cltq   
  801c88:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c8e:	48 c1 e0 0c          	shl    $0xc,%rax
  801c92:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9a:	48 89 c2             	mov    %rax,%rdx
  801c9d:	48 c1 ea 15          	shr    $0x15,%rdx
  801ca1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ca8:	01 00 00 
  801cab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801caf:	83 e0 01             	and    $0x1,%eax
  801cb2:	48 85 c0             	test   %rax,%rax
  801cb5:	74 21                	je     801cd8 <fd_alloc+0x6a>
  801cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cbb:	48 89 c2             	mov    %rax,%rdx
  801cbe:	48 c1 ea 0c          	shr    $0xc,%rdx
  801cc2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cc9:	01 00 00 
  801ccc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cd0:	83 e0 01             	and    $0x1,%eax
  801cd3:	48 85 c0             	test   %rax,%rax
  801cd6:	75 12                	jne    801cea <fd_alloc+0x7c>
			*fd_store = fd;
  801cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce8:	eb 1a                	jmp    801d04 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cee:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cf2:	7e 8f                	jle    801c83 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801cff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d04:	c9                   	leaveq 
  801d05:	c3                   	retq   

0000000000801d06 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	48 83 ec 20          	sub    $0x20,%rsp
  801d0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d19:	78 06                	js     801d21 <fd_lookup+0x1b>
  801d1b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d1f:	7e 07                	jle    801d28 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d26:	eb 6c                	jmp    801d94 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d28:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d2b:	48 98                	cltq   
  801d2d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d33:	48 c1 e0 0c          	shl    $0xc,%rax
  801d37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	48 89 c2             	mov    %rax,%rdx
  801d42:	48 c1 ea 15          	shr    $0x15,%rdx
  801d46:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d4d:	01 00 00 
  801d50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d54:	83 e0 01             	and    $0x1,%eax
  801d57:	48 85 c0             	test   %rax,%rax
  801d5a:	74 21                	je     801d7d <fd_lookup+0x77>
  801d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d60:	48 89 c2             	mov    %rax,%rdx
  801d63:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d6e:	01 00 00 
  801d71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d75:	83 e0 01             	and    $0x1,%eax
  801d78:	48 85 c0             	test   %rax,%rax
  801d7b:	75 07                	jne    801d84 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d82:	eb 10                	jmp    801d94 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d88:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d8c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d94:	c9                   	leaveq 
  801d95:	c3                   	retq   

0000000000801d96 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d96:	55                   	push   %rbp
  801d97:	48 89 e5             	mov    %rsp,%rbp
  801d9a:	48 83 ec 30          	sub    $0x30,%rsp
  801d9e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801da2:	89 f0                	mov    %esi,%eax
  801da4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dab:	48 89 c7             	mov    %rax,%rdi
  801dae:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  801db5:	00 00 00 
  801db8:	ff d0                	callq  *%rax
  801dba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dbe:	48 89 d6             	mov    %rdx,%rsi
  801dc1:	89 c7                	mov    %eax,%edi
  801dc3:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  801dca:	00 00 00 
  801dcd:	ff d0                	callq  *%rax
  801dcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dd6:	78 0a                	js     801de2 <fd_close+0x4c>
	    || fd != fd2)
  801dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddc:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801de0:	74 12                	je     801df4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801de2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801de6:	74 05                	je     801ded <fd_close+0x57>
  801de8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801deb:	eb 05                	jmp    801df2 <fd_close+0x5c>
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	eb 69                	jmp    801e5d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801df8:	8b 00                	mov    (%rax),%eax
  801dfa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801dfe:	48 89 d6             	mov    %rdx,%rsi
  801e01:	89 c7                	mov    %eax,%edi
  801e03:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  801e0a:	00 00 00 
  801e0d:	ff d0                	callq  *%rax
  801e0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e16:	78 2a                	js     801e42 <fd_close+0xac>
		if (dev->dev_close)
  801e18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1c:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e20:	48 85 c0             	test   %rax,%rax
  801e23:	74 16                	je     801e3b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e29:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801e2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e31:	48 89 c7             	mov    %rax,%rdi
  801e34:	ff d2                	callq  *%rdx
  801e36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e39:	eb 07                	jmp    801e42 <fd_close+0xac>
		else
			r = 0;
  801e3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e46:	48 89 c6             	mov    %rax,%rsi
  801e49:	bf 00 00 00 00       	mov    $0x0,%edi
  801e4e:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  801e55:	00 00 00 
  801e58:	ff d0                	callq  *%rax
	return r;
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e5d:	c9                   	leaveq 
  801e5e:	c3                   	retq   

0000000000801e5f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e5f:	55                   	push   %rbp
  801e60:	48 89 e5             	mov    %rsp,%rbp
  801e63:	48 83 ec 20          	sub    $0x20,%rsp
  801e67:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e75:	eb 41                	jmp    801eb8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e77:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e7e:	00 00 00 
  801e81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e84:	48 63 d2             	movslq %edx,%rdx
  801e87:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e8b:	8b 00                	mov    (%rax),%eax
  801e8d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e90:	75 22                	jne    801eb4 <dev_lookup+0x55>
			*dev = devtab[i];
  801e92:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801e99:	00 00 00 
  801e9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e9f:	48 63 d2             	movslq %edx,%rdx
  801ea2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ea6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eaa:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb2:	eb 60                	jmp    801f14 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801eb4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eb8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ebf:	00 00 00 
  801ec2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec5:	48 63 d2             	movslq %edx,%rdx
  801ec8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecc:	48 85 c0             	test   %rax,%rax
  801ecf:	75 a6                	jne    801e77 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ed1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801ed8:	00 00 00 
  801edb:	48 8b 00             	mov    (%rax),%rax
  801ede:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ee4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ee7:	89 c6                	mov    %eax,%esi
  801ee9:	48 bf d0 4d 80 00 00 	movabs $0x804dd0,%rdi
  801ef0:	00 00 00 
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  801eff:	00 00 00 
  801f02:	ff d1                	callq  *%rcx
	*dev = 0;
  801f04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f08:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f14:	c9                   	leaveq 
  801f15:	c3                   	retq   

0000000000801f16 <close>:

int
close(int fdnum)
{
  801f16:	55                   	push   %rbp
  801f17:	48 89 e5             	mov    %rsp,%rbp
  801f1a:	48 83 ec 20          	sub    $0x20,%rsp
  801f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f28:	48 89 d6             	mov    %rdx,%rsi
  801f2b:	89 c7                	mov    %eax,%edi
  801f2d:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  801f34:	00 00 00 
  801f37:	ff d0                	callq  *%rax
  801f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f40:	79 05                	jns    801f47 <close+0x31>
		return r;
  801f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f45:	eb 18                	jmp    801f5f <close+0x49>
	else
		return fd_close(fd, 1);
  801f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4b:	be 01 00 00 00       	mov    $0x1,%esi
  801f50:	48 89 c7             	mov    %rax,%rdi
  801f53:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	callq  *%rax
}
  801f5f:	c9                   	leaveq 
  801f60:	c3                   	retq   

0000000000801f61 <close_all>:

void
close_all(void)
{
  801f61:	55                   	push   %rbp
  801f62:	48 89 e5             	mov    %rsp,%rbp
  801f65:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f70:	eb 15                	jmp    801f87 <close_all+0x26>
		close(i);
  801f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f75:	89 c7                	mov    %eax,%edi
  801f77:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  801f7e:	00 00 00 
  801f81:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f87:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f8b:	7e e5                	jle    801f72 <close_all+0x11>
		close(i);
}
  801f8d:	c9                   	leaveq 
  801f8e:	c3                   	retq   

0000000000801f8f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f8f:	55                   	push   %rbp
  801f90:	48 89 e5             	mov    %rsp,%rbp
  801f93:	48 83 ec 40          	sub    $0x40,%rsp
  801f97:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801f9a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f9d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fa1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fa4:	48 89 d6             	mov    %rdx,%rsi
  801fa7:	89 c7                	mov    %eax,%edi
  801fa9:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  801fb0:	00 00 00 
  801fb3:	ff d0                	callq  *%rax
  801fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fb8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fbc:	79 08                	jns    801fc6 <dup+0x37>
		return r;
  801fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc1:	e9 70 01 00 00       	jmpq   802136 <dup+0x1a7>
	close(newfdnum);
  801fc6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fc9:	89 c7                	mov    %eax,%edi
  801fcb:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fd7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fda:	48 98                	cltq   
  801fdc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fe2:	48 c1 e0 0c          	shl    $0xc,%rax
  801fe6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801fea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fee:	48 89 c7             	mov    %rax,%rdi
  801ff1:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
  801ffd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802005:	48 89 c7             	mov    %rax,%rdi
  802008:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  80200f:	00 00 00 
  802012:	ff d0                	callq  *%rax
  802014:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80201c:	48 89 c2             	mov    %rax,%rdx
  80201f:	48 c1 ea 15          	shr    $0x15,%rdx
  802023:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80202a:	01 00 00 
  80202d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802031:	83 e0 01             	and    $0x1,%eax
  802034:	84 c0                	test   %al,%al
  802036:	74 71                	je     8020a9 <dup+0x11a>
  802038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203c:	48 89 c2             	mov    %rax,%rdx
  80203f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802043:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80204a:	01 00 00 
  80204d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802051:	83 e0 01             	and    $0x1,%eax
  802054:	84 c0                	test   %al,%al
  802056:	74 51                	je     8020a9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205c:	48 89 c2             	mov    %rax,%rdx
  80205f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802063:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80206a:	01 00 00 
  80206d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802071:	89 c1                	mov    %eax,%ecx
  802073:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802079:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80207d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802081:	41 89 c8             	mov    %ecx,%r8d
  802084:	48 89 d1             	mov    %rdx,%rcx
  802087:	ba 00 00 00 00       	mov    $0x0,%edx
  80208c:	48 89 c6             	mov    %rax,%rsi
  80208f:	bf 00 00 00 00       	mov    $0x0,%edi
  802094:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  80209b:	00 00 00 
  80209e:	ff d0                	callq  *%rax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020a7:	78 56                	js     8020ff <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ad:	48 89 c2             	mov    %rax,%rdx
  8020b0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8020b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020bb:	01 00 00 
  8020be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8020ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d2:	41 89 c8             	mov    %ecx,%r8d
  8020d5:	48 89 d1             	mov    %rdx,%rcx
  8020d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020dd:	48 89 c6             	mov    %rax,%rsi
  8020e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e5:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  8020ec:	00 00 00 
  8020ef:	ff d0                	callq  *%rax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020f8:	78 08                	js     802102 <dup+0x173>
		goto err;

	return newfdnum;
  8020fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020fd:	eb 37                	jmp    802136 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8020ff:	90                   	nop
  802100:	eb 01                	jmp    802103 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802102:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802107:	48 89 c6             	mov    %rax,%rsi
  80210a:	bf 00 00 00 00       	mov    $0x0,%edi
  80210f:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80211b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80211f:	48 89 c6             	mov    %rax,%rsi
  802122:	bf 00 00 00 00       	mov    $0x0,%edi
  802127:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax
	return r;
  802133:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802136:	c9                   	leaveq 
  802137:	c3                   	retq   

0000000000802138 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802138:	55                   	push   %rbp
  802139:	48 89 e5             	mov    %rsp,%rbp
  80213c:	48 83 ec 40          	sub    $0x40,%rsp
  802140:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802143:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802147:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80214f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802152:	48 89 d6             	mov    %rdx,%rsi
  802155:	89 c7                	mov    %eax,%edi
  802157:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  80215e:	00 00 00 
  802161:	ff d0                	callq  *%rax
  802163:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802166:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216a:	78 24                	js     802190 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80216c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802170:	8b 00                	mov    (%rax),%eax
  802172:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802176:	48 89 d6             	mov    %rdx,%rsi
  802179:	89 c7                	mov    %eax,%edi
  80217b:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  802182:	00 00 00 
  802185:	ff d0                	callq  *%rax
  802187:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218e:	79 05                	jns    802195 <read+0x5d>
		return r;
  802190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802193:	eb 7a                	jmp    80220f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802199:	8b 40 08             	mov    0x8(%rax),%eax
  80219c:	83 e0 03             	and    $0x3,%eax
  80219f:	83 f8 01             	cmp    $0x1,%eax
  8021a2:	75 3a                	jne    8021de <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021a4:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8021ab:	00 00 00 
  8021ae:	48 8b 00             	mov    (%rax),%rax
  8021b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ba:	89 c6                	mov    %eax,%esi
  8021bc:	48 bf ef 4d 80 00 00 	movabs $0x804def,%rdi
  8021c3:	00 00 00 
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  8021d2:	00 00 00 
  8021d5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021dc:	eb 31                	jmp    80220f <read+0xd7>
	}
	if (!dev->dev_read)
  8021de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021e6:	48 85 c0             	test   %rax,%rax
  8021e9:	75 07                	jne    8021f2 <read+0xba>
		return -E_NOT_SUPP;
  8021eb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021f0:	eb 1d                	jmp    80220f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8021f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8021fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fe:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802202:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802206:	48 89 ce             	mov    %rcx,%rsi
  802209:	48 89 c7             	mov    %rax,%rdi
  80220c:	41 ff d0             	callq  *%r8
}
  80220f:	c9                   	leaveq 
  802210:	c3                   	retq   

0000000000802211 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802211:	55                   	push   %rbp
  802212:	48 89 e5             	mov    %rsp,%rbp
  802215:	48 83 ec 30          	sub    $0x30,%rsp
  802219:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80221c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802220:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802224:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222b:	eb 46                	jmp    802273 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80222d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802230:	48 98                	cltq   
  802232:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802236:	48 29 c2             	sub    %rax,%rdx
  802239:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80223c:	48 98                	cltq   
  80223e:	48 89 c1             	mov    %rax,%rcx
  802241:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802245:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802248:	48 89 ce             	mov    %rcx,%rsi
  80224b:	89 c7                	mov    %eax,%edi
  80224d:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  802254:	00 00 00 
  802257:	ff d0                	callq  *%rax
  802259:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80225c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802260:	79 05                	jns    802267 <readn+0x56>
			return m;
  802262:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802265:	eb 1d                	jmp    802284 <readn+0x73>
		if (m == 0)
  802267:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80226b:	74 13                	je     802280 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80226d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802270:	01 45 fc             	add    %eax,-0x4(%rbp)
  802273:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802276:	48 98                	cltq   
  802278:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80227c:	72 af                	jb     80222d <readn+0x1c>
  80227e:	eb 01                	jmp    802281 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802280:	90                   	nop
	}
	return tot;
  802281:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802284:	c9                   	leaveq 
  802285:	c3                   	retq   

0000000000802286 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802286:	55                   	push   %rbp
  802287:	48 89 e5             	mov    %rsp,%rbp
  80228a:	48 83 ec 40          	sub    $0x40,%rsp
  80228e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802291:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802295:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802299:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80229d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022a0:	48 89 d6             	mov    %rdx,%rsi
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b8:	78 24                	js     8022de <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022be:	8b 00                	mov    (%rax),%eax
  8022c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c4:	48 89 d6             	mov    %rdx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dc:	79 05                	jns    8022e3 <write+0x5d>
		return r;
  8022de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e1:	eb 79                	jmp    80235c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e7:	8b 40 08             	mov    0x8(%rax),%eax
  8022ea:	83 e0 03             	and    $0x3,%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 3a                	jne    80232b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8022f8:	00 00 00 
  8022fb:	48 8b 00             	mov    (%rax),%rax
  8022fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802304:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802307:	89 c6                	mov    %eax,%esi
  802309:	48 bf 0b 4e 80 00 00 	movabs $0x804e0b,%rdi
  802310:	00 00 00 
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  80231f:	00 00 00 
  802322:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802324:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802329:	eb 31                	jmp    80235c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80232b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802333:	48 85 c0             	test   %rax,%rax
  802336:	75 07                	jne    80233f <write+0xb9>
		return -E_NOT_SUPP;
  802338:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80233d:	eb 1d                	jmp    80235c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80233f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802343:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802347:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80234f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802353:	48 89 ce             	mov    %rcx,%rsi
  802356:	48 89 c7             	mov    %rax,%rdi
  802359:	41 ff d0             	callq  *%r8
}
  80235c:	c9                   	leaveq 
  80235d:	c3                   	retq   

000000000080235e <seek>:

int
seek(int fdnum, off_t offset)
{
  80235e:	55                   	push   %rbp
  80235f:	48 89 e5             	mov    %rsp,%rbp
  802362:	48 83 ec 18          	sub    $0x18,%rsp
  802366:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802369:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80236c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802370:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802373:	48 89 d6             	mov    %rdx,%rsi
  802376:	89 c7                	mov    %eax,%edi
  802378:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  80237f:	00 00 00 
  802382:	ff d0                	callq  *%rax
  802384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238b:	79 05                	jns    802392 <seek+0x34>
		return r;
  80238d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802390:	eb 0f                	jmp    8023a1 <seek+0x43>
	fd->fd_offset = offset;
  802392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802396:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802399:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a1:	c9                   	leaveq 
  8023a2:	c3                   	retq   

00000000008023a3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023a3:	55                   	push   %rbp
  8023a4:	48 89 e5             	mov    %rsp,%rbp
  8023a7:	48 83 ec 30          	sub    $0x30,%rsp
  8023ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023b8:	48 89 d6             	mov    %rdx,%rsi
  8023bb:	89 c7                	mov    %eax,%edi
  8023bd:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  8023c4:	00 00 00 
  8023c7:	ff d0                	callq  *%rax
  8023c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d0:	78 24                	js     8023f6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d6:	8b 00                	mov    (%rax),%eax
  8023d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023dc:	48 89 d6             	mov    %rdx,%rsi
  8023df:	89 c7                	mov    %eax,%edi
  8023e1:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  8023e8:	00 00 00 
  8023eb:	ff d0                	callq  *%rax
  8023ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f4:	79 05                	jns    8023fb <ftruncate+0x58>
		return r;
  8023f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f9:	eb 72                	jmp    80246d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ff:	8b 40 08             	mov    0x8(%rax),%eax
  802402:	83 e0 03             	and    $0x3,%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	75 3a                	jne    802443 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802409:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802410:	00 00 00 
  802413:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802416:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80241c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80241f:	89 c6                	mov    %eax,%esi
  802421:	48 bf 28 4e 80 00 00 	movabs $0x804e28,%rdi
  802428:	00 00 00 
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  802437:	00 00 00 
  80243a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80243c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802441:	eb 2a                	jmp    80246d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802443:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802447:	48 8b 40 30          	mov    0x30(%rax),%rax
  80244b:	48 85 c0             	test   %rax,%rax
  80244e:	75 07                	jne    802457 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802450:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802455:	eb 16                	jmp    80246d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80245f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802463:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802466:	89 d6                	mov    %edx,%esi
  802468:	48 89 c7             	mov    %rax,%rdi
  80246b:	ff d1                	callq  *%rcx
}
  80246d:	c9                   	leaveq 
  80246e:	c3                   	retq   

000000000080246f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80246f:	55                   	push   %rbp
  802470:	48 89 e5             	mov    %rsp,%rbp
  802473:	48 83 ec 30          	sub    $0x30,%rsp
  802477:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80247e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802482:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802485:	48 89 d6             	mov    %rdx,%rsi
  802488:	89 c7                	mov    %eax,%edi
  80248a:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
  802496:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802499:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249d:	78 24                	js     8024c3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80249f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a3:	8b 00                	mov    (%rax),%eax
  8024a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a9:	48 89 d6             	mov    %rdx,%rsi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	48 b8 5f 1e 80 00 00 	movabs $0x801e5f,%rax
  8024b5:	00 00 00 
  8024b8:	ff d0                	callq  *%rax
  8024ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c1:	79 05                	jns    8024c8 <fstat+0x59>
		return r;
  8024c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c6:	eb 5e                	jmp    802526 <fstat+0xb7>
	if (!dev->dev_stat)
  8024c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d0:	48 85 c0             	test   %rax,%rax
  8024d3:	75 07                	jne    8024dc <fstat+0x6d>
		return -E_NOT_SUPP;
  8024d5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024da:	eb 4a                	jmp    802526 <fstat+0xb7>
	stat->st_name[0] = 0;
  8024dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024ee:	00 00 00 
	stat->st_isdir = 0;
  8024f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8024fc:	00 00 00 
	stat->st_dev = dev;
  8024ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802503:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802507:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80250e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802512:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802516:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80251e:	48 89 d6             	mov    %rdx,%rsi
  802521:	48 89 c7             	mov    %rax,%rdi
  802524:	ff d1                	callq  *%rcx
}
  802526:	c9                   	leaveq 
  802527:	c3                   	retq   

0000000000802528 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802528:	55                   	push   %rbp
  802529:	48 89 e5             	mov    %rsp,%rbp
  80252c:	48 83 ec 20          	sub    $0x20,%rsp
  802530:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802534:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80253c:	be 00 00 00 00       	mov    $0x0,%esi
  802541:	48 89 c7             	mov    %rax,%rdi
  802544:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax
  802550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802557:	79 05                	jns    80255e <stat+0x36>
		return fd;
  802559:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80255c:	eb 2f                	jmp    80258d <stat+0x65>
	r = fstat(fd, stat);
  80255e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	48 89 d6             	mov    %rdx,%rsi
  802568:	89 c7                	mov    %eax,%edi
  80256a:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  802571:	00 00 00 
  802574:	ff d0                	callq  *%rax
  802576:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  802585:	00 00 00 
  802588:	ff d0                	callq  *%rax
	return r;
  80258a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   
	...

0000000000802590 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802590:	55                   	push   %rbp
  802591:	48 89 e5             	mov    %rsp,%rbp
  802594:	48 83 ec 10          	sub    $0x10,%rsp
  802598:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80259b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80259f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025a6:	00 00 00 
  8025a9:	8b 00                	mov    (%rax),%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	75 1d                	jne    8025cc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025af:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b4:	48 b8 3f 47 80 00 00 	movabs $0x80473f,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax
  8025c0:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  8025c7:	00 00 00 
  8025ca:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025cc:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025d3:	00 00 00 
  8025d6:	8b 00                	mov    (%rax),%eax
  8025d8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025db:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025e0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8025e7:	00 00 00 
  8025ea:	89 c7                	mov    %eax,%edi
  8025ec:	48 b8 7c 46 80 00 00 	movabs $0x80467c,%rax
  8025f3:	00 00 00 
  8025f6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802601:	48 89 c6             	mov    %rax,%rsi
  802604:	bf 00 00 00 00       	mov    $0x0,%edi
  802609:	48 b8 bc 45 80 00 00 	movabs $0x8045bc,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
}
  802615:	c9                   	leaveq 
  802616:	c3                   	retq   

0000000000802617 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802617:	55                   	push   %rbp
  802618:	48 89 e5             	mov    %rsp,%rbp
  80261b:	48 83 ec 20          	sub    $0x20,%rsp
  80261f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802623:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802626:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262a:	48 89 c7             	mov    %rax,%rdi
  80262d:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  802634:	00 00 00 
  802637:	ff d0                	callq  *%rax
  802639:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80263e:	7e 0a                	jle    80264a <open+0x33>
                return -E_BAD_PATH;
  802640:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802645:	e9 a5 00 00 00       	jmpq   8026ef <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80264a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80264e:	48 89 c7             	mov    %rax,%rdi
  802651:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  802658:	00 00 00 
  80265b:	ff d0                	callq  *%rax
  80265d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802660:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802664:	79 08                	jns    80266e <open+0x57>
		return r;
  802666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802669:	e9 81 00 00 00       	jmpq   8026ef <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80266e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802672:	48 89 c6             	mov    %rax,%rsi
  802675:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80267c:	00 00 00 
  80267f:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  802686:	00 00 00 
  802689:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80268b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802692:	00 00 00 
  802695:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802698:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80269e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a2:	48 89 c6             	mov    %rax,%rsi
  8026a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8026aa:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8026b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bd:	79 1d                	jns    8026dc <open+0xc5>
	{
		fd_close(fd,0);
  8026bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c3:	be 00 00 00 00       	mov    $0x0,%esi
  8026c8:	48 89 c7             	mov    %rax,%rdi
  8026cb:	48 b8 96 1d 80 00 00 	movabs $0x801d96,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	callq  *%rax
		return r;
  8026d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026da:	eb 13                	jmp    8026ef <open+0xd8>
	}
	return fd2num(fd);
  8026dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e0:	48 89 c7             	mov    %rax,%rdi
  8026e3:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  8026ea:	00 00 00 
  8026ed:	ff d0                	callq  *%rax
	


}
  8026ef:	c9                   	leaveq 
  8026f0:	c3                   	retq   

00000000008026f1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026f1:	55                   	push   %rbp
  8026f2:	48 89 e5             	mov    %rsp,%rbp
  8026f5:	48 83 ec 10          	sub    $0x10,%rsp
  8026f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802701:	8b 50 0c             	mov    0xc(%rax),%edx
  802704:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80270b:	00 00 00 
  80270e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802710:	be 00 00 00 00       	mov    $0x0,%esi
  802715:	bf 06 00 00 00       	mov    $0x6,%edi
  80271a:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
}
  802726:	c9                   	leaveq 
  802727:	c3                   	retq   

0000000000802728 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802728:	55                   	push   %rbp
  802729:	48 89 e5             	mov    %rsp,%rbp
  80272c:	48 83 ec 30          	sub    $0x30,%rsp
  802730:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802734:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802738:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80273c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802740:	8b 50 0c             	mov    0xc(%rax),%edx
  802743:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80274a:	00 00 00 
  80274d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80274f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802756:	00 00 00 
  802759:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80275d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802761:	be 00 00 00 00       	mov    $0x0,%esi
  802766:	bf 03 00 00 00       	mov    $0x3,%edi
  80276b:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	79 05                	jns    802785 <devfile_read+0x5d>
	{
		return r;
  802780:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802783:	eb 2c                	jmp    8027b1 <devfile_read+0x89>
	}
	if(r > 0)
  802785:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802789:	7e 23                	jle    8027ae <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80278b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278e:	48 63 d0             	movslq %eax,%rdx
  802791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802795:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80279c:	00 00 00 
  80279f:	48 89 c7             	mov    %rax,%rdi
  8027a2:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8027a9:	00 00 00 
  8027ac:	ff d0                	callq  *%rax
	return r;
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8027b1:	c9                   	leaveq 
  8027b2:	c3                   	retq   

00000000008027b3 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027b3:	55                   	push   %rbp
  8027b4:	48 89 e5             	mov    %rsp,%rbp
  8027b7:	48 83 ec 30          	sub    $0x30,%rsp
  8027bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8027c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8027ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027d5:	00 00 00 
  8027d8:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8027da:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8027e1:	00 
  8027e2:	76 08                	jbe    8027ec <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8027e4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8027eb:	00 
	fsipcbuf.write.req_n=n;
  8027ec:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027f3:	00 00 00 
  8027f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027fa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8027fe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802802:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802806:	48 89 c6             	mov    %rax,%rsi
  802809:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802810:	00 00 00 
  802813:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80281f:	be 00 00 00 00       	mov    $0x0,%esi
  802824:	bf 04 00 00 00       	mov    $0x4,%edi
  802829:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80283b:	c9                   	leaveq 
  80283c:	c3                   	retq   

000000000080283d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  80283d:	55                   	push   %rbp
  80283e:	48 89 e5             	mov    %rsp,%rbp
  802841:	48 83 ec 10          	sub    $0x10,%rsp
  802845:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802849:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80284c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802850:	8b 50 0c             	mov    0xc(%rax),%edx
  802853:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80285a:	00 00 00 
  80285d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80285f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802866:	00 00 00 
  802869:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80286c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80286f:	be 00 00 00 00       	mov    $0x0,%esi
  802874:	bf 02 00 00 00       	mov    $0x2,%edi
  802879:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
}
  802885:	c9                   	leaveq 
  802886:	c3                   	retq   

0000000000802887 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802887:	55                   	push   %rbp
  802888:	48 89 e5             	mov    %rsp,%rbp
  80288b:	48 83 ec 20          	sub    $0x20,%rsp
  80288f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802893:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289b:	8b 50 0c             	mov    0xc(%rax),%edx
  80289e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028a5:	00 00 00 
  8028a8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028aa:	be 00 00 00 00       	mov    $0x0,%esi
  8028af:	bf 05 00 00 00       	mov    $0x5,%edi
  8028b4:	48 b8 90 25 80 00 00 	movabs $0x802590,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c7:	79 05                	jns    8028ce <devfile_stat+0x47>
		return r;
  8028c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cc:	eb 56                	jmp    802924 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028d2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028d9:	00 00 00 
  8028dc:	48 89 c7             	mov    %rax,%rdi
  8028df:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028eb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f2:	00 00 00 
  8028f5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8028fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ff:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802905:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290c:	00 00 00 
  80290f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802915:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802919:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802924:	c9                   	leaveq 
  802925:	c3                   	retq   
	...

0000000000802928 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802928:	55                   	push   %rbp
  802929:	48 89 e5             	mov    %rsp,%rbp
  80292c:	53                   	push   %rbx
  80292d:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  802934:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  80293b:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802942:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802949:	be 00 00 00 00       	mov    $0x0,%esi
  80294e:	48 89 c7             	mov    %rax,%rdi
  802951:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  802958:	00 00 00 
  80295b:	ff d0                	callq  *%rax
  80295d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802960:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802964:	79 08                	jns    80296e <spawn+0x46>
		return r;
  802966:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802969:	e9 1d 03 00 00       	jmpq   802c8b <spawn+0x363>
	fd = r;
  80296e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802971:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802974:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  80297b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80297f:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  802986:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802989:	ba 00 02 00 00       	mov    $0x200,%edx
  80298e:	48 89 ce             	mov    %rcx,%rsi
  802991:	89 c7                	mov    %eax,%edi
  802993:	48 b8 11 22 80 00 00 	movabs $0x802211,%rax
  80299a:	00 00 00 
  80299d:	ff d0                	callq  *%rax
  80299f:	3d 00 02 00 00       	cmp    $0x200,%eax
  8029a4:	75 0d                	jne    8029b3 <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  8029a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029aa:	8b 00                	mov    (%rax),%eax
  8029ac:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8029b1:	74 43                	je     8029f6 <spawn+0xce>
		close(fd);
  8029b3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8029b6:	89 c7                	mov    %eax,%edi
  8029b8:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  8029bf:	00 00 00 
  8029c2:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8029c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029c8:	8b 00                	mov    (%rax),%eax
  8029ca:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8029cf:	89 c6                	mov    %eax,%esi
  8029d1:	48 bf 50 4e 80 00 00 	movabs $0x804e50,%rdi
  8029d8:	00 00 00 
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  8029e7:	00 00 00 
  8029ea:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  8029ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8029f1:	e9 95 02 00 00       	jmpq   802c8b <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8029f6:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  8029fd:	00 00 00 
  802a00:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  802a06:	cd 30                	int    $0x30
  802a08:	89 c3                	mov    %eax,%ebx
  802a0a:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802a0d:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802a10:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802a13:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802a17:	79 08                	jns    802a21 <spawn+0xf9>
		return r;
  802a19:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802a1c:	e9 6a 02 00 00       	jmpq   802c8b <spawn+0x363>
	child = r;
  802a21:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802a24:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802a27:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a2a:	25 ff 03 00 00       	and    $0x3ff,%eax
  802a2f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802a36:	00 00 00 
  802a39:	48 63 d0             	movslq %eax,%rdx
  802a3c:	48 89 d0             	mov    %rdx,%rax
  802a3f:	48 c1 e0 03          	shl    $0x3,%rax
  802a43:	48 01 d0             	add    %rdx,%rax
  802a46:	48 c1 e0 05          	shl    $0x5,%rax
  802a4a:	48 01 c8             	add    %rcx,%rax
  802a4d:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802a54:	48 89 c6             	mov    %rax,%rsi
  802a57:	b8 18 00 00 00       	mov    $0x18,%eax
  802a5c:	48 89 d7             	mov    %rdx,%rdi
  802a5f:	48 89 c1             	mov    %rax,%rcx
  802a62:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802a65:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a69:	48 8b 40 18          	mov    0x18(%rax),%rax
  802a6d:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802a74:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  802a7b:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802a82:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  802a89:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a8c:	48 89 ce             	mov    %rcx,%rsi
  802a8f:	89 c7                	mov    %eax,%edi
  802a91:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  802a98:	00 00 00 
  802a9b:	ff d0                	callq  *%rax
  802a9d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802aa0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802aa4:	79 08                	jns    802aae <spawn+0x186>
		return r;
  802aa6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802aa9:	e9 dd 01 00 00       	jmpq   802c8b <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802aae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ab2:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ab6:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  802abd:	48 01 d0             	add    %rdx,%rax
  802ac0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ac4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802acb:	eb 7a                	jmp    802b47 <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  802acd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad1:	8b 00                	mov    (%rax),%eax
  802ad3:	83 f8 01             	cmp    $0x1,%eax
  802ad6:	75 65                	jne    802b3d <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  802ad8:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802adf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ae3:	8b 40 04             	mov    0x4(%rax),%eax
  802ae6:	83 e0 02             	and    $0x2,%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 04                	je     802af1 <spawn+0x1c9>
			perm |= PTE_W;
  802aed:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af5:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802af9:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b00:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b08:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802b0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b10:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802b14:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802b17:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b1a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802b1d:	89 3c 24             	mov    %edi,(%rsp)
  802b20:	89 c7                	mov    %eax,%edi
  802b22:	48 b8 53 31 80 00 00 	movabs $0x803153,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
  802b2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b35:	0f 88 2a 01 00 00    	js     802c65 <spawn+0x33d>
  802b3b:	eb 01                	jmp    802b3e <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802b3d:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b3e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802b42:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  802b47:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b4b:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802b4f:	0f b7 c0             	movzwl %ax,%eax
  802b52:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802b55:	0f 8f 72 ff ff ff    	jg     802acd <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802b5b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b5e:	89 c7                	mov    %eax,%edi
  802b60:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
	fd = -1;
  802b6c:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802b73:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b76:	89 c7                	mov    %eax,%edi
  802b78:	48 b8 3a 33 80 00 00 	movabs $0x80333a,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b87:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b8b:	79 30                	jns    802bbd <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  802b8d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b90:	89 c1                	mov    %eax,%ecx
  802b92:	48 ba 6a 4e 80 00 00 	movabs $0x804e6a,%rdx
  802b99:	00 00 00 
  802b9c:	be 82 00 00 00       	mov    $0x82,%esi
  802ba1:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  802ba8:	00 00 00 
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  802bb7:	00 00 00 
  802bba:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bbd:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802bc4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802bc7:	48 89 d6             	mov    %rdx,%rsi
  802bca:	89 c7                	mov    %eax,%edi
  802bcc:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802bd3:	00 00 00 
  802bd6:	ff d0                	callq  *%rax
  802bd8:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802bdb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802bdf:	79 30                	jns    802c11 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  802be1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802be4:	89 c1                	mov    %eax,%ecx
  802be6:	48 ba 8c 4e 80 00 00 	movabs $0x804e8c,%rdx
  802bed:	00 00 00 
  802bf0:	be 85 00 00 00       	mov    $0x85,%esi
  802bf5:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  802bfc:	00 00 00 
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  802c0b:	00 00 00 
  802c0e:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802c11:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c14:	be 02 00 00 00       	mov    $0x2,%esi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
  802c27:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802c2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802c2e:	79 30                	jns    802c60 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  802c30:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802c33:	89 c1                	mov    %eax,%ecx
  802c35:	48 ba a6 4e 80 00 00 	movabs $0x804ea6,%rdx
  802c3c:	00 00 00 
  802c3f:	be 88 00 00 00       	mov    $0x88,%esi
  802c44:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  802c4b:	00 00 00 
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c53:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  802c5a:	00 00 00 
  802c5d:	41 ff d0             	callq  *%r8

	return child;
  802c60:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c63:	eb 26                	jmp    802c8b <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802c65:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802c66:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c69:	89 c7                	mov    %eax,%edi
  802c6b:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
	close(fd);
  802c77:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c7a:	89 c7                	mov    %eax,%edi
  802c7c:	48 b8 16 1f 80 00 00 	movabs $0x801f16,%rax
  802c83:	00 00 00 
  802c86:	ff d0                	callq  *%rax
	return r;
  802c88:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  802c8b:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  802c92:	5b                   	pop    %rbx
  802c93:	5d                   	pop    %rbp
  802c94:	c3                   	retq   

0000000000802c95 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802c95:	55                   	push   %rbp
  802c96:	48 89 e5             	mov    %rsp,%rbp
  802c99:	53                   	push   %rbx
  802c9a:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  802ca1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ca8:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  802caf:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802cb6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802cbd:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802cc4:	84 c0                	test   %al,%al
  802cc6:	74 23                	je     802ceb <spawnl+0x56>
  802cc8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802ccf:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802cd3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802cd7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802cdb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802cdf:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802ce3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802ce7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802ceb:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802cf2:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  802cf9:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802cfc:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802d03:	00 00 00 
  802d06:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802d0d:	00 00 00 
  802d10:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d14:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802d1b:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802d22:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802d29:	eb 07                	jmp    802d32 <spawnl+0x9d>
		argc++;
  802d2b:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802d32:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802d38:	83 f8 30             	cmp    $0x30,%eax
  802d3b:	73 23                	jae    802d60 <spawnl+0xcb>
  802d3d:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802d44:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802d4a:	89 c0                	mov    %eax,%eax
  802d4c:	48 01 d0             	add    %rdx,%rax
  802d4f:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802d55:	83 c2 08             	add    $0x8,%edx
  802d58:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802d5e:	eb 15                	jmp    802d75 <spawnl+0xe0>
  802d60:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802d67:	48 89 d0             	mov    %rdx,%rax
  802d6a:	48 83 c2 08          	add    $0x8,%rdx
  802d6e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802d75:	48 8b 00             	mov    (%rax),%rax
  802d78:	48 85 c0             	test   %rax,%rax
  802d7b:	75 ae                	jne    802d2b <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802d7d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802d83:	83 c0 02             	add    $0x2,%eax
  802d86:	48 89 e2             	mov    %rsp,%rdx
  802d89:	48 89 d3             	mov    %rdx,%rbx
  802d8c:	48 63 d0             	movslq %eax,%rdx
  802d8f:	48 83 ea 01          	sub    $0x1,%rdx
  802d93:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  802d9a:	48 98                	cltq   
  802d9c:	48 c1 e0 03          	shl    $0x3,%rax
  802da0:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  802da4:	b8 10 00 00 00       	mov    $0x10,%eax
  802da9:	48 83 e8 01          	sub    $0x1,%rax
  802dad:	48 01 d0             	add    %rdx,%rax
  802db0:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  802db7:	10 00 00 00 
  802dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc0:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  802dc7:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802dcb:	48 29 c4             	sub    %rax,%rsp
  802dce:	48 89 e0             	mov    %rsp,%rax
  802dd1:	48 83 c0 0f          	add    $0xf,%rax
  802dd5:	48 c1 e8 04          	shr    $0x4,%rax
  802dd9:	48 c1 e0 04          	shl    $0x4,%rax
  802ddd:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  802de4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802deb:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  802df2:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802df5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802dfb:	8d 50 01             	lea    0x1(%rax),%edx
  802dfe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802e05:	48 63 d2             	movslq %edx,%rdx
  802e08:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802e0f:	00 

	va_start(vl, arg0);
  802e10:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802e17:	00 00 00 
  802e1a:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802e21:	00 00 00 
  802e24:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e28:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802e2f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802e36:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802e3d:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  802e44:	00 00 00 
  802e47:	eb 63                	jmp    802eac <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  802e49:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  802e4f:	8d 70 01             	lea    0x1(%rax),%esi
  802e52:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802e58:	83 f8 30             	cmp    $0x30,%eax
  802e5b:	73 23                	jae    802e80 <spawnl+0x1eb>
  802e5d:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802e64:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802e6a:	89 c0                	mov    %eax,%eax
  802e6c:	48 01 d0             	add    %rdx,%rax
  802e6f:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802e75:	83 c2 08             	add    $0x8,%edx
  802e78:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802e7e:	eb 15                	jmp    802e95 <spawnl+0x200>
  802e80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802e87:	48 89 d0             	mov    %rdx,%rax
  802e8a:	48 83 c2 08          	add    $0x8,%rdx
  802e8e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802e95:	48 8b 08             	mov    (%rax),%rcx
  802e98:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802e9f:	89 f2                	mov    %esi,%edx
  802ea1:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802ea5:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  802eac:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802eb2:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  802eb8:	77 8f                	ja     802e49 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802eba:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  802ec1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ec8:	48 89 d6             	mov    %rdx,%rsi
  802ecb:	48 89 c7             	mov    %rax,%rdi
  802ece:	48 b8 28 29 80 00 00 	movabs $0x802928,%rax
  802ed5:	00 00 00 
  802ed8:	ff d0                	callq  *%rax
  802eda:	48 89 dc             	mov    %rbx,%rsp
}
  802edd:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  802ee1:	c9                   	leaveq 
  802ee2:	c3                   	retq   

0000000000802ee3 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  802ee3:	55                   	push   %rbp
  802ee4:	48 89 e5             	mov    %rsp,%rbp
  802ee7:	48 83 ec 50          	sub    $0x50,%rsp
  802eeb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802eee:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  802ef2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802ef6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802efd:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  802efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  802f05:	eb 2c                	jmp    802f33 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  802f07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f0a:	48 98                	cltq   
  802f0c:	48 c1 e0 03          	shl    $0x3,%rax
  802f10:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802f14:	48 8b 00             	mov    (%rax),%rax
  802f17:	48 89 c7             	mov    %rax,%rdi
  802f1a:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
  802f26:	83 c0 01             	add    $0x1,%eax
  802f29:	48 98                	cltq   
  802f2b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802f2f:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  802f33:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f36:	48 98                	cltq   
  802f38:	48 c1 e0 03          	shl    $0x3,%rax
  802f3c:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802f40:	48 8b 00             	mov    (%rax),%rax
  802f43:	48 85 c0             	test   %rax,%rax
  802f46:	75 bf                	jne    802f07 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802f48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f4c:	48 f7 d8             	neg    %rax
  802f4f:	48 05 00 10 40 00    	add    $0x401000,%rax
  802f55:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  802f59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802f61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f65:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  802f69:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f6c:	83 c2 01             	add    $0x1,%edx
  802f6f:	c1 e2 03             	shl    $0x3,%edx
  802f72:	48 63 d2             	movslq %edx,%rdx
  802f75:	48 f7 da             	neg    %rdx
  802f78:	48 01 d0             	add    %rdx,%rax
  802f7b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802f7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f83:	48 83 e8 10          	sub    $0x10,%rax
  802f87:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  802f8d:	77 0a                	ja     802f99 <init_stack+0xb6>
		return -E_NO_MEM;
  802f8f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802f94:	e9 b8 01 00 00       	jmpq   803151 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802f99:	ba 07 00 00 00       	mov    $0x7,%edx
  802f9e:	be 00 00 40 00       	mov    $0x400000,%esi
  802fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa8:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fbb:	79 08                	jns    802fc5 <init_stack+0xe2>
		return r;
  802fbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc0:	e9 8c 01 00 00       	jmpq   803151 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802fc5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  802fcc:	eb 73                	jmp    803041 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  802fce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fd1:	48 98                	cltq   
  802fd3:	48 c1 e0 03          	shl    $0x3,%rax
  802fd7:	48 03 45 d0          	add    -0x30(%rbp),%rax
  802fdb:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  802fe0:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  802fe4:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  802feb:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  802fee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ff1:	48 98                	cltq   
  802ff3:	48 c1 e0 03          	shl    $0x3,%rax
  802ff7:	48 03 45 c0          	add    -0x40(%rbp),%rax
  802ffb:	48 8b 10             	mov    (%rax),%rdx
  802ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803002:	48 89 d6             	mov    %rdx,%rsi
  803005:	48 89 c7             	mov    %rax,%rdi
  803008:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80300f:	00 00 00 
  803012:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803014:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803017:	48 98                	cltq   
  803019:	48 c1 e0 03          	shl    $0x3,%rax
  80301d:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803021:	48 8b 00             	mov    (%rax),%rax
  803024:	48 89 c7             	mov    %rax,%rdi
  803027:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  80302e:	00 00 00 
  803031:	ff d0                	callq  *%rax
  803033:	48 98                	cltq   
  803035:	48 83 c0 01          	add    $0x1,%rax
  803039:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80303d:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803041:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803044:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803047:	7c 85                	jl     802fce <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803049:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80304c:	48 98                	cltq   
  80304e:	48 c1 e0 03          	shl    $0x3,%rax
  803052:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803056:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80305d:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803064:	00 
  803065:	74 35                	je     80309c <init_stack+0x1b9>
  803067:	48 b9 c0 4e 80 00 00 	movabs $0x804ec0,%rcx
  80306e:	00 00 00 
  803071:	48 ba e6 4e 80 00 00 	movabs $0x804ee6,%rdx
  803078:	00 00 00 
  80307b:	be f1 00 00 00       	mov    $0xf1,%esi
  803080:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  803087:	00 00 00 
  80308a:	b8 00 00 00 00       	mov    $0x0,%eax
  80308f:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  803096:	00 00 00 
  803099:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80309c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a0:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8030a4:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  8030a9:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8030ad:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8030b3:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  8030b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ba:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  8030be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030c1:	48 98                	cltq   
  8030c3:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8030c6:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  8030cb:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8030cf:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8030d5:	48 89 c2             	mov    %rax,%rdx
  8030d8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8030dc:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8030df:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8030e2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8030e8:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8030ed:	89 c2                	mov    %eax,%edx
  8030ef:	be 00 00 40 00       	mov    $0x400000,%esi
  8030f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f9:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803100:	00 00 00 
  803103:	ff d0                	callq  *%rax
  803105:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803108:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80310c:	78 26                	js     803134 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80310e:	be 00 00 40 00       	mov    $0x400000,%esi
  803113:	bf 00 00 00 00       	mov    $0x0,%edi
  803118:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  80311f:	00 00 00 
  803122:	ff d0                	callq  *%rax
  803124:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803127:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80312b:	78 0a                	js     803137 <init_stack+0x254>
		goto error;

	return 0;
  80312d:	b8 00 00 00 00       	mov    $0x0,%eax
  803132:	eb 1d                	jmp    803151 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803134:	90                   	nop
  803135:	eb 01                	jmp    803138 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803137:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803138:	be 00 00 40 00       	mov    $0x400000,%esi
  80313d:	bf 00 00 00 00       	mov    $0x0,%edi
  803142:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803149:	00 00 00 
  80314c:	ff d0                	callq  *%rax
	return r;
  80314e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803151:	c9                   	leaveq 
  803152:	c3                   	retq   

0000000000803153 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803153:	55                   	push   %rbp
  803154:	48 89 e5             	mov    %rsp,%rbp
  803157:	48 83 ec 50          	sub    $0x50,%rsp
  80315b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80315e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803162:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803166:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803169:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80316d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803171:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803175:	25 ff 0f 00 00       	and    $0xfff,%eax
  80317a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803181:	74 21                	je     8031a4 <map_segment+0x51>
		va -= i;
  803183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803186:	48 98                	cltq   
  803188:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80318c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318f:	48 98                	cltq   
  803191:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803198:	48 98                	cltq   
  80319a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a1:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8031a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031ab:	e9 74 01 00 00       	jmpq   803324 <map_segment+0x1d1>
		if (i >= filesz) {
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b3:	48 98                	cltq   
  8031b5:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  8031b9:	72 38                	jb     8031f3 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8031bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031be:	48 98                	cltq   
  8031c0:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8031c4:	48 89 c1             	mov    %rax,%rcx
  8031c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031ca:	8b 55 10             	mov    0x10(%rbp),%edx
  8031cd:	48 89 ce             	mov    %rcx,%rsi
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031e5:	0f 89 32 01 00 00    	jns    80331d <map_segment+0x1ca>
				return r;
  8031eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ee:	e9 45 01 00 00       	jmpq   803338 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8031f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8031f8:	be 00 00 40 00       	mov    $0x400000,%esi
  8031fd:	bf 00 00 00 00       	mov    $0x0,%edi
  803202:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803209:	00 00 00 
  80320c:	ff d0                	callq  *%rax
  80320e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803211:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803215:	79 08                	jns    80321f <map_segment+0xcc>
				return r;
  803217:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80321a:	e9 19 01 00 00       	jmpq   803338 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  80321f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803222:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803225:	01 c2                	add    %eax,%edx
  803227:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80322a:	89 d6                	mov    %edx,%esi
  80322c:	89 c7                	mov    %eax,%edi
  80322e:	48 b8 5e 23 80 00 00 	movabs $0x80235e,%rax
  803235:	00 00 00 
  803238:	ff d0                	callq  *%rax
  80323a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80323d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803241:	79 08                	jns    80324b <map_segment+0xf8>
				return r;
  803243:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803246:	e9 ed 00 00 00       	jmpq   803338 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80324b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803255:	48 98                	cltq   
  803257:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80325b:	48 89 d1             	mov    %rdx,%rcx
  80325e:	48 29 c1             	sub    %rax,%rcx
  803261:	48 89 c8             	mov    %rcx,%rax
  803264:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803268:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80326b:	48 63 d0             	movslq %eax,%rdx
  80326e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803272:	48 39 c2             	cmp    %rax,%rdx
  803275:	48 0f 47 d0          	cmova  %rax,%rdx
  803279:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80327c:	be 00 00 40 00       	mov    $0x400000,%esi
  803281:	89 c7                	mov    %eax,%edi
  803283:	48 b8 11 22 80 00 00 	movabs $0x802211,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
  80328f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803292:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803296:	79 08                	jns    8032a0 <map_segment+0x14d>
				return r;
  803298:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80329b:	e9 98 00 00 00       	jmpq   803338 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8032a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a3:	48 98                	cltq   
  8032a5:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8032a9:	48 89 c2             	mov    %rax,%rdx
  8032ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032af:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8032b3:	48 89 d1             	mov    %rdx,%rcx
  8032b6:	89 c2                	mov    %eax,%edx
  8032b8:	be 00 00 40 00       	mov    $0x400000,%esi
  8032bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c2:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
  8032ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032d5:	79 30                	jns    803307 <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  8032d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032da:	89 c1                	mov    %eax,%ecx
  8032dc:	48 ba fb 4e 80 00 00 	movabs $0x804efb,%rdx
  8032e3:	00 00 00 
  8032e6:	be 24 01 00 00       	mov    $0x124,%esi
  8032eb:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  8032f2:	00 00 00 
  8032f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fa:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  803301:	00 00 00 
  803304:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803307:	be 00 00 40 00       	mov    $0x400000,%esi
  80330c:	bf 00 00 00 00       	mov    $0x0,%edi
  803311:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803318:	00 00 00 
  80331b:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80331d:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803327:	48 98                	cltq   
  803329:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80332d:	0f 82 7d fe ff ff    	jb     8031b0 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803338:	c9                   	leaveq 
  803339:	c3                   	retq   

000000000080333a <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80333a:	55                   	push   %rbp
  80333b:	48 89 e5             	mov    %rsp,%rbp
  80333e:	48 83 ec 60          	sub    $0x60,%rsp
  803342:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  803345:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  80334c:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803353:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80335a:	00 
  80335b:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  803362:	00 
  803363:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80336a:	00 
  80336b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803372:	00 
  803373:	e9 a6 01 00 00       	jmpq   80351e <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  803378:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80337f:	01 00 00 
  803382:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803386:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80338a:	83 e0 01             	and    $0x1,%eax
  80338d:	84 c0                	test   %al,%al
  80338f:	0f 84 74 01 00 00    	je     803509 <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803395:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80339c:	00 
  80339d:	e9 56 01 00 00       	jmpq   8034f8 <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  8033a2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8033a9:	01 00 00 
  8033ac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033b4:	83 e0 01             	and    $0x1,%eax
  8033b7:	84 c0                	test   %al,%al
  8033b9:	0f 84 1f 01 00 00    	je     8034de <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  8033bf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8033c6:	00 
  8033c7:	e9 02 01 00 00       	jmpq   8034ce <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  8033cc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8033d3:	01 00 00 
  8033d6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8033da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033de:	83 e0 01             	and    $0x1,%eax
  8033e1:	84 c0                	test   %al,%al
  8033e3:	0f 84 cb 00 00 00    	je     8034b4 <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  8033e9:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8033f0:	00 
  8033f1:	e9 ae 00 00 00       	jmpq   8034a4 <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  8033f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033fd:	01 00 00 
  803400:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803404:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803408:	25 00 04 00 00       	and    $0x400,%eax
  80340d:	48 85 c0             	test   %rax,%rax
  803410:	0f 84 84 00 00 00    	je     80349a <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  803416:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80341a:	48 c1 e0 0c          	shl    $0xc,%rax
  80341e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  803422:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803429:	01 00 00 
  80342c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803430:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803434:	25 07 0e 00 00       	and    $0xe07,%eax
  803439:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  80343c:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  80343f:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  803443:	8b 55 ac             	mov    -0x54(%rbp),%edx
  803446:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80344a:	41 89 f0             	mov    %esi,%r8d
  80344d:	48 89 c6             	mov    %rax,%rsi
  803450:	bf 00 00 00 00       	mov    $0x0,%edi
  803455:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  80345c:	00 00 00 
  80345f:	ff d0                	callq  *%rax
  803461:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  803464:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  803468:	79 30                	jns    80349a <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  80346a:	8b 45 b0             	mov    -0x50(%rbp),%eax
  80346d:	89 c1                	mov    %eax,%ecx
  80346f:	48 ba 18 4f 80 00 00 	movabs $0x804f18,%rdx
  803476:	00 00 00 
  803479:	be 48 01 00 00       	mov    $0x148,%esi
  80347e:	48 bf 80 4e 80 00 00 	movabs $0x804e80,%rdi
  803485:	00 00 00 
  803488:	b8 00 00 00 00       	mov    $0x0,%eax
  80348d:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  803494:	00 00 00 
  803497:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  80349a:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80349f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8034a4:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8034ab:	00 
  8034ac:	0f 86 44 ff ff ff    	jbe    8033f6 <copy_shared_pages+0xbc>
  8034b2:	eb 10                	jmp    8034c4 <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  8034b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b8:	48 83 c0 01          	add    $0x1,%rax
  8034bc:	48 c1 e0 09          	shl    $0x9,%rax
  8034c0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  8034c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8034c9:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8034ce:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8034d5:	00 
  8034d6:	0f 86 f0 fe ff ff    	jbe    8033cc <copy_shared_pages+0x92>
  8034dc:	eb 10                	jmp    8034ee <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  8034de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e2:	48 83 c0 01          	add    $0x1,%rax
  8034e6:	48 c1 e0 09          	shl    $0x9,%rax
  8034ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  8034ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  8034f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8034f8:	8b 45 c0             	mov    -0x40(%rbp),%eax
  8034fb:	48 98                	cltq   
  8034fd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803501:	0f 87 9b fe ff ff    	ja     8033a2 <copy_shared_pages+0x68>
  803507:	eb 10                	jmp    803519 <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  803509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350d:	48 83 c0 01          	add    $0x1,%rax
  803511:	48 c1 e0 09          	shl    $0x9,%rax
  803515:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803519:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80351e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803521:	48 98                	cltq   
  803523:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803527:	0f 87 4b fe ff ff    	ja     803378 <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  80352d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803532:	c9                   	leaveq 
  803533:	c3                   	retq   

0000000000803534 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803534:	55                   	push   %rbp
  803535:	48 89 e5             	mov    %rsp,%rbp
  803538:	48 83 ec 20          	sub    $0x20,%rsp
  80353c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80353f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803543:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803546:	48 89 d6             	mov    %rdx,%rsi
  803549:	89 c7                	mov    %eax,%edi
  80354b:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax
  803557:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80355a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355e:	79 05                	jns    803565 <fd2sockid+0x31>
		return r;
  803560:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803563:	eb 24                	jmp    803589 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803569:	8b 10                	mov    (%rax),%edx
  80356b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803572:	00 00 00 
  803575:	8b 00                	mov    (%rax),%eax
  803577:	39 c2                	cmp    %eax,%edx
  803579:	74 07                	je     803582 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80357b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803580:	eb 07                	jmp    803589 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803586:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803589:	c9                   	leaveq 
  80358a:	c3                   	retq   

000000000080358b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80358b:	55                   	push   %rbp
  80358c:	48 89 e5             	mov    %rsp,%rbp
  80358f:	48 83 ec 20          	sub    $0x20,%rsp
  803593:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803596:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80359a:	48 89 c7             	mov    %rax,%rdi
  80359d:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  8035a4:	00 00 00 
  8035a7:	ff d0                	callq  *%rax
  8035a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b0:	78 26                	js     8035d8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8035b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8035bb:	48 89 c6             	mov    %rax,%rsi
  8035be:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c3:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d6:	79 16                	jns    8035ee <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035db:	89 c7                	mov    %eax,%edi
  8035dd:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
		return r;
  8035e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ec:	eb 3a                	jmp    803628 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8035f9:	00 00 00 
  8035fc:	8b 12                	mov    (%rdx),%edx
  8035fe:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803600:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803604:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80360b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803612:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803619:	48 89 c7             	mov    %rax,%rdi
  80361c:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  803623:	00 00 00 
  803626:	ff d0                	callq  *%rax
}
  803628:	c9                   	leaveq 
  803629:	c3                   	retq   

000000000080362a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80362a:	55                   	push   %rbp
  80362b:	48 89 e5             	mov    %rsp,%rbp
  80362e:	48 83 ec 30          	sub    $0x30,%rsp
  803632:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803635:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803639:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80363d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803640:	89 c7                	mov    %eax,%edi
  803642:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  803649:	00 00 00 
  80364c:	ff d0                	callq  *%rax
  80364e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803655:	79 05                	jns    80365c <accept+0x32>
		return r;
  803657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365a:	eb 3b                	jmp    803697 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80365c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803660:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803664:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803667:	48 89 ce             	mov    %rcx,%rsi
  80366a:	89 c7                	mov    %eax,%edi
  80366c:	48 b8 75 39 80 00 00 	movabs $0x803975,%rax
  803673:	00 00 00 
  803676:	ff d0                	callq  *%rax
  803678:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367f:	79 05                	jns    803686 <accept+0x5c>
		return r;
  803681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803684:	eb 11                	jmp    803697 <accept+0x6d>
	return alloc_sockfd(r);
  803686:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803689:	89 c7                	mov    %eax,%edi
  80368b:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  803692:	00 00 00 
  803695:	ff d0                	callq  *%rax
}
  803697:	c9                   	leaveq 
  803698:	c3                   	retq   

0000000000803699 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803699:	55                   	push   %rbp
  80369a:	48 89 e5             	mov    %rsp,%rbp
  80369d:	48 83 ec 20          	sub    $0x20,%rsp
  8036a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036a8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ae:	89 c7                	mov    %eax,%edi
  8036b0:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
  8036bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036c3:	79 05                	jns    8036ca <bind+0x31>
		return r;
  8036c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c8:	eb 1b                	jmp    8036e5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036cd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d4:	48 89 ce             	mov    %rcx,%rsi
  8036d7:	89 c7                	mov    %eax,%edi
  8036d9:	48 b8 f4 39 80 00 00 	movabs $0x8039f4,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
}
  8036e5:	c9                   	leaveq 
  8036e6:	c3                   	retq   

00000000008036e7 <shutdown>:

int
shutdown(int s, int how)
{
  8036e7:	55                   	push   %rbp
  8036e8:	48 89 e5             	mov    %rsp,%rbp
  8036eb:	48 83 ec 20          	sub    $0x20,%rsp
  8036ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036f2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f8:	89 c7                	mov    %eax,%edi
  8036fa:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
  803706:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803709:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370d:	79 05                	jns    803714 <shutdown+0x2d>
		return r;
  80370f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803712:	eb 16                	jmp    80372a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803714:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803717:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371a:	89 d6                	mov    %edx,%esi
  80371c:	89 c7                	mov    %eax,%edi
  80371e:	48 b8 58 3a 80 00 00 	movabs $0x803a58,%rax
  803725:	00 00 00 
  803728:	ff d0                	callq  *%rax
}
  80372a:	c9                   	leaveq 
  80372b:	c3                   	retq   

000000000080372c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80372c:	55                   	push   %rbp
  80372d:	48 89 e5             	mov    %rsp,%rbp
  803730:	48 83 ec 10          	sub    $0x10,%rsp
  803734:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373c:	48 89 c7             	mov    %rax,%rdi
  80373f:	48 b8 c4 47 80 00 00 	movabs $0x8047c4,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
  80374b:	83 f8 01             	cmp    $0x1,%eax
  80374e:	75 17                	jne    803767 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803754:	8b 40 0c             	mov    0xc(%rax),%eax
  803757:	89 c7                	mov    %eax,%edi
  803759:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	eb 05                	jmp    80376c <devsock_close+0x40>
	else
		return 0;
  803767:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80376c:	c9                   	leaveq 
  80376d:	c3                   	retq   

000000000080376e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80376e:	55                   	push   %rbp
  80376f:	48 89 e5             	mov    %rsp,%rbp
  803772:	48 83 ec 20          	sub    $0x20,%rsp
  803776:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803779:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80377d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803780:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803783:	89 c7                	mov    %eax,%edi
  803785:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  80378c:	00 00 00 
  80378f:	ff d0                	callq  *%rax
  803791:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803794:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803798:	79 05                	jns    80379f <connect+0x31>
		return r;
  80379a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379d:	eb 1b                	jmp    8037ba <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80379f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a9:	48 89 ce             	mov    %rcx,%rsi
  8037ac:	89 c7                	mov    %eax,%edi
  8037ae:	48 b8 c5 3a 80 00 00 	movabs $0x803ac5,%rax
  8037b5:	00 00 00 
  8037b8:	ff d0                	callq  *%rax
}
  8037ba:	c9                   	leaveq 
  8037bb:	c3                   	retq   

00000000008037bc <listen>:

int
listen(int s, int backlog)
{
  8037bc:	55                   	push   %rbp
  8037bd:	48 89 e5             	mov    %rsp,%rbp
  8037c0:	48 83 ec 20          	sub    $0x20,%rsp
  8037c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037cd:	89 c7                	mov    %eax,%edi
  8037cf:	48 b8 34 35 80 00 00 	movabs $0x803534,%rax
  8037d6:	00 00 00 
  8037d9:	ff d0                	callq  *%rax
  8037db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e2:	79 05                	jns    8037e9 <listen+0x2d>
		return r;
  8037e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e7:	eb 16                	jmp    8037ff <listen+0x43>
	return nsipc_listen(r, backlog);
  8037e9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ef:	89 d6                	mov    %edx,%esi
  8037f1:	89 c7                	mov    %eax,%edi
  8037f3:	48 b8 29 3b 80 00 00 	movabs $0x803b29,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
}
  8037ff:	c9                   	leaveq 
  803800:	c3                   	retq   

0000000000803801 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803801:	55                   	push   %rbp
  803802:	48 89 e5             	mov    %rsp,%rbp
  803805:	48 83 ec 20          	sub    $0x20,%rsp
  803809:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80380d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803811:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803815:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803819:	89 c2                	mov    %eax,%edx
  80381b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381f:	8b 40 0c             	mov    0xc(%rax),%eax
  803822:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803826:	b9 00 00 00 00       	mov    $0x0,%ecx
  80382b:	89 c7                	mov    %eax,%edi
  80382d:	48 b8 69 3b 80 00 00 	movabs $0x803b69,%rax
  803834:	00 00 00 
  803837:	ff d0                	callq  *%rax
}
  803839:	c9                   	leaveq 
  80383a:	c3                   	retq   

000000000080383b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80383b:	55                   	push   %rbp
  80383c:	48 89 e5             	mov    %rsp,%rbp
  80383f:	48 83 ec 20          	sub    $0x20,%rsp
  803843:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803847:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80384b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80384f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803853:	89 c2                	mov    %eax,%edx
  803855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803859:	8b 40 0c             	mov    0xc(%rax),%eax
  80385c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803860:	b9 00 00 00 00       	mov    $0x0,%ecx
  803865:	89 c7                	mov    %eax,%edi
  803867:	48 b8 35 3c 80 00 00 	movabs $0x803c35,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 10          	sub    $0x10,%rsp
  80387d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803881:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803889:	48 be 34 4f 80 00 00 	movabs $0x804f34,%rsi
  803890:	00 00 00 
  803893:	48 89 c7             	mov    %rax,%rdi
  803896:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80389d:	00 00 00 
  8038a0:	ff d0                	callq  *%rax
	return 0;
  8038a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a7:	c9                   	leaveq 
  8038a8:	c3                   	retq   

00000000008038a9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8038a9:	55                   	push   %rbp
  8038aa:	48 89 e5             	mov    %rsp,%rbp
  8038ad:	48 83 ec 20          	sub    $0x20,%rsp
  8038b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038b7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038ba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038bd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c3:	89 ce                	mov    %ecx,%esi
  8038c5:	89 c7                	mov    %eax,%edi
  8038c7:	48 b8 ed 3c 80 00 00 	movabs $0x803ced,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
  8038d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038da:	79 05                	jns    8038e1 <socket+0x38>
		return r;
  8038dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038df:	eb 11                	jmp    8038f2 <socket+0x49>
	return alloc_sockfd(r);
  8038e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e4:	89 c7                	mov    %eax,%edi
  8038e6:	48 b8 8b 35 80 00 00 	movabs $0x80358b,%rax
  8038ed:	00 00 00 
  8038f0:	ff d0                	callq  *%rax
}
  8038f2:	c9                   	leaveq 
  8038f3:	c3                   	retq   

00000000008038f4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038f4:	55                   	push   %rbp
  8038f5:	48 89 e5             	mov    %rsp,%rbp
  8038f8:	48 83 ec 10          	sub    $0x10,%rsp
  8038fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038ff:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803906:	00 00 00 
  803909:	8b 00                	mov    (%rax),%eax
  80390b:	85 c0                	test   %eax,%eax
  80390d:	75 1d                	jne    80392c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80390f:	bf 02 00 00 00       	mov    $0x2,%edi
  803914:	48 b8 3f 47 80 00 00 	movabs $0x80473f,%rax
  80391b:	00 00 00 
  80391e:	ff d0                	callq  *%rax
  803920:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  803927:	00 00 00 
  80392a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80392c:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803933:	00 00 00 
  803936:	8b 00                	mov    (%rax),%eax
  803938:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80393b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803940:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803947:	00 00 00 
  80394a:	89 c7                	mov    %eax,%edi
  80394c:	48 b8 7c 46 80 00 00 	movabs $0x80467c,%rax
  803953:	00 00 00 
  803956:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803958:	ba 00 00 00 00       	mov    $0x0,%edx
  80395d:	be 00 00 00 00       	mov    $0x0,%esi
  803962:	bf 00 00 00 00       	mov    $0x0,%edi
  803967:	48 b8 bc 45 80 00 00 	movabs $0x8045bc,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax
}
  803973:	c9                   	leaveq 
  803974:	c3                   	retq   

0000000000803975 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803975:	55                   	push   %rbp
  803976:	48 89 e5             	mov    %rsp,%rbp
  803979:	48 83 ec 30          	sub    $0x30,%rsp
  80397d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803980:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803984:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803988:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80398f:	00 00 00 
  803992:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803995:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803997:	bf 01 00 00 00       	mov    $0x1,%edi
  80399c:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  8039a3:	00 00 00 
  8039a6:	ff d0                	callq  *%rax
  8039a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039af:	78 3e                	js     8039ef <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8039b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b8:	00 00 00 
  8039bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c3:	8b 40 10             	mov    0x10(%rax),%eax
  8039c6:	89 c2                	mov    %eax,%edx
  8039c8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d0:	48 89 ce             	mov    %rcx,%rsi
  8039d3:	48 89 c7             	mov    %rax,%rdi
  8039d6:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8039dd:	00 00 00 
  8039e0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e6:	8b 50 10             	mov    0x10(%rax),%edx
  8039e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ed:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039f2:	c9                   	leaveq 
  8039f3:	c3                   	retq   

00000000008039f4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039f4:	55                   	push   %rbp
  8039f5:	48 89 e5             	mov    %rsp,%rbp
  8039f8:	48 83 ec 10          	sub    $0x10,%rsp
  8039fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a03:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a0d:	00 00 00 
  803a10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a13:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a15:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1c:	48 89 c6             	mov    %rax,%rsi
  803a1f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a26:	00 00 00 
  803a29:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3c:	00 00 00 
  803a3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a42:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a45:	bf 02 00 00 00       	mov    $0x2,%edi
  803a4a:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803a51:	00 00 00 
  803a54:	ff d0                	callq  *%rax
}
  803a56:	c9                   	leaveq 
  803a57:	c3                   	retq   

0000000000803a58 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a58:	55                   	push   %rbp
  803a59:	48 89 e5             	mov    %rsp,%rbp
  803a5c:	48 83 ec 10          	sub    $0x10,%rsp
  803a60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a63:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a66:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a6d:	00 00 00 
  803a70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a73:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a7c:	00 00 00 
  803a7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a82:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a85:	bf 03 00 00 00       	mov    $0x3,%edi
  803a8a:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
}
  803a96:	c9                   	leaveq 
  803a97:	c3                   	retq   

0000000000803a98 <nsipc_close>:

int
nsipc_close(int s)
{
  803a98:	55                   	push   %rbp
  803a99:	48 89 e5             	mov    %rsp,%rbp
  803a9c:	48 83 ec 10          	sub    $0x10,%rsp
  803aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803aa3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aaa:	00 00 00 
  803aad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ab0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803ab2:	bf 04 00 00 00       	mov    $0x4,%edi
  803ab7:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803abe:	00 00 00 
  803ac1:	ff d0                	callq  *%rax
}
  803ac3:	c9                   	leaveq 
  803ac4:	c3                   	retq   

0000000000803ac5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ac5:	55                   	push   %rbp
  803ac6:	48 89 e5             	mov    %rsp,%rbp
  803ac9:	48 83 ec 10          	sub    $0x10,%rsp
  803acd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ad4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ad7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ade:	00 00 00 
  803ae1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ae6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ae9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aed:	48 89 c6             	mov    %rax,%rsi
  803af0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803af7:	00 00 00 
  803afa:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803b01:	00 00 00 
  803b04:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b0d:	00 00 00 
  803b10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b13:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b16:	bf 05 00 00 00       	mov    $0x5,%edi
  803b1b:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803b22:	00 00 00 
  803b25:	ff d0                	callq  *%rax
}
  803b27:	c9                   	leaveq 
  803b28:	c3                   	retq   

0000000000803b29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b29:	55                   	push   %rbp
  803b2a:	48 89 e5             	mov    %rsp,%rbp
  803b2d:	48 83 ec 10          	sub    $0x10,%rsp
  803b31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b3e:	00 00 00 
  803b41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b44:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b4d:	00 00 00 
  803b50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b53:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b56:	bf 06 00 00 00       	mov    $0x6,%edi
  803b5b:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
}
  803b67:	c9                   	leaveq 
  803b68:	c3                   	retq   

0000000000803b69 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b69:	55                   	push   %rbp
  803b6a:	48 89 e5             	mov    %rsp,%rbp
  803b6d:	48 83 ec 30          	sub    $0x30,%rsp
  803b71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b78:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b7b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b7e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b85:	00 00 00 
  803b88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b8b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b8d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b94:	00 00 00 
  803b97:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b9a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ba4:	00 00 00 
  803ba7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803baa:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803bad:	bf 07 00 00 00       	mov    $0x7,%edi
  803bb2:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803bb9:	00 00 00 
  803bbc:	ff d0                	callq  *%rax
  803bbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc5:	78 69                	js     803c30 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bc7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bce:	7f 08                	jg     803bd8 <nsipc_recv+0x6f>
  803bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bd6:	7e 35                	jle    803c0d <nsipc_recv+0xa4>
  803bd8:	48 b9 3b 4f 80 00 00 	movabs $0x804f3b,%rcx
  803bdf:	00 00 00 
  803be2:	48 ba 50 4f 80 00 00 	movabs $0x804f50,%rdx
  803be9:	00 00 00 
  803bec:	be 61 00 00 00       	mov    $0x61,%esi
  803bf1:	48 bf 65 4f 80 00 00 	movabs $0x804f65,%rdi
  803bf8:	00 00 00 
  803bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  803c00:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  803c07:	00 00 00 
  803c0a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c10:	48 63 d0             	movslq %eax,%rdx
  803c13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c17:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c1e:	00 00 00 
  803c21:	48 89 c7             	mov    %rax,%rdi
  803c24:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
	}

	return r;
  803c30:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c33:	c9                   	leaveq 
  803c34:	c3                   	retq   

0000000000803c35 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c35:	55                   	push   %rbp
  803c36:	48 89 e5             	mov    %rsp,%rbp
  803c39:	48 83 ec 20          	sub    $0x20,%rsp
  803c3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c44:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c47:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c51:	00 00 00 
  803c54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c57:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c59:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c60:	7e 35                	jle    803c97 <nsipc_send+0x62>
  803c62:	48 b9 71 4f 80 00 00 	movabs $0x804f71,%rcx
  803c69:	00 00 00 
  803c6c:	48 ba 50 4f 80 00 00 	movabs $0x804f50,%rdx
  803c73:	00 00 00 
  803c76:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c7b:	48 bf 65 4f 80 00 00 	movabs $0x804f65,%rdi
  803c82:	00 00 00 
  803c85:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8a:	49 b8 b0 01 80 00 00 	movabs $0x8001b0,%r8
  803c91:	00 00 00 
  803c94:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c9a:	48 63 d0             	movslq %eax,%rdx
  803c9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca1:	48 89 c6             	mov    %rax,%rsi
  803ca4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803cab:	00 00 00 
  803cae:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803cb5:	00 00 00 
  803cb8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803cba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cc1:	00 00 00 
  803cc4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cc7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cd1:	00 00 00 
  803cd4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cda:	bf 08 00 00 00       	mov    $0x8,%edi
  803cdf:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803ce6:	00 00 00 
  803ce9:	ff d0                	callq  *%rax
}
  803ceb:	c9                   	leaveq 
  803cec:	c3                   	retq   

0000000000803ced <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ced:	55                   	push   %rbp
  803cee:	48 89 e5             	mov    %rsp,%rbp
  803cf1:	48 83 ec 10          	sub    $0x10,%rsp
  803cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803cfb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803cfe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d05:	00 00 00 
  803d08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d0b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d14:	00 00 00 
  803d17:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d1a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d1d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d24:	00 00 00 
  803d27:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d2a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d2d:	bf 09 00 00 00       	mov    $0x9,%edi
  803d32:	48 b8 f4 38 80 00 00 	movabs $0x8038f4,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
}
  803d3e:	c9                   	leaveq 
  803d3f:	c3                   	retq   

0000000000803d40 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d40:	55                   	push   %rbp
  803d41:	48 89 e5             	mov    %rsp,%rbp
  803d44:	53                   	push   %rbx
  803d45:	48 83 ec 38          	sub    $0x38,%rsp
  803d49:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d4d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d51:	48 89 c7             	mov    %rax,%rdi
  803d54:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  803d5b:	00 00 00 
  803d5e:	ff d0                	callq  *%rax
  803d60:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d63:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d67:	0f 88 bf 01 00 00    	js     803f2c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d71:	ba 07 04 00 00       	mov    $0x407,%edx
  803d76:	48 89 c6             	mov    %rax,%rsi
  803d79:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7e:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803d85:	00 00 00 
  803d88:	ff d0                	callq  *%rax
  803d8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d91:	0f 88 95 01 00 00    	js     803f2c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d97:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d9b:	48 89 c7             	mov    %rax,%rdi
  803d9e:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803db1:	0f 88 5d 01 00 00    	js     803f14 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803db7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dbb:	ba 07 04 00 00       	mov    $0x407,%edx
  803dc0:	48 89 c6             	mov    %rax,%rsi
  803dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc8:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803dcf:	00 00 00 
  803dd2:	ff d0                	callq  *%rax
  803dd4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ddb:	0f 88 33 01 00 00    	js     803f14 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803de1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de5:	48 89 c7             	mov    %rax,%rdi
  803de8:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  803def:	00 00 00 
  803df2:	ff d0                	callq  *%rax
  803df4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803df8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dfc:	ba 07 04 00 00       	mov    $0x407,%edx
  803e01:	48 89 c6             	mov    %rax,%rsi
  803e04:	bf 00 00 00 00       	mov    $0x0,%edi
  803e09:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	callq  *%rax
  803e15:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e18:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e1c:	0f 88 d9 00 00 00    	js     803efb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e22:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e26:	48 89 c7             	mov    %rax,%rdi
  803e29:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
  803e35:	48 89 c2             	mov    %rax,%rdx
  803e38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e3c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e42:	48 89 d1             	mov    %rdx,%rcx
  803e45:	ba 00 00 00 00       	mov    $0x0,%edx
  803e4a:	48 89 c6             	mov    %rax,%rsi
  803e4d:	bf 00 00 00 00       	mov    $0x0,%edi
  803e52:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803e59:	00 00 00 
  803e5c:	ff d0                	callq  *%rax
  803e5e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e61:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e65:	78 79                	js     803ee0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e6b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e72:	00 00 00 
  803e75:	8b 12                	mov    (%rdx),%edx
  803e77:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e88:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e8f:	00 00 00 
  803e92:	8b 12                	mov    (%rdx),%edx
  803e94:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e9a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ea1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea5:	48 89 c7             	mov    %rax,%rdi
  803ea8:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  803eaf:	00 00 00 
  803eb2:	ff d0                	callq  *%rax
  803eb4:	89 c2                	mov    %eax,%edx
  803eb6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803eba:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803ebc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ec0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ec4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec8:	48 89 c7             	mov    %rax,%rdi
  803ecb:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  803ed2:	00 00 00 
  803ed5:	ff d0                	callq  *%rax
  803ed7:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  803ede:	eb 4f                	jmp    803f2f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ee0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803ee1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee5:	48 89 c6             	mov    %rax,%rsi
  803ee8:	bf 00 00 00 00       	mov    $0x0,%edi
  803eed:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803ef4:	00 00 00 
  803ef7:	ff d0                	callq  *%rax
  803ef9:	eb 01                	jmp    803efc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803efb:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803efc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f00:	48 89 c6             	mov    %rax,%rsi
  803f03:	bf 00 00 00 00       	mov    $0x0,%edi
  803f08:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803f0f:	00 00 00 
  803f12:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f18:	48 89 c6             	mov    %rax,%rsi
  803f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f20:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803f27:	00 00 00 
  803f2a:	ff d0                	callq  *%rax
    err:
	return r;
  803f2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f2f:	48 83 c4 38          	add    $0x38,%rsp
  803f33:	5b                   	pop    %rbx
  803f34:	5d                   	pop    %rbp
  803f35:	c3                   	retq   

0000000000803f36 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f36:	55                   	push   %rbp
  803f37:	48 89 e5             	mov    %rsp,%rbp
  803f3a:	53                   	push   %rbx
  803f3b:	48 83 ec 28          	sub    $0x28,%rsp
  803f3f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f43:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f47:	eb 01                	jmp    803f4a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803f49:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f4a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f51:	00 00 00 
  803f54:	48 8b 00             	mov    (%rax),%rax
  803f57:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f5d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f64:	48 89 c7             	mov    %rax,%rdi
  803f67:	48 b8 c4 47 80 00 00 	movabs $0x8047c4,%rax
  803f6e:	00 00 00 
  803f71:	ff d0                	callq  *%rax
  803f73:	89 c3                	mov    %eax,%ebx
  803f75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f79:	48 89 c7             	mov    %rax,%rdi
  803f7c:	48 b8 c4 47 80 00 00 	movabs $0x8047c4,%rax
  803f83:	00 00 00 
  803f86:	ff d0                	callq  *%rax
  803f88:	39 c3                	cmp    %eax,%ebx
  803f8a:	0f 94 c0             	sete   %al
  803f8d:	0f b6 c0             	movzbl %al,%eax
  803f90:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f93:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f9a:	00 00 00 
  803f9d:	48 8b 00             	mov    (%rax),%rax
  803fa0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fa6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803fa9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803faf:	75 0a                	jne    803fbb <_pipeisclosed+0x85>
			return ret;
  803fb1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803fb4:	48 83 c4 28          	add    $0x28,%rsp
  803fb8:	5b                   	pop    %rbx
  803fb9:	5d                   	pop    %rbp
  803fba:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803fbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fbe:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fc1:	74 86                	je     803f49 <_pipeisclosed+0x13>
  803fc3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fc7:	75 80                	jne    803f49 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fc9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803fd0:	00 00 00 
  803fd3:	48 8b 00             	mov    (%rax),%rax
  803fd6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fdc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe2:	89 c6                	mov    %eax,%esi
  803fe4:	48 bf 82 4f 80 00 00 	movabs $0x804f82,%rdi
  803feb:	00 00 00 
  803fee:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff3:	49 b8 eb 03 80 00 00 	movabs $0x8003eb,%r8
  803ffa:	00 00 00 
  803ffd:	41 ff d0             	callq  *%r8
	}
  804000:	e9 44 ff ff ff       	jmpq   803f49 <_pipeisclosed+0x13>

0000000000804005 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804005:	55                   	push   %rbp
  804006:	48 89 e5             	mov    %rsp,%rbp
  804009:	48 83 ec 30          	sub    $0x30,%rsp
  80400d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804010:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804014:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804017:	48 89 d6             	mov    %rdx,%rsi
  80401a:	89 c7                	mov    %eax,%edi
  80401c:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  804023:	00 00 00 
  804026:	ff d0                	callq  *%rax
  804028:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80402b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402f:	79 05                	jns    804036 <pipeisclosed+0x31>
		return r;
  804031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804034:	eb 31                	jmp    804067 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804036:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80403a:	48 89 c7             	mov    %rax,%rdi
  80403d:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  804044:	00 00 00 
  804047:	ff d0                	callq  *%rax
  804049:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80404d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804051:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804055:	48 89 d6             	mov    %rdx,%rsi
  804058:	48 89 c7             	mov    %rax,%rdi
  80405b:	48 b8 36 3f 80 00 00 	movabs $0x803f36,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
}
  804067:	c9                   	leaveq 
  804068:	c3                   	retq   

0000000000804069 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804069:	55                   	push   %rbp
  80406a:	48 89 e5             	mov    %rsp,%rbp
  80406d:	48 83 ec 40          	sub    $0x40,%rsp
  804071:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804075:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804079:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80407d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804081:	48 89 c7             	mov    %rax,%rdi
  804084:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  80408b:	00 00 00 
  80408e:	ff d0                	callq  *%rax
  804090:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804094:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804098:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80409c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040a3:	00 
  8040a4:	e9 97 00 00 00       	jmpq   804140 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040ae:	74 09                	je     8040b9 <devpipe_read+0x50>
				return i;
  8040b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b4:	e9 95 00 00 00       	jmpq   80414e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040c1:	48 89 d6             	mov    %rdx,%rsi
  8040c4:	48 89 c7             	mov    %rax,%rdi
  8040c7:	48 b8 36 3f 80 00 00 	movabs $0x803f36,%rax
  8040ce:	00 00 00 
  8040d1:	ff d0                	callq  *%rax
  8040d3:	85 c0                	test   %eax,%eax
  8040d5:	74 07                	je     8040de <devpipe_read+0x75>
				return 0;
  8040d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8040dc:	eb 70                	jmp    80414e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040de:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  8040e5:	00 00 00 
  8040e8:	ff d0                	callq  *%rax
  8040ea:	eb 01                	jmp    8040ed <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040ec:	90                   	nop
  8040ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f1:	8b 10                	mov    (%rax),%edx
  8040f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f7:	8b 40 04             	mov    0x4(%rax),%eax
  8040fa:	39 c2                	cmp    %eax,%edx
  8040fc:	74 ab                	je     8040a9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804102:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804106:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80410a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410e:	8b 00                	mov    (%rax),%eax
  804110:	89 c2                	mov    %eax,%edx
  804112:	c1 fa 1f             	sar    $0x1f,%edx
  804115:	c1 ea 1b             	shr    $0x1b,%edx
  804118:	01 d0                	add    %edx,%eax
  80411a:	83 e0 1f             	and    $0x1f,%eax
  80411d:	29 d0                	sub    %edx,%eax
  80411f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804123:	48 98                	cltq   
  804125:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80412a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80412c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804130:	8b 00                	mov    (%rax),%eax
  804132:	8d 50 01             	lea    0x1(%rax),%edx
  804135:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804139:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80413b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804144:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804148:	72 a2                	jb     8040ec <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80414a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80414e:	c9                   	leaveq 
  80414f:	c3                   	retq   

0000000000804150 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804150:	55                   	push   %rbp
  804151:	48 89 e5             	mov    %rsp,%rbp
  804154:	48 83 ec 40          	sub    $0x40,%rsp
  804158:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80415c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804160:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804164:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804168:	48 89 c7             	mov    %rax,%rdi
  80416b:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  804172:	00 00 00 
  804175:	ff d0                	callq  *%rax
  804177:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80417b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80417f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804183:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80418a:	00 
  80418b:	e9 93 00 00 00       	jmpq   804223 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804190:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804198:	48 89 d6             	mov    %rdx,%rsi
  80419b:	48 89 c7             	mov    %rax,%rdi
  80419e:	48 b8 36 3f 80 00 00 	movabs $0x803f36,%rax
  8041a5:	00 00 00 
  8041a8:	ff d0                	callq  *%rax
  8041aa:	85 c0                	test   %eax,%eax
  8041ac:	74 07                	je     8041b5 <devpipe_write+0x65>
				return 0;
  8041ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b3:	eb 7c                	jmp    804231 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041b5:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  8041bc:	00 00 00 
  8041bf:	ff d0                	callq  *%rax
  8041c1:	eb 01                	jmp    8041c4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041c3:	90                   	nop
  8041c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c8:	8b 40 04             	mov    0x4(%rax),%eax
  8041cb:	48 63 d0             	movslq %eax,%rdx
  8041ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d2:	8b 00                	mov    (%rax),%eax
  8041d4:	48 98                	cltq   
  8041d6:	48 83 c0 20          	add    $0x20,%rax
  8041da:	48 39 c2             	cmp    %rax,%rdx
  8041dd:	73 b1                	jae    804190 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e3:	8b 40 04             	mov    0x4(%rax),%eax
  8041e6:	89 c2                	mov    %eax,%edx
  8041e8:	c1 fa 1f             	sar    $0x1f,%edx
  8041eb:	c1 ea 1b             	shr    $0x1b,%edx
  8041ee:	01 d0                	add    %edx,%eax
  8041f0:	83 e0 1f             	and    $0x1f,%eax
  8041f3:	29 d0                	sub    %edx,%eax
  8041f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041fd:	48 01 ca             	add    %rcx,%rdx
  804200:	0f b6 0a             	movzbl (%rdx),%ecx
  804203:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804207:	48 98                	cltq   
  804209:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80420d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804211:	8b 40 04             	mov    0x4(%rax),%eax
  804214:	8d 50 01             	lea    0x1(%rax),%edx
  804217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80421b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80421e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804227:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80422b:	72 96                	jb     8041c3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80422d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804231:	c9                   	leaveq 
  804232:	c3                   	retq   

0000000000804233 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804233:	55                   	push   %rbp
  804234:	48 89 e5             	mov    %rsp,%rbp
  804237:	48 83 ec 20          	sub    $0x20,%rsp
  80423b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80423f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804247:	48 89 c7             	mov    %rax,%rdi
  80424a:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  804251:	00 00 00 
  804254:	ff d0                	callq  *%rax
  804256:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80425a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425e:	48 be 95 4f 80 00 00 	movabs $0x804f95,%rsi
  804265:	00 00 00 
  804268:	48 89 c7             	mov    %rax,%rdi
  80426b:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  804272:	00 00 00 
  804275:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427b:	8b 50 04             	mov    0x4(%rax),%edx
  80427e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804282:	8b 00                	mov    (%rax),%eax
  804284:	29 c2                	sub    %eax,%edx
  804286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80428a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804290:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804294:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80429b:	00 00 00 
	stat->st_dev = &devpipe;
  80429e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042a2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8042a9:	00 00 00 
  8042ac:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8042b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042b8:	c9                   	leaveq 
  8042b9:	c3                   	retq   

00000000008042ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042ba:	55                   	push   %rbp
  8042bb:	48 89 e5             	mov    %rsp,%rbp
  8042be:	48 83 ec 10          	sub    $0x10,%rsp
  8042c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ca:	48 89 c6             	mov    %rax,%rsi
  8042cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8042d2:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  8042d9:	00 00 00 
  8042dc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e2:	48 89 c7             	mov    %rax,%rdi
  8042e5:	48 b8 43 1c 80 00 00 	movabs $0x801c43,%rax
  8042ec:	00 00 00 
  8042ef:	ff d0                	callq  *%rax
  8042f1:	48 89 c6             	mov    %rax,%rsi
  8042f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f9:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  804300:	00 00 00 
  804303:	ff d0                	callq  *%rax
}
  804305:	c9                   	leaveq 
  804306:	c3                   	retq   
	...

0000000000804308 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804308:	55                   	push   %rbp
  804309:	48 89 e5             	mov    %rsp,%rbp
  80430c:	48 83 ec 20          	sub    $0x20,%rsp
  804310:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804313:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804316:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804319:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80431d:	be 01 00 00 00       	mov    $0x1,%esi
  804322:	48 89 c7             	mov    %rax,%rdi
  804325:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  80432c:	00 00 00 
  80432f:	ff d0                	callq  *%rax
}
  804331:	c9                   	leaveq 
  804332:	c3                   	retq   

0000000000804333 <getchar>:

int
getchar(void)
{
  804333:	55                   	push   %rbp
  804334:	48 89 e5             	mov    %rsp,%rbp
  804337:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80433b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80433f:	ba 01 00 00 00       	mov    $0x1,%edx
  804344:	48 89 c6             	mov    %rax,%rsi
  804347:	bf 00 00 00 00       	mov    $0x0,%edi
  80434c:	48 b8 38 21 80 00 00 	movabs $0x802138,%rax
  804353:	00 00 00 
  804356:	ff d0                	callq  *%rax
  804358:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80435b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80435f:	79 05                	jns    804366 <getchar+0x33>
		return r;
  804361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804364:	eb 14                	jmp    80437a <getchar+0x47>
	if (r < 1)
  804366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80436a:	7f 07                	jg     804373 <getchar+0x40>
		return -E_EOF;
  80436c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804371:	eb 07                	jmp    80437a <getchar+0x47>
	return c;
  804373:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804377:	0f b6 c0             	movzbl %al,%eax
}
  80437a:	c9                   	leaveq 
  80437b:	c3                   	retq   

000000000080437c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80437c:	55                   	push   %rbp
  80437d:	48 89 e5             	mov    %rsp,%rbp
  804380:	48 83 ec 20          	sub    $0x20,%rsp
  804384:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804387:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80438b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80438e:	48 89 d6             	mov    %rdx,%rsi
  804391:	89 c7                	mov    %eax,%edi
  804393:	48 b8 06 1d 80 00 00 	movabs $0x801d06,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
  80439f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a6:	79 05                	jns    8043ad <iscons+0x31>
		return r;
  8043a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ab:	eb 1a                	jmp    8043c7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8043ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b1:	8b 10                	mov    (%rax),%edx
  8043b3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8043ba:	00 00 00 
  8043bd:	8b 00                	mov    (%rax),%eax
  8043bf:	39 c2                	cmp    %eax,%edx
  8043c1:	0f 94 c0             	sete   %al
  8043c4:	0f b6 c0             	movzbl %al,%eax
}
  8043c7:	c9                   	leaveq 
  8043c8:	c3                   	retq   

00000000008043c9 <opencons>:

int
opencons(void)
{
  8043c9:	55                   	push   %rbp
  8043ca:	48 89 e5             	mov    %rsp,%rbp
  8043cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043d1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043d5:	48 89 c7             	mov    %rax,%rdi
  8043d8:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  8043df:	00 00 00 
  8043e2:	ff d0                	callq  *%rax
  8043e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043eb:	79 05                	jns    8043f2 <opencons+0x29>
		return r;
  8043ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043f0:	eb 5b                	jmp    80444d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8043fb:	48 89 c6             	mov    %rax,%rsi
  8043fe:	bf 00 00 00 00       	mov    $0x0,%edi
  804403:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  80440a:	00 00 00 
  80440d:	ff d0                	callq  *%rax
  80440f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804412:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804416:	79 05                	jns    80441d <opencons+0x54>
		return r;
  804418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441b:	eb 30                	jmp    80444d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80441d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804421:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804428:	00 00 00 
  80442b:	8b 12                	mov    (%rdx),%edx
  80442d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80442f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804433:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80443a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443e:	48 89 c7             	mov    %rax,%rdi
  804441:	48 b8 20 1c 80 00 00 	movabs $0x801c20,%rax
  804448:	00 00 00 
  80444b:	ff d0                	callq  *%rax
}
  80444d:	c9                   	leaveq 
  80444e:	c3                   	retq   

000000000080444f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80444f:	55                   	push   %rbp
  804450:	48 89 e5             	mov    %rsp,%rbp
  804453:	48 83 ec 30          	sub    $0x30,%rsp
  804457:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80445b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80445f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804463:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804468:	75 13                	jne    80447d <devcons_read+0x2e>
		return 0;
  80446a:	b8 00 00 00 00       	mov    $0x0,%eax
  80446f:	eb 49                	jmp    8044ba <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804471:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  804478:	00 00 00 
  80447b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80447d:	48 b8 e2 17 80 00 00 	movabs $0x8017e2,%rax
  804484:	00 00 00 
  804487:	ff d0                	callq  *%rax
  804489:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80448c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804490:	74 df                	je     804471 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804496:	79 05                	jns    80449d <devcons_read+0x4e>
		return c;
  804498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449b:	eb 1d                	jmp    8044ba <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80449d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8044a1:	75 07                	jne    8044aa <devcons_read+0x5b>
		return 0;
  8044a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a8:	eb 10                	jmp    8044ba <devcons_read+0x6b>
	*(char*)vbuf = c;
  8044aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ad:	89 c2                	mov    %eax,%edx
  8044af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044b3:	88 10                	mov    %dl,(%rax)
	return 1;
  8044b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8044ba:	c9                   	leaveq 
  8044bb:	c3                   	retq   

00000000008044bc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044bc:	55                   	push   %rbp
  8044bd:	48 89 e5             	mov    %rsp,%rbp
  8044c0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8044c7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044ce:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044d5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044e3:	eb 77                	jmp    80455c <devcons_write+0xa0>
		m = n - tot;
  8044e5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044ec:	89 c2                	mov    %eax,%edx
  8044ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f1:	89 d1                	mov    %edx,%ecx
  8044f3:	29 c1                	sub    %eax,%ecx
  8044f5:	89 c8                	mov    %ecx,%eax
  8044f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8044fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044fd:	83 f8 7f             	cmp    $0x7f,%eax
  804500:	76 07                	jbe    804509 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804502:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804509:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80450c:	48 63 d0             	movslq %eax,%rdx
  80450f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804512:	48 98                	cltq   
  804514:	48 89 c1             	mov    %rax,%rcx
  804517:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80451e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804525:	48 89 ce             	mov    %rcx,%rsi
  804528:	48 89 c7             	mov    %rax,%rdi
  80452b:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  804532:	00 00 00 
  804535:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804537:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80453a:	48 63 d0             	movslq %eax,%rdx
  80453d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804544:	48 89 d6             	mov    %rdx,%rsi
  804547:	48 89 c7             	mov    %rax,%rdi
  80454a:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  804551:	00 00 00 
  804554:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804559:	01 45 fc             	add    %eax,-0x4(%rbp)
  80455c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455f:	48 98                	cltq   
  804561:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804568:	0f 82 77 ff ff ff    	jb     8044e5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80456e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804571:	c9                   	leaveq 
  804572:	c3                   	retq   

0000000000804573 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804573:	55                   	push   %rbp
  804574:	48 89 e5             	mov    %rsp,%rbp
  804577:	48 83 ec 08          	sub    $0x8,%rsp
  80457b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80457f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804584:	c9                   	leaveq 
  804585:	c3                   	retq   

0000000000804586 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804586:	55                   	push   %rbp
  804587:	48 89 e5             	mov    %rsp,%rbp
  80458a:	48 83 ec 10          	sub    $0x10,%rsp
  80458e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804592:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804596:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80459a:	48 be a1 4f 80 00 00 	movabs $0x804fa1,%rsi
  8045a1:	00 00 00 
  8045a4:	48 89 c7             	mov    %rax,%rdi
  8045a7:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  8045ae:	00 00 00 
  8045b1:	ff d0                	callq  *%rax
	return 0;
  8045b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045b8:	c9                   	leaveq 
  8045b9:	c3                   	retq   
	...

00000000008045bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8045bc:	55                   	push   %rbp
  8045bd:	48 89 e5             	mov    %rsp,%rbp
  8045c0:	48 83 ec 30          	sub    $0x30,%rsp
  8045c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8045d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045d5:	74 18                	je     8045ef <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8045d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045db:	48 89 c7             	mov    %rax,%rdi
  8045de:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  8045e5:	00 00 00 
  8045e8:	ff d0                	callq  *%rax
  8045ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ed:	eb 19                	jmp    804608 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8045ef:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8045f6:	00 00 00 
  8045f9:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  804600:	00 00 00 
  804603:	ff d0                	callq  *%rax
  804605:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804608:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80460c:	79 19                	jns    804627 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80460e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804612:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  804622:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804625:	eb 53                	jmp    80467a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  804627:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80462c:	74 19                	je     804647 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  80462e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804635:	00 00 00 
  804638:	48 8b 00             	mov    (%rax),%rax
  80463b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804645:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  804647:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80464c:	74 19                	je     804667 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80464e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804655:	00 00 00 
  804658:	48 8b 00             	mov    (%rax),%rax
  80465b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804665:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804667:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80466e:	00 00 00 
  804671:	48 8b 00             	mov    (%rax),%rax
  804674:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80467a:	c9                   	leaveq 
  80467b:	c3                   	retq   

000000000080467c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80467c:	55                   	push   %rbp
  80467d:	48 89 e5             	mov    %rsp,%rbp
  804680:	48 83 ec 30          	sub    $0x30,%rsp
  804684:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804687:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80468a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80468e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804691:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804698:	e9 96 00 00 00       	jmpq   804733 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  80469d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046a2:	74 20                	je     8046c4 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8046a4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8046a7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8046aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8046ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046b1:	89 c7                	mov    %eax,%edi
  8046b3:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  8046ba:	00 00 00 
  8046bd:	ff d0                	callq  *%rax
  8046bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046c2:	eb 2d                	jmp    8046f1 <ipc_send+0x75>
		else if(pg==NULL)
  8046c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8046c9:	75 26                	jne    8046f1 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8046cb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8046ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8046d6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8046dd:	00 00 00 
  8046e0:	89 c7                	mov    %eax,%edi
  8046e2:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  8046e9:	00 00 00 
  8046ec:	ff d0                	callq  *%rax
  8046ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8046f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046f5:	79 30                	jns    804727 <ipc_send+0xab>
  8046f7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8046fb:	74 2a                	je     804727 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8046fd:	48 ba a8 4f 80 00 00 	movabs $0x804fa8,%rdx
  804704:	00 00 00 
  804707:	be 40 00 00 00       	mov    $0x40,%esi
  80470c:	48 bf c0 4f 80 00 00 	movabs $0x804fc0,%rdi
  804713:	00 00 00 
  804716:	b8 00 00 00 00       	mov    $0x0,%eax
  80471b:	48 b9 b0 01 80 00 00 	movabs $0x8001b0,%rcx
  804722:	00 00 00 
  804725:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804727:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  80472e:	00 00 00 
  804731:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804733:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804737:	0f 85 60 ff ff ff    	jne    80469d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80473d:	c9                   	leaveq 
  80473e:	c3                   	retq   

000000000080473f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80473f:	55                   	push   %rbp
  804740:	48 89 e5             	mov    %rsp,%rbp
  804743:	48 83 ec 18          	sub    $0x18,%rsp
  804747:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80474a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804751:	eb 5e                	jmp    8047b1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804753:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80475a:	00 00 00 
  80475d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804760:	48 63 d0             	movslq %eax,%rdx
  804763:	48 89 d0             	mov    %rdx,%rax
  804766:	48 c1 e0 03          	shl    $0x3,%rax
  80476a:	48 01 d0             	add    %rdx,%rax
  80476d:	48 c1 e0 05          	shl    $0x5,%rax
  804771:	48 01 c8             	add    %rcx,%rax
  804774:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80477a:	8b 00                	mov    (%rax),%eax
  80477c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80477f:	75 2c                	jne    8047ad <ipc_find_env+0x6e>
			return envs[i].env_id;
  804781:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804788:	00 00 00 
  80478b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80478e:	48 63 d0             	movslq %eax,%rdx
  804791:	48 89 d0             	mov    %rdx,%rax
  804794:	48 c1 e0 03          	shl    $0x3,%rax
  804798:	48 01 d0             	add    %rdx,%rax
  80479b:	48 c1 e0 05          	shl    $0x5,%rax
  80479f:	48 01 c8             	add    %rcx,%rax
  8047a2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8047a8:	8b 40 08             	mov    0x8(%rax),%eax
  8047ab:	eb 12                	jmp    8047bf <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8047ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8047b1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8047b8:	7e 99                	jle    804753 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8047ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047bf:	c9                   	leaveq 
  8047c0:	c3                   	retq   
  8047c1:	00 00                	add    %al,(%rax)
	...

00000000008047c4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8047c4:	55                   	push   %rbp
  8047c5:	48 89 e5             	mov    %rsp,%rbp
  8047c8:	48 83 ec 18          	sub    $0x18,%rsp
  8047cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8047d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d4:	48 89 c2             	mov    %rax,%rdx
  8047d7:	48 c1 ea 15          	shr    $0x15,%rdx
  8047db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8047e2:	01 00 00 
  8047e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8047e9:	83 e0 01             	and    $0x1,%eax
  8047ec:	48 85 c0             	test   %rax,%rax
  8047ef:	75 07                	jne    8047f8 <pageref+0x34>
		return 0;
  8047f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8047f6:	eb 53                	jmp    80484b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8047f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047fc:	48 89 c2             	mov    %rax,%rdx
  8047ff:	48 c1 ea 0c          	shr    $0xc,%rdx
  804803:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80480a:	01 00 00 
  80480d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804811:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804815:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804819:	83 e0 01             	and    $0x1,%eax
  80481c:	48 85 c0             	test   %rax,%rax
  80481f:	75 07                	jne    804828 <pageref+0x64>
		return 0;
  804821:	b8 00 00 00 00       	mov    $0x0,%eax
  804826:	eb 23                	jmp    80484b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80482c:	48 89 c2             	mov    %rax,%rdx
  80482f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804833:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80483a:	00 00 00 
  80483d:	48 c1 e2 04          	shl    $0x4,%rdx
  804841:	48 01 d0             	add    %rdx,%rax
  804844:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804848:	0f b7 c0             	movzwl %ax,%eax
}
  80484b:	c9                   	leaveq 
  80484c:	c3                   	retq   
