
obj/user/hello.debug:     file format elf64-x86-64


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
  80003c:	e8 5f 00 00 00       	callq  8000a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800053:	48 bf 00 3c 80 00 00 	movabs $0x803c00,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 8f 02 80 00 00 	movabs $0x80028f,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006e:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800075:	00 00 00 
  800078:	48 8b 00             	mov    (%rax),%rax
  80007b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800081:	89 c6                	mov    %eax,%esi
  800083:	48 bf 0e 3c 80 00 00 	movabs $0x803c0e,%rdi
  80008a:	00 00 00 
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
  800092:	48 ba 8f 02 80 00 00 	movabs $0x80028f,%rdx
  800099:	00 00 00 
  80009c:	ff d2                	callq  *%rdx
}
  80009e:	c9                   	leaveq 
  80009f:	c3                   	retq   

00000000008000a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %rbp
  8000a1:	48 89 e5             	mov    %rsp,%rbp
  8000a4:	48 83 ec 10          	sub    $0x10,%rsp
  8000a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000af:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000b6:	00 00 00 
  8000b9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8000c0:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  8000c7:	00 00 00 
  8000ca:	ff d0                	callq  *%rax
  8000cc:	48 98                	cltq   
  8000ce:	48 89 c2             	mov    %rax,%rdx
  8000d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8000d7:	48 89 d0             	mov    %rdx,%rax
  8000da:	48 c1 e0 03          	shl    $0x3,%rax
  8000de:	48 01 d0             	add    %rdx,%rax
  8000e1:	48 c1 e0 05          	shl    $0x5,%rax
  8000e5:	48 89 c2             	mov    %rax,%rdx
  8000e8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000ef:	00 00 00 
  8000f2:	48 01 c2             	add    %rax,%rdx
  8000f5:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8000fc:	00 00 00 
  8000ff:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800106:	7e 14                	jle    80011c <libmain+0x7c>
		binaryname = argv[0];
  800108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80010c:	48 8b 10             	mov    (%rax),%rdx
  80010f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800116:	00 00 00 
  800119:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80011c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800123:	48 89 d6             	mov    %rdx,%rsi
  800126:	89 c7                	mov    %eax,%edi
  800128:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80012f:	00 00 00 
  800132:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800134:	48 b8 44 01 80 00 00 	movabs $0x800144,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	callq  *%rax
}
  800140:	c9                   	leaveq 
  800141:	c3                   	retq   
	...

0000000000800144 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800144:	55                   	push   %rbp
  800145:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800148:	48 b8 05 1e 80 00 00 	movabs $0x801e05,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800154:	bf 00 00 00 00       	mov    $0x0,%edi
  800159:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
}
  800165:	5d                   	pop    %rbp
  800166:	c3                   	retq   
	...

0000000000800168 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800168:	55                   	push   %rbp
  800169:	48 89 e5             	mov    %rsp,%rbp
  80016c:	48 83 ec 10          	sub    $0x10,%rsp
  800170:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800173:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800177:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017b:	8b 00                	mov    (%rax),%eax
  80017d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800180:	89 d6                	mov    %edx,%esi
  800182:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800186:	48 63 d0             	movslq %eax,%rdx
  800189:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80018e:	8d 50 01             	lea    0x1(%rax),%edx
  800191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800195:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800197:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019b:	8b 00                	mov    (%rax),%eax
  80019d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a2:	75 2c                	jne    8001d0 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8001a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a8:	8b 00                	mov    (%rax),%eax
  8001aa:	48 98                	cltq   
  8001ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b0:	48 83 c2 08          	add    $0x8,%rdx
  8001b4:	48 89 c6             	mov    %rax,%rsi
  8001b7:	48 89 d7             	mov    %rdx,%rdi
  8001ba:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8001c1:	00 00 00 
  8001c4:	ff d0                	callq  *%rax
		b->idx = 0;
  8001c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d4:	8b 40 04             	mov    0x4(%rax),%eax
  8001d7:	8d 50 01             	lea    0x1(%rax),%edx
  8001da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001de:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001ee:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001f5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001fc:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800203:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80020a:	48 8b 0a             	mov    (%rdx),%rcx
  80020d:	48 89 08             	mov    %rcx,(%rax)
  800210:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800214:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800218:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80021c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800220:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800227:	00 00 00 
	b.cnt = 0;
  80022a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800231:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800234:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80023b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800242:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800249:	48 89 c6             	mov    %rax,%rsi
  80024c:	48 bf 68 01 80 00 00 	movabs $0x800168,%rdi
  800253:	00 00 00 
  800256:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  80025d:	00 00 00 
  800260:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800262:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800268:	48 98                	cltq   
  80026a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800271:	48 83 c2 08          	add    $0x8,%rdx
  800275:	48 89 c6             	mov    %rax,%rsi
  800278:	48 89 d7             	mov    %rdx,%rdi
  80027b:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  800282:	00 00 00 
  800285:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800287:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80028d:	c9                   	leaveq 
  80028e:	c3                   	retq   

000000000080028f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028f:	55                   	push   %rbp
  800290:	48 89 e5             	mov    %rsp,%rbp
  800293:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80029a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002a1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002a8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002af:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002b6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002bd:	84 c0                	test   %al,%al
  8002bf:	74 20                	je     8002e1 <cprintf+0x52>
  8002c1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002c5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002c9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002cd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002d1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002d5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002d9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002dd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002e1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002e8:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002ef:	00 00 00 
  8002f2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002f9:	00 00 00 
  8002fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800300:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800307:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80030e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800315:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80031c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800323:	48 8b 0a             	mov    (%rdx),%rcx
  800326:	48 89 08             	mov    %rcx,(%rax)
  800329:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80032d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800331:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800335:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800339:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800340:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800347:	48 89 d6             	mov    %rdx,%rsi
  80034a:	48 89 c7             	mov    %rax,%rdi
  80034d:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
  800359:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80035f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800365:	c9                   	leaveq 
  800366:	c3                   	retq   
	...

0000000000800368 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800368:	55                   	push   %rbp
  800369:	48 89 e5             	mov    %rsp,%rbp
  80036c:	48 83 ec 30          	sub    $0x30,%rsp
  800370:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800374:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800378:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80037c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80037f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800383:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800387:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80038a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80038e:	77 52                	ja     8003e2 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800390:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800393:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800397:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80039a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80039e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8003ab:	48 89 c2             	mov    %rax,%rdx
  8003ae:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8003b1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003b4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8003b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003bc:	41 89 f9             	mov    %edi,%r9d
  8003bf:	48 89 c7             	mov    %rax,%rdi
  8003c2:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  8003c9:	00 00 00 
  8003cc:	ff d0                	callq  *%rax
  8003ce:	eb 1c                	jmp    8003ec <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8003d7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8003db:	48 89 d6             	mov    %rdx,%rsi
  8003de:	89 c7                	mov    %eax,%edi
  8003e0:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8003e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003ea:	7f e4                	jg     8003d0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f8:	48 f7 f1             	div    %rcx
  8003fb:	48 89 d0             	mov    %rdx,%rax
  8003fe:	48 ba 08 3e 80 00 00 	movabs $0x803e08,%rdx
  800405:	00 00 00 
  800408:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80040c:	0f be c0             	movsbl %al,%eax
  80040f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800413:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800417:	48 89 d6             	mov    %rdx,%rsi
  80041a:	89 c7                	mov    %eax,%edi
  80041c:	ff d1                	callq  *%rcx
}
  80041e:	c9                   	leaveq 
  80041f:	c3                   	retq   

0000000000800420 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800420:	55                   	push   %rbp
  800421:	48 89 e5             	mov    %rsp,%rbp
  800424:	48 83 ec 20          	sub    $0x20,%rsp
  800428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80042c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80042f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800433:	7e 52                	jle    800487 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800439:	8b 00                	mov    (%rax),%eax
  80043b:	83 f8 30             	cmp    $0x30,%eax
  80043e:	73 24                	jae    800464 <getuint+0x44>
  800440:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800444:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800448:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044c:	8b 00                	mov    (%rax),%eax
  80044e:	89 c0                	mov    %eax,%eax
  800450:	48 01 d0             	add    %rdx,%rax
  800453:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800457:	8b 12                	mov    (%rdx),%edx
  800459:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80045c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800460:	89 0a                	mov    %ecx,(%rdx)
  800462:	eb 17                	jmp    80047b <getuint+0x5b>
  800464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800468:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80046c:	48 89 d0             	mov    %rdx,%rax
  80046f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800473:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800477:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80047b:	48 8b 00             	mov    (%rax),%rax
  80047e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800482:	e9 a3 00 00 00       	jmpq   80052a <getuint+0x10a>
	else if (lflag)
  800487:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80048b:	74 4f                	je     8004dc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80048d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800491:	8b 00                	mov    (%rax),%eax
  800493:	83 f8 30             	cmp    $0x30,%eax
  800496:	73 24                	jae    8004bc <getuint+0x9c>
  800498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	8b 00                	mov    (%rax),%eax
  8004a6:	89 c0                	mov    %eax,%eax
  8004a8:	48 01 d0             	add    %rdx,%rax
  8004ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004af:	8b 12                	mov    (%rdx),%edx
  8004b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b8:	89 0a                	mov    %ecx,(%rdx)
  8004ba:	eb 17                	jmp    8004d3 <getuint+0xb3>
  8004bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004c4:	48 89 d0             	mov    %rdx,%rax
  8004c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d3:	48 8b 00             	mov    (%rax),%rax
  8004d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004da:	eb 4e                	jmp    80052a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e0:	8b 00                	mov    (%rax),%eax
  8004e2:	83 f8 30             	cmp    $0x30,%eax
  8004e5:	73 24                	jae    80050b <getuint+0xeb>
  8004e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004eb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f3:	8b 00                	mov    (%rax),%eax
  8004f5:	89 c0                	mov    %eax,%eax
  8004f7:	48 01 d0             	add    %rdx,%rax
  8004fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fe:	8b 12                	mov    (%rdx),%edx
  800500:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800503:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800507:	89 0a                	mov    %ecx,(%rdx)
  800509:	eb 17                	jmp    800522 <getuint+0x102>
  80050b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800513:	48 89 d0             	mov    %rdx,%rax
  800516:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800522:	8b 00                	mov    (%rax),%eax
  800524:	89 c0                	mov    %eax,%eax
  800526:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80052a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80052e:	c9                   	leaveq 
  80052f:	c3                   	retq   

0000000000800530 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800530:	55                   	push   %rbp
  800531:	48 89 e5             	mov    %rsp,%rbp
  800534:	48 83 ec 20          	sub    $0x20,%rsp
  800538:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80053c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80053f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800543:	7e 52                	jle    800597 <getint+0x67>
		x=va_arg(*ap, long long);
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	83 f8 30             	cmp    $0x30,%eax
  80054e:	73 24                	jae    800574 <getint+0x44>
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	8b 00                	mov    (%rax),%eax
  80055e:	89 c0                	mov    %eax,%eax
  800560:	48 01 d0             	add    %rdx,%rax
  800563:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800567:	8b 12                	mov    (%rdx),%edx
  800569:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800570:	89 0a                	mov    %ecx,(%rdx)
  800572:	eb 17                	jmp    80058b <getint+0x5b>
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80057c:	48 89 d0             	mov    %rdx,%rax
  80057f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800587:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058b:	48 8b 00             	mov    (%rax),%rax
  80058e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800592:	e9 a3 00 00 00       	jmpq   80063a <getint+0x10a>
	else if (lflag)
  800597:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80059b:	74 4f                	je     8005ec <getint+0xbc>
		x=va_arg(*ap, long);
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	8b 00                	mov    (%rax),%eax
  8005a3:	83 f8 30             	cmp    $0x30,%eax
  8005a6:	73 24                	jae    8005cc <getint+0x9c>
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	89 c0                	mov    %eax,%eax
  8005b8:	48 01 d0             	add    %rdx,%rax
  8005bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bf:	8b 12                	mov    (%rdx),%edx
  8005c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c8:	89 0a                	mov    %ecx,(%rdx)
  8005ca:	eb 17                	jmp    8005e3 <getint+0xb3>
  8005cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005d4:	48 89 d0             	mov    %rdx,%rax
  8005d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e3:	48 8b 00             	mov    (%rax),%rax
  8005e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ea:	eb 4e                	jmp    80063a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f0:	8b 00                	mov    (%rax),%eax
  8005f2:	83 f8 30             	cmp    $0x30,%eax
  8005f5:	73 24                	jae    80061b <getint+0xeb>
  8005f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800603:	8b 00                	mov    (%rax),%eax
  800605:	89 c0                	mov    %eax,%eax
  800607:	48 01 d0             	add    %rdx,%rax
  80060a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060e:	8b 12                	mov    (%rdx),%edx
  800610:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800617:	89 0a                	mov    %ecx,(%rdx)
  800619:	eb 17                	jmp    800632 <getint+0x102>
  80061b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800623:	48 89 d0             	mov    %rdx,%rax
  800626:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800632:	8b 00                	mov    (%rax),%eax
  800634:	48 98                	cltq   
  800636:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80063a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80063e:	c9                   	leaveq 
  80063f:	c3                   	retq   

0000000000800640 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	41 54                	push   %r12
  800646:	53                   	push   %rbx
  800647:	48 83 ec 60          	sub    $0x60,%rsp
  80064b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80064f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800653:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800657:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80065b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80065f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800663:	48 8b 0a             	mov    (%rdx),%rcx
  800666:	48 89 08             	mov    %rcx,(%rax)
  800669:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80066d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800671:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800675:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800679:	eb 17                	jmp    800692 <vprintfmt+0x52>
			if (ch == '\0')
  80067b:	85 db                	test   %ebx,%ebx
  80067d:	0f 84 d7 04 00 00    	je     800b5a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800683:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800687:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80068b:	48 89 c6             	mov    %rax,%rsi
  80068e:	89 df                	mov    %ebx,%edi
  800690:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800692:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800696:	0f b6 00             	movzbl (%rax),%eax
  800699:	0f b6 d8             	movzbl %al,%ebx
  80069c:	83 fb 25             	cmp    $0x25,%ebx
  80069f:	0f 95 c0             	setne  %al
  8006a2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006a7:	84 c0                	test   %al,%al
  8006a9:	75 d0                	jne    80067b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006af:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006c4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8006cb:	eb 04                	jmp    8006d1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8006cd:	90                   	nop
  8006ce:	eb 01                	jmp    8006d1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8006d0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006d1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d5:	0f b6 00             	movzbl (%rax),%eax
  8006d8:	0f b6 d8             	movzbl %al,%ebx
  8006db:	89 d8                	mov    %ebx,%eax
  8006dd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006e2:	83 e8 23             	sub    $0x23,%eax
  8006e5:	83 f8 55             	cmp    $0x55,%eax
  8006e8:	0f 87 38 04 00 00    	ja     800b26 <vprintfmt+0x4e6>
  8006ee:	89 c0                	mov    %eax,%eax
  8006f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006f7:	00 
  8006f8:	48 b8 30 3e 80 00 00 	movabs $0x803e30,%rax
  8006ff:	00 00 00 
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 00             	mov    (%rax),%rax
  800708:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80070a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80070e:	eb c1                	jmp    8006d1 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800710:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800714:	eb bb                	jmp    8006d1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800716:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80071d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800720:	89 d0                	mov    %edx,%eax
  800722:	c1 e0 02             	shl    $0x2,%eax
  800725:	01 d0                	add    %edx,%eax
  800727:	01 c0                	add    %eax,%eax
  800729:	01 d8                	add    %ebx,%eax
  80072b:	83 e8 30             	sub    $0x30,%eax
  80072e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800731:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800735:	0f b6 00             	movzbl (%rax),%eax
  800738:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80073b:	83 fb 2f             	cmp    $0x2f,%ebx
  80073e:	7e 63                	jle    8007a3 <vprintfmt+0x163>
  800740:	83 fb 39             	cmp    $0x39,%ebx
  800743:	7f 5e                	jg     8007a3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800745:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80074a:	eb d1                	jmp    80071d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80074c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80074f:	83 f8 30             	cmp    $0x30,%eax
  800752:	73 17                	jae    80076b <vprintfmt+0x12b>
  800754:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800758:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80075b:	89 c0                	mov    %eax,%eax
  80075d:	48 01 d0             	add    %rdx,%rax
  800760:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800763:	83 c2 08             	add    $0x8,%edx
  800766:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800769:	eb 0f                	jmp    80077a <vprintfmt+0x13a>
  80076b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80076f:	48 89 d0             	mov    %rdx,%rax
  800772:	48 83 c2 08          	add    $0x8,%rdx
  800776:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80077a:	8b 00                	mov    (%rax),%eax
  80077c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80077f:	eb 23                	jmp    8007a4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800781:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800785:	0f 89 42 ff ff ff    	jns    8006cd <vprintfmt+0x8d>
				width = 0;
  80078b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800792:	e9 36 ff ff ff       	jmpq   8006cd <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800797:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80079e:	e9 2e ff ff ff       	jmpq   8006d1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007a3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a8:	0f 89 22 ff ff ff    	jns    8006d0 <vprintfmt+0x90>
				width = precision, precision = -1;
  8007ae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007b1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007b4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007bb:	e9 10 ff ff ff       	jmpq   8006d0 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007c0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007c4:	e9 08 ff ff ff       	jmpq   8006d1 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cc:	83 f8 30             	cmp    $0x30,%eax
  8007cf:	73 17                	jae    8007e8 <vprintfmt+0x1a8>
  8007d1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007d5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 01 d0             	add    %rdx,%rax
  8007dd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e0:	83 c2 08             	add    $0x8,%edx
  8007e3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e6:	eb 0f                	jmp    8007f7 <vprintfmt+0x1b7>
  8007e8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ec:	48 89 d0             	mov    %rdx,%rax
  8007ef:	48 83 c2 08          	add    $0x8,%rdx
  8007f3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007f7:	8b 00                	mov    (%rax),%eax
  8007f9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007fd:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800801:	48 89 d6             	mov    %rdx,%rsi
  800804:	89 c7                	mov    %eax,%edi
  800806:	ff d1                	callq  *%rcx
			break;
  800808:	e9 47 03 00 00       	jmpq   800b54 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80080d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800810:	83 f8 30             	cmp    $0x30,%eax
  800813:	73 17                	jae    80082c <vprintfmt+0x1ec>
  800815:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800819:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081c:	89 c0                	mov    %eax,%eax
  80081e:	48 01 d0             	add    %rdx,%rax
  800821:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800824:	83 c2 08             	add    $0x8,%edx
  800827:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80082a:	eb 0f                	jmp    80083b <vprintfmt+0x1fb>
  80082c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800830:	48 89 d0             	mov    %rdx,%rax
  800833:	48 83 c2 08          	add    $0x8,%rdx
  800837:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80083b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	79 02                	jns    800843 <vprintfmt+0x203>
				err = -err;
  800841:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800843:	83 fb 10             	cmp    $0x10,%ebx
  800846:	7f 16                	jg     80085e <vprintfmt+0x21e>
  800848:	48 b8 80 3d 80 00 00 	movabs $0x803d80,%rax
  80084f:	00 00 00 
  800852:	48 63 d3             	movslq %ebx,%rdx
  800855:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800859:	4d 85 e4             	test   %r12,%r12
  80085c:	75 2e                	jne    80088c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80085e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800862:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800866:	89 d9                	mov    %ebx,%ecx
  800868:	48 ba 19 3e 80 00 00 	movabs $0x803e19,%rdx
  80086f:	00 00 00 
  800872:	48 89 c7             	mov    %rax,%rdi
  800875:	b8 00 00 00 00       	mov    $0x0,%eax
  80087a:	49 b8 64 0b 80 00 00 	movabs $0x800b64,%r8
  800881:	00 00 00 
  800884:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800887:	e9 c8 02 00 00       	jmpq   800b54 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80088c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800890:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800894:	4c 89 e1             	mov    %r12,%rcx
  800897:	48 ba 22 3e 80 00 00 	movabs $0x803e22,%rdx
  80089e:	00 00 00 
  8008a1:	48 89 c7             	mov    %rax,%rdi
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a9:	49 b8 64 0b 80 00 00 	movabs $0x800b64,%r8
  8008b0:	00 00 00 
  8008b3:	41 ff d0             	callq  *%r8
			break;
  8008b6:	e9 99 02 00 00       	jmpq   800b54 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008be:	83 f8 30             	cmp    $0x30,%eax
  8008c1:	73 17                	jae    8008da <vprintfmt+0x29a>
  8008c3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ca:	89 c0                	mov    %eax,%eax
  8008cc:	48 01 d0             	add    %rdx,%rax
  8008cf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d2:	83 c2 08             	add    $0x8,%edx
  8008d5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d8:	eb 0f                	jmp    8008e9 <vprintfmt+0x2a9>
  8008da:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008de:	48 89 d0             	mov    %rdx,%rax
  8008e1:	48 83 c2 08          	add    $0x8,%rdx
  8008e5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e9:	4c 8b 20             	mov    (%rax),%r12
  8008ec:	4d 85 e4             	test   %r12,%r12
  8008ef:	75 0a                	jne    8008fb <vprintfmt+0x2bb>
				p = "(null)";
  8008f1:	49 bc 25 3e 80 00 00 	movabs $0x803e25,%r12
  8008f8:	00 00 00 
			if (width > 0 && padc != '-')
  8008fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ff:	7e 7a                	jle    80097b <vprintfmt+0x33b>
  800901:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800905:	74 74                	je     80097b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800907:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80090a:	48 98                	cltq   
  80090c:	48 89 c6             	mov    %rax,%rsi
  80090f:	4c 89 e7             	mov    %r12,%rdi
  800912:	48 b8 0e 0e 80 00 00 	movabs $0x800e0e,%rax
  800919:	00 00 00 
  80091c:	ff d0                	callq  *%rax
  80091e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800921:	eb 17                	jmp    80093a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800923:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800927:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80092f:	48 89 d6             	mov    %rdx,%rsi
  800932:	89 c7                	mov    %eax,%edi
  800934:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80093a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80093e:	7f e3                	jg     800923 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800940:	eb 39                	jmp    80097b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800942:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800946:	74 1e                	je     800966 <vprintfmt+0x326>
  800948:	83 fb 1f             	cmp    $0x1f,%ebx
  80094b:	7e 05                	jle    800952 <vprintfmt+0x312>
  80094d:	83 fb 7e             	cmp    $0x7e,%ebx
  800950:	7e 14                	jle    800966 <vprintfmt+0x326>
					putch('?', putdat);
  800952:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800956:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80095a:	48 89 c6             	mov    %rax,%rsi
  80095d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800962:	ff d2                	callq  *%rdx
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800966:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80096a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80096e:	48 89 c6             	mov    %rax,%rsi
  800971:	89 df                	mov    %ebx,%edi
  800973:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800979:	eb 01                	jmp    80097c <vprintfmt+0x33c>
  80097b:	90                   	nop
  80097c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800981:	0f be d8             	movsbl %al,%ebx
  800984:	85 db                	test   %ebx,%ebx
  800986:	0f 95 c0             	setne  %al
  800989:	49 83 c4 01          	add    $0x1,%r12
  80098d:	84 c0                	test   %al,%al
  80098f:	74 28                	je     8009b9 <vprintfmt+0x379>
  800991:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800995:	78 ab                	js     800942 <vprintfmt+0x302>
  800997:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80099b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80099f:	79 a1                	jns    800942 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a1:	eb 16                	jmp    8009b9 <vprintfmt+0x379>
				putch(' ', putdat);
  8009a3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009a7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009ab:	48 89 c6             	mov    %rax,%rsi
  8009ae:	bf 20 00 00 00       	mov    $0x20,%edi
  8009b3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009bd:	7f e4                	jg     8009a3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8009bf:	e9 90 01 00 00       	jmpq   800b54 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c8:	be 03 00 00 00       	mov    $0x3,%esi
  8009cd:	48 89 c7             	mov    %rax,%rdi
  8009d0:	48 b8 30 05 80 00 00 	movabs $0x800530,%rax
  8009d7:	00 00 00 
  8009da:	ff d0                	callq  *%rax
  8009dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	48 85 c0             	test   %rax,%rax
  8009e7:	79 1d                	jns    800a06 <vprintfmt+0x3c6>
				putch('-', putdat);
  8009e9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009ed:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009f1:	48 89 c6             	mov    %rax,%rsi
  8009f4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009f9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8009fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ff:	48 f7 d8             	neg    %rax
  800a02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a06:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a0d:	e9 d5 00 00 00       	jmpq   800ae7 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a12:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a16:	be 03 00 00 00       	mov    $0x3,%esi
  800a1b:	48 89 c7             	mov    %rax,%rdi
  800a1e:	48 b8 20 04 80 00 00 	movabs $0x800420,%rax
  800a25:	00 00 00 
  800a28:	ff d0                	callq  *%rax
  800a2a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a2e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a35:	e9 ad 00 00 00       	jmpq   800ae7 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800a3a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a3e:	be 03 00 00 00       	mov    $0x3,%esi
  800a43:	48 89 c7             	mov    %rax,%rdi
  800a46:	48 b8 20 04 80 00 00 	movabs $0x800420,%rax
  800a4d:	00 00 00 
  800a50:	ff d0                	callq  *%rax
  800a52:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800a56:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a5d:	e9 85 00 00 00       	jmpq   800ae7 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a62:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a66:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a6a:	48 89 c6             	mov    %rax,%rsi
  800a6d:	bf 30 00 00 00       	mov    $0x30,%edi
  800a72:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800a74:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a78:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a7c:	48 89 c6             	mov    %rax,%rsi
  800a7f:	bf 78 00 00 00       	mov    $0x78,%edi
  800a84:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a89:	83 f8 30             	cmp    $0x30,%eax
  800a8c:	73 17                	jae    800aa5 <vprintfmt+0x465>
  800a8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a95:	89 c0                	mov    %eax,%eax
  800a97:	48 01 d0             	add    %rdx,%rax
  800a9a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9d:	83 c2 08             	add    $0x8,%edx
  800aa0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa3:	eb 0f                	jmp    800ab4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800aa5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa9:	48 89 d0             	mov    %rdx,%rax
  800aac:	48 83 c2 08          	add    $0x8,%rdx
  800ab0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ab7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800abb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ac2:	eb 23                	jmp    800ae7 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ac4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac8:	be 03 00 00 00       	mov    $0x3,%esi
  800acd:	48 89 c7             	mov    %rax,%rdi
  800ad0:	48 b8 20 04 80 00 00 	movabs $0x800420,%rax
  800ad7:	00 00 00 
  800ada:	ff d0                	callq  *%rax
  800adc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ae0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ae7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800aec:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aef:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800af2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800afa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afe:	45 89 c1             	mov    %r8d,%r9d
  800b01:	41 89 f8             	mov    %edi,%r8d
  800b04:	48 89 c7             	mov    %rax,%rdi
  800b07:	48 b8 68 03 80 00 00 	movabs $0x800368,%rax
  800b0e:	00 00 00 
  800b11:	ff d0                	callq  *%rax
			break;
  800b13:	eb 3f                	jmp    800b54 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b15:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b19:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b1d:	48 89 c6             	mov    %rax,%rsi
  800b20:	89 df                	mov    %ebx,%edi
  800b22:	ff d2                	callq  *%rdx
			break;
  800b24:	eb 2e                	jmp    800b54 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b26:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b2a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b2e:	48 89 c6             	mov    %rax,%rsi
  800b31:	bf 25 00 00 00       	mov    $0x25,%edi
  800b36:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b38:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b3d:	eb 05                	jmp    800b44 <vprintfmt+0x504>
  800b3f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b44:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b48:	48 83 e8 01          	sub    $0x1,%rax
  800b4c:	0f b6 00             	movzbl (%rax),%eax
  800b4f:	3c 25                	cmp    $0x25,%al
  800b51:	75 ec                	jne    800b3f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800b53:	90                   	nop
		}
	}
  800b54:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b55:	e9 38 fb ff ff       	jmpq   800692 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800b5a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800b5b:	48 83 c4 60          	add    $0x60,%rsp
  800b5f:	5b                   	pop    %rbx
  800b60:	41 5c                	pop    %r12
  800b62:	5d                   	pop    %rbp
  800b63:	c3                   	retq   

0000000000800b64 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b64:	55                   	push   %rbp
  800b65:	48 89 e5             	mov    %rsp,%rbp
  800b68:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b6f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b76:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b7d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b84:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b8b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b92:	84 c0                	test   %al,%al
  800b94:	74 20                	je     800bb6 <printfmt+0x52>
  800b96:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b9a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b9e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ba2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ba6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800baa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bb2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bb6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bbd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800bc4:	00 00 00 
  800bc7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bce:	00 00 00 
  800bd1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bd5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bdc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800be3:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bea:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bf1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bf8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bff:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c06:	48 89 c7             	mov    %rax,%rdi
  800c09:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c10:	00 00 00 
  800c13:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c15:	c9                   	leaveq 
  800c16:	c3                   	retq   

0000000000800c17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c17:	55                   	push   %rbp
  800c18:	48 89 e5             	mov    %rsp,%rbp
  800c1b:	48 83 ec 10          	sub    $0x10,%rsp
  800c1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2a:	8b 40 10             	mov    0x10(%rax),%eax
  800c2d:	8d 50 01             	lea    0x1(%rax),%edx
  800c30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c34:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c3b:	48 8b 10             	mov    (%rax),%rdx
  800c3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c42:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c46:	48 39 c2             	cmp    %rax,%rdx
  800c49:	73 17                	jae    800c62 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c4f:	48 8b 00             	mov    (%rax),%rax
  800c52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c55:	88 10                	mov    %dl,(%rax)
  800c57:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5f:	48 89 10             	mov    %rdx,(%rax)
}
  800c62:	c9                   	leaveq 
  800c63:	c3                   	retq   

0000000000800c64 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c64:	55                   	push   %rbp
  800c65:	48 89 e5             	mov    %rsp,%rbp
  800c68:	48 83 ec 50          	sub    $0x50,%rsp
  800c6c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c70:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c73:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c77:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c7b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c7f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c83:	48 8b 0a             	mov    (%rdx),%rcx
  800c86:	48 89 08             	mov    %rcx,(%rax)
  800c89:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c8d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c91:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c95:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c99:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c9d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ca1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ca4:	48 98                	cltq   
  800ca6:	48 83 e8 01          	sub    $0x1,%rax
  800caa:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800cae:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cb2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cb9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cbe:	74 06                	je     800cc6 <vsnprintf+0x62>
  800cc0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800cc4:	7f 07                	jg     800ccd <vsnprintf+0x69>
		return -E_INVAL;
  800cc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ccb:	eb 2f                	jmp    800cfc <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ccd:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cd1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cd5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cd9:	48 89 c6             	mov    %rax,%rsi
  800cdc:	48 bf 17 0c 80 00 00 	movabs $0x800c17,%rdi
  800ce3:	00 00 00 
  800ce6:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800ced:	00 00 00 
  800cf0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cf6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cf9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cfc:	c9                   	leaveq 
  800cfd:	c3                   	retq   

0000000000800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %rbp
  800cff:	48 89 e5             	mov    %rsp,%rbp
  800d02:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d09:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d10:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d16:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d1d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d24:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d2b:	84 c0                	test   %al,%al
  800d2d:	74 20                	je     800d4f <snprintf+0x51>
  800d2f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d33:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d37:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d3b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d3f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d43:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d47:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d4b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d4f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d56:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d5d:	00 00 00 
  800d60:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d67:	00 00 00 
  800d6a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d6e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d75:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d7c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d83:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d8a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d91:	48 8b 0a             	mov    (%rdx),%rcx
  800d94:	48 89 08             	mov    %rcx,(%rax)
  800d97:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d9b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d9f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800da3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800da7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dae:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800db5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dbb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800dc2:	48 89 c7             	mov    %rax,%rdi
  800dc5:	48 b8 64 0c 80 00 00 	movabs $0x800c64,%rax
  800dcc:	00 00 00 
  800dcf:	ff d0                	callq  *%rax
  800dd1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800dd7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ddd:	c9                   	leaveq 
  800dde:	c3                   	retq   
	...

0000000000800de0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800de0:	55                   	push   %rbp
  800de1:	48 89 e5             	mov    %rsp,%rbp
  800de4:	48 83 ec 18          	sub    $0x18,%rsp
  800de8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800df3:	eb 09                	jmp    800dfe <strlen+0x1e>
		n++;
  800df5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e02:	0f b6 00             	movzbl (%rax),%eax
  800e05:	84 c0                	test   %al,%al
  800e07:	75 ec                	jne    800df5 <strlen+0x15>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e0c:	c9                   	leaveq 
  800e0d:	c3                   	retq   

0000000000800e0e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e0e:	55                   	push   %rbp
  800e0f:	48 89 e5             	mov    %rsp,%rbp
  800e12:	48 83 ec 20          	sub    $0x20,%rsp
  800e16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e25:	eb 0e                	jmp    800e35 <strnlen+0x27>
		n++;
  800e27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e30:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e35:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e3a:	74 0b                	je     800e47 <strnlen+0x39>
  800e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e40:	0f b6 00             	movzbl (%rax),%eax
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e0                	jne    800e27 <strnlen+0x19>
		n++;
	return n;
  800e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e4a:	c9                   	leaveq 
  800e4b:	c3                   	retq   

0000000000800e4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e4c:	55                   	push   %rbp
  800e4d:	48 89 e5             	mov    %rsp,%rbp
  800e50:	48 83 ec 20          	sub    $0x20,%rsp
  800e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e64:	90                   	nop
  800e65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e69:	0f b6 10             	movzbl (%rax),%edx
  800e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e70:	88 10                	mov    %dl,(%rax)
  800e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e76:	0f b6 00             	movzbl (%rax),%eax
  800e79:	84 c0                	test   %al,%al
  800e7b:	0f 95 c0             	setne  %al
  800e7e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e83:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800e88:	84 c0                	test   %al,%al
  800e8a:	75 d9                	jne    800e65 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e90:	c9                   	leaveq 
  800e91:	c3                   	retq   

0000000000800e92 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e92:	55                   	push   %rbp
  800e93:	48 89 e5             	mov    %rsp,%rbp
  800e96:	48 83 ec 20          	sub    $0x20,%rsp
  800e9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ea2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea6:	48 89 c7             	mov    %rax,%rdi
  800ea9:	48 b8 e0 0d 80 00 00 	movabs $0x800de0,%rax
  800eb0:	00 00 00 
  800eb3:	ff d0                	callq  *%rax
  800eb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ebb:	48 98                	cltq   
  800ebd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800ec1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec5:	48 89 d6             	mov    %rdx,%rsi
  800ec8:	48 89 c7             	mov    %rax,%rdi
  800ecb:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  800ed2:	00 00 00 
  800ed5:	ff d0                	callq  *%rax
	return dst;
  800ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800edb:	c9                   	leaveq 
  800edc:	c3                   	retq   

0000000000800edd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 83 ec 28          	sub    $0x28,%rsp
  800ee5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800eed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ef1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ef9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f00:	00 
  800f01:	eb 27                	jmp    800f2a <strncpy+0x4d>
		*dst++ = *src;
  800f03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f07:	0f b6 10             	movzbl (%rax),%edx
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	88 10                	mov    %dl,(%rax)
  800f10:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f19:	0f b6 00             	movzbl (%rax),%eax
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 05                	je     800f25 <strncpy+0x48>
			src++;
  800f20:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f25:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f2e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f32:	72 cf                	jb     800f03 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f38:	c9                   	leaveq 
  800f39:	c3                   	retq   

0000000000800f3a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f3a:	55                   	push   %rbp
  800f3b:	48 89 e5             	mov    %rsp,%rbp
  800f3e:	48 83 ec 28          	sub    $0x28,%rsp
  800f42:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f46:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f4a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f56:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f5b:	74 37                	je     800f94 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800f5d:	eb 17                	jmp    800f76 <strlcpy+0x3c>
			*dst++ = *src++;
  800f5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f63:	0f b6 10             	movzbl (%rax),%edx
  800f66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6a:	88 10                	mov    %dl,(%rax)
  800f6c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f71:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f76:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f7b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f80:	74 0b                	je     800f8d <strlcpy+0x53>
  800f82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f86:	0f b6 00             	movzbl (%rax),%eax
  800f89:	84 c0                	test   %al,%al
  800f8b:	75 d2                	jne    800f5f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f91:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9c:	48 89 d1             	mov    %rdx,%rcx
  800f9f:	48 29 c1             	sub    %rax,%rcx
  800fa2:	48 89 c8             	mov    %rcx,%rax
}
  800fa5:	c9                   	leaveq 
  800fa6:	c3                   	retq   

0000000000800fa7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa7:	55                   	push   %rbp
  800fa8:	48 89 e5             	mov    %rsp,%rbp
  800fab:	48 83 ec 10          	sub    $0x10,%rsp
  800faf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fb7:	eb 0a                	jmp    800fc3 <strcmp+0x1c>
		p++, q++;
  800fb9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fbe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc7:	0f b6 00             	movzbl (%rax),%eax
  800fca:	84 c0                	test   %al,%al
  800fcc:	74 12                	je     800fe0 <strcmp+0x39>
  800fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd2:	0f b6 10             	movzbl (%rax),%edx
  800fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd9:	0f b6 00             	movzbl (%rax),%eax
  800fdc:	38 c2                	cmp    %al,%dl
  800fde:	74 d9                	je     800fb9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fe4:	0f b6 00             	movzbl (%rax),%eax
  800fe7:	0f b6 d0             	movzbl %al,%edx
  800fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fee:	0f b6 00             	movzbl (%rax),%eax
  800ff1:	0f b6 c0             	movzbl %al,%eax
  800ff4:	89 d1                	mov    %edx,%ecx
  800ff6:	29 c1                	sub    %eax,%ecx
  800ff8:	89 c8                	mov    %ecx,%eax
}
  800ffa:	c9                   	leaveq 
  800ffb:	c3                   	retq   

0000000000800ffc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 83 ec 18          	sub    $0x18,%rsp
  801004:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801008:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80100c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801010:	eb 0f                	jmp    801021 <strncmp+0x25>
		n--, p++, q++;
  801012:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801017:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80101c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801021:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801026:	74 1d                	je     801045 <strncmp+0x49>
  801028:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102c:	0f b6 00             	movzbl (%rax),%eax
  80102f:	84 c0                	test   %al,%al
  801031:	74 12                	je     801045 <strncmp+0x49>
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	0f b6 10             	movzbl (%rax),%edx
  80103a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103e:	0f b6 00             	movzbl (%rax),%eax
  801041:	38 c2                	cmp    %al,%dl
  801043:	74 cd                	je     801012 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801045:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80104a:	75 07                	jne    801053 <strncmp+0x57>
		return 0;
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
  801051:	eb 1a                	jmp    80106d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	0f b6 d0             	movzbl %al,%edx
  80105d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801061:	0f b6 00             	movzbl (%rax),%eax
  801064:	0f b6 c0             	movzbl %al,%eax
  801067:	89 d1                	mov    %edx,%ecx
  801069:	29 c1                	sub    %eax,%ecx
  80106b:	89 c8                	mov    %ecx,%eax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 10          	sub    $0x10,%rsp
  801077:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80107b:	89 f0                	mov    %esi,%eax
  80107d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801080:	eb 17                	jmp    801099 <strchr+0x2a>
		if (*s == c)
  801082:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80108c:	75 06                	jne    801094 <strchr+0x25>
			return (char *) s;
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801092:	eb 15                	jmp    8010a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109d:	0f b6 00             	movzbl (%rax),%eax
  8010a0:	84 c0                	test   %al,%al
  8010a2:	75 de                	jne    801082 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a9:	c9                   	leaveq 
  8010aa:	c3                   	retq   

00000000008010ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ab:	55                   	push   %rbp
  8010ac:	48 89 e5             	mov    %rsp,%rbp
  8010af:	48 83 ec 10          	sub    $0x10,%rsp
  8010b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b7:	89 f0                	mov    %esi,%eax
  8010b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010bc:	eb 11                	jmp    8010cf <strfind+0x24>
		if (*s == c)
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010c8:	74 12                	je     8010dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d3:	0f b6 00             	movzbl (%rax),%eax
  8010d6:	84 c0                	test   %al,%al
  8010d8:	75 e4                	jne    8010be <strfind+0x13>
  8010da:	eb 01                	jmp    8010dd <strfind+0x32>
		if (*s == c)
			break;
  8010dc:	90                   	nop
	return (char *) s;
  8010dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 18          	sub    $0x18,%rsp
  8010eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ef:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010fb:	75 06                	jne    801103 <memset+0x20>
		return v;
  8010fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801101:	eb 69                	jmp    80116c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	83 e0 03             	and    $0x3,%eax
  80110a:	48 85 c0             	test   %rax,%rax
  80110d:	75 48                	jne    801157 <memset+0x74>
  80110f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801113:	83 e0 03             	and    $0x3,%eax
  801116:	48 85 c0             	test   %rax,%rax
  801119:	75 3c                	jne    801157 <memset+0x74>
		c &= 0xFF;
  80111b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801122:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801125:	89 c2                	mov    %eax,%edx
  801127:	c1 e2 18             	shl    $0x18,%edx
  80112a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112d:	c1 e0 10             	shl    $0x10,%eax
  801130:	09 c2                	or     %eax,%edx
  801132:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801135:	c1 e0 08             	shl    $0x8,%eax
  801138:	09 d0                	or     %edx,%eax
  80113a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 89 c1             	mov    %rax,%rcx
  801144:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801148:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80114c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114f:	48 89 d7             	mov    %rdx,%rdi
  801152:	fc                   	cld    
  801153:	f3 ab                	rep stos %eax,%es:(%rdi)
  801155:	eb 11                	jmp    801168 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801157:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80115b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80115e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801162:	48 89 d7             	mov    %rdx,%rdi
  801165:	fc                   	cld    
  801166:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80116c:	c9                   	leaveq 
  80116d:	c3                   	retq   

000000000080116e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80116e:	55                   	push   %rbp
  80116f:	48 89 e5             	mov    %rsp,%rbp
  801172:	48 83 ec 28          	sub    $0x28,%rsp
  801176:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80117e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801182:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801186:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80118a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801196:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80119a:	0f 83 88 00 00 00    	jae    801228 <memmove+0xba>
  8011a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a8:	48 01 d0             	add    %rdx,%rax
  8011ab:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011af:	76 77                	jbe    801228 <memmove+0xba>
		s += n;
  8011b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c5:	83 e0 03             	and    $0x3,%eax
  8011c8:	48 85 c0             	test   %rax,%rax
  8011cb:	75 3b                	jne    801208 <memmove+0x9a>
  8011cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d1:	83 e0 03             	and    $0x3,%eax
  8011d4:	48 85 c0             	test   %rax,%rax
  8011d7:	75 2f                	jne    801208 <memmove+0x9a>
  8011d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	48 85 c0             	test   %rax,%rax
  8011e3:	75 23                	jne    801208 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e9:	48 83 e8 04          	sub    $0x4,%rax
  8011ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f1:	48 83 ea 04          	sub    $0x4,%rdx
  8011f5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011f9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011fd:	48 89 c7             	mov    %rax,%rdi
  801200:	48 89 d6             	mov    %rdx,%rsi
  801203:	fd                   	std    
  801204:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801206:	eb 1d                	jmp    801225 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801214:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801218:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121c:	48 89 d7             	mov    %rdx,%rdi
  80121f:	48 89 c1             	mov    %rax,%rcx
  801222:	fd                   	std    
  801223:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801225:	fc                   	cld    
  801226:	eb 57                	jmp    80127f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801228:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122c:	83 e0 03             	and    $0x3,%eax
  80122f:	48 85 c0             	test   %rax,%rax
  801232:	75 36                	jne    80126a <memmove+0xfc>
  801234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801238:	83 e0 03             	and    $0x3,%eax
  80123b:	48 85 c0             	test   %rax,%rax
  80123e:	75 2a                	jne    80126a <memmove+0xfc>
  801240:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801244:	83 e0 03             	and    $0x3,%eax
  801247:	48 85 c0             	test   %rax,%rax
  80124a:	75 1e                	jne    80126a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 89 c1             	mov    %rax,%rcx
  801253:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80125f:	48 89 c7             	mov    %rax,%rdi
  801262:	48 89 d6             	mov    %rdx,%rsi
  801265:	fc                   	cld    
  801266:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801268:	eb 15                	jmp    80127f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80126a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801272:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 89 d6             	mov    %rdx,%rsi
  80127c:	fc                   	cld    
  80127d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801283:	c9                   	leaveq 
  801284:	c3                   	retq   

0000000000801285 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	48 83 ec 18          	sub    $0x18,%rsp
  80128d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801291:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801295:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801299:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	48 89 ce             	mov    %rcx,%rsi
  8012a8:	48 89 c7             	mov    %rax,%rdi
  8012ab:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  8012b2:	00 00 00 
  8012b5:	ff d0                	callq  *%rax
}
  8012b7:	c9                   	leaveq 
  8012b8:	c3                   	retq   

00000000008012b9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012b9:	55                   	push   %rbp
  8012ba:	48 89 e5             	mov    %rsp,%rbp
  8012bd:	48 83 ec 28          	sub    $0x28,%rsp
  8012c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012dd:	eb 38                	jmp    801317 <memcmp+0x5e>
		if (*s1 != *s2)
  8012df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e3:	0f b6 10             	movzbl (%rax),%edx
  8012e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ea:	0f b6 00             	movzbl (%rax),%eax
  8012ed:	38 c2                	cmp    %al,%dl
  8012ef:	74 1c                	je     80130d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8012f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	0f b6 d0             	movzbl %al,%edx
  8012fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	0f b6 c0             	movzbl %al,%eax
  801305:	89 d1                	mov    %edx,%ecx
  801307:	29 c1                	sub    %eax,%ecx
  801309:	89 c8                	mov    %ecx,%eax
  80130b:	eb 20                	jmp    80132d <memcmp+0x74>
		s1++, s2++;
  80130d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801312:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801317:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80131c:	0f 95 c0             	setne  %al
  80131f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801324:	84 c0                	test   %al,%al
  801326:	75 b7                	jne    8012df <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 28          	sub    $0x28,%rsp
  801337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80133b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80133e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801346:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80134a:	48 01 d0             	add    %rdx,%rax
  80134d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801351:	eb 13                	jmp    801366 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801357:	0f b6 10             	movzbl (%rax),%edx
  80135a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80135d:	38 c2                	cmp    %al,%dl
  80135f:	74 11                	je     801372 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801361:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80136e:	72 e3                	jb     801353 <memfind+0x24>
  801370:	eb 01                	jmp    801373 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801372:	90                   	nop
	return (void *) s;
  801373:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801377:	c9                   	leaveq 
  801378:	c3                   	retq   

0000000000801379 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801379:	55                   	push   %rbp
  80137a:	48 89 e5             	mov    %rsp,%rbp
  80137d:	48 83 ec 38          	sub    $0x38,%rsp
  801381:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801385:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801389:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801393:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80139a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139b:	eb 05                	jmp    8013a2 <strtol+0x29>
		s++;
  80139d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a6:	0f b6 00             	movzbl (%rax),%eax
  8013a9:	3c 20                	cmp    $0x20,%al
  8013ab:	74 f0                	je     80139d <strtol+0x24>
  8013ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	3c 09                	cmp    $0x9,%al
  8013b6:	74 e5                	je     80139d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	0f b6 00             	movzbl (%rax),%eax
  8013bf:	3c 2b                	cmp    $0x2b,%al
  8013c1:	75 07                	jne    8013ca <strtol+0x51>
		s++;
  8013c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013c8:	eb 17                	jmp    8013e1 <strtol+0x68>
	else if (*s == '-')
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	3c 2d                	cmp    $0x2d,%al
  8013d3:	75 0c                	jne    8013e1 <strtol+0x68>
		s++, neg = 1;
  8013d5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013e5:	74 06                	je     8013ed <strtol+0x74>
  8013e7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013eb:	75 28                	jne    801415 <strtol+0x9c>
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	3c 30                	cmp    $0x30,%al
  8013f6:	75 1d                	jne    801415 <strtol+0x9c>
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	48 83 c0 01          	add    $0x1,%rax
  801400:	0f b6 00             	movzbl (%rax),%eax
  801403:	3c 78                	cmp    $0x78,%al
  801405:	75 0e                	jne    801415 <strtol+0x9c>
		s += 2, base = 16;
  801407:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80140c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801413:	eb 2c                	jmp    801441 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801415:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801419:	75 19                	jne    801434 <strtol+0xbb>
  80141b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141f:	0f b6 00             	movzbl (%rax),%eax
  801422:	3c 30                	cmp    $0x30,%al
  801424:	75 0e                	jne    801434 <strtol+0xbb>
		s++, base = 8;
  801426:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80142b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801432:	eb 0d                	jmp    801441 <strtol+0xc8>
	else if (base == 0)
  801434:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801438:	75 07                	jne    801441 <strtol+0xc8>
		base = 10;
  80143a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801441:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801445:	0f b6 00             	movzbl (%rax),%eax
  801448:	3c 2f                	cmp    $0x2f,%al
  80144a:	7e 1d                	jle    801469 <strtol+0xf0>
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	3c 39                	cmp    $0x39,%al
  801455:	7f 12                	jg     801469 <strtol+0xf0>
			dig = *s - '0';
  801457:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	0f be c0             	movsbl %al,%eax
  801461:	83 e8 30             	sub    $0x30,%eax
  801464:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801467:	eb 4e                	jmp    8014b7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801469:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	3c 60                	cmp    $0x60,%al
  801472:	7e 1d                	jle    801491 <strtol+0x118>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	3c 7a                	cmp    $0x7a,%al
  80147d:	7f 12                	jg     801491 <strtol+0x118>
			dig = *s - 'a' + 10;
  80147f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	0f be c0             	movsbl %al,%eax
  801489:	83 e8 57             	sub    $0x57,%eax
  80148c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80148f:	eb 26                	jmp    8014b7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	3c 40                	cmp    $0x40,%al
  80149a:	7e 47                	jle    8014e3 <strtol+0x16a>
  80149c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	3c 5a                	cmp    $0x5a,%al
  8014a5:	7f 3c                	jg     8014e3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8014a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	83 e8 37             	sub    $0x37,%eax
  8014b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ba:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014bd:	7d 23                	jge    8014e2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014c4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014c7:	48 98                	cltq   
  8014c9:	48 89 c2             	mov    %rax,%rdx
  8014cc:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8014d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d4:	48 98                	cltq   
  8014d6:	48 01 d0             	add    %rdx,%rax
  8014d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014dd:	e9 5f ff ff ff       	jmpq   801441 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014e3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014e8:	74 0b                	je     8014f5 <strtol+0x17c>
		*endptr = (char *) s;
  8014ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014f2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014f9:	74 09                	je     801504 <strtol+0x18b>
  8014fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ff:	48 f7 d8             	neg    %rax
  801502:	eb 04                	jmp    801508 <strtol+0x18f>
  801504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801508:	c9                   	leaveq 
  801509:	c3                   	retq   

000000000080150a <strstr>:

char * strstr(const char *in, const char *str)
{
  80150a:	55                   	push   %rbp
  80150b:	48 89 e5             	mov    %rsp,%rbp
  80150e:	48 83 ec 30          	sub    $0x30,%rsp
  801512:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801516:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80151a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151e:	0f b6 00             	movzbl (%rax),%eax
  801521:	88 45 ff             	mov    %al,-0x1(%rbp)
  801524:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801529:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80152d:	75 06                	jne    801535 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	eb 68                	jmp    80159d <strstr+0x93>

    len = strlen(str);
  801535:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801539:	48 89 c7             	mov    %rax,%rdi
  80153c:	48 b8 e0 0d 80 00 00 	movabs $0x800de0,%rax
  801543:	00 00 00 
  801546:	ff d0                	callq  *%rax
  801548:	48 98                	cltq   
  80154a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80154e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801552:	0f b6 00             	movzbl (%rax),%eax
  801555:	88 45 ef             	mov    %al,-0x11(%rbp)
  801558:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80155d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801561:	75 07                	jne    80156a <strstr+0x60>
                return (char *) 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 33                	jmp    80159d <strstr+0x93>
        } while (sc != c);
  80156a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80156e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801571:	75 db                	jne    80154e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801573:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801577:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 89 ce             	mov    %rcx,%rsi
  801582:	48 89 c7             	mov    %rax,%rdi
  801585:	48 b8 fc 0f 80 00 00 	movabs $0x800ffc,%rax
  80158c:	00 00 00 
  80158f:	ff d0                	callq  *%rax
  801591:	85 c0                	test   %eax,%eax
  801593:	75 b9                	jne    80154e <strstr+0x44>

    return (char *) (in - 1);
  801595:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801599:	48 83 e8 01          	sub    $0x1,%rax
}
  80159d:	c9                   	leaveq 
  80159e:	c3                   	retq   
	...

00000000008015a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015a0:	55                   	push   %rbp
  8015a1:	48 89 e5             	mov    %rsp,%rbp
  8015a4:	53                   	push   %rbx
  8015a5:	48 83 ec 58          	sub    $0x58,%rsp
  8015a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015ac:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015af:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015b3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015b7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015bb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015bf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015c2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8015c5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015c9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015cd:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015d1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015d5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015d9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8015dc:	4c 89 c3             	mov    %r8,%rbx
  8015df:	cd 30                	int    $0x30
  8015e1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8015e5:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8015e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015f1:	74 3e                	je     801631 <syscall+0x91>
  8015f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f8:	7e 37                	jle    801631 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801601:	49 89 d0             	mov    %rdx,%r8
  801604:	89 c1                	mov    %eax,%ecx
  801606:	48 ba e0 40 80 00 00 	movabs $0x8040e0,%rdx
  80160d:	00 00 00 
  801610:	be 23 00 00 00       	mov    $0x23,%esi
  801615:	48 bf fd 40 80 00 00 	movabs $0x8040fd,%rdi
  80161c:	00 00 00 
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
  801624:	49 b9 54 38 80 00 00 	movabs $0x803854,%r9
  80162b:	00 00 00 
  80162e:	41 ff d1             	callq  *%r9

	return ret;
  801631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801635:	48 83 c4 58          	add    $0x58,%rsp
  801639:	5b                   	pop    %rbx
  80163a:	5d                   	pop    %rbp
  80163b:	c3                   	retq   

000000000080163c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 20          	sub    $0x20,%rsp
  801644:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80164c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801654:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80165b:	00 
  80165c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801662:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801668:	48 89 d1             	mov    %rdx,%rcx
  80166b:	48 89 c2             	mov    %rax,%rdx
  80166e:	be 00 00 00 00       	mov    $0x0,%esi
  801673:	bf 00 00 00 00       	mov    $0x0,%edi
  801678:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  80167f:	00 00 00 
  801682:	ff d0                	callq  *%rax
}
  801684:	c9                   	leaveq 
  801685:	c3                   	retq   

0000000000801686 <sys_cgetc>:

int
sys_cgetc(void)
{
  801686:	55                   	push   %rbp
  801687:	48 89 e5             	mov    %rsp,%rbp
  80168a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80168e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801695:	00 
  801696:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	be 00 00 00 00       	mov    $0x0,%esi
  8016b1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016b6:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8016bd:	00 00 00 
  8016c0:	ff d0                	callq  *%rax
}
  8016c2:	c9                   	leaveq 
  8016c3:	c3                   	retq   

00000000008016c4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016c4:	55                   	push   %rbp
  8016c5:	48 89 e5             	mov    %rsp,%rbp
  8016c8:	48 83 ec 20          	sub    $0x20,%rsp
  8016cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016d2:	48 98                	cltq   
  8016d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016db:	00 
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016ed:	48 89 c2             	mov    %rax,%rdx
  8016f0:	be 01 00 00 00       	mov    $0x1,%esi
  8016f5:	bf 03 00 00 00       	mov    $0x3,%edi
  8016fa:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801701:	00 00 00 
  801704:	ff d0                	callq  *%rax
}
  801706:	c9                   	leaveq 
  801707:	c3                   	retq   

0000000000801708 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
  80170c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801710:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801717:	00 
  801718:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801724:	b9 00 00 00 00       	mov    $0x0,%ecx
  801729:	ba 00 00 00 00       	mov    $0x0,%edx
  80172e:	be 00 00 00 00       	mov    $0x0,%esi
  801733:	bf 02 00 00 00       	mov    $0x2,%edi
  801738:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  80173f:	00 00 00 
  801742:	ff d0                	callq  *%rax
}
  801744:	c9                   	leaveq 
  801745:	c3                   	retq   

0000000000801746 <sys_yield>:

void
sys_yield(void)
{
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80174e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801755:	00 
  801756:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	be 00 00 00 00       	mov    $0x0,%esi
  801771:	bf 0b 00 00 00       	mov    $0xb,%edi
  801776:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
}
  801782:	c9                   	leaveq 
  801783:	c3                   	retq   

0000000000801784 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801784:	55                   	push   %rbp
  801785:	48 89 e5             	mov    %rsp,%rbp
  801788:	48 83 ec 20          	sub    $0x20,%rsp
  80178c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80178f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801793:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801796:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801799:	48 63 c8             	movslq %eax,%rcx
  80179c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a3:	48 98                	cltq   
  8017a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ac:	00 
  8017ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b3:	49 89 c8             	mov    %rcx,%r8
  8017b6:	48 89 d1             	mov    %rdx,%rcx
  8017b9:	48 89 c2             	mov    %rax,%rdx
  8017bc:	be 01 00 00 00       	mov    $0x1,%esi
  8017c1:	bf 04 00 00 00       	mov    $0x4,%edi
  8017c6:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
}
  8017d2:	c9                   	leaveq 
  8017d3:	c3                   	retq   

00000000008017d4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 83 ec 30          	sub    $0x30,%rsp
  8017dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e3:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017e6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017ea:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017ee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017f1:	48 63 c8             	movslq %eax,%rcx
  8017f4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017fb:	48 63 f0             	movslq %eax,%rsi
  8017fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801805:	48 98                	cltq   
  801807:	48 89 0c 24          	mov    %rcx,(%rsp)
  80180b:	49 89 f9             	mov    %rdi,%r9
  80180e:	49 89 f0             	mov    %rsi,%r8
  801811:	48 89 d1             	mov    %rdx,%rcx
  801814:	48 89 c2             	mov    %rax,%rdx
  801817:	be 01 00 00 00       	mov    $0x1,%esi
  80181c:	bf 05 00 00 00       	mov    $0x5,%edi
  801821:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801828:	00 00 00 
  80182b:	ff d0                	callq  *%rax
}
  80182d:	c9                   	leaveq 
  80182e:	c3                   	retq   

000000000080182f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80182f:	55                   	push   %rbp
  801830:	48 89 e5             	mov    %rsp,%rbp
  801833:	48 83 ec 20          	sub    $0x20,%rsp
  801837:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80183e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801845:	48 98                	cltq   
  801847:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184e:	00 
  80184f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801855:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185b:	48 89 d1             	mov    %rdx,%rcx
  80185e:	48 89 c2             	mov    %rax,%rdx
  801861:	be 01 00 00 00       	mov    $0x1,%esi
  801866:	bf 06 00 00 00       	mov    $0x6,%edi
  80186b:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801872:	00 00 00 
  801875:	ff d0                	callq  *%rax
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 20          	sub    $0x20,%rsp
  801881:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801884:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801887:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80188a:	48 63 d0             	movslq %eax,%rdx
  80188d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801890:	48 98                	cltq   
  801892:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801899:	00 
  80189a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a6:	48 89 d1             	mov    %rdx,%rcx
  8018a9:	48 89 c2             	mov    %rax,%rdx
  8018ac:	be 01 00 00 00       	mov    $0x1,%esi
  8018b1:	bf 08 00 00 00       	mov    $0x8,%edi
  8018b6:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8018bd:	00 00 00 
  8018c0:	ff d0                	callq  *%rax
}
  8018c2:	c9                   	leaveq 
  8018c3:	c3                   	retq   

00000000008018c4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018c4:	55                   	push   %rbp
  8018c5:	48 89 e5             	mov    %rsp,%rbp
  8018c8:	48 83 ec 20          	sub    $0x20,%rsp
  8018cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018da:	48 98                	cltq   
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	48 89 d1             	mov    %rdx,%rcx
  8018f3:	48 89 c2             	mov    %rax,%rdx
  8018f6:	be 01 00 00 00       	mov    $0x1,%esi
  8018fb:	bf 09 00 00 00       	mov    $0x9,%edi
  801900:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801907:	00 00 00 
  80190a:	ff d0                	callq  *%rax
}
  80190c:	c9                   	leaveq 
  80190d:	c3                   	retq   

000000000080190e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80190e:	55                   	push   %rbp
  80190f:	48 89 e5             	mov    %rsp,%rbp
  801912:	48 83 ec 20          	sub    $0x20,%rsp
  801916:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801919:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80191d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801924:	48 98                	cltq   
  801926:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192d:	00 
  80192e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801934:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193a:	48 89 d1             	mov    %rdx,%rcx
  80193d:	48 89 c2             	mov    %rax,%rdx
  801940:	be 01 00 00 00       	mov    $0x1,%esi
  801945:	bf 0a 00 00 00       	mov    $0xa,%edi
  80194a:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801951:	00 00 00 
  801954:	ff d0                	callq  *%rax
}
  801956:	c9                   	leaveq 
  801957:	c3                   	retq   

0000000000801958 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801958:	55                   	push   %rbp
  801959:	48 89 e5             	mov    %rsp,%rbp
  80195c:	48 83 ec 30          	sub    $0x30,%rsp
  801960:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801963:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801967:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80196b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80196e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801971:	48 63 f0             	movslq %eax,%rsi
  801974:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197b:	48 98                	cltq   
  80197d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801981:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801988:	00 
  801989:	49 89 f1             	mov    %rsi,%r9
  80198c:	49 89 c8             	mov    %rcx,%r8
  80198f:	48 89 d1             	mov    %rdx,%rcx
  801992:	48 89 c2             	mov    %rax,%rdx
  801995:	be 00 00 00 00       	mov    $0x0,%esi
  80199a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80199f:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8019a6:	00 00 00 
  8019a9:	ff d0                	callq  *%rax
}
  8019ab:	c9                   	leaveq 
  8019ac:	c3                   	retq   

00000000008019ad <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ad:	55                   	push   %rbp
  8019ae:	48 89 e5             	mov    %rsp,%rbp
  8019b1:	48 83 ec 20          	sub    $0x20,%rsp
  8019b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c4:	00 
  8019c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019d6:	48 89 c2             	mov    %rax,%rdx
  8019d9:	be 01 00 00 00       	mov    $0x1,%esi
  8019de:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019e3:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  8019ea:	00 00 00 
  8019ed:	ff d0                	callq  *%rax
}
  8019ef:	c9                   	leaveq 
  8019f0:	c3                   	retq   

00000000008019f1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8019f1:	55                   	push   %rbp
  8019f2:	48 89 e5             	mov    %rsp,%rbp
  8019f5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8019f9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a00:	00 
  801a01:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a07:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
  801a17:	be 00 00 00 00       	mov    $0x0,%esi
  801a1c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a21:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 20          	sub    $0x20,%rsp
  801a37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801a3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a47:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4e:	00 
  801a4f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a55:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5b:	48 89 d1             	mov    %rdx,%rcx
  801a5e:	48 89 c2             	mov    %rax,%rdx
  801a61:	be 00 00 00 00       	mov    $0x0,%esi
  801a66:	bf 0f 00 00 00       	mov    $0xf,%edi
  801a6b:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	callq  *%rax
}
  801a77:	c9                   	leaveq 
  801a78:	c3                   	retq   

0000000000801a79 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801a79:	55                   	push   %rbp
  801a7a:	48 89 e5             	mov    %rsp,%rbp
  801a7d:	48 83 ec 20          	sub    $0x20,%rsp
  801a81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801a89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a91:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a98:	00 
  801a99:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa5:	48 89 d1             	mov    %rdx,%rcx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 00 00 00 00       	mov    $0x0,%esi
  801ab0:	bf 10 00 00 00       	mov    $0x10,%edi
  801ab5:	48 b8 a0 15 80 00 00 	movabs $0x8015a0,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   
	...

0000000000801ac4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 08          	sub    $0x8,%rsp
  801acc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ad0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ad4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801adb:	ff ff ff 
  801ade:	48 01 d0             	add    %rdx,%rax
  801ae1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ae5:	c9                   	leaveq 
  801ae6:	c3                   	retq   

0000000000801ae7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ae7:	55                   	push   %rbp
  801ae8:	48 89 e5             	mov    %rsp,%rbp
  801aeb:	48 83 ec 08          	sub    $0x8,%rsp
  801aef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af7:	48 89 c7             	mov    %rax,%rdi
  801afa:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  801b01:	00 00 00 
  801b04:	ff d0                	callq  *%rax
  801b06:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b0c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b10:	c9                   	leaveq 
  801b11:	c3                   	retq   

0000000000801b12 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b12:	55                   	push   %rbp
  801b13:	48 89 e5             	mov    %rsp,%rbp
  801b16:	48 83 ec 18          	sub    $0x18,%rsp
  801b1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b25:	eb 6b                	jmp    801b92 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2a:	48 98                	cltq   
  801b2c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b32:	48 c1 e0 0c          	shl    $0xc,%rax
  801b36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b3e:	48 89 c2             	mov    %rax,%rdx
  801b41:	48 c1 ea 15          	shr    $0x15,%rdx
  801b45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b4c:	01 00 00 
  801b4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b53:	83 e0 01             	and    $0x1,%eax
  801b56:	48 85 c0             	test   %rax,%rax
  801b59:	74 21                	je     801b7c <fd_alloc+0x6a>
  801b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b5f:	48 89 c2             	mov    %rax,%rdx
  801b62:	48 c1 ea 0c          	shr    $0xc,%rdx
  801b66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b6d:	01 00 00 
  801b70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b74:	83 e0 01             	and    $0x1,%eax
  801b77:	48 85 c0             	test   %rax,%rax
  801b7a:	75 12                	jne    801b8e <fd_alloc+0x7c>
			*fd_store = fd;
  801b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b84:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	eb 1a                	jmp    801ba8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b8e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801b92:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b96:	7e 8f                	jle    801b27 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ba3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   

0000000000801baa <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	48 83 ec 20          	sub    $0x20,%rsp
  801bb2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801bb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801bb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801bbd:	78 06                	js     801bc5 <fd_lookup+0x1b>
  801bbf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801bc3:	7e 07                	jle    801bcc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801bc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bca:	eb 6c                	jmp    801c38 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801bcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801bcf:	48 98                	cltq   
  801bd1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801bd7:	48 c1 e0 0c          	shl    $0xc,%rax
  801bdb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801bdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be3:	48 89 c2             	mov    %rax,%rdx
  801be6:	48 c1 ea 15          	shr    $0x15,%rdx
  801bea:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bf1:	01 00 00 
  801bf4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bf8:	83 e0 01             	and    $0x1,%eax
  801bfb:	48 85 c0             	test   %rax,%rax
  801bfe:	74 21                	je     801c21 <fd_lookup+0x77>
  801c00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	48 c1 ea 0c          	shr    $0xc,%rdx
  801c0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c12:	01 00 00 
  801c15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c19:	83 e0 01             	and    $0x1,%eax
  801c1c:	48 85 c0             	test   %rax,%rax
  801c1f:	75 07                	jne    801c28 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c26:	eb 10                	jmp    801c38 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c2c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c30:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c38:	c9                   	leaveq 
  801c39:	c3                   	retq   

0000000000801c3a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c3a:	55                   	push   %rbp
  801c3b:	48 89 e5             	mov    %rsp,%rbp
  801c3e:	48 83 ec 30          	sub    $0x30,%rsp
  801c42:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c46:	89 f0                	mov    %esi,%eax
  801c48:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c4f:	48 89 c7             	mov    %rax,%rdi
  801c52:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
  801c5e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801c62:	48 89 d6             	mov    %rdx,%rsi
  801c65:	89 c7                	mov    %eax,%edi
  801c67:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  801c6e:	00 00 00 
  801c71:	ff d0                	callq  *%rax
  801c73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7a:	78 0a                	js     801c86 <fd_close+0x4c>
	    || fd != fd2)
  801c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c80:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801c84:	74 12                	je     801c98 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801c86:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801c8a:	74 05                	je     801c91 <fd_close+0x57>
  801c8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8f:	eb 05                	jmp    801c96 <fd_close+0x5c>
  801c91:	b8 00 00 00 00       	mov    $0x0,%eax
  801c96:	eb 69                	jmp    801d01 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9c:	8b 00                	mov    (%rax),%eax
  801c9e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ca2:	48 89 d6             	mov    %rdx,%rsi
  801ca5:	89 c7                	mov    %eax,%edi
  801ca7:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  801cae:	00 00 00 
  801cb1:	ff d0                	callq  *%rax
  801cb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cba:	78 2a                	js     801ce6 <fd_close+0xac>
		if (dev->dev_close)
  801cbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc0:	48 8b 40 20          	mov    0x20(%rax),%rax
  801cc4:	48 85 c0             	test   %rax,%rax
  801cc7:	74 16                	je     801cdf <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801cc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ccd:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801cd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd5:	48 89 c7             	mov    %rax,%rdi
  801cd8:	ff d2                	callq  *%rdx
  801cda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cdd:	eb 07                	jmp    801ce6 <fd_close+0xac>
		else
			r = 0;
  801cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ce6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cea:	48 89 c6             	mov    %rax,%rsi
  801ced:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf2:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
	return r;
  801cfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d01:	c9                   	leaveq 
  801d02:	c3                   	retq   

0000000000801d03 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d03:	55                   	push   %rbp
  801d04:	48 89 e5             	mov    %rsp,%rbp
  801d07:	48 83 ec 20          	sub    $0x20,%rsp
  801d0b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d0e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d19:	eb 41                	jmp    801d5c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d1b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d22:	00 00 00 
  801d25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d28:	48 63 d2             	movslq %edx,%rdx
  801d2b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d2f:	8b 00                	mov    (%rax),%eax
  801d31:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d34:	75 22                	jne    801d58 <dev_lookup+0x55>
			*dev = devtab[i];
  801d36:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d3d:	00 00 00 
  801d40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d43:	48 63 d2             	movslq %edx,%rdx
  801d46:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801d4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
  801d56:	eb 60                	jmp    801db8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d58:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d5c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d63:	00 00 00 
  801d66:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d69:	48 63 d2             	movslq %edx,%rdx
  801d6c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d70:	48 85 c0             	test   %rax,%rax
  801d73:	75 a6                	jne    801d1b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d75:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801d7c:	00 00 00 
  801d7f:	48 8b 00             	mov    (%rax),%rax
  801d82:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801d88:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801d8b:	89 c6                	mov    %eax,%esi
  801d8d:	48 bf 10 41 80 00 00 	movabs $0x804110,%rdi
  801d94:	00 00 00 
  801d97:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9c:	48 b9 8f 02 80 00 00 	movabs $0x80028f,%rcx
  801da3:	00 00 00 
  801da6:	ff d1                	callq  *%rcx
	*dev = 0;
  801da8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801db3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801db8:	c9                   	leaveq 
  801db9:	c3                   	retq   

0000000000801dba <close>:

int
close(int fdnum)
{
  801dba:	55                   	push   %rbp
  801dbb:	48 89 e5             	mov    %rsp,%rbp
  801dbe:	48 83 ec 20          	sub    $0x20,%rsp
  801dc2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dcc:	48 89 d6             	mov    %rdx,%rsi
  801dcf:	89 c7                	mov    %eax,%edi
  801dd1:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
  801ddd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801de0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de4:	79 05                	jns    801deb <close+0x31>
		return r;
  801de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de9:	eb 18                	jmp    801e03 <close+0x49>
	else
		return fd_close(fd, 1);
  801deb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801def:	be 01 00 00 00       	mov    $0x1,%esi
  801df4:	48 89 c7             	mov    %rax,%rdi
  801df7:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  801dfe:	00 00 00 
  801e01:	ff d0                	callq  *%rax
}
  801e03:	c9                   	leaveq 
  801e04:	c3                   	retq   

0000000000801e05 <close_all>:

void
close_all(void)
{
  801e05:	55                   	push   %rbp
  801e06:	48 89 e5             	mov    %rsp,%rbp
  801e09:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e14:	eb 15                	jmp    801e2b <close_all+0x26>
		close(i);
  801e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e19:	89 c7                	mov    %eax,%edi
  801e1b:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e27:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e2b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e2f:	7e e5                	jle    801e16 <close_all+0x11>
		close(i);
}
  801e31:	c9                   	leaveq 
  801e32:	c3                   	retq   

0000000000801e33 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e33:	55                   	push   %rbp
  801e34:	48 89 e5             	mov    %rsp,%rbp
  801e37:	48 83 ec 40          	sub    $0x40,%rsp
  801e3b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e3e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e41:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801e45:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e48:	48 89 d6             	mov    %rdx,%rsi
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  801e54:	00 00 00 
  801e57:	ff d0                	callq  *%rax
  801e59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e60:	79 08                	jns    801e6a <dup+0x37>
		return r;
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	e9 70 01 00 00       	jmpq   801fda <dup+0x1a7>
	close(newfdnum);
  801e6a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e6d:	89 c7                	mov    %eax,%edi
  801e6f:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  801e76:	00 00 00 
  801e79:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801e7b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e7e:	48 98                	cltq   
  801e80:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e86:	48 c1 e0 0c          	shl    $0xc,%rax
  801e8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801e8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e92:	48 89 c7             	mov    %rax,%rdi
  801e95:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801ea5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea9:	48 89 c7             	mov    %rax,%rdi
  801eac:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  801eb3:	00 00 00 
  801eb6:	ff d0                	callq  *%rax
  801eb8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec0:	48 89 c2             	mov    %rax,%rdx
  801ec3:	48 c1 ea 15          	shr    $0x15,%rdx
  801ec7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ece:	01 00 00 
  801ed1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed5:	83 e0 01             	and    $0x1,%eax
  801ed8:	84 c0                	test   %al,%al
  801eda:	74 71                	je     801f4d <dup+0x11a>
  801edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee0:	48 89 c2             	mov    %rax,%rdx
  801ee3:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ee7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eee:	01 00 00 
  801ef1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef5:	83 e0 01             	and    $0x1,%eax
  801ef8:	84 c0                	test   %al,%al
  801efa:	74 51                	je     801f4d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f00:	48 89 c2             	mov    %rax,%rdx
  801f03:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0e:	01 00 00 
  801f11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f15:	89 c1                	mov    %eax,%ecx
  801f17:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801f1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f25:	41 89 c8             	mov    %ecx,%r8d
  801f28:	48 89 d1             	mov    %rdx,%rcx
  801f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f30:	48 89 c6             	mov    %rax,%rsi
  801f33:	bf 00 00 00 00       	mov    $0x0,%edi
  801f38:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  801f3f:	00 00 00 
  801f42:	ff d0                	callq  *%rax
  801f44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4b:	78 56                	js     801fa3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f51:	48 89 c2             	mov    %rax,%rdx
  801f54:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5f:	01 00 00 
  801f62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f66:	89 c1                	mov    %eax,%ecx
  801f68:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f76:	41 89 c8             	mov    %ecx,%r8d
  801f79:	48 89 d1             	mov    %rdx,%rcx
  801f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f81:	48 89 c6             	mov    %rax,%rsi
  801f84:	bf 00 00 00 00       	mov    $0x0,%edi
  801f89:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  801f90:	00 00 00 
  801f93:	ff d0                	callq  *%rax
  801f95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9c:	78 08                	js     801fa6 <dup+0x173>
		goto err;

	return newfdnum;
  801f9e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fa1:	eb 37                	jmp    801fda <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  801fa3:	90                   	nop
  801fa4:	eb 01                	jmp    801fa7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  801fa6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fab:	48 89 c6             	mov    %rax,%rsi
  801fae:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb3:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  801fba:	00 00 00 
  801fbd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801fbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc3:	48 89 c6             	mov    %rax,%rsi
  801fc6:	bf 00 00 00 00       	mov    $0x0,%edi
  801fcb:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  801fd2:	00 00 00 
  801fd5:	ff d0                	callq  *%rax
	return r;
  801fd7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fda:	c9                   	leaveq 
  801fdb:	c3                   	retq   

0000000000801fdc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fdc:	55                   	push   %rbp
  801fdd:	48 89 e5             	mov    %rsp,%rbp
  801fe0:	48 83 ec 40          	sub    $0x40,%rsp
  801fe4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801fe7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801feb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ff3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ff6:	48 89 d6             	mov    %rdx,%rsi
  801ff9:	89 c7                	mov    %eax,%edi
  801ffb:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  802002:	00 00 00 
  802005:	ff d0                	callq  *%rax
  802007:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80200a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80200e:	78 24                	js     802034 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802014:	8b 00                	mov    (%rax),%eax
  802016:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80201a:	48 89 d6             	mov    %rdx,%rsi
  80201d:	89 c7                	mov    %eax,%edi
  80201f:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  802026:	00 00 00 
  802029:	ff d0                	callq  *%rax
  80202b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80202e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802032:	79 05                	jns    802039 <read+0x5d>
		return r;
  802034:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802037:	eb 7a                	jmp    8020b3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80203d:	8b 40 08             	mov    0x8(%rax),%eax
  802040:	83 e0 03             	and    $0x3,%eax
  802043:	83 f8 01             	cmp    $0x1,%eax
  802046:	75 3a                	jne    802082 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802048:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80204f:	00 00 00 
  802052:	48 8b 00             	mov    (%rax),%rax
  802055:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80205b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80205e:	89 c6                	mov    %eax,%esi
  802060:	48 bf 2f 41 80 00 00 	movabs $0x80412f,%rdi
  802067:	00 00 00 
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	48 b9 8f 02 80 00 00 	movabs $0x80028f,%rcx
  802076:	00 00 00 
  802079:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80207b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802080:	eb 31                	jmp    8020b3 <read+0xd7>
	}
	if (!dev->dev_read)
  802082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802086:	48 8b 40 10          	mov    0x10(%rax),%rax
  80208a:	48 85 c0             	test   %rax,%rax
  80208d:	75 07                	jne    802096 <read+0xba>
		return -E_NOT_SUPP;
  80208f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802094:	eb 1d                	jmp    8020b3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802096:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80209a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80209e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020a6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8020aa:	48 89 ce             	mov    %rcx,%rsi
  8020ad:	48 89 c7             	mov    %rax,%rdi
  8020b0:	41 ff d0             	callq  *%r8
}
  8020b3:	c9                   	leaveq 
  8020b4:	c3                   	retq   

00000000008020b5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8020b5:	55                   	push   %rbp
  8020b6:	48 89 e5             	mov    %rsp,%rbp
  8020b9:	48 83 ec 30          	sub    $0x30,%rsp
  8020bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020c0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020c4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020cf:	eb 46                	jmp    802117 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020d4:	48 98                	cltq   
  8020d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8020da:	48 29 c2             	sub    %rax,%rdx
  8020dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020e0:	48 98                	cltq   
  8020e2:	48 89 c1             	mov    %rax,%rcx
  8020e5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8020e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020ec:	48 89 ce             	mov    %rcx,%rsi
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax
  8020fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802100:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802104:	79 05                	jns    80210b <readn+0x56>
			return m;
  802106:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802109:	eb 1d                	jmp    802128 <readn+0x73>
		if (m == 0)
  80210b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80210f:	74 13                	je     802124 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802111:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802114:	01 45 fc             	add    %eax,-0x4(%rbp)
  802117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211a:	48 98                	cltq   
  80211c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802120:	72 af                	jb     8020d1 <readn+0x1c>
  802122:	eb 01                	jmp    802125 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802124:	90                   	nop
	}
	return tot;
  802125:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802128:	c9                   	leaveq 
  802129:	c3                   	retq   

000000000080212a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80212a:	55                   	push   %rbp
  80212b:	48 89 e5             	mov    %rsp,%rbp
  80212e:	48 83 ec 40          	sub    $0x40,%rsp
  802132:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802135:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802139:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80213d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802141:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802144:	48 89 d6             	mov    %rdx,%rsi
  802147:	89 c7                	mov    %eax,%edi
  802149:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  802150:	00 00 00 
  802153:	ff d0                	callq  *%rax
  802155:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802158:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80215c:	78 24                	js     802182 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80215e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802162:	8b 00                	mov    (%rax),%eax
  802164:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802168:	48 89 d6             	mov    %rdx,%rsi
  80216b:	89 c7                	mov    %eax,%edi
  80216d:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80217c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802180:	79 05                	jns    802187 <write+0x5d>
		return r;
  802182:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802185:	eb 79                	jmp    802200 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218b:	8b 40 08             	mov    0x8(%rax),%eax
  80218e:	83 e0 03             	and    $0x3,%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	75 3a                	jne    8021cf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802195:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80219c:	00 00 00 
  80219f:	48 8b 00             	mov    (%rax),%rax
  8021a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ab:	89 c6                	mov    %eax,%esi
  8021ad:	48 bf 4b 41 80 00 00 	movabs $0x80414b,%rdi
  8021b4:	00 00 00 
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bc:	48 b9 8f 02 80 00 00 	movabs $0x80028f,%rcx
  8021c3:	00 00 00 
  8021c6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021cd:	eb 31                	jmp    802200 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021d7:	48 85 c0             	test   %rax,%rax
  8021da:	75 07                	jne    8021e3 <write+0xb9>
		return -E_NOT_SUPP;
  8021dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021e1:	eb 1d                	jmp    802200 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8021e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  8021eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8021f3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8021f7:	48 89 ce             	mov    %rcx,%rsi
  8021fa:	48 89 c7             	mov    %rax,%rdi
  8021fd:	41 ff d0             	callq  *%r8
}
  802200:	c9                   	leaveq 
  802201:	c3                   	retq   

0000000000802202 <seek>:

int
seek(int fdnum, off_t offset)
{
  802202:	55                   	push   %rbp
  802203:	48 89 e5             	mov    %rsp,%rbp
  802206:	48 83 ec 18          	sub    $0x18,%rsp
  80220a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80220d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802210:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802214:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802217:	48 89 d6             	mov    %rdx,%rsi
  80221a:	89 c7                	mov    %eax,%edi
  80221c:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  802223:	00 00 00 
  802226:	ff d0                	callq  *%rax
  802228:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222f:	79 05                	jns    802236 <seek+0x34>
		return r;
  802231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802234:	eb 0f                	jmp    802245 <seek+0x43>
	fd->fd_offset = offset;
  802236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80223d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802245:	c9                   	leaveq 
  802246:	c3                   	retq   

0000000000802247 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802247:	55                   	push   %rbp
  802248:	48 89 e5             	mov    %rsp,%rbp
  80224b:	48 83 ec 30          	sub    $0x30,%rsp
  80224f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802252:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802255:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802259:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80225c:	48 89 d6             	mov    %rdx,%rsi
  80225f:	89 c7                	mov    %eax,%edi
  802261:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  802268:	00 00 00 
  80226b:	ff d0                	callq  *%rax
  80226d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802270:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802274:	78 24                	js     80229a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80227a:	8b 00                	mov    (%rax),%eax
  80227c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802280:	48 89 d6             	mov    %rdx,%rsi
  802283:	89 c7                	mov    %eax,%edi
  802285:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802298:	79 05                	jns    80229f <ftruncate+0x58>
		return r;
  80229a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229d:	eb 72                	jmp    802311 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80229f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a3:	8b 40 08             	mov    0x8(%rax),%eax
  8022a6:	83 e0 03             	and    $0x3,%eax
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	75 3a                	jne    8022e7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8022ad:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8022b4:	00 00 00 
  8022b7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022ba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022c0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022c3:	89 c6                	mov    %eax,%esi
  8022c5:	48 bf 68 41 80 00 00 	movabs $0x804168,%rdi
  8022cc:	00 00 00 
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	48 b9 8f 02 80 00 00 	movabs $0x80028f,%rcx
  8022db:	00 00 00 
  8022de:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8022e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022e5:	eb 2a                	jmp    802311 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8022e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022eb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8022ef:	48 85 c0             	test   %rax,%rax
  8022f2:	75 07                	jne    8022fb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8022f4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022f9:	eb 16                	jmp    802311 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8022fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ff:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802307:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80230a:	89 d6                	mov    %edx,%esi
  80230c:	48 89 c7             	mov    %rax,%rdi
  80230f:	ff d1                	callq  *%rcx
}
  802311:	c9                   	leaveq 
  802312:	c3                   	retq   

0000000000802313 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802313:	55                   	push   %rbp
  802314:	48 89 e5             	mov    %rsp,%rbp
  802317:	48 83 ec 30          	sub    $0x30,%rsp
  80231b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80231e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802322:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802326:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802329:	48 89 d6             	mov    %rdx,%rsi
  80232c:	89 c7                	mov    %eax,%edi
  80232e:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  802335:	00 00 00 
  802338:	ff d0                	callq  *%rax
  80233a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802341:	78 24                	js     802367 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802347:	8b 00                	mov    (%rax),%eax
  802349:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80234d:	48 89 d6             	mov    %rdx,%rsi
  802350:	89 c7                	mov    %eax,%edi
  802352:	48 b8 03 1d 80 00 00 	movabs $0x801d03,%rax
  802359:	00 00 00 
  80235c:	ff d0                	callq  *%rax
  80235e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802361:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802365:	79 05                	jns    80236c <fstat+0x59>
		return r;
  802367:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236a:	eb 5e                	jmp    8023ca <fstat+0xb7>
	if (!dev->dev_stat)
  80236c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802370:	48 8b 40 28          	mov    0x28(%rax),%rax
  802374:	48 85 c0             	test   %rax,%rax
  802377:	75 07                	jne    802380 <fstat+0x6d>
		return -E_NOT_SUPP;
  802379:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80237e:	eb 4a                	jmp    8023ca <fstat+0xb7>
	stat->st_name[0] = 0;
  802380:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802384:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802387:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80238b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802392:	00 00 00 
	stat->st_isdir = 0;
  802395:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802399:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023a0:	00 00 00 
	stat->st_dev = dev;
  8023a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023ab:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8023b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8023ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023be:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8023c2:	48 89 d6             	mov    %rdx,%rsi
  8023c5:	48 89 c7             	mov    %rax,%rdi
  8023c8:	ff d1                	callq  *%rcx
}
  8023ca:	c9                   	leaveq 
  8023cb:	c3                   	retq   

00000000008023cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8023cc:	55                   	push   %rbp
  8023cd:	48 89 e5             	mov    %rsp,%rbp
  8023d0:	48 83 ec 20          	sub    $0x20,%rsp
  8023d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8023dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e0:	be 00 00 00 00       	mov    $0x0,%esi
  8023e5:	48 89 c7             	mov    %rax,%rdi
  8023e8:	48 b8 bb 24 80 00 00 	movabs $0x8024bb,%rax
  8023ef:	00 00 00 
  8023f2:	ff d0                	callq  *%rax
  8023f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023fb:	79 05                	jns    802402 <stat+0x36>
		return fd;
  8023fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802400:	eb 2f                	jmp    802431 <stat+0x65>
	r = fstat(fd, stat);
  802402:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802406:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802409:	48 89 d6             	mov    %rdx,%rsi
  80240c:	89 c7                	mov    %eax,%edi
  80240e:	48 b8 13 23 80 00 00 	movabs $0x802313,%rax
  802415:	00 00 00 
  802418:	ff d0                	callq  *%rax
  80241a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80241d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802420:	89 c7                	mov    %eax,%edi
  802422:	48 b8 ba 1d 80 00 00 	movabs $0x801dba,%rax
  802429:	00 00 00 
  80242c:	ff d0                	callq  *%rax
	return r;
  80242e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802431:	c9                   	leaveq 
  802432:	c3                   	retq   
	...

0000000000802434 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802434:	55                   	push   %rbp
  802435:	48 89 e5             	mov    %rsp,%rbp
  802438:	48 83 ec 10          	sub    $0x10,%rsp
  80243c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80243f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802443:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  80244a:	00 00 00 
  80244d:	8b 00                	mov    (%rax),%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	75 1d                	jne    802470 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802453:	bf 01 00 00 00       	mov    $0x1,%edi
  802458:	48 b8 eb 3a 80 00 00 	movabs $0x803aeb,%rax
  80245f:	00 00 00 
  802462:	ff d0                	callq  *%rax
  802464:	48 ba 1c 70 80 00 00 	movabs $0x80701c,%rdx
  80246b:	00 00 00 
  80246e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802470:	48 b8 1c 70 80 00 00 	movabs $0x80701c,%rax
  802477:	00 00 00 
  80247a:	8b 00                	mov    (%rax),%eax
  80247c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80247f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802484:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80248b:	00 00 00 
  80248e:	89 c7                	mov    %eax,%edi
  802490:	48 b8 28 3a 80 00 00 	movabs $0x803a28,%rax
  802497:	00 00 00 
  80249a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80249c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a5:	48 89 c6             	mov    %rax,%rsi
  8024a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ad:	48 b8 68 39 80 00 00 	movabs $0x803968,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
}
  8024b9:	c9                   	leaveq 
  8024ba:	c3                   	retq   

00000000008024bb <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8024bb:	55                   	push   %rbp
  8024bc:	48 89 e5             	mov    %rsp,%rbp
  8024bf:	48 83 ec 20          	sub    $0x20,%rsp
  8024c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8024ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024ce:	48 89 c7             	mov    %rax,%rdi
  8024d1:	48 b8 e0 0d 80 00 00 	movabs $0x800de0,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
  8024dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8024e2:	7e 0a                	jle    8024ee <open+0x33>
                return -E_BAD_PATH;
  8024e4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8024e9:	e9 a5 00 00 00       	jmpq   802593 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8024ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8024f2:	48 89 c7             	mov    %rax,%rdi
  8024f5:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	callq  *%rax
  802501:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802504:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802508:	79 08                	jns    802512 <open+0x57>
		return r;
  80250a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80250d:	e9 81 00 00 00       	jmpq   802593 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802512:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802516:	48 89 c6             	mov    %rax,%rsi
  802519:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802520:	00 00 00 
  802523:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  80252a:	00 00 00 
  80252d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80252f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802536:	00 00 00 
  802539:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80253c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802546:	48 89 c6             	mov    %rax,%rsi
  802549:	bf 01 00 00 00       	mov    $0x1,%edi
  80254e:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802555:	00 00 00 
  802558:	ff d0                	callq  *%rax
  80255a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80255d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802561:	79 1d                	jns    802580 <open+0xc5>
	{
		fd_close(fd,0);
  802563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802567:	be 00 00 00 00       	mov    $0x0,%esi
  80256c:	48 89 c7             	mov    %rax,%rdi
  80256f:	48 b8 3a 1c 80 00 00 	movabs $0x801c3a,%rax
  802576:	00 00 00 
  802579:	ff d0                	callq  *%rax
		return r;
  80257b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257e:	eb 13                	jmp    802593 <open+0xd8>
	}
	return fd2num(fd);
  802580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802584:	48 89 c7             	mov    %rax,%rdi
  802587:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax
	


}
  802593:	c9                   	leaveq 
  802594:	c3                   	retq   

0000000000802595 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802595:	55                   	push   %rbp
  802596:	48 89 e5             	mov    %rsp,%rbp
  802599:	48 83 ec 10          	sub    $0x10,%rsp
  80259d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025a5:	8b 50 0c             	mov    0xc(%rax),%edx
  8025a8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025af:	00 00 00 
  8025b2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8025b4:	be 00 00 00 00       	mov    $0x0,%esi
  8025b9:	bf 06 00 00 00       	mov    $0x6,%edi
  8025be:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8025c5:	00 00 00 
  8025c8:	ff d0                	callq  *%rax
}
  8025ca:	c9                   	leaveq 
  8025cb:	c3                   	retq   

00000000008025cc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025cc:	55                   	push   %rbp
  8025cd:	48 89 e5             	mov    %rsp,%rbp
  8025d0:	48 83 ec 30          	sub    $0x30,%rsp
  8025d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8025e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8025e7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025ee:	00 00 00 
  8025f1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8025f3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8025fa:	00 00 00 
  8025fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802601:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802605:	be 00 00 00 00       	mov    $0x0,%esi
  80260a:	bf 03 00 00 00       	mov    $0x3,%edi
  80260f:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802616:	00 00 00 
  802619:	ff d0                	callq  *%rax
  80261b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80261e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802622:	79 05                	jns    802629 <devfile_read+0x5d>
	{
		return r;
  802624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802627:	eb 2c                	jmp    802655 <devfile_read+0x89>
	}
	if(r > 0)
  802629:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80262d:	7e 23                	jle    802652 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80262f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802632:	48 63 d0             	movslq %eax,%rdx
  802635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802639:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802640:	00 00 00 
  802643:	48 89 c7             	mov    %rax,%rdi
  802646:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  80264d:	00 00 00 
  802650:	ff d0                	callq  *%rax
	return r;
  802652:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802655:	c9                   	leaveq 
  802656:	c3                   	retq   

0000000000802657 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802657:	55                   	push   %rbp
  802658:	48 89 e5             	mov    %rsp,%rbp
  80265b:	48 83 ec 30          	sub    $0x30,%rsp
  80265f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802663:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802667:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80266b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266f:	8b 50 0c             	mov    0xc(%rax),%edx
  802672:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802679:	00 00 00 
  80267c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80267e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802685:	00 
  802686:	76 08                	jbe    802690 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802688:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80268f:	00 
	fsipcbuf.write.req_n=n;
  802690:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802697:	00 00 00 
  80269a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80269e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8026a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026aa:	48 89 c6             	mov    %rax,%rsi
  8026ad:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8026b4:	00 00 00 
  8026b7:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  8026be:	00 00 00 
  8026c1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8026c3:	be 00 00 00 00       	mov    $0x0,%esi
  8026c8:	bf 04 00 00 00       	mov    $0x4,%edi
  8026cd:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
  8026d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8026dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026df:	c9                   	leaveq 
  8026e0:	c3                   	retq   

00000000008026e1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8026e1:	55                   	push   %rbp
  8026e2:	48 89 e5             	mov    %rsp,%rbp
  8026e5:	48 83 ec 10          	sub    $0x10,%rsp
  8026e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026ed:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8026f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f4:	8b 50 0c             	mov    0xc(%rax),%edx
  8026f7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026fe:	00 00 00 
  802701:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802703:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80270a:	00 00 00 
  80270d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802710:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802713:	be 00 00 00 00       	mov    $0x0,%esi
  802718:	bf 02 00 00 00       	mov    $0x2,%edi
  80271d:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
}
  802729:	c9                   	leaveq 
  80272a:	c3                   	retq   

000000000080272b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80272b:	55                   	push   %rbp
  80272c:	48 89 e5             	mov    %rsp,%rbp
  80272f:	48 83 ec 20          	sub    $0x20,%rsp
  802733:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802737:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80273b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80273f:	8b 50 0c             	mov    0xc(%rax),%edx
  802742:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802749:	00 00 00 
  80274c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80274e:	be 00 00 00 00       	mov    $0x0,%esi
  802753:	bf 05 00 00 00       	mov    $0x5,%edi
  802758:	48 b8 34 24 80 00 00 	movabs $0x802434,%rax
  80275f:	00 00 00 
  802762:	ff d0                	callq  *%rax
  802764:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80276b:	79 05                	jns    802772 <devfile_stat+0x47>
		return r;
  80276d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802770:	eb 56                	jmp    8027c8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802772:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802776:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80277d:	00 00 00 
  802780:	48 89 c7             	mov    %rax,%rdi
  802783:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80278f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802796:	00 00 00 
  802799:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80279f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027a9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b0:	00 00 00 
  8027b3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027bd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c8:	c9                   	leaveq 
  8027c9:	c3                   	retq   
	...

00000000008027cc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8027cc:	55                   	push   %rbp
  8027cd:	48 89 e5             	mov    %rsp,%rbp
  8027d0:	48 83 ec 20          	sub    $0x20,%rsp
  8027d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8027d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027de:	48 89 d6             	mov    %rdx,%rsi
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  8027ea:	00 00 00 
  8027ed:	ff d0                	callq  *%rax
  8027ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f6:	79 05                	jns    8027fd <fd2sockid+0x31>
		return r;
  8027f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fb:	eb 24                	jmp    802821 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8027fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802801:	8b 10                	mov    (%rax),%edx
  802803:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80280a:	00 00 00 
  80280d:	8b 00                	mov    (%rax),%eax
  80280f:	39 c2                	cmp    %eax,%edx
  802811:	74 07                	je     80281a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802813:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802818:	eb 07                	jmp    802821 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80281a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802821:	c9                   	leaveq 
  802822:	c3                   	retq   

0000000000802823 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802823:	55                   	push   %rbp
  802824:	48 89 e5             	mov    %rsp,%rbp
  802827:	48 83 ec 20          	sub    $0x20,%rsp
  80282b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80282e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802832:	48 89 c7             	mov    %rax,%rdi
  802835:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  80283c:	00 00 00 
  80283f:	ff d0                	callq  *%rax
  802841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802848:	78 26                	js     802870 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80284a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284e:	ba 07 04 00 00       	mov    $0x407,%edx
  802853:	48 89 c6             	mov    %rax,%rsi
  802856:	bf 00 00 00 00       	mov    $0x0,%edi
  80285b:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
  802867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80286e:	79 16                	jns    802886 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802870:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802873:	89 c7                	mov    %eax,%edi
  802875:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
		return r;
  802881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802884:	eb 3a                	jmp    8028c0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802886:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802891:	00 00 00 
  802894:	8b 12                	mov    (%rdx),%edx
  802896:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8028a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028aa:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8028ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b1:	48 89 c7             	mov    %rax,%rdi
  8028b4:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
}
  8028c0:	c9                   	leaveq 
  8028c1:	c3                   	retq   

00000000008028c2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028c2:	55                   	push   %rbp
  8028c3:	48 89 e5             	mov    %rsp,%rbp
  8028c6:	48 83 ec 30          	sub    $0x30,%rsp
  8028ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8028d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d8:	89 c7                	mov    %eax,%edi
  8028da:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
  8028e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ed:	79 05                	jns    8028f4 <accept+0x32>
		return r;
  8028ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f2:	eb 3b                	jmp    80292f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028f4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8028fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ff:	48 89 ce             	mov    %rcx,%rsi
  802902:	89 c7                	mov    %eax,%edi
  802904:	48 b8 0d 2c 80 00 00 	movabs $0x802c0d,%rax
  80290b:	00 00 00 
  80290e:	ff d0                	callq  *%rax
  802910:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802917:	79 05                	jns    80291e <accept+0x5c>
		return r;
  802919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80291c:	eb 11                	jmp    80292f <accept+0x6d>
	return alloc_sockfd(r);
  80291e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802921:	89 c7                	mov    %eax,%edi
  802923:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
}
  80292f:	c9                   	leaveq 
  802930:	c3                   	retq   

0000000000802931 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802931:	55                   	push   %rbp
  802932:	48 89 e5             	mov    %rsp,%rbp
  802935:	48 83 ec 20          	sub    $0x20,%rsp
  802939:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80293c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802940:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802943:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802946:	89 c7                	mov    %eax,%edi
  802948:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
  802954:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802957:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80295b:	79 05                	jns    802962 <bind+0x31>
		return r;
  80295d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802960:	eb 1b                	jmp    80297d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802962:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802965:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296c:	48 89 ce             	mov    %rcx,%rsi
  80296f:	89 c7                	mov    %eax,%edi
  802971:	48 b8 8c 2c 80 00 00 	movabs $0x802c8c,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
}
  80297d:	c9                   	leaveq 
  80297e:	c3                   	retq   

000000000080297f <shutdown>:

int
shutdown(int s, int how)
{
  80297f:	55                   	push   %rbp
  802980:	48 89 e5             	mov    %rsp,%rbp
  802983:	48 83 ec 20          	sub    $0x20,%rsp
  802987:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80298a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80298d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802990:	89 c7                	mov    %eax,%edi
  802992:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  802999:	00 00 00 
  80299c:	ff d0                	callq  *%rax
  80299e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a5:	79 05                	jns    8029ac <shutdown+0x2d>
		return r;
  8029a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029aa:	eb 16                	jmp    8029c2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8029ac:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b2:	89 d6                	mov    %edx,%esi
  8029b4:	89 c7                	mov    %eax,%edi
  8029b6:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  8029bd:	00 00 00 
  8029c0:	ff d0                	callq  *%rax
}
  8029c2:	c9                   	leaveq 
  8029c3:	c3                   	retq   

00000000008029c4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8029c4:	55                   	push   %rbp
  8029c5:	48 89 e5             	mov    %rsp,%rbp
  8029c8:	48 83 ec 10          	sub    $0x10,%rsp
  8029cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8029d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029d4:	48 89 c7             	mov    %rax,%rdi
  8029d7:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  8029de:	00 00 00 
  8029e1:	ff d0                	callq  *%rax
  8029e3:	83 f8 01             	cmp    $0x1,%eax
  8029e6:	75 17                	jne    8029ff <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8029e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029ec:	8b 40 0c             	mov    0xc(%rax),%eax
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	eb 05                	jmp    802a04 <devsock_close+0x40>
	else
		return 0;
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a04:	c9                   	leaveq 
  802a05:	c3                   	retq   

0000000000802a06 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a06:	55                   	push   %rbp
  802a07:	48 89 e5             	mov    %rsp,%rbp
  802a0a:	48 83 ec 20          	sub    $0x20,%rsp
  802a0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a11:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a15:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a1b:	89 c7                	mov    %eax,%edi
  802a1d:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  802a24:	00 00 00 
  802a27:	ff d0                	callq  *%rax
  802a29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a30:	79 05                	jns    802a37 <connect+0x31>
		return r;
  802a32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a35:	eb 1b                	jmp    802a52 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802a37:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a3a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a41:	48 89 ce             	mov    %rcx,%rsi
  802a44:	89 c7                	mov    %eax,%edi
  802a46:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
}
  802a52:	c9                   	leaveq 
  802a53:	c3                   	retq   

0000000000802a54 <listen>:

int
listen(int s, int backlog)
{
  802a54:	55                   	push   %rbp
  802a55:	48 89 e5             	mov    %rsp,%rbp
  802a58:	48 83 ec 20          	sub    $0x20,%rsp
  802a5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a5f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a65:	89 c7                	mov    %eax,%edi
  802a67:	48 b8 cc 27 80 00 00 	movabs $0x8027cc,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	callq  *%rax
  802a73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7a:	79 05                	jns    802a81 <listen+0x2d>
		return r;
  802a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7f:	eb 16                	jmp    802a97 <listen+0x43>
	return nsipc_listen(r, backlog);
  802a81:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a87:	89 d6                	mov    %edx,%esi
  802a89:	89 c7                	mov    %eax,%edi
  802a8b:	48 b8 c1 2d 80 00 00 	movabs $0x802dc1,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
}
  802a97:	c9                   	leaveq 
  802a98:	c3                   	retq   

0000000000802a99 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802a99:	55                   	push   %rbp
  802a9a:	48 89 e5             	mov    %rsp,%rbp
  802a9d:	48 83 ec 20          	sub    $0x20,%rsp
  802aa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802aa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802aa9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab1:	89 c2                	mov    %eax,%edx
  802ab3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab7:	8b 40 0c             	mov    0xc(%rax),%eax
  802aba:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ac3:	89 c7                	mov    %eax,%edi
  802ac5:	48 b8 01 2e 80 00 00 	movabs $0x802e01,%rax
  802acc:	00 00 00 
  802acf:	ff d0                	callq  *%rax
}
  802ad1:	c9                   	leaveq 
  802ad2:	c3                   	retq   

0000000000802ad3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802ad3:	55                   	push   %rbp
  802ad4:	48 89 e5             	mov    %rsp,%rbp
  802ad7:	48 83 ec 20          	sub    $0x20,%rsp
  802adb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802adf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ae3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aeb:	89 c2                	mov    %eax,%edx
  802aed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802af1:	8b 40 0c             	mov    0xc(%rax),%eax
  802af4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  802afd:	89 c7                	mov    %eax,%edi
  802aff:	48 b8 cd 2e 80 00 00 	movabs $0x802ecd,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	callq  *%rax
}
  802b0b:	c9                   	leaveq 
  802b0c:	c3                   	retq   

0000000000802b0d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802b0d:	55                   	push   %rbp
  802b0e:	48 89 e5             	mov    %rsp,%rbp
  802b11:	48 83 ec 10          	sub    $0x10,%rsp
  802b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b19:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802b1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b21:	48 be 93 41 80 00 00 	movabs $0x804193,%rsi
  802b28:	00 00 00 
  802b2b:	48 89 c7             	mov    %rax,%rdi
  802b2e:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  802b35:	00 00 00 
  802b38:	ff d0                	callq  *%rax
	return 0;
  802b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3f:	c9                   	leaveq 
  802b40:	c3                   	retq   

0000000000802b41 <socket>:

int
socket(int domain, int type, int protocol)
{
  802b41:	55                   	push   %rbp
  802b42:	48 89 e5             	mov    %rsp,%rbp
  802b45:	48 83 ec 20          	sub    $0x20,%rsp
  802b49:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b4c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802b4f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802b52:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b55:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802b58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b5b:	89 ce                	mov    %ecx,%esi
  802b5d:	89 c7                	mov    %eax,%edi
  802b5f:	48 b8 85 2f 80 00 00 	movabs $0x802f85,%rax
  802b66:	00 00 00 
  802b69:	ff d0                	callq  *%rax
  802b6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b72:	79 05                	jns    802b79 <socket+0x38>
		return r;
  802b74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b77:	eb 11                	jmp    802b8a <socket+0x49>
	return alloc_sockfd(r);
  802b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	48 b8 23 28 80 00 00 	movabs $0x802823,%rax
  802b85:	00 00 00 
  802b88:	ff d0                	callq  *%rax
}
  802b8a:	c9                   	leaveq 
  802b8b:	c3                   	retq   

0000000000802b8c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802b8c:	55                   	push   %rbp
  802b8d:	48 89 e5             	mov    %rsp,%rbp
  802b90:	48 83 ec 10          	sub    $0x10,%rsp
  802b94:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802b97:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802b9e:	00 00 00 
  802ba1:	8b 00                	mov    (%rax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 1d                	jne    802bc4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802ba7:	bf 02 00 00 00       	mov    $0x2,%edi
  802bac:	48 b8 eb 3a 80 00 00 	movabs $0x803aeb,%rax
  802bb3:	00 00 00 
  802bb6:	ff d0                	callq  *%rax
  802bb8:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  802bbf:	00 00 00 
  802bc2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802bc4:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802bcb:	00 00 00 
  802bce:	8b 00                	mov    (%rax),%eax
  802bd0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802bd3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802bd8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802bdf:	00 00 00 
  802be2:	89 c7                	mov    %eax,%edi
  802be4:	48 b8 28 3a 80 00 00 	movabs $0x803a28,%rax
  802beb:	00 00 00 
  802bee:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf5:	be 00 00 00 00       	mov    $0x0,%esi
  802bfa:	bf 00 00 00 00       	mov    $0x0,%edi
  802bff:	48 b8 68 39 80 00 00 	movabs $0x803968,%rax
  802c06:	00 00 00 
  802c09:	ff d0                	callq  *%rax
}
  802c0b:	c9                   	leaveq 
  802c0c:	c3                   	retq   

0000000000802c0d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c0d:	55                   	push   %rbp
  802c0e:	48 89 e5             	mov    %rsp,%rbp
  802c11:	48 83 ec 30          	sub    $0x30,%rsp
  802c15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c18:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c1c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802c20:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c27:	00 00 00 
  802c2a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c2d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802c2f:	bf 01 00 00 00       	mov    $0x1,%edi
  802c34:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	78 3e                	js     802c87 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802c49:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802c50:	00 00 00 
  802c53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5b:	8b 40 10             	mov    0x10(%rax),%eax
  802c5e:	89 c2                	mov    %eax,%edx
  802c60:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802c64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c68:	48 89 ce             	mov    %rcx,%rsi
  802c6b:	48 89 c7             	mov    %rax,%rdi
  802c6e:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  802c75:	00 00 00 
  802c78:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802c7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c7e:	8b 50 10             	mov    0x10(%rax),%edx
  802c81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c85:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c8a:	c9                   	leaveq 
  802c8b:	c3                   	retq   

0000000000802c8c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c8c:	55                   	push   %rbp
  802c8d:	48 89 e5             	mov    %rsp,%rbp
  802c90:	48 83 ec 10          	sub    $0x10,%rsp
  802c94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c9b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802c9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ca5:	00 00 00 
  802ca8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cab:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802cad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb4:	48 89 c6             	mov    %rax,%rsi
  802cb7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802cbe:	00 00 00 
  802cc1:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  802cc8:	00 00 00 
  802ccb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802ccd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802cd4:	00 00 00 
  802cd7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802cda:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802cdd:	bf 02 00 00 00       	mov    $0x2,%edi
  802ce2:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 10          	sub    $0x10,%rsp
  802cf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cfb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802cfe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d05:	00 00 00 
  802d08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d0b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802d0d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d14:	00 00 00 
  802d17:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d1a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802d1d:	bf 03 00 00 00       	mov    $0x3,%edi
  802d22:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802d29:	00 00 00 
  802d2c:	ff d0                	callq  *%rax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <nsipc_close>:

int
nsipc_close(int s)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 83 ec 10          	sub    $0x10,%rsp
  802d38:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802d3b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d42:	00 00 00 
  802d45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d48:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802d4a:	bf 04 00 00 00       	mov    $0x4,%edi
  802d4f:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
}
  802d5b:	c9                   	leaveq 
  802d5c:	c3                   	retq   

0000000000802d5d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d5d:	55                   	push   %rbp
  802d5e:	48 89 e5             	mov    %rsp,%rbp
  802d61:	48 83 ec 10          	sub    $0x10,%rsp
  802d65:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d68:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d6c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802d6f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802d76:	00 00 00 
  802d79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d7c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802d7e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802d81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d85:	48 89 c6             	mov    %rax,%rsi
  802d88:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802d8f:	00 00 00 
  802d92:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  802d99:	00 00 00 
  802d9c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802d9e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802da5:	00 00 00 
  802da8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802dab:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802dae:	bf 05 00 00 00       	mov    $0x5,%edi
  802db3:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
}
  802dbf:	c9                   	leaveq 
  802dc0:	c3                   	retq   

0000000000802dc1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802dc1:	55                   	push   %rbp
  802dc2:	48 89 e5             	mov    %rsp,%rbp
  802dc5:	48 83 ec 10          	sub    $0x10,%rsp
  802dc9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802dcc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802dcf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802dd6:	00 00 00 
  802dd9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ddc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802dde:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802de5:	00 00 00 
  802de8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802deb:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802dee:	bf 06 00 00 00       	mov    $0x6,%edi
  802df3:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
}
  802dff:	c9                   	leaveq 
  802e00:	c3                   	retq   

0000000000802e01 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802e01:	55                   	push   %rbp
  802e02:	48 89 e5             	mov    %rsp,%rbp
  802e05:	48 83 ec 30          	sub    $0x30,%rsp
  802e09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e10:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802e13:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802e16:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e1d:	00 00 00 
  802e20:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e23:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802e25:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e2c:	00 00 00 
  802e2f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e32:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802e35:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e3c:	00 00 00 
  802e3f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e42:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802e45:	bf 07 00 00 00       	mov    $0x7,%edi
  802e4a:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
  802e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e5d:	78 69                	js     802ec8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802e5f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802e66:	7f 08                	jg     802e70 <nsipc_recv+0x6f>
  802e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802e6e:	7e 35                	jle    802ea5 <nsipc_recv+0xa4>
  802e70:	48 b9 9a 41 80 00 00 	movabs $0x80419a,%rcx
  802e77:	00 00 00 
  802e7a:	48 ba af 41 80 00 00 	movabs $0x8041af,%rdx
  802e81:	00 00 00 
  802e84:	be 61 00 00 00       	mov    $0x61,%esi
  802e89:	48 bf c4 41 80 00 00 	movabs $0x8041c4,%rdi
  802e90:	00 00 00 
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
  802e98:	49 b8 54 38 80 00 00 	movabs $0x803854,%r8
  802e9f:	00 00 00 
  802ea2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802ea5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea8:	48 63 d0             	movslq %eax,%rdx
  802eab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eaf:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802eb6:	00 00 00 
  802eb9:	48 89 c7             	mov    %rax,%rdi
  802ebc:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
	}

	return r;
  802ec8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ecb:	c9                   	leaveq 
  802ecc:	c3                   	retq   

0000000000802ecd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802ecd:	55                   	push   %rbp
  802ece:	48 89 e5             	mov    %rsp,%rbp
  802ed1:	48 83 ec 20          	sub    $0x20,%rsp
  802ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802edc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802edf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  802ee2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ee9:	00 00 00 
  802eec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802eef:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  802ef1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  802ef8:	7e 35                	jle    802f2f <nsipc_send+0x62>
  802efa:	48 b9 d0 41 80 00 00 	movabs $0x8041d0,%rcx
  802f01:	00 00 00 
  802f04:	48 ba af 41 80 00 00 	movabs $0x8041af,%rdx
  802f0b:	00 00 00 
  802f0e:	be 6c 00 00 00       	mov    $0x6c,%esi
  802f13:	48 bf c4 41 80 00 00 	movabs $0x8041c4,%rdi
  802f1a:	00 00 00 
  802f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f22:	49 b8 54 38 80 00 00 	movabs $0x803854,%r8
  802f29:	00 00 00 
  802f2c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802f2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f32:	48 63 d0             	movslq %eax,%rdx
  802f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f39:	48 89 c6             	mov    %rax,%rsi
  802f3c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  802f43:	00 00 00 
  802f46:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  802f4d:	00 00 00 
  802f50:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  802f52:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f59:	00 00 00 
  802f5c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f5f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  802f62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f69:	00 00 00 
  802f6c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f6f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  802f72:	bf 08 00 00 00       	mov    $0x8,%edi
  802f77:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
}
  802f83:	c9                   	leaveq 
  802f84:	c3                   	retq   

0000000000802f85 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802f85:	55                   	push   %rbp
  802f86:	48 89 e5             	mov    %rsp,%rbp
  802f89:	48 83 ec 10          	sub    $0x10,%rsp
  802f8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f90:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802f93:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  802f96:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f9d:	00 00 00 
  802fa0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fa3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  802fa5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fac:	00 00 00 
  802faf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fb2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  802fb5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fbc:	00 00 00 
  802fbf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802fc2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  802fc5:	bf 09 00 00 00       	mov    $0x9,%edi
  802fca:	48 b8 8c 2b 80 00 00 	movabs $0x802b8c,%rax
  802fd1:	00 00 00 
  802fd4:	ff d0                	callq  *%rax
}
  802fd6:	c9                   	leaveq 
  802fd7:	c3                   	retq   

0000000000802fd8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802fd8:	55                   	push   %rbp
  802fd9:	48 89 e5             	mov    %rsp,%rbp
  802fdc:	53                   	push   %rbx
  802fdd:	48 83 ec 38          	sub    $0x38,%rsp
  802fe1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802fe5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802fe9:	48 89 c7             	mov    %rax,%rdi
  802fec:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  802ff3:	00 00 00 
  802ff6:	ff d0                	callq  *%rax
  802ff8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ffb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fff:	0f 88 bf 01 00 00    	js     8031c4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803005:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803009:	ba 07 04 00 00       	mov    $0x407,%edx
  80300e:	48 89 c6             	mov    %rax,%rsi
  803011:	bf 00 00 00 00       	mov    $0x0,%edi
  803016:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
  803022:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803025:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803029:	0f 88 95 01 00 00    	js     8031c4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80302f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803033:	48 89 c7             	mov    %rax,%rdi
  803036:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  80303d:	00 00 00 
  803040:	ff d0                	callq  *%rax
  803042:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803045:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803049:	0f 88 5d 01 00 00    	js     8031ac <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80304f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803053:	ba 07 04 00 00       	mov    $0x407,%edx
  803058:	48 89 c6             	mov    %rax,%rsi
  80305b:	bf 00 00 00 00       	mov    $0x0,%edi
  803060:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  803067:	00 00 00 
  80306a:	ff d0                	callq  *%rax
  80306c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80306f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803073:	0f 88 33 01 00 00    	js     8031ac <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80307d:	48 89 c7             	mov    %rax,%rdi
  803080:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  803087:	00 00 00 
  80308a:	ff d0                	callq  *%rax
  80308c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803090:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803094:	ba 07 04 00 00       	mov    $0x407,%edx
  803099:	48 89 c6             	mov    %rax,%rsi
  80309c:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a1:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  8030a8:	00 00 00 
  8030ab:	ff d0                	callq  *%rax
  8030ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b4:	0f 88 d9 00 00 00    	js     803193 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030be:	48 89 c7             	mov    %rax,%rdi
  8030c1:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	48 89 c2             	mov    %rax,%rdx
  8030d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8030da:	48 89 d1             	mov    %rdx,%rcx
  8030dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8030e2:	48 89 c6             	mov    %rax,%rsi
  8030e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ea:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  8030f1:	00 00 00 
  8030f4:	ff d0                	callq  *%rax
  8030f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030fd:	78 79                	js     803178 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8030ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803103:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80310a:	00 00 00 
  80310d:	8b 12                	mov    (%rdx),%edx
  80310f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803111:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803115:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80311c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803120:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803127:	00 00 00 
  80312a:	8b 12                	mov    (%rdx),%edx
  80312c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80312e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803132:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803139:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80313d:	48 89 c7             	mov    %rax,%rdi
  803140:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803147:	00 00 00 
  80314a:	ff d0                	callq  *%rax
  80314c:	89 c2                	mov    %eax,%edx
  80314e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803152:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803154:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803158:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80315c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
  80316f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803171:	b8 00 00 00 00       	mov    $0x0,%eax
  803176:	eb 4f                	jmp    8031c7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803178:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803179:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80317d:	48 89 c6             	mov    %rax,%rsi
  803180:	bf 00 00 00 00       	mov    $0x0,%edi
  803185:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
  803191:	eb 01                	jmp    803194 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803193:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803194:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803198:	48 89 c6             	mov    %rax,%rsi
  80319b:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a0:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  8031a7:	00 00 00 
  8031aa:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8031ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b0:	48 89 c6             	mov    %rax,%rsi
  8031b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031b8:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
    err:
	return r;
  8031c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8031c7:	48 83 c4 38          	add    $0x38,%rsp
  8031cb:	5b                   	pop    %rbx
  8031cc:	5d                   	pop    %rbp
  8031cd:	c3                   	retq   

00000000008031ce <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8031ce:	55                   	push   %rbp
  8031cf:	48 89 e5             	mov    %rsp,%rbp
  8031d2:	53                   	push   %rbx
  8031d3:	48 83 ec 28          	sub    $0x28,%rsp
  8031d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031df:	eb 01                	jmp    8031e2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8031e1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8031e2:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8031e9:	00 00 00 
  8031ec:	48 8b 00             	mov    (%rax),%rax
  8031ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8031f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8031f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fc:	48 89 c7             	mov    %rax,%rdi
  8031ff:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
  80320b:	89 c3                	mov    %eax,%ebx
  80320d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803211:	48 89 c7             	mov    %rax,%rdi
  803214:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  80321b:	00 00 00 
  80321e:	ff d0                	callq  *%rax
  803220:	39 c3                	cmp    %eax,%ebx
  803222:	0f 94 c0             	sete   %al
  803225:	0f b6 c0             	movzbl %al,%eax
  803228:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80322b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803232:	00 00 00 
  803235:	48 8b 00             	mov    (%rax),%rax
  803238:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80323e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803241:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803244:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803247:	75 0a                	jne    803253 <_pipeisclosed+0x85>
			return ret;
  803249:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80324c:	48 83 c4 28          	add    $0x28,%rsp
  803250:	5b                   	pop    %rbx
  803251:	5d                   	pop    %rbp
  803252:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803253:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803256:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803259:	74 86                	je     8031e1 <_pipeisclosed+0x13>
  80325b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80325f:	75 80                	jne    8031e1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803261:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803268:	00 00 00 
  80326b:	48 8b 00             	mov    (%rax),%rax
  80326e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803274:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803277:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327a:	89 c6                	mov    %eax,%esi
  80327c:	48 bf e1 41 80 00 00 	movabs $0x8041e1,%rdi
  803283:	00 00 00 
  803286:	b8 00 00 00 00       	mov    $0x0,%eax
  80328b:	49 b8 8f 02 80 00 00 	movabs $0x80028f,%r8
  803292:	00 00 00 
  803295:	41 ff d0             	callq  *%r8
	}
  803298:	e9 44 ff ff ff       	jmpq   8031e1 <_pipeisclosed+0x13>

000000000080329d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 30          	sub    $0x30,%rsp
  8032a5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032a8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032af:	48 89 d6             	mov    %rdx,%rsi
  8032b2:	89 c7                	mov    %eax,%edi
  8032b4:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  8032bb:	00 00 00 
  8032be:	ff d0                	callq  *%rax
  8032c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032c7:	79 05                	jns    8032ce <pipeisclosed+0x31>
		return r;
  8032c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032cc:	eb 31                	jmp    8032ff <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8032ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d2:	48 89 c7             	mov    %rax,%rdi
  8032d5:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	callq  *%rax
  8032e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8032e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ed:	48 89 d6             	mov    %rdx,%rsi
  8032f0:	48 89 c7             	mov    %rax,%rdi
  8032f3:	48 b8 ce 31 80 00 00 	movabs $0x8031ce,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
}
  8032ff:	c9                   	leaveq 
  803300:	c3                   	retq   

0000000000803301 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803301:	55                   	push   %rbp
  803302:	48 89 e5             	mov    %rsp,%rbp
  803305:	48 83 ec 40          	sub    $0x40,%rsp
  803309:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80330d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803311:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803319:	48 89 c7             	mov    %rax,%rdi
  80331c:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  803323:	00 00 00 
  803326:	ff d0                	callq  *%rax
  803328:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80332c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803330:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803334:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80333b:	00 
  80333c:	e9 97 00 00 00       	jmpq   8033d8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803341:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803346:	74 09                	je     803351 <devpipe_read+0x50>
				return i;
  803348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334c:	e9 95 00 00 00       	jmpq   8033e6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803351:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803359:	48 89 d6             	mov    %rdx,%rsi
  80335c:	48 89 c7             	mov    %rax,%rdi
  80335f:	48 b8 ce 31 80 00 00 	movabs $0x8031ce,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	74 07                	je     803376 <devpipe_read+0x75>
				return 0;
  80336f:	b8 00 00 00 00       	mov    $0x0,%eax
  803374:	eb 70                	jmp    8033e6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803376:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  80337d:	00 00 00 
  803380:	ff d0                	callq  *%rax
  803382:	eb 01                	jmp    803385 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803384:	90                   	nop
  803385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803389:	8b 10                	mov    (%rax),%edx
  80338b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80338f:	8b 40 04             	mov    0x4(%rax),%eax
  803392:	39 c2                	cmp    %eax,%edx
  803394:	74 ab                	je     803341 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803396:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80339a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80339e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8033a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a6:	8b 00                	mov    (%rax),%eax
  8033a8:	89 c2                	mov    %eax,%edx
  8033aa:	c1 fa 1f             	sar    $0x1f,%edx
  8033ad:	c1 ea 1b             	shr    $0x1b,%edx
  8033b0:	01 d0                	add    %edx,%eax
  8033b2:	83 e0 1f             	and    $0x1f,%eax
  8033b5:	29 d0                	sub    %edx,%eax
  8033b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033bb:	48 98                	cltq   
  8033bd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8033c2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8033c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c8:	8b 00                	mov    (%rax),%eax
  8033ca:	8d 50 01             	lea    0x1(%rax),%edx
  8033cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033dc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033e0:	72 a2                	jb     803384 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8033e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033e6:	c9                   	leaveq 
  8033e7:	c3                   	retq   

00000000008033e8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033e8:	55                   	push   %rbp
  8033e9:	48 89 e5             	mov    %rsp,%rbp
  8033ec:	48 83 ec 40          	sub    $0x40,%rsp
  8033f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8033fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803400:	48 89 c7             	mov    %rax,%rdi
  803403:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
  80340f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803413:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803417:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80341b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803422:	00 
  803423:	e9 93 00 00 00       	jmpq   8034bb <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80342c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803430:	48 89 d6             	mov    %rdx,%rsi
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 ce 31 80 00 00 	movabs $0x8031ce,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	85 c0                	test   %eax,%eax
  803444:	74 07                	je     80344d <devpipe_write+0x65>
				return 0;
  803446:	b8 00 00 00 00       	mov    $0x0,%eax
  80344b:	eb 7c                	jmp    8034c9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80344d:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	eb 01                	jmp    80345c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80345b:	90                   	nop
  80345c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803460:	8b 40 04             	mov    0x4(%rax),%eax
  803463:	48 63 d0             	movslq %eax,%rdx
  803466:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80346a:	8b 00                	mov    (%rax),%eax
  80346c:	48 98                	cltq   
  80346e:	48 83 c0 20          	add    $0x20,%rax
  803472:	48 39 c2             	cmp    %rax,%rdx
  803475:	73 b1                	jae    803428 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347b:	8b 40 04             	mov    0x4(%rax),%eax
  80347e:	89 c2                	mov    %eax,%edx
  803480:	c1 fa 1f             	sar    $0x1f,%edx
  803483:	c1 ea 1b             	shr    $0x1b,%edx
  803486:	01 d0                	add    %edx,%eax
  803488:	83 e0 1f             	and    $0x1f,%eax
  80348b:	29 d0                	sub    %edx,%eax
  80348d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803491:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803495:	48 01 ca             	add    %rcx,%rdx
  803498:	0f b6 0a             	movzbl (%rdx),%ecx
  80349b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80349f:	48 98                	cltq   
  8034a1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8034a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a9:	8b 40 04             	mov    0x4(%rax),%eax
  8034ac:	8d 50 01             	lea    0x1(%rax),%edx
  8034af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034b6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034c3:	72 96                	jb     80345b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8034c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8034c9:	c9                   	leaveq 
  8034ca:	c3                   	retq   

00000000008034cb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8034cb:	55                   	push   %rbp
  8034cc:	48 89 e5             	mov    %rsp,%rbp
  8034cf:	48 83 ec 20          	sub    $0x20,%rsp
  8034d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8034db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034df:	48 89 c7             	mov    %rax,%rdi
  8034e2:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  8034e9:	00 00 00 
  8034ec:	ff d0                	callq  *%rax
  8034ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8034f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f6:	48 be f4 41 80 00 00 	movabs $0x8041f4,%rsi
  8034fd:	00 00 00 
  803500:	48 89 c7             	mov    %rax,%rdi
  803503:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80350f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803513:	8b 50 04             	mov    0x4(%rax),%edx
  803516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80351a:	8b 00                	mov    (%rax),%eax
  80351c:	29 c2                	sub    %eax,%edx
  80351e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803522:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803528:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80352c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803533:	00 00 00 
	stat->st_dev = &devpipe;
  803536:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803541:	00 00 00 
  803544:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803550:	c9                   	leaveq 
  803551:	c3                   	retq   

0000000000803552 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803552:	55                   	push   %rbp
  803553:	48 89 e5             	mov    %rsp,%rbp
  803556:	48 83 ec 10          	sub    $0x10,%rsp
  80355a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80355e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803562:	48 89 c6             	mov    %rax,%rsi
  803565:	bf 00 00 00 00       	mov    $0x0,%edi
  80356a:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  803571:	00 00 00 
  803574:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80357a:	48 89 c7             	mov    %rax,%rdi
  80357d:	48 b8 e7 1a 80 00 00 	movabs $0x801ae7,%rax
  803584:	00 00 00 
  803587:	ff d0                	callq  *%rax
  803589:	48 89 c6             	mov    %rax,%rsi
  80358c:	bf 00 00 00 00       	mov    $0x0,%edi
  803591:	48 b8 2f 18 80 00 00 	movabs $0x80182f,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
}
  80359d:	c9                   	leaveq 
  80359e:	c3                   	retq   
	...

00000000008035a0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8035a0:	55                   	push   %rbp
  8035a1:	48 89 e5             	mov    %rsp,%rbp
  8035a4:	48 83 ec 20          	sub    $0x20,%rsp
  8035a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8035ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035ae:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8035b1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8035b5:	be 01 00 00 00       	mov    $0x1,%esi
  8035ba:	48 89 c7             	mov    %rax,%rdi
  8035bd:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8035c4:	00 00 00 
  8035c7:	ff d0                	callq  *%rax
}
  8035c9:	c9                   	leaveq 
  8035ca:	c3                   	retq   

00000000008035cb <getchar>:

int
getchar(void)
{
  8035cb:	55                   	push   %rbp
  8035cc:	48 89 e5             	mov    %rsp,%rbp
  8035cf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8035d3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8035d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8035dc:	48 89 c6             	mov    %rax,%rsi
  8035df:	bf 00 00 00 00       	mov    $0x0,%edi
  8035e4:	48 b8 dc 1f 80 00 00 	movabs $0x801fdc,%rax
  8035eb:	00 00 00 
  8035ee:	ff d0                	callq  *%rax
  8035f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8035f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f7:	79 05                	jns    8035fe <getchar+0x33>
		return r;
  8035f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fc:	eb 14                	jmp    803612 <getchar+0x47>
	if (r < 1)
  8035fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803602:	7f 07                	jg     80360b <getchar+0x40>
		return -E_EOF;
  803604:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803609:	eb 07                	jmp    803612 <getchar+0x47>
	return c;
  80360b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80360f:	0f b6 c0             	movzbl %al,%eax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	48 83 ec 20          	sub    $0x20,%rsp
  80361c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80361f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803623:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803626:	48 89 d6             	mov    %rdx,%rsi
  803629:	89 c7                	mov    %eax,%edi
  80362b:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
  803637:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363e:	79 05                	jns    803645 <iscons+0x31>
		return r;
  803640:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803643:	eb 1a                	jmp    80365f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803645:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803649:	8b 10                	mov    (%rax),%edx
  80364b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803652:	00 00 00 
  803655:	8b 00                	mov    (%rax),%eax
  803657:	39 c2                	cmp    %eax,%edx
  803659:	0f 94 c0             	sete   %al
  80365c:	0f b6 c0             	movzbl %al,%eax
}
  80365f:	c9                   	leaveq 
  803660:	c3                   	retq   

0000000000803661 <opencons>:

int
opencons(void)
{
  803661:	55                   	push   %rbp
  803662:	48 89 e5             	mov    %rsp,%rbp
  803665:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803669:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80366d:	48 89 c7             	mov    %rax,%rdi
  803670:	48 b8 12 1b 80 00 00 	movabs $0x801b12,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
  80367c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803683:	79 05                	jns    80368a <opencons+0x29>
		return r;
  803685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803688:	eb 5b                	jmp    8036e5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80368a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368e:	ba 07 04 00 00       	mov    $0x407,%edx
  803693:	48 89 c6             	mov    %rax,%rsi
  803696:	bf 00 00 00 00       	mov    $0x0,%edi
  80369b:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
  8036a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ae:	79 05                	jns    8036b5 <opencons+0x54>
		return r;
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	eb 30                	jmp    8036e5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8036b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8036c0:	00 00 00 
  8036c3:	8b 12                	mov    (%rdx),%edx
  8036c5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8036c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8036d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d6:	48 89 c7             	mov    %rax,%rdi
  8036d9:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8036e0:	00 00 00 
  8036e3:	ff d0                	callq  *%rax
}
  8036e5:	c9                   	leaveq 
  8036e6:	c3                   	retq   

00000000008036e7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036e7:	55                   	push   %rbp
  8036e8:	48 89 e5             	mov    %rsp,%rbp
  8036eb:	48 83 ec 30          	sub    $0x30,%rsp
  8036ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8036fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803700:	75 13                	jne    803715 <devcons_read+0x2e>
		return 0;
  803702:	b8 00 00 00 00       	mov    $0x0,%eax
  803707:	eb 49                	jmp    803752 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803709:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803715:	48 b8 86 16 80 00 00 	movabs $0x801686,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803728:	74 df                	je     803709 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80372a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372e:	79 05                	jns    803735 <devcons_read+0x4e>
		return c;
  803730:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803733:	eb 1d                	jmp    803752 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803735:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803739:	75 07                	jne    803742 <devcons_read+0x5b>
		return 0;
  80373b:	b8 00 00 00 00       	mov    $0x0,%eax
  803740:	eb 10                	jmp    803752 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803742:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803745:	89 c2                	mov    %eax,%edx
  803747:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374b:	88 10                	mov    %dl,(%rax)
	return 1;
  80374d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803752:	c9                   	leaveq 
  803753:	c3                   	retq   

0000000000803754 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803754:	55                   	push   %rbp
  803755:	48 89 e5             	mov    %rsp,%rbp
  803758:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80375f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803766:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80376d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803774:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80377b:	eb 77                	jmp    8037f4 <devcons_write+0xa0>
		m = n - tot;
  80377d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803784:	89 c2                	mov    %eax,%edx
  803786:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803789:	89 d1                	mov    %edx,%ecx
  80378b:	29 c1                	sub    %eax,%ecx
  80378d:	89 c8                	mov    %ecx,%eax
  80378f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803792:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803795:	83 f8 7f             	cmp    $0x7f,%eax
  803798:	76 07                	jbe    8037a1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80379a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8037a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037a4:	48 63 d0             	movslq %eax,%rdx
  8037a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037aa:	48 98                	cltq   
  8037ac:	48 89 c1             	mov    %rax,%rcx
  8037af:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8037b6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8037bd:	48 89 ce             	mov    %rcx,%rsi
  8037c0:	48 89 c7             	mov    %rax,%rdi
  8037c3:	48 b8 6e 11 80 00 00 	movabs $0x80116e,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8037cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037d2:	48 63 d0             	movslq %eax,%rdx
  8037d5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8037dc:	48 89 d6             	mov    %rdx,%rsi
  8037df:	48 89 c7             	mov    %rax,%rdi
  8037e2:	48 b8 3c 16 80 00 00 	movabs $0x80163c,%rax
  8037e9:	00 00 00 
  8037ec:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8037ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037f1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8037f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f7:	48 98                	cltq   
  8037f9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803800:	0f 82 77 ff ff ff    	jb     80377d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803806:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803809:	c9                   	leaveq 
  80380a:	c3                   	retq   

000000000080380b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80380b:	55                   	push   %rbp
  80380c:	48 89 e5             	mov    %rsp,%rbp
  80380f:	48 83 ec 08          	sub    $0x8,%rsp
  803813:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803817:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80381c:	c9                   	leaveq 
  80381d:	c3                   	retq   

000000000080381e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80381e:	55                   	push   %rbp
  80381f:	48 89 e5             	mov    %rsp,%rbp
  803822:	48 83 ec 10          	sub    $0x10,%rsp
  803826:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80382a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80382e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803832:	48 be 00 42 80 00 00 	movabs $0x804200,%rsi
  803839:	00 00 00 
  80383c:	48 89 c7             	mov    %rax,%rdi
  80383f:	48 b8 4c 0e 80 00 00 	movabs $0x800e4c,%rax
  803846:	00 00 00 
  803849:	ff d0                	callq  *%rax
	return 0;
  80384b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803850:	c9                   	leaveq 
  803851:	c3                   	retq   
	...

0000000000803854 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803854:	55                   	push   %rbp
  803855:	48 89 e5             	mov    %rsp,%rbp
  803858:	53                   	push   %rbx
  803859:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803860:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803867:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80386d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803874:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80387b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803882:	84 c0                	test   %al,%al
  803884:	74 23                	je     8038a9 <_panic+0x55>
  803886:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80388d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803891:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803895:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803899:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80389d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8038a1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8038a5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8038a9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8038b0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8038b7:	00 00 00 
  8038ba:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8038c1:	00 00 00 
  8038c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8038c8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8038cf:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8038d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8038dd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8038e4:	00 00 00 
  8038e7:	48 8b 18             	mov    (%rax),%rbx
  8038ea:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
  8038f6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8038fc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803903:	41 89 c8             	mov    %ecx,%r8d
  803906:	48 89 d1             	mov    %rdx,%rcx
  803909:	48 89 da             	mov    %rbx,%rdx
  80390c:	89 c6                	mov    %eax,%esi
  80390e:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  803915:	00 00 00 
  803918:	b8 00 00 00 00       	mov    $0x0,%eax
  80391d:	49 b9 8f 02 80 00 00 	movabs $0x80028f,%r9
  803924:	00 00 00 
  803927:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80392a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803931:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803938:	48 89 d6             	mov    %rdx,%rsi
  80393b:	48 89 c7             	mov    %rax,%rdi
  80393e:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  803945:	00 00 00 
  803948:	ff d0                	callq  *%rax
	cprintf("\n");
  80394a:	48 bf 2b 42 80 00 00 	movabs $0x80422b,%rdi
  803951:	00 00 00 
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
  803959:	48 ba 8f 02 80 00 00 	movabs $0x80028f,%rdx
  803960:	00 00 00 
  803963:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803965:	cc                   	int3   
  803966:	eb fd                	jmp    803965 <_panic+0x111>

0000000000803968 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803968:	55                   	push   %rbp
  803969:	48 89 e5             	mov    %rsp,%rbp
  80396c:	48 83 ec 30          	sub    $0x30,%rsp
  803970:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803974:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803978:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  80397c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803981:	74 18                	je     80399b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803983:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803987:	48 89 c7             	mov    %rax,%rdi
  80398a:	48 b8 ad 19 80 00 00 	movabs $0x8019ad,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
  803996:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803999:	eb 19                	jmp    8039b4 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80399b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8039a2:	00 00 00 
  8039a5:	48 b8 ad 19 80 00 00 	movabs $0x8019ad,%rax
  8039ac:	00 00 00 
  8039af:	ff d0                	callq  *%rax
  8039b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8039b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b8:	79 19                	jns    8039d3 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8039ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039be:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8039c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8039ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d1:	eb 53                	jmp    803a26 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8039d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039d8:	74 19                	je     8039f3 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8039da:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8039e1:	00 00 00 
  8039e4:	48 8b 00             	mov    (%rax),%rax
  8039e7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8039ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f1:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8039f3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8039f8:	74 19                	je     803a13 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8039fa:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a01:	00 00 00 
  803a04:	48 8b 00             	mov    (%rax),%rax
  803a07:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a11:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803a13:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803a1a:	00 00 00 
  803a1d:	48 8b 00             	mov    (%rax),%rax
  803a20:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803a26:	c9                   	leaveq 
  803a27:	c3                   	retq   

0000000000803a28 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a28:	55                   	push   %rbp
  803a29:	48 89 e5             	mov    %rsp,%rbp
  803a2c:	48 83 ec 30          	sub    $0x30,%rsp
  803a30:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a33:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a36:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a3a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803a3d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803a44:	e9 96 00 00 00       	jmpq   803adf <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803a49:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a4e:	74 20                	je     803a70 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803a50:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a53:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803a56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803a5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a5d:	89 c7                	mov    %eax,%edi
  803a5f:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
  803a6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6e:	eb 2d                	jmp    803a9d <ipc_send+0x75>
		else if(pg==NULL)
  803a70:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a75:	75 26                	jne    803a9d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803a77:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803a7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a82:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803a89:	00 00 00 
  803a8c:	89 c7                	mov    %eax,%edi
  803a8e:	48 b8 58 19 80 00 00 	movabs $0x801958,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
  803a9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803a9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa1:	79 30                	jns    803ad3 <ipc_send+0xab>
  803aa3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803aa7:	74 2a                	je     803ad3 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803aa9:	48 ba 2d 42 80 00 00 	movabs $0x80422d,%rdx
  803ab0:	00 00 00 
  803ab3:	be 40 00 00 00       	mov    $0x40,%esi
  803ab8:	48 bf 45 42 80 00 00 	movabs $0x804245,%rdi
  803abf:	00 00 00 
  803ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac7:	48 b9 54 38 80 00 00 	movabs $0x803854,%rcx
  803ace:	00 00 00 
  803ad1:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803ad3:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803adf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ae3:	0f 85 60 ff ff ff    	jne    803a49 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803ae9:	c9                   	leaveq 
  803aea:	c3                   	retq   

0000000000803aeb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803aeb:	55                   	push   %rbp
  803aec:	48 89 e5             	mov    %rsp,%rbp
  803aef:	48 83 ec 18          	sub    $0x18,%rsp
  803af3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803afd:	eb 5e                	jmp    803b5d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803aff:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b06:	00 00 00 
  803b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0c:	48 63 d0             	movslq %eax,%rdx
  803b0f:	48 89 d0             	mov    %rdx,%rax
  803b12:	48 c1 e0 03          	shl    $0x3,%rax
  803b16:	48 01 d0             	add    %rdx,%rax
  803b19:	48 c1 e0 05          	shl    $0x5,%rax
  803b1d:	48 01 c8             	add    %rcx,%rax
  803b20:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b26:	8b 00                	mov    (%rax),%eax
  803b28:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b2b:	75 2c                	jne    803b59 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b2d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b34:	00 00 00 
  803b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3a:	48 63 d0             	movslq %eax,%rdx
  803b3d:	48 89 d0             	mov    %rdx,%rax
  803b40:	48 c1 e0 03          	shl    $0x3,%rax
  803b44:	48 01 d0             	add    %rdx,%rax
  803b47:	48 c1 e0 05          	shl    $0x5,%rax
  803b4b:	48 01 c8             	add    %rcx,%rax
  803b4e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b54:	8b 40 08             	mov    0x8(%rax),%eax
  803b57:	eb 12                	jmp    803b6b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803b59:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b5d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b64:	7e 99                	jle    803aff <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b6b:	c9                   	leaveq 
  803b6c:	c3                   	retq   
  803b6d:	00 00                	add    %al,(%rax)
	...

0000000000803b70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b70:	55                   	push   %rbp
  803b71:	48 89 e5             	mov    %rsp,%rbp
  803b74:	48 83 ec 18          	sub    $0x18,%rsp
  803b78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803b7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b80:	48 89 c2             	mov    %rax,%rdx
  803b83:	48 c1 ea 15          	shr    $0x15,%rdx
  803b87:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803b8e:	01 00 00 
  803b91:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b95:	83 e0 01             	and    $0x1,%eax
  803b98:	48 85 c0             	test   %rax,%rax
  803b9b:	75 07                	jne    803ba4 <pageref+0x34>
		return 0;
  803b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba2:	eb 53                	jmp    803bf7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803ba4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ba8:	48 89 c2             	mov    %rax,%rdx
  803bab:	48 c1 ea 0c          	shr    $0xc,%rdx
  803baf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bb6:	01 00 00 
  803bb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bc5:	83 e0 01             	and    $0x1,%eax
  803bc8:	48 85 c0             	test   %rax,%rax
  803bcb:	75 07                	jne    803bd4 <pageref+0x64>
		return 0;
  803bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd2:	eb 23                	jmp    803bf7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bd8:	48 89 c2             	mov    %rax,%rdx
  803bdb:	48 c1 ea 0c          	shr    $0xc,%rdx
  803bdf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803be6:	00 00 00 
  803be9:	48 c1 e2 04          	shl    $0x4,%rdx
  803bed:	48 01 d0             	add    %rdx,%rax
  803bf0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803bf4:	0f b7 c0             	movzwl %ax,%eax
}
  803bf7:	c9                   	leaveq 
  803bf8:	c3                   	retq   
