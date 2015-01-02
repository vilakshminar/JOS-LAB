
obj/user/pingpong.debug:     file format elf64-x86-64


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
  800048:	53                   	push   %rbx
  800049:	48 83 ec 28          	sub    $0x28,%rsp
  80004d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800050:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800054:	48 b8 07 1f 80 00 00 	movabs $0x801f07,%rax
  80005b:	00 00 00 
  80005e:	ff d0                	callq  *%rax
  800060:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800063:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800066:	85 c0                	test   %eax,%eax
  800068:	74 51                	je     8000bb <umain+0x77>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80006a:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006d:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 da                	mov    %ebx,%edx
  80007b:	89 c6                	mov    %eax,%esi
  80007d:	48 bf c0 44 80 00 00 	movabs $0x8044c0,%rdi
  800084:	00 00 00 
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  800093:	00 00 00 
  800096:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800098:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a5:	be 00 00 00 00       	mov    $0x0,%esi
  8000aa:	89 c7                	mov    %eax,%edi
  8000ac:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  8000b3:	00 00 00 
  8000b6:	ff d0                	callq  *%rax
  8000b8:	eb 01                	jmp    8000bb <umain+0x77>
			return;
		i++;
		ipc_send(who, i, 0, 0);
		if (i == 10)
			return;
	}
  8000ba:	90                   	nop
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000bb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c4:	be 00 00 00 00       	mov    $0x0,%esi
  8000c9:	48 89 c7             	mov    %rax,%rdi
  8000cc:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  8000d3:	00 00 00 
  8000d6:	ff d0                	callq  *%rax
  8000d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000db:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000de:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000ed:	89 d9                	mov    %ebx,%ecx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf d6 44 80 00 00 	movabs $0x8044d6,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	49 b8 3b 03 80 00 00 	movabs $0x80033b,%r8
  800107:	00 00 00 
  80010a:	41 ff d0             	callq  *%r8
		if (i == 10)
  80010d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800111:	74 2e                	je     800141 <umain+0xfd>
			return;
		i++;
  800113:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800117:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80011a:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800122:	ba 00 00 00 00       	mov    $0x0,%edx
  800127:	89 c7                	mov    %eax,%edi
  800129:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  800130:	00 00 00 
  800133:	ff d0                	callq  *%rax
		if (i == 10)
  800135:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800139:	0f 85 7b ff ff ff    	jne    8000ba <umain+0x76>
			return;
  80013f:	eb 01                	jmp    800142 <umain+0xfe>

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
		if (i == 10)
			return;
  800141:	90                   	nop
		ipc_send(who, i, 0, 0);
		if (i == 10)
			return;
	}

}
  800142:	48 83 c4 28          	add    $0x28,%rsp
  800146:	5b                   	pop    %rbx
  800147:	5d                   	pop    %rbp
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
  8001f4:	48 b8 7d 27 80 00 00 	movabs $0x80277d,%rax
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
  8004aa:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
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
  8007a4:	48 b8 f0 46 80 00 00 	movabs $0x8046f0,%rax
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
  8008f4:	48 b8 40 46 80 00 00 	movabs $0x804640,%rax
  8008fb:	00 00 00 
  8008fe:	48 63 d3             	movslq %ebx,%rdx
  800901:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800905:	4d 85 e4             	test   %r12,%r12
  800908:	75 2e                	jne    800938 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80090a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80090e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800912:	89 d9                	mov    %ebx,%ecx
  800914:	48 ba d9 46 80 00 00 	movabs $0x8046d9,%rdx
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
  800943:	48 ba e2 46 80 00 00 	movabs $0x8046e2,%rdx
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
  80099d:	49 bc e5 46 80 00 00 	movabs $0x8046e5,%r12
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
  8016b2:	48 ba a0 49 80 00 00 	movabs $0x8049a0,%rdx
  8016b9:	00 00 00 
  8016bc:	be 23 00 00 00       	mov    $0x23,%esi
  8016c1:	48 bf bd 49 80 00 00 	movabs $0x8049bd,%rdi
  8016c8:	00 00 00 
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	49 b9 cc 41 80 00 00 	movabs $0x8041cc,%r9
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
  801bbf:	48 ba d0 49 80 00 00 	movabs $0x8049d0,%rdx
  801bc6:	00 00 00 
  801bc9:	be 1c 00 00 00       	mov    $0x1c,%esi
  801bce:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801bd5:	00 00 00 
  801bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdd:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
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
  801c12:	48 ba 10 4a 80 00 00 	movabs $0x804a10,%rdx
  801c19:	00 00 00 
  801c1c:	be 26 00 00 00       	mov    $0x26,%esi
  801c21:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801c28:	00 00 00 
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c30:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  801cac:	48 ba 38 4a 80 00 00 	movabs $0x804a38,%rdx
  801cb3:	00 00 00 
  801cb6:	be 2b 00 00 00       	mov    $0x2b,%esi
  801cbb:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801cc2:	00 00 00 
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cca:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  801cfb:	48 ba 60 4a 80 00 00 	movabs $0x804a60,%rdx
  801d02:	00 00 00 
  801d05:	be 2e 00 00 00       	mov    $0x2e,%esi
  801d0a:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801d11:	00 00 00 
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
  801d19:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  801da0:	48 ba 88 4a 80 00 00 	movabs $0x804a88,%rdx
  801da7:	00 00 00 
  801daa:	be 4d 00 00 00       	mov    $0x4d,%esi
  801daf:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801db6:	00 00 00 
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
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
  801e1d:	48 ba b8 4a 80 00 00 	movabs $0x804ab8,%rdx
  801e24:	00 00 00 
  801e27:	be 56 00 00 00       	mov    $0x56,%esi
  801e2c:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801e33:	00 00 00 
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3b:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
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
  801e7e:	48 ba b8 4a 80 00 00 	movabs $0x804ab8,%rdx
  801e85:	00 00 00 
  801e88:	be 59 00 00 00       	mov    $0x59,%esi
  801e8d:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801e94:	00 00 00 
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9c:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
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
  801ed6:	48 ba f0 4a 80 00 00 	movabs $0x804af0,%rdx
  801edd:	00 00 00 
  801ee0:	be 60 00 00 00       	mov    $0x60,%esi
  801ee5:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801eec:	00 00 00 
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
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
  801f1a:	48 b8 e0 42 80 00 00 	movabs $0x8042e0,%rax
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
  801f48:	48 ba 14 4b 80 00 00 	movabs $0x804b14,%rdx
  801f4f:	00 00 00 
  801f52:	be 7f 00 00 00       	mov    $0x7f,%esi
  801f57:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  801f5e:	00 00 00 
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  801fee:	48 ba 28 4b 80 00 00 	movabs $0x804b28,%rdx
  801ff5:	00 00 00 
  801ff8:	be 8b 00 00 00       	mov    $0x8b,%esi
  801ffd:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  802004:	00 00 00 
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  80215a:	48 be a4 43 80 00 00 	movabs $0x8043a4,%rsi
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
  802180:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  802187:	00 00 00 
  80218a:	be ad 00 00 00       	mov    $0xad,%esi
  80218f:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  802196:	00 00 00 
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  8021cf:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  8021d6:	00 00 00 
  8021d9:	be b0 00 00 00       	mov    $0xb0,%esi
  8021de:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  8021e5:	00 00 00 
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
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
  802208:	48 ba 9c 4b 80 00 00 	movabs $0x804b9c,%rdx
  80220f:	00 00 00 
  802212:	be b8 00 00 00       	mov    $0xb8,%esi
  802217:	48 bf 05 4a 80 00 00 	movabs $0x804a05,%rdi
  80221e:	00 00 00 
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
  80222d:	00 00 00 
  802230:	ff d1                	callq  *%rcx
	...

0000000000802234 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	48 83 ec 30          	sub    $0x30,%rsp
  80223c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802240:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802244:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  802248:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80224d:	74 18                	je     802267 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80224f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802253:	48 89 c7             	mov    %rax,%rdi
  802256:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  80225d:	00 00 00 
  802260:	ff d0                	callq  *%rax
  802262:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802265:	eb 19                	jmp    802280 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802267:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80226e:	00 00 00 
  802271:	48 b8 59 1a 80 00 00 	movabs $0x801a59,%rax
  802278:	00 00 00 
  80227b:	ff d0                	callq  *%rax
  80227d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  802280:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802284:	79 19                	jns    80229f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  802286:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  802290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802294:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80229a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229d:	eb 53                	jmp    8022f2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80229f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022a4:	74 19                	je     8022bf <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8022a6:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8022ad:	00 00 00 
  8022b0:	48 8b 00             	mov    (%rax),%rax
  8022b3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8022bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8022c4:	74 19                	je     8022df <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8022c6:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8022cd:	00 00 00 
  8022d0:	48 8b 00             	mov    (%rax),%rax
  8022d3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8022d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022dd:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8022df:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8022e6:	00 00 00 
  8022e9:	48 8b 00             	mov    (%rax),%rax
  8022ec:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8022f2:	c9                   	leaveq 
  8022f3:	c3                   	retq   

00000000008022f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022f4:	55                   	push   %rbp
  8022f5:	48 89 e5             	mov    %rsp,%rbp
  8022f8:	48 83 ec 30          	sub    $0x30,%rsp
  8022fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022ff:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802302:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802306:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802309:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  802310:	e9 96 00 00 00       	jmpq   8023ab <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802315:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80231a:	74 20                	je     80233c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  80231c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80231f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802322:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802326:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802329:	89 c7                	mov    %eax,%edi
  80232b:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
  802337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233a:	eb 2d                	jmp    802369 <ipc_send+0x75>
		else if(pg==NULL)
  80233c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802341:	75 26                	jne    802369 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  802343:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802346:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802349:	b9 00 00 00 00       	mov    $0x0,%ecx
  80234e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802355:	00 00 00 
  802358:	89 c7                	mov    %eax,%edi
  80235a:	48 b8 04 1a 80 00 00 	movabs $0x801a04,%rax
  802361:	00 00 00 
  802364:	ff d0                	callq  *%rax
  802366:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802369:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236d:	79 30                	jns    80239f <ipc_send+0xab>
  80236f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802373:	74 2a                	je     80239f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  802375:	48 ba b2 4b 80 00 00 	movabs $0x804bb2,%rdx
  80237c:	00 00 00 
  80237f:	be 40 00 00 00       	mov    $0x40,%esi
  802384:	48 bf ca 4b 80 00 00 	movabs $0x804bca,%rdi
  80238b:	00 00 00 
  80238e:	b8 00 00 00 00       	mov    $0x0,%eax
  802393:	48 b9 cc 41 80 00 00 	movabs $0x8041cc,%rcx
  80239a:	00 00 00 
  80239d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80239f:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8023ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023af:	0f 85 60 ff ff ff    	jne    802315 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8023b5:	c9                   	leaveq 
  8023b6:	c3                   	retq   

00000000008023b7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023b7:	55                   	push   %rbp
  8023b8:	48 89 e5             	mov    %rsp,%rbp
  8023bb:	48 83 ec 18          	sub    $0x18,%rsp
  8023bf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8023c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023c9:	eb 5e                	jmp    802429 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8023cb:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8023d2:	00 00 00 
  8023d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d8:	48 63 d0             	movslq %eax,%rdx
  8023db:	48 89 d0             	mov    %rdx,%rax
  8023de:	48 c1 e0 03          	shl    $0x3,%rax
  8023e2:	48 01 d0             	add    %rdx,%rax
  8023e5:	48 c1 e0 05          	shl    $0x5,%rax
  8023e9:	48 01 c8             	add    %rcx,%rax
  8023ec:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8023f2:	8b 00                	mov    (%rax),%eax
  8023f4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023f7:	75 2c                	jne    802425 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8023f9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802400:	00 00 00 
  802403:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802406:	48 63 d0             	movslq %eax,%rdx
  802409:	48 89 d0             	mov    %rdx,%rax
  80240c:	48 c1 e0 03          	shl    $0x3,%rax
  802410:	48 01 d0             	add    %rdx,%rax
  802413:	48 c1 e0 05          	shl    $0x5,%rax
  802417:	48 01 c8             	add    %rcx,%rax
  80241a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802420:	8b 40 08             	mov    0x8(%rax),%eax
  802423:	eb 12                	jmp    802437 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802425:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802429:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802430:	7e 99                	jle    8023cb <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802437:	c9                   	leaveq 
  802438:	c3                   	retq   
  802439:	00 00                	add    %al,(%rax)
	...

000000000080243c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80243c:	55                   	push   %rbp
  80243d:	48 89 e5             	mov    %rsp,%rbp
  802440:	48 83 ec 08          	sub    $0x8,%rsp
  802444:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802448:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80244c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802453:	ff ff ff 
  802456:	48 01 d0             	add    %rdx,%rax
  802459:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80245d:	c9                   	leaveq 
  80245e:	c3                   	retq   

000000000080245f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80245f:	55                   	push   %rbp
  802460:	48 89 e5             	mov    %rsp,%rbp
  802463:	48 83 ec 08          	sub    $0x8,%rsp
  802467:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80246b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246f:	48 89 c7             	mov    %rax,%rdi
  802472:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  802479:	00 00 00 
  80247c:	ff d0                	callq  *%rax
  80247e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802484:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 18          	sub    $0x18,%rsp
  802492:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802496:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80249d:	eb 6b                	jmp    80250a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80249f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a2:	48 98                	cltq   
  8024a4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024aa:	48 c1 e0 0c          	shl    $0xc,%rax
  8024ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8024b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b6:	48 89 c2             	mov    %rax,%rdx
  8024b9:	48 c1 ea 15          	shr    $0x15,%rdx
  8024bd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024c4:	01 00 00 
  8024c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024cb:	83 e0 01             	and    $0x1,%eax
  8024ce:	48 85 c0             	test   %rax,%rax
  8024d1:	74 21                	je     8024f4 <fd_alloc+0x6a>
  8024d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d7:	48 89 c2             	mov    %rax,%rdx
  8024da:	48 c1 ea 0c          	shr    $0xc,%rdx
  8024de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024e5:	01 00 00 
  8024e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ec:	83 e0 01             	and    $0x1,%eax
  8024ef:	48 85 c0             	test   %rax,%rax
  8024f2:	75 12                	jne    802506 <fd_alloc+0x7c>
			*fd_store = fd;
  8024f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	eb 1a                	jmp    802520 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802506:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80250a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80250e:	7e 8f                	jle    80249f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80251b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802520:	c9                   	leaveq 
  802521:	c3                   	retq   

0000000000802522 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802522:	55                   	push   %rbp
  802523:	48 89 e5             	mov    %rsp,%rbp
  802526:	48 83 ec 20          	sub    $0x20,%rsp
  80252a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80252d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802531:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802535:	78 06                	js     80253d <fd_lookup+0x1b>
  802537:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80253b:	7e 07                	jle    802544 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80253d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802542:	eb 6c                	jmp    8025b0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802544:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802547:	48 98                	cltq   
  802549:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80254f:	48 c1 e0 0c          	shl    $0xc,%rax
  802553:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80255b:	48 89 c2             	mov    %rax,%rdx
  80255e:	48 c1 ea 15          	shr    $0x15,%rdx
  802562:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802569:	01 00 00 
  80256c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802570:	83 e0 01             	and    $0x1,%eax
  802573:	48 85 c0             	test   %rax,%rax
  802576:	74 21                	je     802599 <fd_lookup+0x77>
  802578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80257c:	48 89 c2             	mov    %rax,%rdx
  80257f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802583:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80258a:	01 00 00 
  80258d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802591:	83 e0 01             	and    $0x1,%eax
  802594:	48 85 c0             	test   %rax,%rax
  802597:	75 07                	jne    8025a0 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802599:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80259e:	eb 10                	jmp    8025b0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025a8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b0:	c9                   	leaveq 
  8025b1:	c3                   	retq   

00000000008025b2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8025b2:	55                   	push   %rbp
  8025b3:	48 89 e5             	mov    %rsp,%rbp
  8025b6:	48 83 ec 30          	sub    $0x30,%rsp
  8025ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8025be:	89 f0                	mov    %esi,%eax
  8025c0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8025c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c7:	48 89 c7             	mov    %rax,%rdi
  8025ca:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  8025d1:	00 00 00 
  8025d4:	ff d0                	callq  *%rax
  8025d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025da:	48 89 d6             	mov    %rdx,%rsi
  8025dd:	89 c7                	mov    %eax,%edi
  8025df:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax
  8025eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f2:	78 0a                	js     8025fe <fd_close+0x4c>
	    || fd != fd2)
  8025f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025fc:	74 12                	je     802610 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8025fe:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802602:	74 05                	je     802609 <fd_close+0x57>
  802604:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802607:	eb 05                	jmp    80260e <fd_close+0x5c>
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
  80260e:	eb 69                	jmp    802679 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802614:	8b 00                	mov    (%rax),%eax
  802616:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80261a:	48 89 d6             	mov    %rdx,%rsi
  80261d:	89 c7                	mov    %eax,%edi
  80261f:	48 b8 7b 26 80 00 00 	movabs $0x80267b,%rax
  802626:	00 00 00 
  802629:	ff d0                	callq  *%rax
  80262b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80262e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802632:	78 2a                	js     80265e <fd_close+0xac>
		if (dev->dev_close)
  802634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802638:	48 8b 40 20          	mov    0x20(%rax),%rax
  80263c:	48 85 c0             	test   %rax,%rax
  80263f:	74 16                	je     802657 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802645:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802649:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80264d:	48 89 c7             	mov    %rax,%rdi
  802650:	ff d2                	callq  *%rdx
  802652:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802655:	eb 07                	jmp    80265e <fd_close+0xac>
		else
			r = 0;
  802657:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80265e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802662:	48 89 c6             	mov    %rax,%rsi
  802665:	bf 00 00 00 00       	mov    $0x0,%edi
  80266a:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  802671:	00 00 00 
  802674:	ff d0                	callq  *%rax
	return r;
  802676:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802679:	c9                   	leaveq 
  80267a:	c3                   	retq   

000000000080267b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80267b:	55                   	push   %rbp
  80267c:	48 89 e5             	mov    %rsp,%rbp
  80267f:	48 83 ec 20          	sub    $0x20,%rsp
  802683:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802686:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80268a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802691:	eb 41                	jmp    8026d4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802693:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80269a:	00 00 00 
  80269d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026a0:	48 63 d2             	movslq %edx,%rdx
  8026a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a7:	8b 00                	mov    (%rax),%eax
  8026a9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8026ac:	75 22                	jne    8026d0 <dev_lookup+0x55>
			*dev = devtab[i];
  8026ae:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026b5:	00 00 00 
  8026b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026bb:	48 63 d2             	movslq %edx,%rdx
  8026be:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026c6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb 60                	jmp    802730 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8026d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026d4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8026db:	00 00 00 
  8026de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026e1:	48 63 d2             	movslq %edx,%rdx
  8026e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e8:	48 85 c0             	test   %rax,%rax
  8026eb:	75 a6                	jne    802693 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8026ed:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8026f4:	00 00 00 
  8026f7:	48 8b 00             	mov    (%rax),%rax
  8026fa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802700:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802703:	89 c6                	mov    %eax,%esi
  802705:	48 bf d8 4b 80 00 00 	movabs $0x804bd8,%rdi
  80270c:	00 00 00 
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
  802714:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  80271b:	00 00 00 
  80271e:	ff d1                	callq  *%rcx
	*dev = 0;
  802720:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802724:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80272b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802730:	c9                   	leaveq 
  802731:	c3                   	retq   

0000000000802732 <close>:

int
close(int fdnum)
{
  802732:	55                   	push   %rbp
  802733:	48 89 e5             	mov    %rsp,%rbp
  802736:	48 83 ec 20          	sub    $0x20,%rsp
  80273a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80273d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802741:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802744:	48 89 d6             	mov    %rdx,%rsi
  802747:	89 c7                	mov    %eax,%edi
  802749:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802750:	00 00 00 
  802753:	ff d0                	callq  *%rax
  802755:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275c:	79 05                	jns    802763 <close+0x31>
		return r;
  80275e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802761:	eb 18                	jmp    80277b <close+0x49>
	else
		return fd_close(fd, 1);
  802763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802767:	be 01 00 00 00       	mov    $0x1,%esi
  80276c:	48 89 c7             	mov    %rax,%rdi
  80276f:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  802776:	00 00 00 
  802779:	ff d0                	callq  *%rax
}
  80277b:	c9                   	leaveq 
  80277c:	c3                   	retq   

000000000080277d <close_all>:

void
close_all(void)
{
  80277d:	55                   	push   %rbp
  80277e:	48 89 e5             	mov    %rsp,%rbp
  802781:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802785:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80278c:	eb 15                	jmp    8027a3 <close_all+0x26>
		close(i);
  80278e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802791:	89 c7                	mov    %eax,%edi
  802793:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  80279a:	00 00 00 
  80279d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80279f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027a3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027a7:	7e e5                	jle    80278e <close_all+0x11>
		close(i);
}
  8027a9:	c9                   	leaveq 
  8027aa:	c3                   	retq   

00000000008027ab <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8027ab:	55                   	push   %rbp
  8027ac:	48 89 e5             	mov    %rsp,%rbp
  8027af:	48 83 ec 40          	sub    $0x40,%rsp
  8027b3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8027b6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8027b9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8027bd:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8027c0:	48 89 d6             	mov    %rdx,%rsi
  8027c3:	89 c7                	mov    %eax,%edi
  8027c5:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  8027cc:	00 00 00 
  8027cf:	ff d0                	callq  *%rax
  8027d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d8:	79 08                	jns    8027e2 <dup+0x37>
		return r;
  8027da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027dd:	e9 70 01 00 00       	jmpq   802952 <dup+0x1a7>
	close(newfdnum);
  8027e2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027e5:	89 c7                	mov    %eax,%edi
  8027e7:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  8027ee:	00 00 00 
  8027f1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8027f3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8027f6:	48 98                	cltq   
  8027f8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027fe:	48 c1 e0 0c          	shl    $0xc,%rax
  802802:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802806:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80280a:	48 89 c7             	mov    %rax,%rdi
  80280d:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  802814:	00 00 00 
  802817:	ff d0                	callq  *%rax
  802819:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80281d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802821:	48 89 c7             	mov    %rax,%rdi
  802824:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  80282b:	00 00 00 
  80282e:	ff d0                	callq  *%rax
  802830:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802834:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802838:	48 89 c2             	mov    %rax,%rdx
  80283b:	48 c1 ea 15          	shr    $0x15,%rdx
  80283f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802846:	01 00 00 
  802849:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284d:	83 e0 01             	and    $0x1,%eax
  802850:	84 c0                	test   %al,%al
  802852:	74 71                	je     8028c5 <dup+0x11a>
  802854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802858:	48 89 c2             	mov    %rax,%rdx
  80285b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80285f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802866:	01 00 00 
  802869:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286d:	83 e0 01             	and    $0x1,%eax
  802870:	84 c0                	test   %al,%al
  802872:	74 51                	je     8028c5 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	48 89 c2             	mov    %rax,%rdx
  80287b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80287f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802886:	01 00 00 
  802889:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80288d:	89 c1                	mov    %eax,%ecx
  80288f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802895:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289d:	41 89 c8             	mov    %ecx,%r8d
  8028a0:	48 89 d1             	mov    %rdx,%rcx
  8028a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8028a8:	48 89 c6             	mov    %rax,%rsi
  8028ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8028b0:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  8028b7:	00 00 00 
  8028ba:	ff d0                	callq  *%rax
  8028bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c3:	78 56                	js     80291b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8028c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028c9:	48 89 c2             	mov    %rax,%rdx
  8028cc:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028d0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028d7:	01 00 00 
  8028da:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028de:	89 c1                	mov    %eax,%ecx
  8028e0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8028e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028ee:	41 89 c8             	mov    %ecx,%r8d
  8028f1:	48 89 d1             	mov    %rdx,%rcx
  8028f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028f9:	48 89 c6             	mov    %rax,%rsi
  8028fc:	bf 00 00 00 00       	mov    $0x0,%edi
  802901:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
  80290d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802910:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802914:	78 08                	js     80291e <dup+0x173>
		goto err;

	return newfdnum;
  802916:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802919:	eb 37                	jmp    802952 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80291b:	90                   	nop
  80291c:	eb 01                	jmp    80291f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80291e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80291f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802923:	48 89 c6             	mov    %rax,%rsi
  802926:	bf 00 00 00 00       	mov    $0x0,%edi
  80292b:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  802932:	00 00 00 
  802935:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80293b:	48 89 c6             	mov    %rax,%rsi
  80293e:	bf 00 00 00 00       	mov    $0x0,%edi
  802943:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
	return r;
  80294f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802952:	c9                   	leaveq 
  802953:	c3                   	retq   

0000000000802954 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802954:	55                   	push   %rbp
  802955:	48 89 e5             	mov    %rsp,%rbp
  802958:	48 83 ec 40          	sub    $0x40,%rsp
  80295c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80295f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802963:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802967:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80296b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80296e:	48 89 d6             	mov    %rdx,%rsi
  802971:	89 c7                	mov    %eax,%edi
  802973:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
  80297f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802986:	78 24                	js     8029ac <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802988:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298c:	8b 00                	mov    (%rax),%eax
  80298e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802992:	48 89 d6             	mov    %rdx,%rsi
  802995:	89 c7                	mov    %eax,%edi
  802997:	48 b8 7b 26 80 00 00 	movabs $0x80267b,%rax
  80299e:	00 00 00 
  8029a1:	ff d0                	callq  *%rax
  8029a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029aa:	79 05                	jns    8029b1 <read+0x5d>
		return r;
  8029ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029af:	eb 7a                	jmp    802a2b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8029b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b5:	8b 40 08             	mov    0x8(%rax),%eax
  8029b8:	83 e0 03             	and    $0x3,%eax
  8029bb:	83 f8 01             	cmp    $0x1,%eax
  8029be:	75 3a                	jne    8029fa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8029c0:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8029c7:	00 00 00 
  8029ca:	48 8b 00             	mov    (%rax),%rax
  8029cd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8029d3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029d6:	89 c6                	mov    %eax,%esi
  8029d8:	48 bf f7 4b 80 00 00 	movabs $0x804bf7,%rdi
  8029df:	00 00 00 
  8029e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e7:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  8029ee:	00 00 00 
  8029f1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8029f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029f8:	eb 31                	jmp    802a2b <read+0xd7>
	}
	if (!dev->dev_read)
  8029fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a02:	48 85 c0             	test   %rax,%rax
  802a05:	75 07                	jne    802a0e <read+0xba>
		return -E_NOT_SUPP;
  802a07:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a0c:	eb 1d                	jmp    802a2b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802a0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a12:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a1e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a22:	48 89 ce             	mov    %rcx,%rsi
  802a25:	48 89 c7             	mov    %rax,%rdi
  802a28:	41 ff d0             	callq  *%r8
}
  802a2b:	c9                   	leaveq 
  802a2c:	c3                   	retq   

0000000000802a2d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a2d:	55                   	push   %rbp
  802a2e:	48 89 e5             	mov    %rsp,%rbp
  802a31:	48 83 ec 30          	sub    $0x30,%rsp
  802a35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a47:	eb 46                	jmp    802a8f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802a49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4c:	48 98                	cltq   
  802a4e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a52:	48 29 c2             	sub    %rax,%rdx
  802a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a58:	48 98                	cltq   
  802a5a:	48 89 c1             	mov    %rax,%rcx
  802a5d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802a61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a64:	48 89 ce             	mov    %rcx,%rsi
  802a67:	89 c7                	mov    %eax,%edi
  802a69:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  802a70:	00 00 00 
  802a73:	ff d0                	callq  *%rax
  802a75:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802a78:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a7c:	79 05                	jns    802a83 <readn+0x56>
			return m;
  802a7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a81:	eb 1d                	jmp    802aa0 <readn+0x73>
		if (m == 0)
  802a83:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a87:	74 13                	je     802a9c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a8c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a92:	48 98                	cltq   
  802a94:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a98:	72 af                	jb     802a49 <readn+0x1c>
  802a9a:	eb 01                	jmp    802a9d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802a9c:	90                   	nop
	}
	return tot;
  802a9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aa0:	c9                   	leaveq 
  802aa1:	c3                   	retq   

0000000000802aa2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802aa2:	55                   	push   %rbp
  802aa3:	48 89 e5             	mov    %rsp,%rbp
  802aa6:	48 83 ec 40          	sub    $0x40,%rsp
  802aaa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ab1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ab5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ab9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802abc:	48 89 d6             	mov    %rdx,%rsi
  802abf:	89 c7                	mov    %eax,%edi
  802ac1:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	callq  *%rax
  802acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad4:	78 24                	js     802afa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ada:	8b 00                	mov    (%rax),%eax
  802adc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ae0:	48 89 d6             	mov    %rdx,%rsi
  802ae3:	89 c7                	mov    %eax,%edi
  802ae5:	48 b8 7b 26 80 00 00 	movabs $0x80267b,%rax
  802aec:	00 00 00 
  802aef:	ff d0                	callq  *%rax
  802af1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af8:	79 05                	jns    802aff <write+0x5d>
		return r;
  802afa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afd:	eb 79                	jmp    802b78 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b03:	8b 40 08             	mov    0x8(%rax),%eax
  802b06:	83 e0 03             	and    $0x3,%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	75 3a                	jne    802b47 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b0d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802b14:	00 00 00 
  802b17:	48 8b 00             	mov    (%rax),%rax
  802b1a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b20:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b23:	89 c6                	mov    %eax,%esi
  802b25:	48 bf 13 4c 80 00 00 	movabs $0x804c13,%rdi
  802b2c:	00 00 00 
  802b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b34:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  802b3b:	00 00 00 
  802b3e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b45:	eb 31                	jmp    802b78 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b4b:	48 8b 40 18          	mov    0x18(%rax),%rax
  802b4f:	48 85 c0             	test   %rax,%rax
  802b52:	75 07                	jne    802b5b <write+0xb9>
		return -E_NOT_SUPP;
  802b54:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b59:	eb 1d                	jmp    802b78 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802b5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b5f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b6b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b6f:	48 89 ce             	mov    %rcx,%rsi
  802b72:	48 89 c7             	mov    %rax,%rdi
  802b75:	41 ff d0             	callq  *%r8
}
  802b78:	c9                   	leaveq 
  802b79:	c3                   	retq   

0000000000802b7a <seek>:

int
seek(int fdnum, off_t offset)
{
  802b7a:	55                   	push   %rbp
  802b7b:	48 89 e5             	mov    %rsp,%rbp
  802b7e:	48 83 ec 18          	sub    $0x18,%rsp
  802b82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b85:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8f:	48 89 d6             	mov    %rdx,%rsi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802b9b:	00 00 00 
  802b9e:	ff d0                	callq  *%rax
  802ba0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba7:	79 05                	jns    802bae <seek+0x34>
		return r;
  802ba9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bac:	eb 0f                	jmp    802bbd <seek+0x43>
	fd->fd_offset = offset;
  802bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbd:	c9                   	leaveq 
  802bbe:	c3                   	retq   

0000000000802bbf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802bbf:	55                   	push   %rbp
  802bc0:	48 89 e5             	mov    %rsp,%rbp
  802bc3:	48 83 ec 30          	sub    $0x30,%rsp
  802bc7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bca:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bcd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bd1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bd4:	48 89 d6             	mov    %rdx,%rsi
  802bd7:	89 c7                	mov    %eax,%edi
  802bd9:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bec:	78 24                	js     802c12 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf2:	8b 00                	mov    (%rax),%eax
  802bf4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bf8:	48 89 d6             	mov    %rdx,%rsi
  802bfb:	89 c7                	mov    %eax,%edi
  802bfd:	48 b8 7b 26 80 00 00 	movabs $0x80267b,%rax
  802c04:	00 00 00 
  802c07:	ff d0                	callq  *%rax
  802c09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c10:	79 05                	jns    802c17 <ftruncate+0x58>
		return r;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	eb 72                	jmp    802c89 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1b:	8b 40 08             	mov    0x8(%rax),%eax
  802c1e:	83 e0 03             	and    $0x3,%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	75 3a                	jne    802c5f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c25:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802c2c:	00 00 00 
  802c2f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c32:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c38:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c3b:	89 c6                	mov    %eax,%esi
  802c3d:	48 bf 30 4c 80 00 00 	movabs $0x804c30,%rdi
  802c44:	00 00 00 
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	48 b9 3b 03 80 00 00 	movabs $0x80033b,%rcx
  802c53:	00 00 00 
  802c56:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802c58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c5d:	eb 2a                	jmp    802c89 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c63:	48 8b 40 30          	mov    0x30(%rax),%rax
  802c67:	48 85 c0             	test   %rax,%rax
  802c6a:	75 07                	jne    802c73 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802c6c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c71:	eb 16                	jmp    802c89 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c77:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802c7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802c82:	89 d6                	mov    %edx,%esi
  802c84:	48 89 c7             	mov    %rax,%rdi
  802c87:	ff d1                	callq  *%rcx
}
  802c89:	c9                   	leaveq 
  802c8a:	c3                   	retq   

0000000000802c8b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c8b:	55                   	push   %rbp
  802c8c:	48 89 e5             	mov    %rsp,%rbp
  802c8f:	48 83 ec 30          	sub    $0x30,%rsp
  802c93:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c96:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c9a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c9e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ca1:	48 89 d6             	mov    %rdx,%rsi
  802ca4:	89 c7                	mov    %eax,%edi
  802ca6:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb9:	78 24                	js     802cdf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbf:	8b 00                	mov    (%rax),%eax
  802cc1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cc5:	48 89 d6             	mov    %rdx,%rsi
  802cc8:	89 c7                	mov    %eax,%edi
  802cca:	48 b8 7b 26 80 00 00 	movabs $0x80267b,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
  802cd6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cd9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cdd:	79 05                	jns    802ce4 <fstat+0x59>
		return r;
  802cdf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce2:	eb 5e                	jmp    802d42 <fstat+0xb7>
	if (!dev->dev_stat)
  802ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce8:	48 8b 40 28          	mov    0x28(%rax),%rax
  802cec:	48 85 c0             	test   %rax,%rax
  802cef:	75 07                	jne    802cf8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802cf1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf6:	eb 4a                	jmp    802d42 <fstat+0xb7>
	stat->st_name[0] = 0;
  802cf8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cfc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802cff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d03:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d0a:	00 00 00 
	stat->st_isdir = 0;
  802d0d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d11:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d18:	00 00 00 
	stat->st_dev = dev;
  802d1b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d23:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d2e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802d32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d36:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802d3a:	48 89 d6             	mov    %rdx,%rsi
  802d3d:	48 89 c7             	mov    %rax,%rdi
  802d40:	ff d1                	callq  *%rcx
}
  802d42:	c9                   	leaveq 
  802d43:	c3                   	retq   

0000000000802d44 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d44:	55                   	push   %rbp
  802d45:	48 89 e5             	mov    %rsp,%rbp
  802d48:	48 83 ec 20          	sub    $0x20,%rsp
  802d4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d58:	be 00 00 00 00       	mov    $0x0,%esi
  802d5d:	48 89 c7             	mov    %rax,%rdi
  802d60:	48 b8 33 2e 80 00 00 	movabs $0x802e33,%rax
  802d67:	00 00 00 
  802d6a:	ff d0                	callq  *%rax
  802d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d73:	79 05                	jns    802d7a <stat+0x36>
		return fd;
  802d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d78:	eb 2f                	jmp    802da9 <stat+0x65>
	r = fstat(fd, stat);
  802d7a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d81:	48 89 d6             	mov    %rdx,%rsi
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 8b 2c 80 00 00 	movabs $0x802c8b,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
  802d92:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d98:	89 c7                	mov    %eax,%edi
  802d9a:	48 b8 32 27 80 00 00 	movabs $0x802732,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
	return r;
  802da6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   
	...

0000000000802dac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 10          	sub    $0x10,%rsp
  802db4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802db7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802dbb:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802dc2:	00 00 00 
  802dc5:	8b 00                	mov    (%rax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	75 1d                	jne    802de8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802dcb:	bf 01 00 00 00       	mov    $0x1,%edi
  802dd0:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  802dd7:	00 00 00 
  802dda:	ff d0                	callq  *%rax
  802ddc:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802de3:	00 00 00 
  802de6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802de8:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802def:	00 00 00 
  802df2:	8b 00                	mov    (%rax),%eax
  802df4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802df7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802dfc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802e03:	00 00 00 
  802e06:	89 c7                	mov    %eax,%edi
  802e08:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  802e0f:	00 00 00 
  802e12:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e18:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1d:	48 89 c6             	mov    %rax,%rsi
  802e20:	bf 00 00 00 00       	mov    $0x0,%edi
  802e25:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
}
  802e31:	c9                   	leaveq 
  802e32:	c3                   	retq   

0000000000802e33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e33:	55                   	push   %rbp
  802e34:	48 89 e5             	mov    %rsp,%rbp
  802e37:	48 83 ec 20          	sub    $0x20,%rsp
  802e3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e3f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e46:	48 89 c7             	mov    %rax,%rdi
  802e49:	48 b8 8c 0e 80 00 00 	movabs $0x800e8c,%rax
  802e50:	00 00 00 
  802e53:	ff d0                	callq  *%rax
  802e55:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e5a:	7e 0a                	jle    802e66 <open+0x33>
                return -E_BAD_PATH;
  802e5c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e61:	e9 a5 00 00 00       	jmpq   802f0b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802e66:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e6a:	48 89 c7             	mov    %rax,%rdi
  802e6d:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  802e74:	00 00 00 
  802e77:	ff d0                	callq  *%rax
  802e79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e80:	79 08                	jns    802e8a <open+0x57>
		return r;
  802e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e85:	e9 81 00 00 00       	jmpq   802f0b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802e8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8e:	48 89 c6             	mov    %rax,%rsi
  802e91:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e98:	00 00 00 
  802e9b:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802ea7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eae:	00 00 00 
  802eb1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802eb4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebe:	48 89 c6             	mov    %rax,%rsi
  802ec1:	bf 01 00 00 00       	mov    $0x1,%edi
  802ec6:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
  802ed2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802ed5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed9:	79 1d                	jns    802ef8 <open+0xc5>
	{
		fd_close(fd,0);
  802edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edf:	be 00 00 00 00       	mov    $0x0,%esi
  802ee4:	48 89 c7             	mov    %rax,%rdi
  802ee7:	48 b8 b2 25 80 00 00 	movabs $0x8025b2,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
		return r;
  802ef3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef6:	eb 13                	jmp    802f0b <open+0xd8>
	}
	return fd2num(fd);
  802ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efc:	48 89 c7             	mov    %rax,%rdi
  802eff:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
	


}
  802f0b:	c9                   	leaveq 
  802f0c:	c3                   	retq   

0000000000802f0d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	48 83 ec 10          	sub    $0x10,%rsp
  802f15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f1d:	8b 50 0c             	mov    0xc(%rax),%edx
  802f20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f27:	00 00 00 
  802f2a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f2c:	be 00 00 00 00       	mov    $0x0,%esi
  802f31:	bf 06 00 00 00       	mov    $0x6,%edi
  802f36:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
}
  802f42:	c9                   	leaveq 
  802f43:	c3                   	retq   

0000000000802f44 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802f44:	55                   	push   %rbp
  802f45:	48 89 e5             	mov    %rsp,%rbp
  802f48:	48 83 ec 30          	sub    $0x30,%rsp
  802f4c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f50:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f54:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5c:	8b 50 0c             	mov    0xc(%rax),%edx
  802f5f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f66:	00 00 00 
  802f69:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802f6b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f72:	00 00 00 
  802f75:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f79:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802f7d:	be 00 00 00 00       	mov    $0x0,%esi
  802f82:	bf 03 00 00 00       	mov    $0x3,%edi
  802f87:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802f8e:	00 00 00 
  802f91:	ff d0                	callq  *%rax
  802f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f9a:	79 05                	jns    802fa1 <devfile_read+0x5d>
	{
		return r;
  802f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9f:	eb 2c                	jmp    802fcd <devfile_read+0x89>
	}
	if(r > 0)
  802fa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa5:	7e 23                	jle    802fca <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802fa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802faa:	48 63 d0             	movslq %eax,%rdx
  802fad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802fb8:	00 00 00 
  802fbb:	48 89 c7             	mov    %rax,%rdi
  802fbe:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  802fc5:	00 00 00 
  802fc8:	ff d0                	callq  *%rax
	return r;
  802fca:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802fcd:	c9                   	leaveq 
  802fce:	c3                   	retq   

0000000000802fcf <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802fcf:	55                   	push   %rbp
  802fd0:	48 89 e5             	mov    %rsp,%rbp
  802fd3:	48 83 ec 30          	sub    $0x30,%rsp
  802fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe7:	8b 50 0c             	mov    0xc(%rax),%edx
  802fea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ff1:	00 00 00 
  802ff4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802ff6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802ffd:	00 
  802ffe:	76 08                	jbe    803008 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  803000:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803007:	00 
	fsipcbuf.write.req_n=n;
  803008:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80300f:	00 00 00 
  803012:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803016:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80301a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80301e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803022:	48 89 c6             	mov    %rax,%rsi
  803025:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80302c:	00 00 00 
  80302f:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80303b:	be 00 00 00 00       	mov    $0x0,%esi
  803040:	bf 04 00 00 00       	mov    $0x4,%edi
  803045:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  80304c:	00 00 00 
  80304f:	ff d0                	callq  *%rax
  803051:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803054:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803057:	c9                   	leaveq 
  803058:	c3                   	retq   

0000000000803059 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803059:	55                   	push   %rbp
  80305a:	48 89 e5             	mov    %rsp,%rbp
  80305d:	48 83 ec 10          	sub    $0x10,%rsp
  803061:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803065:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80306c:	8b 50 0c             	mov    0xc(%rax),%edx
  80306f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803076:	00 00 00 
  803079:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80307b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803082:	00 00 00 
  803085:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803088:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80308b:	be 00 00 00 00       	mov    $0x0,%esi
  803090:	bf 02 00 00 00       	mov    $0x2,%edi
  803095:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
}
  8030a1:	c9                   	leaveq 
  8030a2:	c3                   	retq   

00000000008030a3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8030a3:	55                   	push   %rbp
  8030a4:	48 89 e5             	mov    %rsp,%rbp
  8030a7:	48 83 ec 20          	sub    $0x20,%rsp
  8030ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8030b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c1:	00 00 00 
  8030c4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030c6:	be 00 00 00 00       	mov    $0x0,%esi
  8030cb:	bf 05 00 00 00       	mov    $0x5,%edi
  8030d0:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  8030d7:	00 00 00 
  8030da:	ff d0                	callq  *%rax
  8030dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e3:	79 05                	jns    8030ea <devfile_stat+0x47>
		return r;
  8030e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e8:	eb 56                	jmp    803140 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ee:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030f5:	00 00 00 
  8030f8:	48 89 c7             	mov    %rax,%rdi
  8030fb:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803107:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80310e:	00 00 00 
  803111:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803117:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803121:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803128:	00 00 00 
  80312b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803131:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803135:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80313b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803140:	c9                   	leaveq 
  803141:	c3                   	retq   
	...

0000000000803144 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803144:	55                   	push   %rbp
  803145:	48 89 e5             	mov    %rsp,%rbp
  803148:	48 83 ec 20          	sub    $0x20,%rsp
  80314c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80314f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803153:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803156:	48 89 d6             	mov    %rdx,%rsi
  803159:	89 c7                	mov    %eax,%edi
  80315b:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  803162:	00 00 00 
  803165:	ff d0                	callq  *%rax
  803167:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316e:	79 05                	jns    803175 <fd2sockid+0x31>
		return r;
  803170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803173:	eb 24                	jmp    803199 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803179:	8b 10                	mov    (%rax),%edx
  80317b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803182:	00 00 00 
  803185:	8b 00                	mov    (%rax),%eax
  803187:	39 c2                	cmp    %eax,%edx
  803189:	74 07                	je     803192 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80318b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803190:	eb 07                	jmp    803199 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803196:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803199:	c9                   	leaveq 
  80319a:	c3                   	retq   

000000000080319b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80319b:	55                   	push   %rbp
  80319c:	48 89 e5             	mov    %rsp,%rbp
  80319f:	48 83 ec 20          	sub    $0x20,%rsp
  8031a3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8031a6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031aa:	48 89 c7             	mov    %rax,%rdi
  8031ad:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
  8031b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c0:	78 26                	js     8031e8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8031c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8031cb:	48 89 c6             	mov    %rax,%rsi
  8031ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d3:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8031da:	00 00 00 
  8031dd:	ff d0                	callq  *%rax
  8031df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e6:	79 16                	jns    8031fe <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8031e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031eb:	89 c7                	mov    %eax,%edi
  8031ed:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
		return r;
  8031f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031fc:	eb 3a                	jmp    803238 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8031fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803202:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803209:	00 00 00 
  80320c:	8b 12                	mov    (%rdx),%edx
  80320e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803210:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803214:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80321b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803222:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803229:	48 89 c7             	mov    %rax,%rdi
  80322c:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
}
  803238:	c9                   	leaveq 
  803239:	c3                   	retq   

000000000080323a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80323a:	55                   	push   %rbp
  80323b:	48 89 e5             	mov    %rsp,%rbp
  80323e:	48 83 ec 30          	sub    $0x30,%rsp
  803242:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803245:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803249:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80324d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803250:	89 c7                	mov    %eax,%edi
  803252:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803259:	00 00 00 
  80325c:	ff d0                	callq  *%rax
  80325e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803261:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803265:	79 05                	jns    80326c <accept+0x32>
		return r;
  803267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326a:	eb 3b                	jmp    8032a7 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80326c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803270:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803274:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803277:	48 89 ce             	mov    %rcx,%rsi
  80327a:	89 c7                	mov    %eax,%edi
  80327c:	48 b8 85 35 80 00 00 	movabs $0x803585,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax
  803288:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80328f:	79 05                	jns    803296 <accept+0x5c>
		return r;
  803291:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803294:	eb 11                	jmp    8032a7 <accept+0x6d>
	return alloc_sockfd(r);
  803296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803299:	89 c7                	mov    %eax,%edi
  80329b:	48 b8 9b 31 80 00 00 	movabs $0x80319b,%rax
  8032a2:	00 00 00 
  8032a5:	ff d0                	callq  *%rax
}
  8032a7:	c9                   	leaveq 
  8032a8:	c3                   	retq   

00000000008032a9 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032a9:	55                   	push   %rbp
  8032aa:	48 89 e5             	mov    %rsp,%rbp
  8032ad:	48 83 ec 20          	sub    $0x20,%rsp
  8032b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b8:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032be:	89 c7                	mov    %eax,%edi
  8032c0:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8032c7:	00 00 00 
  8032ca:	ff d0                	callq  *%rax
  8032cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d3:	79 05                	jns    8032da <bind+0x31>
		return r;
  8032d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032d8:	eb 1b                	jmp    8032f5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8032da:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8032dd:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8032e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e4:	48 89 ce             	mov    %rcx,%rsi
  8032e7:	89 c7                	mov    %eax,%edi
  8032e9:	48 b8 04 36 80 00 00 	movabs $0x803604,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
}
  8032f5:	c9                   	leaveq 
  8032f6:	c3                   	retq   

00000000008032f7 <shutdown>:

int
shutdown(int s, int how)
{
  8032f7:	55                   	push   %rbp
  8032f8:	48 89 e5             	mov    %rsp,%rbp
  8032fb:	48 83 ec 20          	sub    $0x20,%rsp
  8032ff:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803302:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803305:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
  803316:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803319:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331d:	79 05                	jns    803324 <shutdown+0x2d>
		return r;
  80331f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803322:	eb 16                	jmp    80333a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803324:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332a:	89 d6                	mov    %edx,%esi
  80332c:	89 c7                	mov    %eax,%edi
  80332e:	48 b8 68 36 80 00 00 	movabs $0x803668,%rax
  803335:	00 00 00 
  803338:	ff d0                	callq  *%rax
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 10          	sub    $0x10,%rsp
  803344:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80334c:	48 89 c7             	mov    %rax,%rdi
  80334f:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  803356:	00 00 00 
  803359:	ff d0                	callq  *%rax
  80335b:	83 f8 01             	cmp    $0x1,%eax
  80335e:	75 17                	jne    803377 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803364:	8b 40 0c             	mov    0xc(%rax),%eax
  803367:	89 c7                	mov    %eax,%edi
  803369:	48 b8 a8 36 80 00 00 	movabs $0x8036a8,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
  803375:	eb 05                	jmp    80337c <devsock_close+0x40>
	else
		return 0;
  803377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80337c:	c9                   	leaveq 
  80337d:	c3                   	retq   

000000000080337e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80337e:	55                   	push   %rbp
  80337f:	48 89 e5             	mov    %rsp,%rbp
  803382:	48 83 ec 20          	sub    $0x20,%rsp
  803386:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803389:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80338d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803390:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803393:	89 c7                	mov    %eax,%edi
  803395:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  80339c:	00 00 00 
  80339f:	ff d0                	callq  *%rax
  8033a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033a8:	79 05                	jns    8033af <connect+0x31>
		return r;
  8033aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ad:	eb 1b                	jmp    8033ca <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8033af:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b9:	48 89 ce             	mov    %rcx,%rsi
  8033bc:	89 c7                	mov    %eax,%edi
  8033be:	48 b8 d5 36 80 00 00 	movabs $0x8036d5,%rax
  8033c5:	00 00 00 
  8033c8:	ff d0                	callq  *%rax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <listen>:

int
listen(int s, int backlog)
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	48 83 ec 20          	sub    $0x20,%rsp
  8033d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033dd:	89 c7                	mov    %eax,%edi
  8033df:	48 b8 44 31 80 00 00 	movabs $0x803144,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
  8033eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f2:	79 05                	jns    8033f9 <listen+0x2d>
		return r;
  8033f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f7:	eb 16                	jmp    80340f <listen+0x43>
	return nsipc_listen(r, backlog);
  8033f9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ff:	89 d6                	mov    %edx,%esi
  803401:	89 c7                	mov    %eax,%edi
  803403:	48 b8 39 37 80 00 00 	movabs $0x803739,%rax
  80340a:	00 00 00 
  80340d:	ff d0                	callq  *%rax
}
  80340f:	c9                   	leaveq 
  803410:	c3                   	retq   

0000000000803411 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803411:	55                   	push   %rbp
  803412:	48 89 e5             	mov    %rsp,%rbp
  803415:	48 83 ec 20          	sub    $0x20,%rsp
  803419:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80341d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803421:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803429:	89 c2                	mov    %eax,%edx
  80342b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80342f:	8b 40 0c             	mov    0xc(%rax),%eax
  803432:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803436:	b9 00 00 00 00       	mov    $0x0,%ecx
  80343b:	89 c7                	mov    %eax,%edi
  80343d:	48 b8 79 37 80 00 00 	movabs $0x803779,%rax
  803444:	00 00 00 
  803447:	ff d0                	callq  *%rax
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 20          	sub    $0x20,%rsp
  803453:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803457:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80345b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80345f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803463:	89 c2                	mov    %eax,%edx
  803465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803469:	8b 40 0c             	mov    0xc(%rax),%eax
  80346c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803470:	b9 00 00 00 00       	mov    $0x0,%ecx
  803475:	89 c7                	mov    %eax,%edi
  803477:	48 b8 45 38 80 00 00 	movabs $0x803845,%rax
  80347e:	00 00 00 
  803481:	ff d0                	callq  *%rax
}
  803483:	c9                   	leaveq 
  803484:	c3                   	retq   

0000000000803485 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803485:	55                   	push   %rbp
  803486:	48 89 e5             	mov    %rsp,%rbp
  803489:	48 83 ec 10          	sub    $0x10,%rsp
  80348d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803491:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803499:	48 be 5b 4c 80 00 00 	movabs $0x804c5b,%rsi
  8034a0:	00 00 00 
  8034a3:	48 89 c7             	mov    %rax,%rdi
  8034a6:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
	return 0;
  8034b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034b7:	c9                   	leaveq 
  8034b8:	c3                   	retq   

00000000008034b9 <socket>:

int
socket(int domain, int type, int protocol)
{
  8034b9:	55                   	push   %rbp
  8034ba:	48 89 e5             	mov    %rsp,%rbp
  8034bd:	48 83 ec 20          	sub    $0x20,%rsp
  8034c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034c4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034c7:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8034ca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034cd:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8034d0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d3:	89 ce                	mov    %ecx,%esi
  8034d5:	89 c7                	mov    %eax,%edi
  8034d7:	48 b8 fd 38 80 00 00 	movabs $0x8038fd,%rax
  8034de:	00 00 00 
  8034e1:	ff d0                	callq  *%rax
  8034e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ea:	79 05                	jns    8034f1 <socket+0x38>
		return r;
  8034ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ef:	eb 11                	jmp    803502 <socket+0x49>
	return alloc_sockfd(r);
  8034f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f4:	89 c7                	mov    %eax,%edi
  8034f6:	48 b8 9b 31 80 00 00 	movabs $0x80319b,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	callq  *%rax
}
  803502:	c9                   	leaveq 
  803503:	c3                   	retq   

0000000000803504 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 83 ec 10          	sub    $0x10,%rsp
  80350c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80350f:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803516:	00 00 00 
  803519:	8b 00                	mov    (%rax),%eax
  80351b:	85 c0                	test   %eax,%eax
  80351d:	75 1d                	jne    80353c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80351f:	bf 02 00 00 00       	mov    $0x2,%edi
  803524:	48 b8 b7 23 80 00 00 	movabs $0x8023b7,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  803537:	00 00 00 
  80353a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80353c:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803543:	00 00 00 
  803546:	8b 00                	mov    (%rax),%eax
  803548:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80354b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803550:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803557:	00 00 00 
  80355a:	89 c7                	mov    %eax,%edi
  80355c:	48 b8 f4 22 80 00 00 	movabs $0x8022f4,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803568:	ba 00 00 00 00       	mov    $0x0,%edx
  80356d:	be 00 00 00 00       	mov    $0x0,%esi
  803572:	bf 00 00 00 00       	mov    $0x0,%edi
  803577:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  80357e:	00 00 00 
  803581:	ff d0                	callq  *%rax
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
  803589:	48 83 ec 30          	sub    $0x30,%rsp
  80358d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803590:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803594:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803598:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80359f:	00 00 00 
  8035a2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8035a7:	bf 01 00 00 00       	mov    $0x1,%edi
  8035ac:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
  8035b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035bf:	78 3e                	js     8035ff <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8035c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c8:	00 00 00 
  8035cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8035cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035d3:	8b 40 10             	mov    0x10(%rax),%eax
  8035d6:	89 c2                	mov    %eax,%edx
  8035d8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8035dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e0:	48 89 ce             	mov    %rcx,%rsi
  8035e3:	48 89 c7             	mov    %rax,%rdi
  8035e6:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  8035ed:	00 00 00 
  8035f0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8035f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f6:	8b 50 10             	mov    0x10(%rax),%edx
  8035f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035fd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8035ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803602:	c9                   	leaveq 
  803603:	c3                   	retq   

0000000000803604 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803604:	55                   	push   %rbp
  803605:	48 89 e5             	mov    %rsp,%rbp
  803608:	48 83 ec 10          	sub    $0x10,%rsp
  80360c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80360f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803613:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803616:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80361d:	00 00 00 
  803620:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803623:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803625:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80362c:	48 89 c6             	mov    %rax,%rsi
  80362f:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803636:	00 00 00 
  803639:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803640:	00 00 00 
  803643:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803645:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364c:	00 00 00 
  80364f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803652:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803655:	bf 02 00 00 00       	mov    $0x2,%edi
  80365a:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  803661:	00 00 00 
  803664:	ff d0                	callq  *%rax
}
  803666:	c9                   	leaveq 
  803667:	c3                   	retq   

0000000000803668 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803668:	55                   	push   %rbp
  803669:	48 89 e5             	mov    %rsp,%rbp
  80366c:	48 83 ec 10          	sub    $0x10,%rsp
  803670:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803673:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803676:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80367d:	00 00 00 
  803680:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803683:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803685:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80368c:	00 00 00 
  80368f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803692:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803695:	bf 03 00 00 00       	mov    $0x3,%edi
  80369a:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  8036a1:	00 00 00 
  8036a4:	ff d0                	callq  *%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <nsipc_close>:

int
nsipc_close(int s)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 10          	sub    $0x10,%rsp
  8036b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8036b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ba:	00 00 00 
  8036bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036c0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8036c2:	bf 04 00 00 00       	mov    $0x4,%edi
  8036c7:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  8036ce:	00 00 00 
  8036d1:	ff d0                	callq  *%rax
}
  8036d3:	c9                   	leaveq 
  8036d4:	c3                   	retq   

00000000008036d5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036d5:	55                   	push   %rbp
  8036d6:	48 89 e5             	mov    %rsp,%rbp
  8036d9:	48 83 ec 10          	sub    $0x10,%rsp
  8036dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8036e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036ee:	00 00 00 
  8036f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036f4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036f6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fd:	48 89 c6             	mov    %rax,%rsi
  803700:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803707:	00 00 00 
  80370a:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803716:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371d:	00 00 00 
  803720:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803723:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803726:	bf 05 00 00 00       	mov    $0x5,%edi
  80372b:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  803732:	00 00 00 
  803735:	ff d0                	callq  *%rax
}
  803737:	c9                   	leaveq 
  803738:	c3                   	retq   

0000000000803739 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803739:	55                   	push   %rbp
  80373a:	48 89 e5             	mov    %rsp,%rbp
  80373d:	48 83 ec 10          	sub    $0x10,%rsp
  803741:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803744:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803747:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374e:	00 00 00 
  803751:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803754:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803756:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80375d:	00 00 00 
  803760:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803763:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803766:	bf 06 00 00 00       	mov    $0x6,%edi
  80376b:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  803772:	00 00 00 
  803775:	ff d0                	callq  *%rax
}
  803777:	c9                   	leaveq 
  803778:	c3                   	retq   

0000000000803779 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803779:	55                   	push   %rbp
  80377a:	48 89 e5             	mov    %rsp,%rbp
  80377d:	48 83 ec 30          	sub    $0x30,%rsp
  803781:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803784:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803788:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80378b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80378e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803795:	00 00 00 
  803798:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80379b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80379d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037a4:	00 00 00 
  8037a7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037aa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8037ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037b4:	00 00 00 
  8037b7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8037ba:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8037bd:	bf 07 00 00 00       	mov    $0x7,%edi
  8037c2:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
  8037ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d5:	78 69                	js     803840 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8037d7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8037de:	7f 08                	jg     8037e8 <nsipc_recv+0x6f>
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8037e6:	7e 35                	jle    80381d <nsipc_recv+0xa4>
  8037e8:	48 b9 62 4c 80 00 00 	movabs $0x804c62,%rcx
  8037ef:	00 00 00 
  8037f2:	48 ba 77 4c 80 00 00 	movabs $0x804c77,%rdx
  8037f9:	00 00 00 
  8037fc:	be 61 00 00 00       	mov    $0x61,%esi
  803801:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  803808:	00 00 00 
  80380b:	b8 00 00 00 00       	mov    $0x0,%eax
  803810:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
  803817:	00 00 00 
  80381a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80381d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803820:	48 63 d0             	movslq %eax,%rdx
  803823:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803827:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80382e:	00 00 00 
  803831:	48 89 c7             	mov    %rax,%rdi
  803834:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  80383b:	00 00 00 
  80383e:	ff d0                	callq  *%rax
	}

	return r;
  803840:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803843:	c9                   	leaveq 
  803844:	c3                   	retq   

0000000000803845 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803845:	55                   	push   %rbp
  803846:	48 89 e5             	mov    %rsp,%rbp
  803849:	48 83 ec 20          	sub    $0x20,%rsp
  80384d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803850:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803854:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803857:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80385a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803861:	00 00 00 
  803864:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803867:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803869:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803870:	7e 35                	jle    8038a7 <nsipc_send+0x62>
  803872:	48 b9 98 4c 80 00 00 	movabs $0x804c98,%rcx
  803879:	00 00 00 
  80387c:	48 ba 77 4c 80 00 00 	movabs $0x804c77,%rdx
  803883:	00 00 00 
  803886:	be 6c 00 00 00       	mov    $0x6c,%esi
  80388b:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  803892:	00 00 00 
  803895:	b8 00 00 00 00       	mov    $0x0,%eax
  80389a:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
  8038a1:	00 00 00 
  8038a4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8038a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038aa:	48 63 d0             	movslq %eax,%rdx
  8038ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b1:	48 89 c6             	mov    %rax,%rsi
  8038b4:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8038bb:	00 00 00 
  8038be:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8038ca:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038d1:	00 00 00 
  8038d4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038d7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8038da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e1:	00 00 00 
  8038e4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038e7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8038ea:	bf 08 00 00 00       	mov    $0x8,%edi
  8038ef:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  8038f6:	00 00 00 
  8038f9:	ff d0                	callq  *%rax
}
  8038fb:	c9                   	leaveq 
  8038fc:	c3                   	retq   

00000000008038fd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8038fd:	55                   	push   %rbp
  8038fe:	48 89 e5             	mov    %rsp,%rbp
  803901:	48 83 ec 10          	sub    $0x10,%rsp
  803905:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803908:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80390b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80390e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803915:	00 00 00 
  803918:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80391b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80391d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803924:	00 00 00 
  803927:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80392a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80392d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803934:	00 00 00 
  803937:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80393a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80393d:	bf 09 00 00 00       	mov    $0x9,%edi
  803942:	48 b8 04 35 80 00 00 	movabs $0x803504,%rax
  803949:	00 00 00 
  80394c:	ff d0                	callq  *%rax
}
  80394e:	c9                   	leaveq 
  80394f:	c3                   	retq   

0000000000803950 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803950:	55                   	push   %rbp
  803951:	48 89 e5             	mov    %rsp,%rbp
  803954:	53                   	push   %rbx
  803955:	48 83 ec 38          	sub    $0x38,%rsp
  803959:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80395d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803961:	48 89 c7             	mov    %rax,%rdi
  803964:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
  803970:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803973:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803977:	0f 88 bf 01 00 00    	js     803b3c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80397d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803981:	ba 07 04 00 00       	mov    $0x407,%edx
  803986:	48 89 c6             	mov    %rax,%rsi
  803989:	bf 00 00 00 00       	mov    $0x0,%edi
  80398e:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
  80399a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80399d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a1:	0f 88 95 01 00 00    	js     803b3c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039a7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039ab:	48 89 c7             	mov    %rax,%rdi
  8039ae:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  8039b5:	00 00 00 
  8039b8:	ff d0                	callq  *%rax
  8039ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c1:	0f 88 5d 01 00 00    	js     803b24 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039cb:	ba 07 04 00 00       	mov    $0x407,%edx
  8039d0:	48 89 c6             	mov    %rax,%rsi
  8039d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8039d8:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  8039df:	00 00 00 
  8039e2:	ff d0                	callq  *%rax
  8039e4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039eb:	0f 88 33 01 00 00    	js     803b24 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8039f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f5:	48 89 c7             	mov    %rax,%rdi
  8039f8:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  8039ff:	00 00 00 
  803a02:	ff d0                	callq  *%rax
  803a04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a0c:	ba 07 04 00 00       	mov    $0x407,%edx
  803a11:	48 89 c6             	mov    %rax,%rsi
  803a14:	bf 00 00 00 00       	mov    $0x0,%edi
  803a19:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  803a20:	00 00 00 
  803a23:	ff d0                	callq  *%rax
  803a25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a2c:	0f 88 d9 00 00 00    	js     803b0b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a36:	48 89 c7             	mov    %rax,%rdi
  803a39:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803a40:	00 00 00 
  803a43:	ff d0                	callq  *%rax
  803a45:	48 89 c2             	mov    %rax,%rdx
  803a48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a4c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a52:	48 89 d1             	mov    %rdx,%rcx
  803a55:	ba 00 00 00 00       	mov    $0x0,%edx
  803a5a:	48 89 c6             	mov    %rax,%rsi
  803a5d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a62:	48 b8 80 18 80 00 00 	movabs $0x801880,%rax
  803a69:	00 00 00 
  803a6c:	ff d0                	callq  *%rax
  803a6e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a71:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a75:	78 79                	js     803af0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803a77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a7b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a82:	00 00 00 
  803a85:	8b 12                	mov    (%rdx),%edx
  803a87:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a94:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a98:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a9f:	00 00 00 
  803aa2:	8b 12                	mov    (%rdx),%edx
  803aa4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803aa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aaa:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ab1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ab5:	48 89 c7             	mov    %rax,%rdi
  803ab8:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
  803ac4:	89 c2                	mov    %eax,%edx
  803ac6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803aca:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803acc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ad0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ad4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ad8:	48 89 c7             	mov    %rax,%rdi
  803adb:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  803ae2:	00 00 00 
  803ae5:	ff d0                	callq  *%rax
  803ae7:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aee:	eb 4f                	jmp    803b3f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803af0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af5:	48 89 c6             	mov    %rax,%rsi
  803af8:	bf 00 00 00 00       	mov    $0x0,%edi
  803afd:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803b04:	00 00 00 
  803b07:	ff d0                	callq  *%rax
  803b09:	eb 01                	jmp    803b0c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803b0b:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803b0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b10:	48 89 c6             	mov    %rax,%rsi
  803b13:	bf 00 00 00 00       	mov    $0x0,%edi
  803b18:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803b1f:	00 00 00 
  803b22:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b28:	48 89 c6             	mov    %rax,%rsi
  803b2b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b30:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803b37:	00 00 00 
  803b3a:	ff d0                	callq  *%rax
    err:
	return r;
  803b3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b3f:	48 83 c4 38          	add    $0x38,%rsp
  803b43:	5b                   	pop    %rbx
  803b44:	5d                   	pop    %rbp
  803b45:	c3                   	retq   

0000000000803b46 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b46:	55                   	push   %rbp
  803b47:	48 89 e5             	mov    %rsp,%rbp
  803b4a:	53                   	push   %rbx
  803b4b:	48 83 ec 28          	sub    $0x28,%rsp
  803b4f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b53:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b57:	eb 01                	jmp    803b5a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803b59:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b5a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803b61:	00 00 00 
  803b64:	48 8b 00             	mov    (%rax),%rax
  803b67:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b74:	48 89 c7             	mov    %rax,%rdi
  803b77:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  803b7e:	00 00 00 
  803b81:	ff d0                	callq  *%rax
  803b83:	89 c3                	mov    %eax,%ebx
  803b85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b89:	48 89 c7             	mov    %rax,%rdi
  803b8c:	48 b8 30 44 80 00 00 	movabs $0x804430,%rax
  803b93:	00 00 00 
  803b96:	ff d0                	callq  *%rax
  803b98:	39 c3                	cmp    %eax,%ebx
  803b9a:	0f 94 c0             	sete   %al
  803b9d:	0f b6 c0             	movzbl %al,%eax
  803ba0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803ba3:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803baa:	00 00 00 
  803bad:	48 8b 00             	mov    (%rax),%rax
  803bb0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bb6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803bb9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bbc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bbf:	75 0a                	jne    803bcb <_pipeisclosed+0x85>
			return ret;
  803bc1:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803bc4:	48 83 c4 28          	add    $0x28,%rsp
  803bc8:	5b                   	pop    %rbx
  803bc9:	5d                   	pop    %rbp
  803bca:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bce:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bd1:	74 86                	je     803b59 <_pipeisclosed+0x13>
  803bd3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803bd7:	75 80                	jne    803b59 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803bd9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803be0:	00 00 00 
  803be3:	48 8b 00             	mov    (%rax),%rax
  803be6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803bec:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803bef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf2:	89 c6                	mov    %eax,%esi
  803bf4:	48 bf a9 4c 80 00 00 	movabs $0x804ca9,%rdi
  803bfb:	00 00 00 
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803c03:	49 b8 3b 03 80 00 00 	movabs $0x80033b,%r8
  803c0a:	00 00 00 
  803c0d:	41 ff d0             	callq  *%r8
	}
  803c10:	e9 44 ff ff ff       	jmpq   803b59 <_pipeisclosed+0x13>

0000000000803c15 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803c15:	55                   	push   %rbp
  803c16:	48 89 e5             	mov    %rsp,%rbp
  803c19:	48 83 ec 30          	sub    $0x30,%rsp
  803c1d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c20:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c24:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c27:	48 89 d6             	mov    %rdx,%rsi
  803c2a:	89 c7                	mov    %eax,%edi
  803c2c:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
  803c38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c3f:	79 05                	jns    803c46 <pipeisclosed+0x31>
		return r;
  803c41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c44:	eb 31                	jmp    803c77 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c4a:	48 89 c7             	mov    %rax,%rdi
  803c4d:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
  803c59:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c65:	48 89 d6             	mov    %rdx,%rsi
  803c68:	48 89 c7             	mov    %rax,%rdi
  803c6b:	48 b8 46 3b 80 00 00 	movabs $0x803b46,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
}
  803c77:	c9                   	leaveq 
  803c78:	c3                   	retq   

0000000000803c79 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c79:	55                   	push   %rbp
  803c7a:	48 89 e5             	mov    %rsp,%rbp
  803c7d:	48 83 ec 40          	sub    $0x40,%rsp
  803c81:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c85:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c89:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c91:	48 89 c7             	mov    %rax,%rdi
  803c94:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803c9b:	00 00 00 
  803c9e:	ff d0                	callq  *%rax
  803ca0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ca4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ca8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803cac:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803cb3:	00 
  803cb4:	e9 97 00 00 00       	jmpq   803d50 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803cb9:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803cbe:	74 09                	je     803cc9 <devpipe_read+0x50>
				return i;
  803cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc4:	e9 95 00 00 00       	jmpq   803d5e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803cc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ccd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd1:	48 89 d6             	mov    %rdx,%rsi
  803cd4:	48 89 c7             	mov    %rax,%rdi
  803cd7:	48 b8 46 3b 80 00 00 	movabs $0x803b46,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
  803ce3:	85 c0                	test   %eax,%eax
  803ce5:	74 07                	je     803cee <devpipe_read+0x75>
				return 0;
  803ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cec:	eb 70                	jmp    803d5e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803cee:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
  803cfa:	eb 01                	jmp    803cfd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803cfc:	90                   	nop
  803cfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d01:	8b 10                	mov    (%rax),%edx
  803d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d07:	8b 40 04             	mov    0x4(%rax),%eax
  803d0a:	39 c2                	cmp    %eax,%edx
  803d0c:	74 ab                	je     803cb9 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d16:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1e:	8b 00                	mov    (%rax),%eax
  803d20:	89 c2                	mov    %eax,%edx
  803d22:	c1 fa 1f             	sar    $0x1f,%edx
  803d25:	c1 ea 1b             	shr    $0x1b,%edx
  803d28:	01 d0                	add    %edx,%eax
  803d2a:	83 e0 1f             	and    $0x1f,%eax
  803d2d:	29 d0                	sub    %edx,%eax
  803d2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d33:	48 98                	cltq   
  803d35:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d3a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d40:	8b 00                	mov    (%rax),%eax
  803d42:	8d 50 01             	lea    0x1(%rax),%edx
  803d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d49:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d4b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d54:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d58:	72 a2                	jb     803cfc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d5e:	c9                   	leaveq 
  803d5f:	c3                   	retq   

0000000000803d60 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d60:	55                   	push   %rbp
  803d61:	48 89 e5             	mov    %rsp,%rbp
  803d64:	48 83 ec 40          	sub    $0x40,%rsp
  803d68:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d6c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d70:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d78:	48 89 c7             	mov    %rax,%rdi
  803d7b:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803d82:	00 00 00 
  803d85:	ff d0                	callq  *%rax
  803d87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d8f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d93:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d9a:	00 
  803d9b:	e9 93 00 00 00       	jmpq   803e33 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803da4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803da8:	48 89 d6             	mov    %rdx,%rsi
  803dab:	48 89 c7             	mov    %rax,%rdi
  803dae:	48 b8 46 3b 80 00 00 	movabs $0x803b46,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
  803dba:	85 c0                	test   %eax,%eax
  803dbc:	74 07                	je     803dc5 <devpipe_write+0x65>
				return 0;
  803dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc3:	eb 7c                	jmp    803e41 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803dc5:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  803dcc:	00 00 00 
  803dcf:	ff d0                	callq  *%rax
  803dd1:	eb 01                	jmp    803dd4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dd3:	90                   	nop
  803dd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd8:	8b 40 04             	mov    0x4(%rax),%eax
  803ddb:	48 63 d0             	movslq %eax,%rdx
  803dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803de2:	8b 00                	mov    (%rax),%eax
  803de4:	48 98                	cltq   
  803de6:	48 83 c0 20          	add    $0x20,%rax
  803dea:	48 39 c2             	cmp    %rax,%rdx
  803ded:	73 b1                	jae    803da0 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df3:	8b 40 04             	mov    0x4(%rax),%eax
  803df6:	89 c2                	mov    %eax,%edx
  803df8:	c1 fa 1f             	sar    $0x1f,%edx
  803dfb:	c1 ea 1b             	shr    $0x1b,%edx
  803dfe:	01 d0                	add    %edx,%eax
  803e00:	83 e0 1f             	and    $0x1f,%eax
  803e03:	29 d0                	sub    %edx,%eax
  803e05:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e09:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e0d:	48 01 ca             	add    %rcx,%rdx
  803e10:	0f b6 0a             	movzbl (%rdx),%ecx
  803e13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e17:	48 98                	cltq   
  803e19:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e21:	8b 40 04             	mov    0x4(%rax),%eax
  803e24:	8d 50 01             	lea    0x1(%rax),%edx
  803e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2b:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e2e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e37:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e3b:	72 96                	jb     803dd3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e41:	c9                   	leaveq 
  803e42:	c3                   	retq   

0000000000803e43 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e43:	55                   	push   %rbp
  803e44:	48 89 e5             	mov    %rsp,%rbp
  803e47:	48 83 ec 20          	sub    $0x20,%rsp
  803e4b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e4f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e57:	48 89 c7             	mov    %rax,%rdi
  803e5a:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803e61:	00 00 00 
  803e64:	ff d0                	callq  *%rax
  803e66:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e6e:	48 be bc 4c 80 00 00 	movabs $0x804cbc,%rsi
  803e75:	00 00 00 
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803e87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e8b:	8b 50 04             	mov    0x4(%rax),%edx
  803e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e92:	8b 00                	mov    (%rax),%eax
  803e94:	29 c2                	sub    %eax,%edx
  803e96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e9a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ea0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803eab:	00 00 00 
	stat->st_dev = &devpipe;
  803eae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb2:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803eb9:	00 00 00 
  803ebc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec8:	c9                   	leaveq 
  803ec9:	c3                   	retq   

0000000000803eca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803eca:	55                   	push   %rbp
  803ecb:	48 89 e5             	mov    %rsp,%rbp
  803ece:	48 83 ec 10          	sub    $0x10,%rsp
  803ed2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803ed6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eda:	48 89 c6             	mov    %rax,%rsi
  803edd:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee2:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803ee9:	00 00 00 
  803eec:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef2:	48 89 c7             	mov    %rax,%rdi
  803ef5:	48 b8 5f 24 80 00 00 	movabs $0x80245f,%rax
  803efc:	00 00 00 
  803eff:	ff d0                	callq  *%rax
  803f01:	48 89 c6             	mov    %rax,%rsi
  803f04:	bf 00 00 00 00       	mov    $0x0,%edi
  803f09:	48 b8 db 18 80 00 00 	movabs $0x8018db,%rax
  803f10:	00 00 00 
  803f13:	ff d0                	callq  *%rax
}
  803f15:	c9                   	leaveq 
  803f16:	c3                   	retq   
	...

0000000000803f18 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f18:	55                   	push   %rbp
  803f19:	48 89 e5             	mov    %rsp,%rbp
  803f1c:	48 83 ec 20          	sub    $0x20,%rsp
  803f20:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f26:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f29:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f2d:	be 01 00 00 00       	mov    $0x1,%esi
  803f32:	48 89 c7             	mov    %rax,%rdi
  803f35:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  803f3c:	00 00 00 
  803f3f:	ff d0                	callq  *%rax
}
  803f41:	c9                   	leaveq 
  803f42:	c3                   	retq   

0000000000803f43 <getchar>:

int
getchar(void)
{
  803f43:	55                   	push   %rbp
  803f44:	48 89 e5             	mov    %rsp,%rbp
  803f47:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f4b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803f4f:	ba 01 00 00 00       	mov    $0x1,%edx
  803f54:	48 89 c6             	mov    %rax,%rsi
  803f57:	bf 00 00 00 00       	mov    $0x0,%edi
  803f5c:	48 b8 54 29 80 00 00 	movabs $0x802954,%rax
  803f63:	00 00 00 
  803f66:	ff d0                	callq  *%rax
  803f68:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803f6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6f:	79 05                	jns    803f76 <getchar+0x33>
		return r;
  803f71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f74:	eb 14                	jmp    803f8a <getchar+0x47>
	if (r < 1)
  803f76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7a:	7f 07                	jg     803f83 <getchar+0x40>
		return -E_EOF;
  803f7c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803f81:	eb 07                	jmp    803f8a <getchar+0x47>
	return c;
  803f83:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803f87:	0f b6 c0             	movzbl %al,%eax
}
  803f8a:	c9                   	leaveq 
  803f8b:	c3                   	retq   

0000000000803f8c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f8c:	55                   	push   %rbp
  803f8d:	48 89 e5             	mov    %rsp,%rbp
  803f90:	48 83 ec 20          	sub    $0x20,%rsp
  803f94:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f9e:	48 89 d6             	mov    %rdx,%rsi
  803fa1:	89 c7                	mov    %eax,%edi
  803fa3:	48 b8 22 25 80 00 00 	movabs $0x802522,%rax
  803faa:	00 00 00 
  803fad:	ff d0                	callq  *%rax
  803faf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb6:	79 05                	jns    803fbd <iscons+0x31>
		return r;
  803fb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fbb:	eb 1a                	jmp    803fd7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc1:	8b 10                	mov    (%rax),%edx
  803fc3:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803fca:	00 00 00 
  803fcd:	8b 00                	mov    (%rax),%eax
  803fcf:	39 c2                	cmp    %eax,%edx
  803fd1:	0f 94 c0             	sete   %al
  803fd4:	0f b6 c0             	movzbl %al,%eax
}
  803fd7:	c9                   	leaveq 
  803fd8:	c3                   	retq   

0000000000803fd9 <opencons>:

int
opencons(void)
{
  803fd9:	55                   	push   %rbp
  803fda:	48 89 e5             	mov    %rsp,%rbp
  803fdd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803fe1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803fe5:	48 89 c7             	mov    %rax,%rdi
  803fe8:	48 b8 8a 24 80 00 00 	movabs $0x80248a,%rax
  803fef:	00 00 00 
  803ff2:	ff d0                	callq  *%rax
  803ff4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ffb:	79 05                	jns    804002 <opencons+0x29>
		return r;
  803ffd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804000:	eb 5b                	jmp    80405d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804002:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804006:	ba 07 04 00 00       	mov    $0x407,%edx
  80400b:	48 89 c6             	mov    %rax,%rsi
  80400e:	bf 00 00 00 00       	mov    $0x0,%edi
  804013:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  80401a:	00 00 00 
  80401d:	ff d0                	callq  *%rax
  80401f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804026:	79 05                	jns    80402d <opencons+0x54>
		return r;
  804028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80402b:	eb 30                	jmp    80405d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80402d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804031:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804038:	00 00 00 
  80403b:	8b 12                	mov    (%rdx),%edx
  80403d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80403f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804043:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80404a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80404e:	48 89 c7             	mov    %rax,%rdi
  804051:	48 b8 3c 24 80 00 00 	movabs $0x80243c,%rax
  804058:	00 00 00 
  80405b:	ff d0                	callq  *%rax
}
  80405d:	c9                   	leaveq 
  80405e:	c3                   	retq   

000000000080405f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80405f:	55                   	push   %rbp
  804060:	48 89 e5             	mov    %rsp,%rbp
  804063:	48 83 ec 30          	sub    $0x30,%rsp
  804067:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80406b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80406f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804073:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804078:	75 13                	jne    80408d <devcons_read+0x2e>
		return 0;
  80407a:	b8 00 00 00 00       	mov    $0x0,%eax
  80407f:	eb 49                	jmp    8040ca <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804081:	48 b8 f2 17 80 00 00 	movabs $0x8017f2,%rax
  804088:	00 00 00 
  80408b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80408d:	48 b8 32 17 80 00 00 	movabs $0x801732,%rax
  804094:	00 00 00 
  804097:	ff d0                	callq  *%rax
  804099:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80409c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a0:	74 df                	je     804081 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8040a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a6:	79 05                	jns    8040ad <devcons_read+0x4e>
		return c;
  8040a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ab:	eb 1d                	jmp    8040ca <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8040ad:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8040b1:	75 07                	jne    8040ba <devcons_read+0x5b>
		return 0;
  8040b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040b8:	eb 10                	jmp    8040ca <devcons_read+0x6b>
	*(char*)vbuf = c;
  8040ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040bd:	89 c2                	mov    %eax,%edx
  8040bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040c3:	88 10                	mov    %dl,(%rax)
	return 1;
  8040c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040ca:	c9                   	leaveq 
  8040cb:	c3                   	retq   

00000000008040cc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040cc:	55                   	push   %rbp
  8040cd:	48 89 e5             	mov    %rsp,%rbp
  8040d0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8040d7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8040de:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8040e5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8040f3:	eb 77                	jmp    80416c <devcons_write+0xa0>
		m = n - tot;
  8040f5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8040fc:	89 c2                	mov    %eax,%edx
  8040fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804101:	89 d1                	mov    %edx,%ecx
  804103:	29 c1                	sub    %eax,%ecx
  804105:	89 c8                	mov    %ecx,%eax
  804107:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80410a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80410d:	83 f8 7f             	cmp    $0x7f,%eax
  804110:	76 07                	jbe    804119 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804112:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804119:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80411c:	48 63 d0             	movslq %eax,%rdx
  80411f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804122:	48 98                	cltq   
  804124:	48 89 c1             	mov    %rax,%rcx
  804127:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80412e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804135:	48 89 ce             	mov    %rcx,%rsi
  804138:	48 89 c7             	mov    %rax,%rdi
  80413b:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  804142:	00 00 00 
  804145:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804147:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80414a:	48 63 d0             	movslq %eax,%rdx
  80414d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804154:	48 89 d6             	mov    %rdx,%rsi
  804157:	48 89 c7             	mov    %rax,%rdi
  80415a:	48 b8 e8 16 80 00 00 	movabs $0x8016e8,%rax
  804161:	00 00 00 
  804164:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804166:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804169:	01 45 fc             	add    %eax,-0x4(%rbp)
  80416c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416f:	48 98                	cltq   
  804171:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804178:	0f 82 77 ff ff ff    	jb     8040f5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80417e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804181:	c9                   	leaveq 
  804182:	c3                   	retq   

0000000000804183 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804183:	55                   	push   %rbp
  804184:	48 89 e5             	mov    %rsp,%rbp
  804187:	48 83 ec 08          	sub    $0x8,%rsp
  80418b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80418f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804194:	c9                   	leaveq 
  804195:	c3                   	retq   

0000000000804196 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804196:	55                   	push   %rbp
  804197:	48 89 e5             	mov    %rsp,%rbp
  80419a:	48 83 ec 10          	sub    $0x10,%rsp
  80419e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041a2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8041a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041aa:	48 be c8 4c 80 00 00 	movabs $0x804cc8,%rsi
  8041b1:	00 00 00 
  8041b4:	48 89 c7             	mov    %rax,%rdi
  8041b7:	48 b8 f8 0e 80 00 00 	movabs $0x800ef8,%rax
  8041be:	00 00 00 
  8041c1:	ff d0                	callq  *%rax
	return 0;
  8041c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041c8:	c9                   	leaveq 
  8041c9:	c3                   	retq   
	...

00000000008041cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8041cc:	55                   	push   %rbp
  8041cd:	48 89 e5             	mov    %rsp,%rbp
  8041d0:	53                   	push   %rbx
  8041d1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8041d8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8041df:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8041e5:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8041ec:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8041f3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8041fa:	84 c0                	test   %al,%al
  8041fc:	74 23                	je     804221 <_panic+0x55>
  8041fe:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804205:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804209:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80420d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804211:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804215:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804219:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80421d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804221:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804228:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80422f:	00 00 00 
  804232:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804239:	00 00 00 
  80423c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804240:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  804247:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80424e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804255:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80425c:	00 00 00 
  80425f:	48 8b 18             	mov    (%rax),%rbx
  804262:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  804269:	00 00 00 
  80426c:	ff d0                	callq  *%rax
  80426e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804274:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80427b:	41 89 c8             	mov    %ecx,%r8d
  80427e:	48 89 d1             	mov    %rdx,%rcx
  804281:	48 89 da             	mov    %rbx,%rdx
  804284:	89 c6                	mov    %eax,%esi
  804286:	48 bf d0 4c 80 00 00 	movabs $0x804cd0,%rdi
  80428d:	00 00 00 
  804290:	b8 00 00 00 00       	mov    $0x0,%eax
  804295:	49 b9 3b 03 80 00 00 	movabs $0x80033b,%r9
  80429c:	00 00 00 
  80429f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8042a2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8042a9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8042b0:	48 89 d6             	mov    %rdx,%rsi
  8042b3:	48 89 c7             	mov    %rax,%rdi
  8042b6:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
	cprintf("\n");
  8042c2:	48 bf f3 4c 80 00 00 	movabs $0x804cf3,%rdi
  8042c9:	00 00 00 
  8042cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8042d1:	48 ba 3b 03 80 00 00 	movabs $0x80033b,%rdx
  8042d8:	00 00 00 
  8042db:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8042dd:	cc                   	int3   
  8042de:	eb fd                	jmp    8042dd <_panic+0x111>

00000000008042e0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8042e0:	55                   	push   %rbp
  8042e1:	48 89 e5             	mov    %rsp,%rbp
  8042e4:	48 83 ec 20          	sub    $0x20,%rsp
  8042e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8042ec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042f3:	00 00 00 
  8042f6:	48 8b 00             	mov    (%rax),%rax
  8042f9:	48 85 c0             	test   %rax,%rax
  8042fc:	0f 85 8e 00 00 00    	jne    804390 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  804302:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804309:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804310:	48 b8 b4 17 80 00 00 	movabs $0x8017b4,%rax
  804317:	00 00 00 
  80431a:	ff d0                	callq  *%rax
  80431c:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  80431f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804326:	ba 07 00 00 00       	mov    $0x7,%edx
  80432b:	48 89 ce             	mov    %rcx,%rsi
  80432e:	89 c7                	mov    %eax,%edi
  804330:	48 b8 30 18 80 00 00 	movabs $0x801830,%rax
  804337:	00 00 00 
  80433a:	ff d0                	callq  *%rax
  80433c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80433f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804343:	74 30                	je     804375 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  804345:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804348:	89 c1                	mov    %eax,%ecx
  80434a:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  804351:	00 00 00 
  804354:	be 24 00 00 00       	mov    $0x24,%esi
  804359:	48 bf 2f 4d 80 00 00 	movabs $0x804d2f,%rdi
  804360:	00 00 00 
  804363:	b8 00 00 00 00       	mov    $0x0,%eax
  804368:	49 b8 cc 41 80 00 00 	movabs $0x8041cc,%r8
  80436f:	00 00 00 
  804372:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804375:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804378:	48 be a4 43 80 00 00 	movabs $0x8043a4,%rsi
  80437f:	00 00 00 
  804382:	89 c7                	mov    %eax,%edi
  804384:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  80438b:	00 00 00 
  80438e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804390:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804397:	00 00 00 
  80439a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80439e:	48 89 10             	mov    %rdx,(%rax)
}
  8043a1:	c9                   	leaveq 
  8043a2:	c3                   	retq   
	...

00000000008043a4 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8043a4:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8043a7:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8043ae:	00 00 00 
	call *%rax
  8043b1:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  8043b3:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  8043b7:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  8043bb:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  8043be:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8043c5:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8043c6:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8043cb:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8043ce:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8043cf:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8043d2:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8043d9:	00 08 
		POPA_						// copy the register contents to the registers
  8043db:	4c 8b 3c 24          	mov    (%rsp),%r15
  8043df:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8043e4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8043e9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8043ee:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8043f3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8043f8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8043fd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804402:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804407:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80440c:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804411:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804416:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80441b:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804420:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804425:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804429:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  80442d:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80442e:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80442f:	c3                   	retq   

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
