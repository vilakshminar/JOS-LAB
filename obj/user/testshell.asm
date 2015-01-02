
obj/user/testshell.debug:     file format elf64-x86-64


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
  80003c:	e8 f7 07 00 00       	callq  800838 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>
	...

0000000000800044 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  800044:	55                   	push   %rbp
  800045:	48 89 e5             	mov    %rsp,%rbp
  800048:	48 83 ec 40          	sub    $0x40,%rsp
  80004c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80004f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  800053:	bf 00 00 00 00       	mov    $0x0,%edi
  800058:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax
	close(1);
  800064:	bf 01 00 00 00       	mov    $0x1,%edi
  800069:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	opencons();
  800075:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  80007c:	00 00 00 
  80007f:	ff d0                	callq  *%rax
	opencons();
  800081:	48 b8 45 06 80 00 00 	movabs $0x800645,%rax
  800088:	00 00 00 
  80008b:	ff d0                	callq  *%rax

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80008d:	be 00 00 00 00       	mov    $0x0,%esi
  800092:	48 bf c0 55 80 00 00 	movabs $0x8055c0,%rdi
  800099:	00 00 00 
  80009c:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8000a3:	00 00 00 
  8000a6:	ff d0                	callq  *%rax
  8000a8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8000ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8000af:	79 30                	jns    8000e1 <umain+0x9d>
		panic("open testshell.sh: %e", rfd);
  8000b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000b4:	89 c1                	mov    %eax,%ecx
  8000b6:	48 ba cd 55 80 00 00 	movabs $0x8055cd,%rdx
  8000bd:	00 00 00 
  8000c0:	be 13 00 00 00       	mov    $0x13,%esi
  8000c5:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  8000cc:	00 00 00 
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8000db:	00 00 00 
  8000de:	41 ff d0             	callq  *%r8
	if ((wfd = pipe(pfds)) < 0)
  8000e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8000e5:	48 89 c7             	mov    %rax,%rdi
  8000e8:	48 b8 54 4b 80 00 00 	movabs $0x804b54,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax
  8000f4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8000fb:	79 30                	jns    80012d <umain+0xe9>
		panic("pipe: %e", wfd);
  8000fd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800100:	89 c1                	mov    %eax,%ecx
  800102:	48 ba f4 55 80 00 00 	movabs $0x8055f4,%rdx
  800109:	00 00 00 
  80010c:	be 15 00 00 00       	mov    $0x15,%esi
  800111:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  800127:	00 00 00 
  80012a:	41 ff d0             	callq  *%r8
	wfd = pfds[1];
  80012d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800130:	89 45 f0             	mov    %eax,-0x10(%rbp)

	cprintf("running sh -x < testshell.sh | cat\n");
  800133:	48 bf 00 56 80 00 00 	movabs $0x805600,%rdi
  80013a:	00 00 00 
  80013d:	b8 00 00 00 00       	mov    $0x0,%eax
  800142:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  800149:	00 00 00 
  80014c:	ff d2                	callq  *%rdx
	if ((r = fork()) < 0)
  80014e:	48 b8 07 27 80 00 00 	movabs $0x802707,%rax
  800155:	00 00 00 
  800158:	ff d0                	callq  *%rax
  80015a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80015d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800161:	79 30                	jns    800193 <umain+0x14f>
		panic("fork: %e", r);
  800163:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800166:	89 c1                	mov    %eax,%ecx
  800168:	48 ba 24 56 80 00 00 	movabs $0x805624,%rdx
  80016f:	00 00 00 
  800172:	be 1a 00 00 00       	mov    $0x1a,%esi
  800177:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  80017e:	00 00 00 
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  80018d:	00 00 00 
  800190:	41 ff d0             	callq  *%r8
	if (r == 0) {
  800193:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800197:	0f 85 fb 00 00 00    	jne    800298 <umain+0x254>
		dup(rfd, 0);
  80019d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001a0:	be 00 00 00 00       	mov    $0x0,%esi
  8001a5:	89 c7                	mov    %eax,%edi
  8001a7:	48 b8 a3 2d 80 00 00 	movabs $0x802da3,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
		dup(wfd, 1);
  8001b3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001b6:	be 01 00 00 00       	mov    $0x1,%esi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 a3 2d 80 00 00 	movabs $0x802da3,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax
		close(rfd);
  8001c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8001cc:	89 c7                	mov    %eax,%edi
  8001ce:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  8001d5:	00 00 00 
  8001d8:	ff d0                	callq  *%rax
		close(wfd);
  8001da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001dd:	89 c7                	mov    %eax,%edi
  8001df:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  8001e6:	00 00 00 
  8001e9:	ff d0                	callq  *%rax
		if ((r = spawnl("/bin/sh", "sh", "-x", 0)) < 0)
  8001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f0:	48 ba 2d 56 80 00 00 	movabs $0x80562d,%rdx
  8001f7:	00 00 00 
  8001fa:	48 be 30 56 80 00 00 	movabs $0x805630,%rsi
  800201:	00 00 00 
  800204:	48 bf 33 56 80 00 00 	movabs $0x805633,%rdi
  80020b:	00 00 00 
  80020e:	b8 00 00 00 00       	mov    $0x0,%eax
  800213:	49 b8 a9 3a 80 00 00 	movabs $0x803aa9,%r8
  80021a:	00 00 00 
  80021d:	41 ff d0             	callq  *%r8
  800220:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800223:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800227:	79 30                	jns    800259 <umain+0x215>
			panic("spawn: %e", r);
  800229:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80022c:	89 c1                	mov    %eax,%ecx
  80022e:	48 ba 3b 56 80 00 00 	movabs $0x80563b,%rdx
  800235:	00 00 00 
  800238:	be 21 00 00 00       	mov    $0x21,%esi
  80023d:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  800244:	00 00 00 
  800247:	b8 00 00 00 00       	mov    $0x0,%eax
  80024c:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  800253:	00 00 00 
  800256:	41 ff d0             	callq  *%r8
		close(0);
  800259:	bf 00 00 00 00       	mov    $0x0,%edi
  80025e:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  800265:	00 00 00 
  800268:	ff d0                	callq  *%rax
		close(1);
  80026a:	bf 01 00 00 00       	mov    $0x1,%edi
  80026f:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  800276:	00 00 00 
  800279:	ff d0                	callq  *%rax
		wait(r);
  80027b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80027e:	89 c7                	mov    %eax,%edi
  800280:	48 b8 1c 51 80 00 00 	movabs $0x80511c,%rax
  800287:	00 00 00 
  80028a:	ff d0                	callq  *%rax
		exit();
  80028c:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  800293:	00 00 00 
  800296:	ff d0                	callq  *%rax
	}
	close(rfd);
  800298:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029b:	89 c7                	mov    %eax,%edi
  80029d:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  8002a4:	00 00 00 
  8002a7:	ff d0                	callq  *%rax
	close(wfd);
  8002a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002ac:	89 c7                	mov    %eax,%edi
  8002ae:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  8002b5:	00 00 00 
  8002b8:	ff d0                	callq  *%rax

	rfd = pfds[0];
  8002ba:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8002bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002c0:	be 00 00 00 00       	mov    $0x0,%esi
  8002c5:	48 bf 45 56 80 00 00 	movabs $0x805645,%rdi
  8002cc:	00 00 00 
  8002cf:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8002d6:	00 00 00 
  8002d9:	ff d0                	callq  *%rax
  8002db:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002de:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e2:	79 30                	jns    800314 <umain+0x2d0>
		panic("open testshell.key for reading: %e", kfd);
  8002e4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002e7:	89 c1                	mov    %eax,%ecx
  8002e9:	48 ba 58 56 80 00 00 	movabs $0x805658,%rdx
  8002f0:	00 00 00 
  8002f3:	be 2c 00 00 00       	mov    $0x2c,%esi
  8002f8:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  8002ff:	00 00 00 
  800302:	b8 00 00 00 00       	mov    $0x0,%eax
  800307:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  80030e:	00 00 00 
  800311:	41 ff d0             	callq  *%r8

	nloff = 0;
  800314:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	for (off=0;; off++) {
  80031b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		n1 = read(rfd, &c1, 1);
  800322:	48 8d 4d df          	lea    -0x21(%rbp),%rcx
  800326:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800329:	ba 01 00 00 00       	mov    $0x1,%edx
  80032e:	48 89 ce             	mov    %rcx,%rsi
  800331:	89 c7                	mov    %eax,%edi
  800333:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80033a:	00 00 00 
  80033d:	ff d0                	callq  *%rax
  80033f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		n2 = read(kfd, &c2, 1);
  800342:	48 8d 4d de          	lea    -0x22(%rbp),%rcx
  800346:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800349:	ba 01 00 00 00       	mov    $0x1,%edx
  80034e:	48 89 ce             	mov    %rcx,%rsi
  800351:	89 c7                	mov    %eax,%edi
  800353:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80035a:	00 00 00 
  80035d:	ff d0                	callq  *%rax
  80035f:	89 45 e0             	mov    %eax,-0x20(%rbp)
		if (n1 < 0)
  800362:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800366:	79 30                	jns    800398 <umain+0x354>
			panic("reading testshell.out: %e", n1);
  800368:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036b:	89 c1                	mov    %eax,%ecx
  80036d:	48 ba 7b 56 80 00 00 	movabs $0x80567b,%rdx
  800374:	00 00 00 
  800377:	be 33 00 00 00       	mov    $0x33,%esi
  80037c:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  800383:	00 00 00 
  800386:	b8 00 00 00 00       	mov    $0x0,%eax
  80038b:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  800392:	00 00 00 
  800395:	41 ff d0             	callq  *%r8
		if (n2 < 0)
  800398:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80039c:	79 30                	jns    8003ce <umain+0x38a>
			panic("reading testshell.key: %e", n2);
  80039e:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8003a1:	89 c1                	mov    %eax,%ecx
  8003a3:	48 ba 95 56 80 00 00 	movabs $0x805695,%rdx
  8003aa:	00 00 00 
  8003ad:	be 35 00 00 00       	mov    $0x35,%esi
  8003b2:	48 bf e3 55 80 00 00 	movabs $0x8055e3,%rdi
  8003b9:	00 00 00 
  8003bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c1:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8003c8:	00 00 00 
  8003cb:	41 ff d0             	callq  *%r8
		if (n1 == 0 && n2 == 0)
  8003ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8003d2:	75 06                	jne    8003da <umain+0x396>
  8003d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8003d8:	74 4b                	je     800425 <umain+0x3e1>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8003da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003de:	75 12                	jne    8003f2 <umain+0x3ae>
  8003e0:	83 7d e0 01          	cmpl   $0x1,-0x20(%rbp)
  8003e4:	75 0c                	jne    8003f2 <umain+0x3ae>
  8003e6:	0f b6 55 df          	movzbl -0x21(%rbp),%edx
  8003ea:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  8003ee:	38 c2                	cmp    %al,%dl
  8003f0:	74 19                	je     80040b <umain+0x3c7>
			wrong(rfd, kfd, nloff);
  8003f2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8003f5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8003f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003fb:	89 ce                	mov    %ecx,%esi
  8003fd:	89 c7                	mov    %eax,%edi
  8003ff:	48 b8 44 04 80 00 00 	movabs $0x800444,%rax
  800406:	00 00 00 
  800409:	ff d0                	callq  *%rax
		if (c1 == '\n')
  80040b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80040f:	3c 0a                	cmp    $0xa,%al
  800411:	75 09                	jne    80041c <umain+0x3d8>
			nloff = off+1;
  800413:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800416:	83 c0 01             	add    $0x1,%eax
  800419:	89 45 f8             	mov    %eax,-0x8(%rbp)
	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
  80041c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
  800420:	e9 fd fe ff ff       	jmpq   800322 <umain+0x2de>
		if (n1 < 0)
			panic("reading testshell.out: %e", n1);
		if (n2 < 0)
			panic("reading testshell.key: %e", n2);
		if (n1 == 0 && n2 == 0)
			break;
  800425:	90                   	nop
		if (n1 != 1 || n2 != 1 || c1 != c2)
			wrong(rfd, kfd, nloff);
		if (c1 == '\n')
			nloff = off+1;
	}
	cprintf("shell ran correctly\n");
  800426:	48 bf af 56 80 00 00 	movabs $0x8056af,%rdi
  80042d:	00 00 00 
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
  800435:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  80043c:	00 00 00 
  80043f:	ff d2                	callq  *%rdx
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800441:	cc                   	int3   

	breakpoint();
}
  800442:	c9                   	leaveq 
  800443:	c3                   	retq   

0000000000800444 <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  800444:	55                   	push   %rbp
  800445:	48 89 e5             	mov    %rsp,%rbp
  800448:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
  80044c:	89 7d 8c             	mov    %edi,-0x74(%rbp)
  80044f:	89 75 88             	mov    %esi,-0x78(%rbp)
  800452:	89 55 84             	mov    %edx,-0x7c(%rbp)
	char buf[100];
	int n;

	seek(rfd, off);
  800455:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800458:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80045b:	89 d6                	mov    %edx,%esi
  80045d:	89 c7                	mov    %eax,%edi
  80045f:	48 b8 72 31 80 00 00 	movabs $0x803172,%rax
  800466:	00 00 00 
  800469:	ff d0                	callq  *%rax
	seek(kfd, off);
  80046b:	8b 55 84             	mov    -0x7c(%rbp),%edx
  80046e:	8b 45 88             	mov    -0x78(%rbp),%eax
  800471:	89 d6                	mov    %edx,%esi
  800473:	89 c7                	mov    %eax,%edi
  800475:	48 b8 72 31 80 00 00 	movabs $0x803172,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax

	cprintf("shell produced incorrect output.\n");
  800481:	48 bf c8 56 80 00 00 	movabs $0x8056c8,%rdi
  800488:	00 00 00 
  80048b:	b8 00 00 00 00       	mov    $0x0,%eax
  800490:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  800497:	00 00 00 
  80049a:	ff d2                	callq  *%rdx
	cprintf("expected:\n===\n");
  80049c:	48 bf ea 56 80 00 00 	movabs $0x8056ea,%rdi
  8004a3:	00 00 00 
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  8004b2:	00 00 00 
  8004b5:	ff d2                	callq  *%rdx
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004b7:	eb 1c                	jmp    8004d5 <wrong+0x91>
		sys_cputs(buf, n);
  8004b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004bc:	48 63 d0             	movslq %eax,%rdx
  8004bf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8004c3:	48 89 d6             	mov    %rdx,%rsi
  8004c6:	48 89 c7             	mov    %rax,%rdi
  8004c9:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8004d5:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  8004d9:	8b 45 88             	mov    -0x78(%rbp),%eax
  8004dc:	ba 63 00 00 00       	mov    $0x63,%edx
  8004e1:	48 89 ce             	mov    %rcx,%rsi
  8004e4:	89 c7                	mov    %eax,%edi
  8004e6:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  8004ed:	00 00 00 
  8004f0:	ff d0                	callq  *%rax
  8004f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8004f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004f9:	7f be                	jg     8004b9 <wrong+0x75>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8004fb:	48 bf f9 56 80 00 00 	movabs $0x8056f9,%rdi
  800502:	00 00 00 
  800505:	b8 00 00 00 00       	mov    $0x0,%eax
  80050a:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  800511:	00 00 00 
  800514:	ff d2                	callq  *%rdx
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800516:	eb 1c                	jmp    800534 <wrong+0xf0>
		sys_cputs(buf, n);
  800518:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80051b:	48 63 d0             	movslq %eax,%rdx
  80051e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800522:	48 89 d6             	mov    %rdx,%rsi
  800525:	48 89 c7             	mov    %rax,%rdi
  800528:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  80052f:	00 00 00 
  800532:	ff d0                	callq  *%rax
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  800534:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  800538:	8b 45 8c             	mov    -0x74(%rbp),%eax
  80053b:	ba 63 00 00 00       	mov    $0x63,%edx
  800540:	48 89 ce             	mov    %rcx,%rsi
  800543:	89 c7                	mov    %eax,%edi
  800545:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
  800551:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800558:	7f be                	jg     800518 <wrong+0xd4>
		sys_cputs(buf, n);
	cprintf("===\n");
  80055a:	48 bf 07 57 80 00 00 	movabs $0x805707,%rdi
  800561:	00 00 00 
  800564:	b8 00 00 00 00       	mov    $0x0,%eax
  800569:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  800570:	00 00 00 
  800573:	ff d2                	callq  *%rdx
	exit();
  800575:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  80057c:	00 00 00 
  80057f:	ff d0                	callq  *%rax
}
  800581:	c9                   	leaveq 
  800582:	c3                   	retq   
	...

0000000000800584 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800584:	55                   	push   %rbp
  800585:	48 89 e5             	mov    %rsp,%rbp
  800588:	48 83 ec 20          	sub    $0x20,%rsp
  80058c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80058f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800592:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800595:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800599:	be 01 00 00 00       	mov    $0x1,%esi
  80059e:	48 89 c7             	mov    %rax,%rdi
  8005a1:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  8005a8:	00 00 00 
  8005ab:	ff d0                	callq  *%rax
}
  8005ad:	c9                   	leaveq 
  8005ae:	c3                   	retq   

00000000008005af <getchar>:

int
getchar(void)
{
  8005af:	55                   	push   %rbp
  8005b0:	48 89 e5             	mov    %rsp,%rbp
  8005b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8005b7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8005bb:	ba 01 00 00 00       	mov    $0x1,%edx
  8005c0:	48 89 c6             	mov    %rax,%rsi
  8005c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c8:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  8005cf:	00 00 00 
  8005d2:	ff d0                	callq  *%rax
  8005d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8005d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005db:	79 05                	jns    8005e2 <getchar+0x33>
		return r;
  8005dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005e0:	eb 14                	jmp    8005f6 <getchar+0x47>
	if (r < 1)
  8005e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e6:	7f 07                	jg     8005ef <getchar+0x40>
		return -E_EOF;
  8005e8:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8005ed:	eb 07                	jmp    8005f6 <getchar+0x47>
	return c;
  8005ef:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8005f3:	0f b6 c0             	movzbl %al,%eax
}
  8005f6:	c9                   	leaveq 
  8005f7:	c3                   	retq   

00000000008005f8 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8005f8:	55                   	push   %rbp
  8005f9:	48 89 e5             	mov    %rsp,%rbp
  8005fc:	48 83 ec 20          	sub    $0x20,%rsp
  800600:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800603:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800607:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80060a:	48 89 d6             	mov    %rdx,%rsi
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  800616:	00 00 00 
  800619:	ff d0                	callq  *%rax
  80061b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80061e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800622:	79 05                	jns    800629 <iscons+0x31>
		return r;
  800624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800627:	eb 1a                	jmp    800643 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  800629:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062d:	8b 10                	mov    (%rax),%edx
  80062f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800636:	00 00 00 
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	39 c2                	cmp    %eax,%edx
  80063d:	0f 94 c0             	sete   %al
  800640:	0f b6 c0             	movzbl %al,%eax
}
  800643:	c9                   	leaveq 
  800644:	c3                   	retq   

0000000000800645 <opencons>:

int
opencons(void)
{
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80064d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800651:	48 89 c7             	mov    %rax,%rdi
  800654:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  80065b:	00 00 00 
  80065e:	ff d0                	callq  *%rax
  800660:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800663:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800667:	79 05                	jns    80066e <opencons+0x29>
		return r;
  800669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80066c:	eb 5b                	jmp    8006c9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80066e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800672:	ba 07 04 00 00       	mov    $0x407,%edx
  800677:	48 89 c6             	mov    %rax,%rsi
  80067a:	bf 00 00 00 00       	mov    $0x0,%edi
  80067f:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  800686:	00 00 00 
  800689:	ff d0                	callq  *%rax
  80068b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80068e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800692:	79 05                	jns    800699 <opencons+0x54>
		return r;
  800694:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800697:	eb 30                	jmp    8006c9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  800699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8006a4:	00 00 00 
  8006a7:	8b 12                	mov    (%rdx),%edx
  8006a9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8006ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006af:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8006b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ba:	48 89 c7             	mov    %rax,%rdi
  8006bd:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  8006c4:	00 00 00 
  8006c7:	ff d0                	callq  *%rax
}
  8006c9:	c9                   	leaveq 
  8006ca:	c3                   	retq   

00000000008006cb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8006cb:	55                   	push   %rbp
  8006cc:	48 89 e5             	mov    %rsp,%rbp
  8006cf:	48 83 ec 30          	sub    $0x30,%rsp
  8006d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006db:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8006df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8006e4:	75 13                	jne    8006f9 <devcons_read+0x2e>
		return 0;
  8006e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006eb:	eb 49                	jmp    800736 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8006ed:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  8006f4:	00 00 00 
  8006f7:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8006f9:	48 b8 32 1f 80 00 00 	movabs $0x801f32,%rax
  800700:	00 00 00 
  800703:	ff d0                	callq  *%rax
  800705:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800708:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80070c:	74 df                	je     8006ed <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80070e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800712:	79 05                	jns    800719 <devcons_read+0x4e>
		return c;
  800714:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800717:	eb 1d                	jmp    800736 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  800719:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80071d:	75 07                	jne    800726 <devcons_read+0x5b>
		return 0;
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	eb 10                	jmp    800736 <devcons_read+0x6b>
	*(char*)vbuf = c;
  800726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800729:	89 c2                	mov    %eax,%edx
  80072b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80072f:	88 10                	mov    %dl,(%rax)
	return 1;
  800731:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800736:	c9                   	leaveq 
  800737:	c3                   	retq   

0000000000800738 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800738:	55                   	push   %rbp
  800739:	48 89 e5             	mov    %rsp,%rbp
  80073c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800743:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80074a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800751:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80075f:	eb 77                	jmp    8007d8 <devcons_write+0xa0>
		m = n - tot;
  800761:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800768:	89 c2                	mov    %eax,%edx
  80076a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80076d:	89 d1                	mov    %edx,%ecx
  80076f:	29 c1                	sub    %eax,%ecx
  800771:	89 c8                	mov    %ecx,%eax
  800773:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  800776:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800779:	83 f8 7f             	cmp    $0x7f,%eax
  80077c:	76 07                	jbe    800785 <devcons_write+0x4d>
			m = sizeof(buf) - 1;
  80077e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  800785:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800788:	48 63 d0             	movslq %eax,%rdx
  80078b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80078e:	48 98                	cltq   
  800790:	48 89 c1             	mov    %rax,%rcx
  800793:	48 03 8d 60 ff ff ff 	add    -0xa0(%rbp),%rcx
  80079a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007a1:	48 89 ce             	mov    %rcx,%rsi
  8007a4:	48 89 c7             	mov    %rax,%rdi
  8007a7:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  8007ae:	00 00 00 
  8007b1:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8007b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007b6:	48 63 d0             	movslq %eax,%rdx
  8007b9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8007c0:	48 89 d6             	mov    %rdx,%rsi
  8007c3:	48 89 c7             	mov    %rax,%rdi
  8007c6:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  8007cd:	00 00 00 
  8007d0:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8007d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8007d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8007d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007db:	48 98                	cltq   
  8007dd:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8007e4:	0f 82 77 ff ff ff    	jb     800761 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8007ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007ed:	c9                   	leaveq 
  8007ee:	c3                   	retq   

00000000008007ef <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8007ef:	55                   	push   %rbp
  8007f0:	48 89 e5             	mov    %rsp,%rbp
  8007f3:	48 83 ec 08          	sub    $0x8,%rsp
  8007f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800800:	c9                   	leaveq 
  800801:	c3                   	retq   

0000000000800802 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800802:	55                   	push   %rbp
  800803:	48 89 e5             	mov    %rsp,%rbp
  800806:	48 83 ec 10          	sub    $0x10,%rsp
  80080a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80080e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800812:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800816:	48 be 11 57 80 00 00 	movabs $0x805711,%rsi
  80081d:	00 00 00 
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
	return 0;
  80082f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800834:	c9                   	leaveq 
  800835:	c3                   	retq   
	...

0000000000800838 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800838:	55                   	push   %rbp
  800839:	48 89 e5             	mov    %rsp,%rbp
  80083c:	48 83 ec 10          	sub    $0x10,%rsp
  800840:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800843:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800847:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  80084e:	00 00 00 
  800851:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	thisenv= &envs[ENVX(sys_getenvid())];
  800858:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  80085f:	00 00 00 
  800862:	ff d0                	callq  *%rax
  800864:	48 98                	cltq   
  800866:	48 89 c2             	mov    %rax,%rdx
  800869:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  80086f:	48 89 d0             	mov    %rdx,%rax
  800872:	48 c1 e0 03          	shl    $0x3,%rax
  800876:	48 01 d0             	add    %rdx,%rax
  800879:	48 c1 e0 05          	shl    $0x5,%rax
  80087d:	48 89 c2             	mov    %rax,%rdx
  800880:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800887:	00 00 00 
  80088a:	48 01 c2             	add    %rax,%rdx
  80088d:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  800894:	00 00 00 
  800897:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  80089a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80089e:	7e 14                	jle    8008b4 <libmain+0x7c>
		binaryname = argv[0];
  8008a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008a4:	48 8b 10             	mov    (%rax),%rdx
  8008a7:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  8008ae:	00 00 00 
  8008b1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8008b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008bb:	48 89 d6             	mov    %rdx,%rsi
  8008be:	89 c7                	mov    %eax,%edi
  8008c0:	48 b8 44 00 80 00 00 	movabs $0x800044,%rax
  8008c7:	00 00 00 
  8008ca:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8008cc:	48 b8 dc 08 80 00 00 	movabs $0x8008dc,%rax
  8008d3:	00 00 00 
  8008d6:	ff d0                	callq  *%rax
}
  8008d8:	c9                   	leaveq 
  8008d9:	c3                   	retq   
	...

00000000008008dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8008e0:	48 b8 75 2d 80 00 00 	movabs $0x802d75,%rax
  8008e7:	00 00 00 
  8008ea:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8008ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8008f1:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  8008f8:	00 00 00 
  8008fb:	ff d0                	callq  *%rax
}
  8008fd:	5d                   	pop    %rbp
  8008fe:	c3                   	retq   
	...

0000000000800900 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800900:	55                   	push   %rbp
  800901:	48 89 e5             	mov    %rsp,%rbp
  800904:	53                   	push   %rbx
  800905:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80090c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800913:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800919:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800920:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800927:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80092e:	84 c0                	test   %al,%al
  800930:	74 23                	je     800955 <_panic+0x55>
  800932:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800939:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80093d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800941:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800945:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800949:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80094d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800951:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800955:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80095c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800963:	00 00 00 
  800966:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80096d:	00 00 00 
  800970:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800974:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80097b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800982:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800989:	48 b8 38 80 80 00 00 	movabs $0x808038,%rax
  800990:	00 00 00 
  800993:	48 8b 18             	mov    (%rax),%rbx
  800996:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  80099d:	00 00 00 
  8009a0:	ff d0                	callq  *%rax
  8009a2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8009a8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8009af:	41 89 c8             	mov    %ecx,%r8d
  8009b2:	48 89 d1             	mov    %rdx,%rcx
  8009b5:	48 89 da             	mov    %rbx,%rdx
  8009b8:	89 c6                	mov    %eax,%esi
  8009ba:	48 bf 28 57 80 00 00 	movabs $0x805728,%rdi
  8009c1:	00 00 00 
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c9:	49 b9 3b 0b 80 00 00 	movabs $0x800b3b,%r9
  8009d0:	00 00 00 
  8009d3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8009d6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8009dd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8009e4:	48 89 d6             	mov    %rdx,%rsi
  8009e7:	48 89 c7             	mov    %rax,%rdi
  8009ea:	48 b8 8f 0a 80 00 00 	movabs $0x800a8f,%rax
  8009f1:	00 00 00 
  8009f4:	ff d0                	callq  *%rax
	cprintf("\n");
  8009f6:	48 bf 4b 57 80 00 00 	movabs $0x80574b,%rdi
  8009fd:	00 00 00 
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	48 ba 3b 0b 80 00 00 	movabs $0x800b3b,%rdx
  800a0c:	00 00 00 
  800a0f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a11:	cc                   	int3   
  800a12:	eb fd                	jmp    800a11 <_panic+0x111>

0000000000800a14 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a14:	55                   	push   %rbp
  800a15:	48 89 e5             	mov    %rsp,%rbp
  800a18:	48 83 ec 10          	sub    $0x10,%rsp
  800a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a27:	8b 00                	mov    (%rax),%eax
  800a29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a2c:	89 d6                	mov    %edx,%esi
  800a2e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a32:	48 63 d0             	movslq %eax,%rdx
  800a35:	40 88 74 11 08       	mov    %sil,0x8(%rcx,%rdx,1)
  800a3a:	8d 50 01             	lea    0x1(%rax),%edx
  800a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a41:	89 10                	mov    %edx,(%rax)
	if (b->idx == 256-1) {
  800a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a47:	8b 00                	mov    (%rax),%eax
  800a49:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4e:	75 2c                	jne    800a7c <putch+0x68>
		sys_cputs(b->buf, b->idx);
  800a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a54:	8b 00                	mov    (%rax),%eax
  800a56:	48 98                	cltq   
  800a58:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a5c:	48 83 c2 08          	add    $0x8,%rdx
  800a60:	48 89 c6             	mov    %rax,%rsi
  800a63:	48 89 d7             	mov    %rdx,%rdi
  800a66:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  800a6d:	00 00 00 
  800a70:	ff d0                	callq  *%rax
		b->idx = 0;
  800a72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a76:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800a7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a80:	8b 40 04             	mov    0x4(%rax),%eax
  800a83:	8d 50 01             	lea    0x1(%rax),%edx
  800a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a8a:	89 50 04             	mov    %edx,0x4(%rax)
}
  800a8d:	c9                   	leaveq 
  800a8e:	c3                   	retq   

0000000000800a8f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a8f:	55                   	push   %rbp
  800a90:	48 89 e5             	mov    %rsp,%rbp
  800a93:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800a9a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800aa1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800aa8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800aaf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ab6:	48 8b 0a             	mov    (%rdx),%rcx
  800ab9:	48 89 08             	mov    %rcx,(%rax)
  800abc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ac0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ac4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ac8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800acc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ad3:	00 00 00 
	b.cnt = 0;
  800ad6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800add:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800ae0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ae7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800aee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800af5:	48 89 c6             	mov    %rax,%rsi
  800af8:	48 bf 14 0a 80 00 00 	movabs $0x800a14,%rdi
  800aff:	00 00 00 
  800b02:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  800b09:	00 00 00 
  800b0c:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800b0e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800b14:	48 98                	cltq   
  800b16:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800b1d:	48 83 c2 08          	add    $0x8,%rdx
  800b21:	48 89 c6             	mov    %rax,%rsi
  800b24:	48 89 d7             	mov    %rdx,%rdi
  800b27:	48 b8 e8 1e 80 00 00 	movabs $0x801ee8,%rax
  800b2e:	00 00 00 
  800b31:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800b33:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800b39:	c9                   	leaveq 
  800b3a:	c3                   	retq   

0000000000800b3b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b3b:	55                   	push   %rbp
  800b3c:	48 89 e5             	mov    %rsp,%rbp
  800b3f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800b46:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800b4d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800b54:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b5b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b62:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b69:	84 c0                	test   %al,%al
  800b6b:	74 20                	je     800b8d <cprintf+0x52>
  800b6d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b71:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b75:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b79:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b7d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b81:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b85:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b89:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b8d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800b94:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800b9b:	00 00 00 
  800b9e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ba5:	00 00 00 
  800ba8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800bb3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800bc1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800bc8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800bcf:	48 8b 0a             	mov    (%rdx),%rcx
  800bd2:	48 89 08             	mov    %rcx,(%rax)
  800bd5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bd9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bdd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800be1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800be5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800bec:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800bf3:	48 89 d6             	mov    %rdx,%rsi
  800bf6:	48 89 c7             	mov    %rax,%rdi
  800bf9:	48 b8 8f 0a 80 00 00 	movabs $0x800a8f,%rax
  800c00:	00 00 00 
  800c03:	ff d0                	callq  *%rax
  800c05:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800c0b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800c11:	c9                   	leaveq 
  800c12:	c3                   	retq   
	...

0000000000800c14 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c14:	55                   	push   %rbp
  800c15:	48 89 e5             	mov    %rsp,%rbp
  800c18:	48 83 ec 30          	sub    $0x30,%rsp
  800c1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800c20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800c24:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800c28:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800c2b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800c2f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c36:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800c3a:	77 52                	ja     800c8e <printnum+0x7a>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800c3f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800c43:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800c46:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	48 f7 75 d0          	divq   -0x30(%rbp)
  800c57:	48 89 c2             	mov    %rax,%rdx
  800c5a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c5d:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c60:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800c64:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800c68:	41 89 f9             	mov    %edi,%r9d
  800c6b:	48 89 c7             	mov    %rax,%rdi
  800c6e:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  800c75:	00 00 00 
  800c78:	ff d0                	callq  *%rax
  800c7a:	eb 1c                	jmp    800c98 <printnum+0x84>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c7c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c80:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c83:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800c87:	48 89 d6             	mov    %rdx,%rsi
  800c8a:	89 c7                	mov    %eax,%edi
  800c8c:	ff d1                	callq  *%rcx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c8e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800c92:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800c96:	7f e4                	jg     800c7c <printnum+0x68>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca4:	48 f7 f1             	div    %rcx
  800ca7:	48 89 d0             	mov    %rdx,%rax
  800caa:	48 ba 28 59 80 00 00 	movabs $0x805928,%rdx
  800cb1:	00 00 00 
  800cb4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800cb8:	0f be c0             	movsbl %al,%eax
  800cbb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cbf:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  800cc3:	48 89 d6             	mov    %rdx,%rsi
  800cc6:	89 c7                	mov    %eax,%edi
  800cc8:	ff d1                	callq  *%rcx
}
  800cca:	c9                   	leaveq 
  800ccb:	c3                   	retq   

0000000000800ccc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %rbp
  800ccd:	48 89 e5             	mov    %rsp,%rbp
  800cd0:	48 83 ec 20          	sub    $0x20,%rsp
  800cd4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800cd8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800cdb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800cdf:	7e 52                	jle    800d33 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce5:	8b 00                	mov    (%rax),%eax
  800ce7:	83 f8 30             	cmp    $0x30,%eax
  800cea:	73 24                	jae    800d10 <getuint+0x44>
  800cec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800cf4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cf8:	8b 00                	mov    (%rax),%eax
  800cfa:	89 c0                	mov    %eax,%eax
  800cfc:	48 01 d0             	add    %rdx,%rax
  800cff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d03:	8b 12                	mov    (%rdx),%edx
  800d05:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d08:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d0c:	89 0a                	mov    %ecx,(%rdx)
  800d0e:	eb 17                	jmp    800d27 <getuint+0x5b>
  800d10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d14:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d18:	48 89 d0             	mov    %rdx,%rax
  800d1b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d23:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d27:	48 8b 00             	mov    (%rax),%rax
  800d2a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d2e:	e9 a3 00 00 00       	jmpq   800dd6 <getuint+0x10a>
	else if (lflag)
  800d33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800d37:	74 4f                	je     800d88 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800d39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d3d:	8b 00                	mov    (%rax),%eax
  800d3f:	83 f8 30             	cmp    $0x30,%eax
  800d42:	73 24                	jae    800d68 <getuint+0x9c>
  800d44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d48:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d50:	8b 00                	mov    (%rax),%eax
  800d52:	89 c0                	mov    %eax,%eax
  800d54:	48 01 d0             	add    %rdx,%rax
  800d57:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d5b:	8b 12                	mov    (%rdx),%edx
  800d5d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800d60:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d64:	89 0a                	mov    %ecx,(%rdx)
  800d66:	eb 17                	jmp    800d7f <getuint+0xb3>
  800d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d6c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800d70:	48 89 d0             	mov    %rdx,%rax
  800d73:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800d77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d7b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800d7f:	48 8b 00             	mov    (%rax),%rax
  800d82:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800d86:	eb 4e                	jmp    800dd6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800d88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d8c:	8b 00                	mov    (%rax),%eax
  800d8e:	83 f8 30             	cmp    $0x30,%eax
  800d91:	73 24                	jae    800db7 <getuint+0xeb>
  800d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d97:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d9f:	8b 00                	mov    (%rax),%eax
  800da1:	89 c0                	mov    %eax,%eax
  800da3:	48 01 d0             	add    %rdx,%rax
  800da6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800daa:	8b 12                	mov    (%rdx),%edx
  800dac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800daf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800db3:	89 0a                	mov    %ecx,(%rdx)
  800db5:	eb 17                	jmp    800dce <getuint+0x102>
  800db7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800dbf:	48 89 d0             	mov    %rdx,%rax
  800dc2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800dc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800dce:	8b 00                	mov    (%rax),%eax
  800dd0:	89 c0                	mov    %eax,%eax
  800dd2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800dd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800dda:	c9                   	leaveq 
  800ddb:	c3                   	retq   

0000000000800ddc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ddc:	55                   	push   %rbp
  800ddd:	48 89 e5             	mov    %rsp,%rbp
  800de0:	48 83 ec 20          	sub    $0x20,%rsp
  800de4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800de8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800deb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800def:	7e 52                	jle    800e43 <getint+0x67>
		x=va_arg(*ap, long long);
  800df1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800df5:	8b 00                	mov    (%rax),%eax
  800df7:	83 f8 30             	cmp    $0x30,%eax
  800dfa:	73 24                	jae    800e20 <getint+0x44>
  800dfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e00:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e08:	8b 00                	mov    (%rax),%eax
  800e0a:	89 c0                	mov    %eax,%eax
  800e0c:	48 01 d0             	add    %rdx,%rax
  800e0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e13:	8b 12                	mov    (%rdx),%edx
  800e15:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e1c:	89 0a                	mov    %ecx,(%rdx)
  800e1e:	eb 17                	jmp    800e37 <getint+0x5b>
  800e20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e24:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e28:	48 89 d0             	mov    %rdx,%rax
  800e2b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e33:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e37:	48 8b 00             	mov    (%rax),%rax
  800e3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e3e:	e9 a3 00 00 00       	jmpq   800ee6 <getint+0x10a>
	else if (lflag)
  800e43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800e47:	74 4f                	je     800e98 <getint+0xbc>
		x=va_arg(*ap, long);
  800e49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4d:	8b 00                	mov    (%rax),%eax
  800e4f:	83 f8 30             	cmp    $0x30,%eax
  800e52:	73 24                	jae    800e78 <getint+0x9c>
  800e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e58:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e60:	8b 00                	mov    (%rax),%eax
  800e62:	89 c0                	mov    %eax,%eax
  800e64:	48 01 d0             	add    %rdx,%rax
  800e67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e6b:	8b 12                	mov    (%rdx),%edx
  800e6d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800e70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e74:	89 0a                	mov    %ecx,(%rdx)
  800e76:	eb 17                	jmp    800e8f <getint+0xb3>
  800e78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800e80:	48 89 d0             	mov    %rdx,%rax
  800e83:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800e87:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e8b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800e8f:	48 8b 00             	mov    (%rax),%rax
  800e92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800e96:	eb 4e                	jmp    800ee6 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800e98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9c:	8b 00                	mov    (%rax),%eax
  800e9e:	83 f8 30             	cmp    $0x30,%eax
  800ea1:	73 24                	jae    800ec7 <getint+0xeb>
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaf:	8b 00                	mov    (%rax),%eax
  800eb1:	89 c0                	mov    %eax,%eax
  800eb3:	48 01 d0             	add    %rdx,%rax
  800eb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eba:	8b 12                	mov    (%rdx),%edx
  800ebc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ebf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ec3:	89 0a                	mov    %ecx,(%rdx)
  800ec5:	eb 17                	jmp    800ede <getint+0x102>
  800ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ecf:	48 89 d0             	mov    %rdx,%rax
  800ed2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ed6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eda:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ede:	8b 00                	mov    (%rax),%eax
  800ee0:	48 98                	cltq   
  800ee2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800ee6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eea:	c9                   	leaveq 
  800eeb:	c3                   	retq   

0000000000800eec <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eec:	55                   	push   %rbp
  800eed:	48 89 e5             	mov    %rsp,%rbp
  800ef0:	41 54                	push   %r12
  800ef2:	53                   	push   %rbx
  800ef3:	48 83 ec 60          	sub    $0x60,%rsp
  800ef7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800efb:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800eff:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800f03:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800f07:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f0b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800f0f:	48 8b 0a             	mov    (%rdx),%rcx
  800f12:	48 89 08             	mov    %rcx,(%rax)
  800f15:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f19:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f1d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f21:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f25:	eb 17                	jmp    800f3e <vprintfmt+0x52>
			if (ch == '\0')
  800f27:	85 db                	test   %ebx,%ebx
  800f29:	0f 84 d7 04 00 00    	je     801406 <vprintfmt+0x51a>
				return;
			putch(ch, putdat);
  800f2f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800f33:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  800f37:	48 89 c6             	mov    %rax,%rsi
  800f3a:	89 df                	mov    %ebx,%edi
  800f3c:	ff d2                	callq  *%rdx
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f3e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f42:	0f b6 00             	movzbl (%rax),%eax
  800f45:	0f b6 d8             	movzbl %al,%ebx
  800f48:	83 fb 25             	cmp    $0x25,%ebx
  800f4b:	0f 95 c0             	setne  %al
  800f4e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f53:	84 c0                	test   %al,%al
  800f55:	75 d0                	jne    800f27 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f57:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800f5b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800f62:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800f69:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800f70:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
  800f77:	eb 04                	jmp    800f7d <vprintfmt+0x91>
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
			goto reswitch;
  800f79:	90                   	nop
  800f7a:	eb 01                	jmp    800f7d <vprintfmt+0x91>
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
			goto reswitch;
  800f7c:	90                   	nop
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f7d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f81:	0f b6 00             	movzbl (%rax),%eax
  800f84:	0f b6 d8             	movzbl %al,%ebx
  800f87:	89 d8                	mov    %ebx,%eax
  800f89:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
  800f8e:	83 e8 23             	sub    $0x23,%eax
  800f91:	83 f8 55             	cmp    $0x55,%eax
  800f94:	0f 87 38 04 00 00    	ja     8013d2 <vprintfmt+0x4e6>
  800f9a:	89 c0                	mov    %eax,%eax
  800f9c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800fa3:	00 
  800fa4:	48 b8 50 59 80 00 00 	movabs $0x805950,%rax
  800fab:	00 00 00 
  800fae:	48 01 d0             	add    %rdx,%rax
  800fb1:	48 8b 00             	mov    (%rax),%rax
  800fb4:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fb6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800fba:	eb c1                	jmp    800f7d <vprintfmt+0x91>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fbc:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800fc0:	eb bb                	jmp    800f7d <vprintfmt+0x91>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800fc9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800fcc:	89 d0                	mov    %edx,%eax
  800fce:	c1 e0 02             	shl    $0x2,%eax
  800fd1:	01 d0                	add    %edx,%eax
  800fd3:	01 c0                	add    %eax,%eax
  800fd5:	01 d8                	add    %ebx,%eax
  800fd7:	83 e8 30             	sub    $0x30,%eax
  800fda:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800fdd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800fe1:	0f b6 00             	movzbl (%rax),%eax
  800fe4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe7:	83 fb 2f             	cmp    $0x2f,%ebx
  800fea:	7e 63                	jle    80104f <vprintfmt+0x163>
  800fec:	83 fb 39             	cmp    $0x39,%ebx
  800fef:	7f 5e                	jg     80104f <vprintfmt+0x163>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d1                	jmp    800fc9 <vprintfmt+0xdd>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ff8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ffb:	83 f8 30             	cmp    $0x30,%eax
  800ffe:	73 17                	jae    801017 <vprintfmt+0x12b>
  801000:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801004:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801007:	89 c0                	mov    %eax,%eax
  801009:	48 01 d0             	add    %rdx,%rax
  80100c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80100f:	83 c2 08             	add    $0x8,%edx
  801012:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801015:	eb 0f                	jmp    801026 <vprintfmt+0x13a>
  801017:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80101b:	48 89 d0             	mov    %rdx,%rax
  80101e:	48 83 c2 08          	add    $0x8,%rdx
  801022:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801026:	8b 00                	mov    (%rax),%eax
  801028:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80102b:	eb 23                	jmp    801050 <vprintfmt+0x164>

		case '.':
			if (width < 0)
  80102d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801031:	0f 89 42 ff ff ff    	jns    800f79 <vprintfmt+0x8d>
				width = 0;
  801037:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80103e:	e9 36 ff ff ff       	jmpq   800f79 <vprintfmt+0x8d>

		case '#':
			altflag = 1;
  801043:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80104a:	e9 2e ff ff ff       	jmpq   800f7d <vprintfmt+0x91>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80104f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801050:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801054:	0f 89 22 ff ff ff    	jns    800f7c <vprintfmt+0x90>
				width = precision, precision = -1;
  80105a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80105d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801060:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801067:	e9 10 ff ff ff       	jmpq   800f7c <vprintfmt+0x90>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80106c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801070:	e9 08 ff ff ff       	jmpq   800f7d <vprintfmt+0x91>

		// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801075:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801078:	83 f8 30             	cmp    $0x30,%eax
  80107b:	73 17                	jae    801094 <vprintfmt+0x1a8>
  80107d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801081:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801084:	89 c0                	mov    %eax,%eax
  801086:	48 01 d0             	add    %rdx,%rax
  801089:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80108c:	83 c2 08             	add    $0x8,%edx
  80108f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801092:	eb 0f                	jmp    8010a3 <vprintfmt+0x1b7>
  801094:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801098:	48 89 d0             	mov    %rdx,%rax
  80109b:	48 83 c2 08          	add    $0x8,%rdx
  80109f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010a3:	8b 00                	mov    (%rax),%eax
  8010a5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010a9:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8010ad:	48 89 d6             	mov    %rdx,%rsi
  8010b0:	89 c7                	mov    %eax,%edi
  8010b2:	ff d1                	callq  *%rcx
			break;
  8010b4:	e9 47 03 00 00       	jmpq   801400 <vprintfmt+0x514>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8010b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010bc:	83 f8 30             	cmp    $0x30,%eax
  8010bf:	73 17                	jae    8010d8 <vprintfmt+0x1ec>
  8010c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8010c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8010c8:	89 c0                	mov    %eax,%eax
  8010ca:	48 01 d0             	add    %rdx,%rax
  8010cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8010d0:	83 c2 08             	add    $0x8,%edx
  8010d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8010d6:	eb 0f                	jmp    8010e7 <vprintfmt+0x1fb>
  8010d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8010dc:	48 89 d0             	mov    %rdx,%rax
  8010df:	48 83 c2 08          	add    $0x8,%rdx
  8010e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8010e7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8010e9:	85 db                	test   %ebx,%ebx
  8010eb:	79 02                	jns    8010ef <vprintfmt+0x203>
				err = -err;
  8010ed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8010ef:	83 fb 10             	cmp    $0x10,%ebx
  8010f2:	7f 16                	jg     80110a <vprintfmt+0x21e>
  8010f4:	48 b8 a0 58 80 00 00 	movabs $0x8058a0,%rax
  8010fb:	00 00 00 
  8010fe:	48 63 d3             	movslq %ebx,%rdx
  801101:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801105:	4d 85 e4             	test   %r12,%r12
  801108:	75 2e                	jne    801138 <vprintfmt+0x24c>
				printfmt(putch, putdat, "error %d", err);
  80110a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80110e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801112:	89 d9                	mov    %ebx,%ecx
  801114:	48 ba 39 59 80 00 00 	movabs $0x805939,%rdx
  80111b:	00 00 00 
  80111e:	48 89 c7             	mov    %rax,%rdi
  801121:	b8 00 00 00 00       	mov    $0x0,%eax
  801126:	49 b8 10 14 80 00 00 	movabs $0x801410,%r8
  80112d:	00 00 00 
  801130:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801133:	e9 c8 02 00 00       	jmpq   801400 <vprintfmt+0x514>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801138:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80113c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801140:	4c 89 e1             	mov    %r12,%rcx
  801143:	48 ba 42 59 80 00 00 	movabs $0x805942,%rdx
  80114a:	00 00 00 
  80114d:	48 89 c7             	mov    %rax,%rdi
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
  801155:	49 b8 10 14 80 00 00 	movabs $0x801410,%r8
  80115c:	00 00 00 
  80115f:	41 ff d0             	callq  *%r8
			break;
  801162:	e9 99 02 00 00       	jmpq   801400 <vprintfmt+0x514>

		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801167:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80116a:	83 f8 30             	cmp    $0x30,%eax
  80116d:	73 17                	jae    801186 <vprintfmt+0x29a>
  80116f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801173:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801176:	89 c0                	mov    %eax,%eax
  801178:	48 01 d0             	add    %rdx,%rax
  80117b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80117e:	83 c2 08             	add    $0x8,%edx
  801181:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801184:	eb 0f                	jmp    801195 <vprintfmt+0x2a9>
  801186:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80118a:	48 89 d0             	mov    %rdx,%rax
  80118d:	48 83 c2 08          	add    $0x8,%rdx
  801191:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801195:	4c 8b 20             	mov    (%rax),%r12
  801198:	4d 85 e4             	test   %r12,%r12
  80119b:	75 0a                	jne    8011a7 <vprintfmt+0x2bb>
				p = "(null)";
  80119d:	49 bc 45 59 80 00 00 	movabs $0x805945,%r12
  8011a4:	00 00 00 
			if (width > 0 && padc != '-')
  8011a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ab:	7e 7a                	jle    801227 <vprintfmt+0x33b>
  8011ad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8011b1:	74 74                	je     801227 <vprintfmt+0x33b>
				for (width -= strnlen(p, precision); width > 0; width--)
  8011b3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8011b6:	48 98                	cltq   
  8011b8:	48 89 c6             	mov    %rax,%rsi
  8011bb:	4c 89 e7             	mov    %r12,%rdi
  8011be:	48 b8 ba 16 80 00 00 	movabs $0x8016ba,%rax
  8011c5:	00 00 00 
  8011c8:	ff d0                	callq  *%rax
  8011ca:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8011cd:	eb 17                	jmp    8011e6 <vprintfmt+0x2fa>
					putch(padc, putdat);
  8011cf:	0f be 45 d3          	movsbl -0x2d(%rbp),%eax
  8011d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8011d7:	48 8b 4d a8          	mov    -0x58(%rbp),%rcx
  8011db:	48 89 d6             	mov    %rdx,%rsi
  8011de:	89 c7                	mov    %eax,%edi
  8011e0:	ff d1                	callq  *%rcx
		// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011e2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8011e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8011ea:	7f e3                	jg     8011cf <vprintfmt+0x2e3>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011ec:	eb 39                	jmp    801227 <vprintfmt+0x33b>
				if (altflag && (ch < ' ' || ch > '~'))
  8011ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8011f2:	74 1e                	je     801212 <vprintfmt+0x326>
  8011f4:	83 fb 1f             	cmp    $0x1f,%ebx
  8011f7:	7e 05                	jle    8011fe <vprintfmt+0x312>
  8011f9:	83 fb 7e             	cmp    $0x7e,%ebx
  8011fc:	7e 14                	jle    801212 <vprintfmt+0x326>
					putch('?', putdat);
  8011fe:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801202:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801206:	48 89 c6             	mov    %rax,%rsi
  801209:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80120e:	ff d2                	callq  *%rdx
  801210:	eb 0f                	jmp    801221 <vprintfmt+0x335>
				else
					putch(ch, putdat);
  801212:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801216:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80121a:	48 89 c6             	mov    %rax,%rsi
  80121d:	89 df                	mov    %ebx,%edi
  80121f:	ff d2                	callq  *%rdx
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801221:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801225:	eb 01                	jmp    801228 <vprintfmt+0x33c>
  801227:	90                   	nop
  801228:	41 0f b6 04 24       	movzbl (%r12),%eax
  80122d:	0f be d8             	movsbl %al,%ebx
  801230:	85 db                	test   %ebx,%ebx
  801232:	0f 95 c0             	setne  %al
  801235:	49 83 c4 01          	add    $0x1,%r12
  801239:	84 c0                	test   %al,%al
  80123b:	74 28                	je     801265 <vprintfmt+0x379>
  80123d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801241:	78 ab                	js     8011ee <vprintfmt+0x302>
  801243:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801247:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80124b:	79 a1                	jns    8011ee <vprintfmt+0x302>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80124d:	eb 16                	jmp    801265 <vprintfmt+0x379>
				putch(' ', putdat);
  80124f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801253:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801257:	48 89 c6             	mov    %rax,%rsi
  80125a:	bf 20 00 00 00       	mov    $0x20,%edi
  80125f:	ff d2                	callq  *%rdx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801261:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801265:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801269:	7f e4                	jg     80124f <vprintfmt+0x363>
				putch(' ', putdat);
			break;
  80126b:	e9 90 01 00 00       	jmpq   801400 <vprintfmt+0x514>

		// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801270:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801274:	be 03 00 00 00       	mov    $0x3,%esi
  801279:	48 89 c7             	mov    %rax,%rdi
  80127c:	48 b8 dc 0d 80 00 00 	movabs $0x800ddc,%rax
  801283:	00 00 00 
  801286:	ff d0                	callq  *%rax
  801288:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80128c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801290:	48 85 c0             	test   %rax,%rax
  801293:	79 1d                	jns    8012b2 <vprintfmt+0x3c6>
				putch('-', putdat);
  801295:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801299:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80129d:	48 89 c6             	mov    %rax,%rsi
  8012a0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8012a5:	ff d2                	callq  *%rdx
				num = -(long long) num;
  8012a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ab:	48 f7 d8             	neg    %rax
  8012ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8012b2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012b9:	e9 d5 00 00 00       	jmpq   801393 <vprintfmt+0x4a7>
                        
			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8012be:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012c2:	be 03 00 00 00       	mov    $0x3,%esi
  8012c7:	48 89 c7             	mov    %rax,%rdi
  8012ca:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  8012d1:	00 00 00 
  8012d4:	ff d0                	callq  *%rax
  8012d6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8012da:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8012e1:	e9 ad 00 00 00       	jmpq   801393 <vprintfmt+0x4a7>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&aq, 3);
  8012e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8012ea:	be 03 00 00 00       	mov    $0x3,%esi
  8012ef:	48 89 c7             	mov    %rax,%rdi
  8012f2:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  8012f9:	00 00 00 
  8012fc:	ff d0                	callq  *%rax
  8012fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                        base = 8;
  801302:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801309:	e9 85 00 00 00       	jmpq   801393 <vprintfmt+0x4a7>
			putch('X', putdat);
		*/	break;

		// pointer
		case 'p':
			putch('0', putdat);
  80130e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801312:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801316:	48 89 c6             	mov    %rax,%rsi
  801319:	bf 30 00 00 00       	mov    $0x30,%edi
  80131e:	ff d2                	callq  *%rdx
			putch('x', putdat);
  801320:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  801324:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801328:	48 89 c6             	mov    %rax,%rsi
  80132b:	bf 78 00 00 00       	mov    $0x78,%edi
  801330:	ff d2                	callq  *%rdx
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801332:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801335:	83 f8 30             	cmp    $0x30,%eax
  801338:	73 17                	jae    801351 <vprintfmt+0x465>
  80133a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80133e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801341:	89 c0                	mov    %eax,%eax
  801343:	48 01 d0             	add    %rdx,%rax
  801346:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801349:	83 c2 08             	add    $0x8,%edx
  80134c:	89 55 b8             	mov    %edx,-0x48(%rbp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80134f:	eb 0f                	jmp    801360 <vprintfmt+0x474>
				(uintptr_t) va_arg(aq, void *);
  801351:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801355:	48 89 d0             	mov    %rdx,%rax
  801358:	48 83 c2 08          	add    $0x8,%rdx
  80135c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801360:	48 8b 00             	mov    (%rax),%rax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801363:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801367:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80136e:	eb 23                	jmp    801393 <vprintfmt+0x4a7>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801370:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801374:	be 03 00 00 00       	mov    $0x3,%esi
  801379:	48 89 c7             	mov    %rax,%rdi
  80137c:	48 b8 cc 0c 80 00 00 	movabs $0x800ccc,%rax
  801383:	00 00 00 
  801386:	ff d0                	callq  *%rax
  801388:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80138c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801393:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801398:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80139b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80139e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013aa:	45 89 c1             	mov    %r8d,%r9d
  8013ad:	41 89 f8             	mov    %edi,%r8d
  8013b0:	48 89 c7             	mov    %rax,%rdi
  8013b3:	48 b8 14 0c 80 00 00 	movabs $0x800c14,%rax
  8013ba:	00 00 00 
  8013bd:	ff d0                	callq  *%rax
			break;
  8013bf:	eb 3f                	jmp    801400 <vprintfmt+0x514>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8013c1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013c5:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013c9:	48 89 c6             	mov    %rax,%rsi
  8013cc:	89 df                	mov    %ebx,%edi
  8013ce:	ff d2                	callq  *%rdx
			break;
  8013d0:	eb 2e                	jmp    801400 <vprintfmt+0x514>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8013d2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8013d6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8013da:	48 89 c6             	mov    %rax,%rsi
  8013dd:	bf 25 00 00 00       	mov    $0x25,%edi
  8013e2:	ff d2                	callq  *%rdx
			for (fmt--; fmt[-1] != '%'; fmt--)
  8013e4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013e9:	eb 05                	jmp    8013f0 <vprintfmt+0x504>
  8013eb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8013f0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013f4:	48 83 e8 01          	sub    $0x1,%rax
  8013f8:	0f b6 00             	movzbl (%rax),%eax
  8013fb:	3c 25                	cmp    $0x25,%al
  8013fd:	75 ec                	jne    8013eb <vprintfmt+0x4ff>
				/* do nothing */;
			break;
  8013ff:	90                   	nop
		}
	}
  801400:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801401:	e9 38 fb ff ff       	jmpq   800f3e <vprintfmt+0x52>
			if (ch == '\0')
				return;
  801406:	90                   	nop
				/* do nothing */;
			break;
		}
	}
    va_end(aq);
}
  801407:	48 83 c4 60          	add    $0x60,%rsp
  80140b:	5b                   	pop    %rbx
  80140c:	41 5c                	pop    %r12
  80140e:	5d                   	pop    %rbp
  80140f:	c3                   	retq   

0000000000801410 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801410:	55                   	push   %rbp
  801411:	48 89 e5             	mov    %rsp,%rbp
  801414:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80141b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801422:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801429:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801430:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801437:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80143e:	84 c0                	test   %al,%al
  801440:	74 20                	je     801462 <printfmt+0x52>
  801442:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801446:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80144a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80144e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801452:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801456:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80145a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80145e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801462:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801469:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801470:	00 00 00 
  801473:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80147a:	00 00 00 
  80147d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801481:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801488:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80148f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801496:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80149d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8014a4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8014ab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8014b2:	48 89 c7             	mov    %rax,%rdi
  8014b5:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  8014bc:	00 00 00 
  8014bf:	ff d0                	callq  *%rax
	va_end(ap);
}
  8014c1:	c9                   	leaveq 
  8014c2:	c3                   	retq   

00000000008014c3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c3:	55                   	push   %rbp
  8014c4:	48 89 e5             	mov    %rsp,%rbp
  8014c7:	48 83 ec 10          	sub    $0x10,%rsp
  8014cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8014ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8014d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d6:	8b 40 10             	mov    0x10(%rax),%eax
  8014d9:	8d 50 01             	lea    0x1(%rax),%edx
  8014dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8014e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e7:	48 8b 10             	mov    (%rax),%rdx
  8014ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8014f2:	48 39 c2             	cmp    %rax,%rdx
  8014f5:	73 17                	jae    80150e <sprintputch+0x4b>
		*b->buf++ = ch;
  8014f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fb:	48 8b 00             	mov    (%rax),%rax
  8014fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801501:	88 10                	mov    %dl,(%rax)
  801503:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	48 89 10             	mov    %rdx,(%rax)
}
  80150e:	c9                   	leaveq 
  80150f:	c3                   	retq   

0000000000801510 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801510:	55                   	push   %rbp
  801511:	48 89 e5             	mov    %rsp,%rbp
  801514:	48 83 ec 50          	sub    $0x50,%rsp
  801518:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80151c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80151f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801523:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801527:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80152b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80152f:	48 8b 0a             	mov    (%rdx),%rcx
  801532:	48 89 08             	mov    %rcx,(%rax)
  801535:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801539:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80153d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801541:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801545:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801549:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80154d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801550:	48 98                	cltq   
  801552:	48 83 e8 01          	sub    $0x1,%rax
  801556:	48 03 45 c8          	add    -0x38(%rbp),%rax
  80155a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80155e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801565:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80156a:	74 06                	je     801572 <vsnprintf+0x62>
  80156c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801570:	7f 07                	jg     801579 <vsnprintf+0x69>
		return -E_INVAL;
  801572:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801577:	eb 2f                	jmp    8015a8 <vsnprintf+0x98>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801579:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80157d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801581:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801585:	48 89 c6             	mov    %rax,%rsi
  801588:	48 bf c3 14 80 00 00 	movabs $0x8014c3,%rdi
  80158f:	00 00 00 
  801592:	48 b8 ec 0e 80 00 00 	movabs $0x800eec,%rax
  801599:	00 00 00 
  80159c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80159e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8015a5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8015b5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8015bc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8015c2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015c9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015d0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015d7:	84 c0                	test   %al,%al
  8015d9:	74 20                	je     8015fb <snprintf+0x51>
  8015db:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015df:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015e3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015e7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015eb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015ef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015f3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015f7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8015fb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801602:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801609:	00 00 00 
  80160c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801613:	00 00 00 
  801616:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80161a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801621:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801628:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80162f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801636:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80163d:	48 8b 0a             	mov    (%rdx),%rcx
  801640:	48 89 08             	mov    %rcx,(%rax)
  801643:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801647:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80164b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80164f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801653:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80165a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801661:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801667:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80166e:	48 89 c7             	mov    %rax,%rdi
  801671:	48 b8 10 15 80 00 00 	movabs $0x801510,%rax
  801678:	00 00 00 
  80167b:	ff d0                	callq  *%rax
  80167d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801683:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801689:	c9                   	leaveq 
  80168a:	c3                   	retq   
	...

000000000080168c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80168c:	55                   	push   %rbp
  80168d:	48 89 e5             	mov    %rsp,%rbp
  801690:	48 83 ec 18          	sub    $0x18,%rsp
  801694:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80169f:	eb 09                	jmp    8016aa <strlen+0x1e>
		n++;
  8016a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8016a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ae:	0f b6 00             	movzbl (%rax),%eax
  8016b1:	84 c0                	test   %al,%al
  8016b3:	75 ec                	jne    8016a1 <strlen+0x15>
		n++;
	return n;
  8016b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016b8:	c9                   	leaveq 
  8016b9:	c3                   	retq   

00000000008016ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8016ba:	55                   	push   %rbp
  8016bb:	48 89 e5             	mov    %rsp,%rbp
  8016be:	48 83 ec 20          	sub    $0x20,%rsp
  8016c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8016d1:	eb 0e                	jmp    8016e1 <strnlen+0x27>
		n++;
  8016d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8016d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8016dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8016e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8016e6:	74 0b                	je     8016f3 <strnlen+0x39>
  8016e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ec:	0f b6 00             	movzbl (%rax),%eax
  8016ef:	84 c0                	test   %al,%al
  8016f1:	75 e0                	jne    8016d3 <strnlen+0x19>
		n++;
	return n;
  8016f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016f6:	c9                   	leaveq 
  8016f7:	c3                   	retq   

00000000008016f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016f8:	55                   	push   %rbp
  8016f9:	48 89 e5             	mov    %rsp,%rbp
  8016fc:	48 83 ec 20          	sub    $0x20,%rsp
  801700:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801710:	90                   	nop
  801711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801715:	0f b6 10             	movzbl (%rax),%edx
  801718:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171c:	88 10                	mov    %dl,(%rax)
  80171e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801722:	0f b6 00             	movzbl (%rax),%eax
  801725:	84 c0                	test   %al,%al
  801727:	0f 95 c0             	setne  %al
  80172a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801734:	84 c0                	test   %al,%al
  801736:	75 d9                	jne    801711 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801738:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80173c:	c9                   	leaveq 
  80173d:	c3                   	retq   

000000000080173e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80173e:	55                   	push   %rbp
  80173f:	48 89 e5             	mov    %rsp,%rbp
  801742:	48 83 ec 20          	sub    $0x20,%rsp
  801746:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80174a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80174e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801752:	48 89 c7             	mov    %rax,%rdi
  801755:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  80175c:	00 00 00 
  80175f:	ff d0                	callq  *%rax
  801761:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801764:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801767:	48 98                	cltq   
  801769:	48 03 45 e8          	add    -0x18(%rbp),%rax
  80176d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801771:	48 89 d6             	mov    %rdx,%rsi
  801774:	48 89 c7             	mov    %rax,%rdi
  801777:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  80177e:	00 00 00 
  801781:	ff d0                	callq  *%rax
	return dst;
  801783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801787:	c9                   	leaveq 
  801788:	c3                   	retq   

0000000000801789 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801789:	55                   	push   %rbp
  80178a:	48 89 e5             	mov    %rsp,%rbp
  80178d:	48 83 ec 28          	sub    $0x28,%rsp
  801791:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801795:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801799:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80179d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8017a5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8017ac:	00 
  8017ad:	eb 27                	jmp    8017d6 <strncpy+0x4d>
		*dst++ = *src;
  8017af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017b3:	0f b6 10             	movzbl (%rax),%edx
  8017b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ba:	88 10                	mov    %dl,(%rax)
  8017bc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017c5:	0f b6 00             	movzbl (%rax),%eax
  8017c8:	84 c0                	test   %al,%al
  8017ca:	74 05                	je     8017d1 <strncpy+0x48>
			src++;
  8017cc:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017da:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8017de:	72 cf                	jb     8017af <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017e4:	c9                   	leaveq 
  8017e5:	c3                   	retq   

00000000008017e6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 28          	sub    $0x28,%rsp
  8017ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8017fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801802:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801807:	74 37                	je     801840 <strlcpy+0x5a>
		while (--size > 0 && *src != '\0')
  801809:	eb 17                	jmp    801822 <strlcpy+0x3c>
			*dst++ = *src++;
  80180b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80180f:	0f b6 10             	movzbl (%rax),%edx
  801812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801816:	88 10                	mov    %dl,(%rax)
  801818:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80181d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801822:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801827:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80182c:	74 0b                	je     801839 <strlcpy+0x53>
  80182e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801832:	0f b6 00             	movzbl (%rax),%eax
  801835:	84 c0                	test   %al,%al
  801837:	75 d2                	jne    80180b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183d:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801840:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801844:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801848:	48 89 d1             	mov    %rdx,%rcx
  80184b:	48 29 c1             	sub    %rax,%rcx
  80184e:	48 89 c8             	mov    %rcx,%rax
}
  801851:	c9                   	leaveq 
  801852:	c3                   	retq   

0000000000801853 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
  801857:	48 83 ec 10          	sub    $0x10,%rsp
  80185b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801863:	eb 0a                	jmp    80186f <strcmp+0x1c>
		p++, q++;
  801865:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80186a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80186f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801873:	0f b6 00             	movzbl (%rax),%eax
  801876:	84 c0                	test   %al,%al
  801878:	74 12                	je     80188c <strcmp+0x39>
  80187a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187e:	0f b6 10             	movzbl (%rax),%edx
  801881:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801885:	0f b6 00             	movzbl (%rax),%eax
  801888:	38 c2                	cmp    %al,%dl
  80188a:	74 d9                	je     801865 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80188c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801890:	0f b6 00             	movzbl (%rax),%eax
  801893:	0f b6 d0             	movzbl %al,%edx
  801896:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80189a:	0f b6 00             	movzbl (%rax),%eax
  80189d:	0f b6 c0             	movzbl %al,%eax
  8018a0:	89 d1                	mov    %edx,%ecx
  8018a2:	29 c1                	sub    %eax,%ecx
  8018a4:	89 c8                	mov    %ecx,%eax
}
  8018a6:	c9                   	leaveq 
  8018a7:	c3                   	retq   

00000000008018a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018a8:	55                   	push   %rbp
  8018a9:	48 89 e5             	mov    %rsp,%rbp
  8018ac:	48 83 ec 18          	sub    $0x18,%rsp
  8018b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8018bc:	eb 0f                	jmp    8018cd <strncmp+0x25>
		n--, p++, q++;
  8018be:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8018c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018c8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8018cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018d2:	74 1d                	je     8018f1 <strncmp+0x49>
  8018d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d8:	0f b6 00             	movzbl (%rax),%eax
  8018db:	84 c0                	test   %al,%al
  8018dd:	74 12                	je     8018f1 <strncmp+0x49>
  8018df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e3:	0f b6 10             	movzbl (%rax),%edx
  8018e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ea:	0f b6 00             	movzbl (%rax),%eax
  8018ed:	38 c2                	cmp    %al,%dl
  8018ef:	74 cd                	je     8018be <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8018f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018f6:	75 07                	jne    8018ff <strncmp+0x57>
		return 0;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fd:	eb 1a                	jmp    801919 <strncmp+0x71>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801903:	0f b6 00             	movzbl (%rax),%eax
  801906:	0f b6 d0             	movzbl %al,%edx
  801909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80190d:	0f b6 00             	movzbl (%rax),%eax
  801910:	0f b6 c0             	movzbl %al,%eax
  801913:	89 d1                	mov    %edx,%ecx
  801915:	29 c1                	sub    %eax,%ecx
  801917:	89 c8                	mov    %ecx,%eax
}
  801919:	c9                   	leaveq 
  80191a:	c3                   	retq   

000000000080191b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80191b:	55                   	push   %rbp
  80191c:	48 89 e5             	mov    %rsp,%rbp
  80191f:	48 83 ec 10          	sub    $0x10,%rsp
  801923:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801927:	89 f0                	mov    %esi,%eax
  801929:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80192c:	eb 17                	jmp    801945 <strchr+0x2a>
		if (*s == c)
  80192e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801932:	0f b6 00             	movzbl (%rax),%eax
  801935:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801938:	75 06                	jne    801940 <strchr+0x25>
			return (char *) s;
  80193a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80193e:	eb 15                	jmp    801955 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801940:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801945:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	84 c0                	test   %al,%al
  80194e:	75 de                	jne    80192e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801955:	c9                   	leaveq 
  801956:	c3                   	retq   

0000000000801957 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801957:	55                   	push   %rbp
  801958:	48 89 e5             	mov    %rsp,%rbp
  80195b:	48 83 ec 10          	sub    $0x10,%rsp
  80195f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801963:	89 f0                	mov    %esi,%eax
  801965:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801968:	eb 11                	jmp    80197b <strfind+0x24>
		if (*s == c)
  80196a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80196e:	0f b6 00             	movzbl (%rax),%eax
  801971:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801974:	74 12                	je     801988 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801976:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80197b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80197f:	0f b6 00             	movzbl (%rax),%eax
  801982:	84 c0                	test   %al,%al
  801984:	75 e4                	jne    80196a <strfind+0x13>
  801986:	eb 01                	jmp    801989 <strfind+0x32>
		if (*s == c)
			break;
  801988:	90                   	nop
	return (char *) s;
  801989:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80198d:	c9                   	leaveq 
  80198e:	c3                   	retq   

000000000080198f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80198f:	55                   	push   %rbp
  801990:	48 89 e5             	mov    %rsp,%rbp
  801993:	48 83 ec 18          	sub    $0x18,%rsp
  801997:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80199b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80199e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8019a2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019a7:	75 06                	jne    8019af <memset+0x20>
		return v;
  8019a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019ad:	eb 69                	jmp    801a18 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8019af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b3:	83 e0 03             	and    $0x3,%eax
  8019b6:	48 85 c0             	test   %rax,%rax
  8019b9:	75 48                	jne    801a03 <memset+0x74>
  8019bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019bf:	83 e0 03             	and    $0x3,%eax
  8019c2:	48 85 c0             	test   %rax,%rax
  8019c5:	75 3c                	jne    801a03 <memset+0x74>
		c &= 0xFF;
  8019c7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019ce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d1:	89 c2                	mov    %eax,%edx
  8019d3:	c1 e2 18             	shl    $0x18,%edx
  8019d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019d9:	c1 e0 10             	shl    $0x10,%eax
  8019dc:	09 c2                	or     %eax,%edx
  8019de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019e1:	c1 e0 08             	shl    $0x8,%eax
  8019e4:	09 d0                	or     %edx,%eax
  8019e6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8019e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ed:	48 89 c1             	mov    %rax,%rcx
  8019f0:	48 c1 e9 02          	shr    $0x2,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8019f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8019fb:	48 89 d7             	mov    %rdx,%rdi
  8019fe:	fc                   	cld    
  8019ff:	f3 ab                	rep stos %eax,%es:(%rdi)
  801a01:	eb 11                	jmp    801a14 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801a03:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a07:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801a0a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a0e:	48 89 d7             	mov    %rdx,%rdi
  801a11:	fc                   	cld    
  801a12:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a18:	c9                   	leaveq 
  801a19:	c3                   	retq   

0000000000801a1a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801a1a:	55                   	push   %rbp
  801a1b:	48 89 e5             	mov    %rsp,%rbp
  801a1e:	48 83 ec 28          	sub    $0x28,%rsp
  801a22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801a2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801a36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801a3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a42:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a46:	0f 83 88 00 00 00    	jae    801ad4 <memmove+0xba>
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a54:	48 01 d0             	add    %rdx,%rax
  801a57:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801a5b:	76 77                	jbe    801ad4 <memmove+0xba>
		s += n;
  801a5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a61:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801a65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a69:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801a6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a71:	83 e0 03             	and    $0x3,%eax
  801a74:	48 85 c0             	test   %rax,%rax
  801a77:	75 3b                	jne    801ab4 <memmove+0x9a>
  801a79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a7d:	83 e0 03             	and    $0x3,%eax
  801a80:	48 85 c0             	test   %rax,%rax
  801a83:	75 2f                	jne    801ab4 <memmove+0x9a>
  801a85:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a89:	83 e0 03             	and    $0x3,%eax
  801a8c:	48 85 c0             	test   %rax,%rax
  801a8f:	75 23                	jne    801ab4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801a91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a95:	48 83 e8 04          	sub    $0x4,%rax
  801a99:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a9d:	48 83 ea 04          	sub    $0x4,%rdx
  801aa1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801aa5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801aa9:	48 89 c7             	mov    %rax,%rdi
  801aac:	48 89 d6             	mov    %rdx,%rsi
  801aaf:	fd                   	std    
  801ab0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ab2:	eb 1d                	jmp    801ad1 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ab8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801abc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ac0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ac4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac8:	48 89 d7             	mov    %rdx,%rdi
  801acb:	48 89 c1             	mov    %rax,%rcx
  801ace:	fd                   	std    
  801acf:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ad1:	fc                   	cld    
  801ad2:	eb 57                	jmp    801b2b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ad4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad8:	83 e0 03             	and    $0x3,%eax
  801adb:	48 85 c0             	test   %rax,%rax
  801ade:	75 36                	jne    801b16 <memmove+0xfc>
  801ae0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae4:	83 e0 03             	and    $0x3,%eax
  801ae7:	48 85 c0             	test   %rax,%rax
  801aea:	75 2a                	jne    801b16 <memmove+0xfc>
  801aec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af0:	83 e0 03             	and    $0x3,%eax
  801af3:	48 85 c0             	test   %rax,%rax
  801af6:	75 1e                	jne    801b16 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801af8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afc:	48 89 c1             	mov    %rax,%rcx
  801aff:	48 c1 e9 02          	shr    $0x2,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b07:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b0b:	48 89 c7             	mov    %rax,%rdi
  801b0e:	48 89 d6             	mov    %rdx,%rsi
  801b11:	fc                   	cld    
  801b12:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801b14:	eb 15                	jmp    801b2b <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b1e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801b22:	48 89 c7             	mov    %rax,%rdi
  801b25:	48 89 d6             	mov    %rdx,%rsi
  801b28:	fc                   	cld    
  801b29:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801b2b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b2f:	c9                   	leaveq 
  801b30:	c3                   	retq   

0000000000801b31 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b31:	55                   	push   %rbp
  801b32:	48 89 e5             	mov    %rsp,%rbp
  801b35:	48 83 ec 18          	sub    $0x18,%rsp
  801b39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b41:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801b45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b49:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b51:	48 89 ce             	mov    %rcx,%rsi
  801b54:	48 89 c7             	mov    %rax,%rdi
  801b57:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 28          	sub    $0x28,%rsp
  801b6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801b75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801b79:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801b81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801b89:	eb 38                	jmp    801bc3 <memcmp+0x5e>
		if (*s1 != *s2)
  801b8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b8f:	0f b6 10             	movzbl (%rax),%edx
  801b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b96:	0f b6 00             	movzbl (%rax),%eax
  801b99:	38 c2                	cmp    %al,%dl
  801b9b:	74 1c                	je     801bb9 <memcmp+0x54>
			return (int) *s1 - (int) *s2;
  801b9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba1:	0f b6 00             	movzbl (%rax),%eax
  801ba4:	0f b6 d0             	movzbl %al,%edx
  801ba7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bab:	0f b6 00             	movzbl (%rax),%eax
  801bae:	0f b6 c0             	movzbl %al,%eax
  801bb1:	89 d1                	mov    %edx,%ecx
  801bb3:	29 c1                	sub    %eax,%ecx
  801bb5:	89 c8                	mov    %ecx,%eax
  801bb7:	eb 20                	jmp    801bd9 <memcmp+0x74>
		s1++, s2++;
  801bb9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801bbe:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bc3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801bc8:	0f 95 c0             	setne  %al
  801bcb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801bd0:	84 c0                	test   %al,%al
  801bd2:	75 b7                	jne    801b8b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd9:	c9                   	leaveq 
  801bda:	c3                   	retq   

0000000000801bdb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bdb:	55                   	push   %rbp
  801bdc:	48 89 e5             	mov    %rsp,%rbp
  801bdf:	48 83 ec 28          	sub    $0x28,%rsp
  801be3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801be7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801bea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801bee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bf2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bf6:	48 01 d0             	add    %rdx,%rax
  801bf9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801bfd:	eb 13                	jmp    801c12 <memfind+0x37>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c03:	0f b6 10             	movzbl (%rax),%edx
  801c06:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c09:	38 c2                	cmp    %al,%dl
  801c0b:	74 11                	je     801c1e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c0d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c16:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801c1a:	72 e3                	jb     801bff <memfind+0x24>
  801c1c:	eb 01                	jmp    801c1f <memfind+0x44>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c1e:	90                   	nop
	return (void *) s;
  801c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c23:	c9                   	leaveq 
  801c24:	c3                   	retq   

0000000000801c25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c25:	55                   	push   %rbp
  801c26:	48 89 e5             	mov    %rsp,%rbp
  801c29:	48 83 ec 38          	sub    $0x38,%rsp
  801c2d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801c31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801c35:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801c38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801c3f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801c46:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c47:	eb 05                	jmp    801c4e <strtol+0x29>
		s++;
  801c49:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c52:	0f b6 00             	movzbl (%rax),%eax
  801c55:	3c 20                	cmp    $0x20,%al
  801c57:	74 f0                	je     801c49 <strtol+0x24>
  801c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5d:	0f b6 00             	movzbl (%rax),%eax
  801c60:	3c 09                	cmp    $0x9,%al
  801c62:	74 e5                	je     801c49 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c64:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c68:	0f b6 00             	movzbl (%rax),%eax
  801c6b:	3c 2b                	cmp    $0x2b,%al
  801c6d:	75 07                	jne    801c76 <strtol+0x51>
		s++;
  801c6f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c74:	eb 17                	jmp    801c8d <strtol+0x68>
	else if (*s == '-')
  801c76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c7a:	0f b6 00             	movzbl (%rax),%eax
  801c7d:	3c 2d                	cmp    $0x2d,%al
  801c7f:	75 0c                	jne    801c8d <strtol+0x68>
		s++, neg = 1;
  801c81:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801c86:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c8d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801c91:	74 06                	je     801c99 <strtol+0x74>
  801c93:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801c97:	75 28                	jne    801cc1 <strtol+0x9c>
  801c99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9d:	0f b6 00             	movzbl (%rax),%eax
  801ca0:	3c 30                	cmp    $0x30,%al
  801ca2:	75 1d                	jne    801cc1 <strtol+0x9c>
  801ca4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ca8:	48 83 c0 01          	add    $0x1,%rax
  801cac:	0f b6 00             	movzbl (%rax),%eax
  801caf:	3c 78                	cmp    $0x78,%al
  801cb1:	75 0e                	jne    801cc1 <strtol+0x9c>
		s += 2, base = 16;
  801cb3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801cb8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801cbf:	eb 2c                	jmp    801ced <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801cc1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cc5:	75 19                	jne    801ce0 <strtol+0xbb>
  801cc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ccb:	0f b6 00             	movzbl (%rax),%eax
  801cce:	3c 30                	cmp    $0x30,%al
  801cd0:	75 0e                	jne    801ce0 <strtol+0xbb>
		s++, base = 8;
  801cd2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801cd7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801cde:	eb 0d                	jmp    801ced <strtol+0xc8>
	else if (base == 0)
  801ce0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ce4:	75 07                	jne    801ced <strtol+0xc8>
		base = 10;
  801ce6:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ced:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cf1:	0f b6 00             	movzbl (%rax),%eax
  801cf4:	3c 2f                	cmp    $0x2f,%al
  801cf6:	7e 1d                	jle    801d15 <strtol+0xf0>
  801cf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfc:	0f b6 00             	movzbl (%rax),%eax
  801cff:	3c 39                	cmp    $0x39,%al
  801d01:	7f 12                	jg     801d15 <strtol+0xf0>
			dig = *s - '0';
  801d03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d07:	0f b6 00             	movzbl (%rax),%eax
  801d0a:	0f be c0             	movsbl %al,%eax
  801d0d:	83 e8 30             	sub    $0x30,%eax
  801d10:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d13:	eb 4e                	jmp    801d63 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801d15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d19:	0f b6 00             	movzbl (%rax),%eax
  801d1c:	3c 60                	cmp    $0x60,%al
  801d1e:	7e 1d                	jle    801d3d <strtol+0x118>
  801d20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d24:	0f b6 00             	movzbl (%rax),%eax
  801d27:	3c 7a                	cmp    $0x7a,%al
  801d29:	7f 12                	jg     801d3d <strtol+0x118>
			dig = *s - 'a' + 10;
  801d2b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d2f:	0f b6 00             	movzbl (%rax),%eax
  801d32:	0f be c0             	movsbl %al,%eax
  801d35:	83 e8 57             	sub    $0x57,%eax
  801d38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d3b:	eb 26                	jmp    801d63 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801d3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d41:	0f b6 00             	movzbl (%rax),%eax
  801d44:	3c 40                	cmp    $0x40,%al
  801d46:	7e 47                	jle    801d8f <strtol+0x16a>
  801d48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4c:	0f b6 00             	movzbl (%rax),%eax
  801d4f:	3c 5a                	cmp    $0x5a,%al
  801d51:	7f 3c                	jg     801d8f <strtol+0x16a>
			dig = *s - 'A' + 10;
  801d53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d57:	0f b6 00             	movzbl (%rax),%eax
  801d5a:	0f be c0             	movsbl %al,%eax
  801d5d:	83 e8 37             	sub    $0x37,%eax
  801d60:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801d63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d66:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801d69:	7d 23                	jge    801d8e <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801d6b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801d70:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d73:	48 98                	cltq   
  801d75:	48 89 c2             	mov    %rax,%rdx
  801d78:	48 0f af 55 f0       	imul   -0x10(%rbp),%rdx
  801d7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d80:	48 98                	cltq   
  801d82:	48 01 d0             	add    %rdx,%rax
  801d85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801d89:	e9 5f ff ff ff       	jmpq   801ced <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d8e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d8f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801d94:	74 0b                	je     801da1 <strtol+0x17c>
		*endptr = (char *) s;
  801d96:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d9a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d9e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801da5:	74 09                	je     801db0 <strtol+0x18b>
  801da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dab:	48 f7 d8             	neg    %rax
  801dae:	eb 04                	jmp    801db4 <strtol+0x18f>
  801db0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801db4:	c9                   	leaveq 
  801db5:	c3                   	retq   

0000000000801db6 <strstr>:

char * strstr(const char *in, const char *str)
{
  801db6:	55                   	push   %rbp
  801db7:	48 89 e5             	mov    %rsp,%rbp
  801dba:	48 83 ec 30          	sub    $0x30,%rsp
  801dbe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dc2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801dc6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dca:	0f b6 00             	movzbl (%rax),%eax
  801dcd:	88 45 ff             	mov    %al,-0x1(%rbp)
  801dd0:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
    if (!c)
  801dd5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801dd9:	75 06                	jne    801de1 <strstr+0x2b>
        return (char *) in;	// Trivial empty string case
  801ddb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ddf:	eb 68                	jmp    801e49 <strstr+0x93>

    len = strlen(str);
  801de1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801de5:	48 89 c7             	mov    %rax,%rdi
  801de8:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	48 98                	cltq   
  801df6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801dfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfe:	0f b6 00             	movzbl (%rax),%eax
  801e01:	88 45 ef             	mov    %al,-0x11(%rbp)
  801e04:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
            if (!sc)
  801e09:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801e0d:	75 07                	jne    801e16 <strstr+0x60>
                return (char *) 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	eb 33                	jmp    801e49 <strstr+0x93>
        } while (sc != c);
  801e16:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801e1a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801e1d:	75 db                	jne    801dfa <strstr+0x44>
    } while (strncmp(in, str, len) != 0);
  801e1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e23:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2b:	48 89 ce             	mov    %rcx,%rsi
  801e2e:	48 89 c7             	mov    %rax,%rdi
  801e31:	48 b8 a8 18 80 00 00 	movabs $0x8018a8,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	75 b9                	jne    801dfa <strstr+0x44>

    return (char *) (in - 1);
  801e41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e45:	48 83 e8 01          	sub    $0x1,%rax
}
  801e49:	c9                   	leaveq 
  801e4a:	c3                   	retq   
	...

0000000000801e4c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801e4c:	55                   	push   %rbp
  801e4d:	48 89 e5             	mov    %rsp,%rbp
  801e50:	53                   	push   %rbx
  801e51:	48 83 ec 58          	sub    $0x58,%rsp
  801e55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801e58:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801e5b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801e5f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801e63:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801e67:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e6b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e6e:	89 45 ac             	mov    %eax,-0x54(%rbp)
  801e71:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801e75:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801e79:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801e7d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801e81:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801e85:	8b 45 ac             	mov    -0x54(%rbp),%eax
  801e88:	4c 89 c3             	mov    %r8,%rbx
  801e8b:	cd 30                	int    $0x30
  801e8d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  801e91:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801e95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801e99:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801e9d:	74 3e                	je     801edd <syscall+0x91>
  801e9f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ea4:	7e 37                	jle    801edd <syscall+0x91>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ea6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801eaa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801ead:	49 89 d0             	mov    %rdx,%r8
  801eb0:	89 c1                	mov    %eax,%ecx
  801eb2:	48 ba 00 5c 80 00 00 	movabs $0x805c00,%rdx
  801eb9:	00 00 00 
  801ebc:	be 23 00 00 00       	mov    $0x23,%esi
  801ec1:	48 bf 1d 5c 80 00 00 	movabs $0x805c1d,%rdi
  801ec8:	00 00 00 
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed0:	49 b9 00 09 80 00 00 	movabs $0x800900,%r9
  801ed7:	00 00 00 
  801eda:	41 ff d1             	callq  *%r9

	return ret;
  801edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801ee1:	48 83 c4 58          	add    $0x58,%rsp
  801ee5:	5b                   	pop    %rbx
  801ee6:	5d                   	pop    %rbp
  801ee7:	c3                   	retq   

0000000000801ee8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801ee8:	55                   	push   %rbp
  801ee9:	48 89 e5             	mov    %rsp,%rbp
  801eec:	48 83 ec 20          	sub    $0x20,%rsp
  801ef0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ef4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801efc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f07:	00 
  801f08:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f0e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f14:	48 89 d1             	mov    %rdx,%rcx
  801f17:	48 89 c2             	mov    %rax,%rdx
  801f1a:	be 00 00 00 00       	mov    $0x0,%esi
  801f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f24:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
}
  801f30:	c9                   	leaveq 
  801f31:	c3                   	retq   

0000000000801f32 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f32:	55                   	push   %rbp
  801f33:	48 89 e5             	mov    %rsp,%rbp
  801f36:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801f3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f41:	00 
  801f42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f48:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f4e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f53:	ba 00 00 00 00       	mov    $0x0,%edx
  801f58:	be 00 00 00 00       	mov    $0x0,%esi
  801f5d:	bf 01 00 00 00       	mov    $0x1,%edi
  801f62:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801f69:	00 00 00 
  801f6c:	ff d0                	callq  *%rax
}
  801f6e:	c9                   	leaveq 
  801f6f:	c3                   	retq   

0000000000801f70 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801f70:	55                   	push   %rbp
  801f71:	48 89 e5             	mov    %rsp,%rbp
  801f74:	48 83 ec 20          	sub    $0x20,%rsp
  801f78:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801f7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f7e:	48 98                	cltq   
  801f80:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f87:	00 
  801f88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f94:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f99:	48 89 c2             	mov    %rax,%rdx
  801f9c:	be 01 00 00 00       	mov    $0x1,%esi
  801fa1:	bf 03 00 00 00       	mov    $0x3,%edi
  801fa6:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801fad:	00 00 00 
  801fb0:	ff d0                	callq  *%rax
}
  801fb2:	c9                   	leaveq 
  801fb3:	c3                   	retq   

0000000000801fb4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801fb4:	55                   	push   %rbp
  801fb5:	48 89 e5             	mov    %rsp,%rbp
  801fb8:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801fbc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fc3:	00 
  801fc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fda:	be 00 00 00 00       	mov    $0x0,%esi
  801fdf:	bf 02 00 00 00       	mov    $0x2,%edi
  801fe4:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  801feb:	00 00 00 
  801fee:	ff d0                	callq  *%rax
}
  801ff0:	c9                   	leaveq 
  801ff1:	c3                   	retq   

0000000000801ff2 <sys_yield>:

void
sys_yield(void)
{
  801ff2:	55                   	push   %rbp
  801ff3:	48 89 e5             	mov    %rsp,%rbp
  801ff6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801ffa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802001:	00 
  802002:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802008:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80200e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802013:	ba 00 00 00 00       	mov    $0x0,%edx
  802018:	be 00 00 00 00       	mov    $0x0,%esi
  80201d:	bf 0b 00 00 00       	mov    $0xb,%edi
  802022:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802029:	00 00 00 
  80202c:	ff d0                	callq  *%rax
}
  80202e:	c9                   	leaveq 
  80202f:	c3                   	retq   

0000000000802030 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802030:	55                   	push   %rbp
  802031:	48 89 e5             	mov    %rsp,%rbp
  802034:	48 83 ec 20          	sub    $0x20,%rsp
  802038:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80203b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80203f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802042:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802045:	48 63 c8             	movslq %eax,%rcx
  802048:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80204c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80204f:	48 98                	cltq   
  802051:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802058:	00 
  802059:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80205f:	49 89 c8             	mov    %rcx,%r8
  802062:	48 89 d1             	mov    %rdx,%rcx
  802065:	48 89 c2             	mov    %rax,%rdx
  802068:	be 01 00 00 00       	mov    $0x1,%esi
  80206d:	bf 04 00 00 00       	mov    $0x4,%edi
  802072:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802079:	00 00 00 
  80207c:	ff d0                	callq  *%rax
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 30          	sub    $0x30,%rsp
  802088:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80208b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80208f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802092:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802096:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80209a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80209d:	48 63 c8             	movslq %eax,%rcx
  8020a0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020a7:	48 63 f0             	movslq %eax,%rsi
  8020aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020b1:	48 98                	cltq   
  8020b3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020b7:	49 89 f9             	mov    %rdi,%r9
  8020ba:	49 89 f0             	mov    %rsi,%r8
  8020bd:	48 89 d1             	mov    %rdx,%rcx
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	be 01 00 00 00       	mov    $0x1,%esi
  8020c8:	bf 05 00 00 00       	mov    $0x5,%edi
  8020cd:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8020d4:	00 00 00 
  8020d7:	ff d0                	callq  *%rax
}
  8020d9:	c9                   	leaveq 
  8020da:	c3                   	retq   

00000000008020db <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8020db:	55                   	push   %rbp
  8020dc:	48 89 e5             	mov    %rsp,%rbp
  8020df:	48 83 ec 20          	sub    $0x20,%rsp
  8020e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8020ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f1:	48 98                	cltq   
  8020f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020fa:	00 
  8020fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802101:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802107:	48 89 d1             	mov    %rdx,%rcx
  80210a:	48 89 c2             	mov    %rax,%rdx
  80210d:	be 01 00 00 00       	mov    $0x1,%esi
  802112:	bf 06 00 00 00       	mov    $0x6,%edi
  802117:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
}
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	48 83 ec 20          	sub    $0x20,%rsp
  80212d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802130:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802133:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802136:	48 63 d0             	movslq %eax,%rdx
  802139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213c:	48 98                	cltq   
  80213e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802145:	00 
  802146:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80214c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802152:	48 89 d1             	mov    %rdx,%rcx
  802155:	48 89 c2             	mov    %rax,%rdx
  802158:	be 01 00 00 00       	mov    $0x1,%esi
  80215d:	bf 08 00 00 00       	mov    $0x8,%edi
  802162:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802169:	00 00 00 
  80216c:	ff d0                	callq  *%rax
}
  80216e:	c9                   	leaveq 
  80216f:	c3                   	retq   

0000000000802170 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802170:	55                   	push   %rbp
  802171:	48 89 e5             	mov    %rsp,%rbp
  802174:	48 83 ec 20          	sub    $0x20,%rsp
  802178:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80217b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80217f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802183:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802186:	48 98                	cltq   
  802188:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80218f:	00 
  802190:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802196:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80219c:	48 89 d1             	mov    %rdx,%rcx
  80219f:	48 89 c2             	mov    %rax,%rdx
  8021a2:	be 01 00 00 00       	mov    $0x1,%esi
  8021a7:	bf 09 00 00 00       	mov    $0x9,%edi
  8021ac:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
}
  8021b8:	c9                   	leaveq 
  8021b9:	c3                   	retq   

00000000008021ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8021ba:	55                   	push   %rbp
  8021bb:	48 89 e5             	mov    %rsp,%rbp
  8021be:	48 83 ec 20          	sub    $0x20,%rsp
  8021c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8021c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8021c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d0:	48 98                	cltq   
  8021d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8021d9:	00 
  8021da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021e6:	48 89 d1             	mov    %rdx,%rcx
  8021e9:	48 89 c2             	mov    %rax,%rdx
  8021ec:	be 01 00 00 00       	mov    $0x1,%esi
  8021f1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021f6:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	callq  *%rax
}
  802202:	c9                   	leaveq 
  802203:	c3                   	retq   

0000000000802204 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802204:	55                   	push   %rbp
  802205:	48 89 e5             	mov    %rsp,%rbp
  802208:	48 83 ec 30          	sub    $0x30,%rsp
  80220c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80220f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802213:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802217:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  80221a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80221d:	48 63 f0             	movslq %eax,%rsi
  802220:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802224:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802227:	48 98                	cltq   
  802229:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80222d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802234:	00 
  802235:	49 89 f1             	mov    %rsi,%r9
  802238:	49 89 c8             	mov    %rcx,%r8
  80223b:	48 89 d1             	mov    %rdx,%rcx
  80223e:	48 89 c2             	mov    %rax,%rdx
  802241:	be 00 00 00 00       	mov    $0x0,%esi
  802246:	bf 0c 00 00 00       	mov    $0xc,%edi
  80224b:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802252:	00 00 00 
  802255:	ff d0                	callq  *%rax
}
  802257:	c9                   	leaveq 
  802258:	c3                   	retq   

0000000000802259 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802259:	55                   	push   %rbp
  80225a:	48 89 e5             	mov    %rsp,%rbp
  80225d:	48 83 ec 20          	sub    $0x20,%rsp
  802261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802265:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802269:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802270:	00 
  802271:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802277:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80227d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802282:	48 89 c2             	mov    %rax,%rdx
  802285:	be 01 00 00 00       	mov    $0x1,%esi
  80228a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80228f:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802296:	00 00 00 
  802299:	ff d0                	callq  *%rax
}
  80229b:	c9                   	leaveq 
  80229c:	c3                   	retq   

000000000080229d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80229d:	55                   	push   %rbp
  80229e:	48 89 e5             	mov    %rsp,%rbp
  8022a1:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  8022a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022ac:	00 
  8022ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022be:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c3:	be 00 00 00 00       	mov    $0x0,%esi
  8022c8:	bf 0e 00 00 00       	mov    $0xe,%edi
  8022cd:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
}
  8022d9:	c9                   	leaveq 
  8022da:	c3                   	retq   

00000000008022db <sys_send_packet>:
int
sys_send_packet(void *addr, size_t len)
{
  8022db:	55                   	push   %rbp
  8022dc:	48 89 e5             	mov    %rsp,%rbp
  8022df:	48 83 ec 20          	sub    $0x20,%rsp
  8022e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8022e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_send_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  8022eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8022fa:	00 
  8022fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802301:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802307:	48 89 d1             	mov    %rdx,%rcx
  80230a:	48 89 c2             	mov    %rax,%rdx
  80230d:	be 00 00 00 00       	mov    $0x0,%esi
  802312:	bf 0f 00 00 00       	mov    $0xf,%edi
  802317:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  80231e:	00 00 00 
  802321:	ff d0                	callq  *%rax
}
  802323:	c9                   	leaveq 
  802324:	c3                   	retq   

0000000000802325 <sys_receive_packet>:
int
sys_receive_packet(void *addr, size_t len)
{
  802325:	55                   	push   %rbp
  802326:	48 89 e5             	mov    %rsp,%rbp
  802329:	48 83 ec 20          	sub    $0x20,%rsp
  80232d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802331:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_receive_packet, 0, (uint64_t)addr, (uint64_t)len, 0, 0, 0);
  802335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802339:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80233d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802344:	00 
  802345:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80234b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802351:	48 89 d1             	mov    %rdx,%rcx
  802354:	48 89 c2             	mov    %rax,%rdx
  802357:	be 00 00 00 00       	mov    $0x0,%esi
  80235c:	bf 10 00 00 00       	mov    $0x10,%edi
  802361:	48 b8 4c 1e 80 00 00 	movabs $0x801e4c,%rax
  802368:	00 00 00 
  80236b:	ff d0                	callq  *%rax
}
  80236d:	c9                   	leaveq 
  80236e:	c3                   	retq   
	...

0000000000802370 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802370:	55                   	push   %rbp
  802371:	48 89 e5             	mov    %rsp,%rbp
  802374:	48 83 ec 30          	sub    $0x30,%rsp
  802378:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80237c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802380:	48 8b 00             	mov    (%rax),%rax
  802383:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  802387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80238f:	89 45 f4             	mov    %eax,-0xc(%rbp)
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if(!(err & FEC_WR) || !(uvpt[VPN(addr)] & PTE_COW))
  802392:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802395:	83 e0 02             	and    $0x2,%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 23                	je     8023bf <pgfault+0x4f>
  80239c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a0:	48 89 c2             	mov    %rax,%rdx
  8023a3:	48 c1 ea 0c          	shr    $0xc,%rdx
  8023a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023ae:	01 00 00 
  8023b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023b5:	25 00 08 00 00       	and    $0x800,%eax
  8023ba:	48 85 c0             	test   %rax,%rax
  8023bd:	75 2a                	jne    8023e9 <pgfault+0x79>
                panic("faulting access not to a write or copy-on-write page");
  8023bf:	48 ba 30 5c 80 00 00 	movabs $0x805c30,%rdx
  8023c6:	00 00 00 
  8023c9:	be 1c 00 00 00       	mov    $0x1c,%esi
  8023ce:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  8023d5:	00 00 00 
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dd:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  8023e4:	00 00 00 
  8023e7:	ff d1                	callq  *%rcx
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if((r = sys_page_alloc(0,(void *)PFTEMP,PTE_P|PTE_U|PTE_W))<0)
  8023e9:	ba 07 00 00 00       	mov    $0x7,%edx
  8023ee:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f8:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8023ff:	00 00 00 
  802402:	ff d0                	callq  *%rax
  802404:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802407:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80240b:	79 30                	jns    80243d <pgfault+0xcd>
                panic("panic in pgfault:sys_page_alloc: %e",r);
  80240d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802410:	89 c1                	mov    %eax,%ecx
  802412:	48 ba 70 5c 80 00 00 	movabs $0x805c70,%rdx
  802419:	00 00 00 
  80241c:	be 26 00 00 00       	mov    $0x26,%esi
  802421:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802428:	00 00 00 
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
  802430:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  802437:	00 00 00 
  80243a:	41 ff d0             	callq  *%r8
	
	memmove((void *)PFTEMP, (void *)(ROUNDDOWN(addr, PGSIZE)), PGSIZE);
  80243d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802441:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802445:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802449:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80244f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802454:	48 89 c6             	mov    %rax,%rsi
  802457:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80245c:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax
	
	if((r = sys_page_map(0,(void *)PFTEMP,0,ROUNDDOWN(addr,PGSIZE),PTE_P|PTE_U|PTE_W))<0)
  802468:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  802470:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802474:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80247a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802480:	48 89 c1             	mov    %rax,%rcx
  802483:	ba 00 00 00 00       	mov    $0x0,%edx
  802488:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80248d:	bf 00 00 00 00       	mov    $0x0,%edi
  802492:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802499:	00 00 00 
  80249c:	ff d0                	callq  *%rax
  80249e:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024a5:	79 30                	jns    8024d7 <pgfault+0x167>
                panic("panic in pgfault:sys_page_map:%e",r);
  8024a7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024aa:	89 c1                	mov    %eax,%ecx
  8024ac:	48 ba 98 5c 80 00 00 	movabs $0x805c98,%rdx
  8024b3:	00 00 00 
  8024b6:	be 2b 00 00 00       	mov    $0x2b,%esi
  8024bb:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  8024c2:	00 00 00 
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8024d1:	00 00 00 
  8024d4:	41 ff d0             	callq  *%r8

	if((r = sys_page_unmap(0,(void *)PFTEMP))<0)
  8024d7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8024dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e1:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  8024e8:	00 00 00 
  8024eb:	ff d0                	callq  *%rax
  8024ed:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024f4:	79 30                	jns    802526 <pgfault+0x1b6>
                panic("panic in pgfault:sys_page_unmap:%e",r);
  8024f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024f9:	89 c1                	mov    %eax,%ecx
  8024fb:	48 ba c0 5c 80 00 00 	movabs $0x805cc0,%rdx
  802502:	00 00 00 
  802505:	be 2e 00 00 00       	mov    $0x2e,%esi
  80250a:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802511:	00 00 00 
  802514:	b8 00 00 00 00       	mov    $0x0,%eax
  802519:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  802520:	00 00 00 
  802523:	41 ff d0             	callq  *%r8
	
}
  802526:	c9                   	leaveq 
  802527:	c3                   	retq   

0000000000802528 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802528:	55                   	push   %rbp
  802529:	48 89 e5             	mov    %rsp,%rbp
  80252c:	48 83 ec 30          	sub    $0x30,%rsp
  802530:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802533:	89 75 d8             	mov    %esi,-0x28(%rbp)
	// LAB 4: Your code here.
	void* addr;
	pte_t pte;
	int r,perm;
	pte = uvpt[pn];
  802536:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80253d:	01 00 00 
  802540:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802547:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	perm  = pte & PTE_SYSCALL;
  80254b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80254f:	25 07 0e 00 00       	and    $0xe07,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%rbp)
	addr = (void*)((uintptr_t)pn * PGSIZE);
  802557:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80255a:	48 c1 e0 0c          	shl    $0xc,%rax
  80255e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	//cprintf("addr:%08x\tpte:%08x\tPTE_SYSCALL:%08x\tpte&PTE_SYSCALL:%08x\tPTE_SHARE:%08x\n",addr,pte,PTE_SYSCALL,pte&PTE_SYSCALL,PTE_SHARE);
	//shared page
	if(perm & PTE_SHARE)
  802562:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802565:	25 00 04 00 00       	and    $0x400,%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	74 5c                	je     8025ca <duppage+0xa2>
	{
                r = sys_page_map(0, addr, envid, addr, perm);
  80256e:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802571:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802575:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257c:	41 89 f0             	mov    %esi,%r8d
  80257f:	48 89 c6             	mov    %rax,%rsi
  802582:	bf 00 00 00 00       	mov    $0x0,%edi
  802587:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax
  802593:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                if (r<0)
  802596:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80259a:	0f 89 60 01 00 00    	jns    802700 <duppage+0x1d8>
                        panic("panic in duppage:sys_page_map:shared page");
  8025a0:	48 ba e8 5c 80 00 00 	movabs $0x805ce8,%rdx
  8025a7:	00 00 00 
  8025aa:	be 4d 00 00 00       	mov    $0x4d,%esi
  8025af:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  8025b6:	00 00 00 
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  8025c5:	00 00 00 
  8025c8:	ff d1                	callq  *%rcx
        }
	//page with PTE_W or PTE_COW set
	else if(((perm & PTE_W) || (perm & PTE_COW))) 
  8025ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025cd:	83 e0 02             	and    $0x2,%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	75 10                	jne    8025e4 <duppage+0xbc>
  8025d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025d7:	25 00 08 00 00       	and    $0x800,%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	0f 84 c4 00 00 00    	je     8026a8 <duppage+0x180>
	{
		perm |= PTE_COW;
  8025e4:	81 4d f4 00 08 00 00 	orl    $0x800,-0xc(%rbp)
		perm &= ~PTE_W;
  8025eb:	83 65 f4 fd          	andl   $0xfffffffd,-0xc(%rbp)
		r = sys_page_map(0, addr, envid, addr, perm); 
  8025ef:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8025f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025fd:	41 89 f0             	mov    %esi,%r8d
  802600:	48 89 c6             	mov    %rax,%rsi
  802603:	bf 00 00 00 00       	mov    $0x0,%edi
  802608:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
  802614:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if(r<0) 
  802617:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80261b:	79 2a                	jns    802647 <duppage+0x11f>
	 		panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page"); 
  80261d:	48 ba 18 5d 80 00 00 	movabs $0x805d18,%rdx
  802624:	00 00 00 
  802627:	be 56 00 00 00       	mov    $0x56,%esi
  80262c:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802633:	00 00 00 
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
  80263b:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  802642:	00 00 00 
  802645:	ff d1                	callq  *%rcx
		r = sys_page_map(0, addr, 0, addr, perm);
  802647:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  80264a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	41 89 c8             	mov    %ecx,%r8d
  802655:	48 89 d1             	mov    %rdx,%rcx
  802658:	ba 00 00 00 00       	mov    $0x0,%edx
  80265d:	48 89 c6             	mov    %rax,%rsi
  802660:	bf 00 00 00 00       	mov    $0x0,%edi
  802665:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  80266c:	00 00 00 
  80266f:	ff d0                	callq  *%rax
  802671:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  802674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802678:	0f 89 82 00 00 00    	jns    802700 <duppage+0x1d8>
      			panic("panic in duppage:sys_page_map:PTE_W or PTE_COW page");
  80267e:	48 ba 18 5d 80 00 00 	movabs $0x805d18,%rdx
  802685:	00 00 00 
  802688:	be 59 00 00 00       	mov    $0x59,%esi
  80268d:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802694:	00 00 00 
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  8026a3:	00 00 00 
  8026a6:	ff d1                	callq  *%rcx
	}
	//read-only page
	else 
	{
		r = sys_page_map(0, addr, envid, addr, perm);
  8026a8:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8026ab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026af:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	41 89 f0             	mov    %esi,%r8d
  8026b9:	48 89 c6             	mov    %rax,%rsi
  8026bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8026c1:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  8026c8:	00 00 00 
  8026cb:	ff d0                	callq  *%rax
  8026cd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    		if (r<0) 
  8026d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8026d4:	79 2a                	jns    802700 <duppage+0x1d8>
      			panic("duppage:sys_page_map:read-only-page");
  8026d6:	48 ba 50 5d 80 00 00 	movabs $0x805d50,%rdx
  8026dd:	00 00 00 
  8026e0:	be 60 00 00 00       	mov    $0x60,%esi
  8026e5:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  8026ec:	00 00 00 
  8026ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f4:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  8026fb:	00 00 00 
  8026fe:	ff d1                	callq  *%rcx
	}
	return 0;
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802705:	c9                   	leaveq 
  802706:	c3                   	retq   

0000000000802707 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802707:	55                   	push   %rbp
  802708:	48 89 e5             	mov    %rsp,%rbp
  80270b:	53                   	push   %rbx
  80270c:	48 83 ec 48          	sub    $0x48,%rsp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  802710:	48 bf 70 23 80 00 00 	movabs $0x802370,%rdi
  802717:	00 00 00 
  80271a:	48 b8 c0 51 80 00 00 	movabs $0x8051c0,%rax
  802721:	00 00 00 
  802724:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802726:	c7 45 bc 07 00 00 00 	movl   $0x7,-0x44(%rbp)
  80272d:	8b 45 bc             	mov    -0x44(%rbp),%eax
  802730:	cd 30                	int    $0x30
  802732:	89 c3                	mov    %eax,%ebx
  802734:	89 5d c4             	mov    %ebx,-0x3c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802737:	8b 45 c4             	mov    -0x3c(%rbp),%eax
	extern void _pgfault_upcall(void);
	envid_t envid; 
	uint64_t addr;
	int r;
	envid = sys_exofork();
  80273a:	89 45 d4             	mov    %eax,-0x2c(%rbp)
   	if (envid < 0)
  80273d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802741:	79 30                	jns    802773 <fork+0x6c>
                panic("sys_exofork: %e", envid);
  802743:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802746:	89 c1                	mov    %eax,%ecx
  802748:	48 ba 74 5d 80 00 00 	movabs $0x805d74,%rdx
  80274f:	00 00 00 
  802752:	be 7f 00 00 00       	mov    $0x7f,%esi
  802757:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  80275e:	00 00 00 
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  80276d:	00 00 00 
  802770:	41 ff d0             	callq  *%r8
        if (envid == 0) 
  802773:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802777:	75 4c                	jne    8027c5 <fork+0xbe>
	{
                // We're the child.
                // The copied value of the global variable 'thisenv'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                thisenv = &envs[ENVX(sys_getenvid())];
  802779:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
  802785:	48 98                	cltq   
  802787:	48 89 c2             	mov    %rax,%rdx
  80278a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  802790:	48 89 d0             	mov    %rdx,%rax
  802793:	48 c1 e0 03          	shl    $0x3,%rax
  802797:	48 01 d0             	add    %rdx,%rax
  80279a:	48 c1 e0 05          	shl    $0x5,%rax
  80279e:	48 89 c2             	mov    %rax,%rdx
  8027a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027a8:	00 00 00 
  8027ab:	48 01 c2             	add    %rax,%rdx
  8027ae:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  8027b5:	00 00 00 
  8027b8:	48 89 10             	mov    %rdx,(%rax)
                return 0;
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	e9 38 02 00 00       	jmpq   8029fd <fork+0x2f6>
        }
	r=sys_page_alloc(envid,(void *)(UXSTACKTOP-PGSIZE),PTE_U|PTE_P|PTE_W);
  8027c5:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8027c8:	ba 07 00 00 00       	mov    $0x7,%edx
  8027cd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8027d2:	89 c7                	mov    %eax,%edi
  8027d4:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8027db:	00 00 00 
  8027de:	ff d0                	callq  *%rax
  8027e0:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if (r < 0)
  8027e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8027e7:	79 30                	jns    802819 <fork+0x112>
    		panic("panic in fork:sys_page_alloc:%e",r);
  8027e9:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8027ec:	89 c1                	mov    %eax,%ecx
  8027ee:	48 ba 88 5d 80 00 00 	movabs $0x805d88,%rdx
  8027f5:	00 00 00 
  8027f8:	be 8b 00 00 00       	mov    $0x8b,%esi
  8027fd:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802804:	00 00 00 
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
  80280c:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  802813:	00 00 00 
  802816:	41 ff d0             	callq  *%r8
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
  802819:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%rbp)
	vpdpe_entries = VPDPE(UTOP);
  802820:	c7 45 c8 00 02 00 00 	movl   $0x200,-0x38(%rbp)
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802827:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
  80282e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
  802835:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80283c:	e9 0a 01 00 00       	jmpq   80294b <fork+0x244>
	{
		if(uvpml4e[a] & PTE_P)
  802841:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802848:	01 00 00 
  80284b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80284e:	48 63 d2             	movslq %edx,%rdx
  802851:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802855:	83 e0 01             	and    $0x1,%eax
  802858:	84 c0                	test   %al,%al
  80285a:	0f 84 e7 00 00 00    	je     802947 <fork+0x240>
		{
			for(b=0;b<vpdpe_entries;b++)
  802860:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  802867:	e9 cf 00 00 00       	jmpq   80293b <fork+0x234>
			{
				if(uvpde[b] & PTE_P)
  80286c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802873:	01 00 00 
  802876:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802879:	48 63 d2             	movslq %edx,%rdx
  80287c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802880:	83 e0 01             	and    $0x1,%eax
  802883:	84 c0                	test   %al,%al
  802885:	0f 84 a0 00 00 00    	je     80292b <fork+0x224>
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  80288b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  802892:	e9 85 00 00 00       	jmpq   80291c <fork+0x215>
					{
						if(uvpd[c1] & PTE_P)
  802897:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80289e:	01 00 00 
  8028a1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028a4:	48 63 d2             	movslq %edx,%rdx
  8028a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028ab:	83 e0 01             	and    $0x1,%eax
  8028ae:	84 c0                	test   %al,%al
  8028b0:	74 56                	je     802908 <fork+0x201>
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8028b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
  8028b9:	eb 42                	jmp    8028fd <fork+0x1f6>
							{
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
  8028bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c2:	01 00 00 
  8028c5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8028c8:	48 63 d2             	movslq %edx,%rdx
  8028cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028cf:	83 e0 01             	and    $0x1,%eax
  8028d2:	84 c0                	test   %al,%al
  8028d4:	74 1f                	je     8028f5 <fork+0x1ee>
  8028d6:	81 7d d8 ff f7 0e 00 	cmpl   $0xef7ff,-0x28(%rbp)
  8028dd:	74 16                	je     8028f5 <fork+0x1ee>
									 duppage(envid,d1);
  8028df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8028e2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8028e5:	89 d6                	mov    %edx,%esi
  8028e7:	89 c7                	mov    %eax,%edi
  8028e9:	48 b8 28 25 80 00 00 	movabs $0x802528,%rax
  8028f0:	00 00 00 
  8028f3:	ff d0                	callq  *%rax
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
					{
						if(uvpd[c1] & PTE_P)
						{
							for(d=0;d<NPTENTRIES;d++,d1++)
  8028f5:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
  8028f9:	83 45 d8 01          	addl   $0x1,-0x28(%rbp)
  8028fd:	81 7d e0 ff 01 00 00 	cmpl   $0x1ff,-0x20(%rbp)
  802904:	7e b5                	jle    8028bb <fork+0x1b4>
  802906:	eb 0c                	jmp    802914 <fork+0x20d>
								if((uvpt[d1] & PTE_P) && (d1 != VPN(UXSTACKTOP-PGSIZE)))
									 duppage(envid,d1);
							}
						}
						else
							d1=(c1+1)*NPTENTRIES;
  802908:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80290b:	83 c0 01             	add    $0x1,%eax
  80290e:	c1 e0 09             	shl    $0x9,%eax
  802911:	89 45 d8             	mov    %eax,-0x28(%rbp)
		{
			for(b=0;b<vpdpe_entries;b++)
			{
				if(uvpde[b] & PTE_P)
				{
					for(c=0;c<NPDENTRIES;c++,c1++)
  802914:	83 45 e4 01          	addl   $0x1,-0x1c(%rbp)
  802918:	83 45 dc 01          	addl   $0x1,-0x24(%rbp)
  80291c:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%rbp)
  802923:	0f 8e 6e ff ff ff    	jle    802897 <fork+0x190>
  802929:	eb 0c                	jmp    802937 <fork+0x230>
						else
							d1=(c1+1)*NPTENTRIES;
					}
				}
				else
					c1=(b+1)*NPDENTRIES;
  80292b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80292e:	83 c0 01             	add    $0x1,%eax
  802931:	c1 e0 09             	shl    $0x9,%eax
  802934:	89 45 dc             	mov    %eax,-0x24(%rbp)
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
	{
		if(uvpml4e[a] & PTE_P)
		{
			for(b=0;b<vpdpe_entries;b++)
  802937:	83 45 e8 01          	addl   $0x1,-0x18(%rbp)
  80293b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80293e:	3b 45 c8             	cmp    -0x38(%rbp),%eax
  802941:	0f 8c 25 ff ff ff    	jl     80286c <fork+0x165>
	if (r < 0)
    		panic("panic in fork:sys_page_alloc:%e",r);
	int vpml4e_entries,vpdpe_entries,a,b,c,d,c1,d1;
	vpml4e_entries = VPML4E(UTOP);
	vpdpe_entries = VPDPE(UTOP);
	for(c1=0,d1=0,a=0;a<vpml4e_entries;a++)
  802947:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80294b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80294e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802951:	0f 8c ea fe ff ff    	jl     802841 <fork+0x13a>
					c1=(b+1)*NPDENTRIES;
			}
		}
	}
	
	r=sys_env_set_pgfault_upcall(envid,_pgfault_upcall);
  802957:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80295a:	48 be 84 52 80 00 00 	movabs $0x805284,%rsi
  802961:	00 00 00 
  802964:	89 c7                	mov    %eax,%edi
  802966:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  80296d:	00 00 00 
  802970:	ff d0                	callq  *%rax
  802972:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  802975:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802979:	79 30                	jns    8029ab <fork+0x2a4>
		panic("panic in fork:sys_env_set_pgfault_upcall:%e",r);
  80297b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80297e:	89 c1                	mov    %eax,%ecx
  802980:	48 ba a8 5d 80 00 00 	movabs $0x805da8,%rdx
  802987:	00 00 00 
  80298a:	be ad 00 00 00       	mov    $0xad,%esi
  80298f:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802996:	00 00 00 
  802999:	b8 00 00 00 00       	mov    $0x0,%eax
  80299e:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8029a5:	00 00 00 
  8029a8:	41 ff d0             	callq  *%r8
	r = sys_env_set_status(envid,ENV_RUNNABLE);
  8029ab:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8029ae:	be 02 00 00 00       	mov    $0x2,%esi
  8029b3:	89 c7                	mov    %eax,%edi
  8029b5:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
  8029c1:	89 45 d0             	mov    %eax,-0x30(%rbp)
	if(r<0)
  8029c4:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8029c8:	79 30                	jns    8029fa <fork+0x2f3>
                panic("panic in fork:sys_env_set_status:%e",r);
  8029ca:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8029cd:	89 c1                	mov    %eax,%ecx
  8029cf:	48 ba d8 5d 80 00 00 	movabs $0x805dd8,%rdx
  8029d6:	00 00 00 
  8029d9:	be b0 00 00 00       	mov    $0xb0,%esi
  8029de:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  8029e5:	00 00 00 
  8029e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ed:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8029f4:	00 00 00 
  8029f7:	41 ff d0             	callq  *%r8
	return envid;
  8029fa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
}
  8029fd:	48 83 c4 48          	add    $0x48,%rsp
  802a01:	5b                   	pop    %rbx
  802a02:	5d                   	pop    %rbp
  802a03:	c3                   	retq   

0000000000802a04 <sfork>:

// Challenge!
int
sfork(void)
{
  802a04:	55                   	push   %rbp
  802a05:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802a08:	48 ba fc 5d 80 00 00 	movabs $0x805dfc,%rdx
  802a0f:	00 00 00 
  802a12:	be b8 00 00 00       	mov    $0xb8,%esi
  802a17:	48 bf 65 5c 80 00 00 	movabs $0x805c65,%rdi
  802a1e:	00 00 00 
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  802a2d:	00 00 00 
  802a30:	ff d1                	callq  *%rcx
	...

0000000000802a34 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a34:	55                   	push   %rbp
  802a35:	48 89 e5             	mov    %rsp,%rbp
  802a38:	48 83 ec 08          	sub    $0x8,%rsp
  802a3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a40:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a44:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a4b:	ff ff ff 
  802a4e:	48 01 d0             	add    %rdx,%rax
  802a51:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 08          	sub    $0x8,%rsp
  802a5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a67:	48 89 c7             	mov    %rax,%rdi
  802a6a:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
  802a76:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a7c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a80:	c9                   	leaveq 
  802a81:	c3                   	retq   

0000000000802a82 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a82:	55                   	push   %rbp
  802a83:	48 89 e5             	mov    %rsp,%rbp
  802a86:	48 83 ec 18          	sub    $0x18,%rsp
  802a8a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a95:	eb 6b                	jmp    802b02 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a9a:	48 98                	cltq   
  802a9c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aa2:	48 c1 e0 0c          	shl    $0xc,%rax
  802aa6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aae:	48 89 c2             	mov    %rax,%rdx
  802ab1:	48 c1 ea 15          	shr    $0x15,%rdx
  802ab5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802abc:	01 00 00 
  802abf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac3:	83 e0 01             	and    $0x1,%eax
  802ac6:	48 85 c0             	test   %rax,%rax
  802ac9:	74 21                	je     802aec <fd_alloc+0x6a>
  802acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802acf:	48 89 c2             	mov    %rax,%rdx
  802ad2:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ad6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802add:	01 00 00 
  802ae0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae4:	83 e0 01             	and    $0x1,%eax
  802ae7:	48 85 c0             	test   %rax,%rax
  802aea:	75 12                	jne    802afe <fd_alloc+0x7c>
			*fd_store = fd;
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802af4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
  802afc:	eb 1a                	jmp    802b18 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802afe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b02:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b06:	7e 8f                	jle    802a97 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b0c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b13:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b18:	c9                   	leaveq 
  802b19:	c3                   	retq   

0000000000802b1a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b1a:	55                   	push   %rbp
  802b1b:	48 89 e5             	mov    %rsp,%rbp
  802b1e:	48 83 ec 20          	sub    $0x20,%rsp
  802b22:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b29:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b2d:	78 06                	js     802b35 <fd_lookup+0x1b>
  802b2f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b33:	7e 07                	jle    802b3c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b3a:	eb 6c                	jmp    802ba8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b3f:	48 98                	cltq   
  802b41:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b47:	48 c1 e0 0c          	shl    $0xc,%rax
  802b4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b53:	48 89 c2             	mov    %rax,%rdx
  802b56:	48 c1 ea 15          	shr    $0x15,%rdx
  802b5a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b61:	01 00 00 
  802b64:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b68:	83 e0 01             	and    $0x1,%eax
  802b6b:	48 85 c0             	test   %rax,%rax
  802b6e:	74 21                	je     802b91 <fd_lookup+0x77>
  802b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b74:	48 89 c2             	mov    %rax,%rdx
  802b77:	48 c1 ea 0c          	shr    $0xc,%rdx
  802b7b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b82:	01 00 00 
  802b85:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b89:	83 e0 01             	and    $0x1,%eax
  802b8c:	48 85 c0             	test   %rax,%rax
  802b8f:	75 07                	jne    802b98 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b91:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b96:	eb 10                	jmp    802ba8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ba0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba8:	c9                   	leaveq 
  802ba9:	c3                   	retq   

0000000000802baa <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802baa:	55                   	push   %rbp
  802bab:	48 89 e5             	mov    %rsp,%rbp
  802bae:	48 83 ec 30          	sub    $0x30,%rsp
  802bb2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802bb6:	89 f0                	mov    %esi,%eax
  802bb8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802bbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bbf:	48 89 c7             	mov    %rax,%rdi
  802bc2:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
  802bce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bd2:	48 89 d6             	mov    %rdx,%rsi
  802bd5:	89 c7                	mov    %eax,%edi
  802bd7:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  802bde:	00 00 00 
  802be1:	ff d0                	callq  *%rax
  802be3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802be6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bea:	78 0a                	js     802bf6 <fd_close+0x4c>
	    || fd != fd2)
  802bec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802bf4:	74 12                	je     802c08 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802bf6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802bfa:	74 05                	je     802c01 <fd_close+0x57>
  802bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bff:	eb 05                	jmp    802c06 <fd_close+0x5c>
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	eb 69                	jmp    802c71 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c0c:	8b 00                	mov    (%rax),%eax
  802c0e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c12:	48 89 d6             	mov    %rdx,%rsi
  802c15:	89 c7                	mov    %eax,%edi
  802c17:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c2a:	78 2a                	js     802c56 <fd_close+0xac>
		if (dev->dev_close)
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c34:	48 85 c0             	test   %rax,%rax
  802c37:	74 16                	je     802c4f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3d:	48 8b 50 20          	mov    0x20(%rax),%rdx
  802c41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c45:	48 89 c7             	mov    %rax,%rdi
  802c48:	ff d2                	callq  *%rdx
  802c4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4d:	eb 07                	jmp    802c56 <fd_close+0xac>
		else
			r = 0;
  802c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c56:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5a:	48 89 c6             	mov    %rax,%rsi
  802c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802c62:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  802c69:	00 00 00 
  802c6c:	ff d0                	callq  *%rax
	return r;
  802c6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c71:	c9                   	leaveq 
  802c72:	c3                   	retq   

0000000000802c73 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c73:	55                   	push   %rbp
  802c74:	48 89 e5             	mov    %rsp,%rbp
  802c77:	48 83 ec 20          	sub    $0x20,%rsp
  802c7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c89:	eb 41                	jmp    802ccc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c8b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802c92:	00 00 00 
  802c95:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c98:	48 63 d2             	movslq %edx,%rdx
  802c9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c9f:	8b 00                	mov    (%rax),%eax
  802ca1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802ca4:	75 22                	jne    802cc8 <dev_lookup+0x55>
			*dev = devtab[i];
  802ca6:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802cad:	00 00 00 
  802cb0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cb3:	48 63 d2             	movslq %edx,%rdx
  802cb6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802cba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbe:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc6:	eb 60                	jmp    802d28 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802cc8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ccc:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  802cd3:	00 00 00 
  802cd6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cd9:	48 63 d2             	movslq %edx,%rdx
  802cdc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ce0:	48 85 c0             	test   %rax,%rax
  802ce3:	75 a6                	jne    802c8b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ce5:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  802cec:	00 00 00 
  802cef:	48 8b 00             	mov    (%rax),%rax
  802cf2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cf8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802cfb:	89 c6                	mov    %eax,%esi
  802cfd:	48 bf 18 5e 80 00 00 	movabs $0x805e18,%rdi
  802d04:	00 00 00 
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0c:	48 b9 3b 0b 80 00 00 	movabs $0x800b3b,%rcx
  802d13:	00 00 00 
  802d16:	ff d1                	callq  *%rcx
	*dev = 0;
  802d18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d28:	c9                   	leaveq 
  802d29:	c3                   	retq   

0000000000802d2a <close>:

int
close(int fdnum)
{
  802d2a:	55                   	push   %rbp
  802d2b:	48 89 e5             	mov    %rsp,%rbp
  802d2e:	48 83 ec 20          	sub    $0x20,%rsp
  802d32:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d3c:	48 89 d6             	mov    %rdx,%rsi
  802d3f:	89 c7                	mov    %eax,%edi
  802d41:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
  802d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	79 05                	jns    802d5b <close+0x31>
		return r;
  802d56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d59:	eb 18                	jmp    802d73 <close+0x49>
	else
		return fd_close(fd, 1);
  802d5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5f:	be 01 00 00 00       	mov    $0x1,%esi
  802d64:	48 89 c7             	mov    %rax,%rdi
  802d67:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
}
  802d73:	c9                   	leaveq 
  802d74:	c3                   	retq   

0000000000802d75 <close_all>:

void
close_all(void)
{
  802d75:	55                   	push   %rbp
  802d76:	48 89 e5             	mov    %rsp,%rbp
  802d79:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d84:	eb 15                	jmp    802d9b <close_all+0x26>
		close(i);
  802d86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d89:	89 c7                	mov    %eax,%edi
  802d8b:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d97:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d9b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d9f:	7e e5                	jle    802d86 <close_all+0x11>
		close(i);
}
  802da1:	c9                   	leaveq 
  802da2:	c3                   	retq   

0000000000802da3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802da3:	55                   	push   %rbp
  802da4:	48 89 e5             	mov    %rsp,%rbp
  802da7:	48 83 ec 40          	sub    $0x40,%rsp
  802dab:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802dae:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802db1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802db5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802db8:	48 89 d6             	mov    %rdx,%rsi
  802dbb:	89 c7                	mov    %eax,%edi
  802dbd:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  802dc4:	00 00 00 
  802dc7:	ff d0                	callq  *%rax
  802dc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dcc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd0:	79 08                	jns    802dda <dup+0x37>
		return r;
  802dd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd5:	e9 70 01 00 00       	jmpq   802f4a <dup+0x1a7>
	close(newfdnum);
  802dda:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ddd:	89 c7                	mov    %eax,%edi
  802ddf:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  802de6:	00 00 00 
  802de9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802deb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802dee:	48 98                	cltq   
  802df0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802df6:	48 c1 e0 0c          	shl    $0xc,%rax
  802dfa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802dfe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e02:	48 89 c7             	mov    %rax,%rdi
  802e05:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802e0c:	00 00 00 
  802e0f:	ff d0                	callq  *%rax
  802e11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e19:	48 89 c7             	mov    %rax,%rdi
  802e1c:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802e23:	00 00 00 
  802e26:	ff d0                	callq  *%rax
  802e28:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e30:	48 89 c2             	mov    %rax,%rdx
  802e33:	48 c1 ea 15          	shr    $0x15,%rdx
  802e37:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e3e:	01 00 00 
  802e41:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e45:	83 e0 01             	and    $0x1,%eax
  802e48:	84 c0                	test   %al,%al
  802e4a:	74 71                	je     802ebd <dup+0x11a>
  802e4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e50:	48 89 c2             	mov    %rax,%rdx
  802e53:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e57:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e5e:	01 00 00 
  802e61:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e65:	83 e0 01             	and    $0x1,%eax
  802e68:	84 c0                	test   %al,%al
  802e6a:	74 51                	je     802ebd <dup+0x11a>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e70:	48 89 c2             	mov    %rax,%rdx
  802e73:	48 c1 ea 0c          	shr    $0xc,%rdx
  802e77:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e7e:	01 00 00 
  802e81:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e85:	89 c1                	mov    %eax,%ecx
  802e87:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802e8d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e95:	41 89 c8             	mov    %ecx,%r8d
  802e98:	48 89 d1             	mov    %rdx,%rcx
  802e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802ea0:	48 89 c6             	mov    %rax,%rsi
  802ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  802ea8:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
  802eb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802eb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ebb:	78 56                	js     802f13 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ebd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec1:	48 89 c2             	mov    %rax,%rdx
  802ec4:	48 c1 ea 0c          	shr    $0xc,%rdx
  802ec8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ecf:	01 00 00 
  802ed2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ed6:	89 c1                	mov    %eax,%ecx
  802ed8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  802ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ee2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ee6:	41 89 c8             	mov    %ecx,%r8d
  802ee9:	48 89 d1             	mov    %rdx,%rcx
  802eec:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef1:	48 89 c6             	mov    %rax,%rsi
  802ef4:	bf 00 00 00 00       	mov    $0x0,%edi
  802ef9:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
  802f05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f0c:	78 08                	js     802f16 <dup+0x173>
		goto err;

	return newfdnum;
  802f0e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f11:	eb 37                	jmp    802f4a <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802f13:	90                   	nop
  802f14:	eb 01                	jmp    802f17 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802f16:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1b:	48 89 c6             	mov    %rax,%rsi
  802f1e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f23:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  802f2a:	00 00 00 
  802f2d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f33:	48 89 c6             	mov    %rax,%rsi
  802f36:	bf 00 00 00 00       	mov    $0x0,%edi
  802f3b:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
	return r;
  802f47:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f4a:	c9                   	leaveq 
  802f4b:	c3                   	retq   

0000000000802f4c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f4c:	55                   	push   %rbp
  802f4d:	48 89 e5             	mov    %rsp,%rbp
  802f50:	48 83 ec 40          	sub    $0x40,%rsp
  802f54:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f57:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f5b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f5f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f63:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f66:	48 89 d6             	mov    %rdx,%rsi
  802f69:	89 c7                	mov    %eax,%edi
  802f6b:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7e:	78 24                	js     802fa4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f84:	8b 00                	mov    (%rax),%eax
  802f86:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f8a:	48 89 d6             	mov    %rdx,%rsi
  802f8d:	89 c7                	mov    %eax,%edi
  802f8f:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa2:	79 05                	jns    802fa9 <read+0x5d>
		return r;
  802fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa7:	eb 7a                	jmp    803023 <read+0xd7>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802fa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fad:	8b 40 08             	mov    0x8(%rax),%eax
  802fb0:	83 e0 03             	and    $0x3,%eax
  802fb3:	83 f8 01             	cmp    $0x1,%eax
  802fb6:	75 3a                	jne    802ff2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fb8:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  802fbf:	00 00 00 
  802fc2:	48 8b 00             	mov    (%rax),%rax
  802fc5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fcb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fce:	89 c6                	mov    %eax,%esi
  802fd0:	48 bf 37 5e 80 00 00 	movabs $0x805e37,%rdi
  802fd7:	00 00 00 
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	48 b9 3b 0b 80 00 00 	movabs $0x800b3b,%rcx
  802fe6:	00 00 00 
  802fe9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802feb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ff0:	eb 31                	jmp    803023 <read+0xd7>
	}
	if (!dev->dev_read)
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ffa:	48 85 c0             	test   %rax,%rax
  802ffd:	75 07                	jne    803006 <read+0xba>
		return -E_NOT_SUPP;
  802fff:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803004:	eb 1d                	jmp    803023 <read+0xd7>
	return (*dev->dev_read)(fd, buf, n);
  803006:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300a:	4c 8b 40 10          	mov    0x10(%rax),%r8
  80300e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803012:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803016:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80301a:	48 89 ce             	mov    %rcx,%rsi
  80301d:	48 89 c7             	mov    %rax,%rdi
  803020:	41 ff d0             	callq  *%r8
}
  803023:	c9                   	leaveq 
  803024:	c3                   	retq   

0000000000803025 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803025:	55                   	push   %rbp
  803026:	48 89 e5             	mov    %rsp,%rbp
  803029:	48 83 ec 30          	sub    $0x30,%rsp
  80302d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803030:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803034:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80303f:	eb 46                	jmp    803087 <readn+0x62>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803041:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803044:	48 98                	cltq   
  803046:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80304a:	48 29 c2             	sub    %rax,%rdx
  80304d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803050:	48 98                	cltq   
  803052:	48 89 c1             	mov    %rax,%rcx
  803055:	48 03 4d e0          	add    -0x20(%rbp),%rcx
  803059:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305c:	48 89 ce             	mov    %rcx,%rsi
  80305f:	89 c7                	mov    %eax,%edi
  803061:	48 b8 4c 2f 80 00 00 	movabs $0x802f4c,%rax
  803068:	00 00 00 
  80306b:	ff d0                	callq  *%rax
  80306d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803070:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803074:	79 05                	jns    80307b <readn+0x56>
			return m;
  803076:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803079:	eb 1d                	jmp    803098 <readn+0x73>
		if (m == 0)
  80307b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80307f:	74 13                	je     803094 <readn+0x6f>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803081:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803084:	01 45 fc             	add    %eax,-0x4(%rbp)
  803087:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308a:	48 98                	cltq   
  80308c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803090:	72 af                	jb     803041 <readn+0x1c>
  803092:	eb 01                	jmp    803095 <readn+0x70>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803094:	90                   	nop
	}
	return tot;
  803095:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803098:	c9                   	leaveq 
  803099:	c3                   	retq   

000000000080309a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80309a:	55                   	push   %rbp
  80309b:	48 89 e5             	mov    %rsp,%rbp
  80309e:	48 83 ec 40          	sub    $0x40,%rsp
  8030a2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030a5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030a9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030b4:	48 89 d6             	mov    %rdx,%rsi
  8030b7:	89 c7                	mov    %eax,%edi
  8030b9:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
  8030c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030cc:	78 24                	js     8030f2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d2:	8b 00                	mov    (%rax),%eax
  8030d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030d8:	48 89 d6             	mov    %rdx,%rsi
  8030db:	89 c7                	mov    %eax,%edi
  8030dd:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  8030e4:	00 00 00 
  8030e7:	ff d0                	callq  *%rax
  8030e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f0:	79 05                	jns    8030f7 <write+0x5d>
		return r;
  8030f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f5:	eb 79                	jmp    803170 <write+0xd6>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030fb:	8b 40 08             	mov    0x8(%rax),%eax
  8030fe:	83 e0 03             	and    $0x3,%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	75 3a                	jne    80313f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803105:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  80310c:	00 00 00 
  80310f:	48 8b 00             	mov    (%rax),%rax
  803112:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803118:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80311b:	89 c6                	mov    %eax,%esi
  80311d:	48 bf 53 5e 80 00 00 	movabs $0x805e53,%rdi
  803124:	00 00 00 
  803127:	b8 00 00 00 00       	mov    $0x0,%eax
  80312c:	48 b9 3b 0b 80 00 00 	movabs $0x800b3b,%rcx
  803133:	00 00 00 
  803136:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803138:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80313d:	eb 31                	jmp    803170 <write+0xd6>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80313f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803143:	48 8b 40 18          	mov    0x18(%rax),%rax
  803147:	48 85 c0             	test   %rax,%rax
  80314a:	75 07                	jne    803153 <write+0xb9>
		return -E_NOT_SUPP;
  80314c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803151:	eb 1d                	jmp    803170 <write+0xd6>
	return (*dev->dev_write)(fd, buf, n);
  803153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803157:	4c 8b 40 18          	mov    0x18(%rax),%r8
  80315b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803163:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803167:	48 89 ce             	mov    %rcx,%rsi
  80316a:	48 89 c7             	mov    %rax,%rdi
  80316d:	41 ff d0             	callq  *%r8
}
  803170:	c9                   	leaveq 
  803171:	c3                   	retq   

0000000000803172 <seek>:

int
seek(int fdnum, off_t offset)
{
  803172:	55                   	push   %rbp
  803173:	48 89 e5             	mov    %rsp,%rbp
  803176:	48 83 ec 18          	sub    $0x18,%rsp
  80317a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80317d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803180:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803184:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803187:	48 89 d6             	mov    %rdx,%rsi
  80318a:	89 c7                	mov    %eax,%edi
  80318c:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
  803198:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319f:	79 05                	jns    8031a6 <seek+0x34>
		return r;
  8031a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a4:	eb 0f                	jmp    8031b5 <seek+0x43>
	fd->fd_offset = offset;
  8031a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031aa:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031ad:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8031b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b5:	c9                   	leaveq 
  8031b6:	c3                   	retq   

00000000008031b7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031b7:	55                   	push   %rbp
  8031b8:	48 89 e5             	mov    %rsp,%rbp
  8031bb:	48 83 ec 30          	sub    $0x30,%rsp
  8031bf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031c2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031cc:	48 89 d6             	mov    %rdx,%rsi
  8031cf:	89 c7                	mov    %eax,%edi
  8031d1:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
  8031dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e4:	78 24                	js     80320a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ea:	8b 00                	mov    (%rax),%eax
  8031ec:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031f0:	48 89 d6             	mov    %rdx,%rsi
  8031f3:	89 c7                	mov    %eax,%edi
  8031f5:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
  803201:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803204:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803208:	79 05                	jns    80320f <ftruncate+0x58>
		return r;
  80320a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320d:	eb 72                	jmp    803281 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80320f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803213:	8b 40 08             	mov    0x8(%rax),%eax
  803216:	83 e0 03             	and    $0x3,%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	75 3a                	jne    803257 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80321d:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  803224:	00 00 00 
  803227:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80322a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803230:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803233:	89 c6                	mov    %eax,%esi
  803235:	48 bf 70 5e 80 00 00 	movabs $0x805e70,%rdi
  80323c:	00 00 00 
  80323f:	b8 00 00 00 00       	mov    $0x0,%eax
  803244:	48 b9 3b 0b 80 00 00 	movabs $0x800b3b,%rcx
  80324b:	00 00 00 
  80324e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803255:	eb 2a                	jmp    803281 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80325f:	48 85 c0             	test   %rax,%rax
  803262:	75 07                	jne    80326b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803264:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803269:	eb 16                	jmp    803281 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80326b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326f:	48 8b 48 30          	mov    0x30(%rax),%rcx
  803273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803277:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80327a:	89 d6                	mov    %edx,%esi
  80327c:	48 89 c7             	mov    %rax,%rdi
  80327f:	ff d1                	callq  *%rcx
}
  803281:	c9                   	leaveq 
  803282:	c3                   	retq   

0000000000803283 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803283:	55                   	push   %rbp
  803284:	48 89 e5             	mov    %rsp,%rbp
  803287:	48 83 ec 30          	sub    $0x30,%rsp
  80328b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80328e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803292:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803296:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803299:	48 89 d6             	mov    %rdx,%rsi
  80329c:	89 c7                	mov    %eax,%edi
  80329e:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  8032a5:	00 00 00 
  8032a8:	ff d0                	callq  *%rax
  8032aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b1:	78 24                	js     8032d7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b7:	8b 00                	mov    (%rax),%eax
  8032b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032bd:	48 89 d6             	mov    %rdx,%rsi
  8032c0:	89 c7                	mov    %eax,%edi
  8032c2:	48 b8 73 2c 80 00 00 	movabs $0x802c73,%rax
  8032c9:	00 00 00 
  8032cc:	ff d0                	callq  *%rax
  8032ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d5:	79 05                	jns    8032dc <fstat+0x59>
		return r;
  8032d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032da:	eb 5e                	jmp    80333a <fstat+0xb7>
	if (!dev->dev_stat)
  8032dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032e4:	48 85 c0             	test   %rax,%rax
  8032e7:	75 07                	jne    8032f0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032e9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032ee:	eb 4a                	jmp    80333a <fstat+0xb7>
	stat->st_name[0] = 0;
  8032f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803302:	00 00 00 
	stat->st_isdir = 0;
  803305:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803309:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803310:	00 00 00 
	stat->st_dev = dev;
  803313:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803317:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803322:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803326:	48 8b 48 28          	mov    0x28(%rax),%rcx
  80332a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803332:	48 89 d6             	mov    %rdx,%rsi
  803335:	48 89 c7             	mov    %rax,%rdi
  803338:	ff d1                	callq  *%rcx
}
  80333a:	c9                   	leaveq 
  80333b:	c3                   	retq   

000000000080333c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80333c:	55                   	push   %rbp
  80333d:	48 89 e5             	mov    %rsp,%rbp
  803340:	48 83 ec 20          	sub    $0x20,%rsp
  803344:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80334c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803350:	be 00 00 00 00       	mov    $0x0,%esi
  803355:	48 89 c7             	mov    %rax,%rdi
  803358:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  80335f:	00 00 00 
  803362:	ff d0                	callq  *%rax
  803364:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803367:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336b:	79 05                	jns    803372 <stat+0x36>
		return fd;
  80336d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803370:	eb 2f                	jmp    8033a1 <stat+0x65>
	r = fstat(fd, stat);
  803372:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803379:	48 89 d6             	mov    %rdx,%rsi
  80337c:	89 c7                	mov    %eax,%edi
  80337e:	48 b8 83 32 80 00 00 	movabs $0x803283,%rax
  803385:	00 00 00 
  803388:	ff d0                	callq  *%rax
  80338a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80338d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803390:	89 c7                	mov    %eax,%edi
  803392:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  803399:	00 00 00 
  80339c:	ff d0                	callq  *%rax
	return r;
  80339e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   
	...

00000000008033a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 83 ec 10          	sub    $0x10,%rsp
  8033ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8033b3:	48 b8 28 90 80 00 00 	movabs $0x809028,%rax
  8033ba:	00 00 00 
  8033bd:	8b 00                	mov    (%rax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	75 1d                	jne    8033e0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8033c8:	48 b8 93 54 80 00 00 	movabs $0x805493,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	48 ba 28 90 80 00 00 	movabs $0x809028,%rdx
  8033db:	00 00 00 
  8033de:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033e0:	48 b8 28 90 80 00 00 	movabs $0x809028,%rax
  8033e7:	00 00 00 
  8033ea:	8b 00                	mov    (%rax),%eax
  8033ec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033ef:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033f4:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8033fb:	00 00 00 
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 d0 53 80 00 00 	movabs $0x8053d0,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80340c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803410:	ba 00 00 00 00       	mov    $0x0,%edx
  803415:	48 89 c6             	mov    %rax,%rsi
  803418:	bf 00 00 00 00       	mov    $0x0,%edi
  80341d:	48 b8 10 53 80 00 00 	movabs $0x805310,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 20          	sub    $0x20,%rsp
  803433:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803437:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// LAB 5: Your code here
	
	struct Fd *fd;
	int r;
	
	if(strlen(path)>= MAXPATHLEN)
  80343a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343e:	48 89 c7             	mov    %rax,%rdi
  803441:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
  80344d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803452:	7e 0a                	jle    80345e <open+0x33>
                return -E_BAD_PATH;
  803454:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803459:	e9 a5 00 00 00       	jmpq   803503 <open+0xd8>
	if((r=fd_alloc(&fd))<0)
  80345e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803462:	48 89 c7             	mov    %rax,%rdi
  803465:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803478:	79 08                	jns    803482 <open+0x57>
		return r;
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	e9 81 00 00 00       	jmpq   803503 <open+0xd8>
	strcpy(fsipcbuf.open.req_path,path);
  803482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803486:	48 89 c6             	mov    %rax,%rsi
  803489:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803490:	00 00 00 
  803493:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  80349a:	00 00 00 
  80349d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode=mode;
  80349f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034a6:	00 00 00 
  8034a9:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8034ac:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	r=fsipc(FSREQ_OPEN, fd);
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	48 89 c6             	mov    %rax,%rsi
  8034b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8034be:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
  8034ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(r<0)
  8034cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d1:	79 1d                	jns    8034f0 <open+0xc5>
	{
		fd_close(fd,0);
  8034d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d7:	be 00 00 00 00       	mov    $0x0,%esi
  8034dc:	48 89 c7             	mov    %rax,%rdi
  8034df:	48 b8 aa 2b 80 00 00 	movabs $0x802baa,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
		return r;
  8034eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ee:	eb 13                	jmp    803503 <open+0xd8>
	}
	return fd2num(fd);
  8034f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
	


}
  803503:	c9                   	leaveq 
  803504:	c3                   	retq   

0000000000803505 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	48 83 ec 10          	sub    $0x10,%rsp
  80350d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803515:	8b 50 0c             	mov    0xc(%rax),%edx
  803518:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80351f:	00 00 00 
  803522:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803524:	be 00 00 00 00       	mov    $0x0,%esi
  803529:	bf 06 00 00 00       	mov    $0x6,%edi
  80352e:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
}
  80353a:	c9                   	leaveq 
  80353b:	c3                   	retq   

000000000080353c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80353c:	55                   	push   %rbp
  80353d:	48 89 e5             	mov    %rsp,%rbp
  803540:	48 83 ec 30          	sub    $0x30,%rsp
  803544:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803548:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80354c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	ssize_t r;
	
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803554:	8b 50 0c             	mov    0xc(%rax),%edx
  803557:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355e:	00 00 00 
  803561:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803563:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80356a:	00 00 00 
  80356d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803571:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803575:	be 00 00 00 00       	mov    $0x0,%esi
  80357a:	bf 03 00 00 00       	mov    $0x3,%edi
  80357f:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803592:	79 05                	jns    803599 <devfile_read+0x5d>
	{
		return r;
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803597:	eb 2c                	jmp    8035c5 <devfile_read+0x89>
	}
	if(r > 0)
  803599:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80359d:	7e 23                	jle    8035c2 <devfile_read+0x86>
		memmove(buf, (void *)&fsipcbuf.readRet.ret_buf, r);
  80359f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a2:	48 63 d0             	movslq %eax,%rdx
  8035a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a9:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8035b0:	00 00 00 
  8035b3:	48 89 c7             	mov    %rax,%rdi
  8035b6:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  8035bd:	00 00 00 
  8035c0:	ff d0                	callq  *%rax
	return r;
  8035c2:	8b 45 fc             	mov    -0x4(%rbp),%eax



}
  8035c5:	c9                   	leaveq 
  8035c6:	c3                   	retq   

00000000008035c7 <devfile_write>:


static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035c7:	55                   	push   %rbp
  8035c8:	48 89 e5             	mov    %rsp,%rbp
  8035cb:	48 83 ec 30          	sub    $0x30,%rsp
  8035cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	ssize_t r,status;
	fsipcbuf.write.req_fileid = fd -> fd_file.id;
  8035db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035df:	8b 50 0c             	mov    0xc(%rax),%edx
  8035e2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035e9:	00 00 00 
  8035ec:	89 10                	mov    %edx,(%rax)
	//fsipcbuf.write.req_n=n;
	if(n > (PGSIZE - (sizeof(int) + sizeof(size_t)))) 
  8035ee:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8035f5:	00 
  8035f6:	76 08                	jbe    803600 <devfile_write+0x39>
		n = (PGSIZE - (sizeof(int) + (sizeof(size_t))));
  8035f8:	48 c7 45 d8 f4 0f 00 	movq   $0xff4,-0x28(%rbp)
  8035ff:	00 
	fsipcbuf.write.req_n=n;
  803600:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803607:	00 00 00 
  80360a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80360e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803612:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803616:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361a:	48 89 c6             	mov    %rax,%rsi
  80361d:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803624:	00 00 00 
  803627:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
	r = fsipc(FSREQ_WRITE, NULL);
  803633:	be 00 00 00 00       	mov    $0x0,%esi
  803638:	bf 04 00 00 00       	mov    $0x4,%edi
  80363d:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	89 45 fc             	mov    %eax,-0x4(%rbp)
	return r;
  80364c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80364f:	c9                   	leaveq 
  803650:	c3                   	retq   

0000000000803651 <devfile_trunc>:



static int
devfile_trunc(struct Fd *fd, off_t size)
{
  803651:	55                   	push   %rbp
  803652:	48 89 e5             	mov    %rsp,%rbp
  803655:	48 83 ec 10          	sub    $0x10,%rsp
  803659:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80365d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803660:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803664:	8b 50 0c             	mov    0xc(%rax),%edx
  803667:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80366e:	00 00 00 
  803671:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = size;
  803673:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80367a:	00 00 00 
  80367d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803680:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803683:	be 00 00 00 00       	mov    $0x0,%esi
  803688:	bf 02 00 00 00       	mov    $0x2,%edi
  80368d:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803694:	00 00 00 
  803697:	ff d0                	callq  *%rax
}
  803699:	c9                   	leaveq 
  80369a:	c3                   	retq   

000000000080369b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80369b:	55                   	push   %rbp
  80369c:	48 89 e5             	mov    %rsp,%rbp
  80369f:	48 83 ec 20          	sub    $0x20,%rsp
  8036a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8036ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036af:	8b 50 0c             	mov    0xc(%rax),%edx
  8036b2:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8036b9:	00 00 00 
  8036bc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8036be:	be 00 00 00 00       	mov    $0x0,%esi
  8036c3:	bf 05 00 00 00       	mov    $0x5,%edi
  8036c8:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	callq  *%rax
  8036d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036db:	79 05                	jns    8036e2 <devfile_stat+0x47>
		return r;
  8036dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e0:	eb 56                	jmp    803738 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036e6:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8036ed:	00 00 00 
  8036f0:	48 89 c7             	mov    %rax,%rdi
  8036f3:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036ff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803706:	00 00 00 
  803709:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80370f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803713:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803719:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803720:	00 00 00 
  803723:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803729:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80372d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803738:	c9                   	leaveq 
  803739:	c3                   	retq   
	...

000000000080373c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80373c:	55                   	push   %rbp
  80373d:	48 89 e5             	mov    %rsp,%rbp
  803740:	53                   	push   %rbx
  803741:	48 81 ec 28 03 00 00 	sub    $0x328,%rsp
  803748:	48 89 bd f8 fc ff ff 	mov    %rdi,-0x308(%rbp)
  80374f:	48 89 b5 f0 fc ff ff 	mov    %rsi,-0x310(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  803756:	48 8b 85 f8 fc ff ff 	mov    -0x308(%rbp),%rax
  80375d:	be 00 00 00 00       	mov    $0x0,%esi
  803762:	48 89 c7             	mov    %rax,%rdi
  803765:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
  803771:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803774:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803778:	79 08                	jns    803782 <spawn+0x46>
		return r;
  80377a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80377d:	e9 1d 03 00 00       	jmpq   803a9f <spawn+0x363>
	fd = r;
  803782:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803785:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  803788:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
  80378f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  803793:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
  80379a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80379d:	ba 00 02 00 00       	mov    $0x200,%edx
  8037a2:	48 89 ce             	mov    %rcx,%rsi
  8037a5:	89 c7                	mov    %eax,%edi
  8037a7:	48 b8 25 30 80 00 00 	movabs $0x803025,%rax
  8037ae:	00 00 00 
  8037b1:	ff d0                	callq  *%rax
  8037b3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8037b8:	75 0d                	jne    8037c7 <spawn+0x8b>
	    || elf->e_magic != ELF_MAGIC) {
  8037ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037be:	8b 00                	mov    (%rax),%eax
  8037c0:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8037c5:	74 43                	je     80380a <spawn+0xce>
		close(fd);
  8037c7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8037ca:	89 c7                	mov    %eax,%edi
  8037cc:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  8037d3:	00 00 00 
  8037d6:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8037d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037dc:	8b 00                	mov    (%rax),%eax
  8037de:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  8037e3:	89 c6                	mov    %eax,%esi
  8037e5:	48 bf 98 5e 80 00 00 	movabs $0x805e98,%rdi
  8037ec:	00 00 00 
  8037ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f4:	48 b9 3b 0b 80 00 00 	movabs $0x800b3b,%rcx
  8037fb:	00 00 00 
  8037fe:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803800:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803805:	e9 95 02 00 00       	jmpq   803a9f <spawn+0x363>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80380a:	c7 85 ec fc ff ff 07 	movl   $0x7,-0x314(%rbp)
  803811:	00 00 00 
  803814:	8b 85 ec fc ff ff    	mov    -0x314(%rbp),%eax
  80381a:	cd 30                	int    $0x30
  80381c:	89 c3                	mov    %eax,%ebx
  80381e:	89 5d c0             	mov    %ebx,-0x40(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803821:	8b 45 c0             	mov    -0x40(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  803824:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803827:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80382b:	79 08                	jns    803835 <spawn+0xf9>
		return r;
  80382d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803830:	e9 6a 02 00 00       	jmpq   803a9f <spawn+0x363>
	child = r;
  803835:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803838:	89 45 c4             	mov    %eax,-0x3c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80383b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80383e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803843:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80384a:	00 00 00 
  80384d:	48 63 d0             	movslq %eax,%rdx
  803850:	48 89 d0             	mov    %rdx,%rax
  803853:	48 c1 e0 03          	shl    $0x3,%rax
  803857:	48 01 d0             	add    %rdx,%rax
  80385a:	48 c1 e0 05          	shl    $0x5,%rax
  80385e:	48 01 c8             	add    %rcx,%rax
  803861:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  803868:	48 89 c6             	mov    %rax,%rsi
  80386b:	b8 18 00 00 00       	mov    $0x18,%eax
  803870:	48 89 d7             	mov    %rdx,%rdi
  803873:	48 89 c1             	mov    %rax,%rcx
  803876:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  803879:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80387d:	48 8b 40 18          	mov    0x18(%rax),%rax
  803881:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  803888:	48 8d 85 00 fd ff ff 	lea    -0x300(%rbp),%rax
  80388f:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  803896:	48 8b 8d f0 fc ff ff 	mov    -0x310(%rbp),%rcx
  80389d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8038a0:	48 89 ce             	mov    %rcx,%rsi
  8038a3:	89 c7                	mov    %eax,%edi
  8038a5:	48 b8 f7 3c 80 00 00 	movabs $0x803cf7,%rax
  8038ac:	00 00 00 
  8038af:	ff d0                	callq  *%rax
  8038b1:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8038b4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8038b8:	79 08                	jns    8038c2 <spawn+0x186>
		return r;
  8038ba:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8038bd:	e9 dd 01 00 00       	jmpq   803a9f <spawn+0x363>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8038c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038c6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8038ca:	48 8d 95 c0 fd ff ff 	lea    -0x240(%rbp),%rdx
  8038d1:	48 01 d0             	add    %rdx,%rax
  8038d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8038d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8038df:	eb 7a                	jmp    80395b <spawn+0x21f>
		if (ph->p_type != ELF_PROG_LOAD)
  8038e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038e5:	8b 00                	mov    (%rax),%eax
  8038e7:	83 f8 01             	cmp    $0x1,%eax
  8038ea:	75 65                	jne    803951 <spawn+0x215>
			continue;
		perm = PTE_P | PTE_U;
  8038ec:	c7 45 dc 05 00 00 00 	movl   $0x5,-0x24(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8038f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038f7:	8b 40 04             	mov    0x4(%rax),%eax
  8038fa:	83 e0 02             	and    $0x2,%eax
  8038fd:	85 c0                	test   %eax,%eax
  8038ff:	74 04                	je     803905 <spawn+0x1c9>
			perm |= PTE_W;
  803901:	83 4d dc 02          	orl    $0x2,-0x24(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803905:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803909:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80390d:	41 89 c1             	mov    %eax,%r9d
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803910:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  803914:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803918:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80391c:	48 8b 50 28          	mov    0x28(%rax),%rdx
  803920:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803924:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803928:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80392b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80392e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803931:	89 3c 24             	mov    %edi,(%rsp)
  803934:	89 c7                	mov    %eax,%edi
  803936:	48 b8 67 3f 80 00 00 	movabs $0x803f67,%rax
  80393d:	00 00 00 
  803940:	ff d0                	callq  *%rax
  803942:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803945:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803949:	0f 88 2a 01 00 00    	js     803a79 <spawn+0x33d>
  80394f:	eb 01                	jmp    803952 <spawn+0x216>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  803951:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803952:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  803956:	48 83 45 e0 38       	addq   $0x38,-0x20(%rbp)
  80395b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80395f:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  803963:	0f b7 c0             	movzwl %ax,%eax
  803966:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803969:	0f 8f 72 ff ff ff    	jg     8038e1 <spawn+0x1a5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80396f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803972:	89 c7                	mov    %eax,%edi
  803974:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  80397b:	00 00 00 
  80397e:	ff d0                	callq  *%rax
	fd = -1;
  803980:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  803987:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80398a:	89 c7                	mov    %eax,%edi
  80398c:	48 b8 4e 41 80 00 00 	movabs $0x80414e,%rax
  803993:	00 00 00 
  803996:	ff d0                	callq  *%rax
  803998:	89 45 d8             	mov    %eax,-0x28(%rbp)
  80399b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80399f:	79 30                	jns    8039d1 <spawn+0x295>
		panic("copy_shared_pages: %e", r);
  8039a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039a4:	89 c1                	mov    %eax,%ecx
  8039a6:	48 ba b2 5e 80 00 00 	movabs $0x805eb2,%rdx
  8039ad:	00 00 00 
  8039b0:	be 82 00 00 00       	mov    $0x82,%esi
  8039b5:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  8039bc:	00 00 00 
  8039bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c4:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8039cb:	00 00 00 
  8039ce:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8039d1:	48 8d 95 00 fd ff ff 	lea    -0x300(%rbp),%rdx
  8039d8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8039db:	48 89 d6             	mov    %rdx,%rsi
  8039de:	89 c7                	mov    %eax,%edi
  8039e0:	48 b8 70 21 80 00 00 	movabs $0x802170,%rax
  8039e7:	00 00 00 
  8039ea:	ff d0                	callq  *%rax
  8039ec:	89 45 d8             	mov    %eax,-0x28(%rbp)
  8039ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8039f3:	79 30                	jns    803a25 <spawn+0x2e9>
		panic("sys_env_set_trapframe: %e", r);
  8039f5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039f8:	89 c1                	mov    %eax,%ecx
  8039fa:	48 ba d4 5e 80 00 00 	movabs $0x805ed4,%rdx
  803a01:	00 00 00 
  803a04:	be 85 00 00 00       	mov    $0x85,%esi
  803a09:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  803a10:	00 00 00 
  803a13:	b8 00 00 00 00       	mov    $0x0,%eax
  803a18:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  803a1f:	00 00 00 
  803a22:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803a25:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a28:	be 02 00 00 00       	mov    $0x2,%esi
  803a2d:	89 c7                	mov    %eax,%edi
  803a2f:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
  803a36:	00 00 00 
  803a39:	ff d0                	callq  *%rax
  803a3b:	89 45 d8             	mov    %eax,-0x28(%rbp)
  803a3e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a42:	79 30                	jns    803a74 <spawn+0x338>
		panic("sys_env_set_status: %e", r);
  803a44:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803a47:	89 c1                	mov    %eax,%ecx
  803a49:	48 ba ee 5e 80 00 00 	movabs $0x805eee,%rdx
  803a50:	00 00 00 
  803a53:	be 88 00 00 00       	mov    $0x88,%esi
  803a58:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  803a5f:	00 00 00 
  803a62:	b8 00 00 00 00       	mov    $0x0,%eax
  803a67:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  803a6e:	00 00 00 
  803a71:	41 ff d0             	callq  *%r8

	return child;
  803a74:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a77:	eb 26                	jmp    803a9f <spawn+0x363>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  803a79:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  803a7a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803a7d:	89 c7                	mov    %eax,%edi
  803a7f:	48 b8 70 1f 80 00 00 	movabs $0x801f70,%rax
  803a86:	00 00 00 
  803a89:	ff d0                	callq  *%rax
	close(fd);
  803a8b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803a8e:	89 c7                	mov    %eax,%edi
  803a90:	48 b8 2a 2d 80 00 00 	movabs $0x802d2a,%rax
  803a97:	00 00 00 
  803a9a:	ff d0                	callq  *%rax
	return r;
  803a9c:	8b 45 d8             	mov    -0x28(%rbp),%eax
}
  803a9f:	48 81 c4 28 03 00 00 	add    $0x328,%rsp
  803aa6:	5b                   	pop    %rbx
  803aa7:	5d                   	pop    %rbp
  803aa8:	c3                   	retq   

0000000000803aa9 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	53                   	push   %rbx
  803aae:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  803ab5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803abc:	48 89 95 50 ff ff ff 	mov    %rdx,-0xb0(%rbp)
  803ac3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803aca:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ad1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803ad8:	84 c0                	test   %al,%al
  803ada:	74 23                	je     803aff <spawnl+0x56>
  803adc:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803ae3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ae7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803aeb:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803aef:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803af3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803af7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803afb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803aff:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803b06:	c7 85 3c ff ff ff 00 	movl   $0x0,-0xc4(%rbp)
  803b0d:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  803b10:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803b17:	00 00 00 
  803b1a:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803b21:	00 00 00 
  803b24:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803b28:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803b2f:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803b36:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803b3d:	eb 07                	jmp    803b46 <spawnl+0x9d>
		argc++;
  803b3f:	83 85 3c ff ff ff 01 	addl   $0x1,-0xc4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803b46:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803b4c:	83 f8 30             	cmp    $0x30,%eax
  803b4f:	73 23                	jae    803b74 <spawnl+0xcb>
  803b51:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  803b58:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803b5e:	89 c0                	mov    %eax,%eax
  803b60:	48 01 d0             	add    %rdx,%rax
  803b63:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  803b69:	83 c2 08             	add    $0x8,%edx
  803b6c:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803b72:	eb 15                	jmp    803b89 <spawnl+0xe0>
  803b74:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803b7b:	48 89 d0             	mov    %rdx,%rax
  803b7e:	48 83 c2 08          	add    $0x8,%rdx
  803b82:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803b89:	48 8b 00             	mov    (%rax),%rax
  803b8c:	48 85 c0             	test   %rax,%rax
  803b8f:	75 ae                	jne    803b3f <spawnl+0x96>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803b91:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803b97:	83 c0 02             	add    $0x2,%eax
  803b9a:	48 89 e2             	mov    %rsp,%rdx
  803b9d:	48 89 d3             	mov    %rdx,%rbx
  803ba0:	48 63 d0             	movslq %eax,%rdx
  803ba3:	48 83 ea 01          	sub    $0x1,%rdx
  803ba7:	48 89 95 30 ff ff ff 	mov    %rdx,-0xd0(%rbp)
  803bae:	48 98                	cltq   
  803bb0:	48 c1 e0 03          	shl    $0x3,%rax
  803bb4:	48 8d 50 0f          	lea    0xf(%rax),%rdx
  803bb8:	b8 10 00 00 00       	mov    $0x10,%eax
  803bbd:	48 83 e8 01          	sub    $0x1,%rax
  803bc1:	48 01 d0             	add    %rdx,%rax
  803bc4:	48 c7 85 f8 fe ff ff 	movq   $0x10,-0x108(%rbp)
  803bcb:	10 00 00 00 
  803bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  803bd4:	48 f7 b5 f8 fe ff ff 	divq   -0x108(%rbp)
  803bdb:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803bdf:	48 29 c4             	sub    %rax,%rsp
  803be2:	48 89 e0             	mov    %rsp,%rax
  803be5:	48 83 c0 0f          	add    $0xf,%rax
  803be9:	48 c1 e8 04          	shr    $0x4,%rax
  803bed:	48 c1 e0 04          	shl    $0x4,%rax
  803bf1:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
	argv[0] = arg0;
  803bf8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803bff:	48 8b 95 00 ff ff ff 	mov    -0x100(%rbp),%rdx
  803c06:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803c09:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803c0f:	8d 50 01             	lea    0x1(%rax),%edx
  803c12:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803c19:	48 63 d2             	movslq %edx,%rdx
  803c1c:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  803c23:	00 

	va_start(vl, arg0);
  803c24:	c7 85 10 ff ff ff 10 	movl   $0x10,-0xf0(%rbp)
  803c2b:	00 00 00 
  803c2e:	c7 85 14 ff ff ff 30 	movl   $0x30,-0xec(%rbp)
  803c35:	00 00 00 
  803c38:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c3c:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
  803c43:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  803c4a:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803c51:	c7 85 38 ff ff ff 00 	movl   $0x0,-0xc8(%rbp)
  803c58:	00 00 00 
  803c5b:	eb 63                	jmp    803cc0 <spawnl+0x217>
		argv[i+1] = va_arg(vl, const char *);
  803c5d:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
  803c63:	8d 70 01             	lea    0x1(%rax),%esi
  803c66:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803c6c:	83 f8 30             	cmp    $0x30,%eax
  803c6f:	73 23                	jae    803c94 <spawnl+0x1eb>
  803c71:	48 8b 95 20 ff ff ff 	mov    -0xe0(%rbp),%rdx
  803c78:	8b 85 10 ff ff ff    	mov    -0xf0(%rbp),%eax
  803c7e:	89 c0                	mov    %eax,%eax
  803c80:	48 01 d0             	add    %rdx,%rax
  803c83:	8b 95 10 ff ff ff    	mov    -0xf0(%rbp),%edx
  803c89:	83 c2 08             	add    $0x8,%edx
  803c8c:	89 95 10 ff ff ff    	mov    %edx,-0xf0(%rbp)
  803c92:	eb 15                	jmp    803ca9 <spawnl+0x200>
  803c94:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803c9b:	48 89 d0             	mov    %rdx,%rax
  803c9e:	48 83 c2 08          	add    $0x8,%rdx
  803ca2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803ca9:	48 8b 08             	mov    (%rax),%rcx
  803cac:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803cb3:	89 f2                	mov    %esi,%edx
  803cb5:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803cb9:	83 85 38 ff ff ff 01 	addl   $0x1,-0xc8(%rbp)
  803cc0:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
  803cc6:	3b 85 38 ff ff ff    	cmp    -0xc8(%rbp),%eax
  803ccc:	77 8f                	ja     803c5d <spawnl+0x1b4>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803cce:	48 8b 95 28 ff ff ff 	mov    -0xd8(%rbp),%rdx
  803cd5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803cdc:	48 89 d6             	mov    %rdx,%rsi
  803cdf:	48 89 c7             	mov    %rax,%rdi
  803ce2:	48 b8 3c 37 80 00 00 	movabs $0x80373c,%rax
  803ce9:	00 00 00 
  803cec:	ff d0                	callq  *%rax
  803cee:	48 89 dc             	mov    %rbx,%rsp
}
  803cf1:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  803cf5:	c9                   	leaveq 
  803cf6:	c3                   	retq   

0000000000803cf7 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803cf7:	55                   	push   %rbp
  803cf8:	48 89 e5             	mov    %rsp,%rbp
  803cfb:	48 83 ec 50          	sub    $0x50,%rsp
  803cff:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803d02:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803d06:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803d0a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d11:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803d12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803d19:	eb 2c                	jmp    803d47 <init_stack+0x50>
		string_size += strlen(argv[argc]) + 1;
  803d1b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d1e:	48 98                	cltq   
  803d20:	48 c1 e0 03          	shl    $0x3,%rax
  803d24:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803d28:	48 8b 00             	mov    (%rax),%rax
  803d2b:	48 89 c7             	mov    %rax,%rdi
  803d2e:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	83 c0 01             	add    $0x1,%eax
  803d3d:	48 98                	cltq   
  803d3f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803d43:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  803d47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803d4a:	48 98                	cltq   
  803d4c:	48 c1 e0 03          	shl    $0x3,%rax
  803d50:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803d54:	48 8b 00             	mov    (%rax),%rax
  803d57:	48 85 c0             	test   %rax,%rax
  803d5a:	75 bf                	jne    803d1b <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  803d5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d60:	48 f7 d8             	neg    %rax
  803d63:	48 05 00 10 40 00    	add    $0x401000,%rax
  803d69:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  803d6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d71:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d79:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  803d7d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d80:	83 c2 01             	add    $0x1,%edx
  803d83:	c1 e2 03             	shl    $0x3,%edx
  803d86:	48 63 d2             	movslq %edx,%rdx
  803d89:	48 f7 da             	neg    %rdx
  803d8c:	48 01 d0             	add    %rdx,%rax
  803d8f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803d93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d97:	48 83 e8 10          	sub    $0x10,%rax
  803d9b:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  803da1:	77 0a                	ja     803dad <init_stack+0xb6>
		return -E_NO_MEM;
  803da3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803da8:	e9 b8 01 00 00       	jmpq   803f65 <init_stack+0x26e>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803dad:	ba 07 00 00 00       	mov    $0x7,%edx
  803db2:	be 00 00 40 00       	mov    $0x400000,%esi
  803db7:	bf 00 00 00 00       	mov    $0x0,%edi
  803dbc:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  803dc3:	00 00 00 
  803dc6:	ff d0                	callq  *%rax
  803dc8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dcf:	79 08                	jns    803dd9 <init_stack+0xe2>
		return r;
  803dd1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dd4:	e9 8c 01 00 00       	jmpq   803f65 <init_stack+0x26e>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803dd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  803de0:	eb 73                	jmp    803e55 <init_stack+0x15e>
		argv_store[i] = UTEMP2USTACK(string_store);
  803de2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803de5:	48 98                	cltq   
  803de7:	48 c1 e0 03          	shl    $0x3,%rax
  803deb:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803def:	ba 00 d0 7f ef       	mov    $0xef7fd000,%edx
  803df4:	48 03 55 e0          	add    -0x20(%rbp),%rdx
  803df8:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  803dff:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  803e02:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e05:	48 98                	cltq   
  803e07:	48 c1 e0 03          	shl    $0x3,%rax
  803e0b:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803e0f:	48 8b 10             	mov    (%rax),%rdx
  803e12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e16:	48 89 d6             	mov    %rdx,%rsi
  803e19:	48 89 c7             	mov    %rax,%rdi
  803e1c:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  803e23:	00 00 00 
  803e26:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803e28:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e2b:	48 98                	cltq   
  803e2d:	48 c1 e0 03          	shl    $0x3,%rax
  803e31:	48 03 45 c0          	add    -0x40(%rbp),%rax
  803e35:	48 8b 00             	mov    (%rax),%rax
  803e38:	48 89 c7             	mov    %rax,%rdi
  803e3b:	48 b8 8c 16 80 00 00 	movabs $0x80168c,%rax
  803e42:	00 00 00 
  803e45:	ff d0                	callq  *%rax
  803e47:	48 98                	cltq   
  803e49:	48 83 c0 01          	add    $0x1,%rax
  803e4d:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803e51:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  803e55:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e58:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  803e5b:	7c 85                	jl     803de2 <init_stack+0xeb>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803e5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e60:	48 98                	cltq   
  803e62:	48 c1 e0 03          	shl    $0x3,%rax
  803e66:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803e6a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  803e71:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  803e78:	00 
  803e79:	74 35                	je     803eb0 <init_stack+0x1b9>
  803e7b:	48 b9 08 5f 80 00 00 	movabs $0x805f08,%rcx
  803e82:	00 00 00 
  803e85:	48 ba 2e 5f 80 00 00 	movabs $0x805f2e,%rdx
  803e8c:	00 00 00 
  803e8f:	be f1 00 00 00       	mov    $0xf1,%esi
  803e94:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  803e9b:	00 00 00 
  803e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea3:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  803eaa:	00 00 00 
  803ead:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803eb0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803eb4:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803eb8:	b8 00 d0 7f ef       	mov    $0xef7fd000,%eax
  803ebd:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803ec1:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ec7:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803eca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ece:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803ed2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ed5:	48 98                	cltq   
  803ed7:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803eda:	b8 f0 cf 7f ef       	mov    $0xef7fcff0,%eax
  803edf:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803ee3:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803ee9:	48 89 c2             	mov    %rax,%rdx
  803eec:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803ef0:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803ef3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ef6:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803efc:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803f01:	89 c2                	mov    %eax,%edx
  803f03:	be 00 00 40 00       	mov    $0x400000,%esi
  803f08:	bf 00 00 00 00       	mov    $0x0,%edi
  803f0d:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  803f14:	00 00 00 
  803f17:	ff d0                	callq  *%rax
  803f19:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f20:	78 26                	js     803f48 <init_stack+0x251>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803f22:	be 00 00 40 00       	mov    $0x400000,%esi
  803f27:	bf 00 00 00 00       	mov    $0x0,%edi
  803f2c:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  803f33:	00 00 00 
  803f36:	ff d0                	callq  *%rax
  803f38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3f:	78 0a                	js     803f4b <init_stack+0x254>
		goto error;

	return 0;
  803f41:	b8 00 00 00 00       	mov    $0x0,%eax
  803f46:	eb 1d                	jmp    803f65 <init_stack+0x26e>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  803f48:	90                   	nop
  803f49:	eb 01                	jmp    803f4c <init_stack+0x255>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  803f4b:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  803f4c:	be 00 00 40 00       	mov    $0x400000,%esi
  803f51:	bf 00 00 00 00       	mov    $0x0,%edi
  803f56:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  803f5d:	00 00 00 
  803f60:	ff d0                	callq  *%rax
	return r;
  803f62:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f65:	c9                   	leaveq 
  803f66:	c3                   	retq   

0000000000803f67 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  803f67:	55                   	push   %rbp
  803f68:	48 89 e5             	mov    %rsp,%rbp
  803f6b:	48 83 ec 50          	sub    $0x50,%rsp
  803f6f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803f72:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f76:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803f7a:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803f7d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803f81:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803f85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f89:	25 ff 0f 00 00       	and    $0xfff,%eax
  803f8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f95:	74 21                	je     803fb8 <map_segment+0x51>
		va -= i;
  803f97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f9a:	48 98                	cltq   
  803f9c:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa3:	48 98                	cltq   
  803fa5:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803fa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fac:	48 98                	cltq   
  803fae:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803fb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fbf:	e9 74 01 00 00       	jmpq   804138 <map_segment+0x1d1>
		if (i >= filesz) {
  803fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc7:	48 98                	cltq   
  803fc9:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803fcd:	72 38                	jb     804007 <map_segment+0xa0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803fcf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fd2:	48 98                	cltq   
  803fd4:	48 03 45 d0          	add    -0x30(%rbp),%rax
  803fd8:	48 89 c1             	mov    %rax,%rcx
  803fdb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803fde:	8b 55 10             	mov    0x10(%rbp),%edx
  803fe1:	48 89 ce             	mov    %rcx,%rsi
  803fe4:	89 c7                	mov    %eax,%edi
  803fe6:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  803fed:	00 00 00 
  803ff0:	ff d0                	callq  *%rax
  803ff2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803ff5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ff9:	0f 89 32 01 00 00    	jns    804131 <map_segment+0x1ca>
				return r;
  803fff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804002:	e9 45 01 00 00       	jmpq   80414c <map_segment+0x1e5>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  804007:	ba 07 00 00 00       	mov    $0x7,%edx
  80400c:	be 00 00 40 00       	mov    $0x400000,%esi
  804011:	bf 00 00 00 00       	mov    $0x0,%edi
  804016:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  80401d:	00 00 00 
  804020:	ff d0                	callq  *%rax
  804022:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804025:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804029:	79 08                	jns    804033 <map_segment+0xcc>
				return r;
  80402b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80402e:	e9 19 01 00 00       	jmpq   80414c <map_segment+0x1e5>
			if ((r = seek(fd, fileoffset + i)) < 0)
  804033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804036:	8b 55 bc             	mov    -0x44(%rbp),%edx
  804039:	01 c2                	add    %eax,%edx
  80403b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80403e:	89 d6                	mov    %edx,%esi
  804040:	89 c7                	mov    %eax,%edi
  804042:	48 b8 72 31 80 00 00 	movabs $0x803172,%rax
  804049:	00 00 00 
  80404c:	ff d0                	callq  *%rax
  80404e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  804051:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804055:	79 08                	jns    80405f <map_segment+0xf8>
				return r;
  804057:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80405a:	e9 ed 00 00 00       	jmpq   80414c <map_segment+0x1e5>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80405f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  804066:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804069:	48 98                	cltq   
  80406b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80406f:	48 89 d1             	mov    %rdx,%rcx
  804072:	48 29 c1             	sub    %rax,%rcx
  804075:	48 89 c8             	mov    %rcx,%rax
  804078:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80407c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80407f:	48 63 d0             	movslq %eax,%rdx
  804082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804086:	48 39 c2             	cmp    %rax,%rdx
  804089:	48 0f 47 d0          	cmova  %rax,%rdx
  80408d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804090:	be 00 00 40 00       	mov    $0x400000,%esi
  804095:	89 c7                	mov    %eax,%edi
  804097:	48 b8 25 30 80 00 00 	movabs $0x803025,%rax
  80409e:	00 00 00 
  8040a1:	ff d0                	callq  *%rax
  8040a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040aa:	79 08                	jns    8040b4 <map_segment+0x14d>
				return r;
  8040ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040af:	e9 98 00 00 00       	jmpq   80414c <map_segment+0x1e5>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8040b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b7:	48 98                	cltq   
  8040b9:	48 03 45 d0          	add    -0x30(%rbp),%rax
  8040bd:	48 89 c2             	mov    %rax,%rdx
  8040c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040c3:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  8040c7:	48 89 d1             	mov    %rdx,%rcx
  8040ca:	89 c2                	mov    %eax,%edx
  8040cc:	be 00 00 40 00       	mov    $0x400000,%esi
  8040d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040d6:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  8040dd:	00 00 00 
  8040e0:	ff d0                	callq  *%rax
  8040e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8040e5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8040e9:	79 30                	jns    80411b <map_segment+0x1b4>
				panic("spawn: sys_page_map data: %e", r);
  8040eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8040ee:	89 c1                	mov    %eax,%ecx
  8040f0:	48 ba 43 5f 80 00 00 	movabs $0x805f43,%rdx
  8040f7:	00 00 00 
  8040fa:	be 24 01 00 00       	mov    $0x124,%esi
  8040ff:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  804106:	00 00 00 
  804109:	b8 00 00 00 00       	mov    $0x0,%eax
  80410e:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  804115:	00 00 00 
  804118:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80411b:	be 00 00 40 00       	mov    $0x400000,%esi
  804120:	bf 00 00 00 00       	mov    $0x0,%edi
  804125:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  80412c:	00 00 00 
  80412f:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  804131:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  804138:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80413b:	48 98                	cltq   
  80413d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804141:	0f 82 7d fe ff ff    	jb     803fc4 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  804147:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80414c:	c9                   	leaveq 
  80414d:	c3                   	retq   

000000000080414e <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80414e:	55                   	push   %rbp
  80414f:	48 89 e5             	mov    %rsp,%rbp
  804152:	48 83 ec 60          	sub    $0x60,%rsp
  804156:	89 7d ac             	mov    %edi,-0x54(%rbp)
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
  804159:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%rbp)
        vpdpe_entries = VPDPE(UTOP);
  804160:	c7 45 c0 00 02 00 00 	movl   $0x200,-0x40(%rbp)
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  804167:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80416e:	00 
  80416f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
  804176:	00 
  804177:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  80417e:	00 
  80417f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804186:	00 
  804187:	e9 a6 01 00 00       	jmpq   804332 <copy_shared_pages+0x1e4>
        {
                if(uvpml4e[a] & PTE_P)
  80418c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  804193:	01 00 00 
  804196:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80419a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80419e:	83 e0 01             	and    $0x1,%eax
  8041a1:	84 c0                	test   %al,%al
  8041a3:	0f 84 74 01 00 00    	je     80431d <copy_shared_pages+0x1cf>
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  8041a9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8041b0:	00 
  8041b1:	e9 56 01 00 00       	jmpq   80430c <copy_shared_pages+0x1be>
                        {
                                if(uvpde[b1] & PTE_P)
  8041b6:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8041bd:	01 00 00 
  8041c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8041c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041c8:	83 e0 01             	and    $0x1,%eax
  8041cb:	84 c0                	test   %al,%al
  8041cd:	0f 84 1f 01 00 00    	je     8042f2 <copy_shared_pages+0x1a4>
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  8041d3:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8041da:	00 
  8041db:	e9 02 01 00 00       	jmpq   8042e2 <copy_shared_pages+0x194>
                                        {
                                                if(uvpd[c1] & PTE_P)
  8041e0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8041e7:	01 00 00 
  8041ea:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8041ee:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041f2:	83 e0 01             	and    $0x1,%eax
  8041f5:	84 c0                	test   %al,%al
  8041f7:	0f 84 cb 00 00 00    	je     8042c8 <copy_shared_pages+0x17a>
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  8041fd:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  804204:	00 
  804205:	e9 ae 00 00 00       	jmpq   8042b8 <copy_shared_pages+0x16a>
                                                        {
                                                                if((uvpt[d1] & PTE_SHARE))// && (f != VPN(UXSTACKTOP-PGSIZE)))
  80420a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804211:	01 00 00 
  804214:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804218:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80421c:	25 00 04 00 00       	and    $0x400,%eax
  804221:	48 85 c0             	test   %rax,%rax
  804224:	0f 84 84 00 00 00    	je     8042ae <copy_shared_pages+0x160>
                                                                {
                                                                        void* addr=(void *)(d1 << PGSHIFT);
  80422a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80422e:	48 c1 e0 0c          	shl    $0xc,%rax
  804232:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                                                                        perm=uvpt[d1] & PTE_USER;
  804236:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80423d:	01 00 00 
  804240:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  804244:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804248:	25 07 0e 00 00       	and    $0xe07,%eax
  80424d:	89 45 b4             	mov    %eax,-0x4c(%rbp)
                                                                        //cprintf("f:%08x\tUTOP:%08x\taddr:%08x\tuvpt[f]:%08x\tperm:%08x\n",f,UTOP,addr,uvpt[f],perm);
                                                                        r = sys_page_map(0, addr, child, addr, perm);
  804250:	8b 75 b4             	mov    -0x4c(%rbp),%esi
  804253:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
  804257:	8b 55 ac             	mov    -0x54(%rbp),%edx
  80425a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80425e:	41 89 f0             	mov    %esi,%r8d
  804261:	48 89 c6             	mov    %rax,%rsi
  804264:	bf 00 00 00 00       	mov    $0x0,%edi
  804269:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  804270:	00 00 00 
  804273:	ff d0                	callq  *%rax
  804275:	89 45 b0             	mov    %eax,-0x50(%rbp)
                                                                        if (r < 0)
  804278:	83 7d b0 00          	cmpl   $0x0,-0x50(%rbp)
  80427c:	79 30                	jns    8042ae <copy_shared_pages+0x160>
                                                                                panic("sys_page_map failed:%e",r);
  80427e:	8b 45 b0             	mov    -0x50(%rbp),%eax
  804281:	89 c1                	mov    %eax,%ecx
  804283:	48 ba 60 5f 80 00 00 	movabs $0x805f60,%rdx
  80428a:	00 00 00 
  80428d:	be 48 01 00 00       	mov    $0x148,%esi
  804292:	48 bf c8 5e 80 00 00 	movabs $0x805ec8,%rdi
  804299:	00 00 00 
  80429c:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a1:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  8042a8:	00 00 00 
  8042ab:	41 ff d0             	callq  *%r8
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
                                        {
                                                if(uvpd[c1] & PTE_P)
                                                {
                                                        for(d=0;d<NPTENTRIES;d++, d1++)
  8042ae:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  8042b3:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8042b8:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  8042bf:	00 
  8042c0:	0f 86 44 ff ff ff    	jbe    80420a <copy_shared_pages+0xbc>
  8042c6:	eb 10                	jmp    8042d8 <copy_shared_pages+0x18a>
                                                                                panic("sys_page_map failed:%e",r);
                                                                }
                                                        }
                                                }
                                                else {
                                                        d1 = (c1+1)*NPTENTRIES;
  8042c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042cc:	48 83 c0 01          	add    $0x1,%rax
  8042d0:	48 c1 e0 09          	shl    $0x9,%rax
  8042d4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
                        {
                                if(uvpde[b1] & PTE_P)
                                {
                                        for(c=0; c< NPDENTRIES; c++, c1++)
  8042d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042dd:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  8042e2:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  8042e9:	00 
  8042ea:	0f 86 f0 fe ff ff    	jbe    8041e0 <copy_shared_pages+0x92>
  8042f0:	eb 10                	jmp    804302 <copy_shared_pages+0x1b4>
                                                        d1 = (c1+1)*NPTENTRIES;
                                                }
                                        }
                                }
                                else {
                                        c1 = (b+1) * NPDENTRIES;
  8042f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f6:	48 83 c0 01          	add    $0x1,%rax
  8042fa:	48 c1 e0 09          	shl    $0x9,%rax
  8042fe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
        {
                if(uvpml4e[a] & PTE_P)
                {
                        for(b=0; b<vpdpe_entries;b++,b1++)
  804302:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  804307:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80430c:	8b 45 c0             	mov    -0x40(%rbp),%eax
  80430f:	48 98                	cltq   
  804311:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804315:	0f 87 9b fe ff ff    	ja     8041b6 <copy_shared_pages+0x68>
  80431b:	eb 10                	jmp    80432d <copy_shared_pages+0x1df>
                                }
                        }
                }
                else
                {
                        b1=(a+1)*NPDPENTRIES;
  80431d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804321:	48 83 c0 01          	add    $0x1,%rax
  804325:	48 c1 e0 09          	shl    $0x9,%rax
  804329:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
{
	int vpml4e_entries,vpdpe_entries,perm,r;
	uint64_t a,b,c,d,b1,c1,d1;
        vpml4e_entries = VPML4E(UTOP);
        vpdpe_entries = VPDPE(UTOP);
	 for(c1=0,d1=0,b1=0,a=0;a<vpml4e_entries;a++)
  80432d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804332:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804335:	48 98                	cltq   
  804337:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80433b:	0f 87 4b fe ff ff    	ja     80418c <copy_shared_pages+0x3e>
                else
                {
                        b1=(a+1)*NPDPENTRIES;
                }
	}	
        return 0;
  804341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804346:	c9                   	leaveq 
  804347:	c3                   	retq   

0000000000804348 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  804348:	55                   	push   %rbp
  804349:	48 89 e5             	mov    %rsp,%rbp
  80434c:	48 83 ec 20          	sub    $0x20,%rsp
  804350:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  804353:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804357:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80435a:	48 89 d6             	mov    %rdx,%rsi
  80435d:	89 c7                	mov    %eax,%edi
  80435f:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  804366:	00 00 00 
  804369:	ff d0                	callq  *%rax
  80436b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80436e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804372:	79 05                	jns    804379 <fd2sockid+0x31>
		return r;
  804374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804377:	eb 24                	jmp    80439d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  804379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437d:	8b 10                	mov    (%rax),%edx
  80437f:	48 b8 c0 80 80 00 00 	movabs $0x8080c0,%rax
  804386:	00 00 00 
  804389:	8b 00                	mov    (%rax),%eax
  80438b:	39 c2                	cmp    %eax,%edx
  80438d:	74 07                	je     804396 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80438f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804394:	eb 07                	jmp    80439d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  804396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80439d:	c9                   	leaveq 
  80439e:	c3                   	retq   

000000000080439f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80439f:	55                   	push   %rbp
  8043a0:	48 89 e5             	mov    %rsp,%rbp
  8043a3:	48 83 ec 20          	sub    $0x20,%rsp
  8043a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8043aa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043ae:	48 89 c7             	mov    %rax,%rdi
  8043b1:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  8043b8:	00 00 00 
  8043bb:	ff d0                	callq  *%rax
  8043bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043c4:	78 26                	js     8043ec <alloc_sockfd+0x4d>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8043c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ca:	ba 07 04 00 00       	mov    $0x407,%edx
  8043cf:	48 89 c6             	mov    %rax,%rsi
  8043d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8043d7:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  8043de:	00 00 00 
  8043e1:	ff d0                	callq  *%rax
  8043e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ea:	79 16                	jns    804402 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8043ec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043ef:	89 c7                	mov    %eax,%edi
  8043f1:	48 b8 ac 48 80 00 00 	movabs $0x8048ac,%rax
  8043f8:	00 00 00 
  8043fb:	ff d0                	callq  *%rax
		return r;
  8043fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804400:	eb 3a                	jmp    80443c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804402:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804406:	48 ba c0 80 80 00 00 	movabs $0x8080c0,%rdx
  80440d:	00 00 00 
  804410:	8b 12                	mov    (%rdx),%edx
  804412:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804418:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80441f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804423:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804426:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  804429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80442d:	48 89 c7             	mov    %rax,%rdi
  804430:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  804437:	00 00 00 
  80443a:	ff d0                	callq  *%rax
}
  80443c:	c9                   	leaveq 
  80443d:	c3                   	retq   

000000000080443e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80443e:	55                   	push   %rbp
  80443f:	48 89 e5             	mov    %rsp,%rbp
  804442:	48 83 ec 30          	sub    $0x30,%rsp
  804446:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804449:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80444d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804451:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804454:	89 c7                	mov    %eax,%edi
  804456:	48 b8 48 43 80 00 00 	movabs $0x804348,%rax
  80445d:	00 00 00 
  804460:	ff d0                	callq  *%rax
  804462:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804465:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804469:	79 05                	jns    804470 <accept+0x32>
		return r;
  80446b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80446e:	eb 3b                	jmp    8044ab <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804470:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804474:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804478:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447b:	48 89 ce             	mov    %rcx,%rsi
  80447e:	89 c7                	mov    %eax,%edi
  804480:	48 b8 89 47 80 00 00 	movabs $0x804789,%rax
  804487:	00 00 00 
  80448a:	ff d0                	callq  *%rax
  80448c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80448f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804493:	79 05                	jns    80449a <accept+0x5c>
		return r;
  804495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804498:	eb 11                	jmp    8044ab <accept+0x6d>
	return alloc_sockfd(r);
  80449a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80449d:	89 c7                	mov    %eax,%edi
  80449f:	48 b8 9f 43 80 00 00 	movabs $0x80439f,%rax
  8044a6:	00 00 00 
  8044a9:	ff d0                	callq  *%rax
}
  8044ab:	c9                   	leaveq 
  8044ac:	c3                   	retq   

00000000008044ad <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8044ad:	55                   	push   %rbp
  8044ae:	48 89 e5             	mov    %rsp,%rbp
  8044b1:	48 83 ec 20          	sub    $0x20,%rsp
  8044b5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8044b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044bc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8044bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044c2:	89 c7                	mov    %eax,%edi
  8044c4:	48 b8 48 43 80 00 00 	movabs $0x804348,%rax
  8044cb:	00 00 00 
  8044ce:	ff d0                	callq  *%rax
  8044d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044d7:	79 05                	jns    8044de <bind+0x31>
		return r;
  8044d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044dc:	eb 1b                	jmp    8044f9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8044de:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8044e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8044e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e8:	48 89 ce             	mov    %rcx,%rsi
  8044eb:	89 c7                	mov    %eax,%edi
  8044ed:	48 b8 08 48 80 00 00 	movabs $0x804808,%rax
  8044f4:	00 00 00 
  8044f7:	ff d0                	callq  *%rax
}
  8044f9:	c9                   	leaveq 
  8044fa:	c3                   	retq   

00000000008044fb <shutdown>:

int
shutdown(int s, int how)
{
  8044fb:	55                   	push   %rbp
  8044fc:	48 89 e5             	mov    %rsp,%rbp
  8044ff:	48 83 ec 20          	sub    $0x20,%rsp
  804503:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804506:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804509:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80450c:	89 c7                	mov    %eax,%edi
  80450e:	48 b8 48 43 80 00 00 	movabs $0x804348,%rax
  804515:	00 00 00 
  804518:	ff d0                	callq  *%rax
  80451a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80451d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804521:	79 05                	jns    804528 <shutdown+0x2d>
		return r;
  804523:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804526:	eb 16                	jmp    80453e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804528:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80452b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80452e:	89 d6                	mov    %edx,%esi
  804530:	89 c7                	mov    %eax,%edi
  804532:	48 b8 6c 48 80 00 00 	movabs $0x80486c,%rax
  804539:	00 00 00 
  80453c:	ff d0                	callq  *%rax
}
  80453e:	c9                   	leaveq 
  80453f:	c3                   	retq   

0000000000804540 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804540:	55                   	push   %rbp
  804541:	48 89 e5             	mov    %rsp,%rbp
  804544:	48 83 ec 10          	sub    $0x10,%rsp
  804548:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80454c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804550:	48 89 c7             	mov    %rax,%rdi
  804553:	48 b8 18 55 80 00 00 	movabs $0x805518,%rax
  80455a:	00 00 00 
  80455d:	ff d0                	callq  *%rax
  80455f:	83 f8 01             	cmp    $0x1,%eax
  804562:	75 17                	jne    80457b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804564:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804568:	8b 40 0c             	mov    0xc(%rax),%eax
  80456b:	89 c7                	mov    %eax,%edi
  80456d:	48 b8 ac 48 80 00 00 	movabs $0x8048ac,%rax
  804574:	00 00 00 
  804577:	ff d0                	callq  *%rax
  804579:	eb 05                	jmp    804580 <devsock_close+0x40>
	else
		return 0;
  80457b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804580:	c9                   	leaveq 
  804581:	c3                   	retq   

0000000000804582 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804582:	55                   	push   %rbp
  804583:	48 89 e5             	mov    %rsp,%rbp
  804586:	48 83 ec 20          	sub    $0x20,%rsp
  80458a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80458d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804591:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804594:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804597:	89 c7                	mov    %eax,%edi
  804599:	48 b8 48 43 80 00 00 	movabs $0x804348,%rax
  8045a0:	00 00 00 
  8045a3:	ff d0                	callq  *%rax
  8045a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045ac:	79 05                	jns    8045b3 <connect+0x31>
		return r;
  8045ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b1:	eb 1b                	jmp    8045ce <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8045b3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8045b6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8045ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045bd:	48 89 ce             	mov    %rcx,%rsi
  8045c0:	89 c7                	mov    %eax,%edi
  8045c2:	48 b8 d9 48 80 00 00 	movabs $0x8048d9,%rax
  8045c9:	00 00 00 
  8045cc:	ff d0                	callq  *%rax
}
  8045ce:	c9                   	leaveq 
  8045cf:	c3                   	retq   

00000000008045d0 <listen>:

int
listen(int s, int backlog)
{
  8045d0:	55                   	push   %rbp
  8045d1:	48 89 e5             	mov    %rsp,%rbp
  8045d4:	48 83 ec 20          	sub    $0x20,%rsp
  8045d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045db:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8045de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045e1:	89 c7                	mov    %eax,%edi
  8045e3:	48 b8 48 43 80 00 00 	movabs $0x804348,%rax
  8045ea:	00 00 00 
  8045ed:	ff d0                	callq  *%rax
  8045ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f6:	79 05                	jns    8045fd <listen+0x2d>
		return r;
  8045f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fb:	eb 16                	jmp    804613 <listen+0x43>
	return nsipc_listen(r, backlog);
  8045fd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804600:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804603:	89 d6                	mov    %edx,%esi
  804605:	89 c7                	mov    %eax,%edi
  804607:	48 b8 3d 49 80 00 00 	movabs $0x80493d,%rax
  80460e:	00 00 00 
  804611:	ff d0                	callq  *%rax
}
  804613:	c9                   	leaveq 
  804614:	c3                   	retq   

0000000000804615 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804615:	55                   	push   %rbp
  804616:	48 89 e5             	mov    %rsp,%rbp
  804619:	48 83 ec 20          	sub    $0x20,%rsp
  80461d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804621:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804625:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80462d:	89 c2                	mov    %eax,%edx
  80462f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804633:	8b 40 0c             	mov    0xc(%rax),%eax
  804636:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80463a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80463f:	89 c7                	mov    %eax,%edi
  804641:	48 b8 7d 49 80 00 00 	movabs $0x80497d,%rax
  804648:	00 00 00 
  80464b:	ff d0                	callq  *%rax
}
  80464d:	c9                   	leaveq 
  80464e:	c3                   	retq   

000000000080464f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80464f:	55                   	push   %rbp
  804650:	48 89 e5             	mov    %rsp,%rbp
  804653:	48 83 ec 20          	sub    $0x20,%rsp
  804657:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80465b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80465f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804667:	89 c2                	mov    %eax,%edx
  804669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80466d:	8b 40 0c             	mov    0xc(%rax),%eax
  804670:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804674:	b9 00 00 00 00       	mov    $0x0,%ecx
  804679:	89 c7                	mov    %eax,%edi
  80467b:	48 b8 49 4a 80 00 00 	movabs $0x804a49,%rax
  804682:	00 00 00 
  804685:	ff d0                	callq  *%rax
}
  804687:	c9                   	leaveq 
  804688:	c3                   	retq   

0000000000804689 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  804689:	55                   	push   %rbp
  80468a:	48 89 e5             	mov    %rsp,%rbp
  80468d:	48 83 ec 10          	sub    $0x10,%rsp
  804691:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804695:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  804699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80469d:	48 be 7c 5f 80 00 00 	movabs $0x805f7c,%rsi
  8046a4:	00 00 00 
  8046a7:	48 89 c7             	mov    %rax,%rdi
  8046aa:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  8046b1:	00 00 00 
  8046b4:	ff d0                	callq  *%rax
	return 0;
  8046b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046bb:	c9                   	leaveq 
  8046bc:	c3                   	retq   

00000000008046bd <socket>:

int
socket(int domain, int type, int protocol)
{
  8046bd:	55                   	push   %rbp
  8046be:	48 89 e5             	mov    %rsp,%rbp
  8046c1:	48 83 ec 20          	sub    $0x20,%rsp
  8046c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8046c8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8046cb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8046ce:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8046d1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8046d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046d7:	89 ce                	mov    %ecx,%esi
  8046d9:	89 c7                	mov    %eax,%edi
  8046db:	48 b8 01 4b 80 00 00 	movabs $0x804b01,%rax
  8046e2:	00 00 00 
  8046e5:	ff d0                	callq  *%rax
  8046e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ee:	79 05                	jns    8046f5 <socket+0x38>
		return r;
  8046f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f3:	eb 11                	jmp    804706 <socket+0x49>
	return alloc_sockfd(r);
  8046f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f8:	89 c7                	mov    %eax,%edi
  8046fa:	48 b8 9f 43 80 00 00 	movabs $0x80439f,%rax
  804701:	00 00 00 
  804704:	ff d0                	callq  *%rax
}
  804706:	c9                   	leaveq 
  804707:	c3                   	retq   

0000000000804708 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804708:	55                   	push   %rbp
  804709:	48 89 e5             	mov    %rsp,%rbp
  80470c:	48 83 ec 10          	sub    $0x10,%rsp
  804710:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804713:	48 b8 38 90 80 00 00 	movabs $0x809038,%rax
  80471a:	00 00 00 
  80471d:	8b 00                	mov    (%rax),%eax
  80471f:	85 c0                	test   %eax,%eax
  804721:	75 1d                	jne    804740 <nsipc+0x38>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804723:	bf 02 00 00 00       	mov    $0x2,%edi
  804728:	48 b8 93 54 80 00 00 	movabs $0x805493,%rax
  80472f:	00 00 00 
  804732:	ff d0                	callq  *%rax
  804734:	48 ba 38 90 80 00 00 	movabs $0x809038,%rdx
  80473b:	00 00 00 
  80473e:	89 02                	mov    %eax,(%rdx)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804740:	48 b8 38 90 80 00 00 	movabs $0x809038,%rax
  804747:	00 00 00 
  80474a:	8b 00                	mov    (%rax),%eax
  80474c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80474f:	b9 07 00 00 00       	mov    $0x7,%ecx
  804754:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80475b:	00 00 00 
  80475e:	89 c7                	mov    %eax,%edi
  804760:	48 b8 d0 53 80 00 00 	movabs $0x8053d0,%rax
  804767:	00 00 00 
  80476a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80476c:	ba 00 00 00 00       	mov    $0x0,%edx
  804771:	be 00 00 00 00       	mov    $0x0,%esi
  804776:	bf 00 00 00 00       	mov    $0x0,%edi
  80477b:	48 b8 10 53 80 00 00 	movabs $0x805310,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
}
  804787:	c9                   	leaveq 
  804788:	c3                   	retq   

0000000000804789 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804789:	55                   	push   %rbp
  80478a:	48 89 e5             	mov    %rsp,%rbp
  80478d:	48 83 ec 30          	sub    $0x30,%rsp
  804791:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804794:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804798:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80479c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047a3:	00 00 00 
  8047a6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8047a9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8047ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8047b0:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  8047b7:	00 00 00 
  8047ba:	ff d0                	callq  *%rax
  8047bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047c3:	78 3e                	js     804803 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8047c5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8047cc:	00 00 00 
  8047cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8047d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d7:	8b 40 10             	mov    0x10(%rax),%eax
  8047da:	89 c2                	mov    %eax,%edx
  8047dc:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8047e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047e4:	48 89 ce             	mov    %rcx,%rsi
  8047e7:	48 89 c7             	mov    %rax,%rdi
  8047ea:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  8047f1:	00 00 00 
  8047f4:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8047f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047fa:	8b 50 10             	mov    0x10(%rax),%edx
  8047fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804801:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804803:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804806:	c9                   	leaveq 
  804807:	c3                   	retq   

0000000000804808 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804808:	55                   	push   %rbp
  804809:	48 89 e5             	mov    %rsp,%rbp
  80480c:	48 83 ec 10          	sub    $0x10,%rsp
  804810:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804813:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804817:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80481a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804821:	00 00 00 
  804824:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804827:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804829:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80482c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804830:	48 89 c6             	mov    %rax,%rsi
  804833:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80483a:	00 00 00 
  80483d:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  804844:	00 00 00 
  804847:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804849:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804850:	00 00 00 
  804853:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804856:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804859:	bf 02 00 00 00       	mov    $0x2,%edi
  80485e:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  804865:	00 00 00 
  804868:	ff d0                	callq  *%rax
}
  80486a:	c9                   	leaveq 
  80486b:	c3                   	retq   

000000000080486c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80486c:	55                   	push   %rbp
  80486d:	48 89 e5             	mov    %rsp,%rbp
  804870:	48 83 ec 10          	sub    $0x10,%rsp
  804874:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804877:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80487a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804881:	00 00 00 
  804884:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804887:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804889:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804890:	00 00 00 
  804893:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804896:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804899:	bf 03 00 00 00       	mov    $0x3,%edi
  80489e:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  8048a5:	00 00 00 
  8048a8:	ff d0                	callq  *%rax
}
  8048aa:	c9                   	leaveq 
  8048ab:	c3                   	retq   

00000000008048ac <nsipc_close>:

int
nsipc_close(int s)
{
  8048ac:	55                   	push   %rbp
  8048ad:	48 89 e5             	mov    %rsp,%rbp
  8048b0:	48 83 ec 10          	sub    $0x10,%rsp
  8048b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8048b7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048be:	00 00 00 
  8048c1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8048c4:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8048c6:	bf 04 00 00 00       	mov    $0x4,%edi
  8048cb:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  8048d2:	00 00 00 
  8048d5:	ff d0                	callq  *%rax
}
  8048d7:	c9                   	leaveq 
  8048d8:	c3                   	retq   

00000000008048d9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8048d9:	55                   	push   %rbp
  8048da:	48 89 e5             	mov    %rsp,%rbp
  8048dd:	48 83 ec 10          	sub    $0x10,%rsp
  8048e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8048e8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8048eb:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8048f2:	00 00 00 
  8048f5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8048f8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8048fa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8048fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804901:	48 89 c6             	mov    %rax,%rsi
  804904:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80490b:	00 00 00 
  80490e:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  804915:	00 00 00 
  804918:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80491a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804921:	00 00 00 
  804924:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804927:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80492a:	bf 05 00 00 00       	mov    $0x5,%edi
  80492f:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  804936:	00 00 00 
  804939:	ff d0                	callq  *%rax
}
  80493b:	c9                   	leaveq 
  80493c:	c3                   	retq   

000000000080493d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80493d:	55                   	push   %rbp
  80493e:	48 89 e5             	mov    %rsp,%rbp
  804941:	48 83 ec 10          	sub    $0x10,%rsp
  804945:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804948:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80494b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804952:	00 00 00 
  804955:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804958:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80495a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804961:	00 00 00 
  804964:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804967:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80496a:	bf 06 00 00 00       	mov    $0x6,%edi
  80496f:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  804976:	00 00 00 
  804979:	ff d0                	callq  *%rax
}
  80497b:	c9                   	leaveq 
  80497c:	c3                   	retq   

000000000080497d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80497d:	55                   	push   %rbp
  80497e:	48 89 e5             	mov    %rsp,%rbp
  804981:	48 83 ec 30          	sub    $0x30,%rsp
  804985:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804988:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80498c:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80498f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804992:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804999:	00 00 00 
  80499c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80499f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8049a1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049a8:	00 00 00 
  8049ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8049ae:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8049b1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8049b8:	00 00 00 
  8049bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8049be:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8049c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8049c6:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  8049cd:	00 00 00 
  8049d0:	ff d0                	callq  *%rax
  8049d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049d9:	78 69                	js     804a44 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8049db:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8049e2:	7f 08                	jg     8049ec <nsipc_recv+0x6f>
  8049e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049e7:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8049ea:	7e 35                	jle    804a21 <nsipc_recv+0xa4>
  8049ec:	48 b9 83 5f 80 00 00 	movabs $0x805f83,%rcx
  8049f3:	00 00 00 
  8049f6:	48 ba 98 5f 80 00 00 	movabs $0x805f98,%rdx
  8049fd:	00 00 00 
  804a00:	be 61 00 00 00       	mov    $0x61,%esi
  804a05:	48 bf ad 5f 80 00 00 	movabs $0x805fad,%rdi
  804a0c:	00 00 00 
  804a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a14:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  804a1b:	00 00 00 
  804a1e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a24:	48 63 d0             	movslq %eax,%rdx
  804a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a2b:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804a32:	00 00 00 
  804a35:	48 89 c7             	mov    %rax,%rdi
  804a38:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  804a3f:	00 00 00 
  804a42:	ff d0                	callq  *%rax
	}

	return r;
  804a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a47:	c9                   	leaveq 
  804a48:	c3                   	retq   

0000000000804a49 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804a49:	55                   	push   %rbp
  804a4a:	48 89 e5             	mov    %rsp,%rbp
  804a4d:	48 83 ec 20          	sub    $0x20,%rsp
  804a51:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a54:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a58:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804a5b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804a5e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804a65:	00 00 00 
  804a68:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804a6b:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804a6d:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804a74:	7e 35                	jle    804aab <nsipc_send+0x62>
  804a76:	48 b9 b9 5f 80 00 00 	movabs $0x805fb9,%rcx
  804a7d:	00 00 00 
  804a80:	48 ba 98 5f 80 00 00 	movabs $0x805f98,%rdx
  804a87:	00 00 00 
  804a8a:	be 6c 00 00 00       	mov    $0x6c,%esi
  804a8f:	48 bf ad 5f 80 00 00 	movabs $0x805fad,%rdi
  804a96:	00 00 00 
  804a99:	b8 00 00 00 00       	mov    $0x0,%eax
  804a9e:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  804aa5:	00 00 00 
  804aa8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804aab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804aae:	48 63 d0             	movslq %eax,%rdx
  804ab1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ab5:	48 89 c6             	mov    %rax,%rsi
  804ab8:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804abf:	00 00 00 
  804ac2:	48 b8 1a 1a 80 00 00 	movabs $0x801a1a,%rax
  804ac9:	00 00 00 
  804acc:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804ace:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ad5:	00 00 00 
  804ad8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804adb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804ade:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ae5:	00 00 00 
  804ae8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804aeb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804aee:	bf 08 00 00 00       	mov    $0x8,%edi
  804af3:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  804afa:	00 00 00 
  804afd:	ff d0                	callq  *%rax
}
  804aff:	c9                   	leaveq 
  804b00:	c3                   	retq   

0000000000804b01 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804b01:	55                   	push   %rbp
  804b02:	48 89 e5             	mov    %rsp,%rbp
  804b05:	48 83 ec 10          	sub    $0x10,%rsp
  804b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b0c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804b0f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804b12:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b19:	00 00 00 
  804b1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804b1f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804b21:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b28:	00 00 00 
  804b2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804b2e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804b31:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b38:	00 00 00 
  804b3b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804b3e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804b41:	bf 09 00 00 00       	mov    $0x9,%edi
  804b46:	48 b8 08 47 80 00 00 	movabs $0x804708,%rax
  804b4d:	00 00 00 
  804b50:	ff d0                	callq  *%rax
}
  804b52:	c9                   	leaveq 
  804b53:	c3                   	retq   

0000000000804b54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804b54:	55                   	push   %rbp
  804b55:	48 89 e5             	mov    %rsp,%rbp
  804b58:	53                   	push   %rbx
  804b59:	48 83 ec 38          	sub    $0x38,%rsp
  804b5d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804b61:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804b65:	48 89 c7             	mov    %rax,%rdi
  804b68:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  804b6f:	00 00 00 
  804b72:	ff d0                	callq  *%rax
  804b74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b7b:	0f 88 bf 01 00 00    	js     804d40 <pipe+0x1ec>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804b81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b85:	ba 07 04 00 00       	mov    $0x407,%edx
  804b8a:	48 89 c6             	mov    %rax,%rsi
  804b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  804b92:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804b99:	00 00 00 
  804b9c:	ff d0                	callq  *%rax
  804b9e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804ba1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804ba5:	0f 88 95 01 00 00    	js     804d40 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804bab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804baf:	48 89 c7             	mov    %rax,%rdi
  804bb2:	48 b8 82 2a 80 00 00 	movabs $0x802a82,%rax
  804bb9:	00 00 00 
  804bbc:	ff d0                	callq  *%rax
  804bbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804bc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bc5:	0f 88 5d 01 00 00    	js     804d28 <pipe+0x1d4>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804bcb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bcf:	ba 07 04 00 00       	mov    $0x407,%edx
  804bd4:	48 89 c6             	mov    %rax,%rsi
  804bd7:	bf 00 00 00 00       	mov    $0x0,%edi
  804bdc:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804be3:	00 00 00 
  804be6:	ff d0                	callq  *%rax
  804be8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bef:	0f 88 33 01 00 00    	js     804d28 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804bf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bf9:	48 89 c7             	mov    %rax,%rdi
  804bfc:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  804c03:	00 00 00 
  804c06:	ff d0                	callq  *%rax
  804c08:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804c0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c10:	ba 07 04 00 00       	mov    $0x407,%edx
  804c15:	48 89 c6             	mov    %rax,%rsi
  804c18:	bf 00 00 00 00       	mov    $0x0,%edi
  804c1d:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  804c24:	00 00 00 
  804c27:	ff d0                	callq  *%rax
  804c29:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804c2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804c30:	0f 88 d9 00 00 00    	js     804d0f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804c36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c3a:	48 89 c7             	mov    %rax,%rdi
  804c3d:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  804c44:	00 00 00 
  804c47:	ff d0                	callq  *%rax
  804c49:	48 89 c2             	mov    %rax,%rdx
  804c4c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c50:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804c56:	48 89 d1             	mov    %rdx,%rcx
  804c59:	ba 00 00 00 00       	mov    $0x0,%edx
  804c5e:	48 89 c6             	mov    %rax,%rsi
  804c61:	bf 00 00 00 00       	mov    $0x0,%edi
  804c66:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  804c6d:	00 00 00 
  804c70:	ff d0                	callq  *%rax
  804c72:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804c75:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804c79:	78 79                	js     804cf4 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804c7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c7f:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804c86:	00 00 00 
  804c89:	8b 12                	mov    (%rdx),%edx
  804c8b:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804c8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804c98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804c9c:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  804ca3:	00 00 00 
  804ca6:	8b 12                	mov    (%rdx),%edx
  804ca8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804caa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804cae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804cb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cb9:	48 89 c7             	mov    %rax,%rdi
  804cbc:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  804cc3:	00 00 00 
  804cc6:	ff d0                	callq  *%rax
  804cc8:	89 c2                	mov    %eax,%edx
  804cca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cce:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804cd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804cd4:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804cdc:	48 89 c7             	mov    %rax,%rdi
  804cdf:	48 b8 34 2a 80 00 00 	movabs $0x802a34,%rax
  804ce6:	00 00 00 
  804ce9:	ff d0                	callq  *%rax
  804ceb:	89 03                	mov    %eax,(%rbx)
	return 0;
  804ced:	b8 00 00 00 00       	mov    $0x0,%eax
  804cf2:	eb 4f                	jmp    804d43 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804cf4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

    err3:
	sys_page_unmap(0, va);
  804cf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cf9:	48 89 c6             	mov    %rax,%rsi
  804cfc:	bf 00 00 00 00       	mov    $0x0,%edi
  804d01:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  804d08:	00 00 00 
  804d0b:	ff d0                	callq  *%rax
  804d0d:	eb 01                	jmp    804d10 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804d0f:	90                   	nop
	return 0;

    err3:
	sys_page_unmap(0, va);
    err2:
	sys_page_unmap(0, fd1);
  804d10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d14:	48 89 c6             	mov    %rax,%rsi
  804d17:	bf 00 00 00 00       	mov    $0x0,%edi
  804d1c:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  804d23:	00 00 00 
  804d26:	ff d0                	callq  *%rax
    err1:
	sys_page_unmap(0, fd0);
  804d28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d2c:	48 89 c6             	mov    %rax,%rsi
  804d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  804d34:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  804d3b:	00 00 00 
  804d3e:	ff d0                	callq  *%rax
    err:
	return r;
  804d40:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804d43:	48 83 c4 38          	add    $0x38,%rsp
  804d47:	5b                   	pop    %rbx
  804d48:	5d                   	pop    %rbp
  804d49:	c3                   	retq   

0000000000804d4a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804d4a:	55                   	push   %rbp
  804d4b:	48 89 e5             	mov    %rsp,%rbp
  804d4e:	53                   	push   %rbx
  804d4f:	48 83 ec 28          	sub    $0x28,%rsp
  804d53:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804d57:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804d5b:	eb 01                	jmp    804d5e <_pipeisclosed+0x14>
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
  804d5d:	90                   	nop
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804d5e:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  804d65:	00 00 00 
  804d68:	48 8b 00             	mov    (%rax),%rax
  804d6b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804d71:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804d74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d78:	48 89 c7             	mov    %rax,%rdi
  804d7b:	48 b8 18 55 80 00 00 	movabs $0x805518,%rax
  804d82:	00 00 00 
  804d85:	ff d0                	callq  *%rax
  804d87:	89 c3                	mov    %eax,%ebx
  804d89:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804d8d:	48 89 c7             	mov    %rax,%rdi
  804d90:	48 b8 18 55 80 00 00 	movabs $0x805518,%rax
  804d97:	00 00 00 
  804d9a:	ff d0                	callq  *%rax
  804d9c:	39 c3                	cmp    %eax,%ebx
  804d9e:	0f 94 c0             	sete   %al
  804da1:	0f b6 c0             	movzbl %al,%eax
  804da4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804da7:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  804dae:	00 00 00 
  804db1:	48 8b 00             	mov    (%rax),%rax
  804db4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804dba:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804dbd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dc0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804dc3:	75 0a                	jne    804dcf <_pipeisclosed+0x85>
			return ret;
  804dc5:	8b 45 e8             	mov    -0x18(%rbp),%eax
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
	}
}
  804dc8:	48 83 c4 28          	add    $0x28,%rsp
  804dcc:	5b                   	pop    %rbx
  804dcd:	5d                   	pop    %rbp
  804dce:	c3                   	retq   
		n = thisenv->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = thisenv->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  804dcf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dd2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804dd5:	74 86                	je     804d5d <_pipeisclosed+0x13>
  804dd7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804ddb:	75 80                	jne    804d5d <_pipeisclosed+0x13>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804ddd:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  804de4:	00 00 00 
  804de7:	48 8b 00             	mov    (%rax),%rax
  804dea:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804df0:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804df3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804df6:	89 c6                	mov    %eax,%esi
  804df8:	48 bf ca 5f 80 00 00 	movabs $0x805fca,%rdi
  804dff:	00 00 00 
  804e02:	b8 00 00 00 00       	mov    $0x0,%eax
  804e07:	49 b8 3b 0b 80 00 00 	movabs $0x800b3b,%r8
  804e0e:	00 00 00 
  804e11:	41 ff d0             	callq  *%r8
	}
  804e14:	e9 44 ff ff ff       	jmpq   804d5d <_pipeisclosed+0x13>

0000000000804e19 <pipeisclosed>:
}

int
pipeisclosed(int fdnum)
{
  804e19:	55                   	push   %rbp
  804e1a:	48 89 e5             	mov    %rsp,%rbp
  804e1d:	48 83 ec 30          	sub    $0x30,%rsp
  804e21:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804e24:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804e28:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804e2b:	48 89 d6             	mov    %rdx,%rsi
  804e2e:	89 c7                	mov    %eax,%edi
  804e30:	48 b8 1a 2b 80 00 00 	movabs $0x802b1a,%rax
  804e37:	00 00 00 
  804e3a:	ff d0                	callq  *%rax
  804e3c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e3f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e43:	79 05                	jns    804e4a <pipeisclosed+0x31>
		return r;
  804e45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e48:	eb 31                	jmp    804e7b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804e4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e4e:	48 89 c7             	mov    %rax,%rdi
  804e51:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  804e58:	00 00 00 
  804e5b:	ff d0                	callq  *%rax
  804e5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804e61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e69:	48 89 d6             	mov    %rdx,%rsi
  804e6c:	48 89 c7             	mov    %rax,%rdi
  804e6f:	48 b8 4a 4d 80 00 00 	movabs $0x804d4a,%rax
  804e76:	00 00 00 
  804e79:	ff d0                	callq  *%rax
}
  804e7b:	c9                   	leaveq 
  804e7c:	c3                   	retq   

0000000000804e7d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804e7d:	55                   	push   %rbp
  804e7e:	48 89 e5             	mov    %rsp,%rbp
  804e81:	48 83 ec 40          	sub    $0x40,%rsp
  804e85:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804e89:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804e8d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804e91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e95:	48 89 c7             	mov    %rax,%rdi
  804e98:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  804e9f:	00 00 00 
  804ea2:	ff d0                	callq  *%rax
  804ea4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804ea8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804eac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804eb0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804eb7:	00 
  804eb8:	e9 97 00 00 00       	jmpq   804f54 <devpipe_read+0xd7>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804ebd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804ec2:	74 09                	je     804ecd <devpipe_read+0x50>
				return i;
  804ec4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ec8:	e9 95 00 00 00       	jmpq   804f62 <devpipe_read+0xe5>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804ecd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ed1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ed5:	48 89 d6             	mov    %rdx,%rsi
  804ed8:	48 89 c7             	mov    %rax,%rdi
  804edb:	48 b8 4a 4d 80 00 00 	movabs $0x804d4a,%rax
  804ee2:	00 00 00 
  804ee5:	ff d0                	callq  *%rax
  804ee7:	85 c0                	test   %eax,%eax
  804ee9:	74 07                	je     804ef2 <devpipe_read+0x75>
				return 0;
  804eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef0:	eb 70                	jmp    804f62 <devpipe_read+0xe5>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804ef2:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  804ef9:	00 00 00 
  804efc:	ff d0                	callq  *%rax
  804efe:	eb 01                	jmp    804f01 <devpipe_read+0x84>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804f00:	90                   	nop
  804f01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f05:	8b 10                	mov    (%rax),%edx
  804f07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f0b:	8b 40 04             	mov    0x4(%rax),%eax
  804f0e:	39 c2                	cmp    %eax,%edx
  804f10:	74 ab                	je     804ebd <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f16:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804f1a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804f1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f22:	8b 00                	mov    (%rax),%eax
  804f24:	89 c2                	mov    %eax,%edx
  804f26:	c1 fa 1f             	sar    $0x1f,%edx
  804f29:	c1 ea 1b             	shr    $0x1b,%edx
  804f2c:	01 d0                	add    %edx,%eax
  804f2e:	83 e0 1f             	and    $0x1f,%eax
  804f31:	29 d0                	sub    %edx,%eax
  804f33:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f37:	48 98                	cltq   
  804f39:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804f3e:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804f40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f44:	8b 00                	mov    (%rax),%eax
  804f46:	8d 50 01             	lea    0x1(%rax),%edx
  804f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f4d:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804f4f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f58:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804f5c:	72 a2                	jb     804f00 <devpipe_read+0x83>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804f5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804f62:	c9                   	leaveq 
  804f63:	c3                   	retq   

0000000000804f64 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804f64:	55                   	push   %rbp
  804f65:	48 89 e5             	mov    %rsp,%rbp
  804f68:	48 83 ec 40          	sub    $0x40,%rsp
  804f6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804f70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804f74:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804f78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804f7c:	48 89 c7             	mov    %rax,%rdi
  804f7f:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  804f86:	00 00 00 
  804f89:	ff d0                	callq  *%rax
  804f8b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804f8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804f93:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804f97:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804f9e:	00 
  804f9f:	e9 93 00 00 00       	jmpq   805037 <devpipe_write+0xd3>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804fa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804fac:	48 89 d6             	mov    %rdx,%rsi
  804faf:	48 89 c7             	mov    %rax,%rdi
  804fb2:	48 b8 4a 4d 80 00 00 	movabs $0x804d4a,%rax
  804fb9:	00 00 00 
  804fbc:	ff d0                	callq  *%rax
  804fbe:	85 c0                	test   %eax,%eax
  804fc0:	74 07                	je     804fc9 <devpipe_write+0x65>
				return 0;
  804fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  804fc7:	eb 7c                	jmp    805045 <devpipe_write+0xe1>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804fc9:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  804fd0:	00 00 00 
  804fd3:	ff d0                	callq  *%rax
  804fd5:	eb 01                	jmp    804fd8 <devpipe_write+0x74>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804fd7:	90                   	nop
  804fd8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fdc:	8b 40 04             	mov    0x4(%rax),%eax
  804fdf:	48 63 d0             	movslq %eax,%rdx
  804fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fe6:	8b 00                	mov    (%rax),%eax
  804fe8:	48 98                	cltq   
  804fea:	48 83 c0 20          	add    $0x20,%rax
  804fee:	48 39 c2             	cmp    %rax,%rdx
  804ff1:	73 b1                	jae    804fa4 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ff7:	8b 40 04             	mov    0x4(%rax),%eax
  804ffa:	89 c2                	mov    %eax,%edx
  804ffc:	c1 fa 1f             	sar    $0x1f,%edx
  804fff:	c1 ea 1b             	shr    $0x1b,%edx
  805002:	01 d0                	add    %edx,%eax
  805004:	83 e0 1f             	and    $0x1f,%eax
  805007:	29 d0                	sub    %edx,%eax
  805009:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80500d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805011:	48 01 ca             	add    %rcx,%rdx
  805014:	0f b6 0a             	movzbl (%rdx),%ecx
  805017:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80501b:	48 98                	cltq   
  80501d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  805021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805025:	8b 40 04             	mov    0x4(%rax),%eax
  805028:	8d 50 01             	lea    0x1(%rax),%edx
  80502b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80502f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  805032:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805037:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80503b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80503f:	72 96                	jb     804fd7 <devpipe_write+0x73>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  805041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  805045:	c9                   	leaveq 
  805046:	c3                   	retq   

0000000000805047 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  805047:	55                   	push   %rbp
  805048:	48 89 e5             	mov    %rsp,%rbp
  80504b:	48 83 ec 20          	sub    $0x20,%rsp
  80504f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805053:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  805057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80505b:	48 89 c7             	mov    %rax,%rdi
  80505e:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  805065:	00 00 00 
  805068:	ff d0                	callq  *%rax
  80506a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80506e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805072:	48 be dd 5f 80 00 00 	movabs $0x805fdd,%rsi
  805079:	00 00 00 
  80507c:	48 89 c7             	mov    %rax,%rdi
  80507f:	48 b8 f8 16 80 00 00 	movabs $0x8016f8,%rax
  805086:	00 00 00 
  805089:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80508b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80508f:	8b 50 04             	mov    0x4(%rax),%edx
  805092:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805096:	8b 00                	mov    (%rax),%eax
  805098:	29 c2                	sub    %eax,%edx
  80509a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80509e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8050a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8050a8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8050af:	00 00 00 
	stat->st_dev = &devpipe;
  8050b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8050b6:	48 ba 00 81 80 00 00 	movabs $0x808100,%rdx
  8050bd:	00 00 00 
  8050c0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return 0;
  8050c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8050cc:	c9                   	leaveq 
  8050cd:	c3                   	retq   

00000000008050ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8050ce:	55                   	push   %rbp
  8050cf:	48 89 e5             	mov    %rsp,%rbp
  8050d2:	48 83 ec 10          	sub    $0x10,%rsp
  8050d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8050da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050de:	48 89 c6             	mov    %rax,%rsi
  8050e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8050e6:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  8050ed:	00 00 00 
  8050f0:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8050f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8050f6:	48 89 c7             	mov    %rax,%rdi
  8050f9:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  805100:	00 00 00 
  805103:	ff d0                	callq  *%rax
  805105:	48 89 c6             	mov    %rax,%rsi
  805108:	bf 00 00 00 00       	mov    $0x0,%edi
  80510d:	48 b8 db 20 80 00 00 	movabs $0x8020db,%rax
  805114:	00 00 00 
  805117:	ff d0                	callq  *%rax
}
  805119:	c9                   	leaveq 
  80511a:	c3                   	retq   
	...

000000000080511c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80511c:	55                   	push   %rbp
  80511d:	48 89 e5             	mov    %rsp,%rbp
  805120:	48 83 ec 20          	sub    $0x20,%rsp
  805124:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  805127:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80512b:	75 35                	jne    805162 <wait+0x46>
  80512d:	48 b9 e4 5f 80 00 00 	movabs $0x805fe4,%rcx
  805134:	00 00 00 
  805137:	48 ba ef 5f 80 00 00 	movabs $0x805fef,%rdx
  80513e:	00 00 00 
  805141:	be 09 00 00 00       	mov    $0x9,%esi
  805146:	48 bf 04 60 80 00 00 	movabs $0x806004,%rdi
  80514d:	00 00 00 
  805150:	b8 00 00 00 00       	mov    $0x0,%eax
  805155:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  80515c:	00 00 00 
  80515f:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  805162:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805165:	48 98                	cltq   
  805167:	48 89 c2             	mov    %rax,%rdx
  80516a:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  805170:	48 89 d0             	mov    %rdx,%rax
  805173:	48 c1 e0 03          	shl    $0x3,%rax
  805177:	48 01 d0             	add    %rdx,%rax
  80517a:	48 c1 e0 05          	shl    $0x5,%rax
  80517e:	48 89 c2             	mov    %rax,%rdx
  805181:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805188:	00 00 00 
  80518b:	48 01 d0             	add    %rdx,%rax
  80518e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  805192:	eb 0c                	jmp    8051a0 <wait+0x84>
		sys_yield();
  805194:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  80519b:	00 00 00 
  80519e:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8051a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8051a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8051aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8051ad:	75 0e                	jne    8051bd <wait+0xa1>
  8051af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8051b3:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8051b9:	85 c0                	test   %eax,%eax
  8051bb:	75 d7                	jne    805194 <wait+0x78>
		sys_yield();
}
  8051bd:	c9                   	leaveq 
  8051be:	c3                   	retq   
	...

00000000008051c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8051c0:	55                   	push   %rbp
  8051c1:	48 89 e5             	mov    %rsp,%rbp
  8051c4:	48 83 ec 20          	sub    $0x20,%rsp
  8051c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r,res;

	if (_pgfault_handler == 0) {
  8051cc:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  8051d3:	00 00 00 
  8051d6:	48 8b 00             	mov    (%rax),%rax
  8051d9:	48 85 c0             	test   %rax,%rax
  8051dc:	0f 85 8e 00 00 00    	jne    805270 <set_pgfault_handler+0xb0>
		// First time through!
		// LAB 4: Your code here.
		void *ex_stack = (void *)(UXSTACKTOP - PGSIZE);
  8051e2:	c7 45 f8 00 f0 7f ef 	movl   $0xef7ff000,-0x8(%rbp)
  8051e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
		envid_t envid = sys_getenvid();
  8051f0:	48 b8 b4 1f 80 00 00 	movabs $0x801fb4,%rax
  8051f7:	00 00 00 
  8051fa:	ff d0                	callq  *%rax
  8051fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		res = sys_page_alloc(envid, ex_stack, PTE_P | PTE_U | PTE_W);
  8051ff:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  805203:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805206:	ba 07 00 00 00       	mov    $0x7,%edx
  80520b:	48 89 ce             	mov    %rcx,%rsi
  80520e:	89 c7                	mov    %eax,%edi
  805210:	48 b8 30 20 80 00 00 	movabs $0x802030,%rax
  805217:	00 00 00 
  80521a:	ff d0                	callq  *%rax
  80521c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if(res)
  80521f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  805223:	74 30                	je     805255 <set_pgfault_handler+0x95>
			panic("\nNo memory left to allocate for pgfault exception: %e\n", res);
  805225:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805228:	89 c1                	mov    %eax,%ecx
  80522a:	48 ba 10 60 80 00 00 	movabs $0x806010,%rdx
  805231:	00 00 00 
  805234:	be 24 00 00 00       	mov    $0x24,%esi
  805239:	48 bf 47 60 80 00 00 	movabs $0x806047,%rdi
  805240:	00 00 00 
  805243:	b8 00 00 00 00       	mov    $0x0,%eax
  805248:	49 b8 00 09 80 00 00 	movabs $0x800900,%r8
  80524f:	00 00 00 
  805252:	41 ff d0             	callq  *%r8

		sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  805255:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805258:	48 be 84 52 80 00 00 	movabs $0x805284,%rsi
  80525f:	00 00 00 
  805262:	89 c7                	mov    %eax,%edi
  805264:	48 b8 ba 21 80 00 00 	movabs $0x8021ba,%rax
  80526b:	00 00 00 
  80526e:	ff d0                	callq  *%rax
//		panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805270:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805277:	00 00 00 
  80527a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80527e:	48 89 10             	mov    %rdx,(%rax)
}
  805281:	c9                   	leaveq 
  805282:	c3                   	retq   
	...

0000000000805284 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  805284:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  805287:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  80528e:	00 00 00 
	call *%rax
  805291:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
		add $8, %rsp  					// For fault_va
  805293:	48 83 c4 08          	add    $0x8,%rsp
		add $8, %rsp 					// For error code
  805297:	48 83 c4 08          	add    $0x8,%rsp
		movq %rsp, %rax					// save the top of exception stack
  80529b:	48 89 e0             	mov    %rsp,%rax
		movq 136(%rsp), %rbx				// trap time rsp
  80529e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8052a5:	00 
		movq 120(%rsp), %rcx				// trap time rip
  8052a6:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
		movq %rbx, %rsp					// move to trap time rsp
  8052ab:	48 89 dc             	mov    %rbx,%rsp
		pushq %rcx					// push trap time rip to stack
  8052ae:	51                   	push   %rcx
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
		movq %rax, %rsp                                 // go back to the exception stack
  8052af:	48 89 c4             	mov    %rax,%rsp
		subq $8, 136(%rsp)  				// update this stack for the push we did
  8052b2:	48 83 ac 24 88 00 00 	subq   $0x8,0x88(%rsp)
  8052b9:	00 08 
		POPA_						// copy the register contents to the registers
  8052bb:	4c 8b 3c 24          	mov    (%rsp),%r15
  8052bf:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8052c4:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8052c9:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8052ce:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8052d3:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8052d8:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8052dd:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8052e2:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8052e7:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8052ec:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8052f1:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8052f6:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8052fb:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805300:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805305:	48 83 c4 78          	add    $0x78,%rsp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		add $8, %rsp					//skip to the eflags value in the stack
  805309:	48 83 c4 08          	add    $0x8,%rsp
		popfq						// pop that value from the stack
  80530d:	9d                   	popfq  
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		popq %rsp					// switch back to the trap time stack
  80530e:	5c                   	pop    %rsp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
		ret						//return back to the instruction that faulted
  80530f:	c3                   	retq   

0000000000805310 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805310:	55                   	push   %rbp
  805311:	48 89 e5             	mov    %rsp,%rbp
  805314:	48 83 ec 30          	sub    $0x30,%rsp
  805318:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80531c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805320:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	int r;
	if(pg!=NULL)
  805324:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805329:	74 18                	je     805343 <ipc_recv+0x33>
		r=sys_ipc_recv(pg);
  80532b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80532f:	48 89 c7             	mov    %rax,%rdi
  805332:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  805339:	00 00 00 
  80533c:	ff d0                	callq  *%rax
  80533e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805341:	eb 19                	jmp    80535c <ipc_recv+0x4c>
	else 
                r=sys_ipc_recv((void *)UTOP);
  805343:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80534a:	00 00 00 
  80534d:	48 b8 59 22 80 00 00 	movabs $0x802259,%rax
  805354:	00 00 00 
  805357:	ff d0                	callq  *%rax
  805359:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if(r<0)
  80535c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805360:	79 19                	jns    80537b <ipc_recv+0x6b>
	{
		*from_env_store=0;
  805362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805366:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		*perm_store=0;
  80536c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805370:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
                return r;
  805376:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805379:	eb 53                	jmp    8053ce <ipc_recv+0xbe>
	}
	if(from_env_store!=NULL)
  80537b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805380:	74 19                	je     80539b <ipc_recv+0x8b>
		*from_env_store=thisenv->env_ipc_from;
  805382:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  805389:	00 00 00 
  80538c:	48 8b 00             	mov    (%rax),%rax
  80538f:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805399:	89 10                	mov    %edx,(%rax)
	if(perm_store!=NULL)
  80539b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8053a0:	74 19                	je     8053bb <ipc_recv+0xab>
		*perm_store=thisenv->env_ipc_perm;
  8053a2:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  8053a9:	00 00 00 
  8053ac:	48 8b 00             	mov    (%rax),%rax
  8053af:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8053b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053b9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8053bb:	48 b8 50 90 80 00 00 	movabs $0x809050,%rax
  8053c2:	00 00 00 
  8053c5:	48 8b 00             	mov    (%rax),%rax
  8053c8:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
}
  8053ce:	c9                   	leaveq 
  8053cf:	c3                   	retq   

00000000008053d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8053d0:	55                   	push   %rbp
  8053d1:	48 89 e5             	mov    %rsp,%rbp
  8053d4:	48 83 ec 30          	sub    $0x30,%rsp
  8053d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8053db:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8053de:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8053e2:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r=1;
  8053e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
	while(r!=0)
  8053ec:	e9 96 00 00 00       	jmpq   805487 <ipc_send+0xb7>
	{
		if(pg!=NULL)
  8053f1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8053f6:	74 20                	je     805418 <ipc_send+0x48>
			r=sys_ipc_try_send(to_env,val,pg,perm);
  8053f8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8053fb:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8053fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805402:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805405:	89 c7                	mov    %eax,%edi
  805407:	48 b8 04 22 80 00 00 	movabs $0x802204,%rax
  80540e:	00 00 00 
  805411:	ff d0                	callq  *%rax
  805413:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805416:	eb 2d                	jmp    805445 <ipc_send+0x75>
		else if(pg==NULL)
  805418:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80541d:	75 26                	jne    805445 <ipc_send+0x75>
			r=sys_ipc_try_send(to_env,val,(void *)UTOP,0);
  80541f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805422:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805425:	b9 00 00 00 00       	mov    $0x0,%ecx
  80542a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805431:	00 00 00 
  805434:	89 c7                	mov    %eax,%edi
  805436:	48 b8 04 22 80 00 00 	movabs $0x802204,%rax
  80543d:	00 00 00 
  805440:	ff d0                	callq  *%rax
  805442:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if(r<0 && r!= -E_IPC_NOT_RECV)
  805445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805449:	79 30                	jns    80547b <ipc_send+0xab>
  80544b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80544f:	74 2a                	je     80547b <ipc_send+0xab>
		{
			panic("panic in ipc_send:%e\n,r");
  805451:	48 ba 55 60 80 00 00 	movabs $0x806055,%rdx
  805458:	00 00 00 
  80545b:	be 40 00 00 00       	mov    $0x40,%esi
  805460:	48 bf 6d 60 80 00 00 	movabs $0x80606d,%rdi
  805467:	00 00 00 
  80546a:	b8 00 00 00 00       	mov    $0x0,%eax
  80546f:	48 b9 00 09 80 00 00 	movabs $0x800900,%rcx
  805476:	00 00 00 
  805479:	ff d1                	callq  *%rcx
		}
		sys_yield();
  80547b:	48 b8 f2 1f 80 00 00 	movabs $0x801ff2,%rax
  805482:	00 00 00 
  805485:	ff d0                	callq  *%rax
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int r=1;
	while(r!=0)
  805487:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80548b:	0f 85 60 ff ff ff    	jne    8053f1 <ipc_send+0x21>
		{
			panic("panic in ipc_send:%e\n,r");
		}
		sys_yield();
	}
}
  805491:	c9                   	leaveq 
  805492:	c3                   	retq   

0000000000805493 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  805493:	55                   	push   %rbp
  805494:	48 89 e5             	mov    %rsp,%rbp
  805497:	48 83 ec 18          	sub    $0x18,%rsp
  80549b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  80549e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8054a5:	eb 5e                	jmp    805505 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8054a7:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8054ae:	00 00 00 
  8054b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b4:	48 63 d0             	movslq %eax,%rdx
  8054b7:	48 89 d0             	mov    %rdx,%rax
  8054ba:	48 c1 e0 03          	shl    $0x3,%rax
  8054be:	48 01 d0             	add    %rdx,%rax
  8054c1:	48 c1 e0 05          	shl    $0x5,%rax
  8054c5:	48 01 c8             	add    %rcx,%rax
  8054c8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8054ce:	8b 00                	mov    (%rax),%eax
  8054d0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8054d3:	75 2c                	jne    805501 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8054d5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8054dc:	00 00 00 
  8054df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e2:	48 63 d0             	movslq %eax,%rdx
  8054e5:	48 89 d0             	mov    %rdx,%rax
  8054e8:	48 c1 e0 03          	shl    $0x3,%rax
  8054ec:	48 01 d0             	add    %rdx,%rax
  8054ef:	48 c1 e0 05          	shl    $0x5,%rax
  8054f3:	48 01 c8             	add    %rcx,%rax
  8054f6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8054fc:	8b 40 08             	mov    0x8(%rax),%eax
  8054ff:	eb 12                	jmp    805513 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  805501:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805505:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80550c:	7e 99                	jle    8054a7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80550e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805513:	c9                   	leaveq 
  805514:	c3                   	retq   
  805515:	00 00                	add    %al,(%rax)
	...

0000000000805518 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  805518:	55                   	push   %rbp
  805519:	48 89 e5             	mov    %rsp,%rbp
  80551c:	48 83 ec 18          	sub    $0x18,%rsp
  805520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805524:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805528:	48 89 c2             	mov    %rax,%rdx
  80552b:	48 c1 ea 15          	shr    $0x15,%rdx
  80552f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805536:	01 00 00 
  805539:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80553d:	83 e0 01             	and    $0x1,%eax
  805540:	48 85 c0             	test   %rax,%rax
  805543:	75 07                	jne    80554c <pageref+0x34>
		return 0;
  805545:	b8 00 00 00 00       	mov    $0x0,%eax
  80554a:	eb 53                	jmp    80559f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80554c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805550:	48 89 c2             	mov    %rax,%rdx
  805553:	48 c1 ea 0c          	shr    $0xc,%rdx
  805557:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80555e:	01 00 00 
  805561:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805565:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80556d:	83 e0 01             	and    $0x1,%eax
  805570:	48 85 c0             	test   %rax,%rax
  805573:	75 07                	jne    80557c <pageref+0x64>
		return 0;
  805575:	b8 00 00 00 00       	mov    $0x0,%eax
  80557a:	eb 23                	jmp    80559f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80557c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805580:	48 89 c2             	mov    %rax,%rdx
  805583:	48 c1 ea 0c          	shr    $0xc,%rdx
  805587:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80558e:	00 00 00 
  805591:	48 c1 e2 04          	shl    $0x4,%rdx
  805595:	48 01 d0             	add    %rdx,%rax
  805598:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80559c:	0f b7 c0             	movzwl %ax,%eax
}
  80559f:	c9                   	leaveq 
  8055a0:	c3                   	retq   
