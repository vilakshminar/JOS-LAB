
obj/user/testfdsharing.debug:     file format elf64-x86-64


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
  80003c:	e8 fb 02 00 00       	callq  80033c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 20          	sub    $0x20,%rsp
  80004c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800053:	be 00 00 00 00       	mov    $0x0,%esi
  800058:	48 bf 60 47 80 00 00 	movabs $0x804760,%rdi
  80005f:	00 00 00 
  800062:	48 b8 2f 2f 80 00 00 	movabs $0x802f2f,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
  80006e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800071:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800075:	79 30                	jns    8000a7 <umain+0x63>
		panic("open motd: %e", fd);
  800077:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80007a:	89 c1                	mov    %eax,%ecx
  80007c:	48 ba 65 47 80 00 00 	movabs $0x804765,%rdx
  800083:	00 00 00 
  800086:	be 0c 00 00 00       	mov    $0xc,%esi
  80008b:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  800092:	00 00 00 
  800095:	b8 00 00 00 00       	mov    $0x0,%eax
  80009a:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8000a1:	00 00 00 
  8000a4:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000aa:	be 00 00 00 00       	mov    $0x0,%esi
  8000af:	89 c7                	mov    %eax,%edi
  8000b1:	48 b8 76 2c 80 00 00 	movabs $0x802c76,%rax
  8000b8:	00 00 00 
  8000bb:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c0:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c5:	48 be 60 82 80 00 00 	movabs $0x808260,%rsi
  8000cc:	00 00 00 
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  8000d8:	00 00 00 
  8000db:	ff d0                	callq  *%rax
  8000dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e4:	7f 30                	jg     800116 <umain+0xd2>
		panic("readn: %e", n);
  8000e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e9:	89 c1                	mov    %eax,%ecx
  8000eb:	48 ba 88 47 80 00 00 	movabs $0x804788,%rdx
  8000f2:	00 00 00 
  8000f5:	be 0f 00 00 00       	mov    $0xf,%esi
  8000fa:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  800101:	00 00 00 
  800104:	b8 00 00 00 00       	mov    $0x0,%eax
  800109:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  800110:	00 00 00 
  800113:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800116:	48 b8 0b 22 80 00 00 	movabs $0x80220b,%rax
  80011d:	00 00 00 
  800120:	ff d0                	callq  *%rax
  800122:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800125:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800129:	79 30                	jns    80015b <umain+0x117>
		panic("fork: %e", r);
  80012b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012e:	89 c1                	mov    %eax,%ecx
  800130:	48 ba 92 47 80 00 00 	movabs $0x804792,%rdx
  800137:	00 00 00 
  80013a:	be 12 00 00 00       	mov    $0x12,%esi
  80013f:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  800146:	00 00 00 
  800149:	b8 00 00 00 00       	mov    $0x0,%eax
  80014e:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  800155:	00 00 00 
  800158:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015f:	0f 85 36 01 00 00    	jne    80029b <umain+0x257>
		seek(fd, 0);
  800165:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800168:	be 00 00 00 00       	mov    $0x0,%esi
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	48 b8 76 2c 80 00 00 	movabs $0x802c76,%rax
  800176:	00 00 00 
  800179:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017b:	48 bf a0 47 80 00 00 	movabs $0x8047a0,%rdi
  800182:	00 00 00 
  800185:	b8 00 00 00 00       	mov    $0x0,%eax
  80018a:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800191:	00 00 00 
  800194:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800199:	ba 00 02 00 00       	mov    $0x200,%edx
  80019e:	48 be 60 80 80 00 00 	movabs $0x808060,%rsi
  8001a5:	00 00 00 
  8001a8:	89 c7                	mov    %eax,%edi
  8001aa:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  8001b1:	00 00 00 
  8001b4:	ff d0                	callq  *%rax
  8001b6:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bc:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001bf:	74 36                	je     8001f7 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c7:	41 89 d0             	mov    %edx,%r8d
  8001ca:	89 c1                	mov    %eax,%ecx
  8001cc:	48 ba e8 47 80 00 00 	movabs $0x8047e8,%rdx
  8001d3:	00 00 00 
  8001d6:	be 17 00 00 00       	mov    $0x17,%esi
  8001db:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  8001e2:	00 00 00 
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	49 b9 04 04 80 00 00 	movabs $0x800404,%r9
  8001f1:	00 00 00 
  8001f4:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001fa:	48 98                	cltq   
  8001fc:	48 89 c2             	mov    %rax,%rdx
  8001ff:	48 be 60 80 80 00 00 	movabs $0x808060,%rsi
  800206:	00 00 00 
  800209:	48 bf 60 82 80 00 00 	movabs $0x808260,%rdi
  800210:	00 00 00 
  800213:	48 b8 69 16 80 00 00 	movabs $0x801669,%rax
  80021a:	00 00 00 
  80021d:	ff d0                	callq  *%rax
  80021f:	85 c0                	test   %eax,%eax
  800221:	74 2a                	je     80024d <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800223:	48 ba 18 48 80 00 00 	movabs $0x804818,%rdx
  80022a:	00 00 00 
  80022d:	be 19 00 00 00       	mov    $0x19,%esi
  800232:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  800239:	00 00 00 
  80023c:	b8 00 00 00 00       	mov    $0x0,%eax
  800241:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  800248:	00 00 00 
  80024b:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024d:	48 bf 4e 48 80 00 00 	movabs $0x80484e,%rdi
  800254:	00 00 00 
  800257:	b8 00 00 00 00       	mov    $0x0,%eax
  80025c:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800263:	00 00 00 
  800266:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	89 c7                	mov    %eax,%edi
  800272:	48 b8 76 2c 80 00 00 	movabs $0x802c76,%rax
  800279:	00 00 00 
  80027c:	ff d0                	callq  *%rax
		close(fd);
  80027e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800281:	89 c7                	mov    %eax,%edi
  800283:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  80028a:	00 00 00 
  80028d:	ff d0                	callq  *%rax
		exit();
  80028f:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
	}
	wait(r);
  80029b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029e:	89 c7                	mov    %eax,%edi
  8002a0:	48 b8 14 40 80 00 00 	movabs $0x804014,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002af:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b4:	48 be 60 80 80 00 00 	movabs $0x808060,%rsi
  8002bb:	00 00 00 
  8002be:	89 c7                	mov    %eax,%edi
  8002c0:	48 b8 29 2b 80 00 00 	movabs $0x802b29,%rax
  8002c7:	00 00 00 
  8002ca:	ff d0                	callq  *%rax
  8002cc:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002cf:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d2:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d5:	74 36                	je     80030d <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d7:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dd:	41 89 d0             	mov    %edx,%r8d
  8002e0:	89 c1                	mov    %eax,%ecx
  8002e2:	48 ba 68 48 80 00 00 	movabs $0x804868,%rdx
  8002e9:	00 00 00 
  8002ec:	be 21 00 00 00       	mov    $0x21,%esi
  8002f1:	48 bf 73 47 80 00 00 	movabs $0x804773,%rdi
  8002f8:	00 00 00 
  8002fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800300:	49 b9 04 04 80 00 00 	movabs $0x800404,%r9
  800307:	00 00 00 
  80030a:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030d:	48 bf 8b 48 80 00 00 	movabs $0x80488b,%rdi
  800314:	00 00 00 
  800317:	b8 00 00 00 00       	mov    $0x0,%eax
  80031c:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800323:	00 00 00 
  800326:	ff d2                	callq  *%rdx
	close(fd);
  800328:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032b:	89 c7                	mov    %eax,%edi
  80032d:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  800334:	00 00 00 
  800337:	ff d0                	callq  *%rax
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800339:	cc                   	int3   

	breakpoint();
}
  80033a:	c9                   	leaveq 
  80033b:	c3                   	retq   

000000000080033c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033c:	55                   	push   %rbp
  80033d:	48 89 e5             	mov    %rsp,%rbp
  800340:	48 83 ec 10          	sub    $0x10,%rsp
  800344:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800347:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80034b:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  800352:	00 00 00 
  800355:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  80035c:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  800363:	00 00 00 
  800366:	ff d0                	callq  *%rax
  800368:	48 98                	cltq   
  80036a:	48 89 c2             	mov    %rax,%rdx
  80036d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  800373:	48 89 d0             	mov    %rdx,%rax
  800376:	48 c1 e0 03          	shl    $0x3,%rax
  80037a:	48 01 d0             	add    %rdx,%rax
  80037d:	48 c1 e0 05          	shl    $0x5,%rax
  800381:	48 89 c2             	mov    %rax,%rdx
  800384:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80038b:	00 00 00 
  80038e:	48 01 c2             	add    %rax,%rdx
  800391:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  800398:	00 00 00 
  80039b:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80039e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003a2:	7e 14                	jle    8003b8 <libmain+0x7c>
		binaryname = argv[0];
  8003a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a8:	48 8b 10             	mov    (%rax),%rdx
  8003ab:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8003b2:	00 00 00 
  8003b5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8003b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bf:	48 89 d6             	mov    %rdx,%rsi
  8003c2:	89 c7                	mov    %eax,%edi
  8003c4:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8003cb:	00 00 00 
  8003ce:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003d0:	48 b8 e0 03 80 00 00 	movabs $0x8003e0,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
}
  8003dc:	c9                   	leaveq 
  8003dd:	c3                   	retq   
	...

00000000008003e0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003e0:	55                   	push   %rbp
  8003e1:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8003e4:	48 b8 79 28 80 00 00 	movabs $0x802879,%rax
  8003eb:	00 00 00 
  8003ee:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8003f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8003f5:	48 b8 74 1a 80 00 00 	movabs $0x801a74,%rax
  8003fc:	00 00 00 
  8003ff:	ff d0                	callq  *%rax
}
  800401:	5d                   	pop    %rbp
  800402:	c3                   	retq   
	...

0000000000800404 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800404:	55                   	push   %rbp
  800405:	48 89 e5             	mov    %rsp,%rbp
  800408:	53                   	push   %rbx
  800409:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800410:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800417:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80041d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800424:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80042b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800432:	84 c0                	test   %al,%al
  800434:	74 23                	je     800459 <_panic+0x55>
  800436:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80043d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800441:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800445:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800449:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80044d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800451:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800455:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800459:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800460:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800467:	00 00 00 
  80046a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800471:	00 00 00 
  800474:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800478:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80047f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800486:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80048d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800494:	00 00 00 
  800497:	48 8b 18             	mov    (%rax),%rbx
  80049a:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8004a1:	00 00 00 
  8004a4:	ff d0                	callq  *%rax
  8004a6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8004ac:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8004b3:	41 89 c8             	mov    %ecx,%r8d
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 da             	mov    %rbx,%rdx
  8004bc:	89 c6                	mov    %eax,%esi
  8004be:	48 bf b0 48 80 00 00 	movabs $0x8048b0,%rdi
  8004c5:	00 00 00 
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cd:	49 b9 3f 06 80 00 00 	movabs $0x80063f,%r9
  8004d4:	00 00 00 
  8004d7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004da:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004e1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004e8:	48 89 d6             	mov    %rdx,%rsi
  8004eb:	48 89 c7             	mov    %rax,%rdi
  8004ee:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  8004f5:	00 00 00 
  8004f8:	ff d0                	callq  *%rax
	cprintf("\n");
  8004fa:	48 bf d3 48 80 00 00 	movabs $0x8048d3,%rdi
  800501:	00 00 00 
  800504:	b8 00 00 00 00       	mov    $0x0,%eax
  800509:	48 ba 3f 06 80 00 00 	movabs $0x80063f,%rdx
  800510:	00 00 00 
  800513:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800515:	cc                   	int3   
  800516:	eb fd                	jmp    800515 <_panic+0x111>

0000000000800518 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 83 ec 10          	sub    $0x10,%rsp
  800520:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800523:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80052b:	8b 00                	mov    (%rax),%eax
  80052d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800530:	89 d6                	mov    %edx,%esi
  800532:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800536:	48 63 d0             	movslq %eax,%rdx
  800539:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  80053e:	8d 50 01             	lea    0x1(%rax),%edx
  800541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800545:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80054b:	8b 00                	mov    (%rax),%eax
  80054d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800552:	75 2c                	jne    800580 <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800554:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800558:	8b 00                	mov    (%rax),%eax
  80055a:	48 98                	cltq   
  80055c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800560:	48 83 c2 08          	add    $0x8,%rdx
  800564:	48 89 c6             	mov    %rax,%rsi
  800567:	48 89 d7             	mov    %rdx,%rdi
  80056a:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  800571:	00 00 00 
  800574:	ff d0                	callq  *%rax
		b->idx = 0;
  800576:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80057a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800580:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800584:	8b 40 04             	mov    0x4(%rax),%eax
  800587:	8d 50 01             	lea    0x1(%rax),%edx
  80058a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800591:	c9                   	leaveq 
  800592:	c3                   	retq   

0000000000800593 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800593:	55                   	push   %rbp
  800594:	48 89 e5             	mov    %rsp,%rbp
  800597:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80059e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8005a5:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8005ac:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8005b3:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8005ba:	48 8b 0a             	mov    (%rdx),%rcx
  8005bd:	48 89 08             	mov    %rcx,(%rax)
  8005c0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005c4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005c8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005cc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8005e4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005eb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005f2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005f9:	48 89 c6             	mov    %rax,%rsi
  8005fc:	48 bf 18 05 80 00 00 	movabs $0x800518,%rdi
  800603:	00 00 00 
  800606:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800612:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800618:	48 98                	cltq   
  80061a:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800621:	48 83 c2 08          	add    $0x8,%rdx
  800625:	48 89 c6             	mov    %rax,%rsi
  800628:	48 89 d7             	mov    %rdx,%rdi
  80062b:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
  800632:	00 00 00 
  800635:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800637:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80063d:	c9                   	leaveq 
  80063e:	c3                   	retq   

000000000080063f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80063f:	55                   	push   %rbp
  800640:	48 89 e5             	mov    %rsp,%rbp
  800643:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80064a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800651:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800658:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80065f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800666:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80066d:	84 c0                	test   %al,%al
  80066f:	74 20                	je     800691 <cprintf+0x52>
  800671:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800675:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800679:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80067d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800681:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800685:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800689:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80068d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800691:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800698:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80069f:	00 00 00 
  8006a2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8006a9:	00 00 00 
  8006ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006b0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8006b7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8006be:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8006c5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006cc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006d3:	48 8b 0a             	mov    (%rdx),%rcx
  8006d6:	48 89 08             	mov    %rcx,(%rax)
  8006d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8006e9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006f0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006f7:	48 89 d6             	mov    %rdx,%rsi
  8006fa:	48 89 c7             	mov    %rax,%rdi
  8006fd:	48 b8 93 05 80 00 00 	movabs $0x800593,%rax
  800704:	00 00 00 
  800707:	ff d0                	callq  *%rax
  800709:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80070f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800715:	c9                   	leaveq 
  800716:	c3                   	retq   
	...

0000000000800718 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800718:	55                   	push   %rbp
  800719:	48 89 e5             	mov    %rsp,%rbp
  80071c:	48 83 ec 30          	sub    $0x30,%rsp
  800720:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800724:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800728:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80072c:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80072f:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800733:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800737:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80073a:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80073e:	77 52                	ja     800792 <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800740:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800743:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800747:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80074a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80074e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
  800757:	48 f7 75 d0          	divq   -0x30(%rbp)
  80075b:	48 89 c2             	mov    %rax,%rdx
  80075e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800761:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800764:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80076c:	41 89 f9             	mov    %edi,%r9d
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	eb 1c                	jmp    80079c <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800780:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800784:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800787:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80078b:	48 89 d6             	mov    %rdx,%rsi
  80078e:	89 c7                	mov    %eax,%edi
  800790:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800792:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800796:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80079a:	7f e4                	jg     800780 <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a8:	48 f7 f1             	div    %rcx
  8007ab:	48 89 d0             	mov    %rdx,%rax
  8007ae:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  8007b5:	00 00 00 
  8007b8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8007bc:	0f be c0             	movsbl %al,%eax
  8007bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007c3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8007c7:	48 89 d6             	mov    %rdx,%rsi
  8007ca:	89 c7                	mov    %eax,%edi
  8007cc:	ff d1                	callq  *%rcx
}
  8007ce:	c9                   	leaveq 
  8007cf:	c3                   	retq   

00000000008007d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007d0:	55                   	push   %rbp
  8007d1:	48 89 e5             	mov    %rsp,%rbp
  8007d4:	48 83 ec 20          	sub    $0x20,%rsp
  8007d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007e3:	7e 52                	jle    800837 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e9:	8b 00                	mov    (%rax),%eax
  8007eb:	83 f8 30             	cmp    $0x30,%eax
  8007ee:	73 24                	jae    800814 <getuint+0x44>
  8007f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	8b 00                	mov    (%rax),%eax
  8007fe:	89 c0                	mov    %eax,%eax
  800800:	48 01 d0             	add    %rdx,%rax
  800803:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800807:	8b 12                	mov    (%rdx),%edx
  800809:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800810:	89 0a                	mov    %ecx,(%rdx)
  800812:	eb 17                	jmp    80082b <getuint+0x5b>
  800814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800818:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081c:	48 89 d0             	mov    %rdx,%rax
  80081f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800823:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800827:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082b:	48 8b 00             	mov    (%rax),%rax
  80082e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800832:	e9 a3 00 00 00       	jmpq   8008da <getuint+0x10a>
	else if (lflag)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80083b:	74 4f                	je     80088c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80083d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800841:	8b 00                	mov    (%rax),%eax
  800843:	83 f8 30             	cmp    $0x30,%eax
  800846:	73 24                	jae    80086c <getuint+0x9c>
  800848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	8b 00                	mov    (%rax),%eax
  800856:	89 c0                	mov    %eax,%eax
  800858:	48 01 d0             	add    %rdx,%rax
  80085b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085f:	8b 12                	mov    (%rdx),%edx
  800861:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	89 0a                	mov    %ecx,(%rdx)
  80086a:	eb 17                	jmp    800883 <getuint+0xb3>
  80086c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800870:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800874:	48 89 d0             	mov    %rdx,%rax
  800877:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80087b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80087f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800883:	48 8b 00             	mov    (%rax),%rax
  800886:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80088a:	eb 4e                	jmp    8008da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	8b 00                	mov    (%rax),%eax
  800892:	83 f8 30             	cmp    $0x30,%eax
  800895:	73 24                	jae    8008bb <getuint+0xeb>
  800897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	89 c0                	mov    %eax,%eax
  8008a7:	48 01 d0             	add    %rdx,%rax
  8008aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ae:	8b 12                	mov    (%rdx),%edx
  8008b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b7:	89 0a                	mov    %ecx,(%rdx)
  8008b9:	eb 17                	jmp    8008d2 <getuint+0x102>
  8008bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008c3:	48 89 d0             	mov    %rdx,%rax
  8008c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008d2:	8b 00                	mov    (%rax),%eax
  8008d4:	89 c0                	mov    %eax,%eax
  8008d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008de:	c9                   	leaveq 
  8008df:	c3                   	retq   

00000000008008e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e0:	55                   	push   %rbp
  8008e1:	48 89 e5             	mov    %rsp,%rbp
  8008e4:	48 83 ec 20          	sub    $0x20,%rsp
  8008e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f3:	7e 52                	jle    800947 <getint+0x67>
		x=va_arg(*ap, long long);
  8008f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f9:	8b 00                	mov    (%rax),%eax
  8008fb:	83 f8 30             	cmp    $0x30,%eax
  8008fe:	73 24                	jae    800924 <getint+0x44>
  800900:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800904:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800908:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090c:	8b 00                	mov    (%rax),%eax
  80090e:	89 c0                	mov    %eax,%eax
  800910:	48 01 d0             	add    %rdx,%rax
  800913:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800917:	8b 12                	mov    (%rdx),%edx
  800919:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800920:	89 0a                	mov    %ecx,(%rdx)
  800922:	eb 17                	jmp    80093b <getint+0x5b>
  800924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800928:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092c:	48 89 d0             	mov    %rdx,%rax
  80092f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800937:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093b:	48 8b 00             	mov    (%rax),%rax
  80093e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800942:	e9 a3 00 00 00       	jmpq   8009ea <getint+0x10a>
	else if (lflag)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094b:	74 4f                	je     80099c <getint+0xbc>
		x=va_arg(*ap, long);
  80094d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800951:	8b 00                	mov    (%rax),%eax
  800953:	83 f8 30             	cmp    $0x30,%eax
  800956:	73 24                	jae    80097c <getint+0x9c>
  800958:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800960:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800964:	8b 00                	mov    (%rax),%eax
  800966:	89 c0                	mov    %eax,%eax
  800968:	48 01 d0             	add    %rdx,%rax
  80096b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096f:	8b 12                	mov    (%rdx),%edx
  800971:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800978:	89 0a                	mov    %ecx,(%rdx)
  80097a:	eb 17                	jmp    800993 <getint+0xb3>
  80097c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800980:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800984:	48 89 d0             	mov    %rdx,%rax
  800987:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800993:	48 8b 00             	mov    (%rax),%rax
  800996:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80099a:	eb 4e                	jmp    8009ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80099c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a0:	8b 00                	mov    (%rax),%eax
  8009a2:	83 f8 30             	cmp    $0x30,%eax
  8009a5:	73 24                	jae    8009cb <getint+0xeb>
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b3:	8b 00                	mov    (%rax),%eax
  8009b5:	89 c0                	mov    %eax,%eax
  8009b7:	48 01 d0             	add    %rdx,%rax
  8009ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009be:	8b 12                	mov    (%rdx),%edx
  8009c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c7:	89 0a                	mov    %ecx,(%rdx)
  8009c9:	eb 17                	jmp    8009e2 <getint+0x102>
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d3:	48 89 d0             	mov    %rdx,%rax
  8009d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e2:	8b 00                	mov    (%rax),%eax
  8009e4:	48 98                	cltq   
  8009e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ee:	c9                   	leaveq 
  8009ef:	c3                   	retq   

00000000008009f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009f0:	55                   	push   %rbp
  8009f1:	48 89 e5             	mov    %rsp,%rbp
  8009f4:	41 54                	push   %r12
  8009f6:	53                   	push   %rbx
  8009f7:	48 83 ec 60          	sub    $0x60,%rsp
  8009fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800a03:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a07:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800a0b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a0f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800a13:	48 8b 0a             	mov    (%rdx),%rcx
  800a16:	48 89 08             	mov    %rcx,(%rax)
  800a19:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800a1d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800a21:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a25:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a29:	eb 17                	jmp    800a42 <vprintfmt+0x52>
			if (ch == '\0')
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	0f 84 d7 04 00 00    	je     800f0a <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800a33:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800a37:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800a3b:	48 89 c6             	mov    %rax,%rsi
  800a3e:	89 df                	mov    %ebx,%edi
  800a40:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a42:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a46:	0f b6 00             	movzbl (%rax),%eax
  800a49:	0f b6 d8             	movzbl %al,%ebx
  800a4c:	83 fb 25             	cmp    $0x25,%ebx
  800a4f:	0f 95 c0             	setne  %al
  800a52:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a57:	84 c0                	test   %al,%al
  800a59:	75 d0                	jne    800a2b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a5b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a5f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a66:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800a7b:	eb 04                	jmp    800a81 <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800a7d:	90                   	nop
  800a7e:	eb 01                	jmp    800a81 <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800a80:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a81:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a85:	0f b6 00             	movzbl (%rax),%eax
  800a88:	0f b6 d8             	movzbl %al,%ebx
  800a8b:	89 d8                	mov    %ebx,%eax
  800a8d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800a92:	83 e8 23             	sub    $0x23,%eax
  800a95:	83 f8 55             	cmp    $0x55,%eax
  800a98:	0f 87 38 04 00 00    	ja     800ed6 <vprintfmt+0x4e6>
  800a9e:	89 c0                	mov    %eax,%eax
  800aa0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800aa7:	00 
  800aa8:	48 b8 d0 4a 80 00 00 	movabs $0x804ad0,%rax
  800aaf:	00 00 00 
  800ab2:	48 01 d0             	add    %rdx,%rax
  800ab5:	48 8b 00             	mov    (%rax),%rax
  800ab8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800aba:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800abe:	eb c1                	jmp    800a81 <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ac4:	eb bb                	jmp    800a81 <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800acd:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ad0:	89 d0                	mov    %edx,%eax
  800ad2:	c1 e0 02             	shl    $0x2,%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	01 c0                	add    %eax,%eax
  800ad9:	01 d8                	add    %ebx,%eax
  800adb:	83 e8 30             	sub    $0x30,%eax
  800ade:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ae1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ae5:	0f b6 00             	movzbl (%rax),%eax
  800ae8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aeb:	83 fb 2f             	cmp    $0x2f,%ebx
  800aee:	7e 63                	jle    800b53 <vprintfmt+0x163>
  800af0:	83 fb 39             	cmp    $0x39,%ebx
  800af3:	7f 5e                	jg     800b53 <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800af5:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800afa:	eb d1                	jmp    800acd <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800afc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aff:	83 f8 30             	cmp    $0x30,%eax
  800b02:	73 17                	jae    800b1b <vprintfmt+0x12b>
  800b04:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b08:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b0b:	89 c0                	mov    %eax,%eax
  800b0d:	48 01 d0             	add    %rdx,%rax
  800b10:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b13:	83 c2 08             	add    $0x8,%edx
  800b16:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b19:	eb 0f                	jmp    800b2a <vprintfmt+0x13a>
  800b1b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b1f:	48 89 d0             	mov    %rdx,%rax
  800b22:	48 83 c2 08          	add    $0x8,%rdx
  800b26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b2a:	8b 00                	mov    (%rax),%eax
  800b2c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b2f:	eb 23                	jmp    800b54 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  800b31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b35:	0f 89 42 ff ff ff    	jns    800a7d <vprintfmt+0x8d>
				width = 0;
  800b3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b42:	e9 36 ff ff ff       	jmpq   800a7d <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  800b47:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b4e:	e9 2e ff ff ff       	jmpq   800a81 <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b53:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b54:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b58:	0f 89 22 ff ff ff    	jns    800a80 <vprintfmt+0x90>
				width = precision, precision = -1;
  800b5e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b61:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b64:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b6b:	e9 10 ff ff ff       	jmpq   800a80 <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b70:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b74:	e9 08 ff ff ff       	jmpq   800a81 <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b7c:	83 f8 30             	cmp    $0x30,%eax
  800b7f:	73 17                	jae    800b98 <vprintfmt+0x1a8>
  800b81:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b88:	89 c0                	mov    %eax,%eax
  800b8a:	48 01 d0             	add    %rdx,%rax
  800b8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b90:	83 c2 08             	add    $0x8,%edx
  800b93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b96:	eb 0f                	jmp    800ba7 <vprintfmt+0x1b7>
  800b98:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b9c:	48 89 d0             	mov    %rdx,%rax
  800b9f:	48 83 c2 08          	add    $0x8,%rdx
  800ba3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ba7:	8b 00                	mov    (%rax),%eax
  800ba9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bad:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800bb1:	48 89 d6             	mov    %rdx,%rsi
  800bb4:	89 c7                	mov    %eax,%edi
  800bb6:	ff d1                	callq  *%rcx
			break;
  800bb8:	e9 47 03 00 00       	jmpq   800f04 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800bbd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc0:	83 f8 30             	cmp    $0x30,%eax
  800bc3:	73 17                	jae    800bdc <vprintfmt+0x1ec>
  800bc5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bc9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcc:	89 c0                	mov    %eax,%eax
  800bce:	48 01 d0             	add    %rdx,%rax
  800bd1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd4:	83 c2 08             	add    $0x8,%edx
  800bd7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bda:	eb 0f                	jmp    800beb <vprintfmt+0x1fb>
  800bdc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be0:	48 89 d0             	mov    %rdx,%rax
  800be3:	48 83 c2 08          	add    $0x8,%rdx
  800be7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800beb:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	79 02                	jns    800bf3 <vprintfmt+0x203>
				err = -err;
  800bf1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bf3:	83 fb 10             	cmp    $0x10,%ebx
  800bf6:	7f 16                	jg     800c0e <vprintfmt+0x21e>
  800bf8:	48 b8 20 4a 80 00 00 	movabs $0x804a20,%rax
  800bff:	00 00 00 
  800c02:	48 63 d3             	movslq %ebx,%rdx
  800c05:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800c09:	4d 85 e4             	test   %r12,%r12
  800c0c:	75 2e                	jne    800c3c <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  800c0e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c12:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c16:	89 d9                	mov    %ebx,%ecx
  800c18:	48 ba b9 4a 80 00 00 	movabs $0x804ab9,%rdx
  800c1f:	00 00 00 
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2a:	49 b8 14 0f 80 00 00 	movabs $0x800f14,%r8
  800c31:	00 00 00 
  800c34:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c37:	e9 c8 02 00 00       	jmpq   800f04 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c3c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c44:	4c 89 e1             	mov    %r12,%rcx
  800c47:	48 ba c2 4a 80 00 00 	movabs $0x804ac2,%rdx
  800c4e:	00 00 00 
  800c51:	48 89 c7             	mov    %rax,%rdi
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
  800c59:	49 b8 14 0f 80 00 00 	movabs $0x800f14,%r8
  800c60:	00 00 00 
  800c63:	41 ff d0             	callq  *%r8
			break;
  800c66:	e9 99 02 00 00       	jmpq   800f04 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c6e:	83 f8 30             	cmp    $0x30,%eax
  800c71:	73 17                	jae    800c8a <vprintfmt+0x29a>
  800c73:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c77:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7a:	89 c0                	mov    %eax,%eax
  800c7c:	48 01 d0             	add    %rdx,%rax
  800c7f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c82:	83 c2 08             	add    $0x8,%edx
  800c85:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c88:	eb 0f                	jmp    800c99 <vprintfmt+0x2a9>
  800c8a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c8e:	48 89 d0             	mov    %rdx,%rax
  800c91:	48 83 c2 08          	add    $0x8,%rdx
  800c95:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c99:	4c 8b 20             	mov    (%rax),%r12
  800c9c:	4d 85 e4             	test   %r12,%r12
  800c9f:	75 0a                	jne    800cab <vprintfmt+0x2bb>
				p = "(null)";
  800ca1:	49 bc c5 4a 80 00 00 	movabs $0x804ac5,%r12
  800ca8:	00 00 00 
			if (width > 0 && padc != '-')
  800cab:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800caf:	7e 7a                	jle    800d2b <vprintfmt+0x33b>
  800cb1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800cb5:	74 74                	je     800d2b <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cb7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800cba:	48 98                	cltq   
  800cbc:	48 89 c6             	mov    %rax,%rsi
  800cbf:	4c 89 e7             	mov    %r12,%rdi
  800cc2:	48 b8 be 11 80 00 00 	movabs $0x8011be,%rax
  800cc9:	00 00 00 
  800ccc:	ff d0                	callq  *%rax
  800cce:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cd1:	eb 17                	jmp    800cea <vprintfmt+0x2fa>
					putch(padc, putdat);
  800cd3:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  800cd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdb:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  800cdf:	48 89 d6             	mov    %rdx,%rsi
  800ce2:	89 c7                	mov    %eax,%edi
  800ce4:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cea:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cee:	7f e3                	jg     800cd3 <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cf0:	eb 39                	jmp    800d2b <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  800cf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800cf6:	74 1e                	je     800d16 <vprintfmt+0x326>
  800cf8:	83 fb 1f             	cmp    $0x1f,%ebx
  800cfb:	7e 05                	jle    800d02 <vprintfmt+0x312>
  800cfd:	83 fb 7e             	cmp    $0x7e,%ebx
  800d00:	7e 14                	jle    800d16 <vprintfmt+0x326>
					putch('?', putdat);
  800d02:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d06:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d0a:	48 89 c6             	mov    %rax,%rsi
  800d0d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800d12:	ff d2                	callq  *%rdx
  800d14:	eb 0f                	jmp    800d25 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  800d16:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d1a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d1e:	48 89 c6             	mov    %rax,%rsi
  800d21:	89 df                	mov    %ebx,%edi
  800d23:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d25:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d29:	eb 01                	jmp    800d2c <vprintfmt+0x33c>
  800d2b:	90                   	nop
  800d2c:	41 0f b6 04 24       	movzbl (%r12),%eax
  800d31:	0f be d8             	movsbl %al,%ebx
  800d34:	85 db                	test   %ebx,%ebx
  800d36:	0f 95 c0             	setne  %al
  800d39:	49 83 c4 01          	add    $0x1,%r12
  800d3d:	84 c0                	test   %al,%al
  800d3f:	74 28                	je     800d69 <vprintfmt+0x379>
  800d41:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d45:	78 ab                	js     800cf2 <vprintfmt+0x302>
  800d47:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d4b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d4f:	79 a1                	jns    800cf2 <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d51:	eb 16                	jmp    800d69 <vprintfmt+0x379>
				putch(' ', putdat);
  800d53:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d57:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800d5b:	48 89 c6             	mov    %rax,%rsi
  800d5e:	bf 20 00 00 00       	mov    $0x20,%edi
  800d63:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d65:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d69:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d6d:	7f e4                	jg     800d53 <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  800d6f:	e9 90 01 00 00       	jmpq   800f04 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d74:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d78:	be 03 00 00 00       	mov    $0x3,%esi
  800d7d:	48 89 c7             	mov    %rax,%rdi
  800d80:	48 b8 e0 08 80 00 00 	movabs $0x8008e0,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	callq  *%rax
  800d8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d94:	48 85 c0             	test   %rax,%rax
  800d97:	79 1d                	jns    800db6 <vprintfmt+0x3c6>
				putch('-', putdat);
  800d99:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800d9d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800da1:	48 89 c6             	mov    %rax,%rsi
  800da4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800da9:	ff d2                	callq  *%rdx
				num = -(long long) num;
  800dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800daf:	48 f7 d8             	neg    %rax
  800db2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800db6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dbd:	e9 d5 00 00 00       	jmpq   800e97 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800dc2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc6:	be 03 00 00 00       	mov    $0x3,%esi
  800dcb:	48 89 c7             	mov    %rax,%rdi
  800dce:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800dd5:	00 00 00 
  800dd8:	ff d0                	callq  *%rax
  800dda:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dde:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800de5:	e9 ad 00 00 00       	jmpq   800e97 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  800dea:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dee:	be 03 00 00 00       	mov    $0x3,%esi
  800df3:	48 89 c7             	mov    %rax,%rdi
  800df6:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800dfd:	00 00 00 
  800e00:	ff d0                	callq  *%rax
  800e02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  800e06:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e0d:	e9 85 00 00 00       	jmpq   800e97 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  800e12:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e16:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e1a:	48 89 c6             	mov    %rax,%rsi
  800e1d:	bf 30 00 00 00       	mov    $0x30,%edi
  800e22:	ff d2                	callq  *%rdx
			putch('x', putdat);
  800e24:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800e28:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800e2c:	48 89 c6             	mov    %rax,%rsi
  800e2f:	bf 78 00 00 00       	mov    $0x78,%edi
  800e34:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e36:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e39:	83 f8 30             	cmp    $0x30,%eax
  800e3c:	73 17                	jae    800e55 <vprintfmt+0x465>
  800e3e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e42:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e45:	89 c0                	mov    %eax,%eax
  800e47:	48 01 d0             	add    %rdx,%rax
  800e4a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e4d:	83 c2 08             	add    $0x8,%edx
  800e50:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e53:	eb 0f                	jmp    800e64 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  800e55:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e59:	48 89 d0             	mov    %rdx,%rax
  800e5c:	48 83 c2 08          	add    $0x8,%rdx
  800e60:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e64:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e67:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e6b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e72:	eb 23                	jmp    800e97 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e74:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e78:	be 03 00 00 00       	mov    $0x3,%esi
  800e7d:	48 89 c7             	mov    %rax,%rdi
  800e80:	48 b8 d0 07 80 00 00 	movabs $0x8007d0,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
  800e8c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e90:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e97:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e9c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e9f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ea2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ea6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800eaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eae:	45 89 c1             	mov    %r8d,%r9d
  800eb1:	41 89 f8             	mov    %edi,%r8d
  800eb4:	48 89 c7             	mov    %rax,%rdi
  800eb7:	48 b8 18 07 80 00 00 	movabs $0x800718,%rax
  800ebe:	00 00 00 
  800ec1:	ff d0                	callq  *%rax
			break;
  800ec3:	eb 3f                	jmp    800f04 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800ec9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ecd:	48 89 c6             	mov    %rax,%rsi
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	ff d2                	callq  *%rdx
			break;
  800ed4:	eb 2e                	jmp    800f04 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800eda:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800ede:	48 89 c6             	mov    %rax,%rsi
  800ee1:	bf 25 00 00 00       	mov    $0x25,%edi
  800ee6:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800eed:	eb 05                	jmp    800ef4 <vprintfmt+0x504>
  800eef:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ef4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ef8:	48 83 e8 01          	sub    $0x1,%rax
  800efc:	0f b6 00             	movzbl (%rax),%eax
  800eff:	3c 25                	cmp    $0x25,%al
  800f01:	75 ec                	jne    800eef <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  800f03:	90                   	nop
		}
	}
  800f04:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f05:	e9 38 fb ff ff       	jmpq   800a42 <vprintfmt+0x52>
			if (ch == '\0')
				return;
  800f0a:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  800f0b:	48 83 c4 60          	add    $0x60,%rsp
  800f0f:	5b                   	pop    %rbx
  800f10:	41 5c                	pop    %r12
  800f12:	5d                   	pop    %rbp
  800f13:	c3                   	retq   

0000000000800f14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f14:	55                   	push   %rbp
  800f15:	48 89 e5             	mov    %rsp,%rbp
  800f18:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f1f:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f26:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f2d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f34:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f3b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f42:	84 c0                	test   %al,%al
  800f44:	74 20                	je     800f66 <printfmt+0x52>
  800f46:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f4a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f4e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f52:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f56:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f5a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f5e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f62:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f66:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f6d:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f74:	00 00 00 
  800f77:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f7e:	00 00 00 
  800f81:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f85:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f8c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f93:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800f9a:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fa1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fa8:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800faf:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fb6:	48 89 c7             	mov    %rax,%rdi
  800fb9:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  800fc0:	00 00 00 
  800fc3:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 10          	sub    $0x10,%rsp
  800fcf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fd2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fda:	8b 40 10             	mov    0x10(%rax),%eax
  800fdd:	8d 50 01             	lea    0x1(%rax),%edx
  800fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe4:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800feb:	48 8b 10             	mov    (%rax),%rdx
  800fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff2:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ff6:	48 39 c2             	cmp    %rax,%rdx
  800ff9:	73 17                	jae    801012 <sprintputch+0x4b>
		*b->buf++ = ch;
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 8b 00             	mov    (%rax),%rax
  801002:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801005:	88 10                	mov    %dl,(%rax)
  801007:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80100b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80100f:	48 89 10             	mov    %rdx,(%rax)
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 50          	sub    $0x50,%rsp
  80101c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801020:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801023:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801027:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80102b:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80102f:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801033:	48 8b 0a             	mov    (%rdx),%rcx
  801036:	48 89 08             	mov    %rcx,(%rax)
  801039:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80103d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801041:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801045:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801049:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80104d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801051:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801054:	48 98                	cltq   
  801056:	48 83 e8 01          	sub    $0x1,%rax
  80105a:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80105e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801062:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801069:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80106e:	74 06                	je     801076 <vsnprintf+0x62>
  801070:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801074:	7f 07                	jg     80107d <vsnprintf+0x69>
		return -E_INVAL;
  801076:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107b:	eb 2f                	jmp    8010ac <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80107d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801081:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801085:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801089:	48 89 c6             	mov    %rax,%rsi
  80108c:	48 bf c7 0f 80 00 00 	movabs $0x800fc7,%rdi
  801093:	00 00 00 
  801096:	48 b8 f0 09 80 00 00 	movabs $0x8009f0,%rax
  80109d:	00 00 00 
  8010a0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010a9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010ac:	c9                   	leaveq 
  8010ad:	c3                   	retq   

00000000008010ae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010ae:	55                   	push   %rbp
  8010af:	48 89 e5             	mov    %rsp,%rbp
  8010b2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010b9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010c0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010c6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010cd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010db:	84 c0                	test   %al,%al
  8010dd:	74 20                	je     8010ff <snprintf+0x51>
  8010df:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010e3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010e7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010eb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010ef:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010f3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010f7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010fb:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010ff:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801106:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80110d:	00 00 00 
  801110:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801117:	00 00 00 
  80111a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80111e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801125:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80112c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801133:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80113a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801141:	48 8b 0a             	mov    (%rdx),%rcx
  801144:	48 89 08             	mov    %rcx,(%rax)
  801147:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80114b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80114f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801153:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801157:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80115e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801165:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80116b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801172:	48 89 c7             	mov    %rax,%rdi
  801175:	48 b8 14 10 80 00 00 	movabs $0x801014,%rax
  80117c:	00 00 00 
  80117f:	ff d0                	callq  *%rax
  801181:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801187:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80118d:	c9                   	leaveq 
  80118e:	c3                   	retq   
	...

0000000000801190 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801190:	55                   	push   %rbp
  801191:	48 89 e5             	mov    %rsp,%rbp
  801194:	48 83 ec 18          	sub    $0x18,%rsp
  801198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80119c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a3:	eb 09                	jmp    8011ae <strlen+0x1e>
		n++;
  8011a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011a9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	0f b6 00             	movzbl (%rax),%eax
  8011b5:	84 c0                	test   %al,%al
  8011b7:	75 ec                	jne    8011a5 <strlen+0x15>
		n++;
	return n;
  8011b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011bc:	c9                   	leaveq 
  8011bd:	c3                   	retq   

00000000008011be <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011be:	55                   	push   %rbp
  8011bf:	48 89 e5             	mov    %rsp,%rbp
  8011c2:	48 83 ec 20          	sub    $0x20,%rsp
  8011c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011d5:	eb 0e                	jmp    8011e5 <strnlen+0x27>
		n++;
  8011d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011db:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011e0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011e5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011ea:	74 0b                	je     8011f7 <strnlen+0x39>
  8011ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	84 c0                	test   %al,%al
  8011f5:	75 e0                	jne    8011d7 <strnlen+0x19>
		n++;
	return n;
  8011f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 20          	sub    $0x20,%rsp
  801204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801208:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80120c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801210:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801214:	90                   	nop
  801215:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801219:	0f b6 10             	movzbl (%rax),%edx
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	88 10                	mov    %dl,(%rax)
  801222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801226:	0f b6 00             	movzbl (%rax),%eax
  801229:	84 c0                	test   %al,%al
  80122b:	0f 95 c0             	setne  %al
  80122e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801233:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801238:	84 c0                	test   %al,%al
  80123a:	75 d9                	jne    801215 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801240:	c9                   	leaveq 
  801241:	c3                   	retq   

0000000000801242 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801242:	55                   	push   %rbp
  801243:	48 89 e5             	mov    %rsp,%rbp
  801246:	48 83 ec 20          	sub    $0x20,%rsp
  80124a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80124e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801256:	48 89 c7             	mov    %rax,%rdi
  801259:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  801260:	00 00 00 
  801263:	ff d0                	callq  *%rax
  801265:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801268:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126b:	48 98                	cltq   
  80126d:	48 03 45 e8          	add    -0x18(%rbp),%rax
  801271:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801275:	48 89 d6             	mov    %rdx,%rsi
  801278:	48 89 c7             	mov    %rax,%rdi
  80127b:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  801282:	00 00 00 
  801285:	ff d0                	callq  *%rax
	return dst;
  801287:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80128b:	c9                   	leaveq 
  80128c:	c3                   	retq   

000000000080128d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80128d:	55                   	push   %rbp
  80128e:	48 89 e5             	mov    %rsp,%rbp
  801291:	48 83 ec 28          	sub    $0x28,%rsp
  801295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80129d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012a9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012b0:	00 
  8012b1:	eb 27                	jmp    8012da <strncpy+0x4d>
		*dst++ = *src;
  8012b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b7:	0f b6 10             	movzbl (%rax),%edx
  8012ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012be:	88 10                	mov    %dl,(%rax)
  8012c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 05                	je     8012d5 <strncpy+0x48>
			src++;
  8012d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012e2:	72 cf                	jb     8012b3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 28          	sub    $0x28,%rsp
  8012f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8012fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801306:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80130b:	74 37                	je     801344 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  80130d:	eb 17                	jmp    801326 <strlcpy+0x3c>
			*dst++ = *src++;
  80130f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801313:	0f b6 10             	movzbl (%rax),%edx
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	88 10                	mov    %dl,(%rax)
  80131c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801321:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801326:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80132b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801330:	74 0b                	je     80133d <strlcpy+0x53>
  801332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801336:	0f b6 00             	movzbl (%rax),%eax
  801339:	84 c0                	test   %al,%al
  80133b:	75 d2                	jne    80130f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80133d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801341:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801344:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801348:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134c:	48 89 d1             	mov    %rdx,%rcx
  80134f:	48 29 c1             	sub    %rax,%rcx
  801352:	48 89 c8             	mov    %rcx,%rax
}
  801355:	c9                   	leaveq 
  801356:	c3                   	retq   

0000000000801357 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801357:	55                   	push   %rbp
  801358:	48 89 e5             	mov    %rsp,%rbp
  80135b:	48 83 ec 10          	sub    $0x10,%rsp
  80135f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801363:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801367:	eb 0a                	jmp    801373 <strcmp+0x1c>
		p++, q++;
  801369:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801373:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801377:	0f b6 00             	movzbl (%rax),%eax
  80137a:	84 c0                	test   %al,%al
  80137c:	74 12                	je     801390 <strcmp+0x39>
  80137e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801382:	0f b6 10             	movzbl (%rax),%edx
  801385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 d9                	je     801369 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801394:	0f b6 00             	movzbl (%rax),%eax
  801397:	0f b6 d0             	movzbl %al,%edx
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	0f b6 00             	movzbl (%rax),%eax
  8013a1:	0f b6 c0             	movzbl %al,%eax
  8013a4:	89 d1                	mov    %edx,%ecx
  8013a6:	29 c1                	sub    %eax,%ecx
  8013a8:	89 c8                	mov    %ecx,%eax
}
  8013aa:	c9                   	leaveq 
  8013ab:	c3                   	retq   

00000000008013ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013ac:	55                   	push   %rbp
  8013ad:	48 89 e5             	mov    %rsp,%rbp
  8013b0:	48 83 ec 18          	sub    $0x18,%rsp
  8013b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013c0:	eb 0f                	jmp    8013d1 <strncmp+0x25>
		n--, p++, q++;
  8013c2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013d6:	74 1d                	je     8013f5 <strncmp+0x49>
  8013d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013dc:	0f b6 00             	movzbl (%rax),%eax
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 12                	je     8013f5 <strncmp+0x49>
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	0f b6 10             	movzbl (%rax),%edx
  8013ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ee:	0f b6 00             	movzbl (%rax),%eax
  8013f1:	38 c2                	cmp    %al,%dl
  8013f3:	74 cd                	je     8013c2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8013f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fa:	75 07                	jne    801403 <strncmp+0x57>
		return 0;
  8013fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801401:	eb 1a                	jmp    80141d <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801403:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	0f b6 d0             	movzbl %al,%edx
  80140d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801411:	0f b6 00             	movzbl (%rax),%eax
  801414:	0f b6 c0             	movzbl %al,%eax
  801417:	89 d1                	mov    %edx,%ecx
  801419:	29 c1                	sub    %eax,%ecx
  80141b:	89 c8                	mov    %ecx,%eax
}
  80141d:	c9                   	leaveq 
  80141e:	c3                   	retq   

000000000080141f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80141f:	55                   	push   %rbp
  801420:	48 89 e5             	mov    %rsp,%rbp
  801423:	48 83 ec 10          	sub    $0x10,%rsp
  801427:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801430:	eb 17                	jmp    801449 <strchr+0x2a>
		if (*s == c)
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80143c:	75 06                	jne    801444 <strchr+0x25>
			return (char *) s;
  80143e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801442:	eb 15                	jmp    801459 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801444:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	84 c0                	test   %al,%al
  801452:	75 de                	jne    801432 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801454:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801459:	c9                   	leaveq 
  80145a:	c3                   	retq   

000000000080145b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 10          	sub    $0x10,%rsp
  801463:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801467:	89 f0                	mov    %esi,%eax
  801469:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80146c:	eb 11                	jmp    80147f <strfind+0x24>
		if (*s == c)
  80146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801478:	74 12                	je     80148c <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80147a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	84 c0                	test   %al,%al
  801488:	75 e4                	jne    80146e <strfind+0x13>
  80148a:	eb 01                	jmp    80148d <strfind+0x32>
		if (*s == c)
			break;
  80148c:	90                   	nop
	return (char *) s;
  80148d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801491:	c9                   	leaveq 
  801492:	c3                   	retq   

0000000000801493 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801493:	55                   	push   %rbp
  801494:	48 89 e5             	mov    %rsp,%rbp
  801497:	48 83 ec 18          	sub    $0x18,%rsp
  80149b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014a6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014ab:	75 06                	jne    8014b3 <memset+0x20>
		return v;
  8014ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b1:	eb 69                	jmp    80151c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b7:	83 e0 03             	and    $0x3,%eax
  8014ba:	48 85 c0             	test   %rax,%rax
  8014bd:	75 48                	jne    801507 <memset+0x74>
  8014bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c3:	83 e0 03             	and    $0x3,%eax
  8014c6:	48 85 c0             	test   %rax,%rax
  8014c9:	75 3c                	jne    801507 <memset+0x74>
		c &= 0xFF;
  8014cb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014d5:	89 c2                	mov    %eax,%edx
  8014d7:	c1 e2 18             	shl    $0x18,%edx
  8014da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014dd:	c1 e0 10             	shl    $0x10,%eax
  8014e0:	09 c2                	or     %eax,%edx
  8014e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014e5:	c1 e0 08             	shl    $0x8,%eax
  8014e8:	09 d0                	or     %edx,%eax
  8014ea:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 c1             	mov    %rax,%rcx
  8014f4:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ff:	48 89 d7             	mov    %rdx,%rdi
  801502:	fc                   	cld    
  801503:	f3 ab                	rep stos %eax,%es:(%rdi)
  801505:	eb 11                	jmp    801518 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80150b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80150e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801512:	48 89 d7             	mov    %rdx,%rdi
  801515:	fc                   	cld    
  801516:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801518:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 28          	sub    $0x28,%rsp
  801526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801532:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801536:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80153a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80153e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801542:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801546:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80154a:	0f 83 88 00 00 00    	jae    8015d8 <memmove+0xba>
  801550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801554:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801558:	48 01 d0             	add    %rdx,%rax
  80155b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80155f:	76 77                	jbe    8015d8 <memmove+0xba>
		s += n;
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801569:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801575:	83 e0 03             	and    $0x3,%eax
  801578:	48 85 c0             	test   %rax,%rax
  80157b:	75 3b                	jne    8015b8 <memmove+0x9a>
  80157d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801581:	83 e0 03             	and    $0x3,%eax
  801584:	48 85 c0             	test   %rax,%rax
  801587:	75 2f                	jne    8015b8 <memmove+0x9a>
  801589:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158d:	83 e0 03             	and    $0x3,%eax
  801590:	48 85 c0             	test   %rax,%rax
  801593:	75 23                	jne    8015b8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801599:	48 83 e8 04          	sub    $0x4,%rax
  80159d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015a1:	48 83 ea 04          	sub    $0x4,%rdx
  8015a5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015a9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ad:	48 89 c7             	mov    %rax,%rdi
  8015b0:	48 89 d6             	mov    %rdx,%rsi
  8015b3:	fd                   	std    
  8015b4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015b6:	eb 1d                	jmp    8015d5 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cc:	48 89 d7             	mov    %rdx,%rdi
  8015cf:	48 89 c1             	mov    %rax,%rcx
  8015d2:	fd                   	std    
  8015d3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015d5:	fc                   	cld    
  8015d6:	eb 57                	jmp    80162f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015dc:	83 e0 03             	and    $0x3,%eax
  8015df:	48 85 c0             	test   %rax,%rax
  8015e2:	75 36                	jne    80161a <memmove+0xfc>
  8015e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e8:	83 e0 03             	and    $0x3,%eax
  8015eb:	48 85 c0             	test   %rax,%rax
  8015ee:	75 2a                	jne    80161a <memmove+0xfc>
  8015f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f4:	83 e0 03             	and    $0x3,%eax
  8015f7:	48 85 c0             	test   %rax,%rax
  8015fa:	75 1e                	jne    80161a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	48 89 c1             	mov    %rax,%rcx
  801603:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80160f:	48 89 c7             	mov    %rax,%rdi
  801612:	48 89 d6             	mov    %rdx,%rsi
  801615:	fc                   	cld    
  801616:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801618:	eb 15                	jmp    80162f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80161a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801622:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801626:	48 89 c7             	mov    %rax,%rdi
  801629:	48 89 d6             	mov    %rdx,%rsi
  80162c:	fc                   	cld    
  80162d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80162f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 18          	sub    $0x18,%rsp
  80163d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801641:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801645:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80164d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801655:	48 89 ce             	mov    %rcx,%rsi
  801658:	48 89 c7             	mov    %rax,%rdi
  80165b:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  801662:	00 00 00 
  801665:	ff d0                	callq  *%rax
}
  801667:	c9                   	leaveq 
  801668:	c3                   	retq   

0000000000801669 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801669:	55                   	push   %rbp
  80166a:	48 89 e5             	mov    %rsp,%rbp
  80166d:	48 83 ec 28          	sub    $0x28,%rsp
  801671:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801675:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801679:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80167d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801681:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801685:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801689:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80168d:	eb 38                	jmp    8016c7 <memcmp+0x5e>
		if (*s1 != *s2)
  80168f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801693:	0f b6 10             	movzbl (%rax),%edx
  801696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169a:	0f b6 00             	movzbl (%rax),%eax
  80169d:	38 c2                	cmp    %al,%dl
  80169f:	74 1c                	je     8016bd <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  8016a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a5:	0f b6 00             	movzbl (%rax),%eax
  8016a8:	0f b6 d0             	movzbl %al,%edx
  8016ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	0f b6 c0             	movzbl %al,%eax
  8016b5:	89 d1                	mov    %edx,%ecx
  8016b7:	29 c1                	sub    %eax,%ecx
  8016b9:	89 c8                	mov    %ecx,%eax
  8016bb:	eb 20                	jmp    8016dd <memcmp+0x74>
		s1++, s2++;
  8016bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8016cc:	0f 95 c0             	setne  %al
  8016cf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8016d4:	84 c0                	test   %al,%al
  8016d6:	75 b7                	jne    80168f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016dd:	c9                   	leaveq 
  8016de:	c3                   	retq   

00000000008016df <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016df:	55                   	push   %rbp
  8016e0:	48 89 e5             	mov    %rsp,%rbp
  8016e3:	48 83 ec 28          	sub    $0x28,%rsp
  8016e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8016ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8016f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016fa:	48 01 d0             	add    %rdx,%rax
  8016fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801701:	eb 13                	jmp    801716 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801707:	0f b6 10             	movzbl (%rax),%edx
  80170a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80170d:	38 c2                	cmp    %al,%dl
  80170f:	74 11                	je     801722 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801711:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80171e:	72 e3                	jb     801703 <memfind+0x24>
  801720:	eb 01                	jmp    801723 <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801722:	90                   	nop
	return (void *) s;
  801723:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801727:	c9                   	leaveq 
  801728:	c3                   	retq   

0000000000801729 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801729:	55                   	push   %rbp
  80172a:	48 89 e5             	mov    %rsp,%rbp
  80172d:	48 83 ec 38          	sub    $0x38,%rsp
  801731:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801735:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801739:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80173c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801743:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80174a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174b:	eb 05                	jmp    801752 <strtol+0x29>
		s++;
  80174d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801756:	0f b6 00             	movzbl (%rax),%eax
  801759:	3c 20                	cmp    $0x20,%al
  80175b:	74 f0                	je     80174d <strtol+0x24>
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	0f b6 00             	movzbl (%rax),%eax
  801764:	3c 09                	cmp    $0x9,%al
  801766:	74 e5                	je     80174d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	0f b6 00             	movzbl (%rax),%eax
  80176f:	3c 2b                	cmp    $0x2b,%al
  801771:	75 07                	jne    80177a <strtol+0x51>
		s++;
  801773:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801778:	eb 17                	jmp    801791 <strtol+0x68>
	else if (*s == '-')
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	0f b6 00             	movzbl (%rax),%eax
  801781:	3c 2d                	cmp    $0x2d,%al
  801783:	75 0c                	jne    801791 <strtol+0x68>
		s++, neg = 1;
  801785:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801791:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801795:	74 06                	je     80179d <strtol+0x74>
  801797:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80179b:	75 28                	jne    8017c5 <strtol+0x9c>
  80179d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	3c 30                	cmp    $0x30,%al
  8017a6:	75 1d                	jne    8017c5 <strtol+0x9c>
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	48 83 c0 01          	add    $0x1,%rax
  8017b0:	0f b6 00             	movzbl (%rax),%eax
  8017b3:	3c 78                	cmp    $0x78,%al
  8017b5:	75 0e                	jne    8017c5 <strtol+0x9c>
		s += 2, base = 16;
  8017b7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017bc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017c3:	eb 2c                	jmp    8017f1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017c9:	75 19                	jne    8017e4 <strtol+0xbb>
  8017cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017cf:	0f b6 00             	movzbl (%rax),%eax
  8017d2:	3c 30                	cmp    $0x30,%al
  8017d4:	75 0e                	jne    8017e4 <strtol+0xbb>
		s++, base = 8;
  8017d6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017db:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017e2:	eb 0d                	jmp    8017f1 <strtol+0xc8>
	else if (base == 0)
  8017e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017e8:	75 07                	jne    8017f1 <strtol+0xc8>
		base = 10;
  8017ea:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f5:	0f b6 00             	movzbl (%rax),%eax
  8017f8:	3c 2f                	cmp    $0x2f,%al
  8017fa:	7e 1d                	jle    801819 <strtol+0xf0>
  8017fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801800:	0f b6 00             	movzbl (%rax),%eax
  801803:	3c 39                	cmp    $0x39,%al
  801805:	7f 12                	jg     801819 <strtol+0xf0>
			dig = *s - '0';
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	0f b6 00             	movzbl (%rax),%eax
  80180e:	0f be c0             	movsbl %al,%eax
  801811:	83 e8 30             	sub    $0x30,%eax
  801814:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801817:	eb 4e                	jmp    801867 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801819:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181d:	0f b6 00             	movzbl (%rax),%eax
  801820:	3c 60                	cmp    $0x60,%al
  801822:	7e 1d                	jle    801841 <strtol+0x118>
  801824:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801828:	0f b6 00             	movzbl (%rax),%eax
  80182b:	3c 7a                	cmp    $0x7a,%al
  80182d:	7f 12                	jg     801841 <strtol+0x118>
			dig = *s - 'a' + 10;
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	0f b6 00             	movzbl (%rax),%eax
  801836:	0f be c0             	movsbl %al,%eax
  801839:	83 e8 57             	sub    $0x57,%eax
  80183c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80183f:	eb 26                	jmp    801867 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 40                	cmp    $0x40,%al
  80184a:	7e 47                	jle    801893 <strtol+0x16a>
  80184c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801850:	0f b6 00             	movzbl (%rax),%eax
  801853:	3c 5a                	cmp    $0x5a,%al
  801855:	7f 3c                	jg     801893 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	0f be c0             	movsbl %al,%eax
  801861:	83 e8 37             	sub    $0x37,%eax
  801864:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801867:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80186a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80186d:	7d 23                	jge    801892 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80186f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801874:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801877:	48 98                	cltq   
  801879:	48 89 c2             	mov    %rax,%rdx
  80187c:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801881:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801884:	48 98                	cltq   
  801886:	48 01 d0             	add    %rdx,%rax
  801889:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80188d:	e9 5f ff ff ff       	jmpq   8017f1 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801892:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801893:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801898:	74 0b                	je     8018a5 <strtol+0x17c>
		*endptr = (char *) s;
  80189a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80189e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018a2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018a9:	74 09                	je     8018b4 <strtol+0x18b>
  8018ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018af:	48 f7 d8             	neg    %rax
  8018b2:	eb 04                	jmp    8018b8 <strtol+0x18f>
  8018b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018b8:	c9                   	leaveq 
  8018b9:	c3                   	retq   

00000000008018ba <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ba:	55                   	push   %rbp
  8018bb:	48 89 e5             	mov    %rsp,%rbp
  8018be:	48 83 ec 30          	sub    $0x30,%rsp
  8018c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8018ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018ce:	0f b6 00             	movzbl (%rax),%eax
  8018d1:	88 45 ff             	mov    %al,-0x1(%rbp)
  8018d4:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  8018d9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018dd:	75 06                	jne    8018e5 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	eb 68                	jmp    80194d <strstr+0x93>

    len = strlen(str);
  8018e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	48 98                	cltq   
  8018fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	0f b6 00             	movzbl (%rax),%eax
  801905:	88 45 ef             	mov    %al,-0x11(%rbp)
  801908:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  80190d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801911:	75 07                	jne    80191a <strstr+0x60>
                return (char *) 0;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
  801918:	eb 33                	jmp    80194d <strstr+0x93>
        } while (sc != c);
  80191a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80191e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801921:	75 db                	jne    8018fe <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801927:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80192b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192f:	48 89 ce             	mov    %rcx,%rsi
  801932:	48 89 c7             	mov    %rax,%rdi
  801935:	48 b8 ac 13 80 00 00 	movabs $0x8013ac,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
  801941:	85 c0                	test   %eax,%eax
  801943:	75 b9                	jne    8018fe <strstr+0x44>

    return (char *) (in - 1);
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	48 83 e8 01          	sub    $0x1,%rax
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   
	...

0000000000801950 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801950:	55                   	push   %rbp
  801951:	48 89 e5             	mov    %rsp,%rbp
  801954:	53                   	push   %rbx
  801955:	48 83 ec 58          	sub    $0x58,%rsp
  801959:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80195c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80195f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801963:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801967:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80196b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801972:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801975:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801979:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80197d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801981:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801985:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801989:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80198c:	4c 89 c3             	mov    %r8,%rbx
  80198f:	cd 30                	int    $0x30
  801991:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801995:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801999:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80199d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019a1:	74 3e                	je     8019e1 <syscall+0x91>
  8019a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a8:	7e 37                	jle    8019e1 <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019b1:	49 89 d0             	mov    %rdx,%r8
  8019b4:	89 c1                	mov    %eax,%ecx
  8019b6:	48 ba 80 4d 80 00 00 	movabs $0x804d80,%rdx
  8019bd:	00 00 00 
  8019c0:	be 23 00 00 00       	mov    $0x23,%esi
  8019c5:	48 bf 9d 4d 80 00 00 	movabs $0x804d9d,%rdi
  8019cc:	00 00 00 
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d4:	49 b9 04 04 80 00 00 	movabs $0x800404,%r9
  8019db:	00 00 00 
  8019de:	41 ff d1             	callq  *%r9

	return ret;
  8019e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019e5:	48 83 c4 58          	add    $0x58,%rsp
  8019e9:	5b                   	pop    %rbx
  8019ea:	5d                   	pop    %rbp
  8019eb:	c3                   	retq   

00000000008019ec <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019ec:	55                   	push   %rbp
  8019ed:	48 89 e5             	mov    %rsp,%rbp
  8019f0:	48 83 ec 20          	sub    $0x20,%rsp
  8019f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8019f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8019fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a00:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0b:	00 
  801a0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a18:	48 89 d1             	mov    %rdx,%rcx
  801a1b:	48 89 c2             	mov    %rax,%rdx
  801a1e:	be 00 00 00 00       	mov    $0x0,%esi
  801a23:	bf 00 00 00 00       	mov    $0x0,%edi
  801a28:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801a2f:	00 00 00 
  801a32:	ff d0                	callq  *%rax
}
  801a34:	c9                   	leaveq 
  801a35:	c3                   	retq   

0000000000801a36 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a36:	55                   	push   %rbp
  801a37:	48 89 e5             	mov    %rsp,%rbp
  801a3a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a3e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a45:	00 
  801a46:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a57:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5c:	be 00 00 00 00       	mov    $0x0,%esi
  801a61:	bf 01 00 00 00       	mov    $0x1,%edi
  801a66:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	callq  *%rax
}
  801a72:	c9                   	leaveq 
  801a73:	c3                   	retq   

0000000000801a74 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a74:	55                   	push   %rbp
  801a75:	48 89 e5             	mov    %rsp,%rbp
  801a78:	48 83 ec 20          	sub    $0x20,%rsp
  801a7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a82:	48 98                	cltq   
  801a84:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8b:	00 
  801a8c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a92:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 01 00 00 00       	mov    $0x1,%esi
  801aa5:	bf 03 00 00 00       	mov    $0x3,%edi
  801aaa:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ac0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ac7:	00 
  801ac8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ace:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ade:	be 00 00 00 00       	mov    $0x0,%esi
  801ae3:	bf 02 00 00 00       	mov    $0x2,%edi
  801ae8:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801aef:	00 00 00 
  801af2:	ff d0                	callq  *%rax
}
  801af4:	c9                   	leaveq 
  801af5:	c3                   	retq   

0000000000801af6 <sys_yield>:

void
sys_yield(void)
{
  801af6:	55                   	push   %rbp
  801af7:	48 89 e5             	mov    %rsp,%rbp
  801afa:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801afe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b05:	00 
  801b06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	be 00 00 00 00       	mov    $0x0,%esi
  801b21:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b26:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801b2d:	00 00 00 
  801b30:	ff d0                	callq  *%rax
}
  801b32:	c9                   	leaveq 
  801b33:	c3                   	retq   

0000000000801b34 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b34:	55                   	push   %rbp
  801b35:	48 89 e5             	mov    %rsp,%rbp
  801b38:	48 83 ec 20          	sub    $0x20,%rsp
  801b3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b43:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b49:	48 63 c8             	movslq %eax,%rcx
  801b4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b53:	48 98                	cltq   
  801b55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b5c:	00 
  801b5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b63:	49 89 c8             	mov    %rcx,%r8
  801b66:	48 89 d1             	mov    %rdx,%rcx
  801b69:	48 89 c2             	mov    %rax,%rdx
  801b6c:	be 01 00 00 00       	mov    $0x1,%esi
  801b71:	bf 04 00 00 00       	mov    $0x4,%edi
  801b76:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801b7d:	00 00 00 
  801b80:	ff d0                	callq  *%rax
}
  801b82:	c9                   	leaveq 
  801b83:	c3                   	retq   

0000000000801b84 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b84:	55                   	push   %rbp
  801b85:	48 89 e5             	mov    %rsp,%rbp
  801b88:	48 83 ec 30          	sub    $0x30,%rsp
  801b8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b8f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b93:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801b96:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801b9a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801b9e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ba1:	48 63 c8             	movslq %eax,%rcx
  801ba4:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801ba8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bab:	48 63 f0             	movslq %eax,%rsi
  801bae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb5:	48 98                	cltq   
  801bb7:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bbb:	49 89 f9             	mov    %rdi,%r9
  801bbe:	49 89 f0             	mov    %rsi,%r8
  801bc1:	48 89 d1             	mov    %rdx,%rcx
  801bc4:	48 89 c2             	mov    %rax,%rdx
  801bc7:	be 01 00 00 00       	mov    $0x1,%esi
  801bcc:	bf 05 00 00 00       	mov    $0x5,%edi
  801bd1:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801bd8:	00 00 00 
  801bdb:	ff d0                	callq  *%rax
}
  801bdd:	c9                   	leaveq 
  801bde:	c3                   	retq   

0000000000801bdf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bdf:	55                   	push   %rbp
  801be0:	48 89 e5             	mov    %rsp,%rbp
  801be3:	48 83 ec 20          	sub    $0x20,%rsp
  801be7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf5:	48 98                	cltq   
  801bf7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bfe:	00 
  801bff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0b:	48 89 d1             	mov    %rdx,%rcx
  801c0e:	48 89 c2             	mov    %rax,%rdx
  801c11:	be 01 00 00 00       	mov    $0x1,%esi
  801c16:	bf 06 00 00 00       	mov    $0x6,%edi
  801c1b:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801c22:	00 00 00 
  801c25:	ff d0                	callq  *%rax
}
  801c27:	c9                   	leaveq 
  801c28:	c3                   	retq   

0000000000801c29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c29:	55                   	push   %rbp
  801c2a:	48 89 e5             	mov    %rsp,%rbp
  801c2d:	48 83 ec 20          	sub    $0x20,%rsp
  801c31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c3a:	48 63 d0             	movslq %eax,%rdx
  801c3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c40:	48 98                	cltq   
  801c42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c49:	00 
  801c4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c56:	48 89 d1             	mov    %rdx,%rcx
  801c59:	48 89 c2             	mov    %rax,%rdx
  801c5c:	be 01 00 00 00       	mov    $0x1,%esi
  801c61:	bf 08 00 00 00       	mov    $0x8,%edi
  801c66:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801c6d:	00 00 00 
  801c70:	ff d0                	callq  *%rax
}
  801c72:	c9                   	leaveq 
  801c73:	c3                   	retq   

0000000000801c74 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c74:	55                   	push   %rbp
  801c75:	48 89 e5             	mov    %rsp,%rbp
  801c78:	48 83 ec 20          	sub    $0x20,%rsp
  801c7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8a:	48 98                	cltq   
  801c8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c93:	00 
  801c94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca0:	48 89 d1             	mov    %rdx,%rcx
  801ca3:	48 89 c2             	mov    %rax,%rdx
  801ca6:	be 01 00 00 00       	mov    $0x1,%esi
  801cab:	bf 09 00 00 00       	mov    $0x9,%edi
  801cb0:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801cb7:	00 00 00 
  801cba:	ff d0                	callq  *%rax
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	48 83 ec 20          	sub    $0x20,%rsp
  801cc6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ccd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd4:	48 98                	cltq   
  801cd6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cdd:	00 
  801cde:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cea:	48 89 d1             	mov    %rdx,%rcx
  801ced:	48 89 c2             	mov    %rax,%rdx
  801cf0:	be 01 00 00 00       	mov    $0x1,%esi
  801cf5:	bf 0a 00 00 00       	mov    $0xa,%edi
  801cfa:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801d01:	00 00 00 
  801d04:	ff d0                	callq  *%rax
}
  801d06:	c9                   	leaveq 
  801d07:	c3                   	retq   

0000000000801d08 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d08:	55                   	push   %rbp
  801d09:	48 89 e5             	mov    %rsp,%rbp
  801d0c:	48 83 ec 30          	sub    $0x30,%rsp
  801d10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d17:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d1b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d1e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d21:	48 63 f0             	movslq %eax,%rsi
  801d24:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2b:	48 98                	cltq   
  801d2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d31:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d38:	00 
  801d39:	49 89 f1             	mov    %rsi,%r9
  801d3c:	49 89 c8             	mov    %rcx,%r8
  801d3f:	48 89 d1             	mov    %rdx,%rcx
  801d42:	48 89 c2             	mov    %rax,%rdx
  801d45:	be 00 00 00 00       	mov    $0x0,%esi
  801d4a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801d4f:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801d56:	00 00 00 
  801d59:	ff d0                	callq  *%rax
}
  801d5b:	c9                   	leaveq 
  801d5c:	c3                   	retq   

0000000000801d5d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801d5d:	55                   	push   %rbp
  801d5e:	48 89 e5             	mov    %rsp,%rbp
  801d61:	48 83 ec 20          	sub    $0x20,%rsp
  801d65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801d69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d74:	00 
  801d75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d86:	48 89 c2             	mov    %rax,%rdx
  801d89:	be 01 00 00 00       	mov    $0x1,%esi
  801d8e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801d93:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801d9a:	00 00 00 
  801d9d:	ff d0                	callq  *%rax
}
  801d9f:	c9                   	leaveq 
  801da0:	c3                   	retq   

0000000000801da1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801da1:	55                   	push   %rbp
  801da2:	48 89 e5             	mov    %rsp,%rbp
  801da5:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801da9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801db0:	00 
  801db1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801db7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc7:	be 00 00 00 00       	mov    $0x0,%esi
  801dcc:	bf 0e 00 00 00       	mov    $0xe,%edi
  801dd1:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
}
  801ddd:	c9                   	leaveq 
  801dde:	c3                   	retq   

0000000000801ddf <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  801ddf:	55                   	push   %rbp
  801de0:	48 89 e5             	mov    %rsp,%rbp
  801de3:	48 83 ec 20          	sub    $0x20,%rsp
  801de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801deb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801def:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801df7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dfe:	00 
  801dff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e0b:	48 89 d1             	mov    %rdx,%rcx
  801e0e:	48 89 c2             	mov    %rax,%rdx
  801e11:	be 00 00 00 00       	mov    $0x0,%esi
  801e16:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e1b:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801e22:	00 00 00 
  801e25:	ff d0                	callq  *%rax
}
  801e27:	c9                   	leaveq 
  801e28:	c3                   	retq   

0000000000801e29 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  801e29:	55                   	push   %rbp
  801e2a:	48 89 e5             	mov    %rsp,%rbp
  801e2d:	48 83 ec 20          	sub    $0x20,%rsp
  801e31:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e35:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  801e39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e41:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e48:	00 
  801e49:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e4f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e55:	48 89 d1             	mov    %rdx,%rcx
  801e58:	48 89 c2             	mov    %rax,%rdx
  801e5b:	be 00 00 00 00       	mov    $0x0,%esi
  801e60:	bf 10 00 00 00       	mov    $0x10,%edi
  801e65:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801e6c:	00 00 00 
  801e6f:	ff d0                	callq  *%rax
}
  801e71:	c9                   	leaveq 
  801e72:	c3                   	retq   
	...

0000000000801e74 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 30          	sub    $0x30,%rsp
  801e7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e84:	48 8b 00             	mov    (%rax),%rax
  801e87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801e8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e93:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  801e96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e99:	83 e0 02             	and    $0x2,%eax
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	74 23                	je     801ec3 <pgfault+0x4f>
  801ea0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea4:	48 89 c2             	mov    %rax,%rdx
  801ea7:	48 c1 ea 0c          	shr    $0xc,%rdx
  801eab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801eb2:	01 00 00 
  801eb5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb9:	25 00 08 00 00       	and    $0x800,%eax
  801ebe:	48 85 c0             	test   %rax,%rax
  801ec1:	75 2a                	jne    801eed <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  801ec3:	48 ba b0 4d 80 00 00 	movabs $0x804db0,%rdx
  801eca:	00 00 00 
  801ecd:	be 1c 00 00 00       	mov    $0x1c,%esi
  801ed2:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  801ed9:	00 00 00 
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  801ee8:	00 00 00 
  801eeb:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  801eed:	ba 07 00 00 00       	mov    $0x7,%edx
  801ef2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801ef7:	bf 00 00 00 00       	mov    $0x0,%edi
  801efc:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  801f03:	00 00 00 
  801f06:	ff d0                	callq  *%rax
  801f08:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f0f:	79 30                	jns    801f41 <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  801f11:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f14:	89 c1                	mov    %eax,%ecx
  801f16:	48 ba f0 4d 80 00 00 	movabs $0x804df0,%rdx
  801f1d:	00 00 00 
  801f20:	be 26 00 00 00       	mov    $0x26,%esi
  801f25:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  801f2c:	00 00 00 
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f34:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  801f3b:	00 00 00 
  801f3e:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  801f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f45:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f4d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f53:	ba 00 10 00 00       	mov    $0x1000,%edx
  801f58:	48 89 c6             	mov    %rax,%rsi
  801f5b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801f60:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  801f67:	00 00 00 
  801f6a:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  801f6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  801f74:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f78:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f7e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801f84:	48 89 c1             	mov    %rax,%rcx
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f91:	bf 00 00 00 00       	mov    $0x0,%edi
  801f96:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  801f9d:	00 00 00 
  801fa0:	ff d0                	callq  *%rax
  801fa2:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fa9:	79 30                	jns    801fdb <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  801fab:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801fae:	89 c1                	mov    %eax,%ecx
  801fb0:	48 ba 18 4e 80 00 00 	movabs $0x804e18,%rdx
  801fb7:	00 00 00 
  801fba:	be 2b 00 00 00       	mov    $0x2b,%esi
  801fbf:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  801fc6:	00 00 00 
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  801fd5:	00 00 00 
  801fd8:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  801fdb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe5:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  801fec:	00 00 00 
  801fef:	ff d0                	callq  *%rax
  801ff1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ff8:	79 30                	jns    80202a <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  801ffa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ffd:	89 c1                	mov    %eax,%ecx
  801fff:	48 ba 40 4e 80 00 00 	movabs $0x804e40,%rdx
  802006:	00 00 00 
  802009:	be 2e 00 00 00       	mov    $0x2e,%esi
  80200e:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802015:	00 00 00 
  802018:	b8 00 00 00 00       	mov    $0x0,%eax
  80201d:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802024:	00 00 00 
  802027:	41 ff d0             	callq  *%r8
	
}
  80202a:	c9                   	leaveq 
  80202b:	c3                   	retq   

000000000080202c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80202c:	55                   	push   %rbp
  80202d:	48 89 e5             	mov    %rsp,%rbp
  802030:	48 83 ec 30          	sub    $0x30,%rsp
  802034:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802037:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  80203a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802041:	01 00 00 
  802044:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802047:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  80204f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802053:	25 07 0e 00 00       	and    $0xe07,%eax
  802058:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  80205b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80205e:	48 c1 e0 0c          	shl    $0xc,%rax
  802062:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  802066:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802069:	25 00 04 00 00       	and    $0x400,%eax
  80206e:	85 c0                	test   %eax,%eax
  802070:	74 5c                	je     8020ce <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  802072:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802075:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802079:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80207c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802080:	41 89 f0             	mov    %esi,%r8d
  802083:	48 89 c6             	mov    %rax,%rsi
  802086:	bf 00 00 00 00       	mov    $0x0,%edi
  80208b:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
  802097:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  80209a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80209e:	0f 89 60 01 00 00    	jns    802204 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  8020a4:	48 ba 68 4e 80 00 00 	movabs $0x804e68,%rdx
  8020ab:	00 00 00 
  8020ae:	be 4d 00 00 00       	mov    $0x4d,%esi
  8020b3:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  8020ba:	00 00 00 
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  8020c9:	00 00 00 
  8020cc:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8020ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020d1:	83 e0 02             	and    $0x2,%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	75 10                	jne    8020e8 <duppage+0xbc>
  8020d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020db:	25 00 08 00 00       	and    $0x800,%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	0f 84 c4 00 00 00    	je     8021ac <duppage+0x180>
	{
		perm |= PTE_COW;
  8020e8:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8020ef:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8020f3:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8020f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020fa:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802101:	41 89 f0             	mov    %esi,%r8d
  802104:	48 89 c6             	mov    %rax,%rsi
  802107:	bf 00 00 00 00       	mov    $0x0,%edi
  80210c:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802113:	00 00 00 
  802116:	ff d0                	callq  *%rax
  802118:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  80211b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80211f:	79 2a                	jns    80214b <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  802121:	48 ba 98 4e 80 00 00 	movabs $0x804e98,%rdx
  802128:	00 00 00 
  80212b:	be 56 00 00 00       	mov    $0x56,%esi
  802130:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802137:	00 00 00 
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  802146:	00 00 00 
  802149:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  80214b:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80214e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802152:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802156:	41 89 c8             	mov    %ecx,%r8d
  802159:	48 89 d1             	mov    %rdx,%rcx
  80215c:	ba 00 00 00 00       	mov    $0x0,%edx
  802161:	48 89 c6             	mov    %rax,%rsi
  802164:	bf 00 00 00 00       	mov    $0x0,%edi
  802169:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802170:	00 00 00 
  802173:	ff d0                	callq  *%rax
  802175:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802178:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80217c:	0f 89 82 00 00 00    	jns    802204 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  802182:	48 ba 98 4e 80 00 00 	movabs $0x804e98,%rdx
  802189:	00 00 00 
  80218c:	be 59 00 00 00       	mov    $0x59,%esi
  802191:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802198:	00 00 00 
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  8021a7:	00 00 00 
  8021aa:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  8021ac:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8021af:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8021b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ba:	41 89 f0             	mov    %esi,%r8d
  8021bd:	48 89 c6             	mov    %rax,%rsi
  8021c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021c5:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8021cc:	00 00 00 
  8021cf:	ff d0                	callq  *%rax
  8021d1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8021d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021d8:	79 2a                	jns    802204 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8021da:	48 ba d0 4e 80 00 00 	movabs $0x804ed0,%rdx
  8021e1:	00 00 00 
  8021e4:	be 60 00 00 00       	mov    $0x60,%esi
  8021e9:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  8021f0:	00 00 00 
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  8021ff:	00 00 00 
  802202:	ff d1                	callq  *%rcx
	}
	return 0;
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802209:	c9                   	leaveq 
  80220a:	c3                   	retq   

000000000080220b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80220b:	55                   	push   %rbp
  80220c:	48 89 e5             	mov    %rsp,%rbp
  80220f:	53                   	push   %rbx
  802210:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802214:	48 bf 74 1e 80 00 00 	movabs $0x801e74,%rdi
  80221b:	00 00 00 
  80221e:	48 b8 6c 43 80 00 00 	movabs $0x80436c,%rax
  802225:	00 00 00 
  802228:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80222a:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  802231:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802234:	cd 30                	int    $0x30
  802236:	89 c3                	mov    %eax,%ebx
  802238:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80223b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  80223e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  802241:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802245:	79 30                	jns    802277 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  802247:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80224a:	89 c1                	mov    %eax,%ecx
  80224c:	48 ba f4 4e 80 00 00 	movabs $0x804ef4,%rdx
  802253:	00 00 00 
  802256:	be 7f 00 00 00       	mov    $0x7f,%esi
  80225b:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802262:	00 00 00 
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802271:	00 00 00 
  802274:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802277:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80227b:	75 4c                	jne    8022c9 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  80227d:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  802284:	00 00 00 
  802287:	ff d0                	callq  *%rax
  802289:	48 98                	cltq   
  80228b:	48 89 c2             	mov    %rax,%rdx
  80228e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802294:	48 89 d0             	mov    %rdx,%rax
  802297:	48 c1 e0 03          	shl    $0x3,%rax
  80229b:	48 01 d0             	add    %rdx,%rax
  80229e:	48 c1 e0 05          	shl    $0x5,%rax
  8022a2:	48 89 c2             	mov    %rax,%rdx
  8022a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8022ac:	00 00 00 
  8022af:	48 01 c2             	add    %rax,%rdx
  8022b2:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  8022b9:	00 00 00 
  8022bc:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	e9 38 02 00 00       	jmpq   802501 <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8022c9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8022cc:	ba 07 00 00 00       	mov    $0x7,%edx
  8022d1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8022d6:	89 c7                	mov    %eax,%edi
  8022d8:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  8022df:	00 00 00 
  8022e2:	ff d0                	callq  *%rax
  8022e4:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8022e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8022eb:	79 30                	jns    80231d <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8022ed:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8022f0:	89 c1                	mov    %eax,%ecx
  8022f2:	48 ba 08 4f 80 00 00 	movabs $0x804f08,%rdx
  8022f9:	00 00 00 
  8022fc:	be 8b 00 00 00       	mov    $0x8b,%esi
  802301:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802308:	00 00 00 
  80230b:	b8 00 00 00 00       	mov    $0x0,%eax
  802310:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  802317:	00 00 00 
  80231a:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  80231d:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802324:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80232b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  802332:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802339:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802340:	e9 0a 01 00 00       	jmpq   80244f <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802345:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  80234c:	01 00 00 
  80234f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802352:	48 63 d2             	movslq %edx,%rdx
  802355:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802359:	83 e0 01             	and    $0x1,%eax
  80235c:	84 c0                	test   %al,%al
  80235e:	0f 84 e7 00 00 00    	je     80244b <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802364:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  80236b:	e9 cf 00 00 00       	jmpq   80243f <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  802370:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802377:	01 00 00 
  80237a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80237d:	48 63 d2             	movslq %edx,%rdx
  802380:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802384:	83 e0 01             	and    $0x1,%eax
  802387:	84 c0                	test   %al,%al
  802389:	0f 84 a0 00 00 00    	je     80242f <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80238f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802396:	e9 85 00 00 00       	jmpq   802420 <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  80239b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023a2:	01 00 00 
  8023a5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023a8:	48 63 d2             	movslq %edx,%rdx
  8023ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023af:	83 e0 01             	and    $0x1,%eax
  8023b2:	84 c0                	test   %al,%al
  8023b4:	74 56                	je     80240c <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8023b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8023bd:	eb 42                	jmp    802401 <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8023bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023c6:	01 00 00 
  8023c9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023cc:	48 63 d2             	movslq %edx,%rdx
  8023cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023d3:	83 e0 01             	and    $0x1,%eax
  8023d6:	84 c0                	test   %al,%al
  8023d8:	74 1f                	je     8023f9 <fork+0x1ee>
  8023da:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8023e1:	74 16                	je     8023f9 <fork+0x1ee>
									 duppage(envid,d1);
  8023e3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023e6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8023e9:	89 d6                	mov    %edx,%esi
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	48 b8 2c 20 80 00 00 	movabs $0x80202c,%rax
  8023f4:	00 00 00 
  8023f7:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8023f9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8023fd:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  802401:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802408:	7e b5                	jle    8023bf <fork+0x1b4>
  80240a:	eb 0c                	jmp    802418 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  80240c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80240f:	83 c0 01             	add    $0x1,%eax
  802412:	c1 e0 09             	shl    $0x9,%eax
  802415:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802418:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  80241c:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  802420:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802427:	0f 8e 6e ff ff ff    	jle    80239b <fork+0x190>
  80242d:	eb 0c                	jmp    80243b <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80242f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802432:	83 c0 01             	add    $0x1,%eax
  802435:	c1 e0 09             	shl    $0x9,%eax
  802438:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  80243b:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80243f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802442:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802445:	0f 8c 25 ff ff ff    	jl     802370 <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  80244b:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80244f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802452:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802455:	0f 8c ea fe ff ff    	jl     802345 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  80245b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80245e:	48 be 30 44 80 00 00 	movabs $0x804430,%rsi
  802465:	00 00 00 
  802468:	89 c7                	mov    %eax,%edi
  80246a:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  802471:	00 00 00 
  802474:	ff d0                	callq  *%rax
  802476:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802479:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80247d:	79 30                	jns    8024af <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80247f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802482:	89 c1                	mov    %eax,%ecx
  802484:	48 ba 28 4f 80 00 00 	movabs $0x804f28,%rdx
  80248b:	00 00 00 
  80248e:	be ad 00 00 00       	mov    $0xad,%esi
  802493:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  80249a:	00 00 00 
  80249d:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a2:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8024a9:	00 00 00 
  8024ac:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8024af:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8024b2:	be 02 00 00 00       	mov    $0x2,%esi
  8024b7:	89 c7                	mov    %eax,%edi
  8024b9:	48 b8 29 1c 80 00 00 	movabs $0x801c29,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	callq  *%rax
  8024c5:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8024c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8024cc:	79 30                	jns    8024fe <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8024ce:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8024d1:	89 c1                	mov    %eax,%ecx
  8024d3:	48 ba 58 4f 80 00 00 	movabs $0x804f58,%rdx
  8024da:	00 00 00 
  8024dd:	be b0 00 00 00       	mov    $0xb0,%esi
  8024e2:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  8024e9:	00 00 00 
  8024ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f1:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8024f8:	00 00 00 
  8024fb:	41 ff d0             	callq  *%r8
	return envid;
  8024fe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  802501:	48 83 c4 48          	add    $0x48,%rsp
  802505:	5b                   	pop    %rbx
  802506:	5d                   	pop    %rbp
  802507:	c3                   	retq   

0000000000802508 <sfork>:

// Challenge!
int
sfork(void)
{
  802508:	55                   	push   %rbp
  802509:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80250c:	48 ba 7c 4f 80 00 00 	movabs $0x804f7c,%rdx
  802513:	00 00 00 
  802516:	be b8 00 00 00       	mov    $0xb8,%esi
  80251b:	48 bf e5 4d 80 00 00 	movabs $0x804de5,%rdi
  802522:	00 00 00 
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
  80252a:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  802531:	00 00 00 
  802534:	ff d1                	callq  *%rcx
	...

0000000000802538 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802538:	55                   	push   %rbp
  802539:	48 89 e5             	mov    %rsp,%rbp
  80253c:	48 83 ec 08          	sub    $0x8,%rsp
  802540:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802544:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802548:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80254f:	ff ff ff 
  802552:	48 01 d0             	add    %rdx,%rax
  802555:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802559:	c9                   	leaveq 
  80255a:	c3                   	retq   

000000000080255b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80255b:	55                   	push   %rbp
  80255c:	48 89 e5             	mov    %rsp,%rbp
  80255f:	48 83 ec 08          	sub    $0x8,%rsp
  802563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80256b:	48 89 c7             	mov    %rax,%rdi
  80256e:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
  80257a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802580:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802584:	c9                   	leaveq 
  802585:	c3                   	retq   

0000000000802586 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802586:	55                   	push   %rbp
  802587:	48 89 e5             	mov    %rsp,%rbp
  80258a:	48 83 ec 18          	sub    $0x18,%rsp
  80258e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802592:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802599:	eb 6b                	jmp    802606 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80259b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80259e:	48 98                	cltq   
  8025a0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025a6:	48 c1 e0 0c          	shl    $0xc,%rax
  8025aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8025ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b2:	48 89 c2             	mov    %rax,%rdx
  8025b5:	48 c1 ea 15          	shr    $0x15,%rdx
  8025b9:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025c0:	01 00 00 
  8025c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025c7:	83 e0 01             	and    $0x1,%eax
  8025ca:	48 85 c0             	test   %rax,%rax
  8025cd:	74 21                	je     8025f0 <fd_alloc+0x6a>
  8025cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d3:	48 89 c2             	mov    %rax,%rdx
  8025d6:	48 c1 ea 0c          	shr    $0xc,%rdx
  8025da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025e1:	01 00 00 
  8025e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e8:	83 e0 01             	and    $0x1,%eax
  8025eb:	48 85 c0             	test   %rax,%rax
  8025ee:	75 12                	jne    802602 <fd_alloc+0x7c>
			*fd_store = fd;
  8025f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802600:	eb 1a                	jmp    80261c <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802602:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802606:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80260a:	7e 8f                	jle    80259b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80260c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802610:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802617:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80261c:	c9                   	leaveq 
  80261d:	c3                   	retq   

000000000080261e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 20          	sub    $0x20,%rsp
  802626:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802629:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80262d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802631:	78 06                	js     802639 <fd_lookup+0x1b>
  802633:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802637:	7e 07                	jle    802640 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80263e:	eb 6c                	jmp    8026ac <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802640:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802643:	48 98                	cltq   
  802645:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80264b:	48 c1 e0 0c          	shl    $0xc,%rax
  80264f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802653:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802657:	48 89 c2             	mov    %rax,%rdx
  80265a:	48 c1 ea 15          	shr    $0x15,%rdx
  80265e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802665:	01 00 00 
  802668:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80266c:	83 e0 01             	and    $0x1,%eax
  80266f:	48 85 c0             	test   %rax,%rax
  802672:	74 21                	je     802695 <fd_lookup+0x77>
  802674:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802678:	48 89 c2             	mov    %rax,%rdx
  80267b:	48 c1 ea 0c          	shr    $0xc,%rdx
  80267f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802686:	01 00 00 
  802689:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80268d:	83 e0 01             	and    $0x1,%eax
  802690:	48 85 c0             	test   %rax,%rax
  802693:	75 07                	jne    80269c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802695:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80269a:	eb 10                	jmp    8026ac <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80269c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026a4:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8026a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ac:	c9                   	leaveq 
  8026ad:	c3                   	retq   

00000000008026ae <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8026ae:	55                   	push   %rbp
  8026af:	48 89 e5             	mov    %rsp,%rbp
  8026b2:	48 83 ec 30          	sub    $0x30,%rsp
  8026b6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8026ba:	89 f0                	mov    %esi,%eax
  8026bc:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8026bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c3:	48 89 c7             	mov    %rax,%rdi
  8026c6:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  8026cd:	00 00 00 
  8026d0:	ff d0                	callq  *%rax
  8026d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d6:	48 89 d6             	mov    %rdx,%rsi
  8026d9:	89 c7                	mov    %eax,%edi
  8026db:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  8026e2:	00 00 00 
  8026e5:	ff d0                	callq  *%rax
  8026e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ee:	78 0a                	js     8026fa <fd_close+0x4c>
	    || fd != fd2)
  8026f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026f8:	74 12                	je     80270c <fd_close+0x5e>
		return (must_exist ? r : 0);
  8026fa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8026fe:	74 05                	je     802705 <fd_close+0x57>
  802700:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802703:	eb 05                	jmp    80270a <fd_close+0x5c>
  802705:	b8 00 00 00 00       	mov    $0x0,%eax
  80270a:	eb 69                	jmp    802775 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80270c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802710:	8b 00                	mov    (%rax),%eax
  802712:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802716:	48 89 d6             	mov    %rdx,%rsi
  802719:	89 c7                	mov    %eax,%edi
  80271b:	48 b8 77 27 80 00 00 	movabs $0x802777,%rax
  802722:	00 00 00 
  802725:	ff d0                	callq  *%rax
  802727:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80272a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80272e:	78 2a                	js     80275a <fd_close+0xac>
		if (dev->dev_close)
  802730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802734:	48 8b 40 20          	mov    0x20(%rax),%rax
  802738:	48 85 c0             	test   %rax,%rax
  80273b:	74 16                	je     802753 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80273d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802741:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802749:	48 89 c7             	mov    %rax,%rdi
  80274c:	ff d2                	callq  *%rdx
  80274e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802751:	eb 07                	jmp    80275a <fd_close+0xac>
		else
			r = 0;
  802753:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80275a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80275e:	48 89 c6             	mov    %rax,%rsi
  802761:	bf 00 00 00 00       	mov    $0x0,%edi
  802766:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
	return r;
  802772:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802775:	c9                   	leaveq 
  802776:	c3                   	retq   

0000000000802777 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802777:	55                   	push   %rbp
  802778:	48 89 e5             	mov    %rsp,%rbp
  80277b:	48 83 ec 20          	sub    $0x20,%rsp
  80277f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802782:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802786:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80278d:	eb 41                	jmp    8027d0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80278f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802796:	00 00 00 
  802799:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80279c:	48 63 d2             	movslq %edx,%rdx
  80279f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027a3:	8b 00                	mov    (%rax),%eax
  8027a5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8027a8:	75 22                	jne    8027cc <dev_lookup+0x55>
			*dev = devtab[i];
  8027aa:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027b1:	00 00 00 
  8027b4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027b7:	48 63 d2             	movslq %edx,%rdx
  8027ba:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ca:	eb 60                	jmp    80282c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8027cc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8027d0:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8027d7:	00 00 00 
  8027da:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027dd:	48 63 d2             	movslq %edx,%rdx
  8027e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027e4:	48 85 c0             	test   %rax,%rax
  8027e7:	75 a6                	jne    80278f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8027e9:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  8027f0:	00 00 00 
  8027f3:	48 8b 00             	mov    (%rax),%rax
  8027f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027fc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8027ff:	89 c6                	mov    %eax,%esi
  802801:	48 bf 98 4f 80 00 00 	movabs $0x804f98,%rdi
  802808:	00 00 00 
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
  802810:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802817:	00 00 00 
  80281a:	ff d1                	callq  *%rcx
	*dev = 0;
  80281c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802820:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802827:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80282c:	c9                   	leaveq 
  80282d:	c3                   	retq   

000000000080282e <close>:

int
close(int fdnum)
{
  80282e:	55                   	push   %rbp
  80282f:	48 89 e5             	mov    %rsp,%rbp
  802832:	48 83 ec 20          	sub    $0x20,%rsp
  802836:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802839:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80283d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802840:	48 89 d6             	mov    %rdx,%rsi
  802843:	89 c7                	mov    %eax,%edi
  802845:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802854:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802858:	79 05                	jns    80285f <close+0x31>
		return r;
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	eb 18                	jmp    802877 <close+0x49>
	else
		return fd_close(fd, 1);
  80285f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802863:	be 01 00 00 00       	mov    $0x1,%esi
  802868:	48 89 c7             	mov    %rax,%rdi
  80286b:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802872:	00 00 00 
  802875:	ff d0                	callq  *%rax
}
  802877:	c9                   	leaveq 
  802878:	c3                   	retq   

0000000000802879 <close_all>:

void
close_all(void)
{
  802879:	55                   	push   %rbp
  80287a:	48 89 e5             	mov    %rsp,%rbp
  80287d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802888:	eb 15                	jmp    80289f <close_all+0x26>
		close(i);
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	89 c7                	mov    %eax,%edi
  80288f:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802896:	00 00 00 
  802899:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80289b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80289f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028a3:	7e e5                	jle    80288a <close_all+0x11>
		close(i);
}
  8028a5:	c9                   	leaveq 
  8028a6:	c3                   	retq   

00000000008028a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8028a7:	55                   	push   %rbp
  8028a8:	48 89 e5             	mov    %rsp,%rbp
  8028ab:	48 83 ec 40          	sub    $0x40,%rsp
  8028af:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8028b2:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8028b5:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8028b9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028bc:	48 89 d6             	mov    %rdx,%rsi
  8028bf:	89 c7                	mov    %eax,%edi
  8028c1:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  8028c8:	00 00 00 
  8028cb:	ff d0                	callq  *%rax
  8028cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d4:	79 08                	jns    8028de <dup+0x37>
		return r;
  8028d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d9:	e9 70 01 00 00       	jmpq   802a4e <dup+0x1a7>
	close(newfdnum);
  8028de:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028e1:	89 c7                	mov    %eax,%edi
  8028e3:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8028ef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8028f2:	48 98                	cltq   
  8028f4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028fa:	48 c1 e0 0c          	shl    $0xc,%rax
  8028fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802906:	48 89 c7             	mov    %rax,%rdi
  802909:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
  802915:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	48 89 c7             	mov    %rax,%rdi
  802920:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  802927:	00 00 00 
  80292a:	ff d0                	callq  *%rax
  80292c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802934:	48 89 c2             	mov    %rax,%rdx
  802937:	48 c1 ea 15          	shr    $0x15,%rdx
  80293b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802942:	01 00 00 
  802945:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802949:	83 e0 01             	and    $0x1,%eax
  80294c:	84 c0                	test   %al,%al
  80294e:	74 71                	je     8029c1 <dup+0x11a>
  802950:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802954:	48 89 c2             	mov    %rax,%rdx
  802957:	48 c1 ea 0c          	shr    $0xc,%rdx
  80295b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802962:	01 00 00 
  802965:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802969:	83 e0 01             	and    $0x1,%eax
  80296c:	84 c0                	test   %al,%al
  80296e:	74 51                	je     8029c1 <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802974:	48 89 c2             	mov    %rax,%rdx
  802977:	48 c1 ea 0c          	shr    $0xc,%rdx
  80297b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802982:	01 00 00 
  802985:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802989:	89 c1                	mov    %eax,%ecx
  80298b:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802991:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802995:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802999:	41 89 c8             	mov    %ecx,%r8d
  80299c:	48 89 d1             	mov    %rdx,%rcx
  80299f:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a4:	48 89 c6             	mov    %rax,%rsi
  8029a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ac:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  8029b3:	00 00 00 
  8029b6:	ff d0                	callq  *%rax
  8029b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029bf:	78 56                	js     802a17 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c5:	48 89 c2             	mov    %rax,%rdx
  8029c8:	48 c1 ea 0c          	shr    $0xc,%rdx
  8029cc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8029d3:	01 00 00 
  8029d6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029da:	89 c1                	mov    %eax,%ecx
  8029dc:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8029e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029ea:	41 89 c8             	mov    %ecx,%r8d
  8029ed:	48 89 d1             	mov    %rdx,%rcx
  8029f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029f5:	48 89 c6             	mov    %rax,%rsi
  8029f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fd:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  802a04:	00 00 00 
  802a07:	ff d0                	callq  *%rax
  802a09:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a10:	78 08                	js     802a1a <dup+0x173>
		goto err;

	return newfdnum;
  802a12:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a15:	eb 37                	jmp    802a4e <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802a17:	90                   	nop
  802a18:	eb 01                	jmp    802a1b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802a1a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802a1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a1f:	48 89 c6             	mov    %rax,%rsi
  802a22:	bf 00 00 00 00       	mov    $0x0,%edi
  802a27:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  802a2e:	00 00 00 
  802a31:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802a33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a37:	48 89 c6             	mov    %rax,%rsi
  802a3a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a3f:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  802a46:	00 00 00 
  802a49:	ff d0                	callq  *%rax
	return r;
  802a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a4e:	c9                   	leaveq 
  802a4f:	c3                   	retq   

0000000000802a50 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a50:	55                   	push   %rbp
  802a51:	48 89 e5             	mov    %rsp,%rbp
  802a54:	48 83 ec 40          	sub    $0x40,%rsp
  802a58:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a5b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a5f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a6a:	48 89 d6             	mov    %rdx,%rsi
  802a6d:	89 c7                	mov    %eax,%edi
  802a6f:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802a76:	00 00 00 
  802a79:	ff d0                	callq  *%rax
  802a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a82:	78 24                	js     802aa8 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a88:	8b 00                	mov    (%rax),%eax
  802a8a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a8e:	48 89 d6             	mov    %rdx,%rsi
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	48 b8 77 27 80 00 00 	movabs $0x802777,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa6:	79 05                	jns    802aad <read+0x5d>
		return r;
  802aa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aab:	eb 7a                	jmp    802b27 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab1:	8b 40 08             	mov    0x8(%rax),%eax
  802ab4:	83 e0 03             	and    $0x3,%eax
  802ab7:	83 f8 01             	cmp    $0x1,%eax
  802aba:	75 3a                	jne    802af6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802abc:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  802ac3:	00 00 00 
  802ac6:	48 8b 00             	mov    (%rax),%rax
  802ac9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802acf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ad2:	89 c6                	mov    %eax,%esi
  802ad4:	48 bf b7 4f 80 00 00 	movabs $0x804fb7,%rdi
  802adb:	00 00 00 
  802ade:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae3:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802aea:	00 00 00 
  802aed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802aef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802af4:	eb 31                	jmp    802b27 <read+0xd7>
	}
	if (!dev->dev_read)
  802af6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802afa:	48 8b 40 10          	mov    0x10(%rax),%rax
  802afe:	48 85 c0             	test   %rax,%rax
  802b01:	75 07                	jne    802b0a <read+0xba>
		return -E_NOT_SUPP;
  802b03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802b08:	eb 1d                	jmp    802b27 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  802b0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b0e:	4c 8b 40 10          	mov    0x10(%rax),%r8
  802b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802b1a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b1e:	48 89 ce             	mov    %rcx,%rsi
  802b21:	48 89 c7             	mov    %rax,%rdi
  802b24:	41 ff d0             	callq  *%r8
}
  802b27:	c9                   	leaveq 
  802b28:	c3                   	retq   

0000000000802b29 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802b29:	55                   	push   %rbp
  802b2a:	48 89 e5             	mov    %rsp,%rbp
  802b2d:	48 83 ec 30          	sub    $0x30,%rsp
  802b31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b38:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b43:	eb 46                	jmp    802b8b <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802b45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b48:	48 98                	cltq   
  802b4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b4e:	48 29 c2             	sub    %rax,%rdx
  802b51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b54:	48 98                	cltq   
  802b56:	48 89 c1             	mov    %rax,%rcx
  802b59:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  802b5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b60:	48 89 ce             	mov    %rcx,%rsi
  802b63:	89 c7                	mov    %eax,%edi
  802b65:	48 b8 50 2a 80 00 00 	movabs $0x802a50,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802b74:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b78:	79 05                	jns    802b7f <readn+0x56>
			return m;
  802b7a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b7d:	eb 1d                	jmp    802b9c <readn+0x73>
		if (m == 0)
  802b7f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802b83:	74 13                	je     802b98 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802b85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b88:	01 45 fc             	add    %eax,-0x4(%rbp)
  802b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8e:	48 98                	cltq   
  802b90:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b94:	72 af                	jb     802b45 <readn+0x1c>
  802b96:	eb 01                	jmp    802b99 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802b98:	90                   	nop
	}
	return tot;
  802b99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b9c:	c9                   	leaveq 
  802b9d:	c3                   	retq   

0000000000802b9e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b9e:	55                   	push   %rbp
  802b9f:	48 89 e5             	mov    %rsp,%rbp
  802ba2:	48 83 ec 40          	sub    $0x40,%rsp
  802ba6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ba9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bb1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bb5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bb8:	48 89 d6             	mov    %rdx,%rsi
  802bbb:	89 c7                	mov    %eax,%edi
  802bbd:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax
  802bc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd0:	78 24                	js     802bf6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd6:	8b 00                	mov    (%rax),%eax
  802bd8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bdc:	48 89 d6             	mov    %rdx,%rsi
  802bdf:	89 c7                	mov    %eax,%edi
  802be1:	48 b8 77 27 80 00 00 	movabs $0x802777,%rax
  802be8:	00 00 00 
  802beb:	ff d0                	callq  *%rax
  802bed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf4:	79 05                	jns    802bfb <write+0x5d>
		return r;
  802bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bf9:	eb 79                	jmp    802c74 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bff:	8b 40 08             	mov    0x8(%rax),%eax
  802c02:	83 e0 03             	and    $0x3,%eax
  802c05:	85 c0                	test   %eax,%eax
  802c07:	75 3a                	jne    802c43 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802c09:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  802c10:	00 00 00 
  802c13:	48 8b 00             	mov    (%rax),%rax
  802c16:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c1c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c1f:	89 c6                	mov    %eax,%esi
  802c21:	48 bf d3 4f 80 00 00 	movabs $0x804fd3,%rdi
  802c28:	00 00 00 
  802c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c30:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802c37:	00 00 00 
  802c3a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c41:	eb 31                	jmp    802c74 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c47:	48 8b 40 18          	mov    0x18(%rax),%rax
  802c4b:	48 85 c0             	test   %rax,%rax
  802c4e:	75 07                	jne    802c57 <write+0xb9>
		return -E_NOT_SUPP;
  802c50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c55:	eb 1d                	jmp    802c74 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  802c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c5b:	4c 8b 40 18          	mov    0x18(%rax),%r8
  802c5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c63:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c67:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c6b:	48 89 ce             	mov    %rcx,%rsi
  802c6e:	48 89 c7             	mov    %rax,%rdi
  802c71:	41 ff d0             	callq  *%r8
}
  802c74:	c9                   	leaveq 
  802c75:	c3                   	retq   

0000000000802c76 <seek>:

int
seek(int fdnum, off_t offset)
{
  802c76:	55                   	push   %rbp
  802c77:	48 89 e5             	mov    %rsp,%rbp
  802c7a:	48 83 ec 18          	sub    $0x18,%rsp
  802c7e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c81:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c8b:	48 89 d6             	mov    %rdx,%rsi
  802c8e:	89 c7                	mov    %eax,%edi
  802c90:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca3:	79 05                	jns    802caa <seek+0x34>
		return r;
  802ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ca8:	eb 0f                	jmp    802cb9 <seek+0x43>
	fd->fd_offset = offset;
  802caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb9:	c9                   	leaveq 
  802cba:	c3                   	retq   

0000000000802cbb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802cbb:	55                   	push   %rbp
  802cbc:	48 89 e5             	mov    %rsp,%rbp
  802cbf:	48 83 ec 30          	sub    $0x30,%rsp
  802cc3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cc6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cc9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ccd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cd0:	48 89 d6             	mov    %rdx,%rsi
  802cd3:	89 c7                	mov    %eax,%edi
  802cd5:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
  802ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ce8:	78 24                	js     802d0e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cee:	8b 00                	mov    (%rax),%eax
  802cf0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802cf4:	48 89 d6             	mov    %rdx,%rsi
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	48 b8 77 27 80 00 00 	movabs $0x802777,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
  802d05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d0c:	79 05                	jns    802d13 <ftruncate+0x58>
		return r;
  802d0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d11:	eb 72                	jmp    802d85 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d17:	8b 40 08             	mov    0x8(%rax),%eax
  802d1a:	83 e0 03             	and    $0x3,%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	75 3a                	jne    802d5b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802d21:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  802d28:	00 00 00 
  802d2b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802d2e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d34:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d37:	89 c6                	mov    %eax,%esi
  802d39:	48 bf f0 4f 80 00 00 	movabs $0x804ff0,%rdi
  802d40:	00 00 00 
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	48 b9 3f 06 80 00 00 	movabs $0x80063f,%rcx
  802d4f:	00 00 00 
  802d52:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802d54:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d59:	eb 2a                	jmp    802d85 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802d63:	48 85 c0             	test   %rax,%rax
  802d66:	75 07                	jne    802d6f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802d68:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d6d:	eb 16                	jmp    802d85 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802d6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d73:	48 8b 48 30          	mov    0x30(%rax),%rcx
  802d77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d7b:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802d7e:	89 d6                	mov    %edx,%esi
  802d80:	48 89 c7             	mov    %rax,%rdi
  802d83:	ff d1                	callq  *%rcx
}
  802d85:	c9                   	leaveq 
  802d86:	c3                   	retq   

0000000000802d87 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802d87:	55                   	push   %rbp
  802d88:	48 89 e5             	mov    %rsp,%rbp
  802d8b:	48 83 ec 30          	sub    $0x30,%rsp
  802d8f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d92:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d96:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d9a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d9d:	48 89 d6             	mov    %rdx,%rsi
  802da0:	89 c7                	mov    %eax,%edi
  802da2:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802da9:	00 00 00 
  802dac:	ff d0                	callq  *%rax
  802dae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db5:	78 24                	js     802ddb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dbb:	8b 00                	mov    (%rax),%eax
  802dbd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802dc1:	48 89 d6             	mov    %rdx,%rsi
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 77 27 80 00 00 	movabs $0x802777,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd9:	79 05                	jns    802de0 <fstat+0x59>
		return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	eb 5e                	jmp    802e3e <fstat+0xb7>
	if (!dev->dev_stat)
  802de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802de8:	48 85 c0             	test   %rax,%rax
  802deb:	75 07                	jne    802df4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802ded:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802df2:	eb 4a                	jmp    802e3e <fstat+0xb7>
	stat->st_name[0] = 0;
  802df4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802df8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802dfb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dff:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e06:	00 00 00 
	stat->st_isdir = 0;
  802e09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e0d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e14:	00 00 00 
	stat->st_dev = dev;
  802e17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e1f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2a:	48 8b 48 28          	mov    0x28(%rax),%rcx
  802e2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e32:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802e36:	48 89 d6             	mov    %rdx,%rsi
  802e39:	48 89 c7             	mov    %rax,%rdi
  802e3c:	ff d1                	callq  *%rcx
}
  802e3e:	c9                   	leaveq 
  802e3f:	c3                   	retq   

0000000000802e40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802e40:	55                   	push   %rbp
  802e41:	48 89 e5             	mov    %rsp,%rbp
  802e44:	48 83 ec 20          	sub    $0x20,%rsp
  802e48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802e50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e54:	be 00 00 00 00       	mov    $0x0,%esi
  802e59:	48 89 c7             	mov    %rax,%rdi
  802e5c:	48 b8 2f 2f 80 00 00 	movabs $0x802f2f,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax
  802e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6f:	79 05                	jns    802e76 <stat+0x36>
		return fd;
  802e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e74:	eb 2f                	jmp    802ea5 <stat+0x65>
	r = fstat(fd, stat);
  802e76:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7d:	48 89 d6             	mov    %rdx,%rsi
  802e80:	89 c7                	mov    %eax,%edi
  802e82:	48 b8 87 2d 80 00 00 	movabs $0x802d87,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
  802e8e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e94:	89 c7                	mov    %eax,%edi
  802e96:	48 b8 2e 28 80 00 00 	movabs $0x80282e,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
	return r;
  802ea2:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ea5:	c9                   	leaveq 
  802ea6:	c3                   	retq   
	...

0000000000802ea8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802ea8:	55                   	push   %rbp
  802ea9:	48 89 e5             	mov    %rsp,%rbp
  802eac:	48 83 ec 10          	sub    $0x10,%rsp
  802eb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802eb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802eb7:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  802ebe:	00 00 00 
  802ec1:	8b 00                	mov    (%rax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	75 1d                	jne    802ee4 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ec7:	bf 01 00 00 00       	mov    $0x1,%edi
  802ecc:	48 b8 3f 46 80 00 00 	movabs $0x80463f,%rax
  802ed3:	00 00 00 
  802ed6:	ff d0                	callq  *%rax
  802ed8:	48 ba 24 80 80 00 00 	movabs $0x808024,%rdx
  802edf:	00 00 00 
  802ee2:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ee4:	48 b8 24 80 80 00 00 	movabs $0x808024,%rax
  802eeb:	00 00 00 
  802eee:	8b 00                	mov    (%rax),%eax
  802ef0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802ef3:	b9 07 00 00 00       	mov    $0x7,%ecx
  802ef8:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802eff:	00 00 00 
  802f02:	89 c7                	mov    %eax,%edi
  802f04:	48 b8 7c 45 80 00 00 	movabs $0x80457c,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802f10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f14:	ba 00 00 00 00       	mov    $0x0,%edx
  802f19:	48 89 c6             	mov    %rax,%rsi
  802f1c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f21:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
}
  802f2d:	c9                   	leaveq 
  802f2e:	c3                   	retq   

0000000000802f2f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802f2f:	55                   	push   %rbp
  802f30:	48 89 e5             	mov    %rsp,%rbp
  802f33:	48 83 ec 20          	sub    $0x20,%rsp
  802f37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f3b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  802f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f42:	48 89 c7             	mov    %rax,%rdi
  802f45:	48 b8 90 11 80 00 00 	movabs $0x801190,%rax
  802f4c:	00 00 00 
  802f4f:	ff d0                	callq  *%rax
  802f51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f56:	7e 0a                	jle    802f62 <open+0x33>
                return -E_BAD_PATH;
  802f58:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f5d:	e9 a5 00 00 00       	jmpq   803007 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  802f62:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f66:	48 89 c7             	mov    %rax,%rdi
  802f69:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
  802f70:	00 00 00 
  802f73:	ff d0                	callq  *%rax
  802f75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7c:	79 08                	jns    802f86 <open+0x57>
		return r;
  802f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f81:	e9 81 00 00 00       	jmpq   803007 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  802f86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8a:	48 89 c6             	mov    %rax,%rsi
  802f8d:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f94:	00 00 00 
  802f97:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  802f9e:	00 00 00 
  802fa1:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  802fa3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802faa:	00 00 00 
  802fad:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802fb0:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  802fb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fba:	48 89 c6             	mov    %rax,%rsi
  802fbd:	bf 01 00 00 00       	mov    $0x1,%edi
  802fc2:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  802fc9:	00 00 00 
  802fcc:	ff d0                	callq  *%rax
  802fce:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  802fd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd5:	79 1d                	jns    802ff4 <open+0xc5>
	{
		fd_close(fd,0);
  802fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdb:	be 00 00 00 00       	mov    $0x0,%esi
  802fe0:	48 89 c7             	mov    %rax,%rdi
  802fe3:	48 b8 ae 26 80 00 00 	movabs $0x8026ae,%rax
  802fea:	00 00 00 
  802fed:	ff d0                	callq  *%rax
		return r;
  802fef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff2:	eb 13                	jmp    803007 <open+0xd8>
	}
	return fd2num(fd);
  802ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff8:	48 89 c7             	mov    %rax,%rdi
  802ffb:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
	


}
  803007:	c9                   	leaveq 
  803008:	c3                   	retq   

0000000000803009 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803009:	55                   	push   %rbp
  80300a:	48 89 e5             	mov    %rsp,%rbp
  80300d:	48 83 ec 10          	sub    $0x10,%rsp
  803011:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803015:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803019:	8b 50 0c             	mov    0xc(%rax),%edx
  80301c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803023:	00 00 00 
  803026:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803028:	be 00 00 00 00       	mov    $0x0,%esi
  80302d:	bf 06 00 00 00       	mov    $0x6,%edi
  803032:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803039:	00 00 00 
  80303c:	ff d0                	callq  *%rax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	48 83 ec 30          	sub    $0x30,%rsp
  803048:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80304c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803050:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803058:	8b 50 0c             	mov    0xc(%rax),%edx
  80305b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803062:	00 00 00 
  803065:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803067:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80306e:	00 00 00 
  803071:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803075:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803079:	be 00 00 00 00       	mov    $0x0,%esi
  80307e:	bf 03 00 00 00       	mov    $0x3,%edi
  803083:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
  80308f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803092:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803096:	79 05                	jns    80309d <devfile_read+0x5d>
	{
		return r;
  803098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309b:	eb 2c                	jmp    8030c9 <devfile_read+0x89>
	}
	if(r > 0)
  80309d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a1:	7e 23                	jle    8030c6 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  8030a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a6:	48 63 d0             	movslq %eax,%rdx
  8030a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030ad:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030b4:	00 00 00 
  8030b7:	48 89 c7             	mov    %rax,%rdi
  8030ba:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  8030c1:	00 00 00 
  8030c4:	ff d0                	callq  *%rax
	return r;
  8030c6:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8030c9:	c9                   	leaveq 
  8030ca:	c3                   	retq   

00000000008030cb <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030cb:	55                   	push   %rbp
  8030cc:	48 89 e5             	mov    %rsp,%rbp
  8030cf:	48 83 ec 30          	sub    $0x30,%rsp
  8030d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8030df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e3:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ed:	00 00 00 
  8030f0:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8030f2:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8030f9:	00 
  8030fa:	76 08                	jbe    803104 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8030fc:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  803103:	00 
	fsipcbuf.write.req_n=n;
  803104:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80310b:	00 00 00 
  80310e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803112:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803116:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80311a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80311e:	48 89 c6             	mov    %rax,%rsi
  803121:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803128:	00 00 00 
  80312b:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803137:	be 00 00 00 00       	mov    $0x0,%esi
  80313c:	bf 04 00 00 00       	mov    $0x4,%edi
  803141:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803148:	00 00 00 
  80314b:	ff d0                	callq  *%rax
  80314d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  803150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803153:	c9                   	leaveq 
  803154:	c3                   	retq   

0000000000803155 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803155:	55                   	push   %rbp
  803156:	48 89 e5             	mov    %rsp,%rbp
  803159:	48 83 ec 10          	sub    $0x10,%rsp
  80315d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803161:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803168:	8b 50 0c             	mov    0xc(%rax),%edx
  80316b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803172:	00 00 00 
  803175:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  803177:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80317e:	00 00 00 
  803181:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803184:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803187:	be 00 00 00 00       	mov    $0x0,%esi
  80318c:	bf 02 00 00 00       	mov    $0x2,%edi
  803191:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  803198:	00 00 00 
  80319b:	ff d0                	callq  *%rax
}
  80319d:	c9                   	leaveq 
  80319e:	c3                   	retq   

000000000080319f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80319f:	55                   	push   %rbp
  8031a0:	48 89 e5             	mov    %rsp,%rbp
  8031a3:	48 83 ec 20          	sub    $0x20,%rsp
  8031a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8031af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031b3:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031bd:	00 00 00 
  8031c0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031c2:	be 00 00 00 00       	mov    $0x0,%esi
  8031c7:	bf 05 00 00 00       	mov    $0x5,%edi
  8031cc:	48 b8 a8 2e 80 00 00 	movabs $0x802ea8,%rax
  8031d3:	00 00 00 
  8031d6:	ff d0                	callq  *%rax
  8031d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031df:	79 05                	jns    8031e6 <devfile_stat+0x47>
		return r;
  8031e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e4:	eb 56                	jmp    80323c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ea:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031f1:	00 00 00 
  8031f4:	48 89 c7             	mov    %rax,%rdi
  8031f7:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  8031fe:	00 00 00 
  803201:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803203:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320a:	00 00 00 
  80320d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803213:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803217:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80321d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803224:	00 00 00 
  803227:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80322d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803231:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80323c:	c9                   	leaveq 
  80323d:	c3                   	retq   
	...

0000000000803240 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
  803244:	48 83 ec 20          	sub    $0x20,%rsp
  803248:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80324b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80324f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803252:	48 89 d6             	mov    %rdx,%rsi
  803255:	89 c7                	mov    %eax,%edi
  803257:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326a:	79 05                	jns    803271 <fd2sockid+0x31>
		return r;
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	eb 24                	jmp    803295 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	8b 10                	mov    (%rax),%edx
  803277:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80327e:	00 00 00 
  803281:	8b 00                	mov    (%rax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	74 07                	je     80328e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803287:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80328c:	eb 07                	jmp    803295 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80328e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803292:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803295:	c9                   	leaveq 
  803296:	c3                   	retq   

0000000000803297 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803297:	55                   	push   %rbp
  803298:	48 89 e5             	mov    %rsp,%rbp
  80329b:	48 83 ec 20          	sub    $0x20,%rsp
  80329f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8032a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032a6:	48 89 c7             	mov    %rax,%rdi
  8032a9:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bc:	78 26                	js     8032e4 <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8032c7:	48 89 c6             	mov    %rax,%rsi
  8032ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8032cf:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  8032d6:	00 00 00 
  8032d9:	ff d0                	callq  *%rax
  8032db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032e2:	79 16                	jns    8032fa <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8032e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032e7:	89 c7                	mov    %eax,%edi
  8032e9:	48 b8 a4 37 80 00 00 	movabs $0x8037a4,%rax
  8032f0:	00 00 00 
  8032f3:	ff d0                	callq  *%rax
		return r;
  8032f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f8:	eb 3a                	jmp    803334 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8032fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fe:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803305:	00 00 00 
  803308:	8b 12                	mov    (%rdx),%edx
  80330a:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  80330c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803310:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803317:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80331e:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803321:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803325:	48 89 c7             	mov    %rax,%rdi
  803328:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  80332f:	00 00 00 
  803332:	ff d0                	callq  *%rax
}
  803334:	c9                   	leaveq 
  803335:	c3                   	retq   

0000000000803336 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803336:	55                   	push   %rbp
  803337:	48 89 e5             	mov    %rsp,%rbp
  80333a:	48 83 ec 30          	sub    $0x30,%rsp
  80333e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803341:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803345:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803349:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80334c:	89 c7                	mov    %eax,%edi
  80334e:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
  80335a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803361:	79 05                	jns    803368 <accept+0x32>
		return r;
  803363:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803366:	eb 3b                	jmp    8033a3 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803368:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80336c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803373:	48 89 ce             	mov    %rcx,%rsi
  803376:	89 c7                	mov    %eax,%edi
  803378:	48 b8 81 36 80 00 00 	movabs $0x803681,%rax
  80337f:	00 00 00 
  803382:	ff d0                	callq  *%rax
  803384:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803387:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80338b:	79 05                	jns    803392 <accept+0x5c>
		return r;
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	eb 11                	jmp    8033a3 <accept+0x6d>
	return alloc_sockfd(r);
  803392:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803395:	89 c7                	mov    %eax,%edi
  803397:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  80339e:	00 00 00 
  8033a1:	ff d0                	callq  *%rax
}
  8033a3:	c9                   	leaveq 
  8033a4:	c3                   	retq   

00000000008033a5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8033a5:	55                   	push   %rbp
  8033a6:	48 89 e5             	mov    %rsp,%rbp
  8033a9:	48 83 ec 20          	sub    $0x20,%rsp
  8033ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b4:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8033b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033ba:	89 c7                	mov    %eax,%edi
  8033bc:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  8033c3:	00 00 00 
  8033c6:	ff d0                	callq  *%rax
  8033c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cf:	79 05                	jns    8033d6 <bind+0x31>
		return r;
  8033d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d4:	eb 1b                	jmp    8033f1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8033d6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8033d9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8033dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e0:	48 89 ce             	mov    %rcx,%rsi
  8033e3:	89 c7                	mov    %eax,%edi
  8033e5:	48 b8 00 37 80 00 00 	movabs $0x803700,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
}
  8033f1:	c9                   	leaveq 
  8033f2:	c3                   	retq   

00000000008033f3 <shutdown>:

int
shutdown(int s, int how)
{
  8033f3:	55                   	push   %rbp
  8033f4:	48 89 e5             	mov    %rsp,%rbp
  8033f7:	48 83 ec 20          	sub    $0x20,%rsp
  8033fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033fe:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803401:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803404:	89 c7                	mov    %eax,%edi
  803406:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
  803412:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803415:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803419:	79 05                	jns    803420 <shutdown+0x2d>
		return r;
  80341b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341e:	eb 16                	jmp    803436 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803420:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803423:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803426:	89 d6                	mov    %edx,%esi
  803428:	89 c7                	mov    %eax,%edi
  80342a:	48 b8 64 37 80 00 00 	movabs $0x803764,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
}
  803436:	c9                   	leaveq 
  803437:	c3                   	retq   

0000000000803438 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803438:	55                   	push   %rbp
  803439:	48 89 e5             	mov    %rsp,%rbp
  80343c:	48 83 ec 10          	sub    $0x10,%rsp
  803440:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803444:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803448:	48 89 c7             	mov    %rax,%rdi
  80344b:	48 b8 c4 46 80 00 00 	movabs $0x8046c4,%rax
  803452:	00 00 00 
  803455:	ff d0                	callq  *%rax
  803457:	83 f8 01             	cmp    $0x1,%eax
  80345a:	75 17                	jne    803473 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80345c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803460:	8b 40 0c             	mov    0xc(%rax),%eax
  803463:	89 c7                	mov    %eax,%edi
  803465:	48 b8 a4 37 80 00 00 	movabs $0x8037a4,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	eb 05                	jmp    803478 <devsock_close+0x40>
	else
		return 0;
  803473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803478:	c9                   	leaveq 
  803479:	c3                   	retq   

000000000080347a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80347a:	55                   	push   %rbp
  80347b:	48 89 e5             	mov    %rsp,%rbp
  80347e:	48 83 ec 20          	sub    $0x20,%rsp
  803482:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803485:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803489:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80348c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80348f:	89 c7                	mov    %eax,%edi
  803491:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  803498:	00 00 00 
  80349b:	ff d0                	callq  *%rax
  80349d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a4:	79 05                	jns    8034ab <connect+0x31>
		return r;
  8034a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a9:	eb 1b                	jmp    8034c6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8034ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034ae:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8034b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b5:	48 89 ce             	mov    %rcx,%rsi
  8034b8:	89 c7                	mov    %eax,%edi
  8034ba:	48 b8 d1 37 80 00 00 	movabs $0x8037d1,%rax
  8034c1:	00 00 00 
  8034c4:	ff d0                	callq  *%rax
}
  8034c6:	c9                   	leaveq 
  8034c7:	c3                   	retq   

00000000008034c8 <listen>:

int
listen(int s, int backlog)
{
  8034c8:	55                   	push   %rbp
  8034c9:	48 89 e5             	mov    %rsp,%rbp
  8034cc:	48 83 ec 20          	sub    $0x20,%rsp
  8034d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034d9:	89 c7                	mov    %eax,%edi
  8034db:	48 b8 40 32 80 00 00 	movabs $0x803240,%rax
  8034e2:	00 00 00 
  8034e5:	ff d0                	callq  *%rax
  8034e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034ee:	79 05                	jns    8034f5 <listen+0x2d>
		return r;
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	eb 16                	jmp    80350b <listen+0x43>
	return nsipc_listen(r, backlog);
  8034f5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8034f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fb:	89 d6                	mov    %edx,%esi
  8034fd:	89 c7                	mov    %eax,%edi
  8034ff:	48 b8 35 38 80 00 00 	movabs $0x803835,%rax
  803506:	00 00 00 
  803509:	ff d0                	callq  *%rax
}
  80350b:	c9                   	leaveq 
  80350c:	c3                   	retq   

000000000080350d <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80350d:	55                   	push   %rbp
  80350e:	48 89 e5             	mov    %rsp,%rbp
  803511:	48 83 ec 20          	sub    $0x20,%rsp
  803515:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803519:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80351d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803525:	89 c2                	mov    %eax,%edx
  803527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80352b:	8b 40 0c             	mov    0xc(%rax),%eax
  80352e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803532:	b9 00 00 00 00       	mov    $0x0,%ecx
  803537:	89 c7                	mov    %eax,%edi
  803539:	48 b8 75 38 80 00 00 	movabs $0x803875,%rax
  803540:	00 00 00 
  803543:	ff d0                	callq  *%rax
}
  803545:	c9                   	leaveq 
  803546:	c3                   	retq   

0000000000803547 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803547:	55                   	push   %rbp
  803548:	48 89 e5             	mov    %rsp,%rbp
  80354b:	48 83 ec 20          	sub    $0x20,%rsp
  80354f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803553:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803557:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80355b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80355f:	89 c2                	mov    %eax,%edx
  803561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803565:	8b 40 0c             	mov    0xc(%rax),%eax
  803568:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80356c:	b9 00 00 00 00       	mov    $0x0,%ecx
  803571:	89 c7                	mov    %eax,%edi
  803573:	48 b8 41 39 80 00 00 	movabs $0x803941,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
}
  80357f:	c9                   	leaveq 
  803580:	c3                   	retq   

0000000000803581 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803581:	55                   	push   %rbp
  803582:	48 89 e5             	mov    %rsp,%rbp
  803585:	48 83 ec 10          	sub    $0x10,%rsp
  803589:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80358d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803595:	48 be 1b 50 80 00 00 	movabs $0x80501b,%rsi
  80359c:	00 00 00 
  80359f:	48 89 c7             	mov    %rax,%rdi
  8035a2:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  8035a9:	00 00 00 
  8035ac:	ff d0                	callq  *%rax
	return 0;
  8035ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035b3:	c9                   	leaveq 
  8035b4:	c3                   	retq   

00000000008035b5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8035b5:	55                   	push   %rbp
  8035b6:	48 89 e5             	mov    %rsp,%rbp
  8035b9:	48 83 ec 20          	sub    $0x20,%rsp
  8035bd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035c0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8035c3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035c6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8035c9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8035cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035cf:	89 ce                	mov    %ecx,%esi
  8035d1:	89 c7                	mov    %eax,%edi
  8035d3:	48 b8 f9 39 80 00 00 	movabs $0x8039f9,%rax
  8035da:	00 00 00 
  8035dd:	ff d0                	callq  *%rax
  8035df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e6:	79 05                	jns    8035ed <socket+0x38>
		return r;
  8035e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035eb:	eb 11                	jmp    8035fe <socket+0x49>
	return alloc_sockfd(r);
  8035ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035f0:	89 c7                	mov    %eax,%edi
  8035f2:	48 b8 97 32 80 00 00 	movabs $0x803297,%rax
  8035f9:	00 00 00 
  8035fc:	ff d0                	callq  *%rax
}
  8035fe:	c9                   	leaveq 
  8035ff:	c3                   	retq   

0000000000803600 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803600:	55                   	push   %rbp
  803601:	48 89 e5             	mov    %rsp,%rbp
  803604:	48 83 ec 10          	sub    $0x10,%rsp
  803608:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  80360b:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  803612:	00 00 00 
  803615:	8b 00                	mov    (%rax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	75 1d                	jne    803638 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80361b:	bf 02 00 00 00       	mov    $0x2,%edi
  803620:	48 b8 3f 46 80 00 00 	movabs $0x80463f,%rax
  803627:	00 00 00 
  80362a:	ff d0                	callq  *%rax
  80362c:	48 ba 30 80 80 00 00 	movabs $0x808030,%rdx
  803633:	00 00 00 
  803636:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803638:	48 b8 30 80 80 00 00 	movabs $0x808030,%rax
  80363f:	00 00 00 
  803642:	8b 00                	mov    (%rax),%eax
  803644:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803647:	b9 07 00 00 00       	mov    $0x7,%ecx
  80364c:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803653:	00 00 00 
  803656:	89 c7                	mov    %eax,%edi
  803658:	48 b8 7c 45 80 00 00 	movabs $0x80457c,%rax
  80365f:	00 00 00 
  803662:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803664:	ba 00 00 00 00       	mov    $0x0,%edx
  803669:	be 00 00 00 00       	mov    $0x0,%esi
  80366e:	bf 00 00 00 00       	mov    $0x0,%edi
  803673:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  80367a:	00 00 00 
  80367d:	ff d0                	callq  *%rax
}
  80367f:	c9                   	leaveq 
  803680:	c3                   	retq   

0000000000803681 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803681:	55                   	push   %rbp
  803682:	48 89 e5             	mov    %rsp,%rbp
  803685:	48 83 ec 30          	sub    $0x30,%rsp
  803689:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80368c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803690:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803694:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80369b:	00 00 00 
  80369e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036a1:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8036a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8036a8:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
  8036b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bb:	78 3e                	js     8036fb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8036bd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8036c4:	00 00 00 
  8036c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8036cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cf:	8b 40 10             	mov    0x10(%rax),%eax
  8036d2:	89 c2                	mov    %eax,%edx
  8036d4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8036d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036dc:	48 89 ce             	mov    %rcx,%rsi
  8036df:	48 89 c7             	mov    %rax,%rdi
  8036e2:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8036ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f2:	8b 50 10             	mov    0x10(%rax),%edx
  8036f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036f9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8036fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8036fe:	c9                   	leaveq 
  8036ff:	c3                   	retq   

0000000000803700 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803700:	55                   	push   %rbp
  803701:	48 89 e5             	mov    %rsp,%rbp
  803704:	48 83 ec 10          	sub    $0x10,%rsp
  803708:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80370b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80370f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803712:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803719:	00 00 00 
  80371c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80371f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803721:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803728:	48 89 c6             	mov    %rax,%rsi
  80372b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803732:	00 00 00 
  803735:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  80373c:	00 00 00 
  80373f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803741:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803748:	00 00 00 
  80374b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80374e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803751:	bf 02 00 00 00       	mov    $0x2,%edi
  803756:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
}
  803762:	c9                   	leaveq 
  803763:	c3                   	retq   

0000000000803764 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803764:	55                   	push   %rbp
  803765:	48 89 e5             	mov    %rsp,%rbp
  803768:	48 83 ec 10          	sub    $0x10,%rsp
  80376c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80376f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803772:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803779:	00 00 00 
  80377c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80377f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803781:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803788:	00 00 00 
  80378b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80378e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803791:	bf 03 00 00 00       	mov    $0x3,%edi
  803796:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  80379d:	00 00 00 
  8037a0:	ff d0                	callq  *%rax
}
  8037a2:	c9                   	leaveq 
  8037a3:	c3                   	retq   

00000000008037a4 <nsipc_close>:

int
nsipc_close(int s)
{
  8037a4:	55                   	push   %rbp
  8037a5:	48 89 e5             	mov    %rsp,%rbp
  8037a8:	48 83 ec 10          	sub    $0x10,%rsp
  8037ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8037af:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037b6:	00 00 00 
  8037b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037bc:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8037be:	bf 04 00 00 00       	mov    $0x4,%edi
  8037c3:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  8037ca:	00 00 00 
  8037cd:	ff d0                	callq  *%rax
}
  8037cf:	c9                   	leaveq 
  8037d0:	c3                   	retq   

00000000008037d1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8037d1:	55                   	push   %rbp
  8037d2:	48 89 e5             	mov    %rsp,%rbp
  8037d5:	48 83 ec 10          	sub    $0x10,%rsp
  8037d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8037dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8037e0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8037e3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8037ea:	00 00 00 
  8037ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8037f0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8037f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8037f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f9:	48 89 c6             	mov    %rax,%rsi
  8037fc:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803803:	00 00 00 
  803806:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  80380d:	00 00 00 
  803810:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803812:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803819:	00 00 00 
  80381c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80381f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803822:	bf 05 00 00 00       	mov    $0x5,%edi
  803827:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  80382e:	00 00 00 
  803831:	ff d0                	callq  *%rax
}
  803833:	c9                   	leaveq 
  803834:	c3                   	retq   

0000000000803835 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803835:	55                   	push   %rbp
  803836:	48 89 e5             	mov    %rsp,%rbp
  803839:	48 83 ec 10          	sub    $0x10,%rsp
  80383d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803840:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803843:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80384a:	00 00 00 
  80384d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803850:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803852:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803859:	00 00 00 
  80385c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80385f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803862:	bf 06 00 00 00       	mov    $0x6,%edi
  803867:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 30          	sub    $0x30,%rsp
  80387d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803880:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803884:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803887:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80388a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803891:	00 00 00 
  803894:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803897:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803899:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038a0:	00 00 00 
  8038a3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038a6:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8038a9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8038b0:	00 00 00 
  8038b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8038b6:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8038b9:	bf 07 00 00 00       	mov    $0x7,%edi
  8038be:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
  8038ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038d1:	78 69                	js     80393c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8038d3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8038da:	7f 08                	jg     8038e4 <nsipc_recv+0x6f>
  8038dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038df:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8038e2:	7e 35                	jle    803919 <nsipc_recv+0xa4>
  8038e4:	48 b9 22 50 80 00 00 	movabs $0x805022,%rcx
  8038eb:	00 00 00 
  8038ee:	48 ba 37 50 80 00 00 	movabs $0x805037,%rdx
  8038f5:	00 00 00 
  8038f8:	be 61 00 00 00       	mov    $0x61,%esi
  8038fd:	48 bf 4c 50 80 00 00 	movabs $0x80504c,%rdi
  803904:	00 00 00 
  803907:	b8 00 00 00 00       	mov    $0x0,%eax
  80390c:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  803913:	00 00 00 
  803916:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803919:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391c:	48 63 d0             	movslq %eax,%rdx
  80391f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803923:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80392a:	00 00 00 
  80392d:	48 89 c7             	mov    %rax,%rdi
  803930:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
	}

	return r;
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80393f:	c9                   	leaveq 
  803940:	c3                   	retq   

0000000000803941 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803941:	55                   	push   %rbp
  803942:	48 89 e5             	mov    %rsp,%rbp
  803945:	48 83 ec 20          	sub    $0x20,%rsp
  803949:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80394c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803950:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803953:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803956:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80395d:	00 00 00 
  803960:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803963:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803965:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80396c:	7e 35                	jle    8039a3 <nsipc_send+0x62>
  80396e:	48 b9 58 50 80 00 00 	movabs $0x805058,%rcx
  803975:	00 00 00 
  803978:	48 ba 37 50 80 00 00 	movabs $0x805037,%rdx
  80397f:	00 00 00 
  803982:	be 6c 00 00 00       	mov    $0x6c,%esi
  803987:	48 bf 4c 50 80 00 00 	movabs $0x80504c,%rdi
  80398e:	00 00 00 
  803991:	b8 00 00 00 00       	mov    $0x0,%eax
  803996:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  80399d:	00 00 00 
  8039a0:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8039a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039a6:	48 63 d0             	movslq %eax,%rdx
  8039a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ad:	48 89 c6             	mov    %rax,%rsi
  8039b0:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8039b7:	00 00 00 
  8039ba:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  8039c1:	00 00 00 
  8039c4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8039c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039cd:	00 00 00 
  8039d0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8039d3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8039d6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8039dd:	00 00 00 
  8039e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039e3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8039e6:	bf 08 00 00 00       	mov    $0x8,%edi
  8039eb:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  8039f2:	00 00 00 
  8039f5:	ff d0                	callq  *%rax
}
  8039f7:	c9                   	leaveq 
  8039f8:	c3                   	retq   

00000000008039f9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8039f9:	55                   	push   %rbp
  8039fa:	48 89 e5             	mov    %rsp,%rbp
  8039fd:	48 83 ec 10          	sub    $0x10,%rsp
  803a01:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a04:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803a07:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803a0a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a11:	00 00 00 
  803a14:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a17:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803a19:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a20:	00 00 00 
  803a23:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803a26:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803a29:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a30:	00 00 00 
  803a33:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803a36:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803a39:	bf 09 00 00 00       	mov    $0x9,%edi
  803a3e:	48 b8 00 36 80 00 00 	movabs $0x803600,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
}
  803a4a:	c9                   	leaveq 
  803a4b:	c3                   	retq   

0000000000803a4c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a4c:	55                   	push   %rbp
  803a4d:	48 89 e5             	mov    %rsp,%rbp
  803a50:	53                   	push   %rbx
  803a51:	48 83 ec 38          	sub    $0x38,%rsp
  803a55:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a59:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803a5d:	48 89 c7             	mov    %rax,%rdi
  803a60:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
  803a67:	00 00 00 
  803a6a:	ff d0                	callq  *%rax
  803a6c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a73:	0f 88 bf 01 00 00    	js     803c38 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a79:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a7d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a82:	48 89 c6             	mov    %rax,%rsi
  803a85:	bf 00 00 00 00       	mov    $0x0,%edi
  803a8a:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a9d:	0f 88 95 01 00 00    	js     803c38 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803aa3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803aa7:	48 89 c7             	mov    %rax,%rdi
  803aaa:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
  803ab1:	00 00 00 
  803ab4:	ff d0                	callq  *%rax
  803ab6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ab9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803abd:	0f 88 5d 01 00 00    	js     803c20 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ac3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ac7:	ba 07 04 00 00       	mov    $0x407,%edx
  803acc:	48 89 c6             	mov    %rax,%rsi
  803acf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad4:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  803adb:	00 00 00 
  803ade:	ff d0                	callq  *%rax
  803ae0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ae7:	0f 88 33 01 00 00    	js     803c20 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803af1:	48 89 c7             	mov    %rax,%rdi
  803af4:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803afb:	00 00 00 
  803afe:	ff d0                	callq  *%rax
  803b00:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b08:	ba 07 04 00 00       	mov    $0x407,%edx
  803b0d:	48 89 c6             	mov    %rax,%rsi
  803b10:	bf 00 00 00 00       	mov    $0x0,%edi
  803b15:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
  803b21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b28:	0f 88 d9 00 00 00    	js     803c07 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803b2e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b32:	48 89 c7             	mov    %rax,%rdi
  803b35:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803b3c:	00 00 00 
  803b3f:	ff d0                	callq  *%rax
  803b41:	48 89 c2             	mov    %rax,%rdx
  803b44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b48:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803b4e:	48 89 d1             	mov    %rdx,%rcx
  803b51:	ba 00 00 00 00       	mov    $0x0,%edx
  803b56:	48 89 c6             	mov    %rax,%rsi
  803b59:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5e:	48 b8 84 1b 80 00 00 	movabs $0x801b84,%rax
  803b65:	00 00 00 
  803b68:	ff d0                	callq  *%rax
  803b6a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b71:	78 79                	js     803bec <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b77:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803b7e:	00 00 00 
  803b81:	8b 12                	mov    (%rdx),%edx
  803b83:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803b85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b94:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803b9b:	00 00 00 
  803b9e:	8b 12                	mov    (%rdx),%edx
  803ba0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ba2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ba6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803bad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bb1:	48 89 c7             	mov    %rax,%rdi
  803bb4:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
  803bc0:	89 c2                	mov    %eax,%edx
  803bc2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bc6:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803bc8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803bcc:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803bd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd4:	48 89 c7             	mov    %rax,%rdi
  803bd7:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
  803bde:	00 00 00 
  803be1:	ff d0                	callq  *%rax
  803be3:	89 03                	mov    %eax,(%rbx)
	return 0;
  803be5:	b8 00 00 00 00       	mov    $0x0,%eax
  803bea:	eb 4f                	jmp    803c3b <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803bec:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  803bed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bf1:	48 89 c6             	mov    %rax,%rsi
  803bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  803bf9:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803c00:	00 00 00 
  803c03:	ff d0                	callq  *%rax
  803c05:	eb 01                	jmp    803c08 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803c07:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  803c08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c0c:	48 89 c6             	mov    %rax,%rsi
  803c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c14:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803c1b:	00 00 00 
  803c1e:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  803c20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c24:	48 89 c6             	mov    %rax,%rsi
  803c27:	bf 00 00 00 00       	mov    $0x0,%edi
  803c2c:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803c33:	00 00 00 
  803c36:	ff d0                	callq  *%rax
    err:
	return r;
  803c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803c3b:	48 83 c4 38          	add    $0x38,%rsp
  803c3f:	5b                   	pop    %rbx
  803c40:	5d                   	pop    %rbp
  803c41:	c3                   	retq   

0000000000803c42 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803c42:	55                   	push   %rbp
  803c43:	48 89 e5             	mov    %rsp,%rbp
  803c46:	53                   	push   %rbx
  803c47:	48 83 ec 28          	sub    $0x28,%rsp
  803c4b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803c4f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803c53:	eb 01                	jmp    803c56 <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  803c55:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803c56:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  803c5d:	00 00 00 
  803c60:	48 8b 00             	mov    (%rax),%rax
  803c63:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c69:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c70:	48 89 c7             	mov    %rax,%rdi
  803c73:	48 b8 c4 46 80 00 00 	movabs $0x8046c4,%rax
  803c7a:	00 00 00 
  803c7d:	ff d0                	callq  *%rax
  803c7f:	89 c3                	mov    %eax,%ebx
  803c81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c85:	48 89 c7             	mov    %rax,%rdi
  803c88:	48 b8 c4 46 80 00 00 	movabs $0x8046c4,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	39 c3                	cmp    %eax,%ebx
  803c96:	0f 94 c0             	sete   %al
  803c99:	0f b6 c0             	movzbl %al,%eax
  803c9c:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803c9f:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  803ca6:	00 00 00 
  803ca9:	48 8b 00             	mov    (%rax),%rax
  803cac:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803cb2:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803cb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb8:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803cbb:	75 0a                	jne    803cc7 <_pipeisclosed+0x85>
			return ret;
  803cbd:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  803cc0:	48 83 c4 28          	add    $0x28,%rsp
  803cc4:	5b                   	pop    %rbx
  803cc5:	5d                   	pop    %rbp
  803cc6:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803cc7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cca:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803ccd:	74 86                	je     803c55 <_pipeisclosed+0x13>
  803ccf:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803cd3:	75 80                	jne    803c55 <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803cd5:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  803cdc:	00 00 00 
  803cdf:	48 8b 00             	mov    (%rax),%rax
  803ce2:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803ce8:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803ceb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cee:	89 c6                	mov    %eax,%esi
  803cf0:	48 bf 69 50 80 00 00 	movabs $0x805069,%rdi
  803cf7:	00 00 00 
  803cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803cff:	49 b8 3f 06 80 00 00 	movabs $0x80063f,%r8
  803d06:	00 00 00 
  803d09:	41 ff d0             	callq  *%r8
	}
  803d0c:	e9 44 ff ff ff       	jmpq   803c55 <_pipeisclosed+0x13>

0000000000803d11 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  803d11:	55                   	push   %rbp
  803d12:	48 89 e5             	mov    %rsp,%rbp
  803d15:	48 83 ec 30          	sub    $0x30,%rsp
  803d19:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803d1c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803d20:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803d23:	48 89 d6             	mov    %rdx,%rsi
  803d26:	89 c7                	mov    %eax,%edi
  803d28:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  803d2f:	00 00 00 
  803d32:	ff d0                	callq  *%rax
  803d34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3b:	79 05                	jns    803d42 <pipeisclosed+0x31>
		return r;
  803d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d40:	eb 31                	jmp    803d73 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803d42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d46:	48 89 c7             	mov    %rax,%rdi
  803d49:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803d50:	00 00 00 
  803d53:	ff d0                	callq  *%rax
  803d55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d61:	48 89 d6             	mov    %rdx,%rsi
  803d64:	48 89 c7             	mov    %rax,%rdi
  803d67:	48 b8 42 3c 80 00 00 	movabs $0x803c42,%rax
  803d6e:	00 00 00 
  803d71:	ff d0                	callq  *%rax
}
  803d73:	c9                   	leaveq 
  803d74:	c3                   	retq   

0000000000803d75 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d75:	55                   	push   %rbp
  803d76:	48 89 e5             	mov    %rsp,%rbp
  803d79:	48 83 ec 40          	sub    $0x40,%rsp
  803d7d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d81:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d85:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803d89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d8d:	48 89 c7             	mov    %rax,%rdi
  803d90:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803d97:	00 00 00 
  803d9a:	ff d0                	callq  *%rax
  803d9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803da0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803da8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803daf:	00 
  803db0:	e9 97 00 00 00       	jmpq   803e4c <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803db5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803dba:	74 09                	je     803dc5 <devpipe_read+0x50>
				return i;
  803dbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dc0:	e9 95 00 00 00       	jmpq   803e5a <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803dc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dc9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dcd:	48 89 d6             	mov    %rdx,%rsi
  803dd0:	48 89 c7             	mov    %rax,%rdi
  803dd3:	48 b8 42 3c 80 00 00 	movabs $0x803c42,%rax
  803dda:	00 00 00 
  803ddd:	ff d0                	callq  *%rax
  803ddf:	85 c0                	test   %eax,%eax
  803de1:	74 07                	je     803dea <devpipe_read+0x75>
				return 0;
  803de3:	b8 00 00 00 00       	mov    $0x0,%eax
  803de8:	eb 70                	jmp    803e5a <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803dea:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803df1:	00 00 00 
  803df4:	ff d0                	callq  *%rax
  803df6:	eb 01                	jmp    803df9 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803df8:	90                   	nop
  803df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dfd:	8b 10                	mov    (%rax),%edx
  803dff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e03:	8b 40 04             	mov    0x4(%rax),%eax
  803e06:	39 c2                	cmp    %eax,%edx
  803e08:	74 ab                	je     803db5 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803e12:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803e16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e1a:	8b 00                	mov    (%rax),%eax
  803e1c:	89 c2                	mov    %eax,%edx
  803e1e:	c1 fa 1f             	sar    $0x1f,%edx
  803e21:	c1 ea 1b             	shr    $0x1b,%edx
  803e24:	01 d0                	add    %edx,%eax
  803e26:	83 e0 1f             	and    $0x1f,%eax
  803e29:	29 d0                	sub    %edx,%eax
  803e2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e2f:	48 98                	cltq   
  803e31:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803e36:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e3c:	8b 00                	mov    (%rax),%eax
  803e3e:	8d 50 01             	lea    0x1(%rax),%edx
  803e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e45:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e47:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e50:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e54:	72 a2                	jb     803df8 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e5a:	c9                   	leaveq 
  803e5b:	c3                   	retq   

0000000000803e5c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803e5c:	55                   	push   %rbp
  803e5d:	48 89 e5             	mov    %rsp,%rbp
  803e60:	48 83 ec 40          	sub    $0x40,%rsp
  803e64:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803e68:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803e6c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803e70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e74:	48 89 c7             	mov    %rax,%rdi
  803e77:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803e7e:	00 00 00 
  803e81:	ff d0                	callq  *%rax
  803e83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803e87:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803e8f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803e96:	00 
  803e97:	e9 93 00 00 00       	jmpq   803f2f <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803e9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ea0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ea4:	48 89 d6             	mov    %rdx,%rsi
  803ea7:	48 89 c7             	mov    %rax,%rdi
  803eaa:	48 b8 42 3c 80 00 00 	movabs $0x803c42,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
  803eb6:	85 c0                	test   %eax,%eax
  803eb8:	74 07                	je     803ec1 <devpipe_write+0x65>
				return 0;
  803eba:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebf:	eb 7c                	jmp    803f3d <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ec1:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  803ec8:	00 00 00 
  803ecb:	ff d0                	callq  *%rax
  803ecd:	eb 01                	jmp    803ed0 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803ecf:	90                   	nop
  803ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ed4:	8b 40 04             	mov    0x4(%rax),%eax
  803ed7:	48 63 d0             	movslq %eax,%rdx
  803eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ede:	8b 00                	mov    (%rax),%eax
  803ee0:	48 98                	cltq   
  803ee2:	48 83 c0 20          	add    $0x20,%rax
  803ee6:	48 39 c2             	cmp    %rax,%rdx
  803ee9:	73 b1                	jae    803e9c <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803eef:	8b 40 04             	mov    0x4(%rax),%eax
  803ef2:	89 c2                	mov    %eax,%edx
  803ef4:	c1 fa 1f             	sar    $0x1f,%edx
  803ef7:	c1 ea 1b             	shr    $0x1b,%edx
  803efa:	01 d0                	add    %edx,%eax
  803efc:	83 e0 1f             	and    $0x1f,%eax
  803eff:	29 d0                	sub    %edx,%eax
  803f01:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803f05:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f09:	48 01 ca             	add    %rcx,%rdx
  803f0c:	0f b6 0a             	movzbl (%rdx),%ecx
  803f0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f13:	48 98                	cltq   
  803f15:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f1d:	8b 40 04             	mov    0x4(%rax),%eax
  803f20:	8d 50 01             	lea    0x1(%rax),%edx
  803f23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f27:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f2a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f33:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f37:	72 96                	jb     803ecf <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803f39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f3d:	c9                   	leaveq 
  803f3e:	c3                   	retq   

0000000000803f3f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803f3f:	55                   	push   %rbp
  803f40:	48 89 e5             	mov    %rsp,%rbp
  803f43:	48 83 ec 20          	sub    $0x20,%rsp
  803f47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f53:	48 89 c7             	mov    %rax,%rdi
  803f56:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803f5d:	00 00 00 
  803f60:	ff d0                	callq  *%rax
  803f62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803f66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f6a:	48 be 7c 50 80 00 00 	movabs $0x80507c,%rsi
  803f71:	00 00 00 
  803f74:	48 89 c7             	mov    %rax,%rdi
  803f77:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  803f7e:	00 00 00 
  803f81:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f87:	8b 50 04             	mov    0x4(%rax),%edx
  803f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f8e:	8b 00                	mov    (%rax),%eax
  803f90:	29 c2                	sub    %eax,%edx
  803f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f96:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803f9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803fa7:	00 00 00 
	stat->st_dev = &devpipe;
  803faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fae:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803fb5:	00 00 00 
  803fb8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  803fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fc4:	c9                   	leaveq 
  803fc5:	c3                   	retq   

0000000000803fc6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803fc6:	55                   	push   %rbp
  803fc7:	48 89 e5             	mov    %rsp,%rbp
  803fca:	48 83 ec 10          	sub    $0x10,%rsp
  803fce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803fd2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd6:	48 89 c6             	mov    %rax,%rsi
  803fd9:	bf 00 00 00 00       	mov    $0x0,%edi
  803fde:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  803fe5:	00 00 00 
  803fe8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803fea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fee:	48 89 c7             	mov    %rax,%rdi
  803ff1:	48 b8 5b 25 80 00 00 	movabs $0x80255b,%rax
  803ff8:	00 00 00 
  803ffb:	ff d0                	callq  *%rax
  803ffd:	48 89 c6             	mov    %rax,%rsi
  804000:	bf 00 00 00 00       	mov    $0x0,%edi
  804005:	48 b8 df 1b 80 00 00 	movabs $0x801bdf,%rax
  80400c:	00 00 00 
  80400f:	ff d0                	callq  *%rax
}
  804011:	c9                   	leaveq 
  804012:	c3                   	retq   
	...

0000000000804014 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  804014:	55                   	push   %rbp
  804015:	48 89 e5             	mov    %rsp,%rbp
  804018:	48 83 ec 20          	sub    $0x20,%rsp
  80401c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80401f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804023:	75 35                	jne    80405a <wait+0x46>
  804025:	48 b9 83 50 80 00 00 	movabs $0x805083,%rcx
  80402c:	00 00 00 
  80402f:	48 ba 8e 50 80 00 00 	movabs $0x80508e,%rdx
  804036:	00 00 00 
  804039:	be 09 00 00 00       	mov    $0x9,%esi
  80403e:	48 bf a3 50 80 00 00 	movabs $0x8050a3,%rdi
  804045:	00 00 00 
  804048:	b8 00 00 00 00       	mov    $0x0,%eax
  80404d:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  804054:	00 00 00 
  804057:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  80405a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80405d:	48 98                	cltq   
  80405f:	48 89 c2             	mov    %rax,%rdx
  804062:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  804068:	48 89 d0             	mov    %rdx,%rax
  80406b:	48 c1 e0 03          	shl    $0x3,%rax
  80406f:	48 01 d0             	add    %rdx,%rax
  804072:	48 c1 e0 05          	shl    $0x5,%rax
  804076:	48 89 c2             	mov    %rax,%rdx
  804079:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804080:	00 00 00 
  804083:	48 01 d0             	add    %rdx,%rax
  804086:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80408a:	eb 0c                	jmp    804098 <wait+0x84>
		sys_yield();
  80408c:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  804093:	00 00 00 
  804096:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8040a2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8040a5:	75 0e                	jne    8040b5 <wait+0xa1>
  8040a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ab:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8040b1:	85 c0                	test   %eax,%eax
  8040b3:	75 d7                	jne    80408c <wait+0x78>
		sys_yield();
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
  8040d5:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
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
  8040fc:	48 b8 50 2a 80 00 00 	movabs $0x802a50,%rax
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
  804143:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
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
  804163:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
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
  804188:	48 b8 86 25 80 00 00 	movabs $0x802586,%rax
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
  8041b3:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
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
  8041d1:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8041d8:	00 00 00 
  8041db:	8b 12                	mov    (%rdx),%edx
  8041dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8041df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8041ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041ee:	48 89 c7             	mov    %rax,%rdi
  8041f1:	48 b8 38 25 80 00 00 	movabs $0x802538,%rax
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
  804221:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80422d:	48 b8 36 1a 80 00 00 	movabs $0x801a36,%rax
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
  8042db:	48 b8 1e 15 80 00 00 	movabs $0x80151e,%rax
  8042e2:	00 00 00 
  8042e5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8042e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8042ea:	48 63 d0             	movslq %eax,%rdx
  8042ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8042f4:	48 89 d6             	mov    %rdx,%rsi
  8042f7:	48 89 c7             	mov    %rax,%rdi
  8042fa:	48 b8 ec 19 80 00 00 	movabs $0x8019ec,%rax
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
  80434a:	48 be b3 50 80 00 00 	movabs $0x8050b3,%rsi
  804351:	00 00 00 
  804354:	48 89 c7             	mov    %rax,%rdi
  804357:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
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
  804378:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
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
  80439c:	48 b8 b8 1a 80 00 00 	movabs $0x801ab8,%rax
  8043a3:	00 00 00 
  8043a6:	ff d0                	callq  *%rax
  8043a8:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8043ab:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8043af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043b2:	ba 07 00 00 00       	mov    $0x7,%edx
  8043b7:	48 89 ce             	mov    %rcx,%rsi
  8043ba:	89 c7                	mov    %eax,%edi
  8043bc:	48 b8 34 1b 80 00 00 	movabs $0x801b34,%rax
  8043c3:	00 00 00 
  8043c6:	ff d0                	callq  *%rax
  8043c8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  8043cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8043cf:	74 30                	je     804401 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  8043d1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8043d4:	89 c1                	mov    %eax,%ecx
  8043d6:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8043dd:	00 00 00 
  8043e0:	be 24 00 00 00       	mov    $0x24,%esi
  8043e5:	48 bf f7 50 80 00 00 	movabs $0x8050f7,%rdi
  8043ec:	00 00 00 
  8043ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f4:	49 b8 04 04 80 00 00 	movabs $0x800404,%r8
  8043fb:	00 00 00 
  8043fe:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  804401:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804404:	48 be 30 44 80 00 00 	movabs $0x804430,%rsi
  80440b:	00 00 00 
  80440e:	89 c7                	mov    %eax,%edi
  804410:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  804417:	00 00 00 
  80441a:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80441c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
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
  804433:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
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

00000000008044bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044bc:	55                   	push   %rbp
  8044bd:	48 89 e5             	mov    %rsp,%rbp
  8044c0:	48 83 ec 30          	sub    $0x30,%rsp
  8044c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  8044d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8044d5:	74 18                	je     8044ef <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  8044d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044db:	48 89 c7             	mov    %rax,%rdi
  8044de:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  8044e5:	00 00 00 
  8044e8:	ff d0                	callq  *%rax
  8044ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044ed:	eb 19                	jmp    804508 <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  8044ef:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8044f6:	00 00 00 
  8044f9:	48 b8 5d 1d 80 00 00 	movabs $0x801d5d,%rax
  804500:	00 00 00 
  804503:	ff d0                	callq  *%rax
  804505:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  804508:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80450c:	79 19                	jns    804527 <ipc_recv+0x6b>
	{
		*from_env_store=0;
  80450e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804512:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  804518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80451c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  804522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804525:	eb 53                	jmp    80457a <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  804527:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80452c:	74 19                	je     804547 <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  80452e:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  804535:	00 00 00 
  804538:	48 8b 00             	mov    (%rax),%rax
  80453b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804545:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  804547:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80454c:	74 19                	je     804567 <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  80454e:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  804555:	00 00 00 
  804558:	48 8b 00             	mov    (%rax),%rax
  80455b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804565:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804567:	48 b8 60 84 80 00 00 	movabs $0x808460,%rax
  80456e:	00 00 00 
  804571:	48 8b 00             	mov    (%rax),%rax
  804574:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  80457a:	c9                   	leaveq 
  80457b:	c3                   	retq   

000000000080457c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80457c:	55                   	push   %rbp
  80457d:	48 89 e5             	mov    %rsp,%rbp
  804580:	48 83 ec 30          	sub    $0x30,%rsp
  804584:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804587:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80458a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80458e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  804591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  804598:	e9 96 00 00 00       	jmpq   804633 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  80459d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045a2:	74 20                	je     8045c4 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8045a4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045a7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045b1:	89 c7                	mov    %eax,%edi
  8045b3:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8045ba:	00 00 00 
  8045bd:	ff d0                	callq  *%rax
  8045bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045c2:	eb 2d                	jmp    8045f1 <ipc_send+0x75>
		else if(pg==NULL)
  8045c4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045c9:	75 26                	jne    8045f1 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  8045cb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8045d6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8045dd:	00 00 00 
  8045e0:	89 c7                	mov    %eax,%edi
  8045e2:	48 b8 08 1d 80 00 00 	movabs $0x801d08,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
  8045ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  8045f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f5:	79 30                	jns    804627 <ipc_send+0xab>
  8045f7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8045fb:	74 2a                	je     804627 <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  8045fd:	48 ba 05 51 80 00 00 	movabs $0x805105,%rdx
  804604:	00 00 00 
  804607:	be 40 00 00 00       	mov    $0x40,%esi
  80460c:	48 bf 1d 51 80 00 00 	movabs $0x80511d,%rdi
  804613:	00 00 00 
  804616:	b8 00 00 00 00       	mov    $0x0,%eax
  80461b:	48 b9 04 04 80 00 00 	movabs $0x800404,%rcx
  804622:	00 00 00 
  804625:	ff d1                	callq  *%rcx
		}
		sys_yield();
  804627:	48 b8 f6 1a 80 00 00 	movabs $0x801af6,%rax
  80462e:	00 00 00 
  804631:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  804633:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804637:	0f 85 60 ff ff ff    	jne    80459d <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  80463d:	c9                   	leaveq 
  80463e:	c3                   	retq   

000000000080463f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80463f:	55                   	push   %rbp
  804640:	48 89 e5             	mov    %rsp,%rbp
  804643:	48 83 ec 18          	sub    $0x18,%rsp
  804647:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80464a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804651:	eb 5e                	jmp    8046b1 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804653:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80465a:	00 00 00 
  80465d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804660:	48 63 d0             	movslq %eax,%rdx
  804663:	48 89 d0             	mov    %rdx,%rax
  804666:	48 c1 e0 03          	shl    $0x3,%rax
  80466a:	48 01 d0             	add    %rdx,%rax
  80466d:	48 c1 e0 05          	shl    $0x5,%rax
  804671:	48 01 c8             	add    %rcx,%rax
  804674:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80467a:	8b 00                	mov    (%rax),%eax
  80467c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80467f:	75 2c                	jne    8046ad <ipc_find_env+0x6e>
			return envs[i].env_id;
  804681:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804688:	00 00 00 
  80468b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468e:	48 63 d0             	movslq %eax,%rdx
  804691:	48 89 d0             	mov    %rdx,%rax
  804694:	48 c1 e0 03          	shl    $0x3,%rax
  804698:	48 01 d0             	add    %rdx,%rax
  80469b:	48 c1 e0 05          	shl    $0x5,%rax
  80469f:	48 01 c8             	add    %rcx,%rax
  8046a2:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8046a8:	8b 40 08             	mov    0x8(%rax),%eax
  8046ab:	eb 12                	jmp    8046bf <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8046ad:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046b1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046b8:	7e 99                	jle    804653 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8046ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046bf:	c9                   	leaveq 
  8046c0:	c3                   	retq   
  8046c1:	00 00                	add    %al,(%rax)
	...

00000000008046c4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8046c4:	55                   	push   %rbp
  8046c5:	48 89 e5             	mov    %rsp,%rbp
  8046c8:	48 83 ec 18          	sub    $0x18,%rsp
  8046cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046d4:	48 89 c2             	mov    %rax,%rdx
  8046d7:	48 c1 ea 15          	shr    $0x15,%rdx
  8046db:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046e2:	01 00 00 
  8046e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e9:	83 e0 01             	and    $0x1,%eax
  8046ec:	48 85 c0             	test   %rax,%rax
  8046ef:	75 07                	jne    8046f8 <pageref+0x34>
		return 0;
  8046f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f6:	eb 53                	jmp    80474b <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8046f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046fc:	48 89 c2             	mov    %rax,%rdx
  8046ff:	48 c1 ea 0c          	shr    $0xc,%rdx
  804703:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80470a:	01 00 00 
  80470d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804719:	83 e0 01             	and    $0x1,%eax
  80471c:	48 85 c0             	test   %rax,%rax
  80471f:	75 07                	jne    804728 <pageref+0x64>
		return 0;
  804721:	b8 00 00 00 00       	mov    $0x0,%eax
  804726:	eb 23                	jmp    80474b <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804728:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80472c:	48 89 c2             	mov    %rax,%rdx
  80472f:	48 c1 ea 0c          	shr    $0xc,%rdx
  804733:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80473a:	00 00 00 
  80473d:	48 c1 e2 04          	shl    $0x4,%rdx
  804741:	48 01 d0             	add    %rdx,%rax
  804744:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804748:	0f b7 c0             	movzwl %ax,%eax
}
  80474b:	c9                   	leaveq 
  80474c:	c3                   	retq   
