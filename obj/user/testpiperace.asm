
obj/user/testpiperace.debug:     file format elf64-x86-64


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
  80003c:	e8 57 03 00 00       	callq  800398 <libmain>
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
  800048:	48 83 ec 50          	sub    $0x50,%rsp
  80004c:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80004f:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800053:	48 bf 20 47 80 00 00 	movabs $0x804720,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800072:	48 89 c7             	mov    %rax,%rdi
  800075:	48 b8 3c 3d 80 00 00 	movabs $0x803d3c,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
  800081:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800084:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800088:	79 30                	jns    8000ba <umain+0x76>
		panic("pipe: %e", r);
  80008a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008d:	89 c1                	mov    %eax,%ecx
  80008f:	48 ba 39 47 80 00 00 	movabs $0x804739,%rdx
  800096:	00 00 00 
  800099:	be 0d 00 00 00       	mov    $0xd,%esi
  80009e:	48 bf 42 47 80 00 00 	movabs $0x804742,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  8000b4:	00 00 00 
  8000b7:	41 ff d0             	callq  *%r8
	max = 200;
  8000ba:	c7 45 f4 c8 00 00 00 	movl   $0xc8,-0xc(%rbp)
	if ((r = fork()) < 0)
  8000c1:	48 b8 67 22 80 00 00 	movabs $0x802267,%rax
  8000c8:	00 00 00 
  8000cb:	ff d0                	callq  *%rax
  8000cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d4:	79 30                	jns    800106 <umain+0xc2>
		panic("fork: %e", r);
  8000d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d9:	89 c1                	mov    %eax,%ecx
  8000db:	48 ba 56 47 80 00 00 	movabs $0x804756,%rdx
  8000e2:	00 00 00 
  8000e5:	be 10 00 00 00       	mov    $0x10,%esi
  8000ea:	48 bf 42 47 80 00 00 	movabs $0x804742,%rdi
  8000f1:	00 00 00 
  8000f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f9:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  800100:	00 00 00 
  800103:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800106:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80010a:	0f 85 89 00 00 00    	jne    800199 <umain+0x155>
		close(p[1]);
  800110:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800113:	89 c7                	mov    %eax,%edi
  800115:	48 b8 92 2a 80 00 00 	movabs $0x802a92,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800128:	eb 4c                	jmp    800176 <umain+0x132>
			if(pipeisclosed(p[0])){
  80012a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80012d:	89 c7                	mov    %eax,%edi
  80012f:	48 b8 01 40 80 00 00 	movabs $0x804001,%rax
  800136:	00 00 00 
  800139:	ff d0                	callq  *%rax
  80013b:	85 c0                	test   %eax,%eax
  80013d:	74 27                	je     800166 <umain+0x122>
				cprintf("RACE: pipe appears closed\n");
  80013f:	48 bf 5f 47 80 00 00 	movabs $0x80475f,%rdi
  800146:	00 00 00 
  800149:	b8 00 00 00 00       	mov    $0x0,%eax
  80014e:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  800155:	00 00 00 
  800158:	ff d2                	callq  *%rdx
				exit();
  80015a:	48 b8 3c 04 80 00 00 	movabs $0x80043c,%rax
  800161:	00 00 00 
  800164:	ff d0                	callq  *%rax
			}
			sys_yield();
  800166:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  80016d:	00 00 00 
  800170:	ff d0                	callq  *%rax
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  800172:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800179:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80017c:	7c ac                	jl     80012a <umain+0xe6>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  80017e:	ba 00 00 00 00       	mov    $0x0,%edx
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	bf 00 00 00 00       	mov    $0x0,%edi
  80018d:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  800194:	00 00 00 
  800197:	ff d0                	callq  *%rax
	}
	pid = r;
  800199:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80019c:	89 45 f0             	mov    %eax,-0x10(%rbp)
	cprintf("pid is %d\n", pid);
  80019f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001a2:	89 c6                	mov    %eax,%esi
  8001a4:	48 bf 7a 47 80 00 00 	movabs $0x80477a,%rdi
  8001ab:	00 00 00 
  8001ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b3:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  8001ba:	00 00 00 
  8001bd:	ff d2                	callq  *%rdx
	va = 0;
  8001bf:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8001c6:	00 
	kid = &envs[ENVX(pid)];
  8001c7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001ca:	48 98                	cltq   
  8001cc:	48 89 c2             	mov    %rax,%rdx
  8001cf:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001d5:	48 89 d0             	mov    %rdx,%rax
  8001d8:	48 c1 e0 03          	shl    $0x3,%rax
  8001dc:	48 01 d0             	add    %rdx,%rax
  8001df:	48 c1 e0 05          	shl    $0x5,%rax
  8001e3:	48 89 c2             	mov    %rax,%rdx
  8001e6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001ed:	00 00 00 
  8001f0:	48 01 d0             	add    %rdx,%rax
  8001f3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	cprintf("kid is %d\n", kid-envs);
  8001f7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001fb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800202:	00 00 00 
  800205:	48 89 d1             	mov    %rdx,%rcx
  800208:	48 29 c1             	sub    %rax,%rcx
  80020b:	48 89 c8             	mov    %rcx,%rax
  80020e:	48 89 c2             	mov    %rax,%rdx
  800211:	48 c1 fa 05          	sar    $0x5,%rdx
  800215:	48 b8 39 8e e3 38 8e 	movabs $0x8e38e38e38e38e39,%rax
  80021c:	e3 38 8e 
  80021f:	48 0f af c2          	imul   %rdx,%rax
  800223:	48 89 c6             	mov    %rax,%rsi
  800226:	48 bf 85 47 80 00 00 	movabs $0x804785,%rdi
  80022d:	00 00 00 
  800230:	b8 00 00 00 00       	mov    $0x0,%eax
  800235:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  80023c:	00 00 00 
  80023f:	ff d2                	callq  *%rdx
	dup(p[0], 10);
  800241:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800244:	be 0a 00 00 00       	mov    $0xa,%esi
  800249:	89 c7                	mov    %eax,%edi
  80024b:	48 b8 0b 2b 80 00 00 	movabs $0x802b0b,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
	while (kid->env_status == ENV_RUNNABLE)
  800257:	eb 16                	jmp    80026f <umain+0x22b>
		dup(p[0], 10);
  800259:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80025c:	be 0a 00 00 00       	mov    $0xa,%esi
  800261:	89 c7                	mov    %eax,%edi
  800263:	48 b8 0b 2b 80 00 00 	movabs $0x802b0b,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  80026f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800273:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800279:	83 f8 02             	cmp    $0x2,%eax
  80027c:	74 db                	je     800259 <umain+0x215>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80027e:	48 bf 90 47 80 00 00 	movabs $0x804790,%rdi
  800285:	00 00 00 
  800288:	b8 00 00 00 00       	mov    $0x0,%eax
  80028d:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  800294:	00 00 00 
  800297:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800299:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80029c:	89 c7                	mov    %eax,%edi
  80029e:	48 b8 01 40 80 00 00 	movabs $0x804001,%rax
  8002a5:	00 00 00 
  8002a8:	ff d0                	callq  *%rax
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	74 2a                	je     8002d8 <umain+0x294>
		panic("somehow the other end of p[0] got closed!");
  8002ae:	48 ba a8 47 80 00 00 	movabs $0x8047a8,%rdx
  8002b5:	00 00 00 
  8002b8:	be 3a 00 00 00       	mov    $0x3a,%esi
  8002bd:	48 bf 42 47 80 00 00 	movabs $0x804742,%rdi
  8002c4:	00 00 00 
  8002c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cc:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  8002d3:	00 00 00 
  8002d6:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002d8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002db:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  8002df:	48 89 d6             	mov    %rdx,%rsi
  8002e2:	89 c7                	mov    %eax,%edi
  8002e4:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
  8002f0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002f7:	79 30                	jns    800329 <umain+0x2e5>
		panic("cannot look up p[0]: %e", r);
  8002f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002fc:	89 c1                	mov    %eax,%ecx
  8002fe:	48 ba d2 47 80 00 00 	movabs $0x8047d2,%rdx
  800305:	00 00 00 
  800308:	be 3c 00 00 00       	mov    $0x3c,%esi
  80030d:	48 bf 42 47 80 00 00 	movabs $0x804742,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  800323:	00 00 00 
  800326:	41 ff d0             	callq  *%r8
	va = fd2data(fd);
  800329:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80032d:	48 89 c7             	mov    %rax,%rdi
  800330:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  800337:	00 00 00 
  80033a:	ff d0                	callq  *%rax
  80033c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (pageref(va) != 3+1)
  800340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 1d                	je     800375 <umain+0x331>
		cprintf("\nchild detected race\n");
  800358:	48 bf ea 47 80 00 00 	movabs $0x8047ea,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  80036e:	00 00 00 
  800371:	ff d2                	callq  *%rdx
  800373:	eb 20                	jmp    800395 <umain+0x351>
	else
		cprintf("\nrace didn't happen\n", max);
  800375:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800378:	89 c6                	mov    %eax,%esi
  80037a:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  800381:	00 00 00 
  800384:	b8 00 00 00 00       	mov    $0x0,%eax
  800389:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  800390:	00 00 00 
  800393:	ff d2                	callq  *%rdx
}
  800395:	c9                   	leaveq 
  800396:	c3                   	retq   
	...

0000000000800398 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800398:	55                   	push   %rbp
  800399:	48 89 e5             	mov    %rsp,%rbp
  80039c:	48 83 ec 10          	sub    $0x10,%rsp
  8003a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8003a7:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8003ae:	00 00 00 
  8003b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  8003b8:	48 b8 14 1b 80 00 00 	movabs $0x801b14,%rax
  8003bf:	00 00 00 
  8003c2:	ff d0                	callq  *%rax
  8003c4:	48 98                	cltq   
  8003c6:	48 89 c2             	mov    %rax,%rdx
  8003c9:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8003cf:	48 89 d0             	mov    %rdx,%rax
  8003d2:	48 c1 e0 03          	shl    $0x3,%rax
  8003d6:	48 01 d0             	add    %rdx,%rax
  8003d9:	48 c1 e0 05          	shl    $0x5,%rax
  8003dd:	48 89 c2             	mov    %rax,%rdx
  8003e0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8003e7:	00 00 00 
  8003ea:	48 01 c2             	add    %rax,%rdx
  8003ed:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8003f4:	00 00 00 
  8003f7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003fe:	7e 14                	jle    800414 <libmain+0x7c>
		binaryname = argv[0];
  800400:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800404:	48 8b 10             	mov    (%rax),%rdx
  800407:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80040e:	00 00 00 
  800411:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800414:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800418:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80041b:	48 89 d6             	mov    %rdx,%rsi
  80041e:	89 c7                	mov    %eax,%edi
  800420:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  800427:	00 00 00 
  80042a:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80042c:	48 b8 3c 04 80 00 00 	movabs $0x80043c,%rax
  800433:	00 00 00 
  800436:	ff d0                	callq  *%rax
}
  800438:	c9                   	leaveq 
  800439:	c3                   	retq   
	...

000000000080043c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80043c:	55                   	push   %rbp
  80043d:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800440:	48 b8 dd 2a 80 00 00 	movabs $0x802add,%rax
  800447:	00 00 00 
  80044a:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80044c:	bf 00 00 00 00       	mov    $0x0,%edi
  800451:	48 b8 d0 1a 80 00 00 	movabs $0x801ad0,%rax
  800458:	00 00 00 
  80045b:	ff d0                	callq  *%rax
}
  80045d:	5d                   	pop    %rbp
  80045e:	c3                   	retq   
	...

0000000000800460 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800460:	55                   	push   %rbp
  800461:	48 89 e5             	mov    %rsp,%rbp
  800464:	53                   	push   %rbx
  800465:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80046c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800473:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800479:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800480:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800487:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80048e:	84 c0                	test   %al,%al
  800490:	74 23                	je     8004b5 <_panic+0x55>
  800492:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800499:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80049d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8004a1:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8004a5:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8004a9:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8004ad:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8004b1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8004b5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8004bc:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8004c3:	00 00 00 
  8004c6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8004cd:	00 00 00 
  8004d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004d4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8004db:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8004e2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8004e9:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8004f0:	00 00 00 
  8004f3:	48 8b 18             	mov    (%rax),%rbx
  8004f6:	48 b8 14 1b 80 00 00 	movabs $0x801b14,%rax
  8004fd:	00 00 00 
  800500:	ff d0                	callq  *%rax
  800502:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800508:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80050f:	41 89 c8             	mov    %ecx,%r8d
  800512:	48 89 d1             	mov    %rdx,%rcx
  800515:	48 89 da             	mov    %rbx,%rdx
  800518:	89 c6                	mov    %eax,%esi
  80051a:	48 bf 20 48 80 00 00 	movabs $0x804820,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	49 b9 9b 06 80 00 00 	movabs $0x80069b,%r9
  800530:	00 00 00 
  800533:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800536:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80053d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800544:	48 89 d6             	mov    %rdx,%rsi
  800547:	48 89 c7             	mov    %rax,%rdi
  80054a:	48 b8 ef 05 80 00 00 	movabs $0x8005ef,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
	cprintf("\n");
  800556:	48 bf 43 48 80 00 00 	movabs $0x804843,%rdi
  80055d:	00 00 00 
  800560:	b8 00 00 00 00       	mov    $0x0,%eax
  800565:	48 ba 9b 06 80 00 00 	movabs $0x80069b,%rdx
  80056c:	00 00 00 
  80056f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800571:	cc                   	int3   
  800572:	eb fd                	jmp    800571 <_panic+0x111>

0000000000800574 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800574:	55                   	push   %rbp
  800575:	48 89 e5             	mov    %rsp,%rbp
  800578:	48 83 ec 10          	sub    $0x10,%rsp
  80057c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80057f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800587:	8b 00                	mov    (%rax),%eax
  800589:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80058c:	89 d6                	mov    %edx,%esi
  80058e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800592:	48 63 d0             	movslq %eax,%rdx
  800595:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80059a:	8d 50 01             	lea    0x1(%rax),%edx
  80059d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a1:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  8005a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005a7:	8b 00                	mov    (%rax),%eax
  8005a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ae:	75 2c                	jne    8005dc <putch+0x68>
		sys_cputs(b->buf, b->idx);
  8005b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	48 98                	cltq   
  8005b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005bc:	48 83 c2 08          	add    $0x8,%rdx
  8005c0:	48 89 c6             	mov    %rax,%rsi
  8005c3:	48 89 d7             	mov    %rdx,%rdi
  8005c6:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  8005cd:	00 00 00 
  8005d0:	ff d0                	callq  *%rax
		b->idx = 0;
  8005d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005d6:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8005dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e0:	8b 40 04             	mov    0x4(%rax),%eax
  8005e3:	8d 50 01             	lea    0x1(%rax),%edx
  8005e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ea:	89 50 04             	mov    %edx,0x4(%rax)
}
  8005ed:	c9                   	leaveq 
  8005ee:	c3                   	retq   

00000000008005ef <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005ef:	55                   	push   %rbp
  8005f0:	48 89 e5             	mov    %rsp,%rbp
  8005f3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8005fa:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800601:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800608:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80060f:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800616:	48 8b 0a             	mov    (%rdx),%rcx
  800619:	48 89 08             	mov    %rcx,(%rax)
  80061c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800620:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800624:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800628:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  80062c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800633:	00 00 00 
	b.cnt = 0;
  800636:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80063d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800640:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800647:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80064e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800655:	48 89 c6             	mov    %rax,%rsi
  800658:	48 bf 74 05 80 00 00 	movabs $0x800574,%rdi
  80065f:	00 00 00 
  800662:	48 b8 4c 0a 80 00 00 	movabs $0x800a4c,%rax
  800669:	00 00 00 
  80066c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80066e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800674:	48 98                	cltq   
  800676:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80067d:	48 83 c2 08          	add    $0x8,%rdx
  800681:	48 89 c6             	mov    %rax,%rsi
  800684:	48 89 d7             	mov    %rdx,%rdi
  800687:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  80068e:	00 00 00 
  800691:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800693:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800699:	c9                   	leaveq 
  80069a:	c3                   	retq   

000000000080069b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80069b:	55                   	push   %rbp
  80069c:	48 89 e5             	mov    %rsp,%rbp
  80069f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8006a6:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8006ad:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8006b4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8006bb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8006c2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8006c9:	84 c0                	test   %al,%al
  8006cb:	74 20                	je     8006ed <cprintf+0x52>
  8006cd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8006d1:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8006d5:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8006d9:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8006dd:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8006e1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8006e5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8006e9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8006ed:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8006f4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8006fb:	00 00 00 
  8006fe:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800705:	00 00 00 
  800708:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80070c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800713:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80071a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800721:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800728:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80072f:	48 8b 0a             	mov    (%rdx),%rcx
  800732:	48 89 08             	mov    %rcx,(%rax)
  800735:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800739:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80073d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800741:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800745:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80074c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800753:	48 89 d6             	mov    %rdx,%rsi
  800756:	48 89 c7             	mov    %rax,%rdi
  800759:	48 b8 ef 05 80 00 00 	movabs $0x8005ef,%rax
  800760:	00 00 00 
  800763:	ff d0                	callq  *%rax
  800765:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80076b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800771:	c9                   	leaveq 
  800772:	c3                   	retq   
	...

0000000000800774 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
  800778:	48 83 ec 30          	sub    $0x30,%rsp
  80077c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800780:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800784:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800788:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80078b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80078f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800793:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800796:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80079a:	77 52                	ja     8007ee <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80079c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80079f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8007a3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8007a6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8007aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b3:	48 f7 75 d0          	divq   -0x30(%rbp)
  8007b7:	48 89 c2             	mov    %rax,%rdx
  8007ba:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8007bd:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007c0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8007c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007c8:	41 89 f9             	mov    %edi,%r9d
  8007cb:	48 89 c7             	mov    %rax,%rdi
  8007ce:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  8007d5:	00 00 00 
  8007d8:	ff d0                	callq  *%rax
  8007da:	eb 1c                	jmp    8007f8 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8007e3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007e7:	48 89 d6             	mov    %rdx,%rsi
  8007ea:	89 c7                	mov    %eax,%edi
  8007ec:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ee:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8007f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8007f6:	7f e4                	jg     8007dc <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	48 f7 f1             	div    %rcx
  800807:	48 89 d0             	mov    %rdx,%rax
  80080a:	48 ba 28 4a 80 00 00 	movabs $0x804a28,%rdx
  800811:	00 00 00 
  800814:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80081f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800823:	48 89 d6             	mov    %rdx,%rsi
  800826:	89 c7                	mov    %eax,%edi
  800828:	ff d1                	callq  *%rcx
}
  80082a:	c9                   	leaveq 
  80082b:	c3                   	retq   

000000000080082c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80082c:	55                   	push   %rbp
  80082d:	48 89 e5             	mov    %rsp,%rbp
  800830:	48 83 ec 20          	sub    $0x20,%rsp
  800834:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800838:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80083b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80083f:	7e 52                	jle    800893 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800845:	8b 00                	mov    (%rax),%eax
  800847:	83 f8 30             	cmp    $0x30,%eax
  80084a:	73 24                	jae    800870 <getuint+0x44>
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
  80086e:	eb 17                	jmp    800887 <getuint+0x5b>
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800878:	48 89 d0             	mov    %rdx,%rax
  80087b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800883:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800887:	48 8b 00             	mov    (%rax),%rax
  80088a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088e:	e9 a3 00 00 00       	jmpq   800936 <getuint+0x10a>
	else if (lflag)
  800893:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800897:	74 4f                	je     8008e8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800899:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089d:	8b 00                	mov    (%rax),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 24                	jae    8008c8 <getuint+0x9c>
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b0:	8b 00                	mov    (%rax),%eax
  8008b2:	89 c0                	mov    %eax,%eax
  8008b4:	48 01 d0             	add    %rdx,%rax
  8008b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bb:	8b 12                	mov    (%rdx),%edx
  8008bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c4:	89 0a                	mov    %ecx,(%rdx)
  8008c6:	eb 17                	jmp    8008df <getuint+0xb3>
  8008c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008d0:	48 89 d0             	mov    %rdx,%rax
  8008d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008df:	48 8b 00             	mov    (%rax),%rax
  8008e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e6:	eb 4e                	jmp    800936 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8008e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ec:	8b 00                	mov    (%rax),%eax
  8008ee:	83 f8 30             	cmp    $0x30,%eax
  8008f1:	73 24                	jae    800917 <getuint+0xeb>
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ff:	8b 00                	mov    (%rax),%eax
  800901:	89 c0                	mov    %eax,%eax
  800903:	48 01 d0             	add    %rdx,%rax
  800906:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090a:	8b 12                	mov    (%rdx),%edx
  80090c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80090f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800913:	89 0a                	mov    %ecx,(%rdx)
  800915:	eb 17                	jmp    80092e <getuint+0x102>
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80091f:	48 89 d0             	mov    %rdx,%rax
  800922:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800926:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80092e:	8b 00                	mov    (%rax),%eax
  800930:	89 c0                	mov    %eax,%eax
  800932:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800936:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80093a:	c9                   	leaveq 
  80093b:	c3                   	retq   

000000000080093c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80093c:	55                   	push   %rbp
  80093d:	48 89 e5             	mov    %rsp,%rbp
  800940:	48 83 ec 20          	sub    $0x20,%rsp
  800944:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800948:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80094b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80094f:	7e 52                	jle    8009a3 <getint+0x67>
		x=va_arg(*ap, long long);
  800951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800955:	8b 00                	mov    (%rax),%eax
  800957:	83 f8 30             	cmp    $0x30,%eax
  80095a:	73 24                	jae    800980 <getint+0x44>
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	8b 00                	mov    (%rax),%eax
  80096a:	89 c0                	mov    %eax,%eax
  80096c:	48 01 d0             	add    %rdx,%rax
  80096f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800973:	8b 12                	mov    (%rdx),%edx
  800975:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800978:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097c:	89 0a                	mov    %ecx,(%rdx)
  80097e:	eb 17                	jmp    800997 <getint+0x5b>
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800988:	48 89 d0             	mov    %rdx,%rax
  80098b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800993:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800997:	48 8b 00             	mov    (%rax),%rax
  80099a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099e:	e9 a3 00 00 00       	jmpq   800a46 <getint+0x10a>
	else if (lflag)
  8009a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009a7:	74 4f                	je     8009f8 <getint+0xbc>
		x=va_arg(*ap, long);
  8009a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ad:	8b 00                	mov    (%rax),%eax
  8009af:	83 f8 30             	cmp    $0x30,%eax
  8009b2:	73 24                	jae    8009d8 <getint+0x9c>
  8009b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	8b 00                	mov    (%rax),%eax
  8009c2:	89 c0                	mov    %eax,%eax
  8009c4:	48 01 d0             	add    %rdx,%rax
  8009c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cb:	8b 12                	mov    (%rdx),%edx
  8009cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d4:	89 0a                	mov    %ecx,(%rdx)
  8009d6:	eb 17                	jmp    8009ef <getint+0xb3>
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e0:	48 89 d0             	mov    %rdx,%rax
  8009e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ef:	48 8b 00             	mov    (%rax),%rax
  8009f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f6:	eb 4e                	jmp    800a46 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	8b 00                	mov    (%rax),%eax
  8009fe:	83 f8 30             	cmp    $0x30,%eax
  800a01:	73 24                	jae    800a27 <getint+0xeb>
  800a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a07:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0f:	8b 00                	mov    (%rax),%eax
  800a11:	89 c0                	mov    %eax,%eax
  800a13:	48 01 d0             	add    %rdx,%rax
  800a16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1a:	8b 12                	mov    (%rdx),%edx
  800a1c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a23:	89 0a                	mov    %ecx,(%rdx)
  800a25:	eb 17                	jmp    800a3e <getint+0x102>
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a2f:	48 89 d0             	mov    %rdx,%rax
  800a32:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3e:	8b 00                	mov    (%rax),%eax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a4a:	c9                   	leaveq 
  800a4b:	c3                   	retq   

0000000000800a4c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a4c:	55                   	push   %rbp
  800a4d:	48 89 e5             	mov    %rsp,%rbp
  800a50:	41 54                	push   %r12
  800a52:	53                   	push   %rbx
  800a53:	48 83 ec 60          	sub    $0x60,%rsp
  800a57:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800a5b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a5f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a63:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a67:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a6f:	48 8b 0a             	mov    (%rdx),%rcx
  800a72:	48 89 08             	mov    %rcx,(%rax)
  800a75:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a79:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a7d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a81:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a85:	eb 17                	jmp    800a9e <vprintfmt+0x52>
			if (ch == '\0')
  800a87:	85 db                	test   %ebx,%ebx
  800a89:	0f 84 d7 04 00 00    	je     800f66 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800a8f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a93:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a97:	48 89 c6             	mov    %rax,%rsi
  800a9a:	89 df                	mov    %ebx,%edi
  800a9c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aa2:	0f b6 00             	movzbl (%rax),%eax
  800aa5:	0f b6 d8             	movzbl %al,%ebx
  800aa8:	83 fb 25             	cmp    $0x25,%ebx
  800aab:	0f 95 c0             	setne  %al
  800aae:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800ab3:	84 c0                	test   %al,%al
  800ab5:	75 d0                	jne    800a87 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ab7:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800abb:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800ac2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800ac9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800ad0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800ad7:	eb 04                	jmp    800add <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800ad9:	90                   	nop
  800ada:	eb 01                	jmp    800add <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800adc:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800add:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae1:	0f b6 00             	movzbl (%rax),%eax
  800ae4:	0f b6 d8             	movzbl %al,%ebx
  800ae7:	89 d8                	mov    %ebx,%eax
  800ae9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800aee:	83 e8 23             	sub    $0x23,%eax
  800af1:	83 f8 55             	cmp    $0x55,%eax
  800af4:	0f 87 38 04 00 00    	ja     800f32 <vprintfmt+0x4e6>
  800afa:	89 c0                	mov    %eax,%eax
  800afc:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b03:	00 
  800b04:	48 b8 50 4a 80 00 00 	movabs $0x804a50,%rax
  800b0b:	00 00 00 
  800b0e:	48 01 d0             	add    %rdx,%rax
  800b11:	48 8b 00             	mov    (%rax),%rax
  800b14:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b16:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b1a:	eb c1                	jmp    800add <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b1c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b20:	eb bb                	jmp    800add <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b22:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b29:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b2c:	89 d0                	mov    %edx,%eax
  800b2e:	c1 e0 02             	shl    $0x2,%eax
  800b31:	01 d0                	add    %edx,%eax
  800b33:	01 c0                	add    %eax,%eax
  800b35:	01 d8                	add    %ebx,%eax
  800b37:	83 e8 30             	sub    $0x30,%eax
  800b3a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b3d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b41:	0f b6 00             	movzbl (%rax),%eax
  800b44:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b47:	83 fb 2f             	cmp    $0x2f,%ebx
  800b4a:	7e 63                	jle    800baf <vprintfmt+0x163>
  800b4c:	83 fb 39             	cmp    $0x39,%ebx
  800b4f:	7f 5e                	jg     800baf <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b51:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b56:	eb d1                	jmp    800b29 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5b:	83 f8 30             	cmp    $0x30,%eax
  800b5e:	73 17                	jae    800b77 <vprintfmt+0x12b>
  800b60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b67:	89 c0                	mov    %eax,%eax
  800b69:	48 01 d0             	add    %rdx,%rax
  800b6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b6f:	83 c2 08             	add    $0x8,%edx
  800b72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b75:	eb 0f                	jmp    800b86 <vprintfmt+0x13a>
  800b77:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b7b:	48 89 d0             	mov    %rdx,%rax
  800b7e:	48 83 c2 08          	add    $0x8,%rdx
  800b82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b86:	8b 00                	mov    (%rax),%eax
  800b88:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b8b:	eb 23                	jmp    800bb0 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b91:	0f 89 42 ff ff ff    	jns    800ad9 <vprintfmt+0x8d>
				width = 0;
  800b97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b9e:	e9 36 ff ff ff       	jmpq   800ad9 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800ba3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800baa:	e9 2e ff ff ff       	jmpq   800add <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800baf:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bb4:	0f 89 22 ff ff ff    	jns    800adc <vprintfmt+0x90>
				width = precision, precision = -1;
  800bba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bbd:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800bc0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800bc7:	e9 10 ff ff ff       	jmpq   800adc <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bcc:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800bd0:	e9 08 ff ff ff       	jmpq   800add <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800bd5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd8:	83 f8 30             	cmp    $0x30,%eax
  800bdb:	73 17                	jae    800bf4 <vprintfmt+0x1a8>
  800bdd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800be1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800be4:	89 c0                	mov    %eax,%eax
  800be6:	48 01 d0             	add    %rdx,%rax
  800be9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bec:	83 c2 08             	add    $0x8,%edx
  800bef:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bf2:	eb 0f                	jmp    800c03 <vprintfmt+0x1b7>
  800bf4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bf8:	48 89 d0             	mov    %rdx,%rax
  800bfb:	48 83 c2 08          	add    $0x8,%rdx
  800bff:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c03:	8b 00                	mov    (%rax),%eax
  800c05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c09:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	ff d1                	callq  *%rcx
			break;
  800c14:	e9 47 03 00 00       	jmpq   800f60 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800c19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1c:	83 f8 30             	cmp    $0x30,%eax
  800c1f:	73 17                	jae    800c38 <vprintfmt+0x1ec>
  800c21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c28:	89 c0                	mov    %eax,%eax
  800c2a:	48 01 d0             	add    %rdx,%rax
  800c2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c30:	83 c2 08             	add    $0x8,%edx
  800c33:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c36:	eb 0f                	jmp    800c47 <vprintfmt+0x1fb>
  800c38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c3c:	48 89 d0             	mov    %rdx,%rax
  800c3f:	48 83 c2 08          	add    $0x8,%rdx
  800c43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c47:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c49:	85 db                	test   %ebx,%ebx
  800c4b:	79 02                	jns    800c4f <vprintfmt+0x203>
				err = -err;
  800c4d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c4f:	83 fb 10             	cmp    $0x10,%ebx
  800c52:	7f 16                	jg     800c6a <vprintfmt+0x21e>
  800c54:	48 b8 a0 49 80 00 00 	movabs $0x8049a0,%rax
  800c5b:	00 00 00 
  800c5e:	48 63 d3             	movslq %ebx,%rdx
  800c61:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c65:	4d 85 e4             	test   %r12,%r12
  800c68:	75 2e                	jne    800c98 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c6a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c6e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c72:	89 d9                	mov    %ebx,%ecx
  800c74:	48 ba 39 4a 80 00 00 	movabs $0x804a39,%rdx
  800c7b:	00 00 00 
  800c7e:	48 89 c7             	mov    %rax,%rdi
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	49 b8 70 0f 80 00 00 	movabs $0x800f70,%r8
  800c8d:	00 00 00 
  800c90:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c93:	e9 c8 02 00 00       	jmpq   800f60 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c98:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca0:	4c 89 e1             	mov    %r12,%rcx
  800ca3:	48 ba 42 4a 80 00 00 	movabs $0x804a42,%rdx
  800caa:	00 00 00 
  800cad:	48 89 c7             	mov    %rax,%rdi
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	49 b8 70 0f 80 00 00 	movabs $0x800f70,%r8
  800cbc:	00 00 00 
  800cbf:	41 ff d0             	callq  *%r8
			break;
  800cc2:	e9 99 02 00 00       	jmpq   800f60 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800cc7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cca:	83 f8 30             	cmp    $0x30,%eax
  800ccd:	73 17                	jae    800ce6 <vprintfmt+0x29a>
  800ccf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd6:	89 c0                	mov    %eax,%eax
  800cd8:	48 01 d0             	add    %rdx,%rax
  800cdb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cde:	83 c2 08             	add    $0x8,%edx
  800ce1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce4:	eb 0f                	jmp    800cf5 <vprintfmt+0x2a9>
  800ce6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cea:	48 89 d0             	mov    %rdx,%rax
  800ced:	48 83 c2 08          	add    $0x8,%rdx
  800cf1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf5:	4c 8b 20             	mov    (%rax),%r12
  800cf8:	4d 85 e4             	test   %r12,%r12
  800cfb:	75 0a                	jne    800d07 <vprintfmt+0x2bb>
				p = "(null)";
  800cfd:	49 bc 45 4a 80 00 00 	movabs $0x804a45,%r12
  800d04:	00 00 00 
			if (width > 0 && padc != '-')
  800d07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d0b:	7e 7a                	jle    800d87 <vprintfmt+0x33b>
  800d0d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d11:	74 74                	je     800d87 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d13:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d16:	48 98                	cltq   
  800d18:	48 89 c6             	mov    %rax,%rsi
  800d1b:	4c 89 e7             	mov    %r12,%rdi
  800d1e:	48 b8 1a 12 80 00 00 	movabs $0x80121a,%rax
  800d25:	00 00 00 
  800d28:	ff d0                	callq  *%rax
  800d2a:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d2d:	eb 17                	jmp    800d46 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800d2f:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800d33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d37:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800d3b:	48 89 d6             	mov    %rdx,%rsi
  800d3e:	89 c7                	mov    %eax,%edi
  800d40:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d46:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d4a:	7f e3                	jg     800d2f <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4c:	eb 39                	jmp    800d87 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800d4e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d52:	74 1e                	je     800d72 <vprintfmt+0x326>
  800d54:	83 fb 1f             	cmp    $0x1f,%ebx
  800d57:	7e 05                	jle    800d5e <vprintfmt+0x312>
  800d59:	83 fb 7e             	cmp    $0x7e,%ebx
  800d5c:	7e 14                	jle    800d72 <vprintfmt+0x326>
					putch('?', putdat);
  800d5e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d62:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d66:	48 89 c6             	mov    %rax,%rsi
  800d69:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d6e:	ff d2                	callq  *%rdx
  800d70:	eb 0f                	jmp    800d81 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d72:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d76:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d7a:	48 89 c6             	mov    %rax,%rsi
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d85:	eb 01                	jmp    800d88 <vprintfmt+0x33c>
  800d87:	90                   	nop
  800d88:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d8d:	0f be d8             	movsbl %al,%ebx
  800d90:	85 db                	test   %ebx,%ebx
  800d92:	0f 95 c0             	setne  %al
  800d95:	49 83 c4 01          	add    $0x1,%r12
  800d99:	84 c0                	test   %al,%al
  800d9b:	74 28                	je     800dc5 <vprintfmt+0x379>
  800d9d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800da1:	78 ab                	js     800d4e <vprintfmt+0x302>
  800da3:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800da7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dab:	79 a1                	jns    800d4e <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dad:	eb 16                	jmp    800dc5 <vprintfmt+0x379>
				putch(' ', putdat);
  800daf:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800db3:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800db7:	48 89 c6             	mov    %rax,%rsi
  800dba:	bf 20 00 00 00       	mov    $0x20,%edi
  800dbf:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dc5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc9:	7f e4                	jg     800daf <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800dcb:	e9 90 01 00 00       	jmpq   800f60 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800dd0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dd4:	be 03 00 00 00       	mov    $0x3,%esi
  800dd9:	48 89 c7             	mov    %rax,%rdi
  800ddc:	48 b8 3c 09 80 00 00 	movabs $0x80093c,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df0:	48 85 c0             	test   %rax,%rax
  800df3:	79 1d                	jns    800e12 <vprintfmt+0x3c6>
				putch('-', putdat);
  800df5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800df9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800dfd:	48 89 c6             	mov    %rax,%rsi
  800e00:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e05:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e0b:	48 f7 d8             	neg    %rax
  800e0e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e12:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e19:	e9 d5 00 00 00       	jmpq   800ef3 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e1e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e22:	be 03 00 00 00       	mov    $0x3,%esi
  800e27:	48 89 c7             	mov    %rax,%rdi
  800e2a:	48 b8 2c 08 80 00 00 	movabs $0x80082c,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
  800e36:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e3a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e41:	e9 ad 00 00 00       	jmpq   800ef3 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800e46:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e4a:	be 03 00 00 00       	mov    $0x3,%esi
  800e4f:	48 89 c7             	mov    %rax,%rdi
  800e52:	48 b8 2c 08 80 00 00 	movabs $0x80082c,%rax
  800e59:	00 00 00 
  800e5c:	ff d0                	callq  *%rax
  800e5e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800e62:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e69:	e9 85 00 00 00       	jmpq   800ef3 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800e6e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e72:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e76:	48 89 c6             	mov    %rax,%rsi
  800e79:	bf 30 00 00 00       	mov    $0x30,%edi
  800e7e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e80:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e84:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e88:	48 89 c6             	mov    %rax,%rsi
  800e8b:	bf 78 00 00 00       	mov    $0x78,%edi
  800e90:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e95:	83 f8 30             	cmp    $0x30,%eax
  800e98:	73 17                	jae    800eb1 <vprintfmt+0x465>
  800e9a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ea1:	89 c0                	mov    %eax,%eax
  800ea3:	48 01 d0             	add    %rdx,%rax
  800ea6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ea9:	83 c2 08             	add    $0x8,%edx
  800eac:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eaf:	eb 0f                	jmp    800ec0 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800eb1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800eb5:	48 89 d0             	mov    %rdx,%rax
  800eb8:	48 83 c2 08          	add    $0x8,%rdx
  800ebc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ec0:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ec7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ece:	eb 23                	jmp    800ef3 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ed0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed4:	be 03 00 00 00       	mov    $0x3,%esi
  800ed9:	48 89 c7             	mov    %rax,%rdi
  800edc:	48 b8 2c 08 80 00 00 	movabs $0x80082c,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
  800ee8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800eec:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ef3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ef8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800efb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f02:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0a:	45 89 c1             	mov    %r8d,%r9d
  800f0d:	41 89 f8             	mov    %edi,%r8d
  800f10:	48 89 c7             	mov    %rax,%rdi
  800f13:	48 b8 74 07 80 00 00 	movabs $0x800774,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	callq  *%rax
			break;
  800f1f:	eb 3f                	jmp    800f60 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f21:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f25:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f29:	48 89 c6             	mov    %rax,%rsi
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	ff d2                	callq  *%rdx
			break;
  800f30:	eb 2e                	jmp    800f60 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f32:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f36:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f3a:	48 89 c6             	mov    %rax,%rsi
  800f3d:	bf 25 00 00 00       	mov    $0x25,%edi
  800f42:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f44:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f49:	eb 05                	jmp    800f50 <vprintfmt+0x504>
  800f4b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f50:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f54:	48 83 e8 01          	sub    $0x1,%rax
  800f58:	0f b6 00             	movzbl (%rax),%eax
  800f5b:	3c 25                	cmp    $0x25,%al
  800f5d:	75 ec                	jne    800f4b <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800f5f:	90                   	nop
		}
	}
  800f60:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f61:	e9 38 fb ff ff       	jmpq   800a9e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f66:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800f67:	48 83 c4 60          	add    $0x60,%rsp
  800f6b:	5b                   	pop    %rbx
  800f6c:	41 5c                	pop    %r12
  800f6e:	5d                   	pop    %rbp
  800f6f:	c3                   	retq   

0000000000800f70 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f70:	55                   	push   %rbp
  800f71:	48 89 e5             	mov    %rsp,%rbp
  800f74:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f7b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f82:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f89:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f90:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f97:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f9e:	84 c0                	test   %al,%al
  800fa0:	74 20                	je     800fc2 <printfmt+0x52>
  800fa2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fa6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800faa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fb2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fb6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fbe:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fc2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800fc9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800fd0:	00 00 00 
  800fd3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800fda:	00 00 00 
  800fdd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fe1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800fe8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fef:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ffd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801004:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80100b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801012:	48 89 c7             	mov    %rax,%rdi
  801015:	48 b8 4c 0a 80 00 00 	movabs $0x800a4c,%rax
  80101c:	00 00 00 
  80101f:	ff d0                	callq  *%rax
	va_end(ap);
}
  801021:	c9                   	leaveq 
  801022:	c3                   	retq   

0000000000801023 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801023:	55                   	push   %rbp
  801024:	48 89 e5             	mov    %rsp,%rbp
  801027:	48 83 ec 10          	sub    $0x10,%rsp
  80102b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80102e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801036:	8b 40 10             	mov    0x10(%rax),%eax
  801039:	8d 50 01             	lea    0x1(%rax),%edx
  80103c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801040:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	48 8b 10             	mov    (%rax),%rdx
  80104a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80104e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801052:	48 39 c2             	cmp    %rax,%rdx
  801055:	73 17                	jae    80106e <sprintputch+0x4b>
		*b->buf++ = ch;
  801057:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80105b:	48 8b 00             	mov    (%rax),%rax
  80105e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801061:	88 10                	mov    %dl,(%rax)
  801063:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106b:	48 89 10             	mov    %rdx,(%rax)
}
  80106e:	c9                   	leaveq 
  80106f:	c3                   	retq   

0000000000801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %rbp
  801071:	48 89 e5             	mov    %rsp,%rbp
  801074:	48 83 ec 50          	sub    $0x50,%rsp
  801078:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80107c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80107f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801083:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801087:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80108b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80108f:	48 8b 0a             	mov    (%rdx),%rcx
  801092:	48 89 08             	mov    %rcx,(%rax)
  801095:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801099:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80109d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010a9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010ad:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010b0:	48 98                	cltq   
  8010b2:	48 83 e8 01          	sub    $0x1,%rax
  8010b6:	48 03 45 c8          	add    -0x38(%rbp),%rax
  8010ba:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010c5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010ca:	74 06                	je     8010d2 <vsnprintf+0x62>
  8010cc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8010d0:	7f 07                	jg     8010d9 <vsnprintf+0x69>
		return -E_INVAL;
  8010d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d7:	eb 2f                	jmp    801108 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8010d9:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8010dd:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8010e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8010e5:	48 89 c6             	mov    %rax,%rsi
  8010e8:	48 bf 23 10 80 00 00 	movabs $0x801023,%rdi
  8010ef:	00 00 00 
  8010f2:	48 b8 4c 0a 80 00 00 	movabs $0x800a4c,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801102:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801105:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801108:	c9                   	leaveq 
  801109:	c3                   	retq   

000000000080110a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801115:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80111c:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801122:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801129:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801130:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801137:	84 c0                	test   %al,%al
  801139:	74 20                	je     80115b <snprintf+0x51>
  80113b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80113f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801143:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801147:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80114b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80114f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801153:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801157:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80115b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801162:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801169:	00 00 00 
  80116c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801173:	00 00 00 
  801176:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80117a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801181:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801188:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80118f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801196:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80119d:	48 8b 0a             	mov    (%rdx),%rcx
  8011a0:	48 89 08             	mov    %rcx,(%rax)
  8011a3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011a7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011ab:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011af:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011b3:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011ba:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011c1:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011c7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8011ce:	48 89 c7             	mov    %rax,%rdi
  8011d1:	48 b8 70 10 80 00 00 	movabs $0x801070,%rax
  8011d8:	00 00 00 
  8011db:	ff d0                	callq  *%rax
  8011dd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8011e3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011e9:	c9                   	leaveq 
  8011ea:	c3                   	retq   
	...

00000000008011ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011ec:	55                   	push   %rbp
  8011ed:	48 89 e5             	mov    %rsp,%rbp
  8011f0:	48 83 ec 18          	sub    $0x18,%rsp
  8011f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011ff:	eb 09                	jmp    80120a <strlen+0x1e>
		n++;
  801201:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801205:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80120a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120e:	0f b6 00             	movzbl (%rax),%eax
  801211:	84 c0                	test   %al,%al
  801213:	75 ec                	jne    801201 <strlen+0x15>
		n++;
	return n;
  801215:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801218:	c9                   	leaveq 
  801219:	c3                   	retq   

000000000080121a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80121a:	55                   	push   %rbp
  80121b:	48 89 e5             	mov    %rsp,%rbp
  80121e:	48 83 ec 20          	sub    $0x20,%rsp
  801222:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801226:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801231:	eb 0e                	jmp    801241 <strnlen+0x27>
		n++;
  801233:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801237:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80123c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801241:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801246:	74 0b                	je     801253 <strnlen+0x39>
  801248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124c:	0f b6 00             	movzbl (%rax),%eax
  80124f:	84 c0                	test   %al,%al
  801251:	75 e0                	jne    801233 <strnlen+0x19>
		n++;
	return n;
  801253:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801256:	c9                   	leaveq 
  801257:	c3                   	retq   

0000000000801258 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	48 83 ec 20          	sub    $0x20,%rsp
  801260:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801264:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801268:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801270:	90                   	nop
  801271:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801275:	0f b6 10             	movzbl (%rax),%edx
  801278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127c:	88 10                	mov    %dl,(%rax)
  80127e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801282:	0f b6 00             	movzbl (%rax),%eax
  801285:	84 c0                	test   %al,%al
  801287:	0f 95 c0             	setne  %al
  80128a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80128f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801294:	84 c0                	test   %al,%al
  801296:	75 d9                	jne    801271 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801298:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80129c:	c9                   	leaveq 
  80129d:	c3                   	retq   

000000000080129e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80129e:	55                   	push   %rbp
  80129f:	48 89 e5             	mov    %rsp,%rbp
  8012a2:	48 83 ec 20          	sub    $0x20,%rsp
  8012a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b2:	48 89 c7             	mov    %rax,%rdi
  8012b5:	48 b8 ec 11 80 00 00 	movabs $0x8011ec,%rax
  8012bc:	00 00 00 
  8012bf:	ff d0                	callq  *%rax
  8012c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012c7:	48 98                	cltq   
  8012c9:	48 03 45 e8          	add    -0x18(%rbp),%rax
  8012cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d1:	48 89 d6             	mov    %rdx,%rsi
  8012d4:	48 89 c7             	mov    %rax,%rdi
  8012d7:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  8012de:	00 00 00 
  8012e1:	ff d0                	callq  *%rax
	return dst;
  8012e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012e7:	c9                   	leaveq 
  8012e8:	c3                   	retq   

00000000008012e9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	48 83 ec 28          	sub    $0x28,%rsp
  8012f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801301:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801305:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80130c:	00 
  80130d:	eb 27                	jmp    801336 <strncpy+0x4d>
		*dst++ = *src;
  80130f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801313:	0f b6 10             	movzbl (%rax),%edx
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	88 10                	mov    %dl,(%rax)
  80131c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801321:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801325:	0f b6 00             	movzbl (%rax),%eax
  801328:	84 c0                	test   %al,%al
  80132a:	74 05                	je     801331 <strncpy+0x48>
			src++;
  80132c:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801331:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801336:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80133e:	72 cf                	jb     80130f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801344:	c9                   	leaveq 
  801345:	c3                   	retq   

0000000000801346 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801346:	55                   	push   %rbp
  801347:	48 89 e5             	mov    %rsp,%rbp
  80134a:	48 83 ec 28          	sub    $0x28,%rsp
  80134e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801352:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801356:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80135a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801362:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801367:	74 37                	je     8013a0 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801369:	eb 17                	jmp    801382 <strlcpy+0x3c>
			*dst++ = *src++;
  80136b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136f:	0f b6 10             	movzbl (%rax),%edx
  801372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801376:	88 10                	mov    %dl,(%rax)
  801378:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80137d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801382:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801387:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80138c:	74 0b                	je     801399 <strlcpy+0x53>
  80138e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	84 c0                	test   %al,%al
  801397:	75 d2                	jne    80136b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a8:	48 89 d1             	mov    %rdx,%rcx
  8013ab:	48 29 c1             	sub    %rax,%rcx
  8013ae:	48 89 c8             	mov    %rcx,%rax
}
  8013b1:	c9                   	leaveq 
  8013b2:	c3                   	retq   

00000000008013b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013b3:	55                   	push   %rbp
  8013b4:	48 89 e5             	mov    %rsp,%rbp
  8013b7:	48 83 ec 10          	sub    $0x10,%rsp
  8013bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013c3:	eb 0a                	jmp    8013cf <strcmp+0x1c>
		p++, q++;
  8013c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d3:	0f b6 00             	movzbl (%rax),%eax
  8013d6:	84 c0                	test   %al,%al
  8013d8:	74 12                	je     8013ec <strcmp+0x39>
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	0f b6 10             	movzbl (%rax),%edx
  8013e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e5:	0f b6 00             	movzbl (%rax),%eax
  8013e8:	38 c2                	cmp    %al,%dl
  8013ea:	74 d9                	je     8013c5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f0:	0f b6 00             	movzbl (%rax),%eax
  8013f3:	0f b6 d0             	movzbl %al,%edx
  8013f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013fa:	0f b6 00             	movzbl (%rax),%eax
  8013fd:	0f b6 c0             	movzbl %al,%eax
  801400:	89 d1                	mov    %edx,%ecx
  801402:	29 c1                	sub    %eax,%ecx
  801404:	89 c8                	mov    %ecx,%eax
}
  801406:	c9                   	leaveq 
  801407:	c3                   	retq   

0000000000801408 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	48 83 ec 18          	sub    $0x18,%rsp
  801410:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801414:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801418:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80141c:	eb 0f                	jmp    80142d <strncmp+0x25>
		n--, p++, q++;
  80141e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801423:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801428:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80142d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801432:	74 1d                	je     801451 <strncmp+0x49>
  801434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	84 c0                	test   %al,%al
  80143d:	74 12                	je     801451 <strncmp+0x49>
  80143f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801443:	0f b6 10             	movzbl (%rax),%edx
  801446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	38 c2                	cmp    %al,%dl
  80144f:	74 cd                	je     80141e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801451:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801456:	75 07                	jne    80145f <strncmp+0x57>
		return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 1a                	jmp    801479 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80145f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	0f b6 d0             	movzbl %al,%edx
  801469:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	0f b6 c0             	movzbl %al,%eax
  801473:	89 d1                	mov    %edx,%ecx
  801475:	29 c1                	sub    %eax,%ecx
  801477:	89 c8                	mov    %ecx,%eax
}
  801479:	c9                   	leaveq 
  80147a:	c3                   	retq   

000000000080147b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	48 83 ec 10          	sub    $0x10,%rsp
  801483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801487:	89 f0                	mov    %esi,%eax
  801489:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80148c:	eb 17                	jmp    8014a5 <strchr+0x2a>
		if (*s == c)
  80148e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801492:	0f b6 00             	movzbl (%rax),%eax
  801495:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801498:	75 06                	jne    8014a0 <strchr+0x25>
			return (char *) s;
  80149a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149e:	eb 15                	jmp    8014b5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a9:	0f b6 00             	movzbl (%rax),%eax
  8014ac:	84 c0                	test   %al,%al
  8014ae:	75 de                	jne    80148e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b5:	c9                   	leaveq 
  8014b6:	c3                   	retq   

00000000008014b7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b7:	55                   	push   %rbp
  8014b8:	48 89 e5             	mov    %rsp,%rbp
  8014bb:	48 83 ec 10          	sub    $0x10,%rsp
  8014bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c3:	89 f0                	mov    %esi,%eax
  8014c5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014c8:	eb 11                	jmp    8014db <strfind+0x24>
		if (*s == c)
  8014ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ce:	0f b6 00             	movzbl (%rax),%eax
  8014d1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014d4:	74 12                	je     8014e8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014d6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	84 c0                	test   %al,%al
  8014e4:	75 e4                	jne    8014ca <strfind+0x13>
  8014e6:	eb 01                	jmp    8014e9 <strfind+0x32>
		if (*s == c)
			break;
  8014e8:	90                   	nop
	return (char *) s;
  8014e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014ed:	c9                   	leaveq 
  8014ee:	c3                   	retq   

00000000008014ef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014ef:	55                   	push   %rbp
  8014f0:	48 89 e5             	mov    %rsp,%rbp
  8014f3:	48 83 ec 18          	sub    $0x18,%rsp
  8014f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014fb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801502:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801507:	75 06                	jne    80150f <memset+0x20>
		return v;
  801509:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150d:	eb 69                	jmp    801578 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	83 e0 03             	and    $0x3,%eax
  801516:	48 85 c0             	test   %rax,%rax
  801519:	75 48                	jne    801563 <memset+0x74>
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151f:	83 e0 03             	and    $0x3,%eax
  801522:	48 85 c0             	test   %rax,%rax
  801525:	75 3c                	jne    801563 <memset+0x74>
		c &= 0xFF;
  801527:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80152e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801531:	89 c2                	mov    %eax,%edx
  801533:	c1 e2 18             	shl    $0x18,%edx
  801536:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801539:	c1 e0 10             	shl    $0x10,%eax
  80153c:	09 c2                	or     %eax,%edx
  80153e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801541:	c1 e0 08             	shl    $0x8,%eax
  801544:	09 d0                	or     %edx,%eax
  801546:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801549:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80154d:	48 89 c1             	mov    %rax,%rcx
  801550:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801554:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801558:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80155b:	48 89 d7             	mov    %rdx,%rdi
  80155e:	fc                   	cld    
  80155f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801561:	eb 11                	jmp    801574 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801563:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801567:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80156e:	48 89 d7             	mov    %rdx,%rdi
  801571:	fc                   	cld    
  801572:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801578:	c9                   	leaveq 
  801579:	c3                   	retq   

000000000080157a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80157a:	55                   	push   %rbp
  80157b:	48 89 e5             	mov    %rsp,%rbp
  80157e:	48 83 ec 28          	sub    $0x28,%rsp
  801582:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801586:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80158a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80158e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801592:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80159a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80159e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015a6:	0f 83 88 00 00 00    	jae    801634 <memmove+0xba>
  8015ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b4:	48 01 d0             	add    %rdx,%rax
  8015b7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015bb:	76 77                	jbe    801634 <memmove+0xba>
		s += n;
  8015bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d1:	83 e0 03             	and    $0x3,%eax
  8015d4:	48 85 c0             	test   %rax,%rax
  8015d7:	75 3b                	jne    801614 <memmove+0x9a>
  8015d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dd:	83 e0 03             	and    $0x3,%eax
  8015e0:	48 85 c0             	test   %rax,%rax
  8015e3:	75 2f                	jne    801614 <memmove+0x9a>
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	83 e0 03             	and    $0x3,%eax
  8015ec:	48 85 c0             	test   %rax,%rax
  8015ef:	75 23                	jne    801614 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f5:	48 83 e8 04          	sub    $0x4,%rax
  8015f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fd:	48 83 ea 04          	sub    $0x4,%rdx
  801601:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801605:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801609:	48 89 c7             	mov    %rax,%rdi
  80160c:	48 89 d6             	mov    %rdx,%rsi
  80160f:	fd                   	std    
  801610:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801612:	eb 1d                	jmp    801631 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801618:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80161c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801620:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	48 89 d7             	mov    %rdx,%rdi
  80162b:	48 89 c1             	mov    %rax,%rcx
  80162e:	fd                   	std    
  80162f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801631:	fc                   	cld    
  801632:	eb 57                	jmp    80168b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801638:	83 e0 03             	and    $0x3,%eax
  80163b:	48 85 c0             	test   %rax,%rax
  80163e:	75 36                	jne    801676 <memmove+0xfc>
  801640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801644:	83 e0 03             	and    $0x3,%eax
  801647:	48 85 c0             	test   %rax,%rax
  80164a:	75 2a                	jne    801676 <memmove+0xfc>
  80164c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801650:	83 e0 03             	and    $0x3,%eax
  801653:	48 85 c0             	test   %rax,%rax
  801656:	75 1e                	jne    801676 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801658:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165c:	48 89 c1             	mov    %rax,%rcx
  80165f:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801663:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801667:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166b:	48 89 c7             	mov    %rax,%rdi
  80166e:	48 89 d6             	mov    %rdx,%rsi
  801671:	fc                   	cld    
  801672:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801674:	eb 15                	jmp    80168b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80167e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801682:	48 89 c7             	mov    %rax,%rdi
  801685:	48 89 d6             	mov    %rdx,%rsi
  801688:	fc                   	cld    
  801689:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80168b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80168f:	c9                   	leaveq 
  801690:	c3                   	retq   

0000000000801691 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801691:	55                   	push   %rbp
  801692:	48 89 e5             	mov    %rsp,%rbp
  801695:	48 83 ec 18          	sub    $0x18,%rsp
  801699:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016a9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016b1:	48 89 ce             	mov    %rcx,%rsi
  8016b4:	48 89 c7             	mov    %rax,%rdi
  8016b7:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
}
  8016c3:	c9                   	leaveq 
  8016c4:	c3                   	retq   

00000000008016c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016c5:	55                   	push   %rbp
  8016c6:	48 89 e5             	mov    %rsp,%rbp
  8016c9:	48 83 ec 28          	sub    $0x28,%rsp
  8016cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8016d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8016e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016e9:	eb 38                	jmp    801723 <memcmp+0x5e>
		if (*s1 != *s2)
  8016eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ef:	0f b6 10             	movzbl (%rax),%edx
  8016f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016f6:	0f b6 00             	movzbl (%rax),%eax
  8016f9:	38 c2                	cmp    %al,%dl
  8016fb:	74 1c                	je     801719 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8016fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801701:	0f b6 00             	movzbl (%rax),%eax
  801704:	0f b6 d0             	movzbl %al,%edx
  801707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80170b:	0f b6 00             	movzbl (%rax),%eax
  80170e:	0f b6 c0             	movzbl %al,%eax
  801711:	89 d1                	mov    %edx,%ecx
  801713:	29 c1                	sub    %eax,%ecx
  801715:	89 c8                	mov    %ecx,%eax
  801717:	eb 20                	jmp    801739 <memcmp+0x74>
		s1++, s2++;
  801719:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80171e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801723:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801728:	0f 95 c0             	setne  %al
  80172b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801730:	84 c0                	test   %al,%al
  801732:	75 b7                	jne    8016eb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leaveq 
  80173a:	c3                   	retq   

000000000080173b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80173b:	55                   	push   %rbp
  80173c:	48 89 e5             	mov    %rsp,%rbp
  80173f:	48 83 ec 28          	sub    $0x28,%rsp
  801743:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801747:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80174a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801756:	48 01 d0             	add    %rdx,%rax
  801759:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80175d:	eb 13                	jmp    801772 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  80175f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801763:	0f b6 10             	movzbl (%rax),%edx
  801766:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801769:	38 c2                	cmp    %al,%dl
  80176b:	74 11                	je     80177e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80176d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801776:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80177a:	72 e3                	jb     80175f <memfind+0x24>
  80177c:	eb 01                	jmp    80177f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80177e:	90                   	nop
	return (void *) s;
  80177f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 83 ec 38          	sub    $0x38,%rsp
  80178d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801791:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801795:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801798:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80179f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017a6:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017a7:	eb 05                	jmp    8017ae <strtol+0x29>
		s++;
  8017a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b2:	0f b6 00             	movzbl (%rax),%eax
  8017b5:	3c 20                	cmp    $0x20,%al
  8017b7:	74 f0                	je     8017a9 <strtol+0x24>
  8017b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bd:	0f b6 00             	movzbl (%rax),%eax
  8017c0:	3c 09                	cmp    $0x9,%al
  8017c2:	74 e5                	je     8017a9 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c8:	0f b6 00             	movzbl (%rax),%eax
  8017cb:	3c 2b                	cmp    $0x2b,%al
  8017cd:	75 07                	jne    8017d6 <strtol+0x51>
		s++;
  8017cf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d4:	eb 17                	jmp    8017ed <strtol+0x68>
	else if (*s == '-')
  8017d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017da:	0f b6 00             	movzbl (%rax),%eax
  8017dd:	3c 2d                	cmp    $0x2d,%al
  8017df:	75 0c                	jne    8017ed <strtol+0x68>
		s++, neg = 1;
  8017e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017f1:	74 06                	je     8017f9 <strtol+0x74>
  8017f3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017f7:	75 28                	jne    801821 <strtol+0x9c>
  8017f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fd:	0f b6 00             	movzbl (%rax),%eax
  801800:	3c 30                	cmp    $0x30,%al
  801802:	75 1d                	jne    801821 <strtol+0x9c>
  801804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801808:	48 83 c0 01          	add    $0x1,%rax
  80180c:	0f b6 00             	movzbl (%rax),%eax
  80180f:	3c 78                	cmp    $0x78,%al
  801811:	75 0e                	jne    801821 <strtol+0x9c>
		s += 2, base = 16;
  801813:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801818:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80181f:	eb 2c                	jmp    80184d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801821:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801825:	75 19                	jne    801840 <strtol+0xbb>
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	3c 30                	cmp    $0x30,%al
  801830:	75 0e                	jne    801840 <strtol+0xbb>
		s++, base = 8;
  801832:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801837:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80183e:	eb 0d                	jmp    80184d <strtol+0xc8>
	else if (base == 0)
  801840:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801844:	75 07                	jne    80184d <strtol+0xc8>
		base = 10;
  801846:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	3c 2f                	cmp    $0x2f,%al
  801856:	7e 1d                	jle    801875 <strtol+0xf0>
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 39                	cmp    $0x39,%al
  801861:	7f 12                	jg     801875 <strtol+0xf0>
			dig = *s - '0';
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	0f be c0             	movsbl %al,%eax
  80186d:	83 e8 30             	sub    $0x30,%eax
  801870:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801873:	eb 4e                	jmp    8018c3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801879:	0f b6 00             	movzbl (%rax),%eax
  80187c:	3c 60                	cmp    $0x60,%al
  80187e:	7e 1d                	jle    80189d <strtol+0x118>
  801880:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801884:	0f b6 00             	movzbl (%rax),%eax
  801887:	3c 7a                	cmp    $0x7a,%al
  801889:	7f 12                	jg     80189d <strtol+0x118>
			dig = *s - 'a' + 10;
  80188b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188f:	0f b6 00             	movzbl (%rax),%eax
  801892:	0f be c0             	movsbl %al,%eax
  801895:	83 e8 57             	sub    $0x57,%eax
  801898:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80189b:	eb 26                	jmp    8018c3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80189d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a1:	0f b6 00             	movzbl (%rax),%eax
  8018a4:	3c 40                	cmp    $0x40,%al
  8018a6:	7e 47                	jle    8018ef <strtol+0x16a>
  8018a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ac:	0f b6 00             	movzbl (%rax),%eax
  8018af:	3c 5a                	cmp    $0x5a,%al
  8018b1:	7f 3c                	jg     8018ef <strtol+0x16a>
			dig = *s - 'A' + 10;
  8018b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b7:	0f b6 00             	movzbl (%rax),%eax
  8018ba:	0f be c0             	movsbl %al,%eax
  8018bd:	83 e8 37             	sub    $0x37,%eax
  8018c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018c6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8018c9:	7d 23                	jge    8018ee <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8018cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8018d3:	48 98                	cltq   
  8018d5:	48 89 c2             	mov    %rax,%rdx
  8018d8:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  8018dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018e0:	48 98                	cltq   
  8018e2:	48 01 d0             	add    %rdx,%rax
  8018e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018e9:	e9 5f ff ff ff       	jmpq   80184d <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018ee:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ef:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018f4:	74 0b                	je     801901 <strtol+0x17c>
		*endptr = (char *) s;
  8018f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018fe:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801901:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801905:	74 09                	je     801910 <strtol+0x18b>
  801907:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190b:	48 f7 d8             	neg    %rax
  80190e:	eb 04                	jmp    801914 <strtol+0x18f>
  801910:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <strstr>:

char * strstr(const char *in, const char *str)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 30          	sub    $0x30,%rsp
  80191e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801922:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801926:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80192a:	0f b6 00             	movzbl (%rax),%eax
  80192d:	88 45 ff             	mov    %al,-0x1(%rbp)
  801930:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801935:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801939:	75 06                	jne    801941 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  80193b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193f:	eb 68                	jmp    8019a9 <strstr+0x93>

    len = strlen(str);
  801941:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801945:	48 89 c7             	mov    %rax,%rdi
  801948:	48 b8 ec 11 80 00 00 	movabs $0x8011ec,%rax
  80194f:	00 00 00 
  801952:	ff d0                	callq  *%rax
  801954:	48 98                	cltq   
  801956:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80195a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195e:	0f b6 00             	movzbl (%rax),%eax
  801961:	88 45 ef             	mov    %al,-0x11(%rbp)
  801964:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801969:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80196d:	75 07                	jne    801976 <strstr+0x60>
                return (char *) 0;
  80196f:	b8 00 00 00 00       	mov    $0x0,%eax
  801974:	eb 33                	jmp    8019a9 <strstr+0x93>
        } while (sc != c);
  801976:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80197a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80197d:	75 db                	jne    80195a <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80197f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801983:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801987:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198b:	48 89 ce             	mov    %rcx,%rsi
  80198e:	48 89 c7             	mov    %rax,%rdi
  801991:	48 b8 08 14 80 00 00 	movabs $0x801408,%rax
  801998:	00 00 00 
  80199b:	ff d0                	callq  *%rax
  80199d:	85 c0                	test   %eax,%eax
  80199f:	75 b9                	jne    80195a <strstr+0x44>

    return (char *) (in - 1);
  8019a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a5:	48 83 e8 01          	sub    $0x1,%rax
}
  8019a9:	c9                   	leaveq 
  8019aa:	c3                   	retq   
	...

00000000008019ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	53                   	push   %rbx
  8019b1:	48 83 ec 58          	sub    $0x58,%rsp
  8019b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019b8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019bb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019bf:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8019c3:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8019c7:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019cb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019ce:	89 45 ac             	mov    %eax,-0x54(%rbp)
  8019d1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8019d5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8019d9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8019dd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8019e1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8019e5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8019e8:	4c 89 c3             	mov    %r8,%rbx
  8019eb:	cd 30                	int    $0x30
  8019ed:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  8019f1:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8019f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019fd:	74 3e                	je     801a3d <syscall+0x91>
  8019ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a04:	7e 37                	jle    801a3d <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a0a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a0d:	49 89 d0             	mov    %rdx,%r8
  801a10:	89 c1                	mov    %eax,%ecx
  801a12:	48 ba 00 4d 80 00 00 	movabs $0x804d00,%rdx
  801a19:	00 00 00 
  801a1c:	be 23 00 00 00       	mov    $0x23,%esi
  801a21:	48 bf 1d 4d 80 00 00 	movabs $0x804d1d,%rdi
  801a28:	00 00 00 
  801a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a30:	49 b9 60 04 80 00 00 	movabs $0x800460,%r9
  801a37:	00 00 00 
  801a3a:	41 ff d1             	callq  *%r9

	return ret;
  801a3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a41:	48 83 c4 58          	add    $0x58,%rsp
  801a45:	5b                   	pop    %rbx
  801a46:	5d                   	pop    %rbp
  801a47:	c3                   	retq   

0000000000801a48 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a48:	55                   	push   %rbp
  801a49:	48 89 e5             	mov    %rsp,%rbp
  801a4c:	48 83 ec 20          	sub    $0x20,%rsp
  801a50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a67:	00 
  801a68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a74:	48 89 d1             	mov    %rdx,%rcx
  801a77:	48 89 c2             	mov    %rax,%rdx
  801a7a:	be 00 00 00 00       	mov    $0x0,%esi
  801a7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801a84:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801a8b:	00 00 00 
  801a8e:	ff d0                	callq  *%rax
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa1:	00 
  801aa2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aae:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab8:	be 00 00 00 00       	mov    $0x0,%esi
  801abd:	bf 01 00 00 00       	mov    $0x1,%edi
  801ac2:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801ac9:	00 00 00 
  801acc:	ff d0                	callq  *%rax
}
  801ace:	c9                   	leaveq 
  801acf:	c3                   	retq   

0000000000801ad0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801ad0:	55                   	push   %rbp
  801ad1:	48 89 e5             	mov    %rsp,%rbp
  801ad4:	48 83 ec 20          	sub    $0x20,%rsp
  801ad8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801adb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ade:	48 98                	cltq   
  801ae0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae7:	00 
  801ae8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aee:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af9:	48 89 c2             	mov    %rax,%rdx
  801afc:	be 01 00 00 00       	mov    $0x1,%esi
  801b01:	bf 03 00 00 00       	mov    $0x3,%edi
  801b06:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	callq  *%rax
}
  801b12:	c9                   	leaveq 
  801b13:	c3                   	retq   

0000000000801b14 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b14:	55                   	push   %rbp
  801b15:	48 89 e5             	mov    %rsp,%rbp
  801b18:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b1c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b23:	00 
  801b24:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b30:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b35:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3a:	be 00 00 00 00       	mov    $0x0,%esi
  801b3f:	bf 02 00 00 00       	mov    $0x2,%edi
  801b44:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	callq  *%rax
}
  801b50:	c9                   	leaveq 
  801b51:	c3                   	retq   

0000000000801b52 <sys_yield>:

void
sys_yield(void)
{
  801b52:	55                   	push   %rbp
  801b53:	48 89 e5             	mov    %rsp,%rbp
  801b56:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b61:	00 
  801b62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b73:	ba 00 00 00 00       	mov    $0x0,%edx
  801b78:	be 00 00 00 00       	mov    $0x0,%esi
  801b7d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b82:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
}
  801b8e:	c9                   	leaveq 
  801b8f:	c3                   	retq   

0000000000801b90 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b90:	55                   	push   %rbp
  801b91:	48 89 e5             	mov    %rsp,%rbp
  801b94:	48 83 ec 20          	sub    $0x20,%rsp
  801b98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ba2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba5:	48 63 c8             	movslq %eax,%rcx
  801ba8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801baf:	48 98                	cltq   
  801bb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bb8:	00 
  801bb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bbf:	49 89 c8             	mov    %rcx,%r8
  801bc2:	48 89 d1             	mov    %rdx,%rcx
  801bc5:	48 89 c2             	mov    %rax,%rdx
  801bc8:	be 01 00 00 00       	mov    $0x1,%esi
  801bcd:	bf 04 00 00 00       	mov    $0x4,%edi
  801bd2:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 30          	sub    $0x30,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801beb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bef:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bf2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bf6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801bfa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bfd:	48 63 c8             	movslq %eax,%rcx
  801c00:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c04:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c07:	48 63 f0             	movslq %eax,%rsi
  801c0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c11:	48 98                	cltq   
  801c13:	48 89 0c 24          	mov    %rcx,(%rsp)
  801c17:	49 89 f9             	mov    %rdi,%r9
  801c1a:	49 89 f0             	mov    %rsi,%r8
  801c1d:	48 89 d1             	mov    %rdx,%rcx
  801c20:	48 89 c2             	mov    %rax,%rdx
  801c23:	be 01 00 00 00       	mov    $0x1,%esi
  801c28:	bf 05 00 00 00       	mov    $0x5,%edi
  801c2d:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801c34:	00 00 00 
  801c37:	ff d0                	callq  *%rax
}
  801c39:	c9                   	leaveq 
  801c3a:	c3                   	retq   

0000000000801c3b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c3b:	55                   	push   %rbp
  801c3c:	48 89 e5             	mov    %rsp,%rbp
  801c3f:	48 83 ec 20          	sub    $0x20,%rsp
  801c43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c51:	48 98                	cltq   
  801c53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c5a:	00 
  801c5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c67:	48 89 d1             	mov    %rdx,%rcx
  801c6a:	48 89 c2             	mov    %rax,%rdx
  801c6d:	be 01 00 00 00       	mov    $0x1,%esi
  801c72:	bf 06 00 00 00       	mov    $0x6,%edi
  801c77:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
}
  801c83:	c9                   	leaveq 
  801c84:	c3                   	retq   

0000000000801c85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c85:	55                   	push   %rbp
  801c86:	48 89 e5             	mov    %rsp,%rbp
  801c89:	48 83 ec 20          	sub    $0x20,%rsp
  801c8d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c90:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c96:	48 63 d0             	movslq %eax,%rdx
  801c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9c:	48 98                	cltq   
  801c9e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca5:	00 
  801ca6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cac:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb2:	48 89 d1             	mov    %rdx,%rcx
  801cb5:	48 89 c2             	mov    %rax,%rdx
  801cb8:	be 01 00 00 00       	mov    $0x1,%esi
  801cbd:	bf 08 00 00 00       	mov    $0x8,%edi
  801cc2:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801cc9:	00 00 00 
  801ccc:	ff d0                	callq  *%rax
}
  801cce:	c9                   	leaveq 
  801ccf:	c3                   	retq   

0000000000801cd0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801cd0:	55                   	push   %rbp
  801cd1:	48 89 e5             	mov    %rsp,%rbp
  801cd4:	48 83 ec 20          	sub    $0x20,%rsp
  801cd8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cdb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801cdf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce6:	48 98                	cltq   
  801ce8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cef:	00 
  801cf0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cfc:	48 89 d1             	mov    %rdx,%rcx
  801cff:	48 89 c2             	mov    %rax,%rdx
  801d02:	be 01 00 00 00       	mov    $0x1,%esi
  801d07:	bf 09 00 00 00       	mov    $0x9,%edi
  801d0c:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801d13:	00 00 00 
  801d16:	ff d0                	callq  *%rax
}
  801d18:	c9                   	leaveq 
  801d19:	c3                   	retq   

0000000000801d1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d1a:	55                   	push   %rbp
  801d1b:	48 89 e5             	mov    %rsp,%rbp
  801d1e:	48 83 ec 20          	sub    $0x20,%rsp
  801d22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d30:	48 98                	cltq   
  801d32:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d39:	00 
  801d3a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d40:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d46:	48 89 d1             	mov    %rdx,%rcx
  801d49:	48 89 c2             	mov    %rax,%rdx
  801d4c:	be 01 00 00 00       	mov    $0x1,%esi
  801d51:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d56:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
  801d68:	48 83 ec 30          	sub    $0x30,%rsp
  801d6c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d77:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d7d:	48 63 f0             	movslq %eax,%rsi
  801d80:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d87:	48 98                	cltq   
  801d89:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d8d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d94:	00 
  801d95:	49 89 f1             	mov    %rsi,%r9
  801d98:	49 89 c8             	mov    %rcx,%r8
  801d9b:	48 89 d1             	mov    %rdx,%rcx
  801d9e:	48 89 c2             	mov    %rax,%rdx
  801da1:	be 00 00 00 00       	mov    $0x0,%esi
  801da6:	bf 0c 00 00 00       	mov    $0xc,%edi
  801dab:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
}
  801db7:	c9                   	leaveq 
  801db8:	c3                   	retq   

0000000000801db9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801db9:	55                   	push   %rbp
  801dba:	48 89 e5             	mov    %rsp,%rbp
  801dbd:	48 83 ec 20          	sub    $0x20,%rsp
  801dc1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dd0:	00 
  801dd1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ddd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de2:	48 89 c2             	mov    %rax,%rdx
  801de5:	be 01 00 00 00       	mov    $0x1,%esi
  801dea:	bf 0d 00 00 00       	mov    $0xd,%edi
  801def:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801df6:	00 00 00 
  801df9:	ff d0                	callq  *%rax
}
  801dfb:	c9                   	leaveq 
  801dfc:	c3                   	retq   

0000000000801dfd <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801dfd:	55                   	push   %rbp
  801dfe:	48 89 e5             	mov    %rsp,%rbp
  801e01:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0c:	00 
  801e0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e23:	be 00 00 00 00       	mov    $0x0,%esi
  801e28:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e2d:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801e34:	00 00 00 
  801e37:	ff d0                	callq  *%rax
}
  801e39:	c9                   	leaveq 
  801e3a:	c3                   	retq   

0000000000801e3b <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801e3b:	55                   	push   %rbp
  801e3c:	48 89 e5             	mov    %rsp,%rbp
  801e3f:	48 83 ec 20          	sub    $0x20,%rsp
  801e43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e4f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e53:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e5a:	00 
  801e5b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e61:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e67:	48 89 d1             	mov    %rdx,%rcx
  801e6a:	48 89 c2             	mov    %rax,%rdx
  801e6d:	be 00 00 00 00       	mov    $0x0,%esi
  801e72:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e77:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801e7e:	00 00 00 
  801e81:	ff d0                	callq  *%rax
}
  801e83:	c9                   	leaveq 
  801e84:	c3                   	retq   

0000000000801e85 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801e85:	55                   	push   %rbp
  801e86:	48 89 e5             	mov    %rsp,%rbp
  801e89:	48 83 ec 20          	sub    $0x20,%rsp
  801e8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e9d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea4:	00 
  801ea5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eb1:	48 89 d1             	mov    %rdx,%rcx
  801eb4:	48 89 c2             	mov    %rax,%rdx
  801eb7:	be 00 00 00 00       	mov    $0x0,%esi
  801ebc:	bf 10 00 00 00       	mov    $0x10,%edi
  801ec1:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
}
  801ecd:	c9                   	leaveq 
  801ece:	c3                   	retq   
	...

0000000000801ed0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ed0:	55                   	push   %rbp
  801ed1:	48 89 e5             	mov    %rsp,%rbp
  801ed4:	48 83 ec 30          	sub    $0x30,%rsp
  801ed8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801edc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee0:	48 8b 00             	mov    (%rax),%rax
  801ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ee7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eeb:	48 8b 40 08          	mov    0x8(%rax),%rax
  801eef:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801ef2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ef5:	83 e0 02             	and    $0x2,%eax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	74 23                	je     801f1f <pgfault+0x4f>
  801efc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f00:	48 89 c2             	mov    %rax,%rdx
  801f03:	48 c1 ea 0c          	shr    $0xc,%rdx
  801f07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f0e:	01 00 00 
  801f11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f15:	25 00 08 00 00       	and    $0x800,%eax
  801f1a:	48 85 c0             	test   %rax,%rax
  801f1d:	75 2a                	jne    801f49 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801f1f:	48 ba 30 4d 80 00 00 	movabs $0x804d30,%rdx
  801f26:	00 00 00 
  801f29:	be 1c 00 00 00       	mov    $0x1c,%esi
  801f2e:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  801f35:	00 00 00 
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  801f44:	00 00 00 
  801f47:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801f49:	ba 07 00 00 00       	mov    $0x7,%edx
  801f4e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f53:	bf 00 00 00 00       	mov    $0x0,%edi
  801f58:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	callq  *%rax
  801f64:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f6b:	79 30                	jns    801f9d <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801f6d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f70:	89 c1                	mov    %eax,%ecx
  801f72:	48 ba 70 4d 80 00 00 	movabs $0x804d70,%rdx
  801f79:	00 00 00 
  801f7c:	be 26 00 00 00       	mov    $0x26,%esi
  801f81:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  801f88:	00 00 00 
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  801f97:	00 00 00 
  801f9a:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801f9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fa1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801fa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801faf:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fb4:	48 89 c6             	mov    %rax,%rsi
  801fb7:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fbc:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  801fc3:	00 00 00 
  801fc6:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fcc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801fd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fd4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801fda:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801fe0:	48 89 c1             	mov    %rax,%rcx
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fed:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff2:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802001:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802005:	79 30                	jns    802037 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  802007:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80200a:	89 c1                	mov    %eax,%ecx
  80200c:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  802013:	00 00 00 
  802016:	be 2b 00 00 00       	mov    $0x2b,%esi
  80201b:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802022:	00 00 00 
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  802031:	00 00 00 
  802034:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  802037:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80203c:	bf 00 00 00 00       	mov    $0x0,%edi
  802041:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  802048:	00 00 00 
  80204b:	ff d0                	callq  *%rax
  80204d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802050:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802054:	79 30                	jns    802086 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  802056:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802059:	89 c1                	mov    %eax,%ecx
  80205b:	48 ba c0 4d 80 00 00 	movabs $0x804dc0,%rdx
  802062:	00 00 00 
  802065:	be 2e 00 00 00       	mov    $0x2e,%esi
  80206a:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802071:	00 00 00 
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  802080:	00 00 00 
  802083:	41 ff d0             	callq  *%r8
	
}
  802086:	c9                   	leaveq 
  802087:	c3                   	retq   

0000000000802088 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802088:	55                   	push   %rbp
  802089:	48 89 e5             	mov    %rsp,%rbp
  80208c:	48 83 ec 30          	sub    $0x30,%rsp
  802090:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802093:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802096:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80209d:	01 00 00 
  8020a0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8020a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  8020ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020af:	25 07 0e 00 00       	and    $0xe07,%eax
  8020b4:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  8020b7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8020ba:	48 c1 e0 0c          	shl    $0xc,%rax
  8020be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  8020c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c5:	25 00 04 00 00       	and    $0x400,%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	74 5c                	je     80212a <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  8020ce:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8020d1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020d5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020dc:	41 89 f0             	mov    %esi,%r8d
  8020df:	48 89 c6             	mov    %rax,%rsi
  8020e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e7:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8020ee:	00 00 00 
  8020f1:	ff d0                	callq  *%rax
  8020f3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  8020f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8020fa:	0f 89 60 01 00 00    	jns    802260 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  802100:	48 ba e8 4d 80 00 00 	movabs $0x804de8,%rdx
  802107:	00 00 00 
  80210a:	be 4d 00 00 00       	mov    $0x4d,%esi
  80210f:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802116:	00 00 00 
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  802125:	00 00 00 
  802128:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  80212a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80212d:	83 e0 02             	and    $0x2,%eax
  802130:	85 c0                	test   %eax,%eax
  802132:	75 10                	jne    802144 <duppage+0xbc>
  802134:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802137:	25 00 08 00 00       	and    $0x800,%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 84 c4 00 00 00    	je     802208 <duppage+0x180>
	{
		perm |= PTE_COW;
  802144:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  80214b:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  80214f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802152:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802156:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80215d:	41 89 f0             	mov    %esi,%r8d
  802160:	48 89 c6             	mov    %rax,%rsi
  802163:	bf 00 00 00 00       	mov    $0x0,%edi
  802168:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  80216f:	00 00 00 
  802172:	ff d0                	callq  *%rax
  802174:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  802177:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80217b:	79 2a                	jns    8021a7 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  80217d:	48 ba 18 4e 80 00 00 	movabs $0x804e18,%rdx
  802184:	00 00 00 
  802187:	be 56 00 00 00       	mov    $0x56,%esi
  80218c:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802193:	00 00 00 
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  8021a2:	00 00 00 
  8021a5:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  8021a7:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  8021aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	41 89 c8             	mov    %ecx,%r8d
  8021b5:	48 89 d1             	mov    %rdx,%rcx
  8021b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bd:	48 89 c6             	mov    %rax,%rsi
  8021c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c5:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
  8021d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8021d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021d8:	0f 89 82 00 00 00    	jns    802260 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  8021de:	48 ba 18 4e 80 00 00 	movabs $0x804e18,%rdx
  8021e5:	00 00 00 
  8021e8:	be 59 00 00 00       	mov    $0x59,%esi
  8021ed:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  8021f4:	00 00 00 
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fc:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  802203:	00 00 00 
  802206:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  802208:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80220b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80220f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	41 89 f0             	mov    %esi,%r8d
  802219:	48 89 c6             	mov    %rax,%rsi
  80221c:	bf 00 00 00 00       	mov    $0x0,%edi
  802221:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802228:	00 00 00 
  80222b:	ff d0                	callq  *%rax
  80222d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802230:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802234:	79 2a                	jns    802260 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  802236:	48 ba 50 4e 80 00 00 	movabs $0x804e50,%rdx
  80223d:	00 00 00 
  802240:	be 60 00 00 00       	mov    $0x60,%esi
  802245:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  80224c:	00 00 00 
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  80225b:	00 00 00 
  80225e:	ff d1                	callq  *%rcx
	}
	return 0;
  802260:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802265:	c9                   	leaveq 
  802266:	c3                   	retq   

0000000000802267 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802267:	55                   	push   %rbp
  802268:	48 89 e5             	mov    %rsp,%rbp
  80226b:	53                   	push   %rbx
  80226c:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802270:	48 bf d0 1e 80 00 00 	movabs $0x801ed0,%rdi
  802277:	00 00 00 
  80227a:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  802281:	00 00 00 
  802284:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802286:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  80228d:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802290:	cd 30                	int    $0x30
  802292:	89 c3                	mov    %eax,%ebx
  802294:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802297:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  80229a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  80229d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8022a1:	79 30                	jns    8022d3 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  8022a3:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022a6:	89 c1                	mov    %eax,%ecx
  8022a8:	48 ba 74 4e 80 00 00 	movabs $0x804e74,%rdx
  8022af:	00 00 00 
  8022b2:	be 7f 00 00 00       	mov    $0x7f,%esi
  8022b7:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  8022be:	00 00 00 
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  8022cd:	00 00 00 
  8022d0:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  8022d3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8022d7:	75 4c                	jne    802325 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  8022d9:	48 b8 14 1b 80 00 00 	movabs $0x801b14,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
  8022e5:	48 98                	cltq   
  8022e7:	48 89 c2             	mov    %rax,%rdx
  8022ea:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8022f0:	48 89 d0             	mov    %rdx,%rax
  8022f3:	48 c1 e0 03          	shl    $0x3,%rax
  8022f7:	48 01 d0             	add    %rdx,%rax
  8022fa:	48 c1 e0 05          	shl    $0x5,%rax
  8022fe:	48 89 c2             	mov    %rax,%rdx
  802301:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802308:	00 00 00 
  80230b:	48 01 c2             	add    %rax,%rdx
  80230e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802315:	00 00 00 
  802318:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	e9 38 02 00 00       	jmpq   80255d <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  802325:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802328:	ba 07 00 00 00       	mov    $0x7,%edx
  80232d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802332:	89 c7                	mov    %eax,%edi
  802334:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
  802340:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  802343:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802347:	79 30                	jns    802379 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  802349:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80234c:	89 c1                	mov    %eax,%ecx
  80234e:	48 ba 88 4e 80 00 00 	movabs $0x804e88,%rdx
  802355:	00 00 00 
  802358:	be 8b 00 00 00       	mov    $0x8b,%esi
  80235d:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802364:	00 00 00 
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  802373:	00 00 00 
  802376:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802379:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802380:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802387:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80238e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802395:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80239c:	e9 0a 01 00 00       	jmpq   8024ab <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  8023a1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8023a8:	01 00 00 
  8023ab:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8023ae:	48 63 d2             	movslq %edx,%rdx
  8023b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b5:	83 e0 01             	and    $0x1,%eax
  8023b8:	84 c0                	test   %al,%al
  8023ba:	0f 84 e7 00 00 00    	je     8024a7 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  8023c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  8023c7:	e9 cf 00 00 00       	jmpq   80249b <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  8023cc:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023d3:	01 00 00 
  8023d6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023d9:	48 63 d2             	movslq %edx,%rdx
  8023dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e0:	83 e0 01             	and    $0x1,%eax
  8023e3:	84 c0                	test   %al,%al
  8023e5:	0f 84 a0 00 00 00    	je     80248b <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  8023eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  8023f2:	e9 85 00 00 00       	jmpq   80247c <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  8023f7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023fe:	01 00 00 
  802401:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802404:	48 63 d2             	movslq %edx,%rdx
  802407:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240b:	83 e0 01             	and    $0x1,%eax
  80240e:	84 c0                	test   %al,%al
  802410:	74 56                	je     802468 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802412:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  802419:	eb 42                	jmp    80245d <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  80241b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802422:	01 00 00 
  802425:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802428:	48 63 d2             	movslq %edx,%rdx
  80242b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242f:	83 e0 01             	and    $0x1,%eax
  802432:	84 c0                	test   %al,%al
  802434:	74 1f                	je     802455 <fork+0x1ee>
  802436:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  80243d:	74 16                	je     802455 <fork+0x1ee>
									 duppage(envid,d1);
  80243f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802442:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802445:	89 d6                	mov    %edx,%esi
  802447:	89 c7                	mov    %eax,%edi
  802449:	48 b8 88 20 80 00 00 	movabs $0x802088,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  802455:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  802459:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  80245d:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802464:	7e b5                	jle    80241b <fork+0x1b4>
  802466:	eb 0c                	jmp    802474 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802468:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80246b:	83 c0 01             	add    $0x1,%eax
  80246e:	c1 e0 09             	shl    $0x9,%eax
  802471:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802474:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802478:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  80247c:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802483:	0f 8e 6e ff ff ff    	jle    8023f7 <fork+0x190>
  802489:	eb 0c                	jmp    802497 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80248b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80248e:	83 c0 01             	add    $0x1,%eax
  802491:	c1 e0 09             	shl    $0x9,%eax
  802494:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802497:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80249b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80249e:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  8024a1:	0f 8c 25 ff ff ff    	jl     8023cc <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  8024a7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  8024ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024ae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8024b1:	0f 8c ea fe ff ff    	jl     8023a1 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  8024b7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8024ba:	48 be 7c 46 80 00 00 	movabs $0x80467c,%rsi
  8024c1:	00 00 00 
  8024c4:	89 c7                	mov    %eax,%edi
  8024c6:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  8024cd:	00 00 00 
  8024d0:	ff d0                	callq  *%rax
  8024d2:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8024d5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8024d9:	79 30                	jns    80250b <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  8024db:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8024de:	89 c1                	mov    %eax,%ecx
  8024e0:	48 ba a8 4e 80 00 00 	movabs $0x804ea8,%rdx
  8024e7:	00 00 00 
  8024ea:	be ad 00 00 00       	mov    $0xad,%esi
  8024ef:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  8024f6:	00 00 00 
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  802505:	00 00 00 
  802508:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  80250b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80250e:	be 02 00 00 00       	mov    $0x2,%esi
  802513:	89 c7                	mov    %eax,%edi
  802515:	48 b8 85 1c 80 00 00 	movabs $0x801c85,%rax
  80251c:	00 00 00 
  80251f:	ff d0                	callq  *%rax
  802521:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802524:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802528:	79 30                	jns    80255a <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  80252a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	48 ba d8 4e 80 00 00 	movabs $0x804ed8,%rdx
  802536:	00 00 00 
  802539:	be b0 00 00 00       	mov    $0xb0,%esi
  80253e:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  802545:	00 00 00 
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  802554:	00 00 00 
  802557:	41 ff d0             	callq  *%r8
	return envid;
  80255a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  80255d:	48 83 c4 48          	add    $0x48,%rsp
  802561:	5b                   	pop    %rbx
  802562:	5d                   	pop    %rbp
  802563:	c3                   	retq   

0000000000802564 <sfork>:

// Challenge!
int
sfork(void)
{
  802564:	55                   	push   %rbp
  802565:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802568:	48 ba fc 4e 80 00 00 	movabs $0x804efc,%rdx
  80256f:	00 00 00 
  802572:	be b8 00 00 00       	mov    $0xb8,%esi
  802577:	48 bf 65 4d 80 00 00 	movabs $0x804d65,%rdi
  80257e:	00 00 00 
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
  802586:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  80258d:	00 00 00 
  802590:	ff d1                	callq  *%rcx
	...

0000000000802594 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802594:	55                   	push   %rbp
  802595:	48 89 e5             	mov    %rsp,%rbp
  802598:	48 83 ec 30          	sub    $0x30,%rsp
  80259c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8025a8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8025ad:	74 18                	je     8025c7 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8025af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b3:	48 89 c7             	mov    %rax,%rdi
  8025b6:	48 b8 b9 1d 80 00 00 	movabs $0x801db9,%rax
  8025bd:	00 00 00 
  8025c0:	ff d0                	callq  *%rax
  8025c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c5:	eb 19                	jmp    8025e0 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8025c7:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8025ce:	00 00 00 
  8025d1:	48 b8 b9 1d 80 00 00 	movabs $0x801db9,%rax
  8025d8:	00 00 00 
  8025db:	ff d0                	callq  *%rax
  8025dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  8025e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e4:	79 19                	jns    8025ff <ipc_recv+0x6b>
	{
		*from_env_store=0;
  8025e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ea:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  8025f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  8025fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025fd:	eb 53                	jmp    802652 <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  8025ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802604:	74 19                	je     80261f <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  802606:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80260d:	00 00 00 
  802610:	48 8b 00             	mov    (%rax),%rax
  802613:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80261d:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80261f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802624:	74 19                	je     80263f <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  802626:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80262d:	00 00 00 
  802630:	48 8b 00             	mov    (%rax),%rax
  802633:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802639:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80263d:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80263f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802646:	00 00 00 
  802649:	48 8b 00             	mov    (%rax),%rax
  80264c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  802652:	c9                   	leaveq 
  802653:	c3                   	retq   

0000000000802654 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802654:	55                   	push   %rbp
  802655:	48 89 e5             	mov    %rsp,%rbp
  802658:	48 83 ec 30          	sub    $0x30,%rsp
  80265c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80265f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802662:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802666:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  802669:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  802670:	e9 96 00 00 00       	jmpq   80270b <ipc_send+0xb7>
	{
		if(pg!=NULL)
  802675:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80267a:	74 20                	je     80269c <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  80267c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80267f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802682:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802686:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802689:	89 c7                	mov    %eax,%edi
  80268b:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  802692:	00 00 00 
  802695:	ff d0                	callq  *%rax
  802697:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80269a:	eb 2d                	jmp    8026c9 <ipc_send+0x75>
		else if(pg==NULL)
  80269c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8026a1:	75 26                	jne    8026c9 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8026a3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8026a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026ae:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8026b5:	00 00 00 
  8026b8:	89 c7                	mov    %eax,%edi
  8026ba:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax
  8026c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8026c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cd:	79 30                	jns    8026ff <ipc_send+0xab>
  8026cf:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8026d3:	74 2a                	je     8026ff <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8026d5:	48 ba 12 4f 80 00 00 	movabs $0x804f12,%rdx
  8026dc:	00 00 00 
  8026df:	be 40 00 00 00       	mov    $0x40,%esi
  8026e4:	48 bf 2a 4f 80 00 00 	movabs $0x804f2a,%rdi
  8026eb:	00 00 00 
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f3:	48 b9 60 04 80 00 00 	movabs $0x800460,%rcx
  8026fa:	00 00 00 
  8026fd:	ff d1                	callq  *%rcx
		}
		sys_yield();
  8026ff:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  802706:	00 00 00 
  802709:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  80270b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270f:	0f 85 60 ff ff ff    	jne    802675 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  802715:	c9                   	leaveq 
  802716:	c3                   	retq   

0000000000802717 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802717:	55                   	push   %rbp
  802718:	48 89 e5             	mov    %rsp,%rbp
  80271b:	48 83 ec 18          	sub    $0x18,%rsp
  80271f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802722:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802729:	eb 5e                	jmp    802789 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80272b:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802732:	00 00 00 
  802735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802738:	48 63 d0             	movslq %eax,%rdx
  80273b:	48 89 d0             	mov    %rdx,%rax
  80273e:	48 c1 e0 03          	shl    $0x3,%rax
  802742:	48 01 d0             	add    %rdx,%rax
  802745:	48 c1 e0 05          	shl    $0x5,%rax
  802749:	48 01 c8             	add    %rcx,%rax
  80274c:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802752:	8b 00                	mov    (%rax),%eax
  802754:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802757:	75 2c                	jne    802785 <ipc_find_env+0x6e>
			return envs[i].env_id;
  802759:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802760:	00 00 00 
  802763:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802766:	48 63 d0             	movslq %eax,%rdx
  802769:	48 89 d0             	mov    %rdx,%rax
  80276c:	48 c1 e0 03          	shl    $0x3,%rax
  802770:	48 01 d0             	add    %rdx,%rax
  802773:	48 c1 e0 05          	shl    $0x5,%rax
  802777:	48 01 c8             	add    %rcx,%rax
  80277a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802780:	8b 40 08             	mov    0x8(%rax),%eax
  802783:	eb 12                	jmp    802797 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802785:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802789:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802790:	7e 99                	jle    80272b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802792:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802797:	c9                   	leaveq 
  802798:	c3                   	retq   
  802799:	00 00                	add    %al,(%rax)
	...

000000000080279c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80279c:	55                   	push   %rbp
  80279d:	48 89 e5             	mov    %rsp,%rbp
  8027a0:	48 83 ec 08          	sub    $0x8,%rsp
  8027a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027ac:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027b3:	ff ff ff 
  8027b6:	48 01 d0             	add    %rdx,%rax
  8027b9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027bd:	c9                   	leaveq 
  8027be:	c3                   	retq   

00000000008027bf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027bf:	55                   	push   %rbp
  8027c0:	48 89 e5             	mov    %rsp,%rbp
  8027c3:	48 83 ec 08          	sub    $0x8,%rsp
  8027c7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027cf:	48 89 c7             	mov    %rax,%rdi
  8027d2:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  8027d9:	00 00 00 
  8027dc:	ff d0                	callq  *%rax
  8027de:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8027e4:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8027e8:	c9                   	leaveq 
  8027e9:	c3                   	retq   

00000000008027ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8027ea:	55                   	push   %rbp
  8027eb:	48 89 e5             	mov    %rsp,%rbp
  8027ee:	48 83 ec 18          	sub    $0x18,%rsp
  8027f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8027f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027fd:	eb 6b                	jmp    80286a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8027ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802802:	48 98                	cltq   
  802804:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80280a:	48 c1 e0 0c          	shl    $0xc,%rax
  80280e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802816:	48 89 c2             	mov    %rax,%rdx
  802819:	48 c1 ea 15          	shr    $0x15,%rdx
  80281d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802824:	01 00 00 
  802827:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80282b:	83 e0 01             	and    $0x1,%eax
  80282e:	48 85 c0             	test   %rax,%rax
  802831:	74 21                	je     802854 <fd_alloc+0x6a>
  802833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802837:	48 89 c2             	mov    %rax,%rdx
  80283a:	48 c1 ea 0c          	shr    $0xc,%rdx
  80283e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802845:	01 00 00 
  802848:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284c:	83 e0 01             	and    $0x1,%eax
  80284f:	48 85 c0             	test   %rax,%rax
  802852:	75 12                	jne    802866 <fd_alloc+0x7c>
			*fd_store = fd;
  802854:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802858:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80285c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	eb 1a                	jmp    802880 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802866:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80286a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80286e:	7e 8f                	jle    8027ff <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802874:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80287b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802880:	c9                   	leaveq 
  802881:	c3                   	retq   

0000000000802882 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802882:	55                   	push   %rbp
  802883:	48 89 e5             	mov    %rsp,%rbp
  802886:	48 83 ec 20          	sub    $0x20,%rsp
  80288a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80288d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802891:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802895:	78 06                	js     80289d <fd_lookup+0x1b>
  802897:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80289b:	7e 07                	jle    8028a4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80289d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a2:	eb 6c                	jmp    802910 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a7:	48 98                	cltq   
  8028a9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028af:	48 c1 e0 0c          	shl    $0xc,%rax
  8028b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028bb:	48 89 c2             	mov    %rax,%rdx
  8028be:	48 c1 ea 15          	shr    $0x15,%rdx
  8028c2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028c9:	01 00 00 
  8028cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d0:	83 e0 01             	and    $0x1,%eax
  8028d3:	48 85 c0             	test   %rax,%rax
  8028d6:	74 21                	je     8028f9 <fd_lookup+0x77>
  8028d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028dc:	48 89 c2             	mov    %rax,%rdx
  8028df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8028e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ea:	01 00 00 
  8028ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f1:	83 e0 01             	and    $0x1,%eax
  8028f4:	48 85 c0             	test   %rax,%rax
  8028f7:	75 07                	jne    802900 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028fe:	eb 10                	jmp    802910 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802900:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802904:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802908:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80290b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802910:	c9                   	leaveq 
  802911:	c3                   	retq   

0000000000802912 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802912:	55                   	push   %rbp
  802913:	48 89 e5             	mov    %rsp,%rbp
  802916:	48 83 ec 30          	sub    $0x30,%rsp
  80291a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80291e:	89 f0                	mov    %esi,%eax
  802920:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802927:	48 89 c7             	mov    %rax,%rdi
  80292a:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  802931:	00 00 00 
  802934:	ff d0                	callq  *%rax
  802936:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80293a:	48 89 d6             	mov    %rdx,%rsi
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
  80294b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802952:	78 0a                	js     80295e <fd_close+0x4c>
	    || fd != fd2)
  802954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802958:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80295c:	74 12                	je     802970 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80295e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802962:	74 05                	je     802969 <fd_close+0x57>
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802967:	eb 05                	jmp    80296e <fd_close+0x5c>
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
  80296e:	eb 69                	jmp    8029d9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802970:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802974:	8b 00                	mov    (%rax),%eax
  802976:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80297a:	48 89 d6             	mov    %rdx,%rsi
  80297d:	89 c7                	mov    %eax,%edi
  80297f:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
  80298b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802992:	78 2a                	js     8029be <fd_close+0xac>
		if (dev->dev_close)
  802994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802998:	48 8b 40 20          	mov    0x20(%rax),%rax
  80299c:	48 85 c0             	test   %rax,%rax
  80299f:	74 16                	je     8029b7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8029a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029a5:	48 8b 50 20          	mov    0x20(%rax),%rdx
  8029a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029ad:	48 89 c7             	mov    %rax,%rdi
  8029b0:	ff d2                	callq  *%rdx
  8029b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b5:	eb 07                	jmp    8029be <fd_close+0xac>
		else
			r = 0;
  8029b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c2:	48 89 c6             	mov    %rax,%rsi
  8029c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ca:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
	return r;
  8029d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029d9:	c9                   	leaveq 
  8029da:	c3                   	retq   

00000000008029db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 83 ec 20          	sub    $0x20,%rsp
  8029e3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8029e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8029ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029f1:	eb 41                	jmp    802a34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8029f3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8029fa:	00 00 00 
  8029fd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a00:	48 63 d2             	movslq %edx,%rdx
  802a03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a07:	8b 00                	mov    (%rax),%eax
  802a09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a0c:	75 22                	jne    802a30 <dev_lookup+0x55>
			*dev = devtab[i];
  802a0e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a15:	00 00 00 
  802a18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a1b:	48 63 d2             	movslq %edx,%rdx
  802a1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	eb 60                	jmp    802a90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a34:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a3b:	00 00 00 
  802a3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a41:	48 63 d2             	movslq %edx,%rdx
  802a44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a48:	48 85 c0             	test   %rax,%rax
  802a4b:	75 a6                	jne    8029f3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a4d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802a54:	00 00 00 
  802a57:	48 8b 00             	mov    (%rax),%rax
  802a5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a63:	89 c6                	mov    %eax,%esi
  802a65:	48 bf 38 4f 80 00 00 	movabs $0x804f38,%rdi
  802a6c:	00 00 00 
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	48 b9 9b 06 80 00 00 	movabs $0x80069b,%rcx
  802a7b:	00 00 00 
  802a7e:	ff d1                	callq  *%rcx
	*dev = 0;
  802a80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802a8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802a90:	c9                   	leaveq 
  802a91:	c3                   	retq   

0000000000802a92 <close>:

int
close(int fdnum)
{
  802a92:	55                   	push   %rbp
  802a93:	48 89 e5             	mov    %rsp,%rbp
  802a96:	48 83 ec 20          	sub    $0x20,%rsp
  802a9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aa1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aa4:	48 89 d6             	mov    %rdx,%rsi
  802aa7:	89 c7                	mov    %eax,%edi
  802aa9:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802ab0:	00 00 00 
  802ab3:	ff d0                	callq  *%rax
  802ab5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ab8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802abc:	79 05                	jns    802ac3 <close+0x31>
		return r;
  802abe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac1:	eb 18                	jmp    802adb <close+0x49>
	else
		return fd_close(fd, 1);
  802ac3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac7:	be 01 00 00 00       	mov    $0x1,%esi
  802acc:	48 89 c7             	mov    %rax,%rdi
  802acf:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  802ad6:	00 00 00 
  802ad9:	ff d0                	callq  *%rax
}
  802adb:	c9                   	leaveq 
  802adc:	c3                   	retq   

0000000000802add <close_all>:

void
close_all(void)
{
  802add:	55                   	push   %rbp
  802ade:	48 89 e5             	mov    %rsp,%rbp
  802ae1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802ae5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aec:	eb 15                	jmp    802b03 <close_all+0x26>
		close(i);
  802aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 92 2a 80 00 00 	movabs $0x802a92,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802aff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b07:	7e e5                	jle    802aee <close_all+0x11>
		close(i);
}
  802b09:	c9                   	leaveq 
  802b0a:	c3                   	retq   

0000000000802b0b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b0b:	55                   	push   %rbp
  802b0c:	48 89 e5             	mov    %rsp,%rbp
  802b0f:	48 83 ec 40          	sub    $0x40,%rsp
  802b13:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b16:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b19:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b1d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b20:	48 89 d6             	mov    %rdx,%rsi
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b38:	79 08                	jns    802b42 <dup+0x37>
		return r;
  802b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3d:	e9 70 01 00 00       	jmpq   802cb2 <dup+0x1a7>
	close(newfdnum);
  802b42:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b45:	89 c7                	mov    %eax,%edi
  802b47:	48 b8 92 2a 80 00 00 	movabs $0x802a92,%rax
  802b4e:	00 00 00 
  802b51:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b56:	48 98                	cltq   
  802b58:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b5e:	48 c1 e0 0c          	shl    $0xc,%rax
  802b62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b6a:	48 89 c7             	mov    %rax,%rdi
  802b6d:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802b7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b81:	48 89 c7             	mov    %rax,%rdi
  802b84:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  802b8b:	00 00 00 
  802b8e:	ff d0                	callq  *%rax
  802b90:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b98:	48 89 c2             	mov    %rax,%rdx
  802b9b:	48 c1 ea 15          	shr    $0x15,%rdx
  802b9f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ba6:	01 00 00 
  802ba9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bad:	83 e0 01             	and    $0x1,%eax
  802bb0:	84 c0                	test   %al,%al
  802bb2:	74 71                	je     802c25 <dup+0x11a>
  802bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb8:	48 89 c2             	mov    %rax,%rdx
  802bbb:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bbf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bc6:	01 00 00 
  802bc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bcd:	83 e0 01             	and    $0x1,%eax
  802bd0:	84 c0                	test   %al,%al
  802bd2:	74 51                	je     802c25 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd8:	48 89 c2             	mov    %rax,%rdx
  802bdb:	48 c1 ea 0c          	shr    $0xc,%rdx
  802bdf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802be6:	01 00 00 
  802be9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bed:	89 c1                	mov    %eax,%ecx
  802bef:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802bf5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	41 89 c8             	mov    %ecx,%r8d
  802c00:	48 89 d1             	mov    %rdx,%rcx
  802c03:	ba 00 00 00 00       	mov    $0x0,%edx
  802c08:	48 89 c6             	mov    %rax,%rsi
  802c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c10:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
  802c1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c23:	78 56                	js     802c7b <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c29:	48 89 c2             	mov    %rax,%rdx
  802c2c:	48 c1 ea 0c          	shr    $0xc,%rdx
  802c30:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c37:	01 00 00 
  802c3a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c3e:	89 c1                	mov    %eax,%ecx
  802c40:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802c46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c4e:	41 89 c8             	mov    %ecx,%r8d
  802c51:	48 89 d1             	mov    %rdx,%rcx
  802c54:	ba 00 00 00 00       	mov    $0x0,%edx
  802c59:	48 89 c6             	mov    %rax,%rsi
  802c5c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c61:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c74:	78 08                	js     802c7e <dup+0x173>
		goto err;

	return newfdnum;
  802c76:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c79:	eb 37                	jmp    802cb2 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802c7b:	90                   	nop
  802c7c:	eb 01                	jmp    802c7f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802c7e:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c83:	48 89 c6             	mov    %rax,%rsi
  802c86:	bf 00 00 00 00       	mov    $0x0,%edi
  802c8b:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802c97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c9b:	48 89 c6             	mov    %rax,%rsi
  802c9e:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca3:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
	return r;
  802caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cb2:	c9                   	leaveq 
  802cb3:	c3                   	retq   

0000000000802cb4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cb4:	55                   	push   %rbp
  802cb5:	48 89 e5             	mov    %rsp,%rbp
  802cb8:	48 83 ec 40          	sub    $0x40,%rsp
  802cbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cc3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ccb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cce:	48 89 d6             	mov    %rdx,%rsi
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802cda:	00 00 00 
  802cdd:	ff d0                	callq  *%rax
  802cdf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce6:	78 24                	js     802d0c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cec:	8b 00                	mov    (%rax),%eax
  802cee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf2:	48 89 d6             	mov    %rdx,%rsi
  802cf5:	89 c7                	mov    %eax,%edi
  802cf7:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802cfe:	00 00 00 
  802d01:	ff d0                	callq  *%rax
  802d03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0a:	79 05                	jns    802d11 <read+0x5d>
		return r;
  802d0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d0f:	eb 7a                	jmp    802d8b <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d15:	8b 40 08             	mov    0x8(%rax),%eax
  802d18:	83 e0 03             	and    $0x3,%eax
  802d1b:	83 f8 01             	cmp    $0x1,%eax
  802d1e:	75 3a                	jne    802d5a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d20:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802d27:	00 00 00 
  802d2a:	48 8b 00             	mov    (%rax),%rax
  802d2d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d33:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d36:	89 c6                	mov    %eax,%esi
  802d38:	48 bf 57 4f 80 00 00 	movabs $0x804f57,%rdi
  802d3f:	00 00 00 
  802d42:	b8 00 00 00 00       	mov    $0x0,%eax
  802d47:	48 b9 9b 06 80 00 00 	movabs $0x80069b,%rcx
  802d4e:	00 00 00 
  802d51:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d58:	eb 31                	jmp    802d8b <read+0xd7>
	}
	if (!dev->dev_read)
  802d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d62:	48 85 c0             	test   %rax,%rax
  802d65:	75 07                	jne    802d6e <read+0xba>
		return -E_NOT_SUPP;
  802d67:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d6c:	eb 1d                	jmp    802d8b <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d72:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d7e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d82:	48 89 ce             	mov    %rcx,%rsi
  802d85:	48 89 c7             	mov    %rax,%rdi
  802d88:	41 ff d0             	callq  *%r8
}
  802d8b:	c9                   	leaveq 
  802d8c:	c3                   	retq   

0000000000802d8d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d8d:	55                   	push   %rbp
  802d8e:	48 89 e5             	mov    %rsp,%rbp
  802d91:	48 83 ec 30          	sub    $0x30,%rsp
  802d95:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d98:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d9c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802da0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802da7:	eb 46                	jmp    802def <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dac:	48 98                	cltq   
  802dae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802db2:	48 29 c2             	sub    %rax,%rdx
  802db5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db8:	48 98                	cltq   
  802dba:	48 89 c1             	mov    %rax,%rcx
  802dbd:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802dc1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dc4:	48 89 ce             	mov    %rcx,%rsi
  802dc7:	89 c7                	mov    %eax,%edi
  802dc9:	48 b8 b4 2c 80 00 00 	movabs $0x802cb4,%rax
  802dd0:	00 00 00 
  802dd3:	ff d0                	callq  *%rax
  802dd5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802dd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ddc:	79 05                	jns    802de3 <readn+0x56>
			return m;
  802dde:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802de1:	eb 1d                	jmp    802e00 <readn+0x73>
		if (m == 0)
  802de3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802de7:	74 13                	je     802dfc <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802de9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dec:	01 45 fc             	add    %eax,-0x4(%rbp)
  802def:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df2:	48 98                	cltq   
  802df4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802df8:	72 af                	jb     802da9 <readn+0x1c>
  802dfa:	eb 01                	jmp    802dfd <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802dfc:	90                   	nop
	}
	return tot;
  802dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e00:	c9                   	leaveq 
  802e01:	c3                   	retq   

0000000000802e02 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e02:	55                   	push   %rbp
  802e03:	48 89 e5             	mov    %rsp,%rbp
  802e06:	48 83 ec 40          	sub    $0x40,%rsp
  802e0a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e0d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e11:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e15:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e19:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e1c:	48 89 d6             	mov    %rdx,%rsi
  802e1f:	89 c7                	mov    %eax,%edi
  802e21:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802e28:	00 00 00 
  802e2b:	ff d0                	callq  *%rax
  802e2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e34:	78 24                	js     802e5a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3a:	8b 00                	mov    (%rax),%eax
  802e3c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e40:	48 89 d6             	mov    %rdx,%rsi
  802e43:	89 c7                	mov    %eax,%edi
  802e45:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
  802e51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e58:	79 05                	jns    802e5f <write+0x5d>
		return r;
  802e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5d:	eb 79                	jmp    802ed8 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e63:	8b 40 08             	mov    0x8(%rax),%eax
  802e66:	83 e0 03             	and    $0x3,%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	75 3a                	jne    802ea7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e6d:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802e74:	00 00 00 
  802e77:	48 8b 00             	mov    (%rax),%rax
  802e7a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802e80:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802e83:	89 c6                	mov    %eax,%esi
  802e85:	48 bf 73 4f 80 00 00 	movabs $0x804f73,%rdi
  802e8c:	00 00 00 
  802e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e94:	48 b9 9b 06 80 00 00 	movabs $0x80069b,%rcx
  802e9b:	00 00 00 
  802e9e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ea0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ea5:	eb 31                	jmp    802ed8 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ea7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eab:	48 8b 40 18          	mov    0x18(%rax),%rax
  802eaf:	48 85 c0             	test   %rax,%rax
  802eb2:	75 07                	jne    802ebb <write+0xb9>
		return -E_NOT_SUPP;
  802eb4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802eb9:	eb 1d                	jmp    802ed8 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802ebb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebf:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ecb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ecf:	48 89 ce             	mov    %rcx,%rsi
  802ed2:	48 89 c7             	mov    %rax,%rdi
  802ed5:	41 ff d0             	callq  *%r8
}
  802ed8:	c9                   	leaveq 
  802ed9:	c3                   	retq   

0000000000802eda <seek>:

int
seek(int fdnum, off_t offset)
{
  802eda:	55                   	push   %rbp
  802edb:	48 89 e5             	mov    %rsp,%rbp
  802ede:	48 83 ec 18          	sub    $0x18,%rsp
  802ee2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ee5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ee8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802eef:	48 89 d6             	mov    %rdx,%rsi
  802ef2:	89 c7                	mov    %eax,%edi
  802ef4:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f07:	79 05                	jns    802f0e <seek+0x34>
		return r;
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	eb 0f                	jmp    802f1d <seek+0x43>
	fd->fd_offset = offset;
  802f0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f12:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f15:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f1d:	c9                   	leaveq 
  802f1e:	c3                   	retq   

0000000000802f1f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f1f:	55                   	push   %rbp
  802f20:	48 89 e5             	mov    %rsp,%rbp
  802f23:	48 83 ec 30          	sub    $0x30,%rsp
  802f27:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f2a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f2d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f31:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f34:	48 89 d6             	mov    %rdx,%rsi
  802f37:	89 c7                	mov    %eax,%edi
  802f39:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  802f40:	00 00 00 
  802f43:	ff d0                	callq  *%rax
  802f45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4c:	78 24                	js     802f72 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f52:	8b 00                	mov    (%rax),%eax
  802f54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f58:	48 89 d6             	mov    %rdx,%rsi
  802f5b:	89 c7                	mov    %eax,%edi
  802f5d:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  802f64:	00 00 00 
  802f67:	ff d0                	callq  *%rax
  802f69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f70:	79 05                	jns    802f77 <ftruncate+0x58>
		return r;
  802f72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f75:	eb 72                	jmp    802fe9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7b:	8b 40 08             	mov    0x8(%rax),%eax
  802f7e:	83 e0 03             	and    $0x3,%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	75 3a                	jne    802fbf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802f85:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802f8c:	00 00 00 
  802f8f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f92:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802f98:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802f9b:	89 c6                	mov    %eax,%esi
  802f9d:	48 bf 90 4f 80 00 00 	movabs $0x804f90,%rdi
  802fa4:	00 00 00 
  802fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fac:	48 b9 9b 06 80 00 00 	movabs $0x80069b,%rcx
  802fb3:	00 00 00 
  802fb6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fb8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fbd:	eb 2a                	jmp    802fe9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fc7:	48 85 c0             	test   %rax,%rax
  802fca:	75 07                	jne    802fd3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fcc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fd1:	eb 16                	jmp    802fe9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd7:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdf:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802fe2:	89 d6                	mov    %edx,%esi
  802fe4:	48 89 c7             	mov    %rax,%rdi
  802fe7:	ff d1                	callq  *%rcx
}
  802fe9:	c9                   	leaveq 
  802fea:	c3                   	retq   

0000000000802feb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802feb:	55                   	push   %rbp
  802fec:	48 89 e5             	mov    %rsp,%rbp
  802fef:	48 83 ec 30          	sub    $0x30,%rsp
  802ff3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ff6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ffa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ffe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803001:	48 89 d6             	mov    %rdx,%rsi
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803015:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803019:	78 24                	js     80303f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80301b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80301f:	8b 00                	mov    (%rax),%eax
  803021:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803025:	48 89 d6             	mov    %rdx,%rsi
  803028:	89 c7                	mov    %eax,%edi
  80302a:	48 b8 db 29 80 00 00 	movabs $0x8029db,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
  803036:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803039:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80303d:	79 05                	jns    803044 <fstat+0x59>
		return r;
  80303f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803042:	eb 5e                	jmp    8030a2 <fstat+0xb7>
	if (!dev->dev_stat)
  803044:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803048:	48 8b 40 28          	mov    0x28(%rax),%rax
  80304c:	48 85 c0             	test   %rax,%rax
  80304f:	75 07                	jne    803058 <fstat+0x6d>
		return -E_NOT_SUPP;
  803051:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803056:	eb 4a                	jmp    8030a2 <fstat+0xb7>
	stat->st_name[0] = 0;
  803058:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80305c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80305f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803063:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80306a:	00 00 00 
	stat->st_isdir = 0;
  80306d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803071:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803078:	00 00 00 
	stat->st_dev = dev;
  80307b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80307f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803083:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80308a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308e:	48 8b 48 28          	mov    0x28(%rax),%rcx
  803092:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803096:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80309a:	48 89 d6             	mov    %rdx,%rsi
  80309d:	48 89 c7             	mov    %rax,%rdi
  8030a0:	ff d1                	callq  *%rcx
}
  8030a2:	c9                   	leaveq 
  8030a3:	c3                   	retq   

00000000008030a4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030a4:	55                   	push   %rbp
  8030a5:	48 89 e5             	mov    %rsp,%rbp
  8030a8:	48 83 ec 20          	sub    $0x20,%rsp
  8030ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b8:	be 00 00 00 00       	mov    $0x0,%esi
  8030bd:	48 89 c7             	mov    %rax,%rdi
  8030c0:	48 b8 93 31 80 00 00 	movabs $0x803193,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d3:	79 05                	jns    8030da <stat+0x36>
		return fd;
  8030d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d8:	eb 2f                	jmp    803109 <stat+0x65>
	r = fstat(fd, stat);
  8030da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e1:	48 89 d6             	mov    %rdx,%rsi
  8030e4:	89 c7                	mov    %eax,%edi
  8030e6:	48 b8 eb 2f 80 00 00 	movabs $0x802feb,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
  8030f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8030f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f8:	89 c7                	mov    %eax,%edi
  8030fa:	48 b8 92 2a 80 00 00 	movabs $0x802a92,%rax
  803101:	00 00 00 
  803104:	ff d0                	callq  *%rax
	return r;
  803106:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803109:	c9                   	leaveq 
  80310a:	c3                   	retq   
	...

000000000080310c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80310c:	55                   	push   %rbp
  80310d:	48 89 e5             	mov    %rsp,%rbp
  803110:	48 83 ec 10          	sub    $0x10,%rsp
  803114:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803117:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80311b:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  803122:	00 00 00 
  803125:	8b 00                	mov    (%rax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	75 1d                	jne    803148 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80312b:	bf 01 00 00 00       	mov    $0x1,%edi
  803130:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  803137:	00 00 00 
  80313a:	ff d0                	callq  *%rax
  80313c:	48 ba 28 70 80 00 00 	movabs $0x807028,%rdx
  803143:	00 00 00 
  803146:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803148:	48 b8 28 70 80 00 00 	movabs $0x807028,%rax
  80314f:	00 00 00 
  803152:	8b 00                	mov    (%rax),%eax
  803154:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803157:	b9 07 00 00 00       	mov    $0x7,%ecx
  80315c:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  803163:	00 00 00 
  803166:	89 c7                	mov    %eax,%edi
  803168:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803178:	ba 00 00 00 00       	mov    $0x0,%edx
  80317d:	48 89 c6             	mov    %rax,%rsi
  803180:	bf 00 00 00 00       	mov    $0x0,%edi
  803185:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
}
  803191:	c9                   	leaveq 
  803192:	c3                   	retq   

0000000000803193 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803193:	55                   	push   %rbp
  803194:	48 89 e5             	mov    %rsp,%rbp
  803197:	48 83 ec 20          	sub    $0x20,%rsp
  80319b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80319f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  8031a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031a6:	48 89 c7             	mov    %rax,%rdi
  8031a9:	48 b8 ec 11 80 00 00 	movabs $0x8011ec,%rax
  8031b0:	00 00 00 
  8031b3:	ff d0                	callq  *%rax
  8031b5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031ba:	7e 0a                	jle    8031c6 <open+0x33>
                return -E_BAD_PATH;
  8031bc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031c1:	e9 a5 00 00 00       	jmpq   80326b <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  8031c6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031ca:	48 89 c7             	mov    %rax,%rdi
  8031cd:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  8031d4:	00 00 00 
  8031d7:	ff d0                	callq  *%rax
  8031d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e0:	79 08                	jns    8031ea <open+0x57>
		return r;
  8031e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e5:	e9 81 00 00 00       	jmpq   80326b <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  8031ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ee:	48 89 c6             	mov    %rax,%rsi
  8031f1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8031f8:	00 00 00 
  8031fb:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  803202:	00 00 00 
  803205:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  803207:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80320e:	00 00 00 
  803211:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803214:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  80321a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80321e:	48 89 c6             	mov    %rax,%rsi
  803221:	bf 01 00 00 00       	mov    $0x1,%edi
  803226:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  803235:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803239:	79 1d                	jns    803258 <open+0xc5>
	{
		fd_close(fd,0);
  80323b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323f:	be 00 00 00 00       	mov    $0x0,%esi
  803244:	48 89 c7             	mov    %rax,%rdi
  803247:	48 b8 12 29 80 00 00 	movabs $0x802912,%rax
  80324e:	00 00 00 
  803251:	ff d0                	callq  *%rax
		return r;
  803253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803256:	eb 13                	jmp    80326b <open+0xd8>
	}
	return fd2num(fd);
  803258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325c:	48 89 c7             	mov    %rax,%rdi
  80325f:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
	


}
  80326b:	c9                   	leaveq 
  80326c:	c3                   	retq   

000000000080326d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80326d:	55                   	push   %rbp
  80326e:	48 89 e5             	mov    %rsp,%rbp
  803271:	48 83 ec 10          	sub    $0x10,%rsp
  803275:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80327d:	8b 50 0c             	mov    0xc(%rax),%edx
  803280:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803287:	00 00 00 
  80328a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80328c:	be 00 00 00 00       	mov    $0x0,%esi
  803291:	bf 06 00 00 00       	mov    $0x6,%edi
  803296:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  80329d:	00 00 00 
  8032a0:	ff d0                	callq  *%rax
}
  8032a2:	c9                   	leaveq 
  8032a3:	c3                   	retq   

00000000008032a4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032a4:	55                   	push   %rbp
  8032a5:	48 89 e5             	mov    %rsp,%rbp
  8032a8:	48 83 ec 30          	sub    $0x30,%rsp
  8032ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032bc:	8b 50 0c             	mov    0xc(%rax),%edx
  8032bf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032c6:	00 00 00 
  8032c9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032cb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032d2:	00 00 00 
  8032d5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032d9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8032dd:	be 00 00 00 00       	mov    $0x0,%esi
  8032e2:	bf 03 00 00 00       	mov    $0x3,%edi
  8032e7:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  8032ee:	00 00 00 
  8032f1:	ff d0                	callq  *%rax
  8032f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032fa:	79 05                	jns    803301 <devfile_read+0x5d>
	{
		return r;
  8032fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ff:	eb 2c                	jmp    80332d <devfile_read+0x89>
	}
	if(r > 0)
  803301:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803305:	7e 23                	jle    80332a <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  803307:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80330a:	48 63 d0             	movslq %eax,%rdx
  80330d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803311:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803318:	00 00 00 
  80331b:	48 89 c7             	mov    %rax,%rdi
  80331e:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803325:	00 00 00 
  803328:	ff d0                	callq  *%rax
	return r;
  80332a:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  80332d:	c9                   	leaveq 
  80332e:	c3                   	retq   

000000000080332f <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80332f:	55                   	push   %rbp
  803330:	48 89 e5             	mov    %rsp,%rbp
  803333:	48 83 ec 30          	sub    $0x30,%rsp
  803337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80333b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80333f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  803343:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803347:	8b 50 0c             	mov    0xc(%rax),%edx
  80334a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803351:	00 00 00 
  803354:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  803356:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  80335d:	00 
  80335e:	76 08                	jbe    803368 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  803360:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803367:	00 
	fsipcbuf.write.req_n=n;
  803368:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80336f:	00 00 00 
  803372:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803376:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80337a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80337e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803382:	48 89 c6             	mov    %rax,%rsi
  803385:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80338c:	00 00 00 
  80338f:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80339b:	be 00 00 00 00       	mov    $0x0,%esi
  8033a0:	bf 04 00 00 00       	mov    $0x4,%edi
  8033a5:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  8033ac:	00 00 00 
  8033af:	ff d0                	callq  *%rax
  8033b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  8033b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b7:	c9                   	leaveq 
  8033b8:	c3                   	retq   

00000000008033b9 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  8033b9:	55                   	push   %rbp
  8033ba:	48 89 e5             	mov    %rsp,%rbp
  8033bd:	48 83 ec 10          	sub    $0x10,%rsp
  8033c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033c5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8033c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033cc:	8b 50 0c             	mov    0xc(%rax),%edx
  8033cf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033d6:	00 00 00 
  8033d9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  8033db:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033e2:	00 00 00 
  8033e5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8033e8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8033eb:	be 00 00 00 00       	mov    $0x0,%esi
  8033f0:	bf 02 00 00 00       	mov    $0x2,%edi
  8033f5:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  8033fc:	00 00 00 
  8033ff:	ff d0                	callq  *%rax
}
  803401:	c9                   	leaveq 
  803402:	c3                   	retq   

0000000000803403 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803403:	55                   	push   %rbp
  803404:	48 89 e5             	mov    %rsp,%rbp
  803407:	48 83 ec 20          	sub    $0x20,%rsp
  80340b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80340f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803417:	8b 50 0c             	mov    0xc(%rax),%edx
  80341a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803421:	00 00 00 
  803424:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803426:	be 00 00 00 00       	mov    $0x0,%esi
  80342b:	bf 05 00 00 00       	mov    $0x5,%edi
  803430:	48 b8 0c 31 80 00 00 	movabs $0x80310c,%rax
  803437:	00 00 00 
  80343a:	ff d0                	callq  *%rax
  80343c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80343f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803443:	79 05                	jns    80344a <devfile_stat+0x47>
		return r;
  803445:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803448:	eb 56                	jmp    8034a0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80344a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803455:	00 00 00 
  803458:	48 89 c7             	mov    %rax,%rdi
  80345b:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  803462:	00 00 00 
  803465:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803467:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80346e:	00 00 00 
  803471:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803477:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80347b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803481:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803488:	00 00 00 
  80348b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803491:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803495:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80349b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034a0:	c9                   	leaveq 
  8034a1:	c3                   	retq   
	...

00000000008034a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034a4:	55                   	push   %rbp
  8034a5:	48 89 e5             	mov    %rsp,%rbp
  8034a8:	48 83 ec 18          	sub    $0x18,%rsp
  8034ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8034b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b4:	48 89 c2             	mov    %rax,%rdx
  8034b7:	48 c1 ea 15          	shr    $0x15,%rdx
  8034bb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034c2:	01 00 00 
  8034c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034c9:	83 e0 01             	and    $0x1,%eax
  8034cc:	48 85 c0             	test   %rax,%rax
  8034cf:	75 07                	jne    8034d8 <pageref+0x34>
		return 0;
  8034d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d6:	eb 53                	jmp    80352b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034dc:	48 89 c2             	mov    %rax,%rdx
  8034df:	48 c1 ea 0c          	shr    $0xc,%rdx
  8034e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034ea:	01 00 00 
  8034ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f9:	83 e0 01             	and    $0x1,%eax
  8034fc:	48 85 c0             	test   %rax,%rax
  8034ff:	75 07                	jne    803508 <pageref+0x64>
		return 0;
  803501:	b8 00 00 00 00       	mov    $0x0,%eax
  803506:	eb 23                	jmp    80352b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80350c:	48 89 c2             	mov    %rax,%rdx
  80350f:	48 c1 ea 0c          	shr    $0xc,%rdx
  803513:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80351a:	00 00 00 
  80351d:	48 c1 e2 04          	shl    $0x4,%rdx
  803521:	48 01 d0             	add    %rdx,%rax
  803524:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803528:	0f b7 c0             	movzwl %ax,%eax
}
  80352b:	c9                   	leaveq 
  80352c:	c3                   	retq   
  80352d:	00 00                	add    %al,(%rax)
	...

0000000000803530 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803530:	55                   	push   %rbp
  803531:	48 89 e5             	mov    %rsp,%rbp
  803534:	48 83 ec 20          	sub    $0x20,%rsp
  803538:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80353b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80353f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803542:	48 89 d6             	mov    %rdx,%rsi
  803545:	89 c7                	mov    %eax,%edi
  803547:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  80354e:	00 00 00 
  803551:	ff d0                	callq  *%rax
  803553:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803556:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80355a:	79 05                	jns    803561 <fd2sockid+0x31>
		return r;
  80355c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80355f:	eb 24                	jmp    803585 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803561:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803565:	8b 10                	mov    (%rax),%edx
  803567:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80356e:	00 00 00 
  803571:	8b 00                	mov    (%rax),%eax
  803573:	39 c2                	cmp    %eax,%edx
  803575:	74 07                	je     80357e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803577:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80357c:	eb 07                	jmp    803585 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80357e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803582:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803585:	c9                   	leaveq 
  803586:	c3                   	retq   

0000000000803587 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803587:	55                   	push   %rbp
  803588:	48 89 e5             	mov    %rsp,%rbp
  80358b:	48 83 ec 20          	sub    $0x20,%rsp
  80358f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803592:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803596:	48 89 c7             	mov    %rax,%rdi
  803599:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  8035a0:	00 00 00 
  8035a3:	ff d0                	callq  *%rax
  8035a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035ac:	78 26                	js     8035d4 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8035ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035b2:	ba 07 04 00 00       	mov    $0x407,%edx
  8035b7:	48 89 c6             	mov    %rax,%rsi
  8035ba:	bf 00 00 00 00       	mov    $0x0,%edi
  8035bf:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d2:	79 16                	jns    8035ea <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8035d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035d7:	89 c7                	mov    %eax,%edi
  8035d9:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  8035e0:	00 00 00 
  8035e3:	ff d0                	callq  *%rax
		return r;
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	eb 3a                	jmp    803624 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8035ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ee:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8035f5:	00 00 00 
  8035f8:	8b 12                	mov    (%rdx),%edx
  8035fa:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8035fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803600:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80360e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803615:	48 89 c7             	mov    %rax,%rdi
  803618:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
}
  803624:	c9                   	leaveq 
  803625:	c3                   	retq   

0000000000803626 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803626:	55                   	push   %rbp
  803627:	48 89 e5             	mov    %rsp,%rbp
  80362a:	48 83 ec 30          	sub    $0x30,%rsp
  80362e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803631:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803635:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803639:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80363c:	89 c7                	mov    %eax,%edi
  80363e:	48 b8 30 35 80 00 00 	movabs $0x803530,%rax
  803645:	00 00 00 
  803648:	ff d0                	callq  *%rax
  80364a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803651:	79 05                	jns    803658 <accept+0x32>
		return r;
  803653:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803656:	eb 3b                	jmp    803693 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803658:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80365c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803660:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803663:	48 89 ce             	mov    %rcx,%rsi
  803666:	89 c7                	mov    %eax,%edi
  803668:	48 b8 71 39 80 00 00 	movabs $0x803971,%rax
  80366f:	00 00 00 
  803672:	ff d0                	callq  *%rax
  803674:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803677:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367b:	79 05                	jns    803682 <accept+0x5c>
		return r;
  80367d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803680:	eb 11                	jmp    803693 <accept+0x6d>
	return alloc_sockfd(r);
  803682:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803685:	89 c7                	mov    %eax,%edi
  803687:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  80368e:	00 00 00 
  803691:	ff d0                	callq  *%rax
}
  803693:	c9                   	leaveq 
  803694:	c3                   	retq   

0000000000803695 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803695:	55                   	push   %rbp
  803696:	48 89 e5             	mov    %rsp,%rbp
  803699:	48 83 ec 20          	sub    $0x20,%rsp
  80369d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8036a4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036aa:	89 c7                	mov    %eax,%edi
  8036ac:	48 b8 30 35 80 00 00 	movabs $0x803530,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
  8036b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bf:	79 05                	jns    8036c6 <bind+0x31>
		return r;
  8036c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c4:	eb 1b                	jmp    8036e1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8036c6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8036cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d0:	48 89 ce             	mov    %rcx,%rsi
  8036d3:	89 c7                	mov    %eax,%edi
  8036d5:	48 b8 f0 39 80 00 00 	movabs $0x8039f0,%rax
  8036dc:	00 00 00 
  8036df:	ff d0                	callq  *%rax
}
  8036e1:	c9                   	leaveq 
  8036e2:	c3                   	retq   

00000000008036e3 <shutdown>:

int
shutdown(int s, int how)
{
  8036e3:	55                   	push   %rbp
  8036e4:	48 89 e5             	mov    %rsp,%rbp
  8036e7:	48 83 ec 20          	sub    $0x20,%rsp
  8036eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036ee:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8036f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f4:	89 c7                	mov    %eax,%edi
  8036f6:	48 b8 30 35 80 00 00 	movabs $0x803530,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803705:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803709:	79 05                	jns    803710 <shutdown+0x2d>
		return r;
  80370b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80370e:	eb 16                	jmp    803726 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803710:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803716:	89 d6                	mov    %edx,%esi
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 54 3a 80 00 00 	movabs $0x803a54,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
}
  803726:	c9                   	leaveq 
  803727:	c3                   	retq   

0000000000803728 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803728:	55                   	push   %rbp
  803729:	48 89 e5             	mov    %rsp,%rbp
  80372c:	48 83 ec 10          	sub    $0x10,%rsp
  803730:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803738:	48 89 c7             	mov    %rax,%rdi
  80373b:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
  803747:	83 f8 01             	cmp    $0x1,%eax
  80374a:	75 17                	jne    803763 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80374c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803750:	8b 40 0c             	mov    0xc(%rax),%eax
  803753:	89 c7                	mov    %eax,%edi
  803755:	48 b8 94 3a 80 00 00 	movabs $0x803a94,%rax
  80375c:	00 00 00 
  80375f:	ff d0                	callq  *%rax
  803761:	eb 05                	jmp    803768 <devsock_close+0x40>
	else
		return 0;
  803763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803768:	c9                   	leaveq 
  803769:	c3                   	retq   

000000000080376a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80376a:	55                   	push   %rbp
  80376b:	48 89 e5             	mov    %rsp,%rbp
  80376e:	48 83 ec 20          	sub    $0x20,%rsp
  803772:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803775:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803779:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80377c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377f:	89 c7                	mov    %eax,%edi
  803781:	48 b8 30 35 80 00 00 	movabs $0x803530,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
  80378d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803790:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803794:	79 05                	jns    80379b <connect+0x31>
		return r;
  803796:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803799:	eb 1b                	jmp    8037b6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80379b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80379e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a5:	48 89 ce             	mov    %rcx,%rsi
  8037a8:	89 c7                	mov    %eax,%edi
  8037aa:	48 b8 c1 3a 80 00 00 	movabs $0x803ac1,%rax
  8037b1:	00 00 00 
  8037b4:	ff d0                	callq  *%rax
}
  8037b6:	c9                   	leaveq 
  8037b7:	c3                   	retq   

00000000008037b8 <listen>:

int
listen(int s, int backlog)
{
  8037b8:	55                   	push   %rbp
  8037b9:	48 89 e5             	mov    %rsp,%rbp
  8037bc:	48 83 ec 20          	sub    $0x20,%rsp
  8037c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037c3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037c9:	89 c7                	mov    %eax,%edi
  8037cb:	48 b8 30 35 80 00 00 	movabs $0x803530,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
  8037d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037de:	79 05                	jns    8037e5 <listen+0x2d>
		return r;
  8037e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e3:	eb 16                	jmp    8037fb <listen+0x43>
	return nsipc_listen(r, backlog);
  8037e5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037eb:	89 d6                	mov    %edx,%esi
  8037ed:	89 c7                	mov    %eax,%edi
  8037ef:	48 b8 25 3b 80 00 00 	movabs $0x803b25,%rax
  8037f6:	00 00 00 
  8037f9:	ff d0                	callq  *%rax
}
  8037fb:	c9                   	leaveq 
  8037fc:	c3                   	retq   

00000000008037fd <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037fd:	55                   	push   %rbp
  8037fe:	48 89 e5             	mov    %rsp,%rbp
  803801:	48 83 ec 20          	sub    $0x20,%rsp
  803805:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803809:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80380d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803811:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803815:	89 c2                	mov    %eax,%edx
  803817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381b:	8b 40 0c             	mov    0xc(%rax),%eax
  80381e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803822:	b9 00 00 00 00       	mov    $0x0,%ecx
  803827:	89 c7                	mov    %eax,%edi
  803829:	48 b8 65 3b 80 00 00 	movabs $0x803b65,%rax
  803830:	00 00 00 
  803833:	ff d0                	callq  *%rax
}
  803835:	c9                   	leaveq 
  803836:	c3                   	retq   

0000000000803837 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803837:	55                   	push   %rbp
  803838:	48 89 e5             	mov    %rsp,%rbp
  80383b:	48 83 ec 20          	sub    $0x20,%rsp
  80383f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803843:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803847:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80384b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80384f:	89 c2                	mov    %eax,%edx
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803855:	8b 40 0c             	mov    0xc(%rax),%eax
  803858:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80385c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803861:	89 c7                	mov    %eax,%edi
  803863:	48 b8 31 3c 80 00 00 	movabs $0x803c31,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
}
  80386f:	c9                   	leaveq 
  803870:	c3                   	retq   

0000000000803871 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803871:	55                   	push   %rbp
  803872:	48 89 e5             	mov    %rsp,%rbp
  803875:	48 83 ec 10          	sub    $0x10,%rsp
  803879:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80387d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803885:	48 be bb 4f 80 00 00 	movabs $0x804fbb,%rsi
  80388c:	00 00 00 
  80388f:	48 89 c7             	mov    %rax,%rdi
  803892:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  803899:	00 00 00 
  80389c:	ff d0                	callq  *%rax
	return 0;
  80389e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a3:	c9                   	leaveq 
  8038a4:	c3                   	retq   

00000000008038a5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8038a5:	55                   	push   %rbp
  8038a6:	48 89 e5             	mov    %rsp,%rbp
  8038a9:	48 83 ec 20          	sub    $0x20,%rsp
  8038ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8038b3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038b6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038b9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038bf:	89 ce                	mov    %ecx,%esi
  8038c1:	89 c7                	mov    %eax,%edi
  8038c3:	48 b8 e9 3c 80 00 00 	movabs $0x803ce9,%rax
  8038ca:	00 00 00 
  8038cd:	ff d0                	callq  *%rax
  8038cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d6:	79 05                	jns    8038dd <socket+0x38>
		return r;
  8038d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038db:	eb 11                	jmp    8038ee <socket+0x49>
	return alloc_sockfd(r);
  8038dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e0:	89 c7                	mov    %eax,%edi
  8038e2:	48 b8 87 35 80 00 00 	movabs $0x803587,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
}
  8038ee:	c9                   	leaveq 
  8038ef:	c3                   	retq   

00000000008038f0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8038f0:	55                   	push   %rbp
  8038f1:	48 89 e5             	mov    %rsp,%rbp
  8038f4:	48 83 ec 10          	sub    $0x10,%rsp
  8038f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8038fb:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  803902:	00 00 00 
  803905:	8b 00                	mov    (%rax),%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	75 1d                	jne    803928 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80390b:	bf 02 00 00 00       	mov    $0x2,%edi
  803910:	48 b8 17 27 80 00 00 	movabs $0x802717,%rax
  803917:	00 00 00 
  80391a:	ff d0                	callq  *%rax
  80391c:	48 ba 38 70 80 00 00 	movabs $0x807038,%rdx
  803923:	00 00 00 
  803926:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803928:	48 b8 38 70 80 00 00 	movabs $0x807038,%rax
  80392f:	00 00 00 
  803932:	8b 00                	mov    (%rax),%eax
  803934:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803937:	b9 07 00 00 00       	mov    $0x7,%ecx
  80393c:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803943:	00 00 00 
  803946:	89 c7                	mov    %eax,%edi
  803948:	48 b8 54 26 80 00 00 	movabs $0x802654,%rax
  80394f:	00 00 00 
  803952:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803954:	ba 00 00 00 00       	mov    $0x0,%edx
  803959:	be 00 00 00 00       	mov    $0x0,%esi
  80395e:	bf 00 00 00 00       	mov    $0x0,%edi
  803963:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  80396a:	00 00 00 
  80396d:	ff d0                	callq  *%rax
}
  80396f:	c9                   	leaveq 
  803970:	c3                   	retq   

0000000000803971 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803971:	55                   	push   %rbp
  803972:	48 89 e5             	mov    %rsp,%rbp
  803975:	48 83 ec 30          	sub    $0x30,%rsp
  803979:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80397c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803980:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803984:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80398b:	00 00 00 
  80398e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803991:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803993:	bf 01 00 00 00       	mov    $0x1,%edi
  803998:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax
  8039a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ab:	78 3e                	js     8039eb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8039ad:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039b4:	00 00 00 
  8039b7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8039bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039bf:	8b 40 10             	mov    0x10(%rax),%eax
  8039c2:	89 c2                	mov    %eax,%edx
  8039c4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8039c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039cc:	48 89 ce             	mov    %rcx,%rsi
  8039cf:	48 89 c7             	mov    %rax,%rdi
  8039d2:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  8039d9:	00 00 00 
  8039dc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8039de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039e2:	8b 50 10             	mov    0x10(%rax),%edx
  8039e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039e9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8039eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8039ee:	c9                   	leaveq 
  8039ef:	c3                   	retq   

00000000008039f0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039f0:	55                   	push   %rbp
  8039f1:	48 89 e5             	mov    %rsp,%rbp
  8039f4:	48 83 ec 10          	sub    $0x10,%rsp
  8039f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ff:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803a02:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a09:	00 00 00 
  803a0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a18:	48 89 c6             	mov    %rax,%rsi
  803a1b:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803a22:	00 00 00 
  803a25:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803a31:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a38:	00 00 00 
  803a3b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a3e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803a41:	bf 02 00 00 00       	mov    $0x2,%edi
  803a46:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803a4d:	00 00 00 
  803a50:	ff d0                	callq  *%rax
}
  803a52:	c9                   	leaveq 
  803a53:	c3                   	retq   

0000000000803a54 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a54:	55                   	push   %rbp
  803a55:	48 89 e5             	mov    %rsp,%rbp
  803a58:	48 83 ec 10          	sub    $0x10,%rsp
  803a5c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a5f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803a62:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a69:	00 00 00 
  803a6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a6f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803a71:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a78:	00 00 00 
  803a7b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a7e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803a81:	bf 03 00 00 00       	mov    $0x3,%edi
  803a86:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
}
  803a92:	c9                   	leaveq 
  803a93:	c3                   	retq   

0000000000803a94 <nsipc_close>:

int
nsipc_close(int s)
{
  803a94:	55                   	push   %rbp
  803a95:	48 89 e5             	mov    %rsp,%rbp
  803a98:	48 83 ec 10          	sub    $0x10,%rsp
  803a9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803a9f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803aa6:	00 00 00 
  803aa9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803aac:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803aae:	bf 04 00 00 00       	mov    $0x4,%edi
  803ab3:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803aba:	00 00 00 
  803abd:	ff d0                	callq  *%rax
}
  803abf:	c9                   	leaveq 
  803ac0:	c3                   	retq   

0000000000803ac1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ac1:	55                   	push   %rbp
  803ac2:	48 89 e5             	mov    %rsp,%rbp
  803ac5:	48 83 ec 10          	sub    $0x10,%rsp
  803ac9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803acc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ad0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ad3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ada:	00 00 00 
  803add:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ae2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ae9:	48 89 c6             	mov    %rax,%rsi
  803aec:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  803af3:	00 00 00 
  803af6:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803afd:	00 00 00 
  803b00:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803b02:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b09:	00 00 00 
  803b0c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b0f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803b12:	bf 05 00 00 00       	mov    $0x5,%edi
  803b17:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
}
  803b23:	c9                   	leaveq 
  803b24:	c3                   	retq   

0000000000803b25 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b25:	55                   	push   %rbp
  803b26:	48 89 e5             	mov    %rsp,%rbp
  803b29:	48 83 ec 10          	sub    $0x10,%rsp
  803b2d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b30:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803b33:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b3a:	00 00 00 
  803b3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b40:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803b42:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b49:	00 00 00 
  803b4c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b4f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803b52:	bf 06 00 00 00       	mov    $0x6,%edi
  803b57:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803b5e:	00 00 00 
  803b61:	ff d0                	callq  *%rax
}
  803b63:	c9                   	leaveq 
  803b64:	c3                   	retq   

0000000000803b65 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b65:	55                   	push   %rbp
  803b66:	48 89 e5             	mov    %rsp,%rbp
  803b69:	48 83 ec 30          	sub    $0x30,%rsp
  803b6d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b74:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803b77:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803b7a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b81:	00 00 00 
  803b84:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b87:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803b89:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b90:	00 00 00 
  803b93:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803b96:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803b99:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ba0:	00 00 00 
  803ba3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803ba6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803ba9:	bf 07 00 00 00       	mov    $0x7,%edi
  803bae:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803bb5:	00 00 00 
  803bb8:	ff d0                	callq  *%rax
  803bba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc1:	78 69                	js     803c2c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803bc3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803bca:	7f 08                	jg     803bd4 <nsipc_recv+0x6f>
  803bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bcf:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803bd2:	7e 35                	jle    803c09 <nsipc_recv+0xa4>
  803bd4:	48 b9 c2 4f 80 00 00 	movabs $0x804fc2,%rcx
  803bdb:	00 00 00 
  803bde:	48 ba d7 4f 80 00 00 	movabs $0x804fd7,%rdx
  803be5:	00 00 00 
  803be8:	be 61 00 00 00       	mov    $0x61,%esi
  803bed:	48 bf ec 4f 80 00 00 	movabs $0x804fec,%rdi
  803bf4:	00 00 00 
  803bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  803bfc:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  803c03:	00 00 00 
  803c06:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0c:	48 63 d0             	movslq %eax,%rdx
  803c0f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c13:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c1a:	00 00 00 
  803c1d:	48 89 c7             	mov    %rax,%rdi
  803c20:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803c27:	00 00 00 
  803c2a:	ff d0                	callq  *%rax
	}

	return r;
  803c2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c2f:	c9                   	leaveq 
  803c30:	c3                   	retq   

0000000000803c31 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803c31:	55                   	push   %rbp
  803c32:	48 89 e5             	mov    %rsp,%rbp
  803c35:	48 83 ec 20          	sub    $0x20,%rsp
  803c39:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c40:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803c43:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803c46:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c4d:	00 00 00 
  803c50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c53:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803c55:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803c5c:	7e 35                	jle    803c93 <nsipc_send+0x62>
  803c5e:	48 b9 f8 4f 80 00 00 	movabs $0x804ff8,%rcx
  803c65:	00 00 00 
  803c68:	48 ba d7 4f 80 00 00 	movabs $0x804fd7,%rdx
  803c6f:	00 00 00 
  803c72:	be 6c 00 00 00       	mov    $0x6c,%esi
  803c77:	48 bf ec 4f 80 00 00 	movabs $0x804fec,%rdi
  803c7e:	00 00 00 
  803c81:	b8 00 00 00 00       	mov    $0x0,%eax
  803c86:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  803c8d:	00 00 00 
  803c90:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803c93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803c96:	48 63 d0             	movslq %eax,%rdx
  803c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c9d:	48 89 c6             	mov    %rax,%rsi
  803ca0:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803ca7:	00 00 00 
  803caa:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  803cb1:	00 00 00 
  803cb4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803cb6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cbd:	00 00 00 
  803cc0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cc3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803cc6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ccd:	00 00 00 
  803cd0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803cd3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803cd6:	bf 08 00 00 00       	mov    $0x8,%edi
  803cdb:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803ce2:	00 00 00 
  803ce5:	ff d0                	callq  *%rax
}
  803ce7:	c9                   	leaveq 
  803ce8:	c3                   	retq   

0000000000803ce9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ce9:	55                   	push   %rbp
  803cea:	48 89 e5             	mov    %rsp,%rbp
  803ced:	48 83 ec 10          	sub    $0x10,%rsp
  803cf1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803cf7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803cfa:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d01:	00 00 00 
  803d04:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d07:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803d09:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d10:	00 00 00 
  803d13:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d16:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803d19:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d20:	00 00 00 
  803d23:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d26:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803d29:	bf 09 00 00 00       	mov    $0x9,%edi
  803d2e:	48 b8 f0 38 80 00 00 	movabs $0x8038f0,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
}
  803d3a:	c9                   	leaveq 
  803d3b:	c3                   	retq   

0000000000803d3c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d3c:	55                   	push   %rbp
  803d3d:	48 89 e5             	mov    %rsp,%rbp
  803d40:	53                   	push   %rbx
  803d41:	48 83 ec 38          	sub    $0x38,%rsp
  803d45:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d49:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d4d:	48 89 c7             	mov    %rax,%rdi
  803d50:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  803d57:	00 00 00 
  803d5a:	ff d0                	callq  *%rax
  803d5c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d63:	0f 88 bf 01 00 00    	js     803f28 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803d69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d6d:	ba 07 04 00 00       	mov    $0x407,%edx
  803d72:	48 89 c6             	mov    %rax,%rsi
  803d75:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7a:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  803d81:	00 00 00 
  803d84:	ff d0                	callq  *%rax
  803d86:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d8d:	0f 88 95 01 00 00    	js     803f28 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803d93:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d97:	48 89 c7             	mov    %rax,%rdi
  803d9a:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  803da1:	00 00 00 
  803da4:	ff d0                	callq  *%rax
  803da6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803da9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dad:	0f 88 5d 01 00 00    	js     803f10 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803db3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db7:	ba 07 04 00 00       	mov    $0x407,%edx
  803dbc:	48 89 c6             	mov    %rax,%rsi
  803dbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803dc4:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  803dcb:	00 00 00 
  803dce:	ff d0                	callq  *%rax
  803dd0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dd7:	0f 88 33 01 00 00    	js     803f10 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ddd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803de1:	48 89 c7             	mov    %rax,%rdi
  803de4:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  803deb:	00 00 00 
  803dee:	ff d0                	callq  *%rax
  803df0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803df4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df8:	ba 07 04 00 00       	mov    $0x407,%edx
  803dfd:	48 89 c6             	mov    %rax,%rsi
  803e00:	bf 00 00 00 00       	mov    $0x0,%edi
  803e05:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  803e0c:	00 00 00 
  803e0f:	ff d0                	callq  *%rax
  803e11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e18:	0f 88 d9 00 00 00    	js     803ef7 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e1e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e22:	48 89 c7             	mov    %rax,%rdi
  803e25:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  803e2c:	00 00 00 
  803e2f:	ff d0                	callq  *%rax
  803e31:	48 89 c2             	mov    %rax,%rdx
  803e34:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e38:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e3e:	48 89 d1             	mov    %rdx,%rcx
  803e41:	ba 00 00 00 00       	mov    $0x0,%edx
  803e46:	48 89 c6             	mov    %rax,%rsi
  803e49:	bf 00 00 00 00       	mov    $0x0,%edi
  803e4e:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  803e55:	00 00 00 
  803e58:	ff d0                	callq  *%rax
  803e5a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e61:	78 79                	js     803edc <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803e63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e67:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e6e:	00 00 00 
  803e71:	8b 12                	mov    (%rdx),%edx
  803e73:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803e80:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e84:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803e8b:	00 00 00 
  803e8e:	8b 12                	mov    (%rdx),%edx
  803e90:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803e92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e96:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea1:	48 89 c7             	mov    %rax,%rdi
  803ea4:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  803eab:	00 00 00 
  803eae:	ff d0                	callq  *%rax
  803eb0:	89 c2                	mov    %eax,%edx
  803eb2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803eb6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803eb8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803ebc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803ec0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ec4:	48 89 c7             	mov    %rax,%rdi
  803ec7:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  803ece:	00 00 00 
  803ed1:	ff d0                	callq  *%rax
  803ed3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  803eda:	eb 4f                	jmp    803f2b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803edc:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803edd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee1:	48 89 c6             	mov    %rax,%rsi
  803ee4:	bf 00 00 00 00       	mov    $0x0,%edi
  803ee9:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803ef0:	00 00 00 
  803ef3:	ff d0                	callq  *%rax
  803ef5:	eb 01                	jmp    803ef8 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803ef7:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803ef8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803efc:	48 89 c6             	mov    %rax,%rsi
  803eff:	bf 00 00 00 00       	mov    $0x0,%edi
  803f04:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803f0b:	00 00 00 
  803f0e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803f10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f14:	48 89 c6             	mov    %rax,%rsi
  803f17:	bf 00 00 00 00       	mov    $0x0,%edi
  803f1c:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
    err:
	return r;
  803f28:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f2b:	48 83 c4 38          	add    $0x38,%rsp
  803f2f:	5b                   	pop    %rbx
  803f30:	5d                   	pop    %rbp
  803f31:	c3                   	retq   

0000000000803f32 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f32:	55                   	push   %rbp
  803f33:	48 89 e5             	mov    %rsp,%rbp
  803f36:	53                   	push   %rbx
  803f37:	48 83 ec 28          	sub    $0x28,%rsp
  803f3b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f43:	eb 01                	jmp    803f46 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803f45:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f46:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f4d:	00 00 00 
  803f50:	48 8b 00             	mov    (%rax),%rax
  803f53:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f59:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f60:	48 89 c7             	mov    %rax,%rdi
  803f63:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803f6a:	00 00 00 
  803f6d:	ff d0                	callq  *%rax
  803f6f:	89 c3                	mov    %eax,%ebx
  803f71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f75:	48 89 c7             	mov    %rax,%rdi
  803f78:	48 b8 a4 34 80 00 00 	movabs $0x8034a4,%rax
  803f7f:	00 00 00 
  803f82:	ff d0                	callq  *%rax
  803f84:	39 c3                	cmp    %eax,%ebx
  803f86:	0f 94 c0             	sete   %al
  803f89:	0f b6 c0             	movzbl %al,%eax
  803f8c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803f8f:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803f96:	00 00 00 
  803f99:	48 8b 00             	mov    (%rax),%rax
  803f9c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fa2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803fa5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fab:	75 0a                	jne    803fb7 <_pipeisclosed+0x85>
			return ret;
  803fad:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803fb0:	48 83 c4 28          	add    $0x28,%rsp
  803fb4:	5b                   	pop    %rbx
  803fb5:	5d                   	pop    %rbp
  803fb6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803fb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fba:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fbd:	74 86                	je     803f45 <_pipeisclosed+0x13>
  803fbf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803fc3:	75 80                	jne    803f45 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803fc5:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803fcc:	00 00 00 
  803fcf:	48 8b 00             	mov    (%rax),%rax
  803fd2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803fd8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803fdb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fde:	89 c6                	mov    %eax,%esi
  803fe0:	48 bf 09 50 80 00 00 	movabs $0x805009,%rdi
  803fe7:	00 00 00 
  803fea:	b8 00 00 00 00       	mov    $0x0,%eax
  803fef:	49 b8 9b 06 80 00 00 	movabs $0x80069b,%r8
  803ff6:	00 00 00 
  803ff9:	41 ff d0             	callq  *%r8
	}
  803ffc:	e9 44 ff ff ff       	jmpq   803f45 <_pipeisclosed+0x13>

0000000000804001 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804001:	55                   	push   %rbp
  804002:	48 89 e5             	mov    %rsp,%rbp
  804005:	48 83 ec 30          	sub    $0x30,%rsp
  804009:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80400c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804010:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804013:	48 89 d6             	mov    %rdx,%rsi
  804016:	89 c7                	mov    %eax,%edi
  804018:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  80401f:	00 00 00 
  804022:	ff d0                	callq  *%rax
  804024:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402b:	79 05                	jns    804032 <pipeisclosed+0x31>
		return r;
  80402d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804030:	eb 31                	jmp    804063 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804036:	48 89 c7             	mov    %rax,%rdi
  804039:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804049:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80404d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804051:	48 89 d6             	mov    %rdx,%rsi
  804054:	48 89 c7             	mov    %rax,%rdi
  804057:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  80405e:	00 00 00 
  804061:	ff d0                	callq  *%rax
}
  804063:	c9                   	leaveq 
  804064:	c3                   	retq   

0000000000804065 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804065:	55                   	push   %rbp
  804066:	48 89 e5             	mov    %rsp,%rbp
  804069:	48 83 ec 40          	sub    $0x40,%rsp
  80406d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804071:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804075:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804079:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80407d:	48 89 c7             	mov    %rax,%rdi
  804080:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  804087:	00 00 00 
  80408a:	ff d0                	callq  *%rax
  80408c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804090:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804094:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804098:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80409f:	00 
  8040a0:	e9 97 00 00 00       	jmpq   80413c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040a5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040aa:	74 09                	je     8040b5 <devpipe_read+0x50>
				return i;
  8040ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040b0:	e9 95 00 00 00       	jmpq   80414a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040bd:	48 89 d6             	mov    %rdx,%rsi
  8040c0:	48 89 c7             	mov    %rax,%rdi
  8040c3:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  8040ca:	00 00 00 
  8040cd:	ff d0                	callq  *%rax
  8040cf:	85 c0                	test   %eax,%eax
  8040d1:	74 07                	je     8040da <devpipe_read+0x75>
				return 0;
  8040d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d8:	eb 70                	jmp    80414a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8040da:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  8040e1:	00 00 00 
  8040e4:	ff d0                	callq  *%rax
  8040e6:	eb 01                	jmp    8040e9 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8040e8:	90                   	nop
  8040e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ed:	8b 10                	mov    (%rax),%edx
  8040ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f3:	8b 40 04             	mov    0x4(%rax),%eax
  8040f6:	39 c2                	cmp    %eax,%edx
  8040f8:	74 ab                	je     8040a5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8040fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804102:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80410a:	8b 00                	mov    (%rax),%eax
  80410c:	89 c2                	mov    %eax,%edx
  80410e:	c1 fa 1f             	sar    $0x1f,%edx
  804111:	c1 ea 1b             	shr    $0x1b,%edx
  804114:	01 d0                	add    %edx,%eax
  804116:	83 e0 1f             	and    $0x1f,%eax
  804119:	29 d0                	sub    %edx,%eax
  80411b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80411f:	48 98                	cltq   
  804121:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804126:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412c:	8b 00                	mov    (%rax),%eax
  80412e:	8d 50 01             	lea    0x1(%rax),%edx
  804131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804135:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804137:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80413c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804140:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804144:	72 a2                	jb     8040e8 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80414a:	c9                   	leaveq 
  80414b:	c3                   	retq   

000000000080414c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80414c:	55                   	push   %rbp
  80414d:	48 89 e5             	mov    %rsp,%rbp
  804150:	48 83 ec 40          	sub    $0x40,%rsp
  804154:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804158:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80415c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804164:	48 89 c7             	mov    %rax,%rdi
  804167:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80416e:	00 00 00 
  804171:	ff d0                	callq  *%rax
  804173:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804177:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80417b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80417f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804186:	00 
  804187:	e9 93 00 00 00       	jmpq   80421f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80418c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804194:	48 89 d6             	mov    %rdx,%rsi
  804197:	48 89 c7             	mov    %rax,%rdi
  80419a:	48 b8 32 3f 80 00 00 	movabs $0x803f32,%rax
  8041a1:	00 00 00 
  8041a4:	ff d0                	callq  *%rax
  8041a6:	85 c0                	test   %eax,%eax
  8041a8:	74 07                	je     8041b1 <devpipe_write+0x65>
				return 0;
  8041aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8041af:	eb 7c                	jmp    80422d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041b1:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  8041b8:	00 00 00 
  8041bb:	ff d0                	callq  *%rax
  8041bd:	eb 01                	jmp    8041c0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041bf:	90                   	nop
  8041c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c4:	8b 40 04             	mov    0x4(%rax),%eax
  8041c7:	48 63 d0             	movslq %eax,%rdx
  8041ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ce:	8b 00                	mov    (%rax),%eax
  8041d0:	48 98                	cltq   
  8041d2:	48 83 c0 20          	add    $0x20,%rax
  8041d6:	48 39 c2             	cmp    %rax,%rdx
  8041d9:	73 b1                	jae    80418c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041df:	8b 40 04             	mov    0x4(%rax),%eax
  8041e2:	89 c2                	mov    %eax,%edx
  8041e4:	c1 fa 1f             	sar    $0x1f,%edx
  8041e7:	c1 ea 1b             	shr    $0x1b,%edx
  8041ea:	01 d0                	add    %edx,%eax
  8041ec:	83 e0 1f             	and    $0x1f,%eax
  8041ef:	29 d0                	sub    %edx,%eax
  8041f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041f5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8041f9:	48 01 ca             	add    %rcx,%rdx
  8041fc:	0f b6 0a             	movzbl (%rdx),%ecx
  8041ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804203:	48 98                	cltq   
  804205:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80420d:	8b 40 04             	mov    0x4(%rax),%eax
  804210:	8d 50 01             	lea    0x1(%rax),%edx
  804213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804217:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80421a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80421f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804223:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804227:	72 96                	jb     8041bf <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80422d:	c9                   	leaveq 
  80422e:	c3                   	retq   

000000000080422f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80422f:	55                   	push   %rbp
  804230:	48 89 e5             	mov    %rsp,%rbp
  804233:	48 83 ec 20          	sub    $0x20,%rsp
  804237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80423b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80423f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804243:	48 89 c7             	mov    %rax,%rdi
  804246:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  80424d:	00 00 00 
  804250:	ff d0                	callq  *%rax
  804252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804256:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80425a:	48 be 1c 50 80 00 00 	movabs $0x80501c,%rsi
  804261:	00 00 00 
  804264:	48 89 c7             	mov    %rax,%rdi
  804267:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  80426e:	00 00 00 
  804271:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804277:	8b 50 04             	mov    0x4(%rax),%edx
  80427a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80427e:	8b 00                	mov    (%rax),%eax
  804280:	29 c2                	sub    %eax,%edx
  804282:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804286:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80428c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804290:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804297:	00 00 00 
	stat->st_dev = &devpipe;
  80429a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80429e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8042a5:	00 00 00 
  8042a8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8042af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042b4:	c9                   	leaveq 
  8042b5:	c3                   	retq   

00000000008042b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042b6:	55                   	push   %rbp
  8042b7:	48 89 e5             	mov    %rsp,%rbp
  8042ba:	48 83 ec 10          	sub    $0x10,%rsp
  8042be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c6:	48 89 c6             	mov    %rax,%rsi
  8042c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8042ce:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8042da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042de:	48 89 c7             	mov    %rax,%rdi
  8042e1:	48 b8 bf 27 80 00 00 	movabs $0x8027bf,%rax
  8042e8:	00 00 00 
  8042eb:	ff d0                	callq  *%rax
  8042ed:	48 89 c6             	mov    %rax,%rsi
  8042f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8042f5:	48 b8 3b 1c 80 00 00 	movabs $0x801c3b,%rax
  8042fc:	00 00 00 
  8042ff:	ff d0                	callq  *%rax
}
  804301:	c9                   	leaveq 
  804302:	c3                   	retq   
	...

0000000000804304 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804304:	55                   	push   %rbp
  804305:	48 89 e5             	mov    %rsp,%rbp
  804308:	48 83 ec 20          	sub    $0x20,%rsp
  80430c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80430f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804312:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804315:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804319:	be 01 00 00 00       	mov    $0x1,%esi
  80431e:	48 89 c7             	mov    %rax,%rdi
  804321:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  804328:	00 00 00 
  80432b:	ff d0                	callq  *%rax
}
  80432d:	c9                   	leaveq 
  80432e:	c3                   	retq   

000000000080432f <getchar>:

int
getchar(void)
{
  80432f:	55                   	push   %rbp
  804330:	48 89 e5             	mov    %rsp,%rbp
  804333:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804337:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80433b:	ba 01 00 00 00       	mov    $0x1,%edx
  804340:	48 89 c6             	mov    %rax,%rsi
  804343:	bf 00 00 00 00       	mov    $0x0,%edi
  804348:	48 b8 b4 2c 80 00 00 	movabs $0x802cb4,%rax
  80434f:	00 00 00 
  804352:	ff d0                	callq  *%rax
  804354:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804357:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80435b:	79 05                	jns    804362 <getchar+0x33>
		return r;
  80435d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804360:	eb 14                	jmp    804376 <getchar+0x47>
	if (r < 1)
  804362:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804366:	7f 07                	jg     80436f <getchar+0x40>
		return -E_EOF;
  804368:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80436d:	eb 07                	jmp    804376 <getchar+0x47>
	return c;
  80436f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804373:	0f b6 c0             	movzbl %al,%eax
}
  804376:	c9                   	leaveq 
  804377:	c3                   	retq   

0000000000804378 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804378:	55                   	push   %rbp
  804379:	48 89 e5             	mov    %rsp,%rbp
  80437c:	48 83 ec 20          	sub    $0x20,%rsp
  804380:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804383:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804387:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80438a:	48 89 d6             	mov    %rdx,%rsi
  80438d:	89 c7                	mov    %eax,%edi
  80438f:	48 b8 82 28 80 00 00 	movabs $0x802882,%rax
  804396:	00 00 00 
  804399:	ff d0                	callq  *%rax
  80439b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80439e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043a2:	79 05                	jns    8043a9 <iscons+0x31>
		return r;
  8043a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a7:	eb 1a                	jmp    8043c3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8043a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ad:	8b 10                	mov    (%rax),%edx
  8043af:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8043b6:	00 00 00 
  8043b9:	8b 00                	mov    (%rax),%eax
  8043bb:	39 c2                	cmp    %eax,%edx
  8043bd:	0f 94 c0             	sete   %al
  8043c0:	0f b6 c0             	movzbl %al,%eax
}
  8043c3:	c9                   	leaveq 
  8043c4:	c3                   	retq   

00000000008043c5 <opencons>:

int
opencons(void)
{
  8043c5:	55                   	push   %rbp
  8043c6:	48 89 e5             	mov    %rsp,%rbp
  8043c9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8043cd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043d1:	48 89 c7             	mov    %rax,%rdi
  8043d4:	48 b8 ea 27 80 00 00 	movabs $0x8027ea,%rax
  8043db:	00 00 00 
  8043de:	ff d0                	callq  *%rax
  8043e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043e7:	79 05                	jns    8043ee <opencons+0x29>
		return r;
  8043e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043ec:	eb 5b                	jmp    804449 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8043ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f2:	ba 07 04 00 00       	mov    $0x407,%edx
  8043f7:	48 89 c6             	mov    %rax,%rsi
  8043fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ff:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  804406:	00 00 00 
  804409:	ff d0                	callq  *%rax
  80440b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80440e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804412:	79 05                	jns    804419 <opencons+0x54>
		return r;
  804414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804417:	eb 30                	jmp    804449 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80441d:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804424:	00 00 00 
  804427:	8b 12                	mov    (%rdx),%edx
  804429:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80442b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443a:	48 89 c7             	mov    %rax,%rdi
  80443d:	48 b8 9c 27 80 00 00 	movabs $0x80279c,%rax
  804444:	00 00 00 
  804447:	ff d0                	callq  *%rax
}
  804449:	c9                   	leaveq 
  80444a:	c3                   	retq   

000000000080444b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80444b:	55                   	push   %rbp
  80444c:	48 89 e5             	mov    %rsp,%rbp
  80444f:	48 83 ec 30          	sub    $0x30,%rsp
  804453:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804457:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80445b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80445f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804464:	75 13                	jne    804479 <devcons_read+0x2e>
		return 0;
  804466:	b8 00 00 00 00       	mov    $0x0,%eax
  80446b:	eb 49                	jmp    8044b6 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80446d:	48 b8 52 1b 80 00 00 	movabs $0x801b52,%rax
  804474:	00 00 00 
  804477:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804479:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
  804485:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804488:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80448c:	74 df                	je     80446d <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80448e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804492:	79 05                	jns    804499 <devcons_read+0x4e>
		return c;
  804494:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804497:	eb 1d                	jmp    8044b6 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804499:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80449d:	75 07                	jne    8044a6 <devcons_read+0x5b>
		return 0;
  80449f:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a4:	eb 10                	jmp    8044b6 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8044a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044a9:	89 c2                	mov    %eax,%edx
  8044ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044af:	88 10                	mov    %dl,(%rax)
	return 1;
  8044b1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8044b6:	c9                   	leaveq 
  8044b7:	c3                   	retq   

00000000008044b8 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044b8:	55                   	push   %rbp
  8044b9:	48 89 e5             	mov    %rsp,%rbp
  8044bc:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8044c3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8044ca:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8044d1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8044df:	eb 77                	jmp    804558 <devcons_write+0xa0>
		m = n - tot;
  8044e1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8044e8:	89 c2                	mov    %eax,%edx
  8044ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ed:	89 d1                	mov    %edx,%ecx
  8044ef:	29 c1                	sub    %eax,%ecx
  8044f1:	89 c8                	mov    %ecx,%eax
  8044f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8044f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8044f9:	83 f8 7f             	cmp    $0x7f,%eax
  8044fc:	76 07                	jbe    804505 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  8044fe:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804505:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804508:	48 63 d0             	movslq %eax,%rdx
  80450b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80450e:	48 98                	cltq   
  804510:	48 89 c1             	mov    %rax,%rcx
  804513:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80451a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804521:	48 89 ce             	mov    %rcx,%rsi
  804524:	48 89 c7             	mov    %rax,%rdi
  804527:	48 b8 7a 15 80 00 00 	movabs $0x80157a,%rax
  80452e:	00 00 00 
  804531:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804533:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804536:	48 63 d0             	movslq %eax,%rdx
  804539:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804540:	48 89 d6             	mov    %rdx,%rsi
  804543:	48 89 c7             	mov    %rax,%rdi
  804546:	48 b8 48 1a 80 00 00 	movabs $0x801a48,%rax
  80454d:	00 00 00 
  804550:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804552:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804555:	01 45 fc             	add    %eax,-0x4(%rbp)
  804558:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80455b:	48 98                	cltq   
  80455d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804564:	0f 82 77 ff ff ff    	jb     8044e1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80456a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80456d:	c9                   	leaveq 
  80456e:	c3                   	retq   

000000000080456f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80456f:	55                   	push   %rbp
  804570:	48 89 e5             	mov    %rsp,%rbp
  804573:	48 83 ec 08          	sub    $0x8,%rsp
  804577:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80457b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804580:	c9                   	leaveq 
  804581:	c3                   	retq   

0000000000804582 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804582:	55                   	push   %rbp
  804583:	48 89 e5             	mov    %rsp,%rbp
  804586:	48 83 ec 10          	sub    $0x10,%rsp
  80458a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80458e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804596:	48 be 28 50 80 00 00 	movabs $0x805028,%rsi
  80459d:	00 00 00 
  8045a0:	48 89 c7             	mov    %rax,%rdi
  8045a3:	48 b8 58 12 80 00 00 	movabs $0x801258,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
	return 0;
  8045af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045b4:	c9                   	leaveq 
  8045b5:	c3                   	retq   
	...

00000000008045b8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8045b8:	55                   	push   %rbp
  8045b9:	48 89 e5             	mov    %rsp,%rbp
  8045bc:	48 83 ec 20          	sub    $0x20,%rsp
  8045c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8045c4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045cb:	00 00 00 
  8045ce:	48 8b 00             	mov    (%rax),%rax
  8045d1:	48 85 c0             	test   %rax,%rax
  8045d4:	0f 85 8e 00 00 00    	jne    804668 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8045da:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8045e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8045e8:	48 b8 14 1b 80 00 00 	movabs $0x801b14,%rax
  8045ef:	00 00 00 
  8045f2:	ff d0                	callq  *%rax
  8045f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8045f7:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8045fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045fe:	ba 07 00 00 00       	mov    $0x7,%edx
  804603:	48 89 ce             	mov    %rcx,%rsi
  804606:	89 c7                	mov    %eax,%edi
  804608:	48 b8 90 1b 80 00 00 	movabs $0x801b90,%rax
  80460f:	00 00 00 
  804612:	ff d0                	callq  *%rax
  804614:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  804617:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80461b:	74 30                	je     80464d <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  80461d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804620:	89 c1                	mov    %eax,%ecx
  804622:	48 ba 30 50 80 00 00 	movabs $0x805030,%rdx
  804629:	00 00 00 
  80462c:	be 24 00 00 00       	mov    $0x24,%esi
  804631:	48 bf 67 50 80 00 00 	movabs $0x805067,%rdi
  804638:	00 00 00 
  80463b:	b8 00 00 00 00       	mov    $0x0,%eax
  804640:	49 b8 60 04 80 00 00 	movabs $0x800460,%r8
  804647:	00 00 00 
  80464a:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80464d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804650:	48 be 7c 46 80 00 00 	movabs $0x80467c,%rsi
  804657:	00 00 00 
  80465a:	89 c7                	mov    %eax,%edi
  80465c:	48 b8 1a 1d 80 00 00 	movabs $0x801d1a,%rax
  804663:	00 00 00 
  804666:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804668:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80466f:	00 00 00 
  804672:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804676:	48 89 10             	mov    %rdx,(%rax)
}
  804679:	c9                   	leaveq 
  80467a:	c3                   	retq   
	...

000000000080467c <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80467c:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80467f:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  804686:	00 00 00 
	call *%rax
  804689:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  80468b:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  80468f:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  804693:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  804696:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80469d:	00 
		movq 120(%rsp), %rcx				// trap time rip
  80469e:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8046a3:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8046a6:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8046a7:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8046aa:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8046b1:	00 08 
		POPA_						// copy the register contents to the registers
  8046b3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8046b7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8046bc:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8046c1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8046c6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8046cb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8046d0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8046d5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8046da:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8046df:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8046e4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8046e9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8046ee:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8046f3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8046f8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8046fd:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804701:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  804705:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  804706:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  804707:	c3                   	retq   
