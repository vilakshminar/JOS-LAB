
obj/user/yield.debug:     file format elf64-x86-64


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
  80003c:	e8 c7 00 00 00       	callq  800108 <libmain>
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
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800053:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80005a:	00 00 00 
  80005d:	48 8b 00             	mov    (%rax),%rax
  800060:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800066:	89 c6                	mov    %eax,%esi
  800068:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  80006f:	00 00 00 
  800072:	b8 00 00 00 00       	mov    $0x0,%eax
  800077:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  80007e:	00 00 00 
  800081:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800083:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80008a:	eb 43                	jmp    8000cf <umain+0x8b>
		sys_yield();
  80008c:	48 b8 ae 17 80 00 00 	movabs $0x8017ae,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800098:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80009f:	00 00 00 
  8000a2:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000ab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ae:	89 c6                	mov    %eax,%esi
  8000b0:	48 bf a0 3c 80 00 00 	movabs $0x803ca0,%rdi
  8000b7:	00 00 00 
  8000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bf:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  8000c6:	00 00 00 
  8000c9:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000cf:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d3:	7e b7                	jle    80008c <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d5:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000dc:	00 00 00 
  8000df:	48 8b 00             	mov    (%rax),%rax
  8000e2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e8:	89 c6                	mov    %eax,%esi
  8000ea:	48 bf d0 3c 80 00 00 	movabs $0x803cd0,%rdi
  8000f1:	00 00 00 
  8000f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f9:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  800100:	00 00 00 
  800103:	ff d2                	callq  *%rdx
}
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   
	...

0000000000800108 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %rbp
  800109:	48 89 e5             	mov    %rsp,%rbp
  80010c:	48 83 ec 10          	sub    $0x10,%rsp
  800110:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800113:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800117:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80011e:	00 00 00 
  800121:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800128:	48 b8 70 17 80 00 00 	movabs $0x801770,%rax
  80012f:	00 00 00 
  800132:	ff d0                	callq  *%rax
  800134:	48 98                	cltq   
  800136:	48 89 c2             	mov    %rax,%rdx
  800139:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80013f:	48 89 d0             	mov    %rdx,%rax
  800142:	48 c1 e0 03          	shl    $0x3,%rax
  800146:	48 01 d0             	add    %rdx,%rax
  800149:	48 c1 e0 05          	shl    $0x5,%rax
  80014d:	48 89 c2             	mov    %rax,%rdx
  800150:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800157:	00 00 00 
  80015a:	48 01 c2             	add    %rax,%rdx
  80015d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800164:	00 00 00 
  800167:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80016e:	7e 14                	jle    800184 <libmain+0x7c>
		binaryname = argv[0];
  800170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800174:	48 8b 10             	mov    (%rax),%rdx
  800177:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80017e:	00 00 00 
  800181:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800184:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018b:	48 89 d6             	mov    %rdx,%rsi
  80018e:	89 c7                	mov    %eax,%edi
  800190:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800197:	00 00 00 
  80019a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80019c:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  8001a3:	00 00 00 
  8001a6:	ff d0                	callq  *%rax
}
  8001a8:	c9                   	leaveq 
  8001a9:	c3                   	retq   
	...

00000000008001ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001b0:	48 b8 6d 1e 80 00 00 	movabs $0x801e6d,%rax
  8001b7:	00 00 00 
  8001ba:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c1:	48 b8 2c 17 80 00 00 	movabs $0x80172c,%rax
  8001c8:	00 00 00 
  8001cb:	ff d0                	callq  *%rax
}
  8001cd:	5d                   	pop    %rbp
  8001ce:	c3                   	retq   
	...

00000000008001d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d0:	55                   	push   %rbp
  8001d1:	48 89 e5             	mov    %rsp,%rbp
  8001d4:	48 83 ec 10          	sub    $0x10,%rsp
  8001d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e3:	8b 00                	mov    (%rax),%eax
  8001e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001e8:	89 d6                	mov    %edx,%esi
  8001ea:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8001ee:	48 63 d0             	movslq %eax,%rdx
  8001f1:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8001f6:	8d 50 01             	lea    0x1(%rax),%edx
  8001f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fd:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8001ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800203:	8b 00                	mov    (%rax),%eax
  800205:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020a:	75 2c                	jne    800238 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80020c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800210:	8b 00                	mov    (%rax),%eax
  800212:	48 98                	cltq   
  800214:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800218:	48 83 c2 08          	add    $0x8,%rdx
  80021c:	48 89 c6             	mov    %rax,%rsi
  80021f:	48 89 d7             	mov    %rdx,%rdi
  800222:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
		b->idx = 0;
  80022e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800232:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023c:	8b 40 04             	mov    0x4(%rax),%eax
  80023f:	8d 50 01             	lea    0x1(%rax),%edx
  800242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800246:	89 50 04             	mov    %edx,0x4(%rax)
}
  800249:	c9                   	leaveq 
  80024a:	c3                   	retq   

000000000080024b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024b:	55                   	push   %rbp
  80024c:	48 89 e5             	mov    %rsp,%rbp
  80024f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800256:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80025d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800264:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80026b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800272:	48 8b 0a             	mov    (%rdx),%rcx
  800275:	48 89 08             	mov    %rcx,(%rax)
  800278:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80027c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800280:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800284:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800288:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80028f:	00 00 00 
	b.cnt = 0;
  800292:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800299:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80029c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002a3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002aa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002b1:	48 89 c6             	mov    %rax,%rsi
  8002b4:	48 bf d0 01 80 00 00 	movabs $0x8001d0,%rdi
  8002bb:	00 00 00 
  8002be:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  8002c5:	00 00 00 
  8002c8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002ca:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002d0:	48 98                	cltq   
  8002d2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d9:	48 83 c2 08          	add    $0x8,%rdx
  8002dd:	48 89 c6             	mov    %rax,%rsi
  8002e0:	48 89 d7             	mov    %rdx,%rdi
  8002e3:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  8002ea:	00 00 00 
  8002ed:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002f5:	c9                   	leaveq 
  8002f6:	c3                   	retq   

00000000008002f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f7:	55                   	push   %rbp
  8002f8:	48 89 e5             	mov    %rsp,%rbp
  8002fb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800302:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800309:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800310:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800317:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80031e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800325:	84 c0                	test   %al,%al
  800327:	74 20                	je     800349 <cprintf+0x52>
  800329:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80032d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800331:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800335:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800339:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80033d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800341:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800345:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800349:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800350:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800357:	00 00 00 
  80035a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800361:	00 00 00 
  800364:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800368:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80036f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800376:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80037d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800384:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80038b:	48 8b 0a             	mov    (%rdx),%rcx
  80038e:	48 89 08             	mov    %rcx,(%rax)
  800391:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800395:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800399:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80039d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003a1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003af:	48 89 d6             	mov    %rdx,%rsi
  8003b2:	48 89 c7             	mov    %rax,%rdi
  8003b5:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  8003bc:	00 00 00 
  8003bf:	ff d0                	callq  *%rax
  8003c1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003c7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003cd:	c9                   	leaveq 
  8003ce:	c3                   	retq   
	...

00000000008003d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d0:	55                   	push   %rbp
  8003d1:	48 89 e5             	mov    %rsp,%rbp
  8003d4:	48 83 ec 30          	sub    $0x30,%rsp
  8003d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003e4:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003e7:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8003eb:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003f2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003f6:	77 52                	ja     80044a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f8:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003fb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003ff:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800402:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80040a:	ba 00 00 00 00       	mov    $0x0,%edx
  80040f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800413:	48 89 c2             	mov    %rax,%rdx
  800416:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800419:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80041c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800424:	41 89 f9             	mov    %edi,%r9d
  800427:	48 89 c7             	mov    %rax,%rdi
  80042a:	48 b8 d0 03 80 00 00 	movabs $0x8003d0,%rax
  800431:	00 00 00 
  800434:	ff d0                	callq  *%rax
  800436:	eb 1c                	jmp    800454 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800438:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80043f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800443:	48 89 d6             	mov    %rdx,%rsi
  800446:	89 c7                	mov    %eax,%edi
  800448:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80044e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800452:	7f e4                	jg     800438 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800454:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045b:	ba 00 00 00 00       	mov    $0x0,%edx
  800460:	48 f7 f1             	div    %rcx
  800463:	48 89 d0             	mov    %rdx,%rax
  800466:	48 ba c8 3e 80 00 00 	movabs $0x803ec8,%rdx
  80046d:	00 00 00 
  800470:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800474:	0f be c0             	movsbl %al,%eax
  800477:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80047b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80047f:	48 89 d6             	mov    %rdx,%rsi
  800482:	89 c7                	mov    %eax,%edi
  800484:	ff d1                	callq  *%rcx
}
  800486:	c9                   	leaveq 
  800487:	c3                   	retq   

0000000000800488 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800488:	55                   	push   %rbp
  800489:	48 89 e5             	mov    %rsp,%rbp
  80048c:	48 83 ec 20          	sub    $0x20,%rsp
  800490:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800494:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800497:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80049b:	7e 52                	jle    8004ef <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80049d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a1:	8b 00                	mov    (%rax),%eax
  8004a3:	83 f8 30             	cmp    $0x30,%eax
  8004a6:	73 24                	jae    8004cc <getuint+0x44>
  8004a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b4:	8b 00                	mov    (%rax),%eax
  8004b6:	89 c0                	mov    %eax,%eax
  8004b8:	48 01 d0             	add    %rdx,%rax
  8004bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bf:	8b 12                	mov    (%rdx),%edx
  8004c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	89 0a                	mov    %ecx,(%rdx)
  8004ca:	eb 17                	jmp    8004e3 <getuint+0x5b>
  8004cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d4:	48 89 d0             	mov    %rdx,%rax
  8004d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e3:	48 8b 00             	mov    (%rax),%rax
  8004e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004ea:	e9 a3 00 00 00       	jmpq   800592 <getuint+0x10a>
	else if (lflag)
  8004ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004f3:	74 4f                	je     800544 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f9:	8b 00                	mov    (%rax),%eax
  8004fb:	83 f8 30             	cmp    $0x30,%eax
  8004fe:	73 24                	jae    800524 <getuint+0x9c>
  800500:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800504:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050c:	8b 00                	mov    (%rax),%eax
  80050e:	89 c0                	mov    %eax,%eax
  800510:	48 01 d0             	add    %rdx,%rax
  800513:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800517:	8b 12                	mov    (%rdx),%edx
  800519:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800520:	89 0a                	mov    %ecx,(%rdx)
  800522:	eb 17                	jmp    80053b <getuint+0xb3>
  800524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800528:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052c:	48 89 d0             	mov    %rdx,%rax
  80052f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800533:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800537:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053b:	48 8b 00             	mov    (%rax),%rax
  80053e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800542:	eb 4e                	jmp    800592 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800548:	8b 00                	mov    (%rax),%eax
  80054a:	83 f8 30             	cmp    $0x30,%eax
  80054d:	73 24                	jae    800573 <getuint+0xeb>
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	8b 00                	mov    (%rax),%eax
  80055d:	89 c0                	mov    %eax,%eax
  80055f:	48 01 d0             	add    %rdx,%rax
  800562:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800566:	8b 12                	mov    (%rdx),%edx
  800568:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	89 0a                	mov    %ecx,(%rdx)
  800571:	eb 17                	jmp    80058a <getuint+0x102>
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80057b:	48 89 d0             	mov    %rdx,%rax
  80057e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800582:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800586:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058a:	8b 00                	mov    (%rax),%eax
  80058c:	89 c0                	mov    %eax,%eax
  80058e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800596:	c9                   	leaveq 
  800597:	c3                   	retq   

0000000000800598 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800598:	55                   	push   %rbp
  800599:	48 89 e5             	mov    %rsp,%rbp
  80059c:	48 83 ec 20          	sub    $0x20,%rsp
  8005a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ab:	7e 52                	jle    8005ff <getint+0x67>
		x=va_arg(*ap, long long);
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	8b 00                	mov    (%rax),%eax
  8005b3:	83 f8 30             	cmp    $0x30,%eax
  8005b6:	73 24                	jae    8005dc <getint+0x44>
  8005b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	8b 00                	mov    (%rax),%eax
  8005c6:	89 c0                	mov    %eax,%eax
  8005c8:	48 01 d0             	add    %rdx,%rax
  8005cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cf:	8b 12                	mov    (%rdx),%edx
  8005d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	89 0a                	mov    %ecx,(%rdx)
  8005da:	eb 17                	jmp    8005f3 <getint+0x5b>
  8005dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e4:	48 89 d0             	mov    %rdx,%rax
  8005e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f3:	48 8b 00             	mov    (%rax),%rax
  8005f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fa:	e9 a3 00 00 00       	jmpq   8006a2 <getint+0x10a>
	else if (lflag)
  8005ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800603:	74 4f                	je     800654 <getint+0xbc>
		x=va_arg(*ap, long);
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	8b 00                	mov    (%rax),%eax
  80060b:	83 f8 30             	cmp    $0x30,%eax
  80060e:	73 24                	jae    800634 <getint+0x9c>
  800610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800614:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	8b 00                	mov    (%rax),%eax
  80061e:	89 c0                	mov    %eax,%eax
  800620:	48 01 d0             	add    %rdx,%rax
  800623:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800627:	8b 12                	mov    (%rdx),%edx
  800629:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800630:	89 0a                	mov    %ecx,(%rdx)
  800632:	eb 17                	jmp    80064b <getint+0xb3>
  800634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800638:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80063c:	48 89 d0             	mov    %rdx,%rax
  80063f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800647:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064b:	48 8b 00             	mov    (%rax),%rax
  80064e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800652:	eb 4e                	jmp    8006a2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	8b 00                	mov    (%rax),%eax
  80065a:	83 f8 30             	cmp    $0x30,%eax
  80065d:	73 24                	jae    800683 <getint+0xeb>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	8b 00                	mov    (%rax),%eax
  80066d:	89 c0                	mov    %eax,%eax
  80066f:	48 01 d0             	add    %rdx,%rax
  800672:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800676:	8b 12                	mov    (%rdx),%edx
  800678:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	89 0a                	mov    %ecx,(%rdx)
  800681:	eb 17                	jmp    80069a <getint+0x102>
  800683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800687:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068b:	48 89 d0             	mov    %rdx,%rax
  80068e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800692:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800696:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069a:	8b 00                	mov    (%rax),%eax
  80069c:	48 98                	cltq   
  80069e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a6:	c9                   	leaveq 
  8006a7:	c3                   	retq   

00000000008006a8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a8:	55                   	push   %rbp
  8006a9:	48 89 e5             	mov    %rsp,%rbp
  8006ac:	41 54                	push   %r12
  8006ae:	53                   	push   %rbx
  8006af:	48 83 ec 60          	sub    $0x60,%rsp
  8006b3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006c3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006cb:	48 8b 0a             	mov    (%rdx),%rcx
  8006ce:	48 89 08             	mov    %rcx,(%rax)
  8006d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e1:	eb 17                	jmp    8006fa <vprintfmt+0x52>
			if (ch == '\0')
  8006e3:	85 db                	test   %ebx,%ebx
  8006e5:	0f 84 d7 04 00 00    	je     800bc2 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8006eb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006ef:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8006f3:	48 89 c6             	mov    %rax,%rsi
  8006f6:	89 df                	mov    %ebx,%edi
  8006f8:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fa:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fe:	0f b6 00             	movzbl (%rax),%eax
  800701:	0f b6 d8             	movzbl %al,%ebx
  800704:	83 fb 25             	cmp    $0x25,%ebx
  800707:	0f 95 c0             	setne  %al
  80070a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80070f:	84 c0                	test   %al,%al
  800711:	75 d0                	jne    8006e3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800713:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800717:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80071e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800725:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80072c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800733:	eb 04                	jmp    800739 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800735:	90                   	nop
  800736:	eb 01                	jmp    800739 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800738:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800739:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80073d:	0f b6 00             	movzbl (%rax),%eax
  800740:	0f b6 d8             	movzbl %al,%ebx
  800743:	89 d8                	mov    %ebx,%eax
  800745:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80074a:	83 e8 23             	sub    $0x23,%eax
  80074d:	83 f8 55             	cmp    $0x55,%eax
  800750:	0f 87 38 04 00 00    	ja     800b8e <vprintfmt+0x4e6>
  800756:	89 c0                	mov    %eax,%eax
  800758:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80075f:	00 
  800760:	48 b8 f0 3e 80 00 00 	movabs $0x803ef0,%rax
  800767:	00 00 00 
  80076a:	48 01 d0             	add    %rdx,%rax
  80076d:	48 8b 00             	mov    (%rax),%rax
  800770:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800772:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800776:	eb c1                	jmp    800739 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800778:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80077c:	eb bb                	jmp    800739 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800785:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800788:	89 d0                	mov    %edx,%eax
  80078a:	c1 e0 02             	shl    $0x2,%eax
  80078d:	01 d0                	add    %edx,%eax
  80078f:	01 c0                	add    %eax,%eax
  800791:	01 d8                	add    %ebx,%eax
  800793:	83 e8 30             	sub    $0x30,%eax
  800796:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800799:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80079d:	0f b6 00             	movzbl (%rax),%eax
  8007a0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a6:	7e 63                	jle    80080b <vprintfmt+0x163>
  8007a8:	83 fb 39             	cmp    $0x39,%ebx
  8007ab:	7f 5e                	jg     80080b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ad:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d1                	jmp    800785 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b7:	83 f8 30             	cmp    $0x30,%eax
  8007ba:	73 17                	jae    8007d3 <vprintfmt+0x12b>
  8007bc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007c0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c3:	89 c0                	mov    %eax,%eax
  8007c5:	48 01 d0             	add    %rdx,%rax
  8007c8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007cb:	83 c2 08             	add    $0x8,%edx
  8007ce:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d1:	eb 0f                	jmp    8007e2 <vprintfmt+0x13a>
  8007d3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d7:	48 89 d0             	mov    %rdx,%rax
  8007da:	48 83 c2 08          	add    $0x8,%rdx
  8007de:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007e7:	eb 23                	jmp    80080c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8007e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007ed:	0f 89 42 ff ff ff    	jns    800735 <vprintfmt+0x8d>
				width = 0;
  8007f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007fa:	e9 36 ff ff ff       	jmpq   800735 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8007ff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800806:	e9 2e ff ff ff       	jmpq   800739 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80080b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80080c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800810:	0f 89 22 ff ff ff    	jns    800738 <vprintfmt+0x90>
				width = precision, precision = -1;
  800816:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800819:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80081c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800823:	e9 10 ff ff ff       	jmpq   800738 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800828:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80082c:	e9 08 ff ff ff       	jmpq   800739 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800831:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800834:	83 f8 30             	cmp    $0x30,%eax
  800837:	73 17                	jae    800850 <vprintfmt+0x1a8>
  800839:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80083d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800840:	89 c0                	mov    %eax,%eax
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800848:	83 c2 08             	add    $0x8,%edx
  80084b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084e:	eb 0f                	jmp    80085f <vprintfmt+0x1b7>
  800850:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800854:	48 89 d0             	mov    %rdx,%rax
  800857:	48 83 c2 08          	add    $0x8,%rdx
  80085b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085f:	8b 00                	mov    (%rax),%eax
  800861:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800865:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800869:	48 89 d6             	mov    %rdx,%rsi
  80086c:	89 c7                	mov    %eax,%edi
  80086e:	ff d1                	callq  *%rcx
			break;
  800870:	e9 47 03 00 00       	jmpq   800bbc <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800875:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800878:	83 f8 30             	cmp    $0x30,%eax
  80087b:	73 17                	jae    800894 <vprintfmt+0x1ec>
  80087d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800881:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800884:	89 c0                	mov    %eax,%eax
  800886:	48 01 d0             	add    %rdx,%rax
  800889:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088c:	83 c2 08             	add    $0x8,%edx
  80088f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800892:	eb 0f                	jmp    8008a3 <vprintfmt+0x1fb>
  800894:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 83 c2 08          	add    $0x8,%rdx
  80089f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008a5:	85 db                	test   %ebx,%ebx
  8008a7:	79 02                	jns    8008ab <vprintfmt+0x203>
				err = -err;
  8008a9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ab:	83 fb 10             	cmp    $0x10,%ebx
  8008ae:	7f 16                	jg     8008c6 <vprintfmt+0x21e>
  8008b0:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  8008b7:	00 00 00 
  8008ba:	48 63 d3             	movslq %ebx,%rdx
  8008bd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008c1:	4d 85 e4             	test   %r12,%r12
  8008c4:	75 2e                	jne    8008f4 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8008c6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ce:	89 d9                	mov    %ebx,%ecx
  8008d0:	48 ba d9 3e 80 00 00 	movabs $0x803ed9,%rdx
  8008d7:	00 00 00 
  8008da:	48 89 c7             	mov    %rax,%rdi
  8008dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e2:	49 b8 cc 0b 80 00 00 	movabs $0x800bcc,%r8
  8008e9:	00 00 00 
  8008ec:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ef:	e9 c8 02 00 00       	jmpq   800bbc <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fc:	4c 89 e1             	mov    %r12,%rcx
  8008ff:	48 ba e2 3e 80 00 00 	movabs $0x803ee2,%rdx
  800906:	00 00 00 
  800909:	48 89 c7             	mov    %rax,%rdi
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	49 b8 cc 0b 80 00 00 	movabs $0x800bcc,%r8
  800918:	00 00 00 
  80091b:	41 ff d0             	callq  *%r8
			break;
  80091e:	e9 99 02 00 00       	jmpq   800bbc <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800923:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800926:	83 f8 30             	cmp    $0x30,%eax
  800929:	73 17                	jae    800942 <vprintfmt+0x29a>
  80092b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80092f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800932:	89 c0                	mov    %eax,%eax
  800934:	48 01 d0             	add    %rdx,%rax
  800937:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093a:	83 c2 08             	add    $0x8,%edx
  80093d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800940:	eb 0f                	jmp    800951 <vprintfmt+0x2a9>
  800942:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800946:	48 89 d0             	mov    %rdx,%rax
  800949:	48 83 c2 08          	add    $0x8,%rdx
  80094d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800951:	4c 8b 20             	mov    (%rax),%r12
  800954:	4d 85 e4             	test   %r12,%r12
  800957:	75 0a                	jne    800963 <vprintfmt+0x2bb>
				p = "(null)";
  800959:	49 bc e5 3e 80 00 00 	movabs $0x803ee5,%r12
  800960:	00 00 00 
			if (width > 0 && padc != '-')
  800963:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800967:	7e 7a                	jle    8009e3 <vprintfmt+0x33b>
  800969:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80096d:	74 74                	je     8009e3 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800972:	48 98                	cltq   
  800974:	48 89 c6             	mov    %rax,%rsi
  800977:	4c 89 e7             	mov    %r12,%rdi
  80097a:	48 b8 76 0e 80 00 00 	movabs $0x800e76,%rax
  800981:	00 00 00 
  800984:	ff d0                	callq  *%rax
  800986:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800989:	eb 17                	jmp    8009a2 <vprintfmt+0x2fa>
					putch(padc, putdat);
  80098b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  80098f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800993:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800997:	48 89 d6             	mov    %rdx,%rsi
  80099a:	89 c7                	mov    %eax,%edi
  80099c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009a2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a6:	7f e3                	jg     80098b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a8:	eb 39                	jmp    8009e3 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8009aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ae:	74 1e                	je     8009ce <vprintfmt+0x326>
  8009b0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b3:	7e 05                	jle    8009ba <vprintfmt+0x312>
  8009b5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b8:	7e 14                	jle    8009ce <vprintfmt+0x326>
					putch('?', putdat);
  8009ba:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009be:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009c2:	48 89 c6             	mov    %rax,%rsi
  8009c5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009ca:	ff d2                	callq  *%rdx
  8009cc:	eb 0f                	jmp    8009dd <vprintfmt+0x335>
				else
					putch(ch, putdat);
  8009ce:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009d2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009d6:	48 89 c6             	mov    %rax,%rsi
  8009d9:	89 df                	mov    %ebx,%edi
  8009db:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009dd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e1:	eb 01                	jmp    8009e4 <vprintfmt+0x33c>
  8009e3:	90                   	nop
  8009e4:	41 0f b6 04 24       	movzbl (%r12),%eax
  8009e9:	0f be d8             	movsbl %al,%ebx
  8009ec:	85 db                	test   %ebx,%ebx
  8009ee:	0f 95 c0             	setne  %al
  8009f1:	49 83 c4 01          	add    $0x1,%r12
  8009f5:	84 c0                	test   %al,%al
  8009f7:	74 28                	je     800a21 <vprintfmt+0x379>
  8009f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009fd:	78 ab                	js     8009aa <vprintfmt+0x302>
  8009ff:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a03:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a07:	79 a1                	jns    8009aa <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a09:	eb 16                	jmp    800a21 <vprintfmt+0x379>
				putch(' ', putdat);
  800a0b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a0f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a13:	48 89 c6             	mov    %rax,%rsi
  800a16:	bf 20 00 00 00       	mov    $0x20,%edi
  800a1b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a1d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a21:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a25:	7f e4                	jg     800a0b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800a27:	e9 90 01 00 00       	jmpq   800bbc <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a30:	be 03 00 00 00       	mov    $0x3,%esi
  800a35:	48 89 c7             	mov    %rax,%rdi
  800a38:	48 b8 98 05 80 00 00 	movabs $0x800598,%rax
  800a3f:	00 00 00 
  800a42:	ff d0                	callq  *%rax
  800a44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4c:	48 85 c0             	test   %rax,%rax
  800a4f:	79 1d                	jns    800a6e <vprintfmt+0x3c6>
				putch('-', putdat);
  800a51:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a55:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a59:	48 89 c6             	mov    %rax,%rsi
  800a5c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a61:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a67:	48 f7 d8             	neg    %rax
  800a6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a6e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a75:	e9 d5 00 00 00       	jmpq   800b4f <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a7e:	be 03 00 00 00       	mov    $0x3,%esi
  800a83:	48 89 c7             	mov    %rax,%rdi
  800a86:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	callq  *%rax
  800a92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a9d:	e9 ad 00 00 00       	jmpq   800b4f <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800aa2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa6:	be 03 00 00 00       	mov    $0x3,%esi
  800aab:	48 89 c7             	mov    %rax,%rdi
  800aae:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800ab5:	00 00 00 
  800ab8:	ff d0                	callq  *%rax
  800aba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800abe:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ac5:	e9 85 00 00 00       	jmpq   800b4f <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800aca:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ace:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ad2:	48 89 c6             	mov    %rax,%rsi
  800ad5:	bf 30 00 00 00       	mov    $0x30,%edi
  800ada:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800adc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ae0:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ae4:	48 89 c6             	mov    %rax,%rsi
  800ae7:	bf 78 00 00 00       	mov    $0x78,%edi
  800aec:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800aee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af1:	83 f8 30             	cmp    $0x30,%eax
  800af4:	73 17                	jae    800b0d <vprintfmt+0x465>
  800af6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800afa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800afd:	89 c0                	mov    %eax,%eax
  800aff:	48 01 d0             	add    %rdx,%rax
  800b02:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b05:	83 c2 08             	add    $0x8,%edx
  800b08:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b0b:	eb 0f                	jmp    800b1c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800b0d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b11:	48 89 d0             	mov    %rdx,%rax
  800b14:	48 83 c2 08          	add    $0x8,%rdx
  800b18:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b1c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b23:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b2a:	eb 23                	jmp    800b4f <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b2c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b30:	be 03 00 00 00       	mov    $0x3,%esi
  800b35:	48 89 c7             	mov    %rax,%rdi
  800b38:	48 b8 88 04 80 00 00 	movabs $0x800488,%rax
  800b3f:	00 00 00 
  800b42:	ff d0                	callq  *%rax
  800b44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b48:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b4f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b54:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b57:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b66:	45 89 c1             	mov    %r8d,%r9d
  800b69:	41 89 f8             	mov    %edi,%r8d
  800b6c:	48 89 c7             	mov    %rax,%rdi
  800b6f:	48 b8 d0 03 80 00 00 	movabs $0x8003d0,%rax
  800b76:	00 00 00 
  800b79:	ff d0                	callq  *%rax
			break;
  800b7b:	eb 3f                	jmp    800bbc <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b81:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b85:	48 89 c6             	mov    %rax,%rsi
  800b88:	89 df                	mov    %ebx,%edi
  800b8a:	ff d2                	callq  *%rdx
			break;
  800b8c:	eb 2e                	jmp    800bbc <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b92:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b96:	48 89 c6             	mov    %rax,%rsi
  800b99:	bf 25 00 00 00       	mov    $0x25,%edi
  800b9e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ba5:	eb 05                	jmp    800bac <vprintfmt+0x504>
  800ba7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bb0:	48 83 e8 01          	sub    $0x1,%rax
  800bb4:	0f b6 00             	movzbl (%rax),%eax
  800bb7:	3c 25                	cmp    $0x25,%al
  800bb9:	75 ec                	jne    800ba7 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800bbb:	90                   	nop
		}
	}
  800bbc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbd:	e9 38 fb ff ff       	jmpq   8006fa <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800bc2:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bc3:	48 83 c4 60          	add    $0x60,%rsp
  800bc7:	5b                   	pop    %rbx
  800bc8:	41 5c                	pop    %r12
  800bca:	5d                   	pop    %rbp
  800bcb:	c3                   	retq   

0000000000800bcc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bcc:	55                   	push   %rbp
  800bcd:	48 89 e5             	mov    %rsp,%rbp
  800bd0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bd7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bde:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800be5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bec:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bf3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bfa:	84 c0                	test   %al,%al
  800bfc:	74 20                	je     800c1e <printfmt+0x52>
  800bfe:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c02:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c06:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c0a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c0e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c12:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c16:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c1a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c1e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c25:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c2c:	00 00 00 
  800c2f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c36:	00 00 00 
  800c39:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c3d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c44:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c4b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c52:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c59:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c60:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c67:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c6e:	48 89 c7             	mov    %rax,%rdi
  800c71:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  800c78:	00 00 00 
  800c7b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c7d:	c9                   	leaveq 
  800c7e:	c3                   	retq   

0000000000800c7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7f:	55                   	push   %rbp
  800c80:	48 89 e5             	mov    %rsp,%rbp
  800c83:	48 83 ec 10          	sub    $0x10,%rsp
  800c87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c92:	8b 40 10             	mov    0x10(%rax),%eax
  800c95:	8d 50 01             	lea    0x1(%rax),%edx
  800c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca3:	48 8b 10             	mov    (%rax),%rdx
  800ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800caa:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cae:	48 39 c2             	cmp    %rax,%rdx
  800cb1:	73 17                	jae    800cca <sprintputch+0x4b>
		*b->buf++ = ch;
  800cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb7:	48 8b 00             	mov    (%rax),%rax
  800cba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cbd:	88 10                	mov    %dl,(%rax)
  800cbf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc7:	48 89 10             	mov    %rdx,(%rax)
}
  800cca:	c9                   	leaveq 
  800ccb:	c3                   	retq   

0000000000800ccc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ccc:	55                   	push   %rbp
  800ccd:	48 89 e5             	mov    %rsp,%rbp
  800cd0:	48 83 ec 50          	sub    $0x50,%rsp
  800cd4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cd8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cdb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cdf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ce3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ce7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ceb:	48 8b 0a             	mov    (%rdx),%rcx
  800cee:	48 89 08             	mov    %rcx,(%rax)
  800cf1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cf5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cf9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cfd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d01:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d05:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d09:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d0c:	48 98                	cltq   
  800d0e:	48 83 e8 01          	sub    $0x1,%rax
  800d12:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800d16:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d1a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d21:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d26:	74 06                	je     800d2e <vsnprintf+0x62>
  800d28:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d2c:	7f 07                	jg     800d35 <vsnprintf+0x69>
		return -E_INVAL;
  800d2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d33:	eb 2f                	jmp    800d64 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d35:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d39:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d3d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d41:	48 89 c6             	mov    %rax,%rsi
  800d44:	48 bf 7f 0c 80 00 00 	movabs $0x800c7f,%rdi
  800d4b:	00 00 00 
  800d4e:	48 b8 a8 06 80 00 00 	movabs $0x8006a8,%rax
  800d55:	00 00 00 
  800d58:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d5e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d61:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d64:	c9                   	leaveq 
  800d65:	c3                   	retq   

0000000000800d66 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d66:	55                   	push   %rbp
  800d67:	48 89 e5             	mov    %rsp,%rbp
  800d6a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d71:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d78:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d7e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d85:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d8c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d93:	84 c0                	test   %al,%al
  800d95:	74 20                	je     800db7 <snprintf+0x51>
  800d97:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d9b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d9f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800da3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800daf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800db3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dbe:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dc5:	00 00 00 
  800dc8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dcf:	00 00 00 
  800dd2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ddd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800de4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800deb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800df2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800df9:	48 8b 0a             	mov    (%rdx),%rcx
  800dfc:	48 89 08             	mov    %rcx,(%rax)
  800dff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e03:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e07:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e0b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e0f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e16:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e1d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e23:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e2a:	48 89 c7             	mov    %rax,%rdi
  800e2d:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  800e34:	00 00 00 
  800e37:	ff d0                	callq  *%rax
  800e39:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e3f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e45:	c9                   	leaveq 
  800e46:	c3                   	retq   
	...

0000000000800e48 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e48:	55                   	push   %rbp
  800e49:	48 89 e5             	mov    %rsp,%rbp
  800e4c:	48 83 ec 18          	sub    $0x18,%rsp
  800e50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e5b:	eb 09                	jmp    800e66 <strlen+0x1e>
		n++;
  800e5d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e61:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e6a:	0f b6 00             	movzbl (%rax),%eax
  800e6d:	84 c0                	test   %al,%al
  800e6f:	75 ec                	jne    800e5d <strlen+0x15>
		n++;
	return n;
  800e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e74:	c9                   	leaveq 
  800e75:	c3                   	retq   

0000000000800e76 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e76:	55                   	push   %rbp
  800e77:	48 89 e5             	mov    %rsp,%rbp
  800e7a:	48 83 ec 20          	sub    $0x20,%rsp
  800e7e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e82:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e8d:	eb 0e                	jmp    800e9d <strnlen+0x27>
		n++;
  800e8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e93:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e98:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e9d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ea2:	74 0b                	je     800eaf <strnlen+0x39>
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	0f b6 00             	movzbl (%rax),%eax
  800eab:	84 c0                	test   %al,%al
  800ead:	75 e0                	jne    800e8f <strnlen+0x19>
		n++;
	return n;
  800eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eb2:	c9                   	leaveq 
  800eb3:	c3                   	retq   

0000000000800eb4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 20          	sub    $0x20,%rsp
  800ebc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ecc:	90                   	nop
  800ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ed1:	0f b6 10             	movzbl (%rax),%edx
  800ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed8:	88 10                	mov    %dl,(%rax)
  800eda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ede:	0f b6 00             	movzbl (%rax),%eax
  800ee1:	84 c0                	test   %al,%al
  800ee3:	0f 95 c0             	setne  %al
  800ee6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eeb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 d9                	jne    800ecd <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ef4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ef8:	c9                   	leaveq 
  800ef9:	c3                   	retq   

0000000000800efa <strcat>:

char *
strcat(char *dst, const char *src)
{
  800efa:	55                   	push   %rbp
  800efb:	48 89 e5             	mov    %rsp,%rbp
  800efe:	48 83 ec 20          	sub    $0x20,%rsp
  800f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	48 89 c7             	mov    %rax,%rdi
  800f11:	48 b8 48 0e 80 00 00 	movabs $0x800e48,%rax
  800f18:	00 00 00 
  800f1b:	ff d0                	callq  *%rax
  800f1d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f23:	48 98                	cltq   
  800f25:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800f29:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2d:	48 89 d6             	mov    %rdx,%rsi
  800f30:	48 89 c7             	mov    %rax,%rdi
  800f33:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  800f3a:	00 00 00 
  800f3d:	ff d0                	callq  *%rax
	return dst;
  800f3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f43:	c9                   	leaveq 
  800f44:	c3                   	retq   

0000000000800f45 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f45:	55                   	push   %rbp
  800f46:	48 89 e5             	mov    %rsp,%rbp
  800f49:	48 83 ec 28          	sub    $0x28,%rsp
  800f4d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f55:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f61:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f68:	00 
  800f69:	eb 27                	jmp    800f92 <strncpy+0x4d>
		*dst++ = *src;
  800f6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6f:	0f b6 10             	movzbl (%rax),%edx
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	88 10                	mov    %dl,(%rax)
  800f78:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f7d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f81:	0f b6 00             	movzbl (%rax),%eax
  800f84:	84 c0                	test   %al,%al
  800f86:	74 05                	je     800f8d <strncpy+0x48>
			src++;
  800f88:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f96:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f9a:	72 cf                	jb     800f6b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fa0:	c9                   	leaveq 
  800fa1:	c3                   	retq   

0000000000800fa2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fa2:	55                   	push   %rbp
  800fa3:	48 89 e5             	mov    %rsp,%rbp
  800fa6:	48 83 ec 28          	sub    $0x28,%rsp
  800faa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fb2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fbe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fc3:	74 37                	je     800ffc <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800fc5:	eb 17                	jmp    800fde <strlcpy+0x3c>
			*dst++ = *src++;
  800fc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fcb:	0f b6 10             	movzbl (%rax),%edx
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	88 10                	mov    %dl,(%rax)
  800fd4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fde:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fe3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe8:	74 0b                	je     800ff5 <strlcpy+0x53>
  800fea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fee:	0f b6 00             	movzbl (%rax),%eax
  800ff1:	84 c0                	test   %al,%al
  800ff3:	75 d2                	jne    800fc7 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ff5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ffc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801004:	48 89 d1             	mov    %rdx,%rcx
  801007:	48 29 c1             	sub    %rax,%rcx
  80100a:	48 89 c8             	mov    %rcx,%rax
}
  80100d:	c9                   	leaveq 
  80100e:	c3                   	retq   

000000000080100f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100f:	55                   	push   %rbp
  801010:	48 89 e5             	mov    %rsp,%rbp
  801013:	48 83 ec 10          	sub    $0x10,%rsp
  801017:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80101b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80101f:	eb 0a                	jmp    80102b <strcmp+0x1c>
		p++, q++;
  801021:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801026:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80102b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102f:	0f b6 00             	movzbl (%rax),%eax
  801032:	84 c0                	test   %al,%al
  801034:	74 12                	je     801048 <strcmp+0x39>
  801036:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103a:	0f b6 10             	movzbl (%rax),%edx
  80103d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801041:	0f b6 00             	movzbl (%rax),%eax
  801044:	38 c2                	cmp    %al,%dl
  801046:	74 d9                	je     801021 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104c:	0f b6 00             	movzbl (%rax),%eax
  80104f:	0f b6 d0             	movzbl %al,%edx
  801052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	0f b6 c0             	movzbl %al,%eax
  80105c:	89 d1                	mov    %edx,%ecx
  80105e:	29 c1                	sub    %eax,%ecx
  801060:	89 c8                	mov    %ecx,%eax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 18          	sub    $0x18,%rsp
  80106c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801070:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801074:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801078:	eb 0f                	jmp    801089 <strncmp+0x25>
		n--, p++, q++;
  80107a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80107f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801084:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801089:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108e:	74 1d                	je     8010ad <strncmp+0x49>
  801090:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801094:	0f b6 00             	movzbl (%rax),%eax
  801097:	84 c0                	test   %al,%al
  801099:	74 12                	je     8010ad <strncmp+0x49>
  80109b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109f:	0f b6 10             	movzbl (%rax),%edx
  8010a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a6:	0f b6 00             	movzbl (%rax),%eax
  8010a9:	38 c2                	cmp    %al,%dl
  8010ab:	74 cd                	je     80107a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b2:	75 07                	jne    8010bb <strncmp+0x57>
		return 0;
  8010b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b9:	eb 1a                	jmp    8010d5 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bf:	0f b6 00             	movzbl (%rax),%eax
  8010c2:	0f b6 d0             	movzbl %al,%edx
  8010c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c9:	0f b6 00             	movzbl (%rax),%eax
  8010cc:	0f b6 c0             	movzbl %al,%eax
  8010cf:	89 d1                	mov    %edx,%ecx
  8010d1:	29 c1                	sub    %eax,%ecx
  8010d3:	89 c8                	mov    %ecx,%eax
}
  8010d5:	c9                   	leaveq 
  8010d6:	c3                   	retq   

00000000008010d7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d7:	55                   	push   %rbp
  8010d8:	48 89 e5             	mov    %rsp,%rbp
  8010db:	48 83 ec 10          	sub    $0x10,%rsp
  8010df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e3:	89 f0                	mov    %esi,%eax
  8010e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010e8:	eb 17                	jmp    801101 <strchr+0x2a>
		if (*s == c)
  8010ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010f4:	75 06                	jne    8010fc <strchr+0x25>
			return (char *) s;
  8010f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fa:	eb 15                	jmp    801111 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801105:	0f b6 00             	movzbl (%rax),%eax
  801108:	84 c0                	test   %al,%al
  80110a:	75 de                	jne    8010ea <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80110c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 10          	sub    $0x10,%rsp
  80111b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80111f:	89 f0                	mov    %esi,%eax
  801121:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801124:	eb 11                	jmp    801137 <strfind+0x24>
		if (*s == c)
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801130:	74 12                	je     801144 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801132:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	75 e4                	jne    801126 <strfind+0x13>
  801142:	eb 01                	jmp    801145 <strfind+0x32>
		if (*s == c)
			break;
  801144:	90                   	nop
	return (char *) s;
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801149:	c9                   	leaveq 
  80114a:	c3                   	retq   

000000000080114b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80114b:	55                   	push   %rbp
  80114c:	48 89 e5             	mov    %rsp,%rbp
  80114f:	48 83 ec 18          	sub    $0x18,%rsp
  801153:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801157:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80115a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80115e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801163:	75 06                	jne    80116b <memset+0x20>
		return v;
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	eb 69                	jmp    8011d4 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	83 e0 03             	and    $0x3,%eax
  801172:	48 85 c0             	test   %rax,%rax
  801175:	75 48                	jne    8011bf <memset+0x74>
  801177:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117b:	83 e0 03             	and    $0x3,%eax
  80117e:	48 85 c0             	test   %rax,%rax
  801181:	75 3c                	jne    8011bf <memset+0x74>
		c &= 0xFF;
  801183:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80118a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	c1 e2 18             	shl    $0x18,%edx
  801192:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801195:	c1 e0 10             	shl    $0x10,%eax
  801198:	09 c2                	or     %eax,%edx
  80119a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119d:	c1 e0 08             	shl    $0x8,%eax
  8011a0:	09 d0                	or     %edx,%eax
  8011a2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 89 c1             	mov    %rax,%rcx
  8011ac:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b7:	48 89 d7             	mov    %rdx,%rdi
  8011ba:	fc                   	cld    
  8011bb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011bd:	eb 11                	jmp    8011d0 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011bf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011ca:	48 89 d7             	mov    %rdx,%rdi
  8011cd:	fc                   	cld    
  8011ce:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 28          	sub    $0x28,%rsp
  8011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fe:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801202:	0f 83 88 00 00 00    	jae    801290 <memmove+0xba>
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801210:	48 01 d0             	add    %rdx,%rax
  801213:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801217:	76 77                	jbe    801290 <memmove+0xba>
		s += n;
  801219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801221:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801225:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122d:	83 e0 03             	and    $0x3,%eax
  801230:	48 85 c0             	test   %rax,%rax
  801233:	75 3b                	jne    801270 <memmove+0x9a>
  801235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801239:	83 e0 03             	and    $0x3,%eax
  80123c:	48 85 c0             	test   %rax,%rax
  80123f:	75 2f                	jne    801270 <memmove+0x9a>
  801241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801245:	83 e0 03             	and    $0x3,%eax
  801248:	48 85 c0             	test   %rax,%rax
  80124b:	75 23                	jne    801270 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80124d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801251:	48 83 e8 04          	sub    $0x4,%rax
  801255:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801259:	48 83 ea 04          	sub    $0x4,%rdx
  80125d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801261:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801265:	48 89 c7             	mov    %rax,%rdi
  801268:	48 89 d6             	mov    %rdx,%rsi
  80126b:	fd                   	std    
  80126c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80126e:	eb 1d                	jmp    80128d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801278:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801284:	48 89 d7             	mov    %rdx,%rdi
  801287:	48 89 c1             	mov    %rax,%rcx
  80128a:	fd                   	std    
  80128b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80128d:	fc                   	cld    
  80128e:	eb 57                	jmp    8012e7 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	83 e0 03             	and    $0x3,%eax
  801297:	48 85 c0             	test   %rax,%rax
  80129a:	75 36                	jne    8012d2 <memmove+0xfc>
  80129c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a0:	83 e0 03             	and    $0x3,%eax
  8012a3:	48 85 c0             	test   %rax,%rax
  8012a6:	75 2a                	jne    8012d2 <memmove+0xfc>
  8012a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ac:	83 e0 03             	and    $0x3,%eax
  8012af:	48 85 c0             	test   %rax,%rax
  8012b2:	75 1e                	jne    8012d2 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b8:	48 89 c1             	mov    %rax,%rcx
  8012bb:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c7:	48 89 c7             	mov    %rax,%rdi
  8012ca:	48 89 d6             	mov    %rdx,%rsi
  8012cd:	fc                   	cld    
  8012ce:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012d0:	eb 15                	jmp    8012e7 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012da:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012de:	48 89 c7             	mov    %rax,%rdi
  8012e1:	48 89 d6             	mov    %rdx,%rsi
  8012e4:	fc                   	cld    
  8012e5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012eb:	c9                   	leaveq 
  8012ec:	c3                   	retq   

00000000008012ed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012ed:	55                   	push   %rbp
  8012ee:	48 89 e5             	mov    %rsp,%rbp
  8012f1:	48 83 ec 18          	sub    $0x18,%rsp
  8012f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012fd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801301:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801305:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	48 89 ce             	mov    %rcx,%rsi
  801310:	48 89 c7             	mov    %rax,%rdi
  801313:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  80131a:	00 00 00 
  80131d:	ff d0                	callq  *%rax
}
  80131f:	c9                   	leaveq 
  801320:	c3                   	retq   

0000000000801321 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801321:	55                   	push   %rbp
  801322:	48 89 e5             	mov    %rsp,%rbp
  801325:	48 83 ec 28          	sub    $0x28,%rsp
  801329:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801331:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80133d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801341:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801345:	eb 38                	jmp    80137f <memcmp+0x5e>
		if (*s1 != *s2)
  801347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134b:	0f b6 10             	movzbl (%rax),%edx
  80134e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801352:	0f b6 00             	movzbl (%rax),%eax
  801355:	38 c2                	cmp    %al,%dl
  801357:	74 1c                	je     801375 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801359:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80135d:	0f b6 00             	movzbl (%rax),%eax
  801360:	0f b6 d0             	movzbl %al,%edx
  801363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801367:	0f b6 00             	movzbl (%rax),%eax
  80136a:	0f b6 c0             	movzbl %al,%eax
  80136d:	89 d1                	mov    %edx,%ecx
  80136f:	29 c1                	sub    %eax,%ecx
  801371:	89 c8                	mov    %ecx,%eax
  801373:	eb 20                	jmp    801395 <memcmp+0x74>
		s1++, s2++;
  801375:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80137a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80137f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801384:	0f 95 c0             	setne  %al
  801387:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80138c:	84 c0                	test   %al,%al
  80138e:	75 b7                	jne    801347 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 28          	sub    $0x28,%rsp
  80139f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013b2:	48 01 d0             	add    %rdx,%rax
  8013b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013b9:	eb 13                	jmp    8013ce <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	0f b6 10             	movzbl (%rax),%edx
  8013c2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 11                	je     8013da <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013d6:	72 e3                	jb     8013bb <memfind+0x24>
  8013d8:	eb 01                	jmp    8013db <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013da:	90                   	nop
	return (void *) s;
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 38          	sub    $0x38,%rsp
  8013e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013f1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013fb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801402:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 05                	jmp    80140a <strtol+0x29>
		s++;
  801405:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	3c 20                	cmp    $0x20,%al
  801413:	74 f0                	je     801405 <strtol+0x24>
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	3c 09                	cmp    $0x9,%al
  80141e:	74 e5                	je     801405 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	3c 2b                	cmp    $0x2b,%al
  801429:	75 07                	jne    801432 <strtol+0x51>
		s++;
  80142b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801430:	eb 17                	jmp    801449 <strtol+0x68>
	else if (*s == '-')
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3c 2d                	cmp    $0x2d,%al
  80143b:	75 0c                	jne    801449 <strtol+0x68>
		s++, neg = 1;
  80143d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801442:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801449:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80144d:	74 06                	je     801455 <strtol+0x74>
  80144f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801453:	75 28                	jne    80147d <strtol+0x9c>
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3c 30                	cmp    $0x30,%al
  80145e:	75 1d                	jne    80147d <strtol+0x9c>
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	48 83 c0 01          	add    $0x1,%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 78                	cmp    $0x78,%al
  80146d:	75 0e                	jne    80147d <strtol+0x9c>
		s += 2, base = 16;
  80146f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801474:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80147b:	eb 2c                	jmp    8014a9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80147d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801481:	75 19                	jne    80149c <strtol+0xbb>
  801483:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	3c 30                	cmp    $0x30,%al
  80148c:	75 0e                	jne    80149c <strtol+0xbb>
		s++, base = 8;
  80148e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801493:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80149a:	eb 0d                	jmp    8014a9 <strtol+0xc8>
	else if (base == 0)
  80149c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a0:	75 07                	jne    8014a9 <strtol+0xc8>
		base = 10;
  8014a2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 2f                	cmp    $0x2f,%al
  8014b2:	7e 1d                	jle    8014d1 <strtol+0xf0>
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	3c 39                	cmp    $0x39,%al
  8014bd:	7f 12                	jg     8014d1 <strtol+0xf0>
			dig = *s - '0';
  8014bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c3:	0f b6 00             	movzbl (%rax),%eax
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	83 e8 30             	sub    $0x30,%eax
  8014cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014cf:	eb 4e                	jmp    80151f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	3c 60                	cmp    $0x60,%al
  8014da:	7e 1d                	jle    8014f9 <strtol+0x118>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	3c 7a                	cmp    $0x7a,%al
  8014e5:	7f 12                	jg     8014f9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	83 e8 57             	sub    $0x57,%eax
  8014f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f7:	eb 26                	jmp    80151f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 40                	cmp    $0x40,%al
  801502:	7e 47                	jle    80154b <strtol+0x16a>
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	3c 5a                	cmp    $0x5a,%al
  80150d:	7f 3c                	jg     80154b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	0f be c0             	movsbl %al,%eax
  801519:	83 e8 37             	sub    $0x37,%eax
  80151c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80151f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801522:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801525:	7d 23                	jge    80154a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801527:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80152c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80152f:	48 98                	cltq   
  801531:	48 89 c2             	mov    %rax,%rdx
  801534:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153c:	48 98                	cltq   
  80153e:	48 01 d0             	add    %rdx,%rax
  801541:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801545:	e9 5f ff ff ff       	jmpq   8014a9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80154a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80154b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801550:	74 0b                	je     80155d <strtol+0x17c>
		*endptr = (char *) s;
  801552:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801556:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80155a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80155d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801561:	74 09                	je     80156c <strtol+0x18b>
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801567:	48 f7 d8             	neg    %rax
  80156a:	eb 04                	jmp    801570 <strtol+0x18f>
  80156c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801570:	c9                   	leaveq 
  801571:	c3                   	retq   

0000000000801572 <strstr>:

char * strstr(const char *in, const char *str)
{
  801572:	55                   	push   %rbp
  801573:	48 89 e5             	mov    %rsp,%rbp
  801576:	48 83 ec 30          	sub    $0x30,%rsp
  80157a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801582:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	88 45 ff             	mov    %al,-0x1(%rbp)
  80158c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801591:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801595:	75 06                	jne    80159d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	eb 68                	jmp    801605 <strstr+0x93>

    len = strlen(str);
  80159d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a1:	48 89 c7             	mov    %rax,%rdi
  8015a4:	48 b8 48 0e 80 00 00 	movabs $0x800e48,%rax
  8015ab:	00 00 00 
  8015ae:	ff d0                	callq  *%rax
  8015b0:	48 98                	cltq   
  8015b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	88 45 ef             	mov    %al,-0x11(%rbp)
  8015c0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8015c5:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c9:	75 07                	jne    8015d2 <strstr+0x60>
                return (char *) 0;
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 33                	jmp    801605 <strstr+0x93>
        } while (sc != c);
  8015d2:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015d6:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d9:	75 db                	jne    8015b6 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8015db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015df:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e7:	48 89 ce             	mov    %rcx,%rsi
  8015ea:	48 89 c7             	mov    %rax,%rdi
  8015ed:	48 b8 64 10 80 00 00 	movabs $0x801064,%rax
  8015f4:	00 00 00 
  8015f7:	ff d0                	callq  *%rax
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	75 b9                	jne    8015b6 <strstr+0x44>

    return (char *) (in - 1);
  8015fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801601:	48 83 e8 01          	sub    $0x1,%rax
}
  801605:	c9                   	leaveq 
  801606:	c3                   	retq   
	...

0000000000801608 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	53                   	push   %rbx
  80160d:	48 83 ec 58          	sub    $0x58,%rsp
  801611:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801614:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801617:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80161b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80161f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801623:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801627:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80162a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  80162d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801631:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801635:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801639:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80163d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801641:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801644:	4c 89 c3             	mov    %r8,%rbx
  801647:	cd 30                	int    $0x30
  801649:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80164d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801651:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801655:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801659:	74 3e                	je     801699 <syscall+0x91>
  80165b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801660:	7e 37                	jle    801699 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801662:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801666:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801669:	49 89 d0             	mov    %rdx,%r8
  80166c:	89 c1                	mov    %eax,%ecx
  80166e:	48 ba a0 41 80 00 00 	movabs $0x8041a0,%rdx
  801675:	00 00 00 
  801678:	be 23 00 00 00       	mov    $0x23,%esi
  80167d:	48 bf bd 41 80 00 00 	movabs $0x8041bd,%rdi
  801684:	00 00 00 
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
  80168c:	49 b9 bc 38 80 00 00 	movabs $0x8038bc,%r9
  801693:	00 00 00 
  801696:	41 ff d1             	callq  *%r9

	return ret;
  801699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80169d:	48 83 c4 58          	add    $0x58,%rsp
  8016a1:	5b                   	pop    %rbx
  8016a2:	5d                   	pop    %rbp
  8016a3:	c3                   	retq   

00000000008016a4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016a4:	55                   	push   %rbp
  8016a5:	48 89 e5             	mov    %rsp,%rbp
  8016a8:	48 83 ec 20          	sub    $0x20,%rsp
  8016ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016c3:	00 
  8016c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d0:	48 89 d1             	mov    %rdx,%rcx
  8016d3:	48 89 c2             	mov    %rax,%rdx
  8016d6:	be 00 00 00 00       	mov    $0x0,%esi
  8016db:	bf 00 00 00 00       	mov    $0x0,%edi
  8016e0:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  8016e7:	00 00 00 
  8016ea:	ff d0                	callq  *%rax
}
  8016ec:	c9                   	leaveq 
  8016ed:	c3                   	retq   

00000000008016ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ee:	55                   	push   %rbp
  8016ef:	48 89 e5             	mov    %rsp,%rbp
  8016f2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016fd:	00 
  8016fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801704:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80170a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80170f:	ba 00 00 00 00       	mov    $0x0,%edx
  801714:	be 00 00 00 00       	mov    $0x0,%esi
  801719:	bf 01 00 00 00       	mov    $0x1,%edi
  80171e:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
}
  80172a:	c9                   	leaveq 
  80172b:	c3                   	retq   

000000000080172c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80172c:	55                   	push   %rbp
  80172d:	48 89 e5             	mov    %rsp,%rbp
  801730:	48 83 ec 20          	sub    $0x20,%rsp
  801734:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801737:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80173a:	48 98                	cltq   
  80173c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801743:	00 
  801744:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80174a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801750:	b9 00 00 00 00       	mov    $0x0,%ecx
  801755:	48 89 c2             	mov    %rax,%rdx
  801758:	be 01 00 00 00       	mov    $0x1,%esi
  80175d:	bf 03 00 00 00       	mov    $0x3,%edi
  801762:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
}
  80176e:	c9                   	leaveq 
  80176f:	c3                   	retq   

0000000000801770 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801770:	55                   	push   %rbp
  801771:	48 89 e5             	mov    %rsp,%rbp
  801774:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801778:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80177f:	00 
  801780:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801786:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80178c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	be 00 00 00 00       	mov    $0x0,%esi
  80179b:	bf 02 00 00 00       	mov    $0x2,%edi
  8017a0:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  8017a7:	00 00 00 
  8017aa:	ff d0                	callq  *%rax
}
  8017ac:	c9                   	leaveq 
  8017ad:	c3                   	retq   

00000000008017ae <sys_yield>:

void
sys_yield(void)
{
  8017ae:	55                   	push   %rbp
  8017af:	48 89 e5             	mov    %rsp,%rbp
  8017b2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017b6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017bd:	00 
  8017be:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d4:	be 00 00 00 00       	mov    $0x0,%esi
  8017d9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017de:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  8017e5:	00 00 00 
  8017e8:	ff d0                	callq  *%rax
}
  8017ea:	c9                   	leaveq 
  8017eb:	c3                   	retq   

00000000008017ec <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	48 83 ec 20          	sub    $0x20,%rsp
  8017f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017fb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801801:	48 63 c8             	movslq %eax,%rcx
  801804:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80180b:	48 98                	cltq   
  80180d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801814:	00 
  801815:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80181b:	49 89 c8             	mov    %rcx,%r8
  80181e:	48 89 d1             	mov    %rdx,%rcx
  801821:	48 89 c2             	mov    %rax,%rdx
  801824:	be 01 00 00 00       	mov    $0x1,%esi
  801829:	bf 04 00 00 00       	mov    $0x4,%edi
  80182e:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801835:	00 00 00 
  801838:	ff d0                	callq  *%rax
}
  80183a:	c9                   	leaveq 
  80183b:	c3                   	retq   

000000000080183c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80183c:	55                   	push   %rbp
  80183d:	48 89 e5             	mov    %rsp,%rbp
  801840:	48 83 ec 30          	sub    $0x30,%rsp
  801844:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801847:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80184b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80184e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801852:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801856:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801859:	48 63 c8             	movslq %eax,%rcx
  80185c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801860:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801863:	48 63 f0             	movslq %eax,%rsi
  801866:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186d:	48 98                	cltq   
  80186f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801873:	49 89 f9             	mov    %rdi,%r9
  801876:	49 89 f0             	mov    %rsi,%r8
  801879:	48 89 d1             	mov    %rdx,%rcx
  80187c:	48 89 c2             	mov    %rax,%rdx
  80187f:	be 01 00 00 00       	mov    $0x1,%esi
  801884:	bf 05 00 00 00       	mov    $0x5,%edi
  801889:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801890:	00 00 00 
  801893:	ff d0                	callq  *%rax
}
  801895:	c9                   	leaveq 
  801896:	c3                   	retq   

0000000000801897 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801897:	55                   	push   %rbp
  801898:	48 89 e5             	mov    %rsp,%rbp
  80189b:	48 83 ec 20          	sub    $0x20,%rsp
  80189f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ad:	48 98                	cltq   
  8018af:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b6:	00 
  8018b7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c3:	48 89 d1             	mov    %rdx,%rcx
  8018c6:	48 89 c2             	mov    %rax,%rdx
  8018c9:	be 01 00 00 00       	mov    $0x1,%esi
  8018ce:	bf 06 00 00 00       	mov    $0x6,%edi
  8018d3:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  8018da:	00 00 00 
  8018dd:	ff d0                	callq  *%rax
}
  8018df:	c9                   	leaveq 
  8018e0:	c3                   	retq   

00000000008018e1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018e1:	55                   	push   %rbp
  8018e2:	48 89 e5             	mov    %rsp,%rbp
  8018e5:	48 83 ec 20          	sub    $0x20,%rsp
  8018e9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ec:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018f2:	48 63 d0             	movslq %eax,%rdx
  8018f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f8:	48 98                	cltq   
  8018fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801901:	00 
  801902:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801908:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190e:	48 89 d1             	mov    %rdx,%rcx
  801911:	48 89 c2             	mov    %rax,%rdx
  801914:	be 01 00 00 00       	mov    $0x1,%esi
  801919:	bf 08 00 00 00       	mov    $0x8,%edi
  80191e:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801925:	00 00 00 
  801928:	ff d0                	callq  *%rax
}
  80192a:	c9                   	leaveq 
  80192b:	c3                   	retq   

000000000080192c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80192c:	55                   	push   %rbp
  80192d:	48 89 e5             	mov    %rsp,%rbp
  801930:	48 83 ec 20          	sub    $0x20,%rsp
  801934:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801937:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80193b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80193f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801942:	48 98                	cltq   
  801944:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194b:	00 
  80194c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801952:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801958:	48 89 d1             	mov    %rdx,%rcx
  80195b:	48 89 c2             	mov    %rax,%rdx
  80195e:	be 01 00 00 00       	mov    $0x1,%esi
  801963:	bf 09 00 00 00       	mov    $0x9,%edi
  801968:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
}
  801974:	c9                   	leaveq 
  801975:	c3                   	retq   

0000000000801976 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 20          	sub    $0x20,%rsp
  80197e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801981:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801985:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80198c:	48 98                	cltq   
  80198e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801995:	00 
  801996:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80199c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a2:	48 89 d1             	mov    %rdx,%rcx
  8019a5:	48 89 c2             	mov    %rax,%rdx
  8019a8:	be 01 00 00 00       	mov    $0x1,%esi
  8019ad:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019b2:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  8019b9:	00 00 00 
  8019bc:	ff d0                	callq  *%rax
}
  8019be:	c9                   	leaveq 
  8019bf:	c3                   	retq   

00000000008019c0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019c0:	55                   	push   %rbp
  8019c1:	48 89 e5             	mov    %rsp,%rbp
  8019c4:	48 83 ec 30          	sub    $0x30,%rsp
  8019c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019cf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019d3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019d9:	48 63 f0             	movslq %eax,%rsi
  8019dc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e3:	48 98                	cltq   
  8019e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f0:	00 
  8019f1:	49 89 f1             	mov    %rsi,%r9
  8019f4:	49 89 c8             	mov    %rcx,%r8
  8019f7:	48 89 d1             	mov    %rdx,%rcx
  8019fa:	48 89 c2             	mov    %rax,%rdx
  8019fd:	be 00 00 00 00       	mov    $0x0,%esi
  801a02:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a07:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801a0e:	00 00 00 
  801a11:	ff d0                	callq  *%rax
}
  801a13:	c9                   	leaveq 
  801a14:	c3                   	retq   

0000000000801a15 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a15:	55                   	push   %rbp
  801a16:	48 89 e5             	mov    %rsp,%rbp
  801a19:	48 83 ec 20          	sub    $0x20,%rsp
  801a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a2c:	00 
  801a2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a3e:	48 89 c2             	mov    %rax,%rdx
  801a41:	be 01 00 00 00       	mov    $0x1,%esi
  801a46:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a4b:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a68:	00 
  801a69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7f:	be 00 00 00 00       	mov    $0x0,%esi
  801a84:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a89:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801a90:	00 00 00 
  801a93:	ff d0                	callq  *%rax
}
  801a95:	c9                   	leaveq 
  801a96:	c3                   	retq   

0000000000801a97 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801a97:	55                   	push   %rbp
  801a98:	48 89 e5             	mov    %rsp,%rbp
  801a9b:	48 83 ec 20          	sub    $0x20,%rsp
  801a9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aa3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801aa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aaf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab6:	00 
  801ab7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801abd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac3:	48 89 d1             	mov    %rdx,%rcx
  801ac6:	48 89 c2             	mov    %rax,%rdx
  801ac9:	be 00 00 00 00       	mov    $0x0,%esi
  801ace:	bf 0f 00 00 00       	mov    $0xf,%edi
  801ad3:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801ada:	00 00 00 
  801add:	ff d0                	callq  *%rax
}
  801adf:	c9                   	leaveq 
  801ae0:	c3                   	retq   

0000000000801ae1 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801ae1:	55                   	push   %rbp
  801ae2:	48 89 e5             	mov    %rsp,%rbp
  801ae5:	48 83 ec 20          	sub    $0x20,%rsp
  801ae9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801aed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801af1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b00:	00 
  801b01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0d:	48 89 d1             	mov    %rdx,%rcx
  801b10:	48 89 c2             	mov    %rax,%rdx
  801b13:	be 00 00 00 00       	mov    $0x0,%esi
  801b18:	bf 10 00 00 00       	mov    $0x10,%edi
  801b1d:	48 b8 08 16 80 00 00 	movabs $0x801608,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	callq  *%rax
}
  801b29:	c9                   	leaveq 
  801b2a:	c3                   	retq   
	...

0000000000801b2c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	48 83 ec 08          	sub    $0x8,%rsp
  801b34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b3c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b43:	ff ff ff 
  801b46:	48 01 d0             	add    %rdx,%rax
  801b49:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   

0000000000801b4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	48 83 ec 08          	sub    $0x8,%rsp
  801b57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5f:	48 89 c7             	mov    %rax,%rdi
  801b62:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801b69:	00 00 00 
  801b6c:	ff d0                	callq  *%rax
  801b6e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b74:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b78:	c9                   	leaveq 
  801b79:	c3                   	retq   

0000000000801b7a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b7a:	55                   	push   %rbp
  801b7b:	48 89 e5             	mov    %rsp,%rbp
  801b7e:	48 83 ec 18          	sub    $0x18,%rsp
  801b82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b8d:	eb 6b                	jmp    801bfa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b92:	48 98                	cltq   
  801b94:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b9a:	48 c1 e0 0c          	shl    $0xc,%rax
  801b9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba6:	48 89 c2             	mov    %rax,%rdx
  801ba9:	48 c1 ea 15          	shr    $0x15,%rdx
  801bad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bb4:	01 00 00 
  801bb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bbb:	83 e0 01             	and    $0x1,%eax
  801bbe:	48 85 c0             	test   %rax,%rax
  801bc1:	74 21                	je     801be4 <fd_alloc+0x6a>
  801bc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc7:	48 89 c2             	mov    %rax,%rdx
  801bca:	48 c1 ea 0c          	shr    $0xc,%rdx
  801bce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bd5:	01 00 00 
  801bd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bdc:	83 e0 01             	and    $0x1,%eax
  801bdf:	48 85 c0             	test   %rax,%rax
  801be2:	75 12                	jne    801bf6 <fd_alloc+0x7c>
			*fd_store = fd;
  801be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bec:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801bef:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf4:	eb 1a                	jmp    801c10 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bf6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bfa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bfe:	7e 8f                	jle    801b8f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c0b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c10:	c9                   	leaveq 
  801c11:	c3                   	retq   

0000000000801c12 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c12:	55                   	push   %rbp
  801c13:	48 89 e5             	mov    %rsp,%rbp
  801c16:	48 83 ec 20          	sub    $0x20,%rsp
  801c1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c25:	78 06                	js     801c2d <fd_lookup+0x1b>
  801c27:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c2b:	7e 07                	jle    801c34 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c32:	eb 6c                	jmp    801ca0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c37:	48 98                	cltq   
  801c39:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c3f:	48 c1 e0 0c          	shl    $0xc,%rax
  801c43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c4b:	48 89 c2             	mov    %rax,%rdx
  801c4e:	48 c1 ea 15          	shr    $0x15,%rdx
  801c52:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c59:	01 00 00 
  801c5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c60:	83 e0 01             	and    $0x1,%eax
  801c63:	48 85 c0             	test   %rax,%rax
  801c66:	74 21                	je     801c89 <fd_lookup+0x77>
  801c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6c:	48 89 c2             	mov    %rax,%rdx
  801c6f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801c73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c7a:	01 00 00 
  801c7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c81:	83 e0 01             	and    $0x1,%eax
  801c84:	48 85 c0             	test   %rax,%rax
  801c87:	75 07                	jne    801c90 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c8e:	eb 10                	jmp    801ca0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c98:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	48 83 ec 30          	sub    $0x30,%rsp
  801caa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cae:	89 f0                	mov    %esi,%eax
  801cb0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb7:	48 89 c7             	mov    %rax,%rdi
  801cba:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801cc1:	00 00 00 
  801cc4:	ff d0                	callq  *%rax
  801cc6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cca:	48 89 d6             	mov    %rdx,%rsi
  801ccd:	89 c7                	mov    %eax,%edi
  801ccf:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  801cd6:	00 00 00 
  801cd9:	ff d0                	callq  *%rax
  801cdb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce2:	78 0a                	js     801cee <fd_close+0x4c>
	    || fd != fd2)
  801ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801cec:	74 12                	je     801d00 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801cee:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cf2:	74 05                	je     801cf9 <fd_close+0x57>
  801cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf7:	eb 05                	jmp    801cfe <fd_close+0x5c>
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfe:	eb 69                	jmp    801d69 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d04:	8b 00                	mov    (%rax),%eax
  801d06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d0a:	48 89 d6             	mov    %rdx,%rsi
  801d0d:	89 c7                	mov    %eax,%edi
  801d0f:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
  801d1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d22:	78 2a                	js     801d4e <fd_close+0xac>
		if (dev->dev_close)
  801d24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d28:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d2c:	48 85 c0             	test   %rax,%rax
  801d2f:	74 16                	je     801d47 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d35:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801d39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	ff d2                	callq  *%rdx
  801d42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d45:	eb 07                	jmp    801d4e <fd_close+0xac>
		else
			r = 0;
  801d47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d52:	48 89 c6             	mov    %rax,%rsi
  801d55:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5a:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  801d61:	00 00 00 
  801d64:	ff d0                	callq  *%rax
	return r;
  801d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d69:	c9                   	leaveq 
  801d6a:	c3                   	retq   

0000000000801d6b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d6b:	55                   	push   %rbp
  801d6c:	48 89 e5             	mov    %rsp,%rbp
  801d6f:	48 83 ec 20          	sub    $0x20,%rsp
  801d73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d81:	eb 41                	jmp    801dc4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d83:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d8a:	00 00 00 
  801d8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d90:	48 63 d2             	movslq %edx,%rdx
  801d93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d97:	8b 00                	mov    (%rax),%eax
  801d99:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d9c:	75 22                	jne    801dc0 <dev_lookup+0x55>
			*dev = devtab[i];
  801d9e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801da5:	00 00 00 
  801da8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dab:	48 63 d2             	movslq %edx,%rdx
  801dae:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801db2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801db6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	eb 60                	jmp    801e20 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801dc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dc4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dcb:	00 00 00 
  801dce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dd1:	48 63 d2             	movslq %edx,%rdx
  801dd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd8:	48 85 c0             	test   %rax,%rax
  801ddb:	75 a6                	jne    801d83 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ddd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801de4:	00 00 00 
  801de7:	48 8b 00             	mov    (%rax),%rax
  801dea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801df0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801df3:	89 c6                	mov    %eax,%esi
  801df5:	48 bf d0 41 80 00 00 	movabs $0x8041d0,%rdi
  801dfc:	00 00 00 
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
  801e04:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  801e0b:	00 00 00 
  801e0e:	ff d1                	callq  *%rcx
	*dev = 0;
  801e10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e14:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e20:	c9                   	leaveq 
  801e21:	c3                   	retq   

0000000000801e22 <close>:

int
close(int fdnum)
{
  801e22:	55                   	push   %rbp
  801e23:	48 89 e5             	mov    %rsp,%rbp
  801e26:	48 83 ec 20          	sub    $0x20,%rsp
  801e2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e34:	48 89 d6             	mov    %rdx,%rsi
  801e37:	89 c7                	mov    %eax,%edi
  801e39:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  801e40:	00 00 00 
  801e43:	ff d0                	callq  *%rax
  801e45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4c:	79 05                	jns    801e53 <close+0x31>
		return r;
  801e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e51:	eb 18                	jmp    801e6b <close+0x49>
	else
		return fd_close(fd, 1);
  801e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e57:	be 01 00 00 00       	mov    $0x1,%esi
  801e5c:	48 89 c7             	mov    %rax,%rdi
  801e5f:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	callq  *%rax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <close_all>:

void
close_all(void)
{
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e7c:	eb 15                	jmp    801e93 <close_all+0x26>
		close(i);
  801e7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e81:	89 c7                	mov    %eax,%edi
  801e83:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  801e8a:	00 00 00 
  801e8d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e93:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e97:	7e e5                	jle    801e7e <close_all+0x11>
		close(i);
}
  801e99:	c9                   	leaveq 
  801e9a:	c3                   	retq   

0000000000801e9b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e9b:	55                   	push   %rbp
  801e9c:	48 89 e5             	mov    %rsp,%rbp
  801e9f:	48 83 ec 40          	sub    $0x40,%rsp
  801ea3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801ea6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ea9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ead:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801eb0:	48 89 d6             	mov    %rdx,%rsi
  801eb3:	89 c7                	mov    %eax,%edi
  801eb5:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  801ebc:	00 00 00 
  801ebf:	ff d0                	callq  *%rax
  801ec1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ec4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec8:	79 08                	jns    801ed2 <dup+0x37>
		return r;
  801eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ecd:	e9 70 01 00 00       	jmpq   802042 <dup+0x1a7>
	close(newfdnum);
  801ed2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ed5:	89 c7                	mov    %eax,%edi
  801ed7:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  801ede:	00 00 00 
  801ee1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801ee3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ee6:	48 98                	cltq   
  801ee8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801eee:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ef6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efa:	48 89 c7             	mov    %rax,%rdi
  801efd:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  801f04:	00 00 00 
  801f07:	ff d0                	callq  *%rax
  801f09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f11:	48 89 c7             	mov    %rax,%rdi
  801f14:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  801f1b:	00 00 00 
  801f1e:	ff d0                	callq  *%rax
  801f20:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f28:	48 89 c2             	mov    %rax,%rdx
  801f2b:	48 c1 ea 15          	shr    $0x15,%rdx
  801f2f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f36:	01 00 00 
  801f39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f3d:	83 e0 01             	and    $0x1,%eax
  801f40:	84 c0                	test   %al,%al
  801f42:	74 71                	je     801fb5 <dup+0x11a>
  801f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f48:	48 89 c2             	mov    %rax,%rdx
  801f4b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f4f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f56:	01 00 00 
  801f59:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5d:	83 e0 01             	and    $0x1,%eax
  801f60:	84 c0                	test   %al,%al
  801f62:	74 51                	je     801fb5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f68:	48 89 c2             	mov    %rax,%rdx
  801f6b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f6f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f76:	01 00 00 
  801f79:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f7d:	89 c1                	mov    %eax,%ecx
  801f7f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801f85:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f8d:	41 89 c8             	mov    %ecx,%r8d
  801f90:	48 89 d1             	mov    %rdx,%rcx
  801f93:	ba 00 00 00 00       	mov    $0x0,%edx
  801f98:	48 89 c6             	mov    %rax,%rsi
  801f9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa0:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	callq  *%rax
  801fac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801faf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fb3:	78 56                	js     80200b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb9:	48 89 c2             	mov    %rax,%rdx
  801fbc:	48 c1 ea 0c          	shr    $0xc,%rdx
  801fc0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc7:	01 00 00 
  801fca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fce:	89 c1                	mov    %eax,%ecx
  801fd0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fde:	41 89 c8             	mov    %ecx,%r8d
  801fe1:	48 89 d1             	mov    %rdx,%rcx
  801fe4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe9:	48 89 c6             	mov    %rax,%rsi
  801fec:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff1:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
  801ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802004:	78 08                	js     80200e <dup+0x173>
		goto err;

	return newfdnum;
  802006:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802009:	eb 37                	jmp    802042 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80200b:	90                   	nop
  80200c:	eb 01                	jmp    80200f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80200e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80200f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802013:	48 89 c6             	mov    %rax,%rsi
  802016:	bf 00 00 00 00       	mov    $0x0,%edi
  80201b:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  802022:	00 00 00 
  802025:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202b:	48 89 c6             	mov    %rax,%rsi
  80202e:	bf 00 00 00 00       	mov    $0x0,%edi
  802033:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax
	return r;
  80203f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802042:	c9                   	leaveq 
  802043:	c3                   	retq   

0000000000802044 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802044:	55                   	push   %rbp
  802045:	48 89 e5             	mov    %rsp,%rbp
  802048:	48 83 ec 40          	sub    $0x40,%rsp
  80204c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80204f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802053:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802057:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80205b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80205e:	48 89 d6             	mov    %rdx,%rsi
  802061:	89 c7                	mov    %eax,%edi
  802063:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80206a:	00 00 00 
  80206d:	ff d0                	callq  *%rax
  80206f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802072:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802076:	78 24                	js     80209c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802078:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80207c:	8b 00                	mov    (%rax),%eax
  80207e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802082:	48 89 d6             	mov    %rdx,%rsi
  802085:	89 c7                	mov    %eax,%edi
  802087:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  80208e:	00 00 00 
  802091:	ff d0                	callq  *%rax
  802093:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802096:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80209a:	79 05                	jns    8020a1 <read+0x5d>
		return r;
  80209c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209f:	eb 7a                	jmp    80211b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a5:	8b 40 08             	mov    0x8(%rax),%eax
  8020a8:	83 e0 03             	and    $0x3,%eax
  8020ab:	83 f8 01             	cmp    $0x1,%eax
  8020ae:	75 3a                	jne    8020ea <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020b0:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8020b7:	00 00 00 
  8020ba:	48 8b 00             	mov    (%rax),%rax
  8020bd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020c6:	89 c6                	mov    %eax,%esi
  8020c8:	48 bf ef 41 80 00 00 	movabs $0x8041ef,%rdi
  8020cf:	00 00 00 
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  8020de:	00 00 00 
  8020e1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e8:	eb 31                	jmp    80211b <read+0xd7>
	}
	if (!dev->dev_read)
  8020ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ee:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020f2:	48 85 c0             	test   %rax,%rax
  8020f5:	75 07                	jne    8020fe <read+0xba>
		return -E_NOT_SUPP;
  8020f7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020fc:	eb 1d                	jmp    80211b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8020fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802102:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802106:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80210a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80210e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802112:	48 89 ce             	mov    %rcx,%rsi
  802115:	48 89 c7             	mov    %rax,%rdi
  802118:	41 ff d0             	callq  *%r8
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	48 83 ec 30          	sub    $0x30,%rsp
  802125:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802128:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80212c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802137:	eb 46                	jmp    80217f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213c:	48 98                	cltq   
  80213e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802142:	48 29 c2             	sub    %rax,%rdx
  802145:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802148:	48 98                	cltq   
  80214a:	48 89 c1             	mov    %rax,%rcx
  80214d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802151:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802154:	48 89 ce             	mov    %rcx,%rsi
  802157:	89 c7                	mov    %eax,%edi
  802159:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  802160:	00 00 00 
  802163:	ff d0                	callq  *%rax
  802165:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80216c:	79 05                	jns    802173 <readn+0x56>
			return m;
  80216e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802171:	eb 1d                	jmp    802190 <readn+0x73>
		if (m == 0)
  802173:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802177:	74 13                	je     80218c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802179:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80217c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80217f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802182:	48 98                	cltq   
  802184:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802188:	72 af                	jb     802139 <readn+0x1c>
  80218a:	eb 01                	jmp    80218d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80218c:	90                   	nop
	}
	return tot;
  80218d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802190:	c9                   	leaveq 
  802191:	c3                   	retq   

0000000000802192 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802192:	55                   	push   %rbp
  802193:	48 89 e5             	mov    %rsp,%rbp
  802196:	48 83 ec 40          	sub    $0x40,%rsp
  80219a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80219d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021ac:	48 89 d6             	mov    %rdx,%rsi
  8021af:	89 c7                	mov    %eax,%edi
  8021b1:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax
  8021bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c4:	78 24                	js     8021ea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ca:	8b 00                	mov    (%rax),%eax
  8021cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021d0:	48 89 d6             	mov    %rdx,%rsi
  8021d3:	89 c7                	mov    %eax,%edi
  8021d5:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	callq  *%rax
  8021e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e8:	79 05                	jns    8021ef <write+0x5d>
		return r;
  8021ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ed:	eb 79                	jmp    802268 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f3:	8b 40 08             	mov    0x8(%rax),%eax
  8021f6:	83 e0 03             	and    $0x3,%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 3a                	jne    802237 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021fd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802204:	00 00 00 
  802207:	48 8b 00             	mov    (%rax),%rax
  80220a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802210:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802213:	89 c6                	mov    %eax,%esi
  802215:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  80221c:	00 00 00 
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  80222b:	00 00 00 
  80222e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802235:	eb 31                	jmp    802268 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80223f:	48 85 c0             	test   %rax,%rax
  802242:	75 07                	jne    80224b <write+0xb9>
		return -E_NOT_SUPP;
  802244:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802249:	eb 1d                	jmp    802268 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80224b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802257:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80225b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80225f:	48 89 ce             	mov    %rcx,%rsi
  802262:	48 89 c7             	mov    %rax,%rdi
  802265:	41 ff d0             	callq  *%r8
}
  802268:	c9                   	leaveq 
  802269:	c3                   	retq   

000000000080226a <seek>:

int
seek(int fdnum, off_t offset)
{
  80226a:	55                   	push   %rbp
  80226b:	48 89 e5             	mov    %rsp,%rbp
  80226e:	48 83 ec 18          	sub    $0x18,%rsp
  802272:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802275:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802278:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80227c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80227f:	48 89 d6             	mov    %rdx,%rsi
  802282:	89 c7                	mov    %eax,%edi
  802284:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80228b:	00 00 00 
  80228e:	ff d0                	callq  *%rax
  802290:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802293:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802297:	79 05                	jns    80229e <seek+0x34>
		return r;
  802299:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229c:	eb 0f                	jmp    8022ad <seek+0x43>
	fd->fd_offset = offset;
  80229e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022a5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ad:	c9                   	leaveq 
  8022ae:	c3                   	retq   

00000000008022af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022af:	55                   	push   %rbp
  8022b0:	48 89 e5             	mov    %rsp,%rbp
  8022b3:	48 83 ec 30          	sub    $0x30,%rsp
  8022b7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ba:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022bd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022c4:	48 89 d6             	mov    %rdx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dc:	78 24                	js     802302 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e2:	8b 00                	mov    (%rax),%eax
  8022e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022e8:	48 89 d6             	mov    %rdx,%rsi
  8022eb:	89 c7                	mov    %eax,%edi
  8022ed:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802300:	79 05                	jns    802307 <ftruncate+0x58>
		return r;
  802302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802305:	eb 72                	jmp    802379 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230b:	8b 40 08             	mov    0x8(%rax),%eax
  80230e:	83 e0 03             	and    $0x3,%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	75 3a                	jne    80234f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802315:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80231c:	00 00 00 
  80231f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802322:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802328:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80232b:	89 c6                	mov    %eax,%esi
  80232d:	48 bf 28 42 80 00 00 	movabs $0x804228,%rdi
  802334:	00 00 00 
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
  80233c:	48 b9 f7 02 80 00 00 	movabs $0x8002f7,%rcx
  802343:	00 00 00 
  802346:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802348:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80234d:	eb 2a                	jmp    802379 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80234f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802353:	48 8b 40 30          	mov    0x30(%rax),%rax
  802357:	48 85 c0             	test   %rax,%rax
  80235a:	75 07                	jne    802363 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80235c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802361:	eb 16                	jmp    802379 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802367:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80236b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802372:	89 d6                	mov    %edx,%esi
  802374:	48 89 c7             	mov    %rax,%rdi
  802377:	ff d1                	callq  *%rcx
}
  802379:	c9                   	leaveq 
  80237a:	c3                   	retq   

000000000080237b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80237b:	55                   	push   %rbp
  80237c:	48 89 e5             	mov    %rsp,%rbp
  80237f:	48 83 ec 30          	sub    $0x30,%rsp
  802383:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802386:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80238a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80238e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802391:	48 89 d6             	mov    %rdx,%rsi
  802394:	89 c7                	mov    %eax,%edi
  802396:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80239d:	00 00 00 
  8023a0:	ff d0                	callq  *%rax
  8023a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a9:	78 24                	js     8023cf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023af:	8b 00                	mov    (%rax),%eax
  8023b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023b5:	48 89 d6             	mov    %rdx,%rsi
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	48 b8 6b 1d 80 00 00 	movabs $0x801d6b,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023cd:	79 05                	jns    8023d4 <fstat+0x59>
		return r;
  8023cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d2:	eb 5e                	jmp    802432 <fstat+0xb7>
	if (!dev->dev_stat)
  8023d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023dc:	48 85 c0             	test   %rax,%rax
  8023df:	75 07                	jne    8023e8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023e1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023e6:	eb 4a                	jmp    802432 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ec:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023fa:	00 00 00 
	stat->st_isdir = 0;
  8023fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802401:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802408:	00 00 00 
	stat->st_dev = dev;
  80240b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802413:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80241a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802426:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80242a:	48 89 d6             	mov    %rdx,%rsi
  80242d:	48 89 c7             	mov    %rax,%rdi
  802430:	ff d1                	callq  *%rcx
}
  802432:	c9                   	leaveq 
  802433:	c3                   	retq   

0000000000802434 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 20          	sub    $0x20,%rsp
  80243c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802440:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802448:	be 00 00 00 00       	mov    $0x0,%esi
  80244d:	48 89 c7             	mov    %rax,%rdi
  802450:	48 b8 23 25 80 00 00 	movabs $0x802523,%rax
  802457:	00 00 00 
  80245a:	ff d0                	callq  *%rax
  80245c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802463:	79 05                	jns    80246a <stat+0x36>
		return fd;
  802465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802468:	eb 2f                	jmp    802499 <stat+0x65>
	r = fstat(fd, stat);
  80246a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80246e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802471:	48 89 d6             	mov    %rdx,%rsi
  802474:	89 c7                	mov    %eax,%edi
  802476:	48 b8 7b 23 80 00 00 	movabs $0x80237b,%rax
  80247d:	00 00 00 
  802480:	ff d0                	callq  *%rax
  802482:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802488:	89 c7                	mov    %eax,%edi
  80248a:	48 b8 22 1e 80 00 00 	movabs $0x801e22,%rax
  802491:	00 00 00 
  802494:	ff d0                	callq  *%rax
	return r;
  802496:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802499:	c9                   	leaveq 
  80249a:	c3                   	retq   
	...

000000000080249c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80249c:	55                   	push   %rbp
  80249d:	48 89 e5             	mov    %rsp,%rbp
  8024a0:	48 83 ec 10          	sub    $0x10,%rsp
  8024a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8024ab:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8024b2:	00 00 00 
  8024b5:	8b 00                	mov    (%rax),%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	75 1d                	jne    8024d8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024bb:	bf 01 00 00 00       	mov    $0x1,%edi
  8024c0:	48 b8 53 3b 80 00 00 	movabs $0x803b53,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
  8024cc:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  8024d3:	00 00 00 
  8024d6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024d8:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  8024df:	00 00 00 
  8024e2:	8b 00                	mov    (%rax),%eax
  8024e4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024e7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024ec:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024f3:	00 00 00 
  8024f6:	89 c7                	mov    %eax,%edi
  8024f8:	48 b8 90 3a 80 00 00 	movabs $0x803a90,%rax
  8024ff:	00 00 00 
  802502:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802508:	ba 00 00 00 00       	mov    $0x0,%edx
  80250d:	48 89 c6             	mov    %rax,%rsi
  802510:	bf 00 00 00 00       	mov    $0x0,%edi
  802515:	48 b8 d0 39 80 00 00 	movabs $0x8039d0,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	callq  *%rax
}
  802521:	c9                   	leaveq 
  802522:	c3                   	retq   

0000000000802523 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802523:	55                   	push   %rbp
  802524:	48 89 e5             	mov    %rsp,%rbp
  802527:	48 83 ec 20          	sub    $0x20,%rsp
  80252b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80252f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802536:	48 89 c7             	mov    %rax,%rdi
  802539:	48 b8 48 0e 80 00 00 	movabs $0x800e48,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
  802545:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80254a:	7e 0a                	jle    802556 <open+0x33>
                return -E_BAD_PATH;
  80254c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802551:	e9 a5 00 00 00       	jmpq   8025fb <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802556:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80255a:	48 89 c7             	mov    %rax,%rdi
  80255d:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802570:	79 08                	jns    80257a <open+0x57>
		return r;
  802572:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802575:	e9 81 00 00 00       	jmpq   8025fb <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80257a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257e:	48 89 c6             	mov    %rax,%rsi
  802581:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802588:	00 00 00 
  80258b:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802597:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80259e:	00 00 00 
  8025a1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8025a4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8025aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ae:	48 89 c6             	mov    %rax,%rsi
  8025b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b6:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	79 1d                	jns    8025e8 <open+0xc5>
	{
		fd_close(fd,0);
  8025cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cf:	be 00 00 00 00       	mov    $0x0,%esi
  8025d4:	48 89 c7             	mov    %rax,%rdi
  8025d7:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8025de:	00 00 00 
  8025e1:	ff d0                	callq  *%rax
		return r;
  8025e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e6:	eb 13                	jmp    8025fb <open+0xd8>
	}
	return fd2num(fd);
  8025e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ec:	48 89 c7             	mov    %rax,%rdi
  8025ef:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8025f6:	00 00 00 
  8025f9:	ff d0                	callq  *%rax
	


}
  8025fb:	c9                   	leaveq 
  8025fc:	c3                   	retq   

00000000008025fd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
  802601:	48 83 ec 10          	sub    $0x10,%rsp
  802605:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802609:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260d:	8b 50 0c             	mov    0xc(%rax),%edx
  802610:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802617:	00 00 00 
  80261a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80261c:	be 00 00 00 00       	mov    $0x0,%esi
  802621:	bf 06 00 00 00       	mov    $0x6,%edi
  802626:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  80262d:	00 00 00 
  802630:	ff d0                	callq  *%rax
}
  802632:	c9                   	leaveq 
  802633:	c3                   	retq   

0000000000802634 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802634:	55                   	push   %rbp
  802635:	48 89 e5             	mov    %rsp,%rbp
  802638:	48 83 ec 30          	sub    $0x30,%rsp
  80263c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802640:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802644:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264c:	8b 50 0c             	mov    0xc(%rax),%edx
  80264f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802656:	00 00 00 
  802659:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80265b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802662:	00 00 00 
  802665:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802669:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80266d:	be 00 00 00 00       	mov    $0x0,%esi
  802672:	bf 03 00 00 00       	mov    $0x3,%edi
  802677:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  80267e:	00 00 00 
  802681:	ff d0                	callq  *%rax
  802683:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802686:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80268a:	79 05                	jns    802691 <devfile_read+0x5d>
	{
		return r;
  80268c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268f:	eb 2c                	jmp    8026bd <devfile_read+0x89>
	}
	if(r > 0)
  802691:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802695:	7e 23                	jle    8026ba <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269a:	48 63 d0             	movslq %eax,%rdx
  80269d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8026a8:	00 00 00 
  8026ab:	48 89 c7             	mov    %rax,%rdi
  8026ae:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
	return r;
  8026ba:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 83 ec 30          	sub    $0x30,%rsp
  8026c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8026d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8026da:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026e1:	00 00 00 
  8026e4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8026e6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8026ed:	00 
  8026ee:	76 08                	jbe    8026f8 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8026f0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8026f7:	00 
	fsipcbuf.write.req_n=n;
  8026f8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026ff:	00 00 00 
  802702:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802706:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80270a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80270e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802712:	48 89 c6             	mov    %rax,%rsi
  802715:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80271c:	00 00 00 
  80271f:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80272b:	be 00 00 00 00       	mov    $0x0,%esi
  802730:	bf 04 00 00 00       	mov    $0x4,%edi
  802735:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
  802741:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802744:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802747:	c9                   	leaveq 
  802748:	c3                   	retq   

0000000000802749 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802749:	55                   	push   %rbp
  80274a:	48 89 e5             	mov    %rsp,%rbp
  80274d:	48 83 ec 10          	sub    $0x10,%rsp
  802751:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802755:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275c:	8b 50 0c             	mov    0xc(%rax),%edx
  80275f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802766:	00 00 00 
  802769:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80276b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802772:	00 00 00 
  802775:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802778:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80277b:	be 00 00 00 00       	mov    $0x0,%esi
  802780:	bf 02 00 00 00       	mov    $0x2,%edi
  802785:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
}
  802791:	c9                   	leaveq 
  802792:	c3                   	retq   

0000000000802793 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802793:	55                   	push   %rbp
  802794:	48 89 e5             	mov    %rsp,%rbp
  802797:	48 83 ec 20          	sub    $0x20,%rsp
  80279b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80279f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8027a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a7:	8b 50 0c             	mov    0xc(%rax),%edx
  8027aa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b1:	00 00 00 
  8027b4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8027b6:	be 00 00 00 00       	mov    $0x0,%esi
  8027bb:	bf 05 00 00 00       	mov    $0x5,%edi
  8027c0:	48 b8 9c 24 80 00 00 	movabs $0x80249c,%rax
  8027c7:	00 00 00 
  8027ca:	ff d0                	callq  *%rax
  8027cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d3:	79 05                	jns    8027da <devfile_stat+0x47>
		return r;
  8027d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d8:	eb 56                	jmp    802830 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8027da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027de:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027e5:	00 00 00 
  8027e8:	48 89 c7             	mov    %rax,%rdi
  8027eb:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  8027f2:	00 00 00 
  8027f5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8027f7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027fe:	00 00 00 
  802801:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802807:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802811:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802818:	00 00 00 
  80281b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802821:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802825:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802830:	c9                   	leaveq 
  802831:	c3                   	retq   
	...

0000000000802834 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802834:	55                   	push   %rbp
  802835:	48 89 e5             	mov    %rsp,%rbp
  802838:	48 83 ec 20          	sub    $0x20,%rsp
  80283c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80283f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802843:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802846:	48 89 d6             	mov    %rdx,%rsi
  802849:	89 c7                	mov    %eax,%edi
  80284b:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802852:	00 00 00 
  802855:	ff d0                	callq  *%rax
  802857:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80285a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285e:	79 05                	jns    802865 <fd2sockid+0x31>
		return r;
  802860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802863:	eb 24                	jmp    802889 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802865:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802869:	8b 10                	mov    (%rax),%edx
  80286b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802872:	00 00 00 
  802875:	8b 00                	mov    (%rax),%eax
  802877:	39 c2                	cmp    %eax,%edx
  802879:	74 07                	je     802882 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80287b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802880:	eb 07                	jmp    802889 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802889:	c9                   	leaveq 
  80288a:	c3                   	retq   

000000000080288b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80288b:	55                   	push   %rbp
  80288c:	48 89 e5             	mov    %rsp,%rbp
  80288f:	48 83 ec 20          	sub    $0x20,%rsp
  802893:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802896:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80289a:	48 89 c7             	mov    %rax,%rdi
  80289d:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
  8028a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b0:	78 26                	js     8028d8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8028b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8028bb:	48 89 c6             	mov    %rax,%rsi
  8028be:	bf 00 00 00 00       	mov    $0x0,%edi
  8028c3:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
  8028cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d6:	79 16                	jns    8028ee <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8028d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028db:	89 c7                	mov    %eax,%edi
  8028dd:	48 b8 98 2d 80 00 00 	movabs $0x802d98,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
		return r;
  8028e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ec:	eb 3a                	jmp    802928 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8028ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028f2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8028f9:	00 00 00 
  8028fc:	8b 12                	mov    (%rdx),%edx
  8028fe:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802904:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80290b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802912:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802915:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802919:	48 89 c7             	mov    %rax,%rdi
  80291c:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  802923:	00 00 00 
  802926:	ff d0                	callq  *%rax
}
  802928:	c9                   	leaveq 
  802929:	c3                   	retq   

000000000080292a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80292a:	55                   	push   %rbp
  80292b:	48 89 e5             	mov    %rsp,%rbp
  80292e:	48 83 ec 30          	sub    $0x30,%rsp
  802932:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802935:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802939:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80293d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802940:	89 c7                	mov    %eax,%edi
  802942:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802949:	00 00 00 
  80294c:	ff d0                	callq  *%rax
  80294e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802951:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802955:	79 05                	jns    80295c <accept+0x32>
		return r;
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295a:	eb 3b                	jmp    802997 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80295c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802960:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802967:	48 89 ce             	mov    %rcx,%rsi
  80296a:	89 c7                	mov    %eax,%edi
  80296c:	48 b8 75 2c 80 00 00 	movabs $0x802c75,%rax
  802973:	00 00 00 
  802976:	ff d0                	callq  *%rax
  802978:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80297f:	79 05                	jns    802986 <accept+0x5c>
		return r;
  802981:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802984:	eb 11                	jmp    802997 <accept+0x6d>
	return alloc_sockfd(r);
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	89 c7                	mov    %eax,%edi
  80298b:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  802992:	00 00 00 
  802995:	ff d0                	callq  *%rax
}
  802997:	c9                   	leaveq 
  802998:	c3                   	retq   

0000000000802999 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802999:	55                   	push   %rbp
  80299a:	48 89 e5             	mov    %rsp,%rbp
  80299d:	48 83 ec 20          	sub    $0x20,%rsp
  8029a1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029a8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ae:	89 c7                	mov    %eax,%edi
  8029b0:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
  8029bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c3:	79 05                	jns    8029ca <bind+0x31>
		return r;
  8029c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c8:	eb 1b                	jmp    8029e5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8029ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029cd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8029d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d4:	48 89 ce             	mov    %rcx,%rsi
  8029d7:	89 c7                	mov    %eax,%edi
  8029d9:	48 b8 f4 2c 80 00 00 	movabs $0x802cf4,%rax
  8029e0:	00 00 00 
  8029e3:	ff d0                	callq  *%rax
}
  8029e5:	c9                   	leaveq 
  8029e6:	c3                   	retq   

00000000008029e7 <shutdown>:

int
shutdown(int s, int how)
{
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
  8029eb:	48 83 ec 20          	sub    $0x20,%rsp
  8029ef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029f2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8029f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029f8:	89 c7                	mov    %eax,%edi
  8029fa:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802a01:	00 00 00 
  802a04:	ff d0                	callq  *%rax
  802a06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0d:	79 05                	jns    802a14 <shutdown+0x2d>
		return r;
  802a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a12:	eb 16                	jmp    802a2a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802a14:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1a:	89 d6                	mov    %edx,%esi
  802a1c:	89 c7                	mov    %eax,%edi
  802a1e:	48 b8 58 2d 80 00 00 	movabs $0x802d58,%rax
  802a25:	00 00 00 
  802a28:	ff d0                	callq  *%rax
}
  802a2a:	c9                   	leaveq 
  802a2b:	c3                   	retq   

0000000000802a2c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802a2c:	55                   	push   %rbp
  802a2d:	48 89 e5             	mov    %rsp,%rbp
  802a30:	48 83 ec 10          	sub    $0x10,%rsp
  802a34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3c:	48 89 c7             	mov    %rax,%rdi
  802a3f:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
  802a4b:	83 f8 01             	cmp    $0x1,%eax
  802a4e:	75 17                	jne    802a67 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802a50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a54:	8b 40 0c             	mov    0xc(%rax),%eax
  802a57:	89 c7                	mov    %eax,%edi
  802a59:	48 b8 98 2d 80 00 00 	movabs $0x802d98,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	callq  *%rax
  802a65:	eb 05                	jmp    802a6c <devsock_close+0x40>
	else
		return 0;
  802a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6c:	c9                   	leaveq 
  802a6d:	c3                   	retq   

0000000000802a6e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a6e:	55                   	push   %rbp
  802a6f:	48 89 e5             	mov    %rsp,%rbp
  802a72:	48 83 ec 20          	sub    $0x20,%rsp
  802a76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a7d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a83:	89 c7                	mov    %eax,%edi
  802a85:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802a8c:	00 00 00 
  802a8f:	ff d0                	callq  *%rax
  802a91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a98:	79 05                	jns    802a9f <connect+0x31>
		return r;
  802a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9d:	eb 1b                	jmp    802aba <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802a9f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802aa2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa9:	48 89 ce             	mov    %rcx,%rsi
  802aac:	89 c7                	mov    %eax,%edi
  802aae:	48 b8 c5 2d 80 00 00 	movabs $0x802dc5,%rax
  802ab5:	00 00 00 
  802ab8:	ff d0                	callq  *%rax
}
  802aba:	c9                   	leaveq 
  802abb:	c3                   	retq   

0000000000802abc <listen>:

int
listen(int s, int backlog)
{
  802abc:	55                   	push   %rbp
  802abd:	48 89 e5             	mov    %rsp,%rbp
  802ac0:	48 83 ec 20          	sub    $0x20,%rsp
  802ac4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ac7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802aca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802acd:	89 c7                	mov    %eax,%edi
  802acf:	48 b8 34 28 80 00 00 	movabs $0x802834,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
  802adb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ade:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae2:	79 05                	jns    802ae9 <listen+0x2d>
		return r;
  802ae4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae7:	eb 16                	jmp    802aff <listen+0x43>
	return nsipc_listen(r, backlog);
  802ae9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802aec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aef:	89 d6                	mov    %edx,%esi
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 29 2e 80 00 00 	movabs $0x802e29,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
}
  802aff:	c9                   	leaveq 
  802b00:	c3                   	retq   

0000000000802b01 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802b01:	55                   	push   %rbp
  802b02:	48 89 e5             	mov    %rsp,%rbp
  802b05:	48 83 ec 20          	sub    $0x20,%rsp
  802b09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b11:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802b15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b19:	89 c2                	mov    %eax,%edx
  802b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b1f:	8b 40 0c             	mov    0xc(%rax),%eax
  802b22:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b2b:	89 c7                	mov    %eax,%edi
  802b2d:	48 b8 69 2e 80 00 00 	movabs $0x802e69,%rax
  802b34:	00 00 00 
  802b37:	ff d0                	callq  *%rax
}
  802b39:	c9                   	leaveq 
  802b3a:	c3                   	retq   

0000000000802b3b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802b3b:	55                   	push   %rbp
  802b3c:	48 89 e5             	mov    %rsp,%rbp
  802b3f:	48 83 ec 20          	sub    $0x20,%rsp
  802b43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b53:	89 c2                	mov    %eax,%edx
  802b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b59:	8b 40 0c             	mov    0xc(%rax),%eax
  802b5c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802b60:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b65:	89 c7                	mov    %eax,%edi
  802b67:	48 b8 35 2f 80 00 00 	movabs $0x802f35,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
}
  802b73:	c9                   	leaveq 
  802b74:	c3                   	retq   

0000000000802b75 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802b75:	55                   	push   %rbp
  802b76:	48 89 e5             	mov    %rsp,%rbp
  802b79:	48 83 ec 10          	sub    $0x10,%rsp
  802b7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802b85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b89:	48 be 53 42 80 00 00 	movabs $0x804253,%rsi
  802b90:	00 00 00 
  802b93:	48 89 c7             	mov    %rax,%rdi
  802b96:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
	return 0;
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba7:	c9                   	leaveq 
  802ba8:	c3                   	retq   

0000000000802ba9 <socket>:

int
socket(int domain, int type, int protocol)
{
  802ba9:	55                   	push   %rbp
  802baa:	48 89 e5             	mov    %rsp,%rbp
  802bad:	48 83 ec 20          	sub    $0x20,%rsp
  802bb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bb4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802bb7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802bba:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bbd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802bc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bc3:	89 ce                	mov    %ecx,%esi
  802bc5:	89 c7                	mov    %eax,%edi
  802bc7:	48 b8 ed 2f 80 00 00 	movabs $0x802fed,%rax
  802bce:	00 00 00 
  802bd1:	ff d0                	callq  *%rax
  802bd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bda:	79 05                	jns    802be1 <socket+0x38>
		return r;
  802bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdf:	eb 11                	jmp    802bf2 <socket+0x49>
	return alloc_sockfd(r);
  802be1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be4:	89 c7                	mov    %eax,%edi
  802be6:	48 b8 8b 28 80 00 00 	movabs $0x80288b,%rax
  802bed:	00 00 00 
  802bf0:	ff d0                	callq  *%rax
}
  802bf2:	c9                   	leaveq 
  802bf3:	c3                   	retq   

0000000000802bf4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802bf4:	55                   	push   %rbp
  802bf5:	48 89 e5             	mov    %rsp,%rbp
  802bf8:	48 83 ec 10          	sub    $0x10,%rsp
  802bfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802bff:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802c06:	00 00 00 
  802c09:	8b 00                	mov    (%rax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	75 1d                	jne    802c2c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802c0f:	bf 02 00 00 00       	mov    $0x2,%edi
  802c14:	48 b8 53 3b 80 00 00 	movabs $0x803b53,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
  802c20:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  802c27:	00 00 00 
  802c2a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802c2c:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802c33:	00 00 00 
  802c36:	8b 00                	mov    (%rax),%eax
  802c38:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c3b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c40:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802c47:	00 00 00 
  802c4a:	89 c7                	mov    %eax,%edi
  802c4c:	48 b8 90 3a 80 00 00 	movabs $0x803a90,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802c58:	ba 00 00 00 00       	mov    $0x0,%edx
  802c5d:	be 00 00 00 00       	mov    $0x0,%esi
  802c62:	bf 00 00 00 00       	mov    $0x0,%edi
  802c67:	48 b8 d0 39 80 00 00 	movabs $0x8039d0,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
}
  802c73:	c9                   	leaveq 
  802c74:	c3                   	retq   

0000000000802c75 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c75:	55                   	push   %rbp
  802c76:	48 89 e5             	mov    %rsp,%rbp
  802c79:	48 83 ec 30          	sub    $0x30,%rsp
  802c7d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802c88:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c8f:	00 00 00 
  802c92:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c95:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802c97:	bf 01 00 00 00       	mov    $0x1,%edi
  802c9c:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802ca3:	00 00 00 
  802ca6:	ff d0                	callq  *%rax
  802ca8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802caf:	78 3e                	js     802cef <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802cb1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cb8:	00 00 00 
  802cbb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc3:	8b 40 10             	mov    0x10(%rax),%eax
  802cc6:	89 c2                	mov    %eax,%edx
  802cc8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802ccc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cd0:	48 89 ce             	mov    %rcx,%rsi
  802cd3:	48 89 c7             	mov    %rax,%rdi
  802cd6:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce6:	8b 50 10             	mov    0x10(%rax),%edx
  802ce9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ced:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cf2:	c9                   	leaveq 
  802cf3:	c3                   	retq   

0000000000802cf4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802cf4:	55                   	push   %rbp
  802cf5:	48 89 e5             	mov    %rsp,%rbp
  802cf8:	48 83 ec 10          	sub    $0x10,%rsp
  802cfc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d03:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802d06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d0d:	00 00 00 
  802d10:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d13:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d15:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1c:	48 89 c6             	mov    %rax,%rsi
  802d1f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802d26:	00 00 00 
  802d29:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802d35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d3c:	00 00 00 
  802d3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d42:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802d45:	bf 02 00 00 00       	mov    $0x2,%edi
  802d4a:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
}
  802d56:	c9                   	leaveq 
  802d57:	c3                   	retq   

0000000000802d58 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802d58:	55                   	push   %rbp
  802d59:	48 89 e5             	mov    %rsp,%rbp
  802d5c:	48 83 ec 10          	sub    $0x10,%rsp
  802d60:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d63:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802d66:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d6d:	00 00 00 
  802d70:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d73:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802d75:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d7c:	00 00 00 
  802d7f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d82:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802d85:	bf 03 00 00 00       	mov    $0x3,%edi
  802d8a:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802d91:	00 00 00 
  802d94:	ff d0                	callq  *%rax
}
  802d96:	c9                   	leaveq 
  802d97:	c3                   	retq   

0000000000802d98 <nsipc_close>:

int
nsipc_close(int s)
{
  802d98:	55                   	push   %rbp
  802d99:	48 89 e5             	mov    %rsp,%rbp
  802d9c:	48 83 ec 10          	sub    $0x10,%rsp
  802da0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802da3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802daa:	00 00 00 
  802dad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802db0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802db2:	bf 04 00 00 00       	mov    $0x4,%edi
  802db7:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802dbe:	00 00 00 
  802dc1:	ff d0                	callq  *%rax
}
  802dc3:	c9                   	leaveq 
  802dc4:	c3                   	retq   

0000000000802dc5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802dc5:	55                   	push   %rbp
  802dc6:	48 89 e5             	mov    %rsp,%rbp
  802dc9:	48 83 ec 10          	sub    $0x10,%rsp
  802dcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dd4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802dd7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dde:	00 00 00 
  802de1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802de4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802de6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802de9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ded:	48 89 c6             	mov    %rax,%rsi
  802df0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802df7:	00 00 00 
  802dfa:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802e06:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e0d:	00 00 00 
  802e10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e13:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802e16:	bf 05 00 00 00       	mov    $0x5,%edi
  802e1b:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
}
  802e27:	c9                   	leaveq 
  802e28:	c3                   	retq   

0000000000802e29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802e29:	55                   	push   %rbp
  802e2a:	48 89 e5             	mov    %rsp,%rbp
  802e2d:	48 83 ec 10          	sub    $0x10,%rsp
  802e31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802e37:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e3e:	00 00 00 
  802e41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e44:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802e46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e4d:	00 00 00 
  802e50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e53:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802e56:	bf 06 00 00 00       	mov    $0x6,%edi
  802e5b:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
}
  802e67:	c9                   	leaveq 
  802e68:	c3                   	retq   

0000000000802e69 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802e69:	55                   	push   %rbp
  802e6a:	48 89 e5             	mov    %rsp,%rbp
  802e6d:	48 83 ec 30          	sub    $0x30,%rsp
  802e71:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e74:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e78:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802e7b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802e7e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e85:	00 00 00 
  802e88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e8b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802e8d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e94:	00 00 00 
  802e97:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802e9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ea4:	00 00 00 
  802ea7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802eaa:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802ead:	bf 07 00 00 00       	mov    $0x7,%edi
  802eb2:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
  802ebe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec5:	78 69                	js     802f30 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802ec7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802ece:	7f 08                	jg     802ed8 <nsipc_recv+0x6f>
  802ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802ed6:	7e 35                	jle    802f0d <nsipc_recv+0xa4>
  802ed8:	48 b9 5a 42 80 00 00 	movabs $0x80425a,%rcx
  802edf:	00 00 00 
  802ee2:	48 ba 6f 42 80 00 00 	movabs $0x80426f,%rdx
  802ee9:	00 00 00 
  802eec:	be 61 00 00 00       	mov    $0x61,%esi
  802ef1:	48 bf 84 42 80 00 00 	movabs $0x804284,%rdi
  802ef8:	00 00 00 
  802efb:	b8 00 00 00 00       	mov    $0x0,%eax
  802f00:	49 b8 bc 38 80 00 00 	movabs $0x8038bc,%r8
  802f07:	00 00 00 
  802f0a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802f0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f10:	48 63 d0             	movslq %eax,%rdx
  802f13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f17:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802f1e:	00 00 00 
  802f21:	48 89 c7             	mov    %rax,%rdi
  802f24:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802f2b:	00 00 00 
  802f2e:	ff d0                	callq  *%rax
	}

	return r;
  802f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f33:	c9                   	leaveq 
  802f34:	c3                   	retq   

0000000000802f35 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802f35:	55                   	push   %rbp
  802f36:	48 89 e5             	mov    %rsp,%rbp
  802f39:	48 83 ec 20          	sub    $0x20,%rsp
  802f3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f44:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802f47:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  802f4a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f51:	00 00 00 
  802f54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f57:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  802f59:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802f60:	7e 35                	jle    802f97 <nsipc_send+0x62>
  802f62:	48 b9 90 42 80 00 00 	movabs $0x804290,%rcx
  802f69:	00 00 00 
  802f6c:	48 ba 6f 42 80 00 00 	movabs $0x80426f,%rdx
  802f73:	00 00 00 
  802f76:	be 6c 00 00 00       	mov    $0x6c,%esi
  802f7b:	48 bf 84 42 80 00 00 	movabs $0x804284,%rdi
  802f82:	00 00 00 
  802f85:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8a:	49 b8 bc 38 80 00 00 	movabs $0x8038bc,%r8
  802f91:	00 00 00 
  802f94:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802f97:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f9a:	48 63 d0             	movslq %eax,%rdx
  802f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa1:	48 89 c6             	mov    %rax,%rsi
  802fa4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  802fab:	00 00 00 
  802fae:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  802fb5:	00 00 00 
  802fb8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  802fba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc1:	00 00 00 
  802fc4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  802fca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fd1:	00 00 00 
  802fd4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fd7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  802fda:	bf 08 00 00 00       	mov    $0x8,%edi
  802fdf:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  802fe6:	00 00 00 
  802fe9:	ff d0                	callq  *%rax
}
  802feb:	c9                   	leaveq 
  802fec:	c3                   	retq   

0000000000802fed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802fed:	55                   	push   %rbp
  802fee:	48 89 e5             	mov    %rsp,%rbp
  802ff1:	48 83 ec 10          	sub    $0x10,%rsp
  802ff5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ff8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802ffb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  802ffe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803005:	00 00 00 
  803008:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80300b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80300d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803014:	00 00 00 
  803017:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80301a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80301d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803024:	00 00 00 
  803027:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80302a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80302d:	bf 09 00 00 00       	mov    $0x9,%edi
  803032:	48 b8 f4 2b 80 00 00 	movabs $0x802bf4,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	53                   	push   %rbx
  803045:	48 83 ec 38          	sub    $0x38,%rsp
  803049:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80304d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803051:	48 89 c7             	mov    %rax,%rdi
  803054:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
  803060:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803063:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803067:	0f 88 bf 01 00 00    	js     80322c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80306d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803071:	ba 07 04 00 00       	mov    $0x407,%edx
  803076:	48 89 c6             	mov    %rax,%rsi
  803079:	bf 00 00 00 00       	mov    $0x0,%edi
  80307e:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  803085:	00 00 00 
  803088:	ff d0                	callq  *%rax
  80308a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80308d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803091:	0f 88 95 01 00 00    	js     80322c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803097:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80309b:	48 89 c7             	mov    %rax,%rdi
  80309e:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b1:	0f 88 5d 01 00 00    	js     803214 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8030c0:	48 89 c6             	mov    %rax,%rsi
  8030c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8030c8:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030db:	0f 88 33 01 00 00    	js     803214 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e5:	48 89 c7             	mov    %rax,%rdi
  8030e8:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8030ef:	00 00 00 
  8030f2:	ff d0                	callq  *%rax
  8030f4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030fc:	ba 07 04 00 00       	mov    $0x407,%edx
  803101:	48 89 c6             	mov    %rax,%rsi
  803104:	bf 00 00 00 00       	mov    $0x0,%edi
  803109:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  803110:	00 00 00 
  803113:	ff d0                	callq  *%rax
  803115:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803118:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80311c:	0f 88 d9 00 00 00    	js     8031fb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803122:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803126:	48 89 c7             	mov    %rax,%rdi
  803129:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803130:	00 00 00 
  803133:	ff d0                	callq  *%rax
  803135:	48 89 c2             	mov    %rax,%rdx
  803138:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80313c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803142:	48 89 d1             	mov    %rdx,%rcx
  803145:	ba 00 00 00 00       	mov    $0x0,%edx
  80314a:	48 89 c6             	mov    %rax,%rsi
  80314d:	bf 00 00 00 00       	mov    $0x0,%edi
  803152:	48 b8 3c 18 80 00 00 	movabs $0x80183c,%rax
  803159:	00 00 00 
  80315c:	ff d0                	callq  *%rax
  80315e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803161:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803165:	78 79                	js     8031e0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803172:	00 00 00 
  803175:	8b 12                	mov    (%rdx),%edx
  803177:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803184:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803188:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80318f:	00 00 00 
  803192:	8b 12                	mov    (%rdx),%edx
  803194:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803196:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80319a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031a5:	48 89 c7             	mov    %rax,%rdi
  8031a8:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8031af:	00 00 00 
  8031b2:	ff d0                	callq  *%rax
  8031b4:	89 c2                	mov    %eax,%edx
  8031b6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031ba:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8031bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031c0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8031c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031c8:	48 89 c7             	mov    %rax,%rdi
  8031cb:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
  8031d7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8031d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031de:	eb 4f                	jmp    80322f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8031e0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8031e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e5:	48 89 c6             	mov    %rax,%rsi
  8031e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ed:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	eb 01                	jmp    8031fc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8031fb:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8031fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803200:	48 89 c6             	mov    %rax,%rsi
  803203:	bf 00 00 00 00       	mov    $0x0,%edi
  803208:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803218:	48 89 c6             	mov    %rax,%rsi
  80321b:	bf 00 00 00 00       	mov    $0x0,%edi
  803220:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
    err:
	return r;
  80322c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80322f:	48 83 c4 38          	add    $0x38,%rsp
  803233:	5b                   	pop    %rbx
  803234:	5d                   	pop    %rbp
  803235:	c3                   	retq   

0000000000803236 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803236:	55                   	push   %rbp
  803237:	48 89 e5             	mov    %rsp,%rbp
  80323a:	53                   	push   %rbx
  80323b:	48 83 ec 28          	sub    $0x28,%rsp
  80323f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803243:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803247:	eb 01                	jmp    80324a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803249:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80324a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803251:	00 00 00 
  803254:	48 8b 00             	mov    (%rax),%rax
  803257:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80325d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803264:	48 89 c7             	mov    %rax,%rdi
  803267:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
  803273:	89 c3                	mov    %eax,%ebx
  803275:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803279:	48 89 c7             	mov    %rax,%rdi
  80327c:	48 b8 d8 3b 80 00 00 	movabs $0x803bd8,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	39 c3                	cmp    %eax,%ebx
  80328a:	0f 94 c0             	sete   %al
  80328d:	0f b6 c0             	movzbl %al,%eax
  803290:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803293:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80329a:	00 00 00 
  80329d:	48 8b 00             	mov    (%rax),%rax
  8032a0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032a6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032ac:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032af:	75 0a                	jne    8032bb <_pipeisclosed+0x85>
			return ret;
  8032b1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8032b4:	48 83 c4 28          	add    $0x28,%rsp
  8032b8:	5b                   	pop    %rbx
  8032b9:	5d                   	pop    %rbp
  8032ba:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8032bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032be:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032c1:	74 86                	je     803249 <_pipeisclosed+0x13>
  8032c3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8032c7:	75 80                	jne    803249 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032c9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8032d0:	00 00 00 
  8032d3:	48 8b 00             	mov    (%rax),%rax
  8032d6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8032dc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e2:	89 c6                	mov    %eax,%esi
  8032e4:	48 bf a1 42 80 00 00 	movabs $0x8042a1,%rdi
  8032eb:	00 00 00 
  8032ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f3:	49 b8 f7 02 80 00 00 	movabs $0x8002f7,%r8
  8032fa:	00 00 00 
  8032fd:	41 ff d0             	callq  *%r8
	}
  803300:	e9 44 ff ff ff       	jmpq   803249 <_pipeisclosed+0x13>

0000000000803305 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803305:	55                   	push   %rbp
  803306:	48 89 e5             	mov    %rsp,%rbp
  803309:	48 83 ec 30          	sub    $0x30,%rsp
  80330d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803310:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803314:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803317:	48 89 d6             	mov    %rdx,%rsi
  80331a:	89 c7                	mov    %eax,%edi
  80331c:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80332b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332f:	79 05                	jns    803336 <pipeisclosed+0x31>
		return r;
  803331:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803334:	eb 31                	jmp    803367 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333a:	48 89 c7             	mov    %rax,%rdi
  80333d:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803344:	00 00 00 
  803347:	ff d0                	callq  *%rax
  803349:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80334d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803355:	48 89 d6             	mov    %rdx,%rsi
  803358:	48 89 c7             	mov    %rax,%rdi
  80335b:	48 b8 36 32 80 00 00 	movabs $0x803236,%rax
  803362:	00 00 00 
  803365:	ff d0                	callq  *%rax
}
  803367:	c9                   	leaveq 
  803368:	c3                   	retq   

0000000000803369 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803369:	55                   	push   %rbp
  80336a:	48 89 e5             	mov    %rsp,%rbp
  80336d:	48 83 ec 40          	sub    $0x40,%rsp
  803371:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803375:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803379:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80337d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803381:	48 89 c7             	mov    %rax,%rdi
  803384:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
  803390:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803394:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803398:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80339c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033a3:	00 
  8033a4:	e9 97 00 00 00       	jmpq   803440 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033a9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8033ae:	74 09                	je     8033b9 <devpipe_read+0x50>
				return i;
  8033b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033b4:	e9 95 00 00 00       	jmpq   80344e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8033b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c1:	48 89 d6             	mov    %rdx,%rsi
  8033c4:	48 89 c7             	mov    %rax,%rdi
  8033c7:	48 b8 36 32 80 00 00 	movabs $0x803236,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
  8033d3:	85 c0                	test   %eax,%eax
  8033d5:	74 07                	je     8033de <devpipe_read+0x75>
				return 0;
  8033d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033dc:	eb 70                	jmp    80344e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8033de:	48 b8 ae 17 80 00 00 	movabs $0x8017ae,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
  8033ea:	eb 01                	jmp    8033ed <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8033ec:	90                   	nop
  8033ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f1:	8b 10                	mov    (%rax),%edx
  8033f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f7:	8b 40 04             	mov    0x4(%rax),%eax
  8033fa:	39 c2                	cmp    %eax,%edx
  8033fc:	74 ab                	je     8033a9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803402:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803406:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80340a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340e:	8b 00                	mov    (%rax),%eax
  803410:	89 c2                	mov    %eax,%edx
  803412:	c1 fa 1f             	sar    $0x1f,%edx
  803415:	c1 ea 1b             	shr    $0x1b,%edx
  803418:	01 d0                	add    %edx,%eax
  80341a:	83 e0 1f             	and    $0x1f,%eax
  80341d:	29 d0                	sub    %edx,%eax
  80341f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803423:	48 98                	cltq   
  803425:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80342a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80342c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803430:	8b 00                	mov    (%rax),%eax
  803432:	8d 50 01             	lea    0x1(%rax),%edx
  803435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803439:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80343b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803440:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803444:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803448:	72 a2                	jb     8033ec <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80344a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80344e:	c9                   	leaveq 
  80344f:	c3                   	retq   

0000000000803450 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803450:	55                   	push   %rbp
  803451:	48 89 e5             	mov    %rsp,%rbp
  803454:	48 83 ec 40          	sub    $0x40,%rsp
  803458:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80345c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803460:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803468:	48 89 c7             	mov    %rax,%rdi
  80346b:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803472:	00 00 00 
  803475:	ff d0                	callq  *%rax
  803477:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80347b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803483:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80348a:	00 
  80348b:	e9 93 00 00 00       	jmpq   803523 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803490:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803498:	48 89 d6             	mov    %rdx,%rsi
  80349b:	48 89 c7             	mov    %rax,%rdi
  80349e:	48 b8 36 32 80 00 00 	movabs $0x803236,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 07                	je     8034b5 <devpipe_write+0x65>
				return 0;
  8034ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b3:	eb 7c                	jmp    803531 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8034b5:	48 b8 ae 17 80 00 00 	movabs $0x8017ae,%rax
  8034bc:	00 00 00 
  8034bf:	ff d0                	callq  *%rax
  8034c1:	eb 01                	jmp    8034c4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034c3:	90                   	nop
  8034c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c8:	8b 40 04             	mov    0x4(%rax),%eax
  8034cb:	48 63 d0             	movslq %eax,%rdx
  8034ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d2:	8b 00                	mov    (%rax),%eax
  8034d4:	48 98                	cltq   
  8034d6:	48 83 c0 20          	add    $0x20,%rax
  8034da:	48 39 c2             	cmp    %rax,%rdx
  8034dd:	73 b1                	jae    803490 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8034df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e3:	8b 40 04             	mov    0x4(%rax),%eax
  8034e6:	89 c2                	mov    %eax,%edx
  8034e8:	c1 fa 1f             	sar    $0x1f,%edx
  8034eb:	c1 ea 1b             	shr    $0x1b,%edx
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	83 e0 1f             	and    $0x1f,%eax
  8034f3:	29 d0                	sub    %edx,%eax
  8034f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034f9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8034fd:	48 01 ca             	add    %rcx,%rdx
  803500:	0f b6 0a             	movzbl (%rdx),%ecx
  803503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803507:	48 98                	cltq   
  803509:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80350d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803511:	8b 40 04             	mov    0x4(%rax),%eax
  803514:	8d 50 01             	lea    0x1(%rax),%edx
  803517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80351e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803527:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80352b:	72 96                	jb     8034c3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80352d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803531:	c9                   	leaveq 
  803532:	c3                   	retq   

0000000000803533 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803533:	55                   	push   %rbp
  803534:	48 89 e5             	mov    %rsp,%rbp
  803537:	48 83 ec 20          	sub    $0x20,%rsp
  80353b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80353f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803547:	48 89 c7             	mov    %rax,%rdi
  80354a:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803551:	00 00 00 
  803554:	ff d0                	callq  *%rax
  803556:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80355a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80355e:	48 be b4 42 80 00 00 	movabs $0x8042b4,%rsi
  803565:	00 00 00 
  803568:	48 89 c7             	mov    %rax,%rdi
  80356b:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357b:	8b 50 04             	mov    0x4(%rax),%edx
  80357e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803582:	8b 00                	mov    (%rax),%eax
  803584:	29 c2                	sub    %eax,%edx
  803586:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80358a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803590:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803594:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80359b:	00 00 00 
	stat->st_dev = &devpipe;
  80359e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8035a9:	00 00 00 
  8035ac:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8035b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b8:	c9                   	leaveq 
  8035b9:	c3                   	retq   

00000000008035ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8035ba:	55                   	push   %rbp
  8035bb:	48 89 e5             	mov    %rsp,%rbp
  8035be:	48 83 ec 10          	sub    $0x10,%rsp
  8035c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8035c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ca:	48 89 c6             	mov    %rax,%rsi
  8035cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d2:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8035de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035e2:	48 89 c7             	mov    %rax,%rdi
  8035e5:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8035ec:	00 00 00 
  8035ef:	ff d0                	callq  *%rax
  8035f1:	48 89 c6             	mov    %rax,%rsi
  8035f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8035f9:	48 b8 97 18 80 00 00 	movabs $0x801897,%rax
  803600:	00 00 00 
  803603:	ff d0                	callq  *%rax
}
  803605:	c9                   	leaveq 
  803606:	c3                   	retq   
	...

0000000000803608 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803608:	55                   	push   %rbp
  803609:	48 89 e5             	mov    %rsp,%rbp
  80360c:	48 83 ec 20          	sub    $0x20,%rsp
  803610:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803613:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803616:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803619:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80361d:	be 01 00 00 00       	mov    $0x1,%esi
  803622:	48 89 c7             	mov    %rax,%rdi
  803625:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  80362c:	00 00 00 
  80362f:	ff d0                	callq  *%rax
}
  803631:	c9                   	leaveq 
  803632:	c3                   	retq   

0000000000803633 <getchar>:

int
getchar(void)
{
  803633:	55                   	push   %rbp
  803634:	48 89 e5             	mov    %rsp,%rbp
  803637:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80363b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80363f:	ba 01 00 00 00       	mov    $0x1,%edx
  803644:	48 89 c6             	mov    %rax,%rsi
  803647:	bf 00 00 00 00       	mov    $0x0,%edi
  80364c:	48 b8 44 20 80 00 00 	movabs $0x802044,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
  803658:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80365b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80365f:	79 05                	jns    803666 <getchar+0x33>
		return r;
  803661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803664:	eb 14                	jmp    80367a <getchar+0x47>
	if (r < 1)
  803666:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366a:	7f 07                	jg     803673 <getchar+0x40>
		return -E_EOF;
  80366c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803671:	eb 07                	jmp    80367a <getchar+0x47>
	return c;
  803673:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803677:	0f b6 c0             	movzbl %al,%eax
}
  80367a:	c9                   	leaveq 
  80367b:	c3                   	retq   

000000000080367c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80367c:	55                   	push   %rbp
  80367d:	48 89 e5             	mov    %rsp,%rbp
  803680:	48 83 ec 20          	sub    $0x20,%rsp
  803684:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803687:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80368b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80368e:	48 89 d6             	mov    %rdx,%rsi
  803691:	89 c7                	mov    %eax,%edi
  803693:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
  80369f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a6:	79 05                	jns    8036ad <iscons+0x31>
		return r;
  8036a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ab:	eb 1a                	jmp    8036c7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b1:	8b 10                	mov    (%rax),%edx
  8036b3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8036ba:	00 00 00 
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	39 c2                	cmp    %eax,%edx
  8036c1:	0f 94 c0             	sete   %al
  8036c4:	0f b6 c0             	movzbl %al,%eax
}
  8036c7:	c9                   	leaveq 
  8036c8:	c3                   	retq   

00000000008036c9 <opencons>:

int
opencons(void)
{
  8036c9:	55                   	push   %rbp
  8036ca:	48 89 e5             	mov    %rsp,%rbp
  8036cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8036d1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036d5:	48 89 c7             	mov    %rax,%rdi
  8036d8:	48 b8 7a 1b 80 00 00 	movabs $0x801b7a,%rax
  8036df:	00 00 00 
  8036e2:	ff d0                	callq  *%rax
  8036e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036eb:	79 05                	jns    8036f2 <opencons+0x29>
		return r;
  8036ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f0:	eb 5b                	jmp    80374d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8036f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f6:	ba 07 04 00 00       	mov    $0x407,%edx
  8036fb:	48 89 c6             	mov    %rax,%rsi
  8036fe:	bf 00 00 00 00       	mov    $0x0,%edi
  803703:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  80370a:	00 00 00 
  80370d:	ff d0                	callq  *%rax
  80370f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803712:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803716:	79 05                	jns    80371d <opencons+0x54>
		return r;
  803718:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80371b:	eb 30                	jmp    80374d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80371d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803721:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803728:	00 00 00 
  80372b:	8b 12                	mov    (%rdx),%edx
  80372d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80372f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803733:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80373a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373e:	48 89 c7             	mov    %rax,%rdi
  803741:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
}
  80374d:	c9                   	leaveq 
  80374e:	c3                   	retq   

000000000080374f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80374f:	55                   	push   %rbp
  803750:	48 89 e5             	mov    %rsp,%rbp
  803753:	48 83 ec 30          	sub    $0x30,%rsp
  803757:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80375b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80375f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803763:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803768:	75 13                	jne    80377d <devcons_read+0x2e>
		return 0;
  80376a:	b8 00 00 00 00       	mov    $0x0,%eax
  80376f:	eb 49                	jmp    8037ba <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803771:	48 b8 ae 17 80 00 00 	movabs $0x8017ae,%rax
  803778:	00 00 00 
  80377b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80377d:	48 b8 ee 16 80 00 00 	movabs $0x8016ee,%rax
  803784:	00 00 00 
  803787:	ff d0                	callq  *%rax
  803789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80378c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803790:	74 df                	je     803771 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803796:	79 05                	jns    80379d <devcons_read+0x4e>
		return c;
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	eb 1d                	jmp    8037ba <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80379d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037a1:	75 07                	jne    8037aa <devcons_read+0x5b>
		return 0;
  8037a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a8:	eb 10                	jmp    8037ba <devcons_read+0x6b>
	*(char*)vbuf = c;
  8037aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ad:	89 c2                	mov    %eax,%edx
  8037af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b3:	88 10                	mov    %dl,(%rax)
	return 1;
  8037b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8037ba:	c9                   	leaveq 
  8037bb:	c3                   	retq   

00000000008037bc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037bc:	55                   	push   %rbp
  8037bd:	48 89 e5             	mov    %rsp,%rbp
  8037c0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8037c7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8037ce:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8037d5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8037e3:	eb 77                	jmp    80385c <devcons_write+0xa0>
		m = n - tot;
  8037e5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8037ec:	89 c2                	mov    %eax,%edx
  8037ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f1:	89 d1                	mov    %edx,%ecx
  8037f3:	29 c1                	sub    %eax,%ecx
  8037f5:	89 c8                	mov    %ecx,%eax
  8037f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8037fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037fd:	83 f8 7f             	cmp    $0x7f,%eax
  803800:	76 07                	jbe    803809 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803802:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803809:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80380c:	48 63 d0             	movslq %eax,%rdx
  80380f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803812:	48 98                	cltq   
  803814:	48 89 c1             	mov    %rax,%rcx
  803817:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80381e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803825:	48 89 ce             	mov    %rcx,%rsi
  803828:	48 89 c7             	mov    %rax,%rdi
  80382b:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803837:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80383a:	48 63 d0             	movslq %eax,%rdx
  80383d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803844:	48 89 d6             	mov    %rdx,%rsi
  803847:	48 89 c7             	mov    %rax,%rdi
  80384a:	48 b8 a4 16 80 00 00 	movabs $0x8016a4,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803856:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803859:	01 45 fc             	add    %eax,-0x4(%rbp)
  80385c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385f:	48 98                	cltq   
  803861:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803868:	0f 82 77 ff ff ff    	jb     8037e5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80386e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803871:	c9                   	leaveq 
  803872:	c3                   	retq   

0000000000803873 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803873:	55                   	push   %rbp
  803874:	48 89 e5             	mov    %rsp,%rbp
  803877:	48 83 ec 08          	sub    $0x8,%rsp
  80387b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80387f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803884:	c9                   	leaveq 
  803885:	c3                   	retq   

0000000000803886 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803886:	55                   	push   %rbp
  803887:	48 89 e5             	mov    %rsp,%rbp
  80388a:	48 83 ec 10          	sub    $0x10,%rsp
  80388e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803892:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389a:	48 be c0 42 80 00 00 	movabs $0x8042c0,%rsi
  8038a1:	00 00 00 
  8038a4:	48 89 c7             	mov    %rax,%rdi
  8038a7:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  8038ae:	00 00 00 
  8038b1:	ff d0                	callq  *%rax
	return 0;
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038b8:	c9                   	leaveq 
  8038b9:	c3                   	retq   
	...

00000000008038bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8038bc:	55                   	push   %rbp
  8038bd:	48 89 e5             	mov    %rsp,%rbp
  8038c0:	53                   	push   %rbx
  8038c1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8038c8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8038cf:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8038d5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8038dc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8038e3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8038ea:	84 c0                	test   %al,%al
  8038ec:	74 23                	je     803911 <_panic+0x55>
  8038ee:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8038f5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8038f9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8038fd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803901:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803905:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803909:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80390d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803911:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803918:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80391f:	00 00 00 
  803922:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803929:	00 00 00 
  80392c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803930:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803937:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80393e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803945:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80394c:	00 00 00 
  80394f:	48 8b 18             	mov    (%rax),%rbx
  803952:	48 b8 70 17 80 00 00 	movabs $0x801770,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
  80395e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803964:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80396b:	41 89 c8             	mov    %ecx,%r8d
  80396e:	48 89 d1             	mov    %rdx,%rcx
  803971:	48 89 da             	mov    %rbx,%rdx
  803974:	89 c6                	mov    %eax,%esi
  803976:	48 bf c8 42 80 00 00 	movabs $0x8042c8,%rdi
  80397d:	00 00 00 
  803980:	b8 00 00 00 00       	mov    $0x0,%eax
  803985:	49 b9 f7 02 80 00 00 	movabs $0x8002f7,%r9
  80398c:	00 00 00 
  80398f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803992:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803999:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8039a0:	48 89 d6             	mov    %rdx,%rsi
  8039a3:	48 89 c7             	mov    %rax,%rdi
  8039a6:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  8039ad:	00 00 00 
  8039b0:	ff d0                	callq  *%rax
	cprintf("\n");
  8039b2:	48 bf eb 42 80 00 00 	movabs $0x8042eb,%rdi
  8039b9:	00 00 00 
  8039bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c1:	48 ba f7 02 80 00 00 	movabs $0x8002f7,%rdx
  8039c8:	00 00 00 
  8039cb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8039cd:	cc                   	int3   
  8039ce:	eb fd                	jmp    8039cd <_panic+0x111>

00000000008039d0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 83 ec 30          	sub    $0x30,%rsp
  8039d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8039e4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039e9:	74 18                	je     803a03 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8039eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039ef:	48 89 c7             	mov    %rax,%rdi
  8039f2:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
  8039fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a01:	eb 19                	jmp    803a1c <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803a03:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803a0a:	00 00 00 
  803a0d:	48 b8 15 1a 80 00 00 	movabs $0x801a15,%rax
  803a14:	00 00 00 
  803a17:	ff d0                	callq  *%rax
  803a19:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803a1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a20:	79 19                	jns    803a3b <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a26:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803a2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a30:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803a36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a39:	eb 53                	jmp    803a8e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803a3b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a40:	74 19                	je     803a5b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803a42:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a49:	00 00 00 
  803a4c:	48 8b 00             	mov    (%rax),%rax
  803a4f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a59:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803a5b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a60:	74 19                	je     803a7b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803a62:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a69:	00 00 00 
  803a6c:	48 8b 00             	mov    (%rax),%rax
  803a6f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a79:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803a7b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a82:	00 00 00 
  803a85:	48 8b 00             	mov    (%rax),%rax
  803a88:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803a8e:	c9                   	leaveq 
  803a8f:	c3                   	retq   

0000000000803a90 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a90:	55                   	push   %rbp
  803a91:	48 89 e5             	mov    %rsp,%rbp
  803a94:	48 83 ec 30          	sub    $0x30,%rsp
  803a98:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a9b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a9e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803aa2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803aa5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803aac:	e9 96 00 00 00       	jmpq   803b47 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803ab1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ab6:	74 20                	je     803ad8 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803ab8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803abb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803abe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ac5:	89 c7                	mov    %eax,%edi
  803ac7:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
  803ad3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ad6:	eb 2d                	jmp    803b05 <ipc_send+0x75>
		else if(pg==NULL)
  803ad8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803add:	75 26                	jne    803b05 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803adf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ae2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ae5:	b9 00 00 00 00       	mov    $0x0,%ecx
  803aea:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803af1:	00 00 00 
  803af4:	89 c7                	mov    %eax,%edi
  803af6:	48 b8 c0 19 80 00 00 	movabs $0x8019c0,%rax
  803afd:	00 00 00 
  803b00:	ff d0                	callq  *%rax
  803b02:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803b05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b09:	79 30                	jns    803b3b <ipc_send+0xab>
  803b0b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b0f:	74 2a                	je     803b3b <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803b11:	48 ba ed 42 80 00 00 	movabs $0x8042ed,%rdx
  803b18:	00 00 00 
  803b1b:	be 40 00 00 00       	mov    $0x40,%esi
  803b20:	48 bf 05 43 80 00 00 	movabs $0x804305,%rdi
  803b27:	00 00 00 
  803b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2f:	48 b9 bc 38 80 00 00 	movabs $0x8038bc,%rcx
  803b36:	00 00 00 
  803b39:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803b3b:	48 b8 ae 17 80 00 00 	movabs $0x8017ae,%rax
  803b42:	00 00 00 
  803b45:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b4b:	0f 85 60 ff ff ff    	jne    803ab1 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803b51:	c9                   	leaveq 
  803b52:	c3                   	retq   

0000000000803b53 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b53:	55                   	push   %rbp
  803b54:	48 89 e5             	mov    %rsp,%rbp
  803b57:	48 83 ec 18          	sub    $0x18,%rsp
  803b5b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b65:	eb 5e                	jmp    803bc5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b67:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b6e:	00 00 00 
  803b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b74:	48 63 d0             	movslq %eax,%rdx
  803b77:	48 89 d0             	mov    %rdx,%rax
  803b7a:	48 c1 e0 03          	shl    $0x3,%rax
  803b7e:	48 01 d0             	add    %rdx,%rax
  803b81:	48 c1 e0 05          	shl    $0x5,%rax
  803b85:	48 01 c8             	add    %rcx,%rax
  803b88:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b8e:	8b 00                	mov    (%rax),%eax
  803b90:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b93:	75 2c                	jne    803bc1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b95:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b9c:	00 00 00 
  803b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba2:	48 63 d0             	movslq %eax,%rdx
  803ba5:	48 89 d0             	mov    %rdx,%rax
  803ba8:	48 c1 e0 03          	shl    $0x3,%rax
  803bac:	48 01 d0             	add    %rdx,%rax
  803baf:	48 c1 e0 05          	shl    $0x5,%rax
  803bb3:	48 01 c8             	add    %rcx,%rax
  803bb6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bbc:	8b 40 08             	mov    0x8(%rax),%eax
  803bbf:	eb 12                	jmp    803bd3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803bc1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bc5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bcc:	7e 99                	jle    803b67 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bd3:	c9                   	leaveq 
  803bd4:	c3                   	retq   
  803bd5:	00 00                	add    %al,(%rax)
	...

0000000000803bd8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bd8:	55                   	push   %rbp
  803bd9:	48 89 e5             	mov    %rsp,%rbp
  803bdc:	48 83 ec 18          	sub    $0x18,%rsp
  803be0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803be4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803be8:	48 89 c2             	mov    %rax,%rdx
  803beb:	48 c1 ea 15          	shr    $0x15,%rdx
  803bef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bf6:	01 00 00 
  803bf9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bfd:	83 e0 01             	and    $0x1,%eax
  803c00:	48 85 c0             	test   %rax,%rax
  803c03:	75 07                	jne    803c0c <pageref+0x34>
		return 0;
  803c05:	b8 00 00 00 00       	mov    $0x0,%eax
  803c0a:	eb 53                	jmp    803c5f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c10:	48 89 c2             	mov    %rax,%rdx
  803c13:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c17:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c1e:	01 00 00 
  803c21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c25:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2d:	83 e0 01             	and    $0x1,%eax
  803c30:	48 85 c0             	test   %rax,%rax
  803c33:	75 07                	jne    803c3c <pageref+0x64>
		return 0;
  803c35:	b8 00 00 00 00       	mov    $0x0,%eax
  803c3a:	eb 23                	jmp    803c5f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c40:	48 89 c2             	mov    %rax,%rdx
  803c43:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c47:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c4e:	00 00 00 
  803c51:	48 c1 e2 04          	shl    $0x4,%rdx
  803c55:	48 01 d0             	add    %rdx,%rax
  803c58:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c5c:	0f b7 c0             	movzwl %ax,%eax
}
  803c5f:	c9                   	leaveq 
  803c60:	c3                   	retq   
