
obj/user/testtime.debug:     file format elf64-x86-64


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
  80003c:	e8 6b 01 00 00       	callq  8001ac <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	unsigned now = sys_time_msec();
  80004f:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  800056:	00 00 00 
  800059:	ff d0                	callq  *%rax
  80005b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	unsigned end = now + sec * 1000;
  80005e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800061:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  800067:	03 45 fc             	add    -0x4(%rbp),%eax
  80006a:	89 45 f8             	mov    %eax,-0x8(%rbp)

	if ((int)now < 0 && (int)now > -MAXERROR)
  80006d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800070:	85 c0                	test   %eax,%eax
  800072:	79 38                	jns    8000ac <sleep+0x68>
  800074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800077:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80007a:	7c 30                	jl     8000ac <sleep+0x68>
		panic("sys_time_msec: %e", (int)now);
  80007c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007f:	89 c1                	mov    %eax,%ecx
  800081:	48 ba 20 3d 80 00 00 	movabs $0x803d20,%rdx
  800088:	00 00 00 
  80008b:	be 0b 00 00 00       	mov    $0xb,%esi
  800090:	48 bf 32 3d 80 00 00 	movabs $0x803d32,%rdi
  800097:	00 00 00 
  80009a:	b8 00 00 00 00       	mov    $0x0,%eax
  80009f:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8000a6:	00 00 00 
  8000a9:	41 ff d0             	callq  *%r8
	if (end < now)
  8000ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000af:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000b2:	73 38                	jae    8000ec <sleep+0xa8>
		panic("sleep: wrap");
  8000b4:	48 ba 42 3d 80 00 00 	movabs $0x803d42,%rdx
  8000bb:	00 00 00 
  8000be:	be 0d 00 00 00       	mov    $0xd,%esi
  8000c3:	48 bf 32 3d 80 00 00 	movabs $0x803d32,%rdi
  8000ca:	00 00 00 
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  8000d9:	00 00 00 
  8000dc:	ff d1                	callq  *%rcx

	while (sys_time_msec() < end)
		sys_yield();
  8000de:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	eb 01                	jmp    8000ed <sleep+0xa9>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000ec:	90                   	nop
  8000ed:	48 b8 11 1c 80 00 00 	movabs $0x801c11,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax
  8000f9:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8000fc:	72 e0                	jb     8000de <sleep+0x9a>
		sys_yield();
}
  8000fe:	c9                   	leaveq 
  8000ff:	c3                   	retq   

0000000000800100 <umain>:

void
umain(int argc, char **argv)
{
  800100:	55                   	push   %rbp
  800101:	48 89 e5             	mov    %rsp,%rbp
  800104:	48 83 ec 20          	sub    $0x20,%rsp
  800108:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80010b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  80010f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800116:	eb 10                	jmp    800128 <umain+0x28>
		sys_yield();
  800118:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  800124:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800128:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  80012c:	7e ea                	jle    800118 <umain+0x18>
		sys_yield();

	cprintf("starting count down: ");
  80012e:	48 bf 4e 3d 80 00 00 	movabs $0x803d4e,%rdi
  800135:	00 00 00 
  800138:	b8 00 00 00 00       	mov    $0x0,%eax
  80013d:	48 ba af 04 80 00 00 	movabs $0x8004af,%rdx
  800144:	00 00 00 
  800147:	ff d2                	callq  *%rdx
	for (i = 5; i >= 0; i--) {
  800149:	c7 45 fc 05 00 00 00 	movl   $0x5,-0x4(%rbp)
  800150:	eb 35                	jmp    800187 <umain+0x87>
		cprintf("%d ", i);
  800152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800155:	89 c6                	mov    %eax,%esi
  800157:	48 bf 64 3d 80 00 00 	movabs $0x803d64,%rdi
  80015e:	00 00 00 
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
  800166:	48 ba af 04 80 00 00 	movabs $0x8004af,%rdx
  80016d:	00 00 00 
  800170:	ff d2                	callq  *%rdx
		sleep(1);
  800172:	bf 01 00 00 00       	mov    $0x1,%edi
  800177:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  800183:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  800187:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80018b:	79 c5                	jns    800152 <umain+0x52>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  80018d:	48 bf 68 3d 80 00 00 	movabs $0x803d68,%rdi
  800194:	00 00 00 
  800197:	b8 00 00 00 00       	mov    $0x0,%eax
  80019c:	48 ba af 04 80 00 00 	movabs $0x8004af,%rdx
  8001a3:	00 00 00 
  8001a6:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001a8:	cc                   	int3   
	breakpoint();
}
  8001a9:	c9                   	leaveq 
  8001aa:	c3                   	retq   
	...

00000000008001ac <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
  8001b0:	48 83 ec 10          	sub    $0x10,%rsp
  8001b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001bb:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8001c2:	00 00 00 
  8001c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8001cc:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax
  8001d8:	48 98                	cltq   
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001e3:	48 89 d0             	mov    %rdx,%rax
  8001e6:	48 c1 e0 03          	shl    $0x3,%rax
  8001ea:	48 01 d0             	add    %rdx,%rax
  8001ed:	48 c1 e0 05          	shl    $0x5,%rax
  8001f1:	48 89 c2             	mov    %rax,%rdx
  8001f4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001fb:	00 00 00 
  8001fe:	48 01 c2             	add    %rax,%rdx
  800201:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  800208:	00 00 00 
  80020b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800212:	7e 14                	jle    800228 <libmain+0x7c>
		binaryname = argv[0];
  800214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800218:	48 8b 10             	mov    (%rax),%rdx
  80021b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800222:	00 00 00 
  800225:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800228:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022f:	48 89 d6             	mov    %rdx,%rsi
  800232:	89 c7                	mov    %eax,%edi
  800234:	48 b8 00 01 80 00 00 	movabs $0x800100,%rax
  80023b:	00 00 00 
  80023e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800240:	48 b8 50 02 80 00 00 	movabs $0x800250,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax
}
  80024c:	c9                   	leaveq 
  80024d:	c3                   	retq   
	...

0000000000800250 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800254:	48 b8 25 20 80 00 00 	movabs $0x802025,%rax
  80025b:	00 00 00 
  80025e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800260:	bf 00 00 00 00       	mov    $0x0,%edi
  800265:	48 b8 e4 18 80 00 00 	movabs $0x8018e4,%rax
  80026c:	00 00 00 
  80026f:	ff d0                	callq  *%rax
}
  800271:	5d                   	pop    %rbp
  800272:	c3                   	retq   
	...

0000000000800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	53                   	push   %rbx
  800279:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800280:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800287:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80028d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800294:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80029b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002a2:	84 c0                	test   %al,%al
  8002a4:	74 23                	je     8002c9 <_panic+0x55>
  8002a6:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002ad:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002b1:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002b5:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002b9:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002bd:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002c1:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002c5:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002c9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002d0:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ef:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002f6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002fd:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800304:	00 00 00 
  800307:	48 8b 18             	mov    (%rax),%rbx
  80030a:	48 b8 28 19 80 00 00 	movabs $0x801928,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
  800316:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80031c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800323:	41 89 c8             	mov    %ecx,%r8d
  800326:	48 89 d1             	mov    %rdx,%rcx
  800329:	48 89 da             	mov    %rbx,%rdx
  80032c:	89 c6                	mov    %eax,%esi
  80032e:	48 bf 78 3d 80 00 00 	movabs $0x803d78,%rdi
  800335:	00 00 00 
  800338:	b8 00 00 00 00       	mov    $0x0,%eax
  80033d:	49 b9 af 04 80 00 00 	movabs $0x8004af,%r9
  800344:	00 00 00 
  800347:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80034a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800351:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800358:	48 89 d6             	mov    %rdx,%rsi
  80035b:	48 89 c7             	mov    %rax,%rdi
  80035e:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  800365:	00 00 00 
  800368:	ff d0                	callq  *%rax
	cprintf("\n");
  80036a:	48 bf 9b 3d 80 00 00 	movabs $0x803d9b,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba af 04 80 00 00 	movabs $0x8004af,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x111>

0000000000800388 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800388:	55                   	push   %rbp
  800389:	48 89 e5             	mov    %rsp,%rbp
  80038c:	48 83 ec 10          	sub    $0x10,%rsp
  800390:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800393:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80039b:	8b 00                	mov    (%rax),%eax
  80039d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003a0:	89 d6                	mov    %edx,%esi
  8003a2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003a6:	48 63 d0             	movslq %eax,%rdx
  8003a9:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8003ae:	8d 50 01             	lea    0x1(%rax),%edx
  8003b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b5:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	8b 00                	mov    (%rax),%eax
  8003bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003c2:	75 2c                	jne    8003f0 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8003c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c8:	8b 00                	mov    (%rax),%eax
  8003ca:	48 98                	cltq   
  8003cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d0:	48 83 c2 08          	add    $0x8,%rdx
  8003d4:	48 89 c6             	mov    %rax,%rsi
  8003d7:	48 89 d7             	mov    %rdx,%rdi
  8003da:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8003e1:	00 00 00 
  8003e4:	ff d0                	callq  *%rax
		b->idx = 0;
  8003e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f4:	8b 40 04             	mov    0x4(%rax),%eax
  8003f7:	8d 50 01             	lea    0x1(%rax),%edx
  8003fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fe:	89 50 04             	mov    %edx,0x4(%rax)
}
  800401:	c9                   	leaveq 
  800402:	c3                   	retq   

0000000000800403 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800403:	55                   	push   %rbp
  800404:	48 89 e5             	mov    %rsp,%rbp
  800407:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80040e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800415:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80041c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800423:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80042a:	48 8b 0a             	mov    (%rdx),%rcx
  80042d:	48 89 08             	mov    %rcx,(%rax)
  800430:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800434:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800438:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80043c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800440:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800447:	00 00 00 
	b.cnt = 0;
  80044a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800451:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800454:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80045b:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800462:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800469:	48 89 c6             	mov    %rax,%rsi
  80046c:	48 bf 88 03 80 00 00 	movabs $0x800388,%rdi
  800473:	00 00 00 
  800476:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  80047d:	00 00 00 
  800480:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800482:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800488:	48 98                	cltq   
  80048a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800491:	48 83 c2 08          	add    $0x8,%rdx
  800495:	48 89 c6             	mov    %rax,%rsi
  800498:	48 89 d7             	mov    %rdx,%rdi
  80049b:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8004a2:	00 00 00 
  8004a5:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004ad:	c9                   	leaveq 
  8004ae:	c3                   	retq   

00000000008004af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004af:	55                   	push   %rbp
  8004b0:	48 89 e5             	mov    %rsp,%rbp
  8004b3:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ba:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004c1:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004c8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004cf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004d6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004dd:	84 c0                	test   %al,%al
  8004df:	74 20                	je     800501 <cprintf+0x52>
  8004e1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004e5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004e9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004ed:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004f1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004f5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004f9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004fd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800501:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800508:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80050f:	00 00 00 
  800512:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800519:	00 00 00 
  80051c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800520:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800527:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80052e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800535:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80053c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800543:	48 8b 0a             	mov    (%rdx),%rcx
  800546:	48 89 08             	mov    %rcx,(%rax)
  800549:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80054d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800551:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800555:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800559:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800560:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800567:	48 89 d6             	mov    %rdx,%rsi
  80056a:	48 89 c7             	mov    %rax,%rdi
  80056d:	48 b8 03 04 80 00 00 	movabs $0x800403,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax
  800579:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80057f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800585:	c9                   	leaveq 
  800586:	c3                   	retq   
	...

0000000000800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp
  80058c:	48 83 ec 30          	sub    $0x30,%rsp
  800590:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800594:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800598:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80059c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80059f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005a3:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005aa:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005ae:	77 52                	ja     800602 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005b3:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005b7:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005ba:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005cb:	48 89 c2             	mov    %rax,%rdx
  8005ce:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005d1:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005d4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005dc:	41 89 f9             	mov    %edi,%r9d
  8005df:	48 89 c7             	mov    %rax,%rdi
  8005e2:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8005e9:	00 00 00 
  8005ec:	ff d0                	callq  *%rax
  8005ee:	eb 1c                	jmp    80060c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005f7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005fb:	48 89 d6             	mov    %rdx,%rsi
  8005fe:	89 c7                	mov    %eax,%edi
  800600:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800602:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800606:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80060a:	7f e4                	jg     8005f0 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	48 f7 f1             	div    %rcx
  80061b:	48 89 d0             	mov    %rdx,%rax
  80061e:	48 ba 68 3f 80 00 00 	movabs $0x803f68,%rdx
  800625:	00 00 00 
  800628:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80062c:	0f be c0             	movsbl %al,%eax
  80062f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800633:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800637:	48 89 d6             	mov    %rdx,%rsi
  80063a:	89 c7                	mov    %eax,%edi
  80063c:	ff d1                	callq  *%rcx
}
  80063e:	c9                   	leaveq 
  80063f:	c3                   	retq   

0000000000800640 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800640:	55                   	push   %rbp
  800641:	48 89 e5             	mov    %rsp,%rbp
  800644:	48 83 ec 20          	sub    $0x20,%rsp
  800648:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80064c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80064f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800653:	7e 52                	jle    8006a7 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	83 f8 30             	cmp    $0x30,%eax
  80065e:	73 24                	jae    800684 <getuint+0x44>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 01 d0             	add    %rdx,%rax
  800673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800677:	8b 12                	mov    (%rdx),%edx
  800679:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	89 0a                	mov    %ecx,(%rdx)
  800682:	eb 17                	jmp    80069b <getuint+0x5b>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068c:	48 89 d0             	mov    %rdx,%rax
  80068f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069b:	48 8b 00             	mov    (%rax),%rax
  80069e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a2:	e9 a3 00 00 00       	jmpq   80074a <getuint+0x10a>
	else if (lflag)
  8006a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006ab:	74 4f                	je     8006fc <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	8b 00                	mov    (%rax),%eax
  8006b3:	83 f8 30             	cmp    $0x30,%eax
  8006b6:	73 24                	jae    8006dc <getuint+0x9c>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	8b 00                	mov    (%rax),%eax
  8006c6:	89 c0                	mov    %eax,%eax
  8006c8:	48 01 d0             	add    %rdx,%rax
  8006cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cf:	8b 12                	mov    (%rdx),%edx
  8006d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d8:	89 0a                	mov    %ecx,(%rdx)
  8006da:	eb 17                	jmp    8006f3 <getuint+0xb3>
  8006dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006e4:	48 89 d0             	mov    %rdx,%rax
  8006e7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ef:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006f3:	48 8b 00             	mov    (%rax),%rax
  8006f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006fa:	eb 4e                	jmp    80074a <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	83 f8 30             	cmp    $0x30,%eax
  800705:	73 24                	jae    80072b <getuint+0xeb>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800713:	8b 00                	mov    (%rax),%eax
  800715:	89 c0                	mov    %eax,%eax
  800717:	48 01 d0             	add    %rdx,%rax
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	8b 12                	mov    (%rdx),%edx
  800720:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800723:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800727:	89 0a                	mov    %ecx,(%rdx)
  800729:	eb 17                	jmp    800742 <getuint+0x102>
  80072b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800733:	48 89 d0             	mov    %rdx,%rax
  800736:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80073a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800742:	8b 00                	mov    (%rax),%eax
  800744:	89 c0                	mov    %eax,%eax
  800746:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80074a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80074e:	c9                   	leaveq 
  80074f:	c3                   	retq   

0000000000800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %rbp
  800751:	48 89 e5             	mov    %rsp,%rbp
  800754:	48 83 ec 20          	sub    $0x20,%rsp
  800758:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80075c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80075f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800763:	7e 52                	jle    8007b7 <getint+0x67>
		x=va_arg(*ap, long long);
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	83 f8 30             	cmp    $0x30,%eax
  80076e:	73 24                	jae    800794 <getint+0x44>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 01 d0             	add    %rdx,%rax
  800783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800787:	8b 12                	mov    (%rdx),%edx
  800789:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80078c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800790:	89 0a                	mov    %ecx,(%rdx)
  800792:	eb 17                	jmp    8007ab <getint+0x5b>
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80079c:	48 89 d0             	mov    %rdx,%rax
  80079f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ab:	48 8b 00             	mov    (%rax),%rax
  8007ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b2:	e9 a3 00 00 00       	jmpq   80085a <getint+0x10a>
	else if (lflag)
  8007b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007bb:	74 4f                	je     80080c <getint+0xbc>
		x=va_arg(*ap, long);
  8007bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c1:	8b 00                	mov    (%rax),%eax
  8007c3:	83 f8 30             	cmp    $0x30,%eax
  8007c6:	73 24                	jae    8007ec <getint+0x9c>
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	8b 00                	mov    (%rax),%eax
  8007d6:	89 c0                	mov    %eax,%eax
  8007d8:	48 01 d0             	add    %rdx,%rax
  8007db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007df:	8b 12                	mov    (%rdx),%edx
  8007e1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e8:	89 0a                	mov    %ecx,(%rdx)
  8007ea:	eb 17                	jmp    800803 <getint+0xb3>
  8007ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f4:	48 89 d0             	mov    %rdx,%rax
  8007f7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ff:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800803:	48 8b 00             	mov    (%rax),%rax
  800806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080a:	eb 4e                	jmp    80085a <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	83 f8 30             	cmp    $0x30,%eax
  800815:	73 24                	jae    80083b <getint+0xeb>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80081f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800823:	8b 00                	mov    (%rax),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082e:	8b 12                	mov    (%rdx),%edx
  800830:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800833:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800837:	89 0a                	mov    %ecx,(%rdx)
  800839:	eb 17                	jmp    800852 <getint+0x102>
  80083b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800843:	48 89 d0             	mov    %rdx,%rax
  800846:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80084a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80084e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800852:	8b 00                	mov    (%rax),%eax
  800854:	48 98                	cltq   
  800856:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80085a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80085e:	c9                   	leaveq 
  80085f:	c3                   	retq   

0000000000800860 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800860:	55                   	push   %rbp
  800861:	48 89 e5             	mov    %rsp,%rbp
  800864:	41 54                	push   %r12
  800866:	53                   	push   %rbx
  800867:	48 83 ec 60          	sub    $0x60,%rsp
  80086b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80086f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800873:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800877:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80087b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80087f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800883:	48 8b 0a             	mov    (%rdx),%rcx
  800886:	48 89 08             	mov    %rcx,(%rax)
  800889:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800891:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800895:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800899:	eb 17                	jmp    8008b2 <vprintfmt+0x52>
			if (ch == '\0')
  80089b:	85 db                	test   %ebx,%ebx
  80089d:	0f 84 d7 04 00 00    	je     800d7a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8008a3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008a7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8008ab:	48 89 c6             	mov    %rax,%rsi
  8008ae:	89 df                	mov    %ebx,%edi
  8008b0:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008b6:	0f b6 00             	movzbl (%rax),%eax
  8008b9:	0f b6 d8             	movzbl %al,%ebx
  8008bc:	83 fb 25             	cmp    $0x25,%ebx
  8008bf:	0f 95 c0             	setne  %al
  8008c2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008c7:	84 c0                	test   %al,%al
  8008c9:	75 d0                	jne    80089b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008cf:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8008eb:	eb 04                	jmp    8008f1 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8008ed:	90                   	nop
  8008ee:	eb 01                	jmp    8008f1 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8008f0:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f5:	0f b6 00             	movzbl (%rax),%eax
  8008f8:	0f b6 d8             	movzbl %al,%ebx
  8008fb:	89 d8                	mov    %ebx,%eax
  8008fd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800902:	83 e8 23             	sub    $0x23,%eax
  800905:	83 f8 55             	cmp    $0x55,%eax
  800908:	0f 87 38 04 00 00    	ja     800d46 <vprintfmt+0x4e6>
  80090e:	89 c0                	mov    %eax,%eax
  800910:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800917:	00 
  800918:	48 b8 90 3f 80 00 00 	movabs $0x803f90,%rax
  80091f:	00 00 00 
  800922:	48 01 d0             	add    %rdx,%rax
  800925:	48 8b 00             	mov    (%rax),%rax
  800928:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80092a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80092e:	eb c1                	jmp    8008f1 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800930:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800934:	eb bb                	jmp    8008f1 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800936:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80093d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800940:	89 d0                	mov    %edx,%eax
  800942:	c1 e0 02             	shl    $0x2,%eax
  800945:	01 d0                	add    %edx,%eax
  800947:	01 c0                	add    %eax,%eax
  800949:	01 d8                	add    %ebx,%eax
  80094b:	83 e8 30             	sub    $0x30,%eax
  80094e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800951:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800955:	0f b6 00             	movzbl (%rax),%eax
  800958:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80095b:	83 fb 2f             	cmp    $0x2f,%ebx
  80095e:	7e 63                	jle    8009c3 <vprintfmt+0x163>
  800960:	83 fb 39             	cmp    $0x39,%ebx
  800963:	7f 5e                	jg     8009c3 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800965:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80096a:	eb d1                	jmp    80093d <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80096c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096f:	83 f8 30             	cmp    $0x30,%eax
  800972:	73 17                	jae    80098b <vprintfmt+0x12b>
  800974:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800978:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097b:	89 c0                	mov    %eax,%eax
  80097d:	48 01 d0             	add    %rdx,%rax
  800980:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800983:	83 c2 08             	add    $0x8,%edx
  800986:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800989:	eb 0f                	jmp    80099a <vprintfmt+0x13a>
  80098b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098f:	48 89 d0             	mov    %rdx,%rax
  800992:	48 83 c2 08          	add    $0x8,%rdx
  800996:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80099a:	8b 00                	mov    (%rax),%eax
  80099c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80099f:	eb 23                	jmp    8009c4 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a5:	0f 89 42 ff ff ff    	jns    8008ed <vprintfmt+0x8d>
				width = 0;
  8009ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009b2:	e9 36 ff ff ff       	jmpq   8008ed <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8009b7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009be:	e9 2e ff ff ff       	jmpq   8008f1 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009c3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009c8:	0f 89 22 ff ff ff    	jns    8008f0 <vprintfmt+0x90>
				width = precision, precision = -1;
  8009ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009d1:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009db:	e9 10 ff ff ff       	jmpq   8008f0 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009e4:	e9 08 ff ff ff       	jmpq   8008f1 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009e9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009ec:	83 f8 30             	cmp    $0x30,%eax
  8009ef:	73 17                	jae    800a08 <vprintfmt+0x1a8>
  8009f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	89 c0                	mov    %eax,%eax
  8009fa:	48 01 d0             	add    %rdx,%rax
  8009fd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a00:	83 c2 08             	add    $0x8,%edx
  800a03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a06:	eb 0f                	jmp    800a17 <vprintfmt+0x1b7>
  800a08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0c:	48 89 d0             	mov    %rdx,%rax
  800a0f:	48 83 c2 08          	add    $0x8,%rdx
  800a13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a17:	8b 00                	mov    (%rax),%eax
  800a19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1d:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a21:	48 89 d6             	mov    %rdx,%rsi
  800a24:	89 c7                	mov    %eax,%edi
  800a26:	ff d1                	callq  *%rcx
			break;
  800a28:	e9 47 03 00 00       	jmpq   800d74 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a2d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a30:	83 f8 30             	cmp    $0x30,%eax
  800a33:	73 17                	jae    800a4c <vprintfmt+0x1ec>
  800a35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3c:	89 c0                	mov    %eax,%eax
  800a3e:	48 01 d0             	add    %rdx,%rax
  800a41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a44:	83 c2 08             	add    $0x8,%edx
  800a47:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a4a:	eb 0f                	jmp    800a5b <vprintfmt+0x1fb>
  800a4c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a50:	48 89 d0             	mov    %rdx,%rax
  800a53:	48 83 c2 08          	add    $0x8,%rdx
  800a57:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a5b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	79 02                	jns    800a63 <vprintfmt+0x203>
				err = -err;
  800a61:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a63:	83 fb 10             	cmp    $0x10,%ebx
  800a66:	7f 16                	jg     800a7e <vprintfmt+0x21e>
  800a68:	48 b8 e0 3e 80 00 00 	movabs $0x803ee0,%rax
  800a6f:	00 00 00 
  800a72:	48 63 d3             	movslq %ebx,%rdx
  800a75:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a79:	4d 85 e4             	test   %r12,%r12
  800a7c:	75 2e                	jne    800aac <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a7e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a86:	89 d9                	mov    %ebx,%ecx
  800a88:	48 ba 79 3f 80 00 00 	movabs $0x803f79,%rdx
  800a8f:	00 00 00 
  800a92:	48 89 c7             	mov    %rax,%rdi
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9a:	49 b8 84 0d 80 00 00 	movabs $0x800d84,%r8
  800aa1:	00 00 00 
  800aa4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa7:	e9 c8 02 00 00       	jmpq   800d74 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aac:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab4:	4c 89 e1             	mov    %r12,%rcx
  800ab7:	48 ba 82 3f 80 00 00 	movabs $0x803f82,%rdx
  800abe:	00 00 00 
  800ac1:	48 89 c7             	mov    %rax,%rdi
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac9:	49 b8 84 0d 80 00 00 	movabs $0x800d84,%r8
  800ad0:	00 00 00 
  800ad3:	41 ff d0             	callq  *%r8
			break;
  800ad6:	e9 99 02 00 00       	jmpq   800d74 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800adb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ade:	83 f8 30             	cmp    $0x30,%eax
  800ae1:	73 17                	jae    800afa <vprintfmt+0x29a>
  800ae3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aea:	89 c0                	mov    %eax,%eax
  800aec:	48 01 d0             	add    %rdx,%rax
  800aef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800af2:	83 c2 08             	add    $0x8,%edx
  800af5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800af8:	eb 0f                	jmp    800b09 <vprintfmt+0x2a9>
  800afa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800afe:	48 89 d0             	mov    %rdx,%rax
  800b01:	48 83 c2 08          	add    $0x8,%rdx
  800b05:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b09:	4c 8b 20             	mov    (%rax),%r12
  800b0c:	4d 85 e4             	test   %r12,%r12
  800b0f:	75 0a                	jne    800b1b <vprintfmt+0x2bb>
				p = "(null)";
  800b11:	49 bc 85 3f 80 00 00 	movabs $0x803f85,%r12
  800b18:	00 00 00 
			if (width > 0 && padc != '-')
  800b1b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1f:	7e 7a                	jle    800b9b <vprintfmt+0x33b>
  800b21:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b25:	74 74                	je     800b9b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b27:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b2a:	48 98                	cltq   
  800b2c:	48 89 c6             	mov    %rax,%rsi
  800b2f:	4c 89 e7             	mov    %r12,%rdi
  800b32:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  800b39:	00 00 00 
  800b3c:	ff d0                	callq  *%rax
  800b3e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b41:	eb 17                	jmp    800b5a <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b43:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4b:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b4f:	48 89 d6             	mov    %rdx,%rsi
  800b52:	89 c7                	mov    %eax,%edi
  800b54:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b56:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b5e:	7f e3                	jg     800b43 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b60:	eb 39                	jmp    800b9b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b62:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b66:	74 1e                	je     800b86 <vprintfmt+0x326>
  800b68:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6b:	7e 05                	jle    800b72 <vprintfmt+0x312>
  800b6d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b70:	7e 14                	jle    800b86 <vprintfmt+0x326>
					putch('?', putdat);
  800b72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b7a:	48 89 c6             	mov    %rax,%rsi
  800b7d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b82:	ff d2                	callq  *%rdx
  800b84:	eb 0f                	jmp    800b95 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b86:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b8a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b8e:	48 89 c6             	mov    %rax,%rsi
  800b91:	89 df                	mov    %ebx,%edi
  800b93:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b95:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b99:	eb 01                	jmp    800b9c <vprintfmt+0x33c>
  800b9b:	90                   	nop
  800b9c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800ba1:	0f be d8             	movsbl %al,%ebx
  800ba4:	85 db                	test   %ebx,%ebx
  800ba6:	0f 95 c0             	setne  %al
  800ba9:	49 83 c4 01          	add    $0x1,%r12
  800bad:	84 c0                	test   %al,%al
  800baf:	74 28                	je     800bd9 <vprintfmt+0x379>
  800bb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bb5:	78 ab                	js     800b62 <vprintfmt+0x302>
  800bb7:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bbb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bbf:	79 a1                	jns    800b62 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc1:	eb 16                	jmp    800bd9 <vprintfmt+0x379>
				putch(' ', putdat);
  800bc3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bc7:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bcb:	48 89 c6             	mov    %rax,%rsi
  800bce:	bf 20 00 00 00       	mov    $0x20,%edi
  800bd3:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bdd:	7f e4                	jg     800bc3 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800bdf:	e9 90 01 00 00       	jmpq   800d74 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800be4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be8:	be 03 00 00 00       	mov    $0x3,%esi
  800bed:	48 89 c7             	mov    %rax,%rdi
  800bf0:	48 b8 50 07 80 00 00 	movabs $0x800750,%rax
  800bf7:	00 00 00 
  800bfa:	ff d0                	callq  *%rax
  800bfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c04:	48 85 c0             	test   %rax,%rax
  800c07:	79 1d                	jns    800c26 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c09:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c0d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c11:	48 89 c6             	mov    %rax,%rsi
  800c14:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c19:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c1f:	48 f7 d8             	neg    %rax
  800c22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2d:	e9 d5 00 00 00       	jmpq   800d07 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c36:	be 03 00 00 00       	mov    $0x3,%esi
  800c3b:	48 89 c7             	mov    %rax,%rdi
  800c3e:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
  800c4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c4e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c55:	e9 ad 00 00 00       	jmpq   800d07 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c5e:	be 03 00 00 00       	mov    $0x3,%esi
  800c63:	48 89 c7             	mov    %rax,%rdi
  800c66:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800c6d:	00 00 00 
  800c70:	ff d0                	callq  *%rax
  800c72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800c76:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c7d:	e9 85 00 00 00       	jmpq   800d07 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8a:	48 89 c6             	mov    %rax,%rsi
  800c8d:	bf 30 00 00 00       	mov    $0x30,%edi
  800c92:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800c94:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c98:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c9c:	48 89 c6             	mov    %rax,%rsi
  800c9f:	bf 78 00 00 00       	mov    $0x78,%edi
  800ca4:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ca6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca9:	83 f8 30             	cmp    $0x30,%eax
  800cac:	73 17                	jae    800cc5 <vprintfmt+0x465>
  800cae:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb5:	89 c0                	mov    %eax,%eax
  800cb7:	48 01 d0             	add    %rdx,%rax
  800cba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cbd:	83 c2 08             	add    $0x8,%edx
  800cc0:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc3:	eb 0f                	jmp    800cd4 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800cc5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cc9:	48 89 d0             	mov    %rdx,%rax
  800ccc:	48 83 c2 08          	add    $0x8,%rdx
  800cd0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd4:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cd7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cdb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ce2:	eb 23                	jmp    800d07 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ce4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ce8:	be 03 00 00 00       	mov    $0x3,%esi
  800ced:	48 89 c7             	mov    %rax,%rdi
  800cf0:	48 b8 40 06 80 00 00 	movabs $0x800640,%rax
  800cf7:	00 00 00 
  800cfa:	ff d0                	callq  *%rax
  800cfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d00:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d07:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d0c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d0f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d16:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d1e:	45 89 c1             	mov    %r8d,%r9d
  800d21:	41 89 f8             	mov    %edi,%r8d
  800d24:	48 89 c7             	mov    %rax,%rdi
  800d27:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
			break;
  800d33:	eb 3f                	jmp    800d74 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d35:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d39:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d3d:	48 89 c6             	mov    %rax,%rsi
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	ff d2                	callq  *%rdx
			break;
  800d44:	eb 2e                	jmp    800d74 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d46:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d4a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d4e:	48 89 c6             	mov    %rax,%rsi
  800d51:	bf 25 00 00 00       	mov    $0x25,%edi
  800d56:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d58:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d5d:	eb 05                	jmp    800d64 <vprintfmt+0x504>
  800d5f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d64:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d68:	48 83 e8 01          	sub    $0x1,%rax
  800d6c:	0f b6 00             	movzbl (%rax),%eax
  800d6f:	3c 25                	cmp    $0x25,%al
  800d71:	75 ec                	jne    800d5f <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d73:	90                   	nop
		}
	}
  800d74:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d75:	e9 38 fb ff ff       	jmpq   8008b2 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d7a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d7b:	48 83 c4 60          	add    $0x60,%rsp
  800d7f:	5b                   	pop    %rbx
  800d80:	41 5c                	pop    %r12
  800d82:	5d                   	pop    %rbp
  800d83:	c3                   	retq   

0000000000800d84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d84:	55                   	push   %rbp
  800d85:	48 89 e5             	mov    %rsp,%rbp
  800d88:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d8f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d96:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d9d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db2:	84 c0                	test   %al,%al
  800db4:	74 20                	je     800dd6 <printfmt+0x52>
  800db6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dbe:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ddd:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800de4:	00 00 00 
  800de7:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dee:	00 00 00 
  800df1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df5:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dfc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e03:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e0a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e11:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e18:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e1f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e26:	48 89 c7             	mov    %rax,%rdi
  800e29:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800e30:	00 00 00 
  800e33:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 83 ec 10          	sub    $0x10,%rsp
  800e3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e42:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	8b 40 10             	mov    0x10(%rax),%eax
  800e4d:	8d 50 01             	lea    0x1(%rax),%edx
  800e50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e54:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e5b:	48 8b 10             	mov    (%rax),%rdx
  800e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e62:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e66:	48 39 c2             	cmp    %rax,%rdx
  800e69:	73 17                	jae    800e82 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6f:	48 8b 00             	mov    (%rax),%rax
  800e72:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e75:	88 10                	mov    %dl,(%rax)
  800e77:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7f:	48 89 10             	mov    %rdx,(%rax)
}
  800e82:	c9                   	leaveq 
  800e83:	c3                   	retq   

0000000000800e84 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e84:	55                   	push   %rbp
  800e85:	48 89 e5             	mov    %rsp,%rbp
  800e88:	48 83 ec 50          	sub    $0x50,%rsp
  800e8c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e90:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e93:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e97:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e9b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e9f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ea3:	48 8b 0a             	mov    (%rdx),%rcx
  800ea6:	48 89 08             	mov    %rcx,(%rax)
  800ea9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ead:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800eb1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eb5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ebd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ec1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ec4:	48 98                	cltq   
  800ec6:	48 83 e8 01          	sub    $0x1,%rax
  800eca:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800ece:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ed2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ed9:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ede:	74 06                	je     800ee6 <vsnprintf+0x62>
  800ee0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ee4:	7f 07                	jg     800eed <vsnprintf+0x69>
		return -E_INVAL;
  800ee6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eeb:	eb 2f                	jmp    800f1c <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800eed:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ef1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ef5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ef9:	48 89 c6             	mov    %rax,%rsi
  800efc:	48 bf 37 0e 80 00 00 	movabs $0x800e37,%rdi
  800f03:	00 00 00 
  800f06:	48 b8 60 08 80 00 00 	movabs $0x800860,%rax
  800f0d:	00 00 00 
  800f10:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f16:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f19:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f1c:	c9                   	leaveq 
  800f1d:	c3                   	retq   

0000000000800f1e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f1e:	55                   	push   %rbp
  800f1f:	48 89 e5             	mov    %rsp,%rbp
  800f22:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f29:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f30:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f36:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f3d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f44:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f4b:	84 c0                	test   %al,%al
  800f4d:	74 20                	je     800f6f <snprintf+0x51>
  800f4f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f53:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f57:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f5b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f5f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f63:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f67:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f6b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f6f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f76:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f7d:	00 00 00 
  800f80:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f87:	00 00 00 
  800f8a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f8e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f95:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f9c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fa3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800faa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fb1:	48 8b 0a             	mov    (%rdx),%rcx
  800fb4:	48 89 08             	mov    %rcx,(%rax)
  800fb7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fbb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fbf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fc3:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fc7:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fce:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fd5:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fdb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fe2:	48 89 c7             	mov    %rax,%rdi
  800fe5:	48 b8 84 0e 80 00 00 	movabs $0x800e84,%rax
  800fec:	00 00 00 
  800fef:	ff d0                	callq  *%rax
  800ff1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800ff7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800ffd:	c9                   	leaveq 
  800ffe:	c3                   	retq   
	...

0000000000801000 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801000:	55                   	push   %rbp
  801001:	48 89 e5             	mov    %rsp,%rbp
  801004:	48 83 ec 18          	sub    $0x18,%rsp
  801008:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80100c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801013:	eb 09                	jmp    80101e <strlen+0x1e>
		n++;
  801015:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801019:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80101e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801022:	0f b6 00             	movzbl (%rax),%eax
  801025:	84 c0                	test   %al,%al
  801027:	75 ec                	jne    801015 <strlen+0x15>
		n++;
	return n;
  801029:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80102c:	c9                   	leaveq 
  80102d:	c3                   	retq   

000000000080102e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80102e:	55                   	push   %rbp
  80102f:	48 89 e5             	mov    %rsp,%rbp
  801032:	48 83 ec 20          	sub    $0x20,%rsp
  801036:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801045:	eb 0e                	jmp    801055 <strnlen+0x27>
		n++;
  801047:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801050:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801055:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80105a:	74 0b                	je     801067 <strnlen+0x39>
  80105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801060:	0f b6 00             	movzbl (%rax),%eax
  801063:	84 c0                	test   %al,%al
  801065:	75 e0                	jne    801047 <strnlen+0x19>
		n++;
	return n;
  801067:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80106a:	c9                   	leaveq 
  80106b:	c3                   	retq   

000000000080106c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80106c:	55                   	push   %rbp
  80106d:	48 89 e5             	mov    %rsp,%rbp
  801070:	48 83 ec 20          	sub    $0x20,%rsp
  801074:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801078:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80107c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801080:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801084:	90                   	nop
  801085:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801089:	0f b6 10             	movzbl (%rax),%edx
  80108c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801090:	88 10                	mov    %dl,(%rax)
  801092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801096:	0f b6 00             	movzbl (%rax),%eax
  801099:	84 c0                	test   %al,%al
  80109b:	0f 95 c0             	setne  %al
  80109e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010a3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8010a8:	84 c0                	test   %al,%al
  8010aa:	75 d9                	jne    801085 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010b0:	c9                   	leaveq 
  8010b1:	c3                   	retq   

00000000008010b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010b2:	55                   	push   %rbp
  8010b3:	48 89 e5             	mov    %rsp,%rbp
  8010b6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	48 89 c7             	mov    %rax,%rdi
  8010c9:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
  8010d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010db:	48 98                	cltq   
  8010dd:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010e1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e5:	48 89 d6             	mov    %rdx,%rsi
  8010e8:	48 89 c7             	mov    %rax,%rdi
  8010eb:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  8010f2:	00 00 00 
  8010f5:	ff d0                	callq  *%rax
	return dst;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010fb:	c9                   	leaveq 
  8010fc:	c3                   	retq   

00000000008010fd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010fd:	55                   	push   %rbp
  8010fe:	48 89 e5             	mov    %rsp,%rbp
  801101:	48 83 ec 28          	sub    $0x28,%rsp
  801105:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801109:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80110d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801115:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801119:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801120:	00 
  801121:	eb 27                	jmp    80114a <strncpy+0x4d>
		*dst++ = *src;
  801123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801127:	0f b6 10             	movzbl (%rax),%edx
  80112a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112e:	88 10                	mov    %dl,(%rax)
  801130:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801135:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801139:	0f b6 00             	movzbl (%rax),%eax
  80113c:	84 c0                	test   %al,%al
  80113e:	74 05                	je     801145 <strncpy+0x48>
			src++;
  801140:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801145:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801152:	72 cf                	jb     801123 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801158:	c9                   	leaveq 
  801159:	c3                   	retq   

000000000080115a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80115a:	55                   	push   %rbp
  80115b:	48 89 e5             	mov    %rsp,%rbp
  80115e:	48 83 ec 28          	sub    $0x28,%rsp
  801162:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801166:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80116a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80116e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801172:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801176:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80117b:	74 37                	je     8011b4 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80117d:	eb 17                	jmp    801196 <strlcpy+0x3c>
			*dst++ = *src++;
  80117f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801183:	0f b6 10             	movzbl (%rax),%edx
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	88 10                	mov    %dl,(%rax)
  80118c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801191:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801196:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80119b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a0:	74 0b                	je     8011ad <strlcpy+0x53>
  8011a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a6:	0f b6 00             	movzbl (%rax),%eax
  8011a9:	84 c0                	test   %al,%al
  8011ab:	75 d2                	jne    80117f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b1:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bc:	48 89 d1             	mov    %rdx,%rcx
  8011bf:	48 29 c1             	sub    %rax,%rcx
  8011c2:	48 89 c8             	mov    %rcx,%rax
}
  8011c5:	c9                   	leaveq 
  8011c6:	c3                   	retq   

00000000008011c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011c7:	55                   	push   %rbp
  8011c8:	48 89 e5             	mov    %rsp,%rbp
  8011cb:	48 83 ec 10          	sub    $0x10,%rsp
  8011cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011d7:	eb 0a                	jmp    8011e3 <strcmp+0x1c>
		p++, q++;
  8011d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	0f b6 00             	movzbl (%rax),%eax
  8011ea:	84 c0                	test   %al,%al
  8011ec:	74 12                	je     801200 <strcmp+0x39>
  8011ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f2:	0f b6 10             	movzbl (%rax),%edx
  8011f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	38 c2                	cmp    %al,%dl
  8011fe:	74 d9                	je     8011d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801200:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	0f b6 d0             	movzbl %al,%edx
  80120a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	0f b6 c0             	movzbl %al,%eax
  801214:	89 d1                	mov    %edx,%ecx
  801216:	29 c1                	sub    %eax,%ecx
  801218:	89 c8                	mov    %ecx,%eax
}
  80121a:	c9                   	leaveq 
  80121b:	c3                   	retq   

000000000080121c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80121c:	55                   	push   %rbp
  80121d:	48 89 e5             	mov    %rsp,%rbp
  801220:	48 83 ec 18          	sub    $0x18,%rsp
  801224:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801228:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80122c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801230:	eb 0f                	jmp    801241 <strncmp+0x25>
		n--, p++, q++;
  801232:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801237:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80123c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801241:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801246:	74 1d                	je     801265 <strncmp+0x49>
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	84 c0                	test   %al,%al
  801251:	74 12                	je     801265 <strncmp+0x49>
  801253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801257:	0f b6 10             	movzbl (%rax),%edx
  80125a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	38 c2                	cmp    %al,%dl
  801263:	74 cd                	je     801232 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801265:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80126a:	75 07                	jne    801273 <strncmp+0x57>
		return 0;
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
  801271:	eb 1a                	jmp    80128d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801277:	0f b6 00             	movzbl (%rax),%eax
  80127a:	0f b6 d0             	movzbl %al,%edx
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	0f b6 00             	movzbl (%rax),%eax
  801284:	0f b6 c0             	movzbl %al,%eax
  801287:	89 d1                	mov    %edx,%ecx
  801289:	29 c1                	sub    %eax,%ecx
  80128b:	89 c8                	mov    %ecx,%eax
}
  80128d:	c9                   	leaveq 
  80128e:	c3                   	retq   

000000000080128f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80128f:	55                   	push   %rbp
  801290:	48 89 e5             	mov    %rsp,%rbp
  801293:	48 83 ec 10          	sub    $0x10,%rsp
  801297:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129b:	89 f0                	mov    %esi,%eax
  80129d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012a0:	eb 17                	jmp    8012b9 <strchr+0x2a>
		if (*s == c)
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012ac:	75 06                	jne    8012b4 <strchr+0x25>
			return (char *) s;
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	eb 15                	jmp    8012c9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bd:	0f b6 00             	movzbl (%rax),%eax
  8012c0:	84 c0                	test   %al,%al
  8012c2:	75 de                	jne    8012a2 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c9:	c9                   	leaveq 
  8012ca:	c3                   	retq   

00000000008012cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012cb:	55                   	push   %rbp
  8012cc:	48 89 e5             	mov    %rsp,%rbp
  8012cf:	48 83 ec 10          	sub    $0x10,%rsp
  8012d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012d7:	89 f0                	mov    %esi,%eax
  8012d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012dc:	eb 11                	jmp    8012ef <strfind+0x24>
		if (*s == c)
  8012de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012e8:	74 12                	je     8012fc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f3:	0f b6 00             	movzbl (%rax),%eax
  8012f6:	84 c0                	test   %al,%al
  8012f8:	75 e4                	jne    8012de <strfind+0x13>
  8012fa:	eb 01                	jmp    8012fd <strfind+0x32>
		if (*s == c)
			break;
  8012fc:	90                   	nop
	return (char *) s;
  8012fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801301:	c9                   	leaveq 
  801302:	c3                   	retq   

0000000000801303 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801303:	55                   	push   %rbp
  801304:	48 89 e5             	mov    %rsp,%rbp
  801307:	48 83 ec 18          	sub    $0x18,%rsp
  80130b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801312:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801316:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80131b:	75 06                	jne    801323 <memset+0x20>
		return v;
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	eb 69                	jmp    80138c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	83 e0 03             	and    $0x3,%eax
  80132a:	48 85 c0             	test   %rax,%rax
  80132d:	75 48                	jne    801377 <memset+0x74>
  80132f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 3c                	jne    801377 <memset+0x74>
		c &= 0xFF;
  80133b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801342:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	c1 e2 18             	shl    $0x18,%edx
  80134a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80134d:	c1 e0 10             	shl    $0x10,%eax
  801350:	09 c2                	or     %eax,%edx
  801352:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801355:	c1 e0 08             	shl    $0x8,%eax
  801358:	09 d0                	or     %edx,%eax
  80135a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801361:	48 89 c1             	mov    %rax,%rcx
  801364:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801368:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80136c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136f:	48 89 d7             	mov    %rdx,%rdi
  801372:	fc                   	cld    
  801373:	f3 ab                	rep stos %eax,%es:(%rdi)
  801375:	eb 11                	jmp    801388 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801377:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801382:	48 89 d7             	mov    %rdx,%rdi
  801385:	fc                   	cld    
  801386:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 28          	sub    $0x28,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ba:	0f 83 88 00 00 00    	jae    801448 <memmove+0xba>
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c8:	48 01 d0             	add    %rdx,%rax
  8013cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013cf:	76 77                	jbe    801448 <memmove+0xba>
		s += n;
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 3b                	jne    801428 <memmove+0x9a>
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 2f                	jne    801428 <memmove+0x9a>
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 23                	jne    801428 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	48 83 e8 04          	sub    $0x4,%rax
  80140d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801411:	48 83 ea 04          	sub    $0x4,%rdx
  801415:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801419:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80141d:	48 89 c7             	mov    %rax,%rdi
  801420:	48 89 d6             	mov    %rdx,%rsi
  801423:	fd                   	std    
  801424:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801426:	eb 1d                	jmp    801445 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801434:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	48 89 d7             	mov    %rdx,%rdi
  80143f:	48 89 c1             	mov    %rax,%rcx
  801442:	fd                   	std    
  801443:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801445:	fc                   	cld    
  801446:	eb 57                	jmp    80149f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144c:	83 e0 03             	and    $0x3,%eax
  80144f:	48 85 c0             	test   %rax,%rax
  801452:	75 36                	jne    80148a <memmove+0xfc>
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 2a                	jne    80148a <memmove+0xfc>
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 1e                	jne    80148a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	48 89 c1             	mov    %rax,%rcx
  801473:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801477:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147f:	48 89 c7             	mov    %rax,%rdi
  801482:	48 89 d6             	mov    %rdx,%rsi
  801485:	fc                   	cld    
  801486:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801488:	eb 15                	jmp    80149f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80148a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801492:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801496:	48 89 c7             	mov    %rax,%rdi
  801499:	48 89 d6             	mov    %rdx,%rsi
  80149c:	fc                   	cld    
  80149d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80149f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a3:	c9                   	leaveq 
  8014a4:	c3                   	retq   

00000000008014a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a5:	55                   	push   %rbp
  8014a6:	48 89 e5             	mov    %rsp,%rbp
  8014a9:	48 83 ec 18          	sub    $0x18,%rsp
  8014ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c5:	48 89 ce             	mov    %rcx,%rsi
  8014c8:	48 89 c7             	mov    %rax,%rdi
  8014cb:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8014d2:	00 00 00 
  8014d5:	ff d0                	callq  *%rax
}
  8014d7:	c9                   	leaveq 
  8014d8:	c3                   	retq   

00000000008014d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014d9:	55                   	push   %rbp
  8014da:	48 89 e5             	mov    %rsp,%rbp
  8014dd:	48 83 ec 28          	sub    $0x28,%rsp
  8014e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014fd:	eb 38                	jmp    801537 <memcmp+0x5e>
		if (*s1 != *s2)
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 10             	movzbl (%rax),%edx
  801506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	38 c2                	cmp    %al,%dl
  80150f:	74 1c                	je     80152d <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	0f b6 d0             	movzbl %al,%edx
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 c0             	movzbl %al,%eax
  801525:	89 d1                	mov    %edx,%ecx
  801527:	29 c1                	sub    %eax,%ecx
  801529:	89 c8                	mov    %ecx,%eax
  80152b:	eb 20                	jmp    80154d <memcmp+0x74>
		s1++, s2++;
  80152d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801532:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801537:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80153c:	0f 95 c0             	setne  %al
  80153f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801544:	84 c0                	test   %al,%al
  801546:	75 b7                	jne    8014ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801548:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154d:	c9                   	leaveq 
  80154e:	c3                   	retq   

000000000080154f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80154f:	55                   	push   %rbp
  801550:	48 89 e5             	mov    %rsp,%rbp
  801553:	48 83 ec 28          	sub    $0x28,%rsp
  801557:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80155b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80155e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80156a:	48 01 d0             	add    %rdx,%rax
  80156d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801571:	eb 13                	jmp    801586 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801577:	0f b6 10             	movzbl (%rax),%edx
  80157a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80157d:	38 c2                	cmp    %al,%dl
  80157f:	74 11                	je     801592 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801581:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80158a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80158e:	72 e3                	jb     801573 <memfind+0x24>
  801590:	eb 01                	jmp    801593 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801592:	90                   	nop
	return (void *) s;
  801593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801597:	c9                   	leaveq 
  801598:	c3                   	retq   

0000000000801599 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801599:	55                   	push   %rbp
  80159a:	48 89 e5             	mov    %rsp,%rbp
  80159d:	48 83 ec 38          	sub    $0x38,%rsp
  8015a1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015a9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015b3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015ba:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	eb 05                	jmp    8015c2 <strtol+0x29>
		s++;
  8015bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 20                	cmp    $0x20,%al
  8015cb:	74 f0                	je     8015bd <strtol+0x24>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 09                	cmp    $0x9,%al
  8015d6:	74 e5                	je     8015bd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	0f b6 00             	movzbl (%rax),%eax
  8015df:	3c 2b                	cmp    $0x2b,%al
  8015e1:	75 07                	jne    8015ea <strtol+0x51>
		s++;
  8015e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e8:	eb 17                	jmp    801601 <strtol+0x68>
	else if (*s == '-')
  8015ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	3c 2d                	cmp    $0x2d,%al
  8015f3:	75 0c                	jne    801601 <strtol+0x68>
		s++, neg = 1;
  8015f5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801601:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801605:	74 06                	je     80160d <strtol+0x74>
  801607:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80160b:	75 28                	jne    801635 <strtol+0x9c>
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 30                	cmp    $0x30,%al
  801616:	75 1d                	jne    801635 <strtol+0x9c>
  801618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161c:	48 83 c0 01          	add    $0x1,%rax
  801620:	0f b6 00             	movzbl (%rax),%eax
  801623:	3c 78                	cmp    $0x78,%al
  801625:	75 0e                	jne    801635 <strtol+0x9c>
		s += 2, base = 16;
  801627:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80162c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801633:	eb 2c                	jmp    801661 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801635:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801639:	75 19                	jne    801654 <strtol+0xbb>
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 30                	cmp    $0x30,%al
  801644:	75 0e                	jne    801654 <strtol+0xbb>
		s++, base = 8;
  801646:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80164b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801652:	eb 0d                	jmp    801661 <strtol+0xc8>
	else if (base == 0)
  801654:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801658:	75 07                	jne    801661 <strtol+0xc8>
		base = 10;
  80165a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 2f                	cmp    $0x2f,%al
  80166a:	7e 1d                	jle    801689 <strtol+0xf0>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 39                	cmp    $0x39,%al
  801675:	7f 12                	jg     801689 <strtol+0xf0>
			dig = *s - '0';
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	0f be c0             	movsbl %al,%eax
  801681:	83 e8 30             	sub    $0x30,%eax
  801684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801687:	eb 4e                	jmp    8016d7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 60                	cmp    $0x60,%al
  801692:	7e 1d                	jle    8016b1 <strtol+0x118>
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 7a                	cmp    $0x7a,%al
  80169d:	7f 12                	jg     8016b1 <strtol+0x118>
			dig = *s - 'a' + 10;
  80169f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	0f be c0             	movsbl %al,%eax
  8016a9:	83 e8 57             	sub    $0x57,%eax
  8016ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016af:	eb 26                	jmp    8016d7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b5:	0f b6 00             	movzbl (%rax),%eax
  8016b8:	3c 40                	cmp    $0x40,%al
  8016ba:	7e 47                	jle    801703 <strtol+0x16a>
  8016bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c0:	0f b6 00             	movzbl (%rax),%eax
  8016c3:	3c 5a                	cmp    $0x5a,%al
  8016c5:	7f 3c                	jg     801703 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cb:	0f b6 00             	movzbl (%rax),%eax
  8016ce:	0f be c0             	movsbl %al,%eax
  8016d1:	83 e8 37             	sub    $0x37,%eax
  8016d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016da:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016dd:	7d 23                	jge    801702 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016e4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016e7:	48 98                	cltq   
  8016e9:	48 89 c2             	mov    %rax,%rdx
  8016ec:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8016f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016f4:	48 98                	cltq   
  8016f6:	48 01 d0             	add    %rdx,%rax
  8016f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016fd:	e9 5f ff ff ff       	jmpq   801661 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801702:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801703:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801708:	74 0b                	je     801715 <strtol+0x17c>
		*endptr = (char *) s;
  80170a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801712:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801715:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801719:	74 09                	je     801724 <strtol+0x18b>
  80171b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171f:	48 f7 d8             	neg    %rax
  801722:	eb 04                	jmp    801728 <strtol+0x18f>
  801724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801728:	c9                   	leaveq 
  801729:	c3                   	retq   

000000000080172a <strstr>:

char * strstr(const char *in, const char *str)
{
  80172a:	55                   	push   %rbp
  80172b:	48 89 e5             	mov    %rsp,%rbp
  80172e:	48 83 ec 30          	sub    $0x30,%rsp
  801732:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801736:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  80173a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173e:	0f b6 00             	movzbl (%rax),%eax
  801741:	88 45 ff             	mov    %al,-0x1(%rbp)
  801744:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801749:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80174d:	75 06                	jne    801755 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80174f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801753:	eb 68                	jmp    8017bd <strstr+0x93>

    len = strlen(str);
  801755:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801759:	48 89 c7             	mov    %rax,%rdi
  80175c:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  801763:	00 00 00 
  801766:	ff d0                	callq  *%rax
  801768:	48 98                	cltq   
  80176a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80176e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801772:	0f b6 00             	movzbl (%rax),%eax
  801775:	88 45 ef             	mov    %al,-0x11(%rbp)
  801778:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80177d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801781:	75 07                	jne    80178a <strstr+0x60>
                return (char *) 0;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	eb 33                	jmp    8017bd <strstr+0x93>
        } while (sc != c);
  80178a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80178e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801791:	75 db                	jne    80176e <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801793:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801797:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80179b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179f:	48 89 ce             	mov    %rcx,%rsi
  8017a2:	48 89 c7             	mov    %rax,%rdi
  8017a5:	48 b8 1c 12 80 00 00 	movabs $0x80121c,%rax
  8017ac:	00 00 00 
  8017af:	ff d0                	callq  *%rax
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	75 b9                	jne    80176e <strstr+0x44>

    return (char *) (in - 1);
  8017b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b9:	48 83 e8 01          	sub    $0x1,%rax
}
  8017bd:	c9                   	leaveq 
  8017be:	c3                   	retq   
	...

00000000008017c0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017c0:	55                   	push   %rbp
  8017c1:	48 89 e5             	mov    %rsp,%rbp
  8017c4:	53                   	push   %rbx
  8017c5:	48 83 ec 58          	sub    $0x58,%rsp
  8017c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017cc:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017cf:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017d3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017d7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017db:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017df:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017e2:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8017e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017f9:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8017fc:	4c 89 c3             	mov    %r8,%rbx
  8017ff:	cd 30                	int    $0x30
  801801:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801805:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801809:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80180d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801811:	74 3e                	je     801851 <syscall+0x91>
  801813:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801818:	7e 37                	jle    801851 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  80181a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80181e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801821:	49 89 d0             	mov    %rdx,%r8
  801824:	89 c1                	mov    %eax,%ecx
  801826:	48 ba 40 42 80 00 00 	movabs $0x804240,%rdx
  80182d:	00 00 00 
  801830:	be 23 00 00 00       	mov    $0x23,%esi
  801835:	48 bf 5d 42 80 00 00 	movabs $0x80425d,%rdi
  80183c:	00 00 00 
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	49 b9 74 02 80 00 00 	movabs $0x800274,%r9
  80184b:	00 00 00 
  80184e:	41 ff d1             	callq  *%r9

	return ret;
  801851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801855:	48 83 c4 58          	add    $0x58,%rsp
  801859:	5b                   	pop    %rbx
  80185a:	5d                   	pop    %rbp
  80185b:	c3                   	retq   

000000000080185c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	48 83 ec 20          	sub    $0x20,%rsp
  801864:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801868:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80186c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801870:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801874:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187b:	00 
  80187c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801882:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801888:	48 89 d1             	mov    %rdx,%rcx
  80188b:	48 89 c2             	mov    %rax,%rdx
  80188e:	be 00 00 00 00       	mov    $0x0,%esi
  801893:	bf 00 00 00 00       	mov    $0x0,%edi
  801898:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	callq  *%rax
}
  8018a4:	c9                   	leaveq 
  8018a5:	c3                   	retq   

00000000008018a6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a6:	55                   	push   %rbp
  8018a7:	48 89 e5             	mov    %rsp,%rbp
  8018aa:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018ae:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b5:	00 
  8018b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	be 00 00 00 00       	mov    $0x0,%esi
  8018d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8018d6:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  8018dd:	00 00 00 
  8018e0:	ff d0                	callq  *%rax
}
  8018e2:	c9                   	leaveq 
  8018e3:	c3                   	retq   

00000000008018e4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018e4:	55                   	push   %rbp
  8018e5:	48 89 e5             	mov    %rsp,%rbp
  8018e8:	48 83 ec 20          	sub    $0x20,%rsp
  8018ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018f2:	48 98                	cltq   
  8018f4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018fb:	00 
  8018fc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801902:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801908:	b9 00 00 00 00       	mov    $0x0,%ecx
  80190d:	48 89 c2             	mov    %rax,%rdx
  801910:	be 01 00 00 00       	mov    $0x1,%esi
  801915:	bf 03 00 00 00       	mov    $0x3,%edi
  80191a:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801921:	00 00 00 
  801924:	ff d0                	callq  *%rax
}
  801926:	c9                   	leaveq 
  801927:	c3                   	retq   

0000000000801928 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801928:	55                   	push   %rbp
  801929:	48 89 e5             	mov    %rsp,%rbp
  80192c:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801930:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801937:	00 
  801938:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801944:	b9 00 00 00 00       	mov    $0x0,%ecx
  801949:	ba 00 00 00 00       	mov    $0x0,%edx
  80194e:	be 00 00 00 00       	mov    $0x0,%esi
  801953:	bf 02 00 00 00       	mov    $0x2,%edi
  801958:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
}
  801964:	c9                   	leaveq 
  801965:	c3                   	retq   

0000000000801966 <sys_yield>:

void
sys_yield(void)
{
  801966:	55                   	push   %rbp
  801967:	48 89 e5             	mov    %rsp,%rbp
  80196a:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80196e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801975:	00 
  801976:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801982:	b9 00 00 00 00       	mov    $0x0,%ecx
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	be 00 00 00 00       	mov    $0x0,%esi
  801991:	bf 0b 00 00 00       	mov    $0xb,%edi
  801996:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  80199d:	00 00 00 
  8019a0:	ff d0                	callq  *%rax
}
  8019a2:	c9                   	leaveq 
  8019a3:	c3                   	retq   

00000000008019a4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019a4:	55                   	push   %rbp
  8019a5:	48 89 e5             	mov    %rsp,%rbp
  8019a8:	48 83 ec 20          	sub    $0x20,%rsp
  8019ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019b9:	48 63 c8             	movslq %eax,%rcx
  8019bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c3:	48 98                	cltq   
  8019c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cc:	00 
  8019cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d3:	49 89 c8             	mov    %rcx,%r8
  8019d6:	48 89 d1             	mov    %rdx,%rcx
  8019d9:	48 89 c2             	mov    %rax,%rdx
  8019dc:	be 01 00 00 00       	mov    $0x1,%esi
  8019e1:	bf 04 00 00 00       	mov    $0x4,%edi
  8019e6:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  8019ed:	00 00 00 
  8019f0:	ff d0                	callq  *%rax
}
  8019f2:	c9                   	leaveq 
  8019f3:	c3                   	retq   

00000000008019f4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019f4:	55                   	push   %rbp
  8019f5:	48 89 e5             	mov    %rsp,%rbp
  8019f8:	48 83 ec 30          	sub    $0x30,%rsp
  8019fc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a03:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a06:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a0a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a0e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a11:	48 63 c8             	movslq %eax,%rcx
  801a14:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a18:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a1b:	48 63 f0             	movslq %eax,%rsi
  801a1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a25:	48 98                	cltq   
  801a27:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a2b:	49 89 f9             	mov    %rdi,%r9
  801a2e:	49 89 f0             	mov    %rsi,%r8
  801a31:	48 89 d1             	mov    %rdx,%rcx
  801a34:	48 89 c2             	mov    %rax,%rdx
  801a37:	be 01 00 00 00       	mov    $0x1,%esi
  801a3c:	bf 05 00 00 00       	mov    $0x5,%edi
  801a41:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801a48:	00 00 00 
  801a4b:	ff d0                	callq  *%rax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   

0000000000801a4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 83 ec 20          	sub    $0x20,%rsp
  801a57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a65:	48 98                	cltq   
  801a67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a6e:	00 
  801a6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a7b:	48 89 d1             	mov    %rdx,%rcx
  801a7e:	48 89 c2             	mov    %rax,%rdx
  801a81:	be 01 00 00 00       	mov    $0x1,%esi
  801a86:	bf 06 00 00 00       	mov    $0x6,%edi
  801a8b:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801a92:	00 00 00 
  801a95:	ff d0                	callq  *%rax
}
  801a97:	c9                   	leaveq 
  801a98:	c3                   	retq   

0000000000801a99 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a99:	55                   	push   %rbp
  801a9a:	48 89 e5             	mov    %rsp,%rbp
  801a9d:	48 83 ec 20          	sub    $0x20,%rsp
  801aa1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aa4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801aa7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aaa:	48 63 d0             	movslq %eax,%rdx
  801aad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab0:	48 98                	cltq   
  801ab2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ab9:	00 
  801aba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ac6:	48 89 d1             	mov    %rdx,%rcx
  801ac9:	48 89 c2             	mov    %rax,%rdx
  801acc:	be 01 00 00 00       	mov    $0x1,%esi
  801ad1:	bf 08 00 00 00       	mov    $0x8,%edi
  801ad6:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801add:	00 00 00 
  801ae0:	ff d0                	callq  *%rax
}
  801ae2:	c9                   	leaveq 
  801ae3:	c3                   	retq   

0000000000801ae4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ae4:	55                   	push   %rbp
  801ae5:	48 89 e5             	mov    %rsp,%rbp
  801ae8:	48 83 ec 20          	sub    $0x20,%rsp
  801aec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801af3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afa:	48 98                	cltq   
  801afc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b03:	00 
  801b04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b10:	48 89 d1             	mov    %rdx,%rcx
  801b13:	48 89 c2             	mov    %rax,%rdx
  801b16:	be 01 00 00 00       	mov    $0x1,%esi
  801b1b:	bf 09 00 00 00       	mov    $0x9,%edi
  801b20:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801b27:	00 00 00 
  801b2a:	ff d0                	callq  *%rax
}
  801b2c:	c9                   	leaveq 
  801b2d:	c3                   	retq   

0000000000801b2e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b2e:	55                   	push   %rbp
  801b2f:	48 89 e5             	mov    %rsp,%rbp
  801b32:	48 83 ec 20          	sub    $0x20,%rsp
  801b36:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b44:	48 98                	cltq   
  801b46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4d:	00 
  801b4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5a:	48 89 d1             	mov    %rdx,%rcx
  801b5d:	48 89 c2             	mov    %rax,%rdx
  801b60:	be 01 00 00 00       	mov    $0x1,%esi
  801b65:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b6a:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 30          	sub    $0x30,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b87:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b8b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b91:	48 63 f0             	movslq %eax,%rsi
  801b94:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9b:	48 98                	cltq   
  801b9d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ba8:	00 
  801ba9:	49 89 f1             	mov    %rsi,%r9
  801bac:	49 89 c8             	mov    %rcx,%r8
  801baf:	48 89 d1             	mov    %rdx,%rcx
  801bb2:	48 89 c2             	mov    %rax,%rdx
  801bb5:	be 00 00 00 00       	mov    $0x0,%esi
  801bba:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bbf:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801bc6:	00 00 00 
  801bc9:	ff d0                	callq  *%rax
}
  801bcb:	c9                   	leaveq 
  801bcc:	c3                   	retq   

0000000000801bcd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bcd:	55                   	push   %rbp
  801bce:	48 89 e5             	mov    %rsp,%rbp
  801bd1:	48 83 ec 20          	sub    $0x20,%rsp
  801bd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bdd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be4:	00 
  801be5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801beb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bf6:	48 89 c2             	mov    %rax,%rdx
  801bf9:	be 01 00 00 00       	mov    $0x1,%esi
  801bfe:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c03:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
}
  801c0f:	c9                   	leaveq 
  801c10:	c3                   	retq   

0000000000801c11 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c11:	55                   	push   %rbp
  801c12:	48 89 e5             	mov    %rsp,%rbp
  801c15:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c20:	00 
  801c21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	be 00 00 00 00       	mov    $0x0,%esi
  801c3c:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c41:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801c48:	00 00 00 
  801c4b:	ff d0                	callq  *%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 20          	sub    $0x20,%rsp
  801c57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c63:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c67:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c6e:	00 
  801c6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c75:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c7b:	48 89 d1             	mov    %rdx,%rcx
  801c7e:	48 89 c2             	mov    %rax,%rdx
  801c81:	be 00 00 00 00       	mov    $0x0,%esi
  801c86:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c8b:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
}
  801c97:	c9                   	leaveq 
  801c98:	c3                   	retq   

0000000000801c99 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801c99:	55                   	push   %rbp
  801c9a:	48 89 e5             	mov    %rsp,%rbp
  801c9d:	48 83 ec 20          	sub    $0x20,%rsp
  801ca1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ca5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801ca9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb8:	00 
  801cb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc5:	48 89 d1             	mov    %rdx,%rcx
  801cc8:	48 89 c2             	mov    %rax,%rdx
  801ccb:	be 00 00 00 00       	mov    $0x0,%esi
  801cd0:	bf 10 00 00 00       	mov    $0x10,%edi
  801cd5:	48 b8 c0 17 80 00 00 	movabs $0x8017c0,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   
	...

0000000000801ce4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801ce4:	55                   	push   %rbp
  801ce5:	48 89 e5             	mov    %rsp,%rbp
  801ce8:	48 83 ec 08          	sub    $0x8,%rsp
  801cec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cf0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cfb:	ff ff ff 
  801cfe:	48 01 d0             	add    %rdx,%rax
  801d01:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d05:	c9                   	leaveq 
  801d06:	c3                   	retq   

0000000000801d07 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d07:	55                   	push   %rbp
  801d08:	48 89 e5             	mov    %rsp,%rbp
  801d0b:	48 83 ec 08          	sub    $0x8,%rsp
  801d0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d17:	48 89 c7             	mov    %rax,%rdi
  801d1a:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  801d21:	00 00 00 
  801d24:	ff d0                	callq  *%rax
  801d26:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d2c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d30:	c9                   	leaveq 
  801d31:	c3                   	retq   

0000000000801d32 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d32:	55                   	push   %rbp
  801d33:	48 89 e5             	mov    %rsp,%rbp
  801d36:	48 83 ec 18          	sub    $0x18,%rsp
  801d3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d45:	eb 6b                	jmp    801db2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d4a:	48 98                	cltq   
  801d4c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d52:	48 c1 e0 0c          	shl    $0xc,%rax
  801d56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5e:	48 89 c2             	mov    %rax,%rdx
  801d61:	48 c1 ea 15          	shr    $0x15,%rdx
  801d65:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d6c:	01 00 00 
  801d6f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d73:	83 e0 01             	and    $0x1,%eax
  801d76:	48 85 c0             	test   %rax,%rax
  801d79:	74 21                	je     801d9c <fd_alloc+0x6a>
  801d7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d7f:	48 89 c2             	mov    %rax,%rdx
  801d82:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d86:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d8d:	01 00 00 
  801d90:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d94:	83 e0 01             	and    $0x1,%eax
  801d97:	48 85 c0             	test   %rax,%rax
  801d9a:	75 12                	jne    801dae <fd_alloc+0x7c>
			*fd_store = fd;
  801d9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801da0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801da4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	eb 1a                	jmp    801dc8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dae:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801db2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801db6:	7e 8f                	jle    801d47 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dbc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dc3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dc8:	c9                   	leaveq 
  801dc9:	c3                   	retq   

0000000000801dca <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dca:	55                   	push   %rbp
  801dcb:	48 89 e5             	mov    %rsp,%rbp
  801dce:	48 83 ec 20          	sub    $0x20,%rsp
  801dd2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dd5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801dd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ddd:	78 06                	js     801de5 <fd_lookup+0x1b>
  801ddf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801de3:	7e 07                	jle    801dec <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801de5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801dea:	eb 6c                	jmp    801e58 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801dec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801def:	48 98                	cltq   
  801df1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801df7:	48 c1 e0 0c          	shl    $0xc,%rax
  801dfb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e03:	48 89 c2             	mov    %rax,%rdx
  801e06:	48 c1 ea 15          	shr    $0x15,%rdx
  801e0a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e11:	01 00 00 
  801e14:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e18:	83 e0 01             	and    $0x1,%eax
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	74 21                	je     801e41 <fd_lookup+0x77>
  801e20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e24:	48 89 c2             	mov    %rax,%rdx
  801e27:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e2b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e32:	01 00 00 
  801e35:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e39:	83 e0 01             	and    $0x1,%eax
  801e3c:	48 85 c0             	test   %rax,%rax
  801e3f:	75 07                	jne    801e48 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e41:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e46:	eb 10                	jmp    801e58 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e50:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	c9                   	leaveq 
  801e59:	c3                   	retq   

0000000000801e5a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	48 83 ec 30          	sub    $0x30,%rsp
  801e62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e66:	89 f0                	mov    %esi,%eax
  801e68:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e6f:	48 89 c7             	mov    %rax,%rdi
  801e72:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  801e79:	00 00 00 
  801e7c:	ff d0                	callq  *%rax
  801e7e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e82:	48 89 d6             	mov    %rdx,%rsi
  801e85:	89 c7                	mov    %eax,%edi
  801e87:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  801e8e:	00 00 00 
  801e91:	ff d0                	callq  *%rax
  801e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e9a:	78 0a                	js     801ea6 <fd_close+0x4c>
	    || fd != fd2)
  801e9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ea4:	74 12                	je     801eb8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ea6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801eaa:	74 05                	je     801eb1 <fd_close+0x57>
  801eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eaf:	eb 05                	jmp    801eb6 <fd_close+0x5c>
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	eb 69                	jmp    801f21 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801eb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebc:	8b 00                	mov    (%rax),%eax
  801ebe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ec2:	48 89 d6             	mov    %rdx,%rsi
  801ec5:	89 c7                	mov    %eax,%edi
  801ec7:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ed6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eda:	78 2a                	js     801f06 <fd_close+0xac>
		if (dev->dev_close)
  801edc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee0:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ee4:	48 85 c0             	test   %rax,%rax
  801ee7:	74 16                	je     801eff <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eed:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef5:	48 89 c7             	mov    %rax,%rdi
  801ef8:	ff d2                	callq  *%rdx
  801efa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801efd:	eb 07                	jmp    801f06 <fd_close+0xac>
		else
			r = 0;
  801eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f0a:	48 89 c6             	mov    %rax,%rsi
  801f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f12:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
	return r;
  801f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f21:	c9                   	leaveq 
  801f22:	c3                   	retq   

0000000000801f23 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f23:	55                   	push   %rbp
  801f24:	48 89 e5             	mov    %rsp,%rbp
  801f27:	48 83 ec 20          	sub    $0x20,%rsp
  801f2b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f39:	eb 41                	jmp    801f7c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f3b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f42:	00 00 00 
  801f45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f48:	48 63 d2             	movslq %edx,%rdx
  801f4b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f4f:	8b 00                	mov    (%rax),%eax
  801f51:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f54:	75 22                	jne    801f78 <dev_lookup+0x55>
			*dev = devtab[i];
  801f56:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f5d:	00 00 00 
  801f60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f63:	48 63 d2             	movslq %edx,%rdx
  801f66:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
  801f76:	eb 60                	jmp    801fd8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f7c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801f83:	00 00 00 
  801f86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f89:	48 63 d2             	movslq %edx,%rdx
  801f8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f90:	48 85 c0             	test   %rax,%rax
  801f93:	75 a6                	jne    801f3b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f95:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  801f9c:	00 00 00 
  801f9f:	48 8b 00             	mov    (%rax),%rax
  801fa2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fa8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fab:	89 c6                	mov    %eax,%esi
  801fad:	48 bf 70 42 80 00 00 	movabs $0x804270,%rdi
  801fb4:	00 00 00 
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	48 b9 af 04 80 00 00 	movabs $0x8004af,%rcx
  801fc3:	00 00 00 
  801fc6:	ff d1                	callq  *%rcx
	*dev = 0;
  801fc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fcc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fd8:	c9                   	leaveq 
  801fd9:	c3                   	retq   

0000000000801fda <close>:

int
close(int fdnum)
{
  801fda:	55                   	push   %rbp
  801fdb:	48 89 e5             	mov    %rsp,%rbp
  801fde:	48 83 ec 20          	sub    $0x20,%rsp
  801fe2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fe9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fec:	48 89 d6             	mov    %rdx,%rsi
  801fef:	89 c7                	mov    %eax,%edi
  801ff1:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
  801ffd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802000:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802004:	79 05                	jns    80200b <close+0x31>
		return r;
  802006:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802009:	eb 18                	jmp    802023 <close+0x49>
	else
		return fd_close(fd, 1);
  80200b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200f:	be 01 00 00 00       	mov    $0x1,%esi
  802014:	48 89 c7             	mov    %rax,%rdi
  802017:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
}
  802023:	c9                   	leaveq 
  802024:	c3                   	retq   

0000000000802025 <close_all>:

void
close_all(void)
{
  802025:	55                   	push   %rbp
  802026:	48 89 e5             	mov    %rsp,%rbp
  802029:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80202d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802034:	eb 15                	jmp    80204b <close_all+0x26>
		close(i);
  802036:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802039:	89 c7                	mov    %eax,%edi
  80203b:	48 b8 da 1f 80 00 00 	movabs $0x801fda,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802047:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80204b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80204f:	7e e5                	jle    802036 <close_all+0x11>
		close(i);
}
  802051:	c9                   	leaveq 
  802052:	c3                   	retq   

0000000000802053 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802053:	55                   	push   %rbp
  802054:	48 89 e5             	mov    %rsp,%rbp
  802057:	48 83 ec 40          	sub    $0x40,%rsp
  80205b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80205e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802061:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802065:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802068:	48 89 d6             	mov    %rdx,%rsi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802080:	79 08                	jns    80208a <dup+0x37>
		return r;
  802082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802085:	e9 70 01 00 00       	jmpq   8021fa <dup+0x1a7>
	close(newfdnum);
  80208a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80208d:	89 c7                	mov    %eax,%edi
  80208f:	48 b8 da 1f 80 00 00 	movabs $0x801fda,%rax
  802096:	00 00 00 
  802099:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80209b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80209e:	48 98                	cltq   
  8020a0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020a6:	48 c1 e0 0c          	shl    $0xc,%rax
  8020aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b2:	48 89 c7             	mov    %rax,%rdi
  8020b5:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	callq  *%rax
  8020c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c9:	48 89 c7             	mov    %rax,%rdi
  8020cc:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8020d3:	00 00 00 
  8020d6:	ff d0                	callq  *%rax
  8020d8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e0:	48 89 c2             	mov    %rax,%rdx
  8020e3:	48 c1 ea 15          	shr    $0x15,%rdx
  8020e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020ee:	01 00 00 
  8020f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f5:	83 e0 01             	and    $0x1,%eax
  8020f8:	84 c0                	test   %al,%al
  8020fa:	74 71                	je     80216d <dup+0x11a>
  8020fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802100:	48 89 c2             	mov    %rax,%rdx
  802103:	48 c1 ea 0c          	shr    $0xc,%rdx
  802107:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210e:	01 00 00 
  802111:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802115:	83 e0 01             	and    $0x1,%eax
  802118:	84 c0                	test   %al,%al
  80211a:	74 51                	je     80216d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80211c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802120:	48 89 c2             	mov    %rax,%rdx
  802123:	48 c1 ea 0c          	shr    $0xc,%rdx
  802127:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80212e:	01 00 00 
  802131:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802135:	89 c1                	mov    %eax,%ecx
  802137:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80213d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802145:	41 89 c8             	mov    %ecx,%r8d
  802148:	48 89 d1             	mov    %rdx,%rcx
  80214b:	ba 00 00 00 00       	mov    $0x0,%edx
  802150:	48 89 c6             	mov    %rax,%rsi
  802153:	bf 00 00 00 00       	mov    $0x0,%edi
  802158:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax
  802164:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216b:	78 56                	js     8021c3 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80216d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802171:	48 89 c2             	mov    %rax,%rdx
  802174:	48 c1 ea 0c          	shr    $0xc,%rdx
  802178:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217f:	01 00 00 
  802182:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802186:	89 c1                	mov    %eax,%ecx
  802188:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80218e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802192:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802196:	41 89 c8             	mov    %ecx,%r8d
  802199:	48 89 d1             	mov    %rdx,%rcx
  80219c:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a1:	48 89 c6             	mov    %rax,%rsi
  8021a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a9:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	callq  *%rax
  8021b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021bc:	78 08                	js     8021c6 <dup+0x173>
		goto err;

	return newfdnum;
  8021be:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021c1:	eb 37                	jmp    8021fa <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8021c3:	90                   	nop
  8021c4:	eb 01                	jmp    8021c7 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8021c6:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8021c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021cb:	48 89 c6             	mov    %rax,%rsi
  8021ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d3:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8021da:	00 00 00 
  8021dd:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e3:	48 89 c6             	mov    %rax,%rsi
  8021e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021eb:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8021f2:	00 00 00 
  8021f5:	ff d0                	callq  *%rax
	return r;
  8021f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021fa:	c9                   	leaveq 
  8021fb:	c3                   	retq   

00000000008021fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021fc:	55                   	push   %rbp
  8021fd:	48 89 e5             	mov    %rsp,%rbp
  802200:	48 83 ec 40          	sub    $0x40,%rsp
  802204:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802207:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80220b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80220f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802213:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802216:	48 89 d6             	mov    %rdx,%rsi
  802219:	89 c7                	mov    %eax,%edi
  80221b:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802222:	00 00 00 
  802225:	ff d0                	callq  *%rax
  802227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80222a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80222e:	78 24                	js     802254 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802230:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802234:	8b 00                	mov    (%rax),%eax
  802236:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80223a:	48 89 d6             	mov    %rdx,%rsi
  80223d:	89 c7                	mov    %eax,%edi
  80223f:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  802246:	00 00 00 
  802249:	ff d0                	callq  *%rax
  80224b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802252:	79 05                	jns    802259 <read+0x5d>
		return r;
  802254:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802257:	eb 7a                	jmp    8022d3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225d:	8b 40 08             	mov    0x8(%rax),%eax
  802260:	83 e0 03             	and    $0x3,%eax
  802263:	83 f8 01             	cmp    $0x1,%eax
  802266:	75 3a                	jne    8022a2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802268:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  80226f:	00 00 00 
  802272:	48 8b 00             	mov    (%rax),%rax
  802275:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80227b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80227e:	89 c6                	mov    %eax,%esi
  802280:	48 bf 8f 42 80 00 00 	movabs $0x80428f,%rdi
  802287:	00 00 00 
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
  80228f:	48 b9 af 04 80 00 00 	movabs $0x8004af,%rcx
  802296:	00 00 00 
  802299:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80229b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a0:	eb 31                	jmp    8022d3 <read+0xd7>
	}
	if (!dev->dev_read)
  8022a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022a6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022aa:	48 85 c0             	test   %rax,%rax
  8022ad:	75 07                	jne    8022b6 <read+0xba>
		return -E_NOT_SUPP;
  8022af:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022b4:	eb 1d                	jmp    8022d3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8022b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022ba:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8022be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022c6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022ca:	48 89 ce             	mov    %rcx,%rsi
  8022cd:	48 89 c7             	mov    %rax,%rdi
  8022d0:	41 ff d0             	callq  *%r8
}
  8022d3:	c9                   	leaveq 
  8022d4:	c3                   	retq   

00000000008022d5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022d5:	55                   	push   %rbp
  8022d6:	48 89 e5             	mov    %rsp,%rbp
  8022d9:	48 83 ec 30          	sub    $0x30,%rsp
  8022dd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022ef:	eb 46                	jmp    802337 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f4:	48 98                	cltq   
  8022f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022fa:	48 29 c2             	sub    %rax,%rdx
  8022fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802300:	48 98                	cltq   
  802302:	48 89 c1             	mov    %rax,%rcx
  802305:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802309:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80230c:	48 89 ce             	mov    %rcx,%rsi
  80230f:	89 c7                	mov    %eax,%edi
  802311:	48 b8 fc 21 80 00 00 	movabs $0x8021fc,%rax
  802318:	00 00 00 
  80231b:	ff d0                	callq  *%rax
  80231d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802320:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802324:	79 05                	jns    80232b <readn+0x56>
			return m;
  802326:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802329:	eb 1d                	jmp    802348 <readn+0x73>
		if (m == 0)
  80232b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80232f:	74 13                	je     802344 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802331:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802334:	01 45 fc             	add    %eax,-0x4(%rbp)
  802337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233a:	48 98                	cltq   
  80233c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802340:	72 af                	jb     8022f1 <readn+0x1c>
  802342:	eb 01                	jmp    802345 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802344:	90                   	nop
	}
	return tot;
  802345:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802348:	c9                   	leaveq 
  802349:	c3                   	retq   

000000000080234a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80234a:	55                   	push   %rbp
  80234b:	48 89 e5             	mov    %rsp,%rbp
  80234e:	48 83 ec 40          	sub    $0x40,%rsp
  802352:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802355:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802359:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80235d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802361:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802364:	48 89 d6             	mov    %rdx,%rsi
  802367:	89 c7                	mov    %eax,%edi
  802369:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802370:	00 00 00 
  802373:	ff d0                	callq  *%rax
  802375:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802378:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237c:	78 24                	js     8023a2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80237e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802382:	8b 00                	mov    (%rax),%eax
  802384:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802388:	48 89 d6             	mov    %rdx,%rsi
  80238b:	89 c7                	mov    %eax,%edi
  80238d:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  802394:	00 00 00 
  802397:	ff d0                	callq  *%rax
  802399:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80239c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023a0:	79 05                	jns    8023a7 <write+0x5d>
		return r;
  8023a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023a5:	eb 79                	jmp    802420 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ab:	8b 40 08             	mov    0x8(%rax),%eax
  8023ae:	83 e0 03             	and    $0x3,%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	75 3a                	jne    8023ef <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023b5:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8023bc:	00 00 00 
  8023bf:	48 8b 00             	mov    (%rax),%rax
  8023c2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023cb:	89 c6                	mov    %eax,%esi
  8023cd:	48 bf ab 42 80 00 00 	movabs $0x8042ab,%rdi
  8023d4:	00 00 00 
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	48 b9 af 04 80 00 00 	movabs $0x8004af,%rcx
  8023e3:	00 00 00 
  8023e6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023ed:	eb 31                	jmp    802420 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023f7:	48 85 c0             	test   %rax,%rax
  8023fa:	75 07                	jne    802403 <write+0xb9>
		return -E_NOT_SUPP;
  8023fc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802401:	eb 1d                	jmp    802420 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802407:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80240b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80240f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802413:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802417:	48 89 ce             	mov    %rcx,%rsi
  80241a:	48 89 c7             	mov    %rax,%rdi
  80241d:	41 ff d0             	callq  *%r8
}
  802420:	c9                   	leaveq 
  802421:	c3                   	retq   

0000000000802422 <seek>:

int
seek(int fdnum, off_t offset)
{
  802422:	55                   	push   %rbp
  802423:	48 89 e5             	mov    %rsp,%rbp
  802426:	48 83 ec 18          	sub    $0x18,%rsp
  80242a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80242d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802430:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802434:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802437:	48 89 d6             	mov    %rdx,%rsi
  80243a:	89 c7                	mov    %eax,%edi
  80243c:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802443:	00 00 00 
  802446:	ff d0                	callq  *%rax
  802448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80244f:	79 05                	jns    802456 <seek+0x34>
		return r;
  802451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802454:	eb 0f                	jmp    802465 <seek+0x43>
	fd->fd_offset = offset;
  802456:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	48 83 ec 30          	sub    $0x30,%rsp
  80246f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802472:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802475:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802479:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80247c:	48 89 d6             	mov    %rdx,%rsi
  80247f:	89 c7                	mov    %eax,%edi
  802481:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802488:	00 00 00 
  80248b:	ff d0                	callq  *%rax
  80248d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802490:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802494:	78 24                	js     8024ba <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802496:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80249a:	8b 00                	mov    (%rax),%eax
  80249c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a0:	48 89 d6             	mov    %rdx,%rsi
  8024a3:	89 c7                	mov    %eax,%edi
  8024a5:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  8024ac:	00 00 00 
  8024af:	ff d0                	callq  *%rax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b8:	79 05                	jns    8024bf <ftruncate+0x58>
		return r;
  8024ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024bd:	eb 72                	jmp    802531 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024c3:	8b 40 08             	mov    0x8(%rax),%eax
  8024c6:	83 e0 03             	and    $0x3,%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 3a                	jne    802507 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024cd:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  8024d4:	00 00 00 
  8024d7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024e0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024e3:	89 c6                	mov    %eax,%esi
  8024e5:	48 bf c8 42 80 00 00 	movabs $0x8042c8,%rdi
  8024ec:	00 00 00 
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	48 b9 af 04 80 00 00 	movabs $0x8004af,%rcx
  8024fb:	00 00 00 
  8024fe:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802500:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802505:	eb 2a                	jmp    802531 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80250f:	48 85 c0             	test   %rax,%rax
  802512:	75 07                	jne    80251b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802514:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802519:	eb 16                	jmp    802531 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80251b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802527:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80252a:	89 d6                	mov    %edx,%esi
  80252c:	48 89 c7             	mov    %rax,%rdi
  80252f:	ff d1                	callq  *%rcx
}
  802531:	c9                   	leaveq 
  802532:	c3                   	retq   

0000000000802533 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802533:	55                   	push   %rbp
  802534:	48 89 e5             	mov    %rsp,%rbp
  802537:	48 83 ec 30          	sub    $0x30,%rsp
  80253b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80253e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802542:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802546:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802549:	48 89 d6             	mov    %rdx,%rsi
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802555:	00 00 00 
  802558:	ff d0                	callq  *%rax
  80255a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802561:	78 24                	js     802587 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802563:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802567:	8b 00                	mov    (%rax),%eax
  802569:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80256d:	48 89 d6             	mov    %rdx,%rsi
  802570:	89 c7                	mov    %eax,%edi
  802572:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  802579:	00 00 00 
  80257c:	ff d0                	callq  *%rax
  80257e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802581:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802585:	79 05                	jns    80258c <fstat+0x59>
		return r;
  802587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258a:	eb 5e                	jmp    8025ea <fstat+0xb7>
	if (!dev->dev_stat)
  80258c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802590:	48 8b 40 28          	mov    0x28(%rax),%rax
  802594:	48 85 c0             	test   %rax,%rax
  802597:	75 07                	jne    8025a0 <fstat+0x6d>
		return -E_NOT_SUPP;
  802599:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80259e:	eb 4a                	jmp    8025ea <fstat+0xb7>
	stat->st_name[0] = 0;
  8025a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8025a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025b2:	00 00 00 
	stat->st_isdir = 0;
  8025b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025b9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025c0:	00 00 00 
	stat->st_dev = dev;
  8025c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025cb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8025da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025de:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8025e2:	48 89 d6             	mov    %rdx,%rsi
  8025e5:	48 89 c7             	mov    %rax,%rdi
  8025e8:	ff d1                	callq  *%rcx
}
  8025ea:	c9                   	leaveq 
  8025eb:	c3                   	retq   

00000000008025ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025ec:	55                   	push   %rbp
  8025ed:	48 89 e5             	mov    %rsp,%rbp
  8025f0:	48 83 ec 20          	sub    $0x20,%rsp
  8025f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802600:	be 00 00 00 00       	mov    $0x0,%esi
  802605:	48 89 c7             	mov    %rax,%rdi
  802608:	48 b8 db 26 80 00 00 	movabs $0x8026db,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
  802614:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802617:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80261b:	79 05                	jns    802622 <stat+0x36>
		return fd;
  80261d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802620:	eb 2f                	jmp    802651 <stat+0x65>
	r = fstat(fd, stat);
  802622:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802629:	48 89 d6             	mov    %rdx,%rsi
  80262c:	89 c7                	mov    %eax,%edi
  80262e:	48 b8 33 25 80 00 00 	movabs $0x802533,%rax
  802635:	00 00 00 
  802638:	ff d0                	callq  *%rax
  80263a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80263d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802640:	89 c7                	mov    %eax,%edi
  802642:	48 b8 da 1f 80 00 00 	movabs $0x801fda,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
	return r;
  80264e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802651:	c9                   	leaveq 
  802652:	c3                   	retq   
	...

0000000000802654 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 10          	sub    $0x10,%rsp
  80265c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80265f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802663:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80266a:	00 00 00 
  80266d:	8b 00                	mov    (%rax),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 1d                	jne    802690 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802673:	bf 01 00 00 00       	mov    $0x1,%edi
  802678:	48 b8 f7 3b 80 00 00 	movabs $0x803bf7,%rax
  80267f:	00 00 00 
  802682:	ff d0                	callq  *%rax
  802684:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  80268b:	00 00 00 
  80268e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802690:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802697:	00 00 00 
  80269a:	8b 00                	mov    (%rax),%eax
  80269c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80269f:	b9 07 00 00 00       	mov    $0x7,%ecx
  8026a4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8026ab:	00 00 00 
  8026ae:	89 c7                	mov    %eax,%edi
  8026b0:	48 b8 34 3b 80 00 00 	movabs $0x803b34,%rax
  8026b7:	00 00 00 
  8026ba:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c5:	48 89 c6             	mov    %rax,%rsi
  8026c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8026cd:	48 b8 74 3a 80 00 00 	movabs $0x803a74,%rax
  8026d4:	00 00 00 
  8026d7:	ff d0                	callq  *%rax
}
  8026d9:	c9                   	leaveq 
  8026da:	c3                   	retq   

00000000008026db <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026db:	55                   	push   %rbp
  8026dc:	48 89 e5             	mov    %rsp,%rbp
  8026df:	48 83 ec 20          	sub    $0x20,%rsp
  8026e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8026ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ee:	48 89 c7             	mov    %rax,%rdi
  8026f1:	48 b8 00 10 80 00 00 	movabs $0x801000,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
  8026fd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802702:	7e 0a                	jle    80270e <open+0x33>
                return -E_BAD_PATH;
  802704:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802709:	e9 a5 00 00 00       	jmpq   8027b3 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80270e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802712:	48 89 c7             	mov    %rax,%rdi
  802715:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  80271c:	00 00 00 
  80271f:	ff d0                	callq  *%rax
  802721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802728:	79 08                	jns    802732 <open+0x57>
		return r;
  80272a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80272d:	e9 81 00 00 00       	jmpq   8027b3 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802736:	48 89 c6             	mov    %rax,%rsi
  802739:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802740:	00 00 00 
  802743:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  80274a:	00 00 00 
  80274d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80274f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802756:	00 00 00 
  802759:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80275c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802762:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802766:	48 89 c6             	mov    %rax,%rsi
  802769:	bf 01 00 00 00       	mov    $0x1,%edi
  80276e:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
  80277a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  80277d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802781:	79 1d                	jns    8027a0 <open+0xc5>
	{
		fd_close(fd,0);
  802783:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802787:	be 00 00 00 00       	mov    $0x0,%esi
  80278c:	48 89 c7             	mov    %rax,%rdi
  80278f:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802796:	00 00 00 
  802799:	ff d0                	callq  *%rax
		return r;
  80279b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279e:	eb 13                	jmp    8027b3 <open+0xd8>
	}
	return fd2num(fd);
  8027a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a4:	48 89 c7             	mov    %rax,%rdi
  8027a7:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  8027ae:	00 00 00 
  8027b1:	ff d0                	callq  *%rax
	


}
  8027b3:	c9                   	leaveq 
  8027b4:	c3                   	retq   

00000000008027b5 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027b5:	55                   	push   %rbp
  8027b6:	48 89 e5             	mov    %rsp,%rbp
  8027b9:	48 83 ec 10          	sub    $0x10,%rsp
  8027bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027c5:	8b 50 0c             	mov    0xc(%rax),%edx
  8027c8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027cf:	00 00 00 
  8027d2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027d4:	be 00 00 00 00       	mov    $0x0,%esi
  8027d9:	bf 06 00 00 00       	mov    $0x6,%edi
  8027de:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  8027e5:	00 00 00 
  8027e8:	ff d0                	callq  *%rax
}
  8027ea:	c9                   	leaveq 
  8027eb:	c3                   	retq   

00000000008027ec <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027ec:	55                   	push   %rbp
  8027ed:	48 89 e5             	mov    %rsp,%rbp
  8027f0:	48 83 ec 30          	sub    $0x30,%rsp
  8027f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027f8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027fc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802804:	8b 50 0c             	mov    0xc(%rax),%edx
  802807:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80280e:	00 00 00 
  802811:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802813:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80281a:	00 00 00 
  80281d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802821:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802825:	be 00 00 00 00       	mov    $0x0,%esi
  80282a:	bf 03 00 00 00       	mov    $0x3,%edi
  80282f:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
  80283b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80283e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802842:	79 05                	jns    802849 <devfile_read+0x5d>
	{
		return r;
  802844:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802847:	eb 2c                	jmp    802875 <devfile_read+0x89>
	}
	if(r > 0)
  802849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284d:	7e 23                	jle    802872 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80284f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802852:	48 63 d0             	movslq %eax,%rdx
  802855:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802859:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802860:	00 00 00 
  802863:	48 89 c7             	mov    %rax,%rdi
  802866:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  80286d:	00 00 00 
  802870:	ff d0                	callq  *%rax
	return r;
  802872:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802875:	c9                   	leaveq 
  802876:	c3                   	retq   

0000000000802877 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802877:	55                   	push   %rbp
  802878:	48 89 e5             	mov    %rsp,%rbp
  80287b:	48 83 ec 30          	sub    $0x30,%rsp
  80287f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802883:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802887:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80288b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80288f:	8b 50 0c             	mov    0xc(%rax),%edx
  802892:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802899:	00 00 00 
  80289c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80289e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8028a5:	00 
  8028a6:	76 08                	jbe    8028b0 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8028a8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8028af:	00 
	fsipcbuf.write.req_n=n;
  8028b0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028b7:	00 00 00 
  8028ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028be:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8028c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ca:	48 89 c6             	mov    %rax,%rsi
  8028cd:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8028d4:	00 00 00 
  8028d7:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8028de:	00 00 00 
  8028e1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8028e3:	be 00 00 00 00       	mov    $0x0,%esi
  8028e8:	bf 04 00 00 00       	mov    $0x4,%edi
  8028ed:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax
  8028f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8028fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028ff:	c9                   	leaveq 
  802900:	c3                   	retq   

0000000000802901 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802901:	55                   	push   %rbp
  802902:	48 89 e5             	mov    %rsp,%rbp
  802905:	48 83 ec 10          	sub    $0x10,%rsp
  802909:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80290d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802910:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802914:	8b 50 0c             	mov    0xc(%rax),%edx
  802917:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80291e:	00 00 00 
  802921:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802923:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80292a:	00 00 00 
  80292d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802930:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802933:	be 00 00 00 00       	mov    $0x0,%esi
  802938:	bf 02 00 00 00       	mov    $0x2,%edi
  80293d:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  802944:	00 00 00 
  802947:	ff d0                	callq  *%rax
}
  802949:	c9                   	leaveq 
  80294a:	c3                   	retq   

000000000080294b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80294b:	55                   	push   %rbp
  80294c:	48 89 e5             	mov    %rsp,%rbp
  80294f:	48 83 ec 20          	sub    $0x20,%rsp
  802953:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802957:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80295b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80295f:	8b 50 0c             	mov    0xc(%rax),%edx
  802962:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802969:	00 00 00 
  80296c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80296e:	be 00 00 00 00       	mov    $0x0,%esi
  802973:	bf 05 00 00 00       	mov    $0x5,%edi
  802978:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
  802984:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802987:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80298b:	79 05                	jns    802992 <devfile_stat+0x47>
		return r;
  80298d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802990:	eb 56                	jmp    8029e8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802992:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802996:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80299d:	00 00 00 
  8029a0:	48 89 c7             	mov    %rax,%rdi
  8029a3:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  8029aa:	00 00 00 
  8029ad:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8029af:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029b6:	00 00 00 
  8029b9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8029bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8029c9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029d0:	00 00 00 
  8029d3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8029d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029dd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8029e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e8:	c9                   	leaveq 
  8029e9:	c3                   	retq   
	...

00000000008029ec <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8029ec:	55                   	push   %rbp
  8029ed:	48 89 e5             	mov    %rsp,%rbp
  8029f0:	48 83 ec 20          	sub    $0x20,%rsp
  8029f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8029f7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029fe:	48 89 d6             	mov    %rdx,%rsi
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a12:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a16:	79 05                	jns    802a1d <fd2sockid+0x31>
		return r;
  802a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a1b:	eb 24                	jmp    802a41 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a21:	8b 10                	mov    (%rax),%edx
  802a23:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802a2a:	00 00 00 
  802a2d:	8b 00                	mov    (%rax),%eax
  802a2f:	39 c2                	cmp    %eax,%edx
  802a31:	74 07                	je     802a3a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802a33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a38:	eb 07                	jmp    802a41 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802a3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a3e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802a41:	c9                   	leaveq 
  802a42:	c3                   	retq   

0000000000802a43 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802a43:	55                   	push   %rbp
  802a44:	48 89 e5             	mov    %rsp,%rbp
  802a47:	48 83 ec 20          	sub    $0x20,%rsp
  802a4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802a4e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a52:	48 89 c7             	mov    %rax,%rdi
  802a55:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
  802a61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a68:	78 26                	js     802a90 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a6e:	ba 07 04 00 00       	mov    $0x407,%edx
  802a73:	48 89 c6             	mov    %rax,%rsi
  802a76:	bf 00 00 00 00       	mov    $0x0,%edi
  802a7b:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
  802a87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8e:	79 16                	jns    802aa6 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802a90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a93:	89 c7                	mov    %eax,%edi
  802a95:	48 b8 50 2f 80 00 00 	movabs $0x802f50,%rax
  802a9c:	00 00 00 
  802a9f:	ff d0                	callq  *%rax
		return r;
  802aa1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa4:	eb 3a                	jmp    802ae0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802aa6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aaa:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802ab1:	00 00 00 
  802ab4:	8b 12                	mov    (%rdx),%edx
  802ab6:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ab8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ac3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac7:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802aca:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802acd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad1:	48 89 c7             	mov    %rax,%rdi
  802ad4:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
}
  802ae0:	c9                   	leaveq 
  802ae1:	c3                   	retq   

0000000000802ae2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ae2:	55                   	push   %rbp
  802ae3:	48 89 e5             	mov    %rsp,%rbp
  802ae6:	48 83 ec 30          	sub    $0x30,%rsp
  802aea:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802aed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802af1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802af5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802af8:	89 c7                	mov    %eax,%edi
  802afa:	48 b8 ec 29 80 00 00 	movabs $0x8029ec,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0d:	79 05                	jns    802b14 <accept+0x32>
		return r;
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b12:	eb 3b                	jmp    802b4f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b14:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b18:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1f:	48 89 ce             	mov    %rcx,%rsi
  802b22:	89 c7                	mov    %eax,%edi
  802b24:	48 b8 2d 2e 80 00 00 	movabs $0x802e2d,%rax
  802b2b:	00 00 00 
  802b2e:	ff d0                	callq  *%rax
  802b30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b37:	79 05                	jns    802b3e <accept+0x5c>
		return r;
  802b39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3c:	eb 11                	jmp    802b4f <accept+0x6d>
	return alloc_sockfd(r);
  802b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 43 2a 80 00 00 	movabs $0x802a43,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
}
  802b4f:	c9                   	leaveq 
  802b50:	c3                   	retq   

0000000000802b51 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b51:	55                   	push   %rbp
  802b52:	48 89 e5             	mov    %rsp,%rbp
  802b55:	48 83 ec 20          	sub    $0x20,%rsp
  802b59:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b60:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b66:	89 c7                	mov    %eax,%edi
  802b68:	48 b8 ec 29 80 00 00 	movabs $0x8029ec,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
  802b74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b7b:	79 05                	jns    802b82 <bind+0x31>
		return r;
  802b7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b80:	eb 1b                	jmp    802b9d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802b82:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b85:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802b89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8c:	48 89 ce             	mov    %rcx,%rsi
  802b8f:	89 c7                	mov    %eax,%edi
  802b91:	48 b8 ac 2e 80 00 00 	movabs $0x802eac,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
}
  802b9d:	c9                   	leaveq 
  802b9e:	c3                   	retq   

0000000000802b9f <shutdown>:

int
shutdown(int s, int how)
{
  802b9f:	55                   	push   %rbp
  802ba0:	48 89 e5             	mov    %rsp,%rbp
  802ba3:	48 83 ec 20          	sub    $0x20,%rsp
  802ba7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802baa:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb0:	89 c7                	mov    %eax,%edi
  802bb2:	48 b8 ec 29 80 00 00 	movabs $0x8029ec,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
  802bbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc5:	79 05                	jns    802bcc <shutdown+0x2d>
		return r;
  802bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bca:	eb 16                	jmp    802be2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802bcc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802bcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd2:	89 d6                	mov    %edx,%esi
  802bd4:	89 c7                	mov    %eax,%edi
  802bd6:	48 b8 10 2f 80 00 00 	movabs $0x802f10,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
}
  802be2:	c9                   	leaveq 
  802be3:	c3                   	retq   

0000000000802be4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802be4:	55                   	push   %rbp
  802be5:	48 89 e5             	mov    %rsp,%rbp
  802be8:	48 83 ec 10          	sub    $0x10,%rsp
  802bec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bf4:	48 89 c7             	mov    %rax,%rdi
  802bf7:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
  802c03:	83 f8 01             	cmp    $0x1,%eax
  802c06:	75 17                	jne    802c1f <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c0c:	8b 40 0c             	mov    0xc(%rax),%eax
  802c0f:	89 c7                	mov    %eax,%edi
  802c11:	48 b8 50 2f 80 00 00 	movabs $0x802f50,%rax
  802c18:	00 00 00 
  802c1b:	ff d0                	callq  *%rax
  802c1d:	eb 05                	jmp    802c24 <devsock_close+0x40>
	else
		return 0;
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c24:	c9                   	leaveq 
  802c25:	c3                   	retq   

0000000000802c26 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802c26:	55                   	push   %rbp
  802c27:	48 89 e5             	mov    %rsp,%rbp
  802c2a:	48 83 ec 20          	sub    $0x20,%rsp
  802c2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c35:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c3b:	89 c7                	mov    %eax,%edi
  802c3d:	48 b8 ec 29 80 00 00 	movabs $0x8029ec,%rax
  802c44:	00 00 00 
  802c47:	ff d0                	callq  *%rax
  802c49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c50:	79 05                	jns    802c57 <connect+0x31>
		return r;
  802c52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c55:	eb 1b                	jmp    802c72 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802c57:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c5a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c61:	48 89 ce             	mov    %rcx,%rsi
  802c64:	89 c7                	mov    %eax,%edi
  802c66:	48 b8 7d 2f 80 00 00 	movabs $0x802f7d,%rax
  802c6d:	00 00 00 
  802c70:	ff d0                	callq  *%rax
}
  802c72:	c9                   	leaveq 
  802c73:	c3                   	retq   

0000000000802c74 <listen>:

int
listen(int s, int backlog)
{
  802c74:	55                   	push   %rbp
  802c75:	48 89 e5             	mov    %rsp,%rbp
  802c78:	48 83 ec 20          	sub    $0x20,%rsp
  802c7c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c7f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c85:	89 c7                	mov    %eax,%edi
  802c87:	48 b8 ec 29 80 00 00 	movabs $0x8029ec,%rax
  802c8e:	00 00 00 
  802c91:	ff d0                	callq  *%rax
  802c93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9a:	79 05                	jns    802ca1 <listen+0x2d>
		return r;
  802c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9f:	eb 16                	jmp    802cb7 <listen+0x43>
	return nsipc_listen(r, backlog);
  802ca1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca7:	89 d6                	mov    %edx,%esi
  802ca9:	89 c7                	mov    %eax,%edi
  802cab:	48 b8 e1 2f 80 00 00 	movabs $0x802fe1,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
}
  802cb7:	c9                   	leaveq 
  802cb8:	c3                   	retq   

0000000000802cb9 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802cb9:	55                   	push   %rbp
  802cba:	48 89 e5             	mov    %rsp,%rbp
  802cbd:	48 83 ec 20          	sub    $0x20,%rsp
  802cc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cc5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802cc9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802ccd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd1:	89 c2                	mov    %eax,%edx
  802cd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd7:	8b 40 0c             	mov    0xc(%rax),%eax
  802cda:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802cde:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ce3:	89 c7                	mov    %eax,%edi
  802ce5:	48 b8 21 30 80 00 00 	movabs $0x803021,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
}
  802cf1:	c9                   	leaveq 
  802cf2:	c3                   	retq   

0000000000802cf3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802cf3:	55                   	push   %rbp
  802cf4:	48 89 e5             	mov    %rsp,%rbp
  802cf7:	48 83 ec 20          	sub    $0x20,%rsp
  802cfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802cff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d03:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0b:	89 c2                	mov    %eax,%edx
  802d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d11:	8b 40 0c             	mov    0xc(%rax),%eax
  802d14:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d1d:	89 c7                	mov    %eax,%edi
  802d1f:	48 b8 ed 30 80 00 00 	movabs $0x8030ed,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
}
  802d2b:	c9                   	leaveq 
  802d2c:	c3                   	retq   

0000000000802d2d <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d2d:	55                   	push   %rbp
  802d2e:	48 89 e5             	mov    %rsp,%rbp
  802d31:	48 83 ec 10          	sub    $0x10,%rsp
  802d35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802d3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d41:	48 be f3 42 80 00 00 	movabs $0x8042f3,%rsi
  802d48:	00 00 00 
  802d4b:	48 89 c7             	mov    %rax,%rdi
  802d4e:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  802d55:	00 00 00 
  802d58:	ff d0                	callq  *%rax
	return 0;
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5f:	c9                   	leaveq 
  802d60:	c3                   	retq   

0000000000802d61 <socket>:

int
socket(int domain, int type, int protocol)
{
  802d61:	55                   	push   %rbp
  802d62:	48 89 e5             	mov    %rsp,%rbp
  802d65:	48 83 ec 20          	sub    $0x20,%rsp
  802d69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d6c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802d6f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802d72:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802d75:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d7b:	89 ce                	mov    %ecx,%esi
  802d7d:	89 c7                	mov    %eax,%edi
  802d7f:	48 b8 a5 31 80 00 00 	movabs $0x8031a5,%rax
  802d86:	00 00 00 
  802d89:	ff d0                	callq  *%rax
  802d8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d92:	79 05                	jns    802d99 <socket+0x38>
		return r;
  802d94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d97:	eb 11                	jmp    802daa <socket+0x49>
	return alloc_sockfd(r);
  802d99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	48 b8 43 2a 80 00 00 	movabs $0x802a43,%rax
  802da5:	00 00 00 
  802da8:	ff d0                	callq  *%rax
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 10          	sub    $0x10,%rsp
  802db4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802db7:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802dbe:	00 00 00 
  802dc1:	8b 00                	mov    (%rax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	75 1d                	jne    802de4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802dc7:	bf 02 00 00 00       	mov    $0x2,%edi
  802dcc:	48 b8 f7 3b 80 00 00 	movabs $0x803bf7,%rax
  802dd3:	00 00 00 
  802dd6:	ff d0                	callq  *%rax
  802dd8:	48 ba 2c 70 80 00 00 	movabs $0x80702c,%rdx
  802ddf:	00 00 00 
  802de2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802de4:	48 b8 2c 70 80 00 00 	movabs $0x80702c,%rax
  802deb:	00 00 00 
  802dee:	8b 00                	mov    (%rax),%eax
  802df0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802df3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802df8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802dff:	00 00 00 
  802e02:	89 c7                	mov    %eax,%edi
  802e04:	48 b8 34 3b 80 00 00 	movabs $0x803b34,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802e10:	ba 00 00 00 00       	mov    $0x0,%edx
  802e15:	be 00 00 00 00       	mov    $0x0,%esi
  802e1a:	bf 00 00 00 00       	mov    $0x0,%edi
  802e1f:	48 b8 74 3a 80 00 00 	movabs $0x803a74,%rax
  802e26:	00 00 00 
  802e29:	ff d0                	callq  *%rax
}
  802e2b:	c9                   	leaveq 
  802e2c:	c3                   	retq   

0000000000802e2d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802e2d:	55                   	push   %rbp
  802e2e:	48 89 e5             	mov    %rsp,%rbp
  802e31:	48 83 ec 30          	sub    $0x30,%rsp
  802e35:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e3c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802e40:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e47:	00 00 00 
  802e4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802e4d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802e4f:	bf 01 00 00 00       	mov    $0x1,%edi
  802e54:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e67:	78 3e                	js     802ea7 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802e69:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802e70:	00 00 00 
  802e73:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7b:	8b 40 10             	mov    0x10(%rax),%eax
  802e7e:	89 c2                	mov    %eax,%edx
  802e80:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802e84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e88:	48 89 ce             	mov    %rcx,%rsi
  802e8b:	48 89 c7             	mov    %rax,%rdi
  802e8e:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e9e:	8b 50 10             	mov    0x10(%rax),%edx
  802ea1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea5:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802eaa:	c9                   	leaveq 
  802eab:	c3                   	retq   

0000000000802eac <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802eac:	55                   	push   %rbp
  802ead:	48 89 e5             	mov    %rsp,%rbp
  802eb0:	48 83 ec 10          	sub    $0x10,%rsp
  802eb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802eb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ebb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802ebe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ec5:	00 00 00 
  802ec8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ecb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802ecd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ed4:	48 89 c6             	mov    %rax,%rsi
  802ed7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802ede:	00 00 00 
  802ee1:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802ee8:	00 00 00 
  802eeb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802eed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ef4:	00 00 00 
  802ef7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802efa:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802efd:	bf 02 00 00 00       	mov    $0x2,%edi
  802f02:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
}
  802f0e:	c9                   	leaveq 
  802f0f:	c3                   	retq   

0000000000802f10 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802f10:	55                   	push   %rbp
  802f11:	48 89 e5             	mov    %rsp,%rbp
  802f14:	48 83 ec 10          	sub    $0x10,%rsp
  802f18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f1b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  802f1e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f25:	00 00 00 
  802f28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f2b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  802f2d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f34:	00 00 00 
  802f37:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802f3a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  802f3d:	bf 03 00 00 00       	mov    $0x3,%edi
  802f42:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802f49:	00 00 00 
  802f4c:	ff d0                	callq  *%rax
}
  802f4e:	c9                   	leaveq 
  802f4f:	c3                   	retq   

0000000000802f50 <nsipc_close>:

int
nsipc_close(int s)
{
  802f50:	55                   	push   %rbp
  802f51:	48 89 e5             	mov    %rsp,%rbp
  802f54:	48 83 ec 10          	sub    $0x10,%rsp
  802f58:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802f5b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f62:	00 00 00 
  802f65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f68:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802f6a:	bf 04 00 00 00       	mov    $0x4,%edi
  802f6f:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802f76:	00 00 00 
  802f79:	ff d0                	callq  *%rax
}
  802f7b:	c9                   	leaveq 
  802f7c:	c3                   	retq   

0000000000802f7d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802f7d:	55                   	push   %rbp
  802f7e:	48 89 e5             	mov    %rsp,%rbp
  802f81:	48 83 ec 10          	sub    $0x10,%rsp
  802f85:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f8c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  802f8f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f96:	00 00 00 
  802f99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802f9c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802f9e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa5:	48 89 c6             	mov    %rax,%rsi
  802fa8:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802faf:	00 00 00 
  802fb2:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802fb9:	00 00 00 
  802fbc:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  802fbe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc5:	00 00 00 
  802fc8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fcb:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  802fce:	bf 05 00 00 00       	mov    $0x5,%edi
  802fd3:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
}
  802fdf:	c9                   	leaveq 
  802fe0:	c3                   	retq   

0000000000802fe1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802fe1:	55                   	push   %rbp
  802fe2:	48 89 e5             	mov    %rsp,%rbp
  802fe5:	48 83 ec 10          	sub    $0x10,%rsp
  802fe9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fec:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  802fef:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ff6:	00 00 00 
  802ff9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ffc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  802ffe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803005:	00 00 00 
  803008:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80300e:	bf 06 00 00 00       	mov    $0x6,%edi
  803013:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  80301a:	00 00 00 
  80301d:	ff d0                	callq  *%rax
}
  80301f:	c9                   	leaveq 
  803020:	c3                   	retq   

0000000000803021 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803021:	55                   	push   %rbp
  803022:	48 89 e5             	mov    %rsp,%rbp
  803025:	48 83 ec 30          	sub    $0x30,%rsp
  803029:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80302c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803030:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803033:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803036:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80303d:	00 00 00 
  803040:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803043:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803045:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80304c:	00 00 00 
  80304f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803052:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803055:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305c:	00 00 00 
  80305f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803062:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803065:	bf 07 00 00 00       	mov    $0x7,%edi
  80306a:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
  803076:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80307d:	78 69                	js     8030e8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80307f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803086:	7f 08                	jg     803090 <nsipc_recv+0x6f>
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80308e:	7e 35                	jle    8030c5 <nsipc_recv+0xa4>
  803090:	48 b9 fa 42 80 00 00 	movabs $0x8042fa,%rcx
  803097:	00 00 00 
  80309a:	48 ba 0f 43 80 00 00 	movabs $0x80430f,%rdx
  8030a1:	00 00 00 
  8030a4:	be 61 00 00 00       	mov    $0x61,%esi
  8030a9:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  8030b0:	00 00 00 
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b8:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  8030bf:	00 00 00 
  8030c2:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8030c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c8:	48 63 d0             	movslq %eax,%rdx
  8030cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030cf:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8030d6:	00 00 00 
  8030d9:	48 89 c7             	mov    %rax,%rdi
  8030dc:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
	}

	return r;
  8030e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030eb:	c9                   	leaveq 
  8030ec:	c3                   	retq   

00000000008030ed <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8030ed:	55                   	push   %rbp
  8030ee:	48 89 e5             	mov    %rsp,%rbp
  8030f1:	48 83 ec 20          	sub    $0x20,%rsp
  8030f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030fc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8030ff:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803102:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803109:	00 00 00 
  80310c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80310f:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803111:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803118:	7e 35                	jle    80314f <nsipc_send+0x62>
  80311a:	48 b9 30 43 80 00 00 	movabs $0x804330,%rcx
  803121:	00 00 00 
  803124:	48 ba 0f 43 80 00 00 	movabs $0x80430f,%rdx
  80312b:	00 00 00 
  80312e:	be 6c 00 00 00       	mov    $0x6c,%esi
  803133:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  80313a:	00 00 00 
  80313d:	b8 00 00 00 00       	mov    $0x0,%eax
  803142:	49 b8 74 02 80 00 00 	movabs $0x800274,%r8
  803149:	00 00 00 
  80314c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80314f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803152:	48 63 d0             	movslq %eax,%rdx
  803155:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803159:	48 89 c6             	mov    %rax,%rsi
  80315c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803163:	00 00 00 
  803166:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  80316d:	00 00 00 
  803170:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803172:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803179:	00 00 00 
  80317c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80317f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803182:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803189:	00 00 00 
  80318c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80318f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803192:	bf 08 00 00 00       	mov    $0x8,%edi
  803197:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
}
  8031a3:	c9                   	leaveq 
  8031a4:	c3                   	retq   

00000000008031a5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8031a5:	55                   	push   %rbp
  8031a6:	48 89 e5             	mov    %rsp,%rbp
  8031a9:	48 83 ec 10          	sub    $0x10,%rsp
  8031ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031b0:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8031b3:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8031b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031bd:	00 00 00 
  8031c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031c3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8031c5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031cc:	00 00 00 
  8031cf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8031d5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8031dc:	00 00 00 
  8031df:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8031e2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8031e5:	bf 09 00 00 00       	mov    $0x9,%edi
  8031ea:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
}
  8031f6:	c9                   	leaveq 
  8031f7:	c3                   	retq   

00000000008031f8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031f8:	55                   	push   %rbp
  8031f9:	48 89 e5             	mov    %rsp,%rbp
  8031fc:	53                   	push   %rbx
  8031fd:	48 83 ec 38          	sub    $0x38,%rsp
  803201:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803205:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803209:	48 89 c7             	mov    %rax,%rdi
  80320c:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  803213:	00 00 00 
  803216:	ff d0                	callq  *%rax
  803218:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80321b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80321f:	0f 88 bf 01 00 00    	js     8033e4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803229:	ba 07 04 00 00       	mov    $0x407,%edx
  80322e:	48 89 c6             	mov    %rax,%rsi
  803231:	bf 00 00 00 00       	mov    $0x0,%edi
  803236:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803245:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803249:	0f 88 95 01 00 00    	js     8033e4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80324f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803253:	48 89 c7             	mov    %rax,%rdi
  803256:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
  803262:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803265:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803269:	0f 88 5d 01 00 00    	js     8033cc <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80326f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803273:	ba 07 04 00 00       	mov    $0x407,%edx
  803278:	48 89 c6             	mov    %rax,%rsi
  80327b:	bf 00 00 00 00       	mov    $0x0,%edi
  803280:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80328f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803293:	0f 88 33 01 00 00    	js     8033cc <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803299:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329d:	48 89 c7             	mov    %rax,%rdi
  8032a0:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8032a7:	00 00 00 
  8032aa:	ff d0                	callq  *%rax
  8032ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032b9:	48 89 c6             	mov    %rax,%rsi
  8032bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c1:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  8032c8:	00 00 00 
  8032cb:	ff d0                	callq  *%rax
  8032cd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032d4:	0f 88 d9 00 00 00    	js     8033b3 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8032da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032de:	48 89 c7             	mov    %rax,%rdi
  8032e1:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	48 89 c2             	mov    %rax,%rdx
  8032f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8032fa:	48 89 d1             	mov    %rdx,%rcx
  8032fd:	ba 00 00 00 00       	mov    $0x0,%edx
  803302:	48 89 c6             	mov    %rax,%rsi
  803305:	bf 00 00 00 00       	mov    $0x0,%edi
  80330a:	48 b8 f4 19 80 00 00 	movabs $0x8019f4,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
  803316:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803319:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80331d:	78 79                	js     803398 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80331f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803323:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80332a:	00 00 00 
  80332d:	8b 12                	mov    (%rdx),%edx
  80332f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803331:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803335:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80333c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803340:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803347:	00 00 00 
  80334a:	8b 12                	mov    (%rdx),%edx
  80334c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80334e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803352:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80335d:	48 89 c7             	mov    %rax,%rdi
  803360:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	89 c2                	mov    %eax,%edx
  80336e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803372:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803374:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803378:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80337c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803380:	48 89 c7             	mov    %rax,%rdi
  803383:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  80338a:	00 00 00 
  80338d:	ff d0                	callq  *%rax
  80338f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803391:	b8 00 00 00 00       	mov    $0x0,%eax
  803396:	eb 4f                	jmp    8033e7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803398:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803399:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80339d:	48 89 c6             	mov    %rax,%rsi
  8033a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a5:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
  8033b1:	eb 01                	jmp    8033b4 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8033b3:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8033b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033b8:	48 89 c6             	mov    %rax,%rsi
  8033bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8033c0:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8033cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d0:	48 89 c6             	mov    %rax,%rsi
  8033d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033d8:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8033df:	00 00 00 
  8033e2:	ff d0                	callq  *%rax
    err:
	return r;
  8033e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8033e7:	48 83 c4 38          	add    $0x38,%rsp
  8033eb:	5b                   	pop    %rbx
  8033ec:	5d                   	pop    %rbp
  8033ed:	c3                   	retq   

00000000008033ee <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8033ee:	55                   	push   %rbp
  8033ef:	48 89 e5             	mov    %rsp,%rbp
  8033f2:	53                   	push   %rbx
  8033f3:	48 83 ec 28          	sub    $0x28,%rsp
  8033f7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033fb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033ff:	eb 01                	jmp    803402 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803401:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803402:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803409:	00 00 00 
  80340c:	48 8b 00             	mov    (%rax),%rax
  80340f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803415:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341c:	48 89 c7             	mov    %rax,%rdi
  80341f:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  803426:	00 00 00 
  803429:	ff d0                	callq  *%rax
  80342b:	89 c3                	mov    %eax,%ebx
  80342d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803431:	48 89 c7             	mov    %rax,%rdi
  803434:	48 b8 7c 3c 80 00 00 	movabs $0x803c7c,%rax
  80343b:	00 00 00 
  80343e:	ff d0                	callq  *%rax
  803440:	39 c3                	cmp    %eax,%ebx
  803442:	0f 94 c0             	sete   %al
  803445:	0f b6 c0             	movzbl %al,%eax
  803448:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80344b:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803452:	00 00 00 
  803455:	48 8b 00             	mov    (%rax),%rax
  803458:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80345e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803464:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803467:	75 0a                	jne    803473 <_pipeisclosed+0x85>
			return ret;
  803469:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80346c:	48 83 c4 28          	add    $0x28,%rsp
  803470:	5b                   	pop    %rbx
  803471:	5d                   	pop    %rbp
  803472:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803473:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803476:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803479:	74 86                	je     803401 <_pipeisclosed+0x13>
  80347b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80347f:	75 80                	jne    803401 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803481:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803488:	00 00 00 
  80348b:	48 8b 00             	mov    (%rax),%rax
  80348e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803494:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803497:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80349a:	89 c6                	mov    %eax,%esi
  80349c:	48 bf 41 43 80 00 00 	movabs $0x804341,%rdi
  8034a3:	00 00 00 
  8034a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ab:	49 b8 af 04 80 00 00 	movabs $0x8004af,%r8
  8034b2:	00 00 00 
  8034b5:	41 ff d0             	callq  *%r8
	}
  8034b8:	e9 44 ff ff ff       	jmpq   803401 <_pipeisclosed+0x13>

00000000008034bd <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8034bd:	55                   	push   %rbp
  8034be:	48 89 e5             	mov    %rsp,%rbp
  8034c1:	48 83 ec 30          	sub    $0x30,%rsp
  8034c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8034c8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8034cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8034cf:	48 89 d6             	mov    %rdx,%rsi
  8034d2:	89 c7                	mov    %eax,%edi
  8034d4:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
  8034e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e7:	79 05                	jns    8034ee <pipeisclosed+0x31>
		return r;
  8034e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ec:	eb 31                	jmp    80351f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8034ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f2:	48 89 c7             	mov    %rax,%rdi
  8034f5:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8034fc:	00 00 00 
  8034ff:	ff d0                	callq  *%rax
  803501:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803509:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80350d:	48 89 d6             	mov    %rdx,%rsi
  803510:	48 89 c7             	mov    %rax,%rdi
  803513:	48 b8 ee 33 80 00 00 	movabs $0x8033ee,%rax
  80351a:	00 00 00 
  80351d:	ff d0                	callq  *%rax
}
  80351f:	c9                   	leaveq 
  803520:	c3                   	retq   

0000000000803521 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803521:	55                   	push   %rbp
  803522:	48 89 e5             	mov    %rsp,%rbp
  803525:	48 83 ec 40          	sub    $0x40,%rsp
  803529:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80352d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803531:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803539:	48 89 c7             	mov    %rax,%rdi
  80353c:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  803543:	00 00 00 
  803546:	ff d0                	callq  *%rax
  803548:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80354c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803550:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803554:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80355b:	00 
  80355c:	e9 97 00 00 00       	jmpq   8035f8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803561:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803566:	74 09                	je     803571 <devpipe_read+0x50>
				return i;
  803568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356c:	e9 95 00 00 00       	jmpq   803606 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803571:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803579:	48 89 d6             	mov    %rdx,%rsi
  80357c:	48 89 c7             	mov    %rax,%rdi
  80357f:	48 b8 ee 33 80 00 00 	movabs $0x8033ee,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	74 07                	je     803596 <devpipe_read+0x75>
				return 0;
  80358f:	b8 00 00 00 00       	mov    $0x0,%eax
  803594:	eb 70                	jmp    803606 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803596:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  80359d:	00 00 00 
  8035a0:	ff d0                	callq  *%rax
  8035a2:	eb 01                	jmp    8035a5 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8035a4:	90                   	nop
  8035a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a9:	8b 10                	mov    (%rax),%edx
  8035ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035af:	8b 40 04             	mov    0x4(%rax),%eax
  8035b2:	39 c2                	cmp    %eax,%edx
  8035b4:	74 ab                	je     803561 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8035b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035be:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8035c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c6:	8b 00                	mov    (%rax),%eax
  8035c8:	89 c2                	mov    %eax,%edx
  8035ca:	c1 fa 1f             	sar    $0x1f,%edx
  8035cd:	c1 ea 1b             	shr    $0x1b,%edx
  8035d0:	01 d0                	add    %edx,%eax
  8035d2:	83 e0 1f             	and    $0x1f,%eax
  8035d5:	29 d0                	sub    %edx,%eax
  8035d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035db:	48 98                	cltq   
  8035dd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8035e2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8035e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e8:	8b 00                	mov    (%rax),%eax
  8035ea:	8d 50 01             	lea    0x1(%rax),%edx
  8035ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035f1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035f3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035fc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803600:	72 a2                	jb     8035a4 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803606:	c9                   	leaveq 
  803607:	c3                   	retq   

0000000000803608 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803608:	55                   	push   %rbp
  803609:	48 89 e5             	mov    %rsp,%rbp
  80360c:	48 83 ec 40          	sub    $0x40,%rsp
  803610:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803614:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803618:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80361c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803620:	48 89 c7             	mov    %rax,%rdi
  803623:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  80362a:	00 00 00 
  80362d:	ff d0                	callq  *%rax
  80362f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803633:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803637:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80363b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803642:	00 
  803643:	e9 93 00 00 00       	jmpq   8036db <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803648:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80364c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803650:	48 89 d6             	mov    %rdx,%rsi
  803653:	48 89 c7             	mov    %rax,%rdi
  803656:	48 b8 ee 33 80 00 00 	movabs $0x8033ee,%rax
  80365d:	00 00 00 
  803660:	ff d0                	callq  *%rax
  803662:	85 c0                	test   %eax,%eax
  803664:	74 07                	je     80366d <devpipe_write+0x65>
				return 0;
  803666:	b8 00 00 00 00       	mov    $0x0,%eax
  80366b:	eb 7c                	jmp    8036e9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80366d:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  803674:	00 00 00 
  803677:	ff d0                	callq  *%rax
  803679:	eb 01                	jmp    80367c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80367b:	90                   	nop
  80367c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803680:	8b 40 04             	mov    0x4(%rax),%eax
  803683:	48 63 d0             	movslq %eax,%rdx
  803686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80368a:	8b 00                	mov    (%rax),%eax
  80368c:	48 98                	cltq   
  80368e:	48 83 c0 20          	add    $0x20,%rax
  803692:	48 39 c2             	cmp    %rax,%rdx
  803695:	73 b1                	jae    803648 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80369b:	8b 40 04             	mov    0x4(%rax),%eax
  80369e:	89 c2                	mov    %eax,%edx
  8036a0:	c1 fa 1f             	sar    $0x1f,%edx
  8036a3:	c1 ea 1b             	shr    $0x1b,%edx
  8036a6:	01 d0                	add    %edx,%eax
  8036a8:	83 e0 1f             	and    $0x1f,%eax
  8036ab:	29 d0                	sub    %edx,%eax
  8036ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036b1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8036b5:	48 01 ca             	add    %rcx,%rdx
  8036b8:	0f b6 0a             	movzbl (%rdx),%ecx
  8036bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036bf:	48 98                	cltq   
  8036c1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8036c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c9:	8b 40 04             	mov    0x4(%rax),%eax
  8036cc:	8d 50 01             	lea    0x1(%rax),%edx
  8036cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036df:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036e3:	72 96                	jb     80367b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8036e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036e9:	c9                   	leaveq 
  8036ea:	c3                   	retq   

00000000008036eb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8036eb:	55                   	push   %rbp
  8036ec:	48 89 e5             	mov    %rsp,%rbp
  8036ef:	48 83 ec 20          	sub    $0x20,%rsp
  8036f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8036fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ff:	48 89 c7             	mov    %rax,%rdi
  803702:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  803709:	00 00 00 
  80370c:	ff d0                	callq  *%rax
  80370e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803712:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803716:	48 be 54 43 80 00 00 	movabs $0x804354,%rsi
  80371d:	00 00 00 
  803720:	48 89 c7             	mov    %rax,%rdi
  803723:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  80372a:	00 00 00 
  80372d:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80372f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803733:	8b 50 04             	mov    0x4(%rax),%edx
  803736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80373a:	8b 00                	mov    (%rax),%eax
  80373c:	29 c2                	sub    %eax,%edx
  80373e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803742:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803748:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80374c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803753:	00 00 00 
	stat->st_dev = &devpipe;
  803756:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80375a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803761:	00 00 00 
  803764:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80376b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803770:	c9                   	leaveq 
  803771:	c3                   	retq   

0000000000803772 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803772:	55                   	push   %rbp
  803773:	48 89 e5             	mov    %rsp,%rbp
  803776:	48 83 ec 10          	sub    $0x10,%rsp
  80377a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80377e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803782:	48 89 c6             	mov    %rax,%rsi
  803785:	bf 00 00 00 00       	mov    $0x0,%edi
  80378a:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80379a:	48 89 c7             	mov    %rax,%rdi
  80379d:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  8037a4:	00 00 00 
  8037a7:	ff d0                	callq  *%rax
  8037a9:	48 89 c6             	mov    %rax,%rsi
  8037ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b1:	48 b8 4f 1a 80 00 00 	movabs $0x801a4f,%rax
  8037b8:	00 00 00 
  8037bb:	ff d0                	callq  *%rax
}
  8037bd:	c9                   	leaveq 
  8037be:	c3                   	retq   
	...

00000000008037c0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8037c0:	55                   	push   %rbp
  8037c1:	48 89 e5             	mov    %rsp,%rbp
  8037c4:	48 83 ec 20          	sub    $0x20,%rsp
  8037c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8037cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ce:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8037d1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8037d5:	be 01 00 00 00       	mov    $0x1,%esi
  8037da:	48 89 c7             	mov    %rax,%rdi
  8037dd:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
}
  8037e9:	c9                   	leaveq 
  8037ea:	c3                   	retq   

00000000008037eb <getchar>:

int
getchar(void)
{
  8037eb:	55                   	push   %rbp
  8037ec:	48 89 e5             	mov    %rsp,%rbp
  8037ef:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8037f3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8037f7:	ba 01 00 00 00       	mov    $0x1,%edx
  8037fc:	48 89 c6             	mov    %rax,%rsi
  8037ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803804:	48 b8 fc 21 80 00 00 	movabs $0x8021fc,%rax
  80380b:	00 00 00 
  80380e:	ff d0                	callq  *%rax
  803810:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803813:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803817:	79 05                	jns    80381e <getchar+0x33>
		return r;
  803819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381c:	eb 14                	jmp    803832 <getchar+0x47>
	if (r < 1)
  80381e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803822:	7f 07                	jg     80382b <getchar+0x40>
		return -E_EOF;
  803824:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803829:	eb 07                	jmp    803832 <getchar+0x47>
	return c;
  80382b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80382f:	0f b6 c0             	movzbl %al,%eax
}
  803832:	c9                   	leaveq 
  803833:	c3                   	retq   

0000000000803834 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803834:	55                   	push   %rbp
  803835:	48 89 e5             	mov    %rsp,%rbp
  803838:	48 83 ec 20          	sub    $0x20,%rsp
  80383c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80383f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803843:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803846:	48 89 d6             	mov    %rdx,%rsi
  803849:	89 c7                	mov    %eax,%edi
  80384b:	48 b8 ca 1d 80 00 00 	movabs $0x801dca,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80385a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80385e:	79 05                	jns    803865 <iscons+0x31>
		return r;
  803860:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803863:	eb 1a                	jmp    80387f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803865:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803869:	8b 10                	mov    (%rax),%edx
  80386b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803872:	00 00 00 
  803875:	8b 00                	mov    (%rax),%eax
  803877:	39 c2                	cmp    %eax,%edx
  803879:	0f 94 c0             	sete   %al
  80387c:	0f b6 c0             	movzbl %al,%eax
}
  80387f:	c9                   	leaveq 
  803880:	c3                   	retq   

0000000000803881 <opencons>:

int
opencons(void)
{
  803881:	55                   	push   %rbp
  803882:	48 89 e5             	mov    %rsp,%rbp
  803885:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803889:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 32 1d 80 00 00 	movabs $0x801d32,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
  80389c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80389f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038a3:	79 05                	jns    8038aa <opencons+0x29>
		return r;
  8038a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a8:	eb 5b                	jmp    803905 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8038aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ae:	ba 07 04 00 00       	mov    $0x407,%edx
  8038b3:	48 89 c6             	mov    %rax,%rsi
  8038b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8038bb:	48 b8 a4 19 80 00 00 	movabs $0x8019a4,%rax
  8038c2:	00 00 00 
  8038c5:	ff d0                	callq  *%rax
  8038c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038ce:	79 05                	jns    8038d5 <opencons+0x54>
		return r;
  8038d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d3:	eb 30                	jmp    803905 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8038d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8038e0:	00 00 00 
  8038e3:	8b 12                	mov    (%rdx),%edx
  8038e5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8038e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8038f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f6:	48 89 c7             	mov    %rax,%rdi
  8038f9:	48 b8 e4 1c 80 00 00 	movabs $0x801ce4,%rax
  803900:	00 00 00 
  803903:	ff d0                	callq  *%rax
}
  803905:	c9                   	leaveq 
  803906:	c3                   	retq   

0000000000803907 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803907:	55                   	push   %rbp
  803908:	48 89 e5             	mov    %rsp,%rbp
  80390b:	48 83 ec 30          	sub    $0x30,%rsp
  80390f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803913:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803917:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80391b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803920:	75 13                	jne    803935 <devcons_read+0x2e>
		return 0;
  803922:	b8 00 00 00 00       	mov    $0x0,%eax
  803927:	eb 49                	jmp    803972 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803929:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803935:	48 b8 a6 18 80 00 00 	movabs $0x8018a6,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
  803941:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803948:	74 df                	je     803929 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80394a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394e:	79 05                	jns    803955 <devcons_read+0x4e>
		return c;
  803950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803953:	eb 1d                	jmp    803972 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803955:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803959:	75 07                	jne    803962 <devcons_read+0x5b>
		return 0;
  80395b:	b8 00 00 00 00       	mov    $0x0,%eax
  803960:	eb 10                	jmp    803972 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803962:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803965:	89 c2                	mov    %eax,%edx
  803967:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80396b:	88 10                	mov    %dl,(%rax)
	return 1;
  80396d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803972:	c9                   	leaveq 
  803973:	c3                   	retq   

0000000000803974 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803974:	55                   	push   %rbp
  803975:	48 89 e5             	mov    %rsp,%rbp
  803978:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80397f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803986:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80398d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803994:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80399b:	eb 77                	jmp    803a14 <devcons_write+0xa0>
		m = n - tot;
  80399d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8039a4:	89 c2                	mov    %eax,%edx
  8039a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a9:	89 d1                	mov    %edx,%ecx
  8039ab:	29 c1                	sub    %eax,%ecx
  8039ad:	89 c8                	mov    %ecx,%eax
  8039af:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8039b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b5:	83 f8 7f             	cmp    $0x7f,%eax
  8039b8:	76 07                	jbe    8039c1 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8039ba:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8039c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c4:	48 63 d0             	movslq %eax,%rdx
  8039c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ca:	48 98                	cltq   
  8039cc:	48 89 c1             	mov    %rax,%rcx
  8039cf:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8039d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039dd:	48 89 ce             	mov    %rcx,%rsi
  8039e0:	48 89 c7             	mov    %rax,%rdi
  8039e3:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8039ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039f2:	48 63 d0             	movslq %eax,%rdx
  8039f5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8039fc:	48 89 d6             	mov    %rdx,%rsi
  8039ff:	48 89 c7             	mov    %rax,%rdi
  803a02:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  803a09:	00 00 00 
  803a0c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a0e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a11:	01 45 fc             	add    %eax,-0x4(%rbp)
  803a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a17:	48 98                	cltq   
  803a19:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803a20:	0f 82 77 ff ff ff    	jb     80399d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a29:	c9                   	leaveq 
  803a2a:	c3                   	retq   

0000000000803a2b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803a2b:	55                   	push   %rbp
  803a2c:	48 89 e5             	mov    %rsp,%rbp
  803a2f:	48 83 ec 08          	sub    $0x8,%rsp
  803a33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a3c:	c9                   	leaveq 
  803a3d:	c3                   	retq   

0000000000803a3e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803a3e:	55                   	push   %rbp
  803a3f:	48 89 e5             	mov    %rsp,%rbp
  803a42:	48 83 ec 10          	sub    $0x10,%rsp
  803a46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803a4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a52:	48 be 60 43 80 00 00 	movabs $0x804360,%rsi
  803a59:	00 00 00 
  803a5c:	48 89 c7             	mov    %rax,%rdi
  803a5f:	48 b8 6c 10 80 00 00 	movabs $0x80106c,%rax
  803a66:	00 00 00 
  803a69:	ff d0                	callq  *%rax
	return 0;
  803a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a70:	c9                   	leaveq 
  803a71:	c3                   	retq   
	...

0000000000803a74 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a74:	55                   	push   %rbp
  803a75:	48 89 e5             	mov    %rsp,%rbp
  803a78:	48 83 ec 30          	sub    $0x30,%rsp
  803a7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a80:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a84:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803a88:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a8d:	74 18                	je     803aa7 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a93:	48 89 c7             	mov    %rax,%rdi
  803a96:	48 b8 cd 1b 80 00 00 	movabs $0x801bcd,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
  803aa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa5:	eb 19                	jmp    803ac0 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803aa7:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803aae:	00 00 00 
  803ab1:	48 b8 cd 1b 80 00 00 	movabs $0x801bcd,%rax
  803ab8:	00 00 00 
  803abb:	ff d0                	callq  *%rax
  803abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ac4:	79 19                	jns    803adf <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aca:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	eb 53                	jmp    803b32 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803adf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803ae4:	74 19                	je     803aff <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803ae6:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803aed:	00 00 00 
  803af0:	48 8b 00             	mov    (%rax),%rax
  803af3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803af9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803afd:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803aff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803b04:	74 19                	je     803b1f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803b06:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803b0d:	00 00 00 
  803b10:	48 8b 00             	mov    (%rax),%rax
  803b13:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803b1f:	48 b8 40 70 80 00 00 	movabs $0x807040,%rax
  803b26:	00 00 00 
  803b29:	48 8b 00             	mov    (%rax),%rax
  803b2c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803b32:	c9                   	leaveq 
  803b33:	c3                   	retq   

0000000000803b34 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b34:	55                   	push   %rbp
  803b35:	48 89 e5             	mov    %rsp,%rbp
  803b38:	48 83 ec 30          	sub    $0x30,%rsp
  803b3c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b3f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b42:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b46:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803b49:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803b50:	e9 96 00 00 00       	jmpq   803beb <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803b55:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b5a:	74 20                	je     803b7c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803b5c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b5f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b62:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b69:	89 c7                	mov    %eax,%edi
  803b6b:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803b72:	00 00 00 
  803b75:	ff d0                	callq  *%rax
  803b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7a:	eb 2d                	jmp    803ba9 <ipc_send+0x75>
		else if(pg==NULL)
  803b7c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b81:	75 26                	jne    803ba9 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803b83:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b86:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b89:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b8e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b95:	00 00 00 
  803b98:	89 c7                	mov    %eax,%edi
  803b9a:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  803ba1:	00 00 00 
  803ba4:	ff d0                	callq  *%rax
  803ba6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803ba9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bad:	79 30                	jns    803bdf <ipc_send+0xab>
  803baf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803bb3:	74 2a                	je     803bdf <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803bb5:	48 ba 67 43 80 00 00 	movabs $0x804367,%rdx
  803bbc:	00 00 00 
  803bbf:	be 40 00 00 00       	mov    $0x40,%esi
  803bc4:	48 bf 7f 43 80 00 00 	movabs $0x80437f,%rdi
  803bcb:	00 00 00 
  803bce:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd3:	48 b9 74 02 80 00 00 	movabs $0x800274,%rcx
  803bda:	00 00 00 
  803bdd:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803bdf:	48 b8 66 19 80 00 00 	movabs $0x801966,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803beb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bef:	0f 85 60 ff ff ff    	jne    803b55 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803bf5:	c9                   	leaveq 
  803bf6:	c3                   	retq   

0000000000803bf7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803bf7:	55                   	push   %rbp
  803bf8:	48 89 e5             	mov    %rsp,%rbp
  803bfb:	48 83 ec 18          	sub    $0x18,%rsp
  803bff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803c09:	eb 5e                	jmp    803c69 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803c0b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c12:	00 00 00 
  803c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c18:	48 63 d0             	movslq %eax,%rdx
  803c1b:	48 89 d0             	mov    %rdx,%rax
  803c1e:	48 c1 e0 03          	shl    $0x3,%rax
  803c22:	48 01 d0             	add    %rdx,%rax
  803c25:	48 c1 e0 05          	shl    $0x5,%rax
  803c29:	48 01 c8             	add    %rcx,%rax
  803c2c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803c32:	8b 00                	mov    (%rax),%eax
  803c34:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c37:	75 2c                	jne    803c65 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803c39:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803c40:	00 00 00 
  803c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c46:	48 63 d0             	movslq %eax,%rdx
  803c49:	48 89 d0             	mov    %rdx,%rax
  803c4c:	48 c1 e0 03          	shl    $0x3,%rax
  803c50:	48 01 d0             	add    %rdx,%rax
  803c53:	48 c1 e0 05          	shl    $0x5,%rax
  803c57:	48 01 c8             	add    %rcx,%rax
  803c5a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803c60:	8b 40 08             	mov    0x8(%rax),%eax
  803c63:	eb 12                	jmp    803c77 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803c65:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c69:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c70:	7e 99                	jle    803c0b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c77:	c9                   	leaveq 
  803c78:	c3                   	retq   
  803c79:	00 00                	add    %al,(%rax)
	...

0000000000803c7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c7c:	55                   	push   %rbp
  803c7d:	48 89 e5             	mov    %rsp,%rbp
  803c80:	48 83 ec 18          	sub    $0x18,%rsp
  803c84:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c8c:	48 89 c2             	mov    %rax,%rdx
  803c8f:	48 c1 ea 15          	shr    $0x15,%rdx
  803c93:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c9a:	01 00 00 
  803c9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ca1:	83 e0 01             	and    $0x1,%eax
  803ca4:	48 85 c0             	test   %rax,%rax
  803ca7:	75 07                	jne    803cb0 <pageref+0x34>
		return 0;
  803ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cae:	eb 53                	jmp    803d03 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb4:	48 89 c2             	mov    %rax,%rdx
  803cb7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803cbb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cc2:	01 00 00 
  803cc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd1:	83 e0 01             	and    $0x1,%eax
  803cd4:	48 85 c0             	test   %rax,%rax
  803cd7:	75 07                	jne    803ce0 <pageref+0x64>
		return 0;
  803cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cde:	eb 23                	jmp    803d03 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ce0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ce4:	48 89 c2             	mov    %rax,%rdx
  803ce7:	48 c1 ea 0c          	shr    $0xc,%rdx
  803ceb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803cf2:	00 00 00 
  803cf5:	48 c1 e2 04          	shl    $0x4,%rdx
  803cf9:	48 01 d0             	add    %rdx,%rax
  803cfc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803d00:	0f b7 c0             	movzwl %ax,%eax
}
  803d03:	c9                   	leaveq 
  803d04:	c3                   	retq   
