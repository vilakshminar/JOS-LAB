
obj/user/fairness.debug:     file format elf64-x86-64


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
  80003c:	e8 df 00 00 00       	callq  800120 <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800053:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800062:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800069:	00 00 00 
  80006c:	48 8b 10             	mov    (%rax),%rdx
  80006f:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800076:	00 00 00 
  800079:	48 39 c2             	cmp    %rax,%rdx
  80007c:	75 42                	jne    8000c0 <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007e:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	be 00 00 00 00       	mov    $0x0,%esi
  80008c:	48 89 c7             	mov    %rax,%rdi
  80008f:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a1:	89 c6                	mov    %eax,%esi
  8000a3:	48 bf 80 3c 80 00 00 	movabs $0x803c80,%rdi
  8000aa:	00 00 00 
  8000ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b2:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  8000b9:	00 00 00 
  8000bc:	ff d1                	callq  *%rcx
		}
  8000be:	eb be                	jmp    80007e <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000c0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c7:	00 00 00 
  8000ca:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d3:	89 c6                	mov    %eax,%esi
  8000d5:	48 bf 91 3c 80 00 00 	movabs $0x803c91,%rdi
  8000dc:	00 00 00 
  8000df:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e4:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  8000eb:	00 00 00 
  8000ee:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000f0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f7:	00 00 00 
  8000fa:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  800100:	b9 00 00 00 00       	mov    $0x0,%ecx
  800105:	ba 00 00 00 00       	mov    $0x0,%edx
  80010a:	be 00 00 00 00       	mov    $0x0,%esi
  80010f:	89 c7                	mov    %eax,%edi
  800111:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  800118:	00 00 00 
  80011b:	ff d0                	callq  *%rax
  80011d:	eb d1                	jmp    8000f0 <umain+0xac>
	...

0000000000800120 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800120:	55                   	push   %rbp
  800121:	48 89 e5             	mov    %rsp,%rbp
  800124:	48 83 ec 10          	sub    $0x10,%rsp
  800128:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80012b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80012f:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800136:	00 00 00 
  800139:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800140:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  800147:	00 00 00 
  80014a:	ff d0                	callq  *%rax
  80014c:	48 98                	cltq   
  80014e:	48 89 c2             	mov    %rax,%rdx
  800151:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800157:	48 89 d0             	mov    %rdx,%rax
  80015a:	48 c1 e0 03          	shl    $0x3,%rax
  80015e:	48 01 d0             	add    %rdx,%rax
  800161:	48 c1 e0 05          	shl    $0x5,%rax
  800165:	48 89 c2             	mov    %rax,%rdx
  800168:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80016f:	00 00 00 
  800172:	48 01 c2             	add    %rax,%rdx
  800175:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80017c:	00 00 00 
  80017f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800186:	7e 14                	jle    80019c <libmain+0x7c>
		binaryname = argv[0];
  800188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018c:	48 8b 10             	mov    (%rax),%rdx
  80018f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800196:	00 00 00 
  800199:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80019c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001a3:	48 89 d6             	mov    %rdx,%rsi
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001af:	00 00 00 
  8001b2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001b4:	48 b8 c4 01 80 00 00 	movabs $0x8001c4,%rax
  8001bb:	00 00 00 
  8001be:	ff d0                	callq  *%rax
}
  8001c0:	c9                   	leaveq 
  8001c1:	c3                   	retq   
	...

00000000008001c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c4:	55                   	push   %rbp
  8001c5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001c8:	48 b8 8d 20 80 00 00 	movabs $0x80208d,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8001d9:	48 b8 44 17 80 00 00 	movabs $0x801744,%rax
  8001e0:	00 00 00 
  8001e3:	ff d0                	callq  *%rax
}
  8001e5:	5d                   	pop    %rbp
  8001e6:	c3                   	retq   
	...

00000000008001e8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e8:	55                   	push   %rbp
  8001e9:	48 89 e5             	mov    %rsp,%rbp
  8001ec:	48 83 ec 10          	sub    $0x10,%rsp
  8001f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8001f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fb:	8b 00                	mov    (%rax),%eax
  8001fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800200:	89 d6                	mov    %edx,%esi
  800202:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800206:	48 63 d0             	movslq %eax,%rdx
  800209:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80020e:	8d 50 01             	lea    0x1(%rax),%edx
  800211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800215:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80021b:	8b 00                	mov    (%rax),%eax
  80021d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800222:	75 2c                	jne    800250 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800224:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800228:	8b 00                	mov    (%rax),%eax
  80022a:	48 98                	cltq   
  80022c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800230:	48 83 c2 08          	add    $0x8,%rdx
  800234:	48 89 c6             	mov    %rax,%rsi
  800237:	48 89 d7             	mov    %rdx,%rdi
  80023a:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax
		b->idx = 0;
  800246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800254:	8b 40 04             	mov    0x4(%rax),%eax
  800257:	8d 50 01             	lea    0x1(%rax),%edx
  80025a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800261:	c9                   	leaveq 
  800262:	c3                   	retq   

0000000000800263 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800263:	55                   	push   %rbp
  800264:	48 89 e5             	mov    %rsp,%rbp
  800267:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80026e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800275:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80027c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800283:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80028a:	48 8b 0a             	mov    (%rdx),%rcx
  80028d:	48 89 08             	mov    %rcx,(%rax)
  800290:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800294:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800298:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80029c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002a7:	00 00 00 
	b.cnt = 0;
  8002aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002b4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002bb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002c2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002c9:	48 89 c6             	mov    %rax,%rsi
  8002cc:	48 bf e8 01 80 00 00 	movabs $0x8001e8,%rdi
  8002d3:	00 00 00 
  8002d6:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  8002dd:	00 00 00 
  8002e0:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002e2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002e8:	48 98                	cltq   
  8002ea:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002f1:	48 83 c2 08          	add    $0x8,%rdx
  8002f5:	48 89 c6             	mov    %rax,%rsi
  8002f8:	48 89 d7             	mov    %rdx,%rdi
  8002fb:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800307:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80030d:	c9                   	leaveq 
  80030e:	c3                   	retq   

000000000080030f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030f:	55                   	push   %rbp
  800310:	48 89 e5             	mov    %rsp,%rbp
  800313:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80031a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800321:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800328:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80032f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800336:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80033d:	84 c0                	test   %al,%al
  80033f:	74 20                	je     800361 <cprintf+0x52>
  800341:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800345:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800349:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80034d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800351:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800355:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800359:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80035d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800361:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800368:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80036f:	00 00 00 
  800372:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800379:	00 00 00 
  80037c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800380:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800387:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80038e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800395:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80039c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003a3:	48 8b 0a             	mov    (%rdx),%rcx
  8003a6:	48 89 08             	mov    %rcx,(%rax)
  8003a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003b9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003c0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003c7:	48 89 d6             	mov    %rdx,%rsi
  8003ca:	48 89 c7             	mov    %rax,%rdi
  8003cd:	48 b8 63 02 80 00 00 	movabs $0x800263,%rax
  8003d4:	00 00 00 
  8003d7:	ff d0                	callq  *%rax
  8003d9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003df:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003e5:	c9                   	leaveq 
  8003e6:	c3                   	retq   
	...

00000000008003e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e8:	55                   	push   %rbp
  8003e9:	48 89 e5             	mov    %rsp,%rbp
  8003ec:	48 83 ec 30          	sub    $0x30,%rsp
  8003f0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8003f8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8003fc:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8003ff:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800403:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800407:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80040a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80040e:	77 52                	ja     800462 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800410:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800413:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800417:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80041a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80041e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800422:	ba 00 00 00 00       	mov    $0x0,%edx
  800427:	48 f7 75 d0          	divq   -0x30(%rbp)
  80042b:	48 89 c2             	mov    %rax,%rdx
  80042e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800431:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800434:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800438:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80043c:	41 89 f9             	mov    %edi,%r9d
  80043f:	48 89 c7             	mov    %rax,%rdi
  800442:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  800449:	00 00 00 
  80044c:	ff d0                	callq  *%rax
  80044e:	eb 1c                	jmp    80046c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800450:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800454:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800457:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80045b:	48 89 d6             	mov    %rdx,%rsi
  80045e:	89 c7                	mov    %eax,%edi
  800460:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800462:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800466:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80046a:	7f e4                	jg     800450 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80046c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80046f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	48 f7 f1             	div    %rcx
  80047b:	48 89 d0             	mov    %rdx,%rax
  80047e:	48 ba 88 3e 80 00 00 	movabs $0x803e88,%rdx
  800485:	00 00 00 
  800488:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80048c:	0f be c0             	movsbl %al,%eax
  80048f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800493:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800497:	48 89 d6             	mov    %rdx,%rsi
  80049a:	89 c7                	mov    %eax,%edi
  80049c:	ff d1                	callq  *%rcx
}
  80049e:	c9                   	leaveq 
  80049f:	c3                   	retq   

00000000008004a0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a0:	55                   	push   %rbp
  8004a1:	48 89 e5             	mov    %rsp,%rbp
  8004a4:	48 83 ec 20          	sub    $0x20,%rsp
  8004a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004af:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004b3:	7e 52                	jle    800507 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	8b 00                	mov    (%rax),%eax
  8004bb:	83 f8 30             	cmp    $0x30,%eax
  8004be:	73 24                	jae    8004e4 <getuint+0x44>
  8004c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	89 c0                	mov    %eax,%eax
  8004d0:	48 01 d0             	add    %rdx,%rax
  8004d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d7:	8b 12                	mov    (%rdx),%edx
  8004d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e0:	89 0a                	mov    %ecx,(%rdx)
  8004e2:	eb 17                	jmp    8004fb <getuint+0x5b>
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ec:	48 89 d0             	mov    %rdx,%rax
  8004ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fb:	48 8b 00             	mov    (%rax),%rax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800502:	e9 a3 00 00 00       	jmpq   8005aa <getuint+0x10a>
	else if (lflag)
  800507:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80050b:	74 4f                	je     80055c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	8b 00                	mov    (%rax),%eax
  800513:	83 f8 30             	cmp    $0x30,%eax
  800516:	73 24                	jae    80053c <getuint+0x9c>
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	89 c0                	mov    %eax,%eax
  800528:	48 01 d0             	add    %rdx,%rax
  80052b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052f:	8b 12                	mov    (%rdx),%edx
  800531:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	89 0a                	mov    %ecx,(%rdx)
  80053a:	eb 17                	jmp    800553 <getuint+0xb3>
  80053c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800540:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800544:	48 89 d0             	mov    %rdx,%rax
  800547:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80054b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800553:	48 8b 00             	mov    (%rax),%rax
  800556:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80055a:	eb 4e                	jmp    8005aa <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	8b 00                	mov    (%rax),%eax
  800562:	83 f8 30             	cmp    $0x30,%eax
  800565:	73 24                	jae    80058b <getuint+0xeb>
  800567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	89 c0                	mov    %eax,%eax
  800577:	48 01 d0             	add    %rdx,%rax
  80057a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057e:	8b 12                	mov    (%rdx),%edx
  800580:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800587:	89 0a                	mov    %ecx,(%rdx)
  800589:	eb 17                	jmp    8005a2 <getuint+0x102>
  80058b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800593:	48 89 d0             	mov    %rdx,%rax
  800596:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80059a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005a2:	8b 00                	mov    (%rax),%eax
  8005a4:	89 c0                	mov    %eax,%eax
  8005a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005ae:	c9                   	leaveq 
  8005af:	c3                   	retq   

00000000008005b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005b0:	55                   	push   %rbp
  8005b1:	48 89 e5             	mov    %rsp,%rbp
  8005b4:	48 83 ec 20          	sub    $0x20,%rsp
  8005b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005bf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005c3:	7e 52                	jle    800617 <getint+0x67>
		x=va_arg(*ap, long long);
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	8b 00                	mov    (%rax),%eax
  8005cb:	83 f8 30             	cmp    $0x30,%eax
  8005ce:	73 24                	jae    8005f4 <getint+0x44>
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	89 c0                	mov    %eax,%eax
  8005e0:	48 01 d0             	add    %rdx,%rax
  8005e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e7:	8b 12                	mov    (%rdx),%edx
  8005e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	89 0a                	mov    %ecx,(%rdx)
  8005f2:	eb 17                	jmp    80060b <getint+0x5b>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fc:	48 89 d0             	mov    %rdx,%rax
  8005ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060b:	48 8b 00             	mov    (%rax),%rax
  80060e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800612:	e9 a3 00 00 00       	jmpq   8006ba <getint+0x10a>
	else if (lflag)
  800617:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80061b:	74 4f                	je     80066c <getint+0xbc>
		x=va_arg(*ap, long);
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	8b 00                	mov    (%rax),%eax
  800623:	83 f8 30             	cmp    $0x30,%eax
  800626:	73 24                	jae    80064c <getint+0x9c>
  800628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	89 c0                	mov    %eax,%eax
  800638:	48 01 d0             	add    %rdx,%rax
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	8b 12                	mov    (%rdx),%edx
  800641:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	89 0a                	mov    %ecx,(%rdx)
  80064a:	eb 17                	jmp    800663 <getint+0xb3>
  80064c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800650:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800654:	48 89 d0             	mov    %rdx,%rax
  800657:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800663:	48 8b 00             	mov    (%rax),%rax
  800666:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80066a:	eb 4e                	jmp    8006ba <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	83 f8 30             	cmp    $0x30,%eax
  800675:	73 24                	jae    80069b <getint+0xeb>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	89 c0                	mov    %eax,%eax
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	8b 12                	mov    (%rdx),%edx
  800690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	89 0a                	mov    %ecx,(%rdx)
  800699:	eb 17                	jmp    8006b2 <getint+0x102>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a3:	48 89 d0             	mov    %rdx,%rax
  8006a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b2:	8b 00                	mov    (%rax),%eax
  8006b4:	48 98                	cltq   
  8006b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006be:	c9                   	leaveq 
  8006bf:	c3                   	retq   

00000000008006c0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006c0:	55                   	push   %rbp
  8006c1:	48 89 e5             	mov    %rsp,%rbp
  8006c4:	41 54                	push   %r12
  8006c6:	53                   	push   %rbx
  8006c7:	48 83 ec 60          	sub    $0x60,%rsp
  8006cb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006cf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006d3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006d7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006db:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006df:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006e3:	48 8b 0a             	mov    (%rdx),%rcx
  8006e6:	48 89 08             	mov    %rcx,(%rax)
  8006e9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ed:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006f1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006f5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	eb 17                	jmp    800712 <vprintfmt+0x52>
			if (ch == '\0')
  8006fb:	85 db                	test   %ebx,%ebx
  8006fd:	0f 84 d7 04 00 00    	je     800bda <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800703:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800707:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80070b:	48 89 c6             	mov    %rax,%rsi
  80070e:	89 df                	mov    %ebx,%edi
  800710:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800712:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800716:	0f b6 00             	movzbl (%rax),%eax
  800719:	0f b6 d8             	movzbl %al,%ebx
  80071c:	83 fb 25             	cmp    $0x25,%ebx
  80071f:	0f 95 c0             	setne  %al
  800722:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800727:	84 c0                	test   %al,%al
  800729:	75 d0                	jne    8006fb <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80072b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80072f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800736:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80073d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800744:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80074b:	eb 04                	jmp    800751 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  80074d:	90                   	nop
  80074e:	eb 01                	jmp    800751 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800750:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800751:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800755:	0f b6 00             	movzbl (%rax),%eax
  800758:	0f b6 d8             	movzbl %al,%ebx
  80075b:	89 d8                	mov    %ebx,%eax
  80075d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800762:	83 e8 23             	sub    $0x23,%eax
  800765:	83 f8 55             	cmp    $0x55,%eax
  800768:	0f 87 38 04 00 00    	ja     800ba6 <vprintfmt+0x4e6>
  80076e:	89 c0                	mov    %eax,%eax
  800770:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800777:	00 
  800778:	48 b8 b0 3e 80 00 00 	movabs $0x803eb0,%rax
  80077f:	00 00 00 
  800782:	48 01 d0             	add    %rdx,%rax
  800785:	48 8b 00             	mov    (%rax),%rax
  800788:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80078a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80078e:	eb c1                	jmp    800751 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800790:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800794:	eb bb                	jmp    800751 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800796:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80079d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007a0:	89 d0                	mov    %edx,%eax
  8007a2:	c1 e0 02             	shl    $0x2,%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	01 c0                	add    %eax,%eax
  8007a9:	01 d8                	add    %ebx,%eax
  8007ab:	83 e8 30             	sub    $0x30,%eax
  8007ae:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007b5:	0f b6 00             	movzbl (%rax),%eax
  8007b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8007be:	7e 63                	jle    800823 <vprintfmt+0x163>
  8007c0:	83 fb 39             	cmp    $0x39,%ebx
  8007c3:	7f 5e                	jg     800823 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ca:	eb d1                	jmp    80079d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8007cc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007cf:	83 f8 30             	cmp    $0x30,%eax
  8007d2:	73 17                	jae    8007eb <vprintfmt+0x12b>
  8007d4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007d8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007db:	89 c0                	mov    %eax,%eax
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007e3:	83 c2 08             	add    $0x8,%edx
  8007e6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007e9:	eb 0f                	jmp    8007fa <vprintfmt+0x13a>
  8007eb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007ef:	48 89 d0             	mov    %rdx,%rax
  8007f2:	48 83 c2 08          	add    $0x8,%rdx
  8007f6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007fa:	8b 00                	mov    (%rax),%eax
  8007fc:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007ff:	eb 23                	jmp    800824 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800801:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800805:	0f 89 42 ff ff ff    	jns    80074d <vprintfmt+0x8d>
				width = 0;
  80080b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800812:	e9 36 ff ff ff       	jmpq   80074d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800817:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80081e:	e9 2e ff ff ff       	jmpq   800751 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800823:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800824:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800828:	0f 89 22 ff ff ff    	jns    800750 <vprintfmt+0x90>
				width = precision, precision = -1;
  80082e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800831:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800834:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80083b:	e9 10 ff ff ff       	jmpq   800750 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800840:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800844:	e9 08 ff ff ff       	jmpq   800751 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800849:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80084c:	83 f8 30             	cmp    $0x30,%eax
  80084f:	73 17                	jae    800868 <vprintfmt+0x1a8>
  800851:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800855:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800858:	89 c0                	mov    %eax,%eax
  80085a:	48 01 d0             	add    %rdx,%rax
  80085d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800860:	83 c2 08             	add    $0x8,%edx
  800863:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800866:	eb 0f                	jmp    800877 <vprintfmt+0x1b7>
  800868:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80086c:	48 89 d0             	mov    %rdx,%rax
  80086f:	48 83 c2 08          	add    $0x8,%rdx
  800873:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800877:	8b 00                	mov    (%rax),%eax
  800879:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80087d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800881:	48 89 d6             	mov    %rdx,%rsi
  800884:	89 c7                	mov    %eax,%edi
  800886:	ff d1                	callq  *%rcx
			break;
  800888:	e9 47 03 00 00       	jmpq   800bd4 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  80088d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800890:	83 f8 30             	cmp    $0x30,%eax
  800893:	73 17                	jae    8008ac <vprintfmt+0x1ec>
  800895:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800899:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089c:	89 c0                	mov    %eax,%eax
  80089e:	48 01 d0             	add    %rdx,%rax
  8008a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a4:	83 c2 08             	add    $0x8,%edx
  8008a7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008aa:	eb 0f                	jmp    8008bb <vprintfmt+0x1fb>
  8008ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 83 c2 08          	add    $0x8,%rdx
  8008b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008bd:	85 db                	test   %ebx,%ebx
  8008bf:	79 02                	jns    8008c3 <vprintfmt+0x203>
				err = -err;
  8008c1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008c3:	83 fb 10             	cmp    $0x10,%ebx
  8008c6:	7f 16                	jg     8008de <vprintfmt+0x21e>
  8008c8:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  8008cf:	00 00 00 
  8008d2:	48 63 d3             	movslq %ebx,%rdx
  8008d5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008d9:	4d 85 e4             	test   %r12,%r12
  8008dc:	75 2e                	jne    80090c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8008de:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e6:	89 d9                	mov    %ebx,%ecx
  8008e8:	48 ba 99 3e 80 00 00 	movabs $0x803e99,%rdx
  8008ef:	00 00 00 
  8008f2:	48 89 c7             	mov    %rax,%rdi
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fa:	49 b8 e4 0b 80 00 00 	movabs $0x800be4,%r8
  800901:	00 00 00 
  800904:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800907:	e9 c8 02 00 00       	jmpq   800bd4 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80090c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800910:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800914:	4c 89 e1             	mov    %r12,%rcx
  800917:	48 ba a2 3e 80 00 00 	movabs $0x803ea2,%rdx
  80091e:	00 00 00 
  800921:	48 89 c7             	mov    %rax,%rdi
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
  800929:	49 b8 e4 0b 80 00 00 	movabs $0x800be4,%r8
  800930:	00 00 00 
  800933:	41 ff d0             	callq  *%r8
			break;
  800936:	e9 99 02 00 00       	jmpq   800bd4 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80093b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80093e:	83 f8 30             	cmp    $0x30,%eax
  800941:	73 17                	jae    80095a <vprintfmt+0x29a>
  800943:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800947:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094a:	89 c0                	mov    %eax,%eax
  80094c:	48 01 d0             	add    %rdx,%rax
  80094f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800952:	83 c2 08             	add    $0x8,%edx
  800955:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800958:	eb 0f                	jmp    800969 <vprintfmt+0x2a9>
  80095a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80095e:	48 89 d0             	mov    %rdx,%rax
  800961:	48 83 c2 08          	add    $0x8,%rdx
  800965:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800969:	4c 8b 20             	mov    (%rax),%r12
  80096c:	4d 85 e4             	test   %r12,%r12
  80096f:	75 0a                	jne    80097b <vprintfmt+0x2bb>
				p = "(null)";
  800971:	49 bc a5 3e 80 00 00 	movabs $0x803ea5,%r12
  800978:	00 00 00 
			if (width > 0 && padc != '-')
  80097b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097f:	7e 7a                	jle    8009fb <vprintfmt+0x33b>
  800981:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800985:	74 74                	je     8009fb <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800987:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80098a:	48 98                	cltq   
  80098c:	48 89 c6             	mov    %rax,%rsi
  80098f:	4c 89 e7             	mov    %r12,%rdi
  800992:	48 b8 8e 0e 80 00 00 	movabs $0x800e8e,%rax
  800999:	00 00 00 
  80099c:	ff d0                	callq  *%rax
  80099e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009a1:	eb 17                	jmp    8009ba <vprintfmt+0x2fa>
					putch(padc, putdat);
  8009a3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8009a7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ab:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009af:	48 89 d6             	mov    %rdx,%rsi
  8009b2:	89 c7                	mov    %eax,%edi
  8009b4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009be:	7f e3                	jg     8009a3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c0:	eb 39                	jmp    8009fb <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8009c2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009c6:	74 1e                	je     8009e6 <vprintfmt+0x326>
  8009c8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009cb:	7e 05                	jle    8009d2 <vprintfmt+0x312>
  8009cd:	83 fb 7e             	cmp    $0x7e,%ebx
  8009d0:	7e 14                	jle    8009e6 <vprintfmt+0x326>
					putch('?', putdat);
  8009d2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009d6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009da:	48 89 c6             	mov    %rax,%rsi
  8009dd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009e2:	ff d2                	callq  *%rdx
  8009e4:	eb 0f                	jmp    8009f5 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  8009e6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009ea:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009ee:	48 89 c6             	mov    %rax,%rsi
  8009f1:	89 df                	mov    %ebx,%edi
  8009f3:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009f9:	eb 01                	jmp    8009fc <vprintfmt+0x33c>
  8009fb:	90                   	nop
  8009fc:	41 0f b6 04 24       	movzbl (%r12),%eax
  800a01:	0f be d8             	movsbl %al,%ebx
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	0f 95 c0             	setne  %al
  800a09:	49 83 c4 01          	add    $0x1,%r12
  800a0d:	84 c0                	test   %al,%al
  800a0f:	74 28                	je     800a39 <vprintfmt+0x379>
  800a11:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a15:	78 ab                	js     8009c2 <vprintfmt+0x302>
  800a17:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1f:	79 a1                	jns    8009c2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a21:	eb 16                	jmp    800a39 <vprintfmt+0x379>
				putch(' ', putdat);
  800a23:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a27:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a2b:	48 89 c6             	mov    %rax,%rsi
  800a2e:	bf 20 00 00 00       	mov    $0x20,%edi
  800a33:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a35:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a39:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a3d:	7f e4                	jg     800a23 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800a3f:	e9 90 01 00 00       	jmpq   800bd4 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a48:	be 03 00 00 00       	mov    $0x3,%esi
  800a4d:	48 89 c7             	mov    %rax,%rdi
  800a50:	48 b8 b0 05 80 00 00 	movabs $0x8005b0,%rax
  800a57:	00 00 00 
  800a5a:	ff d0                	callq  *%rax
  800a5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a64:	48 85 c0             	test   %rax,%rax
  800a67:	79 1d                	jns    800a86 <vprintfmt+0x3c6>
				putch('-', putdat);
  800a69:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a6d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a71:	48 89 c6             	mov    %rax,%rsi
  800a74:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a79:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7f:	48 f7 d8             	neg    %rax
  800a82:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a86:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a8d:	e9 d5 00 00 00       	jmpq   800b67 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a92:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a96:	be 03 00 00 00       	mov    $0x3,%esi
  800a9b:	48 89 c7             	mov    %rax,%rdi
  800a9e:	48 b8 a0 04 80 00 00 	movabs $0x8004a0,%rax
  800aa5:	00 00 00 
  800aa8:	ff d0                	callq  *%rax
  800aaa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800aae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab5:	e9 ad 00 00 00       	jmpq   800b67 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800aba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abe:	be 03 00 00 00       	mov    $0x3,%esi
  800ac3:	48 89 c7             	mov    %rax,%rdi
  800ac6:	48 b8 a0 04 80 00 00 	movabs $0x8004a0,%rax
  800acd:	00 00 00 
  800ad0:	ff d0                	callq  *%rax
  800ad2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800ad6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800add:	e9 85 00 00 00       	jmpq   800b67 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800ae2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ae6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aea:	48 89 c6             	mov    %rax,%rsi
  800aed:	bf 30 00 00 00       	mov    $0x30,%edi
  800af2:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800af4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800af8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800afc:	48 89 c6             	mov    %rax,%rsi
  800aff:	bf 78 00 00 00       	mov    $0x78,%edi
  800b04:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b09:	83 f8 30             	cmp    $0x30,%eax
  800b0c:	73 17                	jae    800b25 <vprintfmt+0x465>
  800b0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b15:	89 c0                	mov    %eax,%eax
  800b17:	48 01 d0             	add    %rdx,%rax
  800b1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1d:	83 c2 08             	add    $0x8,%edx
  800b20:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b23:	eb 0f                	jmp    800b34 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800b25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b29:	48 89 d0             	mov    %rdx,%rax
  800b2c:	48 83 c2 08          	add    $0x8,%rdx
  800b30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b34:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b37:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b3b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b42:	eb 23                	jmp    800b67 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b44:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b48:	be 03 00 00 00       	mov    $0x3,%esi
  800b4d:	48 89 c7             	mov    %rax,%rdi
  800b50:	48 b8 a0 04 80 00 00 	movabs $0x8004a0,%rax
  800b57:	00 00 00 
  800b5a:	ff d0                	callq  *%rax
  800b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b60:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b67:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b6c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b6f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b76:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7e:	45 89 c1             	mov    %r8d,%r9d
  800b81:	41 89 f8             	mov    %edi,%r8d
  800b84:	48 89 c7             	mov    %rax,%rdi
  800b87:	48 b8 e8 03 80 00 00 	movabs $0x8003e8,%rax
  800b8e:	00 00 00 
  800b91:	ff d0                	callq  *%rax
			break;
  800b93:	eb 3f                	jmp    800bd4 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b95:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b99:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b9d:	48 89 c6             	mov    %rax,%rsi
  800ba0:	89 df                	mov    %ebx,%edi
  800ba2:	ff d2                	callq  *%rdx
			break;
  800ba4:	eb 2e                	jmp    800bd4 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800baa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bae:	48 89 c6             	mov    %rax,%rsi
  800bb1:	bf 25 00 00 00       	mov    $0x25,%edi
  800bb6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bbd:	eb 05                	jmp    800bc4 <vprintfmt+0x504>
  800bbf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bc8:	48 83 e8 01          	sub    $0x1,%rax
  800bcc:	0f b6 00             	movzbl (%rax),%eax
  800bcf:	3c 25                	cmp    $0x25,%al
  800bd1:	75 ec                	jne    800bbf <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800bd3:	90                   	nop
		}
	}
  800bd4:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	e9 38 fb ff ff       	jmpq   800712 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800bda:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800bdb:	48 83 c4 60          	add    $0x60,%rsp
  800bdf:	5b                   	pop    %rbx
  800be0:	41 5c                	pop    %r12
  800be2:	5d                   	pop    %rbp
  800be3:	c3                   	retq   

0000000000800be4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be4:	55                   	push   %rbp
  800be5:	48 89 e5             	mov    %rsp,%rbp
  800be8:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bef:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bf6:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bfd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c04:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c0b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c12:	84 c0                	test   %al,%al
  800c14:	74 20                	je     800c36 <printfmt+0x52>
  800c16:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c1a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c1e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c22:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c26:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c2a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c2e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c32:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c36:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c3d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c44:	00 00 00 
  800c47:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c4e:	00 00 00 
  800c51:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c55:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c5c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c63:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c6a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c71:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c78:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c7f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c86:	48 89 c7             	mov    %rax,%rdi
  800c89:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c95:	c9                   	leaveq 
  800c96:	c3                   	retq   

0000000000800c97 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c97:	55                   	push   %rbp
  800c98:	48 89 e5             	mov    %rsp,%rbp
  800c9b:	48 83 ec 10          	sub    $0x10,%rsp
  800c9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ca6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800caa:	8b 40 10             	mov    0x10(%rax),%eax
  800cad:	8d 50 01             	lea    0x1(%rax),%edx
  800cb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbb:	48 8b 10             	mov    (%rax),%rdx
  800cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cc6:	48 39 c2             	cmp    %rax,%rdx
  800cc9:	73 17                	jae    800ce2 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ccb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ccf:	48 8b 00             	mov    (%rax),%rax
  800cd2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cd5:	88 10                	mov    %dl,(%rax)
  800cd7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdf:	48 89 10             	mov    %rdx,(%rax)
}
  800ce2:	c9                   	leaveq 
  800ce3:	c3                   	retq   

0000000000800ce4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ce4:	55                   	push   %rbp
  800ce5:	48 89 e5             	mov    %rsp,%rbp
  800ce8:	48 83 ec 50          	sub    $0x50,%rsp
  800cec:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cf7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cfb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cff:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d03:	48 8b 0a             	mov    (%rdx),%rcx
  800d06:	48 89 08             	mov    %rcx,(%rax)
  800d09:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d0d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d11:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d15:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d19:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d1d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d21:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d24:	48 98                	cltq   
  800d26:	48 83 e8 01          	sub    $0x1,%rax
  800d2a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800d2e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d39:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d3e:	74 06                	je     800d46 <vsnprintf+0x62>
  800d40:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d44:	7f 07                	jg     800d4d <vsnprintf+0x69>
		return -E_INVAL;
  800d46:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4b:	eb 2f                	jmp    800d7c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d4d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d51:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d55:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d59:	48 89 c6             	mov    %rax,%rsi
  800d5c:	48 bf 97 0c 80 00 00 	movabs $0x800c97,%rdi
  800d63:	00 00 00 
  800d66:	48 b8 c0 06 80 00 00 	movabs $0x8006c0,%rax
  800d6d:	00 00 00 
  800d70:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d72:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d76:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d79:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d7c:	c9                   	leaveq 
  800d7d:	c3                   	retq   

0000000000800d7e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d7e:	55                   	push   %rbp
  800d7f:	48 89 e5             	mov    %rsp,%rbp
  800d82:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d89:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d90:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d96:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d9d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800da4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dab:	84 c0                	test   %al,%al
  800dad:	74 20                	je     800dcf <snprintf+0x51>
  800daf:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800db3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800db7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dbb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dbf:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dc3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dc7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dcb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dcf:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dd6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ddd:	00 00 00 
  800de0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800de7:	00 00 00 
  800dea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800df5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dfc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e03:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e0a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e11:	48 8b 0a             	mov    (%rdx),%rcx
  800e14:	48 89 08             	mov    %rcx,(%rax)
  800e17:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e1b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e1f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e23:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e27:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e2e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e35:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e3b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e42:	48 89 c7             	mov    %rax,%rdi
  800e45:	48 b8 e4 0c 80 00 00 	movabs $0x800ce4,%rax
  800e4c:	00 00 00 
  800e4f:	ff d0                	callq  *%rax
  800e51:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e57:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e5d:	c9                   	leaveq 
  800e5e:	c3                   	retq   
	...

0000000000800e60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e60:	55                   	push   %rbp
  800e61:	48 89 e5             	mov    %rsp,%rbp
  800e64:	48 83 ec 18          	sub    $0x18,%rsp
  800e68:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e73:	eb 09                	jmp    800e7e <strlen+0x1e>
		n++;
  800e75:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e79:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e82:	0f b6 00             	movzbl (%rax),%eax
  800e85:	84 c0                	test   %al,%al
  800e87:	75 ec                	jne    800e75 <strlen+0x15>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e8c:	c9                   	leaveq 
  800e8d:	c3                   	retq   

0000000000800e8e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e8e:	55                   	push   %rbp
  800e8f:	48 89 e5             	mov    %rsp,%rbp
  800e92:	48 83 ec 20          	sub    $0x20,%rsp
  800e96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ea5:	eb 0e                	jmp    800eb5 <strnlen+0x27>
		n++;
  800ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eab:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800eb5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800eba:	74 0b                	je     800ec7 <strnlen+0x39>
  800ebc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec0:	0f b6 00             	movzbl (%rax),%eax
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 e0                	jne    800ea7 <strnlen+0x19>
		n++;
	return n;
  800ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eca:	c9                   	leaveq 
  800ecb:	c3                   	retq   

0000000000800ecc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecc:	55                   	push   %rbp
  800ecd:	48 89 e5             	mov    %rsp,%rbp
  800ed0:	48 83 ec 20          	sub    $0x20,%rsp
  800ed4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ee4:	90                   	nop
  800ee5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ee9:	0f b6 10             	movzbl (%rax),%edx
  800eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef0:	88 10                	mov    %dl,(%rax)
  800ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef6:	0f b6 00             	movzbl (%rax),%eax
  800ef9:	84 c0                	test   %al,%al
  800efb:	0f 95 c0             	setne  %al
  800efe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f03:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 d9                	jne    800ee5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f10:	c9                   	leaveq 
  800f11:	c3                   	retq   

0000000000800f12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f12:	55                   	push   %rbp
  800f13:	48 89 e5             	mov    %rsp,%rbp
  800f16:	48 83 ec 20          	sub    $0x20,%rsp
  800f1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f1e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
  800f35:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f3b:	48 98                	cltq   
  800f3d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800f41:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f45:	48 89 d6             	mov    %rdx,%rsi
  800f48:	48 89 c7             	mov    %rax,%rdi
  800f4b:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  800f52:	00 00 00 
  800f55:	ff d0                	callq  *%rax
	return dst;
  800f57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f5b:	c9                   	leaveq 
  800f5c:	c3                   	retq   

0000000000800f5d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f5d:	55                   	push   %rbp
  800f5e:	48 89 e5             	mov    %rsp,%rbp
  800f61:	48 83 ec 28          	sub    $0x28,%rsp
  800f65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f75:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f79:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f80:	00 
  800f81:	eb 27                	jmp    800faa <strncpy+0x4d>
		*dst++ = *src;
  800f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f87:	0f b6 10             	movzbl (%rax),%edx
  800f8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f8e:	88 10                	mov    %dl,(%rax)
  800f90:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f95:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f99:	0f b6 00             	movzbl (%rax),%eax
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 05                	je     800fa5 <strncpy+0x48>
			src++;
  800fa0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fa5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800faa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fae:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fb2:	72 cf                	jb     800f83 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fb8:	c9                   	leaveq 
  800fb9:	c3                   	retq   

0000000000800fba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fba:	55                   	push   %rbp
  800fbb:	48 89 e5             	mov    %rsp,%rbp
  800fbe:	48 83 ec 28          	sub    $0x28,%rsp
  800fc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fd6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fdb:	74 37                	je     801014 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  800fdd:	eb 17                	jmp    800ff6 <strlcpy+0x3c>
			*dst++ = *src++;
  800fdf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fe3:	0f b6 10             	movzbl (%rax),%edx
  800fe6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fea:	88 10                	mov    %dl,(%rax)
  800fec:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ff1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ff6:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800ffb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801000:	74 0b                	je     80100d <strlcpy+0x53>
  801002:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801006:	0f b6 00             	movzbl (%rax),%eax
  801009:	84 c0                	test   %al,%al
  80100b:	75 d2                	jne    800fdf <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80100d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801011:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801014:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101c:	48 89 d1             	mov    %rdx,%rcx
  80101f:	48 29 c1             	sub    %rax,%rcx
  801022:	48 89 c8             	mov    %rcx,%rax
}
  801025:	c9                   	leaveq 
  801026:	c3                   	retq   

0000000000801027 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 83 ec 10          	sub    $0x10,%rsp
  80102f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801033:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801037:	eb 0a                	jmp    801043 <strcmp+0x1c>
		p++, q++;
  801039:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80103e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801047:	0f b6 00             	movzbl (%rax),%eax
  80104a:	84 c0                	test   %al,%al
  80104c:	74 12                	je     801060 <strcmp+0x39>
  80104e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801052:	0f b6 10             	movzbl (%rax),%edx
  801055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801059:	0f b6 00             	movzbl (%rax),%eax
  80105c:	38 c2                	cmp    %al,%dl
  80105e:	74 d9                	je     801039 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801064:	0f b6 00             	movzbl (%rax),%eax
  801067:	0f b6 d0             	movzbl %al,%edx
  80106a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	0f b6 c0             	movzbl %al,%eax
  801074:	89 d1                	mov    %edx,%ecx
  801076:	29 c1                	sub    %eax,%ecx
  801078:	89 c8                	mov    %ecx,%eax
}
  80107a:	c9                   	leaveq 
  80107b:	c3                   	retq   

000000000080107c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80107c:	55                   	push   %rbp
  80107d:	48 89 e5             	mov    %rsp,%rbp
  801080:	48 83 ec 18          	sub    $0x18,%rsp
  801084:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801088:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80108c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801090:	eb 0f                	jmp    8010a1 <strncmp+0x25>
		n--, p++, q++;
  801092:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801097:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010a6:	74 1d                	je     8010c5 <strncmp+0x49>
  8010a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ac:	0f b6 00             	movzbl (%rax),%eax
  8010af:	84 c0                	test   %al,%al
  8010b1:	74 12                	je     8010c5 <strncmp+0x49>
  8010b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b7:	0f b6 10             	movzbl (%rax),%edx
  8010ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010be:	0f b6 00             	movzbl (%rax),%eax
  8010c1:	38 c2                	cmp    %al,%dl
  8010c3:	74 cd                	je     801092 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ca:	75 07                	jne    8010d3 <strncmp+0x57>
		return 0;
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d1:	eb 1a                	jmp    8010ed <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d7:	0f b6 00             	movzbl (%rax),%eax
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e1:	0f b6 00             	movzbl (%rax),%eax
  8010e4:	0f b6 c0             	movzbl %al,%eax
  8010e7:	89 d1                	mov    %edx,%ecx
  8010e9:	29 c1                	sub    %eax,%ecx
  8010eb:	89 c8                	mov    %ecx,%eax
}
  8010ed:	c9                   	leaveq 
  8010ee:	c3                   	retq   

00000000008010ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010ef:	55                   	push   %rbp
  8010f0:	48 89 e5             	mov    %rsp,%rbp
  8010f3:	48 83 ec 10          	sub    $0x10,%rsp
  8010f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010fb:	89 f0                	mov    %esi,%eax
  8010fd:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801100:	eb 17                	jmp    801119 <strchr+0x2a>
		if (*s == c)
  801102:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801106:	0f b6 00             	movzbl (%rax),%eax
  801109:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80110c:	75 06                	jne    801114 <strchr+0x25>
			return (char *) s;
  80110e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801112:	eb 15                	jmp    801129 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801114:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111d:	0f b6 00             	movzbl (%rax),%eax
  801120:	84 c0                	test   %al,%al
  801122:	75 de                	jne    801102 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801124:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801129:	c9                   	leaveq 
  80112a:	c3                   	retq   

000000000080112b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80112b:	55                   	push   %rbp
  80112c:	48 89 e5             	mov    %rsp,%rbp
  80112f:	48 83 ec 10          	sub    $0x10,%rsp
  801133:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801137:	89 f0                	mov    %esi,%eax
  801139:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80113c:	eb 11                	jmp    80114f <strfind+0x24>
		if (*s == c)
  80113e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801142:	0f b6 00             	movzbl (%rax),%eax
  801145:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801148:	74 12                	je     80115c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80114a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801153:	0f b6 00             	movzbl (%rax),%eax
  801156:	84 c0                	test   %al,%al
  801158:	75 e4                	jne    80113e <strfind+0x13>
  80115a:	eb 01                	jmp    80115d <strfind+0x32>
		if (*s == c)
			break;
  80115c:	90                   	nop
	return (char *) s;
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801161:	c9                   	leaveq 
  801162:	c3                   	retq   

0000000000801163 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801163:	55                   	push   %rbp
  801164:	48 89 e5             	mov    %rsp,%rbp
  801167:	48 83 ec 18          	sub    $0x18,%rsp
  80116b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801172:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801176:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80117b:	75 06                	jne    801183 <memset+0x20>
		return v;
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	eb 69                	jmp    8011ec <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801187:	83 e0 03             	and    $0x3,%eax
  80118a:	48 85 c0             	test   %rax,%rax
  80118d:	75 48                	jne    8011d7 <memset+0x74>
  80118f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801193:	83 e0 03             	and    $0x3,%eax
  801196:	48 85 c0             	test   %rax,%rax
  801199:	75 3c                	jne    8011d7 <memset+0x74>
		c &= 0xFF;
  80119b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011a2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a5:	89 c2                	mov    %eax,%edx
  8011a7:	c1 e2 18             	shl    $0x18,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011ad:	c1 e0 10             	shl    $0x10,%eax
  8011b0:	09 c2                	or     %eax,%edx
  8011b2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b5:	c1 e0 08             	shl    $0x8,%eax
  8011b8:	09 d0                	or     %edx,%eax
  8011ba:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c1:	48 89 c1             	mov    %rax,%rcx
  8011c4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011cc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011cf:	48 89 d7             	mov    %rdx,%rdi
  8011d2:	fc                   	cld    
  8011d3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011d5:	eb 11                	jmp    8011e8 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011d7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011de:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011e2:	48 89 d7             	mov    %rdx,%rdi
  8011e5:	fc                   	cld    
  8011e6:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 28          	sub    $0x28,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801202:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801206:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801212:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801216:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80121a:	0f 83 88 00 00 00    	jae    8012a8 <memmove+0xba>
  801220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801224:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801228:	48 01 d0             	add    %rdx,%rax
  80122b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80122f:	76 77                	jbe    8012a8 <memmove+0xba>
		s += n;
  801231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801235:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801239:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801245:	83 e0 03             	and    $0x3,%eax
  801248:	48 85 c0             	test   %rax,%rax
  80124b:	75 3b                	jne    801288 <memmove+0x9a>
  80124d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801251:	83 e0 03             	and    $0x3,%eax
  801254:	48 85 c0             	test   %rax,%rax
  801257:	75 2f                	jne    801288 <memmove+0x9a>
  801259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125d:	83 e0 03             	and    $0x3,%eax
  801260:	48 85 c0             	test   %rax,%rax
  801263:	75 23                	jne    801288 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801265:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801269:	48 83 e8 04          	sub    $0x4,%rax
  80126d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801271:	48 83 ea 04          	sub    $0x4,%rdx
  801275:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801279:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80127d:	48 89 c7             	mov    %rax,%rdi
  801280:	48 89 d6             	mov    %rdx,%rsi
  801283:	fd                   	std    
  801284:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801286:	eb 1d                	jmp    8012a5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801298:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80129c:	48 89 d7             	mov    %rdx,%rdi
  80129f:	48 89 c1             	mov    %rax,%rcx
  8012a2:	fd                   	std    
  8012a3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012a5:	fc                   	cld    
  8012a6:	eb 57                	jmp    8012ff <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ac:	83 e0 03             	and    $0x3,%eax
  8012af:	48 85 c0             	test   %rax,%rax
  8012b2:	75 36                	jne    8012ea <memmove+0xfc>
  8012b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b8:	83 e0 03             	and    $0x3,%eax
  8012bb:	48 85 c0             	test   %rax,%rax
  8012be:	75 2a                	jne    8012ea <memmove+0xfc>
  8012c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c4:	83 e0 03             	and    $0x3,%eax
  8012c7:	48 85 c0             	test   %rax,%rax
  8012ca:	75 1e                	jne    8012ea <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d0:	48 89 c1             	mov    %rax,%rcx
  8012d3:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012df:	48 89 c7             	mov    %rax,%rdi
  8012e2:	48 89 d6             	mov    %rdx,%rsi
  8012e5:	fc                   	cld    
  8012e6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012e8:	eb 15                	jmp    8012ff <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012f6:	48 89 c7             	mov    %rax,%rdi
  8012f9:	48 89 d6             	mov    %rdx,%rsi
  8012fc:	fc                   	cld    
  8012fd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801303:	c9                   	leaveq 
  801304:	c3                   	retq   

0000000000801305 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801305:	55                   	push   %rbp
  801306:	48 89 e5             	mov    %rsp,%rbp
  801309:	48 83 ec 18          	sub    $0x18,%rsp
  80130d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801311:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801315:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801319:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80131d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801321:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801325:	48 89 ce             	mov    %rcx,%rsi
  801328:	48 89 c7             	mov    %rax,%rdi
  80132b:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  801332:	00 00 00 
  801335:	ff d0                	callq  *%rax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 28          	sub    $0x28,%rsp
  801341:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801349:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80134d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801351:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801355:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801359:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80135d:	eb 38                	jmp    801397 <memcmp+0x5e>
		if (*s1 != *s2)
  80135f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801363:	0f b6 10             	movzbl (%rax),%edx
  801366:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	38 c2                	cmp    %al,%dl
  80136f:	74 1c                	je     80138d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	0f b6 d0             	movzbl %al,%edx
  80137b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137f:	0f b6 00             	movzbl (%rax),%eax
  801382:	0f b6 c0             	movzbl %al,%eax
  801385:	89 d1                	mov    %edx,%ecx
  801387:	29 c1                	sub    %eax,%ecx
  801389:	89 c8                	mov    %ecx,%eax
  80138b:	eb 20                	jmp    8013ad <memcmp+0x74>
		s1++, s2++;
  80138d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801392:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801397:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80139c:	0f 95 c0             	setne  %al
  80139f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013a4:	84 c0                	test   %al,%al
  8013a6:	75 b7                	jne    80135f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ad:	c9                   	leaveq 
  8013ae:	c3                   	retq   

00000000008013af <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013af:	55                   	push   %rbp
  8013b0:	48 89 e5             	mov    %rsp,%rbp
  8013b3:	48 83 ec 28          	sub    $0x28,%rsp
  8013b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013bb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013ca:	48 01 d0             	add    %rdx,%rax
  8013cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d1:	eb 13                	jmp    8013e6 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d7:	0f b6 10             	movzbl (%rax),%edx
  8013da:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013dd:	38 c2                	cmp    %al,%dl
  8013df:	74 11                	je     8013f2 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013e1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ea:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013ee:	72 e3                	jb     8013d3 <memfind+0x24>
  8013f0:	eb 01                	jmp    8013f3 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013f2:	90                   	nop
	return (void *) s;
  8013f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013f7:	c9                   	leaveq 
  8013f8:	c3                   	retq   

00000000008013f9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013f9:	55                   	push   %rbp
  8013fa:	48 89 e5             	mov    %rsp,%rbp
  8013fd:	48 83 ec 38          	sub    $0x38,%rsp
  801401:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801405:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801409:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80140c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801413:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80141a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80141b:	eb 05                	jmp    801422 <strtol+0x29>
		s++;
  80141d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3c 20                	cmp    $0x20,%al
  80142b:	74 f0                	je     80141d <strtol+0x24>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	3c 09                	cmp    $0x9,%al
  801436:	74 e5                	je     80141d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	3c 2b                	cmp    $0x2b,%al
  801441:	75 07                	jne    80144a <strtol+0x51>
		s++;
  801443:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801448:	eb 17                	jmp    801461 <strtol+0x68>
	else if (*s == '-')
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3c 2d                	cmp    $0x2d,%al
  801453:	75 0c                	jne    801461 <strtol+0x68>
		s++, neg = 1;
  801455:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80145a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801461:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801465:	74 06                	je     80146d <strtol+0x74>
  801467:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80146b:	75 28                	jne    801495 <strtol+0x9c>
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	0f b6 00             	movzbl (%rax),%eax
  801474:	3c 30                	cmp    $0x30,%al
  801476:	75 1d                	jne    801495 <strtol+0x9c>
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	48 83 c0 01          	add    $0x1,%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	3c 78                	cmp    $0x78,%al
  801485:	75 0e                	jne    801495 <strtol+0x9c>
		s += 2, base = 16;
  801487:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80148c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801493:	eb 2c                	jmp    8014c1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801495:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801499:	75 19                	jne    8014b4 <strtol+0xbb>
  80149b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	3c 30                	cmp    $0x30,%al
  8014a4:	75 0e                	jne    8014b4 <strtol+0xbb>
		s++, base = 8;
  8014a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ab:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b2:	eb 0d                	jmp    8014c1 <strtol+0xc8>
	else if (base == 0)
  8014b4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b8:	75 07                	jne    8014c1 <strtol+0xc8>
		base = 10;
  8014ba:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c5:	0f b6 00             	movzbl (%rax),%eax
  8014c8:	3c 2f                	cmp    $0x2f,%al
  8014ca:	7e 1d                	jle    8014e9 <strtol+0xf0>
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	0f b6 00             	movzbl (%rax),%eax
  8014d3:	3c 39                	cmp    $0x39,%al
  8014d5:	7f 12                	jg     8014e9 <strtol+0xf0>
			dig = *s - '0';
  8014d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	0f be c0             	movsbl %al,%eax
  8014e1:	83 e8 30             	sub    $0x30,%eax
  8014e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e7:	eb 4e                	jmp    801537 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	3c 60                	cmp    $0x60,%al
  8014f2:	7e 1d                	jle    801511 <strtol+0x118>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	3c 7a                	cmp    $0x7a,%al
  8014fd:	7f 12                	jg     801511 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	0f be c0             	movsbl %al,%eax
  801509:	83 e8 57             	sub    $0x57,%eax
  80150c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80150f:	eb 26                	jmp    801537 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801511:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	3c 40                	cmp    $0x40,%al
  80151a:	7e 47                	jle    801563 <strtol+0x16a>
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	0f b6 00             	movzbl (%rax),%eax
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 3c                	jg     801563 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801527:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f be c0             	movsbl %al,%eax
  801531:	83 e8 37             	sub    $0x37,%eax
  801534:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801537:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80153a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80153d:	7d 23                	jge    801562 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80153f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801544:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801547:	48 98                	cltq   
  801549:	48 89 c2             	mov    %rax,%rdx
  80154c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801551:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801554:	48 98                	cltq   
  801556:	48 01 d0             	add    %rdx,%rax
  801559:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80155d:	e9 5f ff ff ff       	jmpq   8014c1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801562:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801563:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801568:	74 0b                	je     801575 <strtol+0x17c>
		*endptr = (char *) s;
  80156a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80156e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801572:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801575:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801579:	74 09                	je     801584 <strtol+0x18b>
  80157b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157f:	48 f7 d8             	neg    %rax
  801582:	eb 04                	jmp    801588 <strtol+0x18f>
  801584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801588:	c9                   	leaveq 
  801589:	c3                   	retq   

000000000080158a <strstr>:

char * strstr(const char *in, const char *str)
{
  80158a:	55                   	push   %rbp
  80158b:	48 89 e5             	mov    %rsp,%rbp
  80158e:	48 83 ec 30          	sub    $0x30,%rsp
  801592:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801596:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80159a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	88 45 ff             	mov    %al,-0x1(%rbp)
  8015a4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8015a9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015ad:	75 06                	jne    8015b5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8015af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b3:	eb 68                	jmp    80161d <strstr+0x93>

    len = strlen(str);
  8015b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015b9:	48 89 c7             	mov    %rax,%rdi
  8015bc:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  8015c3:	00 00 00 
  8015c6:	ff d0                	callq  *%rax
  8015c8:	48 98                	cltq   
  8015ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	88 45 ef             	mov    %al,-0x11(%rbp)
  8015d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8015dd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015e1:	75 07                	jne    8015ea <strstr+0x60>
                return (char *) 0;
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e8:	eb 33                	jmp    80161d <strstr+0x93>
        } while (sc != c);
  8015ea:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015ee:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015f1:	75 db                	jne    8015ce <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8015f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015f7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	48 89 ce             	mov    %rcx,%rsi
  801602:	48 89 c7             	mov    %rax,%rdi
  801605:	48 b8 7c 10 80 00 00 	movabs $0x80107c,%rax
  80160c:	00 00 00 
  80160f:	ff d0                	callq  *%rax
  801611:	85 c0                	test   %eax,%eax
  801613:	75 b9                	jne    8015ce <strstr+0x44>

    return (char *) (in - 1);
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	48 83 e8 01          	sub    $0x1,%rax
}
  80161d:	c9                   	leaveq 
  80161e:	c3                   	retq   
	...

0000000000801620 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801620:	55                   	push   %rbp
  801621:	48 89 e5             	mov    %rsp,%rbp
  801624:	53                   	push   %rbx
  801625:	48 83 ec 58          	sub    $0x58,%rsp
  801629:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80162c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80162f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801633:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801637:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80163b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801642:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801645:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801649:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80164d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801651:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801655:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801659:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80165c:	4c 89 c3             	mov    %r8,%rbx
  80165f:	cd 30                	int    $0x30
  801661:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801665:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801669:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80166d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801671:	74 3e                	je     8016b1 <syscall+0x91>
  801673:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801678:	7e 37                	jle    8016b1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80167a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801681:	49 89 d0             	mov    %rdx,%r8
  801684:	89 c1                	mov    %eax,%ecx
  801686:	48 ba 60 41 80 00 00 	movabs $0x804160,%rdx
  80168d:	00 00 00 
  801690:	be 23 00 00 00       	mov    $0x23,%esi
  801695:	48 bf 7d 41 80 00 00 	movabs $0x80417d,%rdi
  80169c:	00 00 00 
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	49 b9 dc 3a 80 00 00 	movabs $0x803adc,%r9
  8016ab:	00 00 00 
  8016ae:	41 ff d1             	callq  *%r9

	return ret;
  8016b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b5:	48 83 c4 58          	add    $0x58,%rsp
  8016b9:	5b                   	pop    %rbx
  8016ba:	5d                   	pop    %rbp
  8016bb:	c3                   	retq   

00000000008016bc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016bc:	55                   	push   %rbp
  8016bd:	48 89 e5             	mov    %rsp,%rbp
  8016c0:	48 83 ec 20          	sub    $0x20,%rsp
  8016c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016db:	00 
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	48 89 d1             	mov    %rdx,%rcx
  8016eb:	48 89 c2             	mov    %rax,%rdx
  8016ee:	be 00 00 00 00       	mov    $0x0,%esi
  8016f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f8:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8016ff:	00 00 00 
  801702:	ff d0                	callq  *%rax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <sys_cgetc>:

int
sys_cgetc(void)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80170e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801715:	00 
  801716:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801722:	b9 00 00 00 00       	mov    $0x0,%ecx
  801727:	ba 00 00 00 00       	mov    $0x0,%edx
  80172c:	be 00 00 00 00       	mov    $0x0,%esi
  801731:	bf 01 00 00 00       	mov    $0x1,%edi
  801736:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
}
  801742:	c9                   	leaveq 
  801743:	c3                   	retq   

0000000000801744 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801744:	55                   	push   %rbp
  801745:	48 89 e5             	mov    %rsp,%rbp
  801748:	48 83 ec 20          	sub    $0x20,%rsp
  80174c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801752:	48 98                	cltq   
  801754:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80175b:	00 
  80175c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801762:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801768:	b9 00 00 00 00       	mov    $0x0,%ecx
  80176d:	48 89 c2             	mov    %rax,%rdx
  801770:	be 01 00 00 00       	mov    $0x1,%esi
  801775:	bf 03 00 00 00       	mov    $0x3,%edi
  80177a:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801790:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801797:	00 
  801798:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	be 00 00 00 00       	mov    $0x0,%esi
  8017b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b8:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8017bf:	00 00 00 
  8017c2:	ff d0                	callq  *%rax
}
  8017c4:	c9                   	leaveq 
  8017c5:	c3                   	retq   

00000000008017c6 <sys_yield>:

void
sys_yield(void)
{
  8017c6:	55                   	push   %rbp
  8017c7:	48 89 e5             	mov    %rsp,%rbp
  8017ca:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d5:	00 
  8017d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	be 00 00 00 00       	mov    $0x0,%esi
  8017f1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f6:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 20          	sub    $0x20,%rsp
  80180c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801813:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801816:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801819:	48 63 c8             	movslq %eax,%rcx
  80181c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801823:	48 98                	cltq   
  801825:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182c:	00 
  80182d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801833:	49 89 c8             	mov    %rcx,%r8
  801836:	48 89 d1             	mov    %rdx,%rcx
  801839:	48 89 c2             	mov    %rax,%rdx
  80183c:	be 01 00 00 00       	mov    $0x1,%esi
  801841:	bf 04 00 00 00       	mov    $0x4,%edi
  801846:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  80184d:	00 00 00 
  801850:	ff d0                	callq  *%rax
}
  801852:	c9                   	leaveq 
  801853:	c3                   	retq   

0000000000801854 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	48 83 ec 30          	sub    $0x30,%rsp
  80185c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801863:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801866:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80186a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80186e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801871:	48 63 c8             	movslq %eax,%rcx
  801874:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801878:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187b:	48 63 f0             	movslq %eax,%rsi
  80187e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801885:	48 98                	cltq   
  801887:	48 89 0c 24          	mov    %rcx,(%rsp)
  80188b:	49 89 f9             	mov    %rdi,%r9
  80188e:	49 89 f0             	mov    %rsi,%r8
  801891:	48 89 d1             	mov    %rdx,%rcx
  801894:	48 89 c2             	mov    %rax,%rdx
  801897:	be 01 00 00 00       	mov    $0x1,%esi
  80189c:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a1:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	callq  *%rax
}
  8018ad:	c9                   	leaveq 
  8018ae:	c3                   	retq   

00000000008018af <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 20          	sub    $0x20,%rsp
  8018b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c5:	48 98                	cltq   
  8018c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ce:	00 
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	48 89 d1             	mov    %rdx,%rcx
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	be 01 00 00 00       	mov    $0x1,%esi
  8018e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8018eb:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 83 ec 20          	sub    $0x20,%rsp
  801901:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801904:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801907:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80190a:	48 63 d0             	movslq %eax,%rdx
  80190d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801910:	48 98                	cltq   
  801912:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801919:	00 
  80191a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801920:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801926:	48 89 d1             	mov    %rdx,%rcx
  801929:	48 89 c2             	mov    %rax,%rdx
  80192c:	be 01 00 00 00       	mov    $0x1,%esi
  801931:	bf 08 00 00 00       	mov    $0x8,%edi
  801936:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  80193d:	00 00 00 
  801940:	ff d0                	callq  *%rax
}
  801942:	c9                   	leaveq 
  801943:	c3                   	retq   

0000000000801944 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 20          	sub    $0x20,%rsp
  80194c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801953:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195a:	48 98                	cltq   
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	48 89 d1             	mov    %rdx,%rcx
  801973:	48 89 c2             	mov    %rax,%rdx
  801976:	be 01 00 00 00       	mov    $0x1,%esi
  80197b:	bf 09 00 00 00       	mov    $0x9,%edi
  801980:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 20          	sub    $0x20,%rsp
  801996:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801999:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80199d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a4:	48 98                	cltq   
  8019a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ad:	00 
  8019ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ba:	48 89 d1             	mov    %rdx,%rcx
  8019bd:	48 89 c2             	mov    %rax,%rdx
  8019c0:	be 01 00 00 00       	mov    $0x1,%esi
  8019c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019ca:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
}
  8019d6:	c9                   	leaveq 
  8019d7:	c3                   	retq   

00000000008019d8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d8:	55                   	push   %rbp
  8019d9:	48 89 e5             	mov    %rsp,%rbp
  8019dc:	48 83 ec 30          	sub    $0x30,%rsp
  8019e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019eb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f1:	48 63 f0             	movslq %eax,%rsi
  8019f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a08:	00 
  801a09:	49 89 f1             	mov    %rsi,%r9
  801a0c:	49 89 c8             	mov    %rcx,%r8
  801a0f:	48 89 d1             	mov    %rdx,%rcx
  801a12:	48 89 c2             	mov    %rax,%rdx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a1f:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 20          	sub    $0x20,%rsp
  801a35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a44:	00 
  801a45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a51:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a56:	48 89 c2             	mov    %rax,%rdx
  801a59:	be 01 00 00 00       	mov    $0x1,%esi
  801a5e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a63:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801a6a:	00 00 00 
  801a6d:	ff d0                	callq  *%rax
}
  801a6f:	c9                   	leaveq 
  801a70:	c3                   	retq   

0000000000801a71 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801a71:	55                   	push   %rbp
  801a72:	48 89 e5             	mov    %rsp,%rbp
  801a75:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801a79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a80:	00 
  801a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
  801a97:	be 00 00 00 00       	mov    $0x0,%esi
  801a9c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801aa1:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801aa8:	00 00 00 
  801aab:	ff d0                	callq  *%rax
}
  801aad:	c9                   	leaveq 
  801aae:	c3                   	retq   

0000000000801aaf <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801aaf:	55                   	push   %rbp
  801ab0:	48 89 e5             	mov    %rsp,%rbp
  801ab3:	48 83 ec 20          	sub    $0x20,%rsp
  801ab7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801abb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ace:	00 
  801acf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adb:	48 89 d1             	mov    %rdx,%rcx
  801ade:	48 89 c2             	mov    %rax,%rdx
  801ae1:	be 00 00 00 00       	mov    $0x0,%esi
  801ae6:	bf 0f 00 00 00       	mov    $0xf,%edi
  801aeb:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801af2:	00 00 00 
  801af5:	ff d0                	callq  *%rax
}
  801af7:	c9                   	leaveq 
  801af8:	c3                   	retq   

0000000000801af9 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801af9:	55                   	push   %rbp
  801afa:	48 89 e5             	mov    %rsp,%rbp
  801afd:	48 83 ec 20          	sub    $0x20,%rsp
  801b01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b11:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b18:	00 
  801b19:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b25:	48 89 d1             	mov    %rdx,%rcx
  801b28:	48 89 c2             	mov    %rax,%rdx
  801b2b:	be 00 00 00 00       	mov    $0x0,%esi
  801b30:	bf 10 00 00 00       	mov    $0x10,%edi
  801b35:	48 b8 20 16 80 00 00 	movabs $0x801620,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	callq  *%rax
}
  801b41:	c9                   	leaveq 
  801b42:	c3                   	retq   
	...

0000000000801b44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b44:	55                   	push   %rbp
  801b45:	48 89 e5             	mov    %rsp,%rbp
  801b48:	48 83 ec 30          	sub    $0x30,%rsp
  801b4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b54:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  801b58:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b5d:	74 18                	je     801b77 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  801b5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b63:	48 89 c7             	mov    %rax,%rdi
  801b66:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  801b6d:	00 00 00 
  801b70:	ff d0                	callq  *%rax
  801b72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b75:	eb 19                	jmp    801b90 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  801b77:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  801b7e:	00 00 00 
  801b81:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax
  801b8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  801b90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b94:	79 19                	jns    801baf <ipc_recv+0x6b>
	{
		*from_env_store=0;
  801b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  801ba0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  801baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bad:	eb 53                	jmp    801c02 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  801baf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bb4:	74 19                	je     801bcf <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  801bb6:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801bbd:	00 00 00 
  801bc0:	48 8b 00             	mov    (%rax),%rax
  801bc3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  801bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bcd:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  801bcf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bd4:	74 19                	je     801bef <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  801bd6:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801bdd:	00 00 00 
  801be0:	48 8b 00             	mov    (%rax),%rax
  801be3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  801be9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bed:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  801bef:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801bf6:	00 00 00 
  801bf9:	48 8b 00             	mov    (%rax),%rax
  801bfc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  801c02:	c9                   	leaveq 
  801c03:	c3                   	retq   

0000000000801c04 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c04:	55                   	push   %rbp
  801c05:	48 89 e5             	mov    %rsp,%rbp
  801c08:	48 83 ec 30          	sub    $0x30,%rsp
  801c0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c0f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801c12:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801c16:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  801c19:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  801c20:	e9 96 00 00 00       	jmpq   801cbb <ipc_send+0xb7>
	{
		if(pg!=NULL)
  801c25:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801c2a:	74 20                	je     801c4c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  801c2c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801c2f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c32:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c39:	89 c7                	mov    %eax,%edi
  801c3b:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801c42:	00 00 00 
  801c45:	ff d0                	callq  *%rax
  801c47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c4a:	eb 2d                	jmp    801c79 <ipc_send+0x75>
		else if(pg==NULL)
  801c4c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801c51:	75 26                	jne    801c79 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  801c53:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801c56:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801c65:	00 00 00 
  801c68:	89 c7                	mov    %eax,%edi
  801c6a:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  801c71:	00 00 00 
  801c74:	ff d0                	callq  *%rax
  801c76:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  801c79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c7d:	79 30                	jns    801caf <ipc_send+0xab>
  801c7f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801c83:	74 2a                	je     801caf <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  801c85:	48 ba 8b 41 80 00 00 	movabs $0x80418b,%rdx
  801c8c:	00 00 00 
  801c8f:	be 40 00 00 00       	mov    $0x40,%esi
  801c94:	48 bf a3 41 80 00 00 	movabs $0x8041a3,%rdi
  801c9b:	00 00 00 
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca3:	48 b9 dc 3a 80 00 00 	movabs $0x803adc,%rcx
  801caa:	00 00 00 
  801cad:	ff d1                	callq  *%rcx
		}
		sys_yield();
  801caf:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  801cb6:	00 00 00 
  801cb9:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  801cbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cbf:	0f 85 60 ff ff ff    	jne    801c25 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  801cc5:	c9                   	leaveq 
  801cc6:	c3                   	retq   

0000000000801cc7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cc7:	55                   	push   %rbp
  801cc8:	48 89 e5             	mov    %rsp,%rbp
  801ccb:	48 83 ec 18          	sub    $0x18,%rsp
  801ccf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  801cd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cd9:	eb 5e                	jmp    801d39 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801cdb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801ce2:	00 00 00 
  801ce5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce8:	48 63 d0             	movslq %eax,%rdx
  801ceb:	48 89 d0             	mov    %rdx,%rax
  801cee:	48 c1 e0 03          	shl    $0x3,%rax
  801cf2:	48 01 d0             	add    %rdx,%rax
  801cf5:	48 c1 e0 05          	shl    $0x5,%rax
  801cf9:	48 01 c8             	add    %rcx,%rax
  801cfc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801d02:	8b 00                	mov    (%rax),%eax
  801d04:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d07:	75 2c                	jne    801d35 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801d09:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801d10:	00 00 00 
  801d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d16:	48 63 d0             	movslq %eax,%rdx
  801d19:	48 89 d0             	mov    %rdx,%rax
  801d1c:	48 c1 e0 03          	shl    $0x3,%rax
  801d20:	48 01 d0             	add    %rdx,%rax
  801d23:	48 c1 e0 05          	shl    $0x5,%rax
  801d27:	48 01 c8             	add    %rcx,%rax
  801d2a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801d30:	8b 40 08             	mov    0x8(%rax),%eax
  801d33:	eb 12                	jmp    801d47 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d39:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801d40:	7e 99                	jle    801cdb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leaveq 
  801d48:	c3                   	retq   
  801d49:	00 00                	add    %al,(%rax)
	...

0000000000801d4c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d4c:	55                   	push   %rbp
  801d4d:	48 89 e5             	mov    %rsp,%rbp
  801d50:	48 83 ec 08          	sub    $0x8,%rsp
  801d54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d58:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d5c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d63:	ff ff ff 
  801d66:	48 01 d0             	add    %rdx,%rax
  801d69:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d6d:	c9                   	leaveq 
  801d6e:	c3                   	retq   

0000000000801d6f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d6f:	55                   	push   %rbp
  801d70:	48 89 e5             	mov    %rsp,%rbp
  801d73:	48 83 ec 08          	sub    $0x8,%rsp
  801d77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7f:	48 89 c7             	mov    %rax,%rdi
  801d82:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  801d89:	00 00 00 
  801d8c:	ff d0                	callq  *%rax
  801d8e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d94:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 18          	sub    $0x18,%rsp
  801da2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dad:	eb 6b                	jmp    801e1a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801db2:	48 98                	cltq   
  801db4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dba:	48 c1 e0 0c          	shl    $0xc,%rax
  801dbe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dc6:	48 89 c2             	mov    %rax,%rdx
  801dc9:	48 c1 ea 15          	shr    $0x15,%rdx
  801dcd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dd4:	01 00 00 
  801dd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ddb:	83 e0 01             	and    $0x1,%eax
  801dde:	48 85 c0             	test   %rax,%rax
  801de1:	74 21                	je     801e04 <fd_alloc+0x6a>
  801de3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de7:	48 89 c2             	mov    %rax,%rdx
  801dea:	48 c1 ea 0c          	shr    $0xc,%rdx
  801dee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801df5:	01 00 00 
  801df8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dfc:	83 e0 01             	and    $0x1,%eax
  801dff:	48 85 c0             	test   %rax,%rax
  801e02:	75 12                	jne    801e16 <fd_alloc+0x7c>
			*fd_store = fd;
  801e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e08:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	eb 1a                	jmp    801e30 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e16:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e1a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e1e:	7e 8f                	jle    801daf <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e24:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e2b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 20          	sub    $0x20,%rsp
  801e3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e41:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e45:	78 06                	js     801e4d <fd_lookup+0x1b>
  801e47:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e4b:	7e 07                	jle    801e54 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e52:	eb 6c                	jmp    801ec0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e57:	48 98                	cltq   
  801e59:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e5f:	48 c1 e0 0c          	shl    $0xc,%rax
  801e63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e6b:	48 89 c2             	mov    %rax,%rdx
  801e6e:	48 c1 ea 15          	shr    $0x15,%rdx
  801e72:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e79:	01 00 00 
  801e7c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e80:	83 e0 01             	and    $0x1,%eax
  801e83:	48 85 c0             	test   %rax,%rax
  801e86:	74 21                	je     801ea9 <fd_lookup+0x77>
  801e88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e8c:	48 89 c2             	mov    %rax,%rdx
  801e8f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e9a:	01 00 00 
  801e9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea1:	83 e0 01             	and    $0x1,%eax
  801ea4:	48 85 c0             	test   %rax,%rax
  801ea7:	75 07                	jne    801eb0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eae:	eb 10                	jmp    801ec0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801eb0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801eb8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec0:	c9                   	leaveq 
  801ec1:	c3                   	retq   

0000000000801ec2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ec2:	55                   	push   %rbp
  801ec3:	48 89 e5             	mov    %rsp,%rbp
  801ec6:	48 83 ec 30          	sub    $0x30,%rsp
  801eca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ece:	89 f0                	mov    %esi,%eax
  801ed0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ed3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed7:	48 89 c7             	mov    %rax,%rdi
  801eda:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  801ee1:	00 00 00 
  801ee4:	ff d0                	callq  *%rax
  801ee6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801eea:	48 89 d6             	mov    %rdx,%rsi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	callq  *%rax
  801efb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f02:	78 0a                	js     801f0e <fd_close+0x4c>
	    || fd != fd2)
  801f04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f08:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f0c:	74 12                	je     801f20 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f0e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f12:	74 05                	je     801f19 <fd_close+0x57>
  801f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f17:	eb 05                	jmp    801f1e <fd_close+0x5c>
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb 69                	jmp    801f89 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f24:	8b 00                	mov    (%rax),%eax
  801f26:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f2a:	48 89 d6             	mov    %rdx,%rsi
  801f2d:	89 c7                	mov    %eax,%edi
  801f2f:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	callq  *%rax
  801f3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f42:	78 2a                	js     801f6e <fd_close+0xac>
		if (dev->dev_close)
  801f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f48:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f4c:	48 85 c0             	test   %rax,%rax
  801f4f:	74 16                	je     801f67 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f55:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f5d:	48 89 c7             	mov    %rax,%rdi
  801f60:	ff d2                	callq  *%rdx
  801f62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f65:	eb 07                	jmp    801f6e <fd_close+0xac>
		else
			r = 0;
  801f67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f72:	48 89 c6             	mov    %rax,%rsi
  801f75:	bf 00 00 00 00       	mov    $0x0,%edi
  801f7a:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  801f81:	00 00 00 
  801f84:	ff d0                	callq  *%rax
	return r;
  801f86:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f89:	c9                   	leaveq 
  801f8a:	c3                   	retq   

0000000000801f8b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f8b:	55                   	push   %rbp
  801f8c:	48 89 e5             	mov    %rsp,%rbp
  801f8f:	48 83 ec 20          	sub    $0x20,%rsp
  801f93:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fa1:	eb 41                	jmp    801fe4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fa3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801faa:	00 00 00 
  801fad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fb0:	48 63 d2             	movslq %edx,%rdx
  801fb3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fb7:	8b 00                	mov    (%rax),%eax
  801fb9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fbc:	75 22                	jne    801fe0 <dev_lookup+0x55>
			*dev = devtab[i];
  801fbe:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc5:	00 00 00 
  801fc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcb:	48 63 d2             	movslq %edx,%rdx
  801fce:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fd2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb 60                	jmp    802040 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fe0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fe4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801feb:	00 00 00 
  801fee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff1:	48 63 d2             	movslq %edx,%rdx
  801ff4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ff8:	48 85 c0             	test   %rax,%rax
  801ffb:	75 a6                	jne    801fa3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ffd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802004:	00 00 00 
  802007:	48 8b 00             	mov    (%rax),%rax
  80200a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802010:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802013:	89 c6                	mov    %eax,%esi
  802015:	48 bf b0 41 80 00 00 	movabs $0x8041b0,%rdi
  80201c:	00 00 00 
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  80202b:	00 00 00 
  80202e:	ff d1                	callq  *%rcx
	*dev = 0;
  802030:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802034:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80203b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802040:	c9                   	leaveq 
  802041:	c3                   	retq   

0000000000802042 <close>:

int
close(int fdnum)
{
  802042:	55                   	push   %rbp
  802043:	48 89 e5             	mov    %rsp,%rbp
  802046:	48 83 ec 20          	sub    $0x20,%rsp
  80204a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802051:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802054:	48 89 d6             	mov    %rdx,%rsi
  802057:	89 c7                	mov    %eax,%edi
  802059:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
  802065:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802068:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206c:	79 05                	jns    802073 <close+0x31>
		return r;
  80206e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802071:	eb 18                	jmp    80208b <close+0x49>
	else
		return fd_close(fd, 1);
  802073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802077:	be 01 00 00 00       	mov    $0x1,%esi
  80207c:	48 89 c7             	mov    %rax,%rdi
  80207f:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  802086:	00 00 00 
  802089:	ff d0                	callq  *%rax
}
  80208b:	c9                   	leaveq 
  80208c:	c3                   	retq   

000000000080208d <close_all>:

void
close_all(void)
{
  80208d:	55                   	push   %rbp
  80208e:	48 89 e5             	mov    %rsp,%rbp
  802091:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80209c:	eb 15                	jmp    8020b3 <close_all+0x26>
		close(i);
  80209e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a1:	89 c7                	mov    %eax,%edi
  8020a3:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  8020aa:	00 00 00 
  8020ad:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020b3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020b7:	7e e5                	jle    80209e <close_all+0x11>
		close(i);
}
  8020b9:	c9                   	leaveq 
  8020ba:	c3                   	retq   

00000000008020bb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020bb:	55                   	push   %rbp
  8020bc:	48 89 e5             	mov    %rsp,%rbp
  8020bf:	48 83 ec 40          	sub    $0x40,%rsp
  8020c3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020c6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020c9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020cd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020d0:	48 89 d6             	mov    %rdx,%rsi
  8020d3:	89 c7                	mov    %eax,%edi
  8020d5:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	callq  *%rax
  8020e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e8:	79 08                	jns    8020f2 <dup+0x37>
		return r;
  8020ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ed:	e9 70 01 00 00       	jmpq   802262 <dup+0x1a7>
	close(newfdnum);
  8020f2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8020f5:	89 c7                	mov    %eax,%edi
  8020f7:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802103:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802106:	48 98                	cltq   
  802108:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80210e:	48 c1 e0 0c          	shl    $0xc,%rax
  802112:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802116:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211a:	48 89 c7             	mov    %rax,%rdi
  80211d:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  802124:	00 00 00 
  802127:	ff d0                	callq  *%rax
  802129:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80212d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802131:	48 89 c7             	mov    %rax,%rdi
  802134:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  80213b:	00 00 00 
  80213e:	ff d0                	callq  *%rax
  802140:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802144:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802148:	48 89 c2             	mov    %rax,%rdx
  80214b:	48 c1 ea 15          	shr    $0x15,%rdx
  80214f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802156:	01 00 00 
  802159:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215d:	83 e0 01             	and    $0x1,%eax
  802160:	84 c0                	test   %al,%al
  802162:	74 71                	je     8021d5 <dup+0x11a>
  802164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802168:	48 89 c2             	mov    %rax,%rdx
  80216b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80216f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802176:	01 00 00 
  802179:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217d:	83 e0 01             	and    $0x1,%eax
  802180:	84 c0                	test   %al,%al
  802182:	74 51                	je     8021d5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802184:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802188:	48 89 c2             	mov    %rax,%rdx
  80218b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80218f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802196:	01 00 00 
  802199:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80219d:	89 c1                	mov    %eax,%ecx
  80219f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ad:	41 89 c8             	mov    %ecx,%r8d
  8021b0:	48 89 d1             	mov    %rdx,%rcx
  8021b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b8:	48 89 c6             	mov    %rax,%rsi
  8021bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c0:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  8021c7:	00 00 00 
  8021ca:	ff d0                	callq  *%rax
  8021cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d3:	78 56                	js     80222b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d9:	48 89 c2             	mov    %rax,%rdx
  8021dc:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e7:	01 00 00 
  8021ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ee:	89 c1                	mov    %eax,%ecx
  8021f0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fe:	41 89 c8             	mov    %ecx,%r8d
  802201:	48 89 d1             	mov    %rdx,%rcx
  802204:	ba 00 00 00 00       	mov    $0x0,%edx
  802209:	48 89 c6             	mov    %rax,%rsi
  80220c:	bf 00 00 00 00       	mov    $0x0,%edi
  802211:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  802218:	00 00 00 
  80221b:	ff d0                	callq  *%rax
  80221d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802220:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802224:	78 08                	js     80222e <dup+0x173>
		goto err;

	return newfdnum;
  802226:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802229:	eb 37                	jmp    802262 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80222b:	90                   	nop
  80222c:	eb 01                	jmp    80222f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80222e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80222f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802233:	48 89 c6             	mov    %rax,%rsi
  802236:	bf 00 00 00 00       	mov    $0x0,%edi
  80223b:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  802242:	00 00 00 
  802245:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224b:	48 89 c6             	mov    %rax,%rsi
  80224e:	bf 00 00 00 00       	mov    $0x0,%edi
  802253:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  80225a:	00 00 00 
  80225d:	ff d0                	callq  *%rax
	return r;
  80225f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802262:	c9                   	leaveq 
  802263:	c3                   	retq   

0000000000802264 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802264:	55                   	push   %rbp
  802265:	48 89 e5             	mov    %rsp,%rbp
  802268:	48 83 ec 40          	sub    $0x40,%rsp
  80226c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80226f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802273:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802277:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80227b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80227e:	48 89 d6             	mov    %rdx,%rsi
  802281:	89 c7                	mov    %eax,%edi
  802283:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80228a:	00 00 00 
  80228d:	ff d0                	callq  *%rax
  80228f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802296:	78 24                	js     8022bc <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229c:	8b 00                	mov    (%rax),%eax
  80229e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022a2:	48 89 d6             	mov    %rdx,%rsi
  8022a5:	89 c7                	mov    %eax,%edi
  8022a7:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
  8022b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ba:	79 05                	jns    8022c1 <read+0x5d>
		return r;
  8022bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bf:	eb 7a                	jmp    80233b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c5:	8b 40 08             	mov    0x8(%rax),%eax
  8022c8:	83 e0 03             	and    $0x3,%eax
  8022cb:	83 f8 01             	cmp    $0x1,%eax
  8022ce:	75 3a                	jne    80230a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022d0:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8022d7:	00 00 00 
  8022da:	48 8b 00             	mov    (%rax),%rax
  8022dd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022e3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8022e6:	89 c6                	mov    %eax,%esi
  8022e8:	48 bf cf 41 80 00 00 	movabs $0x8041cf,%rdi
  8022ef:	00 00 00 
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  8022fe:	00 00 00 
  802301:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802303:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802308:	eb 31                	jmp    80233b <read+0xd7>
	}
	if (!dev->dev_read)
  80230a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802312:	48 85 c0             	test   %rax,%rax
  802315:	75 07                	jne    80231e <read+0xba>
		return -E_NOT_SUPP;
  802317:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80231c:	eb 1d                	jmp    80233b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80231e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802322:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802326:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80232e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802332:	48 89 ce             	mov    %rcx,%rsi
  802335:	48 89 c7             	mov    %rax,%rdi
  802338:	41 ff d0             	callq  *%r8
}
  80233b:	c9                   	leaveq 
  80233c:	c3                   	retq   

000000000080233d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80233d:	55                   	push   %rbp
  80233e:	48 89 e5             	mov    %rsp,%rbp
  802341:	48 83 ec 30          	sub    $0x30,%rsp
  802345:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80234c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802357:	eb 46                	jmp    80239f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235c:	48 98                	cltq   
  80235e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802362:	48 29 c2             	sub    %rax,%rdx
  802365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802368:	48 98                	cltq   
  80236a:	48 89 c1             	mov    %rax,%rcx
  80236d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802371:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802374:	48 89 ce             	mov    %rcx,%rsi
  802377:	89 c7                	mov    %eax,%edi
  802379:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  802380:	00 00 00 
  802383:	ff d0                	callq  *%rax
  802385:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802388:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238c:	79 05                	jns    802393 <readn+0x56>
			return m;
  80238e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802391:	eb 1d                	jmp    8023b0 <readn+0x73>
		if (m == 0)
  802393:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802397:	74 13                	je     8023ac <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802399:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80239c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80239f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a2:	48 98                	cltq   
  8023a4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023a8:	72 af                	jb     802359 <readn+0x1c>
  8023aa:	eb 01                	jmp    8023ad <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023ac:	90                   	nop
	}
	return tot;
  8023ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023b0:	c9                   	leaveq 
  8023b1:	c3                   	retq   

00000000008023b2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023b2:	55                   	push   %rbp
  8023b3:	48 89 e5             	mov    %rsp,%rbp
  8023b6:	48 83 ec 40          	sub    $0x40,%rsp
  8023ba:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023bd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023c1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023cc:	48 89 d6             	mov    %rdx,%rsi
  8023cf:	89 c7                	mov    %eax,%edi
  8023d1:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8023d8:	00 00 00 
  8023db:	ff d0                	callq  *%rax
  8023dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e4:	78 24                	js     80240a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ea:	8b 00                	mov    (%rax),%eax
  8023ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f0:	48 89 d6             	mov    %rdx,%rsi
  8023f3:	89 c7                	mov    %eax,%edi
  8023f5:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8023fc:	00 00 00 
  8023ff:	ff d0                	callq  *%rax
  802401:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802404:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802408:	79 05                	jns    80240f <write+0x5d>
		return r;
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240d:	eb 79                	jmp    802488 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80240f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802413:	8b 40 08             	mov    0x8(%rax),%eax
  802416:	83 e0 03             	and    $0x3,%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 3a                	jne    802457 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80241d:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  802424:	00 00 00 
  802427:	48 8b 00             	mov    (%rax),%rax
  80242a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802430:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802433:	89 c6                	mov    %eax,%esi
  802435:	48 bf eb 41 80 00 00 	movabs $0x8041eb,%rdi
  80243c:	00 00 00 
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  80244b:	00 00 00 
  80244e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802450:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802455:	eb 31                	jmp    802488 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80245f:	48 85 c0             	test   %rax,%rax
  802462:	75 07                	jne    80246b <write+0xb9>
		return -E_NOT_SUPP;
  802464:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802469:	eb 1d                	jmp    802488 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80246b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80246f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80247b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80247f:	48 89 ce             	mov    %rcx,%rsi
  802482:	48 89 c7             	mov    %rax,%rdi
  802485:	41 ff d0             	callq  *%r8
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <seek>:

int
seek(int fdnum, off_t offset)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 18          	sub    $0x18,%rsp
  802492:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802495:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802498:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80249c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80249f:	48 89 d6             	mov    %rdx,%rsi
  8024a2:	89 c7                	mov    %eax,%edi
  8024a4:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8024ab:	00 00 00 
  8024ae:	ff d0                	callq  *%rax
  8024b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b7:	79 05                	jns    8024be <seek+0x34>
		return r;
  8024b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bc:	eb 0f                	jmp    8024cd <seek+0x43>
	fd->fd_offset = offset;
  8024be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cd:	c9                   	leaveq 
  8024ce:	c3                   	retq   

00000000008024cf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024cf:	55                   	push   %rbp
  8024d0:	48 89 e5             	mov    %rsp,%rbp
  8024d3:	48 83 ec 30          	sub    $0x30,%rsp
  8024d7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024da:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e4:	48 89 d6             	mov    %rdx,%rsi
  8024e7:	89 c7                	mov    %eax,%edi
  8024e9:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
  8024f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fc:	78 24                	js     802522 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802502:	8b 00                	mov    (%rax),%eax
  802504:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802508:	48 89 d6             	mov    %rdx,%rsi
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  802514:	00 00 00 
  802517:	ff d0                	callq  *%rax
  802519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802520:	79 05                	jns    802527 <ftruncate+0x58>
		return r;
  802522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802525:	eb 72                	jmp    802599 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252b:	8b 40 08             	mov    0x8(%rax),%eax
  80252e:	83 e0 03             	and    $0x3,%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	75 3a                	jne    80256f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802535:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80253c:	00 00 00 
  80253f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802542:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802548:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80254b:	89 c6                	mov    %eax,%esi
  80254d:	48 bf 08 42 80 00 00 	movabs $0x804208,%rdi
  802554:	00 00 00 
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
  80255c:	48 b9 0f 03 80 00 00 	movabs $0x80030f,%rcx
  802563:	00 00 00 
  802566:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80256d:	eb 2a                	jmp    802599 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80256f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802573:	48 8b 40 30          	mov    0x30(%rax),%rax
  802577:	48 85 c0             	test   %rax,%rax
  80257a:	75 07                	jne    802583 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80257c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802581:	eb 16                	jmp    802599 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802587:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802592:	89 d6                	mov    %edx,%esi
  802594:	48 89 c7             	mov    %rax,%rdi
  802597:	ff d1                	callq  *%rcx
}
  802599:	c9                   	leaveq 
  80259a:	c3                   	retq   

000000000080259b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80259b:	55                   	push   %rbp
  80259c:	48 89 e5             	mov    %rsp,%rbp
  80259f:	48 83 ec 30          	sub    $0x30,%rsp
  8025a3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025b1:	48 89 d6             	mov    %rdx,%rsi
  8025b4:	89 c7                	mov    %eax,%edi
  8025b6:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c9:	78 24                	js     8025ef <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025cf:	8b 00                	mov    (%rax),%eax
  8025d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025d5:	48 89 d6             	mov    %rdx,%rsi
  8025d8:	89 c7                	mov    %eax,%edi
  8025da:	48 b8 8b 1f 80 00 00 	movabs $0x801f8b,%rax
  8025e1:	00 00 00 
  8025e4:	ff d0                	callq  *%rax
  8025e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ed:	79 05                	jns    8025f4 <fstat+0x59>
		return r;
  8025ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f2:	eb 5e                	jmp    802652 <fstat+0xb7>
	if (!dev->dev_stat)
  8025f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025fc:	48 85 c0             	test   %rax,%rax
  8025ff:	75 07                	jne    802608 <fstat+0x6d>
		return -E_NOT_SUPP;
  802601:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802606:	eb 4a                	jmp    802652 <fstat+0xb7>
	stat->st_name[0] = 0;
  802608:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80260c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80260f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802613:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80261a:	00 00 00 
	stat->st_isdir = 0;
  80261d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802621:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802628:	00 00 00 
	stat->st_dev = dev;
  80262b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80262f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802633:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80263a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802646:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80264a:	48 89 d6             	mov    %rdx,%rsi
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	ff d1                	callq  *%rcx
}
  802652:	c9                   	leaveq 
  802653:	c3                   	retq   

0000000000802654 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 20          	sub    $0x20,%rsp
  80265c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802660:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802668:	be 00 00 00 00       	mov    $0x0,%esi
  80266d:	48 89 c7             	mov    %rax,%rdi
  802670:	48 b8 43 27 80 00 00 	movabs $0x802743,%rax
  802677:	00 00 00 
  80267a:	ff d0                	callq  *%rax
  80267c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802683:	79 05                	jns    80268a <stat+0x36>
		return fd;
  802685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802688:	eb 2f                	jmp    8026b9 <stat+0x65>
	r = fstat(fd, stat);
  80268a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80268e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802691:	48 89 d6             	mov    %rdx,%rsi
  802694:	89 c7                	mov    %eax,%edi
  802696:	48 b8 9b 25 80 00 00 	movabs $0x80259b,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
  8026a2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a8:	89 c7                	mov    %eax,%edi
  8026aa:	48 b8 42 20 80 00 00 	movabs $0x802042,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
	return r;
  8026b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026b9:	c9                   	leaveq 
  8026ba:	c3                   	retq   
	...

00000000008026bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
  8026c0:	48 83 ec 10          	sub    $0x10,%rsp
  8026c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026cb:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026d2:	00 00 00 
  8026d5:	8b 00                	mov    (%rax),%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	75 1d                	jne    8026f8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026db:	bf 01 00 00 00       	mov    $0x1,%edi
  8026e0:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  8026f3:	00 00 00 
  8026f6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8026f8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026ff:	00 00 00 
  802702:	8b 00                	mov    (%rax),%eax
  802704:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802707:	b9 07 00 00 00       	mov    $0x7,%ecx
  80270c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802713:	00 00 00 
  802716:	89 c7                	mov    %eax,%edi
  802718:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  80271f:	00 00 00 
  802722:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802728:	ba 00 00 00 00       	mov    $0x0,%edx
  80272d:	48 89 c6             	mov    %rax,%rsi
  802730:	bf 00 00 00 00       	mov    $0x0,%edi
  802735:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  80273c:	00 00 00 
  80273f:	ff d0                	callq  *%rax
}
  802741:	c9                   	leaveq 
  802742:	c3                   	retq   

0000000000802743 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802743:	55                   	push   %rbp
  802744:	48 89 e5             	mov    %rsp,%rbp
  802747:	48 83 ec 20          	sub    $0x20,%rsp
  80274b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80274f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802756:	48 89 c7             	mov    %rax,%rdi
  802759:	48 b8 60 0e 80 00 00 	movabs $0x800e60,%rax
  802760:	00 00 00 
  802763:	ff d0                	callq  *%rax
  802765:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80276a:	7e 0a                	jle    802776 <open+0x33>
                return -E_BAD_PATH;
  80276c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802771:	e9 a5 00 00 00       	jmpq   80281b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802776:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80277a:	48 89 c7             	mov    %rax,%rdi
  80277d:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802784:	00 00 00 
  802787:	ff d0                	callq  *%rax
  802789:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802790:	79 08                	jns    80279a <open+0x57>
		return r;
  802792:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802795:	e9 81 00 00 00       	jmpq   80281b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80279a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279e:	48 89 c6             	mov    %rax,%rsi
  8027a1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8027a8:	00 00 00 
  8027ab:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8027b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027be:	00 00 00 
  8027c1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027c4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8027ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ce:	48 89 c6             	mov    %rax,%rsi
  8027d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8027d6:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e9:	79 1d                	jns    802808 <open+0xc5>
	{
		fd_close(fd,0);
  8027eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ef:	be 00 00 00 00       	mov    $0x0,%esi
  8027f4:	48 89 c7             	mov    %rax,%rdi
  8027f7:	48 b8 c2 1e 80 00 00 	movabs $0x801ec2,%rax
  8027fe:	00 00 00 
  802801:	ff d0                	callq  *%rax
		return r;
  802803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802806:	eb 13                	jmp    80281b <open+0xd8>
	}
	return fd2num(fd);
  802808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280c:	48 89 c7             	mov    %rax,%rdi
  80280f:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  802816:	00 00 00 
  802819:	ff d0                	callq  *%rax
	


}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 10          	sub    $0x10,%rsp
  802825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282d:	8b 50 0c             	mov    0xc(%rax),%edx
  802830:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802837:	00 00 00 
  80283a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80283c:	be 00 00 00 00       	mov    $0x0,%esi
  802841:	bf 06 00 00 00       	mov    $0x6,%edi
  802846:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  80284d:	00 00 00 
  802850:	ff d0                	callq  *%rax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 30          	sub    $0x30,%rsp
  80285c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802860:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802864:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80286c:	8b 50 0c             	mov    0xc(%rax),%edx
  80286f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802876:	00 00 00 
  802879:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80287b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802882:	00 00 00 
  802885:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802889:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80288d:	be 00 00 00 00       	mov    $0x0,%esi
  802892:	bf 03 00 00 00       	mov    $0x3,%edi
  802897:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax
  8028a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028aa:	79 05                	jns    8028b1 <devfile_read+0x5d>
	{
		return r;
  8028ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028af:	eb 2c                	jmp    8028dd <devfile_read+0x89>
	}
	if(r > 0)
  8028b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b5:	7e 23                	jle    8028da <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8028b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ba:	48 63 d0             	movslq %eax,%rdx
  8028bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8028c8:	00 00 00 
  8028cb:	48 89 c7             	mov    %rax,%rdi
  8028ce:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax
	return r;
  8028da:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8028dd:	c9                   	leaveq 
  8028de:	c3                   	retq   

00000000008028df <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 30          	sub    $0x30,%rsp
  8028e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8028f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f7:	8b 50 0c             	mov    0xc(%rax),%edx
  8028fa:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802901:	00 00 00 
  802904:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802906:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80290d:	00 
  80290e:	76 08                	jbe    802918 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802910:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802917:	00 
	fsipcbuf.write.req_n=n;
  802918:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80291f:	00 00 00 
  802922:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802926:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80292a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80292e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802932:	48 89 c6             	mov    %rax,%rsi
  802935:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80293c:	00 00 00 
  80293f:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80294b:	be 00 00 00 00       	mov    $0x0,%esi
  802950:	bf 04 00 00 00       	mov    $0x4,%edi
  802955:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  80295c:	00 00 00 
  80295f:	ff d0                	callq  *%rax
  802961:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802967:	c9                   	leaveq 
  802968:	c3                   	retq   

0000000000802969 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802969:	55                   	push   %rbp
  80296a:	48 89 e5             	mov    %rsp,%rbp
  80296d:	48 83 ec 10          	sub    $0x10,%rsp
  802971:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802975:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802978:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80297c:	8b 50 0c             	mov    0xc(%rax),%edx
  80297f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802986:	00 00 00 
  802989:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80298b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802992:	00 00 00 
  802995:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802998:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80299b:	be 00 00 00 00       	mov    $0x0,%esi
  8029a0:	bf 02 00 00 00       	mov    $0x2,%edi
  8029a5:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
}
  8029b1:	c9                   	leaveq 
  8029b2:	c3                   	retq   

00000000008029b3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029b3:	55                   	push   %rbp
  8029b4:	48 89 e5             	mov    %rsp,%rbp
  8029b7:	48 83 ec 20          	sub    $0x20,%rsp
  8029bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d1:	00 00 00 
  8029d4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029d6:	be 00 00 00 00       	mov    $0x0,%esi
  8029db:	bf 05 00 00 00       	mov    $0x5,%edi
  8029e0:	48 b8 bc 26 80 00 00 	movabs $0x8026bc,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f3:	79 05                	jns    8029fa <devfile_stat+0x47>
		return r;
  8029f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f8:	eb 56                	jmp    802a50 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8029fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029fe:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a05:	00 00 00 
  802a08:	48 89 c7             	mov    %rax,%rdi
  802a0b:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  802a12:	00 00 00 
  802a15:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a17:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1e:	00 00 00 
  802a21:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a31:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a38:	00 00 00 
  802a3b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a45:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a50:	c9                   	leaveq 
  802a51:	c3                   	retq   
	...

0000000000802a54 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a54:	55                   	push   %rbp
  802a55:	48 89 e5             	mov    %rsp,%rbp
  802a58:	48 83 ec 20          	sub    $0x20,%rsp
  802a5c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a5f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a66:	48 89 d6             	mov    %rdx,%rsi
  802a69:	89 c7                	mov    %eax,%edi
  802a6b:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  802a72:	00 00 00 
  802a75:	ff d0                	callq  *%rax
  802a77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7e:	79 05                	jns    802a85 <fd2sockid+0x31>
		return r;
  802a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a83:	eb 24                	jmp    802aa9 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802a85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a89:	8b 10                	mov    (%rax),%edx
  802a8b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802a92:	00 00 00 
  802a95:	8b 00                	mov    (%rax),%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	74 07                	je     802aa2 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802a9b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802aa0:	eb 07                	jmp    802aa9 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa6:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802aa9:	c9                   	leaveq 
  802aaa:	c3                   	retq   

0000000000802aab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802aab:	55                   	push   %rbp
  802aac:	48 89 e5             	mov    %rsp,%rbp
  802aaf:	48 83 ec 20          	sub    $0x20,%rsp
  802ab3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802ab6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802aba:	48 89 c7             	mov    %rax,%rdi
  802abd:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802ac4:	00 00 00 
  802ac7:	ff d0                	callq  *%rax
  802ac9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad0:	78 26                	js     802af8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad6:	ba 07 04 00 00       	mov    $0x407,%edx
  802adb:	48 89 c6             	mov    %rax,%rsi
  802ade:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae3:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  802aea:	00 00 00 
  802aed:	ff d0                	callq  *%rax
  802aef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af6:	79 16                	jns    802b0e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802af8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802afb:	89 c7                	mov    %eax,%edi
  802afd:	48 b8 b8 2f 80 00 00 	movabs $0x802fb8,%rax
  802b04:	00 00 00 
  802b07:	ff d0                	callq  *%rax
		return r;
  802b09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0c:	eb 3a                	jmp    802b48 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802b0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b12:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802b19:	00 00 00 
  802b1c:	8b 12                	mov    (%rdx),%edx
  802b1e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b24:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b32:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802b35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b39:	48 89 c7             	mov    %rax,%rdi
  802b3c:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  802b43:	00 00 00 
  802b46:	ff d0                	callq  *%rax
}
  802b48:	c9                   	leaveq 
  802b49:	c3                   	retq   

0000000000802b4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b4a:	55                   	push   %rbp
  802b4b:	48 89 e5             	mov    %rsp,%rbp
  802b4e:	48 83 ec 30          	sub    $0x30,%rsp
  802b52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b60:	89 c7                	mov    %eax,%edi
  802b62:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  802b69:	00 00 00 
  802b6c:	ff d0                	callq  *%rax
  802b6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b75:	79 05                	jns    802b7c <accept+0x32>
		return r;
  802b77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7a:	eb 3b                	jmp    802bb7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b7c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b80:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b87:	48 89 ce             	mov    %rcx,%rsi
  802b8a:	89 c7                	mov    %eax,%edi
  802b8c:	48 b8 95 2e 80 00 00 	movabs $0x802e95,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9f:	79 05                	jns    802ba6 <accept+0x5c>
		return r;
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba4:	eb 11                	jmp    802bb7 <accept+0x6d>
	return alloc_sockfd(r);
  802ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba9:	89 c7                	mov    %eax,%edi
  802bab:	48 b8 ab 2a 80 00 00 	movabs $0x802aab,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
}
  802bb7:	c9                   	leaveq 
  802bb8:	c3                   	retq   

0000000000802bb9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802bb9:	55                   	push   %rbp
  802bba:	48 89 e5             	mov    %rsp,%rbp
  802bbd:	48 83 ec 20          	sub    $0x20,%rsp
  802bc1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bc4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bc8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bce:	89 c7                	mov    %eax,%edi
  802bd0:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
  802bdc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be3:	79 05                	jns    802bea <bind+0x31>
		return r;
  802be5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be8:	eb 1b                	jmp    802c05 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802bea:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bed:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802bf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf4:	48 89 ce             	mov    %rcx,%rsi
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	48 b8 14 2f 80 00 00 	movabs $0x802f14,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
}
  802c05:	c9                   	leaveq 
  802c06:	c3                   	retq   

0000000000802c07 <shutdown>:

int
shutdown(int s, int how)
{
  802c07:	55                   	push   %rbp
  802c08:	48 89 e5             	mov    %rsp,%rbp
  802c0b:	48 83 ec 20          	sub    $0x20,%rsp
  802c0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c12:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c18:	89 c7                	mov    %eax,%edi
  802c1a:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
  802c26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2d:	79 05                	jns    802c34 <shutdown+0x2d>
		return r;
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	eb 16                	jmp    802c4a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802c34:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3a:	89 d6                	mov    %edx,%esi
  802c3c:	89 c7                	mov    %eax,%edi
  802c3e:	48 b8 78 2f 80 00 00 	movabs $0x802f78,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
}
  802c4a:	c9                   	leaveq 
  802c4b:	c3                   	retq   

0000000000802c4c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802c4c:	55                   	push   %rbp
  802c4d:	48 89 e5             	mov    %rsp,%rbp
  802c50:	48 83 ec 10          	sub    $0x10,%rsp
  802c54:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802c58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5c:	48 89 c7             	mov    %rax,%rdi
  802c5f:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  802c66:	00 00 00 
  802c69:	ff d0                	callq  *%rax
  802c6b:	83 f8 01             	cmp    $0x1,%eax
  802c6e:	75 17                	jne    802c87 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802c70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c74:	8b 40 0c             	mov    0xc(%rax),%eax
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	48 b8 b8 2f 80 00 00 	movabs $0x802fb8,%rax
  802c80:	00 00 00 
  802c83:	ff d0                	callq  *%rax
  802c85:	eb 05                	jmp    802c8c <devsock_close+0x40>
	else
		return 0;
  802c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c8c:	c9                   	leaveq 
  802c8d:	c3                   	retq   

0000000000802c8e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802c8e:	55                   	push   %rbp
  802c8f:	48 89 e5             	mov    %rsp,%rbp
  802c92:	48 83 ec 20          	sub    $0x20,%rsp
  802c96:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c9d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ca0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ca3:	89 c7                	mov    %eax,%edi
  802ca5:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  802cac:	00 00 00 
  802caf:	ff d0                	callq  *%rax
  802cb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb8:	79 05                	jns    802cbf <connect+0x31>
		return r;
  802cba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbd:	eb 1b                	jmp    802cda <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802cbf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cc2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc9:	48 89 ce             	mov    %rcx,%rsi
  802ccc:	89 c7                	mov    %eax,%edi
  802cce:	48 b8 e5 2f 80 00 00 	movabs $0x802fe5,%rax
  802cd5:	00 00 00 
  802cd8:	ff d0                	callq  *%rax
}
  802cda:	c9                   	leaveq 
  802cdb:	c3                   	retq   

0000000000802cdc <listen>:

int
listen(int s, int backlog)
{
  802cdc:	55                   	push   %rbp
  802cdd:	48 89 e5             	mov    %rsp,%rbp
  802ce0:	48 83 ec 20          	sub    $0x20,%rsp
  802ce4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ced:	89 c7                	mov    %eax,%edi
  802cef:	48 b8 54 2a 80 00 00 	movabs $0x802a54,%rax
  802cf6:	00 00 00 
  802cf9:	ff d0                	callq  *%rax
  802cfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d02:	79 05                	jns    802d09 <listen+0x2d>
		return r;
  802d04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d07:	eb 16                	jmp    802d1f <listen+0x43>
	return nsipc_listen(r, backlog);
  802d09:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0f:	89 d6                	mov    %edx,%esi
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	48 b8 49 30 80 00 00 	movabs $0x803049,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
}
  802d1f:	c9                   	leaveq 
  802d20:	c3                   	retq   

0000000000802d21 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802d21:	55                   	push   %rbp
  802d22:	48 89 e5             	mov    %rsp,%rbp
  802d25:	48 83 ec 20          	sub    $0x20,%rsp
  802d29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d31:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802d35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d39:	89 c2                	mov    %eax,%edx
  802d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d3f:	8b 40 0c             	mov    0xc(%rax),%eax
  802d42:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d46:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d4b:	89 c7                	mov    %eax,%edi
  802d4d:	48 b8 89 30 80 00 00 	movabs $0x803089,%rax
  802d54:	00 00 00 
  802d57:	ff d0                	callq  *%rax
}
  802d59:	c9                   	leaveq 
  802d5a:	c3                   	retq   

0000000000802d5b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802d5b:	55                   	push   %rbp
  802d5c:	48 89 e5             	mov    %rsp,%rbp
  802d5f:	48 83 ec 20          	sub    $0x20,%rsp
  802d63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d6b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d73:	89 c2                	mov    %eax,%edx
  802d75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d79:	8b 40 0c             	mov    0xc(%rax),%eax
  802d7c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d80:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d85:	89 c7                	mov    %eax,%edi
  802d87:	48 b8 55 31 80 00 00 	movabs $0x803155,%rax
  802d8e:	00 00 00 
  802d91:	ff d0                	callq  *%rax
}
  802d93:	c9                   	leaveq 
  802d94:	c3                   	retq   

0000000000802d95 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d95:	55                   	push   %rbp
  802d96:	48 89 e5             	mov    %rsp,%rbp
  802d99:	48 83 ec 10          	sub    $0x10,%rsp
  802d9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802da1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802da5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da9:	48 be 33 42 80 00 00 	movabs $0x804233,%rsi
  802db0:	00 00 00 
  802db3:	48 89 c7             	mov    %rax,%rdi
  802db6:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
	return 0;
  802dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc7:	c9                   	leaveq 
  802dc8:	c3                   	retq   

0000000000802dc9 <socket>:

int
socket(int domain, int type, int protocol)
{
  802dc9:	55                   	push   %rbp
  802dca:	48 89 e5             	mov    %rsp,%rbp
  802dcd:	48 83 ec 20          	sub    $0x20,%rsp
  802dd1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802dd4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802dd7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802dda:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ddd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802de0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de3:	89 ce                	mov    %ecx,%esi
  802de5:	89 c7                	mov    %eax,%edi
  802de7:	48 b8 0d 32 80 00 00 	movabs $0x80320d,%rax
  802dee:	00 00 00 
  802df1:	ff d0                	callq  *%rax
  802df3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dfa:	79 05                	jns    802e01 <socket+0x38>
		return r;
  802dfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dff:	eb 11                	jmp    802e12 <socket+0x49>
	return alloc_sockfd(r);
  802e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e04:	89 c7                	mov    %eax,%edi
  802e06:	48 b8 ab 2a 80 00 00 	movabs $0x802aab,%rax
  802e0d:	00 00 00 
  802e10:	ff d0                	callq  *%rax
}
  802e12:	c9                   	leaveq 
  802e13:	c3                   	retq   

0000000000802e14 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802e14:	55                   	push   %rbp
  802e15:	48 89 e5             	mov    %rsp,%rbp
  802e18:	48 83 ec 10          	sub    $0x10,%rsp
  802e1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802e1f:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802e26:	00 00 00 
  802e29:	8b 00                	mov    (%rax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	75 1d                	jne    802e4c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802e2f:	bf 02 00 00 00       	mov    $0x2,%edi
  802e34:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  802e3b:	00 00 00 
  802e3e:	ff d0                	callq  *%rax
  802e40:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  802e47:	00 00 00 
  802e4a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802e4c:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802e53:	00 00 00 
  802e56:	8b 00                	mov    (%rax),%eax
  802e58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e5b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e60:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802e67:	00 00 00 
  802e6a:	89 c7                	mov    %eax,%edi
  802e6c:	48 b8 04 1c 80 00 00 	movabs $0x801c04,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802e78:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7d:	be 00 00 00 00       	mov    $0x0,%esi
  802e82:	bf 00 00 00 00       	mov    $0x0,%edi
  802e87:	48 b8 44 1b 80 00 00 	movabs $0x801b44,%rax
  802e8e:	00 00 00 
  802e91:	ff d0                	callq  *%rax
}
  802e93:	c9                   	leaveq 
  802e94:	c3                   	retq   

0000000000802e95 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e95:	55                   	push   %rbp
  802e96:	48 89 e5             	mov    %rsp,%rbp
  802e99:	48 83 ec 30          	sub    $0x30,%rsp
  802e9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ea4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802ea8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802eaf:	00 00 00 
  802eb2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802eb5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802eb7:	bf 01 00 00 00       	mov    $0x1,%edi
  802ebc:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802ec3:	00 00 00 
  802ec6:	ff d0                	callq  *%rax
  802ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ecf:	78 3e                	js     802f0f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802ed1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ed8:	00 00 00 
  802edb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee3:	8b 40 10             	mov    0x10(%rax),%eax
  802ee6:	89 c2                	mov    %eax,%edx
  802ee8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef0:	48 89 ce             	mov    %rcx,%rsi
  802ef3:	48 89 c7             	mov    %rax,%rdi
  802ef6:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  802efd:	00 00 00 
  802f00:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f06:	8b 50 10             	mov    0x10(%rax),%edx
  802f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f12:	c9                   	leaveq 
  802f13:	c3                   	retq   

0000000000802f14 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f14:	55                   	push   %rbp
  802f15:	48 89 e5             	mov    %rsp,%rbp
  802f18:	48 83 ec 10          	sub    $0x10,%rsp
  802f1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802f26:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f2d:	00 00 00 
  802f30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f33:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802f35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3c:	48 89 c6             	mov    %rax,%rsi
  802f3f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802f46:	00 00 00 
  802f49:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  802f50:	00 00 00 
  802f53:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802f55:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f5c:	00 00 00 
  802f5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f62:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802f65:	bf 02 00 00 00       	mov    $0x2,%edi
  802f6a:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
}
  802f76:	c9                   	leaveq 
  802f77:	c3                   	retq   

0000000000802f78 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802f78:	55                   	push   %rbp
  802f79:	48 89 e5             	mov    %rsp,%rbp
  802f7c:	48 83 ec 10          	sub    $0x10,%rsp
  802f80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f83:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802f86:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f8d:	00 00 00 
  802f90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f93:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802f95:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f9c:	00 00 00 
  802f9f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802fa5:	bf 03 00 00 00       	mov    $0x3,%edi
  802faa:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802fb1:	00 00 00 
  802fb4:	ff d0                	callq  *%rax
}
  802fb6:	c9                   	leaveq 
  802fb7:	c3                   	retq   

0000000000802fb8 <nsipc_close>:

int
nsipc_close(int s)
{
  802fb8:	55                   	push   %rbp
  802fb9:	48 89 e5             	mov    %rsp,%rbp
  802fbc:	48 83 ec 10          	sub    $0x10,%rsp
  802fc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802fc3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fca:	00 00 00 
  802fcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fd0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802fd2:	bf 04 00 00 00       	mov    $0x4,%edi
  802fd7:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
}
  802fe3:	c9                   	leaveq 
  802fe4:	c3                   	retq   

0000000000802fe5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fe5:	55                   	push   %rbp
  802fe6:	48 89 e5             	mov    %rsp,%rbp
  802fe9:	48 83 ec 10          	sub    $0x10,%rsp
  802fed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ff0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ff4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802ff7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ffe:	00 00 00 
  803001:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803004:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803006:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300d:	48 89 c6             	mov    %rax,%rsi
  803010:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803017:	00 00 00 
  80301a:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803026:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80302d:	00 00 00 
  803030:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803033:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803036:	bf 05 00 00 00       	mov    $0x5,%edi
  80303b:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
}
  803047:	c9                   	leaveq 
  803048:	c3                   	retq   

0000000000803049 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803049:	55                   	push   %rbp
  80304a:	48 89 e5             	mov    %rsp,%rbp
  80304d:	48 83 ec 10          	sub    $0x10,%rsp
  803051:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803054:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803057:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305e:	00 00 00 
  803061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803064:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803066:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80306d:	00 00 00 
  803070:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803073:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803076:	bf 06 00 00 00       	mov    $0x6,%edi
  80307b:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
}
  803087:	c9                   	leaveq 
  803088:	c3                   	retq   

0000000000803089 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803089:	55                   	push   %rbp
  80308a:	48 89 e5             	mov    %rsp,%rbp
  80308d:	48 83 ec 30          	sub    $0x30,%rsp
  803091:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803094:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803098:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80309b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80309e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030a5:	00 00 00 
  8030a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8030ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8030ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030b4:	00 00 00 
  8030b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8030bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c4:	00 00 00 
  8030c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030ca:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8030cd:	bf 07 00 00 00       	mov    $0x7,%edi
  8030d2:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  8030d9:	00 00 00 
  8030dc:	ff d0                	callq  *%rax
  8030de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e5:	78 69                	js     803150 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8030e7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8030ee:	7f 08                	jg     8030f8 <nsipc_recv+0x6f>
  8030f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8030f6:	7e 35                	jle    80312d <nsipc_recv+0xa4>
  8030f8:	48 b9 3a 42 80 00 00 	movabs $0x80423a,%rcx
  8030ff:	00 00 00 
  803102:	48 ba 4f 42 80 00 00 	movabs $0x80424f,%rdx
  803109:	00 00 00 
  80310c:	be 61 00 00 00       	mov    $0x61,%esi
  803111:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  803118:	00 00 00 
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
  803120:	49 b8 dc 3a 80 00 00 	movabs $0x803adc,%r8
  803127:	00 00 00 
  80312a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80312d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803130:	48 63 d0             	movslq %eax,%rdx
  803133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803137:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80313e:	00 00 00 
  803141:	48 89 c7             	mov    %rax,%rdi
  803144:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  80314b:	00 00 00 
  80314e:	ff d0                	callq  *%rax
	}

	return r;
  803150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803153:	c9                   	leaveq 
  803154:	c3                   	retq   

0000000000803155 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803155:	55                   	push   %rbp
  803156:	48 89 e5             	mov    %rsp,%rbp
  803159:	48 83 ec 20          	sub    $0x20,%rsp
  80315d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803160:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803164:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803167:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80316a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803171:	00 00 00 
  803174:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803177:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803179:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803180:	7e 35                	jle    8031b7 <nsipc_send+0x62>
  803182:	48 b9 70 42 80 00 00 	movabs $0x804270,%rcx
  803189:	00 00 00 
  80318c:	48 ba 4f 42 80 00 00 	movabs $0x80424f,%rdx
  803193:	00 00 00 
  803196:	be 6c 00 00 00       	mov    $0x6c,%esi
  80319b:	48 bf 64 42 80 00 00 	movabs $0x804264,%rdi
  8031a2:	00 00 00 
  8031a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031aa:	49 b8 dc 3a 80 00 00 	movabs $0x803adc,%r8
  8031b1:	00 00 00 
  8031b4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8031b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ba:	48 63 d0             	movslq %eax,%rdx
  8031bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c1:	48 89 c6             	mov    %rax,%rsi
  8031c4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8031cb:	00 00 00 
  8031ce:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8031da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031e1:	00 00 00 
  8031e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031e7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8031ea:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031f1:	00 00 00 
  8031f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031f7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8031fa:	bf 08 00 00 00       	mov    $0x8,%edi
  8031ff:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803206:	00 00 00 
  803209:	ff d0                	callq  *%rax
}
  80320b:	c9                   	leaveq 
  80320c:	c3                   	retq   

000000000080320d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80320d:	55                   	push   %rbp
  80320e:	48 89 e5             	mov    %rsp,%rbp
  803211:	48 83 ec 10          	sub    $0x10,%rsp
  803215:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803218:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80321b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80321e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803225:	00 00 00 
  803228:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80322b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80322d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803234:	00 00 00 
  803237:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80323d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803244:	00 00 00 
  803247:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80324a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80324d:	bf 09 00 00 00       	mov    $0x9,%edi
  803252:	48 b8 14 2e 80 00 00 	movabs $0x802e14,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
}
  80325e:	c9                   	leaveq 
  80325f:	c3                   	retq   

0000000000803260 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803260:	55                   	push   %rbp
  803261:	48 89 e5             	mov    %rsp,%rbp
  803264:	53                   	push   %rbx
  803265:	48 83 ec 38          	sub    $0x38,%rsp
  803269:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80326d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803271:	48 89 c7             	mov    %rax,%rdi
  803274:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80327b:	00 00 00 
  80327e:	ff d0                	callq  *%rax
  803280:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803283:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803287:	0f 88 bf 01 00 00    	js     80344c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80328d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803291:	ba 07 04 00 00       	mov    $0x407,%edx
  803296:	48 89 c6             	mov    %rax,%rsi
  803299:	bf 00 00 00 00       	mov    $0x0,%edi
  80329e:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8032a5:	00 00 00 
  8032a8:	ff d0                	callq  *%rax
  8032aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032b1:	0f 88 95 01 00 00    	js     80344c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8032b7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032d1:	0f 88 5d 01 00 00    	js     803434 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032db:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e0:	48 89 c6             	mov    %rax,%rsi
  8032e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032e8:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8032ef:	00 00 00 
  8032f2:	ff d0                	callq  *%rax
  8032f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032fb:	0f 88 33 01 00 00    	js     803434 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803305:	48 89 c7             	mov    %rax,%rdi
  803308:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
  803314:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803318:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80331c:	ba 07 04 00 00       	mov    $0x407,%edx
  803321:	48 89 c6             	mov    %rax,%rsi
  803324:	bf 00 00 00 00       	mov    $0x0,%edi
  803329:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  803330:	00 00 00 
  803333:	ff d0                	callq  *%rax
  803335:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803338:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80333c:	0f 88 d9 00 00 00    	js     80341b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803342:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803346:	48 89 c7             	mov    %rax,%rdi
  803349:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  803350:	00 00 00 
  803353:	ff d0                	callq  *%rax
  803355:	48 89 c2             	mov    %rax,%rdx
  803358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80335c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803362:	48 89 d1             	mov    %rdx,%rcx
  803365:	ba 00 00 00 00       	mov    $0x0,%edx
  80336a:	48 89 c6             	mov    %rax,%rsi
  80336d:	bf 00 00 00 00       	mov    $0x0,%edi
  803372:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
  80337e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803381:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803385:	78 79                	js     803400 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80338b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803392:	00 00 00 
  803395:	8b 12                	mov    (%rdx),%edx
  803397:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803399:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80339d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8033a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033a8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8033af:	00 00 00 
  8033b2:	8b 12                	mov    (%rdx),%edx
  8033b4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8033b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8033c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c5:	48 89 c7             	mov    %rax,%rdi
  8033c8:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	89 c2                	mov    %eax,%edx
  8033d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033da:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8033dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033e0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8033e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033e8:	48 89 c7             	mov    %rax,%rdi
  8033eb:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  8033f2:	00 00 00 
  8033f5:	ff d0                	callq  *%rax
  8033f7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8033f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fe:	eb 4f                	jmp    80344f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803400:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803401:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803405:	48 89 c6             	mov    %rax,%rsi
  803408:	bf 00 00 00 00       	mov    $0x0,%edi
  80340d:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  803414:	00 00 00 
  803417:	ff d0                	callq  *%rax
  803419:	eb 01                	jmp    80341c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80341b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  80341c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803420:	48 89 c6             	mov    %rax,%rsi
  803423:	bf 00 00 00 00       	mov    $0x0,%edi
  803428:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803438:	48 89 c6             	mov    %rax,%rsi
  80343b:	bf 00 00 00 00       	mov    $0x0,%edi
  803440:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  803447:	00 00 00 
  80344a:	ff d0                	callq  *%rax
    err:
	return r;
  80344c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80344f:	48 83 c4 38          	add    $0x38,%rsp
  803453:	5b                   	pop    %rbx
  803454:	5d                   	pop    %rbp
  803455:	c3                   	retq   

0000000000803456 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803456:	55                   	push   %rbp
  803457:	48 89 e5             	mov    %rsp,%rbp
  80345a:	53                   	push   %rbx
  80345b:	48 83 ec 28          	sub    $0x28,%rsp
  80345f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803463:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803467:	eb 01                	jmp    80346a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803469:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80346a:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803471:	00 00 00 
  803474:	48 8b 00             	mov    (%rax),%rax
  803477:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80347d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803484:	48 89 c7             	mov    %rax,%rdi
  803487:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  80348e:	00 00 00 
  803491:	ff d0                	callq  *%rax
  803493:	89 c3                	mov    %eax,%ebx
  803495:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803499:	48 89 c7             	mov    %rax,%rdi
  80349c:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	39 c3                	cmp    %eax,%ebx
  8034aa:	0f 94 c0             	sete   %al
  8034ad:	0f b6 c0             	movzbl %al,%eax
  8034b0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8034b3:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8034ba:	00 00 00 
  8034bd:	48 8b 00             	mov    (%rax),%rax
  8034c0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8034c6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8034c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034cc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034cf:	75 0a                	jne    8034db <_pipeisclosed+0x85>
			return ret;
  8034d1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8034d4:	48 83 c4 28          	add    $0x28,%rsp
  8034d8:	5b                   	pop    %rbx
  8034d9:	5d                   	pop    %rbp
  8034da:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8034db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034de:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8034e1:	74 86                	je     803469 <_pipeisclosed+0x13>
  8034e3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8034e7:	75 80                	jne    803469 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8034e9:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8034f0:	00 00 00 
  8034f3:	48 8b 00             	mov    (%rax),%rax
  8034f6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8034fc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803502:	89 c6                	mov    %eax,%esi
  803504:	48 bf 81 42 80 00 00 	movabs $0x804281,%rdi
  80350b:	00 00 00 
  80350e:	b8 00 00 00 00       	mov    $0x0,%eax
  803513:	49 b8 0f 03 80 00 00 	movabs $0x80030f,%r8
  80351a:	00 00 00 
  80351d:	41 ff d0             	callq  *%r8
	}
  803520:	e9 44 ff ff ff       	jmpq   803469 <_pipeisclosed+0x13>

0000000000803525 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803525:	55                   	push   %rbp
  803526:	48 89 e5             	mov    %rsp,%rbp
  803529:	48 83 ec 30          	sub    $0x30,%rsp
  80352d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803530:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803534:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803537:	48 89 d6             	mov    %rdx,%rsi
  80353a:	89 c7                	mov    %eax,%edi
  80353c:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80354b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354f:	79 05                	jns    803556 <pipeisclosed+0x31>
		return r;
  803551:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803554:	eb 31                	jmp    803587 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355a:	48 89 c7             	mov    %rax,%rdi
  80355d:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80356d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803575:	48 89 d6             	mov    %rdx,%rsi
  803578:	48 89 c7             	mov    %rax,%rdi
  80357b:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
}
  803587:	c9                   	leaveq 
  803588:	c3                   	retq   

0000000000803589 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803589:	55                   	push   %rbp
  80358a:	48 89 e5             	mov    %rsp,%rbp
  80358d:	48 83 ec 40          	sub    $0x40,%rsp
  803591:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803595:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803599:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80359d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a1:	48 89 c7             	mov    %rax,%rdi
  8035a4:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  8035ab:	00 00 00 
  8035ae:	ff d0                	callq  *%rax
  8035b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8035b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8035bc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8035c3:	00 
  8035c4:	e9 97 00 00 00       	jmpq   803660 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8035c9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8035ce:	74 09                	je     8035d9 <devpipe_read+0x50>
				return i;
  8035d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d4:	e9 95 00 00 00       	jmpq   80366e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8035d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035e1:	48 89 d6             	mov    %rdx,%rsi
  8035e4:	48 89 c7             	mov    %rax,%rdi
  8035e7:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  8035ee:	00 00 00 
  8035f1:	ff d0                	callq  *%rax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 07                	je     8035fe <devpipe_read+0x75>
				return 0;
  8035f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fc:	eb 70                	jmp    80366e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8035fe:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803605:	00 00 00 
  803608:	ff d0                	callq  *%rax
  80360a:	eb 01                	jmp    80360d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80360c:	90                   	nop
  80360d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803611:	8b 10                	mov    (%rax),%edx
  803613:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803617:	8b 40 04             	mov    0x4(%rax),%eax
  80361a:	39 c2                	cmp    %eax,%edx
  80361c:	74 ab                	je     8035c9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80361e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803622:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803626:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80362a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362e:	8b 00                	mov    (%rax),%eax
  803630:	89 c2                	mov    %eax,%edx
  803632:	c1 fa 1f             	sar    $0x1f,%edx
  803635:	c1 ea 1b             	shr    $0x1b,%edx
  803638:	01 d0                	add    %edx,%eax
  80363a:	83 e0 1f             	and    $0x1f,%eax
  80363d:	29 d0                	sub    %edx,%eax
  80363f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803643:	48 98                	cltq   
  803645:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80364a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80364c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803650:	8b 00                	mov    (%rax),%eax
  803652:	8d 50 01             	lea    0x1(%rax),%edx
  803655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803659:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80365b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803664:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803668:	72 a2                	jb     80360c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80366a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80366e:	c9                   	leaveq 
  80366f:	c3                   	retq   

0000000000803670 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803670:	55                   	push   %rbp
  803671:	48 89 e5             	mov    %rsp,%rbp
  803674:	48 83 ec 40          	sub    $0x40,%rsp
  803678:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80367c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803680:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803684:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803688:	48 89 c7             	mov    %rax,%rdi
  80368b:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  803692:	00 00 00 
  803695:	ff d0                	callq  *%rax
  803697:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80369b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80369f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8036a3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8036aa:	00 
  8036ab:	e9 93 00 00 00       	jmpq   803743 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8036b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b8:	48 89 d6             	mov    %rdx,%rsi
  8036bb:	48 89 c7             	mov    %rax,%rdi
  8036be:	48 b8 56 34 80 00 00 	movabs $0x803456,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 07                	je     8036d5 <devpipe_write+0x65>
				return 0;
  8036ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8036d3:	eb 7c                	jmp    803751 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8036d5:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
  8036e1:	eb 01                	jmp    8036e4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036e3:	90                   	nop
  8036e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e8:	8b 40 04             	mov    0x4(%rax),%eax
  8036eb:	48 63 d0             	movslq %eax,%rdx
  8036ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f2:	8b 00                	mov    (%rax),%eax
  8036f4:	48 98                	cltq   
  8036f6:	48 83 c0 20          	add    $0x20,%rax
  8036fa:	48 39 c2             	cmp    %rax,%rdx
  8036fd:	73 b1                	jae    8036b0 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8036ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803703:	8b 40 04             	mov    0x4(%rax),%eax
  803706:	89 c2                	mov    %eax,%edx
  803708:	c1 fa 1f             	sar    $0x1f,%edx
  80370b:	c1 ea 1b             	shr    $0x1b,%edx
  80370e:	01 d0                	add    %edx,%eax
  803710:	83 e0 1f             	and    $0x1f,%eax
  803713:	29 d0                	sub    %edx,%eax
  803715:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803719:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80371d:	48 01 ca             	add    %rcx,%rdx
  803720:	0f b6 0a             	movzbl (%rdx),%ecx
  803723:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803727:	48 98                	cltq   
  803729:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80372d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803731:	8b 40 04             	mov    0x4(%rax),%eax
  803734:	8d 50 01             	lea    0x1(%rax),%edx
  803737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80373b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80373e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803743:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803747:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80374b:	72 96                	jb     8036e3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80374d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803751:	c9                   	leaveq 
  803752:	c3                   	retq   

0000000000803753 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803753:	55                   	push   %rbp
  803754:	48 89 e5             	mov    %rsp,%rbp
  803757:	48 83 ec 20          	sub    $0x20,%rsp
  80375b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80375f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803767:	48 89 c7             	mov    %rax,%rdi
  80376a:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  803771:	00 00 00 
  803774:	ff d0                	callq  *%rax
  803776:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80377a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80377e:	48 be 94 42 80 00 00 	movabs $0x804294,%rsi
  803785:	00 00 00 
  803788:	48 89 c7             	mov    %rax,%rdi
  80378b:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  803792:	00 00 00 
  803795:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803797:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379b:	8b 50 04             	mov    0x4(%rax),%edx
  80379e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037a2:	8b 00                	mov    (%rax),%eax
  8037a4:	29 c2                	sub    %eax,%edx
  8037a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037aa:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8037b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037bb:	00 00 00 
	stat->st_dev = &devpipe;
  8037be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037c2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8037c9:	00 00 00 
  8037cc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8037d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d8:	c9                   	leaveq 
  8037d9:	c3                   	retq   

00000000008037da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8037da:	55                   	push   %rbp
  8037db:	48 89 e5             	mov    %rsp,%rbp
  8037de:	48 83 ec 10          	sub    $0x10,%rsp
  8037e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8037e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ea:	48 89 c6             	mov    %rax,%rsi
  8037ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f2:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8037f9:	00 00 00 
  8037fc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8037fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803802:	48 89 c7             	mov    %rax,%rdi
  803805:	48 b8 6f 1d 80 00 00 	movabs $0x801d6f,%rax
  80380c:	00 00 00 
  80380f:	ff d0                	callq  *%rax
  803811:	48 89 c6             	mov    %rax,%rsi
  803814:	bf 00 00 00 00       	mov    $0x0,%edi
  803819:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
}
  803825:	c9                   	leaveq 
  803826:	c3                   	retq   
	...

0000000000803828 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803828:	55                   	push   %rbp
  803829:	48 89 e5             	mov    %rsp,%rbp
  80382c:	48 83 ec 20          	sub    $0x20,%rsp
  803830:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803833:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803836:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803839:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80383d:	be 01 00 00 00       	mov    $0x1,%esi
  803842:	48 89 c7             	mov    %rax,%rdi
  803845:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  80384c:	00 00 00 
  80384f:	ff d0                	callq  *%rax
}
  803851:	c9                   	leaveq 
  803852:	c3                   	retq   

0000000000803853 <getchar>:

int
getchar(void)
{
  803853:	55                   	push   %rbp
  803854:	48 89 e5             	mov    %rsp,%rbp
  803857:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80385b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80385f:	ba 01 00 00 00       	mov    $0x1,%edx
  803864:	48 89 c6             	mov    %rax,%rsi
  803867:	bf 00 00 00 00       	mov    $0x0,%edi
  80386c:	48 b8 64 22 80 00 00 	movabs $0x802264,%rax
  803873:	00 00 00 
  803876:	ff d0                	callq  *%rax
  803878:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80387b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80387f:	79 05                	jns    803886 <getchar+0x33>
		return r;
  803881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803884:	eb 14                	jmp    80389a <getchar+0x47>
	if (r < 1)
  803886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80388a:	7f 07                	jg     803893 <getchar+0x40>
		return -E_EOF;
  80388c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803891:	eb 07                	jmp    80389a <getchar+0x47>
	return c;
  803893:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803897:	0f b6 c0             	movzbl %al,%eax
}
  80389a:	c9                   	leaveq 
  80389b:	c3                   	retq   

000000000080389c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80389c:	55                   	push   %rbp
  80389d:	48 89 e5             	mov    %rsp,%rbp
  8038a0:	48 83 ec 20          	sub    $0x20,%rsp
  8038a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038a7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8038ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ae:	48 89 d6             	mov    %rdx,%rsi
  8038b1:	89 c7                	mov    %eax,%edi
  8038b3:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  8038ba:	00 00 00 
  8038bd:	ff d0                	callq  *%rax
  8038bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c6:	79 05                	jns    8038cd <iscons+0x31>
		return r;
  8038c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038cb:	eb 1a                	jmp    8038e7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8038cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d1:	8b 10                	mov    (%rax),%edx
  8038d3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8038da:	00 00 00 
  8038dd:	8b 00                	mov    (%rax),%eax
  8038df:	39 c2                	cmp    %eax,%edx
  8038e1:	0f 94 c0             	sete   %al
  8038e4:	0f b6 c0             	movzbl %al,%eax
}
  8038e7:	c9                   	leaveq 
  8038e8:	c3                   	retq   

00000000008038e9 <opencons>:

int
opencons(void)
{
  8038e9:	55                   	push   %rbp
  8038ea:	48 89 e5             	mov    %rsp,%rbp
  8038ed:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8038f1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8038f5:	48 89 c7             	mov    %rax,%rdi
  8038f8:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8038ff:	00 00 00 
  803902:	ff d0                	callq  *%rax
  803904:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803907:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80390b:	79 05                	jns    803912 <opencons+0x29>
		return r;
  80390d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803910:	eb 5b                	jmp    80396d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803912:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803916:	ba 07 04 00 00       	mov    $0x407,%edx
  80391b:	48 89 c6             	mov    %rax,%rsi
  80391e:	bf 00 00 00 00       	mov    $0x0,%edi
  803923:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  80392a:	00 00 00 
  80392d:	ff d0                	callq  *%rax
  80392f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803932:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803936:	79 05                	jns    80393d <opencons+0x54>
		return r;
  803938:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393b:	eb 30                	jmp    80396d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80393d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803941:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803948:	00 00 00 
  80394b:	8b 12                	mov    (%rdx),%edx
  80394d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80394f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803953:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80395a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395e:	48 89 c7             	mov    %rax,%rdi
  803961:	48 b8 4c 1d 80 00 00 	movabs $0x801d4c,%rax
  803968:	00 00 00 
  80396b:	ff d0                	callq  *%rax
}
  80396d:	c9                   	leaveq 
  80396e:	c3                   	retq   

000000000080396f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80396f:	55                   	push   %rbp
  803970:	48 89 e5             	mov    %rsp,%rbp
  803973:	48 83 ec 30          	sub    $0x30,%rsp
  803977:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80397b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80397f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803983:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803988:	75 13                	jne    80399d <devcons_read+0x2e>
		return 0;
  80398a:	b8 00 00 00 00       	mov    $0x0,%eax
  80398f:	eb 49                	jmp    8039da <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803991:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80399d:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  8039a4:	00 00 00 
  8039a7:	ff d0                	callq  *%rax
  8039a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b0:	74 df                	je     803991 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8039b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b6:	79 05                	jns    8039bd <devcons_read+0x4e>
		return c;
  8039b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039bb:	eb 1d                	jmp    8039da <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8039bd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8039c1:	75 07                	jne    8039ca <devcons_read+0x5b>
		return 0;
  8039c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c8:	eb 10                	jmp    8039da <devcons_read+0x6b>
	*(char*)vbuf = c;
  8039ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cd:	89 c2                	mov    %eax,%edx
  8039cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039d3:	88 10                	mov    %dl,(%rax)
	return 1;
  8039d5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039da:	c9                   	leaveq 
  8039db:	c3                   	retq   

00000000008039dc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8039dc:	55                   	push   %rbp
  8039dd:	48 89 e5             	mov    %rsp,%rbp
  8039e0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8039e7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8039ee:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8039f5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8039fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a03:	eb 77                	jmp    803a7c <devcons_write+0xa0>
		m = n - tot;
  803a05:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803a0c:	89 c2                	mov    %eax,%edx
  803a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a11:	89 d1                	mov    %edx,%ecx
  803a13:	29 c1                	sub    %eax,%ecx
  803a15:	89 c8                	mov    %ecx,%eax
  803a17:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803a1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a1d:	83 f8 7f             	cmp    $0x7f,%eax
  803a20:	76 07                	jbe    803a29 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803a22:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803a29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a2c:	48 63 d0             	movslq %eax,%rdx
  803a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a32:	48 98                	cltq   
  803a34:	48 89 c1             	mov    %rax,%rcx
  803a37:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803a3e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a45:	48 89 ce             	mov    %rcx,%rsi
  803a48:	48 89 c7             	mov    %rax,%rdi
  803a4b:	48 b8 ee 11 80 00 00 	movabs $0x8011ee,%rax
  803a52:	00 00 00 
  803a55:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803a57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a5a:	48 63 d0             	movslq %eax,%rdx
  803a5d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803a64:	48 89 d6             	mov    %rdx,%rsi
  803a67:	48 89 c7             	mov    %rax,%rdi
  803a6a:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a79:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7f:	48 98                	cltq   
  803a81:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a88:	0f 82 77 ff ff ff    	jb     803a05 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a91:	c9                   	leaveq 
  803a92:	c3                   	retq   

0000000000803a93 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a93:	55                   	push   %rbp
  803a94:	48 89 e5             	mov    %rsp,%rbp
  803a97:	48 83 ec 08          	sub    $0x8,%rsp
  803a9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aa4:	c9                   	leaveq 
  803aa5:	c3                   	retq   

0000000000803aa6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803aa6:	55                   	push   %rbp
  803aa7:	48 89 e5             	mov    %rsp,%rbp
  803aaa:	48 83 ec 10          	sub    $0x10,%rsp
  803aae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ab2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aba:	48 be a0 42 80 00 00 	movabs $0x8042a0,%rsi
  803ac1:	00 00 00 
  803ac4:	48 89 c7             	mov    %rax,%rdi
  803ac7:	48 b8 cc 0e 80 00 00 	movabs $0x800ecc,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
	return 0;
  803ad3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad8:	c9                   	leaveq 
  803ad9:	c3                   	retq   
	...

0000000000803adc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803adc:	55                   	push   %rbp
  803add:	48 89 e5             	mov    %rsp,%rbp
  803ae0:	53                   	push   %rbx
  803ae1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ae8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803aef:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803af5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803afc:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803b03:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803b0a:	84 c0                	test   %al,%al
  803b0c:	74 23                	je     803b31 <_panic+0x55>
  803b0e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803b15:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803b19:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803b1d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803b21:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803b25:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803b29:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803b2d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803b31:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803b38:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803b3f:	00 00 00 
  803b42:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803b49:	00 00 00 
  803b4c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b50:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803b57:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803b5e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803b65:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803b6c:	00 00 00 
  803b6f:	48 8b 18             	mov    (%rax),%rbx
  803b72:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  803b79:	00 00 00 
  803b7c:	ff d0                	callq  *%rax
  803b7e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803b84:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b8b:	41 89 c8             	mov    %ecx,%r8d
  803b8e:	48 89 d1             	mov    %rdx,%rcx
  803b91:	48 89 da             	mov    %rbx,%rdx
  803b94:	89 c6                	mov    %eax,%esi
  803b96:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  803b9d:	00 00 00 
  803ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba5:	49 b9 0f 03 80 00 00 	movabs $0x80030f,%r9
  803bac:	00 00 00 
  803baf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803bb2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803bb9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803bc0:	48 89 d6             	mov    %rdx,%rsi
  803bc3:	48 89 c7             	mov    %rax,%rdi
  803bc6:	48 b8 63 02 80 00 00 	movabs $0x800263,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
	cprintf("\n");
  803bd2:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  803bd9:	00 00 00 
  803bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803be1:	48 ba 0f 03 80 00 00 	movabs $0x80030f,%rdx
  803be8:	00 00 00 
  803beb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803bed:	cc                   	int3   
  803bee:	eb fd                	jmp    803bed <_panic+0x111>

0000000000803bf0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 18          	sub    $0x18,%rsp
  803bf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c00:	48 89 c2             	mov    %rax,%rdx
  803c03:	48 c1 ea 15          	shr    $0x15,%rdx
  803c07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c0e:	01 00 00 
  803c11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c15:	83 e0 01             	and    $0x1,%eax
  803c18:	48 85 c0             	test   %rax,%rax
  803c1b:	75 07                	jne    803c24 <pageref+0x34>
		return 0;
  803c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c22:	eb 53                	jmp    803c77 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c28:	48 89 c2             	mov    %rax,%rdx
  803c2b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c36:	01 00 00 
  803c39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c45:	83 e0 01             	and    $0x1,%eax
  803c48:	48 85 c0             	test   %rax,%rax
  803c4b:	75 07                	jne    803c54 <pageref+0x64>
		return 0;
  803c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c52:	eb 23                	jmp    803c77 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c58:	48 89 c2             	mov    %rax,%rdx
  803c5b:	48 c1 ea 0c          	shr    $0xc,%rdx
  803c5f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c66:	00 00 00 
  803c69:	48 c1 e2 04          	shl    $0x4,%rdx
  803c6d:	48 01 d0             	add    %rdx,%rax
  803c70:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c74:	0f b7 c0             	movzwl %ax,%eax
}
  803c77:	c9                   	leaveq 
  803c78:	c3                   	retq   
