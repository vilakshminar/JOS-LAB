
obj/user/pingpongs.debug:     file format elf64-x86-64


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
  80003c:	e8 bb 01 00 00       	callq  8001fc <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	41 56                	push   %r14
  80004a:	41 55                	push   %r13
  80004c:	41 54                	push   %r12
  80004e:	53                   	push   %rbx
  80004f:	48 83 ec 20          	sub    $0x20,%rsp
  800053:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800056:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	envid_t who;
	uint32_t i;

	i = 0;
  80005a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
	if ((who = sfork()) != 0) {
  800061:	48 b8 b4 22 80 00 00 	movabs $0x8022b4,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 d8             	mov    %eax,-0x28(%rbp)
  800070:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800073:	85 c0                	test   %eax,%eax
  800075:	0f 84 8a 00 00 00    	je     800105 <umain+0xc1>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  80007b:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800082:	00 00 00 
  800085:	48 8b 18             	mov    (%rax),%rbx
  800088:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80008f:	00 00 00 
  800092:	ff d0                	callq  *%rax
  800094:	48 89 da             	mov    %rbx,%rdx
  800097:	89 c6                	mov    %eax,%esi
  800099:	48 bf 80 45 80 00 00 	movabs $0x804580,%rdi
  8000a0:	00 00 00 
  8000a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a8:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  8000af:	00 00 00 
  8000b2:	ff d1                	callq  *%rcx
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000b4:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  8000b7:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8000be:	00 00 00 
  8000c1:	ff d0                	callq  *%rax
  8000c3:	89 da                	mov    %ebx,%edx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	48 bf 9a 45 80 00 00 	movabs $0x80459a,%rdi
  8000ce:	00 00 00 
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  8000dd:	00 00 00 
  8000e0:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  8000e2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ef:	be 00 00 00 00       	mov    $0x0,%esi
  8000f4:	89 c7                	mov    %eax,%edi
  8000f6:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	eb 01                	jmp    800105 <umain+0xc1>
			return;
		++val;
		ipc_send(who, 0, 0, 0);
		if (val == 10)
			return;
	}
  800104:	90                   	nop
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800105:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800109:	ba 00 00 00 00       	mov    $0x0,%edx
  80010e:	be 00 00 00 00       	mov    $0x0,%esi
  800113:	48 89 c7             	mov    %rax,%rdi
  800116:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  80011d:	00 00 00 
  800120:	ff d0                	callq  *%rax
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800122:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800129:	00 00 00 
  80012c:	48 8b 00             	mov    (%rax),%rax
  80012f:	44 8b b0 c8 00 00 00 	mov    0xc8(%rax),%r14d
  800136:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80013d:	00 00 00 
  800140:	4c 8b 28             	mov    (%rax),%r13
  800143:	44 8b 65 d8          	mov    -0x28(%rbp),%r12d
  800147:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80014e:	00 00 00 
  800151:	8b 18                	mov    (%rax),%ebx
  800153:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax
  80015f:	45 89 f1             	mov    %r14d,%r9d
  800162:	4d 89 e8             	mov    %r13,%r8
  800165:	44 89 e1             	mov    %r12d,%ecx
  800168:	89 da                	mov    %ebx,%edx
  80016a:	89 c6                	mov    %eax,%esi
  80016c:	48 bf b0 45 80 00 00 	movabs $0x8045b0,%rdi
  800173:	00 00 00 
  800176:	b8 00 00 00 00       	mov    $0x0,%eax
  80017b:	49 ba eb 03 80 00 00 	movabs $0x8003eb,%r10
  800182:	00 00 00 
  800185:	41 ff d2             	callq  *%r10
		if (val == 10)
  800188:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80018f:	00 00 00 
  800192:	8b 00                	mov    (%rax),%eax
  800194:	83 f8 0a             	cmp    $0xa,%eax
  800197:	74 52                	je     8001eb <umain+0x1a7>
			return;
		++val;
  800199:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001a0:	00 00 00 
  8001a3:	8b 00                	mov    (%rax),%eax
  8001a5:	8d 50 01             	lea    0x1(%rax),%edx
  8001a8:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001af:	00 00 00 
  8001b2:	89 10                	mov    %edx,(%rax)
		ipc_send(who, 0, 0, 0);
  8001b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8001b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c1:	be 00 00 00 00       	mov    $0x0,%esi
  8001c6:	89 c7                	mov    %eax,%edi
  8001c8:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
		if (val == 10)
  8001d4:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001db:	00 00 00 
  8001de:	8b 00                	mov    (%rax),%eax
  8001e0:	83 f8 0a             	cmp    $0xa,%eax
  8001e3:	0f 85 1b ff ff ff    	jne    800104 <umain+0xc0>
			return;
  8001e9:	eb 01                	jmp    8001ec <umain+0x1a8>

	while (1) {
		ipc_recv(&who, 0, 0);
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
		if (val == 10)
			return;
  8001eb:	90                   	nop
		ipc_send(who, 0, 0, 0);
		if (val == 10)
			return;
	}

}
  8001ec:	48 83 c4 20          	add    $0x20,%rsp
  8001f0:	5b                   	pop    %rbx
  8001f1:	41 5c                	pop    %r12
  8001f3:	41 5d                	pop    %r13
  8001f5:	41 5e                	pop    %r14
  8001f7:	5d                   	pop    %rbp
  8001f8:	c3                   	retq   
  8001f9:	00 00                	add    %al,(%rax)
	...

00000000008001fc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001fc:	55                   	push   %rbp
  8001fd:	48 89 e5             	mov    %rsp,%rbp
  800200:	48 83 ec 10          	sub    $0x10,%rsp
  800204:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800207:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80020b:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800212:	00 00 00 
  800215:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80021c:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  800223:	00 00 00 
  800226:	ff d0                	callq  *%rax
  800228:	48 98                	cltq   
  80022a:	48 89 c2             	mov    %rax,%rdx
  80022d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800233:	48 89 d0             	mov    %rdx,%rax
  800236:	48 c1 e0 03          	shl    $0x3,%rax
  80023a:	48 01 d0             	add    %rdx,%rax
  80023d:	48 c1 e0 05          	shl    $0x5,%rax
  800241:	48 89 c2             	mov    %rax,%rdx
  800244:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80024b:	00 00 00 
  80024e:	48 01 c2             	add    %rax,%rdx
  800251:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800258:	00 00 00 
  80025b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800262:	7e 14                	jle    800278 <libmain+0x7c>
		binaryname = argv[0];
  800264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800268:	48 8b 10             	mov    (%rax),%rdx
  80026b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800272:	00 00 00 
  800275:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800278:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80027c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80027f:	48 89 d6             	mov    %rdx,%rsi
  800282:	89 c7                	mov    %eax,%edi
  800284:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800290:	48 b8 a0 02 80 00 00 	movabs $0x8002a0,%rax
  800297:	00 00 00 
  80029a:	ff d0                	callq  *%rax
}
  80029c:	c9                   	leaveq 
  80029d:	c3                   	retq   
	...

00000000008002a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002a0:	55                   	push   %rbp
  8002a1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002a4:	48 b8 2d 28 80 00 00 	movabs $0x80282d,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b5:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
}
  8002c1:	5d                   	pop    %rbp
  8002c2:	c3                   	retq   
	...

00000000008002c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002c4:	55                   	push   %rbp
  8002c5:	48 89 e5             	mov    %rsp,%rbp
  8002c8:	48 83 ec 10          	sub    $0x10,%rsp
  8002cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8002d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d7:	8b 00                	mov    (%rax),%eax
  8002d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002dc:	89 d6                	mov    %edx,%esi
  8002de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8002e2:	48 63 d0             	movslq %eax,%rdx
  8002e5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8002ea:	8d 50 01             	lea    0x1(%rax),%edx
  8002ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8002f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002f7:	8b 00                	mov    (%rax),%eax
  8002f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fe:	75 2c                	jne    80032c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800304:	8b 00                	mov    (%rax),%eax
  800306:	48 98                	cltq   
  800308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030c:	48 83 c2 08          	add    $0x8,%rdx
  800310:	48 89 c6             	mov    %rax,%rsi
  800313:	48 89 d7             	mov    %rdx,%rdi
  800316:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
		b->idx = 0;
  800322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800326:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80032c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800330:	8b 40 04             	mov    0x4(%rax),%eax
  800333:	8d 50 01             	lea    0x1(%rax),%edx
  800336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80033a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80033d:	c9                   	leaveq 
  80033e:	c3                   	retq   

000000000080033f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033f:	55                   	push   %rbp
  800340:	48 89 e5             	mov    %rsp,%rbp
  800343:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80034a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800351:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800358:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80035f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800366:	48 8b 0a             	mov    (%rdx),%rcx
  800369:	48 89 08             	mov    %rcx,(%rax)
  80036c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800370:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800374:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800378:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80037c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800383:	00 00 00 
	b.cnt = 0;
  800386:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80038d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800390:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800397:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80039e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003a5:	48 89 c6             	mov    %rax,%rsi
  8003a8:	48 bf c4 02 80 00 00 	movabs $0x8002c4,%rdi
  8003af:	00 00 00 
  8003b2:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  8003b9:	00 00 00 
  8003bc:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8003be:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003c4:	48 98                	cltq   
  8003c6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003cd:	48 83 c2 08          	add    $0x8,%rdx
  8003d1:	48 89 c6             	mov    %rax,%rsi
  8003d4:	48 89 d7             	mov    %rdx,%rdi
  8003d7:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8003e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003e9:	c9                   	leaveq 
  8003ea:	c3                   	retq   

00000000008003eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003f6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003fd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800404:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80040b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800412:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800419:	84 c0                	test   %al,%al
  80041b:	74 20                	je     80043d <cprintf+0x52>
  80041d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800421:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800425:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800429:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80042d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800431:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800435:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800439:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80043d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800444:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80044b:	00 00 00 
  80044e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800455:	00 00 00 
  800458:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80045c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800463:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80046a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800471:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800478:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80047f:	48 8b 0a             	mov    (%rdx),%rcx
  800482:	48 89 08             	mov    %rcx,(%rax)
  800485:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800489:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80048d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800491:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800495:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80049c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004a3:	48 89 d6             	mov    %rdx,%rsi
  8004a6:	48 89 c7             	mov    %rax,%rdi
  8004a9:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  8004b0:	00 00 00 
  8004b3:	ff d0                	callq  *%rax
  8004b5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8004bb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004c1:	c9                   	leaveq 
  8004c2:	c3                   	retq   
	...

00000000008004c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c4:	55                   	push   %rbp
  8004c5:	48 89 e5             	mov    %rsp,%rbp
  8004c8:	48 83 ec 30          	sub    $0x30,%rsp
  8004cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004d8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8004db:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8004df:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8004e6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8004ea:	77 52                	ja     80053e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ec:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8004ef:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004f3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004f6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8004fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800503:	48 f7 75 d0          	divq   -0x30(%rbp)
  800507:	48 89 c2             	mov    %rax,%rdx
  80050a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80050d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800510:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800518:	41 89 f9             	mov    %edi,%r9d
  80051b:	48 89 c7             	mov    %rax,%rdi
  80051e:	48 b8 c4 04 80 00 00 	movabs $0x8004c4,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
  80052a:	eb 1c                	jmp    800548 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80052c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800530:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800533:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800537:	48 89 d6             	mov    %rdx,%rsi
  80053a:	89 c7                	mov    %eax,%edi
  80053c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800542:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800546:	7f e4                	jg     80052c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800548:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80054b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054f:	ba 00 00 00 00       	mov    $0x0,%edx
  800554:	48 f7 f1             	div    %rcx
  800557:	48 89 d0             	mov    %rdx,%rax
  80055a:	48 ba a8 47 80 00 00 	movabs $0x8047a8,%rdx
  800561:	00 00 00 
  800564:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800568:	0f be c0             	movsbl %al,%eax
  80056b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80056f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800573:	48 89 d6             	mov    %rdx,%rsi
  800576:	89 c7                	mov    %eax,%edi
  800578:	ff d1                	callq  *%rcx
}
  80057a:	c9                   	leaveq 
  80057b:	c3                   	retq   

000000000080057c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057c:	55                   	push   %rbp
  80057d:	48 89 e5             	mov    %rsp,%rbp
  800580:	48 83 ec 20          	sub    $0x20,%rsp
  800584:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800588:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80058b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80058f:	7e 52                	jle    8005e3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800595:	8b 00                	mov    (%rax),%eax
  800597:	83 f8 30             	cmp    $0x30,%eax
  80059a:	73 24                	jae    8005c0 <getuint+0x44>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	8b 00                	mov    (%rax),%eax
  8005aa:	89 c0                	mov    %eax,%eax
  8005ac:	48 01 d0             	add    %rdx,%rax
  8005af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b3:	8b 12                	mov    (%rdx),%edx
  8005b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bc:	89 0a                	mov    %ecx,(%rdx)
  8005be:	eb 17                	jmp    8005d7 <getuint+0x5b>
  8005c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c8:	48 89 d0             	mov    %rdx,%rax
  8005cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d7:	48 8b 00             	mov    (%rax),%rax
  8005da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005de:	e9 a3 00 00 00       	jmpq   800686 <getuint+0x10a>
	else if (lflag)
  8005e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005e7:	74 4f                	je     800638 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	83 f8 30             	cmp    $0x30,%eax
  8005f2:	73 24                	jae    800618 <getuint+0x9c>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800600:	8b 00                	mov    (%rax),%eax
  800602:	89 c0                	mov    %eax,%eax
  800604:	48 01 d0             	add    %rdx,%rax
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	8b 12                	mov    (%rdx),%edx
  80060d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	89 0a                	mov    %ecx,(%rdx)
  800616:	eb 17                	jmp    80062f <getuint+0xb3>
  800618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800620:	48 89 d0             	mov    %rdx,%rax
  800623:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800627:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80062f:	48 8b 00             	mov    (%rax),%rax
  800632:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800636:	eb 4e                	jmp    800686 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getuint+0xeb>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getuint+0x102>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	8b 00                	mov    (%rax),%eax
  800680:	89 c0                	mov    %eax,%eax
  800682:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068a:	c9                   	leaveq 
  80068b:	c3                   	retq   

000000000080068c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068c:	55                   	push   %rbp
  80068d:	48 89 e5             	mov    %rsp,%rbp
  800690:	48 83 ec 20          	sub    $0x20,%rsp
  800694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800698:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80069b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80069f:	7e 52                	jle    8006f3 <getint+0x67>
		x=va_arg(*ap, long long);
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	8b 00                	mov    (%rax),%eax
  8006a7:	83 f8 30             	cmp    $0x30,%eax
  8006aa:	73 24                	jae    8006d0 <getint+0x44>
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	8b 00                	mov    (%rax),%eax
  8006ba:	89 c0                	mov    %eax,%eax
  8006bc:	48 01 d0             	add    %rdx,%rax
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	8b 12                	mov    (%rdx),%edx
  8006c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cc:	89 0a                	mov    %ecx,(%rdx)
  8006ce:	eb 17                	jmp    8006e7 <getint+0x5b>
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d8:	48 89 d0             	mov    %rdx,%rax
  8006db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e7:	48 8b 00             	mov    (%rax),%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ee:	e9 a3 00 00 00       	jmpq   800796 <getint+0x10a>
	else if (lflag)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006f7:	74 4f                	je     800748 <getint+0xbc>
		x=va_arg(*ap, long);
  8006f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fd:	8b 00                	mov    (%rax),%eax
  8006ff:	83 f8 30             	cmp    $0x30,%eax
  800702:	73 24                	jae    800728 <getint+0x9c>
  800704:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800708:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	8b 00                	mov    (%rax),%eax
  800712:	89 c0                	mov    %eax,%eax
  800714:	48 01 d0             	add    %rdx,%rax
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	8b 12                	mov    (%rdx),%edx
  80071d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800720:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800724:	89 0a                	mov    %ecx,(%rdx)
  800726:	eb 17                	jmp    80073f <getint+0xb3>
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800730:	48 89 d0             	mov    %rdx,%rax
  800733:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800737:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80073f:	48 8b 00             	mov    (%rax),%rax
  800742:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800746:	eb 4e                	jmp    800796 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	83 f8 30             	cmp    $0x30,%eax
  800751:	73 24                	jae    800777 <getint+0xeb>
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80075b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	89 c0                	mov    %eax,%eax
  800763:	48 01 d0             	add    %rdx,%rax
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	8b 12                	mov    (%rdx),%edx
  80076c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80076f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800773:	89 0a                	mov    %ecx,(%rdx)
  800775:	eb 17                	jmp    80078e <getint+0x102>
  800777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80077b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80077f:	48 89 d0             	mov    %rdx,%rax
  800782:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800786:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80078a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80078e:	8b 00                	mov    (%rax),%eax
  800790:	48 98                	cltq   
  800792:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80079a:	c9                   	leaveq 
  80079b:	c3                   	retq   

000000000080079c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079c:	55                   	push   %rbp
  80079d:	48 89 e5             	mov    %rsp,%rbp
  8007a0:	41 54                	push   %r12
  8007a2:	53                   	push   %rbx
  8007a3:	48 83 ec 60          	sub    $0x60,%rsp
  8007a7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8007ab:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8007af:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007b3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007b7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007bb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007bf:	48 8b 0a             	mov    (%rdx),%rcx
  8007c2:	48 89 08             	mov    %rcx,(%rax)
  8007c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	eb 17                	jmp    8007ee <vprintfmt+0x52>
			if (ch == '\0')
  8007d7:	85 db                	test   %ebx,%ebx
  8007d9:	0f 84 d7 04 00 00    	je     800cb6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8007df:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8007e3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8007e7:	48 89 c6             	mov    %rax,%rsi
  8007ea:	89 df                	mov    %ebx,%edi
  8007ec:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007f2:	0f b6 00             	movzbl (%rax),%eax
  8007f5:	0f b6 d8             	movzbl %al,%ebx
  8007f8:	83 fb 25             	cmp    $0x25,%ebx
  8007fb:	0f 95 c0             	setne  %al
  8007fe:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800803:	84 c0                	test   %al,%al
  800805:	75 d0                	jne    8007d7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800807:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80080b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800812:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800819:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800820:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800827:	eb 04                	jmp    80082d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800829:	90                   	nop
  80082a:	eb 01                	jmp    80082d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80082c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800831:	0f b6 00             	movzbl (%rax),%eax
  800834:	0f b6 d8             	movzbl %al,%ebx
  800837:	89 d8                	mov    %ebx,%eax
  800839:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80083e:	83 e8 23             	sub    $0x23,%eax
  800841:	83 f8 55             	cmp    $0x55,%eax
  800844:	0f 87 38 04 00 00    	ja     800c82 <vprintfmt+0x4e6>
  80084a:	89 c0                	mov    %eax,%eax
  80084c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800853:	00 
  800854:	48 b8 d0 47 80 00 00 	movabs $0x8047d0,%rax
  80085b:	00 00 00 
  80085e:	48 01 d0             	add    %rdx,%rax
  800861:	48 8b 00             	mov    (%rax),%rax
  800864:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800866:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80086a:	eb c1                	jmp    80082d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80086c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800870:	eb bb                	jmp    80082d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800872:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800879:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80087c:	89 d0                	mov    %edx,%eax
  80087e:	c1 e0 02             	shl    $0x2,%eax
  800881:	01 d0                	add    %edx,%eax
  800883:	01 c0                	add    %eax,%eax
  800885:	01 d8                	add    %ebx,%eax
  800887:	83 e8 30             	sub    $0x30,%eax
  80088a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80088d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800891:	0f b6 00             	movzbl (%rax),%eax
  800894:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800897:	83 fb 2f             	cmp    $0x2f,%ebx
  80089a:	7e 63                	jle    8008ff <vprintfmt+0x163>
  80089c:	83 fb 39             	cmp    $0x39,%ebx
  80089f:	7f 5e                	jg     8008ff <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a6:	eb d1                	jmp    800879 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	83 f8 30             	cmp    $0x30,%eax
  8008ae:	73 17                	jae    8008c7 <vprintfmt+0x12b>
  8008b0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b7:	89 c0                	mov    %eax,%eax
  8008b9:	48 01 d0             	add    %rdx,%rax
  8008bc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008bf:	83 c2 08             	add    $0x8,%edx
  8008c2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c5:	eb 0f                	jmp    8008d6 <vprintfmt+0x13a>
  8008c7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 83 c2 08          	add    $0x8,%rdx
  8008d2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008db:	eb 23                	jmp    800900 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8008dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e1:	0f 89 42 ff ff ff    	jns    800829 <vprintfmt+0x8d>
				width = 0;
  8008e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008ee:	e9 36 ff ff ff       	jmpq   800829 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8008f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008fa:	e9 2e ff ff ff       	jmpq   80082d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800900:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800904:	0f 89 22 ff ff ff    	jns    80082c <vprintfmt+0x90>
				width = precision, precision = -1;
  80090a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80090d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800910:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800917:	e9 10 ff ff ff       	jmpq   80082c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800920:	e9 08 ff ff ff       	jmpq   80082d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800925:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800928:	83 f8 30             	cmp    $0x30,%eax
  80092b:	73 17                	jae    800944 <vprintfmt+0x1a8>
  80092d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800931:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800934:	89 c0                	mov    %eax,%eax
  800936:	48 01 d0             	add    %rdx,%rax
  800939:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093c:	83 c2 08             	add    $0x8,%edx
  80093f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800942:	eb 0f                	jmp    800953 <vprintfmt+0x1b7>
  800944:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800948:	48 89 d0             	mov    %rdx,%rax
  80094b:	48 83 c2 08          	add    $0x8,%rdx
  80094f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800953:	8b 00                	mov    (%rax),%eax
  800955:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800959:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  80095d:	48 89 d6             	mov    %rdx,%rsi
  800960:	89 c7                	mov    %eax,%edi
  800962:	ff d1                	callq  *%rcx
			break;
  800964:	e9 47 03 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800969:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096c:	83 f8 30             	cmp    $0x30,%eax
  80096f:	73 17                	jae    800988 <vprintfmt+0x1ec>
  800971:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800975:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800978:	89 c0                	mov    %eax,%eax
  80097a:	48 01 d0             	add    %rdx,%rax
  80097d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800980:	83 c2 08             	add    $0x8,%edx
  800983:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800986:	eb 0f                	jmp    800997 <vprintfmt+0x1fb>
  800988:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098c:	48 89 d0             	mov    %rdx,%rax
  80098f:	48 83 c2 08          	add    $0x8,%rdx
  800993:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800997:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800999:	85 db                	test   %ebx,%ebx
  80099b:	79 02                	jns    80099f <vprintfmt+0x203>
				err = -err;
  80099d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80099f:	83 fb 10             	cmp    $0x10,%ebx
  8009a2:	7f 16                	jg     8009ba <vprintfmt+0x21e>
  8009a4:	48 b8 20 47 80 00 00 	movabs $0x804720,%rax
  8009ab:	00 00 00 
  8009ae:	48 63 d3             	movslq %ebx,%rdx
  8009b1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8009b5:	4d 85 e4             	test   %r12,%r12
  8009b8:	75 2e                	jne    8009e8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  8009ba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009be:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c2:	89 d9                	mov    %ebx,%ecx
  8009c4:	48 ba b9 47 80 00 00 	movabs $0x8047b9,%rdx
  8009cb:	00 00 00 
  8009ce:	48 89 c7             	mov    %rax,%rdi
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	49 b8 c0 0c 80 00 00 	movabs $0x800cc0,%r8
  8009dd:	00 00 00 
  8009e0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e3:	e9 c8 02 00 00       	jmpq   800cb0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009e8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f0:	4c 89 e1             	mov    %r12,%rcx
  8009f3:	48 ba c2 47 80 00 00 	movabs $0x8047c2,%rdx
  8009fa:	00 00 00 
  8009fd:	48 89 c7             	mov    %rax,%rdi
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	49 b8 c0 0c 80 00 00 	movabs $0x800cc0,%r8
  800a0c:	00 00 00 
  800a0f:	41 ff d0             	callq  *%r8
			break;
  800a12:	e9 99 02 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a1a:	83 f8 30             	cmp    $0x30,%eax
  800a1d:	73 17                	jae    800a36 <vprintfmt+0x29a>
  800a1f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a26:	89 c0                	mov    %eax,%eax
  800a28:	48 01 d0             	add    %rdx,%rax
  800a2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2e:	83 c2 08             	add    $0x8,%edx
  800a31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a34:	eb 0f                	jmp    800a45 <vprintfmt+0x2a9>
  800a36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a3a:	48 89 d0             	mov    %rdx,%rax
  800a3d:	48 83 c2 08          	add    $0x8,%rdx
  800a41:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a45:	4c 8b 20             	mov    (%rax),%r12
  800a48:	4d 85 e4             	test   %r12,%r12
  800a4b:	75 0a                	jne    800a57 <vprintfmt+0x2bb>
				p = "(null)";
  800a4d:	49 bc c5 47 80 00 00 	movabs $0x8047c5,%r12
  800a54:	00 00 00 
			if (width > 0 && padc != '-')
  800a57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a5b:	7e 7a                	jle    800ad7 <vprintfmt+0x33b>
  800a5d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a61:	74 74                	je     800ad7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a63:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a66:	48 98                	cltq   
  800a68:	48 89 c6             	mov    %rax,%rsi
  800a6b:	4c 89 e7             	mov    %r12,%rdi
  800a6e:	48 b8 6a 0f 80 00 00 	movabs $0x800f6a,%rax
  800a75:	00 00 00 
  800a78:	ff d0                	callq  *%rax
  800a7a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a7d:	eb 17                	jmp    800a96 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800a7f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800a83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a87:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a8b:	48 89 d6             	mov    %rdx,%rsi
  800a8e:	89 c7                	mov    %eax,%edi
  800a90:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a92:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a96:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a9a:	7f e3                	jg     800a7f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a9c:	eb 39                	jmp    800ad7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800a9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800aa2:	74 1e                	je     800ac2 <vprintfmt+0x326>
  800aa4:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa7:	7e 05                	jle    800aae <vprintfmt+0x312>
  800aa9:	83 fb 7e             	cmp    $0x7e,%ebx
  800aac:	7e 14                	jle    800ac2 <vprintfmt+0x326>
					putch('?', putdat);
  800aae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ab2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ab6:	48 89 c6             	mov    %rax,%rsi
  800ab9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800abe:	ff d2                	callq  *%rdx
  800ac0:	eb 0f                	jmp    800ad1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800ac2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ac6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800aca:	48 89 c6             	mov    %rax,%rsi
  800acd:	89 df                	mov    %ebx,%edi
  800acf:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ad5:	eb 01                	jmp    800ad8 <vprintfmt+0x33c>
  800ad7:	90                   	nop
  800ad8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800add:	0f be d8             	movsbl %al,%ebx
  800ae0:	85 db                	test   %ebx,%ebx
  800ae2:	0f 95 c0             	setne  %al
  800ae5:	49 83 c4 01          	add    $0x1,%r12
  800ae9:	84 c0                	test   %al,%al
  800aeb:	74 28                	je     800b15 <vprintfmt+0x379>
  800aed:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800af1:	78 ab                	js     800a9e <vprintfmt+0x302>
  800af3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800af7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800afb:	79 a1                	jns    800a9e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800afd:	eb 16                	jmp    800b15 <vprintfmt+0x379>
				putch(' ', putdat);
  800aff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b03:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b07:	48 89 c6             	mov    %rax,%rsi
  800b0a:	bf 20 00 00 00       	mov    $0x20,%edi
  800b0f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b11:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b19:	7f e4                	jg     800aff <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800b1b:	e9 90 01 00 00       	jmpq   800cb0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b24:	be 03 00 00 00       	mov    $0x3,%esi
  800b29:	48 89 c7             	mov    %rax,%rdi
  800b2c:	48 b8 8c 06 80 00 00 	movabs $0x80068c,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
  800b38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b40:	48 85 c0             	test   %rax,%rax
  800b43:	79 1d                	jns    800b62 <vprintfmt+0x3c6>
				putch('-', putdat);
  800b45:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b49:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b4d:	48 89 c6             	mov    %rax,%rsi
  800b50:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b55:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800b57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5b:	48 f7 d8             	neg    %rax
  800b5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b62:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b69:	e9 d5 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b72:	be 03 00 00 00       	mov    $0x3,%esi
  800b77:	48 89 c7             	mov    %rax,%rdi
  800b7a:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b8a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b91:	e9 ad 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800b96:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9a:	be 03 00 00 00       	mov    $0x3,%esi
  800b9f:	48 89 c7             	mov    %rax,%rdi
  800ba2:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800ba9:	00 00 00 
  800bac:	ff d0                	callq  *%rax
  800bae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800bb2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800bb9:	e9 85 00 00 00       	jmpq   800c43 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800bbe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bc2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bc6:	48 89 c6             	mov    %rax,%rsi
  800bc9:	bf 30 00 00 00       	mov    $0x30,%edi
  800bce:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800bd0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bd8:	48 89 c6             	mov    %rax,%rsi
  800bdb:	bf 78 00 00 00       	mov    $0x78,%edi
  800be0:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800be2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be5:	83 f8 30             	cmp    $0x30,%eax
  800be8:	73 17                	jae    800c01 <vprintfmt+0x465>
  800bea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bf1:	89 c0                	mov    %eax,%eax
  800bf3:	48 01 d0             	add    %rdx,%rax
  800bf6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bf9:	83 c2 08             	add    $0x8,%edx
  800bfc:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bff:	eb 0f                	jmp    800c10 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800c01:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c05:	48 89 d0             	mov    %rdx,%rax
  800c08:	48 83 c2 08          	add    $0x8,%rdx
  800c0c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c10:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c17:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c1e:	eb 23                	jmp    800c43 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c20:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c24:	be 03 00 00 00       	mov    $0x3,%esi
  800c29:	48 89 c7             	mov    %rax,%rdi
  800c2c:	48 b8 7c 05 80 00 00 	movabs $0x80057c,%rax
  800c33:	00 00 00 
  800c36:	ff d0                	callq  *%rax
  800c38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c3c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c43:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c48:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c4b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c52:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5a:	45 89 c1             	mov    %r8d,%r9d
  800c5d:	41 89 f8             	mov    %edi,%r8d
  800c60:	48 89 c7             	mov    %rax,%rdi
  800c63:	48 b8 c4 04 80 00 00 	movabs $0x8004c4,%rax
  800c6a:	00 00 00 
  800c6d:	ff d0                	callq  *%rax
			break;
  800c6f:	eb 3f                	jmp    800cb0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c71:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c75:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c79:	48 89 c6             	mov    %rax,%rsi
  800c7c:	89 df                	mov    %ebx,%edi
  800c7e:	ff d2                	callq  *%rdx
			break;
  800c80:	eb 2e                	jmp    800cb0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c82:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c86:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c8a:	48 89 c6             	mov    %rax,%rsi
  800c8d:	bf 25 00 00 00       	mov    $0x25,%edi
  800c92:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c94:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c99:	eb 05                	jmp    800ca0 <vprintfmt+0x504>
  800c9b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ca0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ca4:	48 83 e8 01          	sub    $0x1,%rax
  800ca8:	0f b6 00             	movzbl (%rax),%eax
  800cab:	3c 25                	cmp    $0x25,%al
  800cad:	75 ec                	jne    800c9b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800caf:	90                   	nop
		}
	}
  800cb0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cb1:	e9 38 fb ff ff       	jmpq   8007ee <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800cb6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800cb7:	48 83 c4 60          	add    $0x60,%rsp
  800cbb:	5b                   	pop    %rbx
  800cbc:	41 5c                	pop    %r12
  800cbe:	5d                   	pop    %rbp
  800cbf:	c3                   	retq   

0000000000800cc0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc0:	55                   	push   %rbp
  800cc1:	48 89 e5             	mov    %rsp,%rbp
  800cc4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ccb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cd2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cd9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ce0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ce7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 20                	je     800d12 <printfmt+0x52>
  800cf2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cf6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cfa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cfe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d02:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d06:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d0a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d0e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d12:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d19:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d20:	00 00 00 
  800d23:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d2a:	00 00 00 
  800d2d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d31:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d38:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d3f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d46:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d4d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d54:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d5b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d62:	48 89 c7             	mov    %rax,%rdi
  800d65:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  800d6c:	00 00 00 
  800d6f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d71:	c9                   	leaveq 
  800d72:	c3                   	retq   

0000000000800d73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d73:	55                   	push   %rbp
  800d74:	48 89 e5             	mov    %rsp,%rbp
  800d77:	48 83 ec 10          	sub    $0x10,%rsp
  800d7b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d86:	8b 40 10             	mov    0x10(%rax),%eax
  800d89:	8d 50 01             	lea    0x1(%rax),%edx
  800d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d90:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d97:	48 8b 10             	mov    (%rax),%rdx
  800d9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800da2:	48 39 c2             	cmp    %rax,%rdx
  800da5:	73 17                	jae    800dbe <sprintputch+0x4b>
		*b->buf++ = ch;
  800da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dab:	48 8b 00             	mov    (%rax),%rax
  800dae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800db1:	88 10                	mov    %dl,(%rax)
  800db3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800db7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dbb:	48 89 10             	mov    %rdx,(%rax)
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 50          	sub    $0x50,%rsp
  800dc8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800dcc:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800dcf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800dd3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800dd7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ddb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ddf:	48 8b 0a             	mov    (%rdx),%rcx
  800de2:	48 89 08             	mov    %rcx,(%rax)
  800de5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800de9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ded:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800df1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800df5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800df9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800dfd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e00:	48 98                	cltq   
  800e02:	48 83 e8 01          	sub    $0x1,%rax
  800e06:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800e0a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e15:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e1a:	74 06                	je     800e22 <vsnprintf+0x62>
  800e1c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e20:	7f 07                	jg     800e29 <vsnprintf+0x69>
		return -E_INVAL;
  800e22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e27:	eb 2f                	jmp    800e58 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e29:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e2d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e31:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e35:	48 89 c6             	mov    %rax,%rsi
  800e38:	48 bf 73 0d 80 00 00 	movabs $0x800d73,%rdi
  800e3f:	00 00 00 
  800e42:	48 b8 9c 07 80 00 00 	movabs $0x80079c,%rax
  800e49:	00 00 00 
  800e4c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e4e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e52:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e55:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e58:	c9                   	leaveq 
  800e59:	c3                   	retq   

0000000000800e5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5a:	55                   	push   %rbp
  800e5b:	48 89 e5             	mov    %rsp,%rbp
  800e5e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e65:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e6c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e87:	84 c0                	test   %al,%al
  800e89:	74 20                	je     800eab <snprintf+0x51>
  800e8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ea3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ea7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eab:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800eb2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800eb9:	00 00 00 
  800ebc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ec3:	00 00 00 
  800ec6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ed1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ed8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800edf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ee6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800eed:	48 8b 0a             	mov    (%rdx),%rcx
  800ef0:	48 89 08             	mov    %rcx,(%rax)
  800ef3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ef7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800efb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800eff:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f03:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f0a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f11:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f17:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f1e:	48 89 c7             	mov    %rax,%rdi
  800f21:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  800f28:	00 00 00 
  800f2b:	ff d0                	callq  *%rax
  800f2d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f33:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f39:	c9                   	leaveq 
  800f3a:	c3                   	retq   
	...

0000000000800f3c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f3c:	55                   	push   %rbp
  800f3d:	48 89 e5             	mov    %rsp,%rbp
  800f40:	48 83 ec 18          	sub    $0x18,%rsp
  800f44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f4f:	eb 09                	jmp    800f5a <strlen+0x1e>
		n++;
  800f51:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f55:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5e:	0f b6 00             	movzbl (%rax),%eax
  800f61:	84 c0                	test   %al,%al
  800f63:	75 ec                	jne    800f51 <strlen+0x15>
		n++;
	return n;
  800f65:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f68:	c9                   	leaveq 
  800f69:	c3                   	retq   

0000000000800f6a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f6a:	55                   	push   %rbp
  800f6b:	48 89 e5             	mov    %rsp,%rbp
  800f6e:	48 83 ec 20          	sub    $0x20,%rsp
  800f72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f81:	eb 0e                	jmp    800f91 <strnlen+0x27>
		n++;
  800f83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f87:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f8c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f91:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f96:	74 0b                	je     800fa3 <strnlen+0x39>
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	0f b6 00             	movzbl (%rax),%eax
  800f9f:	84 c0                	test   %al,%al
  800fa1:	75 e0                	jne    800f83 <strnlen+0x19>
		n++;
	return n;
  800fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fa6:	c9                   	leaveq 
  800fa7:	c3                   	retq   

0000000000800fa8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fa8:	55                   	push   %rbp
  800fa9:	48 89 e5             	mov    %rsp,%rbp
  800fac:	48 83 ec 20          	sub    $0x20,%rsp
  800fb0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fb4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800fb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fbc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fc0:	90                   	nop
  800fc1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc5:	0f b6 10             	movzbl (%rax),%edx
  800fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcc:	88 10                	mov    %dl,(%rax)
  800fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd2:	0f b6 00             	movzbl (%rax),%eax
  800fd5:	84 c0                	test   %al,%al
  800fd7:	0f 95 c0             	setne  %al
  800fda:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fdf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  800fe4:	84 c0                	test   %al,%al
  800fe6:	75 d9                	jne    800fc1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fec:	c9                   	leaveq 
  800fed:	c3                   	retq   

0000000000800fee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fee:	55                   	push   %rbp
  800fef:	48 89 e5             	mov    %rsp,%rbp
  800ff2:	48 83 ec 20          	sub    $0x20,%rsp
  800ff6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ffa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ffe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801002:	48 89 c7             	mov    %rax,%rdi
  801005:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  80100c:	00 00 00 
  80100f:	ff d0                	callq  *%rax
  801011:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801014:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801017:	48 98                	cltq   
  801019:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80101d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801021:	48 89 d6             	mov    %rdx,%rsi
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
	return dst;
  801033:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801037:	c9                   	leaveq 
  801038:	c3                   	retq   

0000000000801039 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801039:	55                   	push   %rbp
  80103a:	48 89 e5             	mov    %rsp,%rbp
  80103d:	48 83 ec 28          	sub    $0x28,%rsp
  801041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801045:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801049:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801055:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80105c:	00 
  80105d:	eb 27                	jmp    801086 <strncpy+0x4d>
		*dst++ = *src;
  80105f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801063:	0f b6 10             	movzbl (%rax),%edx
  801066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106a:	88 10                	mov    %dl,(%rax)
  80106c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801071:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801075:	0f b6 00             	movzbl (%rax),%eax
  801078:	84 c0                	test   %al,%al
  80107a:	74 05                	je     801081 <strncpy+0x48>
			src++;
  80107c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801081:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801086:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80108a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80108e:	72 cf                	jb     80105f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801094:	c9                   	leaveq 
  801095:	c3                   	retq   

0000000000801096 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801096:	55                   	push   %rbp
  801097:	48 89 e5             	mov    %rsp,%rbp
  80109a:	48 83 ec 28          	sub    $0x28,%rsp
  80109e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8010b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010b7:	74 37                	je     8010f0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 17                	jmp    8010d2 <strlcpy+0x3c>
			*dst++ = *src++;
  8010bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010bf:	0f b6 10             	movzbl (%rax),%edx
  8010c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c6:	88 10                	mov    %dl,(%rax)
  8010c8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010cd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010d7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010dc:	74 0b                	je     8010e9 <strlcpy+0x53>
  8010de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010e2:	0f b6 00             	movzbl (%rax),%eax
  8010e5:	84 c0                	test   %al,%al
  8010e7:	75 d2                	jne    8010bb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ed:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f8:	48 89 d1             	mov    %rdx,%rcx
  8010fb:	48 29 c1             	sub    %rax,%rcx
  8010fe:	48 89 c8             	mov    %rcx,%rax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 10          	sub    $0x10,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801113:	eb 0a                	jmp    80111f <strcmp+0x1c>
		p++, q++;
  801115:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801123:	0f b6 00             	movzbl (%rax),%eax
  801126:	84 c0                	test   %al,%al
  801128:	74 12                	je     80113c <strcmp+0x39>
  80112a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112e:	0f b6 10             	movzbl (%rax),%edx
  801131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801135:	0f b6 00             	movzbl (%rax),%eax
  801138:	38 c2                	cmp    %al,%dl
  80113a:	74 d9                	je     801115 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80113c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801140:	0f b6 00             	movzbl (%rax),%eax
  801143:	0f b6 d0             	movzbl %al,%edx
  801146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80114a:	0f b6 00             	movzbl (%rax),%eax
  80114d:	0f b6 c0             	movzbl %al,%eax
  801150:	89 d1                	mov    %edx,%ecx
  801152:	29 c1                	sub    %eax,%ecx
  801154:	89 c8                	mov    %ecx,%eax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 18          	sub    $0x18,%rsp
  801160:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801164:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801168:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80116c:	eb 0f                	jmp    80117d <strncmp+0x25>
		n--, p++, q++;
  80116e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801173:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801178:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80117d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801182:	74 1d                	je     8011a1 <strncmp+0x49>
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	0f b6 00             	movzbl (%rax),%eax
  80118b:	84 c0                	test   %al,%al
  80118d:	74 12                	je     8011a1 <strncmp+0x49>
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	0f b6 10             	movzbl (%rax),%edx
  801196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119a:	0f b6 00             	movzbl (%rax),%eax
  80119d:	38 c2                	cmp    %al,%dl
  80119f:	74 cd                	je     80116e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a6:	75 07                	jne    8011af <strncmp+0x57>
		return 0;
  8011a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ad:	eb 1a                	jmp    8011c9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b3:	0f b6 00             	movzbl (%rax),%eax
  8011b6:	0f b6 d0             	movzbl %al,%edx
  8011b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011bd:	0f b6 00             	movzbl (%rax),%eax
  8011c0:	0f b6 c0             	movzbl %al,%eax
  8011c3:	89 d1                	mov    %edx,%ecx
  8011c5:	29 c1                	sub    %eax,%ecx
  8011c7:	89 c8                	mov    %ecx,%eax
}
  8011c9:	c9                   	leaveq 
  8011ca:	c3                   	retq   

00000000008011cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	48 83 ec 10          	sub    $0x10,%rsp
  8011d3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011d7:	89 f0                	mov    %esi,%eax
  8011d9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011dc:	eb 17                	jmp    8011f5 <strchr+0x2a>
		if (*s == c)
  8011de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e2:	0f b6 00             	movzbl (%rax),%eax
  8011e5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011e8:	75 06                	jne    8011f0 <strchr+0x25>
			return (char *) s;
  8011ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ee:	eb 15                	jmp    801205 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f9:	0f b6 00             	movzbl (%rax),%eax
  8011fc:	84 c0                	test   %al,%al
  8011fe:	75 de                	jne    8011de <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801205:	c9                   	leaveq 
  801206:	c3                   	retq   

0000000000801207 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801207:	55                   	push   %rbp
  801208:	48 89 e5             	mov    %rsp,%rbp
  80120b:	48 83 ec 10          	sub    $0x10,%rsp
  80120f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801213:	89 f0                	mov    %esi,%eax
  801215:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801218:	eb 11                	jmp    80122b <strfind+0x24>
		if (*s == c)
  80121a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121e:	0f b6 00             	movzbl (%rax),%eax
  801221:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801224:	74 12                	je     801238 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801226:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	0f b6 00             	movzbl (%rax),%eax
  801232:	84 c0                	test   %al,%al
  801234:	75 e4                	jne    80121a <strfind+0x13>
  801236:	eb 01                	jmp    801239 <strfind+0x32>
		if (*s == c)
			break;
  801238:	90                   	nop
	return (char *) s;
  801239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80123d:	c9                   	leaveq 
  80123e:	c3                   	retq   

000000000080123f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80123f:	55                   	push   %rbp
  801240:	48 89 e5             	mov    %rsp,%rbp
  801243:	48 83 ec 18          	sub    $0x18,%rsp
  801247:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80124e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801252:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801257:	75 06                	jne    80125f <memset+0x20>
		return v;
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	eb 69                	jmp    8012c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 48                	jne    8012b3 <memset+0x74>
  80126b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126f:	83 e0 03             	and    $0x3,%eax
  801272:	48 85 c0             	test   %rax,%rax
  801275:	75 3c                	jne    8012b3 <memset+0x74>
		c &= 0xFF;
  801277:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80127e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801281:	89 c2                	mov    %eax,%edx
  801283:	c1 e2 18             	shl    $0x18,%edx
  801286:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801289:	c1 e0 10             	shl    $0x10,%eax
  80128c:	09 c2                	or     %eax,%edx
  80128e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801291:	c1 e0 08             	shl    $0x8,%eax
  801294:	09 d0                	or     %edx,%eax
  801296:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129d:	48 89 c1             	mov    %rax,%rcx
  8012a0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ab:	48 89 d7             	mov    %rdx,%rdi
  8012ae:	fc                   	cld    
  8012af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8012b1:	eb 11                	jmp    8012c4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012be:	48 89 d7             	mov    %rdx,%rdi
  8012c1:	fc                   	cld    
  8012c2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8012c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012c8:	c9                   	leaveq 
  8012c9:	c3                   	retq   

00000000008012ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012ca:	55                   	push   %rbp
  8012cb:	48 89 e5             	mov    %rsp,%rbp
  8012ce:	48 83 ec 28          	sub    $0x28,%rsp
  8012d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012f6:	0f 83 88 00 00 00    	jae    801384 <memmove+0xba>
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801304:	48 01 d0             	add    %rdx,%rax
  801307:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80130b:	76 77                	jbe    801384 <memmove+0xba>
		s += n;
  80130d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801311:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801315:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801319:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801321:	83 e0 03             	and    $0x3,%eax
  801324:	48 85 c0             	test   %rax,%rax
  801327:	75 3b                	jne    801364 <memmove+0x9a>
  801329:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80132d:	83 e0 03             	and    $0x3,%eax
  801330:	48 85 c0             	test   %rax,%rax
  801333:	75 2f                	jne    801364 <memmove+0x9a>
  801335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801339:	83 e0 03             	and    $0x3,%eax
  80133c:	48 85 c0             	test   %rax,%rax
  80133f:	75 23                	jne    801364 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801341:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801345:	48 83 e8 04          	sub    $0x4,%rax
  801349:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134d:	48 83 ea 04          	sub    $0x4,%rdx
  801351:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801355:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801359:	48 89 c7             	mov    %rax,%rdi
  80135c:	48 89 d6             	mov    %rdx,%rsi
  80135f:	fd                   	std    
  801360:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801362:	eb 1d                	jmp    801381 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801364:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801368:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80136c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801370:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801378:	48 89 d7             	mov    %rdx,%rdi
  80137b:	48 89 c1             	mov    %rax,%rcx
  80137e:	fd                   	std    
  80137f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801381:	fc                   	cld    
  801382:	eb 57                	jmp    8013db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	83 e0 03             	and    $0x3,%eax
  80138b:	48 85 c0             	test   %rax,%rax
  80138e:	75 36                	jne    8013c6 <memmove+0xfc>
  801390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801394:	83 e0 03             	and    $0x3,%eax
  801397:	48 85 c0             	test   %rax,%rax
  80139a:	75 2a                	jne    8013c6 <memmove+0xfc>
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	83 e0 03             	and    $0x3,%eax
  8013a3:	48 85 c0             	test   %rax,%rax
  8013a6:	75 1e                	jne    8013c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 89 c1             	mov    %rax,%rcx
  8013af:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8013b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013bb:	48 89 c7             	mov    %rax,%rdi
  8013be:	48 89 d6             	mov    %rdx,%rsi
  8013c1:	fc                   	cld    
  8013c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013c4:	eb 15                	jmp    8013db <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d2:	48 89 c7             	mov    %rax,%rdi
  8013d5:	48 89 d6             	mov    %rdx,%rsi
  8013d8:	fc                   	cld    
  8013d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013df:	c9                   	leaveq 
  8013e0:	c3                   	retq   

00000000008013e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013e1:	55                   	push   %rbp
  8013e2:	48 89 e5             	mov    %rsp,%rbp
  8013e5:	48 83 ec 18          	sub    $0x18,%rsp
  8013e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801401:	48 89 ce             	mov    %rcx,%rsi
  801404:	48 89 c7             	mov    %rax,%rdi
  801407:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  80140e:	00 00 00 
  801411:	ff d0                	callq  *%rax
}
  801413:	c9                   	leaveq 
  801414:	c3                   	retq   

0000000000801415 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801415:	55                   	push   %rbp
  801416:	48 89 e5             	mov    %rsp,%rbp
  801419:	48 83 ec 28          	sub    $0x28,%rsp
  80141d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801421:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801425:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801431:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801435:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801439:	eb 38                	jmp    801473 <memcmp+0x5e>
		if (*s1 != *s2)
  80143b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143f:	0f b6 10             	movzbl (%rax),%edx
  801442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	38 c2                	cmp    %al,%dl
  80144b:	74 1c                	je     801469 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80144d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801451:	0f b6 00             	movzbl (%rax),%eax
  801454:	0f b6 d0             	movzbl %al,%edx
  801457:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	0f b6 c0             	movzbl %al,%eax
  801461:	89 d1                	mov    %edx,%ecx
  801463:	29 c1                	sub    %eax,%ecx
  801465:	89 c8                	mov    %ecx,%eax
  801467:	eb 20                	jmp    801489 <memcmp+0x74>
		s1++, s2++;
  801469:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80146e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801473:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801478:	0f 95 c0             	setne  %al
  80147b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801480:	84 c0                	test   %al,%al
  801482:	75 b7                	jne    80143b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 28          	sub    $0x28,%rsp
  801493:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801497:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80149a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80149e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a6:	48 01 d0             	add    %rdx,%rax
  8014a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014ad:	eb 13                	jmp    8014c2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b3:	0f b6 10             	movzbl (%rax),%edx
  8014b6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8014b9:	38 c2                	cmp    %al,%dl
  8014bb:	74 11                	je     8014ce <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014ca:	72 e3                	jb     8014af <memfind+0x24>
  8014cc:	eb 01                	jmp    8014cf <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014ce:	90                   	nop
	return (void *) s;
  8014cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 83 ec 38          	sub    $0x38,%rsp
  8014dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014e5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014ef:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014f6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f7:	eb 05                	jmp    8014fe <strtol+0x29>
		s++;
  8014f9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801502:	0f b6 00             	movzbl (%rax),%eax
  801505:	3c 20                	cmp    $0x20,%al
  801507:	74 f0                	je     8014f9 <strtol+0x24>
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	0f b6 00             	movzbl (%rax),%eax
  801510:	3c 09                	cmp    $0x9,%al
  801512:	74 e5                	je     8014f9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801514:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801518:	0f b6 00             	movzbl (%rax),%eax
  80151b:	3c 2b                	cmp    $0x2b,%al
  80151d:	75 07                	jne    801526 <strtol+0x51>
		s++;
  80151f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801524:	eb 17                	jmp    80153d <strtol+0x68>
	else if (*s == '-')
  801526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152a:	0f b6 00             	movzbl (%rax),%eax
  80152d:	3c 2d                	cmp    $0x2d,%al
  80152f:	75 0c                	jne    80153d <strtol+0x68>
		s++, neg = 1;
  801531:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80153d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801541:	74 06                	je     801549 <strtol+0x74>
  801543:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801547:	75 28                	jne    801571 <strtol+0x9c>
  801549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154d:	0f b6 00             	movzbl (%rax),%eax
  801550:	3c 30                	cmp    $0x30,%al
  801552:	75 1d                	jne    801571 <strtol+0x9c>
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	48 83 c0 01          	add    $0x1,%rax
  80155c:	0f b6 00             	movzbl (%rax),%eax
  80155f:	3c 78                	cmp    $0x78,%al
  801561:	75 0e                	jne    801571 <strtol+0x9c>
		s += 2, base = 16;
  801563:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801568:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80156f:	eb 2c                	jmp    80159d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801571:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801575:	75 19                	jne    801590 <strtol+0xbb>
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	3c 30                	cmp    $0x30,%al
  801580:	75 0e                	jne    801590 <strtol+0xbb>
		s++, base = 8;
  801582:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801587:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80158e:	eb 0d                	jmp    80159d <strtol+0xc8>
	else if (base == 0)
  801590:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801594:	75 07                	jne    80159d <strtol+0xc8>
		base = 10;
  801596:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80159d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a1:	0f b6 00             	movzbl (%rax),%eax
  8015a4:	3c 2f                	cmp    $0x2f,%al
  8015a6:	7e 1d                	jle    8015c5 <strtol+0xf0>
  8015a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ac:	0f b6 00             	movzbl (%rax),%eax
  8015af:	3c 39                	cmp    $0x39,%al
  8015b1:	7f 12                	jg     8015c5 <strtol+0xf0>
			dig = *s - '0';
  8015b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	0f be c0             	movsbl %al,%eax
  8015bd:	83 e8 30             	sub    $0x30,%eax
  8015c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015c3:	eb 4e                	jmp    801613 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 60                	cmp    $0x60,%al
  8015ce:	7e 1d                	jle    8015ed <strtol+0x118>
  8015d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 7a                	cmp    $0x7a,%al
  8015d9:	7f 12                	jg     8015ed <strtol+0x118>
			dig = *s - 'a' + 10;
  8015db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015df:	0f b6 00             	movzbl (%rax),%eax
  8015e2:	0f be c0             	movsbl %al,%eax
  8015e5:	83 e8 57             	sub    $0x57,%eax
  8015e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015eb:	eb 26                	jmp    801613 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f1:	0f b6 00             	movzbl (%rax),%eax
  8015f4:	3c 40                	cmp    $0x40,%al
  8015f6:	7e 47                	jle    80163f <strtol+0x16a>
  8015f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fc:	0f b6 00             	movzbl (%rax),%eax
  8015ff:	3c 5a                	cmp    $0x5a,%al
  801601:	7f 3c                	jg     80163f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801603:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	0f be c0             	movsbl %al,%eax
  80160d:	83 e8 37             	sub    $0x37,%eax
  801610:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801613:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801616:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801619:	7d 23                	jge    80163e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80161b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801620:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801623:	48 98                	cltq   
  801625:	48 89 c2             	mov    %rax,%rdx
  801628:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80162d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801630:	48 98                	cltq   
  801632:	48 01 d0             	add    %rdx,%rax
  801635:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801639:	e9 5f ff ff ff       	jmpq   80159d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80163e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80163f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801644:	74 0b                	je     801651 <strtol+0x17c>
		*endptr = (char *) s;
  801646:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80164e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801655:	74 09                	je     801660 <strtol+0x18b>
  801657:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165b:	48 f7 d8             	neg    %rax
  80165e:	eb 04                	jmp    801664 <strtol+0x18f>
  801660:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801664:	c9                   	leaveq 
  801665:	c3                   	retq   

0000000000801666 <strstr>:

char * strstr(const char *in, const char *str)
{
  801666:	55                   	push   %rbp
  801667:	48 89 e5             	mov    %rsp,%rbp
  80166a:	48 83 ec 30          	sub    $0x30,%rsp
  80166e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801672:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801676:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167a:	0f b6 00             	movzbl (%rax),%eax
  80167d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801680:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801685:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801689:	75 06                	jne    801691 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80168b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168f:	eb 68                	jmp    8016f9 <strstr+0x93>

    len = strlen(str);
  801691:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801695:	48 89 c7             	mov    %rax,%rdi
  801698:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  80169f:	00 00 00 
  8016a2:	ff d0                	callq  *%rax
  8016a4:	48 98                	cltq   
  8016a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8016aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8016b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8016b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016bd:	75 07                	jne    8016c6 <strstr+0x60>
                return (char *) 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c4:	eb 33                	jmp    8016f9 <strstr+0x93>
        } while (sc != c);
  8016c6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016ca:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016cd:	75 db                	jne    8016aa <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8016cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	48 89 ce             	mov    %rcx,%rsi
  8016de:	48 89 c7             	mov    %rax,%rdi
  8016e1:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  8016e8:	00 00 00 
  8016eb:	ff d0                	callq  *%rax
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	75 b9                	jne    8016aa <strstr+0x44>

    return (char *) (in - 1);
  8016f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f5:	48 83 e8 01          	sub    $0x1,%rax
}
  8016f9:	c9                   	leaveq 
  8016fa:	c3                   	retq   
	...

00000000008016fc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	53                   	push   %rbx
  801701:	48 83 ec 58          	sub    $0x58,%rsp
  801705:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801708:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80170b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80170f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801713:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801717:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80171e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801721:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801725:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801729:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80172d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801731:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801735:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801738:	4c 89 c3             	mov    %r8,%rbx
  80173b:	cd 30                	int    $0x30
  80173d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801741:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801745:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801749:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80174d:	74 3e                	je     80178d <syscall+0x91>
  80174f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801754:	7e 37                	jle    80178d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801756:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80175a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80175d:	49 89 d0             	mov    %rdx,%r8
  801760:	89 c1                	mov    %eax,%ecx
  801762:	48 ba 80 4a 80 00 00 	movabs $0x804a80,%rdx
  801769:	00 00 00 
  80176c:	be 23 00 00 00       	mov    $0x23,%esi
  801771:	48 bf 9d 4a 80 00 00 	movabs $0x804a9d,%rdi
  801778:	00 00 00 
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
  801780:	49 b9 7c 42 80 00 00 	movabs $0x80427c,%r9
  801787:	00 00 00 
  80178a:	41 ff d1             	callq  *%r9

	return ret;
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801791:	48 83 c4 58          	add    $0x58,%rsp
  801795:	5b                   	pop    %rbx
  801796:	5d                   	pop    %rbp
  801797:	c3                   	retq   

0000000000801798 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801798:	55                   	push   %rbp
  801799:	48 89 e5             	mov    %rsp,%rbp
  80179c:	48 83 ec 20          	sub    $0x20,%rsp
  8017a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b7:	00 
  8017b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c4:	48 89 d1             	mov    %rdx,%rcx
  8017c7:	48 89 c2             	mov    %rax,%rdx
  8017ca:	be 00 00 00 00       	mov    $0x0,%esi
  8017cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d4:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8017db:	00 00 00 
  8017de:	ff d0                	callq  *%rax
}
  8017e0:	c9                   	leaveq 
  8017e1:	c3                   	retq   

00000000008017e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e2:	55                   	push   %rbp
  8017e3:	48 89 e5             	mov    %rsp,%rbp
  8017e6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017ea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f1:	00 
  8017f2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	be 00 00 00 00       	mov    $0x0,%esi
  80180d:	bf 01 00 00 00       	mov    $0x1,%edi
  801812:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801819:	00 00 00 
  80181c:	ff d0                	callq  *%rax
}
  80181e:	c9                   	leaveq 
  80181f:	c3                   	retq   

0000000000801820 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
  801824:	48 83 ec 20          	sub    $0x20,%rsp
  801828:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80182b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182e:	48 98                	cltq   
  801830:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801837:	00 
  801838:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801844:	b9 00 00 00 00       	mov    $0x0,%ecx
  801849:	48 89 c2             	mov    %rax,%rdx
  80184c:	be 01 00 00 00       	mov    $0x1,%esi
  801851:	bf 03 00 00 00       	mov    $0x3,%edi
  801856:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  80185d:	00 00 00 
  801860:	ff d0                	callq  *%rax
}
  801862:	c9                   	leaveq 
  801863:	c3                   	retq   

0000000000801864 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801864:	55                   	push   %rbp
  801865:	48 89 e5             	mov    %rsp,%rbp
  801868:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80186c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801873:	00 
  801874:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80187a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801880:	b9 00 00 00 00       	mov    $0x0,%ecx
  801885:	ba 00 00 00 00       	mov    $0x0,%edx
  80188a:	be 00 00 00 00       	mov    $0x0,%esi
  80188f:	bf 02 00 00 00       	mov    $0x2,%edi
  801894:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  80189b:	00 00 00 
  80189e:	ff d0                	callq  *%rax
}
  8018a0:	c9                   	leaveq 
  8018a1:	c3                   	retq   

00000000008018a2 <sys_yield>:

void
sys_yield(void)
{
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b1:	00 
  8018b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c8:	be 00 00 00 00       	mov    $0x0,%esi
  8018cd:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018d2:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8018d9:	00 00 00 
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 20          	sub    $0x20,%rsp
  8018e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018ef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018f5:	48 63 c8             	movslq %eax,%rcx
  8018f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ff:	48 98                	cltq   
  801901:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801908:	00 
  801909:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190f:	49 89 c8             	mov    %rcx,%r8
  801912:	48 89 d1             	mov    %rdx,%rcx
  801915:	48 89 c2             	mov    %rax,%rdx
  801918:	be 01 00 00 00       	mov    $0x1,%esi
  80191d:	bf 04 00 00 00       	mov    $0x4,%edi
  801922:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801929:	00 00 00 
  80192c:	ff d0                	callq  *%rax
}
  80192e:	c9                   	leaveq 
  80192f:	c3                   	retq   

0000000000801930 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	48 83 ec 30          	sub    $0x30,%rsp
  801938:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80193b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801942:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801946:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80194a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80194d:	48 63 c8             	movslq %eax,%rcx
  801950:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801957:	48 63 f0             	movslq %eax,%rsi
  80195a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801961:	48 98                	cltq   
  801963:	48 89 0c 24          	mov    %rcx,(%rsp)
  801967:	49 89 f9             	mov    %rdi,%r9
  80196a:	49 89 f0             	mov    %rsi,%r8
  80196d:	48 89 d1             	mov    %rdx,%rcx
  801970:	48 89 c2             	mov    %rax,%rdx
  801973:	be 01 00 00 00       	mov    $0x1,%esi
  801978:	bf 05 00 00 00       	mov    $0x5,%edi
  80197d:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801984:	00 00 00 
  801987:	ff d0                	callq  *%rax
}
  801989:	c9                   	leaveq 
  80198a:	c3                   	retq   

000000000080198b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80198b:	55                   	push   %rbp
  80198c:	48 89 e5             	mov    %rsp,%rbp
  80198f:	48 83 ec 20          	sub    $0x20,%rsp
  801993:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801996:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80199a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a1:	48 98                	cltq   
  8019a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019aa:	00 
  8019ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b7:	48 89 d1             	mov    %rdx,%rcx
  8019ba:	48 89 c2             	mov    %rax,%rdx
  8019bd:	be 01 00 00 00       	mov    $0x1,%esi
  8019c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8019c7:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	callq  *%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 20          	sub    $0x20,%rsp
  8019dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e6:	48 63 d0             	movslq %eax,%rdx
  8019e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ec:	48 98                	cltq   
  8019ee:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f5:	00 
  8019f6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a02:	48 89 d1             	mov    %rdx,%rcx
  801a05:	48 89 c2             	mov    %rax,%rdx
  801a08:	be 01 00 00 00       	mov    $0x1,%esi
  801a0d:	bf 08 00 00 00       	mov    $0x8,%edi
  801a12:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 20          	sub    $0x20,%rsp
  801a28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a2f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a36:	48 98                	cltq   
  801a38:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3f:	00 
  801a40:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a46:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4c:	48 89 d1             	mov    %rdx,%rcx
  801a4f:	48 89 c2             	mov    %rax,%rdx
  801a52:	be 01 00 00 00       	mov    $0x1,%esi
  801a57:	bf 09 00 00 00       	mov    $0x9,%edi
  801a5c:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801a63:	00 00 00 
  801a66:	ff d0                	callq  *%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   

0000000000801a6a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a6a:	55                   	push   %rbp
  801a6b:	48 89 e5             	mov    %rsp,%rbp
  801a6e:	48 83 ec 20          	sub    $0x20,%rsp
  801a72:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a75:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a80:	48 98                	cltq   
  801a82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a89:	00 
  801a8a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a90:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a96:	48 89 d1             	mov    %rdx,%rcx
  801a99:	48 89 c2             	mov    %rax,%rdx
  801a9c:	be 01 00 00 00       	mov    $0x1,%esi
  801aa1:	bf 0a 00 00 00       	mov    $0xa,%edi
  801aa6:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801aad:	00 00 00 
  801ab0:	ff d0                	callq  *%rax
}
  801ab2:	c9                   	leaveq 
  801ab3:	c3                   	retq   

0000000000801ab4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ab4:	55                   	push   %rbp
  801ab5:	48 89 e5             	mov    %rsp,%rbp
  801ab8:	48 83 ec 30          	sub    $0x30,%rsp
  801abc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ac3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ac7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801aca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801acd:	48 63 f0             	movslq %eax,%rsi
  801ad0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ad4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad7:	48 98                	cltq   
  801ad9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	49 89 f1             	mov    %rsi,%r9
  801ae8:	49 89 c8             	mov    %rcx,%r8
  801aeb:	48 89 d1             	mov    %rdx,%rcx
  801aee:	48 89 c2             	mov    %rax,%rdx
  801af1:	be 00 00 00 00       	mov    $0x0,%esi
  801af6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801afb:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b02:	00 00 00 
  801b05:	ff d0                	callq  *%rax
}
  801b07:	c9                   	leaveq 
  801b08:	c3                   	retq   

0000000000801b09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b09:	55                   	push   %rbp
  801b0a:	48 89 e5             	mov    %rsp,%rbp
  801b0d:	48 83 ec 20          	sub    $0x20,%rsp
  801b11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b20:	00 
  801b21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b32:	48 89 c2             	mov    %rax,%rdx
  801b35:	be 01 00 00 00       	mov    $0x1,%esi
  801b3a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b3f:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	callq  *%rax
}
  801b4b:	c9                   	leaveq 
  801b4c:	c3                   	retq   

0000000000801b4d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801b4d:	55                   	push   %rbp
  801b4e:	48 89 e5             	mov    %rsp,%rbp
  801b51:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801b55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5c:	00 
  801b5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b73:	be 00 00 00 00       	mov    $0x0,%esi
  801b78:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b7d:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801b84:	00 00 00 
  801b87:	ff d0                	callq  *%rax
}
  801b89:	c9                   	leaveq 
  801b8a:	c3                   	retq   

0000000000801b8b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801b8b:	55                   	push   %rbp
  801b8c:	48 89 e5             	mov    %rsp,%rbp
  801b8f:	48 83 ec 20          	sub    $0x20,%rsp
  801b93:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b97:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801b9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ba3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801baa:	00 
  801bab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bb7:	48 89 d1             	mov    %rdx,%rcx
  801bba:	48 89 c2             	mov    %rax,%rdx
  801bbd:	be 00 00 00 00       	mov    $0x0,%esi
  801bc2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801bc7:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801bce:	00 00 00 
  801bd1:	ff d0                	callq  *%rax
}
  801bd3:	c9                   	leaveq 
  801bd4:	c3                   	retq   

0000000000801bd5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
  801bd9:	48 83 ec 20          	sub    $0x20,%rsp
  801bdd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801be1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bed:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf4:	00 
  801bf5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c01:	48 89 d1             	mov    %rdx,%rcx
  801c04:	48 89 c2             	mov    %rax,%rdx
  801c07:	be 00 00 00 00       	mov    $0x0,%esi
  801c0c:	bf 10 00 00 00       	mov    $0x10,%edi
  801c11:	48 b8 fc 16 80 00 00 	movabs $0x8016fc,%rax
  801c18:	00 00 00 
  801c1b:	ff d0                	callq  *%rax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   
	...

0000000000801c20 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801c20:	55                   	push   %rbp
  801c21:	48 89 e5             	mov    %rsp,%rbp
  801c24:	48 83 ec 30          	sub    $0x30,%rsp
  801c28:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801c2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c30:	48 8b 00             	mov    (%rax),%rax
  801c33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801c37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c3f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801c42:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c45:	83 e0 02             	and    $0x2,%eax
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	74 23                	je     801c6f <pgfault+0x4f>
  801c4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c50:	48 89 c2             	mov    %rax,%rdx
  801c53:	48 c1 ea 0c          	shr    $0xc,%rdx
  801c57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c5e:	01 00 00 
  801c61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c65:	25 00 08 00 00       	and    $0x800,%eax
  801c6a:	48 85 c0             	test   %rax,%rax
  801c6d:	75 2a                	jne    801c99 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801c6f:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  801c76:	00 00 00 
  801c79:	be 1c 00 00 00       	mov    $0x1c,%esi
  801c7e:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801c85:	00 00 00 
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  801c94:	00 00 00 
  801c97:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801c99:	ba 07 00 00 00       	mov    $0x7,%edx
  801c9e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca8:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	callq  *%rax
  801cb4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801cbb:	79 30                	jns    801ced <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801cbd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801cc0:	89 c1                	mov    %eax,%ecx
  801cc2:	48 ba f0 4a 80 00 00 	movabs $0x804af0,%rdx
  801cc9:	00 00 00 
  801ccc:	be 26 00 00 00       	mov    $0x26,%esi
  801cd1:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801cd8:	00 00 00 
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce0:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  801ce7:	00 00 00 
  801cea:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cf1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801cf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cf9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801cff:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d04:	48 89 c6             	mov    %rax,%rsi
  801d07:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d0c:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801d20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d24:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d2a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801d30:	48 89 c1             	mov    %rax,%rcx
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
  801d38:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d3d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d42:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801d49:	00 00 00 
  801d4c:	ff d0                	callq  *%rax
  801d4e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d51:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d55:	79 30                	jns    801d87 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801d57:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d5a:	89 c1                	mov    %eax,%ecx
  801d5c:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  801d63:	00 00 00 
  801d66:	be 2b 00 00 00       	mov    $0x2b,%esi
  801d6b:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801d72:	00 00 00 
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  801d81:	00 00 00 
  801d84:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801d87:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d91:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
  801d9d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801da0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801da4:	79 30                	jns    801dd6 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801da6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801da9:	89 c1                	mov    %eax,%ecx
  801dab:	48 ba 40 4b 80 00 00 	movabs $0x804b40,%rdx
  801db2:	00 00 00 
  801db5:	be 2e 00 00 00       	mov    $0x2e,%esi
  801dba:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801dc1:	00 00 00 
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc9:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  801dd0:	00 00 00 
  801dd3:	41 ff d0             	callq  *%r8
	
}
  801dd6:	c9                   	leaveq 
  801dd7:	c3                   	retq   

0000000000801dd8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801dd8:	55                   	push   %rbp
  801dd9:	48 89 e5             	mov    %rsp,%rbp
  801ddc:	48 83 ec 30          	sub    $0x30,%rsp
  801de0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801de3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801de6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ded:	01 00 00 
  801df0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801df3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801df7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dff:	25 07 0e 00 00       	and    $0xe07,%eax
  801e04:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801e07:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801e0a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801e12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e15:	25 00 04 00 00       	and    $0x400,%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	74 5c                	je     801e7a <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801e1e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801e21:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e25:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2c:	41 89 f0             	mov    %esi,%r8d
  801e2f:	48 89 c6             	mov    %rax,%rsi
  801e32:	bf 00 00 00 00       	mov    $0x0,%edi
  801e37:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801e46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801e4a:	0f 89 60 01 00 00    	jns    801fb0 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801e50:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  801e57:	00 00 00 
  801e5a:	be 4d 00 00 00       	mov    $0x4d,%esi
  801e5f:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801e66:	00 00 00 
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  801e75:	00 00 00 
  801e78:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801e7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e7d:	83 e0 02             	and    $0x2,%eax
  801e80:	85 c0                	test   %eax,%eax
  801e82:	75 10                	jne    801e94 <duppage+0xbc>
  801e84:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e87:	25 00 08 00 00       	and    $0x800,%eax
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	0f 84 c4 00 00 00    	je     801f58 <duppage+0x180>
	{
		perm |= PTE_COW;
  801e94:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801e9b:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801e9f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801ea2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ea6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ea9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ead:	41 89 f0             	mov    %esi,%r8d
  801eb0:	48 89 c6             	mov    %rax,%rsi
  801eb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb8:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801ebf:	00 00 00 
  801ec2:	ff d0                	callq  *%rax
  801ec4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801ec7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ecb:	79 2a                	jns    801ef7 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801ecd:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  801ed4:	00 00 00 
  801ed7:	be 56 00 00 00       	mov    $0x56,%esi
  801edc:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801ee3:	00 00 00 
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  801ef2:	00 00 00 
  801ef5:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801ef7:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801efa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f02:	41 89 c8             	mov    %ecx,%r8d
  801f05:	48 89 d1             	mov    %rdx,%rcx
  801f08:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0d:	48 89 c6             	mov    %rax,%rsi
  801f10:	bf 00 00 00 00       	mov    $0x0,%edi
  801f15:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801f1c:	00 00 00 
  801f1f:	ff d0                	callq  *%rax
  801f21:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801f24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f28:	0f 89 82 00 00 00    	jns    801fb0 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  801f2e:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  801f35:	00 00 00 
  801f38:	be 59 00 00 00       	mov    $0x59,%esi
  801f3d:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801f44:	00 00 00 
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  801f53:	00 00 00 
  801f56:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  801f58:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801f5b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f5f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f66:	41 89 f0             	mov    %esi,%r8d
  801f69:	48 89 c6             	mov    %rax,%rsi
  801f6c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f71:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	callq  *%rax
  801f7d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f84:	79 2a                	jns    801fb0 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  801f86:	48 ba d0 4b 80 00 00 	movabs $0x804bd0,%rdx
  801f8d:	00 00 00 
  801f90:	be 60 00 00 00       	mov    $0x60,%esi
  801f95:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801f9c:	00 00 00 
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  801fab:	00 00 00 
  801fae:	ff d1                	callq  *%rcx
	}
	return 0;
  801fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb5:	c9                   	leaveq 
  801fb6:	c3                   	retq   

0000000000801fb7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801fb7:	55                   	push   %rbp
  801fb8:	48 89 e5             	mov    %rsp,%rbp
  801fbb:	53                   	push   %rbx
  801fbc:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801fc0:	48 bf 20 1c 80 00 00 	movabs $0x801c20,%rdi
  801fc7:	00 00 00 
  801fca:	48 b8 90 43 80 00 00 	movabs $0x804390,%rax
  801fd1:	00 00 00 
  801fd4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801fd6:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  801fdd:	8b 45 bc             	mov    -0x44(%rbp),%eax
  801fe0:	cd 30                	int    $0x30
  801fe2:	89 c3                	mov    %eax,%ebx
  801fe4:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801fe7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  801fea:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  801fed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801ff1:	79 30                	jns    802023 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  801ff3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801ff6:	89 c1                	mov    %eax,%ecx
  801ff8:	48 ba f4 4b 80 00 00 	movabs $0x804bf4,%rdx
  801fff:	00 00 00 
  802002:	be 7f 00 00 00       	mov    $0x7f,%esi
  802007:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  80200e:	00 00 00 
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  80201d:	00 00 00 
  802020:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802023:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802027:	75 4c                	jne    802075 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802029:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  802030:	00 00 00 
  802033:	ff d0                	callq  *%rax
  802035:	48 98                	cltq   
  802037:	48 89 c2             	mov    %rax,%rdx
  80203a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802040:	48 89 d0             	mov    %rdx,%rax
  802043:	48 c1 e0 03          	shl    $0x3,%rax
  802047:	48 01 d0             	add    %rdx,%rax
  80204a:	48 c1 e0 05          	shl    $0x5,%rax
  80204e:	48 89 c2             	mov    %rax,%rdx
  802051:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802058:	00 00 00 
  80205b:	48 01 c2             	add    %rax,%rdx
  80205e:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802065:	00 00 00 
  802068:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	e9 38 02 00 00       	jmpq   8022ad <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802075:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802078:	ba 07 00 00 00       	mov    $0x7,%edx
  80207d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802082:	89 c7                	mov    %eax,%edi
  802084:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  80208b:	00 00 00 
  80208e:	ff d0                	callq  *%rax
  802090:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802093:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802097:	79 30                	jns    8020c9 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802099:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80209c:	89 c1                	mov    %eax,%ecx
  80209e:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  8020a5:	00 00 00 
  8020a8:	be 8b 00 00 00       	mov    $0x8b,%esi
  8020ad:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  8020b4:	00 00 00 
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  8020c3:	00 00 00 
  8020c6:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  8020c9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  8020d0:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8020d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8020de:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  8020e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8020ec:	e9 0a 01 00 00       	jmpq   8021fb <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8020f1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8020f8:	01 00 00 
  8020fb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020fe:	48 63 d2             	movslq %edx,%rdx
  802101:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802105:	83 e0 01             	and    $0x1,%eax
  802108:	84 c0                	test   %al,%al
  80210a:	0f 84 e7 00 00 00    	je     8021f7 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802117:	e9 cf 00 00 00       	jmpq   8021eb <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80211c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802123:	01 00 00 
  802126:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802129:	48 63 d2             	movslq %edx,%rdx
  80212c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802130:	83 e0 01             	and    $0x1,%eax
  802133:	84 c0                	test   %al,%al
  802135:	0f 84 a0 00 00 00    	je     8021db <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80213b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802142:	e9 85 00 00 00       	jmpq   8021cc <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802147:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80214e:	01 00 00 
  802151:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802154:	48 63 d2             	movslq %edx,%rdx
  802157:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215b:	83 e0 01             	and    $0x1,%eax
  80215e:	84 c0                	test   %al,%al
  802160:	74 56                	je     8021b8 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802162:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802169:	eb 42                	jmp    8021ad <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80216b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802172:	01 00 00 
  802175:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802178:	48 63 d2             	movslq %edx,%rdx
  80217b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80217f:	83 e0 01             	and    $0x1,%eax
  802182:	84 c0                	test   %al,%al
  802184:	74 1f                	je     8021a5 <fork+0x1ee>
  802186:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  80218d:	74 16                	je     8021a5 <fork+0x1ee>
									 duppage(envid,d1);
  80218f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802192:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802195:	89 d6                	mov    %edx,%esi
  802197:	89 c7                	mov    %eax,%edi
  802199:	48 b8 d8 1d 80 00 00 	movabs $0x801dd8,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8021a5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8021a9:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8021ad:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  8021b4:	7e b5                	jle    80216b <fork+0x1b4>
  8021b6:	eb 0c                	jmp    8021c4 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  8021b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021bb:	83 c0 01             	add    $0x1,%eax
  8021be:	c1 e0 09             	shl    $0x9,%eax
  8021c1:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8021c4:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  8021c8:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  8021cc:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  8021d3:	0f 8e 6e ff ff ff    	jle    802147 <fork+0x190>
  8021d9:	eb 0c                	jmp    8021e7 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  8021db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021de:	83 c0 01             	add    $0x1,%eax
  8021e1:	c1 e0 09             	shl    $0x9,%eax
  8021e4:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  8021e7:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  8021eb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021ee:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8021f1:	0f 8c 25 ff ff ff    	jl     80211c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8021f7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8021fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021fe:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802201:	0f 8c ea fe ff ff    	jl     8020f1 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802207:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80220a:	48 be 54 44 80 00 00 	movabs $0x804454,%rsi
  802211:	00 00 00 
  802214:	89 c7                	mov    %eax,%edi
  802216:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
  802222:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802225:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802229:	79 30                	jns    80225b <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80222b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80222e:	89 c1                	mov    %eax,%ecx
  802230:	48 ba 28 4c 80 00 00 	movabs $0x804c28,%rdx
  802237:	00 00 00 
  80223a:	be ad 00 00 00       	mov    $0xad,%esi
  80223f:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802246:	00 00 00 
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  802255:	00 00 00 
  802258:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80225b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80225e:	be 02 00 00 00       	mov    $0x2,%esi
  802263:	89 c7                	mov    %eax,%edi
  802265:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  80226c:	00 00 00 
  80226f:	ff d0                	callq  *%rax
  802271:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802274:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802278:	79 30                	jns    8022aa <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80227a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80227d:	89 c1                	mov    %eax,%ecx
  80227f:	48 ba 58 4c 80 00 00 	movabs $0x804c58,%rdx
  802286:	00 00 00 
  802289:	be b0 00 00 00       	mov    $0xb0,%esi
  80228e:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802295:	00 00 00 
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
  80229d:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  8022a4:	00 00 00 
  8022a7:	41 ff d0             	callq  *%r8
	return envid;
  8022aa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8022ad:	48 83 c4 48          	add    $0x48,%rsp
  8022b1:	5b                   	pop    %rbx
  8022b2:	5d                   	pop    %rbp
  8022b3:	c3                   	retq   

00000000008022b4 <sfork>:

// Challenge!
int
sfork(void)
{
  8022b4:	55                   	push   %rbp
  8022b5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8022b8:	48 ba 7c 4c 80 00 00 	movabs $0x804c7c,%rdx
  8022bf:	00 00 00 
  8022c2:	be b8 00 00 00       	mov    $0xb8,%esi
  8022c7:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  8022ce:	00 00 00 
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d6:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  8022dd:	00 00 00 
  8022e0:	ff d1                	callq  *%rcx
	...

00000000008022e4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022e4:	55                   	push   %rbp
  8022e5:	48 89 e5             	mov    %rsp,%rbp
  8022e8:	48 83 ec 30          	sub    $0x30,%rsp
  8022ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8022f8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8022fd:	74 18                	je     802317 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8022ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802303:	48 89 c7             	mov    %rax,%rdi
  802306:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802315:	eb 19                	jmp    802330 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802317:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80231e:	00 00 00 
  802321:	48 b8 09 1b 80 00 00 	movabs $0x801b09,%rax
  802328:	00 00 00 
  80232b:	ff d0                	callq  *%rax
  80232d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  802330:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802334:	79 19                	jns    80234f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  802336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  802340:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802344:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80234a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80234d:	eb 53                	jmp    8023a2 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80234f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802354:	74 19                	je     80236f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802356:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80235d:	00 00 00 
  802360:	48 8b 00             	mov    (%rax),%rax
  802363:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80236f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802374:	74 19                	je     80238f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802376:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80237d:	00 00 00 
  802380:	48 8b 00             	mov    (%rax),%rax
  802383:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80238f:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802396:	00 00 00 
  802399:	48 8b 00             	mov    (%rax),%rax
  80239c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8023a2:	c9                   	leaveq 
  8023a3:	c3                   	retq   

00000000008023a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
  8023a8:	48 83 ec 30          	sub    $0x30,%rsp
  8023ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023af:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8023b2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8023b6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8023b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8023c0:	e9 96 00 00 00       	jmpq   80245b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8023c5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023ca:	74 20                	je     8023ec <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8023cc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023cf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8023d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8023d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d9:	89 c7                	mov    %eax,%edi
  8023db:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  8023e2:	00 00 00 
  8023e5:	ff d0                	callq  *%rax
  8023e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ea:	eb 2d                	jmp    802419 <ipc_send+0x75>
		else if(pg==NULL)
  8023ec:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023f1:	75 26                	jne    802419 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8023f3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8023f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023fe:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802405:	00 00 00 
  802408:	89 c7                	mov    %eax,%edi
  80240a:	48 b8 b4 1a 80 00 00 	movabs $0x801ab4,%rax
  802411:	00 00 00 
  802414:	ff d0                	callq  *%rax
  802416:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802419:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80241d:	79 30                	jns    80244f <ipc_send+0xab>
  80241f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802423:	74 2a                	je     80244f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  802425:	48 ba 92 4c 80 00 00 	movabs $0x804c92,%rdx
  80242c:	00 00 00 
  80242f:	be 40 00 00 00       	mov    $0x40,%esi
  802434:	48 bf aa 4c 80 00 00 	movabs $0x804caa,%rdi
  80243b:	00 00 00 
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	48 b9 7c 42 80 00 00 	movabs $0x80427c,%rcx
  80244a:	00 00 00 
  80244d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80244f:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  802456:	00 00 00 
  802459:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80245b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245f:	0f 85 60 ff ff ff    	jne    8023c5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802465:	c9                   	leaveq 
  802466:	c3                   	retq   

0000000000802467 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802467:	55                   	push   %rbp
  802468:	48 89 e5             	mov    %rsp,%rbp
  80246b:	48 83 ec 18          	sub    $0x18,%rsp
  80246f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802479:	eb 5e                	jmp    8024d9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80247b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802482:	00 00 00 
  802485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802488:	48 63 d0             	movslq %eax,%rdx
  80248b:	48 89 d0             	mov    %rdx,%rax
  80248e:	48 c1 e0 03          	shl    $0x3,%rax
  802492:	48 01 d0             	add    %rdx,%rax
  802495:	48 c1 e0 05          	shl    $0x5,%rax
  802499:	48 01 c8             	add    %rcx,%rax
  80249c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8024a2:	8b 00                	mov    (%rax),%eax
  8024a4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024a7:	75 2c                	jne    8024d5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8024a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8024b0:	00 00 00 
  8024b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b6:	48 63 d0             	movslq %eax,%rdx
  8024b9:	48 89 d0             	mov    %rdx,%rax
  8024bc:	48 c1 e0 03          	shl    $0x3,%rax
  8024c0:	48 01 d0             	add    %rdx,%rax
  8024c3:	48 c1 e0 05          	shl    $0x5,%rax
  8024c7:	48 01 c8             	add    %rcx,%rax
  8024ca:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8024d0:	8b 40 08             	mov    0x8(%rax),%eax
  8024d3:	eb 12                	jmp    8024e7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024d5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024d9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8024e0:	7e 99                	jle    80247b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e7:	c9                   	leaveq 
  8024e8:	c3                   	retq   
  8024e9:	00 00                	add    %al,(%rax)
	...

00000000008024ec <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8024ec:	55                   	push   %rbp
  8024ed:	48 89 e5             	mov    %rsp,%rbp
  8024f0:	48 83 ec 08          	sub    $0x8,%rsp
  8024f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024fc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802503:	ff ff ff 
  802506:	48 01 d0             	add    %rdx,%rax
  802509:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80250d:	c9                   	leaveq 
  80250e:	c3                   	retq   

000000000080250f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
  802513:	48 83 ec 08          	sub    $0x8,%rsp
  802517:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80251b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251f:	48 89 c7             	mov    %rax,%rdi
  802522:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802529:	00 00 00 
  80252c:	ff d0                	callq  *%rax
  80252e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802534:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802538:	c9                   	leaveq 
  802539:	c3                   	retq   

000000000080253a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80253a:	55                   	push   %rbp
  80253b:	48 89 e5             	mov    %rsp,%rbp
  80253e:	48 83 ec 18          	sub    $0x18,%rsp
  802542:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802546:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80254d:	eb 6b                	jmp    8025ba <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80254f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802552:	48 98                	cltq   
  802554:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80255a:	48 c1 e0 0c          	shl    $0xc,%rax
  80255e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802562:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802566:	48 89 c2             	mov    %rax,%rdx
  802569:	48 c1 ea 15          	shr    $0x15,%rdx
  80256d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802574:	01 00 00 
  802577:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80257b:	83 e0 01             	and    $0x1,%eax
  80257e:	48 85 c0             	test   %rax,%rax
  802581:	74 21                	je     8025a4 <fd_alloc+0x6a>
  802583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802587:	48 89 c2             	mov    %rax,%rdx
  80258a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80258e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802595:	01 00 00 
  802598:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80259c:	83 e0 01             	and    $0x1,%eax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	75 12                	jne    8025b6 <fd_alloc+0x7c>
			*fd_store = fd;
  8025a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025ac:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b4:	eb 1a                	jmp    8025d0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025ba:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8025be:	7e 8f                	jle    80254f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8025c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8025cb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8025d0:	c9                   	leaveq 
  8025d1:	c3                   	retq   

00000000008025d2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8025d2:	55                   	push   %rbp
  8025d3:	48 89 e5             	mov    %rsp,%rbp
  8025d6:	48 83 ec 20          	sub    $0x20,%rsp
  8025da:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8025e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025e5:	78 06                	js     8025ed <fd_lookup+0x1b>
  8025e7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8025eb:	7e 07                	jle    8025f4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025f2:	eb 6c                	jmp    802660 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f7:	48 98                	cltq   
  8025f9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025ff:	48 c1 e0 0c          	shl    $0xc,%rax
  802603:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260b:	48 89 c2             	mov    %rax,%rdx
  80260e:	48 c1 ea 15          	shr    $0x15,%rdx
  802612:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802619:	01 00 00 
  80261c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802620:	83 e0 01             	and    $0x1,%eax
  802623:	48 85 c0             	test   %rax,%rax
  802626:	74 21                	je     802649 <fd_lookup+0x77>
  802628:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80262c:	48 89 c2             	mov    %rax,%rdx
  80262f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802633:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80263a:	01 00 00 
  80263d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802641:	83 e0 01             	and    $0x1,%eax
  802644:	48 85 c0             	test   %rax,%rax
  802647:	75 07                	jne    802650 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802649:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80264e:	eb 10                	jmp    802660 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802650:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802654:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802658:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802660:	c9                   	leaveq 
  802661:	c3                   	retq   

0000000000802662 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802662:	55                   	push   %rbp
  802663:	48 89 e5             	mov    %rsp,%rbp
  802666:	48 83 ec 30          	sub    $0x30,%rsp
  80266a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80266e:	89 f0                	mov    %esi,%eax
  802670:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802673:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802677:	48 89 c7             	mov    %rax,%rdi
  80267a:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802681:	00 00 00 
  802684:	ff d0                	callq  *%rax
  802686:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80268a:	48 89 d6             	mov    %rdx,%rsi
  80268d:	89 c7                	mov    %eax,%edi
  80268f:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
  80269b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026a2:	78 0a                	js     8026ae <fd_close+0x4c>
	    || fd != fd2)
  8026a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026ac:	74 12                	je     8026c0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026ae:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026b2:	74 05                	je     8026b9 <fd_close+0x57>
  8026b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b7:	eb 05                	jmp    8026be <fd_close+0x5c>
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	eb 69                	jmp    802729 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8026c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c4:	8b 00                	mov    (%rax),%eax
  8026c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ca:	48 89 d6             	mov    %rdx,%rsi
  8026cd:	89 c7                	mov    %eax,%edi
  8026cf:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  8026d6:	00 00 00 
  8026d9:	ff d0                	callq  *%rax
  8026db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e2:	78 2a                	js     80270e <fd_close+0xac>
		if (dev->dev_close)
  8026e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026ec:	48 85 c0             	test   %rax,%rax
  8026ef:	74 16                	je     802707 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8026f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8026f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026fd:	48 89 c7             	mov    %rax,%rdi
  802700:	ff d2                	callq  *%rdx
  802702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802705:	eb 07                	jmp    80270e <fd_close+0xac>
		else
			r = 0;
  802707:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80270e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802712:	48 89 c6             	mov    %rax,%rsi
  802715:	bf 00 00 00 00       	mov    $0x0,%edi
  80271a:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
	return r;
  802726:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802729:	c9                   	leaveq 
  80272a:	c3                   	retq   

000000000080272b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80272b:	55                   	push   %rbp
  80272c:	48 89 e5             	mov    %rsp,%rbp
  80272f:	48 83 ec 20          	sub    $0x20,%rsp
  802733:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802736:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80273a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802741:	eb 41                	jmp    802784 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802743:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80274a:	00 00 00 
  80274d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802750:	48 63 d2             	movslq %edx,%rdx
  802753:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802757:	8b 00                	mov    (%rax),%eax
  802759:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80275c:	75 22                	jne    802780 <dev_lookup+0x55>
			*dev = devtab[i];
  80275e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802765:	00 00 00 
  802768:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80276b:	48 63 d2             	movslq %edx,%rdx
  80276e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802772:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802776:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
  80277e:	eb 60                	jmp    8027e0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802780:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802784:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80278b:	00 00 00 
  80278e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802791:	48 63 d2             	movslq %edx,%rdx
  802794:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802798:	48 85 c0             	test   %rax,%rax
  80279b:	75 a6                	jne    802743 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80279d:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8027a4:	00 00 00 
  8027a7:	48 8b 00             	mov    (%rax),%rax
  8027aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027b3:	89 c6                	mov    %eax,%esi
  8027b5:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  8027bc:	00 00 00 
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  8027cb:	00 00 00 
  8027ce:	ff d1                	callq  *%rcx
	*dev = 0;
  8027d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027d4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8027db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8027e0:	c9                   	leaveq 
  8027e1:	c3                   	retq   

00000000008027e2 <close>:

int
close(int fdnum)
{
  8027e2:	55                   	push   %rbp
  8027e3:	48 89 e5             	mov    %rsp,%rbp
  8027e6:	48 83 ec 20          	sub    $0x20,%rsp
  8027ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027f4:	48 89 d6             	mov    %rdx,%rsi
  8027f7:	89 c7                	mov    %eax,%edi
  8027f9:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
  802805:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802808:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280c:	79 05                	jns    802813 <close+0x31>
		return r;
  80280e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802811:	eb 18                	jmp    80282b <close+0x49>
	else
		return fd_close(fd, 1);
  802813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802817:	be 01 00 00 00       	mov    $0x1,%esi
  80281c:	48 89 c7             	mov    %rax,%rdi
  80281f:	48 b8 62 26 80 00 00 	movabs $0x802662,%rax
  802826:	00 00 00 
  802829:	ff d0                	callq  *%rax
}
  80282b:	c9                   	leaveq 
  80282c:	c3                   	retq   

000000000080282d <close_all>:

void
close_all(void)
{
  80282d:	55                   	push   %rbp
  80282e:	48 89 e5             	mov    %rsp,%rbp
  802831:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80283c:	eb 15                	jmp    802853 <close_all+0x26>
		close(i);
  80283e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802841:	89 c7                	mov    %eax,%edi
  802843:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80284f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802853:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802857:	7e e5                	jle    80283e <close_all+0x11>
		close(i);
}
  802859:	c9                   	leaveq 
  80285a:	c3                   	retq   

000000000080285b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80285b:	55                   	push   %rbp
  80285c:	48 89 e5             	mov    %rsp,%rbp
  80285f:	48 83 ec 40          	sub    $0x40,%rsp
  802863:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802866:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802869:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80286d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802870:	48 89 d6             	mov    %rdx,%rsi
  802873:	89 c7                	mov    %eax,%edi
  802875:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
  802881:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802888:	79 08                	jns    802892 <dup+0x37>
		return r;
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	e9 70 01 00 00       	jmpq   802a02 <dup+0x1a7>
	close(newfdnum);
  802892:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802895:	89 c7                	mov    %eax,%edi
  802897:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  80289e:	00 00 00 
  8028a1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028a3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028a6:	48 98                	cltq   
  8028a8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028ae:	48 c1 e0 0c          	shl    $0xc,%rax
  8028b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ba:	48 89 c7             	mov    %rax,%rdi
  8028bd:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  8028c4:	00 00 00 
  8028c7:	ff d0                	callq  *%rax
  8028c9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8028cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d1:	48 89 c7             	mov    %rax,%rdi
  8028d4:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  8028db:	00 00 00 
  8028de:	ff d0                	callq  *%rax
  8028e0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8028e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e8:	48 89 c2             	mov    %rax,%rdx
  8028eb:	48 c1 ea 15          	shr    $0x15,%rdx
  8028ef:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028f6:	01 00 00 
  8028f9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028fd:	83 e0 01             	and    $0x1,%eax
  802900:	84 c0                	test   %al,%al
  802902:	74 71                	je     802975 <dup+0x11a>
  802904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802908:	48 89 c2             	mov    %rax,%rdx
  80290b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80290f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802916:	01 00 00 
  802919:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291d:	83 e0 01             	and    $0x1,%eax
  802920:	84 c0                	test   %al,%al
  802922:	74 51                	je     802975 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802928:	48 89 c2             	mov    %rax,%rdx
  80292b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80292f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802936:	01 00 00 
  802939:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293d:	89 c1                	mov    %eax,%ecx
  80293f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802945:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802949:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294d:	41 89 c8             	mov    %ecx,%r8d
  802950:	48 89 d1             	mov    %rdx,%rcx
  802953:	ba 00 00 00 00       	mov    $0x0,%edx
  802958:	48 89 c6             	mov    %rax,%rsi
  80295b:	bf 00 00 00 00       	mov    $0x0,%edi
  802960:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  802967:	00 00 00 
  80296a:	ff d0                	callq  *%rax
  80296c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802973:	78 56                	js     8029cb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802975:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802979:	48 89 c2             	mov    %rax,%rdx
  80297c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802980:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802987:	01 00 00 
  80298a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80298e:	89 c1                	mov    %eax,%ecx
  802990:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80299a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80299e:	41 89 c8             	mov    %ecx,%r8d
  8029a1:	48 89 d1             	mov    %rdx,%rcx
  8029a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a9:	48 89 c6             	mov    %rax,%rsi
  8029ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b1:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  8029b8:	00 00 00 
  8029bb:	ff d0                	callq  *%rax
  8029bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029c4:	78 08                	js     8029ce <dup+0x173>
		goto err;

	return newfdnum;
  8029c6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8029c9:	eb 37                	jmp    802a02 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8029cb:	90                   	nop
  8029cc:	eb 01                	jmp    8029cf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8029ce:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8029cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d3:	48 89 c6             	mov    %rax,%rsi
  8029d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029db:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  8029e2:	00 00 00 
  8029e5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8029e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029eb:	48 89 c6             	mov    %rax,%rsi
  8029ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f3:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  8029fa:	00 00 00 
  8029fd:	ff d0                	callq  *%rax
	return r;
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a02:	c9                   	leaveq 
  802a03:	c3                   	retq   

0000000000802a04 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
  802a08:	48 83 ec 40          	sub    $0x40,%rsp
  802a0c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a0f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a13:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a17:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a1b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1e:	48 89 d6             	mov    %rdx,%rsi
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802a2a:	00 00 00 
  802a2d:	ff d0                	callq  *%rax
  802a2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a36:	78 24                	js     802a5c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3c:	8b 00                	mov    (%rax),%eax
  802a3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a42:	48 89 d6             	mov    %rdx,%rsi
  802a45:	89 c7                	mov    %eax,%edi
  802a47:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  802a4e:	00 00 00 
  802a51:	ff d0                	callq  *%rax
  802a53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5a:	79 05                	jns    802a61 <read+0x5d>
		return r;
  802a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5f:	eb 7a                	jmp    802adb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a65:	8b 40 08             	mov    0x8(%rax),%eax
  802a68:	83 e0 03             	and    $0x3,%eax
  802a6b:	83 f8 01             	cmp    $0x1,%eax
  802a6e:	75 3a                	jne    802aaa <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a70:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802a77:	00 00 00 
  802a7a:	48 8b 00             	mov    (%rax),%rax
  802a7d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a83:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a86:	89 c6                	mov    %eax,%esi
  802a88:	48 bf d7 4c 80 00 00 	movabs $0x804cd7,%rdi
  802a8f:	00 00 00 
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
  802a97:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  802a9e:	00 00 00 
  802aa1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802aa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa8:	eb 31                	jmp    802adb <read+0xd7>
	}
	if (!dev->dev_read)
  802aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aae:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ab2:	48 85 c0             	test   %rax,%rax
  802ab5:	75 07                	jne    802abe <read+0xba>
		return -E_NOT_SUPP;
  802ab7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802abc:	eb 1d                	jmp    802adb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802abe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ace:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ad2:	48 89 ce             	mov    %rcx,%rsi
  802ad5:	48 89 c7             	mov    %rax,%rdi
  802ad8:	41 ff d0             	callq  *%r8
}
  802adb:	c9                   	leaveq 
  802adc:	c3                   	retq   

0000000000802add <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802add:	55                   	push   %rbp
  802ade:	48 89 e5             	mov    %rsp,%rbp
  802ae1:	48 83 ec 30          	sub    $0x30,%rsp
  802ae5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802aec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802af0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802af7:	eb 46                	jmp    802b3f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afc:	48 98                	cltq   
  802afe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b02:	48 29 c2             	sub    %rax,%rdx
  802b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b08:	48 98                	cltq   
  802b0a:	48 89 c1             	mov    %rax,%rcx
  802b0d:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802b11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b14:	48 89 ce             	mov    %rcx,%rsi
  802b17:	89 c7                	mov    %eax,%edi
  802b19:	48 b8 04 2a 80 00 00 	movabs $0x802a04,%rax
  802b20:	00 00 00 
  802b23:	ff d0                	callq  *%rax
  802b25:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b28:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b2c:	79 05                	jns    802b33 <readn+0x56>
			return m;
  802b2e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b31:	eb 1d                	jmp    802b50 <readn+0x73>
		if (m == 0)
  802b33:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b37:	74 13                	je     802b4c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b3c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b42:	48 98                	cltq   
  802b44:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b48:	72 af                	jb     802af9 <readn+0x1c>
  802b4a:	eb 01                	jmp    802b4d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b4c:	90                   	nop
	}
	return tot;
  802b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b50:	c9                   	leaveq 
  802b51:	c3                   	retq   

0000000000802b52 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b52:	55                   	push   %rbp
  802b53:	48 89 e5             	mov    %rsp,%rbp
  802b56:	48 83 ec 40          	sub    $0x40,%rsp
  802b5a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b5d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b61:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b65:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b69:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b6c:	48 89 d6             	mov    %rdx,%rsi
  802b6f:	89 c7                	mov    %eax,%edi
  802b71:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802b78:	00 00 00 
  802b7b:	ff d0                	callq  *%rax
  802b7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b84:	78 24                	js     802baa <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8a:	8b 00                	mov    (%rax),%eax
  802b8c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b90:	48 89 d6             	mov    %rdx,%rsi
  802b93:	89 c7                	mov    %eax,%edi
  802b95:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  802b9c:	00 00 00 
  802b9f:	ff d0                	callq  *%rax
  802ba1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ba8:	79 05                	jns    802baf <write+0x5d>
		return r;
  802baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bad:	eb 79                	jmp    802c28 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802baf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb3:	8b 40 08             	mov    0x8(%rax),%eax
  802bb6:	83 e0 03             	and    $0x3,%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	75 3a                	jne    802bf7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802bbd:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802bc4:	00 00 00 
  802bc7:	48 8b 00             	mov    (%rax),%rax
  802bca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bd0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bd3:	89 c6                	mov    %eax,%esi
  802bd5:	48 bf f3 4c 80 00 00 	movabs $0x804cf3,%rdi
  802bdc:	00 00 00 
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802be4:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  802beb:	00 00 00 
  802bee:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802bf0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bf5:	eb 31                	jmp    802c28 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802bf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bff:	48 85 c0             	test   %rax,%rax
  802c02:	75 07                	jne    802c0b <write+0xb9>
		return -E_NOT_SUPP;
  802c04:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c09:	eb 1d                	jmp    802c28 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802c0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0f:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c17:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c1b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c1f:	48 89 ce             	mov    %rcx,%rsi
  802c22:	48 89 c7             	mov    %rax,%rdi
  802c25:	41 ff d0             	callq  *%r8
}
  802c28:	c9                   	leaveq 
  802c29:	c3                   	retq   

0000000000802c2a <seek>:

int
seek(int fdnum, off_t offset)
{
  802c2a:	55                   	push   %rbp
  802c2b:	48 89 e5             	mov    %rsp,%rbp
  802c2e:	48 83 ec 18          	sub    $0x18,%rsp
  802c32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c35:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c38:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c3f:	48 89 d6             	mov    %rdx,%rsi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802c4b:	00 00 00 
  802c4e:	ff d0                	callq  *%rax
  802c50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c57:	79 05                	jns    802c5e <seek+0x34>
		return r;
  802c59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5c:	eb 0f                	jmp    802c6d <seek+0x43>
	fd->fd_offset = offset;
  802c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c62:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6d:	c9                   	leaveq 
  802c6e:	c3                   	retq   

0000000000802c6f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c6f:	55                   	push   %rbp
  802c70:	48 89 e5             	mov    %rsp,%rbp
  802c73:	48 83 ec 30          	sub    $0x30,%rsp
  802c77:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c7a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c7d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c81:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c84:	48 89 d6             	mov    %rdx,%rsi
  802c87:	89 c7                	mov    %eax,%edi
  802c89:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802c90:	00 00 00 
  802c93:	ff d0                	callq  *%rax
  802c95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9c:	78 24                	js     802cc2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca2:	8b 00                	mov    (%rax),%eax
  802ca4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ca8:	48 89 d6             	mov    %rdx,%rsi
  802cab:	89 c7                	mov    %eax,%edi
  802cad:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  802cb4:	00 00 00 
  802cb7:	ff d0                	callq  *%rax
  802cb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc0:	79 05                	jns    802cc7 <ftruncate+0x58>
		return r;
  802cc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc5:	eb 72                	jmp    802d39 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802cc7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ccb:	8b 40 08             	mov    0x8(%rax),%eax
  802cce:	83 e0 03             	and    $0x3,%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	75 3a                	jne    802d0f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802cd5:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802cdc:	00 00 00 
  802cdf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ce2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ceb:	89 c6                	mov    %eax,%esi
  802ced:	48 bf 10 4d 80 00 00 	movabs $0x804d10,%rdi
  802cf4:	00 00 00 
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfc:	48 b9 eb 03 80 00 00 	movabs $0x8003eb,%rcx
  802d03:	00 00 00 
  802d06:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d0d:	eb 2a                	jmp    802d39 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d13:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d17:	48 85 c0             	test   %rax,%rax
  802d1a:	75 07                	jne    802d23 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d1c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d21:	eb 16                	jmp    802d39 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d27:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802d2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d32:	89 d6                	mov    %edx,%esi
  802d34:	48 89 c7             	mov    %rax,%rdi
  802d37:	ff d1                	callq  *%rcx
}
  802d39:	c9                   	leaveq 
  802d3a:	c3                   	retq   

0000000000802d3b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d3b:	55                   	push   %rbp
  802d3c:	48 89 e5             	mov    %rsp,%rbp
  802d3f:	48 83 ec 30          	sub    $0x30,%rsp
  802d43:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d46:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d4a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d4e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d51:	48 89 d6             	mov    %rdx,%rsi
  802d54:	89 c7                	mov    %eax,%edi
  802d56:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	callq  *%rax
  802d62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d69:	78 24                	js     802d8f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6f:	8b 00                	mov    (%rax),%eax
  802d71:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d75:	48 89 d6             	mov    %rdx,%rsi
  802d78:	89 c7                	mov    %eax,%edi
  802d7a:	48 b8 2b 27 80 00 00 	movabs $0x80272b,%rax
  802d81:	00 00 00 
  802d84:	ff d0                	callq  *%rax
  802d86:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8d:	79 05                	jns    802d94 <fstat+0x59>
		return r;
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	eb 5e                	jmp    802df2 <fstat+0xb7>
	if (!dev->dev_stat)
  802d94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d98:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d9c:	48 85 c0             	test   %rax,%rax
  802d9f:	75 07                	jne    802da8 <fstat+0x6d>
		return -E_NOT_SUPP;
  802da1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802da6:	eb 4a                	jmp    802df2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802da8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dac:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802daf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dba:	00 00 00 
	stat->st_isdir = 0;
  802dbd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802dc8:	00 00 00 
	stat->st_dev = dev;
  802dcb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dcf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802dda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dde:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802dea:	48 89 d6             	mov    %rdx,%rsi
  802ded:	48 89 c7             	mov    %rax,%rdi
  802df0:	ff d1                	callq  *%rcx
}
  802df2:	c9                   	leaveq 
  802df3:	c3                   	retq   

0000000000802df4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802df4:	55                   	push   %rbp
  802df5:	48 89 e5             	mov    %rsp,%rbp
  802df8:	48 83 ec 20          	sub    $0x20,%rsp
  802dfc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e08:	be 00 00 00 00       	mov    $0x0,%esi
  802e0d:	48 89 c7             	mov    %rax,%rdi
  802e10:	48 b8 e3 2e 80 00 00 	movabs $0x802ee3,%rax
  802e17:	00 00 00 
  802e1a:	ff d0                	callq  *%rax
  802e1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e23:	79 05                	jns    802e2a <stat+0x36>
		return fd;
  802e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e28:	eb 2f                	jmp    802e59 <stat+0x65>
	r = fstat(fd, stat);
  802e2a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e31:	48 89 d6             	mov    %rdx,%rsi
  802e34:	89 c7                	mov    %eax,%edi
  802e36:	48 b8 3b 2d 80 00 00 	movabs $0x802d3b,%rax
  802e3d:	00 00 00 
  802e40:	ff d0                	callq  *%rax
  802e42:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e48:	89 c7                	mov    %eax,%edi
  802e4a:	48 b8 e2 27 80 00 00 	movabs $0x8027e2,%rax
  802e51:	00 00 00 
  802e54:	ff d0                	callq  *%rax
	return r;
  802e56:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e59:	c9                   	leaveq 
  802e5a:	c3                   	retq   
	...

0000000000802e5c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e5c:	55                   	push   %rbp
  802e5d:	48 89 e5             	mov    %rsp,%rbp
  802e60:	48 83 ec 10          	sub    $0x10,%rsp
  802e64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e6b:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802e72:	00 00 00 
  802e75:	8b 00                	mov    (%rax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	75 1d                	jne    802e98 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e7b:	bf 01 00 00 00       	mov    $0x1,%edi
  802e80:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  802e87:	00 00 00 
  802e8a:	ff d0                	callq  *%rax
  802e8c:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802e93:	00 00 00 
  802e96:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e98:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802e9f:	00 00 00 
  802ea2:	8b 00                	mov    (%rax),%eax
  802ea4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ea7:	b9 07 00 00 00       	mov    $0x7,%ecx
  802eac:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802eb3:	00 00 00 
  802eb6:	89 c7                	mov    %eax,%edi
  802eb8:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  802ebf:	00 00 00 
  802ec2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ecd:	48 89 c6             	mov    %rax,%rsi
  802ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed5:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  802edc:	00 00 00 
  802edf:	ff d0                	callq  *%rax
}
  802ee1:	c9                   	leaveq 
  802ee2:	c3                   	retq   

0000000000802ee3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802ee3:	55                   	push   %rbp
  802ee4:	48 89 e5             	mov    %rsp,%rbp
  802ee7:	48 83 ec 20          	sub    $0x20,%rsp
  802eeb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eef:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802ef2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef6:	48 89 c7             	mov    %rax,%rdi
  802ef9:	48 b8 3c 0f 80 00 00 	movabs $0x800f3c,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
  802f05:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f0a:	7e 0a                	jle    802f16 <open+0x33>
                return -E_BAD_PATH;
  802f0c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f11:	e9 a5 00 00 00       	jmpq   802fbb <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802f16:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f1a:	48 89 c7             	mov    %rax,%rdi
  802f1d:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	79 08                	jns    802f3a <open+0x57>
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	e9 81 00 00 00       	jmpq   802fbb <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3e:	48 89 c6             	mov    %rax,%rsi
  802f41:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f48:	00 00 00 
  802f4b:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802f57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f5e:	00 00 00 
  802f61:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f64:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6e:	48 89 c6             	mov    %rax,%rsi
  802f71:	bf 01 00 00 00       	mov    $0x1,%edi
  802f76:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  802f7d:	00 00 00 
  802f80:	ff d0                	callq  *%rax
  802f82:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802f85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f89:	79 1d                	jns    802fa8 <open+0xc5>
	{
		fd_close(fd,0);
  802f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8f:	be 00 00 00 00       	mov    $0x0,%esi
  802f94:	48 89 c7             	mov    %rax,%rdi
  802f97:	48 b8 62 26 80 00 00 	movabs $0x802662,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
		return r;
  802fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa6:	eb 13                	jmp    802fbb <open+0xd8>
	}
	return fd2num(fd);
  802fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fac:	48 89 c7             	mov    %rax,%rdi
  802faf:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  802fb6:	00 00 00 
  802fb9:	ff d0                	callq  *%rax
	


}
  802fbb:	c9                   	leaveq 
  802fbc:	c3                   	retq   

0000000000802fbd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802fbd:	55                   	push   %rbp
  802fbe:	48 89 e5             	mov    %rsp,%rbp
  802fc1:	48 83 ec 10          	sub    $0x10,%rsp
  802fc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fcd:	8b 50 0c             	mov    0xc(%rax),%edx
  802fd0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fd7:	00 00 00 
  802fda:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802fdc:	be 00 00 00 00       	mov    $0x0,%esi
  802fe1:	bf 06 00 00 00       	mov    $0x6,%edi
  802fe6:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  802fed:	00 00 00 
  802ff0:	ff d0                	callq  *%rax
}
  802ff2:	c9                   	leaveq 
  802ff3:	c3                   	retq   

0000000000802ff4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ff4:	55                   	push   %rbp
  802ff5:	48 89 e5             	mov    %rsp,%rbp
  802ff8:	48 83 ec 30          	sub    $0x30,%rsp
  802ffc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803000:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803004:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300c:	8b 50 0c             	mov    0xc(%rax),%edx
  80300f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803016:	00 00 00 
  803019:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80301b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803022:	00 00 00 
  803025:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803029:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80302d:	be 00 00 00 00       	mov    $0x0,%esi
  803032:	bf 03 00 00 00       	mov    $0x3,%edi
  803037:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  80303e:	00 00 00 
  803041:	ff d0                	callq  *%rax
  803043:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803046:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80304a:	79 05                	jns    803051 <devfile_read+0x5d>
	{
		return r;
  80304c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80304f:	eb 2c                	jmp    80307d <devfile_read+0x89>
	}
	if(r > 0)
  803051:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803055:	7e 23                	jle    80307a <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803057:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305a:	48 63 d0             	movslq %eax,%rdx
  80305d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803061:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803068:	00 00 00 
  80306b:	48 89 c7             	mov    %rax,%rdi
  80306e:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803075:	00 00 00 
  803078:	ff d0                	callq  *%rax
	return r;
  80307a:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  80307d:	c9                   	leaveq 
  80307e:	c3                   	retq   

000000000080307f <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80307f:	55                   	push   %rbp
  803080:	48 89 e5             	mov    %rsp,%rbp
  803083:	48 83 ec 30          	sub    $0x30,%rsp
  803087:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80308b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80308f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  803093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803097:	8b 50 0c             	mov    0xc(%rax),%edx
  80309a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a1:	00 00 00 
  8030a4:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8030a6:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030ad:	00 
  8030ae:	76 08                	jbe    8030b8 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8030b0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030b7:	00 
	fsipcbuf.write.req_n=n;
  8030b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030bf:	00 00 00 
  8030c2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030c6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8030ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d2:	48 89 c6             	mov    %rax,%rsi
  8030d5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8030dc:	00 00 00 
  8030df:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8030e6:	00 00 00 
  8030e9:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8030eb:	be 00 00 00 00       	mov    $0x0,%esi
  8030f0:	bf 04 00 00 00       	mov    $0x4,%edi
  8030f5:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  8030fc:	00 00 00 
  8030ff:	ff d0                	callq  *%rax
  803101:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803104:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803107:	c9                   	leaveq 
  803108:	c3                   	retq   

0000000000803109 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803109:	55                   	push   %rbp
  80310a:	48 89 e5             	mov    %rsp,%rbp
  80310d:	48 83 ec 10          	sub    $0x10,%rsp
  803111:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803115:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803118:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311c:	8b 50 0c             	mov    0xc(%rax),%edx
  80311f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803126:	00 00 00 
  803129:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80312b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803132:	00 00 00 
  803135:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803138:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80313b:	be 00 00 00 00       	mov    $0x0,%esi
  803140:	bf 02 00 00 00       	mov    $0x2,%edi
  803145:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	callq  *%rax
}
  803151:	c9                   	leaveq 
  803152:	c3                   	retq   

0000000000803153 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803153:	55                   	push   %rbp
  803154:	48 89 e5             	mov    %rsp,%rbp
  803157:	48 83 ec 20          	sub    $0x20,%rsp
  80315b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80315f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803167:	8b 50 0c             	mov    0xc(%rax),%edx
  80316a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803171:	00 00 00 
  803174:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803176:	be 00 00 00 00       	mov    $0x0,%esi
  80317b:	bf 05 00 00 00       	mov    $0x5,%edi
  803180:	48 b8 5c 2e 80 00 00 	movabs $0x802e5c,%rax
  803187:	00 00 00 
  80318a:	ff d0                	callq  *%rax
  80318c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80318f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803193:	79 05                	jns    80319a <devfile_stat+0x47>
		return r;
  803195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803198:	eb 56                	jmp    8031f0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80319a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80319e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031a5:	00 00 00 
  8031a8:	48 89 c7             	mov    %rax,%rdi
  8031ab:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  8031b2:	00 00 00 
  8031b5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031be:	00 00 00 
  8031c1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031cb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031d8:	00 00 00 
  8031db:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8031e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8031eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f0:	c9                   	leaveq 
  8031f1:	c3                   	retq   
	...

00000000008031f4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8031f4:	55                   	push   %rbp
  8031f5:	48 89 e5             	mov    %rsp,%rbp
  8031f8:	48 83 ec 20          	sub    $0x20,%rsp
  8031fc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8031ff:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803203:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803206:	48 89 d6             	mov    %rdx,%rsi
  803209:	89 c7                	mov    %eax,%edi
  80320b:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  803212:	00 00 00 
  803215:	ff d0                	callq  *%rax
  803217:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80321a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321e:	79 05                	jns    803225 <fd2sockid+0x31>
		return r;
  803220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803223:	eb 24                	jmp    803249 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803225:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803229:	8b 10                	mov    (%rax),%edx
  80322b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803232:	00 00 00 
  803235:	8b 00                	mov    (%rax),%eax
  803237:	39 c2                	cmp    %eax,%edx
  803239:	74 07                	je     803242 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80323b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803240:	eb 07                	jmp    803249 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803242:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803246:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803249:	c9                   	leaveq 
  80324a:	c3                   	retq   

000000000080324b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80324b:	55                   	push   %rbp
  80324c:	48 89 e5             	mov    %rsp,%rbp
  80324f:	48 83 ec 20          	sub    $0x20,%rsp
  803253:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803256:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80325a:	48 89 c7             	mov    %rax,%rdi
  80325d:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  803264:	00 00 00 
  803267:	ff d0                	callq  *%rax
  803269:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80326c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803270:	78 26                	js     803298 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803276:	ba 07 04 00 00       	mov    $0x407,%edx
  80327b:	48 89 c6             	mov    %rax,%rsi
  80327e:	bf 00 00 00 00       	mov    $0x0,%edi
  803283:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  80328a:	00 00 00 
  80328d:	ff d0                	callq  *%rax
  80328f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803292:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803296:	79 16                	jns    8032ae <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803298:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80329b:	89 c7                	mov    %eax,%edi
  80329d:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  8032a4:	00 00 00 
  8032a7:	ff d0                	callq  *%rax
		return r;
  8032a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ac:	eb 3a                	jmp    8032e8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032b9:	00 00 00 
  8032bc:	8b 12                	mov    (%rdx),%edx
  8032be:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8032c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8032cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032d2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8032d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d9:	48 89 c7             	mov    %rax,%rdi
  8032dc:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
}
  8032e8:	c9                   	leaveq 
  8032e9:	c3                   	retq   

00000000008032ea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8032ea:	55                   	push   %rbp
  8032eb:	48 89 e5             	mov    %rsp,%rbp
  8032ee:	48 83 ec 30          	sub    $0x30,%rsp
  8032f2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8032fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803300:	89 c7                	mov    %eax,%edi
  803302:	48 b8 f4 31 80 00 00 	movabs $0x8031f4,%rax
  803309:	00 00 00 
  80330c:	ff d0                	callq  *%rax
  80330e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803311:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803315:	79 05                	jns    80331c <accept+0x32>
		return r;
  803317:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331a:	eb 3b                	jmp    803357 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80331c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803320:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803327:	48 89 ce             	mov    %rcx,%rsi
  80332a:	89 c7                	mov    %eax,%edi
  80332c:	48 b8 35 36 80 00 00 	movabs $0x803635,%rax
  803333:	00 00 00 
  803336:	ff d0                	callq  *%rax
  803338:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80333b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80333f:	79 05                	jns    803346 <accept+0x5c>
		return r;
  803341:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803344:	eb 11                	jmp    803357 <accept+0x6d>
	return alloc_sockfd(r);
  803346:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803349:	89 c7                	mov    %eax,%edi
  80334b:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803352:	00 00 00 
  803355:	ff d0                	callq  *%rax
}
  803357:	c9                   	leaveq 
  803358:	c3                   	retq   

0000000000803359 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803359:	55                   	push   %rbp
  80335a:	48 89 e5             	mov    %rsp,%rbp
  80335d:	48 83 ec 20          	sub    $0x20,%rsp
  803361:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803364:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803368:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80336b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336e:	89 c7                	mov    %eax,%edi
  803370:	48 b8 f4 31 80 00 00 	movabs $0x8031f4,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803383:	79 05                	jns    80338a <bind+0x31>
		return r;
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	eb 1b                	jmp    8033a5 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80338a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80338d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803394:	48 89 ce             	mov    %rcx,%rsi
  803397:	89 c7                	mov    %eax,%edi
  803399:	48 b8 b4 36 80 00 00 	movabs $0x8036b4,%rax
  8033a0:	00 00 00 
  8033a3:	ff d0                	callq  *%rax
}
  8033a5:	c9                   	leaveq 
  8033a6:	c3                   	retq   

00000000008033a7 <shutdown>:

int
shutdown(int s, int how)
{
  8033a7:	55                   	push   %rbp
  8033a8:	48 89 e5             	mov    %rsp,%rbp
  8033ab:	48 83 ec 20          	sub    $0x20,%rsp
  8033af:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b8:	89 c7                	mov    %eax,%edi
  8033ba:	48 b8 f4 31 80 00 00 	movabs $0x8031f4,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	callq  *%rax
  8033c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cd:	79 05                	jns    8033d4 <shutdown+0x2d>
		return r;
  8033cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d2:	eb 16                	jmp    8033ea <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8033d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033da:	89 d6                	mov    %edx,%esi
  8033dc:	89 c7                	mov    %eax,%edi
  8033de:	48 b8 18 37 80 00 00 	movabs $0x803718,%rax
  8033e5:	00 00 00 
  8033e8:	ff d0                	callq  *%rax
}
  8033ea:	c9                   	leaveq 
  8033eb:	c3                   	retq   

00000000008033ec <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8033ec:	55                   	push   %rbp
  8033ed:	48 89 e5             	mov    %rsp,%rbp
  8033f0:	48 83 ec 10          	sub    $0x10,%rsp
  8033f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8033f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033fc:	48 89 c7             	mov    %rax,%rdi
  8033ff:	48 b8 e0 44 80 00 00 	movabs $0x8044e0,%rax
  803406:	00 00 00 
  803409:	ff d0                	callq  *%rax
  80340b:	83 f8 01             	cmp    $0x1,%eax
  80340e:	75 17                	jne    803427 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803414:	8b 40 0c             	mov    0xc(%rax),%eax
  803417:	89 c7                	mov    %eax,%edi
  803419:	48 b8 58 37 80 00 00 	movabs $0x803758,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
  803425:	eb 05                	jmp    80342c <devsock_close+0x40>
	else
		return 0;
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342c:	c9                   	leaveq 
  80342d:	c3                   	retq   

000000000080342e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80342e:	55                   	push   %rbp
  80342f:	48 89 e5             	mov    %rsp,%rbp
  803432:	48 83 ec 20          	sub    $0x20,%rsp
  803436:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803439:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80343d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803440:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803443:	89 c7                	mov    %eax,%edi
  803445:	48 b8 f4 31 80 00 00 	movabs $0x8031f4,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
  803451:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803454:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803458:	79 05                	jns    80345f <connect+0x31>
		return r;
  80345a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345d:	eb 1b                	jmp    80347a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80345f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803462:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803466:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803469:	48 89 ce             	mov    %rcx,%rsi
  80346c:	89 c7                	mov    %eax,%edi
  80346e:	48 b8 85 37 80 00 00 	movabs $0x803785,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
}
  80347a:	c9                   	leaveq 
  80347b:	c3                   	retq   

000000000080347c <listen>:

int
listen(int s, int backlog)
{
  80347c:	55                   	push   %rbp
  80347d:	48 89 e5             	mov    %rsp,%rbp
  803480:	48 83 ec 20          	sub    $0x20,%rsp
  803484:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803487:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80348a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348d:	89 c7                	mov    %eax,%edi
  80348f:	48 b8 f4 31 80 00 00 	movabs $0x8031f4,%rax
  803496:	00 00 00 
  803499:	ff d0                	callq  *%rax
  80349b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a2:	79 05                	jns    8034a9 <listen+0x2d>
		return r;
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	eb 16                	jmp    8034bf <listen+0x43>
	return nsipc_listen(r, backlog);
  8034a9:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034af:	89 d6                	mov    %edx,%esi
  8034b1:	89 c7                	mov    %eax,%edi
  8034b3:	48 b8 e9 37 80 00 00 	movabs $0x8037e9,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
}
  8034bf:	c9                   	leaveq 
  8034c0:	c3                   	retq   

00000000008034c1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8034c1:	55                   	push   %rbp
  8034c2:	48 89 e5             	mov    %rsp,%rbp
  8034c5:	48 83 ec 20          	sub    $0x20,%rsp
  8034c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8034d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8034d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d9:	89 c2                	mov    %eax,%edx
  8034db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034df:	8b 40 0c             	mov    0xc(%rax),%eax
  8034e2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8034e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8034eb:	89 c7                	mov    %eax,%edi
  8034ed:	48 b8 29 38 80 00 00 	movabs $0x803829,%rax
  8034f4:	00 00 00 
  8034f7:	ff d0                	callq  *%rax
}
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	48 83 ec 20          	sub    $0x20,%rsp
  803503:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803507:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80350b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80350f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803513:	89 c2                	mov    %eax,%edx
  803515:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803519:	8b 40 0c             	mov    0xc(%rax),%eax
  80351c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803520:	b9 00 00 00 00       	mov    $0x0,%ecx
  803525:	89 c7                	mov    %eax,%edi
  803527:	48 b8 f5 38 80 00 00 	movabs $0x8038f5,%rax
  80352e:	00 00 00 
  803531:	ff d0                	callq  *%rax
}
  803533:	c9                   	leaveq 
  803534:	c3                   	retq   

0000000000803535 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803535:	55                   	push   %rbp
  803536:	48 89 e5             	mov    %rsp,%rbp
  803539:	48 83 ec 10          	sub    $0x10,%rsp
  80353d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803541:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803549:	48 be 3b 4d 80 00 00 	movabs $0x804d3b,%rsi
  803550:	00 00 00 
  803553:	48 89 c7             	mov    %rax,%rdi
  803556:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80355d:	00 00 00 
  803560:	ff d0                	callq  *%rax
	return 0;
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803567:	c9                   	leaveq 
  803568:	c3                   	retq   

0000000000803569 <socket>:

int
socket(int domain, int type, int protocol)
{
  803569:	55                   	push   %rbp
  80356a:	48 89 e5             	mov    %rsp,%rbp
  80356d:	48 83 ec 20          	sub    $0x20,%rsp
  803571:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803574:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803577:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80357a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80357d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803580:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803583:	89 ce                	mov    %ecx,%esi
  803585:	89 c7                	mov    %eax,%edi
  803587:	48 b8 ad 39 80 00 00 	movabs $0x8039ad,%rax
  80358e:	00 00 00 
  803591:	ff d0                	callq  *%rax
  803593:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803596:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359a:	79 05                	jns    8035a1 <socket+0x38>
		return r;
  80359c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359f:	eb 11                	jmp    8035b2 <socket+0x49>
	return alloc_sockfd(r);
  8035a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a4:	89 c7                	mov    %eax,%edi
  8035a6:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
}
  8035b2:	c9                   	leaveq 
  8035b3:	c3                   	retq   

00000000008035b4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035b4:	55                   	push   %rbp
  8035b5:	48 89 e5             	mov    %rsp,%rbp
  8035b8:	48 83 ec 10          	sub    $0x10,%rsp
  8035bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8035bf:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  8035c6:	00 00 00 
  8035c9:	8b 00                	mov    (%rax),%eax
  8035cb:	85 c0                	test   %eax,%eax
  8035cd:	75 1d                	jne    8035ec <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035cf:	bf 02 00 00 00       	mov    $0x2,%edi
  8035d4:	48 b8 67 24 80 00 00 	movabs $0x802467,%rax
  8035db:	00 00 00 
  8035de:	ff d0                	callq  *%rax
  8035e0:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  8035e7:	00 00 00 
  8035ea:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035ec:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  8035f3:	00 00 00 
  8035f6:	8b 00                	mov    (%rax),%eax
  8035f8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8035fb:	b9 07 00 00 00       	mov    $0x7,%ecx
  803600:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803607:	00 00 00 
  80360a:	89 c7                	mov    %eax,%edi
  80360c:	48 b8 a4 23 80 00 00 	movabs $0x8023a4,%rax
  803613:	00 00 00 
  803616:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803618:	ba 00 00 00 00       	mov    $0x0,%edx
  80361d:	be 00 00 00 00       	mov    $0x0,%esi
  803622:	bf 00 00 00 00       	mov    $0x0,%edi
  803627:	48 b8 e4 22 80 00 00 	movabs $0x8022e4,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
}
  803633:	c9                   	leaveq 
  803634:	c3                   	retq   

0000000000803635 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803635:	55                   	push   %rbp
  803636:	48 89 e5             	mov    %rsp,%rbp
  803639:	48 83 ec 30          	sub    $0x30,%rsp
  80363d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803640:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803644:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803648:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80364f:	00 00 00 
  803652:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803655:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803657:	bf 01 00 00 00       	mov    $0x1,%edi
  80365c:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803663:	00 00 00 
  803666:	ff d0                	callq  *%rax
  803668:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80366b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80366f:	78 3e                	js     8036af <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803671:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803678:	00 00 00 
  80367b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80367f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803683:	8b 40 10             	mov    0x10(%rax),%eax
  803686:	89 c2                	mov    %eax,%edx
  803688:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80368c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803690:	48 89 ce             	mov    %rcx,%rsi
  803693:	48 89 c7             	mov    %rax,%rdi
  803696:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036a6:	8b 50 10             	mov    0x10(%rax),%edx
  8036a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036ad:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036af:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036b2:	c9                   	leaveq 
  8036b3:	c3                   	retq   

00000000008036b4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036b4:	55                   	push   %rbp
  8036b5:	48 89 e5             	mov    %rsp,%rbp
  8036b8:	48 83 ec 10          	sub    $0x10,%rsp
  8036bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036c3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8036c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036cd:	00 00 00 
  8036d0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036d3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8036d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036dc:	48 89 c6             	mov    %rax,%rsi
  8036df:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8036e6:	00 00 00 
  8036e9:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8036f0:	00 00 00 
  8036f3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8036f5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036fc:	00 00 00 
  8036ff:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803702:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803705:	bf 02 00 00 00       	mov    $0x2,%edi
  80370a:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
}
  803716:	c9                   	leaveq 
  803717:	c3                   	retq   

0000000000803718 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803718:	55                   	push   %rbp
  803719:	48 89 e5             	mov    %rsp,%rbp
  80371c:	48 83 ec 10          	sub    $0x10,%rsp
  803720:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803723:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803726:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372d:	00 00 00 
  803730:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803733:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803735:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373c:	00 00 00 
  80373f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803745:	bf 03 00 00 00       	mov    $0x3,%edi
  80374a:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803751:	00 00 00 
  803754:	ff d0                	callq  *%rax
}
  803756:	c9                   	leaveq 
  803757:	c3                   	retq   

0000000000803758 <nsipc_close>:

int
nsipc_close(int s)
{
  803758:	55                   	push   %rbp
  803759:	48 89 e5             	mov    %rsp,%rbp
  80375c:	48 83 ec 10          	sub    $0x10,%rsp
  803760:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803763:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80376a:	00 00 00 
  80376d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803770:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803772:	bf 04 00 00 00       	mov    $0x4,%edi
  803777:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  80377e:	00 00 00 
  803781:	ff d0                	callq  *%rax
}
  803783:	c9                   	leaveq 
  803784:	c3                   	retq   

0000000000803785 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803785:	55                   	push   %rbp
  803786:	48 89 e5             	mov    %rsp,%rbp
  803789:	48 83 ec 10          	sub    $0x10,%rsp
  80378d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803790:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803794:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803797:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80379e:	00 00 00 
  8037a1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037a4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037a6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ad:	48 89 c6             	mov    %rax,%rsi
  8037b0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037b7:	00 00 00 
  8037ba:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8037c6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037cd:	00 00 00 
  8037d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037d3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8037d6:	bf 05 00 00 00       	mov    $0x5,%edi
  8037db:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
}
  8037e7:	c9                   	leaveq 
  8037e8:	c3                   	retq   

00000000008037e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8037e9:	55                   	push   %rbp
  8037ea:	48 89 e5             	mov    %rsp,%rbp
  8037ed:	48 83 ec 10          	sub    $0x10,%rsp
  8037f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037f4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8037f7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037fe:	00 00 00 
  803801:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803804:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803806:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80380d:	00 00 00 
  803810:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803813:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803816:	bf 06 00 00 00       	mov    $0x6,%edi
  80381b:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803822:	00 00 00 
  803825:	ff d0                	callq  *%rax
}
  803827:	c9                   	leaveq 
  803828:	c3                   	retq   

0000000000803829 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803829:	55                   	push   %rbp
  80382a:	48 89 e5             	mov    %rsp,%rbp
  80382d:	48 83 ec 30          	sub    $0x30,%rsp
  803831:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803834:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803838:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80383b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80383e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803845:	00 00 00 
  803848:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80384b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80384d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803854:	00 00 00 
  803857:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80385a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80385d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803864:	00 00 00 
  803867:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80386a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80386d:	bf 07 00 00 00       	mov    $0x7,%edi
  803872:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  803879:	00 00 00 
  80387c:	ff d0                	callq  *%rax
  80387e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803881:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803885:	78 69                	js     8038f0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803887:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80388e:	7f 08                	jg     803898 <nsipc_recv+0x6f>
  803890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803893:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803896:	7e 35                	jle    8038cd <nsipc_recv+0xa4>
  803898:	48 b9 42 4d 80 00 00 	movabs $0x804d42,%rcx
  80389f:	00 00 00 
  8038a2:	48 ba 57 4d 80 00 00 	movabs $0x804d57,%rdx
  8038a9:	00 00 00 
  8038ac:	be 61 00 00 00       	mov    $0x61,%esi
  8038b1:	48 bf 6c 4d 80 00 00 	movabs $0x804d6c,%rdi
  8038b8:	00 00 00 
  8038bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c0:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  8038c7:	00 00 00 
  8038ca:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8038cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d0:	48 63 d0             	movslq %eax,%rdx
  8038d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038d7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8038de:	00 00 00 
  8038e1:	48 89 c7             	mov    %rax,%rdi
  8038e4:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8038eb:	00 00 00 
  8038ee:	ff d0                	callq  *%rax
	}

	return r;
  8038f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038f3:	c9                   	leaveq 
  8038f4:	c3                   	retq   

00000000008038f5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8038f5:	55                   	push   %rbp
  8038f6:	48 89 e5             	mov    %rsp,%rbp
  8038f9:	48 83 ec 20          	sub    $0x20,%rsp
  8038fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803900:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803904:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803907:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80390a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803911:	00 00 00 
  803914:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803917:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803919:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803920:	7e 35                	jle    803957 <nsipc_send+0x62>
  803922:	48 b9 78 4d 80 00 00 	movabs $0x804d78,%rcx
  803929:	00 00 00 
  80392c:	48 ba 57 4d 80 00 00 	movabs $0x804d57,%rdx
  803933:	00 00 00 
  803936:	be 6c 00 00 00       	mov    $0x6c,%esi
  80393b:	48 bf 6c 4d 80 00 00 	movabs $0x804d6c,%rdi
  803942:	00 00 00 
  803945:	b8 00 00 00 00       	mov    $0x0,%eax
  80394a:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  803951:	00 00 00 
  803954:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803957:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80395a:	48 63 d0             	movslq %eax,%rdx
  80395d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803961:	48 89 c6             	mov    %rax,%rsi
  803964:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  80396b:	00 00 00 
  80396e:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  803975:	00 00 00 
  803978:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80397a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803981:	00 00 00 
  803984:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803987:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80398a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803991:	00 00 00 
  803994:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803997:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80399a:	bf 08 00 00 00       	mov    $0x8,%edi
  80399f:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  8039a6:	00 00 00 
  8039a9:	ff d0                	callq  *%rax
}
  8039ab:	c9                   	leaveq 
  8039ac:	c3                   	retq   

00000000008039ad <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039ad:	55                   	push   %rbp
  8039ae:	48 89 e5             	mov    %rsp,%rbp
  8039b1:	48 83 ec 10          	sub    $0x10,%rsp
  8039b5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039b8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039bb:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8039be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c5:	00 00 00 
  8039c8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8039cb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8039cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d4:	00 00 00 
  8039d7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039da:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8039dd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039e4:	00 00 00 
  8039e7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8039ea:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8039ed:	bf 09 00 00 00       	mov    $0x9,%edi
  8039f2:	48 b8 b4 35 80 00 00 	movabs $0x8035b4,%rax
  8039f9:	00 00 00 
  8039fc:	ff d0                	callq  *%rax
}
  8039fe:	c9                   	leaveq 
  8039ff:	c3                   	retq   

0000000000803a00 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a00:	55                   	push   %rbp
  803a01:	48 89 e5             	mov    %rsp,%rbp
  803a04:	53                   	push   %rbx
  803a05:	48 83 ec 38          	sub    $0x38,%rsp
  803a09:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a0d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a11:	48 89 c7             	mov    %rax,%rdi
  803a14:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
  803a20:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a23:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a27:	0f 88 bf 01 00 00    	js     803bec <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a31:	ba 07 04 00 00       	mov    $0x407,%edx
  803a36:	48 89 c6             	mov    %rax,%rsi
  803a39:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3e:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a51:	0f 88 95 01 00 00    	js     803bec <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a57:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a5b:	48 89 c7             	mov    %rax,%rdi
  803a5e:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
  803a6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a71:	0f 88 5d 01 00 00    	js     803bd4 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a7b:	ba 07 04 00 00       	mov    $0x407,%edx
  803a80:	48 89 c6             	mov    %rax,%rsi
  803a83:	bf 00 00 00 00       	mov    $0x0,%edi
  803a88:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803a8f:	00 00 00 
  803a92:	ff d0                	callq  *%rax
  803a94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a9b:	0f 88 33 01 00 00    	js     803bd4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803aa1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa5:	48 89 c7             	mov    %rax,%rdi
  803aa8:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803aaf:	00 00 00 
  803ab2:	ff d0                	callq  *%rax
  803ab4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ab8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803abc:	ba 07 04 00 00       	mov    $0x407,%edx
  803ac1:	48 89 c6             	mov    %rax,%rsi
  803ac4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ac9:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  803ad0:	00 00 00 
  803ad3:	ff d0                	callq  *%rax
  803ad5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ad8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803adc:	0f 88 d9 00 00 00    	js     803bbb <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ae2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae6:	48 89 c7             	mov    %rax,%rdi
  803ae9:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803af0:	00 00 00 
  803af3:	ff d0                	callq  *%rax
  803af5:	48 89 c2             	mov    %rax,%rdx
  803af8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afc:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b02:	48 89 d1             	mov    %rdx,%rcx
  803b05:	ba 00 00 00 00       	mov    $0x0,%edx
  803b0a:	48 89 c6             	mov    %rax,%rsi
  803b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  803b12:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  803b19:	00 00 00 
  803b1c:	ff d0                	callq  *%rax
  803b1e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b25:	78 79                	js     803ba0 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b2b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b32:	00 00 00 
  803b35:	8b 12                	mov    (%rdx),%edx
  803b37:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b48:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b4f:	00 00 00 
  803b52:	8b 12                	mov    (%rdx),%edx
  803b54:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b5a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b65:	48 89 c7             	mov    %rax,%rdi
  803b68:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
  803b74:	89 c2                	mov    %eax,%edx
  803b76:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b7a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b7c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b80:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b88:	48 89 c7             	mov    %rax,%rdi
  803b8b:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  803b92:	00 00 00 
  803b95:	ff d0                	callq  *%rax
  803b97:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	eb 4f                	jmp    803bef <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803ba0:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba5:	48 89 c6             	mov    %rax,%rsi
  803ba8:	bf 00 00 00 00       	mov    $0x0,%edi
  803bad:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803bb4:	00 00 00 
  803bb7:	ff d0                	callq  *%rax
  803bb9:	eb 01                	jmp    803bbc <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803bbb:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803bbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bc0:	48 89 c6             	mov    %rax,%rsi
  803bc3:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc8:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803bcf:	00 00 00 
  803bd2:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803bd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd8:	48 89 c6             	mov    %rax,%rsi
  803bdb:	bf 00 00 00 00       	mov    $0x0,%edi
  803be0:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803be7:	00 00 00 
  803bea:	ff d0                	callq  *%rax
    err:
	return r;
  803bec:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803bef:	48 83 c4 38          	add    $0x38,%rsp
  803bf3:	5b                   	pop    %rbx
  803bf4:	5d                   	pop    %rbp
  803bf5:	c3                   	retq   

0000000000803bf6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803bf6:	55                   	push   %rbp
  803bf7:	48 89 e5             	mov    %rsp,%rbp
  803bfa:	53                   	push   %rbx
  803bfb:	48 83 ec 28          	sub    $0x28,%rsp
  803bff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c03:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c07:	eb 01                	jmp    803c0a <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c09:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c0a:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c11:	00 00 00 
  803c14:	48 8b 00             	mov    (%rax),%rax
  803c17:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c24:	48 89 c7             	mov    %rax,%rdi
  803c27:	48 b8 e0 44 80 00 00 	movabs $0x8044e0,%rax
  803c2e:	00 00 00 
  803c31:	ff d0                	callq  *%rax
  803c33:	89 c3                	mov    %eax,%ebx
  803c35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c39:	48 89 c7             	mov    %rax,%rdi
  803c3c:	48 b8 e0 44 80 00 00 	movabs $0x8044e0,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
  803c48:	39 c3                	cmp    %eax,%ebx
  803c4a:	0f 94 c0             	sete   %al
  803c4d:	0f b6 c0             	movzbl %al,%eax
  803c50:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c53:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c5a:	00 00 00 
  803c5d:	48 8b 00             	mov    (%rax),%rax
  803c60:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c66:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c6c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c6f:	75 0a                	jne    803c7b <_pipeisclosed+0x85>
			return ret;
  803c71:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803c74:	48 83 c4 28          	add    $0x28,%rsp
  803c78:	5b                   	pop    %rbx
  803c79:	5d                   	pop    %rbp
  803c7a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803c7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c7e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c81:	74 86                	je     803c09 <_pipeisclosed+0x13>
  803c83:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c87:	75 80                	jne    803c09 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c89:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803c90:	00 00 00 
  803c93:	48 8b 00             	mov    (%rax),%rax
  803c96:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c9c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c9f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ca2:	89 c6                	mov    %eax,%esi
  803ca4:	48 bf 89 4d 80 00 00 	movabs $0x804d89,%rdi
  803cab:	00 00 00 
  803cae:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb3:	49 b8 eb 03 80 00 00 	movabs $0x8003eb,%r8
  803cba:	00 00 00 
  803cbd:	41 ff d0             	callq  *%r8
	}
  803cc0:	e9 44 ff ff ff       	jmpq   803c09 <_pipeisclosed+0x13>

0000000000803cc5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 30          	sub    $0x30,%rsp
  803ccd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803cd0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803cd4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803cd7:	48 89 d6             	mov    %rdx,%rsi
  803cda:	89 c7                	mov    %eax,%edi
  803cdc:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
  803ce8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cef:	79 05                	jns    803cf6 <pipeisclosed+0x31>
		return r;
  803cf1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cf4:	eb 31                	jmp    803d27 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803cf6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cfa:	48 89 c7             	mov    %rax,%rdi
  803cfd:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803d04:	00 00 00 
  803d07:	ff d0                	callq  *%rax
  803d09:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d15:	48 89 d6             	mov    %rdx,%rsi
  803d18:	48 89 c7             	mov    %rax,%rdi
  803d1b:	48 b8 f6 3b 80 00 00 	movabs $0x803bf6,%rax
  803d22:	00 00 00 
  803d25:	ff d0                	callq  *%rax
}
  803d27:	c9                   	leaveq 
  803d28:	c3                   	retq   

0000000000803d29 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d29:	55                   	push   %rbp
  803d2a:	48 89 e5             	mov    %rsp,%rbp
  803d2d:	48 83 ec 40          	sub    $0x40,%rsp
  803d31:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d35:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d39:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d41:	48 89 c7             	mov    %rax,%rdi
  803d44:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803d4b:	00 00 00 
  803d4e:	ff d0                	callq  *%rax
  803d50:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d58:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d5c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d63:	00 
  803d64:	e9 97 00 00 00       	jmpq   803e00 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d69:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d6e:	74 09                	je     803d79 <devpipe_read+0x50>
				return i;
  803d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d74:	e9 95 00 00 00       	jmpq   803e0e <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d79:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d81:	48 89 d6             	mov    %rdx,%rsi
  803d84:	48 89 c7             	mov    %rax,%rdi
  803d87:	48 b8 f6 3b 80 00 00 	movabs $0x803bf6,%rax
  803d8e:	00 00 00 
  803d91:	ff d0                	callq  *%rax
  803d93:	85 c0                	test   %eax,%eax
  803d95:	74 07                	je     803d9e <devpipe_read+0x75>
				return 0;
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9c:	eb 70                	jmp    803e0e <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d9e:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  803da5:	00 00 00 
  803da8:	ff d0                	callq  *%rax
  803daa:	eb 01                	jmp    803dad <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dac:	90                   	nop
  803dad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db1:	8b 10                	mov    (%rax),%edx
  803db3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803db7:	8b 40 04             	mov    0x4(%rax),%eax
  803dba:	39 c2                	cmp    %eax,%edx
  803dbc:	74 ab                	je     803d69 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803dbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803dc6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803dca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dce:	8b 00                	mov    (%rax),%eax
  803dd0:	89 c2                	mov    %eax,%edx
  803dd2:	c1 fa 1f             	sar    $0x1f,%edx
  803dd5:	c1 ea 1b             	shr    $0x1b,%edx
  803dd8:	01 d0                	add    %edx,%eax
  803dda:	83 e0 1f             	and    $0x1f,%eax
  803ddd:	29 d0                	sub    %edx,%eax
  803ddf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803de3:	48 98                	cltq   
  803de5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803dea:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803dec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df0:	8b 00                	mov    (%rax),%eax
  803df2:	8d 50 01             	lea    0x1(%rax),%edx
  803df5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dfb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e04:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e08:	72 a2                	jb     803dac <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e0e:	c9                   	leaveq 
  803e0f:	c3                   	retq   

0000000000803e10 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e10:	55                   	push   %rbp
  803e11:	48 89 e5             	mov    %rsp,%rbp
  803e14:	48 83 ec 40          	sub    $0x40,%rsp
  803e18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e20:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e28:	48 89 c7             	mov    %rax,%rdi
  803e2b:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803e32:	00 00 00 
  803e35:	ff d0                	callq  *%rax
  803e37:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e3b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e43:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e4a:	00 
  803e4b:	e9 93 00 00 00       	jmpq   803ee3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e58:	48 89 d6             	mov    %rdx,%rsi
  803e5b:	48 89 c7             	mov    %rax,%rdi
  803e5e:	48 b8 f6 3b 80 00 00 	movabs $0x803bf6,%rax
  803e65:	00 00 00 
  803e68:	ff d0                	callq  *%rax
  803e6a:	85 c0                	test   %eax,%eax
  803e6c:	74 07                	je     803e75 <devpipe_write+0x65>
				return 0;
  803e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e73:	eb 7c                	jmp    803ef1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e75:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
  803e81:	eb 01                	jmp    803e84 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e83:	90                   	nop
  803e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e88:	8b 40 04             	mov    0x4(%rax),%eax
  803e8b:	48 63 d0             	movslq %eax,%rdx
  803e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e92:	8b 00                	mov    (%rax),%eax
  803e94:	48 98                	cltq   
  803e96:	48 83 c0 20          	add    $0x20,%rax
  803e9a:	48 39 c2             	cmp    %rax,%rdx
  803e9d:	73 b1                	jae    803e50 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea3:	8b 40 04             	mov    0x4(%rax),%eax
  803ea6:	89 c2                	mov    %eax,%edx
  803ea8:	c1 fa 1f             	sar    $0x1f,%edx
  803eab:	c1 ea 1b             	shr    $0x1b,%edx
  803eae:	01 d0                	add    %edx,%eax
  803eb0:	83 e0 1f             	and    $0x1f,%eax
  803eb3:	29 d0                	sub    %edx,%eax
  803eb5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803eb9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803ebd:	48 01 ca             	add    %rcx,%rdx
  803ec0:	0f b6 0a             	movzbl (%rdx),%ecx
  803ec3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ec7:	48 98                	cltq   
  803ec9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed1:	8b 40 04             	mov    0x4(%rax),%eax
  803ed4:	8d 50 01             	lea    0x1(%rax),%edx
  803ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803edb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803ede:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ee3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803eeb:	72 96                	jb     803e83 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ef1:	c9                   	leaveq 
  803ef2:	c3                   	retq   

0000000000803ef3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803ef3:	55                   	push   %rbp
  803ef4:	48 89 e5             	mov    %rsp,%rbp
  803ef7:	48 83 ec 20          	sub    $0x20,%rsp
  803efb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f07:	48 89 c7             	mov    %rax,%rdi
  803f0a:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803f11:	00 00 00 
  803f14:	ff d0                	callq  *%rax
  803f16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f1e:	48 be 9c 4d 80 00 00 	movabs $0x804d9c,%rsi
  803f25:	00 00 00 
  803f28:	48 89 c7             	mov    %rax,%rdi
  803f2b:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  803f32:	00 00 00 
  803f35:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f3b:	8b 50 04             	mov    0x4(%rax),%edx
  803f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f42:	8b 00                	mov    (%rax),%eax
  803f44:	29 c2                	sub    %eax,%edx
  803f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f4a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f50:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f54:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f5b:	00 00 00 
	stat->st_dev = &devpipe;
  803f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f62:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803f69:	00 00 00 
  803f6c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f78:	c9                   	leaveq 
  803f79:	c3                   	retq   

0000000000803f7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f7a:	55                   	push   %rbp
  803f7b:	48 89 e5             	mov    %rsp,%rbp
  803f7e:	48 83 ec 10          	sub    $0x10,%rsp
  803f82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8a:	48 89 c6             	mov    %rax,%rsi
  803f8d:	bf 00 00 00 00       	mov    $0x0,%edi
  803f92:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803f99:	00 00 00 
  803f9c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fa2:	48 89 c7             	mov    %rax,%rdi
  803fa5:	48 b8 0f 25 80 00 00 	movabs $0x80250f,%rax
  803fac:	00 00 00 
  803faf:	ff d0                	callq  *%rax
  803fb1:	48 89 c6             	mov    %rax,%rsi
  803fb4:	bf 00 00 00 00       	mov    $0x0,%edi
  803fb9:	48 b8 8b 19 80 00 00 	movabs $0x80198b,%rax
  803fc0:	00 00 00 
  803fc3:	ff d0                	callq  *%rax
}
  803fc5:	c9                   	leaveq 
  803fc6:	c3                   	retq   
	...

0000000000803fc8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fc8:	55                   	push   %rbp
  803fc9:	48 89 e5             	mov    %rsp,%rbp
  803fcc:	48 83 ec 20          	sub    $0x20,%rsp
  803fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fd6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fd9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803fdd:	be 01 00 00 00       	mov    $0x1,%esi
  803fe2:	48 89 c7             	mov    %rax,%rdi
  803fe5:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <getchar>:

int
getchar(void)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ffb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fff:	ba 01 00 00 00       	mov    $0x1,%edx
  804004:	48 89 c6             	mov    %rax,%rsi
  804007:	bf 00 00 00 00       	mov    $0x0,%edi
  80400c:	48 b8 04 2a 80 00 00 	movabs $0x802a04,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80401b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401f:	79 05                	jns    804026 <getchar+0x33>
		return r;
  804021:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804024:	eb 14                	jmp    80403a <getchar+0x47>
	if (r < 1)
  804026:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402a:	7f 07                	jg     804033 <getchar+0x40>
		return -E_EOF;
  80402c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804031:	eb 07                	jmp    80403a <getchar+0x47>
	return c;
  804033:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804037:	0f b6 c0             	movzbl %al,%eax
}
  80403a:	c9                   	leaveq 
  80403b:	c3                   	retq   

000000000080403c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 83 ec 20          	sub    $0x20,%rsp
  804044:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804047:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80404b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80404e:	48 89 d6             	mov    %rdx,%rsi
  804051:	89 c7                	mov    %eax,%edi
  804053:	48 b8 d2 25 80 00 00 	movabs $0x8025d2,%rax
  80405a:	00 00 00 
  80405d:	ff d0                	callq  *%rax
  80405f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804066:	79 05                	jns    80406d <iscons+0x31>
		return r;
  804068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406b:	eb 1a                	jmp    804087 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80406d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804071:	8b 10                	mov    (%rax),%edx
  804073:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80407a:	00 00 00 
  80407d:	8b 00                	mov    (%rax),%eax
  80407f:	39 c2                	cmp    %eax,%edx
  804081:	0f 94 c0             	sete   %al
  804084:	0f b6 c0             	movzbl %al,%eax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <opencons>:

int
opencons(void)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804091:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804095:	48 89 c7             	mov    %rax,%rdi
  804098:	48 b8 3a 25 80 00 00 	movabs $0x80253a,%rax
  80409f:	00 00 00 
  8040a2:	ff d0                	callq  *%rax
  8040a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ab:	79 05                	jns    8040b2 <opencons+0x29>
		return r;
  8040ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b0:	eb 5b                	jmp    80410d <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b6:	ba 07 04 00 00       	mov    $0x407,%edx
  8040bb:	48 89 c6             	mov    %rax,%rsi
  8040be:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c3:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d6:	79 05                	jns    8040dd <opencons+0x54>
		return r;
  8040d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040db:	eb 30                	jmp    80410d <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040e1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040e8:	00 00 00 
  8040eb:	8b 12                	mov    (%rdx),%edx
  8040ed:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8040ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8040fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fe:	48 89 c7             	mov    %rax,%rdi
  804101:	48 b8 ec 24 80 00 00 	movabs $0x8024ec,%rax
  804108:	00 00 00 
  80410b:	ff d0                	callq  *%rax
}
  80410d:	c9                   	leaveq 
  80410e:	c3                   	retq   

000000000080410f <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80410f:	55                   	push   %rbp
  804110:	48 89 e5             	mov    %rsp,%rbp
  804113:	48 83 ec 30          	sub    $0x30,%rsp
  804117:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80411b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80411f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804123:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804128:	75 13                	jne    80413d <devcons_read+0x2e>
		return 0;
  80412a:	b8 00 00 00 00       	mov    $0x0,%eax
  80412f:	eb 49                	jmp    80417a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804131:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  804138:	00 00 00 
  80413b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80413d:	48 b8 e2 17 80 00 00 	movabs $0x8017e2,%rax
  804144:	00 00 00 
  804147:	ff d0                	callq  *%rax
  804149:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80414c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804150:	74 df                	je     804131 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804156:	79 05                	jns    80415d <devcons_read+0x4e>
		return c;
  804158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415b:	eb 1d                	jmp    80417a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80415d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804161:	75 07                	jne    80416a <devcons_read+0x5b>
		return 0;
  804163:	b8 00 00 00 00       	mov    $0x0,%eax
  804168:	eb 10                	jmp    80417a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80416a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416d:	89 c2                	mov    %eax,%edx
  80416f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804173:	88 10                	mov    %dl,(%rax)
	return 1;
  804175:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80417a:	c9                   	leaveq 
  80417b:	c3                   	retq   

000000000080417c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80417c:	55                   	push   %rbp
  80417d:	48 89 e5             	mov    %rsp,%rbp
  804180:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804187:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80418e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804195:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80419c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041a3:	eb 77                	jmp    80421c <devcons_write+0xa0>
		m = n - tot;
  8041a5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041ac:	89 c2                	mov    %eax,%edx
  8041ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b1:	89 d1                	mov    %edx,%ecx
  8041b3:	29 c1                	sub    %eax,%ecx
  8041b5:	89 c8                	mov    %ecx,%eax
  8041b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041bd:	83 f8 7f             	cmp    $0x7f,%eax
  8041c0:	76 07                	jbe    8041c9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8041c2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041cc:	48 63 d0             	movslq %eax,%rdx
  8041cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d2:	48 98                	cltq   
  8041d4:	48 89 c1             	mov    %rax,%rcx
  8041d7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8041de:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041e5:	48 89 ce             	mov    %rcx,%rsi
  8041e8:	48 89 c7             	mov    %rax,%rdi
  8041eb:	48 b8 ca 12 80 00 00 	movabs $0x8012ca,%rax
  8041f2:	00 00 00 
  8041f5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8041f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041fa:	48 63 d0             	movslq %eax,%rdx
  8041fd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804204:	48 89 d6             	mov    %rdx,%rsi
  804207:	48 89 c7             	mov    %rax,%rdi
  80420a:	48 b8 98 17 80 00 00 	movabs $0x801798,%rax
  804211:	00 00 00 
  804214:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804216:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804219:	01 45 fc             	add    %eax,-0x4(%rbp)
  80421c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421f:	48 98                	cltq   
  804221:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804228:	0f 82 77 ff ff ff    	jb     8041a5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80422e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804231:	c9                   	leaveq 
  804232:	c3                   	retq   

0000000000804233 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804233:	55                   	push   %rbp
  804234:	48 89 e5             	mov    %rsp,%rbp
  804237:	48 83 ec 08          	sub    $0x8,%rsp
  80423b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80423f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804244:	c9                   	leaveq 
  804245:	c3                   	retq   

0000000000804246 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804246:	55                   	push   %rbp
  804247:	48 89 e5             	mov    %rsp,%rbp
  80424a:	48 83 ec 10          	sub    $0x10,%rsp
  80424e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425a:	48 be a8 4d 80 00 00 	movabs $0x804da8,%rsi
  804261:	00 00 00 
  804264:	48 89 c7             	mov    %rax,%rdi
  804267:	48 b8 a8 0f 80 00 00 	movabs $0x800fa8,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
	return 0;
  804273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804278:	c9                   	leaveq 
  804279:	c3                   	retq   
	...

000000000080427c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80427c:	55                   	push   %rbp
  80427d:	48 89 e5             	mov    %rsp,%rbp
  804280:	53                   	push   %rbx
  804281:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804288:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80428f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  804295:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80429c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8042a3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8042aa:	84 c0                	test   %al,%al
  8042ac:	74 23                	je     8042d1 <_panic+0x55>
  8042ae:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8042b5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8042b9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8042bd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8042c1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8042c5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8042c9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8042cd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8042d1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8042d8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8042df:	00 00 00 
  8042e2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8042e9:	00 00 00 
  8042ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8042f0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8042f7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8042fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  804305:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80430c:	00 00 00 
  80430f:	48 8b 18             	mov    (%rax),%rbx
  804312:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
  80431e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  804324:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80432b:	41 89 c8             	mov    %ecx,%r8d
  80432e:	48 89 d1             	mov    %rdx,%rcx
  804331:	48 89 da             	mov    %rbx,%rdx
  804334:	89 c6                	mov    %eax,%esi
  804336:	48 bf b0 4d 80 00 00 	movabs $0x804db0,%rdi
  80433d:	00 00 00 
  804340:	b8 00 00 00 00       	mov    $0x0,%eax
  804345:	49 b9 eb 03 80 00 00 	movabs $0x8003eb,%r9
  80434c:	00 00 00 
  80434f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  804352:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  804359:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804360:	48 89 d6             	mov    %rdx,%rsi
  804363:	48 89 c7             	mov    %rax,%rdi
  804366:	48 b8 3f 03 80 00 00 	movabs $0x80033f,%rax
  80436d:	00 00 00 
  804370:	ff d0                	callq  *%rax
	cprintf("\n");
  804372:	48 bf d3 4d 80 00 00 	movabs $0x804dd3,%rdi
  804379:	00 00 00 
  80437c:	b8 00 00 00 00       	mov    $0x0,%eax
  804381:	48 ba eb 03 80 00 00 	movabs $0x8003eb,%rdx
  804388:	00 00 00 
  80438b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80438d:	cc                   	int3   
  80438e:	eb fd                	jmp    80438d <_panic+0x111>

0000000000804390 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804390:	55                   	push   %rbp
  804391:	48 89 e5             	mov    %rsp,%rbp
  804394:	48 83 ec 20          	sub    $0x20,%rsp
  804398:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  80439c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a3:	00 00 00 
  8043a6:	48 8b 00             	mov    (%rax),%rax
  8043a9:	48 85 c0             	test   %rax,%rax
  8043ac:	0f 85 8e 00 00 00    	jne    804440 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8043b2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8043b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8043c0:	48 b8 64 18 80 00 00 	movabs $0x801864,%rax
  8043c7:	00 00 00 
  8043ca:	ff d0                	callq  *%rax
  8043cc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8043cf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8043d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043d6:	ba 07 00 00 00       	mov    $0x7,%edx
  8043db:	48 89 ce             	mov    %rcx,%rsi
  8043de:	89 c7                	mov    %eax,%edi
  8043e0:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8043e7:	00 00 00 
  8043ea:	ff d0                	callq  *%rax
  8043ec:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  8043ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8043f3:	74 30                	je     804425 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8043f5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043f8:	89 c1                	mov    %eax,%ecx
  8043fa:	48 ba d8 4d 80 00 00 	movabs $0x804dd8,%rdx
  804401:	00 00 00 
  804404:	be 24 00 00 00       	mov    $0x24,%esi
  804409:	48 bf 0f 4e 80 00 00 	movabs $0x804e0f,%rdi
  804410:	00 00 00 
  804413:	b8 00 00 00 00       	mov    $0x0,%eax
  804418:	49 b8 7c 42 80 00 00 	movabs $0x80427c,%r8
  80441f:	00 00 00 
  804422:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804425:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804428:	48 be 54 44 80 00 00 	movabs $0x804454,%rsi
  80442f:	00 00 00 
  804432:	89 c7                	mov    %eax,%edi
  804434:	48 b8 6a 1a 80 00 00 	movabs $0x801a6a,%rax
  80443b:	00 00 00 
  80443e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804440:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804447:	00 00 00 
  80444a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80444e:	48 89 10             	mov    %rdx,(%rax)
}
  804451:	c9                   	leaveq 
  804452:	c3                   	retq   
	...

0000000000804454 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804454:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804457:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80445e:	00 00 00 
	call *%rax
  804461:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  804463:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804467:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80446b:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80446e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804475:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804476:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  80447b:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  80447e:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  80447f:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  804482:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804489:	00 08 
		POPA_						// copy the register contents to the registers
  80448b:	4c 8b 3c 24          	mov    (%rsp),%r15
  80448f:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804494:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804499:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80449e:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8044a3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8044a8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8044ad:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8044b2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8044b7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8044bc:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8044c1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8044c6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8044cb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044d0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044d5:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  8044d9:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  8044dd:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  8044de:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  8044df:	c3                   	retq   

00000000008044e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8044e0:	55                   	push   %rbp
  8044e1:	48 89 e5             	mov    %rsp,%rbp
  8044e4:	48 83 ec 18          	sub    $0x18,%rsp
  8044e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f0:	48 89 c2             	mov    %rax,%rdx
  8044f3:	48 c1 ea 15          	shr    $0x15,%rdx
  8044f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044fe:	01 00 00 
  804501:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804505:	83 e0 01             	and    $0x1,%eax
  804508:	48 85 c0             	test   %rax,%rax
  80450b:	75 07                	jne    804514 <pageref+0x34>
		return 0;
  80450d:	b8 00 00 00 00       	mov    $0x0,%eax
  804512:	eb 53                	jmp    804567 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804518:	48 89 c2             	mov    %rax,%rdx
  80451b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80451f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804526:	01 00 00 
  804529:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80452d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804535:	83 e0 01             	and    $0x1,%eax
  804538:	48 85 c0             	test   %rax,%rax
  80453b:	75 07                	jne    804544 <pageref+0x64>
		return 0;
  80453d:	b8 00 00 00 00       	mov    $0x0,%eax
  804542:	eb 23                	jmp    804567 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804548:	48 89 c2             	mov    %rax,%rdx
  80454b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80454f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804556:	00 00 00 
  804559:	48 c1 e2 04          	shl    $0x4,%rdx
  80455d:	48 01 d0             	add    %rdx,%rax
  804560:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804564:	0f b7 c0             	movzwl %ax,%eax
}
  804567:	c9                   	leaveq 
  804568:	c3                   	retq   
