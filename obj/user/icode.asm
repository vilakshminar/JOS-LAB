
obj/user/icode.debug:     file format elf64-x86-64


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
  80003c:	e8 ff 01 00 00       	callq  800240 <libmain>
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
  800048:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80004f:	89 bd ec fd ff ff    	mov    %edi,-0x214(%rbp)
  800055:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80005c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800063:	00 00 00 
  800066:	48 ba c0 49 80 00 00 	movabs $0x8049c0,%rdx
  80006d:	00 00 00 
  800070:	48 89 10             	mov    %rdx,(%rax)

	cprintf("icode startup\n");
  800073:	48 bf c6 49 80 00 00 	movabs $0x8049c6,%rdi
  80007a:	00 00 00 
  80007d:	b8 00 00 00 00       	mov    $0x0,%eax
  800082:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  800089:	00 00 00 
  80008c:	ff d2                	callq  *%rdx

	cprintf("icode: open /motd\n");
  80008e:	48 bf d5 49 80 00 00 	movabs $0x8049d5,%rdi
  800095:	00 00 00 
  800098:	b8 00 00 00 00       	mov    $0x0,%eax
  80009d:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  8000a4:	00 00 00 
  8000a7:	ff d2                	callq  *%rdx
	if ((fd = open("/motd", O_RDONLY)) < 0)
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	48 bf e8 49 80 00 00 	movabs $0x8049e8,%rdi
  8000b5:	00 00 00 
  8000b8:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xb9>
		panic("icode: open /motd: %e", fd);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba ee 49 80 00 00 	movabs $0x8049ee,%rdx
  8000d9:	00 00 00 
  8000dc:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e1:	48 bf 04 4a 80 00 00 	movabs $0x804a04,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8

	cprintf("icode: read /motd\n");
  8000fd:	48 bf 11 4a 80 00 00 	movabs $0x804a11,%rdi
  800104:	00 00 00 
  800107:	b8 00 00 00 00       	mov    $0x0,%eax
  80010c:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  800113:	00 00 00 
  800116:	ff d2                	callq  *%rdx
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800118:	eb 1f                	jmp    800139 <umain+0xf5>
		sys_cputs(buf, n);
  80011a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011d:	48 63 d0             	movslq %eax,%rdx
  800120:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  800127:	48 89 d6             	mov    %rdx,%rsi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800139:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800140:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800143:	ba 00 02 00 00       	mov    $0x200,%edx
  800148:	48 89 ce             	mov    %rcx,%rsi
  80014b:	89 c7                	mov    %eax,%edi
  80014d:	48 b8 90 22 80 00 00 	movabs $0x802290,%rax
  800154:	00 00 00 
  800157:	ff d0                	callq  *%rax
  800159:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80015c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800160:	7f b8                	jg     80011a <umain+0xd6>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  800162:	48 bf 24 4a 80 00 00 	movabs $0x804a24,%rdi
  800169:	00 00 00 
  80016c:	b8 00 00 00 00       	mov    $0x0,%eax
  800171:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  800178:	00 00 00 
  80017b:	ff d2                	callq  *%rdx
	close(fd);
  80017d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800180:	89 c7                	mov    %eax,%edi
  800182:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax

	cprintf("icode: spawn /init\n");
  80018e:	48 bf 38 4a 80 00 00 	movabs $0x804a38,%rdi
  800195:	00 00 00 
  800198:	b8 00 00 00 00       	mov    $0x0,%eax
  80019d:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  8001a4:	00 00 00 
  8001a7:	ff d2                	callq  *%rdx
	if ((r = spawnl("/sbin/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8001a9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001af:	48 b9 4c 4a 80 00 00 	movabs $0x804a4c,%rcx
  8001b6:	00 00 00 
  8001b9:	48 ba 55 4a 80 00 00 	movabs $0x804a55,%rdx
  8001c0:	00 00 00 
  8001c3:	48 be 5e 4a 80 00 00 	movabs $0x804a5e,%rsi
  8001ca:	00 00 00 
  8001cd:	48 bf 63 4a 80 00 00 	movabs $0x804a63,%rdi
  8001d4:	00 00 00 
  8001d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dc:	49 b9 ed 2d 80 00 00 	movabs $0x802ded,%r9
  8001e3:	00 00 00 
  8001e6:	41 ff d1             	callq  *%r9
  8001e9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8001ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8001f0:	79 30                	jns    800222 <umain+0x1de>
		panic("icode: spawn /sbin/init: %e", r);
  8001f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001f5:	89 c1                	mov    %eax,%ecx
  8001f7:	48 ba 6e 4a 80 00 00 	movabs $0x804a6e,%rdx
  8001fe:	00 00 00 
  800201:	be 1a 00 00 00       	mov    $0x1a,%esi
  800206:	48 bf 04 4a 80 00 00 	movabs $0x804a04,%rdi
  80020d:	00 00 00 
  800210:	b8 00 00 00 00       	mov    $0x0,%eax
  800215:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  80021c:	00 00 00 
  80021f:	41 ff d0             	callq  *%r8

	cprintf("icode: exiting\n");
  800222:	48 bf 8a 4a 80 00 00 	movabs $0x804a8a,%rdi
  800229:	00 00 00 
  80022c:	b8 00 00 00 00       	mov    $0x0,%eax
  800231:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  800238:	00 00 00 
  80023b:	ff d2                	callq  *%rdx
}
  80023d:	c9                   	leaveq 
  80023e:	c3                   	retq   
	...

0000000000800240 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
  800244:	48 83 ec 10          	sub    $0x10,%rsp
  800248:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80024b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80024f:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  800256:	00 00 00 
  800259:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800260:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  800267:	00 00 00 
  80026a:	ff d0                	callq  *%rax
  80026c:	48 98                	cltq   
  80026e:	48 89 c2             	mov    %rax,%rdx
  800271:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800277:	48 89 d0             	mov    %rdx,%rax
  80027a:	48 c1 e0 03          	shl    $0x3,%rax
  80027e:	48 01 d0             	add    %rdx,%rax
  800281:	48 c1 e0 05          	shl    $0x5,%rax
  800285:	48 89 c2             	mov    %rax,%rdx
  800288:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80028f:	00 00 00 
  800292:	48 01 c2             	add    %rax,%rdx
  800295:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  80029c:	00 00 00 
  80029f:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002a6:	7e 14                	jle    8002bc <libmain+0x7c>
		binaryname = argv[0];
  8002a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ac:	48 8b 10             	mov    (%rax),%rdx
  8002af:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002b6:	00 00 00 
  8002b9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002c3:	48 89 d6             	mov    %rdx,%rsi
  8002c6:	89 c7                	mov    %eax,%edi
  8002c8:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8002cf:	00 00 00 
  8002d2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002d4:	48 b8 e4 02 80 00 00 	movabs $0x8002e4,%rax
  8002db:	00 00 00 
  8002de:	ff d0                	callq  *%rax
}
  8002e0:	c9                   	leaveq 
  8002e1:	c3                   	retq   
	...

00000000008002e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002e4:	55                   	push   %rbp
  8002e5:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002e8:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  8002ef:	00 00 00 
  8002f2:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002f9:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  800300:	00 00 00 
  800303:	ff d0                	callq  *%rax
}
  800305:	5d                   	pop    %rbp
  800306:	c3                   	retq   
	...

0000000000800308 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	53                   	push   %rbx
  80030d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800314:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80031b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800321:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800328:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80032f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800336:	84 c0                	test   %al,%al
  800338:	74 23                	je     80035d <_panic+0x55>
  80033a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800341:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800345:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800349:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80034d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800351:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800355:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800359:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80035d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800364:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80036b:	00 00 00 
  80036e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800375:	00 00 00 
  800378:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80037c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800383:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80038a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800391:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800398:	00 00 00 
  80039b:	48 8b 18             	mov    (%rax),%rbx
  80039e:	48 b8 bc 19 80 00 00 	movabs $0x8019bc,%rax
  8003a5:	00 00 00 
  8003a8:	ff d0                	callq  *%rax
  8003aa:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003b0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003b7:	41 89 c8             	mov    %ecx,%r8d
  8003ba:	48 89 d1             	mov    %rdx,%rcx
  8003bd:	48 89 da             	mov    %rbx,%rdx
  8003c0:	89 c6                	mov    %eax,%esi
  8003c2:	48 bf a8 4a 80 00 00 	movabs $0x804aa8,%rdi
  8003c9:	00 00 00 
  8003cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d1:	49 b9 43 05 80 00 00 	movabs $0x800543,%r9
  8003d8:	00 00 00 
  8003db:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003de:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003e5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ec:	48 89 d6             	mov    %rdx,%rsi
  8003ef:	48 89 c7             	mov    %rax,%rdi
  8003f2:	48 b8 97 04 80 00 00 	movabs $0x800497,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
	cprintf("\n");
  8003fe:	48 bf cb 4a 80 00 00 	movabs $0x804acb,%rdi
  800405:	00 00 00 
  800408:	b8 00 00 00 00       	mov    $0x0,%eax
  80040d:	48 ba 43 05 80 00 00 	movabs $0x800543,%rdx
  800414:	00 00 00 
  800417:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800419:	cc                   	int3   
  80041a:	eb fd                	jmp    800419 <_panic+0x111>

000000000080041c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 10          	sub    $0x10,%rsp
  800424:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800427:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80042b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042f:	8b 00                	mov    (%rax),%eax
  800431:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800434:	89 d6                	mov    %edx,%esi
  800436:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80043a:	48 63 d0             	movslq %eax,%rdx
  80043d:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800442:	8d 50 01             	lea    0x1(%rax),%edx
  800445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800449:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80044b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044f:	8b 00                	mov    (%rax),%eax
  800451:	3d ff 00 00 00       	cmp    $0xff,%eax
  800456:	75 2c                	jne    800484 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800458:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045c:	8b 00                	mov    (%rax),%eax
  80045e:	48 98                	cltq   
  800460:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800464:	48 83 c2 08          	add    $0x8,%rdx
  800468:	48 89 c6             	mov    %rax,%rsi
  80046b:	48 89 d7             	mov    %rdx,%rdi
  80046e:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800475:	00 00 00 
  800478:	ff d0                	callq  *%rax
		b->idx = 0;
  80047a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800484:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800488:	8b 40 04             	mov    0x4(%rax),%eax
  80048b:	8d 50 01             	lea    0x1(%rax),%edx
  80048e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800492:	89 50 04             	mov    %edx,0x4(%rax)
}
  800495:	c9                   	leaveq 
  800496:	c3                   	retq   

0000000000800497 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800497:	55                   	push   %rbp
  800498:	48 89 e5             	mov    %rsp,%rbp
  80049b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8004b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004be:	48 8b 0a             	mov    (%rdx),%rcx
  8004c1:	48 89 08             	mov    %rcx,(%rax)
  8004c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8004e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004fd:	48 89 c6             	mov    %rax,%rsi
  800500:	48 bf 1c 04 80 00 00 	movabs $0x80041c,%rdi
  800507:	00 00 00 
  80050a:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800511:	00 00 00 
  800514:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800516:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80051c:	48 98                	cltq   
  80051e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800525:	48 83 c2 08          	add    $0x8,%rdx
  800529:	48 89 c6             	mov    %rax,%rsi
  80052c:	48 89 d7             	mov    %rdx,%rdi
  80052f:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800536:	00 00 00 
  800539:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80053b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800541:	c9                   	leaveq 
  800542:	c3                   	retq   

0000000000800543 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800543:	55                   	push   %rbp
  800544:	48 89 e5             	mov    %rsp,%rbp
  800547:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80054e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800555:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80055c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800563:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80056a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800571:	84 c0                	test   %al,%al
  800573:	74 20                	je     800595 <cprintf+0x52>
  800575:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800579:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80057d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800581:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800585:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800589:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80058d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800591:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800595:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80059c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005a3:	00 00 00 
  8005a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005ad:	00 00 00 
  8005b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8005c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005d7:	48 8b 0a             	mov    (%rdx),%rcx
  8005da:	48 89 08             	mov    %rcx,(%rax)
  8005dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8005ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005fb:	48 89 d6             	mov    %rdx,%rsi
  8005fe:	48 89 c7             	mov    %rax,%rdi
  800601:	48 b8 97 04 80 00 00 	movabs $0x800497,%rax
  800608:	00 00 00 
  80060b:	ff d0                	callq  *%rax
  80060d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800613:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800619:	c9                   	leaveq 
  80061a:	c3                   	retq   
	...

000000000080061c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061c:	55                   	push   %rbp
  80061d:	48 89 e5             	mov    %rsp,%rbp
  800620:	48 83 ec 30          	sub    $0x30,%rsp
  800624:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800628:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80062c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800630:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800633:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800637:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80063e:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800642:	77 52                	ja     800696 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800644:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800647:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80064b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80064e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	48 f7 75 d0          	divq   -0x30(%rbp)
  80065f:	48 89 c2             	mov    %rax,%rdx
  800662:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800665:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800668:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80066c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800670:	41 89 f9             	mov    %edi,%r9d
  800673:	48 89 c7             	mov    %rax,%rdi
  800676:	48 b8 1c 06 80 00 00 	movabs $0x80061c,%rax
  80067d:	00 00 00 
  800680:	ff d0                	callq  *%rax
  800682:	eb 1c                	jmp    8006a0 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800684:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800688:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80068b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80068f:	48 89 d6             	mov    %rdx,%rsi
  800692:	89 c7                	mov    %eax,%edi
  800694:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800696:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80069a:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80069e:	7f e4                	jg     800684 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8006a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ac:	48 f7 f1             	div    %rcx
  8006af:	48 89 d0             	mov    %rdx,%rax
  8006b2:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  8006b9:	00 00 00 
  8006bc:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006c0:	0f be c0             	movsbl %al,%eax
  8006c3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006c7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8006cb:	48 89 d6             	mov    %rdx,%rsi
  8006ce:	89 c7                	mov    %eax,%edi
  8006d0:	ff d1                	callq  *%rcx
}
  8006d2:	c9                   	leaveq 
  8006d3:	c3                   	retq   

00000000008006d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006d4:	55                   	push   %rbp
  8006d5:	48 89 e5             	mov    %rsp,%rbp
  8006d8:	48 83 ec 20          	sub    $0x20,%rsp
  8006dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006e3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006e7:	7e 52                	jle    80073b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ed:	8b 00                	mov    (%rax),%eax
  8006ef:	83 f8 30             	cmp    $0x30,%eax
  8006f2:	73 24                	jae    800718 <getuint+0x44>
  8006f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800700:	8b 00                	mov    (%rax),%eax
  800702:	89 c0                	mov    %eax,%eax
  800704:	48 01 d0             	add    %rdx,%rax
  800707:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070b:	8b 12                	mov    (%rdx),%edx
  80070d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800710:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800714:	89 0a                	mov    %ecx,(%rdx)
  800716:	eb 17                	jmp    80072f <getuint+0x5b>
  800718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800727:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072f:	48 8b 00             	mov    (%rax),%rax
  800732:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800736:	e9 a3 00 00 00       	jmpq   8007de <getuint+0x10a>
	else if (lflag)
  80073b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80073f:	74 4f                	je     800790 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	83 f8 30             	cmp    $0x30,%eax
  80074a:	73 24                	jae    800770 <getuint+0x9c>
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	89 c0                	mov    %eax,%eax
  80075c:	48 01 d0             	add    %rdx,%rax
  80075f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800763:	8b 12                	mov    (%rdx),%edx
  800765:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076c:	89 0a                	mov    %ecx,(%rdx)
  80076e:	eb 17                	jmp    800787 <getuint+0xb3>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800778:	48 89 d0             	mov    %rdx,%rax
  80077b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800787:	48 8b 00             	mov    (%rax),%rax
  80078a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078e:	eb 4e                	jmp    8007de <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800794:	8b 00                	mov    (%rax),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 24                	jae    8007bf <getuint+0xeb>
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a7:	8b 00                	mov    (%rax),%eax
  8007a9:	89 c0                	mov    %eax,%eax
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b2:	8b 12                	mov    (%rdx),%edx
  8007b4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	89 0a                	mov    %ecx,(%rdx)
  8007bd:	eb 17                	jmp    8007d6 <getuint+0x102>
  8007bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c7:	48 89 d0             	mov    %rdx,%rax
  8007ca:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d6:	8b 00                	mov    (%rax),%eax
  8007d8:	89 c0                	mov    %eax,%eax
  8007da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007e2:	c9                   	leaveq 
  8007e3:	c3                   	retq   

00000000008007e4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007e4:	55                   	push   %rbp
  8007e5:	48 89 e5             	mov    %rsp,%rbp
  8007e8:	48 83 ec 20          	sub    $0x20,%rsp
  8007ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007f7:	7e 52                	jle    80084b <getint+0x67>
		x=va_arg(*ap, long long);
  8007f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fd:	8b 00                	mov    (%rax),%eax
  8007ff:	83 f8 30             	cmp    $0x30,%eax
  800802:	73 24                	jae    800828 <getint+0x44>
  800804:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800808:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	8b 00                	mov    (%rax),%eax
  800812:	89 c0                	mov    %eax,%eax
  800814:	48 01 d0             	add    %rdx,%rax
  800817:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081b:	8b 12                	mov    (%rdx),%edx
  80081d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800820:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800824:	89 0a                	mov    %ecx,(%rdx)
  800826:	eb 17                	jmp    80083f <getint+0x5b>
  800828:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800830:	48 89 d0             	mov    %rdx,%rax
  800833:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800837:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083f:	48 8b 00             	mov    (%rax),%rax
  800842:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800846:	e9 a3 00 00 00       	jmpq   8008ee <getint+0x10a>
	else if (lflag)
  80084b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80084f:	74 4f                	je     8008a0 <getint+0xbc>
		x=va_arg(*ap, long);
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	8b 00                	mov    (%rax),%eax
  800857:	83 f8 30             	cmp    $0x30,%eax
  80085a:	73 24                	jae    800880 <getint+0x9c>
  80085c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800860:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	8b 00                	mov    (%rax),%eax
  80086a:	89 c0                	mov    %eax,%eax
  80086c:	48 01 d0             	add    %rdx,%rax
  80086f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800873:	8b 12                	mov    (%rdx),%edx
  800875:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800878:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087c:	89 0a                	mov    %ecx,(%rdx)
  80087e:	eb 17                	jmp    800897 <getint+0xb3>
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800888:	48 89 d0             	mov    %rdx,%rax
  80088b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800893:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800897:	48 8b 00             	mov    (%rax),%rax
  80089a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80089e:	eb 4e                	jmp    8008ee <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a4:	8b 00                	mov    (%rax),%eax
  8008a6:	83 f8 30             	cmp    $0x30,%eax
  8008a9:	73 24                	jae    8008cf <getint+0xeb>
  8008ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008af:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	8b 00                	mov    (%rax),%eax
  8008b9:	89 c0                	mov    %eax,%eax
  8008bb:	48 01 d0             	add    %rdx,%rax
  8008be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c2:	8b 12                	mov    (%rdx),%edx
  8008c4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cb:	89 0a                	mov    %ecx,(%rdx)
  8008cd:	eb 17                	jmp    8008e6 <getint+0x102>
  8008cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d3:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d7:	48 89 d0             	mov    %rdx,%rax
  8008da:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e6:	8b 00                	mov    (%rax),%eax
  8008e8:	48 98                	cltq   
  8008ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008f2:	c9                   	leaveq 
  8008f3:	c3                   	retq   

00000000008008f4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008f4:	55                   	push   %rbp
  8008f5:	48 89 e5             	mov    %rsp,%rbp
  8008f8:	41 54                	push   %r12
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 60          	sub    $0x60,%rsp
  8008ff:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800903:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800907:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80090b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80090f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800913:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800917:	48 8b 0a             	mov    (%rdx),%rcx
  80091a:	48 89 08             	mov    %rcx,(%rax)
  80091d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800921:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800925:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800929:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092d:	eb 17                	jmp    800946 <vprintfmt+0x52>
			if (ch == '\0')
  80092f:	85 db                	test   %ebx,%ebx
  800931:	0f 84 d7 04 00 00    	je     800e0e <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800937:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  80093b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80093f:	48 89 c6             	mov    %rax,%rsi
  800942:	89 df                	mov    %ebx,%edi
  800944:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800946:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80094a:	0f b6 00             	movzbl (%rax),%eax
  80094d:	0f b6 d8             	movzbl %al,%ebx
  800950:	83 fb 25             	cmp    $0x25,%ebx
  800953:	0f 95 c0             	setne  %al
  800956:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80095b:	84 c0                	test   %al,%al
  80095d:	75 d0                	jne    80092f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800963:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80096a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800971:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800978:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  80097f:	eb 04                	jmp    800985 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800981:	90                   	nop
  800982:	eb 01                	jmp    800985 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800984:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800985:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800989:	0f b6 00             	movzbl (%rax),%eax
  80098c:	0f b6 d8             	movzbl %al,%ebx
  80098f:	89 d8                	mov    %ebx,%eax
  800991:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800996:	83 e8 23             	sub    $0x23,%eax
  800999:	83 f8 55             	cmp    $0x55,%eax
  80099c:	0f 87 38 04 00 00    	ja     800dda <vprintfmt+0x4e6>
  8009a2:	89 c0                	mov    %eax,%eax
  8009a4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009ab:	00 
  8009ac:	48 b8 d0 4c 80 00 00 	movabs $0x804cd0,%rax
  8009b3:	00 00 00 
  8009b6:	48 01 d0             	add    %rdx,%rax
  8009b9:	48 8b 00             	mov    (%rax),%rax
  8009bc:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009be:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009c2:	eb c1                	jmp    800985 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009c8:	eb bb                	jmp    800985 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ca:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009d1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009d4:	89 d0                	mov    %edx,%eax
  8009d6:	c1 e0 02             	shl    $0x2,%eax
  8009d9:	01 d0                	add    %edx,%eax
  8009db:	01 c0                	add    %eax,%eax
  8009dd:	01 d8                	add    %ebx,%eax
  8009df:	83 e8 30             	sub    $0x30,%eax
  8009e2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009e5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009e9:	0f b6 00             	movzbl (%rax),%eax
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 63                	jle    800a57 <vprintfmt+0x163>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 5e                	jg     800a57 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fe:	eb d1                	jmp    8009d1 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800a00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a03:	83 f8 30             	cmp    $0x30,%eax
  800a06:	73 17                	jae    800a1f <vprintfmt+0x12b>
  800a08:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a0c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0f:	89 c0                	mov    %eax,%eax
  800a11:	48 01 d0             	add    %rdx,%rax
  800a14:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a17:	83 c2 08             	add    $0x8,%edx
  800a1a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1d:	eb 0f                	jmp    800a2e <vprintfmt+0x13a>
  800a1f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a23:	48 89 d0             	mov    %rdx,%rax
  800a26:	48 83 c2 08          	add    $0x8,%rdx
  800a2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2e:	8b 00                	mov    (%rax),%eax
  800a30:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a33:	eb 23                	jmp    800a58 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800a35:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a39:	0f 89 42 ff ff ff    	jns    800981 <vprintfmt+0x8d>
				width = 0;
  800a3f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a46:	e9 36 ff ff ff       	jmpq   800981 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800a4b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a52:	e9 2e ff ff ff       	jmpq   800985 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a57:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a58:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5c:	0f 89 22 ff ff ff    	jns    800984 <vprintfmt+0x90>
				width = precision, precision = -1;
  800a62:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a65:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a68:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a6f:	e9 10 ff ff ff       	jmpq   800984 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a74:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a78:	e9 08 ff ff ff       	jmpq   800985 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a80:	83 f8 30             	cmp    $0x30,%eax
  800a83:	73 17                	jae    800a9c <vprintfmt+0x1a8>
  800a85:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a8c:	89 c0                	mov    %eax,%eax
  800a8e:	48 01 d0             	add    %rdx,%rax
  800a91:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a94:	83 c2 08             	add    $0x8,%edx
  800a97:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a9a:	eb 0f                	jmp    800aab <vprintfmt+0x1b7>
  800a9c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aa0:	48 89 d0             	mov    %rdx,%rax
  800aa3:	48 83 c2 08          	add    $0x8,%rdx
  800aa7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aab:	8b 00                	mov    (%rax),%eax
  800aad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ab1:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ab5:	48 89 d6             	mov    %rdx,%rsi
  800ab8:	89 c7                	mov    %eax,%edi
  800aba:	ff d1                	callq  *%rcx
			break;
  800abc:	e9 47 03 00 00       	jmpq   800e08 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ac1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac4:	83 f8 30             	cmp    $0x30,%eax
  800ac7:	73 17                	jae    800ae0 <vprintfmt+0x1ec>
  800ac9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800acd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ad0:	89 c0                	mov    %eax,%eax
  800ad2:	48 01 d0             	add    %rdx,%rax
  800ad5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ad8:	83 c2 08             	add    $0x8,%edx
  800adb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ade:	eb 0f                	jmp    800aef <vprintfmt+0x1fb>
  800ae0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ae4:	48 89 d0             	mov    %rdx,%rax
  800ae7:	48 83 c2 08          	add    $0x8,%rdx
  800aeb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aef:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800af1:	85 db                	test   %ebx,%ebx
  800af3:	79 02                	jns    800af7 <vprintfmt+0x203>
				err = -err;
  800af5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800af7:	83 fb 10             	cmp    $0x10,%ebx
  800afa:	7f 16                	jg     800b12 <vprintfmt+0x21e>
  800afc:	48 b8 20 4c 80 00 00 	movabs $0x804c20,%rax
  800b03:	00 00 00 
  800b06:	48 63 d3             	movslq %ebx,%rdx
  800b09:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b0d:	4d 85 e4             	test   %r12,%r12
  800b10:	75 2e                	jne    800b40 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800b12:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1a:	89 d9                	mov    %ebx,%ecx
  800b1c:	48 ba b9 4c 80 00 00 	movabs $0x804cb9,%rdx
  800b23:	00 00 00 
  800b26:	48 89 c7             	mov    %rax,%rdi
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2e:	49 b8 18 0e 80 00 00 	movabs $0x800e18,%r8
  800b35:	00 00 00 
  800b38:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b3b:	e9 c8 02 00 00       	jmpq   800e08 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b40:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b48:	4c 89 e1             	mov    %r12,%rcx
  800b4b:	48 ba c2 4c 80 00 00 	movabs $0x804cc2,%rdx
  800b52:	00 00 00 
  800b55:	48 89 c7             	mov    %rax,%rdi
  800b58:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5d:	49 b8 18 0e 80 00 00 	movabs $0x800e18,%r8
  800b64:	00 00 00 
  800b67:	41 ff d0             	callq  *%r8
			break;
  800b6a:	e9 99 02 00 00       	jmpq   800e08 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b72:	83 f8 30             	cmp    $0x30,%eax
  800b75:	73 17                	jae    800b8e <vprintfmt+0x29a>
  800b77:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7e:	89 c0                	mov    %eax,%eax
  800b80:	48 01 d0             	add    %rdx,%rax
  800b83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b86:	83 c2 08             	add    $0x8,%edx
  800b89:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b8c:	eb 0f                	jmp    800b9d <vprintfmt+0x2a9>
  800b8e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b92:	48 89 d0             	mov    %rdx,%rax
  800b95:	48 83 c2 08          	add    $0x8,%rdx
  800b99:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b9d:	4c 8b 20             	mov    (%rax),%r12
  800ba0:	4d 85 e4             	test   %r12,%r12
  800ba3:	75 0a                	jne    800baf <vprintfmt+0x2bb>
				p = "(null)";
  800ba5:	49 bc c5 4c 80 00 00 	movabs $0x804cc5,%r12
  800bac:	00 00 00 
			if (width > 0 && padc != '-')
  800baf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb3:	7e 7a                	jle    800c2f <vprintfmt+0x33b>
  800bb5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800bb9:	74 74                	je     800c2f <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bbb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bbe:	48 98                	cltq   
  800bc0:	48 89 c6             	mov    %rax,%rsi
  800bc3:	4c 89 e7             	mov    %r12,%rdi
  800bc6:	48 b8 c2 10 80 00 00 	movabs $0x8010c2,%rax
  800bcd:	00 00 00 
  800bd0:	ff d0                	callq  *%rax
  800bd2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bd5:	eb 17                	jmp    800bee <vprintfmt+0x2fa>
					putch(padc, putdat);
  800bd7:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800bdb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bdf:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800be3:	48 89 d6             	mov    %rdx,%rsi
  800be6:	89 c7                	mov    %eax,%edi
  800be8:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bea:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bee:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf2:	7f e3                	jg     800bd7 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf4:	eb 39                	jmp    800c2f <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800bf6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bfa:	74 1e                	je     800c1a <vprintfmt+0x326>
  800bfc:	83 fb 1f             	cmp    $0x1f,%ebx
  800bff:	7e 05                	jle    800c06 <vprintfmt+0x312>
  800c01:	83 fb 7e             	cmp    $0x7e,%ebx
  800c04:	7e 14                	jle    800c1a <vprintfmt+0x326>
					putch('?', putdat);
  800c06:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c0a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c0e:	48 89 c6             	mov    %rax,%rsi
  800c11:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c16:	ff d2                	callq  *%rdx
  800c18:	eb 0f                	jmp    800c29 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800c1a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c1e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c22:	48 89 c6             	mov    %rax,%rsi
  800c25:	89 df                	mov    %ebx,%edi
  800c27:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c29:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c2d:	eb 01                	jmp    800c30 <vprintfmt+0x33c>
  800c2f:	90                   	nop
  800c30:	41 0f b6 04 24       	movzbl (%r12),%eax
  800c35:	0f be d8             	movsbl %al,%ebx
  800c38:	85 db                	test   %ebx,%ebx
  800c3a:	0f 95 c0             	setne  %al
  800c3d:	49 83 c4 01          	add    $0x1,%r12
  800c41:	84 c0                	test   %al,%al
  800c43:	74 28                	je     800c6d <vprintfmt+0x379>
  800c45:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c49:	78 ab                	js     800bf6 <vprintfmt+0x302>
  800c4b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c53:	79 a1                	jns    800bf6 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c55:	eb 16                	jmp    800c6d <vprintfmt+0x379>
				putch(' ', putdat);
  800c57:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c5b:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c5f:	48 89 c6             	mov    %rax,%rsi
  800c62:	bf 20 00 00 00       	mov    $0x20,%edi
  800c67:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c71:	7f e4                	jg     800c57 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c73:	e9 90 01 00 00       	jmpq   800e08 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7c:	be 03 00 00 00       	mov    $0x3,%esi
  800c81:	48 89 c7             	mov    %rax,%rdi
  800c84:	48 b8 e4 07 80 00 00 	movabs $0x8007e4,%rax
  800c8b:	00 00 00 
  800c8e:	ff d0                	callq  *%rax
  800c90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c98:	48 85 c0             	test   %rax,%rax
  800c9b:	79 1d                	jns    800cba <vprintfmt+0x3c6>
				putch('-', putdat);
  800c9d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ca1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca5:	48 89 c6             	mov    %rax,%rsi
  800ca8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cad:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800caf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cb3:	48 f7 d8             	neg    %rax
  800cb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800cba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cc1:	e9 d5 00 00 00       	jmpq   800d9b <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800cc6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cca:	be 03 00 00 00       	mov    $0x3,%esi
  800ccf:	48 89 c7             	mov    %rax,%rdi
  800cd2:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800cd9:	00 00 00 
  800cdc:	ff d0                	callq  *%rax
  800cde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ce2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ce9:	e9 ad 00 00 00       	jmpq   800d9b <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800cee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf2:	be 03 00 00 00       	mov    $0x3,%esi
  800cf7:	48 89 c7             	mov    %rax,%rdi
  800cfa:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d01:	00 00 00 
  800d04:	ff d0                	callq  *%rax
  800d06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800d0a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800d11:	e9 85 00 00 00       	jmpq   800d9b <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800d16:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d1a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d1e:	48 89 c6             	mov    %rax,%rsi
  800d21:	bf 30 00 00 00       	mov    $0x30,%edi
  800d26:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800d28:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d2c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d30:	48 89 c6             	mov    %rax,%rsi
  800d33:	bf 78 00 00 00       	mov    $0x78,%edi
  800d38:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d3d:	83 f8 30             	cmp    $0x30,%eax
  800d40:	73 17                	jae    800d59 <vprintfmt+0x465>
  800d42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d49:	89 c0                	mov    %eax,%eax
  800d4b:	48 01 d0             	add    %rdx,%rax
  800d4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d51:	83 c2 08             	add    $0x8,%edx
  800d54:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d57:	eb 0f                	jmp    800d68 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800d59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d5d:	48 89 d0             	mov    %rdx,%rax
  800d60:	48 83 c2 08          	add    $0x8,%rdx
  800d64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d68:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d76:	eb 23                	jmp    800d9b <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d7c:	be 03 00 00 00       	mov    $0x3,%esi
  800d81:	48 89 c7             	mov    %rax,%rdi
  800d84:	48 b8 d4 06 80 00 00 	movabs $0x8006d4,%rax
  800d8b:	00 00 00 
  800d8e:	ff d0                	callq  *%rax
  800d90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d94:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d9b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800da0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800da3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800da6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800daa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db2:	45 89 c1             	mov    %r8d,%r9d
  800db5:	41 89 f8             	mov    %edi,%r8d
  800db8:	48 89 c7             	mov    %rax,%rdi
  800dbb:	48 b8 1c 06 80 00 00 	movabs $0x80061c,%rax
  800dc2:	00 00 00 
  800dc5:	ff d0                	callq  *%rax
			break;
  800dc7:	eb 3f                	jmp    800e08 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dcd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dd1:	48 89 c6             	mov    %rax,%rsi
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	ff d2                	callq  *%rdx
			break;
  800dd8:	eb 2e                	jmp    800e08 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dda:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800dde:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800de2:	48 89 c6             	mov    %rax,%rsi
  800de5:	bf 25 00 00 00       	mov    $0x25,%edi
  800dea:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dec:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df1:	eb 05                	jmp    800df8 <vprintfmt+0x504>
  800df3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800df8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800dfc:	48 83 e8 01          	sub    $0x1,%rax
  800e00:	0f b6 00             	movzbl (%rax),%eax
  800e03:	3c 25                	cmp    $0x25,%al
  800e05:	75 ec                	jne    800df3 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800e07:	90                   	nop
		}
	}
  800e08:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e09:	e9 38 fb ff ff       	jmpq   800946 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800e0e:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800e0f:	48 83 c4 60          	add    $0x60,%rsp
  800e13:	5b                   	pop    %rbx
  800e14:	41 5c                	pop    %r12
  800e16:	5d                   	pop    %rbp
  800e17:	c3                   	retq   

0000000000800e18 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e18:	55                   	push   %rbp
  800e19:	48 89 e5             	mov    %rsp,%rbp
  800e1c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e23:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e2a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e31:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e38:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e3f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e46:	84 c0                	test   %al,%al
  800e48:	74 20                	je     800e6a <printfmt+0x52>
  800e4a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e4e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e52:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e56:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e5a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e5e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e62:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e66:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e6a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e71:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e78:	00 00 00 
  800e7b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e82:	00 00 00 
  800e85:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e89:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e90:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e97:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e9e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ea5:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800eac:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800eb3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800eba:	48 89 c7             	mov    %rax,%rdi
  800ebd:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800ec4:	00 00 00 
  800ec7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ec9:	c9                   	leaveq 
  800eca:	c3                   	retq   

0000000000800ecb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ecb:	55                   	push   %rbp
  800ecc:	48 89 e5             	mov    %rsp,%rbp
  800ecf:	48 83 ec 10          	sub    $0x10,%rsp
  800ed3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ed6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ede:	8b 40 10             	mov    0x10(%rax),%eax
  800ee1:	8d 50 01             	lea    0x1(%rax),%edx
  800ee4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eef:	48 8b 10             	mov    (%rax),%rdx
  800ef2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ef6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800efa:	48 39 c2             	cmp    %rax,%rdx
  800efd:	73 17                	jae    800f16 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f03:	48 8b 00             	mov    (%rax),%rax
  800f06:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f09:	88 10                	mov    %dl,(%rax)
  800f0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f13:	48 89 10             	mov    %rdx,(%rax)
}
  800f16:	c9                   	leaveq 
  800f17:	c3                   	retq   

0000000000800f18 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 83 ec 50          	sub    $0x50,%rsp
  800f20:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f24:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f27:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f2b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f2f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f33:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f37:	48 8b 0a             	mov    (%rdx),%rcx
  800f3a:	48 89 08             	mov    %rcx,(%rax)
  800f3d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f41:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f45:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f49:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f4d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f51:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f55:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f58:	48 98                	cltq   
  800f5a:	48 83 e8 01          	sub    $0x1,%rax
  800f5e:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800f62:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f6d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f72:	74 06                	je     800f7a <vsnprintf+0x62>
  800f74:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f78:	7f 07                	jg     800f81 <vsnprintf+0x69>
		return -E_INVAL;
  800f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7f:	eb 2f                	jmp    800fb0 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f81:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f85:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f89:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f8d:	48 89 c6             	mov    %rax,%rsi
  800f90:	48 bf cb 0e 80 00 00 	movabs $0x800ecb,%rdi
  800f97:	00 00 00 
  800f9a:	48 b8 f4 08 80 00 00 	movabs $0x8008f4,%rax
  800fa1:	00 00 00 
  800fa4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800fa6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800faa:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800fad:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800fb0:	c9                   	leaveq 
  800fb1:	c3                   	retq   

0000000000800fb2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb2:	55                   	push   %rbp
  800fb3:	48 89 e5             	mov    %rsp,%rbp
  800fb6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fbd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800fc4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fd1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fd8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fdf:	84 c0                	test   %al,%al
  800fe1:	74 20                	je     801003 <snprintf+0x51>
  800fe3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fe7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800feb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ff3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ff7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ffb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801003:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80100a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801011:	00 00 00 
  801014:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80101b:	00 00 00 
  80101e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801022:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801029:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801030:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801037:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80103e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801045:	48 8b 0a             	mov    (%rdx),%rcx
  801048:	48 89 08             	mov    %rcx,(%rax)
  80104b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801053:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801057:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80105b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801062:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801069:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80106f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801076:	48 89 c7             	mov    %rax,%rdi
  801079:	48 b8 18 0f 80 00 00 	movabs $0x800f18,%rax
  801080:	00 00 00 
  801083:	ff d0                	callq  *%rax
  801085:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80108b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801091:	c9                   	leaveq 
  801092:	c3                   	retq   
	...

0000000000801094 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 18          	sub    $0x18,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010a7:	eb 09                	jmp    8010b2 <strlen+0x1e>
		n++;
  8010a9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	84 c0                	test   %al,%al
  8010bb:	75 ec                	jne    8010a9 <strlen+0x15>
		n++;
	return n;
  8010bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 20          	sub    $0x20,%rsp
  8010ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010d9:	eb 0e                	jmp    8010e9 <strnlen+0x27>
		n++;
  8010db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010df:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010e4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010e9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010ee:	74 0b                	je     8010fb <strnlen+0x39>
  8010f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f4:	0f b6 00             	movzbl (%rax),%eax
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 e0                	jne    8010db <strnlen+0x19>
		n++;
	return n;
  8010fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010fe:	c9                   	leaveq 
  8010ff:	c3                   	retq   

0000000000801100 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801100:	55                   	push   %rbp
  801101:	48 89 e5             	mov    %rsp,%rbp
  801104:	48 83 ec 20          	sub    $0x20,%rsp
  801108:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80110c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801114:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801118:	90                   	nop
  801119:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80111d:	0f b6 10             	movzbl (%rax),%edx
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	88 10                	mov    %dl,(%rax)
  801126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112a:	0f b6 00             	movzbl (%rax),%eax
  80112d:	84 c0                	test   %al,%al
  80112f:	0f 95 c0             	setne  %al
  801132:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801137:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80113c:	84 c0                	test   %al,%al
  80113e:	75 d9                	jne    801119 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801144:	c9                   	leaveq 
  801145:	c3                   	retq   

0000000000801146 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801146:	55                   	push   %rbp
  801147:	48 89 e5             	mov    %rsp,%rbp
  80114a:	48 83 ec 20          	sub    $0x20,%rsp
  80114e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	48 89 c7             	mov    %rax,%rdi
  80115d:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  801164:	00 00 00 
  801167:	ff d0                	callq  *%rax
  801169:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80116c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116f:	48 98                	cltq   
  801171:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801175:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801179:	48 89 d6             	mov    %rdx,%rsi
  80117c:	48 89 c7             	mov    %rax,%rdi
  80117f:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  801186:	00 00 00 
  801189:	ff d0                	callq  *%rax
	return dst;
  80118b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80118f:	c9                   	leaveq 
  801190:	c3                   	retq   

0000000000801191 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801191:	55                   	push   %rbp
  801192:	48 89 e5             	mov    %rsp,%rbp
  801195:	48 83 ec 28          	sub    $0x28,%rsp
  801199:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011b4:	00 
  8011b5:	eb 27                	jmp    8011de <strncpy+0x4d>
		*dst++ = *src;
  8011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bb:	0f b6 10             	movzbl (%rax),%edx
  8011be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c2:	88 10                	mov    %dl,(%rax)
  8011c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cd:	0f b6 00             	movzbl (%rax),%eax
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 05                	je     8011d9 <strncpy+0x48>
			src++;
  8011d4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011e6:	72 cf                	jb     8011b7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011ec:	c9                   	leaveq 
  8011ed:	c3                   	retq   

00000000008011ee <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011ee:	55                   	push   %rbp
  8011ef:	48 89 e5             	mov    %rsp,%rbp
  8011f2:	48 83 ec 28          	sub    $0x28,%rsp
  8011f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011fe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801206:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80120a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80120f:	74 37                	je     801248 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801211:	eb 17                	jmp    80122a <strlcpy+0x3c>
			*dst++ = *src++;
  801213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801217:	0f b6 10             	movzbl (%rax),%edx
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	88 10                	mov    %dl,(%rax)
  801220:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801225:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80122a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80122f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801234:	74 0b                	je     801241 <strlcpy+0x53>
  801236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	75 d2                	jne    801213 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801241:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801245:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801248:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	48 89 d1             	mov    %rdx,%rcx
  801253:	48 29 c1             	sub    %rax,%rcx
  801256:	48 89 c8             	mov    %rcx,%rax
}
  801259:	c9                   	leaveq 
  80125a:	c3                   	retq   

000000000080125b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80125b:	55                   	push   %rbp
  80125c:	48 89 e5             	mov    %rsp,%rbp
  80125f:	48 83 ec 10          	sub    $0x10,%rsp
  801263:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801267:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80126b:	eb 0a                	jmp    801277 <strcmp+0x1c>
		p++, q++;
  80126d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801272:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801277:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127b:	0f b6 00             	movzbl (%rax),%eax
  80127e:	84 c0                	test   %al,%al
  801280:	74 12                	je     801294 <strcmp+0x39>
  801282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801286:	0f b6 10             	movzbl (%rax),%edx
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	0f b6 00             	movzbl (%rax),%eax
  801290:	38 c2                	cmp    %al,%dl
  801292:	74 d9                	je     80126d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801294:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801298:	0f b6 00             	movzbl (%rax),%eax
  80129b:	0f b6 d0             	movzbl %al,%edx
  80129e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a2:	0f b6 00             	movzbl (%rax),%eax
  8012a5:	0f b6 c0             	movzbl %al,%eax
  8012a8:	89 d1                	mov    %edx,%ecx
  8012aa:	29 c1                	sub    %eax,%ecx
  8012ac:	89 c8                	mov    %ecx,%eax
}
  8012ae:	c9                   	leaveq 
  8012af:	c3                   	retq   

00000000008012b0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012b0:	55                   	push   %rbp
  8012b1:	48 89 e5             	mov    %rsp,%rbp
  8012b4:	48 83 ec 18          	sub    $0x18,%rsp
  8012b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012c4:	eb 0f                	jmp    8012d5 <strncmp+0x25>
		n--, p++, q++;
  8012c6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012da:	74 1d                	je     8012f9 <strncmp+0x49>
  8012dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e0:	0f b6 00             	movzbl (%rax),%eax
  8012e3:	84 c0                	test   %al,%al
  8012e5:	74 12                	je     8012f9 <strncmp+0x49>
  8012e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012eb:	0f b6 10             	movzbl (%rax),%edx
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	38 c2                	cmp    %al,%dl
  8012f7:	74 cd                	je     8012c6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012fe:	75 07                	jne    801307 <strncmp+0x57>
		return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb 1a                	jmp    801321 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801307:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	0f b6 d0             	movzbl %al,%edx
  801311:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 c0             	movzbl %al,%eax
  80131b:	89 d1                	mov    %edx,%ecx
  80131d:	29 c1                	sub    %eax,%ecx
  80131f:	89 c8                	mov    %ecx,%eax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 10          	sub    $0x10,%rsp
  80132b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80132f:	89 f0                	mov    %esi,%eax
  801331:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801334:	eb 17                	jmp    80134d <strchr+0x2a>
		if (*s == c)
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	0f b6 00             	movzbl (%rax),%eax
  80133d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801340:	75 06                	jne    801348 <strchr+0x25>
			return (char *) s;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801346:	eb 15                	jmp    80135d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801348:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80134d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801351:	0f b6 00             	movzbl (%rax),%eax
  801354:	84 c0                	test   %al,%al
  801356:	75 de                	jne    801336 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135d:	c9                   	leaveq 
  80135e:	c3                   	retq   

000000000080135f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80135f:	55                   	push   %rbp
  801360:	48 89 e5             	mov    %rsp,%rbp
  801363:	48 83 ec 10          	sub    $0x10,%rsp
  801367:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136b:	89 f0                	mov    %esi,%eax
  80136d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801370:	eb 11                	jmp    801383 <strfind+0x24>
		if (*s == c)
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80137c:	74 12                	je     801390 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80137e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	84 c0                	test   %al,%al
  80138c:	75 e4                	jne    801372 <strfind+0x13>
  80138e:	eb 01                	jmp    801391 <strfind+0x32>
		if (*s == c)
			break;
  801390:	90                   	nop
	return (char *) s;
  801391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801395:	c9                   	leaveq 
  801396:	c3                   	retq   

0000000000801397 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801397:	55                   	push   %rbp
  801398:	48 89 e5             	mov    %rsp,%rbp
  80139b:	48 83 ec 18          	sub    $0x18,%rsp
  80139f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013a3:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013a6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013aa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013af:	75 06                	jne    8013b7 <memset+0x20>
		return v;
  8013b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013b5:	eb 69                	jmp    801420 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bb:	83 e0 03             	and    $0x3,%eax
  8013be:	48 85 c0             	test   %rax,%rax
  8013c1:	75 48                	jne    80140b <memset+0x74>
  8013c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	48 85 c0             	test   %rax,%rax
  8013cd:	75 3c                	jne    80140b <memset+0x74>
		c &= 0xFF;
  8013cf:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 e2 18             	shl    $0x18,%edx
  8013de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e1:	c1 e0 10             	shl    $0x10,%eax
  8013e4:	09 c2                	or     %eax,%edx
  8013e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013e9:	c1 e0 08             	shl    $0x8,%eax
  8013ec:	09 d0                	or     %edx,%eax
  8013ee:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 89 c1             	mov    %rax,%rcx
  8013f8:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013fc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801400:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801403:	48 89 d7             	mov    %rdx,%rdi
  801406:	fc                   	cld    
  801407:	f3 ab                	rep stos %eax,%es:(%rdi)
  801409:	eb 11                	jmp    80141c <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80140b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801412:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801416:	48 89 d7             	mov    %rdx,%rdi
  801419:	fc                   	cld    
  80141a:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801420:	c9                   	leaveq 
  801421:	c3                   	retq   

0000000000801422 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801422:	55                   	push   %rbp
  801423:	48 89 e5             	mov    %rsp,%rbp
  801426:	48 83 ec 28          	sub    $0x28,%rsp
  80142a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801432:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801436:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80143e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801442:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144e:	0f 83 88 00 00 00    	jae    8014dc <memmove+0xba>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145c:	48 01 d0             	add    %rdx,%rax
  80145f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801463:	76 77                	jbe    8014dc <memmove+0xba>
		s += n;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80146d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801471:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	48 85 c0             	test   %rax,%rax
  80147f:	75 3b                	jne    8014bc <memmove+0x9a>
  801481:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801485:	83 e0 03             	and    $0x3,%eax
  801488:	48 85 c0             	test   %rax,%rax
  80148b:	75 2f                	jne    8014bc <memmove+0x9a>
  80148d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 23                	jne    8014bc <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	48 83 e8 04          	sub    $0x4,%rax
  8014a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a5:	48 83 ea 04          	sub    $0x4,%rdx
  8014a9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014ad:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014b1:	48 89 c7             	mov    %rax,%rdi
  8014b4:	48 89 d6             	mov    %rdx,%rsi
  8014b7:	fd                   	std    
  8014b8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014ba:	eb 1d                	jmp    8014d9 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c8:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d0:	48 89 d7             	mov    %rdx,%rdi
  8014d3:	48 89 c1             	mov    %rax,%rcx
  8014d6:	fd                   	std    
  8014d7:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014d9:	fc                   	cld    
  8014da:	eb 57                	jmp    801533 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e0:	83 e0 03             	and    $0x3,%eax
  8014e3:	48 85 c0             	test   %rax,%rax
  8014e6:	75 36                	jne    80151e <memmove+0xfc>
  8014e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	48 85 c0             	test   %rax,%rax
  8014f2:	75 2a                	jne    80151e <memmove+0xfc>
  8014f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f8:	83 e0 03             	and    $0x3,%eax
  8014fb:	48 85 c0             	test   %rax,%rax
  8014fe:	75 1e                	jne    80151e <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801500:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801504:	48 89 c1             	mov    %rax,%rcx
  801507:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80150b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 89 d6             	mov    %rdx,%rsi
  801519:	fc                   	cld    
  80151a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80151c:	eb 15                	jmp    801533 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801526:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80152a:	48 89 c7             	mov    %rax,%rdi
  80152d:	48 89 d6             	mov    %rdx,%rsi
  801530:	fc                   	cld    
  801531:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 18          	sub    $0x18,%rsp
  801541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801545:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801549:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80154d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801551:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801555:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801559:	48 89 ce             	mov    %rcx,%rsi
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
}
  80156b:	c9                   	leaveq 
  80156c:	c3                   	retq   

000000000080156d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80156d:	55                   	push   %rbp
  80156e:	48 89 e5             	mov    %rsp,%rbp
  801571:	48 83 ec 28          	sub    $0x28,%rsp
  801575:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801579:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80157d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801585:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801589:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80158d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801591:	eb 38                	jmp    8015cb <memcmp+0x5e>
		if (*s1 != *s2)
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 10             	movzbl (%rax),%edx
  80159a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	38 c2                	cmp    %al,%dl
  8015a3:	74 1c                	je     8015c1 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8015a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a9:	0f b6 00             	movzbl (%rax),%eax
  8015ac:	0f b6 d0             	movzbl %al,%edx
  8015af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 c0             	movzbl %al,%eax
  8015b9:	89 d1                	mov    %edx,%ecx
  8015bb:	29 c1                	sub    %eax,%ecx
  8015bd:	89 c8                	mov    %ecx,%eax
  8015bf:	eb 20                	jmp    8015e1 <memcmp+0x74>
		s1++, s2++;
  8015c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015cb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015d0:	0f 95 c0             	setne  %al
  8015d3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015d8:	84 c0                	test   %al,%al
  8015da:	75 b7                	jne    801593 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e1:	c9                   	leaveq 
  8015e2:	c3                   	retq   

00000000008015e3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e3:	55                   	push   %rbp
  8015e4:	48 89 e5             	mov    %rsp,%rbp
  8015e7:	48 83 ec 28          	sub    $0x28,%rsp
  8015eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015ef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015fe:	48 01 d0             	add    %rdx,%rax
  801601:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801605:	eb 13                	jmp    80161a <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160b:	0f b6 10             	movzbl (%rax),%edx
  80160e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801611:	38 c2                	cmp    %al,%dl
  801613:	74 11                	je     801626 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801615:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80161a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80161e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801622:	72 e3                	jb     801607 <memfind+0x24>
  801624:	eb 01                	jmp    801627 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801626:	90                   	nop
	return (void *) s;
  801627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80162b:	c9                   	leaveq 
  80162c:	c3                   	retq   

000000000080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	48 83 ec 38          	sub    $0x38,%rsp
  801635:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801639:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80163d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801640:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801647:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80164e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164f:	eb 05                	jmp    801656 <strtol+0x29>
		s++;
  801651:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801656:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165a:	0f b6 00             	movzbl (%rax),%eax
  80165d:	3c 20                	cmp    $0x20,%al
  80165f:	74 f0                	je     801651 <strtol+0x24>
  801661:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801665:	0f b6 00             	movzbl (%rax),%eax
  801668:	3c 09                	cmp    $0x9,%al
  80166a:	74 e5                	je     801651 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80166c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801670:	0f b6 00             	movzbl (%rax),%eax
  801673:	3c 2b                	cmp    $0x2b,%al
  801675:	75 07                	jne    80167e <strtol+0x51>
		s++;
  801677:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80167c:	eb 17                	jmp    801695 <strtol+0x68>
	else if (*s == '-')
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	0f b6 00             	movzbl (%rax),%eax
  801685:	3c 2d                	cmp    $0x2d,%al
  801687:	75 0c                	jne    801695 <strtol+0x68>
		s++, neg = 1;
  801689:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801695:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801699:	74 06                	je     8016a1 <strtol+0x74>
  80169b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80169f:	75 28                	jne    8016c9 <strtol+0x9c>
  8016a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	3c 30                	cmp    $0x30,%al
  8016aa:	75 1d                	jne    8016c9 <strtol+0x9c>
  8016ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b0:	48 83 c0 01          	add    $0x1,%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	3c 78                	cmp    $0x78,%al
  8016b9:	75 0e                	jne    8016c9 <strtol+0x9c>
		s += 2, base = 16;
  8016bb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016c0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016c7:	eb 2c                	jmp    8016f5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016cd:	75 19                	jne    8016e8 <strtol+0xbb>
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	0f b6 00             	movzbl (%rax),%eax
  8016d6:	3c 30                	cmp    $0x30,%al
  8016d8:	75 0e                	jne    8016e8 <strtol+0xbb>
		s++, base = 8;
  8016da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016df:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016e6:	eb 0d                	jmp    8016f5 <strtol+0xc8>
	else if (base == 0)
  8016e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016ec:	75 07                	jne    8016f5 <strtol+0xc8>
		base = 10;
  8016ee:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f9:	0f b6 00             	movzbl (%rax),%eax
  8016fc:	3c 2f                	cmp    $0x2f,%al
  8016fe:	7e 1d                	jle    80171d <strtol+0xf0>
  801700:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801704:	0f b6 00             	movzbl (%rax),%eax
  801707:	3c 39                	cmp    $0x39,%al
  801709:	7f 12                	jg     80171d <strtol+0xf0>
			dig = *s - '0';
  80170b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170f:	0f b6 00             	movzbl (%rax),%eax
  801712:	0f be c0             	movsbl %al,%eax
  801715:	83 e8 30             	sub    $0x30,%eax
  801718:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171b:	eb 4e                	jmp    80176b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80171d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801721:	0f b6 00             	movzbl (%rax),%eax
  801724:	3c 60                	cmp    $0x60,%al
  801726:	7e 1d                	jle    801745 <strtol+0x118>
  801728:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	3c 7a                	cmp    $0x7a,%al
  801731:	7f 12                	jg     801745 <strtol+0x118>
			dig = *s - 'a' + 10;
  801733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801737:	0f b6 00             	movzbl (%rax),%eax
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	83 e8 57             	sub    $0x57,%eax
  801740:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801743:	eb 26                	jmp    80176b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	0f b6 00             	movzbl (%rax),%eax
  80174c:	3c 40                	cmp    $0x40,%al
  80174e:	7e 47                	jle    801797 <strtol+0x16a>
  801750:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801754:	0f b6 00             	movzbl (%rax),%eax
  801757:	3c 5a                	cmp    $0x5a,%al
  801759:	7f 3c                	jg     801797 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	0f b6 00             	movzbl (%rax),%eax
  801762:	0f be c0             	movsbl %al,%eax
  801765:	83 e8 37             	sub    $0x37,%eax
  801768:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80176b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80176e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801771:	7d 23                	jge    801796 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801773:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801778:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80177b:	48 98                	cltq   
  80177d:	48 89 c2             	mov    %rax,%rdx
  801780:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801785:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801788:	48 98                	cltq   
  80178a:	48 01 d0             	add    %rdx,%rax
  80178d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801791:	e9 5f ff ff ff       	jmpq   8016f5 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801796:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801797:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80179c:	74 0b                	je     8017a9 <strtol+0x17c>
		*endptr = (char *) s;
  80179e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017a2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017a6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ad:	74 09                	je     8017b8 <strtol+0x18b>
  8017af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b3:	48 f7 d8             	neg    %rax
  8017b6:	eb 04                	jmp    8017bc <strtol+0x18f>
  8017b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <strstr>:

char * strstr(const char *in, const char *str)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 30          	sub    $0x30,%rsp
  8017c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8017ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017d2:	0f b6 00             	movzbl (%rax),%eax
  8017d5:	88 45 ff             	mov    %al,-0x1(%rbp)
  8017d8:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8017dd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017e1:	75 06                	jne    8017e9 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8017e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e7:	eb 68                	jmp    801851 <strstr+0x93>

    len = strlen(str);
  8017e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017ed:	48 89 c7             	mov    %rax,%rdi
  8017f0:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
  8017fc:	48 98                	cltq   
  8017fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801806:	0f b6 00             	movzbl (%rax),%eax
  801809:	88 45 ef             	mov    %al,-0x11(%rbp)
  80180c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801811:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801815:	75 07                	jne    80181e <strstr+0x60>
                return (char *) 0;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	eb 33                	jmp    801851 <strstr+0x93>
        } while (sc != c);
  80181e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801822:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801825:	75 db                	jne    801802 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801827:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80182b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	48 89 ce             	mov    %rcx,%rsi
  801836:	48 89 c7             	mov    %rax,%rdi
  801839:	48 b8 b0 12 80 00 00 	movabs $0x8012b0,%rax
  801840:	00 00 00 
  801843:	ff d0                	callq  *%rax
  801845:	85 c0                	test   %eax,%eax
  801847:	75 b9                	jne    801802 <strstr+0x44>

    return (char *) (in - 1);
  801849:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80184d:	48 83 e8 01          	sub    $0x1,%rax
}
  801851:	c9                   	leaveq 
  801852:	c3                   	retq   
	...

0000000000801854 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	53                   	push   %rbx
  801859:	48 83 ec 58          	sub    $0x58,%rsp
  80185d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801860:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801863:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801867:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80186b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80186f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801873:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801876:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801879:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80187d:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801881:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801885:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801889:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80188d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801890:	4c 89 c3             	mov    %r8,%rbx
  801893:	cd 30                	int    $0x30
  801895:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801899:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  80189d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018a5:	74 3e                	je     8018e5 <syscall+0x91>
  8018a7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ac:	7e 37                	jle    8018e5 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018b5:	49 89 d0             	mov    %rdx,%r8
  8018b8:	89 c1                	mov    %eax,%ecx
  8018ba:	48 ba 80 4f 80 00 00 	movabs $0x804f80,%rdx
  8018c1:	00 00 00 
  8018c4:	be 23 00 00 00       	mov    $0x23,%esi
  8018c9:	48 bf 9d 4f 80 00 00 	movabs $0x804f9d,%rdi
  8018d0:	00 00 00 
  8018d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d8:	49 b9 08 03 80 00 00 	movabs $0x800308,%r9
  8018df:	00 00 00 
  8018e2:	41 ff d1             	callq  *%r9

	return ret;
  8018e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018e9:	48 83 c4 58          	add    $0x58,%rsp
  8018ed:	5b                   	pop    %rbx
  8018ee:	5d                   	pop    %rbp
  8018ef:	c3                   	retq   

00000000008018f0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 20          	sub    $0x20,%rsp
  8018f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801904:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801908:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80190f:	00 
  801910:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801916:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80191c:	48 89 d1             	mov    %rdx,%rcx
  80191f:	48 89 c2             	mov    %rax,%rdx
  801922:	be 00 00 00 00       	mov    $0x0,%esi
  801927:	bf 00 00 00 00       	mov    $0x0,%edi
  80192c:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801933:	00 00 00 
  801936:	ff d0                	callq  *%rax
}
  801938:	c9                   	leaveq 
  801939:	c3                   	retq   

000000000080193a <sys_cgetc>:

int
sys_cgetc(void)
{
  80193a:	55                   	push   %rbp
  80193b:	48 89 e5             	mov    %rsp,%rbp
  80193e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801942:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801949:	00 
  80194a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801950:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801956:	b9 00 00 00 00       	mov    $0x0,%ecx
  80195b:	ba 00 00 00 00       	mov    $0x0,%edx
  801960:	be 00 00 00 00       	mov    $0x0,%esi
  801965:	bf 01 00 00 00       	mov    $0x1,%edi
  80196a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801971:	00 00 00 
  801974:	ff d0                	callq  *%rax
}
  801976:	c9                   	leaveq 
  801977:	c3                   	retq   

0000000000801978 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801978:	55                   	push   %rbp
  801979:	48 89 e5             	mov    %rsp,%rbp
  80197c:	48 83 ec 20          	sub    $0x20,%rsp
  801980:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801983:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801986:	48 98                	cltq   
  801988:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80198f:	00 
  801990:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801996:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80199c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a1:	48 89 c2             	mov    %rax,%rdx
  8019a4:	be 01 00 00 00       	mov    $0x1,%esi
  8019a9:	bf 03 00 00 00       	mov    $0x3,%edi
  8019ae:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
}
  8019ba:	c9                   	leaveq 
  8019bb:	c3                   	retq   

00000000008019bc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019bc:	55                   	push   %rbp
  8019bd:	48 89 e5             	mov    %rsp,%rbp
  8019c0:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019c4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cb:	00 
  8019cc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e2:	be 00 00 00 00       	mov    $0x0,%esi
  8019e7:	bf 02 00 00 00       	mov    $0x2,%edi
  8019ec:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  8019f3:	00 00 00 
  8019f6:	ff d0                	callq  *%rax
}
  8019f8:	c9                   	leaveq 
  8019f9:	c3                   	retq   

00000000008019fa <sys_yield>:

void
sys_yield(void)
{
  8019fa:	55                   	push   %rbp
  8019fb:	48 89 e5             	mov    %rsp,%rbp
  8019fe:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a09:	00 
  801a0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a16:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	be 00 00 00 00       	mov    $0x0,%esi
  801a25:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a2a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801a31:	00 00 00 
  801a34:	ff d0                	callq  *%rax
}
  801a36:	c9                   	leaveq 
  801a37:	c3                   	retq   

0000000000801a38 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a38:	55                   	push   %rbp
  801a39:	48 89 e5             	mov    %rsp,%rbp
  801a3c:	48 83 ec 20          	sub    $0x20,%rsp
  801a40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a47:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a4d:	48 63 c8             	movslq %eax,%rcx
  801a50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a57:	48 98                	cltq   
  801a59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a60:	00 
  801a61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a67:	49 89 c8             	mov    %rcx,%r8
  801a6a:	48 89 d1             	mov    %rdx,%rcx
  801a6d:	48 89 c2             	mov    %rax,%rdx
  801a70:	be 01 00 00 00       	mov    $0x1,%esi
  801a75:	bf 04 00 00 00       	mov    $0x4,%edi
  801a7a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801a81:	00 00 00 
  801a84:	ff d0                	callq  *%rax
}
  801a86:	c9                   	leaveq 
  801a87:	c3                   	retq   

0000000000801a88 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a88:	55                   	push   %rbp
  801a89:	48 89 e5             	mov    %rsp,%rbp
  801a8c:	48 83 ec 30          	sub    $0x30,%rsp
  801a90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a97:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a9a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a9e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801aa2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801aa5:	48 63 c8             	movslq %eax,%rcx
  801aa8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aaf:	48 63 f0             	movslq %eax,%rsi
  801ab2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab9:	48 98                	cltq   
  801abb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801abf:	49 89 f9             	mov    %rdi,%r9
  801ac2:	49 89 f0             	mov    %rsi,%r8
  801ac5:	48 89 d1             	mov    %rdx,%rcx
  801ac8:	48 89 c2             	mov    %rax,%rdx
  801acb:	be 01 00 00 00       	mov    $0x1,%esi
  801ad0:	bf 05 00 00 00       	mov    $0x5,%edi
  801ad5:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801adc:	00 00 00 
  801adf:	ff d0                	callq  *%rax
}
  801ae1:	c9                   	leaveq 
  801ae2:	c3                   	retq   

0000000000801ae3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ae3:	55                   	push   %rbp
  801ae4:	48 89 e5             	mov    %rsp,%rbp
  801ae7:	48 83 ec 20          	sub    $0x20,%rsp
  801aeb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801aee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801af2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af9:	48 98                	cltq   
  801afb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b02:	00 
  801b03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0f:	48 89 d1             	mov    %rdx,%rcx
  801b12:	48 89 c2             	mov    %rax,%rdx
  801b15:	be 01 00 00 00       	mov    $0x1,%esi
  801b1a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b1f:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801b26:	00 00 00 
  801b29:	ff d0                	callq  *%rax
}
  801b2b:	c9                   	leaveq 
  801b2c:	c3                   	retq   

0000000000801b2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b2d:	55                   	push   %rbp
  801b2e:	48 89 e5             	mov    %rsp,%rbp
  801b31:	48 83 ec 20          	sub    $0x20,%rsp
  801b35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b38:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b3b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3e:	48 63 d0             	movslq %eax,%rdx
  801b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b44:	48 98                	cltq   
  801b46:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b4d:	00 
  801b4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5a:	48 89 d1             	mov    %rdx,%rcx
  801b5d:	48 89 c2             	mov    %rax,%rdx
  801b60:	be 01 00 00 00       	mov    $0x1,%esi
  801b65:	bf 08 00 00 00       	mov    $0x8,%edi
  801b6a:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801b71:	00 00 00 
  801b74:	ff d0                	callq  *%rax
}
  801b76:	c9                   	leaveq 
  801b77:	c3                   	retq   

0000000000801b78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b78:	55                   	push   %rbp
  801b79:	48 89 e5             	mov    %rsp,%rbp
  801b7c:	48 83 ec 20          	sub    $0x20,%rsp
  801b80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8e:	48 98                	cltq   
  801b90:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b97:	00 
  801b98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba4:	48 89 d1             	mov    %rdx,%rcx
  801ba7:	48 89 c2             	mov    %rax,%rdx
  801baa:	be 01 00 00 00       	mov    $0x1,%esi
  801baf:	bf 09 00 00 00       	mov    $0x9,%edi
  801bb4:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801bbb:	00 00 00 
  801bbe:	ff d0                	callq  *%rax
}
  801bc0:	c9                   	leaveq 
  801bc1:	c3                   	retq   

0000000000801bc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801bc2:	55                   	push   %rbp
  801bc3:	48 89 e5             	mov    %rsp,%rbp
  801bc6:	48 83 ec 20          	sub    $0x20,%rsp
  801bca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd8:	48 98                	cltq   
  801bda:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801be1:	00 
  801be2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801be8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bee:	48 89 d1             	mov    %rdx,%rcx
  801bf1:	48 89 c2             	mov    %rax,%rdx
  801bf4:	be 01 00 00 00       	mov    $0x1,%esi
  801bf9:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bfe:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
}
  801c0a:	c9                   	leaveq 
  801c0b:	c3                   	retq   

0000000000801c0c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c0c:	55                   	push   %rbp
  801c0d:	48 89 e5             	mov    %rsp,%rbp
  801c10:	48 83 ec 30          	sub    $0x30,%rsp
  801c14:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c17:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c1b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c1f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c25:	48 63 f0             	movslq %eax,%rsi
  801c28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2f:	48 98                	cltq   
  801c31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c35:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c3c:	00 
  801c3d:	49 89 f1             	mov    %rsi,%r9
  801c40:	49 89 c8             	mov    %rcx,%r8
  801c43:	48 89 d1             	mov    %rdx,%rcx
  801c46:	48 89 c2             	mov    %rax,%rdx
  801c49:	be 00 00 00 00       	mov    $0x0,%esi
  801c4e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c53:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
}
  801c5f:	c9                   	leaveq 
  801c60:	c3                   	retq   

0000000000801c61 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c61:	55                   	push   %rbp
  801c62:	48 89 e5             	mov    %rsp,%rbp
  801c65:	48 83 ec 20          	sub    $0x20,%rsp
  801c69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c78:	00 
  801c79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c85:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8a:	48 89 c2             	mov    %rax,%rdx
  801c8d:	be 01 00 00 00       	mov    $0x1,%esi
  801c92:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c97:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801cad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb4:	00 
  801cb5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	be 00 00 00 00       	mov    $0x0,%esi
  801cd0:	bf 0e 00 00 00       	mov    $0xe,%edi
  801cd5:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
}
  801ce1:	c9                   	leaveq 
  801ce2:	c3                   	retq   

0000000000801ce3 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801ce3:	55                   	push   %rbp
  801ce4:	48 89 e5             	mov    %rsp,%rbp
  801ce7:	48 83 ec 20          	sub    $0x20,%rsp
  801ceb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801cf3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cfb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d02:	00 
  801d03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d0f:	48 89 d1             	mov    %rdx,%rcx
  801d12:	48 89 c2             	mov    %rax,%rdx
  801d15:	be 00 00 00 00       	mov    $0x0,%esi
  801d1a:	bf 0f 00 00 00       	mov    $0xf,%edi
  801d1f:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax
}
  801d2b:	c9                   	leaveq 
  801d2c:	c3                   	retq   

0000000000801d2d <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801d2d:	55                   	push   %rbp
  801d2e:	48 89 e5             	mov    %rsp,%rbp
  801d31:	48 83 ec 20          	sub    $0x20,%rsp
  801d35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801d3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d4c:	00 
  801d4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d59:	48 89 d1             	mov    %rdx,%rcx
  801d5c:	48 89 c2             	mov    %rax,%rdx
  801d5f:	be 00 00 00 00       	mov    $0x0,%esi
  801d64:	bf 10 00 00 00       	mov    $0x10,%edi
  801d69:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801d70:	00 00 00 
  801d73:	ff d0                	callq  *%rax
}
  801d75:	c9                   	leaveq 
  801d76:	c3                   	retq   
	...

0000000000801d78 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801d78:	55                   	push   %rbp
  801d79:	48 89 e5             	mov    %rsp,%rbp
  801d7c:	48 83 ec 08          	sub    $0x8,%rsp
  801d80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d88:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801d8f:	ff ff ff 
  801d92:	48 01 d0             	add    %rdx,%rax
  801d95:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801d99:	c9                   	leaveq 
  801d9a:	c3                   	retq   

0000000000801d9b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801d9b:	55                   	push   %rbp
  801d9c:	48 89 e5             	mov    %rsp,%rbp
  801d9f:	48 83 ec 08          	sub    $0x8,%rsp
  801da3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801da7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dab:	48 89 c7             	mov    %rax,%rdi
  801dae:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  801db5:	00 00 00 
  801db8:	ff d0                	callq  *%rax
  801dba:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801dc0:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801dc4:	c9                   	leaveq 
  801dc5:	c3                   	retq   

0000000000801dc6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dc6:	55                   	push   %rbp
  801dc7:	48 89 e5             	mov    %rsp,%rbp
  801dca:	48 83 ec 18          	sub    $0x18,%rsp
  801dce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801dd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801dd9:	eb 6b                	jmp    801e46 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dde:	48 98                	cltq   
  801de0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801de6:	48 c1 e0 0c          	shl    $0xc,%rax
  801dea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801df2:	48 89 c2             	mov    %rax,%rdx
  801df5:	48 c1 ea 15          	shr    $0x15,%rdx
  801df9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e00:	01 00 00 
  801e03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e07:	83 e0 01             	and    $0x1,%eax
  801e0a:	48 85 c0             	test   %rax,%rax
  801e0d:	74 21                	je     801e30 <fd_alloc+0x6a>
  801e0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e13:	48 89 c2             	mov    %rax,%rdx
  801e16:	48 c1 ea 0c          	shr    $0xc,%rdx
  801e1a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e21:	01 00 00 
  801e24:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e28:	83 e0 01             	and    $0x1,%eax
  801e2b:	48 85 c0             	test   %rax,%rax
  801e2e:	75 12                	jne    801e42 <fd_alloc+0x7c>
			*fd_store = fd;
  801e30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e38:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e40:	eb 1a                	jmp    801e5c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e42:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e46:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e4a:	7e 8f                	jle    801ddb <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e50:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801e57:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801e5c:	c9                   	leaveq 
  801e5d:	c3                   	retq   

0000000000801e5e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e5e:	55                   	push   %rbp
  801e5f:	48 89 e5             	mov    %rsp,%rbp
  801e62:	48 83 ec 20          	sub    $0x20,%rsp
  801e66:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801e71:	78 06                	js     801e79 <fd_lookup+0x1b>
  801e73:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801e77:	7e 07                	jle    801e80 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e7e:	eb 6c                	jmp    801eec <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801e80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e83:	48 98                	cltq   
  801e85:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e8b:	48 c1 e0 0c          	shl    $0xc,%rax
  801e8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e97:	48 89 c2             	mov    %rax,%rdx
  801e9a:	48 c1 ea 15          	shr    $0x15,%rdx
  801e9e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ea5:	01 00 00 
  801ea8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eac:	83 e0 01             	and    $0x1,%eax
  801eaf:	48 85 c0             	test   %rax,%rax
  801eb2:	74 21                	je     801ed5 <fd_lookup+0x77>
  801eb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eb8:	48 89 c2             	mov    %rax,%rdx
  801ebb:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ebf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec6:	01 00 00 
  801ec9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecd:	83 e0 01             	and    $0x1,%eax
  801ed0:	48 85 c0             	test   %rax,%rax
  801ed3:	75 07                	jne    801edc <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ed5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801eda:	eb 10                	jmp    801eec <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801edc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ee0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ee4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eec:	c9                   	leaveq 
  801eed:	c3                   	retq   

0000000000801eee <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eee:	55                   	push   %rbp
  801eef:	48 89 e5             	mov    %rsp,%rbp
  801ef2:	48 83 ec 30          	sub    $0x30,%rsp
  801ef6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801efa:	89 f0                	mov    %esi,%eax
  801efc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f03:	48 89 c7             	mov    %rax,%rdi
  801f06:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  801f0d:	00 00 00 
  801f10:	ff d0                	callq  *%rax
  801f12:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f16:	48 89 d6             	mov    %rdx,%rsi
  801f19:	89 c7                	mov    %eax,%edi
  801f1b:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  801f22:	00 00 00 
  801f25:	ff d0                	callq  *%rax
  801f27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f2e:	78 0a                	js     801f3a <fd_close+0x4c>
	    || fd != fd2)
  801f30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f34:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f38:	74 12                	je     801f4c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801f3a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f3e:	74 05                	je     801f45 <fd_close+0x57>
  801f40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f43:	eb 05                	jmp    801f4a <fd_close+0x5c>
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	eb 69                	jmp    801fb5 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f50:	8b 00                	mov    (%rax),%eax
  801f52:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f56:	48 89 d6             	mov    %rdx,%rsi
  801f59:	89 c7                	mov    %eax,%edi
  801f5b:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  801f62:	00 00 00 
  801f65:	ff d0                	callq  *%rax
  801f67:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f6a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f6e:	78 2a                	js     801f9a <fd_close+0xac>
		if (dev->dev_close)
  801f70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f74:	48 8b 40 20          	mov    0x20(%rax),%rax
  801f78:	48 85 c0             	test   %rax,%rax
  801f7b:	74 16                	je     801f93 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801f7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f81:	48 8b 50 20          	mov    0x20(%rax),%rdx
  801f85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f89:	48 89 c7             	mov    %rax,%rdi
  801f8c:	ff d2                	callq  *%rdx
  801f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f91:	eb 07                	jmp    801f9a <fd_close+0xac>
		else
			r = 0;
  801f93:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f9e:	48 89 c6             	mov    %rax,%rsi
  801fa1:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa6:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
	return r;
  801fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801fb5:	c9                   	leaveq 
  801fb6:	c3                   	retq   

0000000000801fb7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fb7:	55                   	push   %rbp
  801fb8:	48 89 e5             	mov    %rsp,%rbp
  801fbb:	48 83 ec 20          	sub    $0x20,%rsp
  801fbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801fc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fcd:	eb 41                	jmp    802010 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801fcf:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801fd6:	00 00 00 
  801fd9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fdc:	48 63 d2             	movslq %edx,%rdx
  801fdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fe3:	8b 00                	mov    (%rax),%eax
  801fe5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801fe8:	75 22                	jne    80200c <dev_lookup+0x55>
			*dev = devtab[i];
  801fea:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  801ff1:	00 00 00 
  801ff4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff7:	48 63 d2             	movslq %edx,%rdx
  801ffa:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802002:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
  80200a:	eb 60                	jmp    80206c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80200c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802010:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802017:	00 00 00 
  80201a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80201d:	48 63 d2             	movslq %edx,%rdx
  802020:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802024:	48 85 c0             	test   %rax,%rax
  802027:	75 a6                	jne    801fcf <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802029:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  802030:	00 00 00 
  802033:	48 8b 00             	mov    (%rax),%rax
  802036:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80203c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80203f:	89 c6                	mov    %eax,%esi
  802041:	48 bf b0 4f 80 00 00 	movabs $0x804fb0,%rdi
  802048:	00 00 00 
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	48 b9 43 05 80 00 00 	movabs $0x800543,%rcx
  802057:	00 00 00 
  80205a:	ff d1                	callq  *%rcx
	*dev = 0;
  80205c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802060:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80206c:	c9                   	leaveq 
  80206d:	c3                   	retq   

000000000080206e <close>:

int
close(int fdnum)
{
  80206e:	55                   	push   %rbp
  80206f:	48 89 e5             	mov    %rsp,%rbp
  802072:	48 83 ec 20          	sub    $0x20,%rsp
  802076:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802079:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80207d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802080:	48 89 d6             	mov    %rdx,%rsi
  802083:	89 c7                	mov    %eax,%edi
  802085:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  80208c:	00 00 00 
  80208f:	ff d0                	callq  *%rax
  802091:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802094:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802098:	79 05                	jns    80209f <close+0x31>
		return r;
  80209a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80209d:	eb 18                	jmp    8020b7 <close+0x49>
	else
		return fd_close(fd, 1);
  80209f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a3:	be 01 00 00 00       	mov    $0x1,%esi
  8020a8:	48 89 c7             	mov    %rax,%rdi
  8020ab:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
}
  8020b7:	c9                   	leaveq 
  8020b8:	c3                   	retq   

00000000008020b9 <close_all>:

void
close_all(void)
{
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8020c8:	eb 15                	jmp    8020df <close_all+0x26>
		close(i);
  8020ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020cd:	89 c7                	mov    %eax,%edi
  8020cf:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8020d6:	00 00 00 
  8020d9:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020df:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020e3:	7e e5                	jle    8020ca <close_all+0x11>
		close(i);
}
  8020e5:	c9                   	leaveq 
  8020e6:	c3                   	retq   

00000000008020e7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020e7:	55                   	push   %rbp
  8020e8:	48 89 e5             	mov    %rsp,%rbp
  8020eb:	48 83 ec 40          	sub    $0x40,%rsp
  8020ef:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8020f2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020f5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8020f9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020fc:	48 89 d6             	mov    %rdx,%rsi
  8020ff:	89 c7                	mov    %eax,%edi
  802101:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  802108:	00 00 00 
  80210b:	ff d0                	callq  *%rax
  80210d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802110:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802114:	79 08                	jns    80211e <dup+0x37>
		return r;
  802116:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802119:	e9 70 01 00 00       	jmpq   80228e <dup+0x1a7>
	close(newfdnum);
  80211e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802121:	89 c7                	mov    %eax,%edi
  802123:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  80212a:	00 00 00 
  80212d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80212f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802132:	48 98                	cltq   
  802134:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80213a:	48 c1 e0 0c          	shl    $0xc,%rax
  80213e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802142:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802146:	48 89 c7             	mov    %rax,%rdi
  802149:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  802150:	00 00 00 
  802153:	ff d0                	callq  *%rax
  802155:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802159:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80215d:	48 89 c7             	mov    %rax,%rdi
  802160:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  802167:	00 00 00 
  80216a:	ff d0                	callq  *%rax
  80216c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802174:	48 89 c2             	mov    %rax,%rdx
  802177:	48 c1 ea 15          	shr    $0x15,%rdx
  80217b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802182:	01 00 00 
  802185:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802189:	83 e0 01             	and    $0x1,%eax
  80218c:	84 c0                	test   %al,%al
  80218e:	74 71                	je     802201 <dup+0x11a>
  802190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802194:	48 89 c2             	mov    %rax,%rdx
  802197:	48 c1 ea 0c          	shr    $0xc,%rdx
  80219b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021a2:	01 00 00 
  8021a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021a9:	83 e0 01             	and    $0x1,%eax
  8021ac:	84 c0                	test   %al,%al
  8021ae:	74 51                	je     802201 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b4:	48 89 c2             	mov    %rax,%rdx
  8021b7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8021bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c2:	01 00 00 
  8021c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c9:	89 c1                	mov    %eax,%ecx
  8021cb:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8021d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8021d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d9:	41 89 c8             	mov    %ecx,%r8d
  8021dc:	48 89 d1             	mov    %rdx,%rcx
  8021df:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e4:	48 89 c6             	mov    %rax,%rsi
  8021e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ec:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  8021f3:	00 00 00 
  8021f6:	ff d0                	callq  *%rax
  8021f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021ff:	78 56                	js     802257 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802205:	48 89 c2             	mov    %rax,%rdx
  802208:	48 c1 ea 0c          	shr    $0xc,%rdx
  80220c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802213:	01 00 00 
  802216:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80221a:	89 c1                	mov    %eax,%ecx
  80221c:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802226:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80222a:	41 89 c8             	mov    %ecx,%r8d
  80222d:	48 89 d1             	mov    %rdx,%rcx
  802230:	ba 00 00 00 00       	mov    $0x0,%edx
  802235:	48 89 c6             	mov    %rax,%rsi
  802238:	bf 00 00 00 00       	mov    $0x0,%edi
  80223d:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  802244:	00 00 00 
  802247:	ff d0                	callq  *%rax
  802249:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802250:	78 08                	js     80225a <dup+0x173>
		goto err;

	return newfdnum;
  802252:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802255:	eb 37                	jmp    80228e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802257:	90                   	nop
  802258:	eb 01                	jmp    80225b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80225a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80225b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225f:	48 89 c6             	mov    %rax,%rsi
  802262:	bf 00 00 00 00       	mov    $0x0,%edi
  802267:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802273:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802277:	48 89 c6             	mov    %rax,%rsi
  80227a:	bf 00 00 00 00       	mov    $0x0,%edi
  80227f:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  802286:	00 00 00 
  802289:	ff d0                	callq  *%rax
	return r;
  80228b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80228e:	c9                   	leaveq 
  80228f:	c3                   	retq   

0000000000802290 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802290:	55                   	push   %rbp
  802291:	48 89 e5             	mov    %rsp,%rbp
  802294:	48 83 ec 40          	sub    $0x40,%rsp
  802298:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80229b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80229f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022aa:	48 89 d6             	mov    %rdx,%rsi
  8022ad:	89 c7                	mov    %eax,%edi
  8022af:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8022b6:	00 00 00 
  8022b9:	ff d0                	callq  *%rax
  8022bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c2:	78 24                	js     8022e8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c8:	8b 00                	mov    (%rax),%eax
  8022ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022ce:	48 89 d6             	mov    %rdx,%rsi
  8022d1:	89 c7                	mov    %eax,%edi
  8022d3:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  8022da:	00 00 00 
  8022dd:	ff d0                	callq  *%rax
  8022df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e6:	79 05                	jns    8022ed <read+0x5d>
		return r;
  8022e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022eb:	eb 7a                	jmp    802367 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f1:	8b 40 08             	mov    0x8(%rax),%eax
  8022f4:	83 e0 03             	and    $0x3,%eax
  8022f7:	83 f8 01             	cmp    $0x1,%eax
  8022fa:	75 3a                	jne    802336 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8022fc:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  802303:	00 00 00 
  802306:	48 8b 00             	mov    (%rax),%rax
  802309:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80230f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802312:	89 c6                	mov    %eax,%esi
  802314:	48 bf cf 4f 80 00 00 	movabs $0x804fcf,%rdi
  80231b:	00 00 00 
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	48 b9 43 05 80 00 00 	movabs $0x800543,%rcx
  80232a:	00 00 00 
  80232d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80232f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802334:	eb 31                	jmp    802367 <read+0xd7>
	}
	if (!dev->dev_read)
  802336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80233a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80233e:	48 85 c0             	test   %rax,%rax
  802341:	75 07                	jne    80234a <read+0xba>
		return -E_NOT_SUPP;
  802343:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802348:	eb 1d                	jmp    802367 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  80234a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802356:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80235a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80235e:	48 89 ce             	mov    %rcx,%rsi
  802361:	48 89 c7             	mov    %rax,%rdi
  802364:	41 ff d0             	callq  *%r8
}
  802367:	c9                   	leaveq 
  802368:	c3                   	retq   

0000000000802369 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802369:	55                   	push   %rbp
  80236a:	48 89 e5             	mov    %rsp,%rbp
  80236d:	48 83 ec 30          	sub    $0x30,%rsp
  802371:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802374:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802378:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80237c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802383:	eb 46                	jmp    8023cb <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802388:	48 98                	cltq   
  80238a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80238e:	48 29 c2             	sub    %rax,%rdx
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802394:	48 98                	cltq   
  802396:	48 89 c1             	mov    %rax,%rcx
  802399:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  80239d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023a0:	48 89 ce             	mov    %rcx,%rsi
  8023a3:	89 c7                	mov    %eax,%edi
  8023a5:	48 b8 90 22 80 00 00 	movabs $0x802290,%rax
  8023ac:	00 00 00 
  8023af:	ff d0                	callq  *%rax
  8023b1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8023b4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023b8:	79 05                	jns    8023bf <readn+0x56>
			return m;
  8023ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023bd:	eb 1d                	jmp    8023dc <readn+0x73>
		if (m == 0)
  8023bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023c3:	74 13                	je     8023d8 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023c8:	01 45 fc             	add    %eax,-0x4(%rbp)
  8023cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ce:	48 98                	cltq   
  8023d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8023d4:	72 af                	jb     802385 <readn+0x1c>
  8023d6:	eb 01                	jmp    8023d9 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8023d8:	90                   	nop
	}
	return tot;
  8023d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023dc:	c9                   	leaveq 
  8023dd:	c3                   	retq   

00000000008023de <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8023de:	55                   	push   %rbp
  8023df:	48 89 e5             	mov    %rsp,%rbp
  8023e2:	48 83 ec 40          	sub    $0x40,%rsp
  8023e6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8023ed:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023f1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023f5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023f8:	48 89 d6             	mov    %rdx,%rsi
  8023fb:	89 c7                	mov    %eax,%edi
  8023fd:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  802404:	00 00 00 
  802407:	ff d0                	callq  *%rax
  802409:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80240c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802410:	78 24                	js     802436 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802416:	8b 00                	mov    (%rax),%eax
  802418:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80241c:	48 89 d6             	mov    %rdx,%rsi
  80241f:	89 c7                	mov    %eax,%edi
  802421:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  802428:	00 00 00 
  80242b:	ff d0                	callq  *%rax
  80242d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802430:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802434:	79 05                	jns    80243b <write+0x5d>
		return r;
  802436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802439:	eb 79                	jmp    8024b4 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80243b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243f:	8b 40 08             	mov    0x8(%rax),%eax
  802442:	83 e0 03             	and    $0x3,%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	75 3a                	jne    802483 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802449:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  802450:	00 00 00 
  802453:	48 8b 00             	mov    (%rax),%rax
  802456:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80245c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80245f:	89 c6                	mov    %eax,%esi
  802461:	48 bf eb 4f 80 00 00 	movabs $0x804feb,%rdi
  802468:	00 00 00 
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	48 b9 43 05 80 00 00 	movabs $0x800543,%rcx
  802477:	00 00 00 
  80247a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80247c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802481:	eb 31                	jmp    8024b4 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802487:	48 8b 40 18          	mov    0x18(%rax),%rax
  80248b:	48 85 c0             	test   %rax,%rax
  80248e:	75 07                	jne    802497 <write+0xb9>
		return -E_NOT_SUPP;
  802490:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802495:	eb 1d                	jmp    8024b4 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802497:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80249b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80249f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024a7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8024ab:	48 89 ce             	mov    %rcx,%rsi
  8024ae:	48 89 c7             	mov    %rax,%rdi
  8024b1:	41 ff d0             	callq  *%r8
}
  8024b4:	c9                   	leaveq 
  8024b5:	c3                   	retq   

00000000008024b6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8024b6:	55                   	push   %rbp
  8024b7:	48 89 e5             	mov    %rsp,%rbp
  8024ba:	48 83 ec 18          	sub    $0x18,%rsp
  8024be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024c1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024cb:	48 89 d6             	mov    %rdx,%rsi
  8024ce:	89 c7                	mov    %eax,%edi
  8024d0:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8024d7:	00 00 00 
  8024da:	ff d0                	callq  *%rax
  8024dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024e3:	79 05                	jns    8024ea <seek+0x34>
		return r;
  8024e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e8:	eb 0f                	jmp    8024f9 <seek+0x43>
	fd->fd_offset = offset;
  8024ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8024f1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f9:	c9                   	leaveq 
  8024fa:	c3                   	retq   

00000000008024fb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8024fb:	55                   	push   %rbp
  8024fc:	48 89 e5             	mov    %rsp,%rbp
  8024ff:	48 83 ec 30          	sub    $0x30,%rsp
  802503:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802506:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802509:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80250d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802510:	48 89 d6             	mov    %rdx,%rsi
  802513:	89 c7                	mov    %eax,%edi
  802515:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	callq  *%rax
  802521:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802524:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802528:	78 24                	js     80254e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80252a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252e:	8b 00                	mov    (%rax),%eax
  802530:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802534:	48 89 d6             	mov    %rdx,%rsi
  802537:	89 c7                	mov    %eax,%edi
  802539:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
  802545:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802548:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254c:	79 05                	jns    802553 <ftruncate+0x58>
		return r;
  80254e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802551:	eb 72                	jmp    8025c5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802557:	8b 40 08             	mov    0x8(%rax),%eax
  80255a:	83 e0 03             	and    $0x3,%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	75 3a                	jne    80259b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802561:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  802568:	00 00 00 
  80256b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80256e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802574:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802577:	89 c6                	mov    %eax,%esi
  802579:	48 bf 08 50 80 00 00 	movabs $0x805008,%rdi
  802580:	00 00 00 
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	48 b9 43 05 80 00 00 	movabs $0x800543,%rcx
  80258f:	00 00 00 
  802592:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802594:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802599:	eb 2a                	jmp    8025c5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80259b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259f:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025a3:	48 85 c0             	test   %rax,%rax
  8025a6:	75 07                	jne    8025af <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025ad:	eb 16                	jmp    8025c5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b3:	48 8b 48 30          	mov    0x30(%rax),%rcx
  8025b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8025be:	89 d6                	mov    %edx,%esi
  8025c0:	48 89 c7             	mov    %rax,%rdi
  8025c3:	ff d1                	callq  *%rcx
}
  8025c5:	c9                   	leaveq 
  8025c6:	c3                   	retq   

00000000008025c7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8025c7:	55                   	push   %rbp
  8025c8:	48 89 e5             	mov    %rsp,%rbp
  8025cb:	48 83 ec 30          	sub    $0x30,%rsp
  8025cf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8025d6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8025da:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8025dd:	48 89 d6             	mov    %rdx,%rsi
  8025e0:	89 c7                	mov    %eax,%edi
  8025e2:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8025e9:	00 00 00 
  8025ec:	ff d0                	callq  *%rax
  8025ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025f5:	78 24                	js     80261b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8025f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fb:	8b 00                	mov    (%rax),%eax
  8025fd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802601:	48 89 d6             	mov    %rdx,%rsi
  802604:	89 c7                	mov    %eax,%edi
  802606:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
  802612:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802615:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802619:	79 05                	jns    802620 <fstat+0x59>
		return r;
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261e:	eb 5e                	jmp    80267e <fstat+0xb7>
	if (!dev->dev_stat)
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	48 8b 40 28          	mov    0x28(%rax),%rax
  802628:	48 85 c0             	test   %rax,%rax
  80262b:	75 07                	jne    802634 <fstat+0x6d>
		return -E_NOT_SUPP;
  80262d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802632:	eb 4a                	jmp    80267e <fstat+0xb7>
	stat->st_name[0] = 0;
  802634:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802638:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80263b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80263f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802646:	00 00 00 
	stat->st_isdir = 0;
  802649:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80264d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802654:	00 00 00 
	stat->st_dev = dev;
  802657:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80265b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80265f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802666:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80266e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802672:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802676:	48 89 d6             	mov    %rdx,%rsi
  802679:	48 89 c7             	mov    %rax,%rdi
  80267c:	ff d1                	callq  *%rcx
}
  80267e:	c9                   	leaveq 
  80267f:	c3                   	retq   

0000000000802680 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802680:	55                   	push   %rbp
  802681:	48 89 e5             	mov    %rsp,%rbp
  802684:	48 83 ec 20          	sub    $0x20,%rsp
  802688:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80268c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802694:	be 00 00 00 00       	mov    $0x0,%esi
  802699:	48 89 c7             	mov    %rax,%rdi
  80269c:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  8026a3:	00 00 00 
  8026a6:	ff d0                	callq  *%rax
  8026a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026af:	79 05                	jns    8026b6 <stat+0x36>
		return fd;
  8026b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b4:	eb 2f                	jmp    8026e5 <stat+0x65>
	r = fstat(fd, stat);
  8026b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8026ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bd:	48 89 d6             	mov    %rdx,%rsi
  8026c0:	89 c7                	mov    %eax,%edi
  8026c2:	48 b8 c7 25 80 00 00 	movabs $0x8025c7,%rax
  8026c9:	00 00 00 
  8026cc:	ff d0                	callq  *%rax
  8026ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8026d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d4:	89 c7                	mov    %eax,%edi
  8026d6:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  8026dd:	00 00 00 
  8026e0:	ff d0                	callq  *%rax
	return r;
  8026e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8026e5:	c9                   	leaveq 
  8026e6:	c3                   	retq   
	...

00000000008026e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 10          	sub    $0x10,%rsp
  8026f0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026f3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8026f7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8026fe:	00 00 00 
  802701:	8b 00                	mov    (%rax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	75 1d                	jne    802724 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802707:	bf 01 00 00 00       	mov    $0x1,%edi
  80270c:	48 b8 97 48 80 00 00 	movabs $0x804897,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
  802718:	48 ba 20 80 80 00 00 	movabs $0x808020,%rdx
  80271f:	00 00 00 
  802722:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802724:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80272b:	00 00 00 
  80272e:	8b 00                	mov    (%rax),%eax
  802730:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802733:	b9 07 00 00 00       	mov    $0x7,%ecx
  802738:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80273f:	00 00 00 
  802742:	89 c7                	mov    %eax,%edi
  802744:	48 b8 d4 47 80 00 00 	movabs $0x8047d4,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802754:	ba 00 00 00 00       	mov    $0x0,%edx
  802759:	48 89 c6             	mov    %rax,%rsi
  80275c:	bf 00 00 00 00       	mov    $0x0,%edi
  802761:	48 b8 14 47 80 00 00 	movabs $0x804714,%rax
  802768:	00 00 00 
  80276b:	ff d0                	callq  *%rax
}
  80276d:	c9                   	leaveq 
  80276e:	c3                   	retq   

000000000080276f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80276f:	55                   	push   %rbp
  802770:	48 89 e5             	mov    %rsp,%rbp
  802773:	48 83 ec 20          	sub    $0x20,%rsp
  802777:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80277b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80277e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802782:	48 89 c7             	mov    %rax,%rdi
  802785:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
  802791:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802796:	7e 0a                	jle    8027a2 <open+0x33>
                return -E_BAD_PATH;
  802798:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80279d:	e9 a5 00 00 00       	jmpq   802847 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8027a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027a6:	48 89 c7             	mov    %rax,%rdi
  8027a9:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8027b0:	00 00 00 
  8027b3:	ff d0                	callq  *%rax
  8027b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bc:	79 08                	jns    8027c6 <open+0x57>
		return r;
  8027be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c1:	e9 81 00 00 00       	jmpq   802847 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8027c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ca:	48 89 c6             	mov    %rax,%rsi
  8027cd:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8027d4:	00 00 00 
  8027d7:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8027de:	00 00 00 
  8027e1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  8027e3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027ea:	00 00 00 
  8027ed:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8027f0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8027f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027fa:	48 89 c6             	mov    %rax,%rsi
  8027fd:	bf 01 00 00 00       	mov    $0x1,%edi
  802802:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802809:	00 00 00 
  80280c:	ff d0                	callq  *%rax
  80280e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802811:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802815:	79 1d                	jns    802834 <open+0xc5>
	{
		fd_close(fd,0);
  802817:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80281b:	be 00 00 00 00       	mov    $0x0,%esi
  802820:	48 89 c7             	mov    %rax,%rdi
  802823:	48 b8 ee 1e 80 00 00 	movabs $0x801eee,%rax
  80282a:	00 00 00 
  80282d:	ff d0                	callq  *%rax
		return r;
  80282f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802832:	eb 13                	jmp    802847 <open+0xd8>
	}
	return fd2num(fd);
  802834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802838:	48 89 c7             	mov    %rax,%rdi
  80283b:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
	


}
  802847:	c9                   	leaveq 
  802848:	c3                   	retq   

0000000000802849 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802849:	55                   	push   %rbp
  80284a:	48 89 e5             	mov    %rsp,%rbp
  80284d:	48 83 ec 10          	sub    $0x10,%rsp
  802851:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802859:	8b 50 0c             	mov    0xc(%rax),%edx
  80285c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802863:	00 00 00 
  802866:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802868:	be 00 00 00 00       	mov    $0x0,%esi
  80286d:	bf 06 00 00 00       	mov    $0x6,%edi
  802872:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802879:	00 00 00 
  80287c:	ff d0                	callq  *%rax
}
  80287e:	c9                   	leaveq 
  80287f:	c3                   	retq   

0000000000802880 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802880:	55                   	push   %rbp
  802881:	48 89 e5             	mov    %rsp,%rbp
  802884:	48 83 ec 30          	sub    $0x30,%rsp
  802888:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80288c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802890:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802898:	8b 50 0c             	mov    0xc(%rax),%edx
  80289b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028a2:	00 00 00 
  8028a5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028a7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028ae:	00 00 00 
  8028b1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8028b9:	be 00 00 00 00       	mov    $0x0,%esi
  8028be:	bf 03 00 00 00       	mov    $0x3,%edi
  8028c3:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
  8028cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d6:	79 05                	jns    8028dd <devfile_read+0x5d>
	{
		return r;
  8028d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028db:	eb 2c                	jmp    802909 <devfile_read+0x89>
	}
	if(r > 0)
  8028dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e1:	7e 23                	jle    802906 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8028e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e6:	48 63 d0             	movslq %eax,%rdx
  8028e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ed:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8028f4:	00 00 00 
  8028f7:	48 89 c7             	mov    %rax,%rdi
  8028fa:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802901:	00 00 00 
  802904:	ff d0                	callq  *%rax
	return r;
  802906:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802909:	c9                   	leaveq 
  80290a:	c3                   	retq   

000000000080290b <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80290b:	55                   	push   %rbp
  80290c:	48 89 e5             	mov    %rsp,%rbp
  80290f:	48 83 ec 30          	sub    $0x30,%rsp
  802913:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802917:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80291b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  80291f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802923:	8b 50 0c             	mov    0xc(%rax),%edx
  802926:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80292d:	00 00 00 
  802930:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802932:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802939:	00 
  80293a:	76 08                	jbe    802944 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  80293c:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802943:	00 
	fsipcbuf.write.req_n=n;
  802944:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80294b:	00 00 00 
  80294e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802952:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802956:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80295a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295e:	48 89 c6             	mov    %rax,%rsi
  802961:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802968:	00 00 00 
  80296b:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  802972:	00 00 00 
  802975:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802977:	be 00 00 00 00       	mov    $0x0,%esi
  80297c:	bf 04 00 00 00       	mov    $0x4,%edi
  802981:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802988:	00 00 00 
  80298b:	ff d0                	callq  *%rax
  80298d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802990:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802993:	c9                   	leaveq 
  802994:	c3                   	retq   

0000000000802995 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802995:	55                   	push   %rbp
  802996:	48 89 e5             	mov    %rsp,%rbp
  802999:	48 83 ec 10          	sub    $0x10,%rsp
  80299d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8029a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8029a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029a8:	8b 50 0c             	mov    0xc(%rax),%edx
  8029ab:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029b2:	00 00 00 
  8029b5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8029b7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029be:	00 00 00 
  8029c1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029c7:	be 00 00 00 00       	mov    $0x0,%esi
  8029cc:	bf 02 00 00 00       	mov    $0x2,%edi
  8029d1:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8029d8:	00 00 00 
  8029db:	ff d0                	callq  *%rax
}
  8029dd:	c9                   	leaveq 
  8029de:	c3                   	retq   

00000000008029df <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8029df:	55                   	push   %rbp
  8029e0:	48 89 e5             	mov    %rsp,%rbp
  8029e3:	48 83 ec 20          	sub    $0x20,%rsp
  8029e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8029ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8029f6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8029fd:	00 00 00 
  802a00:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802a02:	be 00 00 00 00       	mov    $0x0,%esi
  802a07:	bf 05 00 00 00       	mov    $0x5,%edi
  802a0c:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  802a13:	00 00 00 
  802a16:	ff d0                	callq  *%rax
  802a18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a1f:	79 05                	jns    802a26 <devfile_stat+0x47>
		return r;
  802a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a24:	eb 56                	jmp    802a7c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802a26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802a31:	00 00 00 
  802a34:	48 89 c7             	mov    %rax,%rdi
  802a37:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802a43:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a4a:	00 00 00 
  802a4d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802a53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a57:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802a5d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a64:	00 00 00 
  802a67:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802a6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a71:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7c:	c9                   	leaveq 
  802a7d:	c3                   	retq   
	...

0000000000802a80 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a80:	55                   	push   %rbp
  802a81:	48 89 e5             	mov    %rsp,%rbp
  802a84:	53                   	push   %rbx
  802a85:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  802a8c:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  802a93:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a9a:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  802aa1:	be 00 00 00 00       	mov    $0x0,%esi
  802aa6:	48 89 c7             	mov    %rax,%rdi
  802aa9:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802ab8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802abc:	79 08                	jns    802ac6 <spawn+0x46>
		return r;
  802abe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ac1:	e9 1d 03 00 00       	jmpq   802de3 <spawn+0x363>
	fd = r;
  802ac6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ac9:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802acc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  802ad3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802ad7:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  802ade:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ae1:	ba 00 02 00 00       	mov    $0x200,%edx
  802ae6:	48 89 ce             	mov    %rcx,%rsi
  802ae9:	89 c7                	mov    %eax,%edi
  802aeb:	48 b8 69 23 80 00 00 	movabs $0x802369,%rax
  802af2:	00 00 00 
  802af5:	ff d0                	callq  *%rax
  802af7:	3d 00 02 00 00       	cmp    $0x200,%eax
  802afc:	75 0d                	jne    802b0b <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  802afe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b02:	8b 00                	mov    (%rax),%eax
  802b04:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802b09:	74 43                	je     802b4e <spawn+0xce>
		close(fd);
  802b0b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b0e:	89 c7                	mov    %eax,%edi
  802b10:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802b17:	00 00 00 
  802b1a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b20:	8b 00                	mov    (%rax),%eax
  802b22:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802b27:	89 c6                	mov    %eax,%esi
  802b29:	48 bf 30 50 80 00 00 	movabs $0x805030,%rdi
  802b30:	00 00 00 
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	48 b9 43 05 80 00 00 	movabs $0x800543,%rcx
  802b3f:	00 00 00 
  802b42:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802b44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b49:	e9 95 02 00 00       	jmpq   802de3 <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802b4e:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  802b55:	00 00 00 
  802b58:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  802b5e:	cd 30                	int    $0x30
  802b60:	89 c3                	mov    %eax,%ebx
  802b62:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802b65:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b68:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802b6b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802b6f:	79 08                	jns    802b79 <spawn+0xf9>
		return r;
  802b71:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b74:	e9 6a 02 00 00       	jmpq   802de3 <spawn+0x363>
	child = r;
  802b79:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802b7c:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b7f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802b82:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b87:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802b8e:	00 00 00 
  802b91:	48 63 d0             	movslq %eax,%rdx
  802b94:	48 89 d0             	mov    %rdx,%rax
  802b97:	48 c1 e0 03          	shl    $0x3,%rax
  802b9b:	48 01 d0             	add    %rdx,%rax
  802b9e:	48 c1 e0 05          	shl    $0x5,%rax
  802ba2:	48 01 c8             	add    %rcx,%rax
  802ba5:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802bac:	48 89 c6             	mov    %rax,%rsi
  802baf:	b8 18 00 00 00       	mov    $0x18,%eax
  802bb4:	48 89 d7             	mov    %rdx,%rdi
  802bb7:	48 89 c1             	mov    %rax,%rcx
  802bba:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802bbd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802bc1:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bc5:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802bcc:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  802bd3:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802bda:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  802be1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802be4:	48 89 ce             	mov    %rcx,%rsi
  802be7:	89 c7                	mov    %eax,%edi
  802be9:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802bf8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802bfc:	79 08                	jns    802c06 <spawn+0x186>
		return r;
  802bfe:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802c01:	e9 dd 01 00 00       	jmpq   802de3 <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c0a:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c0e:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  802c15:	48 01 d0             	add    %rdx,%rax
  802c18:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802c23:	eb 7a                	jmp    802c9f <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  802c25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c29:	8b 00                	mov    (%rax),%eax
  802c2b:	83 f8 01             	cmp    $0x1,%eax
  802c2e:	75 65                	jne    802c95 <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  802c30:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802c37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c3b:	8b 40 04             	mov    0x4(%rax),%eax
  802c3e:	83 e0 02             	and    $0x2,%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 04                	je     802c49 <spawn+0x1c9>
			perm |= PTE_W;
  802c45:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802c49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c4d:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c51:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802c54:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c58:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802c5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c60:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802c64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c68:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802c6c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802c6f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802c72:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802c75:	89 3c 24             	mov    %edi,(%rsp)
  802c78:	89 c7                	mov    %eax,%edi
  802c7a:	48 b8 ab 32 80 00 00 	movabs $0x8032ab,%rax
  802c81:	00 00 00 
  802c84:	ff d0                	callq  *%rax
  802c86:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802c89:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802c8d:	0f 88 2a 01 00 00    	js     802dbd <spawn+0x33d>
  802c93:	eb 01                	jmp    802c96 <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  802c95:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c96:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802c9a:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  802c9f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ca3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802ca7:	0f b7 c0             	movzwl %ax,%eax
  802caa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cad:	0f 8f 72 ff ff ff    	jg     802c25 <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802cb3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802cb6:	89 c7                	mov    %eax,%edi
  802cb8:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802cbf:	00 00 00 
  802cc2:	ff d0                	callq  *%rax
	fd = -1;
  802cc4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802ccb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802cce:	89 c7                	mov    %eax,%edi
  802cd0:	48 b8 92 34 80 00 00 	movabs $0x803492,%rax
  802cd7:	00 00 00 
  802cda:	ff d0                	callq  *%rax
  802cdc:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802cdf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802ce3:	79 30                	jns    802d15 <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  802ce5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802ce8:	89 c1                	mov    %eax,%ecx
  802cea:	48 ba 4a 50 80 00 00 	movabs $0x80504a,%rdx
  802cf1:	00 00 00 
  802cf4:	be 82 00 00 00       	mov    $0x82,%esi
  802cf9:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  802d00:	00 00 00 
  802d03:	b8 00 00 00 00       	mov    $0x0,%eax
  802d08:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  802d0f:	00 00 00 
  802d12:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d15:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  802d1c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802d1f:	48 89 d6             	mov    %rdx,%rsi
  802d22:	89 c7                	mov    %eax,%edi
  802d24:	48 b8 78 1b 80 00 00 	movabs $0x801b78,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
  802d30:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802d33:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d37:	79 30                	jns    802d69 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  802d39:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d3c:	89 c1                	mov    %eax,%ecx
  802d3e:	48 ba 6c 50 80 00 00 	movabs $0x80506c,%rdx
  802d45:	00 00 00 
  802d48:	be 85 00 00 00       	mov    $0x85,%esi
  802d4d:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  802d54:	00 00 00 
  802d57:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5c:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  802d63:	00 00 00 
  802d66:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802d69:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802d6c:	be 02 00 00 00       	mov    $0x2,%esi
  802d71:	89 c7                	mov    %eax,%edi
  802d73:	48 b8 2d 1b 80 00 00 	movabs $0x801b2d,%rax
  802d7a:	00 00 00 
  802d7d:	ff d0                	callq  *%rax
  802d7f:	89 45 d8             	mov    %eax,-0x28(%rbp)
  802d82:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802d86:	79 30                	jns    802db8 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  802d88:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802d8b:	89 c1                	mov    %eax,%ecx
  802d8d:	48 ba 86 50 80 00 00 	movabs $0x805086,%rdx
  802d94:	00 00 00 
  802d97:	be 88 00 00 00       	mov    $0x88,%esi
  802d9c:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  802da3:	00 00 00 
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  802db2:	00 00 00 
  802db5:	41 ff d0             	callq  *%r8

	return child;
  802db8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802dbb:	eb 26                	jmp    802de3 <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802dbd:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802dbe:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802dc1:	89 c7                	mov    %eax,%edi
  802dc3:	48 b8 78 19 80 00 00 	movabs $0x801978,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
	close(fd);
  802dcf:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802dd2:	89 c7                	mov    %eax,%edi
  802dd4:	48 b8 6e 20 80 00 00 	movabs $0x80206e,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
	return r;
  802de0:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  802de3:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  802dea:	5b                   	pop    %rbx
  802deb:	5d                   	pop    %rbp
  802dec:	c3                   	retq   

0000000000802ded <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802ded:	55                   	push   %rbp
  802dee:	48 89 e5             	mov    %rsp,%rbp
  802df1:	53                   	push   %rbx
  802df2:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  802df9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802e00:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  802e07:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  802e0e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802e15:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  802e1c:	84 c0                	test   %al,%al
  802e1e:	74 23                	je     802e43 <spawnl+0x56>
  802e20:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802e27:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802e2b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802e2f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802e33:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802e37:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802e3b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802e3f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802e43:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802e4a:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  802e51:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802e54:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802e5b:	00 00 00 
  802e5e:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802e65:	00 00 00 
  802e68:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e6c:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802e73:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802e7a:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802e81:	eb 07                	jmp    802e8a <spawnl+0x9d>
		argc++;
  802e83:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802e8a:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802e90:	83 f8 30             	cmp    $0x30,%eax
  802e93:	73 23                	jae    802eb8 <spawnl+0xcb>
  802e95:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802e9c:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802ea2:	89 c0                	mov    %eax,%eax
  802ea4:	48 01 d0             	add    %rdx,%rax
  802ea7:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802ead:	83 c2 08             	add    $0x8,%edx
  802eb0:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802eb6:	eb 15                	jmp    802ecd <spawnl+0xe0>
  802eb8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802ebf:	48 89 d0             	mov    %rdx,%rax
  802ec2:	48 83 c2 08          	add    $0x8,%rdx
  802ec6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802ecd:	48 8b 00             	mov    (%rax),%rax
  802ed0:	48 85 c0             	test   %rax,%rax
  802ed3:	75 ae                	jne    802e83 <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ed5:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802edb:	83 c0 02             	add    $0x2,%eax
  802ede:	48 89 e2             	mov    %rsp,%rdx
  802ee1:	48 89 d3             	mov    %rdx,%rbx
  802ee4:	48 63 d0             	movslq %eax,%rdx
  802ee7:	48 83 ea 01          	sub    $0x1,%rdx
  802eeb:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  802ef2:	48 98                	cltq   
  802ef4:	48 c1 e0 03          	shl    $0x3,%rax
  802ef8:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  802efc:	b8 10 00 00 00       	mov    $0x10,%eax
  802f01:	48 83 e8 01          	sub    $0x1,%rax
  802f05:	48 01 d0             	add    %rdx,%rax
  802f08:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  802f0f:	10 00 00 00 
  802f13:	ba 00 00 00 00       	mov    $0x0,%edx
  802f18:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  802f1f:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802f23:	48 29 c4             	sub    %rax,%rsp
  802f26:	48 89 e0             	mov    %rsp,%rax
  802f29:	48 83 c0 0f          	add    $0xf,%rax
  802f2d:	48 c1 e8 04          	shr    $0x4,%rax
  802f31:	48 c1 e0 04          	shl    $0x4,%rax
  802f35:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  802f3c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f43:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  802f4a:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802f4d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  802f53:	8d 50 01             	lea    0x1(%rax),%edx
  802f56:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802f5d:	48 63 d2             	movslq %edx,%rdx
  802f60:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802f67:	00 

	va_start(vl, arg0);
  802f68:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  802f6f:	00 00 00 
  802f72:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  802f79:	00 00 00 
  802f7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f80:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  802f87:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  802f8e:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802f95:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  802f9c:	00 00 00 
  802f9f:	eb 63                	jmp    803004 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  802fa1:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  802fa7:	8d 70 01             	lea    0x1(%rax),%esi
  802faa:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802fb0:	83 f8 30             	cmp    $0x30,%eax
  802fb3:	73 23                	jae    802fd8 <spawnl+0x1eb>
  802fb5:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  802fbc:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  802fc2:	89 c0                	mov    %eax,%eax
  802fc4:	48 01 d0             	add    %rdx,%rax
  802fc7:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  802fcd:	83 c2 08             	add    $0x8,%edx
  802fd0:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  802fd6:	eb 15                	jmp    802fed <spawnl+0x200>
  802fd8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  802fdf:	48 89 d0             	mov    %rdx,%rax
  802fe2:	48 83 c2 08          	add    $0x8,%rdx
  802fe6:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  802fed:	48 8b 08             	mov    (%rax),%rcx
  802ff0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802ff7:	89 f2                	mov    %esi,%edx
  802ff9:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802ffd:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  803004:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  80300a:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  803010:	77 8f                	ja     802fa1 <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803012:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803019:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803020:	48 89 d6             	mov    %rdx,%rsi
  803023:	48 89 c7             	mov    %rax,%rdi
  803026:	48 b8 80 2a 80 00 00 	movabs $0x802a80,%rax
  80302d:	00 00 00 
  803030:	ff d0                	callq  *%rax
  803032:	48 89 dc             	mov    %rbx,%rsp
}
  803035:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 50          	sub    $0x50,%rsp
  803043:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803046:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  80304a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80304e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803055:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803056:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80305d:	eb 2c                	jmp    80308b <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  80305f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803062:	48 98                	cltq   
  803064:	48 c1 e0 03          	shl    $0x3,%rax
  803068:	48 03 45 c0          	add    -0x40(%rbp),%rax
  80306c:	48 8b 00             	mov    (%rax),%rax
  80306f:	48 89 c7             	mov    %rax,%rdi
  803072:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
  80307e:	83 c0 01             	add    $0x1,%eax
  803081:	48 98                	cltq   
  803083:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803087:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80308b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80308e:	48 98                	cltq   
  803090:	48 c1 e0 03          	shl    $0x3,%rax
  803094:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803098:	48 8b 00             	mov    (%rax),%rax
  80309b:	48 85 c0             	test   %rax,%rax
  80309e:	75 bf                	jne    80305f <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8030a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030a4:	48 f7 d8             	neg    %rax
  8030a7:	48 05 00 10 40 00    	add    $0x401000,%rax
  8030ad:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8030b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8030b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bd:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8030c1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030c4:	83 c2 01             	add    $0x1,%edx
  8030c7:	c1 e2 03             	shl    $0x3,%edx
  8030ca:	48 63 d2             	movslq %edx,%rdx
  8030cd:	48 f7 da             	neg    %rdx
  8030d0:	48 01 d0             	add    %rdx,%rax
  8030d3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8030d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030db:	48 83 e8 10          	sub    $0x10,%rax
  8030df:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8030e5:	77 0a                	ja     8030f1 <init_stack+0xb6>
		return -E_NO_MEM;
  8030e7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8030ec:	e9 b8 01 00 00       	jmpq   8032a9 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8030f1:	ba 07 00 00 00       	mov    $0x7,%edx
  8030f6:	be 00 00 40 00       	mov    $0x400000,%esi
  8030fb:	bf 00 00 00 00       	mov    $0x0,%edi
  803100:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803107:	00 00 00 
  80310a:	ff d0                	callq  *%rax
  80310c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80310f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803113:	79 08                	jns    80311d <init_stack+0xe2>
		return r;
  803115:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803118:	e9 8c 01 00 00       	jmpq   8032a9 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80311d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803124:	eb 73                	jmp    803199 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803126:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803129:	48 98                	cltq   
  80312b:	48 c1 e0 03          	shl    $0x3,%rax
  80312f:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803133:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803138:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  80313c:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803143:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803146:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803149:	48 98                	cltq   
  80314b:	48 c1 e0 03          	shl    $0x3,%rax
  80314f:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803153:	48 8b 10             	mov    (%rax),%rdx
  803156:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315a:	48 89 d6             	mov    %rdx,%rsi
  80315d:	48 89 c7             	mov    %rax,%rdi
  803160:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  803167:	00 00 00 
  80316a:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80316c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80316f:	48 98                	cltq   
  803171:	48 c1 e0 03          	shl    $0x3,%rax
  803175:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803179:	48 8b 00             	mov    (%rax),%rax
  80317c:	48 89 c7             	mov    %rax,%rdi
  80317f:	48 b8 94 10 80 00 00 	movabs $0x801094,%rax
  803186:	00 00 00 
  803189:	ff d0                	callq  *%rax
  80318b:	48 98                	cltq   
  80318d:	48 83 c0 01          	add    $0x1,%rax
  803191:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803195:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803199:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80319c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80319f:	7c 85                	jl     803126 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8031a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031a4:	48 98                	cltq   
  8031a6:	48 c1 e0 03          	shl    $0x3,%rax
  8031aa:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8031ae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8031b5:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8031bc:	00 
  8031bd:	74 35                	je     8031f4 <init_stack+0x1b9>
  8031bf:	48 b9 a0 50 80 00 00 	movabs $0x8050a0,%rcx
  8031c6:	00 00 00 
  8031c9:	48 ba c6 50 80 00 00 	movabs $0x8050c6,%rdx
  8031d0:	00 00 00 
  8031d3:	be f1 00 00 00       	mov    $0xf1,%esi
  8031d8:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  8031df:	00 00 00 
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8031ee:	00 00 00 
  8031f1:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8031f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f8:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  8031fc:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803201:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803205:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80320b:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80320e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803212:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803216:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803219:	48 98                	cltq   
  80321b:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80321e:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803223:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803227:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80322d:	48 89 c2             	mov    %rax,%rdx
  803230:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803234:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803237:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80323a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803240:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803245:	89 c2                	mov    %eax,%edx
  803247:	be 00 00 40 00       	mov    $0x400000,%esi
  80324c:	bf 00 00 00 00       	mov    $0x0,%edi
  803251:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  803258:	00 00 00 
  80325b:	ff d0                	callq  *%rax
  80325d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803260:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803264:	78 26                	js     80328c <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803266:	be 00 00 40 00       	mov    $0x400000,%esi
  80326b:	bf 00 00 00 00       	mov    $0x0,%edi
  803270:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803283:	78 0a                	js     80328f <init_stack+0x254>
		goto error;

	return 0;
  803285:	b8 00 00 00 00       	mov    $0x0,%eax
  80328a:	eb 1d                	jmp    8032a9 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  80328c:	90                   	nop
  80328d:	eb 01                	jmp    803290 <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  80328f:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803290:	be 00 00 40 00       	mov    $0x400000,%esi
  803295:	bf 00 00 00 00       	mov    $0x0,%edi
  80329a:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
	return r;
  8032a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032a9:	c9                   	leaveq 
  8032aa:	c3                   	retq   

00000000008032ab <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8032ab:	55                   	push   %rbp
  8032ac:	48 89 e5             	mov    %rsp,%rbp
  8032af:	48 83 ec 50          	sub    $0x50,%rsp
  8032b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032ba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8032be:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8032c1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8032c5:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8032c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032cd:	25 ff 0f 00 00       	and    $0xfff,%eax
  8032d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d9:	74 21                	je     8032fc <map_segment+0x51>
		va -= i;
  8032db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032de:	48 98                	cltq   
  8032e0:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  8032e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032e7:	48 98                	cltq   
  8032e9:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  8032ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f0:	48 98                	cltq   
  8032f2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  8032f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f9:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8032fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803303:	e9 74 01 00 00       	jmpq   80347c <map_segment+0x1d1>
		if (i >= filesz) {
  803308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330b:	48 98                	cltq   
  80330d:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803311:	72 38                	jb     80334b <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803316:	48 98                	cltq   
  803318:	48 03 45 d0          	add    -0x30(%rbp),%rax
  80331c:	48 89 c1             	mov    %rax,%rcx
  80331f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803322:	8b 55 10             	mov    0x10(%rbp),%edx
  803325:	48 89 ce             	mov    %rcx,%rsi
  803328:	89 c7                	mov    %eax,%edi
  80332a:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803331:	00 00 00 
  803334:	ff d0                	callq  *%rax
  803336:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803339:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80333d:	0f 89 32 01 00 00    	jns    803475 <map_segment+0x1ca>
				return r;
  803343:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803346:	e9 45 01 00 00       	jmpq   803490 <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80334b:	ba 07 00 00 00       	mov    $0x7,%edx
  803350:	be 00 00 40 00       	mov    $0x400000,%esi
  803355:	bf 00 00 00 00       	mov    $0x0,%edi
  80335a:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
  803366:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803369:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80336d:	79 08                	jns    803377 <map_segment+0xcc>
				return r;
  80336f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803372:	e9 19 01 00 00       	jmpq   803490 <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337a:	8b 55 bc             	mov    -0x44(%rbp),%edx
  80337d:	01 c2                	add    %eax,%edx
  80337f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803382:	89 d6                	mov    %edx,%esi
  803384:	89 c7                	mov    %eax,%edi
  803386:	48 b8 b6 24 80 00 00 	movabs $0x8024b6,%rax
  80338d:	00 00 00 
  803390:	ff d0                	callq  *%rax
  803392:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803395:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803399:	79 08                	jns    8033a3 <map_segment+0xf8>
				return r;
  80339b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80339e:	e9 ed 00 00 00       	jmpq   803490 <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8033a3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8033aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ad:	48 98                	cltq   
  8033af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8033b3:	48 89 d1             	mov    %rdx,%rcx
  8033b6:	48 29 c1             	sub    %rax,%rcx
  8033b9:	48 89 c8             	mov    %rcx,%rax
  8033bc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8033c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033c3:	48 63 d0             	movslq %eax,%rdx
  8033c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ca:	48 39 c2             	cmp    %rax,%rdx
  8033cd:	48 0f 47 d0          	cmova  %rax,%rdx
  8033d1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8033d4:	be 00 00 40 00       	mov    $0x400000,%esi
  8033d9:	89 c7                	mov    %eax,%edi
  8033db:	48 b8 69 23 80 00 00 	movabs $0x802369,%rax
  8033e2:	00 00 00 
  8033e5:	ff d0                	callq  *%rax
  8033e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033ea:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033ee:	79 08                	jns    8033f8 <map_segment+0x14d>
				return r;
  8033f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033f3:	e9 98 00 00 00       	jmpq   803490 <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8033f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033fb:	48 98                	cltq   
  8033fd:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803401:	48 89 c2             	mov    %rax,%rdx
  803404:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803407:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  80340b:	48 89 d1             	mov    %rdx,%rcx
  80340e:	89 c2                	mov    %eax,%edx
  803410:	be 00 00 40 00       	mov    $0x400000,%esi
  803415:	bf 00 00 00 00       	mov    $0x0,%edi
  80341a:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
  803426:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803429:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80342d:	79 30                	jns    80345f <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  80342f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803432:	89 c1                	mov    %eax,%ecx
  803434:	48 ba db 50 80 00 00 	movabs $0x8050db,%rdx
  80343b:	00 00 00 
  80343e:	be 24 01 00 00       	mov    $0x124,%esi
  803443:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  80344a:	00 00 00 
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  803459:	00 00 00 
  80345c:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80345f:	be 00 00 40 00       	mov    $0x400000,%esi
  803464:	bf 00 00 00 00       	mov    $0x0,%edi
  803469:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803470:	00 00 00 
  803473:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803475:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347f:	48 98                	cltq   
  803481:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803485:	0f 82 7d fe ff ff    	jb     803308 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  80348b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803490:	c9                   	leaveq 
  803491:	c3                   	retq   

0000000000803492 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803492:	55                   	push   %rbp
  803493:	48 89 e5             	mov    %rsp,%rbp
  803496:	48 83 ec 60          	sub    $0x60,%rsp
  80349a:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  80349d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  8034a4:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  8034ab:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  8034b2:	00 
  8034b3:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  8034ba:	00 
  8034bb:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8034c2:	00 
  8034c3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034ca:	00 
  8034cb:	e9 a6 01 00 00       	jmpq   803676 <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  8034d0:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8034d7:	01 00 00 
  8034da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034e2:	83 e0 01             	and    $0x1,%eax
  8034e5:	84 c0                	test   %al,%al
  8034e7:	0f 84 74 01 00 00    	je     803661 <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  8034ed:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8034f4:	00 
  8034f5:	e9 56 01 00 00       	jmpq   803650 <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  8034fa:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803501:	01 00 00 
  803504:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803508:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80350c:	83 e0 01             	and    $0x1,%eax
  80350f:	84 c0                	test   %al,%al
  803511:	0f 84 1f 01 00 00    	je     803636 <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  803517:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80351e:	00 
  80351f:	e9 02 01 00 00       	jmpq   803626 <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  803524:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80352b:	01 00 00 
  80352e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803532:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803536:	83 e0 01             	and    $0x1,%eax
  803539:	84 c0                	test   %al,%al
  80353b:	0f 84 cb 00 00 00    	je     80360c <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  803541:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803548:	00 
  803549:	e9 ae 00 00 00       	jmpq   8035fc <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  80354e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803555:	01 00 00 
  803558:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80355c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803560:	25 00 04 00 00       	and    $0x400,%eax
  803565:	48 85 c0             	test   %rax,%rax
  803568:	0f 84 84 00 00 00    	je     8035f2 <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  80356e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803572:	48 c1 e0 0c          	shl    $0xc,%rax
  803576:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  80357a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803581:	01 00 00 
  803584:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803588:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80358c:	25 07 0e 00 00       	and    $0xe07,%eax
  803591:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  803594:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  803597:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  80359b:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80359e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8035a2:	41 89 f0             	mov    %esi,%r8d
  8035a5:	48 89 c6             	mov    %rax,%rsi
  8035a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ad:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  8035b4:	00 00 00 
  8035b7:	ff d0                	callq  *%rax
  8035b9:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  8035bc:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  8035c0:	79 30                	jns    8035f2 <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  8035c2:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8035c5:	89 c1                	mov    %eax,%ecx
  8035c7:	48 ba f8 50 80 00 00 	movabs $0x8050f8,%rdx
  8035ce:	00 00 00 
  8035d1:	be 48 01 00 00       	mov    $0x148,%esi
  8035d6:	48 bf 60 50 80 00 00 	movabs $0x805060,%rdi
  8035dd:	00 00 00 
  8035e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e5:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  8035ec:	00 00 00 
  8035ef:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  8035f2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8035f7:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8035fc:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803603:	00 
  803604:	0f 86 44 ff ff ff    	jbe    80354e <copy_shared_pages+0xbc>
  80360a:	eb 10                	jmp    80361c <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  80360c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803610:	48 83 c0 01          	add    $0x1,%rax
  803614:	48 c1 e0 09          	shl    $0x9,%rax
  803618:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  80361c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803621:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  803626:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  80362d:	00 
  80362e:	0f 86 f0 fe ff ff    	jbe    803524 <copy_shared_pages+0x92>
  803634:	eb 10                	jmp    803646 <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  803636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363a:	48 83 c0 01          	add    $0x1,%rax
  80363e:	48 c1 e0 09          	shl    $0x9,%rax
  803642:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  803646:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  80364b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803650:	8b 45 c0             	mov    -0x40(%rbp),%eax
  803653:	48 98                	cltq   
  803655:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  803659:	0f 87 9b fe ff ff    	ja     8034fa <copy_shared_pages+0x68>
  80365f:	eb 10                	jmp    803671 <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  803661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803665:	48 83 c0 01          	add    $0x1,%rax
  803669:	48 c1 e0 09          	shl    $0x9,%rax
  80366d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  803671:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803676:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803679:	48 98                	cltq   
  80367b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80367f:	0f 87 4b fe ff ff    	ja     8034d0 <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  803685:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80368a:	c9                   	leaveq 
  80368b:	c3                   	retq   

000000000080368c <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80368c:	55                   	push   %rbp
  80368d:	48 89 e5             	mov    %rsp,%rbp
  803690:	48 83 ec 20          	sub    $0x20,%rsp
  803694:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803697:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80369b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80369e:	48 89 d6             	mov    %rdx,%rsi
  8036a1:	89 c7                	mov    %eax,%edi
  8036a3:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
  8036af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b6:	79 05                	jns    8036bd <fd2sockid+0x31>
		return r;
  8036b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bb:	eb 24                	jmp    8036e1 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8036bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c1:	8b 10                	mov    (%rax),%edx
  8036c3:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  8036ca:	00 00 00 
  8036cd:	8b 00                	mov    (%rax),%eax
  8036cf:	39 c2                	cmp    %eax,%edx
  8036d1:	74 07                	je     8036da <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8036d3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8036d8:	eb 07                	jmp    8036e1 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8036da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036de:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   

00000000008036e3 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8036e3:	55                   	push   %rbp
  8036e4:	48 89 e5             	mov    %rsp,%rbp
  8036e7:	48 83 ec 20          	sub    $0x20,%rsp
  8036eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8036ee:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8036f2:	48 89 c7             	mov    %rax,%rdi
  8036f5:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  8036fc:	00 00 00 
  8036ff:	ff d0                	callq  *%rax
  803701:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803704:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803708:	78 26                	js     803730 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80370a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370e:	ba 07 04 00 00       	mov    $0x407,%edx
  803713:	48 89 c6             	mov    %rax,%rsi
  803716:	bf 00 00 00 00       	mov    $0x0,%edi
  80371b:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803722:	00 00 00 
  803725:	ff d0                	callq  *%rax
  803727:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80372a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372e:	79 16                	jns    803746 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803730:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803733:	89 c7                	mov    %eax,%edi
  803735:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
		return r;
  803741:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803744:	eb 3a                	jmp    803780 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80374a:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803751:	00 00 00 
  803754:	8b 12                	mov    (%rdx),%edx
  803756:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803758:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803763:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803767:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80376a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80376d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803771:	48 89 c7             	mov    %rax,%rdi
  803774:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  80377b:	00 00 00 
  80377e:	ff d0                	callq  *%rax
}
  803780:	c9                   	leaveq 
  803781:	c3                   	retq   

0000000000803782 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803782:	55                   	push   %rbp
  803783:	48 89 e5             	mov    %rsp,%rbp
  803786:	48 83 ec 30          	sub    $0x30,%rsp
  80378a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80378d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803791:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803795:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803798:	89 c7                	mov    %eax,%edi
  80379a:	48 b8 8c 36 80 00 00 	movabs $0x80368c,%rax
  8037a1:	00 00 00 
  8037a4:	ff d0                	callq  *%rax
  8037a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ad:	79 05                	jns    8037b4 <accept+0x32>
		return r;
  8037af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037b2:	eb 3b                	jmp    8037ef <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8037b4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037b8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bf:	48 89 ce             	mov    %rcx,%rsi
  8037c2:	89 c7                	mov    %eax,%edi
  8037c4:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  8037cb:	00 00 00 
  8037ce:	ff d0                	callq  *%rax
  8037d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037d7:	79 05                	jns    8037de <accept+0x5c>
		return r;
  8037d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037dc:	eb 11                	jmp    8037ef <accept+0x6d>
	return alloc_sockfd(r);
  8037de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e1:	89 c7                	mov    %eax,%edi
  8037e3:	48 b8 e3 36 80 00 00 	movabs $0x8036e3,%rax
  8037ea:	00 00 00 
  8037ed:	ff d0                	callq  *%rax
}
  8037ef:	c9                   	leaveq 
  8037f0:	c3                   	retq   

00000000008037f1 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037f1:	55                   	push   %rbp
  8037f2:	48 89 e5             	mov    %rsp,%rbp
  8037f5:	48 83 ec 20          	sub    $0x20,%rsp
  8037f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803800:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803803:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803806:	89 c7                	mov    %eax,%edi
  803808:	48 b8 8c 36 80 00 00 	movabs $0x80368c,%rax
  80380f:	00 00 00 
  803812:	ff d0                	callq  *%rax
  803814:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803817:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80381b:	79 05                	jns    803822 <bind+0x31>
		return r;
  80381d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803820:	eb 1b                	jmp    80383d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803822:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803825:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803829:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382c:	48 89 ce             	mov    %rcx,%rsi
  80382f:	89 c7                	mov    %eax,%edi
  803831:	48 b8 4c 3b 80 00 00 	movabs $0x803b4c,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
}
  80383d:	c9                   	leaveq 
  80383e:	c3                   	retq   

000000000080383f <shutdown>:

int
shutdown(int s, int how)
{
  80383f:	55                   	push   %rbp
  803840:	48 89 e5             	mov    %rsp,%rbp
  803843:	48 83 ec 20          	sub    $0x20,%rsp
  803847:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803850:	89 c7                	mov    %eax,%edi
  803852:	48 b8 8c 36 80 00 00 	movabs $0x80368c,%rax
  803859:	00 00 00 
  80385c:	ff d0                	callq  *%rax
  80385e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803861:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803865:	79 05                	jns    80386c <shutdown+0x2d>
		return r;
  803867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386a:	eb 16                	jmp    803882 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80386c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80386f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803872:	89 d6                	mov    %edx,%esi
  803874:	89 c7                	mov    %eax,%edi
  803876:	48 b8 b0 3b 80 00 00 	movabs $0x803bb0,%rax
  80387d:	00 00 00 
  803880:	ff d0                	callq  *%rax
}
  803882:	c9                   	leaveq 
  803883:	c3                   	retq   

0000000000803884 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803884:	55                   	push   %rbp
  803885:	48 89 e5             	mov    %rsp,%rbp
  803888:	48 83 ec 10          	sub    $0x10,%rsp
  80388c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803890:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803894:	48 89 c7             	mov    %rax,%rdi
  803897:	48 b8 1c 49 80 00 00 	movabs $0x80491c,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
  8038a3:	83 f8 01             	cmp    $0x1,%eax
  8038a6:	75 17                	jne    8038bf <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8038a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ac:	8b 40 0c             	mov    0xc(%rax),%eax
  8038af:	89 c7                	mov    %eax,%edi
  8038b1:	48 b8 f0 3b 80 00 00 	movabs $0x803bf0,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	eb 05                	jmp    8038c4 <devsock_close+0x40>
	else
		return 0;
  8038bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c4:	c9                   	leaveq 
  8038c5:	c3                   	retq   

00000000008038c6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038c6:	55                   	push   %rbp
  8038c7:	48 89 e5             	mov    %rsp,%rbp
  8038ca:	48 83 ec 20          	sub    $0x20,%rsp
  8038ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038d5:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038db:	89 c7                	mov    %eax,%edi
  8038dd:	48 b8 8c 36 80 00 00 	movabs $0x80368c,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
  8038e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f0:	79 05                	jns    8038f7 <connect+0x31>
		return r;
  8038f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038f5:	eb 1b                	jmp    803912 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8038f7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038fa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803901:	48 89 ce             	mov    %rcx,%rsi
  803904:	89 c7                	mov    %eax,%edi
  803906:	48 b8 1d 3c 80 00 00 	movabs $0x803c1d,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <listen>:

int
listen(int s, int backlog)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 83 ec 20          	sub    $0x20,%rsp
  80391c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80391f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803922:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803925:	89 c7                	mov    %eax,%edi
  803927:	48 b8 8c 36 80 00 00 	movabs $0x80368c,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
  803933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393a:	79 05                	jns    803941 <listen+0x2d>
		return r;
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393f:	eb 16                	jmp    803957 <listen+0x43>
	return nsipc_listen(r, backlog);
  803941:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803947:	89 d6                	mov    %edx,%esi
  803949:	89 c7                	mov    %eax,%edi
  80394b:	48 b8 81 3c 80 00 00 	movabs $0x803c81,%rax
  803952:	00 00 00 
  803955:	ff d0                	callq  *%rax
}
  803957:	c9                   	leaveq 
  803958:	c3                   	retq   

0000000000803959 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803959:	55                   	push   %rbp
  80395a:	48 89 e5             	mov    %rsp,%rbp
  80395d:	48 83 ec 20          	sub    $0x20,%rsp
  803961:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803965:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803969:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80396d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803971:	89 c2                	mov    %eax,%edx
  803973:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803977:	8b 40 0c             	mov    0xc(%rax),%eax
  80397a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80397e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803983:	89 c7                	mov    %eax,%edi
  803985:	48 b8 c1 3c 80 00 00 	movabs $0x803cc1,%rax
  80398c:	00 00 00 
  80398f:	ff d0                	callq  *%rax
}
  803991:	c9                   	leaveq 
  803992:	c3                   	retq   

0000000000803993 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803993:	55                   	push   %rbp
  803994:	48 89 e5             	mov    %rsp,%rbp
  803997:	48 83 ec 20          	sub    $0x20,%rsp
  80399b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80399f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039a3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8039a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ab:	89 c2                	mov    %eax,%edx
  8039ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b1:	8b 40 0c             	mov    0xc(%rax),%eax
  8039b4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039bd:	89 c7                	mov    %eax,%edi
  8039bf:	48 b8 8d 3d 80 00 00 	movabs $0x803d8d,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
}
  8039cb:	c9                   	leaveq 
  8039cc:	c3                   	retq   

00000000008039cd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8039cd:	55                   	push   %rbp
  8039ce:	48 89 e5             	mov    %rsp,%rbp
  8039d1:	48 83 ec 10          	sub    $0x10,%rsp
  8039d5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8039dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e1:	48 be 14 51 80 00 00 	movabs $0x805114,%rsi
  8039e8:	00 00 00 
  8039eb:	48 89 c7             	mov    %rax,%rdi
  8039ee:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8039f5:	00 00 00 
  8039f8:	ff d0                	callq  *%rax
	return 0;
  8039fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039ff:	c9                   	leaveq 
  803a00:	c3                   	retq   

0000000000803a01 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a01:	55                   	push   %rbp
  803a02:	48 89 e5             	mov    %rsp,%rbp
  803a05:	48 83 ec 20          	sub    $0x20,%rsp
  803a09:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a0c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a0f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a12:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a15:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a1b:	89 ce                	mov    %ecx,%esi
  803a1d:	89 c7                	mov    %eax,%edi
  803a1f:	48 b8 45 3e 80 00 00 	movabs $0x803e45,%rax
  803a26:	00 00 00 
  803a29:	ff d0                	callq  *%rax
  803a2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a32:	79 05                	jns    803a39 <socket+0x38>
		return r;
  803a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a37:	eb 11                	jmp    803a4a <socket+0x49>
	return alloc_sockfd(r);
  803a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3c:	89 c7                	mov    %eax,%edi
  803a3e:	48 b8 e3 36 80 00 00 	movabs $0x8036e3,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
}
  803a4a:	c9                   	leaveq 
  803a4b:	c3                   	retq   

0000000000803a4c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a4c:	55                   	push   %rbp
  803a4d:	48 89 e5             	mov    %rsp,%rbp
  803a50:	48 83 ec 10          	sub    $0x10,%rsp
  803a54:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803a57:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  803a5e:	00 00 00 
  803a61:	8b 00                	mov    (%rax),%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	75 1d                	jne    803a84 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803a67:	bf 02 00 00 00       	mov    $0x2,%edi
  803a6c:	48 b8 97 48 80 00 00 	movabs $0x804897,%rax
  803a73:	00 00 00 
  803a76:	ff d0                	callq  *%rax
  803a78:	48 ba 30 80 80 00 00 	movabs $0x808030,%rdx
  803a7f:	00 00 00 
  803a82:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a84:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  803a8b:	00 00 00 
  803a8e:	8b 00                	mov    (%rax),%eax
  803a90:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a93:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a98:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a9f:	00 00 00 
  803aa2:	89 c7                	mov    %eax,%edi
  803aa4:	48 b8 d4 47 80 00 00 	movabs $0x8047d4,%rax
  803aab:	00 00 00 
  803aae:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  803ab5:	be 00 00 00 00       	mov    $0x0,%esi
  803aba:	bf 00 00 00 00       	mov    $0x0,%edi
  803abf:	48 b8 14 47 80 00 00 	movabs $0x804714,%rax
  803ac6:	00 00 00 
  803ac9:	ff d0                	callq  *%rax
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	48 83 ec 30          	sub    $0x30,%rsp
  803ad5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ad8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803adc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ae0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae7:	00 00 00 
  803aea:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803aed:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803aef:	bf 01 00 00 00       	mov    $0x1,%edi
  803af4:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
  803b00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b07:	78 3e                	js     803b47 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b09:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b10:	00 00 00 
  803b13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1b:	8b 40 10             	mov    0x10(%rax),%eax
  803b1e:	89 c2                	mov    %eax,%edx
  803b20:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b24:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b28:	48 89 ce             	mov    %rcx,%rsi
  803b2b:	48 89 c7             	mov    %rax,%rdi
  803b2e:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b3e:	8b 50 10             	mov    0x10(%rax),%edx
  803b41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b45:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b4a:	c9                   	leaveq 
  803b4b:	c3                   	retq   

0000000000803b4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b4c:	55                   	push   %rbp
  803b4d:	48 89 e5             	mov    %rsp,%rbp
  803b50:	48 83 ec 10          	sub    $0x10,%rsp
  803b54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b5b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803b5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b65:	00 00 00 
  803b68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b6b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803b6d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	48 89 c6             	mov    %rax,%rsi
  803b77:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803b7e:	00 00 00 
  803b81:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b8d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b94:	00 00 00 
  803b97:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b9a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b9d:	bf 02 00 00 00       	mov    $0x2,%edi
  803ba2:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803ba9:	00 00 00 
  803bac:	ff d0                	callq  *%rax
}
  803bae:	c9                   	leaveq 
  803baf:	c3                   	retq   

0000000000803bb0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803bb0:	55                   	push   %rbp
  803bb1:	48 89 e5             	mov    %rsp,%rbp
  803bb4:	48 83 ec 10          	sub    $0x10,%rsp
  803bb8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bbb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803bbe:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bc5:	00 00 00 
  803bc8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bcb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803bcd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bd4:	00 00 00 
  803bd7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bda:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803bdd:	bf 03 00 00 00       	mov    $0x3,%edi
  803be2:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803be9:	00 00 00 
  803bec:	ff d0                	callq  *%rax
}
  803bee:	c9                   	leaveq 
  803bef:	c3                   	retq   

0000000000803bf0 <nsipc_close>:

int
nsipc_close(int s)
{
  803bf0:	55                   	push   %rbp
  803bf1:	48 89 e5             	mov    %rsp,%rbp
  803bf4:	48 83 ec 10          	sub    $0x10,%rsp
  803bf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803bfb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c02:	00 00 00 
  803c05:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c08:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c0a:	bf 04 00 00 00       	mov    $0x4,%edi
  803c0f:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803c16:	00 00 00 
  803c19:	ff d0                	callq  *%rax
}
  803c1b:	c9                   	leaveq 
  803c1c:	c3                   	retq   

0000000000803c1d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c1d:	55                   	push   %rbp
  803c1e:	48 89 e5             	mov    %rsp,%rbp
  803c21:	48 83 ec 10          	sub    $0x10,%rsp
  803c25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c2c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c36:	00 00 00 
  803c39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c3c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c3e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c45:	48 89 c6             	mov    %rax,%rsi
  803c48:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c4f:	00 00 00 
  803c52:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803c59:	00 00 00 
  803c5c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803c5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c65:	00 00 00 
  803c68:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c6b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803c6e:	bf 05 00 00 00       	mov    $0x5,%edi
  803c73:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
}
  803c7f:	c9                   	leaveq 
  803c80:	c3                   	retq   

0000000000803c81 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803c81:	55                   	push   %rbp
  803c82:	48 89 e5             	mov    %rsp,%rbp
  803c85:	48 83 ec 10          	sub    $0x10,%rsp
  803c89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c8c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c96:	00 00 00 
  803c99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c9c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c9e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ca5:	00 00 00 
  803ca8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cab:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803cae:	bf 06 00 00 00       	mov    $0x6,%edi
  803cb3:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803cba:	00 00 00 
  803cbd:	ff d0                	callq  *%rax
}
  803cbf:	c9                   	leaveq 
  803cc0:	c3                   	retq   

0000000000803cc1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803cc1:	55                   	push   %rbp
  803cc2:	48 89 e5             	mov    %rsp,%rbp
  803cc5:	48 83 ec 30          	sub    $0x30,%rsp
  803cc9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ccc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803cd0:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803cd3:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803cd6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cdd:	00 00 00 
  803ce0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ce3:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803ce5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cec:	00 00 00 
  803cef:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cf2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803cf5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cfc:	00 00 00 
  803cff:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d02:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d05:	bf 07 00 00 00       	mov    $0x7,%edi
  803d0a:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803d11:	00 00 00 
  803d14:	ff d0                	callq  *%rax
  803d16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d1d:	78 69                	js     803d88 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d1f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d26:	7f 08                	jg     803d30 <nsipc_recv+0x6f>
  803d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d2b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d2e:	7e 35                	jle    803d65 <nsipc_recv+0xa4>
  803d30:	48 b9 1b 51 80 00 00 	movabs $0x80511b,%rcx
  803d37:	00 00 00 
  803d3a:	48 ba 30 51 80 00 00 	movabs $0x805130,%rdx
  803d41:	00 00 00 
  803d44:	be 61 00 00 00       	mov    $0x61,%esi
  803d49:	48 bf 45 51 80 00 00 	movabs $0x805145,%rdi
  803d50:	00 00 00 
  803d53:	b8 00 00 00 00       	mov    $0x0,%eax
  803d58:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  803d5f:	00 00 00 
  803d62:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803d65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d68:	48 63 d0             	movslq %eax,%rdx
  803d6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d6f:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803d76:	00 00 00 
  803d79:	48 89 c7             	mov    %rax,%rdi
  803d7c:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803d83:	00 00 00 
  803d86:	ff d0                	callq  *%rax
	}

	return r;
  803d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d8b:	c9                   	leaveq 
  803d8c:	c3                   	retq   

0000000000803d8d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d8d:	55                   	push   %rbp
  803d8e:	48 89 e5             	mov    %rsp,%rbp
  803d91:	48 83 ec 20          	sub    $0x20,%rsp
  803d95:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d9c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d9f:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803da2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da9:	00 00 00 
  803dac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803daf:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803db1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803db8:	7e 35                	jle    803def <nsipc_send+0x62>
  803dba:	48 b9 51 51 80 00 00 	movabs $0x805151,%rcx
  803dc1:	00 00 00 
  803dc4:	48 ba 30 51 80 00 00 	movabs $0x805130,%rdx
  803dcb:	00 00 00 
  803dce:	be 6c 00 00 00       	mov    $0x6c,%esi
  803dd3:	48 bf 45 51 80 00 00 	movabs $0x805145,%rdi
  803dda:	00 00 00 
  803ddd:	b8 00 00 00 00       	mov    $0x0,%eax
  803de2:	49 b8 08 03 80 00 00 	movabs $0x800308,%r8
  803de9:	00 00 00 
  803dec:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803def:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803df2:	48 63 d0             	movslq %eax,%rdx
  803df5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df9:	48 89 c6             	mov    %rax,%rsi
  803dfc:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e03:	00 00 00 
  803e06:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  803e0d:	00 00 00 
  803e10:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e12:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e19:	00 00 00 
  803e1c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e1f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e22:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e29:	00 00 00 
  803e2c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e2f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e32:	bf 08 00 00 00       	mov    $0x8,%edi
  803e37:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803e3e:	00 00 00 
  803e41:	ff d0                	callq  *%rax
}
  803e43:	c9                   	leaveq 
  803e44:	c3                   	retq   

0000000000803e45 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e45:	55                   	push   %rbp
  803e46:	48 89 e5             	mov    %rsp,%rbp
  803e49:	48 83 ec 10          	sub    $0x10,%rsp
  803e4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e50:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803e53:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803e56:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e5d:	00 00 00 
  803e60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e63:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803e65:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e6c:	00 00 00 
  803e6f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e72:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803e75:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e7c:	00 00 00 
  803e7f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803e82:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e85:	bf 09 00 00 00       	mov    $0x9,%edi
  803e8a:	48 b8 4c 3a 80 00 00 	movabs $0x803a4c,%rax
  803e91:	00 00 00 
  803e94:	ff d0                	callq  *%rax
}
  803e96:	c9                   	leaveq 
  803e97:	c3                   	retq   

0000000000803e98 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e98:	55                   	push   %rbp
  803e99:	48 89 e5             	mov    %rsp,%rbp
  803e9c:	53                   	push   %rbx
  803e9d:	48 83 ec 38          	sub    $0x38,%rsp
  803ea1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ea5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ea9:	48 89 c7             	mov    %rax,%rdi
  803eac:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  803eb3:	00 00 00 
  803eb6:	ff d0                	callq  *%rax
  803eb8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ebf:	0f 88 bf 01 00 00    	js     804084 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ec5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ec9:	ba 07 04 00 00       	mov    $0x407,%edx
  803ece:	48 89 c6             	mov    %rax,%rsi
  803ed1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed6:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803edd:	00 00 00 
  803ee0:	ff d0                	callq  *%rax
  803ee2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ee5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ee9:	0f 88 95 01 00 00    	js     804084 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803eef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803ef3:	48 89 c7             	mov    %rax,%rdi
  803ef6:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  803efd:	00 00 00 
  803f00:	ff d0                	callq  *%rax
  803f02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f09:	0f 88 5d 01 00 00    	js     80406c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f0f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f13:	ba 07 04 00 00       	mov    $0x407,%edx
  803f18:	48 89 c6             	mov    %rax,%rsi
  803f1b:	bf 00 00 00 00       	mov    $0x0,%edi
  803f20:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803f27:	00 00 00 
  803f2a:	ff d0                	callq  *%rax
  803f2c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f33:	0f 88 33 01 00 00    	js     80406c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f3d:	48 89 c7             	mov    %rax,%rdi
  803f40:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  803f47:	00 00 00 
  803f4a:	ff d0                	callq  *%rax
  803f4c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f54:	ba 07 04 00 00       	mov    $0x407,%edx
  803f59:	48 89 c6             	mov    %rax,%rsi
  803f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803f61:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  803f68:	00 00 00 
  803f6b:	ff d0                	callq  *%rax
  803f6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f74:	0f 88 d9 00 00 00    	js     804053 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7e:	48 89 c7             	mov    %rax,%rdi
  803f81:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
  803f8d:	48 89 c2             	mov    %rax,%rdx
  803f90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f94:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f9a:	48 89 d1             	mov    %rdx,%rcx
  803f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  803fa2:	48 89 c6             	mov    %rax,%rsi
  803fa5:	bf 00 00 00 00       	mov    $0x0,%edi
  803faa:	48 b8 88 1a 80 00 00 	movabs $0x801a88,%rax
  803fb1:	00 00 00 
  803fb4:	ff d0                	callq  *%rax
  803fb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fbd:	78 79                	js     804038 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803fbf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc3:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fca:	00 00 00 
  803fcd:	8b 12                	mov    (%rdx),%edx
  803fcf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803fdc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe0:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fe7:	00 00 00 
  803fea:	8b 12                	mov    (%rdx),%edx
  803fec:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803fee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ff9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ffd:	48 89 c7             	mov    %rax,%rdi
  804000:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  804007:	00 00 00 
  80400a:	ff d0                	callq  *%rax
  80400c:	89 c2                	mov    %eax,%edx
  80400e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804012:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804014:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804018:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80401c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804020:	48 89 c7             	mov    %rax,%rdi
  804023:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  80402a:	00 00 00 
  80402d:	ff d0                	callq  *%rax
  80402f:	89 03                	mov    %eax,(%rbx)
	return 0;
  804031:	b8 00 00 00 00       	mov    $0x0,%eax
  804036:	eb 4f                	jmp    804087 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804038:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  804039:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403d:	48 89 c6             	mov    %rax,%rsi
  804040:	bf 00 00 00 00       	mov    $0x0,%edi
  804045:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80404c:	00 00 00 
  80404f:	ff d0                	callq  *%rax
  804051:	eb 01                	jmp    804054 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804053:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804054:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804058:	48 89 c6             	mov    %rax,%rsi
  80405b:	bf 00 00 00 00       	mov    $0x0,%edi
  804060:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  804067:	00 00 00 
  80406a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  80406c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804070:	48 89 c6             	mov    %rax,%rsi
  804073:	bf 00 00 00 00       	mov    $0x0,%edi
  804078:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80407f:	00 00 00 
  804082:	ff d0                	callq  *%rax
    err:
	return r;
  804084:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804087:	48 83 c4 38          	add    $0x38,%rsp
  80408b:	5b                   	pop    %rbx
  80408c:	5d                   	pop    %rbp
  80408d:	c3                   	retq   

000000000080408e <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80408e:	55                   	push   %rbp
  80408f:	48 89 e5             	mov    %rsp,%rbp
  804092:	53                   	push   %rbx
  804093:	48 83 ec 28          	sub    $0x28,%rsp
  804097:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80409b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80409f:	eb 01                	jmp    8040a2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  8040a1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8040a2:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  8040a9:	00 00 00 
  8040ac:	48 8b 00             	mov    (%rax),%rax
  8040af:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8040b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040bc:	48 89 c7             	mov    %rax,%rdi
  8040bf:	48 b8 1c 49 80 00 00 	movabs $0x80491c,%rax
  8040c6:	00 00 00 
  8040c9:	ff d0                	callq  *%rax
  8040cb:	89 c3                	mov    %eax,%ebx
  8040cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d1:	48 89 c7             	mov    %rax,%rdi
  8040d4:	48 b8 1c 49 80 00 00 	movabs $0x80491c,%rax
  8040db:	00 00 00 
  8040de:	ff d0                	callq  *%rax
  8040e0:	39 c3                	cmp    %eax,%ebx
  8040e2:	0f 94 c0             	sete   %al
  8040e5:	0f b6 c0             	movzbl %al,%eax
  8040e8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8040eb:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  8040f2:	00 00 00 
  8040f5:	48 8b 00             	mov    (%rax),%rax
  8040f8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8040fe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804101:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804104:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804107:	75 0a                	jne    804113 <_pipeisclosed+0x85>
			return ret;
  804109:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  80410c:	48 83 c4 28          	add    $0x28,%rsp
  804110:	5b                   	pop    %rbx
  804111:	5d                   	pop    %rbp
  804112:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804113:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804116:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804119:	74 86                	je     8040a1 <_pipeisclosed+0x13>
  80411b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80411f:	75 80                	jne    8040a1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804121:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  804128:	00 00 00 
  80412b:	48 8b 00             	mov    (%rax),%rax
  80412e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804134:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804137:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413a:	89 c6                	mov    %eax,%esi
  80413c:	48 bf 62 51 80 00 00 	movabs $0x805162,%rdi
  804143:	00 00 00 
  804146:	b8 00 00 00 00       	mov    $0x0,%eax
  80414b:	49 b8 43 05 80 00 00 	movabs $0x800543,%r8
  804152:	00 00 00 
  804155:	41 ff d0             	callq  *%r8
	}
  804158:	e9 44 ff ff ff       	jmpq   8040a1 <_pipeisclosed+0x13>

000000000080415d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  80415d:	55                   	push   %rbp
  80415e:	48 89 e5             	mov    %rsp,%rbp
  804161:	48 83 ec 30          	sub    $0x30,%rsp
  804165:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804168:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80416c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80416f:	48 89 d6             	mov    %rdx,%rsi
  804172:	89 c7                	mov    %eax,%edi
  804174:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  80417b:	00 00 00 
  80417e:	ff d0                	callq  *%rax
  804180:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804183:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804187:	79 05                	jns    80418e <pipeisclosed+0x31>
		return r;
  804189:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418c:	eb 31                	jmp    8041bf <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80418e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804192:	48 89 c7             	mov    %rax,%rdi
  804195:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  80419c:	00 00 00 
  80419f:	ff d0                	callq  *%rax
  8041a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8041a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041ad:	48 89 d6             	mov    %rdx,%rsi
  8041b0:	48 89 c7             	mov    %rax,%rdi
  8041b3:	48 b8 8e 40 80 00 00 	movabs $0x80408e,%rax
  8041ba:	00 00 00 
  8041bd:	ff d0                	callq  *%rax
}
  8041bf:	c9                   	leaveq 
  8041c0:	c3                   	retq   

00000000008041c1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041c1:	55                   	push   %rbp
  8041c2:	48 89 e5             	mov    %rsp,%rbp
  8041c5:	48 83 ec 40          	sub    $0x40,%rsp
  8041c9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041cd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8041d1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8041d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d9:	48 89 c7             	mov    %rax,%rdi
  8041dc:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8041e3:	00 00 00 
  8041e6:	ff d0                	callq  *%rax
  8041e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041f0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041f4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041fb:	00 
  8041fc:	e9 97 00 00 00       	jmpq   804298 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804201:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804206:	74 09                	je     804211 <devpipe_read+0x50>
				return i;
  804208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80420c:	e9 95 00 00 00       	jmpq   8042a6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804215:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804219:	48 89 d6             	mov    %rdx,%rsi
  80421c:	48 89 c7             	mov    %rax,%rdi
  80421f:	48 b8 8e 40 80 00 00 	movabs $0x80408e,%rax
  804226:	00 00 00 
  804229:	ff d0                	callq  *%rax
  80422b:	85 c0                	test   %eax,%eax
  80422d:	74 07                	je     804236 <devpipe_read+0x75>
				return 0;
  80422f:	b8 00 00 00 00       	mov    $0x0,%eax
  804234:	eb 70                	jmp    8042a6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804236:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
  804242:	eb 01                	jmp    804245 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804244:	90                   	nop
  804245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804249:	8b 10                	mov    (%rax),%edx
  80424b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424f:	8b 40 04             	mov    0x4(%rax),%eax
  804252:	39 c2                	cmp    %eax,%edx
  804254:	74 ab                	je     804201 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804256:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80425a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80425e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804262:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804266:	8b 00                	mov    (%rax),%eax
  804268:	89 c2                	mov    %eax,%edx
  80426a:	c1 fa 1f             	sar    $0x1f,%edx
  80426d:	c1 ea 1b             	shr    $0x1b,%edx
  804270:	01 d0                	add    %edx,%eax
  804272:	83 e0 1f             	and    $0x1f,%eax
  804275:	29 d0                	sub    %edx,%eax
  804277:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80427b:	48 98                	cltq   
  80427d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804282:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804288:	8b 00                	mov    (%rax),%eax
  80428a:	8d 50 01             	lea    0x1(%rax),%edx
  80428d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804291:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804293:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80429c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042a0:	72 a2                	jb     804244 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8042a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8042a6:	c9                   	leaveq 
  8042a7:	c3                   	retq   

00000000008042a8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042a8:	55                   	push   %rbp
  8042a9:	48 89 e5             	mov    %rsp,%rbp
  8042ac:	48 83 ec 40          	sub    $0x40,%rsp
  8042b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042b8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8042bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042c0:	48 89 c7             	mov    %rax,%rdi
  8042c3:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8042ca:	00 00 00 
  8042cd:	ff d0                	callq  *%rax
  8042cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8042d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8042db:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8042e2:	00 
  8042e3:	e9 93 00 00 00       	jmpq   80437b <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8042e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f0:	48 89 d6             	mov    %rdx,%rsi
  8042f3:	48 89 c7             	mov    %rax,%rdi
  8042f6:	48 b8 8e 40 80 00 00 	movabs $0x80408e,%rax
  8042fd:	00 00 00 
  804300:	ff d0                	callq  *%rax
  804302:	85 c0                	test   %eax,%eax
  804304:	74 07                	je     80430d <devpipe_write+0x65>
				return 0;
  804306:	b8 00 00 00 00       	mov    $0x0,%eax
  80430b:	eb 7c                	jmp    804389 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80430d:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  804314:	00 00 00 
  804317:	ff d0                	callq  *%rax
  804319:	eb 01                	jmp    80431c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80431b:	90                   	nop
  80431c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804320:	8b 40 04             	mov    0x4(%rax),%eax
  804323:	48 63 d0             	movslq %eax,%rdx
  804326:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80432a:	8b 00                	mov    (%rax),%eax
  80432c:	48 98                	cltq   
  80432e:	48 83 c0 20          	add    $0x20,%rax
  804332:	48 39 c2             	cmp    %rax,%rdx
  804335:	73 b1                	jae    8042e8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80433b:	8b 40 04             	mov    0x4(%rax),%eax
  80433e:	89 c2                	mov    %eax,%edx
  804340:	c1 fa 1f             	sar    $0x1f,%edx
  804343:	c1 ea 1b             	shr    $0x1b,%edx
  804346:	01 d0                	add    %edx,%eax
  804348:	83 e0 1f             	and    $0x1f,%eax
  80434b:	29 d0                	sub    %edx,%eax
  80434d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804351:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804355:	48 01 ca             	add    %rcx,%rdx
  804358:	0f b6 0a             	movzbl (%rdx),%ecx
  80435b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80435f:	48 98                	cltq   
  804361:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804365:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804369:	8b 40 04             	mov    0x4(%rax),%eax
  80436c:	8d 50 01             	lea    0x1(%rax),%edx
  80436f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804373:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804376:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80437b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80437f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804383:	72 96                	jb     80431b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804385:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804389:	c9                   	leaveq 
  80438a:	c3                   	retq   

000000000080438b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80438b:	55                   	push   %rbp
  80438c:	48 89 e5             	mov    %rsp,%rbp
  80438f:	48 83 ec 20          	sub    $0x20,%rsp
  804393:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804397:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80439b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80439f:	48 89 c7             	mov    %rax,%rdi
  8043a2:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  8043a9:	00 00 00 
  8043ac:	ff d0                	callq  *%rax
  8043ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8043b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043b6:	48 be 75 51 80 00 00 	movabs $0x805175,%rsi
  8043bd:	00 00 00 
  8043c0:	48 89 c7             	mov    %rax,%rdi
  8043c3:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  8043ca:	00 00 00 
  8043cd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8043cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043d3:	8b 50 04             	mov    0x4(%rax),%edx
  8043d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043da:	8b 00                	mov    (%rax),%eax
  8043dc:	29 c2                	sub    %eax,%edx
  8043de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8043e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043ec:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8043f3:	00 00 00 
	stat->st_dev = &devpipe;
  8043f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043fa:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804401:	00 00 00 
  804404:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  80440b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804410:	c9                   	leaveq 
  804411:	c3                   	retq   

0000000000804412 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804412:	55                   	push   %rbp
  804413:	48 89 e5             	mov    %rsp,%rbp
  804416:	48 83 ec 10          	sub    $0x10,%rsp
  80441a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80441e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804422:	48 89 c6             	mov    %rax,%rsi
  804425:	bf 00 00 00 00       	mov    $0x0,%edi
  80442a:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  804431:	00 00 00 
  804434:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80443a:	48 89 c7             	mov    %rax,%rdi
  80443d:	48 b8 9b 1d 80 00 00 	movabs $0x801d9b,%rax
  804444:	00 00 00 
  804447:	ff d0                	callq  *%rax
  804449:	48 89 c6             	mov    %rax,%rsi
  80444c:	bf 00 00 00 00       	mov    $0x0,%edi
  804451:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  804458:	00 00 00 
  80445b:	ff d0                	callq  *%rax
}
  80445d:	c9                   	leaveq 
  80445e:	c3                   	retq   
	...

0000000000804460 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804460:	55                   	push   %rbp
  804461:	48 89 e5             	mov    %rsp,%rbp
  804464:	48 83 ec 20          	sub    $0x20,%rsp
  804468:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80446b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80446e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804471:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804475:	be 01 00 00 00       	mov    $0x1,%esi
  80447a:	48 89 c7             	mov    %rax,%rdi
  80447d:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  804484:	00 00 00 
  804487:	ff d0                	callq  *%rax
}
  804489:	c9                   	leaveq 
  80448a:	c3                   	retq   

000000000080448b <getchar>:

int
getchar(void)
{
  80448b:	55                   	push   %rbp
  80448c:	48 89 e5             	mov    %rsp,%rbp
  80448f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804493:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804497:	ba 01 00 00 00       	mov    $0x1,%edx
  80449c:	48 89 c6             	mov    %rax,%rsi
  80449f:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a4:	48 b8 90 22 80 00 00 	movabs $0x802290,%rax
  8044ab:	00 00 00 
  8044ae:	ff d0                	callq  *%rax
  8044b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b7:	79 05                	jns    8044be <getchar+0x33>
		return r;
  8044b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044bc:	eb 14                	jmp    8044d2 <getchar+0x47>
	if (r < 1)
  8044be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044c2:	7f 07                	jg     8044cb <getchar+0x40>
		return -E_EOF;
  8044c4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8044c9:	eb 07                	jmp    8044d2 <getchar+0x47>
	return c;
  8044cb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8044cf:	0f b6 c0             	movzbl %al,%eax
}
  8044d2:	c9                   	leaveq 
  8044d3:	c3                   	retq   

00000000008044d4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8044d4:	55                   	push   %rbp
  8044d5:	48 89 e5             	mov    %rsp,%rbp
  8044d8:	48 83 ec 20          	sub    $0x20,%rsp
  8044dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8044df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8044e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044e6:	48 89 d6             	mov    %rdx,%rsi
  8044e9:	89 c7                	mov    %eax,%edi
  8044eb:	48 b8 5e 1e 80 00 00 	movabs $0x801e5e,%rax
  8044f2:	00 00 00 
  8044f5:	ff d0                	callq  *%rax
  8044f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044fe:	79 05                	jns    804505 <iscons+0x31>
		return r;
  804500:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804503:	eb 1a                	jmp    80451f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804505:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804509:	8b 10                	mov    (%rax),%edx
  80450b:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804512:	00 00 00 
  804515:	8b 00                	mov    (%rax),%eax
  804517:	39 c2                	cmp    %eax,%edx
  804519:	0f 94 c0             	sete   %al
  80451c:	0f b6 c0             	movzbl %al,%eax
}
  80451f:	c9                   	leaveq 
  804520:	c3                   	retq   

0000000000804521 <opencons>:

int
opencons(void)
{
  804521:	55                   	push   %rbp
  804522:	48 89 e5             	mov    %rsp,%rbp
  804525:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804529:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80452d:	48 89 c7             	mov    %rax,%rdi
  804530:	48 b8 c6 1d 80 00 00 	movabs $0x801dc6,%rax
  804537:	00 00 00 
  80453a:	ff d0                	callq  *%rax
  80453c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80453f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804543:	79 05                	jns    80454a <opencons+0x29>
		return r;
  804545:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804548:	eb 5b                	jmp    8045a5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80454a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454e:	ba 07 04 00 00       	mov    $0x407,%edx
  804553:	48 89 c6             	mov    %rax,%rsi
  804556:	bf 00 00 00 00       	mov    $0x0,%edi
  80455b:	48 b8 38 1a 80 00 00 	movabs $0x801a38,%rax
  804562:	00 00 00 
  804565:	ff d0                	callq  *%rax
  804567:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80456a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456e:	79 05                	jns    804575 <opencons+0x54>
		return r;
  804570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804573:	eb 30                	jmp    8045a5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804579:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804580:	00 00 00 
  804583:	8b 12                	mov    (%rdx),%edx
  804585:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804587:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80458b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804596:	48 89 c7             	mov    %rax,%rdi
  804599:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  8045a0:	00 00 00 
  8045a3:	ff d0                	callq  *%rax
}
  8045a5:	c9                   	leaveq 
  8045a6:	c3                   	retq   

00000000008045a7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045a7:	55                   	push   %rbp
  8045a8:	48 89 e5             	mov    %rsp,%rbp
  8045ab:	48 83 ec 30          	sub    $0x30,%rsp
  8045af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045bb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8045c0:	75 13                	jne    8045d5 <devcons_read+0x2e>
		return 0;
  8045c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c7:	eb 49                	jmp    804612 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8045c9:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  8045d0:	00 00 00 
  8045d3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8045d5:	48 b8 3a 19 80 00 00 	movabs $0x80193a,%rax
  8045dc:	00 00 00 
  8045df:	ff d0                	callq  *%rax
  8045e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045e8:	74 df                	je     8045c9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8045ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ee:	79 05                	jns    8045f5 <devcons_read+0x4e>
		return c;
  8045f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f3:	eb 1d                	jmp    804612 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8045f5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8045f9:	75 07                	jne    804602 <devcons_read+0x5b>
		return 0;
  8045fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804600:	eb 10                	jmp    804612 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804605:	89 c2                	mov    %eax,%edx
  804607:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80460b:	88 10                	mov    %dl,(%rax)
	return 1;
  80460d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804612:	c9                   	leaveq 
  804613:	c3                   	retq   

0000000000804614 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804614:	55                   	push   %rbp
  804615:	48 89 e5             	mov    %rsp,%rbp
  804618:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80461f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804626:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80462d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804634:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80463b:	eb 77                	jmp    8046b4 <devcons_write+0xa0>
		m = n - tot;
  80463d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804644:	89 c2                	mov    %eax,%edx
  804646:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804649:	89 d1                	mov    %edx,%ecx
  80464b:	29 c1                	sub    %eax,%ecx
  80464d:	89 c8                	mov    %ecx,%eax
  80464f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804652:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804655:	83 f8 7f             	cmp    $0x7f,%eax
  804658:	76 07                	jbe    804661 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80465a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804661:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804664:	48 63 d0             	movslq %eax,%rdx
  804667:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80466a:	48 98                	cltq   
  80466c:	48 89 c1             	mov    %rax,%rcx
  80466f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804676:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80467d:	48 89 ce             	mov    %rcx,%rsi
  804680:	48 89 c7             	mov    %rax,%rdi
  804683:	48 b8 22 14 80 00 00 	movabs $0x801422,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80468f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804692:	48 63 d0             	movslq %eax,%rdx
  804695:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80469c:	48 89 d6             	mov    %rdx,%rsi
  80469f:	48 89 c7             	mov    %rax,%rdi
  8046a2:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  8046a9:	00 00 00 
  8046ac:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046b1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b7:	48 98                	cltq   
  8046b9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8046c0:	0f 82 77 ff ff ff    	jb     80463d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8046c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8046c9:	c9                   	leaveq 
  8046ca:	c3                   	retq   

00000000008046cb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8046cb:	55                   	push   %rbp
  8046cc:	48 89 e5             	mov    %rsp,%rbp
  8046cf:	48 83 ec 08          	sub    $0x8,%rsp
  8046d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8046d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046dc:	c9                   	leaveq 
  8046dd:	c3                   	retq   

00000000008046de <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8046de:	55                   	push   %rbp
  8046df:	48 89 e5             	mov    %rsp,%rbp
  8046e2:	48 83 ec 10          	sub    $0x10,%rsp
  8046e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8046ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f2:	48 be 81 51 80 00 00 	movabs $0x805181,%rsi
  8046f9:	00 00 00 
  8046fc:	48 89 c7             	mov    %rax,%rdi
  8046ff:	48 b8 00 11 80 00 00 	movabs $0x801100,%rax
  804706:	00 00 00 
  804709:	ff d0                	callq  *%rax
	return 0;
  80470b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804710:	c9                   	leaveq 
  804711:	c3                   	retq   
	...

0000000000804714 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804714:	55                   	push   %rbp
  804715:	48 89 e5             	mov    %rsp,%rbp
  804718:	48 83 ec 30          	sub    $0x30,%rsp
  80471c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804720:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804724:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804728:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80472d:	74 18                	je     804747 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80472f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804733:	48 89 c7             	mov    %rax,%rdi
  804736:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  80473d:	00 00 00 
  804740:	ff d0                	callq  *%rax
  804742:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804745:	eb 19                	jmp    804760 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  804747:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80474e:	00 00 00 
  804751:	48 b8 61 1c 80 00 00 	movabs $0x801c61,%rax
  804758:	00 00 00 
  80475b:	ff d0                	callq  *%rax
  80475d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804764:	79 19                	jns    80477f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  804766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80476a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804774:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80477a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80477d:	eb 53                	jmp    8047d2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80477f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804784:	74 19                	je     80479f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  804786:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  80478d:	00 00 00 
  804790:	48 8b 00             	mov    (%rax),%rax
  804793:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80479d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80479f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047a4:	74 19                	je     8047bf <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8047a6:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  8047ad:	00 00 00 
  8047b0:	48 8b 00             	mov    (%rax),%rax
  8047b3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047bd:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8047bf:	48 b8 48 80 80 00 00 	movabs $0x808048,%rax
  8047c6:	00 00 00 
  8047c9:	48 8b 00             	mov    (%rax),%rax
  8047cc:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8047d2:	c9                   	leaveq 
  8047d3:	c3                   	retq   

00000000008047d4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8047d4:	55                   	push   %rbp
  8047d5:	48 89 e5             	mov    %rsp,%rbp
  8047d8:	48 83 ec 30          	sub    $0x30,%rsp
  8047dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8047df:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8047e2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8047e6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8047e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8047f0:	e9 96 00 00 00       	jmpq   80488b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8047f5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047fa:	74 20                	je     80481c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8047fc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8047ff:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804802:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804806:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804809:	89 c7                	mov    %eax,%edi
  80480b:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  804812:	00 00 00 
  804815:	ff d0                	callq  *%rax
  804817:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80481a:	eb 2d                	jmp    804849 <ipc_send+0x75>
		else if(pg==NULL)
  80481c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804821:	75 26                	jne    804849 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  804823:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804826:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80482e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804835:	00 00 00 
  804838:	89 c7                	mov    %eax,%edi
  80483a:	48 b8 0c 1c 80 00 00 	movabs $0x801c0c,%rax
  804841:	00 00 00 
  804844:	ff d0                	callq  *%rax
  804846:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804849:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80484d:	79 30                	jns    80487f <ipc_send+0xab>
  80484f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804853:	74 2a                	je     80487f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804855:	48 ba 88 51 80 00 00 	movabs $0x805188,%rdx
  80485c:	00 00 00 
  80485f:	be 40 00 00 00       	mov    $0x40,%esi
  804864:	48 bf a0 51 80 00 00 	movabs $0x8051a0,%rdi
  80486b:	00 00 00 
  80486e:	b8 00 00 00 00       	mov    $0x0,%eax
  804873:	48 b9 08 03 80 00 00 	movabs $0x800308,%rcx
  80487a:	00 00 00 
  80487d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80487f:	48 b8 fa 19 80 00 00 	movabs $0x8019fa,%rax
  804886:	00 00 00 
  804889:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80488b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80488f:	0f 85 60 ff ff ff    	jne    8047f5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804895:	c9                   	leaveq 
  804896:	c3                   	retq   

0000000000804897 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804897:	55                   	push   %rbp
  804898:	48 89 e5             	mov    %rsp,%rbp
  80489b:	48 83 ec 18          	sub    $0x18,%rsp
  80489f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  8048a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8048a9:	eb 5e                	jmp    804909 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8048ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048b2:	00 00 00 
  8048b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048b8:	48 63 d0             	movslq %eax,%rdx
  8048bb:	48 89 d0             	mov    %rdx,%rax
  8048be:	48 c1 e0 03          	shl    $0x3,%rax
  8048c2:	48 01 d0             	add    %rdx,%rax
  8048c5:	48 c1 e0 05          	shl    $0x5,%rax
  8048c9:	48 01 c8             	add    %rcx,%rax
  8048cc:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8048d2:	8b 00                	mov    (%rax),%eax
  8048d4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8048d7:	75 2c                	jne    804905 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8048d9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8048e0:	00 00 00 
  8048e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048e6:	48 63 d0             	movslq %eax,%rdx
  8048e9:	48 89 d0             	mov    %rdx,%rax
  8048ec:	48 c1 e0 03          	shl    $0x3,%rax
  8048f0:	48 01 d0             	add    %rdx,%rax
  8048f3:	48 c1 e0 05          	shl    $0x5,%rax
  8048f7:	48 01 c8             	add    %rcx,%rax
  8048fa:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804900:	8b 40 08             	mov    0x8(%rax),%eax
  804903:	eb 12                	jmp    804917 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804905:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804909:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804910:	7e 99                	jle    8048ab <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804912:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804917:	c9                   	leaveq 
  804918:	c3                   	retq   
  804919:	00 00                	add    %al,(%rax)
	...

000000000080491c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80491c:	55                   	push   %rbp
  80491d:	48 89 e5             	mov    %rsp,%rbp
  804920:	48 83 ec 18          	sub    $0x18,%rsp
  804924:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80492c:	48 89 c2             	mov    %rax,%rdx
  80492f:	48 c1 ea 15          	shr    $0x15,%rdx
  804933:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80493a:	01 00 00 
  80493d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804941:	83 e0 01             	and    $0x1,%eax
  804944:	48 85 c0             	test   %rax,%rax
  804947:	75 07                	jne    804950 <pageref+0x34>
		return 0;
  804949:	b8 00 00 00 00       	mov    $0x0,%eax
  80494e:	eb 53                	jmp    8049a3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804954:	48 89 c2             	mov    %rax,%rdx
  804957:	48 c1 ea 0c          	shr    $0xc,%rdx
  80495b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804962:	01 00 00 
  804965:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804969:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80496d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804971:	83 e0 01             	and    $0x1,%eax
  804974:	48 85 c0             	test   %rax,%rax
  804977:	75 07                	jne    804980 <pageref+0x64>
		return 0;
  804979:	b8 00 00 00 00       	mov    $0x0,%eax
  80497e:	eb 23                	jmp    8049a3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804980:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804984:	48 89 c2             	mov    %rax,%rdx
  804987:	48 c1 ea 0c          	shr    $0xc,%rdx
  80498b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804992:	00 00 00 
  804995:	48 c1 e2 04          	shl    $0x4,%rdx
  804999:	48 01 d0             	add    %rdx,%rax
  80499c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8049a0:	0f b7 c0             	movzwl %ax,%eax
}
  8049a3:	c9                   	leaveq 
  8049a4:	c3                   	retq   
