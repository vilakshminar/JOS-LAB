
obj/user/num.debug:     file format elf64-x86-64


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
  80003c:	e8 7f 02 00 00       	callq  8002c0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800053:	e9 da 00 00 00       	jmpq   800132 <num+0xee>
		if (bol) {
  800058:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80005f:	00 00 00 
  800062:	8b 00                	mov    (%rax),%eax
  800064:	85 c0                	test   %eax,%eax
  800066:	74 54                	je     8000bc <num+0x78>
			printf("%5d ", ++line);
  800068:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80006f:	00 00 00 
  800072:	8b 00                	mov    (%rax),%eax
  800074:	8d 50 01             	lea    0x1(%rax),%edx
  800077:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80007e:	00 00 00 
  800081:	89 10                	mov    %edx,(%rax)
  800083:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80008a:	00 00 00 
  80008d:	8b 00                	mov    (%rax),%eax
  80008f:	89 c6                	mov    %eax,%esi
  800091:	48 bf 40 41 80 00 00 	movabs $0x804140,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 ba 50 2d 80 00 00 	movabs $0x802d50,%rdx
  8000a7:	00 00 00 
  8000aa:	ff d2                	callq  *%rdx
			bol = 0;
  8000ac:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000b3:	00 00 00 
  8000b6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		}
		if ((r = write(1, &c, 1)) != 1)
  8000bc:	48 8d 45 f3          	lea    -0xd(%rbp),%rax
  8000c0:	ba 01 00 00 00       	mov    $0x1,%edx
  8000c5:	48 89 c6             	mov    %rax,%rsi
  8000c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8000cd:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  8000d4:	00 00 00 
  8000d7:	ff d0                	callq  *%rax
  8000d9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000dc:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
  8000e0:	74 38                	je     80011a <num+0xd6>
			panic("write error copying %s: %e", s, r);
  8000e2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e9:	41 89 d0             	mov    %edx,%r8d
  8000ec:	48 89 c1             	mov    %rax,%rcx
  8000ef:	48 ba 45 41 80 00 00 	movabs $0x804145,%rdx
  8000f6:	00 00 00 
  8000f9:	be 13 00 00 00       	mov    $0x13,%esi
  8000fe:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  800105:	00 00 00 
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  800114:	00 00 00 
  800117:	41 ff d1             	callq  *%r9
		if (c == '\n')
  80011a:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  80011e:	3c 0a                	cmp    $0xa,%al
  800120:	75 10                	jne    800132 <num+0xee>
			bol = 1;
  800122:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800129:	00 00 00 
  80012c:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800132:	48 8d 4d f3          	lea    -0xd(%rbp),%rcx
  800136:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800139:	ba 01 00 00 00       	mov    $0x1,%edx
  80013e:	48 89 ce             	mov    %rcx,%rsi
  800141:	89 c7                	mov    %eax,%edi
  800143:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80014a:	00 00 00 
  80014d:	ff d0                	callq  *%rax
  80014f:	48 98                	cltq   
  800151:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800155:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80015a:	0f 8f f8 fe ff ff    	jg     800058 <num+0x14>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  800160:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800165:	79 39                	jns    8001a0 <num+0x15c>
		panic("error reading %s: %e", s, n);
  800167:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80016b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80016f:	49 89 d0             	mov    %rdx,%r8
  800172:	48 89 c1             	mov    %rax,%rcx
  800175:	48 ba 6b 41 80 00 00 	movabs $0x80416b,%rdx
  80017c:	00 00 00 
  80017f:	be 18 00 00 00       	mov    $0x18,%esi
  800184:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9
}
  8001a0:	c9                   	leaveq 
  8001a1:	c3                   	retq   

00000000008001a2 <umain>:

void
umain(int argc, char **argv)
{
  8001a2:	55                   	push   %rbp
  8001a3:	48 89 e5             	mov    %rsp,%rbp
  8001a6:	48 83 ec 20          	sub    $0x20,%rsp
  8001aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8001ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int f, i;

	binaryname = "num";
  8001b1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001b8:	00 00 00 
  8001bb:	48 ba 80 41 80 00 00 	movabs $0x804180,%rdx
  8001c2:	00 00 00 
  8001c5:	48 89 10             	mov    %rdx,(%rax)
	if (argc == 1)
  8001c8:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  8001cc:	75 20                	jne    8001ee <umain+0x4c>
		num(0, "<stdin>");
  8001ce:	48 be 84 41 80 00 00 	movabs $0x804184,%rsi
  8001d5:	00 00 00 
  8001d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001dd:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
  8001e9:	e9 c2 00 00 00       	jmpq   8002b0 <umain+0x10e>
	else
		for (i = 1; i < argc; i++) {
  8001ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8001f5:	e9 aa 00 00 00       	jmpq   8002a4 <umain+0x102>
			f = open(argv[i], O_RDONLY);
  8001fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001fd:	48 98                	cltq   
  8001ff:	48 c1 e0 03          	shl    $0x3,%rax
  800203:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800207:	48 8b 00             	mov    (%rax),%rax
  80020a:	be 00 00 00 00       	mov    $0x0,%esi
  80020f:	48 89 c7             	mov    %rax,%rdi
  800212:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	89 45 f8             	mov    %eax,-0x8(%rbp)
			if (f < 0)
  800221:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800225:	79 44                	jns    80026b <umain+0xc9>
				panic("can't open %s: %e", argv[i], f);
  800227:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022a:	48 98                	cltq   
  80022c:	48 c1 e0 03          	shl    $0x3,%rax
  800230:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800234:	48 8b 00             	mov    (%rax),%rax
  800237:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80023a:	41 89 d0             	mov    %edx,%r8d
  80023d:	48 89 c1             	mov    %rax,%rcx
  800240:	48 ba 8c 41 80 00 00 	movabs $0x80418c,%rdx
  800247:	00 00 00 
  80024a:	be 27 00 00 00       	mov    $0x27,%esi
  80024f:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  800256:	00 00 00 
  800259:	b8 00 00 00 00       	mov    $0x0,%eax
  80025e:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  800265:	00 00 00 
  800268:	41 ff d1             	callq  *%r9
			else {
				num(f, argv[i]);
  80026b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026e:	48 98                	cltq   
  800270:	48 c1 e0 03          	shl    $0x3,%rax
  800274:	48 03 45 e0          	add    -0x20(%rbp),%rax
  800278:	48 8b 10             	mov    (%rax),%rdx
  80027b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80027e:	48 89 d6             	mov    %rdx,%rsi
  800281:	89 c7                	mov    %eax,%edi
  800283:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80028a:	00 00 00 
  80028d:	ff d0                	callq  *%rax
				close(f);
  80028f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800292:	89 c7                	mov    %eax,%edi
  800294:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  80029b:	00 00 00 
  80029e:	ff d0                	callq  *%rax

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8002a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8002a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8002aa:	0f 8c 4a ff ff ff    	jl     8001fa <umain+0x58>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8002b0:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  8002b7:	00 00 00 
  8002ba:	ff d0                	callq  *%rax
}
  8002bc:	c9                   	leaveq 
  8002bd:	c3                   	retq   
	...

00000000008002c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %rbp
  8002c1:	48 89 e5             	mov    %rsp,%rbp
  8002c4:	48 83 ec 10          	sub    $0x10,%rsp
  8002c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002cf:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8002d6:	00 00 00 
  8002d9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8002e0:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  8002e7:	00 00 00 
  8002ea:	ff d0                	callq  *%rax
  8002ec:	48 98                	cltq   
  8002ee:	48 89 c2             	mov    %rax,%rdx
  8002f1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8002f7:	48 89 d0             	mov    %rdx,%rax
  8002fa:	48 c1 e0 03          	shl    $0x3,%rax
  8002fe:	48 01 d0             	add    %rdx,%rax
  800301:	48 c1 e0 05          	shl    $0x5,%rax
  800305:	48 89 c2             	mov    %rax,%rdx
  800308:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80030f:	00 00 00 
  800312:	48 01 c2             	add    %rax,%rdx
  800315:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80031c:	00 00 00 
  80031f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800322:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800326:	7e 14                	jle    80033c <libmain+0x7c>
		binaryname = argv[0];
  800328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80032c:	48 8b 10             	mov    (%rax),%rdx
  80032f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800336:	00 00 00 
  800339:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80033c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800343:	48 89 d6             	mov    %rdx,%rsi
  800346:	89 c7                	mov    %eax,%edi
  800348:	48 b8 a2 01 80 00 00 	movabs $0x8001a2,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800354:	48 b8 64 03 80 00 00 	movabs $0x800364,%rax
  80035b:	00 00 00 
  80035e:	ff d0                	callq  *%rax
}
  800360:	c9                   	leaveq 
  800361:	c3                   	retq   
	...

0000000000800364 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800368:	48 b8 39 21 80 00 00 	movabs $0x802139,%rax
  80036f:	00 00 00 
  800372:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800374:	bf 00 00 00 00       	mov    $0x0,%edi
  800379:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  800380:	00 00 00 
  800383:	ff d0                	callq  *%rax
}
  800385:	5d                   	pop    %rbp
  800386:	c3                   	retq   
	...

0000000000800388 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	53                   	push   %rbx
  80038d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800394:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80039b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003a1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8003a8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8003af:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8003b6:	84 c0                	test   %al,%al
  8003b8:	74 23                	je     8003dd <_panic+0x55>
  8003ba:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8003c1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8003c5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8003c9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003cd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003d1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003d5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003d9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003dd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003e4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003eb:	00 00 00 
  8003ee:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003f5:	00 00 00 
  8003f8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003fc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800403:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80040a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800411:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800418:	00 00 00 
  80041b:	48 8b 18             	mov    (%rax),%rbx
  80041e:	48 b8 3c 1a 80 00 00 	movabs $0x801a3c,%rax
  800425:	00 00 00 
  800428:	ff d0                	callq  *%rax
  80042a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800430:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800437:	41 89 c8             	mov    %ecx,%r8d
  80043a:	48 89 d1             	mov    %rdx,%rcx
  80043d:	48 89 da             	mov    %rbx,%rdx
  800440:	89 c6                	mov    %eax,%esi
  800442:	48 bf a8 41 80 00 00 	movabs $0x8041a8,%rdi
  800449:	00 00 00 
  80044c:	b8 00 00 00 00       	mov    $0x0,%eax
  800451:	49 b9 c3 05 80 00 00 	movabs $0x8005c3,%r9
  800458:	00 00 00 
  80045b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80045e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800465:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80046c:	48 89 d6             	mov    %rdx,%rsi
  80046f:	48 89 c7             	mov    %rax,%rdi
  800472:	48 b8 17 05 80 00 00 	movabs $0x800517,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
	cprintf("\n");
  80047e:	48 bf cb 41 80 00 00 	movabs $0x8041cb,%rdi
  800485:	00 00 00 
  800488:	b8 00 00 00 00       	mov    $0x0,%eax
  80048d:	48 ba c3 05 80 00 00 	movabs $0x8005c3,%rdx
  800494:	00 00 00 
  800497:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800499:	cc                   	int3   
  80049a:	eb fd                	jmp    800499 <_panic+0x111>

000000000080049c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp
  8004a0:	48 83 ec 10          	sub    $0x10,%rsp
  8004a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8004ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004af:	8b 00                	mov    (%rax),%eax
  8004b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8004b4:	89 d6                	mov    %edx,%esi
  8004b6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004ba:	48 63 d0             	movslq %eax,%rdx
  8004bd:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8004c2:	8d 50 01             	lea    0x1(%rax),%edx
  8004c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004c9:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8004cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cf:	8b 00                	mov    (%rax),%eax
  8004d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d6:	75 2c                	jne    800504 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8004d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004dc:	8b 00                	mov    (%rax),%eax
  8004de:	48 98                	cltq   
  8004e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004e4:	48 83 c2 08          	add    $0x8,%rdx
  8004e8:	48 89 c6             	mov    %rax,%rsi
  8004eb:	48 89 d7             	mov    %rdx,%rdi
  8004ee:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
		b->idx = 0;
  8004fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004fe:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800508:	8b 40 04             	mov    0x4(%rax),%eax
  80050b:	8d 50 01             	lea    0x1(%rax),%edx
  80050e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800512:	89 50 04             	mov    %edx,0x4(%rax)
}
  800515:	c9                   	leaveq 
  800516:	c3                   	retq   

0000000000800517 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800517:	55                   	push   %rbp
  800518:	48 89 e5             	mov    %rsp,%rbp
  80051b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800522:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800529:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800530:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800537:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80053e:	48 8b 0a             	mov    (%rdx),%rcx
  800541:	48 89 08             	mov    %rcx,(%rax)
  800544:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800548:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80054c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800550:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800554:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80055b:	00 00 00 
	b.cnt = 0;
  80055e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800565:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800568:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80056f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800576:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80057d:	48 89 c6             	mov    %rax,%rsi
  800580:	48 bf 9c 04 80 00 00 	movabs $0x80049c,%rdi
  800587:	00 00 00 
  80058a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800591:	00 00 00 
  800594:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800596:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80059c:	48 98                	cltq   
  80059e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005a5:	48 83 c2 08          	add    $0x8,%rdx
  8005a9:	48 89 c6             	mov    %rax,%rsi
  8005ac:	48 89 d7             	mov    %rdx,%rdi
  8005af:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8005bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8005ce:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005d5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005f1:	84 c0                	test   %al,%al
  8005f3:	74 20                	je     800615 <cprintf+0x52>
  8005f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800601:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800605:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800609:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80060d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800611:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800615:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80061c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800623:	00 00 00 
  800626:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80062d:	00 00 00 
  800630:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800634:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80063b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800642:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800649:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800650:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800657:	48 8b 0a             	mov    (%rdx),%rcx
  80065a:	48 89 08             	mov    %rcx,(%rax)
  80065d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800661:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800665:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800669:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80066d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800674:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80067b:	48 89 d6             	mov    %rdx,%rsi
  80067e:	48 89 c7             	mov    %rax,%rdi
  800681:	48 b8 17 05 80 00 00 	movabs $0x800517,%rax
  800688:	00 00 00 
  80068b:	ff d0                	callq  *%rax
  80068d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800693:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800699:	c9                   	leaveq 
  80069a:	c3                   	retq   
	...

000000000080069c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069c:	55                   	push   %rbp
  80069d:	48 89 e5             	mov    %rsp,%rbp
  8006a0:	48 83 ec 30          	sub    $0x30,%rsp
  8006a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8006b0:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8006b3:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8006b7:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006bb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8006be:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8006c2:	77 52                	ja     800716 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8006c7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8006cb:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8006ce:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8006d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	48 f7 75 d0          	divq   -0x30(%rbp)
  8006df:	48 89 c2             	mov    %rax,%rdx
  8006e2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8006e5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006e8:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8006ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f0:	41 89 f9             	mov    %edi,%r9d
  8006f3:	48 89 c7             	mov    %rax,%rdi
  8006f6:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  8006fd:	00 00 00 
  800700:	ff d0                	callq  *%rax
  800702:	eb 1c                	jmp    800720 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800704:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800708:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80070b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80070f:	48 89 d6             	mov    %rdx,%rsi
  800712:	89 c7                	mov    %eax,%edi
  800714:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80071a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80071e:	7f e4                	jg     800704 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800720:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	48 f7 f1             	div    %rcx
  80072f:	48 89 d0             	mov    %rdx,%rax
  800732:	48 ba a8 43 80 00 00 	movabs $0x8043a8,%rdx
  800739:	00 00 00 
  80073c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800740:	0f be c0             	movsbl %al,%eax
  800743:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800747:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80074b:	48 89 d6             	mov    %rdx,%rsi
  80074e:	89 c7                	mov    %eax,%edi
  800750:	ff d1                	callq  *%rcx
}
  800752:	c9                   	leaveq 
  800753:	c3                   	retq   

0000000000800754 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800754:	55                   	push   %rbp
  800755:	48 89 e5             	mov    %rsp,%rbp
  800758:	48 83 ec 20          	sub    $0x20,%rsp
  80075c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800760:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800763:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800767:	7e 52                	jle    8007bb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	83 f8 30             	cmp    $0x30,%eax
  800772:	73 24                	jae    800798 <getuint+0x44>
  800774:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800778:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	89 c0                	mov    %eax,%eax
  800784:	48 01 d0             	add    %rdx,%rax
  800787:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078b:	8b 12                	mov    (%rdx),%edx
  80078d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	89 0a                	mov    %ecx,(%rdx)
  800796:	eb 17                	jmp    8007af <getuint+0x5b>
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a0:	48 89 d0             	mov    %rdx,%rax
  8007a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007af:	48 8b 00             	mov    (%rax),%rax
  8007b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b6:	e9 a3 00 00 00       	jmpq   80085e <getuint+0x10a>
	else if (lflag)
  8007bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bf:	74 4f                	je     800810 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8007c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	83 f8 30             	cmp    $0x30,%eax
  8007ca:	73 24                	jae    8007f0 <getuint+0x9c>
  8007cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	89 c0                	mov    %eax,%eax
  8007dc:	48 01 d0             	add    %rdx,%rax
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	8b 12                	mov    (%rdx),%edx
  8007e5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ec:	89 0a                	mov    %ecx,(%rdx)
  8007ee:	eb 17                	jmp    800807 <getuint+0xb3>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f8:	48 89 d0             	mov    %rdx,%rax
  8007fb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800803:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800807:	48 8b 00             	mov    (%rax),%rax
  80080a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080e:	eb 4e                	jmp    80085e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	8b 00                	mov    (%rax),%eax
  800816:	83 f8 30             	cmp    $0x30,%eax
  800819:	73 24                	jae    80083f <getuint+0xeb>
  80081b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	8b 00                	mov    (%rax),%eax
  800829:	89 c0                	mov    %eax,%eax
  80082b:	48 01 d0             	add    %rdx,%rax
  80082e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800832:	8b 12                	mov    (%rdx),%edx
  800834:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	89 0a                	mov    %ecx,(%rdx)
  80083d:	eb 17                	jmp    800856 <getuint+0x102>
  80083f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800843:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800847:	48 89 d0             	mov    %rdx,%rax
  80084a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800852:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800856:	8b 00                	mov    (%rax),%eax
  800858:	89 c0                	mov    %eax,%eax
  80085a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800862:	c9                   	leaveq 
  800863:	c3                   	retq   

0000000000800864 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800864:	55                   	push   %rbp
  800865:	48 89 e5             	mov    %rsp,%rbp
  800868:	48 83 ec 20          	sub    $0x20,%rsp
  80086c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800870:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800873:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800877:	7e 52                	jle    8008cb <getint+0x67>
		x=va_arg(*ap, long long);
  800879:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087d:	8b 00                	mov    (%rax),%eax
  80087f:	83 f8 30             	cmp    $0x30,%eax
  800882:	73 24                	jae    8008a8 <getint+0x44>
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	89 c0                	mov    %eax,%eax
  800894:	48 01 d0             	add    %rdx,%rax
  800897:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80089b:	8b 12                	mov    (%rdx),%edx
  80089d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a4:	89 0a                	mov    %ecx,(%rdx)
  8008a6:	eb 17                	jmp    8008bf <getint+0x5b>
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008bf:	48 8b 00             	mov    (%rax),%rax
  8008c2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008c6:	e9 a3 00 00 00       	jmpq   80096e <getint+0x10a>
	else if (lflag)
  8008cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008cf:	74 4f                	je     800920 <getint+0xbc>
		x=va_arg(*ap, long);
  8008d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d5:	8b 00                	mov    (%rax),%eax
  8008d7:	83 f8 30             	cmp    $0x30,%eax
  8008da:	73 24                	jae    800900 <getint+0x9c>
  8008dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e8:	8b 00                	mov    (%rax),%eax
  8008ea:	89 c0                	mov    %eax,%eax
  8008ec:	48 01 d0             	add    %rdx,%rax
  8008ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f3:	8b 12                	mov    (%rdx),%edx
  8008f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fc:	89 0a                	mov    %ecx,(%rdx)
  8008fe:	eb 17                	jmp    800917 <getint+0xb3>
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800908:	48 89 d0             	mov    %rdx,%rax
  80090b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80090f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800913:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800917:	48 8b 00             	mov    (%rax),%rax
  80091a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091e:	eb 4e                	jmp    80096e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800920:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800924:	8b 00                	mov    (%rax),%eax
  800926:	83 f8 30             	cmp    $0x30,%eax
  800929:	73 24                	jae    80094f <getint+0xeb>
  80092b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800937:	8b 00                	mov    (%rax),%eax
  800939:	89 c0                	mov    %eax,%eax
  80093b:	48 01 d0             	add    %rdx,%rax
  80093e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800942:	8b 12                	mov    (%rdx),%edx
  800944:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800947:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094b:	89 0a                	mov    %ecx,(%rdx)
  80094d:	eb 17                	jmp    800966 <getint+0x102>
  80094f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800953:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800957:	48 89 d0             	mov    %rdx,%rax
  80095a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80095e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800962:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800966:	8b 00                	mov    (%rax),%eax
  800968:	48 98                	cltq   
  80096a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80096e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800972:	c9                   	leaveq 
  800973:	c3                   	retq   

0000000000800974 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800974:	55                   	push   %rbp
  800975:	48 89 e5             	mov    %rsp,%rbp
  800978:	41 54                	push   %r12
  80097a:	53                   	push   %rbx
  80097b:	48 83 ec 60          	sub    $0x60,%rsp
  80097f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800983:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800987:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80098b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80098f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800993:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800997:	48 8b 0a             	mov    (%rdx),%rcx
  80099a:	48 89 08             	mov    %rcx,(%rax)
  80099d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009a1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009a5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8009a9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ad:	eb 17                	jmp    8009c6 <vprintfmt+0x52>
			if (ch == '\0')
  8009af:	85 db                	test   %ebx,%ebx
  8009b1:	0f 84 d7 04 00 00    	je     800e8e <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8009b7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8009bb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8009bf:	48 89 c6             	mov    %rax,%rsi
  8009c2:	89 df                	mov    %ebx,%edi
  8009c4:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009c6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009ca:	0f b6 00             	movzbl (%rax),%eax
  8009cd:	0f b6 d8             	movzbl %al,%ebx
  8009d0:	83 fb 25             	cmp    $0x25,%ebx
  8009d3:	0f 95 c0             	setne  %al
  8009d6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8009db:	84 c0                	test   %al,%al
  8009dd:	75 d0                	jne    8009af <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009df:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009e3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009f8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8009ff:	eb 04                	jmp    800a05 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a01:	90                   	nop
  800a02:	eb 01                	jmp    800a05 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a04:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a05:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a09:	0f b6 00             	movzbl (%rax),%eax
  800a0c:	0f b6 d8             	movzbl %al,%ebx
  800a0f:	89 d8                	mov    %ebx,%eax
  800a11:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a16:	83 e8 23             	sub    $0x23,%eax
  800a19:	83 f8 55             	cmp    $0x55,%eax
  800a1c:	0f 87 38 04 00 00    	ja     800e5a <vprintfmt+0x4e6>
  800a22:	89 c0                	mov    %eax,%eax
  800a24:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a2b:	00 
  800a2c:	48 b8 d0 43 80 00 00 	movabs $0x8043d0,%rax
  800a33:	00 00 00 
  800a36:	48 01 d0             	add    %rdx,%rax
  800a39:	48 8b 00             	mov    (%rax),%rax
  800a3c:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a3e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a42:	eb c1                	jmp    800a05 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a44:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a48:	eb bb                	jmp    800a05 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a51:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a54:	89 d0                	mov    %edx,%eax
  800a56:	c1 e0 02             	shl    $0x2,%eax
  800a59:	01 d0                	add    %edx,%eax
  800a5b:	01 c0                	add    %eax,%eax
  800a5d:	01 d8                	add    %ebx,%eax
  800a5f:	83 e8 30             	sub    $0x30,%eax
  800a62:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a65:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a69:	0f b6 00             	movzbl (%rax),%eax
  800a6c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a6f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a72:	7e 63                	jle    800ad7 <vprintfmt+0x163>
  800a74:	83 fb 39             	cmp    $0x39,%ebx
  800a77:	7f 5e                	jg     800ad7 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a79:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7e:	eb d1                	jmp    800a51 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a83:	83 f8 30             	cmp    $0x30,%eax
  800a86:	73 17                	jae    800a9f <vprintfmt+0x12b>
  800a88:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8f:	89 c0                	mov    %eax,%eax
  800a91:	48 01 d0             	add    %rdx,%rax
  800a94:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a97:	83 c2 08             	add    $0x8,%edx
  800a9a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9d:	eb 0f                	jmp    800aae <vprintfmt+0x13a>
  800a9f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa3:	48 89 d0             	mov    %rdx,%rax
  800aa6:	48 83 c2 08          	add    $0x8,%rdx
  800aaa:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aae:	8b 00                	mov    (%rax),%eax
  800ab0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800ab3:	eb 23                	jmp    800ad8 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800ab5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab9:	0f 89 42 ff ff ff    	jns    800a01 <vprintfmt+0x8d>
				width = 0;
  800abf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ac6:	e9 36 ff ff ff       	jmpq   800a01 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800acb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800ad2:	e9 2e ff ff ff       	jmpq   800a05 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ad7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ad8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800adc:	0f 89 22 ff ff ff    	jns    800a04 <vprintfmt+0x90>
				width = precision, precision = -1;
  800ae2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ae8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800aef:	e9 10 ff ff ff       	jmpq   800a04 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800af4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800af8:	e9 08 ff ff ff       	jmpq   800a05 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800afd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b00:	83 f8 30             	cmp    $0x30,%eax
  800b03:	73 17                	jae    800b1c <vprintfmt+0x1a8>
  800b05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0c:	89 c0                	mov    %eax,%eax
  800b0e:	48 01 d0             	add    %rdx,%rax
  800b11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b14:	83 c2 08             	add    $0x8,%edx
  800b17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b1a:	eb 0f                	jmp    800b2b <vprintfmt+0x1b7>
  800b1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b20:	48 89 d0             	mov    %rdx,%rax
  800b23:	48 83 c2 08          	add    $0x8,%rdx
  800b27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2b:	8b 00                	mov    (%rax),%eax
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	89 c7                	mov    %eax,%edi
  800b3a:	ff d1                	callq  *%rcx
			break;
  800b3c:	e9 47 03 00 00       	jmpq   800e88 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800b41:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b44:	83 f8 30             	cmp    $0x30,%eax
  800b47:	73 17                	jae    800b60 <vprintfmt+0x1ec>
  800b49:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b50:	89 c0                	mov    %eax,%eax
  800b52:	48 01 d0             	add    %rdx,%rax
  800b55:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b58:	83 c2 08             	add    $0x8,%edx
  800b5b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b5e:	eb 0f                	jmp    800b6f <vprintfmt+0x1fb>
  800b60:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b64:	48 89 d0             	mov    %rdx,%rax
  800b67:	48 83 c2 08          	add    $0x8,%rdx
  800b6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b6f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b71:	85 db                	test   %ebx,%ebx
  800b73:	79 02                	jns    800b77 <vprintfmt+0x203>
				err = -err;
  800b75:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b77:	83 fb 10             	cmp    $0x10,%ebx
  800b7a:	7f 16                	jg     800b92 <vprintfmt+0x21e>
  800b7c:	48 b8 20 43 80 00 00 	movabs $0x804320,%rax
  800b83:	00 00 00 
  800b86:	48 63 d3             	movslq %ebx,%rdx
  800b89:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b8d:	4d 85 e4             	test   %r12,%r12
  800b90:	75 2e                	jne    800bc0 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9a:	89 d9                	mov    %ebx,%ecx
  800b9c:	48 ba b9 43 80 00 00 	movabs $0x8043b9,%rdx
  800ba3:	00 00 00 
  800ba6:	48 89 c7             	mov    %rax,%rdi
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bae:	49 b8 98 0e 80 00 00 	movabs $0x800e98,%r8
  800bb5:	00 00 00 
  800bb8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bbb:	e9 c8 02 00 00       	jmpq   800e88 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc8:	4c 89 e1             	mov    %r12,%rcx
  800bcb:	48 ba c2 43 80 00 00 	movabs $0x8043c2,%rdx
  800bd2:	00 00 00 
  800bd5:	48 89 c7             	mov    %rax,%rdi
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	49 b8 98 0e 80 00 00 	movabs $0x800e98,%r8
  800be4:	00 00 00 
  800be7:	41 ff d0             	callq  *%r8
			break;
  800bea:	e9 99 02 00 00       	jmpq   800e88 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf2:	83 f8 30             	cmp    $0x30,%eax
  800bf5:	73 17                	jae    800c0e <vprintfmt+0x29a>
  800bf7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bfb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bfe:	89 c0                	mov    %eax,%eax
  800c00:	48 01 d0             	add    %rdx,%rax
  800c03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c06:	83 c2 08             	add    $0x8,%edx
  800c09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c0c:	eb 0f                	jmp    800c1d <vprintfmt+0x2a9>
  800c0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c12:	48 89 d0             	mov    %rdx,%rax
  800c15:	48 83 c2 08          	add    $0x8,%rdx
  800c19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c1d:	4c 8b 20             	mov    (%rax),%r12
  800c20:	4d 85 e4             	test   %r12,%r12
  800c23:	75 0a                	jne    800c2f <vprintfmt+0x2bb>
				p = "(null)";
  800c25:	49 bc c5 43 80 00 00 	movabs $0x8043c5,%r12
  800c2c:	00 00 00 
			if (width > 0 && padc != '-')
  800c2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c33:	7e 7a                	jle    800caf <vprintfmt+0x33b>
  800c35:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c39:	74 74                	je     800caf <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c3b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c3e:	48 98                	cltq   
  800c40:	48 89 c6             	mov    %rax,%rsi
  800c43:	4c 89 e7             	mov    %r12,%rdi
  800c46:	48 b8 42 11 80 00 00 	movabs $0x801142,%rax
  800c4d:	00 00 00 
  800c50:	ff d0                	callq  *%rax
  800c52:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c55:	eb 17                	jmp    800c6e <vprintfmt+0x2fa>
					putch(padc, putdat);
  800c57:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800c5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c5f:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c63:	48 89 d6             	mov    %rdx,%rsi
  800c66:	89 c7                	mov    %eax,%edi
  800c68:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c72:	7f e3                	jg     800c57 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c74:	eb 39                	jmp    800caf <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800c76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c7a:	74 1e                	je     800c9a <vprintfmt+0x326>
  800c7c:	83 fb 1f             	cmp    $0x1f,%ebx
  800c7f:	7e 05                	jle    800c86 <vprintfmt+0x312>
  800c81:	83 fb 7e             	cmp    $0x7e,%ebx
  800c84:	7e 14                	jle    800c9a <vprintfmt+0x326>
					putch('?', putdat);
  800c86:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c8a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8e:	48 89 c6             	mov    %rax,%rsi
  800c91:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c96:	ff d2                	callq  *%rdx
  800c98:	eb 0f                	jmp    800ca9 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c9a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c9e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca2:	48 89 c6             	mov    %rax,%rsi
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cad:	eb 01                	jmp    800cb0 <vprintfmt+0x33c>
  800caf:	90                   	nop
  800cb0:	41 0f b6 04 24       	movzbl (%r12),%eax
  800cb5:	0f be d8             	movsbl %al,%ebx
  800cb8:	85 db                	test   %ebx,%ebx
  800cba:	0f 95 c0             	setne  %al
  800cbd:	49 83 c4 01          	add    $0x1,%r12
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 28                	je     800ced <vprintfmt+0x379>
  800cc5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cc9:	78 ab                	js     800c76 <vprintfmt+0x302>
  800ccb:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ccf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800cd3:	79 a1                	jns    800c76 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd5:	eb 16                	jmp    800ced <vprintfmt+0x379>
				putch(' ', putdat);
  800cd7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cdb:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cdf:	48 89 c6             	mov    %rax,%rsi
  800ce2:	bf 20 00 00 00       	mov    $0x20,%edi
  800ce7:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ced:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cf1:	7f e4                	jg     800cd7 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800cf3:	e9 90 01 00 00       	jmpq   800e88 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cf8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cfc:	be 03 00 00 00       	mov    $0x3,%esi
  800d01:	48 89 c7             	mov    %rax,%rdi
  800d04:	48 b8 64 08 80 00 00 	movabs $0x800864,%rax
  800d0b:	00 00 00 
  800d0e:	ff d0                	callq  *%rax
  800d10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d18:	48 85 c0             	test   %rax,%rax
  800d1b:	79 1d                	jns    800d3a <vprintfmt+0x3c6>
				putch('-', putdat);
  800d1d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d21:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d25:	48 89 c6             	mov    %rax,%rsi
  800d28:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d2d:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800d2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d33:	48 f7 d8             	neg    %rax
  800d36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d3a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d41:	e9 d5 00 00 00       	jmpq   800e1b <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d4a:	be 03 00 00 00       	mov    $0x3,%esi
  800d4f:	48 89 c7             	mov    %rax,%rdi
  800d52:	48 b8 54 07 80 00 00 	movabs $0x800754,%rax
  800d59:	00 00 00 
  800d5c:	ff d0                	callq  *%rax
  800d5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d62:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d69:	e9 ad 00 00 00       	jmpq   800e1b <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800d6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d72:	be 03 00 00 00       	mov    $0x3,%esi
  800d77:	48 89 c7             	mov    %rax,%rdi
  800d7a:	48 b8 54 07 80 00 00 	movabs $0x800754,%rax
  800d81:	00 00 00 
  800d84:	ff d0                	callq  *%rax
  800d86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800d8a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d91:	e9 85 00 00 00       	jmpq   800e1b <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800d96:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d9e:	48 89 c6             	mov    %rax,%rsi
  800da1:	bf 30 00 00 00       	mov    $0x30,%edi
  800da6:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800da8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dac:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db0:	48 89 c6             	mov    %rax,%rsi
  800db3:	bf 78 00 00 00       	mov    $0x78,%edi
  800db8:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800dba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dbd:	83 f8 30             	cmp    $0x30,%eax
  800dc0:	73 17                	jae    800dd9 <vprintfmt+0x465>
  800dc2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dc6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dc9:	89 c0                	mov    %eax,%eax
  800dcb:	48 01 d0             	add    %rdx,%rax
  800dce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dd1:	83 c2 08             	add    $0x8,%edx
  800dd4:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dd7:	eb 0f                	jmp    800de8 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800dd9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ddd:	48 89 d0             	mov    %rdx,%rax
  800de0:	48 83 c2 08          	add    $0x8,%rdx
  800de4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800de8:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800deb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800def:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800df6:	eb 23                	jmp    800e1b <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800df8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dfc:	be 03 00 00 00       	mov    $0x3,%esi
  800e01:	48 89 c7             	mov    %rax,%rdi
  800e04:	48 b8 54 07 80 00 00 	movabs $0x800754,%rax
  800e0b:	00 00 00 
  800e0e:	ff d0                	callq  *%rax
  800e10:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e14:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e1b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e20:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e23:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	45 89 c1             	mov    %r8d,%r9d
  800e35:	41 89 f8             	mov    %edi,%r8d
  800e38:	48 89 c7             	mov    %rax,%rdi
  800e3b:	48 b8 9c 06 80 00 00 	movabs $0x80069c,%rax
  800e42:	00 00 00 
  800e45:	ff d0                	callq  *%rax
			break;
  800e47:	eb 3f                	jmp    800e88 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e49:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e4d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e51:	48 89 c6             	mov    %rax,%rsi
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	ff d2                	callq  *%rdx
			break;
  800e58:	eb 2e                	jmp    800e88 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e5a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e5e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e62:	48 89 c6             	mov    %rax,%rsi
  800e65:	bf 25 00 00 00       	mov    $0x25,%edi
  800e6a:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e6c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e71:	eb 05                	jmp    800e78 <vprintfmt+0x504>
  800e73:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e78:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e7c:	48 83 e8 01          	sub    $0x1,%rax
  800e80:	0f b6 00             	movzbl (%rax),%eax
  800e83:	3c 25                	cmp    $0x25,%al
  800e85:	75 ec                	jne    800e73 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800e87:	90                   	nop
		}
	}
  800e88:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e89:	e9 38 fb ff ff       	jmpq   8009c6 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e8e:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800e8f:	48 83 c4 60          	add    $0x60,%rsp
  800e93:	5b                   	pop    %rbx
  800e94:	41 5c                	pop    %r12
  800e96:	5d                   	pop    %rbp
  800e97:	c3                   	retq   

0000000000800e98 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
  800e9c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ea3:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800eaa:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800eb1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800eb8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ebf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ec6:	84 c0                	test   %al,%al
  800ec8:	74 20                	je     800eea <printfmt+0x52>
  800eca:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ece:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ed2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ed6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eda:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ede:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ee2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ee6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eea:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ef1:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ef8:	00 00 00 
  800efb:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f02:	00 00 00 
  800f05:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f09:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f10:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f17:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f1e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f25:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800f2c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800f33:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f3a:	48 89 c7             	mov    %rax,%rdi
  800f3d:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  800f44:	00 00 00 
  800f47:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f49:	c9                   	leaveq 
  800f4a:	c3                   	retq   

0000000000800f4b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4b:	55                   	push   %rbp
  800f4c:	48 89 e5             	mov    %rsp,%rbp
  800f4f:	48 83 ec 10          	sub    $0x10,%rsp
  800f53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5e:	8b 40 10             	mov    0x10(%rax),%eax
  800f61:	8d 50 01             	lea    0x1(%rax),%edx
  800f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f68:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f6f:	48 8b 10             	mov    (%rax),%rdx
  800f72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f76:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f7a:	48 39 c2             	cmp    %rax,%rdx
  800f7d:	73 17                	jae    800f96 <sprintputch+0x4b>
		*b->buf++ = ch;
  800f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f83:	48 8b 00             	mov    (%rax),%rax
  800f86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f89:	88 10                	mov    %dl,(%rax)
  800f8b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f93:	48 89 10             	mov    %rdx,(%rax)
}
  800f96:	c9                   	leaveq 
  800f97:	c3                   	retq   

0000000000800f98 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f98:	55                   	push   %rbp
  800f99:	48 89 e5             	mov    %rsp,%rbp
  800f9c:	48 83 ec 50          	sub    $0x50,%rsp
  800fa0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800fa4:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800fa7:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800fab:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800faf:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800fb3:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800fb7:	48 8b 0a             	mov    (%rdx),%rcx
  800fba:	48 89 08             	mov    %rcx,(%rax)
  800fbd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fc5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fcd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800fd5:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800fd8:	48 98                	cltq   
  800fda:	48 83 e8 01          	sub    $0x1,%rax
  800fde:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800fe2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fe6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fed:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ff2:	74 06                	je     800ffa <vsnprintf+0x62>
  800ff4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ff8:	7f 07                	jg     801001 <vsnprintf+0x69>
		return -E_INVAL;
  800ffa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fff:	eb 2f                	jmp    801030 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801001:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801005:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801009:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80100d:	48 89 c6             	mov    %rax,%rsi
  801010:	48 bf 4b 0f 80 00 00 	movabs $0x800f4b,%rdi
  801017:	00 00 00 
  80101a:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  801021:	00 00 00 
  801024:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801026:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80102a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80102d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801030:	c9                   	leaveq 
  801031:	c3                   	retq   

0000000000801032 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801032:	55                   	push   %rbp
  801033:	48 89 e5             	mov    %rsp,%rbp
  801036:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80103d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801044:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80104a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801051:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801058:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105f:	84 c0                	test   %al,%al
  801061:	74 20                	je     801083 <snprintf+0x51>
  801063:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801067:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80106b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801073:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801077:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80107b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801083:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80108a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801091:	00 00 00 
  801094:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80109b:	00 00 00 
  80109e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8010a9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010b0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8010b7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8010be:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8010c5:	48 8b 0a             	mov    (%rdx),%rcx
  8010c8:	48 89 08             	mov    %rcx,(%rax)
  8010cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010db:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010e2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010e9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	48 b8 98 0f 80 00 00 	movabs $0x800f98,%rax
  801100:	00 00 00 
  801103:	ff d0                	callq  *%rax
  801105:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80110b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   
	...

0000000000801114 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801114:	55                   	push   %rbp
  801115:	48 89 e5             	mov    %rsp,%rbp
  801118:	48 83 ec 18          	sub    $0x18,%rsp
  80111c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801127:	eb 09                	jmp    801132 <strlen+0x1e>
		n++;
  801129:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80112d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	0f b6 00             	movzbl (%rax),%eax
  801139:	84 c0                	test   %al,%al
  80113b:	75 ec                	jne    801129 <strlen+0x15>
		n++;
	return n;
  80113d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801140:	c9                   	leaveq 
  801141:	c3                   	retq   

0000000000801142 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801142:	55                   	push   %rbp
  801143:	48 89 e5             	mov    %rsp,%rbp
  801146:	48 83 ec 20          	sub    $0x20,%rsp
  80114a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801152:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801159:	eb 0e                	jmp    801169 <strnlen+0x27>
		n++;
  80115b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80115f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801164:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801169:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80116e:	74 0b                	je     80117b <strnlen+0x39>
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	0f b6 00             	movzbl (%rax),%eax
  801177:	84 c0                	test   %al,%al
  801179:	75 e0                	jne    80115b <strnlen+0x19>
		n++;
	return n;
  80117b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80117e:	c9                   	leaveq 
  80117f:	c3                   	retq   

0000000000801180 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801180:	55                   	push   %rbp
  801181:	48 89 e5             	mov    %rsp,%rbp
  801184:	48 83 ec 20          	sub    $0x20,%rsp
  801188:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801194:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801198:	90                   	nop
  801199:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119d:	0f b6 10             	movzbl (%rax),%edx
  8011a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a4:	88 10                	mov    %dl,(%rax)
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	84 c0                	test   %al,%al
  8011af:	0f 95 c0             	setne  %al
  8011b2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011b7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 d9                	jne    801199 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8011c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c4:	c9                   	leaveq 
  8011c5:	c3                   	retq   

00000000008011c6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8011c6:	55                   	push   %rbp
  8011c7:	48 89 e5             	mov    %rsp,%rbp
  8011ca:	48 83 ec 20          	sub    $0x20,%rsp
  8011ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8011d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011da:	48 89 c7             	mov    %rax,%rdi
  8011dd:	48 b8 14 11 80 00 00 	movabs $0x801114,%rax
  8011e4:	00 00 00 
  8011e7:	ff d0                	callq  *%rax
  8011e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011ef:	48 98                	cltq   
  8011f1:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8011f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011f9:	48 89 d6             	mov    %rdx,%rsi
  8011fc:	48 89 c7             	mov    %rax,%rdi
  8011ff:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  801206:	00 00 00 
  801209:	ff d0                	callq  *%rax
	return dst;
  80120b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 28          	sub    $0x28,%rsp
  801219:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801221:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801225:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801229:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80122d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801234:	00 
  801235:	eb 27                	jmp    80125e <strncpy+0x4d>
		*dst++ = *src;
  801237:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123b:	0f b6 10             	movzbl (%rax),%edx
  80123e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801242:	88 10                	mov    %dl,(%rax)
  801244:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801249:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80124d:	0f b6 00             	movzbl (%rax),%eax
  801250:	84 c0                	test   %al,%al
  801252:	74 05                	je     801259 <strncpy+0x48>
			src++;
  801254:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801259:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80125e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801262:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801266:	72 cf                	jb     801237 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80126c:	c9                   	leaveq 
  80126d:	c3                   	retq   

000000000080126e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80126e:	55                   	push   %rbp
  80126f:	48 89 e5             	mov    %rsp,%rbp
  801272:	48 83 ec 28          	sub    $0x28,%rsp
  801276:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80127a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80127e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801286:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80128a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80128f:	74 37                	je     8012c8 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801291:	eb 17                	jmp    8012aa <strlcpy+0x3c>
			*dst++ = *src++;
  801293:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801297:	0f b6 10             	movzbl (%rax),%edx
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129e:	88 10                	mov    %dl,(%rax)
  8012a0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012a5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8012aa:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8012af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8012b4:	74 0b                	je     8012c1 <strlcpy+0x53>
  8012b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012ba:	0f b6 00             	movzbl (%rax),%eax
  8012bd:	84 c0                	test   %al,%al
  8012bf:	75 d2                	jne    801293 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8012c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8012c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d0:	48 89 d1             	mov    %rdx,%rcx
  8012d3:	48 29 c1             	sub    %rax,%rcx
  8012d6:	48 89 c8             	mov    %rcx,%rax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 10          	sub    $0x10,%rsp
  8012e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012eb:	eb 0a                	jmp    8012f7 <strcmp+0x1c>
		p++, q++;
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fb:	0f b6 00             	movzbl (%rax),%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	74 12                	je     801314 <strcmp+0x39>
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	0f b6 10             	movzbl (%rax),%edx
  801309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	38 c2                	cmp    %al,%dl
  801312:	74 d9                	je     8012ed <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801314:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801318:	0f b6 00             	movzbl (%rax),%eax
  80131b:	0f b6 d0             	movzbl %al,%edx
  80131e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801322:	0f b6 00             	movzbl (%rax),%eax
  801325:	0f b6 c0             	movzbl %al,%eax
  801328:	89 d1                	mov    %edx,%ecx
  80132a:	29 c1                	sub    %eax,%ecx
  80132c:	89 c8                	mov    %ecx,%eax
}
  80132e:	c9                   	leaveq 
  80132f:	c3                   	retq   

0000000000801330 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801330:	55                   	push   %rbp
  801331:	48 89 e5             	mov    %rsp,%rbp
  801334:	48 83 ec 18          	sub    $0x18,%rsp
  801338:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801340:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801344:	eb 0f                	jmp    801355 <strncmp+0x25>
		n--, p++, q++;
  801346:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80134b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801350:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801355:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80135a:	74 1d                	je     801379 <strncmp+0x49>
  80135c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	84 c0                	test   %al,%al
  801365:	74 12                	je     801379 <strncmp+0x49>
  801367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136b:	0f b6 10             	movzbl (%rax),%edx
  80136e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801372:	0f b6 00             	movzbl (%rax),%eax
  801375:	38 c2                	cmp    %al,%dl
  801377:	74 cd                	je     801346 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801379:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80137e:	75 07                	jne    801387 <strncmp+0x57>
		return 0;
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	eb 1a                	jmp    8013a1 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 00             	movzbl (%rax),%eax
  80138e:	0f b6 d0             	movzbl %al,%edx
  801391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801395:	0f b6 00             	movzbl (%rax),%eax
  801398:	0f b6 c0             	movzbl %al,%eax
  80139b:	89 d1                	mov    %edx,%ecx
  80139d:	29 c1                	sub    %eax,%ecx
  80139f:	89 c8                	mov    %ecx,%eax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 10          	sub    $0x10,%rsp
  8013ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013af:	89 f0                	mov    %esi,%eax
  8013b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013b4:	eb 17                	jmp    8013cd <strchr+0x2a>
		if (*s == c)
  8013b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ba:	0f b6 00             	movzbl (%rax),%eax
  8013bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c0:	75 06                	jne    8013c8 <strchr+0x25>
			return (char *) s;
  8013c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c6:	eb 15                	jmp    8013dd <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	84 c0                	test   %al,%al
  8013d6:	75 de                	jne    8013b6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013dd:	c9                   	leaveq 
  8013de:	c3                   	retq   

00000000008013df <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013df:	55                   	push   %rbp
  8013e0:	48 89 e5             	mov    %rsp,%rbp
  8013e3:	48 83 ec 10          	sub    $0x10,%rsp
  8013e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013eb:	89 f0                	mov    %esi,%eax
  8013ed:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013f0:	eb 11                	jmp    801403 <strfind+0x24>
		if (*s == c)
  8013f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f6:	0f b6 00             	movzbl (%rax),%eax
  8013f9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013fc:	74 12                	je     801410 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	84 c0                	test   %al,%al
  80140c:	75 e4                	jne    8013f2 <strfind+0x13>
  80140e:	eb 01                	jmp    801411 <strfind+0x32>
		if (*s == c)
			break;
  801410:	90                   	nop
	return (char *) s;
  801411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801415:	c9                   	leaveq 
  801416:	c3                   	retq   

0000000000801417 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	48 83 ec 18          	sub    $0x18,%rsp
  80141f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801423:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801426:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80142a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80142f:	75 06                	jne    801437 <memset+0x20>
		return v;
  801431:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801435:	eb 69                	jmp    8014a0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143b:	83 e0 03             	and    $0x3,%eax
  80143e:	48 85 c0             	test   %rax,%rax
  801441:	75 48                	jne    80148b <memset+0x74>
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	83 e0 03             	and    $0x3,%eax
  80144a:	48 85 c0             	test   %rax,%rax
  80144d:	75 3c                	jne    80148b <memset+0x74>
		c &= 0xFF;
  80144f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801456:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801459:	89 c2                	mov    %eax,%edx
  80145b:	c1 e2 18             	shl    $0x18,%edx
  80145e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801461:	c1 e0 10             	shl    $0x10,%eax
  801464:	09 c2                	or     %eax,%edx
  801466:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801469:	c1 e0 08             	shl    $0x8,%eax
  80146c:	09 d0                	or     %edx,%eax
  80146e:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801471:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801475:	48 89 c1             	mov    %rax,%rcx
  801478:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80147c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801480:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801483:	48 89 d7             	mov    %rdx,%rdi
  801486:	fc                   	cld    
  801487:	f3 ab                	rep stos %eax,%es:(%rdi)
  801489:	eb 11                	jmp    80149c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80148b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801492:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801496:	48 89 d7             	mov    %rdx,%rdi
  801499:	fc                   	cld    
  80149a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a0:	c9                   	leaveq 
  8014a1:	c3                   	retq   

00000000008014a2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8014a2:	55                   	push   %rbp
  8014a3:	48 89 e5             	mov    %rsp,%rbp
  8014a6:	48 83 ec 28          	sub    $0x28,%rsp
  8014aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8014b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8014be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8014c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ca:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ce:	0f 83 88 00 00 00    	jae    80155c <memmove+0xba>
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014dc:	48 01 d0             	add    %rdx,%rax
  8014df:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014e3:	76 77                	jbe    80155c <memmove+0xba>
		s += n;
  8014e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e9:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f9:	83 e0 03             	and    $0x3,%eax
  8014fc:	48 85 c0             	test   %rax,%rax
  8014ff:	75 3b                	jne    80153c <memmove+0x9a>
  801501:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801505:	83 e0 03             	and    $0x3,%eax
  801508:	48 85 c0             	test   %rax,%rax
  80150b:	75 2f                	jne    80153c <memmove+0x9a>
  80150d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801511:	83 e0 03             	and    $0x3,%eax
  801514:	48 85 c0             	test   %rax,%rax
  801517:	75 23                	jne    80153c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151d:	48 83 e8 04          	sub    $0x4,%rax
  801521:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801525:	48 83 ea 04          	sub    $0x4,%rdx
  801529:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801531:	48 89 c7             	mov    %rax,%rdi
  801534:	48 89 d6             	mov    %rdx,%rsi
  801537:	fd                   	std    
  801538:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80153a:	eb 1d                	jmp    801559 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80153c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801540:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80154c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801550:	48 89 d7             	mov    %rdx,%rdi
  801553:	48 89 c1             	mov    %rax,%rcx
  801556:	fd                   	std    
  801557:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801559:	fc                   	cld    
  80155a:	eb 57                	jmp    8015b3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	83 e0 03             	and    $0x3,%eax
  801563:	48 85 c0             	test   %rax,%rax
  801566:	75 36                	jne    80159e <memmove+0xfc>
  801568:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156c:	83 e0 03             	and    $0x3,%eax
  80156f:	48 85 c0             	test   %rax,%rax
  801572:	75 2a                	jne    80159e <memmove+0xfc>
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	83 e0 03             	and    $0x3,%eax
  80157b:	48 85 c0             	test   %rax,%rax
  80157e:	75 1e                	jne    80159e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801580:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801584:	48 89 c1             	mov    %rax,%rcx
  801587:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80158b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801593:	48 89 c7             	mov    %rax,%rdi
  801596:	48 89 d6             	mov    %rdx,%rsi
  801599:	fc                   	cld    
  80159a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80159c:	eb 15                	jmp    8015b3 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80159e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015aa:	48 89 c7             	mov    %rax,%rdi
  8015ad:	48 89 d6             	mov    %rdx,%rsi
  8015b0:	fc                   	cld    
  8015b1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8015b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015b7:	c9                   	leaveq 
  8015b8:	c3                   	retq   

00000000008015b9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8015b9:	55                   	push   %rbp
  8015ba:	48 89 e5             	mov    %rsp,%rbp
  8015bd:	48 83 ec 18          	sub    $0x18,%rsp
  8015c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8015cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d9:	48 89 ce             	mov    %rcx,%rsi
  8015dc:	48 89 c7             	mov    %rax,%rdi
  8015df:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  8015e6:	00 00 00 
  8015e9:	ff d0                	callq  *%rax
}
  8015eb:	c9                   	leaveq 
  8015ec:	c3                   	retq   

00000000008015ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 83 ec 28          	sub    $0x28,%rsp
  8015f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015f9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801605:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801609:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80160d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801611:	eb 38                	jmp    80164b <memcmp+0x5e>
		if (*s1 != *s2)
  801613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801617:	0f b6 10             	movzbl (%rax),%edx
  80161a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	38 c2                	cmp    %al,%dl
  801623:	74 1c                	je     801641 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801625:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801629:	0f b6 00             	movzbl (%rax),%eax
  80162c:	0f b6 d0             	movzbl %al,%edx
  80162f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801633:	0f b6 00             	movzbl (%rax),%eax
  801636:	0f b6 c0             	movzbl %al,%eax
  801639:	89 d1                	mov    %edx,%ecx
  80163b:	29 c1                	sub    %eax,%ecx
  80163d:	89 c8                	mov    %ecx,%eax
  80163f:	eb 20                	jmp    801661 <memcmp+0x74>
		s1++, s2++;
  801641:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801646:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80164b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801650:	0f 95 c0             	setne  %al
  801653:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801658:	84 c0                	test   %al,%al
  80165a:	75 b7                	jne    801613 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801661:	c9                   	leaveq 
  801662:	c3                   	retq   

0000000000801663 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801663:	55                   	push   %rbp
  801664:	48 89 e5             	mov    %rsp,%rbp
  801667:	48 83 ec 28          	sub    $0x28,%rsp
  80166b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801672:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801676:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167e:	48 01 d0             	add    %rdx,%rax
  801681:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801685:	eb 13                	jmp    80169a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168b:	0f b6 10             	movzbl (%rax),%edx
  80168e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801691:	38 c2                	cmp    %al,%dl
  801693:	74 11                	je     8016a6 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801695:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80169a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8016a2:	72 e3                	jb     801687 <memfind+0x24>
  8016a4:	eb 01                	jmp    8016a7 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016a6:	90                   	nop
	return (void *) s;
  8016a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016ab:	c9                   	leaveq 
  8016ac:	c3                   	retq   

00000000008016ad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
  8016b1:	48 83 ec 38          	sub    $0x38,%rsp
  8016b5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016b9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8016bd:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8016c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8016c7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8016ce:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016cf:	eb 05                	jmp    8016d6 <strtol+0x29>
		s++;
  8016d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	3c 20                	cmp    $0x20,%al
  8016df:	74 f0                	je     8016d1 <strtol+0x24>
  8016e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	3c 09                	cmp    $0x9,%al
  8016ea:	74 e5                	je     8016d1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f0:	0f b6 00             	movzbl (%rax),%eax
  8016f3:	3c 2b                	cmp    $0x2b,%al
  8016f5:	75 07                	jne    8016fe <strtol+0x51>
		s++;
  8016f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016fc:	eb 17                	jmp    801715 <strtol+0x68>
	else if (*s == '-')
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	3c 2d                	cmp    $0x2d,%al
  801707:	75 0c                	jne    801715 <strtol+0x68>
		s++, neg = 1;
  801709:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80170e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801715:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801719:	74 06                	je     801721 <strtol+0x74>
  80171b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80171f:	75 28                	jne    801749 <strtol+0x9c>
  801721:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801725:	0f b6 00             	movzbl (%rax),%eax
  801728:	3c 30                	cmp    $0x30,%al
  80172a:	75 1d                	jne    801749 <strtol+0x9c>
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	48 83 c0 01          	add    $0x1,%rax
  801734:	0f b6 00             	movzbl (%rax),%eax
  801737:	3c 78                	cmp    $0x78,%al
  801739:	75 0e                	jne    801749 <strtol+0x9c>
		s += 2, base = 16;
  80173b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801740:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801747:	eb 2c                	jmp    801775 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801749:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80174d:	75 19                	jne    801768 <strtol+0xbb>
  80174f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801753:	0f b6 00             	movzbl (%rax),%eax
  801756:	3c 30                	cmp    $0x30,%al
  801758:	75 0e                	jne    801768 <strtol+0xbb>
		s++, base = 8;
  80175a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80175f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801766:	eb 0d                	jmp    801775 <strtol+0xc8>
	else if (base == 0)
  801768:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80176c:	75 07                	jne    801775 <strtol+0xc8>
		base = 10;
  80176e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801779:	0f b6 00             	movzbl (%rax),%eax
  80177c:	3c 2f                	cmp    $0x2f,%al
  80177e:	7e 1d                	jle    80179d <strtol+0xf0>
  801780:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801784:	0f b6 00             	movzbl (%rax),%eax
  801787:	3c 39                	cmp    $0x39,%al
  801789:	7f 12                	jg     80179d <strtol+0xf0>
			dig = *s - '0';
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	0f b6 00             	movzbl (%rax),%eax
  801792:	0f be c0             	movsbl %al,%eax
  801795:	83 e8 30             	sub    $0x30,%eax
  801798:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80179b:	eb 4e                	jmp    8017eb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	3c 60                	cmp    $0x60,%al
  8017a6:	7e 1d                	jle    8017c5 <strtol+0x118>
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	3c 7a                	cmp    $0x7a,%al
  8017b1:	7f 12                	jg     8017c5 <strtol+0x118>
			dig = *s - 'a' + 10;
  8017b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	0f be c0             	movsbl %al,%eax
  8017bd:	83 e8 57             	sub    $0x57,%eax
  8017c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8017c3:	eb 26                	jmp    8017eb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8017c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c9:	0f b6 00             	movzbl (%rax),%eax
  8017cc:	3c 40                	cmp    $0x40,%al
  8017ce:	7e 47                	jle    801817 <strtol+0x16a>
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	0f b6 00             	movzbl (%rax),%eax
  8017d7:	3c 5a                	cmp    $0x5a,%al
  8017d9:	7f 3c                	jg     801817 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8017db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017df:	0f b6 00             	movzbl (%rax),%eax
  8017e2:	0f be c0             	movsbl %al,%eax
  8017e5:	83 e8 37             	sub    $0x37,%eax
  8017e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ee:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017f1:	7d 23                	jge    801816 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8017f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017fb:	48 98                	cltq   
  8017fd:	48 89 c2             	mov    %rax,%rdx
  801800:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801805:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801808:	48 98                	cltq   
  80180a:	48 01 d0             	add    %rdx,%rax
  80180d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801811:	e9 5f ff ff ff       	jmpq   801775 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801816:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801817:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80181c:	74 0b                	je     801829 <strtol+0x17c>
		*endptr = (char *) s;
  80181e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801822:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801826:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801829:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80182d:	74 09                	je     801838 <strtol+0x18b>
  80182f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801833:	48 f7 d8             	neg    %rax
  801836:	eb 04                	jmp    80183c <strtol+0x18f>
  801838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80183c:	c9                   	leaveq 
  80183d:	c3                   	retq   

000000000080183e <strstr>:

char * strstr(const char *in, const char *str)
{
  80183e:	55                   	push   %rbp
  80183f:	48 89 e5             	mov    %rsp,%rbp
  801842:	48 83 ec 30          	sub    $0x30,%rsp
  801846:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80184a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80184e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801852:	0f b6 00             	movzbl (%rax),%eax
  801855:	88 45 ff             	mov    %al,-0x1(%rbp)
  801858:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  80185d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801861:	75 06                	jne    801869 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	eb 68                	jmp    8018d1 <strstr+0x93>

    len = strlen(str);
  801869:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80186d:	48 89 c7             	mov    %rax,%rdi
  801870:	48 b8 14 11 80 00 00 	movabs $0x801114,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
  80187c:	48 98                	cltq   
  80187e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	0f b6 00             	movzbl (%rax),%eax
  801889:	88 45 ef             	mov    %al,-0x11(%rbp)
  80188c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801891:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801895:	75 07                	jne    80189e <strstr+0x60>
                return (char *) 0;
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	eb 33                	jmp    8018d1 <strstr+0x93>
        } while (sc != c);
  80189e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8018a2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8018a5:	75 db                	jne    801882 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8018a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ab:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8018af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b3:	48 89 ce             	mov    %rcx,%rsi
  8018b6:	48 89 c7             	mov    %rax,%rdi
  8018b9:	48 b8 30 13 80 00 00 	movabs $0x801330,%rax
  8018c0:	00 00 00 
  8018c3:	ff d0                	callq  *%rax
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	75 b9                	jne    801882 <strstr+0x44>

    return (char *) (in - 1);
  8018c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018cd:	48 83 e8 01          	sub    $0x1,%rax
}
  8018d1:	c9                   	leaveq 
  8018d2:	c3                   	retq   
	...

00000000008018d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	53                   	push   %rbx
  8018d9:	48 83 ec 58          	sub    $0x58,%rsp
  8018dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018e0:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018e3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018e7:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018eb:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018ef:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f6:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8018f9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018fd:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801901:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801905:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801909:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80190d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801910:	4c 89 c3             	mov    %r8,%rbx
  801913:	cd 30                	int    $0x30
  801915:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801919:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80191d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801921:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801925:	74 3e                	je     801965 <syscall+0x91>
  801927:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80192c:	7e 37                	jle    801965 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80192e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801932:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801935:	49 89 d0             	mov    %rdx,%r8
  801938:	89 c1                	mov    %eax,%ecx
  80193a:	48 ba 80 46 80 00 00 	movabs $0x804680,%rdx
  801941:	00 00 00 
  801944:	be 23 00 00 00       	mov    $0x23,%esi
  801949:	48 bf 9d 46 80 00 00 	movabs $0x80469d,%rdi
  801950:	00 00 00 
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
  801958:	49 b9 88 03 80 00 00 	movabs $0x800388,%r9
  80195f:	00 00 00 
  801962:	41 ff d1             	callq  *%r9

	return ret;
  801965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801969:	48 83 c4 58          	add    $0x58,%rsp
  80196d:	5b                   	pop    %rbx
  80196e:	5d                   	pop    %rbp
  80196f:	c3                   	retq   

0000000000801970 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801970:	55                   	push   %rbp
  801971:	48 89 e5             	mov    %rsp,%rbp
  801974:	48 83 ec 20          	sub    $0x20,%rsp
  801978:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80197c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801980:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801984:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801988:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198f:	00 
  801990:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801996:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199c:	48 89 d1             	mov    %rdx,%rcx
  80199f:	48 89 c2             	mov    %rax,%rdx
  8019a2:	be 00 00 00 00       	mov    $0x0,%esi
  8019a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8019ac:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8019b3:	00 00 00 
  8019b6:	ff d0                	callq  *%rax
}
  8019b8:	c9                   	leaveq 
  8019b9:	c3                   	retq   

00000000008019ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8019ba:	55                   	push   %rbp
  8019bb:	48 89 e5             	mov    %rsp,%rbp
  8019be:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8019c2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c9:	00 
  8019ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e0:	be 00 00 00 00       	mov    $0x0,%esi
  8019e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8019ea:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
}
  8019f6:	c9                   	leaveq 
  8019f7:	c3                   	retq   

00000000008019f8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019f8:	55                   	push   %rbp
  8019f9:	48 89 e5             	mov    %rsp,%rbp
  8019fc:	48 83 ec 20          	sub    $0x20,%rsp
  801a00:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a06:	48 98                	cltq   
  801a08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0f:	00 
  801a10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a21:	48 89 c2             	mov    %rax,%rdx
  801a24:	be 01 00 00 00       	mov    $0x1,%esi
  801a29:	bf 03 00 00 00       	mov    $0x3,%edi
  801a2e:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801a35:	00 00 00 
  801a38:	ff d0                	callq  *%rax
}
  801a3a:	c9                   	leaveq 
  801a3b:	c3                   	retq   

0000000000801a3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801a3c:	55                   	push   %rbp
  801a3d:	48 89 e5             	mov    %rsp,%rbp
  801a40:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a44:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4b:	00 
  801a4c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a52:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a58:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
  801a67:	bf 02 00 00 00       	mov    $0x2,%edi
  801a6c:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_yield>:

void
sys_yield(void)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aaa:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ac7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801aca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801acd:	48 63 c8             	movslq %eax,%rcx
  801ad0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad7:	48 98                	cltq   
  801ad9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae0:	00 
  801ae1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae7:	49 89 c8             	mov    %rcx,%r8
  801aea:	48 89 d1             	mov    %rdx,%rcx
  801aed:	48 89 c2             	mov    %rax,%rdx
  801af0:	be 01 00 00 00       	mov    $0x1,%esi
  801af5:	bf 04 00 00 00       	mov    $0x4,%edi
  801afa:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801b01:	00 00 00 
  801b04:	ff d0                	callq  *%rax
}
  801b06:	c9                   	leaveq 
  801b07:	c3                   	retq   

0000000000801b08 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b08:	55                   	push   %rbp
  801b09:	48 89 e5             	mov    %rsp,%rbp
  801b0c:	48 83 ec 30          	sub    $0x30,%rsp
  801b10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b17:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b1a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b1e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b22:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b25:	48 63 c8             	movslq %eax,%rcx
  801b28:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801b2c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b2f:	48 63 f0             	movslq %eax,%rsi
  801b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 89 0c 24          	mov    %rcx,(%rsp)
  801b3f:	49 89 f9             	mov    %rdi,%r9
  801b42:	49 89 f0             	mov    %rsi,%r8
  801b45:	48 89 d1             	mov    %rdx,%rcx
  801b48:	48 89 c2             	mov    %rax,%rdx
  801b4b:	be 01 00 00 00       	mov    $0x1,%esi
  801b50:	bf 05 00 00 00       	mov    $0x5,%edi
  801b55:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax
}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 20          	sub    $0x20,%rsp
  801b6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b79:	48 98                	cltq   
  801b7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b82:	00 
  801b83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8f:	48 89 d1             	mov    %rdx,%rcx
  801b92:	48 89 c2             	mov    %rax,%rdx
  801b95:	be 01 00 00 00       	mov    $0x1,%esi
  801b9a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b9f:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
}
  801bab:	c9                   	leaveq 
  801bac:	c3                   	retq   

0000000000801bad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801bad:	55                   	push   %rbp
  801bae:	48 89 e5             	mov    %rsp,%rbp
  801bb1:	48 83 ec 20          	sub    $0x20,%rsp
  801bb5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801bbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbe:	48 63 d0             	movslq %eax,%rdx
  801bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc4:	48 98                	cltq   
  801bc6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcd:	00 
  801bce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bda:	48 89 d1             	mov    %rdx,%rcx
  801bdd:	48 89 c2             	mov    %rax,%rdx
  801be0:	be 01 00 00 00       	mov    $0x1,%esi
  801be5:	bf 08 00 00 00       	mov    $0x8,%edi
  801bea:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801bf1:	00 00 00 
  801bf4:	ff d0                	callq  *%rax
}
  801bf6:	c9                   	leaveq 
  801bf7:	c3                   	retq   

0000000000801bf8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bf8:	55                   	push   %rbp
  801bf9:	48 89 e5             	mov    %rsp,%rbp
  801bfc:	48 83 ec 20          	sub    $0x20,%rsp
  801c00:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c0e:	48 98                	cltq   
  801c10:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c17:	00 
  801c18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c24:	48 89 d1             	mov    %rdx,%rcx
  801c27:	48 89 c2             	mov    %rax,%rdx
  801c2a:	be 01 00 00 00       	mov    $0x1,%esi
  801c2f:	bf 09 00 00 00       	mov    $0x9,%edi
  801c34:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	callq  *%rax
}
  801c40:	c9                   	leaveq 
  801c41:	c3                   	retq   

0000000000801c42 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c42:	55                   	push   %rbp
  801c43:	48 89 e5             	mov    %rsp,%rbp
  801c46:	48 83 ec 20          	sub    $0x20,%rsp
  801c4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c58:	48 98                	cltq   
  801c5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c61:	00 
  801c62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6e:	48 89 d1             	mov    %rdx,%rcx
  801c71:	48 89 c2             	mov    %rax,%rdx
  801c74:	be 01 00 00 00       	mov    $0x1,%esi
  801c79:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c7e:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
}
  801c8a:	c9                   	leaveq 
  801c8b:	c3                   	retq   

0000000000801c8c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c8c:	55                   	push   %rbp
  801c8d:	48 89 e5             	mov    %rsp,%rbp
  801c90:	48 83 ec 30          	sub    $0x30,%rsp
  801c94:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c9b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c9f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ca2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca5:	48 63 f0             	movslq %eax,%rsi
  801ca8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801caf:	48 98                	cltq   
  801cb1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cbc:	00 
  801cbd:	49 89 f1             	mov    %rsi,%r9
  801cc0:	49 89 c8             	mov    %rcx,%r8
  801cc3:	48 89 d1             	mov    %rdx,%rcx
  801cc6:	48 89 c2             	mov    %rax,%rdx
  801cc9:	be 00 00 00 00       	mov    $0x0,%esi
  801cce:	bf 0c 00 00 00       	mov    $0xc,%edi
  801cd3:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801cda:	00 00 00 
  801cdd:	ff d0                	callq  *%rax
}
  801cdf:	c9                   	leaveq 
  801ce0:	c3                   	retq   

0000000000801ce1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	48 83 ec 20          	sub    $0x20,%rsp
  801ce9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cf8:	00 
  801cf9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d05:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d0a:	48 89 c2             	mov    %rax,%rdx
  801d0d:	be 01 00 00 00       	mov    $0x1,%esi
  801d12:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d17:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801d1e:	00 00 00 
  801d21:	ff d0                	callq  *%rax
}
  801d23:	c9                   	leaveq 
  801d24:	c3                   	retq   

0000000000801d25 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d25:	55                   	push   %rbp
  801d26:	48 89 e5             	mov    %rsp,%rbp
  801d29:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801d2d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d34:	00 
  801d35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d41:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d46:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4b:	be 00 00 00 00       	mov    $0x0,%esi
  801d50:	bf 0e 00 00 00       	mov    $0xe,%edi
  801d55:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801d5c:	00 00 00 
  801d5f:	ff d0                	callq  *%rax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 20          	sub    $0x20,%rsp
  801d6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d7b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d82:	00 
  801d83:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d89:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d8f:	48 89 d1             	mov    %rdx,%rcx
  801d92:	48 89 c2             	mov    %rax,%rdx
  801d95:	be 00 00 00 00       	mov    $0x0,%esi
  801d9a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d9f:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801da6:	00 00 00 
  801da9:	ff d0                	callq  *%rax
}
  801dab:	c9                   	leaveq 
  801dac:	c3                   	retq   

0000000000801dad <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801dad:	55                   	push   %rbp
  801dae:	48 89 e5             	mov    %rsp,%rbp
  801db1:	48 83 ec 20          	sub    $0x20,%rsp
  801db5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801db9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dcc:	00 
  801dcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd9:	48 89 d1             	mov    %rdx,%rcx
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	be 00 00 00 00       	mov    $0x0,%esi
  801de4:	bf 10 00 00 00       	mov    $0x10,%edi
  801de9:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   
	...

0000000000801df8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801df8:	55                   	push   %rbp
  801df9:	48 89 e5             	mov    %rsp,%rbp
  801dfc:	48 83 ec 08          	sub    $0x8,%rsp
  801e00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e04:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e08:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e0f:	ff ff ff 
  801e12:	48 01 d0             	add    %rdx,%rax
  801e15:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e19:	c9                   	leaveq 
  801e1a:	c3                   	retq   

0000000000801e1b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e1b:	55                   	push   %rbp
  801e1c:	48 89 e5             	mov    %rsp,%rbp
  801e1f:	48 83 ec 08          	sub    $0x8,%rsp
  801e23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e2b:	48 89 c7             	mov    %rax,%rdi
  801e2e:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
  801e3a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e40:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e44:	c9                   	leaveq 
  801e45:	c3                   	retq   

0000000000801e46 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e46:	55                   	push   %rbp
  801e47:	48 89 e5             	mov    %rsp,%rbp
  801e4a:	48 83 ec 18          	sub    $0x18,%rsp
  801e4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e59:	eb 6b                	jmp    801ec6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5e:	48 98                	cltq   
  801e60:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e66:	48 c1 e0 0c          	shl    $0xc,%rax
  801e6a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e72:	48 89 c2             	mov    %rax,%rdx
  801e75:	48 c1 ea 15          	shr    $0x15,%rdx
  801e79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e80:	01 00 00 
  801e83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e87:	83 e0 01             	and    $0x1,%eax
  801e8a:	48 85 c0             	test   %rax,%rax
  801e8d:	74 21                	je     801eb0 <fd_alloc+0x6a>
  801e8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e93:	48 89 c2             	mov    %rax,%rdx
  801e96:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea1:	01 00 00 
  801ea4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ea8:	83 e0 01             	and    $0x1,%eax
  801eab:	48 85 c0             	test   %rax,%rax
  801eae:	75 12                	jne    801ec2 <fd_alloc+0x7c>
			*fd_store = fd;
  801eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	eb 1a                	jmp    801edc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ec2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eca:	7e 8f                	jle    801e5b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ed7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801edc:	c9                   	leaveq 
  801edd:	c3                   	retq   

0000000000801ede <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ede:	55                   	push   %rbp
  801edf:	48 89 e5             	mov    %rsp,%rbp
  801ee2:	48 83 ec 20          	sub    $0x20,%rsp
  801ee6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801eed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ef1:	78 06                	js     801ef9 <fd_lookup+0x1b>
  801ef3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ef7:	7e 07                	jle    801f00 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ef9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801efe:	eb 6c                	jmp    801f6c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f03:	48 98                	cltq   
  801f05:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f0b:	48 c1 e0 0c          	shl    $0xc,%rax
  801f0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f17:	48 89 c2             	mov    %rax,%rdx
  801f1a:	48 c1 ea 15          	shr    $0x15,%rdx
  801f1e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f25:	01 00 00 
  801f28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f2c:	83 e0 01             	and    $0x1,%eax
  801f2f:	48 85 c0             	test   %rax,%rax
  801f32:	74 21                	je     801f55 <fd_lookup+0x77>
  801f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f46:	01 00 00 
  801f49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4d:	83 e0 01             	and    $0x1,%eax
  801f50:	48 85 c0             	test   %rax,%rax
  801f53:	75 07                	jne    801f5c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f5a:	eb 10                	jmp    801f6c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f64:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6c:	c9                   	leaveq 
  801f6d:	c3                   	retq   

0000000000801f6e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f6e:	55                   	push   %rbp
  801f6f:	48 89 e5             	mov    %rsp,%rbp
  801f72:	48 83 ec 30          	sub    $0x30,%rsp
  801f76:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f7a:	89 f0                	mov    %esi,%eax
  801f7c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f7f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f83:	48 89 c7             	mov    %rax,%rdi
  801f86:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  801f8d:	00 00 00 
  801f90:	ff d0                	callq  *%rax
  801f92:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f96:	48 89 d6             	mov    %rdx,%rsi
  801f99:	89 c7                	mov    %eax,%edi
  801f9b:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  801fa2:	00 00 00 
  801fa5:	ff d0                	callq  *%rax
  801fa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801faa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fae:	78 0a                	js     801fba <fd_close+0x4c>
	    || fd != fd2)
  801fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fb8:	74 12                	je     801fcc <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fba:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fbe:	74 05                	je     801fc5 <fd_close+0x57>
  801fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fc3:	eb 05                	jmp    801fca <fd_close+0x5c>
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fca:	eb 69                	jmp    802035 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd0:	8b 00                	mov    (%rax),%eax
  801fd2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fd6:	48 89 d6             	mov    %rdx,%rsi
  801fd9:	89 c7                	mov    %eax,%edi
  801fdb:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  801fe2:	00 00 00 
  801fe5:	ff d0                	callq  *%rax
  801fe7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fee:	78 2a                	js     80201a <fd_close+0xac>
		if (dev->dev_close)
  801ff0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ff8:	48 85 c0             	test   %rax,%rax
  801ffb:	74 16                	je     802013 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802001:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802005:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802009:	48 89 c7             	mov    %rax,%rdi
  80200c:	ff d2                	callq  *%rdx
  80200e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802011:	eb 07                	jmp    80201a <fd_close+0xac>
		else
			r = 0;
  802013:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80201a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201e:	48 89 c6             	mov    %rax,%rsi
  802021:	bf 00 00 00 00       	mov    $0x0,%edi
  802026:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  80202d:	00 00 00 
  802030:	ff d0                	callq  *%rax
	return r;
  802032:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802035:	c9                   	leaveq 
  802036:	c3                   	retq   

0000000000802037 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802037:	55                   	push   %rbp
  802038:	48 89 e5             	mov    %rsp,%rbp
  80203b:	48 83 ec 20          	sub    $0x20,%rsp
  80203f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802042:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80204d:	eb 41                	jmp    802090 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80204f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802056:	00 00 00 
  802059:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80205c:	48 63 d2             	movslq %edx,%rdx
  80205f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802063:	8b 00                	mov    (%rax),%eax
  802065:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802068:	75 22                	jne    80208c <dev_lookup+0x55>
			*dev = devtab[i];
  80206a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802071:	00 00 00 
  802074:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802077:	48 63 d2             	movslq %edx,%rdx
  80207a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80207e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802082:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	eb 60                	jmp    8020ec <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80208c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802090:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802097:	00 00 00 
  80209a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80209d:	48 63 d2             	movslq %edx,%rdx
  8020a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a4:	48 85 c0             	test   %rax,%rax
  8020a7:	75 a6                	jne    80204f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020a9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8020b0:	00 00 00 
  8020b3:	48 8b 00             	mov    (%rax),%rax
  8020b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020bc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020bf:	89 c6                	mov    %eax,%esi
  8020c1:	48 bf b0 46 80 00 00 	movabs $0x8046b0,%rdi
  8020c8:	00 00 00 
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	48 b9 c3 05 80 00 00 	movabs $0x8005c3,%rcx
  8020d7:	00 00 00 
  8020da:	ff d1                	callq  *%rcx
	*dev = 0;
  8020dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020ec:	c9                   	leaveq 
  8020ed:	c3                   	retq   

00000000008020ee <close>:

int
close(int fdnum)
{
  8020ee:	55                   	push   %rbp
  8020ef:	48 89 e5             	mov    %rsp,%rbp
  8020f2:	48 83 ec 20          	sub    $0x20,%rsp
  8020f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802100:	48 89 d6             	mov    %rdx,%rsi
  802103:	89 c7                	mov    %eax,%edi
  802105:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80210c:	00 00 00 
  80210f:	ff d0                	callq  *%rax
  802111:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802118:	79 05                	jns    80211f <close+0x31>
		return r;
  80211a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80211d:	eb 18                	jmp    802137 <close+0x49>
	else
		return fd_close(fd, 1);
  80211f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802123:	be 01 00 00 00       	mov    $0x1,%esi
  802128:	48 89 c7             	mov    %rax,%rdi
  80212b:	48 b8 6e 1f 80 00 00 	movabs $0x801f6e,%rax
  802132:	00 00 00 
  802135:	ff d0                	callq  *%rax
}
  802137:	c9                   	leaveq 
  802138:	c3                   	retq   

0000000000802139 <close_all>:

void
close_all(void)
{
  802139:	55                   	push   %rbp
  80213a:	48 89 e5             	mov    %rsp,%rbp
  80213d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802148:	eb 15                	jmp    80215f <close_all+0x26>
		close(i);
  80214a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80214d:	89 c7                	mov    %eax,%edi
  80214f:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80215b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80215f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802163:	7e e5                	jle    80214a <close_all+0x11>
		close(i);
}
  802165:	c9                   	leaveq 
  802166:	c3                   	retq   

0000000000802167 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802167:	55                   	push   %rbp
  802168:	48 89 e5             	mov    %rsp,%rbp
  80216b:	48 83 ec 40          	sub    $0x40,%rsp
  80216f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802172:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802175:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802179:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80217c:	48 89 d6             	mov    %rdx,%rsi
  80217f:	89 c7                	mov    %eax,%edi
  802181:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802188:	00 00 00 
  80218b:	ff d0                	callq  *%rax
  80218d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802194:	79 08                	jns    80219e <dup+0x37>
		return r;
  802196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802199:	e9 70 01 00 00       	jmpq   80230e <dup+0x1a7>
	close(newfdnum);
  80219e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021a1:	89 c7                	mov    %eax,%edi
  8021a3:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021af:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021b2:	48 98                	cltq   
  8021b4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8021be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021c6:	48 89 c7             	mov    %rax,%rdi
  8021c9:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021dd:	48 89 c7             	mov    %rax,%rdi
  8021e0:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8021e7:	00 00 00 
  8021ea:	ff d0                	callq  *%rax
  8021ec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f4:	48 89 c2             	mov    %rax,%rdx
  8021f7:	48 c1 ea 15          	shr    $0x15,%rdx
  8021fb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802202:	01 00 00 
  802205:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802209:	83 e0 01             	and    $0x1,%eax
  80220c:	84 c0                	test   %al,%al
  80220e:	74 71                	je     802281 <dup+0x11a>
  802210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802214:	48 89 c2             	mov    %rax,%rdx
  802217:	48 c1 ea 0c          	shr    $0xc,%rdx
  80221b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802222:	01 00 00 
  802225:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802229:	83 e0 01             	and    $0x1,%eax
  80222c:	84 c0                	test   %al,%al
  80222e:	74 51                	je     802281 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802234:	48 89 c2             	mov    %rax,%rdx
  802237:	48 c1 ea 0c          	shr    $0xc,%rdx
  80223b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802242:	01 00 00 
  802245:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802251:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802255:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802259:	41 89 c8             	mov    %ecx,%r8d
  80225c:	48 89 d1             	mov    %rdx,%rcx
  80225f:	ba 00 00 00 00       	mov    $0x0,%edx
  802264:	48 89 c6             	mov    %rax,%rsi
  802267:	bf 00 00 00 00       	mov    $0x0,%edi
  80226c:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  802273:	00 00 00 
  802276:	ff d0                	callq  *%rax
  802278:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80227b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80227f:	78 56                	js     8022d7 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802285:	48 89 c2             	mov    %rax,%rdx
  802288:	48 c1 ea 0c          	shr    $0xc,%rdx
  80228c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802293:	01 00 00 
  802296:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229a:	89 c1                	mov    %eax,%ecx
  80229c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8022a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022aa:	41 89 c8             	mov    %ecx,%r8d
  8022ad:	48 89 d1             	mov    %rdx,%rcx
  8022b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b5:	48 89 c6             	mov    %rax,%rsi
  8022b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022bd:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  8022c4:	00 00 00 
  8022c7:	ff d0                	callq  *%rax
  8022c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d0:	78 08                	js     8022da <dup+0x173>
		goto err;

	return newfdnum;
  8022d2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022d5:	eb 37                	jmp    80230e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022d7:	90                   	nop
  8022d8:	eb 01                	jmp    8022db <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022da:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022df:	48 89 c6             	mov    %rax,%rsi
  8022e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e7:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022f7:	48 89 c6             	mov    %rax,%rsi
  8022fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8022ff:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  802306:	00 00 00 
  802309:	ff d0                	callq  *%rax
	return r;
  80230b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80230e:	c9                   	leaveq 
  80230f:	c3                   	retq   

0000000000802310 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802310:	55                   	push   %rbp
  802311:	48 89 e5             	mov    %rsp,%rbp
  802314:	48 83 ec 40          	sub    $0x40,%rsp
  802318:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80231b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80231f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802323:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802327:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80232a:	48 89 d6             	mov    %rdx,%rsi
  80232d:	89 c7                	mov    %eax,%edi
  80232f:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802336:	00 00 00 
  802339:	ff d0                	callq  *%rax
  80233b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802342:	78 24                	js     802368 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802348:	8b 00                	mov    (%rax),%eax
  80234a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80234e:	48 89 d6             	mov    %rdx,%rsi
  802351:	89 c7                	mov    %eax,%edi
  802353:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
  80235f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802362:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802366:	79 05                	jns    80236d <read+0x5d>
		return r;
  802368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236b:	eb 7a                	jmp    8023e7 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80236d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802371:	8b 40 08             	mov    0x8(%rax),%eax
  802374:	83 e0 03             	and    $0x3,%eax
  802377:	83 f8 01             	cmp    $0x1,%eax
  80237a:	75 3a                	jne    8023b6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80237c:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802383:	00 00 00 
  802386:	48 8b 00             	mov    (%rax),%rax
  802389:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80238f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802392:	89 c6                	mov    %eax,%esi
  802394:	48 bf cf 46 80 00 00 	movabs $0x8046cf,%rdi
  80239b:	00 00 00 
  80239e:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a3:	48 b9 c3 05 80 00 00 	movabs $0x8005c3,%rcx
  8023aa:	00 00 00 
  8023ad:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b4:	eb 31                	jmp    8023e7 <read+0xd7>
	}
	if (!dev->dev_read)
  8023b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ba:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023be:	48 85 c0             	test   %rax,%rax
  8023c1:	75 07                	jne    8023ca <read+0xba>
		return -E_NOT_SUPP;
  8023c3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023c8:	eb 1d                	jmp    8023e7 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8023ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ce:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8023d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023da:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023de:	48 89 ce             	mov    %rcx,%rsi
  8023e1:	48 89 c7             	mov    %rax,%rdi
  8023e4:	41 ff d0             	callq  *%r8
}
  8023e7:	c9                   	leaveq 
  8023e8:	c3                   	retq   

00000000008023e9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023e9:	55                   	push   %rbp
  8023ea:	48 89 e5             	mov    %rsp,%rbp
  8023ed:	48 83 ec 30          	sub    $0x30,%rsp
  8023f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802403:	eb 46                	jmp    80244b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802408:	48 98                	cltq   
  80240a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80240e:	48 29 c2             	sub    %rax,%rdx
  802411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802414:	48 98                	cltq   
  802416:	48 89 c1             	mov    %rax,%rcx
  802419:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80241d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802420:	48 89 ce             	mov    %rcx,%rsi
  802423:	89 c7                	mov    %eax,%edi
  802425:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  80242c:	00 00 00 
  80242f:	ff d0                	callq  *%rax
  802431:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802434:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802438:	79 05                	jns    80243f <readn+0x56>
			return m;
  80243a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80243d:	eb 1d                	jmp    80245c <readn+0x73>
		if (m == 0)
  80243f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802443:	74 13                	je     802458 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802448:	01 45 fc             	add    %eax,-0x4(%rbp)
  80244b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80244e:	48 98                	cltq   
  802450:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802454:	72 af                	jb     802405 <readn+0x1c>
  802456:	eb 01                	jmp    802459 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802458:	90                   	nop
	}
	return tot;
  802459:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80245c:	c9                   	leaveq 
  80245d:	c3                   	retq   

000000000080245e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80245e:	55                   	push   %rbp
  80245f:	48 89 e5             	mov    %rsp,%rbp
  802462:	48 83 ec 40          	sub    $0x40,%rsp
  802466:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802469:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80246d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802471:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802475:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802478:	48 89 d6             	mov    %rdx,%rsi
  80247b:	89 c7                	mov    %eax,%edi
  80247d:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802484:	00 00 00 
  802487:	ff d0                	callq  *%rax
  802489:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80248c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802490:	78 24                	js     8024b6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802496:	8b 00                	mov    (%rax),%eax
  802498:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80249c:	48 89 d6             	mov    %rdx,%rsi
  80249f:	89 c7                	mov    %eax,%edi
  8024a1:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  8024a8:	00 00 00 
  8024ab:	ff d0                	callq  *%rax
  8024ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b4:	79 05                	jns    8024bb <write+0x5d>
		return r;
  8024b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b9:	eb 79                	jmp    802534 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024bf:	8b 40 08             	mov    0x8(%rax),%eax
  8024c2:	83 e0 03             	and    $0x3,%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	75 3a                	jne    802503 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024c9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8024d0:	00 00 00 
  8024d3:	48 8b 00             	mov    (%rax),%rax
  8024d6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  8024e8:	00 00 00 
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	48 b9 c3 05 80 00 00 	movabs $0x8005c3,%rcx
  8024f7:	00 00 00 
  8024fa:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802501:	eb 31                	jmp    802534 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802507:	48 8b 40 18          	mov    0x18(%rax),%rax
  80250b:	48 85 c0             	test   %rax,%rax
  80250e:	75 07                	jne    802517 <write+0xb9>
		return -E_NOT_SUPP;
  802510:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802515:	eb 1d                	jmp    802534 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80251f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802523:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802527:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80252b:	48 89 ce             	mov    %rcx,%rsi
  80252e:	48 89 c7             	mov    %rax,%rdi
  802531:	41 ff d0             	callq  *%r8
}
  802534:	c9                   	leaveq 
  802535:	c3                   	retq   

0000000000802536 <seek>:

int
seek(int fdnum, off_t offset)
{
  802536:	55                   	push   %rbp
  802537:	48 89 e5             	mov    %rsp,%rbp
  80253a:	48 83 ec 18          	sub    $0x18,%rsp
  80253e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802541:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802544:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802548:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254b:	48 89 d6             	mov    %rdx,%rsi
  80254e:	89 c7                	mov    %eax,%edi
  802550:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802557:	00 00 00 
  80255a:	ff d0                	callq  *%rax
  80255c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802563:	79 05                	jns    80256a <seek+0x34>
		return r;
  802565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802568:	eb 0f                	jmp    802579 <seek+0x43>
	fd->fd_offset = offset;
  80256a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80256e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802571:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802574:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802579:	c9                   	leaveq 
  80257a:	c3                   	retq   

000000000080257b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80257b:	55                   	push   %rbp
  80257c:	48 89 e5             	mov    %rsp,%rbp
  80257f:	48 83 ec 30          	sub    $0x30,%rsp
  802583:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802586:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802589:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80258d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802590:	48 89 d6             	mov    %rdx,%rsi
  802593:	89 c7                	mov    %eax,%edi
  802595:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  80259c:	00 00 00 
  80259f:	ff d0                	callq  *%rax
  8025a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a8:	78 24                	js     8025ce <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ae:	8b 00                	mov    (%rax),%eax
  8025b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025b4:	48 89 d6             	mov    %rdx,%rsi
  8025b7:	89 c7                	mov    %eax,%edi
  8025b9:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
  8025c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025cc:	79 05                	jns    8025d3 <ftruncate+0x58>
		return r;
  8025ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d1:	eb 72                	jmp    802645 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025d7:	8b 40 08             	mov    0x8(%rax),%eax
  8025da:	83 e0 03             	and    $0x3,%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	75 3a                	jne    80261b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025e1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8025e8:	00 00 00 
  8025eb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025f4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025f7:	89 c6                	mov    %eax,%esi
  8025f9:	48 bf 08 47 80 00 00 	movabs $0x804708,%rdi
  802600:	00 00 00 
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	48 b9 c3 05 80 00 00 	movabs $0x8005c3,%rcx
  80260f:	00 00 00 
  802612:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802614:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802619:	eb 2a                	jmp    802645 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80261b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802623:	48 85 c0             	test   %rax,%rax
  802626:	75 07                	jne    80262f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802628:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80262d:	eb 16                	jmp    802645 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80262f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802633:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80263e:	89 d6                	mov    %edx,%esi
  802640:	48 89 c7             	mov    %rax,%rdi
  802643:	ff d1                	callq  *%rcx
}
  802645:	c9                   	leaveq 
  802646:	c3                   	retq   

0000000000802647 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802647:	55                   	push   %rbp
  802648:	48 89 e5             	mov    %rsp,%rbp
  80264b:	48 83 ec 30          	sub    $0x30,%rsp
  80264f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802652:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802656:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80265a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80265d:	48 89 d6             	mov    %rdx,%rsi
  802660:	89 c7                	mov    %eax,%edi
  802662:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802669:	00 00 00 
  80266c:	ff d0                	callq  *%rax
  80266e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802671:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802675:	78 24                	js     80269b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267b:	8b 00                	mov    (%rax),%eax
  80267d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802681:	48 89 d6             	mov    %rdx,%rsi
  802684:	89 c7                	mov    %eax,%edi
  802686:	48 b8 37 20 80 00 00 	movabs $0x802037,%rax
  80268d:	00 00 00 
  802690:	ff d0                	callq  *%rax
  802692:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802695:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802699:	79 05                	jns    8026a0 <fstat+0x59>
		return r;
  80269b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80269e:	eb 5e                	jmp    8026fe <fstat+0xb7>
	if (!dev->dev_stat)
  8026a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a4:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026a8:	48 85 c0             	test   %rax,%rax
  8026ab:	75 07                	jne    8026b4 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026b2:	eb 4a                	jmp    8026fe <fstat+0xb7>
	stat->st_name[0] = 0;
  8026b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026bf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026c6:	00 00 00 
	stat->st_isdir = 0;
  8026c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026cd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026d4:	00 00 00 
	stat->st_dev = dev;
  8026d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026df:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ea:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8026ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f2:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026f6:	48 89 d6             	mov    %rdx,%rsi
  8026f9:	48 89 c7             	mov    %rax,%rdi
  8026fc:	ff d1                	callq  *%rcx
}
  8026fe:	c9                   	leaveq 
  8026ff:	c3                   	retq   

0000000000802700 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802700:	55                   	push   %rbp
  802701:	48 89 e5             	mov    %rsp,%rbp
  802704:	48 83 ec 20          	sub    $0x20,%rsp
  802708:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80270c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802714:	be 00 00 00 00       	mov    $0x0,%esi
  802719:	48 89 c7             	mov    %rax,%rdi
  80271c:	48 b8 ef 27 80 00 00 	movabs $0x8027ef,%rax
  802723:	00 00 00 
  802726:	ff d0                	callq  *%rax
  802728:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272f:	79 05                	jns    802736 <stat+0x36>
		return fd;
  802731:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802734:	eb 2f                	jmp    802765 <stat+0x65>
	r = fstat(fd, stat);
  802736:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80273a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273d:	48 89 d6             	mov    %rdx,%rsi
  802740:	89 c7                	mov    %eax,%edi
  802742:	48 b8 47 26 80 00 00 	movabs $0x802647,%rax
  802749:	00 00 00 
  80274c:	ff d0                	callq  *%rax
  80274e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802754:	89 c7                	mov    %eax,%edi
  802756:	48 b8 ee 20 80 00 00 	movabs $0x8020ee,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
	return r;
  802762:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802765:	c9                   	leaveq 
  802766:	c3                   	retq   
	...

0000000000802768 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802768:	55                   	push   %rbp
  802769:	48 89 e5             	mov    %rsp,%rbp
  80276c:	48 83 ec 10          	sub    $0x10,%rsp
  802770:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802773:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802777:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  80277e:	00 00 00 
  802781:	8b 00                	mov    (%rax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	75 1d                	jne    8027a4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802787:	bf 01 00 00 00       	mov    $0x1,%edi
  80278c:	48 b8 13 40 80 00 00 	movabs $0x804013,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  80279f:	00 00 00 
  8027a2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027a4:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  8027ab:	00 00 00 
  8027ae:	8b 00                	mov    (%rax),%eax
  8027b0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027b3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027b8:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027bf:	00 00 00 
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	48 b8 50 3f 80 00 00 	movabs $0x803f50,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027d9:	48 89 c6             	mov    %rax,%rsi
  8027dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e1:	48 b8 90 3e 80 00 00 	movabs $0x803e90,%rax
  8027e8:	00 00 00 
  8027eb:	ff d0                	callq  *%rax
}
  8027ed:	c9                   	leaveq 
  8027ee:	c3                   	retq   

00000000008027ef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027ef:	55                   	push   %rbp
  8027f0:	48 89 e5             	mov    %rsp,%rbp
  8027f3:	48 83 ec 20          	sub    $0x20,%rsp
  8027f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8027fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802802:	48 89 c7             	mov    %rax,%rdi
  802805:	48 b8 14 11 80 00 00 	movabs $0x801114,%rax
  80280c:	00 00 00 
  80280f:	ff d0                	callq  *%rax
  802811:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802816:	7e 0a                	jle    802822 <open+0x33>
                return -E_BAD_PATH;
  802818:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80281d:	e9 a5 00 00 00       	jmpq   8028c7 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802822:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802826:	48 89 c7             	mov    %rax,%rdi
  802829:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  802830:	00 00 00 
  802833:	ff d0                	callq  *%rax
  802835:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802838:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283c:	79 08                	jns    802846 <open+0x57>
		return r;
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	e9 81 00 00 00       	jmpq   8028c7 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284a:	48 89 c6             	mov    %rax,%rsi
  80284d:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802854:	00 00 00 
  802857:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  80285e:	00 00 00 
  802861:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802863:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80286a:	00 00 00 
  80286d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802870:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802876:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287a:	48 89 c6             	mov    %rax,%rsi
  80287d:	bf 01 00 00 00       	mov    $0x1,%edi
  802882:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802891:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802895:	79 1d                	jns    8028b4 <open+0xc5>
	{
		fd_close(fd,0);
  802897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289b:	be 00 00 00 00       	mov    $0x0,%esi
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 6e 1f 80 00 00 	movabs $0x801f6e,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
		return r;
  8028af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b2:	eb 13                	jmp    8028c7 <open+0xd8>
	}
	return fd2num(fd);
  8028b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b8:	48 89 c7             	mov    %rax,%rdi
  8028bb:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
	


}
  8028c7:	c9                   	leaveq 
  8028c8:	c3                   	retq   

00000000008028c9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028c9:	55                   	push   %rbp
  8028ca:	48 89 e5             	mov    %rsp,%rbp
  8028cd:	48 83 ec 10          	sub    $0x10,%rsp
  8028d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028e3:	00 00 00 
  8028e6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028e8:	be 00 00 00 00       	mov    $0x0,%esi
  8028ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8028f2:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  8028f9:	00 00 00 
  8028fc:	ff d0                	callq  *%rax
}
  8028fe:	c9                   	leaveq 
  8028ff:	c3                   	retq   

0000000000802900 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802900:	55                   	push   %rbp
  802901:	48 89 e5             	mov    %rsp,%rbp
  802904:	48 83 ec 30          	sub    $0x30,%rsp
  802908:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80290c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802910:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802918:	8b 50 0c             	mov    0xc(%rax),%edx
  80291b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802922:	00 00 00 
  802925:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802927:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292e:	00 00 00 
  802931:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802935:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802939:	be 00 00 00 00       	mov    $0x0,%esi
  80293e:	bf 03 00 00 00       	mov    $0x3,%edi
  802943:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
  80294f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802952:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802956:	79 05                	jns    80295d <devfile_read+0x5d>
	{
		return r;
  802958:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295b:	eb 2c                	jmp    802989 <devfile_read+0x89>
	}
	if(r > 0)
  80295d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802961:	7e 23                	jle    802986 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802963:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802966:	48 63 d0             	movslq %eax,%rdx
  802969:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80296d:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802974:	00 00 00 
  802977:	48 89 c7             	mov    %rax,%rdi
  80297a:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  802981:	00 00 00 
  802984:	ff d0                	callq  *%rax
	return r;
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802989:	c9                   	leaveq 
  80298a:	c3                   	retq   

000000000080298b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80298b:	55                   	push   %rbp
  80298c:	48 89 e5             	mov    %rsp,%rbp
  80298f:	48 83 ec 30          	sub    $0x30,%rsp
  802993:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802997:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80299f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a3:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029ad:	00 00 00 
  8029b0:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8029b2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029b9:	00 
  8029ba:	76 08                	jbe    8029c4 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8029bc:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029c3:	00 
	fsipcbuf.write.req_n=n;
  8029c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029cb:	00 00 00 
  8029ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029d2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029d6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029de:	48 89 c6             	mov    %rax,%rsi
  8029e1:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029e8:	00 00 00 
  8029eb:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  8029f2:	00 00 00 
  8029f5:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8029f7:	be 00 00 00 00       	mov    $0x0,%esi
  8029fc:	bf 04 00 00 00       	mov    $0x4,%edi
  802a01:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
  802a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802a10:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a13:	c9                   	leaveq 
  802a14:	c3                   	retq   

0000000000802a15 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802a15:	55                   	push   %rbp
  802a16:	48 89 e5             	mov    %rsp,%rbp
  802a19:	48 83 ec 10          	sub    $0x10,%rsp
  802a1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a21:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a28:	8b 50 0c             	mov    0xc(%rax),%edx
  802a2b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a32:	00 00 00 
  802a35:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802a37:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a3e:	00 00 00 
  802a41:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a44:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a47:	be 00 00 00 00       	mov    $0x0,%esi
  802a4c:	bf 02 00 00 00       	mov    $0x2,%edi
  802a51:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	callq  *%rax
}
  802a5d:	c9                   	leaveq 
  802a5e:	c3                   	retq   

0000000000802a5f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a5f:	55                   	push   %rbp
  802a60:	48 89 e5             	mov    %rsp,%rbp
  802a63:	48 83 ec 20          	sub    $0x20,%rsp
  802a67:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a73:	8b 50 0c             	mov    0xc(%rax),%edx
  802a76:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a7d:	00 00 00 
  802a80:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a82:	be 00 00 00 00       	mov    $0x0,%esi
  802a87:	bf 05 00 00 00       	mov    $0x5,%edi
  802a8c:	48 b8 68 27 80 00 00 	movabs $0x802768,%rax
  802a93:	00 00 00 
  802a96:	ff d0                	callq  *%rax
  802a98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9f:	79 05                	jns    802aa6 <devfile_stat+0x47>
		return r;
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	eb 56                	jmp    802afc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aaa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ab1:	00 00 00 
  802ab4:	48 89 c7             	mov    %rax,%rdi
  802ab7:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  802abe:	00 00 00 
  802ac1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ac3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802aca:	00 00 00 
  802acd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802add:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae4:	00 00 00 
  802ae7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802aed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802af1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afc:	c9                   	leaveq 
  802afd:	c3                   	retq   
	...

0000000000802b00 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802b00:	55                   	push   %rbp
  802b01:	48 89 e5             	mov    %rsp,%rbp
  802b04:	48 83 ec 20          	sub    $0x20,%rsp
  802b08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b10:	8b 40 0c             	mov    0xc(%rax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	7e 67                	jle    802b7e <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1b:	8b 40 04             	mov    0x4(%rax),%eax
  802b1e:	48 63 d0             	movslq %eax,%rdx
  802b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b25:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802b29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2d:	8b 00                	mov    (%rax),%eax
  802b2f:	48 89 ce             	mov    %rcx,%rsi
  802b32:	89 c7                	mov    %eax,%edi
  802b34:	48 b8 5e 24 80 00 00 	movabs $0x80245e,%rax
  802b3b:	00 00 00 
  802b3e:	ff d0                	callq  *%rax
  802b40:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b47:	7e 13                	jle    802b5c <writebuf+0x5c>
			b->result += result;
  802b49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4d:	8b 40 08             	mov    0x8(%rax),%eax
  802b50:	89 c2                	mov    %eax,%edx
  802b52:	03 55 fc             	add    -0x4(%rbp),%edx
  802b55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b59:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802b5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b60:	8b 40 04             	mov    0x4(%rax),%eax
  802b63:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802b66:	74 16                	je     802b7e <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802b68:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b71:	89 c2                	mov    %eax,%edx
  802b73:	0f 4e 55 fc          	cmovle -0x4(%rbp),%edx
  802b77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7b:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802b7e:	c9                   	leaveq 
  802b7f:	c3                   	retq   

0000000000802b80 <putch>:

static void
putch(int ch, void *thunk)
{
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	48 83 ec 20          	sub    $0x20,%rsp
  802b88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802b8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b93:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802b97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b9b:	8b 40 04             	mov    0x4(%rax),%eax
  802b9e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ba1:	89 d6                	mov    %edx,%esi
  802ba3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802ba7:	48 63 d0             	movslq %eax,%rdx
  802baa:	40 88 74 11 10       	mov    %sil,0x10(%rcx,%rdx,1)
  802baf:	8d 50 01             	lea    0x1(%rax),%edx
  802bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb6:	89 50 04             	mov    %edx,0x4(%rax)
	if (b->idx == 256) {
  802bb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bbd:	8b 40 04             	mov    0x4(%rax),%eax
  802bc0:	3d 00 01 00 00       	cmp    $0x100,%eax
  802bc5:	75 1e                	jne    802be5 <putch+0x65>
		writebuf(b);
  802bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bcb:	48 89 c7             	mov    %rax,%rdi
  802bce:	48 b8 00 2b 80 00 00 	movabs $0x802b00,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
		b->idx = 0;
  802bda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
  802beb:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802bf2:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802bf8:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802bff:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802c06:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802c0c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802c12:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802c19:	00 00 00 
	b.result = 0;
  802c1c:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802c23:	00 00 00 
	b.error = 1;
  802c26:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802c2d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802c30:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802c37:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802c3e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c45:	48 89 c6             	mov    %rax,%rsi
  802c48:	48 bf 80 2b 80 00 00 	movabs $0x802b80,%rdi
  802c4f:	00 00 00 
  802c52:	48 b8 74 09 80 00 00 	movabs $0x800974,%rax
  802c59:	00 00 00 
  802c5c:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802c5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802c64:	85 c0                	test   %eax,%eax
  802c66:	7e 16                	jle    802c7e <vfprintf+0x97>
		writebuf(&b);
  802c68:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802c6f:	48 89 c7             	mov    %rax,%rdi
  802c72:	48 b8 00 2b 80 00 00 	movabs $0x802b00,%rax
  802c79:	00 00 00 
  802c7c:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802c7e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 08                	je     802c90 <vfprintf+0xa9>
  802c88:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802c8e:	eb 06                	jmp    802c96 <vfprintf+0xaf>
  802c90:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802c96:	c9                   	leaveq 
  802c97:	c3                   	retq   

0000000000802c98 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802c98:	55                   	push   %rbp
  802c99:	48 89 e5             	mov    %rsp,%rbp
  802c9c:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802ca3:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802ca9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802cb0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802cb7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802cbe:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802cc5:	84 c0                	test   %al,%al
  802cc7:	74 20                	je     802ce9 <fprintf+0x51>
  802cc9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802ccd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802cd1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802cd5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802cd9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802cdd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ce1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ce5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ce9:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802cf0:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802cf7:	00 00 00 
  802cfa:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802d01:	00 00 00 
  802d04:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802d08:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802d0f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802d16:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802d1d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802d24:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802d2b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802d31:	48 89 ce             	mov    %rcx,%rsi
  802d34:	89 c7                	mov    %eax,%edi
  802d36:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  802d3d:	00 00 00 
  802d40:	ff d0                	callq  *%rax
  802d42:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802d48:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802d4e:	c9                   	leaveq 
  802d4f:	c3                   	retq   

0000000000802d50 <printf>:

int
printf(const char *fmt, ...)
{
  802d50:	55                   	push   %rbp
  802d51:	48 89 e5             	mov    %rsp,%rbp
  802d54:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d5b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802d62:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d69:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d70:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d77:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d7e:	84 c0                	test   %al,%al
  802d80:	74 20                	je     802da2 <printf+0x52>
  802d82:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802d86:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802d8a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802d8e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802d92:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802d96:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802d9a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802d9e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802da2:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802da9:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802db0:	00 00 00 
  802db3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802dba:	00 00 00 
  802dbd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802dc1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802dc8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802dcf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802dd6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802ddd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802de4:	48 89 c6             	mov    %rax,%rsi
  802de7:	bf 01 00 00 00       	mov    $0x1,%edi
  802dec:	48 b8 e7 2b 80 00 00 	movabs $0x802be7,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
  802df8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802dfe:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   
	...

0000000000802e08 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802e08:	55                   	push   %rbp
  802e09:	48 89 e5             	mov    %rsp,%rbp
  802e0c:	48 83 ec 20          	sub    $0x20,%rsp
  802e10:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e13:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e1a:	48 89 d6             	mov    %rdx,%rsi
  802e1d:	89 c7                	mov    %eax,%edi
  802e1f:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  802e26:	00 00 00 
  802e29:	ff d0                	callq  *%rax
  802e2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e32:	79 05                	jns    802e39 <fd2sockid+0x31>
		return r;
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	eb 24                	jmp    802e5d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3d:	8b 10                	mov    (%rax),%edx
  802e3f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802e46:	00 00 00 
  802e49:	8b 00                	mov    (%rax),%eax
  802e4b:	39 c2                	cmp    %eax,%edx
  802e4d:	74 07                	je     802e56 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e4f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e54:	eb 07                	jmp    802e5d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e5d:	c9                   	leaveq 
  802e5e:	c3                   	retq   

0000000000802e5f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e5f:	55                   	push   %rbp
  802e60:	48 89 e5             	mov    %rsp,%rbp
  802e63:	48 83 ec 20          	sub    $0x20,%rsp
  802e67:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e6a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e6e:	48 89 c7             	mov    %rax,%rdi
  802e71:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  802e78:	00 00 00 
  802e7b:	ff d0                	callq  *%rax
  802e7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e84:	78 26                	js     802eac <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e8a:	ba 07 04 00 00       	mov    $0x407,%edx
  802e8f:	48 89 c6             	mov    %rax,%rsi
  802e92:	bf 00 00 00 00       	mov    $0x0,%edi
  802e97:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	79 16                	jns    802ec2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802eac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eaf:	89 c7                	mov    %eax,%edi
  802eb1:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  802eb8:	00 00 00 
  802ebb:	ff d0                	callq  *%rax
		return r;
  802ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec0:	eb 3a                	jmp    802efc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802ecd:	00 00 00 
  802ed0:	8b 12                	mov    (%rdx),%edx
  802ed2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ee6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ee9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eed:	48 89 c7             	mov    %rax,%rdi
  802ef0:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
}
  802efc:	c9                   	leaveq 
  802efd:	c3                   	retq   

0000000000802efe <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802efe:	55                   	push   %rbp
  802eff:	48 89 e5             	mov    %rsp,%rbp
  802f02:	48 83 ec 30          	sub    $0x30,%rsp
  802f06:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f14:	89 c7                	mov    %eax,%edi
  802f16:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802f1d:	00 00 00 
  802f20:	ff d0                	callq  *%rax
  802f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f29:	79 05                	jns    802f30 <accept+0x32>
		return r;
  802f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2e:	eb 3b                	jmp    802f6b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f30:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f34:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3b:	48 89 ce             	mov    %rcx,%rsi
  802f3e:	89 c7                	mov    %eax,%edi
  802f40:	48 b8 49 32 80 00 00 	movabs $0x803249,%rax
  802f47:	00 00 00 
  802f4a:	ff d0                	callq  *%rax
  802f4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f53:	79 05                	jns    802f5a <accept+0x5c>
		return r;
  802f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f58:	eb 11                	jmp    802f6b <accept+0x6d>
	return alloc_sockfd(r);
  802f5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5d:	89 c7                	mov    %eax,%edi
  802f5f:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  802f66:	00 00 00 
  802f69:	ff d0                	callq  *%rax
}
  802f6b:	c9                   	leaveq 
  802f6c:	c3                   	retq   

0000000000802f6d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f6d:	55                   	push   %rbp
  802f6e:	48 89 e5             	mov    %rsp,%rbp
  802f71:	48 83 ec 20          	sub    $0x20,%rsp
  802f75:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f78:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f7c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
  802f90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f97:	79 05                	jns    802f9e <bind+0x31>
		return r;
  802f99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9c:	eb 1b                	jmp    802fb9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f9e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fa1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa8:	48 89 ce             	mov    %rcx,%rsi
  802fab:	89 c7                	mov    %eax,%edi
  802fad:	48 b8 c8 32 80 00 00 	movabs $0x8032c8,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
}
  802fb9:	c9                   	leaveq 
  802fba:	c3                   	retq   

0000000000802fbb <shutdown>:

int
shutdown(int s, int how)
{
  802fbb:	55                   	push   %rbp
  802fbc:	48 89 e5             	mov    %rsp,%rbp
  802fbf:	48 83 ec 20          	sub    $0x20,%rsp
  802fc3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fcc:	89 c7                	mov    %eax,%edi
  802fce:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
  802fda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe1:	79 05                	jns    802fe8 <shutdown+0x2d>
		return r;
  802fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe6:	eb 16                	jmp    802ffe <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fe8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802feb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fee:	89 d6                	mov    %edx,%esi
  802ff0:	89 c7                	mov    %eax,%edi
  802ff2:	48 b8 2c 33 80 00 00 	movabs $0x80332c,%rax
  802ff9:	00 00 00 
  802ffc:	ff d0                	callq  *%rax
}
  802ffe:	c9                   	leaveq 
  802fff:	c3                   	retq   

0000000000803000 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803000:	55                   	push   %rbp
  803001:	48 89 e5             	mov    %rsp,%rbp
  803004:	48 83 ec 10          	sub    $0x10,%rsp
  803008:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80300c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803010:	48 89 c7             	mov    %rax,%rdi
  803013:	48 b8 98 40 80 00 00 	movabs $0x804098,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
  80301f:	83 f8 01             	cmp    $0x1,%eax
  803022:	75 17                	jne    80303b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803024:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803028:	8b 40 0c             	mov    0xc(%rax),%eax
  80302b:	89 c7                	mov    %eax,%edi
  80302d:	48 b8 6c 33 80 00 00 	movabs $0x80336c,%rax
  803034:	00 00 00 
  803037:	ff d0                	callq  *%rax
  803039:	eb 05                	jmp    803040 <devsock_close+0x40>
	else
		return 0;
  80303b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803040:	c9                   	leaveq 
  803041:	c3                   	retq   

0000000000803042 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803042:	55                   	push   %rbp
  803043:	48 89 e5             	mov    %rsp,%rbp
  803046:	48 83 ec 20          	sub    $0x20,%rsp
  80304a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80304d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803051:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803054:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803057:	89 c7                	mov    %eax,%edi
  803059:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
  803065:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803068:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306c:	79 05                	jns    803073 <connect+0x31>
		return r;
  80306e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803071:	eb 1b                	jmp    80308e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803073:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803076:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80307a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307d:	48 89 ce             	mov    %rcx,%rsi
  803080:	89 c7                	mov    %eax,%edi
  803082:	48 b8 99 33 80 00 00 	movabs $0x803399,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
}
  80308e:	c9                   	leaveq 
  80308f:	c3                   	retq   

0000000000803090 <listen>:

int
listen(int s, int backlog)
{
  803090:	55                   	push   %rbp
  803091:	48 89 e5             	mov    %rsp,%rbp
  803094:	48 83 ec 20          	sub    $0x20,%rsp
  803098:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80309b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80309e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030a1:	89 c7                	mov    %eax,%edi
  8030a3:	48 b8 08 2e 80 00 00 	movabs $0x802e08,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
  8030af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b6:	79 05                	jns    8030bd <listen+0x2d>
		return r;
  8030b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030bb:	eb 16                	jmp    8030d3 <listen+0x43>
	return nsipc_listen(r, backlog);
  8030bd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c3:	89 d6                	mov    %edx,%esi
  8030c5:	89 c7                	mov    %eax,%edi
  8030c7:	48 b8 fd 33 80 00 00 	movabs $0x8033fd,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
}
  8030d3:	c9                   	leaveq 
  8030d4:	c3                   	retq   

00000000008030d5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030d5:	55                   	push   %rbp
  8030d6:	48 89 e5             	mov    %rsp,%rbp
  8030d9:	48 83 ec 20          	sub    $0x20,%rsp
  8030dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ed:	89 c2                	mov    %eax,%edx
  8030ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030f3:	8b 40 0c             	mov    0xc(%rax),%eax
  8030f6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030ff:	89 c7                	mov    %eax,%edi
  803101:	48 b8 3d 34 80 00 00 	movabs $0x80343d,%rax
  803108:	00 00 00 
  80310b:	ff d0                	callq  *%rax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
  803113:	48 83 ec 20          	sub    $0x20,%rsp
  803117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80311b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80311f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803127:	89 c2                	mov    %eax,%edx
  803129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312d:	8b 40 0c             	mov    0xc(%rax),%eax
  803130:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803134:	b9 00 00 00 00       	mov    $0x0,%ecx
  803139:	89 c7                	mov    %eax,%edi
  80313b:	48 b8 09 35 80 00 00 	movabs $0x803509,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 10          	sub    $0x10,%rsp
  803151:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803155:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803159:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315d:	48 be 33 47 80 00 00 	movabs $0x804733,%rsi
  803164:	00 00 00 
  803167:	48 89 c7             	mov    %rax,%rdi
  80316a:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  803171:	00 00 00 
  803174:	ff d0                	callq  *%rax
	return 0;
  803176:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80317b:	c9                   	leaveq 
  80317c:	c3                   	retq   

000000000080317d <socket>:

int
socket(int domain, int type, int protocol)
{
  80317d:	55                   	push   %rbp
  80317e:	48 89 e5             	mov    %rsp,%rbp
  803181:	48 83 ec 20          	sub    $0x20,%rsp
  803185:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803188:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80318b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80318e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803191:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803194:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803197:	89 ce                	mov    %ecx,%esi
  803199:	89 c7                	mov    %eax,%edi
  80319b:	48 b8 c1 35 80 00 00 	movabs $0x8035c1,%rax
  8031a2:	00 00 00 
  8031a5:	ff d0                	callq  *%rax
  8031a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ae:	79 05                	jns    8031b5 <socket+0x38>
		return r;
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b3:	eb 11                	jmp    8031c6 <socket+0x49>
	return alloc_sockfd(r);
  8031b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b8:	89 c7                	mov    %eax,%edi
  8031ba:	48 b8 5f 2e 80 00 00 	movabs $0x802e5f,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	48 83 ec 10          	sub    $0x10,%rsp
  8031d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031d3:	48 b8 34 70 80 00 00 	movabs $0x807034,%rax
  8031da:	00 00 00 
  8031dd:	8b 00                	mov    (%rax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	75 1d                	jne    803200 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031e3:	bf 02 00 00 00       	mov    $0x2,%edi
  8031e8:	48 b8 13 40 80 00 00 	movabs $0x804013,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
  8031f4:	48 ba 34 70 80 00 00 	movabs $0x807034,%rdx
  8031fb:	00 00 00 
  8031fe:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803200:	48 b8 34 70 80 00 00 	movabs $0x807034,%rax
  803207:	00 00 00 
  80320a:	8b 00                	mov    (%rax),%eax
  80320c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80320f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803214:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80321b:	00 00 00 
  80321e:	89 c7                	mov    %eax,%edi
  803220:	48 b8 50 3f 80 00 00 	movabs $0x803f50,%rax
  803227:	00 00 00 
  80322a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80322c:	ba 00 00 00 00       	mov    $0x0,%edx
  803231:	be 00 00 00 00       	mov    $0x0,%esi
  803236:	bf 00 00 00 00       	mov    $0x0,%edi
  80323b:	48 b8 90 3e 80 00 00 	movabs $0x803e90,%rax
  803242:	00 00 00 
  803245:	ff d0                	callq  *%rax
}
  803247:	c9                   	leaveq 
  803248:	c3                   	retq   

0000000000803249 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803249:	55                   	push   %rbp
  80324a:	48 89 e5             	mov    %rsp,%rbp
  80324d:	48 83 ec 30          	sub    $0x30,%rsp
  803251:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803254:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803258:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80325c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803263:	00 00 00 
  803266:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803269:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80326b:	bf 01 00 00 00       	mov    $0x1,%edi
  803270:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803283:	78 3e                	js     8032c3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803285:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80328c:	00 00 00 
  80328f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803297:	8b 40 10             	mov    0x10(%rax),%eax
  80329a:	89 c2                	mov    %eax,%edx
  80329c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8032a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a4:	48 89 ce             	mov    %rcx,%rsi
  8032a7:	48 89 c7             	mov    %rax,%rdi
  8032aa:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  8032b1:	00 00 00 
  8032b4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ba:	8b 50 10             	mov    0x10(%rax),%edx
  8032bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032c6:	c9                   	leaveq 
  8032c7:	c3                   	retq   

00000000008032c8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032c8:	55                   	push   %rbp
  8032c9:	48 89 e5             	mov    %rsp,%rbp
  8032cc:	48 83 ec 10          	sub    $0x10,%rsp
  8032d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032d7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e1:	00 00 00 
  8032e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032e7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f0:	48 89 c6             	mov    %rax,%rsi
  8032f3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8032fa:	00 00 00 
  8032fd:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  803304:	00 00 00 
  803307:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803309:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803310:	00 00 00 
  803313:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803316:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803319:	bf 02 00 00 00       	mov    $0x2,%edi
  80331e:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
}
  80332a:	c9                   	leaveq 
  80332b:	c3                   	retq   

000000000080332c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80332c:	55                   	push   %rbp
  80332d:	48 89 e5             	mov    %rsp,%rbp
  803330:	48 83 ec 10          	sub    $0x10,%rsp
  803334:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803337:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80333a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803341:	00 00 00 
  803344:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803347:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803349:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803350:	00 00 00 
  803353:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803356:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803359:	bf 03 00 00 00       	mov    $0x3,%edi
  80335e:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
}
  80336a:	c9                   	leaveq 
  80336b:	c3                   	retq   

000000000080336c <nsipc_close>:

int
nsipc_close(int s)
{
  80336c:	55                   	push   %rbp
  80336d:	48 89 e5             	mov    %rsp,%rbp
  803370:	48 83 ec 10          	sub    $0x10,%rsp
  803374:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803377:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80337e:	00 00 00 
  803381:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803384:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803386:	bf 04 00 00 00       	mov    $0x4,%edi
  80338b:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
}
  803397:	c9                   	leaveq 
  803398:	c3                   	retq   

0000000000803399 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803399:	55                   	push   %rbp
  80339a:	48 89 e5             	mov    %rsp,%rbp
  80339d:	48 83 ec 10          	sub    $0x10,%rsp
  8033a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033a8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8033ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033b2:	00 00 00 
  8033b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033b8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033ba:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c1:	48 89 c6             	mov    %rax,%rsi
  8033c4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8033cb:	00 00 00 
  8033ce:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  8033d5:	00 00 00 
  8033d8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033da:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8033e1:	00 00 00 
  8033e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033ea:	bf 05 00 00 00       	mov    $0x5,%edi
  8033ef:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
}
  8033fb:	c9                   	leaveq 
  8033fc:	c3                   	retq   

00000000008033fd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033fd:	55                   	push   %rbp
  8033fe:	48 89 e5             	mov    %rsp,%rbp
  803401:	48 83 ec 10          	sub    $0x10,%rsp
  803405:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803408:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80340b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803412:	00 00 00 
  803415:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803418:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80341a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803421:	00 00 00 
  803424:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80342a:	bf 06 00 00 00       	mov    $0x6,%edi
  80342f:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  803436:	00 00 00 
  803439:	ff d0                	callq  *%rax
}
  80343b:	c9                   	leaveq 
  80343c:	c3                   	retq   

000000000080343d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80343d:	55                   	push   %rbp
  80343e:	48 89 e5             	mov    %rsp,%rbp
  803441:	48 83 ec 30          	sub    $0x30,%rsp
  803445:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803448:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80344c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80344f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803452:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803459:	00 00 00 
  80345c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80345f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803461:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803468:	00 00 00 
  80346b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80346e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803471:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803478:	00 00 00 
  80347b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80347e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803481:	bf 07 00 00 00       	mov    $0x7,%edi
  803486:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  80348d:	00 00 00 
  803490:	ff d0                	callq  *%rax
  803492:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803495:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803499:	78 69                	js     803504 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80349b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8034a2:	7f 08                	jg     8034ac <nsipc_recv+0x6f>
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8034aa:	7e 35                	jle    8034e1 <nsipc_recv+0xa4>
  8034ac:	48 b9 3a 47 80 00 00 	movabs $0x80473a,%rcx
  8034b3:	00 00 00 
  8034b6:	48 ba 4f 47 80 00 00 	movabs $0x80474f,%rdx
  8034bd:	00 00 00 
  8034c0:	be 61 00 00 00       	mov    $0x61,%esi
  8034c5:	48 bf 64 47 80 00 00 	movabs $0x804764,%rdi
  8034cc:	00 00 00 
  8034cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d4:	49 b8 88 03 80 00 00 	movabs $0x800388,%r8
  8034db:	00 00 00 
  8034de:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e4:	48 63 d0             	movslq %eax,%rdx
  8034e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034eb:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8034f2:	00 00 00 
  8034f5:	48 89 c7             	mov    %rax,%rdi
  8034f8:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  8034ff:	00 00 00 
  803502:	ff d0                	callq  *%rax
	}

	return r;
  803504:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803507:	c9                   	leaveq 
  803508:	c3                   	retq   

0000000000803509 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803509:	55                   	push   %rbp
  80350a:	48 89 e5             	mov    %rsp,%rbp
  80350d:	48 83 ec 20          	sub    $0x20,%rsp
  803511:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803514:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803518:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80351b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80351e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803525:	00 00 00 
  803528:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80352b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80352d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803534:	7e 35                	jle    80356b <nsipc_send+0x62>
  803536:	48 b9 70 47 80 00 00 	movabs $0x804770,%rcx
  80353d:	00 00 00 
  803540:	48 ba 4f 47 80 00 00 	movabs $0x80474f,%rdx
  803547:	00 00 00 
  80354a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80354f:	48 bf 64 47 80 00 00 	movabs $0x804764,%rdi
  803556:	00 00 00 
  803559:	b8 00 00 00 00       	mov    $0x0,%eax
  80355e:	49 b8 88 03 80 00 00 	movabs $0x800388,%r8
  803565:	00 00 00 
  803568:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80356b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80356e:	48 63 d0             	movslq %eax,%rdx
  803571:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803575:	48 89 c6             	mov    %rax,%rsi
  803578:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80357f:	00 00 00 
  803582:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  803589:	00 00 00 
  80358c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80358e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803595:	00 00 00 
  803598:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80359e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a5:	00 00 00 
  8035a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035ab:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8035ae:	bf 08 00 00 00       	mov    $0x8,%edi
  8035b3:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  8035ba:	00 00 00 
  8035bd:	ff d0                	callq  *%rax
}
  8035bf:	c9                   	leaveq 
  8035c0:	c3                   	retq   

00000000008035c1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035c1:	55                   	push   %rbp
  8035c2:	48 89 e5             	mov    %rsp,%rbp
  8035c5:	48 83 ec 10          	sub    $0x10,%rsp
  8035c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035cc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035cf:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035d9:	00 00 00 
  8035dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035e1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e8:	00 00 00 
  8035eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ee:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f8:	00 00 00 
  8035fb:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035fe:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803601:	bf 09 00 00 00       	mov    $0x9,%edi
  803606:	48 b8 c8 31 80 00 00 	movabs $0x8031c8,%rax
  80360d:	00 00 00 
  803610:	ff d0                	callq  *%rax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	53                   	push   %rbx
  803619:	48 83 ec 38          	sub    $0x38,%rsp
  80361d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803621:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803625:	48 89 c7             	mov    %rax,%rdi
  803628:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  80362f:	00 00 00 
  803632:	ff d0                	callq  *%rax
  803634:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803637:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80363b:	0f 88 bf 01 00 00    	js     803800 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803645:	ba 07 04 00 00       	mov    $0x407,%edx
  80364a:	48 89 c6             	mov    %rax,%rsi
  80364d:	bf 00 00 00 00       	mov    $0x0,%edi
  803652:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  803659:	00 00 00 
  80365c:	ff d0                	callq  *%rax
  80365e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803661:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803665:	0f 88 95 01 00 00    	js     803800 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80366b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80366f:	48 89 c7             	mov    %rax,%rdi
  803672:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  803679:	00 00 00 
  80367c:	ff d0                	callq  *%rax
  80367e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803681:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803685:	0f 88 5d 01 00 00    	js     8037e8 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80368b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368f:	ba 07 04 00 00       	mov    $0x407,%edx
  803694:	48 89 c6             	mov    %rax,%rsi
  803697:	bf 00 00 00 00       	mov    $0x0,%edi
  80369c:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8036a3:	00 00 00 
  8036a6:	ff d0                	callq  *%rax
  8036a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036af:	0f 88 33 01 00 00    	js     8037e8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b9:	48 89 c7             	mov    %rax,%rdi
  8036bc:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8036c3:	00 00 00 
  8036c6:	ff d0                	callq  *%rax
  8036c8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d0:	ba 07 04 00 00       	mov    $0x407,%edx
  8036d5:	48 89 c6             	mov    %rax,%rsi
  8036d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8036dd:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8036e4:	00 00 00 
  8036e7:	ff d0                	callq  *%rax
  8036e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036f0:	0f 88 d9 00 00 00    	js     8037cf <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036fa:	48 89 c7             	mov    %rax,%rdi
  8036fd:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  803704:	00 00 00 
  803707:	ff d0                	callq  *%rax
  803709:	48 89 c2             	mov    %rax,%rdx
  80370c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803710:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803716:	48 89 d1             	mov    %rdx,%rcx
  803719:	ba 00 00 00 00       	mov    $0x0,%edx
  80371e:	48 89 c6             	mov    %rax,%rsi
  803721:	bf 00 00 00 00       	mov    $0x0,%edi
  803726:	48 b8 08 1b 80 00 00 	movabs $0x801b08,%rax
  80372d:	00 00 00 
  803730:	ff d0                	callq  *%rax
  803732:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803735:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803739:	78 79                	js     8037b4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80373b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80373f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803746:	00 00 00 
  803749:	8b 12                	mov    (%rdx),%edx
  80374b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80374d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803751:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803758:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803763:	00 00 00 
  803766:	8b 12                	mov    (%rdx),%edx
  803768:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80376a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80376e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803775:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803779:	48 89 c7             	mov    %rax,%rdi
  80377c:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  803783:	00 00 00 
  803786:	ff d0                	callq  *%rax
  803788:	89 c2                	mov    %eax,%edx
  80378a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80378e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803790:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803794:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803798:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80379c:	48 89 c7             	mov    %rax,%rdi
  80379f:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  8037a6:	00 00 00 
  8037a9:	ff d0                	callq  *%rax
  8037ab:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b2:	eb 4f                	jmp    803803 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8037b4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8037b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b9:	48 89 c6             	mov    %rax,%rsi
  8037bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8037c1:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8037c8:	00 00 00 
  8037cb:	ff d0                	callq  *%rax
  8037cd:	eb 01                	jmp    8037d0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8037cf:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8037d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037d4:	48 89 c6             	mov    %rax,%rsi
  8037d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8037dc:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8037e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ec:	48 89 c6             	mov    %rax,%rsi
  8037ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8037f4:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  8037fb:	00 00 00 
  8037fe:	ff d0                	callq  *%rax
    err:
	return r;
  803800:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803803:	48 83 c4 38          	add    $0x38,%rsp
  803807:	5b                   	pop    %rbx
  803808:	5d                   	pop    %rbp
  803809:	c3                   	retq   

000000000080380a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80380a:	55                   	push   %rbp
  80380b:	48 89 e5             	mov    %rsp,%rbp
  80380e:	53                   	push   %rbx
  80380f:	48 83 ec 28          	sub    $0x28,%rsp
  803813:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803817:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80381b:	eb 01                	jmp    80381e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  80381d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80381e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803825:	00 00 00 
  803828:	48 8b 00             	mov    (%rax),%rax
  80382b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803831:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803834:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803838:	48 89 c7             	mov    %rax,%rdi
  80383b:	48 b8 98 40 80 00 00 	movabs $0x804098,%rax
  803842:	00 00 00 
  803845:	ff d0                	callq  *%rax
  803847:	89 c3                	mov    %eax,%ebx
  803849:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80384d:	48 89 c7             	mov    %rax,%rdi
  803850:	48 b8 98 40 80 00 00 	movabs $0x804098,%rax
  803857:	00 00 00 
  80385a:	ff d0                	callq  *%rax
  80385c:	39 c3                	cmp    %eax,%ebx
  80385e:	0f 94 c0             	sete   %al
  803861:	0f b6 c0             	movzbl %al,%eax
  803864:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803867:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80386e:	00 00 00 
  803871:	48 8b 00             	mov    (%rax),%rax
  803874:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80387a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80387d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803880:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803883:	75 0a                	jne    80388f <_pipeisclosed+0x85>
			return ret;
  803885:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803888:	48 83 c4 28          	add    $0x28,%rsp
  80388c:	5b                   	pop    %rbx
  80388d:	5d                   	pop    %rbp
  80388e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80388f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803892:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803895:	74 86                	je     80381d <_pipeisclosed+0x13>
  803897:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80389b:	75 80                	jne    80381d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80389d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8038a4:	00 00 00 
  8038a7:	48 8b 00             	mov    (%rax),%rax
  8038aa:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038b0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b6:	89 c6                	mov    %eax,%esi
  8038b8:	48 bf 81 47 80 00 00 	movabs $0x804781,%rdi
  8038bf:	00 00 00 
  8038c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c7:	49 b8 c3 05 80 00 00 	movabs $0x8005c3,%r8
  8038ce:	00 00 00 
  8038d1:	41 ff d0             	callq  *%r8
	}
  8038d4:	e9 44 ff ff ff       	jmpq   80381d <_pipeisclosed+0x13>

00000000008038d9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8038d9:	55                   	push   %rbp
  8038da:	48 89 e5             	mov    %rsp,%rbp
  8038dd:	48 83 ec 30          	sub    $0x30,%rsp
  8038e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038e4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038eb:	48 89 d6             	mov    %rdx,%rsi
  8038ee:	89 c7                	mov    %eax,%edi
  8038f0:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  8038f7:	00 00 00 
  8038fa:	ff d0                	callq  *%rax
  8038fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803903:	79 05                	jns    80390a <pipeisclosed+0x31>
		return r;
  803905:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803908:	eb 31                	jmp    80393b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80390a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390e:	48 89 c7             	mov    %rax,%rdi
  803911:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  803918:	00 00 00 
  80391b:	ff d0                	callq  *%rax
  80391d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803925:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803929:	48 89 d6             	mov    %rdx,%rsi
  80392c:	48 89 c7             	mov    %rax,%rdi
  80392f:	48 b8 0a 38 80 00 00 	movabs $0x80380a,%rax
  803936:	00 00 00 
  803939:	ff d0                	callq  *%rax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 40          	sub    $0x40,%rsp
  803945:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803949:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80394d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803955:	48 89 c7             	mov    %rax,%rdi
  803958:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  80395f:	00 00 00 
  803962:	ff d0                	callq  *%rax
  803964:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803968:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80396c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803970:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803977:	00 
  803978:	e9 97 00 00 00       	jmpq   803a14 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80397d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803982:	74 09                	je     80398d <devpipe_read+0x50>
				return i;
  803984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803988:	e9 95 00 00 00       	jmpq   803a22 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80398d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803995:	48 89 d6             	mov    %rdx,%rsi
  803998:	48 89 c7             	mov    %rax,%rdi
  80399b:	48 b8 0a 38 80 00 00 	movabs $0x80380a,%rax
  8039a2:	00 00 00 
  8039a5:	ff d0                	callq  *%rax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 07                	je     8039b2 <devpipe_read+0x75>
				return 0;
  8039ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b0:	eb 70                	jmp    803a22 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039b2:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
  8039be:	eb 01                	jmp    8039c1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039c0:	90                   	nop
  8039c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c5:	8b 10                	mov    (%rax),%edx
  8039c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039cb:	8b 40 04             	mov    0x4(%rax),%eax
  8039ce:	39 c2                	cmp    %eax,%edx
  8039d0:	74 ab                	je     80397d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039da:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e2:	8b 00                	mov    (%rax),%eax
  8039e4:	89 c2                	mov    %eax,%edx
  8039e6:	c1 fa 1f             	sar    $0x1f,%edx
  8039e9:	c1 ea 1b             	shr    $0x1b,%edx
  8039ec:	01 d0                	add    %edx,%eax
  8039ee:	83 e0 1f             	and    $0x1f,%eax
  8039f1:	29 d0                	sub    %edx,%eax
  8039f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039f7:	48 98                	cltq   
  8039f9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039fe:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a04:	8b 00                	mov    (%rax),%eax
  803a06:	8d 50 01             	lea    0x1(%rax),%edx
  803a09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a0f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a18:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a1c:	72 a2                	jb     8039c0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a22:	c9                   	leaveq 
  803a23:	c3                   	retq   

0000000000803a24 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a24:	55                   	push   %rbp
  803a25:	48 89 e5             	mov    %rsp,%rbp
  803a28:	48 83 ec 40          	sub    $0x40,%rsp
  803a2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a34:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a38:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a3c:	48 89 c7             	mov    %rax,%rdi
  803a3f:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
  803a4b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a57:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a5e:	00 
  803a5f:	e9 93 00 00 00       	jmpq   803af7 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a64:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6c:	48 89 d6             	mov    %rdx,%rsi
  803a6f:	48 89 c7             	mov    %rax,%rdi
  803a72:	48 b8 0a 38 80 00 00 	movabs $0x80380a,%rax
  803a79:	00 00 00 
  803a7c:	ff d0                	callq  *%rax
  803a7e:	85 c0                	test   %eax,%eax
  803a80:	74 07                	je     803a89 <devpipe_write+0x65>
				return 0;
  803a82:	b8 00 00 00 00       	mov    $0x0,%eax
  803a87:	eb 7c                	jmp    803b05 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a89:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  803a90:	00 00 00 
  803a93:	ff d0                	callq  *%rax
  803a95:	eb 01                	jmp    803a98 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a97:	90                   	nop
  803a98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a9c:	8b 40 04             	mov    0x4(%rax),%eax
  803a9f:	48 63 d0             	movslq %eax,%rdx
  803aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa6:	8b 00                	mov    (%rax),%eax
  803aa8:	48 98                	cltq   
  803aaa:	48 83 c0 20          	add    $0x20,%rax
  803aae:	48 39 c2             	cmp    %rax,%rdx
  803ab1:	73 b1                	jae    803a64 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ab3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ab7:	8b 40 04             	mov    0x4(%rax),%eax
  803aba:	89 c2                	mov    %eax,%edx
  803abc:	c1 fa 1f             	sar    $0x1f,%edx
  803abf:	c1 ea 1b             	shr    $0x1b,%edx
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	83 e0 1f             	and    $0x1f,%eax
  803ac7:	29 d0                	sub    %edx,%eax
  803ac9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803acd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ad1:	48 01 ca             	add    %rcx,%rdx
  803ad4:	0f b6 0a             	movzbl (%rdx),%ecx
  803ad7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803adb:	48 98                	cltq   
  803add:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae5:	8b 40 04             	mov    0x4(%rax),%eax
  803ae8:	8d 50 01             	lea    0x1(%rax),%edx
  803aeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aef:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803af2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803afb:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803aff:	72 96                	jb     803a97 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b05:	c9                   	leaveq 
  803b06:	c3                   	retq   

0000000000803b07 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b07:	55                   	push   %rbp
  803b08:	48 89 e5             	mov    %rsp,%rbp
  803b0b:	48 83 ec 20          	sub    $0x20,%rsp
  803b0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b13:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b1b:	48 89 c7             	mov    %rax,%rdi
  803b1e:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
  803b2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b32:	48 be 94 47 80 00 00 	movabs $0x804794,%rsi
  803b39:	00 00 00 
  803b3c:	48 89 c7             	mov    %rax,%rdi
  803b3f:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  803b46:	00 00 00 
  803b49:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4f:	8b 50 04             	mov    0x4(%rax),%edx
  803b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b56:	8b 00                	mov    (%rax),%eax
  803b58:	29 c2                	sub    %eax,%edx
  803b5a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b68:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b6f:	00 00 00 
	stat->st_dev = &devpipe;
  803b72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b76:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b7d:	00 00 00 
  803b80:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b8c:	c9                   	leaveq 
  803b8d:	c3                   	retq   

0000000000803b8e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b8e:	55                   	push   %rbp
  803b8f:	48 89 e5             	mov    %rsp,%rbp
  803b92:	48 83 ec 10          	sub    $0x10,%rsp
  803b96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803b9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b9e:	48 89 c6             	mov    %rax,%rsi
  803ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ba6:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803bb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bb6:	48 89 c7             	mov    %rax,%rdi
  803bb9:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
  803bc5:	48 89 c6             	mov    %rax,%rsi
  803bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bcd:	48 b8 63 1b 80 00 00 	movabs $0x801b63,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
}
  803bd9:	c9                   	leaveq 
  803bda:	c3                   	retq   
	...

0000000000803bdc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bdc:	55                   	push   %rbp
  803bdd:	48 89 e5             	mov    %rsp,%rbp
  803be0:	48 83 ec 20          	sub    $0x20,%rsp
  803be4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803be7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bea:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bed:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bf1:	be 01 00 00 00       	mov    $0x1,%esi
  803bf6:	48 89 c7             	mov    %rax,%rdi
  803bf9:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803c00:	00 00 00 
  803c03:	ff d0                	callq  *%rax
}
  803c05:	c9                   	leaveq 
  803c06:	c3                   	retq   

0000000000803c07 <getchar>:

int
getchar(void)
{
  803c07:	55                   	push   %rbp
  803c08:	48 89 e5             	mov    %rsp,%rbp
  803c0b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c0f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c13:	ba 01 00 00 00       	mov    $0x1,%edx
  803c18:	48 89 c6             	mov    %rax,%rsi
  803c1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803c20:	48 b8 10 23 80 00 00 	movabs $0x802310,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
  803c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c33:	79 05                	jns    803c3a <getchar+0x33>
		return r;
  803c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c38:	eb 14                	jmp    803c4e <getchar+0x47>
	if (r < 1)
  803c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c3e:	7f 07                	jg     803c47 <getchar+0x40>
		return -E_EOF;
  803c40:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c45:	eb 07                	jmp    803c4e <getchar+0x47>
	return c;
  803c47:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c4b:	0f b6 c0             	movzbl %al,%eax
}
  803c4e:	c9                   	leaveq 
  803c4f:	c3                   	retq   

0000000000803c50 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c50:	55                   	push   %rbp
  803c51:	48 89 e5             	mov    %rsp,%rbp
  803c54:	48 83 ec 20          	sub    $0x20,%rsp
  803c58:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c5b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c62:	48 89 d6             	mov    %rdx,%rsi
  803c65:	89 c7                	mov    %eax,%edi
  803c67:	48 b8 de 1e 80 00 00 	movabs $0x801ede,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
  803c73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c7a:	79 05                	jns    803c81 <iscons+0x31>
		return r;
  803c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c7f:	eb 1a                	jmp    803c9b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c85:	8b 10                	mov    (%rax),%edx
  803c87:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803c8e:	00 00 00 
  803c91:	8b 00                	mov    (%rax),%eax
  803c93:	39 c2                	cmp    %eax,%edx
  803c95:	0f 94 c0             	sete   %al
  803c98:	0f b6 c0             	movzbl %al,%eax
}
  803c9b:	c9                   	leaveq 
  803c9c:	c3                   	retq   

0000000000803c9d <opencons>:

int
opencons(void)
{
  803c9d:	55                   	push   %rbp
  803c9e:	48 89 e5             	mov    %rsp,%rbp
  803ca1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ca5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ca9:	48 89 c7             	mov    %rax,%rdi
  803cac:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  803cb3:	00 00 00 
  803cb6:	ff d0                	callq  *%rax
  803cb8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cbf:	79 05                	jns    803cc6 <opencons+0x29>
		return r;
  803cc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc4:	eb 5b                	jmp    803d21 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cca:	ba 07 04 00 00       	mov    $0x407,%edx
  803ccf:	48 89 c6             	mov    %rax,%rsi
  803cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd7:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  803cde:	00 00 00 
  803ce1:	ff d0                	callq  *%rax
  803ce3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ce6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cea:	79 05                	jns    803cf1 <opencons+0x54>
		return r;
  803cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cef:	eb 30                	jmp    803d21 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cf1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf5:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803cfc:	00 00 00 
  803cff:	8b 12                	mov    (%rdx),%edx
  803d01:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d07:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d12:	48 89 c7             	mov    %rax,%rdi
  803d15:	48 b8 f8 1d 80 00 00 	movabs $0x801df8,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
}
  803d21:	c9                   	leaveq 
  803d22:	c3                   	retq   

0000000000803d23 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d23:	55                   	push   %rbp
  803d24:	48 89 e5             	mov    %rsp,%rbp
  803d27:	48 83 ec 30          	sub    $0x30,%rsp
  803d2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d33:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d37:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d3c:	75 13                	jne    803d51 <devcons_read+0x2e>
		return 0;
  803d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d43:	eb 49                	jmp    803d8e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803d45:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  803d4c:	00 00 00 
  803d4f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d51:	48 b8 ba 19 80 00 00 	movabs $0x8019ba,%rax
  803d58:	00 00 00 
  803d5b:	ff d0                	callq  *%rax
  803d5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d64:	74 df                	je     803d45 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803d66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6a:	79 05                	jns    803d71 <devcons_read+0x4e>
		return c;
  803d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6f:	eb 1d                	jmp    803d8e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803d71:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d75:	75 07                	jne    803d7e <devcons_read+0x5b>
		return 0;
  803d77:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7c:	eb 10                	jmp    803d8e <devcons_read+0x6b>
	*(char*)vbuf = c;
  803d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d81:	89 c2                	mov    %eax,%edx
  803d83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d87:	88 10                	mov    %dl,(%rax)
	return 1;
  803d89:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d8e:	c9                   	leaveq 
  803d8f:	c3                   	retq   

0000000000803d90 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d90:	55                   	push   %rbp
  803d91:	48 89 e5             	mov    %rsp,%rbp
  803d94:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d9b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803da2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803da9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803db0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803db7:	eb 77                	jmp    803e30 <devcons_write+0xa0>
		m = n - tot;
  803db9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dc0:	89 c2                	mov    %eax,%edx
  803dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc5:	89 d1                	mov    %edx,%ecx
  803dc7:	29 c1                	sub    %eax,%ecx
  803dc9:	89 c8                	mov    %ecx,%eax
  803dcb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803dce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dd1:	83 f8 7f             	cmp    $0x7f,%eax
  803dd4:	76 07                	jbe    803ddd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803dd6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ddd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803de0:	48 63 d0             	movslq %eax,%rdx
  803de3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de6:	48 98                	cltq   
  803de8:	48 89 c1             	mov    %rax,%rcx
  803deb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803df2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803df9:	48 89 ce             	mov    %rcx,%rsi
  803dfc:	48 89 c7             	mov    %rax,%rdi
  803dff:	48 b8 a2 14 80 00 00 	movabs $0x8014a2,%rax
  803e06:	00 00 00 
  803e09:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e0e:	48 63 d0             	movslq %eax,%rdx
  803e11:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e18:	48 89 d6             	mov    %rdx,%rsi
  803e1b:	48 89 c7             	mov    %rax,%rdi
  803e1e:	48 b8 70 19 80 00 00 	movabs $0x801970,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e2d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e33:	48 98                	cltq   
  803e35:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e3c:	0f 82 77 ff ff ff    	jb     803db9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e45:	c9                   	leaveq 
  803e46:	c3                   	retq   

0000000000803e47 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e47:	55                   	push   %rbp
  803e48:	48 89 e5             	mov    %rsp,%rbp
  803e4b:	48 83 ec 08          	sub    $0x8,%rsp
  803e4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e58:	c9                   	leaveq 
  803e59:	c3                   	retq   

0000000000803e5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e5a:	55                   	push   %rbp
  803e5b:	48 89 e5             	mov    %rsp,%rbp
  803e5e:	48 83 ec 10          	sub    $0x10,%rsp
  803e62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e6e:	48 be a0 47 80 00 00 	movabs $0x8047a0,%rsi
  803e75:	00 00 00 
  803e78:	48 89 c7             	mov    %rax,%rdi
  803e7b:	48 b8 80 11 80 00 00 	movabs $0x801180,%rax
  803e82:	00 00 00 
  803e85:	ff d0                	callq  *%rax
	return 0;
  803e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e8c:	c9                   	leaveq 
  803e8d:	c3                   	retq   
	...

0000000000803e90 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803e90:	55                   	push   %rbp
  803e91:	48 89 e5             	mov    %rsp,%rbp
  803e94:	48 83 ec 30          	sub    $0x30,%rsp
  803e98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e9c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803ea4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ea9:	74 18                	je     803ec3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803eab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eaf:	48 89 c7             	mov    %rax,%rdi
  803eb2:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax
  803ebe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ec1:	eb 19                	jmp    803edc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803ec3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803eca:	00 00 00 
  803ecd:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  803ed4:	00 00 00 
  803ed7:	ff d0                	callq  *%rax
  803ed9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee0:	79 19                	jns    803efb <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803eec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ef9:	eb 53                	jmp    803f4e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803efb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f00:	74 19                	je     803f1b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803f02:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f09:	00 00 00 
  803f0c:	48 8b 00             	mov    (%rax),%rax
  803f0f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f19:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803f1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f20:	74 19                	je     803f3b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803f22:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f29:	00 00 00 
  803f2c:	48 8b 00             	mov    (%rax),%rax
  803f2f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f39:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803f3b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f42:	00 00 00 
  803f45:	48 8b 00             	mov    (%rax),%rax
  803f48:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803f4e:	c9                   	leaveq 
  803f4f:	c3                   	retq   

0000000000803f50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f50:	55                   	push   %rbp
  803f51:	48 89 e5             	mov    %rsp,%rbp
  803f54:	48 83 ec 30          	sub    $0x30,%rsp
  803f58:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f5b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f5e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f62:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803f65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803f6c:	e9 96 00 00 00       	jmpq   804007 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803f71:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f76:	74 20                	je     803f98 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803f78:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f7b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803f7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f85:	89 c7                	mov    %eax,%edi
  803f87:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
  803f93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f96:	eb 2d                	jmp    803fc5 <ipc_send+0x75>
		else if(pg==NULL)
  803f98:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f9d:	75 26                	jne    803fc5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803f9f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803fa2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa5:	b9 00 00 00 00       	mov    $0x0,%ecx
  803faa:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803fb1:	00 00 00 
  803fb4:	89 c7                	mov    %eax,%edi
  803fb6:	48 b8 8c 1c 80 00 00 	movabs $0x801c8c,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
  803fc2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803fc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc9:	79 30                	jns    803ffb <ipc_send+0xab>
  803fcb:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fcf:	74 2a                	je     803ffb <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803fd1:	48 ba a7 47 80 00 00 	movabs $0x8047a7,%rdx
  803fd8:	00 00 00 
  803fdb:	be 40 00 00 00       	mov    $0x40,%esi
  803fe0:	48 bf bf 47 80 00 00 	movabs $0x8047bf,%rdi
  803fe7:	00 00 00 
  803fea:	b8 00 00 00 00       	mov    $0x0,%eax
  803fef:	48 b9 88 03 80 00 00 	movabs $0x800388,%rcx
  803ff6:	00 00 00 
  803ff9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803ffb:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80400b:	0f 85 60 ff ff ff    	jne    803f71 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804011:	c9                   	leaveq 
  804012:	c3                   	retq   

0000000000804013 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804013:	55                   	push   %rbp
  804014:	48 89 e5             	mov    %rsp,%rbp
  804017:	48 83 ec 18          	sub    $0x18,%rsp
  80401b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80401e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804025:	eb 5e                	jmp    804085 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804027:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80402e:	00 00 00 
  804031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804034:	48 63 d0             	movslq %eax,%rdx
  804037:	48 89 d0             	mov    %rdx,%rax
  80403a:	48 c1 e0 03          	shl    $0x3,%rax
  80403e:	48 01 d0             	add    %rdx,%rax
  804041:	48 c1 e0 05          	shl    $0x5,%rax
  804045:	48 01 c8             	add    %rcx,%rax
  804048:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80404e:	8b 00                	mov    (%rax),%eax
  804050:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804053:	75 2c                	jne    804081 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804055:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80405c:	00 00 00 
  80405f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804062:	48 63 d0             	movslq %eax,%rdx
  804065:	48 89 d0             	mov    %rdx,%rax
  804068:	48 c1 e0 03          	shl    $0x3,%rax
  80406c:	48 01 d0             	add    %rdx,%rax
  80406f:	48 c1 e0 05          	shl    $0x5,%rax
  804073:	48 01 c8             	add    %rcx,%rax
  804076:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80407c:	8b 40 08             	mov    0x8(%rax),%eax
  80407f:	eb 12                	jmp    804093 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804081:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804085:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80408c:	7e 99                	jle    804027 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80408e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804093:	c9                   	leaveq 
  804094:	c3                   	retq   
  804095:	00 00                	add    %al,(%rax)
	...

0000000000804098 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804098:	55                   	push   %rbp
  804099:	48 89 e5             	mov    %rsp,%rbp
  80409c:	48 83 ec 18          	sub    $0x18,%rsp
  8040a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a8:	48 89 c2             	mov    %rax,%rdx
  8040ab:	48 c1 ea 15          	shr    $0x15,%rdx
  8040af:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040b6:	01 00 00 
  8040b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040bd:	83 e0 01             	and    $0x1,%eax
  8040c0:	48 85 c0             	test   %rax,%rax
  8040c3:	75 07                	jne    8040cc <pageref+0x34>
		return 0;
  8040c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ca:	eb 53                	jmp    80411f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d0:	48 89 c2             	mov    %rax,%rdx
  8040d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8040d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040de:	01 00 00 
  8040e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ed:	83 e0 01             	and    $0x1,%eax
  8040f0:	48 85 c0             	test   %rax,%rax
  8040f3:	75 07                	jne    8040fc <pageref+0x64>
		return 0;
  8040f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fa:	eb 23                	jmp    80411f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8040fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804100:	48 89 c2             	mov    %rax,%rdx
  804103:	48 c1 ea 0c          	shr    $0xc,%rdx
  804107:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80410e:	00 00 00 
  804111:	48 c1 e2 04          	shl    $0x4,%rdx
  804115:	48 01 d0             	add    %rdx,%rax
  804118:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80411c:	0f b7 c0             	movzwl %ax,%eax
}
  80411f:	c9                   	leaveq 
  804120:	c3                   	retq   
