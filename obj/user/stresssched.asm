
obj/user/stresssched.debug:     file format elf64-x86-64


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
  80003c:	e8 77 01 00 00       	callq  8001b8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800053:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800069:	eb 14                	jmp    80007f <umain+0x3b>
		if (fork() == 0)
  80006b:	48 b8 87 20 80 00 00 	movabs $0x802087,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax
  800077:	85 c0                	test   %eax,%eax
  800079:	74 0c                	je     800087 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80007f:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800083:	7e e6                	jle    80006b <umain+0x27>
  800085:	eb 01                	jmp    800088 <umain+0x44>
		if (fork() == 0)
			break;
  800087:	90                   	nop
	if (i == 20) {
  800088:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008c:	75 15                	jne    8000a3 <umain+0x5f>
		sys_yield();
  80008e:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
		return;
  80009a:	e9 17 01 00 00       	jmpq   8001b6 <umain+0x172>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  80009f:	f3 90                	pause  
  8000a1:	eb 01                	jmp    8000a4 <umain+0x60>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a3:	90                   	nop
  8000a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ac:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b3:	00 00 00 
  8000b6:	48 63 d0             	movslq %eax,%rdx
  8000b9:	48 89 d0             	mov    %rdx,%rax
  8000bc:	48 c1 e0 03          	shl    $0x3,%rax
  8000c0:	48 01 d0             	add    %rdx,%rax
  8000c3:	48 c1 e0 05          	shl    $0x5,%rax
  8000c7:	48 01 c8             	add    %rcx,%rax
  8000ca:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000d0:	8b 40 04             	mov    0x4(%rax),%eax
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	75 c8                	jne    80009f <umain+0x5b>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000de:	eb 41                	jmp    800121 <umain+0xdd>
		sys_yield();
  8000e0:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f3:	eb 1f                	jmp    800114 <umain+0xd0>
			counter++;
  8000f5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8000fc:	00 00 00 
  8000ff:	8b 00                	mov    (%rax),%eax
  800101:	8d 50 01             	lea    0x1(%rax),%edx
  800104:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80010b:	00 00 00 
  80010e:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  800110:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800114:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  80011b:	7e d8                	jle    8000f5 <umain+0xb1>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800121:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800125:	7e b9                	jle    8000e0 <umain+0x9c>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800127:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80012e:	00 00 00 
  800131:	8b 00                	mov    (%rax),%eax
  800133:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800138:	74 39                	je     800173 <umain+0x12f>
		panic("ran on two CPUs at once (counter is %d)", counter);
  80013a:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800141:	00 00 00 
  800144:	8b 00                	mov    (%rax),%eax
  800146:	89 c1                	mov    %eax,%ecx
  800148:	48 ba 40 45 80 00 00 	movabs $0x804540,%rdx
  80014f:	00 00 00 
  800152:	be 21 00 00 00       	mov    $0x21,%esi
  800157:	48 bf 68 45 80 00 00 	movabs $0x804568,%rdi
  80015e:	00 00 00 
  800161:	b8 00 00 00 00       	mov    $0x0,%eax
  800166:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  80016d:	00 00 00 
  800170:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800173:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80017a:	00 00 00 
  80017d:	48 8b 00             	mov    (%rax),%rax
  800180:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800186:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80018d:	00 00 00 
  800190:	48 8b 00             	mov    (%rax),%rax
  800193:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800199:	89 c6                	mov    %eax,%esi
  80019b:	48 bf 7b 45 80 00 00 	movabs $0x80457b,%rdi
  8001a2:	00 00 00 
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  8001b1:	00 00 00 
  8001b4:	ff d1                	callq  *%rcx

}
  8001b6:	c9                   	leaveq 
  8001b7:	c3                   	retq   

00000000008001b8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 10          	sub    $0x10,%rsp
  8001c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001c7:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  8001ce:	00 00 00 
  8001d1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8001d8:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
  8001e4:	48 98                	cltq   
  8001e6:	48 89 c2             	mov    %rax,%rdx
  8001e9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001ef:	48 89 d0             	mov    %rdx,%rax
  8001f2:	48 c1 e0 03          	shl    $0x3,%rax
  8001f6:	48 01 d0             	add    %rdx,%rax
  8001f9:	48 c1 e0 05          	shl    $0x5,%rax
  8001fd:	48 89 c2             	mov    %rax,%rdx
  800200:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800207:	00 00 00 
  80020a:	48 01 c2             	add    %rax,%rdx
  80020d:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  800214:	00 00 00 
  800217:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80021a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021e:	7e 14                	jle    800234 <libmain+0x7c>
		binaryname = argv[0];
  800220:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800224:	48 8b 10             	mov    (%rax),%rdx
  800227:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80022e:	00 00 00 
  800231:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800234:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800238:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023b:	48 89 d6             	mov    %rdx,%rsi
  80023e:	89 c7                	mov    %eax,%edi
  800240:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800247:	00 00 00 
  80024a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80024c:	48 b8 5c 02 80 00 00 	movabs $0x80025c,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
}
  800258:	c9                   	leaveq 
  800259:	c3                   	retq   
	...

000000000080025c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025c:	55                   	push   %rbp
  80025d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800260:	48 b8 f5 26 80 00 00 	movabs $0x8026f5,%rax
  800267:	00 00 00 
  80026a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80026c:	bf 00 00 00 00       	mov    $0x0,%edi
  800271:	48 b8 f0 18 80 00 00 	movabs $0x8018f0,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
}
  80027d:	5d                   	pop    %rbp
  80027e:	c3                   	retq   
	...

0000000000800280 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800280:	55                   	push   %rbp
  800281:	48 89 e5             	mov    %rsp,%rbp
  800284:	53                   	push   %rbx
  800285:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80028c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800293:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800299:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002a0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002a7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002ae:	84 c0                	test   %al,%al
  8002b0:	74 23                	je     8002d5 <_panic+0x55>
  8002b2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002b9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002bd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002c1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002c5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002c9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002cd:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002d1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002d5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002dc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002e3:	00 00 00 
  8002e6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002ed:	00 00 00 
  8002f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002f4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002fb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800302:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800309:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800310:	00 00 00 
  800313:	48 8b 18             	mov    (%rax),%rbx
  800316:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
  800322:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800328:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80032f:	41 89 c8             	mov    %ecx,%r8d
  800332:	48 89 d1             	mov    %rdx,%rcx
  800335:	48 89 da             	mov    %rbx,%rdx
  800338:	89 c6                	mov    %eax,%esi
  80033a:	48 bf a8 45 80 00 00 	movabs $0x8045a8,%rdi
  800341:	00 00 00 
  800344:	b8 00 00 00 00       	mov    $0x0,%eax
  800349:	49 b9 bb 04 80 00 00 	movabs $0x8004bb,%r9
  800350:	00 00 00 
  800353:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800356:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80035d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800364:	48 89 d6             	mov    %rdx,%rsi
  800367:	48 89 c7             	mov    %rax,%rdi
  80036a:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  800371:	00 00 00 
  800374:	ff d0                	callq  *%rax
	cprintf("\n");
  800376:	48 bf cb 45 80 00 00 	movabs $0x8045cb,%rdi
  80037d:	00 00 00 
  800380:	b8 00 00 00 00       	mov    $0x0,%eax
  800385:	48 ba bb 04 80 00 00 	movabs $0x8004bb,%rdx
  80038c:	00 00 00 
  80038f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800391:	cc                   	int3   
  800392:	eb fd                	jmp    800391 <_panic+0x111>

0000000000800394 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800394:	55                   	push   %rbp
  800395:	48 89 e5             	mov    %rsp,%rbp
  800398:	48 83 ec 10          	sub    $0x10,%rsp
  80039c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8003a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a7:	8b 00                	mov    (%rax),%eax
  8003a9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003ac:	89 d6                	mov    %edx,%esi
  8003ae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003b2:	48 63 d0             	movslq %eax,%rdx
  8003b5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8003ba:	8d 50 01             	lea    0x1(%rax),%edx
  8003bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8003c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c7:	8b 00                	mov    (%rax),%eax
  8003c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ce:	75 2c                	jne    8003fc <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8003d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d4:	8b 00                	mov    (%rax),%eax
  8003d6:	48 98                	cltq   
  8003d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003dc:	48 83 c2 08          	add    $0x8,%rdx
  8003e0:	48 89 c6             	mov    %rax,%rsi
  8003e3:	48 89 d7             	mov    %rdx,%rdi
  8003e6:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
		b->idx = 0;
  8003f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	8b 40 04             	mov    0x4(%rax),%eax
  800403:	8d 50 01             	lea    0x1(%rax),%edx
  800406:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80040d:	c9                   	leaveq 
  80040e:	c3                   	retq   

000000000080040f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040f:	55                   	push   %rbp
  800410:	48 89 e5             	mov    %rsp,%rbp
  800413:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80041a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800421:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800428:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80042f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800436:	48 8b 0a             	mov    (%rdx),%rcx
  800439:	48 89 08             	mov    %rcx,(%rax)
  80043c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800440:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800444:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800448:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80044c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800453:	00 00 00 
	b.cnt = 0;
  800456:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80045d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800460:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800467:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80046e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800475:	48 89 c6             	mov    %rax,%rsi
  800478:	48 bf 94 03 80 00 00 	movabs $0x800394,%rdi
  80047f:	00 00 00 
  800482:	48 b8 6c 08 80 00 00 	movabs $0x80086c,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80048e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800494:	48 98                	cltq   
  800496:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80049d:	48 83 c2 08          	add    $0x8,%rdx
  8004a1:	48 89 c6             	mov    %rax,%rsi
  8004a4:	48 89 d7             	mov    %rdx,%rdi
  8004a7:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8004ae:	00 00 00 
  8004b1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004b3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004b9:	c9                   	leaveq 
  8004ba:	c3                   	retq   

00000000008004bb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004c6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004cd:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004d4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004db:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004e2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004e9:	84 c0                	test   %al,%al
  8004eb:	74 20                	je     80050d <cprintf+0x52>
  8004ed:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004f1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004f5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004f9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004fd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800501:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800505:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800509:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80050d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800514:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80051b:	00 00 00 
  80051e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800525:	00 00 00 
  800528:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80052c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800533:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80053a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800541:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800548:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80054f:	48 8b 0a             	mov    (%rdx),%rcx
  800552:	48 89 08             	mov    %rcx,(%rax)
  800555:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800559:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80055d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800561:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800565:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80056c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800573:	48 89 d6             	mov    %rdx,%rsi
  800576:	48 89 c7             	mov    %rax,%rdi
  800579:	48 b8 0f 04 80 00 00 	movabs $0x80040f,%rax
  800580:	00 00 00 
  800583:	ff d0                	callq  *%rax
  800585:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80058b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800591:	c9                   	leaveq 
  800592:	c3                   	retq   
	...

0000000000800594 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 83 ec 30          	sub    $0x30,%rsp
  80059c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005a8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005ab:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005af:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005b6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005ba:	77 52                	ja     80060e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bc:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005bf:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005c3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005c6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d3:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005dd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8005e0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8005e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e8:	41 89 f9             	mov    %edi,%r9d
  8005eb:	48 89 c7             	mov    %rax,%rdi
  8005ee:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  8005f5:	00 00 00 
  8005f8:	ff d0                	callq  *%rax
  8005fa:	eb 1c                	jmp    800618 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800600:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800603:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800607:	48 89 d6             	mov    %rdx,%rsi
  80060a:	89 c7                	mov    %eax,%edi
  80060c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80060e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800612:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800616:	7f e4                	jg     8005fc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800618:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80061b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061f:	ba 00 00 00 00       	mov    $0x0,%edx
  800624:	48 f7 f1             	div    %rcx
  800627:	48 89 d0             	mov    %rdx,%rax
  80062a:	48 ba a8 47 80 00 00 	movabs $0x8047a8,%rdx
  800631:	00 00 00 
  800634:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800638:	0f be c0             	movsbl %al,%eax
  80063b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800643:	48 89 d6             	mov    %rdx,%rsi
  800646:	89 c7                	mov    %eax,%edi
  800648:	ff d1                	callq  *%rcx
}
  80064a:	c9                   	leaveq 
  80064b:	c3                   	retq   

000000000080064c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064c:	55                   	push   %rbp
  80064d:	48 89 e5             	mov    %rsp,%rbp
  800650:	48 83 ec 20          	sub    $0x20,%rsp
  800654:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800658:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80065b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80065f:	7e 52                	jle    8006b3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800661:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	83 f8 30             	cmp    $0x30,%eax
  80066a:	73 24                	jae    800690 <getuint+0x44>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800674:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800678:	8b 00                	mov    (%rax),%eax
  80067a:	89 c0                	mov    %eax,%eax
  80067c:	48 01 d0             	add    %rdx,%rax
  80067f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800683:	8b 12                	mov    (%rdx),%edx
  800685:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068c:	89 0a                	mov    %ecx,(%rdx)
  80068e:	eb 17                	jmp    8006a7 <getuint+0x5b>
  800690:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800694:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800698:	48 89 d0             	mov    %rdx,%rax
  80069b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80069f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006a7:	48 8b 00             	mov    (%rax),%rax
  8006aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ae:	e9 a3 00 00 00       	jmpq   800756 <getuint+0x10a>
	else if (lflag)
  8006b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006b7:	74 4f                	je     800708 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bd:	8b 00                	mov    (%rax),%eax
  8006bf:	83 f8 30             	cmp    $0x30,%eax
  8006c2:	73 24                	jae    8006e8 <getuint+0x9c>
  8006c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d0:	8b 00                	mov    (%rax),%eax
  8006d2:	89 c0                	mov    %eax,%eax
  8006d4:	48 01 d0             	add    %rdx,%rax
  8006d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006db:	8b 12                	mov    (%rdx),%edx
  8006dd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e4:	89 0a                	mov    %ecx,(%rdx)
  8006e6:	eb 17                	jmp    8006ff <getuint+0xb3>
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f0:	48 89 d0             	mov    %rdx,%rax
  8006f3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006ff:	48 8b 00             	mov    (%rax),%rax
  800702:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800706:	eb 4e                	jmp    800756 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	83 f8 30             	cmp    $0x30,%eax
  800711:	73 24                	jae    800737 <getuint+0xeb>
  800713:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800717:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80071b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071f:	8b 00                	mov    (%rax),%eax
  800721:	89 c0                	mov    %eax,%eax
  800723:	48 01 d0             	add    %rdx,%rax
  800726:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072a:	8b 12                	mov    (%rdx),%edx
  80072c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80072f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800733:	89 0a                	mov    %ecx,(%rdx)
  800735:	eb 17                	jmp    80074e <getuint+0x102>
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80073f:	48 89 d0             	mov    %rdx,%rax
  800742:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80074e:	8b 00                	mov    (%rax),%eax
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800756:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80075a:	c9                   	leaveq 
  80075b:	c3                   	retq   

000000000080075c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075c:	55                   	push   %rbp
  80075d:	48 89 e5             	mov    %rsp,%rbp
  800760:	48 83 ec 20          	sub    $0x20,%rsp
  800764:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800768:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80076b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80076f:	7e 52                	jle    8007c3 <getint+0x67>
		x=va_arg(*ap, long long);
  800771:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800775:	8b 00                	mov    (%rax),%eax
  800777:	83 f8 30             	cmp    $0x30,%eax
  80077a:	73 24                	jae    8007a0 <getint+0x44>
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	89 c0                	mov    %eax,%eax
  80078c:	48 01 d0             	add    %rdx,%rax
  80078f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800793:	8b 12                	mov    (%rdx),%edx
  800795:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	89 0a                	mov    %ecx,(%rdx)
  80079e:	eb 17                	jmp    8007b7 <getint+0x5b>
  8007a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007a8:	48 89 d0             	mov    %rdx,%rax
  8007ab:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007b7:	48 8b 00             	mov    (%rax),%rax
  8007ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007be:	e9 a3 00 00 00       	jmpq   800866 <getint+0x10a>
	else if (lflag)
  8007c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007c7:	74 4f                	je     800818 <getint+0xbc>
		x=va_arg(*ap, long);
  8007c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cd:	8b 00                	mov    (%rax),%eax
  8007cf:	83 f8 30             	cmp    $0x30,%eax
  8007d2:	73 24                	jae    8007f8 <getint+0x9c>
  8007d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e0:	8b 00                	mov    (%rax),%eax
  8007e2:	89 c0                	mov    %eax,%eax
  8007e4:	48 01 d0             	add    %rdx,%rax
  8007e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007eb:	8b 12                	mov    (%rdx),%edx
  8007ed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f4:	89 0a                	mov    %ecx,(%rdx)
  8007f6:	eb 17                	jmp    80080f <getint+0xb3>
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800800:	48 89 d0             	mov    %rdx,%rax
  800803:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800807:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80080f:	48 8b 00             	mov    (%rax),%rax
  800812:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800816:	eb 4e                	jmp    800866 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	8b 00                	mov    (%rax),%eax
  80081e:	83 f8 30             	cmp    $0x30,%eax
  800821:	73 24                	jae    800847 <getint+0xeb>
  800823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800827:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082f:	8b 00                	mov    (%rax),%eax
  800831:	89 c0                	mov    %eax,%eax
  800833:	48 01 d0             	add    %rdx,%rax
  800836:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083a:	8b 12                	mov    (%rdx),%edx
  80083c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80083f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800843:	89 0a                	mov    %ecx,(%rdx)
  800845:	eb 17                	jmp    80085e <getint+0x102>
  800847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80084f:	48 89 d0             	mov    %rdx,%rax
  800852:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80085e:	8b 00                	mov    (%rax),%eax
  800860:	48 98                	cltq   
  800862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80086a:	c9                   	leaveq 
  80086b:	c3                   	retq   

000000000080086c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80086c:	55                   	push   %rbp
  80086d:	48 89 e5             	mov    %rsp,%rbp
  800870:	41 54                	push   %r12
  800872:	53                   	push   %rbx
  800873:	48 83 ec 60          	sub    $0x60,%rsp
  800877:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80087b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80087f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800883:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800887:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80088b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80088f:	48 8b 0a             	mov    (%rdx),%rcx
  800892:	48 89 08             	mov    %rcx,(%rax)
  800895:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800899:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80089d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a5:	eb 17                	jmp    8008be <vprintfmt+0x52>
			if (ch == '\0')
  8008a7:	85 db                	test   %ebx,%ebx
  8008a9:	0f 84 d7 04 00 00    	je     800d86 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8008af:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008b3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8008b7:	48 89 c6             	mov    %rax,%rsi
  8008ba:	89 df                	mov    %ebx,%edi
  8008bc:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008be:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	0f b6 d8             	movzbl %al,%ebx
  8008c8:	83 fb 25             	cmp    $0x25,%ebx
  8008cb:	0f 95 c0             	setne  %al
  8008ce:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008d3:	84 c0                	test   %al,%al
  8008d5:	75 d0                	jne    8008a7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008d7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008db:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008e2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008e9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  8008f7:	eb 04                	jmp    8008fd <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  8008f9:	90                   	nop
  8008fa:	eb 01                	jmp    8008fd <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  8008fc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008fd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800901:	0f b6 00             	movzbl (%rax),%eax
  800904:	0f b6 d8             	movzbl %al,%ebx
  800907:	89 d8                	mov    %ebx,%eax
  800909:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80090e:	83 e8 23             	sub    $0x23,%eax
  800911:	83 f8 55             	cmp    $0x55,%eax
  800914:	0f 87 38 04 00 00    	ja     800d52 <vprintfmt+0x4e6>
  80091a:	89 c0                	mov    %eax,%eax
  80091c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800923:	00 
  800924:	48 b8 d0 47 80 00 00 	movabs $0x8047d0,%rax
  80092b:	00 00 00 
  80092e:	48 01 d0             	add    %rdx,%rax
  800931:	48 8b 00             	mov    (%rax),%rax
  800934:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800936:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80093a:	eb c1                	jmp    8008fd <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80093c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800940:	eb bb                	jmp    8008fd <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800942:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800949:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80094c:	89 d0                	mov    %edx,%eax
  80094e:	c1 e0 02             	shl    $0x2,%eax
  800951:	01 d0                	add    %edx,%eax
  800953:	01 c0                	add    %eax,%eax
  800955:	01 d8                	add    %ebx,%eax
  800957:	83 e8 30             	sub    $0x30,%eax
  80095a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80095d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800961:	0f b6 00             	movzbl (%rax),%eax
  800964:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800967:	83 fb 2f             	cmp    $0x2f,%ebx
  80096a:	7e 63                	jle    8009cf <vprintfmt+0x163>
  80096c:	83 fb 39             	cmp    $0x39,%ebx
  80096f:	7f 5e                	jg     8009cf <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800971:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800976:	eb d1                	jmp    800949 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800978:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097b:	83 f8 30             	cmp    $0x30,%eax
  80097e:	73 17                	jae    800997 <vprintfmt+0x12b>
  800980:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800984:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800987:	89 c0                	mov    %eax,%eax
  800989:	48 01 d0             	add    %rdx,%rax
  80098c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80098f:	83 c2 08             	add    $0x8,%edx
  800992:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800995:	eb 0f                	jmp    8009a6 <vprintfmt+0x13a>
  800997:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099b:	48 89 d0             	mov    %rdx,%rax
  80099e:	48 83 c2 08          	add    $0x8,%rdx
  8009a2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a6:	8b 00                	mov    (%rax),%eax
  8009a8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009ab:	eb 23                	jmp    8009d0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b1:	0f 89 42 ff ff ff    	jns    8008f9 <vprintfmt+0x8d>
				width = 0;
  8009b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009be:	e9 36 ff ff ff       	jmpq   8008f9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8009c3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ca:	e9 2e ff ff ff       	jmpq   8008fd <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009cf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d4:	0f 89 22 ff ff ff    	jns    8008fc <vprintfmt+0x90>
				width = precision, precision = -1;
  8009da:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009dd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009e0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009e7:	e9 10 ff ff ff       	jmpq   8008fc <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009ec:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009f0:	e9 08 ff ff ff       	jmpq   8008fd <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009f5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f8:	83 f8 30             	cmp    $0x30,%eax
  8009fb:	73 17                	jae    800a14 <vprintfmt+0x1a8>
  8009fd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a01:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a04:	89 c0                	mov    %eax,%eax
  800a06:	48 01 d0             	add    %rdx,%rax
  800a09:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a0c:	83 c2 08             	add    $0x8,%edx
  800a0f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a12:	eb 0f                	jmp    800a23 <vprintfmt+0x1b7>
  800a14:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a18:	48 89 d0             	mov    %rdx,%rax
  800a1b:	48 83 c2 08          	add    $0x8,%rdx
  800a1f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a23:	8b 00                	mov    (%rax),%eax
  800a25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a29:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a2d:	48 89 d6             	mov    %rdx,%rsi
  800a30:	89 c7                	mov    %eax,%edi
  800a32:	ff d1                	callq  *%rcx
			break;
  800a34:	e9 47 03 00 00       	jmpq   800d80 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a39:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a3c:	83 f8 30             	cmp    $0x30,%eax
  800a3f:	73 17                	jae    800a58 <vprintfmt+0x1ec>
  800a41:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a45:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a48:	89 c0                	mov    %eax,%eax
  800a4a:	48 01 d0             	add    %rdx,%rax
  800a4d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a50:	83 c2 08             	add    $0x8,%edx
  800a53:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a56:	eb 0f                	jmp    800a67 <vprintfmt+0x1fb>
  800a58:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a5c:	48 89 d0             	mov    %rdx,%rax
  800a5f:	48 83 c2 08          	add    $0x8,%rdx
  800a63:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a67:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a69:	85 db                	test   %ebx,%ebx
  800a6b:	79 02                	jns    800a6f <vprintfmt+0x203>
				err = -err;
  800a6d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a6f:	83 fb 10             	cmp    $0x10,%ebx
  800a72:	7f 16                	jg     800a8a <vprintfmt+0x21e>
  800a74:	48 b8 20 47 80 00 00 	movabs $0x804720,%rax
  800a7b:	00 00 00 
  800a7e:	48 63 d3             	movslq %ebx,%rdx
  800a81:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a85:	4d 85 e4             	test   %r12,%r12
  800a88:	75 2e                	jne    800ab8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800a8a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a8e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a92:	89 d9                	mov    %ebx,%ecx
  800a94:	48 ba b9 47 80 00 00 	movabs $0x8047b9,%rdx
  800a9b:	00 00 00 
  800a9e:	48 89 c7             	mov    %rax,%rdi
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa6:	49 b8 90 0d 80 00 00 	movabs $0x800d90,%r8
  800aad:	00 00 00 
  800ab0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab3:	e9 c8 02 00 00       	jmpq   800d80 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800abc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac0:	4c 89 e1             	mov    %r12,%rcx
  800ac3:	48 ba c2 47 80 00 00 	movabs $0x8047c2,%rdx
  800aca:	00 00 00 
  800acd:	48 89 c7             	mov    %rax,%rdi
  800ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad5:	49 b8 90 0d 80 00 00 	movabs $0x800d90,%r8
  800adc:	00 00 00 
  800adf:	41 ff d0             	callq  *%r8
			break;
  800ae2:	e9 99 02 00 00       	jmpq   800d80 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ae7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aea:	83 f8 30             	cmp    $0x30,%eax
  800aed:	73 17                	jae    800b06 <vprintfmt+0x29a>
  800aef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af6:	89 c0                	mov    %eax,%eax
  800af8:	48 01 d0             	add    %rdx,%rax
  800afb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afe:	83 c2 08             	add    $0x8,%edx
  800b01:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b04:	eb 0f                	jmp    800b15 <vprintfmt+0x2a9>
  800b06:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b0a:	48 89 d0             	mov    %rdx,%rax
  800b0d:	48 83 c2 08          	add    $0x8,%rdx
  800b11:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b15:	4c 8b 20             	mov    (%rax),%r12
  800b18:	4d 85 e4             	test   %r12,%r12
  800b1b:	75 0a                	jne    800b27 <vprintfmt+0x2bb>
				p = "(null)";
  800b1d:	49 bc c5 47 80 00 00 	movabs $0x8047c5,%r12
  800b24:	00 00 00 
			if (width > 0 && padc != '-')
  800b27:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2b:	7e 7a                	jle    800ba7 <vprintfmt+0x33b>
  800b2d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b31:	74 74                	je     800ba7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b33:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b36:	48 98                	cltq   
  800b38:	48 89 c6             	mov    %rax,%rsi
  800b3b:	4c 89 e7             	mov    %r12,%rdi
  800b3e:	48 b8 3a 10 80 00 00 	movabs $0x80103a,%rax
  800b45:	00 00 00 
  800b48:	ff d0                	callq  *%rax
  800b4a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b4d:	eb 17                	jmp    800b66 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b4f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b57:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b5b:	48 89 d6             	mov    %rdx,%rsi
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b62:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b66:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6a:	7f e3                	jg     800b4f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6c:	eb 39                	jmp    800ba7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b72:	74 1e                	je     800b92 <vprintfmt+0x326>
  800b74:	83 fb 1f             	cmp    $0x1f,%ebx
  800b77:	7e 05                	jle    800b7e <vprintfmt+0x312>
  800b79:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7c:	7e 14                	jle    800b92 <vprintfmt+0x326>
					putch('?', putdat);
  800b7e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b82:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b86:	48 89 c6             	mov    %rax,%rsi
  800b89:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b8e:	ff d2                	callq  *%rdx
  800b90:	eb 0f                	jmp    800ba1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800b92:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800b96:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800b9a:	48 89 c6             	mov    %rax,%rsi
  800b9d:	89 df                	mov    %ebx,%edi
  800b9f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ba5:	eb 01                	jmp    800ba8 <vprintfmt+0x33c>
  800ba7:	90                   	nop
  800ba8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800bad:	0f be d8             	movsbl %al,%ebx
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	0f 95 c0             	setne  %al
  800bb5:	49 83 c4 01          	add    $0x1,%r12
  800bb9:	84 c0                	test   %al,%al
  800bbb:	74 28                	je     800be5 <vprintfmt+0x379>
  800bbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bc1:	78 ab                	js     800b6e <vprintfmt+0x302>
  800bc3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bc7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bcb:	79 a1                	jns    800b6e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcd:	eb 16                	jmp    800be5 <vprintfmt+0x379>
				putch(' ', putdat);
  800bcf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bd3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bd7:	48 89 c6             	mov    %rax,%rsi
  800bda:	bf 20 00 00 00       	mov    $0x20,%edi
  800bdf:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800be5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be9:	7f e4                	jg     800bcf <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800beb:	e9 90 01 00 00       	jmpq   800d80 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf4:	be 03 00 00 00       	mov    $0x3,%esi
  800bf9:	48 89 c7             	mov    %rax,%rdi
  800bfc:	48 b8 5c 07 80 00 00 	movabs $0x80075c,%rax
  800c03:	00 00 00 
  800c06:	ff d0                	callq  *%rax
  800c08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c10:	48 85 c0             	test   %rax,%rax
  800c13:	79 1d                	jns    800c32 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c15:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c19:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c1d:	48 89 c6             	mov    %rax,%rsi
  800c20:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c25:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 f7 d8             	neg    %rax
  800c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c32:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c39:	e9 d5 00 00 00       	jmpq   800d13 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c3e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c42:	be 03 00 00 00       	mov    $0x3,%esi
  800c47:	48 89 c7             	mov    %rax,%rdi
  800c4a:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
  800c56:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c5a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c61:	e9 ad 00 00 00       	jmpq   800d13 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c66:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c6a:	be 03 00 00 00       	mov    $0x3,%esi
  800c6f:	48 89 c7             	mov    %rax,%rdi
  800c72:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800c79:	00 00 00 
  800c7c:	ff d0                	callq  *%rax
  800c7e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800c82:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c89:	e9 85 00 00 00       	jmpq   800d13 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c8e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c92:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c96:	48 89 c6             	mov    %rax,%rsi
  800c99:	bf 30 00 00 00       	mov    $0x30,%edi
  800c9e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800ca0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ca4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ca8:	48 89 c6             	mov    %rax,%rsi
  800cab:	bf 78 00 00 00       	mov    $0x78,%edi
  800cb0:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cb5:	83 f8 30             	cmp    $0x30,%eax
  800cb8:	73 17                	jae    800cd1 <vprintfmt+0x465>
  800cba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc1:	89 c0                	mov    %eax,%eax
  800cc3:	48 01 d0             	add    %rdx,%rax
  800cc6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc9:	83 c2 08             	add    $0x8,%edx
  800ccc:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccf:	eb 0f                	jmp    800ce0 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800cd1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cd5:	48 89 d0             	mov    %rdx,%rax
  800cd8:	48 83 c2 08          	add    $0x8,%rdx
  800cdc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ce0:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ce7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cee:	eb 23                	jmp    800d13 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cf0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cf4:	be 03 00 00 00       	mov    $0x3,%esi
  800cf9:	48 89 c7             	mov    %rax,%rdi
  800cfc:	48 b8 4c 06 80 00 00 	movabs $0x80064c,%rax
  800d03:	00 00 00 
  800d06:	ff d0                	callq  *%rax
  800d08:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d0c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d13:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d18:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d1b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d22:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d2a:	45 89 c1             	mov    %r8d,%r9d
  800d2d:	41 89 f8             	mov    %edi,%r8d
  800d30:	48 89 c7             	mov    %rax,%rdi
  800d33:	48 b8 94 05 80 00 00 	movabs $0x800594,%rax
  800d3a:	00 00 00 
  800d3d:	ff d0                	callq  *%rax
			break;
  800d3f:	eb 3f                	jmp    800d80 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d41:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d45:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d49:	48 89 c6             	mov    %rax,%rsi
  800d4c:	89 df                	mov    %ebx,%edi
  800d4e:	ff d2                	callq  *%rdx
			break;
  800d50:	eb 2e                	jmp    800d80 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d52:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d56:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d5a:	48 89 c6             	mov    %rax,%rsi
  800d5d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d62:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d64:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d69:	eb 05                	jmp    800d70 <vprintfmt+0x504>
  800d6b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d70:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d74:	48 83 e8 01          	sub    $0x1,%rax
  800d78:	0f b6 00             	movzbl (%rax),%eax
  800d7b:	3c 25                	cmp    $0x25,%al
  800d7d:	75 ec                	jne    800d6b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d7f:	90                   	nop
		}
	}
  800d80:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d81:	e9 38 fb ff ff       	jmpq   8008be <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800d86:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800d87:	48 83 c4 60          	add    $0x60,%rsp
  800d8b:	5b                   	pop    %rbx
  800d8c:	41 5c                	pop    %r12
  800d8e:	5d                   	pop    %rbp
  800d8f:	c3                   	retq   

0000000000800d90 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d90:	55                   	push   %rbp
  800d91:	48 89 e5             	mov    %rsp,%rbp
  800d94:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d9b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800da2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800da9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800db0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 20                	je     800de2 <printfmt+0x52>
  800dc2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dca:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dce:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dda:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dde:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800de9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800df0:	00 00 00 
  800df3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dfa:	00 00 00 
  800dfd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e01:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e08:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e16:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e1d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e24:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e2b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e32:	48 89 c7             	mov    %rax,%rdi
  800e35:	48 b8 6c 08 80 00 00 	movabs $0x80086c,%rax
  800e3c:	00 00 00 
  800e3f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e41:	c9                   	leaveq 
  800e42:	c3                   	retq   

0000000000800e43 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e43:	55                   	push   %rbp
  800e44:	48 89 e5             	mov    %rsp,%rbp
  800e47:	48 83 ec 10          	sub    $0x10,%rsp
  800e4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e56:	8b 40 10             	mov    0x10(%rax),%eax
  800e59:	8d 50 01             	lea    0x1(%rax),%edx
  800e5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e60:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e67:	48 8b 10             	mov    (%rax),%rdx
  800e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e6e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e72:	48 39 c2             	cmp    %rax,%rdx
  800e75:	73 17                	jae    800e8e <sprintputch+0x4b>
		*b->buf++ = ch;
  800e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e7b:	48 8b 00             	mov    (%rax),%rax
  800e7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e81:	88 10                	mov    %dl,(%rax)
  800e83:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	48 89 10             	mov    %rdx,(%rax)
}
  800e8e:	c9                   	leaveq 
  800e8f:	c3                   	retq   

0000000000800e90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e90:	55                   	push   %rbp
  800e91:	48 89 e5             	mov    %rsp,%rbp
  800e94:	48 83 ec 50          	sub    $0x50,%rsp
  800e98:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e9c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e9f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ea3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ea7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800eab:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800eaf:	48 8b 0a             	mov    (%rdx),%rcx
  800eb2:	48 89 08             	mov    %rcx,(%rax)
  800eb5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eb9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ebd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ec1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ec9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ecd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ed0:	48 98                	cltq   
  800ed2:	48 83 e8 01          	sub    $0x1,%rax
  800ed6:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800eda:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ede:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ee5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800eea:	74 06                	je     800ef2 <vsnprintf+0x62>
  800eec:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ef0:	7f 07                	jg     800ef9 <vsnprintf+0x69>
		return -E_INVAL;
  800ef2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef7:	eb 2f                	jmp    800f28 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ef9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800efd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f01:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f05:	48 89 c6             	mov    %rax,%rsi
  800f08:	48 bf 43 0e 80 00 00 	movabs $0x800e43,%rdi
  800f0f:	00 00 00 
  800f12:	48 b8 6c 08 80 00 00 	movabs $0x80086c,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f22:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f25:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f28:	c9                   	leaveq 
  800f29:	c3                   	retq   

0000000000800f2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f2a:	55                   	push   %rbp
  800f2b:	48 89 e5             	mov    %rsp,%rbp
  800f2e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f35:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f3c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f42:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f49:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f50:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f57:	84 c0                	test   %al,%al
  800f59:	74 20                	je     800f7b <snprintf+0x51>
  800f5b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f63:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f67:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f6b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f73:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f77:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f7b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f82:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f89:	00 00 00 
  800f8c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f93:	00 00 00 
  800f96:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f9a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fa1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800faf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fb6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fbd:	48 8b 0a             	mov    (%rdx),%rcx
  800fc0:	48 89 08             	mov    %rcx,(%rax)
  800fc3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fc7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fcb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fcf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fd3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fda:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fe1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fe7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fee:	48 89 c7             	mov    %rax,%rdi
  800ff1:	48 b8 90 0e 80 00 00 	movabs $0x800e90,%rax
  800ff8:	00 00 00 
  800ffb:	ff d0                	callq  *%rax
  800ffd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801003:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801009:	c9                   	leaveq 
  80100a:	c3                   	retq   
	...

000000000080100c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80100c:	55                   	push   %rbp
  80100d:	48 89 e5             	mov    %rsp,%rbp
  801010:	48 83 ec 18          	sub    $0x18,%rsp
  801014:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80101f:	eb 09                	jmp    80102a <strlen+0x1e>
		n++;
  801021:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801025:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80102a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102e:	0f b6 00             	movzbl (%rax),%eax
  801031:	84 c0                	test   %al,%al
  801033:	75 ec                	jne    801021 <strlen+0x15>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801038:	c9                   	leaveq 
  801039:	c3                   	retq   

000000000080103a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80103a:	55                   	push   %rbp
  80103b:	48 89 e5             	mov    %rsp,%rbp
  80103e:	48 83 ec 20          	sub    $0x20,%rsp
  801042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801051:	eb 0e                	jmp    801061 <strnlen+0x27>
		n++;
  801053:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801057:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80105c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801061:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801066:	74 0b                	je     801073 <strnlen+0x39>
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	0f b6 00             	movzbl (%rax),%eax
  80106f:	84 c0                	test   %al,%al
  801071:	75 e0                	jne    801053 <strnlen+0x19>
		n++;
	return n;
  801073:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801076:	c9                   	leaveq 
  801077:	c3                   	retq   

0000000000801078 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801078:	55                   	push   %rbp
  801079:	48 89 e5             	mov    %rsp,%rbp
  80107c:	48 83 ec 20          	sub    $0x20,%rsp
  801080:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801084:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801090:	90                   	nop
  801091:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801095:	0f b6 10             	movzbl (%rax),%edx
  801098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109c:	88 10                	mov    %dl,(%rax)
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	84 c0                	test   %al,%al
  8010a7:	0f 95 c0             	setne  %al
  8010aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010af:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8010b4:	84 c0                	test   %al,%al
  8010b6:	75 d9                	jne    801091 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010bc:	c9                   	leaveq 
  8010bd:	c3                   	retq   

00000000008010be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010be:	55                   	push   %rbp
  8010bf:	48 89 e5             	mov    %rsp,%rbp
  8010c2:	48 83 ec 20          	sub    $0x20,%rsp
  8010c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d2:	48 89 c7             	mov    %rax,%rdi
  8010d5:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  8010dc:	00 00 00 
  8010df:	ff d0                	callq  *%rax
  8010e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e7:	48 98                	cltq   
  8010e9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8010ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010f1:	48 89 d6             	mov    %rdx,%rsi
  8010f4:	48 89 c7             	mov    %rax,%rdi
  8010f7:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  8010fe:	00 00 00 
  801101:	ff d0                	callq  *%rax
	return dst;
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801107:	c9                   	leaveq 
  801108:	c3                   	retq   

0000000000801109 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801109:	55                   	push   %rbp
  80110a:	48 89 e5             	mov    %rsp,%rbp
  80110d:	48 83 ec 28          	sub    $0x28,%rsp
  801111:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801115:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801119:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801125:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80112c:	00 
  80112d:	eb 27                	jmp    801156 <strncpy+0x4d>
		*dst++ = *src;
  80112f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801133:	0f b6 10             	movzbl (%rax),%edx
  801136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113a:	88 10                	mov    %dl,(%rax)
  80113c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801141:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801145:	0f b6 00             	movzbl (%rax),%eax
  801148:	84 c0                	test   %al,%al
  80114a:	74 05                	je     801151 <strncpy+0x48>
			src++;
  80114c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801151:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80115e:	72 cf                	jb     80112f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801164:	c9                   	leaveq 
  801165:	c3                   	retq   

0000000000801166 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801166:	55                   	push   %rbp
  801167:	48 89 e5             	mov    %rsp,%rbp
  80116a:	48 83 ec 28          	sub    $0x28,%rsp
  80116e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801172:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801176:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801182:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801187:	74 37                	je     8011c0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801189:	eb 17                	jmp    8011a2 <strlcpy+0x3c>
			*dst++ = *src++;
  80118b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80118f:	0f b6 10             	movzbl (%rax),%edx
  801192:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801196:	88 10                	mov    %dl,(%rax)
  801198:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80119d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011a2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011a7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ac:	74 0b                	je     8011b9 <strlcpy+0x53>
  8011ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	84 c0                	test   %al,%al
  8011b7:	75 d2                	jne    80118b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c8:	48 89 d1             	mov    %rdx,%rcx
  8011cb:	48 29 c1             	sub    %rax,%rcx
  8011ce:	48 89 c8             	mov    %rcx,%rax
}
  8011d1:	c9                   	leaveq 
  8011d2:	c3                   	retq   

00000000008011d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011d3:	55                   	push   %rbp
  8011d4:	48 89 e5             	mov    %rsp,%rbp
  8011d7:	48 83 ec 10          	sub    $0x10,%rsp
  8011db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011e3:	eb 0a                	jmp    8011ef <strcmp+0x1c>
		p++, q++;
  8011e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ea:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f3:	0f b6 00             	movzbl (%rax),%eax
  8011f6:	84 c0                	test   %al,%al
  8011f8:	74 12                	je     80120c <strcmp+0x39>
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011fe:	0f b6 10             	movzbl (%rax),%edx
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	0f b6 00             	movzbl (%rax),%eax
  801208:	38 c2                	cmp    %al,%dl
  80120a:	74 d9                	je     8011e5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80120c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801210:	0f b6 00             	movzbl (%rax),%eax
  801213:	0f b6 d0             	movzbl %al,%edx
  801216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	0f b6 c0             	movzbl %al,%eax
  801220:	89 d1                	mov    %edx,%ecx
  801222:	29 c1                	sub    %eax,%ecx
  801224:	89 c8                	mov    %ecx,%eax
}
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 18          	sub    $0x18,%rsp
  801230:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801234:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801238:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80123c:	eb 0f                	jmp    80124d <strncmp+0x25>
		n--, p++, q++;
  80123e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801243:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801248:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80124d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801252:	74 1d                	je     801271 <strncmp+0x49>
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	0f b6 00             	movzbl (%rax),%eax
  80125b:	84 c0                	test   %al,%al
  80125d:	74 12                	je     801271 <strncmp+0x49>
  80125f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801263:	0f b6 10             	movzbl (%rax),%edx
  801266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126a:	0f b6 00             	movzbl (%rax),%eax
  80126d:	38 c2                	cmp    %al,%dl
  80126f:	74 cd                	je     80123e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801271:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801276:	75 07                	jne    80127f <strncmp+0x57>
		return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
  80127d:	eb 1a                	jmp    801299 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	0f b6 d0             	movzbl %al,%edx
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	0f b6 00             	movzbl (%rax),%eax
  801290:	0f b6 c0             	movzbl %al,%eax
  801293:	89 d1                	mov    %edx,%ecx
  801295:	29 c1                	sub    %eax,%ecx
  801297:	89 c8                	mov    %ecx,%eax
}
  801299:	c9                   	leaveq 
  80129a:	c3                   	retq   

000000000080129b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	48 83 ec 10          	sub    $0x10,%rsp
  8012a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a7:	89 f0                	mov    %esi,%eax
  8012a9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012ac:	eb 17                	jmp    8012c5 <strchr+0x2a>
		if (*s == c)
  8012ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b2:	0f b6 00             	movzbl (%rax),%eax
  8012b5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012b8:	75 06                	jne    8012c0 <strchr+0x25>
			return (char *) s;
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	eb 15                	jmp    8012d5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	84 c0                	test   %al,%al
  8012ce:	75 de                	jne    8012ae <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012d5:	c9                   	leaveq 
  8012d6:	c3                   	retq   

00000000008012d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012d7:	55                   	push   %rbp
  8012d8:	48 89 e5             	mov    %rsp,%rbp
  8012db:	48 83 ec 10          	sub    $0x10,%rsp
  8012df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e3:	89 f0                	mov    %esi,%eax
  8012e5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e8:	eb 11                	jmp    8012fb <strfind+0x24>
		if (*s == c)
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	0f b6 00             	movzbl (%rax),%eax
  8012f1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f4:	74 12                	je     801308 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ff:	0f b6 00             	movzbl (%rax),%eax
  801302:	84 c0                	test   %al,%al
  801304:	75 e4                	jne    8012ea <strfind+0x13>
  801306:	eb 01                	jmp    801309 <strfind+0x32>
		if (*s == c)
			break;
  801308:	90                   	nop
	return (char *) s;
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 18          	sub    $0x18,%rsp
  801317:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80131e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801322:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801327:	75 06                	jne    80132f <memset+0x20>
		return v;
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132d:	eb 69                	jmp    801398 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80132f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801333:	83 e0 03             	and    $0x3,%eax
  801336:	48 85 c0             	test   %rax,%rax
  801339:	75 48                	jne    801383 <memset+0x74>
  80133b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133f:	83 e0 03             	and    $0x3,%eax
  801342:	48 85 c0             	test   %rax,%rax
  801345:	75 3c                	jne    801383 <memset+0x74>
		c &= 0xFF;
  801347:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80134e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	c1 e2 18             	shl    $0x18,%edx
  801356:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801359:	c1 e0 10             	shl    $0x10,%eax
  80135c:	09 c2                	or     %eax,%edx
  80135e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801361:	c1 e0 08             	shl    $0x8,%eax
  801364:	09 d0                	or     %edx,%eax
  801366:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136d:	48 89 c1             	mov    %rax,%rcx
  801370:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801374:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801378:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80137b:	48 89 d7             	mov    %rdx,%rdi
  80137e:	fc                   	cld    
  80137f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801381:	eb 11                	jmp    801394 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801383:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801387:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80138e:	48 89 d7             	mov    %rdx,%rdi
  801391:	fc                   	cld    
  801392:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801398:	c9                   	leaveq 
  801399:	c3                   	retq   

000000000080139a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80139a:	55                   	push   %rbp
  80139b:	48 89 e5             	mov    %rsp,%rbp
  80139e:	48 83 ec 28          	sub    $0x28,%rsp
  8013a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013c6:	0f 83 88 00 00 00    	jae    801454 <memmove+0xba>
  8013cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013d4:	48 01 d0             	add    %rdx,%rax
  8013d7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013db:	76 77                	jbe    801454 <memmove+0xba>
		s += n;
  8013dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 3b                	jne    801434 <memmove+0x9a>
  8013f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fd:	83 e0 03             	and    $0x3,%eax
  801400:	48 85 c0             	test   %rax,%rax
  801403:	75 2f                	jne    801434 <memmove+0x9a>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	83 e0 03             	and    $0x3,%eax
  80140c:	48 85 c0             	test   %rax,%rax
  80140f:	75 23                	jne    801434 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801411:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801415:	48 83 e8 04          	sub    $0x4,%rax
  801419:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141d:	48 83 ea 04          	sub    $0x4,%rdx
  801421:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801425:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801429:	48 89 c7             	mov    %rax,%rdi
  80142c:	48 89 d6             	mov    %rdx,%rsi
  80142f:	fd                   	std    
  801430:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801432:	eb 1d                	jmp    801451 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801438:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80143c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801440:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801444:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801448:	48 89 d7             	mov    %rdx,%rdi
  80144b:	48 89 c1             	mov    %rax,%rcx
  80144e:	fd                   	std    
  80144f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801451:	fc                   	cld    
  801452:	eb 57                	jmp    8014ab <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801458:	83 e0 03             	and    $0x3,%eax
  80145b:	48 85 c0             	test   %rax,%rax
  80145e:	75 36                	jne    801496 <memmove+0xfc>
  801460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801464:	83 e0 03             	and    $0x3,%eax
  801467:	48 85 c0             	test   %rax,%rax
  80146a:	75 2a                	jne    801496 <memmove+0xfc>
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	83 e0 03             	and    $0x3,%eax
  801473:	48 85 c0             	test   %rax,%rax
  801476:	75 1e                	jne    801496 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801478:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147c:	48 89 c1             	mov    %rax,%rcx
  80147f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801483:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801487:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80148b:	48 89 c7             	mov    %rax,%rdi
  80148e:	48 89 d6             	mov    %rdx,%rsi
  801491:	fc                   	cld    
  801492:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801494:	eb 15                	jmp    8014ab <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80149e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014a2:	48 89 c7             	mov    %rax,%rdi
  8014a5:	48 89 d6             	mov    %rdx,%rsi
  8014a8:	fc                   	cld    
  8014a9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014af:	c9                   	leaveq 
  8014b0:	c3                   	retq   

00000000008014b1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014b1:	55                   	push   %rbp
  8014b2:	48 89 e5             	mov    %rsp,%rbp
  8014b5:	48 83 ec 18          	sub    $0x18,%rsp
  8014b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014c9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d1:	48 89 ce             	mov    %rcx,%rsi
  8014d4:	48 89 c7             	mov    %rax,%rdi
  8014d7:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  8014de:	00 00 00 
  8014e1:	ff d0                	callq  *%rax
}
  8014e3:	c9                   	leaveq 
  8014e4:	c3                   	retq   

00000000008014e5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014e5:	55                   	push   %rbp
  8014e6:	48 89 e5             	mov    %rsp,%rbp
  8014e9:	48 83 ec 28          	sub    $0x28,%rsp
  8014ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801501:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801505:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801509:	eb 38                	jmp    801543 <memcmp+0x5e>
		if (*s1 != *s2)
  80150b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150f:	0f b6 10             	movzbl (%rax),%edx
  801512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801516:	0f b6 00             	movzbl (%rax),%eax
  801519:	38 c2                	cmp    %al,%dl
  80151b:	74 1c                	je     801539 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	0f b6 d0             	movzbl %al,%edx
  801527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	89 d1                	mov    %edx,%ecx
  801533:	29 c1                	sub    %eax,%ecx
  801535:	89 c8                	mov    %ecx,%eax
  801537:	eb 20                	jmp    801559 <memcmp+0x74>
		s1++, s2++;
  801539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80153e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801543:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801548:	0f 95 c0             	setne  %al
  80154b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801550:	84 c0                	test   %al,%al
  801552:	75 b7                	jne    80150b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 28          	sub    $0x28,%rsp
  801563:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801567:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80156a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801576:	48 01 d0             	add    %rdx,%rax
  801579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80157d:	eb 13                	jmp    801592 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801583:	0f b6 10             	movzbl (%rax),%edx
  801586:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801589:	38 c2                	cmp    %al,%dl
  80158b:	74 11                	je     80159e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801596:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80159a:	72 e3                	jb     80157f <memfind+0x24>
  80159c:	eb 01                	jmp    80159f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159e:	90                   	nop
	return (void *) s;
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015a3:	c9                   	leaveq 
  8015a4:	c3                   	retq   

00000000008015a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a5:	55                   	push   %rbp
  8015a6:	48 89 e5             	mov    %rsp,%rbp
  8015a9:	48 83 ec 38          	sub    $0x38,%rsp
  8015ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015b5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015bf:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015c6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015c7:	eb 05                	jmp    8015ce <strtol+0x29>
		s++;
  8015c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 20                	cmp    $0x20,%al
  8015d7:	74 f0                	je     8015c9 <strtol+0x24>
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	0f b6 00             	movzbl (%rax),%eax
  8015e0:	3c 09                	cmp    $0x9,%al
  8015e2:	74 e5                	je     8015c9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e8:	0f b6 00             	movzbl (%rax),%eax
  8015eb:	3c 2b                	cmp    $0x2b,%al
  8015ed:	75 07                	jne    8015f6 <strtol+0x51>
		s++;
  8015ef:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015f4:	eb 17                	jmp    80160d <strtol+0x68>
	else if (*s == '-')
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	3c 2d                	cmp    $0x2d,%al
  8015ff:	75 0c                	jne    80160d <strtol+0x68>
		s++, neg = 1;
  801601:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801606:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801611:	74 06                	je     801619 <strtol+0x74>
  801613:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801617:	75 28                	jne    801641 <strtol+0x9c>
  801619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161d:	0f b6 00             	movzbl (%rax),%eax
  801620:	3c 30                	cmp    $0x30,%al
  801622:	75 1d                	jne    801641 <strtol+0x9c>
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	48 83 c0 01          	add    $0x1,%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	3c 78                	cmp    $0x78,%al
  801631:	75 0e                	jne    801641 <strtol+0x9c>
		s += 2, base = 16;
  801633:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801638:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80163f:	eb 2c                	jmp    80166d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801641:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801645:	75 19                	jne    801660 <strtol+0xbb>
  801647:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164b:	0f b6 00             	movzbl (%rax),%eax
  80164e:	3c 30                	cmp    $0x30,%al
  801650:	75 0e                	jne    801660 <strtol+0xbb>
		s++, base = 8;
  801652:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801657:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80165e:	eb 0d                	jmp    80166d <strtol+0xc8>
	else if (base == 0)
  801660:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801664:	75 07                	jne    80166d <strtol+0xc8>
		base = 10;
  801666:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 2f                	cmp    $0x2f,%al
  801676:	7e 1d                	jle    801695 <strtol+0xf0>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 39                	cmp    $0x39,%al
  801681:	7f 12                	jg     801695 <strtol+0xf0>
			dig = *s - '0';
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 30             	sub    $0x30,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801693:	eb 4e                	jmp    8016e3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 60                	cmp    $0x60,%al
  80169e:	7e 1d                	jle    8016bd <strtol+0x118>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 7a                	cmp    $0x7a,%al
  8016a9:	7f 12                	jg     8016bd <strtol+0x118>
			dig = *s - 'a' + 10;
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	0f be c0             	movsbl %al,%eax
  8016b5:	83 e8 57             	sub    $0x57,%eax
  8016b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016bb:	eb 26                	jmp    8016e3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	0f b6 00             	movzbl (%rax),%eax
  8016c4:	3c 40                	cmp    $0x40,%al
  8016c6:	7e 47                	jle    80170f <strtol+0x16a>
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	0f b6 00             	movzbl (%rax),%eax
  8016cf:	3c 5a                	cmp    $0x5a,%al
  8016d1:	7f 3c                	jg     80170f <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	0f be c0             	movsbl %al,%eax
  8016dd:	83 e8 37             	sub    $0x37,%eax
  8016e0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016e6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016e9:	7d 23                	jge    80170e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8016eb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016f0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016f3:	48 98                	cltq   
  8016f5:	48 89 c2             	mov    %rax,%rdx
  8016f8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8016fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801700:	48 98                	cltq   
  801702:	48 01 d0             	add    %rdx,%rax
  801705:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801709:	e9 5f ff ff ff       	jmpq   80166d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80170e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80170f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801714:	74 0b                	je     801721 <strtol+0x17c>
		*endptr = (char *) s;
  801716:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80171a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80171e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801721:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801725:	74 09                	je     801730 <strtol+0x18b>
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	48 f7 d8             	neg    %rax
  80172e:	eb 04                	jmp    801734 <strtol+0x18f>
  801730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801734:	c9                   	leaveq 
  801735:	c3                   	retq   

0000000000801736 <strstr>:

char * strstr(const char *in, const char *str)
{
  801736:	55                   	push   %rbp
  801737:	48 89 e5             	mov    %rsp,%rbp
  80173a:	48 83 ec 30          	sub    $0x30,%rsp
  80173e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801742:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801746:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80174a:	0f b6 00             	movzbl (%rax),%eax
  80174d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801750:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801755:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801759:	75 06                	jne    801761 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	eb 68                	jmp    8017c9 <strstr+0x93>

    len = strlen(str);
  801761:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801765:	48 89 c7             	mov    %rax,%rdi
  801768:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  80176f:	00 00 00 
  801772:	ff d0                	callq  *%rax
  801774:	48 98                	cltq   
  801776:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	88 45 ef             	mov    %al,-0x11(%rbp)
  801784:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801789:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80178d:	75 07                	jne    801796 <strstr+0x60>
                return (char *) 0;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb 33                	jmp    8017c9 <strstr+0x93>
        } while (sc != c);
  801796:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80179a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80179d:	75 db                	jne    80177a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80179f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017a3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ab:	48 89 ce             	mov    %rcx,%rsi
  8017ae:	48 89 c7             	mov    %rax,%rdi
  8017b1:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  8017b8:	00 00 00 
  8017bb:	ff d0                	callq  *%rax
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	75 b9                	jne    80177a <strstr+0x44>

    return (char *) (in - 1);
  8017c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017c9:	c9                   	leaveq 
  8017ca:	c3                   	retq   
	...

00000000008017cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	53                   	push   %rbx
  8017d1:	48 83 ec 58          	sub    $0x58,%rsp
  8017d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017d8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017db:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017df:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017e3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017e7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ee:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8017f1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017f5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017f9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017fd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801801:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801805:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801808:	4c 89 c3             	mov    %r8,%rbx
  80180b:	cd 30                	int    $0x30
  80180d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801811:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801815:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801819:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80181d:	74 3e                	je     80185d <syscall+0x91>
  80181f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801824:	7e 37                	jle    80185d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80182d:	49 89 d0             	mov    %rdx,%r8
  801830:	89 c1                	mov    %eax,%ecx
  801832:	48 ba 80 4a 80 00 00 	movabs $0x804a80,%rdx
  801839:	00 00 00 
  80183c:	be 23 00 00 00       	mov    $0x23,%esi
  801841:	48 bf 9d 4a 80 00 00 	movabs $0x804a9d,%rdi
  801848:	00 00 00 
  80184b:	b8 00 00 00 00       	mov    $0x0,%eax
  801850:	49 b9 80 02 80 00 00 	movabs $0x800280,%r9
  801857:	00 00 00 
  80185a:	41 ff d1             	callq  *%r9

	return ret;
  80185d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801861:	48 83 c4 58          	add    $0x58,%rsp
  801865:	5b                   	pop    %rbx
  801866:	5d                   	pop    %rbp
  801867:	c3                   	retq   

0000000000801868 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801868:	55                   	push   %rbp
  801869:	48 89 e5             	mov    %rsp,%rbp
  80186c:	48 83 ec 20          	sub    $0x20,%rsp
  801870:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801874:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801880:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801887:	00 
  801888:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801894:	48 89 d1             	mov    %rdx,%rcx
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	be 00 00 00 00       	mov    $0x0,%esi
  80189f:	bf 00 00 00 00       	mov    $0x0,%edi
  8018a4:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c1:	00 
  8018c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	be 00 00 00 00       	mov    $0x0,%esi
  8018dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8018e2:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
}
  8018ee:	c9                   	leaveq 
  8018ef:	c3                   	retq   

00000000008018f0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 20          	sub    $0x20,%rsp
  8018f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018fe:	48 98                	cltq   
  801900:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801907:	00 
  801908:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801914:	b9 00 00 00 00       	mov    $0x0,%ecx
  801919:	48 89 c2             	mov    %rax,%rdx
  80191c:	be 01 00 00 00       	mov    $0x1,%esi
  801921:	bf 03 00 00 00       	mov    $0x3,%edi
  801926:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  80192d:	00 00 00 
  801930:	ff d0                	callq  *%rax
}
  801932:	c9                   	leaveq 
  801933:	c3                   	retq   

0000000000801934 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801934:	55                   	push   %rbp
  801935:	48 89 e5             	mov    %rsp,%rbp
  801938:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80193c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801943:	00 
  801944:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80194a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801950:	b9 00 00 00 00       	mov    $0x0,%ecx
  801955:	ba 00 00 00 00       	mov    $0x0,%edx
  80195a:	be 00 00 00 00       	mov    $0x0,%esi
  80195f:	bf 02 00 00 00       	mov    $0x2,%edi
  801964:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  80196b:	00 00 00 
  80196e:	ff d0                	callq  *%rax
}
  801970:	c9                   	leaveq 
  801971:	c3                   	retq   

0000000000801972 <sys_yield>:

void
sys_yield(void)
{
  801972:	55                   	push   %rbp
  801973:	48 89 e5             	mov    %rsp,%rbp
  801976:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80197a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801981:	00 
  801982:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801988:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
  801998:	be 00 00 00 00       	mov    $0x0,%esi
  80199d:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019a2:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8019a9:	00 00 00 
  8019ac:	ff d0                	callq  *%rax
}
  8019ae:	c9                   	leaveq 
  8019af:	c3                   	retq   

00000000008019b0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019b0:	55                   	push   %rbp
  8019b1:	48 89 e5             	mov    %rsp,%rbp
  8019b4:	48 83 ec 20          	sub    $0x20,%rsp
  8019b8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c5:	48 63 c8             	movslq %eax,%rcx
  8019c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cf:	48 98                	cltq   
  8019d1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d8:	00 
  8019d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019df:	49 89 c8             	mov    %rcx,%r8
  8019e2:	48 89 d1             	mov    %rdx,%rcx
  8019e5:	48 89 c2             	mov    %rax,%rdx
  8019e8:	be 01 00 00 00       	mov    $0x1,%esi
  8019ed:	bf 04 00 00 00       	mov    $0x4,%edi
  8019f2:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8019f9:	00 00 00 
  8019fc:	ff d0                	callq  *%rax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 30          	sub    $0x30,%rsp
  801a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a0f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a12:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a16:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a1a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a1d:	48 63 c8             	movslq %eax,%rcx
  801a20:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a27:	48 63 f0             	movslq %eax,%rsi
  801a2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a31:	48 98                	cltq   
  801a33:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a37:	49 89 f9             	mov    %rdi,%r9
  801a3a:	49 89 f0             	mov    %rsi,%r8
  801a3d:	48 89 d1             	mov    %rdx,%rcx
  801a40:	48 89 c2             	mov    %rax,%rdx
  801a43:	be 01 00 00 00       	mov    $0x1,%esi
  801a48:	bf 05 00 00 00       	mov    $0x5,%edi
  801a4d:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801a54:	00 00 00 
  801a57:	ff d0                	callq  *%rax
}
  801a59:	c9                   	leaveq 
  801a5a:	c3                   	retq   

0000000000801a5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a5b:	55                   	push   %rbp
  801a5c:	48 89 e5             	mov    %rsp,%rbp
  801a5f:	48 83 ec 20          	sub    $0x20,%rsp
  801a63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a71:	48 98                	cltq   
  801a73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a7a:	00 
  801a7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a87:	48 89 d1             	mov    %rdx,%rcx
  801a8a:	48 89 c2             	mov    %rax,%rdx
  801a8d:	be 01 00 00 00       	mov    $0x1,%esi
  801a92:	bf 06 00 00 00       	mov    $0x6,%edi
  801a97:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801a9e:	00 00 00 
  801aa1:	ff d0                	callq  *%rax
}
  801aa3:	c9                   	leaveq 
  801aa4:	c3                   	retq   

0000000000801aa5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801aa5:	55                   	push   %rbp
  801aa6:	48 89 e5             	mov    %rsp,%rbp
  801aa9:	48 83 ec 20          	sub    $0x20,%rsp
  801aad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ab0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ab3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ab6:	48 63 d0             	movslq %eax,%rdx
  801ab9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801abc:	48 98                	cltq   
  801abe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac5:	00 
  801ac6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801acc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad2:	48 89 d1             	mov    %rdx,%rcx
  801ad5:	48 89 c2             	mov    %rax,%rdx
  801ad8:	be 01 00 00 00       	mov    $0x1,%esi
  801add:	bf 08 00 00 00       	mov    $0x8,%edi
  801ae2:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801ae9:	00 00 00 
  801aec:	ff d0                	callq  *%rax
}
  801aee:	c9                   	leaveq 
  801aef:	c3                   	retq   

0000000000801af0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801af0:	55                   	push   %rbp
  801af1:	48 89 e5             	mov    %rsp,%rbp
  801af4:	48 83 ec 20          	sub    $0x20,%rsp
  801af8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801afb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801aff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b06:	48 98                	cltq   
  801b08:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b0f:	00 
  801b10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1c:	48 89 d1             	mov    %rdx,%rcx
  801b1f:	48 89 c2             	mov    %rax,%rdx
  801b22:	be 01 00 00 00       	mov    $0x1,%esi
  801b27:	bf 09 00 00 00       	mov    $0x9,%edi
  801b2c:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801b33:	00 00 00 
  801b36:	ff d0                	callq  *%rax
}
  801b38:	c9                   	leaveq 
  801b39:	c3                   	retq   

0000000000801b3a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b3a:	55                   	push   %rbp
  801b3b:	48 89 e5             	mov    %rsp,%rbp
  801b3e:	48 83 ec 20          	sub    $0x20,%rsp
  801b42:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b45:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b50:	48 98                	cltq   
  801b52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b59:	00 
  801b5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b66:	48 89 d1             	mov    %rdx,%rcx
  801b69:	48 89 c2             	mov    %rax,%rdx
  801b6c:	be 01 00 00 00       	mov    $0x1,%esi
  801b71:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b76:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801b7d:	00 00 00 
  801b80:	ff d0                	callq  *%rax
}
  801b82:	c9                   	leaveq 
  801b83:	c3                   	retq   

0000000000801b84 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	48 83 ec 30          	sub    $0x30,%rsp
  801b8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b97:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b9d:	48 63 f0             	movslq %eax,%rsi
  801ba0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba7:	48 98                	cltq   
  801ba9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb4:	00 
  801bb5:	49 89 f1             	mov    %rsi,%r9
  801bb8:	49 89 c8             	mov    %rcx,%r8
  801bbb:	48 89 d1             	mov    %rdx,%rcx
  801bbe:	48 89 c2             	mov    %rax,%rdx
  801bc1:	be 00 00 00 00       	mov    $0x0,%esi
  801bc6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801bcb:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801bd2:	00 00 00 
  801bd5:	ff d0                	callq  *%rax
}
  801bd7:	c9                   	leaveq 
  801bd8:	c3                   	retq   

0000000000801bd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bd9:	55                   	push   %rbp
  801bda:	48 89 e5             	mov    %rsp,%rbp
  801bdd:	48 83 ec 20          	sub    $0x20,%rsp
  801be1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801be5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801be9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf0:	00 
  801bf1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bf7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c02:	48 89 c2             	mov    %rax,%rdx
  801c05:	be 01 00 00 00       	mov    $0x1,%esi
  801c0a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c0f:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	callq  *%rax
}
  801c1b:	c9                   	leaveq 
  801c1c:	c3                   	retq   

0000000000801c1d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c1d:	55                   	push   %rbp
  801c1e:	48 89 e5             	mov    %rsp,%rbp
  801c21:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c25:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c2c:	00 
  801c2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c39:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	be 00 00 00 00       	mov    $0x0,%esi
  801c48:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c4d:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 20          	sub    $0x20,%rsp
  801c63:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c6f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c73:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7a:	00 
  801c7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c87:	48 89 d1             	mov    %rdx,%rcx
  801c8a:	48 89 c2             	mov    %rax,%rdx
  801c8d:	be 00 00 00 00       	mov    $0x0,%esi
  801c92:	bf 0f 00 00 00       	mov    $0xf,%edi
  801c97:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801c9e:	00 00 00 
  801ca1:	ff d0                	callq  *%rax
}
  801ca3:	c9                   	leaveq 
  801ca4:	c3                   	retq   

0000000000801ca5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801ca5:	55                   	push   %rbp
  801ca6:	48 89 e5             	mov    %rsp,%rbp
  801ca9:	48 83 ec 20          	sub    $0x20,%rsp
  801cad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cbd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cc4:	00 
  801cc5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ccb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cd1:	48 89 d1             	mov    %rdx,%rcx
  801cd4:	48 89 c2             	mov    %rax,%rdx
  801cd7:	be 00 00 00 00       	mov    $0x0,%esi
  801cdc:	bf 10 00 00 00       	mov    $0x10,%edi
  801ce1:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  801ce8:	00 00 00 
  801ceb:	ff d0                	callq  *%rax
}
  801ced:	c9                   	leaveq 
  801cee:	c3                   	retq   
	...

0000000000801cf0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801cf0:	55                   	push   %rbp
  801cf1:	48 89 e5             	mov    %rsp,%rbp
  801cf4:	48 83 ec 30          	sub    $0x30,%rsp
  801cf8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cfc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d00:	48 8b 00             	mov    (%rax),%rax
  801d03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d0b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d0f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801d12:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d15:	83 e0 02             	and    $0x2,%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	74 23                	je     801d3f <pgfault+0x4f>
  801d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d20:	48 89 c2             	mov    %rax,%rdx
  801d23:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d27:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d2e:	01 00 00 
  801d31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d35:	25 00 08 00 00       	and    $0x800,%eax
  801d3a:	48 85 c0             	test   %rax,%rax
  801d3d:	75 2a                	jne    801d69 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801d3f:	48 ba b0 4a 80 00 00 	movabs $0x804ab0,%rdx
  801d46:	00 00 00 
  801d49:	be 1c 00 00 00       	mov    $0x1c,%esi
  801d4e:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801d55:	00 00 00 
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  801d64:	00 00 00 
  801d67:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801d69:	ba 07 00 00 00       	mov    $0x7,%edx
  801d6e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d73:	bf 00 00 00 00       	mov    $0x0,%edi
  801d78:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	callq  *%rax
  801d84:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801d8b:	79 30                	jns    801dbd <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801d8d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801d90:	89 c1                	mov    %eax,%ecx
  801d92:	48 ba f0 4a 80 00 00 	movabs $0x804af0,%rdx
  801d99:	00 00 00 
  801d9c:	be 26 00 00 00       	mov    $0x26,%esi
  801da1:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801da8:	00 00 00 
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  801db7:	00 00 00 
  801dba:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dcf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801dd4:	48 89 c6             	mov    %rax,%rsi
  801dd7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ddc:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  801de3:	00 00 00 
  801de6:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801de8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dec:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801df0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801df4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801dfa:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e00:	48 89 c1             	mov    %rax,%rcx
  801e03:	ba 00 00 00 00       	mov    $0x0,%edx
  801e08:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e0d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e12:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801e19:	00 00 00 
  801e1c:	ff d0                	callq  *%rax
  801e1e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e21:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e25:	79 30                	jns    801e57 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801e27:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e2a:	89 c1                	mov    %eax,%ecx
  801e2c:	48 ba 18 4b 80 00 00 	movabs $0x804b18,%rdx
  801e33:	00 00 00 
  801e36:	be 2b 00 00 00       	mov    $0x2b,%esi
  801e3b:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801e42:	00 00 00 
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4a:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  801e51:	00 00 00 
  801e54:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801e57:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e61:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  801e68:	00 00 00 
  801e6b:	ff d0                	callq  *%rax
  801e6d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e74:	79 30                	jns    801ea6 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801e76:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e79:	89 c1                	mov    %eax,%ecx
  801e7b:	48 ba 40 4b 80 00 00 	movabs $0x804b40,%rdx
  801e82:	00 00 00 
  801e85:	be 2e 00 00 00       	mov    $0x2e,%esi
  801e8a:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801e91:	00 00 00 
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  801ea0:	00 00 00 
  801ea3:	41 ff d0             	callq  *%r8
	
}
  801ea6:	c9                   	leaveq 
  801ea7:	c3                   	retq   

0000000000801ea8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ea8:	55                   	push   %rbp
  801ea9:	48 89 e5             	mov    %rsp,%rbp
  801eac:	48 83 ec 30          	sub    $0x30,%rsp
  801eb0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801eb3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801eb6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ebd:	01 00 00 
  801ec0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801ec3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ec7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801ecb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ecf:	25 07 0e 00 00       	and    $0xe07,%eax
  801ed4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801ed7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801eda:	48 c1 e0 0c          	shl    $0xc,%rax
  801ede:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801ee2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ee5:	25 00 04 00 00       	and    $0x400,%eax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	74 5c                	je     801f4a <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801eee:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801ef1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ef5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801ef8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801efc:	41 89 f0             	mov    %esi,%r8d
  801eff:	48 89 c6             	mov    %rax,%rsi
  801f02:	bf 00 00 00 00       	mov    $0x0,%edi
  801f07:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801f0e:	00 00 00 
  801f11:	ff d0                	callq  *%rax
  801f13:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801f16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f1a:	0f 89 60 01 00 00    	jns    802080 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801f20:	48 ba 68 4b 80 00 00 	movabs $0x804b68,%rdx
  801f27:	00 00 00 
  801f2a:	be 4d 00 00 00       	mov    $0x4d,%esi
  801f2f:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801f36:	00 00 00 
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  801f45:	00 00 00 
  801f48:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801f4a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f4d:	83 e0 02             	and    $0x2,%eax
  801f50:	85 c0                	test   %eax,%eax
  801f52:	75 10                	jne    801f64 <duppage+0xbc>
  801f54:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f57:	25 00 08 00 00       	and    $0x800,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	0f 84 c4 00 00 00    	je     802028 <duppage+0x180>
	{
		perm |= PTE_COW;
  801f64:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801f6b:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801f6f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801f72:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f76:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7d:	41 89 f0             	mov    %esi,%r8d
  801f80:	48 89 c6             	mov    %rax,%rsi
  801f83:	bf 00 00 00 00       	mov    $0x0,%edi
  801f88:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801f8f:	00 00 00 
  801f92:	ff d0                	callq  *%rax
  801f94:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801f97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f9b:	79 2a                	jns    801fc7 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801f9d:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  801fa4:	00 00 00 
  801fa7:	be 56 00 00 00       	mov    $0x56,%esi
  801fac:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  801fb3:	00 00 00 
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  801fc2:	00 00 00 
  801fc5:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801fc7:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801fca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd2:	41 89 c8             	mov    %ecx,%r8d
  801fd5:	48 89 d1             	mov    %rdx,%rcx
  801fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdd:	48 89 c6             	mov    %rax,%rsi
  801fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe5:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801fec:	00 00 00 
  801fef:	ff d0                	callq  *%rax
  801ff1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  801ff4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801ff8:	0f 89 82 00 00 00    	jns    802080 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  801ffe:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  802005:	00 00 00 
  802008:	be 59 00 00 00       	mov    $0x59,%esi
  80200d:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802014:	00 00 00 
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  802023:	00 00 00 
  802026:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802028:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80202b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80202f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802036:	41 89 f0             	mov    %esi,%r8d
  802039:	48 89 c6             	mov    %rax,%rsi
  80203c:	bf 00 00 00 00       	mov    $0x0,%edi
  802041:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  802048:	00 00 00 
  80204b:	ff d0                	callq  *%rax
  80204d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802054:	79 2a                	jns    802080 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  802056:	48 ba d0 4b 80 00 00 	movabs $0x804bd0,%rdx
  80205d:	00 00 00 
  802060:	be 60 00 00 00       	mov    $0x60,%esi
  802065:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  80206c:	00 00 00 
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  80207b:	00 00 00 
  80207e:	ff d1                	callq  *%rcx
	}
	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leaveq 
  802086:	c3                   	retq   

0000000000802087 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802087:	55                   	push   %rbp
  802088:	48 89 e5             	mov    %rsp,%rbp
  80208b:	53                   	push   %rbx
  80208c:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802090:	48 bf f0 1c 80 00 00 	movabs $0x801cf0,%rdi
  802097:	00 00 00 
  80209a:	48 b8 44 41 80 00 00 	movabs $0x804144,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020a6:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  8020ad:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8020b0:	cd 30                	int    $0x30
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020b7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  8020ba:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  8020bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8020c1:	79 30                	jns    8020f3 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  8020c3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020c6:	89 c1                	mov    %eax,%ecx
  8020c8:	48 ba f4 4b 80 00 00 	movabs $0x804bf4,%rdx
  8020cf:	00 00 00 
  8020d2:	be 7f 00 00 00       	mov    $0x7f,%esi
  8020d7:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  8020de:	00 00 00 
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  8020ed:	00 00 00 
  8020f0:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  8020f3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8020f7:	75 4c                	jne    802145 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8020f9:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  802100:	00 00 00 
  802103:	ff d0                	callq  *%rax
  802105:	48 98                	cltq   
  802107:	48 89 c2             	mov    %rax,%rdx
  80210a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802110:	48 89 d0             	mov    %rdx,%rax
  802113:	48 c1 e0 03          	shl    $0x3,%rax
  802117:	48 01 d0             	add    %rdx,%rax
  80211a:	48 c1 e0 05          	shl    $0x5,%rax
  80211e:	48 89 c2             	mov    %rax,%rdx
  802121:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802128:	00 00 00 
  80212b:	48 01 c2             	add    %rax,%rdx
  80212e:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802135:	00 00 00 
  802138:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80213b:	b8 00 00 00 00       	mov    $0x0,%eax
  802140:	e9 38 02 00 00       	jmpq   80237d <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802145:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802148:	ba 07 00 00 00       	mov    $0x7,%edx
  80214d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802152:	89 c7                	mov    %eax,%edi
  802154:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80215b:	00 00 00 
  80215e:	ff d0                	callq  *%rax
  802160:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802163:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802167:	79 30                	jns    802199 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802169:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80216c:	89 c1                	mov    %eax,%ecx
  80216e:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  802175:	00 00 00 
  802178:	be 8b 00 00 00       	mov    $0x8b,%esi
  80217d:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802184:	00 00 00 
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  802193:	00 00 00 
  802196:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802199:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  8021a0:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8021a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8021ae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  8021b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8021bc:	e9 0a 01 00 00       	jmpq   8022cb <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8021c1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021c8:	01 00 00 
  8021cb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021ce:	48 63 d2             	movslq %edx,%rdx
  8021d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021d5:	83 e0 01             	and    $0x1,%eax
  8021d8:	84 c0                	test   %al,%al
  8021da:	0f 84 e7 00 00 00    	je     8022c7 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  8021e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  8021e7:	e9 cf 00 00 00       	jmpq   8022bb <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  8021ec:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8021f3:	01 00 00 
  8021f6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021f9:	48 63 d2             	movslq %edx,%rdx
  8021fc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802200:	83 e0 01             	and    $0x1,%eax
  802203:	84 c0                	test   %al,%al
  802205:	0f 84 a0 00 00 00    	je     8022ab <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80220b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802212:	e9 85 00 00 00       	jmpq   80229c <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802217:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80221e:	01 00 00 
  802221:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802224:	48 63 d2             	movslq %edx,%rdx
  802227:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222b:	83 e0 01             	and    $0x1,%eax
  80222e:	84 c0                	test   %al,%al
  802230:	74 56                	je     802288 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802232:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802239:	eb 42                	jmp    80227d <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80223b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802242:	01 00 00 
  802245:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802248:	48 63 d2             	movslq %edx,%rdx
  80224b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224f:	83 e0 01             	and    $0x1,%eax
  802252:	84 c0                	test   %al,%al
  802254:	74 1f                	je     802275 <fork+0x1ee>
  802256:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  80225d:	74 16                	je     802275 <fork+0x1ee>
									 duppage(envid,d1);
  80225f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802262:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802265:	89 d6                	mov    %edx,%esi
  802267:	89 c7                	mov    %eax,%edi
  802269:	48 b8 a8 1e 80 00 00 	movabs $0x801ea8,%rax
  802270:	00 00 00 
  802273:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802275:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802279:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  80227d:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802284:	7e b5                	jle    80223b <fork+0x1b4>
  802286:	eb 0c                	jmp    802294 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802288:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80228b:	83 c0 01             	add    $0x1,%eax
  80228e:	c1 e0 09             	shl    $0x9,%eax
  802291:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802294:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802298:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  80229c:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  8022a3:	0f 8e 6e ff ff ff    	jle    802217 <fork+0x190>
  8022a9:	eb 0c                	jmp    8022b7 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  8022ab:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022ae:	83 c0 01             	add    $0x1,%eax
  8022b1:	c1 e0 09             	shl    $0x9,%eax
  8022b4:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  8022b7:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  8022bb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022be:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8022c1:	0f 8c 25 ff ff ff    	jl     8021ec <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8022c7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8022cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ce:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8022d1:	0f 8c ea fe ff ff    	jl     8021c1 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8022d7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022da:	48 be 08 42 80 00 00 	movabs $0x804208,%rsi
  8022e1:	00 00 00 
  8022e4:	89 c7                	mov    %eax,%edi
  8022e6:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8022f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8022f9:	79 30                	jns    80232b <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8022fb:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8022fe:	89 c1                	mov    %eax,%ecx
  802300:	48 ba 28 4c 80 00 00 	movabs $0x804c28,%rdx
  802307:	00 00 00 
  80230a:	be ad 00 00 00       	mov    $0xad,%esi
  80230f:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802316:	00 00 00 
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  802325:	00 00 00 
  802328:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80232b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80232e:	be 02 00 00 00       	mov    $0x2,%esi
  802333:	89 c7                	mov    %eax,%edi
  802335:	48 b8 a5 1a 80 00 00 	movabs $0x801aa5,%rax
  80233c:	00 00 00 
  80233f:	ff d0                	callq  *%rax
  802341:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802344:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802348:	79 30                	jns    80237a <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80234a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80234d:	89 c1                	mov    %eax,%ecx
  80234f:	48 ba 58 4c 80 00 00 	movabs $0x804c58,%rdx
  802356:	00 00 00 
  802359:	be b0 00 00 00       	mov    $0xb0,%esi
  80235e:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  802365:	00 00 00 
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
  80236d:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  802374:	00 00 00 
  802377:	41 ff d0             	callq  *%r8
	return envid;
  80237a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  80237d:	48 83 c4 48          	add    $0x48,%rsp
  802381:	5b                   	pop    %rbx
  802382:	5d                   	pop    %rbp
  802383:	c3                   	retq   

0000000000802384 <sfork>:

// Challenge!
int
sfork(void)
{
  802384:	55                   	push   %rbp
  802385:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802388:	48 ba 7c 4c 80 00 00 	movabs $0x804c7c,%rdx
  80238f:	00 00 00 
  802392:	be b8 00 00 00       	mov    $0xb8,%esi
  802397:	48 bf e5 4a 80 00 00 	movabs $0x804ae5,%rdi
  80239e:	00 00 00 
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  8023ad:	00 00 00 
  8023b0:	ff d1                	callq  *%rcx
	...

00000000008023b4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8023b4:	55                   	push   %rbp
  8023b5:	48 89 e5             	mov    %rsp,%rbp
  8023b8:	48 83 ec 08          	sub    $0x8,%rsp
  8023bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023c4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023cb:	ff ff ff 
  8023ce:	48 01 d0             	add    %rdx,%rax
  8023d1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023d5:	c9                   	leaveq 
  8023d6:	c3                   	retq   

00000000008023d7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023d7:	55                   	push   %rbp
  8023d8:	48 89 e5             	mov    %rsp,%rbp
  8023db:	48 83 ec 08          	sub    $0x8,%rsp
  8023df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e7:	48 89 c7             	mov    %rax,%rdi
  8023ea:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  8023f1:	00 00 00 
  8023f4:	ff d0                	callq  *%rax
  8023f6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023fc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802400:	c9                   	leaveq 
  802401:	c3                   	retq   

0000000000802402 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
  802406:	48 83 ec 18          	sub    $0x18,%rsp
  80240a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80240e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802415:	eb 6b                	jmp    802482 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241a:	48 98                	cltq   
  80241c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802422:	48 c1 e0 0c          	shl    $0xc,%rax
  802426:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80242a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80242e:	48 89 c2             	mov    %rax,%rdx
  802431:	48 c1 ea 15          	shr    $0x15,%rdx
  802435:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80243c:	01 00 00 
  80243f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802443:	83 e0 01             	and    $0x1,%eax
  802446:	48 85 c0             	test   %rax,%rax
  802449:	74 21                	je     80246c <fd_alloc+0x6a>
  80244b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244f:	48 89 c2             	mov    %rax,%rdx
  802452:	48 c1 ea 0c          	shr    $0xc,%rdx
  802456:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80245d:	01 00 00 
  802460:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802464:	83 e0 01             	and    $0x1,%eax
  802467:	48 85 c0             	test   %rax,%rax
  80246a:	75 12                	jne    80247e <fd_alloc+0x7c>
			*fd_store = fd;
  80246c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802470:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802474:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
  80247c:	eb 1a                	jmp    802498 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80247e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802482:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802486:	7e 8f                	jle    802417 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802493:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802498:	c9                   	leaveq 
  802499:	c3                   	retq   

000000000080249a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80249a:	55                   	push   %rbp
  80249b:	48 89 e5             	mov    %rsp,%rbp
  80249e:	48 83 ec 20          	sub    $0x20,%rsp
  8024a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8024a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024ad:	78 06                	js     8024b5 <fd_lookup+0x1b>
  8024af:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8024b3:	7e 07                	jle    8024bc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024ba:	eb 6c                	jmp    802528 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024bf:	48 98                	cltq   
  8024c1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024c7:	48 c1 e0 0c          	shl    $0xc,%rax
  8024cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d3:	48 89 c2             	mov    %rax,%rdx
  8024d6:	48 c1 ea 15          	shr    $0x15,%rdx
  8024da:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024e1:	01 00 00 
  8024e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e8:	83 e0 01             	and    $0x1,%eax
  8024eb:	48 85 c0             	test   %rax,%rax
  8024ee:	74 21                	je     802511 <fd_lookup+0x77>
  8024f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f4:	48 89 c2             	mov    %rax,%rdx
  8024f7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8024fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802502:	01 00 00 
  802505:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802509:	83 e0 01             	and    $0x1,%eax
  80250c:	48 85 c0             	test   %rax,%rax
  80250f:	75 07                	jne    802518 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802511:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802516:	eb 10                	jmp    802528 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802518:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802520:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leaveq 
  802529:	c3                   	retq   

000000000080252a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80252a:	55                   	push   %rbp
  80252b:	48 89 e5             	mov    %rsp,%rbp
  80252e:	48 83 ec 30          	sub    $0x30,%rsp
  802532:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802536:	89 f0                	mov    %esi,%eax
  802538:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80253b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80253f:	48 89 c7             	mov    %rax,%rdi
  802542:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  802549:	00 00 00 
  80254c:	ff d0                	callq  *%rax
  80254e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802552:	48 89 d6             	mov    %rdx,%rsi
  802555:	89 c7                	mov    %eax,%edi
  802557:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
  802563:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802566:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80256a:	78 0a                	js     802576 <fd_close+0x4c>
	    || fd != fd2)
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802574:	74 12                	je     802588 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802576:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80257a:	74 05                	je     802581 <fd_close+0x57>
  80257c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257f:	eb 05                	jmp    802586 <fd_close+0x5c>
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	eb 69                	jmp    8025f1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802588:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80258c:	8b 00                	mov    (%rax),%eax
  80258e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802592:	48 89 d6             	mov    %rdx,%rsi
  802595:	89 c7                	mov    %eax,%edi
  802597:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025aa:	78 2a                	js     8025d6 <fd_close+0xac>
		if (dev->dev_close)
  8025ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025b4:	48 85 c0             	test   %rax,%rax
  8025b7:	74 16                	je     8025cf <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8025b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bd:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8025c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c5:	48 89 c7             	mov    %rax,%rdi
  8025c8:	ff d2                	callq  *%rdx
  8025ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025cd:	eb 07                	jmp    8025d6 <fd_close+0xac>
		else
			r = 0;
  8025cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025da:	48 89 c6             	mov    %rax,%rsi
  8025dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e2:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  8025e9:	00 00 00 
  8025ec:	ff d0                	callq  *%rax
	return r;
  8025ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025f1:	c9                   	leaveq 
  8025f2:	c3                   	retq   

00000000008025f3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025f3:	55                   	push   %rbp
  8025f4:	48 89 e5             	mov    %rsp,%rbp
  8025f7:	48 83 ec 20          	sub    $0x20,%rsp
  8025fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802609:	eb 41                	jmp    80264c <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80260b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802612:	00 00 00 
  802615:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802618:	48 63 d2             	movslq %edx,%rdx
  80261b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80261f:	8b 00                	mov    (%rax),%eax
  802621:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802624:	75 22                	jne    802648 <dev_lookup+0x55>
			*dev = devtab[i];
  802626:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80262d:	00 00 00 
  802630:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802633:	48 63 d2             	movslq %edx,%rdx
  802636:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80263a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802641:	b8 00 00 00 00       	mov    $0x0,%eax
  802646:	eb 60                	jmp    8026a8 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802648:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80264c:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802653:	00 00 00 
  802656:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802659:	48 63 d2             	movslq %edx,%rdx
  80265c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802660:	48 85 c0             	test   %rax,%rax
  802663:	75 a6                	jne    80260b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802665:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80266c:	00 00 00 
  80266f:	48 8b 00             	mov    (%rax),%rax
  802672:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802678:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80267b:	89 c6                	mov    %eax,%esi
  80267d:	48 bf 98 4c 80 00 00 	movabs $0x804c98,%rdi
  802684:	00 00 00 
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802693:	00 00 00 
  802696:	ff d1                	callq  *%rcx
	*dev = 0;
  802698:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80269c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8026a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8026a8:	c9                   	leaveq 
  8026a9:	c3                   	retq   

00000000008026aa <close>:

int
close(int fdnum)
{
  8026aa:	55                   	push   %rbp
  8026ab:	48 89 e5             	mov    %rsp,%rbp
  8026ae:	48 83 ec 20          	sub    $0x20,%rsp
  8026b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026bc:	48 89 d6             	mov    %rdx,%rsi
  8026bf:	89 c7                	mov    %eax,%edi
  8026c1:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d4:	79 05                	jns    8026db <close+0x31>
		return r;
  8026d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d9:	eb 18                	jmp    8026f3 <close+0x49>
	else
		return fd_close(fd, 1);
  8026db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026df:	be 01 00 00 00       	mov    $0x1,%esi
  8026e4:	48 89 c7             	mov    %rax,%rdi
  8026e7:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  8026ee:	00 00 00 
  8026f1:	ff d0                	callq  *%rax
}
  8026f3:	c9                   	leaveq 
  8026f4:	c3                   	retq   

00000000008026f5 <close_all>:

void
close_all(void)
{
  8026f5:	55                   	push   %rbp
  8026f6:	48 89 e5             	mov    %rsp,%rbp
  8026f9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802704:	eb 15                	jmp    80271b <close_all+0x26>
		close(i);
  802706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802709:	89 c7                	mov    %eax,%edi
  80270b:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802712:	00 00 00 
  802715:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802717:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80271b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80271f:	7e e5                	jle    802706 <close_all+0x11>
		close(i);
}
  802721:	c9                   	leaveq 
  802722:	c3                   	retq   

0000000000802723 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802723:	55                   	push   %rbp
  802724:	48 89 e5             	mov    %rsp,%rbp
  802727:	48 83 ec 40          	sub    $0x40,%rsp
  80272b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80272e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802731:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802735:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802738:	48 89 d6             	mov    %rdx,%rsi
  80273b:	89 c7                	mov    %eax,%edi
  80273d:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802744:	00 00 00 
  802747:	ff d0                	callq  *%rax
  802749:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80274c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802750:	79 08                	jns    80275a <dup+0x37>
		return r;
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	e9 70 01 00 00       	jmpq   8028ca <dup+0x1a7>
	close(newfdnum);
  80275a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80275d:	89 c7                	mov    %eax,%edi
  80275f:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80276b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80276e:	48 98                	cltq   
  802770:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802776:	48 c1 e0 0c          	shl    $0xc,%rax
  80277a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80277e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802782:	48 89 c7             	mov    %rax,%rdi
  802785:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  80278c:	00 00 00 
  80278f:	ff d0                	callq  *%rax
  802791:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802795:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802799:	48 89 c7             	mov    %rax,%rdi
  80279c:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	48 89 c2             	mov    %rax,%rdx
  8027b3:	48 c1 ea 15          	shr    $0x15,%rdx
  8027b7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027be:	01 00 00 
  8027c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027c5:	83 e0 01             	and    $0x1,%eax
  8027c8:	84 c0                	test   %al,%al
  8027ca:	74 71                	je     80283d <dup+0x11a>
  8027cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d0:	48 89 c2             	mov    %rax,%rdx
  8027d3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027de:	01 00 00 
  8027e1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e5:	83 e0 01             	and    $0x1,%eax
  8027e8:	84 c0                	test   %al,%al
  8027ea:	74 51                	je     80283d <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f0:	48 89 c2             	mov    %rax,%rdx
  8027f3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8027f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027fe:	01 00 00 
  802801:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802805:	89 c1                	mov    %eax,%ecx
  802807:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80280d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802815:	41 89 c8             	mov    %ecx,%r8d
  802818:	48 89 d1             	mov    %rdx,%rcx
  80281b:	ba 00 00 00 00       	mov    $0x0,%edx
  802820:	48 89 c6             	mov    %rax,%rsi
  802823:	bf 00 00 00 00       	mov    $0x0,%edi
  802828:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  80282f:	00 00 00 
  802832:	ff d0                	callq  *%rax
  802834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283b:	78 56                	js     802893 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80283d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802841:	48 89 c2             	mov    %rax,%rdx
  802844:	48 c1 ea 0c          	shr    $0xc,%rdx
  802848:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80284f:	01 00 00 
  802852:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802856:	89 c1                	mov    %eax,%ecx
  802858:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80285e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802862:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802866:	41 89 c8             	mov    %ecx,%r8d
  802869:	48 89 d1             	mov    %rdx,%rcx
  80286c:	ba 00 00 00 00       	mov    $0x0,%edx
  802871:	48 89 c6             	mov    %rax,%rsi
  802874:	bf 00 00 00 00       	mov    $0x0,%edi
  802879:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  802880:	00 00 00 
  802883:	ff d0                	callq  *%rax
  802885:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802888:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288c:	78 08                	js     802896 <dup+0x173>
		goto err;

	return newfdnum;
  80288e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802891:	eb 37                	jmp    8028ca <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802893:	90                   	nop
  802894:	eb 01                	jmp    802897 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802896:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80289b:	48 89 c6             	mov    %rax,%rsi
  80289e:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a3:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  8028aa:	00 00 00 
  8028ad:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8028af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b3:	48 89 c6             	mov    %rax,%rsi
  8028b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8028bb:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  8028c2:	00 00 00 
  8028c5:	ff d0                	callq  *%rax
	return r;
  8028c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028ca:	c9                   	leaveq 
  8028cb:	c3                   	retq   

00000000008028cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028cc:	55                   	push   %rbp
  8028cd:	48 89 e5             	mov    %rsp,%rbp
  8028d0:	48 83 ec 40          	sub    $0x40,%rsp
  8028d4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028df:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028e3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028e6:	48 89 d6             	mov    %rdx,%rsi
  8028e9:	89 c7                	mov    %eax,%edi
  8028eb:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  8028f2:	00 00 00 
  8028f5:	ff d0                	callq  *%rax
  8028f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fe:	78 24                	js     802924 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802904:	8b 00                	mov    (%rax),%eax
  802906:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80290a:	48 89 d6             	mov    %rdx,%rsi
  80290d:	89 c7                	mov    %eax,%edi
  80290f:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80291e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802922:	79 05                	jns    802929 <read+0x5d>
		return r;
  802924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802927:	eb 7a                	jmp    8029a3 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802929:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292d:	8b 40 08             	mov    0x8(%rax),%eax
  802930:	83 e0 03             	and    $0x3,%eax
  802933:	83 f8 01             	cmp    $0x1,%eax
  802936:	75 3a                	jne    802972 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802938:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80293f:	00 00 00 
  802942:	48 8b 00             	mov    (%rax),%rax
  802945:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80294b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80294e:	89 c6                	mov    %eax,%esi
  802950:	48 bf b7 4c 80 00 00 	movabs $0x804cb7,%rdi
  802957:	00 00 00 
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
  80295f:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802966:	00 00 00 
  802969:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80296b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802970:	eb 31                	jmp    8029a3 <read+0xd7>
	}
	if (!dev->dev_read)
  802972:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802976:	48 8b 40 10          	mov    0x10(%rax),%rax
  80297a:	48 85 c0             	test   %rax,%rax
  80297d:	75 07                	jne    802986 <read+0xba>
		return -E_NOT_SUPP;
  80297f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802984:	eb 1d                	jmp    8029a3 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802986:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80298e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802992:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802996:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80299a:	48 89 ce             	mov    %rcx,%rsi
  80299d:	48 89 c7             	mov    %rax,%rdi
  8029a0:	41 ff d0             	callq  *%r8
}
  8029a3:	c9                   	leaveq 
  8029a4:	c3                   	retq   

00000000008029a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8029a5:	55                   	push   %rbp
  8029a6:	48 89 e5             	mov    %rsp,%rbp
  8029a9:	48 83 ec 30          	sub    $0x30,%rsp
  8029ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8029b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029bf:	eb 46                	jmp    802a07 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c4:	48 98                	cltq   
  8029c6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029ca:	48 29 c2             	sub    %rax,%rdx
  8029cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029d0:	48 98                	cltq   
  8029d2:	48 89 c1             	mov    %rax,%rcx
  8029d5:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  8029d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029dc:	48 89 ce             	mov    %rcx,%rsi
  8029df:	89 c7                	mov    %eax,%edi
  8029e1:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
  8029ed:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029f4:	79 05                	jns    8029fb <readn+0x56>
			return m;
  8029f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029f9:	eb 1d                	jmp    802a18 <readn+0x73>
		if (m == 0)
  8029fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029ff:	74 13                	je     802a14 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a04:	01 45 fc             	add    %eax,-0x4(%rbp)
  802a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a0a:	48 98                	cltq   
  802a0c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802a10:	72 af                	jb     8029c1 <readn+0x1c>
  802a12:	eb 01                	jmp    802a15 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802a14:	90                   	nop
	}
	return tot;
  802a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a18:	c9                   	leaveq 
  802a19:	c3                   	retq   

0000000000802a1a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a1a:	55                   	push   %rbp
  802a1b:	48 89 e5             	mov    %rsp,%rbp
  802a1e:	48 83 ec 40          	sub    $0x40,%rsp
  802a22:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a2d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a31:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a34:	48 89 d6             	mov    %rdx,%rsi
  802a37:	89 c7                	mov    %eax,%edi
  802a39:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
  802a45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a4c:	78 24                	js     802a72 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a52:	8b 00                	mov    (%rax),%eax
  802a54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a58:	48 89 d6             	mov    %rdx,%rsi
  802a5b:	89 c7                	mov    %eax,%edi
  802a5d:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a70:	79 05                	jns    802a77 <write+0x5d>
		return r;
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	eb 79                	jmp    802af0 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7b:	8b 40 08             	mov    0x8(%rax),%eax
  802a7e:	83 e0 03             	and    $0x3,%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	75 3a                	jne    802abf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a85:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802a8c:	00 00 00 
  802a8f:	48 8b 00             	mov    (%rax),%rax
  802a92:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a98:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a9b:	89 c6                	mov    %eax,%esi
  802a9d:	48 bf d3 4c 80 00 00 	movabs $0x804cd3,%rdi
  802aa4:	00 00 00 
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802ab3:	00 00 00 
  802ab6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802abd:	eb 31                	jmp    802af0 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ac7:	48 85 c0             	test   %rax,%rax
  802aca:	75 07                	jne    802ad3 <write+0xb9>
		return -E_NOT_SUPP;
  802acc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ad1:	eb 1d                	jmp    802af0 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad7:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ae3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ae7:	48 89 ce             	mov    %rcx,%rsi
  802aea:	48 89 c7             	mov    %rax,%rdi
  802aed:	41 ff d0             	callq  *%r8
}
  802af0:	c9                   	leaveq 
  802af1:	c3                   	retq   

0000000000802af2 <seek>:

int
seek(int fdnum, off_t offset)
{
  802af2:	55                   	push   %rbp
  802af3:	48 89 e5             	mov    %rsp,%rbp
  802af6:	48 83 ec 18          	sub    $0x18,%rsp
  802afa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802afd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b00:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b07:	48 89 d6             	mov    %rdx,%rsi
  802b0a:	89 c7                	mov    %eax,%edi
  802b0c:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802b13:	00 00 00 
  802b16:	ff d0                	callq  *%rax
  802b18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b1f:	79 05                	jns    802b26 <seek+0x34>
		return r;
  802b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b24:	eb 0f                	jmp    802b35 <seek+0x43>
	fd->fd_offset = offset;
  802b26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b2a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b2d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b35:	c9                   	leaveq 
  802b36:	c3                   	retq   

0000000000802b37 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b37:	55                   	push   %rbp
  802b38:	48 89 e5             	mov    %rsp,%rbp
  802b3b:	48 83 ec 30          	sub    $0x30,%rsp
  802b3f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b42:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b4c:	48 89 d6             	mov    %rdx,%rsi
  802b4f:	89 c7                	mov    %eax,%edi
  802b51:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802b58:	00 00 00 
  802b5b:	ff d0                	callq  *%rax
  802b5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b64:	78 24                	js     802b8a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6a:	8b 00                	mov    (%rax),%eax
  802b6c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b70:	48 89 d6             	mov    %rdx,%rsi
  802b73:	89 c7                	mov    %eax,%edi
  802b75:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  802b7c:	00 00 00 
  802b7f:	ff d0                	callq  *%rax
  802b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b88:	79 05                	jns    802b8f <ftruncate+0x58>
		return r;
  802b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8d:	eb 72                	jmp    802c01 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b93:	8b 40 08             	mov    0x8(%rax),%eax
  802b96:	83 e0 03             	and    $0x3,%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	75 3a                	jne    802bd7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b9d:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  802ba4:	00 00 00 
  802ba7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802baa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802bb0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802bb3:	89 c6                	mov    %eax,%esi
  802bb5:	48 bf f0 4c 80 00 00 	movabs $0x804cf0,%rdi
  802bbc:	00 00 00 
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc4:	48 b9 bb 04 80 00 00 	movabs $0x8004bb,%rcx
  802bcb:	00 00 00 
  802bce:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bd5:	eb 2a                	jmp    802c01 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdb:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bdf:	48 85 c0             	test   %rax,%rax
  802be2:	75 07                	jne    802beb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802be4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802be9:	eb 16                	jmp    802c01 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bef:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802bfa:	89 d6                	mov    %edx,%esi
  802bfc:	48 89 c7             	mov    %rax,%rdi
  802bff:	ff d1                	callq  *%rcx
}
  802c01:	c9                   	leaveq 
  802c02:	c3                   	retq   

0000000000802c03 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	48 83 ec 30          	sub    $0x30,%rsp
  802c0b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c0e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c12:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c16:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c19:	48 89 d6             	mov    %rdx,%rsi
  802c1c:	89 c7                	mov    %eax,%edi
  802c1e:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  802c25:	00 00 00 
  802c28:	ff d0                	callq  *%rax
  802c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c31:	78 24                	js     802c57 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c37:	8b 00                	mov    (%rax),%eax
  802c39:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c3d:	48 89 d6             	mov    %rdx,%rsi
  802c40:	89 c7                	mov    %eax,%edi
  802c42:	48 b8 f3 25 80 00 00 	movabs $0x8025f3,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
  802c4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c55:	79 05                	jns    802c5c <fstat+0x59>
		return r;
  802c57:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c5a:	eb 5e                	jmp    802cba <fstat+0xb7>
	if (!dev->dev_stat)
  802c5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c60:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c64:	48 85 c0             	test   %rax,%rax
  802c67:	75 07                	jne    802c70 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c69:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c6e:	eb 4a                	jmp    802cba <fstat+0xb7>
	stat->st_name[0] = 0;
  802c70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c74:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c77:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c82:	00 00 00 
	stat->st_isdir = 0;
  802c85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c89:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c90:	00 00 00 
	stat->st_dev = dev;
  802c93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c97:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c9b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca6:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802caa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cae:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802cb2:	48 89 d6             	mov    %rdx,%rsi
  802cb5:	48 89 c7             	mov    %rax,%rdi
  802cb8:	ff d1                	callq  *%rcx
}
  802cba:	c9                   	leaveq 
  802cbb:	c3                   	retq   

0000000000802cbc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 83 ec 20          	sub    $0x20,%rsp
  802cc4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cc8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd0:	be 00 00 00 00       	mov    $0x0,%esi
  802cd5:	48 89 c7             	mov    %rax,%rdi
  802cd8:	48 b8 ab 2d 80 00 00 	movabs $0x802dab,%rax
  802cdf:	00 00 00 
  802ce2:	ff d0                	callq  *%rax
  802ce4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ceb:	79 05                	jns    802cf2 <stat+0x36>
		return fd;
  802ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf0:	eb 2f                	jmp    802d21 <stat+0x65>
	r = fstat(fd, stat);
  802cf2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf9:	48 89 d6             	mov    %rdx,%rsi
  802cfc:	89 c7                	mov    %eax,%edi
  802cfe:	48 b8 03 2c 80 00 00 	movabs $0x802c03,%rax
  802d05:	00 00 00 
  802d08:	ff d0                	callq  *%rax
  802d0a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802d0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d10:	89 c7                	mov    %eax,%edi
  802d12:	48 b8 aa 26 80 00 00 	movabs $0x8026aa,%rax
  802d19:	00 00 00 
  802d1c:	ff d0                	callq  *%rax
	return r;
  802d1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d21:	c9                   	leaveq 
  802d22:	c3                   	retq   
	...

0000000000802d24 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d24:	55                   	push   %rbp
  802d25:	48 89 e5             	mov    %rsp,%rbp
  802d28:	48 83 ec 10          	sub    $0x10,%rsp
  802d2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d33:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802d3a:	00 00 00 
  802d3d:	8b 00                	mov    (%rax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	75 1d                	jne    802d60 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d43:	bf 01 00 00 00       	mov    $0x1,%edi
  802d48:	48 b8 17 44 80 00 00 	movabs $0x804417,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
  802d54:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802d5b:	00 00 00 
  802d5e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d60:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802d67:	00 00 00 
  802d6a:	8b 00                	mov    (%rax),%eax
  802d6c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d6f:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d74:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802d7b:	00 00 00 
  802d7e:	89 c7                	mov    %eax,%edi
  802d80:	48 b8 54 43 80 00 00 	movabs $0x804354,%rax
  802d87:	00 00 00 
  802d8a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d90:	ba 00 00 00 00       	mov    $0x0,%edx
  802d95:	48 89 c6             	mov    %rax,%rsi
  802d98:	bf 00 00 00 00       	mov    $0x0,%edi
  802d9d:	48 b8 94 42 80 00 00 	movabs $0x804294,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
}
  802da9:	c9                   	leaveq 
  802daa:	c3                   	retq   

0000000000802dab <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802dab:	55                   	push   %rbp
  802dac:	48 89 e5             	mov    %rsp,%rbp
  802daf:	48 83 ec 20          	sub    $0x20,%rsp
  802db3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802db7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802dba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbe:	48 89 c7             	mov    %rax,%rdi
  802dc1:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  802dc8:	00 00 00 
  802dcb:	ff d0                	callq  *%rax
  802dcd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802dd2:	7e 0a                	jle    802dde <open+0x33>
                return -E_BAD_PATH;
  802dd4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802dd9:	e9 a5 00 00 00       	jmpq   802e83 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802dde:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802de2:	48 89 c7             	mov    %rax,%rdi
  802de5:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  802dec:	00 00 00 
  802def:	ff d0                	callq  *%rax
  802df1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df8:	79 08                	jns    802e02 <open+0x57>
		return r;
  802dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfd:	e9 81 00 00 00       	jmpq   802e83 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e06:	48 89 c6             	mov    %rax,%rsi
  802e09:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e10:	00 00 00 
  802e13:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802e1f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e26:	00 00 00 
  802e29:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e2c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802e32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e36:	48 89 c6             	mov    %rax,%rsi
  802e39:	bf 01 00 00 00       	mov    $0x1,%edi
  802e3e:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  802e45:	00 00 00 
  802e48:	ff d0                	callq  *%rax
  802e4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802e4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e51:	79 1d                	jns    802e70 <open+0xc5>
	{
		fd_close(fd,0);
  802e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e57:	be 00 00 00 00       	mov    $0x0,%esi
  802e5c:	48 89 c7             	mov    %rax,%rdi
  802e5f:	48 b8 2a 25 80 00 00 	movabs $0x80252a,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax
		return r;
  802e6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6e:	eb 13                	jmp    802e83 <open+0xd8>
	}
	return fd2num(fd);
  802e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e74:	48 89 c7             	mov    %rax,%rdi
  802e77:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
	


}
  802e83:	c9                   	leaveq 
  802e84:	c3                   	retq   

0000000000802e85 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e85:	55                   	push   %rbp
  802e86:	48 89 e5             	mov    %rsp,%rbp
  802e89:	48 83 ec 10          	sub    $0x10,%rsp
  802e8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e95:	8b 50 0c             	mov    0xc(%rax),%edx
  802e98:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e9f:	00 00 00 
  802ea2:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ea4:	be 00 00 00 00       	mov    $0x0,%esi
  802ea9:	bf 06 00 00 00       	mov    $0x6,%edi
  802eae:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
}
  802eba:	c9                   	leaveq 
  802ebb:	c3                   	retq   

0000000000802ebc <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ebc:	55                   	push   %rbp
  802ebd:	48 89 e5             	mov    %rsp,%rbp
  802ec0:	48 83 ec 30          	sub    $0x30,%rsp
  802ec4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ec8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ecc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed4:	8b 50 0c             	mov    0xc(%rax),%edx
  802ed7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ede:	00 00 00 
  802ee1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ee3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802eea:	00 00 00 
  802eed:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ef1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802ef5:	be 00 00 00 00       	mov    $0x0,%esi
  802efa:	bf 03 00 00 00       	mov    $0x3,%edi
  802eff:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
  802f0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f12:	79 05                	jns    802f19 <devfile_read+0x5d>
	{
		return r;
  802f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f17:	eb 2c                	jmp    802f45 <devfile_read+0x89>
	}
	if(r > 0)
  802f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f1d:	7e 23                	jle    802f42 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  802f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f22:	48 63 d0             	movslq %eax,%rdx
  802f25:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f29:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802f30:	00 00 00 
  802f33:	48 89 c7             	mov    %rax,%rdi
  802f36:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
	return r;
  802f42:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  802f45:	c9                   	leaveq 
  802f46:	c3                   	retq   

0000000000802f47 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802f47:	55                   	push   %rbp
  802f48:	48 89 e5             	mov    %rsp,%rbp
  802f4b:	48 83 ec 30          	sub    $0x30,%rsp
  802f4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  802f5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f5f:	8b 50 0c             	mov    0xc(%rax),%edx
  802f62:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f69:	00 00 00 
  802f6c:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  802f6e:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802f75:	00 
  802f76:	76 08                	jbe    802f80 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  802f78:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  802f7f:	00 
	fsipcbuf.write.req_n=n;
  802f80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f87:	00 00 00 
  802f8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f8e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802f92:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f9a:	48 89 c6             	mov    %rax,%rsi
  802f9d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802fa4:	00 00 00 
  802fa7:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  802fb3:	be 00 00 00 00       	mov    $0x0,%esi
  802fb8:	bf 04 00 00 00       	mov    $0x4,%edi
  802fbd:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  802fc4:	00 00 00 
  802fc7:	ff d0                	callq  *%rax
  802fc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  802fcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fcf:	c9                   	leaveq 
  802fd0:	c3                   	retq   

0000000000802fd1 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  802fd1:	55                   	push   %rbp
  802fd2:	48 89 e5             	mov    %rsp,%rbp
  802fd5:	48 83 ec 10          	sub    $0x10,%rsp
  802fd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802fdd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fe0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fe4:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fee:	00 00 00 
  802ff1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  802ff3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ffa:	00 00 00 
  802ffd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803000:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803003:	be 00 00 00 00       	mov    $0x0,%esi
  803008:	bf 02 00 00 00       	mov    $0x2,%edi
  80300d:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  803014:	00 00 00 
  803017:	ff d0                	callq  *%rax
}
  803019:	c9                   	leaveq 
  80301a:	c3                   	retq   

000000000080301b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80301b:	55                   	push   %rbp
  80301c:	48 89 e5             	mov    %rsp,%rbp
  80301f:	48 83 ec 20          	sub    $0x20,%rsp
  803023:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803027:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80302b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302f:	8b 50 0c             	mov    0xc(%rax),%edx
  803032:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803039:	00 00 00 
  80303c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80303e:	be 00 00 00 00       	mov    $0x0,%esi
  803043:	bf 05 00 00 00       	mov    $0x5,%edi
  803048:	48 b8 24 2d 80 00 00 	movabs $0x802d24,%rax
  80304f:	00 00 00 
  803052:	ff d0                	callq  *%rax
  803054:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803057:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80305b:	79 05                	jns    803062 <devfile_stat+0x47>
		return r;
  80305d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803060:	eb 56                	jmp    8030b8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803066:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80306d:	00 00 00 
  803070:	48 89 c7             	mov    %rax,%rdi
  803073:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  80307a:	00 00 00 
  80307d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80307f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803086:	00 00 00 
  803089:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80308f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803093:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803099:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030a0:	00 00 00 
  8030a3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b8:	c9                   	leaveq 
  8030b9:	c3                   	retq   
	...

00000000008030bc <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8030bc:	55                   	push   %rbp
  8030bd:	48 89 e5             	mov    %rsp,%rbp
  8030c0:	48 83 ec 20          	sub    $0x20,%rsp
  8030c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8030c7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030cb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030ce:	48 89 d6             	mov    %rdx,%rsi
  8030d1:	89 c7                	mov    %eax,%edi
  8030d3:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
  8030df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030e6:	79 05                	jns    8030ed <fd2sockid+0x31>
		return r;
  8030e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030eb:	eb 24                	jmp    803111 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8030ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030f1:	8b 10                	mov    (%rax),%edx
  8030f3:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8030fa:	00 00 00 
  8030fd:	8b 00                	mov    (%rax),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	74 07                	je     80310a <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803103:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803108:	eb 07                	jmp    803111 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80310a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80310e:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803111:	c9                   	leaveq 
  803112:	c3                   	retq   

0000000000803113 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803113:	55                   	push   %rbp
  803114:	48 89 e5             	mov    %rsp,%rbp
  803117:	48 83 ec 20          	sub    $0x20,%rsp
  80311b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80311e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
  803131:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803134:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803138:	78 26                	js     803160 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80313a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313e:	ba 07 04 00 00       	mov    $0x407,%edx
  803143:	48 89 c6             	mov    %rax,%rsi
  803146:	bf 00 00 00 00       	mov    $0x0,%edi
  80314b:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80315a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315e:	79 16                	jns    803176 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803160:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803163:	89 c7                	mov    %eax,%edi
  803165:	48 b8 20 36 80 00 00 	movabs $0x803620,%rax
  80316c:	00 00 00 
  80316f:	ff d0                	callq  *%rax
		return r;
  803171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803174:	eb 3a                	jmp    8031b0 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317a:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  803181:	00 00 00 
  803184:	8b 12                	mov    (%rdx),%edx
  803186:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803193:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803197:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80319a:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80319d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
}
  8031b0:	c9                   	leaveq 
  8031b1:	c3                   	retq   

00000000008031b2 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8031b2:	55                   	push   %rbp
  8031b3:	48 89 e5             	mov    %rsp,%rbp
  8031b6:	48 83 ec 30          	sub    $0x30,%rsp
  8031ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c8:	89 c7                	mov    %eax,%edi
  8031ca:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  8031d1:	00 00 00 
  8031d4:	ff d0                	callq  *%rax
  8031d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031dd:	79 05                	jns    8031e4 <accept+0x32>
		return r;
  8031df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e2:	eb 3b                	jmp    80321f <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8031e4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8031ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ef:	48 89 ce             	mov    %rcx,%rsi
  8031f2:	89 c7                	mov    %eax,%edi
  8031f4:	48 b8 fd 34 80 00 00 	movabs $0x8034fd,%rax
  8031fb:	00 00 00 
  8031fe:	ff d0                	callq  *%rax
  803200:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803203:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803207:	79 05                	jns    80320e <accept+0x5c>
		return r;
  803209:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320c:	eb 11                	jmp    80321f <accept+0x6d>
	return alloc_sockfd(r);
  80320e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803211:	89 c7                	mov    %eax,%edi
  803213:	48 b8 13 31 80 00 00 	movabs $0x803113,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 20          	sub    $0x20,%rsp
  803229:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80322c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803230:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803233:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803236:	89 c7                	mov    %eax,%edi
  803238:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax
  803244:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803247:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324b:	79 05                	jns    803252 <bind+0x31>
		return r;
  80324d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803250:	eb 1b                	jmp    80326d <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803252:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803255:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80325c:	48 89 ce             	mov    %rcx,%rsi
  80325f:	89 c7                	mov    %eax,%edi
  803261:	48 b8 7c 35 80 00 00 	movabs $0x80357c,%rax
  803268:	00 00 00 
  80326b:	ff d0                	callq  *%rax
}
  80326d:	c9                   	leaveq 
  80326e:	c3                   	retq   

000000000080326f <shutdown>:

int
shutdown(int s, int how)
{
  80326f:	55                   	push   %rbp
  803270:	48 89 e5             	mov    %rsp,%rbp
  803273:	48 83 ec 20          	sub    $0x20,%rsp
  803277:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80327a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80327d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803280:	89 c7                	mov    %eax,%edi
  803282:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
  80328e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803291:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803295:	79 05                	jns    80329c <shutdown+0x2d>
		return r;
  803297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80329a:	eb 16                	jmp    8032b2 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80329c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80329f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a2:	89 d6                	mov    %edx,%esi
  8032a4:	89 c7                	mov    %eax,%edi
  8032a6:	48 b8 e0 35 80 00 00 	movabs $0x8035e0,%rax
  8032ad:	00 00 00 
  8032b0:	ff d0                	callq  *%rax
}
  8032b2:	c9                   	leaveq 
  8032b3:	c3                   	retq   

00000000008032b4 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8032b4:	55                   	push   %rbp
  8032b5:	48 89 e5             	mov    %rsp,%rbp
  8032b8:	48 83 ec 10          	sub    $0x10,%rsp
  8032bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8032c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c4:	48 89 c7             	mov    %rax,%rdi
  8032c7:	48 b8 9c 44 80 00 00 	movabs $0x80449c,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	83 f8 01             	cmp    $0x1,%eax
  8032d6:	75 17                	jne    8032ef <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8032d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032dc:	8b 40 0c             	mov    0xc(%rax),%eax
  8032df:	89 c7                	mov    %eax,%edi
  8032e1:	48 b8 20 36 80 00 00 	movabs $0x803620,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
  8032ed:	eb 05                	jmp    8032f4 <devsock_close+0x40>
	else
		return 0;
  8032ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f4:	c9                   	leaveq 
  8032f5:	c3                   	retq   

00000000008032f6 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8032f6:	55                   	push   %rbp
  8032f7:	48 89 e5             	mov    %rsp,%rbp
  8032fa:	48 83 ec 20          	sub    $0x20,%rsp
  8032fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803301:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803305:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803308:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80330b:	89 c7                	mov    %eax,%edi
  80330d:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  803314:	00 00 00 
  803317:	ff d0                	callq  *%rax
  803319:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80331c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803320:	79 05                	jns    803327 <connect+0x31>
		return r;
  803322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803325:	eb 1b                	jmp    803342 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803327:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80332a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	48 89 ce             	mov    %rcx,%rsi
  803334:	89 c7                	mov    %eax,%edi
  803336:	48 b8 4d 36 80 00 00 	movabs $0x80364d,%rax
  80333d:	00 00 00 
  803340:	ff d0                	callq  *%rax
}
  803342:	c9                   	leaveq 
  803343:	c3                   	retq   

0000000000803344 <listen>:

int
listen(int s, int backlog)
{
  803344:	55                   	push   %rbp
  803345:	48 89 e5             	mov    %rsp,%rbp
  803348:	48 83 ec 20          	sub    $0x20,%rsp
  80334c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80334f:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803352:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803355:	89 c7                	mov    %eax,%edi
  803357:	48 b8 bc 30 80 00 00 	movabs $0x8030bc,%rax
  80335e:	00 00 00 
  803361:	ff d0                	callq  *%rax
  803363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336a:	79 05                	jns    803371 <listen+0x2d>
		return r;
  80336c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336f:	eb 16                	jmp    803387 <listen+0x43>
	return nsipc_listen(r, backlog);
  803371:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	89 d6                	mov    %edx,%esi
  803379:	89 c7                	mov    %eax,%edi
  80337b:	48 b8 b1 36 80 00 00 	movabs $0x8036b1,%rax
  803382:	00 00 00 
  803385:	ff d0                	callq  *%rax
}
  803387:	c9                   	leaveq 
  803388:	c3                   	retq   

0000000000803389 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803389:	55                   	push   %rbp
  80338a:	48 89 e5             	mov    %rsp,%rbp
  80338d:	48 83 ec 20          	sub    $0x20,%rsp
  803391:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803399:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80339d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a1:	89 c2                	mov    %eax,%edx
  8033a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033a7:	8b 40 0c             	mov    0xc(%rax),%eax
  8033aa:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033b3:	89 c7                	mov    %eax,%edi
  8033b5:	48 b8 f1 36 80 00 00 	movabs $0x8036f1,%rax
  8033bc:	00 00 00 
  8033bf:	ff d0                	callq  *%rax
}
  8033c1:	c9                   	leaveq 
  8033c2:	c3                   	retq   

00000000008033c3 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033c3:	55                   	push   %rbp
  8033c4:	48 89 e5             	mov    %rsp,%rbp
  8033c7:	48 83 ec 20          	sub    $0x20,%rsp
  8033cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033db:	89 c2                	mov    %eax,%edx
  8033dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033e1:	8b 40 0c             	mov    0xc(%rax),%eax
  8033e4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8033e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8033ed:	89 c7                	mov    %eax,%edi
  8033ef:	48 b8 bd 37 80 00 00 	movabs $0x8037bd,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
}
  8033fb:	c9                   	leaveq 
  8033fc:	c3                   	retq   

00000000008033fd <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8033fd:	55                   	push   %rbp
  8033fe:	48 89 e5             	mov    %rsp,%rbp
  803401:	48 83 ec 10          	sub    $0x10,%rsp
  803405:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803409:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80340d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803411:	48 be 1b 4d 80 00 00 	movabs $0x804d1b,%rsi
  803418:	00 00 00 
  80341b:	48 89 c7             	mov    %rax,%rdi
  80341e:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
	return 0;
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342f:	c9                   	leaveq 
  803430:	c3                   	retq   

0000000000803431 <socket>:

int
socket(int domain, int type, int protocol)
{
  803431:	55                   	push   %rbp
  803432:	48 89 e5             	mov    %rsp,%rbp
  803435:	48 83 ec 20          	sub    $0x20,%rsp
  803439:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80343c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80343f:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803442:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803445:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803448:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80344b:	89 ce                	mov    %ecx,%esi
  80344d:	89 c7                	mov    %eax,%edi
  80344f:	48 b8 75 38 80 00 00 	movabs $0x803875,%rax
  803456:	00 00 00 
  803459:	ff d0                	callq  *%rax
  80345b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803462:	79 05                	jns    803469 <socket+0x38>
		return r;
  803464:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803467:	eb 11                	jmp    80347a <socket+0x49>
	return alloc_sockfd(r);
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346c:	89 c7                	mov    %eax,%edi
  80346e:	48 b8 13 31 80 00 00 	movabs $0x803113,%rax
  803475:	00 00 00 
  803478:	ff d0                	callq  *%rax
}
  80347a:	c9                   	leaveq 
  80347b:	c3                   	retq   

000000000080347c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80347c:	55                   	push   %rbp
  80347d:	48 89 e5             	mov    %rsp,%rbp
  803480:	48 83 ec 10          	sub    $0x10,%rsp
  803484:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803487:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80348e:	00 00 00 
  803491:	8b 00                	mov    (%rax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	75 1d                	jne    8034b4 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803497:	bf 02 00 00 00       	mov    $0x2,%edi
  80349c:	48 b8 17 44 80 00 00 	movabs $0x804417,%rax
  8034a3:	00 00 00 
  8034a6:	ff d0                	callq  *%rax
  8034a8:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  8034af:	00 00 00 
  8034b2:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8034b4:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  8034bb:	00 00 00 
  8034be:	8b 00                	mov    (%rax),%eax
  8034c0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8034c3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8034c8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8034cf:	00 00 00 
  8034d2:	89 c7                	mov    %eax,%edi
  8034d4:	48 b8 54 43 80 00 00 	movabs $0x804354,%rax
  8034db:	00 00 00 
  8034de:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8034e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e5:	be 00 00 00 00       	mov    $0x0,%esi
  8034ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8034ef:	48 b8 94 42 80 00 00 	movabs $0x804294,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
}
  8034fb:	c9                   	leaveq 
  8034fc:	c3                   	retq   

00000000008034fd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034fd:	55                   	push   %rbp
  8034fe:	48 89 e5             	mov    %rsp,%rbp
  803501:	48 83 ec 30          	sub    $0x30,%rsp
  803505:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803508:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80350c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803510:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803517:	00 00 00 
  80351a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80351d:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80351f:	bf 01 00 00 00       	mov    $0x1,%edi
  803524:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
  803530:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803533:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803537:	78 3e                	js     803577 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803539:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803540:	00 00 00 
  803543:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354b:	8b 40 10             	mov    0x10(%rax),%eax
  80354e:	89 c2                	mov    %eax,%edx
  803550:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803558:	48 89 ce             	mov    %rcx,%rsi
  80355b:	48 89 c7             	mov    %rax,%rdi
  80355e:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  803565:	00 00 00 
  803568:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	8b 50 10             	mov    0x10(%rax),%edx
  803571:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803575:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803577:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80357a:	c9                   	leaveq 
  80357b:	c3                   	retq   

000000000080357c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80357c:	55                   	push   %rbp
  80357d:	48 89 e5             	mov    %rsp,%rbp
  803580:	48 83 ec 10          	sub    $0x10,%rsp
  803584:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803587:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80358b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80358e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803595:	00 00 00 
  803598:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80359b:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80359d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035a4:	48 89 c6             	mov    %rax,%rsi
  8035a7:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8035ae:	00 00 00 
  8035b1:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  8035b8:	00 00 00 
  8035bb:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8035bd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035c4:	00 00 00 
  8035c7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035ca:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8035cd:	bf 02 00 00 00       	mov    $0x2,%edi
  8035d2:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
}
  8035de:	c9                   	leaveq 
  8035df:	c3                   	retq   

00000000008035e0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8035e0:	55                   	push   %rbp
  8035e1:	48 89 e5             	mov    %rsp,%rbp
  8035e4:	48 83 ec 10          	sub    $0x10,%rsp
  8035e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035eb:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8035ee:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035f5:	00 00 00 
  8035f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035fb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8035fd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803604:	00 00 00 
  803607:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80360a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80360d:	bf 03 00 00 00       	mov    $0x3,%edi
  803612:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803619:	00 00 00 
  80361c:	ff d0                	callq  *%rax
}
  80361e:	c9                   	leaveq 
  80361f:	c3                   	retq   

0000000000803620 <nsipc_close>:

int
nsipc_close(int s)
{
  803620:	55                   	push   %rbp
  803621:	48 89 e5             	mov    %rsp,%rbp
  803624:	48 83 ec 10          	sub    $0x10,%rsp
  803628:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80362b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803632:	00 00 00 
  803635:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803638:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80363a:	bf 04 00 00 00       	mov    $0x4,%edi
  80363f:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803646:	00 00 00 
  803649:	ff d0                	callq  *%rax
}
  80364b:	c9                   	leaveq 
  80364c:	c3                   	retq   

000000000080364d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80364d:	55                   	push   %rbp
  80364e:	48 89 e5             	mov    %rsp,%rbp
  803651:	48 83 ec 10          	sub    $0x10,%rsp
  803655:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803658:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80365c:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80365f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803666:	00 00 00 
  803669:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80366c:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80366e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803675:	48 89 c6             	mov    %rax,%rsi
  803678:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80367f:	00 00 00 
  803682:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  803689:	00 00 00 
  80368c:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80368e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803695:	00 00 00 
  803698:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80369b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80369e:	bf 05 00 00 00       	mov    $0x5,%edi
  8036a3:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8036aa:	00 00 00 
  8036ad:	ff d0                	callq  *%rax
}
  8036af:	c9                   	leaveq 
  8036b0:	c3                   	retq   

00000000008036b1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8036b1:	55                   	push   %rbp
  8036b2:	48 89 e5             	mov    %rsp,%rbp
  8036b5:	48 83 ec 10          	sub    $0x10,%rsp
  8036b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8036bc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8036bf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036c6:	00 00 00 
  8036c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036cc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8036ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036d5:	00 00 00 
  8036d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8036db:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8036de:	bf 06 00 00 00       	mov    $0x6,%edi
  8036e3:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8036ea:	00 00 00 
  8036ed:	ff d0                	callq  *%rax
}
  8036ef:	c9                   	leaveq 
  8036f0:	c3                   	retq   

00000000008036f1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8036f1:	55                   	push   %rbp
  8036f2:	48 89 e5             	mov    %rsp,%rbp
  8036f5:	48 83 ec 30          	sub    $0x30,%rsp
  8036f9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803700:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803703:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803706:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80370d:	00 00 00 
  803710:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803713:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803715:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80371c:	00 00 00 
  80371f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803722:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803725:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80372c:	00 00 00 
  80372f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803732:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803735:	bf 07 00 00 00       	mov    $0x7,%edi
  80373a:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803749:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374d:	78 69                	js     8037b8 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80374f:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803756:	7f 08                	jg     803760 <nsipc_recv+0x6f>
  803758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375b:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80375e:	7e 35                	jle    803795 <nsipc_recv+0xa4>
  803760:	48 b9 22 4d 80 00 00 	movabs $0x804d22,%rcx
  803767:	00 00 00 
  80376a:	48 ba 37 4d 80 00 00 	movabs $0x804d37,%rdx
  803771:	00 00 00 
  803774:	be 61 00 00 00       	mov    $0x61,%esi
  803779:	48 bf 4c 4d 80 00 00 	movabs $0x804d4c,%rdi
  803780:	00 00 00 
  803783:	b8 00 00 00 00       	mov    $0x0,%eax
  803788:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  80378f:	00 00 00 
  803792:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803795:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803798:	48 63 d0             	movslq %eax,%rdx
  80379b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80379f:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8037a6:	00 00 00 
  8037a9:	48 89 c7             	mov    %rax,%rdi
  8037ac:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
	}

	return r;
  8037b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037bb:	c9                   	leaveq 
  8037bc:	c3                   	retq   

00000000008037bd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037bd:	55                   	push   %rbp
  8037be:	48 89 e5             	mov    %rsp,%rbp
  8037c1:	48 83 ec 20          	sub    $0x20,%rsp
  8037c5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037cc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8037cf:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8037d2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037d9:	00 00 00 
  8037dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037df:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8037e1:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8037e8:	7e 35                	jle    80381f <nsipc_send+0x62>
  8037ea:	48 b9 58 4d 80 00 00 	movabs $0x804d58,%rcx
  8037f1:	00 00 00 
  8037f4:	48 ba 37 4d 80 00 00 	movabs $0x804d37,%rdx
  8037fb:	00 00 00 
  8037fe:	be 6c 00 00 00       	mov    $0x6c,%esi
  803803:	48 bf 4c 4d 80 00 00 	movabs $0x804d4c,%rdi
  80380a:	00 00 00 
  80380d:	b8 00 00 00 00       	mov    $0x0,%eax
  803812:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  803819:	00 00 00 
  80381c:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80381f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803822:	48 63 d0             	movslq %eax,%rdx
  803825:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803829:	48 89 c6             	mov    %rax,%rsi
  80382c:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803833:	00 00 00 
  803836:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  80383d:	00 00 00 
  803840:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803842:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803849:	00 00 00 
  80384c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80384f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803852:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803859:	00 00 00 
  80385c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80385f:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803862:	bf 08 00 00 00       	mov    $0x8,%edi
  803867:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 10          	sub    $0x10,%rsp
  80387d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803880:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803883:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803886:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80388d:	00 00 00 
  803890:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803893:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803895:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80389c:	00 00 00 
  80389f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038a2:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8038a5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ac:	00 00 00 
  8038af:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8038b2:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8038b5:	bf 09 00 00 00       	mov    $0x9,%edi
  8038ba:	48 b8 7c 34 80 00 00 	movabs $0x80347c,%rax
  8038c1:	00 00 00 
  8038c4:	ff d0                	callq  *%rax
}
  8038c6:	c9                   	leaveq 
  8038c7:	c3                   	retq   

00000000008038c8 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8038c8:	55                   	push   %rbp
  8038c9:	48 89 e5             	mov    %rsp,%rbp
  8038cc:	53                   	push   %rbx
  8038cd:	48 83 ec 38          	sub    $0x38,%rsp
  8038d1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8038d5:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8038d9:	48 89 c7             	mov    %rax,%rdi
  8038dc:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  8038e3:	00 00 00 
  8038e6:	ff d0                	callq  *%rax
  8038e8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8038eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038ef:	0f 88 bf 01 00 00    	js     803ab4 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038f9:	ba 07 04 00 00       	mov    $0x407,%edx
  8038fe:	48 89 c6             	mov    %rax,%rsi
  803901:	bf 00 00 00 00       	mov    $0x0,%edi
  803906:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
  803912:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803915:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803919:	0f 88 95 01 00 00    	js     803ab4 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80391f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803923:	48 89 c7             	mov    %rax,%rdi
  803926:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  80392d:	00 00 00 
  803930:	ff d0                	callq  *%rax
  803932:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803935:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803939:	0f 88 5d 01 00 00    	js     803a9c <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80393f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803943:	ba 07 04 00 00       	mov    $0x407,%edx
  803948:	48 89 c6             	mov    %rax,%rsi
  80394b:	bf 00 00 00 00       	mov    $0x0,%edi
  803950:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
  80395c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80395f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803963:	0f 88 33 01 00 00    	js     803a9c <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80396d:	48 89 c7             	mov    %rax,%rdi
  803970:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803977:	00 00 00 
  80397a:	ff d0                	callq  *%rax
  80397c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803980:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803984:	ba 07 04 00 00       	mov    $0x407,%edx
  803989:	48 89 c6             	mov    %rax,%rsi
  80398c:	bf 00 00 00 00       	mov    $0x0,%edi
  803991:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
  80399d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a4:	0f 88 d9 00 00 00    	js     803a83 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039ae:	48 89 c7             	mov    %rax,%rdi
  8039b1:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  8039b8:	00 00 00 
  8039bb:	ff d0                	callq  *%rax
  8039bd:	48 89 c2             	mov    %rax,%rdx
  8039c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8039ca:	48 89 d1             	mov    %rdx,%rcx
  8039cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8039d2:	48 89 c6             	mov    %rax,%rsi
  8039d5:	bf 00 00 00 00       	mov    $0x0,%edi
  8039da:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
  8039e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039ed:	78 79                	js     803a68 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8039ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8039fa:	00 00 00 
  8039fd:	8b 12                	mov    (%rdx),%edx
  8039ff:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803a01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803a0c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a10:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803a17:	00 00 00 
  803a1a:	8b 12                	mov    (%rdx),%edx
  803a1c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803a1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a22:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	48 89 c7             	mov    %rax,%rdi
  803a30:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
  803a3c:	89 c2                	mov    %eax,%edx
  803a3e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a42:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803a44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803a48:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803a4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a50:	48 89 c7             	mov    %rax,%rdi
  803a53:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  803a5a:	00 00 00 
  803a5d:	ff d0                	callq  *%rax
  803a5f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803a61:	b8 00 00 00 00       	mov    $0x0,%eax
  803a66:	eb 4f                	jmp    803ab7 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803a68:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803a69:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a6d:	48 89 c6             	mov    %rax,%rsi
  803a70:	bf 00 00 00 00       	mov    $0x0,%edi
  803a75:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  803a7c:	00 00 00 
  803a7f:	ff d0                	callq  *%rax
  803a81:	eb 01                	jmp    803a84 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803a83:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803a84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a88:	48 89 c6             	mov    %rax,%rsi
  803a8b:	bf 00 00 00 00       	mov    $0x0,%edi
  803a90:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803a9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aa0:	48 89 c6             	mov    %rax,%rsi
  803aa3:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa8:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  803aaf:	00 00 00 
  803ab2:	ff d0                	callq  *%rax
    err:
	return r;
  803ab4:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803ab7:	48 83 c4 38          	add    $0x38,%rsp
  803abb:	5b                   	pop    %rbx
  803abc:	5d                   	pop    %rbp
  803abd:	c3                   	retq   

0000000000803abe <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803abe:	55                   	push   %rbp
  803abf:	48 89 e5             	mov    %rsp,%rbp
  803ac2:	53                   	push   %rbx
  803ac3:	48 83 ec 28          	sub    $0x28,%rsp
  803ac7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803acb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803acf:	eb 01                	jmp    803ad2 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803ad1:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ad2:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803ad9:	00 00 00 
  803adc:	48 8b 00             	mov    (%rax),%rax
  803adf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803ae5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803ae8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803aec:	48 89 c7             	mov    %rax,%rdi
  803aef:	48 b8 9c 44 80 00 00 	movabs $0x80449c,%rax
  803af6:	00 00 00 
  803af9:	ff d0                	callq  *%rax
  803afb:	89 c3                	mov    %eax,%ebx
  803afd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b01:	48 89 c7             	mov    %rax,%rdi
  803b04:	48 b8 9c 44 80 00 00 	movabs $0x80449c,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
  803b10:	39 c3                	cmp    %eax,%ebx
  803b12:	0f 94 c0             	sete   %al
  803b15:	0f b6 c0             	movzbl %al,%eax
  803b18:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803b1b:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803b22:	00 00 00 
  803b25:	48 8b 00             	mov    (%rax),%rax
  803b28:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b2e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803b31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b34:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b37:	75 0a                	jne    803b43 <_pipeisclosed+0x85>
			return ret;
  803b39:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803b3c:	48 83 c4 28          	add    $0x28,%rsp
  803b40:	5b                   	pop    %rbx
  803b41:	5d                   	pop    %rbp
  803b42:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803b43:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b46:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803b49:	74 86                	je     803ad1 <_pipeisclosed+0x13>
  803b4b:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803b4f:	75 80                	jne    803ad1 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803b51:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  803b58:	00 00 00 
  803b5b:	48 8b 00             	mov    (%rax),%rax
  803b5e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803b64:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b6a:	89 c6                	mov    %eax,%esi
  803b6c:	48 bf 69 4d 80 00 00 	movabs $0x804d69,%rdi
  803b73:	00 00 00 
  803b76:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7b:	49 b8 bb 04 80 00 00 	movabs $0x8004bb,%r8
  803b82:	00 00 00 
  803b85:	41 ff d0             	callq  *%r8
	}
  803b88:	e9 44 ff ff ff       	jmpq   803ad1 <_pipeisclosed+0x13>

0000000000803b8d <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803b8d:	55                   	push   %rbp
  803b8e:	48 89 e5             	mov    %rsp,%rbp
  803b91:	48 83 ec 30          	sub    $0x30,%rsp
  803b95:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b98:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b9f:	48 89 d6             	mov    %rdx,%rsi
  803ba2:	89 c7                	mov    %eax,%edi
  803ba4:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
  803bb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bb7:	79 05                	jns    803bbe <pipeisclosed+0x31>
		return r;
  803bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bbc:	eb 31                	jmp    803bef <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bc2:	48 89 c7             	mov    %rax,%rdi
  803bc5:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
  803bd1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bdd:	48 89 d6             	mov    %rdx,%rsi
  803be0:	48 89 c7             	mov    %rax,%rdi
  803be3:	48 b8 be 3a 80 00 00 	movabs $0x803abe,%rax
  803bea:	00 00 00 
  803bed:	ff d0                	callq  *%rax
}
  803bef:	c9                   	leaveq 
  803bf0:	c3                   	retq   

0000000000803bf1 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803bf1:	55                   	push   %rbp
  803bf2:	48 89 e5             	mov    %rsp,%rbp
  803bf5:	48 83 ec 40          	sub    $0x40,%rsp
  803bf9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803bfd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c01:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803c05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c09:	48 89 c7             	mov    %rax,%rdi
  803c0c:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
  803c18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803c1c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c20:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803c24:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803c2b:	00 
  803c2c:	e9 97 00 00 00       	jmpq   803cc8 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803c31:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803c36:	74 09                	je     803c41 <devpipe_read+0x50>
				return i;
  803c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c3c:	e9 95 00 00 00       	jmpq   803cd6 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803c41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c49:	48 89 d6             	mov    %rdx,%rsi
  803c4c:	48 89 c7             	mov    %rax,%rdi
  803c4f:	48 b8 be 3a 80 00 00 	movabs $0x803abe,%rax
  803c56:	00 00 00 
  803c59:	ff d0                	callq  *%rax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	74 07                	je     803c66 <devpipe_read+0x75>
				return 0;
  803c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803c64:	eb 70                	jmp    803cd6 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803c66:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  803c6d:	00 00 00 
  803c70:	ff d0                	callq  *%rax
  803c72:	eb 01                	jmp    803c75 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803c74:	90                   	nop
  803c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c79:	8b 10                	mov    (%rax),%edx
  803c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c7f:	8b 40 04             	mov    0x4(%rax),%eax
  803c82:	39 c2                	cmp    %eax,%edx
  803c84:	74 ab                	je     803c31 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803c86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803c8e:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803c92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c96:	8b 00                	mov    (%rax),%eax
  803c98:	89 c2                	mov    %eax,%edx
  803c9a:	c1 fa 1f             	sar    $0x1f,%edx
  803c9d:	c1 ea 1b             	shr    $0x1b,%edx
  803ca0:	01 d0                	add    %edx,%eax
  803ca2:	83 e0 1f             	and    $0x1f,%eax
  803ca5:	29 d0                	sub    %edx,%eax
  803ca7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cab:	48 98                	cltq   
  803cad:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803cb2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb8:	8b 00                	mov    (%rax),%eax
  803cba:	8d 50 01             	lea    0x1(%rax),%edx
  803cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc1:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803cc3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803cc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ccc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803cd0:	72 a2                	jb     803c74 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803cd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803cd6:	c9                   	leaveq 
  803cd7:	c3                   	retq   

0000000000803cd8 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803cd8:	55                   	push   %rbp
  803cd9:	48 89 e5             	mov    %rsp,%rbp
  803cdc:	48 83 ec 40          	sub    $0x40,%rsp
  803ce0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ce4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ce8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803cec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cf0:	48 89 c7             	mov    %rax,%rdi
  803cf3:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803cfa:	00 00 00 
  803cfd:	ff d0                	callq  *%rax
  803cff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d0b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d12:	00 
  803d13:	e9 93 00 00 00       	jmpq   803dab <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d20:	48 89 d6             	mov    %rdx,%rsi
  803d23:	48 89 c7             	mov    %rax,%rdi
  803d26:	48 b8 be 3a 80 00 00 	movabs $0x803abe,%rax
  803d2d:	00 00 00 
  803d30:	ff d0                	callq  *%rax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	74 07                	je     803d3d <devpipe_write+0x65>
				return 0;
  803d36:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3b:	eb 7c                	jmp    803db9 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d3d:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  803d44:	00 00 00 
  803d47:	ff d0                	callq  *%rax
  803d49:	eb 01                	jmp    803d4c <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d4b:	90                   	nop
  803d4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d50:	8b 40 04             	mov    0x4(%rax),%eax
  803d53:	48 63 d0             	movslq %eax,%rdx
  803d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5a:	8b 00                	mov    (%rax),%eax
  803d5c:	48 98                	cltq   
  803d5e:	48 83 c0 20          	add    $0x20,%rax
  803d62:	48 39 c2             	cmp    %rax,%rdx
  803d65:	73 b1                	jae    803d18 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6b:	8b 40 04             	mov    0x4(%rax),%eax
  803d6e:	89 c2                	mov    %eax,%edx
  803d70:	c1 fa 1f             	sar    $0x1f,%edx
  803d73:	c1 ea 1b             	shr    $0x1b,%edx
  803d76:	01 d0                	add    %edx,%eax
  803d78:	83 e0 1f             	and    $0x1f,%eax
  803d7b:	29 d0                	sub    %edx,%eax
  803d7d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803d81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803d85:	48 01 ca             	add    %rcx,%rdx
  803d88:	0f b6 0a             	movzbl (%rdx),%ecx
  803d8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d8f:	48 98                	cltq   
  803d91:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d99:	8b 40 04             	mov    0x4(%rax),%eax
  803d9c:	8d 50 01             	lea    0x1(%rax),%edx
  803d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da3:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803da6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803dab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803daf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803db3:	72 96                	jb     803d4b <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803db5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803db9:	c9                   	leaveq 
  803dba:	c3                   	retq   

0000000000803dbb <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803dbb:	55                   	push   %rbp
  803dbc:	48 89 e5             	mov    %rsp,%rbp
  803dbf:	48 83 ec 20          	sub    $0x20,%rsp
  803dc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803dc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803dcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dcf:	48 89 c7             	mov    %rax,%rdi
  803dd2:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803dd9:	00 00 00 
  803ddc:	ff d0                	callq  *%rax
  803dde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803de2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de6:	48 be 7c 4d 80 00 00 	movabs $0x804d7c,%rsi
  803ded:	00 00 00 
  803df0:	48 89 c7             	mov    %rax,%rdi
  803df3:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  803dfa:	00 00 00 
  803dfd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e03:	8b 50 04             	mov    0x4(%rax),%edx
  803e06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0a:	8b 00                	mov    (%rax),%eax
  803e0c:	29 c2                	sub    %eax,%edx
  803e0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e12:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803e18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e1c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803e23:	00 00 00 
	stat->st_dev = &devpipe;
  803e26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e2a:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e31:	00 00 00 
  803e34:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e40:	c9                   	leaveq 
  803e41:	c3                   	retq   

0000000000803e42 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803e42:	55                   	push   %rbp
  803e43:	48 89 e5             	mov    %rsp,%rbp
  803e46:	48 83 ec 10          	sub    $0x10,%rsp
  803e4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e52:	48 89 c6             	mov    %rax,%rsi
  803e55:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5a:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  803e61:	00 00 00 
  803e64:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803e66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e6a:	48 89 c7             	mov    %rax,%rdi
  803e6d:	48 b8 d7 23 80 00 00 	movabs $0x8023d7,%rax
  803e74:	00 00 00 
  803e77:	ff d0                	callq  *%rax
  803e79:	48 89 c6             	mov    %rax,%rsi
  803e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  803e81:	48 b8 5b 1a 80 00 00 	movabs $0x801a5b,%rax
  803e88:	00 00 00 
  803e8b:	ff d0                	callq  *%rax
}
  803e8d:	c9                   	leaveq 
  803e8e:	c3                   	retq   
	...

0000000000803e90 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803e90:	55                   	push   %rbp
  803e91:	48 89 e5             	mov    %rsp,%rbp
  803e94:	48 83 ec 20          	sub    $0x20,%rsp
  803e98:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803e9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ea1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ea5:	be 01 00 00 00       	mov    $0x1,%esi
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
}
  803eb9:	c9                   	leaveq 
  803eba:	c3                   	retq   

0000000000803ebb <getchar>:

int
getchar(void)
{
  803ebb:	55                   	push   %rbp
  803ebc:	48 89 e5             	mov    %rsp,%rbp
  803ebf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ec3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803ec7:	ba 01 00 00 00       	mov    $0x1,%edx
  803ecc:	48 89 c6             	mov    %rax,%rsi
  803ecf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed4:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  803edb:	00 00 00 
  803ede:	ff d0                	callq  *%rax
  803ee0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803ee3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee7:	79 05                	jns    803eee <getchar+0x33>
		return r;
  803ee9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eec:	eb 14                	jmp    803f02 <getchar+0x47>
	if (r < 1)
  803eee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ef2:	7f 07                	jg     803efb <getchar+0x40>
		return -E_EOF;
  803ef4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803ef9:	eb 07                	jmp    803f02 <getchar+0x47>
	return c;
  803efb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803eff:	0f b6 c0             	movzbl %al,%eax
}
  803f02:	c9                   	leaveq 
  803f03:	c3                   	retq   

0000000000803f04 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803f04:	55                   	push   %rbp
  803f05:	48 89 e5             	mov    %rsp,%rbp
  803f08:	48 83 ec 20          	sub    $0x20,%rsp
  803f0c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803f0f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f16:	48 89 d6             	mov    %rdx,%rsi
  803f19:	89 c7                	mov    %eax,%edi
  803f1b:	48 b8 9a 24 80 00 00 	movabs $0x80249a,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
  803f27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2e:	79 05                	jns    803f35 <iscons+0x31>
		return r;
  803f30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f33:	eb 1a                	jmp    803f4f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f39:	8b 10                	mov    (%rax),%edx
  803f3b:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803f42:	00 00 00 
  803f45:	8b 00                	mov    (%rax),%eax
  803f47:	39 c2                	cmp    %eax,%edx
  803f49:	0f 94 c0             	sete   %al
  803f4c:	0f b6 c0             	movzbl %al,%eax
}
  803f4f:	c9                   	leaveq 
  803f50:	c3                   	retq   

0000000000803f51 <opencons>:

int
opencons(void)
{
  803f51:	55                   	push   %rbp
  803f52:	48 89 e5             	mov    %rsp,%rbp
  803f55:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803f59:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f5d:	48 89 c7             	mov    %rax,%rdi
  803f60:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  803f67:	00 00 00 
  803f6a:	ff d0                	callq  *%rax
  803f6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f73:	79 05                	jns    803f7a <opencons+0x29>
		return r;
  803f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f78:	eb 5b                	jmp    803fd5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803f7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f7e:	ba 07 04 00 00       	mov    $0x407,%edx
  803f83:	48 89 c6             	mov    %rax,%rsi
  803f86:	bf 00 00 00 00       	mov    $0x0,%edi
  803f8b:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  803f92:	00 00 00 
  803f95:	ff d0                	callq  *%rax
  803f97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f9e:	79 05                	jns    803fa5 <opencons+0x54>
		return r;
  803fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa3:	eb 30                	jmp    803fd5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803fa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fa9:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803fb0:	00 00 00 
  803fb3:	8b 12                	mov    (%rdx),%edx
  803fb5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc6:	48 89 c7             	mov    %rax,%rdi
  803fc9:	48 b8 b4 23 80 00 00 	movabs $0x8023b4,%rax
  803fd0:	00 00 00 
  803fd3:	ff d0                	callq  *%rax
}
  803fd5:	c9                   	leaveq 
  803fd6:	c3                   	retq   

0000000000803fd7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803fd7:	55                   	push   %rbp
  803fd8:	48 89 e5             	mov    %rsp,%rbp
  803fdb:	48 83 ec 30          	sub    $0x30,%rsp
  803fdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fe3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803fe7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803feb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803ff0:	75 13                	jne    804005 <devcons_read+0x2e>
		return 0;
  803ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff7:	eb 49                	jmp    804042 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803ff9:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  804000:	00 00 00 
  804003:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804005:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80400c:	00 00 00 
  80400f:	ff d0                	callq  *%rax
  804011:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804014:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804018:	74 df                	je     803ff9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80401a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401e:	79 05                	jns    804025 <devcons_read+0x4e>
		return c;
  804020:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804023:	eb 1d                	jmp    804042 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804025:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804029:	75 07                	jne    804032 <devcons_read+0x5b>
		return 0;
  80402b:	b8 00 00 00 00       	mov    $0x0,%eax
  804030:	eb 10                	jmp    804042 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804035:	89 c2                	mov    %eax,%edx
  804037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403b:	88 10                	mov    %dl,(%rax)
	return 1;
  80403d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804042:	c9                   	leaveq 
  804043:	c3                   	retq   

0000000000804044 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804044:	55                   	push   %rbp
  804045:	48 89 e5             	mov    %rsp,%rbp
  804048:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80404f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804056:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80405d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80406b:	eb 77                	jmp    8040e4 <devcons_write+0xa0>
		m = n - tot;
  80406d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804074:	89 c2                	mov    %eax,%edx
  804076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804079:	89 d1                	mov    %edx,%ecx
  80407b:	29 c1                	sub    %eax,%ecx
  80407d:	89 c8                	mov    %ecx,%eax
  80407f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804082:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804085:	83 f8 7f             	cmp    $0x7f,%eax
  804088:	76 07                	jbe    804091 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80408a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804091:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804094:	48 63 d0             	movslq %eax,%rdx
  804097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409a:	48 98                	cltq   
  80409c:	48 89 c1             	mov    %rax,%rcx
  80409f:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8040a6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040ad:	48 89 ce             	mov    %rcx,%rsi
  8040b0:	48 89 c7             	mov    %rax,%rdi
  8040b3:	48 b8 9a 13 80 00 00 	movabs $0x80139a,%rax
  8040ba:	00 00 00 
  8040bd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8040bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040c2:	48 63 d0             	movslq %eax,%rdx
  8040c5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8040cc:	48 89 d6             	mov    %rdx,%rsi
  8040cf:	48 89 c7             	mov    %rax,%rdi
  8040d2:	48 b8 68 18 80 00 00 	movabs $0x801868,%rax
  8040d9:	00 00 00 
  8040dc:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040e1:	01 45 fc             	add    %eax,-0x4(%rbp)
  8040e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e7:	48 98                	cltq   
  8040e9:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8040f0:	0f 82 77 ff ff ff    	jb     80406d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8040f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8040f9:	c9                   	leaveq 
  8040fa:	c3                   	retq   

00000000008040fb <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8040fb:	55                   	push   %rbp
  8040fc:	48 89 e5             	mov    %rsp,%rbp
  8040ff:	48 83 ec 08          	sub    $0x8,%rsp
  804103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80410c:	c9                   	leaveq 
  80410d:	c3                   	retq   

000000000080410e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80410e:	55                   	push   %rbp
  80410f:	48 89 e5             	mov    %rsp,%rbp
  804112:	48 83 ec 10          	sub    $0x10,%rsp
  804116:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80411a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80411e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804122:	48 be 88 4d 80 00 00 	movabs $0x804d88,%rsi
  804129:	00 00 00 
  80412c:	48 89 c7             	mov    %rax,%rdi
  80412f:	48 b8 78 10 80 00 00 	movabs $0x801078,%rax
  804136:	00 00 00 
  804139:	ff d0                	callq  *%rax
	return 0;
  80413b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804140:	c9                   	leaveq 
  804141:	c3                   	retq   
	...

0000000000804144 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804144:	55                   	push   %rbp
  804145:	48 89 e5             	mov    %rsp,%rbp
  804148:	48 83 ec 20          	sub    $0x20,%rsp
  80414c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804150:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804157:	00 00 00 
  80415a:	48 8b 00             	mov    (%rax),%rax
  80415d:	48 85 c0             	test   %rax,%rax
  804160:	0f 85 8e 00 00 00    	jne    8041f4 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  804166:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  80416d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  804174:	48 b8 34 19 80 00 00 	movabs $0x801934,%rax
  80417b:	00 00 00 
  80417e:	ff d0                	callq  *%rax
  804180:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  804183:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804187:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80418a:	ba 07 00 00 00       	mov    $0x7,%edx
  80418f:	48 89 ce             	mov    %rcx,%rsi
  804192:	89 c7                	mov    %eax,%edi
  804194:	48 b8 b0 19 80 00 00 	movabs $0x8019b0,%rax
  80419b:	00 00 00 
  80419e:	ff d0                	callq  *%rax
  8041a0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  8041a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8041a7:	74 30                	je     8041d9 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8041a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8041ac:	89 c1                	mov    %eax,%ecx
  8041ae:	48 ba 90 4d 80 00 00 	movabs $0x804d90,%rdx
  8041b5:	00 00 00 
  8041b8:	be 24 00 00 00       	mov    $0x24,%esi
  8041bd:	48 bf c7 4d 80 00 00 	movabs $0x804dc7,%rdi
  8041c4:	00 00 00 
  8041c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041cc:	49 b8 80 02 80 00 00 	movabs $0x800280,%r8
  8041d3:	00 00 00 
  8041d6:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8041d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041dc:	48 be 08 42 80 00 00 	movabs $0x804208,%rsi
  8041e3:	00 00 00 
  8041e6:	89 c7                	mov    %eax,%edi
  8041e8:	48 b8 3a 1b 80 00 00 	movabs $0x801b3a,%rax
  8041ef:	00 00 00 
  8041f2:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8041f4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041fb:	00 00 00 
  8041fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804202:	48 89 10             	mov    %rdx,(%rax)
}
  804205:	c9                   	leaveq 
  804206:	c3                   	retq   
	...

0000000000804208 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804208:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80420b:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804212:	00 00 00 
	call *%rax
  804215:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  804217:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  80421b:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80421f:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  804222:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804229:	00 
		movq 120(%rsp), %rcx				// trap time rip
  80422a:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  80422f:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  804232:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  804233:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  804236:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  80423d:	00 08 
		POPA_						// copy the register contents to the registers
  80423f:	4c 8b 3c 24          	mov    (%rsp),%r15
  804243:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804248:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80424d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804252:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804257:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80425c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804261:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804266:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80426b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804270:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804275:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80427a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80427f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804284:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804289:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  80428d:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804291:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804292:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804293:	c3                   	retq   

0000000000804294 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804294:	55                   	push   %rbp
  804295:	48 89 e5             	mov    %rsp,%rbp
  804298:	48 83 ec 30          	sub    $0x30,%rsp
  80429c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8042a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8042a8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8042ad:	74 18                	je     8042c7 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8042af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042b3:	48 89 c7             	mov    %rax,%rdi
  8042b6:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  8042bd:	00 00 00 
  8042c0:	ff d0                	callq  *%rax
  8042c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c5:	eb 19                	jmp    8042e0 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8042c7:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8042ce:	00 00 00 
  8042d1:	48 b8 d9 1b 80 00 00 	movabs $0x801bd9,%rax
  8042d8:	00 00 00 
  8042db:	ff d0                	callq  *%rax
  8042dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8042e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e4:	79 19                	jns    8042ff <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8042e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8042f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8042fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042fd:	eb 53                	jmp    804352 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8042ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804304:	74 19                	je     80431f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  804306:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80430d:	00 00 00 
  804310:	48 8b 00             	mov    (%rax),%rax
  804313:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804319:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80431d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80431f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804324:	74 19                	je     80433f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  804326:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  80432d:	00 00 00 
  804330:	48 8b 00             	mov    (%rax),%rax
  804333:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804339:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80433d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80433f:	48 b8 50 70 80 00 00 	movabs $0x807050,%rax
  804346:	00 00 00 
  804349:	48 8b 00             	mov    (%rax),%rax
  80434c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  804352:	c9                   	leaveq 
  804353:	c3                   	retq   

0000000000804354 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804354:	55                   	push   %rbp
  804355:	48 89 e5             	mov    %rsp,%rbp
  804358:	48 83 ec 30          	sub    $0x30,%rsp
  80435c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80435f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804362:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804366:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804369:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804370:	e9 96 00 00 00       	jmpq   80440b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  804375:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80437a:	74 20                	je     80439c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  80437c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80437f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804382:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804386:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804389:	89 c7                	mov    %eax,%edi
  80438b:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  804392:	00 00 00 
  804395:	ff d0                	callq  *%rax
  804397:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80439a:	eb 2d                	jmp    8043c9 <ipc_send+0x75>
		else if(pg==NULL)
  80439c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043a1:	75 26                	jne    8043c9 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8043a3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8043a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8043ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043b5:	00 00 00 
  8043b8:	89 c7                	mov    %eax,%edi
  8043ba:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8043c1:	00 00 00 
  8043c4:	ff d0                	callq  *%rax
  8043c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8043c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043cd:	79 30                	jns    8043ff <ipc_send+0xab>
  8043cf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8043d3:	74 2a                	je     8043ff <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8043d5:	48 ba d5 4d 80 00 00 	movabs $0x804dd5,%rdx
  8043dc:	00 00 00 
  8043df:	be 40 00 00 00       	mov    $0x40,%esi
  8043e4:	48 bf ed 4d 80 00 00 	movabs $0x804ded,%rdi
  8043eb:	00 00 00 
  8043ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f3:	48 b9 80 02 80 00 00 	movabs $0x800280,%rcx
  8043fa:	00 00 00 
  8043fd:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8043ff:	48 b8 72 19 80 00 00 	movabs $0x801972,%rax
  804406:	00 00 00 
  804409:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80440b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80440f:	0f 85 60 ff ff ff    	jne    804375 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804415:	c9                   	leaveq 
  804416:	c3                   	retq   

0000000000804417 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804417:	55                   	push   %rbp
  804418:	48 89 e5             	mov    %rsp,%rbp
  80441b:	48 83 ec 18          	sub    $0x18,%rsp
  80441f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  804422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804429:	eb 5e                	jmp    804489 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80442b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804432:	00 00 00 
  804435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804438:	48 63 d0             	movslq %eax,%rdx
  80443b:	48 89 d0             	mov    %rdx,%rax
  80443e:	48 c1 e0 03          	shl    $0x3,%rax
  804442:	48 01 d0             	add    %rdx,%rax
  804445:	48 c1 e0 05          	shl    $0x5,%rax
  804449:	48 01 c8             	add    %rcx,%rax
  80444c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804452:	8b 00                	mov    (%rax),%eax
  804454:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804457:	75 2c                	jne    804485 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804459:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804460:	00 00 00 
  804463:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804466:	48 63 d0             	movslq %eax,%rdx
  804469:	48 89 d0             	mov    %rdx,%rax
  80446c:	48 c1 e0 03          	shl    $0x3,%rax
  804470:	48 01 d0             	add    %rdx,%rax
  804473:	48 c1 e0 05          	shl    $0x5,%rax
  804477:	48 01 c8             	add    %rcx,%rax
  80447a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804480:	8b 40 08             	mov    0x8(%rax),%eax
  804483:	eb 12                	jmp    804497 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804485:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804489:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804490:	7e 99                	jle    80442b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  804492:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804497:	c9                   	leaveq 
  804498:	c3                   	retq   
  804499:	00 00                	add    %al,(%rax)
	...

000000000080449c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80449c:	55                   	push   %rbp
  80449d:	48 89 e5             	mov    %rsp,%rbp
  8044a0:	48 83 ec 18          	sub    $0x18,%rsp
  8044a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044ac:	48 89 c2             	mov    %rax,%rdx
  8044af:	48 c1 ea 15          	shr    $0x15,%rdx
  8044b3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044ba:	01 00 00 
  8044bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044c1:	83 e0 01             	and    $0x1,%eax
  8044c4:	48 85 c0             	test   %rax,%rax
  8044c7:	75 07                	jne    8044d0 <pageref+0x34>
		return 0;
  8044c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ce:	eb 53                	jmp    804523 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044d4:	48 89 c2             	mov    %rax,%rdx
  8044d7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8044db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8044e2:	01 00 00 
  8044e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8044ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f1:	83 e0 01             	and    $0x1,%eax
  8044f4:	48 85 c0             	test   %rax,%rax
  8044f7:	75 07                	jne    804500 <pageref+0x64>
		return 0;
  8044f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044fe:	eb 23                	jmp    804523 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804504:	48 89 c2             	mov    %rax,%rdx
  804507:	48 c1 ea 0c          	shr    $0xc,%rdx
  80450b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804512:	00 00 00 
  804515:	48 c1 e2 04          	shl    $0x4,%rdx
  804519:	48 01 d0             	add    %rdx,%rax
  80451c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804520:	0f b7 c0             	movzwl %ax,%eax
}
  804523:	c9                   	leaveq 
  804524:	c3                   	retq   
