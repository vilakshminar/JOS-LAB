
obj/user/primes.debug:     file format elf64-x86-64


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
  80003c:	e8 97 01 00 00       	callq  8001d8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 10          	sub    $0x10,%rsp
  80004c:	eb 01                	jmp    80004f <primeproc+0xb>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
		panic("fork: %e", id);
	if (id == 0)
		goto top;
  80004e:	90                   	nop
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800053:	ba 00 00 00 00       	mov    $0x0,%edx
  800058:	be 00 00 00 00       	mov    $0x0,%esi
  80005d:	48 89 c7             	mov    %rax,%rdi
  800060:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  800067:	00 00 00 
  80006a:	ff d0                	callq  *%rax
  80006c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80006f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800076:	00 00 00 
  800079:	48 8b 00             	mov    (%rax),%rax
  80007c:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  800082:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800085:	89 c6                	mov    %eax,%esi
  800087:	48 bf 60 45 80 00 00 	movabs $0x804560,%rdi
  80008e:	00 00 00 
  800091:	b8 00 00 00 00       	mov    $0x0,%eax
  800096:	48 b9 db 04 80 00 00 	movabs $0x8004db,%rcx
  80009d:	00 00 00 
  8000a0:	ff d1                	callq  *%rcx

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  8000a2:	48 b8 a7 20 80 00 00 	movabs $0x8020a7,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000b1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000b5:	79 30                	jns    8000e7 <primeproc+0xa3>
		panic("fork: %e", id);
  8000b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000ba:	89 c1                	mov    %eax,%ecx
  8000bc:	48 ba 6c 45 80 00 00 	movabs $0x80456c,%rdx
  8000c3:	00 00 00 
  8000c6:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000cb:	48 bf 75 45 80 00 00 	movabs $0x804575,%rdi
  8000d2:	00 00 00 
  8000d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000da:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  8000e1:	00 00 00 
  8000e4:	41 ff d0             	callq  *%r8
	if (id == 0)
  8000e7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000eb:	0f 84 5d ff ff ff    	je     80004e <primeproc+0xa>
  8000f1:	eb 01                	jmp    8000f4 <primeproc+0xb0>
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
		if (i % p)
			ipc_send(id, i, 0, 0);
	}
  8000f3:	90                   	nop
	if (id == 0)
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000f4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000fd:	be 00 00 00 00       	mov    $0x0,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax
  800111:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (i % p)
  800114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	c1 fa 1f             	sar    $0x1f,%edx
  80011c:	f7 7d fc             	idivl  -0x4(%rbp)
  80011f:	89 d0                	mov    %edx,%eax
  800121:	85 c0                	test   %eax,%eax
  800123:	74 ce                	je     8000f3 <primeproc+0xaf>
			ipc_send(id, i, 0, 0);
  800125:	8b 75 f4             	mov    -0xc(%rbp),%esi
  800128:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80012b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800130:	ba 00 00 00 00       	mov    $0x0,%edx
  800135:	89 c7                	mov    %eax,%edi
  800137:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  80013e:	00 00 00 
  800141:	ff d0                	callq  *%rax
	}
  800143:	eb ae                	jmp    8000f3 <primeproc+0xaf>

0000000000800145 <umain>:
}

void
umain(int argc, char **argv)
{
  800145:	55                   	push   %rbp
  800146:	48 89 e5             	mov    %rsp,%rbp
  800149:	48 83 ec 20          	sub    $0x20,%rsp
  80014d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800150:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  800154:	48 b8 a7 20 80 00 00 	movabs $0x8020a7,%rax
  80015b:	00 00 00 
  80015e:	ff d0                	callq  *%rax
  800160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800163:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800167:	79 30                	jns    800199 <umain+0x54>
		panic("fork: %e", id);
  800169:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80016c:	89 c1                	mov    %eax,%ecx
  80016e:	48 ba 6c 45 80 00 00 	movabs $0x80456c,%rdx
  800175:	00 00 00 
  800178:	be 2d 00 00 00       	mov    $0x2d,%esi
  80017d:	48 bf 75 45 80 00 00 	movabs $0x804575,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  800193:	00 00 00 
  800196:	41 ff d0             	callq  *%r8
	if (id == 0)
  800199:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019d:	75 0c                	jne    8001ab <umain+0x66>
		primeproc();
  80019f:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8001a6:	00 00 00 
  8001a9:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i = 2; ; i++)
  8001ab:	c7 45 fc 02 00 00 00 	movl   $0x2,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001b2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001b5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8001d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
		ipc_send(id, i, 0, 0);
  8001d4:	eb dc                	jmp    8001b2 <umain+0x6d>
	...

00000000008001d8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
  8001dc:	48 83 ec 10          	sub    $0x10,%rsp
  8001e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001e7:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8001ee:	00 00 00 
  8001f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8001f8:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  8001ff:	00 00 00 
  800202:	ff d0                	callq  *%rax
  800204:	48 98                	cltq   
  800206:	48 89 c2             	mov    %rax,%rdx
  800209:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80020f:	48 89 d0             	mov    %rdx,%rax
  800212:	48 c1 e0 03          	shl    $0x3,%rax
  800216:	48 01 d0             	add    %rdx,%rax
  800219:	48 c1 e0 05          	shl    $0x5,%rax
  80021d:	48 89 c2             	mov    %rax,%rdx
  800220:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800227:	00 00 00 
  80022a:	48 01 c2             	add    %rax,%rdx
  80022d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800234:	00 00 00 
  800237:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80023e:	7e 14                	jle    800254 <libmain+0x7c>
		binaryname = argv[0];
  800240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800244:	48 8b 10             	mov    (%rax),%rdx
  800247:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80024e:	00 00 00 
  800251:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800254:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	89 c7                	mov    %eax,%edi
  800260:	48 b8 45 01 80 00 00 	movabs $0x800145,%rax
  800267:	00 00 00 
  80026a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80026c:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  800273:	00 00 00 
  800276:	ff d0                	callq  *%rax
}
  800278:	c9                   	leaveq 
  800279:	c3                   	retq   
	...

000000000080027c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800280:	48 b8 1d 29 80 00 00 	movabs $0x80291d,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80028c:	bf 00 00 00 00       	mov    $0x0,%edi
  800291:	48 b8 10 19 80 00 00 	movabs $0x801910,%rax
  800298:	00 00 00 
  80029b:	ff d0                	callq  *%rax
}
  80029d:	5d                   	pop    %rbp
  80029e:	c3                   	retq   
	...

00000000008002a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a0:	55                   	push   %rbp
  8002a1:	48 89 e5             	mov    %rsp,%rbp
  8002a4:	53                   	push   %rbx
  8002a5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002ac:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002b3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002b9:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002c0:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002c7:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002ce:	84 c0                	test   %al,%al
  8002d0:	74 23                	je     8002f5 <_panic+0x55>
  8002d2:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002d9:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002dd:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002e1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002e5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002e9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002ed:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002f1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002f5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002fc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800303:	00 00 00 
  800306:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80030d:	00 00 00 
  800310:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800314:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80031b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800322:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800329:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800330:	00 00 00 
  800333:	48 8b 18             	mov    (%rax),%rbx
  800336:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  80033d:	00 00 00 
  800340:	ff d0                	callq  *%rax
  800342:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800348:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80034f:	41 89 c8             	mov    %ecx,%r8d
  800352:	48 89 d1             	mov    %rdx,%rcx
  800355:	48 89 da             	mov    %rbx,%rdx
  800358:	89 c6                	mov    %eax,%esi
  80035a:	48 bf 90 45 80 00 00 	movabs $0x804590,%rdi
  800361:	00 00 00 
  800364:	b8 00 00 00 00       	mov    $0x0,%eax
  800369:	49 b9 db 04 80 00 00 	movabs $0x8004db,%r9
  800370:	00 00 00 
  800373:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800376:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80037d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800384:	48 89 d6             	mov    %rdx,%rsi
  800387:	48 89 c7             	mov    %rax,%rdi
  80038a:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  800391:	00 00 00 
  800394:	ff d0                	callq  *%rax
	cprintf("\n");
  800396:	48 bf b3 45 80 00 00 	movabs $0x8045b3,%rdi
  80039d:	00 00 00 
  8003a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a5:	48 ba db 04 80 00 00 	movabs $0x8004db,%rdx
  8003ac:	00 00 00 
  8003af:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003b1:	cc                   	int3   
  8003b2:	eb fd                	jmp    8003b1 <_panic+0x111>

00000000008003b4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003b4:	55                   	push   %rbp
  8003b5:	48 89 e5             	mov    %rsp,%rbp
  8003b8:	48 83 ec 10          	sub    $0x10,%rsp
  8003bc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8003c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c7:	8b 00                	mov    (%rax),%eax
  8003c9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003cc:	89 d6                	mov    %edx,%esi
  8003ce:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8003d2:	48 63 d0             	movslq %eax,%rdx
  8003d5:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  8003da:	8d 50 01             	lea    0x1(%rax),%edx
  8003dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8003e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e7:	8b 00                	mov    (%rax),%eax
  8003e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ee:	75 2c                	jne    80041c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8003f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f4:	8b 00                	mov    (%rax),%eax
  8003f6:	48 98                	cltq   
  8003f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003fc:	48 83 c2 08          	add    $0x8,%rdx
  800400:	48 89 c6             	mov    %rax,%rsi
  800403:	48 89 d7             	mov    %rdx,%rdi
  800406:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  80040d:	00 00 00 
  800410:	ff d0                	callq  *%rax
		b->idx = 0;
  800412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800416:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80041c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800420:	8b 40 04             	mov    0x4(%rax),%eax
  800423:	8d 50 01             	lea    0x1(%rax),%edx
  800426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042a:	89 50 04             	mov    %edx,0x4(%rax)
}
  80042d:	c9                   	leaveq 
  80042e:	c3                   	retq   

000000000080042f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80042f:	55                   	push   %rbp
  800430:	48 89 e5             	mov    %rsp,%rbp
  800433:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80043a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800441:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800448:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80044f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800456:	48 8b 0a             	mov    (%rdx),%rcx
  800459:	48 89 08             	mov    %rcx,(%rax)
  80045c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800460:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800464:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800468:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80046c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800473:	00 00 00 
	b.cnt = 0;
  800476:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80047d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800480:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800487:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80048e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800495:	48 89 c6             	mov    %rax,%rsi
  800498:	48 bf b4 03 80 00 00 	movabs $0x8003b4,%rdi
  80049f:	00 00 00 
  8004a2:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  8004a9:	00 00 00 
  8004ac:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8004ae:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004b4:	48 98                	cltq   
  8004b6:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004bd:	48 83 c2 08          	add    $0x8,%rdx
  8004c1:	48 89 c6             	mov    %rax,%rsi
  8004c4:	48 89 d7             	mov    %rdx,%rdi
  8004c7:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  8004ce:	00 00 00 
  8004d1:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8004d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004d9:	c9                   	leaveq 
  8004da:	c3                   	retq   

00000000008004db <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004db:	55                   	push   %rbp
  8004dc:	48 89 e5             	mov    %rsp,%rbp
  8004df:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004e6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004ed:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004f4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004fb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800502:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800509:	84 c0                	test   %al,%al
  80050b:	74 20                	je     80052d <cprintf+0x52>
  80050d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800511:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800515:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800519:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80051d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800521:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800525:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800529:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80052d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800534:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80053b:	00 00 00 
  80053e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800545:	00 00 00 
  800548:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80054c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800553:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80055a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800561:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800568:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80056f:	48 8b 0a             	mov    (%rdx),%rcx
  800572:	48 89 08             	mov    %rcx,(%rax)
  800575:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800579:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80057d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800581:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800585:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80058c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800593:	48 89 d6             	mov    %rdx,%rsi
  800596:	48 89 c7             	mov    %rax,%rdi
  800599:	48 b8 2f 04 80 00 00 	movabs $0x80042f,%rax
  8005a0:	00 00 00 
  8005a3:	ff d0                	callq  *%rax
  8005a5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8005ab:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005b1:	c9                   	leaveq 
  8005b2:	c3                   	retq   
	...

00000000008005b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b4:	55                   	push   %rbp
  8005b5:	48 89 e5             	mov    %rsp,%rbp
  8005b8:	48 83 ec 30          	sub    $0x30,%rsp
  8005bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8005c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8005c8:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8005cb:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8005cf:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005d6:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8005da:	77 52                	ja     80062e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8005df:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005e3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8005e6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f3:	48 f7 75 d0          	divq   -0x30(%rbp)
  8005f7:	48 89 c2             	mov    %rax,%rdx
  8005fa:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8005fd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800600:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800608:	41 89 f9             	mov    %edi,%r9d
  80060b:	48 89 c7             	mov    %rax,%rdi
  80060e:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  800615:	00 00 00 
  800618:	ff d0                	callq  *%rax
  80061a:	eb 1c                	jmp    800638 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80061c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800620:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800623:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800627:	48 89 d6             	mov    %rdx,%rsi
  80062a:	89 c7                	mov    %eax,%edi
  80062c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80062e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800632:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800636:	7f e4                	jg     80061c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800638:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	48 f7 f1             	div    %rcx
  800647:	48 89 d0             	mov    %rdx,%rax
  80064a:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  800651:	00 00 00 
  800654:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800658:	0f be c0             	movsbl %al,%eax
  80065b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	89 c7                	mov    %eax,%edi
  800668:	ff d1                	callq  *%rcx
}
  80066a:	c9                   	leaveq 
  80066b:	c3                   	retq   

000000000080066c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	48 83 ec 20          	sub    $0x20,%rsp
  800674:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800678:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80067b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80067f:	7e 52                	jle    8006d3 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800681:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800685:	8b 00                	mov    (%rax),%eax
  800687:	83 f8 30             	cmp    $0x30,%eax
  80068a:	73 24                	jae    8006b0 <getuint+0x44>
  80068c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800690:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	8b 00                	mov    (%rax),%eax
  80069a:	89 c0                	mov    %eax,%eax
  80069c:	48 01 d0             	add    %rdx,%rax
  80069f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a3:	8b 12                	mov    (%rdx),%edx
  8006a5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ac:	89 0a                	mov    %ecx,(%rdx)
  8006ae:	eb 17                	jmp    8006c7 <getuint+0x5b>
  8006b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b8:	48 89 d0             	mov    %rdx,%rax
  8006bb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c7:	48 8b 00             	mov    (%rax),%rax
  8006ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ce:	e9 a3 00 00 00       	jmpq   800776 <getuint+0x10a>
	else if (lflag)
  8006d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006d7:	74 4f                	je     800728 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	8b 00                	mov    (%rax),%eax
  8006df:	83 f8 30             	cmp    $0x30,%eax
  8006e2:	73 24                	jae    800708 <getuint+0x9c>
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
  800706:	eb 17                	jmp    80071f <getuint+0xb3>
  800708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800710:	48 89 d0             	mov    %rdx,%rax
  800713:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071f:	48 8b 00             	mov    (%rax),%rax
  800722:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800726:	eb 4e                	jmp    800776 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072c:	8b 00                	mov    (%rax),%eax
  80072e:	83 f8 30             	cmp    $0x30,%eax
  800731:	73 24                	jae    800757 <getuint+0xeb>
  800733:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800737:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80073b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073f:	8b 00                	mov    (%rax),%eax
  800741:	89 c0                	mov    %eax,%eax
  800743:	48 01 d0             	add    %rdx,%rax
  800746:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074a:	8b 12                	mov    (%rdx),%edx
  80074c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800753:	89 0a                	mov    %ecx,(%rdx)
  800755:	eb 17                	jmp    80076e <getuint+0x102>
  800757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075f:	48 89 d0             	mov    %rdx,%rax
  800762:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076e:	8b 00                	mov    (%rax),%eax
  800770:	89 c0                	mov    %eax,%eax
  800772:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800776:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80077a:	c9                   	leaveq 
  80077b:	c3                   	retq   

000000000080077c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80077c:	55                   	push   %rbp
  80077d:	48 89 e5             	mov    %rsp,%rbp
  800780:	48 83 ec 20          	sub    $0x20,%rsp
  800784:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800788:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80078b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80078f:	7e 52                	jle    8007e3 <getint+0x67>
		x=va_arg(*ap, long long);
  800791:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800795:	8b 00                	mov    (%rax),%eax
  800797:	83 f8 30             	cmp    $0x30,%eax
  80079a:	73 24                	jae    8007c0 <getint+0x44>
  80079c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	8b 00                	mov    (%rax),%eax
  8007aa:	89 c0                	mov    %eax,%eax
  8007ac:	48 01 d0             	add    %rdx,%rax
  8007af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b3:	8b 12                	mov    (%rdx),%edx
  8007b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bc:	89 0a                	mov    %ecx,(%rdx)
  8007be:	eb 17                	jmp    8007d7 <getint+0x5b>
  8007c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007c8:	48 89 d0             	mov    %rdx,%rax
  8007cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007d7:	48 8b 00             	mov    (%rax),%rax
  8007da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007de:	e9 a3 00 00 00       	jmpq   800886 <getint+0x10a>
	else if (lflag)
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007e7:	74 4f                	je     800838 <getint+0xbc>
		x=va_arg(*ap, long);
  8007e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ed:	8b 00                	mov    (%rax),%eax
  8007ef:	83 f8 30             	cmp    $0x30,%eax
  8007f2:	73 24                	jae    800818 <getint+0x9c>
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
  800816:	eb 17                	jmp    80082f <getint+0xb3>
  800818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800820:	48 89 d0             	mov    %rdx,%rax
  800823:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082f:	48 8b 00             	mov    (%rax),%rax
  800832:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800836:	eb 4e                	jmp    800886 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083c:	8b 00                	mov    (%rax),%eax
  80083e:	83 f8 30             	cmp    $0x30,%eax
  800841:	73 24                	jae    800867 <getint+0xeb>
  800843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800847:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80084b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084f:	8b 00                	mov    (%rax),%eax
  800851:	89 c0                	mov    %eax,%eax
  800853:	48 01 d0             	add    %rdx,%rax
  800856:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085a:	8b 12                	mov    (%rdx),%edx
  80085c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800863:	89 0a                	mov    %ecx,(%rdx)
  800865:	eb 17                	jmp    80087e <getint+0x102>
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800876:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087e:	8b 00                	mov    (%rax),%eax
  800880:	48 98                	cltq   
  800882:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80088a:	c9                   	leaveq 
  80088b:	c3                   	retq   

000000000080088c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088c:	55                   	push   %rbp
  80088d:	48 89 e5             	mov    %rsp,%rbp
  800890:	41 54                	push   %r12
  800892:	53                   	push   %rbx
  800893:	48 83 ec 60          	sub    $0x60,%rsp
  800897:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80089b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80089f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008a3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008a7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008ab:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008af:	48 8b 0a             	mov    (%rdx),%rcx
  8008b2:	48 89 08             	mov    %rcx,(%rax)
  8008b5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008b9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008bd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c5:	eb 17                	jmp    8008de <vprintfmt+0x52>
			if (ch == '\0')
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	0f 84 d7 04 00 00    	je     800da6 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  8008cf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8008d3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8008d7:	48 89 c6             	mov    %rax,%rsi
  8008da:	89 df                	mov    %ebx,%edi
  8008dc:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008de:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e2:	0f b6 00             	movzbl (%rax),%eax
  8008e5:	0f b6 d8             	movzbl %al,%ebx
  8008e8:	83 fb 25             	cmp    $0x25,%ebx
  8008eb:	0f 95 c0             	setne  %al
  8008ee:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  8008f3:	84 c0                	test   %al,%al
  8008f5:	75 d0                	jne    8008c7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008fb:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800902:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800909:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800910:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800917:	eb 04                	jmp    80091d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800919:	90                   	nop
  80091a:	eb 01                	jmp    80091d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  80091c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800921:	0f b6 00             	movzbl (%rax),%eax
  800924:	0f b6 d8             	movzbl %al,%ebx
  800927:	89 d8                	mov    %ebx,%eax
  800929:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  80092e:	83 e8 23             	sub    $0x23,%eax
  800931:	83 f8 55             	cmp    $0x55,%eax
  800934:	0f 87 38 04 00 00    	ja     800d72 <vprintfmt+0x4e6>
  80093a:	89 c0                	mov    %eax,%eax
  80093c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800943:	00 
  800944:	48 b8 b0 47 80 00 00 	movabs $0x8047b0,%rax
  80094b:	00 00 00 
  80094e:	48 01 d0             	add    %rdx,%rax
  800951:	48 8b 00             	mov    (%rax),%rax
  800954:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800956:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80095a:	eb c1                	jmp    80091d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80095c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800960:	eb bb                	jmp    80091d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800962:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800969:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80096c:	89 d0                	mov    %edx,%eax
  80096e:	c1 e0 02             	shl    $0x2,%eax
  800971:	01 d0                	add    %edx,%eax
  800973:	01 c0                	add    %eax,%eax
  800975:	01 d8                	add    %ebx,%eax
  800977:	83 e8 30             	sub    $0x30,%eax
  80097a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80097d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800981:	0f b6 00             	movzbl (%rax),%eax
  800984:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800987:	83 fb 2f             	cmp    $0x2f,%ebx
  80098a:	7e 63                	jle    8009ef <vprintfmt+0x163>
  80098c:	83 fb 39             	cmp    $0x39,%ebx
  80098f:	7f 5e                	jg     8009ef <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800991:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800996:	eb d1                	jmp    800969 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800998:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099b:	83 f8 30             	cmp    $0x30,%eax
  80099e:	73 17                	jae    8009b7 <vprintfmt+0x12b>
  8009a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a7:	89 c0                	mov    %eax,%eax
  8009a9:	48 01 d0             	add    %rdx,%rax
  8009ac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009af:	83 c2 08             	add    $0x8,%edx
  8009b2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b5:	eb 0f                	jmp    8009c6 <vprintfmt+0x13a>
  8009b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009bb:	48 89 d0             	mov    %rdx,%rax
  8009be:	48 83 c2 08          	add    $0x8,%rdx
  8009c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c6:	8b 00                	mov    (%rax),%eax
  8009c8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  8009cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d1:	0f 89 42 ff ff ff    	jns    800919 <vprintfmt+0x8d>
				width = 0;
  8009d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009de:	e9 36 ff ff ff       	jmpq   800919 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  8009e3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ea:	e9 2e ff ff ff       	jmpq   80091d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ef:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009f4:	0f 89 22 ff ff ff    	jns    80091c <vprintfmt+0x90>
				width = precision, precision = -1;
  8009fa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009fd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a00:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a07:	e9 10 ff ff ff       	jmpq   80091c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a0c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a10:	e9 08 ff ff ff       	jmpq   80091d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a18:	83 f8 30             	cmp    $0x30,%eax
  800a1b:	73 17                	jae    800a34 <vprintfmt+0x1a8>
  800a1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a24:	89 c0                	mov    %eax,%eax
  800a26:	48 01 d0             	add    %rdx,%rax
  800a29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a2c:	83 c2 08             	add    $0x8,%edx
  800a2f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a32:	eb 0f                	jmp    800a43 <vprintfmt+0x1b7>
  800a34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a38:	48 89 d0             	mov    %rdx,%rax
  800a3b:	48 83 c2 08          	add    $0x8,%rdx
  800a3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a43:	8b 00                	mov    (%rax),%eax
  800a45:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a49:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800a4d:	48 89 d6             	mov    %rdx,%rsi
  800a50:	89 c7                	mov    %eax,%edi
  800a52:	ff d1                	callq  *%rcx
			break;
  800a54:	e9 47 03 00 00       	jmpq   800da0 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800a59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5c:	83 f8 30             	cmp    $0x30,%eax
  800a5f:	73 17                	jae    800a78 <vprintfmt+0x1ec>
  800a61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a68:	89 c0                	mov    %eax,%eax
  800a6a:	48 01 d0             	add    %rdx,%rax
  800a6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a70:	83 c2 08             	add    $0x8,%edx
  800a73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a76:	eb 0f                	jmp    800a87 <vprintfmt+0x1fb>
  800a78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7c:	48 89 d0             	mov    %rdx,%rax
  800a7f:	48 83 c2 08          	add    $0x8,%rdx
  800a83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a87:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a89:	85 db                	test   %ebx,%ebx
  800a8b:	79 02                	jns    800a8f <vprintfmt+0x203>
				err = -err;
  800a8d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a8f:	83 fb 10             	cmp    $0x10,%ebx
  800a92:	7f 16                	jg     800aaa <vprintfmt+0x21e>
  800a94:	48 b8 00 47 80 00 00 	movabs $0x804700,%rax
  800a9b:	00 00 00 
  800a9e:	48 63 d3             	movslq %ebx,%rdx
  800aa1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aa5:	4d 85 e4             	test   %r12,%r12
  800aa8:	75 2e                	jne    800ad8 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800aaa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab2:	89 d9                	mov    %ebx,%ecx
  800ab4:	48 ba 99 47 80 00 00 	movabs $0x804799,%rdx
  800abb:	00 00 00 
  800abe:	48 89 c7             	mov    %rax,%rdi
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac6:	49 b8 b0 0d 80 00 00 	movabs $0x800db0,%r8
  800acd:	00 00 00 
  800ad0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad3:	e9 c8 02 00 00       	jmpq   800da0 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800adc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae0:	4c 89 e1             	mov    %r12,%rcx
  800ae3:	48 ba a2 47 80 00 00 	movabs $0x8047a2,%rdx
  800aea:	00 00 00 
  800aed:	48 89 c7             	mov    %rax,%rdi
  800af0:	b8 00 00 00 00       	mov    $0x0,%eax
  800af5:	49 b8 b0 0d 80 00 00 	movabs $0x800db0,%r8
  800afc:	00 00 00 
  800aff:	41 ff d0             	callq  *%r8
			break;
  800b02:	e9 99 02 00 00       	jmpq   800da0 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0a:	83 f8 30             	cmp    $0x30,%eax
  800b0d:	73 17                	jae    800b26 <vprintfmt+0x29a>
  800b0f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b13:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b16:	89 c0                	mov    %eax,%eax
  800b18:	48 01 d0             	add    %rdx,%rax
  800b1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b24:	eb 0f                	jmp    800b35 <vprintfmt+0x2a9>
  800b26:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b2a:	48 89 d0             	mov    %rdx,%rax
  800b2d:	48 83 c2 08          	add    $0x8,%rdx
  800b31:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b35:	4c 8b 20             	mov    (%rax),%r12
  800b38:	4d 85 e4             	test   %r12,%r12
  800b3b:	75 0a                	jne    800b47 <vprintfmt+0x2bb>
				p = "(null)";
  800b3d:	49 bc a5 47 80 00 00 	movabs $0x8047a5,%r12
  800b44:	00 00 00 
			if (width > 0 && padc != '-')
  800b47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4b:	7e 7a                	jle    800bc7 <vprintfmt+0x33b>
  800b4d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b51:	74 74                	je     800bc7 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b53:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b56:	48 98                	cltq   
  800b58:	48 89 c6             	mov    %rax,%rsi
  800b5b:	4c 89 e7             	mov    %r12,%rdi
  800b5e:	48 b8 5a 10 80 00 00 	movabs $0x80105a,%rax
  800b65:	00 00 00 
  800b68:	ff d0                	callq  *%rax
  800b6a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b6d:	eb 17                	jmp    800b86 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800b6f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800b73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b77:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800b7b:	48 89 d6             	mov    %rdx,%rsi
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b82:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b86:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b8a:	7f e3                	jg     800b6f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	eb 39                	jmp    800bc7 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b92:	74 1e                	je     800bb2 <vprintfmt+0x326>
  800b94:	83 fb 1f             	cmp    $0x1f,%ebx
  800b97:	7e 05                	jle    800b9e <vprintfmt+0x312>
  800b99:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9c:	7e 14                	jle    800bb2 <vprintfmt+0x326>
					putch('?', putdat);
  800b9e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ba2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ba6:	48 89 c6             	mov    %rax,%rsi
  800ba9:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bae:	ff d2                	callq  *%rdx
  800bb0:	eb 0f                	jmp    800bc1 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800bb2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bb6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bba:	48 89 c6             	mov    %rax,%rsi
  800bbd:	89 df                	mov    %ebx,%edi
  800bbf:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc5:	eb 01                	jmp    800bc8 <vprintfmt+0x33c>
  800bc7:	90                   	nop
  800bc8:	41 0f b6 04 24       	movzbl (%r12),%eax
  800bcd:	0f be d8             	movsbl %al,%ebx
  800bd0:	85 db                	test   %ebx,%ebx
  800bd2:	0f 95 c0             	setne  %al
  800bd5:	49 83 c4 01          	add    $0x1,%r12
  800bd9:	84 c0                	test   %al,%al
  800bdb:	74 28                	je     800c05 <vprintfmt+0x379>
  800bdd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be1:	78 ab                	js     800b8e <vprintfmt+0x302>
  800be3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800be7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800beb:	79 a1                	jns    800b8e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bed:	eb 16                	jmp    800c05 <vprintfmt+0x379>
				putch(' ', putdat);
  800bef:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800bf3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800bf7:	48 89 c6             	mov    %rax,%rsi
  800bfa:	bf 20 00 00 00       	mov    $0x20,%edi
  800bff:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c01:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c05:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c09:	7f e4                	jg     800bef <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800c0b:	e9 90 01 00 00       	jmpq   800da0 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c14:	be 03 00 00 00       	mov    $0x3,%esi
  800c19:	48 89 c7             	mov    %rax,%rdi
  800c1c:	48 b8 7c 07 80 00 00 	movabs $0x80077c,%rax
  800c23:	00 00 00 
  800c26:	ff d0                	callq  *%rax
  800c28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c30:	48 85 c0             	test   %rax,%rax
  800c33:	79 1d                	jns    800c52 <vprintfmt+0x3c6>
				putch('-', putdat);
  800c35:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800c39:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800c3d:	48 89 c6             	mov    %rax,%rsi
  800c40:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c45:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4b:	48 f7 d8             	neg    %rax
  800c4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c52:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c59:	e9 d5 00 00 00       	jmpq   800d33 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c5e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c62:	be 03 00 00 00       	mov    $0x3,%esi
  800c67:	48 89 c7             	mov    %rax,%rdi
  800c6a:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800c71:	00 00 00 
  800c74:	ff d0                	callq  *%rax
  800c76:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c7a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c81:	e9 ad 00 00 00       	jmpq   800d33 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800c86:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c8a:	be 03 00 00 00       	mov    $0x3,%esi
  800c8f:	48 89 c7             	mov    %rax,%rdi
  800c92:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800c99:	00 00 00 
  800c9c:	ff d0                	callq  *%rax
  800c9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800ca2:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ca9:	e9 85 00 00 00       	jmpq   800d33 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800cae:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cb2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cb6:	48 89 c6             	mov    %rax,%rsi
  800cb9:	bf 30 00 00 00       	mov    $0x30,%edi
  800cbe:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800cc0:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cc4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800cc8:	48 89 c6             	mov    %rax,%rsi
  800ccb:	bf 78 00 00 00       	mov    $0x78,%edi
  800cd0:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800cd2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd5:	83 f8 30             	cmp    $0x30,%eax
  800cd8:	73 17                	jae    800cf1 <vprintfmt+0x465>
  800cda:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce1:	89 c0                	mov    %eax,%eax
  800ce3:	48 01 d0             	add    %rdx,%rax
  800ce6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ce9:	83 c2 08             	add    $0x8,%edx
  800cec:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cef:	eb 0f                	jmp    800d00 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800cf1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cf5:	48 89 d0             	mov    %rdx,%rax
  800cf8:	48 83 c2 08          	add    $0x8,%rdx
  800cfc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d00:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d03:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d07:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d0e:	eb 23                	jmp    800d33 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d14:	be 03 00 00 00       	mov    $0x3,%esi
  800d19:	48 89 c7             	mov    %rax,%rdi
  800d1c:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800d23:	00 00 00 
  800d26:	ff d0                	callq  *%rax
  800d28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d2c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d33:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d38:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d3b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d3e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d42:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4a:	45 89 c1             	mov    %r8d,%r9d
  800d4d:	41 89 f8             	mov    %edi,%r8d
  800d50:	48 89 c7             	mov    %rax,%rdi
  800d53:	48 b8 b4 05 80 00 00 	movabs $0x8005b4,%rax
  800d5a:	00 00 00 
  800d5d:	ff d0                	callq  *%rax
			break;
  800d5f:	eb 3f                	jmp    800da0 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d61:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d65:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d69:	48 89 c6             	mov    %rax,%rsi
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	ff d2                	callq  *%rdx
			break;
  800d70:	eb 2e                	jmp    800da0 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d7a:	48 89 c6             	mov    %rax,%rsi
  800d7d:	bf 25 00 00 00       	mov    $0x25,%edi
  800d82:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d84:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d89:	eb 05                	jmp    800d90 <vprintfmt+0x504>
  800d8b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d90:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d94:	48 83 e8 01          	sub    $0x1,%rax
  800d98:	0f b6 00             	movzbl (%rax),%eax
  800d9b:	3c 25                	cmp    $0x25,%al
  800d9d:	75 ec                	jne    800d8b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800d9f:	90                   	nop
		}
	}
  800da0:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da1:	e9 38 fb ff ff       	jmpq   8008de <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800da6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800da7:	48 83 c4 60          	add    $0x60,%rsp
  800dab:	5b                   	pop    %rbx
  800dac:	41 5c                	pop    %r12
  800dae:	5d                   	pop    %rbp
  800daf:	c3                   	retq   

0000000000800db0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db0:	55                   	push   %rbp
  800db1:	48 89 e5             	mov    %rsp,%rbp
  800db4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dbb:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dc2:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dc9:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dd0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dd7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dde:	84 c0                	test   %al,%al
  800de0:	74 20                	je     800e02 <printfmt+0x52>
  800de2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800de6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dea:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dee:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800df2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800df6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dfa:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dfe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e02:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e09:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e10:	00 00 00 
  800e13:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e1a:	00 00 00 
  800e1d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e21:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e28:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e2f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e36:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e3d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e44:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e4b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e52:	48 89 c7             	mov    %rax,%rdi
  800e55:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800e5c:	00 00 00 
  800e5f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e61:	c9                   	leaveq 
  800e62:	c3                   	retq   

0000000000800e63 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e63:	55                   	push   %rbp
  800e64:	48 89 e5             	mov    %rsp,%rbp
  800e67:	48 83 ec 10          	sub    $0x10,%rsp
  800e6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e76:	8b 40 10             	mov    0x10(%rax),%eax
  800e79:	8d 50 01             	lea    0x1(%rax),%edx
  800e7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e80:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e87:	48 8b 10             	mov    (%rax),%rdx
  800e8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e92:	48 39 c2             	cmp    %rax,%rdx
  800e95:	73 17                	jae    800eae <sprintputch+0x4b>
		*b->buf++ = ch;
  800e97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9b:	48 8b 00             	mov    (%rax),%rax
  800e9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ea1:	88 10                	mov    %dl,(%rax)
  800ea3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eab:	48 89 10             	mov    %rdx,(%rax)
}
  800eae:	c9                   	leaveq 
  800eaf:	c3                   	retq   

0000000000800eb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800eb0:	55                   	push   %rbp
  800eb1:	48 89 e5             	mov    %rsp,%rbp
  800eb4:	48 83 ec 50          	sub    $0x50,%rsp
  800eb8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ebc:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ebf:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ec3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800ec7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ecb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ecf:	48 8b 0a             	mov    (%rdx),%rcx
  800ed2:	48 89 08             	mov    %rcx,(%rax)
  800ed5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800edd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ee5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ee9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800eed:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ef0:	48 98                	cltq   
  800ef2:	48 83 e8 01          	sub    $0x1,%rax
  800ef6:	48 03 45 c8          	add    -0x38(%rbp),%rax
  800efa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800efe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f05:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f0a:	74 06                	je     800f12 <vsnprintf+0x62>
  800f0c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f10:	7f 07                	jg     800f19 <vsnprintf+0x69>
		return -E_INVAL;
  800f12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f17:	eb 2f                	jmp    800f48 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f19:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f1d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f21:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f25:	48 89 c6             	mov    %rax,%rsi
  800f28:	48 bf 63 0e 80 00 00 	movabs $0x800e63,%rdi
  800f2f:	00 00 00 
  800f32:	48 b8 8c 08 80 00 00 	movabs $0x80088c,%rax
  800f39:	00 00 00 
  800f3c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f3e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f42:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f45:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f48:	c9                   	leaveq 
  800f49:	c3                   	retq   

0000000000800f4a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f4a:	55                   	push   %rbp
  800f4b:	48 89 e5             	mov    %rsp,%rbp
  800f4e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f55:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f5c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f62:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f69:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f70:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f77:	84 c0                	test   %al,%al
  800f79:	74 20                	je     800f9b <snprintf+0x51>
  800f7b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f7f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f83:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f87:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f8b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f8f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f93:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f97:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f9b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fa2:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fa9:	00 00 00 
  800fac:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fb3:	00 00 00 
  800fb6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fba:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fc1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fc8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fcf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fd6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fdd:	48 8b 0a             	mov    (%rdx),%rcx
  800fe0:	48 89 08             	mov    %rcx,(%rax)
  800fe3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fe7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800feb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ff3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800ffa:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801001:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801007:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80100e:	48 89 c7             	mov    %rax,%rdi
  801011:	48 b8 b0 0e 80 00 00 	movabs $0x800eb0,%rax
  801018:	00 00 00 
  80101b:	ff d0                	callq  *%rax
  80101d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801023:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801029:	c9                   	leaveq 
  80102a:	c3                   	retq   
	...

000000000080102c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 83 ec 18          	sub    $0x18,%rsp
  801034:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80103f:	eb 09                	jmp    80104a <strlen+0x1e>
		n++;
  801041:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801045:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80104a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104e:	0f b6 00             	movzbl (%rax),%eax
  801051:	84 c0                	test   %al,%al
  801053:	75 ec                	jne    801041 <strlen+0x15>
		n++;
	return n;
  801055:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801058:	c9                   	leaveq 
  801059:	c3                   	retq   

000000000080105a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80105a:	55                   	push   %rbp
  80105b:	48 89 e5             	mov    %rsp,%rbp
  80105e:	48 83 ec 20          	sub    $0x20,%rsp
  801062:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801066:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801071:	eb 0e                	jmp    801081 <strnlen+0x27>
		n++;
  801073:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801077:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80107c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801081:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801086:	74 0b                	je     801093 <strnlen+0x39>
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	84 c0                	test   %al,%al
  801091:	75 e0                	jne    801073 <strnlen+0x19>
		n++;
	return n;
  801093:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801096:	c9                   	leaveq 
  801097:	c3                   	retq   

0000000000801098 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801098:	55                   	push   %rbp
  801099:	48 89 e5             	mov    %rsp,%rbp
  80109c:	48 83 ec 20          	sub    $0x20,%rsp
  8010a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010b0:	90                   	nop
  8010b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010b5:	0f b6 10             	movzbl (%rax),%edx
  8010b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bc:	88 10                	mov    %dl,(%rax)
  8010be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	0f 95 c0             	setne  %al
  8010ca:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010cf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8010d4:	84 c0                	test   %al,%al
  8010d6:	75 d9                	jne    8010b1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010dc:	c9                   	leaveq 
  8010dd:	c3                   	retq   

00000000008010de <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010de:	55                   	push   %rbp
  8010df:	48 89 e5             	mov    %rsp,%rbp
  8010e2:	48 83 ec 20          	sub    $0x20,%rsp
  8010e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f2:	48 89 c7             	mov    %rax,%rdi
  8010f5:	48 b8 2c 10 80 00 00 	movabs $0x80102c,%rax
  8010fc:	00 00 00 
  8010ff:	ff d0                	callq  *%rax
  801101:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801107:	48 98                	cltq   
  801109:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80110d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801111:	48 89 d6             	mov    %rdx,%rsi
  801114:	48 89 c7             	mov    %rax,%rdi
  801117:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  80111e:	00 00 00 
  801121:	ff d0                	callq  *%rax
	return dst;
  801123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801127:	c9                   	leaveq 
  801128:	c3                   	retq   

0000000000801129 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801129:	55                   	push   %rbp
  80112a:	48 89 e5             	mov    %rsp,%rbp
  80112d:	48 83 ec 28          	sub    $0x28,%rsp
  801131:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801135:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801139:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801145:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80114c:	00 
  80114d:	eb 27                	jmp    801176 <strncpy+0x4d>
		*dst++ = *src;
  80114f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801153:	0f b6 10             	movzbl (%rax),%edx
  801156:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115a:	88 10                	mov    %dl,(%rax)
  80115c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	84 c0                	test   %al,%al
  80116a:	74 05                	je     801171 <strncpy+0x48>
			src++;
  80116c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801171:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801176:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80117e:	72 cf                	jb     80114f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801180:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801184:	c9                   	leaveq 
  801185:	c3                   	retq   

0000000000801186 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801186:	55                   	push   %rbp
  801187:	48 89 e5             	mov    %rsp,%rbp
  80118a:	48 83 ec 28          	sub    $0x28,%rsp
  80118e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801196:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80119a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011a2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011a7:	74 37                	je     8011e0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  8011a9:	eb 17                	jmp    8011c2 <strlcpy+0x3c>
			*dst++ = *src++;
  8011ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011af:	0f b6 10             	movzbl (%rax),%edx
  8011b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b6:	88 10                	mov    %dl,(%rax)
  8011b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011bd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011c2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011cc:	74 0b                	je     8011d9 <strlcpy+0x53>
  8011ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d2:	0f b6 00             	movzbl (%rax),%eax
  8011d5:	84 c0                	test   %al,%al
  8011d7:	75 d2                	jne    8011ab <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011dd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	48 89 d1             	mov    %rdx,%rcx
  8011eb:	48 29 c1             	sub    %rax,%rcx
  8011ee:	48 89 c8             	mov    %rcx,%rax
}
  8011f1:	c9                   	leaveq 
  8011f2:	c3                   	retq   

00000000008011f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	48 83 ec 10          	sub    $0x10,%rsp
  8011fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ff:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801203:	eb 0a                	jmp    80120f <strcmp+0x1c>
		p++, q++;
  801205:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80120a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80120f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801213:	0f b6 00             	movzbl (%rax),%eax
  801216:	84 c0                	test   %al,%al
  801218:	74 12                	je     80122c <strcmp+0x39>
  80121a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80121e:	0f b6 10             	movzbl (%rax),%edx
  801221:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801225:	0f b6 00             	movzbl (%rax),%eax
  801228:	38 c2                	cmp    %al,%dl
  80122a:	74 d9                	je     801205 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80122c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801230:	0f b6 00             	movzbl (%rax),%eax
  801233:	0f b6 d0             	movzbl %al,%edx
  801236:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123a:	0f b6 00             	movzbl (%rax),%eax
  80123d:	0f b6 c0             	movzbl %al,%eax
  801240:	89 d1                	mov    %edx,%ecx
  801242:	29 c1                	sub    %eax,%ecx
  801244:	89 c8                	mov    %ecx,%eax
}
  801246:	c9                   	leaveq 
  801247:	c3                   	retq   

0000000000801248 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	48 83 ec 18          	sub    $0x18,%rsp
  801250:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801258:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80125c:	eb 0f                	jmp    80126d <strncmp+0x25>
		n--, p++, q++;
  80125e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801263:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801268:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80126d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801272:	74 1d                	je     801291 <strncmp+0x49>
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	84 c0                	test   %al,%al
  80127d:	74 12                	je     801291 <strncmp+0x49>
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 10             	movzbl (%rax),%edx
  801286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128a:	0f b6 00             	movzbl (%rax),%eax
  80128d:	38 c2                	cmp    %al,%dl
  80128f:	74 cd                	je     80125e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801291:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801296:	75 07                	jne    80129f <strncmp+0x57>
		return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb 1a                	jmp    8012b9 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80129f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a3:	0f b6 00             	movzbl (%rax),%eax
  8012a6:	0f b6 d0             	movzbl %al,%edx
  8012a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	0f b6 c0             	movzbl %al,%eax
  8012b3:	89 d1                	mov    %edx,%ecx
  8012b5:	29 c1                	sub    %eax,%ecx
  8012b7:	89 c8                	mov    %ecx,%eax
}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 10          	sub    $0x10,%rsp
  8012c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c7:	89 f0                	mov    %esi,%eax
  8012c9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012cc:	eb 17                	jmp    8012e5 <strchr+0x2a>
		if (*s == c)
  8012ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d2:	0f b6 00             	movzbl (%rax),%eax
  8012d5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d8:	75 06                	jne    8012e0 <strchr+0x25>
			return (char *) s;
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	eb 15                	jmp    8012f5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e9:	0f b6 00             	movzbl (%rax),%eax
  8012ec:	84 c0                	test   %al,%al
  8012ee:	75 de                	jne    8012ce <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f5:	c9                   	leaveq 
  8012f6:	c3                   	retq   

00000000008012f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012f7:	55                   	push   %rbp
  8012f8:	48 89 e5             	mov    %rsp,%rbp
  8012fb:	48 83 ec 10          	sub    $0x10,%rsp
  8012ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801303:	89 f0                	mov    %esi,%eax
  801305:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801308:	eb 11                	jmp    80131b <strfind+0x24>
		if (*s == c)
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	0f b6 00             	movzbl (%rax),%eax
  801311:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801314:	74 12                	je     801328 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801316:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80131f:	0f b6 00             	movzbl (%rax),%eax
  801322:	84 c0                	test   %al,%al
  801324:	75 e4                	jne    80130a <strfind+0x13>
  801326:	eb 01                	jmp    801329 <strfind+0x32>
		if (*s == c)
			break;
  801328:	90                   	nop
	return (char *) s;
  801329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80132d:	c9                   	leaveq 
  80132e:	c3                   	retq   

000000000080132f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80132f:	55                   	push   %rbp
  801330:	48 89 e5             	mov    %rsp,%rbp
  801333:	48 83 ec 18          	sub    $0x18,%rsp
  801337:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80133b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80133e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801342:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801347:	75 06                	jne    80134f <memset+0x20>
		return v;
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	eb 69                	jmp    8013b8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80134f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801353:	83 e0 03             	and    $0x3,%eax
  801356:	48 85 c0             	test   %rax,%rax
  801359:	75 48                	jne    8013a3 <memset+0x74>
  80135b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135f:	83 e0 03             	and    $0x3,%eax
  801362:	48 85 c0             	test   %rax,%rax
  801365:	75 3c                	jne    8013a3 <memset+0x74>
		c &= 0xFF;
  801367:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80136e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801371:	89 c2                	mov    %eax,%edx
  801373:	c1 e2 18             	shl    $0x18,%edx
  801376:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801379:	c1 e0 10             	shl    $0x10,%eax
  80137c:	09 c2                	or     %eax,%edx
  80137e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801381:	c1 e0 08             	shl    $0x8,%eax
  801384:	09 d0                	or     %edx,%eax
  801386:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138d:	48 89 c1             	mov    %rax,%rcx
  801390:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801394:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801398:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139b:	48 89 d7             	mov    %rdx,%rdi
  80139e:	fc                   	cld    
  80139f:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013a1:	eb 11                	jmp    8013b4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013aa:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013ae:	48 89 d7             	mov    %rdx,%rdi
  8013b1:	fc                   	cld    
  8013b2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8013b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b8:	c9                   	leaveq 
  8013b9:	c3                   	retq   

00000000008013ba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013ba:	55                   	push   %rbp
  8013bb:	48 89 e5             	mov    %rsp,%rbp
  8013be:	48 83 ec 28          	sub    $0x28,%rsp
  8013c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013e6:	0f 83 88 00 00 00    	jae    801474 <memmove+0xba>
  8013ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f4:	48 01 d0             	add    %rdx,%rax
  8013f7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013fb:	76 77                	jbe    801474 <memmove+0xba>
		s += n;
  8013fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801401:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80140d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801411:	83 e0 03             	and    $0x3,%eax
  801414:	48 85 c0             	test   %rax,%rax
  801417:	75 3b                	jne    801454 <memmove+0x9a>
  801419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141d:	83 e0 03             	and    $0x3,%eax
  801420:	48 85 c0             	test   %rax,%rax
  801423:	75 2f                	jne    801454 <memmove+0x9a>
  801425:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	48 85 c0             	test   %rax,%rax
  80142f:	75 23                	jne    801454 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801431:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801435:	48 83 e8 04          	sub    $0x4,%rax
  801439:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80143d:	48 83 ea 04          	sub    $0x4,%rdx
  801441:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801445:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801449:	48 89 c7             	mov    %rax,%rdi
  80144c:	48 89 d6             	mov    %rdx,%rsi
  80144f:	fd                   	std    
  801450:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801452:	eb 1d                	jmp    801471 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801458:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801460:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801464:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801468:	48 89 d7             	mov    %rdx,%rdi
  80146b:	48 89 c1             	mov    %rax,%rcx
  80146e:	fd                   	std    
  80146f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801471:	fc                   	cld    
  801472:	eb 57                	jmp    8014cb <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801474:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	48 85 c0             	test   %rax,%rax
  80147e:	75 36                	jne    8014b6 <memmove+0xfc>
  801480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801484:	83 e0 03             	and    $0x3,%eax
  801487:	48 85 c0             	test   %rax,%rax
  80148a:	75 2a                	jne    8014b6 <memmove+0xfc>
  80148c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801490:	83 e0 03             	and    $0x3,%eax
  801493:	48 85 c0             	test   %rax,%rax
  801496:	75 1e                	jne    8014b6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801498:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149c:	48 89 c1             	mov    %rax,%rcx
  80149f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ab:	48 89 c7             	mov    %rax,%rdi
  8014ae:	48 89 d6             	mov    %rdx,%rsi
  8014b1:	fc                   	cld    
  8014b2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014b4:	eb 15                	jmp    8014cb <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014c2:	48 89 c7             	mov    %rax,%rdi
  8014c5:	48 89 d6             	mov    %rdx,%rsi
  8014c8:	fc                   	cld    
  8014c9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014cf:	c9                   	leaveq 
  8014d0:	c3                   	retq   

00000000008014d1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014d1:	55                   	push   %rbp
  8014d2:	48 89 e5             	mov    %rsp,%rbp
  8014d5:	48 83 ec 18          	sub    $0x18,%rsp
  8014d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	48 89 ce             	mov    %rcx,%rsi
  8014f4:	48 89 c7             	mov    %rax,%rdi
  8014f7:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8014fe:	00 00 00 
  801501:	ff d0                	callq  *%rax
}
  801503:	c9                   	leaveq 
  801504:	c3                   	retq   

0000000000801505 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801505:	55                   	push   %rbp
  801506:	48 89 e5             	mov    %rsp,%rbp
  801509:	48 83 ec 28          	sub    $0x28,%rsp
  80150d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801511:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801515:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801525:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801529:	eb 38                	jmp    801563 <memcmp+0x5e>
		if (*s1 != *s2)
  80152b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152f:	0f b6 10             	movzbl (%rax),%edx
  801532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801536:	0f b6 00             	movzbl (%rax),%eax
  801539:	38 c2                	cmp    %al,%dl
  80153b:	74 1c                	je     801559 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	0f b6 00             	movzbl (%rax),%eax
  801544:	0f b6 d0             	movzbl %al,%edx
  801547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154b:	0f b6 00             	movzbl (%rax),%eax
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	89 d1                	mov    %edx,%ecx
  801553:	29 c1                	sub    %eax,%ecx
  801555:	89 c8                	mov    %ecx,%eax
  801557:	eb 20                	jmp    801579 <memcmp+0x74>
		s1++, s2++;
  801559:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80155e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801563:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801568:	0f 95 c0             	setne  %al
  80156b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801570:	84 c0                	test   %al,%al
  801572:	75 b7                	jne    80152b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801579:	c9                   	leaveq 
  80157a:	c3                   	retq   

000000000080157b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80157b:	55                   	push   %rbp
  80157c:	48 89 e5             	mov    %rsp,%rbp
  80157f:	48 83 ec 28          	sub    $0x28,%rsp
  801583:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801587:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80158a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80158e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801592:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801596:	48 01 d0             	add    %rdx,%rax
  801599:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80159d:	eb 13                	jmp    8015b2 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a3:	0f b6 10             	movzbl (%rax),%edx
  8015a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015a9:	38 c2                	cmp    %al,%dl
  8015ab:	74 11                	je     8015be <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015ad:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015ba:	72 e3                	jb     80159f <memfind+0x24>
  8015bc:	eb 01                	jmp    8015bf <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015be:	90                   	nop
	return (void *) s;
  8015bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015c3:	c9                   	leaveq 
  8015c4:	c3                   	retq   

00000000008015c5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c5:	55                   	push   %rbp
  8015c6:	48 89 e5             	mov    %rsp,%rbp
  8015c9:	48 83 ec 38          	sub    $0x38,%rsp
  8015cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015d5:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015df:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015e6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015e7:	eb 05                	jmp    8015ee <strtol+0x29>
		s++;
  8015e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f2:	0f b6 00             	movzbl (%rax),%eax
  8015f5:	3c 20                	cmp    $0x20,%al
  8015f7:	74 f0                	je     8015e9 <strtol+0x24>
  8015f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fd:	0f b6 00             	movzbl (%rax),%eax
  801600:	3c 09                	cmp    $0x9,%al
  801602:	74 e5                	je     8015e9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 2b                	cmp    $0x2b,%al
  80160d:	75 07                	jne    801616 <strtol+0x51>
		s++;
  80160f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801614:	eb 17                	jmp    80162d <strtol+0x68>
	else if (*s == '-')
  801616:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161a:	0f b6 00             	movzbl (%rax),%eax
  80161d:	3c 2d                	cmp    $0x2d,%al
  80161f:	75 0c                	jne    80162d <strtol+0x68>
		s++, neg = 1;
  801621:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801626:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80162d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801631:	74 06                	je     801639 <strtol+0x74>
  801633:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801637:	75 28                	jne    801661 <strtol+0x9c>
  801639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163d:	0f b6 00             	movzbl (%rax),%eax
  801640:	3c 30                	cmp    $0x30,%al
  801642:	75 1d                	jne    801661 <strtol+0x9c>
  801644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801648:	48 83 c0 01          	add    $0x1,%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 78                	cmp    $0x78,%al
  801651:	75 0e                	jne    801661 <strtol+0x9c>
		s += 2, base = 16;
  801653:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801658:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80165f:	eb 2c                	jmp    80168d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801661:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801665:	75 19                	jne    801680 <strtol+0xbb>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 30                	cmp    $0x30,%al
  801670:	75 0e                	jne    801680 <strtol+0xbb>
		s++, base = 8;
  801672:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801677:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80167e:	eb 0d                	jmp    80168d <strtol+0xc8>
	else if (base == 0)
  801680:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801684:	75 07                	jne    80168d <strtol+0xc8>
		base = 10;
  801686:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	3c 2f                	cmp    $0x2f,%al
  801696:	7e 1d                	jle    8016b5 <strtol+0xf0>
  801698:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	3c 39                	cmp    $0x39,%al
  8016a1:	7f 12                	jg     8016b5 <strtol+0xf0>
			dig = *s - '0';
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f be c0             	movsbl %al,%eax
  8016ad:	83 e8 30             	sub    $0x30,%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b3:	eb 4e                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b9:	0f b6 00             	movzbl (%rax),%eax
  8016bc:	3c 60                	cmp    $0x60,%al
  8016be:	7e 1d                	jle    8016dd <strtol+0x118>
  8016c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c4:	0f b6 00             	movzbl (%rax),%eax
  8016c7:	3c 7a                	cmp    $0x7a,%al
  8016c9:	7f 12                	jg     8016dd <strtol+0x118>
			dig = *s - 'a' + 10;
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	0f be c0             	movsbl %al,%eax
  8016d5:	83 e8 57             	sub    $0x57,%eax
  8016d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016db:	eb 26                	jmp    801703 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	0f b6 00             	movzbl (%rax),%eax
  8016e4:	3c 40                	cmp    $0x40,%al
  8016e6:	7e 47                	jle    80172f <strtol+0x16a>
  8016e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	3c 5a                	cmp    $0x5a,%al
  8016f1:	7f 3c                	jg     80172f <strtol+0x16a>
			dig = *s - 'A' + 10;
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	0f be c0             	movsbl %al,%eax
  8016fd:	83 e8 37             	sub    $0x37,%eax
  801700:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801703:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801706:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801709:	7d 23                	jge    80172e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80170b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801710:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801713:	48 98                	cltq   
  801715:	48 89 c2             	mov    %rax,%rdx
  801718:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  80171d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801720:	48 98                	cltq   
  801722:	48 01 d0             	add    %rdx,%rax
  801725:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801729:	e9 5f ff ff ff       	jmpq   80168d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80172e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80172f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801734:	74 0b                	je     801741 <strtol+0x17c>
		*endptr = (char *) s;
  801736:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80173a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80173e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801741:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801745:	74 09                	je     801750 <strtol+0x18b>
  801747:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80174b:	48 f7 d8             	neg    %rax
  80174e:	eb 04                	jmp    801754 <strtol+0x18f>
  801750:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801754:	c9                   	leaveq 
  801755:	c3                   	retq   

0000000000801756 <strstr>:

char * strstr(const char *in, const char *str)
{
  801756:	55                   	push   %rbp
  801757:	48 89 e5             	mov    %rsp,%rbp
  80175a:	48 83 ec 30          	sub    $0x30,%rsp
  80175e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801762:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801766:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80176a:	0f b6 00             	movzbl (%rax),%eax
  80176d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801770:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801775:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801779:	75 06                	jne    801781 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	eb 68                	jmp    8017e9 <strstr+0x93>

    len = strlen(str);
  801781:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801785:	48 89 c7             	mov    %rax,%rdi
  801788:	48 b8 2c 10 80 00 00 	movabs $0x80102c,%rax
  80178f:	00 00 00 
  801792:	ff d0                	callq  *%rax
  801794:	48 98                	cltq   
  801796:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80179a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179e:	0f b6 00             	movzbl (%rax),%eax
  8017a1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8017a4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  8017a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017ad:	75 07                	jne    8017b6 <strstr+0x60>
                return (char *) 0;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b4:	eb 33                	jmp    8017e9 <strstr+0x93>
        } while (sc != c);
  8017b6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017ba:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017bd:	75 db                	jne    80179a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  8017bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cb:	48 89 ce             	mov    %rcx,%rsi
  8017ce:	48 89 c7             	mov    %rax,%rdi
  8017d1:	48 b8 48 12 80 00 00 	movabs $0x801248,%rax
  8017d8:	00 00 00 
  8017db:	ff d0                	callq  *%rax
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	75 b9                	jne    80179a <strstr+0x44>

    return (char *) (in - 1);
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	48 83 e8 01          	sub    $0x1,%rax
}
  8017e9:	c9                   	leaveq 
  8017ea:	c3                   	retq   
	...

00000000008017ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017ec:	55                   	push   %rbp
  8017ed:	48 89 e5             	mov    %rsp,%rbp
  8017f0:	53                   	push   %rbx
  8017f1:	48 83 ec 58          	sub    $0x58,%rsp
  8017f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017f8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017fb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017ff:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801803:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801807:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80180e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801811:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801815:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801819:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80181d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801821:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801825:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801828:	4c 89 c3             	mov    %r8,%rbx
  80182b:	cd 30                	int    $0x30
  80182d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801831:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801835:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801839:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80183d:	74 3e                	je     80187d <syscall+0x91>
  80183f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801844:	7e 37                	jle    80187d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801846:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80184d:	49 89 d0             	mov    %rdx,%r8
  801850:	89 c1                	mov    %eax,%ecx
  801852:	48 ba 60 4a 80 00 00 	movabs $0x804a60,%rdx
  801859:	00 00 00 
  80185c:	be 23 00 00 00       	mov    $0x23,%esi
  801861:	48 bf 7d 4a 80 00 00 	movabs $0x804a7d,%rdi
  801868:	00 00 00 
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
  801870:	49 b9 a0 02 80 00 00 	movabs $0x8002a0,%r9
  801877:	00 00 00 
  80187a:	41 ff d1             	callq  *%r9

	return ret;
  80187d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801881:	48 83 c4 58          	add    $0x58,%rsp
  801885:	5b                   	pop    %rbx
  801886:	5d                   	pop    %rbp
  801887:	c3                   	retq   

0000000000801888 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801888:	55                   	push   %rbp
  801889:	48 89 e5             	mov    %rsp,%rbp
  80188c:	48 83 ec 20          	sub    $0x20,%rsp
  801890:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801894:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a7:	00 
  8018a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b4:	48 89 d1             	mov    %rdx,%rcx
  8018b7:	48 89 c2             	mov    %rax,%rdx
  8018ba:	be 00 00 00 00       	mov    $0x0,%esi
  8018bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8018c4:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  8018cb:	00 00 00 
  8018ce:	ff d0                	callq  *%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8018da:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e1:	00 
  8018e2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	be 00 00 00 00       	mov    $0x0,%esi
  8018fd:	bf 01 00 00 00       	mov    $0x1,%edi
  801902:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801909:	00 00 00 
  80190c:	ff d0                	callq  *%rax
}
  80190e:	c9                   	leaveq 
  80190f:	c3                   	retq   

0000000000801910 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801910:	55                   	push   %rbp
  801911:	48 89 e5             	mov    %rsp,%rbp
  801914:	48 83 ec 20          	sub    $0x20,%rsp
  801918:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80191b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80191e:	48 98                	cltq   
  801920:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801927:	00 
  801928:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801934:	b9 00 00 00 00       	mov    $0x0,%ecx
  801939:	48 89 c2             	mov    %rax,%rdx
  80193c:	be 01 00 00 00       	mov    $0x1,%esi
  801941:	bf 03 00 00 00       	mov    $0x3,%edi
  801946:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  80194d:	00 00 00 
  801950:	ff d0                	callq  *%rax
}
  801952:	c9                   	leaveq 
  801953:	c3                   	retq   

0000000000801954 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801954:	55                   	push   %rbp
  801955:	48 89 e5             	mov    %rsp,%rbp
  801958:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	b9 00 00 00 00       	mov    $0x0,%ecx
  801975:	ba 00 00 00 00       	mov    $0x0,%edx
  80197a:	be 00 00 00 00       	mov    $0x0,%esi
  80197f:	bf 02 00 00 00       	mov    $0x2,%edi
  801984:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  80198b:	00 00 00 
  80198e:	ff d0                	callq  *%rax
}
  801990:	c9                   	leaveq 
  801991:	c3                   	retq   

0000000000801992 <sys_yield>:

void
sys_yield(void)
{
  801992:	55                   	push   %rbp
  801993:	48 89 e5             	mov    %rsp,%rbp
  801996:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80199a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019a1:	00 
  8019a2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	be 00 00 00 00       	mov    $0x0,%esi
  8019bd:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019c2:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  8019c9:	00 00 00 
  8019cc:	ff d0                	callq  *%rax
}
  8019ce:	c9                   	leaveq 
  8019cf:	c3                   	retq   

00000000008019d0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8019d0:	55                   	push   %rbp
  8019d1:	48 89 e5             	mov    %rsp,%rbp
  8019d4:	48 83 ec 20          	sub    $0x20,%rsp
  8019d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019df:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8019e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019e5:	48 63 c8             	movslq %eax,%rcx
  8019e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ef:	48 98                	cltq   
  8019f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f8:	00 
  8019f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ff:	49 89 c8             	mov    %rcx,%r8
  801a02:	48 89 d1             	mov    %rdx,%rcx
  801a05:	48 89 c2             	mov    %rax,%rdx
  801a08:	be 01 00 00 00       	mov    $0x1,%esi
  801a0d:	bf 04 00 00 00       	mov    $0x4,%edi
  801a12:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
}
  801a1e:	c9                   	leaveq 
  801a1f:	c3                   	retq   

0000000000801a20 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a20:	55                   	push   %rbp
  801a21:	48 89 e5             	mov    %rsp,%rbp
  801a24:	48 83 ec 30          	sub    $0x30,%rsp
  801a28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a32:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a36:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a3a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a3d:	48 63 c8             	movslq %eax,%rcx
  801a40:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a47:	48 63 f0             	movslq %eax,%rsi
  801a4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a51:	48 98                	cltq   
  801a53:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a57:	49 89 f9             	mov    %rdi,%r9
  801a5a:	49 89 f0             	mov    %rsi,%r8
  801a5d:	48 89 d1             	mov    %rdx,%rcx
  801a60:	48 89 c2             	mov    %rax,%rdx
  801a63:	be 01 00 00 00       	mov    $0x1,%esi
  801a68:	bf 05 00 00 00       	mov    $0x5,%edi
  801a6d:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801a74:	00 00 00 
  801a77:	ff d0                	callq  *%rax
}
  801a79:	c9                   	leaveq 
  801a7a:	c3                   	retq   

0000000000801a7b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a7b:	55                   	push   %rbp
  801a7c:	48 89 e5             	mov    %rsp,%rbp
  801a7f:	48 83 ec 20          	sub    $0x20,%rsp
  801a83:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a91:	48 98                	cltq   
  801a93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9a:	00 
  801a9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa7:	48 89 d1             	mov    %rdx,%rcx
  801aaa:	48 89 c2             	mov    %rax,%rdx
  801aad:	be 01 00 00 00       	mov    $0x1,%esi
  801ab2:	bf 06 00 00 00       	mov    $0x6,%edi
  801ab7:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801abe:	00 00 00 
  801ac1:	ff d0                	callq  *%rax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	48 83 ec 20          	sub    $0x20,%rsp
  801acd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ad3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad6:	48 63 d0             	movslq %eax,%rdx
  801ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adc:	48 98                	cltq   
  801ade:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae5:	00 
  801ae6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af2:	48 89 d1             	mov    %rdx,%rcx
  801af5:	48 89 c2             	mov    %rax,%rdx
  801af8:	be 01 00 00 00       	mov    $0x1,%esi
  801afd:	bf 08 00 00 00       	mov    $0x8,%edi
  801b02:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
}
  801b0e:	c9                   	leaveq 
  801b0f:	c3                   	retq   

0000000000801b10 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b10:	55                   	push   %rbp
  801b11:	48 89 e5             	mov    %rsp,%rbp
  801b14:	48 83 ec 20          	sub    $0x20,%rsp
  801b18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b26:	48 98                	cltq   
  801b28:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2f:	00 
  801b30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3c:	48 89 d1             	mov    %rdx,%rcx
  801b3f:	48 89 c2             	mov    %rax,%rdx
  801b42:	be 01 00 00 00       	mov    $0x1,%esi
  801b47:	bf 09 00 00 00       	mov    $0x9,%edi
  801b4c:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
}
  801b58:	c9                   	leaveq 
  801b59:	c3                   	retq   

0000000000801b5a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b5a:	55                   	push   %rbp
  801b5b:	48 89 e5             	mov    %rsp,%rbp
  801b5e:	48 83 ec 20          	sub    $0x20,%rsp
  801b62:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b70:	48 98                	cltq   
  801b72:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b79:	00 
  801b7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b86:	48 89 d1             	mov    %rdx,%rcx
  801b89:	48 89 c2             	mov    %rax,%rdx
  801b8c:	be 01 00 00 00       	mov    $0x1,%esi
  801b91:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b96:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	callq  *%rax
}
  801ba2:	c9                   	leaveq 
  801ba3:	c3                   	retq   

0000000000801ba4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ba4:	55                   	push   %rbp
  801ba5:	48 89 e5             	mov    %rsp,%rbp
  801ba8:	48 83 ec 30          	sub    $0x30,%rsp
  801bac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801baf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801bb7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801bba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bbd:	48 63 f0             	movslq %eax,%rsi
  801bc0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc7:	48 98                	cltq   
  801bc9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd4:	00 
  801bd5:	49 89 f1             	mov    %rsi,%r9
  801bd8:	49 89 c8             	mov    %rcx,%r8
  801bdb:	48 89 d1             	mov    %rdx,%rcx
  801bde:	48 89 c2             	mov    %rax,%rdx
  801be1:	be 00 00 00 00       	mov    $0x0,%esi
  801be6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801beb:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
}
  801bf7:	c9                   	leaveq 
  801bf8:	c3                   	retq   

0000000000801bf9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bf9:	55                   	push   %rbp
  801bfa:	48 89 e5             	mov    %rsp,%rbp
  801bfd:	48 83 ec 20          	sub    $0x20,%rsp
  801c01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c10:	00 
  801c11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c22:	48 89 c2             	mov    %rax,%rdx
  801c25:	be 01 00 00 00       	mov    $0x1,%esi
  801c2a:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c2f:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801c36:	00 00 00 
  801c39:	ff d0                	callq  *%rax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801c45:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c4c:	00 
  801c4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c59:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c63:	be 00 00 00 00       	mov    $0x0,%esi
  801c68:	bf 0e 00 00 00       	mov    $0xe,%edi
  801c6d:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801c74:	00 00 00 
  801c77:	ff d0                	callq  *%rax
}
  801c79:	c9                   	leaveq 
  801c7a:	c3                   	retq   

0000000000801c7b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801c7b:	55                   	push   %rbp
  801c7c:	48 89 e5             	mov    %rsp,%rbp
  801c7f:	48 83 ec 20          	sub    $0x20,%rsp
  801c83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801c8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c8f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9a:	00 
  801c9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca7:	48 89 d1             	mov    %rdx,%rcx
  801caa:	48 89 c2             	mov    %rax,%rdx
  801cad:	be 00 00 00 00       	mov    $0x0,%esi
  801cb2:	bf 0f 00 00 00       	mov    $0xf,%edi
  801cb7:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801cbe:	00 00 00 
  801cc1:	ff d0                	callq  *%rax
}
  801cc3:	c9                   	leaveq 
  801cc4:	c3                   	retq   

0000000000801cc5 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801cc5:	55                   	push   %rbp
  801cc6:	48 89 e5             	mov    %rsp,%rbp
  801cc9:	48 83 ec 20          	sub    $0x20,%rsp
  801ccd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cd1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce4:	00 
  801ce5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ceb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf1:	48 89 d1             	mov    %rdx,%rcx
  801cf4:	48 89 c2             	mov    %rax,%rdx
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 10 00 00 00       	mov    $0x10,%edi
  801d01:	48 b8 ec 17 80 00 00 	movabs $0x8017ec,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
}
  801d0d:	c9                   	leaveq 
  801d0e:	c3                   	retq   
	...

0000000000801d10 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801d10:	55                   	push   %rbp
  801d11:	48 89 e5             	mov    %rsp,%rbp
  801d14:	48 83 ec 30          	sub    $0x30,%rsp
  801d18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d20:	48 8b 00             	mov    (%rax),%rax
  801d23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801d27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2b:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d2f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801d32:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801d35:	83 e0 02             	and    $0x2,%eax
  801d38:	85 c0                	test   %eax,%eax
  801d3a:	74 23                	je     801d5f <pgfault+0x4f>
  801d3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d40:	48 89 c2             	mov    %rax,%rdx
  801d43:	48 c1 ea 0c          	shr    $0xc,%rdx
  801d47:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d4e:	01 00 00 
  801d51:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d55:	25 00 08 00 00       	and    $0x800,%eax
  801d5a:	48 85 c0             	test   %rax,%rax
  801d5d:	75 2a                	jne    801d89 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801d5f:	48 ba 90 4a 80 00 00 	movabs $0x804a90,%rdx
  801d66:	00 00 00 
  801d69:	be 1c 00 00 00       	mov    $0x1c,%esi
  801d6e:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801d75:	00 00 00 
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801d84:	00 00 00 
  801d87:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801d89:	ba 07 00 00 00       	mov    $0x7,%edx
  801d8e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d93:	bf 00 00 00 00       	mov    $0x0,%edi
  801d98:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  801d9f:	00 00 00 
  801da2:	ff d0                	callq  *%rax
  801da4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801dab:	79 30                	jns    801ddd <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801dad:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801db0:	89 c1                	mov    %eax,%ecx
  801db2:	48 ba d0 4a 80 00 00 	movabs $0x804ad0,%rdx
  801db9:	00 00 00 
  801dbc:	be 26 00 00 00       	mov    $0x26,%esi
  801dc1:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801dc8:	00 00 00 
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  801dd7:	00 00 00 
  801dda:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801ddd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801de1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801de5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801def:	ba 00 10 00 00       	mov    $0x1000,%edx
  801df4:	48 89 c6             	mov    %rax,%rsi
  801df7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801dfc:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  801e03:	00 00 00 
  801e06:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801e10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e14:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801e1a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801e20:	48 89 c1             	mov    %rax,%rcx
  801e23:	ba 00 00 00 00       	mov    $0x0,%edx
  801e28:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e2d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e32:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
  801e3e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e45:	79 30                	jns    801e77 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801e47:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e4a:	89 c1                	mov    %eax,%ecx
  801e4c:	48 ba f8 4a 80 00 00 	movabs $0x804af8,%rdx
  801e53:	00 00 00 
  801e56:	be 2b 00 00 00       	mov    $0x2b,%esi
  801e5b:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801e62:	00 00 00 
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  801e71:	00 00 00 
  801e74:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801e77:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e81:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801e94:	79 30                	jns    801ec6 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801e96:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801e99:	89 c1                	mov    %eax,%ecx
  801e9b:	48 ba 20 4b 80 00 00 	movabs $0x804b20,%rdx
  801ea2:	00 00 00 
  801ea5:	be 2e 00 00 00       	mov    $0x2e,%esi
  801eaa:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801eb1:	00 00 00 
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb9:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  801ec0:	00 00 00 
  801ec3:	41 ff d0             	callq  *%r8
	
}
  801ec6:	c9                   	leaveq 
  801ec7:	c3                   	retq   

0000000000801ec8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ec8:	55                   	push   %rbp
  801ec9:	48 89 e5             	mov    %rsp,%rbp
  801ecc:	48 83 ec 30          	sub    $0x30,%rsp
  801ed0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ed3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  801ed6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801edd:	01 00 00 
  801ee0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801ee3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ee7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  801eeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eef:	25 07 0e 00 00       	and    $0xe07,%eax
  801ef4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  801ef7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801efa:	48 c1 e0 0c          	shl    $0xc,%rax
  801efe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  801f02:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f05:	25 00 04 00 00       	and    $0x400,%eax
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 5c                	je     801f6a <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  801f0e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801f11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f15:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f1c:	41 89 f0             	mov    %esi,%r8d
  801f1f:	48 89 c6             	mov    %rax,%rsi
  801f22:	bf 00 00 00 00       	mov    $0x0,%edi
  801f27:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  801f2e:	00 00 00 
  801f31:	ff d0                	callq  *%rax
  801f33:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  801f36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801f3a:	0f 89 60 01 00 00    	jns    8020a0 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  801f40:	48 ba 48 4b 80 00 00 	movabs $0x804b48,%rdx
  801f47:	00 00 00 
  801f4a:	be 4d 00 00 00       	mov    $0x4d,%esi
  801f4f:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801f56:	00 00 00 
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801f65:	00 00 00 
  801f68:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  801f6a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f6d:	83 e0 02             	and    $0x2,%eax
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 10                	jne    801f84 <duppage+0xbc>
  801f74:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801f77:	25 00 08 00 00       	and    $0x800,%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	0f 84 c4 00 00 00    	je     802048 <duppage+0x180>
	{
		perm |= PTE_COW;
  801f84:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  801f8b:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  801f8f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  801f92:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f96:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f9d:	41 89 f0             	mov    %esi,%r8d
  801fa0:	48 89 c6             	mov    %rax,%rsi
  801fa3:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa8:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  801faf:	00 00 00 
  801fb2:	ff d0                	callq  *%rax
  801fb4:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  801fb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801fbb:	79 2a                	jns    801fe7 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  801fbd:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  801fc4:	00 00 00 
  801fc7:	be 56 00 00 00       	mov    $0x56,%esi
  801fcc:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  801fd3:	00 00 00 
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  801fe2:	00 00 00 
  801fe5:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  801fe7:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  801fea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ff2:	41 89 c8             	mov    %ecx,%r8d
  801ff5:	48 89 d1             	mov    %rdx,%rcx
  801ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffd:	48 89 c6             	mov    %rax,%rsi
  802000:	bf 00 00 00 00       	mov    $0x0,%edi
  802005:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  80200c:	00 00 00 
  80200f:	ff d0                	callq  *%rax
  802011:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802014:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802018:	0f 89 82 00 00 00    	jns    8020a0 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  80201e:	48 ba 78 4b 80 00 00 	movabs $0x804b78,%rdx
  802025:	00 00 00 
  802028:	be 59 00 00 00       	mov    $0x59,%esi
  80202d:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  802034:	00 00 00 
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  802043:	00 00 00 
  802046:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802048:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80204b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80204f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802056:	41 89 f0             	mov    %esi,%r8d
  802059:	48 89 c6             	mov    %rax,%rsi
  80205c:	bf 00 00 00 00       	mov    $0x0,%edi
  802061:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802068:	00 00 00 
  80206b:	ff d0                	callq  *%rax
  80206d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802070:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802074:	79 2a                	jns    8020a0 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  802076:	48 ba b0 4b 80 00 00 	movabs $0x804bb0,%rdx
  80207d:	00 00 00 
  802080:	be 60 00 00 00       	mov    $0x60,%esi
  802085:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  80208c:	00 00 00 
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  80209b:	00 00 00 
  80209e:	ff d1                	callq  *%rcx
	}
	return 0;
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a5:	c9                   	leaveq 
  8020a6:	c3                   	retq   

00000000008020a7 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8020a7:	55                   	push   %rbp
  8020a8:	48 89 e5             	mov    %rsp,%rbp
  8020ab:	53                   	push   %rbx
  8020ac:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8020b0:	48 bf 10 1d 80 00 00 	movabs $0x801d10,%rdi
  8020b7:	00 00 00 
  8020ba:	48 b8 6c 43 80 00 00 	movabs $0x80436c,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8020c6:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  8020cd:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8020d0:	cd 30                	int    $0x30
  8020d2:	89 c3                	mov    %eax,%ebx
  8020d4:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8020d7:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  8020da:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  8020dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8020e1:	79 30                	jns    802113 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  8020e3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020e6:	89 c1                	mov    %eax,%ecx
  8020e8:	48 ba d4 4b 80 00 00 	movabs $0x804bd4,%rdx
  8020ef:	00 00 00 
  8020f2:	be 7f 00 00 00       	mov    $0x7f,%esi
  8020f7:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  8020fe:	00 00 00 
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  80210d:	00 00 00 
  802110:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802113:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802117:	75 4c                	jne    802165 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802119:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	48 98                	cltq   
  802127:	48 89 c2             	mov    %rax,%rdx
  80212a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802130:	48 89 d0             	mov    %rdx,%rax
  802133:	48 c1 e0 03          	shl    $0x3,%rax
  802137:	48 01 d0             	add    %rdx,%rax
  80213a:	48 c1 e0 05          	shl    $0x5,%rax
  80213e:	48 89 c2             	mov    %rax,%rdx
  802141:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802148:	00 00 00 
  80214b:	48 01 c2             	add    %rax,%rdx
  80214e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802155:	00 00 00 
  802158:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
  802160:	e9 38 02 00 00       	jmpq   80239d <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802165:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802168:	ba 07 00 00 00       	mov    $0x7,%edx
  80216d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802172:	89 c7                	mov    %eax,%edi
  802174:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80217b:	00 00 00 
  80217e:	ff d0                	callq  *%rax
  802180:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802183:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802187:	79 30                	jns    8021b9 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802189:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80218c:	89 c1                	mov    %eax,%ecx
  80218e:	48 ba e8 4b 80 00 00 	movabs $0x804be8,%rdx
  802195:	00 00 00 
  802198:	be 8b 00 00 00       	mov    $0x8b,%esi
  80219d:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  8021a4:	00 00 00 
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  8021b3:	00 00 00 
  8021b6:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  8021b9:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  8021c0:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8021c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  8021ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  8021d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8021dc:	e9 0a 01 00 00       	jmpq   8022eb <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8021e1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8021e8:	01 00 00 
  8021eb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021ee:	48 63 d2             	movslq %edx,%rdx
  8021f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f5:	83 e0 01             	and    $0x1,%eax
  8021f8:	84 c0                	test   %al,%al
  8021fa:	0f 84 e7 00 00 00    	je     8022e7 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802200:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802207:	e9 cf 00 00 00       	jmpq   8022db <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80220c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802213:	01 00 00 
  802216:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802219:	48 63 d2             	movslq %edx,%rdx
  80221c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802220:	83 e0 01             	and    $0x1,%eax
  802223:	84 c0                	test   %al,%al
  802225:	0f 84 a0 00 00 00    	je     8022cb <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80222b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802232:	e9 85 00 00 00       	jmpq   8022bc <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802237:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80223e:	01 00 00 
  802241:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802244:	48 63 d2             	movslq %edx,%rdx
  802247:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80224b:	83 e0 01             	and    $0x1,%eax
  80224e:	84 c0                	test   %al,%al
  802250:	74 56                	je     8022a8 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802252:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802259:	eb 42                	jmp    80229d <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80225b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802262:	01 00 00 
  802265:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802268:	48 63 d2             	movslq %edx,%rdx
  80226b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80226f:	83 e0 01             	and    $0x1,%eax
  802272:	84 c0                	test   %al,%al
  802274:	74 1f                	je     802295 <fork+0x1ee>
  802276:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  80227d:	74 16                	je     802295 <fork+0x1ee>
									 duppage(envid,d1);
  80227f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802282:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802285:	89 d6                	mov    %edx,%esi
  802287:	89 c7                	mov    %eax,%edi
  802289:	48 b8 c8 1e 80 00 00 	movabs $0x801ec8,%rax
  802290:	00 00 00 
  802293:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802295:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802299:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  80229d:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  8022a4:	7e b5                	jle    80225b <fork+0x1b4>
  8022a6:	eb 0c                	jmp    8022b4 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  8022a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ab:	83 c0 01             	add    $0x1,%eax
  8022ae:	c1 e0 09             	shl    $0x9,%eax
  8022b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8022b4:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  8022b8:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  8022bc:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  8022c3:	0f 8e 6e ff ff ff    	jle    802237 <fork+0x190>
  8022c9:	eb 0c                	jmp    8022d7 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  8022cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022ce:	83 c0 01             	add    $0x1,%eax
  8022d1:	c1 e0 09             	shl    $0x9,%eax
  8022d4:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  8022d7:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  8022db:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8022de:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8022e1:	0f 8c 25 ff ff ff    	jl     80220c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8022e7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8022eb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ee:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8022f1:	0f 8c ea fe ff ff    	jl     8021e1 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8022f7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022fa:	48 be 30 44 80 00 00 	movabs $0x804430,%rsi
  802301:	00 00 00 
  802304:	89 c7                	mov    %eax,%edi
  802306:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802315:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802319:	79 30                	jns    80234b <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80231b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80231e:	89 c1                	mov    %eax,%ecx
  802320:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  802327:	00 00 00 
  80232a:	be ad 00 00 00       	mov    $0xad,%esi
  80232f:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  802336:	00 00 00 
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  802345:	00 00 00 
  802348:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80234b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80234e:	be 02 00 00 00       	mov    $0x2,%esi
  802353:	89 c7                	mov    %eax,%edi
  802355:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  80235c:	00 00 00 
  80235f:	ff d0                	callq  *%rax
  802361:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802364:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802368:	79 30                	jns    80239a <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80236a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80236d:	89 c1                	mov    %eax,%ecx
  80236f:	48 ba 38 4c 80 00 00 	movabs $0x804c38,%rdx
  802376:	00 00 00 
  802379:	be b0 00 00 00       	mov    $0xb0,%esi
  80237e:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  802385:	00 00 00 
  802388:	b8 00 00 00 00       	mov    $0x0,%eax
  80238d:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  802394:	00 00 00 
  802397:	41 ff d0             	callq  *%r8
	return envid;
  80239a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  80239d:	48 83 c4 48          	add    $0x48,%rsp
  8023a1:	5b                   	pop    %rbx
  8023a2:	5d                   	pop    %rbp
  8023a3:	c3                   	retq   

00000000008023a4 <sfork>:

// Challenge!
int
sfork(void)
{
  8023a4:	55                   	push   %rbp
  8023a5:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8023a8:	48 ba 5c 4c 80 00 00 	movabs $0x804c5c,%rdx
  8023af:	00 00 00 
  8023b2:	be b8 00 00 00       	mov    $0xb8,%esi
  8023b7:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  8023be:	00 00 00 
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c6:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  8023cd:	00 00 00 
  8023d0:	ff d1                	callq  *%rcx
	...

00000000008023d4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023d4:	55                   	push   %rbp
  8023d5:	48 89 e5             	mov    %rsp,%rbp
  8023d8:	48 83 ec 30          	sub    $0x30,%rsp
  8023dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8023e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8023ed:	74 18                	je     802407 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8023ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023f3:	48 89 c7             	mov    %rax,%rdi
  8023f6:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
  802402:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802405:	eb 19                	jmp    802420 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  802407:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80240e:	00 00 00 
  802411:	48 b8 f9 1b 80 00 00 	movabs $0x801bf9,%rax
  802418:	00 00 00 
  80241b:	ff d0                	callq  *%rax
  80241d:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  802420:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802424:	79 19                	jns    80243f <ipc_recv+0x6b>
	{
		*from_env_store=0;
  802426:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  802430:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802434:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  80243a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80243d:	eb 53                	jmp    802492 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80243f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802444:	74 19                	je     80245f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802446:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80244d:	00 00 00 
  802450:	48 8b 00             	mov    (%rax),%rax
  802453:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80245f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802464:	74 19                	je     80247f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802466:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80246d:	00 00 00 
  802470:	48 8b 00             	mov    (%rax),%rax
  802473:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80247f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802486:	00 00 00 
  802489:	48 8b 00             	mov    (%rax),%rax
  80248c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  802492:	c9                   	leaveq 
  802493:	c3                   	retq   

0000000000802494 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802494:	55                   	push   %rbp
  802495:	48 89 e5             	mov    %rsp,%rbp
  802498:	48 83 ec 30          	sub    $0x30,%rsp
  80249c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80249f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8024a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8024a6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8024a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8024b0:	e9 96 00 00 00       	jmpq   80254b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8024b5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024ba:	74 20                	je     8024dc <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8024bc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024bf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8024c2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024c9:	89 c7                	mov    %eax,%edi
  8024cb:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  8024d2:	00 00 00 
  8024d5:	ff d0                	callq  *%rax
  8024d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024da:	eb 2d                	jmp    802509 <ipc_send+0x75>
		else if(pg==NULL)
  8024dc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8024e1:	75 26                	jne    802509 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8024e3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8024e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8024ee:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8024f5:	00 00 00 
  8024f8:	89 c7                	mov    %eax,%edi
  8024fa:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  802501:	00 00 00 
  802504:	ff d0                	callq  *%rax
  802506:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  802509:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250d:	79 30                	jns    80253f <ipc_send+0xab>
  80250f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802513:	74 2a                	je     80253f <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  802515:	48 ba 72 4c 80 00 00 	movabs $0x804c72,%rdx
  80251c:	00 00 00 
  80251f:	be 40 00 00 00       	mov    $0x40,%esi
  802524:	48 bf 8a 4c 80 00 00 	movabs $0x804c8a,%rdi
  80252b:	00 00 00 
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	48 b9 a0 02 80 00 00 	movabs $0x8002a0,%rcx
  80253a:	00 00 00 
  80253d:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80253f:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80254b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254f:	0f 85 60 ff ff ff    	jne    8024b5 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802555:	c9                   	leaveq 
  802556:	c3                   	retq   

0000000000802557 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802557:	55                   	push   %rbp
  802558:	48 89 e5             	mov    %rsp,%rbp
  80255b:	48 83 ec 18          	sub    $0x18,%rsp
  80255f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802569:	eb 5e                	jmp    8025c9 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80256b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802572:	00 00 00 
  802575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802578:	48 63 d0             	movslq %eax,%rdx
  80257b:	48 89 d0             	mov    %rdx,%rax
  80257e:	48 c1 e0 03          	shl    $0x3,%rax
  802582:	48 01 d0             	add    %rdx,%rax
  802585:	48 c1 e0 05          	shl    $0x5,%rax
  802589:	48 01 c8             	add    %rcx,%rax
  80258c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802592:	8b 00                	mov    (%rax),%eax
  802594:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802597:	75 2c                	jne    8025c5 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802599:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8025a0:	00 00 00 
  8025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a6:	48 63 d0             	movslq %eax,%rdx
  8025a9:	48 89 d0             	mov    %rdx,%rax
  8025ac:	48 c1 e0 03          	shl    $0x3,%rax
  8025b0:	48 01 d0             	add    %rdx,%rax
  8025b3:	48 c1 e0 05          	shl    $0x5,%rax
  8025b7:	48 01 c8             	add    %rcx,%rax
  8025ba:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8025c0:	8b 40 08             	mov    0x8(%rax),%eax
  8025c3:	eb 12                	jmp    8025d7 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025c9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8025d0:	7e 99                	jle    80256b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d7:	c9                   	leaveq 
  8025d8:	c3                   	retq   
  8025d9:	00 00                	add    %al,(%rax)
	...

00000000008025dc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 08          	sub    $0x8,%rsp
  8025e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ec:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025f3:	ff ff ff 
  8025f6:	48 01 d0             	add    %rdx,%rax
  8025f9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025fd:	c9                   	leaveq 
  8025fe:	c3                   	retq   

00000000008025ff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025ff:	55                   	push   %rbp
  802600:	48 89 e5             	mov    %rsp,%rbp
  802603:	48 83 ec 08          	sub    $0x8,%rsp
  802607:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80260b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260f:	48 89 c7             	mov    %rax,%rdi
  802612:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802619:	00 00 00 
  80261c:	ff d0                	callq  *%rax
  80261e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802624:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802628:	c9                   	leaveq 
  802629:	c3                   	retq   

000000000080262a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80262a:	55                   	push   %rbp
  80262b:	48 89 e5             	mov    %rsp,%rbp
  80262e:	48 83 ec 18          	sub    $0x18,%rsp
  802632:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802636:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80263d:	eb 6b                	jmp    8026aa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80263f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802642:	48 98                	cltq   
  802644:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80264a:	48 c1 e0 0c          	shl    $0xc,%rax
  80264e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802656:	48 89 c2             	mov    %rax,%rdx
  802659:	48 c1 ea 15          	shr    $0x15,%rdx
  80265d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802664:	01 00 00 
  802667:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266b:	83 e0 01             	and    $0x1,%eax
  80266e:	48 85 c0             	test   %rax,%rax
  802671:	74 21                	je     802694 <fd_alloc+0x6a>
  802673:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802677:	48 89 c2             	mov    %rax,%rdx
  80267a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80267e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802685:	01 00 00 
  802688:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268c:	83 e0 01             	and    $0x1,%eax
  80268f:	48 85 c0             	test   %rax,%rax
  802692:	75 12                	jne    8026a6 <fd_alloc+0x7c>
			*fd_store = fd;
  802694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802698:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80269c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 1a                	jmp    8026c0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8026a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026aa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026ae:	7e 8f                	jle    80263f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026bb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026c0:	c9                   	leaveq 
  8026c1:	c3                   	retq   

00000000008026c2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026c2:	55                   	push   %rbp
  8026c3:	48 89 e5             	mov    %rsp,%rbp
  8026c6:	48 83 ec 20          	sub    $0x20,%rsp
  8026ca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026d5:	78 06                	js     8026dd <fd_lookup+0x1b>
  8026d7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026db:	7e 07                	jle    8026e4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026e2:	eb 6c                	jmp    802750 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026e7:	48 98                	cltq   
  8026e9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026ef:	48 c1 e0 0c          	shl    $0xc,%rax
  8026f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026fb:	48 89 c2             	mov    %rax,%rdx
  8026fe:	48 c1 ea 15          	shr    $0x15,%rdx
  802702:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802709:	01 00 00 
  80270c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802710:	83 e0 01             	and    $0x1,%eax
  802713:	48 85 c0             	test   %rax,%rax
  802716:	74 21                	je     802739 <fd_lookup+0x77>
  802718:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271c:	48 89 c2             	mov    %rax,%rdx
  80271f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802723:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80272a:	01 00 00 
  80272d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802731:	83 e0 01             	and    $0x1,%eax
  802734:	48 85 c0             	test   %rax,%rax
  802737:	75 07                	jne    802740 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802739:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80273e:	eb 10                	jmp    802750 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802740:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802744:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802748:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802750:	c9                   	leaveq 
  802751:	c3                   	retq   

0000000000802752 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802752:	55                   	push   %rbp
  802753:	48 89 e5             	mov    %rsp,%rbp
  802756:	48 83 ec 30          	sub    $0x30,%rsp
  80275a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80275e:	89 f0                	mov    %esi,%eax
  802760:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802763:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802767:	48 89 c7             	mov    %rax,%rdi
  80276a:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  802771:	00 00 00 
  802774:	ff d0                	callq  *%rax
  802776:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80277a:	48 89 d6             	mov    %rdx,%rsi
  80277d:	89 c7                	mov    %eax,%edi
  80277f:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802786:	00 00 00 
  802789:	ff d0                	callq  *%rax
  80278b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802792:	78 0a                	js     80279e <fd_close+0x4c>
	    || fd != fd2)
  802794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802798:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80279c:	74 12                	je     8027b0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80279e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8027a2:	74 05                	je     8027a9 <fd_close+0x57>
  8027a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a7:	eb 05                	jmp    8027ae <fd_close+0x5c>
  8027a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ae:	eb 69                	jmp    802819 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b4:	8b 00                	mov    (%rax),%eax
  8027b6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027ba:	48 89 d6             	mov    %rdx,%rsi
  8027bd:	89 c7                	mov    %eax,%edi
  8027bf:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  8027c6:	00 00 00 
  8027c9:	ff d0                	callq  *%rax
  8027cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d2:	78 2a                	js     8027fe <fd_close+0xac>
		if (dev->dev_close)
  8027d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027dc:	48 85 c0             	test   %rax,%rax
  8027df:	74 16                	je     8027f7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8027e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8027e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ed:	48 89 c7             	mov    %rax,%rdi
  8027f0:	ff d2                	callq  *%rdx
  8027f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f5:	eb 07                	jmp    8027fe <fd_close+0xac>
		else
			r = 0;
  8027f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802802:	48 89 c6             	mov    %rax,%rsi
  802805:	bf 00 00 00 00       	mov    $0x0,%edi
  80280a:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  802811:	00 00 00 
  802814:	ff d0                	callq  *%rax
	return r;
  802816:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802819:	c9                   	leaveq 
  80281a:	c3                   	retq   

000000000080281b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80281b:	55                   	push   %rbp
  80281c:	48 89 e5             	mov    %rsp,%rbp
  80281f:	48 83 ec 20          	sub    $0x20,%rsp
  802823:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802826:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80282a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802831:	eb 41                	jmp    802874 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802833:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80283a:	00 00 00 
  80283d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802840:	48 63 d2             	movslq %edx,%rdx
  802843:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802847:	8b 00                	mov    (%rax),%eax
  802849:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80284c:	75 22                	jne    802870 <dev_lookup+0x55>
			*dev = devtab[i];
  80284e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802855:	00 00 00 
  802858:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80285b:	48 63 d2             	movslq %edx,%rdx
  80285e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802862:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802866:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
  80286e:	eb 60                	jmp    8028d0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802870:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802874:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80287b:	00 00 00 
  80287e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802881:	48 63 d2             	movslq %edx,%rdx
  802884:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802888:	48 85 c0             	test   %rax,%rax
  80288b:	75 a6                	jne    802833 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80288d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802894:	00 00 00 
  802897:	48 8b 00             	mov    (%rax),%rax
  80289a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8028a0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8028a3:	89 c6                	mov    %eax,%esi
  8028a5:	48 bf 98 4c 80 00 00 	movabs $0x804c98,%rdi
  8028ac:	00 00 00 
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	48 b9 db 04 80 00 00 	movabs $0x8004db,%rcx
  8028bb:	00 00 00 
  8028be:	ff d1                	callq  *%rcx
	*dev = 0;
  8028c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028c4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028d0:	c9                   	leaveq 
  8028d1:	c3                   	retq   

00000000008028d2 <close>:

int
close(int fdnum)
{
  8028d2:	55                   	push   %rbp
  8028d3:	48 89 e5             	mov    %rsp,%rbp
  8028d6:	48 83 ec 20          	sub    $0x20,%rsp
  8028da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e4:	48 89 d6             	mov    %rdx,%rsi
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
  8028f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fc:	79 05                	jns    802903 <close+0x31>
		return r;
  8028fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802901:	eb 18                	jmp    80291b <close+0x49>
	else
		return fd_close(fd, 1);
  802903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802907:	be 01 00 00 00       	mov    $0x1,%esi
  80290c:	48 89 c7             	mov    %rax,%rdi
  80290f:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
}
  80291b:	c9                   	leaveq 
  80291c:	c3                   	retq   

000000000080291d <close_all>:

void
close_all(void)
{
  80291d:	55                   	push   %rbp
  80291e:	48 89 e5             	mov    %rsp,%rbp
  802921:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802925:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80292c:	eb 15                	jmp    802943 <close_all+0x26>
		close(i);
  80292e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802931:	89 c7                	mov    %eax,%edi
  802933:	48 b8 d2 28 80 00 00 	movabs $0x8028d2,%rax
  80293a:	00 00 00 
  80293d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80293f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802943:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802947:	7e e5                	jle    80292e <close_all+0x11>
		close(i);
}
  802949:	c9                   	leaveq 
  80294a:	c3                   	retq   

000000000080294b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80294b:	55                   	push   %rbp
  80294c:	48 89 e5             	mov    %rsp,%rbp
  80294f:	48 83 ec 40          	sub    $0x40,%rsp
  802953:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802956:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802959:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80295d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802960:	48 89 d6             	mov    %rdx,%rsi
  802963:	89 c7                	mov    %eax,%edi
  802965:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  80296c:	00 00 00 
  80296f:	ff d0                	callq  *%rax
  802971:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802974:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802978:	79 08                	jns    802982 <dup+0x37>
		return r;
  80297a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297d:	e9 70 01 00 00       	jmpq   802af2 <dup+0x1a7>
	close(newfdnum);
  802982:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802985:	89 c7                	mov    %eax,%edi
  802987:	48 b8 d2 28 80 00 00 	movabs $0x8028d2,%rax
  80298e:	00 00 00 
  802991:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802993:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802996:	48 98                	cltq   
  802998:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80299e:	48 c1 e0 0c          	shl    $0xc,%rax
  8029a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029aa:	48 89 c7             	mov    %rax,%rdi
  8029ad:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	callq  *%rax
  8029b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c1:	48 89 c7             	mov    %rax,%rdi
  8029c4:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  8029cb:	00 00 00 
  8029ce:	ff d0                	callq  *%rax
  8029d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d8:	48 89 c2             	mov    %rax,%rdx
  8029db:	48 c1 ea 15          	shr    $0x15,%rdx
  8029df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029e6:	01 00 00 
  8029e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029ed:	83 e0 01             	and    $0x1,%eax
  8029f0:	84 c0                	test   %al,%al
  8029f2:	74 71                	je     802a65 <dup+0x11a>
  8029f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f8:	48 89 c2             	mov    %rax,%rdx
  8029fb:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a06:	01 00 00 
  802a09:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a0d:	83 e0 01             	and    $0x1,%eax
  802a10:	84 c0                	test   %al,%al
  802a12:	74 51                	je     802a65 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	48 89 c2             	mov    %rax,%rdx
  802a1b:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a1f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a26:	01 00 00 
  802a29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a2d:	89 c1                	mov    %eax,%ecx
  802a2f:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a35:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3d:	41 89 c8             	mov    %ecx,%r8d
  802a40:	48 89 d1             	mov    %rdx,%rcx
  802a43:	ba 00 00 00 00       	mov    $0x0,%edx
  802a48:	48 89 c6             	mov    %rax,%rsi
  802a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a50:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a63:	78 56                	js     802abb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a69:	48 89 c2             	mov    %rax,%rdx
  802a6c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802a70:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a77:	01 00 00 
  802a7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a7e:	89 c1                	mov    %eax,%ecx
  802a80:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a8e:	41 89 c8             	mov    %ecx,%r8d
  802a91:	48 89 d1             	mov    %rdx,%rcx
  802a94:	ba 00 00 00 00       	mov    $0x0,%edx
  802a99:	48 89 c6             	mov    %rax,%rsi
  802a9c:	bf 00 00 00 00       	mov    $0x0,%edi
  802aa1:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  802aa8:	00 00 00 
  802aab:	ff d0                	callq  *%rax
  802aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ab4:	78 08                	js     802abe <dup+0x173>
		goto err;

	return newfdnum;
  802ab6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ab9:	eb 37                	jmp    802af2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802abb:	90                   	nop
  802abc:	eb 01                	jmp    802abf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802abe:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802abf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac3:	48 89 c6             	mov    %rax,%rsi
  802ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  802acb:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ad7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802adb:	48 89 c6             	mov    %rax,%rsi
  802ade:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae3:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  802aea:	00 00 00 
  802aed:	ff d0                	callq  *%rax
	return r;
  802aef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802af2:	c9                   	leaveq 
  802af3:	c3                   	retq   

0000000000802af4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802af4:	55                   	push   %rbp
  802af5:	48 89 e5             	mov    %rsp,%rbp
  802af8:	48 83 ec 40          	sub    $0x40,%rsp
  802afc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802aff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b03:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b07:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b0b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b0e:	48 89 d6             	mov    %rdx,%rsi
  802b11:	89 c7                	mov    %eax,%edi
  802b13:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
  802b1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b26:	78 24                	js     802b4c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b2c:	8b 00                	mov    (%rax),%eax
  802b2e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b32:	48 89 d6             	mov    %rdx,%rsi
  802b35:	89 c7                	mov    %eax,%edi
  802b37:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  802b3e:	00 00 00 
  802b41:	ff d0                	callq  *%rax
  802b43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4a:	79 05                	jns    802b51 <read+0x5d>
		return r;
  802b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4f:	eb 7a                	jmp    802bcb <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b55:	8b 40 08             	mov    0x8(%rax),%eax
  802b58:	83 e0 03             	and    $0x3,%eax
  802b5b:	83 f8 01             	cmp    $0x1,%eax
  802b5e:	75 3a                	jne    802b9a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b60:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802b67:	00 00 00 
  802b6a:	48 8b 00             	mov    (%rax),%rax
  802b6d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b73:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b76:	89 c6                	mov    %eax,%esi
  802b78:	48 bf b7 4c 80 00 00 	movabs $0x804cb7,%rdi
  802b7f:	00 00 00 
  802b82:	b8 00 00 00 00       	mov    $0x0,%eax
  802b87:	48 b9 db 04 80 00 00 	movabs $0x8004db,%rcx
  802b8e:	00 00 00 
  802b91:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b98:	eb 31                	jmp    802bcb <read+0xd7>
	}
	if (!dev->dev_read)
  802b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b9e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ba2:	48 85 c0             	test   %rax,%rax
  802ba5:	75 07                	jne    802bae <read+0xba>
		return -E_NOT_SUPP;
  802ba7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bac:	eb 1d                	jmp    802bcb <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb2:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bbe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802bc2:	48 89 ce             	mov    %rcx,%rsi
  802bc5:	48 89 c7             	mov    %rax,%rdi
  802bc8:	41 ff d0             	callq  *%r8
}
  802bcb:	c9                   	leaveq 
  802bcc:	c3                   	retq   

0000000000802bcd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bcd:	55                   	push   %rbp
  802bce:	48 89 e5             	mov    %rsp,%rbp
  802bd1:	48 83 ec 30          	sub    $0x30,%rsp
  802bd5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bd8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bdc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802be0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802be7:	eb 46                	jmp    802c2f <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bec:	48 98                	cltq   
  802bee:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bf2:	48 29 c2             	sub    %rax,%rdx
  802bf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf8:	48 98                	cltq   
  802bfa:	48 89 c1             	mov    %rax,%rcx
  802bfd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802c01:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c04:	48 89 ce             	mov    %rcx,%rsi
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
  802c15:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c18:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c1c:	79 05                	jns    802c23 <readn+0x56>
			return m;
  802c1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c21:	eb 1d                	jmp    802c40 <readn+0x73>
		if (m == 0)
  802c23:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c27:	74 13                	je     802c3c <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c2c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c32:	48 98                	cltq   
  802c34:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c38:	72 af                	jb     802be9 <readn+0x1c>
  802c3a:	eb 01                	jmp    802c3d <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c3c:	90                   	nop
	}
	return tot;
  802c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c40:	c9                   	leaveq 
  802c41:	c3                   	retq   

0000000000802c42 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c42:	55                   	push   %rbp
  802c43:	48 89 e5             	mov    %rsp,%rbp
  802c46:	48 83 ec 40          	sub    $0x40,%rsp
  802c4a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c55:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c59:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c5c:	48 89 d6             	mov    %rdx,%rsi
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c74:	78 24                	js     802c9a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7a:	8b 00                	mov    (%rax),%eax
  802c7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c80:	48 89 d6             	mov    %rdx,%rsi
  802c83:	89 c7                	mov    %eax,%edi
  802c85:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  802c8c:	00 00 00 
  802c8f:	ff d0                	callq  *%rax
  802c91:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c94:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c98:	79 05                	jns    802c9f <write+0x5d>
		return r;
  802c9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9d:	eb 79                	jmp    802d18 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca3:	8b 40 08             	mov    0x8(%rax),%eax
  802ca6:	83 e0 03             	and    $0x3,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	75 3a                	jne    802ce7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802cad:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802cb4:	00 00 00 
  802cb7:	48 8b 00             	mov    (%rax),%rax
  802cba:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cc0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cc3:	89 c6                	mov    %eax,%esi
  802cc5:	48 bf d3 4c 80 00 00 	movabs $0x804cd3,%rdi
  802ccc:	00 00 00 
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd4:	48 b9 db 04 80 00 00 	movabs $0x8004db,%rcx
  802cdb:	00 00 00 
  802cde:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ce0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ce5:	eb 31                	jmp    802d18 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ce7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ceb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cef:	48 85 c0             	test   %rax,%rax
  802cf2:	75 07                	jne    802cfb <write+0xb9>
		return -E_NOT_SUPP;
  802cf4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf9:	eb 1d                	jmp    802d18 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cff:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802d03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d07:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d0b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d0f:	48 89 ce             	mov    %rcx,%rsi
  802d12:	48 89 c7             	mov    %rax,%rdi
  802d15:	41 ff d0             	callq  *%r8
}
  802d18:	c9                   	leaveq 
  802d19:	c3                   	retq   

0000000000802d1a <seek>:

int
seek(int fdnum, off_t offset)
{
  802d1a:	55                   	push   %rbp
  802d1b:	48 89 e5             	mov    %rsp,%rbp
  802d1e:	48 83 ec 18          	sub    $0x18,%rsp
  802d22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d25:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d28:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d2f:	48 89 d6             	mov    %rdx,%rsi
  802d32:	89 c7                	mov    %eax,%edi
  802d34:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802d3b:	00 00 00 
  802d3e:	ff d0                	callq  *%rax
  802d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d47:	79 05                	jns    802d4e <seek+0x34>
		return r;
  802d49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d4c:	eb 0f                	jmp    802d5d <seek+0x43>
	fd->fd_offset = offset;
  802d4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d52:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d5d:	c9                   	leaveq 
  802d5e:	c3                   	retq   

0000000000802d5f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d5f:	55                   	push   %rbp
  802d60:	48 89 e5             	mov    %rsp,%rbp
  802d63:	48 83 ec 30          	sub    $0x30,%rsp
  802d67:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d6a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d6d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d71:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d74:	48 89 d6             	mov    %rdx,%rsi
  802d77:	89 c7                	mov    %eax,%edi
  802d79:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
  802d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8c:	78 24                	js     802db2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d92:	8b 00                	mov    (%rax),%eax
  802d94:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d98:	48 89 d6             	mov    %rdx,%rsi
  802d9b:	89 c7                	mov    %eax,%edi
  802d9d:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  802da4:	00 00 00 
  802da7:	ff d0                	callq  *%rax
  802da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db0:	79 05                	jns    802db7 <ftruncate+0x58>
		return r;
  802db2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db5:	eb 72                	jmp    802e29 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbb:	8b 40 08             	mov    0x8(%rax),%eax
  802dbe:	83 e0 03             	and    $0x3,%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	75 3a                	jne    802dff <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802dc5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802dcc:	00 00 00 
  802dcf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dd2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dd8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ddb:	89 c6                	mov    %eax,%esi
  802ddd:	48 bf f0 4c 80 00 00 	movabs $0x804cf0,%rdi
  802de4:	00 00 00 
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dec:	48 b9 db 04 80 00 00 	movabs $0x8004db,%rcx
  802df3:	00 00 00 
  802df6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802df8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dfd:	eb 2a                	jmp    802e29 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e03:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e07:	48 85 c0             	test   %rax,%rax
  802e0a:	75 07                	jne    802e13 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e0c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e11:	eb 16                	jmp    802e29 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e17:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802e22:	89 d6                	mov    %edx,%esi
  802e24:	48 89 c7             	mov    %rax,%rdi
  802e27:	ff d1                	callq  *%rcx
}
  802e29:	c9                   	leaveq 
  802e2a:	c3                   	retq   

0000000000802e2b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e2b:	55                   	push   %rbp
  802e2c:	48 89 e5             	mov    %rsp,%rbp
  802e2f:	48 83 ec 30          	sub    $0x30,%rsp
  802e33:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e3a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e41:	48 89 d6             	mov    %rdx,%rsi
  802e44:	89 c7                	mov    %eax,%edi
  802e46:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
  802e52:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e55:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e59:	78 24                	js     802e7f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5f:	8b 00                	mov    (%rax),%eax
  802e61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e65:	48 89 d6             	mov    %rdx,%rsi
  802e68:	89 c7                	mov    %eax,%edi
  802e6a:	48 b8 1b 28 80 00 00 	movabs $0x80281b,%rax
  802e71:	00 00 00 
  802e74:	ff d0                	callq  *%rax
  802e76:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7d:	79 05                	jns    802e84 <fstat+0x59>
		return r;
  802e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e82:	eb 5e                	jmp    802ee2 <fstat+0xb7>
	if (!dev->dev_stat)
  802e84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e88:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e8c:	48 85 c0             	test   %rax,%rax
  802e8f:	75 07                	jne    802e98 <fstat+0x6d>
		return -E_NOT_SUPP;
  802e91:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e96:	eb 4a                	jmp    802ee2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e9c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ea3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802eaa:	00 00 00 
	stat->st_isdir = 0;
  802ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802eb8:	00 00 00 
	stat->st_dev = dev;
  802ebb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ebf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ec3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802eca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ece:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ed6:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802eda:	48 89 d6             	mov    %rdx,%rsi
  802edd:	48 89 c7             	mov    %rax,%rdi
  802ee0:	ff d1                	callq  *%rcx
}
  802ee2:	c9                   	leaveq 
  802ee3:	c3                   	retq   

0000000000802ee4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ee4:	55                   	push   %rbp
  802ee5:	48 89 e5             	mov    %rsp,%rbp
  802ee8:	48 83 ec 20          	sub    $0x20,%rsp
  802eec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ef0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ef4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef8:	be 00 00 00 00       	mov    $0x0,%esi
  802efd:	48 89 c7             	mov    %rax,%rdi
  802f00:	48 b8 d3 2f 80 00 00 	movabs $0x802fd3,%rax
  802f07:	00 00 00 
  802f0a:	ff d0                	callq  *%rax
  802f0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f13:	79 05                	jns    802f1a <stat+0x36>
		return fd;
  802f15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f18:	eb 2f                	jmp    802f49 <stat+0x65>
	r = fstat(fd, stat);
  802f1a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f21:	48 89 d6             	mov    %rdx,%rsi
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 2b 2e 80 00 00 	movabs $0x802e2b,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f38:	89 c7                	mov    %eax,%edi
  802f3a:	48 b8 d2 28 80 00 00 	movabs $0x8028d2,%rax
  802f41:	00 00 00 
  802f44:	ff d0                	callq  *%rax
	return r;
  802f46:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f49:	c9                   	leaveq 
  802f4a:	c3                   	retq   
	...

0000000000802f4c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f4c:	55                   	push   %rbp
  802f4d:	48 89 e5             	mov    %rsp,%rbp
  802f50:	48 83 ec 10          	sub    $0x10,%rsp
  802f54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f5b:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802f62:	00 00 00 
  802f65:	8b 00                	mov    (%rax),%eax
  802f67:	85 c0                	test   %eax,%eax
  802f69:	75 1d                	jne    802f88 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f6b:	bf 01 00 00 00       	mov    $0x1,%edi
  802f70:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  802f77:	00 00 00 
  802f7a:	ff d0                	callq  *%rax
  802f7c:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  802f83:	00 00 00 
  802f86:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f88:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  802f8f:	00 00 00 
  802f92:	8b 00                	mov    (%rax),%eax
  802f94:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f97:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f9c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802fa3:	00 00 00 
  802fa6:	89 c7                	mov    %eax,%edi
  802fa8:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  802fbd:	48 89 c6             	mov    %rax,%rsi
  802fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  802fc5:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
}
  802fd1:	c9                   	leaveq 
  802fd2:	c3                   	retq   

0000000000802fd3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fd3:	55                   	push   %rbp
  802fd4:	48 89 e5             	mov    %rsp,%rbp
  802fd7:	48 83 ec 20          	sub    $0x20,%rsp
  802fdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fdf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe6:	48 89 c7             	mov    %rax,%rdi
  802fe9:	48 b8 2c 10 80 00 00 	movabs $0x80102c,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
  802ff5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ffa:	7e 0a                	jle    803006 <open+0x33>
                return -E_BAD_PATH;
  802ffc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803001:	e9 a5 00 00 00       	jmpq   8030ab <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  803006:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80300a:	48 89 c7             	mov    %rax,%rdi
  80300d:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803014:	00 00 00 
  803017:	ff d0                	callq  *%rax
  803019:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80301c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803020:	79 08                	jns    80302a <open+0x57>
		return r;
  803022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803025:	e9 81 00 00 00       	jmpq   8030ab <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  80302a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302e:	48 89 c6             	mov    %rax,%rsi
  803031:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803038:	00 00 00 
  80303b:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  803042:	00 00 00 
  803045:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  803047:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80304e:	00 00 00 
  803051:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803054:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80305a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305e:	48 89 c6             	mov    %rax,%rsi
  803061:	bf 01 00 00 00       	mov    $0x1,%edi
  803066:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  803075:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803079:	79 1d                	jns    803098 <open+0xc5>
	{
		fd_close(fd,0);
  80307b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307f:	be 00 00 00 00       	mov    $0x0,%esi
  803084:	48 89 c7             	mov    %rax,%rdi
  803087:	48 b8 52 27 80 00 00 	movabs $0x802752,%rax
  80308e:	00 00 00 
  803091:	ff d0                	callq  *%rax
		return r;
  803093:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803096:	eb 13                	jmp    8030ab <open+0xd8>
	}
	return fd2num(fd);
  803098:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80309c:	48 89 c7             	mov    %rax,%rdi
  80309f:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8030a6:	00 00 00 
  8030a9:	ff d0                	callq  *%rax
	


}
  8030ab:	c9                   	leaveq 
  8030ac:	c3                   	retq   

00000000008030ad <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030ad:	55                   	push   %rbp
  8030ae:	48 89 e5             	mov    %rsp,%rbp
  8030b1:	48 83 ec 10          	sub    $0x10,%rsp
  8030b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030bd:	8b 50 0c             	mov    0xc(%rax),%edx
  8030c0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030c7:	00 00 00 
  8030ca:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030cc:	be 00 00 00 00       	mov    $0x0,%esi
  8030d1:	bf 06 00 00 00       	mov    $0x6,%edi
  8030d6:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  8030dd:	00 00 00 
  8030e0:	ff d0                	callq  *%rax
}
  8030e2:	c9                   	leaveq 
  8030e3:	c3                   	retq   

00000000008030e4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030e4:	55                   	push   %rbp
  8030e5:	48 89 e5             	mov    %rsp,%rbp
  8030e8:	48 83 ec 30          	sub    $0x30,%rsp
  8030ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8030ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803106:	00 00 00 
  803109:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80310b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803112:	00 00 00 
  803115:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803119:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80311d:	be 00 00 00 00       	mov    $0x0,%esi
  803122:	bf 03 00 00 00       	mov    $0x3,%edi
  803127:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80312e:	00 00 00 
  803131:	ff d0                	callq  *%rax
  803133:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803136:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80313a:	79 05                	jns    803141 <devfile_read+0x5d>
	{
		return r;
  80313c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313f:	eb 2c                	jmp    80316d <devfile_read+0x89>
	}
	if(r > 0)
  803141:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803145:	7e 23                	jle    80316a <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803147:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314a:	48 63 d0             	movslq %eax,%rdx
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803158:	00 00 00 
  80315b:	48 89 c7             	mov    %rax,%rdi
  80315e:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  803165:	00 00 00 
  803168:	ff d0                	callq  *%rax
	return r;
  80316a:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  80316d:	c9                   	leaveq 
  80316e:	c3                   	retq   

000000000080316f <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80316f:	55                   	push   %rbp
  803170:	48 89 e5             	mov    %rsp,%rbp
  803173:	48 83 ec 30          	sub    $0x30,%rsp
  803177:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80317b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80317f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  803183:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803187:	8b 50 0c             	mov    0xc(%rax),%edx
  80318a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803191:	00 00 00 
  803194:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803196:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80319d:	00 
  80319e:	76 08                	jbe    8031a8 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8031a0:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8031a7:	00 
	fsipcbuf.write.req_n=n;
  8031a8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031af:	00 00 00 
  8031b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031b6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8031ba:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c2:	48 89 c6             	mov    %rax,%rsi
  8031c5:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  8031cc:	00 00 00 
  8031cf:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8031d6:	00 00 00 
  8031d9:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  8031db:	be 00 00 00 00       	mov    $0x0,%esi
  8031e0:	bf 04 00 00 00       	mov    $0x4,%edi
  8031e5:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  8031ec:	00 00 00 
  8031ef:	ff d0                	callq  *%rax
  8031f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8031f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031f7:	c9                   	leaveq 
  8031f8:	c3                   	retq   

00000000008031f9 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8031f9:	55                   	push   %rbp
  8031fa:	48 89 e5             	mov    %rsp,%rbp
  8031fd:	48 83 ec 10          	sub    $0x10,%rsp
  803201:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803205:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80320c:	8b 50 0c             	mov    0xc(%rax),%edx
  80320f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803216:	00 00 00 
  803219:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80321b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803222:	00 00 00 
  803225:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803228:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80322b:	be 00 00 00 00       	mov    $0x0,%esi
  803230:	bf 02 00 00 00       	mov    $0x2,%edi
  803235:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
}
  803241:	c9                   	leaveq 
  803242:	c3                   	retq   

0000000000803243 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803243:	55                   	push   %rbp
  803244:	48 89 e5             	mov    %rsp,%rbp
  803247:	48 83 ec 20          	sub    $0x20,%rsp
  80324b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80324f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803257:	8b 50 0c             	mov    0xc(%rax),%edx
  80325a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803261:	00 00 00 
  803264:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803266:	be 00 00 00 00       	mov    $0x0,%esi
  80326b:	bf 05 00 00 00       	mov    $0x5,%edi
  803270:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80327f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803283:	79 05                	jns    80328a <devfile_stat+0x47>
		return r;
  803285:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803288:	eb 56                	jmp    8032e0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80328a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80328e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803295:	00 00 00 
  803298:	48 89 c7             	mov    %rax,%rdi
  80329b:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  8032a2:	00 00 00 
  8032a5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8032a7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032ae:	00 00 00 
  8032b1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8032b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8032c1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032c8:	00 00 00 
  8032cb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8032d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032d5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8032db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032e0:	c9                   	leaveq 
  8032e1:	c3                   	retq   
	...

00000000008032e4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8032e4:	55                   	push   %rbp
  8032e5:	48 89 e5             	mov    %rsp,%rbp
  8032e8:	48 83 ec 20          	sub    $0x20,%rsp
  8032ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8032ef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032f6:	48 89 d6             	mov    %rdx,%rsi
  8032f9:	89 c7                	mov    %eax,%edi
  8032fb:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  803302:	00 00 00 
  803305:	ff d0                	callq  *%rax
  803307:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330e:	79 05                	jns    803315 <fd2sockid+0x31>
		return r;
  803310:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803313:	eb 24                	jmp    803339 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	8b 10                	mov    (%rax),%edx
  80331b:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803322:	00 00 00 
  803325:	8b 00                	mov    (%rax),%eax
  803327:	39 c2                	cmp    %eax,%edx
  803329:	74 07                	je     803332 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80332b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803330:	eb 07                	jmp    803339 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803336:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803339:	c9                   	leaveq 
  80333a:	c3                   	retq   

000000000080333b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80333b:	55                   	push   %rbp
  80333c:	48 89 e5             	mov    %rsp,%rbp
  80333f:	48 83 ec 20          	sub    $0x20,%rsp
  803343:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803346:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80334a:	48 89 c7             	mov    %rax,%rdi
  80334d:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803360:	78 26                	js     803388 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803362:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803366:	ba 07 04 00 00       	mov    $0x407,%edx
  80336b:	48 89 c6             	mov    %rax,%rsi
  80336e:	bf 00 00 00 00       	mov    $0x0,%edi
  803373:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80337a:	00 00 00 
  80337d:	ff d0                	callq  *%rax
  80337f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803386:	79 16                	jns    80339e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803388:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338b:	89 c7                	mov    %eax,%edi
  80338d:	48 b8 48 38 80 00 00 	movabs $0x803848,%rax
  803394:	00 00 00 
  803397:	ff d0                	callq  *%rax
		return r;
  803399:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339c:	eb 3a                	jmp    8033d8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80339e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a2:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8033a9:	00 00 00 
  8033ac:	8b 12                	mov    (%rdx),%edx
  8033ae:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8033b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8033bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033bf:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8033c2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8033c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c9:	48 89 c7             	mov    %rax,%rdi
  8033cc:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
}
  8033d8:	c9                   	leaveq 
  8033d9:	c3                   	retq   

00000000008033da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8033da:	55                   	push   %rbp
  8033db:	48 89 e5             	mov    %rsp,%rbp
  8033de:	48 83 ec 30          	sub    $0x30,%rsp
  8033e2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033f0:	89 c7                	mov    %eax,%edi
  8033f2:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
  8033fe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803401:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803405:	79 05                	jns    80340c <accept+0x32>
		return r;
  803407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80340a:	eb 3b                	jmp    803447 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80340c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803410:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803417:	48 89 ce             	mov    %rcx,%rsi
  80341a:	89 c7                	mov    %eax,%edi
  80341c:	48 b8 25 37 80 00 00 	movabs $0x803725,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
  803428:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342f:	79 05                	jns    803436 <accept+0x5c>
		return r;
  803431:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803434:	eb 11                	jmp    803447 <accept+0x6d>
	return alloc_sockfd(r);
  803436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803439:	89 c7                	mov    %eax,%edi
  80343b:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
}
  803447:	c9                   	leaveq 
  803448:	c3                   	retq   

0000000000803449 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803449:	55                   	push   %rbp
  80344a:	48 89 e5             	mov    %rsp,%rbp
  80344d:	48 83 ec 20          	sub    $0x20,%rsp
  803451:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803454:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803458:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80345b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80345e:	89 c7                	mov    %eax,%edi
  803460:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
  80346c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803473:	79 05                	jns    80347a <bind+0x31>
		return r;
  803475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803478:	eb 1b                	jmp    803495 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80347a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80347d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803481:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803484:	48 89 ce             	mov    %rcx,%rsi
  803487:	89 c7                	mov    %eax,%edi
  803489:	48 b8 a4 37 80 00 00 	movabs $0x8037a4,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
}
  803495:	c9                   	leaveq 
  803496:	c3                   	retq   

0000000000803497 <shutdown>:

int
shutdown(int s, int how)
{
  803497:	55                   	push   %rbp
  803498:	48 89 e5             	mov    %rsp,%rbp
  80349b:	48 83 ec 20          	sub    $0x20,%rsp
  80349f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034a2:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034a8:	89 c7                	mov    %eax,%edi
  8034aa:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  8034b1:	00 00 00 
  8034b4:	ff d0                	callq  *%rax
  8034b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034bd:	79 05                	jns    8034c4 <shutdown+0x2d>
		return r;
  8034bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c2:	eb 16                	jmp    8034da <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8034c4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ca:	89 d6                	mov    %edx,%esi
  8034cc:	89 c7                	mov    %eax,%edi
  8034ce:	48 b8 08 38 80 00 00 	movabs $0x803808,%rax
  8034d5:	00 00 00 
  8034d8:	ff d0                	callq  *%rax
}
  8034da:	c9                   	leaveq 
  8034db:	c3                   	retq   

00000000008034dc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8034dc:	55                   	push   %rbp
  8034dd:	48 89 e5             	mov    %rsp,%rbp
  8034e0:	48 83 ec 10          	sub    $0x10,%rsp
  8034e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8034e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ec:	48 89 c7             	mov    %rax,%rdi
  8034ef:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  8034f6:	00 00 00 
  8034f9:	ff d0                	callq  *%rax
  8034fb:	83 f8 01             	cmp    $0x1,%eax
  8034fe:	75 17                	jne    803517 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803500:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803504:	8b 40 0c             	mov    0xc(%rax),%eax
  803507:	89 c7                	mov    %eax,%edi
  803509:	48 b8 48 38 80 00 00 	movabs $0x803848,%rax
  803510:	00 00 00 
  803513:	ff d0                	callq  *%rax
  803515:	eb 05                	jmp    80351c <devsock_close+0x40>
	else
		return 0;
  803517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80351c:	c9                   	leaveq 
  80351d:	c3                   	retq   

000000000080351e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80351e:	55                   	push   %rbp
  80351f:	48 89 e5             	mov    %rsp,%rbp
  803522:	48 83 ec 20          	sub    $0x20,%rsp
  803526:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803529:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80352d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803530:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803533:	89 c7                	mov    %eax,%edi
  803535:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  80353c:	00 00 00 
  80353f:	ff d0                	callq  *%rax
  803541:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803544:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803548:	79 05                	jns    80354f <connect+0x31>
		return r;
  80354a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354d:	eb 1b                	jmp    80356a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80354f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803552:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803556:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803559:	48 89 ce             	mov    %rcx,%rsi
  80355c:	89 c7                	mov    %eax,%edi
  80355e:	48 b8 75 38 80 00 00 	movabs $0x803875,%rax
  803565:	00 00 00 
  803568:	ff d0                	callq  *%rax
}
  80356a:	c9                   	leaveq 
  80356b:	c3                   	retq   

000000000080356c <listen>:

int
listen(int s, int backlog)
{
  80356c:	55                   	push   %rbp
  80356d:	48 89 e5             	mov    %rsp,%rbp
  803570:	48 83 ec 20          	sub    $0x20,%rsp
  803574:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803577:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80357a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357d:	89 c7                	mov    %eax,%edi
  80357f:	48 b8 e4 32 80 00 00 	movabs $0x8032e4,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803592:	79 05                	jns    803599 <listen+0x2d>
		return r;
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803597:	eb 16                	jmp    8035af <listen+0x43>
	return nsipc_listen(r, backlog);
  803599:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80359c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359f:	89 d6                	mov    %edx,%esi
  8035a1:	89 c7                	mov    %eax,%edi
  8035a3:	48 b8 d9 38 80 00 00 	movabs $0x8038d9,%rax
  8035aa:	00 00 00 
  8035ad:	ff d0                	callq  *%rax
}
  8035af:	c9                   	leaveq 
  8035b0:	c3                   	retq   

00000000008035b1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8035b1:	55                   	push   %rbp
  8035b2:	48 89 e5             	mov    %rsp,%rbp
  8035b5:	48 83 ec 20          	sub    $0x20,%rsp
  8035b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8035c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c9:	89 c2                	mov    %eax,%edx
  8035cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cf:	8b 40 0c             	mov    0xc(%rax),%eax
  8035d2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8035d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8035db:	89 c7                	mov    %eax,%edi
  8035dd:	48 b8 19 39 80 00 00 	movabs $0x803919,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
}
  8035e9:	c9                   	leaveq 
  8035ea:	c3                   	retq   

00000000008035eb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	48 83 ec 20          	sub    $0x20,%rsp
  8035f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035f7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035fb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8035ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803603:	89 c2                	mov    %eax,%edx
  803605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803609:	8b 40 0c             	mov    0xc(%rax),%eax
  80360c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803610:	b9 00 00 00 00       	mov    $0x0,%ecx
  803615:	89 c7                	mov    %eax,%edi
  803617:	48 b8 e5 39 80 00 00 	movabs $0x8039e5,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
}
  803623:	c9                   	leaveq 
  803624:	c3                   	retq   

0000000000803625 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803625:	55                   	push   %rbp
  803626:	48 89 e5             	mov    %rsp,%rbp
  803629:	48 83 ec 10          	sub    $0x10,%rsp
  80362d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803631:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803639:	48 be 1b 4d 80 00 00 	movabs $0x804d1b,%rsi
  803640:	00 00 00 
  803643:	48 89 c7             	mov    %rax,%rdi
  803646:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  80364d:	00 00 00 
  803650:	ff d0                	callq  *%rax
	return 0;
  803652:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803657:	c9                   	leaveq 
  803658:	c3                   	retq   

0000000000803659 <socket>:

int
socket(int domain, int type, int protocol)
{
  803659:	55                   	push   %rbp
  80365a:	48 89 e5             	mov    %rsp,%rbp
  80365d:	48 83 ec 20          	sub    $0x20,%rsp
  803661:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803664:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803667:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80366a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80366d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803670:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803673:	89 ce                	mov    %ecx,%esi
  803675:	89 c7                	mov    %eax,%edi
  803677:	48 b8 9d 3a 80 00 00 	movabs $0x803a9d,%rax
  80367e:	00 00 00 
  803681:	ff d0                	callq  *%rax
  803683:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803686:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80368a:	79 05                	jns    803691 <socket+0x38>
		return r;
  80368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368f:	eb 11                	jmp    8036a2 <socket+0x49>
	return alloc_sockfd(r);
  803691:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803694:	89 c7                	mov    %eax,%edi
  803696:	48 b8 3b 33 80 00 00 	movabs $0x80333b,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
}
  8036a2:	c9                   	leaveq 
  8036a3:	c3                   	retq   

00000000008036a4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8036a4:	55                   	push   %rbp
  8036a5:	48 89 e5             	mov    %rsp,%rbp
  8036a8:	48 83 ec 10          	sub    $0x10,%rsp
  8036ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8036af:	48 b8 34 70 80 00 00 	movabs $0x807034,%rax
  8036b6:	00 00 00 
  8036b9:	8b 00                	mov    (%rax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	75 1d                	jne    8036dc <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8036bf:	bf 02 00 00 00       	mov    $0x2,%edi
  8036c4:	48 b8 57 25 80 00 00 	movabs $0x802557,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
  8036d0:	48 ba 34 70 80 00 00 	movabs $0x807034,%rdx
  8036d7:	00 00 00 
  8036da:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8036dc:	48 b8 34 70 80 00 00 	movabs $0x807034,%rax
  8036e3:	00 00 00 
  8036e6:	8b 00                	mov    (%rax),%eax
  8036e8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8036eb:	b9 07 00 00 00       	mov    $0x7,%ecx
  8036f0:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8036f7:	00 00 00 
  8036fa:	89 c7                	mov    %eax,%edi
  8036fc:	48 b8 94 24 80 00 00 	movabs $0x802494,%rax
  803703:	00 00 00 
  803706:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803708:	ba 00 00 00 00       	mov    $0x0,%edx
  80370d:	be 00 00 00 00       	mov    $0x0,%esi
  803712:	bf 00 00 00 00       	mov    $0x0,%edi
  803717:	48 b8 d4 23 80 00 00 	movabs $0x8023d4,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
}
  803723:	c9                   	leaveq 
  803724:	c3                   	retq   

0000000000803725 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803725:	55                   	push   %rbp
  803726:	48 89 e5             	mov    %rsp,%rbp
  803729:	48 83 ec 30          	sub    $0x30,%rsp
  80372d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803730:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803734:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803738:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80373f:	00 00 00 
  803742:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803745:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803747:	bf 01 00 00 00       	mov    $0x1,%edi
  80374c:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803753:	00 00 00 
  803756:	ff d0                	callq  *%rax
  803758:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80375b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80375f:	78 3e                	js     80379f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803761:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803768:	00 00 00 
  80376b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80376f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803773:	8b 40 10             	mov    0x10(%rax),%eax
  803776:	89 c2                	mov    %eax,%edx
  803778:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80377c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803780:	48 89 ce             	mov    %rcx,%rsi
  803783:	48 89 c7             	mov    %rax,%rdi
  803786:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803796:	8b 50 10             	mov    0x10(%rax),%edx
  803799:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80379d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8037a2:	c9                   	leaveq 
  8037a3:	c3                   	retq   

00000000008037a4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8037a4:	55                   	push   %rbp
  8037a5:	48 89 e5             	mov    %rsp,%rbp
  8037a8:	48 83 ec 10          	sub    $0x10,%rsp
  8037ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037b3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8037b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037bd:	00 00 00 
  8037c0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037c3:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8037c5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037cc:	48 89 c6             	mov    %rax,%rsi
  8037cf:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037d6:	00 00 00 
  8037d9:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8037e0:	00 00 00 
  8037e3:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8037e5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ec:	00 00 00 
  8037ef:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f2:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8037f5:	bf 02 00 00 00       	mov    $0x2,%edi
  8037fa:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
}
  803806:	c9                   	leaveq 
  803807:	c3                   	retq   

0000000000803808 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803808:	55                   	push   %rbp
  803809:	48 89 e5             	mov    %rsp,%rbp
  80380c:	48 83 ec 10          	sub    $0x10,%rsp
  803810:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803813:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803816:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80381d:	00 00 00 
  803820:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803823:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803825:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80382c:	00 00 00 
  80382f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803832:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803835:	bf 03 00 00 00       	mov    $0x3,%edi
  80383a:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
}
  803846:	c9                   	leaveq 
  803847:	c3                   	retq   

0000000000803848 <nsipc_close>:

int
nsipc_close(int s)
{
  803848:	55                   	push   %rbp
  803849:	48 89 e5             	mov    %rsp,%rbp
  80384c:	48 83 ec 10          	sub    $0x10,%rsp
  803850:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803853:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80385a:	00 00 00 
  80385d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803860:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803862:	bf 04 00 00 00       	mov    $0x4,%edi
  803867:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 10          	sub    $0x10,%rsp
  80387d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803884:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803887:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80388e:	00 00 00 
  803891:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803894:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803896:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803899:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389d:	48 89 c6             	mov    %rax,%rsi
  8038a0:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8038a7:	00 00 00 
  8038aa:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8038b1:	00 00 00 
  8038b4:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8038b6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038bd:	00 00 00 
  8038c0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038c3:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8038c6:	bf 05 00 00 00       	mov    $0x5,%edi
  8038cb:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  8038d2:	00 00 00 
  8038d5:	ff d0                	callq  *%rax
}
  8038d7:	c9                   	leaveq 
  8038d8:	c3                   	retq   

00000000008038d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8038d9:	55                   	push   %rbp
  8038da:	48 89 e5             	mov    %rsp,%rbp
  8038dd:	48 83 ec 10          	sub    $0x10,%rsp
  8038e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038e4:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8038e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038ee:	00 00 00 
  8038f1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038f4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8038f6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038fd:	00 00 00 
  803900:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803903:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803906:	bf 06 00 00 00       	mov    $0x6,%edi
  80390b:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803912:	00 00 00 
  803915:	ff d0                	callq  *%rax
}
  803917:	c9                   	leaveq 
  803918:	c3                   	retq   

0000000000803919 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803919:	55                   	push   %rbp
  80391a:	48 89 e5             	mov    %rsp,%rbp
  80391d:	48 83 ec 30          	sub    $0x30,%rsp
  803921:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803924:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803928:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80392b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80392e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803935:	00 00 00 
  803938:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80393b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80393d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803944:	00 00 00 
  803947:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80394a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80394d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803954:	00 00 00 
  803957:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80395a:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80395d:	bf 07 00 00 00       	mov    $0x7,%edi
  803962:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803969:	00 00 00 
  80396c:	ff d0                	callq  *%rax
  80396e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803971:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803975:	78 69                	js     8039e0 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803977:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80397e:	7f 08                	jg     803988 <nsipc_recv+0x6f>
  803980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803983:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803986:	7e 35                	jle    8039bd <nsipc_recv+0xa4>
  803988:	48 b9 22 4d 80 00 00 	movabs $0x804d22,%rcx
  80398f:	00 00 00 
  803992:	48 ba 37 4d 80 00 00 	movabs $0x804d37,%rdx
  803999:	00 00 00 
  80399c:	be 61 00 00 00       	mov    $0x61,%esi
  8039a1:	48 bf 4c 4d 80 00 00 	movabs $0x804d4c,%rdi
  8039a8:	00 00 00 
  8039ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b0:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  8039b7:	00 00 00 
  8039ba:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8039bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039c0:	48 63 d0             	movslq %eax,%rdx
  8039c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039c7:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8039ce:	00 00 00 
  8039d1:	48 89 c7             	mov    %rax,%rdi
  8039d4:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8039db:	00 00 00 
  8039de:	ff d0                	callq  *%rax
	}

	return r;
  8039e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039e3:	c9                   	leaveq 
  8039e4:	c3                   	retq   

00000000008039e5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8039e5:	55                   	push   %rbp
  8039e6:	48 89 e5             	mov    %rsp,%rbp
  8039e9:	48 83 ec 20          	sub    $0x20,%rsp
  8039ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039f4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8039f7:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8039fa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a01:	00 00 00 
  803a04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a07:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a09:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a10:	7e 35                	jle    803a47 <nsipc_send+0x62>
  803a12:	48 b9 58 4d 80 00 00 	movabs $0x804d58,%rcx
  803a19:	00 00 00 
  803a1c:	48 ba 37 4d 80 00 00 	movabs $0x804d37,%rdx
  803a23:	00 00 00 
  803a26:	be 6c 00 00 00       	mov    $0x6c,%esi
  803a2b:	48 bf 4c 4d 80 00 00 	movabs $0x804d4c,%rdi
  803a32:	00 00 00 
  803a35:	b8 00 00 00 00       	mov    $0x0,%eax
  803a3a:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  803a41:	00 00 00 
  803a44:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803a47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a4a:	48 63 d0             	movslq %eax,%rdx
  803a4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a51:	48 89 c6             	mov    %rax,%rsi
  803a54:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803a5b:	00 00 00 
  803a5e:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  803a65:	00 00 00 
  803a68:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803a6a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a71:	00 00 00 
  803a74:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a77:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803a7a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a81:	00 00 00 
  803a84:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a87:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803a8a:	bf 08 00 00 00       	mov    $0x8,%edi
  803a8f:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803a96:	00 00 00 
  803a99:	ff d0                	callq  *%rax
}
  803a9b:	c9                   	leaveq 
  803a9c:	c3                   	retq   

0000000000803a9d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803a9d:	55                   	push   %rbp
  803a9e:	48 89 e5             	mov    %rsp,%rbp
  803aa1:	48 83 ec 10          	sub    $0x10,%rsp
  803aa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803aa8:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803aab:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803aae:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ab5:	00 00 00 
  803ab8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803abb:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803abd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ac4:	00 00 00 
  803ac7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aca:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803acd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ad4:	00 00 00 
  803ad7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ada:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803add:	bf 09 00 00 00       	mov    $0x9,%edi
  803ae2:	48 b8 a4 36 80 00 00 	movabs $0x8036a4,%rax
  803ae9:	00 00 00 
  803aec:	ff d0                	callq  *%rax
}
  803aee:	c9                   	leaveq 
  803aef:	c3                   	retq   

0000000000803af0 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803af0:	55                   	push   %rbp
  803af1:	48 89 e5             	mov    %rsp,%rbp
  803af4:	53                   	push   %rbx
  803af5:	48 83 ec 38          	sub    $0x38,%rsp
  803af9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803afd:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b01:	48 89 c7             	mov    %rax,%rdi
  803b04:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
  803b10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b13:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b17:	0f 88 bf 01 00 00    	js     803cdc <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b21:	ba 07 04 00 00       	mov    $0x407,%edx
  803b26:	48 89 c6             	mov    %rax,%rsi
  803b29:	bf 00 00 00 00       	mov    $0x0,%edi
  803b2e:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803b35:	00 00 00 
  803b38:	ff d0                	callq  *%rax
  803b3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b41:	0f 88 95 01 00 00    	js     803cdc <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803b47:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803b4b:	48 89 c7             	mov    %rax,%rdi
  803b4e:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  803b55:	00 00 00 
  803b58:	ff d0                	callq  *%rax
  803b5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b61:	0f 88 5d 01 00 00    	js     803cc4 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b6b:	ba 07 04 00 00       	mov    $0x407,%edx
  803b70:	48 89 c6             	mov    %rax,%rsi
  803b73:	bf 00 00 00 00       	mov    $0x0,%edi
  803b78:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
  803b84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b87:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b8b:	0f 88 33 01 00 00    	js     803cc4 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803b91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b95:	48 89 c7             	mov    %rax,%rdi
  803b98:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803b9f:	00 00 00 
  803ba2:	ff d0                	callq  *%rax
  803ba4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ba8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bac:	ba 07 04 00 00       	mov    $0x407,%edx
  803bb1:	48 89 c6             	mov    %rax,%rsi
  803bb4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb9:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
  803bc5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bcc:	0f 88 d9 00 00 00    	js     803cab <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bd2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd6:	48 89 c7             	mov    %rax,%rdi
  803bd9:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803be0:	00 00 00 
  803be3:	ff d0                	callq  *%rax
  803be5:	48 89 c2             	mov    %rax,%rdx
  803be8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bec:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803bf2:	48 89 d1             	mov    %rdx,%rcx
  803bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  803bfa:	48 89 c6             	mov    %rax,%rsi
  803bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  803c02:	48 b8 20 1a 80 00 00 	movabs $0x801a20,%rax
  803c09:	00 00 00 
  803c0c:	ff d0                	callq  *%rax
  803c0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c15:	78 79                	js     803c90 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1b:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c22:	00 00 00 
  803c25:	8b 12                	mov    (%rdx),%edx
  803c27:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803c29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803c34:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c38:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803c3f:	00 00 00 
  803c42:	8b 12                	mov    (%rdx),%edx
  803c44:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803c46:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c4a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c55:	48 89 c7             	mov    %rax,%rdi
  803c58:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803c5f:	00 00 00 
  803c62:	ff d0                	callq  *%rax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c6a:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803c6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c70:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803c74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c78:	48 89 c7             	mov    %rax,%rdi
  803c7b:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  803c82:	00 00 00 
  803c85:	ff d0                	callq  *%rax
  803c87:	89 03                	mov    %eax,(%rbx)
	return 0;
  803c89:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8e:	eb 4f                	jmp    803cdf <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803c90:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803c91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c95:	48 89 c6             	mov    %rax,%rsi
  803c98:	bf 00 00 00 00       	mov    $0x0,%edi
  803c9d:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  803ca4:	00 00 00 
  803ca7:	ff d0                	callq  *%rax
  803ca9:	eb 01                	jmp    803cac <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803cab:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803cac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cb0:	48 89 c6             	mov    %rax,%rsi
  803cb3:	bf 00 00 00 00       	mov    $0x0,%edi
  803cb8:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  803cbf:	00 00 00 
  803cc2:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803cc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc8:	48 89 c6             	mov    %rax,%rsi
  803ccb:	bf 00 00 00 00       	mov    $0x0,%edi
  803cd0:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  803cd7:	00 00 00 
  803cda:	ff d0                	callq  *%rax
    err:
	return r;
  803cdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803cdf:	48 83 c4 38          	add    $0x38,%rsp
  803ce3:	5b                   	pop    %rbx
  803ce4:	5d                   	pop    %rbp
  803ce5:	c3                   	retq   

0000000000803ce6 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ce6:	55                   	push   %rbp
  803ce7:	48 89 e5             	mov    %rsp,%rbp
  803cea:	53                   	push   %rbx
  803ceb:	48 83 ec 28          	sub    $0x28,%rsp
  803cef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cf3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cf7:	eb 01                	jmp    803cfa <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803cf9:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cfa:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d01:	00 00 00 
  803d04:	48 8b 00             	mov    (%rax),%rax
  803d07:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d14:	48 89 c7             	mov    %rax,%rdi
  803d17:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  803d1e:	00 00 00 
  803d21:	ff d0                	callq  *%rax
  803d23:	89 c3                	mov    %eax,%ebx
  803d25:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d29:	48 89 c7             	mov    %rax,%rdi
  803d2c:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
  803d38:	39 c3                	cmp    %eax,%ebx
  803d3a:	0f 94 c0             	sete   %al
  803d3d:	0f b6 c0             	movzbl %al,%eax
  803d40:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803d43:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d4a:	00 00 00 
  803d4d:	48 8b 00             	mov    (%rax),%rax
  803d50:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d56:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803d59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d5c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d5f:	75 0a                	jne    803d6b <_pipeisclosed+0x85>
			return ret;
  803d61:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803d64:	48 83 c4 28          	add    $0x28,%rsp
  803d68:	5b                   	pop    %rbx
  803d69:	5d                   	pop    %rbp
  803d6a:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d6b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d6e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803d71:	74 86                	je     803cf9 <_pipeisclosed+0x13>
  803d73:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803d77:	75 80                	jne    803cf9 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d79:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803d80:	00 00 00 
  803d83:	48 8b 00             	mov    (%rax),%rax
  803d86:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803d8c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803d8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d92:	89 c6                	mov    %eax,%esi
  803d94:	48 bf 69 4d 80 00 00 	movabs $0x804d69,%rdi
  803d9b:	00 00 00 
  803d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803da3:	49 b8 db 04 80 00 00 	movabs $0x8004db,%r8
  803daa:	00 00 00 
  803dad:	41 ff d0             	callq  *%r8
	}
  803db0:	e9 44 ff ff ff       	jmpq   803cf9 <_pipeisclosed+0x13>

0000000000803db5 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803db5:	55                   	push   %rbp
  803db6:	48 89 e5             	mov    %rsp,%rbp
  803db9:	48 83 ec 30          	sub    $0x30,%rsp
  803dbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803dc0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803dc4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803dc7:	48 89 d6             	mov    %rdx,%rsi
  803dca:	89 c7                	mov    %eax,%edi
  803dcc:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  803dd3:	00 00 00 
  803dd6:	ff d0                	callq  *%rax
  803dd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ddb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ddf:	79 05                	jns    803de6 <pipeisclosed+0x31>
		return r;
  803de1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de4:	eb 31                	jmp    803e17 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803de6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dea:	48 89 c7             	mov    %rax,%rdi
  803ded:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803df4:	00 00 00 
  803df7:	ff d0                	callq  *%rax
  803df9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e01:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e05:	48 89 d6             	mov    %rdx,%rsi
  803e08:	48 89 c7             	mov    %rax,%rdi
  803e0b:	48 b8 e6 3c 80 00 00 	movabs $0x803ce6,%rax
  803e12:	00 00 00 
  803e15:	ff d0                	callq  *%rax
}
  803e17:	c9                   	leaveq 
  803e18:	c3                   	retq   

0000000000803e19 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e19:	55                   	push   %rbp
  803e1a:	48 89 e5             	mov    %rsp,%rbp
  803e1d:	48 83 ec 40          	sub    $0x40,%rsp
  803e21:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e25:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e29:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e31:	48 89 c7             	mov    %rax,%rdi
  803e34:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803e3b:	00 00 00 
  803e3e:	ff d0                	callq  *%rax
  803e40:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e4c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e53:	00 
  803e54:	e9 97 00 00 00       	jmpq   803ef0 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803e59:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803e5e:	74 09                	je     803e69 <devpipe_read+0x50>
				return i;
  803e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e64:	e9 95 00 00 00       	jmpq   803efe <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e71:	48 89 d6             	mov    %rdx,%rsi
  803e74:	48 89 c7             	mov    %rax,%rdi
  803e77:	48 b8 e6 3c 80 00 00 	movabs $0x803ce6,%rax
  803e7e:	00 00 00 
  803e81:	ff d0                	callq  *%rax
  803e83:	85 c0                	test   %eax,%eax
  803e85:	74 07                	je     803e8e <devpipe_read+0x75>
				return 0;
  803e87:	b8 00 00 00 00       	mov    $0x0,%eax
  803e8c:	eb 70                	jmp    803efe <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e8e:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  803e95:	00 00 00 
  803e98:	ff d0                	callq  *%rax
  803e9a:	eb 01                	jmp    803e9d <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e9c:	90                   	nop
  803e9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea1:	8b 10                	mov    (%rax),%edx
  803ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ea7:	8b 40 04             	mov    0x4(%rax),%eax
  803eaa:	39 c2                	cmp    %eax,%edx
  803eac:	74 ab                	je     803e59 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803eae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803eb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803eb6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803eba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ebe:	8b 00                	mov    (%rax),%eax
  803ec0:	89 c2                	mov    %eax,%edx
  803ec2:	c1 fa 1f             	sar    $0x1f,%edx
  803ec5:	c1 ea 1b             	shr    $0x1b,%edx
  803ec8:	01 d0                	add    %edx,%eax
  803eca:	83 e0 1f             	and    $0x1f,%eax
  803ecd:	29 d0                	sub    %edx,%eax
  803ecf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ed3:	48 98                	cltq   
  803ed5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803eda:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee0:	8b 00                	mov    (%rax),%eax
  803ee2:	8d 50 01             	lea    0x1(%rax),%edx
  803ee5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803eeb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ef0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ef4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803ef8:	72 a2                	jb     803e9c <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803efe:	c9                   	leaveq 
  803eff:	c3                   	retq   

0000000000803f00 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f00:	55                   	push   %rbp
  803f01:	48 89 e5             	mov    %rsp,%rbp
  803f04:	48 83 ec 40          	sub    $0x40,%rsp
  803f08:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f18:	48 89 c7             	mov    %rax,%rdi
  803f1b:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  803f22:	00 00 00 
  803f25:	ff d0                	callq  *%rax
  803f27:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803f2b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803f33:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803f3a:	00 
  803f3b:	e9 93 00 00 00       	jmpq   803fd3 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803f40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f48:	48 89 d6             	mov    %rdx,%rsi
  803f4b:	48 89 c7             	mov    %rax,%rdi
  803f4e:	48 b8 e6 3c 80 00 00 	movabs $0x803ce6,%rax
  803f55:	00 00 00 
  803f58:	ff d0                	callq  *%rax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 07                	je     803f65 <devpipe_write+0x65>
				return 0;
  803f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f63:	eb 7c                	jmp    803fe1 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803f65:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  803f6c:	00 00 00 
  803f6f:	ff d0                	callq  *%rax
  803f71:	eb 01                	jmp    803f74 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803f73:	90                   	nop
  803f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f78:	8b 40 04             	mov    0x4(%rax),%eax
  803f7b:	48 63 d0             	movslq %eax,%rdx
  803f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f82:	8b 00                	mov    (%rax),%eax
  803f84:	48 98                	cltq   
  803f86:	48 83 c0 20          	add    $0x20,%rax
  803f8a:	48 39 c2             	cmp    %rax,%rdx
  803f8d:	73 b1                	jae    803f40 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803f8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f93:	8b 40 04             	mov    0x4(%rax),%eax
  803f96:	89 c2                	mov    %eax,%edx
  803f98:	c1 fa 1f             	sar    $0x1f,%edx
  803f9b:	c1 ea 1b             	shr    $0x1b,%edx
  803f9e:	01 d0                	add    %edx,%eax
  803fa0:	83 e0 1f             	and    $0x1f,%eax
  803fa3:	29 d0                	sub    %edx,%eax
  803fa5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803fa9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803fad:	48 01 ca             	add    %rcx,%rdx
  803fb0:	0f b6 0a             	movzbl (%rdx),%ecx
  803fb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fb7:	48 98                	cltq   
  803fb9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc1:	8b 40 04             	mov    0x4(%rax),%eax
  803fc4:	8d 50 01             	lea    0x1(%rax),%edx
  803fc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fcb:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803fce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803fdb:	72 96                	jb     803f73 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803fe1:	c9                   	leaveq 
  803fe2:	c3                   	retq   

0000000000803fe3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803fe3:	55                   	push   %rbp
  803fe4:	48 89 e5             	mov    %rsp,%rbp
  803fe7:	48 83 ec 20          	sub    $0x20,%rsp
  803feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ff7:	48 89 c7             	mov    %rax,%rdi
  803ffa:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
  804006:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80400a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400e:	48 be 7c 4d 80 00 00 	movabs $0x804d7c,%rsi
  804015:	00 00 00 
  804018:	48 89 c7             	mov    %rax,%rdi
  80401b:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  804022:	00 00 00 
  804025:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804027:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80402b:	8b 50 04             	mov    0x4(%rax),%edx
  80402e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804032:	8b 00                	mov    (%rax),%eax
  804034:	29 c2                	sub    %eax,%edx
  804036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804040:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804044:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80404b:	00 00 00 
	stat->st_dev = &devpipe;
  80404e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804052:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  804059:	00 00 00 
  80405c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  804063:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804068:	c9                   	leaveq 
  804069:	c3                   	retq   

000000000080406a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80406a:	55                   	push   %rbp
  80406b:	48 89 e5             	mov    %rsp,%rbp
  80406e:	48 83 ec 10          	sub    $0x10,%rsp
  804072:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  804076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80407a:	48 89 c6             	mov    %rax,%rsi
  80407d:	bf 00 00 00 00       	mov    $0x0,%edi
  804082:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  804089:	00 00 00 
  80408c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80408e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804092:	48 89 c7             	mov    %rax,%rdi
  804095:	48 b8 ff 25 80 00 00 	movabs $0x8025ff,%rax
  80409c:	00 00 00 
  80409f:	ff d0                	callq  *%rax
  8040a1:	48 89 c6             	mov    %rax,%rsi
  8040a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040a9:	48 b8 7b 1a 80 00 00 	movabs $0x801a7b,%rax
  8040b0:	00 00 00 
  8040b3:	ff d0                	callq  *%rax
}
  8040b5:	c9                   	leaveq 
  8040b6:	c3                   	retq   
	...

00000000008040b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040b8:	55                   	push   %rbp
  8040b9:	48 89 e5             	mov    %rsp,%rbp
  8040bc:	48 83 ec 20          	sub    $0x20,%rsp
  8040c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8040c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8040cd:	be 01 00 00 00       	mov    $0x1,%esi
  8040d2:	48 89 c7             	mov    %rax,%rdi
  8040d5:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  8040dc:	00 00 00 
  8040df:	ff d0                	callq  *%rax
}
  8040e1:	c9                   	leaveq 
  8040e2:	c3                   	retq   

00000000008040e3 <getchar>:

int
getchar(void)
{
  8040e3:	55                   	push   %rbp
  8040e4:	48 89 e5             	mov    %rsp,%rbp
  8040e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8040ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8040f4:	48 89 c6             	mov    %rax,%rsi
  8040f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040fc:	48 b8 f4 2a 80 00 00 	movabs $0x802af4,%rax
  804103:	00 00 00 
  804106:	ff d0                	callq  *%rax
  804108:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80410b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80410f:	79 05                	jns    804116 <getchar+0x33>
		return r;
  804111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804114:	eb 14                	jmp    80412a <getchar+0x47>
	if (r < 1)
  804116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411a:	7f 07                	jg     804123 <getchar+0x40>
		return -E_EOF;
  80411c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804121:	eb 07                	jmp    80412a <getchar+0x47>
	return c;
  804123:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804127:	0f b6 c0             	movzbl %al,%eax
}
  80412a:	c9                   	leaveq 
  80412b:	c3                   	retq   

000000000080412c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80412c:	55                   	push   %rbp
  80412d:	48 89 e5             	mov    %rsp,%rbp
  804130:	48 83 ec 20          	sub    $0x20,%rsp
  804134:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804137:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80413b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413e:	48 89 d6             	mov    %rdx,%rsi
  804141:	89 c7                	mov    %eax,%edi
  804143:	48 b8 c2 26 80 00 00 	movabs $0x8026c2,%rax
  80414a:	00 00 00 
  80414d:	ff d0                	callq  *%rax
  80414f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804156:	79 05                	jns    80415d <iscons+0x31>
		return r;
  804158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80415b:	eb 1a                	jmp    804177 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80415d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804161:	8b 10                	mov    (%rax),%edx
  804163:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80416a:	00 00 00 
  80416d:	8b 00                	mov    (%rax),%eax
  80416f:	39 c2                	cmp    %eax,%edx
  804171:	0f 94 c0             	sete   %al
  804174:	0f b6 c0             	movzbl %al,%eax
}
  804177:	c9                   	leaveq 
  804178:	c3                   	retq   

0000000000804179 <opencons>:

int
opencons(void)
{
  804179:	55                   	push   %rbp
  80417a:	48 89 e5             	mov    %rsp,%rbp
  80417d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804181:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804185:	48 89 c7             	mov    %rax,%rdi
  804188:	48 b8 2a 26 80 00 00 	movabs $0x80262a,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
  804194:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80419b:	79 05                	jns    8041a2 <opencons+0x29>
		return r;
  80419d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041a0:	eb 5b                	jmp    8041fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8041ab:	48 89 c6             	mov    %rax,%rsi
  8041ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8041b3:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8041ba:	00 00 00 
  8041bd:	ff d0                	callq  *%rax
  8041bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041c6:	79 05                	jns    8041cd <opencons+0x54>
		return r;
  8041c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cb:	eb 30                	jmp    8041fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8041cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041d1:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8041d8:	00 00 00 
  8041db:	8b 12                	mov    (%rdx),%edx
  8041dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8041df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ee:	48 89 c7             	mov    %rax,%rdi
  8041f1:	48 b8 dc 25 80 00 00 	movabs $0x8025dc,%rax
  8041f8:	00 00 00 
  8041fb:	ff d0                	callq  *%rax
}
  8041fd:	c9                   	leaveq 
  8041fe:	c3                   	retq   

00000000008041ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8041ff:	55                   	push   %rbp
  804200:	48 89 e5             	mov    %rsp,%rbp
  804203:	48 83 ec 30          	sub    $0x30,%rsp
  804207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80420b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80420f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804213:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804218:	75 13                	jne    80422d <devcons_read+0x2e>
		return 0;
  80421a:	b8 00 00 00 00       	mov    $0x0,%eax
  80421f:	eb 49                	jmp    80426a <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804221:	48 b8 92 19 80 00 00 	movabs $0x801992,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80422d:	48 b8 d2 18 80 00 00 	movabs $0x8018d2,%rax
  804234:	00 00 00 
  804237:	ff d0                	callq  *%rax
  804239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80423c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804240:	74 df                	je     804221 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804246:	79 05                	jns    80424d <devcons_read+0x4e>
		return c;
  804248:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80424b:	eb 1d                	jmp    80426a <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80424d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804251:	75 07                	jne    80425a <devcons_read+0x5b>
		return 0;
  804253:	b8 00 00 00 00       	mov    $0x0,%eax
  804258:	eb 10                	jmp    80426a <devcons_read+0x6b>
	*(char*)vbuf = c;
  80425a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80425d:	89 c2                	mov    %eax,%edx
  80425f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804263:	88 10                	mov    %dl,(%rax)
	return 1;
  804265:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80426a:	c9                   	leaveq 
  80426b:	c3                   	retq   

000000000080426c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80426c:	55                   	push   %rbp
  80426d:	48 89 e5             	mov    %rsp,%rbp
  804270:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804277:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80427e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804285:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80428c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804293:	eb 77                	jmp    80430c <devcons_write+0xa0>
		m = n - tot;
  804295:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80429c:	89 c2                	mov    %eax,%edx
  80429e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a1:	89 d1                	mov    %edx,%ecx
  8042a3:	29 c1                	sub    %eax,%ecx
  8042a5:	89 c8                	mov    %ecx,%eax
  8042a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8042aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ad:	83 f8 7f             	cmp    $0x7f,%eax
  8042b0:	76 07                	jbe    8042b9 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8042b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8042b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042bc:	48 63 d0             	movslq %eax,%rdx
  8042bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c2:	48 98                	cltq   
  8042c4:	48 89 c1             	mov    %rax,%rcx
  8042c7:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  8042ce:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042d5:	48 89 ce             	mov    %rcx,%rsi
  8042d8:	48 89 c7             	mov    %rax,%rdi
  8042db:	48 b8 ba 13 80 00 00 	movabs $0x8013ba,%rax
  8042e2:	00 00 00 
  8042e5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ea:	48 63 d0             	movslq %eax,%rdx
  8042ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042f4:	48 89 d6             	mov    %rdx,%rsi
  8042f7:	48 89 c7             	mov    %rax,%rdi
  8042fa:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  804301:	00 00 00 
  804304:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804306:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804309:	01 45 fc             	add    %eax,-0x4(%rbp)
  80430c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80430f:	48 98                	cltq   
  804311:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804318:	0f 82 77 ff ff ff    	jb     804295 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80431e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804321:	c9                   	leaveq 
  804322:	c3                   	retq   

0000000000804323 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804323:	55                   	push   %rbp
  804324:	48 89 e5             	mov    %rsp,%rbp
  804327:	48 83 ec 08          	sub    $0x8,%rsp
  80432b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80432f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804334:	c9                   	leaveq 
  804335:	c3                   	retq   

0000000000804336 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804336:	55                   	push   %rbp
  804337:	48 89 e5             	mov    %rsp,%rbp
  80433a:	48 83 ec 10          	sub    $0x10,%rsp
  80433e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80434a:	48 be 88 4d 80 00 00 	movabs $0x804d88,%rsi
  804351:	00 00 00 
  804354:	48 89 c7             	mov    %rax,%rdi
  804357:	48 b8 98 10 80 00 00 	movabs $0x801098,%rax
  80435e:	00 00 00 
  804361:	ff d0                	callq  *%rax
	return 0;
  804363:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804368:	c9                   	leaveq 
  804369:	c3                   	retq   
	...

000000000080436c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80436c:	55                   	push   %rbp
  80436d:	48 89 e5             	mov    %rsp,%rbp
  804370:	48 83 ec 20          	sub    $0x20,%rsp
  804374:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  804378:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80437f:	00 00 00 
  804382:	48 8b 00             	mov    (%rax),%rax
  804385:	48 85 c0             	test   %rax,%rax
  804388:	0f 85 8e 00 00 00    	jne    80441c <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  80438e:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  804395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  80439c:	48 b8 54 19 80 00 00 	movabs $0x801954,%rax
  8043a3:	00 00 00 
  8043a6:	ff d0                	callq  *%rax
  8043a8:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8043ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8043af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043b7:	48 89 ce             	mov    %rcx,%rsi
  8043ba:	89 c7                	mov    %eax,%edi
  8043bc:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8043c3:	00 00 00 
  8043c6:	ff d0                	callq  *%rax
  8043c8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  8043cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8043cf:	74 30                	je     804401 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8043d1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043d4:	89 c1                	mov    %eax,%ecx
  8043d6:	48 ba 90 4d 80 00 00 	movabs $0x804d90,%rdx
  8043dd:	00 00 00 
  8043e0:	be 24 00 00 00       	mov    $0x24,%esi
  8043e5:	48 bf c7 4d 80 00 00 	movabs $0x804dc7,%rdi
  8043ec:	00 00 00 
  8043ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f4:	49 b8 a0 02 80 00 00 	movabs $0x8002a0,%r8
  8043fb:	00 00 00 
  8043fe:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804401:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804404:	48 be 30 44 80 00 00 	movabs $0x804430,%rsi
  80440b:	00 00 00 
  80440e:	89 c7                	mov    %eax,%edi
  804410:	48 b8 5a 1b 80 00 00 	movabs $0x801b5a,%rax
  804417:	00 00 00 
  80441a:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80441c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804423:	00 00 00 
  804426:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80442a:	48 89 10             	mov    %rdx,(%rax)
}
  80442d:	c9                   	leaveq 
  80442e:	c3                   	retq   
	...

0000000000804430 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804430:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804433:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80443a:	00 00 00 
	call *%rax
  80443d:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80443f:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804443:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804447:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80444a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804451:	00 
		movq 120(%rsp), %rcx				// trap time rip
  804452:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  804457:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  80445a:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  80445b:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  80445e:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  804465:	00 08 
		POPA_						// copy the register contents to the registers
  804467:	4c 8b 3c 24          	mov    (%rsp),%r15
  80446b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804470:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804475:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80447a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80447f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804484:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804489:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80448e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804493:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804498:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80449d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8044a2:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8044a7:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8044ac:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8044b1:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  8044b5:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  8044b9:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  8044ba:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  8044bb:	c3                   	retq   

00000000008044bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8044bc:	55                   	push   %rbp
  8044bd:	48 89 e5             	mov    %rsp,%rbp
  8044c0:	48 83 ec 18          	sub    $0x18,%rsp
  8044c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8044c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044cc:	48 89 c2             	mov    %rax,%rdx
  8044cf:	48 c1 ea 15          	shr    $0x15,%rdx
  8044d3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8044da:	01 00 00 
  8044dd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8044e1:	83 e0 01             	and    $0x1,%eax
  8044e4:	48 85 c0             	test   %rax,%rax
  8044e7:	75 07                	jne    8044f0 <pageref+0x34>
		return 0;
  8044e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ee:	eb 53                	jmp    804543 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8044f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f4:	48 89 c2             	mov    %rax,%rdx
  8044f7:	48 c1 ea 0c          	shr    $0xc,%rdx
  8044fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804502:	01 00 00 
  804505:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804509:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80450d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804511:	83 e0 01             	and    $0x1,%eax
  804514:	48 85 c0             	test   %rax,%rax
  804517:	75 07                	jne    804520 <pageref+0x64>
		return 0;
  804519:	b8 00 00 00 00       	mov    $0x0,%eax
  80451e:	eb 23                	jmp    804543 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804520:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804524:	48 89 c2             	mov    %rax,%rdx
  804527:	48 c1 ea 0c          	shr    $0xc,%rdx
  80452b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804532:	00 00 00 
  804535:	48 c1 e2 04          	shl    $0x4,%rdx
  804539:	48 01 d0             	add    %rdx,%rax
  80453c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804540:	0f b7 c0             	movzwl %ax,%eax
}
  804543:	c9                   	leaveq 
  804544:	c3                   	retq   
