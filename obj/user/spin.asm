
obj/user/spin.debug:     file format elf64-x86-64


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
  80003c:	e8 0b 01 00 00       	callq  80014c <libmain>
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
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800053:	48 bf c0 44 80 00 00 	movabs $0x8044c0,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006e:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  800075:	00 00 00 
  800078:	ff d0                	callq  *%rax
  80007a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800081:	75 1d                	jne    8000a0 <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800083:	48 bf e8 44 80 00 00 	movabs $0x8044e8,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  800099:	00 00 00 
  80009c:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009e:	eb fe                	jmp    80009e <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  8000a0:	48 bf 08 45 80 00 00 	movabs $0x804508,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  8000b6:	00 00 00 
  8000b9:	ff d2                	callq  *%rdx
	sys_yield();
  8000bb:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000c2:	00 00 00 
  8000c5:	ff d0                	callq  *%rax
	sys_yield();
  8000c7:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000ce:	00 00 00 
  8000d1:	ff d0                	callq  *%rax
	sys_yield();
  8000d3:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000da:	00 00 00 
  8000dd:	ff d0                	callq  *%rax
	sys_yield();
  8000df:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
	sys_yield();
  8000eb:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000f2:	00 00 00 
  8000f5:	ff d0                	callq  *%rax
	sys_yield();
  8000f7:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8000fe:	00 00 00 
  800101:	ff d0                	callq  *%rax
	sys_yield();
  800103:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80010a:	00 00 00 
  80010d:	ff d0                	callq  *%rax
	sys_yield();
  80010f:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  800116:	00 00 00 
  800119:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011b:	48 bf 30 45 80 00 00 	movabs $0x804530,%rdi
  800122:	00 00 00 
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
  80012a:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  800131:	00 00 00 
  800134:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800136:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800139:	89 c7                	mov    %eax,%edi
  80013b:	48 b8 70 17 80 00 00 	movabs $0x801770,%rax
  800142:	00 00 00 
  800145:	ff d0                	callq  *%rax
}
  800147:	c9                   	leaveq 
  800148:	c3                   	retq   
  800149:	00 00                	add    %al,(%rax)
	...

000000000080014c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80014c:	55                   	push   %rbp
  80014d:	48 89 e5             	mov    %rsp,%rbp
  800150:	48 83 ec 10          	sub    $0x10,%rsp
  800154:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800157:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80015b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800162:	00 00 00 
  800165:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80016c:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800173:	00 00 00 
  800176:	ff d0                	callq  *%rax
  800178:	48 98                	cltq   
  80017a:	48 89 c2             	mov    %rax,%rdx
  80017d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800183:	48 89 d0             	mov    %rdx,%rax
  800186:	48 c1 e0 03          	shl    $0x3,%rax
  80018a:	48 01 d0             	add    %rdx,%rax
  80018d:	48 c1 e0 05          	shl    $0x5,%rax
  800191:	48 89 c2             	mov    %rax,%rdx
  800194:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80019b:	00 00 00 
  80019e:	48 01 c2             	add    %rax,%rdx
  8001a1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001a8:	00 00 00 
  8001ab:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b2:	7e 14                	jle    8001c8 <libmain+0x7c>
		binaryname = argv[0];
  8001b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b8:	48 8b 10             	mov    (%rax),%rdx
  8001bb:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c2:	00 00 00 
  8001c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001cf:	48 89 d6             	mov    %rdx,%rsi
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001db:	00 00 00 
  8001de:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001e0:	48 b8 f0 01 80 00 00 	movabs $0x8001f0,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
}
  8001ec:	c9                   	leaveq 
  8001ed:	c3                   	retq   
	...

00000000008001f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f0:	55                   	push   %rbp
  8001f1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f4:	48 b8 75 25 80 00 00 	movabs $0x802575,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800200:	bf 00 00 00 00       	mov    $0x0,%edi
  800205:	48 b8 70 17 80 00 00 	movabs $0x801770,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax
}
  800211:	5d                   	pop    %rbp
  800212:	c3                   	retq   
	...

0000000000800214 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800214:	55                   	push   %rbp
  800215:	48 89 e5             	mov    %rsp,%rbp
  800218:	48 83 ec 10          	sub    $0x10,%rsp
  80021c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80021f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800223:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800227:	8b 00                	mov    (%rax),%eax
  800229:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80022c:	89 d6                	mov    %edx,%esi
  80022e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800232:	48 63 d0             	movslq %eax,%rdx
  800235:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80023a:	8d 50 01             	lea    0x1(%rax),%edx
  80023d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800241:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800247:	8b 00                	mov    (%rax),%eax
  800249:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024e:	75 2c                	jne    80027c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800254:	8b 00                	mov    (%rax),%eax
  800256:	48 98                	cltq   
  800258:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025c:	48 83 c2 08          	add    $0x8,%rdx
  800260:	48 89 c6             	mov    %rax,%rsi
  800263:	48 89 d7             	mov    %rdx,%rdi
  800266:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax
		b->idx = 0;
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80027c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800280:	8b 40 04             	mov    0x4(%rax),%eax
  800283:	8d 50 01             	lea    0x1(%rax),%edx
  800286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80028a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028d:	c9                   	leaveq 
  80028e:	c3                   	retq   

000000000080028f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80028f:	55                   	push   %rbp
  800290:	48 89 e5             	mov    %rsp,%rbp
  800293:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80029a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002a1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8002a8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002af:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b6:	48 8b 0a             	mov    (%rdx),%rcx
  8002b9:	48 89 08             	mov    %rcx,(%rax)
  8002bc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002c0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002cc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d3:	00 00 00 
	b.cnt = 0;
  8002d6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002dd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002e0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002ee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f5:	48 89 c6             	mov    %rax,%rsi
  8002f8:	48 bf 14 02 80 00 00 	movabs $0x800214,%rdi
  8002ff:	00 00 00 
  800302:	48 b8 ec 06 80 00 00 	movabs $0x8006ec,%rax
  800309:	00 00 00 
  80030c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80030e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800314:	48 98                	cltq   
  800316:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031d:	48 83 c2 08          	add    $0x8,%rdx
  800321:	48 89 c6             	mov    %rax,%rsi
  800324:	48 89 d7             	mov    %rdx,%rdi
  800327:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800333:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800346:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80034d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800354:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80035b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800362:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800369:	84 c0                	test   %al,%al
  80036b:	74 20                	je     80038d <cprintf+0x52>
  80036d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800371:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800375:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800379:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80037d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800381:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800385:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800389:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80038d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800394:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80039b:	00 00 00 
  80039e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a5:	00 00 00 
  8003a8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003ba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003c1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003c8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003cf:	48 8b 0a             	mov    (%rdx),%rcx
  8003d2:	48 89 08             	mov    %rcx,(%rax)
  8003d5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003d9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003dd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003e5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ec:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f3:	48 89 d6             	mov    %rdx,%rsi
  8003f6:	48 89 c7             	mov    %rax,%rdi
  8003f9:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  800400:	00 00 00 
  800403:	ff d0                	callq  *%rax
  800405:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80040b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800411:	c9                   	leaveq 
  800412:	c3                   	retq   
	...

0000000000800414 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800414:	55                   	push   %rbp
  800415:	48 89 e5             	mov    %rsp,%rbp
  800418:	48 83 ec 30          	sub    $0x30,%rsp
  80041c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800420:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800424:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800428:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80042b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80042f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800433:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800436:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80043a:	77 52                	ja     80048e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80043f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800443:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800446:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80044a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
  800453:	48 f7 75 d0          	divq   -0x30(%rbp)
  800457:	48 89 c2             	mov    %rax,%rdx
  80045a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80045d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800460:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800464:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800468:	41 89 f9             	mov    %edi,%r9d
  80046b:	48 89 c7             	mov    %rax,%rdi
  80046e:	48 b8 14 04 80 00 00 	movabs $0x800414,%rax
  800475:	00 00 00 
  800478:	ff d0                	callq  *%rax
  80047a:	eb 1c                	jmp    800498 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80047c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800480:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800483:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800487:	48 89 d6             	mov    %rdx,%rsi
  80048a:	89 c7                	mov    %eax,%edi
  80048c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800492:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800496:	7f e4                	jg     80047c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800498:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80049b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	48 f7 f1             	div    %rcx
  8004a7:	48 89 d0             	mov    %rdx,%rax
  8004aa:	48 ba 48 47 80 00 00 	movabs $0x804748,%rdx
  8004b1:	00 00 00 
  8004b4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b8:	0f be c0             	movsbl %al,%eax
  8004bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004bf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	89 c7                	mov    %eax,%edi
  8004c8:	ff d1                	callq  *%rcx
}
  8004ca:	c9                   	leaveq 
  8004cb:	c3                   	retq   

00000000008004cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cc:	55                   	push   %rbp
  8004cd:	48 89 e5             	mov    %rsp,%rbp
  8004d0:	48 83 ec 20          	sub    $0x20,%rsp
  8004d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004db:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004df:	7e 52                	jle    800533 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e5:	8b 00                	mov    (%rax),%eax
  8004e7:	83 f8 30             	cmp    $0x30,%eax
  8004ea:	73 24                	jae    800510 <getuint+0x44>
  8004ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f8:	8b 00                	mov    (%rax),%eax
  8004fa:	89 c0                	mov    %eax,%eax
  8004fc:	48 01 d0             	add    %rdx,%rax
  8004ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800503:	8b 12                	mov    (%rdx),%edx
  800505:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800508:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050c:	89 0a                	mov    %ecx,(%rdx)
  80050e:	eb 17                	jmp    800527 <getuint+0x5b>
  800510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800514:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800518:	48 89 d0             	mov    %rdx,%rax
  80051b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800523:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800527:	48 8b 00             	mov    (%rax),%rax
  80052a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052e:	e9 a3 00 00 00       	jmpq   8005d6 <getuint+0x10a>
	else if (lflag)
  800533:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800537:	74 4f                	je     800588 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800539:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053d:	8b 00                	mov    (%rax),%eax
  80053f:	83 f8 30             	cmp    $0x30,%eax
  800542:	73 24                	jae    800568 <getuint+0x9c>
  800544:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800548:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800550:	8b 00                	mov    (%rax),%eax
  800552:	89 c0                	mov    %eax,%eax
  800554:	48 01 d0             	add    %rdx,%rax
  800557:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055b:	8b 12                	mov    (%rdx),%edx
  80055d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800560:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800564:	89 0a                	mov    %ecx,(%rdx)
  800566:	eb 17                	jmp    80057f <getuint+0xb3>
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800570:	48 89 d0             	mov    %rdx,%rax
  800573:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057f:	48 8b 00             	mov    (%rax),%rax
  800582:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800586:	eb 4e                	jmp    8005d6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	83 f8 30             	cmp    $0x30,%eax
  800591:	73 24                	jae    8005b7 <getuint+0xeb>
  800593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800597:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059f:	8b 00                	mov    (%rax),%eax
  8005a1:	89 c0                	mov    %eax,%eax
  8005a3:	48 01 d0             	add    %rdx,%rax
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	8b 12                	mov    (%rdx),%edx
  8005ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	89 0a                	mov    %ecx,(%rdx)
  8005b5:	eb 17                	jmp    8005ce <getuint+0x102>
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bf:	48 89 d0             	mov    %rdx,%rax
  8005c2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ce:	8b 00                	mov    (%rax),%eax
  8005d0:	89 c0                	mov    %eax,%eax
  8005d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005da:	c9                   	leaveq 
  8005db:	c3                   	retq   

00000000008005dc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005dc:	55                   	push   %rbp
  8005dd:	48 89 e5             	mov    %rsp,%rbp
  8005e0:	48 83 ec 20          	sub    $0x20,%rsp
  8005e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005eb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ef:	7e 52                	jle    800643 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f5:	8b 00                	mov    (%rax),%eax
  8005f7:	83 f8 30             	cmp    $0x30,%eax
  8005fa:	73 24                	jae    800620 <getint+0x44>
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800608:	8b 00                	mov    (%rax),%eax
  80060a:	89 c0                	mov    %eax,%eax
  80060c:	48 01 d0             	add    %rdx,%rax
  80060f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800613:	8b 12                	mov    (%rdx),%edx
  800615:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800618:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061c:	89 0a                	mov    %ecx,(%rdx)
  80061e:	eb 17                	jmp    800637 <getint+0x5b>
  800620:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800624:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800628:	48 89 d0             	mov    %rdx,%rax
  80062b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800633:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800637:	48 8b 00             	mov    (%rax),%rax
  80063a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063e:	e9 a3 00 00 00       	jmpq   8006e6 <getint+0x10a>
	else if (lflag)
  800643:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800647:	74 4f                	je     800698 <getint+0xbc>
		x=va_arg(*ap, long);
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	8b 00                	mov    (%rax),%eax
  80064f:	83 f8 30             	cmp    $0x30,%eax
  800652:	73 24                	jae    800678 <getint+0x9c>
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800660:	8b 00                	mov    (%rax),%eax
  800662:	89 c0                	mov    %eax,%eax
  800664:	48 01 d0             	add    %rdx,%rax
  800667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066b:	8b 12                	mov    (%rdx),%edx
  80066d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800670:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800674:	89 0a                	mov    %ecx,(%rdx)
  800676:	eb 17                	jmp    80068f <getint+0xb3>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800680:	48 89 d0             	mov    %rdx,%rax
  800683:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068f:	48 8b 00             	mov    (%rax),%rax
  800692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800696:	eb 4e                	jmp    8006e6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	83 f8 30             	cmp    $0x30,%eax
  8006a1:	73 24                	jae    8006c7 <getint+0xeb>
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006af:	8b 00                	mov    (%rax),%eax
  8006b1:	89 c0                	mov    %eax,%eax
  8006b3:	48 01 d0             	add    %rdx,%rax
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	8b 12                	mov    (%rdx),%edx
  8006bc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	89 0a                	mov    %ecx,(%rdx)
  8006c5:	eb 17                	jmp    8006de <getint+0x102>
  8006c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006cf:	48 89 d0             	mov    %rdx,%rax
  8006d2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006de:	8b 00                	mov    (%rax),%eax
  8006e0:	48 98                	cltq   
  8006e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006ea:	c9                   	leaveq 
  8006eb:	c3                   	retq   

00000000008006ec <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ec:	55                   	push   %rbp
  8006ed:	48 89 e5             	mov    %rsp,%rbp
  8006f0:	41 54                	push   %r12
  8006f2:	53                   	push   %rbx
  8006f3:	48 83 ec 60          	sub    $0x60,%rsp
  8006f7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006fb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006ff:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800703:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800707:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80070b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80070f:	48 8b 0a             	mov    (%rdx),%rcx
  800712:	48 89 08             	mov    %rcx,(%rax)
  800715:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800719:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80071d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800721:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	eb 17                	jmp    80073e <vprintfmt+0x52>
			if (ch == '\0')
  800727:	85 db                	test   %ebx,%ebx
  800729:	0f 84 d7 04 00 00    	je     800c06 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80072f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800733:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800737:	48 89 c6             	mov    %rax,%rsi
  80073a:	89 df                	mov    %ebx,%edi
  80073c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800742:	0f b6 00             	movzbl (%rax),%eax
  800745:	0f b6 d8             	movzbl %al,%ebx
  800748:	83 fb 25             	cmp    $0x25,%ebx
  80074b:	0f 95 c0             	setne  %al
  80074e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800753:	84 c0                	test   %al,%al
  800755:	75 d0                	jne    800727 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800757:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80075b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800762:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800769:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800770:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800777:	eb 04                	jmp    80077d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800779:	90                   	nop
  80077a:	eb 01                	jmp    80077d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80077c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800781:	0f b6 00             	movzbl (%rax),%eax
  800784:	0f b6 d8             	movzbl %al,%ebx
  800787:	89 d8                	mov    %ebx,%eax
  800789:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80078e:	83 e8 23             	sub    $0x23,%eax
  800791:	83 f8 55             	cmp    $0x55,%eax
  800794:	0f 87 38 04 00 00    	ja     800bd2 <vprintfmt+0x4e6>
  80079a:	89 c0                	mov    %eax,%eax
  80079c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007a3:	00 
  8007a4:	48 b8 70 47 80 00 00 	movabs $0x804770,%rax
  8007ab:	00 00 00 
  8007ae:	48 01 d0             	add    %rdx,%rax
  8007b1:	48 8b 00             	mov    (%rax),%rax
  8007b4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007ba:	eb c1                	jmp    80077d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007c0:	eb bb                	jmp    80077d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007c9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007cc:	89 d0                	mov    %edx,%eax
  8007ce:	c1 e0 02             	shl    $0x2,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	01 c0                	add    %eax,%eax
  8007d5:	01 d8                	add    %ebx,%eax
  8007d7:	83 e8 30             	sub    $0x30,%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007dd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007e1:	0f b6 00             	movzbl (%rax),%eax
  8007e4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ea:	7e 63                	jle    80084f <vprintfmt+0x163>
  8007ec:	83 fb 39             	cmp    $0x39,%ebx
  8007ef:	7f 5e                	jg     80084f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f6:	eb d1                	jmp    8007c9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fb:	83 f8 30             	cmp    $0x30,%eax
  8007fe:	73 17                	jae    800817 <vprintfmt+0x12b>
  800800:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800804:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800807:	89 c0                	mov    %eax,%eax
  800809:	48 01 d0             	add    %rdx,%rax
  80080c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080f:	83 c2 08             	add    $0x8,%edx
  800812:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800815:	eb 0f                	jmp    800826 <vprintfmt+0x13a>
  800817:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081b:	48 89 d0             	mov    %rdx,%rax
  80081e:	48 83 c2 08          	add    $0x8,%rdx
  800822:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800826:	8b 00                	mov    (%rax),%eax
  800828:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80082b:	eb 23                	jmp    800850 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80082d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800831:	0f 89 42 ff ff ff    	jns    800779 <vprintfmt+0x8d>
				width = 0;
  800837:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80083e:	e9 36 ff ff ff       	jmpq   800779 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800843:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80084a:	e9 2e ff ff ff       	jmpq   80077d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80084f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800850:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800854:	0f 89 22 ff ff ff    	jns    80077c <vprintfmt+0x90>
				width = precision, precision = -1;
  80085a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80085d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800860:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800867:	e9 10 ff ff ff       	jmpq   80077c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800870:	e9 08 ff ff ff       	jmpq   80077d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800875:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800878:	83 f8 30             	cmp    $0x30,%eax
  80087b:	73 17                	jae    800894 <vprintfmt+0x1a8>
  80087d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800881:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800884:	89 c0                	mov    %eax,%eax
  800886:	48 01 d0             	add    %rdx,%rax
  800889:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088c:	83 c2 08             	add    $0x8,%edx
  80088f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800892:	eb 0f                	jmp    8008a3 <vprintfmt+0x1b7>
  800894:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 83 c2 08          	add    $0x8,%rdx
  80089f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008a9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8008ad:	48 89 d6             	mov    %rdx,%rsi
  8008b0:	89 c7                	mov    %eax,%edi
  8008b2:	ff d1                	callq  *%rcx
			break;
  8008b4:	e9 47 03 00 00       	jmpq   800c00 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8008b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bc:	83 f8 30             	cmp    $0x30,%eax
  8008bf:	73 17                	jae    8008d8 <vprintfmt+0x1ec>
  8008c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c8:	89 c0                	mov    %eax,%eax
  8008ca:	48 01 d0             	add    %rdx,%rax
  8008cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d6:	eb 0f                	jmp    8008e7 <vprintfmt+0x1fb>
  8008d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 83 c2 08          	add    $0x8,%rdx
  8008e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008e9:	85 db                	test   %ebx,%ebx
  8008eb:	79 02                	jns    8008ef <vprintfmt+0x203>
				err = -err;
  8008ed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ef:	83 fb 10             	cmp    $0x10,%ebx
  8008f2:	7f 16                	jg     80090a <vprintfmt+0x21e>
  8008f4:	48 b8 c0 46 80 00 00 	movabs $0x8046c0,%rax
  8008fb:	00 00 00 
  8008fe:	48 63 d3             	movslq %ebx,%rdx
  800901:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800905:	4d 85 e4             	test   %r12,%r12
  800908:	75 2e                	jne    800938 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80090a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80090e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800912:	89 d9                	mov    %ebx,%ecx
  800914:	48 ba 59 47 80 00 00 	movabs $0x804759,%rdx
  80091b:	00 00 00 
  80091e:	48 89 c7             	mov    %rax,%rdi
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	49 b8 10 0c 80 00 00 	movabs $0x800c10,%r8
  80092d:	00 00 00 
  800930:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800933:	e9 c8 02 00 00       	jmpq   800c00 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800938:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80093c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800940:	4c 89 e1             	mov    %r12,%rcx
  800943:	48 ba 62 47 80 00 00 	movabs $0x804762,%rdx
  80094a:	00 00 00 
  80094d:	48 89 c7             	mov    %rax,%rdi
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
  800955:	49 b8 10 0c 80 00 00 	movabs $0x800c10,%r8
  80095c:	00 00 00 
  80095f:	41 ff d0             	callq  *%r8
			break;
  800962:	e9 99 02 00 00       	jmpq   800c00 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800967:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096a:	83 f8 30             	cmp    $0x30,%eax
  80096d:	73 17                	jae    800986 <vprintfmt+0x29a>
  80096f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	89 c0                	mov    %eax,%eax
  800978:	48 01 d0             	add    %rdx,%rax
  80097b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097e:	83 c2 08             	add    $0x8,%edx
  800981:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800984:	eb 0f                	jmp    800995 <vprintfmt+0x2a9>
  800986:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098a:	48 89 d0             	mov    %rdx,%rax
  80098d:	48 83 c2 08          	add    $0x8,%rdx
  800991:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800995:	4c 8b 20             	mov    (%rax),%r12
  800998:	4d 85 e4             	test   %r12,%r12
  80099b:	75 0a                	jne    8009a7 <vprintfmt+0x2bb>
				p = "(null)";
  80099d:	49 bc 65 47 80 00 00 	movabs $0x804765,%r12
  8009a4:	00 00 00 
			if (width > 0 && padc != '-')
  8009a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ab:	7e 7a                	jle    800a27 <vprintfmt+0x33b>
  8009ad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009b1:	74 74                	je     800a27 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b6:	48 98                	cltq   
  8009b8:	48 89 c6             	mov    %rax,%rsi
  8009bb:	4c 89 e7             	mov    %r12,%rdi
  8009be:	48 b8 ba 0e 80 00 00 	movabs $0x800eba,%rax
  8009c5:	00 00 00 
  8009c8:	ff d0                	callq  *%rax
  8009ca:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009cd:	eb 17                	jmp    8009e6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8009cf:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8009d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009d7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009db:	48 89 d6             	mov    %rdx,%rsi
  8009de:	89 c7                	mov    %eax,%edi
  8009e0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ea:	7f e3                	jg     8009cf <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ec:	eb 39                	jmp    800a27 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009f2:	74 1e                	je     800a12 <vprintfmt+0x326>
  8009f4:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f7:	7e 05                	jle    8009fe <vprintfmt+0x312>
  8009f9:	83 fb 7e             	cmp    $0x7e,%ebx
  8009fc:	7e 14                	jle    800a12 <vprintfmt+0x326>
					putch('?', putdat);
  8009fe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a02:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a06:	48 89 c6             	mov    %rax,%rsi
  800a09:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a0e:	ff d2                	callq  *%rdx
  800a10:	eb 0f                	jmp    800a21 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800a12:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a16:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a1a:	48 89 c6             	mov    %rax,%rsi
  800a1d:	89 df                	mov    %ebx,%edi
  800a1f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a25:	eb 01                	jmp    800a28 <vprintfmt+0x33c>
  800a27:	90                   	nop
  800a28:	41 0f b6 04 24       	movzbl (%r12),%eax
  800a2d:	0f be d8             	movsbl %al,%ebx
  800a30:	85 db                	test   %ebx,%ebx
  800a32:	0f 95 c0             	setne  %al
  800a35:	49 83 c4 01          	add    $0x1,%r12
  800a39:	84 c0                	test   %al,%al
  800a3b:	74 28                	je     800a65 <vprintfmt+0x379>
  800a3d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a41:	78 ab                	js     8009ee <vprintfmt+0x302>
  800a43:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a47:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a4b:	79 a1                	jns    8009ee <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4d:	eb 16                	jmp    800a65 <vprintfmt+0x379>
				putch(' ', putdat);
  800a4f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a53:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a57:	48 89 c6             	mov    %rax,%rsi
  800a5a:	bf 20 00 00 00       	mov    $0x20,%edi
  800a5f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a65:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a69:	7f e4                	jg     800a4f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800a6b:	e9 90 01 00 00       	jmpq   800c00 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a74:	be 03 00 00 00       	mov    $0x3,%esi
  800a79:	48 89 c7             	mov    %rax,%rdi
  800a7c:	48 b8 dc 05 80 00 00 	movabs $0x8005dc,%rax
  800a83:	00 00 00 
  800a86:	ff d0                	callq  *%rax
  800a88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a90:	48 85 c0             	test   %rax,%rax
  800a93:	79 1d                	jns    800ab2 <vprintfmt+0x3c6>
				putch('-', putdat);
  800a95:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a99:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a9d:	48 89 c6             	mov    %rax,%rsi
  800aa0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800aa5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aab:	48 f7 d8             	neg    %rax
  800aae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ab2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab9:	e9 d5 00 00 00       	jmpq   800b93 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800abe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac2:	be 03 00 00 00       	mov    $0x3,%esi
  800ac7:	48 89 c7             	mov    %rax,%rdi
  800aca:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  800ad1:	00 00 00 
  800ad4:	ff d0                	callq  *%rax
  800ad6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ada:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ae1:	e9 ad 00 00 00       	jmpq   800b93 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800ae6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aea:	be 03 00 00 00       	mov    $0x3,%esi
  800aef:	48 89 c7             	mov    %rax,%rdi
  800af2:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  800af9:	00 00 00 
  800afc:	ff d0                	callq  *%rax
  800afe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800b02:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b09:	e9 85 00 00 00       	jmpq   800b93 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800b0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b16:	48 89 c6             	mov    %rax,%rsi
  800b19:	bf 30 00 00 00       	mov    $0x30,%edi
  800b1e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800b20:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b24:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b28:	48 89 c6             	mov    %rax,%rsi
  800b2b:	bf 78 00 00 00       	mov    $0x78,%edi
  800b30:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b32:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b35:	83 f8 30             	cmp    $0x30,%eax
  800b38:	73 17                	jae    800b51 <vprintfmt+0x465>
  800b3a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b3e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b41:	89 c0                	mov    %eax,%eax
  800b43:	48 01 d0             	add    %rdx,%rax
  800b46:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b49:	83 c2 08             	add    $0x8,%edx
  800b4c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	eb 0f                	jmp    800b60 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800b51:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b55:	48 89 d0             	mov    %rdx,%rax
  800b58:	48 83 c2 08          	add    $0x8,%rdx
  800b5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b60:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b6e:	eb 23                	jmp    800b93 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b74:	be 03 00 00 00       	mov    $0x3,%esi
  800b79:	48 89 c7             	mov    %rax,%rdi
  800b7c:	48 b8 cc 04 80 00 00 	movabs $0x8004cc,%rax
  800b83:	00 00 00 
  800b86:	ff d0                	callq  *%rax
  800b88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b93:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b9b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ba6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800baa:	45 89 c1             	mov    %r8d,%r9d
  800bad:	41 89 f8             	mov    %edi,%r8d
  800bb0:	48 89 c7             	mov    %rax,%rdi
  800bb3:	48 b8 14 04 80 00 00 	movabs $0x800414,%rax
  800bba:	00 00 00 
  800bbd:	ff d0                	callq  *%rax
			break;
  800bbf:	eb 3f                	jmp    800c00 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bc5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bc9:	48 89 c6             	mov    %rax,%rsi
  800bcc:	89 df                	mov    %ebx,%edi
  800bce:	ff d2                	callq  *%rdx
			break;
  800bd0:	eb 2e                	jmp    800c00 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bda:	48 89 c6             	mov    %rax,%rsi
  800bdd:	bf 25 00 00 00       	mov    $0x25,%edi
  800be2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be9:	eb 05                	jmp    800bf0 <vprintfmt+0x504>
  800beb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bf0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf4:	48 83 e8 01          	sub    $0x1,%rax
  800bf8:	0f b6 00             	movzbl (%rax),%eax
  800bfb:	3c 25                	cmp    $0x25,%al
  800bfd:	75 ec                	jne    800beb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800bff:	90                   	nop
		}
	}
  800c00:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c01:	e9 38 fb ff ff       	jmpq   80073e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800c06:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800c07:	48 83 c4 60          	add    $0x60,%rsp
  800c0b:	5b                   	pop    %rbx
  800c0c:	41 5c                	pop    %r12
  800c0e:	5d                   	pop    %rbp
  800c0f:	c3                   	retq   

0000000000800c10 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c10:	55                   	push   %rbp
  800c11:	48 89 e5             	mov    %rsp,%rbp
  800c14:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c1b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c22:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c29:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c30:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c37:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c3e:	84 c0                	test   %al,%al
  800c40:	74 20                	je     800c62 <printfmt+0x52>
  800c42:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c46:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c4a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c4e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c52:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c56:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c5a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c5e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c62:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c69:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c70:	00 00 00 
  800c73:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c7a:	00 00 00 
  800c7d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c81:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c88:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c8f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c96:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c9d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ca4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cb2:	48 89 c7             	mov    %rax,%rdi
  800cb5:	48 b8 ec 06 80 00 00 	movabs $0x8006ec,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cc1:	c9                   	leaveq 
  800cc2:	c3                   	retq   

0000000000800cc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc3:	55                   	push   %rbp
  800cc4:	48 89 e5             	mov    %rsp,%rbp
  800cc7:	48 83 ec 10          	sub    $0x10,%rsp
  800ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd6:	8b 40 10             	mov    0x10(%rax),%eax
  800cd9:	8d 50 01             	lea    0x1(%rax),%edx
  800cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce7:	48 8b 10             	mov    (%rax),%rdx
  800cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cee:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cf2:	48 39 c2             	cmp    %rax,%rdx
  800cf5:	73 17                	jae    800d0e <sprintputch+0x4b>
		*b->buf++ = ch;
  800cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cfb:	48 8b 00             	mov    (%rax),%rax
  800cfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d01:	88 10                	mov    %dl,(%rax)
  800d03:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d0b:	48 89 10             	mov    %rdx,(%rax)
}
  800d0e:	c9                   	leaveq 
  800d0f:	c3                   	retq   

0000000000800d10 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d10:	55                   	push   %rbp
  800d11:	48 89 e5             	mov    %rsp,%rbp
  800d14:	48 83 ec 50          	sub    $0x50,%rsp
  800d18:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d1c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d1f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d23:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d27:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d2b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d2f:	48 8b 0a             	mov    (%rdx),%rcx
  800d32:	48 89 08             	mov    %rcx,(%rax)
  800d35:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d39:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d3d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d41:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d45:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d49:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d4d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d50:	48 98                	cltq   
  800d52:	48 83 e8 01          	sub    $0x1,%rax
  800d56:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800d5a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d65:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d6a:	74 06                	je     800d72 <vsnprintf+0x62>
  800d6c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d70:	7f 07                	jg     800d79 <vsnprintf+0x69>
		return -E_INVAL;
  800d72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d77:	eb 2f                	jmp    800da8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d79:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d7d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d81:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d85:	48 89 c6             	mov    %rax,%rsi
  800d88:	48 bf c3 0c 80 00 00 	movabs $0x800cc3,%rdi
  800d8f:	00 00 00 
  800d92:	48 b8 ec 06 80 00 00 	movabs $0x8006ec,%rax
  800d99:	00 00 00 
  800d9c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800da2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800da5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800da8:	c9                   	leaveq 
  800da9:	c3                   	retq   

0000000000800daa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800daa:	55                   	push   %rbp
  800dab:	48 89 e5             	mov    %rsp,%rbp
  800dae:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800db5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800dbc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800dc2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dc9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dd7:	84 c0                	test   %al,%al
  800dd9:	74 20                	je     800dfb <snprintf+0x51>
  800ddb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ddf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800de3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800de7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800deb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800def:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800df3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800df7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dfb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e02:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e09:	00 00 00 
  800e0c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e13:	00 00 00 
  800e16:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e1a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e21:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e28:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e2f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e36:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e3d:	48 8b 0a             	mov    (%rdx),%rcx
  800e40:	48 89 08             	mov    %rcx,(%rax)
  800e43:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e47:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e4b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e4f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e53:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e5a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e61:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e67:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e6e:	48 89 c7             	mov    %rax,%rdi
  800e71:	48 b8 10 0d 80 00 00 	movabs $0x800d10,%rax
  800e78:	00 00 00 
  800e7b:	ff d0                	callq  *%rax
  800e7d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e83:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e89:	c9                   	leaveq 
  800e8a:	c3                   	retq   
	...

0000000000800e8c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e8c:	55                   	push   %rbp
  800e8d:	48 89 e5             	mov    %rsp,%rbp
  800e90:	48 83 ec 18          	sub    $0x18,%rsp
  800e94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e9f:	eb 09                	jmp    800eaa <strlen+0x1e>
		n++;
  800ea1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eae:	0f b6 00             	movzbl (%rax),%eax
  800eb1:	84 c0                	test   %al,%al
  800eb3:	75 ec                	jne    800ea1 <strlen+0x15>
		n++;
	return n;
  800eb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eb8:	c9                   	leaveq 
  800eb9:	c3                   	retq   

0000000000800eba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eba:	55                   	push   %rbp
  800ebb:	48 89 e5             	mov    %rsp,%rbp
  800ebe:	48 83 ec 20          	sub    $0x20,%rsp
  800ec2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ed1:	eb 0e                	jmp    800ee1 <strnlen+0x27>
		n++;
  800ed3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800edc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ee1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ee6:	74 0b                	je     800ef3 <strnlen+0x39>
  800ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eec:	0f b6 00             	movzbl (%rax),%eax
  800eef:	84 c0                	test   %al,%al
  800ef1:	75 e0                	jne    800ed3 <strnlen+0x19>
		n++;
	return n;
  800ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ef6:	c9                   	leaveq 
  800ef7:	c3                   	retq   

0000000000800ef8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef8:	55                   	push   %rbp
  800ef9:	48 89 e5             	mov    %rsp,%rbp
  800efc:	48 83 ec 20          	sub    $0x20,%rsp
  800f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f10:	90                   	nop
  800f11:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f15:	0f b6 10             	movzbl (%rax),%edx
  800f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1c:	88 10                	mov    %dl,(%rax)
  800f1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f22:	0f b6 00             	movzbl (%rax),%eax
  800f25:	84 c0                	test   %al,%al
  800f27:	0f 95 c0             	setne  %al
  800f2a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f2f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800f34:	84 c0                	test   %al,%al
  800f36:	75 d9                	jne    800f11 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f3c:	c9                   	leaveq 
  800f3d:	c3                   	retq   

0000000000800f3e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f3e:	55                   	push   %rbp
  800f3f:	48 89 e5             	mov    %rsp,%rbp
  800f42:	48 83 ec 20          	sub    $0x20,%rsp
  800f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	48 89 c7             	mov    %rax,%rdi
  800f55:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  800f5c:	00 00 00 
  800f5f:	ff d0                	callq  *%rax
  800f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f67:	48 98                	cltq   
  800f69:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800f6d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f71:	48 89 d6             	mov    %rdx,%rsi
  800f74:	48 89 c7             	mov    %rax,%rdi
  800f77:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  800f7e:	00 00 00 
  800f81:	ff d0                	callq  *%rax
	return dst;
  800f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f87:	c9                   	leaveq 
  800f88:	c3                   	retq   

0000000000800f89 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f89:	55                   	push   %rbp
  800f8a:	48 89 e5             	mov    %rsp,%rbp
  800f8d:	48 83 ec 28          	sub    $0x28,%rsp
  800f91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f95:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f99:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fa5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fac:	00 
  800fad:	eb 27                	jmp    800fd6 <strncpy+0x4d>
		*dst++ = *src;
  800faf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fb3:	0f b6 10             	movzbl (%rax),%edx
  800fb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fba:	88 10                	mov    %dl,(%rax)
  800fbc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc5:	0f b6 00             	movzbl (%rax),%eax
  800fc8:	84 c0                	test   %al,%al
  800fca:	74 05                	je     800fd1 <strncpy+0x48>
			src++;
  800fcc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fd1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fda:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fde:	72 cf                	jb     800faf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fe4:	c9                   	leaveq 
  800fe5:	c3                   	retq   

0000000000800fe6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fe6:	55                   	push   %rbp
  800fe7:	48 89 e5             	mov    %rsp,%rbp
  800fea:	48 83 ec 28          	sub    $0x28,%rsp
  800fee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ff6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801002:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801007:	74 37                	je     801040 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801009:	eb 17                	jmp    801022 <strlcpy+0x3c>
			*dst++ = *src++;
  80100b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80100f:	0f b6 10             	movzbl (%rax),%edx
  801012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801016:	88 10                	mov    %dl,(%rax)
  801018:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80101d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801022:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801027:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80102c:	74 0b                	je     801039 <strlcpy+0x53>
  80102e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801032:	0f b6 00             	movzbl (%rax),%eax
  801035:	84 c0                	test   %al,%al
  801037:	75 d2                	jne    80100b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801040:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801048:	48 89 d1             	mov    %rdx,%rcx
  80104b:	48 29 c1             	sub    %rax,%rcx
  80104e:	48 89 c8             	mov    %rcx,%rax
}
  801051:	c9                   	leaveq 
  801052:	c3                   	retq   

0000000000801053 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801053:	55                   	push   %rbp
  801054:	48 89 e5             	mov    %rsp,%rbp
  801057:	48 83 ec 10          	sub    $0x10,%rsp
  80105b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801063:	eb 0a                	jmp    80106f <strcmp+0x1c>
		p++, q++;
  801065:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	84 c0                	test   %al,%al
  801078:	74 12                	je     80108c <strcmp+0x39>
  80107a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107e:	0f b6 10             	movzbl (%rax),%edx
  801081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801085:	0f b6 00             	movzbl (%rax),%eax
  801088:	38 c2                	cmp    %al,%dl
  80108a:	74 d9                	je     801065 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80108c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801090:	0f b6 00             	movzbl (%rax),%eax
  801093:	0f b6 d0             	movzbl %al,%edx
  801096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109a:	0f b6 00             	movzbl (%rax),%eax
  80109d:	0f b6 c0             	movzbl %al,%eax
  8010a0:	89 d1                	mov    %edx,%ecx
  8010a2:	29 c1                	sub    %eax,%ecx
  8010a4:	89 c8                	mov    %ecx,%eax
}
  8010a6:	c9                   	leaveq 
  8010a7:	c3                   	retq   

00000000008010a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010a8:	55                   	push   %rbp
  8010a9:	48 89 e5             	mov    %rsp,%rbp
  8010ac:	48 83 ec 18          	sub    $0x18,%rsp
  8010b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010bc:	eb 0f                	jmp    8010cd <strncmp+0x25>
		n--, p++, q++;
  8010be:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d2:	74 1d                	je     8010f1 <strncmp+0x49>
  8010d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d8:	0f b6 00             	movzbl (%rax),%eax
  8010db:	84 c0                	test   %al,%al
  8010dd:	74 12                	je     8010f1 <strncmp+0x49>
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e3:	0f b6 10             	movzbl (%rax),%edx
  8010e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ea:	0f b6 00             	movzbl (%rax),%eax
  8010ed:	38 c2                	cmp    %al,%dl
  8010ef:	74 cd                	je     8010be <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f6:	75 07                	jne    8010ff <strncmp+0x57>
		return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	eb 1a                	jmp    801119 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801103:	0f b6 00             	movzbl (%rax),%eax
  801106:	0f b6 d0             	movzbl %al,%edx
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110d:	0f b6 00             	movzbl (%rax),%eax
  801110:	0f b6 c0             	movzbl %al,%eax
  801113:	89 d1                	mov    %edx,%ecx
  801115:	29 c1                	sub    %eax,%ecx
  801117:	89 c8                	mov    %ecx,%eax
}
  801119:	c9                   	leaveq 
  80111a:	c3                   	retq   

000000000080111b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80111b:	55                   	push   %rbp
  80111c:	48 89 e5             	mov    %rsp,%rbp
  80111f:	48 83 ec 10          	sub    $0x10,%rsp
  801123:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801127:	89 f0                	mov    %esi,%eax
  801129:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80112c:	eb 17                	jmp    801145 <strchr+0x2a>
		if (*s == c)
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801132:	0f b6 00             	movzbl (%rax),%eax
  801135:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801138:	75 06                	jne    801140 <strchr+0x25>
			return (char *) s;
  80113a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113e:	eb 15                	jmp    801155 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801140:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801145:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801149:	0f b6 00             	movzbl (%rax),%eax
  80114c:	84 c0                	test   %al,%al
  80114e:	75 de                	jne    80112e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801155:	c9                   	leaveq 
  801156:	c3                   	retq   

0000000000801157 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801157:	55                   	push   %rbp
  801158:	48 89 e5             	mov    %rsp,%rbp
  80115b:	48 83 ec 10          	sub    $0x10,%rsp
  80115f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801163:	89 f0                	mov    %esi,%eax
  801165:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801168:	eb 11                	jmp    80117b <strfind+0x24>
		if (*s == c)
  80116a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116e:	0f b6 00             	movzbl (%rax),%eax
  801171:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801174:	74 12                	je     801188 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801176:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117f:	0f b6 00             	movzbl (%rax),%eax
  801182:	84 c0                	test   %al,%al
  801184:	75 e4                	jne    80116a <strfind+0x13>
  801186:	eb 01                	jmp    801189 <strfind+0x32>
		if (*s == c)
			break;
  801188:	90                   	nop
	return (char *) s;
  801189:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   

000000000080118f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80118f:	55                   	push   %rbp
  801190:	48 89 e5             	mov    %rsp,%rbp
  801193:	48 83 ec 18          	sub    $0x18,%rsp
  801197:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80119b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80119e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a7:	75 06                	jne    8011af <memset+0x20>
		return v;
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ad:	eb 69                	jmp    801218 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b3:	83 e0 03             	and    $0x3,%eax
  8011b6:	48 85 c0             	test   %rax,%rax
  8011b9:	75 48                	jne    801203 <memset+0x74>
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	83 e0 03             	and    $0x3,%eax
  8011c2:	48 85 c0             	test   %rax,%rax
  8011c5:	75 3c                	jne    801203 <memset+0x74>
		c &= 0xFF;
  8011c7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d1:	89 c2                	mov    %eax,%edx
  8011d3:	c1 e2 18             	shl    $0x18,%edx
  8011d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d9:	c1 e0 10             	shl    $0x10,%eax
  8011dc:	09 c2                	or     %eax,%edx
  8011de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e1:	c1 e0 08             	shl    $0x8,%eax
  8011e4:	09 d0                	or     %edx,%eax
  8011e6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ed:	48 89 c1             	mov    %rax,%rcx
  8011f0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011fb:	48 89 d7             	mov    %rdx,%rdi
  8011fe:	fc                   	cld    
  8011ff:	f3 ab                	rep stos %eax,%es:(%rdi)
  801201:	eb 11                	jmp    801214 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801203:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801207:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80120a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80120e:	48 89 d7             	mov    %rdx,%rdi
  801211:	fc                   	cld    
  801212:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801214:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 28          	sub    $0x28,%rsp
  801222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801226:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80122a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80122e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801232:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80123e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801242:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801246:	0f 83 88 00 00 00    	jae    8012d4 <memmove+0xba>
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801254:	48 01 d0             	add    %rdx,%rax
  801257:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80125b:	76 77                	jbe    8012d4 <memmove+0xba>
		s += n;
  80125d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801261:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801265:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801269:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80126d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801271:	83 e0 03             	and    $0x3,%eax
  801274:	48 85 c0             	test   %rax,%rax
  801277:	75 3b                	jne    8012b4 <memmove+0x9a>
  801279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127d:	83 e0 03             	and    $0x3,%eax
  801280:	48 85 c0             	test   %rax,%rax
  801283:	75 2f                	jne    8012b4 <memmove+0x9a>
  801285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801289:	83 e0 03             	and    $0x3,%eax
  80128c:	48 85 c0             	test   %rax,%rax
  80128f:	75 23                	jne    8012b4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801295:	48 83 e8 04          	sub    $0x4,%rax
  801299:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129d:	48 83 ea 04          	sub    $0x4,%rdx
  8012a1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012a5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012a9:	48 89 c7             	mov    %rax,%rdi
  8012ac:	48 89 d6             	mov    %rdx,%rsi
  8012af:	fd                   	std    
  8012b0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012b2:	eb 1d                	jmp    8012d1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c8:	48 89 d7             	mov    %rdx,%rdi
  8012cb:	48 89 c1             	mov    %rax,%rcx
  8012ce:	fd                   	std    
  8012cf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012d1:	fc                   	cld    
  8012d2:	eb 57                	jmp    80132b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	83 e0 03             	and    $0x3,%eax
  8012db:	48 85 c0             	test   %rax,%rax
  8012de:	75 36                	jne    801316 <memmove+0xfc>
  8012e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e4:	83 e0 03             	and    $0x3,%eax
  8012e7:	48 85 c0             	test   %rax,%rax
  8012ea:	75 2a                	jne    801316 <memmove+0xfc>
  8012ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f0:	83 e0 03             	and    $0x3,%eax
  8012f3:	48 85 c0             	test   %rax,%rax
  8012f6:	75 1e                	jne    801316 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fc:	48 89 c1             	mov    %rax,%rcx
  8012ff:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801303:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801307:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80130b:	48 89 c7             	mov    %rax,%rdi
  80130e:	48 89 d6             	mov    %rdx,%rsi
  801311:	fc                   	cld    
  801312:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801314:	eb 15                	jmp    80132b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801316:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801322:	48 89 c7             	mov    %rax,%rdi
  801325:	48 89 d6             	mov    %rdx,%rsi
  801328:	fc                   	cld    
  801329:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80132f:	c9                   	leaveq 
  801330:	c3                   	retq   

0000000000801331 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801331:	55                   	push   %rbp
  801332:	48 89 e5             	mov    %rsp,%rbp
  801335:	48 83 ec 18          	sub    $0x18,%rsp
  801339:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801341:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801345:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801349:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	48 89 ce             	mov    %rcx,%rsi
  801354:	48 89 c7             	mov    %rax,%rdi
  801357:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  80135e:	00 00 00 
  801361:	ff d0                	callq  *%rax
}
  801363:	c9                   	leaveq 
  801364:	c3                   	retq   

0000000000801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801365:	55                   	push   %rbp
  801366:	48 89 e5             	mov    %rsp,%rbp
  801369:	48 83 ec 28          	sub    $0x28,%rsp
  80136d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801371:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801375:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801379:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80137d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801381:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801385:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801389:	eb 38                	jmp    8013c3 <memcmp+0x5e>
		if (*s1 != *s2)
  80138b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138f:	0f b6 10             	movzbl (%rax),%edx
  801392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	38 c2                	cmp    %al,%dl
  80139b:	74 1c                	je     8013b9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a1:	0f b6 00             	movzbl (%rax),%eax
  8013a4:	0f b6 d0             	movzbl %al,%edx
  8013a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	0f b6 c0             	movzbl %al,%eax
  8013b1:	89 d1                	mov    %edx,%ecx
  8013b3:	29 c1                	sub    %eax,%ecx
  8013b5:	89 c8                	mov    %ecx,%eax
  8013b7:	eb 20                	jmp    8013d9 <memcmp+0x74>
		s1++, s2++;
  8013b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c8:	0f 95 c0             	setne  %al
  8013cb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013d0:	84 c0                	test   %al,%al
  8013d2:	75 b7                	jne    80138b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d9:	c9                   	leaveq 
  8013da:	c3                   	retq   

00000000008013db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013db:	55                   	push   %rbp
  8013dc:	48 89 e5             	mov    %rsp,%rbp
  8013df:	48 83 ec 28          	sub    $0x28,%rsp
  8013e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013f6:	48 01 d0             	add    %rdx,%rax
  8013f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013fd:	eb 13                	jmp    801412 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801403:	0f b6 10             	movzbl (%rax),%edx
  801406:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801409:	38 c2                	cmp    %al,%dl
  80140b:	74 11                	je     80141e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80140d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801416:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80141a:	72 e3                	jb     8013ff <memfind+0x24>
  80141c:	eb 01                	jmp    80141f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80141e:	90                   	nop
	return (void *) s;
  80141f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801423:	c9                   	leaveq 
  801424:	c3                   	retq   

0000000000801425 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801425:	55                   	push   %rbp
  801426:	48 89 e5             	mov    %rsp,%rbp
  801429:	48 83 ec 38          	sub    $0x38,%rsp
  80142d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801431:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801435:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801438:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80143f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801446:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801447:	eb 05                	jmp    80144e <strtol+0x29>
		s++;
  801449:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801452:	0f b6 00             	movzbl (%rax),%eax
  801455:	3c 20                	cmp    $0x20,%al
  801457:	74 f0                	je     801449 <strtol+0x24>
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 09                	cmp    $0x9,%al
  801462:	74 e5                	je     801449 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	0f b6 00             	movzbl (%rax),%eax
  80146b:	3c 2b                	cmp    $0x2b,%al
  80146d:	75 07                	jne    801476 <strtol+0x51>
		s++;
  80146f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801474:	eb 17                	jmp    80148d <strtol+0x68>
	else if (*s == '-')
  801476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	3c 2d                	cmp    $0x2d,%al
  80147f:	75 0c                	jne    80148d <strtol+0x68>
		s++, neg = 1;
  801481:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801486:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80148d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801491:	74 06                	je     801499 <strtol+0x74>
  801493:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801497:	75 28                	jne    8014c1 <strtol+0x9c>
  801499:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149d:	0f b6 00             	movzbl (%rax),%eax
  8014a0:	3c 30                	cmp    $0x30,%al
  8014a2:	75 1d                	jne    8014c1 <strtol+0x9c>
  8014a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a8:	48 83 c0 01          	add    $0x1,%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	3c 78                	cmp    $0x78,%al
  8014b1:	75 0e                	jne    8014c1 <strtol+0x9c>
		s += 2, base = 16;
  8014b3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014b8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014bf:	eb 2c                	jmp    8014ed <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c5:	75 19                	jne    8014e0 <strtol+0xbb>
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	3c 30                	cmp    $0x30,%al
  8014d0:	75 0e                	jne    8014e0 <strtol+0xbb>
		s++, base = 8;
  8014d2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014de:	eb 0d                	jmp    8014ed <strtol+0xc8>
	else if (base == 0)
  8014e0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014e4:	75 07                	jne    8014ed <strtol+0xc8>
		base = 10;
  8014e6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	3c 2f                	cmp    $0x2f,%al
  8014f6:	7e 1d                	jle    801515 <strtol+0xf0>
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 39                	cmp    $0x39,%al
  801501:	7f 12                	jg     801515 <strtol+0xf0>
			dig = *s - '0';
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 30             	sub    $0x30,%eax
  801510:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801513:	eb 4e                	jmp    801563 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801515:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801519:	0f b6 00             	movzbl (%rax),%eax
  80151c:	3c 60                	cmp    $0x60,%al
  80151e:	7e 1d                	jle    80153d <strtol+0x118>
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	3c 7a                	cmp    $0x7a,%al
  801529:	7f 12                	jg     80153d <strtol+0x118>
			dig = *s - 'a' + 10;
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	0f be c0             	movsbl %al,%eax
  801535:	83 e8 57             	sub    $0x57,%eax
  801538:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80153b:	eb 26                	jmp    801563 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80153d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801541:	0f b6 00             	movzbl (%rax),%eax
  801544:	3c 40                	cmp    $0x40,%al
  801546:	7e 47                	jle    80158f <strtol+0x16a>
  801548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	3c 5a                	cmp    $0x5a,%al
  801551:	7f 3c                	jg     80158f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801553:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801557:	0f b6 00             	movzbl (%rax),%eax
  80155a:	0f be c0             	movsbl %al,%eax
  80155d:	83 e8 37             	sub    $0x37,%eax
  801560:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801563:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801566:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801569:	7d 23                	jge    80158e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80156b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801570:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801573:	48 98                	cltq   
  801575:	48 89 c2             	mov    %rax,%rdx
  801578:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80157d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801580:	48 98                	cltq   
  801582:	48 01 d0             	add    %rdx,%rax
  801585:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801589:	e9 5f ff ff ff       	jmpq   8014ed <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80158e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80158f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801594:	74 0b                	je     8015a1 <strtol+0x17c>
		*endptr = (char *) s;
  801596:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80159e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015a5:	74 09                	je     8015b0 <strtol+0x18b>
  8015a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015ab:	48 f7 d8             	neg    %rax
  8015ae:	eb 04                	jmp    8015b4 <strtol+0x18f>
  8015b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015b4:	c9                   	leaveq 
  8015b5:	c3                   	retq   

00000000008015b6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015b6:	55                   	push   %rbp
  8015b7:	48 89 e5             	mov    %rsp,%rbp
  8015ba:	48 83 ec 30          	sub    $0x30,%rsp
  8015be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8015c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	88 45 ff             	mov    %al,-0x1(%rbp)
  8015d0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8015d5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015d9:	75 06                	jne    8015e1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	eb 68                	jmp    801649 <strstr+0x93>

    len = strlen(str);
  8015e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e5:	48 89 c7             	mov    %rax,%rdi
  8015e8:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  8015ef:	00 00 00 
  8015f2:	ff d0                	callq  *%rax
  8015f4:	48 98                	cltq   
  8015f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	0f b6 00             	movzbl (%rax),%eax
  801601:	88 45 ef             	mov    %al,-0x11(%rbp)
  801604:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801609:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80160d:	75 07                	jne    801616 <strstr+0x60>
                return (char *) 0;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	eb 33                	jmp    801649 <strstr+0x93>
        } while (sc != c);
  801616:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80161a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80161d:	75 db                	jne    8015fa <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80161f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801623:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162b:	48 89 ce             	mov    %rcx,%rsi
  80162e:	48 89 c7             	mov    %rax,%rdi
  801631:	48 b8 a8 10 80 00 00 	movabs $0x8010a8,%rax
  801638:	00 00 00 
  80163b:	ff d0                	callq  *%rax
  80163d:	85 c0                	test   %eax,%eax
  80163f:	75 b9                	jne    8015fa <strstr+0x44>

    return (char *) (in - 1);
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	48 83 e8 01          	sub    $0x1,%rax
}
  801649:	c9                   	leaveq 
  80164a:	c3                   	retq   
	...

000000000080164c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80164c:	55                   	push   %rbp
  80164d:	48 89 e5             	mov    %rsp,%rbp
  801650:	53                   	push   %rbx
  801651:	48 83 ec 58          	sub    $0x58,%rsp
  801655:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801658:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80165b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80165f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801663:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801667:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801671:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801675:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801679:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80167d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801681:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801685:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801688:	4c 89 c3             	mov    %r8,%rbx
  80168b:	cd 30                	int    $0x30
  80168d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801691:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801695:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801699:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80169d:	74 3e                	je     8016dd <syscall+0x91>
  80169f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016a4:	7e 37                	jle    8016dd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016ad:	49 89 d0             	mov    %rdx,%r8
  8016b0:	89 c1                	mov    %eax,%ecx
  8016b2:	48 ba 20 4a 80 00 00 	movabs $0x804a20,%rdx
  8016b9:	00 00 00 
  8016bc:	be 23 00 00 00       	mov    $0x23,%esi
  8016c1:	48 bf 3d 4a 80 00 00 	movabs $0x804a3d,%rdi
  8016c8:	00 00 00 
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	49 b9 c4 3f 80 00 00 	movabs $0x803fc4,%r9
  8016d7:	00 00 00 
  8016da:	41 ff d1             	callq  *%r9

	return ret;
  8016dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016e1:	48 83 c4 58          	add    $0x58,%rsp
  8016e5:	5b                   	pop    %rbx
  8016e6:	5d                   	pop    %rbp
  8016e7:	c3                   	retq   

00000000008016e8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016e8:	55                   	push   %rbp
  8016e9:	48 89 e5             	mov    %rsp,%rbp
  8016ec:	48 83 ec 20          	sub    $0x20,%rsp
  8016f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801700:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801707:	00 
  801708:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80170e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801714:	48 89 d1             	mov    %rdx,%rcx
  801717:	48 89 c2             	mov    %rax,%rdx
  80171a:	be 00 00 00 00       	mov    $0x0,%esi
  80171f:	bf 00 00 00 00       	mov    $0x0,%edi
  801724:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  80172b:	00 00 00 
  80172e:	ff d0                	callq  *%rax
}
  801730:	c9                   	leaveq 
  801731:	c3                   	retq   

0000000000801732 <sys_cgetc>:

int
sys_cgetc(void)
{
  801732:	55                   	push   %rbp
  801733:	48 89 e5             	mov    %rsp,%rbp
  801736:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80173a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801741:	00 
  801742:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801748:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80174e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801753:	ba 00 00 00 00       	mov    $0x0,%edx
  801758:	be 00 00 00 00       	mov    $0x0,%esi
  80175d:	bf 01 00 00 00       	mov    $0x1,%edi
  801762:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
}
  80176e:	c9                   	leaveq 
  80176f:	c3                   	retq   

0000000000801770 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801770:	55                   	push   %rbp
  801771:	48 89 e5             	mov    %rsp,%rbp
  801774:	48 83 ec 20          	sub    $0x20,%rsp
  801778:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80177b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80177e:	48 98                	cltq   
  801780:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801787:	00 
  801788:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801794:	b9 00 00 00 00       	mov    $0x0,%ecx
  801799:	48 89 c2             	mov    %rax,%rdx
  80179c:	be 01 00 00 00       	mov    $0x1,%esi
  8017a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8017a6:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8017ad:	00 00 00 
  8017b0:	ff d0                	callq  *%rax
}
  8017b2:	c9                   	leaveq 
  8017b3:	c3                   	retq   

00000000008017b4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017b4:	55                   	push   %rbp
  8017b5:	48 89 e5             	mov    %rsp,%rbp
  8017b8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c3:	00 
  8017c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017da:	be 00 00 00 00       	mov    $0x0,%esi
  8017df:	bf 02 00 00 00       	mov    $0x2,%edi
  8017e4:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8017eb:	00 00 00 
  8017ee:	ff d0                	callq  *%rax
}
  8017f0:	c9                   	leaveq 
  8017f1:	c3                   	retq   

00000000008017f2 <sys_yield>:

void
sys_yield(void)
{
  8017f2:	55                   	push   %rbp
  8017f3:	48 89 e5             	mov    %rsp,%rbp
  8017f6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801801:	00 
  801802:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801808:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	be 00 00 00 00       	mov    $0x0,%esi
  80181d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801822:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801829:	00 00 00 
  80182c:	ff d0                	callq  *%rax
}
  80182e:	c9                   	leaveq 
  80182f:	c3                   	retq   

0000000000801830 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 20          	sub    $0x20,%rsp
  801838:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80183f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801842:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801845:	48 63 c8             	movslq %eax,%rcx
  801848:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80184c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184f:	48 98                	cltq   
  801851:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801858:	00 
  801859:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185f:	49 89 c8             	mov    %rcx,%r8
  801862:	48 89 d1             	mov    %rdx,%rcx
  801865:	48 89 c2             	mov    %rax,%rdx
  801868:	be 01 00 00 00       	mov    $0x1,%esi
  80186d:	bf 04 00 00 00       	mov    $0x4,%edi
  801872:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801879:	00 00 00 
  80187c:	ff d0                	callq  *%rax
}
  80187e:	c9                   	leaveq 
  80187f:	c3                   	retq   

0000000000801880 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801880:	55                   	push   %rbp
  801881:	48 89 e5             	mov    %rsp,%rbp
  801884:	48 83 ec 30          	sub    $0x30,%rsp
  801888:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80188b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80188f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801892:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801896:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80189a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80189d:	48 63 c8             	movslq %eax,%rcx
  8018a0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018a7:	48 63 f0             	movslq %eax,%rsi
  8018aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b1:	48 98                	cltq   
  8018b3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018b7:	49 89 f9             	mov    %rdi,%r9
  8018ba:	49 89 f0             	mov    %rsi,%r8
  8018bd:	48 89 d1             	mov    %rdx,%rcx
  8018c0:	48 89 c2             	mov    %rax,%rdx
  8018c3:	be 01 00 00 00       	mov    $0x1,%esi
  8018c8:	bf 05 00 00 00       	mov    $0x5,%edi
  8018cd:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8018d4:	00 00 00 
  8018d7:	ff d0                	callq  *%rax
}
  8018d9:	c9                   	leaveq 
  8018da:	c3                   	retq   

00000000008018db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018db:	55                   	push   %rbp
  8018dc:	48 89 e5             	mov    %rsp,%rbp
  8018df:	48 83 ec 20          	sub    $0x20,%rsp
  8018e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f1:	48 98                	cltq   
  8018f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fa:	00 
  8018fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801901:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801907:	48 89 d1             	mov    %rdx,%rcx
  80190a:	48 89 c2             	mov    %rax,%rdx
  80190d:	be 01 00 00 00       	mov    $0x1,%esi
  801912:	bf 06 00 00 00       	mov    $0x6,%edi
  801917:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  80191e:	00 00 00 
  801921:	ff d0                	callq  *%rax
}
  801923:	c9                   	leaveq 
  801924:	c3                   	retq   

0000000000801925 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801925:	55                   	push   %rbp
  801926:	48 89 e5             	mov    %rsp,%rbp
  801929:	48 83 ec 20          	sub    $0x20,%rsp
  80192d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801930:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801936:	48 63 d0             	movslq %eax,%rdx
  801939:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80193c:	48 98                	cltq   
  80193e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801945:	00 
  801946:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801952:	48 89 d1             	mov    %rdx,%rcx
  801955:	48 89 c2             	mov    %rax,%rdx
  801958:	be 01 00 00 00       	mov    $0x1,%esi
  80195d:	bf 08 00 00 00       	mov    $0x8,%edi
  801962:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801969:	00 00 00 
  80196c:	ff d0                	callq  *%rax
}
  80196e:	c9                   	leaveq 
  80196f:	c3                   	retq   

0000000000801970 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 20          	sub    $0x20,%rsp
  801978:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80197b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80197f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801986:	48 98                	cltq   
  801988:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198f:	00 
  801990:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801996:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199c:	48 89 d1             	mov    %rdx,%rcx
  80199f:	48 89 c2             	mov    %rax,%rdx
  8019a2:	be 01 00 00 00       	mov    $0x1,%esi
  8019a7:	bf 09 00 00 00       	mov    $0x9,%edi
  8019ac:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	callq  *%rax
}
  8019b8:	c9                   	leaveq 
  8019b9:	c3                   	retq   

00000000008019ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	48 83 ec 20          	sub    $0x20,%rsp
  8019c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d0:	48 98                	cltq   
  8019d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d9:	00 
  8019da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e6:	48 89 d1             	mov    %rdx,%rcx
  8019e9:	48 89 c2             	mov    %rax,%rdx
  8019ec:	be 01 00 00 00       	mov    $0x1,%esi
  8019f1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019f6:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  8019fd:	00 00 00 
  801a00:	ff d0                	callq  *%rax
}
  801a02:	c9                   	leaveq 
  801a03:	c3                   	retq   

0000000000801a04 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a04:	55                   	push   %rbp
  801a05:	48 89 e5             	mov    %rsp,%rbp
  801a08:	48 83 ec 30          	sub    $0x30,%rsp
  801a0c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a13:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a17:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1d:	48 63 f0             	movslq %eax,%rsi
  801a20:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a27:	48 98                	cltq   
  801a29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a34:	00 
  801a35:	49 89 f1             	mov    %rsi,%r9
  801a38:	49 89 c8             	mov    %rcx,%r8
  801a3b:	48 89 d1             	mov    %rdx,%rcx
  801a3e:	48 89 c2             	mov    %rax,%rdx
  801a41:	be 00 00 00 00       	mov    $0x0,%esi
  801a46:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a4b:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801a52:	00 00 00 
  801a55:	ff d0                	callq  *%rax
}
  801a57:	c9                   	leaveq 
  801a58:	c3                   	retq   

0000000000801a59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a59:	55                   	push   %rbp
  801a5a:	48 89 e5             	mov    %rsp,%rbp
  801a5d:	48 83 ec 20          	sub    $0x20,%rsp
  801a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a69:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a70:	00 
  801a71:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a77:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a82:	48 89 c2             	mov    %rax,%rdx
  801a85:	be 01 00 00 00       	mov    $0x1,%esi
  801a8a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a8f:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801a96:	00 00 00 
  801a99:	ff d0                	callq  *%rax
}
  801a9b:	c9                   	leaveq 
  801a9c:	c3                   	retq   

0000000000801a9d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a9d:	55                   	push   %rbp
  801a9e:	48 89 e5             	mov    %rsp,%rbp
  801aa1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801aa5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aac:	00 
  801aad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	be 00 00 00 00       	mov    $0x0,%esi
  801ac8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801acd:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801ad4:	00 00 00 
  801ad7:	ff d0                	callq  *%rax
}
  801ad9:	c9                   	leaveq 
  801ada:	c3                   	retq   

0000000000801adb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801adb:	55                   	push   %rbp
  801adc:	48 89 e5             	mov    %rsp,%rbp
  801adf:	48 83 ec 20          	sub    $0x20,%rsp
  801ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ae7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afa:	00 
  801afb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b01:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b07:	48 89 d1             	mov    %rdx,%rcx
  801b0a:	48 89 c2             	mov    %rax,%rdx
  801b0d:	be 00 00 00 00       	mov    $0x0,%esi
  801b12:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b17:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801b1e:	00 00 00 
  801b21:	ff d0                	callq  *%rax
}
  801b23:	c9                   	leaveq 
  801b24:	c3                   	retq   

0000000000801b25 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801b25:	55                   	push   %rbp
  801b26:	48 89 e5             	mov    %rsp,%rbp
  801b29:	48 83 ec 20          	sub    $0x20,%rsp
  801b2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b44:	00 
  801b45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b51:	48 89 d1             	mov    %rdx,%rcx
  801b54:	48 89 c2             	mov    %rax,%rdx
  801b57:	be 00 00 00 00       	mov    $0x0,%esi
  801b5c:	bf 10 00 00 00       	mov    $0x10,%edi
  801b61:	48 b8 4c 16 80 00 00 	movabs $0x80164c,%rax
  801b68:	00 00 00 
  801b6b:	ff d0                	callq  *%rax
}
  801b6d:	c9                   	leaveq 
  801b6e:	c3                   	retq   
	...

0000000000801b70 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b70:	55                   	push   %rbp
  801b71:	48 89 e5             	mov    %rsp,%rbp
  801b74:	48 83 ec 30          	sub    $0x30,%rsp
  801b78:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b80:	48 8b 00             	mov    (%rax),%rax
  801b83:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801b87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b8b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801b8f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801b92:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b95:	83 e0 02             	and    $0x2,%eax
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	74 23                	je     801bbf <pgfault+0x4f>
  801b9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba0:	48 89 c2             	mov    %rax,%rdx
  801ba3:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ba7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bae:	01 00 00 
  801bb1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bb5:	25 00 08 00 00       	and    $0x800,%eax
  801bba:	48 85 c0             	test   %rax,%rax
  801bbd:	75 2a                	jne    801be9 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801bbf:	48 ba 50 4a 80 00 00 	movabs $0x804a50,%rdx
  801bc6:	00 00 00 
  801bc9:	be 1c 00 00 00       	mov    $0x1c,%esi
  801bce:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801bd5:	00 00 00 
  801bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdd:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  801be4:	00 00 00 
  801be7:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801be9:	ba 07 00 00 00       	mov    $0x7,%edx
  801bee:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bf3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf8:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  801bff:	00 00 00 
  801c02:	ff d0                	callq  *%rax
  801c04:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c0b:	79 30                	jns    801c3d <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801c0d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c10:	89 c1                	mov    %eax,%ecx
  801c12:	48 ba 90 4a 80 00 00 	movabs $0x804a90,%rdx
  801c19:	00 00 00 
  801c1c:	be 26 00 00 00       	mov    $0x26,%esi
  801c21:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801c28:	00 00 00 
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  801c37:	00 00 00 
  801c3a:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c41:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c49:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c4f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c54:	48 89 c6             	mov    %rax,%rsi
  801c57:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c5c:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  801c63:	00 00 00 
  801c66:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801c68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801c70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c74:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c7a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801c80:	48 89 c1             	mov    %rax,%rcx
  801c83:	ba 00 00 00 00       	mov    $0x0,%edx
  801c88:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c92:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801c99:	00 00 00 
  801c9c:	ff d0                	callq  *%rax
  801c9e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ca5:	79 30                	jns    801cd7 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801ca7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801caa:	89 c1                	mov    %eax,%ecx
  801cac:	48 ba b8 4a 80 00 00 	movabs $0x804ab8,%rdx
  801cb3:	00 00 00 
  801cb6:	be 2b 00 00 00       	mov    $0x2b,%esi
  801cbb:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801cc2:	00 00 00 
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cca:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  801cd1:	00 00 00 
  801cd4:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801cd7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cdc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce1:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	callq  *%rax
  801ced:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801cf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801cf4:	79 30                	jns    801d26 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801cf6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801cf9:	89 c1                	mov    %eax,%ecx
  801cfb:	48 ba e0 4a 80 00 00 	movabs $0x804ae0,%rdx
  801d02:	00 00 00 
  801d05:	be 2e 00 00 00       	mov    $0x2e,%esi
  801d0a:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801d11:	00 00 00 
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  801d20:	00 00 00 
  801d23:	41 ff d0             	callq  *%r8
	
}
  801d26:	c9                   	leaveq 
  801d27:	c3                   	retq   

0000000000801d28 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d28:	55                   	push   %rbp
  801d29:	48 89 e5             	mov    %rsp,%rbp
  801d2c:	48 83 ec 30          	sub    $0x30,%rsp
  801d30:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d33:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801d36:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d3d:	01 00 00 
  801d40:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d54:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801d57:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d5a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801d62:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d65:	25 00 04 00 00       	and    $0x400,%eax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	74 5c                	je     801dca <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801d6e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801d71:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d75:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7c:	41 89 f0             	mov    %esi,%r8d
  801d7f:	48 89 c6             	mov    %rax,%rsi
  801d82:	bf 00 00 00 00       	mov    $0x0,%edi
  801d87:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801d8e:	00 00 00 
  801d91:	ff d0                	callq  *%rax
  801d93:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801d96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801d9a:	0f 89 60 01 00 00    	jns    801f00 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801da0:	48 ba 08 4b 80 00 00 	movabs $0x804b08,%rdx
  801da7:	00 00 00 
  801daa:	be 4d 00 00 00       	mov    $0x4d,%esi
  801daf:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801db6:	00 00 00 
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  801dc5:	00 00 00 
  801dc8:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801dca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dcd:	83 e0 02             	and    $0x2,%eax
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	75 10                	jne    801de4 <duppage+0xbc>
  801dd4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801dd7:	25 00 08 00 00       	and    $0x800,%eax
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	0f 84 c4 00 00 00    	je     801ea8 <duppage+0x180>
	{
		perm |= PTE_COW;
  801de4:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801deb:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801def:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801df2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801df6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801df9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfd:	41 89 f0             	mov    %esi,%r8d
  801e00:	48 89 c6             	mov    %rax,%rsi
  801e03:	bf 00 00 00 00       	mov    $0x0,%edi
  801e08:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801e0f:	00 00 00 
  801e12:	ff d0                	callq  *%rax
  801e14:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801e17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e1b:	79 2a                	jns    801e47 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801e1d:	48 ba 38 4b 80 00 00 	movabs $0x804b38,%rdx
  801e24:	00 00 00 
  801e27:	be 56 00 00 00       	mov    $0x56,%esi
  801e2c:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801e33:	00 00 00 
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3b:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  801e42:	00 00 00 
  801e45:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801e47:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801e4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e52:	41 89 c8             	mov    %ecx,%r8d
  801e55:	48 89 d1             	mov    %rdx,%rcx
  801e58:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5d:	48 89 c6             	mov    %rax,%rsi
  801e60:	bf 00 00 00 00       	mov    $0x0,%edi
  801e65:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
  801e71:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e78:	0f 89 82 00 00 00    	jns    801f00 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  801e7e:	48 ba 38 4b 80 00 00 	movabs $0x804b38,%rdx
  801e85:	00 00 00 
  801e88:	be 59 00 00 00       	mov    $0x59,%esi
  801e8d:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801e94:	00 00 00 
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9c:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  801ea3:	00 00 00 
  801ea6:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  801ea8:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801eab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801eaf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb6:	41 89 f0             	mov    %esi,%r8d
  801eb9:	48 89 c6             	mov    %rax,%rsi
  801ebc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec1:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
  801ecd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801ed0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ed4:	79 2a                	jns    801f00 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  801ed6:	48 ba 70 4b 80 00 00 	movabs $0x804b70,%rdx
  801edd:	00 00 00 
  801ee0:	be 60 00 00 00       	mov    $0x60,%esi
  801ee5:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801eec:	00 00 00 
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  801efb:	00 00 00 
  801efe:	ff d1                	callq  *%rcx
	}
	return 0;
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f05:	c9                   	leaveq 
  801f06:	c3                   	retq   

0000000000801f07 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f07:	55                   	push   %rbp
  801f08:	48 89 e5             	mov    %rsp,%rbp
  801f0b:	53                   	push   %rbx
  801f0c:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801f10:	48 bf 70 1b 80 00 00 	movabs $0x801b70,%rdi
  801f17:	00 00 00 
  801f1a:	48 b8 d8 40 80 00 00 	movabs $0x8040d8,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f26:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  801f2d:	8b 45 bc             	mov    -0x44(%rbp),%eax
  801f30:	cd 30                	int    $0x30
  801f32:	89 c3                	mov    %eax,%ebx
  801f34:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f37:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  801f3a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  801f3d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f41:	79 30                	jns    801f73 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  801f43:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f46:	89 c1                	mov    %eax,%ecx
  801f48:	48 ba 94 4b 80 00 00 	movabs $0x804b94,%rdx
  801f4f:	00 00 00 
  801f52:	be 7f 00 00 00       	mov    $0x7f,%esi
  801f57:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  801f6d:	00 00 00 
  801f70:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  801f73:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f77:	75 4c                	jne    801fc5 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  801f79:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  801f80:	00 00 00 
  801f83:	ff d0                	callq  *%rax
  801f85:	48 98                	cltq   
  801f87:	48 89 c2             	mov    %rax,%rdx
  801f8a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801f90:	48 89 d0             	mov    %rdx,%rax
  801f93:	48 c1 e0 03          	shl    $0x3,%rax
  801f97:	48 01 d0             	add    %rdx,%rax
  801f9a:	48 c1 e0 05          	shl    $0x5,%rax
  801f9e:	48 89 c2             	mov    %rax,%rdx
  801fa1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801fa8:	00 00 00 
  801fab:	48 01 c2             	add    %rax,%rdx
  801fae:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801fb5:	00 00 00 
  801fb8:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc0:	e9 38 02 00 00       	jmpq   8021fd <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  801fc5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801fc8:	ba 07 00 00 00       	mov    $0x7,%edx
  801fcd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801fd2:	89 c7                	mov    %eax,%edi
  801fd4:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	callq  *%rax
  801fe0:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  801fe3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  801fe7:	79 30                	jns    802019 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  801fe9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  801fec:	89 c1                	mov    %eax,%ecx
  801fee:	48 ba a8 4b 80 00 00 	movabs $0x804ba8,%rdx
  801ff5:	00 00 00 
  801ff8:	be 8b 00 00 00       	mov    $0x8b,%esi
  801ffd:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  802004:	00 00 00 
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  802013:	00 00 00 
  802016:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802019:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802020:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802027:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80202e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802035:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80203c:	e9 0a 01 00 00       	jmpq   80214b <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802041:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802048:	01 00 00 
  80204b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80204e:	48 63 d2             	movslq %edx,%rdx
  802051:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802055:	83 e0 01             	and    $0x1,%eax
  802058:	84 c0                	test   %al,%al
  80205a:	0f 84 e7 00 00 00    	je     802147 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802060:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802067:	e9 cf 00 00 00       	jmpq   80213b <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80206c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802073:	01 00 00 
  802076:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802079:	48 63 d2             	movslq %edx,%rdx
  80207c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802080:	83 e0 01             	and    $0x1,%eax
  802083:	84 c0                	test   %al,%al
  802085:	0f 84 a0 00 00 00    	je     80212b <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80208b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802092:	e9 85 00 00 00       	jmpq   80211c <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802097:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80209e:	01 00 00 
  8020a1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020a4:	48 63 d2             	movslq %edx,%rdx
  8020a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ab:	83 e0 01             	and    $0x1,%eax
  8020ae:	84 c0                	test   %al,%al
  8020b0:	74 56                	je     802108 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8020b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8020b9:	eb 42                	jmp    8020fd <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8020bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c2:	01 00 00 
  8020c5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020c8:	48 63 d2             	movslq %edx,%rdx
  8020cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cf:	83 e0 01             	and    $0x1,%eax
  8020d2:	84 c0                	test   %al,%al
  8020d4:	74 1f                	je     8020f5 <fork+0x1ee>
  8020d6:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8020dd:	74 16                	je     8020f5 <fork+0x1ee>
									 duppage(envid,d1);
  8020df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020e2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020e5:	89 d6                	mov    %edx,%esi
  8020e7:	89 c7                	mov    %eax,%edi
  8020e9:	48 b8 28 1d 80 00 00 	movabs $0x801d28,%rax
  8020f0:	00 00 00 
  8020f3:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8020f5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8020f9:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8020fd:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802104:	7e b5                	jle    8020bb <fork+0x1b4>
  802106:	eb 0c                	jmp    802114 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802108:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80210b:	83 c0 01             	add    $0x1,%eax
  80210e:	c1 e0 09             	shl    $0x9,%eax
  802111:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802114:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802118:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  80211c:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802123:	0f 8e 6e ff ff ff    	jle    802097 <fork+0x190>
  802129:	eb 0c                	jmp    802137 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80212b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80212e:	83 c0 01             	add    $0x1,%eax
  802131:	c1 e0 09             	shl    $0x9,%eax
  802134:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802137:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80213b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80213e:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802141:	0f 8c 25 ff ff ff    	jl     80206c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802147:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80214b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80214e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802151:	0f 8c ea fe ff ff    	jl     802041 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802157:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80215a:	48 be 9c 41 80 00 00 	movabs $0x80419c,%rsi
  802161:	00 00 00 
  802164:	89 c7                	mov    %eax,%edi
  802166:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
  802172:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802175:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802179:	79 30                	jns    8021ab <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80217b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80217e:	89 c1                	mov    %eax,%ecx
  802180:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  802187:	00 00 00 
  80218a:	be ad 00 00 00       	mov    $0xad,%esi
  80218f:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  802196:	00 00 00 
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  8021a5:	00 00 00 
  8021a8:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8021ab:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021ae:	be 02 00 00 00       	mov    $0x2,%esi
  8021b3:	89 c7                	mov    %eax,%edi
  8021b5:	48 b8 25 19 80 00 00 	movabs $0x801925,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8021c4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021c8:	79 30                	jns    8021fa <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8021ca:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8021cd:	89 c1                	mov    %eax,%ecx
  8021cf:	48 ba f8 4b 80 00 00 	movabs $0x804bf8,%rdx
  8021d6:	00 00 00 
  8021d9:	be b0 00 00 00       	mov    $0xb0,%esi
  8021de:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  8021e5:	00 00 00 
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  8021f4:	00 00 00 
  8021f7:	41 ff d0             	callq  *%r8
	return envid;
  8021fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8021fd:	48 83 c4 48          	add    $0x48,%rsp
  802201:	5b                   	pop    %rbx
  802202:	5d                   	pop    %rbp
  802203:	c3                   	retq   

0000000000802204 <sfork>:

// Challenge!
int
sfork(void)
{
  802204:	55                   	push   %rbp
  802205:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802208:	48 ba 1c 4c 80 00 00 	movabs $0x804c1c,%rdx
  80220f:	00 00 00 
  802212:	be b8 00 00 00       	mov    $0xb8,%esi
  802217:	48 bf 85 4a 80 00 00 	movabs $0x804a85,%rdi
  80221e:	00 00 00 
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  80222d:	00 00 00 
  802230:	ff d1                	callq  *%rcx
	...

0000000000802234 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	48 83 ec 08          	sub    $0x8,%rsp
  80223c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802240:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802244:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80224b:	ff ff ff 
  80224e:	48 01 d0             	add    %rdx,%rax
  802251:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802255:	c9                   	leaveq 
  802256:	c3                   	retq   

0000000000802257 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802257:	55                   	push   %rbp
  802258:	48 89 e5             	mov    %rsp,%rbp
  80225b:	48 83 ec 08          	sub    $0x8,%rsp
  80225f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802263:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802267:	48 89 c7             	mov    %rax,%rdi
  80226a:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  802271:	00 00 00 
  802274:	ff d0                	callq  *%rax
  802276:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80227c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802280:	c9                   	leaveq 
  802281:	c3                   	retq   

0000000000802282 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802282:	55                   	push   %rbp
  802283:	48 89 e5             	mov    %rsp,%rbp
  802286:	48 83 ec 18          	sub    $0x18,%rsp
  80228a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80228e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802295:	eb 6b                	jmp    802302 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229a:	48 98                	cltq   
  80229c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ae:	48 89 c2             	mov    %rax,%rdx
  8022b1:	48 c1 ea 15          	shr    $0x15,%rdx
  8022b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022bc:	01 00 00 
  8022bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c3:	83 e0 01             	and    $0x1,%eax
  8022c6:	48 85 c0             	test   %rax,%rax
  8022c9:	74 21                	je     8022ec <fd_alloc+0x6a>
  8022cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cf:	48 89 c2             	mov    %rax,%rdx
  8022d2:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022dd:	01 00 00 
  8022e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e4:	83 e0 01             	and    $0x1,%eax
  8022e7:	48 85 c0             	test   %rax,%rax
  8022ea:	75 12                	jne    8022fe <fd_alloc+0x7c>
			*fd_store = fd;
  8022ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	eb 1a                	jmp    802318 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022fe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802302:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802306:	7e 8f                	jle    802297 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802313:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802318:	c9                   	leaveq 
  802319:	c3                   	retq   

000000000080231a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80231a:	55                   	push   %rbp
  80231b:	48 89 e5             	mov    %rsp,%rbp
  80231e:	48 83 ec 20          	sub    $0x20,%rsp
  802322:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802329:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80232d:	78 06                	js     802335 <fd_lookup+0x1b>
  80232f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802333:	7e 07                	jle    80233c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802335:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80233a:	eb 6c                	jmp    8023a8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80233c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80233f:	48 98                	cltq   
  802341:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802347:	48 c1 e0 0c          	shl    $0xc,%rax
  80234b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80234f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802353:	48 89 c2             	mov    %rax,%rdx
  802356:	48 c1 ea 15          	shr    $0x15,%rdx
  80235a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802361:	01 00 00 
  802364:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802368:	83 e0 01             	and    $0x1,%eax
  80236b:	48 85 c0             	test   %rax,%rax
  80236e:	74 21                	je     802391 <fd_lookup+0x77>
  802370:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802374:	48 89 c2             	mov    %rax,%rdx
  802377:	48 c1 ea 0c          	shr    $0xc,%rdx
  80237b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802382:	01 00 00 
  802385:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802389:	83 e0 01             	and    $0x1,%eax
  80238c:	48 85 c0             	test   %rax,%rax
  80238f:	75 07                	jne    802398 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802391:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802396:	eb 10                	jmp    8023a8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802398:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80239c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023a0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a8:	c9                   	leaveq 
  8023a9:	c3                   	retq   

00000000008023aa <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023aa:	55                   	push   %rbp
  8023ab:	48 89 e5             	mov    %rsp,%rbp
  8023ae:	48 83 ec 30          	sub    $0x30,%rsp
  8023b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023b6:	89 f0                	mov    %esi,%eax
  8023b8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023bf:	48 89 c7             	mov    %rax,%rdi
  8023c2:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  8023c9:	00 00 00 
  8023cc:	ff d0                	callq  *%rax
  8023ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023d2:	48 89 d6             	mov    %rdx,%rsi
  8023d5:	89 c7                	mov    %eax,%edi
  8023d7:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  8023de:	00 00 00 
  8023e1:	ff d0                	callq  *%rax
  8023e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ea:	78 0a                	js     8023f6 <fd_close+0x4c>
	    || fd != fd2)
  8023ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023f4:	74 12                	je     802408 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023f6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023fa:	74 05                	je     802401 <fd_close+0x57>
  8023fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ff:	eb 05                	jmp    802406 <fd_close+0x5c>
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
  802406:	eb 69                	jmp    802471 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802408:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80240c:	8b 00                	mov    (%rax),%eax
  80240e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802412:	48 89 d6             	mov    %rdx,%rsi
  802415:	89 c7                	mov    %eax,%edi
  802417:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  80241e:	00 00 00 
  802421:	ff d0                	callq  *%rax
  802423:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802426:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242a:	78 2a                	js     802456 <fd_close+0xac>
		if (dev->dev_close)
  80242c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802430:	48 8b 40 20          	mov    0x20(%rax),%rax
  802434:	48 85 c0             	test   %rax,%rax
  802437:	74 16                	je     80244f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802439:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802441:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802445:	48 89 c7             	mov    %rax,%rdi
  802448:	ff d2                	callq  *%rdx
  80244a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244d:	eb 07                	jmp    802456 <fd_close+0xac>
		else
			r = 0;
  80244f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80245a:	48 89 c6             	mov    %rax,%rsi
  80245d:	bf 00 00 00 00       	mov    $0x0,%edi
  802462:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  802469:	00 00 00 
  80246c:	ff d0                	callq  *%rax
	return r;
  80246e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 20          	sub    $0x20,%rsp
  80247b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80247e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802482:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802489:	eb 41                	jmp    8024cc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80248b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802492:	00 00 00 
  802495:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802498:	48 63 d2             	movslq %edx,%rdx
  80249b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249f:	8b 00                	mov    (%rax),%eax
  8024a1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024a4:	75 22                	jne    8024c8 <dev_lookup+0x55>
			*dev = devtab[i];
  8024a6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024ad:	00 00 00 
  8024b0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b3:	48 63 d2             	movslq %edx,%rdx
  8024b6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024be:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	eb 60                	jmp    802528 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024cc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024d3:	00 00 00 
  8024d6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024d9:	48 63 d2             	movslq %edx,%rdx
  8024dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e0:	48 85 c0             	test   %rax,%rax
  8024e3:	75 a6                	jne    80248b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024e5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8024ec:	00 00 00 
  8024ef:	48 8b 00             	mov    (%rax),%rax
  8024f2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024fb:	89 c6                	mov    %eax,%esi
  8024fd:	48 bf 38 4c 80 00 00 	movabs $0x804c38,%rdi
  802504:	00 00 00 
  802507:	b8 00 00 00 00       	mov    $0x0,%eax
  80250c:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  802513:	00 00 00 
  802516:	ff d1                	callq  *%rcx
	*dev = 0;
  802518:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802528:	c9                   	leaveq 
  802529:	c3                   	retq   

000000000080252a <close>:

int
close(int fdnum)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 20          	sub    $0x20,%rsp
  802532:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802535:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802539:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80253c:	48 89 d6             	mov    %rdx,%rsi
  80253f:	89 c7                	mov    %eax,%edi
  802541:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  802548:	00 00 00 
  80254b:	ff d0                	callq  *%rax
  80254d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802550:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802554:	79 05                	jns    80255b <close+0x31>
		return r;
  802556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802559:	eb 18                	jmp    802573 <close+0x49>
	else
		return fd_close(fd, 1);
  80255b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255f:	be 01 00 00 00       	mov    $0x1,%esi
  802564:	48 89 c7             	mov    %rax,%rdi
  802567:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  80256e:	00 00 00 
  802571:	ff d0                	callq  *%rax
}
  802573:	c9                   	leaveq 
  802574:	c3                   	retq   

0000000000802575 <close_all>:

void
close_all(void)
{
  802575:	55                   	push   %rbp
  802576:	48 89 e5             	mov    %rsp,%rbp
  802579:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80257d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802584:	eb 15                	jmp    80259b <close_all+0x26>
		close(i);
  802586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802589:	89 c7                	mov    %eax,%edi
  80258b:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802592:	00 00 00 
  802595:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802597:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80259b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80259f:	7e e5                	jle    802586 <close_all+0x11>
		close(i);
}
  8025a1:	c9                   	leaveq 
  8025a2:	c3                   	retq   

00000000008025a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025a3:	55                   	push   %rbp
  8025a4:	48 89 e5             	mov    %rsp,%rbp
  8025a7:	48 83 ec 40          	sub    $0x40,%rsp
  8025ab:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025ae:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025b1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025b8:	48 89 d6             	mov    %rdx,%rsi
  8025bb:	89 c7                	mov    %eax,%edi
  8025bd:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  8025c4:	00 00 00 
  8025c7:	ff d0                	callq  *%rax
  8025c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025d0:	79 08                	jns    8025da <dup+0x37>
		return r;
  8025d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d5:	e9 70 01 00 00       	jmpq   80274a <dup+0x1a7>
	close(newfdnum);
  8025da:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025dd:	89 c7                	mov    %eax,%edi
  8025df:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025eb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025ee:	48 98                	cltq   
  8025f0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f6:	48 c1 e0 0c          	shl    $0xc,%rax
  8025fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802602:	48 89 c7             	mov    %rax,%rdi
  802605:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  80260c:	00 00 00 
  80260f:	ff d0                	callq  *%rax
  802611:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802615:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802619:	48 89 c7             	mov    %rax,%rdi
  80261c:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  802623:	00 00 00 
  802626:	ff d0                	callq  *%rax
  802628:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80262c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802630:	48 89 c2             	mov    %rax,%rdx
  802633:	48 c1 ea 15          	shr    $0x15,%rdx
  802637:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80263e:	01 00 00 
  802641:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802645:	83 e0 01             	and    $0x1,%eax
  802648:	84 c0                	test   %al,%al
  80264a:	74 71                	je     8026bd <dup+0x11a>
  80264c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802650:	48 89 c2             	mov    %rax,%rdx
  802653:	48 c1 ea 0c          	shr    $0xc,%rdx
  802657:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265e:	01 00 00 
  802661:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802665:	83 e0 01             	and    $0x1,%eax
  802668:	84 c0                	test   %al,%al
  80266a:	74 51                	je     8026bd <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80266c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802670:	48 89 c2             	mov    %rax,%rdx
  802673:	48 c1 ea 0c          	shr    $0xc,%rdx
  802677:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267e:	01 00 00 
  802681:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802685:	89 c1                	mov    %eax,%ecx
  802687:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80268d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802695:	41 89 c8             	mov    %ecx,%r8d
  802698:	48 89 d1             	mov    %rdx,%rcx
  80269b:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a0:	48 89 c6             	mov    %rax,%rsi
  8026a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a8:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8026af:	00 00 00 
  8026b2:	ff d0                	callq  *%rax
  8026b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026bb:	78 56                	js     802713 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c1:	48 89 c2             	mov    %rax,%rdx
  8026c4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026c8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026cf:	01 00 00 
  8026d2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d6:	89 c1                	mov    %eax,%ecx
  8026d8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8026de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026e6:	41 89 c8             	mov    %ecx,%r8d
  8026e9:	48 89 d1             	mov    %rdx,%rcx
  8026ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f1:	48 89 c6             	mov    %rax,%rsi
  8026f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f9:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802700:	00 00 00 
  802703:	ff d0                	callq  *%rax
  802705:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802708:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270c:	78 08                	js     802716 <dup+0x173>
		goto err;

	return newfdnum;
  80270e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802711:	eb 37                	jmp    80274a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802713:	90                   	nop
  802714:	eb 01                	jmp    802717 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802716:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802717:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80271b:	48 89 c6             	mov    %rax,%rsi
  80271e:	bf 00 00 00 00       	mov    $0x0,%edi
  802723:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80272f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802733:	48 89 c6             	mov    %rax,%rsi
  802736:	bf 00 00 00 00       	mov    $0x0,%edi
  80273b:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  802742:	00 00 00 
  802745:	ff d0                	callq  *%rax
	return r;
  802747:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80274a:	c9                   	leaveq 
  80274b:	c3                   	retq   

000000000080274c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80274c:	55                   	push   %rbp
  80274d:	48 89 e5             	mov    %rsp,%rbp
  802750:	48 83 ec 40          	sub    $0x40,%rsp
  802754:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802757:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80275b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802763:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802766:	48 89 d6             	mov    %rdx,%rsi
  802769:	89 c7                	mov    %eax,%edi
  80276b:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  802772:	00 00 00 
  802775:	ff d0                	callq  *%rax
  802777:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277e:	78 24                	js     8027a4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802784:	8b 00                	mov    (%rax),%eax
  802786:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278a:	48 89 d6             	mov    %rdx,%rsi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  802796:	00 00 00 
  802799:	ff d0                	callq  *%rax
  80279b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a2:	79 05                	jns    8027a9 <read+0x5d>
		return r;
  8027a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a7:	eb 7a                	jmp    802823 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ad:	8b 40 08             	mov    0x8(%rax),%eax
  8027b0:	83 e0 03             	and    $0x3,%eax
  8027b3:	83 f8 01             	cmp    $0x1,%eax
  8027b6:	75 3a                	jne    8027f2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027b8:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8027bf:	00 00 00 
  8027c2:	48 8b 00             	mov    (%rax),%rax
  8027c5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027cb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ce:	89 c6                	mov    %eax,%esi
  8027d0:	48 bf 57 4c 80 00 00 	movabs $0x804c57,%rdi
  8027d7:	00 00 00 
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  8027e6:	00 00 00 
  8027e9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f0:	eb 31                	jmp    802823 <read+0xd7>
	}
	if (!dev->dev_read)
  8027f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027fa:	48 85 c0             	test   %rax,%rax
  8027fd:	75 07                	jne    802806 <read+0xba>
		return -E_NOT_SUPP;
  8027ff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802804:	eb 1d                	jmp    802823 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802806:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80280e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802812:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802816:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80281a:	48 89 ce             	mov    %rcx,%rsi
  80281d:	48 89 c7             	mov    %rax,%rdi
  802820:	41 ff d0             	callq  *%r8
}
  802823:	c9                   	leaveq 
  802824:	c3                   	retq   

0000000000802825 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802825:	55                   	push   %rbp
  802826:	48 89 e5             	mov    %rsp,%rbp
  802829:	48 83 ec 30          	sub    $0x30,%rsp
  80282d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802830:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802834:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802838:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80283f:	eb 46                	jmp    802887 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802841:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802844:	48 98                	cltq   
  802846:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80284a:	48 29 c2             	sub    %rax,%rdx
  80284d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802850:	48 98                	cltq   
  802852:	48 89 c1             	mov    %rax,%rcx
  802855:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802859:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80285c:	48 89 ce             	mov    %rcx,%rsi
  80285f:	89 c7                	mov    %eax,%edi
  802861:	48 b8 4c 27 80 00 00 	movabs $0x80274c,%rax
  802868:	00 00 00 
  80286b:	ff d0                	callq  *%rax
  80286d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802870:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802874:	79 05                	jns    80287b <readn+0x56>
			return m;
  802876:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802879:	eb 1d                	jmp    802898 <readn+0x73>
		if (m == 0)
  80287b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80287f:	74 13                	je     802894 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802881:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802884:	01 45 fc             	add    %eax,-0x4(%rbp)
  802887:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288a:	48 98                	cltq   
  80288c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802890:	72 af                	jb     802841 <readn+0x1c>
  802892:	eb 01                	jmp    802895 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802894:	90                   	nop
	}
	return tot;
  802895:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802898:	c9                   	leaveq 
  802899:	c3                   	retq   

000000000080289a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
  80289e:	48 83 ec 40          	sub    $0x40,%rsp
  8028a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028b4:	48 89 d6             	mov    %rdx,%rsi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cc:	78 24                	js     8028f2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d2:	8b 00                	mov    (%rax),%eax
  8028d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d8:	48 89 d6             	mov    %rdx,%rsi
  8028db:	89 c7                	mov    %eax,%edi
  8028dd:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax
  8028e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f0:	79 05                	jns    8028f7 <write+0x5d>
		return r;
  8028f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f5:	eb 79                	jmp    802970 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028fb:	8b 40 08             	mov    0x8(%rax),%eax
  8028fe:	83 e0 03             	and    $0x3,%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	75 3a                	jne    80293f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802905:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80290c:	00 00 00 
  80290f:	48 8b 00             	mov    (%rax),%rax
  802912:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802918:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80291b:	89 c6                	mov    %eax,%esi
  80291d:	48 bf 73 4c 80 00 00 	movabs $0x804c73,%rdi
  802924:	00 00 00 
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  802933:	00 00 00 
  802936:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80293d:	eb 31                	jmp    802970 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80293f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802943:	48 8b 40 18          	mov    0x18(%rax),%rax
  802947:	48 85 c0             	test   %rax,%rax
  80294a:	75 07                	jne    802953 <write+0xb9>
		return -E_NOT_SUPP;
  80294c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802951:	eb 1d                	jmp    802970 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802957:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80295b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802963:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802967:	48 89 ce             	mov    %rcx,%rsi
  80296a:	48 89 c7             	mov    %rax,%rdi
  80296d:	41 ff d0             	callq  *%r8
}
  802970:	c9                   	leaveq 
  802971:	c3                   	retq   

0000000000802972 <seek>:

int
seek(int fdnum, off_t offset)
{
  802972:	55                   	push   %rbp
  802973:	48 89 e5             	mov    %rsp,%rbp
  802976:	48 83 ec 18          	sub    $0x18,%rsp
  80297a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80297d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802980:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802984:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802987:	48 89 d6             	mov    %rdx,%rsi
  80298a:	89 c7                	mov    %eax,%edi
  80298c:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  802993:	00 00 00 
  802996:	ff d0                	callq  *%rax
  802998:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80299f:	79 05                	jns    8029a6 <seek+0x34>
		return r;
  8029a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a4:	eb 0f                	jmp    8029b5 <seek+0x43>
	fd->fd_offset = offset;
  8029a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029aa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029ad:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b5:	c9                   	leaveq 
  8029b6:	c3                   	retq   

00000000008029b7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029b7:	55                   	push   %rbp
  8029b8:	48 89 e5             	mov    %rsp,%rbp
  8029bb:	48 83 ec 30          	sub    $0x30,%rsp
  8029bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029c2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cc:	48 89 d6             	mov    %rdx,%rsi
  8029cf:	89 c7                	mov    %eax,%edi
  8029d1:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
  8029dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e4:	78 24                	js     802a0a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ea:	8b 00                	mov    (%rax),%eax
  8029ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f0:	48 89 d6             	mov    %rdx,%rsi
  8029f3:	89 c7                	mov    %eax,%edi
  8029f5:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  8029fc:	00 00 00 
  8029ff:	ff d0                	callq  *%rax
  802a01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a08:	79 05                	jns    802a0f <ftruncate+0x58>
		return r;
  802a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0d:	eb 72                	jmp    802a81 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a13:	8b 40 08             	mov    0x8(%rax),%eax
  802a16:	83 e0 03             	and    $0x3,%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 3a                	jne    802a57 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a1d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802a24:	00 00 00 
  802a27:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a2a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a30:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a33:	89 c6                	mov    %eax,%esi
  802a35:	48 bf 90 4c 80 00 00 	movabs $0x804c90,%rdi
  802a3c:	00 00 00 
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  802a4b:	00 00 00 
  802a4e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a55:	eb 2a                	jmp    802a81 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a5b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a5f:	48 85 c0             	test   %rax,%rax
  802a62:	75 07                	jne    802a6b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a64:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a69:	eb 16                	jmp    802a81 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a77:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802a7a:	89 d6                	mov    %edx,%esi
  802a7c:	48 89 c7             	mov    %rax,%rdi
  802a7f:	ff d1                	callq  *%rcx
}
  802a81:	c9                   	leaveq 
  802a82:	c3                   	retq   

0000000000802a83 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a83:	55                   	push   %rbp
  802a84:	48 89 e5             	mov    %rsp,%rbp
  802a87:	48 83 ec 30          	sub    $0x30,%rsp
  802a8b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a8e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a92:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a96:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a99:	48 89 d6             	mov    %rdx,%rsi
  802a9c:	89 c7                	mov    %eax,%edi
  802a9e:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
  802aaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab1:	78 24                	js     802ad7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ab3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab7:	8b 00                	mov    (%rax),%eax
  802ab9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802abd:	48 89 d6             	mov    %rdx,%rsi
  802ac0:	89 c7                	mov    %eax,%edi
  802ac2:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  802ac9:	00 00 00 
  802acc:	ff d0                	callq  *%rax
  802ace:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad5:	79 05                	jns    802adc <fstat+0x59>
		return r;
  802ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ada:	eb 5e                	jmp    802b3a <fstat+0xb7>
	if (!dev->dev_stat)
  802adc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae0:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ae4:	48 85 c0             	test   %rax,%rax
  802ae7:	75 07                	jne    802af0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ae9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aee:	eb 4a                	jmp    802b3a <fstat+0xb7>
	stat->st_name[0] = 0;
  802af0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802af7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802afb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b02:	00 00 00 
	stat->st_isdir = 0;
  802b05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b09:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b10:	00 00 00 
	stat->st_dev = dev;
  802b13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b22:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b26:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802b2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802b32:	48 89 d6             	mov    %rdx,%rsi
  802b35:	48 89 c7             	mov    %rax,%rdi
  802b38:	ff d1                	callq  *%rcx
}
  802b3a:	c9                   	leaveq 
  802b3b:	c3                   	retq   

0000000000802b3c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b3c:	55                   	push   %rbp
  802b3d:	48 89 e5             	mov    %rsp,%rbp
  802b40:	48 83 ec 20          	sub    $0x20,%rsp
  802b44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b50:	be 00 00 00 00       	mov    $0x0,%esi
  802b55:	48 89 c7             	mov    %rax,%rdi
  802b58:	48 b8 2b 2c 80 00 00 	movabs $0x802c2b,%rax
  802b5f:	00 00 00 
  802b62:	ff d0                	callq  *%rax
  802b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6b:	79 05                	jns    802b72 <stat+0x36>
		return fd;
  802b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b70:	eb 2f                	jmp    802ba1 <stat+0x65>
	r = fstat(fd, stat);
  802b72:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b79:	48 89 d6             	mov    %rdx,%rsi
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	48 b8 83 2a 80 00 00 	movabs $0x802a83,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
  802b8a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b90:	89 c7                	mov    %eax,%edi
  802b92:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
	return r;
  802b9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ba1:	c9                   	leaveq 
  802ba2:	c3                   	retq   
	...

0000000000802ba4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ba4:	55                   	push   %rbp
  802ba5:	48 89 e5             	mov    %rsp,%rbp
  802ba8:	48 83 ec 10          	sub    $0x10,%rsp
  802bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802baf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bb3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bba:	00 00 00 
  802bbd:	8b 00                	mov    (%rax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	75 1d                	jne    802be0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bc3:	bf 01 00 00 00       	mov    $0x1,%edi
  802bc8:	48 b8 ab 43 80 00 00 	movabs $0x8043ab,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802bdb:	00 00 00 
  802bde:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802be0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802be7:	00 00 00 
  802bea:	8b 00                	mov    (%rax),%eax
  802bec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bef:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bf4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bfb:	00 00 00 
  802bfe:	89 c7                	mov    %eax,%edi
  802c00:	48 b8 e8 42 80 00 00 	movabs $0x8042e8,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c10:	ba 00 00 00 00       	mov    $0x0,%edx
  802c15:	48 89 c6             	mov    %rax,%rsi
  802c18:	bf 00 00 00 00       	mov    $0x0,%edi
  802c1d:	48 b8 28 42 80 00 00 	movabs $0x804228,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
}
  802c29:	c9                   	leaveq 
  802c2a:	c3                   	retq   

0000000000802c2b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c2b:	55                   	push   %rbp
  802c2c:	48 89 e5             	mov    %rsp,%rbp
  802c2f:	48 83 ec 20          	sub    $0x20,%rsp
  802c33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c37:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802c3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3e:	48 89 c7             	mov    %rax,%rdi
  802c41:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c52:	7e 0a                	jle    802c5e <open+0x33>
                return -E_BAD_PATH;
  802c54:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c59:	e9 a5 00 00 00       	jmpq   802d03 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802c5e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c62:	48 89 c7             	mov    %rax,%rdi
  802c65:	48 b8 82 22 80 00 00 	movabs $0x802282,%rax
  802c6c:	00 00 00 
  802c6f:	ff d0                	callq  *%rax
  802c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c78:	79 08                	jns    802c82 <open+0x57>
		return r;
  802c7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7d:	e9 81 00 00 00       	jmpq   802d03 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802c82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c86:	48 89 c6             	mov    %rax,%rsi
  802c89:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802c90:	00 00 00 
  802c93:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  802c9a:	00 00 00 
  802c9d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802c9f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ca6:	00 00 00 
  802ca9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802cac:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802cb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb6:	48 89 c6             	mov    %rax,%rsi
  802cb9:	bf 01 00 00 00       	mov    $0x1,%edi
  802cbe:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
  802cca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802ccd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd1:	79 1d                	jns    802cf0 <open+0xc5>
	{
		fd_close(fd,0);
  802cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd7:	be 00 00 00 00       	mov    $0x0,%esi
  802cdc:	48 89 c7             	mov    %rax,%rdi
  802cdf:	48 b8 aa 23 80 00 00 	movabs $0x8023aa,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
		return r;
  802ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cee:	eb 13                	jmp    802d03 <open+0xd8>
	}
	return fd2num(fd);
  802cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf4:	48 89 c7             	mov    %rax,%rdi
  802cf7:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
	


}
  802d03:	c9                   	leaveq 
  802d04:	c3                   	retq   

0000000000802d05 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d05:	55                   	push   %rbp
  802d06:	48 89 e5             	mov    %rsp,%rbp
  802d09:	48 83 ec 10          	sub    $0x10,%rsp
  802d0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d15:	8b 50 0c             	mov    0xc(%rax),%edx
  802d18:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d1f:	00 00 00 
  802d22:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d24:	be 00 00 00 00       	mov    $0x0,%esi
  802d29:	bf 06 00 00 00       	mov    $0x6,%edi
  802d2e:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
}
  802d3a:	c9                   	leaveq 
  802d3b:	c3                   	retq   

0000000000802d3c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d3c:	55                   	push   %rbp
  802d3d:	48 89 e5             	mov    %rsp,%rbp
  802d40:	48 83 ec 30          	sub    $0x30,%rsp
  802d44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d54:	8b 50 0c             	mov    0xc(%rax),%edx
  802d57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d5e:	00 00 00 
  802d61:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d6a:	00 00 00 
  802d6d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d71:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d75:	be 00 00 00 00       	mov    $0x0,%esi
  802d7a:	bf 03 00 00 00       	mov    $0x3,%edi
  802d7f:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
  802d8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d92:	79 05                	jns    802d99 <devfile_read+0x5d>
	{
		return r;
  802d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d97:	eb 2c                	jmp    802dc5 <devfile_read+0x89>
	}
	if(r > 0)
  802d99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d9d:	7e 23                	jle    802dc2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802d9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da2:	48 63 d0             	movslq %eax,%rdx
  802da5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802da9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802db0:	00 00 00 
  802db3:	48 89 c7             	mov    %rax,%rdi
  802db6:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
	return r;
  802dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802dc5:	c9                   	leaveq 
  802dc6:	c3                   	retq   

0000000000802dc7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802dc7:	55                   	push   %rbp
  802dc8:	48 89 e5             	mov    %rsp,%rbp
  802dcb:	48 83 ec 30          	sub    $0x30,%rsp
  802dcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802ddb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ddf:	8b 50 0c             	mov    0xc(%rax),%edx
  802de2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de9:	00 00 00 
  802dec:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802dee:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802df5:	00 
  802df6:	76 08                	jbe    802e00 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802df8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802dff:	00 
	fsipcbuf.write.req_n=n;
  802e00:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e07:	00 00 00 
  802e0a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e0e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802e12:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1a:	48 89 c6             	mov    %rax,%rsi
  802e1d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e24:	00 00 00 
  802e27:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802e33:	be 00 00 00 00       	mov    $0x0,%esi
  802e38:	bf 04 00 00 00       	mov    $0x4,%edi
  802e3d:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802e44:	00 00 00 
  802e47:	ff d0                	callq  *%rax
  802e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e4f:	c9                   	leaveq 
  802e50:	c3                   	retq   

0000000000802e51 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802e51:	55                   	push   %rbp
  802e52:	48 89 e5             	mov    %rsp,%rbp
  802e55:	48 83 ec 10          	sub    $0x10,%rsp
  802e59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e64:	8b 50 0c             	mov    0xc(%rax),%edx
  802e67:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e6e:	00 00 00 
  802e71:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802e73:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e7a:	00 00 00 
  802e7d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e83:	be 00 00 00 00       	mov    $0x0,%esi
  802e88:	bf 02 00 00 00       	mov    $0x2,%edi
  802e8d:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
}
  802e99:	c9                   	leaveq 
  802e9a:	c3                   	retq   

0000000000802e9b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e9b:	55                   	push   %rbp
  802e9c:	48 89 e5             	mov    %rsp,%rbp
  802e9f:	48 83 ec 20          	sub    $0x20,%rsp
  802ea3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ea7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eaf:	8b 50 0c             	mov    0xc(%rax),%edx
  802eb2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eb9:	00 00 00 
  802ebc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ebe:	be 00 00 00 00       	mov    $0x0,%esi
  802ec3:	bf 05 00 00 00       	mov    $0x5,%edi
  802ec8:	48 b8 a4 2b 80 00 00 	movabs $0x802ba4,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
  802ed4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edb:	79 05                	jns    802ee2 <devfile_stat+0x47>
		return r;
  802edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee0:	eb 56                	jmp    802f38 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802ee2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee6:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802eed:	00 00 00 
  802ef0:	48 89 c7             	mov    %rax,%rdi
  802ef3:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  802efa:	00 00 00 
  802efd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802eff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f06:	00 00 00 
  802f09:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f13:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f19:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f20:	00 00 00 
  802f23:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f2d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f38:	c9                   	leaveq 
  802f39:	c3                   	retq   
	...

0000000000802f3c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802f3c:	55                   	push   %rbp
  802f3d:	48 89 e5             	mov    %rsp,%rbp
  802f40:	48 83 ec 20          	sub    $0x20,%rsp
  802f44:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802f47:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f4b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f4e:	48 89 d6             	mov    %rdx,%rsi
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f66:	79 05                	jns    802f6d <fd2sockid+0x31>
		return r;
  802f68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f6b:	eb 24                	jmp    802f91 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f71:	8b 10                	mov    (%rax),%edx
  802f73:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f7a:	00 00 00 
  802f7d:	8b 00                	mov    (%rax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	74 07                	je     802f8a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802f83:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f88:	eb 07                	jmp    802f91 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802f91:	c9                   	leaveq 
  802f92:	c3                   	retq   

0000000000802f93 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802f93:	55                   	push   %rbp
  802f94:	48 89 e5             	mov    %rsp,%rbp
  802f97:	48 83 ec 20          	sub    $0x20,%rsp
  802f9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802f9e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fa2:	48 89 c7             	mov    %rax,%rdi
  802fa5:	48 b8 82 22 80 00 00 	movabs $0x802282,%rax
  802fac:	00 00 00 
  802faf:	ff d0                	callq  *%rax
  802fb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fb8:	78 26                	js     802fe0 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbe:	ba 07 04 00 00       	mov    $0x407,%edx
  802fc3:	48 89 c6             	mov    %rax,%rsi
  802fc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802fcb:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fde:	79 16                	jns    802ff6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802fe0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe3:	89 c7                	mov    %eax,%edi
  802fe5:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  802fec:	00 00 00 
  802fef:	ff d0                	callq  *%rax
		return r;
  802ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff4:	eb 3a                	jmp    803030 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ff6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffa:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803001:	00 00 00 
  803004:	8b 12                	mov    (%rdx),%edx
  803006:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803013:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803017:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80301a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80301d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803021:	48 89 c7             	mov    %rax,%rdi
  803024:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
}
  803030:	c9                   	leaveq 
  803031:	c3                   	retq   

0000000000803032 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803032:	55                   	push   %rbp
  803033:	48 89 e5             	mov    %rsp,%rbp
  803036:	48 83 ec 30          	sub    $0x30,%rsp
  80303a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80303d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803041:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803045:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803048:	89 c7                	mov    %eax,%edi
  80304a:	48 b8 3c 2f 80 00 00 	movabs $0x802f3c,%rax
  803051:	00 00 00 
  803054:	ff d0                	callq  *%rax
  803056:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803059:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305d:	79 05                	jns    803064 <accept+0x32>
		return r;
  80305f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803062:	eb 3b                	jmp    80309f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803064:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803068:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80306c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80306f:	48 89 ce             	mov    %rcx,%rsi
  803072:	89 c7                	mov    %eax,%edi
  803074:	48 b8 7d 33 80 00 00 	movabs $0x80337d,%rax
  80307b:	00 00 00 
  80307e:	ff d0                	callq  *%rax
  803080:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803083:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803087:	79 05                	jns    80308e <accept+0x5c>
		return r;
  803089:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308c:	eb 11                	jmp    80309f <accept+0x6d>
	return alloc_sockfd(r);
  80308e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803091:	89 c7                	mov    %eax,%edi
  803093:	48 b8 93 2f 80 00 00 	movabs $0x802f93,%rax
  80309a:	00 00 00 
  80309d:	ff d0                	callq  *%rax
}
  80309f:	c9                   	leaveq 
  8030a0:	c3                   	retq   

00000000008030a1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8030a1:	55                   	push   %rbp
  8030a2:	48 89 e5             	mov    %rsp,%rbp
  8030a5:	48 83 ec 20          	sub    $0x20,%rsp
  8030a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030b0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030b6:	89 c7                	mov    %eax,%edi
  8030b8:	48 b8 3c 2f 80 00 00 	movabs $0x802f3c,%rax
  8030bf:	00 00 00 
  8030c2:	ff d0                	callq  *%rax
  8030c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cb:	79 05                	jns    8030d2 <bind+0x31>
		return r;
  8030cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d0:	eb 1b                	jmp    8030ed <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8030d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030d5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030dc:	48 89 ce             	mov    %rcx,%rsi
  8030df:	89 c7                	mov    %eax,%edi
  8030e1:	48 b8 fc 33 80 00 00 	movabs $0x8033fc,%rax
  8030e8:	00 00 00 
  8030eb:	ff d0                	callq  *%rax
}
  8030ed:	c9                   	leaveq 
  8030ee:	c3                   	retq   

00000000008030ef <shutdown>:

int
shutdown(int s, int how)
{
  8030ef:	55                   	push   %rbp
  8030f0:	48 89 e5             	mov    %rsp,%rbp
  8030f3:	48 83 ec 20          	sub    $0x20,%rsp
  8030f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030fa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 3c 2f 80 00 00 	movabs $0x802f3c,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
  80310e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803115:	79 05                	jns    80311c <shutdown+0x2d>
		return r;
  803117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311a:	eb 16                	jmp    803132 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80311c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80311f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803122:	89 d6                	mov    %edx,%esi
  803124:	89 c7                	mov    %eax,%edi
  803126:	48 b8 60 34 80 00 00 	movabs $0x803460,%rax
  80312d:	00 00 00 
  803130:	ff d0                	callq  *%rax
}
  803132:	c9                   	leaveq 
  803133:	c3                   	retq   

0000000000803134 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803134:	55                   	push   %rbp
  803135:	48 89 e5             	mov    %rsp,%rbp
  803138:	48 83 ec 10          	sub    $0x10,%rsp
  80313c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803144:	48 89 c7             	mov    %rax,%rdi
  803147:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
  803153:	83 f8 01             	cmp    $0x1,%eax
  803156:	75 17                	jne    80316f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80315c:	8b 40 0c             	mov    0xc(%rax),%eax
  80315f:	89 c7                	mov    %eax,%edi
  803161:	48 b8 a0 34 80 00 00 	movabs $0x8034a0,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
  80316d:	eb 05                	jmp    803174 <devsock_close+0x40>
	else
		return 0;
  80316f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803174:	c9                   	leaveq 
  803175:	c3                   	retq   

0000000000803176 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803176:	55                   	push   %rbp
  803177:	48 89 e5             	mov    %rsp,%rbp
  80317a:	48 83 ec 20          	sub    $0x20,%rsp
  80317e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803181:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803185:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 3c 2f 80 00 00 	movabs $0x802f3c,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a0:	79 05                	jns    8031a7 <connect+0x31>
		return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a5:	eb 1b                	jmp    8031c2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8031a7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b1:	48 89 ce             	mov    %rcx,%rsi
  8031b4:	89 c7                	mov    %eax,%edi
  8031b6:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
}
  8031c2:	c9                   	leaveq 
  8031c3:	c3                   	retq   

00000000008031c4 <listen>:

int
listen(int s, int backlog)
{
  8031c4:	55                   	push   %rbp
  8031c5:	48 89 e5             	mov    %rsp,%rbp
  8031c8:	48 83 ec 20          	sub    $0x20,%rsp
  8031cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031cf:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031d5:	89 c7                	mov    %eax,%edi
  8031d7:	48 b8 3c 2f 80 00 00 	movabs $0x802f3c,%rax
  8031de:	00 00 00 
  8031e1:	ff d0                	callq  *%rax
  8031e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ea:	79 05                	jns    8031f1 <listen+0x2d>
		return r;
  8031ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ef:	eb 16                	jmp    803207 <listen+0x43>
	return nsipc_listen(r, backlog);
  8031f1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f7:	89 d6                	mov    %edx,%esi
  8031f9:	89 c7                	mov    %eax,%edi
  8031fb:	48 b8 31 35 80 00 00 	movabs $0x803531,%rax
  803202:	00 00 00 
  803205:	ff d0                	callq  *%rax
}
  803207:	c9                   	leaveq 
  803208:	c3                   	retq   

0000000000803209 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803209:	55                   	push   %rbp
  80320a:	48 89 e5             	mov    %rsp,%rbp
  80320d:	48 83 ec 20          	sub    $0x20,%rsp
  803211:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803215:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803219:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80321d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803221:	89 c2                	mov    %eax,%edx
  803223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803227:	8b 40 0c             	mov    0xc(%rax),%eax
  80322a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80322e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803233:	89 c7                	mov    %eax,%edi
  803235:	48 b8 71 35 80 00 00 	movabs $0x803571,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	c9                   	leaveq 
  803242:	c3                   	retq   

0000000000803243 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 83 ec 20          	sub    $0x20,%rsp
  80324b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80324f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803253:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80325b:	89 c2                	mov    %eax,%edx
  80325d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803261:	8b 40 0c             	mov    0xc(%rax),%eax
  803264:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803268:	b9 00 00 00 00       	mov    $0x0,%ecx
  80326d:	89 c7                	mov    %eax,%edi
  80326f:	48 b8 3d 36 80 00 00 	movabs $0x80363d,%rax
  803276:	00 00 00 
  803279:	ff d0                	callq  *%rax
}
  80327b:	c9                   	leaveq 
  80327c:	c3                   	retq   

000000000080327d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80327d:	55                   	push   %rbp
  80327e:	48 89 e5             	mov    %rsp,%rbp
  803281:	48 83 ec 10          	sub    $0x10,%rsp
  803285:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803289:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80328d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803291:	48 be bb 4c 80 00 00 	movabs $0x804cbb,%rsi
  803298:	00 00 00 
  80329b:	48 89 c7             	mov    %rax,%rdi
  80329e:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  8032a5:	00 00 00 
  8032a8:	ff d0                	callq  *%rax
	return 0;
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032af:	c9                   	leaveq 
  8032b0:	c3                   	retq   

00000000008032b1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032b1:	55                   	push   %rbp
  8032b2:	48 89 e5             	mov    %rsp,%rbp
  8032b5:	48 83 ec 20          	sub    $0x20,%rsp
  8032b9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032bc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8032bf:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032c2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032c5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032cb:	89 ce                	mov    %ecx,%esi
  8032cd:	89 c7                	mov    %eax,%edi
  8032cf:	48 b8 f5 36 80 00 00 	movabs $0x8036f5,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
  8032db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e2:	79 05                	jns    8032e9 <socket+0x38>
		return r;
  8032e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e7:	eb 11                	jmp    8032fa <socket+0x49>
	return alloc_sockfd(r);
  8032e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ec:	89 c7                	mov    %eax,%edi
  8032ee:	48 b8 93 2f 80 00 00 	movabs $0x802f93,%rax
  8032f5:	00 00 00 
  8032f8:	ff d0                	callq  *%rax
}
  8032fa:	c9                   	leaveq 
  8032fb:	c3                   	retq   

00000000008032fc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8032fc:	55                   	push   %rbp
  8032fd:	48 89 e5             	mov    %rsp,%rbp
  803300:	48 83 ec 10          	sub    $0x10,%rsp
  803304:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803307:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  80330e:	00 00 00 
  803311:	8b 00                	mov    (%rax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	75 1d                	jne    803334 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803317:	bf 02 00 00 00       	mov    $0x2,%edi
  80331c:	48 b8 ab 43 80 00 00 	movabs $0x8043ab,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  80332f:	00 00 00 
  803332:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803334:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  80333b:	00 00 00 
  80333e:	8b 00                	mov    (%rax),%eax
  803340:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803343:	b9 07 00 00 00       	mov    $0x7,%ecx
  803348:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80334f:	00 00 00 
  803352:	89 c7                	mov    %eax,%edi
  803354:	48 b8 e8 42 80 00 00 	movabs $0x8042e8,%rax
  80335b:	00 00 00 
  80335e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803360:	ba 00 00 00 00       	mov    $0x0,%edx
  803365:	be 00 00 00 00       	mov    $0x0,%esi
  80336a:	bf 00 00 00 00       	mov    $0x0,%edi
  80336f:	48 b8 28 42 80 00 00 	movabs $0x804228,%rax
  803376:	00 00 00 
  803379:	ff d0                	callq  *%rax
}
  80337b:	c9                   	leaveq 
  80337c:	c3                   	retq   

000000000080337d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80337d:	55                   	push   %rbp
  80337e:	48 89 e5             	mov    %rsp,%rbp
  803381:	48 83 ec 30          	sub    $0x30,%rsp
  803385:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803388:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803390:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803397:	00 00 00 
  80339a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80339d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80339f:	bf 01 00 00 00       	mov    $0x1,%edi
  8033a4:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  8033ab:	00 00 00 
  8033ae:	ff d0                	callq  *%rax
  8033b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b7:	78 3e                	js     8033f7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8033b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033c0:	00 00 00 
  8033c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8033c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cb:	8b 40 10             	mov    0x10(%rax),%eax
  8033ce:	89 c2                	mov    %eax,%edx
  8033d0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8033d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d8:	48 89 ce             	mov    %rcx,%rsi
  8033db:	48 89 c7             	mov    %rax,%rdi
  8033de:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8033ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ee:	8b 50 10             	mov    0x10(%rax),%edx
  8033f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033f5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8033f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033fa:	c9                   	leaveq 
  8033fb:	c3                   	retq   

00000000008033fc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033fc:	55                   	push   %rbp
  8033fd:	48 89 e5             	mov    %rsp,%rbp
  803400:	48 83 ec 10          	sub    $0x10,%rsp
  803404:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803407:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80340b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80340e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803415:	00 00 00 
  803418:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80341b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80341d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803420:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803424:	48 89 c6             	mov    %rax,%rsi
  803427:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80342e:	00 00 00 
  803431:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80343d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803444:	00 00 00 
  803447:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80344a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80344d:	bf 02 00 00 00       	mov    $0x2,%edi
  803452:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
}
  80345e:	c9                   	leaveq 
  80345f:	c3                   	retq   

0000000000803460 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803460:	55                   	push   %rbp
  803461:	48 89 e5             	mov    %rsp,%rbp
  803464:	48 83 ec 10          	sub    $0x10,%rsp
  803468:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80346b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80346e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803475:	00 00 00 
  803478:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80347b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80347d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803484:	00 00 00 
  803487:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80348a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80348d:	bf 03 00 00 00       	mov    $0x3,%edi
  803492:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
}
  80349e:	c9                   	leaveq 
  80349f:	c3                   	retq   

00000000008034a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8034a0:	55                   	push   %rbp
  8034a1:	48 89 e5             	mov    %rsp,%rbp
  8034a4:	48 83 ec 10          	sub    $0x10,%rsp
  8034a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8034ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034b2:	00 00 00 
  8034b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034b8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8034ba:	bf 04 00 00 00       	mov    $0x4,%edi
  8034bf:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
}
  8034cb:	c9                   	leaveq 
  8034cc:	c3                   	retq   

00000000008034cd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 10          	sub    $0x10,%rsp
  8034d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034dc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8034df:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034e6:	00 00 00 
  8034e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034ec:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8034ee:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f5:	48 89 c6             	mov    %rax,%rsi
  8034f8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8034ff:	00 00 00 
  803502:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80350e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803515:	00 00 00 
  803518:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80351b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80351e:	bf 05 00 00 00       	mov    $0x5,%edi
  803523:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
}
  80352f:	c9                   	leaveq 
  803530:	c3                   	retq   

0000000000803531 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803531:	55                   	push   %rbp
  803532:	48 89 e5             	mov    %rsp,%rbp
  803535:	48 83 ec 10          	sub    $0x10,%rsp
  803539:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80353c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80353f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803546:	00 00 00 
  803549:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80354c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80354e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803555:	00 00 00 
  803558:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80355e:	bf 06 00 00 00       	mov    $0x6,%edi
  803563:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  80356a:	00 00 00 
  80356d:	ff d0                	callq  *%rax
}
  80356f:	c9                   	leaveq 
  803570:	c3                   	retq   

0000000000803571 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803571:	55                   	push   %rbp
  803572:	48 89 e5             	mov    %rsp,%rbp
  803575:	48 83 ec 30          	sub    $0x30,%rsp
  803579:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80357c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803580:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803583:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803586:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80358d:	00 00 00 
  803590:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803593:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803595:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359c:	00 00 00 
  80359f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035a2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8035a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ac:	00 00 00 
  8035af:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8035b2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8035b5:	bf 07 00 00 00       	mov    $0x7,%edi
  8035ba:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  8035c1:	00 00 00 
  8035c4:	ff d0                	callq  *%rax
  8035c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cd:	78 69                	js     803638 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8035cf:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8035d6:	7f 08                	jg     8035e0 <nsipc_recv+0x6f>
  8035d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035db:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8035de:	7e 35                	jle    803615 <nsipc_recv+0xa4>
  8035e0:	48 b9 c2 4c 80 00 00 	movabs $0x804cc2,%rcx
  8035e7:	00 00 00 
  8035ea:	48 ba d7 4c 80 00 00 	movabs $0x804cd7,%rdx
  8035f1:	00 00 00 
  8035f4:	be 61 00 00 00       	mov    $0x61,%esi
  8035f9:	48 bf ec 4c 80 00 00 	movabs $0x804cec,%rdi
  803600:	00 00 00 
  803603:	b8 00 00 00 00       	mov    $0x0,%eax
  803608:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  80360f:	00 00 00 
  803612:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803615:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803618:	48 63 d0             	movslq %eax,%rdx
  80361b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803626:	00 00 00 
  803629:	48 89 c7             	mov    %rax,%rdi
  80362c:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
	}

	return r;
  803638:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80363b:	c9                   	leaveq 
  80363c:	c3                   	retq   

000000000080363d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80363d:	55                   	push   %rbp
  80363e:	48 89 e5             	mov    %rsp,%rbp
  803641:	48 83 ec 20          	sub    $0x20,%rsp
  803645:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80364c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80364f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803652:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803659:	00 00 00 
  80365c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80365f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803661:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803668:	7e 35                	jle    80369f <nsipc_send+0x62>
  80366a:	48 b9 f8 4c 80 00 00 	movabs $0x804cf8,%rcx
  803671:	00 00 00 
  803674:	48 ba d7 4c 80 00 00 	movabs $0x804cd7,%rdx
  80367b:	00 00 00 
  80367e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803683:	48 bf ec 4c 80 00 00 	movabs $0x804cec,%rdi
  80368a:	00 00 00 
  80368d:	b8 00 00 00 00       	mov    $0x0,%eax
  803692:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  803699:	00 00 00 
  80369c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80369f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a2:	48 63 d0             	movslq %eax,%rdx
  8036a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a9:	48 89 c6             	mov    %rax,%rsi
  8036ac:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8036b3:	00 00 00 
  8036b6:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  8036bd:	00 00 00 
  8036c0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8036c2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c9:	00 00 00 
  8036cc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036cf:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8036d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d9:	00 00 00 
  8036dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036df:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8036e2:	bf 08 00 00 00       	mov    $0x8,%edi
  8036e7:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
}
  8036f3:	c9                   	leaveq 
  8036f4:	c3                   	retq   

00000000008036f5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8036f5:	55                   	push   %rbp
  8036f6:	48 89 e5             	mov    %rsp,%rbp
  8036f9:	48 83 ec 10          	sub    $0x10,%rsp
  8036fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803700:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803703:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803706:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370d:	00 00 00 
  803710:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803713:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803715:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371c:	00 00 00 
  80371f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803722:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803725:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372c:	00 00 00 
  80372f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803732:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803735:	bf 09 00 00 00       	mov    $0x9,%edi
  80373a:	48 b8 fc 32 80 00 00 	movabs $0x8032fc,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
}
  803746:	c9                   	leaveq 
  803747:	c3                   	retq   

0000000000803748 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803748:	55                   	push   %rbp
  803749:	48 89 e5             	mov    %rsp,%rbp
  80374c:	53                   	push   %rbx
  80374d:	48 83 ec 38          	sub    $0x38,%rsp
  803751:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803755:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 82 22 80 00 00 	movabs $0x802282,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80376b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80376f:	0f 88 bf 01 00 00    	js     803934 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803779:	ba 07 04 00 00       	mov    $0x407,%edx
  80377e:	48 89 c6             	mov    %rax,%rsi
  803781:	bf 00 00 00 00       	mov    $0x0,%edi
  803786:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
  803792:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803795:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803799:	0f 88 95 01 00 00    	js     803934 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80379f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037a3:	48 89 c7             	mov    %rax,%rdi
  8037a6:	48 b8 82 22 80 00 00 	movabs $0x802282,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
  8037b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b9:	0f 88 5d 01 00 00    	js     80391c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037c3:	ba 07 04 00 00       	mov    $0x407,%edx
  8037c8:	48 89 c6             	mov    %rax,%rsi
  8037cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d0:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8037d7:	00 00 00 
  8037da:	ff d0                	callq  *%rax
  8037dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037e3:	0f 88 33 01 00 00    	js     80391c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ed:	48 89 c7             	mov    %rax,%rdi
  8037f0:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
  8037fc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803800:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803804:	ba 07 04 00 00       	mov    $0x407,%edx
  803809:	48 89 c6             	mov    %rax,%rsi
  80380c:	bf 00 00 00 00       	mov    $0x0,%edi
  803811:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803820:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803824:	0f 88 d9 00 00 00    	js     803903 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80382a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80382e:	48 89 c7             	mov    %rax,%rdi
  803831:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	48 89 c2             	mov    %rax,%rdx
  803840:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803844:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80384a:	48 89 d1             	mov    %rdx,%rcx
  80384d:	ba 00 00 00 00       	mov    $0x0,%edx
  803852:	48 89 c6             	mov    %rax,%rsi
  803855:	bf 00 00 00 00       	mov    $0x0,%edi
  80385a:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
  803866:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803869:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80386d:	78 79                	js     8038e8 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80386f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803873:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80387a:	00 00 00 
  80387d:	8b 12                	mov    (%rdx),%edx
  80387f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803885:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80388c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803890:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803897:	00 00 00 
  80389a:	8b 12                	mov    (%rdx),%edx
  80389c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80389e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038a2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038ad:	48 89 c7             	mov    %rax,%rdi
  8038b0:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	89 c2                	mov    %eax,%edx
  8038be:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038c2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038c4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038c8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8038cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038d0:	48 89 c7             	mov    %rax,%rdi
  8038d3:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  8038da:	00 00 00 
  8038dd:	ff d0                	callq  *%rax
  8038df:	89 03                	mov    %eax,(%rbx)
	return 0;
  8038e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e6:	eb 4f                	jmp    803937 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8038e8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8038e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ed:	48 89 c6             	mov    %rax,%rsi
  8038f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8038f5:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  8038fc:	00 00 00 
  8038ff:	ff d0                	callq  *%rax
  803901:	eb 01                	jmp    803904 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803903:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803904:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803908:	48 89 c6             	mov    %rax,%rsi
  80390b:	bf 00 00 00 00       	mov    $0x0,%edi
  803910:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80391c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803920:	48 89 c6             	mov    %rax,%rsi
  803923:	bf 00 00 00 00       	mov    $0x0,%edi
  803928:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
    err:
	return r;
  803934:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803937:	48 83 c4 38          	add    $0x38,%rsp
  80393b:	5b                   	pop    %rbx
  80393c:	5d                   	pop    %rbp
  80393d:	c3                   	retq   

000000000080393e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80393e:	55                   	push   %rbp
  80393f:	48 89 e5             	mov    %rsp,%rbp
  803942:	53                   	push   %rbx
  803943:	48 83 ec 28          	sub    $0x28,%rsp
  803947:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80394b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80394f:	eb 01                	jmp    803952 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803951:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803952:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803959:	00 00 00 
  80395c:	48 8b 00             	mov    (%rax),%rax
  80395f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803965:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396c:	48 89 c7             	mov    %rax,%rdi
  80396f:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  803976:	00 00 00 
  803979:	ff d0                	callq  *%rax
  80397b:	89 c3                	mov    %eax,%ebx
  80397d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803981:	48 89 c7             	mov    %rax,%rdi
  803984:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  80398b:	00 00 00 
  80398e:	ff d0                	callq  *%rax
  803990:	39 c3                	cmp    %eax,%ebx
  803992:	0f 94 c0             	sete   %al
  803995:	0f b6 c0             	movzbl %al,%eax
  803998:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80399b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8039a2:	00 00 00 
  8039a5:	48 8b 00             	mov    (%rax),%rax
  8039a8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039ae:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039b7:	75 0a                	jne    8039c3 <_pipeisclosed+0x85>
			return ret;
  8039b9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8039bc:	48 83 c4 28          	add    $0x28,%rsp
  8039c0:	5b                   	pop    %rbx
  8039c1:	5d                   	pop    %rbp
  8039c2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8039c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039c6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039c9:	74 86                	je     803951 <_pipeisclosed+0x13>
  8039cb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039cf:	75 80                	jne    803951 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039d1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8039d8:	00 00 00 
  8039db:	48 8b 00             	mov    (%rax),%rax
  8039de:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8039e4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8039e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039ea:	89 c6                	mov    %eax,%esi
  8039ec:	48 bf 09 4d 80 00 00 	movabs $0x804d09,%rdi
  8039f3:	00 00 00 
  8039f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fb:	49 b8 3b 03 80 00 00 	movabs $0x80033b,%r8
  803a02:	00 00 00 
  803a05:	41 ff d0             	callq  *%r8
	}
  803a08:	e9 44 ff ff ff       	jmpq   803951 <_pipeisclosed+0x13>

0000000000803a0d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803a0d:	55                   	push   %rbp
  803a0e:	48 89 e5             	mov    %rsp,%rbp
  803a11:	48 83 ec 30          	sub    $0x30,%rsp
  803a15:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a18:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a1c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a1f:	48 89 d6             	mov    %rdx,%rsi
  803a22:	89 c7                	mov    %eax,%edi
  803a24:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  803a2b:	00 00 00 
  803a2e:	ff d0                	callq  *%rax
  803a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a37:	79 05                	jns    803a3e <pipeisclosed+0x31>
		return r;
  803a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3c:	eb 31                	jmp    803a6f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a42:	48 89 c7             	mov    %rax,%rdi
  803a45:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803a4c:	00 00 00 
  803a4f:	ff d0                	callq  *%rax
  803a51:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a5d:	48 89 d6             	mov    %rdx,%rsi
  803a60:	48 89 c7             	mov    %rax,%rdi
  803a63:	48 b8 3e 39 80 00 00 	movabs $0x80393e,%rax
  803a6a:	00 00 00 
  803a6d:	ff d0                	callq  *%rax
}
  803a6f:	c9                   	leaveq 
  803a70:	c3                   	retq   

0000000000803a71 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a71:	55                   	push   %rbp
  803a72:	48 89 e5             	mov    %rsp,%rbp
  803a75:	48 83 ec 40          	sub    $0x40,%rsp
  803a79:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a7d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a81:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a89:	48 89 c7             	mov    %rax,%rdi
  803a8c:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803a93:	00 00 00 
  803a96:	ff d0                	callq  *%rax
  803a98:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aa4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803aab:	00 
  803aac:	e9 97 00 00 00       	jmpq   803b48 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ab1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ab6:	74 09                	je     803ac1 <devpipe_read+0x50>
				return i;
  803ab8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abc:	e9 95 00 00 00       	jmpq   803b56 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ac1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac9:	48 89 d6             	mov    %rdx,%rsi
  803acc:	48 89 c7             	mov    %rax,%rdi
  803acf:	48 b8 3e 39 80 00 00 	movabs $0x80393e,%rax
  803ad6:	00 00 00 
  803ad9:	ff d0                	callq  *%rax
  803adb:	85 c0                	test   %eax,%eax
  803add:	74 07                	je     803ae6 <devpipe_read+0x75>
				return 0;
  803adf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae4:	eb 70                	jmp    803b56 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803ae6:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803aed:	00 00 00 
  803af0:	ff d0                	callq  *%rax
  803af2:	eb 01                	jmp    803af5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803af4:	90                   	nop
  803af5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af9:	8b 10                	mov    (%rax),%edx
  803afb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aff:	8b 40 04             	mov    0x4(%rax),%eax
  803b02:	39 c2                	cmp    %eax,%edx
  803b04:	74 ab                	je     803ab1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b0e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b16:	8b 00                	mov    (%rax),%eax
  803b18:	89 c2                	mov    %eax,%edx
  803b1a:	c1 fa 1f             	sar    $0x1f,%edx
  803b1d:	c1 ea 1b             	shr    $0x1b,%edx
  803b20:	01 d0                	add    %edx,%eax
  803b22:	83 e0 1f             	and    $0x1f,%eax
  803b25:	29 d0                	sub    %edx,%eax
  803b27:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b2b:	48 98                	cltq   
  803b2d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b32:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b38:	8b 00                	mov    (%rax),%eax
  803b3a:	8d 50 01             	lea    0x1(%rax),%edx
  803b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b41:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b43:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b50:	72 a2                	jb     803af4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b56:	c9                   	leaveq 
  803b57:	c3                   	retq   

0000000000803b58 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b58:	55                   	push   %rbp
  803b59:	48 89 e5             	mov    %rsp,%rbp
  803b5c:	48 83 ec 40          	sub    $0x40,%rsp
  803b60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b68:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b70:	48 89 c7             	mov    %rax,%rdi
  803b73:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
  803b7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803b83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803b8b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803b92:	00 
  803b93:	e9 93 00 00 00       	jmpq   803c2b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803b98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba0:	48 89 d6             	mov    %rdx,%rsi
  803ba3:	48 89 c7             	mov    %rax,%rdi
  803ba6:	48 b8 3e 39 80 00 00 	movabs $0x80393e,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
  803bb2:	85 c0                	test   %eax,%eax
  803bb4:	74 07                	je     803bbd <devpipe_write+0x65>
				return 0;
  803bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbb:	eb 7c                	jmp    803c39 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bbd:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803bc4:	00 00 00 
  803bc7:	ff d0                	callq  *%rax
  803bc9:	eb 01                	jmp    803bcc <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bcb:	90                   	nop
  803bcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bd0:	8b 40 04             	mov    0x4(%rax),%eax
  803bd3:	48 63 d0             	movslq %eax,%rdx
  803bd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bda:	8b 00                	mov    (%rax),%eax
  803bdc:	48 98                	cltq   
  803bde:	48 83 c0 20          	add    $0x20,%rax
  803be2:	48 39 c2             	cmp    %rax,%rdx
  803be5:	73 b1                	jae    803b98 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803beb:	8b 40 04             	mov    0x4(%rax),%eax
  803bee:	89 c2                	mov    %eax,%edx
  803bf0:	c1 fa 1f             	sar    $0x1f,%edx
  803bf3:	c1 ea 1b             	shr    $0x1b,%edx
  803bf6:	01 d0                	add    %edx,%eax
  803bf8:	83 e0 1f             	and    $0x1f,%eax
  803bfb:	29 d0                	sub    %edx,%eax
  803bfd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c01:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c05:	48 01 ca             	add    %rcx,%rdx
  803c08:	0f b6 0a             	movzbl (%rdx),%ecx
  803c0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c0f:	48 98                	cltq   
  803c11:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c19:	8b 40 04             	mov    0x4(%rax),%eax
  803c1c:	8d 50 01             	lea    0x1(%rax),%edx
  803c1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c23:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c26:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c2f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c33:	72 96                	jb     803bcb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c39:	c9                   	leaveq 
  803c3a:	c3                   	retq   

0000000000803c3b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c3b:	55                   	push   %rbp
  803c3c:	48 89 e5             	mov    %rsp,%rbp
  803c3f:	48 83 ec 20          	sub    $0x20,%rsp
  803c43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4f:	48 89 c7             	mov    %rax,%rdi
  803c52:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803c59:	00 00 00 
  803c5c:	ff d0                	callq  *%rax
  803c5e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c66:	48 be 1c 4d 80 00 00 	movabs $0x804d1c,%rsi
  803c6d:	00 00 00 
  803c70:	48 89 c7             	mov    %rax,%rdi
  803c73:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c83:	8b 50 04             	mov    0x4(%rax),%edx
  803c86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8a:	8b 00                	mov    (%rax),%eax
  803c8c:	29 c2                	sub    %eax,%edx
  803c8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c92:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803c98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c9c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803ca3:	00 00 00 
	stat->st_dev = &devpipe;
  803ca6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803caa:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cb1:	00 00 00 
  803cb4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cc0:	c9                   	leaveq 
  803cc1:	c3                   	retq   

0000000000803cc2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803cc2:	55                   	push   %rbp
  803cc3:	48 89 e5             	mov    %rsp,%rbp
  803cc6:	48 83 ec 10          	sub    $0x10,%rsp
  803cca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd2:	48 89 c6             	mov    %rax,%rsi
  803cd5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cda:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803ce1:	00 00 00 
  803ce4:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803ce6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cea:	48 89 c7             	mov    %rax,%rdi
  803ced:	48 b8 57 22 80 00 00 	movabs $0x802257,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
  803cf9:	48 89 c6             	mov    %rax,%rsi
  803cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  803d01:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
}
  803d0d:	c9                   	leaveq 
  803d0e:	c3                   	retq   
	...

0000000000803d10 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d10:	55                   	push   %rbp
  803d11:	48 89 e5             	mov    %rsp,%rbp
  803d14:	48 83 ec 20          	sub    $0x20,%rsp
  803d18:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d21:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d25:	be 01 00 00 00       	mov    $0x1,%esi
  803d2a:	48 89 c7             	mov    %rax,%rdi
  803d2d:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  803d34:	00 00 00 
  803d37:	ff d0                	callq  *%rax
}
  803d39:	c9                   	leaveq 
  803d3a:	c3                   	retq   

0000000000803d3b <getchar>:

int
getchar(void)
{
  803d3b:	55                   	push   %rbp
  803d3c:	48 89 e5             	mov    %rsp,%rbp
  803d3f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d43:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d47:	ba 01 00 00 00       	mov    $0x1,%edx
  803d4c:	48 89 c6             	mov    %rax,%rsi
  803d4f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d54:	48 b8 4c 27 80 00 00 	movabs $0x80274c,%rax
  803d5b:	00 00 00 
  803d5e:	ff d0                	callq  *%rax
  803d60:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d67:	79 05                	jns    803d6e <getchar+0x33>
		return r;
  803d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6c:	eb 14                	jmp    803d82 <getchar+0x47>
	if (r < 1)
  803d6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d72:	7f 07                	jg     803d7b <getchar+0x40>
		return -E_EOF;
  803d74:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d79:	eb 07                	jmp    803d82 <getchar+0x47>
	return c;
  803d7b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d7f:	0f b6 c0             	movzbl %al,%eax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	48 83 ec 20          	sub    $0x20,%rsp
  803d8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803d93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d96:	48 89 d6             	mov    %rdx,%rsi
  803d99:	89 c7                	mov    %eax,%edi
  803d9b:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  803da2:	00 00 00 
  803da5:	ff d0                	callq  *%rax
  803da7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803daa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dae:	79 05                	jns    803db5 <iscons+0x31>
		return r;
  803db0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db3:	eb 1a                	jmp    803dcf <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db9:	8b 10                	mov    (%rax),%edx
  803dbb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803dc2:	00 00 00 
  803dc5:	8b 00                	mov    (%rax),%eax
  803dc7:	39 c2                	cmp    %eax,%edx
  803dc9:	0f 94 c0             	sete   %al
  803dcc:	0f b6 c0             	movzbl %al,%eax
}
  803dcf:	c9                   	leaveq 
  803dd0:	c3                   	retq   

0000000000803dd1 <opencons>:

int
opencons(void)
{
  803dd1:	55                   	push   %rbp
  803dd2:	48 89 e5             	mov    %rsp,%rbp
  803dd5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803dd9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ddd:	48 89 c7             	mov    %rax,%rdi
  803de0:	48 b8 82 22 80 00 00 	movabs $0x802282,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
  803dec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803def:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df3:	79 05                	jns    803dfa <opencons+0x29>
		return r;
  803df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803df8:	eb 5b                	jmp    803e55 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803dfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfe:	ba 07 04 00 00       	mov    $0x407,%edx
  803e03:	48 89 c6             	mov    %rax,%rsi
  803e06:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0b:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803e12:	00 00 00 
  803e15:	ff d0                	callq  *%rax
  803e17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1e:	79 05                	jns    803e25 <opencons+0x54>
		return r;
  803e20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e23:	eb 30                	jmp    803e55 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e29:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e30:	00 00 00 
  803e33:	8b 12                	mov    (%rdx),%edx
  803e35:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e46:	48 89 c7             	mov    %rax,%rdi
  803e49:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  803e50:	00 00 00 
  803e53:	ff d0                	callq  *%rax
}
  803e55:	c9                   	leaveq 
  803e56:	c3                   	retq   

0000000000803e57 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e57:	55                   	push   %rbp
  803e58:	48 89 e5             	mov    %rsp,%rbp
  803e5b:	48 83 ec 30          	sub    $0x30,%rsp
  803e5f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e67:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e6b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e70:	75 13                	jne    803e85 <devcons_read+0x2e>
		return 0;
  803e72:	b8 00 00 00 00       	mov    $0x0,%eax
  803e77:	eb 49                	jmp    803ec2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e79:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803e80:	00 00 00 
  803e83:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803e85:	48 b8 32 17 80 00 00 	movabs $0x801732,%rax
  803e8c:	00 00 00 
  803e8f:	ff d0                	callq  *%rax
  803e91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e98:	74 df                	je     803e79 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803e9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e9e:	79 05                	jns    803ea5 <devcons_read+0x4e>
		return c;
  803ea0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ea3:	eb 1d                	jmp    803ec2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ea5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ea9:	75 07                	jne    803eb2 <devcons_read+0x5b>
		return 0;
  803eab:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb0:	eb 10                	jmp    803ec2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803eb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb5:	89 c2                	mov    %eax,%edx
  803eb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ebb:	88 10                	mov    %dl,(%rax)
	return 1;
  803ebd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ec2:	c9                   	leaveq 
  803ec3:	c3                   	retq   

0000000000803ec4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ec4:	55                   	push   %rbp
  803ec5:	48 89 e5             	mov    %rsp,%rbp
  803ec8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803ecf:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ed6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803edd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803ee4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803eeb:	eb 77                	jmp    803f64 <devcons_write+0xa0>
		m = n - tot;
  803eed:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803ef4:	89 c2                	mov    %eax,%edx
  803ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef9:	89 d1                	mov    %edx,%ecx
  803efb:	29 c1                	sub    %eax,%ecx
  803efd:	89 c8                	mov    %ecx,%eax
  803eff:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f05:	83 f8 7f             	cmp    $0x7f,%eax
  803f08:	76 07                	jbe    803f11 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803f0a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f14:	48 63 d0             	movslq %eax,%rdx
  803f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f1a:	48 98                	cltq   
  803f1c:	48 89 c1             	mov    %rax,%rcx
  803f1f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803f26:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f2d:	48 89 ce             	mov    %rcx,%rsi
  803f30:	48 89 c7             	mov    %rax,%rdi
  803f33:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803f3a:	00 00 00 
  803f3d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f3f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f42:	48 63 d0             	movslq %eax,%rdx
  803f45:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f4c:	48 89 d6             	mov    %rdx,%rsi
  803f4f:	48 89 c7             	mov    %rax,%rdi
  803f52:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  803f59:	00 00 00 
  803f5c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f61:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f67:	48 98                	cltq   
  803f69:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f70:	0f 82 77 ff ff ff    	jb     803eed <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f79:	c9                   	leaveq 
  803f7a:	c3                   	retq   

0000000000803f7b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f7b:	55                   	push   %rbp
  803f7c:	48 89 e5             	mov    %rsp,%rbp
  803f7f:	48 83 ec 08          	sub    $0x8,%rsp
  803f83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f8c:	c9                   	leaveq 
  803f8d:	c3                   	retq   

0000000000803f8e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803f8e:	55                   	push   %rbp
  803f8f:	48 89 e5             	mov    %rsp,%rbp
  803f92:	48 83 ec 10          	sub    $0x10,%rsp
  803f96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803f9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803f9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa2:	48 be 28 4d 80 00 00 	movabs $0x804d28,%rsi
  803fa9:	00 00 00 
  803fac:	48 89 c7             	mov    %rax,%rdi
  803faf:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  803fb6:	00 00 00 
  803fb9:	ff d0                	callq  *%rax
	return 0;
  803fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc0:	c9                   	leaveq 
  803fc1:	c3                   	retq   
	...

0000000000803fc4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803fc4:	55                   	push   %rbp
  803fc5:	48 89 e5             	mov    %rsp,%rbp
  803fc8:	53                   	push   %rbx
  803fc9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803fd0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803fd7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803fdd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803fe4:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803feb:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ff2:	84 c0                	test   %al,%al
  803ff4:	74 23                	je     804019 <_panic+0x55>
  803ff6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803ffd:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804001:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804005:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804009:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80400d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804011:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804015:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804019:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804020:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804027:	00 00 00 
  80402a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804031:	00 00 00 
  804034:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804038:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80403f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804046:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80404d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804054:	00 00 00 
  804057:	48 8b 18             	mov    (%rax),%rbx
  80405a:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  804061:	00 00 00 
  804064:	ff d0                	callq  *%rax
  804066:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80406c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804073:	41 89 c8             	mov    %ecx,%r8d
  804076:	48 89 d1             	mov    %rdx,%rcx
  804079:	48 89 da             	mov    %rbx,%rdx
  80407c:	89 c6                	mov    %eax,%esi
  80407e:	48 bf 30 4d 80 00 00 	movabs $0x804d30,%rdi
  804085:	00 00 00 
  804088:	b8 00 00 00 00       	mov    $0x0,%eax
  80408d:	49 b9 3b 03 80 00 00 	movabs $0x80033b,%r9
  804094:	00 00 00 
  804097:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80409a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8040a1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8040a8:	48 89 d6             	mov    %rdx,%rsi
  8040ab:	48 89 c7             	mov    %rax,%rdi
  8040ae:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
	cprintf("\n");
  8040ba:	48 bf 53 4d 80 00 00 	movabs $0x804d53,%rdi
  8040c1:	00 00 00 
  8040c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c9:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  8040d0:	00 00 00 
  8040d3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8040d5:	cc                   	int3   
  8040d6:	eb fd                	jmp    8040d5 <_panic+0x111>

00000000008040d8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040d8:	55                   	push   %rbp
  8040d9:	48 89 e5             	mov    %rsp,%rbp
  8040dc:	48 83 ec 20          	sub    $0x20,%rsp
  8040e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8040e4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040eb:	00 00 00 
  8040ee:	48 8b 00             	mov    (%rax),%rax
  8040f1:	48 85 c0             	test   %rax,%rax
  8040f4:	0f 85 8e 00 00 00    	jne    804188 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8040fa:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804108:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  80410f:	00 00 00 
  804112:	ff d0                	callq  *%rax
  804114:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804117:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80411b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80411e:	ba 07 00 00 00       	mov    $0x7,%edx
  804123:	48 89 ce             	mov    %rcx,%rsi
  804126:	89 c7                	mov    %eax,%edi
  804128:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  80412f:	00 00 00 
  804132:	ff d0                	callq  *%rax
  804134:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804137:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80413b:	74 30                	je     80416d <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  80413d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804140:	89 c1                	mov    %eax,%ecx
  804142:	48 ba 58 4d 80 00 00 	movabs $0x804d58,%rdx
  804149:	00 00 00 
  80414c:	be 24 00 00 00       	mov    $0x24,%esi
  804151:	48 bf 8f 4d 80 00 00 	movabs $0x804d8f,%rdi
  804158:	00 00 00 
  80415b:	b8 00 00 00 00       	mov    $0x0,%eax
  804160:	49 b8 c4 3f 80 00 00 	movabs $0x803fc4,%r8
  804167:	00 00 00 
  80416a:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80416d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804170:	48 be 9c 41 80 00 00 	movabs $0x80419c,%rsi
  804177:	00 00 00 
  80417a:	89 c7                	mov    %eax,%edi
  80417c:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  804183:	00 00 00 
  804186:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804188:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80418f:	00 00 00 
  804192:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804196:	48 89 10             	mov    %rdx,(%rax)
}
  804199:	c9                   	leaveq 
  80419a:	c3                   	retq   
	...

000000000080419c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80419c:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80419f:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8041a6:	00 00 00 
	call *%rax
  8041a9:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  8041ab:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  8041af:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  8041b3:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  8041b6:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8041bd:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8041be:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8041c3:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8041c6:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8041c7:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8041ca:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8041d1:	00 08 
		POPA_						// copy the register contents to the registers
  8041d3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041d7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041dc:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8041e1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8041e6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8041eb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8041f0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8041f5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8041fa:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8041ff:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804204:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804209:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80420e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804213:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804218:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80421d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804221:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804225:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804226:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804227:	c3                   	retq   

0000000000804228 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804228:	55                   	push   %rbp
  804229:	48 89 e5             	mov    %rsp,%rbp
  80422c:	48 83 ec 30          	sub    $0x30,%rsp
  804230:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804234:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804238:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  80423c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804241:	74 18                	je     80425b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  804243:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804247:	48 89 c7             	mov    %rax,%rdi
  80424a:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  804251:	00 00 00 
  804254:	ff d0                	callq  *%rax
  804256:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804259:	eb 19                	jmp    804274 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80425b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804262:	00 00 00 
  804265:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  80426c:	00 00 00 
  80426f:	ff d0                	callq  *%rax
  804271:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804274:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804278:	79 19                	jns    804293 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80427a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804288:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80428e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804291:	eb 53                	jmp    8042e6 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  804293:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804298:	74 19                	je     8042b3 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  80429a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042a1:	00 00 00 
  8042a4:	48 8b 00             	mov    (%rax),%rax
  8042a7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042b1:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8042b3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042b8:	74 19                	je     8042d3 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8042ba:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042c1:	00 00 00 
  8042c4:	48 8b 00             	mov    (%rax),%rax
  8042c7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042d1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8042d3:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042da:	00 00 00 
  8042dd:	48 8b 00             	mov    (%rax),%rax
  8042e0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8042e6:	c9                   	leaveq 
  8042e7:	c3                   	retq   

00000000008042e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8042e8:	55                   	push   %rbp
  8042e9:	48 89 e5             	mov    %rsp,%rbp
  8042ec:	48 83 ec 30          	sub    $0x30,%rsp
  8042f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8042f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8042f6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8042fa:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8042fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804304:	e9 96 00 00 00       	jmpq   80439f <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804309:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80430e:	74 20                	je     804330 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804310:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804313:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804316:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80431a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80431d:	89 c7                	mov    %eax,%edi
  80431f:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  804326:	00 00 00 
  804329:	ff d0                	callq  *%rax
  80432b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80432e:	eb 2d                	jmp    80435d <ipc_send+0x75>
		else if(pg==NULL)
  804330:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804335:	75 26                	jne    80435d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804337:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80433a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804342:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804349:	00 00 00 
  80434c:	89 c7                	mov    %eax,%edi
  80434e:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  804355:	00 00 00 
  804358:	ff d0                	callq  *%rax
  80435a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  80435d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804361:	79 30                	jns    804393 <ipc_send+0xab>
  804363:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804367:	74 2a                	je     804393 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804369:	48 ba 9d 4d 80 00 00 	movabs $0x804d9d,%rdx
  804370:	00 00 00 
  804373:	be 40 00 00 00       	mov    $0x40,%esi
  804378:	48 bf b5 4d 80 00 00 	movabs $0x804db5,%rdi
  80437f:	00 00 00 
  804382:	b8 00 00 00 00       	mov    $0x0,%eax
  804387:	48 b9 c4 3f 80 00 00 	movabs $0x803fc4,%rcx
  80438e:	00 00 00 
  804391:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804393:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80439f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a3:	0f 85 60 ff ff ff    	jne    804309 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8043a9:	c9                   	leaveq 
  8043aa:	c3                   	retq   

00000000008043ab <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043ab:	55                   	push   %rbp
  8043ac:	48 89 e5             	mov    %rsp,%rbp
  8043af:	48 83 ec 18          	sub    $0x18,%rsp
  8043b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8043b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043bd:	eb 5e                	jmp    80441d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8043bf:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043c6:	00 00 00 
  8043c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043cc:	48 63 d0             	movslq %eax,%rdx
  8043cf:	48 89 d0             	mov    %rdx,%rax
  8043d2:	48 c1 e0 03          	shl    $0x3,%rax
  8043d6:	48 01 d0             	add    %rdx,%rax
  8043d9:	48 c1 e0 05          	shl    $0x5,%rax
  8043dd:	48 01 c8             	add    %rcx,%rax
  8043e0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8043e6:	8b 00                	mov    (%rax),%eax
  8043e8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043eb:	75 2c                	jne    804419 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8043ed:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043f4:	00 00 00 
  8043f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043fa:	48 63 d0             	movslq %eax,%rdx
  8043fd:	48 89 d0             	mov    %rdx,%rax
  804400:	48 c1 e0 03          	shl    $0x3,%rax
  804404:	48 01 d0             	add    %rdx,%rax
  804407:	48 c1 e0 05          	shl    $0x5,%rax
  80440b:	48 01 c8             	add    %rcx,%rax
  80440e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804414:	8b 40 08             	mov    0x8(%rax),%eax
  804417:	eb 12                	jmp    80442b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804419:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80441d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804424:	7e 99                	jle    8043bf <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80442b:	c9                   	leaveq 
  80442c:	c3                   	retq   
  80442d:	00 00                	add    %al,(%rax)
	...

0000000000804430 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804430:	55                   	push   %rbp
  804431:	48 89 e5             	mov    %rsp,%rbp
  804434:	48 83 ec 18          	sub    $0x18,%rsp
  804438:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80443c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804440:	48 89 c2             	mov    %rax,%rdx
  804443:	48 c1 ea 15          	shr    $0x15,%rdx
  804447:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80444e:	01 00 00 
  804451:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804455:	83 e0 01             	and    $0x1,%eax
  804458:	48 85 c0             	test   %rax,%rax
  80445b:	75 07                	jne    804464 <pageref+0x34>
		return 0;
  80445d:	b8 00 00 00 00       	mov    $0x0,%eax
  804462:	eb 53                	jmp    8044b7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804468:	48 89 c2             	mov    %rax,%rdx
  80446b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80446f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804476:	01 00 00 
  804479:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80447d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804485:	83 e0 01             	and    $0x1,%eax
  804488:	48 85 c0             	test   %rax,%rax
  80448b:	75 07                	jne    804494 <pageref+0x64>
		return 0;
  80448d:	b8 00 00 00 00       	mov    $0x0,%eax
  804492:	eb 23                	jmp    8044b7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804498:	48 89 c2             	mov    %rax,%rdx
  80449b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80449f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044a6:	00 00 00 
  8044a9:	48 c1 e2 04          	shl    $0x4,%rdx
  8044ad:	48 01 d0             	add    %rdx,%rax
  8044b0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044b4:	0f b7 c0             	movzwl %ax,%eax
}
  8044b7:	c9                   	leaveq 
  8044b8:	c3                   	retq   
