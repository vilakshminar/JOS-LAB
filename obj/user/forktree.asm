
obj/user/forktree.debug:     file format elf64-x86-64


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
  80003c:	e8 2b 01 00 00       	callq  80016c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800050:	89 f0                	mov    %esi,%eax
  800052:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800055:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800059:	48 89 c7             	mov    %rax,%rdi
  80005c:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  800063:	00 00 00 
  800066:	ff d0                	callq  *%rax
  800068:	83 f8 02             	cmp    $0x2,%eax
  80006b:	7f 67                	jg     8000d4 <forkchild+0x90>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006d:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800071:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800075:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800079:	41 89 c8             	mov    %ecx,%r8d
  80007c:	48 89 d1             	mov    %rdx,%rcx
  80007f:	48 ba e0 44 80 00 00 	movabs $0x8044e0,%rdx
  800086:	00 00 00 
  800089:	be 04 00 00 00       	mov    $0x4,%esi
  80008e:	48 89 c7             	mov    %rax,%rdi
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	49 b9 ca 0d 80 00 00 	movabs $0x800dca,%r9
  80009d:	00 00 00 
  8000a0:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a3:	48 b8 27 1f 80 00 00 	movabs $0x801f27,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	75 22                	jne    8000d5 <forkchild+0x91>
		forktree(nxt);
  8000b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b7:	48 89 c7             	mov    %rax,%rdi
  8000ba:	48 b8 d7 00 80 00 00 	movabs $0x8000d7,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		exit();
  8000c6:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
  8000d2:	eb 01                	jmp    8000d5 <forkchild+0x91>
forkchild(const char *cur, char branch)
{
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
		return;
  8000d4:	90                   	nop
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
	if (fork() == 0) {
		forktree(nxt);
		exit();
	}
}
  8000d5:	c9                   	leaveq 
  8000d6:	c3                   	retq   

00000000008000d7 <forktree>:

void
forktree(const char *cur)
{
  8000d7:	55                   	push   %rbp
  8000d8:	48 89 e5             	mov    %rsp,%rbp
  8000db:	48 83 ec 10          	sub    $0x10,%rsp
  8000df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000e3:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  8000ea:	00 00 00 
  8000ed:	ff d0                	callq  *%rax
  8000ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	48 bf e5 44 80 00 00 	movabs $0x8044e5,%rdi
  8000fc:	00 00 00 
  8000ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800104:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  80010b:	00 00 00 
  80010e:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  800110:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800114:	be 30 00 00 00       	mov    $0x30,%esi
  800119:	48 89 c7             	mov    %rax,%rdi
  80011c:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80012c:	be 31 00 00 00       	mov    $0x31,%esi
  800131:	48 89 c7             	mov    %rax,%rdi
  800134:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80013b:	00 00 00 
  80013e:	ff d0                	callq  *%rax
}
  800140:	c9                   	leaveq 
  800141:	c3                   	retq   

0000000000800142 <umain>:

void
umain(int argc, char **argv)
{
  800142:	55                   	push   %rbp
  800143:	48 89 e5             	mov    %rsp,%rbp
  800146:	48 83 ec 10          	sub    $0x10,%rsp
  80014a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  800151:	48 bf f6 44 80 00 00 	movabs $0x8044f6,%rdi
  800158:	00 00 00 
  80015b:	48 b8 d7 00 80 00 00 	movabs $0x8000d7,%rax
  800162:	00 00 00 
  800165:	ff d0                	callq  *%rax
}
  800167:	c9                   	leaveq 
  800168:	c3                   	retq   
  800169:	00 00                	add    %al,(%rax)
	...

000000000080016c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %rbp
  80016d:	48 89 e5             	mov    %rsp,%rbp
  800170:	48 83 ec 10          	sub    $0x10,%rsp
  800174:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800177:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80017b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800182:	00 00 00 
  800185:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80018c:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
  800198:	48 98                	cltq   
  80019a:	48 89 c2             	mov    %rax,%rdx
  80019d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001a3:	48 89 d0             	mov    %rdx,%rax
  8001a6:	48 c1 e0 03          	shl    $0x3,%rax
  8001aa:	48 01 d0             	add    %rdx,%rax
  8001ad:	48 c1 e0 05          	shl    $0x5,%rax
  8001b1:	48 89 c2             	mov    %rax,%rdx
  8001b4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001bb:	00 00 00 
  8001be:	48 01 c2             	add    %rax,%rdx
  8001c1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001c8:	00 00 00 
  8001cb:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d2:	7e 14                	jle    8001e8 <libmain+0x7c>
		binaryname = argv[0];
  8001d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001d8:	48 8b 10             	mov    (%rax),%rdx
  8001db:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001e2:	00 00 00 
  8001e5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ef:	48 89 d6             	mov    %rdx,%rsi
  8001f2:	89 c7                	mov    %eax,%edi
  8001f4:	48 b8 42 01 80 00 00 	movabs $0x800142,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800200:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
}
  80020c:	c9                   	leaveq 
  80020d:	c3                   	retq   
	...

0000000000800210 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800214:	48 b8 95 25 80 00 00 	movabs $0x802595,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800220:	bf 00 00 00 00       	mov    $0x0,%edi
  800225:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
}
  800231:	5d                   	pop    %rbp
  800232:	c3                   	retq   
	...

0000000000800234 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800234:	55                   	push   %rbp
  800235:	48 89 e5             	mov    %rsp,%rbp
  800238:	48 83 ec 10          	sub    $0x10,%rsp
  80023c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80023f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800247:	8b 00                	mov    (%rax),%eax
  800249:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80024c:	89 d6                	mov    %edx,%esi
  80024e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800252:	48 63 d0             	movslq %eax,%rdx
  800255:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80025a:	8d 50 01             	lea    0x1(%rax),%edx
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800263:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800267:	8b 00                	mov    (%rax),%eax
  800269:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026e:	75 2c                	jne    80029c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800274:	8b 00                	mov    (%rax),%eax
  800276:	48 98                	cltq   
  800278:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80027c:	48 83 c2 08          	add    $0x8,%rdx
  800280:	48 89 c6             	mov    %rax,%rsi
  800283:	48 89 d7             	mov    %rdx,%rdi
  800286:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  80028d:	00 00 00 
  800290:	ff d0                	callq  *%rax
		b->idx = 0;
  800292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800296:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80029c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a0:	8b 40 04             	mov    0x4(%rax),%eax
  8002a3:	8d 50 01             	lea    0x1(%rax),%edx
  8002a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002aa:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002ad:	c9                   	leaveq 
  8002ae:	c3                   	retq   

00000000008002af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002af:	55                   	push   %rbp
  8002b0:	48 89 e5             	mov    %rsp,%rbp
  8002b3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002ba:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002c1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8002c8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002cf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002d6:	48 8b 0a             	mov    (%rdx),%rcx
  8002d9:	48 89 08             	mov    %rcx,(%rax)
  8002dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002f3:	00 00 00 
	b.cnt = 0;
  8002f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800300:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800307:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80030e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800315:	48 89 c6             	mov    %rax,%rsi
  800318:	48 bf 34 02 80 00 00 	movabs $0x800234,%rdi
  80031f:	00 00 00 
  800322:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800329:	00 00 00 
  80032c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80032e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800334:	48 98                	cltq   
  800336:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80033d:	48 83 c2 08          	add    $0x8,%rdx
  800341:	48 89 c6             	mov    %rax,%rsi
  800344:	48 89 d7             	mov    %rdx,%rdi
  800347:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800353:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800359:	c9                   	leaveq 
  80035a:	c3                   	retq   

000000000080035b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800366:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80036d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800374:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80037b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800382:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800389:	84 c0                	test   %al,%al
  80038b:	74 20                	je     8003ad <cprintf+0x52>
  80038d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800391:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800395:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800399:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80039d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003a1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003a5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003a9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8003ad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8003b4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003bb:	00 00 00 
  8003be:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003c5:	00 00 00 
  8003c8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003cc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003d3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003da:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003e1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003e8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003ef:	48 8b 0a             	mov    (%rdx),%rcx
  8003f2:	48 89 08             	mov    %rcx,(%rax)
  8003f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800401:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800405:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80040c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800413:	48 89 d6             	mov    %rdx,%rsi
  800416:	48 89 c7             	mov    %rax,%rdi
  800419:	48 b8 af 02 80 00 00 	movabs $0x8002af,%rax
  800420:	00 00 00 
  800423:	ff d0                	callq  *%rax
  800425:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80042b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800431:	c9                   	leaveq 
  800432:	c3                   	retq   
	...

0000000000800434 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800434:	55                   	push   %rbp
  800435:	48 89 e5             	mov    %rsp,%rbp
  800438:	48 83 ec 30          	sub    $0x30,%rsp
  80043c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800440:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800444:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800448:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80044b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80044f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800453:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800456:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80045a:	77 52                	ja     8004ae <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80045f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800463:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800466:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80046a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
  800473:	48 f7 75 d0          	divq   -0x30(%rbp)
  800477:	48 89 c2             	mov    %rax,%rdx
  80047a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80047d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800480:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800488:	41 89 f9             	mov    %edi,%r9d
  80048b:	48 89 c7             	mov    %rax,%rdi
  80048e:	48 b8 34 04 80 00 00 	movabs $0x800434,%rax
  800495:	00 00 00 
  800498:	ff d0                	callq  *%rax
  80049a:	eb 1c                	jmp    8004b8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80049c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8004a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004a7:	48 89 d6             	mov    %rdx,%rsi
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004ae:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8004b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8004b6:	7f e4                	jg     80049c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c4:	48 f7 f1             	div    %rcx
  8004c7:	48 89 d0             	mov    %rdx,%rax
  8004ca:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  8004d1:	00 00 00 
  8004d4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004d8:	0f be c0             	movsbl %al,%eax
  8004db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004df:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004e3:	48 89 d6             	mov    %rdx,%rsi
  8004e6:	89 c7                	mov    %eax,%edi
  8004e8:	ff d1                	callq  *%rcx
}
  8004ea:	c9                   	leaveq 
  8004eb:	c3                   	retq   

00000000008004ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ec:	55                   	push   %rbp
  8004ed:	48 89 e5             	mov    %rsp,%rbp
  8004f0:	48 83 ec 20          	sub    $0x20,%rsp
  8004f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004ff:	7e 52                	jle    800553 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800505:	8b 00                	mov    (%rax),%eax
  800507:	83 f8 30             	cmp    $0x30,%eax
  80050a:	73 24                	jae    800530 <getuint+0x44>
  80050c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800510:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	8b 00                	mov    (%rax),%eax
  80051a:	89 c0                	mov    %eax,%eax
  80051c:	48 01 d0             	add    %rdx,%rax
  80051f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800523:	8b 12                	mov    (%rdx),%edx
  800525:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800528:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052c:	89 0a                	mov    %ecx,(%rdx)
  80052e:	eb 17                	jmp    800547 <getuint+0x5b>
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800538:	48 89 d0             	mov    %rdx,%rax
  80053b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80053f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800543:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800547:	48 8b 00             	mov    (%rax),%rax
  80054a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80054e:	e9 a3 00 00 00       	jmpq   8005f6 <getuint+0x10a>
	else if (lflag)
  800553:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800557:	74 4f                	je     8005a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	8b 00                	mov    (%rax),%eax
  80055f:	83 f8 30             	cmp    $0x30,%eax
  800562:	73 24                	jae    800588 <getuint+0x9c>
  800564:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800568:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	8b 00                	mov    (%rax),%eax
  800572:	89 c0                	mov    %eax,%eax
  800574:	48 01 d0             	add    %rdx,%rax
  800577:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057b:	8b 12                	mov    (%rdx),%edx
  80057d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800580:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800584:	89 0a                	mov    %ecx,(%rdx)
  800586:	eb 17                	jmp    80059f <getuint+0xb3>
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800590:	48 89 d0             	mov    %rdx,%rax
  800593:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800597:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80059f:	48 8b 00             	mov    (%rax),%rax
  8005a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005a6:	eb 4e                	jmp    8005f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	8b 00                	mov    (%rax),%eax
  8005ae:	83 f8 30             	cmp    $0x30,%eax
  8005b1:	73 24                	jae    8005d7 <getuint+0xeb>
  8005b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	8b 00                	mov    (%rax),%eax
  8005c1:	89 c0                	mov    %eax,%eax
  8005c3:	48 01 d0             	add    %rdx,%rax
  8005c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ca:	8b 12                	mov    (%rdx),%edx
  8005cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	89 0a                	mov    %ecx,(%rdx)
  8005d5:	eb 17                	jmp    8005ee <getuint+0x102>
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005df:	48 89 d0             	mov    %rdx,%rax
  8005e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005fa:	c9                   	leaveq 
  8005fb:	c3                   	retq   

00000000008005fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005fc:	55                   	push   %rbp
  8005fd:	48 89 e5             	mov    %rsp,%rbp
  800600:	48 83 ec 20          	sub    $0x20,%rsp
  800604:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800608:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80060b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80060f:	7e 52                	jle    800663 <getint+0x67>
		x=va_arg(*ap, long long);
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	8b 00                	mov    (%rax),%eax
  800617:	83 f8 30             	cmp    $0x30,%eax
  80061a:	73 24                	jae    800640 <getint+0x44>
  80061c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800620:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	8b 00                	mov    (%rax),%eax
  80062a:	89 c0                	mov    %eax,%eax
  80062c:	48 01 d0             	add    %rdx,%rax
  80062f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800633:	8b 12                	mov    (%rdx),%edx
  800635:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800638:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063c:	89 0a                	mov    %ecx,(%rdx)
  80063e:	eb 17                	jmp    800657 <getint+0x5b>
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800648:	48 89 d0             	mov    %rdx,%rax
  80064b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800657:	48 8b 00             	mov    (%rax),%rax
  80065a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80065e:	e9 a3 00 00 00       	jmpq   800706 <getint+0x10a>
	else if (lflag)
  800663:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800667:	74 4f                	je     8006b8 <getint+0xbc>
		x=va_arg(*ap, long);
  800669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066d:	8b 00                	mov    (%rax),%eax
  80066f:	83 f8 30             	cmp    $0x30,%eax
  800672:	73 24                	jae    800698 <getint+0x9c>
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	8b 00                	mov    (%rax),%eax
  800682:	89 c0                	mov    %eax,%eax
  800684:	48 01 d0             	add    %rdx,%rax
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	8b 12                	mov    (%rdx),%edx
  80068d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800690:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800694:	89 0a                	mov    %ecx,(%rdx)
  800696:	eb 17                	jmp    8006af <getint+0xb3>
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a0:	48 89 d0             	mov    %rdx,%rax
  8006a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006af:	48 8b 00             	mov    (%rax),%rax
  8006b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b6:	eb 4e                	jmp    800706 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	8b 00                	mov    (%rax),%eax
  8006be:	83 f8 30             	cmp    $0x30,%eax
  8006c1:	73 24                	jae    8006e7 <getint+0xeb>
  8006c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	8b 00                	mov    (%rax),%eax
  8006d1:	89 c0                	mov    %eax,%eax
  8006d3:	48 01 d0             	add    %rdx,%rax
  8006d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006da:	8b 12                	mov    (%rdx),%edx
  8006dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	89 0a                	mov    %ecx,(%rdx)
  8006e5:	eb 17                	jmp    8006fe <getint+0x102>
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006ef:	48 89 d0             	mov    %rdx,%rax
  8006f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	48 98                	cltq   
  800702:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80070a:	c9                   	leaveq 
  80070b:	c3                   	retq   

000000000080070c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %rbp
  80070d:	48 89 e5             	mov    %rsp,%rbp
  800710:	41 54                	push   %r12
  800712:	53                   	push   %rbx
  800713:	48 83 ec 60          	sub    $0x60,%rsp
  800717:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80071b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80071f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800723:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800727:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80072b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80072f:	48 8b 0a             	mov    (%rdx),%rcx
  800732:	48 89 08             	mov    %rcx,(%rax)
  800735:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800739:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80073d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800741:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800745:	eb 17                	jmp    80075e <vprintfmt+0x52>
			if (ch == '\0')
  800747:	85 db                	test   %ebx,%ebx
  800749:	0f 84 d7 04 00 00    	je     800c26 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80074f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800753:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800757:	48 89 c6             	mov    %rax,%rsi
  80075a:	89 df                	mov    %ebx,%edi
  80075c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800762:	0f b6 00             	movzbl (%rax),%eax
  800765:	0f b6 d8             	movzbl %al,%ebx
  800768:	83 fb 25             	cmp    $0x25,%ebx
  80076b:	0f 95 c0             	setne  %al
  80076e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800773:	84 c0                	test   %al,%al
  800775:	75 d0                	jne    800747 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800777:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80077b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800782:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800789:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800790:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800797:	eb 04                	jmp    80079d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800799:	90                   	nop
  80079a:	eb 01                	jmp    80079d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80079c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007a1:	0f b6 00             	movzbl (%rax),%eax
  8007a4:	0f b6 d8             	movzbl %al,%ebx
  8007a7:	89 d8                	mov    %ebx,%eax
  8007a9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8007ae:	83 e8 23             	sub    $0x23,%eax
  8007b1:	83 f8 55             	cmp    $0x55,%eax
  8007b4:	0f 87 38 04 00 00    	ja     800bf2 <vprintfmt+0x4e6>
  8007ba:	89 c0                	mov    %eax,%eax
  8007bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007c3:	00 
  8007c4:	48 b8 10 47 80 00 00 	movabs $0x804710,%rax
  8007cb:	00 00 00 
  8007ce:	48 01 d0             	add    %rdx,%rax
  8007d1:	48 8b 00             	mov    (%rax),%rax
  8007d4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007da:	eb c1                	jmp    80079d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007e0:	eb bb                	jmp    80079d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800801:	0f b6 00             	movzbl (%rax),%eax
  800804:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800807:	83 fb 2f             	cmp    $0x2f,%ebx
  80080a:	7e 63                	jle    80086f <vprintfmt+0x163>
  80080c:	83 fb 39             	cmp    $0x39,%ebx
  80080f:	7f 5e                	jg     80086f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800811:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800816:	eb d1                	jmp    8007e9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800818:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80081b:	83 f8 30             	cmp    $0x30,%eax
  80081e:	73 17                	jae    800837 <vprintfmt+0x12b>
  800820:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800824:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800827:	89 c0                	mov    %eax,%eax
  800829:	48 01 d0             	add    %rdx,%rax
  80082c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80082f:	83 c2 08             	add    $0x8,%edx
  800832:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800835:	eb 0f                	jmp    800846 <vprintfmt+0x13a>
  800837:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80083b:	48 89 d0             	mov    %rdx,%rax
  80083e:	48 83 c2 08          	add    $0x8,%rdx
  800842:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800846:	8b 00                	mov    (%rax),%eax
  800848:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80084b:	eb 23                	jmp    800870 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80084d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800851:	0f 89 42 ff ff ff    	jns    800799 <vprintfmt+0x8d>
				width = 0;
  800857:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80085e:	e9 36 ff ff ff       	jmpq   800799 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800863:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80086a:	e9 2e ff ff ff       	jmpq   80079d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80086f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800870:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800874:	0f 89 22 ff ff ff    	jns    80079c <vprintfmt+0x90>
				width = precision, precision = -1;
  80087a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80087d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800880:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800887:	e9 10 ff ff ff       	jmpq   80079c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80088c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800890:	e9 08 ff ff ff       	jmpq   80079d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800895:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800898:	83 f8 30             	cmp    $0x30,%eax
  80089b:	73 17                	jae    8008b4 <vprintfmt+0x1a8>
  80089d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a4:	89 c0                	mov    %eax,%eax
  8008a6:	48 01 d0             	add    %rdx,%rax
  8008a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ac:	83 c2 08             	add    $0x8,%edx
  8008af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b2:	eb 0f                	jmp    8008c3 <vprintfmt+0x1b7>
  8008b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b8:	48 89 d0             	mov    %rdx,%rax
  8008bb:	48 83 c2 08          	add    $0x8,%rdx
  8008bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c3:	8b 00                	mov    (%rax),%eax
  8008c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008c9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8008cd:	48 89 d6             	mov    %rdx,%rsi
  8008d0:	89 c7                	mov    %eax,%edi
  8008d2:	ff d1                	callq  *%rcx
			break;
  8008d4:	e9 47 03 00 00       	jmpq   800c20 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8008d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008dc:	83 f8 30             	cmp    $0x30,%eax
  8008df:	73 17                	jae    8008f8 <vprintfmt+0x1ec>
  8008e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e8:	89 c0                	mov    %eax,%eax
  8008ea:	48 01 d0             	add    %rdx,%rax
  8008ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f0:	83 c2 08             	add    $0x8,%edx
  8008f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008f6:	eb 0f                	jmp    800907 <vprintfmt+0x1fb>
  8008f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008fc:	48 89 d0             	mov    %rdx,%rax
  8008ff:	48 83 c2 08          	add    $0x8,%rdx
  800903:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800907:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800909:	85 db                	test   %ebx,%ebx
  80090b:	79 02                	jns    80090f <vprintfmt+0x203>
				err = -err;
  80090d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80090f:	83 fb 10             	cmp    $0x10,%ebx
  800912:	7f 16                	jg     80092a <vprintfmt+0x21e>
  800914:	48 b8 60 46 80 00 00 	movabs $0x804660,%rax
  80091b:	00 00 00 
  80091e:	48 63 d3             	movslq %ebx,%rdx
  800921:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800925:	4d 85 e4             	test   %r12,%r12
  800928:	75 2e                	jne    800958 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80092a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80092e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800932:	89 d9                	mov    %ebx,%ecx
  800934:	48 ba f9 46 80 00 00 	movabs $0x8046f9,%rdx
  80093b:	00 00 00 
  80093e:	48 89 c7             	mov    %rax,%rdi
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	49 b8 30 0c 80 00 00 	movabs $0x800c30,%r8
  80094d:	00 00 00 
  800950:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800953:	e9 c8 02 00 00       	jmpq   800c20 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800958:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80095c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800960:	4c 89 e1             	mov    %r12,%rcx
  800963:	48 ba 02 47 80 00 00 	movabs $0x804702,%rdx
  80096a:	00 00 00 
  80096d:	48 89 c7             	mov    %rax,%rdi
  800970:	b8 00 00 00 00       	mov    $0x0,%eax
  800975:	49 b8 30 0c 80 00 00 	movabs $0x800c30,%r8
  80097c:	00 00 00 
  80097f:	41 ff d0             	callq  *%r8
			break;
  800982:	e9 99 02 00 00       	jmpq   800c20 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800987:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80098a:	83 f8 30             	cmp    $0x30,%eax
  80098d:	73 17                	jae    8009a6 <vprintfmt+0x29a>
  80098f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800993:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800996:	89 c0                	mov    %eax,%eax
  800998:	48 01 d0             	add    %rdx,%rax
  80099b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80099e:	83 c2 08             	add    $0x8,%edx
  8009a1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009a4:	eb 0f                	jmp    8009b5 <vprintfmt+0x2a9>
  8009a6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009aa:	48 89 d0             	mov    %rdx,%rax
  8009ad:	48 83 c2 08          	add    $0x8,%rdx
  8009b1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b5:	4c 8b 20             	mov    (%rax),%r12
  8009b8:	4d 85 e4             	test   %r12,%r12
  8009bb:	75 0a                	jne    8009c7 <vprintfmt+0x2bb>
				p = "(null)";
  8009bd:	49 bc 05 47 80 00 00 	movabs $0x804705,%r12
  8009c4:	00 00 00 
			if (width > 0 && padc != '-')
  8009c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cb:	7e 7a                	jle    800a47 <vprintfmt+0x33b>
  8009cd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009d1:	74 74                	je     800a47 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d6:	48 98                	cltq   
  8009d8:	48 89 c6             	mov    %rax,%rsi
  8009db:	4c 89 e7             	mov    %r12,%rdi
  8009de:	48 b8 da 0e 80 00 00 	movabs $0x800eda,%rax
  8009e5:	00 00 00 
  8009e8:	ff d0                	callq  *%rax
  8009ea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009ed:	eb 17                	jmp    800a06 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8009ef:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8009f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009fb:	48 89 d6             	mov    %rdx,%rsi
  8009fe:	89 c7                	mov    %eax,%edi
  800a00:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a0a:	7f e3                	jg     8009ef <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0c:	eb 39                	jmp    800a47 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a12:	74 1e                	je     800a32 <vprintfmt+0x326>
  800a14:	83 fb 1f             	cmp    $0x1f,%ebx
  800a17:	7e 05                	jle    800a1e <vprintfmt+0x312>
  800a19:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1c:	7e 14                	jle    800a32 <vprintfmt+0x326>
					putch('?', putdat);
  800a1e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a22:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a26:	48 89 c6             	mov    %rax,%rsi
  800a29:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a2e:	ff d2                	callq  *%rdx
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800a32:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a36:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a3a:	48 89 c6             	mov    %rax,%rsi
  800a3d:	89 df                	mov    %ebx,%edi
  800a3f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a45:	eb 01                	jmp    800a48 <vprintfmt+0x33c>
  800a47:	90                   	nop
  800a48:	41 0f b6 04 24       	movzbl (%r12),%eax
  800a4d:	0f be d8             	movsbl %al,%ebx
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	0f 95 c0             	setne  %al
  800a55:	49 83 c4 01          	add    $0x1,%r12
  800a59:	84 c0                	test   %al,%al
  800a5b:	74 28                	je     800a85 <vprintfmt+0x379>
  800a5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a61:	78 ab                	js     800a0e <vprintfmt+0x302>
  800a63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a6b:	79 a1                	jns    800a0e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a6d:	eb 16                	jmp    800a85 <vprintfmt+0x379>
				putch(' ', putdat);
  800a6f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a73:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a77:	48 89 c6             	mov    %rax,%rsi
  800a7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800a7f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a89:	7f e4                	jg     800a6f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800a8b:	e9 90 01 00 00       	jmpq   800c20 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a94:	be 03 00 00 00       	mov    $0x3,%esi
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	48 b8 fc 05 80 00 00 	movabs $0x8005fc,%rax
  800aa3:	00 00 00 
  800aa6:	ff d0                	callq  *%rax
  800aa8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800aac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab0:	48 85 c0             	test   %rax,%rax
  800ab3:	79 1d                	jns    800ad2 <vprintfmt+0x3c6>
				putch('-', putdat);
  800ab5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800abd:	48 89 c6             	mov    %rax,%rsi
  800ac0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ac5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800ac7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acb:	48 f7 d8             	neg    %rax
  800ace:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ad2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ad9:	e9 d5 00 00 00       	jmpq   800bb3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ade:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae2:	be 03 00 00 00       	mov    $0x3,%esi
  800ae7:	48 89 c7             	mov    %rax,%rdi
  800aea:	48 b8 ec 04 80 00 00 	movabs $0x8004ec,%rax
  800af1:	00 00 00 
  800af4:	ff d0                	callq  *%rax
  800af6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800afa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b01:	e9 ad 00 00 00       	jmpq   800bb3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800b06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0a:	be 03 00 00 00       	mov    $0x3,%esi
  800b0f:	48 89 c7             	mov    %rax,%rdi
  800b12:	48 b8 ec 04 80 00 00 	movabs $0x8004ec,%rax
  800b19:	00 00 00 
  800b1c:	ff d0                	callq  *%rax
  800b1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800b22:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b29:	e9 85 00 00 00       	jmpq   800bb3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800b2e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b36:	48 89 c6             	mov    %rax,%rsi
  800b39:	bf 30 00 00 00       	mov    $0x30,%edi
  800b3e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800b40:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b44:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b48:	48 89 c6             	mov    %rax,%rsi
  800b4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800b50:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b55:	83 f8 30             	cmp    $0x30,%eax
  800b58:	73 17                	jae    800b71 <vprintfmt+0x465>
  800b5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b61:	89 c0                	mov    %eax,%eax
  800b63:	48 01 d0             	add    %rdx,%rax
  800b66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b69:	83 c2 08             	add    $0x8,%edx
  800b6c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b6f:	eb 0f                	jmp    800b80 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800b71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b75:	48 89 d0             	mov    %rdx,%rax
  800b78:	48 83 c2 08          	add    $0x8,%rdx
  800b7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b80:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b8e:	eb 23                	jmp    800bb3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b94:	be 03 00 00 00       	mov    $0x3,%esi
  800b99:	48 89 c7             	mov    %rax,%rdi
  800b9c:	48 b8 ec 04 80 00 00 	movabs $0x8004ec,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	callq  *%rax
  800ba8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bb3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bbb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bca:	45 89 c1             	mov    %r8d,%r9d
  800bcd:	41 89 f8             	mov    %edi,%r8d
  800bd0:	48 89 c7             	mov    %rax,%rdi
  800bd3:	48 b8 34 04 80 00 00 	movabs $0x800434,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax
			break;
  800bdf:	eb 3f                	jmp    800c20 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800be5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800be9:	48 89 c6             	mov    %rax,%rsi
  800bec:	89 df                	mov    %ebx,%edi
  800bee:	ff d2                	callq  *%rdx
			break;
  800bf0:	eb 2e                	jmp    800c20 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bfa:	48 89 c6             	mov    %rax,%rsi
  800bfd:	bf 25 00 00 00       	mov    $0x25,%edi
  800c02:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c09:	eb 05                	jmp    800c10 <vprintfmt+0x504>
  800c0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c14:	48 83 e8 01          	sub    $0x1,%rax
  800c18:	0f b6 00             	movzbl (%rax),%eax
  800c1b:	3c 25                	cmp    $0x25,%al
  800c1d:	75 ec                	jne    800c0b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800c1f:	90                   	nop
		}
	}
  800c20:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c21:	e9 38 fb ff ff       	jmpq   80075e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800c26:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800c27:	48 83 c4 60          	add    $0x60,%rsp
  800c2b:	5b                   	pop    %rbx
  800c2c:	41 5c                	pop    %r12
  800c2e:	5d                   	pop    %rbp
  800c2f:	c3                   	retq   

0000000000800c30 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c30:	55                   	push   %rbp
  800c31:	48 89 e5             	mov    %rsp,%rbp
  800c34:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c3b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c42:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c5e:	84 c0                	test   %al,%al
  800c60:	74 20                	je     800c82 <printfmt+0x52>
  800c62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c82:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c89:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c90:	00 00 00 
  800c93:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c9a:	00 00 00 
  800c9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ca1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ca8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800caf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cb6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cbd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cc4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ccb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cd2:	48 89 c7             	mov    %rax,%rdi
  800cd5:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800cdc:	00 00 00 
  800cdf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ce1:	c9                   	leaveq 
  800ce2:	c3                   	retq   

0000000000800ce3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ce3:	55                   	push   %rbp
  800ce4:	48 89 e5             	mov    %rsp,%rbp
  800ce7:	48 83 ec 10          	sub    $0x10,%rsp
  800ceb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cf2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf6:	8b 40 10             	mov    0x10(%rax),%eax
  800cf9:	8d 50 01             	lea    0x1(%rax),%edx
  800cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d00:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d07:	48 8b 10             	mov    (%rax),%rdx
  800d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d0e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d12:	48 39 c2             	cmp    %rax,%rdx
  800d15:	73 17                	jae    800d2e <sprintputch+0x4b>
		*b->buf++ = ch;
  800d17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d1b:	48 8b 00             	mov    (%rax),%rax
  800d1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d21:	88 10                	mov    %dl,(%rax)
  800d23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800d27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d2b:	48 89 10             	mov    %rdx,(%rax)
}
  800d2e:	c9                   	leaveq 
  800d2f:	c3                   	retq   

0000000000800d30 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d30:	55                   	push   %rbp
  800d31:	48 89 e5             	mov    %rsp,%rbp
  800d34:	48 83 ec 50          	sub    $0x50,%rsp
  800d38:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d3c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d3f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d43:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d47:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d4b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d4f:	48 8b 0a             	mov    (%rdx),%rcx
  800d52:	48 89 08             	mov    %rcx,(%rax)
  800d55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d65:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d69:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d6d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d70:	48 98                	cltq   
  800d72:	48 83 e8 01          	sub    $0x1,%rax
  800d76:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800d7a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d85:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d8a:	74 06                	je     800d92 <vsnprintf+0x62>
  800d8c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d90:	7f 07                	jg     800d99 <vsnprintf+0x69>
		return -E_INVAL;
  800d92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d97:	eb 2f                	jmp    800dc8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d99:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d9d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800da1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800da5:	48 89 c6             	mov    %rax,%rsi
  800da8:	48 bf e3 0c 80 00 00 	movabs $0x800ce3,%rdi
  800daf:	00 00 00 
  800db2:	48 b8 0c 07 80 00 00 	movabs $0x80070c,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dc2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800dc5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dc8:	c9                   	leaveq 
  800dc9:	c3                   	retq   

0000000000800dca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dca:	55                   	push   %rbp
  800dcb:	48 89 e5             	mov    %rsp,%rbp
  800dce:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800dd5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ddc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800de2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800de9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800df0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800df7:	84 c0                	test   %al,%al
  800df9:	74 20                	je     800e1b <snprintf+0x51>
  800dfb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e1b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e22:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e29:	00 00 00 
  800e2c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e33:	00 00 00 
  800e36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e3a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e41:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e48:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e4f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e56:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e5d:	48 8b 0a             	mov    (%rdx),%rcx
  800e60:	48 89 08             	mov    %rcx,(%rax)
  800e63:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e67:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e6b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e6f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e73:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e7a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e81:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e87:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e8e:	48 89 c7             	mov    %rax,%rdi
  800e91:	48 b8 30 0d 80 00 00 	movabs $0x800d30,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
  800e9d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ea3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ea9:	c9                   	leaveq 
  800eaa:	c3                   	retq   
	...

0000000000800eac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eac:	55                   	push   %rbp
  800ead:	48 89 e5             	mov    %rsp,%rbp
  800eb0:	48 83 ec 18          	sub    $0x18,%rsp
  800eb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800eb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ebf:	eb 09                	jmp    800eca <strlen+0x1e>
		n++;
  800ec1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ece:	0f b6 00             	movzbl (%rax),%eax
  800ed1:	84 c0                	test   %al,%al
  800ed3:	75 ec                	jne    800ec1 <strlen+0x15>
		n++;
	return n;
  800ed5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ed8:	c9                   	leaveq 
  800ed9:	c3                   	retq   

0000000000800eda <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eda:	55                   	push   %rbp
  800edb:	48 89 e5             	mov    %rsp,%rbp
  800ede:	48 83 ec 20          	sub    $0x20,%rsp
  800ee2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ef1:	eb 0e                	jmp    800f01 <strnlen+0x27>
		n++;
  800ef3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800efc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f01:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f06:	74 0b                	je     800f13 <strnlen+0x39>
  800f08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0c:	0f b6 00             	movzbl (%rax),%eax
  800f0f:	84 c0                	test   %al,%al
  800f11:	75 e0                	jne    800ef3 <strnlen+0x19>
		n++;
	return n;
  800f13:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f16:	c9                   	leaveq 
  800f17:	c3                   	retq   

0000000000800f18 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 83 ec 20          	sub    $0x20,%rsp
  800f20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f30:	90                   	nop
  800f31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f35:	0f b6 10             	movzbl (%rax),%edx
  800f38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3c:	88 10                	mov    %dl,(%rax)
  800f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f42:	0f b6 00             	movzbl (%rax),%eax
  800f45:	84 c0                	test   %al,%al
  800f47:	0f 95 c0             	setne  %al
  800f4a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f4f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800f54:	84 c0                	test   %al,%al
  800f56:	75 d9                	jne    800f31 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f5c:	c9                   	leaveq 
  800f5d:	c3                   	retq   

0000000000800f5e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f5e:	55                   	push   %rbp
  800f5f:	48 89 e5             	mov    %rsp,%rbp
  800f62:	48 83 ec 20          	sub    $0x20,%rsp
  800f66:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f6a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	48 89 c7             	mov    %rax,%rdi
  800f75:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  800f7c:	00 00 00 
  800f7f:	ff d0                	callq  *%rax
  800f81:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f87:	48 98                	cltq   
  800f89:	48 03 45 e8          	add    -0x18(%rbp),%rax
  800f8d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f91:	48 89 d6             	mov    %rdx,%rsi
  800f94:	48 89 c7             	mov    %rax,%rdi
  800f97:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  800f9e:	00 00 00 
  800fa1:	ff d0                	callq  *%rax
	return dst;
  800fa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fa7:	c9                   	leaveq 
  800fa8:	c3                   	retq   

0000000000800fa9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fa9:	55                   	push   %rbp
  800faa:	48 89 e5             	mov    %rsp,%rbp
  800fad:	48 83 ec 28          	sub    $0x28,%rsp
  800fb1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fb9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fc5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fcc:	00 
  800fcd:	eb 27                	jmp    800ff6 <strncpy+0x4d>
		*dst++ = *src;
  800fcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd3:	0f b6 10             	movzbl (%rax),%edx
  800fd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fda:	88 10                	mov    %dl,(%rax)
  800fdc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fe1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fe5:	0f b6 00             	movzbl (%rax),%eax
  800fe8:	84 c0                	test   %al,%al
  800fea:	74 05                	je     800ff1 <strncpy+0x48>
			src++;
  800fec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ff1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ffe:	72 cf                	jb     800fcf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801004:	c9                   	leaveq 
  801005:	c3                   	retq   

0000000000801006 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801006:	55                   	push   %rbp
  801007:	48 89 e5             	mov    %rsp,%rbp
  80100a:	48 83 ec 28          	sub    $0x28,%rsp
  80100e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801012:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801016:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80101a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801022:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801027:	74 37                	je     801060 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801029:	eb 17                	jmp    801042 <strlcpy+0x3c>
			*dst++ = *src++;
  80102b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80102f:	0f b6 10             	movzbl (%rax),%edx
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	88 10                	mov    %dl,(%rax)
  801038:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80103d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801042:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801047:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80104c:	74 0b                	je     801059 <strlcpy+0x53>
  80104e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801052:	0f b6 00             	movzbl (%rax),%eax
  801055:	84 c0                	test   %al,%al
  801057:	75 d2                	jne    80102b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801060:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801068:	48 89 d1             	mov    %rdx,%rcx
  80106b:	48 29 c1             	sub    %rax,%rcx
  80106e:	48 89 c8             	mov    %rcx,%rax
}
  801071:	c9                   	leaveq 
  801072:	c3                   	retq   

0000000000801073 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801073:	55                   	push   %rbp
  801074:	48 89 e5             	mov    %rsp,%rbp
  801077:	48 83 ec 10          	sub    $0x10,%rsp
  80107b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80107f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801083:	eb 0a                	jmp    80108f <strcmp+0x1c>
		p++, q++;
  801085:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80108a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80108f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801093:	0f b6 00             	movzbl (%rax),%eax
  801096:	84 c0                	test   %al,%al
  801098:	74 12                	je     8010ac <strcmp+0x39>
  80109a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109e:	0f b6 10             	movzbl (%rax),%edx
  8010a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	38 c2                	cmp    %al,%dl
  8010aa:	74 d9                	je     801085 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b0:	0f b6 00             	movzbl (%rax),%eax
  8010b3:	0f b6 d0             	movzbl %al,%edx
  8010b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ba:	0f b6 00             	movzbl (%rax),%eax
  8010bd:	0f b6 c0             	movzbl %al,%eax
  8010c0:	89 d1                	mov    %edx,%ecx
  8010c2:	29 c1                	sub    %eax,%ecx
  8010c4:	89 c8                	mov    %ecx,%eax
}
  8010c6:	c9                   	leaveq 
  8010c7:	c3                   	retq   

00000000008010c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010c8:	55                   	push   %rbp
  8010c9:	48 89 e5             	mov    %rsp,%rbp
  8010cc:	48 83 ec 18          	sub    $0x18,%rsp
  8010d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010dc:	eb 0f                	jmp    8010ed <strncmp+0x25>
		n--, p++, q++;
  8010de:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f2:	74 1d                	je     801111 <strncmp+0x49>
  8010f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f8:	0f b6 00             	movzbl (%rax),%eax
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 12                	je     801111 <strncmp+0x49>
  8010ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801103:	0f b6 10             	movzbl (%rax),%edx
  801106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	38 c2                	cmp    %al,%dl
  80110f:	74 cd                	je     8010de <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801111:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801116:	75 07                	jne    80111f <strncmp+0x57>
		return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
  80111d:	eb 1a                	jmp    801139 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	0f b6 d0             	movzbl %al,%edx
  801129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112d:	0f b6 00             	movzbl (%rax),%eax
  801130:	0f b6 c0             	movzbl %al,%eax
  801133:	89 d1                	mov    %edx,%ecx
  801135:	29 c1                	sub    %eax,%ecx
  801137:	89 c8                	mov    %ecx,%eax
}
  801139:	c9                   	leaveq 
  80113a:	c3                   	retq   

000000000080113b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80113b:	55                   	push   %rbp
  80113c:	48 89 e5             	mov    %rsp,%rbp
  80113f:	48 83 ec 10          	sub    $0x10,%rsp
  801143:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801147:	89 f0                	mov    %esi,%eax
  801149:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80114c:	eb 17                	jmp    801165 <strchr+0x2a>
		if (*s == c)
  80114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801152:	0f b6 00             	movzbl (%rax),%eax
  801155:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801158:	75 06                	jne    801160 <strchr+0x25>
			return (char *) s;
  80115a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115e:	eb 15                	jmp    801175 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801160:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	0f b6 00             	movzbl (%rax),%eax
  80116c:	84 c0                	test   %al,%al
  80116e:	75 de                	jne    80114e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801175:	c9                   	leaveq 
  801176:	c3                   	retq   

0000000000801177 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801177:	55                   	push   %rbp
  801178:	48 89 e5             	mov    %rsp,%rbp
  80117b:	48 83 ec 10          	sub    $0x10,%rsp
  80117f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801183:	89 f0                	mov    %esi,%eax
  801185:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801188:	eb 11                	jmp    80119b <strfind+0x24>
		if (*s == c)
  80118a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118e:	0f b6 00             	movzbl (%rax),%eax
  801191:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801194:	74 12                	je     8011a8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801196:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119f:	0f b6 00             	movzbl (%rax),%eax
  8011a2:	84 c0                	test   %al,%al
  8011a4:	75 e4                	jne    80118a <strfind+0x13>
  8011a6:	eb 01                	jmp    8011a9 <strfind+0x32>
		if (*s == c)
			break;
  8011a8:	90                   	nop
	return (char *) s;
  8011a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ad:	c9                   	leaveq 
  8011ae:	c3                   	retq   

00000000008011af <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011af:	55                   	push   %rbp
  8011b0:	48 89 e5             	mov    %rsp,%rbp
  8011b3:	48 83 ec 18          	sub    $0x18,%rsp
  8011b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011c7:	75 06                	jne    8011cf <memset+0x20>
		return v;
  8011c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011cd:	eb 69                	jmp    801238 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	83 e0 03             	and    $0x3,%eax
  8011d6:	48 85 c0             	test   %rax,%rax
  8011d9:	75 48                	jne    801223 <memset+0x74>
  8011db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011df:	83 e0 03             	and    $0x3,%eax
  8011e2:	48 85 c0             	test   %rax,%rax
  8011e5:	75 3c                	jne    801223 <memset+0x74>
		c &= 0xFF;
  8011e7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 e2 18             	shl    $0x18,%edx
  8011f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f9:	c1 e0 10             	shl    $0x10,%eax
  8011fc:	09 c2                	or     %eax,%edx
  8011fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801201:	c1 e0 08             	shl    $0x8,%eax
  801204:	09 d0                	or     %edx,%eax
  801206:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120d:	48 89 c1             	mov    %rax,%rcx
  801210:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801214:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801218:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80121b:	48 89 d7             	mov    %rdx,%rdi
  80121e:	fc                   	cld    
  80121f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801221:	eb 11                	jmp    801234 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801223:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801227:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80122a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80122e:	48 89 d7             	mov    %rdx,%rdi
  801231:	fc                   	cld    
  801232:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801238:	c9                   	leaveq 
  801239:	c3                   	retq   

000000000080123a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80123a:	55                   	push   %rbp
  80123b:	48 89 e5             	mov    %rsp,%rbp
  80123e:	48 83 ec 28          	sub    $0x28,%rsp
  801242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80124a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80124e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801256:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80125a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80125e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801262:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801266:	0f 83 88 00 00 00    	jae    8012f4 <memmove+0xba>
  80126c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801270:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801274:	48 01 d0             	add    %rdx,%rax
  801277:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80127b:	76 77                	jbe    8012f4 <memmove+0xba>
		s += n;
  80127d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801281:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801285:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801289:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80128d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801291:	83 e0 03             	and    $0x3,%eax
  801294:	48 85 c0             	test   %rax,%rax
  801297:	75 3b                	jne    8012d4 <memmove+0x9a>
  801299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129d:	83 e0 03             	and    $0x3,%eax
  8012a0:	48 85 c0             	test   %rax,%rax
  8012a3:	75 2f                	jne    8012d4 <memmove+0x9a>
  8012a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a9:	83 e0 03             	and    $0x3,%eax
  8012ac:	48 85 c0             	test   %rax,%rax
  8012af:	75 23                	jne    8012d4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b5:	48 83 e8 04          	sub    $0x4,%rax
  8012b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bd:	48 83 ea 04          	sub    $0x4,%rdx
  8012c1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012c5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012c9:	48 89 c7             	mov    %rax,%rdi
  8012cc:	48 89 d6             	mov    %rdx,%rsi
  8012cf:	fd                   	std    
  8012d0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012d2:	eb 1d                	jmp    8012f1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e8:	48 89 d7             	mov    %rdx,%rdi
  8012eb:	48 89 c1             	mov    %rax,%rcx
  8012ee:	fd                   	std    
  8012ef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012f1:	fc                   	cld    
  8012f2:	eb 57                	jmp    80134b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	83 e0 03             	and    $0x3,%eax
  8012fb:	48 85 c0             	test   %rax,%rax
  8012fe:	75 36                	jne    801336 <memmove+0xfc>
  801300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801304:	83 e0 03             	and    $0x3,%eax
  801307:	48 85 c0             	test   %rax,%rax
  80130a:	75 2a                	jne    801336 <memmove+0xfc>
  80130c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801310:	83 e0 03             	and    $0x3,%eax
  801313:	48 85 c0             	test   %rax,%rax
  801316:	75 1e                	jne    801336 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801318:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131c:	48 89 c1             	mov    %rax,%rcx
  80131f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801327:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132b:	48 89 c7             	mov    %rax,%rdi
  80132e:	48 89 d6             	mov    %rdx,%rsi
  801331:	fc                   	cld    
  801332:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801334:	eb 15                	jmp    80134b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80133a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80133e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801342:	48 89 c7             	mov    %rax,%rdi
  801345:	48 89 d6             	mov    %rdx,%rsi
  801348:	fc                   	cld    
  801349:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80134f:	c9                   	leaveq 
  801350:	c3                   	retq   

0000000000801351 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801351:	55                   	push   %rbp
  801352:	48 89 e5             	mov    %rsp,%rbp
  801355:	48 83 ec 18          	sub    $0x18,%rsp
  801359:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801361:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801365:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801369:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80136d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801371:	48 89 ce             	mov    %rcx,%rsi
  801374:	48 89 c7             	mov    %rax,%rdi
  801377:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  80137e:	00 00 00 
  801381:	ff d0                	callq  *%rax
}
  801383:	c9                   	leaveq 
  801384:	c3                   	retq   

0000000000801385 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801385:	55                   	push   %rbp
  801386:	48 89 e5             	mov    %rsp,%rbp
  801389:	48 83 ec 28          	sub    $0x28,%rsp
  80138d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801391:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801395:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013a9:	eb 38                	jmp    8013e3 <memcmp+0x5e>
		if (*s1 != *s2)
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	0f b6 10             	movzbl (%rax),%edx
  8013b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b6:	0f b6 00             	movzbl (%rax),%eax
  8013b9:	38 c2                	cmp    %al,%dl
  8013bb:	74 1c                	je     8013d9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8013bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c1:	0f b6 00             	movzbl (%rax),%eax
  8013c4:	0f b6 d0             	movzbl %al,%edx
  8013c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013cb:	0f b6 00             	movzbl (%rax),%eax
  8013ce:	0f b6 c0             	movzbl %al,%eax
  8013d1:	89 d1                	mov    %edx,%ecx
  8013d3:	29 c1                	sub    %eax,%ecx
  8013d5:	89 c8                	mov    %ecx,%eax
  8013d7:	eb 20                	jmp    8013f9 <memcmp+0x74>
		s1++, s2++;
  8013d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013e8:	0f 95 c0             	setne  %al
  8013eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013f0:	84 c0                	test   %al,%al
  8013f2:	75 b7                	jne    8013ab <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f9:	c9                   	leaveq 
  8013fa:	c3                   	retq   

00000000008013fb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013fb:	55                   	push   %rbp
  8013fc:	48 89 e5             	mov    %rsp,%rbp
  8013ff:	48 83 ec 28          	sub    $0x28,%rsp
  801403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801407:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80140a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80140e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801412:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801416:	48 01 d0             	add    %rdx,%rax
  801419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80141d:	eb 13                	jmp    801432 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80141f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801423:	0f b6 10             	movzbl (%rax),%edx
  801426:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801429:	38 c2                	cmp    %al,%dl
  80142b:	74 11                	je     80143e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80142d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801436:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80143a:	72 e3                	jb     80141f <memfind+0x24>
  80143c:	eb 01                	jmp    80143f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80143e:	90                   	nop
	return (void *) s;
  80143f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801443:	c9                   	leaveq 
  801444:	c3                   	retq   

0000000000801445 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801445:	55                   	push   %rbp
  801446:	48 89 e5             	mov    %rsp,%rbp
  801449:	48 83 ec 38          	sub    $0x38,%rsp
  80144d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801451:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801455:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80145f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801466:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801467:	eb 05                	jmp    80146e <strtol+0x29>
		s++;
  801469:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3c 20                	cmp    $0x20,%al
  801477:	74 f0                	je     801469 <strtol+0x24>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	3c 09                	cmp    $0x9,%al
  801482:	74 e5                	je     801469 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	3c 2b                	cmp    $0x2b,%al
  80148d:	75 07                	jne    801496 <strtol+0x51>
		s++;
  80148f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801494:	eb 17                	jmp    8014ad <strtol+0x68>
	else if (*s == '-')
  801496:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	3c 2d                	cmp    $0x2d,%al
  80149f:	75 0c                	jne    8014ad <strtol+0x68>
		s++, neg = 1;
  8014a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014b1:	74 06                	je     8014b9 <strtol+0x74>
  8014b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014b7:	75 28                	jne    8014e1 <strtol+0x9c>
  8014b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bd:	0f b6 00             	movzbl (%rax),%eax
  8014c0:	3c 30                	cmp    $0x30,%al
  8014c2:	75 1d                	jne    8014e1 <strtol+0x9c>
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	48 83 c0 01          	add    $0x1,%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	3c 78                	cmp    $0x78,%al
  8014d1:	75 0e                	jne    8014e1 <strtol+0x9c>
		s += 2, base = 16;
  8014d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014df:	eb 2c                	jmp    80150d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014e5:	75 19                	jne    801500 <strtol+0xbb>
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	3c 30                	cmp    $0x30,%al
  8014f0:	75 0e                	jne    801500 <strtol+0xbb>
		s++, base = 8;
  8014f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014fe:	eb 0d                	jmp    80150d <strtol+0xc8>
	else if (base == 0)
  801500:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801504:	75 07                	jne    80150d <strtol+0xc8>
		base = 10;
  801506:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	3c 2f                	cmp    $0x2f,%al
  801516:	7e 1d                	jle    801535 <strtol+0xf0>
  801518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	3c 39                	cmp    $0x39,%al
  801521:	7f 12                	jg     801535 <strtol+0xf0>
			dig = *s - '0';
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	0f be c0             	movsbl %al,%eax
  80152d:	83 e8 30             	sub    $0x30,%eax
  801530:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801533:	eb 4e                	jmp    801583 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801539:	0f b6 00             	movzbl (%rax),%eax
  80153c:	3c 60                	cmp    $0x60,%al
  80153e:	7e 1d                	jle    80155d <strtol+0x118>
  801540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	3c 7a                	cmp    $0x7a,%al
  801549:	7f 12                	jg     80155d <strtol+0x118>
			dig = *s - 'a' + 10;
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	0f be c0             	movsbl %al,%eax
  801555:	83 e8 57             	sub    $0x57,%eax
  801558:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80155b:	eb 26                	jmp    801583 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80155d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801561:	0f b6 00             	movzbl (%rax),%eax
  801564:	3c 40                	cmp    $0x40,%al
  801566:	7e 47                	jle    8015af <strtol+0x16a>
  801568:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156c:	0f b6 00             	movzbl (%rax),%eax
  80156f:	3c 5a                	cmp    $0x5a,%al
  801571:	7f 3c                	jg     8015af <strtol+0x16a>
			dig = *s - 'A' + 10;
  801573:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801577:	0f b6 00             	movzbl (%rax),%eax
  80157a:	0f be c0             	movsbl %al,%eax
  80157d:	83 e8 37             	sub    $0x37,%eax
  801580:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801583:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801586:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801589:	7d 23                	jge    8015ae <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80158b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801590:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801593:	48 98                	cltq   
  801595:	48 89 c2             	mov    %rax,%rdx
  801598:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80159d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015a0:	48 98                	cltq   
  8015a2:	48 01 d0             	add    %rdx,%rax
  8015a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015a9:	e9 5f ff ff ff       	jmpq   80150d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015af:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015b4:	74 0b                	je     8015c1 <strtol+0x17c>
		*endptr = (char *) s;
  8015b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015be:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015c5:	74 09                	je     8015d0 <strtol+0x18b>
  8015c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015cb:	48 f7 d8             	neg    %rax
  8015ce:	eb 04                	jmp    8015d4 <strtol+0x18f>
  8015d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015d4:	c9                   	leaveq 
  8015d5:	c3                   	retq   

00000000008015d6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015d6:	55                   	push   %rbp
  8015d7:	48 89 e5             	mov    %rsp,%rbp
  8015da:	48 83 ec 30          	sub    $0x30,%rsp
  8015de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8015e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ea:	0f b6 00             	movzbl (%rax),%eax
  8015ed:	88 45 ff             	mov    %al,-0x1(%rbp)
  8015f0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8015f5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015f9:	75 06                	jne    801601 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8015fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ff:	eb 68                	jmp    801669 <strstr+0x93>

    len = strlen(str);
  801601:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801605:	48 89 c7             	mov    %rax,%rdi
  801608:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  80160f:	00 00 00 
  801612:	ff d0                	callq  *%rax
  801614:	48 98                	cltq   
  801616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	88 45 ef             	mov    %al,-0x11(%rbp)
  801624:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801629:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80162d:	75 07                	jne    801636 <strstr+0x60>
                return (char *) 0;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
  801634:	eb 33                	jmp    801669 <strstr+0x93>
        } while (sc != c);
  801636:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80163a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80163d:	75 db                	jne    80161a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80163f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801643:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	48 89 ce             	mov    %rcx,%rsi
  80164e:	48 89 c7             	mov    %rax,%rdi
  801651:	48 b8 c8 10 80 00 00 	movabs $0x8010c8,%rax
  801658:	00 00 00 
  80165b:	ff d0                	callq  *%rax
  80165d:	85 c0                	test   %eax,%eax
  80165f:	75 b9                	jne    80161a <strstr+0x44>

    return (char *) (in - 1);
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	48 83 e8 01          	sub    $0x1,%rax
}
  801669:	c9                   	leaveq 
  80166a:	c3                   	retq   
	...

000000000080166c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80166c:	55                   	push   %rbp
  80166d:	48 89 e5             	mov    %rsp,%rbp
  801670:	53                   	push   %rbx
  801671:	48 83 ec 58          	sub    $0x58,%rsp
  801675:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801678:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80167b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80167f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801683:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801687:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80168e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801691:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801695:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801699:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80169d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016a1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016a5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8016a8:	4c 89 c3             	mov    %r8,%rbx
  8016ab:	cd 30                	int    $0x30
  8016ad:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8016b1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8016b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016bd:	74 3e                	je     8016fd <syscall+0x91>
  8016bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016c4:	7e 37                	jle    8016fd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016cd:	49 89 d0             	mov    %rdx,%r8
  8016d0:	89 c1                	mov    %eax,%ecx
  8016d2:	48 ba c0 49 80 00 00 	movabs $0x8049c0,%rdx
  8016d9:	00 00 00 
  8016dc:	be 23 00 00 00       	mov    $0x23,%esi
  8016e1:	48 bf dd 49 80 00 00 	movabs $0x8049dd,%rdi
  8016e8:	00 00 00 
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	49 b9 e4 3f 80 00 00 	movabs $0x803fe4,%r9
  8016f7:	00 00 00 
  8016fa:	41 ff d1             	callq  *%r9

	return ret;
  8016fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801701:	48 83 c4 58          	add    $0x58,%rsp
  801705:	5b                   	pop    %rbx
  801706:	5d                   	pop    %rbp
  801707:	c3                   	retq   

0000000000801708 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801708:	55                   	push   %rbp
  801709:	48 89 e5             	mov    %rsp,%rbp
  80170c:	48 83 ec 20          	sub    $0x20,%rsp
  801710:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801714:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80171c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801720:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801727:	00 
  801728:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80172e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801734:	48 89 d1             	mov    %rdx,%rcx
  801737:	48 89 c2             	mov    %rax,%rdx
  80173a:	be 00 00 00 00       	mov    $0x0,%esi
  80173f:	bf 00 00 00 00       	mov    $0x0,%edi
  801744:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
}
  801750:	c9                   	leaveq 
  801751:	c3                   	retq   

0000000000801752 <sys_cgetc>:

int
sys_cgetc(void)
{
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80175a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801761:	00 
  801762:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801768:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80176e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	be 00 00 00 00       	mov    $0x0,%esi
  80177d:	bf 01 00 00 00       	mov    $0x1,%edi
  801782:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801789:	00 00 00 
  80178c:	ff d0                	callq  *%rax
}
  80178e:	c9                   	leaveq 
  80178f:	c3                   	retq   

0000000000801790 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	48 83 ec 20          	sub    $0x20,%rsp
  801798:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80179b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80179e:	48 98                	cltq   
  8017a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017a7:	00 
  8017a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b9:	48 89 c2             	mov    %rax,%rdx
  8017bc:	be 01 00 00 00       	mov    $0x1,%esi
  8017c1:	bf 03 00 00 00       	mov    $0x3,%edi
  8017c6:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  8017cd:	00 00 00 
  8017d0:	ff d0                	callq  *%rax
}
  8017d2:	c9                   	leaveq 
  8017d3:	c3                   	retq   

00000000008017d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017d4:	55                   	push   %rbp
  8017d5:	48 89 e5             	mov    %rsp,%rbp
  8017d8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017e3:	00 
  8017e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fa:	be 00 00 00 00       	mov    $0x0,%esi
  8017ff:	bf 02 00 00 00       	mov    $0x2,%edi
  801804:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  80180b:	00 00 00 
  80180e:	ff d0                	callq  *%rax
}
  801810:	c9                   	leaveq 
  801811:	c3                   	retq   

0000000000801812 <sys_yield>:

void
sys_yield(void)
{
  801812:	55                   	push   %rbp
  801813:	48 89 e5             	mov    %rsp,%rbp
  801816:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80181a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801821:	00 
  801822:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801828:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80182e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	be 00 00 00 00       	mov    $0x0,%esi
  80183d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801842:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801849:	00 00 00 
  80184c:	ff d0                	callq  *%rax
}
  80184e:	c9                   	leaveq 
  80184f:	c3                   	retq   

0000000000801850 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
  801854:	48 83 ec 20          	sub    $0x20,%rsp
  801858:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801862:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801865:	48 63 c8             	movslq %eax,%rcx
  801868:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80186c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801878:	00 
  801879:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187f:	49 89 c8             	mov    %rcx,%r8
  801882:	48 89 d1             	mov    %rdx,%rcx
  801885:	48 89 c2             	mov    %rax,%rdx
  801888:	be 01 00 00 00       	mov    $0x1,%esi
  80188d:	bf 04 00 00 00       	mov    $0x4,%edi
  801892:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801899:	00 00 00 
  80189c:	ff d0                	callq  *%rax
}
  80189e:	c9                   	leaveq 
  80189f:	c3                   	retq   

00000000008018a0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018a0:	55                   	push   %rbp
  8018a1:	48 89 e5             	mov    %rsp,%rbp
  8018a4:	48 83 ec 30          	sub    $0x30,%rsp
  8018a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018af:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018b2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018b6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018bd:	48 63 c8             	movslq %eax,%rcx
  8018c0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c7:	48 63 f0             	movslq %eax,%rsi
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d1:	48 98                	cltq   
  8018d3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018d7:	49 89 f9             	mov    %rdi,%r9
  8018da:	49 89 f0             	mov    %rsi,%r8
  8018dd:	48 89 d1             	mov    %rdx,%rcx
  8018e0:	48 89 c2             	mov    %rax,%rdx
  8018e3:	be 01 00 00 00       	mov    $0x1,%esi
  8018e8:	bf 05 00 00 00       	mov    $0x5,%edi
  8018ed:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  8018f4:	00 00 00 
  8018f7:	ff d0                	callq  *%rax
}
  8018f9:	c9                   	leaveq 
  8018fa:	c3                   	retq   

00000000008018fb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018fb:	55                   	push   %rbp
  8018fc:	48 89 e5             	mov    %rsp,%rbp
  8018ff:	48 83 ec 20          	sub    $0x20,%rsp
  801903:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801906:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80190a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801911:	48 98                	cltq   
  801913:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80191a:	00 
  80191b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801921:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801927:	48 89 d1             	mov    %rdx,%rcx
  80192a:	48 89 c2             	mov    %rax,%rdx
  80192d:	be 01 00 00 00       	mov    $0x1,%esi
  801932:	bf 06 00 00 00       	mov    $0x6,%edi
  801937:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  80193e:	00 00 00 
  801941:	ff d0                	callq  *%rax
}
  801943:	c9                   	leaveq 
  801944:	c3                   	retq   

0000000000801945 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801945:	55                   	push   %rbp
  801946:	48 89 e5             	mov    %rsp,%rbp
  801949:	48 83 ec 20          	sub    $0x20,%rsp
  80194d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801950:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801953:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801956:	48 63 d0             	movslq %eax,%rdx
  801959:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195c:	48 98                	cltq   
  80195e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801965:	00 
  801966:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801972:	48 89 d1             	mov    %rdx,%rcx
  801975:	48 89 c2             	mov    %rax,%rdx
  801978:	be 01 00 00 00       	mov    $0x1,%esi
  80197d:	bf 08 00 00 00       	mov    $0x8,%edi
  801982:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801989:	00 00 00 
  80198c:	ff d0                	callq  *%rax
}
  80198e:	c9                   	leaveq 
  80198f:	c3                   	retq   

0000000000801990 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801990:	55                   	push   %rbp
  801991:	48 89 e5             	mov    %rsp,%rbp
  801994:	48 83 ec 20          	sub    $0x20,%rsp
  801998:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80199b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80199f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a6:	48 98                	cltq   
  8019a8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019af:	00 
  8019b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019bc:	48 89 d1             	mov    %rdx,%rcx
  8019bf:	48 89 c2             	mov    %rax,%rdx
  8019c2:	be 01 00 00 00       	mov    $0x1,%esi
  8019c7:	bf 09 00 00 00       	mov    $0x9,%edi
  8019cc:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  8019d3:	00 00 00 
  8019d6:	ff d0                	callq  *%rax
}
  8019d8:	c9                   	leaveq 
  8019d9:	c3                   	retq   

00000000008019da <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	48 83 ec 20          	sub    $0x20,%rsp
  8019e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019f0:	48 98                	cltq   
  8019f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f9:	00 
  8019fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a06:	48 89 d1             	mov    %rdx,%rcx
  801a09:	48 89 c2             	mov    %rax,%rdx
  801a0c:	be 01 00 00 00       	mov    $0x1,%esi
  801a11:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a16:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801a1d:	00 00 00 
  801a20:	ff d0                	callq  *%rax
}
  801a22:	c9                   	leaveq 
  801a23:	c3                   	retq   

0000000000801a24 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a24:	55                   	push   %rbp
  801a25:	48 89 e5             	mov    %rsp,%rbp
  801a28:	48 83 ec 30          	sub    $0x30,%rsp
  801a2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a37:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3d:	48 63 f0             	movslq %eax,%rsi
  801a40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a47:	48 98                	cltq   
  801a49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a54:	00 
  801a55:	49 89 f1             	mov    %rsi,%r9
  801a58:	49 89 c8             	mov    %rcx,%r8
  801a5b:	48 89 d1             	mov    %rdx,%rcx
  801a5e:	48 89 c2             	mov    %rax,%rdx
  801a61:	be 00 00 00 00       	mov    $0x0,%esi
  801a66:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a6b:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	callq  *%rax
}
  801a77:	c9                   	leaveq 
  801a78:	c3                   	retq   

0000000000801a79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a79:	55                   	push   %rbp
  801a7a:	48 89 e5             	mov    %rsp,%rbp
  801a7d:	48 83 ec 20          	sub    $0x20,%rsp
  801a81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a90:	00 
  801a91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa2:	48 89 c2             	mov    %rax,%rdx
  801aa5:	be 01 00 00 00       	mov    $0x1,%esi
  801aaa:	bf 0d 00 00 00       	mov    $0xd,%edi
  801aaf:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801ab6:	00 00 00 
  801ab9:	ff d0                	callq  *%rax
}
  801abb:	c9                   	leaveq 
  801abc:	c3                   	retq   

0000000000801abd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801abd:	55                   	push   %rbp
  801abe:	48 89 e5             	mov    %rsp,%rbp
  801ac1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801ac5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acc:	00 
  801acd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ade:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae3:	be 00 00 00 00       	mov    $0x0,%esi
  801ae8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801aed:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801af4:	00 00 00 
  801af7:	ff d0                	callq  *%rax
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 20          	sub    $0x20,%rsp
  801b03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b1a:	00 
  801b1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b27:	48 89 d1             	mov    %rdx,%rcx
  801b2a:	48 89 c2             	mov    %rax,%rdx
  801b2d:	be 00 00 00 00       	mov    $0x0,%esi
  801b32:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b37:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801b3e:	00 00 00 
  801b41:	ff d0                	callq  *%rax
}
  801b43:	c9                   	leaveq 
  801b44:	c3                   	retq   

0000000000801b45 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801b45:	55                   	push   %rbp
  801b46:	48 89 e5             	mov    %rsp,%rbp
  801b49:	48 83 ec 20          	sub    $0x20,%rsp
  801b4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b64:	00 
  801b65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b71:	48 89 d1             	mov    %rdx,%rcx
  801b74:	48 89 c2             	mov    %rax,%rdx
  801b77:	be 00 00 00 00       	mov    $0x0,%esi
  801b7c:	bf 10 00 00 00       	mov    $0x10,%edi
  801b81:	48 b8 6c 16 80 00 00 	movabs $0x80166c,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax
}
  801b8d:	c9                   	leaveq 
  801b8e:	c3                   	retq   
	...

0000000000801b90 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 30          	sub    $0x30,%rsp
  801b98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801b9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba0:	48 8b 00             	mov    (%rax),%rax
  801ba3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ba7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bab:	48 8b 40 08          	mov    0x8(%rax),%rax
  801baf:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801bb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb5:	83 e0 02             	and    $0x2,%eax
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	74 23                	je     801bdf <pgfault+0x4f>
  801bbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bc0:	48 89 c2             	mov    %rax,%rdx
  801bc3:	48 c1 ea 0c          	shr    $0xc,%rdx
  801bc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bce:	01 00 00 
  801bd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd5:	25 00 08 00 00       	and    $0x800,%eax
  801bda:	48 85 c0             	test   %rax,%rax
  801bdd:	75 2a                	jne    801c09 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801bdf:	48 ba f0 49 80 00 00 	movabs $0x8049f0,%rdx
  801be6:	00 00 00 
  801be9:	be 1c 00 00 00       	mov    $0x1c,%esi
  801bee:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801bf5:	00 00 00 
  801bf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfd:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  801c04:	00 00 00 
  801c07:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801c09:	ba 07 00 00 00       	mov    $0x7,%edx
  801c0e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c13:	bf 00 00 00 00       	mov    $0x0,%edi
  801c18:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  801c1f:	00 00 00 
  801c22:	ff d0                	callq  *%rax
  801c24:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c2b:	79 30                	jns    801c5d <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801c2d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c30:	89 c1                	mov    %eax,%ecx
  801c32:	48 ba 30 4a 80 00 00 	movabs $0x804a30,%rdx
  801c39:	00 00 00 
  801c3c:	be 26 00 00 00       	mov    $0x26,%esi
  801c41:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801c48:	00 00 00 
  801c4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c50:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  801c57:	00 00 00 
  801c5a:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801c65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c69:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c6f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c74:	48 89 c6             	mov    %rax,%rsi
  801c77:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801c7c:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  801c83:	00 00 00 
  801c86:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801c88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801c90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c94:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c9a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ca0:	48 89 c1             	mov    %rax,%rcx
  801ca3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cad:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb2:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801cb9:	00 00 00 
  801cbc:	ff d0                	callq  *%rax
  801cbe:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801cc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801cc5:	79 30                	jns    801cf7 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801cc7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801cca:	89 c1                	mov    %eax,%ecx
  801ccc:	48 ba 58 4a 80 00 00 	movabs $0x804a58,%rdx
  801cd3:	00 00 00 
  801cd6:	be 2b 00 00 00       	mov    $0x2b,%esi
  801cdb:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801ce2:	00 00 00 
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  801cf1:	00 00 00 
  801cf4:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801cf7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801d01:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
  801d0d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d10:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d14:	79 30                	jns    801d46 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801d16:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d19:	89 c1                	mov    %eax,%ecx
  801d1b:	48 ba 80 4a 80 00 00 	movabs $0x804a80,%rdx
  801d22:	00 00 00 
  801d25:	be 2e 00 00 00       	mov    $0x2e,%esi
  801d2a:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801d31:	00 00 00 
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  801d40:	00 00 00 
  801d43:	41 ff d0             	callq  *%r8
	
}
  801d46:	c9                   	leaveq 
  801d47:	c3                   	retq   

0000000000801d48 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	48 83 ec 30          	sub    $0x30,%rsp
  801d50:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801d53:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801d56:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5d:	01 00 00 
  801d60:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801d63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6f:	25 07 0e 00 00       	and    $0xe07,%eax
  801d74:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801d77:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801d7a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801d82:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d85:	25 00 04 00 00       	and    $0x400,%eax
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	74 5c                	je     801dea <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801d8e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801d91:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d95:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9c:	41 89 f0             	mov    %esi,%r8d
  801d9f:	48 89 c6             	mov    %rax,%rsi
  801da2:	bf 00 00 00 00       	mov    $0x0,%edi
  801da7:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801dae:	00 00 00 
  801db1:	ff d0                	callq  *%rax
  801db3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801db6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801dba:	0f 89 60 01 00 00    	jns    801f20 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801dc0:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  801dc7:	00 00 00 
  801dca:	be 4d 00 00 00       	mov    $0x4d,%esi
  801dcf:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801dd6:	00 00 00 
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dde:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  801de5:	00 00 00 
  801de8:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801dea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ded:	83 e0 02             	and    $0x2,%eax
  801df0:	85 c0                	test   %eax,%eax
  801df2:	75 10                	jne    801e04 <duppage+0xbc>
  801df4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801df7:	25 00 08 00 00       	and    $0x800,%eax
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	0f 84 c4 00 00 00    	je     801ec8 <duppage+0x180>
	{
		perm |= PTE_COW;
  801e04:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801e0b:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801e0f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801e12:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e16:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1d:	41 89 f0             	mov    %esi,%r8d
  801e20:	48 89 c6             	mov    %rax,%rsi
  801e23:	bf 00 00 00 00       	mov    $0x0,%edi
  801e28:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801e2f:	00 00 00 
  801e32:	ff d0                	callq  *%rax
  801e34:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801e37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e3b:	79 2a                	jns    801e67 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801e3d:	48 ba d8 4a 80 00 00 	movabs $0x804ad8,%rdx
  801e44:	00 00 00 
  801e47:	be 56 00 00 00       	mov    $0x56,%esi
  801e4c:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801e53:	00 00 00 
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5b:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  801e62:	00 00 00 
  801e65:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801e67:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801e6a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e72:	41 89 c8             	mov    %ecx,%r8d
  801e75:	48 89 d1             	mov    %rdx,%rcx
  801e78:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7d:	48 89 c6             	mov    %rax,%rsi
  801e80:	bf 00 00 00 00       	mov    $0x0,%edi
  801e85:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801e8c:	00 00 00 
  801e8f:	ff d0                	callq  *%rax
  801e91:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801e94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e98:	0f 89 82 00 00 00    	jns    801f20 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  801e9e:	48 ba d8 4a 80 00 00 	movabs $0x804ad8,%rdx
  801ea5:	00 00 00 
  801ea8:	be 59 00 00 00       	mov    $0x59,%esi
  801ead:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801eb4:	00 00 00 
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  801ec3:	00 00 00 
  801ec6:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  801ec8:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801ecb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ecf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed6:	41 89 f0             	mov    %esi,%r8d
  801ed9:	48 89 c6             	mov    %rax,%rsi
  801edc:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee1:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  801ee8:	00 00 00 
  801eeb:	ff d0                	callq  *%rax
  801eed:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ef4:	79 2a                	jns    801f20 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  801ef6:	48 ba 10 4b 80 00 00 	movabs $0x804b10,%rdx
  801efd:	00 00 00 
  801f00:	be 60 00 00 00       	mov    $0x60,%esi
  801f05:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801f0c:	00 00 00 
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  801f1b:	00 00 00 
  801f1e:	ff d1                	callq  *%rcx
	}
	return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f25:	c9                   	leaveq 
  801f26:	c3                   	retq   

0000000000801f27 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
  801f2b:	53                   	push   %rbx
  801f2c:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801f30:	48 bf 90 1b 80 00 00 	movabs $0x801b90,%rdi
  801f37:	00 00 00 
  801f3a:	48 b8 f8 40 80 00 00 	movabs $0x8040f8,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f46:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  801f4d:	8b 45 bc             	mov    -0x44(%rbp),%eax
  801f50:	cd 30                	int    $0x30
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f57:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  801f5a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  801f5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f61:	79 30                	jns    801f93 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  801f63:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801f66:	89 c1                	mov    %eax,%ecx
  801f68:	48 ba 34 4b 80 00 00 	movabs $0x804b34,%rdx
  801f6f:	00 00 00 
  801f72:	be 7f 00 00 00       	mov    $0x7f,%esi
  801f77:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  801f7e:	00 00 00 
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  801f8d:	00 00 00 
  801f90:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  801f93:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801f97:	75 4c                	jne    801fe5 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  801f99:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  801fa0:	00 00 00 
  801fa3:	ff d0                	callq  *%rax
  801fa5:	48 98                	cltq   
  801fa7:	48 89 c2             	mov    %rax,%rdx
  801faa:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801fb0:	48 89 d0             	mov    %rdx,%rax
  801fb3:	48 c1 e0 03          	shl    $0x3,%rax
  801fb7:	48 01 d0             	add    %rdx,%rax
  801fba:	48 c1 e0 05          	shl    $0x5,%rax
  801fbe:	48 89 c2             	mov    %rax,%rdx
  801fc1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801fc8:	00 00 00 
  801fcb:	48 01 c2             	add    %rax,%rdx
  801fce:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  801fd5:	00 00 00 
  801fd8:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	e9 38 02 00 00       	jmpq   80221d <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  801fe5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801fe8:	ba 07 00 00 00       	mov    $0x7,%edx
  801fed:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801ff2:	89 c7                	mov    %eax,%edi
  801ff4:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  801ffb:	00 00 00 
  801ffe:	ff d0                	callq  *%rax
  802000:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802003:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802007:	79 30                	jns    802039 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802009:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80200c:	89 c1                	mov    %eax,%ecx
  80200e:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  802015:	00 00 00 
  802018:	be 8b 00 00 00       	mov    $0x8b,%esi
  80201d:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  802024:	00 00 00 
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  802033:	00 00 00 
  802036:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802039:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802040:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802047:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80204e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802055:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80205c:	e9 0a 01 00 00       	jmpq   80216b <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802061:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802068:	01 00 00 
  80206b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80206e:	48 63 d2             	movslq %edx,%rdx
  802071:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802075:	83 e0 01             	and    $0x1,%eax
  802078:	84 c0                	test   %al,%al
  80207a:	0f 84 e7 00 00 00    	je     802167 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802080:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802087:	e9 cf 00 00 00       	jmpq   80215b <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80208c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802093:	01 00 00 
  802096:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802099:	48 63 d2             	movslq %edx,%rdx
  80209c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a0:	83 e0 01             	and    $0x1,%eax
  8020a3:	84 c0                	test   %al,%al
  8020a5:	0f 84 a0 00 00 00    	je     80214b <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8020ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  8020b2:	e9 85 00 00 00       	jmpq   80213c <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  8020b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020be:	01 00 00 
  8020c1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020c4:	48 63 d2             	movslq %edx,%rdx
  8020c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cb:	83 e0 01             	and    $0x1,%eax
  8020ce:	84 c0                	test   %al,%al
  8020d0:	74 56                	je     802128 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8020d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8020d9:	eb 42                	jmp    80211d <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8020db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020e2:	01 00 00 
  8020e5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020e8:	48 63 d2             	movslq %edx,%rdx
  8020eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ef:	83 e0 01             	and    $0x1,%eax
  8020f2:	84 c0                	test   %al,%al
  8020f4:	74 1f                	je     802115 <fork+0x1ee>
  8020f6:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8020fd:	74 16                	je     802115 <fork+0x1ee>
									 duppage(envid,d1);
  8020ff:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802102:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802105:	89 d6                	mov    %edx,%esi
  802107:	89 c7                	mov    %eax,%edi
  802109:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  802110:	00 00 00 
  802113:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802115:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802119:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  80211d:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802124:	7e b5                	jle    8020db <fork+0x1b4>
  802126:	eb 0c                	jmp    802134 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802128:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80212b:	83 c0 01             	add    $0x1,%eax
  80212e:	c1 e0 09             	shl    $0x9,%eax
  802131:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802134:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802138:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  80213c:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802143:	0f 8e 6e ff ff ff    	jle    8020b7 <fork+0x190>
  802149:	eb 0c                	jmp    802157 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80214b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80214e:	83 c0 01             	add    $0x1,%eax
  802151:	c1 e0 09             	shl    $0x9,%eax
  802154:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802157:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80215b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80215e:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802161:	0f 8c 25 ff ff ff    	jl     80208c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802167:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80216b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802171:	0f 8c ea fe ff ff    	jl     802061 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802177:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80217a:	48 be bc 41 80 00 00 	movabs $0x8041bc,%rsi
  802181:	00 00 00 
  802184:	89 c7                	mov    %eax,%edi
  802186:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  80218d:	00 00 00 
  802190:	ff d0                	callq  *%rax
  802192:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802195:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802199:	79 30                	jns    8021cb <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80219b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80219e:	89 c1                	mov    %eax,%ecx
  8021a0:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  8021a7:	00 00 00 
  8021aa:	be ad 00 00 00       	mov    $0xad,%esi
  8021af:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  8021b6:	00 00 00 
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  8021c5:	00 00 00 
  8021c8:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8021cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8021ce:	be 02 00 00 00       	mov    $0x2,%esi
  8021d3:	89 c7                	mov    %eax,%edi
  8021d5:	48 b8 45 19 80 00 00 	movabs $0x801945,%rax
  8021dc:	00 00 00 
  8021df:	ff d0                	callq  *%rax
  8021e1:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8021e4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8021e8:	79 30                	jns    80221a <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8021ea:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8021ed:	89 c1                	mov    %eax,%ecx
  8021ef:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  8021f6:	00 00 00 
  8021f9:	be b0 00 00 00       	mov    $0xb0,%esi
  8021fe:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  802205:	00 00 00 
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
  80220d:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  802214:	00 00 00 
  802217:	41 ff d0             	callq  *%r8
	return envid;
  80221a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  80221d:	48 83 c4 48          	add    $0x48,%rsp
  802221:	5b                   	pop    %rbx
  802222:	5d                   	pop    %rbp
  802223:	c3                   	retq   

0000000000802224 <sfork>:

// Challenge!
int
sfork(void)
{
  802224:	55                   	push   %rbp
  802225:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802228:	48 ba bc 4b 80 00 00 	movabs $0x804bbc,%rdx
  80222f:	00 00 00 
  802232:	be b8 00 00 00       	mov    $0xb8,%esi
  802237:	48 bf 25 4a 80 00 00 	movabs $0x804a25,%rdi
  80223e:	00 00 00 
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
  802246:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  80224d:	00 00 00 
  802250:	ff d1                	callq  *%rcx
	...

0000000000802254 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802254:	55                   	push   %rbp
  802255:	48 89 e5             	mov    %rsp,%rbp
  802258:	48 83 ec 08          	sub    $0x8,%rsp
  80225c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802260:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802264:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80226b:	ff ff ff 
  80226e:	48 01 d0             	add    %rdx,%rax
  802271:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802275:	c9                   	leaveq 
  802276:	c3                   	retq   

0000000000802277 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802277:	55                   	push   %rbp
  802278:	48 89 e5             	mov    %rsp,%rbp
  80227b:	48 83 ec 08          	sub    $0x8,%rsp
  80227f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802287:	48 89 c7             	mov    %rax,%rdi
  80228a:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  802291:	00 00 00 
  802294:	ff d0                	callq  *%rax
  802296:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80229c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8022a0:	c9                   	leaveq 
  8022a1:	c3                   	retq   

00000000008022a2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8022a2:	55                   	push   %rbp
  8022a3:	48 89 e5             	mov    %rsp,%rbp
  8022a6:	48 83 ec 18          	sub    $0x18,%rsp
  8022aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b5:	eb 6b                	jmp    802322 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8022b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ba:	48 98                	cltq   
  8022bc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022c2:	48 c1 e0 0c          	shl    $0xc,%rax
  8022c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ce:	48 89 c2             	mov    %rax,%rdx
  8022d1:	48 c1 ea 15          	shr    $0x15,%rdx
  8022d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022dc:	01 00 00 
  8022df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e3:	83 e0 01             	and    $0x1,%eax
  8022e6:	48 85 c0             	test   %rax,%rax
  8022e9:	74 21                	je     80230c <fd_alloc+0x6a>
  8022eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ef:	48 89 c2             	mov    %rax,%rdx
  8022f2:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022fd:	01 00 00 
  802300:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802304:	83 e0 01             	and    $0x1,%eax
  802307:	48 85 c0             	test   %rax,%rax
  80230a:	75 12                	jne    80231e <fd_alloc+0x7c>
			*fd_store = fd;
  80230c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802310:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802314:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802317:	b8 00 00 00 00       	mov    $0x0,%eax
  80231c:	eb 1a                	jmp    802338 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80231e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802322:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802326:	7e 8f                	jle    8022b7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802333:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802338:	c9                   	leaveq 
  802339:	c3                   	retq   

000000000080233a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80233a:	55                   	push   %rbp
  80233b:	48 89 e5             	mov    %rsp,%rbp
  80233e:	48 83 ec 20          	sub    $0x20,%rsp
  802342:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802345:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802349:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80234d:	78 06                	js     802355 <fd_lookup+0x1b>
  80234f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802353:	7e 07                	jle    80235c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80235a:	eb 6c                	jmp    8023c8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80235c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80235f:	48 98                	cltq   
  802361:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802367:	48 c1 e0 0c          	shl    $0xc,%rax
  80236b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80236f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802373:	48 89 c2             	mov    %rax,%rdx
  802376:	48 c1 ea 15          	shr    $0x15,%rdx
  80237a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802381:	01 00 00 
  802384:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802388:	83 e0 01             	and    $0x1,%eax
  80238b:	48 85 c0             	test   %rax,%rax
  80238e:	74 21                	je     8023b1 <fd_lookup+0x77>
  802390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802394:	48 89 c2             	mov    %rax,%rdx
  802397:	48 c1 ea 0c          	shr    $0xc,%rdx
  80239b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023a2:	01 00 00 
  8023a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a9:	83 e0 01             	and    $0x1,%eax
  8023ac:	48 85 c0             	test   %rax,%rax
  8023af:	75 07                	jne    8023b8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8023b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b6:	eb 10                	jmp    8023c8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8023b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023c0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c8:	c9                   	leaveq 
  8023c9:	c3                   	retq   

00000000008023ca <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023ca:	55                   	push   %rbp
  8023cb:	48 89 e5             	mov    %rsp,%rbp
  8023ce:	48 83 ec 30          	sub    $0x30,%rsp
  8023d2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023d6:	89 f0                	mov    %esi,%eax
  8023d8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023df:	48 89 c7             	mov    %rax,%rdi
  8023e2:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  8023e9:	00 00 00 
  8023ec:	ff d0                	callq  *%rax
  8023ee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023f2:	48 89 d6             	mov    %rdx,%rsi
  8023f5:	89 c7                	mov    %eax,%edi
  8023f7:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8023fe:	00 00 00 
  802401:	ff d0                	callq  *%rax
  802403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80240a:	78 0a                	js     802416 <fd_close+0x4c>
	    || fd != fd2)
  80240c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802410:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802414:	74 12                	je     802428 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802416:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80241a:	74 05                	je     802421 <fd_close+0x57>
  80241c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241f:	eb 05                	jmp    802426 <fd_close+0x5c>
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
  802426:	eb 69                	jmp    802491 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80242c:	8b 00                	mov    (%rax),%eax
  80242e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802432:	48 89 d6             	mov    %rdx,%rsi
  802435:	89 c7                	mov    %eax,%edi
  802437:	48 b8 93 24 80 00 00 	movabs $0x802493,%rax
  80243e:	00 00 00 
  802441:	ff d0                	callq  *%rax
  802443:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802446:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244a:	78 2a                	js     802476 <fd_close+0xac>
		if (dev->dev_close)
  80244c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802450:	48 8b 40 20          	mov    0x20(%rax),%rax
  802454:	48 85 c0             	test   %rax,%rax
  802457:	74 16                	je     80246f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802465:	48 89 c7             	mov    %rax,%rdi
  802468:	ff d2                	callq  *%rdx
  80246a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246d:	eb 07                	jmp    802476 <fd_close+0xac>
		else
			r = 0;
  80246f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802476:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247a:	48 89 c6             	mov    %rax,%rsi
  80247d:	bf 00 00 00 00       	mov    $0x0,%edi
  802482:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  802489:	00 00 00 
  80248c:	ff d0                	callq  *%rax
	return r;
  80248e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802491:	c9                   	leaveq 
  802492:	c3                   	retq   

0000000000802493 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802493:	55                   	push   %rbp
  802494:	48 89 e5             	mov    %rsp,%rbp
  802497:	48 83 ec 20          	sub    $0x20,%rsp
  80249b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8024a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024a9:	eb 41                	jmp    8024ec <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8024ab:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024b2:	00 00 00 
  8024b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024b8:	48 63 d2             	movslq %edx,%rdx
  8024bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bf:	8b 00                	mov    (%rax),%eax
  8024c1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024c4:	75 22                	jne    8024e8 <dev_lookup+0x55>
			*dev = devtab[i];
  8024c6:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024cd:	00 00 00 
  8024d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024d3:	48 63 d2             	movslq %edx,%rdx
  8024d6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024de:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	eb 60                	jmp    802548 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024e8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024ec:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8024f3:	00 00 00 
  8024f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024f9:	48 63 d2             	movslq %edx,%rdx
  8024fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802500:	48 85 c0             	test   %rax,%rax
  802503:	75 a6                	jne    8024ab <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802505:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80250c:	00 00 00 
  80250f:	48 8b 00             	mov    (%rax),%rax
  802512:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802518:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80251b:	89 c6                	mov    %eax,%esi
  80251d:	48 bf d8 4b 80 00 00 	movabs $0x804bd8,%rdi
  802524:	00 00 00 
  802527:	b8 00 00 00 00       	mov    $0x0,%eax
  80252c:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  802533:	00 00 00 
  802536:	ff d1                	callq  *%rcx
	*dev = 0;
  802538:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80253c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802543:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802548:	c9                   	leaveq 
  802549:	c3                   	retq   

000000000080254a <close>:

int
close(int fdnum)
{
  80254a:	55                   	push   %rbp
  80254b:	48 89 e5             	mov    %rsp,%rbp
  80254e:	48 83 ec 20          	sub    $0x20,%rsp
  802552:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802555:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802559:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80255c:	48 89 d6             	mov    %rdx,%rsi
  80255f:	89 c7                	mov    %eax,%edi
  802561:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  802568:	00 00 00 
  80256b:	ff d0                	callq  *%rax
  80256d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802574:	79 05                	jns    80257b <close+0x31>
		return r;
  802576:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802579:	eb 18                	jmp    802593 <close+0x49>
	else
		return fd_close(fd, 1);
  80257b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257f:	be 01 00 00 00       	mov    $0x1,%esi
  802584:	48 89 c7             	mov    %rax,%rdi
  802587:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax
}
  802593:	c9                   	leaveq 
  802594:	c3                   	retq   

0000000000802595 <close_all>:

void
close_all(void)
{
  802595:	55                   	push   %rbp
  802596:	48 89 e5             	mov    %rsp,%rbp
  802599:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80259d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025a4:	eb 15                	jmp    8025bb <close_all+0x26>
		close(i);
  8025a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a9:	89 c7                	mov    %eax,%edi
  8025ab:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  8025b2:	00 00 00 
  8025b5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8025b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025bb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025bf:	7e e5                	jle    8025a6 <close_all+0x11>
		close(i);
}
  8025c1:	c9                   	leaveq 
  8025c2:	c3                   	retq   

00000000008025c3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8025c3:	55                   	push   %rbp
  8025c4:	48 89 e5             	mov    %rsp,%rbp
  8025c7:	48 83 ec 40          	sub    $0x40,%rsp
  8025cb:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025ce:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025d1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025d5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025d8:	48 89 d6             	mov    %rdx,%rsi
  8025db:	89 c7                	mov    %eax,%edi
  8025dd:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8025e4:	00 00 00 
  8025e7:	ff d0                	callq  *%rax
  8025e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f0:	79 08                	jns    8025fa <dup+0x37>
		return r;
  8025f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f5:	e9 70 01 00 00       	jmpq   80276a <dup+0x1a7>
	close(newfdnum);
  8025fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025fd:	89 c7                	mov    %eax,%edi
  8025ff:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  802606:	00 00 00 
  802609:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80260b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80260e:	48 98                	cltq   
  802610:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802616:	48 c1 e0 0c          	shl    $0xc,%rax
  80261a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80261e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802622:	48 89 c7             	mov    %rax,%rdi
  802625:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  80262c:	00 00 00 
  80262f:	ff d0                	callq  *%rax
  802631:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802639:	48 89 c7             	mov    %rax,%rdi
  80263c:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  802643:	00 00 00 
  802646:	ff d0                	callq  *%rax
  802648:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80264c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802650:	48 89 c2             	mov    %rax,%rdx
  802653:	48 c1 ea 15          	shr    $0x15,%rdx
  802657:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265e:	01 00 00 
  802661:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802665:	83 e0 01             	and    $0x1,%eax
  802668:	84 c0                	test   %al,%al
  80266a:	74 71                	je     8026dd <dup+0x11a>
  80266c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802670:	48 89 c2             	mov    %rax,%rdx
  802673:	48 c1 ea 0c          	shr    $0xc,%rdx
  802677:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267e:	01 00 00 
  802681:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802685:	83 e0 01             	and    $0x1,%eax
  802688:	84 c0                	test   %al,%al
  80268a:	74 51                	je     8026dd <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80268c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802690:	48 89 c2             	mov    %rax,%rdx
  802693:	48 c1 ea 0c          	shr    $0xc,%rdx
  802697:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80269e:	01 00 00 
  8026a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a5:	89 c1                	mov    %eax,%ecx
  8026a7:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8026ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b5:	41 89 c8             	mov    %ecx,%r8d
  8026b8:	48 89 d1             	mov    %rdx,%rcx
  8026bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c0:	48 89 c6             	mov    %rax,%rsi
  8026c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c8:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  8026cf:	00 00 00 
  8026d2:	ff d0                	callq  *%rax
  8026d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026db:	78 56                	js     802733 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e1:	48 89 c2             	mov    %rax,%rdx
  8026e4:	48 c1 ea 0c          	shr    $0xc,%rdx
  8026e8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ef:	01 00 00 
  8026f2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026f6:	89 c1                	mov    %eax,%ecx
  8026f8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8026fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802702:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802706:	41 89 c8             	mov    %ecx,%r8d
  802709:	48 89 d1             	mov    %rdx,%rcx
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
  802711:	48 89 c6             	mov    %rax,%rsi
  802714:	bf 00 00 00 00       	mov    $0x0,%edi
  802719:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272c:	78 08                	js     802736 <dup+0x173>
		goto err;

	return newfdnum;
  80272e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802731:	eb 37                	jmp    80276a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802733:	90                   	nop
  802734:	eb 01                	jmp    802737 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802736:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273b:	48 89 c6             	mov    %rax,%rsi
  80273e:	bf 00 00 00 00       	mov    $0x0,%edi
  802743:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80274f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802753:	48 89 c6             	mov    %rax,%rsi
  802756:	bf 00 00 00 00       	mov    $0x0,%edi
  80275b:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
	return r;
  802767:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80276a:	c9                   	leaveq 
  80276b:	c3                   	retq   

000000000080276c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80276c:	55                   	push   %rbp
  80276d:	48 89 e5             	mov    %rsp,%rbp
  802770:	48 83 ec 40          	sub    $0x40,%rsp
  802774:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802777:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80277b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80277f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802783:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802786:	48 89 d6             	mov    %rdx,%rsi
  802789:	89 c7                	mov    %eax,%edi
  80278b:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279e:	78 24                	js     8027c4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a4:	8b 00                	mov    (%rax),%eax
  8027a6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027aa:	48 89 d6             	mov    %rdx,%rsi
  8027ad:	89 c7                	mov    %eax,%edi
  8027af:	48 b8 93 24 80 00 00 	movabs $0x802493,%rax
  8027b6:	00 00 00 
  8027b9:	ff d0                	callq  *%rax
  8027bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027c2:	79 05                	jns    8027c9 <read+0x5d>
		return r;
  8027c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c7:	eb 7a                	jmp    802843 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027cd:	8b 40 08             	mov    0x8(%rax),%eax
  8027d0:	83 e0 03             	and    $0x3,%eax
  8027d3:	83 f8 01             	cmp    $0x1,%eax
  8027d6:	75 3a                	jne    802812 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027d8:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8027df:	00 00 00 
  8027e2:	48 8b 00             	mov    (%rax),%rax
  8027e5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ee:	89 c6                	mov    %eax,%esi
  8027f0:	48 bf f7 4b 80 00 00 	movabs $0x804bf7,%rdi
  8027f7:	00 00 00 
  8027fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ff:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  802806:	00 00 00 
  802809:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80280b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802810:	eb 31                	jmp    802843 <read+0xd7>
	}
	if (!dev->dev_read)
  802812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802816:	48 8b 40 10          	mov    0x10(%rax),%rax
  80281a:	48 85 c0             	test   %rax,%rax
  80281d:	75 07                	jne    802826 <read+0xba>
		return -E_NOT_SUPP;
  80281f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802824:	eb 1d                	jmp    802843 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802826:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80282a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80282e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802832:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802836:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80283a:	48 89 ce             	mov    %rcx,%rsi
  80283d:	48 89 c7             	mov    %rax,%rdi
  802840:	41 ff d0             	callq  *%r8
}
  802843:	c9                   	leaveq 
  802844:	c3                   	retq   

0000000000802845 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802845:	55                   	push   %rbp
  802846:	48 89 e5             	mov    %rsp,%rbp
  802849:	48 83 ec 30          	sub    $0x30,%rsp
  80284d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802850:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802854:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80285f:	eb 46                	jmp    8028a7 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802861:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802864:	48 98                	cltq   
  802866:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80286a:	48 29 c2             	sub    %rax,%rdx
  80286d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802870:	48 98                	cltq   
  802872:	48 89 c1             	mov    %rax,%rcx
  802875:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802879:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80287c:	48 89 ce             	mov    %rcx,%rsi
  80287f:	89 c7                	mov    %eax,%edi
  802881:	48 b8 6c 27 80 00 00 	movabs $0x80276c,%rax
  802888:	00 00 00 
  80288b:	ff d0                	callq  *%rax
  80288d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802890:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802894:	79 05                	jns    80289b <readn+0x56>
			return m;
  802896:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802899:	eb 1d                	jmp    8028b8 <readn+0x73>
		if (m == 0)
  80289b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80289f:	74 13                	je     8028b4 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8028a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028a4:	01 45 fc             	add    %eax,-0x4(%rbp)
  8028a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028aa:	48 98                	cltq   
  8028ac:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8028b0:	72 af                	jb     802861 <readn+0x1c>
  8028b2:	eb 01                	jmp    8028b5 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8028b4:	90                   	nop
	}
	return tot;
  8028b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b8:	c9                   	leaveq 
  8028b9:	c3                   	retq   

00000000008028ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	48 83 ec 40          	sub    $0x40,%rsp
  8028c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028d4:	48 89 d6             	mov    %rdx,%rsi
  8028d7:	89 c7                	mov    %eax,%edi
  8028d9:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
  8028e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ec:	78 24                	js     802912 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f2:	8b 00                	mov    (%rax),%eax
  8028f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f8:	48 89 d6             	mov    %rdx,%rsi
  8028fb:	89 c7                	mov    %eax,%edi
  8028fd:	48 b8 93 24 80 00 00 	movabs $0x802493,%rax
  802904:	00 00 00 
  802907:	ff d0                	callq  *%rax
  802909:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802910:	79 05                	jns    802917 <write+0x5d>
		return r;
  802912:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802915:	eb 79                	jmp    802990 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	8b 40 08             	mov    0x8(%rax),%eax
  80291e:	83 e0 03             	and    $0x3,%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	75 3a                	jne    80295f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802925:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80292c:	00 00 00 
  80292f:	48 8b 00             	mov    (%rax),%rax
  802932:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802938:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80293b:	89 c6                	mov    %eax,%esi
  80293d:	48 bf 13 4c 80 00 00 	movabs $0x804c13,%rdi
  802944:	00 00 00 
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
  80294c:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  802953:	00 00 00 
  802956:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80295d:	eb 31                	jmp    802990 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80295f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802963:	48 8b 40 18          	mov    0x18(%rax),%rax
  802967:	48 85 c0             	test   %rax,%rax
  80296a:	75 07                	jne    802973 <write+0xb9>
		return -E_NOT_SUPP;
  80296c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802971:	eb 1d                	jmp    802990 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802973:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802977:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80297b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80297f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802983:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802987:	48 89 ce             	mov    %rcx,%rsi
  80298a:	48 89 c7             	mov    %rax,%rdi
  80298d:	41 ff d0             	callq  *%r8
}
  802990:	c9                   	leaveq 
  802991:	c3                   	retq   

0000000000802992 <seek>:

int
seek(int fdnum, off_t offset)
{
  802992:	55                   	push   %rbp
  802993:	48 89 e5             	mov    %rsp,%rbp
  802996:	48 83 ec 18          	sub    $0x18,%rsp
  80299a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80299d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029a7:	48 89 d6             	mov    %rdx,%rsi
  8029aa:	89 c7                	mov    %eax,%edi
  8029ac:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8029b3:	00 00 00 
  8029b6:	ff d0                	callq  *%rax
  8029b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bf:	79 05                	jns    8029c6 <seek+0x34>
		return r;
  8029c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c4:	eb 0f                	jmp    8029d5 <seek+0x43>
	fd->fd_offset = offset;
  8029c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ca:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029cd:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d5:	c9                   	leaveq 
  8029d6:	c3                   	retq   

00000000008029d7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029d7:	55                   	push   %rbp
  8029d8:	48 89 e5             	mov    %rsp,%rbp
  8029db:	48 83 ec 30          	sub    $0x30,%rsp
  8029df:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029e2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029e5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029e9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029ec:	48 89 d6             	mov    %rdx,%rsi
  8029ef:	89 c7                	mov    %eax,%edi
  8029f1:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  8029f8:	00 00 00 
  8029fb:	ff d0                	callq  *%rax
  8029fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a04:	78 24                	js     802a2a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a0a:	8b 00                	mov    (%rax),%eax
  802a0c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a10:	48 89 d6             	mov    %rdx,%rsi
  802a13:	89 c7                	mov    %eax,%edi
  802a15:	48 b8 93 24 80 00 00 	movabs $0x802493,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a28:	79 05                	jns    802a2f <ftruncate+0x58>
		return r;
  802a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2d:	eb 72                	jmp    802aa1 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a33:	8b 40 08             	mov    0x8(%rax),%eax
  802a36:	83 e0 03             	and    $0x3,%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	75 3a                	jne    802a77 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a3d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802a44:	00 00 00 
  802a47:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a4a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a50:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a53:	89 c6                	mov    %eax,%esi
  802a55:	48 bf 30 4c 80 00 00 	movabs $0x804c30,%rdi
  802a5c:	00 00 00 
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a64:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  802a6b:	00 00 00 
  802a6e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a75:	eb 2a                	jmp    802aa1 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a7b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a7f:	48 85 c0             	test   %rax,%rax
  802a82:	75 07                	jne    802a8b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a84:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a89:	eb 16                	jmp    802aa1 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a97:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802a9a:	89 d6                	mov    %edx,%esi
  802a9c:	48 89 c7             	mov    %rax,%rdi
  802a9f:	ff d1                	callq  *%rcx
}
  802aa1:	c9                   	leaveq 
  802aa2:	c3                   	retq   

0000000000802aa3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802aa3:	55                   	push   %rbp
  802aa4:	48 89 e5             	mov    %rsp,%rbp
  802aa7:	48 83 ec 30          	sub    $0x30,%rsp
  802aab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ab2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ab6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ab9:	48 89 d6             	mov    %rdx,%rsi
  802abc:	89 c7                	mov    %eax,%edi
  802abe:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  802ac5:	00 00 00 
  802ac8:	ff d0                	callq  *%rax
  802aca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad1:	78 24                	js     802af7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad7:	8b 00                	mov    (%rax),%eax
  802ad9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802add:	48 89 d6             	mov    %rdx,%rsi
  802ae0:	89 c7                	mov    %eax,%edi
  802ae2:	48 b8 93 24 80 00 00 	movabs $0x802493,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
  802aee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802af5:	79 05                	jns    802afc <fstat+0x59>
		return r;
  802af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afa:	eb 5e                	jmp    802b5a <fstat+0xb7>
	if (!dev->dev_stat)
  802afc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b00:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b04:	48 85 c0             	test   %rax,%rax
  802b07:	75 07                	jne    802b10 <fstat+0x6d>
		return -E_NOT_SUPP;
  802b09:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b0e:	eb 4a                	jmp    802b5a <fstat+0xb7>
	stat->st_name[0] = 0;
  802b10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b14:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802b17:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802b22:	00 00 00 
	stat->st_isdir = 0;
  802b25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b29:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b30:	00 00 00 
	stat->st_dev = dev;
  802b33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b37:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b3b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b46:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802b4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802b52:	48 89 d6             	mov    %rdx,%rsi
  802b55:	48 89 c7             	mov    %rax,%rdi
  802b58:	ff d1                	callq  *%rcx
}
  802b5a:	c9                   	leaveq 
  802b5b:	c3                   	retq   

0000000000802b5c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b5c:	55                   	push   %rbp
  802b5d:	48 89 e5             	mov    %rsp,%rbp
  802b60:	48 83 ec 20          	sub    $0x20,%rsp
  802b64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b70:	be 00 00 00 00       	mov    $0x0,%esi
  802b75:	48 89 c7             	mov    %rax,%rdi
  802b78:	48 b8 4b 2c 80 00 00 	movabs $0x802c4b,%rax
  802b7f:	00 00 00 
  802b82:	ff d0                	callq  *%rax
  802b84:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b87:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8b:	79 05                	jns    802b92 <stat+0x36>
		return fd;
  802b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b90:	eb 2f                	jmp    802bc1 <stat+0x65>
	r = fstat(fd, stat);
  802b92:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b99:	48 89 d6             	mov    %rdx,%rsi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	48 b8 a3 2a 80 00 00 	movabs $0x802aa3,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
  802baa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802bad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb0:	89 c7                	mov    %eax,%edi
  802bb2:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
	return r;
  802bbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802bc1:	c9                   	leaveq 
  802bc2:	c3                   	retq   
	...

0000000000802bc4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802bc4:	55                   	push   %rbp
  802bc5:	48 89 e5             	mov    %rsp,%rbp
  802bc8:	48 83 ec 10          	sub    $0x10,%rsp
  802bcc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bcf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802bd3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802bda:	00 00 00 
  802bdd:	8b 00                	mov    (%rax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	75 1d                	jne    802c00 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802be3:	bf 01 00 00 00       	mov    $0x1,%edi
  802be8:	48 b8 cb 43 80 00 00 	movabs $0x8043cb,%rax
  802bef:	00 00 00 
  802bf2:	ff d0                	callq  *%rax
  802bf4:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802bfb:	00 00 00 
  802bfe:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802c00:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c07:	00 00 00 
  802c0a:	8b 00                	mov    (%rax),%eax
  802c0c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802c0f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802c14:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802c1b:	00 00 00 
  802c1e:	89 c7                	mov    %eax,%edi
  802c20:	48 b8 08 43 80 00 00 	movabs $0x804308,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802c2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c30:	ba 00 00 00 00       	mov    $0x0,%edx
  802c35:	48 89 c6             	mov    %rax,%rsi
  802c38:	bf 00 00 00 00       	mov    $0x0,%edi
  802c3d:	48 b8 48 42 80 00 00 	movabs $0x804248,%rax
  802c44:	00 00 00 
  802c47:	ff d0                	callq  *%rax
}
  802c49:	c9                   	leaveq 
  802c4a:	c3                   	retq   

0000000000802c4b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c4b:	55                   	push   %rbp
  802c4c:	48 89 e5             	mov    %rsp,%rbp
  802c4f:	48 83 ec 20          	sub    $0x20,%rsp
  802c53:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c57:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802c5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5e:	48 89 c7             	mov    %rax,%rdi
  802c61:	48 b8 ac 0e 80 00 00 	movabs $0x800eac,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c72:	7e 0a                	jle    802c7e <open+0x33>
                return -E_BAD_PATH;
  802c74:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c79:	e9 a5 00 00 00       	jmpq   802d23 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802c7e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c82:	48 89 c7             	mov    %rax,%rdi
  802c85:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
  802c91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c98:	79 08                	jns    802ca2 <open+0x57>
		return r;
  802c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9d:	e9 81 00 00 00       	jmpq   802d23 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802ca2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca6:	48 89 c6             	mov    %rax,%rsi
  802ca9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cb0:	00 00 00 
  802cb3:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802cbf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cc6:	00 00 00 
  802cc9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802ccc:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd6:	48 89 c6             	mov    %rax,%rsi
  802cd9:	bf 01 00 00 00       	mov    $0x1,%edi
  802cde:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802ced:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf1:	79 1d                	jns    802d10 <open+0xc5>
	{
		fd_close(fd,0);
  802cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf7:	be 00 00 00 00       	mov    $0x0,%esi
  802cfc:	48 89 c7             	mov    %rax,%rdi
  802cff:	48 b8 ca 23 80 00 00 	movabs $0x8023ca,%rax
  802d06:	00 00 00 
  802d09:	ff d0                	callq  *%rax
		return r;
  802d0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0e:	eb 13                	jmp    802d23 <open+0xd8>
	}
	return fd2num(fd);
  802d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d14:	48 89 c7             	mov    %rax,%rdi
  802d17:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
	


}
  802d23:	c9                   	leaveq 
  802d24:	c3                   	retq   

0000000000802d25 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802d25:	55                   	push   %rbp
  802d26:	48 89 e5             	mov    %rsp,%rbp
  802d29:	48 83 ec 10          	sub    $0x10,%rsp
  802d2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d35:	8b 50 0c             	mov    0xc(%rax),%edx
  802d38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d3f:	00 00 00 
  802d42:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d44:	be 00 00 00 00       	mov    $0x0,%esi
  802d49:	bf 06 00 00 00       	mov    $0x6,%edi
  802d4e:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
}
  802d5a:	c9                   	leaveq 
  802d5b:	c3                   	retq   

0000000000802d5c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d5c:	55                   	push   %rbp
  802d5d:	48 89 e5             	mov    %rsp,%rbp
  802d60:	48 83 ec 30          	sub    $0x30,%rsp
  802d64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d74:	8b 50 0c             	mov    0xc(%rax),%edx
  802d77:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d7e:	00 00 00 
  802d81:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d83:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d8a:	00 00 00 
  802d8d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d91:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802d95:	be 00 00 00 00       	mov    $0x0,%esi
  802d9a:	bf 03 00 00 00       	mov    $0x3,%edi
  802d9f:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802da6:	00 00 00 
  802da9:	ff d0                	callq  *%rax
  802dab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db2:	79 05                	jns    802db9 <devfile_read+0x5d>
	{
		return r;
  802db4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db7:	eb 2c                	jmp    802de5 <devfile_read+0x89>
	}
	if(r > 0)
  802db9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbd:	7e 23                	jle    802de2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802dbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc2:	48 63 d0             	movslq %eax,%rdx
  802dc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc9:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dd0:	00 00 00 
  802dd3:	48 89 c7             	mov    %rax,%rdi
  802dd6:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  802ddd:	00 00 00 
  802de0:	ff d0                	callq  *%rax
	return r;
  802de2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802de5:	c9                   	leaveq 
  802de6:	c3                   	retq   

0000000000802de7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802de7:	55                   	push   %rbp
  802de8:	48 89 e5             	mov    %rsp,%rbp
  802deb:	48 83 ec 30          	sub    $0x30,%rsp
  802def:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802df3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802df7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dff:	8b 50 0c             	mov    0xc(%rax),%edx
  802e02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e09:	00 00 00 
  802e0c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802e0e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802e15:	00 
  802e16:	76 08                	jbe    802e20 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802e18:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802e1f:	00 
	fsipcbuf.write.req_n=n;
  802e20:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e27:	00 00 00 
  802e2a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e2e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802e32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e36:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e3a:	48 89 c6             	mov    %rax,%rsi
  802e3d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802e44:	00 00 00 
  802e47:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802e53:	be 00 00 00 00       	mov    $0x0,%esi
  802e58:	bf 04 00 00 00       	mov    $0x4,%edi
  802e5d:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802e6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e6f:	c9                   	leaveq 
  802e70:	c3                   	retq   

0000000000802e71 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802e71:	55                   	push   %rbp
  802e72:	48 89 e5             	mov    %rsp,%rbp
  802e75:	48 83 ec 10          	sub    $0x10,%rsp
  802e79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e7d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e84:	8b 50 0c             	mov    0xc(%rax),%edx
  802e87:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e8e:	00 00 00 
  802e91:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802e93:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e9a:	00 00 00 
  802e9d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ea0:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802ea3:	be 00 00 00 00       	mov    $0x0,%esi
  802ea8:	bf 02 00 00 00       	mov    $0x2,%edi
  802ead:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
}
  802eb9:	c9                   	leaveq 
  802eba:	c3                   	retq   

0000000000802ebb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802ebb:	55                   	push   %rbp
  802ebc:	48 89 e5             	mov    %rsp,%rbp
  802ebf:	48 83 ec 20          	sub    $0x20,%rsp
  802ec3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ec7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802ecb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ecf:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ed9:	00 00 00 
  802edc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ede:	be 00 00 00 00       	mov    $0x0,%esi
  802ee3:	bf 05 00 00 00       	mov    $0x5,%edi
  802ee8:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
  802eef:	00 00 00 
  802ef2:	ff d0                	callq  *%rax
  802ef4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efb:	79 05                	jns    802f02 <devfile_stat+0x47>
		return r;
  802efd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f00:	eb 56                	jmp    802f58 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802f02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f06:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f0d:	00 00 00 
  802f10:	48 89 c7             	mov    %rax,%rdi
  802f13:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  802f1a:	00 00 00 
  802f1d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802f1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f26:	00 00 00 
  802f29:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802f2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f33:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802f39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f40:	00 00 00 
  802f43:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802f49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f4d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f58:	c9                   	leaveq 
  802f59:	c3                   	retq   
	...

0000000000802f5c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802f5c:	55                   	push   %rbp
  802f5d:	48 89 e5             	mov    %rsp,%rbp
  802f60:	48 83 ec 20          	sub    $0x20,%rsp
  802f64:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802f67:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f6e:	48 89 d6             	mov    %rdx,%rsi
  802f71:	89 c7                	mov    %eax,%edi
  802f73:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  802f7a:	00 00 00 
  802f7d:	ff d0                	callq  *%rax
  802f7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f86:	79 05                	jns    802f8d <fd2sockid+0x31>
		return r;
  802f88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8b:	eb 24                	jmp    802fb1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802f8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f91:	8b 10                	mov    (%rax),%edx
  802f93:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802f9a:	00 00 00 
  802f9d:	8b 00                	mov    (%rax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	74 07                	je     802faa <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802fa3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fa8:	eb 07                	jmp    802fb1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fae:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802fb1:	c9                   	leaveq 
  802fb2:	c3                   	retq   

0000000000802fb3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802fb3:	55                   	push   %rbp
  802fb4:	48 89 e5             	mov    %rsp,%rbp
  802fb7:	48 83 ec 20          	sub    $0x20,%rsp
  802fbb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802fbe:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fc2:	48 89 c7             	mov    %rax,%rdi
  802fc5:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
  802fd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd8:	78 26                	js     803000 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fde:	ba 07 04 00 00       	mov    $0x407,%edx
  802fe3:	48 89 c6             	mov    %rax,%rsi
  802fe6:	bf 00 00 00 00       	mov    $0x0,%edi
  802feb:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  802ff2:	00 00 00 
  802ff5:	ff d0                	callq  *%rax
  802ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ffe:	79 16                	jns    803016 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803000:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803003:	89 c7                	mov    %eax,%edi
  803005:	48 b8 c0 34 80 00 00 	movabs $0x8034c0,%rax
  80300c:	00 00 00 
  80300f:	ff d0                	callq  *%rax
		return r;
  803011:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803014:	eb 3a                	jmp    803050 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803021:	00 00 00 
  803024:	8b 12                	mov    (%rdx),%edx
  803026:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80302c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803037:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80303a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80303d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803041:	48 89 c7             	mov    %rax,%rdi
  803044:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
}
  803050:	c9                   	leaveq 
  803051:	c3                   	retq   

0000000000803052 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803052:	55                   	push   %rbp
  803053:	48 89 e5             	mov    %rsp,%rbp
  803056:	48 83 ec 30          	sub    $0x30,%rsp
  80305a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80305d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803061:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803065:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803068:	89 c7                	mov    %eax,%edi
  80306a:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
  803076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307d:	79 05                	jns    803084 <accept+0x32>
		return r;
  80307f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803082:	eb 3b                	jmp    8030bf <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803084:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803088:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80308c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308f:	48 89 ce             	mov    %rcx,%rsi
  803092:	89 c7                	mov    %eax,%edi
  803094:	48 b8 9d 33 80 00 00 	movabs $0x80339d,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax
  8030a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a7:	79 05                	jns    8030ae <accept+0x5c>
		return r;
  8030a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ac:	eb 11                	jmp    8030bf <accept+0x6d>
	return alloc_sockfd(r);
  8030ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b1:	89 c7                	mov    %eax,%edi
  8030b3:	48 b8 b3 2f 80 00 00 	movabs $0x802fb3,%rax
  8030ba:	00 00 00 
  8030bd:	ff d0                	callq  *%rax
}
  8030bf:	c9                   	leaveq 
  8030c0:	c3                   	retq   

00000000008030c1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8030c1:	55                   	push   %rbp
  8030c2:	48 89 e5             	mov    %rsp,%rbp
  8030c5:	48 83 ec 20          	sub    $0x20,%rsp
  8030c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d0:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8030d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030d6:	89 c7                	mov    %eax,%edi
  8030d8:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  8030df:	00 00 00 
  8030e2:	ff d0                	callq  *%rax
  8030e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030eb:	79 05                	jns    8030f2 <bind+0x31>
		return r;
  8030ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f0:	eb 1b                	jmp    80310d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8030f2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8030f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fc:	48 89 ce             	mov    %rcx,%rsi
  8030ff:	89 c7                	mov    %eax,%edi
  803101:	48 b8 1c 34 80 00 00 	movabs $0x80341c,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <shutdown>:

int
shutdown(int s, int how)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
  803113:	48 83 ec 20          	sub    $0x20,%rsp
  803117:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80311a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80311d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803120:	89 c7                	mov    %eax,%edi
  803122:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
  80312e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803131:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803135:	79 05                	jns    80313c <shutdown+0x2d>
		return r;
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	eb 16                	jmp    803152 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80313c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80313f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803142:	89 d6                	mov    %edx,%esi
  803144:	89 c7                	mov    %eax,%edi
  803146:	48 b8 80 34 80 00 00 	movabs $0x803480,%rax
  80314d:	00 00 00 
  803150:	ff d0                	callq  *%rax
}
  803152:	c9                   	leaveq 
  803153:	c3                   	retq   

0000000000803154 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803154:	55                   	push   %rbp
  803155:	48 89 e5             	mov    %rsp,%rbp
  803158:	48 83 ec 10          	sub    $0x10,%rsp
  80315c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803160:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803164:	48 89 c7             	mov    %rax,%rdi
  803167:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  80316e:	00 00 00 
  803171:	ff d0                	callq  *%rax
  803173:	83 f8 01             	cmp    $0x1,%eax
  803176:	75 17                	jne    80318f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803178:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80317c:	8b 40 0c             	mov    0xc(%rax),%eax
  80317f:	89 c7                	mov    %eax,%edi
  803181:	48 b8 c0 34 80 00 00 	movabs $0x8034c0,%rax
  803188:	00 00 00 
  80318b:	ff d0                	callq  *%rax
  80318d:	eb 05                	jmp    803194 <devsock_close+0x40>
	else
		return 0;
  80318f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803194:	c9                   	leaveq 
  803195:	c3                   	retq   

0000000000803196 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803196:	55                   	push   %rbp
  803197:	48 89 e5             	mov    %rsp,%rbp
  80319a:	48 83 ec 20          	sub    $0x20,%rsp
  80319e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031a5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ab:	89 c7                	mov    %eax,%edi
  8031ad:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  8031b4:	00 00 00 
  8031b7:	ff d0                	callq  *%rax
  8031b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c0:	79 05                	jns    8031c7 <connect+0x31>
		return r;
  8031c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c5:	eb 1b                	jmp    8031e2 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8031c7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031ca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d1:	48 89 ce             	mov    %rcx,%rsi
  8031d4:	89 c7                	mov    %eax,%edi
  8031d6:	48 b8 ed 34 80 00 00 	movabs $0x8034ed,%rax
  8031dd:	00 00 00 
  8031e0:	ff d0                	callq  *%rax
}
  8031e2:	c9                   	leaveq 
  8031e3:	c3                   	retq   

00000000008031e4 <listen>:

int
listen(int s, int backlog)
{
  8031e4:	55                   	push   %rbp
  8031e5:	48 89 e5             	mov    %rsp,%rbp
  8031e8:	48 83 ec 20          	sub    $0x20,%rsp
  8031ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031ef:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031f5:	89 c7                	mov    %eax,%edi
  8031f7:	48 b8 5c 2f 80 00 00 	movabs $0x802f5c,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
  803203:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803206:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80320a:	79 05                	jns    803211 <listen+0x2d>
		return r;
  80320c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320f:	eb 16                	jmp    803227 <listen+0x43>
	return nsipc_listen(r, backlog);
  803211:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803214:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803217:	89 d6                	mov    %edx,%esi
  803219:	89 c7                	mov    %eax,%edi
  80321b:	48 b8 51 35 80 00 00 	movabs $0x803551,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
}
  803227:	c9                   	leaveq 
  803228:	c3                   	retq   

0000000000803229 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803229:	55                   	push   %rbp
  80322a:	48 89 e5             	mov    %rsp,%rbp
  80322d:	48 83 ec 20          	sub    $0x20,%rsp
  803231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803235:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803239:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80323d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803241:	89 c2                	mov    %eax,%edx
  803243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803247:	8b 40 0c             	mov    0xc(%rax),%eax
  80324a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80324e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803253:	89 c7                	mov    %eax,%edi
  803255:	48 b8 91 35 80 00 00 	movabs $0x803591,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
}
  803261:	c9                   	leaveq 
  803262:	c3                   	retq   

0000000000803263 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803263:	55                   	push   %rbp
  803264:	48 89 e5             	mov    %rsp,%rbp
  803267:	48 83 ec 20          	sub    $0x20,%rsp
  80326b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80326f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803273:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80327b:	89 c2                	mov    %eax,%edx
  80327d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803281:	8b 40 0c             	mov    0xc(%rax),%eax
  803284:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803288:	b9 00 00 00 00       	mov    $0x0,%ecx
  80328d:	89 c7                	mov    %eax,%edi
  80328f:	48 b8 5d 36 80 00 00 	movabs $0x80365d,%rax
  803296:	00 00 00 
  803299:	ff d0                	callq  *%rax
}
  80329b:	c9                   	leaveq 
  80329c:	c3                   	retq   

000000000080329d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80329d:	55                   	push   %rbp
  80329e:	48 89 e5             	mov    %rsp,%rbp
  8032a1:	48 83 ec 10          	sub    $0x10,%rsp
  8032a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b1:	48 be 5b 4c 80 00 00 	movabs $0x804c5b,%rsi
  8032b8:	00 00 00 
  8032bb:	48 89 c7             	mov    %rax,%rdi
  8032be:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
	return 0;
  8032ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032cf:	c9                   	leaveq 
  8032d0:	c3                   	retq   

00000000008032d1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8032d1:	55                   	push   %rbp
  8032d2:	48 89 e5             	mov    %rsp,%rbp
  8032d5:	48 83 ec 20          	sub    $0x20,%rsp
  8032d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8032df:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8032e2:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8032e5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8032e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032eb:	89 ce                	mov    %ecx,%esi
  8032ed:	89 c7                	mov    %eax,%edi
  8032ef:	48 b8 15 37 80 00 00 	movabs $0x803715,%rax
  8032f6:	00 00 00 
  8032f9:	ff d0                	callq  *%rax
  8032fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803302:	79 05                	jns    803309 <socket+0x38>
		return r;
  803304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803307:	eb 11                	jmp    80331a <socket+0x49>
	return alloc_sockfd(r);
  803309:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330c:	89 c7                	mov    %eax,%edi
  80330e:	48 b8 b3 2f 80 00 00 	movabs $0x802fb3,%rax
  803315:	00 00 00 
  803318:	ff d0                	callq  *%rax
}
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 10          	sub    $0x10,%rsp
  803324:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803327:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  80332e:	00 00 00 
  803331:	8b 00                	mov    (%rax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	75 1d                	jne    803354 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803337:	bf 02 00 00 00       	mov    $0x2,%edi
  80333c:	48 b8 cb 43 80 00 00 	movabs $0x8043cb,%rax
  803343:	00 00 00 
  803346:	ff d0                	callq  *%rax
  803348:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  80334f:	00 00 00 
  803352:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803354:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  80335b:	00 00 00 
  80335e:	8b 00                	mov    (%rax),%eax
  803360:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803363:	b9 07 00 00 00       	mov    $0x7,%ecx
  803368:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80336f:	00 00 00 
  803372:	89 c7                	mov    %eax,%edi
  803374:	48 b8 08 43 80 00 00 	movabs $0x804308,%rax
  80337b:	00 00 00 
  80337e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803380:	ba 00 00 00 00       	mov    $0x0,%edx
  803385:	be 00 00 00 00       	mov    $0x0,%esi
  80338a:	bf 00 00 00 00       	mov    $0x0,%edi
  80338f:	48 b8 48 42 80 00 00 	movabs $0x804248,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 30          	sub    $0x30,%rsp
  8033a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8033b0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b7:	00 00 00 
  8033ba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033bd:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8033bf:	bf 01 00 00 00       	mov    $0x1,%edi
  8033c4:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  8033cb:	00 00 00 
  8033ce:	ff d0                	callq  *%rax
  8033d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033d7:	78 3e                	js     803417 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8033d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e0:	00 00 00 
  8033e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8033e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033eb:	8b 40 10             	mov    0x10(%rax),%eax
  8033ee:	89 c2                	mov    %eax,%edx
  8033f0:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8033f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f8:	48 89 ce             	mov    %rcx,%rsi
  8033fb:	48 89 c7             	mov    %rax,%rdi
  8033fe:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80340a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80340e:	8b 50 10             	mov    0x10(%rax),%edx
  803411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803415:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803417:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80341a:	c9                   	leaveq 
  80341b:	c3                   	retq   

000000000080341c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80341c:	55                   	push   %rbp
  80341d:	48 89 e5             	mov    %rsp,%rbp
  803420:	48 83 ec 10          	sub    $0x10,%rsp
  803424:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803427:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80342b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80342e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803435:	00 00 00 
  803438:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80343b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80343d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803444:	48 89 c6             	mov    %rax,%rsi
  803447:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80344e:	00 00 00 
  803451:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  803458:	00 00 00 
  80345b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80345d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803464:	00 00 00 
  803467:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80346a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80346d:	bf 02 00 00 00       	mov    $0x2,%edi
  803472:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  803479:	00 00 00 
  80347c:	ff d0                	callq  *%rax
}
  80347e:	c9                   	leaveq 
  80347f:	c3                   	retq   

0000000000803480 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803480:	55                   	push   %rbp
  803481:	48 89 e5             	mov    %rsp,%rbp
  803484:	48 83 ec 10          	sub    $0x10,%rsp
  803488:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80348b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80348e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803495:	00 00 00 
  803498:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80349b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80349d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a4:	00 00 00 
  8034a7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8034aa:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8034ad:	bf 03 00 00 00       	mov    $0x3,%edi
  8034b2:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
}
  8034be:	c9                   	leaveq 
  8034bf:	c3                   	retq   

00000000008034c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8034c0:	55                   	push   %rbp
  8034c1:	48 89 e5             	mov    %rsp,%rbp
  8034c4:	48 83 ec 10          	sub    $0x10,%rsp
  8034c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8034cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034d2:	00 00 00 
  8034d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8034d8:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8034da:	bf 04 00 00 00       	mov    $0x4,%edi
  8034df:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
}
  8034eb:	c9                   	leaveq 
  8034ec:	c3                   	retq   

00000000008034ed <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8034ed:	55                   	push   %rbp
  8034ee:	48 89 e5             	mov    %rsp,%rbp
  8034f1:	48 83 ec 10          	sub    $0x10,%rsp
  8034f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8034ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803506:	00 00 00 
  803509:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80350c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80350e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803515:	48 89 c6             	mov    %rax,%rsi
  803518:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80351f:	00 00 00 
  803522:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  803529:	00 00 00 
  80352c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80352e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803535:	00 00 00 
  803538:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80353b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80353e:	bf 05 00 00 00       	mov    $0x5,%edi
  803543:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  80354a:	00 00 00 
  80354d:	ff d0                	callq  *%rax
}
  80354f:	c9                   	leaveq 
  803550:	c3                   	retq   

0000000000803551 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803551:	55                   	push   %rbp
  803552:	48 89 e5             	mov    %rsp,%rbp
  803555:	48 83 ec 10          	sub    $0x10,%rsp
  803559:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80355c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80355f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803566:	00 00 00 
  803569:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80356c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80356e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803575:	00 00 00 
  803578:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80357b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80357e:	bf 06 00 00 00       	mov    $0x6,%edi
  803583:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  80358a:	00 00 00 
  80358d:	ff d0                	callq  *%rax
}
  80358f:	c9                   	leaveq 
  803590:	c3                   	retq   

0000000000803591 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803591:	55                   	push   %rbp
  803592:	48 89 e5             	mov    %rsp,%rbp
  803595:	48 83 ec 30          	sub    $0x30,%rsp
  803599:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80359c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035a0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8035a3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8035a6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035ad:	00 00 00 
  8035b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035b3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8035b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035bc:	00 00 00 
  8035bf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8035c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035cc:	00 00 00 
  8035cf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8035d2:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8035d5:	bf 07 00 00 00       	mov    $0x7,%edi
  8035da:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  8035e1:	00 00 00 
  8035e4:	ff d0                	callq  *%rax
  8035e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ed:	78 69                	js     803658 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8035ef:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8035f6:	7f 08                	jg     803600 <nsipc_recv+0x6f>
  8035f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8035fe:	7e 35                	jle    803635 <nsipc_recv+0xa4>
  803600:	48 b9 62 4c 80 00 00 	movabs $0x804c62,%rcx
  803607:	00 00 00 
  80360a:	48 ba 77 4c 80 00 00 	movabs $0x804c77,%rdx
  803611:	00 00 00 
  803614:	be 61 00 00 00       	mov    $0x61,%esi
  803619:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  803620:	00 00 00 
  803623:	b8 00 00 00 00       	mov    $0x0,%eax
  803628:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  80362f:	00 00 00 
  803632:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803635:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803638:	48 63 d0             	movslq %eax,%rdx
  80363b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80363f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803646:	00 00 00 
  803649:	48 89 c7             	mov    %rax,%rdi
  80364c:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
	}

	return r;
  803658:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80365b:	c9                   	leaveq 
  80365c:	c3                   	retq   

000000000080365d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80365d:	55                   	push   %rbp
  80365e:	48 89 e5             	mov    %rsp,%rbp
  803661:	48 83 ec 20          	sub    $0x20,%rsp
  803665:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803668:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80366c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80366f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803672:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803679:	00 00 00 
  80367c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80367f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803681:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803688:	7e 35                	jle    8036bf <nsipc_send+0x62>
  80368a:	48 b9 98 4c 80 00 00 	movabs $0x804c98,%rcx
  803691:	00 00 00 
  803694:	48 ba 77 4c 80 00 00 	movabs $0x804c77,%rdx
  80369b:	00 00 00 
  80369e:	be 6c 00 00 00       	mov    $0x6c,%esi
  8036a3:	48 bf 8c 4c 80 00 00 	movabs $0x804c8c,%rdi
  8036aa:	00 00 00 
  8036ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b2:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  8036b9:	00 00 00 
  8036bc:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8036bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c2:	48 63 d0             	movslq %eax,%rdx
  8036c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c9:	48 89 c6             	mov    %rax,%rsi
  8036cc:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8036d3:	00 00 00 
  8036d6:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8036e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036e9:	00 00 00 
  8036ec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8036f2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036f9:	00 00 00 
  8036fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036ff:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803702:	bf 08 00 00 00       	mov    $0x8,%edi
  803707:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  80370e:	00 00 00 
  803711:	ff d0                	callq  *%rax
}
  803713:	c9                   	leaveq 
  803714:	c3                   	retq   

0000000000803715 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803715:	55                   	push   %rbp
  803716:	48 89 e5             	mov    %rsp,%rbp
  803719:	48 83 ec 10          	sub    $0x10,%rsp
  80371d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803720:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803723:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803726:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372d:	00 00 00 
  803730:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803733:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803735:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373c:	00 00 00 
  80373f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803745:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80374c:	00 00 00 
  80374f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803752:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803755:	bf 09 00 00 00       	mov    $0x9,%edi
  80375a:	48 b8 1c 33 80 00 00 	movabs $0x80331c,%rax
  803761:	00 00 00 
  803764:	ff d0                	callq  *%rax
}
  803766:	c9                   	leaveq 
  803767:	c3                   	retq   

0000000000803768 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803768:	55                   	push   %rbp
  803769:	48 89 e5             	mov    %rsp,%rbp
  80376c:	53                   	push   %rbx
  80376d:	48 83 ec 38          	sub    $0x38,%rsp
  803771:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803775:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803779:	48 89 c7             	mov    %rax,%rdi
  80377c:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80378b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378f:	0f 88 bf 01 00 00    	js     803954 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803799:	ba 07 04 00 00       	mov    $0x407,%edx
  80379e:	48 89 c6             	mov    %rax,%rsi
  8037a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8037a6:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  8037ad:	00 00 00 
  8037b0:	ff d0                	callq  *%rax
  8037b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037b9:	0f 88 95 01 00 00    	js     803954 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037c3:	48 89 c7             	mov    %rax,%rdi
  8037c6:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  8037cd:	00 00 00 
  8037d0:	ff d0                	callq  *%rax
  8037d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037d9:	0f 88 5d 01 00 00    	js     80393c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037e3:	ba 07 04 00 00       	mov    $0x407,%edx
  8037e8:	48 89 c6             	mov    %rax,%rsi
  8037eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f0:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  8037f7:	00 00 00 
  8037fa:	ff d0                	callq  *%rax
  8037fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803803:	0f 88 33 01 00 00    	js     80393c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80380d:	48 89 c7             	mov    %rax,%rdi
  803810:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
  80381c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803820:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803824:	ba 07 04 00 00       	mov    $0x407,%edx
  803829:	48 89 c6             	mov    %rax,%rsi
  80382c:	bf 00 00 00 00       	mov    $0x0,%edi
  803831:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803840:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803844:	0f 88 d9 00 00 00    	js     803923 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80384a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384e:	48 89 c7             	mov    %rax,%rdi
  803851:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803858:	00 00 00 
  80385b:	ff d0                	callq  *%rax
  80385d:	48 89 c2             	mov    %rax,%rdx
  803860:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803864:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80386a:	48 89 d1             	mov    %rdx,%rcx
  80386d:	ba 00 00 00 00       	mov    $0x0,%edx
  803872:	48 89 c6             	mov    %rax,%rsi
  803875:	bf 00 00 00 00       	mov    $0x0,%edi
  80387a:	48 b8 a0 18 80 00 00 	movabs $0x8018a0,%rax
  803881:	00 00 00 
  803884:	ff d0                	callq  *%rax
  803886:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803889:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80388d:	78 79                	js     803908 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80388f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803893:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80389a:	00 00 00 
  80389d:	8b 12                	mov    (%rdx),%edx
  80389f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038b0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038b7:	00 00 00 
  8038ba:	8b 12                	mov    (%rdx),%edx
  8038bc:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038c2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038cd:	48 89 c7             	mov    %rax,%rdi
  8038d0:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  8038d7:	00 00 00 
  8038da:	ff d0                	callq  *%rax
  8038dc:	89 c2                	mov    %eax,%edx
  8038de:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038e2:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8038e4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038e8:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8038ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f0:	48 89 c7             	mov    %rax,%rdi
  8038f3:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  8038fa:	00 00 00 
  8038fd:	ff d0                	callq  *%rax
  8038ff:	89 03                	mov    %eax,(%rbx)
	return 0;
  803901:	b8 00 00 00 00       	mov    $0x0,%eax
  803906:	eb 4f                	jmp    803957 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803908:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803909:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80390d:	48 89 c6             	mov    %rax,%rsi
  803910:	bf 00 00 00 00       	mov    $0x0,%edi
  803915:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  80391c:	00 00 00 
  80391f:	ff d0                	callq  *%rax
  803921:	eb 01                	jmp    803924 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803923:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803924:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803928:	48 89 c6             	mov    %rax,%rsi
  80392b:	bf 00 00 00 00       	mov    $0x0,%edi
  803930:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80393c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803940:	48 89 c6             	mov    %rax,%rsi
  803943:	bf 00 00 00 00       	mov    $0x0,%edi
  803948:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
    err:
	return r;
  803954:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803957:	48 83 c4 38          	add    $0x38,%rsp
  80395b:	5b                   	pop    %rbx
  80395c:	5d                   	pop    %rbp
  80395d:	c3                   	retq   

000000000080395e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80395e:	55                   	push   %rbp
  80395f:	48 89 e5             	mov    %rsp,%rbp
  803962:	53                   	push   %rbx
  803963:	48 83 ec 28          	sub    $0x28,%rsp
  803967:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80396b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80396f:	eb 01                	jmp    803972 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803971:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803972:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803979:	00 00 00 
  80397c:	48 8b 00             	mov    (%rax),%rax
  80397f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803985:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398c:	48 89 c7             	mov    %rax,%rdi
  80398f:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  803996:	00 00 00 
  803999:	ff d0                	callq  *%rax
  80399b:	89 c3                	mov    %eax,%ebx
  80399d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039a1:	48 89 c7             	mov    %rax,%rdi
  8039a4:	48 b8 50 44 80 00 00 	movabs $0x804450,%rax
  8039ab:	00 00 00 
  8039ae:	ff d0                	callq  *%rax
  8039b0:	39 c3                	cmp    %eax,%ebx
  8039b2:	0f 94 c0             	sete   %al
  8039b5:	0f b6 c0             	movzbl %al,%eax
  8039b8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039bb:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8039c2:	00 00 00 
  8039c5:	48 8b 00             	mov    (%rax),%rax
  8039c8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039ce:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039d4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039d7:	75 0a                	jne    8039e3 <_pipeisclosed+0x85>
			return ret;
  8039d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8039dc:	48 83 c4 28          	add    $0x28,%rsp
  8039e0:	5b                   	pop    %rbx
  8039e1:	5d                   	pop    %rbp
  8039e2:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8039e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039e9:	74 86                	je     803971 <_pipeisclosed+0x13>
  8039eb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039ef:	75 80                	jne    803971 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039f1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8039f8:	00 00 00 
  8039fb:	48 8b 00             	mov    (%rax),%rax
  8039fe:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a04:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a0a:	89 c6                	mov    %eax,%esi
  803a0c:	48 bf a9 4c 80 00 00 	movabs $0x804ca9,%rdi
  803a13:	00 00 00 
  803a16:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1b:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803a22:	00 00 00 
  803a25:	41 ff d0             	callq  *%r8
	}
  803a28:	e9 44 ff ff ff       	jmpq   803971 <_pipeisclosed+0x13>

0000000000803a2d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803a2d:	55                   	push   %rbp
  803a2e:	48 89 e5             	mov    %rsp,%rbp
  803a31:	48 83 ec 30          	sub    $0x30,%rsp
  803a35:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a38:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a3f:	48 89 d6             	mov    %rdx,%rsi
  803a42:	89 c7                	mov    %eax,%edi
  803a44:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  803a4b:	00 00 00 
  803a4e:	ff d0                	callq  *%rax
  803a50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a57:	79 05                	jns    803a5e <pipeisclosed+0x31>
		return r;
  803a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a5c:	eb 31                	jmp    803a8f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a62:	48 89 c7             	mov    %rax,%rdi
  803a65:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
  803a71:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a7d:	48 89 d6             	mov    %rdx,%rsi
  803a80:	48 89 c7             	mov    %rax,%rdi
  803a83:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  803a8a:	00 00 00 
  803a8d:	ff d0                	callq  *%rax
}
  803a8f:	c9                   	leaveq 
  803a90:	c3                   	retq   

0000000000803a91 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a91:	55                   	push   %rbp
  803a92:	48 89 e5             	mov    %rsp,%rbp
  803a95:	48 83 ec 40          	sub    $0x40,%rsp
  803a99:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a9d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803aa1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803aa5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa9:	48 89 c7             	mov    %rax,%rdi
  803aac:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803ab3:	00 00 00 
  803ab6:	ff d0                	callq  *%rax
  803ab8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803abc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ac4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803acb:	00 
  803acc:	e9 97 00 00 00       	jmpq   803b68 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ad1:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ad6:	74 09                	je     803ae1 <devpipe_read+0x50>
				return i;
  803ad8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803adc:	e9 95 00 00 00       	jmpq   803b76 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803ae1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae9:	48 89 d6             	mov    %rdx,%rsi
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	85 c0                	test   %eax,%eax
  803afd:	74 07                	je     803b06 <devpipe_read+0x75>
				return 0;
  803aff:	b8 00 00 00 00       	mov    $0x0,%eax
  803b04:	eb 70                	jmp    803b76 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b06:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  803b0d:	00 00 00 
  803b10:	ff d0                	callq  *%rax
  803b12:	eb 01                	jmp    803b15 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b14:	90                   	nop
  803b15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b19:	8b 10                	mov    (%rax),%edx
  803b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1f:	8b 40 04             	mov    0x4(%rax),%eax
  803b22:	39 c2                	cmp    %eax,%edx
  803b24:	74 ab                	je     803ad1 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b2a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b2e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b36:	8b 00                	mov    (%rax),%eax
  803b38:	89 c2                	mov    %eax,%edx
  803b3a:	c1 fa 1f             	sar    $0x1f,%edx
  803b3d:	c1 ea 1b             	shr    $0x1b,%edx
  803b40:	01 d0                	add    %edx,%eax
  803b42:	83 e0 1f             	and    $0x1f,%eax
  803b45:	29 d0                	sub    %edx,%eax
  803b47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b4b:	48 98                	cltq   
  803b4d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b52:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b58:	8b 00                	mov    (%rax),%eax
  803b5a:	8d 50 01             	lea    0x1(%rax),%edx
  803b5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b61:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b63:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b6c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b70:	72 a2                	jb     803b14 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b76:	c9                   	leaveq 
  803b77:	c3                   	retq   

0000000000803b78 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b78:	55                   	push   %rbp
  803b79:	48 89 e5             	mov    %rsp,%rbp
  803b7c:	48 83 ec 40          	sub    $0x40,%rsp
  803b80:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b84:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b88:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803b8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b90:	48 89 c7             	mov    %rax,%rdi
  803b93:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803b9a:	00 00 00 
  803b9d:	ff d0                	callq  *%rax
  803b9f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ba3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bab:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bb2:	00 
  803bb3:	e9 93 00 00 00       	jmpq   803c4b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803bb8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc0:	48 89 d6             	mov    %rdx,%rsi
  803bc3:	48 89 c7             	mov    %rax,%rdi
  803bc6:	48 b8 5e 39 80 00 00 	movabs $0x80395e,%rax
  803bcd:	00 00 00 
  803bd0:	ff d0                	callq  *%rax
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	74 07                	je     803bdd <devpipe_write+0x65>
				return 0;
  803bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bdb:	eb 7c                	jmp    803c59 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bdd:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  803be4:	00 00 00 
  803be7:	ff d0                	callq  *%rax
  803be9:	eb 01                	jmp    803bec <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803beb:	90                   	nop
  803bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf0:	8b 40 04             	mov    0x4(%rax),%eax
  803bf3:	48 63 d0             	movslq %eax,%rdx
  803bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bfa:	8b 00                	mov    (%rax),%eax
  803bfc:	48 98                	cltq   
  803bfe:	48 83 c0 20          	add    $0x20,%rax
  803c02:	48 39 c2             	cmp    %rax,%rdx
  803c05:	73 b1                	jae    803bb8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c0b:	8b 40 04             	mov    0x4(%rax),%eax
  803c0e:	89 c2                	mov    %eax,%edx
  803c10:	c1 fa 1f             	sar    $0x1f,%edx
  803c13:	c1 ea 1b             	shr    $0x1b,%edx
  803c16:	01 d0                	add    %edx,%eax
  803c18:	83 e0 1f             	and    $0x1f,%eax
  803c1b:	29 d0                	sub    %edx,%eax
  803c1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c21:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c25:	48 01 ca             	add    %rcx,%rdx
  803c28:	0f b6 0a             	movzbl (%rdx),%ecx
  803c2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c2f:	48 98                	cltq   
  803c31:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c39:	8b 40 04             	mov    0x4(%rax),%eax
  803c3c:	8d 50 01             	lea    0x1(%rax),%edx
  803c3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c43:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c46:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c4f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c53:	72 96                	jb     803beb <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c59:	c9                   	leaveq 
  803c5a:	c3                   	retq   

0000000000803c5b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c5b:	55                   	push   %rbp
  803c5c:	48 89 e5             	mov    %rsp,%rbp
  803c5f:	48 83 ec 20          	sub    $0x20,%rsp
  803c63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c6f:	48 89 c7             	mov    %rax,%rdi
  803c72:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
  803c7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c86:	48 be bc 4c 80 00 00 	movabs $0x804cbc,%rsi
  803c8d:	00 00 00 
  803c90:	48 89 c7             	mov    %rax,%rdi
  803c93:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ca3:	8b 50 04             	mov    0x4(%rax),%edx
  803ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803caa:	8b 00                	mov    (%rax),%eax
  803cac:	29 c2                	sub    %eax,%edx
  803cae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cc3:	00 00 00 
	stat->st_dev = &devpipe;
  803cc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cca:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cd1:	00 00 00 
  803cd4:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ce0:	c9                   	leaveq 
  803ce1:	c3                   	retq   

0000000000803ce2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803ce2:	55                   	push   %rbp
  803ce3:	48 89 e5             	mov    %rsp,%rbp
  803ce6:	48 83 ec 10          	sub    $0x10,%rsp
  803cea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803cee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf2:	48 89 c6             	mov    %rax,%rsi
  803cf5:	bf 00 00 00 00       	mov    $0x0,%edi
  803cfa:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  803d01:	00 00 00 
  803d04:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d0a:	48 89 c7             	mov    %rax,%rdi
  803d0d:	48 b8 77 22 80 00 00 	movabs $0x802277,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	48 89 c6             	mov    %rax,%rsi
  803d1c:	bf 00 00 00 00       	mov    $0x0,%edi
  803d21:	48 b8 fb 18 80 00 00 	movabs $0x8018fb,%rax
  803d28:	00 00 00 
  803d2b:	ff d0                	callq  *%rax
}
  803d2d:	c9                   	leaveq 
  803d2e:	c3                   	retq   
	...

0000000000803d30 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803d30:	55                   	push   %rbp
  803d31:	48 89 e5             	mov    %rsp,%rbp
  803d34:	48 83 ec 20          	sub    $0x20,%rsp
  803d38:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803d3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d3e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803d41:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803d45:	be 01 00 00 00       	mov    $0x1,%esi
  803d4a:	48 89 c7             	mov    %rax,%rdi
  803d4d:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  803d54:	00 00 00 
  803d57:	ff d0                	callq  *%rax
}
  803d59:	c9                   	leaveq 
  803d5a:	c3                   	retq   

0000000000803d5b <getchar>:

int
getchar(void)
{
  803d5b:	55                   	push   %rbp
  803d5c:	48 89 e5             	mov    %rsp,%rbp
  803d5f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803d63:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803d67:	ba 01 00 00 00       	mov    $0x1,%edx
  803d6c:	48 89 c6             	mov    %rax,%rsi
  803d6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803d74:	48 b8 6c 27 80 00 00 	movabs $0x80276c,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
  803d80:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803d83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d87:	79 05                	jns    803d8e <getchar+0x33>
		return r;
  803d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8c:	eb 14                	jmp    803da2 <getchar+0x47>
	if (r < 1)
  803d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d92:	7f 07                	jg     803d9b <getchar+0x40>
		return -E_EOF;
  803d94:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803d99:	eb 07                	jmp    803da2 <getchar+0x47>
	return c;
  803d9b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803d9f:	0f b6 c0             	movzbl %al,%eax
}
  803da2:	c9                   	leaveq 
  803da3:	c3                   	retq   

0000000000803da4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803da4:	55                   	push   %rbp
  803da5:	48 89 e5             	mov    %rsp,%rbp
  803da8:	48 83 ec 20          	sub    $0x20,%rsp
  803dac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803daf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803db3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803db6:	48 89 d6             	mov    %rdx,%rsi
  803db9:	89 c7                	mov    %eax,%edi
  803dbb:	48 b8 3a 23 80 00 00 	movabs $0x80233a,%rax
  803dc2:	00 00 00 
  803dc5:	ff d0                	callq  *%rax
  803dc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dce:	79 05                	jns    803dd5 <iscons+0x31>
		return r;
  803dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd3:	eb 1a                	jmp    803def <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd9:	8b 10                	mov    (%rax),%edx
  803ddb:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803de2:	00 00 00 
  803de5:	8b 00                	mov    (%rax),%eax
  803de7:	39 c2                	cmp    %eax,%edx
  803de9:	0f 94 c0             	sete   %al
  803dec:	0f b6 c0             	movzbl %al,%eax
}
  803def:	c9                   	leaveq 
  803df0:	c3                   	retq   

0000000000803df1 <opencons>:

int
opencons(void)
{
  803df1:	55                   	push   %rbp
  803df2:	48 89 e5             	mov    %rsp,%rbp
  803df5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803df9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803dfd:	48 89 c7             	mov    %rax,%rdi
  803e00:	48 b8 a2 22 80 00 00 	movabs $0x8022a2,%rax
  803e07:	00 00 00 
  803e0a:	ff d0                	callq  *%rax
  803e0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e13:	79 05                	jns    803e1a <opencons+0x29>
		return r;
  803e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e18:	eb 5b                	jmp    803e75 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1e:	ba 07 04 00 00       	mov    $0x407,%edx
  803e23:	48 89 c6             	mov    %rax,%rsi
  803e26:	bf 00 00 00 00       	mov    $0x0,%edi
  803e2b:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  803e32:	00 00 00 
  803e35:	ff d0                	callq  *%rax
  803e37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3e:	79 05                	jns    803e45 <opencons+0x54>
		return r;
  803e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e43:	eb 30                	jmp    803e75 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e49:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803e50:	00 00 00 
  803e53:	8b 12                	mov    (%rdx),%edx
  803e55:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803e62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e66:	48 89 c7             	mov    %rax,%rdi
  803e69:	48 b8 54 22 80 00 00 	movabs $0x802254,%rax
  803e70:	00 00 00 
  803e73:	ff d0                	callq  *%rax
}
  803e75:	c9                   	leaveq 
  803e76:	c3                   	retq   

0000000000803e77 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e77:	55                   	push   %rbp
  803e78:	48 89 e5             	mov    %rsp,%rbp
  803e7b:	48 83 ec 30          	sub    $0x30,%rsp
  803e7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803e8b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e90:	75 13                	jne    803ea5 <devcons_read+0x2e>
		return 0;
  803e92:	b8 00 00 00 00       	mov    $0x0,%eax
  803e97:	eb 49                	jmp    803ee2 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803e99:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  803ea0:	00 00 00 
  803ea3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803ea5:	48 b8 52 17 80 00 00 	movabs $0x801752,%rax
  803eac:	00 00 00 
  803eaf:	ff d0                	callq  *%rax
  803eb1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb8:	74 df                	je     803e99 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803eba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebe:	79 05                	jns    803ec5 <devcons_read+0x4e>
		return c;
  803ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec3:	eb 1d                	jmp    803ee2 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ec5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ec9:	75 07                	jne    803ed2 <devcons_read+0x5b>
		return 0;
  803ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed0:	eb 10                	jmp    803ee2 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ed5:	89 c2                	mov    %eax,%edx
  803ed7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803edb:	88 10                	mov    %dl,(%rax)
	return 1;
  803edd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803ee2:	c9                   	leaveq 
  803ee3:	c3                   	retq   

0000000000803ee4 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803ee4:	55                   	push   %rbp
  803ee5:	48 89 e5             	mov    %rsp,%rbp
  803ee8:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803eef:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803ef6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803efd:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f0b:	eb 77                	jmp    803f84 <devcons_write+0xa0>
		m = n - tot;
  803f0d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803f14:	89 c2                	mov    %eax,%edx
  803f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f19:	89 d1                	mov    %edx,%ecx
  803f1b:	29 c1                	sub    %eax,%ecx
  803f1d:	89 c8                	mov    %ecx,%eax
  803f1f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803f22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f25:	83 f8 7f             	cmp    $0x7f,%eax
  803f28:	76 07                	jbe    803f31 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803f2a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803f31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f34:	48 63 d0             	movslq %eax,%rdx
  803f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3a:	48 98                	cltq   
  803f3c:	48 89 c1             	mov    %rax,%rcx
  803f3f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803f46:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f4d:	48 89 ce             	mov    %rcx,%rsi
  803f50:	48 89 c7             	mov    %rax,%rdi
  803f53:	48 b8 3a 12 80 00 00 	movabs $0x80123a,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803f5f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f62:	48 63 d0             	movslq %eax,%rdx
  803f65:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803f6c:	48 89 d6             	mov    %rdx,%rsi
  803f6f:	48 89 c7             	mov    %rax,%rdi
  803f72:	48 b8 08 17 80 00 00 	movabs $0x801708,%rax
  803f79:	00 00 00 
  803f7c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803f7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f81:	01 45 fc             	add    %eax,-0x4(%rbp)
  803f84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f87:	48 98                	cltq   
  803f89:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803f90:	0f 82 77 ff ff ff    	jb     803f0d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f99:	c9                   	leaveq 
  803f9a:	c3                   	retq   

0000000000803f9b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803f9b:	55                   	push   %rbp
  803f9c:	48 89 e5             	mov    %rsp,%rbp
  803f9f:	48 83 ec 08          	sub    $0x8,%rsp
  803fa3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fac:	c9                   	leaveq 
  803fad:	c3                   	retq   

0000000000803fae <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fae:	55                   	push   %rbp
  803faf:	48 89 e5             	mov    %rsp,%rbp
  803fb2:	48 83 ec 10          	sub    $0x10,%rsp
  803fb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803fba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803fbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc2:	48 be c8 4c 80 00 00 	movabs $0x804cc8,%rsi
  803fc9:	00 00 00 
  803fcc:	48 89 c7             	mov    %rax,%rdi
  803fcf:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  803fd6:	00 00 00 
  803fd9:	ff d0                	callq  *%rax
	return 0;
  803fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fe0:	c9                   	leaveq 
  803fe1:	c3                   	retq   
	...

0000000000803fe4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803fe4:	55                   	push   %rbp
  803fe5:	48 89 e5             	mov    %rsp,%rbp
  803fe8:	53                   	push   %rbx
  803fe9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803ff0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803ff7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803ffd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  804004:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80400b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804012:	84 c0                	test   %al,%al
  804014:	74 23                	je     804039 <_panic+0x55>
  804016:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80401d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804021:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  804025:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  804029:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80402d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804031:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  804035:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  804039:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804040:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804047:	00 00 00 
  80404a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804051:	00 00 00 
  804054:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804058:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80405f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804066:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80406d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804074:	00 00 00 
  804077:	48 8b 18             	mov    (%rax),%rbx
  80407a:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
  804086:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80408c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  804093:	41 89 c8             	mov    %ecx,%r8d
  804096:	48 89 d1             	mov    %rdx,%rcx
  804099:	48 89 da             	mov    %rbx,%rdx
  80409c:	89 c6                	mov    %eax,%esi
  80409e:	48 bf d0 4c 80 00 00 	movabs $0x804cd0,%rdi
  8040a5:	00 00 00 
  8040a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ad:	49 b9 5b 03 80 00 00 	movabs $0x80035b,%r9
  8040b4:	00 00 00 
  8040b7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8040ba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8040c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8040c8:	48 89 d6             	mov    %rdx,%rsi
  8040cb:	48 89 c7             	mov    %rax,%rdi
  8040ce:	48 b8 af 02 80 00 00 	movabs $0x8002af,%rax
  8040d5:	00 00 00 
  8040d8:	ff d0                	callq  *%rax
	cprintf("\n");
  8040da:	48 bf f3 4c 80 00 00 	movabs $0x804cf3,%rdi
  8040e1:	00 00 00 
  8040e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8040e9:	48 ba 5b 03 80 00 00 	movabs $0x80035b,%rdx
  8040f0:	00 00 00 
  8040f3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8040f5:	cc                   	int3   
  8040f6:	eb fd                	jmp    8040f5 <_panic+0x111>

00000000008040f8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8040f8:	55                   	push   %rbp
  8040f9:	48 89 e5             	mov    %rsp,%rbp
  8040fc:	48 83 ec 20          	sub    $0x20,%rsp
  804100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804104:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80410b:	00 00 00 
  80410e:	48 8b 00             	mov    (%rax),%rax
  804111:	48 85 c0             	test   %rax,%rax
  804114:	0f 85 8e 00 00 00    	jne    8041a8 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80411a:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804128:	48 b8 d4 17 80 00 00 	movabs $0x8017d4,%rax
  80412f:	00 00 00 
  804132:	ff d0                	callq  *%rax
  804134:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804137:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80413b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80413e:	ba 07 00 00 00       	mov    $0x7,%edx
  804143:	48 89 ce             	mov    %rcx,%rsi
  804146:	89 c7                	mov    %eax,%edi
  804148:	48 b8 50 18 80 00 00 	movabs $0x801850,%rax
  80414f:	00 00 00 
  804152:	ff d0                	callq  *%rax
  804154:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804157:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80415b:	74 30                	je     80418d <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  80415d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804160:	89 c1                	mov    %eax,%ecx
  804162:	48 ba f8 4c 80 00 00 	movabs $0x804cf8,%rdx
  804169:	00 00 00 
  80416c:	be 24 00 00 00       	mov    $0x24,%esi
  804171:	48 bf 2f 4d 80 00 00 	movabs $0x804d2f,%rdi
  804178:	00 00 00 
  80417b:	b8 00 00 00 00       	mov    $0x0,%eax
  804180:	49 b8 e4 3f 80 00 00 	movabs $0x803fe4,%r8
  804187:	00 00 00 
  80418a:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80418d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804190:	48 be bc 41 80 00 00 	movabs $0x8041bc,%rsi
  804197:	00 00 00 
  80419a:	89 c7                	mov    %eax,%edi
  80419c:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  8041a3:	00 00 00 
  8041a6:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8041a8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041af:	00 00 00 
  8041b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041b6:	48 89 10             	mov    %rdx,(%rax)
}
  8041b9:	c9                   	leaveq 
  8041ba:	c3                   	retq   
	...

00000000008041bc <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8041bc:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8041bf:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  8041c6:	00 00 00 
	call *%rax
  8041c9:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  8041cb:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  8041cf:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  8041d3:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  8041d6:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8041dd:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8041de:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8041e3:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8041e6:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8041e7:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8041ea:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8041f1:	00 08 
		POPA_						// copy the register contents to the registers
  8041f3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8041f7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8041fc:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804201:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804206:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80420b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804210:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804215:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80421a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80421f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804224:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804229:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80422e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804233:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804238:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80423d:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804241:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804245:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804246:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804247:	c3                   	retq   

0000000000804248 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804248:	55                   	push   %rbp
  804249:	48 89 e5             	mov    %rsp,%rbp
  80424c:	48 83 ec 30          	sub    $0x30,%rsp
  804250:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804258:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  80425c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804261:	74 18                	je     80427b <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  804263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804267:	48 89 c7             	mov    %rax,%rdi
  80426a:	48 b8 79 1a 80 00 00 	movabs $0x801a79,%rax
  804271:	00 00 00 
  804274:	ff d0                	callq  *%rax
  804276:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804279:	eb 19                	jmp    804294 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  80427b:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  804282:	00 00 00 
  804285:	48 b8 79 1a 80 00 00 	movabs $0x801a79,%rax
  80428c:	00 00 00 
  80428f:	ff d0                	callq  *%rax
  804291:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804298:	79 19                	jns    8042b3 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80429a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80429e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8042a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042a8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8042ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b1:	eb 53                	jmp    804306 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8042b3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8042b8:	74 19                	je     8042d3 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  8042ba:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042c1:	00 00 00 
  8042c4:	48 8b 00             	mov    (%rax),%rax
  8042c7:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8042cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042d1:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  8042d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8042d8:	74 19                	je     8042f3 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8042da:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042e1:	00 00 00 
  8042e4:	48 8b 00             	mov    (%rax),%rax
  8042e7:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8042ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8042f3:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8042fa:	00 00 00 
  8042fd:	48 8b 00             	mov    (%rax),%rax
  804300:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804306:	c9                   	leaveq 
  804307:	c3                   	retq   

0000000000804308 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804308:	55                   	push   %rbp
  804309:	48 89 e5             	mov    %rsp,%rbp
  80430c:	48 83 ec 30          	sub    $0x30,%rsp
  804310:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804313:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804316:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80431a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  80431d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804324:	e9 96 00 00 00       	jmpq   8043bf <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804329:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80432e:	74 20                	je     804350 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  804330:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804333:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80433a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80433d:	89 c7                	mov    %eax,%edi
  80433f:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  804346:	00 00 00 
  804349:	ff d0                	callq  *%rax
  80434b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80434e:	eb 2d                	jmp    80437d <ipc_send+0x75>
		else if(pg==NULL)
  804350:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804355:	75 26                	jne    80437d <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804357:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80435a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80435d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804362:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804369:	00 00 00 
  80436c:	89 c7                	mov    %eax,%edi
  80436e:	48 b8 24 1a 80 00 00 	movabs $0x801a24,%rax
  804375:	00 00 00 
  804378:	ff d0                	callq  *%rax
  80437a:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  80437d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804381:	79 30                	jns    8043b3 <ipc_send+0xab>
  804383:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804387:	74 2a                	je     8043b3 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804389:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
  804390:	00 00 00 
  804393:	be 40 00 00 00       	mov    $0x40,%esi
  804398:	48 bf 55 4d 80 00 00 	movabs $0x804d55,%rdi
  80439f:	00 00 00 
  8043a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8043a7:	48 b9 e4 3f 80 00 00 	movabs $0x803fe4,%rcx
  8043ae:	00 00 00 
  8043b1:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8043b3:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  8043ba:	00 00 00 
  8043bd:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  8043bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043c3:	0f 85 60 ff ff ff    	jne    804329 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  8043c9:	c9                   	leaveq 
  8043ca:	c3                   	retq   

00000000008043cb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8043cb:	55                   	push   %rbp
  8043cc:	48 89 e5             	mov    %rsp,%rbp
  8043cf:	48 83 ec 18          	sub    $0x18,%rsp
  8043d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8043d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8043dd:	eb 5e                	jmp    80443d <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8043df:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8043e6:	00 00 00 
  8043e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ec:	48 63 d0             	movslq %eax,%rdx
  8043ef:	48 89 d0             	mov    %rdx,%rax
  8043f2:	48 c1 e0 03          	shl    $0x3,%rax
  8043f6:	48 01 d0             	add    %rdx,%rax
  8043f9:	48 c1 e0 05          	shl    $0x5,%rax
  8043fd:	48 01 c8             	add    %rcx,%rax
  804400:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804406:	8b 00                	mov    (%rax),%eax
  804408:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80440b:	75 2c                	jne    804439 <ipc_find_env+0x6e>
			return envs[i].env_id;
  80440d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804414:	00 00 00 
  804417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80441a:	48 63 d0             	movslq %eax,%rdx
  80441d:	48 89 d0             	mov    %rdx,%rax
  804420:	48 c1 e0 03          	shl    $0x3,%rax
  804424:	48 01 d0             	add    %rdx,%rax
  804427:	48 c1 e0 05          	shl    $0x5,%rax
  80442b:	48 01 c8             	add    %rcx,%rax
  80442e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804434:	8b 40 08             	mov    0x8(%rax),%eax
  804437:	eb 12                	jmp    80444b <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804439:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80443d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804444:	7e 99                	jle    8043df <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80444b:	c9                   	leaveq 
  80444c:	c3                   	retq   
  80444d:	00 00                	add    %al,(%rax)
	...

0000000000804450 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804450:	55                   	push   %rbp
  804451:	48 89 e5             	mov    %rsp,%rbp
  804454:	48 83 ec 18          	sub    $0x18,%rsp
  804458:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80445c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804460:	48 89 c2             	mov    %rax,%rdx
  804463:	48 c1 ea 15          	shr    $0x15,%rdx
  804467:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80446e:	01 00 00 
  804471:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804475:	83 e0 01             	and    $0x1,%eax
  804478:	48 85 c0             	test   %rax,%rax
  80447b:	75 07                	jne    804484 <pageref+0x34>
		return 0;
  80447d:	b8 00 00 00 00       	mov    $0x0,%eax
  804482:	eb 53                	jmp    8044d7 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804484:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804488:	48 89 c2             	mov    %rax,%rdx
  80448b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80448f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804496:	01 00 00 
  804499:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80449d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a5:	83 e0 01             	and    $0x1,%eax
  8044a8:	48 85 c0             	test   %rax,%rax
  8044ab:	75 07                	jne    8044b4 <pageref+0x64>
		return 0;
  8044ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b2:	eb 23                	jmp    8044d7 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8044b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b8:	48 89 c2             	mov    %rax,%rdx
  8044bb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8044bf:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8044c6:	00 00 00 
  8044c9:	48 c1 e2 04          	shl    $0x4,%rdx
  8044cd:	48 01 d0             	add    %rdx,%rax
  8044d0:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8044d4:	0f b7 c0             	movzwl %ax,%eax
}
  8044d7:	c9                   	leaveq 
  8044d8:	c3                   	retq   
