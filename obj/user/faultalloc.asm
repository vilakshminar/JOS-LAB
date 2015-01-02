
obj/user/faultalloc.debug:     file format elf64-x86-64


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
  80003c:	e8 43 01 00 00       	callq  800184 <libmain>
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
  800048:	48 83 ec 30          	sub    $0x30,%rsp
  80004c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800054:	48 8b 00             	mov    (%rax),%rax
  800057:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005f:	48 89 c6             	mov    %rax,%rsi
  800062:	48 bf 40 3e 80 00 00 	movabs $0x803e40,%rdi
  800069:	00 00 00 
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  800078:	00 00 00 
  80007b:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800081:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800085:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800089:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008f:	ba 07 00 00 00       	mov    $0x7,%edx
  800094:	48 89 c6             	mov    %rax,%rsi
  800097:	bf 00 00 00 00       	mov    $0x0,%edi
  80009c:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	callq  *%rax
  8000a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000af:	79 38                	jns    8000e9 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b8:	41 89 d0             	mov    %edx,%r8d
  8000bb:	48 89 c1             	mov    %rax,%rcx
  8000be:	48 ba 50 3e 80 00 00 	movabs $0x803e50,%rdx
  8000c5:	00 00 00 
  8000c8:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cd:	48 bf 7b 3e 80 00 00 	movabs $0x803e7b,%rdi
  8000d4:	00 00 00 
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	49 b9 4c 02 80 00 00 	movabs $0x80024c,%r9
  8000e3:	00 00 00 
  8000e6:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f1:	48 89 d1             	mov    %rdx,%rcx
  8000f4:	48 ba 90 3e 80 00 00 	movabs $0x803e90,%rdx
  8000fb:	00 00 00 
  8000fe:	be 64 00 00 00       	mov    $0x64,%esi
  800103:	48 89 c7             	mov    %rax,%rdi
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	49 b8 f6 0e 80 00 00 	movabs $0x800ef6,%r8
  800112:	00 00 00 
  800115:	41 ff d0             	callq  *%r8
}
  800118:	c9                   	leaveq 
  800119:	c3                   	retq   

000000000080011a <umain>:

void
umain(int argc, char **argv)
{
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
  80011e:	48 83 ec 10          	sub    $0x10,%rsp
  800122:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800125:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800129:	48 bf 44 00 80 00 00 	movabs $0x800044,%rdi
  800130:	00 00 00 
  800133:	48 b8 bc 1c 80 00 00 	movabs $0x801cbc,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013f:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800144:	48 bf b1 3e 80 00 00 	movabs $0x803eb1,%rdi
  80014b:	00 00 00 
  80014e:	b8 00 00 00 00       	mov    $0x0,%eax
  800153:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  80015a:	00 00 00 
  80015d:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015f:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800164:	48 bf b1 3e 80 00 00 	movabs $0x803eb1,%rdi
  80016b:	00 00 00 
  80016e:	b8 00 00 00 00       	mov    $0x0,%eax
  800173:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  80017a:	00 00 00 
  80017d:	ff d2                	callq  *%rdx
}
  80017f:	c9                   	leaveq 
  800180:	c3                   	retq   
  800181:	00 00                	add    %al,(%rax)
	...

0000000000800184 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800184:	55                   	push   %rbp
  800185:	48 89 e5             	mov    %rsp,%rbp
  800188:	48 83 ec 10          	sub    $0x10,%rsp
  80018c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800193:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80019a:	00 00 00 
  80019d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8001a4:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  8001ab:	00 00 00 
  8001ae:	ff d0                	callq  *%rax
  8001b0:	48 98                	cltq   
  8001b2:	48 89 c2             	mov    %rax,%rdx
  8001b5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001bb:	48 89 d0             	mov    %rdx,%rax
  8001be:	48 c1 e0 03          	shl    $0x3,%rax
  8001c2:	48 01 d0             	add    %rdx,%rax
  8001c5:	48 c1 e0 05          	shl    $0x5,%rax
  8001c9:	48 89 c2             	mov    %rax,%rdx
  8001cc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001d3:	00 00 00 
  8001d6:	48 01 c2             	add    %rax,%rdx
  8001d9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001e0:	00 00 00 
  8001e3:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001ea:	7e 14                	jle    800200 <libmain+0x7c>
		binaryname = argv[0];
  8001ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f0:	48 8b 10             	mov    (%rax),%rdx
  8001f3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fa:	00 00 00 
  8001fd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800200:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800204:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800207:	48 89 d6             	mov    %rdx,%rsi
  80020a:	89 c7                	mov    %eax,%edi
  80020c:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800213:	00 00 00 
  800216:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800218:	48 b8 28 02 80 00 00 	movabs $0x800228,%rax
  80021f:	00 00 00 
  800222:	ff d0                	callq  *%rax
}
  800224:	c9                   	leaveq 
  800225:	c3                   	retq   
	...

0000000000800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	55                   	push   %rbp
  800229:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80022c:	48 b8 4d 21 80 00 00 	movabs $0x80214d,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800238:	bf 00 00 00 00       	mov    $0x0,%edi
  80023d:	48 b8 bc 18 80 00 00 	movabs $0x8018bc,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax
}
  800249:	5d                   	pop    %rbp
  80024a:	c3                   	retq   
	...

000000000080024c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024c:	55                   	push   %rbp
  80024d:	48 89 e5             	mov    %rsp,%rbp
  800250:	53                   	push   %rbx
  800251:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800258:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80025f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800265:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80026c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800273:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80027a:	84 c0                	test   %al,%al
  80027c:	74 23                	je     8002a1 <_panic+0x55>
  80027e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800285:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800289:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80028d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800291:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800295:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800299:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80029d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002a1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002a8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002af:	00 00 00 
  8002b2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002b9:	00 00 00 
  8002bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002c7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002dc:	00 00 00 
  8002df:	48 8b 18             	mov    (%rax),%rbx
  8002e2:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
  8002ee:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002f4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002fb:	41 89 c8             	mov    %ecx,%r8d
  8002fe:	48 89 d1             	mov    %rdx,%rcx
  800301:	48 89 da             	mov    %rbx,%rdx
  800304:	89 c6                	mov    %eax,%esi
  800306:	48 bf c0 3e 80 00 00 	movabs $0x803ec0,%rdi
  80030d:	00 00 00 
  800310:	b8 00 00 00 00       	mov    $0x0,%eax
  800315:	49 b9 87 04 80 00 00 	movabs $0x800487,%r9
  80031c:	00 00 00 
  80031f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800322:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800329:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800330:	48 89 d6             	mov    %rdx,%rsi
  800333:	48 89 c7             	mov    %rax,%rdi
  800336:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
	cprintf("\n");
  800342:	48 bf e3 3e 80 00 00 	movabs $0x803ee3,%rdi
  800349:	00 00 00 
  80034c:	b8 00 00 00 00       	mov    $0x0,%eax
  800351:	48 ba 87 04 80 00 00 	movabs $0x800487,%rdx
  800358:	00 00 00 
  80035b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80035d:	cc                   	int3   
  80035e:	eb fd                	jmp    80035d <_panic+0x111>

0000000000800360 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800360:	55                   	push   %rbp
  800361:	48 89 e5             	mov    %rsp,%rbp
  800364:	48 83 ec 10          	sub    $0x10,%rsp
  800368:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80036f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800373:	8b 00                	mov    (%rax),%eax
  800375:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800378:	89 d6                	mov    %edx,%esi
  80037a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80037e:	48 63 d0             	movslq %eax,%rdx
  800381:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800386:	8d 50 01             	lea    0x1(%rax),%edx
  800389:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80038f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800393:	8b 00                	mov    (%rax),%eax
  800395:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039a:	75 2c                	jne    8003c8 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 00                	mov    (%rax),%eax
  8003a2:	48 98                	cltq   
  8003a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a8:	48 83 c2 08          	add    $0x8,%rdx
  8003ac:	48 89 c6             	mov    %rax,%rsi
  8003af:	48 89 d7             	mov    %rdx,%rdi
  8003b2:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
		b->idx = 0;
  8003be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003cc:	8b 40 04             	mov    0x4(%rax),%eax
  8003cf:	8d 50 01             	lea    0x1(%rax),%edx
  8003d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003d9:	c9                   	leaveq 
  8003da:	c3                   	retq   

00000000008003db <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003db:	55                   	push   %rbp
  8003dc:	48 89 e5             	mov    %rsp,%rbp
  8003df:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003e6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003ed:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003f4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003fb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800402:	48 8b 0a             	mov    (%rdx),%rcx
  800405:	48 89 08             	mov    %rcx,(%rax)
  800408:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80040c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800410:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800414:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800418:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80041f:	00 00 00 
	b.cnt = 0;
  800422:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800429:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80042c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800433:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80043a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800441:	48 89 c6             	mov    %rax,%rsi
  800444:	48 bf 60 03 80 00 00 	movabs $0x800360,%rdi
  80044b:	00 00 00 
  80044e:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80045a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800460:	48 98                	cltq   
  800462:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800469:	48 83 c2 08          	add    $0x8,%rdx
  80046d:	48 89 c6             	mov    %rax,%rsi
  800470:	48 89 d7             	mov    %rdx,%rdi
  800473:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  80047a:	00 00 00 
  80047d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80047f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800485:	c9                   	leaveq 
  800486:	c3                   	retq   

0000000000800487 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800487:	55                   	push   %rbp
  800488:	48 89 e5             	mov    %rsp,%rbp
  80048b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800492:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800499:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004a7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004ae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004b5:	84 c0                	test   %al,%al
  8004b7:	74 20                	je     8004d9 <cprintf+0x52>
  8004b9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004bd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004c1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004c5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004c9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004cd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004d1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004d5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004d9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004e0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004e7:	00 00 00 
  8004ea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f1:	00 00 00 
  8004f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004f8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800506:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80050d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800514:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80051b:	48 8b 0a             	mov    (%rdx),%rcx
  80051e:	48 89 08             	mov    %rcx,(%rax)
  800521:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800525:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800529:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80052d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800531:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800538:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80053f:	48 89 d6             	mov    %rdx,%rsi
  800542:	48 89 c7             	mov    %rax,%rdi
  800545:	48 b8 db 03 80 00 00 	movabs $0x8003db,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800557:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80055d:	c9                   	leaveq 
  80055e:	c3                   	retq   
	...

0000000000800560 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800560:	55                   	push   %rbp
  800561:	48 89 e5             	mov    %rsp,%rbp
  800564:	48 83 ec 30          	sub    $0x30,%rsp
  800568:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80056c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800570:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800574:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800577:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80057b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800582:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800586:	77 52                	ja     8005da <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800588:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80058b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80058f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800592:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005a3:	48 89 c2             	mov    %rax,%rdx
  8005a6:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005a9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005ac:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b4:	41 89 f9             	mov    %edi,%r9d
  8005b7:	48 89 c7             	mov    %rax,%rdi
  8005ba:	48 b8 60 05 80 00 00 	movabs $0x800560,%rax
  8005c1:	00 00 00 
  8005c4:	ff d0                	callq  *%rax
  8005c6:	eb 1c                	jmp    8005e4 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005cf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005d3:	48 89 d6             	mov    %rdx,%rsi
  8005d6:	89 c7                	mov    %eax,%edi
  8005d8:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005da:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005de:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005e2:	7f e4                	jg     8005c8 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f0:	48 f7 f1             	div    %rcx
  8005f3:	48 89 d0             	mov    %rdx,%rax
  8005f6:	48 ba c8 40 80 00 00 	movabs $0x8040c8,%rdx
  8005fd:	00 00 00 
  800600:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800604:	0f be c0             	movsbl %al,%eax
  800607:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80060b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80060f:	48 89 d6             	mov    %rdx,%rsi
  800612:	89 c7                	mov    %eax,%edi
  800614:	ff d1                	callq  *%rcx
}
  800616:	c9                   	leaveq 
  800617:	c3                   	retq   

0000000000800618 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800618:	55                   	push   %rbp
  800619:	48 89 e5             	mov    %rsp,%rbp
  80061c:	48 83 ec 20          	sub    $0x20,%rsp
  800620:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800624:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800627:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80062b:	7e 52                	jle    80067f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	8b 00                	mov    (%rax),%eax
  800633:	83 f8 30             	cmp    $0x30,%eax
  800636:	73 24                	jae    80065c <getuint+0x44>
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800644:	8b 00                	mov    (%rax),%eax
  800646:	89 c0                	mov    %eax,%eax
  800648:	48 01 d0             	add    %rdx,%rax
  80064b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064f:	8b 12                	mov    (%rdx),%edx
  800651:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800654:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800658:	89 0a                	mov    %ecx,(%rdx)
  80065a:	eb 17                	jmp    800673 <getuint+0x5b>
  80065c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800660:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800664:	48 89 d0             	mov    %rdx,%rax
  800667:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800673:	48 8b 00             	mov    (%rax),%rax
  800676:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067a:	e9 a3 00 00 00       	jmpq   800722 <getuint+0x10a>
	else if (lflag)
  80067f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800683:	74 4f                	je     8006d4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800689:	8b 00                	mov    (%rax),%eax
  80068b:	83 f8 30             	cmp    $0x30,%eax
  80068e:	73 24                	jae    8006b4 <getuint+0x9c>
  800690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800694:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069c:	8b 00                	mov    (%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 01 d0             	add    %rdx,%rax
  8006a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a7:	8b 12                	mov    (%rdx),%edx
  8006a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b0:	89 0a                	mov    %ecx,(%rdx)
  8006b2:	eb 17                	jmp    8006cb <getuint+0xb3>
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bc:	48 89 d0             	mov    %rdx,%rax
  8006bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cb:	48 8b 00             	mov    (%rax),%rax
  8006ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d2:	eb 4e                	jmp    800722 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d8:	8b 00                	mov    (%rax),%eax
  8006da:	83 f8 30             	cmp    $0x30,%eax
  8006dd:	73 24                	jae    800703 <getuint+0xeb>
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	89 c0                	mov    %eax,%eax
  8006ef:	48 01 d0             	add    %rdx,%rax
  8006f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006f6:	8b 12                	mov    (%rdx),%edx
  8006f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	89 0a                	mov    %ecx,(%rdx)
  800701:	eb 17                	jmp    80071a <getuint+0x102>
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070b:	48 89 d0             	mov    %rdx,%rax
  80070e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800712:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800716:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071a:	8b 00                	mov    (%rax),%eax
  80071c:	89 c0                	mov    %eax,%eax
  80071e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800726:	c9                   	leaveq 
  800727:	c3                   	retq   

0000000000800728 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800728:	55                   	push   %rbp
  800729:	48 89 e5             	mov    %rsp,%rbp
  80072c:	48 83 ec 20          	sub    $0x20,%rsp
  800730:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800734:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800737:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073b:	7e 52                	jle    80078f <getint+0x67>
		x=va_arg(*ap, long long);
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	8b 00                	mov    (%rax),%eax
  800743:	83 f8 30             	cmp    $0x30,%eax
  800746:	73 24                	jae    80076c <getint+0x44>
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800750:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800754:	8b 00                	mov    (%rax),%eax
  800756:	89 c0                	mov    %eax,%eax
  800758:	48 01 d0             	add    %rdx,%rax
  80075b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075f:	8b 12                	mov    (%rdx),%edx
  800761:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800764:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800768:	89 0a                	mov    %ecx,(%rdx)
  80076a:	eb 17                	jmp    800783 <getint+0x5b>
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800774:	48 89 d0             	mov    %rdx,%rax
  800777:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800783:	48 8b 00             	mov    (%rax),%rax
  800786:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078a:	e9 a3 00 00 00       	jmpq   800832 <getint+0x10a>
	else if (lflag)
  80078f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800793:	74 4f                	je     8007e4 <getint+0xbc>
		x=va_arg(*ap, long);
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800799:	8b 00                	mov    (%rax),%eax
  80079b:	83 f8 30             	cmp    $0x30,%eax
  80079e:	73 24                	jae    8007c4 <getint+0x9c>
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ac:	8b 00                	mov    (%rax),%eax
  8007ae:	89 c0                	mov    %eax,%eax
  8007b0:	48 01 d0             	add    %rdx,%rax
  8007b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b7:	8b 12                	mov    (%rdx),%edx
  8007b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c0:	89 0a                	mov    %ecx,(%rdx)
  8007c2:	eb 17                	jmp    8007db <getint+0xb3>
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cc:	48 89 d0             	mov    %rdx,%rax
  8007cf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007db:	48 8b 00             	mov    (%rax),%rax
  8007de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e2:	eb 4e                	jmp    800832 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e8:	8b 00                	mov    (%rax),%eax
  8007ea:	83 f8 30             	cmp    $0x30,%eax
  8007ed:	73 24                	jae    800813 <getint+0xeb>
  8007ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	8b 00                	mov    (%rax),%eax
  8007fd:	89 c0                	mov    %eax,%eax
  8007ff:	48 01 d0             	add    %rdx,%rax
  800802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800806:	8b 12                	mov    (%rdx),%edx
  800808:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	89 0a                	mov    %ecx,(%rdx)
  800811:	eb 17                	jmp    80082a <getint+0x102>
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081b:	48 89 d0             	mov    %rdx,%rax
  80081e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800822:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800826:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082a:	8b 00                	mov    (%rax),%eax
  80082c:	48 98                	cltq   
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800836:	c9                   	leaveq 
  800837:	c3                   	retq   

0000000000800838 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800838:	55                   	push   %rbp
  800839:	48 89 e5             	mov    %rsp,%rbp
  80083c:	41 54                	push   %r12
  80083e:	53                   	push   %rbx
  80083f:	48 83 ec 60          	sub    $0x60,%rsp
  800843:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800847:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80084b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80084f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800853:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800857:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80085b:	48 8b 0a             	mov    (%rdx),%rcx
  80085e:	48 89 08             	mov    %rcx,(%rax)
  800861:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800865:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800869:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80086d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800871:	eb 17                	jmp    80088a <vprintfmt+0x52>
			if (ch == '\0')
  800873:	85 db                	test   %ebx,%ebx
  800875:	0f 84 d7 04 00 00    	je     800d52 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80087b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80087f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800883:	48 89 c6             	mov    %rax,%rsi
  800886:	89 df                	mov    %ebx,%edi
  800888:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80088e:	0f b6 00             	movzbl (%rax),%eax
  800891:	0f b6 d8             	movzbl %al,%ebx
  800894:	83 fb 25             	cmp    $0x25,%ebx
  800897:	0f 95 c0             	setne  %al
  80089a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80089f:	84 c0                	test   %al,%al
  8008a1:	75 d0                	jne    800873 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a3:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008a7:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008ae:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008bc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8008c3:	eb 04                	jmp    8008c9 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8008c5:	90                   	nop
  8008c6:	eb 01                	jmp    8008c9 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8008c8:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008cd:	0f b6 00             	movzbl (%rax),%eax
  8008d0:	0f b6 d8             	movzbl %al,%ebx
  8008d3:	89 d8                	mov    %ebx,%eax
  8008d5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008da:	83 e8 23             	sub    $0x23,%eax
  8008dd:	83 f8 55             	cmp    $0x55,%eax
  8008e0:	0f 87 38 04 00 00    	ja     800d1e <vprintfmt+0x4e6>
  8008e6:	89 c0                	mov    %eax,%eax
  8008e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ef:	00 
  8008f0:	48 b8 f0 40 80 00 00 	movabs $0x8040f0,%rax
  8008f7:	00 00 00 
  8008fa:	48 01 d0             	add    %rdx,%rax
  8008fd:	48 8b 00             	mov    (%rax),%rax
  800900:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800902:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800906:	eb c1                	jmp    8008c9 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800908:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80090c:	eb bb                	jmp    8008c9 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800915:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800918:	89 d0                	mov    %edx,%eax
  80091a:	c1 e0 02             	shl    $0x2,%eax
  80091d:	01 d0                	add    %edx,%eax
  80091f:	01 c0                	add    %eax,%eax
  800921:	01 d8                	add    %ebx,%eax
  800923:	83 e8 30             	sub    $0x30,%eax
  800926:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800929:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092d:	0f b6 00             	movzbl (%rax),%eax
  800930:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800933:	83 fb 2f             	cmp    $0x2f,%ebx
  800936:	7e 63                	jle    80099b <vprintfmt+0x163>
  800938:	83 fb 39             	cmp    $0x39,%ebx
  80093b:	7f 5e                	jg     80099b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800942:	eb d1                	jmp    800915 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800944:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800947:	83 f8 30             	cmp    $0x30,%eax
  80094a:	73 17                	jae    800963 <vprintfmt+0x12b>
  80094c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800950:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800953:	89 c0                	mov    %eax,%eax
  800955:	48 01 d0             	add    %rdx,%rax
  800958:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095b:	83 c2 08             	add    $0x8,%edx
  80095e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x13a>
  800963:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800967:	48 89 d0             	mov    %rdx,%rax
  80096a:	48 83 c2 08          	add    $0x8,%rdx
  80096e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800972:	8b 00                	mov    (%rax),%eax
  800974:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800977:	eb 23                	jmp    80099c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800979:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097d:	0f 89 42 ff ff ff    	jns    8008c5 <vprintfmt+0x8d>
				width = 0;
  800983:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80098a:	e9 36 ff ff ff       	jmpq   8008c5 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  80098f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800996:	e9 2e ff ff ff       	jmpq   8008c9 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80099b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80099c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a0:	0f 89 22 ff ff ff    	jns    8008c8 <vprintfmt+0x90>
				width = precision, precision = -1;
  8009a6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009ac:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009b3:	e9 10 ff ff ff       	jmpq   8008c8 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009bc:	e9 08 ff ff ff       	jmpq   8008c9 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 30             	cmp    $0x30,%eax
  8009c7:	73 17                	jae    8009e0 <vprintfmt+0x1a8>
  8009c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d0:	89 c0                	mov    %eax,%eax
  8009d2:	48 01 d0             	add    %rdx,%rax
  8009d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d8:	83 c2 08             	add    $0x8,%edx
  8009db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009de:	eb 0f                	jmp    8009ef <vprintfmt+0x1b7>
  8009e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e4:	48 89 d0             	mov    %rdx,%rax
  8009e7:	48 83 c2 08          	add    $0x8,%rdx
  8009eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ef:	8b 00                	mov    (%rax),%eax
  8009f1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009f9:	48 89 d6             	mov    %rdx,%rsi
  8009fc:	89 c7                	mov    %eax,%edi
  8009fe:	ff d1                	callq  *%rcx
			break;
  800a00:	e9 47 03 00 00       	jmpq   800d4c <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 17                	jae    800a24 <vprintfmt+0x1ec>
  800a0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a14:	89 c0                	mov    %eax,%eax
  800a16:	48 01 d0             	add    %rdx,%rax
  800a19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1c:	83 c2 08             	add    $0x8,%edx
  800a1f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a22:	eb 0f                	jmp    800a33 <vprintfmt+0x1fb>
  800a24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a28:	48 89 d0             	mov    %rdx,%rax
  800a2b:	48 83 c2 08          	add    $0x8,%rdx
  800a2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a33:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	79 02                	jns    800a3b <vprintfmt+0x203>
				err = -err;
  800a39:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a3b:	83 fb 10             	cmp    $0x10,%ebx
  800a3e:	7f 16                	jg     800a56 <vprintfmt+0x21e>
  800a40:	48 b8 40 40 80 00 00 	movabs $0x804040,%rax
  800a47:	00 00 00 
  800a4a:	48 63 d3             	movslq %ebx,%rdx
  800a4d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a51:	4d 85 e4             	test   %r12,%r12
  800a54:	75 2e                	jne    800a84 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5e:	89 d9                	mov    %ebx,%ecx
  800a60:	48 ba d9 40 80 00 00 	movabs $0x8040d9,%rdx
  800a67:	00 00 00 
  800a6a:	48 89 c7             	mov    %rax,%rdi
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	49 b8 5c 0d 80 00 00 	movabs $0x800d5c,%r8
  800a79:	00 00 00 
  800a7c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7f:	e9 c8 02 00 00       	jmpq   800d4c <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	4c 89 e1             	mov    %r12,%rcx
  800a8f:	48 ba e2 40 80 00 00 	movabs $0x8040e2,%rdx
  800a96:	00 00 00 
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	49 b8 5c 0d 80 00 00 	movabs $0x800d5c,%r8
  800aa8:	00 00 00 
  800aab:	41 ff d0             	callq  *%r8
			break;
  800aae:	e9 99 02 00 00       	jmpq   800d4c <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ab3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab6:	83 f8 30             	cmp    $0x30,%eax
  800ab9:	73 17                	jae    800ad2 <vprintfmt+0x29a>
  800abb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aca:	83 c2 08             	add    $0x8,%edx
  800acd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad0:	eb 0f                	jmp    800ae1 <vprintfmt+0x2a9>
  800ad2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad6:	48 89 d0             	mov    %rdx,%rax
  800ad9:	48 83 c2 08          	add    $0x8,%rdx
  800add:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae1:	4c 8b 20             	mov    (%rax),%r12
  800ae4:	4d 85 e4             	test   %r12,%r12
  800ae7:	75 0a                	jne    800af3 <vprintfmt+0x2bb>
				p = "(null)";
  800ae9:	49 bc e5 40 80 00 00 	movabs $0x8040e5,%r12
  800af0:	00 00 00 
			if (width > 0 && padc != '-')
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af7:	7e 7a                	jle    800b73 <vprintfmt+0x33b>
  800af9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800afd:	74 74                	je     800b73 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b02:	48 98                	cltq   
  800b04:	48 89 c6             	mov    %rax,%rsi
  800b07:	4c 89 e7             	mov    %r12,%rdi
  800b0a:	48 b8 06 10 80 00 00 	movabs $0x801006,%rax
  800b11:	00 00 00 
  800b14:	ff d0                	callq  *%rax
  800b16:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b19:	eb 17                	jmp    800b32 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b1b:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	89 c7                	mov    %eax,%edi
  800b2c:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b36:	7f e3                	jg     800b1b <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b38:	eb 39                	jmp    800b73 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b3e:	74 1e                	je     800b5e <vprintfmt+0x326>
  800b40:	83 fb 1f             	cmp    $0x1f,%ebx
  800b43:	7e 05                	jle    800b4a <vprintfmt+0x312>
  800b45:	83 fb 7e             	cmp    $0x7e,%ebx
  800b48:	7e 14                	jle    800b5e <vprintfmt+0x326>
					putch('?', putdat);
  800b4a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b4e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b52:	48 89 c6             	mov    %rax,%rsi
  800b55:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b5a:	ff d2                	callq  *%rdx
  800b5c:	eb 0f                	jmp    800b6d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b66:	48 89 c6             	mov    %rax,%rsi
  800b69:	89 df                	mov    %ebx,%edi
  800b6b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b71:	eb 01                	jmp    800b74 <vprintfmt+0x33c>
  800b73:	90                   	nop
  800b74:	41 0f b6 04 24       	movzbl (%r12),%eax
  800b79:	0f be d8             	movsbl %al,%ebx
  800b7c:	85 db                	test   %ebx,%ebx
  800b7e:	0f 95 c0             	setne  %al
  800b81:	49 83 c4 01          	add    $0x1,%r12
  800b85:	84 c0                	test   %al,%al
  800b87:	74 28                	je     800bb1 <vprintfmt+0x379>
  800b89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b8d:	78 ab                	js     800b3a <vprintfmt+0x302>
  800b8f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b93:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b97:	79 a1                	jns    800b3a <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b99:	eb 16                	jmp    800bb1 <vprintfmt+0x379>
				putch(' ', putdat);
  800b9b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b9f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ba3:	48 89 c6             	mov    %rax,%rsi
  800ba6:	bf 20 00 00 00       	mov    $0x20,%edi
  800bab:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bad:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb5:	7f e4                	jg     800b9b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800bb7:	e9 90 01 00 00       	jmpq   800d4c <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc0:	be 03 00 00 00       	mov    $0x3,%esi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 28 07 80 00 00 	movabs $0x800728,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
  800bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bdc:	48 85 c0             	test   %rax,%rax
  800bdf:	79 1d                	jns    800bfe <vprintfmt+0x3c6>
				putch('-', putdat);
  800be1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800be5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800be9:	48 89 c6             	mov    %rax,%rsi
  800bec:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bf1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf7:	48 f7 d8             	neg    %rax
  800bfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bfe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c05:	e9 d5 00 00 00       	jmpq   800cdf <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0e:	be 03 00 00 00       	mov    $0x3,%esi
  800c13:	48 89 c7             	mov    %rax,%rdi
  800c16:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800c1d:	00 00 00 
  800c20:	ff d0                	callq  *%rax
  800c22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c26:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c2d:	e9 ad 00 00 00       	jmpq   800cdf <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c36:	be 03 00 00 00       	mov    $0x3,%esi
  800c3b:	48 89 c7             	mov    %rax,%rdi
  800c3e:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800c45:	00 00 00 
  800c48:	ff d0                	callq  *%rax
  800c4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800c4e:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c55:	e9 85 00 00 00       	jmpq   800cdf <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c5a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c5e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c62:	48 89 c6             	mov    %rax,%rsi
  800c65:	bf 30 00 00 00       	mov    $0x30,%edi
  800c6a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800c6c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c70:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c74:	48 89 c6             	mov    %rax,%rsi
  800c77:	bf 78 00 00 00       	mov    $0x78,%edi
  800c7c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c7e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c81:	83 f8 30             	cmp    $0x30,%eax
  800c84:	73 17                	jae    800c9d <vprintfmt+0x465>
  800c86:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	89 c0                	mov    %eax,%eax
  800c8f:	48 01 d0             	add    %rdx,%rax
  800c92:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c95:	83 c2 08             	add    $0x8,%edx
  800c98:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c9b:	eb 0f                	jmp    800cac <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800c9d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca1:	48 89 d0             	mov    %rdx,%rax
  800ca4:	48 83 c2 08          	add    $0x8,%rdx
  800ca8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cac:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800caf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cba:	eb 23                	jmp    800cdf <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc0:	be 03 00 00 00       	mov    $0x3,%esi
  800cc5:	48 89 c7             	mov    %rax,%rdi
  800cc8:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800ccf:	00 00 00 
  800cd2:	ff d0                	callq  *%rax
  800cd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cd8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cdf:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ce4:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ce7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cee:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cf2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf6:	45 89 c1             	mov    %r8d,%r9d
  800cf9:	41 89 f8             	mov    %edi,%r8d
  800cfc:	48 89 c7             	mov    %rax,%rdi
  800cff:	48 b8 60 05 80 00 00 	movabs $0x800560,%rax
  800d06:	00 00 00 
  800d09:	ff d0                	callq  *%rax
			break;
  800d0b:	eb 3f                	jmp    800d4c <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d0d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d11:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d15:	48 89 c6             	mov    %rax,%rsi
  800d18:	89 df                	mov    %ebx,%edi
  800d1a:	ff d2                	callq  *%rdx
			break;
  800d1c:	eb 2e                	jmp    800d4c <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d22:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d26:	48 89 c6             	mov    %rax,%rsi
  800d29:	bf 25 00 00 00       	mov    $0x25,%edi
  800d2e:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d30:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d35:	eb 05                	jmp    800d3c <vprintfmt+0x504>
  800d37:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d3c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d40:	48 83 e8 01          	sub    $0x1,%rax
  800d44:	0f b6 00             	movzbl (%rax),%eax
  800d47:	3c 25                	cmp    $0x25,%al
  800d49:	75 ec                	jne    800d37 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d4b:	90                   	nop
		}
	}
  800d4c:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4d:	e9 38 fb ff ff       	jmpq   80088a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d52:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d53:	48 83 c4 60          	add    $0x60,%rsp
  800d57:	5b                   	pop    %rbx
  800d58:	41 5c                	pop    %r12
  800d5a:	5d                   	pop    %rbp
  800d5b:	c3                   	retq   

0000000000800d5c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5c:	55                   	push   %rbp
  800d5d:	48 89 e5             	mov    %rsp,%rbp
  800d60:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d67:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d6e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d75:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d83:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8a:	84 c0                	test   %al,%al
  800d8c:	74 20                	je     800dae <printfmt+0x52>
  800d8e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d92:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d96:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800daa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dae:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800db5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dbc:	00 00 00 
  800dbf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dc6:	00 00 00 
  800dc9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dcd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800dd4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ddb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800de2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800de9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800df0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800df7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dfe:	48 89 c7             	mov    %rax,%rdi
  800e01:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800e08:	00 00 00 
  800e0b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e0d:	c9                   	leaveq 
  800e0e:	c3                   	retq   

0000000000800e0f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e0f:	55                   	push   %rbp
  800e10:	48 89 e5             	mov    %rsp,%rbp
  800e13:	48 83 ec 10          	sub    $0x10,%rsp
  800e17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e22:	8b 40 10             	mov    0x10(%rax),%eax
  800e25:	8d 50 01             	lea    0x1(%rax),%edx
  800e28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e33:	48 8b 10             	mov    (%rax),%rdx
  800e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e3e:	48 39 c2             	cmp    %rax,%rdx
  800e41:	73 17                	jae    800e5a <sprintputch+0x4b>
		*b->buf++ = ch;
  800e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e47:	48 8b 00             	mov    (%rax),%rax
  800e4a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e4d:	88 10                	mov    %dl,(%rax)
  800e4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 89 10             	mov    %rdx,(%rax)
}
  800e5a:	c9                   	leaveq 
  800e5b:	c3                   	retq   

0000000000800e5c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e5c:	55                   	push   %rbp
  800e5d:	48 89 e5             	mov    %rsp,%rbp
  800e60:	48 83 ec 50          	sub    $0x50,%rsp
  800e64:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e68:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e6b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e6f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e73:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e77:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e7b:	48 8b 0a             	mov    (%rdx),%rcx
  800e7e:	48 89 08             	mov    %rcx,(%rax)
  800e81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e95:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e99:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e9c:	48 98                	cltq   
  800e9e:	48 83 e8 01          	sub    $0x1,%rax
  800ea2:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800ea6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eaa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800eb1:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eb6:	74 06                	je     800ebe <vsnprintf+0x62>
  800eb8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ebc:	7f 07                	jg     800ec5 <vsnprintf+0x69>
		return -E_INVAL;
  800ebe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec3:	eb 2f                	jmp    800ef4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ec5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ec9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ecd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ed1:	48 89 c6             	mov    %rax,%rsi
  800ed4:	48 bf 0f 0e 80 00 00 	movabs $0x800e0f,%rdi
  800edb:	00 00 00 
  800ede:	48 b8 38 08 80 00 00 	movabs $0x800838,%rax
  800ee5:	00 00 00 
  800ee8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800eea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eee:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ef1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ef4:	c9                   	leaveq 
  800ef5:	c3                   	retq   

0000000000800ef6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ef6:	55                   	push   %rbp
  800ef7:	48 89 e5             	mov    %rsp,%rbp
  800efa:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f01:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f08:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f0e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f15:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f1c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f23:	84 c0                	test   %al,%al
  800f25:	74 20                	je     800f47 <snprintf+0x51>
  800f27:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f2b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f2f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f33:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f37:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f3b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f3f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f43:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f47:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f4e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f55:	00 00 00 
  800f58:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f5f:	00 00 00 
  800f62:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f66:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f6d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f74:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f7b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f82:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f89:	48 8b 0a             	mov    (%rdx),%rcx
  800f8c:	48 89 08             	mov    %rcx,(%rax)
  800f8f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f93:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f97:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f9b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f9f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fa6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fad:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fb3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fba:	48 89 c7             	mov    %rax,%rdi
  800fbd:	48 b8 5c 0e 80 00 00 	movabs $0x800e5c,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
  800fc9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fcf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fd5:	c9                   	leaveq 
  800fd6:	c3                   	retq   
	...

0000000000800fd8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd8:	55                   	push   %rbp
  800fd9:	48 89 e5             	mov    %rsp,%rbp
  800fdc:	48 83 ec 18          	sub    $0x18,%rsp
  800fe0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800feb:	eb 09                	jmp    800ff6 <strlen+0x1e>
		n++;
  800fed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ff6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffa:	0f b6 00             	movzbl (%rax),%eax
  800ffd:	84 c0                	test   %al,%al
  800fff:	75 ec                	jne    800fed <strlen+0x15>
		n++;
	return n;
  801001:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801004:	c9                   	leaveq 
  801005:	c3                   	retq   

0000000000801006 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801006:	55                   	push   %rbp
  801007:	48 89 e5             	mov    %rsp,%rbp
  80100a:	48 83 ec 20          	sub    $0x20,%rsp
  80100e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801012:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101d:	eb 0e                	jmp    80102d <strnlen+0x27>
		n++;
  80101f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801023:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801028:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80102d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801032:	74 0b                	je     80103f <strnlen+0x39>
  801034:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801038:	0f b6 00             	movzbl (%rax),%eax
  80103b:	84 c0                	test   %al,%al
  80103d:	75 e0                	jne    80101f <strnlen+0x19>
		n++;
	return n;
  80103f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801042:	c9                   	leaveq 
  801043:	c3                   	retq   

0000000000801044 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801044:	55                   	push   %rbp
  801045:	48 89 e5             	mov    %rsp,%rbp
  801048:	48 83 ec 20          	sub    $0x20,%rsp
  80104c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801050:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801058:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80105c:	90                   	nop
  80105d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801061:	0f b6 10             	movzbl (%rax),%edx
  801064:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801068:	88 10                	mov    %dl,(%rax)
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	0f b6 00             	movzbl (%rax),%eax
  801071:	84 c0                	test   %al,%al
  801073:	0f 95 c0             	setne  %al
  801076:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801080:	84 c0                	test   %al,%al
  801082:	75 d9                	jne    80105d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 20          	sub    $0x20,%rsp
  801092:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801096:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80109a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109e:	48 89 c7             	mov    %rax,%rdi
  8010a1:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
  8010ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b3:	48 98                	cltq   
  8010b5:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010b9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010bd:	48 89 d6             	mov    %rdx,%rsi
  8010c0:	48 89 c7             	mov    %rax,%rdi
  8010c3:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  8010ca:	00 00 00 
  8010cd:	ff d0                	callq  *%rax
	return dst;
  8010cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010d3:	c9                   	leaveq 
  8010d4:	c3                   	retq   

00000000008010d5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010d5:	55                   	push   %rbp
  8010d6:	48 89 e5             	mov    %rsp,%rbp
  8010d9:	48 83 ec 28          	sub    $0x28,%rsp
  8010dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010f1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010f8:	00 
  8010f9:	eb 27                	jmp    801122 <strncpy+0x4d>
		*dst++ = *src;
  8010fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ff:	0f b6 10             	movzbl (%rax),%edx
  801102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801106:	88 10                	mov    %dl,(%rax)
  801108:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80110d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801111:	0f b6 00             	movzbl (%rax),%eax
  801114:	84 c0                	test   %al,%al
  801116:	74 05                	je     80111d <strncpy+0x48>
			src++;
  801118:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80111d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801126:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80112a:	72 cf                	jb     8010fb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80112c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801130:	c9                   	leaveq 
  801131:	c3                   	retq   

0000000000801132 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801132:	55                   	push   %rbp
  801133:	48 89 e5             	mov    %rsp,%rbp
  801136:	48 83 ec 28          	sub    $0x28,%rsp
  80113a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801142:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80114e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801153:	74 37                	je     80118c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801155:	eb 17                	jmp    80116e <strlcpy+0x3c>
			*dst++ = *src++;
  801157:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115b:	0f b6 10             	movzbl (%rax),%edx
  80115e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801162:	88 10                	mov    %dl,(%rax)
  801164:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801169:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80116e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801173:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801178:	74 0b                	je     801185 <strlcpy+0x53>
  80117a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80117e:	0f b6 00             	movzbl (%rax),%eax
  801181:	84 c0                	test   %al,%al
  801183:	75 d2                	jne    801157 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80118c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	48 89 d1             	mov    %rdx,%rcx
  801197:	48 29 c1             	sub    %rax,%rcx
  80119a:	48 89 c8             	mov    %rcx,%rax
}
  80119d:	c9                   	leaveq 
  80119e:	c3                   	retq   

000000000080119f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119f:	55                   	push   %rbp
  8011a0:	48 89 e5             	mov    %rsp,%rbp
  8011a3:	48 83 ec 10          	sub    $0x10,%rsp
  8011a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011af:	eb 0a                	jmp    8011bb <strcmp+0x1c>
		p++, q++;
  8011b1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011b6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011bf:	0f b6 00             	movzbl (%rax),%eax
  8011c2:	84 c0                	test   %al,%al
  8011c4:	74 12                	je     8011d8 <strcmp+0x39>
  8011c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ca:	0f b6 10             	movzbl (%rax),%edx
  8011cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011d1:	0f b6 00             	movzbl (%rax),%eax
  8011d4:	38 c2                	cmp    %al,%dl
  8011d6:	74 d9                	je     8011b1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	0f b6 00             	movzbl (%rax),%eax
  8011df:	0f b6 d0             	movzbl %al,%edx
  8011e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e6:	0f b6 00             	movzbl (%rax),%eax
  8011e9:	0f b6 c0             	movzbl %al,%eax
  8011ec:	89 d1                	mov    %edx,%ecx
  8011ee:	29 c1                	sub    %eax,%ecx
  8011f0:	89 c8                	mov    %ecx,%eax
}
  8011f2:	c9                   	leaveq 
  8011f3:	c3                   	retq   

00000000008011f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	48 83 ec 18          	sub    $0x18,%rsp
  8011fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801200:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801204:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801208:	eb 0f                	jmp    801219 <strncmp+0x25>
		n--, p++, q++;
  80120a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80120f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801214:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801219:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80121e:	74 1d                	je     80123d <strncmp+0x49>
  801220:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801224:	0f b6 00             	movzbl (%rax),%eax
  801227:	84 c0                	test   %al,%al
  801229:	74 12                	je     80123d <strncmp+0x49>
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 10             	movzbl (%rax),%edx
  801232:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	38 c2                	cmp    %al,%dl
  80123b:	74 cd                	je     80120a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80123d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801242:	75 07                	jne    80124b <strncmp+0x57>
		return 0;
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
  801249:	eb 1a                	jmp    801265 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124f:	0f b6 00             	movzbl (%rax),%eax
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801259:	0f b6 00             	movzbl (%rax),%eax
  80125c:	0f b6 c0             	movzbl %al,%eax
  80125f:	89 d1                	mov    %edx,%ecx
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 c8                	mov    %ecx,%eax
}
  801265:	c9                   	leaveq 
  801266:	c3                   	retq   

0000000000801267 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	48 83 ec 10          	sub    $0x10,%rsp
  80126f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801273:	89 f0                	mov    %esi,%eax
  801275:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801278:	eb 17                	jmp    801291 <strchr+0x2a>
		if (*s == c)
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801284:	75 06                	jne    80128c <strchr+0x25>
			return (char *) s;
  801286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128a:	eb 15                	jmp    8012a1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80128c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801291:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801295:	0f b6 00             	movzbl (%rax),%eax
  801298:	84 c0                	test   %al,%al
  80129a:	75 de                	jne    80127a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a1:	c9                   	leaveq 
  8012a2:	c3                   	retq   

00000000008012a3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012a3:	55                   	push   %rbp
  8012a4:	48 89 e5             	mov    %rsp,%rbp
  8012a7:	48 83 ec 10          	sub    $0x10,%rsp
  8012ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012b4:	eb 11                	jmp    8012c7 <strfind+0x24>
		if (*s == c)
  8012b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ba:	0f b6 00             	movzbl (%rax),%eax
  8012bd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012c0:	74 12                	je     8012d4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 00             	movzbl (%rax),%eax
  8012ce:	84 c0                	test   %al,%al
  8012d0:	75 e4                	jne    8012b6 <strfind+0x13>
  8012d2:	eb 01                	jmp    8012d5 <strfind+0x32>
		if (*s == c)
			break;
  8012d4:	90                   	nop
	return (char *) s;
  8012d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 18          	sub    $0x18,%rsp
  8012e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012f3:	75 06                	jne    8012fb <memset+0x20>
		return v;
  8012f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f9:	eb 69                	jmp    801364 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	83 e0 03             	and    $0x3,%eax
  801302:	48 85 c0             	test   %rax,%rax
  801305:	75 48                	jne    80134f <memset+0x74>
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	83 e0 03             	and    $0x3,%eax
  80130e:	48 85 c0             	test   %rax,%rax
  801311:	75 3c                	jne    80134f <memset+0x74>
		c &= 0xFF;
  801313:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80131a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131d:	89 c2                	mov    %eax,%edx
  80131f:	c1 e2 18             	shl    $0x18,%edx
  801322:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801325:	c1 e0 10             	shl    $0x10,%eax
  801328:	09 c2                	or     %eax,%edx
  80132a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132d:	c1 e0 08             	shl    $0x8,%eax
  801330:	09 d0                	or     %edx,%eax
  801332:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	48 89 c1             	mov    %rax,%rcx
  80133c:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801340:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801347:	48 89 d7             	mov    %rdx,%rdi
  80134a:	fc                   	cld    
  80134b:	f3 ab                	rep stos %eax,%es:(%rdi)
  80134d:	eb 11                	jmp    801360 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80134f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801353:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801356:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80135a:	48 89 d7             	mov    %rdx,%rdi
  80135d:	fc                   	cld    
  80135e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801360:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801364:	c9                   	leaveq 
  801365:	c3                   	retq   

0000000000801366 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801366:	55                   	push   %rbp
  801367:	48 89 e5             	mov    %rsp,%rbp
  80136a:	48 83 ec 28          	sub    $0x28,%rsp
  80136e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801372:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801376:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80137a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801386:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80138a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801392:	0f 83 88 00 00 00    	jae    801420 <memmove+0xba>
  801398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a0:	48 01 d0             	add    %rdx,%rax
  8013a3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a7:	76 77                	jbe    801420 <memmove+0xba>
		s += n;
  8013a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ad:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bd:	83 e0 03             	and    $0x3,%eax
  8013c0:	48 85 c0             	test   %rax,%rax
  8013c3:	75 3b                	jne    801400 <memmove+0x9a>
  8013c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c9:	83 e0 03             	and    $0x3,%eax
  8013cc:	48 85 c0             	test   %rax,%rax
  8013cf:	75 2f                	jne    801400 <memmove+0x9a>
  8013d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d5:	83 e0 03             	and    $0x3,%eax
  8013d8:	48 85 c0             	test   %rax,%rax
  8013db:	75 23                	jne    801400 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e1:	48 83 e8 04          	sub    $0x4,%rax
  8013e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013e9:	48 83 ea 04          	sub    $0x4,%rdx
  8013ed:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013f1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013f5:	48 89 c7             	mov    %rax,%rdi
  8013f8:	48 89 d6             	mov    %rdx,%rsi
  8013fb:	fd                   	std    
  8013fc:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013fe:	eb 1d                	jmp    80141d <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801404:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140c:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	48 89 d7             	mov    %rdx,%rdi
  801417:	48 89 c1             	mov    %rax,%rcx
  80141a:	fd                   	std    
  80141b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80141d:	fc                   	cld    
  80141e:	eb 57                	jmp    801477 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801420:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801424:	83 e0 03             	and    $0x3,%eax
  801427:	48 85 c0             	test   %rax,%rax
  80142a:	75 36                	jne    801462 <memmove+0xfc>
  80142c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801430:	83 e0 03             	and    $0x3,%eax
  801433:	48 85 c0             	test   %rax,%rax
  801436:	75 2a                	jne    801462 <memmove+0xfc>
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	83 e0 03             	and    $0x3,%eax
  80143f:	48 85 c0             	test   %rax,%rax
  801442:	75 1e                	jne    801462 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	48 89 c1             	mov    %rax,%rcx
  80144b:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80144f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801453:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801457:	48 89 c7             	mov    %rax,%rdi
  80145a:	48 89 d6             	mov    %rdx,%rsi
  80145d:	fc                   	cld    
  80145e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801460:	eb 15                	jmp    801477 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801466:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80146e:	48 89 c7             	mov    %rax,%rdi
  801471:	48 89 d6             	mov    %rdx,%rsi
  801474:	fc                   	cld    
  801475:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80147b:	c9                   	leaveq 
  80147c:	c3                   	retq   

000000000080147d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80147d:	55                   	push   %rbp
  80147e:	48 89 e5             	mov    %rsp,%rbp
  801481:	48 83 ec 18          	sub    $0x18,%rsp
  801485:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801489:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80148d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801491:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801495:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801499:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149d:	48 89 ce             	mov    %rcx,%rsi
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 28          	sub    $0x28,%rsp
  8014b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014d5:	eb 38                	jmp    80150f <memcmp+0x5e>
		if (*s1 != *s2)
  8014d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014db:	0f b6 10             	movzbl (%rax),%edx
  8014de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e2:	0f b6 00             	movzbl (%rax),%eax
  8014e5:	38 c2                	cmp    %al,%dl
  8014e7:	74 1c                	je     801505 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ed:	0f b6 00             	movzbl (%rax),%eax
  8014f0:	0f b6 d0             	movzbl %al,%edx
  8014f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	0f b6 c0             	movzbl %al,%eax
  8014fd:	89 d1                	mov    %edx,%ecx
  8014ff:	29 c1                	sub    %eax,%ecx
  801501:	89 c8                	mov    %ecx,%eax
  801503:	eb 20                	jmp    801525 <memcmp+0x74>
		s1++, s2++;
  801505:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80150a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80150f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801514:	0f 95 c0             	setne  %al
  801517:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80151c:	84 c0                	test   %al,%al
  80151e:	75 b7                	jne    8014d7 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801520:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   

0000000000801527 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	48 83 ec 28          	sub    $0x28,%rsp
  80152f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801533:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801536:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80153a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801542:	48 01 d0             	add    %rdx,%rax
  801545:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801549:	eb 13                	jmp    80155e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80154b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154f:	0f b6 10             	movzbl (%rax),%edx
  801552:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801555:	38 c2                	cmp    %al,%dl
  801557:	74 11                	je     80156a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801559:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80155e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801562:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801566:	72 e3                	jb     80154b <memfind+0x24>
  801568:	eb 01                	jmp    80156b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80156a:	90                   	nop
	return (void *) s;
  80156b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80156f:	c9                   	leaveq 
  801570:	c3                   	retq   

0000000000801571 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801571:	55                   	push   %rbp
  801572:	48 89 e5             	mov    %rsp,%rbp
  801575:	48 83 ec 38          	sub    $0x38,%rsp
  801579:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80157d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801581:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80158b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801592:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801593:	eb 05                	jmp    80159a <strtol+0x29>
		s++;
  801595:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	3c 20                	cmp    $0x20,%al
  8015a3:	74 f0                	je     801595 <strtol+0x24>
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	3c 09                	cmp    $0x9,%al
  8015ae:	74 e5                	je     801595 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	0f b6 00             	movzbl (%rax),%eax
  8015b7:	3c 2b                	cmp    $0x2b,%al
  8015b9:	75 07                	jne    8015c2 <strtol+0x51>
		s++;
  8015bb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015c0:	eb 17                	jmp    8015d9 <strtol+0x68>
	else if (*s == '-')
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	0f b6 00             	movzbl (%rax),%eax
  8015c9:	3c 2d                	cmp    $0x2d,%al
  8015cb:	75 0c                	jne    8015d9 <strtol+0x68>
		s++, neg = 1;
  8015cd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015dd:	74 06                	je     8015e5 <strtol+0x74>
  8015df:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015e3:	75 28                	jne    80160d <strtol+0x9c>
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	3c 30                	cmp    $0x30,%al
  8015ee:	75 1d                	jne    80160d <strtol+0x9c>
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	48 83 c0 01          	add    $0x1,%rax
  8015f8:	0f b6 00             	movzbl (%rax),%eax
  8015fb:	3c 78                	cmp    $0x78,%al
  8015fd:	75 0e                	jne    80160d <strtol+0x9c>
		s += 2, base = 16;
  8015ff:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801604:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80160b:	eb 2c                	jmp    801639 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80160d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801611:	75 19                	jne    80162c <strtol+0xbb>
  801613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	3c 30                	cmp    $0x30,%al
  80161c:	75 0e                	jne    80162c <strtol+0xbb>
		s++, base = 8;
  80161e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801623:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80162a:	eb 0d                	jmp    801639 <strtol+0xc8>
	else if (base == 0)
  80162c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801630:	75 07                	jne    801639 <strtol+0xc8>
		base = 10;
  801632:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	3c 2f                	cmp    $0x2f,%al
  801642:	7e 1d                	jle    801661 <strtol+0xf0>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	0f b6 00             	movzbl (%rax),%eax
  80164b:	3c 39                	cmp    $0x39,%al
  80164d:	7f 12                	jg     801661 <strtol+0xf0>
			dig = *s - '0';
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	0f b6 00             	movzbl (%rax),%eax
  801656:	0f be c0             	movsbl %al,%eax
  801659:	83 e8 30             	sub    $0x30,%eax
  80165c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165f:	eb 4e                	jmp    8016af <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 60                	cmp    $0x60,%al
  80166a:	7e 1d                	jle    801689 <strtol+0x118>
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 7a                	cmp    $0x7a,%al
  801675:	7f 12                	jg     801689 <strtol+0x118>
			dig = *s - 'a' + 10;
  801677:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167b:	0f b6 00             	movzbl (%rax),%eax
  80167e:	0f be c0             	movsbl %al,%eax
  801681:	83 e8 57             	sub    $0x57,%eax
  801684:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801687:	eb 26                	jmp    8016af <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801689:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3c 40                	cmp    $0x40,%al
  801692:	7e 47                	jle    8016db <strtol+0x16a>
  801694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801698:	0f b6 00             	movzbl (%rax),%eax
  80169b:	3c 5a                	cmp    $0x5a,%al
  80169d:	7f 3c                	jg     8016db <strtol+0x16a>
			dig = *s - 'A' + 10;
  80169f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a3:	0f b6 00             	movzbl (%rax),%eax
  8016a6:	0f be c0             	movsbl %al,%eax
  8016a9:	83 e8 37             	sub    $0x37,%eax
  8016ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016b2:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016b5:	7d 23                	jge    8016da <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016bc:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016bf:	48 98                	cltq   
  8016c1:	48 89 c2             	mov    %rax,%rdx
  8016c4:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8016c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016cc:	48 98                	cltq   
  8016ce:	48 01 d0             	add    %rdx,%rax
  8016d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016d5:	e9 5f ff ff ff       	jmpq   801639 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016db:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016e0:	74 0b                	je     8016ed <strtol+0x17c>
		*endptr = (char *) s;
  8016e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016ea:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016f1:	74 09                	je     8016fc <strtol+0x18b>
  8016f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f7:	48 f7 d8             	neg    %rax
  8016fa:	eb 04                	jmp    801700 <strtol+0x18f>
  8016fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801700:	c9                   	leaveq 
  801701:	c3                   	retq   

0000000000801702 <strstr>:

char * strstr(const char *in, const char *str)
{
  801702:	55                   	push   %rbp
  801703:	48 89 e5             	mov    %rsp,%rbp
  801706:	48 83 ec 30          	sub    $0x30,%rsp
  80170a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80170e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801712:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801716:	0f b6 00             	movzbl (%rax),%eax
  801719:	88 45 ff             	mov    %al,-0x1(%rbp)
  80171c:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801721:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801725:	75 06                	jne    80172d <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172b:	eb 68                	jmp    801795 <strstr+0x93>

    len = strlen(str);
  80172d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801731:	48 89 c7             	mov    %rax,%rdi
  801734:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  80173b:	00 00 00 
  80173e:	ff d0                	callq  *%rax
  801740:	48 98                	cltq   
  801742:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	0f b6 00             	movzbl (%rax),%eax
  80174d:	88 45 ef             	mov    %al,-0x11(%rbp)
  801750:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801755:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801759:	75 07                	jne    801762 <strstr+0x60>
                return (char *) 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
  801760:	eb 33                	jmp    801795 <strstr+0x93>
        } while (sc != c);
  801762:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801766:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801769:	75 db                	jne    801746 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80176b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80176f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801777:	48 89 ce             	mov    %rcx,%rsi
  80177a:	48 89 c7             	mov    %rax,%rdi
  80177d:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  801784:	00 00 00 
  801787:	ff d0                	callq  *%rax
  801789:	85 c0                	test   %eax,%eax
  80178b:	75 b9                	jne    801746 <strstr+0x44>

    return (char *) (in - 1);
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	48 83 e8 01          	sub    $0x1,%rax
}
  801795:	c9                   	leaveq 
  801796:	c3                   	retq   
	...

0000000000801798 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	53                   	push   %rbx
  80179d:	48 83 ec 58          	sub    $0x58,%rsp
  8017a1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017a4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017a7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ab:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017af:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017b3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ba:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8017bd:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017c1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017c5:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017c9:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017cd:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017d1:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8017d4:	4c 89 c3             	mov    %r8,%rbx
  8017d7:	cd 30                	int    $0x30
  8017d9:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8017dd:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8017e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017e9:	74 3e                	je     801829 <syscall+0x91>
  8017eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f0:	7e 37                	jle    801829 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017f9:	49 89 d0             	mov    %rdx,%r8
  8017fc:	89 c1                	mov    %eax,%ecx
  8017fe:	48 ba a0 43 80 00 00 	movabs $0x8043a0,%rdx
  801805:	00 00 00 
  801808:	be 23 00 00 00       	mov    $0x23,%esi
  80180d:	48 bf bd 43 80 00 00 	movabs $0x8043bd,%rdi
  801814:	00 00 00 
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	49 b9 4c 02 80 00 00 	movabs $0x80024c,%r9
  801823:	00 00 00 
  801826:	41 ff d1             	callq  *%r9

	return ret;
  801829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80182d:	48 83 c4 58          	add    $0x58,%rsp
  801831:	5b                   	pop    %rbx
  801832:	5d                   	pop    %rbp
  801833:	c3                   	retq   

0000000000801834 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801834:	55                   	push   %rbp
  801835:	48 89 e5             	mov    %rsp,%rbp
  801838:	48 83 ec 20          	sub    $0x20,%rsp
  80183c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801840:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801848:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80184c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801853:	00 
  801854:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801860:	48 89 d1             	mov    %rdx,%rcx
  801863:	48 89 c2             	mov    %rax,%rdx
  801866:	be 00 00 00 00       	mov    $0x0,%esi
  80186b:	bf 00 00 00 00       	mov    $0x0,%edi
  801870:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801877:	00 00 00 
  80187a:	ff d0                	callq  *%rax
}
  80187c:	c9                   	leaveq 
  80187d:	c3                   	retq   

000000000080187e <sys_cgetc>:

int
sys_cgetc(void)
{
  80187e:	55                   	push   %rbp
  80187f:	48 89 e5             	mov    %rsp,%rbp
  801882:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801886:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188d:	00 
  80188e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801894:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189f:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a4:	be 00 00 00 00       	mov    $0x0,%esi
  8018a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8018ae:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8018b5:	00 00 00 
  8018b8:	ff d0                	callq  *%rax
}
  8018ba:	c9                   	leaveq 
  8018bb:	c3                   	retq   

00000000008018bc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018bc:	55                   	push   %rbp
  8018bd:	48 89 e5             	mov    %rsp,%rbp
  8018c0:	48 83 ec 20          	sub    $0x20,%rsp
  8018c4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ca:	48 98                	cltq   
  8018cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d3:	00 
  8018d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e5:	48 89 c2             	mov    %rax,%rdx
  8018e8:	be 01 00 00 00       	mov    $0x1,%esi
  8018ed:	bf 03 00 00 00       	mov    $0x3,%edi
  8018f2:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
}
  8018fe:	c9                   	leaveq 
  8018ff:	c3                   	retq   

0000000000801900 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801900:	55                   	push   %rbp
  801901:	48 89 e5             	mov    %rsp,%rbp
  801904:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801908:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190f:	00 
  801910:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801916:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801921:	ba 00 00 00 00       	mov    $0x0,%edx
  801926:	be 00 00 00 00       	mov    $0x0,%esi
  80192b:	bf 02 00 00 00       	mov    $0x2,%edi
  801930:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801937:	00 00 00 
  80193a:	ff d0                	callq  *%rax
}
  80193c:	c9                   	leaveq 
  80193d:	c3                   	retq   

000000000080193e <sys_yield>:

void
sys_yield(void)
{
  80193e:	55                   	push   %rbp
  80193f:	48 89 e5             	mov    %rsp,%rbp
  801942:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801946:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194d:	00 
  80194e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801954:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	be 00 00 00 00       	mov    $0x0,%esi
  801969:	bf 0b 00 00 00       	mov    $0xb,%edi
  80196e:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801975:	00 00 00 
  801978:	ff d0                	callq  *%rax
}
  80197a:	c9                   	leaveq 
  80197b:	c3                   	retq   

000000000080197c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80197c:	55                   	push   %rbp
  80197d:	48 89 e5             	mov    %rsp,%rbp
  801980:	48 83 ec 20          	sub    $0x20,%rsp
  801984:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801987:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80198e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801991:	48 63 c8             	movslq %eax,%rcx
  801994:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80199b:	48 98                	cltq   
  80199d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a4:	00 
  8019a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ab:	49 89 c8             	mov    %rcx,%r8
  8019ae:	48 89 d1             	mov    %rdx,%rcx
  8019b1:	48 89 c2             	mov    %rax,%rdx
  8019b4:	be 01 00 00 00       	mov    $0x1,%esi
  8019b9:	bf 04 00 00 00       	mov    $0x4,%edi
  8019be:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8019c5:	00 00 00 
  8019c8:	ff d0                	callq  *%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 30          	sub    $0x30,%rsp
  8019d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019db:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019de:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019e2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019e6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019e9:	48 63 c8             	movslq %eax,%rcx
  8019ec:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f3:	48 63 f0             	movslq %eax,%rsi
  8019f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fd:	48 98                	cltq   
  8019ff:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a03:	49 89 f9             	mov    %rdi,%r9
  801a06:	49 89 f0             	mov    %rsi,%r8
  801a09:	48 89 d1             	mov    %rdx,%rcx
  801a0c:	48 89 c2             	mov    %rax,%rdx
  801a0f:	be 01 00 00 00       	mov    $0x1,%esi
  801a14:	bf 05 00 00 00       	mov    $0x5,%edi
  801a19:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801a20:	00 00 00 
  801a23:	ff d0                	callq  *%rax
}
  801a25:	c9                   	leaveq 
  801a26:	c3                   	retq   

0000000000801a27 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a27:	55                   	push   %rbp
  801a28:	48 89 e5             	mov    %rsp,%rbp
  801a2b:	48 83 ec 20          	sub    $0x20,%rsp
  801a2f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a32:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3d:	48 98                	cltq   
  801a3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a46:	00 
  801a47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a53:	48 89 d1             	mov    %rdx,%rcx
  801a56:	48 89 c2             	mov    %rax,%rdx
  801a59:	be 01 00 00 00       	mov    $0x1,%esi
  801a5e:	bf 06 00 00 00       	mov    $0x6,%edi
  801a63:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801a6a:	00 00 00 
  801a6d:	ff d0                	callq  *%rax
}
  801a6f:	c9                   	leaveq 
  801a70:	c3                   	retq   

0000000000801a71 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a71:	55                   	push   %rbp
  801a72:	48 89 e5             	mov    %rsp,%rbp
  801a75:	48 83 ec 20          	sub    $0x20,%rsp
  801a79:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a7c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a82:	48 63 d0             	movslq %eax,%rdx
  801a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a88:	48 98                	cltq   
  801a8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a91:	00 
  801a92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a98:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9e:	48 89 d1             	mov    %rdx,%rcx
  801aa1:	48 89 c2             	mov    %rax,%rdx
  801aa4:	be 01 00 00 00       	mov    $0x1,%esi
  801aa9:	bf 08 00 00 00       	mov    $0x8,%edi
  801aae:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801ab5:	00 00 00 
  801ab8:	ff d0                	callq  *%rax
}
  801aba:	c9                   	leaveq 
  801abb:	c3                   	retq   

0000000000801abc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801abc:	55                   	push   %rbp
  801abd:	48 89 e5             	mov    %rsp,%rbp
  801ac0:	48 83 ec 20          	sub    $0x20,%rsp
  801ac4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801acb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801acf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad2:	48 98                	cltq   
  801ad4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801adb:	00 
  801adc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ae8:	48 89 d1             	mov    %rdx,%rcx
  801aeb:	48 89 c2             	mov    %rax,%rdx
  801aee:	be 01 00 00 00       	mov    $0x1,%esi
  801af3:	bf 09 00 00 00       	mov    $0x9,%edi
  801af8:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	callq  *%rax
}
  801b04:	c9                   	leaveq 
  801b05:	c3                   	retq   

0000000000801b06 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b06:	55                   	push   %rbp
  801b07:	48 89 e5             	mov    %rsp,%rbp
  801b0a:	48 83 ec 20          	sub    $0x20,%rsp
  801b0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1c:	48 98                	cltq   
  801b1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b25:	00 
  801b26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b32:	48 89 d1             	mov    %rdx,%rcx
  801b35:	48 89 c2             	mov    %rax,%rdx
  801b38:	be 01 00 00 00       	mov    $0x1,%esi
  801b3d:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b42:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801b49:	00 00 00 
  801b4c:	ff d0                	callq  *%rax
}
  801b4e:	c9                   	leaveq 
  801b4f:	c3                   	retq   

0000000000801b50 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b50:	55                   	push   %rbp
  801b51:	48 89 e5             	mov    %rsp,%rbp
  801b54:	48 83 ec 30          	sub    $0x30,%rsp
  801b58:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b5b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b5f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b63:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b69:	48 63 f0             	movslq %eax,%rsi
  801b6c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b70:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b73:	48 98                	cltq   
  801b75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b79:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b80:	00 
  801b81:	49 89 f1             	mov    %rsi,%r9
  801b84:	49 89 c8             	mov    %rcx,%r8
  801b87:	48 89 d1             	mov    %rdx,%rcx
  801b8a:	48 89 c2             	mov    %rax,%rdx
  801b8d:	be 00 00 00 00       	mov    $0x0,%esi
  801b92:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b97:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801b9e:	00 00 00 
  801ba1:	ff d0                	callq  *%rax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 20          	sub    $0x20,%rsp
  801bad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bb5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bbc:	00 
  801bbd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bce:	48 89 c2             	mov    %rax,%rdx
  801bd1:	be 01 00 00 00       	mov    $0x1,%esi
  801bd6:	bf 0d 00 00 00       	mov    $0xd,%edi
  801bdb:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801be2:	00 00 00 
  801be5:	ff d0                	callq  *%rax
}
  801be7:	c9                   	leaveq 
  801be8:	c3                   	retq   

0000000000801be9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801be9:	55                   	push   %rbp
  801bea:	48 89 e5             	mov    %rsp,%rbp
  801bed:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bf1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf8:	00 
  801bf9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c05:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	be 00 00 00 00       	mov    $0x0,%esi
  801c14:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c19:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801c20:	00 00 00 
  801c23:	ff d0                	callq  *%rax
}
  801c25:	c9                   	leaveq 
  801c26:	c3                   	retq   

0000000000801c27 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801c27:	55                   	push   %rbp
  801c28:	48 89 e5             	mov    %rsp,%rbp
  801c2b:	48 83 ec 20          	sub    $0x20,%rsp
  801c2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c3f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c46:	00 
  801c47:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c4d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c53:	48 89 d1             	mov    %rdx,%rcx
  801c56:	48 89 c2             	mov    %rax,%rdx
  801c59:	be 00 00 00 00       	mov    $0x0,%esi
  801c5e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c63:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801c6a:	00 00 00 
  801c6d:	ff d0                	callq  *%rax
}
  801c6f:	c9                   	leaveq 
  801c70:	c3                   	retq   

0000000000801c71 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801c71:	55                   	push   %rbp
  801c72:	48 89 e5             	mov    %rsp,%rbp
  801c75:	48 83 ec 20          	sub    $0x20,%rsp
  801c79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c81:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c90:	00 
  801c91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9d:	48 89 d1             	mov    %rdx,%rcx
  801ca0:	48 89 c2             	mov    %rax,%rdx
  801ca3:	be 00 00 00 00       	mov    $0x0,%esi
  801ca8:	bf 10 00 00 00       	mov    $0x10,%edi
  801cad:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  801cb4:	00 00 00 
  801cb7:	ff d0                	callq  *%rax
}
  801cb9:	c9                   	leaveq 
  801cba:	c3                   	retq   
	...

0000000000801cbc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801cbc:	55                   	push   %rbp
  801cbd:	48 89 e5             	mov    %rsp,%rbp
  801cc0:	48 83 ec 20          	sub    $0x20,%rsp
  801cc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  801cc8:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801ccf:	00 00 00 
  801cd2:	48 8b 00             	mov    (%rax),%rax
  801cd5:	48 85 c0             	test   %rax,%rax
  801cd8:	0f 85 8e 00 00 00    	jne    801d6c <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  801cde:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  801ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  801cec:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax
  801cf8:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  801cfb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801cff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d02:	ba 07 00 00 00       	mov    $0x7,%edx
  801d07:	48 89 ce             	mov    %rcx,%rsi
  801d0a:	89 c7                	mov    %eax,%edi
  801d0c:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax
  801d18:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  801d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d1f:	74 30                	je     801d51 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  801d21:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d24:	89 c1                	mov    %eax,%ecx
  801d26:	48 ba d0 43 80 00 00 	movabs $0x8043d0,%rdx
  801d2d:	00 00 00 
  801d30:	be 24 00 00 00       	mov    $0x24,%esi
  801d35:	48 bf 07 44 80 00 00 	movabs $0x804407,%rdi
  801d3c:	00 00 00 
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	49 b8 4c 02 80 00 00 	movabs $0x80024c,%r8
  801d4b:	00 00 00 
  801d4e:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801d51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d54:	48 be 80 1d 80 00 00 	movabs $0x801d80,%rsi
  801d5b:	00 00 00 
  801d5e:	89 c7                	mov    %eax,%edi
  801d60:	48 b8 06 1b 80 00 00 	movabs $0x801b06,%rax
  801d67:	00 00 00 
  801d6a:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801d6c:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801d73:	00 00 00 
  801d76:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d7a:	48 89 10             	mov    %rdx,(%rax)
}
  801d7d:	c9                   	leaveq 
  801d7e:	c3                   	retq   
	...

0000000000801d80 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801d80:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801d83:	48 a1 50 70 80 00 00 	movabs 0x807050,%rax
  801d8a:	00 00 00 
	call *%rax
  801d8d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  801d8f:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  801d93:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  801d97:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  801d9a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801da1:	00 
		movq 120(%rsp), %rcx				// trap time rip
  801da2:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  801da7:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  801daa:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  801dab:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  801dae:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  801db5:	00 08 
		POPA_						// copy the register contents to the registers
  801db7:	4c 8b 3c 24          	mov    (%rsp),%r15
  801dbb:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801dc0:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801dc5:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801dca:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801dcf:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801dd4:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801dd9:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801dde:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801de3:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801de8:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801ded:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801df2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801df7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801dfc:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801e01:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  801e05:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  801e09:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  801e0a:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  801e0b:	c3                   	retq   

0000000000801e0c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801e0c:	55                   	push   %rbp
  801e0d:	48 89 e5             	mov    %rsp,%rbp
  801e10:	48 83 ec 08          	sub    $0x8,%rsp
  801e14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e18:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801e23:	ff ff ff 
  801e26:	48 01 d0             	add    %rdx,%rax
  801e29:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e2d:	c9                   	leaveq 
  801e2e:	c3                   	retq   

0000000000801e2f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e2f:	55                   	push   %rbp
  801e30:	48 89 e5             	mov    %rsp,%rbp
  801e33:	48 83 ec 08          	sub    $0x8,%rsp
  801e37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3f:	48 89 c7             	mov    %rax,%rdi
  801e42:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  801e49:	00 00 00 
  801e4c:	ff d0                	callq  *%rax
  801e4e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e54:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e58:	c9                   	leaveq 
  801e59:	c3                   	retq   

0000000000801e5a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e5a:	55                   	push   %rbp
  801e5b:	48 89 e5             	mov    %rsp,%rbp
  801e5e:	48 83 ec 18          	sub    $0x18,%rsp
  801e62:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e6d:	eb 6b                	jmp    801eda <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e72:	48 98                	cltq   
  801e74:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e7a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e86:	48 89 c2             	mov    %rax,%rdx
  801e89:	48 c1 ea 15          	shr    $0x15,%rdx
  801e8d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e94:	01 00 00 
  801e97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9b:	83 e0 01             	and    $0x1,%eax
  801e9e:	48 85 c0             	test   %rax,%rax
  801ea1:	74 21                	je     801ec4 <fd_alloc+0x6a>
  801ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea7:	48 89 c2             	mov    %rax,%rdx
  801eaa:	48 c1 ea 0c          	shr    $0xc,%rdx
  801eae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb5:	01 00 00 
  801eb8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ebc:	83 e0 01             	and    $0x1,%eax
  801ebf:	48 85 c0             	test   %rax,%rax
  801ec2:	75 12                	jne    801ed6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ecc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	eb 1a                	jmp    801ef0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ed6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eda:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ede:	7e 8f                	jle    801e6f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eeb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ef0:	c9                   	leaveq 
  801ef1:	c3                   	retq   

0000000000801ef2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ef2:	55                   	push   %rbp
  801ef3:	48 89 e5             	mov    %rsp,%rbp
  801ef6:	48 83 ec 20          	sub    $0x20,%rsp
  801efa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801efd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f01:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801f05:	78 06                	js     801f0d <fd_lookup+0x1b>
  801f07:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801f0b:	7e 07                	jle    801f14 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f12:	eb 6c                	jmp    801f80 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801f14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f17:	48 98                	cltq   
  801f19:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801f1f:	48 c1 e0 0c          	shl    $0xc,%rax
  801f23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f2b:	48 89 c2             	mov    %rax,%rdx
  801f2e:	48 c1 ea 15          	shr    $0x15,%rdx
  801f32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f39:	01 00 00 
  801f3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f40:	83 e0 01             	and    $0x1,%eax
  801f43:	48 85 c0             	test   %rax,%rax
  801f46:	74 21                	je     801f69 <fd_lookup+0x77>
  801f48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f4c:	48 89 c2             	mov    %rax,%rdx
  801f4f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f5a:	01 00 00 
  801f5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f61:	83 e0 01             	and    $0x1,%eax
  801f64:	48 85 c0             	test   %rax,%rax
  801f67:	75 07                	jne    801f70 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f6e:	eb 10                	jmp    801f80 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f74:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f78:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f80:	c9                   	leaveq 
  801f81:	c3                   	retq   

0000000000801f82 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	48 83 ec 30          	sub    $0x30,%rsp
  801f8a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f8e:	89 f0                	mov    %esi,%eax
  801f90:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f97:	48 89 c7             	mov    %rax,%rdi
  801f9a:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  801fa1:	00 00 00 
  801fa4:	ff d0                	callq  *%rax
  801fa6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801faa:	48 89 d6             	mov    %rdx,%rsi
  801fad:	89 c7                	mov    %eax,%edi
  801faf:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  801fb6:	00 00 00 
  801fb9:	ff d0                	callq  *%rax
  801fbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc2:	78 0a                	js     801fce <fd_close+0x4c>
	    || fd != fd2)
  801fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fc8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fcc:	74 12                	je     801fe0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fce:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fd2:	74 05                	je     801fd9 <fd_close+0x57>
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd7:	eb 05                	jmp    801fde <fd_close+0x5c>
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fde:	eb 69                	jmp    802049 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fe0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe4:	8b 00                	mov    (%rax),%eax
  801fe6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fea:	48 89 d6             	mov    %rdx,%rsi
  801fed:	89 c7                	mov    %eax,%edi
  801fef:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  801ff6:	00 00 00 
  801ff9:	ff d0                	callq  *%rax
  801ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802002:	78 2a                	js     80202e <fd_close+0xac>
		if (dev->dev_close)
  802004:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802008:	48 8b 40 20          	mov    0x20(%rax),%rax
  80200c:	48 85 c0             	test   %rax,%rax
  80200f:	74 16                	je     802027 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802015:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802019:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201d:	48 89 c7             	mov    %rax,%rdi
  802020:	ff d2                	callq  *%rdx
  802022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802025:	eb 07                	jmp    80202e <fd_close+0xac>
		else
			r = 0;
  802027:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80202e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802032:	48 89 c6             	mov    %rax,%rsi
  802035:	bf 00 00 00 00       	mov    $0x0,%edi
  80203a:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  802041:	00 00 00 
  802044:	ff d0                	callq  *%rax
	return r;
  802046:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 20          	sub    $0x20,%rsp
  802053:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802056:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80205a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802061:	eb 41                	jmp    8020a4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802063:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80206a:	00 00 00 
  80206d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802070:	48 63 d2             	movslq %edx,%rdx
  802073:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802077:	8b 00                	mov    (%rax),%eax
  802079:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80207c:	75 22                	jne    8020a0 <dev_lookup+0x55>
			*dev = devtab[i];
  80207e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802085:	00 00 00 
  802088:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80208b:	48 63 d2             	movslq %edx,%rdx
  80208e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802096:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	eb 60                	jmp    802100 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020a4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8020ab:	00 00 00 
  8020ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020b1:	48 63 d2             	movslq %edx,%rdx
  8020b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b8:	48 85 c0             	test   %rax,%rax
  8020bb:	75 a6                	jne    802063 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8020bd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8020c4:	00 00 00 
  8020c7:	48 8b 00             	mov    (%rax),%rax
  8020ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020d0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020d3:	89 c6                	mov    %eax,%esi
  8020d5:	48 bf 18 44 80 00 00 	movabs $0x804418,%rdi
  8020dc:	00 00 00 
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  8020eb:	00 00 00 
  8020ee:	ff d1                	callq  *%rcx
	*dev = 0;
  8020f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802100:	c9                   	leaveq 
  802101:	c3                   	retq   

0000000000802102 <close>:

int
close(int fdnum)
{
  802102:	55                   	push   %rbp
  802103:	48 89 e5             	mov    %rsp,%rbp
  802106:	48 83 ec 20          	sub    $0x20,%rsp
  80210a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802111:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802114:	48 89 d6             	mov    %rdx,%rsi
  802117:	89 c7                	mov    %eax,%edi
  802119:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802128:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212c:	79 05                	jns    802133 <close+0x31>
		return r;
  80212e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802131:	eb 18                	jmp    80214b <close+0x49>
	else
		return fd_close(fd, 1);
  802133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802137:	be 01 00 00 00       	mov    $0x1,%esi
  80213c:	48 89 c7             	mov    %rax,%rdi
  80213f:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  802146:	00 00 00 
  802149:	ff d0                	callq  *%rax
}
  80214b:	c9                   	leaveq 
  80214c:	c3                   	retq   

000000000080214d <close_all>:

void
close_all(void)
{
  80214d:	55                   	push   %rbp
  80214e:	48 89 e5             	mov    %rsp,%rbp
  802151:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802155:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80215c:	eb 15                	jmp    802173 <close_all+0x26>
		close(i);
  80215e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802161:	89 c7                	mov    %eax,%edi
  802163:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80216f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802173:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802177:	7e e5                	jle    80215e <close_all+0x11>
		close(i);
}
  802179:	c9                   	leaveq 
  80217a:	c3                   	retq   

000000000080217b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80217b:	55                   	push   %rbp
  80217c:	48 89 e5             	mov    %rsp,%rbp
  80217f:	48 83 ec 40          	sub    $0x40,%rsp
  802183:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802186:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802189:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80218d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802190:	48 89 d6             	mov    %rdx,%rsi
  802193:	89 c7                	mov    %eax,%edi
  802195:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80219c:	00 00 00 
  80219f:	ff d0                	callq  *%rax
  8021a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021a8:	79 08                	jns    8021b2 <dup+0x37>
		return r;
  8021aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ad:	e9 70 01 00 00       	jmpq   802322 <dup+0x1a7>
	close(newfdnum);
  8021b2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021b5:	89 c7                	mov    %eax,%edi
  8021b7:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8021c3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021c6:	48 98                	cltq   
  8021c8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021ce:	48 c1 e0 0c          	shl    $0xc,%rax
  8021d2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021da:	48 89 c7             	mov    %rax,%rdi
  8021dd:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  8021e4:	00 00 00 
  8021e7:	ff d0                	callq  *%rax
  8021e9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f1:	48 89 c7             	mov    %rax,%rdi
  8021f4:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  8021fb:	00 00 00 
  8021fe:	ff d0                	callq  *%rax
  802200:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802208:	48 89 c2             	mov    %rax,%rdx
  80220b:	48 c1 ea 15          	shr    $0x15,%rdx
  80220f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802216:	01 00 00 
  802219:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221d:	83 e0 01             	and    $0x1,%eax
  802220:	84 c0                	test   %al,%al
  802222:	74 71                	je     802295 <dup+0x11a>
  802224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802228:	48 89 c2             	mov    %rax,%rdx
  80222b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80222f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802236:	01 00 00 
  802239:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80223d:	83 e0 01             	and    $0x1,%eax
  802240:	84 c0                	test   %al,%al
  802242:	74 51                	je     802295 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	48 89 c2             	mov    %rax,%rdx
  80224b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80224f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802256:	01 00 00 
  802259:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80225d:	89 c1                	mov    %eax,%ecx
  80225f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802265:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226d:	41 89 c8             	mov    %ecx,%r8d
  802270:	48 89 d1             	mov    %rdx,%rcx
  802273:	ba 00 00 00 00       	mov    $0x0,%edx
  802278:	48 89 c6             	mov    %rax,%rsi
  80227b:	bf 00 00 00 00       	mov    $0x0,%edi
  802280:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  802287:	00 00 00 
  80228a:	ff d0                	callq  *%rax
  80228c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80228f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802293:	78 56                	js     8022eb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802299:	48 89 c2             	mov    %rax,%rdx
  80229c:	48 c1 ea 0c          	shr    $0xc,%rdx
  8022a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022a7:	01 00 00 
  8022aa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022ae:	89 c1                	mov    %eax,%ecx
  8022b0:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8022b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022be:	41 89 c8             	mov    %ecx,%r8d
  8022c1:	48 89 d1             	mov    %rdx,%rcx
  8022c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c9:	48 89 c6             	mov    %rax,%rsi
  8022cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d1:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	78 08                	js     8022ee <dup+0x173>
		goto err;

	return newfdnum;
  8022e6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022e9:	eb 37                	jmp    802322 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022eb:	90                   	nop
  8022ec:	eb 01                	jmp    8022ef <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022ee:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f3:	48 89 c6             	mov    %rax,%rsi
  8022f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8022fb:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  802302:	00 00 00 
  802305:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80230b:	48 89 c6             	mov    %rax,%rsi
  80230e:	bf 00 00 00 00       	mov    $0x0,%edi
  802313:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
	return r;
  80231f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802322:	c9                   	leaveq 
  802323:	c3                   	retq   

0000000000802324 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802324:	55                   	push   %rbp
  802325:	48 89 e5             	mov    %rsp,%rbp
  802328:	48 83 ec 40          	sub    $0x40,%rsp
  80232c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80232f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802333:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802337:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80233b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80233e:	48 89 d6             	mov    %rdx,%rsi
  802341:	89 c7                	mov    %eax,%edi
  802343:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80234a:	00 00 00 
  80234d:	ff d0                	callq  *%rax
  80234f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802356:	78 24                	js     80237c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80235c:	8b 00                	mov    (%rax),%eax
  80235e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802362:	48 89 d6             	mov    %rdx,%rsi
  802365:	89 c7                	mov    %eax,%edi
  802367:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax
  802373:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802376:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80237a:	79 05                	jns    802381 <read+0x5d>
		return r;
  80237c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237f:	eb 7a                	jmp    8023fb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802381:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802385:	8b 40 08             	mov    0x8(%rax),%eax
  802388:	83 e0 03             	and    $0x3,%eax
  80238b:	83 f8 01             	cmp    $0x1,%eax
  80238e:	75 3a                	jne    8023ca <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802390:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802397:	00 00 00 
  80239a:	48 8b 00             	mov    (%rax),%rax
  80239d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023a3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023a6:	89 c6                	mov    %eax,%esi
  8023a8:	48 bf 37 44 80 00 00 	movabs $0x804437,%rdi
  8023af:	00 00 00 
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b7:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  8023be:	00 00 00 
  8023c1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023c8:	eb 31                	jmp    8023fb <read+0xd7>
	}
	if (!dev->dev_read)
  8023ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023d2:	48 85 c0             	test   %rax,%rax
  8023d5:	75 07                	jne    8023de <read+0xba>
		return -E_NOT_SUPP;
  8023d7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023dc:	eb 1d                	jmp    8023fb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8023de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8023e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023ee:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023f2:	48 89 ce             	mov    %rcx,%rsi
  8023f5:	48 89 c7             	mov    %rax,%rdi
  8023f8:	41 ff d0             	callq  *%r8
}
  8023fb:	c9                   	leaveq 
  8023fc:	c3                   	retq   

00000000008023fd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023fd:	55                   	push   %rbp
  8023fe:	48 89 e5             	mov    %rsp,%rbp
  802401:	48 83 ec 30          	sub    $0x30,%rsp
  802405:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802408:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80240c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802417:	eb 46                	jmp    80245f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241c:	48 98                	cltq   
  80241e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802422:	48 29 c2             	sub    %rax,%rdx
  802425:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802428:	48 98                	cltq   
  80242a:	48 89 c1             	mov    %rax,%rcx
  80242d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802431:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802434:	48 89 ce             	mov    %rcx,%rsi
  802437:	89 c7                	mov    %eax,%edi
  802439:	48 b8 24 23 80 00 00 	movabs $0x802324,%rax
  802440:	00 00 00 
  802443:	ff d0                	callq  *%rax
  802445:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802448:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80244c:	79 05                	jns    802453 <readn+0x56>
			return m;
  80244e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802451:	eb 1d                	jmp    802470 <readn+0x73>
		if (m == 0)
  802453:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802457:	74 13                	je     80246c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802459:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80245c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80245f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802462:	48 98                	cltq   
  802464:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802468:	72 af                	jb     802419 <readn+0x1c>
  80246a:	eb 01                	jmp    80246d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80246c:	90                   	nop
	}
	return tot;
  80246d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802470:	c9                   	leaveq 
  802471:	c3                   	retq   

0000000000802472 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802472:	55                   	push   %rbp
  802473:	48 89 e5             	mov    %rsp,%rbp
  802476:	48 83 ec 40          	sub    $0x40,%rsp
  80247a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802481:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802485:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802489:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80248c:	48 89 d6             	mov    %rdx,%rsi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a4:	78 24                	js     8024ca <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024aa:	8b 00                	mov    (%rax),%eax
  8024ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024b0:	48 89 d6             	mov    %rdx,%rsi
  8024b3:	89 c7                	mov    %eax,%edi
  8024b5:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8024bc:	00 00 00 
  8024bf:	ff d0                	callq  *%rax
  8024c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c8:	79 05                	jns    8024cf <write+0x5d>
		return r;
  8024ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024cd:	eb 79                	jmp    802548 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024d3:	8b 40 08             	mov    0x8(%rax),%eax
  8024d6:	83 e0 03             	and    $0x3,%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 3a                	jne    802517 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024dd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8024e4:	00 00 00 
  8024e7:	48 8b 00             	mov    (%rax),%rax
  8024ea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024f0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024f3:	89 c6                	mov    %eax,%esi
  8024f5:	48 bf 53 44 80 00 00 	movabs $0x804453,%rdi
  8024fc:	00 00 00 
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  80250b:	00 00 00 
  80250e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802510:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802515:	eb 31                	jmp    802548 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80251b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80251f:	48 85 c0             	test   %rax,%rax
  802522:	75 07                	jne    80252b <write+0xb9>
		return -E_NOT_SUPP;
  802524:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802529:	eb 1d                	jmp    802548 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  80252b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802537:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80253b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80253f:	48 89 ce             	mov    %rcx,%rsi
  802542:	48 89 c7             	mov    %rax,%rdi
  802545:	41 ff d0             	callq  *%r8
}
  802548:	c9                   	leaveq 
  802549:	c3                   	retq   

000000000080254a <seek>:

int
seek(int fdnum, off_t offset)
{
  80254a:	55                   	push   %rbp
  80254b:	48 89 e5             	mov    %rsp,%rbp
  80254e:	48 83 ec 18          	sub    $0x18,%rsp
  802552:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802555:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802558:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80255c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80255f:	48 89 d6             	mov    %rdx,%rsi
  802562:	89 c7                	mov    %eax,%edi
  802564:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80256b:	00 00 00 
  80256e:	ff d0                	callq  *%rax
  802570:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802573:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802577:	79 05                	jns    80257e <seek+0x34>
		return r;
  802579:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257c:	eb 0f                	jmp    80258d <seek+0x43>
	fd->fd_offset = offset;
  80257e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802582:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802585:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258d:	c9                   	leaveq 
  80258e:	c3                   	retq   

000000000080258f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80258f:	55                   	push   %rbp
  802590:	48 89 e5             	mov    %rsp,%rbp
  802593:	48 83 ec 30          	sub    $0x30,%rsp
  802597:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80259a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80259d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025a4:	48 89 d6             	mov    %rdx,%rsi
  8025a7:	89 c7                	mov    %eax,%edi
  8025a9:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  8025b0:	00 00 00 
  8025b3:	ff d0                	callq  *%rax
  8025b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025bc:	78 24                	js     8025e2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c2:	8b 00                	mov    (%rax),%eax
  8025c4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025c8:	48 89 d6             	mov    %rdx,%rsi
  8025cb:	89 c7                	mov    %eax,%edi
  8025cd:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8025d4:	00 00 00 
  8025d7:	ff d0                	callq  *%rax
  8025d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e0:	79 05                	jns    8025e7 <ftruncate+0x58>
		return r;
  8025e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e5:	eb 72                	jmp    802659 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	8b 40 08             	mov    0x8(%rax),%eax
  8025ee:	83 e0 03             	and    $0x3,%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	75 3a                	jne    80262f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025f5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8025fc:	00 00 00 
  8025ff:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802602:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802608:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80260b:	89 c6                	mov    %eax,%esi
  80260d:	48 bf 70 44 80 00 00 	movabs $0x804470,%rdi
  802614:	00 00 00 
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
  80261c:	48 b9 87 04 80 00 00 	movabs $0x800487,%rcx
  802623:	00 00 00 
  802626:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802628:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80262d:	eb 2a                	jmp    802659 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80262f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802633:	48 8b 40 30          	mov    0x30(%rax),%rax
  802637:	48 85 c0             	test   %rax,%rax
  80263a:	75 07                	jne    802643 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80263c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802641:	eb 16                	jmp    802659 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802647:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80264b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802652:	89 d6                	mov    %edx,%esi
  802654:	48 89 c7             	mov    %rax,%rdi
  802657:	ff d1                	callq  *%rcx
}
  802659:	c9                   	leaveq 
  80265a:	c3                   	retq   

000000000080265b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80265b:	55                   	push   %rbp
  80265c:	48 89 e5             	mov    %rsp,%rbp
  80265f:	48 83 ec 30          	sub    $0x30,%rsp
  802663:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802666:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80266a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80266e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802671:	48 89 d6             	mov    %rdx,%rsi
  802674:	89 c7                	mov    %eax,%edi
  802676:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80267d:	00 00 00 
  802680:	ff d0                	callq  *%rax
  802682:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802685:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802689:	78 24                	js     8026af <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80268b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268f:	8b 00                	mov    (%rax),%eax
  802691:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802695:	48 89 d6             	mov    %rdx,%rsi
  802698:	89 c7                	mov    %eax,%edi
  80269a:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8026a1:	00 00 00 
  8026a4:	ff d0                	callq  *%rax
  8026a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ad:	79 05                	jns    8026b4 <fstat+0x59>
		return r;
  8026af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b2:	eb 5e                	jmp    802712 <fstat+0xb7>
	if (!dev->dev_stat)
  8026b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026b8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026bc:	48 85 c0             	test   %rax,%rax
  8026bf:	75 07                	jne    8026c8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8026c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026c6:	eb 4a                	jmp    802712 <fstat+0xb7>
	stat->st_name[0] = 0;
  8026c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026cc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026d3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026da:	00 00 00 
	stat->st_isdir = 0;
  8026dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026e1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026e8:	00 00 00 
	stat->st_dev = dev;
  8026eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026f3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026fe:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802706:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80270a:	48 89 d6             	mov    %rdx,%rsi
  80270d:	48 89 c7             	mov    %rax,%rdi
  802710:	ff d1                	callq  *%rcx
}
  802712:	c9                   	leaveq 
  802713:	c3                   	retq   

0000000000802714 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802714:	55                   	push   %rbp
  802715:	48 89 e5             	mov    %rsp,%rbp
  802718:	48 83 ec 20          	sub    $0x20,%rsp
  80271c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802720:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802728:	be 00 00 00 00       	mov    $0x0,%esi
  80272d:	48 89 c7             	mov    %rax,%rdi
  802730:	48 b8 03 28 80 00 00 	movabs $0x802803,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802743:	79 05                	jns    80274a <stat+0x36>
		return fd;
  802745:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802748:	eb 2f                	jmp    802779 <stat+0x65>
	r = fstat(fd, stat);
  80274a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80274e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802751:	48 89 d6             	mov    %rdx,%rsi
  802754:	89 c7                	mov    %eax,%edi
  802756:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  80275d:	00 00 00 
  802760:	ff d0                	callq  *%rax
  802762:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802765:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802768:	89 c7                	mov    %eax,%edi
  80276a:	48 b8 02 21 80 00 00 	movabs $0x802102,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
	return r;
  802776:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802779:	c9                   	leaveq 
  80277a:	c3                   	retq   
	...

000000000080277c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80277c:	55                   	push   %rbp
  80277d:	48 89 e5             	mov    %rsp,%rbp
  802780:	48 83 ec 10          	sub    $0x10,%rsp
  802784:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802787:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80278b:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802792:	00 00 00 
  802795:	8b 00                	mov    (%rax),%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	75 1d                	jne    8027b8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80279b:	bf 01 00 00 00       	mov    $0x1,%edi
  8027a0:	48 b8 1f 3d 80 00 00 	movabs $0x803d1f,%rax
  8027a7:	00 00 00 
  8027aa:	ff d0                	callq  *%rax
  8027ac:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  8027b3:	00 00 00 
  8027b6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8027b8:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  8027bf:	00 00 00 
  8027c2:	8b 00                	mov    (%rax),%eax
  8027c4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8027c7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027cc:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027d3:	00 00 00 
  8027d6:	89 c7                	mov    %eax,%edi
  8027d8:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ed:	48 89 c6             	mov    %rax,%rsi
  8027f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f5:	48 b8 9c 3b 80 00 00 	movabs $0x803b9c,%rax
  8027fc:	00 00 00 
  8027ff:	ff d0                	callq  *%rax
}
  802801:	c9                   	leaveq 
  802802:	c3                   	retq   

0000000000802803 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802803:	55                   	push   %rbp
  802804:	48 89 e5             	mov    %rsp,%rbp
  802807:	48 83 ec 20          	sub    $0x20,%rsp
  80280b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80280f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802816:	48 89 c7             	mov    %rax,%rdi
  802819:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80282a:	7e 0a                	jle    802836 <open+0x33>
                return -E_BAD_PATH;
  80282c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802831:	e9 a5 00 00 00       	jmpq   8028db <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802836:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80283a:	48 89 c7             	mov    %rax,%rdi
  80283d:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax
  802849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802850:	79 08                	jns    80285a <open+0x57>
		return r;
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802855:	e9 81 00 00 00       	jmpq   8028db <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80285a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80285e:	48 89 c6             	mov    %rax,%rsi
  802861:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802868:	00 00 00 
  80286b:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802877:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80287e:	00 00 00 
  802881:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802884:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80288a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288e:	48 89 c6             	mov    %rax,%rsi
  802891:	bf 01 00 00 00       	mov    $0x1,%edi
  802896:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  80289d:	00 00 00 
  8028a0:	ff d0                	callq  *%rax
  8028a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8028a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a9:	79 1d                	jns    8028c8 <open+0xc5>
	{
		fd_close(fd,0);
  8028ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028af:	be 00 00 00 00       	mov    $0x0,%esi
  8028b4:	48 89 c7             	mov    %rax,%rdi
  8028b7:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  8028be:	00 00 00 
  8028c1:	ff d0                	callq  *%rax
		return r;
  8028c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c6:	eb 13                	jmp    8028db <open+0xd8>
	}
	return fd2num(fd);
  8028c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028cc:	48 89 c7             	mov    %rax,%rdi
  8028cf:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  8028d6:	00 00 00 
  8028d9:	ff d0                	callq  *%rax
	


}
  8028db:	c9                   	leaveq 
  8028dc:	c3                   	retq   

00000000008028dd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028dd:	55                   	push   %rbp
  8028de:	48 89 e5             	mov    %rsp,%rbp
  8028e1:	48 83 ec 10          	sub    $0x10,%rsp
  8028e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028f7:	00 00 00 
  8028fa:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028fc:	be 00 00 00 00       	mov    $0x0,%esi
  802901:	bf 06 00 00 00       	mov    $0x6,%edi
  802906:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
}
  802912:	c9                   	leaveq 
  802913:	c3                   	retq   

0000000000802914 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802914:	55                   	push   %rbp
  802915:	48 89 e5             	mov    %rsp,%rbp
  802918:	48 83 ec 30          	sub    $0x30,%rsp
  80291c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802920:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802924:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292c:	8b 50 0c             	mov    0xc(%rax),%edx
  80292f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802936:	00 00 00 
  802939:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80293b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802942:	00 00 00 
  802945:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802949:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80294d:	be 00 00 00 00       	mov    $0x0,%esi
  802952:	bf 03 00 00 00       	mov    $0x3,%edi
  802957:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax
  802963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802966:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296a:	79 05                	jns    802971 <devfile_read+0x5d>
	{
		return r;
  80296c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296f:	eb 2c                	jmp    80299d <devfile_read+0x89>
	}
	if(r > 0)
  802971:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802975:	7e 23                	jle    80299a <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297a:	48 63 d0             	movslq %eax,%rdx
  80297d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802981:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802988:	00 00 00 
  80298b:	48 89 c7             	mov    %rax,%rdi
  80298e:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  802995:	00 00 00 
  802998:	ff d0                	callq  *%rax
	return r;
  80299a:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  80299d:	c9                   	leaveq 
  80299e:	c3                   	retq   

000000000080299f <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80299f:	55                   	push   %rbp
  8029a0:	48 89 e5             	mov    %rsp,%rbp
  8029a3:	48 83 ec 30          	sub    $0x30,%rsp
  8029a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8029b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ba:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029c1:	00 00 00 
  8029c4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8029c6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029cd:	00 
  8029ce:	76 08                	jbe    8029d8 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8029d0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029d7:	00 
	fsipcbuf.write.req_n=n;
  8029d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029df:	00 00 00 
  8029e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029f2:	48 89 c6             	mov    %rax,%rsi
  8029f5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029fc:	00 00 00 
  8029ff:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802a0b:	be 00 00 00 00       	mov    $0x0,%esi
  802a10:	bf 04 00 00 00       	mov    $0x4,%edi
  802a15:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
  802a21:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 10          	sub    $0x10,%rsp
  802a31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a35:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3c:	8b 50 0c             	mov    0xc(%rax),%edx
  802a3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a46:	00 00 00 
  802a49:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802a4b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a52:	00 00 00 
  802a55:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a58:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a5b:	be 00 00 00 00       	mov    $0x0,%esi
  802a60:	bf 02 00 00 00       	mov    $0x2,%edi
  802a65:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802a6c:	00 00 00 
  802a6f:	ff d0                	callq  *%rax
}
  802a71:	c9                   	leaveq 
  802a72:	c3                   	retq   

0000000000802a73 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a73:	55                   	push   %rbp
  802a74:	48 89 e5             	mov    %rsp,%rbp
  802a77:	48 83 ec 20          	sub    $0x20,%rsp
  802a7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a87:	8b 50 0c             	mov    0xc(%rax),%edx
  802a8a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a91:	00 00 00 
  802a94:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a96:	be 00 00 00 00       	mov    $0x0,%esi
  802a9b:	bf 05 00 00 00       	mov    $0x5,%edi
  802aa0:	48 b8 7c 27 80 00 00 	movabs $0x80277c,%rax
  802aa7:	00 00 00 
  802aaa:	ff d0                	callq  *%rax
  802aac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab3:	79 05                	jns    802aba <devfile_stat+0x47>
		return r;
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	eb 56                	jmp    802b10 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802aba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abe:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802ac5:	00 00 00 
  802ac8:	48 89 c7             	mov    %rax,%rdi
  802acb:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ad7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ade:	00 00 00 
  802ae1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802ae7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aeb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802af1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802af8:	00 00 00 
  802afb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b05:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b10:	c9                   	leaveq 
  802b11:	c3                   	retq   
	...

0000000000802b14 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802b14:	55                   	push   %rbp
  802b15:	48 89 e5             	mov    %rsp,%rbp
  802b18:	48 83 ec 20          	sub    $0x20,%rsp
  802b1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802b1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b26:	48 89 d6             	mov    %rdx,%rsi
  802b29:	89 c7                	mov    %eax,%edi
  802b2b:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
  802b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b3e:	79 05                	jns    802b45 <fd2sockid+0x31>
		return r;
  802b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b43:	eb 24                	jmp    802b69 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b49:	8b 10                	mov    (%rax),%edx
  802b4b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802b52:	00 00 00 
  802b55:	8b 00                	mov    (%rax),%eax
  802b57:	39 c2                	cmp    %eax,%edx
  802b59:	74 07                	je     802b62 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802b5b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b60:	eb 07                	jmp    802b69 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b66:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 20          	sub    $0x20,%rsp
  802b73:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b76:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b7a:	48 89 c7             	mov    %rax,%rdi
  802b7d:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  802b84:	00 00 00 
  802b87:	ff d0                	callq  *%rax
  802b89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b90:	78 26                	js     802bb8 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b96:	ba 07 04 00 00       	mov    $0x407,%edx
  802b9b:	48 89 c6             	mov    %rax,%rsi
  802b9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ba3:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  802baa:	00 00 00 
  802bad:	ff d0                	callq  *%rax
  802baf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb6:	79 16                	jns    802bce <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802bb8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 78 30 80 00 00 	movabs $0x803078,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
		return r;
  802bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcc:	eb 3a                	jmp    802c08 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802bce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802bd9:	00 00 00 
  802bdc:	8b 12                	mov    (%rdx),%edx
  802bde:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802be4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bef:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bf2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf9:	48 89 c7             	mov    %rax,%rdi
  802bfc:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  802c03:	00 00 00 
  802c06:	ff d0                	callq  *%rax
}
  802c08:	c9                   	leaveq 
  802c09:	c3                   	retq   

0000000000802c0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c0a:	55                   	push   %rbp
  802c0b:	48 89 e5             	mov    %rsp,%rbp
  802c0e:	48 83 ec 30          	sub    $0x30,%rsp
  802c12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c19:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c20:	89 c7                	mov    %eax,%edi
  802c22:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802c29:	00 00 00 
  802c2c:	ff d0                	callq  *%rax
  802c2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c35:	79 05                	jns    802c3c <accept+0x32>
		return r;
  802c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3a:	eb 3b                	jmp    802c77 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c3c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c40:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c47:	48 89 ce             	mov    %rcx,%rsi
  802c4a:	89 c7                	mov    %eax,%edi
  802c4c:	48 b8 55 2f 80 00 00 	movabs $0x802f55,%rax
  802c53:	00 00 00 
  802c56:	ff d0                	callq  *%rax
  802c58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5f:	79 05                	jns    802c66 <accept+0x5c>
		return r;
  802c61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c64:	eb 11                	jmp    802c77 <accept+0x6d>
	return alloc_sockfd(r);
  802c66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c69:	89 c7                	mov    %eax,%edi
  802c6b:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
}
  802c77:	c9                   	leaveq 
  802c78:	c3                   	retq   

0000000000802c79 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c79:	55                   	push   %rbp
  802c7a:	48 89 e5             	mov    %rsp,%rbp
  802c7d:	48 83 ec 20          	sub    $0x20,%rsp
  802c81:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c84:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c88:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8e:	89 c7                	mov    %eax,%edi
  802c90:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca3:	79 05                	jns    802caa <bind+0x31>
		return r;
  802ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca8:	eb 1b                	jmp    802cc5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802caa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cad:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802cb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cb4:	48 89 ce             	mov    %rcx,%rsi
  802cb7:	89 c7                	mov    %eax,%edi
  802cb9:	48 b8 d4 2f 80 00 00 	movabs $0x802fd4,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
}
  802cc5:	c9                   	leaveq 
  802cc6:	c3                   	retq   

0000000000802cc7 <shutdown>:

int
shutdown(int s, int how)
{
  802cc7:	55                   	push   %rbp
  802cc8:	48 89 e5             	mov    %rsp,%rbp
  802ccb:	48 83 ec 20          	sub    $0x20,%rsp
  802ccf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cd2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cd5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd8:	89 c7                	mov    %eax,%edi
  802cda:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802ce1:	00 00 00 
  802ce4:	ff d0                	callq  *%rax
  802ce6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ced:	79 05                	jns    802cf4 <shutdown+0x2d>
		return r;
  802cef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf2:	eb 16                	jmp    802d0a <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802cf4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfa:	89 d6                	mov    %edx,%esi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 38 30 80 00 00 	movabs $0x803038,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
}
  802d0a:	c9                   	leaveq 
  802d0b:	c3                   	retq   

0000000000802d0c <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802d0c:	55                   	push   %rbp
  802d0d:	48 89 e5             	mov    %rsp,%rbp
  802d10:	48 83 ec 10          	sub    $0x10,%rsp
  802d14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1c:	48 89 c7             	mov    %rax,%rdi
  802d1f:	48 b8 a4 3d 80 00 00 	movabs $0x803da4,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
  802d2b:	83 f8 01             	cmp    $0x1,%eax
  802d2e:	75 17                	jne    802d47 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d34:	8b 40 0c             	mov    0xc(%rax),%eax
  802d37:	89 c7                	mov    %eax,%edi
  802d39:	48 b8 78 30 80 00 00 	movabs $0x803078,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
  802d45:	eb 05                	jmp    802d4c <devsock_close+0x40>
	else
		return 0;
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4c:	c9                   	leaveq 
  802d4d:	c3                   	retq   

0000000000802d4e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d4e:	55                   	push   %rbp
  802d4f:	48 89 e5             	mov    %rsp,%rbp
  802d52:	48 83 ec 20          	sub    $0x20,%rsp
  802d56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d5d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d63:	89 c7                	mov    %eax,%edi
  802d65:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802d6c:	00 00 00 
  802d6f:	ff d0                	callq  *%rax
  802d71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d78:	79 05                	jns    802d7f <connect+0x31>
		return r;
  802d7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7d:	eb 1b                	jmp    802d9a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d7f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d82:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d89:	48 89 ce             	mov    %rcx,%rsi
  802d8c:	89 c7                	mov    %eax,%edi
  802d8e:	48 b8 a5 30 80 00 00 	movabs $0x8030a5,%rax
  802d95:	00 00 00 
  802d98:	ff d0                	callq  *%rax
}
  802d9a:	c9                   	leaveq 
  802d9b:	c3                   	retq   

0000000000802d9c <listen>:

int
listen(int s, int backlog)
{
  802d9c:	55                   	push   %rbp
  802d9d:	48 89 e5             	mov    %rsp,%rbp
  802da0:	48 83 ec 20          	sub    $0x20,%rsp
  802da4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802da7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dad:	89 c7                	mov    %eax,%edi
  802daf:	48 b8 14 2b 80 00 00 	movabs $0x802b14,%rax
  802db6:	00 00 00 
  802db9:	ff d0                	callq  *%rax
  802dbb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc2:	79 05                	jns    802dc9 <listen+0x2d>
		return r;
  802dc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc7:	eb 16                	jmp    802ddf <listen+0x43>
	return nsipc_listen(r, backlog);
  802dc9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcf:	89 d6                	mov    %edx,%esi
  802dd1:	89 c7                	mov    %eax,%edi
  802dd3:	48 b8 09 31 80 00 00 	movabs $0x803109,%rax
  802dda:	00 00 00 
  802ddd:	ff d0                	callq  *%rax
}
  802ddf:	c9                   	leaveq 
  802de0:	c3                   	retq   

0000000000802de1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802de1:	55                   	push   %rbp
  802de2:	48 89 e5             	mov    %rsp,%rbp
  802de5:	48 83 ec 20          	sub    $0x20,%rsp
  802de9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ded:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802df1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df9:	89 c2                	mov    %eax,%edx
  802dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dff:	8b 40 0c             	mov    0xc(%rax),%eax
  802e02:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e06:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e0b:	89 c7                	mov    %eax,%edi
  802e0d:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
}
  802e19:	c9                   	leaveq 
  802e1a:	c3                   	retq   

0000000000802e1b <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802e1b:	55                   	push   %rbp
  802e1c:	48 89 e5             	mov    %rsp,%rbp
  802e1f:	48 83 ec 20          	sub    $0x20,%rsp
  802e23:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e27:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802e2b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e33:	89 c2                	mov    %eax,%edx
  802e35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e39:	8b 40 0c             	mov    0xc(%rax),%eax
  802e3c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e40:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e45:	89 c7                	mov    %eax,%edi
  802e47:	48 b8 15 32 80 00 00 	movabs $0x803215,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
}
  802e53:	c9                   	leaveq 
  802e54:	c3                   	retq   

0000000000802e55 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e55:	55                   	push   %rbp
  802e56:	48 89 e5             	mov    %rsp,%rbp
  802e59:	48 83 ec 10          	sub    $0x10,%rsp
  802e5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e69:	48 be 9b 44 80 00 00 	movabs $0x80449b,%rsi
  802e70:	00 00 00 
  802e73:	48 89 c7             	mov    %rax,%rdi
  802e76:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  802e7d:	00 00 00 
  802e80:	ff d0                	callq  *%rax
	return 0;
  802e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <socket>:

int
socket(int domain, int type, int protocol)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 20          	sub    $0x20,%rsp
  802e91:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e94:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e97:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e9a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e9d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ea0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea3:	89 ce                	mov    %ecx,%esi
  802ea5:	89 c7                	mov    %eax,%edi
  802ea7:	48 b8 cd 32 80 00 00 	movabs $0x8032cd,%rax
  802eae:	00 00 00 
  802eb1:	ff d0                	callq  *%rax
  802eb3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eba:	79 05                	jns    802ec1 <socket+0x38>
		return r;
  802ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ebf:	eb 11                	jmp    802ed2 <socket+0x49>
	return alloc_sockfd(r);
  802ec1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec4:	89 c7                	mov    %eax,%edi
  802ec6:	48 b8 6b 2b 80 00 00 	movabs $0x802b6b,%rax
  802ecd:	00 00 00 
  802ed0:	ff d0                	callq  *%rax
}
  802ed2:	c9                   	leaveq 
  802ed3:	c3                   	retq   

0000000000802ed4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802ed4:	55                   	push   %rbp
  802ed5:	48 89 e5             	mov    %rsp,%rbp
  802ed8:	48 83 ec 10          	sub    $0x10,%rsp
  802edc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802edf:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  802ee6:	00 00 00 
  802ee9:	8b 00                	mov    (%rax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	75 1d                	jne    802f0c <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802eef:	bf 02 00 00 00       	mov    $0x2,%edi
  802ef4:	48 b8 1f 3d 80 00 00 	movabs $0x803d1f,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  802f07:	00 00 00 
  802f0a:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802f0c:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  802f13:	00 00 00 
  802f16:	8b 00                	mov    (%rax),%eax
  802f18:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f1b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f20:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802f27:	00 00 00 
  802f2a:	89 c7                	mov    %eax,%edi
  802f2c:	48 b8 5c 3c 80 00 00 	movabs $0x803c5c,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f38:	ba 00 00 00 00       	mov    $0x0,%edx
  802f3d:	be 00 00 00 00       	mov    $0x0,%esi
  802f42:	bf 00 00 00 00       	mov    $0x0,%edi
  802f47:	48 b8 9c 3b 80 00 00 	movabs $0x803b9c,%rax
  802f4e:	00 00 00 
  802f51:	ff d0                	callq  *%rax
}
  802f53:	c9                   	leaveq 
  802f54:	c3                   	retq   

0000000000802f55 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f55:	55                   	push   %rbp
  802f56:	48 89 e5             	mov    %rsp,%rbp
  802f59:	48 83 ec 30          	sub    $0x30,%rsp
  802f5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f64:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f68:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f6f:	00 00 00 
  802f72:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f75:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f77:	bf 01 00 00 00       	mov    $0x1,%edi
  802f7c:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
  802f88:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8f:	78 3e                	js     802fcf <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f91:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f98:	00 00 00 
  802f9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa3:	8b 40 10             	mov    0x10(%rax),%eax
  802fa6:	89 c2                	mov    %eax,%edx
  802fa8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802fac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb0:	48 89 ce             	mov    %rcx,%rsi
  802fb3:	48 89 c7             	mov    %rax,%rdi
  802fb6:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  802fbd:	00 00 00 
  802fc0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	8b 50 10             	mov    0x10(%rax),%edx
  802fc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcd:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fd2:	c9                   	leaveq 
  802fd3:	c3                   	retq   

0000000000802fd4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fd4:	55                   	push   %rbp
  802fd5:	48 89 e5             	mov    %rsp,%rbp
  802fd8:	48 83 ec 10          	sub    $0x10,%rsp
  802fdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fe3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802fe6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fed:	00 00 00 
  802ff0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ff3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802ff5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ff8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffc:	48 89 c6             	mov    %rax,%rsi
  802fff:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803006:	00 00 00 
  803009:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803015:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80301c:	00 00 00 
  80301f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803022:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803025:	bf 02 00 00 00       	mov    $0x2,%edi
  80302a:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 10          	sub    $0x10,%rsp
  803040:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803043:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803046:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80304d:	00 00 00 
  803050:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803053:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803055:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305c:	00 00 00 
  80305f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803062:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803065:	bf 03 00 00 00       	mov    $0x3,%edi
  80306a:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
}
  803076:	c9                   	leaveq 
  803077:	c3                   	retq   

0000000000803078 <nsipc_close>:

int
nsipc_close(int s)
{
  803078:	55                   	push   %rbp
  803079:	48 89 e5             	mov    %rsp,%rbp
  80307c:	48 83 ec 10          	sub    $0x10,%rsp
  803080:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803083:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80308a:	00 00 00 
  80308d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803090:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803092:	bf 04 00 00 00       	mov    $0x4,%edi
  803097:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  80309e:	00 00 00 
  8030a1:	ff d0                	callq  *%rax
}
  8030a3:	c9                   	leaveq 
  8030a4:	c3                   	retq   

00000000008030a5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8030a5:	55                   	push   %rbp
  8030a6:	48 89 e5             	mov    %rsp,%rbp
  8030a9:	48 83 ec 10          	sub    $0x10,%rsp
  8030ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030b4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8030b7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030be:	00 00 00 
  8030c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030c4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030c6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030cd:	48 89 c6             	mov    %rax,%rsi
  8030d0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030d7:	00 00 00 
  8030da:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8030e6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030ed:	00 00 00 
  8030f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030f3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8030f6:	bf 05 00 00 00       	mov    $0x5,%edi
  8030fb:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803102:	00 00 00 
  803105:	ff d0                	callq  *%rax
}
  803107:	c9                   	leaveq 
  803108:	c3                   	retq   

0000000000803109 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 83 ec 10          	sub    $0x10,%rsp
  803111:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803114:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803117:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80311e:	00 00 00 
  803121:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803124:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803126:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80312d:	00 00 00 
  803130:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803133:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803136:	bf 06 00 00 00       	mov    $0x6,%edi
  80313b:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803142:	00 00 00 
  803145:	ff d0                	callq  *%rax
}
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 83 ec 30          	sub    $0x30,%rsp
  803151:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803154:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803158:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80315b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80315e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803165:	00 00 00 
  803168:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80316b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80316d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803174:	00 00 00 
  803177:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80317a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80317d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803184:	00 00 00 
  803187:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80318a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80318d:	bf 07 00 00 00       	mov    $0x7,%edi
  803192:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a5:	78 69                	js     803210 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8031a7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8031ae:	7f 08                	jg     8031b8 <nsipc_recv+0x6f>
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031b3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8031b6:	7e 35                	jle    8031ed <nsipc_recv+0xa4>
  8031b8:	48 b9 a2 44 80 00 00 	movabs $0x8044a2,%rcx
  8031bf:	00 00 00 
  8031c2:	48 ba b7 44 80 00 00 	movabs $0x8044b7,%rdx
  8031c9:	00 00 00 
  8031cc:	be 61 00 00 00       	mov    $0x61,%esi
  8031d1:	48 bf cc 44 80 00 00 	movabs $0x8044cc,%rdi
  8031d8:	00 00 00 
  8031db:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e0:	49 b8 4c 02 80 00 00 	movabs $0x80024c,%r8
  8031e7:	00 00 00 
  8031ea:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8031ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f0:	48 63 d0             	movslq %eax,%rdx
  8031f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031f7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031fe:	00 00 00 
  803201:	48 89 c7             	mov    %rax,%rdi
  803204:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
	}

	return r;
  803210:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803213:	c9                   	leaveq 
  803214:	c3                   	retq   

0000000000803215 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803215:	55                   	push   %rbp
  803216:	48 89 e5             	mov    %rsp,%rbp
  803219:	48 83 ec 20          	sub    $0x20,%rsp
  80321d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803220:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803224:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803227:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80322a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803231:	00 00 00 
  803234:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803237:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803239:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803240:	7e 35                	jle    803277 <nsipc_send+0x62>
  803242:	48 b9 d8 44 80 00 00 	movabs $0x8044d8,%rcx
  803249:	00 00 00 
  80324c:	48 ba b7 44 80 00 00 	movabs $0x8044b7,%rdx
  803253:	00 00 00 
  803256:	be 6c 00 00 00       	mov    $0x6c,%esi
  80325b:	48 bf cc 44 80 00 00 	movabs $0x8044cc,%rdi
  803262:	00 00 00 
  803265:	b8 00 00 00 00       	mov    $0x0,%eax
  80326a:	49 b8 4c 02 80 00 00 	movabs $0x80024c,%r8
  803271:	00 00 00 
  803274:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803277:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80327a:	48 63 d0             	movslq %eax,%rdx
  80327d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803281:	48 89 c6             	mov    %rax,%rsi
  803284:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80328b:	00 00 00 
  80328e:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  803295:	00 00 00 
  803298:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80329a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032a1:	00 00 00 
  8032a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032a7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8032aa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b1:	00 00 00 
  8032b4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032b7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8032ba:	bf 08 00 00 00       	mov    $0x8,%edi
  8032bf:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
}
  8032cb:	c9                   	leaveq 
  8032cc:	c3                   	retq   

00000000008032cd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8032cd:	55                   	push   %rbp
  8032ce:	48 89 e5             	mov    %rsp,%rbp
  8032d1:	48 83 ec 10          	sub    $0x10,%rsp
  8032d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032d8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8032db:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8032de:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032e5:	00 00 00 
  8032e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032eb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8032ed:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032f4:	00 00 00 
  8032f7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032fa:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8032fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803304:	00 00 00 
  803307:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80330a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80330d:	bf 09 00 00 00       	mov    $0x9,%edi
  803312:	48 b8 d4 2e 80 00 00 	movabs $0x802ed4,%rax
  803319:	00 00 00 
  80331c:	ff d0                	callq  *%rax
}
  80331e:	c9                   	leaveq 
  80331f:	c3                   	retq   

0000000000803320 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803320:	55                   	push   %rbp
  803321:	48 89 e5             	mov    %rsp,%rbp
  803324:	53                   	push   %rbx
  803325:	48 83 ec 38          	sub    $0x38,%rsp
  803329:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80332d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803331:	48 89 c7             	mov    %rax,%rdi
  803334:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  80333b:	00 00 00 
  80333e:	ff d0                	callq  *%rax
  803340:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803343:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803347:	0f 88 bf 01 00 00    	js     80350c <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80334d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803351:	ba 07 04 00 00       	mov    $0x407,%edx
  803356:	48 89 c6             	mov    %rax,%rsi
  803359:	bf 00 00 00 00       	mov    $0x0,%edi
  80335e:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80336d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803371:	0f 88 95 01 00 00    	js     80350c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803377:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80337b:	48 89 c7             	mov    %rax,%rdi
  80337e:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
  80338a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80338d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803391:	0f 88 5d 01 00 00    	js     8034f4 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803397:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80339b:	ba 07 04 00 00       	mov    $0x407,%edx
  8033a0:	48 89 c6             	mov    %rax,%rsi
  8033a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a8:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  8033af:	00 00 00 
  8033b2:	ff d0                	callq  *%rax
  8033b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033bb:	0f 88 33 01 00 00    	js     8034f4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8033c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c5:	48 89 c7             	mov    %rax,%rdi
  8033c8:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8033e1:	48 89 c6             	mov    %rax,%rsi
  8033e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e9:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
  8033f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033fc:	0f 88 d9 00 00 00    	js     8034db <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803402:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803406:	48 89 c7             	mov    %rax,%rdi
  803409:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  803410:	00 00 00 
  803413:	ff d0                	callq  *%rax
  803415:	48 89 c2             	mov    %rax,%rdx
  803418:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80341c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803422:	48 89 d1             	mov    %rdx,%rcx
  803425:	ba 00 00 00 00       	mov    $0x0,%edx
  80342a:	48 89 c6             	mov    %rax,%rsi
  80342d:	bf 00 00 00 00       	mov    $0x0,%edi
  803432:	48 b8 cc 19 80 00 00 	movabs $0x8019cc,%rax
  803439:	00 00 00 
  80343c:	ff d0                	callq  *%rax
  80343e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803441:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803445:	78 79                	js     8034c0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80344b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803452:	00 00 00 
  803455:	8b 12                	mov    (%rdx),%edx
  803457:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80345d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803464:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803468:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80346f:	00 00 00 
  803472:	8b 12                	mov    (%rdx),%edx
  803474:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803476:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803481:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803485:	48 89 c7             	mov    %rax,%rdi
  803488:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  80348f:	00 00 00 
  803492:	ff d0                	callq  *%rax
  803494:	89 c2                	mov    %eax,%edx
  803496:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80349a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80349c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034a0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8034a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034a8:	48 89 c7             	mov    %rax,%rdi
  8034ab:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8034b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034be:	eb 4f                	jmp    80350f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8034c0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  8034c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c5:	48 89 c6             	mov    %rax,%rsi
  8034c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8034cd:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	eb 01                	jmp    8034dc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8034db:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8034dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034e0:	48 89 c6             	mov    %rax,%rsi
  8034e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e8:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8034f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034f8:	48 89 c6             	mov    %rax,%rsi
  8034fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803500:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
    err:
	return r;
  80350c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80350f:	48 83 c4 38          	add    $0x38,%rsp
  803513:	5b                   	pop    %rbx
  803514:	5d                   	pop    %rbp
  803515:	c3                   	retq   

0000000000803516 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803516:	55                   	push   %rbp
  803517:	48 89 e5             	mov    %rsp,%rbp
  80351a:	53                   	push   %rbx
  80351b:	48 83 ec 28          	sub    $0x28,%rsp
  80351f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803523:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803527:	eb 01                	jmp    80352a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803529:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80352a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803531:	00 00 00 
  803534:	48 8b 00             	mov    (%rax),%rax
  803537:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80353d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803544:	48 89 c7             	mov    %rax,%rdi
  803547:	48 b8 a4 3d 80 00 00 	movabs $0x803da4,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
  803553:	89 c3                	mov    %eax,%ebx
  803555:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803559:	48 89 c7             	mov    %rax,%rdi
  80355c:	48 b8 a4 3d 80 00 00 	movabs $0x803da4,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
  803568:	39 c3                	cmp    %eax,%ebx
  80356a:	0f 94 c0             	sete   %al
  80356d:	0f b6 c0             	movzbl %al,%eax
  803570:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803573:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80357a:	00 00 00 
  80357d:	48 8b 00             	mov    (%rax),%rax
  803580:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803586:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803589:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80358c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80358f:	75 0a                	jne    80359b <_pipeisclosed+0x85>
			return ret;
  803591:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803594:	48 83 c4 28          	add    $0x28,%rsp
  803598:	5b                   	pop    %rbx
  803599:	5d                   	pop    %rbp
  80359a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80359b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80359e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8035a1:	74 86                	je     803529 <_pipeisclosed+0x13>
  8035a3:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8035a7:	75 80                	jne    803529 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8035a9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8035b0:	00 00 00 
  8035b3:	48 8b 00             	mov    (%rax),%rax
  8035b6:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8035bc:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c2:	89 c6                	mov    %eax,%esi
  8035c4:	48 bf e9 44 80 00 00 	movabs $0x8044e9,%rdi
  8035cb:	00 00 00 
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d3:	49 b8 87 04 80 00 00 	movabs $0x800487,%r8
  8035da:	00 00 00 
  8035dd:	41 ff d0             	callq  *%r8
	}
  8035e0:	e9 44 ff ff ff       	jmpq   803529 <_pipeisclosed+0x13>

00000000008035e5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8035e5:	55                   	push   %rbp
  8035e6:	48 89 e5             	mov    %rsp,%rbp
  8035e9:	48 83 ec 30          	sub    $0x30,%rsp
  8035ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035f0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035f4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035f7:	48 89 d6             	mov    %rdx,%rsi
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360f:	79 05                	jns    803616 <pipeisclosed+0x31>
		return r;
  803611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803614:	eb 31                	jmp    803647 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361a:	48 89 c7             	mov    %rax,%rdi
  80361d:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  803624:	00 00 00 
  803627:	ff d0                	callq  *%rax
  803629:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80362d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803631:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803635:	48 89 d6             	mov    %rdx,%rsi
  803638:	48 89 c7             	mov    %rax,%rdi
  80363b:	48 b8 16 35 80 00 00 	movabs $0x803516,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
}
  803647:	c9                   	leaveq 
  803648:	c3                   	retq   

0000000000803649 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803649:	55                   	push   %rbp
  80364a:	48 89 e5             	mov    %rsp,%rbp
  80364d:	48 83 ec 40          	sub    $0x40,%rsp
  803651:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803655:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803659:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80365d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803661:	48 89 c7             	mov    %rax,%rdi
  803664:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
  803670:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803678:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80367c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803683:	00 
  803684:	e9 97 00 00 00       	jmpq   803720 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803689:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80368e:	74 09                	je     803699 <devpipe_read+0x50>
				return i;
  803690:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803694:	e9 95 00 00 00       	jmpq   80372e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803699:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80369d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036a1:	48 89 d6             	mov    %rdx,%rsi
  8036a4:	48 89 c7             	mov    %rax,%rdi
  8036a7:	48 b8 16 35 80 00 00 	movabs $0x803516,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 07                	je     8036be <devpipe_read+0x75>
				return 0;
  8036b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bc:	eb 70                	jmp    80372e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036be:	48 b8 3e 19 80 00 00 	movabs $0x80193e,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	eb 01                	jmp    8036cd <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036cc:	90                   	nop
  8036cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d1:	8b 10                	mov    (%rax),%edx
  8036d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d7:	8b 40 04             	mov    0x4(%rax),%eax
  8036da:	39 c2                	cmp    %eax,%edx
  8036dc:	74 ab                	je     803689 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036e6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ee:	8b 00                	mov    (%rax),%eax
  8036f0:	89 c2                	mov    %eax,%edx
  8036f2:	c1 fa 1f             	sar    $0x1f,%edx
  8036f5:	c1 ea 1b             	shr    $0x1b,%edx
  8036f8:	01 d0                	add    %edx,%eax
  8036fa:	83 e0 1f             	and    $0x1f,%eax
  8036fd:	29 d0                	sub    %edx,%eax
  8036ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803703:	48 98                	cltq   
  803705:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80370a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80370c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803710:	8b 00                	mov    (%rax),%eax
  803712:	8d 50 01             	lea    0x1(%rax),%edx
  803715:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803719:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80371b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803724:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803728:	72 a2                	jb     8036cc <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80372a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80372e:	c9                   	leaveq 
  80372f:	c3                   	retq   

0000000000803730 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803730:	55                   	push   %rbp
  803731:	48 89 e5             	mov    %rsp,%rbp
  803734:	48 83 ec 40          	sub    $0x40,%rsp
  803738:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80373c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803740:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803748:	48 89 c7             	mov    %rax,%rdi
  80374b:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  803752:	00 00 00 
  803755:	ff d0                	callq  *%rax
  803757:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80375b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80375f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803763:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80376a:	00 
  80376b:	e9 93 00 00 00       	jmpq   803803 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803770:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803778:	48 89 d6             	mov    %rdx,%rsi
  80377b:	48 89 c7             	mov    %rax,%rdi
  80377e:	48 b8 16 35 80 00 00 	movabs $0x803516,%rax
  803785:	00 00 00 
  803788:	ff d0                	callq  *%rax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	74 07                	je     803795 <devpipe_write+0x65>
				return 0;
  80378e:	b8 00 00 00 00       	mov    $0x0,%eax
  803793:	eb 7c                	jmp    803811 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803795:	48 b8 3e 19 80 00 00 	movabs $0x80193e,%rax
  80379c:	00 00 00 
  80379f:	ff d0                	callq  *%rax
  8037a1:	eb 01                	jmp    8037a4 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8037a3:	90                   	nop
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	8b 40 04             	mov    0x4(%rax),%eax
  8037ab:	48 63 d0             	movslq %eax,%rdx
  8037ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b2:	8b 00                	mov    (%rax),%eax
  8037b4:	48 98                	cltq   
  8037b6:	48 83 c0 20          	add    $0x20,%rax
  8037ba:	48 39 c2             	cmp    %rax,%rdx
  8037bd:	73 b1                	jae    803770 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8037bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c3:	8b 40 04             	mov    0x4(%rax),%eax
  8037c6:	89 c2                	mov    %eax,%edx
  8037c8:	c1 fa 1f             	sar    $0x1f,%edx
  8037cb:	c1 ea 1b             	shr    $0x1b,%edx
  8037ce:	01 d0                	add    %edx,%eax
  8037d0:	83 e0 1f             	and    $0x1f,%eax
  8037d3:	29 d0                	sub    %edx,%eax
  8037d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037d9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037dd:	48 01 ca             	add    %rcx,%rdx
  8037e0:	0f b6 0a             	movzbl (%rdx),%ecx
  8037e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037e7:	48 98                	cltq   
  8037e9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f1:	8b 40 04             	mov    0x4(%rax),%eax
  8037f4:	8d 50 01             	lea    0x1(%rax),%edx
  8037f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803807:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80380b:	72 96                	jb     8037a3 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80380d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803811:	c9                   	leaveq 
  803812:	c3                   	retq   

0000000000803813 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803813:	55                   	push   %rbp
  803814:	48 89 e5             	mov    %rsp,%rbp
  803817:	48 83 ec 20          	sub    $0x20,%rsp
  80381b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80381f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803827:	48 89 c7             	mov    %rax,%rdi
  80382a:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  803831:	00 00 00 
  803834:	ff d0                	callq  *%rax
  803836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80383a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80383e:	48 be fc 44 80 00 00 	movabs $0x8044fc,%rsi
  803845:	00 00 00 
  803848:	48 89 c7             	mov    %rax,%rdi
  80384b:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803857:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80385b:	8b 50 04             	mov    0x4(%rax),%edx
  80385e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803862:	8b 00                	mov    (%rax),%eax
  803864:	29 c2                	sub    %eax,%edx
  803866:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80386a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803870:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803874:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80387b:	00 00 00 
	stat->st_dev = &devpipe;
  80387e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803882:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803889:	00 00 00 
  80388c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803893:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803898:	c9                   	leaveq 
  803899:	c3                   	retq   

000000000080389a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80389a:	55                   	push   %rbp
  80389b:	48 89 e5             	mov    %rsp,%rbp
  80389e:	48 83 ec 10          	sub    $0x10,%rsp
  8038a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8038a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038aa:	48 89 c6             	mov    %rax,%rsi
  8038ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b2:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8038b9:	00 00 00 
  8038bc:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8038be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038c2:	48 89 c7             	mov    %rax,%rdi
  8038c5:	48 b8 2f 1e 80 00 00 	movabs $0x801e2f,%rax
  8038cc:	00 00 00 
  8038cf:	ff d0                	callq  *%rax
  8038d1:	48 89 c6             	mov    %rax,%rsi
  8038d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8038d9:	48 b8 27 1a 80 00 00 	movabs $0x801a27,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
}
  8038e5:	c9                   	leaveq 
  8038e6:	c3                   	retq   
	...

00000000008038e8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038e8:	55                   	push   %rbp
  8038e9:	48 89 e5             	mov    %rsp,%rbp
  8038ec:	48 83 ec 20          	sub    $0x20,%rsp
  8038f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038f6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038f9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038fd:	be 01 00 00 00       	mov    $0x1,%esi
  803902:	48 89 c7             	mov    %rax,%rdi
  803905:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  80390c:	00 00 00 
  80390f:	ff d0                	callq  *%rax
}
  803911:	c9                   	leaveq 
  803912:	c3                   	retq   

0000000000803913 <getchar>:

int
getchar(void)
{
  803913:	55                   	push   %rbp
  803914:	48 89 e5             	mov    %rsp,%rbp
  803917:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80391b:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80391f:	ba 01 00 00 00       	mov    $0x1,%edx
  803924:	48 89 c6             	mov    %rax,%rsi
  803927:	bf 00 00 00 00       	mov    $0x0,%edi
  80392c:	48 b8 24 23 80 00 00 	movabs $0x802324,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
  803938:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80393b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393f:	79 05                	jns    803946 <getchar+0x33>
		return r;
  803941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803944:	eb 14                	jmp    80395a <getchar+0x47>
	if (r < 1)
  803946:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80394a:	7f 07                	jg     803953 <getchar+0x40>
		return -E_EOF;
  80394c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803951:	eb 07                	jmp    80395a <getchar+0x47>
	return c;
  803953:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803957:	0f b6 c0             	movzbl %al,%eax
}
  80395a:	c9                   	leaveq 
  80395b:	c3                   	retq   

000000000080395c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80395c:	55                   	push   %rbp
  80395d:	48 89 e5             	mov    %rsp,%rbp
  803960:	48 83 ec 20          	sub    $0x20,%rsp
  803964:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803967:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80396b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80396e:	48 89 d6             	mov    %rdx,%rsi
  803971:	89 c7                	mov    %eax,%edi
  803973:	48 b8 f2 1e 80 00 00 	movabs $0x801ef2,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
  80397f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803986:	79 05                	jns    80398d <iscons+0x31>
		return r;
  803988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398b:	eb 1a                	jmp    8039a7 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80398d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803991:	8b 10                	mov    (%rax),%edx
  803993:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80399a:	00 00 00 
  80399d:	8b 00                	mov    (%rax),%eax
  80399f:	39 c2                	cmp    %eax,%edx
  8039a1:	0f 94 c0             	sete   %al
  8039a4:	0f b6 c0             	movzbl %al,%eax
}
  8039a7:	c9                   	leaveq 
  8039a8:	c3                   	retq   

00000000008039a9 <opencons>:

int
opencons(void)
{
  8039a9:	55                   	push   %rbp
  8039aa:	48 89 e5             	mov    %rsp,%rbp
  8039ad:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8039b1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8039b5:	48 89 c7             	mov    %rax,%rdi
  8039b8:	48 b8 5a 1e 80 00 00 	movabs $0x801e5a,%rax
  8039bf:	00 00 00 
  8039c2:	ff d0                	callq  *%rax
  8039c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039cb:	79 05                	jns    8039d2 <opencons+0x29>
		return r;
  8039cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d0:	eb 5b                	jmp    803a2d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d6:	ba 07 04 00 00       	mov    $0x407,%edx
  8039db:	48 89 c6             	mov    %rax,%rsi
  8039de:	bf 00 00 00 00       	mov    $0x0,%edi
  8039e3:	48 b8 7c 19 80 00 00 	movabs $0x80197c,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
  8039ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f6:	79 05                	jns    8039fd <opencons+0x54>
		return r;
  8039f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fb:	eb 30                	jmp    803a2d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a01:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803a08:	00 00 00 
  803a0b:	8b 12                	mov    (%rdx),%edx
  803a0d:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803a0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a13:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1e:	48 89 c7             	mov    %rax,%rdi
  803a21:	48 b8 0c 1e 80 00 00 	movabs $0x801e0c,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
}
  803a2d:	c9                   	leaveq 
  803a2e:	c3                   	retq   

0000000000803a2f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a2f:	55                   	push   %rbp
  803a30:	48 89 e5             	mov    %rsp,%rbp
  803a33:	48 83 ec 30          	sub    $0x30,%rsp
  803a37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a43:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a48:	75 13                	jne    803a5d <devcons_read+0x2e>
		return 0;
  803a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4f:	eb 49                	jmp    803a9a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803a51:	48 b8 3e 19 80 00 00 	movabs $0x80193e,%rax
  803a58:	00 00 00 
  803a5b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a5d:	48 b8 7e 18 80 00 00 	movabs $0x80187e,%rax
  803a64:	00 00 00 
  803a67:	ff d0                	callq  *%rax
  803a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a70:	74 df                	je     803a51 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803a72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a76:	79 05                	jns    803a7d <devcons_read+0x4e>
		return c;
  803a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a7b:	eb 1d                	jmp    803a9a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803a7d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a81:	75 07                	jne    803a8a <devcons_read+0x5b>
		return 0;
  803a83:	b8 00 00 00 00       	mov    $0x0,%eax
  803a88:	eb 10                	jmp    803a9a <devcons_read+0x6b>
	*(char*)vbuf = c;
  803a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8d:	89 c2                	mov    %eax,%edx
  803a8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a93:	88 10                	mov    %dl,(%rax)
	return 1;
  803a95:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a9a:	c9                   	leaveq 
  803a9b:	c3                   	retq   

0000000000803a9c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a9c:	55                   	push   %rbp
  803a9d:	48 89 e5             	mov    %rsp,%rbp
  803aa0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803aa7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803aae:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803ab5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803abc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ac3:	eb 77                	jmp    803b3c <devcons_write+0xa0>
		m = n - tot;
  803ac5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803acc:	89 c2                	mov    %eax,%edx
  803ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad1:	89 d1                	mov    %edx,%ecx
  803ad3:	29 c1                	sub    %eax,%ecx
  803ad5:	89 c8                	mov    %ecx,%eax
  803ad7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803ada:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803add:	83 f8 7f             	cmp    $0x7f,%eax
  803ae0:	76 07                	jbe    803ae9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803ae2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803ae9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aec:	48 63 d0             	movslq %eax,%rdx
  803aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af2:	48 98                	cltq   
  803af4:	48 89 c1             	mov    %rax,%rcx
  803af7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803afe:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b05:	48 89 ce             	mov    %rcx,%rsi
  803b08:	48 89 c7             	mov    %rax,%rdi
  803b0b:	48 b8 66 13 80 00 00 	movabs $0x801366,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803b17:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b1a:	48 63 d0             	movslq %eax,%rdx
  803b1d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803b24:	48 89 d6             	mov    %rdx,%rsi
  803b27:	48 89 c7             	mov    %rax,%rdi
  803b2a:	48 b8 34 18 80 00 00 	movabs $0x801834,%rax
  803b31:	00 00 00 
  803b34:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b39:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3f:	48 98                	cltq   
  803b41:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b48:	0f 82 77 ff ff ff    	jb     803ac5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b51:	c9                   	leaveq 
  803b52:	c3                   	retq   

0000000000803b53 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b53:	55                   	push   %rbp
  803b54:	48 89 e5             	mov    %rsp,%rbp
  803b57:	48 83 ec 08          	sub    $0x8,%rsp
  803b5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b64:	c9                   	leaveq 
  803b65:	c3                   	retq   

0000000000803b66 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b66:	55                   	push   %rbp
  803b67:	48 89 e5             	mov    %rsp,%rbp
  803b6a:	48 83 ec 10          	sub    $0x10,%rsp
  803b6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b7a:	48 be 08 45 80 00 00 	movabs $0x804508,%rsi
  803b81:	00 00 00 
  803b84:	48 89 c7             	mov    %rax,%rdi
  803b87:	48 b8 44 10 80 00 00 	movabs $0x801044,%rax
  803b8e:	00 00 00 
  803b91:	ff d0                	callq  *%rax
	return 0;
  803b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b98:	c9                   	leaveq 
  803b99:	c3                   	retq   
	...

0000000000803b9c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b9c:	55                   	push   %rbp
  803b9d:	48 89 e5             	mov    %rsp,%rbp
  803ba0:	48 83 ec 30          	sub    $0x30,%rsp
  803ba4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ba8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803bb0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803bb5:	74 18                	je     803bcf <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbb:	48 89 c7             	mov    %rax,%rdi
  803bbe:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  803bc5:	00 00 00 
  803bc8:	ff d0                	callq  *%rax
  803bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bcd:	eb 19                	jmp    803be8 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803bcf:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803bd6:	00 00 00 
  803bd9:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bec:	79 19                	jns    803c07 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803bf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bfc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c05:	eb 53                	jmp    803c5a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803c07:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803c0c:	74 19                	je     803c27 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803c0e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c15:	00 00 00 
  803c18:	48 8b 00             	mov    (%rax),%rax
  803c1b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c25:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803c27:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c2c:	74 19                	je     803c47 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803c2e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c35:	00 00 00 
  803c38:	48 8b 00             	mov    (%rax),%rax
  803c3b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c45:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803c47:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c4e:	00 00 00 
  803c51:	48 8b 00             	mov    (%rax),%rax
  803c54:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803c5a:	c9                   	leaveq 
  803c5b:	c3                   	retq   

0000000000803c5c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c5c:	55                   	push   %rbp
  803c5d:	48 89 e5             	mov    %rsp,%rbp
  803c60:	48 83 ec 30          	sub    $0x30,%rsp
  803c64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c67:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c6a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c6e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803c71:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803c78:	e9 96 00 00 00       	jmpq   803d13 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803c7d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c82:	74 20                	je     803ca4 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803c84:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c87:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c8a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c91:	89 c7                	mov    %eax,%edi
  803c93:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
  803c9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca2:	eb 2d                	jmp    803cd1 <ipc_send+0x75>
		else if(pg==NULL)
  803ca4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ca9:	75 26                	jne    803cd1 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803cab:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803cae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  803cb6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803cbd:	00 00 00 
  803cc0:	89 c7                	mov    %eax,%edi
  803cc2:	48 b8 50 1b 80 00 00 	movabs $0x801b50,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
  803cce:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd5:	79 30                	jns    803d07 <ipc_send+0xab>
  803cd7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803cdb:	74 2a                	je     803d07 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803cdd:	48 ba 0f 45 80 00 00 	movabs $0x80450f,%rdx
  803ce4:	00 00 00 
  803ce7:	be 40 00 00 00       	mov    $0x40,%esi
  803cec:	48 bf 27 45 80 00 00 	movabs $0x804527,%rdi
  803cf3:	00 00 00 
  803cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  803cfb:	48 b9 4c 02 80 00 00 	movabs $0x80024c,%rcx
  803d02:	00 00 00 
  803d05:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803d07:	48 b8 3e 19 80 00 00 	movabs $0x80193e,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803d13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d17:	0f 85 60 ff ff ff    	jne    803c7d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803d1d:	c9                   	leaveq 
  803d1e:	c3                   	retq   

0000000000803d1f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803d1f:	55                   	push   %rbp
  803d20:	48 89 e5             	mov    %rsp,%rbp
  803d23:	48 83 ec 18          	sub    $0x18,%rsp
  803d27:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803d2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d31:	eb 5e                	jmp    803d91 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d33:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d3a:	00 00 00 
  803d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d40:	48 63 d0             	movslq %eax,%rdx
  803d43:	48 89 d0             	mov    %rdx,%rax
  803d46:	48 c1 e0 03          	shl    $0x3,%rax
  803d4a:	48 01 d0             	add    %rdx,%rax
  803d4d:	48 c1 e0 05          	shl    $0x5,%rax
  803d51:	48 01 c8             	add    %rcx,%rax
  803d54:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d5a:	8b 00                	mov    (%rax),%eax
  803d5c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d5f:	75 2c                	jne    803d8d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d61:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d68:	00 00 00 
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	48 63 d0             	movslq %eax,%rdx
  803d71:	48 89 d0             	mov    %rdx,%rax
  803d74:	48 c1 e0 03          	shl    $0x3,%rax
  803d78:	48 01 d0             	add    %rdx,%rax
  803d7b:	48 c1 e0 05          	shl    $0x5,%rax
  803d7f:	48 01 c8             	add    %rcx,%rax
  803d82:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d88:	8b 40 08             	mov    0x8(%rax),%eax
  803d8b:	eb 12                	jmp    803d9f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803d8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d91:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d98:	7e 99                	jle    803d33 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d9f:	c9                   	leaveq 
  803da0:	c3                   	retq   
  803da1:	00 00                	add    %al,(%rax)
	...

0000000000803da4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803da4:	55                   	push   %rbp
  803da5:	48 89 e5             	mov    %rsp,%rbp
  803da8:	48 83 ec 18          	sub    $0x18,%rsp
  803dac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db4:	48 89 c2             	mov    %rax,%rdx
  803db7:	48 c1 ea 15          	shr    $0x15,%rdx
  803dbb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803dc2:	01 00 00 
  803dc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dc9:	83 e0 01             	and    $0x1,%eax
  803dcc:	48 85 c0             	test   %rax,%rax
  803dcf:	75 07                	jne    803dd8 <pageref+0x34>
		return 0;
  803dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd6:	eb 53                	jmp    803e2b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ddc:	48 89 c2             	mov    %rax,%rdx
  803ddf:	48 c1 ea 0c          	shr    $0xc,%rdx
  803de3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dea:	01 00 00 
  803ded:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803df1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803df5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df9:	83 e0 01             	and    $0x1,%eax
  803dfc:	48 85 c0             	test   %rax,%rax
  803dff:	75 07                	jne    803e08 <pageref+0x64>
		return 0;
  803e01:	b8 00 00 00 00       	mov    $0x0,%eax
  803e06:	eb 23                	jmp    803e2b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0c:	48 89 c2             	mov    %rax,%rdx
  803e0f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803e13:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803e1a:	00 00 00 
  803e1d:	48 c1 e2 04          	shl    $0x4,%rdx
  803e21:	48 01 d0             	add    %rdx,%rax
  803e24:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803e28:	0f b7 c0             	movzwl %ax,%eax
}
  803e2b:	c9                   	leaveq 
  803e2c:	c3                   	retq   
