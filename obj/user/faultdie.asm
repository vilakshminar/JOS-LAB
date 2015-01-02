
obj/user/faultdie.debug:     file format elf64-x86-64


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
  80003c:	e8 9f 00 00 00       	callq  8000e0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  800050:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800054:	48 8b 00             	mov    (%rax),%rax
  800057:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800063:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800066:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800069:	89 c2                	mov    %eax,%edx
  80006b:	83 e2 07             	and    $0x7,%edx
  80006e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800072:	48 89 c6             	mov    %rax,%rsi
  800075:	48 bf a0 3d 80 00 00 	movabs $0x803da0,%rdi
  80007c:	00 00 00 
  80007f:	b8 00 00 00 00       	mov    $0x0,%eax
  800084:	48 b9 cf 02 80 00 00 	movabs $0x8002cf,%rcx
  80008b:	00 00 00 
  80008e:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  800090:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  800097:	00 00 00 
  80009a:	ff d0                	callq  *%rax
  80009c:	89 c7                	mov    %eax,%edi
  80009e:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  8000a5:	00 00 00 
  8000a8:	ff d0                	callq  *%rax
}
  8000aa:	c9                   	leaveq 
  8000ab:	c3                   	retq   

00000000008000ac <umain>:

void
umain(int argc, char **argv)
{
  8000ac:	55                   	push   %rbp
  8000ad:	48 89 e5             	mov    %rsp,%rbp
  8000b0:	48 83 ec 10          	sub    $0x10,%rsp
  8000b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000bb:	48 bf 44 00 80 00 00 	movabs $0x800044,%rdi
  8000c2:	00 00 00 
  8000c5:	48 b8 04 1b 80 00 00 	movabs $0x801b04,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d1:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000dc:	c9                   	leaveq 
  8000dd:	c3                   	retq   
	...

00000000008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %rbp
  8000e1:	48 89 e5             	mov    %rsp,%rbp
  8000e4:	48 83 ec 10          	sub    $0x10,%rsp
  8000e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ef:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8000f6:	00 00 00 
  8000f9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800100:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 c2             	mov    %rax,%rdx
  800111:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800117:	48 89 d0             	mov    %rdx,%rax
  80011a:	48 c1 e0 03          	shl    $0x3,%rax
  80011e:	48 01 d0             	add    %rdx,%rax
  800121:	48 c1 e0 05          	shl    $0x5,%rax
  800125:	48 89 c2             	mov    %rax,%rdx
  800128:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80012f:	00 00 00 
  800132:	48 01 c2             	add    %rax,%rdx
  800135:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80013c:	00 00 00 
  80013f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800142:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800146:	7e 14                	jle    80015c <libmain+0x7c>
		binaryname = argv[0];
  800148:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014c:	48 8b 10             	mov    (%rax),%rdx
  80014f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800156:	00 00 00 
  800159:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80015c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800160:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800163:	48 89 d6             	mov    %rdx,%rsi
  800166:	89 c7                	mov    %eax,%edi
  800168:	48 b8 ac 00 80 00 00 	movabs $0x8000ac,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800174:	48 b8 84 01 80 00 00 	movabs $0x800184,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
}
  800180:	c9                   	leaveq 
  800181:	c3                   	retq   
	...

0000000000800184 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800184:	55                   	push   %rbp
  800185:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800188:	48 b8 95 1f 80 00 00 	movabs $0x801f95,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800194:	bf 00 00 00 00       	mov    $0x0,%edi
  800199:	48 b8 04 17 80 00 00 	movabs $0x801704,%rax
  8001a0:	00 00 00 
  8001a3:	ff d0                	callq  *%rax
}
  8001a5:	5d                   	pop    %rbp
  8001a6:	c3                   	retq   
	...

00000000008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp
  8001ac:	48 83 ec 10          	sub    $0x10,%rsp
  8001b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bb:	8b 00                	mov    (%rax),%eax
  8001bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001c0:	89 d6                	mov    %edx,%esi
  8001c2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8001c6:	48 63 d0             	movslq %eax,%rdx
  8001c9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8001ce:	8d 50 01             	lea    0x1(%rax),%edx
  8001d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d5:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8001d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001db:	8b 00                	mov    (%rax),%eax
  8001dd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e2:	75 2c                	jne    800210 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8001e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e8:	8b 00                	mov    (%rax),%eax
  8001ea:	48 98                	cltq   
  8001ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f0:	48 83 c2 08          	add    $0x8,%rdx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	48 89 d7             	mov    %rdx,%rdi
  8001fa:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax
		b->idx = 0;
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800214:	8b 40 04             	mov    0x4(%rax),%eax
  800217:	8d 50 01             	lea    0x1(%rax),%edx
  80021a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800221:	c9                   	leaveq 
  800222:	c3                   	retq   

0000000000800223 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800223:	55                   	push   %rbp
  800224:	48 89 e5             	mov    %rsp,%rbp
  800227:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80022e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800235:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80023c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800243:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80024a:	48 8b 0a             	mov    (%rdx),%rcx
  80024d:	48 89 08             	mov    %rcx,(%rax)
  800250:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800254:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800258:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80025c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800260:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800267:	00 00 00 
	b.cnt = 0;
  80026a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800271:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800274:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80027b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800282:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800289:	48 89 c6             	mov    %rax,%rsi
  80028c:	48 bf a8 01 80 00 00 	movabs $0x8001a8,%rdi
  800293:	00 00 00 
  800296:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  80029d:	00 00 00 
  8002a0:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002a2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002a8:	48 98                	cltq   
  8002aa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002b1:	48 83 c2 08          	add    $0x8,%rdx
  8002b5:	48 89 c6             	mov    %rax,%rsi
  8002b8:	48 89 d7             	mov    %rdx,%rdi
  8002bb:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  8002c2:	00 00 00 
  8002c5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8002c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002cd:	c9                   	leaveq 
  8002ce:	c3                   	retq   

00000000008002cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002cf:	55                   	push   %rbp
  8002d0:	48 89 e5             	mov    %rsp,%rbp
  8002d3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002da:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002e1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002e8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002ef:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002f6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 20                	je     800321 <cprintf+0x52>
  800301:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800305:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800309:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80030d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800311:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800315:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800319:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80031d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800321:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800328:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80032f:	00 00 00 
  800332:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800339:	00 00 00 
  80033c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800340:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800347:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80034e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800355:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80035c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800363:	48 8b 0a             	mov    (%rdx),%rcx
  800366:	48 89 08             	mov    %rcx,(%rax)
  800369:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80036d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800371:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800375:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800379:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800380:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800387:	48 89 d6             	mov    %rdx,%rsi
  80038a:	48 89 c7             	mov    %rax,%rdi
  80038d:	48 b8 23 02 80 00 00 	movabs $0x800223,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
  800399:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80039f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003a5:	c9                   	leaveq 
  8003a6:	c3                   	retq   
	...

00000000008003a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a8:	55                   	push   %rbp
  8003a9:	48 89 e5             	mov    %rsp,%rbp
  8003ac:	48 83 ec 30          	sub    $0x30,%rsp
  8003b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003bc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003bf:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8003c3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003ca:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8003ce:	77 52                	ja     800422 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003d3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003d7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8003da:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8003de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8003eb:	48 89 c2             	mov    %rax,%rdx
  8003ee:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8003f1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8003f4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8003f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003fc:	41 89 f9             	mov    %edi,%r9d
  8003ff:	48 89 c7             	mov    %rax,%rdi
  800402:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  800409:	00 00 00 
  80040c:	ff d0                	callq  *%rax
  80040e:	eb 1c                	jmp    80042c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800410:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800414:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800417:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80041b:	48 89 d6             	mov    %rdx,%rsi
  80041e:	89 c7                	mov    %eax,%edi
  800420:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800422:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800426:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80042a:	7f e4                	jg     800410 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80042f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	48 f7 f1             	div    %rcx
  80043b:	48 89 d0             	mov    %rdx,%rax
  80043e:	48 ba a8 3f 80 00 00 	movabs $0x803fa8,%rdx
  800445:	00 00 00 
  800448:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80044c:	0f be c0             	movsbl %al,%eax
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800457:	48 89 d6             	mov    %rdx,%rsi
  80045a:	89 c7                	mov    %eax,%edi
  80045c:	ff d1                	callq  *%rcx
}
  80045e:	c9                   	leaveq 
  80045f:	c3                   	retq   

0000000000800460 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	48 83 ec 20          	sub    $0x20,%rsp
  800468:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80046c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80046f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800473:	7e 52                	jle    8004c7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	8b 00                	mov    (%rax),%eax
  80047b:	83 f8 30             	cmp    $0x30,%eax
  80047e:	73 24                	jae    8004a4 <getuint+0x44>
  800480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800484:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048c:	8b 00                	mov    (%rax),%eax
  80048e:	89 c0                	mov    %eax,%eax
  800490:	48 01 d0             	add    %rdx,%rax
  800493:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800497:	8b 12                	mov    (%rdx),%edx
  800499:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a0:	89 0a                	mov    %ecx,(%rdx)
  8004a2:	eb 17                	jmp    8004bb <getuint+0x5b>
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ac:	48 89 d0             	mov    %rdx,%rax
  8004af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004bb:	48 8b 00             	mov    (%rax),%rax
  8004be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c2:	e9 a3 00 00 00       	jmpq   80056a <getuint+0x10a>
	else if (lflag)
  8004c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004cb:	74 4f                	je     80051c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	8b 00                	mov    (%rax),%eax
  8004d3:	83 f8 30             	cmp    $0x30,%eax
  8004d6:	73 24                	jae    8004fc <getuint+0x9c>
  8004d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e4:	8b 00                	mov    (%rax),%eax
  8004e6:	89 c0                	mov    %eax,%eax
  8004e8:	48 01 d0             	add    %rdx,%rax
  8004eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ef:	8b 12                	mov    (%rdx),%edx
  8004f1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f8:	89 0a                	mov    %ecx,(%rdx)
  8004fa:	eb 17                	jmp    800513 <getuint+0xb3>
  8004fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800500:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800504:	48 89 d0             	mov    %rdx,%rax
  800507:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800513:	48 8b 00             	mov    (%rax),%rax
  800516:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80051a:	eb 4e                	jmp    80056a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80051c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800520:	8b 00                	mov    (%rax),%eax
  800522:	83 f8 30             	cmp    $0x30,%eax
  800525:	73 24                	jae    80054b <getuint+0xeb>
  800527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80052f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	89 c0                	mov    %eax,%eax
  800537:	48 01 d0             	add    %rdx,%rax
  80053a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053e:	8b 12                	mov    (%rdx),%edx
  800540:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800543:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800547:	89 0a                	mov    %ecx,(%rdx)
  800549:	eb 17                	jmp    800562 <getuint+0x102>
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800553:	48 89 d0             	mov    %rdx,%rax
  800556:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800562:	8b 00                	mov    (%rax),%eax
  800564:	89 c0                	mov    %eax,%eax
  800566:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80056a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80056e:	c9                   	leaveq 
  80056f:	c3                   	retq   

0000000000800570 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800570:	55                   	push   %rbp
  800571:	48 89 e5             	mov    %rsp,%rbp
  800574:	48 83 ec 20          	sub    $0x20,%rsp
  800578:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80057c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80057f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800583:	7e 52                	jle    8005d7 <getint+0x67>
		x=va_arg(*ap, long long);
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	8b 00                	mov    (%rax),%eax
  80058b:	83 f8 30             	cmp    $0x30,%eax
  80058e:	73 24                	jae    8005b4 <getint+0x44>
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	8b 00                	mov    (%rax),%eax
  80059e:	89 c0                	mov    %eax,%eax
  8005a0:	48 01 d0             	add    %rdx,%rax
  8005a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a7:	8b 12                	mov    (%rdx),%edx
  8005a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	89 0a                	mov    %ecx,(%rdx)
  8005b2:	eb 17                	jmp    8005cb <getint+0x5b>
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bc:	48 89 d0             	mov    %rdx,%rax
  8005bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cb:	48 8b 00             	mov    (%rax),%rax
  8005ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d2:	e9 a3 00 00 00       	jmpq   80067a <getint+0x10a>
	else if (lflag)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005db:	74 4f                	je     80062c <getint+0xbc>
		x=va_arg(*ap, long);
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	8b 00                	mov    (%rax),%eax
  8005e3:	83 f8 30             	cmp    $0x30,%eax
  8005e6:	73 24                	jae    80060c <getint+0x9c>
  8005e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f4:	8b 00                	mov    (%rax),%eax
  8005f6:	89 c0                	mov    %eax,%eax
  8005f8:	48 01 d0             	add    %rdx,%rax
  8005fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ff:	8b 12                	mov    (%rdx),%edx
  800601:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800604:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800608:	89 0a                	mov    %ecx,(%rdx)
  80060a:	eb 17                	jmp    800623 <getint+0xb3>
  80060c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800610:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800614:	48 89 d0             	mov    %rdx,%rax
  800617:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800623:	48 8b 00             	mov    (%rax),%rax
  800626:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80062a:	eb 4e                	jmp    80067a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80062c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800630:	8b 00                	mov    (%rax),%eax
  800632:	83 f8 30             	cmp    $0x30,%eax
  800635:	73 24                	jae    80065b <getint+0xeb>
  800637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80063f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800643:	8b 00                	mov    (%rax),%eax
  800645:	89 c0                	mov    %eax,%eax
  800647:	48 01 d0             	add    %rdx,%rax
  80064a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064e:	8b 12                	mov    (%rdx),%edx
  800650:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800653:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800657:	89 0a                	mov    %ecx,(%rdx)
  800659:	eb 17                	jmp    800672 <getint+0x102>
  80065b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800663:	48 89 d0             	mov    %rdx,%rax
  800666:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800672:	8b 00                	mov    (%rax),%eax
  800674:	48 98                	cltq   
  800676:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80067a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80067e:	c9                   	leaveq 
  80067f:	c3                   	retq   

0000000000800680 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800680:	55                   	push   %rbp
  800681:	48 89 e5             	mov    %rsp,%rbp
  800684:	41 54                	push   %r12
  800686:	53                   	push   %rbx
  800687:	48 83 ec 60          	sub    $0x60,%rsp
  80068b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80068f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800693:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800697:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80069b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80069f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006a3:	48 8b 0a             	mov    (%rdx),%rcx
  8006a6:	48 89 08             	mov    %rcx,(%rax)
  8006a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b9:	eb 17                	jmp    8006d2 <vprintfmt+0x52>
			if (ch == '\0')
  8006bb:	85 db                	test   %ebx,%ebx
  8006bd:	0f 84 d7 04 00 00    	je     800b9a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8006c3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8006c7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8006cb:	48 89 c6             	mov    %rax,%rsi
  8006ce:	89 df                	mov    %ebx,%edi
  8006d0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006d6:	0f b6 00             	movzbl (%rax),%eax
  8006d9:	0f b6 d8             	movzbl %al,%ebx
  8006dc:	83 fb 25             	cmp    $0x25,%ebx
  8006df:	0f 95 c0             	setne  %al
  8006e2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8006e7:	84 c0                	test   %al,%al
  8006e9:	75 d0                	jne    8006bb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006eb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006ef:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800704:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80070b:	eb 04                	jmp    800711 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80070d:	90                   	nop
  80070e:	eb 01                	jmp    800711 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800710:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800711:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800715:	0f b6 00             	movzbl (%rax),%eax
  800718:	0f b6 d8             	movzbl %al,%ebx
  80071b:	89 d8                	mov    %ebx,%eax
  80071d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800722:	83 e8 23             	sub    $0x23,%eax
  800725:	83 f8 55             	cmp    $0x55,%eax
  800728:	0f 87 38 04 00 00    	ja     800b66 <vprintfmt+0x4e6>
  80072e:	89 c0                	mov    %eax,%eax
  800730:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800737:	00 
  800738:	48 b8 d0 3f 80 00 00 	movabs $0x803fd0,%rax
  80073f:	00 00 00 
  800742:	48 01 d0             	add    %rdx,%rax
  800745:	48 8b 00             	mov    (%rax),%rax
  800748:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80074a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80074e:	eb c1                	jmp    800711 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800750:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800754:	eb bb                	jmp    800711 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800756:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80075d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800760:	89 d0                	mov    %edx,%eax
  800762:	c1 e0 02             	shl    $0x2,%eax
  800765:	01 d0                	add    %edx,%eax
  800767:	01 c0                	add    %eax,%eax
  800769:	01 d8                	add    %ebx,%eax
  80076b:	83 e8 30             	sub    $0x30,%eax
  80076e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800771:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800775:	0f b6 00             	movzbl (%rax),%eax
  800778:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80077b:	83 fb 2f             	cmp    $0x2f,%ebx
  80077e:	7e 63                	jle    8007e3 <vprintfmt+0x163>
  800780:	83 fb 39             	cmp    $0x39,%ebx
  800783:	7f 5e                	jg     8007e3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800785:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80078a:	eb d1                	jmp    80075d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80078c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078f:	83 f8 30             	cmp    $0x30,%eax
  800792:	73 17                	jae    8007ab <vprintfmt+0x12b>
  800794:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800798:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079b:	89 c0                	mov    %eax,%eax
  80079d:	48 01 d0             	add    %rdx,%rax
  8007a0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a3:	83 c2 08             	add    $0x8,%edx
  8007a6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007a9:	eb 0f                	jmp    8007ba <vprintfmt+0x13a>
  8007ab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007af:	48 89 d0             	mov    %rdx,%rax
  8007b2:	48 83 c2 08          	add    $0x8,%rdx
  8007b6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007ba:	8b 00                	mov    (%rax),%eax
  8007bc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007bf:	eb 23                	jmp    8007e4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8007c1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007c5:	0f 89 42 ff ff ff    	jns    80070d <vprintfmt+0x8d>
				width = 0;
  8007cb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007d2:	e9 36 ff ff ff       	jmpq   80070d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8007d7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007de:	e9 2e ff ff ff       	jmpq   800711 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e8:	0f 89 22 ff ff ff    	jns    800710 <vprintfmt+0x90>
				width = precision, precision = -1;
  8007ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007f1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007fb:	e9 10 ff ff ff       	jmpq   800710 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800800:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800804:	e9 08 ff ff ff       	jmpq   800711 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800809:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80080c:	83 f8 30             	cmp    $0x30,%eax
  80080f:	73 17                	jae    800828 <vprintfmt+0x1a8>
  800811:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800815:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800818:	89 c0                	mov    %eax,%eax
  80081a:	48 01 d0             	add    %rdx,%rax
  80081d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800820:	83 c2 08             	add    $0x8,%edx
  800823:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800826:	eb 0f                	jmp    800837 <vprintfmt+0x1b7>
  800828:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80082c:	48 89 d0             	mov    %rdx,%rax
  80082f:	48 83 c2 08          	add    $0x8,%rdx
  800833:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800837:	8b 00                	mov    (%rax),%eax
  800839:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80083d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800841:	48 89 d6             	mov    %rdx,%rsi
  800844:	89 c7                	mov    %eax,%edi
  800846:	ff d1                	callq  *%rcx
			break;
  800848:	e9 47 03 00 00       	jmpq   800b94 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80084d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800850:	83 f8 30             	cmp    $0x30,%eax
  800853:	73 17                	jae    80086c <vprintfmt+0x1ec>
  800855:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800859:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085c:	89 c0                	mov    %eax,%eax
  80085e:	48 01 d0             	add    %rdx,%rax
  800861:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800864:	83 c2 08             	add    $0x8,%edx
  800867:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80086a:	eb 0f                	jmp    80087b <vprintfmt+0x1fb>
  80086c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800870:	48 89 d0             	mov    %rdx,%rax
  800873:	48 83 c2 08          	add    $0x8,%rdx
  800877:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80087b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80087d:	85 db                	test   %ebx,%ebx
  80087f:	79 02                	jns    800883 <vprintfmt+0x203>
				err = -err;
  800881:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800883:	83 fb 10             	cmp    $0x10,%ebx
  800886:	7f 16                	jg     80089e <vprintfmt+0x21e>
  800888:	48 b8 20 3f 80 00 00 	movabs $0x803f20,%rax
  80088f:	00 00 00 
  800892:	48 63 d3             	movslq %ebx,%rdx
  800895:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800899:	4d 85 e4             	test   %r12,%r12
  80089c:	75 2e                	jne    8008cc <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80089e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008a2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008a6:	89 d9                	mov    %ebx,%ecx
  8008a8:	48 ba b9 3f 80 00 00 	movabs $0x803fb9,%rdx
  8008af:	00 00 00 
  8008b2:	48 89 c7             	mov    %rax,%rdi
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008c1:	00 00 00 
  8008c4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008c7:	e9 c8 02 00 00       	jmpq   800b94 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008d0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008d4:	4c 89 e1             	mov    %r12,%rcx
  8008d7:	48 ba c2 3f 80 00 00 	movabs $0x803fc2,%rdx
  8008de:	00 00 00 
  8008e1:	48 89 c7             	mov    %rax,%rdi
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e9:	49 b8 a4 0b 80 00 00 	movabs $0x800ba4,%r8
  8008f0:	00 00 00 
  8008f3:	41 ff d0             	callq  *%r8
			break;
  8008f6:	e9 99 02 00 00       	jmpq   800b94 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008fe:	83 f8 30             	cmp    $0x30,%eax
  800901:	73 17                	jae    80091a <vprintfmt+0x29a>
  800903:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800907:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090a:	89 c0                	mov    %eax,%eax
  80090c:	48 01 d0             	add    %rdx,%rax
  80090f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800912:	83 c2 08             	add    $0x8,%edx
  800915:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800918:	eb 0f                	jmp    800929 <vprintfmt+0x2a9>
  80091a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091e:	48 89 d0             	mov    %rdx,%rax
  800921:	48 83 c2 08          	add    $0x8,%rdx
  800925:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800929:	4c 8b 20             	mov    (%rax),%r12
  80092c:	4d 85 e4             	test   %r12,%r12
  80092f:	75 0a                	jne    80093b <vprintfmt+0x2bb>
				p = "(null)";
  800931:	49 bc c5 3f 80 00 00 	movabs $0x803fc5,%r12
  800938:	00 00 00 
			if (width > 0 && padc != '-')
  80093b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80093f:	7e 7a                	jle    8009bb <vprintfmt+0x33b>
  800941:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800945:	74 74                	je     8009bb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800947:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80094a:	48 98                	cltq   
  80094c:	48 89 c6             	mov    %rax,%rsi
  80094f:	4c 89 e7             	mov    %r12,%rdi
  800952:	48 b8 4e 0e 80 00 00 	movabs $0x800e4e,%rax
  800959:	00 00 00 
  80095c:	ff d0                	callq  *%rax
  80095e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800961:	eb 17                	jmp    80097a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800963:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800967:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80096b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80096f:	48 89 d6             	mov    %rdx,%rsi
  800972:	89 c7                	mov    %eax,%edi
  800974:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800976:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80097a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097e:	7f e3                	jg     800963 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800980:	eb 39                	jmp    8009bb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800982:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800986:	74 1e                	je     8009a6 <vprintfmt+0x326>
  800988:	83 fb 1f             	cmp    $0x1f,%ebx
  80098b:	7e 05                	jle    800992 <vprintfmt+0x312>
  80098d:	83 fb 7e             	cmp    $0x7e,%ebx
  800990:	7e 14                	jle    8009a6 <vprintfmt+0x326>
					putch('?', putdat);
  800992:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800996:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80099a:	48 89 c6             	mov    %rax,%rsi
  80099d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009a2:	ff d2                	callq  *%rdx
  8009a4:	eb 0f                	jmp    8009b5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  8009a6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009aa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009ae:	48 89 c6             	mov    %rax,%rsi
  8009b1:	89 df                	mov    %ebx,%edi
  8009b3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009b9:	eb 01                	jmp    8009bc <vprintfmt+0x33c>
  8009bb:	90                   	nop
  8009bc:	41 0f b6 04 24       	movzbl (%r12),%eax
  8009c1:	0f be d8             	movsbl %al,%ebx
  8009c4:	85 db                	test   %ebx,%ebx
  8009c6:	0f 95 c0             	setne  %al
  8009c9:	49 83 c4 01          	add    $0x1,%r12
  8009cd:	84 c0                	test   %al,%al
  8009cf:	74 28                	je     8009f9 <vprintfmt+0x379>
  8009d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009d5:	78 ab                	js     800982 <vprintfmt+0x302>
  8009d7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009db:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009df:	79 a1                	jns    800982 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e1:	eb 16                	jmp    8009f9 <vprintfmt+0x379>
				putch(' ', putdat);
  8009e3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009e7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009eb:	48 89 c6             	mov    %rax,%rsi
  8009ee:	bf 20 00 00 00       	mov    $0x20,%edi
  8009f3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fd:	7f e4                	jg     8009e3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  8009ff:	e9 90 01 00 00       	jmpq   800b94 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a08:	be 03 00 00 00       	mov    $0x3,%esi
  800a0d:	48 89 c7             	mov    %rax,%rdi
  800a10:	48 b8 70 05 80 00 00 	movabs $0x800570,%rax
  800a17:	00 00 00 
  800a1a:	ff d0                	callq  *%rax
  800a1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	48 85 c0             	test   %rax,%rax
  800a27:	79 1d                	jns    800a46 <vprintfmt+0x3c6>
				putch('-', putdat);
  800a29:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a2d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a31:	48 89 c6             	mov    %rax,%rsi
  800a34:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a39:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800a3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3f:	48 f7 d8             	neg    %rax
  800a42:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a46:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a4d:	e9 d5 00 00 00       	jmpq   800b27 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a52:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a56:	be 03 00 00 00       	mov    $0x3,%esi
  800a5b:	48 89 c7             	mov    %rax,%rdi
  800a5e:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800a65:	00 00 00 
  800a68:	ff d0                	callq  *%rax
  800a6a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a6e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a75:	e9 ad 00 00 00       	jmpq   800b27 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800a7a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a7e:	be 03 00 00 00       	mov    $0x3,%esi
  800a83:	48 89 c7             	mov    %rax,%rdi
  800a86:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800a8d:	00 00 00 
  800a90:	ff d0                	callq  *%rax
  800a92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800a96:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a9d:	e9 85 00 00 00       	jmpq   800b27 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800aa2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800aa6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aaa:	48 89 c6             	mov    %rax,%rsi
  800aad:	bf 30 00 00 00       	mov    $0x30,%edi
  800ab2:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800ab4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800abc:	48 89 c6             	mov    %rax,%rsi
  800abf:	bf 78 00 00 00       	mov    $0x78,%edi
  800ac4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ac6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 17                	jae    800ae5 <vprintfmt+0x465>
  800ace:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad5:	89 c0                	mov    %eax,%eax
  800ad7:	48 01 d0             	add    %rdx,%rax
  800ada:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800add:	83 c2 08             	add    $0x8,%edx
  800ae0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae3:	eb 0f                	jmp    800af4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800ae5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae9:	48 89 d0             	mov    %rdx,%rax
  800aec:	48 83 c2 08          	add    $0x8,%rdx
  800af0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800afb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b02:	eb 23                	jmp    800b27 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b08:	be 03 00 00 00       	mov    $0x3,%esi
  800b0d:	48 89 c7             	mov    %rax,%rdi
  800b10:	48 b8 60 04 80 00 00 	movabs $0x800460,%rax
  800b17:	00 00 00 
  800b1a:	ff d0                	callq  *%rax
  800b1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b20:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b27:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b2c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b2f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b36:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3e:	45 89 c1             	mov    %r8d,%r9d
  800b41:	41 89 f8             	mov    %edi,%r8d
  800b44:	48 89 c7             	mov    %rax,%rdi
  800b47:	48 b8 a8 03 80 00 00 	movabs $0x8003a8,%rax
  800b4e:	00 00 00 
  800b51:	ff d0                	callq  *%rax
			break;
  800b53:	eb 3f                	jmp    800b94 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b55:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b59:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b5d:	48 89 c6             	mov    %rax,%rsi
  800b60:	89 df                	mov    %ebx,%edi
  800b62:	ff d2                	callq  *%rdx
			break;
  800b64:	eb 2e                	jmp    800b94 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b66:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b6a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b6e:	48 89 c6             	mov    %rax,%rsi
  800b71:	bf 25 00 00 00       	mov    $0x25,%edi
  800b76:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b78:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b7d:	eb 05                	jmp    800b84 <vprintfmt+0x504>
  800b7f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b84:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b88:	48 83 e8 01          	sub    $0x1,%rax
  800b8c:	0f b6 00             	movzbl (%rax),%eax
  800b8f:	3c 25                	cmp    $0x25,%al
  800b91:	75 ec                	jne    800b7f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800b93:	90                   	nop
		}
	}
  800b94:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b95:	e9 38 fb ff ff       	jmpq   8006d2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800b9a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800b9b:	48 83 c4 60          	add    $0x60,%rsp
  800b9f:	5b                   	pop    %rbx
  800ba0:	41 5c                	pop    %r12
  800ba2:	5d                   	pop    %rbp
  800ba3:	c3                   	retq   

0000000000800ba4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba4:	55                   	push   %rbp
  800ba5:	48 89 e5             	mov    %rsp,%rbp
  800ba8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800baf:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bb6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bbd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bc4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bcb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bd2:	84 c0                	test   %al,%al
  800bd4:	74 20                	je     800bf6 <printfmt+0x52>
  800bd6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bde:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800be2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800be6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bf2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bf6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bfd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c04:	00 00 00 
  800c07:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c0e:	00 00 00 
  800c11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c15:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c23:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c2a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c31:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c38:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c3f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c46:	48 89 c7             	mov    %rax,%rdi
  800c49:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c55:	c9                   	leaveq 
  800c56:	c3                   	retq   

0000000000800c57 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c57:	55                   	push   %rbp
  800c58:	48 89 e5             	mov    %rsp,%rbp
  800c5b:	48 83 ec 10          	sub    $0x10,%rsp
  800c5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6a:	8b 40 10             	mov    0x10(%rax),%eax
  800c6d:	8d 50 01             	lea    0x1(%rax),%edx
  800c70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c74:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7b:	48 8b 10             	mov    (%rax),%rdx
  800c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c82:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c86:	48 39 c2             	cmp    %rax,%rdx
  800c89:	73 17                	jae    800ca2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8f:	48 8b 00             	mov    (%rax),%rax
  800c92:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c95:	88 10                	mov    %dl,(%rax)
  800c97:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9f:	48 89 10             	mov    %rdx,(%rax)
}
  800ca2:	c9                   	leaveq 
  800ca3:	c3                   	retq   

0000000000800ca4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca4:	55                   	push   %rbp
  800ca5:	48 89 e5             	mov    %rsp,%rbp
  800ca8:	48 83 ec 50          	sub    $0x50,%rsp
  800cac:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cb0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cb3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cb7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cbb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cbf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cc3:	48 8b 0a             	mov    (%rdx),%rcx
  800cc6:	48 89 08             	mov    %rcx,(%rax)
  800cc9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ccd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cd1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cd5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cd9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cdd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ce1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ce4:	48 98                	cltq   
  800ce6:	48 83 e8 01          	sub    $0x1,%rax
  800cea:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800cee:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cf9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cfe:	74 06                	je     800d06 <vsnprintf+0x62>
  800d00:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d04:	7f 07                	jg     800d0d <vsnprintf+0x69>
		return -E_INVAL;
  800d06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d0b:	eb 2f                	jmp    800d3c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d0d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d11:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d15:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d19:	48 89 c6             	mov    %rax,%rsi
  800d1c:	48 bf 57 0c 80 00 00 	movabs $0x800c57,%rdi
  800d23:	00 00 00 
  800d26:	48 b8 80 06 80 00 00 	movabs $0x800680,%rax
  800d2d:	00 00 00 
  800d30:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d36:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d39:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d3c:	c9                   	leaveq 
  800d3d:	c3                   	retq   

0000000000800d3e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d3e:	55                   	push   %rbp
  800d3f:	48 89 e5             	mov    %rsp,%rbp
  800d42:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d49:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d50:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d6b:	84 c0                	test   %al,%al
  800d6d:	74 20                	je     800d8f <snprintf+0x51>
  800d6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d8f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d96:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d9d:	00 00 00 
  800da0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800da7:	00 00 00 
  800daa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800db5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dbc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dc3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dd1:	48 8b 0a             	mov    (%rdx),%rcx
  800dd4:	48 89 08             	mov    %rcx,(%rax)
  800dd7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ddb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ddf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800de7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dee:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800df5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dfb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e02:	48 89 c7             	mov    %rax,%rdi
  800e05:	48 b8 a4 0c 80 00 00 	movabs $0x800ca4,%rax
  800e0c:	00 00 00 
  800e0f:	ff d0                	callq  *%rax
  800e11:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e17:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e1d:	c9                   	leaveq 
  800e1e:	c3                   	retq   
	...

0000000000800e20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e20:	55                   	push   %rbp
  800e21:	48 89 e5             	mov    %rsp,%rbp
  800e24:	48 83 ec 18          	sub    $0x18,%rsp
  800e28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e33:	eb 09                	jmp    800e3e <strlen+0x1e>
		n++;
  800e35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e39:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e42:	0f b6 00             	movzbl (%rax),%eax
  800e45:	84 c0                	test   %al,%al
  800e47:	75 ec                	jne    800e35 <strlen+0x15>
		n++;
	return n;
  800e49:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e4c:	c9                   	leaveq 
  800e4d:	c3                   	retq   

0000000000800e4e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
  800e52:	48 83 ec 20          	sub    $0x20,%rsp
  800e56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e65:	eb 0e                	jmp    800e75 <strnlen+0x27>
		n++;
  800e67:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e70:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e75:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e7a:	74 0b                	je     800e87 <strnlen+0x39>
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	0f b6 00             	movzbl (%rax),%eax
  800e83:	84 c0                	test   %al,%al
  800e85:	75 e0                	jne    800e67 <strnlen+0x19>
		n++;
	return n;
  800e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8a:	c9                   	leaveq 
  800e8b:	c3                   	retq   

0000000000800e8c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8c:	55                   	push   %rbp
  800e8d:	48 89 e5             	mov    %rsp,%rbp
  800e90:	48 83 ec 20          	sub    $0x20,%rsp
  800e94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ea4:	90                   	nop
  800ea5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea9:	0f b6 10             	movzbl (%rax),%edx
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	88 10                	mov    %dl,(%rax)
  800eb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb6:	0f b6 00             	movzbl (%rax),%eax
  800eb9:	84 c0                	test   %al,%al
  800ebb:	0f 95 c0             	setne  %al
  800ebe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ec3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 d9                	jne    800ea5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ecc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ed0:	c9                   	leaveq 
  800ed1:	c3                   	retq   

0000000000800ed2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ed2:	55                   	push   %rbp
  800ed3:	48 89 e5             	mov    %rsp,%rbp
  800ed6:	48 83 ec 20          	sub    $0x20,%rsp
  800eda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ede:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	48 89 c7             	mov    %rax,%rdi
  800ee9:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  800ef0:	00 00 00 
  800ef3:	ff d0                	callq  *%rax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800efb:	48 98                	cltq   
  800efd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800f01:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f05:	48 89 d6             	mov    %rdx,%rsi
  800f08:	48 89 c7             	mov    %rax,%rdi
  800f0b:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  800f12:	00 00 00 
  800f15:	ff d0                	callq  *%rax
	return dst;
  800f17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f1b:	c9                   	leaveq 
  800f1c:	c3                   	retq   

0000000000800f1d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f1d:	55                   	push   %rbp
  800f1e:	48 89 e5             	mov    %rsp,%rbp
  800f21:	48 83 ec 28          	sub    $0x28,%rsp
  800f25:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f29:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f2d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f39:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f40:	00 
  800f41:	eb 27                	jmp    800f6a <strncpy+0x4d>
		*dst++ = *src;
  800f43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f47:	0f b6 10             	movzbl (%rax),%edx
  800f4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4e:	88 10                	mov    %dl,(%rax)
  800f50:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f59:	0f b6 00             	movzbl (%rax),%eax
  800f5c:	84 c0                	test   %al,%al
  800f5e:	74 05                	je     800f65 <strncpy+0x48>
			src++;
  800f60:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f65:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f6e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f72:	72 cf                	jb     800f43 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f78:	c9                   	leaveq 
  800f79:	c3                   	retq   

0000000000800f7a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f7a:	55                   	push   %rbp
  800f7b:	48 89 e5             	mov    %rsp,%rbp
  800f7e:	48 83 ec 28          	sub    $0x28,%rsp
  800f82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f86:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f96:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f9b:	74 37                	je     800fd4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800f9d:	eb 17                	jmp    800fb6 <strlcpy+0x3c>
			*dst++ = *src++;
  800f9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa3:	0f b6 10             	movzbl (%rax),%edx
  800fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faa:	88 10                	mov    %dl,(%rax)
  800fac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fb1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fb6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fbb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fc0:	74 0b                	je     800fcd <strlcpy+0x53>
  800fc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc6:	0f b6 00             	movzbl (%rax),%eax
  800fc9:	84 c0                	test   %al,%al
  800fcb:	75 d2                	jne    800f9f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fd4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fdc:	48 89 d1             	mov    %rdx,%rcx
  800fdf:	48 29 c1             	sub    %rax,%rcx
  800fe2:	48 89 c8             	mov    %rcx,%rax
}
  800fe5:	c9                   	leaveq 
  800fe6:	c3                   	retq   

0000000000800fe7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fe7:	55                   	push   %rbp
  800fe8:	48 89 e5             	mov    %rsp,%rbp
  800feb:	48 83 ec 10          	sub    $0x10,%rsp
  800fef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800ff3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800ff7:	eb 0a                	jmp    801003 <strcmp+0x1c>
		p++, q++;
  800ff9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ffe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801007:	0f b6 00             	movzbl (%rax),%eax
  80100a:	84 c0                	test   %al,%al
  80100c:	74 12                	je     801020 <strcmp+0x39>
  80100e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801012:	0f b6 10             	movzbl (%rax),%edx
  801015:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801019:	0f b6 00             	movzbl (%rax),%eax
  80101c:	38 c2                	cmp    %al,%dl
  80101e:	74 d9                	je     800ff9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801020:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801024:	0f b6 00             	movzbl (%rax),%eax
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	0f b6 c0             	movzbl %al,%eax
  801034:	89 d1                	mov    %edx,%ecx
  801036:	29 c1                	sub    %eax,%ecx
  801038:	89 c8                	mov    %ecx,%eax
}
  80103a:	c9                   	leaveq 
  80103b:	c3                   	retq   

000000000080103c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80103c:	55                   	push   %rbp
  80103d:	48 89 e5             	mov    %rsp,%rbp
  801040:	48 83 ec 18          	sub    $0x18,%rsp
  801044:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801048:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80104c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801050:	eb 0f                	jmp    801061 <strncmp+0x25>
		n--, p++, q++;
  801052:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801057:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801061:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801066:	74 1d                	je     801085 <strncmp+0x49>
  801068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106c:	0f b6 00             	movzbl (%rax),%eax
  80106f:	84 c0                	test   %al,%al
  801071:	74 12                	je     801085 <strncmp+0x49>
  801073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801077:	0f b6 10             	movzbl (%rax),%edx
  80107a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	38 c2                	cmp    %al,%dl
  801083:	74 cd                	je     801052 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801085:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108a:	75 07                	jne    801093 <strncmp+0x57>
		return 0;
  80108c:	b8 00 00 00 00       	mov    $0x0,%eax
  801091:	eb 1a                	jmp    8010ad <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	0f b6 00             	movzbl (%rax),%eax
  80109a:	0f b6 d0             	movzbl %al,%edx
  80109d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a1:	0f b6 00             	movzbl (%rax),%eax
  8010a4:	0f b6 c0             	movzbl %al,%eax
  8010a7:	89 d1                	mov    %edx,%ecx
  8010a9:	29 c1                	sub    %eax,%ecx
  8010ab:	89 c8                	mov    %ecx,%eax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 10          	sub    $0x10,%rsp
  8010b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010bb:	89 f0                	mov    %esi,%eax
  8010bd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010c0:	eb 17                	jmp    8010d9 <strchr+0x2a>
		if (*s == c)
  8010c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c6:	0f b6 00             	movzbl (%rax),%eax
  8010c9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010cc:	75 06                	jne    8010d4 <strchr+0x25>
			return (char *) s;
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	eb 15                	jmp    8010e9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	0f b6 00             	movzbl (%rax),%eax
  8010e0:	84 c0                	test   %al,%al
  8010e2:	75 de                	jne    8010c2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e9:	c9                   	leaveq 
  8010ea:	c3                   	retq   

00000000008010eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010eb:	55                   	push   %rbp
  8010ec:	48 89 e5             	mov    %rsp,%rbp
  8010ef:	48 83 ec 10          	sub    $0x10,%rsp
  8010f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f7:	89 f0                	mov    %esi,%eax
  8010f9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010fc:	eb 11                	jmp    80110f <strfind+0x24>
		if (*s == c)
  8010fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801102:	0f b6 00             	movzbl (%rax),%eax
  801105:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801108:	74 12                	je     80111c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80110a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80110f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	84 c0                	test   %al,%al
  801118:	75 e4                	jne    8010fe <strfind+0x13>
  80111a:	eb 01                	jmp    80111d <strfind+0x32>
		if (*s == c)
			break;
  80111c:	90                   	nop
	return (char *) s;
  80111d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801121:	c9                   	leaveq 
  801122:	c3                   	retq   

0000000000801123 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801123:	55                   	push   %rbp
  801124:	48 89 e5             	mov    %rsp,%rbp
  801127:	48 83 ec 18          	sub    $0x18,%rsp
  80112b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80112f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801132:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801136:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80113b:	75 06                	jne    801143 <memset+0x20>
		return v;
  80113d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801141:	eb 69                	jmp    8011ac <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801147:	83 e0 03             	and    $0x3,%eax
  80114a:	48 85 c0             	test   %rax,%rax
  80114d:	75 48                	jne    801197 <memset+0x74>
  80114f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801153:	83 e0 03             	and    $0x3,%eax
  801156:	48 85 c0             	test   %rax,%rax
  801159:	75 3c                	jne    801197 <memset+0x74>
		c &= 0xFF;
  80115b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801162:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801165:	89 c2                	mov    %eax,%edx
  801167:	c1 e2 18             	shl    $0x18,%edx
  80116a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80116d:	c1 e0 10             	shl    $0x10,%eax
  801170:	09 c2                	or     %eax,%edx
  801172:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801175:	c1 e0 08             	shl    $0x8,%eax
  801178:	09 d0                	or     %edx,%eax
  80117a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80117d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801181:	48 89 c1             	mov    %rax,%rcx
  801184:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801188:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80118c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118f:	48 89 d7             	mov    %rdx,%rdi
  801192:	fc                   	cld    
  801193:	f3 ab                	rep stos %eax,%es:(%rdi)
  801195:	eb 11                	jmp    8011a8 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801197:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80119b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80119e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011a2:	48 89 d7             	mov    %rdx,%rdi
  8011a5:	fc                   	cld    
  8011a6:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ac:	c9                   	leaveq 
  8011ad:	c3                   	retq   

00000000008011ae <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011ae:	55                   	push   %rbp
  8011af:	48 89 e5             	mov    %rsp,%rbp
  8011b2:	48 83 ec 28          	sub    $0x28,%rsp
  8011b6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011da:	0f 83 88 00 00 00    	jae    801268 <memmove+0xba>
  8011e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011e4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e8:	48 01 d0             	add    %rdx,%rax
  8011eb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011ef:	76 77                	jbe    801268 <memmove+0xba>
		s += n;
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	83 e0 03             	and    $0x3,%eax
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	75 3b                	jne    801248 <memmove+0x9a>
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	83 e0 03             	and    $0x3,%eax
  801214:	48 85 c0             	test   %rax,%rax
  801217:	75 2f                	jne    801248 <memmove+0x9a>
  801219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121d:	83 e0 03             	and    $0x3,%eax
  801220:	48 85 c0             	test   %rax,%rax
  801223:	75 23                	jne    801248 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801229:	48 83 e8 04          	sub    $0x4,%rax
  80122d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801231:	48 83 ea 04          	sub    $0x4,%rdx
  801235:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801239:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80123d:	48 89 c7             	mov    %rax,%rdi
  801240:	48 89 d6             	mov    %rdx,%rsi
  801243:	fd                   	std    
  801244:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801246:	eb 1d                	jmp    801265 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801250:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801254:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801258:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125c:	48 89 d7             	mov    %rdx,%rdi
  80125f:	48 89 c1             	mov    %rax,%rcx
  801262:	fd                   	std    
  801263:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801265:	fc                   	cld    
  801266:	eb 57                	jmp    8012bf <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126c:	83 e0 03             	and    $0x3,%eax
  80126f:	48 85 c0             	test   %rax,%rax
  801272:	75 36                	jne    8012aa <memmove+0xfc>
  801274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801278:	83 e0 03             	and    $0x3,%eax
  80127b:	48 85 c0             	test   %rax,%rax
  80127e:	75 2a                	jne    8012aa <memmove+0xfc>
  801280:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801284:	83 e0 03             	and    $0x3,%eax
  801287:	48 85 c0             	test   %rax,%rax
  80128a:	75 1e                	jne    8012aa <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80128c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801290:	48 89 c1             	mov    %rax,%rcx
  801293:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80129f:	48 89 c7             	mov    %rax,%rdi
  8012a2:	48 89 d6             	mov    %rdx,%rsi
  8012a5:	fc                   	cld    
  8012a6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012a8:	eb 15                	jmp    8012bf <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012b6:	48 89 c7             	mov    %rax,%rdi
  8012b9:	48 89 d6             	mov    %rdx,%rsi
  8012bc:	fc                   	cld    
  8012bd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012c3:	c9                   	leaveq 
  8012c4:	c3                   	retq   

00000000008012c5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	48 83 ec 18          	sub    $0x18,%rsp
  8012cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012dd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e5:	48 89 ce             	mov    %rcx,%rsi
  8012e8:	48 89 c7             	mov    %rax,%rdi
  8012eb:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  8012f2:	00 00 00 
  8012f5:	ff d0                	callq  *%rax
}
  8012f7:	c9                   	leaveq 
  8012f8:	c3                   	retq   

00000000008012f9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012f9:	55                   	push   %rbp
  8012fa:	48 89 e5             	mov    %rsp,%rbp
  8012fd:	48 83 ec 28          	sub    $0x28,%rsp
  801301:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801305:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801309:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80130d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801311:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801319:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80131d:	eb 38                	jmp    801357 <memcmp+0x5e>
		if (*s1 != *s2)
  80131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801323:	0f b6 10             	movzbl (%rax),%edx
  801326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132a:	0f b6 00             	movzbl (%rax),%eax
  80132d:	38 c2                	cmp    %al,%dl
  80132f:	74 1c                	je     80134d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801335:	0f b6 00             	movzbl (%rax),%eax
  801338:	0f b6 d0             	movzbl %al,%edx
  80133b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133f:	0f b6 00             	movzbl (%rax),%eax
  801342:	0f b6 c0             	movzbl %al,%eax
  801345:	89 d1                	mov    %edx,%ecx
  801347:	29 c1                	sub    %eax,%ecx
  801349:	89 c8                	mov    %ecx,%eax
  80134b:	eb 20                	jmp    80136d <memcmp+0x74>
		s1++, s2++;
  80134d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801352:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801357:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80135c:	0f 95 c0             	setne  %al
  80135f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801364:	84 c0                	test   %al,%al
  801366:	75 b7                	jne    80131f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801368:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 28          	sub    $0x28,%rsp
  801377:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80137b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80137e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801386:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80138a:	48 01 d0             	add    %rdx,%rax
  80138d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801391:	eb 13                	jmp    8013a6 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801393:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801397:	0f b6 10             	movzbl (%rax),%edx
  80139a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80139d:	38 c2                	cmp    %al,%dl
  80139f:	74 11                	je     8013b2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013ae:	72 e3                	jb     801393 <memfind+0x24>
  8013b0:	eb 01                	jmp    8013b3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013b2:	90                   	nop
	return (void *) s;
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013b7:	c9                   	leaveq 
  8013b8:	c3                   	retq   

00000000008013b9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b9:	55                   	push   %rbp
  8013ba:	48 89 e5             	mov    %rsp,%rbp
  8013bd:	48 83 ec 38          	sub    $0x38,%rsp
  8013c1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013c9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013d3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013da:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013db:	eb 05                	jmp    8013e2 <strtol+0x29>
		s++;
  8013dd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	3c 20                	cmp    $0x20,%al
  8013eb:	74 f0                	je     8013dd <strtol+0x24>
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	0f b6 00             	movzbl (%rax),%eax
  8013f4:	3c 09                	cmp    $0x9,%al
  8013f6:	74 e5                	je     8013dd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	0f b6 00             	movzbl (%rax),%eax
  8013ff:	3c 2b                	cmp    $0x2b,%al
  801401:	75 07                	jne    80140a <strtol+0x51>
		s++;
  801403:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801408:	eb 17                	jmp    801421 <strtol+0x68>
	else if (*s == '-')
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	3c 2d                	cmp    $0x2d,%al
  801413:	75 0c                	jne    801421 <strtol+0x68>
		s++, neg = 1;
  801415:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80141a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801421:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801425:	74 06                	je     80142d <strtol+0x74>
  801427:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80142b:	75 28                	jne    801455 <strtol+0x9c>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	3c 30                	cmp    $0x30,%al
  801436:	75 1d                	jne    801455 <strtol+0x9c>
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	48 83 c0 01          	add    $0x1,%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3c 78                	cmp    $0x78,%al
  801445:	75 0e                	jne    801455 <strtol+0x9c>
		s += 2, base = 16;
  801447:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80144c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801453:	eb 2c                	jmp    801481 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801455:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801459:	75 19                	jne    801474 <strtol+0xbb>
  80145b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	3c 30                	cmp    $0x30,%al
  801464:	75 0e                	jne    801474 <strtol+0xbb>
		s++, base = 8;
  801466:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801472:	eb 0d                	jmp    801481 <strtol+0xc8>
	else if (base == 0)
  801474:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801478:	75 07                	jne    801481 <strtol+0xc8>
		base = 10;
  80147a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801485:	0f b6 00             	movzbl (%rax),%eax
  801488:	3c 2f                	cmp    $0x2f,%al
  80148a:	7e 1d                	jle    8014a9 <strtol+0xf0>
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 39                	cmp    $0x39,%al
  801495:	7f 12                	jg     8014a9 <strtol+0xf0>
			dig = *s - '0';
  801497:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	0f be c0             	movsbl %al,%eax
  8014a1:	83 e8 30             	sub    $0x30,%eax
  8014a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014a7:	eb 4e                	jmp    8014f7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	3c 60                	cmp    $0x60,%al
  8014b2:	7e 1d                	jle    8014d1 <strtol+0x118>
  8014b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	3c 7a                	cmp    $0x7a,%al
  8014bd:	7f 12                	jg     8014d1 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c3:	0f b6 00             	movzbl (%rax),%eax
  8014c6:	0f be c0             	movsbl %al,%eax
  8014c9:	83 e8 57             	sub    $0x57,%eax
  8014cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014cf:	eb 26                	jmp    8014f7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 47                	jle    801523 <strtol+0x16a>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	3c 5a                	cmp    $0x5a,%al
  8014e5:	7f 3c                	jg     801523 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	83 e8 37             	sub    $0x37,%eax
  8014f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014fa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014fd:	7d 23                	jge    801522 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8014ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801504:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801507:	48 98                	cltq   
  801509:	48 89 c2             	mov    %rax,%rdx
  80150c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801511:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801514:	48 98                	cltq   
  801516:	48 01 d0             	add    %rdx,%rax
  801519:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80151d:	e9 5f ff ff ff       	jmpq   801481 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801522:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801523:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801528:	74 0b                	je     801535 <strtol+0x17c>
		*endptr = (char *) s;
  80152a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80152e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801532:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801535:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801539:	74 09                	je     801544 <strtol+0x18b>
  80153b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153f:	48 f7 d8             	neg    %rax
  801542:	eb 04                	jmp    801548 <strtol+0x18f>
  801544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801548:	c9                   	leaveq 
  801549:	c3                   	retq   

000000000080154a <strstr>:

char * strstr(const char *in, const char *str)
{
  80154a:	55                   	push   %rbp
  80154b:	48 89 e5             	mov    %rsp,%rbp
  80154e:	48 83 ec 30          	sub    $0x30,%rsp
  801552:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801556:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80155a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80155e:	0f b6 00             	movzbl (%rax),%eax
  801561:	88 45 ff             	mov    %al,-0x1(%rbp)
  801564:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801569:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80156d:	75 06                	jne    801575 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	eb 68                	jmp    8015dd <strstr+0x93>

    len = strlen(str);
  801575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801579:	48 89 c7             	mov    %rax,%rdi
  80157c:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  801583:	00 00 00 
  801586:	ff d0                	callq  *%rax
  801588:	48 98                	cltq   
  80158a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80158e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	88 45 ef             	mov    %al,-0x11(%rbp)
  801598:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80159d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015a1:	75 07                	jne    8015aa <strstr+0x60>
                return (char *) 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a8:	eb 33                	jmp    8015dd <strstr+0x93>
        } while (sc != c);
  8015aa:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015ae:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015b1:	75 db                	jne    80158e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8015b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015b7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	48 89 ce             	mov    %rcx,%rsi
  8015c2:	48 89 c7             	mov    %rax,%rdi
  8015c5:	48 b8 3c 10 80 00 00 	movabs $0x80103c,%rax
  8015cc:	00 00 00 
  8015cf:	ff d0                	callq  *%rax
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	75 b9                	jne    80158e <strstr+0x44>

    return (char *) (in - 1);
  8015d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d9:	48 83 e8 01          	sub    $0x1,%rax
}
  8015dd:	c9                   	leaveq 
  8015de:	c3                   	retq   
	...

00000000008015e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015e0:	55                   	push   %rbp
  8015e1:	48 89 e5             	mov    %rsp,%rbp
  8015e4:	53                   	push   %rbx
  8015e5:	48 83 ec 58          	sub    $0x58,%rsp
  8015e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015ec:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015f3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015f7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015fb:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801602:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801605:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801609:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80160d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801611:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801615:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801619:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80161c:	4c 89 c3             	mov    %r8,%rbx
  80161f:	cd 30                	int    $0x30
  801621:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801625:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801629:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80162d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801631:	74 3e                	je     801671 <syscall+0x91>
  801633:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801638:	7e 37                	jle    801671 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80163a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801641:	49 89 d0             	mov    %rdx,%r8
  801644:	89 c1                	mov    %eax,%ecx
  801646:	48 ba 80 42 80 00 00 	movabs $0x804280,%rdx
  80164d:	00 00 00 
  801650:	be 23 00 00 00       	mov    $0x23,%esi
  801655:	48 bf 9d 42 80 00 00 	movabs $0x80429d,%rdi
  80165c:	00 00 00 
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
  801664:	49 b9 e4 39 80 00 00 	movabs $0x8039e4,%r9
  80166b:	00 00 00 
  80166e:	41 ff d1             	callq  *%r9

	return ret;
  801671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801675:	48 83 c4 58          	add    $0x58,%rsp
  801679:	5b                   	pop    %rbx
  80167a:	5d                   	pop    %rbp
  80167b:	c3                   	retq   

000000000080167c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80167c:	55                   	push   %rbp
  80167d:	48 89 e5             	mov    %rsp,%rbp
  801680:	48 83 ec 20          	sub    $0x20,%rsp
  801684:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801688:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80168c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801690:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801694:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80169b:	00 
  80169c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a8:	48 89 d1             	mov    %rdx,%rcx
  8016ab:	48 89 c2             	mov    %rax,%rdx
  8016ae:	be 00 00 00 00       	mov    $0x0,%esi
  8016b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b8:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8016bf:	00 00 00 
  8016c2:	ff d0                	callq  *%rax
}
  8016c4:	c9                   	leaveq 
  8016c5:	c3                   	retq   

00000000008016c6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c6:	55                   	push   %rbp
  8016c7:	48 89 e5             	mov    %rsp,%rbp
  8016ca:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d5:	00 
  8016d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	be 00 00 00 00       	mov    $0x0,%esi
  8016f1:	bf 01 00 00 00       	mov    $0x1,%edi
  8016f6:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8016fd:	00 00 00 
  801700:	ff d0                	callq  *%rax
}
  801702:	c9                   	leaveq 
  801703:	c3                   	retq   

0000000000801704 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801704:	55                   	push   %rbp
  801705:	48 89 e5             	mov    %rsp,%rbp
  801708:	48 83 ec 20          	sub    $0x20,%rsp
  80170c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80170f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801712:	48 98                	cltq   
  801714:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171b:	00 
  80171c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801722:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172d:	48 89 c2             	mov    %rax,%rdx
  801730:	be 01 00 00 00       	mov    $0x1,%esi
  801735:	bf 03 00 00 00       	mov    $0x3,%edi
  80173a:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801741:	00 00 00 
  801744:	ff d0                	callq  *%rax
}
  801746:	c9                   	leaveq 
  801747:	c3                   	retq   

0000000000801748 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801748:	55                   	push   %rbp
  801749:	48 89 e5             	mov    %rsp,%rbp
  80174c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801750:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801757:	00 
  801758:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801764:	b9 00 00 00 00       	mov    $0x0,%ecx
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	be 00 00 00 00       	mov    $0x0,%esi
  801773:	bf 02 00 00 00       	mov    $0x2,%edi
  801778:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  80177f:	00 00 00 
  801782:	ff d0                	callq  *%rax
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <sys_yield>:

void
sys_yield(void)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80178e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801795:	00 
  801796:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ac:	be 00 00 00 00       	mov    $0x0,%esi
  8017b1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017b6:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8017bd:	00 00 00 
  8017c0:	ff d0                	callq  *%rax
}
  8017c2:	c9                   	leaveq 
  8017c3:	c3                   	retq   

00000000008017c4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017c4:	55                   	push   %rbp
  8017c5:	48 89 e5             	mov    %rsp,%rbp
  8017c8:	48 83 ec 20          	sub    $0x20,%rsp
  8017cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017d3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d9:	48 63 c8             	movslq %eax,%rcx
  8017dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e3:	48 98                	cltq   
  8017e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ec:	00 
  8017ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f3:	49 89 c8             	mov    %rcx,%r8
  8017f6:	48 89 d1             	mov    %rdx,%rcx
  8017f9:	48 89 c2             	mov    %rax,%rdx
  8017fc:	be 01 00 00 00       	mov    $0x1,%esi
  801801:	bf 04 00 00 00       	mov    $0x4,%edi
  801806:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  80180d:	00 00 00 
  801810:	ff d0                	callq  *%rax
}
  801812:	c9                   	leaveq 
  801813:	c3                   	retq   

0000000000801814 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	48 83 ec 30          	sub    $0x30,%rsp
  80181c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80181f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801823:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801826:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80182a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80182e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801831:	48 63 c8             	movslq %eax,%rcx
  801834:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801838:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80183b:	48 63 f0             	movslq %eax,%rsi
  80183e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801842:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801845:	48 98                	cltq   
  801847:	48 89 0c 24          	mov    %rcx,(%rsp)
  80184b:	49 89 f9             	mov    %rdi,%r9
  80184e:	49 89 f0             	mov    %rsi,%r8
  801851:	48 89 d1             	mov    %rdx,%rcx
  801854:	48 89 c2             	mov    %rax,%rdx
  801857:	be 01 00 00 00       	mov    $0x1,%esi
  80185c:	bf 05 00 00 00       	mov    $0x5,%edi
  801861:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801868:	00 00 00 
  80186b:	ff d0                	callq  *%rax
}
  80186d:	c9                   	leaveq 
  80186e:	c3                   	retq   

000000000080186f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80186f:	55                   	push   %rbp
  801870:	48 89 e5             	mov    %rsp,%rbp
  801873:	48 83 ec 20          	sub    $0x20,%rsp
  801877:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80187e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801885:	48 98                	cltq   
  801887:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188e:	00 
  80188f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801895:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189b:	48 89 d1             	mov    %rdx,%rcx
  80189e:	48 89 c2             	mov    %rax,%rdx
  8018a1:	be 01 00 00 00       	mov    $0x1,%esi
  8018a6:	bf 06 00 00 00       	mov    $0x6,%edi
  8018ab:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8018b2:	00 00 00 
  8018b5:	ff d0                	callq  *%rax
}
  8018b7:	c9                   	leaveq 
  8018b8:	c3                   	retq   

00000000008018b9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018b9:	55                   	push   %rbp
  8018ba:	48 89 e5             	mov    %rsp,%rbp
  8018bd:	48 83 ec 20          	sub    $0x20,%rsp
  8018c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018ca:	48 63 d0             	movslq %eax,%rdx
  8018cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d0:	48 98                	cltq   
  8018d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d9:	00 
  8018da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e6:	48 89 d1             	mov    %rdx,%rcx
  8018e9:	48 89 c2             	mov    %rax,%rdx
  8018ec:	be 01 00 00 00       	mov    $0x1,%esi
  8018f1:	bf 08 00 00 00       	mov    $0x8,%edi
  8018f6:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 20          	sub    $0x20,%rsp
  80190c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801913:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801917:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191a:	48 98                	cltq   
  80191c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801923:	00 
  801924:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801930:	48 89 d1             	mov    %rdx,%rcx
  801933:	48 89 c2             	mov    %rax,%rdx
  801936:	be 01 00 00 00       	mov    $0x1,%esi
  80193b:	bf 09 00 00 00       	mov    $0x9,%edi
  801940:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801947:	00 00 00 
  80194a:	ff d0                	callq  *%rax
}
  80194c:	c9                   	leaveq 
  80194d:	c3                   	retq   

000000000080194e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194e:	55                   	push   %rbp
  80194f:	48 89 e5             	mov    %rsp,%rbp
  801952:	48 83 ec 20          	sub    $0x20,%rsp
  801956:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801959:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80195d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801961:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801964:	48 98                	cltq   
  801966:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196d:	00 
  80196e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801974:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197a:	48 89 d1             	mov    %rdx,%rcx
  80197d:	48 89 c2             	mov    %rax,%rdx
  801980:	be 01 00 00 00       	mov    $0x1,%esi
  801985:	bf 0a 00 00 00       	mov    $0xa,%edi
  80198a:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801991:	00 00 00 
  801994:	ff d0                	callq  *%rax
}
  801996:	c9                   	leaveq 
  801997:	c3                   	retq   

0000000000801998 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801998:	55                   	push   %rbp
  801999:	48 89 e5             	mov    %rsp,%rbp
  80199c:	48 83 ec 30          	sub    $0x30,%rsp
  8019a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ab:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b1:	48 63 f0             	movslq %eax,%rsi
  8019b4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bb:	48 98                	cltq   
  8019bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c8:	00 
  8019c9:	49 89 f1             	mov    %rsi,%r9
  8019cc:	49 89 c8             	mov    %rcx,%r8
  8019cf:	48 89 d1             	mov    %rdx,%rcx
  8019d2:	48 89 c2             	mov    %rax,%rdx
  8019d5:	be 00 00 00 00       	mov    $0x0,%esi
  8019da:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019df:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  8019e6:	00 00 00 
  8019e9:	ff d0                	callq  *%rax
}
  8019eb:	c9                   	leaveq 
  8019ec:	c3                   	retq   

00000000008019ed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ed:	55                   	push   %rbp
  8019ee:	48 89 e5             	mov    %rsp,%rbp
  8019f1:	48 83 ec 20          	sub    $0x20,%rsp
  8019f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a04:	00 
  801a05:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a11:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a16:	48 89 c2             	mov    %rax,%rdx
  801a19:	be 01 00 00 00       	mov    $0x1,%esi
  801a1e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a23:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801a2a:	00 00 00 
  801a2d:	ff d0                	callq  *%rax
}
  801a2f:	c9                   	leaveq 
  801a30:	c3                   	retq   

0000000000801a31 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a31:	55                   	push   %rbp
  801a32:	48 89 e5             	mov    %rsp,%rbp
  801a35:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a40:	00 
  801a41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	be 00 00 00 00       	mov    $0x0,%esi
  801a5c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801a61:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801a68:	00 00 00 
  801a6b:	ff d0                	callq  *%rax
}
  801a6d:	c9                   	leaveq 
  801a6e:	c3                   	retq   

0000000000801a6f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801a6f:	55                   	push   %rbp
  801a70:	48 89 e5             	mov    %rsp,%rbp
  801a73:	48 83 ec 20          	sub    $0x20,%rsp
  801a77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8e:	00 
  801a8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9b:	48 89 d1             	mov    %rdx,%rcx
  801a9e:	48 89 c2             	mov    %rax,%rdx
  801aa1:	be 00 00 00 00       	mov    $0x0,%esi
  801aa6:	bf 0f 00 00 00       	mov    $0xf,%edi
  801aab:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801ab2:	00 00 00 
  801ab5:	ff d0                	callq  *%rax
}
  801ab7:	c9                   	leaveq 
  801ab8:	c3                   	retq   

0000000000801ab9 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801ab9:	55                   	push   %rbp
  801aba:	48 89 e5             	mov    %rsp,%rbp
  801abd:	48 83 ec 20          	sub    $0x20,%rsp
  801ac1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ac5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801acd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad8:	00 
  801ad9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801adf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae5:	48 89 d1             	mov    %rdx,%rcx
  801ae8:	48 89 c2             	mov    %rax,%rdx
  801aeb:	be 00 00 00 00       	mov    $0x0,%esi
  801af0:	bf 10 00 00 00       	mov    $0x10,%edi
  801af5:	48 b8 e0 15 80 00 00 	movabs $0x8015e0,%rax
  801afc:	00 00 00 
  801aff:	ff d0                	callq  *%rax
}
  801b01:	c9                   	leaveq 
  801b02:	c3                   	retq   
	...

0000000000801b04 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b04:	55                   	push   %rbp
  801b05:	48 89 e5             	mov    %rsp,%rbp
  801b08:	48 83 ec 20          	sub    $0x20,%rsp
  801b0c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  801b10:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801b17:	00 00 00 
  801b1a:	48 8b 00             	mov    (%rax),%rax
  801b1d:	48 85 c0             	test   %rax,%rax
  801b20:	0f 85 8e 00 00 00    	jne    801bb4 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  801b26:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  801b2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  801b34:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  801b3b:	00 00 00 
  801b3e:	ff d0                	callq  *%rax
  801b40:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  801b43:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801b47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b4a:	ba 07 00 00 00       	mov    $0x7,%edx
  801b4f:	48 89 ce             	mov    %rcx,%rsi
  801b52:	89 c7                	mov    %eax,%edi
  801b54:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  801b5b:	00 00 00 
  801b5e:	ff d0                	callq  *%rax
  801b60:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  801b63:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801b67:	74 30                	je     801b99 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  801b69:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801b6c:	89 c1                	mov    %eax,%ecx
  801b6e:	48 ba b0 42 80 00 00 	movabs $0x8042b0,%rdx
  801b75:	00 00 00 
  801b78:	be 24 00 00 00       	mov    $0x24,%esi
  801b7d:	48 bf e7 42 80 00 00 	movabs $0x8042e7,%rdi
  801b84:	00 00 00 
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	49 b8 e4 39 80 00 00 	movabs $0x8039e4,%r8
  801b93:	00 00 00 
  801b96:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801b99:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b9c:	48 be c8 1b 80 00 00 	movabs $0x801bc8,%rsi
  801ba3:	00 00 00 
  801ba6:	89 c7                	mov    %eax,%edi
  801ba8:	48 b8 4e 19 80 00 00 	movabs $0x80194e,%rax
  801baf:	00 00 00 
  801bb2:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801bb4:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801bbb:	00 00 00 
  801bbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bc2:	48 89 10             	mov    %rdx,(%rax)
}
  801bc5:	c9                   	leaveq 
  801bc6:	c3                   	retq   
	...

0000000000801bc8 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801bc8:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801bcb:	48 a1 50 70 80 00 00 	movabs 0x807050,%rax
  801bd2:	00 00 00 
	call *%rax
  801bd5:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  801bd7:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  801bdb:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  801bdf:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  801be2:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801be9:	00 
		movq 120(%rsp), %rcx				// trap time rip
  801bea:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  801bef:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  801bf2:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  801bf3:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  801bf6:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  801bfd:	00 08 
		POPA_						// copy the register contents to the registers
  801bff:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c03:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c08:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c0d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c12:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c17:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c1c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c21:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c26:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c2b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801c30:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801c35:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801c3a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801c3f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801c44:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801c49:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  801c4d:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  801c51:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  801c52:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  801c53:	c3                   	retq   

0000000000801c54 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c54:	55                   	push   %rbp
  801c55:	48 89 e5             	mov    %rsp,%rbp
  801c58:	48 83 ec 08          	sub    $0x8,%rsp
  801c5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c64:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c6b:	ff ff ff 
  801c6e:	48 01 d0             	add    %rdx,%rax
  801c71:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c75:	c9                   	leaveq 
  801c76:	c3                   	retq   

0000000000801c77 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c77:	55                   	push   %rbp
  801c78:	48 89 e5             	mov    %rsp,%rbp
  801c7b:	48 83 ec 08          	sub    $0x8,%rsp
  801c7f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c87:	48 89 c7             	mov    %rax,%rdi
  801c8a:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
  801c96:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c9c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801ca0:	c9                   	leaveq 
  801ca1:	c3                   	retq   

0000000000801ca2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ca2:	55                   	push   %rbp
  801ca3:	48 89 e5             	mov    %rsp,%rbp
  801ca6:	48 83 ec 18          	sub    $0x18,%rsp
  801caa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cb5:	eb 6b                	jmp    801d22 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cba:	48 98                	cltq   
  801cbc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cc2:	48 c1 e0 0c          	shl    $0xc,%rax
  801cc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cce:	48 89 c2             	mov    %rax,%rdx
  801cd1:	48 c1 ea 15          	shr    $0x15,%rdx
  801cd5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cdc:	01 00 00 
  801cdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ce3:	83 e0 01             	and    $0x1,%eax
  801ce6:	48 85 c0             	test   %rax,%rax
  801ce9:	74 21                	je     801d0c <fd_alloc+0x6a>
  801ceb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cef:	48 89 c2             	mov    %rax,%rdx
  801cf2:	48 c1 ea 0c          	shr    $0xc,%rdx
  801cf6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cfd:	01 00 00 
  801d00:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d04:	83 e0 01             	and    $0x1,%eax
  801d07:	48 85 c0             	test   %rax,%rax
  801d0a:	75 12                	jne    801d1e <fd_alloc+0x7c>
			*fd_store = fd;
  801d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d10:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d14:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1c:	eb 1a                	jmp    801d38 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d1e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d22:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d26:	7e 8f                	jle    801cb7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d33:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	48 83 ec 20          	sub    $0x20,%rsp
  801d42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d49:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d4d:	78 06                	js     801d55 <fd_lookup+0x1b>
  801d4f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d53:	7e 07                	jle    801d5c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d5a:	eb 6c                	jmp    801dc8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d5f:	48 98                	cltq   
  801d61:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d67:	48 c1 e0 0c          	shl    $0xc,%rax
  801d6b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d73:	48 89 c2             	mov    %rax,%rdx
  801d76:	48 c1 ea 15          	shr    $0x15,%rdx
  801d7a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d81:	01 00 00 
  801d84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d88:	83 e0 01             	and    $0x1,%eax
  801d8b:	48 85 c0             	test   %rax,%rax
  801d8e:	74 21                	je     801db1 <fd_lookup+0x77>
  801d90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d94:	48 89 c2             	mov    %rax,%rdx
  801d97:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d9b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801da2:	01 00 00 
  801da5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801da9:	83 e0 01             	and    $0x1,%eax
  801dac:	48 85 c0             	test   %rax,%rax
  801daf:	75 07                	jne    801db8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801db1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db6:	eb 10                	jmp    801dc8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801db8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dbc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dc0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 30          	sub    $0x30,%rsp
  801dd2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dd6:	89 f0                	mov    %esi,%eax
  801dd8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddf:	48 89 c7             	mov    %rax,%rdi
  801de2:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  801de9:	00 00 00 
  801dec:	ff d0                	callq  *%rax
  801dee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801df2:	48 89 d6             	mov    %rdx,%rsi
  801df5:	89 c7                	mov    %eax,%edi
  801df7:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  801dfe:	00 00 00 
  801e01:	ff d0                	callq  *%rax
  801e03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e0a:	78 0a                	js     801e16 <fd_close+0x4c>
	    || fd != fd2)
  801e0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e10:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e14:	74 12                	je     801e28 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e16:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e1a:	74 05                	je     801e21 <fd_close+0x57>
  801e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e1f:	eb 05                	jmp    801e26 <fd_close+0x5c>
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	eb 69                	jmp    801e91 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2c:	8b 00                	mov    (%rax),%eax
  801e2e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e32:	48 89 d6             	mov    %rdx,%rsi
  801e35:	89 c7                	mov    %eax,%edi
  801e37:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e4a:	78 2a                	js     801e76 <fd_close+0xac>
		if (dev->dev_close)
  801e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e50:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e54:	48 85 c0             	test   %rax,%rax
  801e57:	74 16                	je     801e6f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e5d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801e61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e65:	48 89 c7             	mov    %rax,%rdi
  801e68:	ff d2                	callq  *%rdx
  801e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e6d:	eb 07                	jmp    801e76 <fd_close+0xac>
		else
			r = 0;
  801e6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7a:	48 89 c6             	mov    %rax,%rsi
  801e7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e82:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
	return r;
  801e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 20          	sub    $0x20,%rsp
  801e9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ea9:	eb 41                	jmp    801eec <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801eab:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801eb2:	00 00 00 
  801eb5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eb8:	48 63 d2             	movslq %edx,%rdx
  801ebb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebf:	8b 00                	mov    (%rax),%eax
  801ec1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ec4:	75 22                	jne    801ee8 <dev_lookup+0x55>
			*dev = devtab[i];
  801ec6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ecd:	00 00 00 
  801ed0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ed3:	48 63 d2             	movslq %edx,%rdx
  801ed6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ede:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	eb 60                	jmp    801f48 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ee8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eec:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801ef3:	00 00 00 
  801ef6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ef9:	48 63 d2             	movslq %edx,%rdx
  801efc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f00:	48 85 c0             	test   %rax,%rax
  801f03:	75 a6                	jne    801eab <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f05:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801f0c:	00 00 00 
  801f0f:	48 8b 00             	mov    (%rax),%rax
  801f12:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f18:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f1b:	89 c6                	mov    %eax,%esi
  801f1d:	48 bf f8 42 80 00 00 	movabs $0x8042f8,%rdi
  801f24:	00 00 00 
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	48 b9 cf 02 80 00 00 	movabs $0x8002cf,%rcx
  801f33:	00 00 00 
  801f36:	ff d1                	callq  *%rcx
	*dev = 0;
  801f38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f48:	c9                   	leaveq 
  801f49:	c3                   	retq   

0000000000801f4a <close>:

int
close(int fdnum)
{
  801f4a:	55                   	push   %rbp
  801f4b:	48 89 e5             	mov    %rsp,%rbp
  801f4e:	48 83 ec 20          	sub    $0x20,%rsp
  801f52:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f5c:	48 89 d6             	mov    %rdx,%rsi
  801f5f:	89 c7                	mov    %eax,%edi
  801f61:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  801f68:	00 00 00 
  801f6b:	ff d0                	callq  *%rax
  801f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f74:	79 05                	jns    801f7b <close+0x31>
		return r;
  801f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f79:	eb 18                	jmp    801f93 <close+0x49>
	else
		return fd_close(fd, 1);
  801f7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f7f:	be 01 00 00 00       	mov    $0x1,%esi
  801f84:	48 89 c7             	mov    %rax,%rdi
  801f87:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	callq  *%rax
}
  801f93:	c9                   	leaveq 
  801f94:	c3                   	retq   

0000000000801f95 <close_all>:

void
close_all(void)
{
  801f95:	55                   	push   %rbp
  801f96:	48 89 e5             	mov    %rsp,%rbp
  801f99:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa4:	eb 15                	jmp    801fbb <close_all+0x26>
		close(i);
  801fa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa9:	89 c7                	mov    %eax,%edi
  801fab:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  801fb2:	00 00 00 
  801fb5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fb7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fbb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801fbf:	7e e5                	jle    801fa6 <close_all+0x11>
		close(i);
}
  801fc1:	c9                   	leaveq 
  801fc2:	c3                   	retq   

0000000000801fc3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fc3:	55                   	push   %rbp
  801fc4:	48 89 e5             	mov    %rsp,%rbp
  801fc7:	48 83 ec 40          	sub    $0x40,%rsp
  801fcb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fce:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fd1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fd5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fd8:	48 89 d6             	mov    %rdx,%rsi
  801fdb:	89 c7                	mov    %eax,%edi
  801fdd:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ff0:	79 08                	jns    801ffa <dup+0x37>
		return r;
  801ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ff5:	e9 70 01 00 00       	jmpq   80216a <dup+0x1a7>
	close(newfdnum);
  801ffa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ffd:	89 c7                	mov    %eax,%edi
  801fff:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  802006:	00 00 00 
  802009:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80200b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80200e:	48 98                	cltq   
  802010:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802016:	48 c1 e0 0c          	shl    $0xc,%rax
  80201a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80201e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802022:	48 89 c7             	mov    %rax,%rdi
  802025:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  80202c:	00 00 00 
  80202f:	ff d0                	callq  *%rax
  802031:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802035:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802039:	48 89 c7             	mov    %rax,%rdi
  80203c:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  802043:	00 00 00 
  802046:	ff d0                	callq  *%rax
  802048:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80204c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802050:	48 89 c2             	mov    %rax,%rdx
  802053:	48 c1 ea 15          	shr    $0x15,%rdx
  802057:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80205e:	01 00 00 
  802061:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802065:	83 e0 01             	and    $0x1,%eax
  802068:	84 c0                	test   %al,%al
  80206a:	74 71                	je     8020dd <dup+0x11a>
  80206c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802070:	48 89 c2             	mov    %rax,%rdx
  802073:	48 c1 ea 0c          	shr    $0xc,%rdx
  802077:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80207e:	01 00 00 
  802081:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802085:	83 e0 01             	and    $0x1,%eax
  802088:	84 c0                	test   %al,%al
  80208a:	74 51                	je     8020dd <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80208c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802090:	48 89 c2             	mov    %rax,%rdx
  802093:	48 c1 ea 0c          	shr    $0xc,%rdx
  802097:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209e:	01 00 00 
  8020a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a5:	89 c1                	mov    %eax,%ecx
  8020a7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8020ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b5:	41 89 c8             	mov    %ecx,%r8d
  8020b8:	48 89 d1             	mov    %rdx,%rcx
  8020bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c0:	48 89 c6             	mov    %rax,%rsi
  8020c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c8:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  8020cf:	00 00 00 
  8020d2:	ff d0                	callq  *%rax
  8020d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020db:	78 56                	js     802133 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e1:	48 89 c2             	mov    %rax,%rdx
  8020e4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8020e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ef:	01 00 00 
  8020f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f6:	89 c1                	mov    %eax,%ecx
  8020f8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8020fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802102:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802106:	41 89 c8             	mov    %ecx,%r8d
  802109:	48 89 d1             	mov    %rdx,%rcx
  80210c:	ba 00 00 00 00       	mov    $0x0,%edx
  802111:	48 89 c6             	mov    %rax,%rsi
  802114:	bf 00 00 00 00       	mov    $0x0,%edi
  802119:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212c:	78 08                	js     802136 <dup+0x173>
		goto err;

	return newfdnum;
  80212e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802131:	eb 37                	jmp    80216a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802133:	90                   	nop
  802134:	eb 01                	jmp    802137 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802136:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213b:	48 89 c6             	mov    %rax,%rsi
  80213e:	bf 00 00 00 00       	mov    $0x0,%edi
  802143:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  80214a:	00 00 00 
  80214d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80214f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802153:	48 89 c6             	mov    %rax,%rsi
  802156:	bf 00 00 00 00       	mov    $0x0,%edi
  80215b:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  802162:	00 00 00 
  802165:	ff d0                	callq  *%rax
	return r;
  802167:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80216a:	c9                   	leaveq 
  80216b:	c3                   	retq   

000000000080216c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80216c:	55                   	push   %rbp
  80216d:	48 89 e5             	mov    %rsp,%rbp
  802170:	48 83 ec 40          	sub    $0x40,%rsp
  802174:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802177:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80217b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80217f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802183:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802186:	48 89 d6             	mov    %rdx,%rsi
  802189:	89 c7                	mov    %eax,%edi
  80218b:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  802192:	00 00 00 
  802195:	ff d0                	callq  *%rax
  802197:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80219a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219e:	78 24                	js     8021c4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a4:	8b 00                	mov    (%rax),%eax
  8021a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021aa:	48 89 d6             	mov    %rdx,%rsi
  8021ad:	89 c7                	mov    %eax,%edi
  8021af:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  8021b6:	00 00 00 
  8021b9:	ff d0                	callq  *%rax
  8021bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c2:	79 05                	jns    8021c9 <read+0x5d>
		return r;
  8021c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c7:	eb 7a                	jmp    802243 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cd:	8b 40 08             	mov    0x8(%rax),%eax
  8021d0:	83 e0 03             	and    $0x3,%eax
  8021d3:	83 f8 01             	cmp    $0x1,%eax
  8021d6:	75 3a                	jne    802212 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021d8:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8021df:	00 00 00 
  8021e2:	48 8b 00             	mov    (%rax),%rax
  8021e5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ee:	89 c6                	mov    %eax,%esi
  8021f0:	48 bf 17 43 80 00 00 	movabs $0x804317,%rdi
  8021f7:	00 00 00 
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ff:	48 b9 cf 02 80 00 00 	movabs $0x8002cf,%rcx
  802206:	00 00 00 
  802209:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80220b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802210:	eb 31                	jmp    802243 <read+0xd7>
	}
	if (!dev->dev_read)
  802212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802216:	48 8b 40 10          	mov    0x10(%rax),%rax
  80221a:	48 85 c0             	test   %rax,%rax
  80221d:	75 07                	jne    802226 <read+0xba>
		return -E_NOT_SUPP;
  80221f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802224:	eb 1d                	jmp    802243 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80222e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802232:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802236:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80223a:	48 89 ce             	mov    %rcx,%rsi
  80223d:	48 89 c7             	mov    %rax,%rdi
  802240:	41 ff d0             	callq  *%r8
}
  802243:	c9                   	leaveq 
  802244:	c3                   	retq   

0000000000802245 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802245:	55                   	push   %rbp
  802246:	48 89 e5             	mov    %rsp,%rbp
  802249:	48 83 ec 30          	sub    $0x30,%rsp
  80224d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802250:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802254:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80225f:	eb 46                	jmp    8022a7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802264:	48 98                	cltq   
  802266:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80226a:	48 29 c2             	sub    %rax,%rdx
  80226d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802270:	48 98                	cltq   
  802272:	48 89 c1             	mov    %rax,%rcx
  802275:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80227c:	48 89 ce             	mov    %rcx,%rsi
  80227f:	89 c7                	mov    %eax,%edi
  802281:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  802288:	00 00 00 
  80228b:	ff d0                	callq  *%rax
  80228d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802290:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802294:	79 05                	jns    80229b <readn+0x56>
			return m;
  802296:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802299:	eb 1d                	jmp    8022b8 <readn+0x73>
		if (m == 0)
  80229b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80229f:	74 13                	je     8022b4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022a4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022aa:	48 98                	cltq   
  8022ac:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022b0:	72 af                	jb     802261 <readn+0x1c>
  8022b2:	eb 01                	jmp    8022b5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8022b4:	90                   	nop
	}
	return tot;
  8022b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022b8:	c9                   	leaveq 
  8022b9:	c3                   	retq   

00000000008022ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022ba:	55                   	push   %rbp
  8022bb:	48 89 e5             	mov    %rsp,%rbp
  8022be:	48 83 ec 40          	sub    $0x40,%rsp
  8022c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022d4:	48 89 d6             	mov    %rdx,%rsi
  8022d7:	89 c7                	mov    %eax,%edi
  8022d9:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ec:	78 24                	js     802312 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f2:	8b 00                	mov    (%rax),%eax
  8022f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022f8:	48 89 d6             	mov    %rdx,%rsi
  8022fb:	89 c7                	mov    %eax,%edi
  8022fd:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  802304:	00 00 00 
  802307:	ff d0                	callq  *%rax
  802309:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80230c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802310:	79 05                	jns    802317 <write+0x5d>
		return r;
  802312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802315:	eb 79                	jmp    802390 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802317:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231b:	8b 40 08             	mov    0x8(%rax),%eax
  80231e:	83 e0 03             	and    $0x3,%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	75 3a                	jne    80235f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802325:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80232c:	00 00 00 
  80232f:	48 8b 00             	mov    (%rax),%rax
  802332:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802338:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80233b:	89 c6                	mov    %eax,%esi
  80233d:	48 bf 33 43 80 00 00 	movabs $0x804333,%rdi
  802344:	00 00 00 
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	48 b9 cf 02 80 00 00 	movabs $0x8002cf,%rcx
  802353:	00 00 00 
  802356:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235d:	eb 31                	jmp    802390 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80235f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802363:	48 8b 40 18          	mov    0x18(%rax),%rax
  802367:	48 85 c0             	test   %rax,%rax
  80236a:	75 07                	jne    802373 <write+0xb9>
		return -E_NOT_SUPP;
  80236c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802371:	eb 1d                	jmp    802390 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802377:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80237b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80237f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802383:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802387:	48 89 ce             	mov    %rcx,%rsi
  80238a:	48 89 c7             	mov    %rax,%rdi
  80238d:	41 ff d0             	callq  *%r8
}
  802390:	c9                   	leaveq 
  802391:	c3                   	retq   

0000000000802392 <seek>:

int
seek(int fdnum, off_t offset)
{
  802392:	55                   	push   %rbp
  802393:	48 89 e5             	mov    %rsp,%rbp
  802396:	48 83 ec 18          	sub    $0x18,%rsp
  80239a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80239d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023a7:	48 89 d6             	mov    %rdx,%rsi
  8023aa:	89 c7                	mov    %eax,%edi
  8023ac:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	callq  *%rax
  8023b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bf:	79 05                	jns    8023c6 <seek+0x34>
		return r;
  8023c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c4:	eb 0f                	jmp    8023d5 <seek+0x43>
	fd->fd_offset = offset;
  8023c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023cd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d5:	c9                   	leaveq 
  8023d6:	c3                   	retq   

00000000008023d7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	48 83 ec 30          	sub    $0x30,%rsp
  8023df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023e2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023ec:	48 89 d6             	mov    %rdx,%rsi
  8023ef:	89 c7                	mov    %eax,%edi
  8023f1:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8023f8:	00 00 00 
  8023fb:	ff d0                	callq  *%rax
  8023fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802400:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802404:	78 24                	js     80242a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240a:	8b 00                	mov    (%rax),%eax
  80240c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802410:	48 89 d6             	mov    %rdx,%rsi
  802413:	89 c7                	mov    %eax,%edi
  802415:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  80241c:	00 00 00 
  80241f:	ff d0                	callq  *%rax
  802421:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802428:	79 05                	jns    80242f <ftruncate+0x58>
		return r;
  80242a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80242d:	eb 72                	jmp    8024a1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80242f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802433:	8b 40 08             	mov    0x8(%rax),%eax
  802436:	83 e0 03             	and    $0x3,%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 3a                	jne    802477 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80243d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802444:	00 00 00 
  802447:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80244a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802450:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802453:	89 c6                	mov    %eax,%esi
  802455:	48 bf 50 43 80 00 00 	movabs $0x804350,%rdi
  80245c:	00 00 00 
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	48 b9 cf 02 80 00 00 	movabs $0x8002cf,%rcx
  80246b:	00 00 00 
  80246e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802475:	eb 2a                	jmp    8024a1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80247f:	48 85 c0             	test   %rax,%rax
  802482:	75 07                	jne    80248b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802484:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802489:	eb 16                	jmp    8024a1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80248b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802497:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80249a:	89 d6                	mov    %edx,%esi
  80249c:	48 89 c7             	mov    %rax,%rdi
  80249f:	ff d1                	callq  *%rcx
}
  8024a1:	c9                   	leaveq 
  8024a2:	c3                   	retq   

00000000008024a3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024a3:	55                   	push   %rbp
  8024a4:	48 89 e5             	mov    %rsp,%rbp
  8024a7:	48 83 ec 30          	sub    $0x30,%rsp
  8024ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024b9:	48 89 d6             	mov    %rdx,%rsi
  8024bc:	89 c7                	mov    %eax,%edi
  8024be:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8024c5:	00 00 00 
  8024c8:	ff d0                	callq  *%rax
  8024ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d1:	78 24                	js     8024f7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d7:	8b 00                	mov    (%rax),%eax
  8024d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024dd:	48 89 d6             	mov    %rdx,%rsi
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 93 1e 80 00 00 	movabs $0x801e93,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
  8024ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f5:	79 05                	jns    8024fc <fstat+0x59>
		return r;
  8024f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024fa:	eb 5e                	jmp    80255a <fstat+0xb7>
	if (!dev->dev_stat)
  8024fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802500:	48 8b 40 28          	mov    0x28(%rax),%rax
  802504:	48 85 c0             	test   %rax,%rax
  802507:	75 07                	jne    802510 <fstat+0x6d>
		return -E_NOT_SUPP;
  802509:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80250e:	eb 4a                	jmp    80255a <fstat+0xb7>
	stat->st_name[0] = 0;
  802510:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802514:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802517:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80251b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802522:	00 00 00 
	stat->st_isdir = 0;
  802525:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802529:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802530:	00 00 00 
	stat->st_dev = dev;
  802533:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802537:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802546:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80254a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80254e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802552:	48 89 d6             	mov    %rdx,%rsi
  802555:	48 89 c7             	mov    %rax,%rdi
  802558:	ff d1                	callq  *%rcx
}
  80255a:	c9                   	leaveq 
  80255b:	c3                   	retq   

000000000080255c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80255c:	55                   	push   %rbp
  80255d:	48 89 e5             	mov    %rsp,%rbp
  802560:	48 83 ec 20          	sub    $0x20,%rsp
  802564:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802568:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80256c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802570:	be 00 00 00 00       	mov    $0x0,%esi
  802575:	48 89 c7             	mov    %rax,%rdi
  802578:	48 b8 4b 26 80 00 00 	movabs $0x80264b,%rax
  80257f:	00 00 00 
  802582:	ff d0                	callq  *%rax
  802584:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80258b:	79 05                	jns    802592 <stat+0x36>
		return fd;
  80258d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802590:	eb 2f                	jmp    8025c1 <stat+0x65>
	r = fstat(fd, stat);
  802592:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802599:	48 89 d6             	mov    %rdx,%rsi
  80259c:	89 c7                	mov    %eax,%edi
  80259e:	48 b8 a3 24 80 00 00 	movabs $0x8024a3,%rax
  8025a5:	00 00 00 
  8025a8:	ff d0                	callq  *%rax
  8025aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b0:	89 c7                	mov    %eax,%edi
  8025b2:	48 b8 4a 1f 80 00 00 	movabs $0x801f4a,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
	return r;
  8025be:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   
	...

00000000008025c4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025c4:	55                   	push   %rbp
  8025c5:	48 89 e5             	mov    %rsp,%rbp
  8025c8:	48 83 ec 10          	sub    $0x10,%rsp
  8025cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025d3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025da:	00 00 00 
  8025dd:	8b 00                	mov    (%rax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 1d                	jne    802600 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025e3:	bf 01 00 00 00       	mov    $0x1,%edi
  8025e8:	48 b8 7b 3c 80 00 00 	movabs $0x803c7b,%rax
  8025ef:	00 00 00 
  8025f2:	ff d0                	callq  *%rax
  8025f4:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  8025fb:	00 00 00 
  8025fe:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802600:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802607:	00 00 00 
  80260a:	8b 00                	mov    (%rax),%eax
  80260c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80260f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802614:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80261b:	00 00 00 
  80261e:	89 c7                	mov    %eax,%edi
  802620:	48 b8 b8 3b 80 00 00 	movabs $0x803bb8,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80262c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802630:	ba 00 00 00 00       	mov    $0x0,%edx
  802635:	48 89 c6             	mov    %rax,%rsi
  802638:	bf 00 00 00 00       	mov    $0x0,%edi
  80263d:	48 b8 f8 3a 80 00 00 	movabs $0x803af8,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
}
  802649:	c9                   	leaveq 
  80264a:	c3                   	retq   

000000000080264b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80264b:	55                   	push   %rbp
  80264c:	48 89 e5             	mov    %rsp,%rbp
  80264f:	48 83 ec 20          	sub    $0x20,%rsp
  802653:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802657:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80265a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80265e:	48 89 c7             	mov    %rax,%rdi
  802661:	48 b8 20 0e 80 00 00 	movabs $0x800e20,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802672:	7e 0a                	jle    80267e <open+0x33>
                return -E_BAD_PATH;
  802674:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802679:	e9 a5 00 00 00       	jmpq   802723 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80267e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802682:	48 89 c7             	mov    %rax,%rdi
  802685:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  80268c:	00 00 00 
  80268f:	ff d0                	callq  *%rax
  802691:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802694:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802698:	79 08                	jns    8026a2 <open+0x57>
		return r;
  80269a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269d:	e9 81 00 00 00       	jmpq   802723 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8026a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a6:	48 89 c6             	mov    %rax,%rsi
  8026a9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8026b0:	00 00 00 
  8026b3:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  8026ba:	00 00 00 
  8026bd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8026bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026c6:	00 00 00 
  8026c9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026cc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8026d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d6:	48 89 c6             	mov    %rax,%rsi
  8026d9:	bf 01 00 00 00       	mov    $0x1,%edi
  8026de:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8026e5:	00 00 00 
  8026e8:	ff d0                	callq  *%rax
  8026ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8026ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f1:	79 1d                	jns    802710 <open+0xc5>
	{
		fd_close(fd,0);
  8026f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f7:	be 00 00 00 00       	mov    $0x0,%esi
  8026fc:	48 89 c7             	mov    %rax,%rdi
  8026ff:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
		return r;
  80270b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270e:	eb 13                	jmp    802723 <open+0xd8>
	}
	return fd2num(fd);
  802710:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802714:	48 89 c7             	mov    %rax,%rdi
  802717:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  80271e:	00 00 00 
  802721:	ff d0                	callq  *%rax
	


}
  802723:	c9                   	leaveq 
  802724:	c3                   	retq   

0000000000802725 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802725:	55                   	push   %rbp
  802726:	48 89 e5             	mov    %rsp,%rbp
  802729:	48 83 ec 10          	sub    $0x10,%rsp
  80272d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802735:	8b 50 0c             	mov    0xc(%rax),%edx
  802738:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80273f:	00 00 00 
  802742:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802744:	be 00 00 00 00       	mov    $0x0,%esi
  802749:	bf 06 00 00 00       	mov    $0x6,%edi
  80274e:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  802755:	00 00 00 
  802758:	ff d0                	callq  *%rax
}
  80275a:	c9                   	leaveq 
  80275b:	c3                   	retq   

000000000080275c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80275c:	55                   	push   %rbp
  80275d:	48 89 e5             	mov    %rsp,%rbp
  802760:	48 83 ec 30          	sub    $0x30,%rsp
  802764:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802768:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80276c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802774:	8b 50 0c             	mov    0xc(%rax),%edx
  802777:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80277e:	00 00 00 
  802781:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802783:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80278a:	00 00 00 
  80278d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802791:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802795:	be 00 00 00 00       	mov    $0x0,%esi
  80279a:	bf 03 00 00 00       	mov    $0x3,%edi
  80279f:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
  8027ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027b2:	79 05                	jns    8027b9 <devfile_read+0x5d>
	{
		return r;
  8027b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b7:	eb 2c                	jmp    8027e5 <devfile_read+0x89>
	}
	if(r > 0)
  8027b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bd:	7e 23                	jle    8027e2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8027bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c2:	48 63 d0             	movslq %eax,%rdx
  8027c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8027d0:	00 00 00 
  8027d3:	48 89 c7             	mov    %rax,%rdi
  8027d6:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
	return r;
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8027e5:	c9                   	leaveq 
  8027e6:	c3                   	retq   

00000000008027e7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027e7:	55                   	push   %rbp
  8027e8:	48 89 e5             	mov    %rsp,%rbp
  8027eb:	48 83 ec 30          	sub    $0x30,%rsp
  8027ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8027fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802802:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802809:	00 00 00 
  80280c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80280e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802815:	00 
  802816:	76 08                	jbe    802820 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802818:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  80281f:	00 
	fsipcbuf.write.req_n=n;
  802820:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802827:	00 00 00 
  80282a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80282e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802832:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802836:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80283a:	48 89 c6             	mov    %rax,%rsi
  80283d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802844:	00 00 00 
  802847:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  80284e:	00 00 00 
  802851:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802853:	be 00 00 00 00       	mov    $0x0,%esi
  802858:	bf 04 00 00 00       	mov    $0x4,%edi
  80285d:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  802864:	00 00 00 
  802867:	ff d0                	callq  *%rax
  802869:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  80286c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80286f:	c9                   	leaveq 
  802870:	c3                   	retq   

0000000000802871 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802871:	55                   	push   %rbp
  802872:	48 89 e5             	mov    %rsp,%rbp
  802875:	48 83 ec 10          	sub    $0x10,%rsp
  802879:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80287d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802880:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802884:	8b 50 0c             	mov    0xc(%rax),%edx
  802887:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80288e:	00 00 00 
  802891:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802893:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80289a:	00 00 00 
  80289d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8028a3:	be 00 00 00 00       	mov    $0x0,%esi
  8028a8:	bf 02 00 00 00       	mov    $0x2,%edi
  8028ad:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8028b4:	00 00 00 
  8028b7:	ff d0                	callq  *%rax
}
  8028b9:	c9                   	leaveq 
  8028ba:	c3                   	retq   

00000000008028bb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028bb:	55                   	push   %rbp
  8028bc:	48 89 e5             	mov    %rsp,%rbp
  8028bf:	48 83 ec 20          	sub    $0x20,%rsp
  8028c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cf:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028d9:	00 00 00 
  8028dc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028de:	be 00 00 00 00       	mov    $0x0,%esi
  8028e3:	bf 05 00 00 00       	mov    $0x5,%edi
  8028e8:	48 b8 c4 25 80 00 00 	movabs $0x8025c4,%rax
  8028ef:	00 00 00 
  8028f2:	ff d0                	callq  *%rax
  8028f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fb:	79 05                	jns    802902 <devfile_stat+0x47>
		return r;
  8028fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802900:	eb 56                	jmp    802958 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802902:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802906:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80290d:	00 00 00 
  802910:	48 89 c7             	mov    %rax,%rdi
  802913:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80291f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802926:	00 00 00 
  802929:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80292f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802933:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802939:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802940:	00 00 00 
  802943:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802949:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802958:	c9                   	leaveq 
  802959:	c3                   	retq   
	...

000000000080295c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80295c:	55                   	push   %rbp
  80295d:	48 89 e5             	mov    %rsp,%rbp
  802960:	48 83 ec 20          	sub    $0x20,%rsp
  802964:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802967:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80296b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80296e:	48 89 d6             	mov    %rdx,%rsi
  802971:	89 c7                	mov    %eax,%edi
  802973:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
  80297f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802986:	79 05                	jns    80298d <fd2sockid+0x31>
		return r;
  802988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298b:	eb 24                	jmp    8029b1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80298d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802991:	8b 10                	mov    (%rax),%edx
  802993:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80299a:	00 00 00 
  80299d:	8b 00                	mov    (%rax),%eax
  80299f:	39 c2                	cmp    %eax,%edx
  8029a1:	74 07                	je     8029aa <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8029a3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029a8:	eb 07                	jmp    8029b1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8029aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ae:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 20          	sub    $0x20,%rsp
  8029bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029be:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029c2:	48 89 c7             	mov    %rax,%rdi
  8029c5:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
  8029d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d8:	78 26                	js     802a00 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8029da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029de:	ba 07 04 00 00       	mov    $0x407,%edx
  8029e3:	48 89 c6             	mov    %rax,%rsi
  8029e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029eb:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
  8029f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fe:	79 16                	jns    802a16 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802a00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a03:	89 c7                	mov    %eax,%edi
  802a05:	48 b8 c0 2e 80 00 00 	movabs $0x802ec0,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	callq  *%rax
		return r;
  802a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a14:	eb 3a                	jmp    802a50 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802a21:	00 00 00 
  802a24:	8b 12                	mov    (%rdx),%edx
  802a26:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802a28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a2c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802a33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a37:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a3a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a41:	48 89 c7             	mov    %rax,%rdi
  802a44:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
}
  802a50:	c9                   	leaveq 
  802a51:	c3                   	retq   

0000000000802a52 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
  802a56:	48 83 ec 30          	sub    $0x30,%rsp
  802a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a5d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a61:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a68:	89 c7                	mov    %eax,%edi
  802a6a:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
  802a76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7d:	79 05                	jns    802a84 <accept+0x32>
		return r;
  802a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a82:	eb 3b                	jmp    802abf <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802a84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a88:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8f:	48 89 ce             	mov    %rcx,%rsi
  802a92:	89 c7                	mov    %eax,%edi
  802a94:	48 b8 9d 2d 80 00 00 	movabs $0x802d9d,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
  802aa0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa7:	79 05                	jns    802aae <accept+0x5c>
		return r;
  802aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aac:	eb 11                	jmp    802abf <accept+0x6d>
	return alloc_sockfd(r);
  802aae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab1:	89 c7                	mov    %eax,%edi
  802ab3:	48 b8 b3 29 80 00 00 	movabs $0x8029b3,%rax
  802aba:	00 00 00 
  802abd:	ff d0                	callq  *%rax
}
  802abf:	c9                   	leaveq 
  802ac0:	c3                   	retq   

0000000000802ac1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	48 83 ec 20          	sub    $0x20,%rsp
  802ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802acc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ad0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ad3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ad6:	89 c7                	mov    %eax,%edi
  802ad8:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802adf:	00 00 00 
  802ae2:	ff d0                	callq  *%rax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ae7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aeb:	79 05                	jns    802af2 <bind+0x31>
		return r;
  802aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af0:	eb 1b                	jmp    802b0d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802af2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802af5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	48 89 ce             	mov    %rcx,%rsi
  802aff:	89 c7                	mov    %eax,%edi
  802b01:	48 b8 1c 2e 80 00 00 	movabs $0x802e1c,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
}
  802b0d:	c9                   	leaveq 
  802b0e:	c3                   	retq   

0000000000802b0f <shutdown>:

int
shutdown(int s, int how)
{
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
  802b13:	48 83 ec 20          	sub    $0x20,%rsp
  802b17:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b1a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b20:	89 c7                	mov    %eax,%edi
  802b22:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802b29:	00 00 00 
  802b2c:	ff d0                	callq  *%rax
  802b2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b35:	79 05                	jns    802b3c <shutdown+0x2d>
		return r;
  802b37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3a:	eb 16                	jmp    802b52 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802b3c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b42:	89 d6                	mov    %edx,%esi
  802b44:	89 c7                	mov    %eax,%edi
  802b46:	48 b8 80 2e 80 00 00 	movabs $0x802e80,%rax
  802b4d:	00 00 00 
  802b50:	ff d0                	callq  *%rax
}
  802b52:	c9                   	leaveq 
  802b53:	c3                   	retq   

0000000000802b54 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802b54:	55                   	push   %rbp
  802b55:	48 89 e5             	mov    %rsp,%rbp
  802b58:	48 83 ec 10          	sub    $0x10,%rsp
  802b5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802b60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b64:	48 89 c7             	mov    %rax,%rdi
  802b67:	48 b8 00 3d 80 00 00 	movabs $0x803d00,%rax
  802b6e:	00 00 00 
  802b71:	ff d0                	callq  *%rax
  802b73:	83 f8 01             	cmp    $0x1,%eax
  802b76:	75 17                	jne    802b8f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802b78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b7c:	8b 40 0c             	mov    0xc(%rax),%eax
  802b7f:	89 c7                	mov    %eax,%edi
  802b81:	48 b8 c0 2e 80 00 00 	movabs $0x802ec0,%rax
  802b88:	00 00 00 
  802b8b:	ff d0                	callq  *%rax
  802b8d:	eb 05                	jmp    802b94 <devsock_close+0x40>
	else
		return 0;
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b94:	c9                   	leaveq 
  802b95:	c3                   	retq   

0000000000802b96 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b96:	55                   	push   %rbp
  802b97:	48 89 e5             	mov    %rsp,%rbp
  802b9a:	48 83 ec 20          	sub    $0x20,%rsp
  802b9e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ba1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ba5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bab:	89 c7                	mov    %eax,%edi
  802bad:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802bb4:	00 00 00 
  802bb7:	ff d0                	callq  *%rax
  802bb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc0:	79 05                	jns    802bc7 <connect+0x31>
		return r;
  802bc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc5:	eb 1b                	jmp    802be2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802bc7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802bce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd1:	48 89 ce             	mov    %rcx,%rsi
  802bd4:	89 c7                	mov    %eax,%edi
  802bd6:	48 b8 ed 2e 80 00 00 	movabs $0x802eed,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <listen>:

int
listen(int s, int backlog)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	48 83 ec 20          	sub    $0x20,%rsp
  802bec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bf2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf5:	89 c7                	mov    %eax,%edi
  802bf7:	48 b8 5c 29 80 00 00 	movabs $0x80295c,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
  802c03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0a:	79 05                	jns    802c11 <listen+0x2d>
		return r;
  802c0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0f:	eb 16                	jmp    802c27 <listen+0x43>
	return nsipc_listen(r, backlog);
  802c11:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c17:	89 d6                	mov    %edx,%esi
  802c19:	89 c7                	mov    %eax,%edi
  802c1b:	48 b8 51 2f 80 00 00 	movabs $0x802f51,%rax
  802c22:	00 00 00 
  802c25:	ff d0                	callq  *%rax
}
  802c27:	c9                   	leaveq 
  802c28:	c3                   	retq   

0000000000802c29 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802c29:	55                   	push   %rbp
  802c2a:	48 89 e5             	mov    %rsp,%rbp
  802c2d:	48 83 ec 20          	sub    $0x20,%rsp
  802c31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c39:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802c3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c41:	89 c2                	mov    %eax,%edx
  802c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c47:	8b 40 0c             	mov    0xc(%rax),%eax
  802c4a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802c4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c53:	89 c7                	mov    %eax,%edi
  802c55:	48 b8 91 2f 80 00 00 	movabs $0x802f91,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
}
  802c61:	c9                   	leaveq 
  802c62:	c3                   	retq   

0000000000802c63 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802c63:	55                   	push   %rbp
  802c64:	48 89 e5             	mov    %rsp,%rbp
  802c67:	48 83 ec 20          	sub    $0x20,%rsp
  802c6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7b:	89 c2                	mov    %eax,%edx
  802c7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c81:	8b 40 0c             	mov    0xc(%rax),%eax
  802c84:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802c88:	b9 00 00 00 00       	mov    $0x0,%ecx
  802c8d:	89 c7                	mov    %eax,%edi
  802c8f:	48 b8 5d 30 80 00 00 	movabs $0x80305d,%rax
  802c96:	00 00 00 
  802c99:	ff d0                	callq  *%rax
}
  802c9b:	c9                   	leaveq 
  802c9c:	c3                   	retq   

0000000000802c9d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802c9d:	55                   	push   %rbp
  802c9e:	48 89 e5             	mov    %rsp,%rbp
  802ca1:	48 83 ec 10          	sub    $0x10,%rsp
  802ca5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ca9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cb1:	48 be 7b 43 80 00 00 	movabs $0x80437b,%rsi
  802cb8:	00 00 00 
  802cbb:	48 89 c7             	mov    %rax,%rdi
  802cbe:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  802cc5:	00 00 00 
  802cc8:	ff d0                	callq  *%rax
	return 0;
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <socket>:

int
socket(int domain, int type, int protocol)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 20          	sub    $0x20,%rsp
  802cd9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cdc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802cdf:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802ce2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ce5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ce8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ceb:	89 ce                	mov    %ecx,%esi
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 15 31 80 00 00 	movabs $0x803115,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 05                	jns    802d09 <socket+0x38>
		return r;
  802d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d07:	eb 11                	jmp    802d1a <socket+0x49>
	return alloc_sockfd(r);
  802d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0c:	89 c7                	mov    %eax,%edi
  802d0e:	48 b8 b3 29 80 00 00 	movabs $0x8029b3,%rax
  802d15:	00 00 00 
  802d18:	ff d0                	callq  *%rax
}
  802d1a:	c9                   	leaveq 
  802d1b:	c3                   	retq   

0000000000802d1c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802d1c:	55                   	push   %rbp
  802d1d:	48 89 e5             	mov    %rsp,%rbp
  802d20:	48 83 ec 10          	sub    $0x10,%rsp
  802d24:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802d27:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802d2e:	00 00 00 
  802d31:	8b 00                	mov    (%rax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	75 1d                	jne    802d54 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802d37:	bf 02 00 00 00       	mov    $0x2,%edi
  802d3c:	48 b8 7b 3c 80 00 00 	movabs $0x803c7b,%rax
  802d43:	00 00 00 
  802d46:	ff d0                	callq  *%rax
  802d48:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  802d4f:	00 00 00 
  802d52:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802d54:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802d5b:	00 00 00 
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d63:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d68:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802d6f:	00 00 00 
  802d72:	89 c7                	mov    %eax,%edi
  802d74:	48 b8 b8 3b 80 00 00 	movabs $0x803bb8,%rax
  802d7b:	00 00 00 
  802d7e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802d80:	ba 00 00 00 00       	mov    $0x0,%edx
  802d85:	be 00 00 00 00       	mov    $0x0,%esi
  802d8a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d8f:	48 b8 f8 3a 80 00 00 	movabs $0x803af8,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
}
  802d9b:	c9                   	leaveq 
  802d9c:	c3                   	retq   

0000000000802d9d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d9d:	55                   	push   %rbp
  802d9e:	48 89 e5             	mov    %rsp,%rbp
  802da1:	48 83 ec 30          	sub    $0x30,%rsp
  802da5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802db0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802db7:	00 00 00 
  802dba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802dbd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802dbf:	bf 01 00 00 00       	mov    $0x1,%edi
  802dc4:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802dcb:	00 00 00 
  802dce:	ff d0                	callq  *%rax
  802dd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd7:	78 3e                	js     802e17 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802dd9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802de0:	00 00 00 
  802de3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802deb:	8b 40 10             	mov    0x10(%rax),%eax
  802dee:	89 c2                	mov    %eax,%edx
  802df0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802df4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802df8:	48 89 ce             	mov    %rcx,%rsi
  802dfb:	48 89 c7             	mov    %rax,%rdi
  802dfe:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0e:	8b 50 10             	mov    0x10(%rax),%edx
  802e11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e15:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802e17:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e1a:	c9                   	leaveq 
  802e1b:	c3                   	retq   

0000000000802e1c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e1c:	55                   	push   %rbp
  802e1d:	48 89 e5             	mov    %rsp,%rbp
  802e20:	48 83 ec 10          	sub    $0x10,%rsp
  802e24:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e2b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802e2e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e35:	00 00 00 
  802e38:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e3b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e3d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e44:	48 89 c6             	mov    %rax,%rsi
  802e47:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802e4e:	00 00 00 
  802e51:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802e5d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e64:	00 00 00 
  802e67:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802e6a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802e6d:	bf 02 00 00 00       	mov    $0x2,%edi
  802e72:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802e79:	00 00 00 
  802e7c:	ff d0                	callq  *%rax
}
  802e7e:	c9                   	leaveq 
  802e7f:	c3                   	retq   

0000000000802e80 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802e80:	55                   	push   %rbp
  802e81:	48 89 e5             	mov    %rsp,%rbp
  802e84:	48 83 ec 10          	sub    $0x10,%rsp
  802e88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e8b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802e8e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e95:	00 00 00 
  802e98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802e9b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802e9d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ea4:	00 00 00 
  802ea7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802eaa:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802ead:	bf 03 00 00 00       	mov    $0x3,%edi
  802eb2:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
}
  802ebe:	c9                   	leaveq 
  802ebf:	c3                   	retq   

0000000000802ec0 <nsipc_close>:

int
nsipc_close(int s)
{
  802ec0:	55                   	push   %rbp
  802ec1:	48 89 e5             	mov    %rsp,%rbp
  802ec4:	48 83 ec 10          	sub    $0x10,%rsp
  802ec8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802ecb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ed2:	00 00 00 
  802ed5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ed8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802eda:	bf 04 00 00 00       	mov    $0x4,%edi
  802edf:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
}
  802eeb:	c9                   	leaveq 
  802eec:	c3                   	retq   

0000000000802eed <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802eed:	55                   	push   %rbp
  802eee:	48 89 e5             	mov    %rsp,%rbp
  802ef1:	48 83 ec 10          	sub    $0x10,%rsp
  802ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802efc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802eff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f06:	00 00 00 
  802f09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f0c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802f0e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f15:	48 89 c6             	mov    %rax,%rsi
  802f18:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f1f:	00 00 00 
  802f22:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802f2e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f35:	00 00 00 
  802f38:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f3b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802f3e:	bf 05 00 00 00       	mov    $0x5,%edi
  802f43:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
}
  802f4f:	c9                   	leaveq 
  802f50:	c3                   	retq   

0000000000802f51 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802f51:	55                   	push   %rbp
  802f52:	48 89 e5             	mov    %rsp,%rbp
  802f55:	48 83 ec 10          	sub    $0x10,%rsp
  802f59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f5c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802f5f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f66:	00 00 00 
  802f69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f6c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802f6e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f75:	00 00 00 
  802f78:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f7b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  802f7e:	bf 06 00 00 00       	mov    $0x6,%edi
  802f83:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
}
  802f8f:	c9                   	leaveq 
  802f90:	c3                   	retq   

0000000000802f91 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802f91:	55                   	push   %rbp
  802f92:	48 89 e5             	mov    %rsp,%rbp
  802f95:	48 83 ec 30          	sub    $0x30,%rsp
  802f99:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802fa3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802fa6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fad:	00 00 00 
  802fb0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802fb3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802fb5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fbc:	00 00 00 
  802fbf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802fc5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fcc:	00 00 00 
  802fcf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fd2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802fd5:	bf 07 00 00 00       	mov    $0x7,%edi
  802fda:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  802fe1:	00 00 00 
  802fe4:	ff d0                	callq  *%rax
  802fe6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fed:	78 69                	js     803058 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  802fef:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802ff6:	7f 08                	jg     803000 <nsipc_recv+0x6f>
  802ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802ffe:	7e 35                	jle    803035 <nsipc_recv+0xa4>
  803000:	48 b9 82 43 80 00 00 	movabs $0x804382,%rcx
  803007:	00 00 00 
  80300a:	48 ba 97 43 80 00 00 	movabs $0x804397,%rdx
  803011:	00 00 00 
  803014:	be 61 00 00 00       	mov    $0x61,%esi
  803019:	48 bf ac 43 80 00 00 	movabs $0x8043ac,%rdi
  803020:	00 00 00 
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
  803028:	49 b8 e4 39 80 00 00 	movabs $0x8039e4,%r8
  80302f:	00 00 00 
  803032:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803035:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803038:	48 63 d0             	movslq %eax,%rdx
  80303b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803046:	00 00 00 
  803049:	48 89 c7             	mov    %rax,%rdi
  80304c:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
	}

	return r;
  803058:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80305b:	c9                   	leaveq 
  80305c:	c3                   	retq   

000000000080305d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80305d:	55                   	push   %rbp
  80305e:	48 89 e5             	mov    %rsp,%rbp
  803061:	48 83 ec 20          	sub    $0x20,%rsp
  803065:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80306c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80306f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803072:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803079:	00 00 00 
  80307c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80307f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803081:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803088:	7e 35                	jle    8030bf <nsipc_send+0x62>
  80308a:	48 b9 b8 43 80 00 00 	movabs $0x8043b8,%rcx
  803091:	00 00 00 
  803094:	48 ba 97 43 80 00 00 	movabs $0x804397,%rdx
  80309b:	00 00 00 
  80309e:	be 6c 00 00 00       	mov    $0x6c,%esi
  8030a3:	48 bf ac 43 80 00 00 	movabs $0x8043ac,%rdi
  8030aa:	00 00 00 
  8030ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b2:	49 b8 e4 39 80 00 00 	movabs $0x8039e4,%r8
  8030b9:	00 00 00 
  8030bc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8030bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c2:	48 63 d0             	movslq %eax,%rdx
  8030c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c9:	48 89 c6             	mov    %rax,%rsi
  8030cc:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8030d3:	00 00 00 
  8030d6:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8030e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030e9:	00 00 00 
  8030ec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8030f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030f9:	00 00 00 
  8030fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030ff:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803102:	bf 08 00 00 00       	mov    $0x8,%edi
  803107:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  80310e:	00 00 00 
  803111:	ff d0                	callq  *%rax
}
  803113:	c9                   	leaveq 
  803114:	c3                   	retq   

0000000000803115 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803115:	55                   	push   %rbp
  803116:	48 89 e5             	mov    %rsp,%rbp
  803119:	48 83 ec 10          	sub    $0x10,%rsp
  80311d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803120:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803123:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803126:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312d:	00 00 00 
  803130:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803133:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803135:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80313c:	00 00 00 
  80313f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803142:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803145:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80314c:	00 00 00 
  80314f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803152:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803155:	bf 09 00 00 00       	mov    $0x9,%edi
  80315a:	48 b8 1c 2d 80 00 00 	movabs $0x802d1c,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
}
  803166:	c9                   	leaveq 
  803167:	c3                   	retq   

0000000000803168 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803168:	55                   	push   %rbp
  803169:	48 89 e5             	mov    %rsp,%rbp
  80316c:	53                   	push   %rbx
  80316d:	48 83 ec 38          	sub    $0x38,%rsp
  803171:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803175:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803179:	48 89 c7             	mov    %rax,%rdi
  80317c:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803183:	00 00 00 
  803186:	ff d0                	callq  *%rax
  803188:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80318b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80318f:	0f 88 bf 01 00 00    	js     803354 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803195:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803199:	ba 07 04 00 00       	mov    $0x407,%edx
  80319e:	48 89 c6             	mov    %rax,%rsi
  8031a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a6:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8031ad:	00 00 00 
  8031b0:	ff d0                	callq  *%rax
  8031b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031b9:	0f 88 95 01 00 00    	js     803354 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8031bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8031c3:	48 89 c7             	mov    %rax,%rdi
  8031c6:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  8031cd:	00 00 00 
  8031d0:	ff d0                	callq  *%rax
  8031d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031d9:	0f 88 5d 01 00 00    	js     80333c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8031e8:	48 89 c6             	mov    %rax,%rsi
  8031eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f0:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax
  8031fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803203:	0f 88 33 01 00 00    	js     80333c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803209:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320d:	48 89 c7             	mov    %rax,%rdi
  803210:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
  80321c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803220:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803224:	ba 07 04 00 00       	mov    $0x407,%edx
  803229:	48 89 c6             	mov    %rax,%rsi
  80322c:	bf 00 00 00 00       	mov    $0x0,%edi
  803231:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax
  80323d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803240:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803244:	0f 88 d9 00 00 00    	js     803323 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80324a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324e:	48 89 c7             	mov    %rax,%rdi
  803251:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
  80325d:	48 89 c2             	mov    %rax,%rdx
  803260:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803264:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80326a:	48 89 d1             	mov    %rdx,%rcx
  80326d:	ba 00 00 00 00       	mov    $0x0,%edx
  803272:	48 89 c6             	mov    %rax,%rsi
  803275:	bf 00 00 00 00       	mov    $0x0,%edi
  80327a:	48 b8 14 18 80 00 00 	movabs $0x801814,%rax
  803281:	00 00 00 
  803284:	ff d0                	callq  *%rax
  803286:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803289:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80328d:	78 79                	js     803308 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80328f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803293:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80329a:	00 00 00 
  80329d:	8b 12                	mov    (%rdx),%edx
  80329f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8032a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8032b7:	00 00 00 
  8032ba:	8b 12                	mov    (%rdx),%edx
  8032bc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8032be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032cd:	48 89 c7             	mov    %rax,%rdi
  8032d0:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	89 c2                	mov    %eax,%edx
  8032de:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032e2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8032e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032e8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8032ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f0:	48 89 c7             	mov    %rax,%rdi
  8032f3:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  8032fa:	00 00 00 
  8032fd:	ff d0                	callq  *%rax
  8032ff:	89 03                	mov    %eax,(%rbx)
	return 0;
  803301:	b8 00 00 00 00       	mov    $0x0,%eax
  803306:	eb 4f                	jmp    803357 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803308:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330d:	48 89 c6             	mov    %rax,%rsi
  803310:	bf 00 00 00 00       	mov    $0x0,%edi
  803315:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	eb 01                	jmp    803324 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803323:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803324:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803328:	48 89 c6             	mov    %rax,%rsi
  80332b:	bf 00 00 00 00       	mov    $0x0,%edi
  803330:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803337:	00 00 00 
  80333a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80333c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803340:	48 89 c6             	mov    %rax,%rsi
  803343:	bf 00 00 00 00       	mov    $0x0,%edi
  803348:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  80334f:	00 00 00 
  803352:	ff d0                	callq  *%rax
    err:
	return r;
  803354:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803357:	48 83 c4 38          	add    $0x38,%rsp
  80335b:	5b                   	pop    %rbx
  80335c:	5d                   	pop    %rbp
  80335d:	c3                   	retq   

000000000080335e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80335e:	55                   	push   %rbp
  80335f:	48 89 e5             	mov    %rsp,%rbp
  803362:	53                   	push   %rbx
  803363:	48 83 ec 28          	sub    $0x28,%rsp
  803367:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80336b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80336f:	eb 01                	jmp    803372 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803371:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803372:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803379:	00 00 00 
  80337c:	48 8b 00             	mov    (%rax),%rax
  80337f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803385:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338c:	48 89 c7             	mov    %rax,%rdi
  80338f:	48 b8 00 3d 80 00 00 	movabs $0x803d00,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
  80339b:	89 c3                	mov    %eax,%ebx
  80339d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a1:	48 89 c7             	mov    %rax,%rdi
  8033a4:	48 b8 00 3d 80 00 00 	movabs $0x803d00,%rax
  8033ab:	00 00 00 
  8033ae:	ff d0                	callq  *%rax
  8033b0:	39 c3                	cmp    %eax,%ebx
  8033b2:	0f 94 c0             	sete   %al
  8033b5:	0f b6 c0             	movzbl %al,%eax
  8033b8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8033bb:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8033c2:	00 00 00 
  8033c5:	48 8b 00             	mov    (%rax),%rax
  8033c8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8033ce:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8033d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033d7:	75 0a                	jne    8033e3 <_pipeisclosed+0x85>
			return ret;
  8033d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8033dc:	48 83 c4 28          	add    $0x28,%rsp
  8033e0:	5b                   	pop    %rbx
  8033e1:	5d                   	pop    %rbp
  8033e2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8033e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8033e9:	74 86                	je     803371 <_pipeisclosed+0x13>
  8033eb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8033ef:	75 80                	jne    803371 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8033f1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8033f8:	00 00 00 
  8033fb:	48 8b 00             	mov    (%rax),%rax
  8033fe:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803404:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803407:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340a:	89 c6                	mov    %eax,%esi
  80340c:	48 bf c9 43 80 00 00 	movabs $0x8043c9,%rdi
  803413:	00 00 00 
  803416:	b8 00 00 00 00       	mov    $0x0,%eax
  80341b:	49 b8 cf 02 80 00 00 	movabs $0x8002cf,%r8
  803422:	00 00 00 
  803425:	41 ff d0             	callq  *%r8
	}
  803428:	e9 44 ff ff ff       	jmpq   803371 <_pipeisclosed+0x13>

000000000080342d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80342d:	55                   	push   %rbp
  80342e:	48 89 e5             	mov    %rsp,%rbp
  803431:	48 83 ec 30          	sub    $0x30,%rsp
  803435:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803438:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80343c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80343f:	48 89 d6             	mov    %rdx,%rsi
  803442:	89 c7                	mov    %eax,%edi
  803444:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803457:	79 05                	jns    80345e <pipeisclosed+0x31>
		return r;
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345c:	eb 31                	jmp    80348f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80345e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803462:	48 89 c7             	mov    %rax,%rdi
  803465:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803479:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80347d:	48 89 d6             	mov    %rdx,%rsi
  803480:	48 89 c7             	mov    %rax,%rdi
  803483:	48 b8 5e 33 80 00 00 	movabs $0x80335e,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
}
  80348f:	c9                   	leaveq 
  803490:	c3                   	retq   

0000000000803491 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803491:	55                   	push   %rbp
  803492:	48 89 e5             	mov    %rsp,%rbp
  803495:	48 83 ec 40          	sub    $0x40,%rsp
  803499:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80349d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8034a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034a9:	48 89 c7             	mov    %rax,%rdi
  8034ac:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  8034b3:	00 00 00 
  8034b6:	ff d0                	callq  *%rax
  8034b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034bc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034c4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034cb:	00 
  8034cc:	e9 97 00 00 00       	jmpq   803568 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8034d1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8034d6:	74 09                	je     8034e1 <devpipe_read+0x50>
				return i;
  8034d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034dc:	e9 95 00 00 00       	jmpq   803576 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8034e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034e9:	48 89 d6             	mov    %rdx,%rsi
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 5e 33 80 00 00 	movabs $0x80335e,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 07                	je     803506 <devpipe_read+0x75>
				return 0;
  8034ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803504:	eb 70                	jmp    803576 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803506:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  80350d:	00 00 00 
  803510:	ff d0                	callq  *%rax
  803512:	eb 01                	jmp    803515 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803514:	90                   	nop
  803515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803519:	8b 10                	mov    (%rax),%edx
  80351b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80351f:	8b 40 04             	mov    0x4(%rax),%eax
  803522:	39 c2                	cmp    %eax,%edx
  803524:	74 ab                	je     8034d1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803526:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80352e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803536:	8b 00                	mov    (%rax),%eax
  803538:	89 c2                	mov    %eax,%edx
  80353a:	c1 fa 1f             	sar    $0x1f,%edx
  80353d:	c1 ea 1b             	shr    $0x1b,%edx
  803540:	01 d0                	add    %edx,%eax
  803542:	83 e0 1f             	and    $0x1f,%eax
  803545:	29 d0                	sub    %edx,%eax
  803547:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354b:	48 98                	cltq   
  80354d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803552:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803558:	8b 00                	mov    (%rax),%eax
  80355a:	8d 50 01             	lea    0x1(%rax),%edx
  80355d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803561:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803563:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803570:	72 a2                	jb     803514 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803576:	c9                   	leaveq 
  803577:	c3                   	retq   

0000000000803578 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803578:	55                   	push   %rbp
  803579:	48 89 e5             	mov    %rsp,%rbp
  80357c:	48 83 ec 40          	sub    $0x40,%rsp
  803580:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803584:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803588:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80358c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803590:	48 89 c7             	mov    %rax,%rdi
  803593:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  80359a:	00 00 00 
  80359d:	ff d0                	callq  *%rax
  80359f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035ab:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035b2:	00 
  8035b3:	e9 93 00 00 00       	jmpq   80364b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8035b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035c0:	48 89 d6             	mov    %rdx,%rsi
  8035c3:	48 89 c7             	mov    %rax,%rdi
  8035c6:	48 b8 5e 33 80 00 00 	movabs $0x80335e,%rax
  8035cd:	00 00 00 
  8035d0:	ff d0                	callq  *%rax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	74 07                	je     8035dd <devpipe_write+0x65>
				return 0;
  8035d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035db:	eb 7c                	jmp    803659 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8035dd:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
  8035e9:	eb 01                	jmp    8035ec <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8035eb:	90                   	nop
  8035ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f0:	8b 40 04             	mov    0x4(%rax),%eax
  8035f3:	48 63 d0             	movslq %eax,%rdx
  8035f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fa:	8b 00                	mov    (%rax),%eax
  8035fc:	48 98                	cltq   
  8035fe:	48 83 c0 20          	add    $0x20,%rax
  803602:	48 39 c2             	cmp    %rax,%rdx
  803605:	73 b1                	jae    8035b8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 40 04             	mov    0x4(%rax),%eax
  80360e:	89 c2                	mov    %eax,%edx
  803610:	c1 fa 1f             	sar    $0x1f,%edx
  803613:	c1 ea 1b             	shr    $0x1b,%edx
  803616:	01 d0                	add    %edx,%eax
  803618:	83 e0 1f             	and    $0x1f,%eax
  80361b:	29 d0                	sub    %edx,%eax
  80361d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803621:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803625:	48 01 ca             	add    %rcx,%rdx
  803628:	0f b6 0a             	movzbl (%rdx),%ecx
  80362b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80362f:	48 98                	cltq   
  803631:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803639:	8b 40 04             	mov    0x4(%rax),%eax
  80363c:	8d 50 01             	lea    0x1(%rax),%edx
  80363f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803643:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803646:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80364b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80364f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803653:	72 96                	jb     8035eb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803655:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803659:	c9                   	leaveq 
  80365a:	c3                   	retq   

000000000080365b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80365b:	55                   	push   %rbp
  80365c:	48 89 e5             	mov    %rsp,%rbp
  80365f:	48 83 ec 20          	sub    $0x20,%rsp
  803663:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803667:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80366b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366f:	48 89 c7             	mov    %rax,%rdi
  803672:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
  80367e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803682:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803686:	48 be dc 43 80 00 00 	movabs $0x8043dc,%rsi
  80368d:	00 00 00 
  803690:	48 89 c7             	mov    %rax,%rdi
  803693:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  80369a:	00 00 00 
  80369d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80369f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036a3:	8b 50 04             	mov    0x4(%rax),%edx
  8036a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036aa:	8b 00                	mov    (%rax),%eax
  8036ac:	29 c2                	sub    %eax,%edx
  8036ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8036b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036bc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8036c3:	00 00 00 
	stat->st_dev = &devpipe;
  8036c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036ca:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036d1:	00 00 00 
  8036d4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8036db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e0:	c9                   	leaveq 
  8036e1:	c3                   	retq   

00000000008036e2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036e2:	55                   	push   %rbp
  8036e3:	48 89 e5             	mov    %rsp,%rbp
  8036e6:	48 83 ec 10          	sub    $0x10,%rsp
  8036ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8036ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f2:	48 89 c6             	mov    %rax,%rsi
  8036f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fa:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80370a:	48 89 c7             	mov    %rax,%rdi
  80370d:	48 b8 77 1c 80 00 00 	movabs $0x801c77,%rax
  803714:	00 00 00 
  803717:	ff d0                	callq  *%rax
  803719:	48 89 c6             	mov    %rax,%rsi
  80371c:	bf 00 00 00 00       	mov    $0x0,%edi
  803721:	48 b8 6f 18 80 00 00 	movabs $0x80186f,%rax
  803728:	00 00 00 
  80372b:	ff d0                	callq  *%rax
}
  80372d:	c9                   	leaveq 
  80372e:	c3                   	retq   
	...

0000000000803730 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803730:	55                   	push   %rbp
  803731:	48 89 e5             	mov    %rsp,%rbp
  803734:	48 83 ec 20          	sub    $0x20,%rsp
  803738:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80373b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80373e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803741:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803745:	be 01 00 00 00       	mov    $0x1,%esi
  80374a:	48 89 c7             	mov    %rax,%rdi
  80374d:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  803754:	00 00 00 
  803757:	ff d0                	callq  *%rax
}
  803759:	c9                   	leaveq 
  80375a:	c3                   	retq   

000000000080375b <getchar>:

int
getchar(void)
{
  80375b:	55                   	push   %rbp
  80375c:	48 89 e5             	mov    %rsp,%rbp
  80375f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803763:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803767:	ba 01 00 00 00       	mov    $0x1,%edx
  80376c:	48 89 c6             	mov    %rax,%rsi
  80376f:	bf 00 00 00 00       	mov    $0x0,%edi
  803774:	48 b8 6c 21 80 00 00 	movabs $0x80216c,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
  803780:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803783:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803787:	79 05                	jns    80378e <getchar+0x33>
		return r;
  803789:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80378c:	eb 14                	jmp    8037a2 <getchar+0x47>
	if (r < 1)
  80378e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803792:	7f 07                	jg     80379b <getchar+0x40>
		return -E_EOF;
  803794:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803799:	eb 07                	jmp    8037a2 <getchar+0x47>
	return c;
  80379b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80379f:	0f b6 c0             	movzbl %al,%eax
}
  8037a2:	c9                   	leaveq 
  8037a3:	c3                   	retq   

00000000008037a4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8037a4:	55                   	push   %rbp
  8037a5:	48 89 e5             	mov    %rsp,%rbp
  8037a8:	48 83 ec 20          	sub    $0x20,%rsp
  8037ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8037af:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037b6:	48 89 d6             	mov    %rdx,%rsi
  8037b9:	89 c7                	mov    %eax,%edi
  8037bb:	48 b8 3a 1d 80 00 00 	movabs $0x801d3a,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
  8037c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ce:	79 05                	jns    8037d5 <iscons+0x31>
		return r;
  8037d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d3:	eb 1a                	jmp    8037ef <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8037d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d9:	8b 10                	mov    (%rax),%edx
  8037db:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8037e2:	00 00 00 
  8037e5:	8b 00                	mov    (%rax),%eax
  8037e7:	39 c2                	cmp    %eax,%edx
  8037e9:	0f 94 c0             	sete   %al
  8037ec:	0f b6 c0             	movzbl %al,%eax
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <opencons>:

int
opencons(void)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
  8037f5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8037f9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8037fd:	48 89 c7             	mov    %rax,%rdi
  803800:	48 b8 a2 1c 80 00 00 	movabs $0x801ca2,%rax
  803807:	00 00 00 
  80380a:	ff d0                	callq  *%rax
  80380c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80380f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803813:	79 05                	jns    80381a <opencons+0x29>
		return r;
  803815:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803818:	eb 5b                	jmp    803875 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80381a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381e:	ba 07 04 00 00       	mov    $0x407,%edx
  803823:	48 89 c6             	mov    %rax,%rsi
  803826:	bf 00 00 00 00       	mov    $0x0,%edi
  80382b:	48 b8 c4 17 80 00 00 	movabs $0x8017c4,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
  803837:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383e:	79 05                	jns    803845 <opencons+0x54>
		return r;
  803840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803843:	eb 30                	jmp    803875 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803845:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803849:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803850:	00 00 00 
  803853:	8b 12                	mov    (%rdx),%edx
  803855:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803866:	48 89 c7             	mov    %rax,%rdi
  803869:	48 b8 54 1c 80 00 00 	movabs $0x801c54,%rax
  803870:	00 00 00 
  803873:	ff d0                	callq  *%rax
}
  803875:	c9                   	leaveq 
  803876:	c3                   	retq   

0000000000803877 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803877:	55                   	push   %rbp
  803878:	48 89 e5             	mov    %rsp,%rbp
  80387b:	48 83 ec 30          	sub    $0x30,%rsp
  80387f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803883:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803887:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80388b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803890:	75 13                	jne    8038a5 <devcons_read+0x2e>
		return 0;
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
  803897:	eb 49                	jmp    8038e2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803899:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8038a5:	48 b8 c6 16 80 00 00 	movabs $0x8016c6,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b8:	74 df                	je     803899 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8038ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038be:	79 05                	jns    8038c5 <devcons_read+0x4e>
		return c;
  8038c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c3:	eb 1d                	jmp    8038e2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8038c5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8038c9:	75 07                	jne    8038d2 <devcons_read+0x5b>
		return 0;
  8038cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d0:	eb 10                	jmp    8038e2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d5:	89 c2                	mov    %eax,%edx
  8038d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038db:	88 10                	mov    %dl,(%rax)
	return 1;
  8038dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038e2:	c9                   	leaveq 
  8038e3:	c3                   	retq   

00000000008038e4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8038e4:	55                   	push   %rbp
  8038e5:	48 89 e5             	mov    %rsp,%rbp
  8038e8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8038ef:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8038f6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8038fd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803904:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80390b:	eb 77                	jmp    803984 <devcons_write+0xa0>
		m = n - tot;
  80390d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803914:	89 c2                	mov    %eax,%edx
  803916:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803919:	89 d1                	mov    %edx,%ecx
  80391b:	29 c1                	sub    %eax,%ecx
  80391d:	89 c8                	mov    %ecx,%eax
  80391f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803922:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803925:	83 f8 7f             	cmp    $0x7f,%eax
  803928:	76 07                	jbe    803931 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80392a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803931:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803934:	48 63 d0             	movslq %eax,%rdx
  803937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393a:	48 98                	cltq   
  80393c:	48 89 c1             	mov    %rax,%rcx
  80393f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803946:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80394d:	48 89 ce             	mov    %rcx,%rsi
  803950:	48 89 c7             	mov    %rax,%rdi
  803953:	48 b8 ae 11 80 00 00 	movabs $0x8011ae,%rax
  80395a:	00 00 00 
  80395d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80395f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803962:	48 63 d0             	movslq %eax,%rdx
  803965:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80396c:	48 89 d6             	mov    %rdx,%rsi
  80396f:	48 89 c7             	mov    %rax,%rdi
  803972:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  803979:	00 00 00 
  80397c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80397e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803981:	01 45 fc             	add    %eax,-0x4(%rbp)
  803984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803987:	48 98                	cltq   
  803989:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803990:	0f 82 77 ff ff ff    	jb     80390d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803996:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803999:	c9                   	leaveq 
  80399a:	c3                   	retq   

000000000080399b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80399b:	55                   	push   %rbp
  80399c:	48 89 e5             	mov    %rsp,%rbp
  80399f:	48 83 ec 08          	sub    $0x8,%rsp
  8039a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8039a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ac:	c9                   	leaveq 
  8039ad:	c3                   	retq   

00000000008039ae <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039ae:	55                   	push   %rbp
  8039af:	48 89 e5             	mov    %rsp,%rbp
  8039b2:	48 83 ec 10          	sub    $0x10,%rsp
  8039b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8039be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c2:	48 be e8 43 80 00 00 	movabs $0x8043e8,%rsi
  8039c9:	00 00 00 
  8039cc:	48 89 c7             	mov    %rax,%rdi
  8039cf:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
	return 0;
  8039db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   
	...

00000000008039e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8039e4:	55                   	push   %rbp
  8039e5:	48 89 e5             	mov    %rsp,%rbp
  8039e8:	53                   	push   %rbx
  8039e9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8039f0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8039f7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8039fd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803a04:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803a0b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803a12:	84 c0                	test   %al,%al
  803a14:	74 23                	je     803a39 <_panic+0x55>
  803a16:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803a1d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803a21:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803a25:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803a29:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803a2d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803a31:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803a35:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803a39:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803a40:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803a47:	00 00 00 
  803a4a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803a51:	00 00 00 
  803a54:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803a58:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803a5f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803a66:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803a6d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803a74:	00 00 00 
  803a77:	48 8b 18             	mov    (%rax),%rbx
  803a7a:	48 b8 48 17 80 00 00 	movabs $0x801748,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
  803a86:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a8c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a93:	41 89 c8             	mov    %ecx,%r8d
  803a96:	48 89 d1             	mov    %rdx,%rcx
  803a99:	48 89 da             	mov    %rbx,%rdx
  803a9c:	89 c6                	mov    %eax,%esi
  803a9e:	48 bf f0 43 80 00 00 	movabs $0x8043f0,%rdi
  803aa5:	00 00 00 
  803aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  803aad:	49 b9 cf 02 80 00 00 	movabs $0x8002cf,%r9
  803ab4:	00 00 00 
  803ab7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803aba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803ac1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803ac8:	48 89 d6             	mov    %rdx,%rsi
  803acb:	48 89 c7             	mov    %rax,%rdi
  803ace:	48 b8 23 02 80 00 00 	movabs $0x800223,%rax
  803ad5:	00 00 00 
  803ad8:	ff d0                	callq  *%rax
	cprintf("\n");
  803ada:	48 bf 13 44 80 00 00 	movabs $0x804413,%rdi
  803ae1:	00 00 00 
  803ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae9:	48 ba cf 02 80 00 00 	movabs $0x8002cf,%rdx
  803af0:	00 00 00 
  803af3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803af5:	cc                   	int3   
  803af6:	eb fd                	jmp    803af5 <_panic+0x111>

0000000000803af8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803af8:	55                   	push   %rbp
  803af9:	48 89 e5             	mov    %rsp,%rbp
  803afc:	48 83 ec 30          	sub    $0x30,%rsp
  803b00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b08:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803b0c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b11:	74 18                	je     803b2b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803b13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b17:	48 89 c7             	mov    %rax,%rdi
  803b1a:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  803b21:	00 00 00 
  803b24:	ff d0                	callq  *%rax
  803b26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b29:	eb 19                	jmp    803b44 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803b2b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803b32:	00 00 00 
  803b35:	48 b8 ed 19 80 00 00 	movabs $0x8019ed,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803b44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b48:	79 19                	jns    803b63 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b4e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b58:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b61:	eb 53                	jmp    803bb6 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803b63:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803b68:	74 19                	je     803b83 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803b6a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b71:	00 00 00 
  803b74:	48 8b 00             	mov    (%rax),%rax
  803b77:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b81:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803b83:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b88:	74 19                	je     803ba3 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803b8a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b91:	00 00 00 
  803b94:	48 8b 00             	mov    (%rax),%rax
  803b97:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803ba3:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803baa:	00 00 00 
  803bad:	48 8b 00             	mov    (%rax),%rax
  803bb0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803bb6:	c9                   	leaveq 
  803bb7:	c3                   	retq   

0000000000803bb8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803bb8:	55                   	push   %rbp
  803bb9:	48 89 e5             	mov    %rsp,%rbp
  803bbc:	48 83 ec 30          	sub    $0x30,%rsp
  803bc0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bc3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803bc6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803bca:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803bcd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803bd4:	e9 96 00 00 00       	jmpq   803c6f <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803bd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bde:	74 20                	je     803c00 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803be0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803be3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803be6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803bea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bed:	89 c7                	mov    %eax,%edi
  803bef:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  803bf6:	00 00 00 
  803bf9:	ff d0                	callq  *%rax
  803bfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bfe:	eb 2d                	jmp    803c2d <ipc_send+0x75>
		else if(pg==NULL)
  803c00:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c05:	75 26                	jne    803c2d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803c07:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c12:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c19:	00 00 00 
  803c1c:	89 c7                	mov    %eax,%edi
  803c1e:	48 b8 98 19 80 00 00 	movabs $0x801998,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
  803c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c31:	79 30                	jns    803c63 <ipc_send+0xab>
  803c33:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803c37:	74 2a                	je     803c63 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803c39:	48 ba 15 44 80 00 00 	movabs $0x804415,%rdx
  803c40:	00 00 00 
  803c43:	be 40 00 00 00       	mov    $0x40,%esi
  803c48:	48 bf 2d 44 80 00 00 	movabs $0x80442d,%rdi
  803c4f:	00 00 00 
  803c52:	b8 00 00 00 00       	mov    $0x0,%eax
  803c57:	48 b9 e4 39 80 00 00 	movabs $0x8039e4,%rcx
  803c5e:	00 00 00 
  803c61:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803c63:	48 b8 86 17 80 00 00 	movabs $0x801786,%rax
  803c6a:	00 00 00 
  803c6d:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	0f 85 60 ff ff ff    	jne    803bd9 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803c79:	c9                   	leaveq 
  803c7a:	c3                   	retq   

0000000000803c7b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803c7b:	55                   	push   %rbp
  803c7c:	48 89 e5             	mov    %rsp,%rbp
  803c7f:	48 83 ec 18          	sub    $0x18,%rsp
  803c83:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c8d:	eb 5e                	jmp    803ced <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803c8f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c96:	00 00 00 
  803c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c9c:	48 63 d0             	movslq %eax,%rdx
  803c9f:	48 89 d0             	mov    %rdx,%rax
  803ca2:	48 c1 e0 03          	shl    $0x3,%rax
  803ca6:	48 01 d0             	add    %rdx,%rax
  803ca9:	48 c1 e0 05          	shl    $0x5,%rax
  803cad:	48 01 c8             	add    %rcx,%rax
  803cb0:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803cb6:	8b 00                	mov    (%rax),%eax
  803cb8:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803cbb:	75 2c                	jne    803ce9 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803cbd:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803cc4:	00 00 00 
  803cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cca:	48 63 d0             	movslq %eax,%rdx
  803ccd:	48 89 d0             	mov    %rdx,%rax
  803cd0:	48 c1 e0 03          	shl    $0x3,%rax
  803cd4:	48 01 d0             	add    %rdx,%rax
  803cd7:	48 c1 e0 05          	shl    $0x5,%rax
  803cdb:	48 01 c8             	add    %rcx,%rax
  803cde:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ce4:	8b 40 08             	mov    0x8(%rax),%eax
  803ce7:	eb 12                	jmp    803cfb <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803ce9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ced:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803cf4:	7e 99                	jle    803c8f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cfb:	c9                   	leaveq 
  803cfc:	c3                   	retq   
  803cfd:	00 00                	add    %al,(%rax)
	...

0000000000803d00 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d00:	55                   	push   %rbp
  803d01:	48 89 e5             	mov    %rsp,%rbp
  803d04:	48 83 ec 18          	sub    $0x18,%rsp
  803d08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d10:	48 89 c2             	mov    %rax,%rdx
  803d13:	48 c1 ea 15          	shr    $0x15,%rdx
  803d17:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d1e:	01 00 00 
  803d21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d25:	83 e0 01             	and    $0x1,%eax
  803d28:	48 85 c0             	test   %rax,%rax
  803d2b:	75 07                	jne    803d34 <pageref+0x34>
		return 0;
  803d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d32:	eb 53                	jmp    803d87 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d38:	48 89 c2             	mov    %rax,%rdx
  803d3b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d46:	01 00 00 
  803d49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803d51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d55:	83 e0 01             	and    $0x1,%eax
  803d58:	48 85 c0             	test   %rax,%rax
  803d5b:	75 07                	jne    803d64 <pageref+0x64>
		return 0;
  803d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d62:	eb 23                	jmp    803d87 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803d64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d68:	48 89 c2             	mov    %rax,%rdx
  803d6b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803d6f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803d76:	00 00 00 
  803d79:	48 c1 e2 04          	shl    $0x4,%rdx
  803d7d:	48 01 d0             	add    %rdx,%rax
  803d80:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d84:	0f b7 c0             	movzwl %ax,%eax
}
  803d87:	c9                   	leaveq 
  803d88:	c3                   	retq   
