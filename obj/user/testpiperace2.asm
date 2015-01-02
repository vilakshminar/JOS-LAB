
obj/user/testpiperace2.debug:     file format elf64-x86-64


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
  80003c:	e8 f3 02 00 00       	callq  800334 <libmain>
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
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800053:	48 bf c0 46 80 00 00 	movabs $0x8046c0,%rdi
  80005a:	00 00 00 
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
  800062:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  800069:	00 00 00 
  80006c:	ff d2                	callq  *%rdx
	if ((r = pipe(p)) < 0)
  80006e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800072:	48 89 c7             	mov    %rax,%rdi
  800075:	48 b8 44 3a 80 00 00 	movabs $0x803a44,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
  800081:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800084:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800088:	79 30                	jns    8000ba <umain+0x76>
		panic("pipe: %e", r);
  80008a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80008d:	89 c1                	mov    %eax,%ecx
  80008f:	48 ba e2 46 80 00 00 	movabs $0x8046e2,%rdx
  800096:	00 00 00 
  800099:	be 0d 00 00 00       	mov    $0xd,%esi
  80009e:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  8000a5:	00 00 00 
  8000a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ad:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  8000b4:	00 00 00 
  8000b7:	41 ff d0             	callq  *%r8
	if ((r = fork()) < 0)
  8000ba:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
  8000c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000c9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cd:	79 30                	jns    8000ff <umain+0xbb>
		panic("fork: %e", r);
  8000cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d2:	89 c1                	mov    %eax,%ecx
  8000d4:	48 ba 00 47 80 00 00 	movabs $0x804700,%rdx
  8000db:	00 00 00 
  8000de:	be 0f 00 00 00       	mov    $0xf,%esi
  8000e3:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  8000ea:	00 00 00 
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  8000f9:	00 00 00 
  8000fc:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000ff:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800103:	0f 85 c0 00 00 00    	jne    8001c9 <umain+0x185>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  800109:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80010c:	89 c7                	mov    %eax,%edi
  80010e:	48 b8 26 28 80 00 00 	movabs $0x802826,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
		for (i = 0; i < 200; i++) {
  80011a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800121:	e9 8a 00 00 00       	jmpq   8001b0 <umain+0x16c>
			if (i % 10 == 0)
  800126:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800129:	ba 67 66 66 66       	mov    $0x66666667,%edx
  80012e:	89 c8                	mov    %ecx,%eax
  800130:	f7 ea                	imul   %edx
  800132:	c1 fa 02             	sar    $0x2,%edx
  800135:	89 c8                	mov    %ecx,%eax
  800137:	c1 f8 1f             	sar    $0x1f,%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	89 d0                	mov    %edx,%eax
  80013e:	c1 e0 02             	shl    $0x2,%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	01 c0                	add    %eax,%eax
  800145:	89 ca                	mov    %ecx,%edx
  800147:	29 c2                	sub    %eax,%edx
  800149:	85 d2                	test   %edx,%edx
  80014b:	75 20                	jne    80016d <umain+0x129>
				cprintf("%d.", i);
  80014d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800150:	89 c6                	mov    %eax,%esi
  800152:	48 bf 09 47 80 00 00 	movabs $0x804709,%rdi
  800159:	00 00 00 
  80015c:	b8 00 00 00 00       	mov    $0x0,%eax
  800161:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  800168:	00 00 00 
  80016b:	ff d2                	callq  *%rdx
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  80016d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800170:	be 0a 00 00 00       	mov    $0xa,%esi
  800175:	89 c7                	mov    %eax,%edi
  800177:	48 b8 9f 28 80 00 00 	movabs $0x80289f,%rax
  80017e:	00 00 00 
  800181:	ff d0                	callq  *%rax
			sys_yield();
  800183:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
			close(10);
  80018f:	bf 0a 00 00 00       	mov    $0xa,%edi
  800194:	48 b8 26 28 80 00 00 	movabs $0x802826,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax
			sys_yield();
  8001a0:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  8001ac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b0:	81 7d fc c7 00 00 00 	cmpl   $0xc7,-0x4(%rbp)
  8001b7:	0f 8e 69 ff ff ff    	jle    800126 <umain+0xe2>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  8001bd:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8001c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001cc:	48 98                	cltq   
  8001ce:	48 89 c2             	mov    %rax,%rdx
  8001d1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8001d7:	48 89 d0             	mov    %rdx,%rax
  8001da:	48 c1 e0 03          	shl    $0x3,%rax
  8001de:	48 01 d0             	add    %rdx,%rax
  8001e1:	48 c1 e0 05          	shl    $0x5,%rax
  8001e5:	48 89 c2             	mov    %rax,%rdx
  8001e8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001ef:	00 00 00 
  8001f2:	48 01 d0             	add    %rdx,%rax
  8001f5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	while (kid->env_status == ENV_RUNNABLE)
  8001f9:	eb 4d                	jmp    800248 <umain+0x204>
		if (pipeisclosed(p[0]) != 0) {
  8001fb:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8001fe:	89 c7                	mov    %eax,%edi
  800200:	48 b8 09 3d 80 00 00 	movabs $0x803d09,%rax
  800207:	00 00 00 
  80020a:	ff d0                	callq  *%rax
  80020c:	85 c0                	test   %eax,%eax
  80020e:	74 38                	je     800248 <umain+0x204>
			cprintf("\nRACE: pipe appears closed\n");
  800210:	48 bf 0d 47 80 00 00 	movabs $0x80470d,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  800226:	00 00 00 
  800229:	ff d2                	callq  *%rdx
			sys_env_destroy(r);
  80022b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80022e:	89 c7                	mov    %eax,%edi
  800230:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
			exit();
  80023c:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800243:	00 00 00 
  800246:	ff d0                	callq  *%rax
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024c:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  800252:	83 f8 02             	cmp    $0x2,%eax
  800255:	74 a4                	je     8001fb <umain+0x1b7>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  800257:	48 bf 29 47 80 00 00 	movabs $0x804729,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
	if (pipeisclosed(p[0]))
  800272:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800275:	89 c7                	mov    %eax,%edi
  800277:	48 b8 09 3d 80 00 00 	movabs $0x803d09,%rax
  80027e:	00 00 00 
  800281:	ff d0                	callq  *%rax
  800283:	85 c0                	test   %eax,%eax
  800285:	74 2a                	je     8002b1 <umain+0x26d>
		panic("somehow the other end of p[0] got closed!");
  800287:	48 ba 40 47 80 00 00 	movabs $0x804740,%rdx
  80028e:	00 00 00 
  800291:	be 40 00 00 00       	mov    $0x40,%esi
  800296:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  80029d:	00 00 00 
  8002a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a5:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  8002ac:	00 00 00 
  8002af:	ff d1                	callq  *%rcx
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8002b1:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002b4:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8002b8:	48 89 d6             	mov    %rdx,%rsi
  8002bb:	89 c7                	mov    %eax,%edi
  8002bd:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
  8002c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002cc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002d0:	79 30                	jns    800302 <umain+0x2be>
		panic("cannot look up p[0]: %e", r);
  8002d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002d5:	89 c1                	mov    %eax,%ecx
  8002d7:	48 ba 6a 47 80 00 00 	movabs $0x80476a,%rdx
  8002de:	00 00 00 
  8002e1:	be 42 00 00 00       	mov    $0x42,%esi
  8002e6:	48 bf eb 46 80 00 00 	movabs $0x8046eb,%rdi
  8002ed:	00 00 00 
  8002f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f5:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  8002fc:	00 00 00 
  8002ff:	41 ff d0             	callq  *%r8
	(void) fd2data(fd);
  800302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800306:	48 89 c7             	mov    %rax,%rdi
  800309:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  800310:	00 00 00 
  800313:	ff d0                	callq  *%rax
	cprintf("race didn't happen\n");
  800315:	48 bf 82 47 80 00 00 	movabs $0x804782,%rdi
  80031c:	00 00 00 
  80031f:	b8 00 00 00 00       	mov    $0x0,%eax
  800324:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  80032b:	00 00 00 
  80032e:	ff d2                	callq  *%rdx
}
  800330:	c9                   	leaveq 
  800331:	c3                   	retq   
	...

0000000000800334 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800334:	55                   	push   %rbp
  800335:	48 89 e5             	mov    %rsp,%rbp
  800338:	48 83 ec 10          	sub    $0x10,%rsp
  80033c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80033f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800343:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  80034a:	00 00 00 
  80034d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800354:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  80035b:	00 00 00 
  80035e:	ff d0                	callq  *%rax
  800360:	48 98                	cltq   
  800362:	48 89 c2             	mov    %rax,%rdx
  800365:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80036b:	48 89 d0             	mov    %rdx,%rax
  80036e:	48 c1 e0 03          	shl    $0x3,%rax
  800372:	48 01 d0             	add    %rdx,%rax
  800375:	48 c1 e0 05          	shl    $0x5,%rax
  800379:	48 89 c2             	mov    %rax,%rdx
  80037c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800383:	00 00 00 
  800386:	48 01 c2             	add    %rax,%rdx
  800389:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  800390:	00 00 00 
  800393:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  800396:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80039a:	7e 14                	jle    8003b0 <libmain+0x7c>
		binaryname = argv[0];
  80039c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a0:	48 8b 10             	mov    (%rax),%rdx
  8003a3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003aa:	00 00 00 
  8003ad:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b7:	48 89 d6             	mov    %rdx,%rsi
  8003ba:	89 c7                	mov    %eax,%edi
  8003bc:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003c3:	00 00 00 
  8003c6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003c8:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  8003cf:	00 00 00 
  8003d2:	ff d0                	callq  *%rax
}
  8003d4:	c9                   	leaveq 
  8003d5:	c3                   	retq   
	...

00000000008003d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003dc:	48 b8 71 28 80 00 00 	movabs $0x802871,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8003ed:	48 b8 6c 1a 80 00 00 	movabs $0x801a6c,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
}
  8003f9:	5d                   	pop    %rbp
  8003fa:	c3                   	retq   
	...

00000000008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003fc:	55                   	push   %rbp
  8003fd:	48 89 e5             	mov    %rsp,%rbp
  800400:	53                   	push   %rbx
  800401:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800408:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80040f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800415:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80041c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800423:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80042a:	84 c0                	test   %al,%al
  80042c:	74 23                	je     800451 <_panic+0x55>
  80042e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800435:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800439:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80043d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800441:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800445:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800449:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80044d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800451:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800458:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80045f:	00 00 00 
  800462:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800469:	00 00 00 
  80046c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800470:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800477:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80047e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800485:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80048c:	00 00 00 
  80048f:	48 8b 18             	mov    (%rax),%rbx
  800492:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  800499:	00 00 00 
  80049c:	ff d0                	callq  *%rax
  80049e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004ab:	41 89 c8             	mov    %ecx,%r8d
  8004ae:	48 89 d1             	mov    %rdx,%rcx
  8004b1:	48 89 da             	mov    %rbx,%rdx
  8004b4:	89 c6                	mov    %eax,%esi
  8004b6:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	49 b9 37 06 80 00 00 	movabs $0x800637,%r9
  8004cc:	00 00 00 
  8004cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004e0:	48 89 d6             	mov    %rdx,%rsi
  8004e3:	48 89 c7             	mov    %rax,%rdi
  8004e6:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8004f2:	48 bf c3 47 80 00 00 	movabs $0x8047c3,%rdi
  8004f9:	00 00 00 
  8004fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800501:	48 ba 37 06 80 00 00 	movabs $0x800637,%rdx
  800508:	00 00 00 
  80050b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80050d:	cc                   	int3   
  80050e:	eb fd                	jmp    80050d <_panic+0x111>

0000000000800510 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800510:	55                   	push   %rbp
  800511:	48 89 e5             	mov    %rsp,%rbp
  800514:	48 83 ec 10          	sub    $0x10,%rsp
  800518:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80051b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80051f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800528:	89 d6                	mov    %edx,%esi
  80052a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80052e:	48 63 d0             	movslq %eax,%rdx
  800531:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800536:	8d 50 01             	lea    0x1(%rax),%edx
  800539:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80053d:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  80053f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800543:	8b 00                	mov    (%rax),%eax
  800545:	3d ff 00 00 00       	cmp    $0xff,%eax
  80054a:	75 2c                	jne    800578 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  80054c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800550:	8b 00                	mov    (%rax),%eax
  800552:	48 98                	cltq   
  800554:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800558:	48 83 c2 08          	add    $0x8,%rdx
  80055c:	48 89 c6             	mov    %rax,%rsi
  80055f:	48 89 d7             	mov    %rdx,%rdi
  800562:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
		b->idx = 0;
  80056e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800572:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057c:	8b 40 04             	mov    0x4(%rax),%eax
  80057f:	8d 50 01             	lea    0x1(%rax),%edx
  800582:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800586:	89 50 04             	mov    %edx,0x4(%rax)
}
  800589:	c9                   	leaveq 
  80058a:	c3                   	retq   

000000000080058b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80058b:	55                   	push   %rbp
  80058c:	48 89 e5             	mov    %rsp,%rbp
  80058f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800596:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80059d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005a4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005ab:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005b2:	48 8b 0a             	mov    (%rdx),%rcx
  8005b5:	48 89 08             	mov    %rcx,(%rax)
  8005b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005cf:	00 00 00 
	b.cnt = 0;
  8005d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005dc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005e3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005ea:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005f1:	48 89 c6             	mov    %rax,%rsi
  8005f4:	48 bf 10 05 80 00 00 	movabs $0x800510,%rdi
  8005fb:	00 00 00 
  8005fe:	48 b8 e8 09 80 00 00 	movabs $0x8009e8,%rax
  800605:	00 00 00 
  800608:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80060a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800610:	48 98                	cltq   
  800612:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800619:	48 83 c2 08          	add    $0x8,%rdx
  80061d:	48 89 c6             	mov    %rax,%rsi
  800620:	48 89 d7             	mov    %rdx,%rdi
  800623:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  80062a:	00 00 00 
  80062d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80062f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800635:	c9                   	leaveq 
  800636:	c3                   	retq   

0000000000800637 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800637:	55                   	push   %rbp
  800638:	48 89 e5             	mov    %rsp,%rbp
  80063b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800642:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800649:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800650:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800657:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80065e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800665:	84 c0                	test   %al,%al
  800667:	74 20                	je     800689 <cprintf+0x52>
  800669:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80066d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800671:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800675:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800679:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80067d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800681:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800685:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800689:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800690:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800697:	00 00 00 
  80069a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006a1:	00 00 00 
  8006a4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006a8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006af:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006b6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006bd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006c4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006cb:	48 8b 0a             	mov    (%rdx),%rcx
  8006ce:	48 89 08             	mov    %rcx,(%rax)
  8006d1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006dd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006e1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006e8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006ef:	48 89 d6             	mov    %rdx,%rsi
  8006f2:	48 89 c7             	mov    %rax,%rdi
  8006f5:	48 b8 8b 05 80 00 00 	movabs $0x80058b,%rax
  8006fc:	00 00 00 
  8006ff:	ff d0                	callq  *%rax
  800701:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800707:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80070d:	c9                   	leaveq 
  80070e:	c3                   	retq   
	...

0000000000800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %rbp
  800711:	48 89 e5             	mov    %rsp,%rbp
  800714:	48 83 ec 30          	sub    $0x30,%rsp
  800718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80071c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800720:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800724:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800727:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80072b:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80072f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800732:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800736:	77 52                	ja     80078a <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800738:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80073b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80073f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800742:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074a:	ba 00 00 00 00       	mov    $0x0,%edx
  80074f:	48 f7 75 d0          	divq   -0x30(%rbp)
  800753:	48 89 c2             	mov    %rax,%rdx
  800756:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800759:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80075c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800760:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800764:	41 89 f9             	mov    %edi,%r9d
  800767:	48 89 c7             	mov    %rax,%rdi
  80076a:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800771:	00 00 00 
  800774:	ff d0                	callq  *%rax
  800776:	eb 1c                	jmp    800794 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800778:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80077c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80077f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800783:	48 89 d6             	mov    %rdx,%rsi
  800786:	89 c7                	mov    %eax,%edi
  800788:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80078a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80078e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800792:	7f e4                	jg     800778 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800794:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	48 f7 f1             	div    %rcx
  8007a3:	48 89 d0             	mov    %rdx,%rax
  8007a6:	48 ba a8 49 80 00 00 	movabs $0x8049a8,%rdx
  8007ad:	00 00 00 
  8007b0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007b4:	0f be c0             	movsbl %al,%eax
  8007b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007bb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007bf:	48 89 d6             	mov    %rdx,%rsi
  8007c2:	89 c7                	mov    %eax,%edi
  8007c4:	ff d1                	callq  *%rcx
}
  8007c6:	c9                   	leaveq 
  8007c7:	c3                   	retq   

00000000008007c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c8:	55                   	push   %rbp
  8007c9:	48 89 e5             	mov    %rsp,%rbp
  8007cc:	48 83 ec 20          	sub    $0x20,%rsp
  8007d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007db:	7e 52                	jle    80082f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e1:	8b 00                	mov    (%rax),%eax
  8007e3:	83 f8 30             	cmp    $0x30,%eax
  8007e6:	73 24                	jae    80080c <getuint+0x44>
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	8b 00                	mov    (%rax),%eax
  8007f6:	89 c0                	mov    %eax,%eax
  8007f8:	48 01 d0             	add    %rdx,%rax
  8007fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ff:	8b 12                	mov    (%rdx),%edx
  800801:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800804:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800808:	89 0a                	mov    %ecx,(%rdx)
  80080a:	eb 17                	jmp    800823 <getuint+0x5b>
  80080c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800810:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800814:	48 89 d0             	mov    %rdx,%rax
  800817:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80081b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80081f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800823:	48 8b 00             	mov    (%rax),%rax
  800826:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80082a:	e9 a3 00 00 00       	jmpq   8008d2 <getuint+0x10a>
	else if (lflag)
  80082f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800833:	74 4f                	je     800884 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800839:	8b 00                	mov    (%rax),%eax
  80083b:	83 f8 30             	cmp    $0x30,%eax
  80083e:	73 24                	jae    800864 <getuint+0x9c>
  800840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800844:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	8b 00                	mov    (%rax),%eax
  80084e:	89 c0                	mov    %eax,%eax
  800850:	48 01 d0             	add    %rdx,%rax
  800853:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800857:	8b 12                	mov    (%rdx),%edx
  800859:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80085c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800860:	89 0a                	mov    %ecx,(%rdx)
  800862:	eb 17                	jmp    80087b <getuint+0xb3>
  800864:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800868:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80086c:	48 89 d0             	mov    %rdx,%rax
  80086f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80087b:	48 8b 00             	mov    (%rax),%rax
  80087e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800882:	eb 4e                	jmp    8008d2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800884:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800888:	8b 00                	mov    (%rax),%eax
  80088a:	83 f8 30             	cmp    $0x30,%eax
  80088d:	73 24                	jae    8008b3 <getuint+0xeb>
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	8b 00                	mov    (%rax),%eax
  80089d:	89 c0                	mov    %eax,%eax
  80089f:	48 01 d0             	add    %rdx,%rax
  8008a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008a6:	8b 12                	mov    (%rdx),%edx
  8008a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008af:	89 0a                	mov    %ecx,(%rdx)
  8008b1:	eb 17                	jmp    8008ca <getuint+0x102>
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008bb:	48 89 d0             	mov    %rdx,%rax
  8008be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ca:	8b 00                	mov    (%rax),%eax
  8008cc:	89 c0                	mov    %eax,%eax
  8008ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008d6:	c9                   	leaveq 
  8008d7:	c3                   	retq   

00000000008008d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d8:	55                   	push   %rbp
  8008d9:	48 89 e5             	mov    %rsp,%rbp
  8008dc:	48 83 ec 20          	sub    $0x20,%rsp
  8008e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008eb:	7e 52                	jle    80093f <getint+0x67>
		x=va_arg(*ap, long long);
  8008ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f1:	8b 00                	mov    (%rax),%eax
  8008f3:	83 f8 30             	cmp    $0x30,%eax
  8008f6:	73 24                	jae    80091c <getint+0x44>
  8008f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	8b 00                	mov    (%rax),%eax
  800906:	89 c0                	mov    %eax,%eax
  800908:	48 01 d0             	add    %rdx,%rax
  80090b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090f:	8b 12                	mov    (%rdx),%edx
  800911:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800914:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800918:	89 0a                	mov    %ecx,(%rdx)
  80091a:	eb 17                	jmp    800933 <getint+0x5b>
  80091c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800920:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800924:	48 89 d0             	mov    %rdx,%rax
  800927:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80092b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800933:	48 8b 00             	mov    (%rax),%rax
  800936:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093a:	e9 a3 00 00 00       	jmpq   8009e2 <getint+0x10a>
	else if (lflag)
  80093f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800943:	74 4f                	je     800994 <getint+0xbc>
		x=va_arg(*ap, long);
  800945:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800949:	8b 00                	mov    (%rax),%eax
  80094b:	83 f8 30             	cmp    $0x30,%eax
  80094e:	73 24                	jae    800974 <getint+0x9c>
  800950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800954:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	8b 00                	mov    (%rax),%eax
  80095e:	89 c0                	mov    %eax,%eax
  800960:	48 01 d0             	add    %rdx,%rax
  800963:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800967:	8b 12                	mov    (%rdx),%edx
  800969:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800970:	89 0a                	mov    %ecx,(%rdx)
  800972:	eb 17                	jmp    80098b <getint+0xb3>
  800974:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800978:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80097c:	48 89 d0             	mov    %rdx,%rax
  80097f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800983:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800987:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80098b:	48 8b 00             	mov    (%rax),%rax
  80098e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800992:	eb 4e                	jmp    8009e2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800998:	8b 00                	mov    (%rax),%eax
  80099a:	83 f8 30             	cmp    $0x30,%eax
  80099d:	73 24                	jae    8009c3 <getint+0xeb>
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	8b 00                	mov    (%rax),%eax
  8009ad:	89 c0                	mov    %eax,%eax
  8009af:	48 01 d0             	add    %rdx,%rax
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	8b 12                	mov    (%rdx),%edx
  8009b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bf:	89 0a                	mov    %ecx,(%rdx)
  8009c1:	eb 17                	jmp    8009da <getint+0x102>
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009cb:	48 89 d0             	mov    %rdx,%rax
  8009ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009da:	8b 00                	mov    (%rax),%eax
  8009dc:	48 98                	cltq   
  8009de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e6:	c9                   	leaveq 
  8009e7:	c3                   	retq   

00000000008009e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009e8:	55                   	push   %rbp
  8009e9:	48 89 e5             	mov    %rsp,%rbp
  8009ec:	41 54                	push   %r12
  8009ee:	53                   	push   %rbx
  8009ef:	48 83 ec 60          	sub    $0x60,%rsp
  8009f3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009f7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009ff:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a07:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a0b:	48 8b 0a             	mov    (%rdx),%rcx
  800a0e:	48 89 08             	mov    %rcx,(%rax)
  800a11:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a15:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a19:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a1d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a21:	eb 17                	jmp    800a3a <vprintfmt+0x52>
			if (ch == '\0')
  800a23:	85 db                	test   %ebx,%ebx
  800a25:	0f 84 d7 04 00 00    	je     800f02 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800a2b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a2f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a33:	48 89 c6             	mov    %rax,%rsi
  800a36:	89 df                	mov    %ebx,%edi
  800a38:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a3a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a3e:	0f b6 00             	movzbl (%rax),%eax
  800a41:	0f b6 d8             	movzbl %al,%ebx
  800a44:	83 fb 25             	cmp    $0x25,%ebx
  800a47:	0f 95 c0             	setne  %al
  800a4a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a4f:	84 c0                	test   %al,%al
  800a51:	75 d0                	jne    800a23 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a53:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a57:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a5e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a6c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800a73:	eb 04                	jmp    800a79 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a75:	90                   	nop
  800a76:	eb 01                	jmp    800a79 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a78:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a79:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a7d:	0f b6 00             	movzbl (%rax),%eax
  800a80:	0f b6 d8             	movzbl %al,%ebx
  800a83:	89 d8                	mov    %ebx,%eax
  800a85:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a8a:	83 e8 23             	sub    $0x23,%eax
  800a8d:	83 f8 55             	cmp    $0x55,%eax
  800a90:	0f 87 38 04 00 00    	ja     800ece <vprintfmt+0x4e6>
  800a96:	89 c0                	mov    %eax,%eax
  800a98:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a9f:	00 
  800aa0:	48 b8 d0 49 80 00 00 	movabs $0x8049d0,%rax
  800aa7:	00 00 00 
  800aaa:	48 01 d0             	add    %rdx,%rax
  800aad:	48 8b 00             	mov    (%rax),%rax
  800ab0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ab6:	eb c1                	jmp    800a79 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ab8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800abc:	eb bb                	jmp    800a79 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800abe:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ac5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ac8:	89 d0                	mov    %edx,%eax
  800aca:	c1 e0 02             	shl    $0x2,%eax
  800acd:	01 d0                	add    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	01 d8                	add    %ebx,%eax
  800ad3:	83 e8 30             	sub    $0x30,%eax
  800ad6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ad9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800add:	0f b6 00             	movzbl (%rax),%eax
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 63                	jle    800b4b <vprintfmt+0x163>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 5e                	jg     800b4b <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af2:	eb d1                	jmp    800ac5 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800af4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af7:	83 f8 30             	cmp    $0x30,%eax
  800afa:	73 17                	jae    800b13 <vprintfmt+0x12b>
  800afc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b03:	89 c0                	mov    %eax,%eax
  800b05:	48 01 d0             	add    %rdx,%rax
  800b08:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b0b:	83 c2 08             	add    $0x8,%edx
  800b0e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b11:	eb 0f                	jmp    800b22 <vprintfmt+0x13a>
  800b13:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b17:	48 89 d0             	mov    %rdx,%rax
  800b1a:	48 83 c2 08          	add    $0x8,%rdx
  800b1e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b22:	8b 00                	mov    (%rax),%eax
  800b24:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b27:	eb 23                	jmp    800b4c <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b29:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b2d:	0f 89 42 ff ff ff    	jns    800a75 <vprintfmt+0x8d>
				width = 0;
  800b33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b3a:	e9 36 ff ff ff       	jmpq   800a75 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800b3f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b46:	e9 2e ff ff ff       	jmpq   800a79 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b4b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b50:	0f 89 22 ff ff ff    	jns    800a78 <vprintfmt+0x90>
				width = precision, precision = -1;
  800b56:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b59:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b5c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b63:	e9 10 ff ff ff       	jmpq   800a78 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b68:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b6c:	e9 08 ff ff ff       	jmpq   800a79 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b74:	83 f8 30             	cmp    $0x30,%eax
  800b77:	73 17                	jae    800b90 <vprintfmt+0x1a8>
  800b79:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b7d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b80:	89 c0                	mov    %eax,%eax
  800b82:	48 01 d0             	add    %rdx,%rax
  800b85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b88:	83 c2 08             	add    $0x8,%edx
  800b8b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b8e:	eb 0f                	jmp    800b9f <vprintfmt+0x1b7>
  800b90:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b94:	48 89 d0             	mov    %rdx,%rax
  800b97:	48 83 c2 08          	add    $0x8,%rdx
  800b9b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b9f:	8b 00                	mov    (%rax),%eax
  800ba1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba5:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800ba9:	48 89 d6             	mov    %rdx,%rsi
  800bac:	89 c7                	mov    %eax,%edi
  800bae:	ff d1                	callq  *%rcx
			break;
  800bb0:	e9 47 03 00 00       	jmpq   800efc <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bb5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb8:	83 f8 30             	cmp    $0x30,%eax
  800bbb:	73 17                	jae    800bd4 <vprintfmt+0x1ec>
  800bbd:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc4:	89 c0                	mov    %eax,%eax
  800bc6:	48 01 d0             	add    %rdx,%rax
  800bc9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bcc:	83 c2 08             	add    $0x8,%edx
  800bcf:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bd2:	eb 0f                	jmp    800be3 <vprintfmt+0x1fb>
  800bd4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bd8:	48 89 d0             	mov    %rdx,%rax
  800bdb:	48 83 c2 08          	add    $0x8,%rdx
  800bdf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800be3:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800be5:	85 db                	test   %ebx,%ebx
  800be7:	79 02                	jns    800beb <vprintfmt+0x203>
				err = -err;
  800be9:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800beb:	83 fb 10             	cmp    $0x10,%ebx
  800bee:	7f 16                	jg     800c06 <vprintfmt+0x21e>
  800bf0:	48 b8 20 49 80 00 00 	movabs $0x804920,%rax
  800bf7:	00 00 00 
  800bfa:	48 63 d3             	movslq %ebx,%rdx
  800bfd:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c01:	4d 85 e4             	test   %r12,%r12
  800c04:	75 2e                	jne    800c34 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c06:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c0e:	89 d9                	mov    %ebx,%ecx
  800c10:	48 ba b9 49 80 00 00 	movabs $0x8049b9,%rdx
  800c17:	00 00 00 
  800c1a:	48 89 c7             	mov    %rax,%rdi
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	49 b8 0c 0f 80 00 00 	movabs $0x800f0c,%r8
  800c29:	00 00 00 
  800c2c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c2f:	e9 c8 02 00 00       	jmpq   800efc <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c34:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3c:	4c 89 e1             	mov    %r12,%rcx
  800c3f:	48 ba c2 49 80 00 00 	movabs $0x8049c2,%rdx
  800c46:	00 00 00 
  800c49:	48 89 c7             	mov    %rax,%rdi
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c51:	49 b8 0c 0f 80 00 00 	movabs $0x800f0c,%r8
  800c58:	00 00 00 
  800c5b:	41 ff d0             	callq  *%r8
			break;
  800c5e:	e9 99 02 00 00       	jmpq   800efc <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c66:	83 f8 30             	cmp    $0x30,%eax
  800c69:	73 17                	jae    800c82 <vprintfmt+0x29a>
  800c6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c72:	89 c0                	mov    %eax,%eax
  800c74:	48 01 d0             	add    %rdx,%rax
  800c77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c7a:	83 c2 08             	add    $0x8,%edx
  800c7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c80:	eb 0f                	jmp    800c91 <vprintfmt+0x2a9>
  800c82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c86:	48 89 d0             	mov    %rdx,%rax
  800c89:	48 83 c2 08          	add    $0x8,%rdx
  800c8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c91:	4c 8b 20             	mov    (%rax),%r12
  800c94:	4d 85 e4             	test   %r12,%r12
  800c97:	75 0a                	jne    800ca3 <vprintfmt+0x2bb>
				p = "(null)";
  800c99:	49 bc c5 49 80 00 00 	movabs $0x8049c5,%r12
  800ca0:	00 00 00 
			if (width > 0 && padc != '-')
  800ca3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ca7:	7e 7a                	jle    800d23 <vprintfmt+0x33b>
  800ca9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cad:	74 74                	je     800d23 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800caf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cb2:	48 98                	cltq   
  800cb4:	48 89 c6             	mov    %rax,%rsi
  800cb7:	4c 89 e7             	mov    %r12,%rdi
  800cba:	48 b8 b6 11 80 00 00 	movabs $0x8011b6,%rax
  800cc1:	00 00 00 
  800cc4:	ff d0                	callq  *%rax
  800cc6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cc9:	eb 17                	jmp    800ce2 <vprintfmt+0x2fa>
					putch(padc, putdat);
  800ccb:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800ccf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd3:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800cd7:	48 89 d6             	mov    %rdx,%rsi
  800cda:	89 c7                	mov    %eax,%edi
  800cdc:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cde:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ce2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce6:	7f e3                	jg     800ccb <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ce8:	eb 39                	jmp    800d23 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800cea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cee:	74 1e                	je     800d0e <vprintfmt+0x326>
  800cf0:	83 fb 1f             	cmp    $0x1f,%ebx
  800cf3:	7e 05                	jle    800cfa <vprintfmt+0x312>
  800cf5:	83 fb 7e             	cmp    $0x7e,%ebx
  800cf8:	7e 14                	jle    800d0e <vprintfmt+0x326>
					putch('?', putdat);
  800cfa:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800cfe:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d02:	48 89 c6             	mov    %rax,%rsi
  800d05:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d0a:	ff d2                	callq  *%rdx
  800d0c:	eb 0f                	jmp    800d1d <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d0e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d12:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d16:	48 89 c6             	mov    %rax,%rsi
  800d19:	89 df                	mov    %ebx,%edi
  800d1b:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d1d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d21:	eb 01                	jmp    800d24 <vprintfmt+0x33c>
  800d23:	90                   	nop
  800d24:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d29:	0f be d8             	movsbl %al,%ebx
  800d2c:	85 db                	test   %ebx,%ebx
  800d2e:	0f 95 c0             	setne  %al
  800d31:	49 83 c4 01          	add    $0x1,%r12
  800d35:	84 c0                	test   %al,%al
  800d37:	74 28                	je     800d61 <vprintfmt+0x379>
  800d39:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d3d:	78 ab                	js     800cea <vprintfmt+0x302>
  800d3f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d47:	79 a1                	jns    800cea <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d49:	eb 16                	jmp    800d61 <vprintfmt+0x379>
				putch(' ', putdat);
  800d4b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d4f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d53:	48 89 c6             	mov    %rax,%rsi
  800d56:	bf 20 00 00 00       	mov    $0x20,%edi
  800d5b:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d5d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d61:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d65:	7f e4                	jg     800d4b <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800d67:	e9 90 01 00 00       	jmpq   800efc <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d6c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d70:	be 03 00 00 00       	mov    $0x3,%esi
  800d75:	48 89 c7             	mov    %rax,%rdi
  800d78:	48 b8 d8 08 80 00 00 	movabs $0x8008d8,%rax
  800d7f:	00 00 00 
  800d82:	ff d0                	callq  *%rax
  800d84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8c:	48 85 c0             	test   %rax,%rax
  800d8f:	79 1d                	jns    800dae <vprintfmt+0x3c6>
				putch('-', putdat);
  800d91:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d95:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d99:	48 89 c6             	mov    %rax,%rsi
  800d9c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da1:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800da3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da7:	48 f7 d8             	neg    %rax
  800daa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800dae:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800db5:	e9 d5 00 00 00       	jmpq   800e8f <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dba:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dbe:	be 03 00 00 00       	mov    $0x3,%esi
  800dc3:	48 89 c7             	mov    %rax,%rdi
  800dc6:	48 b8 c8 07 80 00 00 	movabs $0x8007c8,%rax
  800dcd:	00 00 00 
  800dd0:	ff d0                	callq  *%rax
  800dd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dd6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ddd:	e9 ad 00 00 00       	jmpq   800e8f <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800de2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800de6:	be 03 00 00 00       	mov    $0x3,%esi
  800deb:	48 89 c7             	mov    %rax,%rdi
  800dee:	48 b8 c8 07 80 00 00 	movabs $0x8007c8,%rax
  800df5:	00 00 00 
  800df8:	ff d0                	callq  *%rax
  800dfa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800dfe:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e05:	e9 85 00 00 00       	jmpq   800e8f <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800e0a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e0e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e12:	48 89 c6             	mov    %rax,%rsi
  800e15:	bf 30 00 00 00       	mov    $0x30,%edi
  800e1a:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e1c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e20:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e24:	48 89 c6             	mov    %rax,%rsi
  800e27:	bf 78 00 00 00       	mov    $0x78,%edi
  800e2c:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e2e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e31:	83 f8 30             	cmp    $0x30,%eax
  800e34:	73 17                	jae    800e4d <vprintfmt+0x465>
  800e36:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e3d:	89 c0                	mov    %eax,%eax
  800e3f:	48 01 d0             	add    %rdx,%rax
  800e42:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e45:	83 c2 08             	add    $0x8,%edx
  800e48:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4b:	eb 0f                	jmp    800e5c <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800e4d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e51:	48 89 d0             	mov    %rdx,%rax
  800e54:	48 83 c2 08          	add    $0x8,%rdx
  800e58:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e5c:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e63:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e6a:	eb 23                	jmp    800e8f <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e6c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e70:	be 03 00 00 00       	mov    $0x3,%esi
  800e75:	48 89 c7             	mov    %rax,%rdi
  800e78:	48 b8 c8 07 80 00 00 	movabs $0x8007c8,%rax
  800e7f:	00 00 00 
  800e82:	ff d0                	callq  *%rax
  800e84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e88:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e8f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e94:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e97:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e9e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ea2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea6:	45 89 c1             	mov    %r8d,%r9d
  800ea9:	41 89 f8             	mov    %edi,%r8d
  800eac:	48 89 c7             	mov    %rax,%rdi
  800eaf:	48 b8 10 07 80 00 00 	movabs $0x800710,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
			break;
  800ebb:	eb 3f                	jmp    800efc <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ebd:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ec1:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ec5:	48 89 c6             	mov    %rax,%rsi
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	ff d2                	callq  *%rdx
			break;
  800ecc:	eb 2e                	jmp    800efc <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ece:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ed2:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ed6:	48 89 c6             	mov    %rax,%rsi
  800ed9:	bf 25 00 00 00       	mov    $0x25,%edi
  800ede:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ee5:	eb 05                	jmp    800eec <vprintfmt+0x504>
  800ee7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef0:	48 83 e8 01          	sub    $0x1,%rax
  800ef4:	0f b6 00             	movzbl (%rax),%eax
  800ef7:	3c 25                	cmp    $0x25,%al
  800ef9:	75 ec                	jne    800ee7 <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800efb:	90                   	nop
		}
	}
  800efc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800efd:	e9 38 fb ff ff       	jmpq   800a3a <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f02:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800f03:	48 83 c4 60          	add    $0x60,%rsp
  800f07:	5b                   	pop    %rbx
  800f08:	41 5c                	pop    %r12
  800f0a:	5d                   	pop    %rbp
  800f0b:	c3                   	retq   

0000000000800f0c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0c:	55                   	push   %rbp
  800f0d:	48 89 e5             	mov    %rsp,%rbp
  800f10:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f17:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f1e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f25:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f2c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f33:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 20                	je     800f5e <printfmt+0x52>
  800f3e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f42:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f46:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f4a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f4e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f52:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f56:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f5a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f5e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f65:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f6c:	00 00 00 
  800f6f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f76:	00 00 00 
  800f79:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f7d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f84:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f8b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f92:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800f99:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fa7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fae:	48 89 c7             	mov    %rax,%rdi
  800fb1:	48 b8 e8 09 80 00 00 	movabs $0x8009e8,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fbd:	c9                   	leaveq 
  800fbe:	c3                   	retq   

0000000000800fbf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fbf:	55                   	push   %rbp
  800fc0:	48 89 e5             	mov    %rsp,%rbp
  800fc3:	48 83 ec 10          	sub    $0x10,%rsp
  800fc7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd2:	8b 40 10             	mov    0x10(%rax),%eax
  800fd5:	8d 50 01             	lea    0x1(%rax),%edx
  800fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fdc:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe3:	48 8b 10             	mov    (%rax),%rdx
  800fe6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fea:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fee:	48 39 c2             	cmp    %rax,%rdx
  800ff1:	73 17                	jae    80100a <sprintputch+0x4b>
		*b->buf++ = ch;
  800ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff7:	48 8b 00             	mov    (%rax),%rax
  800ffa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ffd:	88 10                	mov    %dl,(%rax)
  800fff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	48 89 10             	mov    %rdx,(%rax)
}
  80100a:	c9                   	leaveq 
  80100b:	c3                   	retq   

000000000080100c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100c:	55                   	push   %rbp
  80100d:	48 89 e5             	mov    %rsp,%rbp
  801010:	48 83 ec 50          	sub    $0x50,%rsp
  801014:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801018:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80101b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80101f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801023:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801027:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80102b:	48 8b 0a             	mov    (%rdx),%rcx
  80102e:	48 89 08             	mov    %rcx,(%rax)
  801031:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801035:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801039:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80103d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801041:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801045:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801049:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80104c:	48 98                	cltq   
  80104e:	48 83 e8 01          	sub    $0x1,%rax
  801052:	48 03 45 c8          	add    -0x38(%rbp),%rax
  801056:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80105a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801061:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801066:	74 06                	je     80106e <vsnprintf+0x62>
  801068:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80106c:	7f 07                	jg     801075 <vsnprintf+0x69>
		return -E_INVAL;
  80106e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801073:	eb 2f                	jmp    8010a4 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801075:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801079:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80107d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801081:	48 89 c6             	mov    %rax,%rsi
  801084:	48 bf bf 0f 80 00 00 	movabs $0x800fbf,%rdi
  80108b:	00 00 00 
  80108e:	48 b8 e8 09 80 00 00 	movabs $0x8009e8,%rax
  801095:	00 00 00 
  801098:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80109a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80109e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010a4:	c9                   	leaveq 
  8010a5:	c3                   	retq   

00000000008010a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010b8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010be:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010c5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010cc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 20                	je     8010f7 <snprintf+0x51>
  8010d7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010db:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010df:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010e7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010eb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010ef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010f7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8010fe:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801105:	00 00 00 
  801108:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80110f:	00 00 00 
  801112:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801116:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80111d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801124:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80112b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801132:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801139:	48 8b 0a             	mov    (%rdx),%rcx
  80113c:	48 89 08             	mov    %rcx,(%rax)
  80113f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801143:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801147:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80114b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80114f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801156:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80115d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801163:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80116a:	48 89 c7             	mov    %rax,%rdi
  80116d:	48 b8 0c 10 80 00 00 	movabs $0x80100c,%rax
  801174:	00 00 00 
  801177:	ff d0                	callq  *%rax
  801179:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80117f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801185:	c9                   	leaveq 
  801186:	c3                   	retq   
	...

0000000000801188 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801188:	55                   	push   %rbp
  801189:	48 89 e5             	mov    %rsp,%rbp
  80118c:	48 83 ec 18          	sub    $0x18,%rsp
  801190:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801194:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80119b:	eb 09                	jmp    8011a6 <strlen+0x1e>
		n++;
  80119d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011aa:	0f b6 00             	movzbl (%rax),%eax
  8011ad:	84 c0                	test   %al,%al
  8011af:	75 ec                	jne    80119d <strlen+0x15>
		n++;
	return n;
  8011b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011b4:	c9                   	leaveq 
  8011b5:	c3                   	retq   

00000000008011b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011b6:	55                   	push   %rbp
  8011b7:	48 89 e5             	mov    %rsp,%rbp
  8011ba:	48 83 ec 20          	sub    $0x20,%rsp
  8011be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011cd:	eb 0e                	jmp    8011dd <strnlen+0x27>
		n++;
  8011cf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011d3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011d8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011dd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011e2:	74 0b                	je     8011ef <strnlen+0x39>
  8011e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e8:	0f b6 00             	movzbl (%rax),%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	75 e0                	jne    8011cf <strnlen+0x19>
		n++;
	return n;
  8011ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011f2:	c9                   	leaveq 
  8011f3:	c3                   	retq   

00000000008011f4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011f4:	55                   	push   %rbp
  8011f5:	48 89 e5             	mov    %rsp,%rbp
  8011f8:	48 83 ec 20          	sub    $0x20,%rsp
  8011fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801200:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801208:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80120c:	90                   	nop
  80120d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801211:	0f b6 10             	movzbl (%rax),%edx
  801214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801218:	88 10                	mov    %dl,(%rax)
  80121a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121e:	0f b6 00             	movzbl (%rax),%eax
  801221:	84 c0                	test   %al,%al
  801223:	0f 95 c0             	setne  %al
  801226:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80122b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801230:	84 c0                	test   %al,%al
  801232:	75 d9                	jne    80120d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801234:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801238:	c9                   	leaveq 
  801239:	c3                   	retq   

000000000080123a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80123a:	55                   	push   %rbp
  80123b:	48 89 e5             	mov    %rsp,%rbp
  80123e:	48 83 ec 20          	sub    $0x20,%rsp
  801242:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801246:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	48 89 c7             	mov    %rax,%rdi
  801251:	48 b8 88 11 80 00 00 	movabs $0x801188,%rax
  801258:	00 00 00 
  80125b:	ff d0                	callq  *%rax
  80125d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801263:	48 98                	cltq   
  801265:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801269:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80126d:	48 89 d6             	mov    %rdx,%rsi
  801270:	48 89 c7             	mov    %rax,%rdi
  801273:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  80127a:	00 00 00 
  80127d:	ff d0                	callq  *%rax
	return dst;
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801283:	c9                   	leaveq 
  801284:	c3                   	retq   

0000000000801285 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801285:	55                   	push   %rbp
  801286:	48 89 e5             	mov    %rsp,%rbp
  801289:	48 83 ec 28          	sub    $0x28,%rsp
  80128d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801295:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801299:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012a8:	00 
  8012a9:	eb 27                	jmp    8012d2 <strncpy+0x4d>
		*dst++ = *src;
  8012ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012af:	0f b6 10             	movzbl (%rax),%edx
  8012b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b6:	88 10                	mov    %dl,(%rax)
  8012b8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c1:	0f b6 00             	movzbl (%rax),%eax
  8012c4:	84 c0                	test   %al,%al
  8012c6:	74 05                	je     8012cd <strncpy+0x48>
			src++;
  8012c8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012da:	72 cf                	jb     8012ab <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e0:	c9                   	leaveq 
  8012e1:	c3                   	retq   

00000000008012e2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012e2:	55                   	push   %rbp
  8012e3:	48 89 e5             	mov    %rsp,%rbp
  8012e6:	48 83 ec 28          	sub    $0x28,%rsp
  8012ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012f2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8012fe:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801303:	74 37                	je     80133c <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801305:	eb 17                	jmp    80131e <strlcpy+0x3c>
			*dst++ = *src++;
  801307:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80130b:	0f b6 10             	movzbl (%rax),%edx
  80130e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801312:	88 10                	mov    %dl,(%rax)
  801314:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801319:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80131e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801323:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801328:	74 0b                	je     801335 <strlcpy+0x53>
  80132a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 d2                	jne    801307 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801339:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80133c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	48 89 d1             	mov    %rdx,%rcx
  801347:	48 29 c1             	sub    %rax,%rcx
  80134a:	48 89 c8             	mov    %rcx,%rax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 10          	sub    $0x10,%rsp
  801357:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80135b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80135f:	eb 0a                	jmp    80136b <strcmp+0x1c>
		p++, q++;
  801361:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801366:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80136b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	84 c0                	test   %al,%al
  801374:	74 12                	je     801388 <strcmp+0x39>
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	0f b6 10             	movzbl (%rax),%edx
  80137d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801381:	0f b6 00             	movzbl (%rax),%eax
  801384:	38 c2                	cmp    %al,%dl
  801386:	74 d9                	je     801361 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801388:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138c:	0f b6 00             	movzbl (%rax),%eax
  80138f:	0f b6 d0             	movzbl %al,%edx
  801392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801396:	0f b6 00             	movzbl (%rax),%eax
  801399:	0f b6 c0             	movzbl %al,%eax
  80139c:	89 d1                	mov    %edx,%ecx
  80139e:	29 c1                	sub    %eax,%ecx
  8013a0:	89 c8                	mov    %ecx,%eax
}
  8013a2:	c9                   	leaveq 
  8013a3:	c3                   	retq   

00000000008013a4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013a4:	55                   	push   %rbp
  8013a5:	48 89 e5             	mov    %rsp,%rbp
  8013a8:	48 83 ec 18          	sub    $0x18,%rsp
  8013ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013b4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013b8:	eb 0f                	jmp    8013c9 <strncmp+0x25>
		n--, p++, q++;
  8013ba:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013bf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013c4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ce:	74 1d                	je     8013ed <strncmp+0x49>
  8013d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d4:	0f b6 00             	movzbl (%rax),%eax
  8013d7:	84 c0                	test   %al,%al
  8013d9:	74 12                	je     8013ed <strncmp+0x49>
  8013db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013df:	0f b6 10             	movzbl (%rax),%edx
  8013e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e6:	0f b6 00             	movzbl (%rax),%eax
  8013e9:	38 c2                	cmp    %al,%dl
  8013eb:	74 cd                	je     8013ba <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013f2:	75 07                	jne    8013fb <strncmp+0x57>
		return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f9:	eb 1a                	jmp    801415 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	0f b6 d0             	movzbl %al,%edx
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	0f b6 c0             	movzbl %al,%eax
  80140f:	89 d1                	mov    %edx,%ecx
  801411:	29 c1                	sub    %eax,%ecx
  801413:	89 c8                	mov    %ecx,%eax
}
  801415:	c9                   	leaveq 
  801416:	c3                   	retq   

0000000000801417 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801417:	55                   	push   %rbp
  801418:	48 89 e5             	mov    %rsp,%rbp
  80141b:	48 83 ec 10          	sub    $0x10,%rsp
  80141f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801423:	89 f0                	mov    %esi,%eax
  801425:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801428:	eb 17                	jmp    801441 <strchr+0x2a>
		if (*s == c)
  80142a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801434:	75 06                	jne    80143c <strchr+0x25>
			return (char *) s;
  801436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80143a:	eb 15                	jmp    801451 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801441:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801445:	0f b6 00             	movzbl (%rax),%eax
  801448:	84 c0                	test   %al,%al
  80144a:	75 de                	jne    80142a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801451:	c9                   	leaveq 
  801452:	c3                   	retq   

0000000000801453 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801453:	55                   	push   %rbp
  801454:	48 89 e5             	mov    %rsp,%rbp
  801457:	48 83 ec 10          	sub    $0x10,%rsp
  80145b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80145f:	89 f0                	mov    %esi,%eax
  801461:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801464:	eb 11                	jmp    801477 <strfind+0x24>
		if (*s == c)
  801466:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146a:	0f b6 00             	movzbl (%rax),%eax
  80146d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801470:	74 12                	je     801484 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801472:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801477:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147b:	0f b6 00             	movzbl (%rax),%eax
  80147e:	84 c0                	test   %al,%al
  801480:	75 e4                	jne    801466 <strfind+0x13>
  801482:	eb 01                	jmp    801485 <strfind+0x32>
		if (*s == c)
			break;
  801484:	90                   	nop
	return (char *) s;
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801489:	c9                   	leaveq 
  80148a:	c3                   	retq   

000000000080148b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80148b:	55                   	push   %rbp
  80148c:	48 89 e5             	mov    %rsp,%rbp
  80148f:	48 83 ec 18          	sub    $0x18,%rsp
  801493:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801497:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80149a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80149e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014a3:	75 06                	jne    8014ab <memset+0x20>
		return v;
  8014a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a9:	eb 69                	jmp    801514 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014af:	83 e0 03             	and    $0x3,%eax
  8014b2:	48 85 c0             	test   %rax,%rax
  8014b5:	75 48                	jne    8014ff <memset+0x74>
  8014b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bb:	83 e0 03             	and    $0x3,%eax
  8014be:	48 85 c0             	test   %rax,%rax
  8014c1:	75 3c                	jne    8014ff <memset+0x74>
		c &= 0xFF;
  8014c3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014cd:	89 c2                	mov    %eax,%edx
  8014cf:	c1 e2 18             	shl    $0x18,%edx
  8014d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d5:	c1 e0 10             	shl    $0x10,%eax
  8014d8:	09 c2                	or     %eax,%edx
  8014da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dd:	c1 e0 08             	shl    $0x8,%eax
  8014e0:	09 d0                	or     %edx,%eax
  8014e2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014e9:	48 89 c1             	mov    %rax,%rcx
  8014ec:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f7:	48 89 d7             	mov    %rdx,%rdi
  8014fa:	fc                   	cld    
  8014fb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8014fd:	eb 11                	jmp    801510 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801503:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801506:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80150a:	48 89 d7             	mov    %rdx,%rdi
  80150d:	fc                   	cld    
  80150e:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801514:	c9                   	leaveq 
  801515:	c3                   	retq   

0000000000801516 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801516:	55                   	push   %rbp
  801517:	48 89 e5             	mov    %rsp,%rbp
  80151a:	48 83 ec 28          	sub    $0x28,%rsp
  80151e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801522:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801526:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80152a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80152e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801542:	0f 83 88 00 00 00    	jae    8015d0 <memmove+0xba>
  801548:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801550:	48 01 d0             	add    %rdx,%rax
  801553:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801557:	76 77                	jbe    8015d0 <memmove+0xba>
		s += n;
  801559:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	83 e0 03             	and    $0x3,%eax
  801570:	48 85 c0             	test   %rax,%rax
  801573:	75 3b                	jne    8015b0 <memmove+0x9a>
  801575:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801579:	83 e0 03             	and    $0x3,%eax
  80157c:	48 85 c0             	test   %rax,%rax
  80157f:	75 2f                	jne    8015b0 <memmove+0x9a>
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	83 e0 03             	and    $0x3,%eax
  801588:	48 85 c0             	test   %rax,%rax
  80158b:	75 23                	jne    8015b0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80158d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801591:	48 83 e8 04          	sub    $0x4,%rax
  801595:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801599:	48 83 ea 04          	sub    $0x4,%rdx
  80159d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 89 d6             	mov    %rdx,%rsi
  8015ab:	fd                   	std    
  8015ac:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015ae:	eb 1d                	jmp    8015cd <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c4:	48 89 d7             	mov    %rdx,%rdi
  8015c7:	48 89 c1             	mov    %rax,%rcx
  8015ca:	fd                   	std    
  8015cb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015cd:	fc                   	cld    
  8015ce:	eb 57                	jmp    801627 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	83 e0 03             	and    $0x3,%eax
  8015d7:	48 85 c0             	test   %rax,%rax
  8015da:	75 36                	jne    801612 <memmove+0xfc>
  8015dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e0:	83 e0 03             	and    $0x3,%eax
  8015e3:	48 85 c0             	test   %rax,%rax
  8015e6:	75 2a                	jne    801612 <memmove+0xfc>
  8015e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ec:	83 e0 03             	and    $0x3,%eax
  8015ef:	48 85 c0             	test   %rax,%rax
  8015f2:	75 1e                	jne    801612 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f8:	48 89 c1             	mov    %rax,%rcx
  8015fb:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8015ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801603:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801607:	48 89 c7             	mov    %rax,%rdi
  80160a:	48 89 d6             	mov    %rdx,%rsi
  80160d:	fc                   	cld    
  80160e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801610:	eb 15                	jmp    801627 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801612:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801616:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80161e:	48 89 c7             	mov    %rax,%rdi
  801621:	48 89 d6             	mov    %rdx,%rsi
  801624:	fc                   	cld    
  801625:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80162b:	c9                   	leaveq 
  80162c:	c3                   	retq   

000000000080162d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	48 83 ec 18          	sub    $0x18,%rsp
  801635:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801639:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80163d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801641:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801645:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164d:	48 89 ce             	mov    %rcx,%rsi
  801650:	48 89 c7             	mov    %rax,%rdi
  801653:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  80165a:	00 00 00 
  80165d:	ff d0                	callq  *%rax
}
  80165f:	c9                   	leaveq 
  801660:	c3                   	retq   

0000000000801661 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801661:	55                   	push   %rbp
  801662:	48 89 e5             	mov    %rsp,%rbp
  801665:	48 83 ec 28          	sub    $0x28,%rsp
  801669:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80166d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801671:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80167d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801681:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801685:	eb 38                	jmp    8016bf <memcmp+0x5e>
		if (*s1 != *s2)
  801687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168b:	0f b6 10             	movzbl (%rax),%edx
  80168e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801692:	0f b6 00             	movzbl (%rax),%eax
  801695:	38 c2                	cmp    %al,%dl
  801697:	74 1c                	je     8016b5 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	0f b6 d0             	movzbl %al,%edx
  8016a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	0f b6 c0             	movzbl %al,%eax
  8016ad:	89 d1                	mov    %edx,%ecx
  8016af:	29 c1                	sub    %eax,%ecx
  8016b1:	89 c8                	mov    %ecx,%eax
  8016b3:	eb 20                	jmp    8016d5 <memcmp+0x74>
		s1++, s2++;
  8016b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016bf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016c4:	0f 95 c0             	setne  %al
  8016c7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016cc:	84 c0                	test   %al,%al
  8016ce:	75 b7                	jne    801687 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d5:	c9                   	leaveq 
  8016d6:	c3                   	retq   

00000000008016d7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016d7:	55                   	push   %rbp
  8016d8:	48 89 e5             	mov    %rsp,%rbp
  8016db:	48 83 ec 28          	sub    $0x28,%rsp
  8016df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016e3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016f2:	48 01 d0             	add    %rdx,%rax
  8016f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8016f9:	eb 13                	jmp    80170e <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ff:	0f b6 10             	movzbl (%rax),%edx
  801702:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801705:	38 c2                	cmp    %al,%dl
  801707:	74 11                	je     80171a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801709:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80170e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801712:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801716:	72 e3                	jb     8016fb <memfind+0x24>
  801718:	eb 01                	jmp    80171b <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80171a:	90                   	nop
	return (void *) s;
  80171b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80171f:	c9                   	leaveq 
  801720:	c3                   	retq   

0000000000801721 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801721:	55                   	push   %rbp
  801722:	48 89 e5             	mov    %rsp,%rbp
  801725:	48 83 ec 38          	sub    $0x38,%rsp
  801729:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80172d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801731:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80173b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801742:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801743:	eb 05                	jmp    80174a <strtol+0x29>
		s++;
  801745:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174e:	0f b6 00             	movzbl (%rax),%eax
  801751:	3c 20                	cmp    $0x20,%al
  801753:	74 f0                	je     801745 <strtol+0x24>
  801755:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801759:	0f b6 00             	movzbl (%rax),%eax
  80175c:	3c 09                	cmp    $0x9,%al
  80175e:	74 e5                	je     801745 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801760:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801764:	0f b6 00             	movzbl (%rax),%eax
  801767:	3c 2b                	cmp    $0x2b,%al
  801769:	75 07                	jne    801772 <strtol+0x51>
		s++;
  80176b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801770:	eb 17                	jmp    801789 <strtol+0x68>
	else if (*s == '-')
  801772:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801776:	0f b6 00             	movzbl (%rax),%eax
  801779:	3c 2d                	cmp    $0x2d,%al
  80177b:	75 0c                	jne    801789 <strtol+0x68>
		s++, neg = 1;
  80177d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801782:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801789:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80178d:	74 06                	je     801795 <strtol+0x74>
  80178f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801793:	75 28                	jne    8017bd <strtol+0x9c>
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	0f b6 00             	movzbl (%rax),%eax
  80179c:	3c 30                	cmp    $0x30,%al
  80179e:	75 1d                	jne    8017bd <strtol+0x9c>
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	48 83 c0 01          	add    $0x1,%rax
  8017a8:	0f b6 00             	movzbl (%rax),%eax
  8017ab:	3c 78                	cmp    $0x78,%al
  8017ad:	75 0e                	jne    8017bd <strtol+0x9c>
		s += 2, base = 16;
  8017af:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017b4:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017bb:	eb 2c                	jmp    8017e9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c1:	75 19                	jne    8017dc <strtol+0xbb>
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	0f b6 00             	movzbl (%rax),%eax
  8017ca:	3c 30                	cmp    $0x30,%al
  8017cc:	75 0e                	jne    8017dc <strtol+0xbb>
		s++, base = 8;
  8017ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017d3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017da:	eb 0d                	jmp    8017e9 <strtol+0xc8>
	else if (base == 0)
  8017dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e0:	75 07                	jne    8017e9 <strtol+0xc8>
		base = 10;
  8017e2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ed:	0f b6 00             	movzbl (%rax),%eax
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 1d                	jle    801811 <strtol+0xf0>
  8017f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f8:	0f b6 00             	movzbl (%rax),%eax
  8017fb:	3c 39                	cmp    $0x39,%al
  8017fd:	7f 12                	jg     801811 <strtol+0xf0>
			dig = *s - '0';
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	0f b6 00             	movzbl (%rax),%eax
  801806:	0f be c0             	movsbl %al,%eax
  801809:	83 e8 30             	sub    $0x30,%eax
  80180c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80180f:	eb 4e                	jmp    80185f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801811:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801815:	0f b6 00             	movzbl (%rax),%eax
  801818:	3c 60                	cmp    $0x60,%al
  80181a:	7e 1d                	jle    801839 <strtol+0x118>
  80181c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801820:	0f b6 00             	movzbl (%rax),%eax
  801823:	3c 7a                	cmp    $0x7a,%al
  801825:	7f 12                	jg     801839 <strtol+0x118>
			dig = *s - 'a' + 10;
  801827:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182b:	0f b6 00             	movzbl (%rax),%eax
  80182e:	0f be c0             	movsbl %al,%eax
  801831:	83 e8 57             	sub    $0x57,%eax
  801834:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801837:	eb 26                	jmp    80185f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	0f b6 00             	movzbl (%rax),%eax
  801840:	3c 40                	cmp    $0x40,%al
  801842:	7e 47                	jle    80188b <strtol+0x16a>
  801844:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801848:	0f b6 00             	movzbl (%rax),%eax
  80184b:	3c 5a                	cmp    $0x5a,%al
  80184d:	7f 3c                	jg     80188b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80184f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801853:	0f b6 00             	movzbl (%rax),%eax
  801856:	0f be c0             	movsbl %al,%eax
  801859:	83 e8 37             	sub    $0x37,%eax
  80185c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80185f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801862:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801865:	7d 23                	jge    80188a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801867:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80186c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80186f:	48 98                	cltq   
  801871:	48 89 c2             	mov    %rax,%rdx
  801874:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801879:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80187c:	48 98                	cltq   
  80187e:	48 01 d0             	add    %rdx,%rax
  801881:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801885:	e9 5f ff ff ff       	jmpq   8017e9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80188a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80188b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801890:	74 0b                	je     80189d <strtol+0x17c>
		*endptr = (char *) s;
  801892:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801896:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80189a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80189d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a1:	74 09                	je     8018ac <strtol+0x18b>
  8018a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a7:	48 f7 d8             	neg    %rax
  8018aa:	eb 04                	jmp    8018b0 <strtol+0x18f>
  8018ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <strstr>:

char * strstr(const char *in, const char *str)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 30          	sub    $0x30,%rsp
  8018ba:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018be:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018c6:	0f b6 00             	movzbl (%rax),%eax
  8018c9:	88 45 ff             	mov    %al,-0x1(%rbp)
  8018cc:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8018d1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018d5:	75 06                	jne    8018dd <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8018d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018db:	eb 68                	jmp    801945 <strstr+0x93>

    len = strlen(str);
  8018dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e1:	48 89 c7             	mov    %rax,%rdi
  8018e4:	48 b8 88 11 80 00 00 	movabs $0x801188,%rax
  8018eb:	00 00 00 
  8018ee:	ff d0                	callq  *%rax
  8018f0:	48 98                	cltq   
  8018f2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	0f b6 00             	movzbl (%rax),%eax
  8018fd:	88 45 ef             	mov    %al,-0x11(%rbp)
  801900:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801905:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801909:	75 07                	jne    801912 <strstr+0x60>
                return (char *) 0;
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
  801910:	eb 33                	jmp    801945 <strstr+0x93>
        } while (sc != c);
  801912:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801916:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801919:	75 db                	jne    8018f6 <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  80191b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	48 89 ce             	mov    %rcx,%rsi
  80192a:	48 89 c7             	mov    %rax,%rdi
  80192d:	48 b8 a4 13 80 00 00 	movabs $0x8013a4,%rax
  801934:	00 00 00 
  801937:	ff d0                	callq  *%rax
  801939:	85 c0                	test   %eax,%eax
  80193b:	75 b9                	jne    8018f6 <strstr+0x44>

    return (char *) (in - 1);
  80193d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801941:	48 83 e8 01          	sub    $0x1,%rax
}
  801945:	c9                   	leaveq 
  801946:	c3                   	retq   
	...

0000000000801948 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801948:	55                   	push   %rbp
  801949:	48 89 e5             	mov    %rsp,%rbp
  80194c:	53                   	push   %rbx
  80194d:	48 83 ec 58          	sub    $0x58,%rsp
  801951:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801954:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801957:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80195b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80195f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801963:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801967:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80196a:	89 45 ac             	mov    %eax,-0x54(%rbp)
  80196d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801971:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801975:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801979:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80197d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801981:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801984:	4c 89 c3             	mov    %r8,%rbx
  801987:	cd 30                	int    $0x30
  801989:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  80198d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801991:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801995:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801999:	74 3e                	je     8019d9 <syscall+0x91>
  80199b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a0:	7e 37                	jle    8019d9 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019a6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019a9:	49 89 d0             	mov    %rdx,%r8
  8019ac:	89 c1                	mov    %eax,%ecx
  8019ae:	48 ba 80 4c 80 00 00 	movabs $0x804c80,%rdx
  8019b5:	00 00 00 
  8019b8:	be 23 00 00 00       	mov    $0x23,%esi
  8019bd:	48 bf 9d 4c 80 00 00 	movabs $0x804c9d,%rdi
  8019c4:	00 00 00 
  8019c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cc:	49 b9 fc 03 80 00 00 	movabs $0x8003fc,%r9
  8019d3:	00 00 00 
  8019d6:	41 ff d1             	callq  *%r9

	return ret;
  8019d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019dd:	48 83 c4 58          	add    $0x58,%rsp
  8019e1:	5b                   	pop    %rbx
  8019e2:	5d                   	pop    %rbp
  8019e3:	c3                   	retq   

00000000008019e4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019e4:	55                   	push   %rbp
  8019e5:	48 89 e5             	mov    %rsp,%rbp
  8019e8:	48 83 ec 20          	sub    $0x20,%rsp
  8019ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019fc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a03:	00 
  801a04:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a0a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a10:	48 89 d1             	mov    %rdx,%rcx
  801a13:	48 89 c2             	mov    %rax,%rdx
  801a16:	be 00 00 00 00       	mov    $0x0,%esi
  801a1b:	bf 00 00 00 00       	mov    $0x0,%edi
  801a20:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <sys_cgetc>:

int
sys_cgetc(void)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a36:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3d:	00 
  801a3e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a44:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a54:	be 00 00 00 00       	mov    $0x0,%esi
  801a59:	bf 01 00 00 00       	mov    $0x1,%edi
  801a5e:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
}
  801a6a:	c9                   	leaveq 
  801a6b:	c3                   	retq   

0000000000801a6c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a6c:	55                   	push   %rbp
  801a6d:	48 89 e5             	mov    %rsp,%rbp
  801a70:	48 83 ec 20          	sub    $0x20,%rsp
  801a74:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7a:	48 98                	cltq   
  801a7c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a83:	00 
  801a84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a90:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a95:	48 89 c2             	mov    %rax,%rdx
  801a98:	be 01 00 00 00       	mov    $0x1,%esi
  801a9d:	bf 03 00 00 00       	mov    $0x3,%edi
  801aa2:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
}
  801aae:	c9                   	leaveq 
  801aaf:	c3                   	retq   

0000000000801ab0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ab8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abf:	00 
  801ac0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ac6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801acc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad6:	be 00 00 00 00       	mov    $0x0,%esi
  801adb:	bf 02 00 00 00       	mov    $0x2,%edi
  801ae0:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801ae7:	00 00 00 
  801aea:	ff d0                	callq  *%rax
}
  801aec:	c9                   	leaveq 
  801aed:	c3                   	retq   

0000000000801aee <sys_yield>:

void
sys_yield(void)
{
  801aee:	55                   	push   %rbp
  801aef:	48 89 e5             	mov    %rsp,%rbp
  801af2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801af6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801afd:	00 
  801afe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b04:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b14:	be 00 00 00 00       	mov    $0x0,%esi
  801b19:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b1e:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
}
  801b2a:	c9                   	leaveq 
  801b2b:	c3                   	retq   

0000000000801b2c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b2c:	55                   	push   %rbp
  801b2d:	48 89 e5             	mov    %rsp,%rbp
  801b30:	48 83 ec 20          	sub    $0x20,%rsp
  801b34:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b37:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b3b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b41:	48 63 c8             	movslq %eax,%rcx
  801b44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4b:	48 98                	cltq   
  801b4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b54:	00 
  801b55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b5b:	49 89 c8             	mov    %rcx,%r8
  801b5e:	48 89 d1             	mov    %rdx,%rcx
  801b61:	48 89 c2             	mov    %rax,%rdx
  801b64:	be 01 00 00 00       	mov    $0x1,%esi
  801b69:	bf 04 00 00 00       	mov    $0x4,%edi
  801b6e:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801b75:	00 00 00 
  801b78:	ff d0                	callq  *%rax
}
  801b7a:	c9                   	leaveq 
  801b7b:	c3                   	retq   

0000000000801b7c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b7c:	55                   	push   %rbp
  801b7d:	48 89 e5             	mov    %rsp,%rbp
  801b80:	48 83 ec 30          	sub    $0x30,%rsp
  801b84:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b87:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b8b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b8e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b92:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b96:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b99:	48 63 c8             	movslq %eax,%rcx
  801b9c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ba0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ba3:	48 63 f0             	movslq %eax,%rsi
  801ba6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bad:	48 98                	cltq   
  801baf:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bb3:	49 89 f9             	mov    %rdi,%r9
  801bb6:	49 89 f0             	mov    %rsi,%r8
  801bb9:	48 89 d1             	mov    %rdx,%rcx
  801bbc:	48 89 c2             	mov    %rax,%rdx
  801bbf:	be 01 00 00 00       	mov    $0x1,%esi
  801bc4:	bf 05 00 00 00       	mov    $0x5,%edi
  801bc9:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801bd0:	00 00 00 
  801bd3:	ff d0                	callq  *%rax
}
  801bd5:	c9                   	leaveq 
  801bd6:	c3                   	retq   

0000000000801bd7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bd7:	55                   	push   %rbp
  801bd8:	48 89 e5             	mov    %rsp,%rbp
  801bdb:	48 83 ec 20          	sub    $0x20,%rsp
  801bdf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801be2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bed:	48 98                	cltq   
  801bef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bf6:	00 
  801bf7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c03:	48 89 d1             	mov    %rdx,%rcx
  801c06:	48 89 c2             	mov    %rax,%rdx
  801c09:	be 01 00 00 00       	mov    $0x1,%esi
  801c0e:	bf 06 00 00 00       	mov    $0x6,%edi
  801c13:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801c1a:	00 00 00 
  801c1d:	ff d0                	callq  *%rax
}
  801c1f:	c9                   	leaveq 
  801c20:	c3                   	retq   

0000000000801c21 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c21:	55                   	push   %rbp
  801c22:	48 89 e5             	mov    %rsp,%rbp
  801c25:	48 83 ec 20          	sub    $0x20,%rsp
  801c29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c2c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c32:	48 63 d0             	movslq %eax,%rdx
  801c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c38:	48 98                	cltq   
  801c3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c41:	00 
  801c42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c4e:	48 89 d1             	mov    %rdx,%rcx
  801c51:	48 89 c2             	mov    %rax,%rdx
  801c54:	be 01 00 00 00       	mov    $0x1,%esi
  801c59:	bf 08 00 00 00       	mov    $0x8,%edi
  801c5e:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801c65:	00 00 00 
  801c68:	ff d0                	callq  *%rax
}
  801c6a:	c9                   	leaveq 
  801c6b:	c3                   	retq   

0000000000801c6c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c6c:	55                   	push   %rbp
  801c6d:	48 89 e5             	mov    %rsp,%rbp
  801c70:	48 83 ec 20          	sub    $0x20,%rsp
  801c74:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c77:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c7b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c82:	48 98                	cltq   
  801c84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c8b:	00 
  801c8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c98:	48 89 d1             	mov    %rdx,%rcx
  801c9b:	48 89 c2             	mov    %rax,%rdx
  801c9e:	be 01 00 00 00       	mov    $0x1,%esi
  801ca3:	bf 09 00 00 00       	mov    $0x9,%edi
  801ca8:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801caf:	00 00 00 
  801cb2:	ff d0                	callq  *%rax
}
  801cb4:	c9                   	leaveq 
  801cb5:	c3                   	retq   

0000000000801cb6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cb6:	55                   	push   %rbp
  801cb7:	48 89 e5             	mov    %rsp,%rbp
  801cba:	48 83 ec 20          	sub    $0x20,%rsp
  801cbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccc:	48 98                	cltq   
  801cce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd5:	00 
  801cd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce2:	48 89 d1             	mov    %rdx,%rcx
  801ce5:	48 89 c2             	mov    %rax,%rdx
  801ce8:	be 01 00 00 00       	mov    $0x1,%esi
  801ced:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cf2:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801cf9:	00 00 00 
  801cfc:	ff d0                	callq  *%rax
}
  801cfe:	c9                   	leaveq 
  801cff:	c3                   	retq   

0000000000801d00 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	48 83 ec 30          	sub    $0x30,%rsp
  801d08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d13:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d19:	48 63 f0             	movslq %eax,%rsi
  801d1c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d23:	48 98                	cltq   
  801d25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d29:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d30:	00 
  801d31:	49 89 f1             	mov    %rsi,%r9
  801d34:	49 89 c8             	mov    %rcx,%r8
  801d37:	48 89 d1             	mov    %rdx,%rcx
  801d3a:	48 89 c2             	mov    %rax,%rdx
  801d3d:	be 00 00 00 00       	mov    $0x0,%esi
  801d42:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d47:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801d4e:	00 00 00 
  801d51:	ff d0                	callq  *%rax
}
  801d53:	c9                   	leaveq 
  801d54:	c3                   	retq   

0000000000801d55 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d55:	55                   	push   %rbp
  801d56:	48 89 e5             	mov    %rsp,%rbp
  801d59:	48 83 ec 20          	sub    $0x20,%rsp
  801d5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d65:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6c:	00 
  801d6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d79:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d7e:	48 89 c2             	mov    %rax,%rdx
  801d81:	be 01 00 00 00       	mov    $0x1,%esi
  801d86:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d8b:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801d92:	00 00 00 
  801d95:	ff d0                	callq  *%rax
}
  801d97:	c9                   	leaveq 
  801d98:	c3                   	retq   

0000000000801d99 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801d99:	55                   	push   %rbp
  801d9a:	48 89 e5             	mov    %rsp,%rbp
  801d9d:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801da1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801da8:	00 
  801da9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801daf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801db5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dba:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbf:	be 00 00 00 00       	mov    $0x0,%esi
  801dc4:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dc9:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
}
  801dd5:	c9                   	leaveq 
  801dd6:	c3                   	retq   

0000000000801dd7 <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801dd7:	55                   	push   %rbp
  801dd8:	48 89 e5             	mov    %rsp,%rbp
  801ddb:	48 83 ec 20          	sub    $0x20,%rsp
  801ddf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801de3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801de7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801deb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801def:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df6:	00 
  801df7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dfd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e03:	48 89 d1             	mov    %rdx,%rcx
  801e06:	48 89 c2             	mov    %rax,%rdx
  801e09:	be 00 00 00 00       	mov    $0x0,%esi
  801e0e:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e13:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801e1a:	00 00 00 
  801e1d:	ff d0                	callq  *%rax
}
  801e1f:	c9                   	leaveq 
  801e20:	c3                   	retq   

0000000000801e21 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801e21:	55                   	push   %rbp
  801e22:	48 89 e5             	mov    %rsp,%rbp
  801e25:	48 83 ec 20          	sub    $0x20,%rsp
  801e29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e2d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e39:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e40:	00 
  801e41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e4d:	48 89 d1             	mov    %rdx,%rcx
  801e50:	48 89 c2             	mov    %rax,%rdx
  801e53:	be 00 00 00 00       	mov    $0x0,%esi
  801e58:	bf 10 00 00 00       	mov    $0x10,%edi
  801e5d:	48 b8 48 19 80 00 00 	movabs $0x801948,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	callq  *%rax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   
	...

0000000000801e6c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e6c:	55                   	push   %rbp
  801e6d:	48 89 e5             	mov    %rsp,%rbp
  801e70:	48 83 ec 30          	sub    $0x30,%rsp
  801e74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e7c:	48 8b 00             	mov    (%rax),%rax
  801e7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e87:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e8b:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801e8e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e91:	83 e0 02             	and    $0x2,%eax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	74 23                	je     801ebb <pgfault+0x4f>
  801e98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9c:	48 89 c2             	mov    %rax,%rdx
  801e9f:	48 c1 ea 0c          	shr    $0xc,%rdx
  801ea3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eaa:	01 00 00 
  801ead:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb1:	25 00 08 00 00       	and    $0x800,%eax
  801eb6:	48 85 c0             	test   %rax,%rax
  801eb9:	75 2a                	jne    801ee5 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801ebb:	48 ba b0 4c 80 00 00 	movabs $0x804cb0,%rdx
  801ec2:	00 00 00 
  801ec5:	be 1c 00 00 00       	mov    $0x1c,%esi
  801eca:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  801ed1:	00 00 00 
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  801ee0:	00 00 00 
  801ee3:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801ee5:	ba 07 00 00 00       	mov    $0x7,%edx
  801eea:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801eef:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef4:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  801efb:	00 00 00 
  801efe:	ff d0                	callq  *%rax
  801f00:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f07:	79 30                	jns    801f39 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801f09:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f0c:	89 c1                	mov    %eax,%ecx
  801f0e:	48 ba f0 4c 80 00 00 	movabs $0x804cf0,%rdx
  801f15:	00 00 00 
  801f18:	be 26 00 00 00       	mov    $0x26,%esi
  801f1d:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  801f24:	00 00 00 
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  801f33:	00 00 00 
  801f36:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801f39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f45:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f4b:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f50:	48 89 c6             	mov    %rax,%rsi
  801f53:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f58:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  801f5f:	00 00 00 
  801f62:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801f64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f68:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f70:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f76:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f7c:	48 89 c1             	mov    %rax,%rcx
  801f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f84:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f89:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8e:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  801f95:	00 00 00 
  801f98:	ff d0                	callq  *%rax
  801f9a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fa1:	79 30                	jns    801fd3 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801fa3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801fa6:	89 c1                	mov    %eax,%ecx
  801fa8:	48 ba 18 4d 80 00 00 	movabs $0x804d18,%rdx
  801faf:	00 00 00 
  801fb2:	be 2b 00 00 00       	mov    $0x2b,%esi
  801fb7:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  801fbe:	00 00 00 
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  801fcd:	00 00 00 
  801fd0:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801fd3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fd8:	bf 00 00 00 00       	mov    $0x0,%edi
  801fdd:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fec:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ff0:	79 30                	jns    802022 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801ff2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ff5:	89 c1                	mov    %eax,%ecx
  801ff7:	48 ba 40 4d 80 00 00 	movabs $0x804d40,%rdx
  801ffe:	00 00 00 
  802001:	be 2e 00 00 00       	mov    $0x2e,%esi
  802006:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  80200d:	00 00 00 
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  80201c:	00 00 00 
  80201f:	41 ff d0             	callq  *%r8
	
}
  802022:	c9                   	leaveq 
  802023:	c3                   	retq   

0000000000802024 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802024:	55                   	push   %rbp
  802025:	48 89 e5             	mov    %rsp,%rbp
  802028:	48 83 ec 30          	sub    $0x30,%rsp
  80202c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80202f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802032:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802039:	01 00 00 
  80203c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80203f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802043:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  802047:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204b:	25 07 0e 00 00       	and    $0xe07,%eax
  802050:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  802053:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802056:	48 c1 e0 0c          	shl    $0xc,%rax
  80205a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  80205e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802061:	25 00 04 00 00       	and    $0x400,%eax
  802066:	85 c0                	test   %eax,%eax
  802068:	74 5c                	je     8020c6 <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  80206a:	8b 75 f4             	mov    -0xc(%rbp),%esi
  80206d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802071:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802078:	41 89 f0             	mov    %esi,%r8d
  80207b:	48 89 c6             	mov    %rax,%rsi
  80207e:	bf 00 00 00 00       	mov    $0x0,%edi
  802083:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  802092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802096:	0f 89 60 01 00 00    	jns    8021fc <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  80209c:	48 ba 68 4d 80 00 00 	movabs $0x804d68,%rdx
  8020a3:	00 00 00 
  8020a6:	be 4d 00 00 00       	mov    $0x4d,%esi
  8020ab:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  8020b2:	00 00 00 
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  8020c1:	00 00 00 
  8020c4:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8020c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020c9:	83 e0 02             	and    $0x2,%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	75 10                	jne    8020e0 <duppage+0xbc>
  8020d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d3:	25 00 08 00 00       	and    $0x800,%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	0f 84 c4 00 00 00    	je     8021a4 <duppage+0x180>
	{
		perm |= PTE_COW;
  8020e0:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8020e7:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8020eb:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8020ee:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f9:	41 89 f0             	mov    %esi,%r8d
  8020fc:	48 89 c6             	mov    %rax,%rsi
  8020ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802104:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  80210b:	00 00 00 
  80210e:	ff d0                	callq  *%rax
  802110:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  802113:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802117:	79 2a                	jns    802143 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802119:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  802120:	00 00 00 
  802123:	be 56 00 00 00       	mov    $0x56,%esi
  802128:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  80212f:	00 00 00 
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  80213e:	00 00 00 
  802141:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  802143:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802146:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80214a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214e:	41 89 c8             	mov    %ecx,%r8d
  802151:	48 89 d1             	mov    %rdx,%rcx
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
  802159:	48 89 c6             	mov    %rax,%rsi
  80215c:	bf 00 00 00 00       	mov    $0x0,%edi
  802161:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  802168:	00 00 00 
  80216b:	ff d0                	callq  *%rax
  80216d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802170:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802174:	0f 89 82 00 00 00    	jns    8021fc <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  80217a:	48 ba 98 4d 80 00 00 	movabs $0x804d98,%rdx
  802181:	00 00 00 
  802184:	be 59 00 00 00       	mov    $0x59,%esi
  802189:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  802190:	00 00 00 
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  80219f:	00 00 00 
  8021a2:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  8021a4:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8021a7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b2:	41 89 f0             	mov    %esi,%r8d
  8021b5:	48 89 c6             	mov    %rax,%rsi
  8021b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021bd:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8021cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021d0:	79 2a                	jns    8021fc <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8021d2:	48 ba d0 4d 80 00 00 	movabs $0x804dd0,%rdx
  8021d9:	00 00 00 
  8021dc:	be 60 00 00 00       	mov    $0x60,%esi
  8021e1:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  8021e8:	00 00 00 
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  8021f7:	00 00 00 
  8021fa:	ff d1                	callq  *%rcx
	}
	return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
  802207:	53                   	push   %rbx
  802208:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80220c:	48 bf 6c 1e 80 00 00 	movabs $0x801e6c,%rdi
  802213:	00 00 00 
  802216:	48 b8 c0 42 80 00 00 	movabs $0x8042c0,%rax
  80221d:	00 00 00 
  802220:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802222:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802229:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80222c:	cd 30                	int    $0x30
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802233:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  802236:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802239:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80223d:	79 30                	jns    80226f <fork+0x6c>
                panic("sys_exofork: %e", envid);
  80223f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802242:	89 c1                	mov    %eax,%ecx
  802244:	48 ba f4 4d 80 00 00 	movabs $0x804df4,%rdx
  80224b:	00 00 00 
  80224e:	be 7f 00 00 00       	mov    $0x7f,%esi
  802253:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  80225a:	00 00 00 
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
  802262:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  802269:	00 00 00 
  80226c:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  80226f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802273:	75 4c                	jne    8022c1 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802275:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	48 98                	cltq   
  802283:	48 89 c2             	mov    %rax,%rdx
  802286:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80228c:	48 89 d0             	mov    %rdx,%rax
  80228f:	48 c1 e0 03          	shl    $0x3,%rax
  802293:	48 01 d0             	add    %rdx,%rax
  802296:	48 c1 e0 05          	shl    $0x5,%rax
  80229a:	48 89 c2             	mov    %rax,%rdx
  80229d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022a4:	00 00 00 
  8022a7:	48 01 c2             	add    %rax,%rdx
  8022aa:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8022b1:	00 00 00 
  8022b4:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bc:	e9 38 02 00 00       	jmpq   8024f9 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8022c1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022c4:	ba 07 00 00 00       	mov    $0x7,%edx
  8022c9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022ce:	89 c7                	mov    %eax,%edi
  8022d0:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8022d7:	00 00 00 
  8022da:	ff d0                	callq  *%rax
  8022dc:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8022df:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8022e3:	79 30                	jns    802315 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8022e5:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8022e8:	89 c1                	mov    %eax,%ecx
  8022ea:	48 ba 08 4e 80 00 00 	movabs $0x804e08,%rdx
  8022f1:	00 00 00 
  8022f4:	be 8b 00 00 00       	mov    $0x8b,%esi
  8022f9:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  802300:	00 00 00 
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  80230f:	00 00 00 
  802312:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802315:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  80231c:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802323:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80232a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802331:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802338:	e9 0a 01 00 00       	jmpq   802447 <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  80233d:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802344:	01 00 00 
  802347:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80234a:	48 63 d2             	movslq %edx,%rdx
  80234d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802351:	83 e0 01             	and    $0x1,%eax
  802354:	84 c0                	test   %al,%al
  802356:	0f 84 e7 00 00 00    	je     802443 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  80235c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802363:	e9 cf 00 00 00       	jmpq   802437 <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  802368:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80236f:	01 00 00 
  802372:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802375:	48 63 d2             	movslq %edx,%rdx
  802378:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80237c:	83 e0 01             	and    $0x1,%eax
  80237f:	84 c0                	test   %al,%al
  802381:	0f 84 a0 00 00 00    	je     802427 <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802387:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  80238e:	e9 85 00 00 00       	jmpq   802418 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802393:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80239a:	01 00 00 
  80239d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023a0:	48 63 d2             	movslq %edx,%rdx
  8023a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a7:	83 e0 01             	and    $0x1,%eax
  8023aa:	84 c0                	test   %al,%al
  8023ac:	74 56                	je     802404 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8023ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8023b5:	eb 42                	jmp    8023f9 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8023b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023be:	01 00 00 
  8023c1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023c4:	48 63 d2             	movslq %edx,%rdx
  8023c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cb:	83 e0 01             	and    $0x1,%eax
  8023ce:	84 c0                	test   %al,%al
  8023d0:	74 1f                	je     8023f1 <fork+0x1ee>
  8023d2:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8023d9:	74 16                	je     8023f1 <fork+0x1ee>
									 duppage(envid,d1);
  8023db:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023de:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8023e1:	89 d6                	mov    %edx,%esi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 24 20 80 00 00 	movabs $0x802024,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8023f1:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8023f5:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8023f9:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802400:	7e b5                	jle    8023b7 <fork+0x1b4>
  802402:	eb 0c                	jmp    802410 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802404:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802407:	83 c0 01             	add    $0x1,%eax
  80240a:	c1 e0 09             	shl    $0x9,%eax
  80240d:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802410:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802414:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802418:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  80241f:	0f 8e 6e ff ff ff    	jle    802393 <fork+0x190>
  802425:	eb 0c                	jmp    802433 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  802427:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80242a:	83 c0 01             	add    $0x1,%eax
  80242d:	c1 e0 09             	shl    $0x9,%eax
  802430:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802433:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  802437:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80243a:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  80243d:	0f 8c 25 ff ff ff    	jl     802368 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802443:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802447:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80244a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80244d:	0f 8c ea fe ff ff    	jl     80233d <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802453:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802456:	48 be 84 43 80 00 00 	movabs $0x804384,%rsi
  80245d:	00 00 00 
  802460:	89 c7                	mov    %eax,%edi
  802462:	48 b8 b6 1c 80 00 00 	movabs $0x801cb6,%rax
  802469:	00 00 00 
  80246c:	ff d0                	callq  *%rax
  80246e:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802471:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802475:	79 30                	jns    8024a7 <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  802477:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80247a:	89 c1                	mov    %eax,%ecx
  80247c:	48 ba 28 4e 80 00 00 	movabs $0x804e28,%rdx
  802483:	00 00 00 
  802486:	be ad 00 00 00       	mov    $0xad,%esi
  80248b:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  802492:	00 00 00 
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  8024a1:	00 00 00 
  8024a4:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8024a7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8024aa:	be 02 00 00 00       	mov    $0x2,%esi
  8024af:	89 c7                	mov    %eax,%edi
  8024b1:	48 b8 21 1c 80 00 00 	movabs $0x801c21,%rax
  8024b8:	00 00 00 
  8024bb:	ff d0                	callq  *%rax
  8024bd:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8024c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8024c4:	79 30                	jns    8024f6 <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8024c6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8024c9:	89 c1                	mov    %eax,%ecx
  8024cb:	48 ba 58 4e 80 00 00 	movabs $0x804e58,%rdx
  8024d2:	00 00 00 
  8024d5:	be b0 00 00 00       	mov    $0xb0,%esi
  8024da:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  8024e1:	00 00 00 
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  8024f0:	00 00 00 
  8024f3:	41 ff d0             	callq  *%r8
	return envid;
  8024f6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8024f9:	48 83 c4 48          	add    $0x48,%rsp
  8024fd:	5b                   	pop    %rbx
  8024fe:	5d                   	pop    %rbp
  8024ff:	c3                   	retq   

0000000000802500 <sfork>:

// Challenge!
int
sfork(void)
{
  802500:	55                   	push   %rbp
  802501:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802504:	48 ba 7c 4e 80 00 00 	movabs $0x804e7c,%rdx
  80250b:	00 00 00 
  80250e:	be b8 00 00 00       	mov    $0xb8,%esi
  802513:	48 bf e5 4c 80 00 00 	movabs $0x804ce5,%rdi
  80251a:	00 00 00 
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
  802522:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  802529:	00 00 00 
  80252c:	ff d1                	callq  *%rcx
	...

0000000000802530 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802530:	55                   	push   %rbp
  802531:	48 89 e5             	mov    %rsp,%rbp
  802534:	48 83 ec 08          	sub    $0x8,%rsp
  802538:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80253c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802540:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802547:	ff ff ff 
  80254a:	48 01 d0             	add    %rdx,%rax
  80254d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802551:	c9                   	leaveq 
  802552:	c3                   	retq   

0000000000802553 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802553:	55                   	push   %rbp
  802554:	48 89 e5             	mov    %rsp,%rbp
  802557:	48 83 ec 08          	sub    $0x8,%rsp
  80255b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80255f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802563:	48 89 c7             	mov    %rax,%rdi
  802566:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  80256d:	00 00 00 
  802570:	ff d0                	callq  *%rax
  802572:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802578:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80257c:	c9                   	leaveq 
  80257d:	c3                   	retq   

000000000080257e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80257e:	55                   	push   %rbp
  80257f:	48 89 e5             	mov    %rsp,%rbp
  802582:	48 83 ec 18          	sub    $0x18,%rsp
  802586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80258a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802591:	eb 6b                	jmp    8025fe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802596:	48 98                	cltq   
  802598:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80259e:	48 c1 e0 0c          	shl    $0xc,%rax
  8025a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025aa:	48 89 c2             	mov    %rax,%rdx
  8025ad:	48 c1 ea 15          	shr    $0x15,%rdx
  8025b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025b8:	01 00 00 
  8025bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025bf:	83 e0 01             	and    $0x1,%eax
  8025c2:	48 85 c0             	test   %rax,%rax
  8025c5:	74 21                	je     8025e8 <fd_alloc+0x6a>
  8025c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025cb:	48 89 c2             	mov    %rax,%rdx
  8025ce:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d9:	01 00 00 
  8025dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e0:	83 e0 01             	and    $0x1,%eax
  8025e3:	48 85 c0             	test   %rax,%rax
  8025e6:	75 12                	jne    8025fa <fd_alloc+0x7c>
			*fd_store = fd;
  8025e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	eb 1a                	jmp    802614 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8025fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8025fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802602:	7e 8f                	jle    802593 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802608:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80260f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802614:	c9                   	leaveq 
  802615:	c3                   	retq   

0000000000802616 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802616:	55                   	push   %rbp
  802617:	48 89 e5             	mov    %rsp,%rbp
  80261a:	48 83 ec 20          	sub    $0x20,%rsp
  80261e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802621:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802625:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802629:	78 06                	js     802631 <fd_lookup+0x1b>
  80262b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80262f:	7e 07                	jle    802638 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802631:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802636:	eb 6c                	jmp    8026a4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802638:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80263b:	48 98                	cltq   
  80263d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802643:	48 c1 e0 0c          	shl    $0xc,%rax
  802647:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80264b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80264f:	48 89 c2             	mov    %rax,%rdx
  802652:	48 c1 ea 15          	shr    $0x15,%rdx
  802656:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265d:	01 00 00 
  802660:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802664:	83 e0 01             	and    $0x1,%eax
  802667:	48 85 c0             	test   %rax,%rax
  80266a:	74 21                	je     80268d <fd_lookup+0x77>
  80266c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802670:	48 89 c2             	mov    %rax,%rdx
  802673:	48 c1 ea 0c          	shr    $0xc,%rdx
  802677:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267e:	01 00 00 
  802681:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802685:	83 e0 01             	and    $0x1,%eax
  802688:	48 85 c0             	test   %rax,%rax
  80268b:	75 07                	jne    802694 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80268d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802692:	eb 10                	jmp    8026a4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802694:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802698:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80269c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a4:	c9                   	leaveq 
  8026a5:	c3                   	retq   

00000000008026a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026a6:	55                   	push   %rbp
  8026a7:	48 89 e5             	mov    %rsp,%rbp
  8026aa:	48 83 ec 30          	sub    $0x30,%rsp
  8026ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026b2:	89 f0                	mov    %esi,%eax
  8026b4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026bb:	48 89 c7             	mov    %rax,%rdi
  8026be:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  8026c5:	00 00 00 
  8026c8:	ff d0                	callq  *%rax
  8026ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ce:	48 89 d6             	mov    %rdx,%rsi
  8026d1:	89 c7                	mov    %eax,%edi
  8026d3:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	callq  *%rax
  8026df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026e6:	78 0a                	js     8026f2 <fd_close+0x4c>
	    || fd != fd2)
  8026e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026f0:	74 12                	je     802704 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026f2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026f6:	74 05                	je     8026fd <fd_close+0x57>
  8026f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fb:	eb 05                	jmp    802702 <fd_close+0x5c>
  8026fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802702:	eb 69                	jmp    80276d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802708:	8b 00                	mov    (%rax),%eax
  80270a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80270e:	48 89 d6             	mov    %rdx,%rsi
  802711:	89 c7                	mov    %eax,%edi
  802713:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  80271a:	00 00 00 
  80271d:	ff d0                	callq  *%rax
  80271f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802726:	78 2a                	js     802752 <fd_close+0xac>
		if (dev->dev_close)
  802728:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80272c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802730:	48 85 c0             	test   %rax,%rax
  802733:	74 16                	je     80274b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802739:	48 8b 50 20          	mov    0x20(%rax),%rdx
  80273d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802741:	48 89 c7             	mov    %rax,%rdi
  802744:	ff d2                	callq  *%rdx
  802746:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802749:	eb 07                	jmp    802752 <fd_close+0xac>
		else
			r = 0;
  80274b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802756:	48 89 c6             	mov    %rax,%rsi
  802759:	bf 00 00 00 00       	mov    $0x0,%edi
  80275e:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  802765:	00 00 00 
  802768:	ff d0                	callq  *%rax
	return r;
  80276a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80276d:	c9                   	leaveq 
  80276e:	c3                   	retq   

000000000080276f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80276f:	55                   	push   %rbp
  802770:	48 89 e5             	mov    %rsp,%rbp
  802773:	48 83 ec 20          	sub    $0x20,%rsp
  802777:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80277a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80277e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802785:	eb 41                	jmp    8027c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802787:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80278e:	00 00 00 
  802791:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802794:	48 63 d2             	movslq %edx,%rdx
  802797:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279b:	8b 00                	mov    (%rax),%eax
  80279d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027a0:	75 22                	jne    8027c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8027a2:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027a9:	00 00 00 
  8027ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027af:	48 63 d2             	movslq %edx,%rdx
  8027b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	eb 60                	jmp    802824 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027c8:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8027cf:	00 00 00 
  8027d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027d5:	48 63 d2             	movslq %edx,%rdx
  8027d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027dc:	48 85 c0             	test   %rax,%rax
  8027df:	75 a6                	jne    802787 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027e1:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8027e8:	00 00 00 
  8027eb:	48 8b 00             	mov    (%rax),%rax
  8027ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027f7:	89 c6                	mov    %eax,%esi
  8027f9:	48 bf 98 4e 80 00 00 	movabs $0x804e98,%rdi
  802800:	00 00 00 
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	48 b9 37 06 80 00 00 	movabs $0x800637,%rcx
  80280f:	00 00 00 
  802812:	ff d1                	callq  *%rcx
	*dev = 0;
  802814:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802818:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80281f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802824:	c9                   	leaveq 
  802825:	c3                   	retq   

0000000000802826 <close>:

int
close(int fdnum)
{
  802826:	55                   	push   %rbp
  802827:	48 89 e5             	mov    %rsp,%rbp
  80282a:	48 83 ec 20          	sub    $0x20,%rsp
  80282e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802831:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802835:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802838:	48 89 d6             	mov    %rdx,%rsi
  80283b:	89 c7                	mov    %eax,%edi
  80283d:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802844:	00 00 00 
  802847:	ff d0                	callq  *%rax
  802849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802850:	79 05                	jns    802857 <close+0x31>
		return r;
  802852:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802855:	eb 18                	jmp    80286f <close+0x49>
	else
		return fd_close(fd, 1);
  802857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285b:	be 01 00 00 00       	mov    $0x1,%esi
  802860:	48 89 c7             	mov    %rax,%rdi
  802863:	48 b8 a6 26 80 00 00 	movabs $0x8026a6,%rax
  80286a:	00 00 00 
  80286d:	ff d0                	callq  *%rax
}
  80286f:	c9                   	leaveq 
  802870:	c3                   	retq   

0000000000802871 <close_all>:

void
close_all(void)
{
  802871:	55                   	push   %rbp
  802872:	48 89 e5             	mov    %rsp,%rbp
  802875:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802879:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802880:	eb 15                	jmp    802897 <close_all+0x26>
		close(i);
  802882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802885:	89 c7                	mov    %eax,%edi
  802887:	48 b8 26 28 80 00 00 	movabs $0x802826,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802893:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802897:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80289b:	7e e5                	jle    802882 <close_all+0x11>
		close(i);
}
  80289d:	c9                   	leaveq 
  80289e:	c3                   	retq   

000000000080289f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80289f:	55                   	push   %rbp
  8028a0:	48 89 e5             	mov    %rsp,%rbp
  8028a3:	48 83 ec 40          	sub    $0x40,%rsp
  8028a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028b4:	48 89 d6             	mov    %rdx,%rsi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cc:	79 08                	jns    8028d6 <dup+0x37>
		return r;
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d1:	e9 70 01 00 00       	jmpq   802a46 <dup+0x1a7>
	close(newfdnum);
  8028d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028d9:	89 c7                	mov    %eax,%edi
  8028db:	48 b8 26 28 80 00 00 	movabs $0x802826,%rax
  8028e2:	00 00 00 
  8028e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028ea:	48 98                	cltq   
  8028ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8028f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8028fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028fe:	48 89 c7             	mov    %rax,%rdi
  802901:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  802908:	00 00 00 
  80290b:	ff d0                	callq  *%rax
  80290d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802915:	48 89 c7             	mov    %rax,%rdi
  802918:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80292c:	48 89 c2             	mov    %rax,%rdx
  80292f:	48 c1 ea 15          	shr    $0x15,%rdx
  802933:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80293a:	01 00 00 
  80293d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802941:	83 e0 01             	and    $0x1,%eax
  802944:	84 c0                	test   %al,%al
  802946:	74 71                	je     8029b9 <dup+0x11a>
  802948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294c:	48 89 c2             	mov    %rax,%rdx
  80294f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802953:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80295a:	01 00 00 
  80295d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802961:	83 e0 01             	and    $0x1,%eax
  802964:	84 c0                	test   %al,%al
  802966:	74 51                	je     8029b9 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802968:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80296c:	48 89 c2             	mov    %rax,%rdx
  80296f:	48 c1 ea 0c          	shr    $0xc,%rdx
  802973:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80297a:	01 00 00 
  80297d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802981:	89 c1                	mov    %eax,%ecx
  802983:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802989:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80298d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802991:	41 89 c8             	mov    %ecx,%r8d
  802994:	48 89 d1             	mov    %rdx,%rcx
  802997:	ba 00 00 00 00       	mov    $0x0,%edx
  80299c:	48 89 c6             	mov    %rax,%rsi
  80299f:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a4:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8029ab:	00 00 00 
  8029ae:	ff d0                	callq  *%rax
  8029b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b7:	78 56                	js     802a0f <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029bd:	48 89 c2             	mov    %rax,%rdx
  8029c0:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029cb:	01 00 00 
  8029ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029d2:	89 c1                	mov    %eax,%ecx
  8029d4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8029da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029de:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029e2:	41 89 c8             	mov    %ecx,%r8d
  8029e5:	48 89 d1             	mov    %rdx,%rcx
  8029e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ed:	48 89 c6             	mov    %rax,%rsi
  8029f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f5:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8029fc:	00 00 00 
  8029ff:	ff d0                	callq  *%rax
  802a01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a08:	78 08                	js     802a12 <dup+0x173>
		goto err;

	return newfdnum;
  802a0a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a0d:	eb 37                	jmp    802a46 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802a0f:	90                   	nop
  802a10:	eb 01                	jmp    802a13 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802a12:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802a13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a17:	48 89 c6             	mov    %rax,%rsi
  802a1a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1f:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  802a26:	00 00 00 
  802a29:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a2f:	48 89 c6             	mov    %rax,%rsi
  802a32:	bf 00 00 00 00       	mov    $0x0,%edi
  802a37:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  802a3e:	00 00 00 
  802a41:	ff d0                	callq  *%rax
	return r;
  802a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a46:	c9                   	leaveq 
  802a47:	c3                   	retq   

0000000000802a48 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a48:	55                   	push   %rbp
  802a49:	48 89 e5             	mov    %rsp,%rbp
  802a4c:	48 83 ec 40          	sub    $0x40,%rsp
  802a50:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a53:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a57:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a5b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a5f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a62:	48 89 d6             	mov    %rdx,%rsi
  802a65:	89 c7                	mov    %eax,%edi
  802a67:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802a6e:	00 00 00 
  802a71:	ff d0                	callq  *%rax
  802a73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a7a:	78 24                	js     802aa0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a80:	8b 00                	mov    (%rax),%eax
  802a82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a86:	48 89 d6             	mov    %rdx,%rsi
  802a89:	89 c7                	mov    %eax,%edi
  802a8b:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
  802a97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a9e:	79 05                	jns    802aa5 <read+0x5d>
		return r;
  802aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa3:	eb 7a                	jmp    802b1f <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aa9:	8b 40 08             	mov    0x8(%rax),%eax
  802aac:	83 e0 03             	and    $0x3,%eax
  802aaf:	83 f8 01             	cmp    $0x1,%eax
  802ab2:	75 3a                	jne    802aee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802ab4:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802abb:	00 00 00 
  802abe:	48 8b 00             	mov    (%rax),%rax
  802ac1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ac7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802aca:	89 c6                	mov    %eax,%esi
  802acc:	48 bf b7 4e 80 00 00 	movabs $0x804eb7,%rdi
  802ad3:	00 00 00 
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	48 b9 37 06 80 00 00 	movabs $0x800637,%rcx
  802ae2:	00 00 00 
  802ae5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ae7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aec:	eb 31                	jmp    802b1f <read+0xd7>
	}
	if (!dev->dev_read)
  802aee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802af2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802af6:	48 85 c0             	test   %rax,%rax
  802af9:	75 07                	jne    802b02 <read+0xba>
		return -E_NOT_SUPP;
  802afb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b00:	eb 1d                	jmp    802b1f <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802b02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b06:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b12:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b16:	48 89 ce             	mov    %rcx,%rsi
  802b19:	48 89 c7             	mov    %rax,%rdi
  802b1c:	41 ff d0             	callq  *%r8
}
  802b1f:	c9                   	leaveq 
  802b20:	c3                   	retq   

0000000000802b21 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b21:	55                   	push   %rbp
  802b22:	48 89 e5             	mov    %rsp,%rbp
  802b25:	48 83 ec 30          	sub    $0x30,%rsp
  802b29:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b30:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b3b:	eb 46                	jmp    802b83 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b40:	48 98                	cltq   
  802b42:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b46:	48 29 c2             	sub    %rax,%rdx
  802b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4c:	48 98                	cltq   
  802b4e:	48 89 c1             	mov    %rax,%rcx
  802b51:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802b55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b58:	48 89 ce             	mov    %rcx,%rsi
  802b5b:	89 c7                	mov    %eax,%edi
  802b5d:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  802b64:	00 00 00 
  802b67:	ff d0                	callq  *%rax
  802b69:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b6c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b70:	79 05                	jns    802b77 <readn+0x56>
			return m;
  802b72:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b75:	eb 1d                	jmp    802b94 <readn+0x73>
		if (m == 0)
  802b77:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b7b:	74 13                	je     802b90 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b80:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b86:	48 98                	cltq   
  802b88:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b8c:	72 af                	jb     802b3d <readn+0x1c>
  802b8e:	eb 01                	jmp    802b91 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b90:	90                   	nop
	}
	return tot;
  802b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b94:	c9                   	leaveq 
  802b95:	c3                   	retq   

0000000000802b96 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b96:	55                   	push   %rbp
  802b97:	48 89 e5             	mov    %rsp,%rbp
  802b9a:	48 83 ec 40          	sub    $0x40,%rsp
  802b9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ba5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ba9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bad:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bb0:	48 89 d6             	mov    %rdx,%rsi
  802bb3:	89 c7                	mov    %eax,%edi
  802bb5:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802bbc:	00 00 00 
  802bbf:	ff d0                	callq  *%rax
  802bc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc8:	78 24                	js     802bee <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bce:	8b 00                	mov    (%rax),%eax
  802bd0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd4:	48 89 d6             	mov    %rdx,%rsi
  802bd7:	89 c7                	mov    %eax,%edi
  802bd9:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802be0:	00 00 00 
  802be3:	ff d0                	callq  *%rax
  802be5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bec:	79 05                	jns    802bf3 <write+0x5d>
		return r;
  802bee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf1:	eb 79                	jmp    802c6c <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf7:	8b 40 08             	mov    0x8(%rax),%eax
  802bfa:	83 e0 03             	and    $0x3,%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	75 3a                	jne    802c3b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c01:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802c08:	00 00 00 
  802c0b:	48 8b 00             	mov    (%rax),%rax
  802c0e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c14:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c17:	89 c6                	mov    %eax,%esi
  802c19:	48 bf d3 4e 80 00 00 	movabs $0x804ed3,%rdi
  802c20:	00 00 00 
  802c23:	b8 00 00 00 00       	mov    $0x0,%eax
  802c28:	48 b9 37 06 80 00 00 	movabs $0x800637,%rcx
  802c2f:	00 00 00 
  802c32:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c39:	eb 31                	jmp    802c6c <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c43:	48 85 c0             	test   %rax,%rax
  802c46:	75 07                	jne    802c4f <write+0xb9>
		return -E_NOT_SUPP;
  802c48:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c4d:	eb 1d                	jmp    802c6c <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802c4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c53:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802c57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c63:	48 89 ce             	mov    %rcx,%rsi
  802c66:	48 89 c7             	mov    %rax,%rdi
  802c69:	41 ff d0             	callq  *%r8
}
  802c6c:	c9                   	leaveq 
  802c6d:	c3                   	retq   

0000000000802c6e <seek>:

int
seek(int fdnum, off_t offset)
{
  802c6e:	55                   	push   %rbp
  802c6f:	48 89 e5             	mov    %rsp,%rbp
  802c72:	48 83 ec 18          	sub    $0x18,%rsp
  802c76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c79:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c7c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c80:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c83:	48 89 d6             	mov    %rdx,%rsi
  802c86:	89 c7                	mov    %eax,%edi
  802c88:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802c8f:	00 00 00 
  802c92:	ff d0                	callq  *%rax
  802c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c9b:	79 05                	jns    802ca2 <seek+0x34>
		return r;
  802c9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca0:	eb 0f                	jmp    802cb1 <seek+0x43>
	fd->fd_offset = offset;
  802ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb1:	c9                   	leaveq 
  802cb2:	c3                   	retq   

0000000000802cb3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802cb3:	55                   	push   %rbp
  802cb4:	48 89 e5             	mov    %rsp,%rbp
  802cb7:	48 83 ec 30          	sub    $0x30,%rsp
  802cbb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cbe:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cc5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cc8:	48 89 d6             	mov    %rdx,%rsi
  802ccb:	89 c7                	mov    %eax,%edi
  802ccd:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802cd4:	00 00 00 
  802cd7:	ff d0                	callq  *%rax
  802cd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cdc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce0:	78 24                	js     802d06 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ce2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce6:	8b 00                	mov    (%rax),%eax
  802ce8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cec:	48 89 d6             	mov    %rdx,%rsi
  802cef:	89 c7                	mov    %eax,%edi
  802cf1:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802cf8:	00 00 00 
  802cfb:	ff d0                	callq  *%rax
  802cfd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d04:	79 05                	jns    802d0b <ftruncate+0x58>
		return r;
  802d06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d09:	eb 72                	jmp    802d7d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0f:	8b 40 08             	mov    0x8(%rax),%eax
  802d12:	83 e0 03             	and    $0x3,%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	75 3a                	jne    802d53 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d19:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  802d20:	00 00 00 
  802d23:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d26:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d2c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d2f:	89 c6                	mov    %eax,%esi
  802d31:	48 bf f0 4e 80 00 00 	movabs $0x804ef0,%rdi
  802d38:	00 00 00 
  802d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d40:	48 b9 37 06 80 00 00 	movabs $0x800637,%rcx
  802d47:	00 00 00 
  802d4a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d51:	eb 2a                	jmp    802d7d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d57:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d5b:	48 85 c0             	test   %rax,%rax
  802d5e:	75 07                	jne    802d67 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d60:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d65:	eb 16                	jmp    802d7d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6b:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d73:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d76:	89 d6                	mov    %edx,%esi
  802d78:	48 89 c7             	mov    %rax,%rdi
  802d7b:	ff d1                	callq  *%rcx
}
  802d7d:	c9                   	leaveq 
  802d7e:	c3                   	retq   

0000000000802d7f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d7f:	55                   	push   %rbp
  802d80:	48 89 e5             	mov    %rsp,%rbp
  802d83:	48 83 ec 30          	sub    $0x30,%rsp
  802d87:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d8e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d92:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d95:	48 89 d6             	mov    %rdx,%rsi
  802d98:	89 c7                	mov    %eax,%edi
  802d9a:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  802da1:	00 00 00 
  802da4:	ff d0                	callq  *%rax
  802da6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dad:	78 24                	js     802dd3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db3:	8b 00                	mov    (%rax),%eax
  802db5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802db9:	48 89 d6             	mov    %rdx,%rsi
  802dbc:	89 c7                	mov    %eax,%edi
  802dbe:	48 b8 6f 27 80 00 00 	movabs $0x80276f,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
  802dca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd1:	79 05                	jns    802dd8 <fstat+0x59>
		return r;
  802dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd6:	eb 5e                	jmp    802e36 <fstat+0xb7>
	if (!dev->dev_stat)
  802dd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddc:	48 8b 40 28          	mov    0x28(%rax),%rax
  802de0:	48 85 c0             	test   %rax,%rax
  802de3:	75 07                	jne    802dec <fstat+0x6d>
		return -E_NOT_SUPP;
  802de5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dea:	eb 4a                	jmp    802e36 <fstat+0xb7>
	stat->st_name[0] = 0;
  802dec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802df3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802dfe:	00 00 00 
	stat->st_isdir = 0;
  802e01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e05:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e0c:	00 00 00 
	stat->st_dev = dev;
  802e0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e17:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e22:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802e2e:	48 89 d6             	mov    %rdx,%rsi
  802e31:	48 89 c7             	mov    %rax,%rdi
  802e34:	ff d1                	callq  *%rcx
}
  802e36:	c9                   	leaveq 
  802e37:	c3                   	retq   

0000000000802e38 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e38:	55                   	push   %rbp
  802e39:	48 89 e5             	mov    %rsp,%rbp
  802e3c:	48 83 ec 20          	sub    $0x20,%rsp
  802e40:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e44:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e4c:	be 00 00 00 00       	mov    $0x0,%esi
  802e51:	48 89 c7             	mov    %rax,%rdi
  802e54:	48 b8 27 2f 80 00 00 	movabs $0x802f27,%rax
  802e5b:	00 00 00 
  802e5e:	ff d0                	callq  *%rax
  802e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e67:	79 05                	jns    802e6e <stat+0x36>
		return fd;
  802e69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6c:	eb 2f                	jmp    802e9d <stat+0x65>
	r = fstat(fd, stat);
  802e6e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e75:	48 89 d6             	mov    %rdx,%rsi
  802e78:	89 c7                	mov    %eax,%edi
  802e7a:	48 b8 7f 2d 80 00 00 	movabs $0x802d7f,%rax
  802e81:	00 00 00 
  802e84:	ff d0                	callq  *%rax
  802e86:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e8c:	89 c7                	mov    %eax,%edi
  802e8e:	48 b8 26 28 80 00 00 	movabs $0x802826,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
	return r;
  802e9a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e9d:	c9                   	leaveq 
  802e9e:	c3                   	retq   
	...

0000000000802ea0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ea0:	55                   	push   %rbp
  802ea1:	48 89 e5             	mov    %rsp,%rbp
  802ea4:	48 83 ec 10          	sub    $0x10,%rsp
  802ea8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802eab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802eaf:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802eb6:	00 00 00 
  802eb9:	8b 00                	mov    (%rax),%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	75 1d                	jne    802edc <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ebf:	bf 01 00 00 00       	mov    $0x1,%edi
  802ec4:	48 b8 93 45 80 00 00 	movabs $0x804593,%rax
  802ecb:	00 00 00 
  802ece:	ff d0                	callq  *%rax
  802ed0:	48 ba 24 70 80 00 00 	movabs $0x807024,%rdx
  802ed7:	00 00 00 
  802eda:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802edc:	48 b8 24 70 80 00 00 	movabs $0x807024,%rax
  802ee3:	00 00 00 
  802ee6:	8b 00                	mov    (%rax),%eax
  802ee8:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802eeb:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ef0:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802ef7:	00 00 00 
  802efa:	89 c7                	mov    %eax,%edi
  802efc:	48 b8 d0 44 80 00 00 	movabs $0x8044d0,%rax
  802f03:	00 00 00 
  802f06:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0c:	ba 00 00 00 00       	mov    $0x0,%edx
  802f11:	48 89 c6             	mov    %rax,%rsi
  802f14:	bf 00 00 00 00       	mov    $0x0,%edi
  802f19:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
}
  802f25:	c9                   	leaveq 
  802f26:	c3                   	retq   

0000000000802f27 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f27:	55                   	push   %rbp
  802f28:	48 89 e5             	mov    %rsp,%rbp
  802f2b:	48 83 ec 20          	sub    $0x20,%rsp
  802f2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f33:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3a:	48 89 c7             	mov    %rax,%rdi
  802f3d:	48 b8 88 11 80 00 00 	movabs $0x801188,%rax
  802f44:	00 00 00 
  802f47:	ff d0                	callq  *%rax
  802f49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f4e:	7e 0a                	jle    802f5a <open+0x33>
                return -E_BAD_PATH;
  802f50:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f55:	e9 a5 00 00 00       	jmpq   802fff <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802f5a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f5e:	48 89 c7             	mov    %rax,%rdi
  802f61:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
  802f6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f74:	79 08                	jns    802f7e <open+0x57>
		return r;
  802f76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f79:	e9 81 00 00 00       	jmpq   802fff <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f82:	48 89 c6             	mov    %rax,%rsi
  802f85:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802f8c:	00 00 00 
  802f8f:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802f9b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802fa2:	00 00 00 
  802fa5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fa8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802fae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb2:	48 89 c6             	mov    %rax,%rsi
  802fb5:	bf 01 00 00 00       	mov    $0x1,%edi
  802fba:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fcd:	79 1d                	jns    802fec <open+0xc5>
	{
		fd_close(fd,0);
  802fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd3:	be 00 00 00 00       	mov    $0x0,%esi
  802fd8:	48 89 c7             	mov    %rax,%rdi
  802fdb:	48 b8 a6 26 80 00 00 	movabs $0x8026a6,%rax
  802fe2:	00 00 00 
  802fe5:	ff d0                	callq  *%rax
		return r;
  802fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fea:	eb 13                	jmp    802fff <open+0xd8>
	}
	return fd2num(fd);
  802fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff0:	48 89 c7             	mov    %rax,%rdi
  802ff3:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
	


}
  802fff:	c9                   	leaveq 
  803000:	c3                   	retq   

0000000000803001 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803001:	55                   	push   %rbp
  803002:	48 89 e5             	mov    %rsp,%rbp
  803005:	48 83 ec 10          	sub    $0x10,%rsp
  803009:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80300d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803011:	8b 50 0c             	mov    0xc(%rax),%edx
  803014:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80301b:	00 00 00 
  80301e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803020:	be 00 00 00 00       	mov    $0x0,%esi
  803025:	bf 06 00 00 00       	mov    $0x6,%edi
  80302a:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
}
  803036:	c9                   	leaveq 
  803037:	c3                   	retq   

0000000000803038 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 30          	sub    $0x30,%rsp
  803040:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803048:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80304c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803050:	8b 50 0c             	mov    0xc(%rax),%edx
  803053:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80305a:	00 00 00 
  80305d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80305f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803066:	00 00 00 
  803069:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80306d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803071:	be 00 00 00 00       	mov    $0x0,%esi
  803076:	bf 03 00 00 00       	mov    $0x3,%edi
  80307b:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
  803087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308e:	79 05                	jns    803095 <devfile_read+0x5d>
	{
		return r;
  803090:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803093:	eb 2c                	jmp    8030c1 <devfile_read+0x89>
	}
	if(r > 0)
  803095:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803099:	7e 23                	jle    8030be <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80309b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309e:	48 63 d0             	movslq %eax,%rdx
  8030a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030a5:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8030ac:	00 00 00 
  8030af:	48 89 c7             	mov    %rax,%rdi
  8030b2:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  8030b9:	00 00 00 
  8030bc:	ff d0                	callq  *%rax
	return r;
  8030be:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8030c1:	c9                   	leaveq 
  8030c2:	c3                   	retq   

00000000008030c3 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030c3:	55                   	push   %rbp
  8030c4:	48 89 e5             	mov    %rsp,%rbp
  8030c7:	48 83 ec 30          	sub    $0x30,%rsp
  8030cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030d3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8030d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030db:	8b 50 0c             	mov    0xc(%rax),%edx
  8030de:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8030e5:	00 00 00 
  8030e8:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8030ea:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030f1:	00 
  8030f2:	76 08                	jbe    8030fc <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8030f4:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8030fb:	00 
	fsipcbuf.write.req_n=n;
  8030fc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803103:	00 00 00 
  803106:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80310a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  80310e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803112:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803116:	48 89 c6             	mov    %rax,%rsi
  803119:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803120:	00 00 00 
  803123:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  80312a:	00 00 00 
  80312d:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  80312f:	be 00 00 00 00       	mov    $0x0,%esi
  803134:	bf 04 00 00 00       	mov    $0x4,%edi
  803139:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
  803145:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803148:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80314b:	c9                   	leaveq 
  80314c:	c3                   	retq   

000000000080314d <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  80314d:	55                   	push   %rbp
  80314e:	48 89 e5             	mov    %rsp,%rbp
  803151:	48 83 ec 10          	sub    $0x10,%rsp
  803155:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803159:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80315c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803160:	8b 50 0c             	mov    0xc(%rax),%edx
  803163:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80316a:	00 00 00 
  80316d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  80316f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803176:	00 00 00 
  803179:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80317c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80317f:	be 00 00 00 00       	mov    $0x0,%esi
  803184:	bf 02 00 00 00       	mov    $0x2,%edi
  803189:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  803190:	00 00 00 
  803193:	ff d0                	callq  *%rax
}
  803195:	c9                   	leaveq 
  803196:	c3                   	retq   

0000000000803197 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803197:	55                   	push   %rbp
  803198:	48 89 e5             	mov    %rsp,%rbp
  80319b:	48 83 ec 20          	sub    $0x20,%rsp
  80319f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031a3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ab:	8b 50 0c             	mov    0xc(%rax),%edx
  8031ae:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8031b5:	00 00 00 
  8031b8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031ba:	be 00 00 00 00       	mov    $0x0,%esi
  8031bf:	bf 05 00 00 00       	mov    $0x5,%edi
  8031c4:	48 b8 a0 2e 80 00 00 	movabs $0x802ea0,%rax
  8031cb:	00 00 00 
  8031ce:	ff d0                	callq  *%rax
  8031d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d7:	79 05                	jns    8031de <devfile_stat+0x47>
		return r;
  8031d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031dc:	eb 56                	jmp    803234 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031e2:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8031e9:	00 00 00 
  8031ec:	48 89 c7             	mov    %rax,%rdi
  8031ef:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8031f6:	00 00 00 
  8031f9:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803202:	00 00 00 
  803205:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80320b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80320f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803215:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80321c:	00 00 00 
  80321f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803225:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803229:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80322f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803234:	c9                   	leaveq 
  803235:	c3                   	retq   
	...

0000000000803238 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803238:	55                   	push   %rbp
  803239:	48 89 e5             	mov    %rsp,%rbp
  80323c:	48 83 ec 20          	sub    $0x20,%rsp
  803240:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803243:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803247:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80324a:	48 89 d6             	mov    %rdx,%rsi
  80324d:	89 c7                	mov    %eax,%edi
  80324f:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  803256:	00 00 00 
  803259:	ff d0                	callq  *%rax
  80325b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80325e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803262:	79 05                	jns    803269 <fd2sockid+0x31>
		return r;
  803264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803267:	eb 24                	jmp    80328d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326d:	8b 10                	mov    (%rax),%edx
  80326f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  803276:	00 00 00 
  803279:	8b 00                	mov    (%rax),%eax
  80327b:	39 c2                	cmp    %eax,%edx
  80327d:	74 07                	je     803286 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80327f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803284:	eb 07                	jmp    80328d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80328d:	c9                   	leaveq 
  80328e:	c3                   	retq   

000000000080328f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80328f:	55                   	push   %rbp
  803290:	48 89 e5             	mov    %rsp,%rbp
  803293:	48 83 ec 20          	sub    $0x20,%rsp
  803297:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80329a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80329e:	48 89 c7             	mov    %rax,%rdi
  8032a1:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  8032a8:	00 00 00 
  8032ab:	ff d0                	callq  *%rax
  8032ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b4:	78 26                	js     8032dc <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8032bf:	48 89 c6             	mov    %rax,%rsi
  8032c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c7:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032da:	79 16                	jns    8032f2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032df:	89 c7                	mov    %eax,%edi
  8032e1:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  8032e8:	00 00 00 
  8032eb:	ff d0                	callq  *%rax
		return r;
  8032ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f0:	eb 3a                	jmp    80332c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f6:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8032fd:	00 00 00 
  803300:	8b 12                	mov    (%rdx),%edx
  803302:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803304:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803308:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80330f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803313:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803316:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803319:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331d:	48 89 c7             	mov    %rax,%rdi
  803320:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  803327:	00 00 00 
  80332a:	ff d0                	callq  *%rax
}
  80332c:	c9                   	leaveq 
  80332d:	c3                   	retq   

000000000080332e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80332e:	55                   	push   %rbp
  80332f:	48 89 e5             	mov    %rsp,%rbp
  803332:	48 83 ec 30          	sub    $0x30,%rsp
  803336:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803339:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80333d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803341:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803344:	89 c7                	mov    %eax,%edi
  803346:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  80334d:	00 00 00 
  803350:	ff d0                	callq  *%rax
  803352:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803355:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803359:	79 05                	jns    803360 <accept+0x32>
		return r;
  80335b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80335e:	eb 3b                	jmp    80339b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803360:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803364:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80336b:	48 89 ce             	mov    %rcx,%rsi
  80336e:	89 c7                	mov    %eax,%edi
  803370:	48 b8 79 36 80 00 00 	movabs $0x803679,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803383:	79 05                	jns    80338a <accept+0x5c>
		return r;
  803385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803388:	eb 11                	jmp    80339b <accept+0x6d>
	return alloc_sockfd(r);
  80338a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338d:	89 c7                	mov    %eax,%edi
  80338f:	48 b8 8f 32 80 00 00 	movabs $0x80328f,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
}
  80339b:	c9                   	leaveq 
  80339c:	c3                   	retq   

000000000080339d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80339d:	55                   	push   %rbp
  80339e:	48 89 e5             	mov    %rsp,%rbp
  8033a1:	48 83 ec 20          	sub    $0x20,%rsp
  8033a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ac:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033b2:	89 c7                	mov    %eax,%edi
  8033b4:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8033bb:	00 00 00 
  8033be:	ff d0                	callq  *%rax
  8033c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033c7:	79 05                	jns    8033ce <bind+0x31>
		return r;
  8033c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cc:	eb 1b                	jmp    8033e9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033ce:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d8:	48 89 ce             	mov    %rcx,%rsi
  8033db:	89 c7                	mov    %eax,%edi
  8033dd:	48 b8 f8 36 80 00 00 	movabs $0x8036f8,%rax
  8033e4:	00 00 00 
  8033e7:	ff d0                	callq  *%rax
}
  8033e9:	c9                   	leaveq 
  8033ea:	c3                   	retq   

00000000008033eb <shutdown>:

int
shutdown(int s, int how)
{
  8033eb:	55                   	push   %rbp
  8033ec:	48 89 e5             	mov    %rsp,%rbp
  8033ef:	48 83 ec 20          	sub    $0x20,%rsp
  8033f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033f6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033fc:	89 c7                	mov    %eax,%edi
  8033fe:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803405:	00 00 00 
  803408:	ff d0                	callq  *%rax
  80340a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80340d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803411:	79 05                	jns    803418 <shutdown+0x2d>
		return r;
  803413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803416:	eb 16                	jmp    80342e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803418:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80341b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341e:	89 d6                	mov    %edx,%esi
  803420:	89 c7                	mov    %eax,%edi
  803422:	48 b8 5c 37 80 00 00 	movabs $0x80375c,%rax
  803429:	00 00 00 
  80342c:	ff d0                	callq  *%rax
}
  80342e:	c9                   	leaveq 
  80342f:	c3                   	retq   

0000000000803430 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803430:	55                   	push   %rbp
  803431:	48 89 e5             	mov    %rsp,%rbp
  803434:	48 83 ec 10          	sub    $0x10,%rsp
  803438:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80343c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803440:	48 89 c7             	mov    %rax,%rdi
  803443:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
  80344f:	83 f8 01             	cmp    $0x1,%eax
  803452:	75 17                	jne    80346b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803454:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803458:	8b 40 0c             	mov    0xc(%rax),%eax
  80345b:	89 c7                	mov    %eax,%edi
  80345d:	48 b8 9c 37 80 00 00 	movabs $0x80379c,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
  803469:	eb 05                	jmp    803470 <devsock_close+0x40>
	else
		return 0;
  80346b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803470:	c9                   	leaveq 
  803471:	c3                   	retq   

0000000000803472 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803472:	55                   	push   %rbp
  803473:	48 89 e5             	mov    %rsp,%rbp
  803476:	48 83 ec 20          	sub    $0x20,%rsp
  80347a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80347d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803481:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803484:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803487:	89 c7                	mov    %eax,%edi
  803489:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  803490:	00 00 00 
  803493:	ff d0                	callq  *%rax
  803495:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803498:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80349c:	79 05                	jns    8034a3 <connect+0x31>
		return r;
  80349e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a1:	eb 1b                	jmp    8034be <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8034a3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034a6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ad:	48 89 ce             	mov    %rcx,%rsi
  8034b0:	89 c7                	mov    %eax,%edi
  8034b2:	48 b8 c9 37 80 00 00 	movabs $0x8037c9,%rax
  8034b9:	00 00 00 
  8034bc:	ff d0                	callq  *%rax
}
  8034be:	c9                   	leaveq 
  8034bf:	c3                   	retq   

00000000008034c0 <listen>:

int
listen(int s, int backlog)
{
  8034c0:	55                   	push   %rbp
  8034c1:	48 89 e5             	mov    %rsp,%rbp
  8034c4:	48 83 ec 20          	sub    $0x20,%rsp
  8034c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034cb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d1:	89 c7                	mov    %eax,%edi
  8034d3:	48 b8 38 32 80 00 00 	movabs $0x803238,%rax
  8034da:	00 00 00 
  8034dd:	ff d0                	callq  *%rax
  8034df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034e6:	79 05                	jns    8034ed <listen+0x2d>
		return r;
  8034e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034eb:	eb 16                	jmp    803503 <listen+0x43>
	return nsipc_listen(r, backlog);
  8034ed:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	89 d6                	mov    %edx,%esi
  8034f5:	89 c7                	mov    %eax,%edi
  8034f7:	48 b8 2d 38 80 00 00 	movabs $0x80382d,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
}
  803503:	c9                   	leaveq 
  803504:	c3                   	retq   

0000000000803505 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	48 83 ec 20          	sub    $0x20,%rsp
  80350d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803511:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803515:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351d:	89 c2                	mov    %eax,%edx
  80351f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803523:	8b 40 0c             	mov    0xc(%rax),%eax
  803526:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80352a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80352f:	89 c7                	mov    %eax,%edi
  803531:	48 b8 6d 38 80 00 00 	movabs $0x80386d,%rax
  803538:	00 00 00 
  80353b:	ff d0                	callq  *%rax
}
  80353d:	c9                   	leaveq 
  80353e:	c3                   	retq   

000000000080353f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80353f:	55                   	push   %rbp
  803540:	48 89 e5             	mov    %rsp,%rbp
  803543:	48 83 ec 20          	sub    $0x20,%rsp
  803547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80354b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80354f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803557:	89 c2                	mov    %eax,%edx
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	8b 40 0c             	mov    0xc(%rax),%eax
  803560:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803564:	b9 00 00 00 00       	mov    $0x0,%ecx
  803569:	89 c7                	mov    %eax,%edi
  80356b:	48 b8 39 39 80 00 00 	movabs $0x803939,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
}
  803577:	c9                   	leaveq 
  803578:	c3                   	retq   

0000000000803579 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803579:	55                   	push   %rbp
  80357a:	48 89 e5             	mov    %rsp,%rbp
  80357d:	48 83 ec 10          	sub    $0x10,%rsp
  803581:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803585:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803589:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80358d:	48 be 1b 4f 80 00 00 	movabs $0x804f1b,%rsi
  803594:	00 00 00 
  803597:	48 89 c7             	mov    %rax,%rdi
  80359a:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
	return 0;
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035ab:	c9                   	leaveq 
  8035ac:	c3                   	retq   

00000000008035ad <socket>:

int
socket(int domain, int type, int protocol)
{
  8035ad:	55                   	push   %rbp
  8035ae:	48 89 e5             	mov    %rsp,%rbp
  8035b1:	48 83 ec 20          	sub    $0x20,%rsp
  8035b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035b8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035bb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035be:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035c1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035c7:	89 ce                	mov    %ecx,%esi
  8035c9:	89 c7                	mov    %eax,%edi
  8035cb:	48 b8 f1 39 80 00 00 	movabs $0x8039f1,%rax
  8035d2:	00 00 00 
  8035d5:	ff d0                	callq  *%rax
  8035d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035de:	79 05                	jns    8035e5 <socket+0x38>
		return r;
  8035e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e3:	eb 11                	jmp    8035f6 <socket+0x49>
	return alloc_sockfd(r);
  8035e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e8:	89 c7                	mov    %eax,%edi
  8035ea:	48 b8 8f 32 80 00 00 	movabs $0x80328f,%rax
  8035f1:	00 00 00 
  8035f4:	ff d0                	callq  *%rax
}
  8035f6:	c9                   	leaveq 
  8035f7:	c3                   	retq   

00000000008035f8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035f8:	55                   	push   %rbp
  8035f9:	48 89 e5             	mov    %rsp,%rbp
  8035fc:	48 83 ec 10          	sub    $0x10,%rsp
  803600:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803603:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  80360a:	00 00 00 
  80360d:	8b 00                	mov    (%rax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	75 1d                	jne    803630 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803613:	bf 02 00 00 00       	mov    $0x2,%edi
  803618:	48 b8 93 45 80 00 00 	movabs $0x804593,%rax
  80361f:	00 00 00 
  803622:	ff d0                	callq  *%rax
  803624:	48 ba 30 70 80 00 00 	movabs $0x807030,%rdx
  80362b:	00 00 00 
  80362e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803630:	48 b8 30 70 80 00 00 	movabs $0x807030,%rax
  803637:	00 00 00 
  80363a:	8b 00                	mov    (%rax),%eax
  80363c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80363f:	b9 07 00 00 00       	mov    $0x7,%ecx
  803644:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80364b:	00 00 00 
  80364e:	89 c7                	mov    %eax,%edi
  803650:	48 b8 d0 44 80 00 00 	movabs $0x8044d0,%rax
  803657:	00 00 00 
  80365a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80365c:	ba 00 00 00 00       	mov    $0x0,%edx
  803661:	be 00 00 00 00       	mov    $0x0,%esi
  803666:	bf 00 00 00 00       	mov    $0x0,%edi
  80366b:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
}
  803677:	c9                   	leaveq 
  803678:	c3                   	retq   

0000000000803679 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803679:	55                   	push   %rbp
  80367a:	48 89 e5             	mov    %rsp,%rbp
  80367d:	48 83 ec 30          	sub    $0x30,%rsp
  803681:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803684:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803688:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80368c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803693:	00 00 00 
  803696:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803699:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80369b:	bf 01 00 00 00       	mov    $0x1,%edi
  8036a0:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  8036a7:	00 00 00 
  8036aa:	ff d0                	callq  *%rax
  8036ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b3:	78 3e                	js     8036f3 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8036b5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036bc:	00 00 00 
  8036bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c7:	8b 40 10             	mov    0x10(%rax),%eax
  8036ca:	89 c2                	mov    %eax,%edx
  8036cc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d4:	48 89 ce             	mov    %rcx,%rsi
  8036d7:	48 89 c7             	mov    %rax,%rdi
  8036da:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  8036e1:	00 00 00 
  8036e4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ea:	8b 50 10             	mov    0x10(%rax),%edx
  8036ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f1:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036f6:	c9                   	leaveq 
  8036f7:	c3                   	retq   

00000000008036f8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8036f8:	55                   	push   %rbp
  8036f9:	48 89 e5             	mov    %rsp,%rbp
  8036fc:	48 83 ec 10          	sub    $0x10,%rsp
  803700:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803703:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803707:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80370a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803711:	00 00 00 
  803714:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803717:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803719:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80371c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803720:	48 89 c6             	mov    %rax,%rsi
  803723:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80372a:	00 00 00 
  80372d:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  803734:	00 00 00 
  803737:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803739:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803740:	00 00 00 
  803743:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803746:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803749:	bf 02 00 00 00       	mov    $0x2,%edi
  80374e:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  803755:	00 00 00 
  803758:	ff d0                	callq  *%rax
}
  80375a:	c9                   	leaveq 
  80375b:	c3                   	retq   

000000000080375c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80375c:	55                   	push   %rbp
  80375d:	48 89 e5             	mov    %rsp,%rbp
  803760:	48 83 ec 10          	sub    $0x10,%rsp
  803764:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803767:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80376a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803771:	00 00 00 
  803774:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803777:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803779:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803780:	00 00 00 
  803783:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803786:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803789:	bf 03 00 00 00       	mov    $0x3,%edi
  80378e:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  803795:	00 00 00 
  803798:	ff d0                	callq  *%rax
}
  80379a:	c9                   	leaveq 
  80379b:	c3                   	retq   

000000000080379c <nsipc_close>:

int
nsipc_close(int s)
{
  80379c:	55                   	push   %rbp
  80379d:	48 89 e5             	mov    %rsp,%rbp
  8037a0:	48 83 ec 10          	sub    $0x10,%rsp
  8037a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8037a7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ae:	00 00 00 
  8037b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037b4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8037b6:	bf 04 00 00 00       	mov    $0x4,%edi
  8037bb:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  8037c2:	00 00 00 
  8037c5:	ff d0                	callq  *%rax
}
  8037c7:	c9                   	leaveq 
  8037c8:	c3                   	retq   

00000000008037c9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037c9:	55                   	push   %rbp
  8037ca:	48 89 e5             	mov    %rsp,%rbp
  8037cd:	48 83 ec 10          	sub    $0x10,%rsp
  8037d1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037d8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037db:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037e2:	00 00 00 
  8037e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037e8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037ea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f1:	48 89 c6             	mov    %rax,%rsi
  8037f4:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8037fb:	00 00 00 
  8037fe:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  803805:	00 00 00 
  803808:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80380a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803811:	00 00 00 
  803814:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803817:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80381a:	bf 05 00 00 00       	mov    $0x5,%edi
  80381f:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
}
  80382b:	c9                   	leaveq 
  80382c:	c3                   	retq   

000000000080382d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80382d:	55                   	push   %rbp
  80382e:	48 89 e5             	mov    %rsp,%rbp
  803831:	48 83 ec 10          	sub    $0x10,%rsp
  803835:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803838:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80383b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803842:	00 00 00 
  803845:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803848:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80384a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803851:	00 00 00 
  803854:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803857:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80385a:	bf 06 00 00 00       	mov    $0x6,%edi
  80385f:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  803866:	00 00 00 
  803869:	ff d0                	callq  *%rax
}
  80386b:	c9                   	leaveq 
  80386c:	c3                   	retq   

000000000080386d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80386d:	55                   	push   %rbp
  80386e:	48 89 e5             	mov    %rsp,%rbp
  803871:	48 83 ec 30          	sub    $0x30,%rsp
  803875:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803878:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80387c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80387f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803882:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803889:	00 00 00 
  80388c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80388f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803891:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803898:	00 00 00 
  80389b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80389e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8038a1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038a8:	00 00 00 
  8038ab:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8038ae:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038b1:	bf 07 00 00 00       	mov    $0x7,%edi
  8038b6:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  8038bd:	00 00 00 
  8038c0:	ff d0                	callq  *%rax
  8038c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c9:	78 69                	js     803934 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038cb:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038d2:	7f 08                	jg     8038dc <nsipc_recv+0x6f>
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038da:	7e 35                	jle    803911 <nsipc_recv+0xa4>
  8038dc:	48 b9 22 4f 80 00 00 	movabs $0x804f22,%rcx
  8038e3:	00 00 00 
  8038e6:	48 ba 37 4f 80 00 00 	movabs $0x804f37,%rdx
  8038ed:	00 00 00 
  8038f0:	be 61 00 00 00       	mov    $0x61,%esi
  8038f5:	48 bf 4c 4f 80 00 00 	movabs $0x804f4c,%rdi
  8038fc:	00 00 00 
  8038ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803904:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  80390b:	00 00 00 
  80390e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803911:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803914:	48 63 d0             	movslq %eax,%rdx
  803917:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391b:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803922:	00 00 00 
  803925:	48 89 c7             	mov    %rax,%rdi
  803928:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
	}

	return r;
  803934:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803937:	c9                   	leaveq 
  803938:	c3                   	retq   

0000000000803939 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803939:	55                   	push   %rbp
  80393a:	48 89 e5             	mov    %rsp,%rbp
  80393d:	48 83 ec 20          	sub    $0x20,%rsp
  803941:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803944:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803948:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80394b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80394e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803955:	00 00 00 
  803958:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80395b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  80395d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803964:	7e 35                	jle    80399b <nsipc_send+0x62>
  803966:	48 b9 58 4f 80 00 00 	movabs $0x804f58,%rcx
  80396d:	00 00 00 
  803970:	48 ba 37 4f 80 00 00 	movabs $0x804f37,%rdx
  803977:	00 00 00 
  80397a:	be 6c 00 00 00       	mov    $0x6c,%esi
  80397f:	48 bf 4c 4f 80 00 00 	movabs $0x804f4c,%rdi
  803986:	00 00 00 
  803989:	b8 00 00 00 00       	mov    $0x0,%eax
  80398e:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  803995:	00 00 00 
  803998:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80399b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80399e:	48 63 d0             	movslq %eax,%rdx
  8039a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039a5:	48 89 c6             	mov    %rax,%rsi
  8039a8:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  8039af:	00 00 00 
  8039b2:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c5:	00 00 00 
  8039c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039cb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039ce:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039d5:	00 00 00 
  8039d8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039db:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039de:	bf 08 00 00 00       	mov    $0x8,%edi
  8039e3:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  8039ea:	00 00 00 
  8039ed:	ff d0                	callq  *%rax
}
  8039ef:	c9                   	leaveq 
  8039f0:	c3                   	retq   

00000000008039f1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039f1:	55                   	push   %rbp
  8039f2:	48 89 e5             	mov    %rsp,%rbp
  8039f5:	48 83 ec 10          	sub    $0x10,%rsp
  8039f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8039fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8039ff:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a02:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a09:	00 00 00 
  803a0c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a0f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a11:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a18:	00 00 00 
  803a1b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a1e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a21:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a28:	00 00 00 
  803a2b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a2e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a31:	bf 09 00 00 00       	mov    $0x9,%edi
  803a36:	48 b8 f8 35 80 00 00 	movabs $0x8035f8,%rax
  803a3d:	00 00 00 
  803a40:	ff d0                	callq  *%rax
}
  803a42:	c9                   	leaveq 
  803a43:	c3                   	retq   

0000000000803a44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	53                   	push   %rbx
  803a49:	48 83 ec 38          	sub    $0x38,%rsp
  803a4d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a51:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a55:	48 89 c7             	mov    %rax,%rdi
  803a58:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  803a5f:	00 00 00 
  803a62:	ff d0                	callq  *%rax
  803a64:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a67:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a6b:	0f 88 bf 01 00 00    	js     803c30 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a75:	ba 07 04 00 00       	mov    $0x407,%edx
  803a7a:	48 89 c6             	mov    %rax,%rsi
  803a7d:	bf 00 00 00 00       	mov    $0x0,%edi
  803a82:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
  803a8e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a91:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a95:	0f 88 95 01 00 00    	js     803c30 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a9b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803a9f:	48 89 c7             	mov    %rax,%rdi
  803aa2:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  803aa9:	00 00 00 
  803aac:	ff d0                	callq  *%rax
  803aae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ab5:	0f 88 5d 01 00 00    	js     803c18 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803abb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803abf:	ba 07 04 00 00       	mov    $0x407,%edx
  803ac4:	48 89 c6             	mov    %rax,%rsi
  803ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  803acc:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
  803ad8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803adb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803adf:	0f 88 33 01 00 00    	js     803c18 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae9:	48 89 c7             	mov    %rax,%rdi
  803aec:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803af3:	00 00 00 
  803af6:	ff d0                	callq  *%rax
  803af8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b00:	ba 07 04 00 00       	mov    $0x407,%edx
  803b05:	48 89 c6             	mov    %rax,%rsi
  803b08:	bf 00 00 00 00       	mov    $0x0,%edi
  803b0d:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
  803b19:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b20:	0f 88 d9 00 00 00    	js     803bff <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b26:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b2a:	48 89 c7             	mov    %rax,%rdi
  803b2d:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803b34:	00 00 00 
  803b37:	ff d0                	callq  *%rax
  803b39:	48 89 c2             	mov    %rax,%rdx
  803b3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b40:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b46:	48 89 d1             	mov    %rdx,%rcx
  803b49:	ba 00 00 00 00       	mov    $0x0,%edx
  803b4e:	48 89 c6             	mov    %rax,%rsi
  803b51:	bf 00 00 00 00       	mov    $0x0,%edi
  803b56:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  803b5d:	00 00 00 
  803b60:	ff d0                	callq  *%rax
  803b62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b65:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b69:	78 79                	js     803be4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6f:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b76:	00 00 00 
  803b79:	8b 12                	mov    (%rdx),%edx
  803b7b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b8c:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b93:	00 00 00 
  803b96:	8b 12                	mov    (%rdx),%edx
  803b98:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b9a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b9e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ba5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba9:	48 89 c7             	mov    %rax,%rdi
  803bac:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  803bb3:	00 00 00 
  803bb6:	ff d0                	callq  *%rax
  803bb8:	89 c2                	mov    %eax,%edx
  803bba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bbe:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bc0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bc4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bc8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bcc:	48 89 c7             	mov    %rax,%rdi
  803bcf:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
  803bdb:	89 03                	mov    %eax,(%rbx)
	return 0;
  803bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803be2:	eb 4f                	jmp    803c33 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803be4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803be5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803be9:	48 89 c6             	mov    %rax,%rsi
  803bec:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf1:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803bf8:	00 00 00 
  803bfb:	ff d0                	callq  *%rax
  803bfd:	eb 01                	jmp    803c00 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803bff:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803c00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c04:	48 89 c6             	mov    %rax,%rsi
  803c07:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0c:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803c13:	00 00 00 
  803c16:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803c18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1c:	48 89 c6             	mov    %rax,%rsi
  803c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c24:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
    err:
	return r;
  803c30:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c33:	48 83 c4 38          	add    $0x38,%rsp
  803c37:	5b                   	pop    %rbx
  803c38:	5d                   	pop    %rbp
  803c39:	c3                   	retq   

0000000000803c3a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c3a:	55                   	push   %rbp
  803c3b:	48 89 e5             	mov    %rsp,%rbp
  803c3e:	53                   	push   %rbx
  803c3f:	48 83 ec 28          	sub    $0x28,%rsp
  803c43:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c47:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c4b:	eb 01                	jmp    803c4e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c4d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c4e:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c55:	00 00 00 
  803c58:	48 8b 00             	mov    (%rax),%rax
  803c5b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c61:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c68:	48 89 c7             	mov    %rax,%rdi
  803c6b:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  803c72:	00 00 00 
  803c75:	ff d0                	callq  *%rax
  803c77:	89 c3                	mov    %eax,%ebx
  803c79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c7d:	48 89 c7             	mov    %rax,%rdi
  803c80:	48 b8 18 46 80 00 00 	movabs $0x804618,%rax
  803c87:	00 00 00 
  803c8a:	ff d0                	callq  *%rax
  803c8c:	39 c3                	cmp    %eax,%ebx
  803c8e:	0f 94 c0             	sete   %al
  803c91:	0f b6 c0             	movzbl %al,%eax
  803c94:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c97:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803c9e:	00 00 00 
  803ca1:	48 8b 00             	mov    (%rax),%rax
  803ca4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803caa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803cad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cb3:	75 0a                	jne    803cbf <_pipeisclosed+0x85>
			return ret;
  803cb5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803cb8:	48 83 c4 28          	add    $0x28,%rsp
  803cbc:	5b                   	pop    %rbx
  803cbd:	5d                   	pop    %rbp
  803cbe:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803cbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cc2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cc5:	74 86                	je     803c4d <_pipeisclosed+0x13>
  803cc7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ccb:	75 80                	jne    803c4d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ccd:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  803cd4:	00 00 00 
  803cd7:	48 8b 00             	mov    (%rax),%rax
  803cda:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ce0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ce3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ce6:	89 c6                	mov    %eax,%esi
  803ce8:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  803cef:	00 00 00 
  803cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf7:	49 b8 37 06 80 00 00 	movabs $0x800637,%r8
  803cfe:	00 00 00 
  803d01:	41 ff d0             	callq  *%r8
	}
  803d04:	e9 44 ff ff ff       	jmpq   803c4d <_pipeisclosed+0x13>

0000000000803d09 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803d09:	55                   	push   %rbp
  803d0a:	48 89 e5             	mov    %rsp,%rbp
  803d0d:	48 83 ec 30          	sub    $0x30,%rsp
  803d11:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d1b:	48 89 d6             	mov    %rdx,%rsi
  803d1e:	89 c7                	mov    %eax,%edi
  803d20:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  803d27:	00 00 00 
  803d2a:	ff d0                	callq  *%rax
  803d2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d33:	79 05                	jns    803d3a <pipeisclosed+0x31>
		return r;
  803d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d38:	eb 31                	jmp    803d6b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d3e:	48 89 c7             	mov    %rax,%rdi
  803d41:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803d48:	00 00 00 
  803d4b:	ff d0                	callq  *%rax
  803d4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d59:	48 89 d6             	mov    %rdx,%rsi
  803d5c:	48 89 c7             	mov    %rax,%rdi
  803d5f:	48 b8 3a 3c 80 00 00 	movabs $0x803c3a,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
}
  803d6b:	c9                   	leaveq 
  803d6c:	c3                   	retq   

0000000000803d6d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d6d:	55                   	push   %rbp
  803d6e:	48 89 e5             	mov    %rsp,%rbp
  803d71:	48 83 ec 40          	sub    $0x40,%rsp
  803d75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d7d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d85:	48 89 c7             	mov    %rax,%rdi
  803d88:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803d8f:	00 00 00 
  803d92:	ff d0                	callq  *%rax
  803d94:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803d98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803da0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803da7:	00 
  803da8:	e9 97 00 00 00       	jmpq   803e44 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803dad:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803db2:	74 09                	je     803dbd <devpipe_read+0x50>
				return i;
  803db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db8:	e9 95 00 00 00       	jmpq   803e52 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dc5:	48 89 d6             	mov    %rdx,%rsi
  803dc8:	48 89 c7             	mov    %rax,%rdi
  803dcb:	48 b8 3a 3c 80 00 00 	movabs $0x803c3a,%rax
  803dd2:	00 00 00 
  803dd5:	ff d0                	callq  *%rax
  803dd7:	85 c0                	test   %eax,%eax
  803dd9:	74 07                	je     803de2 <devpipe_read+0x75>
				return 0;
  803ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  803de0:	eb 70                	jmp    803e52 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803de2:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  803de9:	00 00 00 
  803dec:	ff d0                	callq  *%rax
  803dee:	eb 01                	jmp    803df1 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803df0:	90                   	nop
  803df1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803df5:	8b 10                	mov    (%rax),%edx
  803df7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfb:	8b 40 04             	mov    0x4(%rax),%eax
  803dfe:	39 c2                	cmp    %eax,%edx
  803e00:	74 ab                	je     803dad <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e06:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e0a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e12:	8b 00                	mov    (%rax),%eax
  803e14:	89 c2                	mov    %eax,%edx
  803e16:	c1 fa 1f             	sar    $0x1f,%edx
  803e19:	c1 ea 1b             	shr    $0x1b,%edx
  803e1c:	01 d0                	add    %edx,%eax
  803e1e:	83 e0 1f             	and    $0x1f,%eax
  803e21:	29 d0                	sub    %edx,%eax
  803e23:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e27:	48 98                	cltq   
  803e29:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e2e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e34:	8b 00                	mov    (%rax),%eax
  803e36:	8d 50 01             	lea    0x1(%rax),%edx
  803e39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e3f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e48:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e4c:	72 a2                	jb     803df0 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e52:	c9                   	leaveq 
  803e53:	c3                   	retq   

0000000000803e54 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e54:	55                   	push   %rbp
  803e55:	48 89 e5             	mov    %rsp,%rbp
  803e58:	48 83 ec 40          	sub    $0x40,%rsp
  803e5c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e6c:	48 89 c7             	mov    %rax,%rdi
  803e6f:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803e76:	00 00 00 
  803e79:	ff d0                	callq  *%rax
  803e7b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e87:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e8e:	00 
  803e8f:	e9 93 00 00 00       	jmpq   803f27 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e9c:	48 89 d6             	mov    %rdx,%rsi
  803e9f:	48 89 c7             	mov    %rax,%rdi
  803ea2:	48 b8 3a 3c 80 00 00 	movabs $0x803c3a,%rax
  803ea9:	00 00 00 
  803eac:	ff d0                	callq  *%rax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	74 07                	je     803eb9 <devpipe_write+0x65>
				return 0;
  803eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb7:	eb 7c                	jmp    803f35 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803eb9:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
  803ec5:	eb 01                	jmp    803ec8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ec7:	90                   	nop
  803ec8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ecc:	8b 40 04             	mov    0x4(%rax),%eax
  803ecf:	48 63 d0             	movslq %eax,%rdx
  803ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed6:	8b 00                	mov    (%rax),%eax
  803ed8:	48 98                	cltq   
  803eda:	48 83 c0 20          	add    $0x20,%rax
  803ede:	48 39 c2             	cmp    %rax,%rdx
  803ee1:	73 b1                	jae    803e94 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803ee3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee7:	8b 40 04             	mov    0x4(%rax),%eax
  803eea:	89 c2                	mov    %eax,%edx
  803eec:	c1 fa 1f             	sar    $0x1f,%edx
  803eef:	c1 ea 1b             	shr    $0x1b,%edx
  803ef2:	01 d0                	add    %edx,%eax
  803ef4:	83 e0 1f             	and    $0x1f,%eax
  803ef7:	29 d0                	sub    %edx,%eax
  803ef9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803efd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f01:	48 01 ca             	add    %rcx,%rdx
  803f04:	0f b6 0a             	movzbl (%rdx),%ecx
  803f07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f0b:	48 98                	cltq   
  803f0d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f15:	8b 40 04             	mov    0x4(%rax),%eax
  803f18:	8d 50 01             	lea    0x1(%rax),%edx
  803f1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f22:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f2f:	72 96                	jb     803ec7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f35:	c9                   	leaveq 
  803f36:	c3                   	retq   

0000000000803f37 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f37:	55                   	push   %rbp
  803f38:	48 89 e5             	mov    %rsp,%rbp
  803f3b:	48 83 ec 20          	sub    $0x20,%rsp
  803f3f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f43:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f4b:	48 89 c7             	mov    %rax,%rdi
  803f4e:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803f55:	00 00 00 
  803f58:	ff d0                	callq  *%rax
  803f5a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f62:	48 be 7c 4f 80 00 00 	movabs $0x804f7c,%rsi
  803f69:	00 00 00 
  803f6c:	48 89 c7             	mov    %rax,%rdi
  803f6f:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f7f:	8b 50 04             	mov    0x4(%rax),%edx
  803f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f86:	8b 00                	mov    (%rax),%eax
  803f88:	29 c2                	sub    %eax,%edx
  803f8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f8e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f94:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f98:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803f9f:	00 00 00 
	stat->st_dev = &devpipe;
  803fa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa6:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803fad:	00 00 00 
  803fb0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fbc:	c9                   	leaveq 
  803fbd:	c3                   	retq   

0000000000803fbe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fbe:	55                   	push   %rbp
  803fbf:	48 89 e5             	mov    %rsp,%rbp
  803fc2:	48 83 ec 10          	sub    $0x10,%rsp
  803fc6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fce:	48 89 c6             	mov    %rax,%rsi
  803fd1:	bf 00 00 00 00       	mov    $0x0,%edi
  803fd6:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  803fdd:	00 00 00 
  803fe0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fe2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe6:	48 89 c7             	mov    %rax,%rdi
  803fe9:	48 b8 53 25 80 00 00 	movabs $0x802553,%rax
  803ff0:	00 00 00 
  803ff3:	ff d0                	callq  *%rax
  803ff5:	48 89 c6             	mov    %rax,%rsi
  803ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  803ffd:	48 b8 d7 1b 80 00 00 	movabs $0x801bd7,%rax
  804004:	00 00 00 
  804007:	ff d0                	callq  *%rax
}
  804009:	c9                   	leaveq 
  80400a:	c3                   	retq   
	...

000000000080400c <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80400c:	55                   	push   %rbp
  80400d:	48 89 e5             	mov    %rsp,%rbp
  804010:	48 83 ec 20          	sub    $0x20,%rsp
  804014:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804017:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80401a:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80401d:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804021:	be 01 00 00 00       	mov    $0x1,%esi
  804026:	48 89 c7             	mov    %rax,%rdi
  804029:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  804030:	00 00 00 
  804033:	ff d0                	callq  *%rax
}
  804035:	c9                   	leaveq 
  804036:	c3                   	retq   

0000000000804037 <getchar>:

int
getchar(void)
{
  804037:	55                   	push   %rbp
  804038:	48 89 e5             	mov    %rsp,%rbp
  80403b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80403f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804043:	ba 01 00 00 00       	mov    $0x1,%edx
  804048:	48 89 c6             	mov    %rax,%rsi
  80404b:	bf 00 00 00 00       	mov    $0x0,%edi
  804050:	48 b8 48 2a 80 00 00 	movabs $0x802a48,%rax
  804057:	00 00 00 
  80405a:	ff d0                	callq  *%rax
  80405c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80405f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804063:	79 05                	jns    80406a <getchar+0x33>
		return r;
  804065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804068:	eb 14                	jmp    80407e <getchar+0x47>
	if (r < 1)
  80406a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80406e:	7f 07                	jg     804077 <getchar+0x40>
		return -E_EOF;
  804070:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804075:	eb 07                	jmp    80407e <getchar+0x47>
	return c;
  804077:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80407b:	0f b6 c0             	movzbl %al,%eax
}
  80407e:	c9                   	leaveq 
  80407f:	c3                   	retq   

0000000000804080 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804080:	55                   	push   %rbp
  804081:	48 89 e5             	mov    %rsp,%rbp
  804084:	48 83 ec 20          	sub    $0x20,%rsp
  804088:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80408b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80408f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804092:	48 89 d6             	mov    %rdx,%rsi
  804095:	89 c7                	mov    %eax,%edi
  804097:	48 b8 16 26 80 00 00 	movabs $0x802616,%rax
  80409e:	00 00 00 
  8040a1:	ff d0                	callq  *%rax
  8040a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040aa:	79 05                	jns    8040b1 <iscons+0x31>
		return r;
  8040ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040af:	eb 1a                	jmp    8040cb <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8040b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b5:	8b 10                	mov    (%rax),%edx
  8040b7:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8040be:	00 00 00 
  8040c1:	8b 00                	mov    (%rax),%eax
  8040c3:	39 c2                	cmp    %eax,%edx
  8040c5:	0f 94 c0             	sete   %al
  8040c8:	0f b6 c0             	movzbl %al,%eax
}
  8040cb:	c9                   	leaveq 
  8040cc:	c3                   	retq   

00000000008040cd <opencons>:

int
opencons(void)
{
  8040cd:	55                   	push   %rbp
  8040ce:	48 89 e5             	mov    %rsp,%rbp
  8040d1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040d5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040d9:	48 89 c7             	mov    %rax,%rdi
  8040dc:	48 b8 7e 25 80 00 00 	movabs $0x80257e,%rax
  8040e3:	00 00 00 
  8040e6:	ff d0                	callq  *%rax
  8040e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ef:	79 05                	jns    8040f6 <opencons+0x29>
		return r;
  8040f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f4:	eb 5b                	jmp    804151 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040fa:	ba 07 04 00 00       	mov    $0x407,%edx
  8040ff:	48 89 c6             	mov    %rax,%rsi
  804102:	bf 00 00 00 00       	mov    $0x0,%edi
  804107:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  80410e:	00 00 00 
  804111:	ff d0                	callq  *%rax
  804113:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80411a:	79 05                	jns    804121 <opencons+0x54>
		return r;
  80411c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80411f:	eb 30                	jmp    804151 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804121:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804125:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80412c:	00 00 00 
  80412f:	8b 12                	mov    (%rdx),%edx
  804131:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804137:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80413e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804142:	48 89 c7             	mov    %rax,%rdi
  804145:	48 b8 30 25 80 00 00 	movabs $0x802530,%rax
  80414c:	00 00 00 
  80414f:	ff d0                	callq  *%rax
}
  804151:	c9                   	leaveq 
  804152:	c3                   	retq   

0000000000804153 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804153:	55                   	push   %rbp
  804154:	48 89 e5             	mov    %rsp,%rbp
  804157:	48 83 ec 30          	sub    $0x30,%rsp
  80415b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80415f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804163:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804167:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80416c:	75 13                	jne    804181 <devcons_read+0x2e>
		return 0;
  80416e:	b8 00 00 00 00       	mov    $0x0,%eax
  804173:	eb 49                	jmp    8041be <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804175:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  80417c:	00 00 00 
  80417f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804181:	48 b8 2e 1a 80 00 00 	movabs $0x801a2e,%rax
  804188:	00 00 00 
  80418b:	ff d0                	callq  *%rax
  80418d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804194:	74 df                	je     804175 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80419a:	79 05                	jns    8041a1 <devcons_read+0x4e>
		return c;
  80419c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80419f:	eb 1d                	jmp    8041be <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8041a1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8041a5:	75 07                	jne    8041ae <devcons_read+0x5b>
		return 0;
  8041a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ac:	eb 10                	jmp    8041be <devcons_read+0x6b>
	*(char*)vbuf = c;
  8041ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b1:	89 c2                	mov    %eax,%edx
  8041b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041b7:	88 10                	mov    %dl,(%rax)
	return 1;
  8041b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8041be:	c9                   	leaveq 
  8041bf:	c3                   	retq   

00000000008041c0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041c0:	55                   	push   %rbp
  8041c1:	48 89 e5             	mov    %rsp,%rbp
  8041c4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8041cb:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041d2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041d9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041e7:	eb 77                	jmp    804260 <devcons_write+0xa0>
		m = n - tot;
  8041e9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041f0:	89 c2                	mov    %eax,%edx
  8041f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f5:	89 d1                	mov    %edx,%ecx
  8041f7:	29 c1                	sub    %eax,%ecx
  8041f9:	89 c8                	mov    %ecx,%eax
  8041fb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804201:	83 f8 7f             	cmp    $0x7f,%eax
  804204:	76 07                	jbe    80420d <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  804206:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80420d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804210:	48 63 d0             	movslq %eax,%rdx
  804213:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804216:	48 98                	cltq   
  804218:	48 89 c1             	mov    %rax,%rcx
  80421b:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  804222:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804229:	48 89 ce             	mov    %rcx,%rsi
  80422c:	48 89 c7             	mov    %rax,%rdi
  80422f:	48 b8 16 15 80 00 00 	movabs $0x801516,%rax
  804236:	00 00 00 
  804239:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80423b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80423e:	48 63 d0             	movslq %eax,%rdx
  804241:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804248:	48 89 d6             	mov    %rdx,%rsi
  80424b:	48 89 c7             	mov    %rax,%rdi
  80424e:	48 b8 e4 19 80 00 00 	movabs $0x8019e4,%rax
  804255:	00 00 00 
  804258:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80425a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80425d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804260:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804263:	48 98                	cltq   
  804265:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80426c:	0f 82 77 ff ff ff    	jb     8041e9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804272:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804275:	c9                   	leaveq 
  804276:	c3                   	retq   

0000000000804277 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804277:	55                   	push   %rbp
  804278:	48 89 e5             	mov    %rsp,%rbp
  80427b:	48 83 ec 08          	sub    $0x8,%rsp
  80427f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804288:	c9                   	leaveq 
  804289:	c3                   	retq   

000000000080428a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80428a:	55                   	push   %rbp
  80428b:	48 89 e5             	mov    %rsp,%rbp
  80428e:	48 83 ec 10          	sub    $0x10,%rsp
  804292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804296:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80429a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429e:	48 be 88 4f 80 00 00 	movabs $0x804f88,%rsi
  8042a5:	00 00 00 
  8042a8:	48 89 c7             	mov    %rax,%rdi
  8042ab:	48 b8 f4 11 80 00 00 	movabs $0x8011f4,%rax
  8042b2:	00 00 00 
  8042b5:	ff d0                	callq  *%rax
	return 0;
  8042b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042bc:	c9                   	leaveq 
  8042bd:	c3                   	retq   
	...

00000000008042c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8042c0:	55                   	push   %rbp
  8042c1:	48 89 e5             	mov    %rsp,%rbp
  8042c4:	48 83 ec 20          	sub    $0x20,%rsp
  8042c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8042cc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042d3:	00 00 00 
  8042d6:	48 8b 00             	mov    (%rax),%rax
  8042d9:	48 85 c0             	test   %rax,%rax
  8042dc:	0f 85 8e 00 00 00    	jne    804370 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8042e2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8042e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8042f0:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  8042f7:	00 00 00 
  8042fa:	ff d0                	callq  *%rax
  8042fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8042ff:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  804303:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804306:	ba 07 00 00 00       	mov    $0x7,%edx
  80430b:	48 89 ce             	mov    %rcx,%rsi
  80430e:	89 c7                	mov    %eax,%edi
  804310:	48 b8 2c 1b 80 00 00 	movabs $0x801b2c,%rax
  804317:	00 00 00 
  80431a:	ff d0                	callq  *%rax
  80431c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80431f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  804323:	74 30                	je     804355 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  804325:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804328:	89 c1                	mov    %eax,%ecx
  80432a:	48 ba 90 4f 80 00 00 	movabs $0x804f90,%rdx
  804331:	00 00 00 
  804334:	be 24 00 00 00       	mov    $0x24,%esi
  804339:	48 bf c7 4f 80 00 00 	movabs $0x804fc7,%rdi
  804340:	00 00 00 
  804343:	b8 00 00 00 00       	mov    $0x0,%eax
  804348:	49 b8 fc 03 80 00 00 	movabs $0x8003fc,%r8
  80434f:	00 00 00 
  804352:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804355:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804358:	48 be 84 43 80 00 00 	movabs $0x804384,%rsi
  80435f:	00 00 00 
  804362:	89 c7                	mov    %eax,%edi
  804364:	48 b8 b6 1c 80 00 00 	movabs $0x801cb6,%rax
  80436b:	00 00 00 
  80436e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804370:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804377:	00 00 00 
  80437a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80437e:	48 89 10             	mov    %rdx,(%rax)
}
  804381:	c9                   	leaveq 
  804382:	c3                   	retq   
	...

0000000000804384 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  804384:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  804387:	48 a1 00 b0 80 00 00 	movabs 0x80b000,%rax
  80438e:	00 00 00 
	call *%rax
  804391:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  804393:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  804397:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80439b:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80439e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8043a5:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8043a6:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8043ab:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8043ae:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8043af:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8043b2:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8043b9:	00 08 
		POPA_						// copy the register contents to the registers
  8043bb:	4c 8b 3c 24          	mov    (%rsp),%r15
  8043bf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8043c4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8043c9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8043ce:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8043d3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8043d8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8043dd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8043e2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8043e7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8043ec:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8043f1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8043f6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8043fb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804400:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804405:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  804409:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  80440d:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80440e:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80440f:	c3                   	retq   

0000000000804410 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804410:	55                   	push   %rbp
  804411:	48 89 e5             	mov    %rsp,%rbp
  804414:	48 83 ec 30          	sub    $0x30,%rsp
  804418:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80441c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804420:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  804424:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804429:	74 18                	je     804443 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80442b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80442f:	48 89 c7             	mov    %rax,%rdi
  804432:	48 b8 55 1d 80 00 00 	movabs $0x801d55,%rax
  804439:	00 00 00 
  80443c:	ff d0                	callq  *%rax
  80443e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804441:	eb 19                	jmp    80445c <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  804443:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80444a:	00 00 00 
  80444d:	48 b8 55 1d 80 00 00 	movabs $0x801d55,%rax
  804454:	00 00 00 
  804457:	ff d0                	callq  *%rax
  804459:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  80445c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804460:	79 19                	jns    80447b <ipc_recv+0x6b>
	{
		*from_env_store=0;
  804462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804466:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  80446c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804470:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  804476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804479:	eb 53                	jmp    8044ce <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80447b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804480:	74 19                	je     80449b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  804482:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  804489:	00 00 00 
  80448c:	48 8b 00             	mov    (%rax),%rax
  80448f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804495:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804499:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80449b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8044a0:	74 19                	je     8044bb <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8044a2:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8044a9:	00 00 00 
  8044ac:	48 8b 00             	mov    (%rax),%rax
  8044af:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8044b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8044bb:	48 b8 48 70 80 00 00 	movabs $0x807048,%rax
  8044c2:	00 00 00 
  8044c5:	48 8b 00             	mov    (%rax),%rax
  8044c8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8044ce:	c9                   	leaveq 
  8044cf:	c3                   	retq   

00000000008044d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8044d0:	55                   	push   %rbp
  8044d1:	48 89 e5             	mov    %rsp,%rbp
  8044d4:	48 83 ec 30          	sub    $0x30,%rsp
  8044d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8044db:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8044de:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8044e2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8044e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8044ec:	e9 96 00 00 00       	jmpq   804587 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8044f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044f6:	74 20                	je     804518 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8044f8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044fb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8044fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804502:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804505:	89 c7                	mov    %eax,%edi
  804507:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  80450e:	00 00 00 
  804511:	ff d0                	callq  *%rax
  804513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804516:	eb 2d                	jmp    804545 <ipc_send+0x75>
		else if(pg==NULL)
  804518:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80451d:	75 26                	jne    804545 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80451f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804522:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804525:	b9 00 00 00 00       	mov    $0x0,%ecx
  80452a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804531:	00 00 00 
  804534:	89 c7                	mov    %eax,%edi
  804536:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  80453d:	00 00 00 
  804540:	ff d0                	callq  *%rax
  804542:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  804545:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804549:	79 30                	jns    80457b <ipc_send+0xab>
  80454b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80454f:	74 2a                	je     80457b <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  804551:	48 ba d5 4f 80 00 00 	movabs $0x804fd5,%rdx
  804558:	00 00 00 
  80455b:	be 40 00 00 00       	mov    $0x40,%esi
  804560:	48 bf ed 4f 80 00 00 	movabs $0x804fed,%rdi
  804567:	00 00 00 
  80456a:	b8 00 00 00 00       	mov    $0x0,%eax
  80456f:	48 b9 fc 03 80 00 00 	movabs $0x8003fc,%rcx
  804576:	00 00 00 
  804579:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80457b:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  804582:	00 00 00 
  804585:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804587:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80458b:	0f 85 60 ff ff ff    	jne    8044f1 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  804591:	c9                   	leaveq 
  804592:	c3                   	retq   

0000000000804593 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804593:	55                   	push   %rbp
  804594:	48 89 e5             	mov    %rsp,%rbp
  804597:	48 83 ec 18          	sub    $0x18,%rsp
  80459b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80459e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045a5:	eb 5e                	jmp    804605 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8045a7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8045ae:	00 00 00 
  8045b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b4:	48 63 d0             	movslq %eax,%rdx
  8045b7:	48 89 d0             	mov    %rdx,%rax
  8045ba:	48 c1 e0 03          	shl    $0x3,%rax
  8045be:	48 01 d0             	add    %rdx,%rax
  8045c1:	48 c1 e0 05          	shl    $0x5,%rax
  8045c5:	48 01 c8             	add    %rcx,%rax
  8045c8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8045ce:	8b 00                	mov    (%rax),%eax
  8045d0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8045d3:	75 2c                	jne    804601 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8045d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8045dc:	00 00 00 
  8045df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e2:	48 63 d0             	movslq %eax,%rdx
  8045e5:	48 89 d0             	mov    %rdx,%rax
  8045e8:	48 c1 e0 03          	shl    $0x3,%rax
  8045ec:	48 01 d0             	add    %rdx,%rax
  8045ef:	48 c1 e0 05          	shl    $0x5,%rax
  8045f3:	48 01 c8             	add    %rcx,%rax
  8045f6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8045fc:	8b 40 08             	mov    0x8(%rax),%eax
  8045ff:	eb 12                	jmp    804613 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  804601:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804605:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80460c:	7e 99                	jle    8045a7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80460e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804613:	c9                   	leaveq 
  804614:	c3                   	retq   
  804615:	00 00                	add    %al,(%rax)
	...

0000000000804618 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804618:	55                   	push   %rbp
  804619:	48 89 e5             	mov    %rsp,%rbp
  80461c:	48 83 ec 18          	sub    $0x18,%rsp
  804620:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804628:	48 89 c2             	mov    %rax,%rdx
  80462b:	48 c1 ea 15          	shr    $0x15,%rdx
  80462f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804636:	01 00 00 
  804639:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80463d:	83 e0 01             	and    $0x1,%eax
  804640:	48 85 c0             	test   %rax,%rax
  804643:	75 07                	jne    80464c <pageref+0x34>
		return 0;
  804645:	b8 00 00 00 00       	mov    $0x0,%eax
  80464a:	eb 53                	jmp    80469f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80464c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804650:	48 89 c2             	mov    %rax,%rdx
  804653:	48 c1 ea 0c          	shr    $0xc,%rdx
  804657:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80465e:	01 00 00 
  804661:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804665:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466d:	83 e0 01             	and    $0x1,%eax
  804670:	48 85 c0             	test   %rax,%rax
  804673:	75 07                	jne    80467c <pageref+0x64>
		return 0;
  804675:	b8 00 00 00 00       	mov    $0x0,%eax
  80467a:	eb 23                	jmp    80469f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80467c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804680:	48 89 c2             	mov    %rax,%rdx
  804683:	48 c1 ea 0c          	shr    $0xc,%rdx
  804687:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80468e:	00 00 00 
  804691:	48 c1 e2 04          	shl    $0x4,%rdx
  804695:	48 01 d0             	add    %rdx,%rax
  804698:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80469c:	0f b7 c0             	movzwl %ax,%eax
}
  80469f:	c9                   	leaveq 
  8046a0:	c3                   	retq   
