
obj/user/faultallocbad.debug:     file format elf64-x86-64


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
  80003c:	e8 17 01 00 00       	callq  800158 <libmain>
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
  800062:	48 bf 20 3e 80 00 00 	movabs $0x803e20,%rdi
  800069:	00 00 00 
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	48 ba 5b 04 80 00 00 	movabs $0x80045b,%rdx
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
  80009c:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
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
  8000be:	48 ba 30 3e 80 00 00 	movabs $0x803e30,%rdx
  8000c5:	00 00 00 
  8000c8:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cd:	48 bf 5b 3e 80 00 00 	movabs $0x803e5b,%rdi
  8000d4:	00 00 00 
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	49 b9 20 02 80 00 00 	movabs $0x800220,%r9
  8000e3:	00 00 00 
  8000e6:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f1:	48 89 d1             	mov    %rdx,%rcx
  8000f4:	48 ba 70 3e 80 00 00 	movabs $0x803e70,%rdx
  8000fb:	00 00 00 
  8000fe:	be 64 00 00 00       	mov    $0x64,%esi
  800103:	48 89 c7             	mov    %rax,%rdi
  800106:	b8 00 00 00 00       	mov    $0x0,%eax
  80010b:	49 b8 ca 0e 80 00 00 	movabs $0x800eca,%r8
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
  800133:	48 b8 90 1c 80 00 00 	movabs $0x801c90,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013f:	be 04 00 00 00       	mov    $0x4,%esi
  800144:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800149:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  800150:	00 00 00 
  800153:	ff d0                	callq  *%rax
}
  800155:	c9                   	leaveq 
  800156:	c3                   	retq   
	...

0000000000800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %rbp
  800159:	48 89 e5             	mov    %rsp,%rbp
  80015c:	48 83 ec 10          	sub    $0x10,%rsp
  800160:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800163:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800167:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80016e:	00 00 00 
  800171:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800178:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  80017f:	00 00 00 
  800182:	ff d0                	callq  *%rax
  800184:	48 98                	cltq   
  800186:	48 89 c2             	mov    %rax,%rdx
  800189:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80018f:	48 89 d0             	mov    %rdx,%rax
  800192:	48 c1 e0 03          	shl    $0x3,%rax
  800196:	48 01 d0             	add    %rdx,%rax
  800199:	48 c1 e0 05          	shl    $0x5,%rax
  80019d:	48 89 c2             	mov    %rax,%rdx
  8001a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001a7:	00 00 00 
  8001aa:	48 01 c2             	add    %rax,%rdx
  8001ad:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001b4:	00 00 00 
  8001b7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001be:	7e 14                	jle    8001d4 <libmain+0x7c>
		binaryname = argv[0];
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	48 8b 10             	mov    (%rax),%rdx
  8001c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ce:	00 00 00 
  8001d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	48 89 d6             	mov    %rdx,%rsi
  8001de:	89 c7                	mov    %eax,%edi
  8001e0:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ec:	48 b8 fc 01 80 00 00 	movabs $0x8001fc,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	c9                   	leaveq 
  8001f9:	c3                   	retq   
	...

00000000008001fc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800200:	48 b8 21 21 80 00 00 	movabs $0x802121,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80020c:	bf 00 00 00 00       	mov    $0x0,%edi
  800211:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  800218:	00 00 00 
  80021b:	ff d0                	callq  *%rax
}
  80021d:	5d                   	pop    %rbp
  80021e:	c3                   	retq   
	...

0000000000800220 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800220:	55                   	push   %rbp
  800221:	48 89 e5             	mov    %rsp,%rbp
  800224:	53                   	push   %rbx
  800225:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80022c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800233:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800239:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800240:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800247:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80024e:	84 c0                	test   %al,%al
  800250:	74 23                	je     800275 <_panic+0x55>
  800252:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800259:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80025d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800261:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800265:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800269:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80026d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800271:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800275:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80027c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800283:	00 00 00 
  800286:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80028d:	00 00 00 
  800290:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800294:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80029b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002a2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002a9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002b0:	00 00 00 
  8002b3:	48 8b 18             	mov    (%rax),%rbx
  8002b6:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8002bd:	00 00 00 
  8002c0:	ff d0                	callq  *%rax
  8002c2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002c8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002cf:	41 89 c8             	mov    %ecx,%r8d
  8002d2:	48 89 d1             	mov    %rdx,%rcx
  8002d5:	48 89 da             	mov    %rbx,%rdx
  8002d8:	89 c6                	mov    %eax,%esi
  8002da:	48 bf a0 3e 80 00 00 	movabs $0x803ea0,%rdi
  8002e1:	00 00 00 
  8002e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e9:	49 b9 5b 04 80 00 00 	movabs $0x80045b,%r9
  8002f0:	00 00 00 
  8002f3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002f6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800304:	48 89 d6             	mov    %rdx,%rsi
  800307:	48 89 c7             	mov    %rax,%rdi
  80030a:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  800311:	00 00 00 
  800314:	ff d0                	callq  *%rax
	cprintf("\n");
  800316:	48 bf c3 3e 80 00 00 	movabs $0x803ec3,%rdi
  80031d:	00 00 00 
  800320:	b8 00 00 00 00       	mov    $0x0,%eax
  800325:	48 ba 5b 04 80 00 00 	movabs $0x80045b,%rdx
  80032c:	00 00 00 
  80032f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800331:	cc                   	int3   
  800332:	eb fd                	jmp    800331 <_panic+0x111>

0000000000800334 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
  800338:	48 83 ec 10          	sub    $0x10,%rsp
  80033c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800347:	8b 00                	mov    (%rax),%eax
  800349:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80034c:	89 d6                	mov    %edx,%esi
  80034e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800352:	48 63 d0             	movslq %eax,%rdx
  800355:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80035a:	8d 50 01             	lea    0x1(%rax),%edx
  80035d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800361:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800363:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800367:	8b 00                	mov    (%rax),%eax
  800369:	3d ff 00 00 00       	cmp    $0xff,%eax
  80036e:	75 2c                	jne    80039c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800374:	8b 00                	mov    (%rax),%eax
  800376:	48 98                	cltq   
  800378:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037c:	48 83 c2 08          	add    $0x8,%rdx
  800380:	48 89 c6             	mov    %rax,%rsi
  800383:	48 89 d7             	mov    %rdx,%rdi
  800386:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
		b->idx = 0;
  800392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800396:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	8b 40 04             	mov    0x4(%rax),%eax
  8003a3:	8d 50 01             	lea    0x1(%rax),%edx
  8003a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003aa:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003ad:	c9                   	leaveq 
  8003ae:	c3                   	retq   

00000000008003af <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003af:	55                   	push   %rbp
  8003b0:	48 89 e5             	mov    %rsp,%rbp
  8003b3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003ba:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003c1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003c8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003cf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003d6:	48 8b 0a             	mov    (%rdx),%rcx
  8003d9:	48 89 08             	mov    %rcx,(%rax)
  8003dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8003ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003f3:	00 00 00 
	b.cnt = 0;
  8003f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800400:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800407:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80040e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800415:	48 89 c6             	mov    %rax,%rsi
  800418:	48 bf 34 03 80 00 00 	movabs $0x800334,%rdi
  80041f:	00 00 00 
  800422:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80042e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800434:	48 98                	cltq   
  800436:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80043d:	48 83 c2 08          	add    $0x8,%rdx
  800441:	48 89 c6             	mov    %rax,%rsi
  800444:	48 89 d7             	mov    %rdx,%rdi
  800447:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  80044e:	00 00 00 
  800451:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800453:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800459:	c9                   	leaveq 
  80045a:	c3                   	retq   

000000000080045b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80045b:	55                   	push   %rbp
  80045c:	48 89 e5             	mov    %rsp,%rbp
  80045f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800466:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80046d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800474:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80047b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800482:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800489:	84 c0                	test   %al,%al
  80048b:	74 20                	je     8004ad <cprintf+0x52>
  80048d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800491:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800495:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800499:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80049d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004a1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004a5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004a9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004ad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004b4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004bb:	00 00 00 
  8004be:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004c5:	00 00 00 
  8004c8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004cc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004d3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004da:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004e1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004e8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004ef:	48 8b 0a             	mov    (%rdx),%rcx
  8004f2:	48 89 08             	mov    %rcx,(%rax)
  8004f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800501:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800505:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80050c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800513:	48 89 d6             	mov    %rdx,%rsi
  800516:	48 89 c7             	mov    %rax,%rdi
  800519:	48 b8 af 03 80 00 00 	movabs $0x8003af,%rax
  800520:	00 00 00 
  800523:	ff d0                	callq  *%rax
  800525:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80052b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800531:	c9                   	leaveq 
  800532:	c3                   	retq   
	...

0000000000800534 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800534:	55                   	push   %rbp
  800535:	48 89 e5             	mov    %rsp,%rbp
  800538:	48 83 ec 30          	sub    $0x30,%rsp
  80053c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800540:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800544:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800548:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80054b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80054f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800553:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800556:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80055a:	77 52                	ja     8005ae <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80055f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800563:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800566:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80056a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056e:	ba 00 00 00 00       	mov    $0x0,%edx
  800573:	48 f7 75 d0          	divq   -0x30(%rbp)
  800577:	48 89 c2             	mov    %rax,%rdx
  80057a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80057d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800580:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800588:	41 89 f9             	mov    %edi,%r9d
  80058b:	48 89 c7             	mov    %rax,%rdi
  80058e:	48 b8 34 05 80 00 00 	movabs $0x800534,%rax
  800595:	00 00 00 
  800598:	ff d0                	callq  *%rax
  80059a:	eb 1c                	jmp    8005b8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80059c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8005a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005a7:	48 89 d6             	mov    %rdx,%rsi
  8005aa:	89 c7                	mov    %eax,%edi
  8005ac:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ae:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8005b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8005b6:	7f e4                	jg     80059c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005b8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c4:	48 f7 f1             	div    %rcx
  8005c7:	48 89 d0             	mov    %rdx,%rax
  8005ca:	48 ba a8 40 80 00 00 	movabs $0x8040a8,%rdx
  8005d1:	00 00 00 
  8005d4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005d8:	0f be c0             	movsbl %al,%eax
  8005db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005df:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8005e3:	48 89 d6             	mov    %rdx,%rsi
  8005e6:	89 c7                	mov    %eax,%edi
  8005e8:	ff d1                	callq  *%rcx
}
  8005ea:	c9                   	leaveq 
  8005eb:	c3                   	retq   

00000000008005ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005ec:	55                   	push   %rbp
  8005ed:	48 89 e5             	mov    %rsp,%rbp
  8005f0:	48 83 ec 20          	sub    $0x20,%rsp
  8005f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ff:	7e 52                	jle    800653 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	83 f8 30             	cmp    $0x30,%eax
  80060a:	73 24                	jae    800630 <getuint+0x44>
  80060c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800610:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	89 c0                	mov    %eax,%eax
  80061c:	48 01 d0             	add    %rdx,%rax
  80061f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800623:	8b 12                	mov    (%rdx),%edx
  800625:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	89 0a                	mov    %ecx,(%rdx)
  80062e:	eb 17                	jmp    800647 <getuint+0x5b>
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800638:	48 89 d0             	mov    %rdx,%rax
  80063b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80063f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800643:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800647:	48 8b 00             	mov    (%rax),%rax
  80064a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80064e:	e9 a3 00 00 00       	jmpq   8006f6 <getuint+0x10a>
	else if (lflag)
  800653:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800657:	74 4f                	je     8006a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	8b 00                	mov    (%rax),%eax
  80065f:	83 f8 30             	cmp    $0x30,%eax
  800662:	73 24                	jae    800688 <getuint+0x9c>
  800664:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800668:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	89 c0                	mov    %eax,%eax
  800674:	48 01 d0             	add    %rdx,%rax
  800677:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067b:	8b 12                	mov    (%rdx),%edx
  80067d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	89 0a                	mov    %ecx,(%rdx)
  800686:	eb 17                	jmp    80069f <getuint+0xb3>
  800688:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800690:	48 89 d0             	mov    %rdx,%rax
  800693:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80069b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069f:	48 8b 00             	mov    (%rax),%rax
  8006a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006a6:	eb 4e                	jmp    8006f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ac:	8b 00                	mov    (%rax),%eax
  8006ae:	83 f8 30             	cmp    $0x30,%eax
  8006b1:	73 24                	jae    8006d7 <getuint+0xeb>
  8006b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	89 c0                	mov    %eax,%eax
  8006c3:	48 01 d0             	add    %rdx,%rax
  8006c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ca:	8b 12                	mov    (%rdx),%edx
  8006cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	89 0a                	mov    %ecx,(%rdx)
  8006d5:	eb 17                	jmp    8006ee <getuint+0x102>
  8006d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006df:	48 89 d0             	mov    %rdx,%rax
  8006e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ee:	8b 00                	mov    (%rax),%eax
  8006f0:	89 c0                	mov    %eax,%eax
  8006f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006fa:	c9                   	leaveq 
  8006fb:	c3                   	retq   

00000000008006fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fc:	55                   	push   %rbp
  8006fd:	48 89 e5             	mov    %rsp,%rbp
  800700:	48 83 ec 20          	sub    $0x20,%rsp
  800704:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800708:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80070b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80070f:	7e 52                	jle    800763 <getint+0x67>
		x=va_arg(*ap, long long);
  800711:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800715:	8b 00                	mov    (%rax),%eax
  800717:	83 f8 30             	cmp    $0x30,%eax
  80071a:	73 24                	jae    800740 <getint+0x44>
  80071c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800720:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	8b 00                	mov    (%rax),%eax
  80072a:	89 c0                	mov    %eax,%eax
  80072c:	48 01 d0             	add    %rdx,%rax
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	8b 12                	mov    (%rdx),%edx
  800735:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073c:	89 0a                	mov    %ecx,(%rdx)
  80073e:	eb 17                	jmp    800757 <getint+0x5b>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800748:	48 89 d0             	mov    %rdx,%rax
  80074b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800757:	48 8b 00             	mov    (%rax),%rax
  80075a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80075e:	e9 a3 00 00 00       	jmpq   800806 <getint+0x10a>
	else if (lflag)
  800763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800767:	74 4f                	je     8007b8 <getint+0xbc>
		x=va_arg(*ap, long);
  800769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076d:	8b 00                	mov    (%rax),%eax
  80076f:	83 f8 30             	cmp    $0x30,%eax
  800772:	73 24                	jae    800798 <getint+0x9c>
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
  800796:	eb 17                	jmp    8007af <getint+0xb3>
  800798:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a0:	48 89 d0             	mov    %rdx,%rax
  8007a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007af:	48 8b 00             	mov    (%rax),%rax
  8007b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007b6:	eb 4e                	jmp    800806 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007bc:	8b 00                	mov    (%rax),%eax
  8007be:	83 f8 30             	cmp    $0x30,%eax
  8007c1:	73 24                	jae    8007e7 <getint+0xeb>
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	8b 00                	mov    (%rax),%eax
  8007d1:	89 c0                	mov    %eax,%eax
  8007d3:	48 01 d0             	add    %rdx,%rax
  8007d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007da:	8b 12                	mov    (%rdx),%edx
  8007dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	89 0a                	mov    %ecx,(%rdx)
  8007e5:	eb 17                	jmp    8007fe <getint+0x102>
  8007e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007ef:	48 89 d0             	mov    %rdx,%rax
  8007f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007fe:	8b 00                	mov    (%rax),%eax
  800800:	48 98                	cltq   
  800802:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800806:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80080a:	c9                   	leaveq 
  80080b:	c3                   	retq   

000000000080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %rbp
  80080d:	48 89 e5             	mov    %rsp,%rbp
  800810:	41 54                	push   %r12
  800812:	53                   	push   %rbx
  800813:	48 83 ec 60          	sub    $0x60,%rsp
  800817:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80081b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80081f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800823:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800827:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80082b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80082f:	48 8b 0a             	mov    (%rdx),%rcx
  800832:	48 89 08             	mov    %rcx,(%rax)
  800835:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800839:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80083d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800841:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800845:	eb 17                	jmp    80085e <vprintfmt+0x52>
			if (ch == '\0')
  800847:	85 db                	test   %ebx,%ebx
  800849:	0f 84 d7 04 00 00    	je     800d26 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  80084f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800853:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800857:	48 89 c6             	mov    %rax,%rsi
  80085a:	89 df                	mov    %ebx,%edi
  80085c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800862:	0f b6 00             	movzbl (%rax),%eax
  800865:	0f b6 d8             	movzbl %al,%ebx
  800868:	83 fb 25             	cmp    $0x25,%ebx
  80086b:	0f 95 c0             	setne  %al
  80086e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800873:	84 c0                	test   %al,%al
  800875:	75 d0                	jne    800847 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800877:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80087b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800882:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800889:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800890:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800897:	eb 04                	jmp    80089d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800899:	90                   	nop
  80089a:	eb 01                	jmp    80089d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80089c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008a1:	0f b6 00             	movzbl (%rax),%eax
  8008a4:	0f b6 d8             	movzbl %al,%ebx
  8008a7:	89 d8                	mov    %ebx,%eax
  8008a9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008ae:	83 e8 23             	sub    $0x23,%eax
  8008b1:	83 f8 55             	cmp    $0x55,%eax
  8008b4:	0f 87 38 04 00 00    	ja     800cf2 <vprintfmt+0x4e6>
  8008ba:	89 c0                	mov    %eax,%eax
  8008bc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008c3:	00 
  8008c4:	48 b8 d0 40 80 00 00 	movabs $0x8040d0,%rax
  8008cb:	00 00 00 
  8008ce:	48 01 d0             	add    %rdx,%rax
  8008d1:	48 8b 00             	mov    (%rax),%rax
  8008d4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008da:	eb c1                	jmp    80089d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008dc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008e0:	eb bb                	jmp    80089d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008e9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008ec:	89 d0                	mov    %edx,%eax
  8008ee:	c1 e0 02             	shl    $0x2,%eax
  8008f1:	01 d0                	add    %edx,%eax
  8008f3:	01 c0                	add    %eax,%eax
  8008f5:	01 d8                	add    %ebx,%eax
  8008f7:	83 e8 30             	sub    $0x30,%eax
  8008fa:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800901:	0f b6 00             	movzbl (%rax),%eax
  800904:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800907:	83 fb 2f             	cmp    $0x2f,%ebx
  80090a:	7e 63                	jle    80096f <vprintfmt+0x163>
  80090c:	83 fb 39             	cmp    $0x39,%ebx
  80090f:	7f 5e                	jg     80096f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800911:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800916:	eb d1                	jmp    8008e9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800918:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091b:	83 f8 30             	cmp    $0x30,%eax
  80091e:	73 17                	jae    800937 <vprintfmt+0x12b>
  800920:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800924:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800927:	89 c0                	mov    %eax,%eax
  800929:	48 01 d0             	add    %rdx,%rax
  80092c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80092f:	83 c2 08             	add    $0x8,%edx
  800932:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800935:	eb 0f                	jmp    800946 <vprintfmt+0x13a>
  800937:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80093b:	48 89 d0             	mov    %rdx,%rax
  80093e:	48 83 c2 08          	add    $0x8,%rdx
  800942:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800946:	8b 00                	mov    (%rax),%eax
  800948:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80094b:	eb 23                	jmp    800970 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80094d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800951:	0f 89 42 ff ff ff    	jns    800899 <vprintfmt+0x8d>
				width = 0;
  800957:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80095e:	e9 36 ff ff ff       	jmpq   800899 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800963:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80096a:	e9 2e ff ff ff       	jmpq   80089d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800970:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800974:	0f 89 22 ff ff ff    	jns    80089c <vprintfmt+0x90>
				width = precision, precision = -1;
  80097a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80097d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800980:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800987:	e9 10 ff ff ff       	jmpq   80089c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80098c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800990:	e9 08 ff ff ff       	jmpq   80089d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800995:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800998:	83 f8 30             	cmp    $0x30,%eax
  80099b:	73 17                	jae    8009b4 <vprintfmt+0x1a8>
  80099d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a4:	89 c0                	mov    %eax,%eax
  8009a6:	48 01 d0             	add    %rdx,%rax
  8009a9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ac:	83 c2 08             	add    $0x8,%edx
  8009af:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b2:	eb 0f                	jmp    8009c3 <vprintfmt+0x1b7>
  8009b4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009b8:	48 89 d0             	mov    %rdx,%rax
  8009bb:	48 83 c2 08          	add    $0x8,%rdx
  8009bf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c3:	8b 00                	mov    (%rax),%eax
  8009c5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8009cd:	48 89 d6             	mov    %rdx,%rsi
  8009d0:	89 c7                	mov    %eax,%edi
  8009d2:	ff d1                	callq  *%rcx
			break;
  8009d4:	e9 47 03 00 00       	jmpq   800d20 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8009d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dc:	83 f8 30             	cmp    $0x30,%eax
  8009df:	73 17                	jae    8009f8 <vprintfmt+0x1ec>
  8009e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	89 c0                	mov    %eax,%eax
  8009ea:	48 01 d0             	add    %rdx,%rax
  8009ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f0:	83 c2 08             	add    $0x8,%edx
  8009f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f6:	eb 0f                	jmp    800a07 <vprintfmt+0x1fb>
  8009f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fc:	48 89 d0             	mov    %rdx,%rax
  8009ff:	48 83 c2 08          	add    $0x8,%rdx
  800a03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a07:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a09:	85 db                	test   %ebx,%ebx
  800a0b:	79 02                	jns    800a0f <vprintfmt+0x203>
				err = -err;
  800a0d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a0f:	83 fb 10             	cmp    $0x10,%ebx
  800a12:	7f 16                	jg     800a2a <vprintfmt+0x21e>
  800a14:	48 b8 20 40 80 00 00 	movabs $0x804020,%rax
  800a1b:	00 00 00 
  800a1e:	48 63 d3             	movslq %ebx,%rdx
  800a21:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a25:	4d 85 e4             	test   %r12,%r12
  800a28:	75 2e                	jne    800a58 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	89 d9                	mov    %ebx,%ecx
  800a34:	48 ba b9 40 80 00 00 	movabs $0x8040b9,%rdx
  800a3b:	00 00 00 
  800a3e:	48 89 c7             	mov    %rax,%rdi
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	49 b8 30 0d 80 00 00 	movabs $0x800d30,%r8
  800a4d:	00 00 00 
  800a50:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a53:	e9 c8 02 00 00       	jmpq   800d20 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a58:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a60:	4c 89 e1             	mov    %r12,%rcx
  800a63:	48 ba c2 40 80 00 00 	movabs $0x8040c2,%rdx
  800a6a:	00 00 00 
  800a6d:	48 89 c7             	mov    %rax,%rdi
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
  800a75:	49 b8 30 0d 80 00 00 	movabs $0x800d30,%r8
  800a7c:	00 00 00 
  800a7f:	41 ff d0             	callq  *%r8
			break;
  800a82:	e9 99 02 00 00       	jmpq   800d20 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8a:	83 f8 30             	cmp    $0x30,%eax
  800a8d:	73 17                	jae    800aa6 <vprintfmt+0x29a>
  800a8f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a96:	89 c0                	mov    %eax,%eax
  800a98:	48 01 d0             	add    %rdx,%rax
  800a9b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a9e:	83 c2 08             	add    $0x8,%edx
  800aa1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800aa4:	eb 0f                	jmp    800ab5 <vprintfmt+0x2a9>
  800aa6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aaa:	48 89 d0             	mov    %rdx,%rax
  800aad:	48 83 c2 08          	add    $0x8,%rdx
  800ab1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ab5:	4c 8b 20             	mov    (%rax),%r12
  800ab8:	4d 85 e4             	test   %r12,%r12
  800abb:	75 0a                	jne    800ac7 <vprintfmt+0x2bb>
				p = "(null)";
  800abd:	49 bc c5 40 80 00 00 	movabs $0x8040c5,%r12
  800ac4:	00 00 00 
			if (width > 0 && padc != '-')
  800ac7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800acb:	7e 7a                	jle    800b47 <vprintfmt+0x33b>
  800acd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ad1:	74 74                	je     800b47 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ad6:	48 98                	cltq   
  800ad8:	48 89 c6             	mov    %rax,%rsi
  800adb:	4c 89 e7             	mov    %r12,%rdi
  800ade:	48 b8 da 0f 80 00 00 	movabs $0x800fda,%rax
  800ae5:	00 00 00 
  800ae8:	ff d0                	callq  *%rax
  800aea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800aed:	eb 17                	jmp    800b06 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800aef:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800af3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800afb:	48 89 d6             	mov    %rdx,%rsi
  800afe:	89 c7                	mov    %eax,%edi
  800b00:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0a:	7f e3                	jg     800aef <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0c:	eb 39                	jmp    800b47 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b12:	74 1e                	je     800b32 <vprintfmt+0x326>
  800b14:	83 fb 1f             	cmp    $0x1f,%ebx
  800b17:	7e 05                	jle    800b1e <vprintfmt+0x312>
  800b19:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1c:	7e 14                	jle    800b32 <vprintfmt+0x326>
					putch('?', putdat);
  800b1e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b22:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b26:	48 89 c6             	mov    %rax,%rsi
  800b29:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b2e:	ff d2                	callq  *%rdx
  800b30:	eb 0f                	jmp    800b41 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b32:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b36:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b3a:	48 89 c6             	mov    %rax,%rsi
  800b3d:	89 df                	mov    %ebx,%edi
  800b3f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b45:	eb 01                	jmp    800b48 <vprintfmt+0x33c>
  800b47:	90                   	nop
  800b48:	41 0f b6 04 24       	movzbl (%r12),%eax
  800b4d:	0f be d8             	movsbl %al,%ebx
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	0f 95 c0             	setne  %al
  800b55:	49 83 c4 01          	add    $0x1,%r12
  800b59:	84 c0                	test   %al,%al
  800b5b:	74 28                	je     800b85 <vprintfmt+0x379>
  800b5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b61:	78 ab                	js     800b0e <vprintfmt+0x302>
  800b63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b6b:	79 a1                	jns    800b0e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6d:	eb 16                	jmp    800b85 <vprintfmt+0x379>
				putch(' ', putdat);
  800b6f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b73:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b77:	48 89 c6             	mov    %rax,%rsi
  800b7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800b7f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b89:	7f e4                	jg     800b6f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800b8b:	e9 90 01 00 00       	jmpq   800d20 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b94:	be 03 00 00 00       	mov    $0x3,%esi
  800b99:	48 89 c7             	mov    %rax,%rdi
  800b9c:	48 b8 fc 06 80 00 00 	movabs $0x8006fc,%rax
  800ba3:	00 00 00 
  800ba6:	ff d0                	callq  *%rax
  800ba8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb0:	48 85 c0             	test   %rax,%rax
  800bb3:	79 1d                	jns    800bd2 <vprintfmt+0x3c6>
				putch('-', putdat);
  800bb5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bb9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bbd:	48 89 c6             	mov    %rax,%rsi
  800bc0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bc5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800bc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bcb:	48 f7 d8             	neg    %rax
  800bce:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bd2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bd9:	e9 d5 00 00 00       	jmpq   800cb3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bde:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be2:	be 03 00 00 00       	mov    $0x3,%esi
  800be7:	48 89 c7             	mov    %rax,%rdi
  800bea:	48 b8 ec 05 80 00 00 	movabs $0x8005ec,%rax
  800bf1:	00 00 00 
  800bf4:	ff d0                	callq  *%rax
  800bf6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bfa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c01:	e9 ad 00 00 00       	jmpq   800cb3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c0a:	be 03 00 00 00       	mov    $0x3,%esi
  800c0f:	48 89 c7             	mov    %rax,%rdi
  800c12:	48 b8 ec 05 80 00 00 	movabs $0x8005ec,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
  800c1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800c22:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c29:	e9 85 00 00 00       	jmpq   800cb3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c2e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c32:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c36:	48 89 c6             	mov    %rax,%rsi
  800c39:	bf 30 00 00 00       	mov    $0x30,%edi
  800c3e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800c40:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c44:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c48:	48 89 c6             	mov    %rax,%rsi
  800c4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800c50:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c55:	83 f8 30             	cmp    $0x30,%eax
  800c58:	73 17                	jae    800c71 <vprintfmt+0x465>
  800c5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c61:	89 c0                	mov    %eax,%eax
  800c63:	48 01 d0             	add    %rdx,%rax
  800c66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c69:	83 c2 08             	add    $0x8,%edx
  800c6c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c6f:	eb 0f                	jmp    800c80 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800c71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c75:	48 89 d0             	mov    %rdx,%rax
  800c78:	48 83 c2 08          	add    $0x8,%rdx
  800c7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c80:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c8e:	eb 23                	jmp    800cb3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c94:	be 03 00 00 00       	mov    $0x3,%esi
  800c99:	48 89 c7             	mov    %rax,%rdi
  800c9c:	48 b8 ec 05 80 00 00 	movabs $0x8005ec,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cbb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cc2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cca:	45 89 c1             	mov    %r8d,%r9d
  800ccd:	41 89 f8             	mov    %edi,%r8d
  800cd0:	48 89 c7             	mov    %rax,%rdi
  800cd3:	48 b8 34 05 80 00 00 	movabs $0x800534,%rax
  800cda:	00 00 00 
  800cdd:	ff d0                	callq  *%rax
			break;
  800cdf:	eb 3f                	jmp    800d20 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ce5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ce9:	48 89 c6             	mov    %rax,%rsi
  800cec:	89 df                	mov    %ebx,%edi
  800cee:	ff d2                	callq  *%rdx
			break;
  800cf0:	eb 2e                	jmp    800d20 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cf6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cfa:	48 89 c6             	mov    %rax,%rsi
  800cfd:	bf 25 00 00 00       	mov    $0x25,%edi
  800d02:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d04:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d09:	eb 05                	jmp    800d10 <vprintfmt+0x504>
  800d0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d10:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d14:	48 83 e8 01          	sub    $0x1,%rax
  800d18:	0f b6 00             	movzbl (%rax),%eax
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 ec                	jne    800d0b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d21:	e9 38 fb ff ff       	jmpq   80085e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d26:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d27:	48 83 c4 60          	add    $0x60,%rsp
  800d2b:	5b                   	pop    %rbx
  800d2c:	41 5c                	pop    %r12
  800d2e:	5d                   	pop    %rbp
  800d2f:	c3                   	retq   

0000000000800d30 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d30:	55                   	push   %rbp
  800d31:	48 89 e5             	mov    %rsp,%rbp
  800d34:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d3b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d42:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d49:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d50:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d57:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d5e:	84 c0                	test   %al,%al
  800d60:	74 20                	je     800d82 <printfmt+0x52>
  800d62:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d66:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d6a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d6e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d72:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d76:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d7a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d7e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d82:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d89:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d90:	00 00 00 
  800d93:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d9a:	00 00 00 
  800d9d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800da8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800daf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800db6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dbd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dc4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dcb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd2:	48 89 c7             	mov    %rax,%rdi
  800dd5:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800ddc:	00 00 00 
  800ddf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de1:	c9                   	leaveq 
  800de2:	c3                   	retq   

0000000000800de3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de3:	55                   	push   %rbp
  800de4:	48 89 e5             	mov    %rsp,%rbp
  800de7:	48 83 ec 10          	sub    $0x10,%rsp
  800deb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df6:	8b 40 10             	mov    0x10(%rax),%eax
  800df9:	8d 50 01             	lea    0x1(%rax),%edx
  800dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e00:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e07:	48 8b 10             	mov    (%rax),%rdx
  800e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e12:	48 39 c2             	cmp    %rax,%rdx
  800e15:	73 17                	jae    800e2e <sprintputch+0x4b>
		*b->buf++ = ch;
  800e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e1b:	48 8b 00             	mov    (%rax),%rax
  800e1e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e21:	88 10                	mov    %dl,(%rax)
  800e23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2b:	48 89 10             	mov    %rdx,(%rax)
}
  800e2e:	c9                   	leaveq 
  800e2f:	c3                   	retq   

0000000000800e30 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %rbp
  800e31:	48 89 e5             	mov    %rsp,%rbp
  800e34:	48 83 ec 50          	sub    $0x50,%rsp
  800e38:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e3c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e3f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e43:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e47:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e4b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e4f:	48 8b 0a             	mov    (%rdx),%rcx
  800e52:	48 89 08             	mov    %rcx,(%rax)
  800e55:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e59:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e5d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e61:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e65:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e69:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e6d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e70:	48 98                	cltq   
  800e72:	48 83 e8 01          	sub    $0x1,%rax
  800e76:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800e7a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e85:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e8a:	74 06                	je     800e92 <vsnprintf+0x62>
  800e8c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e90:	7f 07                	jg     800e99 <vsnprintf+0x69>
		return -E_INVAL;
  800e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e97:	eb 2f                	jmp    800ec8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e99:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e9d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ea1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ea5:	48 89 c6             	mov    %rax,%rsi
  800ea8:	48 bf e3 0d 80 00 00 	movabs $0x800de3,%rdi
  800eaf:	00 00 00 
  800eb2:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800eb9:	00 00 00 
  800ebc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ebe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ec5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ec8:	c9                   	leaveq 
  800ec9:	c3                   	retq   

0000000000800eca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eca:	55                   	push   %rbp
  800ecb:	48 89 e5             	mov    %rsp,%rbp
  800ece:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ed5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800edc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ee2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ee9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ef0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ef7:	84 c0                	test   %al,%al
  800ef9:	74 20                	je     800f1b <snprintf+0x51>
  800efb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800eff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f03:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f07:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f0b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f0f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f13:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f17:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f1b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f22:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f29:	00 00 00 
  800f2c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f33:	00 00 00 
  800f36:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f3a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f41:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f48:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f4f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f56:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f5d:	48 8b 0a             	mov    (%rdx),%rcx
  800f60:	48 89 08             	mov    %rcx,(%rax)
  800f63:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f67:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f6b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f6f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f73:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f7a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f81:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f87:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f8e:	48 89 c7             	mov    %rax,%rdi
  800f91:	48 b8 30 0e 80 00 00 	movabs $0x800e30,%rax
  800f98:	00 00 00 
  800f9b:	ff d0                	callq  *%rax
  800f9d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fa3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fa9:	c9                   	leaveq 
  800faa:	c3                   	retq   
	...

0000000000800fac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fac:	55                   	push   %rbp
  800fad:	48 89 e5             	mov    %rsp,%rbp
  800fb0:	48 83 ec 18          	sub    $0x18,%rsp
  800fb4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fbf:	eb 09                	jmp    800fca <strlen+0x1e>
		n++;
  800fc1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fce:	0f b6 00             	movzbl (%rax),%eax
  800fd1:	84 c0                	test   %al,%al
  800fd3:	75 ec                	jne    800fc1 <strlen+0x15>
		n++;
	return n;
  800fd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fd8:	c9                   	leaveq 
  800fd9:	c3                   	retq   

0000000000800fda <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fda:	55                   	push   %rbp
  800fdb:	48 89 e5             	mov    %rsp,%rbp
  800fde:	48 83 ec 20          	sub    $0x20,%rsp
  800fe2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fe6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff1:	eb 0e                	jmp    801001 <strnlen+0x27>
		n++;
  800ff3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ffc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801001:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801006:	74 0b                	je     801013 <strnlen+0x39>
  801008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100c:	0f b6 00             	movzbl (%rax),%eax
  80100f:	84 c0                	test   %al,%al
  801011:	75 e0                	jne    800ff3 <strnlen+0x19>
		n++;
	return n;
  801013:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801016:	c9                   	leaveq 
  801017:	c3                   	retq   

0000000000801018 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801018:	55                   	push   %rbp
  801019:	48 89 e5             	mov    %rsp,%rbp
  80101c:	48 83 ec 20          	sub    $0x20,%rsp
  801020:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801024:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801030:	90                   	nop
  801031:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801035:	0f b6 10             	movzbl (%rax),%edx
  801038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103c:	88 10                	mov    %dl,(%rax)
  80103e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801042:	0f b6 00             	movzbl (%rax),%eax
  801045:	84 c0                	test   %al,%al
  801047:	0f 95 c0             	setne  %al
  80104a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801054:	84 c0                	test   %al,%al
  801056:	75 d9                	jne    801031 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801058:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80105c:	c9                   	leaveq 
  80105d:	c3                   	retq   

000000000080105e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80105e:	55                   	push   %rbp
  80105f:	48 89 e5             	mov    %rsp,%rbp
  801062:	48 83 ec 20          	sub    $0x20,%rsp
  801066:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80106a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	48 89 c7             	mov    %rax,%rdi
  801075:	48 b8 ac 0f 80 00 00 	movabs $0x800fac,%rax
  80107c:	00 00 00 
  80107f:	ff d0                	callq  *%rax
  801081:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801084:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801087:	48 98                	cltq   
  801089:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80108d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801091:	48 89 d6             	mov    %rdx,%rsi
  801094:	48 89 c7             	mov    %rax,%rdi
  801097:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  80109e:	00 00 00 
  8010a1:	ff d0                	callq  *%rax
	return dst;
  8010a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010a7:	c9                   	leaveq 
  8010a8:	c3                   	retq   

00000000008010a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010a9:	55                   	push   %rbp
  8010aa:	48 89 e5             	mov    %rsp,%rbp
  8010ad:	48 83 ec 28          	sub    $0x28,%rsp
  8010b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010cc:	00 
  8010cd:	eb 27                	jmp    8010f6 <strncpy+0x4d>
		*dst++ = *src;
  8010cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d3:	0f b6 10             	movzbl (%rax),%edx
  8010d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010da:	88 10                	mov    %dl,(%rax)
  8010dc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e5:	0f b6 00             	movzbl (%rax),%eax
  8010e8:	84 c0                	test   %al,%al
  8010ea:	74 05                	je     8010f1 <strncpy+0x48>
			src++;
  8010ec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010fa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010fe:	72 cf                	jb     8010cf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801104:	c9                   	leaveq 
  801105:	c3                   	retq   

0000000000801106 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801106:	55                   	push   %rbp
  801107:	48 89 e5             	mov    %rsp,%rbp
  80110a:	48 83 ec 28          	sub    $0x28,%rsp
  80110e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801112:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801116:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80111a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801122:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801127:	74 37                	je     801160 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801129:	eb 17                	jmp    801142 <strlcpy+0x3c>
			*dst++ = *src++;
  80112b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80112f:	0f b6 10             	movzbl (%rax),%edx
  801132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801136:	88 10                	mov    %dl,(%rax)
  801138:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80113d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801142:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801147:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80114c:	74 0b                	je     801159 <strlcpy+0x53>
  80114e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801152:	0f b6 00             	movzbl (%rax),%eax
  801155:	84 c0                	test   %al,%al
  801157:	75 d2                	jne    80112b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801160:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801168:	48 89 d1             	mov    %rdx,%rcx
  80116b:	48 29 c1             	sub    %rax,%rcx
  80116e:	48 89 c8             	mov    %rcx,%rax
}
  801171:	c9                   	leaveq 
  801172:	c3                   	retq   

0000000000801173 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801173:	55                   	push   %rbp
  801174:	48 89 e5             	mov    %rsp,%rbp
  801177:	48 83 ec 10          	sub    $0x10,%rsp
  80117b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80117f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801183:	eb 0a                	jmp    80118f <strcmp+0x1c>
		p++, q++;
  801185:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80118a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	84 c0                	test   %al,%al
  801198:	74 12                	je     8011ac <strcmp+0x39>
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	0f b6 10             	movzbl (%rax),%edx
  8011a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a5:	0f b6 00             	movzbl (%rax),%eax
  8011a8:	38 c2                	cmp    %al,%dl
  8011aa:	74 d9                	je     801185 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b0:	0f b6 00             	movzbl (%rax),%eax
  8011b3:	0f b6 d0             	movzbl %al,%edx
  8011b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ba:	0f b6 00             	movzbl (%rax),%eax
  8011bd:	0f b6 c0             	movzbl %al,%eax
  8011c0:	89 d1                	mov    %edx,%ecx
  8011c2:	29 c1                	sub    %eax,%ecx
  8011c4:	89 c8                	mov    %ecx,%eax
}
  8011c6:	c9                   	leaveq 
  8011c7:	c3                   	retq   

00000000008011c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011c8:	55                   	push   %rbp
  8011c9:	48 89 e5             	mov    %rsp,%rbp
  8011cc:	48 83 ec 18          	sub    $0x18,%rsp
  8011d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011dc:	eb 0f                	jmp    8011ed <strncmp+0x25>
		n--, p++, q++;
  8011de:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011f2:	74 1d                	je     801211 <strncmp+0x49>
  8011f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f8:	0f b6 00             	movzbl (%rax),%eax
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 12                	je     801211 <strncmp+0x49>
  8011ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801203:	0f b6 10             	movzbl (%rax),%edx
  801206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80120a:	0f b6 00             	movzbl (%rax),%eax
  80120d:	38 c2                	cmp    %al,%dl
  80120f:	74 cd                	je     8011de <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801211:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801216:	75 07                	jne    80121f <strncmp+0x57>
		return 0;
  801218:	b8 00 00 00 00       	mov    $0x0,%eax
  80121d:	eb 1a                	jmp    801239 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80121f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801223:	0f b6 00             	movzbl (%rax),%eax
  801226:	0f b6 d0             	movzbl %al,%edx
  801229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122d:	0f b6 00             	movzbl (%rax),%eax
  801230:	0f b6 c0             	movzbl %al,%eax
  801233:	89 d1                	mov    %edx,%ecx
  801235:	29 c1                	sub    %eax,%ecx
  801237:	89 c8                	mov    %ecx,%eax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 10          	sub    $0x10,%rsp
  801243:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801247:	89 f0                	mov    %esi,%eax
  801249:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80124c:	eb 17                	jmp    801265 <strchr+0x2a>
		if (*s == c)
  80124e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801252:	0f b6 00             	movzbl (%rax),%eax
  801255:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801258:	75 06                	jne    801260 <strchr+0x25>
			return (char *) s;
  80125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125e:	eb 15                	jmp    801275 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801260:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801269:	0f b6 00             	movzbl (%rax),%eax
  80126c:	84 c0                	test   %al,%al
  80126e:	75 de                	jne    80124e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 10          	sub    $0x10,%rsp
  80127f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801288:	eb 11                	jmp    80129b <strfind+0x24>
		if (*s == c)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801294:	74 12                	je     8012a8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801296:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 00             	movzbl (%rax),%eax
  8012a2:	84 c0                	test   %al,%al
  8012a4:	75 e4                	jne    80128a <strfind+0x13>
  8012a6:	eb 01                	jmp    8012a9 <strfind+0x32>
		if (*s == c)
			break;
  8012a8:	90                   	nop
	return (char *) s;
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ad:	c9                   	leaveq 
  8012ae:	c3                   	retq   

00000000008012af <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012af:	55                   	push   %rbp
  8012b0:	48 89 e5             	mov    %rsp,%rbp
  8012b3:	48 83 ec 18          	sub    $0x18,%rsp
  8012b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012be:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012c2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c7:	75 06                	jne    8012cf <memset+0x20>
		return v;
  8012c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cd:	eb 69                	jmp    801338 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d3:	83 e0 03             	and    $0x3,%eax
  8012d6:	48 85 c0             	test   %rax,%rax
  8012d9:	75 48                	jne    801323 <memset+0x74>
  8012db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012df:	83 e0 03             	and    $0x3,%eax
  8012e2:	48 85 c0             	test   %rax,%rax
  8012e5:	75 3c                	jne    801323 <memset+0x74>
		c &= 0xFF;
  8012e7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	c1 e2 18             	shl    $0x18,%edx
  8012f6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012f9:	c1 e0 10             	shl    $0x10,%eax
  8012fc:	09 c2                	or     %eax,%edx
  8012fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801301:	c1 e0 08             	shl    $0x8,%eax
  801304:	09 d0                	or     %edx,%eax
  801306:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130d:	48 89 c1             	mov    %rax,%rcx
  801310:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801314:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801318:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80131b:	48 89 d7             	mov    %rdx,%rdi
  80131e:	fc                   	cld    
  80131f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801321:	eb 11                	jmp    801334 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801323:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801327:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80132e:	48 89 d7             	mov    %rdx,%rdi
  801331:	fc                   	cld    
  801332:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801338:	c9                   	leaveq 
  801339:	c3                   	retq   

000000000080133a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80133a:	55                   	push   %rbp
  80133b:	48 89 e5             	mov    %rsp,%rbp
  80133e:	48 83 ec 28          	sub    $0x28,%rsp
  801342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801346:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80134a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80134e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801352:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80135e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801362:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801366:	0f 83 88 00 00 00    	jae    8013f4 <memmove+0xba>
  80136c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801370:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801374:	48 01 d0             	add    %rdx,%rax
  801377:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80137b:	76 77                	jbe    8013f4 <memmove+0xba>
		s += n;
  80137d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801381:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801389:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80138d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801391:	83 e0 03             	and    $0x3,%eax
  801394:	48 85 c0             	test   %rax,%rax
  801397:	75 3b                	jne    8013d4 <memmove+0x9a>
  801399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139d:	83 e0 03             	and    $0x3,%eax
  8013a0:	48 85 c0             	test   %rax,%rax
  8013a3:	75 2f                	jne    8013d4 <memmove+0x9a>
  8013a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a9:	83 e0 03             	and    $0x3,%eax
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	75 23                	jne    8013d4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b5:	48 83 e8 04          	sub    $0x4,%rax
  8013b9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bd:	48 83 ea 04          	sub    $0x4,%rdx
  8013c1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013c5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013c9:	48 89 c7             	mov    %rax,%rdi
  8013cc:	48 89 d6             	mov    %rdx,%rsi
  8013cf:	fd                   	std    
  8013d0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013d2:	eb 1d                	jmp    8013f1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e8:	48 89 d7             	mov    %rdx,%rdi
  8013eb:	48 89 c1             	mov    %rax,%rcx
  8013ee:	fd                   	std    
  8013ef:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013f1:	fc                   	cld    
  8013f2:	eb 57                	jmp    80144b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f8:	83 e0 03             	and    $0x3,%eax
  8013fb:	48 85 c0             	test   %rax,%rax
  8013fe:	75 36                	jne    801436 <memmove+0xfc>
  801400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801404:	83 e0 03             	and    $0x3,%eax
  801407:	48 85 c0             	test   %rax,%rax
  80140a:	75 2a                	jne    801436 <memmove+0xfc>
  80140c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801410:	83 e0 03             	and    $0x3,%eax
  801413:	48 85 c0             	test   %rax,%rax
  801416:	75 1e                	jne    801436 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801418:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141c:	48 89 c1             	mov    %rax,%rcx
  80141f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801423:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801427:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80142b:	48 89 c7             	mov    %rax,%rdi
  80142e:	48 89 d6             	mov    %rdx,%rsi
  801431:	fc                   	cld    
  801432:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801434:	eb 15                	jmp    80144b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801442:	48 89 c7             	mov    %rax,%rdi
  801445:	48 89 d6             	mov    %rdx,%rsi
  801448:	fc                   	cld    
  801449:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80144b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80144f:	c9                   	leaveq 
  801450:	c3                   	retq   

0000000000801451 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801451:	55                   	push   %rbp
  801452:	48 89 e5             	mov    %rsp,%rbp
  801455:	48 83 ec 18          	sub    $0x18,%rsp
  801459:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801461:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801465:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801469:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	48 89 ce             	mov    %rcx,%rsi
  801474:	48 89 c7             	mov    %rax,%rdi
  801477:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  80147e:	00 00 00 
  801481:	ff d0                	callq  *%rax
}
  801483:	c9                   	leaveq 
  801484:	c3                   	retq   

0000000000801485 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801485:	55                   	push   %rbp
  801486:	48 89 e5             	mov    %rsp,%rbp
  801489:	48 83 ec 28          	sub    $0x28,%rsp
  80148d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801491:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801495:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80149d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014a9:	eb 38                	jmp    8014e3 <memcmp+0x5e>
		if (*s1 != *s2)
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	0f b6 10             	movzbl (%rax),%edx
  8014b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	38 c2                	cmp    %al,%dl
  8014bb:	74 1c                	je     8014d9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8014bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c1:	0f b6 00             	movzbl (%rax),%eax
  8014c4:	0f b6 d0             	movzbl %al,%edx
  8014c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	0f b6 c0             	movzbl %al,%eax
  8014d1:	89 d1                	mov    %edx,%ecx
  8014d3:	29 c1                	sub    %eax,%ecx
  8014d5:	89 c8                	mov    %ecx,%eax
  8014d7:	eb 20                	jmp    8014f9 <memcmp+0x74>
		s1++, s2++;
  8014d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014e3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e8:	0f 95 c0             	setne  %al
  8014eb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014f0:	84 c0                	test   %al,%al
  8014f2:	75 b7                	jne    8014ab <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f9:	c9                   	leaveq 
  8014fa:	c3                   	retq   

00000000008014fb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014fb:	55                   	push   %rbp
  8014fc:	48 89 e5             	mov    %rsp,%rbp
  8014ff:	48 83 ec 28          	sub    $0x28,%rsp
  801503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801507:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80150a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801516:	48 01 d0             	add    %rdx,%rax
  801519:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80151d:	eb 13                	jmp    801532 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80151f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801523:	0f b6 10             	movzbl (%rax),%edx
  801526:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801529:	38 c2                	cmp    %al,%dl
  80152b:	74 11                	je     80153e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80152d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80153a:	72 e3                	jb     80151f <memfind+0x24>
  80153c:	eb 01                	jmp    80153f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80153e:	90                   	nop
	return (void *) s;
  80153f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801543:	c9                   	leaveq 
  801544:	c3                   	retq   

0000000000801545 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801545:	55                   	push   %rbp
  801546:	48 89 e5             	mov    %rsp,%rbp
  801549:	48 83 ec 38          	sub    $0x38,%rsp
  80154d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801551:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801555:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801558:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80155f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801566:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801567:	eb 05                	jmp    80156e <strtol+0x29>
		s++;
  801569:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	3c 20                	cmp    $0x20,%al
  801577:	74 f0                	je     801569 <strtol+0x24>
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	3c 09                	cmp    $0x9,%al
  801582:	74 e5                	je     801569 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	3c 2b                	cmp    $0x2b,%al
  80158d:	75 07                	jne    801596 <strtol+0x51>
		s++;
  80158f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801594:	eb 17                	jmp    8015ad <strtol+0x68>
	else if (*s == '-')
  801596:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159a:	0f b6 00             	movzbl (%rax),%eax
  80159d:	3c 2d                	cmp    $0x2d,%al
  80159f:	75 0c                	jne    8015ad <strtol+0x68>
		s++, neg = 1;
  8015a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b1:	74 06                	je     8015b9 <strtol+0x74>
  8015b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015b7:	75 28                	jne    8015e1 <strtol+0x9c>
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	3c 30                	cmp    $0x30,%al
  8015c2:	75 1d                	jne    8015e1 <strtol+0x9c>
  8015c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c8:	48 83 c0 01          	add    $0x1,%rax
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	3c 78                	cmp    $0x78,%al
  8015d1:	75 0e                	jne    8015e1 <strtol+0x9c>
		s += 2, base = 16;
  8015d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015df:	eb 2c                	jmp    80160d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e5:	75 19                	jne    801600 <strtol+0xbb>
  8015e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015eb:	0f b6 00             	movzbl (%rax),%eax
  8015ee:	3c 30                	cmp    $0x30,%al
  8015f0:	75 0e                	jne    801600 <strtol+0xbb>
		s++, base = 8;
  8015f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015fe:	eb 0d                	jmp    80160d <strtol+0xc8>
	else if (base == 0)
  801600:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801604:	75 07                	jne    80160d <strtol+0xc8>
		base = 10;
  801606:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80160d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801611:	0f b6 00             	movzbl (%rax),%eax
  801614:	3c 2f                	cmp    $0x2f,%al
  801616:	7e 1d                	jle    801635 <strtol+0xf0>
  801618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	3c 39                	cmp    $0x39,%al
  801621:	7f 12                	jg     801635 <strtol+0xf0>
			dig = *s - '0';
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	0f b6 00             	movzbl (%rax),%eax
  80162a:	0f be c0             	movsbl %al,%eax
  80162d:	83 e8 30             	sub    $0x30,%eax
  801630:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801633:	eb 4e                	jmp    801683 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801635:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	3c 60                	cmp    $0x60,%al
  80163e:	7e 1d                	jle    80165d <strtol+0x118>
  801640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801644:	0f b6 00             	movzbl (%rax),%eax
  801647:	3c 7a                	cmp    $0x7a,%al
  801649:	7f 12                	jg     80165d <strtol+0x118>
			dig = *s - 'a' + 10;
  80164b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	0f be c0             	movsbl %al,%eax
  801655:	83 e8 57             	sub    $0x57,%eax
  801658:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80165b:	eb 26                	jmp    801683 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80165d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	3c 40                	cmp    $0x40,%al
  801666:	7e 47                	jle    8016af <strtol+0x16a>
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	0f b6 00             	movzbl (%rax),%eax
  80166f:	3c 5a                	cmp    $0x5a,%al
  801671:	7f 3c                	jg     8016af <strtol+0x16a>
			dig = *s - 'A' + 10;
  801673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801677:	0f b6 00             	movzbl (%rax),%eax
  80167a:	0f be c0             	movsbl %al,%eax
  80167d:	83 e8 37             	sub    $0x37,%eax
  801680:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801683:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801686:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801689:	7d 23                	jge    8016ae <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80168b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801690:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801693:	48 98                	cltq   
  801695:	48 89 c2             	mov    %rax,%rdx
  801698:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80169d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016a0:	48 98                	cltq   
  8016a2:	48 01 d0             	add    %rdx,%rax
  8016a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 5f ff ff ff       	jmpq   80160d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016b4:	74 0b                	je     8016c1 <strtol+0x17c>
		*endptr = (char *) s;
  8016b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016be:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016c5:	74 09                	je     8016d0 <strtol+0x18b>
  8016c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cb:	48 f7 d8             	neg    %rax
  8016ce:	eb 04                	jmp    8016d4 <strtol+0x18f>
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016d4:	c9                   	leaveq 
  8016d5:	c3                   	retq   

00000000008016d6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016d6:	55                   	push   %rbp
  8016d7:	48 89 e5             	mov    %rsp,%rbp
  8016da:	48 83 ec 30          	sub    $0x30,%rsp
  8016de:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016e2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8016e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ea:	0f b6 00             	movzbl (%rax),%eax
  8016ed:	88 45 ff             	mov    %al,-0x1(%rbp)
  8016f0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8016f5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016f9:	75 06                	jne    801701 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8016fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ff:	eb 68                	jmp    801769 <strstr+0x93>

    len = strlen(str);
  801701:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801705:	48 89 c7             	mov    %rax,%rdi
  801708:	48 b8 ac 0f 80 00 00 	movabs $0x800fac,%rax
  80170f:	00 00 00 
  801712:	ff d0                	callq  *%rax
  801714:	48 98                	cltq   
  801716:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80171a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171e:	0f b6 00             	movzbl (%rax),%eax
  801721:	88 45 ef             	mov    %al,-0x11(%rbp)
  801724:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801729:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80172d:	75 07                	jne    801736 <strstr+0x60>
                return (char *) 0;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	eb 33                	jmp    801769 <strstr+0x93>
        } while (sc != c);
  801736:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80173a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80173d:	75 db                	jne    80171a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80173f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801743:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801747:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174b:	48 89 ce             	mov    %rcx,%rsi
  80174e:	48 89 c7             	mov    %rax,%rdi
  801751:	48 b8 c8 11 80 00 00 	movabs $0x8011c8,%rax
  801758:	00 00 00 
  80175b:	ff d0                	callq  *%rax
  80175d:	85 c0                	test   %eax,%eax
  80175f:	75 b9                	jne    80171a <strstr+0x44>

    return (char *) (in - 1);
  801761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801765:	48 83 e8 01          	sub    $0x1,%rax
}
  801769:	c9                   	leaveq 
  80176a:	c3                   	retq   
	...

000000000080176c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80176c:	55                   	push   %rbp
  80176d:	48 89 e5             	mov    %rsp,%rbp
  801770:	53                   	push   %rbx
  801771:	48 83 ec 58          	sub    $0x58,%rsp
  801775:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801778:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80177b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80177f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801783:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801787:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80178b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80178e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801791:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801795:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801799:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80179d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017a1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017a5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8017a8:	4c 89 c3             	mov    %r8,%rbx
  8017ab:	cd 30                	int    $0x30
  8017ad:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8017b1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8017b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017bd:	74 3e                	je     8017fd <syscall+0x91>
  8017bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c4:	7e 37                	jle    8017fd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cd:	49 89 d0             	mov    %rdx,%r8
  8017d0:	89 c1                	mov    %eax,%ecx
  8017d2:	48 ba 80 43 80 00 00 	movabs $0x804380,%rdx
  8017d9:	00 00 00 
  8017dc:	be 23 00 00 00       	mov    $0x23,%esi
  8017e1:	48 bf 9d 43 80 00 00 	movabs $0x80439d,%rdi
  8017e8:	00 00 00 
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	49 b9 20 02 80 00 00 	movabs $0x800220,%r9
  8017f7:	00 00 00 
  8017fa:	41 ff d1             	callq  *%r9

	return ret;
  8017fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801801:	48 83 c4 58          	add    $0x58,%rsp
  801805:	5b                   	pop    %rbx
  801806:	5d                   	pop    %rbp
  801807:	c3                   	retq   

0000000000801808 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801808:	55                   	push   %rbp
  801809:	48 89 e5             	mov    %rsp,%rbp
  80180c:	48 83 ec 20          	sub    $0x20,%rsp
  801810:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801814:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801820:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801827:	00 
  801828:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801834:	48 89 d1             	mov    %rdx,%rcx
  801837:	48 89 c2             	mov    %rax,%rdx
  80183a:	be 00 00 00 00       	mov    $0x0,%esi
  80183f:	bf 00 00 00 00       	mov    $0x0,%edi
  801844:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	callq  *%rax
}
  801850:	c9                   	leaveq 
  801851:	c3                   	retq   

0000000000801852 <sys_cgetc>:

int
sys_cgetc(void)
{
  801852:	55                   	push   %rbp
  801853:	48 89 e5             	mov    %rsp,%rbp
  801856:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80185a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801861:	00 
  801862:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801868:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801873:	ba 00 00 00 00       	mov    $0x0,%edx
  801878:	be 00 00 00 00       	mov    $0x0,%esi
  80187d:	bf 01 00 00 00       	mov    $0x1,%edi
  801882:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801889:	00 00 00 
  80188c:	ff d0                	callq  *%rax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 20          	sub    $0x20,%rsp
  801898:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80189b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189e:	48 98                	cltq   
  8018a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a7:	00 
  8018a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b9:	48 89 c2             	mov    %rax,%rdx
  8018bc:	be 01 00 00 00       	mov    $0x1,%esi
  8018c1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c6:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  8018cd:	00 00 00 
  8018d0:	ff d0                	callq  *%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	be 00 00 00 00       	mov    $0x0,%esi
  8018ff:	bf 02 00 00 00       	mov    $0x2,%edi
  801904:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	callq  *%rax
}
  801910:	c9                   	leaveq 
  801911:	c3                   	retq   

0000000000801912 <sys_yield>:

void
sys_yield(void)
{
  801912:	55                   	push   %rbp
  801913:	48 89 e5             	mov    %rsp,%rbp
  801916:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80191a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801921:	00 
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	be 00 00 00 00       	mov    $0x0,%esi
  80193d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801942:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801949:	00 00 00 
  80194c:	ff d0                	callq  *%rax
}
  80194e:	c9                   	leaveq 
  80194f:	c3                   	retq   

0000000000801950 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801950:	55                   	push   %rbp
  801951:	48 89 e5             	mov    %rsp,%rbp
  801954:	48 83 ec 20          	sub    $0x20,%rsp
  801958:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801962:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801965:	48 63 c8             	movslq %eax,%rcx
  801968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196f:	48 98                	cltq   
  801971:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801978:	00 
  801979:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197f:	49 89 c8             	mov    %rcx,%r8
  801982:	48 89 d1             	mov    %rdx,%rcx
  801985:	48 89 c2             	mov    %rax,%rdx
  801988:	be 01 00 00 00       	mov    $0x1,%esi
  80198d:	bf 04 00 00 00       	mov    $0x4,%edi
  801992:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801999:	00 00 00 
  80199c:	ff d0                	callq  *%rax
}
  80199e:	c9                   	leaveq 
  80199f:	c3                   	retq   

00000000008019a0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a0:	55                   	push   %rbp
  8019a1:	48 89 e5             	mov    %rsp,%rbp
  8019a4:	48 83 ec 30          	sub    $0x30,%rsp
  8019a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019af:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019b6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019bd:	48 63 c8             	movslq %eax,%rcx
  8019c0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c7:	48 63 f0             	movslq %eax,%rsi
  8019ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d1:	48 98                	cltq   
  8019d3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019d7:	49 89 f9             	mov    %rdi,%r9
  8019da:	49 89 f0             	mov    %rsi,%r8
  8019dd:	48 89 d1             	mov    %rdx,%rcx
  8019e0:	48 89 c2             	mov    %rax,%rdx
  8019e3:	be 01 00 00 00       	mov    $0x1,%esi
  8019e8:	bf 05 00 00 00       	mov    $0x5,%edi
  8019ed:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  8019f4:	00 00 00 
  8019f7:	ff d0                	callq  *%rax
}
  8019f9:	c9                   	leaveq 
  8019fa:	c3                   	retq   

00000000008019fb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 20          	sub    $0x20,%rsp
  801a03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a11:	48 98                	cltq   
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 01 00 00 00       	mov    $0x1,%esi
  801a32:	bf 06 00 00 00       	mov    $0x6,%edi
  801a37:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 20          	sub    $0x20,%rsp
  801a4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a50:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a56:	48 63 d0             	movslq %eax,%rdx
  801a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5c:	48 98                	cltq   
  801a5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a65:	00 
  801a66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a72:	48 89 d1             	mov    %rdx,%rcx
  801a75:	48 89 c2             	mov    %rax,%rdx
  801a78:	be 01 00 00 00       	mov    $0x1,%esi
  801a7d:	bf 08 00 00 00       	mov    $0x8,%edi
  801a82:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	callq  *%rax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 20          	sub    $0x20,%rsp
  801a98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa6:	48 98                	cltq   
  801aa8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aaf:	00 
  801ab0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abc:	48 89 d1             	mov    %rdx,%rcx
  801abf:	48 89 c2             	mov    %rax,%rdx
  801ac2:	be 01 00 00 00       	mov    $0x1,%esi
  801ac7:	bf 09 00 00 00       	mov    $0x9,%edi
  801acc:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	callq  *%rax
}
  801ad8:	c9                   	leaveq 
  801ad9:	c3                   	retq   

0000000000801ada <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	48 83 ec 20          	sub    $0x20,%rsp
  801ae2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ae9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af0:	48 98                	cltq   
  801af2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af9:	00 
  801afa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b06:	48 89 d1             	mov    %rdx,%rcx
  801b09:	48 89 c2             	mov    %rax,%rdx
  801b0c:	be 01 00 00 00       	mov    $0x1,%esi
  801b11:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b16:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	callq  *%rax
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 30          	sub    $0x30,%rsp
  801b2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b37:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3d:	48 63 f0             	movslq %eax,%rsi
  801b40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b47:	48 98                	cltq   
  801b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b54:	00 
  801b55:	49 89 f1             	mov    %rsi,%r9
  801b58:	49 89 c8             	mov    %rcx,%r8
  801b5b:	48 89 d1             	mov    %rdx,%rcx
  801b5e:	48 89 c2             	mov    %rax,%rdx
  801b61:	be 00 00 00 00       	mov    $0x0,%esi
  801b66:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b6b:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	callq  *%rax
}
  801b77:	c9                   	leaveq 
  801b78:	c3                   	retq   

0000000000801b79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b79:	55                   	push   %rbp
  801b7a:	48 89 e5             	mov    %rsp,%rbp
  801b7d:	48 83 ec 20          	sub    $0x20,%rsp
  801b81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b90:	00 
  801b91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba2:	48 89 c2             	mov    %rax,%rdx
  801ba5:	be 01 00 00 00       	mov    $0x1,%esi
  801baa:	bf 0d 00 00 00       	mov    $0xd,%edi
  801baf:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801bb6:	00 00 00 
  801bb9:	ff d0                	callq  *%rax
}
  801bbb:	c9                   	leaveq 
  801bbc:	c3                   	retq   

0000000000801bbd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801bbd:	55                   	push   %rbp
  801bbe:	48 89 e5             	mov    %rsp,%rbp
  801bc1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801bc5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bcc:	00 
  801bcd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bde:	ba 00 00 00 00       	mov    $0x0,%edx
  801be3:	be 00 00 00 00       	mov    $0x0,%esi
  801be8:	bf 0e 00 00 00       	mov    $0xe,%edi
  801bed:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801bf4:	00 00 00 
  801bf7:	ff d0                	callq  *%rax
}
  801bf9:	c9                   	leaveq 
  801bfa:	c3                   	retq   

0000000000801bfb <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	48 83 ec 20          	sub    $0x20,%rsp
  801c03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1a:	00 
  801c1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c27:	48 89 d1             	mov    %rdx,%rcx
  801c2a:	48 89 c2             	mov    %rax,%rdx
  801c2d:	be 00 00 00 00       	mov    $0x0,%esi
  801c32:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c37:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801c3e:	00 00 00 
  801c41:	ff d0                	callq  *%rax
}
  801c43:	c9                   	leaveq 
  801c44:	c3                   	retq   

0000000000801c45 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801c45:	55                   	push   %rbp
  801c46:	48 89 e5             	mov    %rsp,%rbp
  801c49:	48 83 ec 20          	sub    $0x20,%rsp
  801c4d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c51:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c5d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c64:	00 
  801c65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c71:	48 89 d1             	mov    %rdx,%rcx
  801c74:	48 89 c2             	mov    %rax,%rdx
  801c77:	be 00 00 00 00       	mov    $0x0,%esi
  801c7c:	bf 10 00 00 00       	mov    $0x10,%edi
  801c81:	48 b8 6c 17 80 00 00 	movabs $0x80176c,%rax
  801c88:	00 00 00 
  801c8b:	ff d0                	callq  *%rax
}
  801c8d:	c9                   	leaveq 
  801c8e:	c3                   	retq   
	...

0000000000801c90 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801c90:	55                   	push   %rbp
  801c91:	48 89 e5             	mov    %rsp,%rbp
  801c94:	48 83 ec 20          	sub    $0x20,%rsp
  801c98:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  801c9c:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801ca3:	00 00 00 
  801ca6:	48 8b 00             	mov    (%rax),%rax
  801ca9:	48 85 c0             	test   %rax,%rax
  801cac:	0f 85 8e 00 00 00    	jne    801d40 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  801cb2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  801cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  801cc0:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  801cc7:	00 00 00 
  801cca:	ff d0                	callq  *%rax
  801ccc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  801ccf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801cd3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cd6:	ba 07 00 00 00       	mov    $0x7,%edx
  801cdb:	48 89 ce             	mov    %rcx,%rsi
  801cde:	89 c7                	mov    %eax,%edi
  801ce0:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801ce7:	00 00 00 
  801cea:	ff d0                	callq  *%rax
  801cec:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  801cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801cf3:	74 30                	je     801d25 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  801cf5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801cf8:	89 c1                	mov    %eax,%ecx
  801cfa:	48 ba b0 43 80 00 00 	movabs $0x8043b0,%rdx
  801d01:	00 00 00 
  801d04:	be 24 00 00 00       	mov    $0x24,%esi
  801d09:	48 bf e7 43 80 00 00 	movabs $0x8043e7,%rdi
  801d10:	00 00 00 
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	49 b8 20 02 80 00 00 	movabs $0x800220,%r8
  801d1f:	00 00 00 
  801d22:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801d25:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d28:	48 be 54 1d 80 00 00 	movabs $0x801d54,%rsi
  801d2f:	00 00 00 
  801d32:	89 c7                	mov    %eax,%edi
  801d34:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  801d3b:	00 00 00 
  801d3e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801d40:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  801d47:	00 00 00 
  801d4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d4e:	48 89 10             	mov    %rdx,(%rax)
}
  801d51:	c9                   	leaveq 
  801d52:	c3                   	retq   
	...

0000000000801d54 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801d54:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801d57:	48 a1 50 70 80 00 00 	movabs 0x807050,%rax
  801d5e:	00 00 00 
	call *%rax
  801d61:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  801d63:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  801d67:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  801d6b:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  801d6e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801d75:	00 
		movq 120(%rsp), %rcx				// trap time rip
  801d76:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  801d7b:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  801d7e:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  801d7f:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  801d82:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  801d89:	00 08 
		POPA_						// copy the register contents to the registers
  801d8b:	4c 8b 3c 24          	mov    (%rsp),%r15
  801d8f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801d94:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801d99:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801d9e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801da3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801da8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801dad:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801db2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801db7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801dbc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801dc1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801dc6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801dcb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801dd0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801dd5:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  801dd9:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  801ddd:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  801dde:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  801ddf:	c3                   	retq   

0000000000801de0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801de0:	55                   	push   %rbp
  801de1:	48 89 e5             	mov    %rsp,%rbp
  801de4:	48 83 ec 08          	sub    $0x8,%rsp
  801de8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801df7:	ff ff ff 
  801dfa:	48 01 d0             	add    %rdx,%rax
  801dfd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801e01:	c9                   	leaveq 
  801e02:	c3                   	retq   

0000000000801e03 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801e03:	55                   	push   %rbp
  801e04:	48 89 e5             	mov    %rsp,%rbp
  801e07:	48 83 ec 08          	sub    $0x8,%rsp
  801e0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801e0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e13:	48 89 c7             	mov    %rax,%rdi
  801e16:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  801e1d:	00 00 00 
  801e20:	ff d0                	callq  *%rax
  801e22:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e28:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e2c:	c9                   	leaveq 
  801e2d:	c3                   	retq   

0000000000801e2e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e2e:	55                   	push   %rbp
  801e2f:	48 89 e5             	mov    %rsp,%rbp
  801e32:	48 83 ec 18          	sub    $0x18,%rsp
  801e36:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e41:	eb 6b                	jmp    801eae <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e46:	48 98                	cltq   
  801e48:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e4e:	48 c1 e0 0c          	shl    $0xc,%rax
  801e52:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5a:	48 89 c2             	mov    %rax,%rdx
  801e5d:	48 c1 ea 15          	shr    $0x15,%rdx
  801e61:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e68:	01 00 00 
  801e6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6f:	83 e0 01             	and    $0x1,%eax
  801e72:	48 85 c0             	test   %rax,%rax
  801e75:	74 21                	je     801e98 <fd_alloc+0x6a>
  801e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7b:	48 89 c2             	mov    %rax,%rdx
  801e7e:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e82:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e89:	01 00 00 
  801e8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e90:	83 e0 01             	and    $0x1,%eax
  801e93:	48 85 c0             	test   %rax,%rax
  801e96:	75 12                	jne    801eaa <fd_alloc+0x7c>
			*fd_store = fd;
  801e98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea8:	eb 1a                	jmp    801ec4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801eaa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eae:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801eb2:	7e 8f                	jle    801e43 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eb8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801ebf:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801ec4:	c9                   	leaveq 
  801ec5:	c3                   	retq   

0000000000801ec6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ec6:	55                   	push   %rbp
  801ec7:	48 89 e5             	mov    %rsp,%rbp
  801eca:	48 83 ec 20          	sub    $0x20,%rsp
  801ece:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ed5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ed9:	78 06                	js     801ee1 <fd_lookup+0x1b>
  801edb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801edf:	7e 07                	jle    801ee8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ee1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ee6:	eb 6c                	jmp    801f54 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ee8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801eeb:	48 98                	cltq   
  801eed:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ef3:	48 c1 e0 0c          	shl    $0xc,%rax
  801ef7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801efb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eff:	48 89 c2             	mov    %rax,%rdx
  801f02:	48 c1 ea 15          	shr    $0x15,%rdx
  801f06:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f0d:	01 00 00 
  801f10:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f14:	83 e0 01             	and    $0x1,%eax
  801f17:	48 85 c0             	test   %rax,%rax
  801f1a:	74 21                	je     801f3d <fd_lookup+0x77>
  801f1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f20:	48 89 c2             	mov    %rax,%rdx
  801f23:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f2e:	01 00 00 
  801f31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f35:	83 e0 01             	and    $0x1,%eax
  801f38:	48 85 c0             	test   %rax,%rax
  801f3b:	75 07                	jne    801f44 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f42:	eb 10                	jmp    801f54 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f48:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f4c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f54:	c9                   	leaveq 
  801f55:	c3                   	retq   

0000000000801f56 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f56:	55                   	push   %rbp
  801f57:	48 89 e5             	mov    %rsp,%rbp
  801f5a:	48 83 ec 30          	sub    $0x30,%rsp
  801f5e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f62:	89 f0                	mov    %esi,%eax
  801f64:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f6b:	48 89 c7             	mov    %rax,%rdi
  801f6e:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f7e:	48 89 d6             	mov    %rdx,%rsi
  801f81:	89 c7                	mov    %eax,%edi
  801f83:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax
  801f8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f96:	78 0a                	js     801fa2 <fd_close+0x4c>
	    || fd != fd2)
  801f98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801fa0:	74 12                	je     801fb4 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801fa2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801fa6:	74 05                	je     801fad <fd_close+0x57>
  801fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fab:	eb 05                	jmp    801fb2 <fd_close+0x5c>
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	eb 69                	jmp    80201d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fb4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb8:	8b 00                	mov    (%rax),%eax
  801fba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fbe:	48 89 d6             	mov    %rdx,%rsi
  801fc1:	89 c7                	mov    %eax,%edi
  801fc3:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  801fca:	00 00 00 
  801fcd:	ff d0                	callq  *%rax
  801fcf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fd2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd6:	78 2a                	js     802002 <fd_close+0xac>
		if (dev->dev_close)
  801fd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fdc:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fe0:	48 85 c0             	test   %rax,%rax
  801fe3:	74 16                	je     801ffb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fe9:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801fed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff1:	48 89 c7             	mov    %rax,%rdi
  801ff4:	ff d2                	callq  *%rdx
  801ff6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff9:	eb 07                	jmp    802002 <fd_close+0xac>
		else
			r = 0;
  801ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802002:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802006:	48 89 c6             	mov    %rax,%rsi
  802009:	bf 00 00 00 00       	mov    $0x0,%edi
  80200e:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802015:	00 00 00 
  802018:	ff d0                	callq  *%rax
	return r;
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80201d:	c9                   	leaveq 
  80201e:	c3                   	retq   

000000000080201f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80201f:	55                   	push   %rbp
  802020:	48 89 e5             	mov    %rsp,%rbp
  802023:	48 83 ec 20          	sub    $0x20,%rsp
  802027:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80202a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80202e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802035:	eb 41                	jmp    802078 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802037:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80203e:	00 00 00 
  802041:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802044:	48 63 d2             	movslq %edx,%rdx
  802047:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204b:	8b 00                	mov    (%rax),%eax
  80204d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802050:	75 22                	jne    802074 <dev_lookup+0x55>
			*dev = devtab[i];
  802052:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802059:	00 00 00 
  80205c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80205f:	48 63 d2             	movslq %edx,%rdx
  802062:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802066:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80206a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	eb 60                	jmp    8020d4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802074:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802078:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80207f:	00 00 00 
  802082:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802085:	48 63 d2             	movslq %edx,%rdx
  802088:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80208c:	48 85 c0             	test   %rax,%rax
  80208f:	75 a6                	jne    802037 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802091:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802098:	00 00 00 
  80209b:	48 8b 00             	mov    (%rax),%rax
  80209e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020a4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020a7:	89 c6                	mov    %eax,%esi
  8020a9:	48 bf f8 43 80 00 00 	movabs $0x8043f8,%rdi
  8020b0:	00 00 00 
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b8:	48 b9 5b 04 80 00 00 	movabs $0x80045b,%rcx
  8020bf:	00 00 00 
  8020c2:	ff d1                	callq  *%rcx
	*dev = 0;
  8020c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020c8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020d4:	c9                   	leaveq 
  8020d5:	c3                   	retq   

00000000008020d6 <close>:

int
close(int fdnum)
{
  8020d6:	55                   	push   %rbp
  8020d7:	48 89 e5             	mov    %rsp,%rbp
  8020da:	48 83 ec 20          	sub    $0x20,%rsp
  8020de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020e8:	48 89 d6             	mov    %rdx,%rsi
  8020eb:	89 c7                	mov    %eax,%edi
  8020ed:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8020f4:	00 00 00 
  8020f7:	ff d0                	callq  *%rax
  8020f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802100:	79 05                	jns    802107 <close+0x31>
		return r;
  802102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802105:	eb 18                	jmp    80211f <close+0x49>
	else
		return fd_close(fd, 1);
  802107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80210b:	be 01 00 00 00       	mov    $0x1,%esi
  802110:	48 89 c7             	mov    %rax,%rdi
  802113:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  80211a:	00 00 00 
  80211d:	ff d0                	callq  *%rax
}
  80211f:	c9                   	leaveq 
  802120:	c3                   	retq   

0000000000802121 <close_all>:

void
close_all(void)
{
  802121:	55                   	push   %rbp
  802122:	48 89 e5             	mov    %rsp,%rbp
  802125:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802130:	eb 15                	jmp    802147 <close_all+0x26>
		close(i);
  802132:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802135:	89 c7                	mov    %eax,%edi
  802137:	48 b8 d6 20 80 00 00 	movabs $0x8020d6,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802143:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802147:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80214b:	7e e5                	jle    802132 <close_all+0x11>
		close(i);
}
  80214d:	c9                   	leaveq 
  80214e:	c3                   	retq   

000000000080214f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80214f:	55                   	push   %rbp
  802150:	48 89 e5             	mov    %rsp,%rbp
  802153:	48 83 ec 40          	sub    $0x40,%rsp
  802157:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80215a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80215d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802161:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802164:	48 89 d6             	mov    %rdx,%rsi
  802167:	89 c7                	mov    %eax,%edi
  802169:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802170:	00 00 00 
  802173:	ff d0                	callq  *%rax
  802175:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802178:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80217c:	79 08                	jns    802186 <dup+0x37>
		return r;
  80217e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802181:	e9 70 01 00 00       	jmpq   8022f6 <dup+0x1a7>
	close(newfdnum);
  802186:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802189:	89 c7                	mov    %eax,%edi
  80218b:	48 b8 d6 20 80 00 00 	movabs $0x8020d6,%rax
  802192:	00 00 00 
  802195:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802197:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80219a:	48 98                	cltq   
  80219c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021a2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8021aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ae:	48 89 c7             	mov    %rax,%rdi
  8021b1:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8021b8:	00 00 00 
  8021bb:	ff d0                	callq  *%rax
  8021bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c5:	48 89 c7             	mov    %rax,%rdi
  8021c8:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8021cf:	00 00 00 
  8021d2:	ff d0                	callq  *%rax
  8021d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	48 c1 ea 15          	shr    $0x15,%rdx
  8021e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ea:	01 00 00 
  8021ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f1:	83 e0 01             	and    $0x1,%eax
  8021f4:	84 c0                	test   %al,%al
  8021f6:	74 71                	je     802269 <dup+0x11a>
  8021f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021fc:	48 89 c2             	mov    %rax,%rdx
  8021ff:	48 c1 ea 0c          	shr    $0xc,%rdx
  802203:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220a:	01 00 00 
  80220d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802211:	83 e0 01             	and    $0x1,%eax
  802214:	84 c0                	test   %al,%al
  802216:	74 51                	je     802269 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802218:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221c:	48 89 c2             	mov    %rax,%rdx
  80221f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802223:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80222a:	01 00 00 
  80222d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802231:	89 c1                	mov    %eax,%ecx
  802233:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802239:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80223d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802241:	41 89 c8             	mov    %ecx,%r8d
  802244:	48 89 d1             	mov    %rdx,%rcx
  802247:	ba 00 00 00 00       	mov    $0x0,%edx
  80224c:	48 89 c6             	mov    %rax,%rsi
  80224f:	bf 00 00 00 00       	mov    $0x0,%edi
  802254:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80225b:	00 00 00 
  80225e:	ff d0                	callq  *%rax
  802260:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802267:	78 56                	js     8022bf <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802269:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80226d:	48 89 c2             	mov    %rax,%rdx
  802270:	48 c1 ea 0c          	shr    $0xc,%rdx
  802274:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80227b:	01 00 00 
  80227e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802282:	89 c1                	mov    %eax,%ecx
  802284:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80228a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80228e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802292:	41 89 c8             	mov    %ecx,%r8d
  802295:	48 89 d1             	mov    %rdx,%rcx
  802298:	ba 00 00 00 00       	mov    $0x0,%edx
  80229d:	48 89 c6             	mov    %rax,%rsi
  8022a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a5:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  8022ac:	00 00 00 
  8022af:	ff d0                	callq  *%rax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022b8:	78 08                	js     8022c2 <dup+0x173>
		goto err;

	return newfdnum;
  8022ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022bd:	eb 37                	jmp    8022f6 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022bf:	90                   	nop
  8022c0:	eb 01                	jmp    8022c3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022c2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022c7:	48 89 c6             	mov    %rax,%rsi
  8022ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cf:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8022d6:	00 00 00 
  8022d9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022df:	48 89 c6             	mov    %rax,%rsi
  8022e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e7:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8022ee:	00 00 00 
  8022f1:	ff d0                	callq  *%rax
	return r;
  8022f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022f6:	c9                   	leaveq 
  8022f7:	c3                   	retq   

00000000008022f8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022f8:	55                   	push   %rbp
  8022f9:	48 89 e5             	mov    %rsp,%rbp
  8022fc:	48 83 ec 40          	sub    $0x40,%rsp
  802300:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802303:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802307:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80230f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802312:	48 89 d6             	mov    %rdx,%rsi
  802315:	89 c7                	mov    %eax,%edi
  802317:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
  802323:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802326:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232a:	78 24                	js     802350 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80232c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802330:	8b 00                	mov    (%rax),%eax
  802332:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802336:	48 89 d6             	mov    %rdx,%rsi
  802339:	89 c7                	mov    %eax,%edi
  80233b:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802342:	00 00 00 
  802345:	ff d0                	callq  *%rax
  802347:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80234e:	79 05                	jns    802355 <read+0x5d>
		return r;
  802350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802353:	eb 7a                	jmp    8023cf <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802359:	8b 40 08             	mov    0x8(%rax),%eax
  80235c:	83 e0 03             	and    $0x3,%eax
  80235f:	83 f8 01             	cmp    $0x1,%eax
  802362:	75 3a                	jne    80239e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802364:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80236b:	00 00 00 
  80236e:	48 8b 00             	mov    (%rax),%rax
  802371:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802377:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80237a:	89 c6                	mov    %eax,%esi
  80237c:	48 bf 17 44 80 00 00 	movabs $0x804417,%rdi
  802383:	00 00 00 
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
  80238b:	48 b9 5b 04 80 00 00 	movabs $0x80045b,%rcx
  802392:	00 00 00 
  802395:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80239c:	eb 31                	jmp    8023cf <read+0xd7>
	}
	if (!dev->dev_read)
  80239e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a6:	48 85 c0             	test   %rax,%rax
  8023a9:	75 07                	jne    8023b2 <read+0xba>
		return -E_NOT_SUPP;
  8023ab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023b0:	eb 1d                	jmp    8023cf <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  8023b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b6:	4c 8b 40 10          	mov    0x10(%rax),%r8
  8023ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023c2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8023c6:	48 89 ce             	mov    %rcx,%rsi
  8023c9:	48 89 c7             	mov    %rax,%rdi
  8023cc:	41 ff d0             	callq  *%r8
}
  8023cf:	c9                   	leaveq 
  8023d0:	c3                   	retq   

00000000008023d1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023d1:	55                   	push   %rbp
  8023d2:	48 89 e5             	mov    %rsp,%rbp
  8023d5:	48 83 ec 30          	sub    $0x30,%rsp
  8023d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023eb:	eb 46                	jmp    802433 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023f0:	48 98                	cltq   
  8023f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023f6:	48 29 c2             	sub    %rax,%rdx
  8023f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fc:	48 98                	cltq   
  8023fe:	48 89 c1             	mov    %rax,%rcx
  802401:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802405:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802408:	48 89 ce             	mov    %rcx,%rsi
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  802414:	00 00 00 
  802417:	ff d0                	callq  *%rax
  802419:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80241c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802420:	79 05                	jns    802427 <readn+0x56>
			return m;
  802422:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802425:	eb 1d                	jmp    802444 <readn+0x73>
		if (m == 0)
  802427:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80242b:	74 13                	je     802440 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80242d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802430:	01 45 fc             	add    %eax,-0x4(%rbp)
  802433:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802436:	48 98                	cltq   
  802438:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80243c:	72 af                	jb     8023ed <readn+0x1c>
  80243e:	eb 01                	jmp    802441 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802440:	90                   	nop
	}
	return tot;
  802441:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802444:	c9                   	leaveq 
  802445:	c3                   	retq   

0000000000802446 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802446:	55                   	push   %rbp
  802447:	48 89 e5             	mov    %rsp,%rbp
  80244a:	48 83 ec 40          	sub    $0x40,%rsp
  80244e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802451:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802455:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802459:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80245d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802460:	48 89 d6             	mov    %rdx,%rsi
  802463:	89 c7                	mov    %eax,%edi
  802465:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80246c:	00 00 00 
  80246f:	ff d0                	callq  *%rax
  802471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802478:	78 24                	js     80249e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80247a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80247e:	8b 00                	mov    (%rax),%eax
  802480:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802484:	48 89 d6             	mov    %rdx,%rsi
  802487:	89 c7                	mov    %eax,%edi
  802489:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802490:	00 00 00 
  802493:	ff d0                	callq  *%rax
  802495:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802498:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80249c:	79 05                	jns    8024a3 <write+0x5d>
		return r;
  80249e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a1:	eb 79                	jmp    80251c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a7:	8b 40 08             	mov    0x8(%rax),%eax
  8024aa:	83 e0 03             	and    $0x3,%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	75 3a                	jne    8024eb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8024b1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8024b8:	00 00 00 
  8024bb:	48 8b 00             	mov    (%rax),%rax
  8024be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024c7:	89 c6                	mov    %eax,%esi
  8024c9:	48 bf 33 44 80 00 00 	movabs $0x804433,%rdi
  8024d0:	00 00 00 
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	48 b9 5b 04 80 00 00 	movabs $0x80045b,%rcx
  8024df:	00 00 00 
  8024e2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024e9:	eb 31                	jmp    80251c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024f3:	48 85 c0             	test   %rax,%rax
  8024f6:	75 07                	jne    8024ff <write+0xb9>
		return -E_NOT_SUPP;
  8024f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024fd:	eb 1d                	jmp    80251c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  8024ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802503:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802507:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80250f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802513:	48 89 ce             	mov    %rcx,%rsi
  802516:	48 89 c7             	mov    %rax,%rdi
  802519:	41 ff d0             	callq  *%r8
}
  80251c:	c9                   	leaveq 
  80251d:	c3                   	retq   

000000000080251e <seek>:

int
seek(int fdnum, off_t offset)
{
  80251e:	55                   	push   %rbp
  80251f:	48 89 e5             	mov    %rsp,%rbp
  802522:	48 83 ec 18          	sub    $0x18,%rsp
  802526:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802529:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80252c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802530:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802533:	48 89 d6             	mov    %rdx,%rsi
  802536:	89 c7                	mov    %eax,%edi
  802538:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80253f:	00 00 00 
  802542:	ff d0                	callq  *%rax
  802544:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254b:	79 05                	jns    802552 <seek+0x34>
		return r;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802550:	eb 0f                	jmp    802561 <seek+0x43>
	fd->fd_offset = offset;
  802552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802556:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802559:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80255c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802561:	c9                   	leaveq 
  802562:	c3                   	retq   

0000000000802563 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802563:	55                   	push   %rbp
  802564:	48 89 e5             	mov    %rsp,%rbp
  802567:	48 83 ec 30          	sub    $0x30,%rsp
  80256b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80256e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802571:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802575:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802578:	48 89 d6             	mov    %rdx,%rsi
  80257b:	89 c7                	mov    %eax,%edi
  80257d:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802584:	00 00 00 
  802587:	ff d0                	callq  *%rax
  802589:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80258c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802590:	78 24                	js     8025b6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802596:	8b 00                	mov    (%rax),%eax
  802598:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80259c:	48 89 d6             	mov    %rdx,%rsi
  80259f:	89 c7                	mov    %eax,%edi
  8025a1:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  8025a8:	00 00 00 
  8025ab:	ff d0                	callq  *%rax
  8025ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b4:	79 05                	jns    8025bb <ftruncate+0x58>
		return r;
  8025b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025b9:	eb 72                	jmp    80262d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bf:	8b 40 08             	mov    0x8(%rax),%eax
  8025c2:	83 e0 03             	and    $0x3,%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	75 3a                	jne    802603 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025c9:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8025d0:	00 00 00 
  8025d3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025d6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025df:	89 c6                	mov    %eax,%esi
  8025e1:	48 bf 50 44 80 00 00 	movabs $0x804450,%rdi
  8025e8:	00 00 00 
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f0:	48 b9 5b 04 80 00 00 	movabs $0x80045b,%rcx
  8025f7:	00 00 00 
  8025fa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802601:	eb 2a                	jmp    80262d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802607:	48 8b 40 30          	mov    0x30(%rax),%rax
  80260b:	48 85 c0             	test   %rax,%rax
  80260e:	75 07                	jne    802617 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802610:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802615:	eb 16                	jmp    80262d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802617:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80261b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  80261f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802623:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802626:	89 d6                	mov    %edx,%esi
  802628:	48 89 c7             	mov    %rax,%rdi
  80262b:	ff d1                	callq  *%rcx
}
  80262d:	c9                   	leaveq 
  80262e:	c3                   	retq   

000000000080262f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80262f:	55                   	push   %rbp
  802630:	48 89 e5             	mov    %rsp,%rbp
  802633:	48 83 ec 30          	sub    $0x30,%rsp
  802637:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80263a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80263e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802642:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802645:	48 89 d6             	mov    %rdx,%rsi
  802648:	89 c7                	mov    %eax,%edi
  80264a:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802651:	00 00 00 
  802654:	ff d0                	callq  *%rax
  802656:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802659:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80265d:	78 24                	js     802683 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80265f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802663:	8b 00                	mov    (%rax),%eax
  802665:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802669:	48 89 d6             	mov    %rdx,%rsi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	48 b8 1f 20 80 00 00 	movabs $0x80201f,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802681:	79 05                	jns    802688 <fstat+0x59>
		return r;
  802683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802686:	eb 5e                	jmp    8026e6 <fstat+0xb7>
	if (!dev->dev_stat)
  802688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80268c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802690:	48 85 c0             	test   %rax,%rax
  802693:	75 07                	jne    80269c <fstat+0x6d>
		return -E_NOT_SUPP;
  802695:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80269a:	eb 4a                	jmp    8026e6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80269c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8026a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026a7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8026ae:	00 00 00 
	stat->st_isdir = 0;
  8026b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026b5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026bc:	00 00 00 
	stat->st_dev = dev;
  8026bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026c7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d2:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026da:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8026de:	48 89 d6             	mov    %rdx,%rsi
  8026e1:	48 89 c7             	mov    %rax,%rdi
  8026e4:	ff d1                	callq  *%rcx
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
  8026f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026fc:	be 00 00 00 00       	mov    $0x0,%esi
  802701:	48 89 c7             	mov    %rax,%rdi
  802704:	48 b8 d7 27 80 00 00 	movabs $0x8027d7,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802717:	79 05                	jns    80271e <stat+0x36>
		return fd;
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	eb 2f                	jmp    80274d <stat+0x65>
	r = fstat(fd, stat);
  80271e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802725:	48 89 d6             	mov    %rdx,%rsi
  802728:	89 c7                	mov    %eax,%edi
  80272a:	48 b8 2f 26 80 00 00 	movabs $0x80262f,%rax
  802731:	00 00 00 
  802734:	ff d0                	callq  *%rax
  802736:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273c:	89 c7                	mov    %eax,%edi
  80273e:	48 b8 d6 20 80 00 00 	movabs $0x8020d6,%rax
  802745:	00 00 00 
  802748:	ff d0                	callq  *%rax
	return r;
  80274a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80274d:	c9                   	leaveq 
  80274e:	c3                   	retq   
	...

0000000000802750 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802750:	55                   	push   %rbp
  802751:	48 89 e5             	mov    %rsp,%rbp
  802754:	48 83 ec 10          	sub    $0x10,%rsp
  802758:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80275b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80275f:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802766:	00 00 00 
  802769:	8b 00                	mov    (%rax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	75 1d                	jne    80278c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80276f:	bf 01 00 00 00       	mov    $0x1,%edi
  802774:	48 b8 f3 3c 80 00 00 	movabs $0x803cf3,%rax
  80277b:	00 00 00 
  80277e:	ff d0                	callq  *%rax
  802780:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802787:	00 00 00 
  80278a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80278c:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802793:	00 00 00 
  802796:	8b 00                	mov    (%rax),%eax
  802798:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80279b:	b9 07 00 00 00       	mov    $0x7,%ecx
  8027a0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8027a7:	00 00 00 
  8027aa:	89 c7                	mov    %eax,%edi
  8027ac:	48 b8 30 3c 80 00 00 	movabs $0x803c30,%rax
  8027b3:	00 00 00 
  8027b6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c1:	48 89 c6             	mov    %rax,%rsi
  8027c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8027c9:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  8027d0:	00 00 00 
  8027d3:	ff d0                	callq  *%rax
}
  8027d5:	c9                   	leaveq 
  8027d6:	c3                   	retq   

00000000008027d7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027d7:	55                   	push   %rbp
  8027d8:	48 89 e5             	mov    %rsp,%rbp
  8027db:	48 83 ec 20          	sub    $0x20,%rsp
  8027df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8027e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ea:	48 89 c7             	mov    %rax,%rdi
  8027ed:	48 b8 ac 0f 80 00 00 	movabs $0x800fac,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
  8027f9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027fe:	7e 0a                	jle    80280a <open+0x33>
                return -E_BAD_PATH;
  802800:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802805:	e9 a5 00 00 00       	jmpq   8028af <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80280a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80280e:	48 89 c7             	mov    %rax,%rdi
  802811:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802818:	00 00 00 
  80281b:	ff d0                	callq  *%rax
  80281d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802824:	79 08                	jns    80282e <open+0x57>
		return r;
  802826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802829:	e9 81 00 00 00       	jmpq   8028af <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80282e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802832:	48 89 c6             	mov    %rax,%rsi
  802835:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80283c:	00 00 00 
  80283f:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  802846:	00 00 00 
  802849:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80284b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802852:	00 00 00 
  802855:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802858:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80285e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802862:	48 89 c6             	mov    %rax,%rsi
  802865:	bf 01 00 00 00       	mov    $0x1,%edi
  80286a:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  802871:	00 00 00 
  802874:	ff d0                	callq  *%rax
  802876:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287d:	79 1d                	jns    80289c <open+0xc5>
	{
		fd_close(fd,0);
  80287f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802883:	be 00 00 00 00       	mov    $0x0,%esi
  802888:	48 89 c7             	mov    %rax,%rdi
  80288b:	48 b8 56 1f 80 00 00 	movabs $0x801f56,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
		return r;
  802897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289a:	eb 13                	jmp    8028af <open+0xd8>
	}
	return fd2num(fd);
  80289c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a0:	48 89 c7             	mov    %rax,%rdi
  8028a3:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
	


}
  8028af:	c9                   	leaveq 
  8028b0:	c3                   	retq   

00000000008028b1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8028b1:	55                   	push   %rbp
  8028b2:	48 89 e5             	mov    %rsp,%rbp
  8028b5:	48 83 ec 10          	sub    $0x10,%rsp
  8028b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028c1:	8b 50 0c             	mov    0xc(%rax),%edx
  8028c4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8028cb:	00 00 00 
  8028ce:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028d0:	be 00 00 00 00       	mov    $0x0,%esi
  8028d5:	bf 06 00 00 00       	mov    $0x6,%edi
  8028da:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  8028e1:	00 00 00 
  8028e4:	ff d0                	callq  *%rax
}
  8028e6:	c9                   	leaveq 
  8028e7:	c3                   	retq   

00000000008028e8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028e8:	55                   	push   %rbp
  8028e9:	48 89 e5             	mov    %rsp,%rbp
  8028ec:	48 83 ec 30          	sub    $0x30,%rsp
  8028f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	8b 50 0c             	mov    0xc(%rax),%edx
  802903:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80290a:	00 00 00 
  80290d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80290f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802916:	00 00 00 
  802919:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802921:	be 00 00 00 00       	mov    $0x0,%esi
  802926:	bf 03 00 00 00       	mov    $0x3,%edi
  80292b:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  802932:	00 00 00 
  802935:	ff d0                	callq  *%rax
  802937:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80293a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80293e:	79 05                	jns    802945 <devfile_read+0x5d>
	{
		return r;
  802940:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802943:	eb 2c                	jmp    802971 <devfile_read+0x89>
	}
	if(r > 0)
  802945:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802949:	7e 23                	jle    80296e <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80294b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80294e:	48 63 d0             	movslq %eax,%rdx
  802951:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802955:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80295c:	00 00 00 
  80295f:	48 89 c7             	mov    %rax,%rdi
  802962:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
	return r;
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802971:	c9                   	leaveq 
  802972:	c3                   	retq   

0000000000802973 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802973:	55                   	push   %rbp
  802974:	48 89 e5             	mov    %rsp,%rbp
  802977:	48 83 ec 30          	sub    $0x30,%rsp
  80297b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80297f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802983:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802987:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80298b:	8b 50 0c             	mov    0xc(%rax),%edx
  80298e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802995:	00 00 00 
  802998:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  80299a:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8029a1:	00 
  8029a2:	76 08                	jbe    8029ac <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8029a4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8029ab:	00 
	fsipcbuf.write.req_n=n;
  8029ac:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8029b3:	00 00 00 
  8029b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8029be:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c6:	48 89 c6             	mov    %rax,%rsi
  8029c9:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8029d0:	00 00 00 
  8029d3:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  8029da:	00 00 00 
  8029dd:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8029df:	be 00 00 00 00       	mov    $0x0,%esi
  8029e4:	bf 04 00 00 00       	mov    $0x4,%edi
  8029e9:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax
  8029f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 10          	sub    $0x10,%rsp
  802a05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a09:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802a0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a10:	8b 50 0c             	mov    0xc(%rax),%edx
  802a13:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a1a:	00 00 00 
  802a1d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802a1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a26:	00 00 00 
  802a29:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802a2f:	be 00 00 00 00       	mov    $0x0,%esi
  802a34:	bf 02 00 00 00       	mov    $0x2,%edi
  802a39:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
}
  802a45:	c9                   	leaveq 
  802a46:	c3                   	retq   

0000000000802a47 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802a47:	55                   	push   %rbp
  802a48:	48 89 e5             	mov    %rsp,%rbp
  802a4b:	48 83 ec 20          	sub    $0x20,%rsp
  802a4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a5b:	8b 50 0c             	mov    0xc(%rax),%edx
  802a5e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a65:	00 00 00 
  802a68:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a6a:	be 00 00 00 00       	mov    $0x0,%esi
  802a6f:	bf 05 00 00 00       	mov    $0x5,%edi
  802a74:	48 b8 50 27 80 00 00 	movabs $0x802750,%rax
  802a7b:	00 00 00 
  802a7e:	ff d0                	callq  *%rax
  802a80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a87:	79 05                	jns    802a8e <devfile_stat+0x47>
		return r;
  802a89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8c:	eb 56                	jmp    802ae4 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a92:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802a99:	00 00 00 
  802a9c:	48 89 c7             	mov    %rax,%rdi
  802a9f:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  802aa6:	00 00 00 
  802aa9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802aab:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ab2:	00 00 00 
  802ab5:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802abb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ac5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802acc:	00 00 00 
  802acf:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ad5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad9:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   
	...

0000000000802ae8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 20          	sub    $0x20,%rsp
  802af0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802af3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802af7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802afa:	48 89 d6             	mov    %rdx,%rsi
  802afd:	89 c7                	mov    %eax,%edi
  802aff:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  802b06:	00 00 00 
  802b09:	ff d0                	callq  *%rax
  802b0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b12:	79 05                	jns    802b19 <fd2sockid+0x31>
		return r;
  802b14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b17:	eb 24                	jmp    802b3d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802b19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1d:	8b 10                	mov    (%rax),%edx
  802b1f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802b26:	00 00 00 
  802b29:	8b 00                	mov    (%rax),%eax
  802b2b:	39 c2                	cmp    %eax,%edx
  802b2d:	74 07                	je     802b36 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802b2f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b34:	eb 07                	jmp    802b3d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802b36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b3a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802b3d:	c9                   	leaveq 
  802b3e:	c3                   	retq   

0000000000802b3f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802b3f:	55                   	push   %rbp
  802b40:	48 89 e5             	mov    %rsp,%rbp
  802b43:	48 83 ec 20          	sub    $0x20,%rsp
  802b47:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802b4a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b4e:	48 89 c7             	mov    %rax,%rdi
  802b51:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
  802b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b64:	78 26                	js     802b8c <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802b66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b6a:	ba 07 04 00 00       	mov    $0x407,%edx
  802b6f:	48 89 c6             	mov    %rax,%rsi
  802b72:	bf 00 00 00 00       	mov    $0x0,%edi
  802b77:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	79 16                	jns    802ba2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802b8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8f:	89 c7                	mov    %eax,%edi
  802b91:	48 b8 4c 30 80 00 00 	movabs $0x80304c,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
		return r;
  802b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba0:	eb 3a                	jmp    802bdc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802ba2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  802bad:	00 00 00 
  802bb0:	8b 12                	mov    (%rdx),%edx
  802bb2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802bb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802bbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802bc6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802bc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bcd:	48 89 c7             	mov    %rax,%rdi
  802bd0:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
}
  802bdc:	c9                   	leaveq 
  802bdd:	c3                   	retq   

0000000000802bde <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802bde:	55                   	push   %rbp
  802bdf:	48 89 e5             	mov    %rsp,%rbp
  802be2:	48 83 ec 30          	sub    $0x30,%rsp
  802be6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802be9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802bf1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf4:	89 c7                	mov    %eax,%edi
  802bf6:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802bfd:	00 00 00 
  802c00:	ff d0                	callq  *%rax
  802c02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c09:	79 05                	jns    802c10 <accept+0x32>
		return r;
  802c0b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c0e:	eb 3b                	jmp    802c4b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c10:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c14:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c1b:	48 89 ce             	mov    %rcx,%rsi
  802c1e:	89 c7                	mov    %eax,%edi
  802c20:	48 b8 29 2f 80 00 00 	movabs $0x802f29,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
  802c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c33:	79 05                	jns    802c3a <accept+0x5c>
		return r;
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c38:	eb 11                	jmp    802c4b <accept+0x6d>
	return alloc_sockfd(r);
  802c3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c3d:	89 c7                	mov    %eax,%edi
  802c3f:	48 b8 3f 2b 80 00 00 	movabs $0x802b3f,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
}
  802c4b:	c9                   	leaveq 
  802c4c:	c3                   	retq   

0000000000802c4d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c4d:	55                   	push   %rbp
  802c4e:	48 89 e5             	mov    %rsp,%rbp
  802c51:	48 83 ec 20          	sub    $0x20,%rsp
  802c55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c5c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c62:	89 c7                	mov    %eax,%edi
  802c64:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802c6b:	00 00 00 
  802c6e:	ff d0                	callq  *%rax
  802c70:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c73:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c77:	79 05                	jns    802c7e <bind+0x31>
		return r;
  802c79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7c:	eb 1b                	jmp    802c99 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802c7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c81:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c88:	48 89 ce             	mov    %rcx,%rsi
  802c8b:	89 c7                	mov    %eax,%edi
  802c8d:	48 b8 a8 2f 80 00 00 	movabs $0x802fa8,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
}
  802c99:	c9                   	leaveq 
  802c9a:	c3                   	retq   

0000000000802c9b <shutdown>:

int
shutdown(int s, int how)
{
  802c9b:	55                   	push   %rbp
  802c9c:	48 89 e5             	mov    %rsp,%rbp
  802c9f:	48 83 ec 20          	sub    $0x20,%rsp
  802ca3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ca6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ca9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cac:	89 c7                	mov    %eax,%edi
  802cae:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
  802cba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc1:	79 05                	jns    802cc8 <shutdown+0x2d>
		return r;
  802cc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc6:	eb 16                	jmp    802cde <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802cc8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ccb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cce:	89 d6                	mov    %edx,%esi
  802cd0:	89 c7                	mov    %eax,%edi
  802cd2:	48 b8 0c 30 80 00 00 	movabs $0x80300c,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
}
  802cde:	c9                   	leaveq 
  802cdf:	c3                   	retq   

0000000000802ce0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ce0:	55                   	push   %rbp
  802ce1:	48 89 e5             	mov    %rsp,%rbp
  802ce4:	48 83 ec 10          	sub    $0x10,%rsp
  802ce8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  802cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cf0:	48 89 c7             	mov    %rax,%rdi
  802cf3:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  802cfa:	00 00 00 
  802cfd:	ff d0                	callq  *%rax
  802cff:	83 f8 01             	cmp    $0x1,%eax
  802d02:	75 17                	jne    802d1b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  802d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d08:	8b 40 0c             	mov    0xc(%rax),%eax
  802d0b:	89 c7                	mov    %eax,%edi
  802d0d:	48 b8 4c 30 80 00 00 	movabs $0x80304c,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	eb 05                	jmp    802d20 <devsock_close+0x40>
	else
		return 0;
  802d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d20:	c9                   	leaveq 
  802d21:	c3                   	retq   

0000000000802d22 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d22:	55                   	push   %rbp
  802d23:	48 89 e5             	mov    %rsp,%rbp
  802d26:	48 83 ec 20          	sub    $0x20,%rsp
  802d2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d31:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d37:	89 c7                	mov    %eax,%edi
  802d39:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802d40:	00 00 00 
  802d43:	ff d0                	callq  *%rax
  802d45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d4c:	79 05                	jns    802d53 <connect+0x31>
		return r;
  802d4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d51:	eb 1b                	jmp    802d6e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802d53:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d56:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802d5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d5d:	48 89 ce             	mov    %rcx,%rsi
  802d60:	89 c7                	mov    %eax,%edi
  802d62:	48 b8 79 30 80 00 00 	movabs $0x803079,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
}
  802d6e:	c9                   	leaveq 
  802d6f:	c3                   	retq   

0000000000802d70 <listen>:

int
listen(int s, int backlog)
{
  802d70:	55                   	push   %rbp
  802d71:	48 89 e5             	mov    %rsp,%rbp
  802d74:	48 83 ec 20          	sub    $0x20,%rsp
  802d78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d7b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d81:	89 c7                	mov    %eax,%edi
  802d83:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  802d8a:	00 00 00 
  802d8d:	ff d0                	callq  *%rax
  802d8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d96:	79 05                	jns    802d9d <listen+0x2d>
		return r;
  802d98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d9b:	eb 16                	jmp    802db3 <listen+0x43>
	return nsipc_listen(r, backlog);
  802d9d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da3:	89 d6                	mov    %edx,%esi
  802da5:	89 c7                	mov    %eax,%edi
  802da7:	48 b8 dd 30 80 00 00 	movabs $0x8030dd,%rax
  802dae:	00 00 00 
  802db1:	ff d0                	callq  *%rax
}
  802db3:	c9                   	leaveq 
  802db4:	c3                   	retq   

0000000000802db5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802db5:	55                   	push   %rbp
  802db6:	48 89 e5             	mov    %rsp,%rbp
  802db9:	48 83 ec 20          	sub    $0x20,%rsp
  802dbd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dc5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802dc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dcd:	89 c2                	mov    %eax,%edx
  802dcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd3:	8b 40 0c             	mov    0xc(%rax),%eax
  802dd6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802dda:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 1d 31 80 00 00 	movabs $0x80311d,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
}
  802ded:	c9                   	leaveq 
  802dee:	c3                   	retq   

0000000000802def <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802def:	55                   	push   %rbp
  802df0:	48 89 e5             	mov    %rsp,%rbp
  802df3:	48 83 ec 20          	sub    $0x20,%rsp
  802df7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802dff:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802e03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e07:	89 c2                	mov    %eax,%edx
  802e09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0d:	8b 40 0c             	mov    0xc(%rax),%eax
  802e10:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e19:	89 c7                	mov    %eax,%edi
  802e1b:	48 b8 e9 31 80 00 00 	movabs $0x8031e9,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
}
  802e27:	c9                   	leaveq 
  802e28:	c3                   	retq   

0000000000802e29 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802e29:	55                   	push   %rbp
  802e2a:	48 89 e5             	mov    %rsp,%rbp
  802e2d:	48 83 ec 10          	sub    $0x10,%rsp
  802e31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3d:	48 be 7b 44 80 00 00 	movabs $0x80447b,%rsi
  802e44:	00 00 00 
  802e47:	48 89 c7             	mov    %rax,%rdi
  802e4a:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
	return 0;
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5b:	c9                   	leaveq 
  802e5c:	c3                   	retq   

0000000000802e5d <socket>:

int
socket(int domain, int type, int protocol)
{
  802e5d:	55                   	push   %rbp
  802e5e:	48 89 e5             	mov    %rsp,%rbp
  802e61:	48 83 ec 20          	sub    $0x20,%rsp
  802e65:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e68:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802e6b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802e6e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e71:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e74:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e77:	89 ce                	mov    %ecx,%esi
  802e79:	89 c7                	mov    %eax,%edi
  802e7b:	48 b8 a1 32 80 00 00 	movabs $0x8032a1,%rax
  802e82:	00 00 00 
  802e85:	ff d0                	callq  *%rax
  802e87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e8e:	79 05                	jns    802e95 <socket+0x38>
		return r;
  802e90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e93:	eb 11                	jmp    802ea6 <socket+0x49>
	return alloc_sockfd(r);
  802e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e98:	89 c7                	mov    %eax,%edi
  802e9a:	48 b8 3f 2b 80 00 00 	movabs $0x802b3f,%rax
  802ea1:	00 00 00 
  802ea4:	ff d0                	callq  *%rax
}
  802ea6:	c9                   	leaveq 
  802ea7:	c3                   	retq   

0000000000802ea8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802ea8:	55                   	push   %rbp
  802ea9:	48 89 e5             	mov    %rsp,%rbp
  802eac:	48 83 ec 10          	sub    $0x10,%rsp
  802eb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802eb3:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  802eba:	00 00 00 
  802ebd:	8b 00                	mov    (%rax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	75 1d                	jne    802ee0 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802ec3:	bf 02 00 00 00       	mov    $0x2,%edi
  802ec8:	48 b8 f3 3c 80 00 00 	movabs $0x803cf3,%rax
  802ecf:	00 00 00 
  802ed2:	ff d0                	callq  *%rax
  802ed4:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  802edb:	00 00 00 
  802ede:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802ee0:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  802ee7:	00 00 00 
  802eea:	8b 00                	mov    (%rax),%eax
  802eec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eef:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ef4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  802efb:	00 00 00 
  802efe:	89 c7                	mov    %eax,%edi
  802f00:	48 b8 30 3c 80 00 00 	movabs $0x803c30,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  802f0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f11:	be 00 00 00 00       	mov    $0x0,%esi
  802f16:	bf 00 00 00 00       	mov    $0x0,%edi
  802f1b:	48 b8 70 3b 80 00 00 	movabs $0x803b70,%rax
  802f22:	00 00 00 
  802f25:	ff d0                	callq  *%rax
}
  802f27:	c9                   	leaveq 
  802f28:	c3                   	retq   

0000000000802f29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802f29:	55                   	push   %rbp
  802f2a:	48 89 e5             	mov    %rsp,%rbp
  802f2d:	48 83 ec 30          	sub    $0x30,%rsp
  802f31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f38:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  802f3c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f43:	00 00 00 
  802f46:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802f49:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802f4b:	bf 01 00 00 00       	mov    $0x1,%edi
  802f50:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  802f57:	00 00 00 
  802f5a:	ff d0                	callq  *%rax
  802f5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f63:	78 3e                	js     802fa3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802f65:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802f6c:	00 00 00 
  802f6f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	8b 40 10             	mov    0x10(%rax),%eax
  802f7a:	89 c2                	mov    %eax,%edx
  802f7c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f84:	48 89 ce             	mov    %rcx,%rsi
  802f87:	48 89 c7             	mov    %rax,%rdi
  802f8a:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f9a:	8b 50 10             	mov    0x10(%rax),%edx
  802f9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fa6:	c9                   	leaveq 
  802fa7:	c3                   	retq   

0000000000802fa8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802fa8:	55                   	push   %rbp
  802fa9:	48 89 e5             	mov    %rsp,%rbp
  802fac:	48 83 ec 10          	sub    $0x10,%rsp
  802fb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802fb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802fb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  802fba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802fc1:	00 00 00 
  802fc4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802fc7:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802fc9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd0:	48 89 c6             	mov    %rax,%rsi
  802fd3:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  802fda:	00 00 00 
  802fdd:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  802fe9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802ff0:	00 00 00 
  802ff3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802ff6:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  802ff9:	bf 02 00 00 00       	mov    $0x2,%edi
  802ffe:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803005:	00 00 00 
  803008:	ff d0                	callq  *%rax
}
  80300a:	c9                   	leaveq 
  80300b:	c3                   	retq   

000000000080300c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80300c:	55                   	push   %rbp
  80300d:	48 89 e5             	mov    %rsp,%rbp
  803010:	48 83 ec 10          	sub    $0x10,%rsp
  803014:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803017:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80301a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803021:	00 00 00 
  803024:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803027:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803029:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803030:	00 00 00 
  803033:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803036:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803039:	bf 03 00 00 00       	mov    $0x3,%edi
  80303e:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
}
  80304a:	c9                   	leaveq 
  80304b:	c3                   	retq   

000000000080304c <nsipc_close>:

int
nsipc_close(int s)
{
  80304c:	55                   	push   %rbp
  80304d:	48 89 e5             	mov    %rsp,%rbp
  803050:	48 83 ec 10          	sub    $0x10,%rsp
  803054:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803057:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80305e:	00 00 00 
  803061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803064:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803066:	bf 04 00 00 00       	mov    $0x4,%edi
  80306b:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
}
  803077:	c9                   	leaveq 
  803078:	c3                   	retq   

0000000000803079 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803079:	55                   	push   %rbp
  80307a:	48 89 e5             	mov    %rsp,%rbp
  80307d:	48 83 ec 10          	sub    $0x10,%rsp
  803081:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803084:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803088:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80308b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803092:	00 00 00 
  803095:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803098:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80309a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80309d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a1:	48 89 c6             	mov    %rax,%rsi
  8030a4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8030ab:	00 00 00 
  8030ae:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8030ba:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030c1:	00 00 00 
  8030c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8030c7:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8030ca:	bf 05 00 00 00       	mov    $0x5,%edi
  8030cf:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  8030d6:	00 00 00 
  8030d9:	ff d0                	callq  *%rax
}
  8030db:	c9                   	leaveq 
  8030dc:	c3                   	retq   

00000000008030dd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8030dd:	55                   	push   %rbp
  8030de:	48 89 e5             	mov    %rsp,%rbp
  8030e1:	48 83 ec 10          	sub    $0x10,%rsp
  8030e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8030eb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8030f2:	00 00 00 
  8030f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8030f8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8030fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803101:	00 00 00 
  803104:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80310a:	bf 06 00 00 00       	mov    $0x6,%edi
  80310f:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
}
  80311b:	c9                   	leaveq 
  80311c:	c3                   	retq   

000000000080311d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80311d:	55                   	push   %rbp
  80311e:	48 89 e5             	mov    %rsp,%rbp
  803121:	48 83 ec 30          	sub    $0x30,%rsp
  803125:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803128:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80312c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80312f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803132:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803139:	00 00 00 
  80313c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80313f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803141:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803148:	00 00 00 
  80314b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803151:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803158:	00 00 00 
  80315b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80315e:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803161:	bf 07 00 00 00       	mov    $0x7,%edi
  803166:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  80316d:	00 00 00 
  803170:	ff d0                	callq  *%rax
  803172:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803175:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803179:	78 69                	js     8031e4 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80317b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803182:	7f 08                	jg     80318c <nsipc_recv+0x6f>
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803187:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80318a:	7e 35                	jle    8031c1 <nsipc_recv+0xa4>
  80318c:	48 b9 82 44 80 00 00 	movabs $0x804482,%rcx
  803193:	00 00 00 
  803196:	48 ba 97 44 80 00 00 	movabs $0x804497,%rdx
  80319d:	00 00 00 
  8031a0:	be 61 00 00 00       	mov    $0x61,%esi
  8031a5:	48 bf ac 44 80 00 00 	movabs $0x8044ac,%rdi
  8031ac:	00 00 00 
  8031af:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b4:	49 b8 20 02 80 00 00 	movabs $0x800220,%r8
  8031bb:	00 00 00 
  8031be:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8031c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031c4:	48 63 d0             	movslq %eax,%rdx
  8031c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cb:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8031d2:	00 00 00 
  8031d5:	48 89 c7             	mov    %rax,%rdi
  8031d8:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  8031df:	00 00 00 
  8031e2:	ff d0                	callq  *%rax
	}

	return r;
  8031e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031e7:	c9                   	leaveq 
  8031e8:	c3                   	retq   

00000000008031e9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8031e9:	55                   	push   %rbp
  8031ea:	48 89 e5             	mov    %rsp,%rbp
  8031ed:	48 83 ec 20          	sub    $0x20,%rsp
  8031f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8031f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8031f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8031fb:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8031fe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803205:	00 00 00 
  803208:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80320b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80320d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803214:	7e 35                	jle    80324b <nsipc_send+0x62>
  803216:	48 b9 b8 44 80 00 00 	movabs $0x8044b8,%rcx
  80321d:	00 00 00 
  803220:	48 ba 97 44 80 00 00 	movabs $0x804497,%rdx
  803227:	00 00 00 
  80322a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80322f:	48 bf ac 44 80 00 00 	movabs $0x8044ac,%rdi
  803236:	00 00 00 
  803239:	b8 00 00 00 00       	mov    $0x0,%eax
  80323e:	49 b8 20 02 80 00 00 	movabs $0x800220,%r8
  803245:	00 00 00 
  803248:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80324b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324e:	48 63 d0             	movslq %eax,%rdx
  803251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803255:	48 89 c6             	mov    %rax,%rsi
  803258:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80325f:	00 00 00 
  803262:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80326e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803275:	00 00 00 
  803278:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80327b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80327e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803285:	00 00 00 
  803288:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80328b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80328e:	bf 08 00 00 00       	mov    $0x8,%edi
  803293:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
}
  80329f:	c9                   	leaveq 
  8032a0:	c3                   	retq   

00000000008032a1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8032a1:	55                   	push   %rbp
  8032a2:	48 89 e5             	mov    %rsp,%rbp
  8032a5:	48 83 ec 10          	sub    $0x10,%rsp
  8032a9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032ac:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8032af:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8032b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032b9:	00 00 00 
  8032bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032bf:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8032c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032c8:	00 00 00 
  8032cb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8032d1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d8:	00 00 00 
  8032db:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8032de:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8032e1:	bf 09 00 00 00       	mov    $0x9,%edi
  8032e6:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
}
  8032f2:	c9                   	leaveq 
  8032f3:	c3                   	retq   

00000000008032f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8032f4:	55                   	push   %rbp
  8032f5:	48 89 e5             	mov    %rsp,%rbp
  8032f8:	53                   	push   %rbx
  8032f9:	48 83 ec 38          	sub    $0x38,%rsp
  8032fd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803301:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803305:	48 89 c7             	mov    %rax,%rdi
  803308:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  80330f:	00 00 00 
  803312:	ff d0                	callq  *%rax
  803314:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803317:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80331b:	0f 88 bf 01 00 00    	js     8034e0 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803325:	ba 07 04 00 00       	mov    $0x407,%edx
  80332a:	48 89 c6             	mov    %rax,%rsi
  80332d:	bf 00 00 00 00       	mov    $0x0,%edi
  803332:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
  80333e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803341:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803345:	0f 88 95 01 00 00    	js     8034e0 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80334b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80334f:	48 89 c7             	mov    %rax,%rdi
  803352:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  803359:	00 00 00 
  80335c:	ff d0                	callq  *%rax
  80335e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803361:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803365:	0f 88 5d 01 00 00    	js     8034c8 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80336b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336f:	ba 07 04 00 00       	mov    $0x407,%edx
  803374:	48 89 c6             	mov    %rax,%rsi
  803377:	bf 00 00 00 00       	mov    $0x0,%edi
  80337c:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  803383:	00 00 00 
  803386:	ff d0                	callq  *%rax
  803388:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80338b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80338f:	0f 88 33 01 00 00    	js     8034c8 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803399:	48 89 c7             	mov    %rax,%rdi
  80339c:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8033a3:	00 00 00 
  8033a6:	ff d0                	callq  *%rax
  8033a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033b0:	ba 07 04 00 00       	mov    $0x407,%edx
  8033b5:	48 89 c6             	mov    %rax,%rsi
  8033b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8033bd:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  8033c4:	00 00 00 
  8033c7:	ff d0                	callq  *%rax
  8033c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033d0:	0f 88 d9 00 00 00    	js     8034af <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033da:	48 89 c7             	mov    %rax,%rdi
  8033dd:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
  8033e9:	48 89 c2             	mov    %rax,%rdx
  8033ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f0:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8033f6:	48 89 d1             	mov    %rdx,%rcx
  8033f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8033fe:	48 89 c6             	mov    %rax,%rsi
  803401:	bf 00 00 00 00       	mov    $0x0,%edi
  803406:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
  803412:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803415:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803419:	78 79                	js     803494 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80341b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80341f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803426:	00 00 00 
  803429:	8b 12                	mov    (%rdx),%edx
  80342b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80342d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803431:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803438:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80343c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803443:	00 00 00 
  803446:	8b 12                	mov    (%rdx),%edx
  803448:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80344a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803459:	48 89 c7             	mov    %rax,%rdi
  80345c:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803463:	00 00 00 
  803466:	ff d0                	callq  *%rax
  803468:	89 c2                	mov    %eax,%edx
  80346a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80346e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803470:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803474:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803478:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80347c:	48 89 c7             	mov    %rax,%rdi
  80347f:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80348d:	b8 00 00 00 00       	mov    $0x0,%eax
  803492:	eb 4f                	jmp    8034e3 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803494:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803495:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803499:	48 89 c6             	mov    %rax,%rsi
  80349c:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a1:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8034a8:	00 00 00 
  8034ab:	ff d0                	callq  *%rax
  8034ad:	eb 01                	jmp    8034b0 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8034af:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  8034b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b4:	48 89 c6             	mov    %rax,%rsi
  8034b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8034bc:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  8034c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034cc:	48 89 c6             	mov    %rax,%rsi
  8034cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d4:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
    err:
	return r;
  8034e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8034e3:	48 83 c4 38          	add    $0x38,%rsp
  8034e7:	5b                   	pop    %rbx
  8034e8:	5d                   	pop    %rbp
  8034e9:	c3                   	retq   

00000000008034ea <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8034ea:	55                   	push   %rbp
  8034eb:	48 89 e5             	mov    %rsp,%rbp
  8034ee:	53                   	push   %rbx
  8034ef:	48 83 ec 28          	sub    $0x28,%rsp
  8034f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034fb:	eb 01                	jmp    8034fe <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8034fd:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8034fe:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803505:	00 00 00 
  803508:	48 8b 00             	mov    (%rax),%rax
  80350b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803511:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803518:	48 89 c7             	mov    %rax,%rdi
  80351b:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  803522:	00 00 00 
  803525:	ff d0                	callq  *%rax
  803527:	89 c3                	mov    %eax,%ebx
  803529:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80352d:	48 89 c7             	mov    %rax,%rdi
  803530:	48 b8 78 3d 80 00 00 	movabs $0x803d78,%rax
  803537:	00 00 00 
  80353a:	ff d0                	callq  *%rax
  80353c:	39 c3                	cmp    %eax,%ebx
  80353e:	0f 94 c0             	sete   %al
  803541:	0f b6 c0             	movzbl %al,%eax
  803544:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803547:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80354e:	00 00 00 
  803551:	48 8b 00             	mov    (%rax),%rax
  803554:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80355a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80355d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803560:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803563:	75 0a                	jne    80356f <_pipeisclosed+0x85>
			return ret;
  803565:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803568:	48 83 c4 28          	add    $0x28,%rsp
  80356c:	5b                   	pop    %rbx
  80356d:	5d                   	pop    %rbp
  80356e:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80356f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803572:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803575:	74 86                	je     8034fd <_pipeisclosed+0x13>
  803577:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80357b:	75 80                	jne    8034fd <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80357d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803584:	00 00 00 
  803587:	48 8b 00             	mov    (%rax),%rax
  80358a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803590:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803593:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803596:	89 c6                	mov    %eax,%esi
  803598:	48 bf c9 44 80 00 00 	movabs $0x8044c9,%rdi
  80359f:	00 00 00 
  8035a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a7:	49 b8 5b 04 80 00 00 	movabs $0x80045b,%r8
  8035ae:	00 00 00 
  8035b1:	41 ff d0             	callq  *%r8
	}
  8035b4:	e9 44 ff ff ff       	jmpq   8034fd <_pipeisclosed+0x13>

00000000008035b9 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 30          	sub    $0x30,%rsp
  8035c1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8035c4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035c8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035cb:	48 89 d6             	mov    %rdx,%rsi
  8035ce:	89 c7                	mov    %eax,%edi
  8035d0:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  8035d7:	00 00 00 
  8035da:	ff d0                	callq  *%rax
  8035dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e3:	79 05                	jns    8035ea <pipeisclosed+0x31>
		return r;
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	eb 31                	jmp    80361b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8035ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ee:	48 89 c7             	mov    %rax,%rdi
  8035f1:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8035f8:	00 00 00 
  8035fb:	ff d0                	callq  *%rax
  8035fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803605:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803609:	48 89 d6             	mov    %rdx,%rsi
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 ea 34 80 00 00 	movabs $0x8034ea,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
}
  80361b:	c9                   	leaveq 
  80361c:	c3                   	retq   

000000000080361d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80361d:	55                   	push   %rbp
  80361e:	48 89 e5             	mov    %rsp,%rbp
  803621:	48 83 ec 40          	sub    $0x40,%rsp
  803625:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803629:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80362d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803635:	48 89 c7             	mov    %rax,%rdi
  803638:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  80363f:	00 00 00 
  803642:	ff d0                	callq  *%rax
  803644:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803648:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80364c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803650:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803657:	00 
  803658:	e9 97 00 00 00       	jmpq   8036f4 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80365d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803662:	74 09                	je     80366d <devpipe_read+0x50>
				return i;
  803664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803668:	e9 95 00 00 00       	jmpq   803702 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80366d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803675:	48 89 d6             	mov    %rdx,%rsi
  803678:	48 89 c7             	mov    %rax,%rdi
  80367b:	48 b8 ea 34 80 00 00 	movabs $0x8034ea,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	85 c0                	test   %eax,%eax
  803689:	74 07                	je     803692 <devpipe_read+0x75>
				return 0;
  80368b:	b8 00 00 00 00       	mov    $0x0,%eax
  803690:	eb 70                	jmp    803702 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803692:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  803699:	00 00 00 
  80369c:	ff d0                	callq  *%rax
  80369e:	eb 01                	jmp    8036a1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036a0:	90                   	nop
  8036a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a5:	8b 10                	mov    (%rax),%edx
  8036a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ab:	8b 40 04             	mov    0x4(%rax),%eax
  8036ae:	39 c2                	cmp    %eax,%edx
  8036b0:	74 ab                	je     80365d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036ba:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8036be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c2:	8b 00                	mov    (%rax),%eax
  8036c4:	89 c2                	mov    %eax,%edx
  8036c6:	c1 fa 1f             	sar    $0x1f,%edx
  8036c9:	c1 ea 1b             	shr    $0x1b,%edx
  8036cc:	01 d0                	add    %edx,%eax
  8036ce:	83 e0 1f             	and    $0x1f,%eax
  8036d1:	29 d0                	sub    %edx,%eax
  8036d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036d7:	48 98                	cltq   
  8036d9:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8036de:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8036e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e4:	8b 00                	mov    (%rax),%eax
  8036e6:	8d 50 01             	lea    0x1(%rax),%edx
  8036e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ed:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8036f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036fc:	72 a2                	jb     8036a0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8036fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803702:	c9                   	leaveq 
  803703:	c3                   	retq   

0000000000803704 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803704:	55                   	push   %rbp
  803705:	48 89 e5             	mov    %rsp,%rbp
  803708:	48 83 ec 40          	sub    $0x40,%rsp
  80370c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803710:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803714:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803718:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80371c:	48 89 c7             	mov    %rax,%rdi
  80371f:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  803726:	00 00 00 
  803729:	ff d0                	callq  *%rax
  80372b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80372f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803733:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803737:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80373e:	00 
  80373f:	e9 93 00 00 00       	jmpq   8037d7 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803744:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803748:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374c:	48 89 d6             	mov    %rdx,%rsi
  80374f:	48 89 c7             	mov    %rax,%rdi
  803752:	48 b8 ea 34 80 00 00 	movabs $0x8034ea,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	85 c0                	test   %eax,%eax
  803760:	74 07                	je     803769 <devpipe_write+0x65>
				return 0;
  803762:	b8 00 00 00 00       	mov    $0x0,%eax
  803767:	eb 7c                	jmp    8037e5 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803769:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
  803775:	eb 01                	jmp    803778 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803777:	90                   	nop
  803778:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80377c:	8b 40 04             	mov    0x4(%rax),%eax
  80377f:	48 63 d0             	movslq %eax,%rdx
  803782:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803786:	8b 00                	mov    (%rax),%eax
  803788:	48 98                	cltq   
  80378a:	48 83 c0 20          	add    $0x20,%rax
  80378e:	48 39 c2             	cmp    %rax,%rdx
  803791:	73 b1                	jae    803744 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803793:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803797:	8b 40 04             	mov    0x4(%rax),%eax
  80379a:	89 c2                	mov    %eax,%edx
  80379c:	c1 fa 1f             	sar    $0x1f,%edx
  80379f:	c1 ea 1b             	shr    $0x1b,%edx
  8037a2:	01 d0                	add    %edx,%eax
  8037a4:	83 e0 1f             	and    $0x1f,%eax
  8037a7:	29 d0                	sub    %edx,%eax
  8037a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8037ad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8037b1:	48 01 ca             	add    %rcx,%rdx
  8037b4:	0f b6 0a             	movzbl (%rdx),%ecx
  8037b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037bb:	48 98                	cltq   
  8037bd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8037c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c5:	8b 40 04             	mov    0x4(%rax),%eax
  8037c8:	8d 50 01             	lea    0x1(%rax),%edx
  8037cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cf:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037db:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037df:	72 96                	jb     803777 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8037e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037e5:	c9                   	leaveq 
  8037e6:	c3                   	retq   

00000000008037e7 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8037e7:	55                   	push   %rbp
  8037e8:	48 89 e5             	mov    %rsp,%rbp
  8037eb:	48 83 ec 20          	sub    $0x20,%rsp
  8037ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8037f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037fb:	48 89 c7             	mov    %rax,%rdi
  8037fe:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
  80380a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80380e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803812:	48 be dc 44 80 00 00 	movabs $0x8044dc,%rsi
  803819:	00 00 00 
  80381c:	48 89 c7             	mov    %rax,%rdi
  80381f:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80382b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80382f:	8b 50 04             	mov    0x4(%rax),%edx
  803832:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803836:	8b 00                	mov    (%rax),%eax
  803838:	29 c2                	sub    %eax,%edx
  80383a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80383e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803844:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803848:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80384f:	00 00 00 
	stat->st_dev = &devpipe;
  803852:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803856:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80385d:	00 00 00 
  803860:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803867:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80386c:	c9                   	leaveq 
  80386d:	c3                   	retq   

000000000080386e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80386e:	55                   	push   %rbp
  80386f:	48 89 e5             	mov    %rsp,%rbp
  803872:	48 83 ec 10          	sub    $0x10,%rsp
  803876:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80387a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387e:	48 89 c6             	mov    %rax,%rsi
  803881:	bf 00 00 00 00       	mov    $0x0,%edi
  803886:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  80388d:	00 00 00 
  803890:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803892:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803896:	48 89 c7             	mov    %rax,%rdi
  803899:	48 b8 03 1e 80 00 00 	movabs $0x801e03,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
  8038a5:	48 89 c6             	mov    %rax,%rsi
  8038a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ad:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
}
  8038b9:	c9                   	leaveq 
  8038ba:	c3                   	retq   
	...

00000000008038bc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8038bc:	55                   	push   %rbp
  8038bd:	48 89 e5             	mov    %rsp,%rbp
  8038c0:	48 83 ec 20          	sub    $0x20,%rsp
  8038c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8038c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038ca:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8038cd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8038d1:	be 01 00 00 00       	mov    $0x1,%esi
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
}
  8038e5:	c9                   	leaveq 
  8038e6:	c3                   	retq   

00000000008038e7 <getchar>:

int
getchar(void)
{
  8038e7:	55                   	push   %rbp
  8038e8:	48 89 e5             	mov    %rsp,%rbp
  8038eb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8038ef:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8038f3:	ba 01 00 00 00       	mov    $0x1,%edx
  8038f8:	48 89 c6             	mov    %rax,%rsi
  8038fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803900:	48 b8 f8 22 80 00 00 	movabs $0x8022f8,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
  80390c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80390f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803913:	79 05                	jns    80391a <getchar+0x33>
		return r;
  803915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803918:	eb 14                	jmp    80392e <getchar+0x47>
	if (r < 1)
  80391a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391e:	7f 07                	jg     803927 <getchar+0x40>
		return -E_EOF;
  803920:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803925:	eb 07                	jmp    80392e <getchar+0x47>
	return c;
  803927:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80392b:	0f b6 c0             	movzbl %al,%eax
}
  80392e:	c9                   	leaveq 
  80392f:	c3                   	retq   

0000000000803930 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 83 ec 20          	sub    $0x20,%rsp
  803938:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80393b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80393f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803942:	48 89 d6             	mov    %rdx,%rsi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 c6 1e 80 00 00 	movabs $0x801ec6,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395a:	79 05                	jns    803961 <iscons+0x31>
		return r;
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	eb 1a                	jmp    80397b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803961:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803965:	8b 10                	mov    (%rax),%edx
  803967:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80396e:	00 00 00 
  803971:	8b 00                	mov    (%rax),%eax
  803973:	39 c2                	cmp    %eax,%edx
  803975:	0f 94 c0             	sete   %al
  803978:	0f b6 c0             	movzbl %al,%eax
}
  80397b:	c9                   	leaveq 
  80397c:	c3                   	retq   

000000000080397d <opencons>:

int
opencons(void)
{
  80397d:	55                   	push   %rbp
  80397e:	48 89 e5             	mov    %rsp,%rbp
  803981:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803985:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803989:	48 89 c7             	mov    %rax,%rdi
  80398c:	48 b8 2e 1e 80 00 00 	movabs $0x801e2e,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
  803998:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80399f:	79 05                	jns    8039a6 <opencons+0x29>
		return r;
  8039a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a4:	eb 5b                	jmp    803a01 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8039a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039aa:	ba 07 04 00 00       	mov    $0x407,%edx
  8039af:	48 89 c6             	mov    %rax,%rsi
  8039b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b7:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  8039be:	00 00 00 
  8039c1:	ff d0                	callq  *%rax
  8039c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ca:	79 05                	jns    8039d1 <opencons+0x54>
		return r;
  8039cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cf:	eb 30                	jmp    803a01 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8039d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d5:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8039dc:	00 00 00 
  8039df:	8b 12                	mov    (%rdx),%edx
  8039e1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8039e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8039ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f2:	48 89 c7             	mov    %rax,%rdi
  8039f5:	48 b8 e0 1d 80 00 00 	movabs $0x801de0,%rax
  8039fc:	00 00 00 
  8039ff:	ff d0                	callq  *%rax
}
  803a01:	c9                   	leaveq 
  803a02:	c3                   	retq   

0000000000803a03 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803a03:	55                   	push   %rbp
  803a04:	48 89 e5             	mov    %rsp,%rbp
  803a07:	48 83 ec 30          	sub    $0x30,%rsp
  803a0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a13:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803a17:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a1c:	75 13                	jne    803a31 <devcons_read+0x2e>
		return 0;
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a23:	eb 49                	jmp    803a6e <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803a25:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803a31:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  803a38:	00 00 00 
  803a3b:	ff d0                	callq  *%rax
  803a3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a44:	74 df                	je     803a25 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803a46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a4a:	79 05                	jns    803a51 <devcons_read+0x4e>
		return c;
  803a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4f:	eb 1d                	jmp    803a6e <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803a51:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803a55:	75 07                	jne    803a5e <devcons_read+0x5b>
		return 0;
  803a57:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5c:	eb 10                	jmp    803a6e <devcons_read+0x6b>
	*(char*)vbuf = c;
  803a5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a61:	89 c2                	mov    %eax,%edx
  803a63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a67:	88 10                	mov    %dl,(%rax)
	return 1;
  803a69:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a6e:	c9                   	leaveq 
  803a6f:	c3                   	retq   

0000000000803a70 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a70:	55                   	push   %rbp
  803a71:	48 89 e5             	mov    %rsp,%rbp
  803a74:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803a7b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803a82:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803a89:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a97:	eb 77                	jmp    803b10 <devcons_write+0xa0>
		m = n - tot;
  803a99:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803aa0:	89 c2                	mov    %eax,%edx
  803aa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa5:	89 d1                	mov    %edx,%ecx
  803aa7:	29 c1                	sub    %eax,%ecx
  803aa9:	89 c8                	mov    %ecx,%eax
  803aab:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803aae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab1:	83 f8 7f             	cmp    $0x7f,%eax
  803ab4:	76 07                	jbe    803abd <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  803ab6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803abd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ac0:	48 63 d0             	movslq %eax,%rdx
  803ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac6:	48 98                	cltq   
  803ac8:	48 89 c1             	mov    %rax,%rcx
  803acb:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  803ad2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ad9:	48 89 ce             	mov    %rcx,%rsi
  803adc:	48 89 c7             	mov    %rax,%rdi
  803adf:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803aeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803aee:	48 63 d0             	movslq %eax,%rdx
  803af1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803af8:	48 89 d6             	mov    %rdx,%rsi
  803afb:	48 89 c7             	mov    %rax,%rdi
  803afe:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803b0a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b0d:	01 45 fc             	add    %eax,-0x4(%rbp)
  803b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b13:	48 98                	cltq   
  803b15:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803b1c:	0f 82 77 ff ff ff    	jb     803a99 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b25:	c9                   	leaveq 
  803b26:	c3                   	retq   

0000000000803b27 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803b27:	55                   	push   %rbp
  803b28:	48 89 e5             	mov    %rsp,%rbp
  803b2b:	48 83 ec 08          	sub    $0x8,%rsp
  803b2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b38:	c9                   	leaveq 
  803b39:	c3                   	retq   

0000000000803b3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803b3a:	55                   	push   %rbp
  803b3b:	48 89 e5             	mov    %rsp,%rbp
  803b3e:	48 83 ec 10          	sub    $0x10,%rsp
  803b42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803b4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4e:	48 be e8 44 80 00 00 	movabs $0x8044e8,%rsi
  803b55:	00 00 00 
  803b58:	48 89 c7             	mov    %rax,%rdi
  803b5b:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  803b62:	00 00 00 
  803b65:	ff d0                	callq  *%rax
	return 0;
  803b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b6c:	c9                   	leaveq 
  803b6d:	c3                   	retq   
	...

0000000000803b70 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803b70:	55                   	push   %rbp
  803b71:	48 89 e5             	mov    %rsp,%rbp
  803b74:	48 83 ec 30          	sub    $0x30,%rsp
  803b78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b80:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  803b84:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b89:	74 18                	je     803ba3 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  803b8b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b8f:	48 89 c7             	mov    %rax,%rdi
  803b92:	48 b8 79 1b 80 00 00 	movabs $0x801b79,%rax
  803b99:	00 00 00 
  803b9c:	ff d0                	callq  *%rax
  803b9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ba1:	eb 19                	jmp    803bbc <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  803ba3:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803baa:	00 00 00 
  803bad:	48 b8 79 1b 80 00 00 	movabs $0x801b79,%rax
  803bb4:	00 00 00 
  803bb7:	ff d0                	callq  *%rax
  803bb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  803bbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc0:	79 19                	jns    803bdb <ipc_recv+0x6b>
	{
		*from_env_store=0;
  803bc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bc6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  803bcc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  803bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bd9:	eb 53                	jmp    803c2e <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  803bdb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803be0:	74 19                	je     803bfb <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  803be2:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803be9:	00 00 00 
  803bec:	48 8b 00             	mov    (%rax),%rax
  803bef:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf9:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  803bfb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803c00:	74 19                	je     803c1b <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  803c02:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c09:	00 00 00 
  803c0c:	48 8b 00             	mov    (%rax),%rax
  803c0f:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803c15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c19:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803c1b:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c22:	00 00 00 
  803c25:	48 8b 00             	mov    (%rax),%rax
  803c28:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  803c2e:	c9                   	leaveq 
  803c2f:	c3                   	retq   

0000000000803c30 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803c30:	55                   	push   %rbp
  803c31:	48 89 e5             	mov    %rsp,%rbp
  803c34:	48 83 ec 30          	sub    $0x30,%rsp
  803c38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c3b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803c3e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803c42:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  803c45:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  803c4c:	e9 96 00 00 00       	jmpq   803ce7 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  803c51:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c56:	74 20                	je     803c78 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  803c58:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c5b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803c5e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803c62:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c65:	89 c7                	mov    %eax,%edi
  803c67:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  803c6e:	00 00 00 
  803c71:	ff d0                	callq  *%rax
  803c73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c76:	eb 2d                	jmp    803ca5 <ipc_send+0x75>
		else if(pg==NULL)
  803c78:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803c7d:	75 26                	jne    803ca5 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  803c7f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803c82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c85:	b9 00 00 00 00       	mov    $0x0,%ecx
  803c8a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803c91:	00 00 00 
  803c94:	89 c7                	mov    %eax,%edi
  803c96:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  803c9d:	00 00 00 
  803ca0:	ff d0                	callq  *%rax
  803ca2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  803ca5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca9:	79 30                	jns    803cdb <ipc_send+0xab>
  803cab:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803caf:	74 2a                	je     803cdb <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  803cb1:	48 ba ef 44 80 00 00 	movabs $0x8044ef,%rdx
  803cb8:	00 00 00 
  803cbb:	be 40 00 00 00       	mov    $0x40,%esi
  803cc0:	48 bf 07 45 80 00 00 	movabs $0x804507,%rdi
  803cc7:	00 00 00 
  803cca:	b8 00 00 00 00       	mov    $0x0,%eax
  803ccf:	48 b9 20 02 80 00 00 	movabs $0x800220,%rcx
  803cd6:	00 00 00 
  803cd9:	ff d1                	callq  *%rcx
		}
		sys_yield();
  803cdb:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  803ce7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ceb:	0f 85 60 ff ff ff    	jne    803c51 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  803cf1:	c9                   	leaveq 
  803cf2:	c3                   	retq   

0000000000803cf3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803cf3:	55                   	push   %rbp
  803cf4:	48 89 e5             	mov    %rsp,%rbp
  803cf7:	48 83 ec 18          	sub    $0x18,%rsp
  803cfb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  803cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803d05:	eb 5e                	jmp    803d65 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803d07:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d0e:	00 00 00 
  803d11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d14:	48 63 d0             	movslq %eax,%rdx
  803d17:	48 89 d0             	mov    %rdx,%rax
  803d1a:	48 c1 e0 03          	shl    $0x3,%rax
  803d1e:	48 01 d0             	add    %rdx,%rax
  803d21:	48 c1 e0 05          	shl    $0x5,%rax
  803d25:	48 01 c8             	add    %rcx,%rax
  803d28:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803d2e:	8b 00                	mov    (%rax),%eax
  803d30:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803d33:	75 2c                	jne    803d61 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803d35:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803d3c:	00 00 00 
  803d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d42:	48 63 d0             	movslq %eax,%rdx
  803d45:	48 89 d0             	mov    %rdx,%rax
  803d48:	48 c1 e0 03          	shl    $0x3,%rax
  803d4c:	48 01 d0             	add    %rdx,%rax
  803d4f:	48 c1 e0 05          	shl    $0x5,%rax
  803d53:	48 01 c8             	add    %rcx,%rax
  803d56:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803d5c:	8b 40 08             	mov    0x8(%rax),%eax
  803d5f:	eb 12                	jmp    803d73 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803d61:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803d65:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803d6c:	7e 99                	jle    803d07 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d73:	c9                   	leaveq 
  803d74:	c3                   	retq   
  803d75:	00 00                	add    %al,(%rax)
	...

0000000000803d78 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803d78:	55                   	push   %rbp
  803d79:	48 89 e5             	mov    %rsp,%rbp
  803d7c:	48 83 ec 18          	sub    $0x18,%rsp
  803d80:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803d84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d88:	48 89 c2             	mov    %rax,%rdx
  803d8b:	48 c1 ea 15          	shr    $0x15,%rdx
  803d8f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803d96:	01 00 00 
  803d99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d9d:	83 e0 01             	and    $0x1,%eax
  803da0:	48 85 c0             	test   %rax,%rax
  803da3:	75 07                	jne    803dac <pageref+0x34>
		return 0;
  803da5:	b8 00 00 00 00       	mov    $0x0,%eax
  803daa:	eb 53                	jmp    803dff <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803dac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db0:	48 89 c2             	mov    %rax,%rdx
  803db3:	48 c1 ea 0c          	shr    $0xc,%rdx
  803db7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dbe:	01 00 00 
  803dc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dc5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dcd:	83 e0 01             	and    $0x1,%eax
  803dd0:	48 85 c0             	test   %rax,%rax
  803dd3:	75 07                	jne    803ddc <pageref+0x64>
		return 0;
  803dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dda:	eb 23                	jmp    803dff <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803ddc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803de0:	48 89 c2             	mov    %rax,%rdx
  803de3:	48 c1 ea 0c          	shr    $0xc,%rdx
  803de7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803dee:	00 00 00 
  803df1:	48 c1 e2 04          	shl    $0x4,%rdx
  803df5:	48 01 d0             	add    %rdx,%rax
  803df8:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803dfc:	0f b7 c0             	movzwl %ax,%eax
}
  803dff:	c9                   	leaveq 
  803e00:	c3                   	retq   
