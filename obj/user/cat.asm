
obj/user/cat.debug:     file format elf64-x86-64


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
  80003c:	e8 ef 01 00 00       	callq  800230 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800053:	eb 68                	jmp    8000bd <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800055:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800059:	48 89 c2             	mov    %rax,%rdx
  80005c:	48 be 60 70 80 00 00 	movabs $0x807060,%rsi
  800063:	00 00 00 
  800066:	bf 01 00 00 00       	mov    $0x1,%edi
  80006b:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax
  800077:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80007a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007d:	48 98                	cltq   
  80007f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800083:	74 38                	je     8000bd <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800085:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800088:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008c:	41 89 d0             	mov    %edx,%r8d
  80008f:	48 89 c1             	mov    %rax,%rcx
  800092:	48 ba a0 40 80 00 00 	movabs $0x8040a0,%rdx
  800099:	00 00 00 
  80009c:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a1:	48 bf bb 40 80 00 00 	movabs $0x8040bb,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b9 f8 02 80 00 00 	movabs $0x8002f8,%r9
  8000b7:	00 00 00 
  8000ba:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000c0:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c5:	48 be 60 70 80 00 00 	movabs $0x807060,%rsi
  8000cc:	00 00 00 
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax
  8000dd:	48 98                	cltq   
  8000df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e3:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e8:	0f 8f 67 ff ff ff    	jg     800055 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ee:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f3:	79 39                	jns    80012e <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fd:	49 89 d0             	mov    %rdx,%r8
  800100:	48 89 c1             	mov    %rax,%rcx
  800103:	48 ba c6 40 80 00 00 	movabs $0x8040c6,%rdx
  80010a:	00 00 00 
  80010d:	be 0f 00 00 00       	mov    $0xf,%esi
  800112:	48 bf bb 40 80 00 00 	movabs $0x8040bb,%rdi
  800119:	00 00 00 
  80011c:	b8 00 00 00 00       	mov    $0x0,%eax
  800121:	49 b9 f8 02 80 00 00 	movabs $0x8002f8,%r9
  800128:	00 00 00 
  80012b:	41 ff d1             	callq  *%r9
}
  80012e:	c9                   	leaveq 
  80012f:	c3                   	retq   

0000000000800130 <umain>:

void
umain(int argc, char **argv)
{
  800130:	55                   	push   %rbp
  800131:	48 89 e5             	mov    %rsp,%rbp
  800134:	48 83 ec 20          	sub    $0x20,%rsp
  800138:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80013b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800146:	00 00 00 
  800149:	48 ba db 40 80 00 00 	movabs $0x8040db,%rdx
  800150:	00 00 00 
  800153:	48 89 10             	mov    %rdx,(%rax)
	if (argc == 1)
  800156:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4c>
		cat(0, "<stdin>");
  80015c:	48 be df 40 80 00 00 	movabs $0x8040df,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 b1 00 00 00       	jmpq   80022d <umain+0xfd>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  800183:	e9 99 00 00 00       	jmpq   800221 <umain+0xf1>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 c1 e0 03          	shl    $0x3,%rax
  800191:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800195:	48 8b 00             	mov    (%rax),%rax
  800198:	be 00 00 00 00       	mov    $0x0,%esi
  80019d:	48 89 c7             	mov    %rax,%rdi
  8001a0:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
  8001ac:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  8001af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8001b3:	79 33                	jns    8001e8 <umain+0xb8>
				printf("can't open %s: %e\n", argv[i], f);
  8001b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b8:	48 98                	cltq   
  8001ba:	48 c1 e0 03          	shl    $0x3,%rax
  8001be:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8001c2:	48 8b 00             	mov    (%rax),%rax
  8001c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8001c8:	48 89 c6             	mov    %rax,%rsi
  8001cb:	48 bf e7 40 80 00 00 	movabs $0x8040e7,%rdi
  8001d2:	00 00 00 
  8001d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001da:	48 b9 c0 2c 80 00 00 	movabs $0x802cc0,%rcx
  8001e1:	00 00 00 
  8001e4:	ff d1                	callq  *%rcx
  8001e6:	eb 35                	jmp    80021d <umain+0xed>
			else {
				cat(f, argv[i]);
  8001e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001eb:	48 98                	cltq   
  8001ed:	48 c1 e0 03          	shl    $0x3,%rax
  8001f1:	48 03 45 e0          	add    -0x20(%rbp),%rax
  8001f5:	48 8b 10             	mov    (%rax),%rdx
  8001f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001fb:	48 89 d6             	mov    %rdx,%rsi
  8001fe:	89 c7                	mov    %eax,%edi
  800200:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
				close(f);
  80020c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80020f:	89 c7                	mov    %eax,%edi
  800211:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80021d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800221:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800224:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800227:	0f 8c 5b ff ff ff    	jl     800188 <umain+0x58>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80022d:	c9                   	leaveq 
  80022e:	c3                   	retq   
	...

0000000000800230 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 10          	sub    $0x10,%rsp
  800238:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80023b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80023f:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  800246:	00 00 00 
  800249:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800250:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  800257:	00 00 00 
  80025a:	ff d0                	callq  *%rax
  80025c:	48 98                	cltq   
  80025e:	48 89 c2             	mov    %rax,%rdx
  800261:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800267:	48 89 d0             	mov    %rdx,%rax
  80026a:	48 c1 e0 03          	shl    $0x3,%rax
  80026e:	48 01 d0             	add    %rdx,%rax
  800271:	48 c1 e0 05          	shl    $0x5,%rax
  800275:	48 89 c2             	mov    %rax,%rdx
  800278:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80027f:	00 00 00 
  800282:	48 01 c2             	add    %rax,%rdx
  800285:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  80028c:	00 00 00 
  80028f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800296:	7e 14                	jle    8002ac <libmain+0x7c>
		binaryname = argv[0];
  800298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029c:	48 8b 10             	mov    (%rax),%rdx
  80029f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002a6:	00 00 00 
  8002a9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b3:	48 89 d6             	mov    %rdx,%rsi
  8002b6:	89 c7                	mov    %eax,%edi
  8002b8:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8002bf:	00 00 00 
  8002c2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002c4:	48 b8 d4 02 80 00 00 	movabs $0x8002d4,%rax
  8002cb:	00 00 00 
  8002ce:	ff d0                	callq  *%rax
}
  8002d0:	c9                   	leaveq 
  8002d1:	c3                   	retq   
	...

00000000008002d4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d4:	55                   	push   %rbp
  8002d5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002d8:	48 b8 a9 20 80 00 00 	movabs $0x8020a9,%rax
  8002df:	00 00 00 
  8002e2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002e9:	48 b8 68 19 80 00 00 	movabs $0x801968,%rax
  8002f0:	00 00 00 
  8002f3:	ff d0                	callq  *%rax
}
  8002f5:	5d                   	pop    %rbp
  8002f6:	c3                   	retq   
	...

00000000008002f8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002f8:	55                   	push   %rbp
  8002f9:	48 89 e5             	mov    %rsp,%rbp
  8002fc:	53                   	push   %rbx
  8002fd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800304:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800311:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800318:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80031f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800326:	84 c0                	test   %al,%al
  800328:	74 23                	je     80034d <_panic+0x55>
  80032a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800331:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800335:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800339:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80033d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800341:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800345:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800349:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80034d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800354:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035b:	00 00 00 
  80035e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800365:	00 00 00 
  800368:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80036c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800373:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800381:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800388:	00 00 00 
  80038b:	48 8b 18             	mov    (%rax),%rbx
  80038e:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  800395:	00 00 00 
  800398:	ff d0                	callq  *%rax
  80039a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003a7:	41 89 c8             	mov    %ecx,%r8d
  8003aa:	48 89 d1             	mov    %rdx,%rcx
  8003ad:	48 89 da             	mov    %rbx,%rdx
  8003b0:	89 c6                	mov    %eax,%esi
  8003b2:	48 bf 08 41 80 00 00 	movabs $0x804108,%rdi
  8003b9:	00 00 00 
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	49 b9 33 05 80 00 00 	movabs $0x800533,%r9
  8003c8:	00 00 00 
  8003cb:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ce:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003dc:	48 89 d6             	mov    %rdx,%rsi
  8003df:	48 89 c7             	mov    %rax,%rdi
  8003e2:	48 b8 87 04 80 00 00 	movabs $0x800487,%rax
  8003e9:	00 00 00 
  8003ec:	ff d0                	callq  *%rax
	cprintf("\n");
  8003ee:	48 bf 2b 41 80 00 00 	movabs $0x80412b,%rdi
  8003f5:	00 00 00 
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fd:	48 ba 33 05 80 00 00 	movabs $0x800533,%rdx
  800404:	00 00 00 
  800407:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800409:	cc                   	int3   
  80040a:	eb fd                	jmp    800409 <_panic+0x111>

000000000080040c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80040c:	55                   	push   %rbp
  80040d:	48 89 e5             	mov    %rsp,%rbp
  800410:	48 83 ec 10          	sub    $0x10,%rsp
  800414:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800417:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80041b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80041f:	8b 00                	mov    (%rax),%eax
  800421:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800424:	89 d6                	mov    %edx,%esi
  800426:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80042a:	48 63 d0             	movslq %eax,%rdx
  80042d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800432:	8d 50 01             	lea    0x1(%rax),%edx
  800435:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800439:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80043b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80043f:	8b 00                	mov    (%rax),%eax
  800441:	3d ff 00 00 00       	cmp    $0xff,%eax
  800446:	75 2c                	jne    800474 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800448:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044c:	8b 00                	mov    (%rax),%eax
  80044e:	48 98                	cltq   
  800450:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800454:	48 83 c2 08          	add    $0x8,%rdx
  800458:	48 89 c6             	mov    %rax,%rsi
  80045b:	48 89 d7             	mov    %rdx,%rdi
  80045e:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800465:	00 00 00 
  800468:	ff d0                	callq  *%rax
		b->idx = 0;
  80046a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80046e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800474:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800478:	8b 40 04             	mov    0x4(%rax),%eax
  80047b:	8d 50 01             	lea    0x1(%rax),%edx
  80047e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800482:	89 50 04             	mov    %edx,0x4(%rax)
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   

0000000000800487 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800492:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800499:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8004a0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004ae:	48 8b 0a             	mov    (%rdx),%rcx
  8004b1:	48 89 08             	mov    %rcx,(%rax)
  8004b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004cb:	00 00 00 
	b.cnt = 0;
  8004ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004d8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004df:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ed:	48 89 c6             	mov    %rax,%rsi
  8004f0:	48 bf 0c 04 80 00 00 	movabs $0x80040c,%rdi
  8004f7:	00 00 00 
  8004fa:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800501:	00 00 00 
  800504:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800506:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80050c:	48 98                	cltq   
  80050e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800515:	48 83 c2 08          	add    $0x8,%rdx
  800519:	48 89 c6             	mov    %rax,%rsi
  80051c:	48 89 d7             	mov    %rdx,%rdi
  80051f:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800526:	00 00 00 
  800529:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   

0000000000800533 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800533:	55                   	push   %rbp
  800534:	48 89 e5             	mov    %rsp,%rbp
  800537:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80053e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800545:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80054c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800553:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800561:	84 c0                	test   %al,%al
  800563:	74 20                	je     800585 <cprintf+0x52>
  800565:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800569:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800571:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800575:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800579:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800581:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800585:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80058c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800593:	00 00 00 
  800596:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059d:	00 00 00 
  8005a0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ab:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005b9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c7:	48 8b 0a             	mov    (%rdx),%rcx
  8005ca:	48 89 08             	mov    %rcx,(%rax)
  8005cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005dd:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005eb:	48 89 d6             	mov    %rdx,%rsi
  8005ee:	48 89 c7             	mov    %rax,%rdi
  8005f1:	48 b8 87 04 80 00 00 	movabs $0x800487,%rax
  8005f8:	00 00 00 
  8005fb:	ff d0                	callq  *%rax
  8005fd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800603:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800609:	c9                   	leaveq 
  80060a:	c3                   	retq   
	...

000000000080060c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060c:	55                   	push   %rbp
  80060d:	48 89 e5             	mov    %rsp,%rbp
  800610:	48 83 ec 30          	sub    $0x30,%rsp
  800614:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800618:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80061c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800620:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800623:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800627:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80062e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800632:	77 52                	ja     800686 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800634:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800637:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80063e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	ba 00 00 00 00       	mov    $0x0,%edx
  80064b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80064f:	48 89 c2             	mov    %rax,%rdx
  800652:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800655:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800658:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80065c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800660:	41 89 f9             	mov    %edi,%r9d
  800663:	48 89 c7             	mov    %rax,%rdi
  800666:	48 b8 0c 06 80 00 00 	movabs $0x80060c,%rax
  80066d:	00 00 00 
  800670:	ff d0                	callq  *%rax
  800672:	eb 1c                	jmp    800690 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800674:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800678:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80067b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80067f:	48 89 d6             	mov    %rdx,%rsi
  800682:	89 c7                	mov    %eax,%edi
  800684:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800686:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80068e:	7f e4                	jg     800674 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800690:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
  80069c:	48 f7 f1             	div    %rcx
  80069f:	48 89 d0             	mov    %rdx,%rax
  8006a2:	48 ba 08 43 80 00 00 	movabs $0x804308,%rdx
  8006a9:	00 00 00 
  8006ac:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006b0:	0f be c0             	movsbl %al,%eax
  8006b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006bb:	48 89 d6             	mov    %rdx,%rsi
  8006be:	89 c7                	mov    %eax,%edi
  8006c0:	ff d1                	callq  *%rcx
}
  8006c2:	c9                   	leaveq 
  8006c3:	c3                   	retq   

00000000008006c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c4:	55                   	push   %rbp
  8006c5:	48 89 e5             	mov    %rsp,%rbp
  8006c8:	48 83 ec 20          	sub    $0x20,%rsp
  8006cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006d7:	7e 52                	jle    80072b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	8b 00                	mov    (%rax),%eax
  8006df:	83 f8 30             	cmp    $0x30,%eax
  8006e2:	73 24                	jae    800708 <getuint+0x44>
  8006e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f0:	8b 00                	mov    (%rax),%eax
  8006f2:	89 c0                	mov    %eax,%eax
  8006f4:	48 01 d0             	add    %rdx,%rax
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	8b 12                	mov    (%rdx),%edx
  8006fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800700:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800704:	89 0a                	mov    %ecx,(%rdx)
  800706:	eb 17                	jmp    80071f <getuint+0x5b>
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800710:	48 89 d0             	mov    %rdx,%rax
  800713:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071f:	48 8b 00             	mov    (%rax),%rax
  800722:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800726:	e9 a3 00 00 00       	jmpq   8007ce <getuint+0x10a>
	else if (lflag)
  80072b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80072f:	74 4f                	je     800780 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800735:	8b 00                	mov    (%rax),%eax
  800737:	83 f8 30             	cmp    $0x30,%eax
  80073a:	73 24                	jae    800760 <getuint+0x9c>
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800748:	8b 00                	mov    (%rax),%eax
  80074a:	89 c0                	mov    %eax,%eax
  80074c:	48 01 d0             	add    %rdx,%rax
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	8b 12                	mov    (%rdx),%edx
  800755:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800758:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075c:	89 0a                	mov    %ecx,(%rdx)
  80075e:	eb 17                	jmp    800777 <getuint+0xb3>
  800760:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800764:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800768:	48 89 d0             	mov    %rdx,%rax
  80076b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80076f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800773:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800777:	48 8b 00             	mov    (%rax),%rax
  80077a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80077e:	eb 4e                	jmp    8007ce <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800780:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800784:	8b 00                	mov    (%rax),%eax
  800786:	83 f8 30             	cmp    $0x30,%eax
  800789:	73 24                	jae    8007af <getuint+0xeb>
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800793:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800797:	8b 00                	mov    (%rax),%eax
  800799:	89 c0                	mov    %eax,%eax
  80079b:	48 01 d0             	add    %rdx,%rax
  80079e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a2:	8b 12                	mov    (%rdx),%edx
  8007a4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	89 0a                	mov    %ecx,(%rdx)
  8007ad:	eb 17                	jmp    8007c6 <getuint+0x102>
  8007af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b7:	48 89 d0             	mov    %rdx,%rax
  8007ba:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	89 c0                	mov    %eax,%eax
  8007ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d2:	c9                   	leaveq 
  8007d3:	c3                   	retq   

00000000008007d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d4:	55                   	push   %rbp
  8007d5:	48 89 e5             	mov    %rsp,%rbp
  8007d8:	48 83 ec 20          	sub    $0x20,%rsp
  8007dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e7:	7e 52                	jle    80083b <getint+0x67>
		x=va_arg(*ap, long long);
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	83 f8 30             	cmp    $0x30,%eax
  8007f2:	73 24                	jae    800818 <getint+0x44>
  8007f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800800:	8b 00                	mov    (%rax),%eax
  800802:	89 c0                	mov    %eax,%eax
  800804:	48 01 d0             	add    %rdx,%rax
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	8b 12                	mov    (%rdx),%edx
  80080d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800814:	89 0a                	mov    %ecx,(%rdx)
  800816:	eb 17                	jmp    80082f <getint+0x5b>
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800820:	48 89 d0             	mov    %rdx,%rax
  800823:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082f:	48 8b 00             	mov    (%rax),%rax
  800832:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800836:	e9 a3 00 00 00       	jmpq   8008de <getint+0x10a>
	else if (lflag)
  80083b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083f:	74 4f                	je     800890 <getint+0xbc>
		x=va_arg(*ap, long);
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	8b 00                	mov    (%rax),%eax
  800847:	83 f8 30             	cmp    $0x30,%eax
  80084a:	73 24                	jae    800870 <getint+0x9c>
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800858:	8b 00                	mov    (%rax),%eax
  80085a:	89 c0                	mov    %eax,%eax
  80085c:	48 01 d0             	add    %rdx,%rax
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	8b 12                	mov    (%rdx),%edx
  800865:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800868:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086c:	89 0a                	mov    %ecx,(%rdx)
  80086e:	eb 17                	jmp    800887 <getint+0xb3>
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800878:	48 89 d0             	mov    %rdx,%rax
  80087b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800887:	48 8b 00             	mov    (%rax),%rax
  80088a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088e:	eb 4e                	jmp    8008de <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800894:	8b 00                	mov    (%rax),%eax
  800896:	83 f8 30             	cmp    $0x30,%eax
  800899:	73 24                	jae    8008bf <getint+0xeb>
  80089b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a7:	8b 00                	mov    (%rax),%eax
  8008a9:	89 c0                	mov    %eax,%eax
  8008ab:	48 01 d0             	add    %rdx,%rax
  8008ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b2:	8b 12                	mov    (%rdx),%edx
  8008b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	89 0a                	mov    %ecx,(%rdx)
  8008bd:	eb 17                	jmp    8008d6 <getint+0x102>
  8008bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c7:	48 89 d0             	mov    %rdx,%rax
  8008ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	48 98                	cltq   
  8008da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e2:	c9                   	leaveq 
  8008e3:	c3                   	retq   

00000000008008e4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e4:	55                   	push   %rbp
  8008e5:	48 89 e5             	mov    %rsp,%rbp
  8008e8:	41 54                	push   %r12
  8008ea:	53                   	push   %rbx
  8008eb:	48 83 ec 60          	sub    $0x60,%rsp
  8008ef:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008f7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008fb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008ff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800903:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800907:	48 8b 0a             	mov    (%rdx),%rcx
  80090a:	48 89 08             	mov    %rcx,(%rax)
  80090d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800911:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800915:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800919:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091d:	eb 17                	jmp    800936 <vprintfmt+0x52>
			if (ch == '\0')
  80091f:	85 db                	test   %ebx,%ebx
  800921:	0f 84 d7 04 00 00    	je     800dfe <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800927:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80092b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80092f:	48 89 c6             	mov    %rax,%rsi
  800932:	89 df                	mov    %ebx,%edi
  800934:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800936:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093a:	0f b6 00             	movzbl (%rax),%eax
  80093d:	0f b6 d8             	movzbl %al,%ebx
  800940:	83 fb 25             	cmp    $0x25,%ebx
  800943:	0f 95 c0             	setne  %al
  800946:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80094b:	84 c0                	test   %al,%al
  80094d:	75 d0                	jne    80091f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800953:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80095a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800961:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800968:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80096f:	eb 04                	jmp    800975 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800971:	90                   	nop
  800972:	eb 01                	jmp    800975 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800974:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800975:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800979:	0f b6 00             	movzbl (%rax),%eax
  80097c:	0f b6 d8             	movzbl %al,%ebx
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800986:	83 e8 23             	sub    $0x23,%eax
  800989:	83 f8 55             	cmp    $0x55,%eax
  80098c:	0f 87 38 04 00 00    	ja     800dca <vprintfmt+0x4e6>
  800992:	89 c0                	mov    %eax,%eax
  800994:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80099b:	00 
  80099c:	48 b8 30 43 80 00 00 	movabs $0x804330,%rax
  8009a3:	00 00 00 
  8009a6:	48 01 d0             	add    %rdx,%rax
  8009a9:	48 8b 00             	mov    (%rax),%rax
  8009ac:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ae:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009b2:	eb c1                	jmp    800975 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b8:	eb bb                	jmp    800975 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ba:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009c1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c4:	89 d0                	mov    %edx,%eax
  8009c6:	c1 e0 02             	shl    $0x2,%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	01 c0                	add    %eax,%eax
  8009cd:	01 d8                	add    %ebx,%eax
  8009cf:	83 e8 30             	sub    $0x30,%eax
  8009d2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d9:	0f b6 00             	movzbl (%rax),%eax
  8009dc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009df:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e2:	7e 63                	jle    800a47 <vprintfmt+0x163>
  8009e4:	83 fb 39             	cmp    $0x39,%ebx
  8009e7:	7f 5e                	jg     800a47 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ee:	eb d1                	jmp    8009c1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8009f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f3:	83 f8 30             	cmp    $0x30,%eax
  8009f6:	73 17                	jae    800a0f <vprintfmt+0x12b>
  8009f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ff:	89 c0                	mov    %eax,%eax
  800a01:	48 01 d0             	add    %rdx,%rax
  800a04:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a07:	83 c2 08             	add    $0x8,%edx
  800a0a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0d:	eb 0f                	jmp    800a1e <vprintfmt+0x13a>
  800a0f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a13:	48 89 d0             	mov    %rdx,%rax
  800a16:	48 83 c2 08          	add    $0x8,%rdx
  800a1a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a23:	eb 23                	jmp    800a48 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a25:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a29:	0f 89 42 ff ff ff    	jns    800971 <vprintfmt+0x8d>
				width = 0;
  800a2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a36:	e9 36 ff ff ff       	jmpq   800971 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a3b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a42:	e9 2e ff ff ff       	jmpq   800975 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a47:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a48:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4c:	0f 89 22 ff ff ff    	jns    800974 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a52:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a55:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a58:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a5f:	e9 10 ff ff ff       	jmpq   800974 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a64:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a68:	e9 08 ff ff ff       	jmpq   800975 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x1a8>
  800a75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8a:	eb 0f                	jmp    800a9b <vprintfmt+0x1b7>
  800a8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 83 c2 08          	add    $0x8,%rdx
  800a97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9b:	8b 00                	mov    (%rax),%eax
  800a9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aa1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800aa5:	48 89 d6             	mov    %rdx,%rsi
  800aa8:	89 c7                	mov    %eax,%edi
  800aaa:	ff d1                	callq  *%rcx
			break;
  800aac:	e9 47 03 00 00       	jmpq   800df8 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ab1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab4:	83 f8 30             	cmp    $0x30,%eax
  800ab7:	73 17                	jae    800ad0 <vprintfmt+0x1ec>
  800ab9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac0:	89 c0                	mov    %eax,%eax
  800ac2:	48 01 d0             	add    %rdx,%rax
  800ac5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac8:	83 c2 08             	add    $0x8,%edx
  800acb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ace:	eb 0f                	jmp    800adf <vprintfmt+0x1fb>
  800ad0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad4:	48 89 d0             	mov    %rdx,%rax
  800ad7:	48 83 c2 08          	add    $0x8,%rdx
  800adb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800adf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	79 02                	jns    800ae7 <vprintfmt+0x203>
				err = -err;
  800ae5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae7:	83 fb 10             	cmp    $0x10,%ebx
  800aea:	7f 16                	jg     800b02 <vprintfmt+0x21e>
  800aec:	48 b8 80 42 80 00 00 	movabs $0x804280,%rax
  800af3:	00 00 00 
  800af6:	48 63 d3             	movslq %ebx,%rdx
  800af9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800afd:	4d 85 e4             	test   %r12,%r12
  800b00:	75 2e                	jne    800b30 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b02:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0a:	89 d9                	mov    %ebx,%ecx
  800b0c:	48 ba 19 43 80 00 00 	movabs $0x804319,%rdx
  800b13:	00 00 00 
  800b16:	48 89 c7             	mov    %rax,%rdi
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1e:	49 b8 08 0e 80 00 00 	movabs $0x800e08,%r8
  800b25:	00 00 00 
  800b28:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2b:	e9 c8 02 00 00       	jmpq   800df8 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b38:	4c 89 e1             	mov    %r12,%rcx
  800b3b:	48 ba 22 43 80 00 00 	movabs $0x804322,%rdx
  800b42:	00 00 00 
  800b45:	48 89 c7             	mov    %rax,%rdi
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	49 b8 08 0e 80 00 00 	movabs $0x800e08,%r8
  800b54:	00 00 00 
  800b57:	41 ff d0             	callq  *%r8
			break;
  800b5a:	e9 99 02 00 00       	jmpq   800df8 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b62:	83 f8 30             	cmp    $0x30,%eax
  800b65:	73 17                	jae    800b7e <vprintfmt+0x29a>
  800b67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6e:	89 c0                	mov    %eax,%eax
  800b70:	48 01 d0             	add    %rdx,%rax
  800b73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b76:	83 c2 08             	add    $0x8,%edx
  800b79:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b7c:	eb 0f                	jmp    800b8d <vprintfmt+0x2a9>
  800b7e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b82:	48 89 d0             	mov    %rdx,%rax
  800b85:	48 83 c2 08          	add    $0x8,%rdx
  800b89:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8d:	4c 8b 20             	mov    (%rax),%r12
  800b90:	4d 85 e4             	test   %r12,%r12
  800b93:	75 0a                	jne    800b9f <vprintfmt+0x2bb>
				p = "(null)";
  800b95:	49 bc 25 43 80 00 00 	movabs $0x804325,%r12
  800b9c:	00 00 00 
			if (width > 0 && padc != '-')
  800b9f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba3:	7e 7a                	jle    800c1f <vprintfmt+0x33b>
  800ba5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba9:	74 74                	je     800c1f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bab:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bae:	48 98                	cltq   
  800bb0:	48 89 c6             	mov    %rax,%rsi
  800bb3:	4c 89 e7             	mov    %r12,%rdi
  800bb6:	48 b8 b2 10 80 00 00 	movabs $0x8010b2,%rax
  800bbd:	00 00 00 
  800bc0:	ff d0                	callq  *%rax
  800bc2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc5:	eb 17                	jmp    800bde <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bc7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcf:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bd3:	48 89 d6             	mov    %rdx,%rsi
  800bd6:	89 c7                	mov    %eax,%edi
  800bd8:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bda:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be2:	7f e3                	jg     800bc7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be4:	eb 39                	jmp    800c1f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800be6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bea:	74 1e                	je     800c0a <vprintfmt+0x326>
  800bec:	83 fb 1f             	cmp    $0x1f,%ebx
  800bef:	7e 05                	jle    800bf6 <vprintfmt+0x312>
  800bf1:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf4:	7e 14                	jle    800c0a <vprintfmt+0x326>
					putch('?', putdat);
  800bf6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bfa:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bfe:	48 89 c6             	mov    %rax,%rsi
  800c01:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c06:	ff d2                	callq  *%rdx
  800c08:	eb 0f                	jmp    800c19 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c0a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c0e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c12:	48 89 c6             	mov    %rax,%rsi
  800c15:	89 df                	mov    %ebx,%edi
  800c17:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c19:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c1d:	eb 01                	jmp    800c20 <vprintfmt+0x33c>
  800c1f:	90                   	nop
  800c20:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c25:	0f be d8             	movsbl %al,%ebx
  800c28:	85 db                	test   %ebx,%ebx
  800c2a:	0f 95 c0             	setne  %al
  800c2d:	49 83 c4 01          	add    $0x1,%r12
  800c31:	84 c0                	test   %al,%al
  800c33:	74 28                	je     800c5d <vprintfmt+0x379>
  800c35:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c39:	78 ab                	js     800be6 <vprintfmt+0x302>
  800c3b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c3f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c43:	79 a1                	jns    800be6 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c45:	eb 16                	jmp    800c5d <vprintfmt+0x379>
				putch(' ', putdat);
  800c47:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c4b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c4f:	48 89 c6             	mov    %rax,%rsi
  800c52:	bf 20 00 00 00       	mov    $0x20,%edi
  800c57:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c59:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c5d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c61:	7f e4                	jg     800c47 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c63:	e9 90 01 00 00       	jmpq   800df8 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6c:	be 03 00 00 00       	mov    $0x3,%esi
  800c71:	48 89 c7             	mov    %rax,%rdi
  800c74:	48 b8 d4 07 80 00 00 	movabs $0x8007d4,%rax
  800c7b:	00 00 00 
  800c7e:	ff d0                	callq  *%rax
  800c80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c88:	48 85 c0             	test   %rax,%rax
  800c8b:	79 1d                	jns    800caa <vprintfmt+0x3c6>
				putch('-', putdat);
  800c8d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c91:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c95:	48 89 c6             	mov    %rax,%rsi
  800c98:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c9d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ca3:	48 f7 d8             	neg    %rax
  800ca6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800caa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cb1:	e9 d5 00 00 00       	jmpq   800d8b <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cb6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cba:	be 03 00 00 00       	mov    $0x3,%esi
  800cbf:	48 89 c7             	mov    %rax,%rdi
  800cc2:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
  800cce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800cd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd9:	e9 ad 00 00 00       	jmpq   800d8b <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800cde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce2:	be 03 00 00 00       	mov    $0x3,%esi
  800ce7:	48 89 c7             	mov    %rax,%rdi
  800cea:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800cf1:	00 00 00 
  800cf4:	ff d0                	callq  *%rax
  800cf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800cfa:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d01:	e9 85 00 00 00       	jmpq   800d8b <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800d06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0e:	48 89 c6             	mov    %rax,%rsi
  800d11:	bf 30 00 00 00       	mov    $0x30,%edi
  800d16:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d18:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d1c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d20:	48 89 c6             	mov    %rax,%rsi
  800d23:	bf 78 00 00 00       	mov    $0x78,%edi
  800d28:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2d:	83 f8 30             	cmp    $0x30,%eax
  800d30:	73 17                	jae    800d49 <vprintfmt+0x465>
  800d32:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d39:	89 c0                	mov    %eax,%eax
  800d3b:	48 01 d0             	add    %rdx,%rax
  800d3e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d41:	83 c2 08             	add    $0x8,%edx
  800d44:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d47:	eb 0f                	jmp    800d58 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800d49:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4d:	48 89 d0             	mov    %rdx,%rax
  800d50:	48 83 c2 08          	add    $0x8,%rdx
  800d54:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d58:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d5f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d66:	eb 23                	jmp    800d8b <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d68:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d6c:	be 03 00 00 00       	mov    $0x3,%esi
  800d71:	48 89 c7             	mov    %rax,%rdi
  800d74:	48 b8 c4 06 80 00 00 	movabs $0x8006c4,%rax
  800d7b:	00 00 00 
  800d7e:	ff d0                	callq  *%rax
  800d80:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d84:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d8b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d90:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d93:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d96:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d9a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d9e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800da2:	45 89 c1             	mov    %r8d,%r9d
  800da5:	41 89 f8             	mov    %edi,%r8d
  800da8:	48 89 c7             	mov    %rax,%rdi
  800dab:	48 b8 0c 06 80 00 00 	movabs $0x80060c,%rax
  800db2:	00 00 00 
  800db5:	ff d0                	callq  *%rax
			break;
  800db7:	eb 3f                	jmp    800df8 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dbd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dc1:	48 89 c6             	mov    %rax,%rsi
  800dc4:	89 df                	mov    %ebx,%edi
  800dc6:	ff d2                	callq  *%rdx
			break;
  800dc8:	eb 2e                	jmp    800df8 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dca:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dce:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd2:	48 89 c6             	mov    %rax,%rsi
  800dd5:	bf 25 00 00 00       	mov    $0x25,%edi
  800dda:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ddc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800de1:	eb 05                	jmp    800de8 <vprintfmt+0x504>
  800de3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800de8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dec:	48 83 e8 01          	sub    $0x1,%rax
  800df0:	0f b6 00             	movzbl (%rax),%eax
  800df3:	3c 25                	cmp    $0x25,%al
  800df5:	75 ec                	jne    800de3 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800df7:	90                   	nop
		}
	}
  800df8:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df9:	e9 38 fb ff ff       	jmpq   800936 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800dff:	48 83 c4 60          	add    $0x60,%rsp
  800e03:	5b                   	pop    %rbx
  800e04:	41 5c                	pop    %r12
  800e06:	5d                   	pop    %rbp
  800e07:	c3                   	retq   

0000000000800e08 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e08:	55                   	push   %rbp
  800e09:	48 89 e5             	mov    %rsp,%rbp
  800e0c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e13:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e1a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e36:	84 c0                	test   %al,%al
  800e38:	74 20                	je     800e5a <printfmt+0x52>
  800e3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e5a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e61:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e68:	00 00 00 
  800e6b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e72:	00 00 00 
  800e75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e87:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e8e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e95:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e9c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ea3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eaa:	48 89 c7             	mov    %rax,%rdi
  800ead:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eb9:	c9                   	leaveq 
  800eba:	c3                   	retq   

0000000000800ebb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ebb:	55                   	push   %rbp
  800ebc:	48 89 e5             	mov    %rsp,%rbp
  800ebf:	48 83 ec 10          	sub    $0x10,%rsp
  800ec3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ec6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ece:	8b 40 10             	mov    0x10(%rax),%eax
  800ed1:	8d 50 01             	lea    0x1(%rax),%edx
  800ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800edf:	48 8b 10             	mov    (%rax),%rdx
  800ee2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800eea:	48 39 c2             	cmp    %rax,%rdx
  800eed:	73 17                	jae    800f06 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef3:	48 8b 00             	mov    (%rax),%rax
  800ef6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ef9:	88 10                	mov    %dl,(%rax)
  800efb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f03:	48 89 10             	mov    %rdx,(%rax)
}
  800f06:	c9                   	leaveq 
  800f07:	c3                   	retq   

0000000000800f08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f08:	55                   	push   %rbp
  800f09:	48 89 e5             	mov    %rsp,%rbp
  800f0c:	48 83 ec 50          	sub    $0x50,%rsp
  800f10:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f14:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f17:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f1b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f1f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f23:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f27:	48 8b 0a             	mov    (%rdx),%rcx
  800f2a:	48 89 08             	mov    %rcx,(%rax)
  800f2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f41:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f45:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f48:	48 98                	cltq   
  800f4a:	48 83 e8 01          	sub    $0x1,%rax
  800f4e:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f52:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f5d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f62:	74 06                	je     800f6a <vsnprintf+0x62>
  800f64:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f68:	7f 07                	jg     800f71 <vsnprintf+0x69>
		return -E_INVAL;
  800f6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6f:	eb 2f                	jmp    800fa0 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f71:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f75:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f79:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f7d:	48 89 c6             	mov    %rax,%rsi
  800f80:	48 bf bb 0e 80 00 00 	movabs $0x800ebb,%rdi
  800f87:	00 00 00 
  800f8a:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f9a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f9d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fa0:	c9                   	leaveq 
  800fa1:	c3                   	retq   

0000000000800fa2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fa2:	55                   	push   %rbp
  800fa3:	48 89 e5             	mov    %rsp,%rbp
  800fa6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fb4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fc1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fc8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fcf:	84 c0                	test   %al,%al
  800fd1:	74 20                	je     800ff3 <snprintf+0x51>
  800fd3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fd7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fdb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fdf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fe3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fe7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800feb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800ff3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ffa:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801001:	00 00 00 
  801004:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80100b:	00 00 00 
  80100e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801012:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801019:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801020:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801027:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80102e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801035:	48 8b 0a             	mov    (%rdx),%rcx
  801038:	48 89 08             	mov    %rcx,(%rax)
  80103b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80103f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801043:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801047:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80104b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801052:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801059:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80105f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801066:	48 89 c7             	mov    %rax,%rdi
  801069:	48 b8 08 0f 80 00 00 	movabs $0x800f08,%rax
  801070:	00 00 00 
  801073:	ff d0                	callq  *%rax
  801075:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80107b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801081:	c9                   	leaveq 
  801082:	c3                   	retq   
	...

0000000000801084 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 18          	sub    $0x18,%rsp
  80108c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801097:	eb 09                	jmp    8010a2 <strlen+0x1e>
		n++;
  801099:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80109d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a6:	0f b6 00             	movzbl (%rax),%eax
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 ec                	jne    801099 <strlen+0x15>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010c9:	eb 0e                	jmp    8010d9 <strnlen+0x27>
		n++;
  8010cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010cf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010d4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010d9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010de:	74 0b                	je     8010eb <strnlen+0x39>
  8010e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	84 c0                	test   %al,%al
  8010e9:	75 e0                	jne    8010cb <strnlen+0x19>
		n++;
	return n;
  8010eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010ee:	c9                   	leaveq 
  8010ef:	c3                   	retq   

00000000008010f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010f0:	55                   	push   %rbp
  8010f1:	48 89 e5             	mov    %rsp,%rbp
  8010f4:	48 83 ec 20          	sub    $0x20,%rsp
  8010f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801104:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801108:	90                   	nop
  801109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80110d:	0f b6 10             	movzbl (%rax),%edx
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	88 10                	mov    %dl,(%rax)
  801116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	84 c0                	test   %al,%al
  80111f:	0f 95 c0             	setne  %al
  801122:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801127:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80112c:	84 c0                	test   %al,%al
  80112e:	75 d9                	jne    801109 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801130:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 20          	sub    $0x20,%rsp
  80113e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801142:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114a:	48 89 c7             	mov    %rax,%rdi
  80114d:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  801154:	00 00 00 
  801157:	ff d0                	callq  *%rax
  801159:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80115c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115f:	48 98                	cltq   
  801161:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801165:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801169:	48 89 d6             	mov    %rdx,%rsi
  80116c:	48 89 c7             	mov    %rax,%rdi
  80116f:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  801176:	00 00 00 
  801179:	ff d0                	callq  *%rax
	return dst;
  80117b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80117f:	c9                   	leaveq 
  801180:	c3                   	retq   

0000000000801181 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801181:	55                   	push   %rbp
  801182:	48 89 e5             	mov    %rsp,%rbp
  801185:	48 83 ec 28          	sub    $0x28,%rsp
  801189:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801191:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801199:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80119d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011a4:	00 
  8011a5:	eb 27                	jmp    8011ce <strncpy+0x4d>
		*dst++ = *src;
  8011a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011ab:	0f b6 10             	movzbl (%rax),%edx
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	88 10                	mov    %dl,(%rax)
  8011b4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	84 c0                	test   %al,%al
  8011c2:	74 05                	je     8011c9 <strncpy+0x48>
			src++;
  8011c4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011d6:	72 cf                	jb     8011a7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011dc:	c9                   	leaveq 
  8011dd:	c3                   	retq   

00000000008011de <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011de:	55                   	push   %rbp
  8011df:	48 89 e5             	mov    %rsp,%rbp
  8011e2:	48 83 ec 28          	sub    $0x28,%rsp
  8011e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ff:	74 37                	je     801238 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801201:	eb 17                	jmp    80121a <strlcpy+0x3c>
			*dst++ = *src++;
  801203:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801207:	0f b6 10             	movzbl (%rax),%edx
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	88 10                	mov    %dl,(%rax)
  801210:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801215:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80121a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80121f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801224:	74 0b                	je     801231 <strlcpy+0x53>
  801226:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80122a:	0f b6 00             	movzbl (%rax),%eax
  80122d:	84 c0                	test   %al,%al
  80122f:	75 d2                	jne    801203 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801231:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801235:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801238:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801240:	48 89 d1             	mov    %rdx,%rcx
  801243:	48 29 c1             	sub    %rax,%rcx
  801246:	48 89 c8             	mov    %rcx,%rax
}
  801249:	c9                   	leaveq 
  80124a:	c3                   	retq   

000000000080124b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80124b:	55                   	push   %rbp
  80124c:	48 89 e5             	mov    %rsp,%rbp
  80124f:	48 83 ec 10          	sub    $0x10,%rsp
  801253:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801257:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80125b:	eb 0a                	jmp    801267 <strcmp+0x1c>
		p++, q++;
  80125d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801262:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801267:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	84 c0                	test   %al,%al
  801270:	74 12                	je     801284 <strcmp+0x39>
  801272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801276:	0f b6 10             	movzbl (%rax),%edx
  801279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127d:	0f b6 00             	movzbl (%rax),%eax
  801280:	38 c2                	cmp    %al,%dl
  801282:	74 d9                	je     80125d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	0f b6 00             	movzbl (%rax),%eax
  80128b:	0f b6 d0             	movzbl %al,%edx
  80128e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801292:	0f b6 00             	movzbl (%rax),%eax
  801295:	0f b6 c0             	movzbl %al,%eax
  801298:	89 d1                	mov    %edx,%ecx
  80129a:	29 c1                	sub    %eax,%ecx
  80129c:	89 c8                	mov    %ecx,%eax
}
  80129e:	c9                   	leaveq 
  80129f:	c3                   	retq   

00000000008012a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012a0:	55                   	push   %rbp
  8012a1:	48 89 e5             	mov    %rsp,%rbp
  8012a4:	48 83 ec 18          	sub    $0x18,%rsp
  8012a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ac:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012b4:	eb 0f                	jmp    8012c5 <strncmp+0x25>
		n--, p++, q++;
  8012b6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012bb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ca:	74 1d                	je     8012e9 <strncmp+0x49>
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	0f b6 00             	movzbl (%rax),%eax
  8012d3:	84 c0                	test   %al,%al
  8012d5:	74 12                	je     8012e9 <strncmp+0x49>
  8012d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012db:	0f b6 10             	movzbl (%rax),%edx
  8012de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	38 c2                	cmp    %al,%dl
  8012e7:	74 cd                	je     8012b6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ee:	75 07                	jne    8012f7 <strncmp+0x57>
		return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f5:	eb 1a                	jmp    801311 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	0f b6 d0             	movzbl %al,%edx
  801301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	0f b6 c0             	movzbl %al,%eax
  80130b:	89 d1                	mov    %edx,%ecx
  80130d:	29 c1                	sub    %eax,%ecx
  80130f:	89 c8                	mov    %ecx,%eax
}
  801311:	c9                   	leaveq 
  801312:	c3                   	retq   

0000000000801313 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801313:	55                   	push   %rbp
  801314:	48 89 e5             	mov    %rsp,%rbp
  801317:	48 83 ec 10          	sub    $0x10,%rsp
  80131b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131f:	89 f0                	mov    %esi,%eax
  801321:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801324:	eb 17                	jmp    80133d <strchr+0x2a>
		if (*s == c)
  801326:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132a:	0f b6 00             	movzbl (%rax),%eax
  80132d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801330:	75 06                	jne    801338 <strchr+0x25>
			return (char *) s;
  801332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801336:	eb 15                	jmp    80134d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801338:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801341:	0f b6 00             	movzbl (%rax),%eax
  801344:	84 c0                	test   %al,%al
  801346:	75 de                	jne    801326 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 10          	sub    $0x10,%rsp
  801357:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135b:	89 f0                	mov    %esi,%eax
  80135d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801360:	eb 11                	jmp    801373 <strfind+0x24>
		if (*s == c)
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80136c:	74 12                	je     801380 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80136e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	84 c0                	test   %al,%al
  80137c:	75 e4                	jne    801362 <strfind+0x13>
  80137e:	eb 01                	jmp    801381 <strfind+0x32>
		if (*s == c)
			break;
  801380:	90                   	nop
	return (char *) s;
  801381:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801385:	c9                   	leaveq 
  801386:	c3                   	retq   

0000000000801387 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801387:	55                   	push   %rbp
  801388:	48 89 e5             	mov    %rsp,%rbp
  80138b:	48 83 ec 18          	sub    $0x18,%rsp
  80138f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801393:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801396:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80139a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80139f:	75 06                	jne    8013a7 <memset+0x20>
		return v;
  8013a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a5:	eb 69                	jmp    801410 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ab:	83 e0 03             	and    $0x3,%eax
  8013ae:	48 85 c0             	test   %rax,%rax
  8013b1:	75 48                	jne    8013fb <memset+0x74>
  8013b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b7:	83 e0 03             	and    $0x3,%eax
  8013ba:	48 85 c0             	test   %rax,%rax
  8013bd:	75 3c                	jne    8013fb <memset+0x74>
		c &= 0xFF;
  8013bf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	c1 e2 18             	shl    $0x18,%edx
  8013ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d1:	c1 e0 10             	shl    $0x10,%eax
  8013d4:	09 c2                	or     %eax,%edx
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	c1 e0 08             	shl    $0x8,%eax
  8013dc:	09 d0                	or     %edx,%eax
  8013de:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	48 89 c1             	mov    %rax,%rcx
  8013e8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013f3:	48 89 d7             	mov    %rdx,%rdi
  8013f6:	fc                   	cld    
  8013f7:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f9:	eb 11                	jmp    80140c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801402:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801406:	48 89 d7             	mov    %rdx,%rdi
  801409:	fc                   	cld    
  80140a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80140c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 28          	sub    $0x28,%rsp
  80141a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801422:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801426:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80142a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80143e:	0f 83 88 00 00 00    	jae    8014cc <memmove+0xba>
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144c:	48 01 d0             	add    %rdx,%rax
  80144f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801453:	76 77                	jbe    8014cc <memmove+0xba>
		s += n;
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801465:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801469:	83 e0 03             	and    $0x3,%eax
  80146c:	48 85 c0             	test   %rax,%rax
  80146f:	75 3b                	jne    8014ac <memmove+0x9a>
  801471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801475:	83 e0 03             	and    $0x3,%eax
  801478:	48 85 c0             	test   %rax,%rax
  80147b:	75 2f                	jne    8014ac <memmove+0x9a>
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	83 e0 03             	and    $0x3,%eax
  801484:	48 85 c0             	test   %rax,%rax
  801487:	75 23                	jne    8014ac <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148d:	48 83 e8 04          	sub    $0x4,%rax
  801491:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801495:	48 83 ea 04          	sub    $0x4,%rdx
  801499:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80149d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014a1:	48 89 c7             	mov    %rax,%rdi
  8014a4:	48 89 d6             	mov    %rdx,%rsi
  8014a7:	fd                   	std    
  8014a8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014aa:	eb 1d                	jmp    8014c9 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c0:	48 89 d7             	mov    %rdx,%rdi
  8014c3:	48 89 c1             	mov    %rax,%rcx
  8014c6:	fd                   	std    
  8014c7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c9:	fc                   	cld    
  8014ca:	eb 57                	jmp    801523 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	48 85 c0             	test   %rax,%rax
  8014d6:	75 36                	jne    80150e <memmove+0xfc>
  8014d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dc:	83 e0 03             	and    $0x3,%eax
  8014df:	48 85 c0             	test   %rax,%rax
  8014e2:	75 2a                	jne    80150e <memmove+0xfc>
  8014e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e8:	83 e0 03             	and    $0x3,%eax
  8014eb:	48 85 c0             	test   %rax,%rax
  8014ee:	75 1e                	jne    80150e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	48 89 c1             	mov    %rax,%rcx
  8014f7:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801503:	48 89 c7             	mov    %rax,%rdi
  801506:	48 89 d6             	mov    %rdx,%rsi
  801509:	fc                   	cld    
  80150a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80150c:	eb 15                	jmp    801523 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801516:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80151a:	48 89 c7             	mov    %rax,%rdi
  80151d:	48 89 d6             	mov    %rdx,%rsi
  801520:	fc                   	cld    
  801521:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801527:	c9                   	leaveq 
  801528:	c3                   	retq   

0000000000801529 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801529:	55                   	push   %rbp
  80152a:	48 89 e5             	mov    %rsp,%rbp
  80152d:	48 83 ec 18          	sub    $0x18,%rsp
  801531:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801535:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801539:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80153d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801541:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801545:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801549:	48 89 ce             	mov    %rcx,%rsi
  80154c:	48 89 c7             	mov    %rax,%rdi
  80154f:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  801556:	00 00 00 
  801559:	ff d0                	callq  *%rax
}
  80155b:	c9                   	leaveq 
  80155c:	c3                   	retq   

000000000080155d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80155d:	55                   	push   %rbp
  80155e:	48 89 e5             	mov    %rsp,%rbp
  801561:	48 83 ec 28          	sub    $0x28,%rsp
  801565:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801569:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80156d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801571:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801575:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801581:	eb 38                	jmp    8015bb <memcmp+0x5e>
		if (*s1 != *s2)
  801583:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801587:	0f b6 10             	movzbl (%rax),%edx
  80158a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158e:	0f b6 00             	movzbl (%rax),%eax
  801591:	38 c2                	cmp    %al,%dl
  801593:	74 1c                	je     8015b1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801595:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801599:	0f b6 00             	movzbl (%rax),%eax
  80159c:	0f b6 d0             	movzbl %al,%edx
  80159f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	0f b6 c0             	movzbl %al,%eax
  8015a9:	89 d1                	mov    %edx,%ecx
  8015ab:	29 c1                	sub    %eax,%ecx
  8015ad:	89 c8                	mov    %ecx,%eax
  8015af:	eb 20                	jmp    8015d1 <memcmp+0x74>
		s1++, s2++;
  8015b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015c0:	0f 95 c0             	setne  %al
  8015c3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015c8:	84 c0                	test   %al,%al
  8015ca:	75 b7                	jne    801583 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d1:	c9                   	leaveq 
  8015d2:	c3                   	retq   

00000000008015d3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015d3:	55                   	push   %rbp
  8015d4:	48 89 e5             	mov    %rsp,%rbp
  8015d7:	48 83 ec 28          	sub    $0x28,%rsp
  8015db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015df:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ee:	48 01 d0             	add    %rdx,%rax
  8015f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015f5:	eb 13                	jmp    80160a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015fb:	0f b6 10             	movzbl (%rax),%edx
  8015fe:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801601:	38 c2                	cmp    %al,%dl
  801603:	74 11                	je     801616 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801605:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80160a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801612:	72 e3                	jb     8015f7 <memfind+0x24>
  801614:	eb 01                	jmp    801617 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80161b:	c9                   	leaveq 
  80161c:	c3                   	retq   

000000000080161d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161d:	55                   	push   %rbp
  80161e:	48 89 e5             	mov    %rsp,%rbp
  801621:	48 83 ec 38          	sub    $0x38,%rsp
  801625:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801629:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80162d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801630:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801637:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80163e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163f:	eb 05                	jmp    801646 <strtol+0x29>
		s++;
  801641:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 20                	cmp    $0x20,%al
  80164f:	74 f0                	je     801641 <strtol+0x24>
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	3c 09                	cmp    $0x9,%al
  80165a:	74 e5                	je     801641 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80165c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801660:	0f b6 00             	movzbl (%rax),%eax
  801663:	3c 2b                	cmp    $0x2b,%al
  801665:	75 07                	jne    80166e <strtol+0x51>
		s++;
  801667:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80166c:	eb 17                	jmp    801685 <strtol+0x68>
	else if (*s == '-')
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	0f b6 00             	movzbl (%rax),%eax
  801675:	3c 2d                	cmp    $0x2d,%al
  801677:	75 0c                	jne    801685 <strtol+0x68>
		s++, neg = 1;
  801679:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801685:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801689:	74 06                	je     801691 <strtol+0x74>
  80168b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80168f:	75 28                	jne    8016b9 <strtol+0x9c>
  801691:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801695:	0f b6 00             	movzbl (%rax),%eax
  801698:	3c 30                	cmp    $0x30,%al
  80169a:	75 1d                	jne    8016b9 <strtol+0x9c>
  80169c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a0:	48 83 c0 01          	add    $0x1,%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 78                	cmp    $0x78,%al
  8016a9:	75 0e                	jne    8016b9 <strtol+0x9c>
		s += 2, base = 16;
  8016ab:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016b0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016b7:	eb 2c                	jmp    8016e5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016b9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016bd:	75 19                	jne    8016d8 <strtol+0xbb>
  8016bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c3:	0f b6 00             	movzbl (%rax),%eax
  8016c6:	3c 30                	cmp    $0x30,%al
  8016c8:	75 0e                	jne    8016d8 <strtol+0xbb>
		s++, base = 8;
  8016ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016cf:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016d6:	eb 0d                	jmp    8016e5 <strtol+0xc8>
	else if (base == 0)
  8016d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016dc:	75 07                	jne    8016e5 <strtol+0xc8>
		base = 10;
  8016de:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	0f b6 00             	movzbl (%rax),%eax
  8016ec:	3c 2f                	cmp    $0x2f,%al
  8016ee:	7e 1d                	jle    80170d <strtol+0xf0>
  8016f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f4:	0f b6 00             	movzbl (%rax),%eax
  8016f7:	3c 39                	cmp    $0x39,%al
  8016f9:	7f 12                	jg     80170d <strtol+0xf0>
			dig = *s - '0';
  8016fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ff:	0f b6 00             	movzbl (%rax),%eax
  801702:	0f be c0             	movsbl %al,%eax
  801705:	83 e8 30             	sub    $0x30,%eax
  801708:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80170b:	eb 4e                	jmp    80175b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	0f b6 00             	movzbl (%rax),%eax
  801714:	3c 60                	cmp    $0x60,%al
  801716:	7e 1d                	jle    801735 <strtol+0x118>
  801718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171c:	0f b6 00             	movzbl (%rax),%eax
  80171f:	3c 7a                	cmp    $0x7a,%al
  801721:	7f 12                	jg     801735 <strtol+0x118>
			dig = *s - 'a' + 10;
  801723:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801727:	0f b6 00             	movzbl (%rax),%eax
  80172a:	0f be c0             	movsbl %al,%eax
  80172d:	83 e8 57             	sub    $0x57,%eax
  801730:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801733:	eb 26                	jmp    80175b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	0f b6 00             	movzbl (%rax),%eax
  80173c:	3c 40                	cmp    $0x40,%al
  80173e:	7e 47                	jle    801787 <strtol+0x16a>
  801740:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801744:	0f b6 00             	movzbl (%rax),%eax
  801747:	3c 5a                	cmp    $0x5a,%al
  801749:	7f 3c                	jg     801787 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80174b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174f:	0f b6 00             	movzbl (%rax),%eax
  801752:	0f be c0             	movsbl %al,%eax
  801755:	83 e8 37             	sub    $0x37,%eax
  801758:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80175b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80175e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801761:	7d 23                	jge    801786 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801763:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801768:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80176b:	48 98                	cltq   
  80176d:	48 89 c2             	mov    %rax,%rdx
  801770:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801775:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801778:	48 98                	cltq   
  80177a:	48 01 d0             	add    %rdx,%rax
  80177d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801781:	e9 5f ff ff ff       	jmpq   8016e5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801786:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801787:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80178c:	74 0b                	je     801799 <strtol+0x17c>
		*endptr = (char *) s;
  80178e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801792:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801796:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80179d:	74 09                	je     8017a8 <strtol+0x18b>
  80179f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a3:	48 f7 d8             	neg    %rax
  8017a6:	eb 04                	jmp    8017ac <strtol+0x18f>
  8017a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017ac:	c9                   	leaveq 
  8017ad:	c3                   	retq   

00000000008017ae <strstr>:

char * strstr(const char *in, const char *str)
{
  8017ae:	55                   	push   %rbp
  8017af:	48 89 e5             	mov    %rsp,%rbp
  8017b2:	48 83 ec 30          	sub    $0x30,%rsp
  8017b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017c2:	0f b6 00             	movzbl (%rax),%eax
  8017c5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017c8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8017cd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017d1:	75 06                	jne    8017d9 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8017d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d7:	eb 68                	jmp    801841 <strstr+0x93>

    len = strlen(str);
  8017d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017dd:	48 89 c7             	mov    %rax,%rdi
  8017e0:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  8017e7:	00 00 00 
  8017ea:	ff d0                	callq  *%rax
  8017ec:	48 98                	cltq   
  8017ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8017f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801801:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801805:	75 07                	jne    80180e <strstr+0x60>
                return (char *) 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
  80180c:	eb 33                	jmp    801841 <strstr+0x93>
        } while (sc != c);
  80180e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801812:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801815:	75 db                	jne    8017f2 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80181f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801823:	48 89 ce             	mov    %rcx,%rsi
  801826:	48 89 c7             	mov    %rax,%rdi
  801829:	48 b8 a0 12 80 00 00 	movabs $0x8012a0,%rax
  801830:	00 00 00 
  801833:	ff d0                	callq  *%rax
  801835:	85 c0                	test   %eax,%eax
  801837:	75 b9                	jne    8017f2 <strstr+0x44>

    return (char *) (in - 1);
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	48 83 e8 01          	sub    $0x1,%rax
}
  801841:	c9                   	leaveq 
  801842:	c3                   	retq   
	...

0000000000801844 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801844:	55                   	push   %rbp
  801845:	48 89 e5             	mov    %rsp,%rbp
  801848:	53                   	push   %rbx
  801849:	48 83 ec 58          	sub    $0x58,%rsp
  80184d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801850:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801853:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801857:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80185b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80185f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801863:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801866:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801869:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80186d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801871:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801875:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801879:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80187d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801880:	4c 89 c3             	mov    %r8,%rbx
  801883:	cd 30                	int    $0x30
  801885:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801889:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80188d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801891:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801895:	74 3e                	je     8018d5 <syscall+0x91>
  801897:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80189c:	7e 37                	jle    8018d5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80189e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018a5:	49 89 d0             	mov    %rdx,%r8
  8018a8:	89 c1                	mov    %eax,%ecx
  8018aa:	48 ba e0 45 80 00 00 	movabs $0x8045e0,%rdx
  8018b1:	00 00 00 
  8018b4:	be 23 00 00 00       	mov    $0x23,%esi
  8018b9:	48 bf fd 45 80 00 00 	movabs $0x8045fd,%rdi
  8018c0:	00 00 00 
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	49 b9 f8 02 80 00 00 	movabs $0x8002f8,%r9
  8018cf:	00 00 00 
  8018d2:	41 ff d1             	callq  *%r9

	return ret;
  8018d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d9:	48 83 c4 58          	add    $0x58,%rsp
  8018dd:	5b                   	pop    %rbx
  8018de:	5d                   	pop    %rbp
  8018df:	c3                   	retq   

00000000008018e0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018ec:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	48 89 d1             	mov    %rdx,%rcx
  80190f:	48 89 c2             	mov    %rax,%rdx
  801912:	be 00 00 00 00       	mov    $0x0,%esi
  801917:	bf 00 00 00 00       	mov    $0x0,%edi
  80191c:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801923:	00 00 00 
  801926:	ff d0                	callq  *%rax
}
  801928:	c9                   	leaveq 
  801929:	c3                   	retq   

000000000080192a <sys_cgetc>:

int
sys_cgetc(void)
{
  80192a:	55                   	push   %rbp
  80192b:	48 89 e5             	mov    %rsp,%rbp
  80192e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801932:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801939:	00 
  80193a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801946:	b9 00 00 00 00       	mov    $0x0,%ecx
  80194b:	ba 00 00 00 00       	mov    $0x0,%edx
  801950:	be 00 00 00 00       	mov    $0x0,%esi
  801955:	bf 01 00 00 00       	mov    $0x1,%edi
  80195a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801961:	00 00 00 
  801964:	ff d0                	callq  *%rax
}
  801966:	c9                   	leaveq 
  801967:	c3                   	retq   

0000000000801968 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801968:	55                   	push   %rbp
  801969:	48 89 e5             	mov    %rsp,%rbp
  80196c:	48 83 ec 20          	sub    $0x20,%rsp
  801970:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801973:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801976:	48 98                	cltq   
  801978:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80197f:	00 
  801980:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801986:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801991:	48 89 c2             	mov    %rax,%rdx
  801994:	be 01 00 00 00       	mov    $0x1,%esi
  801999:	bf 03 00 00 00       	mov    $0x3,%edi
  80199e:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019b4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019bb:	00 
  8019bc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	be 00 00 00 00       	mov    $0x0,%esi
  8019d7:	bf 02 00 00 00       	mov    $0x2,%edi
  8019dc:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_yield>:

void
sys_yield(void)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019f2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f9:	00 
  8019fa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a10:	be 00 00 00 00       	mov    $0x0,%esi
  801a15:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a1a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801a21:	00 00 00 
  801a24:	ff d0                	callq  *%rax
}
  801a26:	c9                   	leaveq 
  801a27:	c3                   	retq   

0000000000801a28 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a28:	55                   	push   %rbp
  801a29:	48 89 e5             	mov    %rsp,%rbp
  801a2c:	48 83 ec 20          	sub    $0x20,%rsp
  801a30:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a37:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3d:	48 63 c8             	movslq %eax,%rcx
  801a40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a47:	48 98                	cltq   
  801a49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a50:	00 
  801a51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a57:	49 89 c8             	mov    %rcx,%r8
  801a5a:	48 89 d1             	mov    %rdx,%rcx
  801a5d:	48 89 c2             	mov    %rax,%rdx
  801a60:	be 01 00 00 00       	mov    $0x1,%esi
  801a65:	bf 04 00 00 00       	mov    $0x4,%edi
  801a6a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801a71:	00 00 00 
  801a74:	ff d0                	callq  *%rax
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 30          	sub    $0x30,%rsp
  801a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a87:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a8a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a8e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a92:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a95:	48 63 c8             	movslq %eax,%rcx
  801a98:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a9c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a9f:	48 63 f0             	movslq %eax,%rsi
  801aa2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa9:	48 98                	cltq   
  801aab:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aaf:	49 89 f9             	mov    %rdi,%r9
  801ab2:	49 89 f0             	mov    %rsi,%r8
  801ab5:	48 89 d1             	mov    %rdx,%rcx
  801ab8:	48 89 c2             	mov    %rax,%rdx
  801abb:	be 01 00 00 00       	mov    $0x1,%esi
  801ac0:	bf 05 00 00 00       	mov    $0x5,%edi
  801ac5:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801acc:	00 00 00 
  801acf:	ff d0                	callq  *%rax
}
  801ad1:	c9                   	leaveq 
  801ad2:	c3                   	retq   

0000000000801ad3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ad3:	55                   	push   %rbp
  801ad4:	48 89 e5             	mov    %rsp,%rbp
  801ad7:	48 83 ec 20          	sub    $0x20,%rsp
  801adb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ade:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ae2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae9:	48 98                	cltq   
  801aeb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af2:	00 
  801af3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801af9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aff:	48 89 d1             	mov    %rdx,%rcx
  801b02:	48 89 c2             	mov    %rax,%rdx
  801b05:	be 01 00 00 00       	mov    $0x1,%esi
  801b0a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b0f:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801b16:	00 00 00 
  801b19:	ff d0                	callq  *%rax
}
  801b1b:	c9                   	leaveq 
  801b1c:	c3                   	retq   

0000000000801b1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b1d:	55                   	push   %rbp
  801b1e:	48 89 e5             	mov    %rsp,%rbp
  801b21:	48 83 ec 20          	sub    $0x20,%rsp
  801b25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b28:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2e:	48 63 d0             	movslq %eax,%rdx
  801b31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b34:	48 98                	cltq   
  801b36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b3d:	00 
  801b3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4a:	48 89 d1             	mov    %rdx,%rcx
  801b4d:	48 89 c2             	mov    %rax,%rdx
  801b50:	be 01 00 00 00       	mov    $0x1,%esi
  801b55:	bf 08 00 00 00       	mov    $0x8,%edi
  801b5a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
}
  801b66:	c9                   	leaveq 
  801b67:	c3                   	retq   

0000000000801b68 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b68:	55                   	push   %rbp
  801b69:	48 89 e5             	mov    %rsp,%rbp
  801b6c:	48 83 ec 20          	sub    $0x20,%rsp
  801b70:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b73:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7e:	48 98                	cltq   
  801b80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b87:	00 
  801b88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b94:	48 89 d1             	mov    %rdx,%rcx
  801b97:	48 89 c2             	mov    %rax,%rdx
  801b9a:	be 01 00 00 00       	mov    $0x1,%esi
  801b9f:	bf 09 00 00 00       	mov    $0x9,%edi
  801ba4:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801bab:	00 00 00 
  801bae:	ff d0                	callq  *%rax
}
  801bb0:	c9                   	leaveq 
  801bb1:	c3                   	retq   

0000000000801bb2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bb2:	55                   	push   %rbp
  801bb3:	48 89 e5             	mov    %rsp,%rbp
  801bb6:	48 83 ec 20          	sub    $0x20,%rsp
  801bba:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bc5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc8:	48 98                	cltq   
  801bca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd1:	00 
  801bd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bde:	48 89 d1             	mov    %rdx,%rcx
  801be1:	48 89 c2             	mov    %rax,%rdx
  801be4:	be 01 00 00 00       	mov    $0x1,%esi
  801be9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bee:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801bf5:	00 00 00 
  801bf8:	ff d0                	callq  *%rax
}
  801bfa:	c9                   	leaveq 
  801bfb:	c3                   	retq   

0000000000801bfc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bfc:	55                   	push   %rbp
  801bfd:	48 89 e5             	mov    %rsp,%rbp
  801c00:	48 83 ec 30          	sub    $0x30,%rsp
  801c04:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c0b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c0f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c15:	48 63 f0             	movslq %eax,%rsi
  801c18:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1f:	48 98                	cltq   
  801c21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2c:	00 
  801c2d:	49 89 f1             	mov    %rsi,%r9
  801c30:	49 89 c8             	mov    %rcx,%r8
  801c33:	48 89 d1             	mov    %rdx,%rcx
  801c36:	48 89 c2             	mov    %rax,%rdx
  801c39:	be 00 00 00 00       	mov    $0x0,%esi
  801c3e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c43:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801c4a:	00 00 00 
  801c4d:	ff d0                	callq  *%rax
}
  801c4f:	c9                   	leaveq 
  801c50:	c3                   	retq   

0000000000801c51 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c51:	55                   	push   %rbp
  801c52:	48 89 e5             	mov    %rsp,%rbp
  801c55:	48 83 ec 20          	sub    $0x20,%rsp
  801c59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c61:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c68:	00 
  801c69:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c7a:	48 89 c2             	mov    %rax,%rdx
  801c7d:	be 01 00 00 00       	mov    $0x1,%esi
  801c82:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c87:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801c8e:	00 00 00 
  801c91:	ff d0                	callq  *%rax
}
  801c93:	c9                   	leaveq 
  801c94:	c3                   	retq   

0000000000801c95 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c95:	55                   	push   %rbp
  801c96:	48 89 e5             	mov    %rsp,%rbp
  801c99:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca4:	00 
  801ca5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	be 00 00 00 00       	mov    $0x0,%esi
  801cc0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cc5:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801ccc:	00 00 00 
  801ccf:	ff d0                	callq  *%rax
}
  801cd1:	c9                   	leaveq 
  801cd2:	c3                   	retq   

0000000000801cd3 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801cd3:	55                   	push   %rbp
  801cd4:	48 89 e5             	mov    %rsp,%rbp
  801cd7:	48 83 ec 20          	sub    $0x20,%rsp
  801cdb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801ce3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ceb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf2:	00 
  801cf3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cff:	48 89 d1             	mov    %rdx,%rcx
  801d02:	48 89 c2             	mov    %rax,%rdx
  801d05:	be 00 00 00 00       	mov    $0x0,%esi
  801d0a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d0f:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
}
  801d1b:	c9                   	leaveq 
  801d1c:	c3                   	retq   

0000000000801d1d <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801d1d:	55                   	push   %rbp
  801d1e:	48 89 e5             	mov    %rsp,%rbp
  801d21:	48 83 ec 20          	sub    $0x20,%rsp
  801d25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d29:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d3c:	00 
  801d3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d49:	48 89 d1             	mov    %rdx,%rcx
  801d4c:	48 89 c2             	mov    %rax,%rdx
  801d4f:	be 00 00 00 00       	mov    $0x0,%esi
  801d54:	bf 10 00 00 00       	mov    $0x10,%edi
  801d59:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801d60:	00 00 00 
  801d63:	ff d0                	callq  *%rax
}
  801d65:	c9                   	leaveq 
  801d66:	c3                   	retq   
	...

0000000000801d68 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d68:	55                   	push   %rbp
  801d69:	48 89 e5             	mov    %rsp,%rbp
  801d6c:	48 83 ec 08          	sub    $0x8,%rsp
  801d70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d78:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d7f:	ff ff ff 
  801d82:	48 01 d0             	add    %rdx,%rax
  801d85:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 08          	sub    $0x8,%rsp
  801d93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d9b:	48 89 c7             	mov    %rax,%rdi
  801d9e:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  801da5:	00 00 00 
  801da8:	ff d0                	callq  *%rax
  801daa:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801db0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801db4:	c9                   	leaveq 
  801db5:	c3                   	retq   

0000000000801db6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801db6:	55                   	push   %rbp
  801db7:	48 89 e5             	mov    %rsp,%rbp
  801dba:	48 83 ec 18          	sub    $0x18,%rsp
  801dbe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dc9:	eb 6b                	jmp    801e36 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801dcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dce:	48 98                	cltq   
  801dd0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dd6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dda:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	48 c1 ea 15          	shr    $0x15,%rdx
  801de9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801df0:	01 00 00 
  801df3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df7:	83 e0 01             	and    $0x1,%eax
  801dfa:	48 85 c0             	test   %rax,%rax
  801dfd:	74 21                	je     801e20 <fd_alloc+0x6a>
  801dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e0a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e11:	01 00 00 
  801e14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e18:	83 e0 01             	and    $0x1,%eax
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	75 12                	jne    801e32 <fd_alloc+0x7c>
			*fd_store = fd;
  801e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e28:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	eb 1a                	jmp    801e4c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e32:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e36:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e3a:	7e 8f                	jle    801dcb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e40:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e47:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e4c:	c9                   	leaveq 
  801e4d:	c3                   	retq   

0000000000801e4e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 20          	sub    $0x20,%rsp
  801e56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e61:	78 06                	js     801e69 <fd_lookup+0x1b>
  801e63:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e67:	7e 07                	jle    801e70 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6e:	eb 6c                	jmp    801edc <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e73:	48 98                	cltq   
  801e75:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e7b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e87:	48 89 c2             	mov    %rax,%rdx
  801e8a:	48 c1 ea 15          	shr    $0x15,%rdx
  801e8e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e95:	01 00 00 
  801e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9c:	83 e0 01             	and    $0x1,%eax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	74 21                	je     801ec5 <fd_lookup+0x77>
  801ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea8:	48 89 c2             	mov    %rax,%rdx
  801eab:	48 c1 ea 0c          	shr    $0xc,%rdx
  801eaf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb6:	01 00 00 
  801eb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebd:	83 e0 01             	and    $0x1,%eax
  801ec0:	48 85 c0             	test   %rax,%rax
  801ec3:	75 07                	jne    801ecc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ec5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eca:	eb 10                	jmp    801edc <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801ecc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ed0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ed4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 30          	sub    $0x30,%rsp
  801ee6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801eea:	89 f0                	mov    %esi,%eax
  801eec:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 89 c7             	mov    %rax,%rdi
  801ef6:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f06:	48 89 d6             	mov    %rdx,%rsi
  801f09:	89 c7                	mov    %eax,%edi
  801f0b:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  801f12:	00 00 00 
  801f15:	ff d0                	callq  *%rax
  801f17:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f1e:	78 0a                	js     801f2a <fd_close+0x4c>
	    || fd != fd2)
  801f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f24:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f28:	74 12                	je     801f3c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f2a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f2e:	74 05                	je     801f35 <fd_close+0x57>
  801f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f33:	eb 05                	jmp    801f3a <fd_close+0x5c>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	eb 69                	jmp    801fa5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f40:	8b 00                	mov    (%rax),%eax
  801f42:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f46:	48 89 d6             	mov    %rdx,%rsi
  801f49:	89 c7                	mov    %eax,%edi
  801f4b:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
  801f57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f5e:	78 2a                	js     801f8a <fd_close+0xac>
		if (dev->dev_close)
  801f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f64:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f68:	48 85 c0             	test   %rax,%rax
  801f6b:	74 16                	je     801f83 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f71:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f79:	48 89 c7             	mov    %rax,%rdi
  801f7c:	ff d2                	callq  *%rdx
  801f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f81:	eb 07                	jmp    801f8a <fd_close+0xac>
		else
			r = 0;
  801f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f8a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f8e:	48 89 c6             	mov    %rax,%rsi
  801f91:	bf 00 00 00 00       	mov    $0x0,%edi
  801f96:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
	return r;
  801fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fa5:	c9                   	leaveq 
  801fa6:	c3                   	retq   

0000000000801fa7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fa7:	55                   	push   %rbp
  801fa8:	48 89 e5             	mov    %rsp,%rbp
  801fab:	48 83 ec 20          	sub    $0x20,%rsp
  801faf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fb2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fbd:	eb 41                	jmp    802000 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fbf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fc6:	00 00 00 
  801fc9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fcc:	48 63 d2             	movslq %edx,%rdx
  801fcf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fd3:	8b 00                	mov    (%rax),%eax
  801fd5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fd8:	75 22                	jne    801ffc <dev_lookup+0x55>
			*dev = devtab[i];
  801fda:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801fe1:	00 00 00 
  801fe4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fe7:	48 63 d2             	movslq %edx,%rdx
  801fea:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801fee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffa:	eb 60                	jmp    80205c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ffc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802000:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802007:	00 00 00 
  80200a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80200d:	48 63 d2             	movslq %edx,%rdx
  802010:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802014:	48 85 c0             	test   %rax,%rax
  802017:	75 a6                	jne    801fbf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802019:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  802020:	00 00 00 
  802023:	48 8b 00             	mov    (%rax),%rax
  802026:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80202c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80202f:	89 c6                	mov    %eax,%esi
  802031:	48 bf 10 46 80 00 00 	movabs $0x804610,%rdi
  802038:	00 00 00 
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802047:	00 00 00 
  80204a:	ff d1                	callq  *%rcx
	*dev = 0;
  80204c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802050:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80205c:	c9                   	leaveq 
  80205d:	c3                   	retq   

000000000080205e <close>:

int
close(int fdnum)
{
  80205e:	55                   	push   %rbp
  80205f:	48 89 e5             	mov    %rsp,%rbp
  802062:	48 83 ec 20          	sub    $0x20,%rsp
  802066:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802069:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80206d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802070:	48 89 d6             	mov    %rdx,%rsi
  802073:	89 c7                	mov    %eax,%edi
  802075:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  80207c:	00 00 00 
  80207f:	ff d0                	callq  *%rax
  802081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802088:	79 05                	jns    80208f <close+0x31>
		return r;
  80208a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80208d:	eb 18                	jmp    8020a7 <close+0x49>
	else
		return fd_close(fd, 1);
  80208f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802093:	be 01 00 00 00       	mov    $0x1,%esi
  802098:	48 89 c7             	mov    %rax,%rdi
  80209b:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8020a2:	00 00 00 
  8020a5:	ff d0                	callq  *%rax
}
  8020a7:	c9                   	leaveq 
  8020a8:	c3                   	retq   

00000000008020a9 <close_all>:

void
close_all(void)
{
  8020a9:	55                   	push   %rbp
  8020aa:	48 89 e5             	mov    %rsp,%rbp
  8020ad:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020b8:	eb 15                	jmp    8020cf <close_all+0x26>
		close(i);
  8020ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bd:	89 c7                	mov    %eax,%edi
  8020bf:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  8020c6:	00 00 00 
  8020c9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020cf:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020d3:	7e e5                	jle    8020ba <close_all+0x11>
		close(i);
}
  8020d5:	c9                   	leaveq 
  8020d6:	c3                   	retq   

00000000008020d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020d7:	55                   	push   %rbp
  8020d8:	48 89 e5             	mov    %rsp,%rbp
  8020db:	48 83 ec 40          	sub    $0x40,%rsp
  8020df:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020e2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020e5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020e9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020ec:	48 89 d6             	mov    %rdx,%rsi
  8020ef:	89 c7                	mov    %eax,%edi
  8020f1:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8020f8:	00 00 00 
  8020fb:	ff d0                	callq  *%rax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802100:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802104:	79 08                	jns    80210e <dup+0x37>
		return r;
  802106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802109:	e9 70 01 00 00       	jmpq   80227e <dup+0x1a7>
	close(newfdnum);
  80210e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802111:	89 c7                	mov    %eax,%edi
  802113:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80211f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802122:	48 98                	cltq   
  802124:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80212a:	48 c1 e0 0c          	shl    $0xc,%rax
  80212e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	48 89 c7             	mov    %rax,%rdi
  802139:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  802140:	00 00 00 
  802143:	ff d0                	callq  *%rax
  802145:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802149:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214d:	48 89 c7             	mov    %rax,%rdi
  802150:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  802157:	00 00 00 
  80215a:	ff d0                	callq  *%rax
  80215c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802160:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802164:	48 89 c2             	mov    %rax,%rdx
  802167:	48 c1 ea 15          	shr    $0x15,%rdx
  80216b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802172:	01 00 00 
  802175:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802179:	83 e0 01             	and    $0x1,%eax
  80217c:	84 c0                	test   %al,%al
  80217e:	74 71                	je     8021f1 <dup+0x11a>
  802180:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802184:	48 89 c2             	mov    %rax,%rdx
  802187:	48 c1 ea 0c          	shr    $0xc,%rdx
  80218b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802192:	01 00 00 
  802195:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802199:	83 e0 01             	and    $0x1,%eax
  80219c:	84 c0                	test   %al,%al
  80219e:	74 51                	je     8021f1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a4:	48 89 c2             	mov    %rax,%rdx
  8021a7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021b2:	01 00 00 
  8021b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021b9:	89 c1                	mov    %eax,%ecx
  8021bb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021c1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c9:	41 89 c8             	mov    %ecx,%r8d
  8021cc:	48 89 d1             	mov    %rdx,%rcx
  8021cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d4:	48 89 c6             	mov    %rax,%rsi
  8021d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021dc:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8021e3:	00 00 00 
  8021e6:	ff d0                	callq  *%rax
  8021e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ef:	78 56                	js     802247 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021f5:	48 89 c2             	mov    %rax,%rdx
  8021f8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021fc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802203:	01 00 00 
  802206:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80220a:	89 c1                	mov    %eax,%ecx
  80220c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802212:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802216:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221a:	41 89 c8             	mov    %ecx,%r8d
  80221d:	48 89 d1             	mov    %rdx,%rcx
  802220:	ba 00 00 00 00       	mov    $0x0,%edx
  802225:	48 89 c6             	mov    %rax,%rsi
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80223c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802240:	78 08                	js     80224a <dup+0x173>
		goto err;

	return newfdnum;
  802242:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802245:	eb 37                	jmp    80227e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802247:	90                   	nop
  802248:	eb 01                	jmp    80224b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80224a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80224b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224f:	48 89 c6             	mov    %rax,%rsi
  802252:	bf 00 00 00 00       	mov    $0x0,%edi
  802257:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  80225e:	00 00 00 
  802261:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802263:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802267:	48 89 c6             	mov    %rax,%rsi
  80226a:	bf 00 00 00 00       	mov    $0x0,%edi
  80226f:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  802276:	00 00 00 
  802279:	ff d0                	callq  *%rax
	return r;
  80227b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80227e:	c9                   	leaveq 
  80227f:	c3                   	retq   

0000000000802280 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802280:	55                   	push   %rbp
  802281:	48 89 e5             	mov    %rsp,%rbp
  802284:	48 83 ec 40          	sub    $0x40,%rsp
  802288:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80228b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80228f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802293:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802297:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80229a:	48 89 d6             	mov    %rdx,%rsi
  80229d:	89 c7                	mov    %eax,%edi
  80229f:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8022a6:	00 00 00 
  8022a9:	ff d0                	callq  *%rax
  8022ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b2:	78 24                	js     8022d8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b8:	8b 00                	mov    (%rax),%eax
  8022ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022be:	48 89 d6             	mov    %rdx,%rsi
  8022c1:	89 c7                	mov    %eax,%edi
  8022c3:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8022ca:	00 00 00 
  8022cd:	ff d0                	callq  *%rax
  8022cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d6:	79 05                	jns    8022dd <read+0x5d>
		return r;
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	eb 7a                	jmp    802357 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	8b 40 08             	mov    0x8(%rax),%eax
  8022e4:	83 e0 03             	and    $0x3,%eax
  8022e7:	83 f8 01             	cmp    $0x1,%eax
  8022ea:	75 3a                	jne    802326 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022ec:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8022f3:	00 00 00 
  8022f6:	48 8b 00             	mov    (%rax),%rax
  8022f9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022ff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802302:	89 c6                	mov    %eax,%esi
  802304:	48 bf 2f 46 80 00 00 	movabs $0x80462f,%rdi
  80230b:	00 00 00 
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
  802313:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  80231a:	00 00 00 
  80231d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80231f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802324:	eb 31                	jmp    802357 <read+0xd7>
	}
	if (!dev->dev_read)
  802326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80232a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232e:	48 85 c0             	test   %rax,%rax
  802331:	75 07                	jne    80233a <read+0xba>
		return -E_NOT_SUPP;
  802333:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802338:	eb 1d                	jmp    802357 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80233a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802346:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80234a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80234e:	48 89 ce             	mov    %rcx,%rsi
  802351:	48 89 c7             	mov    %rax,%rdi
  802354:	41 ff d0             	callq  *%r8
}
  802357:	c9                   	leaveq 
  802358:	c3                   	retq   

0000000000802359 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802359:	55                   	push   %rbp
  80235a:	48 89 e5             	mov    %rsp,%rbp
  80235d:	48 83 ec 30          	sub    $0x30,%rsp
  802361:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802368:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80236c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802373:	eb 46                	jmp    8023bb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802378:	48 98                	cltq   
  80237a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80237e:	48 29 c2             	sub    %rax,%rdx
  802381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802384:	48 98                	cltq   
  802386:	48 89 c1             	mov    %rax,%rcx
  802389:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80238d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802390:	48 89 ce             	mov    %rcx,%rsi
  802393:	89 c7                	mov    %eax,%edi
  802395:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  80239c:	00 00 00 
  80239f:	ff d0                	callq  *%rax
  8023a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023a8:	79 05                	jns    8023af <readn+0x56>
			return m;
  8023aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023ad:	eb 1d                	jmp    8023cc <readn+0x73>
		if (m == 0)
  8023af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023b3:	74 13                	je     8023c8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023be:	48 98                	cltq   
  8023c0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023c4:	72 af                	jb     802375 <readn+0x1c>
  8023c6:	eb 01                	jmp    8023c9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023c8:	90                   	nop
	}
	return tot;
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023cc:	c9                   	leaveq 
  8023cd:	c3                   	retq   

00000000008023ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023ce:	55                   	push   %rbp
  8023cf:	48 89 e5             	mov    %rsp,%rbp
  8023d2:	48 83 ec 40          	sub    $0x40,%rsp
  8023d6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023d9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023dd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023e8:	48 89 d6             	mov    %rdx,%rsi
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802400:	78 24                	js     802426 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802406:	8b 00                	mov    (%rax),%eax
  802408:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80240c:	48 89 d6             	mov    %rdx,%rsi
  80240f:	89 c7                	mov    %eax,%edi
  802411:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802418:	00 00 00 
  80241b:	ff d0                	callq  *%rax
  80241d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802420:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802424:	79 05                	jns    80242b <write+0x5d>
		return r;
  802426:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802429:	eb 79                	jmp    8024a4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80242b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242f:	8b 40 08             	mov    0x8(%rax),%eax
  802432:	83 e0 03             	and    $0x3,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 3a                	jne    802473 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802439:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  802440:	00 00 00 
  802443:	48 8b 00             	mov    (%rax),%rax
  802446:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80244c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	48 bf 4b 46 80 00 00 	movabs $0x80464b,%rdi
  802458:	00 00 00 
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
  802460:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  802467:	00 00 00 
  80246a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80246c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802471:	eb 31                	jmp    8024a4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802473:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802477:	48 8b 40 18          	mov    0x18(%rax),%rax
  80247b:	48 85 c0             	test   %rax,%rax
  80247e:	75 07                	jne    802487 <write+0xb9>
		return -E_NOT_SUPP;
  802480:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802485:	eb 1d                	jmp    8024a4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80248f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802493:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802497:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80249b:	48 89 ce             	mov    %rcx,%rsi
  80249e:	48 89 c7             	mov    %rax,%rdi
  8024a1:	41 ff d0             	callq  *%r8
}
  8024a4:	c9                   	leaveq 
  8024a5:	c3                   	retq   

00000000008024a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024a6:	55                   	push   %rbp
  8024a7:	48 89 e5             	mov    %rsp,%rbp
  8024aa:	48 83 ec 18          	sub    $0x18,%rsp
  8024ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024bb:	48 89 d6             	mov    %rdx,%rsi
  8024be:	89 c7                	mov    %eax,%edi
  8024c0:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
  8024cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d3:	79 05                	jns    8024da <seek+0x34>
		return r;
  8024d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d8:	eb 0f                	jmp    8024e9 <seek+0x43>
	fd->fd_offset = offset;
  8024da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e9:	c9                   	leaveq 
  8024ea:	c3                   	retq   

00000000008024eb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024eb:	55                   	push   %rbp
  8024ec:	48 89 e5             	mov    %rsp,%rbp
  8024ef:	48 83 ec 30          	sub    $0x30,%rsp
  8024f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024f9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024fd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802500:	48 89 d6             	mov    %rdx,%rsi
  802503:	89 c7                	mov    %eax,%edi
  802505:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
  802511:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802514:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802518:	78 24                	js     80253e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80251a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80251e:	8b 00                	mov    (%rax),%eax
  802520:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802524:	48 89 d6             	mov    %rdx,%rsi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	79 05                	jns    802543 <ftruncate+0x58>
		return r;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802541:	eb 72                	jmp    8025b5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802547:	8b 40 08             	mov    0x8(%rax),%eax
  80254a:	83 e0 03             	and    $0x3,%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	75 3a                	jne    80258b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802551:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  802558:	00 00 00 
  80255b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80255e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802564:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802567:	89 c6                	mov    %eax,%esi
  802569:	48 bf 68 46 80 00 00 	movabs $0x804668,%rdi
  802570:	00 00 00 
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	48 b9 33 05 80 00 00 	movabs $0x800533,%rcx
  80257f:	00 00 00 
  802582:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802584:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802589:	eb 2a                	jmp    8025b5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80258b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80258f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802593:	48 85 c0             	test   %rax,%rax
  802596:	75 07                	jne    80259f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802598:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80259d:	eb 16                	jmp    8025b5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80259f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025ae:	89 d6                	mov    %edx,%esi
  8025b0:	48 89 c7             	mov    %rax,%rdi
  8025b3:	ff d1                	callq  *%rcx
}
  8025b5:	c9                   	leaveq 
  8025b6:	c3                   	retq   

00000000008025b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025b7:	55                   	push   %rbp
  8025b8:	48 89 e5             	mov    %rsp,%rbp
  8025bb:	48 83 ec 30          	sub    $0x30,%rsp
  8025bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025cd:	48 89 d6             	mov    %rdx,%rsi
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e5:	78 24                	js     80260b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	8b 00                	mov    (%rax),%eax
  8025ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025f1:	48 89 d6             	mov    %rdx,%rsi
  8025f4:	89 c7                	mov    %eax,%edi
  8025f6:	48 b8 a7 1f 80 00 00 	movabs $0x801fa7,%rax
  8025fd:	00 00 00 
  802600:	ff d0                	callq  *%rax
  802602:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802605:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802609:	79 05                	jns    802610 <fstat+0x59>
		return r;
  80260b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80260e:	eb 5e                	jmp    80266e <fstat+0xb7>
	if (!dev->dev_stat)
  802610:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802614:	48 8b 40 28          	mov    0x28(%rax),%rax
  802618:	48 85 c0             	test   %rax,%rax
  80261b:	75 07                	jne    802624 <fstat+0x6d>
		return -E_NOT_SUPP;
  80261d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802622:	eb 4a                	jmp    80266e <fstat+0xb7>
	stat->st_name[0] = 0;
  802624:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802628:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80262b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80262f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802636:	00 00 00 
	stat->st_isdir = 0;
  802639:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80263d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802644:	00 00 00 
	stat->st_dev = dev;
  802647:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80264b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80265e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802662:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802666:	48 89 d6             	mov    %rdx,%rsi
  802669:	48 89 c7             	mov    %rax,%rdi
  80266c:	ff d1                	callq  *%rcx
}
  80266e:	c9                   	leaveq 
  80266f:	c3                   	retq   

0000000000802670 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802670:	55                   	push   %rbp
  802671:	48 89 e5             	mov    %rsp,%rbp
  802674:	48 83 ec 20          	sub    $0x20,%rsp
  802678:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80267c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802684:	be 00 00 00 00       	mov    $0x0,%esi
  802689:	48 89 c7             	mov    %rax,%rdi
  80268c:	48 b8 5f 27 80 00 00 	movabs $0x80275f,%rax
  802693:	00 00 00 
  802696:	ff d0                	callq  *%rax
  802698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80269f:	79 05                	jns    8026a6 <stat+0x36>
		return fd;
  8026a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026a4:	eb 2f                	jmp    8026d5 <stat+0x65>
	r = fstat(fd, stat);
  8026a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026ad:	48 89 d6             	mov    %rdx,%rsi
  8026b0:	89 c7                	mov    %eax,%edi
  8026b2:	48 b8 b7 25 80 00 00 	movabs $0x8025b7,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
  8026be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c4:	89 c7                	mov    %eax,%edi
  8026c6:	48 b8 5e 20 80 00 00 	movabs $0x80205e,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
	return r;
  8026d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026d5:	c9                   	leaveq 
  8026d6:	c3                   	retq   
	...

00000000008026d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026d8:	55                   	push   %rbp
  8026d9:	48 89 e5             	mov    %rsp,%rbp
  8026dc:	48 83 ec 10          	sub    $0x10,%rsp
  8026e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026e7:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026ee:	00 00 00 
  8026f1:	8b 00                	mov    (%rax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	75 1d                	jne    802714 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8026f7:	bf 01 00 00 00       	mov    $0x1,%edi
  8026fc:	48 b8 83 3f 80 00 00 	movabs $0x803f83,%rax
  802703:	00 00 00 
  802706:	ff d0                	callq  *%rax
  802708:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  80270f:	00 00 00 
  802712:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802714:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80271b:	00 00 00 
  80271e:	8b 00                	mov    (%rax),%eax
  802720:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802723:	b9 07 00 00 00       	mov    $0x7,%ecx
  802728:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80272f:	00 00 00 
  802732:	89 c7                	mov    %eax,%edi
  802734:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  80273b:	00 00 00 
  80273e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802740:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802744:	ba 00 00 00 00       	mov    $0x0,%edx
  802749:	48 89 c6             	mov    %rax,%rsi
  80274c:	bf 00 00 00 00       	mov    $0x0,%edi
  802751:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
}
  80275d:	c9                   	leaveq 
  80275e:	c3                   	retq   

000000000080275f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80275f:	55                   	push   %rbp
  802760:	48 89 e5             	mov    %rsp,%rbp
  802763:	48 83 ec 20          	sub    $0x20,%rsp
  802767:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80276b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80276e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802772:	48 89 c7             	mov    %rax,%rdi
  802775:	48 b8 84 10 80 00 00 	movabs $0x801084,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802786:	7e 0a                	jle    802792 <open+0x33>
                return -E_BAD_PATH;
  802788:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80278d:	e9 a5 00 00 00       	jmpq   802837 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802792:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802796:	48 89 c7             	mov    %rax,%rdi
  802799:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8027a0:	00 00 00 
  8027a3:	ff d0                	callq  *%rax
  8027a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ac:	79 08                	jns    8027b6 <open+0x57>
		return r;
  8027ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b1:	e9 81 00 00 00       	jmpq   802837 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8027b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ba:	48 89 c6             	mov    %rax,%rsi
  8027bd:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8027c4:	00 00 00 
  8027c7:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  8027ce:	00 00 00 
  8027d1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8027d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8027da:	00 00 00 
  8027dd:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027e0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8027e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ea:	48 89 c6             	mov    %rax,%rsi
  8027ed:	bf 01 00 00 00       	mov    $0x1,%edi
  8027f2:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802805:	79 1d                	jns    802824 <open+0xc5>
	{
		fd_close(fd,0);
  802807:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280b:	be 00 00 00 00       	mov    $0x0,%esi
  802810:	48 89 c7             	mov    %rax,%rdi
  802813:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80281a:	00 00 00 
  80281d:	ff d0                	callq  *%rax
		return r;
  80281f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802822:	eb 13                	jmp    802837 <open+0xd8>
	}
	return fd2num(fd);
  802824:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802828:	48 89 c7             	mov    %rax,%rdi
  80282b:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
	


}
  802837:	c9                   	leaveq 
  802838:	c3                   	retq   

0000000000802839 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802839:	55                   	push   %rbp
  80283a:	48 89 e5             	mov    %rsp,%rbp
  80283d:	48 83 ec 10          	sub    $0x10,%rsp
  802841:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802845:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802849:	8b 50 0c             	mov    0xc(%rax),%edx
  80284c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802853:	00 00 00 
  802856:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802858:	be 00 00 00 00       	mov    $0x0,%esi
  80285d:	bf 06 00 00 00       	mov    $0x6,%edi
  802862:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
}
  80286e:	c9                   	leaveq 
  80286f:	c3                   	retq   

0000000000802870 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802870:	55                   	push   %rbp
  802871:	48 89 e5             	mov    %rsp,%rbp
  802874:	48 83 ec 30          	sub    $0x30,%rsp
  802878:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80287c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802880:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802888:	8b 50 0c             	mov    0xc(%rax),%edx
  80288b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802892:	00 00 00 
  802895:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802897:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028a5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028a9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ae:	bf 03 00 00 00       	mov    $0x3,%edi
  8028b3:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax
  8028bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c6:	79 05                	jns    8028cd <devfile_read+0x5d>
	{
		return r;
  8028c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cb:	eb 2c                	jmp    8028f9 <devfile_read+0x89>
	}
	if(r > 0)
  8028cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d1:	7e 23                	jle    8028f6 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8028d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d6:	48 63 d0             	movslq %eax,%rdx
  8028d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028dd:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8028e4:	00 00 00 
  8028e7:	48 89 c7             	mov    %rax,%rdi
  8028ea:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
	return r;
  8028f6:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8028f9:	c9                   	leaveq 
  8028fa:	c3                   	retq   

00000000008028fb <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8028fb:	55                   	push   %rbp
  8028fc:	48 89 e5             	mov    %rsp,%rbp
  8028ff:	48 83 ec 30          	sub    $0x30,%rsp
  802903:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802907:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80290b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80290f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802913:	8b 50 0c             	mov    0xc(%rax),%edx
  802916:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80291d:	00 00 00 
  802920:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802922:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802929:	00 
  80292a:	76 08                	jbe    802934 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80292c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802933:	00 
	fsipcbuf.write.req_n=n;
  802934:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80293b:	00 00 00 
  80293e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802942:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802946:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80294a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294e:	48 89 c6             	mov    %rax,%rsi
  802951:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  802958:	00 00 00 
  80295b:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  802962:	00 00 00 
  802965:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802967:	be 00 00 00 00       	mov    $0x0,%esi
  80296c:	bf 04 00 00 00       	mov    $0x4,%edi
  802971:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  802978:	00 00 00 
  80297b:	ff d0                	callq  *%rax
  80297d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802980:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802983:	c9                   	leaveq 
  802984:	c3                   	retq   

0000000000802985 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802985:	55                   	push   %rbp
  802986:	48 89 e5             	mov    %rsp,%rbp
  802989:	48 83 ec 10          	sub    $0x10,%rsp
  80298d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802991:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802998:	8b 50 0c             	mov    0xc(%rax),%edx
  80299b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029a2:	00 00 00 
  8029a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8029a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029ae:	00 00 00 
  8029b1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029b7:	be 00 00 00 00       	mov    $0x0,%esi
  8029bc:	bf 02 00 00 00       	mov    $0x2,%edi
  8029c1:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	48 83 ec 20          	sub    $0x20,%rsp
  8029d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8029e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8029ed:	00 00 00 
  8029f0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8029f2:	be 00 00 00 00       	mov    $0x0,%esi
  8029f7:	bf 05 00 00 00       	mov    $0x5,%edi
  8029fc:	48 b8 d8 26 80 00 00 	movabs $0x8026d8,%rax
  802a03:	00 00 00 
  802a06:	ff d0                	callq  *%rax
  802a08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0f:	79 05                	jns    802a16 <devfile_stat+0x47>
		return r;
  802a11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a14:	eb 56                	jmp    802a6c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a1a:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  802a21:	00 00 00 
  802a24:	48 89 c7             	mov    %rax,%rdi
  802a27:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a33:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a3a:	00 00 00 
  802a3d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a43:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a47:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a4d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802a54:	00 00 00 
  802a57:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a61:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6c:	c9                   	leaveq 
  802a6d:	c3                   	retq   
	...

0000000000802a70 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802a70:	55                   	push   %rbp
  802a71:	48 89 e5             	mov    %rsp,%rbp
  802a74:	48 83 ec 20          	sub    $0x20,%rsp
  802a78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a80:	8b 40 0c             	mov    0xc(%rax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	7e 67                	jle    802aee <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a8b:	8b 40 04             	mov    0x4(%rax),%eax
  802a8e:	48 63 d0             	movslq %eax,%rdx
  802a91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a95:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802a99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a9d:	8b 00                	mov    (%rax),%eax
  802a9f:	48 89 ce             	mov    %rcx,%rsi
  802aa2:	89 c7                	mov    %eax,%edi
  802aa4:	48 b8 ce 23 80 00 00 	movabs $0x8023ce,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	callq  *%rax
  802ab0:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802ab3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab7:	7e 13                	jle    802acc <writebuf+0x5c>
			b->result += result;
  802ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abd:	8b 40 08             	mov    0x8(%rax),%eax
  802ac0:	89 c2                	mov    %eax,%edx
  802ac2:	03 55 fc             	add    -0x4(%rbp),%edx
  802ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ac9:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad0:	8b 40 04             	mov    0x4(%rax),%eax
  802ad3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802ad6:	74 16                	je     802aee <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  802add:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ae1:	89 c2                	mov    %eax,%edx
  802ae3:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aeb:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802aee:	c9                   	leaveq 
  802aef:	c3                   	retq   

0000000000802af0 <putch>:

static void
putch(int ch, void *thunk)
{
  802af0:	55                   	push   %rbp
  802af1:	48 89 e5             	mov    %rsp,%rbp
  802af4:	48 83 ec 20          	sub    $0x20,%rsp
  802af8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802afb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802aff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0b:	8b 40 04             	mov    0x4(%rax),%eax
  802b0e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802b11:	89 d6                	mov    %edx,%esi
  802b13:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802b17:	48 63 d0             	movslq %eax,%rdx
  802b1a:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802b1f:	8d 50 01             	lea    0x1(%rax),%edx
  802b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b26:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802b29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b2d:	8b 40 04             	mov    0x4(%rax),%eax
  802b30:	3d 00 01 00 00       	cmp    $0x100,%eax
  802b35:	75 1e                	jne    802b55 <putch+0x65>
		writebuf(b);
  802b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3b:	48 89 c7             	mov    %rax,%rdi
  802b3e:	48 b8 70 2a 80 00 00 	movabs $0x802a70,%rax
  802b45:	00 00 00 
  802b48:	ff d0                	callq  *%rax
		b->idx = 0;
  802b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802b55:	c9                   	leaveq 
  802b56:	c3                   	retq   

0000000000802b57 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802b57:	55                   	push   %rbp
  802b58:	48 89 e5             	mov    %rsp,%rbp
  802b5b:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802b62:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802b68:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802b6f:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802b76:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802b7c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802b82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802b89:	00 00 00 
	b.result = 0;
  802b8c:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802b93:	00 00 00 
	b.error = 1;
  802b96:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802b9d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802ba0:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802ba7:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802bae:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802bb5:	48 89 c6             	mov    %rax,%rsi
  802bb8:	48 bf f0 2a 80 00 00 	movabs $0x802af0,%rdi
  802bbf:	00 00 00 
  802bc2:	48 b8 e4 08 80 00 00 	movabs $0x8008e4,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802bce:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	7e 16                	jle    802bee <vfprintf+0x97>
		writebuf(&b);
  802bd8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802bdf:	48 89 c7             	mov    %rax,%rdi
  802be2:	48 b8 70 2a 80 00 00 	movabs $0x802a70,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802bee:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 08                	je     802c00 <vfprintf+0xa9>
  802bf8:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802bfe:	eb 06                	jmp    802c06 <vfprintf+0xaf>
  802c00:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802c06:	c9                   	leaveq 
  802c07:	c3                   	retq   

0000000000802c08 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802c08:	55                   	push   %rbp
  802c09:	48 89 e5             	mov    %rsp,%rbp
  802c0c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802c13:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802c19:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802c20:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802c27:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802c2e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802c35:	84 c0                	test   %al,%al
  802c37:	74 20                	je     802c59 <fprintf+0x51>
  802c39:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802c3d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802c41:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802c45:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802c49:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802c4d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802c51:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802c55:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802c59:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802c60:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802c67:	00 00 00 
  802c6a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802c71:	00 00 00 
  802c74:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802c78:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802c7f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802c86:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802c8d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802c94:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802c9b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ca1:	48 89 ce             	mov    %rcx,%rsi
  802ca4:	89 c7                	mov    %eax,%edi
  802ca6:	48 b8 57 2b 80 00 00 	movabs $0x802b57,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802cb8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802cbe:	c9                   	leaveq 
  802cbf:	c3                   	retq   

0000000000802cc0 <printf>:

int
printf(const char *fmt, ...)
{
  802cc0:	55                   	push   %rbp
  802cc1:	48 89 e5             	mov    %rsp,%rbp
  802cc4:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ccb:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802cd2:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802cd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802ce0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802ce7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802cee:	84 c0                	test   %al,%al
  802cf0:	74 20                	je     802d12 <printf+0x52>
  802cf2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802cf6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802cfa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802cfe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802d02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802d06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802d0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802d0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802d12:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802d19:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802d20:	00 00 00 
  802d23:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d2a:	00 00 00 
  802d2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d31:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d3f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802d46:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d4d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802d54:	48 89 c6             	mov    %rax,%rsi
  802d57:	bf 01 00 00 00       	mov    $0x1,%edi
  802d5c:	48 b8 57 2b 80 00 00 	movabs $0x802b57,%rax
  802d63:	00 00 00 
  802d66:	ff d0                	callq  *%rax
  802d68:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d6e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d74:	c9                   	leaveq 
  802d75:	c3                   	retq   
	...

0000000000802d78 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802d78:	55                   	push   %rbp
  802d79:	48 89 e5             	mov    %rsp,%rbp
  802d7c:	48 83 ec 20          	sub    $0x20,%rsp
  802d80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802d83:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d87:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d8a:	48 89 d6             	mov    %rdx,%rsi
  802d8d:	89 c7                	mov    %eax,%edi
  802d8f:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  802d96:	00 00 00 
  802d99:	ff d0                	callq  *%rax
  802d9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da2:	79 05                	jns    802da9 <fd2sockid+0x31>
		return r;
  802da4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da7:	eb 24                	jmp    802dcd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dad:	8b 10                	mov    (%rax),%edx
  802daf:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802db6:	00 00 00 
  802db9:	8b 00                	mov    (%rax),%eax
  802dbb:	39 c2                	cmp    %eax,%edx
  802dbd:	74 07                	je     802dc6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802dbf:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dc4:	eb 07                	jmp    802dcd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802dc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dca:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802dcd:	c9                   	leaveq 
  802dce:	c3                   	retq   

0000000000802dcf <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802dcf:	55                   	push   %rbp
  802dd0:	48 89 e5             	mov    %rsp,%rbp
  802dd3:	48 83 ec 20          	sub    $0x20,%rsp
  802dd7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802dda:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dde:	48 89 c7             	mov    %rax,%rdi
  802de1:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
  802ded:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df4:	78 26                	js     802e1c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802df6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dfa:	ba 07 04 00 00       	mov    $0x407,%edx
  802dff:	48 89 c6             	mov    %rax,%rsi
  802e02:	bf 00 00 00 00       	mov    $0x0,%edi
  802e07:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
  802e13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e1a:	79 16                	jns    802e32 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802e1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e1f:	89 c7                	mov    %eax,%edi
  802e21:	48 b8 dc 32 80 00 00 	movabs $0x8032dc,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
		return r;
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	eb 3a                	jmp    802e6c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802e3d:	00 00 00 
  802e40:	8b 12                	mov    (%rdx),%edx
  802e42:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802e44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e48:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802e4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e53:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e56:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802e59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5d:	48 89 c7             	mov    %rax,%rdi
  802e60:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  802e67:	00 00 00 
  802e6a:	ff d0                	callq  *%rax
}
  802e6c:	c9                   	leaveq 
  802e6d:	c3                   	retq   

0000000000802e6e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e6e:	55                   	push   %rbp
  802e6f:	48 89 e5             	mov    %rsp,%rbp
  802e72:	48 83 ec 30          	sub    $0x30,%rsp
  802e76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e7d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802e81:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e84:	89 c7                	mov    %eax,%edi
  802e86:	48 b8 78 2d 80 00 00 	movabs $0x802d78,%rax
  802e8d:	00 00 00 
  802e90:	ff d0                	callq  *%rax
  802e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e99:	79 05                	jns    802ea0 <accept+0x32>
		return r;
  802e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e9e:	eb 3b                	jmp    802edb <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802ea0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ea4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802ea8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eab:	48 89 ce             	mov    %rcx,%rsi
  802eae:	89 c7                	mov    %eax,%edi
  802eb0:	48 b8 b9 31 80 00 00 	movabs $0x8031b9,%rax
  802eb7:	00 00 00 
  802eba:	ff d0                	callq  *%rax
  802ebc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ebf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec3:	79 05                	jns    802eca <accept+0x5c>
		return r;
  802ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec8:	eb 11                	jmp    802edb <accept+0x6d>
	return alloc_sockfd(r);
  802eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ecd:	89 c7                	mov    %eax,%edi
  802ecf:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  802ed6:	00 00 00 
  802ed9:	ff d0                	callq  *%rax
}
  802edb:	c9                   	leaveq 
  802edc:	c3                   	retq   

0000000000802edd <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802edd:	55                   	push   %rbp
  802ede:	48 89 e5             	mov    %rsp,%rbp
  802ee1:	48 83 ec 20          	sub    $0x20,%rsp
  802ee5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eec:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802eef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef2:	89 c7                	mov    %eax,%edi
  802ef4:	48 b8 78 2d 80 00 00 	movabs $0x802d78,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f07:	79 05                	jns    802f0e <bind+0x31>
		return r;
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	eb 1b                	jmp    802f29 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f0e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f11:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	48 89 ce             	mov    %rcx,%rsi
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
}
  802f29:	c9                   	leaveq 
  802f2a:	c3                   	retq   

0000000000802f2b <shutdown>:

int
shutdown(int s, int how)
{
  802f2b:	55                   	push   %rbp
  802f2c:	48 89 e5             	mov    %rsp,%rbp
  802f2f:	48 83 ec 20          	sub    $0x20,%rsp
  802f33:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f36:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f3c:	89 c7                	mov    %eax,%edi
  802f3e:	48 b8 78 2d 80 00 00 	movabs $0x802d78,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f51:	79 05                	jns    802f58 <shutdown+0x2d>
		return r;
  802f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f56:	eb 16                	jmp    802f6e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802f58:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5e:	89 d6                	mov    %edx,%esi
  802f60:	89 c7                	mov    %eax,%edi
  802f62:	48 b8 9c 32 80 00 00 	movabs $0x80329c,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
}
  802f6e:	c9                   	leaveq 
  802f6f:	c3                   	retq   

0000000000802f70 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802f70:	55                   	push   %rbp
  802f71:	48 89 e5             	mov    %rsp,%rbp
  802f74:	48 83 ec 10          	sub    $0x10,%rsp
  802f78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f80:	48 89 c7             	mov    %rax,%rdi
  802f83:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
  802f8f:	83 f8 01             	cmp    $0x1,%eax
  802f92:	75 17                	jne    802fab <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f98:	8b 40 0c             	mov    0xc(%rax),%eax
  802f9b:	89 c7                	mov    %eax,%edi
  802f9d:	48 b8 dc 32 80 00 00 	movabs $0x8032dc,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
  802fa9:	eb 05                	jmp    802fb0 <devsock_close+0x40>
	else
		return 0;
  802fab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb0:	c9                   	leaveq 
  802fb1:	c3                   	retq   

0000000000802fb2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802fb2:	55                   	push   %rbp
  802fb3:	48 89 e5             	mov    %rsp,%rbp
  802fb6:	48 83 ec 20          	sub    $0x20,%rsp
  802fba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc7:	89 c7                	mov    %eax,%edi
  802fc9:	48 b8 78 2d 80 00 00 	movabs $0x802d78,%rax
  802fd0:	00 00 00 
  802fd3:	ff d0                	callq  *%rax
  802fd5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fdc:	79 05                	jns    802fe3 <connect+0x31>
		return r;
  802fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe1:	eb 1b                	jmp    802ffe <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802fe3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fe6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fed:	48 89 ce             	mov    %rcx,%rsi
  802ff0:	89 c7                	mov    %eax,%edi
  802ff2:	48 b8 09 33 80 00 00 	movabs $0x803309,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
}
  802ffe:	c9                   	leaveq 
  802fff:	c3                   	retq   

0000000000803000 <listen>:

int
listen(int s, int backlog)
{
  803000:	55                   	push   %rbp
  803001:	48 89 e5             	mov    %rsp,%rbp
  803004:	48 83 ec 20          	sub    $0x20,%rsp
  803008:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80300b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80300e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803011:	89 c7                	mov    %eax,%edi
  803013:	48 b8 78 2d 80 00 00 	movabs $0x802d78,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803022:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803026:	79 05                	jns    80302d <listen+0x2d>
		return r;
  803028:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302b:	eb 16                	jmp    803043 <listen+0x43>
	return nsipc_listen(r, backlog);
  80302d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803030:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803033:	89 d6                	mov    %edx,%esi
  803035:	89 c7                	mov    %eax,%edi
  803037:	48 b8 6d 33 80 00 00 	movabs $0x80336d,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
}
  803043:	c9                   	leaveq 
  803044:	c3                   	retq   

0000000000803045 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803045:	55                   	push   %rbp
  803046:	48 89 e5             	mov    %rsp,%rbp
  803049:	48 83 ec 20          	sub    $0x20,%rsp
  80304d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803051:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803055:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803059:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80305d:	89 c2                	mov    %eax,%edx
  80305f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803063:	8b 40 0c             	mov    0xc(%rax),%eax
  803066:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80306a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80306f:	89 c7                	mov    %eax,%edi
  803071:	48 b8 ad 33 80 00 00 	movabs $0x8033ad,%rax
  803078:	00 00 00 
  80307b:	ff d0                	callq  *%rax
}
  80307d:	c9                   	leaveq 
  80307e:	c3                   	retq   

000000000080307f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80307f:	55                   	push   %rbp
  803080:	48 89 e5             	mov    %rsp,%rbp
  803083:	48 83 ec 20          	sub    $0x20,%rsp
  803087:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80308b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80308f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803097:	89 c2                	mov    %eax,%edx
  803099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80309d:	8b 40 0c             	mov    0xc(%rax),%eax
  8030a0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030a9:	89 c7                	mov    %eax,%edi
  8030ab:	48 b8 79 34 80 00 00 	movabs $0x803479,%rax
  8030b2:	00 00 00 
  8030b5:	ff d0                	callq  *%rax
}
  8030b7:	c9                   	leaveq 
  8030b8:	c3                   	retq   

00000000008030b9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8030b9:	55                   	push   %rbp
  8030ba:	48 89 e5             	mov    %rsp,%rbp
  8030bd:	48 83 ec 10          	sub    $0x10,%rsp
  8030c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8030c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cd:	48 be 93 46 80 00 00 	movabs $0x804693,%rsi
  8030d4:	00 00 00 
  8030d7:	48 89 c7             	mov    %rax,%rdi
  8030da:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
	return 0;
  8030e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <socket>:

int
socket(int domain, int type, int protocol)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 20          	sub    $0x20,%rsp
  8030f5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030f8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8030fb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8030fe:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803101:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803104:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803107:	89 ce                	mov    %ecx,%esi
  803109:	89 c7                	mov    %eax,%edi
  80310b:	48 b8 31 35 80 00 00 	movabs $0x803531,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax
  803117:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311e:	79 05                	jns    803125 <socket+0x38>
		return r;
  803120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803123:	eb 11                	jmp    803136 <socket+0x49>
	return alloc_sockfd(r);
  803125:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803128:	89 c7                	mov    %eax,%edi
  80312a:	48 b8 cf 2d 80 00 00 	movabs $0x802dcf,%rax
  803131:	00 00 00 
  803134:	ff d0                	callq  *%rax
}
  803136:	c9                   	leaveq 
  803137:	c3                   	retq   

0000000000803138 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803138:	55                   	push   %rbp
  803139:	48 89 e5             	mov    %rsp,%rbp
  80313c:	48 83 ec 10          	sub    $0x10,%rsp
  803140:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803143:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80314a:	00 00 00 
  80314d:	8b 00                	mov    (%rax),%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 1d                	jne    803170 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803153:	bf 02 00 00 00       	mov    $0x2,%edi
  803158:	48 b8 83 3f 80 00 00 	movabs $0x803f83,%rax
  80315f:	00 00 00 
  803162:	ff d0                	callq  *%rax
  803164:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  80316b:	00 00 00 
  80316e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803170:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803177:	00 00 00 
  80317a:	8b 00                	mov    (%rax),%eax
  80317c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80317f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803184:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80318b:	00 00 00 
  80318e:	89 c7                	mov    %eax,%edi
  803190:	48 b8 c0 3e 80 00 00 	movabs $0x803ec0,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80319c:	ba 00 00 00 00       	mov    $0x0,%edx
  8031a1:	be 00 00 00 00       	mov    $0x0,%esi
  8031a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ab:	48 b8 00 3e 80 00 00 	movabs $0x803e00,%rax
  8031b2:	00 00 00 
  8031b5:	ff d0                	callq  *%rax
}
  8031b7:	c9                   	leaveq 
  8031b8:	c3                   	retq   

00000000008031b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031b9:	55                   	push   %rbp
  8031ba:	48 89 e5             	mov    %rsp,%rbp
  8031bd:	48 83 ec 30          	sub    $0x30,%rsp
  8031c1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8031cc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8031d3:	00 00 00 
  8031d6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031d9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8031db:	bf 01 00 00 00       	mov    $0x1,%edi
  8031e0:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  8031e7:	00 00 00 
  8031ea:	ff d0                	callq  *%rax
  8031ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031f3:	78 3e                	js     803233 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8031f5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8031fc:	00 00 00 
  8031ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803207:	8b 40 10             	mov    0x10(%rax),%eax
  80320a:	89 c2                	mov    %eax,%edx
  80320c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803210:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803214:	48 89 ce             	mov    %rcx,%rsi
  803217:	48 89 c7             	mov    %rax,%rdi
  80321a:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803221:	00 00 00 
  803224:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80322a:	8b 50 10             	mov    0x10(%rax),%edx
  80322d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803231:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803233:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803236:	c9                   	leaveq 
  803237:	c3                   	retq   

0000000000803238 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	48 83 ec 10          	sub    $0x10,%rsp
  803240:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803243:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803247:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80324a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803251:	00 00 00 
  803254:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803257:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803259:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80325c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803260:	48 89 c6             	mov    %rax,%rsi
  803263:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80326a:	00 00 00 
  80326d:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803274:	00 00 00 
  803277:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803279:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803280:	00 00 00 
  803283:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803286:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803289:	bf 02 00 00 00       	mov    $0x2,%edi
  80328e:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
}
  80329a:	c9                   	leaveq 
  80329b:	c3                   	retq   

000000000080329c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80329c:	55                   	push   %rbp
  80329d:	48 89 e5             	mov    %rsp,%rbp
  8032a0:	48 83 ec 10          	sub    $0x10,%rsp
  8032a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032a7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8032aa:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032b1:	00 00 00 
  8032b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032b7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8032b9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032c0:	00 00 00 
  8032c3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8032c9:	bf 03 00 00 00       	mov    $0x3,%edi
  8032ce:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
}
  8032da:	c9                   	leaveq 
  8032db:	c3                   	retq   

00000000008032dc <nsipc_close>:

int
nsipc_close(int s)
{
  8032dc:	55                   	push   %rbp
  8032dd:	48 89 e5             	mov    %rsp,%rbp
  8032e0:	48 83 ec 10          	sub    $0x10,%rsp
  8032e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8032e7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8032ee:	00 00 00 
  8032f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032f4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8032f6:	bf 04 00 00 00       	mov    $0x4,%edi
  8032fb:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
}
  803307:	c9                   	leaveq 
  803308:	c3                   	retq   

0000000000803309 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803309:	55                   	push   %rbp
  80330a:	48 89 e5             	mov    %rsp,%rbp
  80330d:	48 83 ec 10          	sub    $0x10,%rsp
  803311:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803314:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803318:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80331b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803322:	00 00 00 
  803325:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803328:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80332a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80332d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803331:	48 89 c6             	mov    %rax,%rsi
  803334:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80333b:	00 00 00 
  80333e:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80334a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803351:	00 00 00 
  803354:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803357:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80335a:	bf 05 00 00 00       	mov    $0x5,%edi
  80335f:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
}
  80336b:	c9                   	leaveq 
  80336c:	c3                   	retq   

000000000080336d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80336d:	55                   	push   %rbp
  80336e:	48 89 e5             	mov    %rsp,%rbp
  803371:	48 83 ec 10          	sub    $0x10,%rsp
  803375:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803378:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80337b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803382:	00 00 00 
  803385:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803388:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80338a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803391:	00 00 00 
  803394:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803397:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80339a:	bf 06 00 00 00       	mov    $0x6,%edi
  80339f:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  8033a6:	00 00 00 
  8033a9:	ff d0                	callq  *%rax
}
  8033ab:	c9                   	leaveq 
  8033ac:	c3                   	retq   

00000000008033ad <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033ad:	55                   	push   %rbp
  8033ae:	48 89 e5             	mov    %rsp,%rbp
  8033b1:	48 83 ec 30          	sub    $0x30,%rsp
  8033b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033bc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8033bf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8033c2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033c9:	00 00 00 
  8033cc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033cf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8033d1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033d8:	00 00 00 
  8033db:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033de:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8033e1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8033e8:	00 00 00 
  8033eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8033ee:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033f1:	bf 07 00 00 00       	mov    $0x7,%edi
  8033f6:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  8033fd:	00 00 00 
  803400:	ff d0                	callq  *%rax
  803402:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803405:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803409:	78 69                	js     803474 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80340b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803412:	7f 08                	jg     80341c <nsipc_recv+0x6f>
  803414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803417:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80341a:	7e 35                	jle    803451 <nsipc_recv+0xa4>
  80341c:	48 b9 9a 46 80 00 00 	movabs $0x80469a,%rcx
  803423:	00 00 00 
  803426:	48 ba af 46 80 00 00 	movabs $0x8046af,%rdx
  80342d:	00 00 00 
  803430:	be 61 00 00 00       	mov    $0x61,%esi
  803435:	48 bf c4 46 80 00 00 	movabs $0x8046c4,%rdi
  80343c:	00 00 00 
  80343f:	b8 00 00 00 00       	mov    $0x0,%eax
  803444:	49 b8 f8 02 80 00 00 	movabs $0x8002f8,%r8
  80344b:	00 00 00 
  80344e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803454:	48 63 d0             	movslq %eax,%rdx
  803457:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80345b:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  803462:	00 00 00 
  803465:	48 89 c7             	mov    %rax,%rdi
  803468:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  80346f:	00 00 00 
  803472:	ff d0                	callq  *%rax
	}

	return r;
  803474:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803477:	c9                   	leaveq 
  803478:	c3                   	retq   

0000000000803479 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803479:	55                   	push   %rbp
  80347a:	48 89 e5             	mov    %rsp,%rbp
  80347d:	48 83 ec 20          	sub    $0x20,%rsp
  803481:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803484:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803488:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80348b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80348e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803495:	00 00 00 
  803498:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80349b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80349d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8034a4:	7e 35                	jle    8034db <nsipc_send+0x62>
  8034a6:	48 b9 d0 46 80 00 00 	movabs $0x8046d0,%rcx
  8034ad:	00 00 00 
  8034b0:	48 ba af 46 80 00 00 	movabs $0x8046af,%rdx
  8034b7:	00 00 00 
  8034ba:	be 6c 00 00 00       	mov    $0x6c,%esi
  8034bf:	48 bf c4 46 80 00 00 	movabs $0x8046c4,%rdi
  8034c6:	00 00 00 
  8034c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ce:	49 b8 f8 02 80 00 00 	movabs $0x8002f8,%r8
  8034d5:	00 00 00 
  8034d8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8034db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034de:	48 63 d0             	movslq %eax,%rdx
  8034e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e5:	48 89 c6             	mov    %rax,%rsi
  8034e8:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8034ef:	00 00 00 
  8034f2:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8034fe:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803505:	00 00 00 
  803508:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80350e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803515:	00 00 00 
  803518:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80351b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80351e:	bf 08 00 00 00       	mov    $0x8,%edi
  803523:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  80352a:	00 00 00 
  80352d:	ff d0                	callq  *%rax
}
  80352f:	c9                   	leaveq 
  803530:	c3                   	retq   

0000000000803531 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803531:	55                   	push   %rbp
  803532:	48 89 e5             	mov    %rsp,%rbp
  803535:	48 83 ec 10          	sub    $0x10,%rsp
  803539:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80353c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80353f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803542:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803549:	00 00 00 
  80354c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80354f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803551:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803558:	00 00 00 
  80355b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80355e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803561:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803568:	00 00 00 
  80356b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80356e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803571:	bf 09 00 00 00       	mov    $0x9,%edi
  803576:	48 b8 38 31 80 00 00 	movabs $0x803138,%rax
  80357d:	00 00 00 
  803580:	ff d0                	callq  *%rax
}
  803582:	c9                   	leaveq 
  803583:	c3                   	retq   

0000000000803584 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803584:	55                   	push   %rbp
  803585:	48 89 e5             	mov    %rsp,%rbp
  803588:	53                   	push   %rbx
  803589:	48 83 ec 38          	sub    $0x38,%rsp
  80358d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803591:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803595:	48 89 c7             	mov    %rax,%rdi
  803598:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  80359f:	00 00 00 
  8035a2:	ff d0                	callq  *%rax
  8035a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035ab:	0f 88 bf 01 00 00    	js     803770 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035b5:	ba 07 04 00 00       	mov    $0x407,%edx
  8035ba:	48 89 c6             	mov    %rax,%rsi
  8035bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8035c2:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  8035c9:	00 00 00 
  8035cc:	ff d0                	callq  *%rax
  8035ce:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035d5:	0f 88 95 01 00 00    	js     803770 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8035db:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8035df:	48 89 c7             	mov    %rax,%rdi
  8035e2:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
  8035ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8035f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8035f5:	0f 88 5d 01 00 00    	js     803758 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8035fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8035ff:	ba 07 04 00 00       	mov    $0x407,%edx
  803604:	48 89 c6             	mov    %rax,%rsi
  803607:	bf 00 00 00 00       	mov    $0x0,%edi
  80360c:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
  803618:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80361b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80361f:	0f 88 33 01 00 00    	js     803758 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803625:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803629:	48 89 c7             	mov    %rax,%rdi
  80362c:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
  803638:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803640:	ba 07 04 00 00       	mov    $0x407,%edx
  803645:	48 89 c6             	mov    %rax,%rsi
  803648:	bf 00 00 00 00       	mov    $0x0,%edi
  80364d:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
  803659:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803660:	0f 88 d9 00 00 00    	js     80373f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803666:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80366a:	48 89 c7             	mov    %rax,%rdi
  80366d:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803674:	00 00 00 
  803677:	ff d0                	callq  *%rax
  803679:	48 89 c2             	mov    %rax,%rdx
  80367c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803680:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803686:	48 89 d1             	mov    %rdx,%rcx
  803689:	ba 00 00 00 00       	mov    $0x0,%edx
  80368e:	48 89 c6             	mov    %rax,%rsi
  803691:	bf 00 00 00 00       	mov    $0x0,%edi
  803696:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
  8036a2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036a9:	78 79                	js     803724 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8036ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036af:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036b6:	00 00 00 
  8036b9:	8b 12                	mov    (%rdx),%edx
  8036bb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8036bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8036c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036cc:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8036d3:	00 00 00 
  8036d6:	8b 12                	mov    (%rdx),%edx
  8036d8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8036da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036de:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8036e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036e9:	48 89 c7             	mov    %rax,%rdi
  8036ec:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	89 c2                	mov    %eax,%edx
  8036fa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036fe:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803700:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803704:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803708:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80370c:	48 89 c7             	mov    %rax,%rdi
  80370f:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
  80371b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80371d:	b8 00 00 00 00       	mov    $0x0,%eax
  803722:	eb 4f                	jmp    803773 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803724:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803725:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803729:	48 89 c6             	mov    %rax,%rsi
  80372c:	bf 00 00 00 00       	mov    $0x0,%edi
  803731:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
  80373d:	eb 01                	jmp    803740 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80373f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803740:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803744:	48 89 c6             	mov    %rax,%rsi
  803747:	bf 00 00 00 00       	mov    $0x0,%edi
  80374c:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803758:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80375c:	48 89 c6             	mov    %rax,%rsi
  80375f:	bf 00 00 00 00       	mov    $0x0,%edi
  803764:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  80376b:	00 00 00 
  80376e:	ff d0                	callq  *%rax
    err:
	return r;
  803770:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803773:	48 83 c4 38          	add    $0x38,%rsp
  803777:	5b                   	pop    %rbx
  803778:	5d                   	pop    %rbp
  803779:	c3                   	retq   

000000000080377a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80377a:	55                   	push   %rbp
  80377b:	48 89 e5             	mov    %rsp,%rbp
  80377e:	53                   	push   %rbx
  80377f:	48 83 ec 28          	sub    $0x28,%rsp
  803783:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803787:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80378b:	eb 01                	jmp    80378e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80378d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80378e:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803795:	00 00 00 
  803798:	48 8b 00             	mov    (%rax),%rax
  80379b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8037a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037a8:	48 89 c7             	mov    %rax,%rdi
  8037ab:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8037b2:	00 00 00 
  8037b5:	ff d0                	callq  *%rax
  8037b7:	89 c3                	mov    %eax,%ebx
  8037b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037bd:	48 89 c7             	mov    %rax,%rdi
  8037c0:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
  8037cc:	39 c3                	cmp    %eax,%ebx
  8037ce:	0f 94 c0             	sete   %al
  8037d1:	0f b6 c0             	movzbl %al,%eax
  8037d4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8037d7:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  8037de:	00 00 00 
  8037e1:	48 8b 00             	mov    (%rax),%rax
  8037e4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8037ea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8037ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037f0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8037f3:	75 0a                	jne    8037ff <_pipeisclosed+0x85>
			return ret;
  8037f5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  8037f8:	48 83 c4 28          	add    $0x28,%rsp
  8037fc:	5b                   	pop    %rbx
  8037fd:	5d                   	pop    %rbp
  8037fe:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8037ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803802:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803805:	74 86                	je     80378d <_pipeisclosed+0x13>
  803807:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80380b:	75 80                	jne    80378d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80380d:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803814:	00 00 00 
  803817:	48 8b 00             	mov    (%rax),%rax
  80381a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803820:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803823:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803826:	89 c6                	mov    %eax,%esi
  803828:	48 bf e1 46 80 00 00 	movabs $0x8046e1,%rdi
  80382f:	00 00 00 
  803832:	b8 00 00 00 00       	mov    $0x0,%eax
  803837:	49 b8 33 05 80 00 00 	movabs $0x800533,%r8
  80383e:	00 00 00 
  803841:	41 ff d0             	callq  *%r8
	}
  803844:	e9 44 ff ff ff       	jmpq   80378d <_pipeisclosed+0x13>

0000000000803849 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803849:	55                   	push   %rbp
  80384a:	48 89 e5             	mov    %rsp,%rbp
  80384d:	48 83 ec 30          	sub    $0x30,%rsp
  803851:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803854:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803858:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80385b:	48 89 d6             	mov    %rdx,%rsi
  80385e:	89 c7                	mov    %eax,%edi
  803860:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  803867:	00 00 00 
  80386a:	ff d0                	callq  *%rax
  80386c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80386f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803873:	79 05                	jns    80387a <pipeisclosed+0x31>
		return r;
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	eb 31                	jmp    8038ab <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80387a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80387e:	48 89 c7             	mov    %rax,%rdi
  803881:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
  80388d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803895:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803899:	48 89 d6             	mov    %rdx,%rsi
  80389c:	48 89 c7             	mov    %rax,%rdi
  80389f:	48 b8 7a 37 80 00 00 	movabs $0x80377a,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
}
  8038ab:	c9                   	leaveq 
  8038ac:	c3                   	retq   

00000000008038ad <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8038ad:	55                   	push   %rbp
  8038ae:	48 89 e5             	mov    %rsp,%rbp
  8038b1:	48 83 ec 40          	sub    $0x40,%rsp
  8038b5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8038b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8038bd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8038c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c5:	48 89 c7             	mov    %rax,%rdi
  8038c8:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8038cf:	00 00 00 
  8038d2:	ff d0                	callq  *%rax
  8038d4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8038d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8038e0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8038e7:	00 
  8038e8:	e9 97 00 00 00       	jmpq   803984 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8038ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8038f2:	74 09                	je     8038fd <devpipe_read+0x50>
				return i;
  8038f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f8:	e9 95 00 00 00       	jmpq   803992 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8038fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803905:	48 89 d6             	mov    %rdx,%rsi
  803908:	48 89 c7             	mov    %rax,%rdi
  80390b:	48 b8 7a 37 80 00 00 	movabs $0x80377a,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
  803917:	85 c0                	test   %eax,%eax
  803919:	74 07                	je     803922 <devpipe_read+0x75>
				return 0;
  80391b:	b8 00 00 00 00       	mov    $0x0,%eax
  803920:	eb 70                	jmp    803992 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803922:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  803929:	00 00 00 
  80392c:	ff d0                	callq  *%rax
  80392e:	eb 01                	jmp    803931 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803930:	90                   	nop
  803931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803935:	8b 10                	mov    (%rax),%edx
  803937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80393b:	8b 40 04             	mov    0x4(%rax),%eax
  80393e:	39 c2                	cmp    %eax,%edx
  803940:	74 ab                	je     8038ed <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803942:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803946:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80394a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80394e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803952:	8b 00                	mov    (%rax),%eax
  803954:	89 c2                	mov    %eax,%edx
  803956:	c1 fa 1f             	sar    $0x1f,%edx
  803959:	c1 ea 1b             	shr    $0x1b,%edx
  80395c:	01 d0                	add    %edx,%eax
  80395e:	83 e0 1f             	and    $0x1f,%eax
  803961:	29 d0                	sub    %edx,%eax
  803963:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803967:	48 98                	cltq   
  803969:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80396e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803970:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803974:	8b 00                	mov    (%rax),%eax
  803976:	8d 50 01             	lea    0x1(%rax),%edx
  803979:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80397d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80397f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803988:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80398c:	72 a2                	jb     803930 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80398e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803992:	c9                   	leaveq 
  803993:	c3                   	retq   

0000000000803994 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	48 83 ec 40          	sub    $0x40,%rsp
  80399c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8039a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ac:	48 89 c7             	mov    %rax,%rdi
  8039af:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039ce:	00 
  8039cf:	e9 93 00 00 00       	jmpq   803a67 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8039d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039dc:	48 89 d6             	mov    %rdx,%rsi
  8039df:	48 89 c7             	mov    %rax,%rdi
  8039e2:	48 b8 7a 37 80 00 00 	movabs $0x80377a,%rax
  8039e9:	00 00 00 
  8039ec:	ff d0                	callq  *%rax
  8039ee:	85 c0                	test   %eax,%eax
  8039f0:	74 07                	je     8039f9 <devpipe_write+0x65>
				return 0;
  8039f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f7:	eb 7c                	jmp    803a75 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8039f9:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  803a00:	00 00 00 
  803a03:	ff d0                	callq  *%rax
  803a05:	eb 01                	jmp    803a08 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a07:	90                   	nop
  803a08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0c:	8b 40 04             	mov    0x4(%rax),%eax
  803a0f:	48 63 d0             	movslq %eax,%rdx
  803a12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a16:	8b 00                	mov    (%rax),%eax
  803a18:	48 98                	cltq   
  803a1a:	48 83 c0 20          	add    $0x20,%rax
  803a1e:	48 39 c2             	cmp    %rax,%rdx
  803a21:	73 b1                	jae    8039d4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a27:	8b 40 04             	mov    0x4(%rax),%eax
  803a2a:	89 c2                	mov    %eax,%edx
  803a2c:	c1 fa 1f             	sar    $0x1f,%edx
  803a2f:	c1 ea 1b             	shr    $0x1b,%edx
  803a32:	01 d0                	add    %edx,%eax
  803a34:	83 e0 1f             	and    $0x1f,%eax
  803a37:	29 d0                	sub    %edx,%eax
  803a39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a3d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803a41:	48 01 ca             	add    %rcx,%rdx
  803a44:	0f b6 0a             	movzbl (%rdx),%ecx
  803a47:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a4b:	48 98                	cltq   
  803a4d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803a51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a55:	8b 40 04             	mov    0x4(%rax),%eax
  803a58:	8d 50 01             	lea    0x1(%rax),%edx
  803a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a62:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a6f:	72 96                	jb     803a07 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803a71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a75:	c9                   	leaveq 
  803a76:	c3                   	retq   

0000000000803a77 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803a77:	55                   	push   %rbp
  803a78:	48 89 e5             	mov    %rsp,%rbp
  803a7b:	48 83 ec 20          	sub    $0x20,%rsp
  803a7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a8b:	48 89 c7             	mov    %rax,%rdi
  803a8e:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803a95:	00 00 00 
  803a98:	ff d0                	callq  *%rax
  803a9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803a9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa2:	48 be f4 46 80 00 00 	movabs $0x8046f4,%rsi
  803aa9:	00 00 00 
  803aac:	48 89 c7             	mov    %rax,%rdi
  803aaf:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  803ab6:	00 00 00 
  803ab9:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abf:	8b 50 04             	mov    0x4(%rax),%edx
  803ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac6:	8b 00                	mov    (%rax),%eax
  803ac8:	29 c2                	sub    %eax,%edx
  803aca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ace:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ad4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ad8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803adf:	00 00 00 
	stat->st_dev = &devpipe;
  803ae2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ae6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803aed:	00 00 00 
  803af0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803afc:	c9                   	leaveq 
  803afd:	c3                   	retq   

0000000000803afe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803afe:	55                   	push   %rbp
  803aff:	48 89 e5             	mov    %rsp,%rbp
  803b02:	48 83 ec 10          	sub    $0x10,%rsp
  803b06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b0e:	48 89 c6             	mov    %rax,%rsi
  803b11:	bf 00 00 00 00       	mov    $0x0,%edi
  803b16:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  803b1d:	00 00 00 
  803b20:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803b22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b26:	48 89 c7             	mov    %rax,%rdi
  803b29:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803b30:	00 00 00 
  803b33:	ff d0                	callq  *%rax
  803b35:	48 89 c6             	mov    %rax,%rsi
  803b38:	bf 00 00 00 00       	mov    $0x0,%edi
  803b3d:	48 b8 d3 1a 80 00 00 	movabs $0x801ad3,%rax
  803b44:	00 00 00 
  803b47:	ff d0                	callq  *%rax
}
  803b49:	c9                   	leaveq 
  803b4a:	c3                   	retq   
	...

0000000000803b4c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803b4c:	55                   	push   %rbp
  803b4d:	48 89 e5             	mov    %rsp,%rbp
  803b50:	48 83 ec 20          	sub    $0x20,%rsp
  803b54:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803b57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b5a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803b5d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803b61:	be 01 00 00 00       	mov    $0x1,%esi
  803b66:	48 89 c7             	mov    %rax,%rdi
  803b69:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
}
  803b75:	c9                   	leaveq 
  803b76:	c3                   	retq   

0000000000803b77 <getchar>:

int
getchar(void)
{
  803b77:	55                   	push   %rbp
  803b78:	48 89 e5             	mov    %rsp,%rbp
  803b7b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803b7f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803b83:	ba 01 00 00 00       	mov    $0x1,%edx
  803b88:	48 89 c6             	mov    %rax,%rsi
  803b8b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b90:	48 b8 80 22 80 00 00 	movabs $0x802280,%rax
  803b97:	00 00 00 
  803b9a:	ff d0                	callq  *%rax
  803b9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803b9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ba3:	79 05                	jns    803baa <getchar+0x33>
		return r;
  803ba5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba8:	eb 14                	jmp    803bbe <getchar+0x47>
	if (r < 1)
  803baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bae:	7f 07                	jg     803bb7 <getchar+0x40>
		return -E_EOF;
  803bb0:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803bb5:	eb 07                	jmp    803bbe <getchar+0x47>
	return c;
  803bb7:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803bbb:	0f b6 c0             	movzbl %al,%eax
}
  803bbe:	c9                   	leaveq 
  803bbf:	c3                   	retq   

0000000000803bc0 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803bc0:	55                   	push   %rbp
  803bc1:	48 89 e5             	mov    %rsp,%rbp
  803bc4:	48 83 ec 20          	sub    $0x20,%rsp
  803bc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bcb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803bcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd2:	48 89 d6             	mov    %rdx,%rsi
  803bd5:	89 c7                	mov    %eax,%edi
  803bd7:	48 b8 4e 1e 80 00 00 	movabs $0x801e4e,%rax
  803bde:	00 00 00 
  803be1:	ff d0                	callq  *%rax
  803be3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803be6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bea:	79 05                	jns    803bf1 <iscons+0x31>
		return r;
  803bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bef:	eb 1a                	jmp    803c0b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803bf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bf5:	8b 10                	mov    (%rax),%edx
  803bf7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803bfe:	00 00 00 
  803c01:	8b 00                	mov    (%rax),%eax
  803c03:	39 c2                	cmp    %eax,%edx
  803c05:	0f 94 c0             	sete   %al
  803c08:	0f b6 c0             	movzbl %al,%eax
}
  803c0b:	c9                   	leaveq 
  803c0c:	c3                   	retq   

0000000000803c0d <opencons>:

int
opencons(void)
{
  803c0d:	55                   	push   %rbp
  803c0e:	48 89 e5             	mov    %rsp,%rbp
  803c11:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c15:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c19:	48 89 c7             	mov    %rax,%rdi
  803c1c:	48 b8 b6 1d 80 00 00 	movabs $0x801db6,%rax
  803c23:	00 00 00 
  803c26:	ff d0                	callq  *%rax
  803c28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2f:	79 05                	jns    803c36 <opencons+0x29>
		return r;
  803c31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c34:	eb 5b                	jmp    803c91 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c3a:	ba 07 04 00 00       	mov    $0x407,%edx
  803c3f:	48 89 c6             	mov    %rax,%rsi
  803c42:	bf 00 00 00 00       	mov    $0x0,%edi
  803c47:	48 b8 28 1a 80 00 00 	movabs $0x801a28,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
  803c53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5a:	79 05                	jns    803c61 <opencons+0x54>
		return r;
  803c5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c5f:	eb 30                	jmp    803c91 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c65:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803c6c:	00 00 00 
  803c6f:	8b 12                	mov    (%rdx),%edx
  803c71:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c77:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c82:	48 89 c7             	mov    %rax,%rdi
  803c85:	48 b8 68 1d 80 00 00 	movabs $0x801d68,%rax
  803c8c:	00 00 00 
  803c8f:	ff d0                	callq  *%rax
}
  803c91:	c9                   	leaveq 
  803c92:	c3                   	retq   

0000000000803c93 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803c93:	55                   	push   %rbp
  803c94:	48 89 e5             	mov    %rsp,%rbp
  803c97:	48 83 ec 30          	sub    $0x30,%rsp
  803c9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ca3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803ca7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803cac:	75 13                	jne    803cc1 <devcons_read+0x2e>
		return 0;
  803cae:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb3:	eb 49                	jmp    803cfe <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803cb5:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  803cbc:	00 00 00 
  803cbf:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803cc1:	48 b8 2a 19 80 00 00 	movabs $0x80192a,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
  803ccd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd4:	74 df                	je     803cb5 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cda:	79 05                	jns    803ce1 <devcons_read+0x4e>
		return c;
  803cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdf:	eb 1d                	jmp    803cfe <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803ce1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803ce5:	75 07                	jne    803cee <devcons_read+0x5b>
		return 0;
  803ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  803cec:	eb 10                	jmp    803cfe <devcons_read+0x6b>
	*(char*)vbuf = c;
  803cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf1:	89 c2                	mov    %eax,%edx
  803cf3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cf7:	88 10                	mov    %dl,(%rax)
	return 1;
  803cf9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803cfe:	c9                   	leaveq 
  803cff:	c3                   	retq   

0000000000803d00 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d00:	55                   	push   %rbp
  803d01:	48 89 e5             	mov    %rsp,%rbp
  803d04:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d0b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d12:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d19:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d27:	eb 77                	jmp    803da0 <devcons_write+0xa0>
		m = n - tot;
  803d29:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803d30:	89 c2                	mov    %eax,%edx
  803d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d35:	89 d1                	mov    %edx,%ecx
  803d37:	29 c1                	sub    %eax,%ecx
  803d39:	89 c8                	mov    %ecx,%eax
  803d3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803d3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d41:	83 f8 7f             	cmp    $0x7f,%eax
  803d44:	76 07                	jbe    803d4d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803d46:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803d4d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d50:	48 63 d0             	movslq %eax,%rdx
  803d53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d56:	48 98                	cltq   
  803d58:	48 89 c1             	mov    %rax,%rcx
  803d5b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803d62:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d69:	48 89 ce             	mov    %rcx,%rsi
  803d6c:	48 89 c7             	mov    %rax,%rdi
  803d6f:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803d76:	00 00 00 
  803d79:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803d7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d7e:	48 63 d0             	movslq %eax,%rdx
  803d81:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803d88:	48 89 d6             	mov    %rdx,%rsi
  803d8b:	48 89 c7             	mov    %rax,%rdi
  803d8e:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803d95:	00 00 00 
  803d98:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d9d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da3:	48 98                	cltq   
  803da5:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803dac:	0f 82 77 ff ff ff    	jb     803d29 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803db5:	c9                   	leaveq 
  803db6:	c3                   	retq   

0000000000803db7 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803db7:	55                   	push   %rbp
  803db8:	48 89 e5             	mov    %rsp,%rbp
  803dbb:	48 83 ec 08          	sub    $0x8,%rsp
  803dbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc8:	c9                   	leaveq 
  803dc9:	c3                   	retq   

0000000000803dca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803dca:	55                   	push   %rbp
  803dcb:	48 89 e5             	mov    %rsp,%rbp
  803dce:	48 83 ec 10          	sub    $0x10,%rsp
  803dd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803dd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dde:	48 be 00 47 80 00 00 	movabs $0x804700,%rsi
  803de5:	00 00 00 
  803de8:	48 89 c7             	mov    %rax,%rdi
  803deb:	48 b8 f0 10 80 00 00 	movabs $0x8010f0,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
	return 0;
  803df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dfc:	c9                   	leaveq 
  803dfd:	c3                   	retq   
	...

0000000000803e00 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e00:	55                   	push   %rbp
  803e01:	48 89 e5             	mov    %rsp,%rbp
  803e04:	48 83 ec 30          	sub    $0x30,%rsp
  803e08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e10:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803e14:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803e19:	74 18                	je     803e33 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803e1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e1f:	48 89 c7             	mov    %rax,%rdi
  803e22:	48 b8 51 1c 80 00 00 	movabs $0x801c51,%rax
  803e29:	00 00 00 
  803e2c:	ff d0                	callq  *%rax
  803e2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e31:	eb 19                	jmp    803e4c <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803e33:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803e3a:	00 00 00 
  803e3d:	48 b8 51 1c 80 00 00 	movabs $0x801c51,%rax
  803e44:	00 00 00 
  803e47:	ff d0                	callq  *%rax
  803e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e50:	79 19                	jns    803e6b <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803e52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e56:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803e5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e60:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e69:	eb 53                	jmp    803ebe <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803e6b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e70:	74 19                	je     803e8b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803e72:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803e79:	00 00 00 
  803e7c:	48 8b 00             	mov    (%rax),%rax
  803e7f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e89:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803e8b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e90:	74 19                	je     803eab <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803e92:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803e99:	00 00 00 
  803e9c:	48 8b 00             	mov    (%rax),%rax
  803e9f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803ea5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803eab:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803eb2:	00 00 00 
  803eb5:	48 8b 00             	mov    (%rax),%rax
  803eb8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803ebe:	c9                   	leaveq 
  803ebf:	c3                   	retq   

0000000000803ec0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803ec0:	55                   	push   %rbp
  803ec1:	48 89 e5             	mov    %rsp,%rbp
  803ec4:	48 83 ec 30          	sub    $0x30,%rsp
  803ec8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ecb:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ece:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ed2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803ed5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803edc:	e9 96 00 00 00       	jmpq   803f77 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803ee1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ee6:	74 20                	je     803f08 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803ee8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803eeb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803eee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ef2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ef5:	89 c7                	mov    %eax,%edi
  803ef7:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f06:	eb 2d                	jmp    803f35 <ipc_send+0x75>
		else if(pg==NULL)
  803f08:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f0d:	75 26                	jne    803f35 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803f0f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f15:	b9 00 00 00 00       	mov    $0x0,%ecx
  803f1a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f21:	00 00 00 
  803f24:	89 c7                	mov    %eax,%edi
  803f26:	48 b8 fc 1b 80 00 00 	movabs $0x801bfc,%rax
  803f2d:	00 00 00 
  803f30:	ff d0                	callq  *%rax
  803f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f39:	79 30                	jns    803f6b <ipc_send+0xab>
  803f3b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803f3f:	74 2a                	je     803f6b <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803f41:	48 ba 07 47 80 00 00 	movabs $0x804707,%rdx
  803f48:	00 00 00 
  803f4b:	be 40 00 00 00       	mov    $0x40,%esi
  803f50:	48 bf 1f 47 80 00 00 	movabs $0x80471f,%rdi
  803f57:	00 00 00 
  803f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f5f:	48 b9 f8 02 80 00 00 	movabs $0x8002f8,%rcx
  803f66:	00 00 00 
  803f69:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803f6b:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  803f72:	00 00 00 
  803f75:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f7b:	0f 85 60 ff ff ff    	jne    803ee1 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803f81:	c9                   	leaveq 
  803f82:	c3                   	retq   

0000000000803f83 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f83:	55                   	push   %rbp
  803f84:	48 89 e5             	mov    %rsp,%rbp
  803f87:	48 83 ec 18          	sub    $0x18,%rsp
  803f8b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f95:	eb 5e                	jmp    803ff5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803f97:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803f9e:	00 00 00 
  803fa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa4:	48 63 d0             	movslq %eax,%rdx
  803fa7:	48 89 d0             	mov    %rdx,%rax
  803faa:	48 c1 e0 03          	shl    $0x3,%rax
  803fae:	48 01 d0             	add    %rdx,%rax
  803fb1:	48 c1 e0 05          	shl    $0x5,%rax
  803fb5:	48 01 c8             	add    %rcx,%rax
  803fb8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803fbe:	8b 00                	mov    (%rax),%eax
  803fc0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fc3:	75 2c                	jne    803ff1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803fc5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803fcc:	00 00 00 
  803fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd2:	48 63 d0             	movslq %eax,%rdx
  803fd5:	48 89 d0             	mov    %rdx,%rax
  803fd8:	48 c1 e0 03          	shl    $0x3,%rax
  803fdc:	48 01 d0             	add    %rdx,%rax
  803fdf:	48 c1 e0 05          	shl    $0x5,%rax
  803fe3:	48 01 c8             	add    %rcx,%rax
  803fe6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803fec:	8b 40 08             	mov    0x8(%rax),%eax
  803fef:	eb 12                	jmp    804003 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803ff1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ff5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803ffc:	7e 99                	jle    803f97 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804003:	c9                   	leaveq 
  804004:	c3                   	retq   
  804005:	00 00                	add    %al,(%rax)
	...

0000000000804008 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804008:	55                   	push   %rbp
  804009:	48 89 e5             	mov    %rsp,%rbp
  80400c:	48 83 ec 18          	sub    $0x18,%rsp
  804010:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804018:	48 89 c2             	mov    %rax,%rdx
  80401b:	48 c1 ea 15          	shr    $0x15,%rdx
  80401f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804026:	01 00 00 
  804029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80402d:	83 e0 01             	and    $0x1,%eax
  804030:	48 85 c0             	test   %rax,%rax
  804033:	75 07                	jne    80403c <pageref+0x34>
		return 0;
  804035:	b8 00 00 00 00       	mov    $0x0,%eax
  80403a:	eb 53                	jmp    80408f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80403c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804040:	48 89 c2             	mov    %rax,%rdx
  804043:	48 c1 ea 0c          	shr    $0xc,%rdx
  804047:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80404e:	01 00 00 
  804051:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804055:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804059:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80405d:	83 e0 01             	and    $0x1,%eax
  804060:	48 85 c0             	test   %rax,%rax
  804063:	75 07                	jne    80406c <pageref+0x64>
		return 0;
  804065:	b8 00 00 00 00       	mov    $0x0,%eax
  80406a:	eb 23                	jmp    80408f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80406c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804070:	48 89 c2             	mov    %rax,%rdx
  804073:	48 c1 ea 0c          	shr    $0xc,%rdx
  804077:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80407e:	00 00 00 
  804081:	48 c1 e2 04          	shl    $0x4,%rdx
  804085:	48 01 d0             	add    %rdx,%rax
  804088:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80408c:	0f b7 c0             	movzwl %ax,%eax
}
  80408f:	c9                   	leaveq 
  804090:	c3                   	retq   
